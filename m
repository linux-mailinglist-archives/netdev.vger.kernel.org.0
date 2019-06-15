Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1DA47057
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFOOJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43171 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6646321B84;
        Sat, 15 Jun 2019 10:09:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1efc3Dv9uRNjSlyULYPnKi2sVDvFMynQicmI5t02aDE=; b=CEzZmfiO
        nYJgfLlD/rFRGFm0fnZTOW2e3tL+zTB3s/xCgdAxkYT0RS4t8obfSZPTjXgW8WlF
        AO+ex5m6kA3J0Tyvrd5GunOCkw+QIrtpE9kVIjeT8oVsntFldQxgLQVET4PGAs3Z
        Jv0ntE11vQhGo8R8UEU8AfkpbgGgy7pytyczvvSKqAs/g55KVIHkgw90WA/hZ9EQ
        zrv7HfjLfV1oQBu9ZHZJ4CZVZ6hfEXT04liwZr6rhumjryAvMMEMKVfZJIdB5Yeh
        LMJUyMkgbDzsVnNysCUXjUkj2ICa9GzSf1E4ezxMLrSha72Ij+6DXvdQlEz6Q6zQ
        dlAbt/0ALvYIHw==
X-ME-Sender: <xms:MPwEXcW2WqAtIjaJP328ezL3VWyCNbGSd_OnobkDK3OEteaBsnTkrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:MPwEXYKv6dW8QXlY8O2cZig57z39V5lGsFC0SPUxc9AevGMJ5iPj3g>
    <xmx:MPwEXX-jPjR6MMoNLL6wxZbdbKVS3KxTj1i2bYyXlqo6w-11wQC4HQ>
    <xmx:MPwEXbQ-1u2V7B1CXmtYGvmaQn1FKa7wIfGu9c17qYS2GA7qMw-4og>
    <xmx:MPwEXVFJih0BTQLnuUyek3EBpnL6vOWiREvCwqPqvh665LroxJNJcA>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 520DE380073;
        Sat, 15 Jun 2019 10:09:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/17] mlxsw: spectrum_router: Add / delete multiple IPv6 nexthops
Date:   Sat, 15 Jun 2019 17:07:48 +0300
Message-Id: <20190615140751.17661-15-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the functions that take care of populating IPv6 nexthop
groups only add / delete a single nexthop.

Prepare them to handle multiple routes in one notification by passing an
array of routes and adding / deleting all of them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 61 ++++++++++++-------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2788366329b4..b3077aceb884 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5211,17 +5211,21 @@ mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
-				struct fib6_info *rt)
+				struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
-	int err;
+	int err, i;
 
-	mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt);
-	if (IS_ERR(mlxsw_sp_rt6))
-		return PTR_ERR(mlxsw_sp_rt6);
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
+		if (IS_ERR(mlxsw_sp_rt6)) {
+			err = PTR_ERR(mlxsw_sp_rt6);
+			goto err_rt6_create;
+		}
 
-	list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
-	fib6_entry->nrt6++;
+		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
+		fib6_entry->nrt6++;
+	}
 
 	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
 	if (err)
@@ -5230,27 +5234,38 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_nexthop6_group_update:
-	fib6_entry->nrt6--;
-	list_del(&mlxsw_sp_rt6->list);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	i = nrt6;
+err_rt6_create:
+	for (i--; i >= 0; i--) {
+		fib6_entry->nrt6--;
+		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
+					       struct mlxsw_sp_rt6, list);
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 	return err;
 }
 
 static void
 mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
-				struct fib6_info *rt)
+				struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
+	int i;
 
-	mlxsw_sp_rt6 = mlxsw_sp_fib6_entry_rt_find(fib6_entry, rt);
-	if (WARN_ON(!mlxsw_sp_rt6))
-		return;
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_fib6_entry_rt_find(fib6_entry,
+							   rt_arr[i]);
+		if (WARN_ON_ONCE(!mlxsw_sp_rt6))
+			continue;
+
+		fib6_entry->nrt6--;
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 
-	fib6_entry->nrt6--;
-	list_del(&mlxsw_sp_rt6->list);
 	mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 }
 
 static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
@@ -5519,7 +5534,8 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 	 */
 	fib6_entry = mlxsw_sp_fib6_node_mp_entry_find(fib_node, rt, replace);
 	if (fib6_entry) {
-		err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt);
+		err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry,
+						      rt_arr, nrt6);
 		if (err)
 			goto err_fib6_entry_nexthop_add;
 		return 0;
@@ -5565,11 +5581,12 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	if (WARN_ON(!fib6_entry))
 		return;
 
-	/* If route is part of a multipath entry, but not the last one
-	 * removed, then only reduce its nexthop group.
+	/* If not all the nexthops are deleted, then only reduce the nexthop
+	 * group.
 	 */
-	if (!list_is_singular(&fib6_entry->rt6_list)) {
-		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt);
+	if (nrt6 != fib6_entry->nrt6) {
+		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt_arr,
+						nrt6);
 		return;
 	}
 
-- 
2.20.1

