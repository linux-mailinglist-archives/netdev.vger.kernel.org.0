Return-Path: <netdev+bounces-8985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF127267A8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B55D281220
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A8A38CB8;
	Wed,  7 Jun 2023 17:43:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583961772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:22 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFF61FD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:43:17 -0700 (PDT)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 165DF3F0F8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686159795;
	bh=bh70dEDRfbjXT/ngJKXaFl7q3s6RJ+sr2Nrb8AyrZUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=g7aFjYXmoTZv6yYuqBWiMhhV99u0KnlzD/28NoBeMs8w8kifWiPpyUs2m7tQU16Np
	 xStBHtwKK0QWdaOYuSKcYSF6oxNsyI5S7MZKyUxgy732uWOhUxUe/2O78lvAlBgbzR
	 uF/w9rNcomf72YLDZPYoay5fb1x4nUy67yuBP2ayGWhFAVUwgE9MJ3onPfh58yEgDH
	 tvC0bU0Cyt6Bn0puqN2TuK6bXPd2is7FCdHNZDSe7HEpckg1ZNaYQV2djt97qhod3v
	 5ZWSqBQBmm3v5Hy+fOdY+NpRQ1YXdaYmBy3pE0Bp417ZnnbiYGj5UUu/Jr9fbtxrYu
	 JX98kpbNOx/jA==
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6af6e80d24aso6998040a34.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159794; x=1688751794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bh70dEDRfbjXT/ngJKXaFl7q3s6RJ+sr2Nrb8AyrZUE=;
        b=TAP/Pdg90BG9RVIF/ru00Fhhs0bcp98aW67TGiIfEyDN4fy4K8NfNWD46gEYzM48Ne
         7TQLZ/zwdgiBspLq/PkKw39t2EhSWuarb3Xi8g5HoqWwrcL/7kj/O5HNlAcuSO662Ji3
         ZKAdZfen1kVIqKUMTHeOl9Q7F/0neI5GK32uDM1Zt6Nct24X2aw00X6bHeNqZXiYh31R
         HwoEw60AdIOj2UWkPlCRiKfcofPywRUP5JqHy+K8NVWJ27op0jV2oydAIrh2X38DmeZZ
         sDejWU7Nh/6Y8NA9HeWa3jLRgLHk8xEZHfYE8nvl460IbHHlJ3lTmy1TmTpbjQEjNnHm
         xs8g==
X-Gm-Message-State: AC+VfDwxJXHsK02N2qsmBCMKsOZ1tQ6lSI9Q6guLSVEjGrTXNHJvXD0M
	0x6XI8wY9oYUNfxDn/j/SnRbMbBrBod2+xjUk8kfz61AsHVIKbU2KKqikcpiyBmOjoJV/lHu/Hv
	tw+WfbaNU4arPcRKPD4eSo93bSrt+9x+RWw==
X-Received: by 2002:a9d:745a:0:b0:6b2:930e:ba3d with SMTP id p26-20020a9d745a000000b006b2930eba3dmr6075120otk.2.1686159793710;
        Wed, 07 Jun 2023 10:43:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7ZtormhkemcZN2J0MYPakjTR6dWJVfNLeGEjYrQ7Y0wKdH/n23gGjbwMoeCyXHrtMbGG6OtA==
X-Received: by 2002:a9d:745a:0:b0:6b2:930e:ba3d with SMTP id p26-20020a9d745a000000b006b2930eba3dmr6075101otk.2.1686159793352;
        Wed, 07 Jun 2023 10:43:13 -0700 (PDT)
Received: from mingau.. ([2804:7f0:b443:8cea:efdc:2496:54f7:d884])
        by smtp.gmail.com with ESMTPSA id c10-20020a9d75ca000000b006ac75cff491sm2176016otl.3.2023.06.07.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:43:12 -0700 (PDT)
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
Subject: [PATCH net 1/3] selftests: net: tls: check if FIPS mode is enabled
Date: Wed,  7 Jun 2023 14:43:00 -0300
Message-Id: <20230607174302.19542-2-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607174302.19542-1-magali.lemes@canonical.com>
References: <20230607174302.19542-1-magali.lemes@canonical.com>
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
 tools/testing/selftests/net/tls.c | 265 +++++++++++++++++++++++++++++-
 1 file changed, 263 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e699548d4247..44cb145a32fd 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -227,7 +227,7 @@ TEST_F(tls_basic, base_base)
 
 FIXTURE(tls)
 {
-	int fd, cfd;
+	int fd, cfd, fips_enabled;
 	bool notls;
 };
 
@@ -309,7 +309,22 @@ FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
 	int one = 1;
-	int ret;
+	int ret, res;
+	FILE *f;
+
+	self->fips_enabled = 0;
+	f = fopen("/proc/sys/crypto/fips_enabled", "r");
+	if (f) {
+		res = fscanf(f, "%d", &self->fips_enabled);
+		if (res != 1)
+			ksft_print_msg("ERROR: Couldn't read /proc/sys/crypto/fips_enabled\n");
+		fclose(f);
+	}
+
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		return;
 
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
 			     &tls12);
@@ -343,6 +358,11 @@ TEST_F(tls, sendfile)
 	int filefd = open("/proc/self/exe", O_RDONLY);
 	struct stat st;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_GE(filefd, 0);
 	fstat(filefd, &st);
 	EXPECT_GE(sendfile(self->fd, filefd, 0, st.st_size), 0);
@@ -357,6 +377,11 @@ TEST_F(tls, send_then_sendfile)
 	struct stat st;
 	char *buf;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_GE(filefd, 0);
 	fstat(filefd, &st);
 	buf = (char *)malloc(st.st_size);
@@ -406,6 +431,12 @@ static void chunked_sendfile(struct __test_metadata *_metadata,
 
 TEST_F(tls, multi_chunk_sendfile)
 {
+
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	chunked_sendfile(_metadata, self, 4096, 4096);
 	chunked_sendfile(_metadata, self, 4096, 0);
 	chunked_sendfile(_metadata, self, 4096, 1);
@@ -433,6 +464,11 @@ TEST_F(tls, recv_max)
 	char recv_mem[TLS_PAYLOAD_MAX_LEN];
 	char buf[TLS_PAYLOAD_MAX_LEN];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(buf, sizeof(buf));
 
 	EXPECT_GE(send(self->fd, buf, send_len, 0), 0);
@@ -446,6 +482,11 @@ TEST_F(tls, recv_small)
 	int send_len = 10;
 	char buf[10];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	send_len = strlen(test_str) + 1;
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
@@ -458,6 +499,11 @@ TEST_F(tls, msg_more)
 	int send_len = 10;
 	char buf[10 * 2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -472,6 +518,11 @@ TEST_F(tls, msg_more_unsent)
 	int send_len = 10;
 	char buf[10];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
 }
@@ -485,6 +536,11 @@ TEST_F(tls, sendmsg_single)
 	struct iovec vec;
 	char buf[13];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	vec.iov_base = (char *)test_str;
 	vec.iov_len = send_len;
 	memset(&msg, 0, sizeof(struct msghdr));
@@ -505,6 +561,11 @@ TEST_F(tls, sendmsg_fragmented)
 	struct msghdr msg;
 	int i, frags;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	for (frags = 1; frags <= MAX_FRAGS; frags++) {
 		for (i = 0; i < frags; i++) {
 			vec[i].iov_base = (char *)test_str;
@@ -536,6 +597,11 @@ TEST_F(tls, sendmsg_large)
 	size_t recvs = 0;
 	size_t sent = 0;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	while (sent++ < sends) {
 		struct iovec vec = { (void *)mem, send_len };
@@ -564,6 +630,11 @@ TEST_F(tls, sendmsg_multiple)
 	char *buf;
 	int i;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	for (i = 0; i < iov_len; i++) {
 		test_strs[i] = (char *)malloc(strlen(test_str) + 1);
@@ -601,6 +672,11 @@ TEST_F(tls, sendmsg_multiple_stress)
 	int len_cmp = 0;
 	int i;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&msg, 0, sizeof(struct msghdr));
 	for (i = 0; i < iov_len; i++) {
 		test_strs[i] = (char *)malloc(strlen(test_str) + 1);
@@ -629,6 +705,11 @@ TEST_F(tls, splice_from_pipe)
 	char mem_recv[TLS_PAYLOAD_MAX_LEN];
 	int p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_GE(write(p[1], mem_send, send_len), 0);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), 0);
@@ -644,6 +725,11 @@ TEST_F(tls, splice_from_pipe2)
 	int p2[2];
 	int p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -666,6 +752,11 @@ TEST_F(tls, send_and_splice)
 	char buf[10];
 	int p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, test_str, send_len2, 0), send_len2);
 	EXPECT_EQ(recv(self->cfd, buf, send_len2, MSG_WAITALL), send_len2);
@@ -685,6 +776,11 @@ TEST_F(tls, splice_to_pipe)
 	char mem_recv[TLS_PAYLOAD_MAX_LEN];
 	int p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -705,6 +801,11 @@ TEST_F(tls, splice_cmsg_to_pipe)
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
@@ -728,6 +829,11 @@ TEST_F(tls, splice_dec_cmsg_to_pipe)
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
@@ -748,6 +854,11 @@ TEST_F(tls, recv_and_splice)
 	int half = send_len / 2;
 	int p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
 	/* Recv hald of the record, splice the other half */
@@ -766,6 +877,11 @@ TEST_F(tls, peek_and_splice)
 	int chunk = TLS_PAYLOAD_MAX_LEN / 4;
 	int n, i, p[2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(mem_send, sizeof(mem_send));
 
 	ASSERT_GE(pipe(p), 0);
@@ -797,6 +913,11 @@ TEST_F(tls, recvmsg_single)
 	struct msghdr hdr;
 	struct iovec vec;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(&hdr, 0, sizeof(hdr));
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	vec.iov_base = (char *)buf;
@@ -815,6 +936,11 @@ TEST_F(tls, recvmsg_single_max)
 	struct iovec vec;
 	struct msghdr hdr;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_EQ(send(self->fd, send_mem, send_len, 0), send_len);
@@ -840,6 +966,11 @@ TEST_F(tls, recvmsg_multiple)
 
 	memrnd(buf, sizeof(buf));
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, buf, send_len, 0), send_len);
 	for (i = 0; i < msg_iovlen; i++) {
 		iov_base[i] = (char *)malloc(iov_len);
@@ -862,6 +993,11 @@ TEST_F(tls, single_send_multiple_recv)
 	char send_mem[TLS_PAYLOAD_MAX_LEN * 2];
 	char recv_mem[TLS_PAYLOAD_MAX_LEN * 2];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
@@ -879,6 +1015,11 @@ TEST_F(tls, multiple_send_single_recv)
 	char recv_mem[2 * 10];
 	char send_mem[10];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, send_len, 0), 0);
@@ -897,6 +1038,11 @@ TEST_F(tls, single_send_multiple_recv_non_align)
 	char recv_mem[recv_len * 2];
 	char send_mem[total_len];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memrnd(send_mem, sizeof(send_mem));
 
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
@@ -915,6 +1061,11 @@ TEST_F(tls, recv_partial)
 	int send_len = strlen(test_str) + 1;
 	char recv_mem[18];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	memset(recv_mem, 0, sizeof(recv_mem));
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_NE(recv(self->cfd, recv_mem, strlen(test_str_first),
@@ -932,6 +1083,11 @@ TEST_F(tls, recv_nonblock)
 	char buf[4096];
 	bool err;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_DONTWAIT), -1);
 	err = (errno == EAGAIN || errno == EWOULDBLOCK);
 	EXPECT_EQ(err, true);
@@ -943,6 +1099,11 @@ TEST_F(tls, recv_peek)
 	int send_len = strlen(test_str) + 1;
 	char buf[15];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_PEEK), send_len);
 	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
@@ -959,6 +1120,11 @@ TEST_F(tls, recv_peek_multiple)
 	char buf[15];
 	int i;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	for (i = 0; i < num_peeks; i++) {
 		EXPECT_NE(recv(self->cfd, buf, send_len, MSG_PEEK), -1);
@@ -977,6 +1143,11 @@ TEST_F(tls, recv_peek_multiple_records)
 	int len;
 	char buf[64];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	len = strlen(test_str_first);
 	EXPECT_EQ(send(self->fd, test_str_first, len, 0), len);
 
@@ -1026,6 +1197,11 @@ TEST_F(tls, recv_peek_large_buf_mult_recs)
 	int len;
 	char buf[64];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	len = strlen(test_str_first);
 	EXPECT_EQ(send(self->fd, test_str_first, len, 0), len);
 
@@ -1046,6 +1222,11 @@ TEST_F(tls, recv_lowat)
 	char recv_mem[20];
 	int lowat = 8;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, send_mem, 10, 0), 10);
 	EXPECT_EQ(send(self->fd, send_mem, 5, 0), 5);
 
@@ -1067,6 +1248,11 @@ TEST_F(tls, bidir)
 	char buf[10];
 	int ret;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	if (!self->notls) {
 		struct tls_crypto_info_keys tls12;
 
@@ -1102,6 +1288,11 @@ TEST_F(tls, pollin)
 	char buf[10];
 	int send_len = 10;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
@@ -1120,6 +1311,11 @@ TEST_F(tls, poll_wait)
 	struct pollfd fd = { 0, 0, 0 };
 	char recv_mem[15];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -1135,6 +1331,11 @@ TEST_F(tls, poll_wait_split)
 	char send_mem[20] = {};
 	char recv_mem[15];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	fd.fd = self->cfd;
 	fd.events = POLLIN;
 	/* Send 20 bytes */
@@ -1160,6 +1361,11 @@ TEST_F(tls, blocking)
 	size_t data = 100000;
 	int res = fork();
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_NE(res, -1);
 
 	if (res) {
@@ -1202,6 +1408,11 @@ TEST_F(tls, nonblocking)
 	int flags;
 	int res;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	flags = fcntl(self->fd, F_GETFL, 0);
 	fcntl(self->fd, F_SETFL, flags | O_NONBLOCK);
 	fcntl(self->cfd, F_SETFL, flags | O_NONBLOCK);
@@ -1343,31 +1554,61 @@ test_mutliproc(struct __test_metadata *_metadata, struct _test_data_tls *self,
 
 TEST_F(tls, mutliproc_even)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 6, 6);
 }
 
 TEST_F(tls, mutliproc_readers)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 4, 12);
 }
 
 TEST_F(tls, mutliproc_writers)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, false, 10, 2);
 }
 
 TEST_F(tls, mutliproc_sendpage_even)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 6, 6);
 }
 
 TEST_F(tls, mutliproc_sendpage_readers)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 4, 12);
 }
 
 TEST_F(tls, mutliproc_sendpage_writers)
 {
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	test_mutliproc(_metadata, self, true, 10, 2);
 }
 
@@ -1378,6 +1619,11 @@ TEST_F(tls, control_msg)
 	int send_len = 10;
 	char buf[10];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	if (self->notls)
 		SKIP(return, "no TLS support");
 
@@ -1406,6 +1652,11 @@ TEST_F(tls, shutdown)
 	int send_len = 10;
 	char buf[10];
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	ASSERT_EQ(strlen(test_str) + 1, send_len);
 
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
@@ -1421,6 +1672,11 @@ TEST_F(tls, shutdown_unsent)
 	char const *test_str = "test_read";
 	int send_len = 10;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
 
 	shutdown(self->fd, SHUT_RDWR);
@@ -1432,6 +1688,11 @@ TEST_F(tls, shutdown_reuse)
 	struct sockaddr_in addr;
 	int ret;
 
+	if (self->fips_enabled && (variant->cipher_type ==
+	    TLS_CIPHER_CHACHA20_POLY1305 || variant->cipher_type ==
+	    TLS_CIPHER_SM4_GCM || variant->cipher_type == TLS_CIPHER_SM4_CCM))
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	shutdown(self->fd, SHUT_RDWR);
 	shutdown(self->cfd, SHUT_RDWR);
 	close(self->cfd);
-- 
2.34.1


