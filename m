Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1E5388989
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 10:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbhESIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 04:37:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239738AbhESIhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 04:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621413355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kBWJsOxt7zpLvOsF815LxI3UC9m1OTmAuh6Ryt/JE9E=;
        b=Wgzexkd2mMWHq6HKlwG9cqJaM9eLLTxDvXPJgX1QLYOvpDMO6AmEwaXtWSXk/eDE8HpWsb
        3SajCNE43wECF8qax1RTtPEDBcAaAzoTG/Qnp6Vqpt9o+/OdRDJJSAEwEFpmFu5jmjyPYk
        Yq6UvEIFt3/MSVr/pWtw6wEnIAfJofQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-QXtdDKwhOi-aZIQ1n34deQ-1; Wed, 19 May 2021 04:35:53 -0400
X-MC-Unique: QXtdDKwhOi-aZIQ1n34deQ-1
Received: by mail-wm1-f72.google.com with SMTP id z62-20020a1c65410000b0290179bd585ef9so385214wmb.7
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 01:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBWJsOxt7zpLvOsF815LxI3UC9m1OTmAuh6Ryt/JE9E=;
        b=qHTcc8ZEdEs2f4G/3slTBlV1vAZ3vbPwqiyMiW9o3qFQzKlGVQOXiVXP2hPbQta+Ws
         GXN7pYgJPMRT92Ehwo2H4CAvTp/nQsVNA9HSFqO+rhg4hqr4Pd70DTeeRIs3d7Sm0x6f
         Wn9DClnaaV9vLY5PtDJLpr/JDhS7uCRSA4ijNKwjYf1GWBC1bfdMqlADL+RThupiMsl5
         2LMQsZXFFBTldK9MGhz6lqs6t2fSdPTRgyJRDETHkVsMngVH51PWcIWMVM3BErsc/gv5
         ymtlvoUqKnV7PVOgfxKC8jX3rl4gdXqdrcSt2ipwyieF5FjoXTMPbPQ3hFW1DS4hbPF3
         /SNg==
X-Gm-Message-State: AOAM532ORsJHAiVyuPWBx69grbsX3deAyB+BoyqzkCQH345zNr5cNcYP
        P6TecBZLi9gDbfcc6BxnCNgYL2Aw9YPThL4WKJCyhlw4Tj9SXqH4JUcbyeMKCgizWK7lQeWXr+z
        0NCpnYqiwJYJPx1GC
X-Received: by 2002:a5d:438c:: with SMTP id i12mr12654211wrq.44.1621413352512;
        Wed, 19 May 2021 01:35:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnuhdYturThgXAIn2AgmdXSkMy9No+V7eGDQOMjqtANuqtHMvDVHRKxvBEyVM2mlWEq2nttw==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr12654194wrq.44.1621413352319;
        Wed, 19 May 2021 01:35:52 -0700 (PDT)
Received: from redhat.com ([2a10:800c:1fa6:0:3809:fe0c:bb87:250e])
        by smtp.gmail.com with ESMTPSA id y2sm5892806wmq.45.2021.05.19.01.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 01:35:51 -0700 (PDT)
Date:   Wed, 19 May 2021 04:35:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: virtio_net: BQL?
Message-ID: <20210519043201-mutt-send-email-mst@kernel.org>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 11:43:43AM -0700, Dave Taht wrote:
> Not really related to this patch, but is there some reason why virtio
> has no support for BQL?

So just so you can try it out, I rebased my old patch.
XDP is handled incorrectly by it so we shouldn't apply it as is,
but should be good enough for you to see whether it helps.
Completely untested!

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>



diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7be93ca01650..4bfb682a20b2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -556,6 +556,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 			kicks = 1;
 	}
 out:
+	/* TODO: netdev_tx_completed_queue? */
 	u64_stats_update_begin(&sq->stats.syncp);
 	sq->stats.bytes += bytes;
 	sq->stats.packets += packets;
@@ -1376,7 +1377,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	return stats.packets;
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+static void free_old_xmit_skbs(struct netdev_queue *txq, struct send_queue *sq, bool in_napi)
 {
 	unsigned int len;
 	unsigned int packets = 0;
@@ -1406,6 +1407,8 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 	if (!packets)
 		return;
 
+	netdev_tx_completed_queue(txq, packets, bytes);
+
 	u64_stats_update_begin(&sq->stats.syncp);
 	sq->stats.bytes += bytes;
 	sq->stats.packets += packets;
@@ -1434,7 +1437,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 	if (__netif_tx_trylock(txq)) {
 		virtqueue_disable_cb(sq->vq);
-		free_old_xmit_skbs(sq, true);
+		free_old_xmit_skbs(txq, sq, true);
 
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 			netif_tx_wake_queue(txq);
@@ -1522,7 +1525,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit_skbs(txq, sq, true);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
@@ -1606,10 +1609,11 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
 	bool kick = !netdev_xmit_more();
 	bool use_napi = sq->napi.weight;
+	unsigned int bytes = skb->len;
 
 	/* Free up any pending old buffers before queueing new ones. */
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, false);
+	free_old_xmit_skbs(txq, sq, false);
 
 	if (use_napi && kick)
 		virtqueue_enable_cb_delayed(sq->vq);
@@ -1638,6 +1642,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		nf_reset_ct(skb);
 	}
 
+	netdev_tx_sent_queue(txq, bytes);
+
 	/* If running out of space, stop queue to avoid getting packets that we
 	 * are then unable to transmit.
 	 * An alternative would be to force queuing layer to requeue the skb by
@@ -1653,7 +1659,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (!use_napi &&
 		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(sq, false);
+			free_old_xmit_skbs(txq, sq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);

