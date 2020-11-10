Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89AF2AD2C4
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKJJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:23 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54411 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729386AbgKJJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DBC5FE07;
        Tue, 10 Nov 2020 04:50:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zJhzB4rNfsB0adzTnkG0Wc6kG1QQSzFhLJBXXNhOibE=; b=MecKpCHO
        UuBfROxMDBuX8zNKS+Ks1IQ/jl4/Q/bYa92ez5wcqu1yEMA9j9ZcKkYqwf+2VabH
        v8qMKk/sFzi1MtF9Mcoxa5KXfttwt2EcwWasrtT370Eo1OGqNEz7zE4ZUe3lz5cA
        8RxWkiQ3tXPf6xHuy/AD1Nph0bB+bfyej0NDndpZJO9gvayt3LNGbsp1w0t/LK85
        fdhuSzj3UOVdB6bPsVenHoD0lm9XR7EfW5S0Mt8K/hR0qkRkL2nGJCF6HTNj8DNU
        Yb82lu/RufVg+iBLyfzq6SxGJ5wup/P/pjy47DRSPWPp92wWNAVskyHqyMZRkozw
        XMDf5QQ3ajNOXg==
X-ME-Sender: <xms:W2KqX_o8OkmVkxOdzLBWe-L7TZkRub1dGrRUQq2X1tplHWx_6Oa_wQ>
    <xme:W2KqX5quAsvKxDyn-ORfI638vIfQFjF476q9TiUTGPgOn6Eq8PFDGfzv4_Oljdjw8
    Qv06RtdAyrsBGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:W2KqX8MLW1Il1n7OdCkRhSCy-TyJRAYxCjxoGUrxqoWpu_ZsevG_Aw>
    <xmx:W2KqXy6g_BPBVdLQQbjgx3hdqY3gk7Z_tbHDLERdmfIG6_WKOCykqg>
    <xmx:W2KqX-5LJUW2KYhTdjOtbMdVZd6Nqnd173-TE2kSL-bEinFhhASZhw>
    <xmx:W2KqX-GoKJxifHs6rqmHsoRPZFZSMgAimCPi_oFv-CvkASMPkdAvkw>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41EDC3280060;
        Tue, 10 Nov 2020 04:50:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/15] mlxsw: spectrum_router: Use RALUE-independent op arg
Date:   Tue, 10 Nov 2020 11:48:47 +0200
Message-Id: <20201110094900.1920158-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Since the write/delete of FIB entry is going to be implemented by XMDR
register for XM implementation, introduce RALUE-independent enum for op
so the enum could be used in both RALUE and XMDR.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 19 ++++++--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 47 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  5 ++
 4 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index a8525992528f..8487de3e9787 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -183,12 +183,25 @@ mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
 				      u32 dip, u8 prefix_len, u16 ul_vr_id,
-				      enum mlxsw_reg_ralue_op op,
+				      enum mlxsw_sp_fib_entry_op op,
 				      u32 tunnel_index)
 {
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	enum mlxsw_reg_ralue_op ralue_op;
+
+	switch (op) {
+	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
+		ralue_op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
+		break;
+	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
+		ralue_op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 
-	mlxsw_reg_ralue_pack4(ralue_pl, MLXSW_REG_RALXX_PROTOCOL_IPV4, op,
+	mlxsw_reg_ralue_pack4(ralue_pl, MLXSW_REG_RALXX_PROTOCOL_IPV4, ralue_op,
 			      ul_vr_id, prefix_len, dip);
 	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl, tunnel_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
@@ -196,7 +209,7 @@ mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_ipip_entry *ipip_entry,
-					enum mlxsw_reg_ralue_op op,
+					enum mlxsw_sp_fib_entry_op op,
 					u32 tunnel_index)
 {
 	u16 ul_vr_id = mlxsw_sp_ipip_lb_ul_vr_id(ipip_entry->ol_lb);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index bb5c4d4a5872..f3ad1e149a45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -53,7 +53,7 @@ struct mlxsw_sp_ipip_ops {
 
 	int (*fib_entry_op)(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_ipip_entry *ipip_entry,
-			    enum mlxsw_reg_ralue_op op,
+			    enum mlxsw_sp_fib_entry_op op,
 			    u32 tunnel_index);
 
 	int (*ol_netdev_change)(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a1424962472d..d916f1045d97 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4293,13 +4293,13 @@ mlxsw_sp_fib_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 static void
 mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_fib_entry *fib_entry,
-				    enum mlxsw_reg_ralue_op op)
+				    enum mlxsw_sp_fib_entry_op op)
 {
 	switch (op) {
-	case MLXSW_REG_RALUE_OP_WRITE_WRITE:
+	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
 		mlxsw_sp_fib_entry_hw_flags_set(mlxsw_sp, fib_entry);
 		break;
-	case MLXSW_REG_RALUE_OP_WRITE_DELETE:
+	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
 		mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, fib_entry);
 		break;
 	default:
@@ -4310,23 +4310,36 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 static void
 mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
 			      const struct mlxsw_sp_fib_entry *fib_entry,
-			      enum mlxsw_reg_ralue_op op)
+			      enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
 	enum mlxsw_reg_ralxx_protocol proto;
+	enum mlxsw_reg_ralue_op ralue_op;
 	u32 *p_dip;
 
 	proto = (enum mlxsw_reg_ralxx_protocol) fib->proto;
 
+	switch (op) {
+	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
+		ralue_op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
+		break;
+	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
+		ralue_op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	switch (fib->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		p_dip = (u32 *) fib_entry->fib_node->key.addr;
-		mlxsw_reg_ralue_pack4(ralue_pl, proto, op, fib->vr->id,
+		mlxsw_reg_ralue_pack4(ralue_pl, proto, ralue_op, fib->vr->id,
 				      fib_entry->fib_node->key.prefix_len,
 				      *p_dip);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_reg_ralue_pack6(ralue_pl, proto, op, fib->vr->id,
+		mlxsw_reg_ralue_pack6(ralue_pl, proto, ralue_op, fib->vr->id,
 				      fib_entry->fib_node->key.prefix_len,
 				      fib_entry->fib_node->key.addr);
 		break;
@@ -4368,7 +4381,7 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry *fib_entry,
-					enum mlxsw_reg_ralue_op op)
+					enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
@@ -4408,7 +4421,7 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib_entry *fib_entry,
-				       enum mlxsw_reg_ralue_op op)
+				       enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nh_rif;
 	enum mlxsw_reg_ralue_trap_action trap_action;
@@ -4432,7 +4445,7 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_fib_entry *fib_entry,
-				      enum mlxsw_reg_ralue_op op)
+				      enum mlxsw_sp_fib_entry_op op)
 {
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
 
@@ -4443,7 +4456,7 @@ static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_fib_entry *fib_entry,
-					   enum mlxsw_reg_ralue_op op)
+					   enum mlxsw_sp_fib_entry_op op)
 {
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
@@ -4457,7 +4470,7 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_fib_entry *fib_entry,
-				  enum mlxsw_reg_ralue_op op)
+				  enum mlxsw_sp_fib_entry_op op)
 {
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
@@ -4474,7 +4487,7 @@ mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry,
-				 enum mlxsw_reg_ralue_op op)
+				 enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_ipip_entry *ipip_entry = fib_entry->decap.ipip_entry;
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
@@ -4489,7 +4502,7 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_fib_entry *fib_entry,
-					   enum mlxsw_reg_ralue_op op)
+					   enum mlxsw_sp_fib_entry_op op)
 {
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
 
@@ -4501,7 +4514,7 @@ static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 
 static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_fib_entry *fib_entry,
-				   enum mlxsw_reg_ralue_op op)
+				   enum mlxsw_sp_fib_entry_op op)
 {
 	switch (fib_entry->type) {
 	case MLXSW_SP_FIB_ENTRY_TYPE_REMOTE:
@@ -4526,7 +4539,7 @@ static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry,
-				 enum mlxsw_reg_ralue_op op)
+				 enum mlxsw_sp_fib_entry_op op)
 {
 	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry, op);
 
@@ -4542,14 +4555,14 @@ static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_entry *fib_entry)
 {
 	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
-				     MLXSW_REG_RALUE_OP_WRITE_WRITE);
+				     MLXSW_SP_FIB_ENTRY_OP_WRITE);
 }
 
 static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_fib_entry *fib_entry)
 {
 	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
-				     MLXSW_REG_RALUE_OP_WRITE_DELETE);
+				     MLXSW_SP_FIB_ENTRY_OP_DELETE);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index c5c7346eb815..68f5feabc02c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -61,6 +61,11 @@ struct mlxsw_sp_router_ll_ops {
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
 };
 
+enum mlxsw_sp_fib_entry_op {
+	MLXSW_SP_FIB_ENTRY_OP_WRITE,
+	MLXSW_SP_FIB_ENTRY_OP_DELETE,
+};
+
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.26.2

