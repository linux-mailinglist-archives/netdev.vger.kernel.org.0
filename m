Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F32E39F705
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhFHMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37313 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhFHMqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 077E15C0138;
        Tue,  8 Jun 2021 08:44:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 08:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KswEXG3MmUi43af35zMoNvoTkbA7Ctmi4aSCfEQ5fxE=; b=BHs/7Lap
        0QHvSWKP2a/veuZ+EVGkcRagiwUGA7TDCEkwp4hMK6vCY3kNpy2QPbJxBcynl7jI
        5w65C1bj1Q5xfN/YkCpt+rHgi5KM07NL+E9qPbJhN2/QoMGEvX3ZaQ+X7/0B0HqO
        ykGqwn5weElL0dueekRu8O7W8DNl8j+BNUhYTndWuVXnC2KokEzIFiCCPomqda+b
        vcyLEnTUxXAlcoCG5qY1Vv/Dh/zUyEc2zm9KPR9qNKNPER9L1hmyH+cRP3jkCBW5
        bQgGCO5aIzdk3RadLWkpQ6G+FH/a5H7cpHXmoBkdIdv8wqIGauLNqplc1YxK3fRB
        fOyLM7yh6cB0ZA==
X-ME-Sender: <xms:OWa_YBMfju6OtOomPzUv576rlB_m9O-qpvGiX2Lae3wpa8daLfFH_g>
    <xme:OWa_YD9p6KlHAYk85eO81zH2OWxGpAzJBQTTtcPreA1LZYO99pXqJmmXYdYVotB23
    v7M5Sug44ZCdEE>
X-ME-Received: <xmr:OWa_YATC98XRIWL8vxINwU2f1VThiVUQsXEwXZ7sFA5FdH8N4ke8FszB14DTTprSMo94QZ4MQSZz6XmtTpqwCTTIAqxqf2ebf3V9LnYmjM9WXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OWa_YNufYHsjDwDrsL6NpNOypTk37QK2qWmphiwuV-0s8ZlTikb9qA>
    <xmx:OWa_YJeW6tuCoSxCh0UAh06gubHUDxU8GOfO02m1bFwXlghXNa4iKA>
    <xmx:OWa_YJ1kSKzKiDte4-ukjES4cyNa9fCnxm9CbowzyDA0-Gy7BEIw4g>
    <xmx:Oma_YDvByjcS_RuncGsXhSNaUUCVOyYTyU6_JLy4STuNmgatVRupww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_router: Remove abort mechanism
Date:   Tue,  8 Jun 2021 15:44:07 +0300
Message-Id: <20210608124414.1664294-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The abort mechanism was introduced in commit 8e05fd7166c6 ("fib: hook
IPv4 fib for hardware offload") with the purpose of falling back to
software-based routing in case of a route programming error in hardware.
The process is irreversible and requires users to reload the offloading
driver or reboot the machine.

While this approach might make sense in theory, it makes very little
sense in practice. In the case of high speed ASICs such as the Spectrum
ASIC, the abort mechanism effectively kills the machine upon a non-fatal
error such as a route programming error.

Such an extreme policy does not belong in the kernel, especially when
user space can simply try to reprogram the route following the
RTM_NEWROUTE failure notification.

Therefore, remove the abort mechanism.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 129 +-----------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 -
 2 files changed, 5 insertions(+), 125 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6decc5a43f98..bc47ed766878 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4312,9 +4312,6 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_nexthop_key key;
 	struct mlxsw_sp_nexthop *nh;
 
-	if (mlxsw_sp->router->aborted)
-		return;
-
 	key.fib_nh = fib_nh;
 	nh = mlxsw_sp_nexthop_lookup(mlxsw_sp, key);
 	if (!nh)
@@ -6422,9 +6419,6 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib_node *fib_node;
 	int err;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	if (fen_info->fi->nh &&
 	    !mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, fen_info->fi->nh->id))
 		return 0;
@@ -6485,9 +6479,6 @@ static int mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib_node *fib_node;
 	int err;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	fib4_entry = mlxsw_sp_fib4_entry_lookup(mlxsw_sp, fen_info);
 	if (!fib4_entry)
 		return 0;
@@ -7070,9 +7061,6 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	struct fib6_info *rt = rt_arr[0];
 	int err;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	if (rt->fib6_src.plen)
 		return -EINVAL;
 
@@ -7136,9 +7124,6 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 	struct fib6_info *rt = rt_arr[0];
 	int err;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	if (rt->fib6_src.plen)
 		return -EINVAL;
 
@@ -7180,9 +7165,6 @@ static int mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	struct fib6_info *rt = rt_arr[0];
 	int err;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
 		return 0;
 
@@ -7211,55 +7193,6 @@ static int mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
-					    enum mlxsw_sp_l3proto proto,
-					    u8 tree_id)
-{
-	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
-	enum mlxsw_reg_ralxx_protocol ralxx_proto =
-				(enum mlxsw_reg_ralxx_protocol) proto;
-	struct mlxsw_sp_fib_entry_priv *priv;
-	char xralta_pl[MLXSW_REG_XRALTA_LEN];
-	char xralst_pl[MLXSW_REG_XRALST_LEN];
-	int i, err;
-
-	mlxsw_reg_xralta_pack(xralta_pl, true, ralxx_proto, tree_id);
-	err = ll_ops->ralta_write(mlxsw_sp, xralta_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_xralst_pack(xralst_pl, 0xff, tree_id);
-	err = ll_ops->ralst_write(mlxsw_sp, xralst_pl);
-	if (err)
-		return err;
-
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
-		struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
-		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
-		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
-
-		mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
-		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, ralxx_proto, tree_id);
-		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
-		if (err)
-			return err;
-
-		priv = mlxsw_sp_fib_entry_priv_create(ll_ops);
-		if (IS_ERR(priv))
-			return PTR_ERR(priv);
-
-		ll_ops->fib_entry_pack(op_ctx, proto, MLXSW_SP_FIB_ENTRY_OP_WRITE,
-				       vr->id, 0, NULL, priv);
-		ll_ops->fib_entry_act_ip2me_pack(op_ctx);
-		err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx, NULL);
-		mlxsw_sp_fib_entry_priv_put(priv);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static struct mlxsw_sp_mr_table *
 mlxsw_sp_router_fibmr_family_to_table(struct mlxsw_sp_vr *vr, int family)
 {
@@ -7276,9 +7209,6 @@ static int mlxsw_sp_router_fibmr_add(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_mr_table *mrt;
 	struct mlxsw_sp_vr *vr;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	vr = mlxsw_sp_vr_get(mlxsw_sp, men_info->tb_id, NULL);
 	if (IS_ERR(vr))
 		return PTR_ERR(vr);
@@ -7293,9 +7223,6 @@ static void mlxsw_sp_router_fibmr_del(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_mr_table *mrt;
 	struct mlxsw_sp_vr *vr;
 
-	if (mlxsw_sp->router->aborted)
-		return;
-
 	vr = mlxsw_sp_vr_find(mlxsw_sp, men_info->tb_id);
 	if (WARN_ON(!vr))
 		return;
@@ -7313,9 +7240,6 @@ mlxsw_sp_router_fibmr_vif_add(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_rif *rif;
 	struct mlxsw_sp_vr *vr;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	vr = mlxsw_sp_vr_get(mlxsw_sp, ven_info->tb_id, NULL);
 	if (IS_ERR(vr))
 		return PTR_ERR(vr);
@@ -7334,9 +7258,6 @@ mlxsw_sp_router_fibmr_vif_del(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_mr_table *mrt;
 	struct mlxsw_sp_vr *vr;
 
-	if (mlxsw_sp->router->aborted)
-		return;
-
 	vr = mlxsw_sp_vr_find(mlxsw_sp, ven_info->tb_id);
 	if (WARN_ON(!vr))
 		return;
@@ -7346,25 +7267,6 @@ mlxsw_sp_router_fibmr_vif_del(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
 }
 
-static int mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp)
-{
-	enum mlxsw_sp_l3proto proto = MLXSW_SP_L3_PROTO_IPV4;
-	int err;
-
-	err = __mlxsw_sp_router_set_abort_trap(mlxsw_sp, proto,
-					       MLXSW_SP_LPM_TREE_MIN);
-	if (err)
-		return err;
-
-	/* The multicast router code does not need an abort trap as by default,
-	 * packets that don't match any routes are trapped to the CPU.
-	 */
-
-	proto = MLXSW_SP_L3_PROTO_IPV6;
-	return __mlxsw_sp_router_set_abort_trap(mlxsw_sp, proto,
-						MLXSW_SP_LPM_TREE_MIN + 1);
-}
-
 static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_node *fib_node)
 {
@@ -7451,20 +7353,6 @@ static void mlxsw_sp_router_fib_flush(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp->router->adj_discard_index_valid = false;
 }
 
-static void mlxsw_sp_router_fib_abort(struct mlxsw_sp *mlxsw_sp)
-{
-	int err;
-
-	if (mlxsw_sp->router->aborted)
-		return;
-	dev_warn(mlxsw_sp->bus_info->dev, "FIB abort triggered. Note that FIB entries are no longer being offloaded to this device.\n");
-	mlxsw_sp_router_fib_flush(mlxsw_sp);
-	mlxsw_sp->router->aborted = true;
-	err = mlxsw_sp_router_set_abort_trap(mlxsw_sp);
-	if (err)
-		dev_warn(mlxsw_sp->bus_info->dev, "Failed to set abort trap.\n");
-}
-
 struct mlxsw_sp_fib6_event {
 	struct fib6_info **rt_arr;
 	unsigned int nrt6;
@@ -7546,7 +7434,7 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, op_ctx, &fib_event->fen_info);
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			dev_warn(mlxsw_sp->bus_info->dev, "FIB replace failed.\n");
 			mlxsw_sp_fib4_offload_failed_flag_set(mlxsw_sp,
 							      &fib_event->fen_info);
 		}
@@ -7581,7 +7469,7 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 						   fib_event->fib6_event.nrt6);
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			dev_warn(mlxsw_sp->bus_info->dev, "FIB replace failed.\n");
 			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
 							      fib6_event->rt_arr,
 							      fib6_event->nrt6);
@@ -7593,7 +7481,7 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 						  fib_event->fib6_event.nrt6);
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			dev_warn(mlxsw_sp->bus_info->dev, "FIB append failed.\n");
 			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
 							      fib6_event->rt_arr,
 							      fib6_event->nrt6);
@@ -7625,7 +7513,7 @@ static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
 
 		err = mlxsw_sp_router_fibmr_add(mlxsw_sp, &fib_event->men_info, replace);
 		if (err)
-			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			dev_warn(mlxsw_sp->bus_info->dev, "MR entry add failed.\n");
 		mr_cache_put(fib_event->men_info.mfc);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
@@ -7636,7 +7524,7 @@ static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
 		err = mlxsw_sp_router_fibmr_vif_add(mlxsw_sp,
 						    &fib_event->ven_info);
 		if (err)
-			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			dev_warn(mlxsw_sp->bus_info->dev, "MR VIF add failed.\n");
 		dev_put(fib_event->ven_info.dev);
 		break;
 	case FIB_EVENT_VIF_DEL:
@@ -7800,9 +7688,6 @@ static int mlxsw_sp_router_fib_rule_event(unsigned long event,
 	if (event == FIB_EVENT_RULE_DEL)
 		return 0;
 
-	if (mlxsw_sp->router->aborted)
-		return 0;
-
 	fr_info = container_of(info, struct fib_rule_notifier_info, info);
 	rule = fr_info->rule;
 
@@ -7860,10 +7745,6 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	case FIB_EVENT_ENTRY_ADD:
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_APPEND:
-		if (router->aborted) {
-			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
-			return notifier_from_errno(-EINVAL);
-		}
 		if (info->family == AF_INET) {
 			struct fib_entry_notifier_info *fen_info = ptr;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index be7708a375e1..c5d7007f9173 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -58,7 +58,6 @@ struct mlxsw_sp_router {
 #define MLXSW_SP_UNRESOLVED_NH_PROBE_INTERVAL 5000 /* ms */
 	struct list_head nexthop_neighs_list;
 	struct list_head ipip_list;
-	bool aborted;
 	struct notifier_block nexthop_nb;
 	struct notifier_block fib_nb;
 	struct notifier_block netevent_nb;
-- 
2.31.1

