Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4EF59549F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiHPILH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiHPIKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9B6967CA5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660628204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7KUDnR7ITSXzGuGHvfD+T/glFccQWZ3L+AQhNkH7LGU=;
        b=UkjhGOVUeTX8KiefZBy2GITjCwi5lEyadKzVT59Oz4sddrs0xk4RiiUhswooxWSjxPgg+S
        iscl1oA920cfsTtWrblQiGEQoCoR7Gy2ml5yyiCBFlQLl21ogr24xrdTvpCaWQstrpQldj
        iy88XBPW5tz8t3unCH8wv6mANXL90tM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-398-Y-yre2tmO8GmQxIGr5-7Og-1; Tue, 16 Aug 2022 01:36:43 -0400
X-MC-Unique: Y-yre2tmO8GmQxIGr5-7Og-1
Received: by mail-wm1-f71.google.com with SMTP id c66-20020a1c3545000000b003a5f6dd6a25so2025627wma.1
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7KUDnR7ITSXzGuGHvfD+T/glFccQWZ3L+AQhNkH7LGU=;
        b=AVNfcPVSrQuhAK1O7bC6LA/987yHQC+xfRfopZIM1gTzVikDs3Ad6B9cBwl8O10Eo2
         V4ficuUmqOoF7klA83vbKFofd1qb4MFumrWf2J7dCVTyEzOAHY2Sx0OH4NymlALBXVTa
         brYs10hCCqzalaEt1ywpGQeYjjXD44t8V0rXyoO7tVJJcmrRX8NZYs47DTU6JjABdcvU
         5AQPS+8facTG4USpBLjkFdYXcVudhHMIQbo1cUbAs5orkJiLEwGf2TsP70q/Jjs1wEyV
         knIHNJIUHeAAx8VGZ770PUvJqfcD2/RSs2ejyERY45DPID969MH5bkjKCm90i1v0mRUb
         crcg==
X-Gm-Message-State: ACgBeo1tXqzaYU/AfebYX+pMhxWh7GAqcWWC5bhxhV8WNlX1nnbv7SqB
        YyCMc7aUXu2dJCLPAuwaQTc0dPl502DQLIFIWeOQiFxdD2e8lwpay7zfIzus17T2ElgKCp9xpZu
        zovcO5hE6RiT5eMch
X-Received: by 2002:a05:600c:1c83:b0:3a3:1f70:25a5 with SMTP id k3-20020a05600c1c8300b003a31f7025a5mr18412710wms.54.1660628201015;
        Mon, 15 Aug 2022 22:36:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4kzmUA2mS0iZBrt5q7gKzWHCvCko36MWp8hTvWspyQu/9LQBLLi7D8U8GszfgwIHA29QVLJw==
X-Received: by 2002:a05:600c:1c83:b0:3a3:1f70:25a5 with SMTP id k3-20020a05600c1c8300b003a31f7025a5mr18412690wms.54.1660628200817;
        Mon, 15 Aug 2022 22:36:40 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id q18-20020adff952000000b00222ed7ea203sm8819074wrr.100.2022.08.15.22.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 22:36:40 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:36:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andres Freund <andres@anarazel.de>
Subject: [PATCH v4 4/6] virtio_pci: Revert "virtio_pci: support the arg sizes
 of find_vqs()"
Message-ID: <20220816053602.173815-5-mst@redhat.com>
References: <20220816053602.173815-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053602.173815-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit cdb44806fca2d0ad29ca644cbf1505433902ee0c: the legacy
path is wrong and in fact can not support the proposed API since for a
legacy device we never communicate the vq size to the hypervisor.

Reported-by: Andres Freund <andres@anarazel.de>
Fixes: cdb44806fca2 ("virtio_pci: support the arg sizes of find_vqs()")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 18 ++++++++----------
 drivers/virtio/virtio_pci_common.h |  1 -
 drivers/virtio/virtio_pci_legacy.c |  6 +-----
 drivers/virtio/virtio_pci_modern.c | 10 +++-------
 4 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 00ad476a815d..7ad734584823 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -174,7 +174,6 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int index,
 				     void (*callback)(struct virtqueue *vq),
 				     const char *name,
-				     u32 size,
 				     bool ctx,
 				     u16 msix_vec)
 {
@@ -187,7 +186,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int in
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, size, ctx,
+	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
 			      msix_vec);
 	if (IS_ERR(vq))
 		goto out_info;
@@ -284,7 +283,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 
 static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], u32 sizes[], bool per_vq_vectors,
+		const char * const names[], bool per_vq_vectors,
 		const bool *ctx,
 		struct irq_affinity *desc)
 {
@@ -327,8 +326,8 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 		else
 			msix_vec = VP_MSIX_VQ_VECTOR;
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     sizes ? sizes[i] : 0,
-				     ctx ? ctx[i] : false, msix_vec);
+				     ctx ? ctx[i] : false,
+				     msix_vec);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto error_find;
@@ -358,7 +357,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 
 static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], u32 sizes[], const bool *ctx)
+		const char * const names[], const bool *ctx)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i, err, queue_idx = 0;
@@ -380,7 +379,6 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 			continue;
 		}
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     sizes ? sizes[i] : 0,
 				     ctx ? ctx[i] : false,
 				     VIRTIO_MSI_NO_VECTOR);
 		if (IS_ERR(vqs[i])) {
@@ -404,15 +402,15 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	int err;
 
 	/* Try MSI-X with one vector per queue. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, true, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, desc);
 	if (!err)
 		return 0;
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, false, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
 	if (!err)
 		return 0;
 	/* Finally fall back to regular interrupts. */
-	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, sizes, ctx);
+	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
 }
 
 const char *vp_bus_name(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index c0448378b698..a5ff838b85a5 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -80,7 +80,6 @@ struct virtio_pci_device {
 				      unsigned int idx,
 				      void (*callback)(struct virtqueue *vq),
 				      const char *name,
-				      u32 size,
 				      bool ctx,
 				      u16 msix_vec);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d75e5c4e637f..2257f1b3d8ae 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -112,7 +112,6 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  unsigned int index,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
-				  u32 size,
 				  bool ctx,
 				  u16 msix_vec)
 {
@@ -126,13 +125,10 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!num || vp_legacy_get_queue_enable(&vp_dev->ldev, index))
 		return ERR_PTR(-ENOENT);
 
-	if (!size || size > num)
-		size = num;
-
 	info->msix_vector = msix_vec;
 
 	/* create the vring */
-	vq = vring_create_virtqueue(index, size,
+	vq = vring_create_virtqueue(index, num,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
 				    true, false, ctx,
 				    vp_notify, callback, name);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index f7965c5dd36b..be51ec849252 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -293,7 +293,6 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  unsigned int index,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
-				  u32 size,
 				  bool ctx,
 				  u16 msix_vec)
 {
@@ -311,18 +310,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!num || vp_modern_get_queue_enable(mdev, index))
 		return ERR_PTR(-ENOENT);
 
-	if (!size || size > num)
-		size = num;
-
-	if (size & (size - 1)) {
-		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", size);
+	if (num & (num - 1)) {
+		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", num);
 		return ERR_PTR(-EINVAL);
 	}
 
 	info->msix_vector = msix_vec;
 
 	/* create the vring */
-	vq = vring_create_virtqueue(index, size,
+	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
 				    vp_notify, callback, name);
-- 
MST

