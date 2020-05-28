Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0671E6B9A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406747AbgE1TsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbgE1Tp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:45:58 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAFC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:45:58 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y9so3859723qvs.4
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mIpeJkQ1ft32l/mRk3zB4nnSLeqmBHNFN+VC9uQ9wwA=;
        b=aIcq6xlzXRx4AnqIstSUvCjy+kGnoObTjzt8JlWcif+bx3b5iNaRlGaQgjqf6Fz5xI
         aCHVwUsVM2xR97NybIqtGhNMEeHoN6ySSxNJtO2FT9Iut3BZezH0PmcRfO33kNuly67s
         wBdyU0OFetnHQbsaXzGSXHFA08Dgx9u+wSNXft6KGwH4jaWKwJHSFkdXiS19oFhBk2B3
         q+aBGGMZfyF9soIy0fRBQxvKZL3nAoYSMWCtuJ2jBrbs0y+robukIsEPbCSEboVKa55z
         Wzjd8YzSEWXRWkpXT2X8qAPkwZ/sAmT1QU22I6sIjhTlZlNhSy21iH3GC4ZkTNBnP8CM
         pSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mIpeJkQ1ft32l/mRk3zB4nnSLeqmBHNFN+VC9uQ9wwA=;
        b=G07qFd2gHfgi6Tb//Uw4dbTQj6BWLW5w5/CDmJocfkx3AW6RDV0Vk4lFIL4J6ZMfL1
         ehG7DpPuNb5emipW9+lOnR8z9UH9aDmjlMVVxTeYWl+PPSy2QLXgmGQ1EekKnY7PiQ9C
         rts7yn+qJelFuyrMOT3ERD14uWxY6tB9iY/fv8jcLVLnIscpcvSnYwDS7hKnJ3CiF2t2
         Y2JxIdZQ6a81NCkbnb5wCROPQMI7HwhZ78QOt6wTQaTrpA8Bq5aZewxazVYJDqJ8foQE
         2g/VZl98yioLUuO2ufPcueZajyFn0uUlgHl8zb3tIoFQdJKniz8Olj9Tr2fYHuFkQvQ4
         9XUg==
X-Gm-Message-State: AOAM531vRou66iudZi0w7lxZYD+yHz8P4wiLc3YqqOZc50Pvzak5R1D0
        hEqWqfK+faI0U9hZlXS6WKeiwg==
X-Google-Smtp-Source: ABdhPJx/wiVYwSPXHSdzxNEa+92Zq2i1Nvog9kY7h969o1YJ9uO0ISWvlapdD60Bo8cJgencTgFQIA==
X-Received: by 2002:ad4:5843:: with SMTP id de3mr4970293qvb.195.1590695157831;
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id m82sm5614947qke.3.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006gy-3O; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     aron.silverton@oracle.com, Max Gurtovoy <maxg@mellanox.com>,
        oren@mellanox.com, santosh.shilimkar@oracle.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 03/13] RDMA/rds: Remove FMR support for memory registration
Date:   Thu, 28 May 2020 16:45:45 -0300
Message-Id: <3-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

Use FRWR method for memory registration by default and remove the ancient
and unsafe FMR method.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: aron.silverton@oracle.com
Cc: santosh.shilimkar@oracle.com
---
 net/rds/Makefile  |   2 +-
 net/rds/ib.c      |  20 ++--
 net/rds/ib.h      |   2 -
 net/rds/ib_cm.c   |   4 +-
 net/rds/ib_fmr.c  | 269 ----------------------------------------------
 net/rds/ib_frmr.c |   4 +-
 net/rds/ib_mr.h   |  14 +--
 net/rds/ib_rdma.c |  28 ++---
 8 files changed, 21 insertions(+), 322 deletions(-)
 delete mode 100644 net/rds/ib_fmr.c

diff --git a/net/rds/Makefile b/net/rds/Makefile
index e647f9de104a67..8fdc118e292756 100644
--- a/net/rds/Makefile
+++ b/net/rds/Makefile
@@ -7,7 +7,7 @@ rds-y :=	af_rds.o bind.o cong.o connection.o info.o message.o   \
 obj-$(CONFIG_RDS_RDMA) += rds_rdma.o
 rds_rdma-y :=	rdma_transport.o \
 			ib.o ib_cm.o ib_recv.o ib_ring.o ib_send.o ib_stats.o \
-			ib_sysctl.o ib_rdma.o ib_fmr.o ib_frmr.o
+			ib_sysctl.o ib_rdma.o ib_frmr.o
 
 
 obj-$(CONFIG_RDS_TCP) += rds_tcp.o
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 90212ed3edf1c9..6c43b3e4c73618 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -130,13 +130,16 @@ void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
 static int rds_ib_add_one(struct ib_device *device)
 {
 	struct rds_ib_device *rds_ibdev;
-	bool has_fr, has_fmr;
 	int ret;
 
 	/* Only handle IB (no iWARP) devices */
 	if (device->node_type != RDMA_NODE_IB_CA)
 		return -EOPNOTSUPP;
 
+	/* Device must support FRWR */
+	if (!(device->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
+		return -EOPNOTSUPP;
+
 	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
 				 ibdev_to_node(device));
 	if (!rds_ibdev)
@@ -152,11 +155,6 @@ static int rds_ib_add_one(struct ib_device *device)
 	rds_ibdev->max_wrs = device->attrs.max_qp_wr;
 	rds_ibdev->max_sge = min(device->attrs.max_send_sge, RDS_IB_MAX_SGE);
 
-	has_fr = (device->attrs.device_cap_flags &
-		  IB_DEVICE_MEM_MGT_EXTENSIONS);
-	has_fmr = (device->ops.alloc_fmr && device->ops.dealloc_fmr &&
-		   device->ops.map_phys_fmr && device->ops.unmap_fmr);
-	rds_ibdev->use_fastreg = (has_fr && !has_fmr);
 	rds_ibdev->odp_capable =
 		!!(device->attrs.device_cap_flags &
 		   IB_DEVICE_ON_DEMAND_PAGING) &&
@@ -165,7 +163,6 @@ static int rds_ib_add_one(struct ib_device *device)
 		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
 		   IB_ODP_SUPPORT_READ);
 
-	rds_ibdev->fmr_max_remaps = device->attrs.max_map_per_fmr?: 32;
 	rds_ibdev->max_1m_mrs = device->attrs.max_mr ?
 		min_t(unsigned int, (device->attrs.max_mr / 2),
 		      rds_ib_mr_1m_pool_size) : rds_ib_mr_1m_pool_size;
@@ -219,14 +216,11 @@ static int rds_ib_add_one(struct ib_device *device)
 		goto put_dev;
 	}
 
-	rdsdebug("RDS/IB: max_mr = %d, max_wrs = %d, max_sge = %d, fmr_max_remaps = %d, max_1m_mrs = %d, max_8k_mrs = %d\n",
+	rdsdebug("RDS/IB: max_mr = %d, max_wrs = %d, max_sge = %d, max_1m_mrs = %d, max_8k_mrs = %d\n",
 		 device->attrs.max_fmr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
-		 rds_ibdev->fmr_max_remaps, rds_ibdev->max_1m_mrs,
-		 rds_ibdev->max_8k_mrs);
+		 rds_ibdev->max_1m_mrs, rds_ibdev->max_8k_mrs);
 
-	pr_info("RDS/IB: %s: %s supported and preferred\n",
-		device->name,
-		rds_ibdev->use_fastreg ? "FRMR" : "FMR");
+	pr_info("RDS/IB: %s: added\n", device->name);
 
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 0296f1f7acda34..5ae069d39eab74 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -247,13 +247,11 @@ struct rds_ib_device {
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
 	struct dma_pool		*rid_hdrs_pool; /* RDS headers DMA pool */
-	u8			use_fastreg:1;
 	u8			odp_capable:1;
 
 	unsigned int		max_mrs;
 	struct rds_ib_mr_pool	*mr_1m_pool;
 	struct rds_ib_mr_pool   *mr_8k_pool;
-	unsigned int		fmr_max_remaps;
 	unsigned int		max_8k_mrs;
 	unsigned int		max_1m_mrs;
 	int			max_sge;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 0fec4171564e25..c3319ff3ee11cd 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -527,10 +527,10 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		return -EOPNOTSUPP;
 
 	/* The fr_queue_space is currently set to 512, to add extra space on
-	 * completion queue and send queue. This extra space is used for FRMR
+	 * completion queue and send queue. This extra space is used for FRWR
 	 * registration and invalidation work requests
 	 */
-	fr_queue_space = (rds_ibdev->use_fastreg ? RDS_IB_DEFAULT_FR_WR : 0);
+	fr_queue_space = RDS_IB_DEFAULT_FR_WR;
 
 	/* add the conn now so that connection establishment has the dev */
 	rds_ib_add_conn(rds_ibdev, conn);
diff --git a/net/rds/ib_fmr.c b/net/rds/ib_fmr.c
deleted file mode 100644
index 93c0437e6a5fd2..00000000000000
--- a/net/rds/ib_fmr.c
+++ /dev/null
@@ -1,269 +0,0 @@
-/*
- * Copyright (c) 2016 Oracle.  All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include "ib_mr.h"
-
-struct rds_ib_mr *rds_ib_alloc_fmr(struct rds_ib_device *rds_ibdev, int npages)
-{
-	struct rds_ib_mr_pool *pool;
-	struct rds_ib_mr *ibmr = NULL;
-	struct rds_ib_fmr *fmr;
-	int err = 0;
-
-	if (npages <= RDS_MR_8K_MSG_SIZE)
-		pool = rds_ibdev->mr_8k_pool;
-	else
-		pool = rds_ibdev->mr_1m_pool;
-
-	if (atomic_read(&pool->dirty_count) >= pool->max_items / 10)
-		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
-
-	/* Switch pools if one of the pool is reaching upper limit */
-	if (atomic_read(&pool->dirty_count) >=  pool->max_items * 9 / 10) {
-		if (pool->pool_type == RDS_IB_MR_8K_POOL)
-			pool = rds_ibdev->mr_1m_pool;
-		else
-			pool = rds_ibdev->mr_8k_pool;
-	}
-
-	ibmr = rds_ib_try_reuse_ibmr(pool);
-	if (ibmr)
-		return ibmr;
-
-	ibmr = kzalloc_node(sizeof(*ibmr), GFP_KERNEL,
-			    rdsibdev_to_node(rds_ibdev));
-	if (!ibmr) {
-		err = -ENOMEM;
-		goto out_no_cigar;
-	}
-
-	fmr = &ibmr->u.fmr;
-	fmr->fmr = ib_alloc_fmr(rds_ibdev->pd,
-			(IB_ACCESS_LOCAL_WRITE |
-			 IB_ACCESS_REMOTE_READ |
-			 IB_ACCESS_REMOTE_WRITE |
-			 IB_ACCESS_REMOTE_ATOMIC),
-			&pool->fmr_attr);
-	if (IS_ERR(fmr->fmr)) {
-		err = PTR_ERR(fmr->fmr);
-		fmr->fmr = NULL;
-		pr_warn("RDS/IB: %s failed (err=%d)\n", __func__, err);
-		goto out_no_cigar;
-	}
-
-	ibmr->pool = pool;
-	if (pool->pool_type == RDS_IB_MR_8K_POOL)
-		rds_ib_stats_inc(s_ib_rdma_mr_8k_alloc);
-	else
-		rds_ib_stats_inc(s_ib_rdma_mr_1m_alloc);
-
-	return ibmr;
-
-out_no_cigar:
-	kfree(ibmr);
-	atomic_dec(&pool->item_count);
-
-	return ERR_PTR(err);
-}
-
-static int rds_ib_map_fmr(struct rds_ib_device *rds_ibdev,
-			  struct rds_ib_mr *ibmr, struct scatterlist *sg,
-			  unsigned int nents)
-{
-	struct ib_device *dev = rds_ibdev->dev;
-	struct rds_ib_fmr *fmr = &ibmr->u.fmr;
-	struct scatterlist *scat = sg;
-	u64 io_addr = 0;
-	u64 *dma_pages;
-	u32 len;
-	int page_cnt, sg_dma_len;
-	int i, j;
-	int ret;
-
-	sg_dma_len = ib_dma_map_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
-	if (unlikely(!sg_dma_len)) {
-		pr_warn("RDS/IB: %s failed!\n", __func__);
-		return -EBUSY;
-	}
-
-	len = 0;
-	page_cnt = 0;
-
-	for (i = 0; i < sg_dma_len; ++i) {
-		unsigned int dma_len = sg_dma_len(&scat[i]);
-		u64 dma_addr = sg_dma_address(&scat[i]);
-
-		if (dma_addr & ~PAGE_MASK) {
-			if (i > 0) {
-				ib_dma_unmap_sg(dev, sg, nents,
-						DMA_BIDIRECTIONAL);
-				return -EINVAL;
-			} else {
-				++page_cnt;
-			}
-		}
-		if ((dma_addr + dma_len) & ~PAGE_MASK) {
-			if (i < sg_dma_len - 1) {
-				ib_dma_unmap_sg(dev, sg, nents,
-						DMA_BIDIRECTIONAL);
-				return -EINVAL;
-			} else {
-				++page_cnt;
-			}
-		}
-
-		len += dma_len;
-	}
-
-	page_cnt += len >> PAGE_SHIFT;
-	if (page_cnt > ibmr->pool->fmr_attr.max_pages) {
-		ib_dma_unmap_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
-		return -EINVAL;
-	}
-
-	dma_pages = kmalloc_array_node(sizeof(u64), page_cnt, GFP_ATOMIC,
-				       rdsibdev_to_node(rds_ibdev));
-	if (!dma_pages) {
-		ib_dma_unmap_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
-		return -ENOMEM;
-	}
-
-	page_cnt = 0;
-	for (i = 0; i < sg_dma_len; ++i) {
-		unsigned int dma_len = sg_dma_len(&scat[i]);
-		u64 dma_addr = sg_dma_address(&scat[i]);
-
-		for (j = 0; j < dma_len; j += PAGE_SIZE)
-			dma_pages[page_cnt++] =
-				(dma_addr & PAGE_MASK) + j;
-	}
-
-	ret = ib_map_phys_fmr(fmr->fmr, dma_pages, page_cnt, io_addr);
-	if (ret) {
-		ib_dma_unmap_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
-		goto out;
-	}
-
-	/* Success - we successfully remapped the MR, so we can
-	 * safely tear down the old mapping.
-	 */
-	rds_ib_teardown_mr(ibmr);
-
-	ibmr->sg = scat;
-	ibmr->sg_len = nents;
-	ibmr->sg_dma_len = sg_dma_len;
-	ibmr->remap_count++;
-
-	if (ibmr->pool->pool_type == RDS_IB_MR_8K_POOL)
-		rds_ib_stats_inc(s_ib_rdma_mr_8k_used);
-	else
-		rds_ib_stats_inc(s_ib_rdma_mr_1m_used);
-	ret = 0;
-
-out:
-	kfree(dma_pages);
-
-	return ret;
-}
-
-struct rds_ib_mr *rds_ib_reg_fmr(struct rds_ib_device *rds_ibdev,
-				 struct scatterlist *sg,
-				 unsigned long nents,
-				 u32 *key)
-{
-	struct rds_ib_mr *ibmr = NULL;
-	struct rds_ib_fmr *fmr;
-	int ret;
-
-	ibmr = rds_ib_alloc_fmr(rds_ibdev, nents);
-	if (IS_ERR(ibmr))
-		return ibmr;
-
-	ibmr->device = rds_ibdev;
-	fmr = &ibmr->u.fmr;
-	ret = rds_ib_map_fmr(rds_ibdev, ibmr, sg, nents);
-	if (ret == 0)
-		*key = fmr->fmr->rkey;
-	else
-		rds_ib_free_mr(ibmr, 0);
-
-	return ibmr;
-}
-
-void rds_ib_unreg_fmr(struct list_head *list, unsigned int *nfreed,
-		      unsigned long *unpinned, unsigned int goal)
-{
-	struct rds_ib_mr *ibmr, *next;
-	struct rds_ib_fmr *fmr;
-	LIST_HEAD(fmr_list);
-	int ret = 0;
-	unsigned int freed = *nfreed;
-
-	/* String all ib_mr's onto one list and hand them to  ib_unmap_fmr */
-	list_for_each_entry(ibmr, list, unmap_list) {
-		fmr = &ibmr->u.fmr;
-		list_add(&fmr->fmr->list, &fmr_list);
-	}
-
-	ret = ib_unmap_fmr(&fmr_list);
-	if (ret)
-		pr_warn("RDS/IB: FMR invalidation failed (err=%d)\n", ret);
-
-	/* Now we can destroy the DMA mapping and unpin any pages */
-	list_for_each_entry_safe(ibmr, next, list, unmap_list) {
-		fmr = &ibmr->u.fmr;
-		*unpinned += ibmr->sg_len;
-		__rds_ib_teardown_mr(ibmr);
-		if (freed < goal ||
-		    ibmr->remap_count >= ibmr->pool->fmr_attr.max_maps) {
-			if (ibmr->pool->pool_type == RDS_IB_MR_8K_POOL)
-				rds_ib_stats_inc(s_ib_rdma_mr_8k_free);
-			else
-				rds_ib_stats_inc(s_ib_rdma_mr_1m_free);
-			list_del(&ibmr->unmap_list);
-			ib_dealloc_fmr(fmr->fmr);
-			kfree(ibmr);
-			freed++;
-		}
-	}
-	*nfreed = freed;
-}
-
-void rds_ib_free_fmr_list(struct rds_ib_mr *ibmr)
-{
-	struct rds_ib_mr_pool *pool = ibmr->pool;
-
-	if (ibmr->remap_count >= pool->fmr_attr.max_maps)
-		llist_add(&ibmr->llnode, &pool->drop_list);
-	else
-		llist_add(&ibmr->llnode, &pool->free_list);
-}
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 06ecf9d2d4bf1b..9b6ffff72f2d11 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -76,7 +76,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 
 	frmr = &ibmr->u.frmr;
 	frmr->mr = ib_alloc_mr(rds_ibdev->pd, IB_MR_TYPE_MEM_REG,
-			 pool->fmr_attr.max_pages);
+			 pool->max_pages);
 	if (IS_ERR(frmr->mr)) {
 		pr_warn("RDS/IB: %s failed to allocate MR", __func__);
 		err = PTR_ERR(frmr->mr);
@@ -240,7 +240,7 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 	}
 	frmr->dma_npages += len >> PAGE_SHIFT;
 
-	if (frmr->dma_npages > ibmr->pool->fmr_attr.max_pages) {
+	if (frmr->dma_npages > ibmr->pool->max_pages) {
 		ret = -EMSGSIZE;
 		goto out_unmap;
 	}
diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index 0c8252d7fe2b76..ea5e9aee4959e2 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -43,10 +43,6 @@
 #define RDS_MR_8K_SCALE			(256 / (RDS_MR_8K_MSG_SIZE + 1))
 #define RDS_MR_8K_POOL_SIZE		(RDS_MR_8K_SCALE * (8192 / 2))
 
-struct rds_ib_fmr {
-	struct ib_fmr		*fmr;
-};
-
 enum rds_ib_fr_state {
 	FRMR_IS_FREE,	/* mr invalidated & ready for use */
 	FRMR_IS_INUSE,	/* mr is in use or used & can be invalidated */
@@ -84,7 +80,6 @@ struct rds_ib_mr {
 
 	u8				odp:1;
 	union {
-		struct rds_ib_fmr	fmr;
 		struct rds_ib_frmr	frmr;
 		struct ib_mr		*mr;
 	} u;
@@ -109,8 +104,7 @@ struct rds_ib_mr_pool {
 	unsigned long		max_items;
 	unsigned long		max_items_soft;
 	unsigned long		max_free_pinned;
-	struct ib_fmr_attr	fmr_attr;
-	bool			use_fastreg;
+	unsigned int		max_pages;
 };
 
 extern struct workqueue_struct *rds_ib_mr_wq;
@@ -136,15 +130,9 @@ u32 rds_ib_get_lkey(void *trans_private);
 
 void __rds_ib_teardown_mr(struct rds_ib_mr *);
 void rds_ib_teardown_mr(struct rds_ib_mr *);
-struct rds_ib_mr *rds_ib_alloc_fmr(struct rds_ib_device *, int);
 struct rds_ib_mr *rds_ib_reuse_mr(struct rds_ib_mr_pool *);
 int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *, int, struct rds_ib_mr **);
-struct rds_ib_mr *rds_ib_reg_fmr(struct rds_ib_device *, struct scatterlist *,
-				 unsigned long, u32 *);
 struct rds_ib_mr *rds_ib_try_reuse_ibmr(struct rds_ib_mr_pool *);
-void rds_ib_unreg_fmr(struct list_head *, unsigned int *,
-		      unsigned long *, unsigned int);
-void rds_ib_free_fmr_list(struct rds_ib_mr *);
 struct rds_ib_mr *rds_ib_reg_frmr(struct rds_ib_device *rds_ibdev,
 				  struct rds_ib_connection *ic,
 				  struct scatterlist *sg,
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index b34b24e237f81b..8f070ee7e74268 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -181,7 +181,7 @@ void rds_ib_get_mr_info(struct rds_ib_device *rds_ibdev, struct rds_info_rdma_co
 	struct rds_ib_mr_pool *pool_1m = rds_ibdev->mr_1m_pool;
 
 	iinfo->rdma_mr_max = pool_1m->max_items;
-	iinfo->rdma_mr_size = pool_1m->fmr_attr.max_pages;
+	iinfo->rdma_mr_size = pool_1m->max_pages;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -191,7 +191,7 @@ void rds6_ib_get_mr_info(struct rds_ib_device *rds_ibdev,
 	struct rds_ib_mr_pool *pool_1m = rds_ibdev->mr_1m_pool;
 
 	iinfo6->rdma_mr_max = pool_1m->max_items;
-	iinfo6->rdma_mr_size = pool_1m->fmr_attr.max_pages;
+	iinfo6->rdma_mr_size = pool_1m->max_pages;
 }
 #endif
 
@@ -406,10 +406,7 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
 	if (list_empty(&unmap_list))
 		goto out;
 
-	if (pool->use_fastreg)
-		rds_ib_unreg_frmr(&unmap_list, &nfreed, &unpinned, free_goal);
-	else
-		rds_ib_unreg_fmr(&unmap_list, &nfreed, &unpinned, free_goal);
+	rds_ib_unreg_frmr(&unmap_list, &nfreed, &unpinned, free_goal);
 
 	if (!list_empty(&unmap_list)) {
 		unsigned long flags;
@@ -503,10 +500,7 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
 	}
 
 	/* Return it to the pool's free list */
-	if (rds_ibdev->use_fastreg)
-		rds_ib_free_frmr_list(ibmr);
-	else
-		rds_ib_free_fmr_list(ibmr);
+	rds_ib_free_frmr_list(ibmr);
 
 	atomic_add(ibmr->sg_len, &pool->free_pinned);
 	atomic_inc(&pool->dirty_count);
@@ -622,10 +616,7 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		goto out;
 	}
 
-	if (rds_ibdev->use_fastreg)
-		ibmr = rds_ib_reg_frmr(rds_ibdev, ic, sg, nents, key_ret);
-	else
-		ibmr = rds_ib_reg_fmr(rds_ibdev, sg, nents, key_ret);
+	ibmr = rds_ib_reg_frmr(rds_ibdev, ic, sg, nents, key_ret);
 	if (IS_ERR(ibmr)) {
 		ret = PTR_ERR(ibmr);
 		pr_warn("RDS/IB: rds_ib_get_mr failed (errno=%d)\n", ret);
@@ -669,19 +660,16 @@ struct rds_ib_mr_pool *rds_ib_create_mr_pool(struct rds_ib_device *rds_ibdev,
 
 	if (pool_type == RDS_IB_MR_1M_POOL) {
 		/* +1 allows for unaligned MRs */
-		pool->fmr_attr.max_pages = RDS_MR_1M_MSG_SIZE + 1;
+		pool->max_pages = RDS_MR_1M_MSG_SIZE + 1;
 		pool->max_items = rds_ibdev->max_1m_mrs;
 	} else {
 		/* pool_type == RDS_IB_MR_8K_POOL */
-		pool->fmr_attr.max_pages = RDS_MR_8K_MSG_SIZE + 1;
+		pool->max_pages = RDS_MR_8K_MSG_SIZE + 1;
 		pool->max_items = rds_ibdev->max_8k_mrs;
 	}
 
-	pool->max_free_pinned = pool->max_items * pool->fmr_attr.max_pages / 4;
-	pool->fmr_attr.max_maps = rds_ibdev->fmr_max_remaps;
-	pool->fmr_attr.page_shift = PAGE_SHIFT;
+	pool->max_free_pinned = pool->max_items * pool->max_pages / 4;
 	pool->max_items_soft = rds_ibdev->max_mrs * 3 / 4;
-	pool->use_fastreg = rds_ibdev->use_fastreg;
 
 	return pool;
 }
-- 
2.26.2

