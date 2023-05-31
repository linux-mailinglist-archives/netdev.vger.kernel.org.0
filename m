Return-Path: <netdev+bounces-6643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0F67172A8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E8A1281415
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81AC1C3A;
	Wed, 31 May 2023 00:36:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73E91C39
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:36:08 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0295E11F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:38 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2b42a8f9so4060849b3a.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493318; x=1688085318;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfBI8GoEpVlIoOUgpQuqqFCS5QSMelByqywlut0pb20=;
        b=VzucnSGsJ49XLS4N1NOKMtpCRHPq6CS/W1H7K1TOLZJvPtSpigWylFkJ0WU7yGHIUn
         R03JHuoSZvgCZaDI8mn8IIv3crINMeKre4VcZJmNNc4djYZG4ZmhWYhbY5PgptmobjLB
         IRugczYR2QcPNNpap6U55Sp2YHwPlC4w2cDCXFQRBCDJ3doerRTo1HZ/OZ2qnn+/ou15
         1vh2+H7jQgmdHhVcn4KHfxT0suhIiSig5+iO+6qT8sBjAulYXY5PIsKoLx1f9R0gIXex
         NU1eAel7ANGKFDCR35Fp1khuboK0HBqmthp+6CVsZuNLP7WMevvedgxXwyL43kZNDZnp
         KkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493318; x=1688085318;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfBI8GoEpVlIoOUgpQuqqFCS5QSMelByqywlut0pb20=;
        b=Z9yz78x4wZSA/jX+p/1OyacKWK/46w08NwXB3D1teS0IB7O7VzK3DP27//y25V3aXq
         UXNnRm7z2VoobM/smeJkqYxHGQDdCj/zqE5eJcZiHJLdwdsV3CZNlmoETKEujrJqNZCN
         QHf23+/HtrkFCIZ7dbg3MX2WqJMzNQFFMG19BjPE1hmZvjqE+Y5CeLy1ZQLaLouhdyO/
         iYctJR4kxji/Y68tytr56szJfTztglN6ot0uLpvtsBg1LoE0zikiQDpRByIxV5SkhM+Y
         Aefv/hRO89OlMFSgVsLA6e0rYeuF6NM6P61Rd28km6MeAgWV2RxoCeTNbjshLnCze6Kk
         QabA==
X-Gm-Message-State: AC+VfDxO5+i5rfiz37Y76PactvrxT2CJYNSPT733OGI04+cBUtbB9py0
	OrjiRapNsvKJ6Cu281IvfS4Bgg==
X-Google-Smtp-Source: ACHHUZ6NA47klTzwNw6SjuHQBc5vekDbSGZcUnMalNmVHVKblFxKyslaT2n+PHFjJTUq0u6LElzAIw==
X-Received: by 2002:a05:6a00:b95:b0:64f:4d1d:32ba with SMTP id g21-20020a056a000b9500b0064f4d1d32bamr4796833pfj.5.1685493318115;
        Tue, 30 May 2023 17:35:18 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:17 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Wed, 31 May 2023 00:35:12 +0000
Subject: [PATCH RFC net-next v3 8/8] tests: add vsock dgram tests
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-8-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, 
 Vishnu Dasa <vdasa@vmware.com>, 
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>, 
 Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiang Wang <jiang.wang@bytedance.com>

This patch adds tests for vsock datagram.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 tools/testing/vsock/util.c       | 105 +++++++++++++++++++++
 tools/testing/vsock/util.h       |   4 +
 tools/testing/vsock/vsock_test.c | 193 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 01b636d3039a..45e35da48b40 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -260,6 +260,57 @@ void send_byte(int fd, int expected_ret, int flags)
 	}
 }
 
+/* Transmit one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
+		 int flags)
+{
+	const uint8_t byte = 'A';
+	ssize_t nwritten;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nwritten = sendto(fd, &byte, sizeof(byte), flags, dest_addr,
+				  len);
+		timeout_check("write");
+	} while (nwritten < 0 && errno == EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nwritten != -1) {
+			fprintf(stderr, "bogus sendto(2) return value %zd\n",
+				nwritten);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("write");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nwritten < 0) {
+		perror("write");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten == 0) {
+		if (expected_ret == 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while sending byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten != sizeof(byte)) {
+		fprintf(stderr, "bogus sendto(2) return value %zd\n", nwritten);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /* Receive one byte and check the return value.
  *
  * expected_ret:
@@ -313,6 +364,60 @@ void recv_byte(int fd, int expected_ret, int flags)
 	}
 }
 
+/* Receive one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
+		   int expected_ret, int flags)
+{
+	uint8_t byte;
+	ssize_t nread;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nread = recvfrom(fd, &byte, sizeof(byte), flags, src_addr, addrlen);
+		timeout_check("read");
+	} while (nread < 0 && errno == EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nread != -1) {
+			fprintf(stderr, "bogus recvfrom(2) return value %zd\n",
+				nread);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("read");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nread < 0) {
+		perror("read");
+		exit(EXIT_FAILURE);
+	}
+	if (nread == 0) {
+		if (expected_ret == 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while receiving byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nread != sizeof(byte)) {
+		fprintf(stderr, "bogus recvfrom(2) return value %zd\n", nread);
+		exit(EXIT_FAILURE);
+	}
+	if (byte != 'A') {
+		fprintf(stderr, "unexpected byte read %c\n", byte);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /* Run test cases.  The program terminates if a failure occurs. */
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts)
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index fb99208a95ea..6e5cd610bf05 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -43,7 +43,11 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
 void send_byte(int fd, int expected_ret, int flags);
+void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
+		 int flags);
 void recv_byte(int fd, int expected_ret, int flags);
+void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
+		   int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
 void list_tests(const struct test_case *test_cases);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..851c3d65178d 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -202,6 +202,113 @@ static void test_stream_server_close_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_dgram_sendto_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int fd;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	sendto_byte(fd, &addr.sa, sizeof(addr.svm), 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_sendto_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	int fd;
+	int len = sizeof(addr.sa);
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	recvfrom_byte(fd, &addr.sa, &len, 1, 0);
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_connect_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int fd;
+	int ret;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = connect(fd, &addr.sa, sizeof(addr.svm));
+	if (ret < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_connect_server(const struct test_opts *opts)
+{
+	test_dgram_sendto_server(opts);
+}
+
 /* With the standard socket sizes, VMCI is able to support about 100
  * concurrent stream connections.
  */
@@ -255,6 +362,77 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 		close(fds[i]);
 }
 
+static void test_dgram_multiconn_client(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		fds[i] = socket(AF_VSOCK, SOCK_DGRAM, 0);
+		if (fds[i] < 0) {
+			perror("socket");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		sendto_byte(fds[i], &addr.sa, sizeof(addr.svm), 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_dgram_multiconn_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	int fd;
+	int len = sizeof(addr.sa);
+	int i;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		recvfrom_byte(fd, &addr.sa, &len, 1, 0);
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
 static void test_stream_msg_peek_client(const struct test_opts *opts)
 {
 	int fd;
@@ -1128,6 +1306,21 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_DGRAM client close",
+		.run_client = test_dgram_sendto_client,
+		.run_server = test_dgram_sendto_server,
+	},
+	{
+		.name = "SOCK_DGRAM client connect",
+		.run_client = test_dgram_connect_client,
+		.run_server = test_dgram_connect_server,
+	},
+	{
+		.name = "SOCK_DGRAM multiple connections",
+		.run_client = test_dgram_multiconn_client,
+		.run_server = test_dgram_multiconn_server,
+	},
 	{},
 };
 

-- 
2.30.2


