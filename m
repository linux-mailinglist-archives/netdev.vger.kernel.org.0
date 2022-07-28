Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12558476A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiG1U65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiG1U6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:58:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CE7785BC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7356189A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1344EC433C1;
        Thu, 28 Jul 2022 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041864;
        bh=oEh2FVFLDKJi/uR5LmLZ5XV4gMf06uC+22/BN4f9GA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpPuR3ldOCnJCNyqgahwfWuuDfuRrxzT6F9Ses411bA30xF1xoFA9pzo48D8MMVLy
         9f9p4f9blkqEdDLfBi3OCxPsnKfJnQWChz2hSeQ1sGvqJ7fbnAH10mnFabfD9S8w6M
         0jvqAzhS0pw6Q2NTQxou5ReMDz95B8y2d7P6+VZEDIKuquezUXEQQF28qSUhOaK2uW
         cOEebljRacYQFwlkaZEzRGf5p+wui9hO5aJLFdW9enGYbfI+0gywF0w3f8bT5+cHzD
         59Fu1kAVb3NqLTxrYMEGngBD3GpbVs+72FVixjs2i1AmnMFgJujAI0MQxU2oi27HO3
         sXHLqvgGb9ZRw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Move mlx5e_init_l2_addr to en_main
Date:   Thu, 28 Jul 2022 13:57:28 -0700
Message-Id: <20220728205728.143074-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Move the function declaration of mlx5e_init_l2_addr to en/fs.h, rename
to mlx5e_fs_init_l2_addr to align with the fs API functions naming
convention and let it take mlx5e_flow_steering as arguments while keeping
implementation at en_fs.c file. This helps maintain a clean driver code
and avoids unnecessary dependencies.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 37152073c645..bea4a1329474 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1024,7 +1024,6 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s);
 
-void mlx5e_init_l2_addr(struct mlx5e_priv *priv);
 int mlx5e_self_test_num(struct mlx5e_priv *priv);
 int mlx5e_self_test_fill_strings(struct mlx5e_priv *priv, u8 *data);
 void mlx5e_self_test(struct net_device *ndev, struct ethtool_test *etest,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 83f67e536ca0..9b8cdf2e68ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -197,5 +197,6 @@ int mlx5e_fs_vlan_rx_add_vid(struct mlx5e_flow_steering *fs,
 int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
 			      struct net_device *netdev,
 			      __be16 proto, u16 vid);
+void mlx5e_fs_init_l2_addr(struct mlx5e_flow_steering *fs, struct net_device *netdev);
 #endif /* __MLX5E_FLOW_STEER_H__ */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 121407f57564..e2a9b9be5c1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -843,9 +843,9 @@ static void mlx5e_destroy_groups(struct mlx5e_flow_table *ft)
 	ft->num_groups = 0;
 }
 
-void mlx5e_init_l2_addr(struct mlx5e_priv *priv)
+void mlx5e_fs_init_l2_addr(struct mlx5e_flow_steering *fs, struct net_device *netdev)
 {
-	ether_addr_copy(priv->fs->l2.broadcast.addr, priv->netdev->broadcast);
+	ether_addr_copy(fs->l2.broadcast.addr, netdev->broadcast);
 }
 
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2a6f5de2db28..426cbeac89f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5186,7 +5186,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	mlx5e_init_l2_addr(priv);
+	mlx5e_fs_init_l2_addr(priv->fs, netdev);
 
 	/* Marking the link as currently not needed by the Driver */
 	if (!netif_running(netdev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3ad9752c35ee..4c1599de652c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -849,7 +849,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 		goto err_free_fs;
 	}
 
-	mlx5e_init_l2_addr(priv);
+	mlx5e_fs_init_l2_addr(priv->fs, priv->netdev);
 
 	err = mlx5e_open_drop_rq(priv, &priv->drop_rq);
 	if (err) {
-- 
2.37.1

