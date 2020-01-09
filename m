Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F3F1362A5
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgAIVev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:34:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59016 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgAIVev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VA4c5Tr0ysg8i8vuzAdXo5jeLKchTQae7zB8f7OeiqY=; b=ucuoG0hoV97g6qP+C57Z/lwKB
        ekJoDlZ0QyS8EY4ik7S8wzC2bA64bhCs4hmWvF/Lc3tiW4y/SchJS83f9lvy9gYahERef0WjCuCcU
        x3bBxs0scOr6B5AiqxYByq25QeZXTgO+aQv7e7zdyNOTz92SMXPArDyX3Z7+2WfyaVpOxF3iMJlED
        P8Zq4b8BxPjwHGKGR3vedxdrxS4AtLnnJ1M0yBIvCR/H3ptFMnMmF3iXPNqs5bgQR5sKPK3Ruc4Xc
        UQt6mtqcD6cAsJE8kDGTNHTClWkCxEeYPQnHRF5DhJByIgNmwPBqIBSvVSQyFEnhh9Ei6dFnclj0p
        Y+fz5q3Mg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52790)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipfS1-0007S7-Aw; Thu, 09 Jan 2020 21:34:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipfRz-0000p5-I4; Thu, 09 Jan 2020 21:34:43 +0000
Date:   Thu, 9 Jan 2020 21:34:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109213443.GS25745@shell.armlinux.org.uk>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 07:01:10PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 09/01/2020 17:43, Russell King - ARM Linux admin wrote:
> > On Thu, Jan 09, 2020 at 05:35:23PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > Thank you for the extensive feedback and explanation.
> > > 
> > > Pardon for having mixed up the semantics on module specifications vs. EEPROM
> > > dump...
> > > 
> > > The module (chipset) been designed by Metanoia, not sure who is the actual
> > > manufacturer, and probably just been branded Allnet.
> > > The designer provides some proprietary management software (called EBM) to
> > > their wholesale buyers only
> > I have one of their early MT-V5311 modules, but it has no accessible
> > EEPROM, and even if it did, it would be of no use to me being
> > unapproved for connection to the BT Openreach network.  (BT SIN 498
> > specifies non-standard power profile to avoid crosstalk issues with
> > existing ADSL infrastructure, and I believe they regularly check the
> > connected modem type and firmware versions against an approved list.)
> > 
> > I haven't noticed the module I have asserting its TX_FAULT signal,
> > but then its RJ45 has never been connected to anything.
> > 
> 
> The curious (and sort of inexplicable) thing is that the module in general
> works, i.e. at some point it must pass the sm checks or connectivity would
> be failing constantly and thus the module being generally unusable.

It all depends what the module does with the TX_FAULT signal.  The state
machine just follows what is layed down in the SFP MSA for dealing with
a transmit fault, although the attempts to clear it and the delay from
TX_FAULT being asserted to attempting to clear are decisions of my own.

It isn't a race in the state machine.

You can check the state of the GPIOs by looking at
/sys/kernel/debug/gpio, and you will probably see that TX_FAULT is
being asserted by the module.

I'm aware of something similar with a certain GPON module, but we
haven't been able to properly work out what is going on there either -
again, it seems pretty random what the module does with the TX_FAULT
signal.

> It somehow "feels" that the module is storing some link signal information
> in a register which does not suit the sm check routine and only when that
> register clears the sm check routine passes and connectivity is restored.

You're reading /way/ too much into the state machine.  The state
machine is only concerned with two signals from the module.  One
of them is the RX_LOS signal which indicates whether the module is
receiving valid signal.  The other is TX_FAULT which is as I've
already described.  Both of these are digital signals - either they
are asserted or deasserted, and the state machine will act
accordingly.  It's rather simple.

> Since there are probably other such SFP modules, xDSL and g.fast, out there
> that do not provide laser safety circuitry by design (since not providing
> connectivity over fibre) would it perhaps not make sense to try checking for
> the existence of laser safety circuitry first prior getting to the sm
> checks?

There is no reliable way to do that; as I've already said, the EEPROM
contents is very hit and miss.  Essentially, SFPs suck, almost nothing
can be really trusted with them.

This, I believe, is why commerical grade routers have this apparent
"vendor lockin" because no one can trust anyone elses EEPROM contents
to actually come close to the SFP MSA requirements - and then you have
modules that blatently violate the SFP MSA in respect of timings.

I would not be surprised if this module's behaviour with TX_FAULT is
along those same lines; the manufacturer has decided to use TX_FAULT
for some other purpose against the SFP MSA, which will cause problems
in any SFP MSA compliant host.

> Sometime in the past sfp.c was not available in the distro and the issue
> never exhibited. Back then the module's operations mode been set through a
> py script - see bottom - but it would appear that it did not implement any
> sm checks.

That python script is very simple.  It reads the EEPROM, and attempts
to work out what kind of link to use.  It doesn't care about any of
the SFP control and status signals.  It doesn't care if you yank the
SFP out of the cage.

BTW, I notice in you original kernel that you have at least one of my
"experimental" patches on your stable kernel taken from my "phy" branch
which has never been in mainline, so I guess you're using the OpenWRT
kernel?  I have submitted patches to bring the SFP state machine up to
what was in v5.4 (and a few extra bits) to the OpenWRT maintainers as
part of some commercial work.  As I say, I'm not expecting much to
change as a result of those given what you've reported thus far.

As I've said, I think it may need a quirk so we ignore the TX_FAULT
signal.  Sorting out a patch to do that for a 4.19.xx kernel is not
going to happen soon, as the hardware I was building the OpenWRT
kernel on isn't in a functional state at the moment - and given the
unknown status of the previously submitted patches as well, I'm not
inclined to produce any further patches for OpenWRT at the moment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
