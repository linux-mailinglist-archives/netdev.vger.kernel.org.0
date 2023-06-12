Return-Path: <netdev+bounces-10114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 015E472C509
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E1D1C208E9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5D11993F;
	Mon, 12 Jun 2023 12:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382218AF1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:30 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6290610DC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:27 -0700 (PDT)
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 371B13F56D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686574285;
	bh=53EQLqkSYcnfUW7tWTa0tl0p5nwMGKAhLFezoflGDnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=Q2VDXwjageDPz/H9RFmu/blLh9f2RtZfj5axuotLwX4jSIPxSHpQ8Xv1M1YDkzYqL
	 bdHYueTMgmFXKtzCzM6vxapauAqKP6fh5jqapvO8rJ3iYJxrokLL1/dAv6Xp+2Zcwx
	 cN7O1F+JqKFF/8nB4XB3Pz/pzqIdXV0p76AcwXVHsL5mYoWYOlaJB54YjmfjAD/v9m
	 4RiVcsiVriF5m8nlOMz3cAuvGHL8UsD3eq3VcKnCMi891An8ttJHbTSsqHA5NcJbE0
	 H468ilmh2BkuXd5wLrTWsK4AllmwvmX5lg1H0DX3GwGtCL5c8LGiR2asNwRriTb9vt
	 UhAruH/FBIcPw==
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6b2940e84fdso2805070a34.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686574283; x=1689166283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53EQLqkSYcnfUW7tWTa0tl0p5nwMGKAhLFezoflGDnw=;
        b=Nf54q0PT+f9pjQ/0wKTRE9JKKCc/vJ9ddG225QUPEXrRnLnOppVdlzX7AXcMtINa6Y
         vBiKZ4mkI8zRr3fZZWCkmQgRsqL4qAaYqJ7UBVcrKdMIG0FSyDxQ7wbVulr4RmXCVBI8
         +dgCJHz+bk36HaD1LRdp58Cpl9NhVgkz3yuzDqzfvPsWCvZ2NbF32CMUppFyDnehtFmr
         2DWpTNgjrPW7HX71Zzc5kjEvjfkOx69XCU7gVbZ9KRMb5h/AOhEDtPqbrH03rvnid+fH
         zVtqIFVvDG7ZhL1//PYPNSyagoE5L/T6iB0zwBuLHFbvGR892Vn7PDsYsyiAC6LM3MCF
         GRwg==
X-Gm-Message-State: AC+VfDxE0CRmgXc7XwDlcj7ACGKCXy7pFGhyVYB3mJnfhC6H2Lvye3wN
	m5Y4UZHG+wxcdxUhpJEmugbTYZV49NT1qnQn8DSCkb7vyC+NwoYJpwK8cMePV4M2SYhe/I762HI
	TYXN1ZT4jJU0OuQ4B9lMAWwqdIMSz2+BsW6GCzmKVmg==
X-Received: by 2002:a05:6870:8785:b0:1a6:88c4:5815 with SMTP id r5-20020a056870878500b001a688c45815mr2399846oam.57.1686574282897;
        Mon, 12 Jun 2023 05:51:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7d6CuEdbi4X+dikuOxYc7owlwRtCAJacFJFzXKOQlEcvp7Jz/z6S00gZUboMLR6TJ52c8YVQ==
X-Received: by 2002:a05:6870:8785:b0:1a6:88c4:5815 with SMTP id r5-20020a056870878500b001a688c45815mr2399831oam.57.1686574282715;
        Mon, 12 Jun 2023 05:51:22 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:d612:b95d:6bdc:8f6d])
        by smtp.gmail.com with ESMTPSA id j22-20020a4ad196000000b00529cc3986c8sm3157193oor.40.2023.06.12.05.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 05:51:22 -0700 (PDT)
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
Subject: [PATCH v3 2/4] selftests: net: tls: check if FIPS mode is enabled
Date: Mon, 12 Jun 2023 09:51:05 -0300
Message-Id: <20230612125107.73795-3-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612125107.73795-1-magali.lemes@canonical.com>
References: <20230612125107.73795-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TLS selftests use the ChaCha20-Poly1305 and SM4 algorithms, which are not
FIPS compliant. When fips=1, this set of tests fails. Add a check and only
run these tests if not in FIPS mode.

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Fixes: e506342a03c7 ("selftests/tls: add SM4 GCM/CCM to tls selftests")
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
Changes in v3:
 - No need to initialize static variable to zero.
 - Skip tests during test setup only.
 - Use the constructor attribute to set fips_enabled before entering
 main().
 
Changes in v2:
 - Put fips_non_compliant into the variants.
 - Turn fips_enabled into a static global variable.
 - Read /proc/sys/crypto/fips_enabled only once at main().

 tools/testing/selftests/net/tls.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e699548d4247..e4efe80d55e9 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,8 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+static int fips_enabled;
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
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
 			     &tls12);
 
@@ -406,6 +415,7 @@ static void chunked_sendfile(struct __test_metadata *_metadata,
 
 TEST_F(tls, multi_chunk_sendfile)
 {
+
 	chunked_sendfile(_metadata, self, 4096, 4096);
 	chunked_sendfile(_metadata, self, 4096, 0);
 	chunked_sendfile(_metadata, self, 4096, 1);
@@ -1865,4 +1875,17 @@ TEST(prequeue) {
 	close(cfd);
 }
 
+static void __attribute__((constructor)) fips_check(void) {
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
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1


