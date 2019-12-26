Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF212AD8C
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfLZQmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:42:02 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56319 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726933AbfLZQmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:42:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 53DB221DFB;
        Thu, 26 Dec 2019 11:42:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=q39R68mweeGXzmjgdnbY63iP3nrxmJqqgYDaSQ+mMtY=; b=yN5852Qd
        isGxnh+qhwkzg6tMX0fD+rJffPKZuFht9v7He9t8/KUve1aMoyz4LeQ0+aFLGQic
        b473s9zPhNVTaE/zI5GruKXLvRNztBpSeV6SwG+UxEQ7qp6NLQG2dodkL68NGq26
        5hsGjEHogjN2Ox3vNrGuklJI+HiaI280FLIMqwEIh9EXVfFy8C++vBQU7h75wIgD
        j9OfJJZRteuiqgXmkG+0jGmjSrPLNAHB2DcX4bw4b4KOg4Ut8x0nl2YPwRBHABSl
        ViGgfhIklWU6HEJjC3wAJpBjAbsKB7IzJ+oQps3j0hsxCXB8G0ro88VrnXPIb55E
        zhnhUmQGQVszig==
X-ME-Sender: <xms:2OIEXs9sbe3_Rof23NpMxAsTXKK3aK4dXDdydW0iUX9i7BUX8_URRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:2OIEXtxjn12U7fKORrzE8Quu5xAf_CpA0PXKJyygZwmJoJ3EhtJZGw>
    <xmx:2OIEXk9DBtphJ0YqvmfhNi8UmgS1FXLglj8ybh7qV11ntREtNJGv2Q>
    <xmx:2OIEXpiypWZHZhZnWC2t2rT5YqIb1A4Gu4USD0og9gDyxDwq_dMUSA>
    <xmx:2OIEXicMbabCqHoLcHnZQAu8J_lVtjIT3-fYo0jIzaNQYae3LxODfQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F49530607B4;
        Thu, 26 Dec 2019 11:41:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_router: Consolidate identical functions
Date:   Thu, 26 Dec 2019 18:41:16 +0200
Message-Id: <20191226164117.53794-5-idosch@idosch.org>
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

After the last patch mlxsw_sp_fib{4,6}_node_entry_link() and
mlxsw_sp_fib{4,6}_node_entry_unlink() are identical and can therefore be
consolidated into the same common function.

Perform the consolidation.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 71 ++++++-------------
 1 file changed, 22 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 940832761d1b..f332c55fc83e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4813,31 +4813,31 @@ static void mlxsw_sp_fib_node_entry_del(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
 }
 
-static int mlxsw_sp_fib4_node_entry_link(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_fib4_entry *fib4_entry)
+static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
+	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
 	int err;
 
-	list_add(&fib4_entry->common.list, &fib_node->entry_list);
+	list_add(&fib_entry->list, &fib_node->entry_list);
 
-	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, &fib4_entry->common);
+	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, fib_entry);
 	if (err)
 		goto err_fib_node_entry_add;
 
 	return 0;
 
 err_fib_node_entry_add:
-	list_del(&fib4_entry->common.list);
+	list_del(&fib_entry->list);
 	return err;
 }
 
 static void
-mlxsw_sp_fib4_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib4_entry *fib4_entry)
+mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib_entry *fib_entry)
 {
-	mlxsw_sp_fib_node_entry_del(mlxsw_sp, &fib4_entry->common);
-	list_del(&fib4_entry->common.list);
+	mlxsw_sp_fib_node_entry_del(mlxsw_sp, fib_entry);
+	list_del(&fib_entry->list);
 }
 
 static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
@@ -4852,7 +4852,7 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
 	/* We inserted the new entry before replaced one */
 	replaced = list_next_entry(fib4_entry, common.list);
 
-	mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, replaced);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &replaced->common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, replaced);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -4884,17 +4884,17 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib4_entry_create;
 	}
 
-	err = mlxsw_sp_fib4_node_entry_link(mlxsw_sp, fib4_entry);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib4_entry->common);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to link FIB entry to node\n");
-		goto err_fib4_node_entry_link;
+		goto err_fib_node_entry_link;
 	}
 
 	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
 
 	return 0;
 
-err_fib4_node_entry_link:
+err_fib_node_entry_link:
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 err_fib4_entry_create:
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
@@ -4915,7 +4915,7 @@ static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
 		return;
 	fib_node = fib4_entry->common.fib_node;
 
-	mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, fib4_entry);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -5374,33 +5374,6 @@ static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	kfree(fib6_entry);
 }
 
-static int mlxsw_sp_fib6_node_entry_link(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_fib6_entry *fib6_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
-	int err;
-
-	list_add(&fib6_entry->common.list, &fib_node->entry_list);
-
-	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, &fib6_entry->common);
-	if (err)
-		goto err_fib_node_entry_add;
-
-	return 0;
-
-err_fib_node_entry_add:
-	list_del(&fib6_entry->common.list);
-	return err;
-}
-
-static void
-mlxsw_sp_fib6_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib6_entry *fib6_entry)
-{
-	mlxsw_sp_fib_node_entry_del(mlxsw_sp, &fib6_entry->common);
-	list_del(&fib6_entry->common.list);
-}
-
 static struct mlxsw_sp_fib6_entry *
 mlxsw_sp_fib6_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 			   const struct fib6_info *rt)
@@ -5445,7 +5418,7 @@ static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
 	/* We inserted the new entry before replaced one */
 	replaced = list_next_entry(fib6_entry, common.list);
 
-	mlxsw_sp_fib6_node_entry_unlink(mlxsw_sp, replaced);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &replaced->common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, replaced);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -5483,15 +5456,15 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
-	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib6_entry->common);
 	if (err)
-		goto err_fib6_node_entry_link;
+		goto err_fib_node_entry_link;
 
 	mlxsw_sp_fib6_entry_replace(mlxsw_sp, fib6_entry);
 
 	return 0;
 
-err_fib6_node_entry_link:
+err_fib_node_entry_link:
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 err_fib6_entry_create:
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
@@ -5577,7 +5550,7 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 
 	fib_node = fib6_entry->common.fib_node;
 
-	mlxsw_sp_fib6_node_entry_unlink(mlxsw_sp, fib6_entry);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
@@ -5737,7 +5710,7 @@ static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
 				 common.list) {
 		bool do_break = &tmp->common.list == &fib_node->entry_list;
 
-		mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, fib4_entry);
+		mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib4_entry->common);
 		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 		/* Break when entry list is empty and node was freed.
@@ -5758,7 +5731,7 @@ static void mlxsw_sp_fib6_node_flush(struct mlxsw_sp *mlxsw_sp,
 				 common.list) {
 		bool do_break = &tmp->common.list == &fib_node->entry_list;
 
-		mlxsw_sp_fib6_node_entry_unlink(mlxsw_sp, fib6_entry);
+		mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib6_entry->common);
 		mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 		if (do_break)
-- 
2.24.1

