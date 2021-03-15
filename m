Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF72A33AB16
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCOFiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCOFiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 01:38:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B37BC061762
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 30so10165477ple.4
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZinwHoffrnXP3ywQjEhLA6Z7sImGc8X+vWD+k+yVcXw=;
        b=jipQjp0vAxMfYHmaj5s0kWN9Ke/4CsNxigw7n7A+2C7XFhG+ZbANQFOyP1z77EE2gG
         D1CrlOJtUQell0Q0O7/KhFhhg0FUMf1HI1/+D7/jipA+myFQwTySahEtiPG43luqyntR
         o8Z1zfIw7kJ8sxezd5jBydusWziXzXjiQdvFexL5PeEmkILq6lMfjX/3Nihae952Vmom
         iPj1LFIc/qHygjtZVY7w1+p5jsxuJIvVmoC4UKPOD3JXd4x1HLnDGMNxtOToK34nEb7W
         u3mKYXALhOv64TaqFUWCio77ncAhbrzr5nMcuFfgcSmx3u89Y5f9ifbL/0M7CkNGEamD
         /HIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZinwHoffrnXP3ywQjEhLA6Z7sImGc8X+vWD+k+yVcXw=;
        b=VkWgHLWb7SY9BcUdVMH52alXkmMizPdLITf8zYrhM+kR8zDawTWBLHqv3RVVCCzujY
         y05LxhorLVPqwzaPH9dqTwsqtAqw3dnHqlGIBBjzovrnp+xW6OHG7QpX6LkwDEH/OKly
         34wjCh4xGqjCZglW/m8KjPkt0xKfdtQvp+bUa13EYiOUdL3fC7XH465mfZpQheh0pvxl
         N0/8403CCvrsvLey0EBoqrgCXNWVfXga/s0zMvwpxtnlTzy5EhvwcrgQjUd+TSc3TWWT
         YBm4ee0kzXmpTUaZmze3pChpe5eQvkffu0/Kfrwc0XHn4KPJNKCZNuJm9BXf1ntUqFkm
         rCCw==
X-Gm-Message-State: AOAM530xRGkEdsKC8WHHiobQua1lSndVoOkE9Vhc2gTLi4OoG/FFhvYL
        91ZZt82UStyAn4s/eptnOJ8U
X-Google-Smtp-Source: ABdhPJz3eltTXJ6/U1MHiydOs5RJgb/pCjjpSyDi9M2ABZX4mV6uQbf0s9qvIlne9yl8ovrJ57QHKg==
X-Received: by 2002:a17:902:74c4:b029:e4:9e16:18d9 with SMTP id f4-20020a17090274c4b02900e49e1618d9mr10219721plt.21.1615786685259;
        Sun, 14 Mar 2021 22:38:05 -0700 (PDT)
Received: from localhost ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id b22sm12821599pff.173.2021.03.14.22.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 22:38:04 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 04/11] vhost-iotlb: Add an opaque pointer for vhost IOTLB
Date:   Mon, 15 Mar 2021 13:37:14 +0800
Message-Id: <20210315053721.189-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315053721.189-1-xieyongji@bytedance.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for vhost IOTLB. And introduce
vhost_iotlb_add_range_ctx() to accept it.

Suggested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
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

