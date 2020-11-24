Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1722C215F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgKXJ2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731024AbgKXJ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:28:48 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3414C0613D6;
        Tue, 24 Nov 2020 01:28:47 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w202so2108896pff.10;
        Tue, 24 Nov 2020 01:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHKb7nomqkZKADTymOqb9YebPYk5PICoUgtAna9zlJA=;
        b=kUjmDLTzJAMIAUeMr0l6en9vgdoe6CAUWMsC1khPiePFd01zJwUlO9BM0Y0FZ9aevz
         UuXpqW5MEhhEgxiJybCmJkUd11D1zymEkd0P6UC8fCf8h6sOGAqrsjwNOSv1mZQpq0zZ
         fZlpvwfJTi3YHbKIyxz8zY77tpIBemrM+ONVEO20Mv+MPgkkcKOyd0r9Y9rNZkMQnjNl
         sBhNUyOo+DOSQoz6NQYXO+sxKBvvZ+JRvCzfItY+k4r0/NDORlvz5jSKEeSoQiPTW9WC
         /s/+PPiOgrJFNWN5PnxVPOHnizrU6pDvXAyKBNR76m5mLGKuEYucE4XUr4W5PXlC7fKE
         Vy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHKb7nomqkZKADTymOqb9YebPYk5PICoUgtAna9zlJA=;
        b=q2jktmY7o4LnmbbfPB1+nZejDj2PWU6RG/svkzuXaRno97KbPmWOC9z4VZLnsFOlFw
         SjbSr+UEkxKxHWIx4ea+QvNgd+JW5e5uYrce2I5Hikzo1WYcNpYYPTVR0eMzePSoZUyN
         WVFFzgQlBMfDhDXPIyv58Bd4P5RmYFT9i6RQX7z5nItn1SB+VbfGvP4KnBwShgNeHojV
         DAFhwSHKl2J4GwMKUf2AazG3wZ3cYrg0HW8/YkZpLkkN3MlvpPP7BlTfzBW9ONtDkJCs
         dMRzLaQPBbCumipF0O5nKvO1OnkjiKU9aljD/KN/hURiei9q3KI8IZTJ+mmVtOyNF67d
         hfbg==
X-Gm-Message-State: AOAM5320BOoFgDH/KqZ1AZnSnz7p383Y/5wHVpX0AVkgA17zj2pEIdto
        wLsKpv3mhEl48DMFefbZm83pTmNaHHyDUmHIr5g=
X-Google-Smtp-Source: ABdhPJx/5TVimn8Gf3cgvlwp5FjpuTfABlr3VrMAEiLMC1K6AxnhqJ0Qm6dcxy+ddZgRSA0ATSDhCzK7WxVTmS24PVk=
X-Received: by 2002:a63:3e0f:: with SMTP id l15mr3103811pga.208.1606210127443;
 Tue, 24 Nov 2020 01:28:47 -0800 (PST)
MIME-Version: 1.0
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
 <cover.1605686678.git.xuanzhuo@linux.alibaba.com> <b7b0432d49ab05064efb85f1858b6e6f9e1274bd.1605686678.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <b7b0432d49ab05064efb85f1858b6e6f9e1274bd.1605686678.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 24 Nov 2020 10:28:36 +0100
Message-ID: <CAJ8uoz2N_bRgJE94wqX4jSL0VfPDcVq6ppjbmgeMLgD-Qu9Oiw@mail.gmail.com>
Subject: Re: [PATCH 2/3] xsk: change the tx writeable condition
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
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 9:25 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Modify the tx writeable condition from the queue is not full to the
> number of remaining tx queues is less than the half of the total number
> of queues. Because the tx queue not full is a very short time, this will
> cause a large number of EPOLLOUT events, and cause a large number of
> process wake up.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk.c       | 20 +++++++++++++++++---
>  net/xdp/xsk_queue.h |  6 ++++++
>  2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 7f0353e..bc3d4ece 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -211,6 +211,17 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
>         return 0;
>  }
>
> +static bool xsk_writeable(struct xdp_sock *xs)

Not clear what this function does from the name. How about
xsk_tx_half_free() or maybe xsk_tx_writeable()?

> +{
> +       if (!xs->tx)
> +               return false;

Skip this test as it will slow down the code. It is only needed in one
place below.

> +       if (xskq_cons_left(xs->tx) > xs->tx->nentries / 2)
> +               return false;
> +
> +       return true;
> +}
> +
>  static bool xsk_is_bound(struct xdp_sock *xs)
>  {
>         if (READ_ONCE(xs->state) == XSK_BOUND) {
> @@ -296,7 +307,8 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
>         rcu_read_lock();
>         list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
>                 __xskq_cons_release(xs->tx);
> -               xs->sk.sk_write_space(&xs->sk);
> +               if (xsk_writeable(xs))
> +                       xs->sk.sk_write_space(&xs->sk);
>         }
>         rcu_read_unlock();
>  }
> @@ -442,7 +454,8 @@ static int xsk_generic_xmit(struct sock *sk)
>
>  out:
>         if (sent_frame)
> -               sk->sk_write_space(sk);
> +               if (xsk_writeable(xs))
> +                       sk->sk_write_space(sk);
>
>         mutex_unlock(&xs->mutex);
>         return err;
> @@ -499,7 +512,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>
>         if (xs->rx && !xskq_prod_is_empty(xs->rx))
>                 mask |= EPOLLIN | EPOLLRDNORM;
> -       if (xs->tx && !xskq_cons_is_full(xs->tx))
> +

No reason to introduce a newline here.

> +       if (xsk_writeable(xs))

Add an explicit "xs->tx &&" in the if statement here as we removed the
test in xsk_writeable.

>                 mask |= EPOLLOUT | EPOLLWRNORM;
>
>         return mask;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index cdb9cf3..82a5228 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -264,6 +264,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
>                 q->nentries;
>  }
>
> +static inline __u64 xskq_cons_left(struct xsk_queue *q)

Let us call this xskq_cons_entries_present() or
xskq_cons_filled_entries(). The word "left" has the connotation that I
still have stuff left to do. While this is kind of true for this case,
it might not be for other cases that can use your function. The
function provides how many (filled) entries that are present in the
ring. Can you come up with a better name as I am not super fond of my
suggestions? It would have been nice to call it xskq_cons_nb_entries()
but there is already such a function that is lazy in nature and that
allows access to the entries.

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
