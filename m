Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC181352CF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfFDWoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:44:22 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45817 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDWoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:44:22 -0400
Received: by mail-ed1-f67.google.com with SMTP id f20so2738178edt.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 15:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVnKZKlGN/grA9fxMqAIVelECIra3fPhXTKIrCAzUBk=;
        b=VoCP6QrWi4PLvMHeZ2ekp2zL7jg9qiHEo2zUOf/1E5yHwaj0gPDexwF2cURTjtTrM8
         GLSEIaiyYNdlCUhk5ObZDakxLhjtI/vwMZ6WhR9UxFPlyLzpoeRXxdg0yxgQNZ1A4r1f
         AkhvhGmKBQcEhjDWww4FgZcWlx2QGFSfgjlXb3FQfRDDHaND2iU7CeqipGqAX+NRmWIY
         j5JdyqJizGVtjJX1Jt5aU1TVvP/kicVdNpeP0KxeYdHGNhXCIeNSpPD0scutdjeejUB0
         1WiI1sWB2Qb834lBRzwebblmG4oBuIWCqlmDP1FA6OFpBzhoETDwTZR6bTi02cIWTTk7
         OjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WVnKZKlGN/grA9fxMqAIVelECIra3fPhXTKIrCAzUBk=;
        b=DXa/BkSqjVYwc7XAYgcd1kqt/3nq4sApcRf6VMjF8IKIVz+1kagMwMzYy/SdCHHhXM
         TDeCBYPwQqdXZKMts6c3d1fycnVbMLuLymcs8/xqR8Y6sswo7WqS4RvxO2e6b2tgbaL8
         Gp7xPKzQP+8XZjlauwWxBr6yHmlGEeyFZqbOkGLjCcl5YGOdWK31AGz5p4JUHA3D+h2L
         8g3XtM6s7VDBPXno6D/gP6rxqL/hwKDUtmfjwFejjDdwncXOOLhyUhgxBm9pifmPUnqw
         UC/S/FpdqI92r6gFQqxcZuwE/j/fz+BdW0yEcP6Nzjheg1vKkDzZzZjJ+075ATM0uPak
         05AQ==
X-Gm-Message-State: APjAAAWlJHrVNEQogPhi3v87Bs0pOPd7QJL+TOKBd0eeXv6HYJ5TgQRx
        jbLIrOQyJ8aJSjQ+OSu5MbQ7eB9AtYyaitjlZtg=
X-Google-Smtp-Source: APXvYqx1enCOcghmhKpIHTArZJ1uPhmuSMAikQ7Hl1MbsCwVD/ZcnX0lyG+wCVcXzLHxeVHUBJEN/Zzq47AKwn8cxKw=
X-Received: by 2002:a05:6402:1543:: with SMTP id p3mr39459997edx.108.1559688259583;
 Tue, 04 Jun 2019 15:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch> <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com> <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com> <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
In-Reply-To: <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 01:44:08 +0300
Message-ID: <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 01:16, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jun 05, 2019 at 01:03:27AM +0300, Vladimir Oltean wrote:
> > On Wed, 5 Jun 2019 at 00:48, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Tue, Jun 04, 2019 at 02:37:31PM -0700, Florian Fainelli wrote:
> > > > The firmware/boot loader transition to a full fledged OS with a switch
> > > > is a tricky one to answer though, and there are no perfect answers
> > > > AFAICT. If your SW is totally hosed, you might want the switch to
> > > > forward traffic between all LAN ports (excluding WAN, otherwise you
> > > > expose your home devices to the outside world, whoops).
> > > >
> > > > If your SW is fully operational, then the questions are:
> > > >
> > > > - do you want a DSA like behavior in your boot loader, in that all ports
> > > > are separated but fully usable or do you want a dumb switch model where
> > > > any port can forward to the CPU/management port, without any tags or
> > > > anything (unmanaged mode)
> > > >
> > > > - what happens during bootloader to OS handover, should the switch be
> > > > held in reset so as to avoid any possible indirect DMA into main memory
> > > > as much as power saving? Should nothing happen and let the OS wipe out
> > > > clean the setting left by the boot loader?
> > > >
> > > > All of these are in the realm of policy and trade offs as far as
> > > > initializing/disruption goes, so there are no hard and fast answers.
> > >
> > > For a switch, there are four stages, not two:
> > >
> > > 1. The out-of-reset state, which from what I've seen seems to be to
> > >    behave like a dumb switch.
> > >
> > > 2. The boot loader state, which is generally the same as the
> > >    out-of-reset state.
> > >
> > > 3. The OS-booting state, which for a DSA switch in Linux isolates each
> > >    port from each other.
> > >
> > > 4. The OS-booted state, which depends on the system configuration.
> > >
> > > If you are setting up a switch in a STP environment, you _have_ to be
> > > aware of all of those states, and plan your network accordingly.
> > > While it's possible to argue that the boot loader should isolate the
> > > ports, it may be that the system gets hosed to the point that the boot
> > > loader is unable to run - then you have a switch operating in a STP
> > > environment acting as a dumb switch.
> > >
> > > The same actually goes for many switches - consider your typical DSL
> > > router integrated with a four port switch.  By default, that switch
> > > forwards traffic between each port.  If you've setup the ports to be
> > > isolated, each time the router is rebooted (e.g., due to a
> > > configuration change) it will forward traffic between all ports until
> > > the routers OS has finished booting and applied the switch
> > > configuration.
> > >
> > > What I'm basically saying is that if you're going to the point of
> > > using such hardware in a STP environment, you _must_ pay attention
> > > to the behaviour of the hardware through all phases of its operation
> > > and consider the consequences should it fail in any of those phases.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > > According to speedtest.net: 11.9Mbps down 500kbps up
> >
> > Hi Russell,
> >
> > The dumb switch was just an example. The absolute same thing (unwanted
> > PHY connection) applies to regular NICs. I am not aware of any setting
> > that makes the MAC ignore frames as long as they observe the
> > appropriate MII spec. And the hardware will go on to process those
> > frames, potentially calling into the operating system and making it
> > susceptible to denial of service.
>
> Having authored several network device drivers, and worked on several
> others, I think you have a misunderstanding somewhere.
>

You caught me.

But even ignoring the NIC case, isn't the PHY state machine
inconsistent with itself? It is ok with callink phy_suspend upon
ndo_stop, but it won't call phy_suspend after phy_connect, when the
netdev is implicitly stopped?

> It is not expected that the MAC will be "alive" while the network
> interface is down - it is expected that the MAC will be disabled, and
> memory necessary for buffer rings etc will not be claimed.
>
> > That is unless you set up your
> > buffer rings/queues/whatever in the ndo_open/ndo_close callbacks.
>
> So yes, that is what is expected - so that when the interface is down,
> the memory needed for the buffer rings and packet buffers is given
> back to the system for other uses.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
-Vladimir
