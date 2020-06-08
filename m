Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0221F1951
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgFHMxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:53:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729319AbgFHMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC9C1bg85UqEARLoLzVVH0wVxPzUMhgdZVeMnCOVW8I=;
        b=ZdOB4XijOdoagcKqSp1IuyScqjZPiXAQOir8D2sxtrZVsXu/9w5TmnywilpC3cJ1/dPcwb
        ucf/NhPII+A4cz+kni6Gwi6C7lxhl5+8cH8AqkkSR3GypjRlM6gfFTesMeee5hJiWjCZUM
        BsPPDYR9ED+av+veP0rexnAl4LdRx7c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-5rv3m6_AP0ylpVf6oM86eQ-1; Mon, 08 Jun 2020 08:53:03 -0400
X-MC-Unique: 5rv3m6_AP0ylpVf6oM86eQ-1
Received: by mail-wm1-f70.google.com with SMTP id u15so3900819wmm.5
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YC9C1bg85UqEARLoLzVVH0wVxPzUMhgdZVeMnCOVW8I=;
        b=hnShubdQll3loxBziR/XSaQUPnTtCC+hB5R4hoVa7eFQlBxbogMvwTO+pDca+qmGDr
         Kd+/ZcDUfEjO4Mfkf+oWYN+1Aiq/5PIMRJCjzgljgZK3/74Ft8jlOJTrWiHkOeg3MxUs
         TuvVJa21H+PzzejC9Pjb/QUyUCJ6G0dmj9w6+NAwN9kWWCHxvwUajLEDQcR6oWDZZUZg
         atqfEZm4kVHnk/znGpXAWV0cbq+xDoopYnoQ+yi1mnww+v1Lnbdln8SaUjYGppA/+Cbj
         b+j0K2b2vJTHD9HSRbn/214IgI1lmr5U1I9vVh+cMAnDi60rHWcWDj9e1Y3BtFn/NCLR
         XbhQ==
X-Gm-Message-State: AOAM531KMCBt1Qx9xbTxOArlPNLEhfVZ/VtRWDgNEw0vhOQ9mlzouKbl
        tQ6DvTasABOHGzj6w1MrNM1tpHHq224eAac0mraAIOV+wBApFFalyzjepmVxBpMU+mtgQkuKUl5
        MBLxMO3vohKUSPDmM
X-Received: by 2002:a1c:59c7:: with SMTP id n190mr15634969wmb.61.1591620782175;
        Mon, 08 Jun 2020 05:53:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycvWcSZ9pgrB8OOPKZQyruJy8vStQkFo1WrrMhroFInHbRmdrcF8cq2oRf/qnvmhPPXJjLnQ==
X-Received: by 2002:a1c:59c7:: with SMTP id n190mr15634952wmb.61.1591620781966;
        Mon, 08 Jun 2020 05:53:01 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id r12sm23319300wrc.22.2020.06.08.05.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:01 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 04/11] vhost: reorder functions
Message-ID: <20200608125238.728563-5-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder functions in the file to not rely on forward
declarations, in preparation to making them static
down the road.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 41d6b132c234..334529ebecab 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2429,19 +2429,6 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
-{
-	struct vring_used_elem heads = {
-		cpu_to_vhost32(vq, head),
-		cpu_to_vhost32(vq, len)
-	};
-
-	return vhost_add_used_n(vq, &heads, 1);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used);
-
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
 			    unsigned count)
@@ -2511,6 +2498,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using eventfd. */
+int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
+{
+	struct vring_used_elem heads = {
+		cpu_to_vhost32(vq, head),
+		cpu_to_vhost32(vq, len)
+	};
+
+	return vhost_add_used_n(vq, &heads, 1);
+}
+EXPORT_SYMBOL_GPL(vhost_add_used);
+
 static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	__u16 old, new;
-- 
MST

