Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4621B2B1F8E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgKMQGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:52 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37599 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbgKMQGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0F3805C019E;
        Fri, 13 Nov 2020 11:06:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CoFBcGaVd41KMaaqAbk0BKJQVLydiQOPv8q78kzzsIc=; b=crsqBaSM
        ZvN3aMRiTqVd/bd5yy+h4bphoXcqZ/lZG1ETYFk7QXyddrB8H6h1DOh4h34RnLR3
        Xy9mGPpSzg3OsJvx0qQG/R3v3duxS28KJeozPKdI5JUnGwXEv/vQ8HZoih6BIZjY
        dGtVPWq6zbiQYpQkL6grdZ+KxMN0yXSZExs5Qev2jLhfLsF8sTRFu+kkS49hsBJM
        MQ7n7X/Grs9XC3tkI3k3DHNlpXQ0kddzghQ3Dq7s5bfqNtf+qb+udBQ0zRdQgaiW
        ll54OJ9MZUBS6m4Sf+zAaI4AGqViQ53OVNmSVHG/iUIHgBYwg5uzeWVtZDFZUmH5
        fpGTUVJ1fWkK1g==
X-ME-Sender: <xms:GK-uXyBQBcQK78FUd6BE9D-vAfwjH-3oJvzDKyr5ouo1kpJ4TzIMBQ>
    <xme:GK-uX8j5tSEINfMrs6QT9P8hzAzC77SY_0DLfXUsu2n7wnA05800F6my7I6dFwFaU
    vJGC49UCejvfXk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GK-uX1lipYSRPYzrDESftIF1cETmUE_JdGnJf5M8_x0ocXsEU29UqA>
    <xmx:GK-uXwxCti2fSyPJUtJNTPCBq69dS3MWYJzu1983rSoJhdJrkszKrA>
    <xmx:GK-uX3SrRL2W426YvQpKMUmBJePVnGGMI3j91uALyyXIIrZvVh0E6Q>
    <xmx:GK-uXxfb66h7gzd6IKHIXpbJ7e5Is21a725oG4JARpU9AXoXz--eTQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FA133280064;
        Fri, 13 Nov 2020 11:06:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/15] mlxsw: spectrum_router: Split nexthop group configuration to a different struct
Date:   Fri, 13 Nov 2020 18:05:52 +0200
Message-Id: <20201113160559.22148-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the individual nexthops member in the group and attributes of
the group (e.g., its type) are stored in the same struct (i.e., 'struct
mlxsw_sp_nexthop_group'). This is fine since the individual nexthops
cannot change during the lifetime of the group.

With nexthop objects this is no longer the case. An existing nexthop
group can be replaced to use a new set of nexthops. Creating a new
struct whenever a group is replaced entails replacing the group pointer
of all the routes (i.e., 'struct mlxsw_sp_fib_entry') using the group.

Avoid this inefficient step by splitting the nexthop group configuration
to a different struct (i.e., 'struct mlxsw_sp_nexthop_group_info').
When a nexthop group is replaced a new group info struct is created and
the individual rotues do not need to be touched.

Illustration after the change:

  mlxsw_sp_fib_entry    mlxsw_sp_nexthop_group    mlxsw_sp_nexthop_group_info
+-------------------+  +----------------------+  +---------------------------+
| nh_group;         +--> nhgi;                +-->                           |
|                   |  |                      |  |                           |
+-------------------+  +----------------------+  +---------------------------+

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 377 +++++++++++-------
 1 file changed, 228 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6612951b6911..3079be4bc5ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -352,6 +352,7 @@ enum mlxsw_sp_fib_entry_type {
 	MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP,
 };
 
+struct mlxsw_sp_nexthop_group_info;
 struct mlxsw_sp_nexthop_group;
 struct mlxsw_sp_fib_entry;
 
@@ -2831,9 +2832,9 @@ struct mlxsw_sp_nexthop {
 	struct list_head neigh_list_node; /* member of neigh entry list */
 	struct list_head rif_list_node;
 	struct list_head router_list_node;
-	struct mlxsw_sp_nexthop_group *nh_grp; /* pointer back to the group
-						* this belongs to
-						*/
+	struct mlxsw_sp_nexthop_group_info *nhgi; /* pointer back to the group
+						   * this nexthop belongs to
+						   */
 	struct rhash_head ht_node;
 	struct neigh_table *neigh_tbl;
 	struct mlxsw_sp_nexthop_key key;
@@ -2866,23 +2867,28 @@ enum mlxsw_sp_nexthop_group_type {
 	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6,
 };
 
+struct mlxsw_sp_nexthop_group_info {
+	struct mlxsw_sp_nexthop_group *nh_grp;
+	u32 adj_index;
+	u16 ecmp_size;
+	u16 count;
+	int sum_norm_weight;
+	u8 adj_index_valid:1,
+	   gateway:1; /* routes using the group use a gateway */
+	struct mlxsw_sp_nexthop nexthops[0];
+#define nh_rif	nexthops[0].rif
+};
+
 struct mlxsw_sp_nexthop_group {
+	struct rhash_head ht_node;
+	struct list_head fib_list; /* list of fib entries that use this group */
 	union {
 		struct {
 			struct fib_info *fi;
 		} ipv4;
 	};
-	struct rhash_head ht_node;
-	struct list_head fib_list; /* list of fib entries that use this group */
+	struct mlxsw_sp_nexthop_group_info *nhgi;
 	enum mlxsw_sp_nexthop_group_type type;
-	u8 adj_index_valid:1,
-	   gateway:1; /* routes using the group use a gateway */
-	u32 adj_index;
-	u16 ecmp_size;
-	u16 count;
-	int sum_norm_weight;
-	struct mlxsw_sp_nexthop nexthops[0];
-#define nh_rif	nexthops[0].rif
 };
 
 void mlxsw_sp_nexthop_counter_alloc(struct mlxsw_sp *mlxsw_sp,
@@ -2950,18 +2956,18 @@ unsigned char *mlxsw_sp_nexthop_ha(struct mlxsw_sp_nexthop *nh)
 int mlxsw_sp_nexthop_indexes(struct mlxsw_sp_nexthop *nh, u32 *p_adj_index,
 			     u32 *p_adj_size, u32 *p_adj_hash_index)
 {
-	struct mlxsw_sp_nexthop_group *nh_grp = nh->nh_grp;
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh->nhgi;
 	u32 adj_hash_index = 0;
 	int i;
 
-	if (!nh->offloaded || !nh_grp->adj_index_valid)
+	if (!nh->offloaded || !nhgi->adj_index_valid)
 		return -EINVAL;
 
-	*p_adj_index = nh_grp->adj_index;
-	*p_adj_size = nh_grp->ecmp_size;
+	*p_adj_index = nhgi->adj_index;
+	*p_adj_size = nhgi->ecmp_size;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh_iter = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh_iter = &nhgi->nexthops[i];
 
 		if (nh_iter == nh)
 			break;
@@ -2980,11 +2986,11 @@ struct mlxsw_sp_rif *mlxsw_sp_nexthop_rif(struct mlxsw_sp_nexthop *nh)
 
 bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh)
 {
-	struct mlxsw_sp_nexthop_group *nh_grp = nh->nh_grp;
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh->nhgi;
 	int i;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh_iter = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh_iter = &nhgi->nexthops[i];
 
 		if (nh_iter->type == MLXSW_SP_NEXTHOP_TYPE_IPIP)
 			return true;
@@ -3007,10 +3013,10 @@ mlxsw_sp_nexthop6_group_has_nexthop(const struct mlxsw_sp_nexthop_group *nh_grp,
 {
 	int i;
 
-	for (i = 0; i < nh_grp->count; i++) {
+	for (i = 0; i < nh_grp->nhgi->count; i++) {
 		const struct mlxsw_sp_nexthop *nh;
 
-		nh = &nh_grp->nexthops[i];
+		nh = &nh_grp->nhgi->nexthops[i];
 		if (nh->ifindex == ifindex && nh->nh_weight == weight &&
 		    ipv6_addr_equal(gw, (struct in6_addr *) nh->gw_addr))
 			return true;
@@ -3025,7 +3031,7 @@ mlxsw_sp_nexthop6_group_cmp(const struct mlxsw_sp_nexthop_group *nh_grp,
 {
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
 
-	if (nh_grp->count != fib6_entry->nrt6)
+	if (nh_grp->nhgi->count != fib6_entry->nrt6)
 		return false;
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
@@ -3078,9 +3084,9 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 		fi = nh_grp->ipv4.fi;
 		return jhash(&fi, sizeof(fi), seed);
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
-		val = nh_grp->count;
-		for (i = 0; i < nh_grp->count; i++) {
-			nh = &nh_grp->nexthops[i];
+		val = nh_grp->nhgi->count;
+		for (i = 0; i < nh_grp->nhgi->count; i++) {
+			nh = &nh_grp->nhgi->nexthops[i];
 			val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
 			val ^= jhash(&nh->gw_addr, sizeof(nh->gw_addr), seed);
 		}
@@ -3136,7 +3142,7 @@ static int mlxsw_sp_nexthop_group_insert(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_nexthop_group *nh_grp)
 {
 	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6 &&
-	    !nh_grp->gateway)
+	    !nh_grp->nhgi->gateway)
 		return 0;
 
 	return rhashtable_insert_fast(&mlxsw_sp->router->nexthop_group_ht,
@@ -3148,7 +3154,7 @@ static void mlxsw_sp_nexthop_group_remove(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_nexthop_group *nh_grp)
 {
 	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6 &&
-	    !nh_grp->gateway)
+	    !nh_grp->nhgi->gateway)
 		return;
 
 	rhashtable_remove_fast(&mlxsw_sp->router->nexthop_group_ht,
@@ -3234,14 +3240,16 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node) {
+		struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+
 		if (fib == fib_entry->fib_node->fib)
 			continue;
 		fib = fib_entry->fib_node->fib;
 		err = mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib,
 							old_adj_index,
 							old_ecmp_size,
-							nh_grp->adj_index,
-							nh_grp->ecmp_size);
+							nhgi->adj_index,
+							nhgi->ecmp_size);
 		if (err)
 			return err;
 	}
@@ -3312,15 +3320,15 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
-			      struct mlxsw_sp_nexthop_group *nh_grp,
+			      struct mlxsw_sp_nexthop_group_info *nhgi,
 			      bool reallocate)
 {
-	u32 adj_index = nh_grp->adj_index; /* base */
+	u32 adj_index = nhgi->adj_index; /* base */
 	struct mlxsw_sp_nexthop *nh;
 	int i;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		nh = &nhgi->nexthops[i];
 
 		if (!nh->should_offload) {
 			nh->offloaded = 0;
@@ -3420,13 +3428,13 @@ static int mlxsw_sp_fix_adj_grp_size(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp_nexthop_group_normalize(struct mlxsw_sp_nexthop_group *nh_grp)
+mlxsw_sp_nexthop_group_normalize(struct mlxsw_sp_nexthop_group_info *nhgi)
 {
 	int i, g = 0, sum_norm_weight = 0;
 	struct mlxsw_sp_nexthop *nh;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		nh = &nhgi->nexthops[i];
 
 		if (!nh->should_offload)
 			continue;
@@ -3436,8 +3444,8 @@ mlxsw_sp_nexthop_group_normalize(struct mlxsw_sp_nexthop_group *nh_grp)
 			g = nh->nh_weight;
 	}
 
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		nh = &nhgi->nexthops[i];
 
 		if (!nh->should_offload)
 			continue;
@@ -3445,18 +3453,18 @@ mlxsw_sp_nexthop_group_normalize(struct mlxsw_sp_nexthop_group *nh_grp)
 		sum_norm_weight += nh->norm_nh_weight;
 	}
 
-	nh_grp->sum_norm_weight = sum_norm_weight;
+	nhgi->sum_norm_weight = sum_norm_weight;
 }
 
 static void
-mlxsw_sp_nexthop_group_rebalance(struct mlxsw_sp_nexthop_group *nh_grp)
+mlxsw_sp_nexthop_group_rebalance(struct mlxsw_sp_nexthop_group_info *nhgi)
 {
-	int total = nh_grp->sum_norm_weight;
-	u16 ecmp_size = nh_grp->ecmp_size;
 	int i, weight = 0, lower_bound = 0;
+	int total = nhgi->sum_norm_weight;
+	u16 ecmp_size = nhgi->ecmp_size;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
 		int upper_bound;
 
 		if (!nh->should_offload)
@@ -3478,8 +3486,8 @@ mlxsw_sp_nexthop4_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 {
 	int i;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nh_grp->nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh = &nh_grp->nhgi->nexthops[i];
 
 		if (nh->offloaded)
 			nh->key.fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
@@ -3539,6 +3547,7 @@ static void
 mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_nexthop_group *nh_grp)
 {
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
 	u16 ecmp_size, old_ecmp_size;
 	struct mlxsw_sp_nexthop *nh;
 	bool offload_change = false;
@@ -3548,13 +3557,13 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	int i;
 	int err;
 
-	if (!nh_grp->gateway) {
+	if (!nhgi->gateway) {
 		mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
 		return;
 	}
 
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nhgi->count; i++) {
+		nh = &nhgi->nexthops[i];
 
 		if (nh->should_offload != nh->offloaded) {
 			offload_change = true;
@@ -3566,21 +3575,21 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		/* Nothing was added or removed, so no need to reallocate. Just
 		 * update MAC on existing adjacency indexes.
 		 */
-		err = mlxsw_sp_nexthop_group_update(mlxsw_sp, nh_grp, false);
+		err = mlxsw_sp_nexthop_group_update(mlxsw_sp, nhgi, false);
 		if (err) {
 			dev_warn(mlxsw_sp->bus_info->dev, "Failed to update neigh MAC in adjacency table.\n");
 			goto set_trap;
 		}
 		return;
 	}
-	mlxsw_sp_nexthop_group_normalize(nh_grp);
-	if (!nh_grp->sum_norm_weight)
+	mlxsw_sp_nexthop_group_normalize(nhgi);
+	if (!nhgi->sum_norm_weight)
 		/* No neigh of this group is connected so we just set
 		 * the trap and let everthing flow through kernel.
 		 */
 		goto set_trap;
 
-	ecmp_size = nh_grp->sum_norm_weight;
+	ecmp_size = nhgi->sum_norm_weight;
 	err = mlxsw_sp_fix_adj_grp_size(mlxsw_sp, &ecmp_size);
 	if (err)
 		/* No valid allocation size available. */
@@ -3595,14 +3604,14 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to allocate KVD linear area for nexthop group.\n");
 		goto set_trap;
 	}
-	old_adj_index_valid = nh_grp->adj_index_valid;
-	old_adj_index = nh_grp->adj_index;
-	old_ecmp_size = nh_grp->ecmp_size;
-	nh_grp->adj_index_valid = 1;
-	nh_grp->adj_index = adj_index;
-	nh_grp->ecmp_size = ecmp_size;
-	mlxsw_sp_nexthop_group_rebalance(nh_grp);
-	err = mlxsw_sp_nexthop_group_update(mlxsw_sp, nh_grp, true);
+	old_adj_index_valid = nhgi->adj_index_valid;
+	old_adj_index = nhgi->adj_index;
+	old_ecmp_size = nhgi->ecmp_size;
+	nhgi->adj_index_valid = 1;
+	nhgi->adj_index = adj_index;
+	nhgi->ecmp_size = ecmp_size;
+	mlxsw_sp_nexthop_group_rebalance(nhgi);
+	err = mlxsw_sp_nexthop_group_update(mlxsw_sp, nhgi, true);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to update neigh MAC in adjacency table.\n");
 		goto set_trap;
@@ -3634,10 +3643,10 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	return;
 
 set_trap:
-	old_adj_index_valid = nh_grp->adj_index_valid;
-	nh_grp->adj_index_valid = 0;
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
+	old_adj_index_valid = nhgi->adj_index_valid;
+	nhgi->adj_index_valid = 0;
+	for (i = 0; i < nhgi->count; i++) {
+		nh = &nhgi->nexthops[i];
 		nh->offloaded = 0;
 	}
 	err = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
@@ -3646,7 +3655,7 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_offload_refresh(mlxsw_sp, nh_grp);
 	if (old_adj_index_valid)
 		mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
-				   nh_grp->ecmp_size, nh_grp->adj_index);
+				   nhgi->ecmp_size, nhgi->adj_index);
 }
 
 static void __mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp_nexthop *nh,
@@ -3697,7 +3706,7 @@ mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
 		neigh_release(old_n);
 		neigh_clone(n);
 		__mlxsw_sp_nexthop_neigh_update(nh, !entry_connected);
-		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 	}
 
 	neigh_release(n);
@@ -3734,7 +3743,7 @@ mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp *mlxsw_sp,
 	list_for_each_entry(nh, &neigh_entry->nexthop_list,
 			    neigh_list_node) {
 		__mlxsw_sp_nexthop_neigh_update(nh, removing);
-		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 	}
 }
 
@@ -3765,7 +3774,7 @@ static int mlxsw_sp_nexthop_neigh_init(struct mlxsw_sp *mlxsw_sp,
 	u8 nud_state, dead;
 	int err;
 
-	if (!nh->nh_grp->gateway || nh->neigh_entry)
+	if (!nh->nhgi->gateway || nh->neigh_entry)
 		return 0;
 
 	/* Take a reference of neigh here ensuring that neigh would
@@ -3856,7 +3865,7 @@ static void mlxsw_sp_nexthop_ipip_init(struct mlxsw_sp *mlxsw_sp,
 {
 	bool removing;
 
-	if (!nh->nh_grp->gateway || nh->ipip_entry)
+	if (!nh->nhgi->gateway || nh->ipip_entry)
 		return;
 
 	nh->ipip_entry = ipip_entry;
@@ -3956,7 +3965,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	struct in_device *in_dev;
 	int err;
 
-	nh->nh_grp = nh_grp;
+	nh->nhgi = nh_grp->nhgi;
 	nh->key.fib_nh = fib_nh;
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	nh->nh_weight = fib_nh->fib_nh_weight;
@@ -4027,7 +4036,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 		break;
 	}
 
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 }
 
 static void mlxsw_sp_nexthop_rif_update(struct mlxsw_sp *mlxsw_sp,
@@ -4050,7 +4059,7 @@ static void mlxsw_sp_nexthop_rif_update(struct mlxsw_sp *mlxsw_sp,
 		}
 
 		__mlxsw_sp_nexthop_neigh_update(nh, removing);
-		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 	}
 }
 
@@ -4073,7 +4082,7 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 
 	list_for_each_entry_safe(nh, tmp, &rif->nexthop_list, rif_list_node) {
 		mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
-		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 	}
 }
 
@@ -4086,45 +4095,88 @@ static bool mlxsw_sp_fi_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 
+static int
+mlxsw_sp_nexthop4_group_info_init(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	unsigned int nhs = fib_info_num_path(nh_grp->ipv4.fi);
+	struct mlxsw_sp_nexthop_group_info *nhgi;
+	struct mlxsw_sp_nexthop *nh;
+	int err, i;
+
+	nhgi = kzalloc(struct_size(nhgi, nexthops, nhs), GFP_KERNEL);
+	if (!nhgi)
+		return -ENOMEM;
+	nh_grp->nhgi = nhgi;
+	nhgi->nh_grp = nh_grp;
+	nhgi->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, nh_grp->ipv4.fi);
+	nhgi->count = nhs;
+	for (i = 0; i < nhgi->count; i++) {
+		struct fib_nh *fib_nh;
+
+		nh = &nhgi->nexthops[i];
+		fib_nh = fib_info_nh(nh_grp->ipv4.fi, i);
+		err = mlxsw_sp_nexthop4_init(mlxsw_sp, nh_grp, nh, fib_nh);
+		if (err)
+			goto err_nexthop4_init;
+	}
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+
+	return 0;
+
+err_nexthop4_init:
+	for (i--; i >= 0; i--) {
+		nh = &nhgi->nexthops[i];
+		mlxsw_sp_nexthop4_fini(mlxsw_sp, nh);
+	}
+	kfree(nhgi);
+	return err;
+}
+
+static void
+mlxsw_sp_nexthop4_group_info_fini(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+	int i;
+
+	for (i = nhgi->count - 1; i >= 0; i--) {
+		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
+
+		mlxsw_sp_nexthop4_fini(mlxsw_sp, nh);
+	}
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	WARN_ON_ONCE(nhgi->adj_index_valid);
+	kfree(nhgi);
+}
+
 static struct mlxsw_sp_nexthop_group *
 mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 {
-	unsigned int nhs = fib_info_num_path(fi);
 	struct mlxsw_sp_nexthop_group *nh_grp;
-	struct mlxsw_sp_nexthop *nh;
-	struct fib_nh *fib_nh;
-	int i;
 	int err;
 
-	nh_grp = kzalloc(struct_size(nh_grp, nexthops, nhs), GFP_KERNEL);
+	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
-
-	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
-	nh_grp->count = nhs;
 	nh_grp->ipv4.fi = fi;
 	fib_info_hold(fi);
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
-		fib_nh = fib_info_nh(fi, i);
-		err = mlxsw_sp_nexthop4_init(mlxsw_sp, nh_grp, nh, fib_nh);
-		if (err)
-			goto err_nexthop4_init;
-	}
+
+	err = mlxsw_sp_nexthop4_group_info_init(mlxsw_sp, nh_grp);
+	if (err)
+		goto err_nexthop_group_info_init;
+
 	err = mlxsw_sp_nexthop_group_insert(mlxsw_sp, nh_grp);
 	if (err)
 		goto err_nexthop_group_insert;
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+
 	return nh_grp;
 
 err_nexthop_group_insert:
-err_nexthop4_init:
-	for (i--; i >= 0; i--) {
-		nh = &nh_grp->nexthops[i];
-		mlxsw_sp_nexthop4_fini(mlxsw_sp, nh);
-	}
+	mlxsw_sp_nexthop4_group_info_fini(mlxsw_sp, nh_grp);
+err_nexthop_group_info_init:
 	fib_info_put(fi);
 	kfree(nh_grp);
 	return ERR_PTR(err);
@@ -4134,16 +4186,8 @@ static void
 mlxsw_sp_nexthop4_group_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_nexthop_group *nh_grp)
 {
-	struct mlxsw_sp_nexthop *nh;
-	int i;
-
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
-	for (i = 0; i < nh_grp->count; i++) {
-		nh = &nh_grp->nexthops[i];
-		mlxsw_sp_nexthop4_fini(mlxsw_sp, nh);
-	}
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
-	WARN_ON_ONCE(nh_grp->adj_index_valid);
+	mlxsw_sp_nexthop4_group_info_fini(mlxsw_sp, nh_grp);
 	fib_info_put(nh_grp->ipv4.fi);
 	kfree(nh_grp);
 }
@@ -4202,9 +4246,9 @@ mlxsw_sp_fib_entry_should_offload(const struct mlxsw_sp_fib_entry *fib_entry)
 
 	switch (fib_entry->type) {
 	case MLXSW_SP_FIB_ENTRY_TYPE_REMOTE:
-		return !!nh_group->adj_index_valid;
+		return !!nh_group->nhgi->adj_index_valid;
 	case MLXSW_SP_FIB_ENTRY_TYPE_LOCAL:
-		return !!nh_group->nh_rif;
+		return !!nh_group->nhgi->nh_rif;
 	case MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE:
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
 	case MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP:
@@ -4220,8 +4264,8 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
 {
 	int i;
 
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+	for (i = 0; i < nh_grp->nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh = &nh_grp->nhgi->nexthops[i];
 		struct fib6_info *rt = mlxsw_sp_rt6->rt;
 
 		if (nh->rif && nh->rif->dev == rt->fib6_nh->fib_nh_dev &&
@@ -4525,6 +4569,7 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 {
 	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_group->nhgi;
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
@@ -4537,12 +4582,11 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 	 */
 	if (mlxsw_sp_fib_entry_should_offload(fib_entry)) {
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
-		adjacency_index = fib_entry->nh_group->adj_index;
-		ecmp_size = fib_entry->nh_group->ecmp_size;
-	} else if (!nh_group->adj_index_valid && nh_group->count &&
-		   nh_group->nh_rif) {
+		adjacency_index = nhgi->adj_index;
+		ecmp_size = nhgi->ecmp_size;
+	} else if (!nhgi->adj_index_valid && nhgi->count && nhgi->nh_rif) {
 		err = mlxsw_sp_adj_discard_write(mlxsw_sp,
-						 nh_group->nh_rif->rif_index);
+						 nhgi->nh_rif->rif_index);
 		if (err)
 			return err;
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
@@ -4565,7 +4609,7 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 				       enum mlxsw_sp_fib_entry_op op)
 {
 	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
-	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nh_rif;
+	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nhgi->nh_rif;
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	u16 trap_id = 0;
 	u16 rif_index = 0;
@@ -5365,7 +5409,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 {
 	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
 
-	nh->nh_grp = nh_grp;
+	nh->nhgi = nh_grp->nhgi;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
 	memcpy(&nh->gw_addr, &rt->fib6_nh->fib_nh_gw6, sizeof(nh->gw_addr));
 #if IS_ENABLED(CONFIG_IPV6)
@@ -5397,49 +5441,92 @@ static bool mlxsw_sp_rt6_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_nexthop6_ipip_type(mlxsw_sp, rt, NULL);
 }
 
-static struct mlxsw_sp_nexthop_group *
-mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_fib6_entry *fib6_entry)
+static int
+mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_nexthop_group *nh_grp,
+				  struct mlxsw_sp_fib6_entry *fib6_entry)
 {
-	struct mlxsw_sp_nexthop_group *nh_grp;
+	struct mlxsw_sp_nexthop_group_info *nhgi;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
 	struct mlxsw_sp_nexthop *nh;
-	int i = 0;
-	int err;
+	int err, i;
 
-	nh_grp = kzalloc(struct_size(nh_grp, nexthops, fib6_entry->nrt6),
-			 GFP_KERNEL);
-	if (!nh_grp)
-		return ERR_PTR(-ENOMEM);
-	INIT_LIST_HEAD(&nh_grp->fib_list);
-	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
+	nhgi = kzalloc(struct_size(nhgi, nexthops, fib6_entry->nrt6),
+		       GFP_KERNEL);
+	if (!nhgi)
+		return -ENOMEM;
+	nh_grp->nhgi = nhgi;
+	nhgi->nh_grp = nh_grp;
 	mlxsw_sp_rt6 = list_first_entry(&fib6_entry->rt6_list,
 					struct mlxsw_sp_rt6, list);
-	nh_grp->gateway = mlxsw_sp_rt6_is_gateway(mlxsw_sp, mlxsw_sp_rt6->rt);
-	nh_grp->count = fib6_entry->nrt6;
-	for (i = 0; i < nh_grp->count; i++) {
+	nhgi->gateway = mlxsw_sp_rt6_is_gateway(mlxsw_sp, mlxsw_sp_rt6->rt);
+	nhgi->count = fib6_entry->nrt6;
+	for (i = 0; i < nhgi->count; i++) {
 		struct fib6_info *rt = mlxsw_sp_rt6->rt;
 
-		nh = &nh_grp->nexthops[i];
+		nh = &nhgi->nexthops[i];
 		err = mlxsw_sp_nexthop6_init(mlxsw_sp, nh_grp, nh, rt);
 		if (err)
 			goto err_nexthop6_init;
 		mlxsw_sp_rt6 = list_next_entry(mlxsw_sp_rt6, list);
 	}
+	nh_grp->nhgi = nhgi;
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+
+	return 0;
+
+err_nexthop6_init:
+	for (i--; i >= 0; i--) {
+		nh = &nhgi->nexthops[i];
+		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
+	}
+	kfree(nh_grp);
+	return err;
+}
+
+static void
+mlxsw_sp_nexthop6_group_info_fini(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+	int i;
+
+	for (i = nhgi->count - 1; i >= 0; i--) {
+		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
+
+		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
+	}
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	WARN_ON_ONCE(nhgi->adj_index_valid);
+	kfree(nhgi);
+}
+
+static struct mlxsw_sp_nexthop_group *
+mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib6_entry *fib6_entry)
+{
+	struct mlxsw_sp_nexthop_group *nh_grp;
+	int err;
+
+	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
+	if (!nh_grp)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&nh_grp->fib_list);
+	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
+
+	err = mlxsw_sp_nexthop6_group_info_init(mlxsw_sp, nh_grp, fib6_entry);
+	if (err)
+		goto err_nexthop_group_info_init;
 
 	err = mlxsw_sp_nexthop_group_insert(mlxsw_sp, nh_grp);
 	if (err)
 		goto err_nexthop_group_insert;
 
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
 	return nh_grp;
 
 err_nexthop_group_insert:
-err_nexthop6_init:
-	for (i--; i >= 0; i--) {
-		nh = &nh_grp->nexthops[i];
-		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
-	}
+	mlxsw_sp_nexthop6_group_info_fini(mlxsw_sp, nh_grp);
+err_nexthop_group_info_init:
 	kfree(nh_grp);
 	return ERR_PTR(err);
 }
@@ -5448,16 +5535,8 @@ static void
 mlxsw_sp_nexthop6_group_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_nexthop_group *nh_grp)
 {
-	struct mlxsw_sp_nexthop *nh;
-	int i = nh_grp->count;
-
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
-	for (i--; i >= 0; i--) {
-		nh = &nh_grp->nexthops[i];
-		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
-	}
-	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
-	WARN_ON(nh_grp->adj_index_valid);
+	mlxsw_sp_nexthop6_group_info_fini(mlxsw_sp, nh_grp);
 	kfree(nh_grp);
 }
 
-- 
2.28.0

