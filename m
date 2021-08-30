Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9A3FBE0C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbhH3VXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhH3VXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:23:18 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF06C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:22:24 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id g14so74784ljk.5
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZrNJ6h5hmI27C2Xkk2J51RyITJq+u6Df453g84lcy4=;
        b=I2V60Z/MEZgf9DNBZx37Apl2tFIwHEK0hXY+doGJcyGAUmhIxmnLKLYifiRfLamJnb
         lBoaJSngqZI21Q9LOq4cMlYgypo1LgBsBb6JMP25eruRirrfTMWNVIrtSbjEusVtMQBv
         Hp/NUhYwoiHKsODDTmha4oGbQDRW1xxTUrct9mx1L/lnrQj6Keh6Ii/2en7VlgNfutYb
         zC87wOpnpX64bn/izWxYcOSC6G/FuZ7Amv5IN/1AE4J/mDWGDZtTS8CGEZd3wxo9sB1B
         bCMkZbh+BU6/U9bQw0dswQbGgnb8QmfIueWFGbBzbdRU216EyO211Pmo96ezjTEffUIj
         o2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZrNJ6h5hmI27C2Xkk2J51RyITJq+u6Df453g84lcy4=;
        b=iQ2+1DchqAioJqgtdXuZxENeC1Omvm+JtUOrYh1zVKzNo/OPw+cCPbUyf0hdEm4k0f
         f2EulZ4+juwDB+8la20e9F12jMOnaD7LaCejqqqq8q8gIOVQLETBAlcDyek6ikHI4hs6
         k7eVvRPbl1GFdcB2KVQ3ZU4X0i6mEL8J635/0R/ENtGHotX+RYr2dS01PIhZa3sEDWki
         Hj+X5k0LPD2JDt6pGQvYrUl1XGaHx2I/UFo9kLySy05rMfucANWyQb76wNd21VK4m8B5
         Yw1aYo4qkx/kp+adz5HT2UaEtwUGKoLOfTauz+NmzKL44yl/BrOv5ujos8jgpYCpYCFI
         AfHg==
X-Gm-Message-State: AOAM533GKT8PiOBoCCt7jeohEeo52X4KmGtmiFtjR9ZDbouOcfu1WSrr
        +MaaTESxfgPbXI1a711r0rNMWTxKF9CPDU1TRjw8Og==
X-Google-Smtp-Source: ABdhPJxz8mPf8m22TkAWlMVUBbjeRUoQJf+JRGL8AgxbKurvXcbMf8b7R1Tzhqlcd5AP/kqAi/4ZaRTn/wWyEObbPdc=
X-Received: by 2002:a2e:89c1:: with SMTP id c1mr22379557ljk.273.1630358542612;
 Mon, 30 Aug 2021 14:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210829002601.282521-1-linus.walleij@linaro.org> <20210830081254.osqvwld7w7jk7jap@skbuf>
In-Reply-To: <20210830081254.osqvwld7w7jk7jap@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 30 Aug 2021 23:22:11 +0200
Message-ID: <CACRpkdZE7i1h1vPTJz+QwkDdBiVg1tF+uxhaOATZGZctkWy+Ag@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rtl8366rb: support bridge offloading
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> > +/* Port isolation registers */
> > +#define RTL8366RB_PORT_ISO_BASE              0x0F08
> > +#define RTL8366RB_PORT_ISO(pnum)     (RTL8366RB_PORT_ISO_BASE + (pnum))
> > +#define RTL8366RB_PORT_ISO_EN                BIT(0)
> > +#define RTL8366RB_PORT_ISO_PORTS_MASK        GENMASK(7, 1)
>
> If RTL8366RB_NUM_PORTS is 6, then why is RTL8366RB_PORT_ISO_PORTS_MASK a
> 7-bit field?

It's a 6 bit field actually from bit 1 to bit 7 just shifted up one
bit because bit 0 is "enable".

> > +     /* Isolate all user ports so only the CPU port can access them */
> > +     for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> > +             ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> > +                                RTL8366RB_PORT_ISO_EN |
> > +                                BIT(RTL8366RB_PORT_NUM_CPU + 1));
>
> The shifting due to RTL8366RB_PORT_ISO_EN looks weird, I can see it
> being mishandled in the future, with code moved around, copied and
> pasted between realtek drivers and such. How about making a macro
>
> #define RTL8366RB_PORT_ISO_PORTS(x)     ((x) << 1)

OK

> > +     /* CPU port can access all ports */
>
> Except itself maybe? RTL8366RB_PORT_NUM_CPU is 5, so maybe use something
> like
>
> RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds))

Tested this and it appears to work just fine!

> Looks okay for the most part. It is to be expected for a new driver that
> introduces bridging offload to also handle .port_pre_bridge_flags,
> .port_bridge_flags and .port_fast_age, for two reasons:
> (a) it is expected that a port which does not offload the bridge, and
>     performs forwarding in software, to not perform address learning in
>     hardware
> (b) it is expected that the addresses learned while the port was under a
>     bridge are not carried over into its life as a standalone port, when
>     it leaves that bridge

I studied the vendor code drop and register file and implemented
the BR_LEARNING flag, and I also managed to implement fast aging.
Each as a separate patch. Thanks for pointing this out!

> Also, it would be nice if you could do some minimal isolation at the
> level of the FDB lookup. Currently, if I am not mistaken, a port will
> perform FDB lookup even if it is standalone, and it might find an FDB
> entry for a given {MAC DA, VLAN ID} pair that belongs to a port outside
> of its isolation mask, so forwarding will be blocked and that packet
> will be dropped (instead of the expected behavior which is for that
> packet to be forwarded to the CPU).
>
> Normally the expectation is that this FDB-level isolation can be achieved
> by configuring the VLANs of one bridge to use a filter ID that is
> different from the VLANs of another bridge, and the port-based default
> VLAN of standalone ports to use yet another filter ID. This is yet
> another reason to disable learning on standalone ports, so that their
> filter ID never contains any FDB entry, and packets are always flooded
> to their only possible destination, the CPU port.
>
> Currently in DSA we do not offer a streamlined way for you to determine
> what filter ID to use for a certain VLAN belonging to a certain bridge,
> but at the very least you can test FDB isolation between standalone
> ports and bridged ports. The simplest way to do that, assuming you
> already have a forwarding setup with 2 switch ports swp0 and swp1, is to
> enable CONFIG_BONDING=y, and then:
>
> ip link add br0 type bridge
> ip link set bond0 master br0
> ip link set swp1 master bond0
> ip link set swp0 master br0
>
> Then ping between station A attached to swp0 and station B attached to
> swp1.
>
> Because swp1 cannot offload bond0, it will fall back to software
> forwarding and act as standalone, i.e. what you had up till now.
> With hardware address learning enabled on swp0 (a port that offloads
> br0), it will learn station A's source MAC address. Then when swp1 needs
> to send a packet to station A's destination MAC address, it would be
> tempted to look up the FDB, find that address, and forward to swp0. But
> swp0 is isolated from swp1. If you use a filter ID for standalone ports
> and another filter ID for bridged ports you will avoid that problem, and
> you will also lay the groundwork for the full FDB isolation even between
> bridges that will be coming during the next development cycle.
>
> If you feel that the second part is too much for now, you can just add
> the extra callbacks for address learning and flushing (although I do
> have some genuine concerns about how reliable was the software forwarding
> with this driver, seeing that right now it enables hardware learning
> unconditionally). Is there something that isolates FDB lookups already?

Ugh that was massive, I'm not that smart ;)

I kinda understand it but have no idea how to achieve this with
the current hardware, driver and vendor code mess.

I prefer to fix the first part for now.

Yours,
Linus Walleij
