Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F091330CFF7
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBBXsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBBXsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:48:24 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23466C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 15:47:44 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id s61so18939144ybi.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq/uxB02TdTmL5a2aEfv4RNVQr6KfO20BH65KlUzpuE=;
        b=nmj+Rtn67w2c3OzA9HoloEhf4iP6KAIWq0KcMFI7Bh/k4kt8EPsSrHpXQ/7LvWAt3d
         7Rynrg9a4Ql0MuBNP8jsnt2z0zfeNkqwUYFnLtk8UgxDS4c3Ywh1iukJx7G3YqIAf3EW
         Gf9I70XluXswXSaAWCwWP4cnGiOAJ9aboEyvE8zfnBkSnozcgO2Pg8G1hUffyfDC8W7J
         i/yd1sndtTe/0eGMyL5RmLb5dORfDes6EowWyPSy9VKeWGkH3CxkxSgBbdw9ss9Ho5VZ
         YanefYVoKpjFOEMSgcmI3jRKhq3PLSFsh+ZhFMOlJDDH3vRcY1D9u0Xe/v8vwCKFFVkS
         Vtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pq/uxB02TdTmL5a2aEfv4RNVQr6KfO20BH65KlUzpuE=;
        b=i51PMLZkQK9XYu4wj3PvCIHgTWcfLJr+tqg1mmOrT9DMlTJ5zXIDIEI0dcOiAEyp4H
         V/WW2wQX5wsRVLLJnjQstihBgwYBYEOWMnRi90Hqoxeq4pzKr7uuWktbdOAMlx1IWDaF
         +5ALqiEdUyUsxfXRf2EoEP2czf5CR3egXnkON4HPaqAf3sIP0T2tW42dyzHUEC735jjs
         MSeFuYpLHWdv0rVinmJQNvM1BBGt0TUTBQth5VphBy0iJUorXZAcYzKvAMey66456j+t
         I4CONKKvLlBBLOKPXQnd8/R1MdJdQqjqnqCNVku+Klp6mQ/2ai29Vd8FzbmOpPyYjM6S
         jtaQ==
X-Gm-Message-State: AOAM531fpT1xiHdaim13hcAzcHv7jUlSCPSzuo0kLucP4umspooD1KP0
        3eIqqHre2ooIUwLraYk6UBIXtfnRJ5n67bmnRmEnGg==
X-Google-Smtp-Source: ABdhPJzYmr8iRSqwdCbNuEkhDB4zvtbopX9Pj4vlDYr0eGC/dcOXA784xxy9GElSYJDVJvI/7pZa/3BLbe3C0Mlyhn0=
X-Received: by 2002:a25:10c3:: with SMTP id 186mr481197ybq.195.1612309663101;
 Tue, 02 Feb 2021 15:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210202180807-mutt-send-email-mst@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 2 Feb 2021 15:47:31 -0800
Message-ID: <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
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
> > This patch adds a new param to struct vring_virtqueue, and we set it for
> > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > case.
> >
> > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > Reported-by: Rick Jones <jonesrick@google.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
>
> This description does not make sense to me.
>
> irq X: nobody cared
> only triggers after an interrupt is unhandled repeatedly.
>
> So something causes a storm of useless tx interrupts here.
>
> Let's find out what it was please. What you are doing is
> just preventing linux from complaining.

The traffic that causes this warning is a netperf tcp_stream with at
least 128 flows between 2 hosts. And the warning gets triggered on the
receiving host, which has a lot of rx interrupts firing on all queues,
and a few tx interrupts.
And I think the scenario is: when the tx interrupt gets fired, it gets
coalesced with the rx interrupt. Basically, the rx and tx interrupts
get triggered very close to each other, and gets handled in one round
of do_IRQ(). And the rx irq handler gets called first, which calls
virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
to try to do the work on the corresponding tx queue as well. That's
why when tx interrupt handler gets called, it sees no work to do.
And the reason for the rx handler to handle the tx work is here:
https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html

>
>
>
> > ---
> >  drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >  drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >  include/linux/virtio.h       |  2 ++
> >  3 files changed, 32 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 508408fbe78f..e9a3f30864e8 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
> >               return;
> >       }
> >
> > +     /* With napi_tx enabled, free_old_xmit_skbs() could be called from
> > +      * rx napi handler. Set work_steal to suppress bad irq warning for
> > +      * IRQ_NONE case from tx complete interrupt handler.
> > +      */
> > +     virtqueue_set_work_steal(vq, true);
> > +
> >       return virtnet_napi_enable(vq, napi);
> >  }
> >
> > -static void virtnet_napi_tx_disable(struct napi_struct *napi)
> > +static void virtnet_napi_tx_disable(struct virtqueue *vq,
> > +                                 struct napi_struct *napi)
> >  {
> > -     if (napi->weight)
> > +     if (napi->weight) {
> >               napi_disable(napi);
> > +             virtqueue_set_work_steal(vq, false);
> > +     }
> >  }
> >
> >  static void refill_work(struct work_struct *work)
> > @@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
> >       for (i = 0; i < vi->max_queue_pairs; i++) {
> >               xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >               napi_disable(&vi->rq[i].napi);
> > -             virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +             virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
> >       }
> >
> >       return 0;
> > @@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> >       if (netif_running(vi->dev)) {
> >               for (i = 0; i < vi->max_queue_pairs; i++) {
> >                       napi_disable(&vi->rq[i].napi);
> > -                     virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +                     virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
> >               }
> >       }
> >  }
> > @@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> >       if (netif_running(dev)) {
> >               for (i = 0; i < vi->max_queue_pairs; i++) {
> >                       napi_disable(&vi->rq[i].napi);
> > -                     virtnet_napi_tx_disable(&vi->sq[i].napi);
> > +                     virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
> >               }
> >       }
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 71e16b53e9c1..f7c5d697c302 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -105,6 +105,9 @@ struct vring_virtqueue {
> >       /* Host publishes avail event idx */
> >       bool event;
> >
> > +     /* Tx side napi work could be done from rx side. */
> > +     bool work_steal;
> > +
> >       /* Head of free buffer list. */
> >       unsigned int free_head;
> >       /* Number we've added since last sync. */
> > @@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
> >       vq->notify = notify;
> >       vq->weak_barriers = weak_barriers;
> >       vq->broken = false;
> > +     vq->work_steal = false;
> >       vq->last_used_idx = 0;
> >       vq->num_added = 0;
> >       vq->packed_ring = true;
> > @@ -2038,6 +2042,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> >
> >       if (!more_used(vq)) {
> >               pr_debug("virtqueue interrupt with no work for %p\n", vq);
> > +             if (vq->work_steal)
> > +                     return IRQ_HANDLED;
> > +
> >               return IRQ_NONE;
> >       }
> >
> > @@ -2082,6 +2089,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> >       vq->notify = notify;
> >       vq->weak_barriers = weak_barriers;
> >       vq->broken = false;
> > +     vq->work_steal = false;
> >       vq->last_used_idx = 0;
> >       vq->num_added = 0;
> >       vq->use_dma_api = vring_use_dma_api(vdev);
> > @@ -2266,6 +2274,14 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_is_broken);
> >
> > +void virtqueue_set_work_steal(struct virtqueue *_vq, bool val)
> > +{
> > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +     vq->work_steal = val;
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_set_work_steal);
> > +
> >  /*
> >   * This should prevent the device from being used, allowing drivers to
> >   * recover.  You may need to grab appropriate locks to flush.
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 55ea329fe72a..091c30f21ff9 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -84,6 +84,8 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
> >
> >  bool virtqueue_is_broken(struct virtqueue *vq);
> >
> > +void virtqueue_set_work_steal(struct virtqueue *vq, bool val);
> > +
> >  const struct vring *virtqueue_get_vring(struct virtqueue *vq);
> >  dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
> >  dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
> > --
> > 2.30.0.365.g02bc693789-goog
> >
>
