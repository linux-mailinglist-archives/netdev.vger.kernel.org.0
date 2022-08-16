Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020FC59622C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiHPSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiHPSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:12:29 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF23984EFA;
        Tue, 16 Aug 2022 11:12:26 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id mk9so8439533qvb.11;
        Tue, 16 Aug 2022 11:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bHi2bAkUYS3z+kGY5jUXeoZJNchcOrKUOAxuL0nsUcE=;
        b=PI/qTLGj3JqjB8UkjRTJbntkyEHFsMXNHziqu89SO6NxQ9yI+RMIrsmTv3E78T9fGo
         wVgPDq5UhMDPkDoJ3eWcuhE7UC6g8uAUumxze2jfPnLWuxrsYCvqdxdks1DGvFSaeKs8
         +Ywfge4Igt5ZPINYphClQGAcDEDocHcTixjn/I5nVFOfdkmx0TSowhyIoZQuOJssQnfP
         sQDPIOfZk2u6pWoRBAD/ocZTEKc4QUtPm1QERLCYiZFHHllbsaxsO0wivSv6MrsXWEBN
         3ojdIAmVPn0SMr5KY2wu3uPrNREAKA8Hh57LRa/tNvAhrFDbYc9/uKAask+bkUXa8e7D
         p6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bHi2bAkUYS3z+kGY5jUXeoZJNchcOrKUOAxuL0nsUcE=;
        b=cEJ5b6apjiLPcSvP98GEAfYJYfyESHaS9lqfAOx+q5qsPA69fYMCMaTAocatgFKYCL
         RGiM65bcg20J/CGs5wMQqJa+8BrZl3d4iUOqIdM75GnXeG5ofT0uBNMHX+woIW87LnH8
         OOLiZBhwXuJH9QqBQ7VJv7SnOkETHxrdYJTm+wjnHjXQm0rxfWEXA5FrtoB74BNsu1MO
         Gqb8IYuhlX7ckfPFPjvL/P3gGN6e9rxEoZZwxKLdhsOKlPa+ykLCnZiulVHndwj5D8EV
         sno04jT/vZRJhqJ3CmDcoKFpK9KtPOYfTOowAIyzqpLGql8Rz/QQl4tkq/5Qa+ovsys2
         eZbw==
X-Gm-Message-State: ACgBeo1hfSBi47TLoAD4q6zZtdo51JQBztDgDXZG9/k0GEu7rFnU7xVv
        rq/OM53Q9B6XzFXBdUXzY9XmFyhYdS0=
X-Google-Smtp-Source: AA6agR5ja84cQFSht91SZ8K8dLJIFUtlPPHvrCfwx0hKVqE8hENZ2hm29GZs9sBoAWYM6tlFekRJgw==
X-Received: by 2002:a17:902:ec8f:b0:16e:d8d8:c2ef with SMTP id x15-20020a170902ec8f00b0016ed8d8c2efmr23742213plg.62.1660673534694;
        Tue, 16 Aug 2022 11:12:14 -0700 (PDT)
Received: from localhost (fwdproxy-prn-119.fbsv.net. [2a03:2880:ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id t4-20020a170902e84400b0016dbe37cebdsm9397576plg.246.2022.08.16.11.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:12:14 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next 6/6] Add self tests for ULP operations, flow setup and crypto tests
Date:   Tue, 16 Aug 2022 11:11:50 -0700
Message-Id: <20220816181150.3507444-7-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816181150.3507444-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220816181150.3507444-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add self tests for ULP operations, flow setup and crypto tests.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>

---

Restored the test build. Changed the QUIC context reference variable
names for the keys and iv to match the uAPI.

Updated alignment, added SPDX license line.

v3: Added Chacha20-Poly1305 test.
---
 tools/testing/selftests/net/.gitignore |    3 +-
 tools/testing/selftests/net/Makefile   |    3 +-
 tools/testing/selftests/net/quic.c     | 1153 ++++++++++++++++++++++++
 tools/testing/selftests/net/quic.sh    |   46 +
 4 files changed, 1203 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/net/quic.c
 create mode 100755 tools/testing/selftests/net/quic.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 892306bdb47d..134b50f2ceb9 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -38,4 +38,5 @@ ioam6_parser
 toeplitz
 tun
 cmsg_sender
-unix_connect
\ No newline at end of file
+unix_connect
+quic
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index e2dfef8b78a7..e107efc84baf 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -42,6 +42,7 @@ TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
 TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
+TEST_PROGS += quic.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
@@ -57,7 +58,7 @@ TEST_GEN_FILES += ipsec
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
index 000000000000..2aa5e1564f5f
--- /dev/null
+++ b/tools/testing/selftests/net/quic.c
@@ -0,0 +1,1153 @@
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
+			     sizeof(optval)), -1);
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
+		ASSERT_NE(setsockopt(self->c1fd, SOL_SOCKET, SO_REUSEPORT,
+				     &optval, sizeof(optval)), -1);
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
+		ASSERT_NE(setsockopt(self->c2fd, SOL_SOCKET, SO_REUSEPORT,
+				     &optval, sizeof(optval)), -1);
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
+			     sizeof(optval)), -1);
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
+	memcpy(&conn_1_info.aes_gcm_128.payload_key,
+	       &variant->conn_1_key, 16);
+	memcpy(&conn_1_info.aes_gcm_128.payload_iv,
+	       &variant->conn_1_iv, 12);
+	memcpy(&conn_1_info.aes_gcm_128.header_key,
+	       &variant->conn_1_hdr_key, 16);
+	memcpy(&conn_2_info.aes_gcm_128.payload_key,
+	       &variant->conn_2_key, 16);
+	memcpy(&conn_2_info.aes_gcm_128.payload_iv,
+	       &variant->conn_2_iv, 12);
+	memcpy(&conn_2_info.aes_gcm_128.header_key,
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
+	size_t conn_key_len;
+	uint8_t conn_id[8];
+	union {
+		uint8_t conn_key_16[16];
+		uint8_t conn_key_32[32];
+	} conn_key;
+	uint8_t conn_iv[12];
+	union {
+		uint8_t conn_hdr_key_16[16];
+		uint8_t conn_hdr_key_32[32];
+	} conn_hdr_key;
+	size_t conn_id_len;
+	bool setup_flow;
+	bool use_client;
+	unsigned int af_server;
+	char *server_address;
+	unsigned short server_port;
+	char plain[128];
+	size_t plain_len;
+	char match[128];
+	size_t match_len;
+	uint32_t next_pkt_num;
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
+		ASSERT_NE(setsockopt(self->cfd, SOL_SOCKET, SO_REUSEPORT,
+				     &optval, sizeof(optval)), -1);
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
+			     sizeof(optval)), -1);
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
+FIXTURE_VARIANT_ADD(quic_crypto, ipv4_aes_gcm_128)
+{
+	.af_client = AF_INET,
+	.client_address = "10.0.0.1",
+	.client_port = 7667,
+	.algo = TLS_CIPHER_AES_GCM_128,
+	.conn_key_len = 16,
+	.conn_id = {0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12, 0x49},
+	.conn_key = {
+		.conn_key_16 = {0x87, 0x71, 0xea, 0x1d,
+				0xfb, 0xbe, 0x7a, 0x45,
+				0xbb, 0xe2, 0x7e, 0xbc,
+				0x0b, 0x53, 0x94, 0x99
+		},
+	},
+	.conn_iv = {0x3A, 0xA7, 0x46, 0x72, 0xE9, 0x83, 0x6B, 0x55, 0xDA,
+		0x66, 0x7B, 0xDA},
+	.conn_hdr_key = {
+		.conn_hdr_key_16 = {0xc9, 0x8e, 0xfd, 0xf2,
+				    0x0b, 0x64, 0x8c, 0x57,
+				    0xb5, 0x0a, 0xb2, 0xd2,
+				    0x21, 0xd3, 0x66, 0xa5},
+	},
+	.conn_id_len = 8,
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET,
+	.server_address = "10.0.0.2",
+	.server_port = 7669,
+	.plain = { 0x40, 0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12,
+		   0x49, 0xca,
+		   // payload
+		   0x02, 0x80, 0xde, 0x40, 0x39, 0x40, 0xf6, 0x00,
+		   0x01, 0x0b, 0x00, 0x0f, 0x65, 0x63, 0x68, 0x6f,
+		   0x20, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36,
+		   0x37, 0x38, 0x39
+	},
+	.plain_len = 37,
+	.match = {
+		   0x46, 0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12,
+		   0x49, 0x1c, 0x44, 0xb8, 0x41, 0xbb, 0xcf, 0x6e,
+		   0x0a, 0x2a, 0x24, 0xfb, 0xb4, 0x79, 0x62, 0xea,
+		   0x59, 0x38, 0x1a, 0x0e, 0x50, 0x1e, 0x59, 0xed,
+		   0x3f, 0x8e, 0x7e, 0x5a, 0x70, 0xe4, 0x2a, 0xbc,
+		   0x2a, 0xfa, 0x2b, 0x54, 0xeb, 0x89, 0xc3, 0x2c,
+		   0xb6, 0x8c, 0x1e, 0xab, 0x2d
+	},
+	.match_len = 53,
+	.next_pkt_num = 0x0d65c9,
+};
+
+FIXTURE_VARIANT_ADD(quic_crypto, ipv4_chacha20_poly1305)
+{
+	.af_client = AF_INET,
+	.client_address = "10.0.0.1",
+	.client_port = 7801,
+	.algo = TLS_CIPHER_CHACHA20_POLY1305,
+	.conn_key_len = 32,
+	.conn_id = {},
+	.conn_id_len = 0,
+	.conn_key = {
+		.conn_key_32 = {
+			0x3b, 0xfc, 0xdd, 0xd7, 0x2b, 0xcf, 0x02, 0x54,
+			0x1d, 0x7f, 0xa0, 0xdd, 0x1f, 0x5f, 0x9e, 0xee,
+			0xa8, 0x17, 0xe0, 0x9a, 0x69, 0x63, 0xa0, 0xe6,
+			0xc7, 0xdf, 0x0f, 0x9a, 0x1b, 0xab, 0x90, 0xf2,
+		},
+	},
+	.conn_iv = {
+		0xa6, 0xb5, 0xbc, 0x6a, 0xb7, 0xda, 0xfc, 0xe3,
+		0x0f, 0xff, 0xf5, 0xdd,
+	},
+	.conn_hdr_key = {
+		.conn_hdr_key_32 = {
+			0xd6, 0x59, 0x76, 0x0d, 0x2b, 0xa4, 0x34, 0xa2,
+			0x26, 0xfd, 0x37, 0xb3, 0x5c, 0x69, 0xe2, 0xda,
+			0x82, 0x11, 0xd1, 0x0c, 0x4f, 0x12, 0x53, 0x87,
+			0x87, 0xd6, 0x56, 0x45, 0xd5, 0xd1, 0xb8, 0xe2,
+		},
+	},
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET,
+	.server_address = "10.0.0.2",
+	.server_port = 7802,
+	.plain = { 0x42, 0x00, 0xbf, 0xf4, 0x01 },
+	.plain_len = 5,
+	.match = { 0x55, 0x58, 0xb1, 0xc6, 0x0a, 0xe7, 0xb6, 0xb9,
+		   0x32, 0xbc, 0x27, 0xd7, 0x86, 0xf4, 0xbc, 0x2b,
+		   0xb2, 0x0f, 0x21, 0x62, 0xba },
+	.match_len = 21,
+	.next_pkt_num = 0x2700bff5,
+};
+
+FIXTURE_VARIANT_ADD(quic_crypto, ipv6_aes_gcm_128)
+{
+	.af_client = AF_INET6,
+	.client_address = "2001::1",
+	.client_port = 7673,
+	.algo = TLS_CIPHER_AES_GCM_128,
+	.conn_key_len = 16,
+	.conn_id = {0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12, 0x49},
+	.conn_key = {
+		.conn_key_16 = {0x87, 0x71, 0xea, 0x1d,
+				0xfb, 0xbe, 0x7a, 0x45,
+				0xbb, 0xe2, 0x7e, 0xbc,
+				0x0b, 0x53, 0x94, 0x99
+		},
+	},
+	.conn_iv = {0x3a, 0xa7, 0x46, 0x72, 0xe9, 0x83, 0x6b, 0x55, 0xda,
+		0x66, 0x7b, 0xda},
+	.conn_hdr_key = {
+		.conn_hdr_key_16 = {0xc9, 0x8e, 0xfd, 0xf2,
+				    0x0b, 0x64, 0x8c, 0x57,
+				    0xb5, 0x0a, 0xb2, 0xd2,
+				    0x21, 0xd3, 0x66, 0xa5},
+	},
+	.conn_id_len = 8,
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "2001::2",
+	.server_port = 7675,
+	.plain = { 0x40, 0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12,
+		   0x49, 0xca,
+		   // Payload
+		   0x02, 0x80, 0xde, 0x40, 0x39, 0x40, 0xf6, 0x00,
+		   0x01, 0x0b, 0x00, 0x0f, 0x65, 0x63, 0x68, 0x6f,
+		   0x20, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36,
+		   0x37, 0x38, 0x39
+	},
+	.plain_len = 37,
+	.match = {
+		   0x46, 0x08, 0x6b, 0xbf, 0x88, 0x82, 0xb9, 0x12,
+		   0x49, 0x1c, 0x44, 0xb8, 0x41, 0xbb, 0xcf, 0x6e,
+		   0x0a, 0x2a, 0x24, 0xfb, 0xb4, 0x79, 0x62, 0xea,
+		   0x59, 0x38, 0x1a, 0x0e, 0x50, 0x1e, 0x59, 0xed,
+		   0x3f, 0x8e, 0x7e, 0x5a, 0x70, 0xe4, 0x2a, 0xbc,
+		   0x2a, 0xfa, 0x2b, 0x54, 0xeb, 0x89, 0xc3, 0x2c,
+		   0xb6, 0x8c, 0x1e, 0xab, 0x2d
+	},
+	.match_len = 53,
+	.next_pkt_num = 0x0d65c9,
+};
+
+FIXTURE_VARIANT_ADD(quic_crypto, ipv6_chacha20_poly1305)
+{
+	.af_client = AF_INET6,
+	.client_address = "2001::1",
+	.client_port = 7803,
+	.algo = TLS_CIPHER_CHACHA20_POLY1305,
+	.conn_key_len = 32,
+	.conn_id = {},
+	.conn_id_len = 0,
+	.conn_key = {
+		.conn_key_32 = {
+			0x3b, 0xfc, 0xdd, 0xd7, 0x2b, 0xcf, 0x02, 0x54,
+			0x1d, 0x7f, 0xa0, 0xdd, 0x1f, 0x5f, 0x9e, 0xee,
+			0xa8, 0x17, 0xe0, 0x9a, 0x69, 0x63, 0xa0, 0xe6,
+			0xc7, 0xdf, 0x0f, 0x9a, 0x1b, 0xab, 0x90, 0xf2,
+		},
+	},
+	.conn_iv = {
+		0xa6, 0xb5, 0xbc, 0x6a, 0xb7, 0xda, 0xfc, 0xe3,
+		0x0f, 0xff, 0xf5, 0xdd,
+	},
+	.conn_hdr_key = {
+		.conn_hdr_key_32 = {
+			0xd6, 0x59, 0x76, 0x0d, 0x2b, 0xa4, 0x34, 0xa2,
+			0x26, 0xfd, 0x37, 0xb3, 0x5c, 0x69, 0xe2, 0xda,
+			0x82, 0x11, 0xd1, 0x0c, 0x4f, 0x12, 0x53, 0x87,
+			0x87, 0xd6, 0x56, 0x45, 0xd5, 0xd1, 0xb8, 0xe2,
+		},
+	},
+	.setup_flow = SETUP_FLOW,
+	.use_client = USE_CLIENT,
+	.af_server = AF_INET6,
+	.server_address = "2001::2",
+	.server_port = 7804,
+	.plain = { 0x42, 0x00, 0xbf, 0xf4, 0x01 },
+	.plain_len = 5,
+	.match = { 0x55, 0x58, 0xb1, 0xc6, 0x0a, 0xe7, 0xb6, 0xb9,
+		   0x32, 0xbc, 0x27, 0xd7, 0x86, 0xf4, 0xbc, 0x2b,
+		   0xb2, 0x0f, 0x21, 0x62, 0xba },
+	.match_len = 21,
+	.next_pkt_num = 0x2700bff5,
+};
+
+TEST_F(quic_crypto, encrypt_test_vector_single_flow_gso_in_control)
+{
+	uint8_t cmsg_buf[CMSG_SPACE(sizeof(struct quic_tx_ancillary_data))
+			 + CMSG_SPACE(sizeof(uint16_t))];
+	struct quic_tx_ancillary_data *anc_data;
+	struct quic_connection_info conn_info;
+	uint16_t frag_size = 1200;
+	struct cmsghdr *cmsg_hdr;
+	int wrong_frag_size = 26;
+	socklen_t recv_addr_len;
+	struct iovec iov;
+	struct msghdr msg;
+	char *buf;
+
+	buf = (char *)malloc(9000);
+	conn_info.cipher_type = variant->algo;
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = variant->conn_id_len;
+	memcpy(conn_info.key.conn_id,
+	       &variant->conn_id,
+	       variant->conn_id_len);
+	ASSERT_TRUE(variant->algo == TLS_CIPHER_AES_GCM_128 ||
+		    variant->algo == TLS_CIPHER_CHACHA20_POLY1305);
+	switch (variant->algo) {
+	case TLS_CIPHER_AES_GCM_128:
+		memcpy(&conn_info.aes_gcm_128.payload_key,
+		       &variant->conn_key, 16);
+		memcpy(&conn_info.aes_gcm_128.payload_iv,
+		       &variant->conn_iv, 12);
+		memcpy(&conn_info.aes_gcm_128.header_key,
+		       &variant->conn_hdr_key, 16);
+		break;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		memcpy(&conn_info.chacha20_poly1305.payload_key,
+		       &variant->conn_key, 32);
+		memcpy(&conn_info.chacha20_poly1305.payload_iv,
+		       &variant->conn_iv, 12);
+		memcpy(&conn_info.chacha20_poly1305.header_key,
+		       &variant->conn_hdr_key, 32);
+		break;
+	}
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &wrong_frag_size,
+			     sizeof(wrong_frag_size)), 0);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+
+	recv_addr_len = self->len_c;
+	iov.iov_base = (void *)variant->plain;
+	iov.iov_len = variant->plain_len;
+	memset(cmsg_buf, 0, sizeof(cmsg_buf));
+	msg.msg_name = (self->client.addr.sin_family == AF_INET)
+		       ? (void *)&self->client.addr
+		       : (void *)&self->client.addr6;
+	msg.msg_namelen = self->len_c;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(sizeof(struct quic_tx_ancillary_data));
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->flags = 0;
+	anc_data->next_pkt_num = variant->next_pkt_num;
+	anc_data->conn_id_length = variant->conn_id_len;
+	cmsg_hdr = CMSG_NXTHDR(&msg, cmsg_hdr);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_SEGMENT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(sizeof(uint16_t));
+	memcpy(CMSG_DATA(cmsg_hdr), (void *)&frag_size, sizeof(frag_size));
+
+	EXPECT_EQ(sendmsg(self->sfd, &msg, 0), variant->plain_len);
+	ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+	if (variant->af_client == AF_INET) {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr, &recv_addr_len),
+			  variant->match_len);
+	} else {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr6, &recv_addr_len),
+			  variant->match_len);
+	}
+	EXPECT_STREQ(buf, variant->match);
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+	free(buf);
+	ASSERT_NE(setns(self->default_net_ns_fd, 0), -1);
+}
+
+TEST_F(quic_crypto, encrypt_test_vector_single_flow_gso_in_setsockopt)
+{
+	uint8_t cmsg_buf[CMSG_SPACE(sizeof(struct quic_tx_ancillary_data))];
+	struct quic_tx_ancillary_data *anc_data;
+	struct quic_connection_info conn_info;
+	int frag_size = 1200;
+	struct cmsghdr *cmsg_hdr;
+	socklen_t recv_addr_len;
+	struct iovec iov;
+	struct msghdr msg;
+	char *buf;
+
+	buf = (char *)malloc(9000);
+	conn_info.cipher_type = variant->algo;
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = variant->conn_id_len;
+	memcpy(conn_info.key.conn_id,
+	       &variant->conn_id,
+	       variant->conn_id_len);
+	ASSERT_TRUE(variant->algo == TLS_CIPHER_AES_GCM_128 ||
+		    variant->algo == TLS_CIPHER_CHACHA20_POLY1305);
+	switch (variant->algo) {
+	case TLS_CIPHER_AES_GCM_128:
+		memcpy(&conn_info.aes_gcm_128.payload_key,
+		       &variant->conn_key, 16);
+		memcpy(&conn_info.aes_gcm_128.payload_iv,
+		       &variant->conn_iv, 12);
+		memcpy(&conn_info.aes_gcm_128.header_key,
+		       &variant->conn_hdr_key, 16);
+		break;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		memcpy(&conn_info.chacha20_poly1305.payload_key,
+		       &variant->conn_key, 32);
+		memcpy(&conn_info.chacha20_poly1305.payload_iv,
+		       &variant->conn_iv, 12);
+		memcpy(&conn_info.chacha20_poly1305.header_key,
+		       &variant->conn_hdr_key, 32);
+		break;
+	}
+
+	ASSERT_NE(setns(self->server_net_ns_fd, 0), -1);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
+			     sizeof(frag_size)), 0);
+	ASSERT_EQ(setsockopt(self->sfd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION,
+			     &conn_info, sizeof(conn_info)), 0);
+
+	recv_addr_len = self->len_c;
+	iov.iov_base = (void *)variant->plain;
+	iov.iov_len = variant->plain_len;
+	memset(cmsg_buf, 0, sizeof(cmsg_buf));
+	msg.msg_name = (self->client.addr.sin_family == AF_INET)
+		       ? (void *)&self->client.addr
+		       : (void *)&self->client.addr6;
+	msg.msg_namelen = self->len_c;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(sizeof(struct quic_tx_ancillary_data));
+	anc_data = (struct quic_tx_ancillary_data *)CMSG_DATA(cmsg_hdr);
+	anc_data->flags = 0;
+	anc_data->next_pkt_num = variant->next_pkt_num;
+	anc_data->conn_id_length = variant->conn_id_len;
+
+	EXPECT_EQ(sendmsg(self->sfd, &msg, 0), variant->plain_len);
+	ASSERT_NE(setns(self->client_net_ns_fd, 0), -1);
+	if (variant->af_client == AF_INET) {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr, &recv_addr_len),
+			  variant->match_len);
+	} else {
+		EXPECT_EQ(recvfrom(self->cfd, buf, 9000, 0,
+				   &self->client.addr6, &recv_addr_len),
+			  variant->match_len);
+	}
+	EXPECT_STREQ(buf, variant->match);
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
index 000000000000..8ff8bc494671
--- /dev/null
+++ b/tools/testing/selftests/net/quic.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
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

