Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6505D3527F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFDWDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:03:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34898 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFDWDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:03:40 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so2690649edr.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 15:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X9AkPEL1D7sULtkf3UU/PgA3Z22vkfJ7f93Z2cyoC7o=;
        b=pYzbEJ39oLdlDPdNyO3D/U0GNHB3haju3hDKmcfctLk4EpaSZhE1iAvyG3uesrLNPA
         T6GCnmZAl6aXMHR1cz/xZ/8Rp0s6ILWt6tT9hHN0lXfhzkkYrPHHnTyqtnibDjK8lEYB
         Bf+eAj0JyWb+qDX1L1BjTHKUGFq17GoQkc5nPbPYE5fF7wbOwaYcajabQrrySG0UOuY+
         QWg7hq3O2LhrsK4u5DsrTXah0ieoqFK8qN1LbM7GHvmG82kANHFZKvrjkfXMtzpxJmOW
         yFeVSxut0/r7MZmGi1LBUwI0LbkCjzT/JiIkjKbanJJJtBhmLd65AVGAl3oJovL3Bhi2
         ewRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X9AkPEL1D7sULtkf3UU/PgA3Z22vkfJ7f93Z2cyoC7o=;
        b=n98yyUZnubLeJQ0a87miEv6DxI99DFzTpAzdtg083mtELpU3J088SlcXMybtBuaQE1
         1k6KjO/ZjIcwVlgmcRsb1Y8haIGJOvXBZp5al6JVAMEq1bGpksqkwsNCAoVP8GHN66HB
         rUmDlcyfcA/W5QTXdmiwUKSEF0Z7dAR8g9IagBpCc3ASL3NjbBKuuiQqSBeC6Biu0LEg
         TeM3dSXrTBlwg5/xiV7yTXwkS2AwBYBmR50pByaQTmCwUuB50reJYNu0pc/+4W14IGiX
         Pg0+Eq/tzDKv1sO/iJBocwQSDtB8F2PGLHXXgHl69OIy2QpFwbvGrz5wHN1WIXxANHqf
         mGbQ==
X-Gm-Message-State: APjAAAXgVSXZyu4rvg2gVtQd8VjZsU5miM5eh1hlbgwP6nJlvHw8E4cH
        mWk95v1w2eyWkxeBOZE9rYjpZGZC94pet3mFtsmVz9Z0
X-Google-Smtp-Source: APXvYqzUox/bLLi2iumseshyQG1BZ/dTnGBn+BZoV4eilT+dpPdp7nCFDi7kFumeqVDZKdsQYwBunoWacQPwUlpMg1Q=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr37765341eds.117.1559685818086;
 Tue, 04 Jun 2019 15:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch> <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com> <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
In-Reply-To: <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 01:03:27 +0300
Message-ID: <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
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

On Wed, 5 Jun 2019 at 00:48, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jun 04, 2019 at 02:37:31PM -0700, Florian Fainelli wrote:
> > The firmware/boot loader transition to a full fledged OS with a switch
> > is a tricky one to answer though, and there are no perfect answers
> > AFAICT. If your SW is totally hosed, you might want the switch to
> > forward traffic between all LAN ports (excluding WAN, otherwise you
> > expose your home devices to the outside world, whoops).
> >
> > If your SW is fully operational, then the questions are:
> >
> > - do you want a DSA like behavior in your boot loader, in that all ports
> > are separated but fully usable or do you want a dumb switch model where
> > any port can forward to the CPU/management port, without any tags or
> > anything (unmanaged mode)
> >
> > - what happens during bootloader to OS handover, should the switch be
> > held in reset so as to avoid any possible indirect DMA into main memory
> > as much as power saving? Should nothing happen and let the OS wipe out
> > clean the setting left by the boot loader?
> >
> > All of these are in the realm of policy and trade offs as far as
> > initializing/disruption goes, so there are no hard and fast answers.
>
> For a switch, there are four stages, not two:
>
> 1. The out-of-reset state, which from what I've seen seems to be to
>    behave like a dumb switch.
>
> 2. The boot loader state, which is generally the same as the
>    out-of-reset state.
>
> 3. The OS-booting state, which for a DSA switch in Linux isolates each
>    port from each other.
>
> 4. The OS-booted state, which depends on the system configuration.
>
> If you are setting up a switch in a STP environment, you _have_ to be
> aware of all of those states, and plan your network accordingly.
> While it's possible to argue that the boot loader should isolate the
> ports, it may be that the system gets hosed to the point that the boot
> loader is unable to run - then you have a switch operating in a STP
> environment acting as a dumb switch.
>
> The same actually goes for many switches - consider your typical DSL
> router integrated with a four port switch.  By default, that switch
> forwards traffic between each port.  If you've setup the ports to be
> isolated, each time the router is rebooted (e.g., due to a
> configuration change) it will forward traffic between all ports until
> the routers OS has finished booting and applied the switch
> configuration.
>
> What I'm basically saying is that if you're going to the point of
> using such hardware in a STP environment, you _must_ pay attention
> to the behaviour of the hardware through all phases of its operation
> and consider the consequences should it fail in any of those phases.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Hi Russell,

The dumb switch was just an example. The absolute same thing (unwanted
PHY connection) applies to regular NICs. I am not aware of any setting
that makes the MAC ignore frames as long as they observe the
appropriate MII spec. And the hardware will go on to process those
frames, potentially calling into the operating system and making it
susceptible to denial of service. That is unless you set up your
buffer rings/queues/whatever in the ndo_open/ndo_close callbacks.
The point is that having a way to make a link dead/have it dead by
default is the easiest way to prevent a lot of problems. Call that
policy, whatever, but I think at the very least the Linux kernel
should have a way to operate in this mode (if not even be the default
one, unless the user knows better).

Regards,
-Vladimir
