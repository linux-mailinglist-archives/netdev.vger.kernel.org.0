Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3705C344A0A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCVQA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47381 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231244AbhCVP7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D21B65C01CF;
        Mon, 22 Mar 2021 11:59:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=BCNyOpDbuYFsJhBRXLwdcyoXqusrAZDyqzK7+4xGqL4=; b=UnqhV4LQ
        YYo+3tTJzKvgAWcQ8UVZr/0uZhNXp9OTZjsX1Yad1nxqzRo8/76UPf35hdyaYwHW
        o3R5yAIOGJuFOZ+qDGXeufVysYNfjwm3m8UTXT+gY9thqE1Gdl8n7NwEECKsoNke
        lI+XqlrBL0R3zCxveK5Z34ucVv9/UJ6YIB7gr8d2mJ8mfxIYfQPh2rx9EQa/zqfB
        cklwxtnnhj1+0ADLf7dTsTdNO1xJdQD5NGGv17EcEn+NHGviiNPtUxUdoM7eeud2
        gytfzI7kMf7YlnmjAuZOvhAzLQOoMP5FMQ0fDon1TDnkZBTKX5rLLT41PcaamsqS
        E74fxx46o1+Aqg==
X-ME-Sender: <xms:7b5YYDlZPa3GBQCSt34uZ5aKS7jkGJVBcF9tmDdI90bp4NGrxaA7Aw>
    <xme:7b5YYG1PytdtH1I2aAc-ii6ze_JPxZcM_7sSnxQmiTcsUzYwTFiUZW26z-PzP5eOF
    JsMCL6Q1oLF78U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7b5YYJoXXFqbYEhIAShlG4rRDXclGp_b6iPEsQL9gzplxe0YA2T5Eg>
    <xmx:7b5YYLnURcnRX9MEuEN9AjtRiL-SZ9Qm4MvSmkO7nJHos3Rp7v1fnA>
    <xmx:7b5YYB2NqTSC_xqml62rpOwgfrmJR8PJioepb7brnXKcda_q7Nofvw>
    <xmx:7b5YYMQTgNAy2JvKesuI1hQG8EisgkyQqAmkogLfwQ68RnO5WYNrog>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0011108005F;
        Mon, 22 Mar 2021 11:59:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/14] mlxsw: spectrum_router: Consolidate nexthop helpers
Date:   Mon, 22 Mar 2021 17:58:43 +0200
Message-Id: <20210322155855.3164151-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The helper mlxsw_sp_nexthop_offload() is actually interested in finding
out if the nexthop is both written to the adjacency table and forwarding
packets (as opposed to discarding them).

Rename it to mlxsw_sp_nexthop_is_forward() and remove
mlxsw_sp_nexthop_is_discard().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c  | 15 ++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c |  9 ++-------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h |  3 +--
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index ed81d4fa48ac..936224d8c2ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -912,9 +912,8 @@ static u64 mlxsw_sp_dpipe_table_adj_size(struct mlxsw_sp *mlxsw_sp)
 	u64 size = 0;
 
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router)
-		if (mlxsw_sp_nexthop_offload(nh) &&
-		    !mlxsw_sp_nexthop_group_has_ipip(nh) &&
-		    !mlxsw_sp_nexthop_is_discard(nh))
+		if (mlxsw_sp_nexthop_is_forward(nh) &&
+		    !mlxsw_sp_nexthop_group_has_ipip(nh))
 			size++;
 	return size;
 }
@@ -1105,9 +1104,8 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	nh_skip = nh_count;
 	nh_count = 0;
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router) {
-		if (!mlxsw_sp_nexthop_offload(nh) ||
-		    mlxsw_sp_nexthop_group_has_ipip(nh) ||
-		    mlxsw_sp_nexthop_is_discard(nh))
+		if (!mlxsw_sp_nexthop_is_forward(nh) ||
+		    mlxsw_sp_nexthop_group_has_ipip(nh))
 			continue;
 
 		if (nh_count < nh_skip)
@@ -1187,9 +1185,8 @@ static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 	u32 adj_size = 0;
 
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router) {
-		if (!mlxsw_sp_nexthop_offload(nh) ||
-		    mlxsw_sp_nexthop_group_has_ipip(nh) ||
-		    mlxsw_sp_nexthop_is_discard(nh))
+		if (!mlxsw_sp_nexthop_is_forward(nh) ||
+		    mlxsw_sp_nexthop_group_has_ipip(nh))
 			continue;
 
 		mlxsw_sp_nexthop_indexes(nh, &adj_index, &adj_size,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0e0b40e97783..593a40aa9af8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2979,9 +2979,9 @@ struct mlxsw_sp_nexthop *mlxsw_sp_nexthop_next(struct mlxsw_sp_router *router,
 	return list_next_entry(nh, router_list_node);
 }
 
-bool mlxsw_sp_nexthop_offload(struct mlxsw_sp_nexthop *nh)
+bool mlxsw_sp_nexthop_is_forward(const struct mlxsw_sp_nexthop *nh)
 {
-	return nh->offloaded;
+	return nh->offloaded && !nh->discard;
 }
 
 unsigned char *mlxsw_sp_nexthop_ha(struct mlxsw_sp_nexthop *nh)
@@ -3036,11 +3036,6 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh)
 	return false;
 }
 
-bool mlxsw_sp_nexthop_is_discard(const struct mlxsw_sp_nexthop *nh)
-{
-	return nh->discard;
-}
-
 static const struct rhashtable_params mlxsw_sp_nexthop_group_vr_ht_params = {
 	.key_offset = offsetof(struct mlxsw_sp_nexthop_group_vr_entry, key),
 	.head_offset = offsetof(struct mlxsw_sp_nexthop_group_vr_entry, ht_node),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 2875ee8ec537..8ecd090a5d8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -195,13 +195,12 @@ mlxsw_sp_ipip_demote_tunnel_by_saddr(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_ipip_entry *except);
 struct mlxsw_sp_nexthop *mlxsw_sp_nexthop_next(struct mlxsw_sp_router *router,
 					       struct mlxsw_sp_nexthop *nh);
-bool mlxsw_sp_nexthop_offload(struct mlxsw_sp_nexthop *nh);
+bool mlxsw_sp_nexthop_is_forward(const struct mlxsw_sp_nexthop *nh);
 unsigned char *mlxsw_sp_nexthop_ha(struct mlxsw_sp_nexthop *nh);
 int mlxsw_sp_nexthop_indexes(struct mlxsw_sp_nexthop *nh, u32 *p_adj_index,
 			     u32 *p_adj_size, u32 *p_adj_hash_index);
 struct mlxsw_sp_rif *mlxsw_sp_nexthop_rif(struct mlxsw_sp_nexthop *nh);
 bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh);
-bool mlxsw_sp_nexthop_is_discard(const struct mlxsw_sp_nexthop *nh);
 #define mlxsw_sp_nexthop_for_each(nh, router)				\
 	for (nh = mlxsw_sp_nexthop_next(router, NULL); nh;		\
 	     nh = mlxsw_sp_nexthop_next(router, nh))
-- 
2.29.2

