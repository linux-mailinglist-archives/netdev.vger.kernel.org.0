Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9AC59D0D8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiHWFz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiHWFzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A425E554
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B629B81B7D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C501CC433D7;
        Tue, 23 Aug 2022 05:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234147;
        bh=3fHUWZ7Fu3Ni1Ff/s1+CL1/oTGq+r2hRZzOIbiQKwe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyukYz4/Zi8NqdhH4DicrePheC/IRvZX55v2zBJLZ5rvgE3wEmzYJIsVT8R/hUEB7
         HbXFvQSNWTQHi9TYHdIDZne0yxZAVzP1O9nfYqptJLMfdcQzDXddKFtAaQz6RZBWvk
         sOMTGpoijS8F77TgvJ1z4w9/xe9CjEoPPeEHdueRmgD8VudL8MGBdRCYxY9BDWLGcd
         p1A7qKUxoh0Z1NnzSPf3QkB8l1r17cBm4zZuOgUoh9oot/R7H7zOAWc8ags4VXg6fV
         joiNeiHlJ+TIPwQwe7AUl7nYjzUoVubtZeHZbKAdKK7T/4E0QvmvVzZst+M094ILsz
         3qj6foM/aRxmw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Drop priv argument of ptp function in en_fs
Date:   Mon, 22 Aug 2022 22:55:22 -0700
Message-Id: <20220823055533.334471-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
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

From: Lama Kayal <lkayal@nvidia.com>

Both mlx5e_ptp_alloc_rx_fs and mlx5e_ptp_free_rx_fs only
make use of two priv member, pass them directly instead.
This will help dropping priv from all en_fs file.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 24 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  6 +++--
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  4 ++--
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 3fdaacc2abde..6fefce30d296 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -622,12 +622,10 @@ static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
 	return bitmap_empty(c->state, MLX5E_PTP_STATE_NUM_STATES) ? -EINVAL : 0;
 }
 
-static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
+static void mlx5e_ptp_rx_unset_fs(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_flow_steering *fs = priv->fs;
-	struct mlx5e_ptp_fs *ptp_fs;
+	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(fs);
 
-	ptp_fs = mlx5e_fs_get_ptp(fs);
 	if (!ptp_fs->valid)
 		return;
 
@@ -801,29 +799,31 @@ int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn)
 	return 0;
 }
 
-int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv)
+int mlx5e_ptp_alloc_rx_fs(struct mlx5e_flow_steering *fs,
+			  const struct mlx5e_profile *profile)
 {
 	struct mlx5e_ptp_fs *ptp_fs;
 
-	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
+	if (!mlx5e_profile_feature_cap(profile, PTP_RX))
 		return 0;
 
 	ptp_fs = kzalloc(sizeof(*ptp_fs), GFP_KERNEL);
 	if (!ptp_fs)
 		return -ENOMEM;
-	mlx5e_fs_set_ptp(priv->fs, ptp_fs);
+	mlx5e_fs_set_ptp(fs, ptp_fs);
 
 	return 0;
 }
 
-void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv)
+void mlx5e_ptp_free_rx_fs(struct mlx5e_flow_steering *fs,
+			  const struct mlx5e_profile *profile)
 {
-	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
+	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(fs);
 
-	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
+	if (!mlx5e_profile_feature_cap(profile, PTP_RX))
 		return;
 
-	mlx5e_ptp_rx_unset_fs(priv);
+	mlx5e_ptp_rx_unset_fs(fs);
 	kfree(ptp_fs);
 }
 
@@ -849,6 +849,6 @@ int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set)
 		netdev_WARN_ONCE(priv->netdev, "Don't try to remove PTP RX-FS rules");
 		return -EINVAL;
 	}
-	mlx5e_ptp_rx_unset_fs(priv);
+	mlx5e_ptp_rx_unset_fs(priv->fs);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 92dbbec472ec..5bce554e131a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -74,8 +74,10 @@ void mlx5e_ptp_close(struct mlx5e_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
 int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
-int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv);
-void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv);
+int mlx5e_ptp_alloc_rx_fs(struct mlx5e_flow_steering *fs,
+			  const struct mlx5e_profile *profile);
+void mlx5e_ptp_free_rx_fs(struct mlx5e_flow_steering *fs,
+			  const struct mlx5e_profile *profile);
 int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set);
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index ffcc9a94fc7d..a84559b2bd92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1338,7 +1338,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_l2_table;
 	}
 
-	err = mlx5e_ptp_alloc_rx_fs(priv);
+	err = mlx5e_ptp_alloc_rx_fs(priv->fs, priv->profile);
 	if (err)
 		goto err_destory_vlan_table;
 
@@ -1362,7 +1362,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 {
-	mlx5e_ptp_free_rx_fs(priv);
+	mlx5e_ptp_free_rx_fs(priv->fs, priv->profile);
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
 	mlx5e_destroy_ttc_table(priv);
-- 
2.37.1

