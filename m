Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAC719F618
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgDFMvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:51:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728069AbgDFMvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586177461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7A/JZx9mU7o1VoLWOXJ3u/SJqb7Gm6YpvdN2hJBccMY=;
        b=aZmik9APiNXM371riVV5/VsmpBybrYEhVA4CbuX8kN+kLnfbT/XI8dWvgfBB/whQtzHOys
        1NunASJITPYg2sd30fv4lqb7/w8aKikqTGg4F/I7GlT/KCI6shz4EHrkQ709RL7w8ZtVft
        xcqPWhilz+2ZVl0M4Wea7l91ndnrcSI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-zGF-Gjv2MYemy4I1E2dYrw-1; Mon, 06 Apr 2020 08:50:59 -0400
X-MC-Unique: zGF-Gjv2MYemy4I1E2dYrw-1
Received: by mail-wr1-f72.google.com with SMTP id j12so8264572wrr.18
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 05:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7A/JZx9mU7o1VoLWOXJ3u/SJqb7Gm6YpvdN2hJBccMY=;
        b=Gxp8ZE6GCMz4L8PEZgzhXCzBiyqHZtX9i/6M4bKNUaBB0R6bDLA32//LQIzCqieBCi
         1FYSesVn2C72lxAeXDuBhtyIJjp/64EMUBEK13gZ5fGZ3avYzKQnlEB3IBm2m2TQUwmv
         WiZeSyxmDKru5i2xu1Tp9fx//DU68SLz5ad7ERirkWaYMHq7oHSzIFqrdM/jnbrb8oJV
         h7huDezFd82x/kNVF66ej4tnGff4Km+j+0oBp/kNmCqPqFLg/RqQWqENal+9mOlMffV5
         q1jOBToEYOd+1BDnZfFu3Os/glqGqH3l8bnfg3Hu2XAbqt7HQ7iHOaMvX/WaplcB76WW
         rxTQ==
X-Gm-Message-State: AGi0PuYwpLi41ocqGjrUzt8vLFRuc48TiJximexkWmPqoGRcXQtSFeGG
        WA8HTUSwDkrrspd0C4XJQZT+DCOqvUvFuEDA1Fbg9M5ft+iOGXCdblPorjRkis9soOfxjjRLIXo
        rQBgV/CyEU9xiIs2n
X-Received: by 2002:adf:81b6:: with SMTP id 51mr17298389wra.229.1586177457394;
        Mon, 06 Apr 2020 05:50:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7/DS77HBZ8L/FNXyj60fPbTTo/BHYI/NHwMQ/9pXpk2TSq6zGsv9CKDz2v5JeoEWm2YjQcw==
X-Received: by 2002:adf:81b6:: with SMTP id 51mr17298368wra.229.1586177457169;
        Mon, 06 Apr 2020 05:50:57 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id y22sm7895262wma.0.2020.04.06.05.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 05:50:56 -0700 (PDT)
Date:   Mon, 6 Apr 2020 08:50:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost: force spec specified alignment on types
Message-ID: <20200406124931.120768-1-mst@redhat.com>
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

I verified that the produced binary is exactly identical on x86.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is my preferred way to handle the ARM incompatibility issues
(in preference to kconfig hacks).
I will push this into next now.
Comments?

 drivers/vhost/vhost.h            |  6 ++---
 include/uapi/linux/virtio_ring.h | 41 ++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index cc82918158d2..a67bda9792ec 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -74,9 +74,9 @@ struct vhost_virtqueue {
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
 
 	struct vhost_desc *descs;
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 559f42e73315..cd6e0b2eaf2f 100644
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
@@ -164,6 +154,37 @@ struct vring {
 #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
 #define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
 
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
+typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
+	vring_desc_t;
+typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
+	vring_avail_t;
+typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_t;
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
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 			      unsigned long align)
 {
-- 
MST

