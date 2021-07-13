Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4143C6C77
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhGMIuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbhGMIum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:50:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E92C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m83so11256319pfd.0
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2fP/MAmI7gUka5e/DKUQ2mjQlxJxe0/QRKPw5yBwyTk=;
        b=rpVEQUV1X70OmbrrQTJJKvk5vCPqC4uyyQYqM8mgOg9WDN/eKRObLhREIgC9AhlQtG
         eUZsoe1ZtDcx9fRxn5K5cTmakEDk81uPA+xScHZGg3Tqu81c80BChtmTqJDJYMUUT2FX
         I8vD0sFKqshhBkFve+LFV2d7iGakKJ6UO++oA6/QFcNuQGOsSjYmiPWVYrZl3U10Hqmm
         N6egKhnknsyBTg02r1Hz+54X/yG9BUJz2HuqTsK2D2UErp3uOrJUQlLV7QFYJqAnHhic
         z3Jy2j8PSswSLNBDJg5a+jUolEiDfEm0gqiykb9N4UFR//SYSeYkWWUQ83/UgrjRRwug
         POjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2fP/MAmI7gUka5e/DKUQ2mjQlxJxe0/QRKPw5yBwyTk=;
        b=TH7ziiXnDoDVR+BgfP7uZMHS2Xnr1yTxmTSq6Rjgj17EDOUVEK4A9+ug6LkyPAVEvi
         JNNkMW3UA4EpMJIKNuVhwtRGbqh/xYMtjSpWNdTgAZzsG1FsjHHXHRa9rVfACaxb9Zmh
         VD46mLdXnT7pAHW/dyNxz2/k79P4o/8CLRQYXJ/wqRPeewGoF6+E5UWKsB0tL2EdLSYL
         Tc7n3VWNxie8xGMlxecwr6jP7mEWqBrMxVsVDXH+AVVZnNJQbr37R+8wV3rxYib9XcH0
         rUq/P7/tZW1rIM3sN7NH1P47kIlZp/gtPRZm3b+nvCjOMybj9SIIa7+Jsy2QN6W7Is62
         USEw==
X-Gm-Message-State: AOAM5329mSkKzx4Sq8Jnaa8nQrYmx2RyjozT8a31NDt76sjhUyVUGz/5
        L334OvTaavgeukg9/wTd9uxF
X-Google-Smtp-Source: ABdhPJyBkUB9QNAx3I8j5SvXv3BBPI0eQfjjVmRO0YZO2mJNlMqzj7TJp+Nb22Xnek5hLerTt0F38A==
X-Received: by 2002:a65:5c89:: with SMTP id a9mr3285855pgt.207.1626166072648;
        Tue, 13 Jul 2021 01:47:52 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id e2sm21544494pgh.5.2021.07.13.01.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:52 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 08/17] virtio_config: Add a return value to reset function
Date:   Tue, 13 Jul 2021 16:46:47 +0800
Message-Id: <20210713084656.232-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a return value to reset function so that we can
handle the reset failure later. No functional changes.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 arch/um/drivers/virtio_uml.c             | 4 +++-
 drivers/platform/mellanox/mlxbf-tmfifo.c | 4 +++-
 drivers/remoteproc/remoteproc_virtio.c   | 4 +++-
 drivers/s390/virtio/virtio_ccw.c         | 6 ++++--
 drivers/virtio/virtio_pci_legacy.c       | 4 +++-
 drivers/virtio/virtio_pci_modern.c       | 4 +++-
 drivers/virtio/virtio_vdpa.c             | 4 +++-
 include/linux/virtio_config.h            | 3 ++-
 8 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 4412d6febade..ca02deaf9b32 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -828,11 +828,13 @@ static void vu_set_status(struct virtio_device *vdev, u8 status)
 	vu_dev->status = status;
 }
 
-static void vu_reset(struct virtio_device *vdev)
+static int vu_reset(struct virtio_device *vdev)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 
 	vu_dev->status = 0;
+
+	return 0;
 }
 
 static void vu_del_vq(struct virtqueue *vq)
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 38800e86ed8a..e3c513c2d4fa 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -989,11 +989,13 @@ static void mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
 }
 
 /* Reset the device. Not much here for now. */
-static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
+static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
 {
 	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
 
 	tm_vdev->status = 0;
+
+	return 0;
 }
 
 /* Read the value of a configuration field. */
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index cf4d54e98e6a..975c845b3187 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
-static void rproc_virtio_reset(struct virtio_device *vdev)
+static int rproc_virtio_reset(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct fw_rsc_vdev *rsc;
@@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 
 	rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
+
+	return 0;
 }
 
 /* provide the vdev features as retrieved from the firmware */
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d35e7a3f7067..5221cdad531d 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -710,14 +710,14 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	return ret;
 }
 
-static void virtio_ccw_reset(struct virtio_device *vdev)
+static int virtio_ccw_reset(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct ccw1 *ccw;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
-		return;
+		return -ENOMEM;
 
 	/* Zero status bits. */
 	vcdev->dma_area->status = 0;
@@ -729,6 +729,8 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	ccw->cda = 0;
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
 	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
+
+	return 0;
 }
 
 static u64 virtio_ccw_get_features(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d62e9835aeec..0b5d95e3efa1 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
@@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
 	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 30654d3a0b41..b0cde3b2f0ff 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	vp_modern_set_status(&vp_dev->mdev, status);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
@@ -174,6 +174,8 @@ static void vp_reset(struct virtio_device *vdev)
 		msleep(1);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index ff43f9b62b2f..3e666f70e829 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 	return ops->set_status(vdpa, status);
 }
 
-static void virtio_vdpa_reset(struct virtio_device *vdev)
+static int virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
 	vdpa_reset(vdpa);
+
+	return 0;
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8519b3ae5d52..203407992c30 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -47,6 +47,7 @@ struct virtio_shm_region {
  *	After this, status and feature negotiation must be done again
  *	Device must not be reset from its vq/config callbacks, or in
  *	parallel with being added/removed.
+ *	Returns 0 on success or error status
  * @find_vqs: find virtqueues and instantiate them.
  *	vdev: the virtio_device
  *	nvqs: the number of virtqueues to find
@@ -82,7 +83,7 @@ struct virtio_config_ops {
 	u32 (*generation)(struct virtio_device *vdev);
 	u8 (*get_status)(struct virtio_device *vdev);
 	void (*set_status)(struct virtio_device *vdev, u8 status);
-	void (*reset)(struct virtio_device *vdev);
+	int (*reset)(struct virtio_device *vdev);
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[], vq_callback_t *callbacks[],
 			const char * const names[], const bool *ctx,
-- 
2.11.0

