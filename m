Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A42C60C8
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgK0IXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK0IXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:23:01 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFD3C0613D1;
        Fri, 27 Nov 2020 00:23:01 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so3732464pgg.13;
        Fri, 27 Nov 2020 00:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gc7eWnisDSwnflspZV/ylxsl1sx9kw3MIByDGHLLb8w=;
        b=qhn8gpAomZ7r9dr1lS3P0cP4zSZT5JoJ4JRDBQpT94LsCTD0o8Qa4w0ppXdZiY3bIA
         zHFhKJov7HDaBjiq40XUIGo8jQKGxhAn3lPSy+8/x/nlj7qt68S0cpnIEhmGcb0+YC8d
         sXv3/uODwwWWT5BLEjoaklobwNBgJtS7HVlt+YsgK+SsI16+MY/k/QAY+/CCep/wWf88
         gbF5TUVwh4+AijS4nkf1dxd5Y58QUdGKv1bPMGAFDN0QCk7ir1U6aWTjIAAZUpm4Gy5l
         xprNDTh+guiF96qAVTHUUkK+r4v5CfX5hXA8hrBx/sZG+zMG9CF6I3VAZX7BTEbOL9ov
         yScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gc7eWnisDSwnflspZV/ylxsl1sx9kw3MIByDGHLLb8w=;
        b=NgY7QIdjNnh4URjPeohgBUL1KjVoep/C6wjc5rF6HocaFwTbNQtwy/jyW0UD5nn8mw
         EmR02As3w7n4Kh7E3QcFO1yZ/cPj2HzbDSpI9CIh7X5Df4/sFanwtmtOBG4Sc1BBimJn
         fs/HAS59R4daAO5/eFo1eReINekxRMDSntOvIcjAoEanXSST0P6GM7zwopbJqWgXwUpQ
         lCp1K9orv8RCZMXEOtCcRdAJqIbOQAhjjMl6o8A2cRMbU4TwzxrX6rr55Mpbjjwq+qTz
         93VWt1060m45eRCz9Pu/7DBvhguz/ICCMdAn+b5m+LXYK+PKaep6+kHuQk4azZjjWBMw
         OmuQ==
X-Gm-Message-State: AOAM533Nv5xLSyVkfbSHFFNC/kzXis5ZnBEeYgVwXgJSo3u0jKIACi94
        I7m5bLJ0Z7GDAm6m3z58EliZy9cYryAWWj2g5yU=
X-Google-Smtp-Source: ABdhPJxOObj0B/zV4XyQZjqQVr0xXk4z8IVZygRSmX3hQPJ1fq9TlD8U14gdoYwJ8NBh1VdNmd95LoATY6p3bbBTM0k=
X-Received: by 2002:a17:90a:eb90:: with SMTP id o16mr8306990pjy.204.1606465380670;
 Fri, 27 Nov 2020 00:23:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
 <cover.1606285978.git.xuanzhuo@linux.alibaba.com> <4fd58d473f4548dc6e9e24ea9876c802d5d584b4.1606285978.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <4fd58d473f4548dc6e9e24ea9876c802d5d584b4.1606285978.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 27 Nov 2020 09:22:49 +0100
Message-ID: <CAJ8uoz3svrWUSuFvMLt9Ae7RR2qFuMzVhizqWGvpPP1F2HwhTA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] xsk: change the tx writeable condition
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 7:49 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Modify the tx writeable condition from the queue is not full to the
> number of present tx queues is less than the half of the total number
> of queues. Because the tx queue not full is a very short time, this will
> cause a large number of EPOLLOUT events, and cause a large number of
> process wake up.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thank you Xuan!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> ---
>  net/xdp/xsk.c       | 16 +++++++++++++---
>  net/xdp/xsk_queue.h |  6 ++++++
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 0df8651..22e35e9 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -211,6 +211,14 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
>         return 0;
>  }
>
> +static bool xsk_tx_writeable(struct xdp_sock *xs)
> +{
> +       if (xskq_cons_present_entries(xs->tx) > xs->tx->nentries / 2)
> +               return false;
> +
> +       return true;
> +}
> +
>  static bool xsk_is_bound(struct xdp_sock *xs)
>  {
>         if (READ_ONCE(xs->state) == XSK_BOUND) {
> @@ -296,7 +304,8 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
>         rcu_read_lock();
>         list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
>                 __xskq_cons_release(xs->tx);
> -               xs->sk.sk_write_space(&xs->sk);
> +               if (xsk_tx_writeable(xs))
> +                       xs->sk.sk_write_space(&xs->sk);
>         }
>         rcu_read_unlock();
>  }
> @@ -499,7 +508,8 @@ static int xsk_generic_xmit(struct sock *sk)
>
>  out:
>         if (sent_frame)
> -               sk->sk_write_space(sk);
> +               if (xsk_tx_writeable(xs))
> +                       sk->sk_write_space(sk);
>
>         mutex_unlock(&xs->mutex);
>         return err;
> @@ -556,7 +566,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>
>         if (xs->rx && !xskq_prod_is_empty(xs->rx))
>                 mask |= EPOLLIN | EPOLLRDNORM;
> -       if (xs->tx && !xskq_cons_is_full(xs->tx))
> +       if (xs->tx && xsk_tx_writeable(xs))
>                 mask |= EPOLLOUT | EPOLLWRNORM;
>
>         return mask;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index b936c46..b655004 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -307,6 +307,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
>                 q->nentries;
>  }
>
> +static inline __u64 xskq_cons_present_entries(struct xsk_queue *q)
> +{
> +       /* No barriers needed since data is not accessed */
> +       return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer);
> +}
> +
>  /* Functions for producers */
>
>  static inline u32 xskq_prod_nb_free(struct xsk_queue *q, u32 max)
> --
> 1.8.3.1
>
