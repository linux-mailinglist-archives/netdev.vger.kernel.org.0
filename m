Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B381966D529
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 04:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbjAQDt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 22:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbjAQDtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 22:49:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88F423333
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 19:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673927306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ox4Ah9tt80v/yWVYXdwLmBislsr/xQeepIzjgpV54dk=;
        b=MdVx44YgHP3dGuUkrI5yXTS05toYp3M/fY3Nis0H5M1QqEa6F5oyyn6STXB8c5uOAqp7al
        /dX8AZYffdOzNfjUSaiXYoVNuVtI1jwbU+NnuPG+iNgMV9lP1mGtufu9pQvFECxmK3wCPy
        SFmJMxo9VVww8pY9xRTEYWNHm1yAAu8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-Nnl9AfAYOb2pv97TYIwl5w-1; Mon, 16 Jan 2023 22:48:25 -0500
X-MC-Unique: Nnl9AfAYOb2pv97TYIwl5w-1
Received: by mail-oi1-f198.google.com with SMTP id du3-20020a056808628300b00364c7610c6aso2082978oib.6
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 19:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ox4Ah9tt80v/yWVYXdwLmBislsr/xQeepIzjgpV54dk=;
        b=Eq+yGvJEyR/qKsZY9h1JHLONC7E8kNGoiHf117/9xjZ9nL64dgv4+p12nc8nhA0acP
         /8uUKafTMZmcEQAYaS+BcBHVYnIRs61htaIUBdRDnkzOa65HhGfGdwUPEyGnHNNBEBiY
         w1Sd8mJK88EndRr+dVtsdcqvm1oZXcCLGOlrtUlA1lq4vUNb6MnIP3ror9eDYE7wbY/0
         96C4tXe0JvOt8fwX5fDnNntfBf02uyKBdkAe3s0dIo+zyi/aTxlQkqJpGvnzvA1kWYxE
         B8qh6CbCfzY7Z3NxM5uhAlRtkM9k0mkC+rZqfT3Cbiys3cFjbLTYyygshqUDdR2DWP4a
         ALRQ==
X-Gm-Message-State: AFqh2kpM4xb9UTi3+zc40LGcu/jPs/WRit1MpeQ3XCH0n4cCYgi/f3D/
        KQMt0Lr85FcGi9VUHCSamZiNfDTaPcXLE7b2WE7iRrx+c8wm3vQGdkwhqosLv4arPAQP+EHBiJ4
        w34UQa57tCvQSeCnbf3h7tpFbobGi/LQf
X-Received: by 2002:a05:6830:334d:b0:684:9f72:3fe3 with SMTP id l13-20020a056830334d00b006849f723fe3mr77545ott.201.1673927304618;
        Mon, 16 Jan 2023 19:48:24 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsvPWHgmiuIC6ubfdkBMLXNoYQC3qKGVcUwBpPUbVPA4QslvV9B3BCnOvNItJrvKcEq//61NUmiljeMR3EA8k8=
X-Received: by 2002:a05:6830:334d:b0:684:9f72:3fe3 with SMTP id
 l13-20020a056830334d00b006849f723fe3mr77542ott.201.1673927304388; Mon, 16 Jan
 2023 19:48:24 -0800 (PST)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <20210526082423.47837-5-mst@redhat.com>
 <a5990064-df57-f991-832d-56d1156dc3f8@redhat.com>
In-Reply-To: <a5990064-df57-f991-832d-56d1156dc3f8@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 17 Jan 2023 11:48:13 +0800
Message-ID: <CACGkMEuq3YOpQaZLD_dFsHsA=qpT=N22ZyLdtE83VNHjS6iVbQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Stefano Brivio <sbrivio@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 9:41 PM Laurent Vivier <lvivier@redhat.com> wrote:
>
> Hi Michael,
>
> On 5/26/21 10:24, Michael S. Tsirkin wrote:
> > There are currently two cases where we poll TX vq not in response to a
> > callback: start xmit and rx napi.  We currently do this with callbacks
> > enabled which can cause extra interrupts from the card.  Used not to be
> > a big issue as we run with interrupts disabled but that is no longer the
> > case, and in some cases the rate of spurious interrupts is so high
> > linux detects this and actually kills the interrupt.
> >
> > Fix up by disabling the callbacks before polling the tx vq.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/net/virtio_net.c | 16 ++++++++++++----
> >   1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c29f42d1e04f..a83dc038d8af 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1433,7 +1433,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
> >               return;
> >
> >       if (__netif_tx_trylock(txq)) {
> > -             free_old_xmit_skbs(sq, true);
> > +             do {
> > +                     virtqueue_disable_cb(sq->vq);
> > +                     free_old_xmit_skbs(sq, true);
> > +             } while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> >
> >               if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> >                       netif_tx_wake_queue(txq);
> > @@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >       struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
> >       bool kick = !netdev_xmit_more();
> >       bool use_napi = sq->napi.weight;
> > +     unsigned int bytes = skb->len;
> >
> >       /* Free up any pending old buffers before queueing new ones. */
> > -     free_old_xmit_skbs(sq, false);
> > +     do {
> > +             if (use_napi)
> > +                     virtqueue_disable_cb(sq->vq);
> >
> > -     if (use_napi && kick)
> > -             virtqueue_enable_cb_delayed(sq->vq);
> > +             free_old_xmit_skbs(sq, false);
> > +
> > +     } while (use_napi && kick &&
> > +            unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> >
> >       /* timestamp packet in software */
> >       skb_tx_timestamp(skb);
>
> This patch seems to introduce a problem with QEMU connected to passt using netdev stream
> backend.
>
> When I run an iperf3 test I get after 1 or 2 seconds of test:
>
> [  254.035559] NETDEV WATCHDOG: ens3 (virtio_net): transmit queue 0 timed out
> ...
> [  254.060962] virtio_net virtio1 ens3: TX timeout on queue: 0, sq: output.0, vq: 0x1,
> name: output.0, 8856000 usecs ago
> [  259.155150] virtio_net virtio1 ens3: TX timeout on queue: 0, sq: output.0, vq: 0x1,
> name: output.0, 13951000 usecs ago
>
> In QEMU, I can see in virtio_net_tx_bh() the function virtio_net_flush_tx() has flushed
> all the queue entries and re-enabled the queue notification with
> virtio_queue_set_notification() and tries to flush again the queue and as it is empty it
> does nothing more and then rely on a kernel notification to re-enable the bottom half
> function. As this notification never comes the queue is stuck and kernel add entries but
> QEMU doesn't remove them:
>
> 2812 static void virtio_net_tx_bh(void *opaque)
> 2813 {
> ...
> 2833     ret = virtio_net_flush_tx(q);
>
> -> flush the queue and ret is not an error and not n->tx_burst (that would re-schedule the
> function)
>
> ...
> 2850     virtio_queue_set_notification(q->tx_vq, 1);
>
> -> re-enable the queue notification
>
> 2851     ret = virtio_net_flush_tx(q);
> 2852     if (ret == -EINVAL) {
> 2853         return;
> 2854     } else if (ret > 0) {
> 2855         virtio_queue_set_notification(q->tx_vq, 0);
> 2856         qemu_bh_schedule(q->tx_bh);
> 2857         q->tx_waiting = 1;
> 2858     }
>
> -> ret is 0, exit the function without re-scheduling the function.
> ...
> 2859 }
>
> If I revert this patch in the kernel (a7766ef18b33 ("virtio_net: disable cb
> aggressively")), it works fine.
>
> How to reproduce it:
>
> I start passt (https://passt.top/passt):
>
> passt -f
>
> and then QEMU
>
> qemu-system-x86_64 ... --netdev
> stream,id=netdev0,server=off,addr.type=unix,addr.path=/tmp/passt_1.socket -device
> virtio-net,mac=9a:2b:2c:2d:2e:2f,netdev=netdev0
>
> Host side:
>
> sysctl -w net.core.rmem_max=134217728
> sysctl -w net.core.wmem_max=134217728
> iperf3 -s
>
> Guest side:
>
> sysctl -w net.core.rmem_max=536870912
> sysctl -w net.core.wmem_max=536870912
>
> ip link set dev $DEV mtu 256
> iperf3 -c $HOST -t10 -i0 -Z -P 8 -l 1M --pacing-timer 1000000 -w 4M
>
> Any idea of what is the problem?

This looks similar to what I spot and try to fix in:

[PATCH net V3] virtio-net: correctly enable callback during start_xmit

(I've cced you in this version).

Thanks

>
> Thanks,
> Laurent
>
>

