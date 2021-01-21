Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486BC2FE440
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbhAUHn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbhAUHni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:43:38 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98344C061575;
        Wed, 20 Jan 2021 23:41:28 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id kx7so1093670pjb.2;
        Wed, 20 Jan 2021 23:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WSQWbxfP2pXq6KG7rxKw6Frm1tiAUnTy+aL8NH7tLg=;
        b=U+oUAi+6oPz7NK/UpWAYd2rzwp662I5l05vsAZctRN13kGBNBWB+wdHiMdJf4vrd2Z
         PAR/V91v5bSPqb8FQ0Q3KO3jHi6Sruea2oqzQr+drUyRarFTz8w6lRM+wJ78aSWWaaYt
         WJfWsT23QYzAIBpdgK/9BEPnIC8hL7KJAU2LF6o/zwV46NlWLn/ZVm6243cwjFV159RU
         m/TEkIHmEWgXyyN1DYpVdfMxPKzBCp7N2Pj4r85aO/Klg0qfgjN7B46bVXEGWjbqhXq5
         tASO7vbl3rW+80m/KOOEPPn0ObUtVpnCDhTqs2eVHfMTpRct1GXQdMJ/tckQ9SyedLu6
         b9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WSQWbxfP2pXq6KG7rxKw6Frm1tiAUnTy+aL8NH7tLg=;
        b=tbohkIP6XbS/OzIs9XX4fHIQMkT/3ZSYBsUQXy3zR4BOTYVFxsVqtbmcm8PxevIe0t
         9smtH+zSNxjf2xZhJJOevKHysWMnBakB+h1oZBK6NEdoqIy2Ycj0pGHDC40eFRFI6qgt
         k+5z26zQpSdG3ds/xE665fgCeW5iU/zB0LV1+2728aG/ExDoU2nKr3G1M5MXUULdRyln
         3xmYpQ+5/E6Hd//bEv3IcJTkn4hEiUEXyqT9gAyFf59GbokZLEdwO+PXT3heP9EaWweD
         5SqDS8YfHsczNYX1tL25Av57i6LNNM0XO6FdZbvcOhj53+Ek8fOvi7+YDcKIwv9VJMf0
         a7mg==
X-Gm-Message-State: AOAM531/0d2wNl3Ucw5fCxTT3QUZrV9ZYpiFCqPtQQEOuCGEY6GgR1nl
        v5hzQHpLbF66MlsbBi5fVzeP+zfLo5Z4aKitGgw=
X-Google-Smtp-Source: ABdhPJwdys27ZARkcsj3JlP6jJ7vhfnyOXsgy7FqDh/DOuIWf5jJV+IaXEog/pbBxb3lxbAWI82s0GLKrmGAdclf+HQ=
X-Received: by 2002:a17:902:7c04:b029:dc:99f2:eea4 with SMTP id
 x4-20020a1709027c04b02900dc99f2eea4mr13569991pll.43.1611214888029; Wed, 20
 Jan 2021 23:41:28 -0800 (PST)
MIME-Version: 1.0
References: <0461512be1925bece9bcda1b4924b09eaa4edd87.1611131344.git.xuanzhuo@linux.alibaba.com>
 <20210120135537.5184-1-alobakin@pm.me>
In-Reply-To: <20210120135537.5184-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 21 Jan 2021 08:41:17 +0100
Message-ID: <CAJ8uoz0=7UmJpqKGeb9BQp9qv_c6ioyxhtU4+B+j-Z01pc-BhQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] xsk: build skb by page
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 9:29 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Wed, 20 Jan 2021 16:30:56 +0800
>
> > This patch is used to construct skb based on page to save memory copy
> > overhead.
> >
> > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > directly construct skb. If this feature is not supported, it is still
> > necessary to copy data to construct skb.
> >
> > ---------------- Performance Testing ------------
> >
> > The test environment is Aliyun ECS server.
> > Test cmd:
> > ```
> > xdpsock -i eth0 -t  -S -s <msg size>
> > ```
> >
> > Test result data:
> >
> > size    64      512     1024    1500
> > copy    1916747 1775988 1600203 1440054
> > page    1974058 1953655 1945463 1904478
> > percent 3.0%    10.0%   21.58%  32.3%
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > ---
> >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 86 insertions(+), 18 deletions(-)
>
> Now I like the result, thanks!
>
> But Patchwork still display your series incorrectly (messages 0 and 1
> are missing). I'm concerning maintainers may not take this in such
> form. Try to pass the folder's name, not folder/*.patch to
> git send-email when sending, and don't use --in-reply-to when sending
> a new iteration.

Xuan,

Please make the new submission of the patch set a v3 even though you
did not change the code. Just so we can clearly see it is the new
submission.

> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 8037b04..40bac11 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> >       sock_wfree(skb);
> >  }
> >
> > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > +                                           struct xdp_desc *desc)
> > +{
> > +     u32 len, offset, copy, copied;
> > +     struct sk_buff *skb;
> > +     struct page *page;
> > +     void *buffer;
> > +     int err, i;
> > +     u64 addr;
> > +
> > +     skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > +     if (unlikely(!skb))
> > +             return ERR_PTR(err);
> > +
> > +     addr = desc->addr;
> > +     len = desc->len;
> > +
> > +     buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > +     offset = offset_in_page(buffer);
> > +     addr = buffer - xs->pool->addrs;
> > +
> > +     for (copied = 0, i = 0; copied < len; i++) {
> > +             page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > +
> > +             get_page(page);
> > +
> > +             copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > +
> > +             skb_fill_page_desc(skb, i, page, offset, copy);
> > +
> > +             copied += copy;
> > +             addr += copy;
> > +             offset = 0;
> > +     }
> > +
> > +     skb->len += len;
> > +     skb->data_len += len;
> > +     skb->truesize += len;
> > +
> > +     refcount_add(len, &xs->sk.sk_wmem_alloc);
> > +
> > +     return skb;
> > +}
> > +
> > +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> > +                                  struct xdp_desc *desc)
> > +{
> > +     struct sk_buff *skb = NULL;
> > +
> > +     if (xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> > +             skb = xsk_build_skb_zerocopy(xs, desc);
> > +             if (IS_ERR(skb))
> > +                     return skb;
> > +     } else {
> > +             void *buffer;
> > +             u32 len;
> > +             int err;
> > +
> > +             len = desc->len;
> > +             skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
> > +             if (unlikely(!skb))
> > +                     return ERR_PTR(err);
> > +
> > +             skb_put(skb, len);
> > +             buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
> > +             err = skb_store_bits(skb, 0, buffer, len);
> > +             if (unlikely(err)) {
> > +                     kfree_skb(skb);
> > +                     return ERR_PTR(err);
> > +             }
> > +     }
> > +
> > +     skb->dev = xs->dev;
> > +     skb->priority = xs->sk.sk_priority;
> > +     skb->mark = xs->sk.sk_mark;
> > +     skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
> > +     skb->destructor = xsk_destruct_skb;
> > +
> > +     return skb;
> > +}
> > +
> >  static int xsk_generic_xmit(struct sock *sk)
> >  {
> >       struct xdp_sock *xs = xdp_sk(sk);
> > @@ -446,43 +527,30 @@ static int xsk_generic_xmit(struct sock *sk)
> >               goto out;
> >
> >       while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> > -             char *buffer;
> > -             u64 addr;
> > -             u32 len;
> > -
> >               if (max_batch-- == 0) {
> >                       err = -EAGAIN;
> >                       goto out;
> >               }
> >
> > -             len = desc.len;
> > -             skb = sock_alloc_send_skb(sk, len, 1, &err);
> > -             if (unlikely(!skb))
> > +             skb = xsk_build_skb(xs, &desc);
> > +             if (IS_ERR(skb)) {
> > +                     err = PTR_ERR(skb);
> >                       goto out;
> > +             }
> >
> > -             skb_put(skb, len);
> > -             addr = desc.addr;
> > -             buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > -             err = skb_store_bits(skb, 0, buffer, len);
> >               /* This is the backpressure mechanism for the Tx path.
> >                * Reserve space in the completion queue and only proceed
> >                * if there is space in it. This avoids having to implement
> >                * any buffering in the Tx path.
> >                */
> >               spin_lock_irqsave(&xs->pool->cq_lock, flags);
> > -             if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> > +             if (xskq_prod_reserve(xs->pool->cq)) {
> >                       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> >                       kfree_skb(skb);
> >                       goto out;
> >               }
> >               spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> >
> > -             skb->dev = xs->dev;
> > -             skb->priority = sk->sk_priority;
> > -             skb->mark = sk->sk_mark;
> > -             skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> > -             skb->destructor = xsk_destruct_skb;
> > -
> >               err = __dev_direct_xmit(skb, xs->queue_id);
> >               if  (err == NETDEV_TX_BUSY) {
> >                       /* Tell user-space to retry the send */
> > --
> > 1.8.3.1
>
> Al
>
