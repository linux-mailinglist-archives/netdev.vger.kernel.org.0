Return-Path: <netdev+bounces-5513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F584711F5D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56366281684
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8F823D0;
	Fri, 26 May 2023 05:47:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8855241
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:47:15 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2E51BD;
	Thu, 25 May 2023 22:47:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d5f65a2f7so408725b3a.1;
        Thu, 25 May 2023 22:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685080024; x=1687672024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aKMfg1fHr2OSnJGRh9PC/RqpCNLsXjfCs8xZ/3DKhk=;
        b=BmFD4aUJPmEqKXrXWhOQ/s9gV3WbY9AQDVH4Z6IWJOiTooyBSk6OGmx//+EBiA1QjC
         7wempSXYAZanDs5r5PjpXnbwsBzGPE93m1xOOlVDG6dbWMO5IwrEvvSN91ktPkHCMwGW
         zIceiISirgOMXblsX2oRowb4Y++oO5yu43TMfDGEOxNGK8ay0cG5E+4j09gbYkIcM6jG
         nvdi0wRY9DmyhZCBNDeQelbgqAmrPQ9hPyIIOsliOLJG9PHWX5chz43zAFfG90efyVXT
         00aSq3u7F3c7cIOXk+oY/vLXKeCntIEV+jqhhDdpVUbBcKVRNkxn5ZW2EKIlDFXIVvvT
         qjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685080024; x=1687672024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aKMfg1fHr2OSnJGRh9PC/RqpCNLsXjfCs8xZ/3DKhk=;
        b=BvzqftFUwoVjsUztXoE1IWqzA4aswCKJOFWysTbbpLctDhiCBNs1yfbpVnq5VnMTN4
         u6RPAV1OrDina6vSutoh1MOxgeyf9/6uFzg0z5pDk0VR0TI7GZnz0O9C82qaQi0qHV5w
         mdrh0NuGQ++E7Y8WJW6Kvs7DlHGQ0dUOA/9SLv6Gp4nwOoHwjdL1adGiq/GgZDKwIuGW
         sYhiUi1IvVDaAtMU+Yh4oPkoICY/r/txUOYzE6hWBwPr56i+AwfNSAJGSkpdjbQGD2QE
         SwuKS5PqeSCNGjU5/yxg5bj3ksKzUGbw9aScMFIYsnTGItHWdIn6Mkayo6U1a3d1Iksi
         2gvQ==
X-Gm-Message-State: AC+VfDy072aSDiSTnz1+UaAJSMxV9rpPufiejRmllMQ5iuXskSTKhScr
	lqqY46tmtrZF6BYT0vkeZ8A=
X-Google-Smtp-Source: ACHHUZ7nCPPQO2FAtG/9EEZJcOORV5prAxpUNUZpAJ9rRcv9tbqMF0YLxC5O2GvRX9b4AG5b877RTg==
X-Received: by 2002:a05:6a21:6709:b0:10a:a0e1:96fa with SMTP id wh9-20020a056a21670900b0010aa0e196famr837654pzb.22.1685080023982;
        Thu, 25 May 2023 22:47:03 -0700 (PDT)
Received: from localhost.localdomain ([104.149.188.130])
        by smtp.gmail.com with ESMTPSA id b23-20020a6567d7000000b0050a0227a4bcsm1836485pgs.57.2023.05.25.22.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 22:47:02 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: jasowang@redhat.com,
	mst@redhat.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH net-next 4/5] virtio_ring: Introduce DMA pre-handler
Date: Fri, 26 May 2023 13:46:20 +0800
Message-Id: <20230526054621.18371-4-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230526054621.18371-1-liangchen.linux@gmail.com>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, DMA operations of virtio devices' data buffer are encapsulated
within the underlying virtqueue implementation. DMA map/unmap operations
are performed for each data buffer attached to/detached from the virtqueue,
which is transparent and invisible to the higher-level virtio device
drivers. This encapsulation makes it not viable for device drivers to
introduce certain mechanisms, such as page pool, that require explicit
management of DMA map/unmap. Therefore, by inserting a pre-handler before
the generic DMA map/unmap operations, virtio device drivers have the
opportunity to participate in DMA operations.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/virtio/virtio_ring.c | 73 +++++++++++++++++++++++++++++++++---
 include/linux/virtio.h       | 18 +++++++++
 2 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c5310eaf8b46..a99641260555 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -213,6 +213,9 @@ struct vring_virtqueue {
 	bool last_add_time_valid;
 	ktime_t last_add_time;
 #endif
+
+	/* DMA mapping Pre-handler for virtio device driver */
+	struct virtqueue_pre_dma_ops *pre_dma_ops;
 };
 
 static struct virtqueue *__vring_new_virtqueue(unsigned int index,
@@ -369,6 +372,19 @@ static dma_addr_t vring_map_one_sg(const struct vring_virtqueue *vq,
 		return (dma_addr_t)sg_phys(sg);
 	}
 
+	/* Allow virtio drivers to perform customized mapping operation, and
+	 * fallback to the generic path if it fails to handle the mapping.
+	 */
+	if (vq->pre_dma_ops && vq->pre_dma_ops->map_page) {
+		dma_addr_t addr;
+
+		addr = vq->pre_dma_ops->map_page(vring_dma_dev(vq),
+				sg_page(sg), sg->offset, sg->length,
+				direction, 0);
+		if (addr)
+			return addr;
+	}
+
 	/*
 	 * We can't use dma_map_sg, because we don't use scatterlists in
 	 * the way it expects (we don't guarantee that the scatterlist
@@ -432,6 +448,15 @@ static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
 
 	flags = virtio16_to_cpu(vq->vq.vdev, desc->flags);
 
+	if (vq->pre_dma_ops && vq->pre_dma_ops->unmap_page) {
+		if (vq->pre_dma_ops->unmap_page(vring_dma_dev(vq),
+					virtio64_to_cpu(vq->vq.vdev, desc->addr),
+					virtio32_to_cpu(vq->vq.vdev, desc->len),
+					(flags & VRING_DESC_F_WRITE) ?
+					DMA_FROM_DEVICE : DMA_TO_DEVICE, 0))
+			return;
+	}
+
 	dma_unmap_page(vring_dma_dev(vq),
 		       virtio64_to_cpu(vq->vq.vdev, desc->addr),
 		       virtio32_to_cpu(vq->vq.vdev, desc->len),
@@ -456,14 +481,22 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 				 extra[i].len,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	} else {
-		dma_unmap_page(vring_dma_dev(vq),
-			       extra[i].addr,
-			       extra[i].len,
-			       (flags & VRING_DESC_F_WRITE) ?
-			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
+		goto out;
+	} else if (vq->pre_dma_ops && vq->pre_dma_ops->unmap_page) {
+		if (vq->pre_dma_ops->unmap_page(vring_dma_dev(vq),
+					extra[i].addr,
+					extra[i].len,
+					(flags & VRING_DESC_F_WRITE) ?
+					DMA_FROM_DEVICE : DMA_TO_DEVICE, 0))
+			goto out;
 	}
 
+	dma_unmap_page(vring_dma_dev(vq),
+			extra[i].addr,
+			extra[i].len,
+			(flags & VRING_DESC_F_WRITE) ?
+			DMA_FROM_DEVICE : DMA_TO_DEVICE);
+
 out:
 	return extra[i].next;
 }
@@ -1206,10 +1239,19 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
+		if (vq->pre_dma_ops && vq->pre_dma_ops->unmap_page) {
+			if (vq->pre_dma_ops->unmap_page(vring_dma_dev(vq),
+						extra->addr,
+						extra->len,
+						(flags & VRING_DESC_F_WRITE) ?
+						DMA_FROM_DEVICE : DMA_TO_DEVICE, 0))
+				return;
+		}
 		dma_unmap_page(vring_dma_dev(vq),
 			       extra->addr, extra->len,
 			       (flags & VRING_DESC_F_WRITE) ?
 			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
+
 	}
 }
 
@@ -1223,6 +1265,15 @@ static void vring_unmap_desc_packed(const struct vring_virtqueue *vq,
 
 	flags = le16_to_cpu(desc->flags);
 
+	if (vq->pre_dma_ops && vq->pre_dma_ops->unmap_page) {
+		if (vq->pre_dma_ops->unmap_page(vring_dma_dev(vq),
+					le64_to_cpu(desc->addr),
+					le32_to_cpu(desc->len),
+					(flags & VRING_DESC_F_WRITE) ?
+					DMA_FROM_DEVICE : DMA_TO_DEVICE, 0))
+			return;
+	}
+
 	dma_unmap_page(vring_dma_dev(vq),
 		       le64_to_cpu(desc->addr),
 		       le32_to_cpu(desc->len),
@@ -2052,6 +2103,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->packed_ring = true;
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->pre_dma_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2541,6 +2593,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 #endif
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
+	vq->pre_dma_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2945,4 +2998,12 @@ const struct vring *virtqueue_get_vring(const struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring);
 
+/* The virtio device driver can register its own DMA map/unmap pre-handler. */
+void virtqueue_register_pre_dma_ops(struct virtqueue *vq,
+		struct virtqueue_pre_dma_ops *pre_dma_ops)
+{
+	to_vvq(vq)->pre_dma_ops = pre_dma_ops;
+}
+EXPORT_SYMBOL_GPL(virtqueue_register_pre_dma_ops);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b93238db94e3..1d5755b5e03f 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gfp.h>
+#include <linux/dma-map-ops.h>
 
 /**
  * struct virtqueue - a queue to register buffers for sending or receiving.
@@ -203,4 +204,21 @@ void unregister_virtio_driver(struct virtio_driver *drv);
 #define module_virtio_driver(__virtio_driver) \
 	module_driver(__virtio_driver, register_virtio_driver, \
 			unregister_virtio_driver)
+/**
+ * struct virtqueue_pre_dma_ops - DMA pre-handler for virtio device driver
+ * @map_page: map a single page of memory for DMA
+ * @unmap_page: unmap a single page of memory for DMA
+ */
+struct virtqueue_pre_dma_ops {
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			unsigned long offset, size_t size,
+			enum dma_data_direction dir, unsigned long attrs);
+	bool (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+			size_t size, enum dma_data_direction dir,
+			unsigned long attrs);
+};
+
+void virtqueue_register_pre_dma_ops(struct virtqueue *vq,
+		struct virtqueue_pre_dma_ops *pre_dma_ops);
+
 #endif /* _LINUX_VIRTIO_H */
-- 
2.31.1


