Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1928AA8E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgJKVBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbgJKVBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:01:15 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F41C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:01:15 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id d19so3872497vso.10
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EA8b2nCZfc6jy1iXSELplyBAeXS/MmTeCooRGf9uTQs=;
        b=p9bX2h1he3Th/5E+jtEKn9yIJg3lvxzTylictgFRJmywsOW07A5RKOh7oZC2A1spTG
         0jA8h1oS+mUy9B1EimFRmyOw1KV/Ue59Pydzg9ULlGhkcN7Losm3RNBxN4JycLkueMC3
         cFrDDBY5wEEFAvEeEcUq/WBhVCbmMRGtW/69/JQUVyTDhdI1vp4ErKe4ay8kJsX7tVcU
         F9gyqLAVWO1FA4veiAgrzXwKPddXGrNF67gU4dP4LEWHwwUKUcTu+fLN1N4eGLq/3RxG
         TQK9hu5YfLIDySiQOHyllELpc/hSknO4iq1k9FJxdzRG6THi5NqlHtaDhSgRotuHK3ay
         D5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EA8b2nCZfc6jy1iXSELplyBAeXS/MmTeCooRGf9uTQs=;
        b=kPyD/C6BmwvR1GK3z5Zn59YHZxghm+nGo+9JHaUxTLyb0sWWsBNg2gjgXAqI0HxjtQ
         mrP6XQ10+dO8J4VDLJR5ykNEZQf8b5ObROCJATJLN7WcxXodfRkoTBoYkivgYSftB6rs
         9S+SdZxWusA2ygagQZCxdg3SDfZzd4pLvv0YVu+hgodnKng2C8LdN9ja0FN8sYQ2bEnU
         NhC2V+UwzEiS+q/iTvjJE/lH4sCw7w0hckxUssTuGOUdXdSbNcLLg5ZBNYGmVxLzb4Q8
         f3/DCJy0lW+byEMqK4TMiXqFqhNw2JSaZzh9KPupE+Sj926swLJUMvesoYb1/FE4yD9C
         tiFg==
X-Gm-Message-State: AOAM532b/xpblb3GGJCcX1towrMUYj8Wb9sj4s89r1twJBumDhKPvSBv
        WJqr2dwIJZxbEPq8d9rCZNORah44Kzw=
X-Google-Smtp-Source: ABdhPJzToGIX0z/kdsjWcY/LXW3wI0M5Et3IN2XD07veI2yBJBAglCYIcR00l5lv9ViP+WUSpSM4xg==
X-Received: by 2002:a67:7dc4:: with SMTP id y187mr12113279vsc.58.1602450071942;
        Sun, 11 Oct 2020 14:01:11 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id 59sm1597595uag.13.2020.10.11.14.01.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 14:01:11 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id l6so7201209vsr.7
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:01:10 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr12555403vsr.13.1602450070044;
 Sun, 11 Oct 2020 14:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201011191129.991-1-xiyou.wangcong@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 11 Oct 2020 17:00:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
Message-ID: <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        Xie He <xie.he.0141@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 3:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> conditionally. When it is set, it assumes the outer IP header is
> already created before ipgre_xmit().
>
> This is not true when we send packets through a raw packet socket,
> where L2 headers are supposed to be constructed by user. Packet
> socket calls dev_validate_header() to validate the header. But
> GRE tunnel does not set dev->hard_header_len, so that check can
> be simply bypassed, therefore uninit memory could be passed down
> to ipgre_xmit(). Similar for dev->needed_headroom.
>
> dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create(), so it should be used whenever
> header_ops is set, and dev->needed_headroom should be used when it
> is not set.
>
> Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
> Cc: Xie He <xie.he.0141@gmail.com>
> Cc: William Tu <u9012063@gmail.com>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
> Note, there are some other suspicious use of dev->hard_header_len in
> the same file, but let's leave them to a separate patch if really
> needed.

There is agreement that hard_header_len should be the length of link
layer headers visible to the upper layers, needed_headroom the
additional room required for headers that are not exposed, i.e., those
pushed inside ndo_start_xmit.

The link layer header length also has to agree with the interface
hardware type (ARPHRD_..).

Tunnel devices have not always been consistent in this, but today
"bare" ip tunnel devices without additional headers (ipip, sit, ..) do
match this and advertise 0 byte hard_header_len. Bareudp, vxlan and
geneve also conform to this. Known exception that probably needs to be
addressed is sit, which still advertises LL_MAX_HEADER and so has
exposed quite a few syzkaller issues. Side note, it is not entirely
clear to me what sets ARPHRD_TUNNEL et al apart from ARPHRD_NONE and
why they are needed.

GRE devices advertise ARPHRD_IPGRE and GRETAP advertise ARPHRD_ETHER.
The second makes sense, as it appears as an Ethernet device. The first
should match "bare" ip tunnel devices, if following the above logic.
Indeed, this is what commit e271c7b4420d ("gre: do not keep the GRE
header around in collect medata mode") implements. It changes
dev->type to ARPHRD_NONE in collect_md mode.

Some of the inconsistency comes from the various modes of the GRE
driver. Which brings us to ipgre_header_ops. It is set only in two
special cases.

Commit 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address")
added ipgre_header_ops.parse to be able to receive the inner ip source
address with PF_PACKET recvfrom. And apparently relies on
ipgre_header_ops.create to be able to set an address, which implies
SOCK_DGRAM.

The other special case, CONFIG_NET_IPGRE_BROADCAST, predates git. Its
implementation starts with the beautiful comment "/* Nice toy.
Unfortunately, useless in real life :-)". From the rest of that
detailed comment, it is not clear to me why it would need to expose
the headers. The example does not use packet sockets.

A packet socket cannot know devices details such as which configurable
mode a device may be in. And different modes conflict with the basic
rule that for a given well defined link layer type, i.e., dev->type,
header length can be expected to be consistent. In an ideal world
these exceptions would not exist, therefore.

Unfortunately, this is legacy behavior that will have to continue to
be supported.

I agree that then swapping dev->needed_headroom for
dev->hard_header_len at init is then a good approach.

Underlying functions like ip_tunnel_xmit can modify needed_headroom at
runtime, not sure how that affects runtime changes in
ipgre_link_update:

"
        max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
                        + rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
        if (max_headroom > dev->needed_headroom)
                dev->needed_headroom = max_headroom;
"

>  net/ipv4/ip_gre.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 4e31f23e4117..82fee0010353 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -626,8 +626,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
>
>         if (dev->header_ops) {
>                 /* Need space for new headers */
> -               if (skb_cow_head(skb, dev->needed_headroom -
> -                                     (tunnel->hlen + sizeof(struct iphdr))))
> +               if (skb_cow_head(skb, dev->hard_header_len))
>                         goto free_skb;
>
>                 tnl_params = (const struct iphdr *)skb->data;
> @@ -748,7 +747,11 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
>         len = tunnel->tun_hlen - len;
>         tunnel->hlen = tunnel->hlen + len;
>
> -       dev->needed_headroom = dev->needed_headroom + len;
> +       if (dev->header_ops)
> +               dev->hard_header_len += len;
> +       else
> +               dev->needed_headroom += len;
> +
>         if (set_mtu)
>                 dev->mtu = max_t(int, dev->mtu - len, 68);
>
> @@ -944,6 +947,7 @@ static void __gre_tunnel_init(struct net_device *dev)
>         tunnel->parms.iph.protocol = IPPROTO_GRE;
>
>         tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
> +       dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
>
>         dev->features           |= GRE_FEATURES;
>         dev->hw_features        |= GRE_FEATURES;
> @@ -987,10 +991,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
>                                 return -EINVAL;
>                         dev->flags = IFF_BROADCAST;
>                         dev->header_ops = &ipgre_header_ops;
> +                       dev->hard_header_len = tunnel->hlen + sizeof(*iph);
> +                       dev->needed_headroom = 0;

here and below, perhaps more descriptive of what is being done, something like:

/* If device has header_ops.create, then headers are part of hard_header_len */
swap(dev->needed_headroom, dev->hard_header_len)

>                 }
>  #endif
>         } else if (!tunnel->collect_md) {
>                 dev->header_ops = &ipgre_header_ops;
> +               dev->hard_header_len = tunnel->hlen + sizeof(*iph);
> +               dev->needed_headroom = 0;
>         }
>
>         return ip_tunnel_init(dev);
> --
> 2.28.0
>
