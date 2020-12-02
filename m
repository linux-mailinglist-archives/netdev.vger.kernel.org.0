Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94DC2CC0D9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgLBPbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLBPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:31:05 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4BCC0613D4;
        Wed,  2 Dec 2020 07:30:19 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f17so1281173pge.6;
        Wed, 02 Dec 2020 07:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwTSpTZUymq3kHcr9Nu1z8YQRX/L7YbJh3Ulw0Y/ks8=;
        b=AVpHvyVmPS6PvURO4TNoOS+xkJTKN4J89fiERyhK3zbr4LLuhBI90TR4TyRhgNACAY
         Ykk6JRil3aQUc5rijqCv+RvgYFGj03GjNyjq8SnzOaUxjFH5xFG+kCoDCoA2Hj2XchlG
         4yAh/RR/8ziZiD/emSe42+Y4i3N20MwpcA1xpD1ZT8HDa6Dav8vCCJly79foL9XX0CoW
         SFGK6iKHavpRXdCMw8WZytNeSIlztaPPhMB8dnQjiBmfU2R3VSU6xjTVYH7W/pwr1VVT
         d0SiG6hmYmwqq86ENfOPaHqiEIiy/t9QZ0bXWqH34SdsR7wqFOIY+Y/c9PREceZpwuno
         CJyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwTSpTZUymq3kHcr9Nu1z8YQRX/L7YbJh3Ulw0Y/ks8=;
        b=Rg+ZjXq+5sMtCtskEzEsz4x+jvJeyJjMVw1+AR3oaXGmnAJWySsjrpuhDVDeU0X135
         B79meZvywkCwPwVT5Jf/VM3mJD3garX0HJIwjz7CCxZ20J0Gad0lDPRBLdnQ7hf/u1Zw
         8pB4CvNANwmCy1qFuIkS6vsWOAGpDyOWRKR8yFBpTOsnKXQnGBlBy0J1P7VmEPfogvWJ
         UbOd/VTEi3M9zi+vqm9/DmhHG20oQJATYcEzU9yxtz00CD32cyoE8XT8xN1RoWAW8fSb
         XkhS6VTBNeDCpM9gGtqJC0ODokjUJ9S7TtXYpsk0F4T8yeKJnQ8+dVndQLJp+RHUOFIk
         f5GA==
X-Gm-Message-State: AOAM531jLY9nPnQnipvEsbTym0T0A0YK8/cPPgVJotAI7ZxFM2nG0eH+
        4q65bkRPWivWYV22394fmcOfRz719wykk6oFAOI=
X-Google-Smtp-Source: ABdhPJzW5GDRw4d17zxtRMBP6HtDK/V/9hmWqMhsT2HnML2ftV8/5NXOGvllEgHuFXxBG5l4tRIoGsFMgO+Qk4q3irE=
X-Received: by 2002:a63:ee0f:: with SMTP id e15mr369788pgi.292.1606923018036;
 Wed, 02 Dec 2020 07:30:18 -0800 (PST)
MIME-Version: 1.0
References: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
 <cover.1606555939.git.xuanzhuo@linux.alibaba.com> <508fef55188d4e1160747ead64c6dcda36735880.1606555939.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <508fef55188d4e1160747ead64c6dcda36735880.1606555939.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Dec 2020 16:30:07 +0100
Message-ID: <CAJ8uoz1b3=gf5gttSe+Tknos7PdpBxaMEdud+iziDA55faMEcg@mail.gmail.com>
Subject: Re: [PATCH bpf V3 2/2] xsk: change the tx writeable condition
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 2:59 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Modify the tx writeable condition from the queue is not full to the
> number of present tx queues is less than the half of the total number
> of queues. Because the tx queue not full is a very short time, this will
> cause a large number of EPOLLOUT events, and cause a large number of
> process wake up.

And the Fixes label here should be:

Fixes: 35fcde7f8deb ("xsk: support for Tx")

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk.c       | 16 +++++++++++++---
>  net/xdp/xsk_queue.h |  6 ++++++
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9bbfd8a..6250447 100644
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
> @@ -436,7 +445,8 @@ static int xsk_generic_xmit(struct sock *sk)
>
>  out:
>         if (sent_frame)
> -               sk->sk_write_space(sk);
> +               if (xsk_tx_writeable(xs))
> +                       sk->sk_write_space(sk);
>
>         mutex_unlock(&xs->mutex);
>         return err;
> @@ -493,7 +503,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>
>         if (xs->rx && !xskq_prod_is_empty(xs->rx))
>                 mask |= EPOLLIN | EPOLLRDNORM;
> -       if (xs->tx && !xskq_cons_is_full(xs->tx))
> +       if (xs->tx && xsk_tx_writeable(xs))
>                 mask |= EPOLLOUT | EPOLLWRNORM;
>
>         return mask;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index cdb9cf3..9e71b9f 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -264,6 +264,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
>                 q->nentries;
>  }
>
> +static inline u32 xskq_cons_present_entries(struct xsk_queue *q)
> +{
> +       /* No barriers needed since data is not accessed */
> +       return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer);
> +}
> +
>  /* Functions for producers */
>
>  static inline bool xskq_prod_is_full(struct xsk_queue *q)
> --
> 1.8.3.1
>
