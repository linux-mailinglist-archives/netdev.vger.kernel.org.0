Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C1C5890B7
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiHCQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiHCQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:41:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB0840BD3;
        Wed,  3 Aug 2022 09:41:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w10so16930316plq.0;
        Wed, 03 Aug 2022 09:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=PagpYLBKMzBgTY2+VszOhttVW5lcLb7OhK9zW5hxXPM=;
        b=fJ6DvZ3Gr8MbyMNwohEqYThd52JIYRvk48Xv3/rnv8zcLt6OLsp2WTMh4hf0bobX/V
         NZVnsEorlaxKf4KHEpxm4v9r7Wtrf9FXtDrfsI7xVNjrzSNTwkSP/zA9JnspkfkF59Is
         Lao8adYVwVfcoAcLi/vxCNdZtWi32Ve0U2rmEM3rQ3gy9BnCWhVDuzd+kiUxVQJWaTN8
         7X5yMy0D1x51DfYv3cBIP3oTVDwfLbVeKImpTnJQNLZItztJ+YLGqxKfAg4evECPzkg6
         YNYPDptVkwrp4pyul+uP4LjtCDuQ4AOm9kKoMrPhmSppqxPyyXkJpDYCLUI5puwd5H91
         kfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=PagpYLBKMzBgTY2+VszOhttVW5lcLb7OhK9zW5hxXPM=;
        b=mV8uqNUfwPG4Ahu8BqDik1c6ofemwKDc1rz+KZ9+6YZQTViPJSBKELjldsysnpjlj/
         7mvXmisvE/mmxFId8gL6kYSrZLLhLbPdqmySKaQwdIbzSaEga9RUL9Uy5Bw2T5FVlIa1
         PU3vsrydyDJzk8IY9OAFH7Z2pxFIg91ciTUfKF9lggYMds/C/3BsVZPDzhQWNNM2kNLS
         TMBrOP6+6G9qS/iB/jhEe4r0urClC1pIghJGJbfByREpzzZ3ms7Usge1tZQvmH5qVewd
         uhoL00ViTQtwkXZeBd3FPIuR+oIITXZ29u6GGiWR0C1+/GCEGksED40iUijJNJ6dVbtB
         OkdQ==
X-Gm-Message-State: ACgBeo3gUYkPHGc8/7jQmlU9HQBsCMK8tm4kq+JhPkE4XO+g1DtxuAcn
        CLBENiK2nU9P2GIHpclUomc=
X-Google-Smtp-Source: AA6agR51dHijpODZzth8zzV6k1eeSaCIsJbJ7Nk4Yk1psIm0t8eQIf7pRYaxR90AVCFPE6zqZstWVQ==
X-Received: by 2002:a17:902:c24c:b0:16d:d5d4:aa84 with SMTP id 12-20020a170902c24c00b0016dd5d4aa84mr24733003plg.36.1659544861483;
        Wed, 03 Aug 2022 09:41:01 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id l15-20020a654c4f000000b003db7de758besm11441190pgr.5.2022.08.03.09.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:41:01 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 6/6] net: Add self tests for ULP operations, flow setup and crypto tests
Date:   Wed,  3 Aug 2022 09:40:45 -0700
Message-Id: <20220803164045.3585187-7-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803164045.3585187-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add self tests for ULP operations, flow setup and crypto tests.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
---
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    2 +-
 tools/testing/selftests/net/quic.c     | 1024 ++++++++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   45 ++
 4 files changed, 1071 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/quic.c
 create mode 100755 tools/testing/selftests/net/quic.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index ffc35a22e914..bd4967e57803 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -38,3 +38,4 @@ ioam6_parser
 toeplitz
 tun
 cmsg_sender
+quic
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index db05b3764b77..aee89b0458b4 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -54,7 +54,7 @@ TEST_GEN_FILES += ipsec
 TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
-TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun
+TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun quic
 TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
diff --git a/tools/testing/selftests/net/quic.c b/tools/testing/selftests/net/quic.c
new file mode 100644
index 000000000000..20e425003fcb
--- /dev/null
+++ b/tools/testing/selftests/net/quic.c
@@ -0,0 +1,1024 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <linux/limits.h>
+#include <linux/quic.h>
+#include <linux/socket.h>
+#include <linux/tls.h>
+#include <linux/tcp.h>
+#include <linux/types.h>
+#include <linux/udp.h>
+
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/sendfile.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+
+#include "../kselftest_harness.h"
+
+#define UDP_ULP		105
+
+#ifndef SOL_UDP
+#define SOL_UDP		17
+#endif
+
+// 1. QUIC ULP Registration Test
+
+FIXTURE(quic_ulp)
+{
+	int sfd;
+	socklen_t len_s;
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} server;
+	int default_net_ns_fd;
+	int server_net_ns_fd;
+};
+
+FIXTURE_VARIANT(quic_ulp)
+{
+	unsigned int af_server;
+	char *server_address;
+	unsigned short server_port;
+};
+
+FIXTURE_VARIANT_ADD(quic_ulp, ipv4)
+{
+	.af_server = AF_INET,
+	.server_address = "10.0.0.2",
+	.server_port = 7101,
+};
+
+FIXTURE_VARIANT_ADD(quic_ulp, ipv6)
+{
+	.af_server = AF_INET6,
+	.server_address = "2001::2",
+	.server_port = 7102,
+};
+
+FIXTURE_SETUP(quic_ulp)
+{
+	char path[PATH_MAX];
+	int optval = 1;
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/net", getpid());
+	self->default_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->default_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns2");
+	self->server_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->server_net_ns_fd, 0);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	self->sfd = socket(variant->af_server, SOCK_DGRAM, 0);
+	ASSERT_NE(setsockopt(self->sfd, SOL_SOCKET, SO_REUSEPORT, &optval,
+		   sizeof(optval)), -1);
+	if (variant->af_server == AF_INET) {
+		self->len_s = sizeof(self->server.addr);
+		self->server.addr.sin_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr.sin_addr);
+		self->server.addr.sin_port = htons(variant->server_port);
+		ASSERT_EQ(bind(self->sfd, &self->server.addr, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr,
+				      &self->len_s), 0);
+	} else {
+		self->len_s = sizeof(self->server.addr6);
+		self->server.addr6.sin6_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr6.sin6_addr);
+		self->server.addr6.sin6_port = htons(variant->server_port);
+		ASSERT_EQ(bind(self->sfd, &self->server.addr6, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr6,
+				      &self->len_s), 0);
+	}
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+};
+
+FIXTURE_TEARDOWN(quic_ulp)
+{
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	close(self->sfd);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+};
+
+TEST_F(quic_ulp, request_nonexistent_udp_ulp)
+{
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_ULP,
+			     "nonexistent", sizeof("nonexistent")), -1);
+	// If UDP_ULP option is not present, the error would be ENOPROTOOPT.
+	ASSERT_EQ(errno, ENOENT);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+};
+
+TEST_F(quic_ulp, request_quic_crypto_udp_ulp)
+{
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_ULP,
+			     "quic-crypto", sizeof("quic-crypto")), 0);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+};
+
+// 2. QUIC Data Path Operation Tests
+
+#define DO_NOT_SETUP_FLOW 0
+#define SETUP_FLOW 1
+
+#define DO_NOT_USE_CLIENT 0
+#define USE_CLIENT 1
+
+FIXTURE(quic_data)
+{
+	int sfd, c1fd, c2fd;
+	socklen_t len_c1;
+	socklen_t len_c2;
+	socklen_t len_s;
+
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} client_1;
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} client_2;
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} server;
+	int default_net_ns_fd;
+	int client_1_net_ns_fd;
+	int client_2_net_ns_fd;
+	int server_net_ns_fd;
+};
+
+FIXTURE_VARIANT(quic_data)
+{
+	unsigned int af_client_1;
+	char *client_1_address;
+	unsigned short client_1_port;
+	uint8_t conn_id_1[8];
+	uint8_t conn_1_key[16];
+	uint8_t conn_1_iv[12];
+	uint8_t conn_1_hdr_key[16];
+	size_t conn_id_1_len;
+	bool setup_flow_1;
+	bool use_client_1;
+	unsigned int af_client_2;
+	char *client_2_address;
+	unsigned short client_2_port;
+	uint8_t conn_id_2[8];
+	uint8_t conn_2_key[16];
+	uint8_t conn_2_iv[12];
+	uint8_t conn_2_hdr_key[16];
+	size_t conn_id_2_len;
+	bool setup_flow_2;
+	bool use_client_2;
+	unsigned int af_server;
+	char *server_address;
+	unsigned short server_port;
+};
+
+FIXTURE_VARIANT_ADD(quic_data, ipv4)
+{
+	.af_client_1 = AF_INET,
+	.client_1_address = "10.0.0.1",
+	.client_1_port = 6667,
+	.conn_id_1 = {0x11, 0x12, 0x13, 0x14},
+	.conn_id_1_len = 4,
+	.setup_flow_1 = SETUP_FLOW,
+	.use_client_1 = USE_CLIENT,
+	.af_client_2 = AF_INET,
+	.client_2_address = "10.0.0.3",
+	.client_2_port = 6668,
+	.conn_id_2 = {0x21, 0x22, 0x23, 0x24},
+	.conn_id_2_len = 4,
+	.setup_flow_2 = SETUP_FLOW,
+	//.use_client_2 = USE_CLIENT,
+	.af_server = AF_INET,
+	.server_address = "10.0.0.2",
+	.server_port = 6669,
+};
+
+FIXTURE_VARIANT_ADD(quic_data, ipv6_mapped_ipv4_two_conns)
+{
+	.af_client_1 = AF_INET6,
+	.client_1_address = "::ffff:10.0.0.1",
+	.client_1_port = 6670,
+	.conn_id_1 = {0x11, 0x12, 0x13, 0x14},
+	.conn_id_1_len = 4,
+	.setup_flow_1 = SETUP_FLOW,
+	.use_client_1 = USE_CLIENT,
+	.af_client_2 = AF_INET6,
+	.client_2_address = "::ffff:10.0.0.3",
+	.client_2_port = 6671,
+	.conn_id_2 = {0x21, 0x22, 0x23, 0x24},
+	.conn_id_2_len = 4,
+	.setup_flow_2 = SETUP_FLOW,
+	.use_client_2 = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "::ffff:10.0.0.2",
+	.server_port = 6672,
+};
+
+FIXTURE_VARIANT_ADD(quic_data, ipv6_mapped_ipv4_setup_ipv4_one_conn)
+{
+	.af_client_1 = AF_INET,
+	.client_1_address = "10.0.0.3",
+	.client_1_port = 6676,
+	.conn_id_1 = {0x11, 0x12, 0x13, 0x14},
+	.conn_id_1_len = 4,
+	.setup_flow_1 = SETUP_FLOW,
+	.use_client_1 = DO_NOT_USE_CLIENT,
+	.af_client_2 = AF_INET6,
+	.client_2_address = "::ffff:10.0.0.3",
+	.client_2_port = 6676,
+	.conn_id_2 = {0x11, 0x12, 0x13, 0x14},
+	.conn_id_2_len = 4,
+	.setup_flow_2 = DO_NOT_SETUP_FLOW,
+	.use_client_2 = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "::ffff:10.0.0.2",
+	.server_port = 6677,
+};
+
+FIXTURE_VARIANT_ADD(quic_data, ipv6_mapped_ipv4_setup_ipv6_one_conn)
+{
+	.af_client_1 = AF_INET6,
+	.client_1_address = "::ffff:10.0.0.3",
+	.client_1_port = 6678,
+	.conn_id_1 = {0x11, 0x12, 0x13, 0x14},
+	.setup_flow_1 = SETUP_FLOW,
+	.use_client_1 = DO_NOT_USE_CLIENT,
+	.af_client_2 = AF_INET,
+	.client_2_address = "10.0.0.3",
+	.client_2_port = 6678,
+	.conn_id_2 = {0x11, 0x12, 0x13, 0x14},
+	.setup_flow_2 = DO_NOT_SETUP_FLOW,
+	.use_client_2 = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "::ffff:10.0.0.2",
+	.server_port = 6679,
+};
+
+FIXTURE_SETUP(quic_data)
+{
+	char path[PATH_MAX];
+	int optval = 1;
+
+	if (variant->af_client_1 == AF_INET) {
+		self->len_c1 = sizeof(self->client_1.addr);
+		self->client_1.addr.sin_family = variant->af_client_1;
+		inet_pton(variant->af_client_1, variant->client_1_address,
+			  &self->client_1.addr.sin_addr);
+		self->client_1.addr.sin_port = htons(variant->client_1_port);
+	} else {
+		self->len_c1 = sizeof(self->client_1.addr6);
+		self->client_1.addr6.sin6_family = variant->af_client_1;
+		inet_pton(variant->af_client_1, variant->client_1_address,
+			  &self->client_1.addr6.sin6_addr);
+		self->client_1.addr6.sin6_port = htons(variant->client_1_port);
+	}
+
+	if (variant->af_client_2 == AF_INET) {
+		self->len_c2 = sizeof(self->client_2.addr);
+		self->client_2.addr.sin_family = variant->af_client_2;
+		inet_pton(variant->af_client_2, variant->client_2_address,
+			  &self->client_2.addr.sin_addr);
+		self->client_2.addr.sin_port = htons(variant->client_2_port);
+	} else {
+		self->len_c2 = sizeof(self->client_2.addr6);
+		self->client_2.addr6.sin6_family = variant->af_client_2;
+		inet_pton(variant->af_client_2, variant->client_2_address,
+			  &self->client_2.addr6.sin6_addr);
+		self->client_2.addr6.sin6_port = htons(variant->client_2_port);
+	}
+
+	if (variant->af_server == AF_INET) {
+		self->len_s = sizeof(self->server.addr);
+		self->server.addr.sin_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr.sin_addr);
+		self->server.addr.sin_port = htons(variant->server_port);
+	} else {
+		self->len_s = sizeof(self->server.addr6);
+		self->server.addr6.sin6_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr6.sin6_addr);
+		self->server.addr6.sin6_port = htons(variant->server_port);
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/net", getpid());
+	self->default_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->default_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns11");
+	self->client_1_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->client_1_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns12");
+	self->client_2_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->client_2_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns2");
+	self->server_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->server_net_ns_fd, 0);
+
+	if (variant->use_client_1) {
+		ASSERT_NE(setns(self->client_1_net_ns_fd, 0), -1);
+		self->c1fd = socket(variant->af_client_1, SOCK_DGRAM, 0);
+		ASSERT_NE(setsockopt(self->c1fd, SOL_SOCKET, SO_REUSEPORT, &optval,
+		   sizeof(optval)), -1);
+		if (variant->af_client_1 == AF_INET) {
+			ASSERT_EQ(bind(self->c1fd, &self->client_1.addr,
+				       self->len_c1), 0);
+			ASSERT_EQ(getsockname(self->c1fd, &self->client_1.addr,
+					      &self->len_c1), 0);
+		} else {
+			ASSERT_EQ(bind(self->c1fd, &self->client_1.addr6,
+				       self->len_c1), 0);
+			ASSERT_EQ(getsockname(self->c1fd, &self->client_1.addr6,
+					      &self->len_c1), 0);
+		}
+	}
+
+	if (variant->use_client_2) {
+		ASSERT_NE(setns(self->client_2_net_ns_fd, 0), -1);
+		self->c2fd = socket(variant->af_client_2, SOCK_DGRAM, 0);
+		ASSERT_NE(setsockopt(self->c2fd, SOL_SOCKET, SO_REUSEPORT, &optval,
+		   sizeof(optval)), -1);
+		if (variant->af_client_2 == AF_INET) {
+			ASSERT_EQ(bind(self->c2fd, &self->client_2.addr,
+				       self->len_c2), 0);
+			ASSERT_EQ(getsockname(self->c2fd, &self->client_2.addr,
+					      &self->len_c2), 0);
+		} else {
+			ASSERT_EQ(bind(self->c2fd, &self->client_2.addr6,
+				       self->len_c2), 0);
+			ASSERT_EQ(getsockname(self->c2fd, &self->client_2.addr6,
+					      &self->len_c2), 0);
+		}
+	}
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	self->sfd = socket(variant->af_server, SOCK_DGRAM, 0);
+	ASSERT_NE(setsockopt(self->sfd, SOL_SOCKET, SO_REUSEPORT, &optval,
+	   sizeof(optval)), -1);
+	if (variant->af_server == AF_INET) {
+		ASSERT_EQ(bind(self->sfd, &self->server.addr, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr,
+				      &self->len_s), 0);
+	} else {
+		ASSERT_EQ(bind(self->sfd, &self->server.addr6, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr6,
+				      &self->len_s), 0);
+	}
+
+	ASSERT_EQ(setsockopt(self->sfd, IPPROTO_UDP, UDP_ULP,
+			     "quic-crypto", sizeof("quic-crypto")), 0);
+
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+FIXTURE_TEARDOWN(quic_data)
+{
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	close(self->sfd);
+	ASSERT_NE(setns(self->client_1_net_ns_fd, 0), -1);
+	close(self->c1fd);
+	ASSERT_NE(setns(self->client_2_net_ns_fd, 0), -1);
+	close(self->c2fd);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+TEST_F(quic_data, send_fail_no_flow)
+{
+	char const *test_str = "test_read";
+	int send_len = 10;
+
+	ASSERT_EQ(strlen(test_str) + 1, send_len);
+	EXPECT_EQ(sendto(self->sfd, test_str, send_len, 0,
+			 &self->client_1.addr, self->len_c1), -1);
+};
+
+TEST_F(quic_data, encrypt_two_conn_gso_1200_iov_2_size_9000_aesgcm128)
+{
+	size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
+	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
+	struct quic_connection_info conn_1_info;
+	struct quic_connection_info conn_2_info;
+	struct quic_tx_ancillary_data *anc_data;
+	socklen_t recv_addr_len_1;
+	socklen_t recv_addr_len_2;
+	struct cmsghdr *cmsg_hdr;
+	int frag_size = 1200;
+	int send_len = 9000;
+	struct iovec iov[2];
+	int msg_len = 4500;
+	struct msghdr msg;
+	char *test_str_1;
+	char *test_str_2;
+	char *buf_1;
+	char *buf_2;
+	int i;
+
+	test_str_1 = (char *)malloc(9000);
+	test_str_2 = (char *)malloc(9000);
+	memset(test_str_1, 0, 9000);
+	memset(test_str_2, 0, 9000);
+
+	buf_1 = (char *)malloc(10000);
+	buf_2 = (char *)malloc(10000);
+	for (i = 0; i < 9000; i += (1200 - 16)) {
+		test_str_1[i] = 0x40;
+		memcpy(&test_str_1[i + 1], &variant->conn_id_1,
+		       variant->conn_id_1_len);
+		test_str_1[i + 1 + variant->conn_id_1_len] = 0xca;
+
+		test_str_2[i] = 0x40;
+		memcpy(&test_str_2[i + 1], &variant->conn_id_2,
+		       variant->conn_id_2_len);
+		test_str_2[i + 1 + variant->conn_id_2_len] = 0xca;
+	}
+
+	// program the connection into the offload
+	conn_1_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(&conn_1_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_1_info.key.conn_id_length = variant->conn_id_1_len;
+	memcpy(conn_1_info.key.conn_id,
+	       &variant->conn_id_1,
+	       variant->conn_id_1_len);
+
+	conn_2_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(&conn_2_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_2_info.key.conn_id_length = variant->conn_id_2_len;
+	memcpy(conn_2_info.key.conn_id,
+	       &variant->conn_id_2,
+	       variant->conn_id_2_len);
+
+	memcpy(&conn_1_info.crypto_info_aes_gcm_128.packet_encryption_key,
+	       &variant->conn_1_key, 16);
+	memcpy(&conn_1_info.crypto_info_aes_gcm_128.packet_encryption_iv,
+	       &variant->conn_1_iv, 12);
+	memcpy(&conn_1_info.crypto_info_aes_gcm_128.header_encryption_key,
+	       &variant->conn_1_hdr_key, 16);
+	memcpy(&conn_2_info.crypto_info_aes_gcm_128.packet_encryption_key,
+	       &variant->conn_2_key, 16);
+	memcpy(&conn_2_info.crypto_info_aes_gcm_128.packet_encryption_iv,
+	       &variant->conn_2_iv, 12);
+	memcpy(&conn_2_info.crypto_info_aes_gcm_128.header_encryption_key,
+	       &variant->conn_2_hdr_key,
+	       16);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
+			     sizeof(frag_size)), 0);
+
+	if (variant->setup_flow_1)
+		ASSERT_EQ(setsockopt(self->sfd, SOL_UDP,
+				     UDP_QUIC_ADD_TX_CONNECTION,
+				     &conn_1_info, sizeof(conn_1_info)), 0);
+
+	if (variant->setup_flow_2)
+		ASSERT_EQ(setsockopt(self->sfd, SOL_UDP,
+				     UDP_QUIC_ADD_TX_CONNECTION,
+				     &conn_2_info, sizeof(conn_2_info)), 0);
+
+	recv_addr_len_1 = self->len_c1;
+	recv_addr_len_2 = self->len_c2;
+
+	iov[0].iov_base = test_str_1;
+	iov[0].iov_len = msg_len;
+	iov[1].iov_base = (void *)test_str_1 + 4500;
+	iov[1].iov_len = msg_len;
+
+	msg.msg_name = (self->client_1.addr.sin_family == AF_INET)
+		       ? (void *)&self->client_1.addr
+		       : (void *)&self->client_1.addr6;
+	msg.msg_namelen = self->len_c1;
+	msg.msg_iov = iov;
+	msg.msg_iovlen = 2;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->next_pkt_num = 0x0d65c9;
+	anc_data->flags = 0;
+	anc_data->conn_id_length = variant->conn_id_1_len;
+
+	if (variant->use_client_1)
+		EXPECT_EQ(sendmsg(self->sfd, &msg, 0), send_len);
+
+	iov[0].iov_base = test_str_2;
+	iov[0].iov_len = msg_len;
+	iov[1].iov_base = (void *)test_str_2 + 4500;
+	iov[1].iov_len = msg_len;
+	msg.msg_name = (self->client_2.addr.sin_family == AF_INET)
+		       ? (void *)&self->client_2.addr
+		       : (void *)&self->client_2.addr6;
+	msg.msg_namelen = self->len_c2;
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->next_pkt_num = 0x0d65c9;
+	anc_data->conn_id_length = variant->conn_id_2_len;
+	anc_data->flags = 0;
+
+	if (variant->use_client_2)
+		EXPECT_EQ(sendmsg(self->sfd, &msg, 0), send_len);
+
+	if (variant->use_client_1) {
+		ASSERT_NE(setns(self->client_1_net_ns_fd, 0), -1);
+		if (variant->af_client_1 == AF_INET) {
+			for (i = 0; i < 7; ++i) {
+				EXPECT_EQ(recvfrom(self->c1fd, buf_1, 9000, 0,
+						   &self->client_1.addr,
+						   &recv_addr_len_1),
+					  1200);
+				// Validate framing is intact.
+				EXPECT_EQ(memcmp((void *)buf_1 + 1,
+						 &variant->conn_id_1,
+						 variant->conn_id_1_len), 0);
+			}
+			EXPECT_EQ(recvfrom(self->c1fd, buf_1, 9000, 0,
+					   &self->client_1.addr,
+					   &recv_addr_len_1),
+				  728);
+			EXPECT_EQ(memcmp((void *)buf_1 + 1,
+					 &variant->conn_id_1,
+					 variant->conn_id_1_len), 0);
+		} else {
+			for (i = 0; i < 7; ++i) {
+				EXPECT_EQ(recvfrom(self->c1fd, buf_1, 9000, 0,
+						   &self->client_1.addr6,
+						   &recv_addr_len_1),
+					1200);
+			}
+			EXPECT_EQ(recvfrom(self->c1fd, buf_1, 9000, 0,
+					   &self->client_1.addr6,
+					   &recv_addr_len_1),
+				  728);
+			EXPECT_EQ(memcmp((void *)buf_1 + 1,
+					 &variant->conn_id_1,
+					 variant->conn_id_1_len), 0);
+		}
+		EXPECT_NE(memcmp(buf_1, test_str_1, send_len), 0);
+	}
+
+	if (variant->use_client_2) {
+		ASSERT_NE(setns(self->client_2_net_ns_fd, 0), -1);
+		if (variant->af_client_2 == AF_INET) {
+			for (i = 0; i < 7; ++i) {
+				EXPECT_EQ(recvfrom(self->c2fd, buf_2, 9000, 0,
+						   &self->client_2.addr,
+						   &recv_addr_len_2),
+					  1200);
+				EXPECT_EQ(memcmp((void *)buf_2 + 1,
+						 &variant->conn_id_2,
+						 variant->conn_id_2_len), 0);
+			}
+			EXPECT_EQ(recvfrom(self->c2fd, buf_2, 9000, 0,
+					   &self->client_2.addr,
+					   &recv_addr_len_2),
+				  728);
+			EXPECT_EQ(memcmp((void *)buf_2 + 1,
+					 &variant->conn_id_2,
+					 variant->conn_id_2_len), 0);
+		} else {
+			for (i = 0; i < 7; ++i) {
+				EXPECT_EQ(recvfrom(self->c2fd, buf_2, 9000, 0,
+						   &self->client_2.addr6,
+						   &recv_addr_len_2),
+					  1200);
+				EXPECT_EQ(memcmp((void *)buf_2 + 1,
+						 &variant->conn_id_2,
+						 variant->conn_id_2_len), 0);
+			}
+			EXPECT_EQ(recvfrom(self->c2fd, buf_2, 9000, 0,
+					   &self->client_2.addr6,
+					   &recv_addr_len_2),
+				  728);
+			EXPECT_EQ(memcmp((void *)buf_2 + 1,
+					 &variant->conn_id_2,
+					 variant->conn_id_2_len), 0);
+		}
+		EXPECT_NE(memcmp(buf_2, test_str_2, send_len), 0);
+	}
+
+	if (variant->use_client_1 && variant->use_client_2)
+		EXPECT_NE(memcmp(buf_1, buf_2, send_len), 0);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	if (variant->setup_flow_1) {
+		ASSERT_EQ(setsockopt(self->sfd, SOL_UDP,
+				     UDP_QUIC_DEL_TX_CONNECTION,
+				     &conn_1_info, sizeof(conn_1_info)),
+			  0);
+	}
+	if (variant->setup_flow_2) {
+		ASSERT_EQ(setsockopt(self->sfd, SOL_UDP,
+				     UDP_QUIC_DEL_TX_CONNECTION,
+				     &conn_2_info, sizeof(conn_2_info)),
+			  0);
+	}
+	free(test_str_1);
+	free(test_str_2);
+	free(buf_1);
+	free(buf_2);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+// 3. QUIC Encryption Tests
+
+FIXTURE(quic_crypto)
+{
+	int sfd, cfd;
+	socklen_t len_c;
+	socklen_t len_s;
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} client;
+	union {
+		struct sockaddr_in addr;
+		struct sockaddr_in6 addr6;
+	} server;
+	int default_net_ns_fd;
+	int client_net_ns_fd;
+	int server_net_ns_fd;
+};
+
+FIXTURE_VARIANT(quic_crypto)
+{
+	unsigned int af_client;
+	char *client_address;
+	unsigned short client_port;
+	uint32_t algo;
+	uint8_t conn_id[8];
+	uint8_t conn_key[16];
+	uint8_t conn_iv[12];
+	uint8_t conn_hdr_key[16];
+	size_t conn_id_len;
+	bool setup_flow;
+	bool use_client;
+	unsigned int af_server;
+	char *server_address;
+	unsigned short server_port;
+};
+
+FIXTURE_SETUP(quic_crypto)
+{
+	char path[PATH_MAX];
+	int optval = 1;
+
+	if (variant->af_client == AF_INET) {
+		self->len_c = sizeof(self->client.addr);
+		self->client.addr.sin_family = variant->af_client;
+		inet_pton(variant->af_client, variant->client_address,
+			  &self->client.addr.sin_addr);
+		self->client.addr.sin_port = htons(variant->client_port);
+	} else {
+		self->len_c = sizeof(self->client.addr6);
+		self->client.addr6.sin6_family = variant->af_client;
+		inet_pton(variant->af_client, variant->client_address,
+			  &self->client.addr6.sin6_addr);
+		self->client.addr6.sin6_port = htons(variant->client_port);
+	}
+
+	if (variant->af_server == AF_INET) {
+		self->len_s = sizeof(self->server.addr);
+		self->server.addr.sin_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr.sin_addr);
+		self->server.addr.sin_port = htons(variant->server_port);
+	} else {
+		self->len_s = sizeof(self->server.addr6);
+		self->server.addr6.sin6_family = variant->af_server;
+		inet_pton(variant->af_server, variant->server_address,
+			  &self->server.addr6.sin6_addr);
+		self->server.addr6.sin6_port = htons(variant->server_port);
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/net", getpid());
+	self->default_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->default_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns11");
+	self->client_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->client_net_ns_fd, 0);
+	strcpy(path, "/var/run/netns/ns2");
+	self->server_net_ns_fd = open(path, O_RDONLY);
+	ASSERT_GE(self->server_net_ns_fd, 0);
+
+	if (variant->use_client) {
+		ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+		self->cfd = socket(variant->af_client, SOCK_DGRAM, 0);
+		ASSERT_NE(setsockopt(self->cfd, SOL_SOCKET, SO_REUSEPORT, &optval,
+			sizeof(optval)), -1);
+		if (variant->af_client == AF_INET) {
+			ASSERT_EQ(bind(self->cfd, &self->client.addr,
+				       self->len_c), 0);
+			ASSERT_EQ(getsockname(self->cfd, &self->client.addr,
+					      &self->len_c), 0);
+		} else {
+			ASSERT_EQ(bind(self->cfd, &self->client.addr6,
+				       self->len_c), 0);
+			ASSERT_EQ(getsockname(self->cfd, &self->client.addr6,
+					      &self->len_c), 0);
+		}
+	}
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	self->sfd = socket(variant->af_server, SOCK_DGRAM, 0);
+	ASSERT_NE(setsockopt(self->sfd, SOL_SOCKET, SO_REUSEPORT, &optval,
+	   sizeof(optval)), -1);
+	if (variant->af_server == AF_INET) {
+		ASSERT_EQ(bind(self->sfd, &self->server.addr, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr,
+				      &self->len_s),
+			  0);
+	} else {
+		ASSERT_EQ(bind(self->sfd, &self->server.addr6, self->len_s), 0);
+		ASSERT_EQ(getsockname(self->sfd, &self->server.addr6,
+				      &self->len_s),
+			  0);
+	}
+
+	ASSERT_EQ(setsockopt(self->sfd, IPPROTO_UDP, UDP_ULP,
+			     "quic-crypto", sizeof("quic-crypto")), 0);
+
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+FIXTURE_TEARDOWN(quic_crypto)
+{
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	close(self->sfd);
+	ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+	close(self->cfd);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+FIXTURE_VARIANT_ADD(quic_crypto, ipv4)
+{
+	.af_client = AF_INET,
+	.client_address = "10.0.0.1",
+	.client_port = 7667,
+	.conn_id = {0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12, 0x49},
+	.conn_key = {0x87, 0x71, 0xEA, 0x1D, 0xFB, 0xBE, 0x7A, 0x45, 0xBB,
+		0xE2, 0x7E, 0xBC, 0x0B, 0x53, 0x94, 0x99},
+	.conn_iv = {0x3A, 0xA7, 0x46, 0x72, 0xE9, 0x83, 0x6B, 0x55, 0xDA,
+		0x66, 0x7B, 0xDA},
+	.conn_hdr_key = {0xC9, 0x8E, 0xFD, 0xF2, 0x0B, 0x64, 0x8C, 0x57,
+		0xB5, 0x0A, 0xB2, 0xD2, 0x21, 0xD3, 0x66, 0xA5},
+	.conn_id_len = 8,
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "10.0.0.2",
+	.server_port = 7669,
+};
+
+FIXTURE_VARIANT_ADD(quic_crypto, ipv6)
+{
+	.af_client = AF_INET6,
+	.client_address = "2001::1",
+	.client_port = 7673,
+	.conn_id = {0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12, 0x49},
+	.conn_key = {0x87, 0x71, 0xEA, 0x1D, 0xFB, 0xBE, 0x7A, 0x45, 0xBB,
+		0xE2, 0x7E, 0xBC, 0x0B, 0x53, 0x94, 0x99},
+	.conn_iv = {0x3A, 0xA7, 0x46, 0x72, 0xE9, 0x83, 0x6B, 0x55, 0xDA,
+		0x66, 0x7B, 0xDA},
+	.conn_hdr_key = {0xC9, 0x8E, 0xFD, 0xF2, 0x0B, 0x64, 0x8C, 0x57,
+		0xB5, 0x0A, 0xB2, 0xD2, 0x21, 0xD3, 0x66, 0xA5},
+	.conn_id_len = 8,
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "2001::2",
+	.server_port = 7675,
+};
+
+TEST_F(quic_crypto, encrypt_test_vector_aesgcm128_single_flow_gso_in_control)
+{
+	char test_str[37] = {// Header, conn id and pkt num
+			     0x40, 0x08, 0x6B, 0xBF, 0x88, 0x82, 0xB9, 0x12,
+			     0x49, 0xCA,
+			     // Payload
+			     0x02, 0x80, 0xDE, 0x40, 0x39, 0x40, 0xF6, 0x00,
+			     0x01, 0x0B, 0x00, 0x0F, 0x65, 0x63, 0x68, 0x6F,
+			     0x20, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36,
+			     0x37, 0x38, 0x39
+	};
+
+	char match_str[53] = {
+			     0x46, 0x08, 0x6B, 0xBF, 0x88, 0x82, 0xB9, 0x12,
+			     0x49, 0x1C, 0x44, 0xB8, 0x41, 0xBB, 0xCF, 0x6E,
+			     0x0A, 0x2A, 0x24, 0xFB, 0xB4, 0x79, 0x62, 0xEA,
+			     0x59, 0x38, 0x1A, 0x0E, 0x50, 0x1E, 0x59, 0xED,
+			     0x3F, 0x8E, 0x7E, 0x5A, 0x70, 0xE4, 0x2A, 0xBC,
+			     0x2A, 0xFA, 0x2B, 0x54, 0xEB, 0x89, 0xC3, 0x2C,
+			     0xB6, 0x8C, 0x1E, 0xAB, 0x2D
+	};
+
+	size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
+	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)
+			 + CMSG_SPACE(sizeof(uint16_t))];
+	struct quic_tx_ancillary_data *anc_data;
+	struct quic_connection_info conn_info;
+	int send_len = sizeof(test_str);
+	int msg_len = sizeof(test_str);
+	uint16_t frag_size = 1200;
+	struct cmsghdr *cmsg_hdr;
+	int wrong_frag_size = 26;
+	socklen_t recv_addr_len;
+	struct iovec iov[2];
+	struct msghdr msg;
+	char *buf;
+
+	buf = (char *)malloc(1024);
+	conn_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = variant->conn_id_len;
+	memcpy(conn_info.key.conn_id,
+	       &variant->conn_id,
+	       variant->conn_id_len);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.packet_encryption_key,
+	       &variant->conn_key, 16);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.packet_encryption_iv,
+	       &variant->conn_iv, 12);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.header_encryption_key,
+	       &variant->conn_hdr_key,
+	       16);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &wrong_frag_size,
+			     sizeof(wrong_frag_size)), 0);
+
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+
+	recv_addr_len = self->len_c;
+
+	iov[0].iov_base = test_str;
+	iov[0].iov_len = msg_len;
+
+	memset(cmsg_buf, 0, sizeof(cmsg_buf));
+	msg.msg_name = (self->client.addr.sin_family == AF_INET)
+		       ? (void *)&self->client.addr
+		       : (void *)&self->client.addr6;
+	msg.msg_namelen = self->len_c;
+	msg.msg_iov = iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->flags = 0;
+	anc_data->next_pkt_num = 0x0d65c9;
+	anc_data->conn_id_length = variant->conn_id_len;
+
+	cmsg_hdr = CMSG_NXTHDR(&msg, cmsg_hdr);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_SEGMENT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(sizeof(uint16_t));
+	memcpy(CMSG_DATA(cmsg_hdr), (void *)&frag_size, sizeof(frag_size));
+
+	EXPECT_EQ(sendmsg(self->sfd, &msg, 0), send_len);
+	ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+	if (variant->af_client == AF_INET) {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 1024, 0,
+				   &self->client.addr, &recv_addr_len),
+			  sizeof(match_str));
+	} else {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr6, &recv_addr_len),
+			  sizeof(match_str));
+	}
+	EXPECT_STREQ(buf, match_str);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+	free(buf);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+TEST_F(quic_crypto, encrypt_test_vector_aesgcm128_single_flow_gso_in_setsockopt)
+{
+	char test_str[37] = {// Header, conn id and pkt num
+			     0x40, 0x08, 0x6B, 0xBF, 0x88, 0x82, 0xB9, 0x12,
+			     0x49, 0xCA,
+			     // Payload
+			     0x02, 0x80, 0xDE, 0x40, 0x39, 0x40, 0xF6, 0x00,
+			     0x01, 0x0B, 0x00, 0x0F, 0x65, 0x63, 0x68, 0x6F,
+			     0x20, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36,
+			     0x37, 0x38, 0x39
+	};
+
+	char match_str[53] = {
+			     0x46, 0x08, 0x6B, 0xBF, 0x88, 0x82, 0xB9, 0x12,
+			     0x49, 0x1C, 0x44, 0xB8, 0x41, 0xBB, 0xCF, 0x6E,
+			     0x0A, 0x2A, 0x24, 0xFB, 0xB4, 0x79, 0x62, 0xEA,
+			     0x59, 0x38, 0x1A, 0x0E, 0x50, 0x1E, 0x59, 0xED,
+			     0x3F, 0x8E, 0x7E, 0x5A, 0x70, 0xE4, 0x2A, 0xBC,
+			     0x2A, 0xFA, 0x2B, 0x54, 0xEB, 0x89, 0xC3, 0x2C,
+			     0xB6, 0x8C, 0x1E, 0xAB, 0x2D
+	};
+
+	size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
+	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
+	struct quic_tx_ancillary_data *anc_data;
+	struct quic_connection_info conn_info;
+	int send_len = sizeof(test_str);
+	int msg_len = sizeof(test_str);
+	struct cmsghdr *cmsg_hdr;
+	socklen_t recv_addr_len;
+	int frag_size = 1200;
+	struct iovec iov[2];
+	struct msghdr msg;
+	char *buf;
+
+	buf = (char *)malloc(1024);
+
+	conn_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = variant->conn_id_len;
+	memcpy(&conn_info.key.conn_id,
+	       &variant->conn_id,
+	       variant->conn_id_len);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.packet_encryption_key,
+	       &variant->conn_key, 16);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.packet_encryption_iv,
+	       &variant->conn_iv, 12);
+	memcpy(&conn_info.crypto_info_aes_gcm_128.header_encryption_key,
+	       &variant->conn_hdr_key,
+	       16);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
+			     sizeof(frag_size)),
+		  0);
+
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)),
+		  0);
+
+	recv_addr_len = self->len_c;
+
+	iov[0].iov_base = test_str;
+	iov[0].iov_len = msg_len;
+
+	msg.msg_name = (self->client.addr.sin_family == AF_INET)
+		       ? (void *)&self->client.addr
+		       : (void *)&self->client.addr6;
+	msg.msg_namelen = self->len_c;
+	msg.msg_iov = iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->flags = 0;
+	anc_data->next_pkt_num = 0x0d65c9;
+	anc_data->conn_id_length = variant->conn_id_len;
+
+	EXPECT_EQ(sendmsg(self->sfd, &msg, 0), send_len);
+	ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+	if (variant->af_client == AF_INET) {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 1024, 0,
+				   &self->client.addr, &recv_addr_len),
+			  sizeof(match_str));
+	} else {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr6, &recv_addr_len),
+			  sizeof(match_str));
+	}
+	EXPECT_STREQ(buf, match_str);
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+	free(buf);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/net/quic.sh b/tools/testing/selftests/net/quic.sh
new file mode 100755
index 000000000000..6c684e670e82
--- /dev/null
+++ b/tools/testing/selftests/net/quic.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+
+sudo ip netns add ns11
+sudo ip netns add ns12
+sudo ip netns add ns2
+sudo ip link add veth11 type veth peer name br-veth11
+sudo ip link add veth12 type veth peer name br-veth12
+sudo ip link add veth2 type veth peer name br-veth2
+sudo ip link set veth11 netns ns11
+sudo ip link set veth12 netns ns12
+sudo ip link set veth2 netns ns2
+sudo ip netns exec ns11 ip addr add 10.0.0.1/24 dev veth11
+sudo ip netns exec ns11 ip addr add ::ffff:10.0.0.1/96 dev veth11
+sudo ip netns exec ns11 ip addr add 2001::1/64 dev veth11
+sudo ip netns exec ns12 ip addr add 10.0.0.3/24 dev veth12
+sudo ip netns exec ns12 ip addr add ::ffff:10.0.0.3/96 dev veth12
+sudo ip netns exec ns12 ip addr add 2001::3/64 dev veth12
+sudo ip netns exec ns2 ip addr add 10.0.0.2/24 dev veth2
+sudo ip netns exec ns2 ip addr add ::ffff:10.0.0.2/96 dev veth2
+sudo ip netns exec ns2 ip addr add 2001::2/64 dev veth2
+sudo ip link add name br1 type bridge forward_delay 0
+sudo ip link set br1 up
+sudo ip link set br-veth11 up
+sudo ip link set br-veth12 up
+sudo ip link set br-veth2 up
+sudo ip netns exec ns11 ip link set veth11 up
+sudo ip netns exec ns12 ip link set veth12 up
+sudo ip netns exec ns2 ip link set veth2 up
+sudo ip link set br-veth11 master br1
+sudo ip link set br-veth12 master br1
+sudo ip link set br-veth2 master br1
+sudo ip netns exec ns2 cat /proc/net/quic_stat
+
+printf "%s" "Waiting for bridge to start fowarding ..."
+while ! timeout 0.5 sudo ip netns exec ns2 ping -c 1 -n 2001::1 &> /dev/null
+do
+	printf "%c" "."
+done
+printf "\n%s\n"  "Bridge is operational"
+
+sudo ./quic
+sudo ip netns exec ns2 cat /proc/net/quic_stat
+sudo ip netns delete ns2
+sudo ip netns delete ns12
+sudo ip netns delete ns11
-- 
2.30.2

