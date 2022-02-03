Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2695F4A8CA8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244319AbiBCTpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiBCTpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:45:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51886C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:45:46 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w14so8277630edd.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8w9QMaojrKN5UmA8klT4B5OR+h0W4qNKr+bD1qbAvYg=;
        b=Q7WNYM/Be8oEziWrMtn2TNba38Zpg58KyQ4VlczUXKEUmlh0t7aKzYPpnOuoNYc0+k
         rbQ7goLCSq5rRePx46CDDrijFu8UCu80m4FP5ib9Czwl5ZSHT9svSW94N76N2+PvFUt/
         CWQtqbJ02zc9zXQDJjNqbHwb/Edx7RIRmtloaxmZI1LjY2NUj+J+cHSCrobWJ4TWqAFL
         UUBJe2T43XUv6yAuPvtQeWVQ+5mhW3UzVKry4LsBdEQWouxVLb8j9qoDC++U2h6nUwzM
         1IEUWDKsuZYs/fW47+8TneD4hAfSOfUTP10rcA6IQunrRD3pvXrtAj0AflPCFM7KXTI3
         qQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8w9QMaojrKN5UmA8klT4B5OR+h0W4qNKr+bD1qbAvYg=;
        b=Ay7S7CCQbdzhZBLCdwkeD06CGkj+MP53DBiUWARPAh8c6J3ZiuM4uBLHw/x3H+yQRc
         M2lcpz48id8kFbn2Q+VT2KGFEUbzzyQugQ1VhEjIcFMqVylnjUzYAxj23n+Wt1bbXffG
         s3SUAGu5NBZPYf8MBoJaaDOOiJjxHC4Sy8N5u7NkDwHqiH1zhmwprN5RIZcHIFHNdviO
         o2hfvkJ41ohFuuxj055WQJvD664YvdL5VcWqw8HfIPVg4mplm1yWNpx47wjwnbXHCCQ5
         0uQUuzZUGlFsIhsTA3PNsRoMiE9iFFY1YebWiWvQzhZtBAyLj3SuHpBipKN6yYh5/6lv
         EVew==
X-Gm-Message-State: AOAM533X+sujfxxvh3K5rHntAzD7ViZYR8lQXSd7F4Fr3uk/ZVWMGEQK
        i0Q0NQUL7s/d5zku26QZi5tD5p24jpyCfoAAEm4=
X-Google-Smtp-Source: ABdhPJyodFOrJI4oLc1C/C4rRedqoN6plf3bs409xUgGZERJ+SJvDkuWUTmSr4NIm2KYhLj2VcBaOW7Yj7jSOflL9oc=
X-Received: by 2002:a05:6402:11cd:: with SMTP id j13mr27692873edw.116.1643917544641;
 Thu, 03 Feb 2022 11:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
In-Reply-To: <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Feb 2022 11:45:33 -0800
Message-ID: <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:17 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 3, 2022 at 10:53 AM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> >
> > Rather than having to perform all of these checkes would it maybe make
> > sense to add SKB_GSO_JUMBOGRAM as a gso_type flag? Then it would make
> > it easier for drivers to indicate if they support the new offload or
> > not.
>
> Yes, this could be an option.
>
> >
> > An added bonus is that it would probably make it easier to do something
> > like a GSO_PARTIAL for this since then it would just be a matter of
> > flagging it, stripping the extra hop-by-hop header, and chopping it
> > into gso_max_size chunks.
> >
> > > +}
> > > +
> > >  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
> > >  {
> > >       /* If forwarding is enabled, RA are not accepted unless the special
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 0118f0afaa4fce8da167ddf39de4c9f3880ca05b..53f17c7392311e7123628fcab4617efc169905a1 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -3959,8 +3959,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> > >       skb_frag_t *frag = skb_shinfo(head_skb)->frags;
> > >       unsigned int mss = skb_shinfo(head_skb)->gso_size;
> > >       unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
> > > +     int hophdr_len = sizeof(struct hop_jumbo_hdr);
> > >       struct sk_buff *frag_skb = head_skb;
> > > -     unsigned int offset = doffset;
> > > +     unsigned int offset;
> > >       unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
> > >       unsigned int partial_segs = 0;
> > >       unsigned int headroom;
> > > @@ -3968,6 +3969,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> > >       __be16 proto;
> > >       bool csum, sg;
> > >       int nfrags = skb_shinfo(head_skb)->nr_frags;
> > > +     struct ipv6hdr *h6;
> > >       int err = -ENOMEM;
> > >       int i = 0;
> > >       int pos;
> > > @@ -3992,6 +3994,23 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> > >       }
> > >
> > >       __skb_push(head_skb, doffset);
> > > +
> > > +     if (ipv6_has_hopopt_jumbo(head_skb)) {
> > > +             /* remove the HBH header.
> > > +              * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > > +              */
> > > +             memmove(head_skb->data + hophdr_len,
> > > +                     head_skb->data,
> > > +                     ETH_HLEN + sizeof(struct ipv6hdr));
> > > +             head_skb->data += hophdr_len;
> > > +             head_skb->len -= hophdr_len;
> > > +             head_skb->network_header += hophdr_len;
> > > +             head_skb->mac_header += hophdr_len;
> > > +             doffset -= hophdr_len;
> > > +             h6 = (struct ipv6hdr *)(head_skb->data + ETH_HLEN);
> > > +             h6->nexthdr = IPPROTO_TCP;
> > > +     }
> >
> > Does it really make the most sense to be doing this here, or should
> > this be a part of the IPv6 processing? It seems like of asymmetric when
> > compared with the change in the next patch to add the header in GRO.
> >
>
> Not sure what you mean. We do have to strip the header here, I do not
> see where else to make this ?

It is the fact that you are adding IPv6 specific code to the
net/core/skbuff.c block here. Logically speaking if you are adding the
header in ipv6_gro_receive then it really seems li:ke the logic to
remove the header really belongs in ipv6_gso_segment. I suppose this
is an attempt to optimize it though, since normally updates to the
header are done after segmentation instead of before.
