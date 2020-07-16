Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3E221B82
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgGPEmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgGPEmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:42:53 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16D3C061755;
        Wed, 15 Jul 2020 21:42:53 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id s192so1013517vkh.3;
        Wed, 15 Jul 2020 21:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C90Ld5hDn2UDc5lBFaloxSrsSLODHsNCzSpkpNrIeCE=;
        b=gBAb3yq7VpvF5+C/ITm0DeWw3h4XOUUiUTUb6E5/d/KK/8GbWUW5TQgPArmcjGH2Hm
         7/qtMWIlBKpUusJoV7VFrIXZRUQ2sURK4j8dWOvEHwsUMJBhTUlozrxe1vXgcy8ulOa0
         Wk0EDRKMu+kH/rZ99irhk0tGbazPiVBdWnl78Ors6YMHvqlOMbfAaAKlrAFQHPih8lfp
         1TjB2cnRG3g5HnsHuZ3rJ7ddvoV/7sJ+Z5jiD/Iy55C2dHOH+CmqW8Wc3FLGZHYYBu/A
         UDMGLcLU92yz3t0XUqjS9MZ90Vp8vOSlKL/L4+MJy0wmOQbUsgkJBJoQM1v0gOtBT5cA
         SgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C90Ld5hDn2UDc5lBFaloxSrsSLODHsNCzSpkpNrIeCE=;
        b=ec41sXBlN+EYnE3FKX06rENuONH6vCVLQx+fcvUjqGymUtE+1jXSyUW5iglMJCYSLR
         L9bsGaAzgfTn/ZWVYODJbrbsAp3D1ZC0RiNjH1rHTrTA01A9T2ojhAzWPiN6R/pPwPVC
         sR72HabJFvBigaTvNCMiOi8HNeCaxkisbkOOopOX4fIcR6g+QOh8CaQx1L7t4jidSi7Z
         b/7PLz6+cozqWe+7Q44xDqYIlHvyBkaRbJgBMHXCfSISeaXg4rZYSDVFe2Cix3l6SlKV
         E5QxvdLjuUuWpmLarz6IyKYb+EF7I8JAqPaRkwsQaMLO0cwGwG2CHJuuLpg8Fn6nQ6LN
         ms0Q==
X-Gm-Message-State: AOAM530m/KRJSZY4dSkZSoeKGVfvxwhnr2xxkCClPM6cEYgw+96EYGmG
        dkiggWKkzgIQqrRs7+igY4qk90xlD6YDmvs8WhS+k82/MmlnFg==
X-Google-Smtp-Source: ABdhPJwny27/b/zWAAAzFYMp7mrI6fupUD4JNJOacgoqcnT1lvvb3f1fRCrcOewFPd26cPb2kMmBX5tw8UIXq+bC0zY=
X-Received: by 2002:a1f:e2c4:: with SMTP id z187mr1926904vkg.14.1594874572737;
 Wed, 15 Jul 2020 21:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
 <1594390602-7635-5-git-send-email-magnus.karlsson@intel.com> <0f2ff47a-d1ce-78d3-bb96-6e5bc60dc04f@mellanox.com>
In-Reply-To: <0f2ff47a-d1ce-78d3-bb96-6e5bc60dc04f@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Jul 2020 06:42:44 +0200
Message-ID: <CAJ8uoz2BqQQMfz1Q=1CHxx7DS1RkYM0REp4kaTsq4mftq7L-eQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/14] xsk: move fill and completion rings to
 buffer pool
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:29 AM Maxim Mikityanskiy
<maximmi@mellanox.com> wrote:
>
> On 2020-07-10 17:16, Magnus Karlsson wrote:
> > Move the fill and completion rings from the umem to the buffer
> > pool. This so that we in a later commit can share the umem
> > between multiple HW queue ids. In this case, we need one fill and
> > completion ring per queue id. As the buffer pool is per queue id
> > and napi id this is a natural place for it and one umem
> > struture can be shared between these buffer pools.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   include/net/xdp_sock.h      |  4 ++--
> >   include/net/xsk_buff_pool.h |  2 +-
> >   net/xdp/xdp_umem.c          | 15 ---------------
> >   net/xdp/xsk.c               | 44 ++++++++++++++++++++++++--------------------
> >   net/xdp/xsk_buff_pool.c     | 20 +++++++++++++++-----
> >   net/xdp/xsk_diag.c          | 10 ++++++----
> >   6 files changed, 48 insertions(+), 47 deletions(-)
> >
> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index b9bb118..5eb59b7 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -18,8 +18,6 @@ struct xsk_queue;
> >   struct xdp_buff;
> >
> >   struct xdp_umem {
> > -     struct xsk_queue *fq;
> > -     struct xsk_queue *cq;
> >       u64 size;
> >       u32 headroom;
> >       u32 chunk_size;
> > @@ -73,6 +71,8 @@ struct xdp_sock {
> >       struct list_head map_list;
> >       /* Protects map_list */
> >       spinlock_t map_list_lock;
> > +     struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
> > +     struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
> >   };
> >
> >   #ifdef CONFIG_XDP_SOCKETS
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index ff8592d5..0423303 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -30,6 +30,7 @@ struct xdp_buff_xsk {
> >
> >   struct xsk_buff_pool {
> >       struct xsk_queue *fq;
> > +     struct xsk_queue *cq;
> >       struct list_head free_list;
> >       dma_addr_t *dma_pages;
> >       struct xdp_buff_xsk *heads;
> > @@ -57,7 +58,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> >                                               struct xdp_umem *umem);
> >   int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> >                 u16 queue_id, u16 flags);
> > -void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
> >   void xp_destroy(struct xsk_buff_pool *pool);
> >   void xp_release(struct xdp_buff_xsk *xskb);
> >   void xp_get_pool(struct xsk_buff_pool *pool);
> > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > index f290345..7d86a63 100644
> > --- a/net/xdp/xdp_umem.c
> > +++ b/net/xdp/xdp_umem.c
> > @@ -85,16 +85,6 @@ static void xdp_umem_release(struct xdp_umem *umem)
> >
> >       ida_simple_remove(&umem_ida, umem->id);
> >
> > -     if (umem->fq) {
> > -             xskq_destroy(umem->fq);
> > -             umem->fq = NULL;
> > -     }
> > -
> > -     if (umem->cq) {
> > -             xskq_destroy(umem->cq);
> > -             umem->cq = NULL;
> > -     }
> > -
> >       xdp_umem_unpin_pages(umem);
> >
> >       xdp_umem_unaccount_pages(umem);
> > @@ -278,8 +268,3 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
> >
> >       return umem;
> >   }
> > -
> > -bool xdp_umem_validate_queues(struct xdp_umem *umem)
> > -{
> > -     return umem->fq && umem->cq;
> > -}
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index caaf298..b44b150 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -36,7 +36,7 @@ static DEFINE_PER_CPU(struct list_head, xskmap_flush_list);
> >   bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
> >   {
> >       return READ_ONCE(xs->rx) &&  READ_ONCE(xs->umem) &&
> > -             READ_ONCE(xs->umem->fq);
> > +             (xs->pool->fq || READ_ONCE(xs->fq_tmp));
> >   }
> >
> >   void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
> > @@ -46,7 +46,7 @@ void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
> >       if (umem->need_wakeup & XDP_WAKEUP_RX)
> >               return;
> >
> > -     umem->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
> > +     pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
> >       umem->need_wakeup |= XDP_WAKEUP_RX;
> >   }
> >   EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
> > @@ -76,7 +76,7 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
> >       if (!(umem->need_wakeup & XDP_WAKEUP_RX))
> >               return;
> >
> > -     umem->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> > +     pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> >       umem->need_wakeup &= ~XDP_WAKEUP_RX;
> >   }
> >   EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
> > @@ -254,7 +254,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
> >   static void xsk_flush(struct xdp_sock *xs)
> >   {
> >       xskq_prod_submit(xs->rx);
> > -     __xskq_cons_release(xs->umem->fq);
> > +     __xskq_cons_release(xs->pool->fq);
> >       sock_def_readable(&xs->sk);
> >   }
> >
> > @@ -297,7 +297,7 @@ void __xsk_map_flush(void)
> >
> >   void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
> >   {
> > -     xskq_prod_submit_n(pool->umem->cq, nb_entries);
> > +     xskq_prod_submit_n(pool->cq, nb_entries);
> >   }
> >   EXPORT_SYMBOL(xsk_tx_completed);
> >
> > @@ -329,7 +329,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
> >                * if there is space in it. This avoids having to implement
> >                * any buffering in the Tx path.
> >                */
> > -             if (xskq_prod_reserve_addr(umem->cq, desc->addr))
> > +             if (xskq_prod_reserve_addr(pool->cq, desc->addr))
> >                       goto out;
> >
> >               xskq_cons_release(xs->tx);
> > @@ -367,7 +367,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> >       unsigned long flags;
> >
> >       spin_lock_irqsave(&xs->tx_completion_lock, flags);
> > -     xskq_prod_submit_addr(xs->umem->cq, addr);
> > +     xskq_prod_submit_addr(xs->pool->cq, addr);
> >       spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
> >
> >       sock_wfree(skb);
> > @@ -411,7 +411,7 @@ static int xsk_generic_xmit(struct sock *sk)
> >                * if there is space in it. This avoids having to implement
> >                * any buffering in the Tx path.
> >                */
> > -             if (unlikely(err) || xskq_prod_reserve(xs->umem->cq)) {
> > +             if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> >                       kfree_skb(skb);
> >                       goto out;
> >               }
> > @@ -629,6 +629,11 @@ static struct socket *xsk_lookup_xsk_from_fd(int fd)
> >       return sock;
> >   }
> >
> > +static bool xsk_validate_queues(struct xdp_sock *xs)
> > +{
> > +     return xs->fq_tmp && xs->cq_tmp;
> > +}
> > +
> >   static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >   {
> >       struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
> > @@ -685,6 +690,12 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >                       goto out_unlock;
> >               }
> >
> > +             if (xs->fq_tmp || xs->cq_tmp) {
> > +                     /* Do not allow setting your own fq or cq. */
> > +                     err = -EINVAL;
> > +                     goto out_unlock;
> > +             }
> > +
> >               sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
> >               if (IS_ERR(sock)) {
> >                       err = PTR_ERR(sock);
> > @@ -709,7 +720,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >               xdp_get_umem(umem_xs->umem);
> >               WRITE_ONCE(xs->umem, umem_xs->umem);
> >               sockfd_put(sock);
> > -     } else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
> > +     } else if (!xs->umem || !xsk_validate_queues(xs)) {
> >               err = -EINVAL;
> >               goto out_unlock;
> >       } else {
> > @@ -844,11 +855,9 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
> >                       return -EINVAL;
> >               }
> >
> > -             q = (optname == XDP_UMEM_FILL_RING) ? &xs->umem->fq :
> > -                     &xs->umem->cq;
> > +             q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp :
> > +                     &xs->cq_tmp;
> >               err = xsk_init_queue(entries, q, true);
> > -             if (optname == XDP_UMEM_FILL_RING)
> > -                     xp_set_fq(xs->pool, *q);
> >               mutex_unlock(&xs->mutex);
> >               return err;
> >       }
> > @@ -995,7 +1004,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> >       unsigned long size = vma->vm_end - vma->vm_start;
> >       struct xdp_sock *xs = xdp_sk(sock->sk);
> >       struct xsk_queue *q = NULL;
> > -     struct xdp_umem *umem;
> >       unsigned long pfn;
> >       struct page *qpg;
> >
> > @@ -1007,16 +1015,12 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> >       } else if (offset == XDP_PGOFF_TX_RING) {
> >               q = READ_ONCE(xs->tx);
> >       } else {
> > -             umem = READ_ONCE(xs->umem);
> > -             if (!umem)
> > -                     return -EINVAL;
> > -
> >               /* Matches the smp_wmb() in XDP_UMEM_REG */
> >               smp_rmb();
> >               if (offset == XDP_UMEM_PGOFF_FILL_RING)
> > -                     q = READ_ONCE(umem->fq);
> > +                     q = READ_ONCE(xs->fq_tmp);
> >               else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
> > -                     q = READ_ONCE(umem->cq);
> > +                     q = READ_ONCE(xs->cq_tmp);
> >       }
> >
> >       if (!q)
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index d450fb7..32720f2 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -66,6 +66,11 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> >       INIT_LIST_HEAD(&pool->free_list);
> >       refcount_set(&pool->users, 1);
> >
> > +     pool->fq = xs->fq_tmp;
> > +     pool->cq = xs->cq_tmp;
> > +     xs->fq_tmp = NULL;
> > +     xs->cq_tmp = NULL;
> > +
> >       for (i = 0; i < pool->free_heads_cnt; i++) {
> >               xskb = &pool->heads[i];
> >               xskb->pool = pool;
> > @@ -82,11 +87,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> >       return NULL;
> >   }
> >
> > -void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq)
> > -{
> > -     pool->fq = fq;
> > -}
> > -
> >   void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
> >   {
> >       u32 i;
> > @@ -190,6 +190,16 @@ static void xp_release_deferred(struct work_struct *work)
> >       xp_clear_dev(pool);
> >       rtnl_unlock();
> >
> > +     if (pool->fq) {
> > +             xskq_destroy(pool->fq);
> > +             pool->fq = NULL;
> > +     }
> > +
> > +     if (pool->cq) {
> > +             xskq_destroy(pool->cq);
> > +             pool->cq = NULL;
> > +     }
> > +
>
> It looks like xskq_destroy is missing for fq_tmp and cq_tmp, which is
> needed in some cases, e.g., if bind() wasn't called at all, or if
> xsk_bind failed with EINVAL.

Thanks Max. Will spin a v3.

/Magnus

> >       xdp_put_umem(pool->umem);
> >       xp_destroy(pool);
> >   }
> > diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> > index 0163b26..1936423 100644
> > --- a/net/xdp/xsk_diag.c
> > +++ b/net/xdp/xsk_diag.c
> > @@ -46,6 +46,7 @@ static int xsk_diag_put_rings_cfg(const struct xdp_sock *xs,
> >
> >   static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
> >   {
> > +     struct xsk_buff_pool *pool = xs->pool;
> >       struct xdp_umem *umem = xs->umem;
> >       struct xdp_diag_umem du = {};
> >       int err;
> > @@ -67,10 +68,11 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
> >
> >       err = nla_put(nlskb, XDP_DIAG_UMEM, sizeof(du), &du);
> >
> > -     if (!err && umem->fq)
> > -             err = xsk_diag_put_ring(umem->fq, XDP_DIAG_UMEM_FILL_RING, nlskb);
> > -     if (!err && umem->cq) {
> > -             err = xsk_diag_put_ring(umem->cq, XDP_DIAG_UMEM_COMPLETION_RING,
> > +     if (!err && pool->fq)
> > +             err = xsk_diag_put_ring(pool->fq,
> > +                                     XDP_DIAG_UMEM_FILL_RING, nlskb);
> > +     if (!err && pool->cq) {
> > +             err = xsk_diag_put_ring(pool->cq, XDP_DIAG_UMEM_COMPLETION_RING,
> >                                       nlskb);
> >       }
> >       return err;
> >
>
