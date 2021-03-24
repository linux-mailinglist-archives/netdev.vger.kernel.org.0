Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1E3482AA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhCXUPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49781 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238110AbhCXUOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D1D65C00CA;
        Wed, 24 Mar 2021 16:14:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dgo2kfSA3tve4cjNHw+uJI4WmKLvZ47xH0+PN2eDRgg=; b=cEDqMhBI
        dHzeIsYMTrBRE6xA0ayYAcdV6zanyjX+54kRGv2Rf6e+0R4w7/unTZmn2qKcQT/A
        x2R0ESUeMgtj4ipC2iDzpO3IcnLbG0j4AgVXQj585zc5vEdQtvVrArcgOgDhGuKN
        D+xhjow2Dsiw4CsDY915ckkVmo0YvmEKwygwvg0x2hFp300MdnrNiBCP9qnDrhpJ
        b1jqNHnJfH8PubHkeOkIiESojDuwQTJykPuLRKRWMjFf+FkG1EXzrX1gO7xd36v8
        Rh1WsTFuxVGlXU1OY5t7cTffMImueM8gNLayUPF14BX3+syFgGmUsrRkiL/T/3TY
        9dAgjNRMyyd/JA==
X-ME-Sender: <xms:uJ1bYLUofdxhfI6ii4mXWicKMMC4pYOfK0_O0eoU4hIBkDiP9ZLcjw>
    <xme:uJ1bYDkPrxhOYFv10_GnMQmXFXBx7PCjBKVoQQCUdOgm5IFVcN9BTjWWBgauAMB3v
    WH6pm0yLURcMBc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uJ1bYHYJIzg_H6xskOzpbJW3Uwgc-FzA0aVzln2uhgd5pPfTIOOyWQ>
    <xmx:uJ1bYGV3FrM0o-UXaLCVIz0JWltAbCuOIGEGhlTqG63tU3ugLqutew>
    <xmx:uJ1bYFlYNVNGP3USrQPh7nRrXTWylFggBZ3OTrwhGQ6UNRm8Hpmc6A>
    <xmx:uJ1bYOAeN_Ai_xsZTaQmpgV-K-fHH1dzIe7I7HqwO36YOm2P0Pm5pg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25CD624041F;
        Wed, 24 Mar 2021 16:14:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_router: Add ability to overwrite adjacency entry only when inactive
Date:   Wed, 24 Mar 2021 22:14:16 +0200
Message-Id: <20210324201424.157387-3-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Allow the driver to instruct the device to only overwrite an adjacency
entry if its activity is cleared. Currently, adjacency entry is always
overwritten, regardless of activity.

This will be used by subsequent patches to prevent replacement of active
nexthop buckets.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  9 +++--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 34 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 +-
 5 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index af2093fc5025..9ff286ba9bf0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -1196,7 +1196,8 @@ static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 		else
 			mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 		mlxsw_sp_nexthop_eth_update(mlxsw_sp,
-					    adj_index + adj_hash_index, nh);
+					    adj_index + adj_hash_index, nh,
+					    true);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 459049c8d065..5e7d9805b349 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -127,14 +127,17 @@ bool mlxsw_sp_l3addr_is_zero(union mlxsw_sp_l3addr addr)
 
 static int
 mlxsw_sp_ipip_nexthop_update_gre4(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				  struct mlxsw_sp_ipip_entry *ipip_entry)
+				  struct mlxsw_sp_ipip_entry *ipip_entry,
+				  bool force)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	__be32 daddr4 = mlxsw_sp_ipip_netdev_daddr4(ipip_entry->ol_dev);
 	char ratr_pl[MLXSW_REG_RATR_LEN];
+	enum mlxsw_reg_ratr_op op;
 
-	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
-			    true, MLXSW_REG_RATR_TYPE_IPIP,
+	op = force ? MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY :
+		     MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY_ON_ACTIVITY;
+	mlxsw_reg_ratr_pack(ratr_pl, op, true, MLXSW_REG_RATR_TYPE_IPIP,
 			    adj_index, rif_index);
 	mlxsw_reg_ratr_ipip4_entry_pack(ratr_pl, be32_to_cpu(daddr4));
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 87bef9880e5e..af7dd19f50e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -40,7 +40,8 @@ struct mlxsw_sp_ipip_ops {
 	enum mlxsw_sp_l3proto ul_proto; /* Underlay. */
 
 	int (*nexthop_update)(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-			      struct mlxsw_sp_ipip_entry *ipip_entry);
+			      struct mlxsw_sp_ipip_entry *ipip_entry,
+			      bool force);
 
 	bool (*can_offload)(const struct mlxsw_sp *mlxsw_sp,
 			    const struct net_device *ol_dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index db859c2bd810..63c2c7a84c64 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3419,16 +3419,19 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 
 static int __mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp,
 					 u32 adj_index,
-					 struct mlxsw_sp_nexthop *nh)
+					 struct mlxsw_sp_nexthop *nh,
+					 bool force)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry = nh->neigh_entry;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
+	enum mlxsw_reg_ratr_op op;
 	u16 rif_index;
 
 	rif_index = nh->rif ? nh->rif->rif_index :
 			      mlxsw_sp->router->lb_rif_index;
-	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
-			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
+	op = force ? MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY :
+		     MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY_ON_ACTIVITY;
+	mlxsw_reg_ratr_pack(ratr_pl, op, true, MLXSW_REG_RATR_TYPE_ETHERNET,
 			    adj_index, rif_index);
 	switch (nh->action) {
 	case MLXSW_SP_NEXTHOP_ACTION_FORWARD:
@@ -3456,7 +3459,7 @@ static int __mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp,
 }
 
 int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				struct mlxsw_sp_nexthop *nh)
+				struct mlxsw_sp_nexthop *nh, bool force)
 {
 	int i;
 
@@ -3464,7 +3467,7 @@ int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 		int err;
 
 		err = __mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index + i,
-						    nh);
+						    nh, force);
 		if (err)
 			return err;
 	}
@@ -3474,17 +3477,19 @@ int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 
 static int __mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 					  u32 adj_index,
-					  struct mlxsw_sp_nexthop *nh)
+					  struct mlxsw_sp_nexthop *nh,
+					  bool force)
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[nh->ipip_entry->ipipt];
-	return ipip_ops->nexthop_update(mlxsw_sp, adj_index, nh->ipip_entry);
+	return ipip_ops->nexthop_update(mlxsw_sp, adj_index, nh->ipip_entry,
+					force);
 }
 
 static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 					u32 adj_index,
-					struct mlxsw_sp_nexthop *nh)
+					struct mlxsw_sp_nexthop *nh, bool force)
 {
 	int i;
 
@@ -3492,7 +3497,7 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 		int err;
 
 		err = __mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index + i,
-						     nh);
+						     nh, force);
 		if (err)
 			return err;
 	}
@@ -3501,7 +3506,7 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				   struct mlxsw_sp_nexthop *nh)
+				   struct mlxsw_sp_nexthop *nh, bool force)
 {
 	/* When action is discard or trap, the nexthop must be
 	 * programmed as an Ethernet nexthop.
@@ -3509,9 +3514,11 @@ static int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	if (nh->type == MLXSW_SP_NEXTHOP_TYPE_ETH ||
 	    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
 	    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
-		return mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index, nh);
+		return mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index, nh,
+						   force);
 	else
-		return mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index, nh);
+		return mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index, nh,
+						    force);
 }
 
 static int
@@ -3534,7 +3541,8 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 		if (nh->update || reallocate) {
 			int err = 0;
 
-			err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh);
+			err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh,
+						      true);
 			if (err)
 				return err;
 			nh->update = 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 01fd9a3d5944..3bb2a06359a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -209,7 +209,7 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh);
 int mlxsw_sp_nexthop_counter_get(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_nexthop *nh, u64 *p_counter);
 int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				struct mlxsw_sp_nexthop *nh);
+				struct mlxsw_sp_nexthop *nh, bool force);
 void mlxsw_sp_nexthop_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_nexthop *nh);
 void mlxsw_sp_nexthop_counter_free(struct mlxsw_sp *mlxsw_sp,
-- 
2.30.2

