Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A1322A1B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhBWL6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhBWLyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:54:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1F4C061223
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id kr16so1652049pjb.2
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aHtCMWLr7gM7N5rZoKJpLG0orFpcTbj04X+cpqBxZtc=;
        b=yUxnYsEU/c2KgIg4VBArPR9TSgRc4M3x6lPMb3dy/FYrrwxRaHZOlo6Svi7IdApYUd
         VC5orLeYCVsrjttuNZGshhiPtQbxudbLpOYzCkJx1Z1ukjKvExIVlrWRes4x69hJACs9
         KUVnNEQSoEGMt7FCO+nAZTqfb/GEnJAGrpCfXuqg0tZH4Nm8eLGteRhVkqm+Hiyt3Bxa
         Srv8w4eJCKm+iwprkUrDB+cE2HHkhkmdyZOrr9ehuYJHDuP3syuhFhzAy2s/ZmnLRmPy
         gDQEMnNth2gtIRhDjNQ1IXF4zVARSqv1ddnvZkIw6AqepPp8RvelBugachUO5+VZx/lo
         bpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aHtCMWLr7gM7N5rZoKJpLG0orFpcTbj04X+cpqBxZtc=;
        b=AKVoAV/M7SxS1/OEUJZdLNiTPZjWZy8Cd5F+IV8/0m/z3SVQ+wciaq+2xTx4P7FpL+
         wbcSAROx4kt0+bez1wZoREscFSabWi69JvDwRznkT/lPEFK8rTzBfbxppxw7BWleKHVk
         /JeztlguXe78LZoe/uA62AgJhs/PmrLCiG3nPjwAzSa0IcuLpkYs8cRqNvHBTkOCsa1/
         9eBsgHDtlcshcpSPku9A0HJ3CKM1yHyVwb09HII1X1QSiZHeLTxdhbC+Xo7QSL3V8RJl
         6BPk19ruKj6bMQH9zva5MPnFSBvzmxpx7luPXtYrw7RrJyGYpSnkRjbrm2a6HEqvlc50
         by9g==
X-Gm-Message-State: AOAM530iEhEc1L4Kbxf5sjSnv7jC3G4f2Ru4jnEVhHerNZ1RAqTkPO59
        lOskR8VuD4Z9YaTrF99YwpcN
X-Google-Smtp-Source: ABdhPJx/Bcu4ehgjlNX+oub9EPIPF0vPiCH+WLCStrWwcNtnh/MUbjyQUdkKxShmjPgvXtZ3pjnTmA==
X-Received: by 2002:a17:902:c407:b029:e3:cfa7:e300 with SMTP id k7-20020a170902c407b02900e3cfa7e300mr18063207plk.49.1614081126161;
        Tue, 23 Feb 2021 03:52:06 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id e1sm3221500pjm.12.2021.02.23.03.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:52:05 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
Date:   Tue, 23 Feb 2021 19:50:43 +0800
Message-Id: <20210223115048.435-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements a MMU-based IOMMU driver to support mapping
kernel dma buffer into userspace. The basic idea behind it is
treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
up MMU mapping instead of IOMMU mapping for the DMA transfer so
that the userspace process is able to use its virtual address to
access the dma buffer in kernel.

And to avoid security issue, a bounce-buffering mechanism is
introduced to prevent userspace accessing the original buffer
directly.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 486 +++++++++++++++++++++++++++++++++++
 drivers/vdpa/vdpa_user/iova_domain.h |  61 +++++
 2 files changed, 547 insertions(+)
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
new file mode 100644
index 000000000000..9285d430d486
--- /dev/null
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -0,0 +1,486 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * MMU-based IOMMU implementation
+ *
+ * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
+ *
+ * Author: Xie Yongji <xieyongji@bytedance.com>
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/anon_inodes.h>
+#include <linux/highmem.h>
+
+#include "iova_domain.h"
+
+#define IOVA_START_PFN 1
+#define IOVA_ALLOC_ORDER 12
+#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
+
+static inline struct page *
+vduse_domain_get_bounce_page(struct vduse_iova_domain *domain, u64 iova)
+{
+	u64 index = iova >> PAGE_SHIFT;
+
+	return domain->bounce_pages[index];
+}
+
+static inline void
+vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
+				u64 iova, struct page *page)
+{
+	u64 index = iova >> PAGE_SHIFT;
+
+	domain->bounce_pages[index] = page;
+}
+
+static enum dma_data_direction perm_to_dir(int perm)
+{
+	enum dma_data_direction dir;
+
+	switch (perm) {
+	case VHOST_MAP_WO:
+		dir = DMA_FROM_DEVICE;
+		break;
+	case VHOST_MAP_RO:
+		dir = DMA_TO_DEVICE;
+		break;
+	case VHOST_MAP_RW:
+		dir = DMA_BIDIRECTIONAL;
+		break;
+	default:
+		break;
+	}
+
+	return dir;
+}
+
+static int dir_to_perm(enum dma_data_direction dir)
+{
+	int perm = -EFAULT;
+
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		perm = VHOST_MAP_WO;
+		break;
+	case DMA_TO_DEVICE:
+		perm = VHOST_MAP_RO;
+		break;
+	case DMA_BIDIRECTIONAL:
+		perm = VHOST_MAP_RW;
+		break;
+	default:
+		break;
+	}
+
+	return perm;
+}
+
+static void do_bounce(phys_addr_t orig, void *addr, size_t size,
+			enum dma_data_direction dir)
+{
+	unsigned long pfn = PFN_DOWN(orig);
+
+	if (PageHighMem(pfn_to_page(pfn))) {
+		unsigned int offset = offset_in_page(orig);
+		char *buffer;
+		unsigned int sz = 0;
+		unsigned long flags;
+
+		while (size) {
+			sz = min_t(size_t, PAGE_SIZE - offset, size);
+
+			local_irq_save(flags);
+			buffer = kmap_atomic(pfn_to_page(pfn));
+			if (dir == DMA_TO_DEVICE)
+				memcpy(addr, buffer + offset, sz);
+			else
+				memcpy(buffer + offset, addr, sz);
+			kunmap_atomic(buffer);
+			local_irq_restore(flags);
+
+			size -= sz;
+			pfn++;
+			addr += sz;
+			offset = 0;
+		}
+	} else if (dir == DMA_TO_DEVICE) {
+		memcpy(addr, phys_to_virt(orig), size);
+	} else {
+		memcpy(phys_to_virt(orig), addr, size);
+	}
+}
+
+static struct page *
+vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 iova)
+{
+	u64 start = iova & PAGE_MASK;
+	u64 last = start + PAGE_SIZE - 1;
+	struct vhost_iotlb_map *map;
+	struct page *page = NULL;
+
+	spin_lock(&domain->iotlb_lock);
+	map = vhost_iotlb_itree_first(domain->iotlb, start, last);
+	if (!map)
+		goto out;
+
+	page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
+	get_page(page);
+out:
+	spin_unlock(&domain->iotlb_lock);
+
+	return page;
+}
+
+static struct page *
+vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u64 iova)
+{
+	u64 start = iova & PAGE_MASK;
+	u64 last = start + PAGE_SIZE - 1;
+	struct vhost_iotlb_map *map;
+	struct page *page = NULL, *new_page = alloc_page(GFP_KERNEL);
+
+	if (!new_page)
+		return NULL;
+
+	spin_lock(&domain->iotlb_lock);
+	if (!vhost_iotlb_itree_first(domain->iotlb, start, last)) {
+		__free_page(new_page);
+		goto out;
+	}
+	page = vduse_domain_get_bounce_page(domain, iova);
+	if (page) {
+		get_page(page);
+		__free_page(new_page);
+		goto out;
+	}
+	vduse_domain_set_bounce_page(domain, iova, new_page);
+	get_page(new_page);
+	page = new_page;
+
+	for (map = vhost_iotlb_itree_first(domain->iotlb, start, last); map;
+	     map = vhost_iotlb_itree_next(map, start, last)) {
+		unsigned int src_offset = 0, dst_offset = 0;
+		phys_addr_t src;
+		void *dst;
+		size_t sz;
+
+		if (perm_to_dir(map->perm) == DMA_FROM_DEVICE)
+			continue;
+
+		if (start > map->start)
+			src_offset = start - map->start;
+		else
+			dst_offset = map->start - start;
+
+		src = map->addr + src_offset;
+		dst = page_address(page) + dst_offset;
+		sz = min_t(size_t, map->size - src_offset,
+				PAGE_SIZE - dst_offset);
+		do_bounce(src, dst, sz, DMA_TO_DEVICE);
+	}
+out:
+	spin_unlock(&domain->iotlb_lock);
+
+	return page;
+}
+
+static void
+vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
+				u64 iova, size_t size)
+{
+	struct page *page;
+
+	spin_lock(&domain->iotlb_lock);
+	if (WARN_ON(vhost_iotlb_itree_first(domain->iotlb, iova,
+						iova + size - 1)))
+		goto out;
+
+	while (size > 0) {
+		page = vduse_domain_get_bounce_page(domain, iova);
+		if (page) {
+			vduse_domain_set_bounce_page(domain, iova, NULL);
+			__free_page(page);
+		}
+		size -= PAGE_SIZE;
+		iova += PAGE_SIZE;
+	}
+out:
+	spin_unlock(&domain->iotlb_lock);
+}
+
+static void vduse_domain_bounce(struct vduse_iova_domain *domain,
+				dma_addr_t iova, phys_addr_t orig,
+				size_t size, enum dma_data_direction dir)
+{
+	unsigned int offset = offset_in_page(iova);
+
+	while (size) {
+		struct page *p = vduse_domain_get_bounce_page(domain, iova);
+		size_t sz = min_t(size_t, PAGE_SIZE - offset, size);
+
+		WARN_ON(!p && dir == DMA_FROM_DEVICE);
+
+		if (p)
+			do_bounce(orig, page_address(p) + offset, sz, dir);
+
+		size -= sz;
+		orig += sz;
+		iova += sz;
+		offset = 0;
+	}
+}
+
+static dma_addr_t vduse_domain_alloc_iova(struct iova_domain *iovad,
+				unsigned long size, unsigned long limit)
+{
+	unsigned long shift = iova_shift(iovad);
+	unsigned long iova_len = iova_align(iovad, size) >> shift;
+	unsigned long iova_pfn;
+
+	if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
+		iova_len = roundup_pow_of_two(iova_len);
+	iova_pfn = alloc_iova_fast(iovad, iova_len, limit >> shift, true);
+
+	return iova_pfn << shift;
+}
+
+static void vduse_domain_free_iova(struct iova_domain *iovad,
+				dma_addr_t iova, size_t size)
+{
+	unsigned long shift = iova_shift(iovad);
+	unsigned long iova_len = iova_align(iovad, size) >> shift;
+
+	free_iova_fast(iovad, iova >> shift, iova_len);
+}
+
+dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
+				struct page *page, unsigned long offset,
+				size_t size, enum dma_data_direction dir,
+				unsigned long attrs)
+{
+	struct iova_domain *iovad = &domain->stream_iovad;
+	unsigned long limit = domain->bounce_size - 1;
+	phys_addr_t pa = page_to_phys(page) + offset;
+	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
+	int ret;
+
+	if (!iova)
+		return DMA_MAPPING_ERROR;
+
+	spin_lock(&domain->iotlb_lock);
+	ret = vhost_iotlb_add_range(domain->iotlb, (u64)iova,
+				    (u64)iova + size - 1,
+				    pa, dir_to_perm(dir));
+	spin_unlock(&domain->iotlb_lock);
+	if (ret) {
+		vduse_domain_free_iova(iovad, iova, size);
+		return DMA_MAPPING_ERROR;
+	}
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
+		vduse_domain_bounce(domain, iova, pa, size, DMA_TO_DEVICE);
+
+	return iova;
+}
+
+void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
+			dma_addr_t dma_addr, size_t size,
+			enum dma_data_direction dir, unsigned long attrs)
+{
+	struct iova_domain *iovad = &domain->stream_iovad;
+	struct vhost_iotlb_map *map;
+	phys_addr_t pa;
+
+	spin_lock(&domain->iotlb_lock);
+	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
+				      (u64)dma_addr + size - 1);
+	if (WARN_ON(!map)) {
+		spin_unlock(&domain->iotlb_lock);
+		return;
+	}
+	pa = map->addr;
+	vhost_iotlb_map_free(domain->iotlb, map);
+	spin_unlock(&domain->iotlb_lock);
+
+	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
+		vduse_domain_bounce(domain, dma_addr, pa,
+					size, DMA_FROM_DEVICE);
+
+	vduse_domain_free_iova(iovad, dma_addr, size);
+}
+
+void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
+				size_t size, dma_addr_t *dma_addr,
+				gfp_t flag, unsigned long attrs)
+{
+	struct iova_domain *iovad = &domain->consistent_iovad;
+	unsigned long limit = domain->iova_limit;
+	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
+	void *orig = alloc_pages_exact(size, flag);
+	int ret;
+
+	if (!iova || !orig)
+		goto err;
+
+	spin_lock(&domain->iotlb_lock);
+	ret = vhost_iotlb_add_range(domain->iotlb, (u64)iova,
+				    (u64)iova + size - 1,
+				    virt_to_phys(orig), VHOST_MAP_RW);
+	spin_unlock(&domain->iotlb_lock);
+	if (ret)
+		goto err;
+
+	*dma_addr = iova;
+
+	return orig;
+err:
+	*dma_addr = DMA_MAPPING_ERROR;
+	if (orig)
+		free_pages_exact(orig, size);
+	if (iova)
+		vduse_domain_free_iova(iovad, iova, size);
+
+	return NULL;
+}
+
+void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
+				void *vaddr, dma_addr_t dma_addr,
+				unsigned long attrs)
+{
+	struct iova_domain *iovad = &domain->consistent_iovad;
+	struct vhost_iotlb_map *map;
+	phys_addr_t pa;
+
+	spin_lock(&domain->iotlb_lock);
+	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
+				      (u64)dma_addr + size - 1);
+	if (WARN_ON(!map)) {
+		spin_unlock(&domain->iotlb_lock);
+		return;
+	}
+	pa = map->addr;
+	vhost_iotlb_map_free(domain->iotlb, map);
+	spin_unlock(&domain->iotlb_lock);
+
+	vduse_domain_free_iova(iovad, dma_addr, size);
+	free_pages_exact(phys_to_virt(pa), size);
+}
+
+static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
+{
+	struct vduse_iova_domain *domain = vmf->vma->vm_private_data;
+	unsigned long iova = vmf->pgoff << PAGE_SHIFT;
+	struct page *page;
+
+	if (!domain)
+		return VM_FAULT_SIGBUS;
+
+	if (iova < domain->bounce_size)
+		page = vduse_domain_alloc_bounce_page(domain, iova);
+	else
+		page = vduse_domain_get_mapping_page(domain, iova);
+
+	if (!page)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = page;
+
+	return 0;
+}
+
+static const struct vm_operations_struct vduse_domain_mmap_ops = {
+	.fault = vduse_domain_mmap_fault,
+};
+
+static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vduse_iova_domain *domain = file->private_data;
+
+	vma->vm_flags |= VM_DONTDUMP | VM_DONTEXPAND;
+	vma->vm_private_data = domain;
+	vma->vm_ops = &vduse_domain_mmap_ops;
+
+	return 0;
+}
+
+static int vduse_domain_release(struct inode *inode, struct file *file)
+{
+	struct vduse_iova_domain *domain = file->private_data;
+
+	vduse_domain_free_bounce_pages(domain, 0, domain->bounce_size);
+	put_iova_domain(&domain->stream_iovad);
+	put_iova_domain(&domain->consistent_iovad);
+	vhost_iotlb_free(domain->iotlb);
+	vfree(domain->bounce_pages);
+	kfree(domain);
+
+	return 0;
+}
+
+static const struct file_operations vduse_domain_fops = {
+	.mmap = vduse_domain_mmap,
+	.release = vduse_domain_release,
+};
+
+void vduse_domain_destroy(struct vduse_iova_domain *domain)
+{
+	fput(domain->file);
+}
+
+struct vduse_iova_domain *
+vduse_domain_create(unsigned long iova_limit, size_t bounce_size)
+{
+	struct vduse_iova_domain *domain;
+	struct file *file;
+	unsigned long bounce_pfns = PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
+
+	if (iova_limit <= bounce_size)
+		return NULL;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	domain->iotlb = vhost_iotlb_alloc(0, 0);
+	if (!domain->iotlb)
+		goto err_iotlb;
+
+	domain->iova_limit = iova_limit;
+	domain->bounce_size = PAGE_ALIGN(bounce_size);
+	domain->bounce_pages = vzalloc(bounce_pfns * sizeof(struct page *));
+	if (!domain->bounce_pages)
+		goto err_page;
+
+	file = anon_inode_getfile("[vduse-domain]", &vduse_domain_fops,
+				domain, O_RDWR);
+	if (IS_ERR(file))
+		goto err_file;
+
+	domain->file = file;
+	spin_lock_init(&domain->iotlb_lock);
+	init_iova_domain(&domain->stream_iovad,
+			IOVA_ALLOC_SIZE, IOVA_START_PFN);
+	init_iova_domain(&domain->consistent_iovad,
+			PAGE_SIZE, bounce_pfns);
+
+	return domain;
+err_file:
+	vfree(domain->bounce_pages);
+err_page:
+	vhost_iotlb_free(domain->iotlb);
+err_iotlb:
+	kfree(domain);
+	return NULL;
+}
+
+int vduse_domain_init(void)
+{
+	return iova_cache_get();
+}
+
+void vduse_domain_exit(void)
+{
+	iova_cache_put();
+}
diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_user/iova_domain.h
new file mode 100644
index 000000000000..9c85d8346626
--- /dev/null
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * MMU-based IOMMU implementation
+ *
+ * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
+ *
+ * Author: Xie Yongji <xieyongji@bytedance.com>
+ *
+ */
+
+#ifndef _VDUSE_IOVA_DOMAIN_H
+#define _VDUSE_IOVA_DOMAIN_H
+
+#include <linux/iova.h>
+#include <linux/dma-mapping.h>
+#include <linux/vhost_iotlb.h>
+
+struct vduse_iova_domain {
+	struct iova_domain stream_iovad;
+	struct iova_domain consistent_iovad;
+	struct page **bounce_pages;
+	size_t bounce_size;
+	unsigned long iova_limit;
+	struct vhost_iotlb *iotlb;
+	spinlock_t iotlb_lock;
+	struct file *file;
+};
+
+static inline struct file *
+vduse_domain_file(struct vduse_iova_domain *domain)
+{
+	return domain->file;
+}
+
+dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
+				struct page *page, unsigned long offset,
+				size_t size, enum dma_data_direction dir,
+				unsigned long attrs);
+
+void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
+			dma_addr_t dma_addr, size_t size,
+			enum dma_data_direction dir, unsigned long attrs);
+
+void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
+				size_t size, dma_addr_t *dma_addr,
+				gfp_t flag, unsigned long attrs);
+
+void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
+				void *vaddr, dma_addr_t dma_addr,
+				unsigned long attrs);
+
+void vduse_domain_destroy(struct vduse_iova_domain *domain);
+
+struct vduse_iova_domain *vduse_domain_create(unsigned long iova_limit,
+						size_t bounce_size);
+
+int vduse_domain_init(void);
+
+void vduse_domain_exit(void);
+
+#endif /* _VDUSE_IOVA_DOMAIN_H */
-- 
2.11.0

