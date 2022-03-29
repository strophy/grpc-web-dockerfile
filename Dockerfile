# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM node:16-bullseye

ARG PROTOBUF_VERSION=3.19.4
ARG GRPC_WEB_VERSION=1.3.2
ARG TARGETARCH

RUN apt-get -qq update && apt-get -qq install -y \
  unzip

WORKDIR /tmp

RUN case $TARGETARCH in arm64) arch="aarch_64"; ;; amd64) arch="x86_64"; ;; *) echo "ERROR: Machine type $TARGETARCH not supported."; ;; esac && \
curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/\
protoc-$PROTOBUF_VERSION-linux-$arch.zip -o protoc.zip && \
  unzip -qq protoc.zip && \
  cp ./bin/protoc /usr/local/bin/protoc

RUN case $TARGETARCH in arm64) arch="arm64"; ;; amd64) arch="x86_64"; ;; *) echo "ERROR: Machine type $TARGETARCH not supported."; ;; esac && \
curl -L https://github.com/strophy/grpc-web/releases/download/$GRPC_WEB_VERSION/\
protoc-gen-grpc-web-$GRPC_WEB_VERSION-linux-$arch -o /usr/local/bin/protoc-gen-grpc-web && \
  chmod +x /usr/local/bin/protoc-gen-grpc-web

WORKDIR /var/www/html/dist

WORKDIR /github/grpc-web

RUN git clone https://github.com/grpc/grpc-web .
