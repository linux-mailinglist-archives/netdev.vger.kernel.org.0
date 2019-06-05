Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31C635882
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 10:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFEI2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 04:28:13 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34148 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFEI2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 04:28:13 -0400
Received: by mail-ed1-f68.google.com with SMTP id c26so4596383edt.1
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5BJY7mKfMEZc55BPbrjce9iYBalQVczOu+KzN18nxE=;
        b=pYBWaZUkG/Qbcp1qBwraHMm1LXZFjb9N6ViH7nxpfhVKY7MP2ky3st/5f/1tfmr1Ur
         g+wss28ICA73VlnVOVoMgoykwazJdAQWme97lY8wskuWpumN1JVG/lqfVwYMAxl35tET
         kzVt3clHhg2bkb5OS0syMmBShOXOj2deuxk6HfqqZ0CDfADp5y2Ig67jIq9ALZ0Fc+xe
         M++qk6720r8t1G1qUV/XwvvYYZUIph9q5jt0HUz98OI2KIr+tauFMd0TJVutqci7UcoK
         sgN6w0XuzpDVyQ7UZ9Sawc7yn90mR2z93kqrRAHgF0QKFlFat8S8vIo6lRVdkkiUVxno
         4fJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5BJY7mKfMEZc55BPbrjce9iYBalQVczOu+KzN18nxE=;
        b=rA2NYBWocBQPtSfP1bCghWHD60SZ5QfCv84RYQufzIzSaHBAjw2Ta+AFkMnXBZq4dN
         M1JWzwOa94ljGkUW/AuJFPgn7GRdyeLORne8qbkRet4HBAelhg/9VH+mFxpWTWcSd2L4
         dP05zsp4HLqsK/ovuYJ5D47GAgrOg2c/c+aHY3wkvZpxpkzGGjvjNKtlrTjQev4fokLv
         gWUoKTCFZGTW1Y3GMJf5zKSWqvmwdXg+XP7I3UynqkqrIgHOjGj1R1mvBclXRlN65jYG
         PIqKLWlWrmu/dkyHpAsxi3BmKBzRDC3/hlbL5ugyXnufBXxmef9XAmMt6VTRH0g2fpdN
         ox1w==
X-Gm-Message-State: APjAAAU+n1se2+3REzfRu79Z05aSqTOLYFKTzRmTsPzb3K9FEgynsado
        Bd3cLIMFs17QwD5HcC75lpoUJXZs2UYYBs97hHs=
X-Google-Smtp-Source: APXvYqwnoS0V9b7YkTGQ/2lfZs0DZRmQ3WUaPj1PbPXnFqsxSH7fS6qoUp7CDHlaRLeu6JQi/zkrzRZRm+8uOcILDC0=
X-Received: by 2002:a50:c985:: with SMTP id w5mr39607934edh.140.1559723290952;
 Wed, 05 Jun 2019 01:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch> <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com> <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk> <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk> <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk> <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
 <262dfc0e-c248-23e7-cd34-d13e104afe91@gmail.com>
In-Reply-To: <262dfc0e-c248-23e7-cd34-d13e104afe91@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 11:27:59 +0300
Message-ID: <CA+h21howazOwxZ840kYKS_cCaGB6_B1f0e=2NMHY1y8zDw7iug@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 06:06, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 6/4/2019 4:46 PM, Vladimir Oltean wrote:
> > On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> >>
> >> On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
> >>> On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
> >>> <linux@armlinux.org.uk> wrote:
> >>>>
> >>>> On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> >>>>> You caught me.
> >>>>>
> >>>>> But even ignoring the NIC case, isn't the PHY state machine
> >>>>> inconsistent with itself? It is ok with callink phy_suspend upon
> >>>>> ndo_stop, but it won't call phy_suspend after phy_connect, when the
> >>>>> netdev is implicitly stopped?
> >>>>
> >>>> The PHY state machine isn't inconsistent with itself, but it does
> >>>> have strange behaviour.
> >>>>
> >>>> When the PHY is attached, the PHY is resumed and the state machine
> >>>> is in PHY_READY state.  If it goes through a start/stop cycle, the
> >>>> state machine transitions to PHY_HALTED and attempts to place the
> >>>> PHY into a low power state.  So the PHY state is consistent with
> >>>> the state machine state (we don't end up in the same state but with
> >>>> the PHY in a different state.)
> >>>>
> >>>> What we do have is a difference between the PHY state (and state
> >>>> machine state) between the boot scenario, and the interface up/down
> >>>> scenario, the latter behaviour having been introduced by a commit
> >>>> back in 2013:
> >>>>
> >>>>     net: phy: suspend phydev when going to HALTED
> >>>>
> >>>>     When phydev is going to HALTED state, we can try to suspend it to
> >>>>     safe more power. phy_suspend helper will check if PHY can be suspended,
> >>>>     so just call it when entering HALTED state.
> >>>>
> >>>> --
> >>>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> >>>> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> >>>> According to speedtest.net: 11.9Mbps down 500kbps up
> >>>
> >>> I am really not into the PHYLIB internals, but basically what you're
> >>> telling me is that running "ip link set dev eth0 down" is a
> >>> stronger/more imperative condition than not running "ip link set dev
> >>> eth0 up"... Does it also suspend the PHY if I put the interface down
> >>> while it was already down?
> >>
> >> No - but that has nothing to do with phylib internals, more to do with
> >> the higher levels of networking.  ndo_stop() will not be called unless
> >> ndo_open() has already been called.  In other words, setting an already
> >> down device down via "ip link set dev eth0 down" is a no-op.
> >>
> >> So, let's a common scenario.  You power up a board.  The PHY comes up
> >> and establishes a link.  The boot loader runs, loads the kernel, which
> >
> > This may or may not be the case. As you pointed out a few emails back,
> > this is a system-level issue that requires a system-level solution -
> > so cutting the link in U-boot is not out of the question.
> >
> >> then boots.  Your network driver is a module, and hasn't been loaded
> >> yet.  The link is still up.
> >>
> >> The modular network driver gets loaded, and initialises.  Userspace
> >> does not bring the network device up, and the network driver does not
> >> attach or connect to the PHY (which is actually quite common).  So,
> >> the link is still up.
> >>
> >> The modular PHY driver gets loaded, and binds to the PHY.  The link
> >> is still up.
> >
> > I would rather say, 'even if the link is not up, Linux brings it up
> > (possibly prematurely) via phy_resume'.
> > But let's consider the case where the link *was* up. The general idea
> > is 'implement your workarounds in whatever other way, that link is
> > welcome!'.
>
> With the systems that I work with, we have enforced the following
> behavior to happen: the boot loader and kernel only turn on what they
> needs, at the time they need it, and nothing more, once done, they put
> the blocks back into lowest power mode (clock and power gated if
> available). So yes, there are multiple link re-negotiations throughput
> the boot process, but when there is no device bound to a driver the
> system conserves power by default which is deemed a higher goal than
> speed. Your mileage may vary of course.
>
> There is not exactly a simple way of enforcing that kind (or another
> kind for that matter) of policy kernel wide, so it's unfortunately up to
> the driver writer to propose something that is deemed sensible.
>
> We could however, extend existing tools like iproute2 to offer the
> ability to control whether the PHY should be completely powered off, in
> a low power state allowing WoL, or remain UP when the network device is
> brought down. That would not cover the case that Russell explained, but
> it would be another monkey wrench you can throw at the system.
> --
> Florian

Hi Florian,

By going to HALTED on phy_stop, the system already achieves what I am
looking after - although maybe it is an unintended consequence for
you.
I'm only trying to make an argument for removing the phy_resume from
phy_attach_direct now. If there was a link, and it doesn't need
re-negociation, fine, use it in phy_start, but at most leave U-boot to
put that link down and don't force it up prior to the netdev's
ndo_open.

Regards,
-Vladimir
