Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF9B19F8F2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgDFPfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:35:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729018AbgDFPfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586187333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WcD5bnL3oh20wTc9EOP7RiXfqynrk2ncKD+A08n84pk=;
        b=OkyqIJhgD69StkGJoYglRh/Yrqy5cLDYzXA+wBWV7jMHLY1SYPKvwtVrPyDuwMvquvv7bU
        lb7WrX0WrAWNm4XQaUUgK4crxWvPhm+E+iSD+f518sukAgir5l/ED6Og64pbBTQEM/a5wi
        8+w78SxvdR1B2InK2F7EtViZwoY0ank=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-Awgj0WJDMwKRE4_Qwpkc9A-1; Mon, 06 Apr 2020 11:35:30 -0400
X-MC-Unique: Awgj0WJDMwKRE4_Qwpkc9A-1
Received: by mail-wm1-f69.google.com with SMTP id y1so5053045wmj.3
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 08:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WcD5bnL3oh20wTc9EOP7RiXfqynrk2ncKD+A08n84pk=;
        b=pNpAD4Qo+jG01lJJZJ2Fomo0KsHAtN0oXCLXJWyyJoILm2U9FB+T/w6ynmYWKUD9XZ
         Yg/GbH9LNxovaSV8jnj9dDyGbq1Thbni8S9lyOHVuEL+PyPjyqvrB7futh5VZEFb3m+V
         m8xECBewpOrwAIkEDHJhPIqfmC4J3k8ohDxFFgpvdVQ2g+jLG9H7ir18CyzOrk3yiVuE
         97mtlDRz0aZzyujzcJMz4HQ7tOE/1yKyPiU9wZgtp09yKoixjhZXVXTPGEHc2zJzJ8cY
         0rLv6mOfY2ieWCfo7jfrJqdYDI/K9xYooFMdC8vnZdcYFiElTHF6nzustLLCZfrRi5Lx
         2flg==
X-Gm-Message-State: AGi0PuYHlc/bgPDJ7GWCCnASQ35cqhUzzMVn9kdgT3wWGt3LArWzll83
        3gPGdXbzZKoTVSXddug019By0NY0hw87VIw49W5fJ+XwE/Ww5mdv14pfhhD61UspwMONEW9nDtQ
        kGyoc/AXk/BmOm7ZO
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr235147wmj.61.1586187328645;
        Mon, 06 Apr 2020 08:35:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypJviLbcieugAjPGOVBq05eDNBi87y+oZCK+mJ9GTEVcTRtTrZXiXSxdhRpJLHpez1P5uNEa6Q==
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr235126wmj.61.1586187328352;
        Mon, 06 Apr 2020 08:35:28 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id d6sm27113086wrw.10.2020.04.06.08.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:35:27 -0700 (PDT)
Date:   Mon, 6 Apr 2020 11:35:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] vhost: force spec specified alignment on types
Message-ID: <20200406153245.127680-3-mst@redhat.com>
References: <20200406153245.127680-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406153245.127680-1-mst@redhat.com>
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
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 09fc6164b523..efcb9fde1dbf 100644
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
 struct vring_s {
 	unsigned int num;
 
-	struct vring_desc *desc;
+	vring_desc_t *desc;
 
-	struct vring_avail *avail;
+	vring_avail_t *avail;
 
-	struct vring_used *used;
+	vring_used_t *used;
 };
 
 static inline void vring_legacy_init(struct vring_s *vr, unsigned int num, void *p,
-- 
MST

