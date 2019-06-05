Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDC35B1E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfFELT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:19:27 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45542 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFELT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 07:19:27 -0400
Received: by mail-ed1-f67.google.com with SMTP id f20so5213140edt.12
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 04:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNoNjeW4LQWj6gyAYxEI2/POlgIa1Imd6nMlL91Ac3Q=;
        b=iU9bVPrlTUjxWJi7JHzQqo1evyL4vUXAJWFgIGRG7TOgUVuYMBeWJPbHawEoB67J6Q
         oU90Zjeqg8fluMKBsknJRzYnm35K5lQlTzh1HERakpv6poYQtz91XopCkislg/Z/0TYn
         qtGco/+LtvGXV26neuJrQNIaGDjl3KsNNaItRcyZdgekbkhILL1nAJHlJ0TxU2xgaFpx
         u/BkJl0jYb3/bjblByqfF+Q7TAIZ9lloVpyOSS2qeSyiSHlrdPDuM3JoUHaRmipHPjk4
         HH+P8zLl0ojFZzpjsNNU5bZtw94xHVJa3mFPjw/nBmfetYhDrrmXT5G19VCteHOyh94r
         4dcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNoNjeW4LQWj6gyAYxEI2/POlgIa1Imd6nMlL91Ac3Q=;
        b=RoiWA+80eRap4NmTYF0sNIhtKnzsgxIX4wk28l2bTx+dmcAuokIN02fbqDLhBuTjjP
         S2imf3OFTKoABNtpjDK5/oL2IcqedGjEgdEMlKynyNcHAQXFTyrO09dXRzF6CAPxua9+
         hdab463uHNSCnNYfLcjOgbwYN4IyOUI55oNly3aGtHxsanJwuNyhqPf4p12z9tCrODh2
         NyH9pmt5SDAJ7p1mRR8EonU46YocX0z82BfqTwX8TJRWeopgBPG9x+7ihd7QGTA4i4YW
         amxXiD0NsP1g+DYNcP+WOgeY4yom5Xm9zXoCdooma2qmCabE9IGFEmgd7qTSw2fBakH9
         ve4Q==
X-Gm-Message-State: APjAAAXn19bDZ3bHqr/oiSOIZ+ePpOVfj//vD31noQIlFg0AJ+PHc6XK
        UCgkZ+M/edIsjb08KFve+cz+ReXpJPsQILVm/tA=
X-Google-Smtp-Source: APXvYqxZv4uE4I4+6WoYC0mreyGKsvdPALj/IfWgdZZFVWMVQ+GD8Q1cmZiG7YBHCr/6Re4h1P7u711yiV6RS3AGrp8=
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr2615975ejs.15.1559733564086;
 Wed, 05 Jun 2019 04:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk> <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk> <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk> <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
 <262dfc0e-c248-23e7-cd34-d13e104afe91@gmail.com> <CA+h21howazOwxZ840kYKS_cCaGB6_B1f0e=2NMHY1y8zDw7iug@mail.gmail.com>
 <20190605093055.sry7mcwefdiawvlc@shell.armlinux.org.uk>
In-Reply-To: <20190605093055.sry7mcwefdiawvlc@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 14:19:12 +0300
Message-ID: <CA+h21hpSFxv89AAyKOQ5um4z+sUx4=hW7Ri698JgwMdTfnxxPg@mail.gmail.com>
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

On Wed, 5 Jun 2019 at 12:31, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jun 05, 2019 at 11:27:59AM +0300, Vladimir Oltean wrote:
> > On Wed, 5 Jun 2019 at 06:06, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > >
> > >
> > > On 6/4/2019 4:46 PM, Vladimir Oltean wrote:
> > > > On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > >>
> > > >> On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
> > > >>> On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
> > > >>> <linux@armlinux.org.uk> wrote:
> > > >>>>
> > > >>>> On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> > > >>>>> You caught me.
> > > >>>>>
> > > >>>>> But even ignoring the NIC case, isn't the PHY state machine
> > > >>>>> inconsistent with itself? It is ok with callink phy_suspend upon
> > > >>>>> ndo_stop, but it won't call phy_suspend after phy_connect, when the
> > > >>>>> netdev is implicitly stopped?
> > > >>>>
> > > >>>> The PHY state machine isn't inconsistent with itself, but it does
> > > >>>> have strange behaviour.
> > > >>>>
> > > >>>> When the PHY is attached, the PHY is resumed and the state machine
> > > >>>> is in PHY_READY state.  If it goes through a start/stop cycle, the
> > > >>>> state machine transitions to PHY_HALTED and attempts to place the
> > > >>>> PHY into a low power state.  So the PHY state is consistent with
> > > >>>> the state machine state (we don't end up in the same state but with
> > > >>>> the PHY in a different state.)
> > > >>>>
> > > >>>> What we do have is a difference between the PHY state (and state
> > > >>>> machine state) between the boot scenario, and the interface up/down
> > > >>>> scenario, the latter behaviour having been introduced by a commit
> > > >>>> back in 2013:
> > > >>>>
> > > >>>>     net: phy: suspend phydev when going to HALTED
> > > >>>>
> > > >>>>     When phydev is going to HALTED state, we can try to suspend it to
> > > >>>>     safe more power. phy_suspend helper will check if PHY can be suspended,
> > > >>>>     so just call it when entering HALTED state.
> > > >>>>
> > > >>>> --
> > > >>>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > >>>> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > > >>>> According to speedtest.net: 11.9Mbps down 500kbps up
> > > >>>
> > > >>> I am really not into the PHYLIB internals, but basically what you're
> > > >>> telling me is that running "ip link set dev eth0 down" is a
> > > >>> stronger/more imperative condition than not running "ip link set dev
> > > >>> eth0 up"... Does it also suspend the PHY if I put the interface down
> > > >>> while it was already down?
> > > >>
> > > >> No - but that has nothing to do with phylib internals, more to do with
> > > >> the higher levels of networking.  ndo_stop() will not be called unless
> > > >> ndo_open() has already been called.  In other words, setting an already
> > > >> down device down via "ip link set dev eth0 down" is a no-op.
> > > >>
> > > >> So, let's a common scenario.  You power up a board.  The PHY comes up
> > > >> and establishes a link.  The boot loader runs, loads the kernel, which
> > > >
> > > > This may or may not be the case. As you pointed out a few emails back,
> > > > this is a system-level issue that requires a system-level solution -
> > > > so cutting the link in U-boot is not out of the question.
> > > >
> > > >> then boots.  Your network driver is a module, and hasn't been loaded
> > > >> yet.  The link is still up.
> > > >>
> > > >> The modular network driver gets loaded, and initialises.  Userspace
> > > >> does not bring the network device up, and the network driver does not
> > > >> attach or connect to the PHY (which is actually quite common).  So,
> > > >> the link is still up.
> > > >>
> > > >> The modular PHY driver gets loaded, and binds to the PHY.  The link
> > > >> is still up.
> > > >
> > > > I would rather say, 'even if the link is not up, Linux brings it up
> > > > (possibly prematurely) via phy_resume'.
> > > > But let's consider the case where the link *was* up. The general idea
> > > > is 'implement your workarounds in whatever other way, that link is
> > > > welcome!'.
> > >
> > > With the systems that I work with, we have enforced the following
> > > behavior to happen: the boot loader and kernel only turn on what they
> > > needs, at the time they need it, and nothing more, once done, they put
> > > the blocks back into lowest power mode (clock and power gated if
> > > available). So yes, there are multiple link re-negotiations throughput
> > > the boot process, but when there is no device bound to a driver the
> > > system conserves power by default which is deemed a higher goal than
> > > speed. Your mileage may vary of course.
> > >
> > > There is not exactly a simple way of enforcing that kind (or another
> > > kind for that matter) of policy kernel wide, so it's unfortunately up to
> > > the driver writer to propose something that is deemed sensible.
> > >
> > > We could however, extend existing tools like iproute2 to offer the
> > > ability to control whether the PHY should be completely powered off, in
> > > a low power state allowing WoL, or remain UP when the network device is
> > > brought down. That would not cover the case that Russell explained, but
> > > it would be another monkey wrench you can throw at the system.
> > > --
> > > Florian
> >
> > Hi Florian,
> >
> > By going to HALTED on phy_stop, the system already achieves what I am
> > looking after - although maybe it is an unintended consequence for
> > you.
> > I'm only trying to make an argument for removing the phy_resume from
> > phy_attach_direct now.
>
> Merely doing that will create problems.  You may remember a few emails
> ago, we discussed whether the physical PHY state was consistent with
> the PHY state machine state.  By making that change, the PHY state
> machine vs the physical PHY state becomes inconsistent.
>
> Removing phy_resume() from phy_attach_direct() means that the PHY may
> not be in a resumed state at this point, yet we set the PHY state
> machine to PHY_READY.  When phy_start() is called, the state will be
> transitioned to PHY_UP rather than PHY_RESUMING, and we will try to
> update the advertisement into the PHY (as I've previously described.)
>
> If the PHY is powered down, but the state machine transitions from
> PHY_READY to PHY_UP state, programming the advertisement will have no
> effect, and the PHY will remain in power-down mode.
>
> So, the PHY state machine state needs to also be set according to the
> PHY mode.  The same is true for phy_probe(), which also assumes that
> the PHY is not powered down.
>
> > If there was a link, and it doesn't need
> > re-negociation, fine, use it in phy_start, but at most leave U-boot to
> > put that link down and don't force it up prior to the netdev's
> > ndo_open.
> >
> > Regards,
> > -Vladimir
> >
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks for explaining this to me in a neutral way. I need to take some
time to figure whether changing the state machine has any value for
anyone.

Regards,
-Vladimir
