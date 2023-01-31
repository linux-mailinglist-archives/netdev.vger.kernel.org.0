Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BA968229A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAaDMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjAaDMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A631511B
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4419F61381
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D25C433EF;
        Tue, 31 Jan 2023 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134732;
        bh=wYCRSKTXnI9FiNyKG+I1jAPwS0OpSPeo6P4beIQASh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKr595dHZDkehz43BkemhL9kz5YbgbIsNbN9GBS3Vbb2NKABTzKGIJO5rArLzu/RC
         fDr1n7j0UjS2C9ABKtEfXYBjynP59N6EGakFjCughwPumGsdGfQF+e+0P25NKdEtX5
         +ER1FjGEE0XcxF52t5MmCN+Re8YlSERmdivkMWUpIs4qhXrNK6GZcuPEoT6zzRlucM
         nrDCWMoBxCEkl6nUGe3BvmCqhNueJZqZLkITn9PRae1kUETc4H0VlGzZ86IX+spobW
         MdlpyIO3kVCtJujehZt23dwzuJXCQYOqtxYag+Gklrlcep7ZxJd63ujIwl6ZEHYne1
         MkE2pL0LUKUGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Add const to the key pointer of encryption key creation
Date:   Mon, 30 Jan 2023 19:11:52 -0800
Message-Id: <20230131031201.35336-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Change key pointer to const void *, as there is no need to change the
key content. This is also to avoid modifying the key by mistake.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index d36788119b8b..f80d6fce28d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -13,8 +13,8 @@ int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 			 struct tls_crypto_info *crypto_info,
 			 u32 *p_key_id)
 {
+	const void *key;
 	u32 sz_bytes;
-	void *key;
 
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128: {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 02bc365efade..bc2a72491e10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -10,7 +10,7 @@ struct mlx5_crypto_dek_priv {
 };
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
-			       void *key, u32 sz_bytes,
+			       const void *key, u32 sz_bytes,
 			       u32 key_type, u32 *p_key_id)
 {
 	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
index 5968536047ca..ee3ed8c863d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
@@ -11,7 +11,7 @@ enum {
 };
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
-			       void *key, u32 sz_bytes,
+			       const void *key, u32 sz_bytes,
 			       u32 key_type, u32 *p_key_id);
 
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
-- 
2.39.1

