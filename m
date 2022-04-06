Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080684F5C4E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiDFLhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiDFLfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:35:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBD855F37C;
        Wed,  6 Apr 2022 01:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DFA960B57;
        Wed,  6 Apr 2022 08:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79189C385A3;
        Wed,  6 Apr 2022 08:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233574;
        bh=Kfs6dDA5Q2GssdFNWVdwG35r8G111lJgJljnX9ySpj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcyUkQxYYz/aGlBKOva1XfSEj/8hGDwbUgrfLcLb0fcCGYGd6Xva7qzfRD/+Fj/Bn
         xKnBlnhks3tkfI04ip16WhUlggFIAe37Jdk4+2RUg9xLiF6UvOE8bakw7NZ8SpvM/o
         5qyX/B4SdsyD6SUAuyoymvKTGHFmLaeiTP9DsPPdnexnEkMSgQWkadEDP2bHDhwhTC
         sKwXt/qIEm7UoxezUoUYW9iO2SMaesj3mVLZGwMEGcTxPnheChMGcSFknT8gC2FRAq
         EBRomjjHWryiemybcezBqUWSEvC4G9tkLr11VuOSSfwr1uNr+Sz/zqlH7itY67J7Q0
         qLDGsDKArsp1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 05/17] net/mlx5: Remove FPGA ipsec specific statistics
Date:   Wed,  6 Apr 2022 11:25:40 +0300
Message-Id: <3f194752881e095910c887dd5cede1dcba6acaf3.1649232994.git.leonro@nvidia.com>
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

Delete the statistics that is not used anymore.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 19 --------
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c | 46 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  1 -
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 -
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 -
 5 files changed, 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 6e4f0dbbd4e4..ee50052cbcb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -55,24 +55,6 @@ struct mlx5e_ipsec_sw_stats {
 	atomic64_t ipsec_tx_drop_no_state;
 	atomic64_t ipsec_tx_drop_not_ip;
 	atomic64_t ipsec_tx_drop_trailer;
-	atomic64_t ipsec_tx_drop_metadata;
-};
-
-struct mlx5e_ipsec_stats {
-	u64 ipsec_dec_in_packets;
-	u64 ipsec_dec_out_packets;
-	u64 ipsec_dec_bypass_packets;
-	u64 ipsec_enc_in_packets;
-	u64 ipsec_enc_out_packets;
-	u64 ipsec_enc_bypass_packets;
-	u64 ipsec_dec_drop_packets;
-	u64 ipsec_dec_auth_fail_packets;
-	u64 ipsec_enc_drop_packets;
-	u64 ipsec_add_sa_success;
-	u64 ipsec_add_sa_fail;
-	u64 ipsec_del_sa_success;
-	u64 ipsec_del_sa_fail;
-	u64 ipsec_cmd_drop;
 };
 
 struct mlx5e_accel_fs_esp;
@@ -83,7 +65,6 @@ struct mlx5e_ipsec {
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
-	struct mlx5e_ipsec_stats stats;
 	struct workqueue_struct *wq;
 	struct mlx5e_accel_fs_esp *rx_fs;
 	struct mlx5e_ipsec_tx *tx_fs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 1607c305d3ab..80886290fd22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -39,23 +39,6 @@
 #include "fpga/sdk.h"
 #include "en_accel/ipsec.h"
 
-static const struct counter_desc mlx5e_ipsec_hw_stats_desc[] = {
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_in_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_out_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_bypass_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_enc_in_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_enc_out_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_enc_bypass_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_drop_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_auth_fail_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_enc_drop_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_add_sa_success) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_add_sa_fail) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_del_sa_success) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_del_sa_fail) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_cmd_drop) },
-};
-
 static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sp_alloc) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sadb_miss) },
@@ -64,13 +47,11 @@ static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_tx_drop_no_state) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_tx_drop_not_ip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_tx_drop_trailer) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_tx_drop_metadata) },
 };
 
 #define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
 	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
 
-#define NUM_IPSEC_HW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_hw_stats_desc)
 #define NUM_IPSEC_SW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_sw_stats_desc)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_sw)
@@ -102,31 +83,4 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_sw)
 	return idx;
 }
 
-static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_hw)
-{
-	return 0;
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_hw)
-{
-	int ret = 0;
-
-	if (priv->ipsec)
-		ret = mlx5_accel_ipsec_counters_read(priv->mdev, (u64 *)&priv->ipsec->stats,
-						     NUM_IPSEC_HW_COUNTERS);
-	if (ret)
-		memset(&priv->ipsec->stats, 0, sizeof(priv->ipsec->stats));
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec_hw)
-{
-	return idx;
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_hw)
-{
-	return idx;
-}
-
 MLX5E_DEFINE_STATS_GRP(ipsec_sw, 0);
-MLX5E_DEFINE_STATS_GRP(ipsec_hw, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6b7e7ea6ded2..47f7b4c034cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1112,7 +1112,6 @@ static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] = {
 	&MLX5E_STATS_GRP(per_port_buff_congest),
 #ifdef CONFIG_MLX5_EN_IPSEC
 	&MLX5E_STATS_GRP(ipsec_sw),
-	&MLX5E_STATS_GRP(ipsec_hw),
 #endif
 	&MLX5E_STATS_GRP(ptp),
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 5123a220d7a4..57fa0489eeb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2443,7 +2443,6 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(pme),
 #ifdef CONFIG_MLX5_EN_IPSEC
 	&MLX5E_STATS_GRP(ipsec_sw),
-	&MLX5E_STATS_GRP(ipsec_hw),
 #endif
 	&MLX5E_STATS_GRP(tls),
 	&MLX5E_STATS_GRP(channels),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index a7a025d15c14..e48b15b55b6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -482,7 +482,6 @@ extern MLX5E_DECLARE_STATS_GRP(per_prio);
 extern MLX5E_DECLARE_STATS_GRP(pme);
 extern MLX5E_DECLARE_STATS_GRP(channels);
 extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
-extern MLX5E_DECLARE_STATS_GRP(ipsec_hw);
 extern MLX5E_DECLARE_STATS_GRP(ipsec_sw);
 extern MLX5E_DECLARE_STATS_GRP(ptp);
 
-- 
2.35.1

