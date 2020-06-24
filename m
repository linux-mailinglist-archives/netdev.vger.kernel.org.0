Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70960207F48
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgFXWZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:25:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36457 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388797AbgFXWZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 18:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593037553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1qVm+qFHpBcFnajiwKWBoYJyF5SCnRnSLqkqB/nC2LI=;
        b=ZH6UUHjQ2rjcSSkpkeMlAj4F9vgKU0lxT6W9SIxwuyCqba4/ywEh4XR6bvb8xLacF692fA
        2dHVZ9VU3h52lEMsgfYTFFuEGDKHuCLCfU9czgtzfUBQeh/ftXvnCAkuU0wkOnG/Cb+EOb
        MeoI0hz15HF884tLc5zmFgyPCNIndBU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-fhI0vNJlOF6gtlli4MxR1Q-1; Wed, 24 Jun 2020 18:25:51 -0400
X-MC-Unique: fhI0vNJlOF6gtlli4MxR1Q-1
Received: by mail-wr1-f70.google.com with SMTP id i12so4512054wrx.11
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 15:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1qVm+qFHpBcFnajiwKWBoYJyF5SCnRnSLqkqB/nC2LI=;
        b=dS29DNGzZtE3u2Wz8/dS9lkQKOjqchREDosbRhrzB96ZOv5HH+qPUEqqGRHR2xeINR
         UbJXbZDVRtszwAEO1jHfYKZwCc/1lNb+zdRuL924FuveEIsQq0S6iMnochfrPBzW8sp4
         Bzjur9LcMWmnzP/HhCjG0YPZnosyFKjkaLrJdmoEhhF8iEWs1FRgO0oBtbG2qRoNJKB3
         yp7Ona3WKwGPB9LlCVfL5+Rym/evTe7jEjPYKhEmzfu2pAMbbDqlb0PaMTHgd7sQjTXJ
         HLQgoGpMnRu+oiGJq8AC1oCvirvy6KZ5JqPZ3C1M+FGfdsfRpJNKs33Suj5HhkflkF+B
         venA==
X-Gm-Message-State: AOAM533+r/rCgdD5Uj35E9NoxF3IvtFwbsd3UEqVM+sMzueNoQZW/H4Q
        kL268vb/KzpK5furVkZbusbFey2pLrk1LXAcbzMeFa6wHJTLgnTZsO+glp3kGhS/AexAzou+H7i
        CRcdh1vXzh8Y8z/Rl
X-Received: by 2002:a5d:5389:: with SMTP id d9mr35177564wrv.77.1593037550093;
        Wed, 24 Jun 2020 15:25:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5gkNnNw1CL/BcAtvH4812k2atgKf2tuErPH8kANjueWieY9PbxsFzSbaKi8RCVMCZsYBf3w==
X-Received: by 2002:a5d:5389:: with SMTP id d9mr35177546wrv.77.1593037549818;
        Wed, 24 Jun 2020 15:25:49 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id p4sm18772481wrx.63.2020.06.24.15.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 15:25:49 -0700 (PDT)
Date:   Wed, 24 Jun 2020 18:25:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] virtio: VIRTIO_F_IOMMU_PLATFORM -> VIRTIO_F_ACCESS_PLATFORM
Message-ID: <20200624222540.584772-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the bit to match latest virtio spec.
Add a compat macro to avoid breaking existing userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/um/drivers/virtio_uml.c       |  2 +-
 drivers/vdpa/ifcvf/ifcvf_base.h    |  2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   |  4 ++--
 drivers/vhost/net.c                |  4 ++--
 drivers/vhost/vdpa.c               |  2 +-
 drivers/virtio/virtio_balloon.c    |  2 +-
 drivers/virtio/virtio_ring.c       |  2 +-
 include/linux/virtio_config.h      |  2 +-
 include/uapi/linux/virtio_config.h | 10 +++++++---
 tools/virtio/linux/virtio_config.h |  2 +-
 10 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 351aee52aca6..a6c4bb6c2c01 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -385,7 +385,7 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
 		}
 		break;
 	case VHOST_USER_SLAVE_IOTLB_MSG:
-		/* not supported - VIRTIO_F_IOMMU_PLATFORM */
+		/* not supported - VIRTIO_F_ACCESS_PLATFORM */
 	case VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG:
 		/* not supported - VHOST_USER_PROTOCOL_F_HOST_NOTIFIER */
 	default:
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f4554412e607..24af422b5a3e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -29,7 +29,7 @@
 		 (1ULL << VIRTIO_F_VERSION_1)			| \
 		 (1ULL << VIRTIO_NET_F_STATUS)			| \
 		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
-		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
+		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
 		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
 
 /* Only one queue pair for now. */
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c7334cc65bb2..a9bc5e0fb353 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -55,7 +55,7 @@ struct vdpasim_virtqueue {
 
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
-			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
+			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
 
 /* State of each vdpasim device */
 struct vdpasim {
@@ -450,7 +450,7 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
 	/* DMA mapping must be done by driver */
-	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
+	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
 		return -EINVAL;
 
 	vdpasim->features = features & vdpasim_features;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e992decfec53..8e0921d3805d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -73,7 +73,7 @@ enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			 (1ULL << VIRTIO_F_IOMMU_PLATFORM)
+			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
 };
 
 enum {
@@ -1653,7 +1653,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 	    !vhost_log_access_ok(&n->dev))
 		goto out_unlock;
 
-	if ((features & (1ULL << VIRTIO_F_IOMMU_PLATFORM))) {
+	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
 		if (vhost_init_device_iotlb(&n->dev, true))
 			goto out_unlock;
 	}
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a54b60d6623f..18869a35d408 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -31,7 +31,7 @@ enum {
 		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
 		(1ULL << VIRTIO_F_ANY_LAYOUT) |
 		(1ULL << VIRTIO_F_VERSION_1) |
-		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
+		(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 		(1ULL << VIRTIO_F_RING_PACKED) |
 		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
 		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f157d2f4952..fc7301406540 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1120,7 +1120,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
-	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 58b96baa8d48..a1a5c2a91426 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2225,7 +2225,7 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_VERSION_1:
 			break;
-		case VIRTIO_F_IOMMU_PLATFORM:
+		case VIRTIO_F_ACCESS_PLATFORM:
 			break;
 		case VIRTIO_F_RING_PACKED:
 			break;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bb4cc4910750..f2cc2a0df174 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -171,7 +171,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
 	 * Note the reverse polarity of the quirk feature (compared to most
 	 * other features), this is for compatibility with legacy systems.
 	 */
-	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
 }
 
 static inline
diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index ff8e7dc9d4dd..b5eda06f0d57 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -67,13 +67,17 @@
 #define VIRTIO_F_VERSION_1		32
 
 /*
- * If clear - device has the IOMMU bypass quirk feature.
- * If set - use platform tools to detect the IOMMU.
+ * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
+ * If set - use platform DMA tools to access the memory.
  *
  * Note the reverse polarity (compared to most other features),
  * this is for compatibility with legacy systems.
  */
-#define VIRTIO_F_IOMMU_PLATFORM		33
+#define VIRTIO_F_ACCESS_PLATFORM	33
+#ifndef __KERNEL__
+/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
+#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
+#endif /* __KERNEL__ */
 
 /* This feature indicates support for the packed virtqueue layout. */
 #define VIRTIO_F_RING_PACKED		34
diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
index dbf14c1e2188..f99ae42668e0 100644
--- a/tools/virtio/linux/virtio_config.h
+++ b/tools/virtio/linux/virtio_config.h
@@ -51,7 +51,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
 	 * Note the reverse polarity of the quirk feature (compared to most
 	 * other features), this is for compatibility with legacy systems.
 	 */
-	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
 }
 
 static inline bool virtio_is_little_endian(struct virtio_device *vdev)
-- 
MST

