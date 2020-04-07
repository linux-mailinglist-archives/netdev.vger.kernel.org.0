Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9CD1A046A
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDGBRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:17:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46575 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726699AbgDGBQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586222213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=FL5cL9jB/jv3Cw8c0R7qvL4Fr6L6684qHMIGeLvRn49FmU0NAjyiVhOH2dTCfHtVcwNLTT
        /fKTvnPA8fBXt1d1mTRvRISYxbpwz2TZ3uzW9C1r2QkluBXsCQt8fjbqw8CNvpeNm1trai
        9qnn1PPCSS8PgevWzuuC3b3MAZBt08o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-SQrGXRjCMhqs9zfu1hJr0g-1; Mon, 06 Apr 2020 21:16:51 -0400
X-MC-Unique: SQrGXRjCMhqs9zfu1hJr0g-1
Received: by mail-wm1-f72.google.com with SMTP id p18so13001wmk.9
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 18:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=Jy5JVkyNdYBrZ7ejAU6liJdK94MXtPl3Sy4LjYu9VHkNuH/nAgJxghQC85qjWA5/9E
         F/IqOZUnWiAMW/HwWmhImtPh07/F2LksT7DlE42t6HoDrqNwduq53LP+sJ1fiV8t1nuc
         i63TNArqIFP29F5EbKyc6ageSCql7fvHME82eteQtNDXO/elv6cEt3AwBlbql9Y3jd/y
         eRshzChLSj8fUvHKYO8HurLeNa2xE2mqK4hAnlU0uXiuJBQbTIwcfZl0e7F9WzMLZ05u
         NiR2DgnPgI0lWm37cMwvguP02vJ9v1WphLdkCvjUCxcD5Wx9/Wus65zE3e3vAUQggwal
         8HPw==
X-Gm-Message-State: AGi0PubtPiUWovPUZ1/RVwyHb8m6vPzAAouZUImtCn+TI0dqOkq98svl
        Lvv8pUWp57rBS/77zXN1mWu37crsclej1NNCWTrY2bNcZC+tRJv7/rGISXbPY4DHxfTtAU8jevK
        Wfp1EJNRaraUmRGXF
X-Received: by 2002:adf:fe52:: with SMTP id m18mr2041304wrs.162.1586222210552;
        Mon, 06 Apr 2020 18:16:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypJn5DjBcjpMzTbrTEAm6PtADPd35uHLc30DK0aLGHH0mu1pODoic12Kr5dEmc3NA5QUWXhA1A==
X-Received: by 2002:adf:fe52:: with SMTP id m18mr2041286wrs.162.1586222210287;
        Mon, 06 Apr 2020 18:16:50 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id u13sm30079813wru.88.2020.04.06.18.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:16:49 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:16:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 10/19] vhost: force spec specified alignment on types
Message-ID: <20200407011612.478226-11-mst@redhat.com>
References: <20200407011612.478226-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407011612.478226-1-mst@redhat.com>
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
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 11680e74761a..c3f9ca054250 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -60,14 +60,32 @@ static inline void virtio_store_mb(bool weak_barriers,
 struct virtio_device;
 struct virtqueue;
 
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
 
 /*
-- 
MST

