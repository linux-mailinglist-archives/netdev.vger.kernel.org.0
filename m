Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAAC31BE2D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhBOQCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhBOPtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:49:55 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE67C061794
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:48:51 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id l3so8188875oii.2
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8xERENugrCSuCZiAv8INblQCgyFu+lZ9sSN5Nlu3p4=;
        b=e7Fx6sRRteghO4BBlAs+15v1Y8az5khDmNS+b1+ofZ9KFeDFVj+oBBhtL+RkZVRSD1
         cWEg5bKJKfbiu7bNuPJed4yvWgV5NbR+1fEd521USp0fZ7KbhEMxVP2jC/FeJ06DBTGb
         AsX2Cvy6kW/uOqG6pf/rCwwBNsKW8pGNFRIa9Uf/iNwvRF6irD+nKVgLrD0JWSP8jTsR
         GD+KoxvISdZbnK68SoWOiaTsGMwv0377TsNq9eVJ72MmH73bdRgYaWeSFHp2vvROxOtl
         hp571Ul5ZDzwEsmXbsFhXhM5/SSUIEPgOK1dYNeqvrwUYb6iVvGIZ/D8beGtSILQCE//
         18Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8xERENugrCSuCZiAv8INblQCgyFu+lZ9sSN5Nlu3p4=;
        b=EPUMu+g16yYD7MQpn2K1MTElpYpb283RQf7OxWlPpA7lQP+B7zfaCL0MxbHzUG4jVz
         RSwDe9eUD3fkz5TfQojkIlYyK8nh5hkse6VhZ/rRot1tE4MjJ3q6dDDs7oZxCzpj5G/y
         XfnaBNjJ5yRh0OVIjS6QhyHnpfvCquIuMpJl17dpQniciHtFYiXS0NoACAXbI4Knmsv5
         jkBJ77+oMyuWiXWhWsmK5aJEB8VR7bPBoKgCnXAFQRxRM+aK5aJg2Z6e2DyI6BxBhBmU
         Xr05WJ2/NEXa2JBimYIJ+tVhEVzWtwtTvOFjMMHkq8XrB5+fLbL77LZVMyQe0jbalP9b
         ypxg==
X-Gm-Message-State: AOAM532pC2hts1w1MdcVDvruUEnIihXaXvi2it04al46kCbLkxtp9KV9
        PBYSlanGlXlvV25rjgYKIn0efPGr3HAQeSR2Jg==
X-Google-Smtp-Source: ABdhPJzzXJw/P9Eo4dSx0r2HOR33GjA57IkIwFrpZaNOwG0/UpQPlmx4pWaHVbK9NceNW4F8o8grMmJqV4yT5bhbcFs=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr8872382oiw.92.1613404130490;
 Mon, 15 Feb 2021 07:48:50 -0800 (PST)
MIME-Version: 1.0
References: <20210214155326.1783266-1-olteanv@gmail.com> <20210214155326.1783266-5-olteanv@gmail.com>
In-Reply-To: <20210214155326.1783266-5-olteanv@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 15 Feb 2021 09:48:38 -0600
Message-ID: <CAFSKS=OryZKixT7d-7tqdwZCpqQT1PaYCt52PuZYr71F3a1gSg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: don't set skb->offload_fwd_mark
 when not offloading the bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 9:54 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[snip]
> diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> index 858cdf9d2913..215ecceea89e 100644
> --- a/net/dsa/tag_xrs700x.c
> +++ b/net/dsa/tag_xrs700x.c
> @@ -45,8 +45,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
>         if (pskb_trim_rcsum(skb, skb->len - 1))
>                 return NULL;
>
> -       /* Frame is forwarded by hardware, don't forward in software. */
> -       skb->offload_fwd_mark = 1;
> +       dsa_default_offload_fwd_mark(skb);

Does it make sense that the following would have worked prior to this
change? Is this only an issue for bridging between DSA ports when
offloading is supported? lan0 is a port an an xrs700x switch:

ip link set eth0 up
ip link del veth0
ip link add veth0 type veth peer name veth1

for eth in veth0 veth1 lan1; do
    ip link set ${eth} up
done
ip link add br0 type bridge
ip link set veth1 master br0
ip link set lan1 master br0
ip link set br0 up

ip addr add 192.168.2.1/24 dev veth0

# ping host connected to physical LAN that lan0 is on
ping 192.168.2.249 (works!)

I was trying to come up with a way to test this change and expected
this would fail (and your patch) would fix it based on what you're
described.

-George

>
>         return skb;
>  }
> --
> 2.25.1
>
