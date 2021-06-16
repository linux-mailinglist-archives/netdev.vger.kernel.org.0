Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDAE3A96F8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhFPKMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhFPKMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:12:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00166C061574;
        Wed, 16 Jun 2021 03:10:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e20so1603747pgg.0;
        Wed, 16 Jun 2021 03:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q6cdXI8avYlQAAsqUuzqUKr7cSdDXO6u/YYwgqUq8yI=;
        b=XmmavSzaCBQ3I0VVPQyXgnPdKS87Y/XrElXHiXaNlh9IRXROGqJ3W5ZR5gworg6iu5
         FbuSJCekJHlRsqk402LGhay4jLi8vCGc71CaMRmBAsKIxGK/+RJCZEF47AC89eEhAKrz
         T4g8xIha8fl3iJ3ymidZTk65WRXpGYOrxmCVQzwWVLPaPL1YQtYSw77mb5fpD/LLr/bt
         pgC0sqLUhttmUyIhiJk0FiHgk2ljzAFa0IZPmERvTf3wAAlDfwHkA6N5+r6SdGJvphXz
         EI+rPHFKWN3swfXrb5Az8WNgrqG2kl4B26vxA2bz0p4WkiGi3vRyyJ+bMOv9IP/LEocS
         9Kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q6cdXI8avYlQAAsqUuzqUKr7cSdDXO6u/YYwgqUq8yI=;
        b=iPzt8ekb74DEFt4CWrDyG4Y/WyKSANj7cv8GJUup2Bh3aNwHHjVvzMaokIIUP6GGQ0
         opdY7QeJIIeeQda5en5YRkBrvini4W1RfrK9B5SL8iM/Zaml7zYJ2XjUmQUpvpEX9gE6
         /ucgyAz37sJ9IlKjr6IZYTkwGrRg2vUJ+KYEokFFkw4l1C9LJPseIfPG3VY3reDjx8Ay
         MhfR4qiFpHUNztuh6aqM2NStZj7ZzPiAqnORSLEP9kaQ16205xkHxfC67o+S6huVEFQX
         9xJh4/qNyk7hmAPck1mIHMWLyjRvyGAbqWK/hzqNevFfQvmYt7kKLD4Unf0Y3oZZ3pSO
         QOIA==
X-Gm-Message-State: AOAM5313Jyko+XftlYpCJzuIU8szXXrkLIh2osbkkHqYiK2xe4YlyNuc
        MzAQauT7dXaQw/AGAm35rUgzhgDVGzT0zcpB1Nc=
X-Google-Smtp-Source: ABdhPJxSjZpl+CqEj6Rb8eg4DqdWwwtku1oFaY79oAQUzML1Cb3O2dqIoS66oktmmk6t2qIcxTQooRy1cZtnKS0IXgc=
X-Received: by 2002:a63:f817:: with SMTP id n23mr4227113pgh.208.1623838216721;
 Wed, 16 Jun 2021 03:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-13-xuanzhuo@linux.alibaba.com> <99116ba9-9c17-a519-471d-98ae96d049d9@redhat.com>
In-Reply-To: <99116ba9-9c17-a519-471d-98ae96d049d9@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 16 Jun 2021 12:10:05 +0200
Message-ID: <CAJ8uoz3Ji9qWWzKftaT5H8jD+mt8kUUnSykztkcxphMrY7jGUw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 12/15] virtio-net: support AF_XDP zc tx
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        "dust . li" <dust.li@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 11:27 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=884:22, Xuan Zhuo =E5=86=99=E9=81=93:
> > AF_XDP(xdp socket, xsk) is a high-performance packet receiving and
> > sending technology.
> >
> > This patch implements the binding and unbinding operations of xsk and
> > the virtio-net queue for xsk zero copy xmit.
> >
> > The xsk zero copy xmit depends on tx napi. Because the actual sending
> > of data is done in the process of tx napi. If tx napi does not
> > work, then the data of the xsk tx queue will not be sent.
> > So if tx napi is not true, an error will be reported when bind xsk.
> >
> > If xsk is active, it will prevent ethtool from modifying tx napi.
> >
> > When reclaiming ptr, a new type of ptr is added, which is distinguished
> > based on the last two digits of ptr:
> > 00: skb
> > 01: xdp frame
> > 10: xsk xmit ptr
> >
> > All sent xsk packets share the virtio-net header of xsk_hdr. If xsk
> > needs to support csum and other functions later, consider assigning xsk
> > hdr separately for each sent packet.
> >
> > Different from other physical network cards, you can reinitialize the
> > channel when you bind xsk. And vrtio does not support independent reset
> > channel, you can only reset the entire device. I think it is not
> > appropriate for us to directly reset the entire setting. So the
> > situation becomes a bit more complicated. We have to consider how
> > to deal with the buffer referenced in vq after xsk is unbind.
> >
> > I added the ring size struct virtnet_xsk_ctx when xsk been bind. Each x=
sk
> > buffer added to vq corresponds to a ctx. This ctx is used to record the
> > page where the xsk buffer is located, and add a page reference. When th=
e
> > buffer is recycling, reduce the reference to page. When xsk has been
> > unbind, and all related xsk buffers have been recycled, release all ctx=
.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > ---
> >   drivers/net/virtio/Makefile     |   1 +
> >   drivers/net/virtio/virtio_net.c |  20 +-
> >   drivers/net/virtio/virtio_net.h |  37 +++-
> >   drivers/net/virtio/xsk.c        | 346 +++++++++++++++++++++++++++++++=
+
> >   drivers/net/virtio/xsk.h        |  99 +++++++++
> >   5 files changed, 497 insertions(+), 6 deletions(-)
> >   create mode 100644 drivers/net/virtio/xsk.c
> >   create mode 100644 drivers/net/virtio/xsk.h
> >
> > diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
> > index ccc80f40f33a..db79d2e7925f 100644
> > --- a/drivers/net/virtio/Makefile
> > +++ b/drivers/net/virtio/Makefile
> > @@ -4,3 +4,4 @@
> >   #
> >
> >   obj-$(CONFIG_VIRTIO_NET) +=3D virtio_net.o
> > +obj-$(CONFIG_VIRTIO_NET) +=3D xsk.o
> > diff --git a/drivers/net/virtio/virtio_net.c b/drivers/net/virtio/virti=
o_net.c
> > index 395ec1f18331..40d7751f1c5f 100644
> > --- a/drivers/net/virtio/virtio_net.c
> > +++ b/drivers/net/virtio/virtio_net.c
> > @@ -1423,6 +1423,7 @@ static int virtnet_poll_tx(struct napi_struct *na=
pi, int budget)
> >
> >       txq =3D netdev_get_tx_queue(vi->dev, index);
> >       __netif_tx_lock(txq, raw_smp_processor_id());
> > +     work_done +=3D virtnet_poll_xsk(sq, budget);
> >       free_old_xmit(sq, true);
> >       __netif_tx_unlock(txq);
> >
> > @@ -2133,8 +2134,16 @@ static int virtnet_set_coalesce(struct net_devic=
e *dev,
> >       if (napi_weight ^ vi->sq[0].napi.weight) {
> >               if (dev->flags & IFF_UP)
> >                       return -EBUSY;
> > -             for (i =3D 0; i < vi->max_queue_pairs; i++)
> > +
> > +             for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > +                     /* xsk xmit depend on the tx napi. So if xsk is a=
ctive,
> > +                      * prevent modifications to tx napi.
> > +                      */
> > +                     if (rtnl_dereference(vi->sq[i].xsk.pool))
> > +                             continue;
>
>
> So this can result tx NAPI is used by some queues buy not the others. I
> think such inconsistency breaks the semantic of set_coalesce() which
> assumes the operation is done at the device not some specific queues.
>
> How about just fail here?
>
>
> > +
> >                       vi->sq[i].napi.weight =3D napi_weight;
> > +             }
> >       }
> >
> >       return 0;
> > @@ -2407,6 +2416,8 @@ static int virtnet_xdp(struct net_device *dev, st=
ruct netdev_bpf *xdp)
> >       switch (xdp->command) {
> >       case XDP_SETUP_PROG:
> >               return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
> > +     case XDP_SETUP_XSK_POOL:
> > +             return virtnet_xsk_pool_setup(dev, xdp);
> >       default:
> >               return -EINVAL;
> >       }
> > @@ -2466,6 +2477,7 @@ static const struct net_device_ops virtnet_netdev=
 =3D {
> >       .ndo_vlan_rx_kill_vid =3D virtnet_vlan_rx_kill_vid,
> >       .ndo_bpf                =3D virtnet_xdp,
> >       .ndo_xdp_xmit           =3D virtnet_xdp_xmit,
> > +     .ndo_xsk_wakeup         =3D virtnet_xsk_wakeup,
> >       .ndo_features_check     =3D passthru_features_check,
> >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> >       .ndo_set_features       =3D virtnet_set_features,
> > @@ -2569,10 +2581,12 @@ static void free_unused_bufs(struct virtnet_inf=
o *vi)
> >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >               struct virtqueue *vq =3D vi->sq[i].vq;
> >               while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D NUL=
L) {
> > -                     if (!is_xdp_frame(buf))
> > +                     if (is_skb_ptr(buf))
> >                               dev_kfree_skb(buf);
> > -                     else
> > +                     else if (is_xdp_frame(buf))
> >                               xdp_return_frame(ptr_to_xdp(buf));
> > +                     else
> > +                             virtnet_xsk_ctx_tx_put(ptr_to_xsk(buf));
> >               }
> >       }
> >
> > diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virti=
o_net.h
> > index 931cc81f92fb..e3da829887dc 100644
> > --- a/drivers/net/virtio/virtio_net.h
> > +++ b/drivers/net/virtio/virtio_net.h
> > @@ -135,6 +135,16 @@ struct send_queue {
> >       struct virtnet_sq_stats stats;
> >
> >       struct napi_struct napi;
> > +
> > +     struct {
> > +             struct xsk_buff_pool __rcu *pool;
> > +
> > +             /* xsk wait for tx inter or softirq */
> > +             bool need_wakeup;
> > +
> > +             /* ctx used to record the page added to vq */
> > +             struct virtnet_xsk_ctx_head *ctx_head;
> > +     } xsk;
> >   };
> >
> >   /* Internal representation of a receive virtqueue */
> > @@ -188,6 +198,13 @@ static inline void virtqueue_napi_schedule(struct =
napi_struct *napi,
> >       }
> >   }
> >
> > +#include "xsk.h"
> > +
> > +static inline bool is_skb_ptr(void *ptr)
> > +{
> > +     return !((unsigned long)ptr & (VIRTIO_XDP_FLAG | VIRTIO_XSK_FLAG)=
);
> > +}
> > +
> >   static inline bool is_xdp_frame(void *ptr)
> >   {
> >       return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > @@ -206,25 +223,39 @@ static inline struct xdp_frame *ptr_to_xdp(void *=
ptr)
> >   static inline void __free_old_xmit(struct send_queue *sq, bool in_nap=
i,
> >                                  struct virtnet_sq_stats *stats)
> >   {
> > +     unsigned int xsknum =3D 0;
> >       unsigned int len;
> >       void *ptr;
> >
> >       while ((ptr =3D virtqueue_get_buf(sq->vq, &len)) !=3D NULL) {
> > -             if (!is_xdp_frame(ptr)) {
> > +             if (is_skb_ptr(ptr)) {
> >                       struct sk_buff *skb =3D ptr;
> >
> >                       pr_debug("Sent skb %p\n", skb);
> >
> >                       stats->bytes +=3D skb->len;
> >                       napi_consume_skb(skb, in_napi);
> > -             } else {
> > +             } else if (is_xdp_frame(ptr)) {
> >                       struct xdp_frame *frame =3D ptr_to_xdp(ptr);
> >
> >                       stats->bytes +=3D frame->len;
> >                       xdp_return_frame(frame);
> > +             } else {
> > +                     struct virtnet_xsk_ctx_tx *ctx;
> > +
> > +                     ctx =3D ptr_to_xsk(ptr);
> > +
> > +                     /* Maybe this ptr was sent by the last xsk. */
> > +                     if (ctx->ctx.head->active)
> > +                             ++xsknum;
> > +
> > +                     stats->bytes +=3D ctx->len;
> > +                     virtnet_xsk_ctx_tx_put(ctx);
> >               }
> >               stats->packets++;
> >       }
> > -}
> >
> > +     if (xsknum)
> > +             virtnet_xsk_complete(sq, xsknum);
> > +}
> >   #endif
> > diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
> > new file mode 100644
> > index 000000000000..f98b68576709
> > --- /dev/null
> > +++ b/drivers/net/virtio/xsk.c
> > @@ -0,0 +1,346 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * virtio-net xsk
> > + */
> > +
> > +#include "virtio_net.h"
> > +
> > +static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
> > +
> > +static struct virtnet_xsk_ctx *virtnet_xsk_ctx_get(struct virtnet_xsk_=
ctx_head *head)
> > +{
> > +     struct virtnet_xsk_ctx *ctx;
> > +
> > +     ctx =3D head->ctx;
> > +     head->ctx =3D ctx->next;
> > +
> > +     ++head->ref;
> > +
> > +     return ctx;
> > +}
> > +
> > +#define virtnet_xsk_ctx_tx_get(head) ((struct virtnet_xsk_ctx_tx *)vir=
tnet_xsk_ctx_get(head))
> > +
> > +static void virtnet_xsk_check_queue(struct send_queue *sq)
> > +{
> > +     struct virtnet_info *vi =3D sq->vq->vdev->priv;
> > +     struct net_device *dev =3D vi->dev;
> > +     int qnum =3D sq - vi->sq;
> > +
> > +     /* If it is a raw buffer queue, it does not check whether the sta=
tus
> > +      * of the queue is stopped when sending. So there is no need to c=
heck
> > +      * the situation of the raw buffer queue.
> > +      */
> > +     if (is_xdp_raw_buffer_queue(vi, qnum))
> > +             return;
> > +
> > +     /* If this sq is not the exclusive queue of the current cpu,
> > +      * then it may be called by start_xmit, so check it running out
> > +      * of space.
> > +      *
> > +      * Stop the queue to avoid getting packets that we are
> > +      * then unable to transmit. Then wait the tx interrupt.
> > +      */
> > +     if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
> > +             netif_stop_subqueue(dev, qnum);
> > +}
> > +
> > +void virtnet_xsk_complete(struct send_queue *sq, u32 num)
> > +{
> > +     struct xsk_buff_pool *pool;
> > +
> > +     rcu_read_lock();
> > +     pool =3D rcu_dereference(sq->xsk.pool);
> > +     if (!pool) {
> > +             rcu_read_unlock();
> > +             return;
> > +     }
> > +     xsk_tx_completed(pool, num);
> > +     rcu_read_unlock();
> > +
> > +     if (sq->xsk.need_wakeup) {
> > +             sq->xsk.need_wakeup =3D false;
> > +             virtqueue_napi_schedule(&sq->napi, sq->vq);
> > +     }
> > +}
> > +
> > +static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_poo=
l *pool,
> > +                         struct xdp_desc *desc)
> > +{
> > +     struct virtnet_xsk_ctx_tx *ctx;
> > +     struct virtnet_info *vi;
> > +     u32 offset, n, len;
> > +     struct page *page;
> > +     void *data;
> > +
> > +     vi =3D sq->vq->vdev->priv;
> > +
> > +     data =3D xsk_buff_raw_get_data(pool, desc->addr);
> > +     offset =3D offset_in_page(data);
> > +
> > +     ctx =3D virtnet_xsk_ctx_tx_get(sq->xsk.ctx_head);
> > +
> > +     /* xsk unaligned mode, desc may use two pages */
> > +     if (desc->len > PAGE_SIZE - offset)
> > +             n =3D 3;
> > +     else
> > +             n =3D 2;
> > +
> > +     sg_init_table(sq->sg, n);
> > +     sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
> > +
> > +     /* handle for xsk first page */
> > +     len =3D min_t(int, desc->len, PAGE_SIZE - offset);
> > +     page =3D vmalloc_to_page(data);
> > +     sg_set_page(sq->sg + 1, page, len, offset);
> > +
> > +     /* ctx is used to record and reference this page to prevent xsk f=
rom
> > +      * being released before this xmit is recycled
> > +      */
>
>
> I'm a little bit surprised that this is done manually per device instead
> of doing it in xsk core.

The pages that the data pointer points to are pinned by the xsk core
so they will not be released until the socket dies. In this case, we
will do a synchronize_net() to wait for the driver to stop using the
socket (and any pages), then start cleaning everything up. During this
clean up, ndo_bpf is called with the command XDP_SETUP_XSK_POOL with a
NULL pool pointer which means that the driver should tear the zero
copy path down and not use it anymore. Not until after that has
completed, is the umem memory with all its packet buffers released. Do
not see why this extra refcounting is needed, but might have missed
something of course. Is there something special with the virtio-net
driver we need to take care about in this context?

>
> > +     ctx->ctx.page =3D page;
> > +     get_page(page);
> > +
> > +     /* xsk unaligned mode, handle for the second page */
> > +     if (len < desc->len) {
> > +             page =3D vmalloc_to_page(data + len);
> > +             len =3D min_t(int, desc->len - len, PAGE_SIZE);
> > +             sg_set_page(sq->sg + 2, page, len, 0);
> > +
> > +             ctx->ctx.page_unaligned =3D page;
> > +             get_page(page);
> > +     } else {
> > +             ctx->ctx.page_unaligned =3D NULL;
> > +     }
> > +
> > +     return virtqueue_add_outbuf(sq->vq, sq->sg, n,
> > +                                xsk_to_ptr(ctx), GFP_ATOMIC);
> > +}
> > +
> > +static int virtnet_xsk_xmit_batch(struct send_queue *sq,
> > +                               struct xsk_buff_pool *pool,
> > +                               unsigned int budget,
> > +                               bool in_napi, int *done,
> > +                               struct virtnet_sq_stats *stats)
> > +{
> > +     struct xdp_desc desc;
> > +     int err, packet =3D 0;
> > +     int ret =3D -EAGAIN;
> > +
> > +     while (budget-- > 0) {
> > +             if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
>
>
> AF_XDP doesn't use skb, so I don't see why MAX_SKB_FRAGS is used.
>
> Looking at virtnet_xsk_xmit(), it looks to me 3 is more suitable here.
> Or did AF_XDP core can handle queue full gracefully then we don't even
> need to worry about this?

We need to make sure that there is enough space in the outgoing queue
/ HW Tx ring somewhere. The easiest place to do this is before you get
the next packet from the Tx ring, as you would have to return it if
there was not enough space. Note that we do not have a function for
returning a packet to the Tx ring at the moment and I would like to
avoid adding one. As Jason says, no reason to test for anything skb
here. The zero-copy path never uses skbs, unless you get an XDP_PASS
from an XDP program.

>
> > +                     ret =3D -EBUSY;
>
>
> -ENOSPC looks better.
>
>
> > +                     break;
> > +             }
> > +
> > +             if (!xsk_tx_peek_desc(pool, &desc)) {
> > +                     /* done */
> > +                     ret =3D 0;
> > +                     break;
> > +             }
> > +
> > +             err =3D virtnet_xsk_xmit(sq, pool, &desc);
> > +             if (unlikely(err)) {
>
>
> If we always reserve sufficient slots, this should be an unexpected
> error, do we need log this as what has been done in start_xmit()?
>
>          /* This should not happen! */
>          if (unlikely(err)) {
>                  dev->stats.tx_fifo_errors++;
>                  if (net_ratelimit())
>                          dev_warn(&dev->dev,
>                                   "Unexpected TXQ (%d) queue failure: %d\=
n",
>                                   qnum, err);
>
>
> > +                     ret =3D -EBUSY;
> > +                     break;
> > +             }
> > +
> > +             ++packet;
> > +     }
> > +
> > +     if (packet) {
> > +             if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq=
->vq))
> > +                     ++stats->kicks;
> > +
> > +             *done +=3D packet;
> > +             stats->xdp_tx +=3D packet;
> > +
> > +             xsk_tx_release(pool);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool=
 *pool,
> > +                        int budget, bool in_napi)
> > +{
> > +     struct virtnet_sq_stats stats =3D {};
> > +     int done =3D 0;
> > +     int err;
> > +
> > +     sq->xsk.need_wakeup =3D false;
> > +     __free_old_xmit(sq, in_napi, &stats);
> > +
> > +     /* return err:
> > +      * -EAGAIN: done =3D=3D budget
> > +      * -EBUSY:  done < budget
> > +      *  0    :  done < budget
> > +      */
>
>
> It's better to move the comment to the implementation of
> virtnet_xsk_xmit_batch().
>
>
> > +xmit:
> > +     err =3D virtnet_xsk_xmit_batch(sq, pool, budget - done, in_napi,
> > +                                  &done, &stats);
> > +     if (err =3D=3D -EBUSY) {
> > +             __free_old_xmit(sq, in_napi, &stats);
> > +
> > +             /* If the space is enough, let napi run again. */
> > +             if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS)
>
>
> The comment does not match the code.
>
>
> > +                     goto xmit;
> > +             else
> > +                     sq->xsk.need_wakeup =3D true;
> > +     }
> > +
> > +     virtnet_xsk_check_queue(sq);
> > +
> > +     u64_stats_update_begin(&sq->stats.syncp);
> > +     sq->stats.packets +=3D stats.packets;
> > +     sq->stats.bytes +=3D stats.bytes;
> > +     sq->stats.kicks +=3D stats.kicks;
> > +     sq->stats.xdp_tx +=3D stats.xdp_tx;
> > +     u64_stats_update_end(&sq->stats.syncp);
> > +
> > +     return done;
> > +}
> > +
> > +int virtnet_poll_xsk(struct send_queue *sq, int budget)
> > +{
> > +     struct xsk_buff_pool *pool;
> > +     int work_done =3D 0;
> > +
> > +     rcu_read_lock();
> > +     pool =3D rcu_dereference(sq->xsk.pool);
> > +     if (pool)
> > +             work_done =3D virtnet_xsk_run(sq, pool, budget, true);
> > +     rcu_read_unlock();
> > +     return work_done;
> > +}
> > +
> > +int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct xsk_buff_pool *pool;
> > +     struct send_queue *sq;
> > +
> > +     if (!netif_running(dev))
> > +             return -ENETDOWN;
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
>
>
> I wonder how we can hit this check. Note that we prevent the user from
> modifying queue pairs when XDP is enabled:
>
>          /* For now we don't support modifying channels while XDP is load=
ed
>           * also when XDP is loaded all RX queues have XDP programs so
> we only
>           * need to check a single RX queue.
>           */
>          if (vi->rq[0].xdp_prog)
>                  return -EINVAL;
>
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     rcu_read_lock();
>
>
> Can we simply use rcu_read_lock_bh() here?
>
>
> > +     pool =3D rcu_dereference(sq->xsk.pool);
> > +     if (pool) {
> > +             local_bh_disable();
> > +             virtqueue_napi_schedule(&sq->napi, sq->vq);
> > +             local_bh_enable();
> > +     }
> > +     rcu_read_unlock();
> > +     return 0;
> > +}
> > +
> > +static struct virtnet_xsk_ctx_head *virtnet_xsk_ctx_alloc(struct xsk_b=
uff_pool *pool,
> > +                                                       struct virtqueu=
e *vq)
> > +{
> > +     struct virtnet_xsk_ctx_head *head;
> > +     u32 size, n, ring_size, ctx_sz;
> > +     struct virtnet_xsk_ctx *ctx;
> > +     void *p;
> > +
> > +     ctx_sz =3D sizeof(struct virtnet_xsk_ctx_tx);
> > +
> > +     ring_size =3D virtqueue_get_vring_size(vq);
> > +     size =3D sizeof(*head) + ctx_sz * ring_size;
> > +
> > +     head =3D kmalloc(size, GFP_ATOMIC);
> > +     if (!head)
> > +             return NULL;
> > +
> > +     memset(head, 0, sizeof(*head));
> > +
> > +     head->active =3D true;
> > +     head->frame_size =3D xsk_pool_get_rx_frame_size(pool);
> > +
> > +     p =3D head + 1;
> > +     for (n =3D 0; n < ring_size; ++n) {
> > +             ctx =3D p;
> > +             ctx->head =3D head;
> > +             ctx->next =3D head->ctx;
> > +             head->ctx =3D ctx;
> > +
> > +             p +=3D ctx_sz;
> > +     }
> > +
> > +     return head;
> > +}
> > +
> > +static int virtnet_xsk_pool_enable(struct net_device *dev,
> > +                                struct xsk_buff_pool *pool,
> > +                                u16 qid)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct send_queue *sq;
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     /* xsk zerocopy depend on the tx napi.
> > +      *
> > +      * All data is actually consumed and sent out from the xsk tx que=
ue
> > +      * under the tx napi mechanism.
> > +      */
> > +     if (!sq->napi.weight)
> > +             return -EPERM;
> > +
> > +     memset(&sq->xsk, 0, sizeof(sq->xsk));
> > +
> > +     sq->xsk.ctx_head =3D virtnet_xsk_ctx_alloc(pool, sq->vq);
> > +     if (!sq->xsk.ctx_head)
> > +             return -ENOMEM;
> > +
> > +     /* Here is already protected by rtnl_lock, so rcu_assign_pointer =
is
> > +      * safe.
> > +      */
> > +     rcu_assign_pointer(sq->xsk.pool, pool);
> > +
> > +     return 0;
> > +}
> > +
> > +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct send_queue *sq;
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     /* Here is already protected by rtnl_lock, so rcu_assign_pointer =
is
> > +      * safe.
> > +      */
> > +     rcu_assign_pointer(sq->xsk.pool, NULL);
> > +
> > +     /* Sync with the XSK wakeup and with NAPI. */
> > +     synchronize_net();
> > +
> > +     if (READ_ONCE(sq->xsk.ctx_head->ref))
> > +             WRITE_ONCE(sq->xsk.ctx_head->active, false);
> > +     else
> > +             kfree(sq->xsk.ctx_head);
> > +
> > +     sq->xsk.ctx_head =3D NULL;
> > +
> > +     return 0;
> > +}
> > +
> > +int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *=
xdp)
> > +{
> > +     if (xdp->xsk.pool)
> > +             return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
> > +                                            xdp->xsk.queue_id);
> > +     else
> > +             return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
> > +}
> > +
> > diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
> > new file mode 100644
> > index 000000000000..54948e0b07fc
> > --- /dev/null
> > +++ b/drivers/net/virtio/xsk.h
> > @@ -0,0 +1,99 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +
> > +#ifndef __XSK_H__
> > +#define __XSK_H__
> > +
> > +#define VIRTIO_XSK_FLAG      BIT(1)
> > +
> > +/* When xsk disable, under normal circumstances, the network card must=
 reclaim
> > + * all the memory that has been sent and the memory added to the rq qu=
eue by
> > + * destroying the queue.
> > + *
> > + * But virtio's queue does not support separate setting to been disabl=
e.
>
>
> This is a call for us to implement per queue enable/disable. Virtio-mmio
> has such facility but virtio-pci only allow to disable a queue (not enabl=
e).
>
>
> > "Reset"
> > + * is not very suitable.
> > + *
> > + * The method here is that each sent chunk or chunk added to the rq qu=
eue is
> > + * described by an independent structure struct virtnet_xsk_ctx.
> > + *
> > + * We will use get_page(page) to refer to the page where these chunks =
are
> > + * located. And these pages will be recorded in struct virtnet_xsk_ctx=
. So these
> > + * chunks in vq are safe. When recycling, put the these page.
> > + *
> > + * These structures point to struct virtnet_xsk_ctx_head, and ref reco=
rds how
> > + * many chunks have not been reclaimed. If active =3D=3D 0, it means t=
hat xsk has
> > + * been disabled.
> > + *
> > + * In this way, even if xsk has been unbundled with rq/sq, or a new xs=
k and
> > + * rq/sq  are bound, and a new virtnet_xsk_ctx_head is created. It wil=
l not
> > + * affect the old virtnet_xsk_ctx to be recycled. And free all head an=
d ctx when
> > + * ref is 0.
>
>
> This looks complicated and it will increase the footprint. Consider the
> performance penalty and the complexity, I would suggest to use reset
> instead.

OK, this explains your reference counting previously. Let us keep it
simple as Jason suggests. If you need anything from the core xsk code,
just let me know. You are the first one to implement AF_XDP zero-copy
on a virtual device, so new requirements might pop up.

Thanks for working on this!

> Then we don't need to introduce such context.
>
> Thanks
>
>
> > + */
> > +struct virtnet_xsk_ctx;
> > +struct virtnet_xsk_ctx_head {
> > +     struct virtnet_xsk_ctx *ctx;
> > +
> > +     /* how many ctx has been add to vq */
> > +     u64 ref;
> > +
> > +     unsigned int frame_size;
> > +
> > +     /* the xsk status */
> > +     bool active;
> > +};
> > +
> > +struct virtnet_xsk_ctx {
> > +     struct virtnet_xsk_ctx_head *head;
> > +     struct virtnet_xsk_ctx *next;
> > +
> > +     struct page *page;
> > +
> > +     /* xsk unaligned mode will use two page in one desc */
> > +     struct page *page_unaligned;
> > +};
> > +
> > +struct virtnet_xsk_ctx_tx {
> > +     /* this *MUST* be the first */
> > +     struct virtnet_xsk_ctx ctx;
> > +
> > +     /* xsk tx xmit use this record the len of packet */
> > +     u32 len;
> > +};
> > +
> > +static inline void *xsk_to_ptr(struct virtnet_xsk_ctx_tx *ctx)
> > +{
> > +     return (void *)((unsigned long)ctx | VIRTIO_XSK_FLAG);
> > +}
> > +
> > +static inline struct virtnet_xsk_ctx_tx *ptr_to_xsk(void *ptr)
> > +{
> > +     unsigned long p;
> > +
> > +     p =3D (unsigned long)ptr;
> > +     return (struct virtnet_xsk_ctx_tx *)(p & ~VIRTIO_XSK_FLAG);
> > +}
> > +
> > +static inline void virtnet_xsk_ctx_put(struct virtnet_xsk_ctx *ctx)
> > +{
> > +     put_page(ctx->page);
> > +     if (ctx->page_unaligned)
> > +             put_page(ctx->page_unaligned);
> > +
> > +     --ctx->head->ref;
> > +
> > +     if (ctx->head->active) {
> > +             ctx->next =3D ctx->head->ctx;
> > +             ctx->head->ctx =3D ctx;
> > +     } else {
> > +             if (!ctx->head->ref)
> > +                     kfree(ctx->head);
> > +     }
> > +}
> > +
> > +#define virtnet_xsk_ctx_tx_put(ctx) \
> > +     virtnet_xsk_ctx_put((struct virtnet_xsk_ctx *)ctx)
> > +
> > +int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag);
> > +int virtnet_poll_xsk(struct send_queue *sq, int budget);
> > +void virtnet_xsk_complete(struct send_queue *sq, u32 num);
> > +int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *=
xdp);
> > +#endif
>
