Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8841F3828FA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhEQJ6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbhEQJ5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:57:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD76C061763
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3400311pjv.1
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WWAi/i4+n9XG5D57vjCca2tNocYxaQJOYj5KH2bJ384=;
        b=1gw758w4orgpYuGg4qlVZ1ufUErcwuFPa6rGxGKNeCcUdBT2DBFUOZgjjjHaru9QgZ
         24Uyd+UWCUuLzaw9E42011Bl3nrphZj8tHi+w2dt1N95LK5Wsa8rVPZEyA3wd0tCL/YZ
         Q0Gb9G8Hrf+Ebn4e//D1+XOMJcJhst7YPhAINXNngxWyGUjrRpi8ZZGq+c6nRSHs9p2E
         RgSSWnemUMQge32qOTb5HFKnkujL0C/9X+8IUxectIdGr0wzBCe6yu4VdFtNi0Gh/irn
         lTbzi2UyOj7hY0zngADRRghjHYcPSHE7wF5oJ3y+4sJ65xbDRl6aOnUyYKIut3Yf9iWP
         tuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWAi/i4+n9XG5D57vjCca2tNocYxaQJOYj5KH2bJ384=;
        b=YlkrRJMSxnYYqiTRDaHKiocnASgPE6JYdK4EbQgx75KTpirMj6aOWz0Ayp4jjvjuZT
         1p+ZkE38XymcwxggtKcEES2ngYJCIld2arI1m6+/LaEoBWe3eCnO6IouintbHW0evs/2
         CVBiXQzGiN7iIlstqc80och4lzPSVi7JZY8gTF5AwHg0E+bJb8bEB2cxsiI+egSZ9HTq
         0eaT27HVE8WpCq3i8/D+fByGlT3+m7Zx5zjKE+i6eEXCUzlCB0GVqprQmdTSX9qHJMJF
         CCFUZH7e+m3ujDEqxNfG29ajzDwFrYYGUxgyOHui2le/+IFA/57766QiTjspAb9nGRyV
         OBpw==
X-Gm-Message-State: AOAM531DVJa9zAs5aUbm58Tf6tZO/ViV863oEtioL0UCCcGoWnuwhXoV
        2wYDkyfBpG0McDBfibFAsvr6
X-Google-Smtp-Source: ABdhPJysOrc8SUm7dy3uINE+H+uKlr2ajo8HgNjhnimd4/k3NX9xtMHO7OR34WrKJCrjN10kcGUv+Q==
X-Received: by 2002:a17:90a:4216:: with SMTP id o22mr25979551pjg.3.1621245380091;
        Mon, 17 May 2021 02:56:20 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id i5sm9478706pfd.159.2021.05.17.02.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:19 -0700 (PDT)
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
Subject: [PATCH v7 06/12] vhost-iotlb: Add an opaque pointer for vhost IOTLB
Date:   Mon, 17 May 2021 17:55:07 +0800
Message-Id: <20210517095513.850-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
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

