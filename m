Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298FD231F27
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgG2NVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2NVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:21:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04D8C061794;
        Wed, 29 Jul 2020 06:21:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so11784237plx.6;
        Wed, 29 Jul 2020 06:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8XAzbFfQ8l+p7IHMV//OZ2f20yfMDwxLVjCOG9ETP4U=;
        b=sFl9JKq0alVBxrImU9Y8HG7TW5lZ2SjFmYb5iCNZPWdy3oG0FB1F2f76vRis0Rcq1C
         CYeNG5Bwu5Ond848sTK/8pM3uY5QAxwQoPo8syC2cuRTCkHuaESDq9uJ50FO2hHwOzUI
         bvsgGGOdZs2XORq7AOjjqXUvzBxaRnEX7pe7VFTmj1141m91sv0IsGwbc1ApHl8F2nKJ
         5ASKTnpECcCCC/mqkKSn496nUnTpkb6ov5aMVandkDsEDNtREaopwKaWzS1/YkRhh/0D
         +B4LyO/qY3MjUThs0TOpXqspuqx2cHwGcYa/jjgjquLqeBXd1gDU9MpOcwPHTFG34U9Z
         0NjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8XAzbFfQ8l+p7IHMV//OZ2f20yfMDwxLVjCOG9ETP4U=;
        b=m3l7/H5CVQRg571uUX0Q4zFJswj9WloXkzOk8HUOaCHnOnbrpbOq7E/dC/CRbmlvr9
         nc9SM8xP6/wFrE8pYlemYG7khyG2WP52E764RjDqUdGcoj4IYVnLLl7oh4/J9/l3HGQt
         weUpMeAi5DOqYNPH7+nD+OZ0ufTWmmRl2rvXwJumDdlHibDQPM1g+0afn1kaaOJwhnjH
         NZkQjO9Xi1AAsQ1dTAkFByFBD44F6oB9lqIThWK/seSkFKjzVr4efBTkG75S8fd1g63Y
         gOAtoNktnLCj+8fiEymuhC/grGAQSgLDDVuUfY+W63eIb6qFBP8MQJ2m6Kg7R2OeHoLo
         HqyA==
X-Gm-Message-State: AOAM532dOEVZ0zoh9vV2I7Gu8B4wW6K4nYCWgVo3xC2vPabHgNu6nMkK
        xQbVPf9aQUCNpsMGniXlpywMB6np5yBBgtx8uIA=
X-Google-Smtp-Source: ABdhPJzbO/ruY32qQ5HORupy6UQzOJaoGsIDp+30qcxK1baIDzFhNHdgnSNQODWlL0z7T+ToJbg82evlbghMMiLWQ5s=
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr29002971pln.16.1596028882239;
 Wed, 29 Jul 2020 06:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com> <08bf5d26-fa21-10b5-d768-01ca9a1ebcbb@mellanox.com>
In-Reply-To: <08bf5d26-fa21-10b5-d768-01ca9a1ebcbb@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 29 Jul 2020 15:21:12 +0200
Message-ID: <CAJ8uoz12jW2uXcD8Xj1ZfzW39FGEJHyx8JEn0Cb6pQ82y8Ji+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/14] xsk: move queue_id, dev and need_wakeup
 to buffer pool
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:22 AM Maxim Mikityanskiy
<maximmi@mellanox.com> wrote:
>
> On 2020-07-21 08:03, Magnus Karlsson wrote:
> > Move queue_id, dev, and need_wakeup from the umem to the
> > buffer pool. This so that we in a later commit can share the umem
> > between multiple HW queues. There is one buffer pool per dev and
> > queue id, so these variables should belong to the buffer pool, not
> > the umem. Need_wakeup is also something that is set on a per napi
> > level, so there is usually one per device and queue id. So move
> > this to the buffer pool too.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   include/net/xdp_sock.h      |  3 ---
> >   include/net/xsk_buff_pool.h |  4 ++++
> >   net/xdp/xdp_umem.c          | 19 +------------------
> >   net/xdp/xdp_umem.h          |  4 ----
> >   net/xdp/xsk.c               | 40 +++++++++++++++-------------------------
> >   net/xdp/xsk_buff_pool.c     | 39 ++++++++++++++++++++++-----------------
> >   net/xdp/xsk_diag.c          |  4 ++--
> >   7 files changed, 44 insertions(+), 69 deletions(-)
> >
> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index 2a284e1..b052f1c 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -26,11 +26,8 @@ struct xdp_umem {
> >       refcount_t users;
> >       struct page **pgs;
> >       u32 npgs;
> > -     u16 queue_id;
> > -     u8 need_wakeup;
> >       u8 flags;
> >       int id;
> > -     struct net_device *dev;
> >       bool zc;
> >       spinlock_t xsk_tx_list_lock;
> >       struct list_head xsk_tx_list;
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index 380d9ae..2d94890 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -43,11 +43,15 @@ struct xsk_buff_pool {
> >       u32 headroom;
> >       u32 chunk_size;
> >       u32 frame_len;
> > +     u16 queue_id;
> > +     u8 cached_need_wakeup;
> > +     bool uses_need_wakeup;
> >       bool dma_need_sync;
> >       bool unaligned;
> >       struct xdp_umem *umem;
> >       void *addrs;
> >       struct device *dev;
> > +     struct net_device *netdev;
> >       refcount_t users;
> >       struct work_struct work;
> >       struct xdp_buff_xsk *free_heads[];
> > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > index 7d86a63..b1699d0 100644
> > --- a/net/xdp/xdp_umem.c
> > +++ b/net/xdp/xdp_umem.c
> > @@ -63,26 +63,9 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
> >       }
> >   }
> >
> > -void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> > -                      u16 queue_id)
> > -{
> > -     umem->dev = dev;
> > -     umem->queue_id = queue_id;
> > -
> > -     dev_hold(dev);
> > -}
> > -
> > -void xdp_umem_clear_dev(struct xdp_umem *umem)
> > -{
> > -     dev_put(umem->dev);
> > -     umem->dev = NULL;
> > -     umem->zc = false;
> > -}
> > -
> >   static void xdp_umem_release(struct xdp_umem *umem)
> >   {
> > -     xdp_umem_clear_dev(umem);
> > -
> > +     umem->zc = false;
> >       ida_simple_remove(&umem_ida, umem->id);
> >
> >       xdp_umem_unpin_pages(umem);
> > diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
> > index 93e96be..67bf3f3 100644
> > --- a/net/xdp/xdp_umem.h
> > +++ b/net/xdp/xdp_umem.h
> > @@ -8,10 +8,6 @@
> >
> >   #include <net/xdp_sock_drv.h>
> >
> > -void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> > -                      u16 queue_id);
> > -void xdp_umem_clear_dev(struct xdp_umem *umem);
> > -bool xdp_umem_validate_queues(struct xdp_umem *umem);
> >   void xdp_get_umem(struct xdp_umem *umem);
> >   void xdp_put_umem(struct xdp_umem *umem);
> >   void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs);
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index ee04887..624d0fc 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -41,67 +41,61 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
> >
> >   void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> > -
> > -     if (umem->need_wakeup & XDP_WAKEUP_RX)
> > +     if (pool->cached_need_wakeup & XDP_WAKEUP_RX)
> >               return;
> >
> >       pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
> > -     umem->need_wakeup |= XDP_WAKEUP_RX;
> > +     pool->cached_need_wakeup |= XDP_WAKEUP_RX;
> >   }
> >   EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
> >
> >   void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> >       struct xdp_sock *xs;
> >
> > -     if (umem->need_wakeup & XDP_WAKEUP_TX)
> > +     if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
> >               return;
> >
> >       rcu_read_lock();
> > -     list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
> > +     list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
>
> I know this is going to be fixed in the next patch, but it breaks
> bisectability: this patch is broken because xs is not assigned. I don't
> think this change is actually needed here, it doesn't belong to this
> patch, and you can convert it to &pool->xsk_tx_list in one step in the
> next patch.

Thanks. Will fix this and the other comment you had below.

/Magnus

> >               xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
> >       }
> >       rcu_read_unlock();
> >
> > -     umem->need_wakeup |= XDP_WAKEUP_TX;
> > +     pool->cached_need_wakeup |= XDP_WAKEUP_TX;
> >   }
> >   EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
> >
> >   void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> > -
> > -     if (!(umem->need_wakeup & XDP_WAKEUP_RX))
> > +     if (!(pool->cached_need_wakeup & XDP_WAKEUP_RX))
> >               return;
> >
> >       pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> > -     umem->need_wakeup &= ~XDP_WAKEUP_RX;
> > +     pool->cached_need_wakeup &= ~XDP_WAKEUP_RX;
> >   }
> >   EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
> >
> >   void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> >       struct xdp_sock *xs;
> >
> > -     if (!(umem->need_wakeup & XDP_WAKEUP_TX))
> > +     if (!(pool->cached_need_wakeup & XDP_WAKEUP_TX))
> >               return;
> >
> >       rcu_read_lock();
> > -     list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
> > +     list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
>
> Same here.
>
> >               xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> >       }
> >       rcu_read_unlock();
> >
> > -     umem->need_wakeup &= ~XDP_WAKEUP_TX;
> > +     pool->cached_need_wakeup &= ~XDP_WAKEUP_TX;
> >   }
> >   EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
> >
> >   bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
> >   {
> > -     return pool->umem->flags & XDP_UMEM_USES_NEED_WAKEUP;
> > +     return pool->uses_need_wakeup;
> >   }
> >   EXPORT_SYMBOL(xsk_uses_need_wakeup);
> >
> > @@ -478,16 +472,16 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
> >       __poll_t mask = datagram_poll(file, sock, wait);
> >       struct sock *sk = sock->sk;
> >       struct xdp_sock *xs = xdp_sk(sk);
> > -     struct xdp_umem *umem;
> > +     struct xsk_buff_pool *pool;
> >
> >       if (unlikely(!xsk_is_bound(xs)))
> >               return mask;
> >
> > -     umem = xs->umem;
> > +     pool = xs->pool;
> >
> > -     if (umem->need_wakeup) {
> > +     if (pool->cached_need_wakeup) {
> >               if (xs->zc)
> > -                     xsk_wakeup(xs, umem->need_wakeup);
> > +                     xsk_wakeup(xs, pool->cached_need_wakeup);
> >               else
> >                       /* Poll needs to drive Tx also in copy mode */
> >                       __xsk_sendmsg(sk);
> > @@ -731,11 +725,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >               goto out_unlock;
> >       } else {
> >               /* This xsk has its own umem. */
> > -             xdp_umem_assign_dev(xs->umem, dev, qid);
> >               xs->pool = xp_create_and_assign_umem(xs, xs->umem);
> >               if (!xs->pool) {
> >                       err = -ENOMEM;
> > -                     xdp_umem_clear_dev(xs->umem);
> >                       goto out_unlock;
> >               }
> >
> > @@ -743,7 +735,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >               if (err) {
> >                       xp_destroy(xs->pool);
> >                       xs->pool = NULL;
> > -                     xdp_umem_clear_dev(xs->umem);
> >                       goto out_unlock;
> >               }
> >       }
> > @@ -1089,7 +1080,6 @@ static int xsk_notifier(struct notifier_block *this,
> >
> >                               /* Clear device references. */
> >                               xp_clear_dev(xs->pool);
> > -                             xdp_umem_clear_dev(xs->umem);
> >                       }
> >                       mutex_unlock(&xs->mutex);
> >               }
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index 36287d2..436648a 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -95,10 +95,9 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
> >   }
> >   EXPORT_SYMBOL(xp_set_rxq_info);
> >
> > -int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> > +int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> >                 u16 queue_id, u16 flags)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> >       bool force_zc, force_copy;
> >       struct netdev_bpf bpf;
> >       int err = 0;
> > @@ -111,27 +110,30 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> >       if (force_zc && force_copy)
> >               return -EINVAL;
> >
> > -     if (xsk_get_pool_from_qid(dev, queue_id))
> > +     if (xsk_get_pool_from_qid(netdev, queue_id))
> >               return -EBUSY;
> >
> > -     err = xsk_reg_pool_at_qid(dev, pool, queue_id);
> > +     err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
> >       if (err)
> >               return err;
> >
> >       if (flags & XDP_USE_NEED_WAKEUP) {
> > -             umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
>
> XDP_UMEM_USES_NEED_WAKEUP definition should be removed, along with its
> remaining usage in xdp_umem_reg.
>
> > +             pool->uses_need_wakeup = true;
> >               /* Tx needs to be explicitly woken up the first time.
> >                * Also for supporting drivers that do not implement this
> >                * feature. They will always have to call sendto().
> >                */
> > -             umem->need_wakeup = XDP_WAKEUP_TX;
> > +             pool->cached_need_wakeup = XDP_WAKEUP_TX;
> >       }
> >
> > +     dev_hold(netdev);
> > +
> >       if (force_copy)
> >               /* For copy-mode, we are done. */
> >               return 0;
> >
> > -     if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
> > +     if (!netdev->netdev_ops->ndo_bpf ||
> > +         !netdev->netdev_ops->ndo_xsk_wakeup) {
> >               err = -EOPNOTSUPP;
> >               goto err_unreg_pool;
> >       }
> > @@ -140,44 +142,47 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> >       bpf.xsk.pool = pool;
> >       bpf.xsk.queue_id = queue_id;
> >
> > -     err = dev->netdev_ops->ndo_bpf(dev, &bpf);
> > +     err = netdev->netdev_ops->ndo_bpf(netdev, &bpf);
> >       if (err)
> >               goto err_unreg_pool;
> >
> > -     umem->zc = true;
> > +     pool->netdev = netdev;
> > +     pool->queue_id = queue_id;
> > +     pool->umem->zc = true;
> >       return 0;
> >
> >   err_unreg_pool:
> >       if (!force_zc)
> >               err = 0; /* fallback to copy mode */
> >       if (err)
> > -             xsk_clear_pool_at_qid(dev, queue_id);
> > +             xsk_clear_pool_at_qid(netdev, queue_id);
> >       return err;
> >   }
> >
> >   void xp_clear_dev(struct xsk_buff_pool *pool)
> >   {
> > -     struct xdp_umem *umem = pool->umem;
> >       struct netdev_bpf bpf;
> >       int err;
> >
> >       ASSERT_RTNL();
> >
> > -     if (!umem->dev)
> > +     if (!pool->netdev)
> >               return;
> >
> > -     if (umem->zc) {
> > +     if (pool->umem->zc) {
> >               bpf.command = XDP_SETUP_XSK_POOL;
> >               bpf.xsk.pool = NULL;
> > -             bpf.xsk.queue_id = umem->queue_id;
> > +             bpf.xsk.queue_id = pool->queue_id;
> >
> > -             err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
> > +             err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
> >
> >               if (err)
> > -                     WARN(1, "failed to disable umem!\n");
> > +                     WARN(1, "Failed to disable zero-copy!\n");
> >       }
> >
> > -     xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
> > +     xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
> > +     dev_put(pool->netdev);
> > +     pool->netdev = NULL;
> >   }
> >
> >   static void xp_release_deferred(struct work_struct *work)
> > diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> > index 52675ea..5bd8ea9 100644
> > --- a/net/xdp/xsk_diag.c
> > +++ b/net/xdp/xsk_diag.c
> > @@ -59,8 +59,8 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
> >       du.num_pages = umem->npgs;
> >       du.chunk_size = umem->chunk_size;
> >       du.headroom = umem->headroom;
> > -     du.ifindex = umem->dev ? umem->dev->ifindex : 0;
> > -     du.queue_id = umem->queue_id;
> > +     du.ifindex = pool->netdev ? pool->netdev->ifindex : 0;
> > +     du.queue_id = pool->queue_id;
> >       du.flags = 0;
> >       if (umem->zc)
> >               du.flags |= XDP_DU_F_ZEROCOPY;
> >
>
