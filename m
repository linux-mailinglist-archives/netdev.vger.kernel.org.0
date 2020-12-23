Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737B22E1AC0
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgLWKFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 05:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgLWKFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 05:05:11 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAC0C0613D3;
        Wed, 23 Dec 2020 02:04:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n3so879099pjm.1;
        Wed, 23 Dec 2020 02:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5XHgKNmGxjNiDE5b2KtQ27P+6FboVI+ofwBHe/X6fw=;
        b=C7EU8nzzmc83zR6nl8GTUmbIR4hYm+QIReH0eCNJtTacD/CPyEnb9xZEFzLAMA6lX1
         TpNp/9Fv/882R1br8UjpWXqL/sHqyXuMEeQh8LE6fB+GOKqs/mPcJ5ilTUSnkUT/yMyv
         vEWAVspbSxUWcZhcdN2GKHRqSYHjF+QZ4mITkWV4GKPbu6HOPwAYuYP2jZT1upLbEDwA
         EtM+QGS9N+g/kdZbsHb7ultxZ9TIfKOM5q7GHE2eeHggfaGL+OS/WmqE/jd/N7NmBmMt
         Ryrk065EHvlYdRwsd0bE2XkNjUkhiT9eT2kH7JH1rxrxCxdgmOAo8OFGo3vjo0E9TkK1
         kcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5XHgKNmGxjNiDE5b2KtQ27P+6FboVI+ofwBHe/X6fw=;
        b=OLfvzCe+KpcJjJJSzRUcm4A9AKjzttla7kWuEaMp6kWqSpGF1yNBuJojgsRTgniIYP
         7hXGxjwVd1CYANZdB6HTbFtjqKYxQ0/tA007o4N/iQagpSr5jvQrGvets0R/l1zTGEgz
         VHpcjuoujQ2F0soczv+qHllJlTG3W2HJ4MTX61/dS24ClqBHKmhcHQkpxtGi1bP42m6p
         QgntWhmsrIVG6mWu7b0nC4908TaWJXSQO/h9Q/6D2QVhraEp+2k2Usj3N1ZzIjOIRX2o
         HAXz/X46qH6x7DWKF3wgYqAtHqh/Ge5gtO+2LaY73h1r9RvuCRXj1Jxq5E01WuEnMS9k
         Xpvg==
X-Gm-Message-State: AOAM532rGHvVH/ggJ9N9RSErVsOF9x8U6Iwlei4rHaGRqB+HhurPS29Y
        fbeJ1Ov5kBhZxdVxUVnUSt2jmBvCzkkjNK+fPL0=
X-Google-Smtp-Source: ABdhPJyIYYgicvnsR+BGJ3UdRrM2LeQbrvQwy5ibqijTo2qKHPufau8DK2LwgA8tFMCTQ4O7xn3hqrACF9krZXKK+Eo=
X-Received: by 2002:a17:902:d38b:b029:db:e003:3ff0 with SMTP id
 e11-20020a170902d38bb02900dbe0033ff0mr93725pld.7.1608717870664; Wed, 23 Dec
 2020 02:04:30 -0800 (PST)
MIME-Version: 1.0
References: <9830fcef7159a47bae361fc213c589449f6a77d3.1608713585.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <9830fcef7159a47bae361fc213c589449f6a77d3.1608713585.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 23 Dec 2020 11:04:19 +0100
Message-ID: <CAJ8uoz2Enx-WwY6RmCp0RXBG2U3BUpagw-X8hQChPResHCM-XA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: build skb by page
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 9:57 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> This patch is used to construct skb based on page to save memory copy
> overhead.
>
> Taking into account the problem of addr unaligned, and the
> possibility of frame size greater than page in the future.

Thanks Xuan for the patch set. Could you please share performance
numbers so we know how much this buys us? Would be good if you could
produce them for 64 bytes, 1500 bytes and something in the middle so
we can judge the benefits of this.

Please note that responses will be delayed this week and next due to
the Christmas and New Years holidays over here.

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk.c | 68 ++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 51 insertions(+), 17 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index ac4a317..7cab40f 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -430,6 +430,55 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>         sock_wfree(skb);
>  }
>
> +static struct sk_buff *xsk_build_skb_bypage(struct xdp_sock *xs, struct xdp_desc *desc)
> +{
> +       char *buffer;
> +       u64 addr;
> +       u32 len, offset, copy, copied;
> +       int err, i;
> +       struct page *page;
> +       struct sk_buff *skb;
> +
> +       skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> +       if (unlikely(!skb))
> +               return NULL;
> +
> +       addr = desc->addr;
> +       len = desc->len;
> +
> +       buffer = xsk_buff_raw_get_data(xs->pool, addr);
> +       offset = offset_in_page(buffer);
> +       addr = buffer - (char *)xs->pool->addrs;
> +
> +       for (copied = 0, i = 0; copied < len; ++i) {
> +               page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> +
> +               get_page(page);
> +
> +               copy = min((u32)(PAGE_SIZE - offset), len - copied);
> +
> +               skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +               copied += copy;
> +               addr += copy;
> +               offset = 0;
> +       }
> +
> +       skb->len += len;
> +       skb->data_len += len;
> +       skb->truesize += len;
> +
> +       refcount_add(len, &xs->sk.sk_wmem_alloc);
> +
> +       skb->dev = xs->dev;
> +       skb->priority = xs->sk.sk_priority;
> +       skb->mark = xs->sk.sk_mark;
> +       skb_shinfo(skb)->destructor_arg = (void *)(long)addr;
> +       skb->destructor = xsk_destruct_skb;
> +
> +       return skb;
> +}
> +
>  static int xsk_generic_xmit(struct sock *sk)
>  {
>         struct xdp_sock *xs = xdp_sk(sk);
> @@ -445,40 +494,25 @@ static int xsk_generic_xmit(struct sock *sk)
>                 goto out;
>
>         while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> -               char *buffer;
> -               u64 addr;
> -               u32 len;
> -
>                 if (max_batch-- == 0) {
>                         err = -EAGAIN;
>                         goto out;
>                 }
>
> -               len = desc.len;
> -               skb = sock_alloc_send_skb(sk, len, 1, &err);
> +               skb = xsk_build_skb_bypage(xs, &desc);
>                 if (unlikely(!skb))
>                         goto out;
>
> -               skb_put(skb, len);
> -               addr = desc.addr;
> -               buffer = xsk_buff_raw_get_data(xs->pool, addr);
> -               err = skb_store_bits(skb, 0, buffer, len);
>                 /* This is the backpressure mechanism for the Tx path.
>                  * Reserve space in the completion queue and only proceed
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
>                  */
> -               if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +               if (xskq_prod_reserve(xs->pool->cq)) {
>                         kfree_skb(skb);
>                         goto out;
>                 }
>
> -               skb->dev = xs->dev;
> -               skb->priority = sk->sk_priority;
> -               skb->mark = sk->sk_mark;
> -               skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> -               skb->destructor = xsk_destruct_skb;
> -
>                 err = __dev_direct_xmit(skb, xs->queue_id);
>                 if  (err == NETDEV_TX_BUSY) {
>                         /* Tell user-space to retry the send */
> --
> 1.8.3.1
>
