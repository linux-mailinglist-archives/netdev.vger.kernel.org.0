Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80563CE96
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiK3FM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiK3FMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D4A76158
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF23161A1E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39276C433C1;
        Wed, 30 Nov 2022 05:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785124;
        bh=MPo5hMvigWnDC2IaankXtMunqU4doOTa8KXfWNDs7GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz5uflCKWDXoqNqs7omCT7OE71f4nv3cNUc8sYj9GMwdyGXnvOyAoHmhm5wx5ODzG
         WzJjP89scZx9jS6VIw4BO3NAlnwZYNsqPkkYDNSCYt+KXxy0i8L56kyY0wLG2WsF6G
         MSm12MB59BMqHEczOCiYpx1zAlzCGRTflNEAb3AA4CM5ip5vdwGUAHOgtwW7StTp1F
         ftSWQhdlixg/rNAO8iKC4/qhMSePHaq4Z+GiTXorKvtqM7o1gf822pwh6fD3feQ4Bu
         TdR6cJxzhRJnFaQdKlKPeKdSNzEDptZvfCFPSQPhMlPKqOyQnB3FLrURf5JnC6Oh9B
         c/f7n3sezu4zQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Generalize name of UMR alignment definition
Date:   Tue, 29 Nov 2022 21:11:43 -0800
Message-Id: <20221130051152.479480-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Per the device spec, MLX5_UMR_MTT_ALIGNMENT is good not only for UMR MTT
entries, but for all other entries as well, like KLMs and KSMs.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c                   |  3 +--
 drivers/infiniband/hw/mlx5/umr.c                   | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  6 +++---
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 include/linux/mlx5/device.h                        |  4 ++--
 6 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index bc97958818bb..e6e021af6aa9 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -230,8 +230,7 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 	struct ib_umem_odp *umem_odp =
 		container_of(mni, struct ib_umem_odp, notifier);
 	struct mlx5_ib_mr *mr;
-	const u64 umr_block_mask = (MLX5_UMR_MTT_ALIGNMENT /
-				    sizeof(struct mlx5_mtt)) - 1;
+	const u64 umr_block_mask = MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT - 1;
 	u64 idx = 0, blk_start_idx = 0;
 	u64 invalidations = 0;
 	unsigned long start;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index d5105b5c9979..029e9536ec28 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -418,7 +418,7 @@ int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 }
 
 #define MLX5_MAX_UMR_CHUNK                                                     \
-	((1 << (MLX5_MAX_UMR_SHIFT + 4)) - MLX5_UMR_MTT_ALIGNMENT)
+	((1 << (MLX5_MAX_UMR_SHIFT + 4)) - MLX5_UMR_FLEX_ALIGNMENT)
 #define MLX5_SPARE_UMR_CHUNK 0x10000
 
 /*
@@ -428,11 +428,11 @@ int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
  */
 static void *mlx5r_umr_alloc_xlt(size_t *nents, size_t ent_size, gfp_t gfp_mask)
 {
-	const size_t xlt_chunk_align = MLX5_UMR_MTT_ALIGNMENT / ent_size;
+	const size_t xlt_chunk_align = MLX5_UMR_FLEX_ALIGNMENT / ent_size;
 	size_t size;
 	void *res = NULL;
 
-	static_assert(PAGE_SIZE % MLX5_UMR_MTT_ALIGNMENT == 0);
+	static_assert(PAGE_SIZE % MLX5_UMR_FLEX_ALIGNMENT == 0);
 
 	/*
 	 * MLX5_IB_UPD_XLT_ATOMIC doesn't signal an atomic context just that the
@@ -666,7 +666,7 @@ int mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags)
 	}
 
 	final_size = (void *)cur_mtt - (void *)mtt;
-	sg.length = ALIGN(final_size, MLX5_UMR_MTT_ALIGNMENT);
+	sg.length = ALIGN(final_size, MLX5_UMR_FLEX_ALIGNMENT);
 	memset(cur_mtt, 0, sg.length - final_size);
 	mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
 
@@ -690,7 +690,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	int desc_size = (flags & MLX5_IB_UPD_XLT_INDIRECT)
 			       ? sizeof(struct mlx5_klm)
 			       : sizeof(struct mlx5_mtt);
-	const int page_align = MLX5_UMR_MTT_ALIGNMENT / desc_size;
+	const int page_align = MLX5_UMR_FLEX_ALIGNMENT / desc_size;
 	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	const int page_mask = page_align - 1;
@@ -711,7 +711,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	if (WARN_ON(!mr->umem->is_odp))
 		return -EINVAL;
 
-	/* UMR copies MTTs in units of MLX5_UMR_MTT_ALIGNMENT bytes,
+	/* UMR copies MTTs in units of MLX5_UMR_FLEX_ALIGNMENT bytes,
 	 * so we need to align the offset and length accordingly
 	 */
 	if (idx & page_mask) {
@@ -748,7 +748,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		mlx5_odp_populate_xlt(xlt, idx, npages, mr, flags);
 		dma_sync_single_for_device(ddev, sg.addr, sg.length,
 					   DMA_TO_DEVICE);
-		sg.length = ALIGN(size_to_map, MLX5_UMR_MTT_ALIGNMENT);
+		sg.length = ALIGN(size_to_map, MLX5_UMR_FLEX_ALIGNMENT);
 
 		if (pages_mapped + pages_iter >= pages_to_map)
 			mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff5b302531d5..3cad59ac1b48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -103,11 +103,11 @@ struct page_pool;
  * size actually used at runtime, but it's not a problem when calculating static
  * array sizes.
  */
-#define MLX5_UMR_MAX_MTT_SPACE \
+#define MLX5_UMR_MAX_FLEX_SPACE \
 	(ALIGN_DOWN(MLX5_SEND_WQE_MAX_SIZE - sizeof(struct mlx5e_umr_wqe), \
-		    MLX5_UMR_MTT_ALIGNMENT))
+		    MLX5_UMR_FLEX_ALIGNMENT))
 #define MLX5_MPWRQ_MAX_PAGES_PER_WQE \
-	rounddown_pow_of_two(MLX5_UMR_MAX_MTT_SPACE / sizeof(struct mlx5_mtt))
+	rounddown_pow_of_two(MLX5_UMR_MAX_FLEX_SPACE / sizeof(struct mlx5_mtt))
 
 #define MLX5E_MAX_RQ_NUM_MTTS	\
 	(ALIGN_DOWN(U16_MAX, 4) * 2) /* Fits into u16 and aligned by WQEBB. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9ec9662d1d0b..585bdc8383ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -107,7 +107,7 @@ u8 mlx5e_mpwrq_log_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
 	/* Keep in sync with MLX5_MPWRQ_MAX_PAGES_PER_WQE. */
 	max_wqe_size = mlx5e_get_max_sq_aligned_wqebbs(mdev) * MLX5_SEND_WQE_BB;
 	max_pages_per_wqe = ALIGN_DOWN(max_wqe_size - sizeof(struct mlx5e_umr_wqe),
-				       MLX5_UMR_MTT_ALIGNMENT) / umr_entry_size;
+				       MLX5_UMR_FLEX_ALIGNMENT) / umr_entry_size;
 	max_log_mpwqe_size = ilog2(max_pages_per_wqe) + page_shift;
 
 	WARN_ON_ONCE(max_log_mpwqe_size < MLX5E_ORDER2_MAX_PACKET_MTU);
@@ -146,7 +146,7 @@ u16 mlx5e_mpwrq_umr_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
 	u16 umr_wqe_sz;
 
 	umr_wqe_sz = sizeof(struct mlx5e_umr_wqe) +
-		ALIGN(pages_per_wqe * umr_entry_size, MLX5_UMR_MTT_ALIGNMENT);
+		ALIGN(pages_per_wqe * umr_entry_size, MLX5_UMR_FLEX_ALIGNMENT);
 
 	WARN_ON_ONCE(DIV_ROUND_UP(umr_wqe_sz, MLX5_SEND_WQE_DS) > MLX5_WQE_CTRL_DS_MASK);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 217c8a478977..199387c6bf16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -208,7 +208,7 @@ static u16 mlx5e_mpwrq_umr_octowords(u32 entries, enum mlx5e_mpwrq_umr_mode umr_
 	u8 umr_entry_size = mlx5e_mpwrq_umr_entry_size(umr_mode);
 	u32 sz;
 
-	sz = ALIGN(entries * umr_entry_size, MLX5_UMR_MTT_ALIGNMENT);
+	sz = ALIGN(entries * umr_entry_size, MLX5_UMR_FLEX_ALIGNMENT);
 
 	return sz / MLX5_OCTWORD;
 }
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index ecf840e2989b..a02f779f5c5b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -291,8 +291,8 @@ enum {
 };
 
 #define MLX5_UMR_KLM_ALIGNMENT 4
-#define MLX5_UMR_MTT_ALIGNMENT 0x40
-#define MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_MTT_ALIGNMENT / sizeof(struct mlx5_mtt))
+#define MLX5_UMR_FLEX_ALIGNMENT 0x40
+#define MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_FLEX_ALIGNMENT / sizeof(struct mlx5_mtt))
 
 #define MLX5_USER_INDEX_LEN (MLX5_FLD_SZ_BYTES(qpc, user_index) * 8)
 
-- 
2.38.1

