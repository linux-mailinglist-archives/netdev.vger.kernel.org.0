Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3835D2E4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbhDLWIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:08:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237058AbhDLWIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618265304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGL7wZWdJprmiLe0nt1hRgifCRO5IhlbubiT9W672a0=;
        b=bpV/lPOoRNUq1q731oRrr0c0LCNnAiOl/EFDxClN2EIQvTIIDi2rPms/7i03YFCADXq45y
        LI92LD+BLNmKaQNegNuziIu0oXpwqgAmtmC0eIuhHW9XsDHqZoOd4X2bysr11LXFkiYa4t
        fK0DXKRzf6M75TqWaX7maioe2Qe7W4g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-bLDZ3xQ6OQSeGZG861wadw-1; Mon, 12 Apr 2021 18:08:23 -0400
X-MC-Unique: bLDZ3xQ6OQSeGZG861wadw-1
Received: by mail-wm1-f69.google.com with SMTP id z135-20020a1c7e8d0000b02901297f50f20dso135547wmc.0
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 15:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:ccc;
        bh=AGL7wZWdJprmiLe0nt1hRgifCRO5IhlbubiT9W672a0=;
        b=N5YdKw8zrHKf+XkSD4vCBl11PlqJw9WWbeYzIIjzohPNY/SsHyrEyW7uYVLb31lK7W
         +tOua+mRQBT7AJO4P35dvqaKXimU9HuETvjU2da8V/VapjeesCE02XCB2qhrvrOad50R
         Yv66RdcQ3rMzzs3HqNMEyAf3QuUnbKts0q16BHDcf8nIbYsJr6jymcQ+ByLZ5E76AX05
         fgdePtZTvnxf9XSaPvASlH2CT4bSsO/V17q9LZ+FvLnZJQTkWjwhJZ6ATyvlaW3i6w0j
         5CyiyMuIsN1J95t7DToik3xApUV60ckcgxb8sXSuY1JgBDmFH3ED97lu40rD7KraZJ1w
         5Zeg==
X-Gm-Message-State: AOAM531cXFjyLyvesx1m3wGlQX3wTOs2eswh7EE30KXWD3yDT3MxD9li
        jxiNKLlbeG8/ghd+plFeUiabQPayy8UeyAtfQxwtj3EidbYkwT1vZQhGD1XUzGB1cT64svRaUmw
        Kt3uUlYpXS7QZIZvs
X-Received: by 2002:a05:600c:329c:: with SMTP id t28mr1073713wmp.74.1618265302063;
        Mon, 12 Apr 2021 15:08:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQq02VEH0x+yR4nCVseGnJU8z9TNWYz+YkkYnKTZ8stWzkVM0s8+ImnNF6USPPWg4NmHoYgQ==
X-Received: by 2002:a05:600c:329c:: with SMTP id t28mr1073698wmp.74.1618265301866;
        Mon, 12 Apr 2021 15:08:21 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id v7sm17127237wrs.2.2021.04.12.15.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 15:08:19 -0700 (PDT)
Date:   Mon, 12 Apr 2021 18:08:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210412180353-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129002136.70865-1-weiwan@google.com>
Ccc:    Eugenio Perez Martin <eperezma@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK I started looking at this again. My idea is simple.
A. disable callbacks before we try to drain skbs
B. actually do disable callbacks even with event idx

To make B not regress, we need to
C. detect the common case of disable after event triggering and skip the write then.

I added a new event_triggered flag for that.
Completely untested - but then I could not see the warnings either.
Would be very much interested to know whether this patch helps
resolve the sruprious interrupt problem at all ...


Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb12..a91a2d6d1ee3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1429,6 +1429,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 		return;
 
 	if (__netif_tx_trylock(txq)) {
+		virtqueue_disable_cb(vq);
 		free_old_xmit_skbs(sq, true);
 		__netif_tx_unlock(txq);
 	}
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..213bfe8b6051 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -113,6 +113,9 @@ struct vring_virtqueue {
 	/* Last used index we've seen. */
 	u16 last_used_idx;
 
+	/* Hint for event idx: already triggered no need to disable. */
+	bool event_triggered;
+
 	union {
 		/* Available for split ring */
 		struct {
@@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
 
 	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
-		if (!vq->event)
+		if (vq->event)
+			/* TODO: this is a hack. Figure out a cleaner value to write. */
+			vring_used_event(&vq->split.vring) = 0x0;
+		else
 			vq->split.vring.avail->flags =
 				cpu_to_virtio16(_vq->vdev,
 						vq->split.avail_flags_shadow);
@@ -1605,6 +1611,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
+	vq->event_triggered = false;
 	vq->num_added = 0;
 	vq->packed_ring = true;
 	vq->use_dma_api = vring_use_dma_api(vdev);
@@ -1919,6 +1926,14 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	/* If device triggered an event already it won't trigger one again:
+	 * no need to disable.
+	 */
+	if (vq->event_triggered) {
+		vq->event_triggered = false;
+		return;
+	}
+
 	if (vq->packed_ring)
 		virtqueue_disable_cb_packed(_vq);
 	else
@@ -2044,6 +2059,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 	if (unlikely(vq->broken))
 		return IRQ_HANDLED;
 
+	/* Just a hint for performance: so it's ok that this can be racy! */
+	if (vq->event)
+		vq->event_triggered = true;
+
 	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
 	if (vq->vq.callback)
 		vq->vq.callback(&vq->vq);
@@ -2083,6 +2102,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
+	vq->event_triggered = false;
 	vq->num_added = 0;
 	vq->use_dma_api = vring_use_dma_api(vdev);
 #ifdef DEBUG

