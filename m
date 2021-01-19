Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7A32FB418
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbhASFYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389433AbhASFHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:07:03 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F373C06179E
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id p15so10893429pjv.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0BQoH5e6Vo5VKCH7jA0/hn3YTplKrX7vVJZ+TW7uaHc=;
        b=K3k9qs+WXjOyCB8k3DeH7IByz/uin6qD6OIudWLS1ha3Z8PRpAjOjBDpsSL+d03lFz
         BaP3UCSIlJzrxZDdwqU1jbUoS433o82gkxC6+OVQeudTLuY1D31eMPIwtpVOr4RTnAMf
         2+aYLFv2VYgCEwUmL6mReu0kt6Dsl6Bw3RKm6L6MSm4XK4uKHpoaUEEjY+3RueLJS91E
         P/jEemmTTp7V5+WtJWg7Ill7MxNhj95VAl9/GDkW18m4ntW6T7KtZ0ShuPu44ziTjr+B
         JglCozsMGr5ZN8kngs8xDgQ4ydeIHlKbYsYvOdWB5Lr9GgQGsrn1dXziQRQOD44SrNgP
         agUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0BQoH5e6Vo5VKCH7jA0/hn3YTplKrX7vVJZ+TW7uaHc=;
        b=kU97QMV6pHS3l9476OKsdKC/sRSLShHs6XCai8NT3qPvOx56TKjkpBRY9AR3UVlR0Z
         /wtmuUQiNa0Dc/MYstdF5UW0hG+JyhpXQEuZSirPINe3Ot6RMtEqEfRgx6JLD6rMza+g
         ZFYZ+QedVGuVQVIHrOR8jHWlgKk5UOfWW3oa4gy/pF/w6hzNHvy8k5SRJbfyCzFWui/I
         mB6lgZLVZhP8YSToLYugRp6aClNZFbRO/9LQOdb5OfgQI5RLvNGB43z20UOCsHsP2aVg
         gSCLGnjtGTqduJF0IlKW2z1WLr+9p6RX0AO5IIiu1VnX4chqrjsY8etkMqOxXaUi+Kwm
         HfAA==
X-Gm-Message-State: AOAM531ZU2zzBISSCDTPSzYOc3A0gpVPxRobVSHZ+nn6JCoPeDj7bq0P
        WViJ7SJM6J/YWw2tA0DbMaGV
X-Google-Smtp-Source: ABdhPJyHdlGs0VLY6eFat3mjD+9C9MAxndXPX0Va3DV4XryieB4S9NGP/Q3yK5UUFLJm7wemV3wgcA==
X-Received: by 2002:a17:902:c94d:b029:de:9b70:d886 with SMTP id i13-20020a170902c94db02900de9b70d886mr2851805pla.5.1611032696610;
        Mon, 18 Jan 2021 21:04:56 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id gf23sm1052752pjb.48.2021.01.18.21.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:56 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 06/11] vhost-vdpa: Add an opaque pointer for vhost IOTLB
Date:   Tue, 19 Jan 2021 12:59:15 +0800
Message-Id: <20210119045920.447-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for vhost IOTLB to store the
corresponding vma->vm_file and offset on the DMA mapping.

It will be used in VDUSE case later.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++---
 drivers/vhost/iotlb.c            |  5 ++-
 drivers/vhost/vdpa.c             | 66 +++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.c            |  4 +--
 include/linux/vdpa.h             |  3 +-
 include/linux/vhost_iotlb.h      |  8 ++++-
 6 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 03c796873a6b..1ffcef67954f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -279,7 +279,7 @@ static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page,
 	 */
 	spin_lock(&vdpasim->iommu_lock);
 	ret = vhost_iotlb_add_range(iommu, pa, pa + size - 1,
-				    pa, dir_to_perm(dir));
+				    pa, dir_to_perm(dir), NULL);
 	spin_unlock(&vdpasim->iommu_lock);
 	if (ret)
 		return DMA_MAPPING_ERROR;
@@ -317,7 +317,7 @@ static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
 
 		ret = vhost_iotlb_add_range(iommu, (u64)pa,
 					    (u64)pa + size - 1,
-					    pa, VHOST_MAP_RW);
+					    pa, VHOST_MAP_RW, NULL);
 		if (ret) {
 			*dma_addr = DMA_MAPPING_ERROR;
 			kfree(addr);
@@ -625,7 +625,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
 	     map = vhost_iotlb_itree_next(map, start, last)) {
 		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
-					    map->last, map->addr, map->perm);
+					    map->last, map->addr,
+					    map->perm, NULL);
 		if (ret)
 			goto err;
 	}
@@ -639,14 +640,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 }
 
 static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
-			   u64 pa, u32 perm)
+			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
 	spin_lock(&vdpasim->iommu_lock);
 	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
-				    perm);
+				    perm, NULL);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0fd3f87e913c..3bd5bd06cdbc 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -42,13 +42,15 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
  * @last: last of IOVA range
  * @addr: the address that is mapped to @start
  * @perm: access permission of this range
+ * @opaque: the opaque pointer for the IOTLB mapping
  *
  * Returns an error last is smaller than start or memory allocation
  * fails
  */
 int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 			  u64 start, u64 last,
-			  u64 addr, unsigned int perm)
+			  u64 addr, unsigned int perm,
+			  void *opaque)
 {
 	struct vhost_iotlb_map *map;
 
@@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
+	map->opaque = opaque;
 
 	iotlb->nmaps++;
 	vhost_iotlb_itree_insert(map, &iotlb->root);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 36b6950ba37f..e83e5be7cec8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -488,6 +488,7 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb_file *iotlb_file;
 	struct vhost_iotlb_map *map;
 	struct page *page;
 	unsigned long pfn, pinned;
@@ -504,6 +505,10 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 			}
 			atomic64_sub(map->size >> PAGE_SHIFT,
 					&dev->mm->pinned_vm);
+		} else if (map->opaque) {
+			iotlb_file = (struct vhost_iotlb_file *)map->opaque;
+			fput(iotlb_file->file);
+			kfree(iotlb_file);
 		}
 		vhost_iotlb_map_free(iotlb, map);
 	}
@@ -540,8 +545,8 @@ static int perm_to_iommu_flags(u32 perm)
 	return flags | IOMMU_CACHE;
 }
 
-static int vhost_vdpa_map(struct vhost_vdpa *v,
-			  u64 iova, u64 size, u64 pa, u32 perm)
+static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
+			  u64 size, u64 pa, u32 perm, void *opaque)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
@@ -549,12 +554,12 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 	int r = 0;
 
 	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
-				  pa, perm);
+				  pa, perm, opaque);
 	if (r)
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
@@ -591,6 +596,51 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
 	}
 }
 
+static int vhost_vdpa_sva_map(struct vhost_vdpa *v,
+			      u64 iova, u64 size, u64 uaddr, u32 perm)
+{
+	u64 offset, map_size, map_iova = iova;
+	struct vhost_iotlb_file *iotlb_file;
+	struct vm_area_struct *vma;
+	int ret;
+
+	while (size) {
+		vma = find_vma(current->mm, uaddr);
+		if (!vma) {
+			ret = -EINVAL;
+			goto err;
+		}
+		map_size = min(size, vma->vm_end - uaddr);
+		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
+		iotlb_file = NULL;
+		if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
+			iotlb_file = kmalloc(sizeof(*iotlb_file), GFP_KERNEL);
+			if (!iotlb_file) {
+				ret = -ENOMEM;
+				goto err;
+			}
+			iotlb_file->file = get_file(vma->vm_file);
+			iotlb_file->offset = offset;
+		}
+		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
+					perm, iotlb_file);
+		if (ret) {
+			if (iotlb_file) {
+				fput(iotlb_file->file);
+				kfree(iotlb_file);
+			}
+			goto err;
+		}
+		size -= map_size;
+		uaddr += map_size;
+		map_iova += map_size;
+	}
+	return 0;
+err:
+	vhost_vdpa_unmap(v, iova, map_iova - iova);
+	return ret;
+}
+
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 					   struct vhost_iotlb_msg *msg)
 {
@@ -615,8 +665,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		return -EEXIST;
 
 	if (vdpa->sva)
-		return vhost_vdpa_map(v, msg->iova, msg->size,
-				      msg->uaddr, msg->perm);
+		return vhost_vdpa_sva_map(v, msg->iova, msg->size,
+					  msg->uaddr, msg->perm);
 
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
@@ -671,7 +721,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     msg->perm, NULL);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -700,7 +750,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, msg->perm, NULL);
 out:
 	if (ret) {
 		if (nchunks) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a262e12c6dc2..120dd5b3c119 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1104,7 +1104,7 @@ static int vhost_process_iotlb_msg(struct vhost_dev *dev,
 		vhost_vq_meta_reset(dev);
 		if (vhost_iotlb_add_range(dev->iotlb, msg->iova,
 					  msg->iova + msg->size - 1,
-					  msg->uaddr, msg->perm)) {
+					  msg->uaddr, msg->perm, NULL)) {
 			ret = -ENOMEM;
 			break;
 		}
@@ -1450,7 +1450,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 					  region->guest_phys_addr +
 					  region->memory_size - 1,
 					  region->userspace_addr,
-					  VHOST_MAP_RW))
+					  VHOST_MAP_RW, NULL))
 			goto err;
 	}
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index f86869651614..b264c627e94b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -189,6 +189,7 @@ struct vdpa_iova_range {
  *				@size: size of the area
  *				@pa: physical address for the map
  *				@perm: device access permission (VHOST_MAP_XX)
+ *				@opaque: the opaque pointer for the mapping
  *				Returns integer: success (0) or error (< 0)
  * @dma_unmap:			Unmap an area of IOVA (optional but
  *				must be implemented with dma_map)
@@ -243,7 +244,7 @@ struct vdpa_config_ops {
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm);
+		       u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
 
 	/* Free device resources */
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 6b09b786a762..66a50c11c8ca 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -4,6 +4,11 @@
 
 #include <linux/interval_tree_generic.h>
 
+struct vhost_iotlb_file {
+	struct file *file;
+	u64 offset;
+};
+
 struct vhost_iotlb_map {
 	struct rb_node rb;
 	struct list_head link;
@@ -17,6 +22,7 @@ struct vhost_iotlb_map {
 	u32 perm;
 	u32 flags_padding;
 	u64 __subtree_last;
+	void *opaque;
 };
 
 #define VHOST_IOTLB_FLAG_RETIRE 0x1
@@ -30,7 +36,7 @@ struct vhost_iotlb {
 };
 
 int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
-			  u64 addr, unsigned int perm);
+			  u64 addr, unsigned int perm, void *opaque);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
 
 struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags);
-- 
2.11.0

