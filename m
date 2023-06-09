Return-Path: <netdev+bounces-9621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D216C72A06A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91F722819A6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28E019E59;
	Fri,  9 Jun 2023 16:43:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17AC19E52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:43 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EEEF5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:43:41 -0700 (PDT)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 81C273F0F8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686329018;
	bh=C88w+6qUNZ4o8QU4MF6cbHvjs9SCcqgrH5QPb8qWgeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=U/YQvqnhUoKLfbWuqxmpiCIXVPd2CDHWRrV7+K+ozD9yeK/H58W9J46QdjOVWb4J3
	 fnrfX4KBNvRbkmD4o1ijg5M9YSfOLqEJCCaVmRk6RoLnCDQppl2Ua3zX7UgyYJaipF
	 iyp4vqU2iIBxmzm4OwAHMVFVrqWD8bEi6k9FmalvwMOsCsc9f0XmybCqiPUJoeQc3c
	 i6Kh8DiGGu+ALvfN9JzyfeAVSF8MMqUE/mAPv2FxITNd+5UsntIRtpSbznglggefdr
	 I+V58eOCi+i+vM2dxN8k1RZ0Ro/KYu/Xuh6w/ULd+M0kUPhDujEKiiNJWhUMBQM98S
	 r4Dr3WcctCCgA==
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-55a1045c2bbso1733489eaf.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686329017; x=1688921017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C88w+6qUNZ4o8QU4MF6cbHvjs9SCcqgrH5QPb8qWgeM=;
        b=EcyH2NaLgTa06XAPFnvY2TGtNrq7pEWUdP97Ttiu5KGbCt6vdD8QPcDo5weh/ulJEZ
         RRGU8SHA0y5zpWV+yn1km5s9mq+OikPGgdJDmJAxpndRkdALIhcBakDEVHa2IUVYQDmC
         lYFBsrhopE78dz8Jqe8CZJQqRVR8JL8ykNDRbVRk+8A5/uHhE47LsUPhnpsI5SQloESJ
         61DS+f3NuEH8/toe4ljCyCmmQbj4DK9ayw0Uv/hQk8I6kSwWNgxDLeJPCcJcRCR/fReI
         qsKqnhOg8JsXBydb0zDCrQM0y366az834fk/XxYN97BbCuA+ITjlpANz02f5GV3QL/FV
         1wWg==
X-Gm-Message-State: AC+VfDzWbEGnLDcIpdp96IYfyasQBnMwXoRu9AFsJiSgSOlplYU8lKuE
	IACEHvY6ib2EvM+jmBPtiDHTk7DHkv333/Ttwqm+hmRptLqMFGeHbwOFp4oGACcNVnkd23BbbFY
	M6go8QHCNTaqqJkM2jNudugoEVc8ttZiy0w==
X-Received: by 2002:a05:6870:7304:b0:1a2:c29a:29ad with SMTP id q4-20020a056870730400b001a2c29a29admr1874723oal.0.1686329016993;
        Fri, 09 Jun 2023 09:43:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4SZgmMeYg9SaTfI8/LPvB5TGmD63kB5M9UrAOoKmOjU0OpJie/syYn/pXZwfeY0DaoyYZYnQ==
X-Received: by 2002:a05:6870:7304:b0:1a2:c29a:29ad with SMTP id q4-20020a056870730400b001a2c29a29admr1874705oal.0.1686329016688;
        Fri, 09 Jun 2023 09:43:36 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:db64:8f3b:3c73:e436])
        by smtp.gmail.com with ESMTPSA id g17-20020a056870c39100b001726cfeea97sm2360707oao.29.2023.06.09.09.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:43:36 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	vfedorenko@novek.ru,
	tianjia.zhang@linux.alibaba.com
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] selftests: net: tls: check if FIPS mode is enabled
Date: Fri,  9 Jun 2023 13:43:22 -0300
Message-Id: <20230609164324.497813-2-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609164324.497813-1-magali.lemes@canonical.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TLS selftests use the ChaCha20-Poly1305 and SM4 algorithms, which are not
FIPS compliant. When fips=1, this set of tests fails. Add a check and only
run these tests if not in FIPS mode.

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Fixes: e506342a03c7 ("selftests/tls: add SM4 GCM/CCM to tls selftests")
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
Changes in v2:
 - Put fips_non_compliant into the variants.
 - Turn fips_enabled into a static global variable.
 - Read /proc/sys/crypto/fips_enabled only once at main().

 tools/testing/selftests/net/tls.c | 175 +++++++++++++++++++++++++++++-
 1 file changed, 174 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e699548d4247..0725c60f227c 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,8 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+static int fips_enabled = 0;
+
 struct tls_crypto_info_keys {
 	union {
 		struct tls12_crypto_info_aes_gcm_128 aes128;
@@ -235,7 +237,7 @@ FIXTURE_VARIANT(tls)
 {
 	uint16_t tls_version;
 	uint16_t cipher_type;
-	bool nopad;
+	bool nopad, fips_non_compliant;
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_aes_gcm)
@@ -254,24 +256,28 @@ FIXTURE_VARIANT_ADD(tls, 12_chacha)
 {
 	.tls_version = TLS_1_2_VERSION,
 	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_chacha)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_sm4_gcm)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_SM4_GCM,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_SM4_CCM,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_aes_ccm)
@@ -311,6 +317,9 @@ FIXTURE_SETUP(tls)
 	int one = 1;
 	int ret;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		return;
+
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
 			     &tls12);
 
@@ -343,6 +352,9 @@ TEST_F(tls, sendfile)
 	int filefd = open("/proc/self/exe", O_RDONLY);
 	struct stat st;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_GE(filefd, 0);
 	fstat(filefd, &st);
 	EXPECT_GE(sendfile(self->fd, filefd, 0, st.st_size), 0);
@@ -357,6 +369,9 @@ TEST_F(tls, send_then_sendfile)
 	struct stat st;
 	char *buf;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_GE(filefd, 0);
 	fstat(filefd, &st);
 	buf = (char *)malloc(st.st_size);
@@ -406,6 +421,10 @@ static void chunked_sendfile(struct __test_metadata *_metadata,
 
 TEST_F(tls, multi_chunk_sendfile)
 {
+
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	chunked_sendfile(_metadata, self, 4096, 4096);
 	chunked_sendfile(_metadata, self, 4096, 0);
 	chunked_sendfile(_metadata, self, 4096, 1);
@@ -433,6 +452,9 @@ TEST_F(tls, recv_max)
 	char recv_mem[TLS_PAYLOAD_MAX_LEN];
 	char buf[TLS_PAYLOAD_MAX_LEN];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(buf, sizeof(buf));
 
 	EXPECT_GE(send(self->fd, buf, send_len, 0), 0);
@@ -446,6 +468,9 @@ TEST_F(tls, recv_small)
 	int send_len = 10;
 	char buf[10];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	send_len = strlen(test_str) + 1;
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
@@ -458,6 +483,9 @@ TEST_F(tls, msg_more)
 	int send_len = 10;
 	char buf[10 * 2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -472,6 +500,9 @@ TEST_F(tls, msg_more_unsent)
 	int send_len = 10;
 	char buf[10];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
 }
@@ -485,6 +516,9 @@ TEST_F(tls, sendmsg_single)
 	struct iovec vec;
 	char buf[13];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	vec.iov_base = (char *)test_str;
 	vec.iov_len = send_len;
 	memset(&msg, 0, sizeof(struct msghdr));
@@ -505,6 +539,9 @@ TEST_F(tls, sendmsg_fragmented)
 	struct msghdr msg;
 	int i, frags;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	for (frags = 1; frags <= MAX_FRAGS; frags++) {
 		for (i = 0; i < frags; i++) {
 			vec[i].iov_base = (char *)test_str;
@@ -536,6 +573,9 @@ TEST_F(tls, sendmsg_large)
 	size_t recvs = 0;
 	size_t sent = 0;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	while (sent++ < sends) {
 		struct iovec vec = { (void *)mem, send_len };
@@ -564,6 +604,9 @@ TEST_F(tls, sendmsg_multiple)
 	char *buf;
 	int i;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	for (i = 0; i < iov_len; i++) {
 		test_strs[i] = (char *)malloc(strlen(test_str) + 1);
@@ -601,6 +644,9 @@ TEST_F(tls, sendmsg_multiple_stress)
 	int len_cmp = 0;
 	int i;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	for (i = 0; i < iov_len; i++) {
 		test_strs[i] = (char *)malloc(strlen(test_str) + 1);
@@ -629,6 +675,9 @@ TEST_F(tls, splice_from_pipe)
 	char mem_recv[TLS_PAYLOAD_MAX_LEN];
 	int p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_GE(write(p[1], mem_send, send_len), 0);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), 0);
@@ -644,6 +693,9 @@ TEST_F(tls, splice_from_pipe2)
 	int p2[2];
 	int p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -666,6 +718,9 @@ TEST_F(tls, send_and_splice)
 	char buf[10];
 	int p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, test_str, send_len2, 0), send_len2);
 	EXPECT_EQ(recv(self->cfd, buf, send_len2, MSG_WAITALL), send_len2);
@@ -685,6 +740,9 @@ TEST_F(tls, splice_to_pipe)
 	char mem_recv[TLS_PAYLOAD_MAX_LEN];
 	int p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -705,6 +763,9 @@ TEST_F(tls, splice_cmsg_to_pipe)
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
@@ -728,6 +789,9 @@ TEST_F(tls, splice_dec_cmsg_to_pipe)
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
@@ -748,6 +812,9 @@ TEST_F(tls, recv_and_splice)
 	int half = send_len / 2;
 	int p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
 	/* Recv hald of the record, splice the other half */
@@ -766,6 +833,9 @@ TEST_F(tls, peek_and_splice)
 	int chunk = TLS_PAYLOAD_MAX_LEN / 4;
 	int n, i, p[2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -797,6 +867,9 @@ TEST_F(tls, recvmsg_single)
 	struct msghdr hdr;
 	struct iovec vec;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&hdr, 0, sizeof(hdr));
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	vec.iov_base = (char *)buf;
@@ -815,6 +888,9 @@ TEST_F(tls, recvmsg_single_max)
 	struct iovec vec;
 	struct msghdr hdr;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_EQ(send(self->fd, send_mem, send_len, 0), send_len);
@@ -840,6 +916,9 @@ TEST_F(tls, recvmsg_multiple)
 
 	memrnd(buf, sizeof(buf));
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, buf, send_len, 0), send_len);
 	for (i = 0; i < msg_iovlen; i++) {
 		iov_base[i] = (char *)malloc(iov_len);
@@ -862,6 +941,9 @@ TEST_F(tls, single_send_multiple_recv)
 	char send_mem[TLS_PAYLOAD_MAX_LEN * 2];
 	char recv_mem[TLS_PAYLOAD_MAX_LEN * 2];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
@@ -879,6 +961,9 @@ TEST_F(tls, multiple_send_single_recv)
 	char recv_mem[2 * 10];
 	char send_mem[10];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, send_len, 0), 0);
@@ -897,6 +982,9 @@ TEST_F(tls, single_send_multiple_recv_non_align)
 	char recv_mem[recv_len * 2];
 	char send_mem[total_len];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
@@ -915,6 +1003,9 @@ TEST_F(tls, recv_partial)
 	int send_len = strlen(test_str) + 1;
 	char recv_mem[18];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(recv_mem, 0, sizeof(recv_mem));
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_NE(recv(self->cfd, recv_mem, strlen(test_str_first),
@@ -932,6 +1023,9 @@ TEST_F(tls, recv_nonblock)
 	char buf[4096];
 	bool err;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_DONTWAIT), -1);
 	err = (errno == EAGAIN || errno == EWOULDBLOCK);
 	EXPECT_EQ(err, true);
@@ -943,6 +1037,9 @@ TEST_F(tls, recv_peek)
 	int send_len = strlen(test_str) + 1;
 	char buf[15];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_PEEK), send_len);
 	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
@@ -959,6 +1056,9 @@ TEST_F(tls, recv_peek_multiple)
 	char buf[15];
 	int i;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	for (i = 0; i < num_peeks; i++) {
 		EXPECT_NE(recv(self->cfd, buf, send_len, MSG_PEEK), -1);
@@ -977,6 +1077,9 @@ TEST_F(tls, recv_peek_multiple_records)
 	int len;
 	char buf[64];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	len = strlen(test_str_first);
 	EXPECT_EQ(send(self->fd, test_str_first, len, 0), len);
 
@@ -1026,6 +1129,9 @@ TEST_F(tls, recv_peek_large_buf_mult_recs)
 	int len;
 	char buf[64];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	len = strlen(test_str_first);
 	EXPECT_EQ(send(self->fd, test_str_first, len, 0), len);
 
@@ -1046,6 +1152,9 @@ TEST_F(tls, recv_lowat)
 	char recv_mem[20];
 	int lowat = 8;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, send_mem, 10, 0), 10);
 	EXPECT_EQ(send(self->fd, send_mem, 5, 0), 5);
 
@@ -1067,6 +1176,9 @@ TEST_F(tls, bidir)
 	char buf[10];
 	int ret;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	if (!self->notls) {
 		struct tls_crypto_info_keys tls12;
 
@@ -1102,6 +1214,9 @@ TEST_F(tls, pollin)
 	char buf[10];
 	int send_len = 10;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
@@ -1120,6 +1235,9 @@ TEST_F(tls, poll_wait)
 	struct pollfd fd = { 0, 0, 0 };
 	char recv_mem[15];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -1135,6 +1253,9 @@ TEST_F(tls, poll_wait_split)
 	char send_mem[20] = {};
 	char recv_mem[15];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
 	/* Send 20 bytes */
@@ -1160,6 +1281,9 @@ TEST_F(tls, blocking)
 	size_t data = 100000;
 	int res = fork();
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_NE(res, -1);
 
 	if (res) {
@@ -1202,6 +1326,9 @@ TEST_F(tls, nonblocking)
 	int flags;
 	int res;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	flags = fcntl(self->fd, F_GETFL, 0);
 	fcntl(self->fd, F_SETFL, flags | O_NONBLOCK);
 	fcntl(self->cfd, F_SETFL, flags | O_NONBLOCK);
@@ -1343,31 +1470,49 @@ test_mutliproc(struct __test_metadata *_metadata, struct _test_data_tls *self,
 
 TEST_F(tls, mutliproc_even)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 6, 6);
 }
 
 TEST_F(tls, mutliproc_readers)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 4, 12);
 }
 
 TEST_F(tls, mutliproc_writers)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 10, 2);
 }
 
 TEST_F(tls, mutliproc_sendpage_even)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 6, 6);
 }
 
 TEST_F(tls, mutliproc_sendpage_readers)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 4, 12);
 }
 
 TEST_F(tls, mutliproc_sendpage_writers)
 {
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 10, 2);
 }
 
@@ -1378,6 +1523,9 @@ TEST_F(tls, control_msg)
 	int send_len = 10;
 	char buf[10];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
@@ -1406,6 +1554,9 @@ TEST_F(tls, shutdown)
 	int send_len = 10;
 	char buf[10];
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_EQ(strlen(test_str) + 1, send_len);
 
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -1421,6 +1572,9 @@ TEST_F(tls, shutdown_unsent)
 	char const *test_str = "test_read";
 	int send_len = 10;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 
 	shutdown(self->fd, SHUT_RDWR);
@@ -1432,6 +1586,9 @@ TEST_F(tls, shutdown_reuse)
 	struct sockaddr_in addr;
 	int ret;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	shutdown(self->fd, SHUT_RDWR);
 	shutdown(self->cfd, SHUT_RDWR);
 	close(self->cfd);
@@ -1865,4 +2022,20 @@ TEST(prequeue) {
 	close(cfd);
 }
 
+#define main test_main
 TEST_HARNESS_MAIN
+#undef main
+int main(int argc, char **argv) {
+	int res;
+	FILE *f;
+
+	f = fopen("/proc/sys/crypto/fips_enabled", "r");
+	if (f) {
+		res = fscanf(f, "%d", &fips_enabled);
+		if (res != 1)
+			ksft_print_msg("ERROR: Couldn't read /proc/sys/crypto/fips_enabled\n");
+		fclose(f);
+	}
+
+	return test_main(argc, argv);
+}
-- 
2.34.1


