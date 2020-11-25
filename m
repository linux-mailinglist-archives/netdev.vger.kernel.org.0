Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FCF2C487D
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgKYTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:56 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47871 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgKYTf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 018555C00D8;
        Wed, 25 Nov 2020 14:35:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=PhvEityuHuYGYXVjZjbpZbhBrqjCniG240NxeI8BSqc=; b=UOiclr5h
        SQqNrgZTYqOqhe/cMdTQ3ZenX5uesNYHsmHuQST4bQoXMeTFiHQiqwTJUEB9gF07
        sManQWreimMi5PmEva0osUd/8cMIRPF1hK/7/7PcECwQa0SP7031d6ReBclnuxYe
        7nY2kIOSEnZzWtSEpL23SHdh/fVn6b3GjZLiOr/qMAA8B0aED76Ayica6EZAP3iS
        pyFBiNiLpgOEd+GQ7MmvTb2SfZWsXTNGuKvDbKSBxvpjlu3DId3RmBFsN3+r7dYW
        vkUXTbY1uIWYgbplUoPeDbD4iVXEbTsV/sWKsmcYaDewaT2qPLSxJVWgRUng9lRC
        +hnKJrbQuWcJFg==
X-ME-Sender: <xms:GbK-X6VDy5JQrU3RfGXaqopnwHcOipVax3vaVwGeaKHZHv-hTCiKlw>
    <xme:GbK-X2knZNlYiKxix_KhRxrp5eJOnwZAottoJJm05pE7-MlYShWBS_BO7jzZG-jP9
    -Eucyl17ljguhc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GbK-X-Z1OeXH-NsRPfhD6Jmss-2qXQ-AVfc3Ov5Qcop8SuIV_CZILQ>
    <xmx:GbK-XxVDT6L0szN6Zz4w0CTiCJVs_QpWz5yD3cpMjGidkhcOq6Bw9A>
    <xmx:GbK-X0kypJsv_KtTnwFq1tBxvG8gEZyRyK_JOghmjzZu-41CBh8QGw>
    <xmx:GbK-X-hmjYnKTDQkZUIWtCIoH7coiLrAeD3cxiRY7U8QV3d4JSJkvg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A02C328005D;
        Wed, 25 Nov 2020 14:35:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_router: Track nexthop group virtual router membership
Date:   Wed, 25 Nov 2020 21:35:04 +0200
Message-Id: <20201125193505.1052466-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
References: <20201125193505.1052466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

For each nexthop group, track in which virtual routers (VRs) the group is
used. This is going to be used by the next patch to perform a more
efficient adjacency index update whenever the group's adjacency index
changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 164 ++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 316182d6c1e3..9e3dfd2f7f45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2889,6 +2889,18 @@ struct mlxsw_sp_nexthop_group_info {
 #define nh_rif	nexthops[0].rif
 };
 
+struct mlxsw_sp_nexthop_group_vr_key {
+	u16 vr_id;
+	enum mlxsw_sp_l3proto proto;
+};
+
+struct mlxsw_sp_nexthop_group_vr_entry {
+	struct list_head list; /* member in vr_list */
+	struct rhash_head ht_node; /* member in vr_ht */
+	refcount_t ref_count;
+	struct mlxsw_sp_nexthop_group_vr_key key;
+};
+
 struct mlxsw_sp_nexthop_group {
 	struct rhash_head ht_node;
 	struct list_head fib_list; /* list of fib entries that use this group */
@@ -2901,6 +2913,8 @@ struct mlxsw_sp_nexthop_group {
 		} obj;
 	};
 	struct mlxsw_sp_nexthop_group_info *nhgi;
+	struct list_head vr_list;
+	struct rhashtable vr_ht;
 	enum mlxsw_sp_nexthop_group_type type;
 	bool can_destroy;
 };
@@ -3017,6 +3031,96 @@ bool mlxsw_sp_nexthop_is_discard(const struct mlxsw_sp_nexthop *nh)
 	return nh->discard;
 }
 
+static const struct rhashtable_params mlxsw_sp_nexthop_group_vr_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_nexthop_group_vr_entry, key),
+	.head_offset = offsetof(struct mlxsw_sp_nexthop_group_vr_entry, ht_node),
+	.key_len = sizeof(struct mlxsw_sp_nexthop_group_vr_key),
+	.automatic_shrinking = true,
+};
+
+static struct mlxsw_sp_nexthop_group_vr_entry *
+mlxsw_sp_nexthop_group_vr_entry_lookup(struct mlxsw_sp_nexthop_group *nh_grp,
+				       const struct mlxsw_sp_fib *fib)
+{
+	struct mlxsw_sp_nexthop_group_vr_key key;
+
+	memset(&key, 0, sizeof(key));
+	key.vr_id = fib->vr->id;
+	key.proto = fib->proto;
+	return rhashtable_lookup_fast(&nh_grp->vr_ht, &key,
+				      mlxsw_sp_nexthop_group_vr_ht_params);
+}
+
+static int
+mlxsw_sp_nexthop_group_vr_entry_create(struct mlxsw_sp_nexthop_group *nh_grp,
+				       const struct mlxsw_sp_fib *fib)
+{
+	struct mlxsw_sp_nexthop_group_vr_entry *vr_entry;
+	int err;
+
+	vr_entry = kzalloc(sizeof(*vr_entry), GFP_KERNEL);
+	if (!vr_entry)
+		return -ENOMEM;
+
+	vr_entry->key.vr_id = fib->vr->id;
+	vr_entry->key.proto = fib->proto;
+	refcount_set(&vr_entry->ref_count, 1);
+
+	err = rhashtable_insert_fast(&nh_grp->vr_ht, &vr_entry->ht_node,
+				     mlxsw_sp_nexthop_group_vr_ht_params);
+	if (err)
+		goto err_hashtable_insert;
+
+	list_add(&vr_entry->list, &nh_grp->vr_list);
+
+	return 0;
+
+err_hashtable_insert:
+	kfree(vr_entry);
+	return err;
+}
+
+static void
+mlxsw_sp_nexthop_group_vr_entry_destroy(struct mlxsw_sp_nexthop_group *nh_grp,
+					struct mlxsw_sp_nexthop_group_vr_entry *vr_entry)
+{
+	list_del(&vr_entry->list);
+	rhashtable_remove_fast(&nh_grp->vr_ht, &vr_entry->ht_node,
+			       mlxsw_sp_nexthop_group_vr_ht_params);
+	kfree(vr_entry);
+}
+
+static int
+mlxsw_sp_nexthop_group_vr_link(struct mlxsw_sp_nexthop_group *nh_grp,
+			       const struct mlxsw_sp_fib *fib)
+{
+	struct mlxsw_sp_nexthop_group_vr_entry *vr_entry;
+
+	vr_entry = mlxsw_sp_nexthop_group_vr_entry_lookup(nh_grp, fib);
+	if (vr_entry) {
+		refcount_inc(&vr_entry->ref_count);
+		return 0;
+	}
+
+	return mlxsw_sp_nexthop_group_vr_entry_create(nh_grp, fib);
+}
+
+static void
+mlxsw_sp_nexthop_group_vr_unlink(struct mlxsw_sp_nexthop_group *nh_grp,
+				 const struct mlxsw_sp_fib *fib)
+{
+	struct mlxsw_sp_nexthop_group_vr_entry *vr_entry;
+
+	vr_entry = mlxsw_sp_nexthop_group_vr_entry_lookup(nh_grp, fib);
+	if (WARN_ON_ONCE(!vr_entry))
+		return;
+
+	if (!refcount_dec_and_test(&vr_entry->ref_count))
+		return;
+
+	mlxsw_sp_nexthop_group_vr_entry_destroy(nh_grp, vr_entry);
+}
+
 struct mlxsw_sp_nexthop_group_cmp_arg {
 	enum mlxsw_sp_nexthop_group_type type;
 	union {
@@ -4379,6 +4483,11 @@ mlxsw_sp_nexthop_obj_group_create(struct mlxsw_sp *mlxsw_sp,
 	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&nh_grp->vr_list);
+	err = rhashtable_init(&nh_grp->vr_ht,
+			      &mlxsw_sp_nexthop_group_vr_ht_params);
+	if (err)
+		goto err_nexthop_group_vr_ht_init;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ;
 	nh_grp->obj.id = info->id;
@@ -4392,6 +4501,8 @@ mlxsw_sp_nexthop_obj_group_create(struct mlxsw_sp *mlxsw_sp,
 	return nh_grp;
 
 err_nexthop_group_info_init:
+	rhashtable_destroy(&nh_grp->vr_ht);
+err_nexthop_group_vr_ht_init:
 	kfree(nh_grp);
 	return ERR_PTR(err);
 }
@@ -4404,6 +4515,8 @@ mlxsw_sp_nexthop_obj_group_destroy(struct mlxsw_sp *mlxsw_sp,
 		return;
 	mlxsw_sp_nexthop_obj_group_info_fini(mlxsw_sp, nh_grp);
 	WARN_ON_ONCE(!list_empty(&nh_grp->fib_list));
+	WARN_ON_ONCE(!list_empty(&nh_grp->vr_list));
+	rhashtable_destroy(&nh_grp->vr_ht);
 	kfree(nh_grp);
 }
 
@@ -4652,6 +4765,11 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&nh_grp->vr_list);
+	err = rhashtable_init(&nh_grp->vr_ht,
+			      &mlxsw_sp_nexthop_group_vr_ht_params);
+	if (err)
+		goto err_nexthop_group_vr_ht_init;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
 	nh_grp->ipv4.fi = fi;
@@ -4673,6 +4791,8 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	mlxsw_sp_nexthop4_group_info_fini(mlxsw_sp, nh_grp);
 err_nexthop_group_info_init:
 	fib_info_put(fi);
+	rhashtable_destroy(&nh_grp->vr_ht);
+err_nexthop_group_vr_ht_init:
 	kfree(nh_grp);
 	return ERR_PTR(err);
 }
@@ -4686,6 +4806,8 @@ mlxsw_sp_nexthop4_group_destroy(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
 	mlxsw_sp_nexthop4_group_info_fini(mlxsw_sp, nh_grp);
 	fib_info_put(nh_grp->ipv4.fi);
+	WARN_ON_ONCE(!list_empty(&nh_grp->vr_list));
+	rhashtable_destroy(&nh_grp->vr_ht);
 	kfree(nh_grp);
 }
 
@@ -5380,6 +5502,11 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop4_group_get;
 
+	err = mlxsw_sp_nexthop_group_vr_link(fib_entry->nh_group,
+					     fib_node->fib);
+	if (err)
+		goto err_nexthop_group_vr_link;
+
 	err = mlxsw_sp_fib4_entry_type_set(mlxsw_sp, fen_info, fib_entry);
 	if (err)
 		goto err_fib4_entry_type_set;
@@ -5395,6 +5522,8 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return fib4_entry;
 
 err_fib4_entry_type_set:
+	mlxsw_sp_nexthop_group_vr_unlink(fib_entry->nh_group, fib_node->fib);
+err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 err_nexthop4_group_get:
 	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
@@ -5406,8 +5535,12 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
+	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
+
 	fib_info_put(fib4_entry->fi);
 	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
+	mlxsw_sp_nexthop_group_vr_unlink(fib4_entry->common.nh_group,
+					 fib_node->fib);
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib_entry_priv_put(fib4_entry->common.priv);
 	kfree(fib4_entry);
@@ -5984,6 +6117,11 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&nh_grp->vr_list);
+	err = rhashtable_init(&nh_grp->vr_ht,
+			      &mlxsw_sp_nexthop_group_vr_ht_params);
+	if (err)
+		goto err_nexthop_group_vr_ht_init;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
 
@@ -6002,6 +6140,8 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 err_nexthop_group_insert:
 	mlxsw_sp_nexthop6_group_info_fini(mlxsw_sp, nh_grp);
 err_nexthop_group_info_init:
+	rhashtable_destroy(&nh_grp->vr_ht);
+err_nexthop_group_vr_ht_init:
 	kfree(nh_grp);
 	return ERR_PTR(err);
 }
@@ -6014,6 +6154,8 @@ mlxsw_sp_nexthop6_group_destroy(struct mlxsw_sp *mlxsw_sp,
 		return;
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
 	mlxsw_sp_nexthop6_group_info_fini(mlxsw_sp, nh_grp);
+	WARN_ON_ONCE(!list_empty(&nh_grp->vr_list));
+	rhashtable_destroy(&nh_grp->vr_ht);
 	kfree(nh_grp);
 }
 
@@ -6073,8 +6215,10 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	struct mlxsw_sp_nexthop_group *old_nh_grp = fib6_entry->common.nh_group;
+	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
 	int err;
 
+	mlxsw_sp_nexthop_group_vr_unlink(old_nh_grp, fib_node->fib);
 	fib6_entry->common.nh_group = NULL;
 	list_del(&fib6_entry->common.nexthop_group_node);
 
@@ -6082,6 +6226,11 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop6_group_get;
 
+	err = mlxsw_sp_nexthop_group_vr_link(fib6_entry->common.nh_group,
+					     fib_node->fib);
+	if (err)
+		goto err_nexthop_group_vr_link;
+
 	/* In case this entry is offloaded, then the adjacency index
 	 * currently associated with it in the device's table is that
 	 * of the old group. Start using the new one instead.
@@ -6097,11 +6246,15 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_fib_entry_update:
+	mlxsw_sp_nexthop_group_vr_unlink(fib6_entry->common.nh_group,
+					 fib_node->fib);
+err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
 err_nexthop6_group_get:
 	list_add_tail(&fib6_entry->common.nexthop_group_node,
 		      &old_nh_grp->fib_list);
 	fib6_entry->common.nh_group = old_nh_grp;
+	mlxsw_sp_nexthop_group_vr_link(old_nh_grp, fib_node->fib);
 	return err;
 }
 
@@ -6233,12 +6386,19 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop6_group_get;
 
+	err = mlxsw_sp_nexthop_group_vr_link(fib_entry->nh_group,
+					     fib_node->fib);
+	if (err)
+		goto err_nexthop_group_vr_link;
+
 	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
 
 	fib_entry->fib_node = fib_node;
 
 	return fib6_entry;
 
+err_nexthop_group_vr_link:
+	mlxsw_sp_nexthop6_group_put(mlxsw_sp, fib_entry);
 err_nexthop6_group_get:
 	i = nrt6;
 err_rt6_create:
@@ -6258,6 +6418,10 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib6_entry *fib6_entry)
 {
+	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
+
+	mlxsw_sp_nexthop_group_vr_unlink(fib6_entry->common.nh_group,
+					 fib_node->fib);
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_rt_destroy_all(fib6_entry);
 	WARN_ON(fib6_entry->nrt6);
-- 
2.28.0

