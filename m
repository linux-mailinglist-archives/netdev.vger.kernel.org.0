Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDA5E93D0
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIYPBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiIYPBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:01:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DE42D76E
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 08:01:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fv3so4241148pjb.0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 08:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=VfqxnD2iT7blaoUS/ZtmBioiIY8af1AqYATKx5jSVnA=;
        b=ljTyfWEkH4NV+5UtCLdGGm+KaWTHBv6KphcKAJ1D4yrpCzf7sJFmZEOT7c41C6NEmT
         g3mil/isd4zh1yeSnQ2/BX+7TKM7i4Jm866gLFwtjZUF7thnac+RZCbsnTZUvoGhskMl
         tWdZRkNaRfw6WgmEaPHE9ZD76o3BPXuwLr0fDWxSa3EsS67jVqavI36UqN2Z1judVGSW
         0DcR5F65jSdeczMz4FqfSEuxpraCG8om6dJILwQqAHyRHuT0hF3yq90dhAxU9cJW7oDo
         HP6EakcaiINDmAcPLLI/p98A2Xc5ASnMuuRwZxvQYlAyZGAdGQeYtJTSmS4E9wsH+uGX
         t+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=VfqxnD2iT7blaoUS/ZtmBioiIY8af1AqYATKx5jSVnA=;
        b=JG6cbo/EC8s2KazZreurqkt0t0V3posMrwVi2wmN4NBmMvARYtMssvmzWA/+jsX0Yd
         VdEAPphbjvv8EUAn06S1rszR+6Hp3EPFoDQduwN1XWAQqp1kDX8a3gkCb9C7Jw+D5Kir
         y/4uoSAtr1mizqM36Cmd5kJYV9pdiL/Ei0Zlthp8hn8PcT8MtdbnyKgoDM36dvguhGH4
         VdELZPgLPksR1JZPpZT3UMxX2e9PUK1H+YeRGn4kaN6ymEx8aElHPSJGtZv/iIvcmi91
         iaCqueqZgFdlQGDdCb9ezChszCpLY6E4RNnlm96kflrb2QYT9Pc+vCxzj6yPIeSLEto8
         mowQ==
X-Gm-Message-State: ACrzQf1yzKiZUd6Lgv19gmllhwZiiKuyfI3Z30zIONWFTDKRvqDklTEK
        UxcSs6s5Xwaasp70X0fSeMM=
X-Google-Smtp-Source: AMsMyM45UwfuptXwhs9a3lbTegI4uZSVBUEoYfNNsMglzbufAh8MVOBmXDDasjpbiLHpPFUvud2qaA==
X-Received: by 2002:a17:902:d2cc:b0:178:1742:c182 with SMTP id n12-20020a170902d2cc00b001781742c182mr17594952plc.98.1664118092834;
        Sun, 25 Sep 2022 08:01:32 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id q7-20020aa78427000000b0053e3a6f7da4sm10390458pfn.12.2022.09.25.08.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 08:01:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, borisp@nvidia.com,
        john.fastabend@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH v3 net-next] net: tls: Add ARIA-GCM algorithm
Date:   Sun, 25 Sep 2022 15:00:33 +0000
Message-Id: <20220925150033.24615-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 6209 describes ARIA for TLS 1.2.
ARIA-128-GCM and ARIA-256-GCM are defined in RFC 6209.

This patch would offer performance increment and an opportunity for
hardware offload.

Benchmark results:
iperf-ssl are used.
CPU: intel i3-12100.

  TLS(openssl-3.0-dev)
[  3]  0.0- 1.0 sec   185 MBytes  1.55 Gbits/sec
[  3]  1.0- 2.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  2.0- 3.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  3.0- 4.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  4.0- 5.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  0.0- 5.0 sec   927 MBytes  1.56 Gbits/sec
  kTLS(aria-generic)
[  3]  0.0- 1.0 sec   198 MBytes  1.66 Gbits/sec
[  3]  1.0- 2.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  2.0- 3.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  3.0- 4.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  4.0- 5.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  0.0- 5.0 sec   974 MBytes  1.63 Gbits/sec
  kTLS(aria-avx wirh GFNI)
[  3]  0.0- 1.0 sec   632 MBytes  5.30 Gbits/sec
[  3]  1.0- 2.0 sec   657 MBytes  5.51 Gbits/sec
[  3]  2.0- 3.0 sec   657 MBytes  5.51 Gbits/sec
[  3]  3.0- 4.0 sec   656 MBytes  5.50 Gbits/sec
[  3]  4.0- 5.0 sec   656 MBytes  5.50 Gbits/sec
[  3]  0.0- 5.0 sec  3.18 GBytes  5.47 Gbits/sec

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
- This patch was a part of patchset of implementation of aria algorithm[1].
  There were 3 patches in the patchset, the target branch of the first
  and second patch were the crypto and these were merged[2].
  This patch was the last patch of that patchset and the target branch of
  this patch is net-next, not crypto. So it was not merged by the crypto 
  branch.
  It waited for merging of these two patches.

v3:
 - There are no code changes in this patch.
 - Update benchmark data with aria-avx.

[1] https://lore.kernel.org/netdev/20220704094250.4265-4-ap420073@gmail.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/crypto/aria.c

 include/uapi/linux/tls.h | 30 +++++++++++++++++++
 net/tls/tls_main.c       | 62 ++++++++++++++++++++++++++++++++++++++++
 net/tls/tls_sw.c         | 34 ++++++++++++++++++++++
 3 files changed, 126 insertions(+)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index f1157d8f4acd..b66a800389cc 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -100,6 +100,20 @@
 #define TLS_CIPHER_SM4_CCM_TAG_SIZE		16
 #define TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE		8
 
+#define TLS_CIPHER_ARIA_GCM_128				57
+#define TLS_CIPHER_ARIA_GCM_128_IV_SIZE			8
+#define TLS_CIPHER_ARIA_GCM_128_KEY_SIZE		16
+#define TLS_CIPHER_ARIA_GCM_128_SALT_SIZE		4
+#define TLS_CIPHER_ARIA_GCM_128_TAG_SIZE		16
+#define TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE		8
+
+#define TLS_CIPHER_ARIA_GCM_256				58
+#define TLS_CIPHER_ARIA_GCM_256_IV_SIZE			8
+#define TLS_CIPHER_ARIA_GCM_256_KEY_SIZE		32
+#define TLS_CIPHER_ARIA_GCM_256_SALT_SIZE		4
+#define TLS_CIPHER_ARIA_GCM_256_TAG_SIZE		16
+#define TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE		8
+
 #define TLS_SET_RECORD_TYPE	1
 #define TLS_GET_RECORD_TYPE	2
 
@@ -156,6 +170,22 @@ struct tls12_crypto_info_sm4_ccm {
 	unsigned char rec_seq[TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE];
 };
 
+struct tls12_crypto_info_aria_gcm_128 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_ARIA_GCM_128_IV_SIZE];
+	unsigned char key[TLS_CIPHER_ARIA_GCM_128_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_ARIA_GCM_128_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE];
+};
+
+struct tls12_crypto_info_aria_gcm_256 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_ARIA_GCM_256_IV_SIZE];
+	unsigned char key[TLS_CIPHER_ARIA_GCM_256_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_ARIA_GCM_256_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE];
+};
+
 enum {
 	TLS_INFO_UNSPEC,
 	TLS_INFO_VERSION,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 5cc6911cc97d..3735cb00905d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -524,6 +524,54 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EFAULT;
 		break;
 	}
+	case TLS_CIPHER_ARIA_GCM_128: {
+		struct tls12_crypto_info_aria_gcm_128 *
+		  crypto_info_aria_gcm_128 =
+		  container_of(crypto_info,
+			       struct tls12_crypto_info_aria_gcm_128,
+			       info);
+
+		if (len != sizeof(*crypto_info_aria_gcm_128)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(crypto_info_aria_gcm_128->iv,
+		       cctx->iv + TLS_CIPHER_ARIA_GCM_128_SALT_SIZE,
+		       TLS_CIPHER_ARIA_GCM_128_IV_SIZE);
+		memcpy(crypto_info_aria_gcm_128->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval,
+				 crypto_info_aria_gcm_128,
+				 sizeof(*crypto_info_aria_gcm_128)))
+			rc = -EFAULT;
+		break;
+	}
+	case TLS_CIPHER_ARIA_GCM_256: {
+		struct tls12_crypto_info_aria_gcm_256 *
+		  crypto_info_aria_gcm_256 =
+		  container_of(crypto_info,
+			       struct tls12_crypto_info_aria_gcm_256,
+			       info);
+
+		if (len != sizeof(*crypto_info_aria_gcm_256)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(crypto_info_aria_gcm_256->iv,
+		       cctx->iv + TLS_CIPHER_ARIA_GCM_256_SALT_SIZE,
+		       TLS_CIPHER_ARIA_GCM_256_IV_SIZE);
+		memcpy(crypto_info_aria_gcm_256->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval,
+				 crypto_info_aria_gcm_256,
+				 sizeof(*crypto_info_aria_gcm_256)))
+			rc = -EFAULT;
+		break;
+	}
 	default:
 		rc = -EINVAL;
 	}
@@ -685,6 +733,20 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	case TLS_CIPHER_SM4_CCM:
 		optsize = sizeof(struct tls12_crypto_info_sm4_ccm);
 		break;
+	case TLS_CIPHER_ARIA_GCM_128:
+		if (crypto_info->version != TLS_1_2_VERSION) {
+			rc = -EINVAL;
+			goto err_crypto_info;
+		}
+		optsize = sizeof(struct tls12_crypto_info_aria_gcm_128);
+		break;
+	case TLS_CIPHER_ARIA_GCM_256:
+		if (crypto_info->version != TLS_1_2_VERSION) {
+			rc = -EINVAL;
+			goto err_crypto_info;
+		}
+		optsize = sizeof(struct tls12_crypto_info_aria_gcm_256);
+		break;
 	default:
 		rc = -EINVAL;
 		goto err_crypto_info;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fe27241cd13f..264cf367e265 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2629,6 +2629,40 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		cipher_name = "ccm(sm4)";
 		break;
 	}
+	case TLS_CIPHER_ARIA_GCM_128: {
+		struct tls12_crypto_info_aria_gcm_128 *aria_gcm_128_info;
+
+		aria_gcm_128_info = (void *)crypto_info;
+		nonce_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
+		tag_size = TLS_CIPHER_ARIA_GCM_128_TAG_SIZE;
+		iv_size = TLS_CIPHER_ARIA_GCM_128_IV_SIZE;
+		iv = aria_gcm_128_info->iv;
+		rec_seq_size = TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE;
+		rec_seq = aria_gcm_128_info->rec_seq;
+		keysize = TLS_CIPHER_ARIA_GCM_128_KEY_SIZE;
+		key = aria_gcm_128_info->key;
+		salt = aria_gcm_128_info->salt;
+		salt_size = TLS_CIPHER_ARIA_GCM_128_SALT_SIZE;
+		cipher_name = "gcm(aria)";
+		break;
+	}
+	case TLS_CIPHER_ARIA_GCM_256: {
+		struct tls12_crypto_info_aria_gcm_256 *gcm_256_info;
+
+		gcm_256_info = (void *)crypto_info;
+		nonce_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
+		tag_size = TLS_CIPHER_ARIA_GCM_256_TAG_SIZE;
+		iv_size = TLS_CIPHER_ARIA_GCM_256_IV_SIZE;
+		iv = gcm_256_info->iv;
+		rec_seq_size = TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE;
+		rec_seq = gcm_256_info->rec_seq;
+		keysize = TLS_CIPHER_ARIA_GCM_256_KEY_SIZE;
+		key = gcm_256_info->key;
+		salt = gcm_256_info->salt;
+		salt_size = TLS_CIPHER_ARIA_GCM_256_SALT_SIZE;
+		cipher_name = "gcm(aria)";
+		break;
+	}
 	default:
 		rc = -EINVAL;
 		goto free_priv;
-- 
2.17.1

