Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F2C19F9E2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 18:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgDFQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 12:12:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729444AbgDFQMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 12:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586189528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YSJ8Eyd5qzlvYRVDFDnJ/h6MFs7vCBsG17V62Acz7Go=;
        b=eyV2B8YNkwvmRb0v5xMEd85IeegWif0Ogf0guMeFaWL8xGZt8muSswQT3MeyXgUKdrm4ka
        dZGJXvmhZHVZD4P20jqXxDUUAfjF2ZIt0Zwxg2lgypKY0pXB4okZSXdTON+YeunCsmOMJF
        hXVp8kmutN3UQ5UopQF1Hk7hxsWhZVI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-ig4y8yBEPXq9eQUBWJ_CTw-1; Mon, 06 Apr 2020 12:12:04 -0400
X-MC-Unique: ig4y8yBEPXq9eQUBWJ_CTw-1
Received: by mail-wr1-f70.google.com with SMTP id 91so57897wro.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 09:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YSJ8Eyd5qzlvYRVDFDnJ/h6MFs7vCBsG17V62Acz7Go=;
        b=K3DudOU5oyowwxO5n4c36aAlbq4FyDjvG9pVITt8fdPlDTjxqZeZJ770PvXdAX25kA
         kTKfaTSgJ/AsVNR9E/RyC53A4IieJC3RUsNADvVtzsHVR5Z4soOnsUA7AJCgGGMZSOVG
         +e8zHfK959vRj4coXoZQuI+Dyhvky+tX3tGbYJxgejxtVLo9Eriaik5xognEz1v3iLGG
         mnvSNPsa1WGSbmFeObx4R54rQE5vjkQnJEKLD76/P2cpjedcEc0oiWDw2SH4CUiyCCxQ
         U8/fqQ7b+llYHc3SD1Ad+QMl0eAhVlkyASLccKhZysqBZiG38OXu9u9jnhnMQAcY/PU2
         E9Ow==
X-Gm-Message-State: AGi0PuapUVIUfSvG1zz8k8mlNwu3H2JF1PZeDj3lrxmoxYMCr6kYPrNH
        6TcKLimyc/sy173WUtkOyicF6d6JH3wPlr+qLnJYcCeBfExPyNFD0tFUidz00VwRmd/jXSXVUPx
        xtm8NPQfAxvPjicdE
X-Received: by 2002:adf:a48d:: with SMTP id g13mr26477936wrb.38.1586189522887;
        Mon, 06 Apr 2020 09:12:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypJYH9VirBBcJS7XAIuyV6I64Pp7s8xM5+YVZD9WaBXPltzMCbzOkZBbTEPyDfUwNBxO2HXnbw==
X-Received: by 2002:adf:a48d:: with SMTP id g13mr26477907wrb.38.1586189522618;
        Mon, 06 Apr 2020 09:12:02 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id s66sm56418wme.40.2020.04.06.09.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 09:12:02 -0700 (PDT)
Date:   Mon, 6 Apr 2020 12:12:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 2/2] vhost: force spec specified alignment on types
Message-ID: <20200406161146.130741-3-mst@redhat.com>
References: <20200406161146.130741-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406161146.130741-1-mst@redhat.com>
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
 drivers/vhost/vhost.h       |  6 +++---
 include/linux/virtio_ring.h | 24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 181382185bbc..3ceaafecc1fb 100644
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
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index b6a31b3cf87c..dfb58eff7a7f 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -113,14 +113,32 @@ void vring_transport_features(struct virtio_device *vdev);
 
 irqreturn_t vring_interrupt(int irq, void *_vq);
 
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
 struct vring {
 	unsigned int num;
 
-	struct vring_desc *desc;
+	vring_desc_t *desc;
 
-	struct vring_avail *avail;
+	vring_avail_t *avail;
 
-	struct vring_used *used;
+	vring_used_t *used;
 };
 
 static inline void vring_legacy_init(struct vring *vr, unsigned int num, void *p,
-- 
MST

