Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5953B2FCA9F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 06:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbhATFNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 00:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbhATFDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 00:03:37 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6378C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 21:02:50 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i63so6690632pfg.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 21:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vcT3HqhVd3zmxQxZ0ZH8WNdz5Yc/PF/X6IYKRYNvs0k=;
        b=ppFgMsDRAAaQMHICyfAfSeYbbzeUIuiUlH2RDkX5dYrxieJLxD/wbSKBFBGdMc9re1
         4Tzx4aKHynVo/tgVEYzIOe25gyGOVPgYgRAVriGtaXi9+hTwPoWIENlL6J/9Dn3v/fUd
         gPhYwKfFVHdjAc+IWxacRuS3jN8zUt2FIvyIqYopUXwn4x2Flmudjn8TLOd5rSmw4KeP
         Kia4GBx3E1u/BlX1ZLfRmOGKDkPJxFxasuUKKg03ojS89xPojAPA57DyKpjKePTyHQaL
         CzgmBfWi3g9SvLqd3wzkuhPohAE+9cwZUFnWt+NAF54bpnKsUFTO8yYJ3AKmFk/kNsaH
         yS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vcT3HqhVd3zmxQxZ0ZH8WNdz5Yc/PF/X6IYKRYNvs0k=;
        b=T0Xk3Vpp4JbqbzcL5P3+NetUDApEmSpMkJu2I6N5hT86BgdU6zGb3Sc1Ac8JnXsOCY
         kNhFfsznQFeTRWXBenoFrWd9c2DFb5ZPEH5qkcdRwf2iMFd7EmSTmPCl1ppLdFbi5EqS
         T90eqH/e3qncE2xwOC+/ryss7lL4DSE5pFd/IqzmfkgpiA+M8VuTL2kK/kc3vvO9jwYg
         Ab8GlI+BvuX7gz0Q1m89OoJKQduuFIUZD8Bjb+wgdT3coHGZd6W2FWaF28VXZg5LW1+b
         k4my/EUChPk52S/6cGO7Y+YJ65KBCjoJkEfFkeZQbECUo5u1i8HjhsJnMmhqUZSLBWAh
         CvNw==
X-Gm-Message-State: AOAM531YTKixDpMbOtbn5J9yrWamFJLoO94FEGmdA7hCJY/Lzo+vAKd/
        icvO4Br84aVvbILRrepfc24=
X-Google-Smtp-Source: ABdhPJzKUNo7m0sHyGyOab4FAcn4snSkXYXoW9ReNyLBxpnzKkBdJyPgILYaZY266+DHwiii/7GfVA==
X-Received: by 2002:a65:6152:: with SMTP id o18mr7722362pgv.392.1611118970132;
        Tue, 19 Jan 2021 21:02:50 -0800 (PST)
Received: from hyd1358.marvell.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id y12sm701814pfp.166.2021.01.19.21.02.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jan 2021 21:02:49 -0800 (PST)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        haokexin@gmail.com
Cc:     gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers"
Date:   Wed, 20 Jan 2021 10:32:35 +0530
Message-Id: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Octeontx2 hardware needs buffer pointers which are 128 byte
aligned. napi_alloc_frag() returns buffer pointers which are
not 128 byte aligned sometimes because if napi_alloc_skb() is
called when a packet is received then subsequent napi_alloc_frag()
returns buffer which is not 128 byte aligned and those buffers
cannot be issued to NPA hardware. Hence reverting this commit.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 52 +++++++++++++---------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 15 ++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  4 ++
 4 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bdfa2e2..921cd86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -483,35 +483,40 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 		     (pfvf->hw.cq_ecount_wait - 1));
 }
 
-dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
+dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			   gfp_t gfp)
 {
 	dma_addr_t iova;
-	u8 *buf;
 
-	buf = napi_alloc_frag(pool->rbsize);
-	if (unlikely(!buf))
+	/* Check if request can be accommodated in previous allocated page */
+	if (pool->page && ((pool->page_offset + pool->rbsize) <=
+	    (PAGE_SIZE << pool->rbpage_order))) {
+		pool->pageref++;
+		goto ret;
+	}
+
+	otx2_get_page(pool);
+
+	/* Allocate a new page */
+	pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
+				 pool->rbpage_order);
+	if (unlikely(!pool->page))
 		return -ENOMEM;
 
-	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
-				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
-	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
-		page_frag_free(buf);
+	pool->page_offset = 0;
+ret:
+	iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
+				      pool->rbsize, DMA_FROM_DEVICE);
+	if (!iova) {
+		if (!pool->page_offset)
+			__free_pages(pool->page, pool->rbpage_order);
+		pool->page = NULL;
 		return -ENOMEM;
 	}
-
+	pool->page_offset += pool->rbsize;
 	return iova;
 }
 
-static dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
-{
-	dma_addr_t addr;
-
-	local_bh_disable();
-	addr = __otx2_alloc_rbuf(pfvf, pool);
-	local_bh_enable();
-	return addr;
-}
-
 void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -913,7 +918,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	free_ptrs = cq->pool_ptrs;
 
 	while (cq->pool_ptrs) {
-		bufptr = otx2_alloc_rbuf(pfvf, rbpool);
+		bufptr = otx2_alloc_rbuf(pfvf, rbpool, GFP_KERNEL);
 		if (bufptr <= 0) {
 			/* Schedule a WQ if we fails to free atleast half of the
 			 * pointers else enable napi for this RQ.
@@ -1172,6 +1177,7 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 		return err;
 
 	pool->rbsize = buf_size;
+	pool->rbpage_order = get_order(buf_size);
 
 	/* Initialize this pool's context via AF */
 	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
@@ -1259,12 +1265,13 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			return -ENOMEM;
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool);
+			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
 			if (bufptr <= 0)
 				return bufptr;
 			otx2_aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
+		otx2_get_page(pool);
 	}
 
 	return 0;
@@ -1310,12 +1317,13 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			bufptr = otx2_alloc_rbuf(pfvf, pool);
+			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
 			if (bufptr <= 0)
 				return bufptr;
 			otx2_aura_freeptr(pfvf, pool_id,
 					  bufptr + OTX2_HEAD_ROOM);
 		}
+		otx2_get_page(pool);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 143ae04..f670da9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -491,6 +491,18 @@ static inline void otx2_aura_freeptr(struct otx2_nic *pfvf,
 		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
 }
 
+/* Update page ref count */
+static inline void otx2_get_page(struct otx2_pool *pool)
+{
+	if (!pool->page)
+		return;
+
+	if (pool->pageref)
+		page_ref_add(pool->page, pool->pageref);
+	pool->pageref = 0;
+	pool->page = NULL;
+}
+
 static inline int otx2_get_pool_idx(struct otx2_nic *pfvf, int type, int idx)
 {
 	if (type == AURA_NIX_SQ)
@@ -636,7 +648,8 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
 int otx2_txschq_stop(struct otx2_nic *pfvf);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
-dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool);
+dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			   gfp_t gfp);
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index d0e2541..7774d9a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -333,7 +333,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
-		bufptr = __otx2_alloc_rbuf(pfvf, cq->rbpool);
+		bufptr = otx2_alloc_rbuf(pfvf, cq->rbpool, GFP_ATOMIC);
 		if (unlikely(bufptr <= 0)) {
 			struct refill_work *work;
 			struct delayed_work *dwork;
@@ -351,6 +351,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+	otx2_get_page(cq->rbpool);
 
 	return processed_cqe;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 73af156..9cd20c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -114,7 +114,11 @@ struct otx2_cq_poll {
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
+	u8			rbpage_order;
 	u16			rbsize;
+	u32			page_offset;
+	u16			pageref;
+	struct page		*page;
 };
 
 struct otx2_cq_queue {
-- 
2.7.4

