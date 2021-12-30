Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429794819C6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 06:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbhL3F0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 00:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhL3F0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 00:26:37 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE1DC061574;
        Wed, 29 Dec 2021 21:26:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i6so11464240pla.0;
        Wed, 29 Dec 2021 21:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBfKAR7Z0HvFlnOfOE8iZZtu+svlpTiRXVznPLBhBr8=;
        b=GhsObzuwLok/kU5J0NDWVY7lKhYkMk29B5r7R/wdy5Wmh0Cn4ZSLk9L4gXYmgwK7NA
         mKha6wFj/o8PDmq5rrLwrwMihj8CGV76ggknZR3Dhk9z14BbAJejWbOdCPqK0gvPZQ94
         9y/ykl40+9qVFwMcrmMygvlA3JnVn9U8jM40H0CPHicd8gkrO558m5t9b1Iliv7Qf0zO
         rT2sPpJfQs8/0WOy4/kQEXpDnS+R1HBuAjjV7AX7NrHb+KDUOyHQ4ac0cVvgiEEdZUfL
         jSmmK3TdddyJXkudkIDgGi4umpviL3go92D9eEH2GCES7eLJ12Af7R+OvmI667y/Xp15
         8Mbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBfKAR7Z0HvFlnOfOE8iZZtu+svlpTiRXVznPLBhBr8=;
        b=xtmTpVnFWtMAKZGmdOZdV0vT2tksoRZGNHFP/K/8kEObbyopMpXo8+YW6jPf6xZ6Ld
         uR6AjGJ+2RXRIdXT+L19F5Oxb/ZFFYxM/FxQjY7ezv7RJZcGThq43eKubKgb+Fg21iyE
         gUGItidynzZcozuKUKDO/84v1iytRkC5zfVRm2vdO5T0NfVoUhXN2Qx31fCqRNwyqpmL
         TAUV2VVHHRsA8fbe9Gm9EgUuysggjtAftwUTx1cDkdiRQqMSa6aF47e+xO6mGRSlcPqU
         fWK/ZdRAx+E5+SIYTXZonMn/riin5nFWVCCK7AK1u3qsZKBCuupCz5iDmKgYKXT5NqHB
         XldQ==
X-Gm-Message-State: AOAM530xJN2KTv5QgBC4zsIewhAVvrxC2fjDzwym9r8W3IrYxeoR8BWt
        AXSBtjmjX9jvpoLlGtVKFGs=
X-Google-Smtp-Source: ABdhPJwwWmDpzWto9NXobEcVhGhf7n3vowJC18NLTwe+NGkb7btEndGF1RD6xVHKh8Rpbj/DSYrTyg==
X-Received: by 2002:a17:902:e5c8:b0:149:14b:f2da with SMTP id u8-20020a170902e5c800b00149014bf2damr29585892plf.110.1640841996605;
        Wed, 29 Dec 2021 21:26:36 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.gmail.com with ESMTPSA id p10sm25284587pfw.69.2021.12.29.21.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 21:26:36 -0800 (PST)
From:   Zizhuang Deng <sunsetdzz@gmail.com>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>
Subject: [PATCH] net/mlx5: Add vport return value checks
Date:   Thu, 30 Dec 2021 13:25:58 +0800
Message-Id: <20211230052558.959617-1-sunsetdzz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add missing vport return value checks for recent code, as in [1].

Ref:
[1] https://lkml.org/lkml/2020/11/1/315

Signed-off-by: Zizhuang Deng <sunsetdzz@gmail.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f4eaa5893886..fda214021738 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1230,6 +1230,8 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 
 	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
 		esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
 						   spec, MLX5_VPORT_PF);
 
@@ -1244,6 +1246,8 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
 		MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_ECPF);
 		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
 					   spec, &flow_act, &dest, 1);
@@ -1281,11 +1285,15 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	}
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
 		mlx5_del_flow_rules(flows[vport->index]);
 	}
 add_ecpf_flow_err:
 	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
 		mlx5_del_flow_rules(flows[vport->index]);
 	}
 add_pf_flow_err:
@@ -1309,11 +1317,15 @@ static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw)
 
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		if (IS_ERR(vport))
+			return;
 		mlx5_del_flow_rules(flows[vport->index]);
 	}
 
 	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+		if (IS_ERR(vport))
+			return;
 		mlx5_del_flow_rules(flows[vport->index]);
 	}
 	kvfree(flows);
@@ -2385,6 +2397,9 @@ static int esw_set_uplink_slave_ingress_root(struct mlx5_core_dev *master,
 	if (master) {
 		esw = master->priv.eswitch;
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
+
 		MLX5_SET(set_flow_table_root_in, in, table_of_other_vport, 1);
 		MLX5_SET(set_flow_table_root_in, in, table_vport_number,
 			 MLX5_VPORT_UPLINK);
@@ -2405,6 +2420,9 @@ static int esw_set_uplink_slave_ingress_root(struct mlx5_core_dev *master,
 	} else {
 		esw = slave->priv.eswitch;
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+		if (IS_ERR(vport))
+			return PTR_ERR(vport);
+
 		ns = mlx5_get_flow_vport_acl_namespace(slave,
 						       MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 						       vport->index);
@@ -2590,6 +2608,8 @@ static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev)
 
 	vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
 				       dev->priv.eswitch->manager_vport);
+	if (IS_ERR(vport))
+		return;
 
 	esw_acl_egress_ofld_cleanup(vport);
 }
-- 
2.25.1

