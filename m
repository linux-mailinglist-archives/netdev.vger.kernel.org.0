Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA22344A0D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhCVQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:31 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47055 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhCVP7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F26635C01D4;
        Mon, 22 Mar 2021 11:59:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3U42voeanu/fTOq6Z4uOM9YD3zq1zHZnCuSZNA5SeH0=; b=j4yaf9UQ
        AtJjYuRC/vvnI1huEnbca8JvGPmk+tIg6MVxeS4Fn2ci496ylakc48DoheKo9Xnn
        Wk0CgHOWOpOBWBRfzrf0ytIkSjNQOCx1U0Sgq+qA9PQ5hG9Yr0eqa5dVnsNM8MV8
        1c7afFUL5cGggqWlz6VAvrpVbDmx8aMI5yKxqlZEq0Ego6lBPZZRH6+/JZWqZaqX
        204zmtyiUM/5+CWA9sTBf9yekY6v8lCMhBDgmjp1ax8Jlv3wJhVq+sjGSe8ZRuja
        Sv+XR4LY/udbT3AriQhpFHooGs8ojxfJpByVe00Z2NL8yY7BeffrG6FMDU+NdW3u
        XA9igQ+7tiCFJw==
X-ME-Sender: <xms:875YYIdwsgGG43MEE2dUjW3JrPD_g-eOhlzF9aZcDIy9CZz9gkDc_g>
    <xme:875YYKNPfSD0JCbPhrV_62v7NBq1hI2TmYrt2EzMxakLwv8f3exOIwfEUUmfuI1e9
    0Py5pB4w-Rz3VU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:875YYJiyiybHh6UwlKb7oix8IkYOASut4r6pAFW4b_dxAR9u3pfNhA>
    <xmx:875YYN8G86QWsvVUMB1CJwF2xZOpH_KJQcRjZ9ejOJ_vNJD2EcaMsA>
    <xmx:875YYEsLfofrFLKGo-ZzG9X9Sehfj96888Pia2J34Y0bFN36kWhfdA>
    <xmx:875YYGIeGwuClT7dk9XMT961fRYha7HWtj3IkrjFExg33LiHpEgLkw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19D211080064;
        Mon, 22 Mar 2021 11:59:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/14] mlxsw: spectrum_router: Introduce nexthop action field
Date:   Mon, 22 Mar 2021 17:58:46 +0200
Message-Id: <20210322155855.3164151-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the action associated with the nexthop is assumed to be
'forward' unless the 'discard' bit is set.

Instead, simplify this by introducing a dedicated field to represent the
action of the nexthop. This will allow us to more easily introduce more
actions, such as trap.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index bdf519b569b6..3ad1e1bd2197 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2842,6 +2842,13 @@ enum mlxsw_sp_nexthop_type {
 	MLXSW_SP_NEXTHOP_TYPE_IPIP,
 };
 
+enum mlxsw_sp_nexthop_action {
+	/* Nexthop forwards packets to an egress RIF */
+	MLXSW_SP_NEXTHOP_ACTION_FORWARD,
+	/* Nexthop discards packets */
+	MLXSW_SP_NEXTHOP_ACTION_DISCARD,
+};
+
 struct mlxsw_sp_nexthop_key {
 	struct fib_nh *fib_nh;
 };
@@ -2868,10 +2875,10 @@ struct mlxsw_sp_nexthop {
 	   offloaded:1, /* set indicates this nexthop was written to the
 			 * adjacency table.
 			 */
-	   update:1, /* set indicates this nexthop should be updated in the
+	   update:1; /* set indicates this nexthop should be updated in the
 		      * adjacency table (f.e., its MAC changed).
 		      */
-	   discard:1; /* nexthop is programmed to discard packets */
+	enum mlxsw_sp_nexthop_action action;
 	enum mlxsw_sp_nexthop_type type;
 	union {
 		struct mlxsw_sp_neigh_entry *neigh_entry;
@@ -2981,7 +2988,7 @@ struct mlxsw_sp_nexthop *mlxsw_sp_nexthop_next(struct mlxsw_sp_router *router,
 
 bool mlxsw_sp_nexthop_is_forward(const struct mlxsw_sp_nexthop *nh)
 {
-	return nh->offloaded && !nh->discard;
+	return nh->offloaded && nh->action == MLXSW_SP_NEXTHOP_ACTION_FORWARD;
 }
 
 unsigned char *mlxsw_sp_nexthop_ha(struct mlxsw_sp_nexthop *nh)
@@ -3408,7 +3415,7 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
 			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
 			    adj_index, nh->rif->rif_index);
-	if (nh->discard)
+	if (nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD)
 		mlxsw_reg_ratr_trap_action_set(ratr_pl,
 					       MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS);
 	else
@@ -3828,10 +3835,12 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 static void __mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp_nexthop *nh,
 					    bool removing)
 {
-	if (!removing)
+	if (!removing) {
+		nh->action = MLXSW_SP_NEXTHOP_ACTION_FORWARD;
 		nh->should_offload = 1;
-	else
+	} else {
 		nh->should_offload = 0;
+	}
 	nh->update = 1;
 }
 
@@ -4342,7 +4351,7 @@ static void mlxsw_sp_nexthop_obj_blackhole_init(struct mlxsw_sp *mlxsw_sp,
 {
 	u16 lb_rif_index = mlxsw_sp->router->lb_rif_index;
 
-	nh->discard = 1;
+	nh->action = MLXSW_SP_NEXTHOP_ACTION_DISCARD;
 	nh->should_offload = 1;
 	/* While nexthops that discard packets do not forward packets
 	 * via an egress RIF, they still need to be programmed using a
@@ -4405,7 +4414,7 @@ mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop_obj_fini(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_nexthop *nh)
 {
-	if (nh->discard)
+	if (nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD)
 		mlxsw_sp_nexthop_obj_blackhole_fini(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 	list_del(&nh->router_list_node);
-- 
2.29.2

