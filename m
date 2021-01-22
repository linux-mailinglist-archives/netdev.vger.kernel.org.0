Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0F2FFAA3
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAVCtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbhAVCtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:49:07 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE98C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:48:27 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id v19so1845445vsf.9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u09ut0byqFUddeY2/rMH8bRUHh6CpXCKKgNy2e/b3Gc=;
        b=okIBxEfzYdSGyoEZS2A3lVJwCUTH5orhqvj09z5FuPM4BxAEPWjO6Xg28WscFQ8cch
         eCGdGpLVNc2fIsSLyqWNMGqUn4udZG37VD+C7kdnlQ1BXecm3H8y7icERAh5AytIFJSI
         Qjl+Fpok7/We4li7Yd3bcjDchOWvqZiL3JHJLZviTT9evbqNpbYvutIUGTozncSwJTJl
         CCGFzJPWIOng2MsB9P1h3LX0ewebl4vuHxv+MRFdHYYVYyd9Mo2BfA3CUlbEMiB+/n2a
         GAerCfQ0TuVY0/HPsuP5eGBhgxMLvJIJtpc7kEwVXeDUEsknWsT0yS6+buVD6n+eGHhv
         cAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u09ut0byqFUddeY2/rMH8bRUHh6CpXCKKgNy2e/b3Gc=;
        b=aYf7OJqqHbxDjAVbW83nyWoLEx1NCQaiC9jwn9nxz5UfOW3zGXWO1FcT1pkJEolpyp
         NG2WxH/7niHKu9GGkV/tTFlX2uRGPxedjj8nPXFl4j2YH9HYE9q6dgCkS6vWCfz04V72
         q0AeqqKhuoWazWXNjph9N3I8wBKtlBTdpXeQDIO2wfqmtkV9FwLwB9uthrdVEH7odp9V
         z+Tk/hoeYHS04d7EmfWYtY1H+HIqnTqa90PPnVw/NWQQq8lngaD+G6+5at5ixJEgTU2E
         RQv1HURsuNiI6HIUc5zac5dwB/H0eARo3aa0hJiR0JTtUQ3qc9h7XUkZ33CThexj6rVK
         hnUg==
X-Gm-Message-State: AOAM532W74rE83nFQ7j831EG/WU/F4s/Z/ZoyDYV3yr/KzVsPHUqPRuF
        hYY1pE4hHpNL1aLHesAlmdnQZaaeB2M=
X-Google-Smtp-Source: ABdhPJw5puWoL7FicPp27pEnI7siovjYKM29eFMinyy283RwuKBeDQ4T8j1Bar+UtiVZC8a+lzh73w==
X-Received: by 2002:a67:2c02:: with SMTP id s2mr763080vss.43.1611283705814;
        Thu, 21 Jan 2021 18:48:25 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id b20sm756107vsr.31.2021.01.21.18.48.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 18:48:24 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id w187so2274558vsw.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:48:24 -0800 (PST)
X-Received: by 2002:a67:cb1a:: with SMTP id b26mr1999163vsl.22.1611283703865;
 Thu, 21 Jan 2021 18:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20210118193122.87271-1-alobakin@pm.me> <20210118193232.87583-1-alobakin@pm.me>
 <20210118193232.87583-2-alobakin@pm.me>
In-Reply-To: <20210118193232.87583-2-alobakin@pm.me>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 21 Jan 2021 21:47:47 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeZu6Z0eQ20Fwhr6DmraV1a90vMb1LQcwLxesD04LXGgw@mail.gmail.com>
Message-ID: <CA+FuTSeZu6Z0eQ20Fwhr6DmraV1a90vMb1LQcwLxesD04LXGgw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] udp: allow forwarding of plain
 (non-fraglisted) UDP GRO packets
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 2:33 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
> not only added a support for fraglisted UDP GRO, but also tweaked
> some logics the way that non-fraglisted UDP GRO started to work for
> forwarding too.
> Commit 2e4ef10f5850 ("net: add GSO UDP L4 and GSO fraglists to the
> list of software-backed types") added GSO UDP L4 to the list of
> software GSO to allow virtual netdevs to forward them as is up to
> the real drivers.
>
> Tests showed that currently forwarding and NATing of plain UDP GRO
> packets are performed fully correctly, regardless if the target
> netdevice has a support for hardware/driver GSO UDP L4 or not.
> Plain UDP GRO forwarding even shows better performance than fraglisted
> UDP GRO in some cases due to not wasting one skbuff_head per every
> segment.

That is surprising. The choice for fraglist based forwarding was made
on the assumption that it is cheaper if software segmentation is needed.

Do you have a more specific definition of the relevant cases?

There currently is no option to enable GRO for forwarding, without
fraglist if to a device with h/w udp segmentation offload. This would
add that option too.

Though under admin control, which may make it a rarely exercised option.
Assuming most hosts to have single or homogeneous NICs, the OS should
be able to choose the preferred option in most cases (e.g.,: use fraglist
unless all devices support h/w gro).

> Add the last element and allow to form plain UDP GRO packets if
> there is no socket -> we are on forwarding path, and the new
> NETIF_F_GRO_UDP is enabled on a receiving netdevice.
> Note that fraglisted UDP GRO now also depends on this feature, as

That may cause a regression for applications that currently enable
that device feature.

> NETIF_F_GRO_FRAGLIST isn't tied to any particular L4 protocol.
>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/ipv4/udp_offload.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94781bf..781a035de5a9 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -454,13 +454,19 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>         struct sk_buff *p;
>         struct udphdr *uh2;
>         unsigned int off = skb_gro_offset(skb);
> -       int flush = 1;
> +       int flist = 0, flush = 1;
> +       bool gro_by_feat = false;

What is this variable shorthand for? By feature? Perhaps
gro_forwarding is more descriptive.

>
> -       NAPI_GRO_CB(skb)->is_flist = 0;
> -       if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> -               NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
> +       if (skb->dev->features & NETIF_F_GRO_UDP) {
> +               if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> +                       flist = !sk || !udp_sk(sk)->gro_enabled;
>
> -       if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {

I would almost rename NETIF_F_GRO_FRAGLIST to NETIF_F_UDP_GRO_FWD.
Then this could be a !NETIF_F_UDP_GRO_FWD_FRAGLIST toggle on top of
that. If it wasn't for this fraglist option also enabling UDP GRO to
local sockets if set.

That is, if the performance difference is significant enough to
require supporting both types of forwarding, under admin control.

Perhaps the simplest alternative is to add the new feature without
making fraglist dependent on it:

  if ((sk && udp_sk(sk)->gro_enabled) ||
      (skb->dev->features & NETIF_F_GRO_FRAGLIST) ||
      (!sk && skb->dev->features & NETIF_F_GRO_UDP_FWD))






> +               gro_by_feat = !sk || flist;
> +       }
> +
> +       NAPI_GRO_CB(skb)->is_flist = flist;
> +
> +       if (gro_by_feat || (sk && udp_sk(sk)->gro_enabled)) {
>                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
>                 return pp;
>         }
> --
> 2.30.0
>
>
