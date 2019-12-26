Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1A412AD8E
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfLZQmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:42:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37723 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726755AbfLZQmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:42:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F93121E1C;
        Thu, 26 Dec 2019 11:42:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:42:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=S2s3Srf01ikKsEfzPgDFxyO1ggv0x0isJLvXwUNADn4=; b=L7IYmFTR
        xfwBB3fsVjEArEFCKvOCD4sqz02T0u+Il8XWbO9ohTQITHslKjhj8uCIveubeHdB
        YaKnvAZt19rWkgXjX4gEaWdULLPyuPsPAoAHd6RRMyT/QoqEfSzlSP2tHtiBkoJq
        vz0b3cZB2YaHh5W7BqerMro1XmV2HxNTXXDng9pWGk3kK9pJnFuVWEgT8z3FzUTc
        JX2N9uc0kCqi7kDISpn+xH1rFW4Gj9mtk14aJpTe19iYlQcFUp3asOlI760jrO+e
        N3Uxx+Ei1lHjc6fIJ7Nljc5yvrFsS1zOHbEu5nizIUVT5Ik9sK/4tdM3hITrmOzW
        iYCUiXy0DcjYrw==
X-ME-Sender: <xms:2eIEXlQkSiDv1gqV6CTz_8MdaWqseptEng0BhVp8sr4kW9ylbSU2vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:2eIEXpSv1fT6uw-gDWjfhbdZimwtD0oxSEXfWA-T4D3nzpAzAIzhEw>
    <xmx:2eIEXoo9MfGwQy1UzD0AlImQkzq7ArSpAEW3ukyxBpVp8OdbcXaMgg>
    <xmx:2eIEXqDGAW_ejqC7izZoh5tIg5hdoR4UJcHm8Ej-k7MtVF10IWulBg>
    <xmx:2eIEXi18SQYE7GUduS_43HlFpv8Qr5RVwUK23zPRAyMEGQsz8Z0-bw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B15630607BE;
        Thu, 26 Dec 2019 11:42:00 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] mlxsw: spectrum_router: Remove FIB entry list from FIB node
Date:   Thu, 26 Dec 2019 18:41:17 +0200
Message-Id: <20191226164117.53794-6-idosch@idosch.org>
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

As explained in previous patches, the driver no longer needs to maintain
a list of identical FIB entries (i.e, same {tb_id, prefix, prefix
length}) and therefore each FIB node can only store one FIB entry.

Remove the FIB entry list and simplify the code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 225 ++++++------------
 1 file changed, 74 insertions(+), 151 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f332c55fc83e..da1c8342c8f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -382,9 +382,10 @@ enum mlxsw_sp_fib_entry_type {
 };
 
 struct mlxsw_sp_nexthop_group;
+struct mlxsw_sp_fib_entry;
 
 struct mlxsw_sp_fib_node {
-	struct list_head entry_list;
+	struct mlxsw_sp_fib_entry *fib_entry;
 	struct list_head list;
 	struct rhash_head ht_node;
 	struct mlxsw_sp_fib *fib;
@@ -397,7 +398,6 @@ struct mlxsw_sp_fib_entry_decap {
 };
 
 struct mlxsw_sp_fib_entry {
-	struct list_head list;
 	struct mlxsw_sp_fib_node *fib_node;
 	enum mlxsw_sp_fib_entry_type type;
 	struct list_head nexthop_group_node;
@@ -1162,7 +1162,6 @@ mlxsw_sp_router_ip2me_fib_entry_find(struct mlxsw_sp *mlxsw_sp, u32 tb_id,
 				     const union mlxsw_sp_l3addr *addr,
 				     enum mlxsw_sp_fib_entry_type type)
 {
-	struct mlxsw_sp_fib_entry *fib_entry;
 	struct mlxsw_sp_fib_node *fib_node;
 	unsigned char addr_prefix_len;
 	struct mlxsw_sp_fib *fib;
@@ -1191,15 +1190,10 @@ mlxsw_sp_router_ip2me_fib_entry_find(struct mlxsw_sp *mlxsw_sp, u32 tb_id,
 
 	fib_node = mlxsw_sp_fib_node_lookup(fib, addrp, addr_len,
 					    addr_prefix_len);
-	if (!fib_node || list_empty(&fib_node->entry_list))
+	if (!fib_node || fib_node->fib_entry->type != type)
 		return NULL;
 
-	fib_entry = list_first_entry(&fib_node->entry_list,
-				     struct mlxsw_sp_fib_entry, list);
-	if (fib_entry->type != type)
-		return NULL;
-
-	return fib_entry;
+	return fib_node->fib_entry;
 }
 
 /* Given an IPIP entry, find the corresponding decap route. */
@@ -1209,7 +1203,6 @@ mlxsw_sp_ipip_entry_find_decap(struct mlxsw_sp *mlxsw_sp,
 {
 	static struct mlxsw_sp_fib_node *fib_node;
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
-	struct mlxsw_sp_fib_entry *fib_entry;
 	unsigned char saddr_prefix_len;
 	union mlxsw_sp_l3addr saddr;
 	struct mlxsw_sp_fib *ul_fib;
@@ -1244,15 +1237,11 @@ mlxsw_sp_ipip_entry_find_decap(struct mlxsw_sp *mlxsw_sp,
 
 	fib_node = mlxsw_sp_fib_node_lookup(ul_fib, saddrp, saddr_len,
 					    saddr_prefix_len);
-	if (!fib_node || list_empty(&fib_node->entry_list))
+	if (!fib_node ||
+	    fib_node->fib_entry->type != MLXSW_SP_FIB_ENTRY_TYPE_TRAP)
 		return NULL;
 
-	fib_entry = list_first_entry(&fib_node->entry_list,
-				     struct mlxsw_sp_fib_entry, list);
-	if (fib_entry->type != MLXSW_SP_FIB_ENTRY_TYPE_TRAP)
-		return NULL;
-
-	return fib_entry;
+	return fib_node->fib_entry;
 }
 
 static struct mlxsw_sp_ipip_entry *
@@ -4559,15 +4548,14 @@ mlxsw_sp_fib4_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	if (!fib_node)
 		return NULL;
 
-	list_for_each_entry(fib4_entry, &fib_node->entry_list, common.list) {
-		if (fib4_entry->tb_id == fen_info->tb_id &&
-		    fib4_entry->tos == fen_info->tos &&
-		    fib4_entry->type == fen_info->type &&
-		    mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group) ==
-		    fen_info->fi) {
-			return fib4_entry;
-		}
-	}
+	fib4_entry = container_of(fib_node->fib_entry,
+				  struct mlxsw_sp_fib4_entry, common);
+	if (fib4_entry->tb_id == fen_info->tb_id &&
+	    fib4_entry->tos == fen_info->tos &&
+	    fib4_entry->type == fen_info->type &&
+	    mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group) ==
+	    fen_info->fi)
+		return fib4_entry;
 
 	return NULL;
 }
@@ -4615,7 +4603,6 @@ mlxsw_sp_fib_node_create(struct mlxsw_sp_fib *fib, const void *addr,
 	if (!fib_node)
 		return NULL;
 
-	INIT_LIST_HEAD(&fib_node->entry_list);
 	list_add(&fib_node->list, &fib->node_list);
 	memcpy(fib_node->key.addr, addr, addr_len);
 	fib_node->key.prefix_len = prefix_len;
@@ -4626,18 +4613,9 @@ mlxsw_sp_fib_node_create(struct mlxsw_sp_fib *fib, const void *addr,
 static void mlxsw_sp_fib_node_destroy(struct mlxsw_sp_fib_node *fib_node)
 {
 	list_del(&fib_node->list);
-	WARN_ON(!list_empty(&fib_node->entry_list));
 	kfree(fib_node);
 }
 
-static bool
-mlxsw_sp_fib_node_entry_is_first(const struct mlxsw_sp_fib_node *fib_node,
-				 const struct mlxsw_sp_fib_entry *fib_entry)
-{
-	return list_first_entry(&fib_node->entry_list,
-				struct mlxsw_sp_fib_entry, list) == fib_entry;
-}
-
 static int mlxsw_sp_fib_lpm_tree_link(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_fib_node *fib_node)
 {
@@ -4777,58 +4755,29 @@ static void mlxsw_sp_fib_node_put(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_vr *vr = fib_node->fib->vr;
 
-	if (!list_empty(&fib_node->entry_list))
+	if (fib_node->fib_entry)
 		return;
 	mlxsw_sp_fib_node_fini(mlxsw_sp, fib_node);
 	mlxsw_sp_fib_node_destroy(fib_node);
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
 }
 
-static int mlxsw_sp_fib_node_entry_add(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_fib_entry *fib_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
-
-	/* To prevent packet loss, overwrite the previously offloaded
-	 * entry.
-	 */
-	if (!list_is_singular(&fib_node->entry_list)) {
-		enum mlxsw_reg_ralue_op op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
-		struct mlxsw_sp_fib_entry *n = list_next_entry(fib_entry, list);
-
-		mlxsw_sp_fib_entry_offload_refresh(n, op, 0);
-	}
-
-	return mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
-}
-
-static void mlxsw_sp_fib_node_entry_del(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib_entry *fib_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
-
-	if (!mlxsw_sp_fib_node_entry_is_first(fib_node, fib_entry))
-		return;
-
-	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
-}
-
 static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
 	int err;
 
-	list_add(&fib_entry->list, &fib_node->entry_list);
+	fib_node->fib_entry = fib_entry;
 
-	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, fib_entry);
+	err = mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
 	if (err)
-		goto err_fib_node_entry_add;
+		goto err_fib_entry_update;
 
 	return 0;
 
-err_fib_node_entry_add:
-	list_del(&fib_entry->list);
+err_fib_entry_update:
+	fib_node->fib_entry = NULL;
 	return err;
 }
 
@@ -4836,32 +4785,18 @@ static void
 mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_fib_entry *fib_entry)
 {
-	mlxsw_sp_fib_node_entry_del(mlxsw_sp, fib_entry);
-	list_del(&fib_entry->list);
-}
-
-static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib4_entry *fib4_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
-	struct mlxsw_sp_fib4_entry *replaced;
-
-	if (list_is_singular(&fib_node->entry_list))
-		return;
-
-	/* We inserted the new entry before replaced one */
-	replaced = list_next_entry(fib4_entry, common.list);
+	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
 
-	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &replaced->common);
-	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, replaced);
-	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
+	fib_node->fib_entry = NULL;
 }
 
 static int
 mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 			     const struct fib_entry_notifier_info *fen_info)
 {
-	struct mlxsw_sp_fib4_entry *fib4_entry;
+	struct mlxsw_sp_fib4_entry *fib4_entry, *fib4_replaced;
+	struct mlxsw_sp_fib_entry *replaced;
 	struct mlxsw_sp_fib_node *fib_node;
 	int err;
 
@@ -4884,17 +4819,26 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib4_entry_create;
 	}
 
+	replaced = fib_node->fib_entry;
 	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib4_entry->common);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to link FIB entry to node\n");
 		goto err_fib_node_entry_link;
 	}
 
-	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
+	/* Nothing to replace */
+	if (!replaced)
+		return 0;
+
+	mlxsw_sp_fib_entry_offload_unset(replaced);
+	fib4_replaced = container_of(replaced, struct mlxsw_sp_fib4_entry,
+				     common);
+	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_replaced);
 
 	return 0;
 
 err_fib_node_entry_link:
+	fib_node->fib_entry = replaced;
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 err_fib4_entry_create:
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
@@ -5201,16 +5145,16 @@ mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	 * currently associated with it in the device's table is that
 	 * of the old group. Start using the new one instead.
 	 */
-	err = mlxsw_sp_fib_node_entry_add(mlxsw_sp, &fib6_entry->common);
+	err = mlxsw_sp_fib_entry_update(mlxsw_sp, &fib6_entry->common);
 	if (err)
-		goto err_fib_node_entry_add;
+		goto err_fib_entry_update;
 
 	if (list_empty(&old_nh_grp->fib_list))
 		mlxsw_sp_nexthop6_group_destroy(mlxsw_sp, old_nh_grp);
 
 	return 0;
 
-err_fib_node_entry_add:
+err_fib_entry_update:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
 err_nexthop6_group_get:
 	list_add_tail(&fib6_entry->common.nexthop_group_node,
@@ -5381,6 +5325,7 @@ mlxsw_sp_fib6_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
 	struct mlxsw_sp_fib *fib;
+	struct fib6_info *cmp_rt;
 	struct mlxsw_sp_vr *vr;
 
 	vr = mlxsw_sp_vr_find(mlxsw_sp, rt->fib6_table->tb6_id);
@@ -5394,40 +5339,23 @@ mlxsw_sp_fib6_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	if (!fib_node)
 		return NULL;
 
-	list_for_each_entry(fib6_entry, &fib_node->entry_list, common.list) {
-		struct fib6_info *iter_rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
-
-		if (rt->fib6_table->tb6_id == iter_rt->fib6_table->tb6_id &&
-		    rt->fib6_metric == iter_rt->fib6_metric &&
-		    mlxsw_sp_fib6_entry_rt_find(fib6_entry, rt))
-			return fib6_entry;
-	}
+	fib6_entry = container_of(fib_node->fib_entry,
+				  struct mlxsw_sp_fib6_entry, common);
+	cmp_rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
+	if (rt->fib6_table->tb6_id == cmp_rt->fib6_table->tb6_id &&
+	    rt->fib6_metric == cmp_rt->fib6_metric &&
+	    mlxsw_sp_fib6_entry_rt_find(fib6_entry, rt))
+		return fib6_entry;
 
 	return NULL;
 }
 
-static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib6_entry *fib6_entry)
-{
-	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
-	struct mlxsw_sp_fib6_entry *replaced;
-
-	if (list_is_singular(&fib_node->entry_list))
-		return;
-
-	/* We inserted the new entry before replaced one */
-	replaced = list_next_entry(fib6_entry, common.list);
-
-	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &replaced->common);
-	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, replaced);
-	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-}
-
 static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 					struct fib6_info **rt_arr,
 					unsigned int nrt6)
 {
-	struct mlxsw_sp_fib6_entry *fib6_entry;
+	struct mlxsw_sp_fib6_entry *fib6_entry, *fib6_replaced;
+	struct mlxsw_sp_fib_entry *replaced;
 	struct mlxsw_sp_fib_node *fib_node;
 	struct fib6_info *rt = rt_arr[0];
 	int err;
@@ -5456,15 +5384,24 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
+	replaced = fib_node->fib_entry;
 	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib6_entry->common);
 	if (err)
 		goto err_fib_node_entry_link;
 
-	mlxsw_sp_fib6_entry_replace(mlxsw_sp, fib6_entry);
+	/* Nothing to replace */
+	if (!replaced)
+		return 0;
+
+	mlxsw_sp_fib_entry_offload_unset(replaced);
+	fib6_replaced = container_of(replaced, struct mlxsw_sp_fib6_entry,
+				     common);
+	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_replaced);
 
 	return 0;
 
 err_fib_node_entry_link:
+	fib_node->fib_entry = replaced;
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 err_fib6_entry_create:
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
@@ -5497,13 +5434,13 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 	if (IS_ERR(fib_node))
 		return PTR_ERR(fib_node);
 
-	if (WARN_ON_ONCE(list_empty(&fib_node->entry_list))) {
+	if (WARN_ON_ONCE(!fib_node->fib_entry)) {
 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 		return -EINVAL;
 	}
 
-	fib6_entry = list_first_entry(&fib_node->entry_list,
-				      struct mlxsw_sp_fib6_entry, common.list);
+	fib6_entry = container_of(fib_node->fib_entry,
+				  struct mlxsw_sp_fib6_entry, common);
 	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt_arr,
 					      nrt6);
 	if (err)
@@ -5704,39 +5641,25 @@ static int mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_node *fib_node)
 {
-	struct mlxsw_sp_fib4_entry *fib4_entry, *tmp;
-
-	list_for_each_entry_safe(fib4_entry, tmp, &fib_node->entry_list,
-				 common.list) {
-		bool do_break = &tmp->common.list == &fib_node->entry_list;
+	struct mlxsw_sp_fib4_entry *fib4_entry;
 
-		mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib4_entry->common);
-		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
-		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-		/* Break when entry list is empty and node was freed.
-		 * Otherwise, we'll access freed memory in the next
-		 * iteration.
-		 */
-		if (do_break)
-			break;
-	}
+	fib4_entry = container_of(fib_node->fib_entry,
+				  struct mlxsw_sp_fib4_entry, common);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, fib_node->fib_entry);
+	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
+	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
 
 static void mlxsw_sp_fib6_node_flush(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_node *fib_node)
 {
-	struct mlxsw_sp_fib6_entry *fib6_entry, *tmp;
-
-	list_for_each_entry_safe(fib6_entry, tmp, &fib_node->entry_list,
-				 common.list) {
-		bool do_break = &tmp->common.list == &fib_node->entry_list;
+	struct mlxsw_sp_fib6_entry *fib6_entry;
 
-		mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib6_entry->common);
-		mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
-		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-		if (do_break)
-			break;
-	}
+	fib6_entry = container_of(fib_node->fib_entry,
+				  struct mlxsw_sp_fib6_entry, common);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, fib_node->fib_entry);
+	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
+	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
 }
 
 static void mlxsw_sp_fib_node_flush(struct mlxsw_sp *mlxsw_sp,
-- 
2.24.1

