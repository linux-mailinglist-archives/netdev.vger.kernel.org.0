Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2FF6A97
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKJReG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:34:06 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42268 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfKJReG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 12:34:06 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so10061836edv.9
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 09:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZrY1XaEMPUMdCEpV50NL3PUcz3OzvbkzH+vuAxgEkE=;
        b=fkcVsbG8iP/aDMF3FMhc1sBwwIWkJMXidAuVGQMWVvR+IV57p8pbehRk2Fp9u8GPAJ
         sf8ispbVK0bKuUOmjafro+WXX0P9ZPW3QjEG4R//nVeTECOj8T3BHEVS/7wjTzQV5P8c
         krY16gWql7KuEOdZtCStbwgekm0RxdJ6iPDn1Gr1Wt2yyK5Xs5MqDoOJ3txKtBezROkn
         dZauildlah7e8w/ybEJgVsdmyqBDm5LMJ64j/Ehn04vAJXv9CCIepKAcIGwLTR/elx7o
         wsYUnD2IZVMXySMxX+FnkzuUAFCpDxzIge6AcZ7OZzsAIzU9fc5Vk+mSrKqSqrLwbaD/
         IcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZrY1XaEMPUMdCEpV50NL3PUcz3OzvbkzH+vuAxgEkE=;
        b=Eg/qi/vewP/ARbSkg42Ed2yRIs8fCaaMBBnfNgFl30wCsE4ajEXFF96cv2Rlu84H/y
         bAc0gWjfEVcUfNyU/ohhqoA0c9b1GuRt4ZqDUJ8oM5MfwnuN2059sjUoFHMLxV3L+RyF
         hPUD8W3G882FrS0mwsSRvHBDUJ6OVDrnpdTAPtDUJGBXAHlnYL3JLWWfgeb55FeDp3GU
         2edmxkofdTagP3Msm0sI9Bm5+M6Ea4jxsCJgLx8lpckjLDLaVUeiA8t03DmVNcC/9ibo
         5bUGHBvba7JCR8f6FaXQTDgqxTciOg7mn7uduM9up3P9nWAoN3P1rTLLjTPlcMuulJkX
         Lu9A==
X-Gm-Message-State: APjAAAX4mb8ae3FaSPigReD6iaxS9OVDKZn6d9Og4dBMurOOY/WtuWrM
        g9jr0420aTjOuBSBclg/UPvuNm26x/bG3vLo2HM=
X-Google-Smtp-Source: APXvYqzuGzcEMITS208RHWbnmFSUUqaxhKZ6ZPofLE4t9GnFAeQ0jIGUOsaKCHOSbr3NCHO2hfX0MBJyHPtEAKIdqKY=
X-Received: by 2002:a50:c408:: with SMTP id v8mr22002500edf.140.1573407243354;
 Sun, 10 Nov 2019 09:34:03 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-16-olteanv@gmail.com>
 <20191110165031.GF25889@lunn.ch> <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
 <20191110171250.GH25889@lunn.ch>
In-Reply-To: <20191110171250.GH25889@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 19:33:52 +0200
Message-ID: <CA+h21hpg2a=V44R_YNBBxTP4jLMgQaHBzHXyqaMDhg9uBvtpAA@mail.gmail.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 at 19:12, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Nov 10, 2019 at 07:00:33PM +0200, Vladimir Oltean wrote:
> > On Sun, 10 Nov 2019 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
> > > > queuing subsystem for terminating traffic locally).
> > >
> > > So maybe that answers my last question.
> > >
> > > > There are 2 issues with hardcoding the CPU port as #10:
> > > > - It is not clear which snippets of the code are configuring something
> > > >   for one of the CPU ports, and which snippets are just doing something
> > > >   related to the number of physical ports.
> > > > - Actually any physical port can act as a CPU port connected to an
> > > >   external CPU (in addition to the local CPU). This is called NPI mode
> > > >   (Node Processor Interface) and is the way that the 6-port VSC9959
> > > >   (Felix) switch is integrated inside NXP LS1028A (the "local management
> > > >   CPU" functionality is not used there).
> > >
> > > So i'm having trouble reading this and spotting the difference between
> > > the DSA concept of a CPU port and the two extra "CPU ports". Maybe
> > > using the concept of virtual ports would help?
> > >
> > > Are the physical ports number 0-9, and so port #10 is the first extra
> > > "CPU port", aka a virtual port? And so that would not work for DSA,
> > > where you need a physical port.
> > >
> > >       Andrew
> >
> > Right. See my other answer which links to Ocelot documentation.
>
> Yes, i'm getting the picture now.
>
> The basic problem is that in the Linux kernel CPU port has a specific
> meaning, and it is clashing with the meaning used in the datasheet. So
> maybe in the driver, we need to refer to these two ports as 'local
> ports'?
>

Hmm, I don't know. Both types of CPU ports lead to management CPUs,
but to different types of them. I understand the clash with the DSA
meaning, but even if I rename it I would have to provide an
explanation relative to the datasheet definitions (and I already
explain that the NPI mode is the DSA type of CPU port). I'm not sure
there is a net gain.

> The mv88e6xxx driver has a similar problem. Some of the switches have
> a Z80 embedded in them. And this Z80 has an ethernet interface
> connected to the switch core as port 12. So far we don't support it,
> but if we ever do, i'm sure we will end up calling it the z80 port,
> not the cpu port.
>
>     Andrew
