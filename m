Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CD2344A10
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCVQAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56943 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230101AbhCVP7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AC0D75C01CF;
        Mon, 22 Mar 2021 11:59:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EuCxEafIPj0K3f4GfJuKT/0AbXxn1ehD54XgXQepoJc=; b=WGAJgfNH
        oxxYdALsqDRgEmhQfZG/vT+QGPM7BNv/KUHyJ6rPYOg7H0CusL3nSAvy/99yTb1x
        WAHyjNicIpC5m0zQD1mQ5jppSbVAfTyHNTrzszUKE5LTCA8jvrBo82Gbq6mvER/k
        qPLiZq61u84STV4JS32rV2sTOniT5wzYDQjaFC4nojNMBvVUXtYvIiHf0qYZfoIy
        hhExJSNE8q1A6ODfV2Gtcqyu5Ig7lgJ60Eh1Oo2jlyyyFSM1ejWNFpyZdflzpFIE
        dLzmKiUUcah/6KwEjZB4GdBaB7j9uLloOoYagJSQOxFQTWKImbfsaCVH9lJwjTOs
        Z5Cf+/lFJw1qKw==
X-ME-Sender: <xms:-L5YYPYuuumcCOng7WVFEBMmXFEHcxzlpvKCKpxfQIYh12HOVhLCJw>
    <xme:-L5YYLTXXPCji8uqGMxRROzdrqh6Kxnv5b38Py-Ye7s2R61BOsYMdmpuxIM5SUv8s
    YiRJ08yHcRBKHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-L5YYBtF0MB6UdpN7K1RgRfCgK4PAG-2lpBFfl80nYg2aZvDkHflbw>
    <xmx:-L5YYFHeJ9egizbh1BRRuWz2rm4IC-teXAPAgenkXtgnhUAPpjtwwg>
    <xmx:-L5YYKwkBLCXDibam3H5tBFg0bY4R1Z2Wth_ZCH61xj6fBIdxmUaYA>
    <xmx:-L5YYKR2vqYTwuJVvn5bc_NPCnf8MaXG87braGU1V2lh_7L4AQBFPQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C4BA1080064;
        Mon, 22 Mar 2021 11:59:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/14] mlxsw: spectrum_router: Add nexthop trap action support
Date:   Mon, 22 Mar 2021 17:58:48 +0200
Message-Id: <20210322155855.3164151-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, nexthops are programmed with either forward or discard action
(for blackhole nexthops). Nexthops that do not have a valid MAC address
(neighbour) or router interface (RIF) are simply not written to the
adjacency table.

In resilient nexthop groups, the size of the group must remain fixed and
the kernel is in complete control of the layout of the adjacency table.
A nexthop without a valid MAC or RIF will therefore be written with a
trap action, to trigger neighbour resolution.

Allow such nexthops to be programmed to the adjacency table to enable
above mentioned use case.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 42 +++++++++++++------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d09a76866a5f..50286c6d0a8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2847,6 +2847,8 @@ enum mlxsw_sp_nexthop_action {
 	MLXSW_SP_NEXTHOP_ACTION_FORWARD,
 	/* Nexthop discards packets */
 	MLXSW_SP_NEXTHOP_ACTION_DISCARD,
+	/* Nexthop traps packets */
+	MLXSW_SP_NEXTHOP_ACTION_TRAP,
 };
 
 struct mlxsw_sp_nexthop_key {
@@ -3418,11 +3420,23 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
 			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
 			    adj_index, rif_index);
-	if (nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD)
+	switch (nh->action) {
+	case MLXSW_SP_NEXTHOP_ACTION_FORWARD:
+		mlxsw_reg_ratr_eth_entry_pack(ratr_pl, neigh_entry->ha);
+		break;
+	case MLXSW_SP_NEXTHOP_ACTION_DISCARD:
 		mlxsw_reg_ratr_trap_action_set(ratr_pl,
 					       MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS);
-	else
-		mlxsw_reg_ratr_eth_entry_pack(ratr_pl, neigh_entry->ha);
+		break;
+	case MLXSW_SP_NEXTHOP_ACTION_TRAP:
+		mlxsw_reg_ratr_trap_action_set(ratr_pl,
+					       MLXSW_REG_RATR_TRAP_ACTION_TRAP);
+		mlxsw_reg_ratr_trap_id_set(ratr_pl, MLXSW_TRAP_ID_RTR_EGRESS0);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 	if (nh->counter_valid)
 		mlxsw_reg_ratr_counter_pack(ratr_pl, nh->counter_index, true);
 	else
@@ -3495,16 +3509,18 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 		if (nh->update || reallocate) {
 			int err = 0;
 
-			switch (nh->type) {
-			case MLXSW_SP_NEXTHOP_TYPE_ETH:
-				err = mlxsw_sp_nexthop_update
-					    (mlxsw_sp, adj_index, nh);
-				break;
-			case MLXSW_SP_NEXTHOP_TYPE_IPIP:
-				err = mlxsw_sp_nexthop_ipip_update
-					    (mlxsw_sp, adj_index, nh);
-				break;
-			}
+			/* When action is discard or trap, the nexthop must be
+			 * programmed as an Ethernet nexthop.
+			 */
+			if (nh->type == MLXSW_SP_NEXTHOP_TYPE_ETH ||
+			    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
+			    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
+				err = mlxsw_sp_nexthop_update(mlxsw_sp,
+							      adj_index, nh);
+			else
+				err = mlxsw_sp_nexthop_ipip_update(mlxsw_sp,
+								   adj_index,
+								   nh);
 			if (err)
 				return err;
 			nh->update = 0;
-- 
2.29.2

