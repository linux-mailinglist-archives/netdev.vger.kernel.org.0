Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A260C3FBEAA
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhH3WC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhH3WCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:02:52 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F7AC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:01:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i6so24523918wrv.2
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g50b/ChqVO/AoG9MSt9xmdUtQJMekm/FqdI8TUdPc4U=;
        b=FU9wS92QkEGH5qUMXbzGoN7BBcsPjS2fZFnj5CU32t1HCH2obNpoxZ7j3K5lsG3LMF
         V4qGbzXa5W3lEzLOFg+/dE2Sn9yEFpwt4IsKGWuhhIfZK02GWZofrc5lrSbBmhnWqSLG
         lCtcPYKDKIb8prjBus6ax9u9WVwomEsqSHuJ179zYoUFeHsZDoKSC1mfr3A4VHc5Y2uy
         SDvGrSyvMaqa59rifga8XzRivqnQG7EUkE4TKH2rSSZwzyk+kmgDyQNFZcMmLzkIsJ7G
         B2qUYCEoLEtrgb+1FnVw0CqnbQEHIV/DzGyCA9KH7SB2vZE4gs6DDComCLof6m9bK5uz
         qY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g50b/ChqVO/AoG9MSt9xmdUtQJMekm/FqdI8TUdPc4U=;
        b=I3KhiHq9egtqR25f+BwrVCSZK5fW3Slz/nr+l2g9tL922CTb9lLDn5pQs5/zL+QThS
         zzoCRabk3Cya+D2z8JEGzF2drMziPiajzrYbSEFmJiyDVl/C0z+IAUBATcbsx27jDZw2
         Uu25IlaOh1wxEZmRvLFyXgSwK3Nhr/HKHxpV2gIMJVvEPzspE4Ykc1LCoYGW/jZrifNQ
         z3140iZL/RMP6rYozJTbWyoEivFkHlAJgQFHhmcIOTpa8Duv+pb/gnD9yFlZL+9TMxaq
         lmu4xn8aFctISU9bfSbAcesyTcQD2H8y8Pd0c56x0I2TTYtvlfy8rxIIid7JeM8+fAEe
         0aHQ==
X-Gm-Message-State: AOAM530OJr4U6hle7OP1whzJqM48W5b8Ls5p7xT93xGm+WXdn2Xa2HEs
        tdOuIj9dBp6Zu9bp6ZXQlsM=
X-Google-Smtp-Source: ABdhPJwDhA68uqZOJ4vPLjAgrwDE/JlYth+DnDvFHmoX2NWskUIo1xxZPIFEBNZrvS5PZMS7Fk0ZBA==
X-Received: by 2002:adf:dc8a:: with SMTP id r10mr27027351wrj.371.1630360917232;
        Mon, 30 Aug 2021 15:01:57 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id t64sm629306wma.48.2021.08.30.15.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:01:56 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:01:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rtl8366rb: support bridge
 offloading
Message-ID: <20210830220155.5nbtm6khoivend6f@skbuf>
References: <20210829002601.282521-1-linus.walleij@linaro.org>
 <20210830081254.osqvwld7w7jk7jap@skbuf>
 <CACRpkdZE7i1h1vPTJz+QwkDdBiVg1tF+uxhaOATZGZctkWy+Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZE7i1h1vPTJz+QwkDdBiVg1tF+uxhaOATZGZctkWy+Ag@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:22:11PM +0200, Linus Walleij wrote:
> On Mon, Aug 30, 2021 at 10:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > +/* Port isolation registers */
> > > +#define RTL8366RB_PORT_ISO_BASE              0x0F08
> > > +#define RTL8366RB_PORT_ISO(pnum)     (RTL8366RB_PORT_ISO_BASE + (pnum))
> > > +#define RTL8366RB_PORT_ISO_EN                BIT(0)
> > > +#define RTL8366RB_PORT_ISO_PORTS_MASK        GENMASK(7, 1)
> >
> > If RTL8366RB_NUM_PORTS is 6, then why is RTL8366RB_PORT_ISO_PORTS_MASK a
> > 7-bit field?
> 
> It's a 6 bit field actually from bit 1 to bit 7 just shifted up one
> bit because bit 0 is "enable".

Understood the part about bit 0 being "ENABLE".
But from bit 1 to bit 7, I count 7 bits set....

> > Also, it would be nice if you could do some minimal isolation at the
> > level of the FDB lookup. Currently, if I am not mistaken, a port will
> > perform FDB lookup even if it is standalone, and it might find an FDB
> > entry for a given {MAC DA, VLAN ID} pair that belongs to a port outside
> > of its isolation mask, so forwarding will be blocked and that packet
> > will be dropped (instead of the expected behavior which is for that
> > packet to be forwarded to the CPU).
> >
> > Normally the expectation is that this FDB-level isolation can be achieved
> > by configuring the VLANs of one bridge to use a filter ID that is
> > different from the VLANs of another bridge, and the port-based default
> > VLAN of standalone ports to use yet another filter ID. This is yet
> > another reason to disable learning on standalone ports, so that their
> > filter ID never contains any FDB entry, and packets are always flooded
> > to their only possible destination, the CPU port.
> >
> > Currently in DSA we do not offer a streamlined way for you to determine
> > what filter ID to use for a certain VLAN belonging to a certain bridge,
> > but at the very least you can test FDB isolation between standalone
> > ports and bridged ports. The simplest way to do that, assuming you
> > already have a forwarding setup with 2 switch ports swp0 and swp1, is to
> > enable CONFIG_BONDING=y, and then:
> >
> > ip link add br0 type bridge
> > ip link set bond0 master br0
> > ip link set swp1 master bond0
> > ip link set swp0 master br0
> >
> > Then ping between station A attached to swp0 and station B attached to
> > swp1.
> >
> > Because swp1 cannot offload bond0, it will fall back to software
> > forwarding and act as standalone, i.e. what you had up till now.
> > With hardware address learning enabled on swp0 (a port that offloads
> > br0), it will learn station A's source MAC address. Then when swp1 needs
> > to send a packet to station A's destination MAC address, it would be
> > tempted to look up the FDB, find that address, and forward to swp0. But
> > swp0 is isolated from swp1. If you use a filter ID for standalone ports
> > and another filter ID for bridged ports you will avoid that problem, and
> > you will also lay the groundwork for the full FDB isolation even between
> > bridges that will be coming during the next development cycle.
> >
> > If you feel that the second part is too much for now, you can just add
> > the extra callbacks for address learning and flushing (although I do
> > have some genuine concerns about how reliable was the software forwarding
> > with this driver, seeing that right now it enables hardware learning
> > unconditionally). Is there something that isolates FDB lookups already?
> 
> Ugh that was massive, I'm not that smart ;)
> 
> I kinda understand it but have no idea how to achieve this with
> the current hardware, driver and vendor code mess.
> 
> I prefer to fix the first part for now.

Okay, no problem, I suppose FDB isolation can be revisited as part of
the larger rework I've got planned for the next kernel.
