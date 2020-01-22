Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE441449F0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAVCjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:39:15 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:47344 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVCjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:39:15 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eL020009;
        Tue, 21 Jan 2020 16:57:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=ZhG+UGDhCdTsG2sDTCZShDaAkDWJx+7R0dzdMclbDMM=;
 b=T4J5d3c/5Jx9yS+GiIQj6QjUA3R2JuWRE40fyy1EcrJpNiUtJ5w2XlaLSOZxT7EzXc3k
 EmDtvV7u2YqZjv4OTeg+Ikmpxocy08gtZisdiW5+K6NVxAzoXIy/Z5yLPrie8p2LcnnL
 eVj2OD//7PpFajcaFjkDg5RC/VthbWDHsItXBOVPO5rK3lsrz+AKwTFgHyCMpyxXLOwm
 z8RwN40/Jz+cFm8y/btzRcJumULU2/ofJKKnNT73v1VwPODYrtNJBdpWl5hOdTyFY+1t
 v9vh9tqk2ghOrvLvifb2Xuo1AKwP+Df7BttLpj/m4PDxplX0yP6Vc1Qdzcqi93O8f1/A +w== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:04 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:03 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 8e11cccf87192e4df3f407d43544ff16
X-Va-R-CD: b9324b3a4efeb48edefc2f9dfbbde0b0
X-Va-CD: 0
X-Va-ID: 37a035fe-7ae2-475d-81be-617b25350902
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 8e11cccf87192e4df3f407d43544ff16
X-V-R-CD: b9324b3a4efeb48edefc2f9dfbbde0b0
X-V-CD: 0
X-V-ID: 1c722b40-b1c9-43de-a0c6-1197564082b4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DSWHB1DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 16/19] mptcp: move from sha1 (v0) to sha256 (v1)
Date:   Tue, 21 Jan 2020 16:56:30 -0800
Message-id: <20200122005633.21229-17-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

For simplicity's sake use directly sha256 primitives (and pull them
as a required build dep).
Add optional, boot-time self-tests for the hmac function.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/Kconfig    |  10 ++++
 net/mptcp/crypto.c   | 140 ++++++++++++++++++++++++++-----------------
 net/mptcp/options.c  |   9 ++-
 net/mptcp/protocol.h |   4 +-
 4 files changed, 104 insertions(+), 59 deletions(-)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index c1a99f07a4cd..5db56d2218c5 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -3,6 +3,7 @@ config MPTCP
 	bool "MPTCP: Multipath TCP"
 	depends on INET
 	select SKB_EXTENSIONS
+	select CRYPTO_LIB_SHA256
 	help
 	  Multipath TCP (MPTCP) connections send and receive data over multiple
 	  subflows in order to utilize multiple network paths. Each subflow
@@ -14,3 +15,12 @@ config MPTCP_IPV6
 	depends on MPTCP
 	select IPV6
 	default y
+
+config MPTCP_HMAC_TEST
+	bool "Tests for MPTCP HMAC implementation"
+	default n
+	help
+	  This option enable boot time self-test for the HMAC implementation
+	  used by the MPTCP code
+
+	  Say N if you are unsure.
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index bbd6d01af211..40d1bb18fd60 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -21,67 +21,36 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/cryptohash.h>
+#include <crypto/sha.h>
 #include <asm/unaligned.h>
 
 #include "protocol.h"
 
-struct sha1_state {
-	u32 workspace[SHA_WORKSPACE_WORDS];
-	u32 digest[SHA_DIGEST_WORDS];
-	unsigned int count;
-};
-
-static void sha1_init(struct sha1_state *state)
-{
-	sha_init(state->digest);
-	state->count = 0;
-}
-
-static void sha1_update(struct sha1_state *state, u8 *input)
-{
-	sha_transform(state->digest, input, state->workspace);
-	state->count += SHA_MESSAGE_BYTES;
-}
-
-static void sha1_pad_final(struct sha1_state *state, u8 *input,
-			   unsigned int length, __be32 *mptcp_hashed_key)
-{
-	int i;
-
-	input[length] = 0x80;
-	memset(&input[length + 1], 0, SHA_MESSAGE_BYTES - length - 9);
-	put_unaligned_be64((length + state->count) << 3,
-			   &input[SHA_MESSAGE_BYTES - 8]);
-
-	sha_transform(state->digest, input, state->workspace);
-	for (i = 0; i < SHA_DIGEST_WORDS; ++i)
-		put_unaligned_be32(state->digest[i], &mptcp_hashed_key[i]);
-
-	memzero_explicit(state->workspace, SHA_WORKSPACE_WORDS << 2);
-}
+#define SHA256_DIGEST_WORDS (SHA256_DIGEST_SIZE / 4)
 
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn)
 {
-	__be32 mptcp_hashed_key[SHA_DIGEST_WORDS];
-	u8 input[SHA_MESSAGE_BYTES];
-	struct sha1_state state;
+	__be32 mptcp_hashed_key[SHA256_DIGEST_WORDS];
+	__be64 input = cpu_to_be64(key);
+	struct sha256_state state;
 
-	sha1_init(&state);
-	put_unaligned_be64(key, input);
-	sha1_pad_final(&state, input, 8, mptcp_hashed_key);
+	sha256_init(&state);
+	sha256_update(&state, (__force u8 *)&input, sizeof(input));
+	sha256_final(&state, (u8 *)mptcp_hashed_key);
 
 	if (token)
 		*token = be32_to_cpu(mptcp_hashed_key[0]);
 	if (idsn)
-		*idsn = be64_to_cpu(*((__be64 *)&mptcp_hashed_key[3]));
+		*idsn = be64_to_cpu(*((__be64 *)&mptcp_hashed_key[6]));
 }
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
-			   u32 *hash_out)
+			   void *hmac)
 {
-	u8 input[SHA_MESSAGE_BYTES * 2];
-	struct sha1_state state;
+	u8 input[SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE];
+	__be32 mptcp_hashed_key[SHA256_DIGEST_WORDS];
+	__be32 *hash_out = (__force __be32 *)hmac;
+	struct sha256_state state;
 	u8 key1be[8];
 	u8 key2be[8];
 	int i;
@@ -96,17 +65,16 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 	for (i = 0; i < 8; i++)
 		input[i + 8] ^= key2be[i];
 
-	put_unaligned_be32(nonce1, &input[SHA_MESSAGE_BYTES]);
-	put_unaligned_be32(nonce2, &input[SHA_MESSAGE_BYTES + 4]);
+	put_unaligned_be32(nonce1, &input[SHA256_BLOCK_SIZE]);
+	put_unaligned_be32(nonce2, &input[SHA256_BLOCK_SIZE + 4]);
 
-	sha1_init(&state);
-	sha1_update(&state, input);
+	sha256_init(&state);
+	sha256_update(&state, input, SHA256_BLOCK_SIZE + 8);
 
 	/* emit sha256(K1 || msg) on the second input block, so we can
 	 * reuse 'input' for the last hashing
 	 */
-	sha1_pad_final(&state, &input[SHA_MESSAGE_BYTES], 8,
-		       (__force __be32 *)&input[SHA_MESSAGE_BYTES]);
+	sha256_final(&state, &input[SHA256_BLOCK_SIZE]);
 
 	/* Prepare second part of hmac */
 	memset(input, 0x5C, SHA_MESSAGE_BYTES);
@@ -115,8 +83,70 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 	for (i = 0; i < 8; i++)
 		input[i + 8] ^= key2be[i];
 
-	sha1_init(&state);
-	sha1_update(&state, input);
-	sha1_pad_final(&state, &input[SHA_MESSAGE_BYTES], SHA_DIGEST_WORDS << 2,
-		       (__be32 *)hash_out);
+	sha256_init(&state);
+	sha256_update(&state, input, SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE);
+	sha256_final(&state, (u8 *)mptcp_hashed_key);
+
+	/* takes only first 160 bits */
+	for (i = 0; i < 5; i++)
+		hash_out[i] = mptcp_hashed_key[i];
+}
+
+#ifdef CONFIG_MPTCP_HMAC_TEST
+struct test_cast {
+	char *key;
+	char *msg;
+	char *result;
+};
+
+/* we can't reuse RFC 4231 test vectors, as we have constraint on the
+ * input and key size, and we truncate the output.
+ */
+static struct test_cast tests[] = {
+	{
+		.key = "0b0b0b0b0b0b0b0b",
+		.msg = "48692054",
+		.result = "8385e24fb4235ac37556b6b886db106284a1da67",
+	},
+	{
+		.key = "aaaaaaaaaaaaaaaa",
+		.msg = "dddddddd",
+		.result = "2c5e219164ff1dca1c4a92318d847bb6b9d44492",
+	},
+	{
+		.key = "0102030405060708",
+		.msg = "cdcdcdcd",
+		.result = "e73b9ba9969969cefb04aa0d6df18ec2fcc075b6",
+	},
+};
+
+static int __init test_mptcp_crypto(void)
+{
+	char hmac[20], hmac_hex[41];
+	u32 nonce1, nonce2;
+	u64 key1, key2;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
+		/* mptcp hmap will convert to be before computing the hmac */
+		key1 = be64_to_cpu(*((__be64 *)&tests[i].key[0]));
+		key2 = be64_to_cpu(*((__be64 *)&tests[i].key[8]));
+		nonce1 = be32_to_cpu(*((__be32 *)&tests[i].msg[0]));
+		nonce2 = be32_to_cpu(*((__be32 *)&tests[i].msg[4]));
+
+		mptcp_crypto_hmac_sha(key1, key2, nonce1, nonce2, hmac);
+		for (j = 0; j < 20; ++j)
+			sprintf(&hmac_hex[j << 1], "%02x", hmac[j] & 0xff);
+		hmac_hex[40] = 0;
+
+		if (memcmp(hmac_hex, tests[i].result, 40))
+			pr_err("test %d failed, got %s expected %s", i,
+			       hmac_hex, tests[i].result);
+		else
+			pr_info("test %d [ ok ]", i);
+	}
+	return 0;
 }
+
+late_initcall(test_mptcp_crypto);
+#endif
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1fa8496f3551..1aec742ca8e1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -9,6 +9,11 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static bool mptcp_cap_flag_sha256(u8 flags)
+{
+	return (flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA256;
+}
+
 void mptcp_parse_option(const unsigned char *ptr, int opsize,
 			struct tcp_options_received *opt_rx)
 {
@@ -29,7 +34,7 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 			break;
 
 		flags = *ptr++;
-		if (!((flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA1) ||
+		if (!mptcp_cap_flag_sha256(flags) ||
 		    (flags & MPTCP_CAP_EXTENSIBILITY))
 			break;
 
@@ -399,7 +404,7 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		*ptr++ = htonl((TCPOPT_MPTCP << 24) | (len << 16) |
 			       (MPTCPOPT_MP_CAPABLE << 12) |
 			       (MPTCP_SUPPORTED_VERSION << 8) |
-			       MPTCP_CAP_HMAC_SHA1);
+			       MPTCP_CAP_HMAC_SHA256);
 		put_unaligned_be64(opts->sndr_key, ptr);
 		ptr += 2;
 		if (OPTION_MPTCP_MPC_ACK & opts->suboptions) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a8fad7d78565..a355bb1cf31b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -43,7 +43,7 @@
 #define MPTCP_VERSION_MASK	(0x0F)
 #define MPTCP_CAP_CHECKSUM_REQD	BIT(7)
 #define MPTCP_CAP_EXTENSIBILITY	BIT(6)
-#define MPTCP_CAP_HMAC_SHA1	BIT(0)
+#define MPTCP_CAP_HMAC_SHA256	BIT(0)
 #define MPTCP_CAP_FLAG_MASK	(0x3F)
 
 /* MPTCP DSS flags */
@@ -216,7 +216,7 @@ static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
 }
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
-			   u32 *hash_out);
+			   void *hash_out);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {
-- 
2.23.0

