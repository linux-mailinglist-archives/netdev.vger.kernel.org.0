Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5511830C21A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhBBOlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhBBOjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:39:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE3C061788
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 06:38:25 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so6053174ejc.8
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 06:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sJBLZtGoam24iH2FvzLjuKUNzi7tkEBGkd3QuKnfqzM=;
        b=nTpvMjoaKg7z31XgCm+eqDiAo1l3Yh1WP+BjxPxK8f2kk9sZmuD0sNs0AQKV9louDI
         OTc1XZEJfAIY5g8f46ylTRIgtOr1yUKSxNDoIr9BiqEAXt4grBAykEvbu20d9nl23yld
         eV2jP0APc50wwBzUnFRVOqsKuO1Bq4vSNjDqvyD9jVRdejRtaO8qkJFG6bSKk0TYqP4D
         62XeHumgJjmFL9rNMSvFeehQ7PGA0w2kKuK9eEPDXd0qhLtCENLB0fmSLEWbOHbO4oGj
         sfZaCuxSqyL10A5F7PG8vs7FZOy+0PUuy7n4AU9KGWFSVUz2aAkCExSvdkOhYE8M/ix/
         bA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sJBLZtGoam24iH2FvzLjuKUNzi7tkEBGkd3QuKnfqzM=;
        b=jl9TYw5iTJF05BhGIR4gqbkXBSfrteaaO7eVCvcdv2/5tY8hyu0wapbljRGfZOwQa7
         EQUoj0TBQFeKAPZBZ2SV06wdiqGyNvFmRYWC0rtkpGs2y/KYuxRCJHO6lB+Z0GZ4DgdO
         ylzSiv53I260cDlaY7rIaazuDoPTocnvOuWB2Eu72ye9SC+ktV32MYKDPW7cdex5mE6C
         QtCnfp1yippHNN/P0Hw3AjshcIbUWo6tINbulRg3fXWJh0DsppknS0KXxiMDx1nFKXWh
         ioz73i6PXz4ho8qhScfjeJNewWOVKiwmGyslJ+j6X333KgLrCL7OeS21cjaI0SrkIO4E
         W2Ug==
X-Gm-Message-State: AOAM531ulL66vKIAE3YTR56vFpzbVOprbUUeRYIG8uZl6t+TMcXJr7ip
        ASkUYaEyIhX+I50Lem6QyBkdZH1SQZYegb1EkOY=
X-Google-Smtp-Source: ABdhPJz7Wkol/Clz5Me9ulCgBXb4UGPaU7Uh1nT5QODx6s1RWG7NxLiq5yPvsaPsLBOaJ6Jv+lOfvqON2cJRkpWN6Ig=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr10797619ejw.11.1612276704131;
 Tue, 02 Feb 2021 06:38:24 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
In-Reply-To: <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 09:37:46 -0500
Message-ID: <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:09 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/29 =E4=B8=8A=E5=8D=888:21, Wei Wang wrote:
> > With the implementation of napi-tx in virtio driver, we clean tx
> > descriptors from rx napi handler, for the purpose of reducing tx
> > complete interrupts. But this could introduce a race where tx complete
> > interrupt has been raised, but the handler found there is no work to do
> > because we have done the work in the previous rx interrupt handler.
> > This could lead to the following warning msg:
> > [ 3588.010778] irq 38: nobody cared (try booting with the
> > "irqpoll" option)
> > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > [ 3588.017940] Call Trace:
> > [ 3588.017942]  <IRQ>
> > [ 3588.017951]  dump_stack+0x63/0x85
> > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > [ 3588.017961]  handle_irq+0x20/0x30
> > [ 3588.017964]  do_IRQ+0x50/0xe0
> > [ 3588.017966]  common_interrupt+0xf/0xf
> > [ 3588.017966]  </IRQ>
> > [ 3588.017989] handlers:
> > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > [ 3588.025099] Disabling IRQ #38
> >
> > This patch adds a new param to struct vring_virtqueue, and we set it fo=
r
> > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > case.
> >
> > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > Reported-by: Rick Jones <jonesrick@google.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
>
> Please use get_maintainer.pl to make sure Michael and me were cced.

Will do. Sorry about that. I suggested just the virtualization list, my bad=
.

>
> > ---
> >   drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >   drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >   include/linux/virtio.h       |  2 ++
> >   3 files changed, 32 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 508408fbe78f..e9a3f30864e8 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtn=
et_info *vi,
> >               return;
> >       }
> >
> > +     /* With napi_tx enabled, free_old_xmit_skbs() could be called fro=
m
> > +      * rx napi handler. Set work_steal to suppress bad irq warning fo=
r
> > +      * IRQ_NONE case from tx complete interrupt handler.
> > +      */
> > +     virtqueue_set_work_steal(vq, true);
> > +
> >       return virtnet_napi_enable(vq, napi);
>
>
> Do we need to force the ordering between steal set and napi enable?

The warning only occurs after one hundred spurious interrupts, so not
really.

>
> >   }
> >
> > -static void virtnet_napi_tx_disable(struct napi_struct *napi)
> > +static void virtnet_napi_tx_disable(struct virtqueue *vq,
> > +                                 struct napi_struct *napi)
> >   {
> > -     if (napi->weight)
> > +     if (napi->weight) {
> >               napi_disable(napi);
> > +             virtqueue_set_work_steal(vq, false);
> > +     }
> >   }
> >
> >   static void refill_work(struct work_struct *work)
> > @@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
> >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >               xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >               napi_disable(&vi->rq[i].napi);
> > -             virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +             virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
> >       }
> >
> >       return 0;
> > @@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_dev=
ice *vdev)
> >       if (netif_running(vi->dev)) {
> >               for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >                       napi_disable(&vi->rq[i].napi);
> > -                     virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +                     virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].=
napi);
> >               }
> >       }
> >   }
> > @@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev=
, struct bpf_prog *prog,
> >       if (netif_running(dev)) {
> >               for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >                       napi_disable(&vi->rq[i].napi);
> > -                     virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +                     virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].=
napi);
> >               }
> >       }
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.=
c
> > index 71e16b53e9c1..f7c5d697c302 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -105,6 +105,9 @@ struct vring_virtqueue {
> >       /* Host publishes avail event idx */
> >       bool event;
> >
> > +     /* Tx side napi work could be done from rx side. */
> > +     bool work_steal;
>
>
> So vring_vritqueue is a general structure, let's avoid mentioning
> network specific stuffs here. And we need a better name like
> "no_interrupt_check"?
>
> And we need a separate patch for virtio core changes.

Ack. Will change.

>
> > +
> >       /* Head of free buffer list. */
> >       unsigned int free_head;
> >       /* Number we've added since last sync. */
> > @@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_p=
acked(
> >       vq->notify =3D notify;
> >       vq->weak_barriers =3D weak_barriers;
> >       vq->broken =3D false;
> > +     vq->work_steal =3D false;
> >       vq->last_used_idx =3D 0;
> >       vq->num_added =3D 0;
> >       vq->packed_ring =3D true;
> > @@ -2038,6 +2042,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> >
> >       if (!more_used(vq)) {
> >               pr_debug("virtqueue interrupt with no work for %p\n", vq)=
;
>
>
> Do we still need to keep this warning?

Come to think of it, I would say no, in this case.

>
>
> > +             if (vq->work_steal)
> > +                     return IRQ_HANDLED;
>
>
> So I wonder instead of doing trick like this, maybe it's time to unify
> TX/RX NAPI with the help of[1] (virtio-net use queue pairs).
>
> Thanks
>
> [1] https://lkml.org/lkml/2014/12/25/169

Interesting idea. It does sound like a good fit for this model. The
patch in the Fixes line proved effective at suppressing unnecessary TX
interrupts when processing in RX interrupt handler. So not sure how
much will help in practice. Might be a nice project to evaluate
separate for net-next at some point.

Thanks for the review!
