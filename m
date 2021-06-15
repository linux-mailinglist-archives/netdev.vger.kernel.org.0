Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AFB3A827C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhFOOTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhFOOSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:18:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912F6C061157
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h1so8544367plt.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WWAi/i4+n9XG5D57vjCca2tNocYxaQJOYj5KH2bJ384=;
        b=0kIA76yEil4BDyN3USnHD3/M8FrPXcpFiBtM5SrfGm4D/hRLIWWQevjzMrmXkvkdwU
         /I8AKMWCkHdw2qTuchBfN/PK2PZZLJMcsPq6LBQFkREk6RWRwnzts6osF//EZXIafzq0
         annTM6mRM+CObk1LmodpcuGI18iPMdrO+f07wL2i7sL4hExnopN7djnuXypf9qHNytXJ
         GbZ58bvDW/a2OGejh65bmDZlKAV+279i3TTA8RA+It3vMuXrP07HIIzP9P/tUf0O5Ghx
         ygd5K2GEyaRP+PSFqmHdZRFnbeBqy6jOJ+pho5sg6ufX4iyz0SatX81p0eMgUcrnXIGv
         ohrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWAi/i4+n9XG5D57vjCca2tNocYxaQJOYj5KH2bJ384=;
        b=rOWmbEbEom2fzFvItF9SwhojqQdDd/DK0YrOf/SCiOWvziK9cehOzahkFn2VdLNkLk
         MklOptP4RJTmluB+mfnghdoddxgJpEvcgdESHSJUXh86YgaBsQb3ZOqKanK42oYG8XB6
         skMFHwvriQd3XaYZhUPJFTc40QnmKHO1v/S76zRCJCO551VCFfg6SbanfZG7UstQdYlF
         o8NwgvJULBl8sTIh9bz/WhN+K3onOb9F/GDiTMUcmi1t1YV+y3SJc8Y5FAsP6V3BjSBH
         pB3OrwLcHopDy9BDcEtNUa/Y47c3LCZeu4EhWUFXT6dCVS7vBv/uHmdBAGIvePlg/Ycv
         Uong==
X-Gm-Message-State: AOAM530h5Wnj/XjY8i5YL7R46S+wZTNx8kKvxU3ETAHKnaZH8AH/V8Hn
        zE4pTtUr3kVMVuGaPUBeF5tE
X-Google-Smtp-Source: ABdhPJwW+q5dHWJSz6MNIvxr3iew20vYFe9rQ1otKyLj3TsWzRln7lNFm51HBugcs9X5HKNDyYkcuA==
X-Received: by 2002:a17:90a:6482:: with SMTP id h2mr5018877pjj.188.1623766451749;
        Tue, 15 Jun 2021 07:14:11 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id f18sm2692741pjq.48.2021.06.15.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:14:11 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 04/10] vhost-iotlb: Add an opaque pointer for vhost IOTLB
Date:   Tue, 15 Jun 2021 22:13:25 +0800
Message-Id: <20210615141331.407-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for vhost IOTLB. And introduce
vhost_iotlb_add_range_ctx() to accept it.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/iotlb.c       | 20 ++++++++++++++++----
 include/linux/vhost_iotlb.h |  3 +++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0fd3f87e913c..5c99e1112cbb 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -36,19 +36,21 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
 
 /**
- * vhost_iotlb_add_range - add a new range to vhost IOTLB
+ * vhost_iotlb_add_range_ctx - add a new range to vhost IOTLB
  * @iotlb: the IOTLB
  * @start: start of the IOVA range
  * @last: last of IOVA range
  * @addr: the address that is mapped to @start
  * @perm: access permission of this range
+ * @opaque: the opaque pointer for the new mapping
  *
  * Returns an error last is smaller than start or memory allocation
  * fails
  */
-int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
-			  u64 start, u64 last,
-			  u64 addr, unsigned int perm)
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
+			      u64 start, u64 last,
+			      u64 addr, unsigned int perm,
+			      void *opaque)
 {
 	struct vhost_iotlb_map *map;
 
@@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
+	map->opaque = opaque;
 
 	iotlb->nmaps++;
 	vhost_iotlb_itree_insert(map, &iotlb->root);
@@ -80,6 +83,15 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_iotlb_add_range_ctx);
+
+int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
+			  u64 start, u64 last,
+			  u64 addr, unsigned int perm)
+{
+	return vhost_iotlb_add_range_ctx(iotlb, start, last,
+					 addr, perm, NULL);
+}
 EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
 
 /**
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 6b09b786a762..2d0e2f52f938 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -17,6 +17,7 @@ struct vhost_iotlb_map {
 	u32 perm;
 	u32 flags_padding;
 	u64 __subtree_last;
+	void *opaque;
 };
 
 #define VHOST_IOTLB_FLAG_RETIRE 0x1
@@ -29,6 +30,8 @@ struct vhost_iotlb {
 	unsigned int flags;
 };
 
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb, u64 start, u64 last,
+			      u64 addr, unsigned int perm, void *opaque);
 int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
-- 
2.11.0

