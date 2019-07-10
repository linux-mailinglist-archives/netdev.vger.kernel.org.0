Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AF1640E9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 08:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfGJGGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 02:06:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37849 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJGGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 02:06:55 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so865155eds.4;
        Tue, 09 Jul 2019 23:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IFatqQJxhkN2PVVhb4XlYYtBpS9gE8ekJeo/gQnleEk=;
        b=fQzho3+Lw2LoydF/Sp7rS07AP+nleH06X3WjYF4dRlMlzA78nX4bY23fZcKZAVvtvs
         7zTvzU4k+cqG5aeywOAUg6L5IyOOs+H+ex8x4HzmOZzeGfgkK8m+3ZKJma/+rHurvq7a
         nDssc5Gp/fp01mnwl7jjizAVT29udQz84u33YW9onDuo3o48fUchRUFGhM70hfnu+dBC
         Vf1aYs7U5ikbjdNXfXZrQV6aq/SkVbIMu5RL8vOH5+KIyAwWZSz33tnpRQCco/qNJell
         6EVgIvnCDJuxI53wnV+HZaExPkPFdX2Tmxhl+3Ax2SqRBUatbv5/Nw1tqy5ECUfgLEVy
         opEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IFatqQJxhkN2PVVhb4XlYYtBpS9gE8ekJeo/gQnleEk=;
        b=W3ciJ5k6mFy3jyuG3J21cjWmTqU/avauVq+nk21BioEGVApLonGvHyhisbCNmtg+vf
         BenZ9oop/+CZvm34swflIrCIEzm21A6tCNrlV8UwkaNtimW8ThZ3kJ4fhCUe0lwnO1Z9
         +YHIwo7ODkpCLjStWskAmeF0rd/feM7EcyY/p6XSdOmLF8qqG5QoGpVcmzHmDrBruwg7
         BJ1xKRpu3eGPswikMwBVJUbdxgXnQkifxC29QQVI6Yiixp+Q+5XM+mYr/+oIiZvCL5uM
         MH2H4BEebIo5aOna5JErUyBhUjQlEy4l2EJ/eDu8G7TZqfDHEeuqzncODCYZXa/BYWh3
         P1Qg==
X-Gm-Message-State: APjAAAXvCOQ6Ih82rIvCxpMROmd+b6Wjlq0HMpTYpbay0J2abs1GzhW5
        FCR3HbjVFD2WMnu9TXydxw8=
X-Google-Smtp-Source: APXvYqxvsBNzi4e0esOHtdk4gNpqSj0iwFmJJoE3PDppDGHZZJY37vpr6ln+4h7g5K93uGFVcfd58A==
X-Received: by 2002:a50:974b:: with SMTP id d11mr29673586edb.24.1562738812536;
        Tue, 09 Jul 2019 23:06:52 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id m16sm830343wrv.89.2019.07.09.23.06.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 23:06:52 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH net-next v3] net/mlx5e: Convert single case statement switch statements into if statements
Date:   Tue,  9 Jul 2019 23:06:15 -0700
Message-Id: <20190710060614.6155-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190710044748.3924-1-natechancellor@gmail.com>
References: <20190710044748.3924-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the review of commit 1ff2f0fa450e ("net/mlx5e: Return in default
case statement in tx_post_resync_params"), Leon and Nick pointed out
that the switch statements can be converted to single if statements
that return early so that the code is easier to follow.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Refactor switch statements into if statements

v2 -> v3:

* Rebase on net-next after v1 was already applied, patch just refactors
  switch statements to if statements.

 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 34 ++++++-------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 5c08891806f0..ea032f54197e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -25,23 +25,17 @@ static void
 fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
 	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 *info;
 	char *initial_rn, *gcm_iv;
 	u16 salt_sz, rec_seq_sz;
 	char *salt, *rec_seq;
 	u8 tls_version;
 
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128: {
-		struct tls12_crypto_info_aes_gcm_128 *info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
-
-		EXTRACT_INFO_FIELDS;
-		break;
-	}
-	default:
-		WARN_ON(1);
+	if (WARN_ON(crypto_info->cipher_type != TLS_CIPHER_AES_GCM_128))
 		return;
-	}
+
+	info = (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	EXTRACT_INFO_FIELDS;
 
 	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
 	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
@@ -234,24 +228,18 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 		      u64 rcd_sn)
 {
 	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 *info;
 	__be64 rn_be = cpu_to_be64(rcd_sn);
 	bool skip_static_post;
 	u16 rec_seq_sz;
 	char *rec_seq;
 
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128: {
-		struct tls12_crypto_info_aes_gcm_128 *info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
-
-		rec_seq = info->rec_seq;
-		rec_seq_sz = sizeof(info->rec_seq);
-		break;
-	}
-	default:
-		WARN_ON(1);
+	if (WARN_ON(crypto_info->cipher_type != TLS_CIPHER_AES_GCM_128))
 		return;
-	}
+
+	info = (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	rec_seq = info->rec_seq;
+	rec_seq_sz = sizeof(info->rec_seq);
 
 	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
 	if (!skip_static_post)
-- 
2.22.0

