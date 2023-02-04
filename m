Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF55368A952
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjBDKJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjBDKJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD85241E2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B4A60BF9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CFDC4339B;
        Sat,  4 Feb 2023 10:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505359;
        bh=XZoG5Llu7m0NdZLd3wr8VxJ14wdUqgl82qpxNDSUyC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4gvLEo2+b1s9iEPlsHWvhLNbtXOweijY9A8otrqBfgGViCBYSOU+dPkod+mc39hE
         oNvkbeoGVE5MC7OnP5zwOPQt/jv+g/Ihy764fcWUImtork9OI8Iihmh1yMZ7fi4E9u
         IycDkEQCUrY9BR598BGPIKGkrEN+3W+vUmiwLL9Wdm1hmDmBdG75hvAuALE1mDTCjv
         NTCGNqSnND+VpstpmcQz86TPQ9UhUUd7Dv/vPAWf2JjKLeWVSW3+8vXkVrtHPIFxk+
         bYGfiK74I8XIly6PD7fGU6M21XAcMMlTXWYUFpPi4Xnh9ULgVsJ6HRef79qAY/qENk
         pOKNh13g2H++w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Lag, Move mpesw related definitions to mpesw.h
Date:   Sat,  4 Feb 2023 02:08:44 -0800
Message-Id: <20230204100854.388126-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

mpesw definitions should be in mpesw.h and not lag.h.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h | 15 ---------------
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h   | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index f30ac2de639f..66013bef9939 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -50,19 +50,6 @@ struct lag_tracker {
 	enum netdev_lag_hash hash_type;
 };
 
-enum mpesw_op {
-	MLX5_MPESW_OP_ENABLE,
-	MLX5_MPESW_OP_DISABLE,
-};
-
-struct mlx5_mpesw_work_st {
-	struct work_struct work;
-	struct mlx5_lag    *lag;
-	enum mpesw_op	   op;
-	struct completion  comp;
-	int result;
-};
-
 /* LAG data of a ConnectX card.
  * It serves both its phys functions.
  */
@@ -124,8 +111,6 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev);
 bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev);
-void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev);
-int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev);
 
 char *mlx5_get_str_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags);
 void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index f88dc6ec3de1..818f19b5a984 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -12,10 +12,25 @@ struct lag_mpesw {
 	atomic_t mpesw_rule_count;
 };
 
+enum mpesw_op {
+	MLX5_MPESW_OP_ENABLE,
+	MLX5_MPESW_OP_DISABLE,
+};
+
+struct mlx5_mpesw_work_st {
+	struct work_struct work;
+	struct mlx5_lag    *lag;
+	enum mpesw_op      op;
+	struct completion  comp;
+	int result;
+};
+
 int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 			     struct net_device *out_dev,
 			     struct netlink_ext_ack *extack);
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
+void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev);
+int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev);
 #if IS_ENABLED(CONFIG_MLX5_ESWITCH)
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
 void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev);
-- 
2.39.1

