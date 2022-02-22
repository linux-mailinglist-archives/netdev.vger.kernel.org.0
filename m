Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137604BF9A7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiBVNnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiBVNnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:43:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA74C119843
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645537367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2uPQ0PrAQ4ziIfXTltU6gJp/EwSDQPeLt7vadw1dPrc=;
        b=MHH5xlq7eyC5xoX2bHeZTICnGVrpHzKIHPSe2/1QH8hNf4Z0mPUKiLDLd0zrPFozYpPKQw
        n+zmB3yzxWd2UaVX1I1SnSh12es1RtS2MlnqDQebrrclrcAt/GL57YKC1Dg7tAizCGvUZT
        Wx38L0JiWSTNVWXLFyNvS1w0P6bd8ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-_ooy5SJoPIK9TtAFxEoSiw-1; Tue, 22 Feb 2022 08:42:43 -0500
X-MC-Unique: _ooy5SJoPIK9TtAFxEoSiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B56A0FC80;
        Tue, 22 Feb 2022 13:42:40 +0000 (UTC)
Received: from localhost (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E511D106D5B4;
        Tue, 22 Feb 2022 13:42:24 +0000 (UTC)
Date:   Tue, 22 Feb 2022 21:42:22 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 2/2] kernel/dma: rename dma_alloc_direct and dma_map_direct
Message-ID: <YhToPpeuTqdQgC80@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222131120.GB10093@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the old dma mapping, coherent mapping uses dma_alloc_coherent() to
allocate DMA buffer and mapping; while streaming mapping can only get
memory from slab or buddy allocator, then map with dma_map_single().
In that situation, dma_alloc_direct() checks a direct mapping for
coherent DMA, dma_map_direct() checks a direct mapping for streaming
DMA.

However, several new APIs have been added for streaming mapping, e.g
dma_alloc_pages(). These new APIs take care of DMA buffer allocating
and mapping which are similar with dma_alloc_coherent(). So we should
rename both of them to reflect their real intention to avoid confusion.

       dma_alloc_direct()  ==>  dma_coherent_direct()
       dma_map_direct()    ==>  dma_streaming_direct()

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 kernel/dma/mapping.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index e66847aeac67..2835b08e96c6 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -127,13 +127,13 @@ static bool dma_go_direct(struct device *dev, dma_addr_t mask,
  * This allows IOMMU drivers to set a bypass mode if the DMA mask is large
  * enough.
  */
-static inline bool dma_alloc_direct(struct device *dev,
+static inline bool dma_coherent_direct(struct device *dev,
 		const struct dma_map_ops *ops)
 {
 	return dma_go_direct(dev, dev->coherent_dma_mask, ops);
 }
 
-static inline bool dma_map_direct(struct device *dev,
+static inline bool dma_streaming_direct(struct device *dev,
 		const struct dma_map_ops *ops)
 {
 	return dma_go_direct(dev, *dev->dma_mask, ops);
@@ -151,7 +151,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
-	if (dma_map_direct(dev, ops) ||
+	if (dma_streaming_direct(dev, ops) ||
 	    arch_dma_map_page_direct(dev, page_to_phys(page) + offset + size))
 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
 	else
@@ -168,7 +168,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (dma_map_direct(dev, ops) ||
+	if (dma_streaming_direct(dev, ops) ||
 	    arch_dma_unmap_page_direct(dev, addr + size))
 		dma_direct_unmap_page(dev, addr, size, dir, attrs);
 	else if (ops->unmap_page)
@@ -188,7 +188,7 @@ static int __dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return 0;
 
-	if (dma_map_direct(dev, ops) ||
+	if (dma_streaming_direct(dev, ops) ||
 	    arch_dma_map_sg_direct(dev, sg, nents))
 		ents = dma_direct_map_sg(dev, sg, nents, dir, attrs);
 	else
@@ -277,7 +277,7 @@ void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg,
 
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
-	if (dma_map_direct(dev, ops) ||
+	if (dma_streaming_direct(dev, ops) ||
 	    arch_dma_unmap_sg_direct(dev, sg, nents))
 		dma_direct_unmap_sg(dev, sg, nents, dir, attrs);
 	else if (ops->unmap_sg)
@@ -296,7 +296,7 @@ dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
 	else if (ops->map_resource)
 		addr = ops->map_resource(dev, phys_addr, size, dir, attrs);
@@ -312,7 +312,7 @@ void dma_unmap_resource(struct device *dev, dma_addr_t addr, size_t size,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (!dma_map_direct(dev, ops) && ops->unmap_resource)
+	if (!dma_streaming_direct(dev, ops) && ops->unmap_resource)
 		ops->unmap_resource(dev, addr, size, dir, attrs);
 	debug_dma_unmap_resource(dev, addr, size, dir);
 }
@@ -324,7 +324,7 @@ void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr, size_t size,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 	else if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
@@ -338,7 +338,7 @@ void dma_sync_single_for_device(struct device *dev, dma_addr_t addr,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		dma_direct_sync_single_for_device(dev, addr, size, dir);
 	else if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
@@ -352,7 +352,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		dma_direct_sync_sg_for_cpu(dev, sg, nelems, dir);
 	else if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
@@ -366,7 +366,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		dma_direct_sync_sg_for_device(dev, sg, nelems, dir);
 	else if (ops->sync_sg_for_device)
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
@@ -391,7 +391,7 @@ int dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		return dma_direct_get_sgtable(dev, sgt, cpu_addr, dma_addr,
 				size, attrs);
 	if (!ops->get_sgtable)
@@ -430,7 +430,7 @@ bool dma_can_mmap(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_coherent_direct(dev, ops))
 		return dma_direct_can_mmap(dev);
 	return ops->mmap != NULL;
 }
@@ -455,7 +455,7 @@ int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_coherent_direct(dev, ops))
 		return dma_direct_mmap(dev, vma, cpu_addr, dma_addr, size,
 				attrs);
 	if (!ops->mmap)
@@ -468,7 +468,7 @@ u64 dma_get_required_mask(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		return dma_direct_get_required_mask(dev);
 	if (ops->get_required_mask)
 		return ops->get_required_mask(dev);
@@ -499,7 +499,7 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	/* let the implementation decide on the zone to allocate from: */
 	flag &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_coherent_direct(dev, ops))
 		cpu_addr = dma_direct_alloc(dev, size, dma_handle, flag, attrs);
 	else if (ops->alloc)
 		cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
@@ -531,7 +531,7 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 		return;
 
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	if (dma_alloc_direct(dev, ops))
+	if (dma_coherent_direct(dev, ops))
 		dma_direct_free(dev, size, cpu_addr, dma_handle, attrs);
 	else if (ops->free)
 		ops->free(dev, size, cpu_addr, dma_handle, attrs);
@@ -550,7 +550,7 @@ static struct page *__dma_alloc_pages(struct device *dev, size_t size,
         gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
 	size = PAGE_ALIGN(size);
-	if (dma_alloc_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		return dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
 	if (!ops->alloc_pages)
 		return NULL;
@@ -574,7 +574,7 @@ static void __dma_free_pages(struct device *dev, size_t size, struct page *page,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	size = PAGE_ALIGN(size);
-	if (dma_alloc_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		dma_direct_free_pages(dev, size, page, dma_handle, dir);
 	else if (ops->free_pages)
 		ops->free_pages(dev, size, page, dma_handle, dir);
@@ -769,7 +769,7 @@ size_t dma_max_mapping_size(struct device *dev)
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	size_t size = SIZE_MAX;
 
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		size = dma_direct_max_mapping_size(dev);
 	else if (ops && ops->max_mapping_size)
 		size = ops->max_mapping_size(dev);
@@ -782,7 +782,7 @@ bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_map_direct(dev, ops))
+	if (dma_streaming_direct(dev, ops))
 		return dma_direct_need_sync(dev, dma_addr);
 	return ops->sync_single_for_cpu || ops->sync_single_for_device;
 }
-- 
2.31.1

