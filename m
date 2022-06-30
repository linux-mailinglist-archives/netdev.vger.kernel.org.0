Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7E560E75
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiF3BAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiF3BAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FA7403D4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2006151E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288AFC34114;
        Thu, 30 Jun 2022 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550820;
        bh=ZrjWM2qW356MwM1p3B8FAmMsZ4SVlUo6ghpw46gnEnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqEAQsaa6bnKSvE2rLyncv0KHNBm3RiAeHsu8a06zzRYHjFeZKNDGIDugk7vUdLs8
         Kt3tlRGPkSlCMHCpZEHF6OPQYtpkzeZCe1q1dbSXfrF6mKwSdJP+3rKEpzBZiCZD35
         fcKFA+oV5M9hw0rxEPx4r/cvm4C6PpTkpSvR6P+FF80ApUqzpvm8hSbA/ogQKdhqeT
         iuctkrl4x5DGNLVnSzqL6Yjn1hJsSvPx0ODA71RVANyW5KnxEL1D+mOCfFx+9/nVvx
         +C929bDSoOKLPHPpiZTgmWz9ztIPlvmyKfH4LwNL5G2EdPOI4x1NDho7na0SokDZKS
         Hmno4oKeFIMcQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Add generic macros to use metadata register mapping
Date:   Wed, 29 Jun 2022 18:00:02 -0700
Message-Id: <20220630010005.145775-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

There are many definitions to get bits and mask for different types of
metadata register mapping, add generic macros to unify them.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c       | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h       | 6 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h          | 4 ++++
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index dea137dd744b..2093cc2b0d48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -22,9 +22,9 @@ struct mlx5e_post_act_handle {
 	u32 id;
 };
 
-#define MLX5_POST_ACTION_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen)
-#define MLX5_POST_ACTION_MAX GENMASK(MLX5_POST_ACTION_BITS - 1, 0)
-#define MLX5_POST_ACTION_MASK MLX5_POST_ACTION_MAX
+#define MLX5_POST_ACTION_BITS MLX5_REG_MAPPING_MBITS(FTEID_TO_REG)
+#define MLX5_POST_ACTION_MASK MLX5_REG_MAPPING_MASK(FTEID_TO_REG)
+#define MLX5_POST_ACTION_MAX MLX5_POST_ACTION_MASK
 
 struct mlx5e_post_act *
 mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 25f51f80a9b4..af959fadbecf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -36,8 +36,8 @@
 #define MLX5_CT_STATE_RELATED_BIT BIT(5)
 #define MLX5_CT_STATE_INVALID_BIT BIT(6)
 
-#define MLX5_CT_LABELS_BITS (mlx5e_tc_attr_to_reg_mappings[LABELS_TO_REG].mlen)
-#define MLX5_CT_LABELS_MASK GENMASK(MLX5_CT_LABELS_BITS - 1, 0)
+#define MLX5_CT_LABELS_BITS MLX5_REG_MAPPING_MBITS(LABELS_TO_REG)
+#define MLX5_CT_LABELS_MASK MLX5_REG_MAPPING_MASK(LABELS_TO_REG)
 
 /* Statically allocate modify actions for
  * ipv6 and port nat (5) + tuple fields (4) + nic mode zone restore (1) = 10.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 00a3ba862afb..6a9933925c4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -84,10 +84,8 @@ struct mlx5_ct_attr {
 	.mlen = ESW_ZONE_ID_BITS,\
 }
 
-#define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
-#define REG_MAPPING_MOFFSET(reg) (mlx5e_tc_attr_to_reg_mappings[reg].moffset)
-#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen)
-#define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
+#define MLX5_CT_ZONE_BITS MLX5_REG_MAPPING_MBITS(ZONE_TO_REG)
+#define MLX5_CT_ZONE_MASK MLX5_REG_MAPPING_MASK(ZONE_TO_REG)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 31b59f6b3f4c..24ff87a0c20f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5086,7 +5086,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tc_skb_ext->chain = chain;
 
-		zone_restore_id = (reg_b >> REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
+		zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
 			ESW_ZONE_ID_MASK;
 
 		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 140b01d4d083..ea12a8bbc7e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -242,6 +242,10 @@ struct mlx5e_tc_attr_to_reg_mapping {
 
 extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
 
+#define MLX5_REG_MAPPING_MOFFSET(reg_id) (mlx5e_tc_attr_to_reg_mappings[reg_id].moffset)
+#define MLX5_REG_MAPPING_MBITS(reg_id) (mlx5e_tc_attr_to_reg_mappings[reg_id].mlen)
+#define MLX5_REG_MAPPING_MASK(reg_id) (GENMASK(mlx5e_tc_attr_to_reg_mappings[reg_id].mlen - 1, 0))
+
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-- 
2.36.1

