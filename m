Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771923B24DF
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFXCYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFXCYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:24:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAD6C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:21:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w13so252457edc.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mqx5UogvVjp8zxCnMoRJTbN6b3RWKNDq3ceLfJhxs7c=;
        b=qcTzADLMap2BNY+5MV2MbQf8CP6mvltalbj5a0sOLcl7TpU8IEAQtuIaEd+fL9v8gw
         ERj5fTkkAYdNRe9c509Mz2XXb4lSC0z54IPqN+xrqSSm0NkLyxmA6zsTGaCxJtAV3HsN
         678gH/Vnb7jVRFlmF9mJQ1vtcmGf2E7TpG6owXeIDqK6VNjpCZwROW+UEjiEpXbFoXBS
         Y55Re5N2lwPCXGK+e8Dc5dIZUj3ncghzZA55dRT7+pvY19Ec9zXzn8hKLzZA+uhKfwjr
         6DmkGyumAOE1Hxl5LDAml7lKFIrVK59nuAfuIj31Z91RyxCvi9Hhmiy5S78XUth018Yt
         TYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mqx5UogvVjp8zxCnMoRJTbN6b3RWKNDq3ceLfJhxs7c=;
        b=YJZOVGaFqRcR79ptmVipO6kYal1RxUSwG38alFP3+r5XCdblRB+IMPnx/wSSJjx8fF
         7NRgLK9nyWQI5QSdPnvqQOhfRPZ53azFZQfaOEgDCCjiz2p9/r4dKXvDCccz+M6DxQRi
         rrrx4XC/zfOzQnFW+md4+2mYgfyLjYB0gJAwPQ5m0gZ9Vv+Lpk6FdO+M5fidi+3Jo9x2
         2vUM7YOgMqlxw+3bgyqqZKq4oxhB4WkOup2VjiydgbtbXj98rCxDH399SmZdMkAqTe9l
         /Er7LAP5a8eJ145Um8yx4QIDjQr8/HUHA4H3nS6c7Wk3K9gEnwmVxDlcMoO+D2yVzFIs
         Ra1g==
X-Gm-Message-State: AOAM531IYTVyol77gJzPIH9JtofadikgadNdGFo2gWl0leah7pAsK8JG
        J1Ok0uR+WnPO2dUNlahLZvufkwruxZAV6w==
X-Google-Smtp-Source: ABdhPJylIK+2sMnsoDLUf1a3FIHqRmtJhAr6Tdu5VRruvta6/j5LlFUBhxNTZLvRYyZmTmfeVJfQkA==
X-Received: by 2002:aa7:c548:: with SMTP id s8mr3722540edr.148.1624501308704;
        Wed, 23 Jun 2021 19:21:48 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id y5sm1002058eds.12.2021.06.23.19.21.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:21:48 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id u11so4747490wrw.11
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 19:21:48 -0700 (PDT)
X-Received: by 2002:adf:b605:: with SMTP id f5mr1334161wre.419.1624501307628;
 Wed, 23 Jun 2021 19:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210623214438.2276538-1-kuba@kernel.org>
In-Reply-To: <20210623214438.2276538-1-kuba@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Jun 2021 22:21:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
Message-ID: <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        brouer@redhat.com, Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 5:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
>
> This is entirely avoidable, we can use an skb with page frags.
>
> af_unix solves a similar problem by limiting the head
> length to SKB_MAX_ALLOC. This seems like a good and simple
> approach. It means that UDP messages > 16kB will now
> use fragments if underlying device supports SG, if extra
> allocator pressure causes regressions in real workloads
> we can switch to trying the large allocation first and
> falling back.
>
> v4: pre-calculate all the additions to alloclen so
>     we can be sure it won't go over order-2
>
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/ip_output.c  | 32 ++++++++++++++++++--------------
>  net/ipv6/ip6_output.c | 32 +++++++++++++++++---------------
>  2 files changed, 35 insertions(+), 29 deletions(-)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index c3efc7d658f6..8d8a8da3ae7e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1054,7 +1054,7 @@ static int __ip_append_data(struct sock *sk,
>                         unsigned int datalen;
>                         unsigned int fraglen;
>                         unsigned int fraggap;
> -                       unsigned int alloclen;
> +                       unsigned int alloclen, alloc_extra;

Separate line?

>                         unsigned int pagedlen;
>                         struct sk_buff *skb_prev;
>  alloc_new_skb:
> @@ -1074,35 +1074,39 @@ static int __ip_append_data(struct sock *sk,
>                         fraglen = datalen + fragheaderlen;
>                         pagedlen = 0;
>
> +                       alloc_extra = hh_len + 15;
> +                       alloc_extra += exthdrlen;
> +
> +                       /* The last fragment gets additional space at tail.
> +                        * Note, with MSG_MORE we overallocate on fragments,
> +                        * because we have no idea what fragment will be
> +                        * the last.
> +                        */
> +                       if (datalen == length + fraggap)
> +                               alloc_extra += rt->dst.trailer_len;
> +
>                         if ((flags & MSG_MORE) &&
>                             !(rt->dst.dev->features&NETIF_F_SG))
>                                 alloclen = mtu;
> -                       else if (!paged)
> +                       else if (!paged &&
> +                                (fraglen + alloc_extra < SKB_MAX_ALLOC ||
> +                                 !(rt->dst.dev->features & NETIF_F_SG)))

This perhaps deserves a comment. Something like this?

  /* avoid order-3 allocations where possible: replace with frags if
allowed (sg) */

>                                 alloclen = fraglen;
>                         else {
>                                 alloclen = min_t(int, fraglen, MAX_HEADER);
>                                 pagedlen = fraglen - alloclen;
>                         }
>
> -                       alloclen += exthdrlen;
> -
> -                       /* The last fragment gets additional space at tail.
> -                        * Note, with MSG_MORE we overallocate on fragments,
> -                        * because we have no idea what fragment will be
> -                        * the last.
> -                        */
> -                       if (datalen == length + fraggap)
> -                               alloclen += rt->dst.trailer_len;
> +                       alloclen += alloc_extra;
>
>                         if (transhdrlen) {
> -                               skb = sock_alloc_send_skb(sk,
> -                                               alloclen + hh_len + 15,
> +                               skb = sock_alloc_send_skb(sk, alloclen,
>                                                 (flags & MSG_DONTWAIT), &err);
>                         } else {
>                                 skb = NULL;
>                                 if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
>                                     2 * sk->sk_sndbuf)
> -                                       skb = alloc_skb(alloclen + hh_len + 15,
> +                                       skb = alloc_skb(alloclen,
>                                                         sk->sk_allocation);
>                                 if (unlikely(!skb))
>                                         err = -ENOBUFS;

Is there any risk of regressions? If so, would it be preferable to try
regular alloc and only on failure, just below here, do the size and SG
test and if permitted jump back to the last of the three alloc_len
options?
