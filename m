Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5078594E60
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbiHPCCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiHPCBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF1F7220069
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3QJuMC2X3Ls7xg8Zv+wmV/GtRe9wR+MYC+AaCjrIFhI=;
        b=QzuYzXBdF4XJt871UR41qevJr4jLydu5qOoiBSgVl0B2BXrCp8/Yc/VW91+dK9iAQm1etH
        LpBosegnj16dFmydjGsbe4u71oga148519cD8V4kX9bDEIUXGu5QepKT9heXbrxMlv1RQk
        wzH44h7qRqMDRGt5EH1VWWTsAJMONBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-jslA5a6oM9OtRbSNPQdDaA-1; Mon, 15 Aug 2022 17:53:25 -0400
X-MC-Unique: jslA5a6oM9OtRbSNPQdDaA-1
Received: by mail-wm1-f72.google.com with SMTP id x16-20020a1c7c10000000b003a5cefa5578so1586056wmc.7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=3QJuMC2X3Ls7xg8Zv+wmV/GtRe9wR+MYC+AaCjrIFhI=;
        b=jV/ihX2lcfAjtxtuDmgrT5ZGSj7JNeCkBX0/yiz/1DOS0K94s2FvQea0KoKy4/5It6
         f+QkxesiZNxOgKHPvgpR9hVAzcSmvdRoX/KfSJM5FUWziSD81d3Si/a6DvvhK3WgHm7I
         wmb0nR7UxnV6sbfP0miwXOK/VuQng2q5r5YaER+/UuxGfzlK3bNsG9aGvH6EEbeN+ge4
         wzp2uNTKPRxWscacHX4LRvi4y2UND4kJ4qwoiiCLnUxjMx0N6f3hLnBavsAslWs9YMQP
         PbnBMsgIMmUPIRot3gNhpHM1BWVB2hl4P7EuCocPCK9bcGxndfUu378zV9lGlmB2NU3o
         LwVA==
X-Gm-Message-State: ACgBeo0hqGbhqbM/IvUge+B7jMek8Pd61iTZVICPGP0uO2rm5rCrTawy
        gwte5wnn6dHh0KA64ODbqo352wn0bTmNFFjxOeFdJCCfRPR4Wa4ErD+Oh9LyLU1RBmjb6yb+zBd
        Riv2u4VS2dVe3la3t
X-Received: by 2002:adf:ce89:0:b0:220:6cc5:aff8 with SMTP id r9-20020adfce89000000b002206cc5aff8mr9905791wrn.396.1660600404290;
        Mon, 15 Aug 2022 14:53:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4OAJ7a0UnnYJ7tqTWqb9naQHIU382zVYRVHjmmnON5u7E9HsMntuwmikOY+aox36XmsS1mBQ==
X-Received: by 2002:adf:ce89:0:b0:220:6cc5:aff8 with SMTP id r9-20020adfce89000000b002206cc5aff8mr9905783wrn.396.1660600403993;
        Mon, 15 Aug 2022 14:53:23 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id n6-20020a1c2706000000b003a511e92abcsm10796901wmn.34.2022.08.15.14.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:53:23 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:53:20 -0400
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
        Ricardo =?utf-8?Q?Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/1] virtio: kerneldocs fixes and enhancements
Message-ID: <20220815215251.154451-2-mst@redhat.com>
References: <20220815215251.154451-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220815215251.154451-1-mst@redhat.com>
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

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

Fix variable names in some kerneldocs, naming in others.
Add kerneldocs for struct vring_desc and vring_interrupt.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Message-Id: <20220810094004.1250-2-ricardo.canuelo@collabora.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index d66c8e6d0ef3..4620e9d79dde 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2426,6 +2426,14 @@ static inline bool more_used(const struct vring_virtqueue *vq)
 	return vq->packed_ring ? more_used_packed(vq) : more_used_split(vq);
 }
 
+/**
+ * vring_interrupt - notify a virtqueue on an interrupt
+ * @irq: the IRQ number (ignored)
+ * @_vq: the struct virtqueue to notify
+ *
+ * Calls the callback function of @_vq to process the virtqueue
+ * notification.
+ */
 irqreturn_t vring_interrupt(int irq, void *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index a3f73bb6733e..dcab9c7e8784 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -11,7 +11,7 @@
 #include <linux/gfp.h>
 
 /**
- * virtqueue - a queue to register buffers for sending or receiving.
+ * struct virtqueue - a queue to register buffers for sending or receiving.
  * @list: the chain of virtqueues for this device
  * @callback: the function to call when buffers are consumed (can be NULL).
  * @name: the name of this virtqueue (mainly for debugging)
@@ -97,7 +97,7 @@ int virtqueue_resize(struct virtqueue *vq, u32 num,
 		     void (*recycle)(struct virtqueue *vq, void *buf));
 
 /**
- * virtio_device - representation of a device using virtio
+ * struct virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
  * @failed: saved value for VIRTIO_CONFIG_S_FAILED bit (for restore)
  * @config_enabled: configuration change reporting enabled
@@ -156,7 +156,7 @@ size_t virtio_max_dma_size(struct virtio_device *vdev);
 	list_for_each_entry(vq, &vdev->vqs, list)
 
 /**
- * virtio_driver - operations for a virtio I/O driver
+ * struct virtio_driver - operations for a virtio I/O driver
  * @driver: underlying device driver (populate name and owner).
  * @id_table: the ids serviced by this driver.
  * @feature_table: an array of feature numbers supported by this driver.
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 36ec7be1f480..4b517649cfe8 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -239,7 +239,7 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 
 /**
  * virtio_synchronize_cbs - synchronize with virtqueue callbacks
- * @vdev: the device
+ * @dev: the virtio device
  */
 static inline
 void virtio_synchronize_cbs(struct virtio_device *dev)
@@ -258,7 +258,7 @@ void virtio_synchronize_cbs(struct virtio_device *dev)
 
 /**
  * virtio_device_ready - enable vq use in probe function
- * @vdev: the device
+ * @dev: the virtio device
  *
  * Driver must call this to use vqs in the probe function.
  *
@@ -306,7 +306,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
 /**
  * virtqueue_set_affinity - setting affinity for a virtqueue
  * @vq: the virtqueue
- * @cpu: the cpu no.
+ * @cpu_mask: the cpu mask
  *
  * Pay attention the function are best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 476d3e5c0fe7..f8c20d3de8da 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -93,15 +93,21 @@
 #define VRING_USED_ALIGN_SIZE 4
 #define VRING_DESC_ALIGN_SIZE 16
 
-/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
+/**
+ * struct vring_desc - Virtio ring descriptors,
+ * 16 bytes long. These can chain together via @next.
+ *
+ * @addr: buffer address (guest-physical)
+ * @len: buffer length
+ * @flags: descriptor flags
+ * @next: index of the next descriptor in the chain,
+ *        if the VRING_DESC_F_NEXT flag is set. We chain unused
+ *        descriptors via this, too.
+ */
 struct vring_desc {
-	/* Address (guest-physical). */
 	__virtio64 addr;
-	/* Length. */
 	__virtio32 len;
-	/* The flags as indicated above. */
 	__virtio16 flags;
-	/* We chain unused descriptors via this, too */
 	__virtio16 next;
 };
 
-- 
MST

