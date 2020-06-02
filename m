Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6FD1EBC95
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgFBNGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46228 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728202AbgFBNGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Doki9eOY+Vt0bEelnsffrGLeK+qhziALFfS1p6mljA=;
        b=FOQAzT8mQe4AXVguQhjZNMWDzXVxAzBY7YV5PmjRHwbVnVIDxg/kg5Z1Zkpyt4AiYnHX7W
        9N9v2WvHrvbzuK/qFRyxGVmWoZg2frMmX06nVfUeW/BG61ShbUOlpmUJal0vz3PhBGiAnk
        rHrjqf1uPL5hzpnn+cF2HVEDYFiutXU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-7DUed-HdMLufjHKjgtCU4g-1; Tue, 02 Jun 2020 09:06:12 -0400
X-MC-Unique: 7DUed-HdMLufjHKjgtCU4g-1
Received: by mail-wm1-f71.google.com with SMTP id b65so926110wmb.5
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Doki9eOY+Vt0bEelnsffrGLeK+qhziALFfS1p6mljA=;
        b=rFIzWH3PommP6rAqvhVe1oCuxBmr6PamDP7azd4hoKE6Xhac9TeJJ0AD0kmW0YMYna
         1XyL1YctTnSyTtwK1o+Aw6j1vg7WeIUGHtKgfozCUy5ABnur3splorusFWJhaKgUEahq
         sSpwgVdJc4q4nX1uvyMxSj+CUX8SoS7bjSw4Yuw/HrzYYI6Vujm+gZRj3U8XeyU9tuLJ
         1mnEwLOIr0fwzsPhAQj9Tr/hVnhDKnUtURYOAzvaCwIakSqGuEiTdnzmouSV4yA+rJxV
         4OEy8AhCMdxu9SNWwd4cioZ8mwIqf1X9Xj78CHULRqLIGaQeGYNign6Ynlaoms1RFvIg
         P+Rw==
X-Gm-Message-State: AOAM531rNTws1DSurIzbk52juDsipX+YcKunArhhjAgMFA2hve0H0J5X
        3cQw7ocv7gn0xYEqPk84IhEuInx7/5I0mFSq/LbB1JySftz0jZL1Ep7zKKHADYWA0jHrgNjV2L0
        4k/Cci9UjdVPnnUCc
X-Received: by 2002:adf:d852:: with SMTP id k18mr11135186wrl.177.1591103170686;
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJze7fjrtd3HAxuSDspGJm8TtOVdc3+cTfx7SISy8qbvd/4VQ9hQeFCUsVzEXG1sYbQZL/2f6g==
X-Received: by 2002:adf:d852:: with SMTP id k18mr11135174wrl.177.1591103170498;
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id k14sm3631200wrq.97.2020.06.02.06.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:10 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 06/13] vhost: reorder functions
Message-ID: <20200602130543.578420-7-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
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
index bd52b44b0d23..b4a6e44d56a8 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2256,6 +2256,13 @@ static int fetch_buf(struct vhost_virtqueue *vq)
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
@@ -2370,26 +2377,6 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
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
@@ -2459,6 +2446,19 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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

