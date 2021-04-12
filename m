Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A7535D332
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbhDLWeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:34:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239408AbhDLWeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618266831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kDYC/0JEgwH/dQyAoKRIGlbZ//2y9RqMa3XQD3efgMY=;
        b=NGk1iL2Vh8v3fLQOHJiUqvZszsATTCc8BeG5owW9SvspkiHkssvUH45pvtOouB2V2kk1Ci
        p8rcCcw5OEncfhMFQAdd9xz0NiF7W960NZzLWZXIFLdaWYPGUdjl6FMVdqnGHlclq4aMiB
        9PNwRUUIaDxEzefu8qtTKjd/gQFEv2c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-uejuC2AeP8mG4pcXjF4v3Q-1; Mon, 12 Apr 2021 18:33:50 -0400
X-MC-Unique: uejuC2AeP8mG4pcXjF4v3Q-1
Received: by mail-wr1-f70.google.com with SMTP id j24so4983712wra.1
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 15:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kDYC/0JEgwH/dQyAoKRIGlbZ//2y9RqMa3XQD3efgMY=;
        b=RmZNDotP3Hh5f3qhp0NMf1OtcjyG5mS5YLDIPNSAe8nrxQBCFO5NiUhe2mvsNagzBI
         A/xfs+aetkQ8f6JwbJqHpGkiIlTzIr5HD2l79QGJZuE/BmtxyPKj0HDJeoDoBOeebZV2
         04ocg5HyTMg0ZRJRTnsapB/Np08LEDsML7VdIj/K930KDd5oyxt5jtogtmpiGldCes46
         pxbG8f7V7/udiasjzIO7XZK3t4ABdvDadFZIXszpoZfjddNoQFo4Ag6npQtq/z0ldYG5
         yATGgMRqXMUQ/3P/8+FQTMFR4R+531Rf8IPibhut6wRwmkd3iWZMZ+9RA7ZzCt+m07G3
         h/Pw==
X-Gm-Message-State: AOAM531vbmRLGf+5mVjGivYvx0QO4Ma3lE4shrRUF95PGW07oGs5ddFu
        r4UopyFX3BK4kHhMaFuO3+rZnVXLIlC4DSZDvdNKwv10MruY5gxB5O9BYApXP16Aw++bCV+Nl2r
        Bvdounr1haSbVw2dx
X-Received: by 2002:adf:df0a:: with SMTP id y10mr19746096wrl.246.1618266829124;
        Mon, 12 Apr 2021 15:33:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuanvU3G286FyJLWeBqftN6+/9ZmG2RjPQ17fFEUGiVXPjlB6KaubOAPuXTHof1g4G0gV/JQ==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr19746080wrl.246.1618266828954;
        Mon, 12 Apr 2021 15:33:48 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id j6sm609841wmq.16.2021.04.12.15.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 15:33:48 -0700 (PDT)
Date:   Mon, 12 Apr 2021 18:33:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210412183141-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
 <20210412180353-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412180353-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 06:08:21PM -0400, Michael S. Tsirkin wrote:
> OK I started looking at this again. My idea is simple.
> A. disable callbacks before we try to drain skbs
> B. actually do disable callbacks even with event idx
> 
> To make B not regress, we need to
> C. detect the common case of disable after event triggering and skip the write then.
> 
> I added a new event_triggered flag for that.
> Completely untested - but then I could not see the warnings either.
> Would be very much interested to know whether this patch helps
> resolve the sruprious interrupt problem at all ...
> 
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Hmm a slightly cleaner alternative is to clear the flag when enabling interrupts ...
I wonder which cacheline it's best to use for this.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb12..c23341b18eb5 100644
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
index 71e16b53e9c1..88f0b16b11b8 100644
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
@@ -1919,6 +1926,12 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	/* If device triggered an event already it won't trigger one again:
+	 * no need to disable.
+	 */
+	if (vq->event_triggered)
+		return;
+
 	if (vq->packed_ring)
 		virtqueue_disable_cb_packed(_vq);
 	else
@@ -1942,6 +1955,9 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (vq->event_triggered)
+		vq->event_triggered = false;
+
 	return vq->packed_ring ? virtqueue_enable_cb_prepare_packed(_vq) :
 				 virtqueue_enable_cb_prepare_split(_vq);
 }
@@ -2005,6 +2021,9 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (vq->event_triggered)
+		vq->event_triggered = false;
+
 	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
 				 virtqueue_enable_cb_delayed_split(_vq);
 }
@@ -2044,6 +2063,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 	if (unlikely(vq->broken))
 		return IRQ_HANDLED;
 
+	/* Just a hint for performance: so it's ok that this can be racy! */
+	if (vq->event)
+		vq->event_triggered = true;
+
 	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
 	if (vq->vq.callback)
 		vq->vq.callback(&vq->vq);
@@ -2083,6 +2106,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
+	vq->event_triggered = false;
 	vq->num_added = 0;
 	vq->use_dma_api = vring_use_dma_api(vdev);
 #ifdef DEBUG

