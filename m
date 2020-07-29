Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50361231F25
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgG2NUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2NUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:20:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D1BC061794;
        Wed, 29 Jul 2020 06:20:17 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s15so2695900pgc.8;
        Wed, 29 Jul 2020 06:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZYFRkxOA0q5WBRDWrqim7U35iiaqRFY/x66SmA6ONb0=;
        b=kxVl3/dcF2JdHtLMOfUN0Na9f8OJ4RVMTlHO9Wrb8J7P+cua5/RySvsCaK8oB+oj24
         9r9OqEMWNj6Yyuc/oBeToixlqtt01B65tK+ddizeB/WhcFjCqGjrxm4KbNF5VE6MMyg0
         lI44gHs/nxooZ71sT6OkqwcCyvLbEp2z4Ube9BaLmkjJNy9sBt220dcZwnlsPdcnA+RP
         p+3xSbPVEf8Wu2jgPG/dOzL0BlVrvv4lgMFE2+gyU4P8xV7AomiAdETmobvVH5ZylEcz
         MysdpIPhf6D1tQtqkqRnKL9x8AAZQbwPh7W9Pd09JodaUQri5fJbkI7WfvRXHwi0XJHP
         v4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZYFRkxOA0q5WBRDWrqim7U35iiaqRFY/x66SmA6ONb0=;
        b=SSQxyYhToVpUjT8QYKGsNgL09IVSnIj+BNSIWELddLGyKu1h3rPp1+7iu0/vRC8+C4
         5EsF8ymoT9tzH1G5WB4TQUh4atdM2MXZ/XO4CiQ9WFdsqpRDuUwiXXwRMIOFdxBzCbug
         c771B/1XobI0WHVBbAvxdvVXDnXXrcY015Rkonc49dEatNS7MbOQoJNZh+K1v6hdSRjA
         tF34mVsM3sur0blH/nNuOU2+M9dbMoFgcbLoUyNkUUL9yZ+WZjIYvlIM8DX6hUcZHu6n
         3W+N2sqIHGE+0S+w1pX340tgxouOPrf+qV+usnAWYKrNXrxdKGsJ3etS0h5esr0GmJuU
         VYFw==
X-Gm-Message-State: AOAM533XmSQwSvyQy8xWUAnk/h6vAKLCHSbo7AhKXbdqY9keIp/2osob
        /2wrZ9adqeMMVN45TCDJ1onWGEmY8m1p1Ceby2pCxg==
X-Google-Smtp-Source: ABdhPJxbZP1L21iULQLwjYJBt0d5u5s11SXlOBKqaybCIsu44qqVe5nOXQVSm82oM0LgJ8HHnVCgLd9VZPIQ/RAS8uQ=
X-Received: by 2002:a63:bd49:: with SMTP id d9mr8486276pgp.126.1596028817548;
 Wed, 29 Jul 2020 06:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com> <00afe3da-0d5e-18fe-b6cb-490faa3dd132@intel.com>
In-Reply-To: <00afe3da-0d5e-18fe-b6cb-490faa3dd132@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 29 Jul 2020 15:20:08 +0200
Message-ID: <CAJ8uoz1mg-NJ-gNDVrikVp93DC5bU6QN8gzEPpyw36URRtBYxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/14] xsk: move queue_id, dev and need_wakeup
 to buffer pool
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 9:10 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.co=
m> wrote:
>
>
>
> On 2020-07-21 07:03, Magnus Karlsson wrote:
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
> >   net/xdp/xsk.c               | 40 +++++++++++++++---------------------=
----
> >   net/xdp/xsk_buff_pool.c     | 39 ++++++++++++++++++++++--------------=
---
> >   net/xdp/xsk_diag.c          |  4 ++--
> >   7 files changed, 44 insertions(+), 69 deletions(-)
> >
> [...]
> >               }
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index 36287d2..436648a 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -95,10 +95,9 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, str=
uct xdp_rxq_info *rxq)
> >   }
> >   EXPORT_SYMBOL(xp_set_rxq_info);
> >
> > -int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> > +int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netde=
v,
> >                 u16 queue_id, u16 flags)
> >   {
> > -     struct xdp_umem *umem =3D pool->umem;
> >       bool force_zc, force_copy;
> >       struct netdev_bpf bpf;
> >       int err =3D 0;
> > @@ -111,27 +110,30 @@ int xp_assign_dev(struct xsk_buff_pool *pool, str=
uct net_device *dev,
> >       if (force_zc && force_copy)
> >               return -EINVAL;
> >
> > -     if (xsk_get_pool_from_qid(dev, queue_id))
> > +     if (xsk_get_pool_from_qid(netdev, queue_id))
> >               return -EBUSY;
> >
> > -     err =3D xsk_reg_pool_at_qid(dev, pool, queue_id);
> > +     err =3D xsk_reg_pool_at_qid(netdev, pool, queue_id);
> >       if (err)
> >               return err;
> >
> >       if (flags & XDP_USE_NEED_WAKEUP) {
> > -             umem->flags |=3D XDP_UMEM_USES_NEED_WAKEUP;
> > +             pool->uses_need_wakeup =3D true;
> >               /* Tx needs to be explicitly woken up the first time.
> >                * Also for supporting drivers that do not implement this
> >                * feature. They will always have to call sendto().
> >                */
> > -             umem->need_wakeup =3D XDP_WAKEUP_TX;
> > +             pool->cached_need_wakeup =3D XDP_WAKEUP_TX;
> >       }
> >
> > +     dev_hold(netdev);
> > +
>
> You have a reference leak here for the error case.

Thanks. Will fix.

/Magnus

>
> Bj=C3=B6rn
