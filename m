Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A282AD2C6
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgKJJu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:27 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58291 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730145AbgKJJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C830A367;
        Tue, 10 Nov 2020 04:50:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=To6HzVDlycGTL/faa7lW5tlF76i3Nmk7SkUV2TkvVGU=; b=UlRWpVZT
        +c05QD2nsbMz0nDm68851i38+wf0xwKUuUScaEWWHVzRMIReer9OaNQP+nNxEdI9
        k7IjMuhKKuT1ogLaZYzvA5i5fRIh95f6URZ4Ino7HmrilCPq8GDXQmJuZkY6tSrh
        8S7tKNkrt7b1MDdW/3nLp/Vubls2wsrjV1jFEFXDKx7sa/2QYCDuTJRnLXzmgpa5
        xm68vDcXfEdU6YI6cSnFZLoEGIqDz3AU30ikwOP/PxAlRE3MSD3ttg10J1xT3Nqk
        vRiqG5y3yyR2OUYbWTacK2ybZhM8ISsRzLv7sbpYhh6kDyH8uyhZLEuqCNQ6UYeA
        Y2f8NdO9RVym8g==
X-ME-Sender: <xms:XmKqXxiLhZfuIKWRQ57ZzfrMrXdMW-pNREWmTQjYPQhy0a00ErlEqQ>
    <xme:XmKqX2Dl6dB6d8ShiFg7UxVZnD8CImmHf3pjeRXUciM3D7yiuwKMyi_Smoq1ehCeA
    bOYpr-e-TLbwIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XmKqXxFCi8PjUChlWkuIjDh4nnqIaJcKee4u2yRDDPEGdZiWXAgqDg>
    <xmx:XmKqX2TTNUpxTzy42av1mtpdO4R4JCO2AUEusuCwcgmxtRAkBl0z-Q>
    <xmx:XmKqX-ydSsnQqDEvY_xqNZW0-sJMYBc9R1oAiWxij2FXLhHDa7eeOw>
    <xmx:XmKqX5_8mm6PnvpK9tFkd-rsuDjsTyuq0NCqPrhTaTM1Qr6HdKu2gg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A3253280060;
        Tue, 10 Nov 2020 04:50:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/15] mlxsw: spectrum: Propagate context from work handler containing RALUE payload
Date:   Tue, 10 Nov 2020 11:48:49 +0200
Message-Id: <20201110094900.1920158-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, RALUE payload is defined locally in the function that is
calling the register write. With introduction of alternative register to
RALUE, XMDR, it has to be possible to put multiple FIB entry
operations into single register write.

So in order to prepare for that, have per-work entry operation context
and propagate it all the way down to the functions writing RALUE.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  11 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 140 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  14 +-
 4 files changed, 103 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 8487de3e9787..f8b9b5be8247 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -182,11 +182,12 @@ mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				      u32 dip, u8 prefix_len, u16 ul_vr_id,
 				      enum mlxsw_sp_fib_entry_op op,
 				      u32 tunnel_index)
 {
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 	enum mlxsw_reg_ralue_op ralue_op;
 
 	switch (op) {
@@ -208,9 +209,9 @@ mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_ipip_entry *ipip_entry,
-					enum mlxsw_sp_fib_entry_op op,
-					u32 tunnel_index)
+					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					   struct mlxsw_sp_ipip_entry *ipip_entry,
+					   enum mlxsw_sp_fib_entry_op op, u32 tunnel_index)
 {
 	u16 ul_vr_id = mlxsw_sp_ipip_lb_ul_vr_id(ipip_entry->ol_lb);
 	__be32 dip;
@@ -223,7 +224,7 @@ static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
 
 	dip = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV4,
 					 ipip_entry->ol_dev).addr4;
-	return mlxsw_sp_ipip_fib_entry_op_gre4_ralue(mlxsw_sp, be32_to_cpu(dip),
+	return mlxsw_sp_ipip_fib_entry_op_gre4_ralue(mlxsw_sp, op_ctx, be32_to_cpu(dip),
 						     32, ul_vr_id, op,
 						     tunnel_index);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index f3ad1e149a45..dd53b1c207b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -52,6 +52,7 @@ struct mlxsw_sp_ipip_ops {
 			      const struct net_device *ol_dev);
 
 	int (*fib_entry_op)(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			    struct mlxsw_sp_ipip_entry *ipip_entry,
 			    enum mlxsw_sp_fib_entry_op op,
 			    u32 tunnel_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 99777d190e6d..9083c74c1904 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4380,12 +4380,13 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 }
 
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					struct mlxsw_sp_fib_entry *fib_entry,
 					enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	enum mlxsw_reg_ralue_trap_action trap_action;
+	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
 	u16 ecmp_size = 0;
@@ -4420,12 +4421,13 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				       struct mlxsw_sp_fib_entry *fib_entry,
 				       enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nh_rif;
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id = 0;
 	u16 rif_index = 0;
 
@@ -4444,10 +4446,11 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				      struct mlxsw_sp_fib_entry *fib_entry,
 				      enum mlxsw_sp_fib_entry_op op)
 {
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 
 	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
 	mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
@@ -4455,11 +4458,12 @@ static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_fib_entry *fib_entry,
 					   enum mlxsw_sp_fib_entry_op op)
 {
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_DISCARD_ERROR;
 	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
@@ -4469,11 +4473,12 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				  struct mlxsw_sp_fib_entry *fib_entry,
 				  enum mlxsw_sp_fib_entry_op op)
 {
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
@@ -4486,6 +4491,7 @@ mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				 struct mlxsw_sp_fib_entry *fib_entry,
 				 enum mlxsw_sp_fib_entry_op op)
 {
@@ -4496,15 +4502,16 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-	return ipip_ops->fib_entry_op(mlxsw_sp, ipip_entry, op,
+	return ipip_ops->fib_entry_op(mlxsw_sp, op_ctx, ipip_entry, op,
 				      fib_entry->decap.tunnel_index);
 }
 
 static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_fib_entry *fib_entry,
 					   enum mlxsw_sp_fib_entry_op op)
 {
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	char *ralue_pl = op_ctx->ralue_pl;
 
 	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
 	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl,
@@ -4513,35 +4520,35 @@ static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				   struct mlxsw_sp_fib_entry *fib_entry,
 				   enum mlxsw_sp_fib_entry_op op)
 {
 	switch (fib_entry->type) {
 	case MLXSW_SP_FIB_ENTRY_TYPE_REMOTE:
-		return mlxsw_sp_fib_entry_op_remote(mlxsw_sp, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_remote(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_LOCAL:
-		return mlxsw_sp_fib_entry_op_local(mlxsw_sp, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_local(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_TRAP:
-		return mlxsw_sp_fib_entry_op_trap(mlxsw_sp, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_trap(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE:
-		return mlxsw_sp_fib_entry_op_blackhole(mlxsw_sp, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_blackhole(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE:
-		return mlxsw_sp_fib_entry_op_unreachable(mlxsw_sp, fib_entry,
-							 op);
+		return mlxsw_sp_fib_entry_op_unreachable(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
-		return mlxsw_sp_fib_entry_op_ipip_decap(mlxsw_sp,
-							fib_entry, op);
+		return mlxsw_sp_fib_entry_op_ipip_decap(mlxsw_sp, op_ctx, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP:
-		return mlxsw_sp_fib_entry_op_nve_decap(mlxsw_sp, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_nve_decap(mlxsw_sp, op_ctx, fib_entry, op);
 	}
 	return -EINVAL;
 }
 
 static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				 struct mlxsw_sp_fib_entry *fib_entry,
 				 enum mlxsw_sp_fib_entry_op op)
 {
-	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry, op);
+	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry, op);
 
 	if (err)
 		return err;
@@ -4551,17 +4558,27 @@ static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static int __mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				       struct mlxsw_sp_fib_entry *fib_entry)
+{
+	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
+				     MLXSW_SP_FIB_ENTRY_OP_WRITE);
+}
+
 static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_entry *fib_entry)
 {
-	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
-				     MLXSW_SP_FIB_ENTRY_OP_WRITE);
+	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
+
+	return __mlxsw_sp_fib_entry_update(mlxsw_sp, &op_ctx, fib_entry);
 }
 
 static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				  struct mlxsw_sp_fib_entry *fib_entry)
 {
-	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
+	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
 				     MLXSW_SP_FIB_ENTRY_OP_DELETE);
 }
 
@@ -4917,6 +4934,7 @@ static void mlxsw_sp_fib_node_put(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
@@ -4924,7 +4942,7 @@ static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 
 	fib_node->fib_entry = fib_entry;
 
-	err = mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
+	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry);
 	if (err)
 		goto err_fib_entry_update;
 
@@ -4935,16 +4953,24 @@ static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static void
-mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_fib_entry *fib_entry)
+static void __mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
+					     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					     struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
 
-	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
+	mlxsw_sp_fib_entry_del(mlxsw_sp, op_ctx, fib_entry);
 	fib_node->fib_entry = NULL;
 }
 
+static void mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_fib_entry *fib_entry)
+{
+	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
+
+	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &op_ctx, fib_entry);
+}
+
 static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
@@ -4964,6 +4990,7 @@ static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
 
 static int
 mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			     const struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry, *fib4_replaced;
@@ -4997,7 +5024,7 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	replaced = fib_node->fib_entry;
-	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib4_entry->common);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, op_ctx, &fib4_entry->common);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to link FIB entry to node\n");
 		goto err_fib_node_entry_link;
@@ -5023,6 +5050,7 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				     struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry;
@@ -5036,7 +5064,7 @@ static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
 		return;
 	fib_node = fib4_entry->common.fib_node;
 
-	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib4_entry->common);
+	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -5305,9 +5333,9 @@ static void mlxsw_sp_nexthop6_group_put(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop6_group_destroy(mlxsw_sp, nh_grp);
 }
 
-static int
-mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_fib6_entry *fib6_entry)
+static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					  struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	struct mlxsw_sp_nexthop_group *old_nh_grp = fib6_entry->common.nh_group;
 	int err;
@@ -5323,7 +5351,7 @@ mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	 * currently associated with it in the device's table is that
 	 * of the old group. Start using the new one instead.
 	 */
-	err = mlxsw_sp_fib_entry_update(mlxsw_sp, &fib6_entry->common);
+	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, &fib6_entry->common);
 	if (err)
 		goto err_fib_entry_update;
 
@@ -5343,6 +5371,7 @@ mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
 				struct fib6_info **rt_arr, unsigned int nrt6)
 {
@@ -5360,7 +5389,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 		fib6_entry->nrt6++;
 	}
 
-	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
+	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 	if (err)
 		goto err_nexthop6_group_update;
 
@@ -5381,6 +5410,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
 				struct fib6_info **rt_arr, unsigned int nrt6)
 {
@@ -5398,7 +5428,7 @@ mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 	}
 
-	mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
+	mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 }
 
 static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
@@ -5550,8 +5580,8 @@ static bool mlxsw_sp_fib6_allow_replace(struct mlxsw_sp_fib6_entry *fib6_entry)
 }
 
 static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
-					struct fib6_info **rt_arr,
-					unsigned int nrt6)
+					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry, *fib6_replaced;
 	struct mlxsw_sp_fib_entry *replaced;
@@ -5590,7 +5620,7 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	replaced = fib_node->fib_entry;
-	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib6_entry->common);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, op_ctx, &fib6_entry->common);
 	if (err)
 		goto err_fib_node_entry_link;
 
@@ -5614,8 +5644,8 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
-				       struct fib6_info **rt_arr,
-				       unsigned int nrt6)
+				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				       struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
@@ -5646,8 +5676,7 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 
 	fib6_entry = container_of(fib_node->fib_entry,
 				  struct mlxsw_sp_fib6_entry, common);
-	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt_arr,
-					      nrt6);
+	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, op_ctx, fib6_entry, rt_arr, nrt6);
 	if (err)
 		goto err_fib6_entry_nexthop_add;
 
@@ -5659,8 +5688,8 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
-				     struct fib6_info **rt_arr,
-				     unsigned int nrt6)
+				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				     struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
@@ -5685,14 +5714,13 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	 * group.
 	 */
 	if (nrt6 != fib6_entry->nrt6) {
-		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt_arr,
-						nrt6);
+		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, op_ctx, fib6_entry, rt_arr, nrt6);
 		return;
 	}
 
 	fib_node = fib6_entry->common.fib_node;
 
-	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib6_entry->common);
+	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -5720,8 +5748,9 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
 		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
+		struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
 		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
-		char ralue_pl[MLXSW_REG_RALUE_LEN];
+		char *ralue_pl = op_ctx.ralue_pl;
 
 		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, ralxx_proto, tree_id);
 		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
@@ -6014,6 +6043,7 @@ mlxsw_sp_router_fib6_event_fini(struct mlxsw_sp_fib6_event *fib6_event)
 }
 
 static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					       struct mlxsw_sp_fib_event *fib_event)
 {
 	int err;
@@ -6023,13 +6053,13 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 
 	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, &fib_event->fen_info);
+		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, op_ctx, &fib_event->fen_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_event->fen_info);
+		mlxsw_sp_router_fib4_del(mlxsw_sp, op_ctx, &fib_event->fen_info);
 		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
@@ -6042,6 +6072,7 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					       struct mlxsw_sp_fib_event *fib_event)
 {
 	int err;
@@ -6051,21 +6082,21 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 
 	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib6_replace(mlxsw_sp, fib_event->fib6_event.rt_arr,
+		err = mlxsw_sp_router_fib6_replace(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
 						   fib_event->fib6_event.nrt6);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
-		err = mlxsw_sp_router_fib6_append(mlxsw_sp, fib_event->fib6_event.rt_arr,
+		err = mlxsw_sp_router_fib6_append(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
 						  fib_event->fib6_event.nrt6);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib6_del(mlxsw_sp, fib_event->fib6_event.rt_arr,
+		mlxsw_sp_router_fib6_del(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
 					 fib_event->fib6_event.nrt6);
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
@@ -6114,6 +6145,7 @@ static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 {
 	struct mlxsw_sp_router *router = container_of(work, struct mlxsw_sp_router, fib_event_work);
+	struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
 	struct mlxsw_sp *mlxsw_sp = router->mlxsw_sp;
 	struct mlxsw_sp_fib_event *fib_event, *tmp;
 	LIST_HEAD(fib_event_queue);
@@ -6125,10 +6157,12 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 	list_for_each_entry_safe(fib_event, tmp, &fib_event_queue, list) {
 		switch (fib_event->family) {
 		case AF_INET:
-			mlxsw_sp_router_fib4_event_process(mlxsw_sp, fib_event);
+			mlxsw_sp_router_fib4_event_process(mlxsw_sp, &op_ctx,
+							   fib_event);
 			break;
 		case AF_INET6:
-			mlxsw_sp_router_fib6_event_process(mlxsw_sp, fib_event);
+			mlxsw_sp_router_fib6_event_process(mlxsw_sp, &op_ctx,
+							   fib_event);
 			break;
 		case RTNL_FAMILY_IP6MR:
 		case RTNL_FAMILY_IPMR:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 5683f20a325e..963825dff66b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -55,6 +55,15 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 };
 
+enum mlxsw_sp_fib_entry_op {
+	MLXSW_SP_FIB_ENTRY_OP_WRITE,
+	MLXSW_SP_FIB_ENTRY_OP_DELETE,
+};
+
+struct mlxsw_sp_fib_entry_op_ctx {
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
+};
+
 /* Low-level router ops. Basically this is to handle the different
  * register sets to work with ordinary and XM trees and FIB entries.
  */
@@ -64,11 +73,6 @@ struct mlxsw_sp_router_ll_ops {
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
 };
 
-enum mlxsw_sp_fib_entry_op {
-	MLXSW_SP_FIB_ENTRY_OP_WRITE,
-	MLXSW_SP_FIB_ENTRY_OP_DELETE,
-};
-
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.26.2

