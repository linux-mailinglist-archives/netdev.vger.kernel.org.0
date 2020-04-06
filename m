Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0681A0042
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 23:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDFVep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 17:34:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbgDFVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 17:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586208884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=Z7amTvX4E8a/BsieLgf9KNnVc3e3g/OJSc4czDKiqHROckdje2WEV9RbRep8GmmBWna4Pl
        9sv4BugdujiMjM/t3oHaFhKtG6X7cxVDzsQhDMA7u7q+xf5kxgbrSltrL6TObsj5uk6YBF
        IntsugIb4kUrEWOUzOIg2XbCz0juVDs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-EzFo7p_XNgaZLNhUrTMojg-1; Mon, 06 Apr 2020 17:34:40 -0400
X-MC-Unique: EzFo7p_XNgaZLNhUrTMojg-1
Received: by mail-wr1-f70.google.com with SMTP id w12so554376wrl.23
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 14:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=U0XhVdlIGos+alg7DkKIoNkn2b1r6ZAjKH6bK9Bsx7B24IlAI2a++iWqnxMu96rdzH
         4eiDA9D/+sB6mEgw3kQtY2rj/oHFVnDMyAMQg75lm6csFtd62UDY4Wu1ozJYCOh3ixlA
         6k/q82i/Dqc5vQgQtNawLaw1ErTG4R3jZWf6ILm1fWx9GtT9dYhh6VmxVyVeZqfcwNG1
         jpOVd7X8CXEN6412qcz7NegVG8EQNg9XpKkzsZm/eIJcKRWhsJy/WjMZe6SSIbdyMtUe
         MxonrLAcWVHZRiiwPteH4iHRPVOORMENn82tjuGm2jkkACZTVNDfSAHlZt8ze0zy5ZI3
         4lfQ==
X-Gm-Message-State: AGi0PubD/lPB76KzVXtbhAzLmrQkKnznVJg8T+XQ8z8RXFmpcR49CoPo
        IIyeiowdygbT4YPQZeBG3/gQWZ4kKhiJXMLhvUz6FlTpk84nVwWI2VI4SLAWc9VRwuHbxgsrxKz
        h7zZ2MxB4pimB9now
X-Received: by 2002:a1c:2d95:: with SMTP id t143mr1048134wmt.89.1586208879545;
        Mon, 06 Apr 2020 14:34:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIDfEOd292CqNqE70r5arC2C5jNItEbGfr741TbN6Hn4hfA1uTh0Srcc3LesXCK0n49qBd6Cw==
X-Received: by 2002:a1c:2d95:: with SMTP id t143mr1048122wmt.89.1586208879332;
        Mon, 06 Apr 2020 14:34:39 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b85sm1103452wmb.21.2020.04.06.14.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 14:34:38 -0700 (PDT)
Date:   Mon, 6 Apr 2020 17:34:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v4 06/12] vhost: force spec specified alignment on types
Message-ID: <20200406210108.148131-7-mst@redhat.com>
References: <20200406210108.148131-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406210108.148131-1-mst@redhat.com>
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

