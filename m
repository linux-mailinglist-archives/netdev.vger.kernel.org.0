Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00653FB815
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhH3OXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbhH3OXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:23:18 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69241C061764
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:22:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w7so12449332pgk.13
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=diFMdOjfYo6h4zJjyD4SVBR9esxDRufQId7nejSxKj0=;
        b=hcYZ3bu/iTv3nXHzdb6IZ+Jz0ImD01FH6mxyeyemAtLnIRQzin3GmJV6HdZ5CqGj8b
         4ztTPPs4YIdl9m8da97tlK52AFnl2gSBJFkWKuMiGMDb9p9X9NIICMr2z8HLWHNTZwqm
         7Sjk/Z4e3tPNHZx8CQldNGPoxabjp5FtpPaBRK4tuHH9xJJptAq9jvw6+fDXsyU3bMz1
         +lqVTP48kweKiJpuJcuKuHbgk7R1dT3L1v2IWN4uG5+M62fybZ9kOE1VR93bRrxTGLG3
         QfzsnfrhuzEbcbQ87CTEozvmFm99ARCVi2kFGM87MLFVN7VD6jZ9g6ZPN9Ta2f4mVx/U
         ZVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=diFMdOjfYo6h4zJjyD4SVBR9esxDRufQId7nejSxKj0=;
        b=ZLtW27mfeA98YvWcDjgd3RWSt5uOlje43eHbhe9ECkPqcfyxwBfq4HIYUjaCDHXrcj
         viDpRzAZCwbbSu4aBwbzM6wUPlH6lAwqECWitqc3QfEx0G6pvDVCWT3zQLllW+shRYoj
         C0ju8eg+suTOBVjMx64LazhmJ0JxuyG1V77AyxWAWxByrE2AG+iFR4tknfBGlUKhVvyh
         vg93oeDGsmEJYsFmwgYlpStv6vPGI3yqSSbVzNcSZhto/LNwPmczj2g/p8BhZhs3mvjm
         4/5lt0F8ZqIa/HaXJlOnD8EmQAruET7oZpzQr+tod/YP0OXihaXlvHiLkB8zUq9p2msE
         H4Hg==
X-Gm-Message-State: AOAM532qxJAZO8sIbo7BxtGEZANUXtj3Oiq+ZuEYr1stOTImkzG/WKE7
        1ZaTRnM5eVmxvzl0IfNAaZe7
X-Google-Smtp-Source: ABdhPJyQB5IJXUEF93RbI9/KIBQuYghvxo2mARtY46/TkN9afeqhYJZUQ2bikAHZ0mSSu+yH91lsog==
X-Received: by 2002:a63:5b08:: with SMTP id p8mr22233395pgb.28.1630333342976;
        Mon, 30 Aug 2021 07:22:22 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id a7sm17128137pga.34.2021.08.30.07.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:22:22 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 08/13] vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
Date:   Mon, 30 Aug 2021 22:17:32 +0800
Message-Id: <20210830141737.181-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
References: <20210830141737.181-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for DMA mapping.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 6 +++---
 drivers/vhost/vdpa.c             | 2 +-
 include/linux/vdpa.h             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index f292bb05d6c9..a70fd2a08ff1 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -555,14 +555,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 }
 
 static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
-			   u64 pa, u32 perm)
+			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
-				    perm);
+	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
+					pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ab39805ecff1..ba030150b4b6 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -571,7 +571,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index e1eae8c7483d..f3014aaca47e 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -270,7 +270,7 @@ struct vdpa_config_ops {
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm);
+		       u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
 
 	/* Free device resources */
-- 
2.11.0

