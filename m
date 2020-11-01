Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E85B2A1E5B
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgKANmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:42:55 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43515 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgKANmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:42:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FE105C00A7;
        Sun,  1 Nov 2020 08:42:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 08:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zHziY+95kmW7LNVEBq0KqiP7ABwEjkU6l7zpjbArM0c=; b=bA4XSsY4
        6qObFeDH75SnuvIxKKHH7GRrng6KlVJ97+vo6CDtDWBYH+HOMI3BUNDPdA1/34WN
        efsFn5Cm/HkNlZcCxMUdUROvXjRbvRQTPNDuDwjgmJj6eE+cKG8ojIRHi7L6FS7a
        xLCa3eKnVvSekdS9HkcOfBlCux1dtYbj+X5SspOqwhzlIXb3WkDQVtzixngQNE74
        HAm6VTbkl2UVp58YFdZyO6I3uR0egfpLjCFK6lPJk8z+eVegEHIPfEdY498KyOnL
        bCkDlbtrJ6aQIlFuKUWFt6gZ7Yc/VCjV1KMmtLrtt6RyAmg7bb8yn2V/URYEJj1i
        NlR65gka0O4/tw==
X-ME-Sender: <xms:XbueX13O9_lhmyo3jHVZM_DDxXqvghQk_6XxPGxs6-Me5FCFDFVbFg>
    <xme:XbueX8GHnD0cgGVHQo8iLOg43o3cZuCIvo_z3mye4N-Z4oj3y2zFxGLs2y4kidand
    zIFFDXjZv-MJHM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheehrddukedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XbueX16L6VjVbi8DRvO86GIlvYwJYmpeEKaKF-7rK6moLWo6LJvm9Q>
    <xmx:XbueXy03MvJPgSdBbJ2KLTlTcKxKOQZT3GcO8Kjo0aME4GC20_kSAQ>
    <xmx:XbueX4Gws1xIY8VU-WWHbaEdRsDgp9P-5bZ7NvwilGM8uI3kRtDhIQ>
    <xmx:XbueX9TsOey_eHLKWOZZsKrXj57XH_b8yM7Fyk4AGUrMSBFFi3KzBA>
Received: from shredder.mtl.com (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9663F3064674;
        Sun,  1 Nov 2020 08:42:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_router: Introduce low-level ops and implement them for RALXX regs
Date:   Sun,  1 Nov 2020 15:42:15 +0200
Message-Id: <20201101134215.713708-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201101134215.713708-1-idosch@idosch.org>
References: <20201101134215.713708-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In preparation for support of XM router implementation which uses
different registers to work with trees and FIB entries, introduce
a structure to hold low-level ops and implement tree manipulation
register ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 120 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  11 ++
 2 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4381f8c6c3fb..29fc47821ad7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -409,6 +409,7 @@ struct mlxsw_sp_fib {
 	struct mlxsw_sp_vr *vr;
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	enum mlxsw_sp_l3proto proto;
+	const struct mlxsw_sp_router_ll_ops *ll_ops;
 };
 
 struct mlxsw_sp_vr {
@@ -422,12 +423,31 @@ struct mlxsw_sp_vr {
 	refcount_t ul_rif_refcnt;
 };
 
+static int mlxsw_sp_router_ll_basic_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta),
+			       xralta_pl + MLXSW_REG_XRALTA_RALTA_OFFSET);
+}
+
+static int mlxsw_sp_router_ll_basic_ralst_write(struct mlxsw_sp *mlxsw_sp, char *xralst_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralst),
+			       xralst_pl + MLXSW_REG_XRALST_RALST_OFFSET);
+}
+
+static int mlxsw_sp_router_ll_basic_raltb_write(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb),
+			       xraltb_pl + MLXSW_REG_XRALTB_RALTB_OFFSET);
+}
+
 static const struct rhashtable_params mlxsw_sp_fib_ht_params;
 
 static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 						struct mlxsw_sp_vr *vr,
 						enum mlxsw_sp_l3proto proto)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	struct mlxsw_sp_fib *fib;
 	int err;
@@ -443,6 +463,7 @@ static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 	fib->proto = proto;
 	fib->vr = vr;
 	fib->lpm_tree = lpm_tree;
+	fib->ll_ops = ll_ops;
 	mlxsw_sp_lpm_tree_hold(lpm_tree);
 	err = mlxsw_sp_vr_lpm_tree_bind(mlxsw_sp, fib, lpm_tree->id);
 	if (err)
@@ -481,33 +502,36 @@ mlxsw_sp_lpm_tree_find_unused(struct mlxsw_sp *mlxsw_sp)
 }
 
 static int mlxsw_sp_lpm_tree_alloc(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_router_ll_ops *ll_ops,
 				   struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char ralta_pl[MLXSW_REG_RALTA_LEN];
+	char xralta_pl[MLXSW_REG_XRALTA_LEN];
 
-	mlxsw_reg_ralta_pack(ralta_pl, true,
-			     (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
-			     lpm_tree->id);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta), ralta_pl);
+	mlxsw_reg_xralta_pack(xralta_pl, true,
+			      (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
+			      lpm_tree->id);
+	return ll_ops->ralta_write(mlxsw_sp, xralta_pl);
 }
 
 static void mlxsw_sp_lpm_tree_free(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_router_ll_ops *ll_ops,
 				   struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char ralta_pl[MLXSW_REG_RALTA_LEN];
+	char xralta_pl[MLXSW_REG_XRALTA_LEN];
 
-	mlxsw_reg_ralta_pack(ralta_pl, false,
-			     (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
-			     lpm_tree->id);
-	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta), ralta_pl);
+	mlxsw_reg_xralta_pack(xralta_pl, false,
+			      (enum mlxsw_reg_ralxx_protocol) lpm_tree->proto,
+			      lpm_tree->id);
+	ll_ops->ralta_write(mlxsw_sp, xralta_pl);
 }
 
 static int
 mlxsw_sp_lpm_tree_left_struct_set(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_router_ll_ops *ll_ops,
 				  struct mlxsw_sp_prefix_usage *prefix_usage,
 				  struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	char ralst_pl[MLXSW_REG_RALST_LEN];
+	char xralst_pl[MLXSW_REG_XRALST_LEN];
 	u8 root_bin = 0;
 	u8 prefix;
 	u8 last_prefix = MLXSW_REG_RALST_BIN_NO_CHILD;
@@ -515,19 +539,20 @@ mlxsw_sp_lpm_tree_left_struct_set(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_prefix_usage_for_each(prefix, prefix_usage)
 		root_bin = prefix;
 
-	mlxsw_reg_ralst_pack(ralst_pl, root_bin, lpm_tree->id);
+	mlxsw_reg_xralst_pack(xralst_pl, root_bin, lpm_tree->id);
 	mlxsw_sp_prefix_usage_for_each(prefix, prefix_usage) {
 		if (prefix == 0)
 			continue;
-		mlxsw_reg_ralst_bin_pack(ralst_pl, prefix, last_prefix,
-					 MLXSW_REG_RALST_BIN_NO_CHILD);
+		mlxsw_reg_xralst_bin_pack(xralst_pl, prefix, last_prefix,
+					  MLXSW_REG_RALST_BIN_NO_CHILD);
 		last_prefix = prefix;
 	}
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralst), ralst_pl);
+	return ll_ops->ralst_write(mlxsw_sp, xralst_pl);
 }
 
 static struct mlxsw_sp_lpm_tree *
 mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
+			 const struct mlxsw_sp_router_ll_ops *ll_ops,
 			 struct mlxsw_sp_prefix_usage *prefix_usage,
 			 enum mlxsw_sp_l3proto proto)
 {
@@ -538,12 +563,11 @@ mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
 	if (!lpm_tree)
 		return ERR_PTR(-EBUSY);
 	lpm_tree->proto = proto;
-	err = mlxsw_sp_lpm_tree_alloc(mlxsw_sp, lpm_tree);
+	err = mlxsw_sp_lpm_tree_alloc(mlxsw_sp, ll_ops, lpm_tree);
 	if (err)
 		return ERR_PTR(err);
 
-	err = mlxsw_sp_lpm_tree_left_struct_set(mlxsw_sp, prefix_usage,
-						lpm_tree);
+	err = mlxsw_sp_lpm_tree_left_struct_set(mlxsw_sp, ll_ops, prefix_usage, lpm_tree);
 	if (err)
 		goto err_left_struct_set;
 	memcpy(&lpm_tree->prefix_usage, prefix_usage,
@@ -554,14 +578,15 @@ mlxsw_sp_lpm_tree_create(struct mlxsw_sp *mlxsw_sp,
 	return lpm_tree;
 
 err_left_struct_set:
-	mlxsw_sp_lpm_tree_free(mlxsw_sp, lpm_tree);
+	mlxsw_sp_lpm_tree_free(mlxsw_sp, ll_ops, lpm_tree);
 	return ERR_PTR(err);
 }
 
 static void mlxsw_sp_lpm_tree_destroy(struct mlxsw_sp *mlxsw_sp,
+				      const struct mlxsw_sp_router_ll_ops *ll_ops,
 				      struct mlxsw_sp_lpm_tree *lpm_tree)
 {
-	mlxsw_sp_lpm_tree_free(mlxsw_sp, lpm_tree);
+	mlxsw_sp_lpm_tree_free(mlxsw_sp, ll_ops, lpm_tree);
 }
 
 static struct mlxsw_sp_lpm_tree *
@@ -569,6 +594,7 @@ mlxsw_sp_lpm_tree_get(struct mlxsw_sp *mlxsw_sp,
 		      struct mlxsw_sp_prefix_usage *prefix_usage,
 		      enum mlxsw_sp_l3proto proto)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
 	struct mlxsw_sp_lpm_tree *lpm_tree;
 	int i;
 
@@ -582,7 +608,7 @@ mlxsw_sp_lpm_tree_get(struct mlxsw_sp *mlxsw_sp,
 			return lpm_tree;
 		}
 	}
-	return mlxsw_sp_lpm_tree_create(mlxsw_sp, prefix_usage, proto);
+	return mlxsw_sp_lpm_tree_create(mlxsw_sp, ll_ops, prefix_usage, proto);
 }
 
 static void mlxsw_sp_lpm_tree_hold(struct mlxsw_sp_lpm_tree *lpm_tree)
@@ -593,8 +619,11 @@ static void mlxsw_sp_lpm_tree_hold(struct mlxsw_sp_lpm_tree *lpm_tree)
 static void mlxsw_sp_lpm_tree_put(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_lpm_tree *lpm_tree)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops =
+				mlxsw_sp->router->proto_ll_ops[lpm_tree->proto];
+
 	if (--lpm_tree->ref_count == 0)
-		mlxsw_sp_lpm_tree_destroy(mlxsw_sp, lpm_tree);
+		mlxsw_sp_lpm_tree_destroy(mlxsw_sp, ll_ops, lpm_tree);
 }
 
 #define MLXSW_SP_LPM_TREE_MIN 1 /* tree 0 is reserved */
@@ -684,23 +713,23 @@ static struct mlxsw_sp_vr *mlxsw_sp_vr_find_unused(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_vr_lpm_tree_bind(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_fib *fib, u8 tree_id)
 {
-	char raltb_pl[MLXSW_REG_RALTB_LEN];
+	char xraltb_pl[MLXSW_REG_XRALTB_LEN];
 
-	mlxsw_reg_raltb_pack(raltb_pl, fib->vr->id,
-			     (enum mlxsw_reg_ralxx_protocol) fib->proto,
-			     tree_id);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb), raltb_pl);
+	mlxsw_reg_xraltb_pack(xraltb_pl, fib->vr->id,
+			      (enum mlxsw_reg_ralxx_protocol) fib->proto,
+			      tree_id);
+	return fib->ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 }
 
 static int mlxsw_sp_vr_lpm_tree_unbind(struct mlxsw_sp *mlxsw_sp,
 				       const struct mlxsw_sp_fib *fib)
 {
-	char raltb_pl[MLXSW_REG_RALTB_LEN];
+	char xraltb_pl[MLXSW_REG_XRALTB_LEN];
 
 	/* Bind to tree 0 which is default */
-	mlxsw_reg_raltb_pack(raltb_pl, fib->vr->id,
-			     (enum mlxsw_reg_ralxx_protocol) fib->proto, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb), raltb_pl);
+	mlxsw_reg_xraltb_pack(xraltb_pl, fib->vr->id,
+			      (enum mlxsw_reg_ralxx_protocol) fib->proto, 0);
+	return fib->ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 }
 
 static u32 mlxsw_sp_fix_tb_id(u32 tb_id)
@@ -5659,28 +5688,28 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 					    enum mlxsw_reg_ralxx_protocol proto,
 					    u8 tree_id)
 {
-	char ralta_pl[MLXSW_REG_RALTA_LEN];
-	char ralst_pl[MLXSW_REG_RALST_LEN];
+	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
+	char xralta_pl[MLXSW_REG_XRALTA_LEN];
+	char xralst_pl[MLXSW_REG_XRALST_LEN];
 	int i, err;
 
-	mlxsw_reg_ralta_pack(ralta_pl, true, proto, tree_id);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta), ralta_pl);
+	mlxsw_reg_xralta_pack(xralta_pl, true, proto, tree_id);
+	err = ll_ops->ralta_write(mlxsw_sp, xralta_pl);
 	if (err)
 		return err;
 
-	mlxsw_reg_ralst_pack(ralst_pl, 0xff, tree_id);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralst), ralst_pl);
+	mlxsw_reg_xralst_pack(xralst_pl, 0xff, tree_id);
+	err = ll_ops->ralst_write(mlxsw_sp, xralst_pl);
 	if (err)
 		return err;
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
 		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
-		char raltb_pl[MLXSW_REG_RALTB_LEN];
+		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
 		char ralue_pl[MLXSW_REG_RALUE_LEN];
 
-		mlxsw_reg_raltb_pack(raltb_pl, vr->id, proto, tree_id);
-		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(raltb),
-				      raltb_pl);
+		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, proto, tree_id);
+		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 		if (err)
 			return err;
 
@@ -8057,6 +8086,12 @@ static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rgcr), rgcr_pl);
 }
 
+static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
+	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
+	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
+	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
+};
+
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack)
 {
@@ -8070,6 +8105,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
+	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
+	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
+
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 8418dc3ae967..c5c7346eb815 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -48,6 +48,17 @@ struct mlxsw_sp_router {
 	bool adj_discard_index_valid;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
 	struct mutex lock; /* Protects shared router resources */
+	/* One set of ops for each protocol: IPv4 and IPv6 */
+	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
+};
+
+/* Low-level router ops. Basically this is to handle the different
+ * register sets to work with ordinary and XM trees and FIB entries.
+ */
+struct mlxsw_sp_router_ll_ops {
+	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
+	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
+	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
 };
 
 struct mlxsw_sp_rif_ipip_lb;
-- 
2.26.2

