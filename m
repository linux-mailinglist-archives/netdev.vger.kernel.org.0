Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D228738F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgJHLtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHLtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:49:20 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48E1C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 04:49:19 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id u74so2875648vsc.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 04:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j478tL9uSphQq1TvChx1R1NBjx64ACTnjONxY65DT6A=;
        b=RqwXhoXa9slVJBS/4vL1H/4fNwO9WZeZJoYZ0TarJ+SOchrolLUBaI5ZlSE/xXMHty
         +qKJ2DYUS5oZTJZMzimMg3CDIm+Az9adAPJiJkCE1Thj472heZAl5UGHUG1gqfvQeTj7
         Ry4Tj09Y+VqtVuwF0K0uinSlTsqkVdgm4tTsO68di9uaFeQkJ+WW7mS1CZwzk/2QwVSD
         9Gy1CL0Udmr60C8mKvojSRTRZpbtc9N9OKByDpvkXn70frjkmjODm2+AVmYf7vulthMG
         bPpD2vY7os9r5P90qky4Wnpb4idpl9XMECB8Zk23/vAZ9G/+yHMU4D7b2XSsgTSd+ZJh
         tfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j478tL9uSphQq1TvChx1R1NBjx64ACTnjONxY65DT6A=;
        b=TTlGYHkmB1dB590j0Y1YXTN1VfBHP7fuvb+jCKVezvgwMt8pkktOSD74vCc0bfIaTK
         iG4+8XmFOXkWlH5dxQ5o/nyVpdWK2ADWOnWNbt6Kd4BqGgk+lUFIIn9dcKLm2Ch56O/b
         IhETrEblTNbxiAFhfG72/+gakgWhRrSohlGVo4cqXpBfIdueymdvInHCxxBqjwkSOoPb
         wC5gAFJ7cBdadPBJISmtjAWTD9pK4BwRclVE2neBNvDGv319gcePydyXECQacSXPswDM
         XjmuLoLiuk0H1Wl35I7uUNizUd+ljfcM+u0orc84hlamdw8X3fOL29Z98nRd4m3zyKb+
         ksdg==
X-Gm-Message-State: AOAM530Fk7kHcDDojL5rkkyGocQhwd6y1D6YKC1uUw25+8D3GVIKMm8k
        5CGXUmVa09YKK483IVRsD1TMbBF56ls=
X-Google-Smtp-Source: ABdhPJyIHXslum4f/TgM9DVBM9eQH9KmDtOhvh8u2vLyNlCk7U+AHrrMs4PctLhkVWYNZdc2O3HDiw==
X-Received: by 2002:a05:6102:2c1:: with SMTP id h1mr4509249vsh.3.1602157758434;
        Thu, 08 Oct 2020 04:49:18 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id 93sm257412uah.19.2020.10.08.04.49.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 04:49:17 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id x185so2887088vsb.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 04:49:17 -0700 (PDT)
X-Received: by 2002:a67:8a8a:: with SMTP id m132mr4148508vsd.14.1602157756834;
 Thu, 08 Oct 2020 04:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 07:48:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
Message-ID: <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>, Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
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
> to ipgre_xmit().

If dev->hard_header_len is zero, the packet socket will not reserve
room for the link layer header, so skb->data points to network_header.
But I don't see any uninitialized packet data?

> Fix this by setting dev->hard_header_len whenever sets header_ops,
> as dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create() anyway.

Agreed. Xie has made similar changes to lapbether recently in
commit c7ca03c216ac.

> Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
> Cc: William Tu <u9012063@gmail.com>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/ipv4/ip_gre.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 4e31f23e4117..43b62095559e 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -987,10 +987,12 @@ static int ipgre_tunnel_init(struct net_device *dev)
>                                 return -EINVAL;
>                         dev->flags = IFF_BROADCAST;
>                         dev->header_ops = &ipgre_header_ops;
> +                       dev->hard_header_len = tunnel->hlen + sizeof(*iph);
>                 }
>  #endif
>         } else if (!tunnel->collect_md) {
>                 dev->header_ops = &ipgre_header_ops;
> +               dev->hard_header_len = tunnel->hlen + sizeof(*iph);

Unrelated to this patch, I do wonder if ipgre_header does the
right thing when tunnel->hlen > sizeof(gre_base_hdr),
i.e., for gre tunnels with optional fields.

Currently it appears to not initialize those.

>         }
>
>         return ip_tunnel_init(dev);
> --
> 2.28.0
>
