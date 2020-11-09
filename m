Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106F82AC3D8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgKIS3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKIS3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:29:35 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C02C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 10:29:34 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id v16so3087865uat.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 10:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jLA7/mamq88rlEqhjwdpSzG3LkBhX2EWIU1whnjCGZU=;
        b=B7rwhjI0RLzwkFqQMa3OcYJxW6clmqovdwWLxiGbE2JhOl4pPKyEXj3+VowoG8xdwq
         J32UKP1mRlgB5VAGzAQc6X2Y/6CdTFx4SEGCr9tJvqirBKa8LWrfX92+Ji1DqaaYF4UW
         Spt5qjLccd502QWiuJqhnLJArWa20Dc2EMqkr8LyMcCeKGcTW2Z9pLsewCrWHmyabxej
         PinweqLPNYStuMZDfhoucH8qZuz/LOmmBKxQUBgJOre94Od6rXOxxWUGHqIYwGyTLn4m
         8R+h0p00lY2VwtE7YLTDHAovtHCwpBFtFgNwXKhxC/LRocTnJKUY/EnISDdWCy/7Ot+L
         IT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jLA7/mamq88rlEqhjwdpSzG3LkBhX2EWIU1whnjCGZU=;
        b=hYgQ3E2nmzRs+MjYMJRBEfZp253hV/YYKsEi5xa4yWQxOp2ZKnsWJUuq8nDbNLTx1L
         fj5WP6FWUvIEkNE9+ZOHkmu4Faj+q3dhDYkwN6N3r62quBz1kkQpWDmw+RchbHsVznOT
         FQS4ulCpHqIiSBCK5FKAcR7f7i8pgSdTqyy0yU2+4ghlz9fhZlI16cfDF/VwjGh1/Ysi
         xyKSr9tcmwrkhx9SZ1tHy2UCFc5c+jRBuM17lnn1PLBViGBopjl8hwZcQUuGHXNuYLtz
         kG4/JTMBrSCLboIyJ9/3QClFKveSRpjge7xFs4KLXvhBZt0eazhPD13xiXp3MCJ3z/dp
         PhAg==
X-Gm-Message-State: AOAM5305SMvzg66XMPdKOk5PT9TQloeZbfDxzwY7x0YLt+qkKKtWztCJ
        39RYWAnCi614iYJYhS/t8iTvpBLt30k=
X-Google-Smtp-Source: ABdhPJw1VcNXYhhNXEptAieCgr0j3fnbn+0wXJfrqFwidUVLenBBB3Nq635VBxjHBQT+Icc7UJ/deg==
X-Received: by 2002:ab0:2397:: with SMTP id b23mr7778252uan.61.1604946572998;
        Mon, 09 Nov 2020 10:29:32 -0800 (PST)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id m23sm1358430vsl.0.2020.11.09.10.29.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 10:29:31 -0800 (PST)
Received: by mail-vs1-f50.google.com with SMTP id b129so5523978vsb.1
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 10:29:31 -0800 (PST)
X-Received: by 2002:a67:ce0e:: with SMTP id s14mr8950211vsl.13.1604946571245;
 Mon, 09 Nov 2020 10:29:31 -0800 (PST)
MIME-Version: 1.0
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch> <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
In-Reply-To: <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Nov 2020 13:28:54 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc0QLM4QpinZ1XiLreRECBDVbanwoFtMhnF6caEWjXTBw@mail.gmail.com>
Message-ID: <CA+FuTSc0QLM4QpinZ1XiLreRECBDVbanwoFtMhnF6caEWjXTBw@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 12:37 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
> > While testing UDP GSO fraglists forwarding through driver that uses
> > Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> > iperf packets:
> >
> > [ ID] Interval           Transfer     Bitrate         Jitter
> > [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
> >
> > Simple switch to napi_gro_receive() any other method without frag0
> > shortcut completely resolved them.
> >
> > I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> > callback. While it's probably OK for non-frag0 paths (when all
> > headers or even the entire frame are already in skb->data), this
> > inline points to junk when using Fast GRO (napi_gro_frags() or
> > napi_gro_receive() with only Ethernet header in skb->data and all
> > the rest in shinfo->frags) and breaks GRO packet compilation and
> > the packet flow itself.
> > To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> > are typically used. UDP even has an inline helper that makes use of
> > them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> > to get rid of the out-of-order delivers.
> >
> > Present since the introduction of plain UDP GRO in 5.0-rc1.
> >
> > Since v1 [1]:
> >  - added a NULL pointer check for "uh" as suggested by Willem.
> >
> > [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch
> >
> > Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/ipv4/udp_offload.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index e67a66fbf27b..7f6bd221880a 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
> >                                              struct sk_buff *skb)
> >  {
> > -     struct udphdr *uh = udp_hdr(skb);
> > +     struct udphdr *uh = udp_gro_udphdr(skb);
> >       struct sk_buff *pp = NULL;
> >       struct udphdr *uh2;
> >       struct sk_buff *p;
> >       unsigned int ulen;
> >       int ret = 0;
> >
> > +     if (unlikely(!uh)) {
>
> How uh could be NULL here ?
>
> My understanding is that udp_gro_receive() is called
> only after udp4_gro_receive() or udp6_gro_receive()
> validated that udp_gro_udphdr(skb) was not NULL.

Oh indeed. This has already been checked before.

> > +             NAPI_GRO_CB(skb)->flush = 1;
> > +             return NULL;
> > +     }
> > +
> >       /* requires non zero csum, for symmetry with GSO */
> >       if (!uh->check) {
> >               NAPI_GRO_CB(skb)->flush = 1;
> >
>
> Why uh2 is left unchanged ?
>
>     uh2 = udp_hdr(p);

Isn't that the same as th2 = tcp_hdr(p) in tcp_gro_receive? no frag0
optimization to worry about for packets on the list.


> ...
>
