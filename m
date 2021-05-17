Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5328E382904
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhEQJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbhEQJ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:58:02 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C70C061355
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m190so4296280pga.2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7UPVFphWKlLnjm3KyM/5Ztd/5bHILYcjpqPK+EYiek=;
        b=RqSNe4hMvGp9UfE8S1qzkSieY6l3c93RCMADFsjRIZsBtyh99/cj2FPeVRp7Ujbzrh
         IatlXMNLYYdNPseqmd/DvjECoj34MQvEHFQ3TKvgrJxCCeQDh9xgE7z5BmHIIYXzQatF
         SYfJm2jbzK3fgG6fyq/X67rUF9iaAHcsy6YpySJD02Qn0u8uwAggbwTgDh5BSijYEK+Q
         H45s+Lvwdi9pGSMCoXUvj1CvugMAyuhOMYv1DOpTlyiV0MG1jb/yZi2xbVIQp7e1Zzot
         W5BphNOPH24k/0p6K425HrIeFhHD4FxFAbFDQTlbKonwfPl89KP9iAcB3TQAF762/lHl
         7i2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7UPVFphWKlLnjm3KyM/5Ztd/5bHILYcjpqPK+EYiek=;
        b=ZkzZ1yE0QD1PgW5zxsGlbQheoYxdjhXJxJ3kL0yrhYMqdFueAOT6Njn1BEof2RhETN
         Myfv8/S5FnZjUhOt9+bRDCxuhoBGQzyoax4+kdiAcgUW/o90WA+LSdL4V7/XMJcxL3Ik
         es819ij8gcT4ryVUpLOr+xmMDRsEe7YLjAO4w1/xz4BDaxtIi5q0ValvujbouPWIRM5K
         RVpzELHkkYRO2ZIEjL0h3iImN0K0weLgNpSXFmZe0IMH3e72M6hXgoeusRej0iv9mfxO
         akqm/ILHEA/A75hxl8N2pR353vUmMe4HrOVnRdXkBf+F2cKOjbfPAqdeSAaFsG7rTjTJ
         9gHw==
X-Gm-Message-State: AOAM531sS2AFfy9F9egkYB22ctO84W4NGVDaqngmBPvYXIlqmt4xbzw1
        I7VB6DgwLxfYNszenzMB5VaM
X-Google-Smtp-Source: ABdhPJwi1jtHgEPXsKetT04pmQxRSuMCRZDYLTHI9A4lskDUMumxaMX4VrgnB1EH6fiq4OHcD/S+bg==
X-Received: by 2002:a05:6a00:22c1:b029:2dc:edbe:5e9 with SMTP id f1-20020a056a0022c1b02902dcedbe05e9mr2036267pfj.51.1621245387862;
        Mon, 17 May 2021 02:56:27 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id o186sm4930765pfg.170.2021.05.17.02.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:27 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 08/12] vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
Date:   Mon, 17 May 2021 17:55:09 +0800
Message-Id: <20210517095513.850-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The upcoming patch is going to support VA mapping/unmapping.
So let's factor out the logic of PA mapping/unmapping firstly
to make the code more readable.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 53 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1dd8e07554f8..3c773654bf40 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -498,7 +498,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
-static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
@@ -520,6 +520,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+{
+	return vhost_vdpa_pa_unmap(v, start, last);
+}
+
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -600,37 +605,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
 	}
 }
 
-static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
-					   struct vhost_iotlb_msg *msg)
+static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
+			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
 	unsigned long lock_limit, sz2pin, nchunks, i;
-	u64 iova = msg->iova;
+	u64 start = iova;
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
-	    msg->iova + msg->size - 1 > v->range.last)
-		return -EINVAL;
-
-	if (vhost_iotlb_itree_first(iotlb, msg->iova,
-				    msg->iova + msg->size - 1))
-		return -EEXIST;
-
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
 
-	if (msg->perm & VHOST_ACCESS_WO)
+	if (perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	npages = PAGE_ALIGN(size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
@@ -644,7 +640,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		goto unlock;
 	}
 
-	cur_base = msg->uaddr & PAGE_MASK;
+	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
 	nchunks = 0;
 
@@ -675,7 +671,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     perm);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -704,7 +700,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -723,13 +719,32 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		vhost_vdpa_unmap(v, start, size);
 	}
 unlock:
 	mmap_read_unlock(dev->mm);
 free:
 	free_page((unsigned long)page_list);
 	return ret;
+
+}
+
+static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb_msg *msg)
+{
+	struct vhost_dev *dev = &v->vdev;
+	struct vhost_iotlb *iotlb = dev->iotlb;
+
+	if (msg->iova < v->range.first ||
+	    msg->iova + msg->size - 1 > v->range.last)
+		return -EINVAL;
+
+	if (vhost_iotlb_itree_first(iotlb, msg->iova,
+				    msg->iova + msg->size - 1))
+		return -EEXIST;
+
+	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
+				 msg->perm);
 }
 
 static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
-- 
2.11.0

