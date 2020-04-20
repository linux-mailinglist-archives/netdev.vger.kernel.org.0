Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA31B16B2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDTUJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:09:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgDTUJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:09:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587413352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3cdUNjir+RJ29IhWI2+VQqP/CP/QCzQGQxj8crbt+CU=;
        b=ZwmxI4M7/usPm0jf49pg3ANFqH3rQY4bWt3+d9VrE6okk9eZtADXu5JDCPDTtlTfCOnKkS
        r2szUzTqMP8mjdjoa8+18kvWttXSVfiKm40punHVTYiXqbwCyYAP6tKjwOAZCEmobkGtZi
        to5sediPD4xlIk7tdFn6VqJjhNr8KlU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-v_R4EnbPM52p6vxoYiGEHA-1; Mon, 20 Apr 2020 16:09:08 -0400
X-MC-Unique: v_R4EnbPM52p6vxoYiGEHA-1
Received: by mail-wr1-f71.google.com with SMTP id f15so6325086wrj.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3cdUNjir+RJ29IhWI2+VQqP/CP/QCzQGQxj8crbt+CU=;
        b=FogGm8AtO3/N7M3peQ6EupifuGUE2hmylbuv+zp3oGJkgc0VovjFA1ibunGFP7InUG
         N8P4kASsYZtuJQZ5kse/oXGFEmZkRIFx7iwnMs+YogY6L3mFAqXLs7C7VykMCRMrPXUN
         TDvMpEo2cMSibeFAn7Ru6jKJ2RdF9MQTNKlITOcWvxtkLUUEJ0jZn21osbOql6qBVebx
         9/A2cicZ//o32xoVphp3JVI6cMpawjwUghUvjQcR+a0pVTq63TntR89+8CdwOpC9JMhn
         O2IsWOrGPUcIFflJcZI6yq41VhqF7BIIjkRw2CuCG08nG2qUvuzpS68Avx703nEX/WnJ
         BoaA==
X-Gm-Message-State: AGi0Pua3dsgCyTOp/abUtGzJDoblfwH0hPRRqsN26u+GYV8PVIXV1XfI
        q1eV0Ysj7yN1DR0hp5DUvatIQe+fN/WUxpA69QAP47T37qMMfKOWB0C0mqx62/FHXluaVNS97dQ
        GT1/RgzYvoIQ//iFQ
X-Received: by 2002:adf:f48f:: with SMTP id l15mr14175273wro.161.1587413347520;
        Mon, 20 Apr 2020 13:09:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypLkaZVhyiGNviDtldj3DJMdeZ39eLj1tjCm5p8aa1AKRsrwnukiu6MtIA4c2rwxsEck4bJl5Q==
X-Received: by 2002:adf:f48f:: with SMTP id l15mr14175249wro.161.1587413347145;
        Mon, 20 Apr 2020 13:09:07 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id c83sm618373wmd.23.2020.04.20.13.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 13:09:06 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:09:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2] virtio: force spec specified alignment on types
Message-ID: <20200420200550.254983-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ring element addresses are passed between components with different
alignments assumptions. Thus, if guest/userspace selects a pointer and
host then gets and dereferences it, we might need to decrease the
compiler-selected alignment to prevent compiler on the host from
assuming pointer is aligned.

This actually triggers on ARM with -mabi=apcs-gnu - which is a
deprecated configuration, but it seems safer to handle this
generally.

Note that userspace that allocates the memory is actually OK and does
not need to be fixed, but userspace that gets it from guest or another
process does need to be fixed. The later doesn't generally talk to the
kernel so while it might be buggy it's not talking to the kernel in the
buggy way - it's just using the header in the buggy way - so fixing
header and asking userspace to recompile is the best we can do.

I verified that the produced kernel binary on x86 is exactly identical
before and after the change.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Changes from v1:
	update vhost, vringh pointers to use the new typedefs

 drivers/vhost/vhost.c            |  8 +++----
 drivers/vhost/vhost.h            |  6 ++---
 drivers/vhost/vringh.c           |  6 ++---
 include/linux/vringh.h           |  6 ++---
 include/uapi/linux/virtio_ring.h | 38 +++++++++++++++++++++++---------
 5 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d450e16c5c25..21706759377e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1244,9 +1244,9 @@ static int vhost_iotlb_miss(struct vhost_virtqueue *vq, u64 iova, int access)
 }
 
 static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
-			 struct vring_desc __user *desc,
-			 struct vring_avail __user *avail,
-			 struct vring_used __user *used)
+			 vring_desc_t __user *desc,
+			 vring_avail_t __user *avail,
+			 vring_used_t __user *used)
 
 {
 	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
@@ -2301,7 +2301,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
 			    unsigned count)
 {
-	struct vring_used_elem __user *used;
+	vring_used_t __user *used;
 	u16 old, new;
 	int start;
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f8403bd46b85..60cab4c78229 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -67,9 +67,9 @@ struct vhost_virtqueue {
 	/* The actual ring of buffers. */
 	struct mutex mutex;
 	unsigned int num;
-	struct vring_desc __user *desc;
-	struct vring_avail __user *avail;
-	struct vring_used __user *used;
+	vring_desc_t __user *desc;
+	vring_avail_t __user *avail;
+	vring_used_t __user *used;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;
 	struct eventfd_ctx *call_ctx;
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index ba8e0d6cfd97..e059a9a47cdf 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -620,9 +620,9 @@ static inline int xfer_to_user(const struct vringh *vrh,
  */
 int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
-		     struct vring_desc __user *desc,
-		     struct vring_avail __user *avail,
-		     struct vring_used __user *used)
+		     vring_desc_t __user *desc,
+		     vring_avail_t __user *avail,
+		     vring_used_t __user *used)
 {
 	/* Sane power of 2 please! */
 	if (!num || num > 0xffff || (num & (num - 1))) {
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 9e2763d7c159..59bd50f99291 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -105,9 +105,9 @@ struct vringh_kiov {
 /* Helpers for userspace vrings. */
 int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
-		     struct vring_desc __user *desc,
-		     struct vring_avail __user *avail,
-		     struct vring_used __user *used);
+		     vring_desc_t __user *desc,
+		     vring_avail_t __user *avail,
+		     vring_used_t __user *used);
 
 static inline void vringh_iov_init(struct vringh_iov *iov,
 				   struct iovec *iovec, unsigned num)
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 9223c3a5c46a..177227f0d9cd 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -118,16 +118,6 @@ struct vring_used {
 	struct vring_used_elem ring[];
 };
 
-struct vring {
-	unsigned int num;
-
-	struct vring_desc *desc;
-
-	struct vring_avail *avail;
-
-	struct vring_used *used;
-};
-
 /* Alignment requirements for vring elements.
  * When using pre-virtio 1.0 layout, these fall out naturally.
  */
@@ -135,6 +125,34 @@ struct vring {
 #define VRING_USED_ALIGN_SIZE 4
 #define VRING_DESC_ALIGN_SIZE 16
 
+/*
+ * The ring element addresses are passed between components with different
+ * alignments assumptions. Thus, we might need to decrease the compiler-selected
+ * alignment, and so must use a typedef to make sure the __aligned attribute
+ * actually takes hold:
+ *
+ * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Common-Type-Attributes
+ *
+ * When used on a struct, or struct member, the aligned attribute can only
+ * increase the alignment; in order to decrease it, the packed attribute must
+ * be specified as well. When used as part of a typedef, the aligned attribute
+ * can both increase and decrease alignment, and specifying the packed
+ * attribute generates a warning.
+ */
+typedef struct vring_desc __aligned(VRING_DESC_ALIGN_SIZE) vring_desc_t;
+typedef struct vring_avail __aligned(VRING_AVAIL_ALIGN_SIZE) vring_avail_t;
+typedef struct vring_used __aligned(VRING_USED_ALIGN_SIZE) vring_used_t;
+
+struct vring {
+	unsigned int num;
+
+	vring_desc_t *desc;
+
+	vring_avail_t *avail;
+
+	vring_used_t *used;
+};
+
 #ifndef VIRTIO_RING_NO_LEGACY
 
 /* The standard layout for the ring is a continuous chunk of memory which looks
-- 
MST

