Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABAA4F5E2B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiDFMeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiDFMbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B501621A0EC;
        Wed,  6 Apr 2022 01:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B6A160BBC;
        Wed,  6 Apr 2022 08:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E474FC385A9;
        Wed,  6 Apr 2022 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233581;
        bh=xr9ehIzB/NufyUUmJObt5E7/ADYvqnVGS1WjCAn3n7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duYGvNgO2c/7ESg2X+pseYZcAu113bXILQDxFmUzZbBEF4ZxMObQGsjvPrvgp22Jh
         f1BH226n3SaBFHjH8JFTAvefvdS/jZtn9rXsKK+Mf7t6FC5EAIPtYx2he2sol0HXN2
         C13XCF9DsyMl8dyrsgjXmN5x3Rcs4j8Ge9jPjqqMXCvhu+s/t5E7Zc9mDdVc3wLoZL
         O5ZJDQW4TK6TZd1cJ6ooDAacoNtIzFUsPSn9dtUt3FJldvWAHlL2A919xWzvwnXtJx
         RXi1CjHn4Iu87s2d3MNEKwPaHbjcUXKGSX8GZKiOeWgFwCBxewLI+Ye44Kw0ceJ3+3
         5Bfa2la/7URsQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 04/17] net/mlx5: Remove XFRM no_trailer flag
Date:   Wed,  6 Apr 2022 11:25:39 +0300
Message-Id: <636d75421e1ca4254a062537eea001ab0e50e19b.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

Only FPGA needed this NO_TRAILER flag, so remove this assignment.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c      | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 213fbf63dde9..13f6fed74950 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -426,8 +426,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
 	ipsec->en_priv = priv;
-	ipsec->no_trailer = !!(mlx5_accel_ipsec_device_caps(priv->mdev) &
-			       MLX5_ACCEL_IPSEC_CAP_RX_NO_TRAILER);
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
 	if (!ipsec->wq) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 51ae6145b6fe..6e4f0dbbd4e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -81,7 +81,6 @@ struct mlx5e_ipsec_tx;
 struct mlx5e_ipsec {
 	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
-	bool no_trailer;
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
 	struct mlx5e_ipsec_stats stats;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 28e0500d4a48..8e0cf5e65100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -347,8 +347,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 	switch (MLX5_IPSEC_METADATA_SYNDROM(ipsec_meta_data)) {
 	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_DECRYPTED:
 		xo->status = CRYPTO_SUCCESS;
-		if (WARN_ON_ONCE(priv->ipsec->no_trailer))
-			xo->flags |= XFRM_ESP_NO_TRAILER;
 		break;
 	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_AUTH_FAILED:
 		xo->status = CRYPTO_TUNNEL_ESP_AUTH_FAILED;
-- 
2.35.1

