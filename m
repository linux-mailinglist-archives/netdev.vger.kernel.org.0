Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81502B1F88
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgKMQGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:38 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46109 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbgKMQGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 44A6B5C018D;
        Fri, 13 Nov 2020 11:06:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=s9HSTwGObTp1TvVq68EhLBtu0O7srBE/wOM0/3ejhBM=; b=qbgyX+Ep
        MUZayw4gcrUgtI9k2c5yEW4+N9J6MPTE/+Qi822ZpzFMDjvNoKaDegYy890zyEFE
        ofAQ1CBK9nwEey4nFxcp4r4pn7c/5UYx4KFYJfsOs2JIQ03iHNB6MafDprpAqsvk
        Dw2a6sSULoPy5hUokAH+dmTVLDGCiJNiVzvsWaft8SiW8w1L/RZ4LUA2DwOwDIYW
        dxZLRHWm5hpj5HIcZuOO3BdL7TDmVbFa/9a3ZjOFRh4x4LTU2h9+441oFrxsknRl
        jhRj39mQZrlgmoKdl7qm/8qCczSnFtXkAGknCUaO8JLJq3IJ2AQsHCFMWfahqhpR
        CkoJWJPmhi2XUA==
X-ME-Sender: <xms:C6-uXyPnpAqty7GcQC4oB8DovePQ2iljZo2Bl2xAuBgLicc5BKLt7g>
    <xme:C6-uXw_4GWa00cFVWsmtepwgIWDZRz6FPg-c9zZDQ_rnJa4x25TUoCtOgApsk8l1u
    ZCRBqvGyT3RDWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:C6-uX5RwIHXYm5GsTwec3tf9IivMNSm1Ln-H3GuaIk4QAnh3737o_w>
    <xmx:C6-uXytTSGm1kiKGishPEIH4FtkSBxcPdS0WzaxCrei3cCzmfk1hGg>
    <xmx:C6-uX6fPawCyzNV2OgWIUFVcO2YMUHEe2NXToM_8V-j94cm_gp3fRQ>
    <xmx:C6-uX642MSZwaM477PyX7MOSTe6Y0n0u2wy2nCZEHX6Iedk9jPgRYQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A9E13280059;
        Fri, 13 Nov 2020 11:06:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/15] mlxsw: spectrum_router: Add nexthop group type field
Date:   Fri, 13 Nov 2020 18:05:46 +0200
Message-Id: <20201113160559.22148-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the type (i.e., IPv4/IPv6) of the nexthop group is derived
from the neighbour table associated with the group.

This is problematic when nexthop objects are taken into account, as a
nexthop group object can contain both IPv4 and IPv6 nexthops.

Instead, add a new field that indicates the type of the group and
initialize it during the group's creation. Currently, the types are IPv4
('struct fib_info') and IPv6 ('struct fib6_info'). In the future another
type will be added for nexthop objects ('struct nexthop').

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 34 ++++++++++---------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 55ae16b03c44..5b8363206325 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2860,11 +2860,17 @@ struct mlxsw_sp_nexthop {
 	bool counter_valid;
 };
 
+enum mlxsw_sp_nexthop_group_type {
+	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4,
+	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6,
+};
+
 struct mlxsw_sp_nexthop_group {
 	void *priv;
 	struct rhash_head ht_node;
 	struct list_head fib_list; /* list of fib entries that use this group */
 	struct neigh_table *neigh_tbl;
+	enum mlxsw_sp_nexthop_group_type type;
 	u8 adj_index_valid:1,
 	   gateway:1; /* routes using the group use a gateway */
 	u32 adj_index;
@@ -3040,12 +3046,6 @@ mlxsw_sp_nexthop6_group_cmp(const struct mlxsw_sp_nexthop_group *nh_grp,
 	return true;
 }
 
-static int
-mlxsw_sp_nexthop_group_type(const struct mlxsw_sp_nexthop_group *nh_grp)
-{
-	return nh_grp->neigh_tbl->family;
-}
-
 static int
 mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 {
@@ -3054,11 +3054,11 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 
 	switch (cmp_arg->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		if (mlxsw_sp_nexthop_group_type(nh_grp) != AF_INET)
+		if (nh_grp->type != MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4)
 			return 1;
 		return cmp_arg->fi != mlxsw_sp_nexthop4_group_fi(nh_grp);
 	case MLXSW_SP_L3_PROTO_IPV6:
-		if (mlxsw_sp_nexthop_group_type(nh_grp) != AF_INET6)
+		if (nh_grp->type != MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6)
 			return 1;
 		return !mlxsw_sp_nexthop6_group_cmp(nh_grp,
 						    cmp_arg->fib6_entry);
@@ -3076,11 +3076,11 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 	unsigned int val;
 	int i;
 
-	switch (mlxsw_sp_nexthop_group_type(nh_grp)) {
-	case AF_INET:
+	switch (nh_grp->type) {
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
 		fi = mlxsw_sp_nexthop4_group_fi(nh_grp);
 		return jhash(&fi, sizeof(fi), seed);
-	case AF_INET6:
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		val = nh_grp->count;
 		for (i = 0; i < nh_grp->count; i++) {
 			nh = &nh_grp->nexthops[i];
@@ -3138,7 +3138,7 @@ static const struct rhashtable_params mlxsw_sp_nexthop_group_ht_params = {
 static int mlxsw_sp_nexthop_group_insert(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_nexthop_group *nh_grp)
 {
-	if (mlxsw_sp_nexthop_group_type(nh_grp) == AF_INET6 &&
+	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6 &&
 	    !nh_grp->gateway)
 		return 0;
 
@@ -3150,7 +3150,7 @@ static int mlxsw_sp_nexthop_group_insert(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop_group_remove(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_nexthop_group *nh_grp)
 {
-	if (mlxsw_sp_nexthop_group_type(nh_grp) == AF_INET6 &&
+	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6 &&
 	    !nh_grp->gateway)
 		return;
 
@@ -3528,11 +3528,11 @@ static void
 mlxsw_sp_nexthop_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_nexthop_group *nh_grp)
 {
-	switch (mlxsw_sp_nexthop_group_type(nh_grp)) {
-	case AF_INET:
+	switch (nh_grp->type) {
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
 		mlxsw_sp_nexthop4_group_offload_refresh(mlxsw_sp, nh_grp);
 		break;
-	case AF_INET6:
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		mlxsw_sp_nexthop6_group_offload_refresh(mlxsw_sp, nh_grp);
 		break;
 	}
@@ -4106,6 +4106,7 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	nh_grp->priv = fi;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->neigh_tbl = &arp_tbl;
+	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
 
 	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
 	nh_grp->count = nhs;
@@ -5417,6 +5418,7 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 #if IS_ENABLED(CONFIG_IPV6)
 	nh_grp->neigh_tbl = &nd_tbl;
 #endif
+	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
 	mlxsw_sp_rt6 = list_first_entry(&fib6_entry->rt6_list,
 					struct mlxsw_sp_rt6, list);
 	nh_grp->gateway = mlxsw_sp_rt6_is_gateway(mlxsw_sp, mlxsw_sp_rt6->rt);
-- 
2.28.0

