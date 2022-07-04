Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2681656512A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiGDJn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiGDJnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:43:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A5FF5;
        Mon,  4 Jul 2022 02:43:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b2so8092646plx.7;
        Mon, 04 Jul 2022 02:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yUOQKPTjbfY7RNPQHjqEXjTgz6Odu28nKeyS3yW7uuQ=;
        b=jKIu1BCaC+TWdkQgyPjUtz+InGicxIyGsp8MV+99v52ckOJ05wdnAt+CDvLq0Nhesb
         LCEzVXU/FbT6iMLDNFuVHrIRBM4xDU1h1r2SLEHczct6jIPJXOYvWv2pFcKlctUEKev7
         fd9zicp92ca7ju5plfhT7clY0o6Wg+LU80tHBZNwxjjKBm1CdoWIDPpARPAuUGG+RBgi
         cM1QUqAVo9KQzAUeV5oyNIVtJTrMp3JQHdBx9HqPzM0MPxZeuQpC3xdifihjxKpZIePy
         k0dFO5rqOGLPIvfYfd1eH/mYtjmQfsdK/z0aPLrkk3if72ih5hPttPicNy33zAUDyk3C
         41Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yUOQKPTjbfY7RNPQHjqEXjTgz6Odu28nKeyS3yW7uuQ=;
        b=e0HA/QNaA39s7L8diFw1vz48a/c8POcIemhkq1gWHVxn7AdtDkNdRvQf/8Pjd5Wvp5
         yB6Eg3rO0PvgfIaNfa/1HFeE1Y0LErpZa2aagIVIGc3P2EmC6+5TddCTq/t/UIMAF0es
         8ObsrTBlSHTgUdr071RVIOpxI2AVM4bXoH4r1khGljECi6S+OrpZ+q8XfyQq/9PnOVjO
         uiIvVvU9cqN55bFkus/dsTFct3FmtHOf92TEIPLrvkSQylpTeg9oae+cT8Zn5WD/ryee
         0UJPWCXfErggcGp7IEXGmDKXvqyJlTe8uLvXh3KVkrGdy4SLjK4V7+uoTGDmlpyFV+5i
         1Q3A==
X-Gm-Message-State: AJIora/Vwaih3+psDQal/phqHFmLZey+MYDHAyoJee/equ0gM4rPbnzR
        t/zm94X1vS+tkkljMRTM6tyoSGs5vDQ=
X-Google-Smtp-Source: AGRyM1tbWRNTyXxlBaq94lUXWAkJwpWgogOwXrVjMdW6uHpQWwM+DvsjDsYTimUtauO3h3g4PlkVag==
X-Received: by 2002:a17:902:b412:b0:16b:d846:77ee with SMTP id x18-20020a170902b41200b0016bd84677eemr9096062plr.25.1656927803212;
        Mon, 04 Jul 2022 02:43:23 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id bb3-20020a170902bc8300b0015e8d4eb1c8sm20714602plb.18.2022.07.04.02.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 02:43:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v2 3/3] net: tls: Add ARIA-GCM algorithm
Date:   Mon,  4 Jul 2022 09:42:50 +0000
Message-Id: <20220704094250.4265-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704094250.4265-1-ap420073@gmail.com>
References: <20220704094250.4265-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
openssl-3.0-dev and iperf-ssl are used.
  TLS
[  3]  0.0- 1.0 sec   185 MBytes  1.55 Gbits/sec
[  3]  1.0- 2.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  2.0- 3.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  3.0- 4.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  4.0- 5.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  0.0- 5.0 sec   927 MBytes  1.56 Gbits/sec
  kTLS
[  3]  0.0- 1.0 sec   198 MBytes  1.66 Gbits/sec
[  3]  1.0- 2.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  2.0- 3.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  3.0- 4.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  4.0- 5.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  0.0- 5.0 sec   974 MBytes  1.63 Gbits/sec

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - patch added.

 include/uapi/linux/tls.h | 30 +++++++++++++++++++
 net/tls/tls_main.c       | 62 ++++++++++++++++++++++++++++++++++++++++
 net/tls/tls_sw.c         | 34 ++++++++++++++++++++++
 3 files changed, 126 insertions(+)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index ac39328eabe7..de3cdfaecf78 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -99,6 +99,20 @@
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
 
@@ -155,6 +169,22 @@ struct tls12_crypto_info_sm4_ccm {
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
index b91ddc110786..e44a2fdca111 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -505,6 +505,54 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
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
@@ -633,6 +681,20 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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
index 0513f82b8537..5094371f8f09 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2417,6 +2417,40 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
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

