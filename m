Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775E96653D4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbjAKFjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjAKFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3240CEB3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C4DCCE1AAF
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA7CC433D2;
        Wed, 11 Jan 2023 05:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415055;
        bh=KsZDG6aULBtjLlpU+Mu1bVSWBjU7N4oO0jB4yr7OyXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQLVkhYZp9VFGP0Vg69EawxL33BlUIYkJnFw/Okj7fZnfYq42647Z7c9Hixps44if
         f6ZzQpP2GqXUqMGWTn60GsxGGenha4y+dfskbG9U+jAYFc+FAmX5dLjwSLkMAx+s2f
         EJBhCwEL9K+LCfkgIA5pKPRaWbeibEBFv9/Br2lA6CMT514xB0vR4liWqTsWO/XqKd
         kFQjpG0gcUfKFX92AF68hFAtnLmBn+uVBA2R25gBqiTp0+VhaniNOUKmf1HMIvX1MH
         dxaRkisc9TE5SCsmoU2e5fBac4R+t6w6MF9UXLySVVfhwBz/R/NfzdC246upZjG1y0
         qWRXeTSUgSk2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Add flow steering debugfs directory
Date:   Tue, 10 Jan 2023 21:30:37 -0800
Message-Id: <20230111053045.413133-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Add a debugfs directory for flow steering related information.
The directory is currently empty, and will hold the 'tc' subdirectory in
a downstream patch.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  5 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 22 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 +++++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  3 ++-
 5 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 379c6dc9a3be..5233d4daca41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -145,7 +145,8 @@ void mlx5e_destroy_flow_steering(struct mlx5e_flow_steering *fs, bool ntuple,
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy);
+					  bool state_destroy,
+					  struct dentry *dfs_root);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
 struct mlx5e_vlan_table *mlx5e_fs_get_vlan(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_tc(struct mlx5e_flow_steering *fs, struct mlx5e_tc_table *tc);
@@ -189,6 +190,8 @@ int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
 			      __be16 proto, u16 vid);
 void mlx5e_fs_init_l2_addr(struct mlx5e_flow_steering *fs, struct net_device *netdev);
 
+struct dentry *mlx5e_fs_get_debugfs_root(struct mlx5e_flow_steering *fs);
+
 #define fs_err(fs, fmt, ...) \
 	mlx5_core_err(mlx5e_fs_get_mdev(fs), fmt, ##__VA_ARGS__)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1892ccb889b3..7298fe782e9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/debugfs.h>
 #include <linux/list.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -67,6 +68,7 @@ struct mlx5e_flow_steering {
 	struct mlx5e_fs_udp            *udp;
 	struct mlx5e_fs_any            *any;
 	struct mlx5e_ptp_fs            *ptp_fs;
+	struct dentry                  *dfs_root;
 };
 
 static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
@@ -104,6 +106,11 @@ static inline int mlx5e_hash_l2(const u8 *addr)
 	return addr[5];
 }
 
+struct dentry *mlx5e_fs_get_debugfs_root(struct mlx5e_flow_steering *fs)
+{
+	return fs->dfs_root;
+}
+
 static void mlx5e_add_l2_to_hash(struct hlist_head *hash, const u8 *addr)
 {
 	struct mlx5e_l2_hash_node *hn;
@@ -1429,9 +1436,19 @@ static int mlx5e_fs_ethtool_alloc(struct mlx5e_flow_steering *fs)
 static void mlx5e_fs_ethtool_free(struct mlx5e_flow_steering *fs) { }
 #endif
 
+static void mlx5e_fs_debugfs_init(struct mlx5e_flow_steering *fs,
+				  struct dentry *dfs_root)
+{
+	if (IS_ERR_OR_NULL(dfs_root))
+		return;
+
+	fs->dfs_root = debugfs_create_dir("fs", dfs_root);
+}
+
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy)
+					  bool state_destroy,
+					  struct dentry *dfs_root)
 {
 	struct mlx5e_flow_steering *fs;
 	int err;
@@ -1458,6 +1475,8 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 	if (err)
 		goto err_free_tc;
 
+	mlx5e_fs_debugfs_init(fs, dfs_root);
+
 	return fs;
 err_free_tc:
 	mlx5e_fs_tc_free(fs);
@@ -1471,6 +1490,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs)
 {
+	debugfs_remove_recursive(fs->dfs_root);
 	mlx5e_fs_ethtool_free(fs);
 	mlx5e_fs_tc_free(fs);
 	mlx5e_fs_vlan_free(fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 16c8bbad5b33..cef8df9cd42b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5231,7 +5231,8 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	mlx5e_timestamp_init(priv);
 
 	fs = mlx5e_fs_init(priv->profile, mdev,
-			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
+			   priv->dfs_root);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 75b9e1528fd2..eecaf46c55de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -788,8 +788,10 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	priv->fs = mlx5e_fs_init(priv->profile, mdev,
-				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+	priv->fs =
+		mlx5e_fs_init(priv->profile, mdev,
+			      !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
+			      priv->dfs_root);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
@@ -807,7 +809,8 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
-				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
+				 priv->dfs_root);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 2c73c8445e63..dd4b255c416b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -374,7 +374,8 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	int err;
 
 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
-				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
+				 priv->dfs_root);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
 		return -ENOMEM;
-- 
2.39.0

