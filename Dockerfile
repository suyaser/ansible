FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 suyaser
RUN adduser --gecos suyaser --uid 1000 --gid 1000 --disabled-password suyaser
USER suyaser
WORKDIR /home/suyaser

FROM prime
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

