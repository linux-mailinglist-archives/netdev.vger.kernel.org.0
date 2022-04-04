Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC9D4F1478
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbiDDMLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbiDDMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:11:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDEC1274E;
        Mon,  4 Apr 2022 05:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BB18B81612;
        Mon,  4 Apr 2022 12:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46276C340F2;
        Mon,  4 Apr 2022 12:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649074124;
        bh=raTPxryZlFPhc6CHQy7xgG4vzuNlp352533jc2ZqN/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfLuXb7Kn3bFORHh7qxHdHU3Vtm3Fuvra+wZO1UFGro5QG+CNWg7DX11V51pRO8xQ
         BBfooKfv+bOw9M7xhwLvpuTr/LVNstGOWTqWTQxWcGHHLNp+DnUCjU6dnzyH1unX3j
         NzR2Gm09IeuFsqjGUsAhX17SwLC8KpFwFM2UAkrWMNqpzy/NphsgMw6jeFGfeUeO2p
         dwfQHzz7lwv7MQZj39JZ9O57kLYQpk9CEynCrfoWsH2fZWCGyvyo7D5gvNguJdmM/Y
         +PkAKTqP3UhHHitVwdiLG5xYBuPLLDWXJyWeIRMl4R4gX3wT2/OfhM12Wc1ZAfVw/F
         7Qm2aOsT6TSAg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Cleanup kTLS function names and their exposure
Date:   Mon,  4 Apr 2022 15:08:19 +0300
Message-Id: <72319e6020fb2553d02b3bbc7476bda363f6d60c.1649073691.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
References: <cover.1649073691.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The _accel_ part of the function is not relevant anymore, so rename kTLS
functions to be without it, together with header cleanup to do not have
declarations that are not used.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |  4 +--
 .../mellanox/mlx5/core/en_accel/ktls.c        | 12 +++----
 .../mellanox/mlx5/core/en_accel/ktls.h        | 35 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  2 +-
 4 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 458a75607ca8..7f76c4f9389b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -804,7 +804,7 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 
 static u8 mlx5e_build_async_icosq_log_wq_sz(struct mlx5_core_dev *mdev)
 {
-	if (mlx5e_accel_is_ktls_rx(mdev))
+	if (mlx5e_is_ktls_rx(mdev))
 		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
 
 	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
@@ -833,7 +833,7 @@ static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 
 	mlx5e_build_sq_param_common(mdev, param);
 	param->stop_room = mlx5e_stop_room_for_wqe(mdev, 1); /* for XSK NOP */
-	param->is_tls = mlx5e_accel_is_ktls_rx(mdev);
+	param->is_tls = mlx5e_is_ktls_rx(mdev);
 	if (param->is_tls)
 		param->stop_room += mlx5e_stop_room_for_wqe(mdev, 1); /* for TLS RX resync NOP */
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 7f95b833f2ea..814f2a56f633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -97,15 +97,15 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!mlx5e_accel_is_ktls_tx(mdev) && !mlx5e_accel_is_ktls_rx(mdev))
+	if (!mlx5e_is_ktls_tx(mdev) && !mlx5e_is_ktls_rx(mdev))
 		return;
 
-	if (mlx5e_accel_is_ktls_tx(mdev)) {
+	if (mlx5e_is_ktls_tx(mdev)) {
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->features    |= NETIF_F_HW_TLS_TX;
 	}
 
-	if (mlx5e_accel_is_ktls_rx(mdev))
+	if (mlx5e_is_ktls_rx(mdev))
 		netdev->hw_features |= NETIF_F_HW_TLS_RX;
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
@@ -130,7 +130,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 {
 	int err;
 
-	if (!mlx5e_accel_is_ktls_rx(priv->mdev))
+	if (!mlx5e_is_ktls_rx(priv->mdev))
 		return 0;
 
 	priv->tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
@@ -150,7 +150,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 {
-	if (!mlx5e_accel_is_ktls_rx(priv->mdev))
+	if (!mlx5e_is_ktls_rx(priv->mdev))
 		return;
 
 	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
@@ -163,7 +163,7 @@ int mlx5e_ktls_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tls *tls;
 
-	if (!mlx5e_accel_is_ktls_device(priv->mdev))
+	if (!mlx5e_is_ktls_device(priv->mdev))
 		return 0;
 
 	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 50e720966358..d016624fbc9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -14,8 +14,11 @@ int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 			 u32 *p_key_id);
 void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
 
-static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
+static inline bool mlx5e_is_ktls_device(struct mlx5_core_dev *mdev)
 {
+	if (is_kdump_kernel())
+		return false;
+
 	if (!MLX5_CAP_GEN(mdev, tls_tx) && !MLX5_CAP_GEN(mdev, tls_rx))
 		return false;
 
@@ -46,22 +49,16 @@ struct mlx5e_ktls_resync_resp *
 mlx5e_ktls_rx_resync_create_resp_list(void);
 void mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list);
 
-static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
+static inline bool mlx5e_is_ktls_tx(struct mlx5_core_dev *mdev)
 {
 	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_tx);
 }
 
-static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
+static inline bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
 {
 	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_rx);
 }
 
-static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev)
-{
-	return !is_kdump_kernel() &&
-		mlx5_accel_is_ktls_device(mdev);
-}
-
 struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_ctx;
 	atomic64_t tx_tls_del;
@@ -82,19 +79,6 @@ int mlx5e_ktls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
 int mlx5e_ktls_get_stats(struct mlx5e_priv *priv, u64 *data);
 
 #else
-static inline int
-mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-		     struct tls_crypto_info *crypto_info,
-		     u32 *p_key_id) { return -EOPNOTSUPP; }
-static inline void
-mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id) {}
-
-static inline bool
-mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
-static inline bool
-mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
-		      struct tls_crypto_info *crypto_info) { return false; }
-
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
@@ -123,9 +107,10 @@ mlx5e_ktls_rx_resync_create_resp_list(void)
 static inline void
 mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list) {}
 
-static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev) { return false; }
-static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev) { return false; }
-static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
+static inline bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
+{
+	return false;
+}
 
 static inline int mlx5e_ktls_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_ktls_cleanup(struct mlx5e_priv *priv) { }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index cadf322f9d9b..4b6f0d1ea59a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -27,7 +27,7 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 {
 	u16 num_dumps, stop_room = 0;
 
-	if (!mlx5e_accel_is_ktls_tx(mdev))
+	if (!mlx5e_is_ktls_tx(mdev))
 		return 0;
 
 	num_dumps = mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
-- 
2.35.1

