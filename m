Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88394F859D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKLAxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:53:39 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43651 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfKLAxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:53:39 -0500
Received: by mail-ed1-f67.google.com with SMTP id w6so13471001edx.10
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 16:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fcSxLNS/biUc89tWphozIjzqziKHdWqDkzf/MRzUwLI=;
        b=aEIW8qlW9Fs3KD6+QuR/lZR65NIOYSejq8qalYvtaYkBc6fYPe/CrPBdmKxRj3tRqA
         SvACVGX4477RMyrfSCaLeo+nAYOb2jWtTo5Pw7L10PPcrtnyE/tNhos43BmUUxfKzvzx
         BW1yntjk2cjistsBv1uKBtgEBncFRzcD4WrWsd/tunT3aifyl8gOyHH/bd+hsiXNmBgf
         hEBzPM1ue3yw1q7Vp1/Jl2OhVobHu8tOe7ly/0xEtJOlGDGtETZuwTRahtML4utbyCY7
         k7yc2N4CsrhuV9ZNePpcnywVSUrxSpyEAewMDeowmp9xUVofJB7kV54XDsWyU0GECof+
         fJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcSxLNS/biUc89tWphozIjzqziKHdWqDkzf/MRzUwLI=;
        b=Bds8IdYdHHlChnSjv1QLc0A6SPusV7wC2PDM4e7QGETWXMg6jT9J3etvBPSUqGYSQz
         ZVuuNtqW1IG4HMMxwocBOOFvbvsC5Fsm7WeSyXMamkCNG+ywJ+fN9qjrKK/MRokcVHwp
         VTaXC/L9nyYMyj78yt6GCY91HWpGKCATestmkrZF7MeeBZRy2cHyt11+CczrMOFpB407
         hCTK2gsuL5KVae8PIxBgAnjCu1v9mVLDiWaHdkUjO1UtD0kjLDYDQkeILaNk59ESa2db
         hJ0AlCduZ60gdmjEOgGjCVPoHyz7FENVtkBW8ePWfkPyM4iiWKPo5NZGiU0xt8tmAuTI
         qVeA==
X-Gm-Message-State: APjAAAWPbR5mOO893w7oJxOhUVRmztukoXHeOBxeYP7gbJcqxiLuFSXz
        aEpo6JGTD/+KMXrGZ3tROt0RGGTMqkFvDmJMgRdKBmTK
X-Google-Smtp-Source: APXvYqyWXGIxePhXlU/bZ5cfmyk0lUafF0BTjv+X3vYuGkL7imU2T56xnaoD6Snrr6nb4RzGykVUJN33xg4TVZB1qKE=
X-Received: by 2002:a50:c408:: with SMTP id v8mr29833770edf.140.1573520016910;
 Mon, 11 Nov 2019 16:53:36 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-16-olteanv@gmail.com>
 <20191110165031.GF25889@lunn.ch> <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
 <20191110171250.GH25889@lunn.ch> <CA+h21hpg2a=V44R_YNBBxTP4jLMgQaHBzHXyqaMDhg9uBvtpAA@mail.gmail.com>
 <d99479d0-b5c2-bee2-73ff-7d9235840225@gmail.com>
In-Reply-To: <d99479d0-b5c2-bee2-73ff-7d9235840225@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 02:53:26 +0200
Message-ID: <CA+h21hqvYnj-4mTwQ5zF9HNh8RHH3PMyBgpHHiiyT4+9RPkLbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
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

On Sun, 10 Nov 2019 at 22:54, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 11/10/2019 9:33 AM, Vladimir Oltean wrote:
> > On Sun, 10 Nov 2019 at 19:12, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Sun, Nov 10, 2019 at 07:00:33PM +0200, Vladimir Oltean wrote:
> >>> On Sun, 10 Nov 2019 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
> >>>>
> >>>> On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
> >>>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >>>>>
> >>>>> VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
> >>>>> queuing subsystem for terminating traffic locally).
> >>>>
> >>>> So maybe that answers my last question.
> >>>>
> >>>>> There are 2 issues with hardcoding the CPU port as #10:
> >>>>> - It is not clear which snippets of the code are configuring something
> >>>>>   for one of the CPU ports, and which snippets are just doing something
> >>>>>   related to the number of physical ports.
> >>>>> - Actually any physical port can act as a CPU port connected to an
> >>>>>   external CPU (in addition to the local CPU). This is called NPI mode
> >>>>>   (Node Processor Interface) and is the way that the 6-port VSC9959
> >>>>>   (Felix) switch is integrated inside NXP LS1028A (the "local management
> >>>>>   CPU" functionality is not used there).
> >>>>
> >>>> So i'm having trouble reading this and spotting the difference between
> >>>> the DSA concept of a CPU port and the two extra "CPU ports". Maybe
> >>>> using the concept of virtual ports would help?
> >>>>
> >>>> Are the physical ports number 0-9, and so port #10 is the first extra
> >>>> "CPU port", aka a virtual port? And so that would not work for DSA,
> >>>> where you need a physical port.
> >>>>
> >>>>       Andrew
> >>>
> >>> Right. See my other answer which links to Ocelot documentation.
> >>
> >> Yes, i'm getting the picture now.
> >>
> >> The basic problem is that in the Linux kernel CPU port has a specific
> >> meaning, and it is clashing with the meaning used in the datasheet. So
> >> maybe in the driver, we need to refer to these two ports as 'local
> >> ports'?
> >>
> >
> > Hmm, I don't know. Both types of CPU ports lead to management CPUs,
> > but to different types of them. I understand the clash with the DSA
> > meaning, but even if I rename it I would have to provide an
> > explanation relative to the datasheet definitions (and I already
> > explain that the NPI mode is the DSA type of CPU port). I'm not sure
> > there is a net gain.
>
> Maybe we need to agree on renaming DSA's CPU port to "mgmt_port" or
> something that indicates that there is in-band signaling to help support
> the function of managing the switch, incidentally Broadcom switches call
> their ports In-Band Management Port (IMP) which is clearer IMHO.
> --
> Florian

In the hardware conceptions that I float in, a "management port" has
the connotation of "exclusively management" (link-local multicast plus
user-defined trapping rules). While I completely understand that this
model is something that doesn't help the Linux abstraction at all, it
is something that apparently enough people in NXP have thought of as
being a good idea since they actually put it in practice in designs.
Just something to keep in mind.

Andrew, is the Z80 embedded CPU able to run Linux? If not, then from
what perspective are you saying you're going to call it "the z80 port"
instead of "CPU port", and why would you add support for it?
The current ocelot driver runs on the little CPU and doesn't support
external management, and the downstream felix driver runs on the big
CPU and doesn't support "local" I/O (DMA, PIO), so there are both at
the extremes. I don't know of any kernel driver that sets up the
switch for a remote DSA master, but I'd be curious to see what is the
terminology there.

But otherwise, I don't know whether there's anything really actionable
here. What the ocelot driver calls a CPU port is always a "port
towards the CPU running Linux and managing the switch", so the CPU
port is always local by definition, no matter whether the CPU is
connected over DMA or over Ethernet (aka NPI mode or not).

Thanks,
-Vladimir
