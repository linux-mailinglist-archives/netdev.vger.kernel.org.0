Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451B02AC515
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgKITic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKITib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:38:31 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4273CC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 11:38:30 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id x7so9411944ili.5
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 11:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k8+EMc4+ZzXJqSUvzL7W5Ni2fcnDgXtP+EcVau6OBrM=;
        b=QPGXaCvVRB4KlRGmWhDbpfdbGn0ZC8kDinWCv2x+JjrJI6PBwoifTda0X4VKf0rNxQ
         G5f1FH27nqN/xBqw4zPvuraKnoNs0119PH5Heq2ppu/7EDCFk0nx0e/UQH7St5Jyp2Y+
         HIUq6T9oY6yloWEntf74siPKEd6n/qnVKbzM0A/ZiDBKevfaRPikMMkh3VtAfnmFEr3v
         B1M9cwtK8iHS0GXtivOLEs9X4osprzrKbe5U54/Vs4hicBCtMTmZVDx0rWX9QXher2ip
         pM6IrJuAtFPR717tRAZeWwiPNDB8Mb2uK6IhnaEJl1n+zPiUdkYuxf5yNEiL5w5T2gkH
         JhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8+EMc4+ZzXJqSUvzL7W5Ni2fcnDgXtP+EcVau6OBrM=;
        b=tjuDqE2IuQqdg0fBsiGpfqpc9pN1cHu7i9fkjtDBbvhmNjHRTRHetDJNyhnsyGttC3
         6yFxlUJeG2LZ3bA/pgvXM9JEyLBiqIH/5+gPFVNfRmd5HinjIlX87/RogBVkom6pyHv7
         Gs1uxo2Fqra/c/vMLJVwWp1JAIKrtEPvQ3lQ76yznqzCElcRa9YqYqzHrx8LNDq85Sq6
         FKGw0n7eO8l5aqp3PUbQrW/eukYDae3m8EjdUDtDoDRs0jJMtVKx1Cuu9TmXuBI7eYlD
         l4w7ZJ79byDL59UaUX7omYaUe+hvqSFxexpktUtgsInm8CcnFMJSIVyGhVBh10YTJAND
         eGfQ==
X-Gm-Message-State: AOAM531+SCFqHIoqjF/rvZTnvlYcU3NFFuRQwtj8tuBujOnfOYuWG5Ok
        aBAq4LwChATDIvCuzN/E6LYGVEKz07wgTmGcIWRc9A==
X-Google-Smtp-Source: ABdhPJw0MeG4P26hzsMF6D4SWQfdhHemZQG3avMmoyM+7Vf54D1B9HL4wVsscgX4reE8l0z4nuZgBbBlWbHxr9kgPTQ=
X-Received: by 2002:a92:9e8b:: with SMTP id s11mr10932147ilk.61.1604950709307;
 Mon, 09 Nov 2020 11:38:29 -0800 (PST)
MIME-Version: 1.0
References: <20200909062613.18604-1-lina.wang@mediatek.com>
 <20200915073006.GR20687@gauss3.secunet.de> <CAKD1Yr1VsueZWUtCL4iMWLhnADypUOtDK=dgqM2Y2HDvXc77iw@mail.gmail.com>
 <20201109095813.GV26422@gauss3.secunet.de>
In-Reply-To: <20201109095813.GV26422@gauss3.secunet.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 9 Nov 2020 11:38:16 -0800
Message-ID: <CANP3RGfuOGoB1msF1evzsgKf5qZZbNDCHDzvgPBHRGyepDuu+g@mail.gmail.com>
Subject: Re: [PATCH] xfrm:fragmented ipv4 tunnel packets in inner interface
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lorenzo Colitti <lorenzo@google.com>,
        mtk81216 <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 1:58 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Thu, Nov 05, 2020 at 01:52:01PM +0900, Lorenzo Colitti wrote:
> > On Tue, Sep 15, 2020 at 4:30 PM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > > > In esp's tunnel mode,if inner interface is ipv4,outer is ipv4,one big
> > > > packet which travels through tunnel will be fragmented with outer
> > > > interface's mtu,peer server will remove tunnelled esp header and assemble
> > > > them in big packet.After forwarding such packet to next endpoint,it will
> > > > be dropped because of exceeding mtu or be returned ICMP(packet-too-big).
> > >
> > > What is the exact case where packets are dropped? Given that the packet
> > > was fragmented (and reassembled), I'd assume the DF bit was not set. So
> > > every router along the path is allowed to fragment again if needed.
> >
> > In general, isn't it just suboptimal to rely on fragmentation if the
> > sender already knows the packet is too big? That's why we have things
> > like path MTU discovery (RFC 1191).
>
> When we setup packets that are sent from a local socket, we take
> MTU/PMTU info we have into account. So we don't create fragments in
> that case.
>
> When forwarding packets it is different. The router that can not
> TX the packet because it exceeds the MTU of the sending interface
> is responsible to either fragment (if DF is not set), or send a
> PMTU notification (if DF is set). So if we are able to transmit
> the packet, we do it.
>
> > Fragmentation is generally
> > expensive, increases the chance of packet loss, and has historically
> > caused lots of security vulnerabilities. Also, in real world networks,
> > fragments sometimes just don't work, either because intermediate
> > routers don't fragment, or because firewalls drop the fragments due to
> > security reasons.
> >
> > While it's possible in theory to ask these operators to configure
> > their routers to fragment packets, that may not result in the network
> > being fixed, due to hardware constraints, security policy or other
> > reasons.
>
> We can not really do anything here. If a flow has no DF bit set
> on the packets, we can not rely on PMTU information. If we have PMTU
> info on the route, then we have it because some other flow (that has
> DF bit set on the packets) triggered PMTU discovery. That means that
> the PMTU information is reset when this flow (with DF set) stops
> sending packets. So the other flow (with DF not set) will send
> big packets again.

PMTU is by default ignored by forwarding - because it's spoofable.

That said I wonder if my recent changes to honour route mtu (for ipv4)
haven't fixed this particular issue in the presence of correctly
configured device/route mtus...

I don't understand if the problem here is locally generated packets,
or forwarded packets.

It does seem like there is (or was) a bug somewhere... but it might
already be fixed (see above) or might be caused by a misconfiguration
of device mtu or routing rules.

I don't really understand the example.

>
> > Those operators may also be in a position to place
> > requirements on devices that have to use their network. If the Linux
> > stack does not work as is on these networks, then those devices will
> > have to meet those requirements by making out-of-tree changes. It
> > would be good to avoid that if there's a better solution (e.g., make
> > this configurable via sysctl).
>
> We should not try to workaround broken configurations, there are just
> too many possibilities to configure a broken network.
