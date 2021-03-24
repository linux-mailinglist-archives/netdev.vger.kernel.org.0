Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597323482AB
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhCXUPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51443 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238112AbhCXUOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E3485C0109;
        Wed, 24 Mar 2021 16:14:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/GXuvyfc1q+Bv1USOL+Bf3hL+8tzbHpYPOmj5GtEOAQ=; b=B6xX0alT
        HMVkWM6REDplpGj0tzqe/+eZ/0JxnCFGXWyFFbeqJYUw3t2BFxTJePE0glF7A3Ra
        nTce/QaqiW52QKdesuKsJu3wura4U3ImNHb0qzO6Pm9YEWUQlbgSZV3d0+dw50nV
        jpApDU08QI1dykSSC5Wb2ubvrfk6nBBV4NiuV5SjHuLWMHWTf2Y0rP06kzRIpmpP
        p8SG8ymtKJ8ZBg3TFZNFGqKXtOieankIbm+IVGvP+vpR0Vu8S9GhSYQVVOu3Ueu0
        5bEqTgawzDSGsZNqN1KV9N8nJjBQ5Ok7ldnaosBZxcbeGVRoHHUE21m2dHuwoT6q
        F3GgexJJnoxESQ==
X-ME-Sender: <xms:up1bYIFdw_zynBpe1_yneJ8GWv5vF8BYr0rj_WRc3nipFLaUOV6Tkw>
    <xme:up1bYBXSEn7nmP_I-sNZa4hLwZ0huvyDBbbTFBTADbHQd3VmCBqMwITrj9G2-CQl7
    w2GEDbYl4efH1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:up1bYCKpfm9GHcjd2lglMdEtuJ-76zmXCQHSrkf_hZZWY0YxL7Cdiw>
    <xmx:up1bYKH7HfFwCpOB9MjlFrCvElGxhwuEXoytfqn-x48uS8kyhGf1tw>
    <xmx:up1bYOWNhmwgXmwyMdhf0ILUZ1saIiQhW2b1XmBTYX8ASYW02FTddQ>
    <xmx:up1bYMxuHIjqadRzyjMp5RPLX9Jdb-xF3dKP3q_oB58k5nysM2ipsg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BC0E24033F;
        Wed, 24 Mar 2021 16:14:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_router: Pass payload pointer to nexthop update function
Date:   Wed, 24 Mar 2021 22:14:17 +0200
Message-Id: <20210324201424.157387-4-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Have the caller pass a pointer to the payload of the RATR register to
the function updating a single nexthop / adjacency entry.

In a subsequent patch, this will allow the caller to make sure
replacement was successful by querying the state of the adjacency entry
after replacement and comparing with the initial request.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  3 ++-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  3 +--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 27 ++++++++++---------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  3 ++-
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 9ff286ba9bf0..1a2fef2a5379 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -1178,6 +1178,7 @@ mlxsw_sp_dpipe_table_adj_entries_dump(void *priv, bool counters_enabled,
 
 static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 {
+	char ratr_pl[MLXSW_REG_RATR_LEN];
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_nexthop *nh;
 	u32 adj_hash_index = 0;
@@ -1197,7 +1198,7 @@ static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 			mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 		mlxsw_sp_nexthop_eth_update(mlxsw_sp,
 					    adj_index + adj_hash_index, nh,
-					    true);
+					    true, ratr_pl);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 5e7d9805b349..61eb34e20fde 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -128,11 +128,10 @@ bool mlxsw_sp_l3addr_is_zero(union mlxsw_sp_l3addr addr)
 static int
 mlxsw_sp_ipip_nexthop_update_gre4(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 				  struct mlxsw_sp_ipip_entry *ipip_entry,
-				  bool force)
+				  bool force, char *ratr_pl)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	__be32 daddr4 = mlxsw_sp_ipip_netdev_daddr4(ipip_entry->ol_dev);
-	char ratr_pl[MLXSW_REG_RATR_LEN];
 	enum mlxsw_reg_ratr_op op;
 
 	op = force ? MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY :
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index af7dd19f50e6..f0837b42d1d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -41,7 +41,7 @@ struct mlxsw_sp_ipip_ops {
 
 	int (*nexthop_update)(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 			      struct mlxsw_sp_ipip_entry *ipip_entry,
-			      bool force);
+			      bool force, char *ratr_pl);
 
 	bool (*can_offload)(const struct mlxsw_sp *mlxsw_sp,
 			    const struct net_device *ol_dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 63c2c7a84c64..02200b183bf7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3420,10 +3420,9 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 static int __mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp,
 					 u32 adj_index,
 					 struct mlxsw_sp_nexthop *nh,
-					 bool force)
+					 bool force, char *ratr_pl)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry = nh->neigh_entry;
-	char ratr_pl[MLXSW_REG_RATR_LEN];
 	enum mlxsw_reg_ratr_op op;
 	u16 rif_index;
 
@@ -3459,7 +3458,8 @@ static int __mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp,
 }
 
 int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				struct mlxsw_sp_nexthop *nh, bool force)
+				struct mlxsw_sp_nexthop *nh, bool force,
+				char *ratr_pl)
 {
 	int i;
 
@@ -3467,7 +3467,7 @@ int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 		int err;
 
 		err = __mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index + i,
-						    nh, force);
+						    nh, force, ratr_pl);
 		if (err)
 			return err;
 	}
@@ -3478,18 +3478,19 @@ int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 static int __mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 					  u32 adj_index,
 					  struct mlxsw_sp_nexthop *nh,
-					  bool force)
+					  bool force, char *ratr_pl)
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[nh->ipip_entry->ipipt];
 	return ipip_ops->nexthop_update(mlxsw_sp, adj_index, nh->ipip_entry,
-					force);
+					force, ratr_pl);
 }
 
 static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 					u32 adj_index,
-					struct mlxsw_sp_nexthop *nh, bool force)
+					struct mlxsw_sp_nexthop *nh, bool force,
+					char *ratr_pl)
 {
 	int i;
 
@@ -3497,7 +3498,7 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 		int err;
 
 		err = __mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index + i,
-						     nh, force);
+						     nh, force, ratr_pl);
 		if (err)
 			return err;
 	}
@@ -3506,7 +3507,8 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				   struct mlxsw_sp_nexthop *nh, bool force)
+				   struct mlxsw_sp_nexthop *nh, bool force,
+				   char *ratr_pl)
 {
 	/* When action is discard or trap, the nexthop must be
 	 * programmed as an Ethernet nexthop.
@@ -3515,10 +3517,10 @@ static int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
 	    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
 		return mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index, nh,
-						   force);
+						   force, ratr_pl);
 	else
 		return mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index, nh,
-						    force);
+						    force, ratr_pl);
 }
 
 static int
@@ -3526,6 +3528,7 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_nexthop_group_info *nhgi,
 			      bool reallocate)
 {
+	char ratr_pl[MLXSW_REG_RATR_LEN];
 	u32 adj_index = nhgi->adj_index; /* base */
 	struct mlxsw_sp_nexthop *nh;
 	int i;
@@ -3542,7 +3545,7 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 			int err = 0;
 
 			err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh,
-						      true);
+						      true, ratr_pl);
 			if (err)
 				return err;
 			nh->update = 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 3bb2a06359a3..b85c5f6c2262 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -209,7 +209,8 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh);
 int mlxsw_sp_nexthop_counter_get(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_nexthop *nh, u64 *p_counter);
 int mlxsw_sp_nexthop_eth_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				struct mlxsw_sp_nexthop *nh, bool force);
+				struct mlxsw_sp_nexthop *nh, bool force,
+				char *ratr_pl);
 void mlxsw_sp_nexthop_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_nexthop *nh);
 void mlxsw_sp_nexthop_counter_free(struct mlxsw_sp *mlxsw_sp,
-- 
2.30.2

