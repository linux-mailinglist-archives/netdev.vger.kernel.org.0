Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5E12AD8A
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfLZQl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:41:58 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56447 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbfLZQl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:41:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C75CE21C28;
        Thu, 26 Dec 2019 11:41:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yL0sEu4+xkxWiL8tEDrvqFjo7ElL2S9hyNwAs0aqzJY=; b=HWF348dF
        0FNeOrQ4FC0524j4UVlx9UEAJXWinHTTfjO1qPnpR8ECloLtKRZ+Av1sxyZ6/CQ/
        NRaS9bPRRI1c25CbLZo2DYAsEBidnVaB9K9hJvXiAaqF+aahnl3NcBVzLsC2DfYg
        ODh7vDTLq7TE4wMLEImaAp7wTDExkUGO5bWvQ0997iRuyH+PG7njUveyfs05nOnt
        OyWWsLEACrlx3fmDFUn2KeWuxCGq9ftG/xxBAtkU9q4dtSo15yDUT/yao5tSVnWi
        Qew+r4OhgFwXV4rycxpkUzwZvvLvLOBbJy8GRw8K7rjud77Z23Uvb7FGfZ7WVPPX
        ZC6xss5h11wLyw==
X-ME-Sender: <xms:1OIEXgGCrb7DP4B06uCHUH38ApmDYYFGLUKA3czJ9YZCosrPrdABxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:1OIEXkvXIeJxQP39uipYho1TahrgOg_6aVV8loBKbDskRvJGJeON2Q>
    <xmx:1OIEXoCRD4s7PIaR0OgqlRpsNwX1gR7kHMGetQx_ZPP2t_Kotdpy3Q>
    <xmx:1OIEXtN8dvsdmzzVtXPa_zbGRfIoLKd-s8hHrYuisHM08pcZeOgI_g>
    <xmx:1OIEXv-dxBIsZwM1Xpj7b9-0AZGW8ysBYeqNB6GJ7qSJnXKBs6YuWw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B249330607B4;
        Thu, 26 Dec 2019 11:41:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] mlxsw: spectrum_router: Remove unnecessary checks
Date:   Thu, 26 Dec 2019 18:41:13 +0200
Message-Id: <20191226164117.53794-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226164117.53794-1-idosch@idosch.org>
References: <20191226164117.53794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Now that the networking stack takes care of only notifying the routes of
interest, we do not need to maintain a list of identical routes.

Remove the check that tests if the route is the first route in the FIB
node.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f62e8d67348c..87a010cb43b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3231,10 +3231,6 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static bool
-mlxsw_sp_fib_node_entry_is_first(const struct mlxsw_sp_fib_node *fib_node,
-				 const struct mlxsw_sp_fib_entry *fib_entry);
-
 static int
 mlxsw_sp_nexthop_fib_entries_update(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_nexthop_group *nh_grp)
@@ -3243,9 +3239,6 @@ mlxsw_sp_nexthop_fib_entries_update(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node) {
-		if (!mlxsw_sp_fib_node_entry_is_first(fib_entry->fib_node,
-						      fib_entry))
-			continue;
 		err = mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
 		if (err)
 			return err;
@@ -3263,12 +3256,8 @@ mlxsw_sp_nexthop_fib_entries_refresh(struct mlxsw_sp_nexthop_group *nh_grp)
 	enum mlxsw_reg_ralue_op op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
 	struct mlxsw_sp_fib_entry *fib_entry;
 
-	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node) {
-		if (!mlxsw_sp_fib_node_entry_is_first(fib_entry->fib_node,
-						      fib_entry))
-			continue;
+	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node)
 		mlxsw_sp_fib_entry_offload_refresh(fib_entry, op, 0);
-	}
 }
 
 static void mlxsw_sp_adj_grp_size_round_up(u16 *p_adj_grp_size)
@@ -4785,9 +4774,6 @@ static int mlxsw_sp_fib_node_entry_add(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
 
-	if (!mlxsw_sp_fib_node_entry_is_first(fib_node, fib_entry))
-		return 0;
-
 	/* To prevent packet loss, overwrite the previously offloaded
 	 * entry.
 	 */
-- 
2.24.1

