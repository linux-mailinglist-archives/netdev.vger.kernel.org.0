Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396F84A9220
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356556AbiBDBsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356559AbiBDBsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:48:22 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B55C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 17:48:21 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c6so14550901ybk.3
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 17:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eO/Yv5qQrdBE01Thm6N82vcfoHAYxSRFVJ6ytFlVh98=;
        b=bN0FeXYKsl/qAVfVdYepY2iwr7GByTl+E+kyGf2ldtQ5BI/QZboFM5XNbAW+E+JcPO
         T3cm/UkFe1vutORxuA3d0n2Zb9IVZI6SeMufwm4rgAs3nEJf2MwZWNaIz/PJhebz1tyF
         6OAFldGn1XBgN6u645hvUy6SHIZtt7x9Ura4i1xkLZY8qRK1ZaDo/XKqLyw+BvJZs8fn
         U2Ydxm6+A1mrCZY+3PylI6EV2UDZEoR5Y/lR/Rv3X7M4QNhuFgBNKzPsAry16jY99we5
         eLiUJc/rvZhVcUVlLIESCzb51VbQkRpzPFe/hbPZjEnOvUaZkn2cLZtY+y8BUE/YLjjc
         WXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eO/Yv5qQrdBE01Thm6N82vcfoHAYxSRFVJ6ytFlVh98=;
        b=M9s//JRHD1iVrPWJgmGwEiW2gTu1B164LRmYpPwicKTO9cLN+oaKMGu4QMrwV1kX6i
         4DVbalvqzxFEQVHgvsGrliC2fzKO79GeIfSaT07yHOi/uHCbTZShU29CDbJ+acyG/c23
         ucF4Qfh9KpBw39LAbqV07VIB+gFxMhbIo5Mt8pc683pafjz94UGNSX8J8HSTikR7HTdl
         MVxrhXc3r9stuGHA4yHu4NhJ7Ovv4e+UMmXmYM+/zpv9RetiWf8KzkbSkzJCvjGj/xR3
         JyOHa0Tz3fAvjqo8ebEP5x96jQZTwwyLlVJNvSt6CI9v5YxAZWPfvfvMzqySVD4Fh8b9
         iEeg==
X-Gm-Message-State: AOAM530MFPp9O/sUw4IRbj0OrEN65H5zOj1yMqxEtJvgiVioWn3ddi2a
        cGPY/vM6QL+Zu8XeGHKccIiAiywP+ZDxgPfrlSPlJA==
X-Google-Smtp-Source: ABdhPJx1spZfE5nqdC+lw8ubUrED01acuIQWnFrhqiWP50Bs/5e8P8lUPZEllF23LpJhskb4/lszcgua8CuICUMStv0=
X-Received: by 2002:a25:3444:: with SMTP id b65mr903332yba.5.1643939300575;
 Thu, 03 Feb 2022 17:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
 <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
 <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
 <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com>
 <CANn89iLkx34cnAJboMdRSbQz63OnD7ttxnEX6gMacjWdEL+7Eg@mail.gmail.com> <CANn89iJjwuN6hv7CuvR3n5efwo4MjV+Xe2byK7wy4k0AXkJkzg@mail.gmail.com>
In-Reply-To: <CANn89iJjwuN6hv7CuvR3n5efwo4MjV+Xe2byK7wy4k0AXkJkzg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 17:48:09 -0800
Message-ID: <CANn89i+LgmKzDCuLZ+5NZu84CHtKAvmTW+=bYRkX5NLjAqXkNA@mail.gmail.com>
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

On Thu, Feb 3, 2022 at 5:14 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 3, 2022 at 4:27 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Feb 3, 2022 at 4:05 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> >
> > > I get that. What I was getting at was that we might be able to process
> > > it in ipv6_gso_segment before we hand it off to either TCP or UDP gso
> > > handlers to segment.
> > >
> > > The general idea being we keep the IPv6 specific bits in the IPv6
> > > specific code instead of having the skb_segment function now have to
> > > understand IPv6 packets. So what we would end up doing is having to do
> > > an skb_cow to replace the skb->head if any clones might be holding on
> > > it, and then just chop off the HBH jumbo header before we start the
> > > segmenting.
> > >
> > > The risk would be that we waste cycles removing the HBH header for a
> > > frame that is going to fail, but I am not sure how likely a scenario
> > > that is or if we need to optimize for that.
> >
> > I guess I can try this for the next version, thanks.
>
> I came up with:
>
> ommit 147f17169ccc6c2c38ea802e5728528ed54f492d
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Sat Nov 20 16:49:35 2021 -0800
>
>     ipv6/gso: remove temporary HBH/jumbo header
>
>     ipv6 tcp and gro stacks will soon be able to build big TCP packets,
>     with an added temporary Hop By Hop header.
>
>     If GSO is involved for these large packets, we need to remove
>     the temporary HBH header before segmentation happens.
>
>     v2: perform HBH removal from ipv6_gso_segment() instead of
>         skb_segment() (Alexander feedback)
>
>     Signed-off-by: Eric Dumazet <edumazet@google.com>


Well, this does not work at all.




>  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
>  {
>         /* If forwarding is enabled, RA are not accepted unless the special
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index d37a79a8554e92a1dcaa6fd023cafe2114841ece..7f65097c8f30fa19a8c9c265eb4f027e91848021
> 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -87,6 +87,27 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
>         bool gso_partial;
>
>         skb_reset_network_header(skb);
> +       if (ipv6_has_hopopt_jumbo(skb)) {
> +               const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> +               int err;
> +
> +               err = skb_cow_head(skb, 0);
> +               if (err < 0)
> +                       return ERR_PTR(err);
> +
> +               /* remove the HBH header.
> +                * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +                */
> +               memmove(skb->data + hophdr_len,
> +                       skb->data,
> +                       ETH_HLEN + sizeof(struct ipv6hdr));
> +               skb->data += hophdr_len;
> +               skb->len -= hophdr_len;
> +               skb->network_header += hophdr_len;
> +               skb->mac_header += hophdr_len;
> +               ipv6h = (struct ipv6hdr *)skb->data;
> +               ipv6h->nexthdr = IPPROTO_TCP;
> +       }
>         nhoff = skb_network_header(skb) - skb_mac_header(skb);
>         if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
>                 goto out;
