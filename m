Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52380231F3B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgG2NXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgG2NWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:22:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F20C0619D4;
        Wed, 29 Jul 2020 06:22:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id lx9so2028197pjb.2;
        Wed, 29 Jul 2020 06:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBlgnicMKH+m3sBFtpxA+lSqJKNt7AV2kplo6p1N0YA=;
        b=MEOEM5LNyl84ctxWHAga7ftQtyzvKcojx81TwlHhDSa5s3MG7HbKYBTuWCdMJDbHHp
         zM1/IZDc/8VtHeGuWfIkULPwFsBppcdvkSTZqK4uK3eKT0gjukN/F1jlXZH5LL5v3kJs
         nQrac9LjNpZfgLxL+8qbtQchgbik7ayaAwujllveIFDLk+PO9AdBk6+rGHGME+44Ft8b
         mvgflhPhWjhqcsxQnZtJcBQb4DhRkX/YqoxBNxjAbok/CDgw2oxqKP7//taDi2FfPF2I
         0VgtdVdYyeYAbWktDy9259SQyFX2mlg+QflF5kT4IeFPiINeMlkxmyCgMqrcR3xKU4XX
         Xjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBlgnicMKH+m3sBFtpxA+lSqJKNt7AV2kplo6p1N0YA=;
        b=JvW8Bvey1c1vdbstoqNOprmFICId5Sr9u1pK5sB7/63PoSUyQJvfBECVVeXhW8NOd2
         hrmDLn4XMuNqeTHi5ePUlZW3kJ3gBXvs0VJBlOZQRJP+YxvdLXhCDHE/46Amw+JZo7Au
         JvXk5Vmao4AAVfCxckQWyldGYAHifSXXTi1nbdlOe6Ce9zz1Ufx1MseMu4KVemKJb0wG
         m+Nl5/kNZ0ZjrY7229Ktchk3aNwSA3jz2LxCWla614dt04llH4aAVHglqcLGbCxBNy/3
         TiiwqadgxxWobzJftfm5mDjGTUIOzH+M8j6BXTRWgTHkF0gStvYl09PHfx7TrMu0cjBP
         tKQA==
X-Gm-Message-State: AOAM530Ses71rzT6siTBDq5yKi2z/l77T3xjiFtbe8h3aG/F9l7tnM1g
        WPeFHdo7m2VRQXziBoku7V+ftWfJ0aMOw22CX1c=
X-Google-Smtp-Source: ABdhPJynhckWCAF0vFEWkTaS6QYD3+kOqdsLfcuMLiU2nmbyeobK9blZIlQUDKUkDLJT9kIssu9Bo4ha1TVNBHjNL/A=
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr29008966pln.16.1596028966729;
 Wed, 29 Jul 2020 06:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-9-git-send-email-magnus.karlsson@intel.com> <11a4e8cb-1c88-ada8-7534-8f32d16e729d@mellanox.com>
In-Reply-To: <11a4e8cb-1c88-ada8-7534-8f32d16e729d@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 29 Jul 2020 15:22:36 +0200
Message-ID: <CAJ8uoz3Cc4dN_dfh5UFHPDEEVMLWg_o3Mi0PRMJOqfhRER2DLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 08/14] xsk: enable sharing of dma mappings
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

On Tue, Jul 28, 2020 at 11:00 AM Maxim Mikityanskiy
<maximmi@mellanox.com> wrote:
>
> On 2020-07-21 08:04, Magnus Karlsson wrote:
> > Enable the sharing of dma mappings by moving them out from the buffer
> > pool. Instead we put each dma mapped umem region in a list in the umem
> > structure. If dma has already been mapped for this umem and device, it
> > is not mapped again and the existing dma mappings are reused.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   include/net/xdp_sock.h      |   1 +
> >   include/net/xsk_buff_pool.h |   7 +++
> >   net/xdp/xdp_umem.c          |   1 +
> >   net/xdp/xsk_buff_pool.c     | 112 ++++++++++++++++++++++++++++++++++++--------
> >   4 files changed, 102 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index 126d243..282aeba 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -30,6 +30,7 @@ struct xdp_umem {
> >       u8 flags;
> >       int id;
> >       bool zc;
> > +     struct list_head xsk_dma_list;
> >   };
> >
> >   struct xsk_map {
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index 83f100c..8f1dc4c 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -28,6 +28,13 @@ struct xdp_buff_xsk {
> >       struct list_head free_list_node;
> >   };
> >
> > +struct xsk_dma_map {
> > +     dma_addr_t *dma_pages;
> > +     struct net_device *dev;
> > +     refcount_t users;
> > +     struct list_head list; /* Protected by the RTNL_LOCK */
> > +};
> > +
> >   struct xsk_buff_pool {
> >       struct xsk_queue *fq;
> >       struct xsk_queue *cq;
> > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > index 372998d..cf27249 100644
> > --- a/net/xdp/xdp_umem.c
> > +++ b/net/xdp/xdp_umem.c
> > @@ -199,6 +199,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
> >       umem->user = NULL;
> >       umem->flags = mr->flags;
> >
> > +     INIT_LIST_HEAD(&umem->xsk_dma_list);
> >       refcount_set(&umem->users, 1);
> >
> >       err = xdp_umem_account_pages(umem);
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index c563874..ca74a3e 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -104,6 +104,25 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
> >   }
> >   EXPORT_SYMBOL(xp_set_rxq_info);
> >
> > +static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
> > +{
> > +     struct netdev_bpf bpf;
> > +     int err;
> > +
> > +     ASSERT_RTNL();
> > +
> > +     if (pool->umem->zc) {
> > +             bpf.command = XDP_SETUP_XSK_POOL;
> > +             bpf.xsk.pool = NULL;
> > +             bpf.xsk.queue_id = pool->queue_id;
> > +
> > +             err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
> > +
> > +             if (err)
> > +                     WARN(1, "Failed to disable zero-copy!\n");
> > +     }
> > +}
> > +
> >   int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> >                 u16 queue_id, u16 flags)
> >   {
> > @@ -122,6 +141,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> >       if (xsk_get_pool_from_qid(netdev, queue_id))
> >               return -EBUSY;
> >
> > +     pool->netdev = netdev;
> > +     pool->queue_id = queue_id;
> >       err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
> >       if (err)
> >               return err;
> > @@ -155,11 +176,15 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> >       if (err)
> >               goto err_unreg_pool;
> >
> > -     pool->netdev = netdev;
> > -     pool->queue_id = queue_id;
> > +     if (!pool->dma_pages) {
> > +             WARN(1, "Driver did not DMA map zero-copy buffers");
> > +             goto err_unreg_xsk;
> > +     }
> >       pool->umem->zc = true;
> >       return 0;
> >
> > +err_unreg_xsk:
> > +     xp_disable_drv_zc(pool);
> >   err_unreg_pool:
> >       if (!force_zc)
> >               err = 0; /* fallback to copy mode */
> > @@ -170,25 +195,10 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> >
> >   void xp_clear_dev(struct xsk_buff_pool *pool)
> >   {
> > -     struct netdev_bpf bpf;
> > -     int err;
> > -
> > -     ASSERT_RTNL();
> > -
> >       if (!pool->netdev)
> >               return;
> >
> > -     if (pool->umem->zc) {
> > -             bpf.command = XDP_SETUP_XSK_POOL;
> > -             bpf.xsk.pool = NULL;
> > -             bpf.xsk.queue_id = pool->queue_id;
> > -
> > -             err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
> > -
> > -             if (err)
> > -                     WARN(1, "Failed to disable zero-copy!\n");
> > -     }
> > -
> > +     xp_disable_drv_zc(pool);
> >       xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
> >       dev_put(pool->netdev);
> >       pool->netdev = NULL;
> > @@ -233,14 +243,61 @@ void xp_put_pool(struct xsk_buff_pool *pool)
> >       }
> >   }
> >
> > +static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
> > +{
> > +     struct xsk_dma_map *dma_map;
> > +
> > +     list_for_each_entry(dma_map, &pool->umem->xsk_dma_list, list) {
> > +             if (dma_map->dev == pool->netdev)
> > +                     return dma_map;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
> > +{
> > +     list_del(&dma_map->list);
> > +     kfree(dma_map);
> > +}
> > +
> > +static void xp_put_dma_map(struct xsk_dma_map *dma_map)
> > +{
> > +     if (!refcount_dec_and_test(&dma_map->users))
> > +             return;
> > +
> > +     xp_destroy_dma_map(dma_map);
> > +}
> > +
> > +static struct xsk_dma_map *xp_create_dma_map(struct xsk_buff_pool *pool)
> > +{
> > +     struct xsk_dma_map *dma_map;
> > +
> > +     dma_map = kzalloc(sizeof(*dma_map), GFP_KERNEL);
> > +     if (!dma_map)
> > +             return NULL;
> > +
> > +     dma_map->dev = pool->netdev;
> > +     refcount_set(&dma_map->users, 1);
> > +     list_add(&dma_map->list, &pool->umem->xsk_dma_list);
> > +     return dma_map;
> > +}
> > +
> >   void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
> >   {
> > +     struct xsk_dma_map *dma_map;
> >       dma_addr_t *dma;
> >       u32 i;
> >
> >       if (pool->dma_pages_cnt == 0)
> >               return;
> >
> > +     dma_map = xp_find_dma_map(pool);
> > +     if (!dma_map) {
> > +             WARN(1, "Could not find dma_map for device");
> > +             return;
> > +     }
> > +
> >       for (i = 0; i < pool->dma_pages_cnt; i++) {
> >               dma = &pool->dma_pages[i];
> >               if (*dma) {
> > @@ -250,6 +307,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
> >               }
> >       }
> >
> > +     xp_put_dma_map(dma_map);
>
> I believe that the logic in this function is not correct. Basically, the
> driver calls xp_dma_[un]map when a socket is enabled/disabled on a given
> queue of a given netdev. On xp_dma_map, if the UMEM is already mapped
> for that netdev, we skip all the logic, but on xp_dma_unmap you unmap
> the pages unconditionally, only after that you check the refcount. This
> is not symmetric, and the pages will be unmapped when the first socket
> is closed, rendering the rest of sockets unusable.

Thanks for spotting this. Will fix.

/Magnus

> >       kvfree(pool->dma_pages);
> >       pool->dma_pages_cnt = 0;
> >       pool->dev = NULL;
> > @@ -271,14 +329,29 @@ static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
> >   int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> >              unsigned long attrs, struct page **pages, u32 nr_pages)
> >   {
> > +     struct xsk_dma_map *dma_map;
> >       dma_addr_t dma;
> >       u32 i;
> >
> > +     dma_map = xp_find_dma_map(pool);
> > +     if (dma_map) {
> > +             pool->dma_pages = dma_map->dma_pages;
> > +             refcount_inc(&dma_map->users);
> > +             return 0;
> > +     }
> > +
> > +     dma_map = xp_create_dma_map(pool);
> > +     if (!dma_map)
> > +             return -ENOMEM;
> > +
> >       pool->dma_pages = kvcalloc(nr_pages, sizeof(*pool->dma_pages),
> >                                  GFP_KERNEL);
> > -     if (!pool->dma_pages)
> > +     if (!pool->dma_pages) {
> > +             xp_destroy_dma_map(dma_map);
> >               return -ENOMEM;
> > +     }
> >
> > +     dma_map->dma_pages = pool->dma_pages;
> >       pool->dev = dev;
> >       pool->dma_pages_cnt = nr_pages;
> >       pool->dma_need_sync = false;
> > @@ -288,6 +361,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> >                                        DMA_BIDIRECTIONAL, attrs);
> >               if (dma_mapping_error(dev, dma)) {
> >                       xp_dma_unmap(pool, attrs);
> > +                     xp_destroy_dma_map(dma_map);
> >                       return -ENOMEM;
> >               }
> >               if (dma_need_sync(dev, dma))
> >
>
