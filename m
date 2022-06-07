Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F241653FDB3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiFGLkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243094AbiFGLkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:40:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F036AB0D22;
        Tue,  7 Jun 2022 04:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B83961697;
        Tue,  7 Jun 2022 11:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CEEC34115;
        Tue,  7 Jun 2022 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654602036;
        bh=u3QWuNKM6ujkQwvkjnzAZhzicWJ/ig079ruFYRoz3es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwYHps0844TSAzc+4MAFFlnhwLuoytgIvNF/8FVJVml+tSJpJS1kv7UVRV6knhqnd
         u6JXFFANzGyaWvVAkRyF9zE1+lsnw8N02IyCQrU3ugdK8dxn9jB1g9syeRxLDdMJDI
         XHkqXAfzv8XgV2gbVz9lslV8gZXpmwhHQYppPSiYegKP58DoPTZi4bImKXkSUCgyzA
         4TWUx8SvwMI5SguZs+2tnAbheevM3HKTCxklOE7on4xN998Zek93G7qvlcXL69ejfc
         mLNsrKGvkwe4no76kxaLt7Z9JUeJHiyPeUDof83PjsibYer4PjXfa4vDQtLk/Vio4d
         egSD/U+/2VMpQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 5/5] RDMA/mlx5: Rename the mkey cache variables and functions
Date:   Tue,  7 Jun 2022 14:40:15 +0300
Message-Id: <d8e3b4e6f73cc9b7db7af71e2abe6ec9fb82e61c.1654601897.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654601897.git.leonro@nvidia.com>
References: <cover.1654601897.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

After replacing the MR cache with an Mkey cache, rename the variables
and functions to fit the new meaning.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |  4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 +++----
 drivers/infiniband/hw/mlx5/mr.c      | 58 ++++++++++++++--------------
 drivers/infiniband/hw/mlx5/odp.c     |  2 +-
 include/linux/mlx5/driver.h          |  6 +--
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b68fddeac0f1..a174a0eee8dc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4002,7 +4002,7 @@ static void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	err = mlx5_mr_cache_cleanup(dev);
+	err = mlx5_mkey_cache_cleanup(dev);
 	if (err)
 		mlx5_ib_warn(dev, "mr cache cleanup failed\n");
 
@@ -4022,7 +4022,7 @@ static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mlx5_mr_cache_init(dev);
+	ret = mlx5_mkey_cache_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
 		mlx5r_umr_resource_cleanup(dev);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index de0375a46b36..bbbd718e67c5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -758,9 +758,9 @@ struct mlx5r_async_create_mkey {
 	u32 mkey;
 };
 
-struct mlx5_mr_cache {
+struct mlx5_mkey_cache {
 	struct workqueue_struct *wq;
-	struct mlx5_cache_ent	ent[MAX_MR_CACHE_ENTRIES];
+	struct mlx5_cache_ent	ent[MAX_MKEY_CACHE_ENTRIES];
 	struct dentry		*root;
 	unsigned long		last_add;
 };
@@ -1059,7 +1059,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_resources	devr;
 
 	atomic_t			mkey_var;
-	struct mlx5_mr_cache		cache;
+	struct mlx5_mkey_cache		cache;
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
@@ -1304,8 +1304,8 @@ void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 			  u64 access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev);
 
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 				       struct mlx5_cache_ent *ent,
@@ -1333,7 +1333,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq);
 void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent);
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent);
 void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 			   struct mlx5_ib_mr *mr, int flags);
 
@@ -1352,7 +1352,7 @@ static inline int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev,
 static inline void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev) {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
-static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
+static inline void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent) {}
 static inline void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 					 struct mlx5_ib_mr *mr, int flags) {}
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9ffe308c2bdf..4cf14b5326ef 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -119,7 +119,7 @@ static int mlx5_ib_create_mkey_cb(struct mlx5r_async_create_mkey *async_create)
 				&async_create->cb_work);
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev);
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev);
 static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent);
 
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
@@ -506,11 +506,11 @@ static const struct file_operations limit_fops = {
 	.read	= limit_read,
 };
 
-static bool someone_adding(struct mlx5_mr_cache *cache)
+static bool someone_adding(struct mlx5_mkey_cache *cache)
 {
 	unsigned int i;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &cache->ent[i];
 		bool ret;
 
@@ -560,7 +560,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 static void __cache_work_func(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_dev *dev = ent->dev;
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	int err;
 
 	xa_lock_irq(&ent->mkeys);
@@ -670,7 +670,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	return mr;
 }
 
-static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
+static void mlx5_mkey_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_cache_ent *ent = mr->mmkey.cache_ent;
 
@@ -683,7 +683,7 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 
 static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
 	u32 mkey;
 
@@ -698,7 +698,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	xa_unlock_irq(&ent->mkeys);
 }
 
-static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
@@ -707,9 +707,9 @@ static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 	dev->cache.root = NULL;
 }
 
-static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	struct dentry *dir;
 	int i;
@@ -719,7 +719,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 
 	cache->root = debugfs_create_dir("mr_cache", mlx5_debugfs_get_dev_root(dev->mdev));
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		sprintf(ent->name, "%d", ent->order);
 		dir = debugfs_create_dir(ent->name, cache->root);
@@ -737,9 +737,9 @@ static void delay_time_func(struct timer_list *t)
 	WRITE_ONCE(dev->fill_delay, 0);
 }
 
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	int i;
 
@@ -752,7 +752,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 		ent->order = i + 2;
@@ -761,12 +761,12 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 
-		if (i > MR_CACHE_LAST_STD_ENTRY) {
-			mlx5_odp_init_mr_cache_entry(ent);
+		if (i > MKEY_CACHE_LAST_STD_ENTRY) {
+			mlx5_odp_init_mkey_cache_entry(ent);
 			continue;
 		}
 
-		if (ent->order > mr_cache_max_order(dev))
+		if (ent->order > mkey_cache_max_order(dev))
 			continue;
 
 		ent->page = PAGE_SHIFT;
@@ -783,19 +783,19 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		xa_unlock_irq(&ent->mkeys);
 	}
 
-	mlx5_mr_cache_debugfs_init(dev);
+	mlx5_mkey_cache_debugfs_init(dev);
 
 	return 0;
 }
 
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 {
 	unsigned int i;
 
 	if (!dev->cache.wq)
 		return 0;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &dev->cache.ent[i];
 
 		xa_lock_irq(&ent->mkeys);
@@ -804,10 +804,10 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 		cancel_delayed_work_sync(&ent->dwork);
 	}
 
-	mlx5_mr_cache_debugfs_cleanup(dev);
+	mlx5_mkey_cache_debugfs_cleanup(dev);
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++)
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++)
 		clean_keys(dev, i);
 
 	destroy_workqueue(dev->cache.wq);
@@ -874,22 +874,22 @@ static int get_octo_len(u64 addr, u64 len, int page_shift)
 	return (npages + 1) / 2;
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev)
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		return MR_CACHE_LAST_STD_ENTRY + 2;
+		return MKEY_CACHE_LAST_STD_ENTRY + 2;
 	return MLX5_MAX_UMR_SHIFT;
 }
 
-static struct mlx5_cache_ent *mr_cache_ent_from_order(struct mlx5_ib_dev *dev,
-						      unsigned int order)
+static struct mlx5_cache_ent *mkey_cache_ent_from_order(struct mlx5_ib_dev *dev,
+							unsigned int order)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 
 	if (order < cache->ent[0].order)
 		return &cache->ent[0];
 	order = order - cache->ent[0].order;
-	if (order > MR_CACHE_LAST_STD_ENTRY)
+	if (order > MKEY_CACHE_LAST_STD_ENTRY)
 		return NULL;
 	return &cache->ent[order];
 }
@@ -932,7 +932,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 						     0, iova);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
-	ent = mr_cache_ent_from_order(
+	ent = mkey_cache_ent_from_order(
 		dev, order_base_2(ib_umem_num_dma_blocks(umem, page_size)));
 	/*
 	 * Matches access in alloc_cache_mr(). If the MR can't come from the
@@ -1640,7 +1640,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	if (mr->mmkey.cache_ent)
-		mlx5_mr_cache_free(dev, mr);
+		mlx5_mkey_cache_free(dev, mr);
 	else
 		mlx5_free_priv_descs(mr);
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 84da5674e1ab..e305bf1dc6c2 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1588,7 +1588,7 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	return err;
 }
 
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5040cd774c5a..aeaedb985c1f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -727,10 +727,10 @@ enum {
 };
 
 enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
+	MKEY_CACHE_LAST_STD_ENTRY = 20,
 	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
+	MAX_MKEY_CACHE_ENTRIES
 };
 
 struct mlx5_profile {
@@ -739,7 +739,7 @@ struct mlx5_profile {
 	struct {
 		int	size;
 		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
+	} mr_cache[MAX_MKEY_CACHE_ENTRIES];
 };
 
 struct mlx5_hca_cap {
-- 
2.36.1

