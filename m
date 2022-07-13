Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA2573FE0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiGMW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGMW71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38A32A95D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651ED61A9D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34D9C34114;
        Wed, 13 Jul 2022 22:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753157;
        bh=SNYBYDo2AkYT7p8QZr4zMvSDmCCqgrSewdcSMZugbc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qm4voHxGTanXojubnTPdVfMFBI8SnMg15/wHpCWM3wMnA366iWrG0Z3tH42tPFj+G
         b/b1lgbzU/x1WcANpgtBJJsCiFySh+nn3NLH1SuOKd4No7qQoQjDoqwJ5qyhGgeDwe
         BpLHWlA5/nJuFLdWANo0hEBgqWG93mw78sMDeIkZ8XE9J1m5gx9HdB5n9XuxqiEeXE
         K2DnIwY3NvjZH1U+UQauxfKWtviY0MY49LmrYuK1k7Aj4b2mjF5llrS2ug6gSzYtQB
         Zs+xUL9sOngB39cAKD7SEGsykR29l3kBePBRV3fPzKhyFoo8bRD64xu61afEzikjX5
         srkDk7pdWKw8A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Bridge, rename filter fg to vlan_filter
Date:   Wed, 13 Jul 2022 15:58:51 -0700
Message-Id: <20220713225859.401241-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series introduce new qinq filtering group. To improve
readability rename the existing group in function, variable and definition
names to include "vlan" in order to make it easy to distinguish from
upcoming qinq group.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 38 +++++++++----------
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |  2 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 6547b848242a..4e3197c0e92b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -18,13 +18,13 @@
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM	\
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM +		\
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
@@ -193,8 +193,8 @@ mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flo
 }
 
 static struct mlx5_flow_group *
-mlx5_esw_bridge_ingress_filter_fg_create(struct mlx5_eswitch *esw,
-					 struct mlx5_flow_table *ingress_ft)
+mlx5_esw_bridge_ingress_vlan_filter_fg_create(struct mlx5_eswitch *esw,
+					      struct mlx5_flow_table *ingress_ft)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -216,9 +216,9 @@ mlx5_esw_bridge_ingress_filter_fg_create(struct mlx5_eswitch *esw,
 		 mlx5_eswitch_get_vport_metadata_mask());
 
 	MLX5_SET(create_flow_group_in, in, start_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_FROM);
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM);
 	MLX5_SET(create_flow_group_in, in, end_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_FILTER_GRP_IDX_TO);
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO);
 
 	fg = mlx5_create_flow_group(ingress_ft, in);
 	if (IS_ERR(fg))
@@ -363,7 +363,7 @@ mlx5_esw_bridge_egress_miss_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 static int
 mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_flow_group *mac_fg, *filter_fg, *vlan_fg;
+	struct mlx5_flow_group *mac_fg, *vlan_filter_fg, *vlan_fg;
 	struct mlx5_flow_table *ingress_ft, *skip_ft;
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	int err;
@@ -391,10 +391,10 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 		goto err_vlan_fg;
 	}
 
-	filter_fg = mlx5_esw_bridge_ingress_filter_fg_create(esw, ingress_ft);
-	if (IS_ERR(filter_fg)) {
-		err = PTR_ERR(filter_fg);
-		goto err_filter_fg;
+	vlan_filter_fg = mlx5_esw_bridge_ingress_vlan_filter_fg_create(esw, ingress_ft);
+	if (IS_ERR(vlan_filter_fg)) {
+		err = PTR_ERR(vlan_filter_fg);
+		goto err_vlan_filter_fg;
 	}
 
 	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(esw, ingress_ft);
@@ -406,13 +406,13 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	br_offloads->ingress_ft = ingress_ft;
 	br_offloads->skip_ft = skip_ft;
 	br_offloads->ingress_vlan_fg = vlan_fg;
-	br_offloads->ingress_filter_fg = filter_fg;
+	br_offloads->ingress_vlan_filter_fg = vlan_filter_fg;
 	br_offloads->ingress_mac_fg = mac_fg;
 	return 0;
 
 err_mac_fg:
-	mlx5_destroy_flow_group(filter_fg);
-err_filter_fg:
+	mlx5_destroy_flow_group(vlan_filter_fg);
+err_vlan_filter_fg:
 	mlx5_destroy_flow_group(vlan_fg);
 err_vlan_fg:
 	mlx5_destroy_flow_table(skip_ft);
@@ -426,8 +426,8 @@ mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloa
 {
 	mlx5_destroy_flow_group(br_offloads->ingress_mac_fg);
 	br_offloads->ingress_mac_fg = NULL;
-	mlx5_destroy_flow_group(br_offloads->ingress_filter_fg);
-	br_offloads->ingress_filter_fg = NULL;
+	mlx5_destroy_flow_group(br_offloads->ingress_vlan_filter_fg);
+	br_offloads->ingress_vlan_filter_fg = NULL;
 	mlx5_destroy_flow_group(br_offloads->ingress_vlan_fg);
 	br_offloads->ingress_vlan_fg = NULL;
 	mlx5_destroy_flow_table(br_offloads->skip_ft);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index efc39975226e..3d0bd6e6c33c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -26,7 +26,7 @@ struct mlx5_esw_bridge_offloads {
 
 	struct mlx5_flow_table *ingress_ft;
 	struct mlx5_flow_group *ingress_vlan_fg;
-	struct mlx5_flow_group *ingress_filter_fg;
+	struct mlx5_flow_group *ingress_vlan_filter_fg;
 	struct mlx5_flow_group *ingress_mac_fg;
 
 	struct mlx5_flow_table *skip_ft;
-- 
2.36.1

