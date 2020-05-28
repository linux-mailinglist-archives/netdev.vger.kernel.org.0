Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E361E6B99
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406743AbgE1TsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbgE1TqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:04 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EFC08C5D1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:00 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c12so1066700qtq.11
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EY2/UtKZBl5qdG+6wGZSTexrqNxwXEJQFPSAzqLwxtM=;
        b=V5nlgps+xMmIVamW837PYQZMZwStNV8Pjy8Yn8d+z52O0K4X3NAn1joaultP1jL9K/
         /LQQFh2QpBIUXZzkVcegQ6xLY7vXogsrEax0BLu3ra8UvBAWwrLsR4452Z8yz7WXr1CS
         6739U6Ye5q0ooDl9fZX2zyZ+r1HamYTiYZlqDzQEsPuYzuKCXGD8hN6ItIjsEE+hBKPc
         7Pucn/pye1xRHFaQgP5eMTMk09nDAog2ECw0OcQmD/KqGcNfb6awLlKaLeY87uF85FEw
         Aq3gVdioSdTUEeoHf5/67r79yOUQfPP0SU2QzmCCK9ZINSRlrDH+aApjEHCtYlFtpbLu
         VcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EY2/UtKZBl5qdG+6wGZSTexrqNxwXEJQFPSAzqLwxtM=;
        b=fvJs3Qhytz5H/fdDiPDT6GH8Ft6NKMiDarbjwoGjbxhZXGr8XuTF4alFrvZtPLkuQf
         TV/tMsU10gp69nJxRx4gUpxJIwhUcv5S8G7W+YVLwLkxXWNziYFBqIsuNHZw8z7/hCsS
         /GNhFwPRx+yS5mlxeAvwC4fVYETbCe0+N3VMLQowv5UxVaW/Wn8XcZTC0QUxgCQ+umt2
         Jreg+hu84FVKHfw/8K9GLxY6Wz18HAcmeLpQ8cnne3ilTiBouEWGCf8MNz42Cq/ppOqg
         b+0N1vqfzmey64aY+Q0kilv48k6DQUB1r9E6oksta7kXpZV6gexzbZqv8R8nxZoj7H8t
         Knsw==
X-Gm-Message-State: AOAM531QsZxseiL07/h2tnvOViurH32UkWrn+iF8jv7U2NaFlouOObZu
        8ch4wuzS2K347nGtqybp2nJNkw==
X-Google-Smtp-Source: ABdhPJwUE9Hig2qEA7XXiV6Y3TBkTas0ErZP3FZDIo72H16N8FFekmlkhERAYacFYfRuyYzQwBH3yA==
X-Received: by 2002:ac8:1858:: with SMTP id n24mr4908918qtk.189.1590695159958;
        Thu, 28 May 2020 12:45:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x4sm6396086qtj.43.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006hl-EI; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        oren@mellanox.com, shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 10/13] RDMA/rdmavt: Remove FMR memory registration
Date:   Thu, 28 May 2020 16:45:52 -0300
Message-Id: <10-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

Use FRWR method to register memory by default and remove the ancient and
unsafe FMR method.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Tested-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/infiniband/sw/rdmavt/mr.c | 154 ------------------------------
 drivers/infiniband/sw/rdmavt/mr.h |  15 ---
 drivers/infiniband/sw/rdmavt/vt.c |   4 -
 3 files changed, 173 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 72f6534fbb52b7..ddb0c0d771c257 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -713,160 +713,6 @@ int rvt_invalidate_rkey(struct rvt_qp *qp, u32 rkey)
 }
 EXPORT_SYMBOL(rvt_invalidate_rkey);
 
-/**
- * rvt_alloc_fmr - allocate a fast memory region
- * @pd: the protection domain for this memory region
- * @mr_access_flags: access flags for this memory region
- * @fmr_attr: fast memory region attributes
- *
- * Return: the memory region on success, otherwise returns an errno.
- */
-struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr)
-{
-	struct rvt_fmr *fmr;
-	int m;
-	struct ib_fmr *ret;
-	int rval = -ENOMEM;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (fmr_attr->max_pages + RVT_SEGSZ - 1) / RVT_SEGSZ;
-	fmr = kzalloc(struct_size(fmr, mr.map, m), GFP_KERNEL);
-	if (!fmr)
-		goto bail;
-
-	rval = rvt_init_mregion(&fmr->mr, pd, fmr_attr->max_pages,
-				PERCPU_REF_INIT_ATOMIC);
-	if (rval)
-		goto bail;
-
-	/*
-	 * ib_alloc_fmr() will initialize fmr->ibfmr except for lkey &
-	 * rkey.
-	 */
-	rval = rvt_alloc_lkey(&fmr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	fmr->ibfmr.rkey = fmr->mr.lkey;
-	fmr->ibfmr.lkey = fmr->mr.lkey;
-	/*
-	 * Resources are allocated but no valid mapping (RKEY can't be
-	 * used).
-	 */
-	fmr->mr.access_flags = mr_access_flags;
-	fmr->mr.max_segs = fmr_attr->max_pages;
-	fmr->mr.page_shift = fmr_attr->page_shift;
-
-	ret = &fmr->ibfmr;
-done:
-	return ret;
-
-bail_mregion:
-	rvt_deinit_mregion(&fmr->mr);
-bail:
-	kfree(fmr);
-	ret = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * rvt_map_phys_fmr - set up a fast memory region
- * @ibfmr: the fast memory region to set up
- * @page_list: the list of pages to associate with the fast memory region
- * @list_len: the number of pages to associate with the fast memory region
- * @iova: the virtual address of the start of the fast memory region
- *
- * This may be called from interrupt context.
- *
- * Return: 0 on success
- */
-
-int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova)
-{
-	struct rvt_fmr *fmr = to_ifmr(ibfmr);
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-	int m, n;
-	unsigned long i;
-	u32 ps;
-	struct rvt_dev_info *rdi = ib_to_rvt(ibfmr->device);
-
-	i = atomic_long_read(&fmr->mr.refcount.count);
-	if (i > 2)
-		return -EBUSY;
-
-	if (list_len > fmr->mr.max_segs)
-		return -EINVAL;
-
-	rkt = &rdi->lkey_table;
-	spin_lock_irqsave(&rkt->lock, flags);
-	fmr->mr.user_base = iova;
-	fmr->mr.iova = iova;
-	ps = 1 << fmr->mr.page_shift;
-	fmr->mr.length = list_len * ps;
-	m = 0;
-	n = 0;
-	for (i = 0; i < list_len; i++) {
-		fmr->mr.map[m]->segs[n].vaddr = (void *)page_list[i];
-		fmr->mr.map[m]->segs[n].length = ps;
-		trace_rvt_mr_fmr_seg(&fmr->mr, m, n, (void *)page_list[i], ps);
-		if (++n == RVT_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	return 0;
-}
-
-/**
- * rvt_unmap_fmr - unmap fast memory regions
- * @fmr_list: the list of fast memory regions to unmap
- *
- * Return: 0 on success.
- */
-int rvt_unmap_fmr(struct list_head *fmr_list)
-{
-	struct rvt_fmr *fmr;
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-	struct rvt_dev_info *rdi;
-
-	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
-		rdi = ib_to_rvt(fmr->ibfmr.device);
-		rkt = &rdi->lkey_table;
-		spin_lock_irqsave(&rkt->lock, flags);
-		fmr->mr.user_base = 0;
-		fmr->mr.iova = 0;
-		fmr->mr.length = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
-	}
-	return 0;
-}
-
-/**
- * rvt_dealloc_fmr - deallocate a fast memory region
- * @ibfmr: the fast memory region to deallocate
- *
- * Return: 0 on success.
- */
-int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
-{
-	struct rvt_fmr *fmr = to_ifmr(ibfmr);
-	int ret = 0;
-
-	rvt_free_lkey(&fmr->mr);
-	rvt_put_mr(&fmr->mr); /* will set completion if last */
-	ret = rvt_check_refs(&fmr->mr, __func__);
-	if (ret)
-		goto out;
-	rvt_deinit_mregion(&fmr->mr);
-	kfree(fmr);
-out:
-	return ret;
-}
-
 /**
  * rvt_sge_adjacent - is isge compressible
  * @last_sge: last outgoing SGE written
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index 2c8d0752e8e34a..780fc63af98b75 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -49,10 +49,6 @@
  */
 
 #include <rdma/rdma_vt.h>
-struct rvt_fmr {
-	struct ib_fmr ibfmr;
-	struct rvt_mregion mr;        /* must be last */
-};
 
 struct rvt_mr {
 	struct ib_mr ibmr;
@@ -60,11 +56,6 @@ struct rvt_mr {
 	struct rvt_mregion mr;  /* must be last */
 };
 
-static inline struct rvt_fmr *to_ifmr(struct ib_fmr *ibfmr)
-{
-	return container_of(ibfmr, struct rvt_fmr, ibfmr);
-}
-
 static inline struct rvt_mr *to_imr(struct ib_mr *ibmr)
 {
 	return container_of(ibmr, struct rvt_mr, ibmr);
@@ -83,11 +74,5 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 			   u32 max_num_sg, struct ib_udata *udata);
 int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
-struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr);
-int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova);
-int rvt_unmap_fmr(struct list_head *fmr_list);
-int rvt_dealloc_fmr(struct ib_fmr *ibfmr);
 
 #endif          /* DEF_RVTMR_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 72b031ab7092d8..f904bb34477ae7 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -378,7 +378,6 @@ enum {
 static const struct ib_device_ops rvt_dev_ops = {
 	.uverbs_abi_ver = RVT_UVERBS_ABI_VERSION,
 
-	.alloc_fmr = rvt_alloc_fmr,
 	.alloc_mr = rvt_alloc_mr,
 	.alloc_pd = rvt_alloc_pd,
 	.alloc_ucontext = rvt_alloc_ucontext,
@@ -387,7 +386,6 @@ static const struct ib_device_ops rvt_dev_ops = {
 	.create_cq = rvt_create_cq,
 	.create_qp = rvt_create_qp,
 	.create_srq = rvt_create_srq,
-	.dealloc_fmr = rvt_dealloc_fmr,
 	.dealloc_pd = rvt_dealloc_pd,
 	.dealloc_ucontext = rvt_dealloc_ucontext,
 	.dereg_mr = rvt_dereg_mr,
@@ -399,7 +397,6 @@ static const struct ib_device_ops rvt_dev_ops = {
 	.get_dma_mr = rvt_get_dma_mr,
 	.get_port_immutable = rvt_get_port_immutable,
 	.map_mr_sg = rvt_map_mr_sg,
-	.map_phys_fmr = rvt_map_phys_fmr,
 	.mmap = rvt_mmap,
 	.modify_ah = rvt_modify_ah,
 	.modify_device = rvt_modify_device,
@@ -420,7 +417,6 @@ static const struct ib_device_ops rvt_dev_ops = {
 	.reg_user_mr = rvt_reg_user_mr,
 	.req_notify_cq = rvt_req_notify_cq,
 	.resize_cq = rvt_resize_cq,
-	.unmap_fmr = rvt_unmap_fmr,
 
 	INIT_RDMA_OBJ_SIZE(ib_ah, rvt_ah, ibah),
 	INIT_RDMA_OBJ_SIZE(ib_cq, rvt_cq, ibcq),
-- 
2.26.2

