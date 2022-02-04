Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323704A9242
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbiBDCPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiBDCPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:15:47 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10B7C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 18:15:47 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k31so14682476ybj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 18:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieOhCB4MeT/sC4IP7axModbr5UVZL3sFLnIUhvl9BhU=;
        b=IPy2Q25qzDDNnRkd9Y/1mbYS+aKZ05jK9zm9uZtETMhUXoIUErquy1+TbsMhKuRHRy
         JhDYhZtzvjR/Ozcz8elnvCGie4/gZPXtvPChJAf4ZHOsrBh97vwgKvsXipAdx7hWYZ33
         oUlXmfID8o1/Ulvb/a5zJ0aqMtuGxuVnEk8puUkupZNKjqK0Sb6WmaSpZrk6+QZZy+mD
         v/clh81PIiJYuyj+89hGl/fP2VO35k9jrPpeA2GNYRwpXI99bE9IM2O+Me1KJb8ZSaon
         g6O98o/NpVPOM++c41DC3uFsAe1EFQ7Y86y2zLkrBMPpl8lQpDBY9fC8G+ZplBsox6Uh
         4uoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieOhCB4MeT/sC4IP7axModbr5UVZL3sFLnIUhvl9BhU=;
        b=uAOiddpngT17iupJTTkrs98/pbHmGkq4XqTy1yKV3ozCYFyZIsv/Jo8Lg/cuuauOqB
         A2n5srwOBiDTG+BhfKKsMNw171uXENSw6fQ2ghzt26HLKtWsPX1sc2JjZ+8WOxBuNwxz
         QOlkF9O/njD1ovD9a/2rn+LnVp2mdZkjSjpz0tmfrq1kjJ/GmU//B2zOl4B++yQDHvyS
         aHLEUgXC+ZS8zr1aCcLad6+ulPlaHZINU9a+AYC3g7YyH4tsVtHGx3QNSNjBFINOluQm
         QP6IglYLI0g0m/TwLZA0na5c3F9flIjd+apoxJEUwUcNNIRn9rYdFpRUkWUJ7NJUUTLo
         sSCQ==
X-Gm-Message-State: AOAM531jsE/KMJ/tjY4MaKKDEp/R6hR0IAh3xWsxpBIsl60Ot3eXdetG
        pawuul4m8flHzpBQELf9ioFdtwMISBWiXaZ9bukveg==
X-Google-Smtp-Source: ABdhPJx+RwaqvBkx5ksFpK9vDLeKB0d5pXRQMaU6tOhA70fTqi0FSpmnhBNclxJ32lxxNLeqJDPc+ZR8kKPyjThLGUY=
X-Received: by 2002:a81:3a4f:: with SMTP id h76mr948662ywa.543.1643940946291;
 Thu, 03 Feb 2022 18:15:46 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
 <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
 <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
 <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com>
 <CANn89iLkx34cnAJboMdRSbQz63OnD7ttxnEX6gMacjWdEL+7Eg@mail.gmail.com>
 <CANn89iJjwuN6hv7CuvR3n5efwo4MjV+Xe2byK7wy4k0AXkJkzg@mail.gmail.com> <CANn89i+LgmKzDCuLZ+5NZu84CHtKAvmTW+=bYRkX5NLjAqXkNA@mail.gmail.com>
In-Reply-To: <CANn89i+LgmKzDCuLZ+5NZu84CHtKAvmTW+=bYRkX5NLjAqXkNA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 18:15:34 -0800
Message-ID: <CANn89iJ-LrhAKfyew43upt+Nrd_S8bO4GQ02ueUqi=c66t--rw@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 5:48 PM Eric Dumazet <edumazet@google.com> wrote:

>
> Well, this does not work at all.
>
>
>
>
> >  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
> >  {
> >         /* If forwarding is enabled, RA are not accepted unless the special
> > diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> > index d37a79a8554e92a1dcaa6fd023cafe2114841ece..7f65097c8f30fa19a8c9c265eb4f027e91848021
> > 100644
> > --- a/net/ipv6/ip6_offload.c
> > +++ b/net/ipv6/ip6_offload.c
> > @@ -87,6 +87,27 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
> >         bool gso_partial;
> >
> >         skb_reset_network_header(skb);
> > +       if (ipv6_has_hopopt_jumbo(skb)) {
> > +               const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> > +               int err;
> > +
> > +               err = skb_cow_head(skb, 0);
> > +               if (err < 0)
> > +                       return ERR_PTR(err);
> > +
> > +               /* remove the HBH header.
> > +                * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > +                */
> > +               memmove(skb->data + hophdr_len,
> > +                       skb->data,

Oh, I must use skb_mac_header() instead of skb->data, sorry for the noise.

> > +                       ETH_HLEN + sizeof(struct ipv6hdr));
> > +               skb->data += hophdr_len;
> > +               skb->len -= hophdr_len;
> > +               skb->network_header += hophdr_len;
> > +               skb->mac_header += hophdr_len;
> > +               ipv6h = (struct ipv6hdr *)skb->data;
> > +               ipv6h->nexthdr = IPPROTO_TCP;
> > +       }
> >         nhoff = skb_network_header(skb) - skb_mac_header(skb);
> >         if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
> >                 goto out;
