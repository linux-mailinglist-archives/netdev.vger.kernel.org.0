Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E791F0BBB
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFGOLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 10:11:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36511 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726752AbgFGOLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 10:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wp6BO12ZdY311uANoeiTSpiBXoC9bVPHS+5RWfNAiPw=;
        b=Q8fxqFhhV1TUiL6R+TX98E6C7gBMo5LeyShwdmvtVNeCCfE55TMCurc/ym+X/HbNpgYWyY
        WVqm2yvjeP5BZIwW7hvgqN18maOMjlmynGN9gEqOg4ma3glxV1EDeKMAqzSvyI/M9HYwNT
        dfPYH64EiCP+PfDAik+kWnIlUbTFmTE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-F7ezX9YiMK6MhmpdNr_UBg-1; Sun, 07 Jun 2020 10:11:39 -0400
X-MC-Unique: F7ezX9YiMK6MhmpdNr_UBg-1
Received: by mail-wm1-f69.google.com with SMTP id l13so1142634wmj.3
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 07:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wp6BO12ZdY311uANoeiTSpiBXoC9bVPHS+5RWfNAiPw=;
        b=l0Bn8Q8rMOgKnnnW8eC2xiFJGNPNa9hakenn2Wb1XDl1cOiTq0S4CoqCnmuLouMfVs
         HNml+7c6KXsjTJ+0EJNtnoCGYu/iPvlJljfH6HBiN+djQS3cBnCuQ8ZCVeiBR1xWs6u4
         /J0rdibtYQqRIINjtxnhtT+tuLg6A6MZa6m4OPfIWhmiX382snZGyJOucLWyiZErKWVr
         tOjhPvIwOm+DRapI9vSpfDWJrgd2II3B3e1SM9wMJ1Dkx6XCXqpudx8II/A86tnHaWwb
         j/u7rThEJoyIgmWckl2drVZePb0D5gB3zQiog+FZY0W7FGsPkqstqGjfAl85WR5vW/XN
         t1cA==
X-Gm-Message-State: AOAM5301G8RFBOBBLdJRwG0Q45OMrrEOyIZxhLrt6JHKfRJdOAVLZPR3
        cxOGzh+/swRv3mioKISW4dufwEZGyOLlCEZdgMU87IpzY/TjoyqY6NxeUbrj/X/pr2ZxHbybB8O
        +Jxiw531Slh74CcBF
X-Received: by 2002:a1c:e20a:: with SMTP id z10mr11194104wmg.63.1591539098285;
        Sun, 07 Jun 2020 07:11:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFt8FJP6Ka1KJy2iQ809xCaM+/JyNuAYCSvk8oDmutDU4mYkXzFPpUiOv4ag1sD+vroAfCPA==
X-Received: by 2002:a1c:e20a:: with SMTP id z10mr11194090wmg.63.1591539098051;
        Sun, 07 Jun 2020 07:11:38 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id o10sm18638815wrq.40.2020.06.07.07.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:37 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 06/13] vhost: reorder functions
Message-ID: <20200607141057.704085-7-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
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
 drivers/vhost/vhost.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5075505cfe55..3ffcba4e27e9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2299,6 +2299,13 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	return 1;
 }
 
+/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
+{
+	vq->last_avail_idx -= n;
+}
+EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
+
 /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
  * A negative code is returned on error. */
 static int fetch_descs(struct vhost_virtqueue *vq)
@@ -2413,26 +2420,6 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
-{
-	vq->last_avail_idx -= n;
-}
-EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
-
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
@@ -2502,6 +2489,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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

