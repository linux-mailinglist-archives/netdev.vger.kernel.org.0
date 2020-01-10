Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117F613778D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgAJTzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:55:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46824 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgAJTzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H8bGymHI2rWTo7++T8xwOfV158PgPjD87HXK+GYYEjg=; b=EVPMhzxUayYmZ2hZgDEbVbeB+
        e4d02Vbdyb+ib0/Oh40FsvUSrRrZnrU4JktqlFKBF75aoMVvk+kRmDuTcGsChIAf5dHWXfr0QE/c6
        3776JSsn9GyxiU6pMsN8PqhiI/hhyNzXMLbznkk3JGtmQWnRXk6sk+6nJkj7NC3cTfJFMnM5DyrWb
        0HMTH6p2p2lT50/F6sPLgkndDFGNnDGubDl1Ywyf2z+EJkYDkVnbYEa53T138yqNyDy6ya2cOtwgW
        mOs1MuMxIbU5ak3R1ZkDkYZ1vyPHmflBmVNFKtj0PO7FoHN4KY+1TjCaxbIQnT9zI2uwXOm93iwcb
        d0ISHjNXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36650)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iq0Na-0005AQ-4U; Fri, 10 Jan 2020 19:55:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iq0NZ-0001me-7R; Fri, 10 Jan 2020 19:55:33 +0000
Date:   Fri, 10 Jan 2020 19:55:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110195533.GM25745@shell.armlinux.org.uk>
References: <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
 <20200110173851.GJ25745@shell.armlinux.org.uk>
 <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
 <20200110190134.GL25745@shell.armlinux.org.uk>
 <a2a22d92-11ec-5f80-f010-d8da838b7cbf@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2a22d92-11ec-5f80-f010-d8da838b7cbf@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 07:36:04PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 10/01/2020 19:01, Russell King - ARM Linux admin wrote:
> > On Fri, Jan 10, 2020 at 06:44:18PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > On 10/01/2020 17:38, Russell King - ARM Linux admin wrote:
> > > > > > On Fri, Jan 10, 2020 at 04:53:06PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > > > > > Seems that the debug avenue has been exhausted, short of running SFP.C in
> > > > > > > debug mode.
> > > > > > You're saying you never see TX_FAULT asserted other than when the
> > > > > > interface is down?
> > > > > Yes, it never exhibits once the iif is up - it is rock-stable in that state,
> > > > > only ever when being transitioned from down state to up state.
> > > > > Pardon, if that has not been made explicitly clear previously.
> > > > I think if we were to have SFP debug enabled, you'll find that
> > > > TX_FAULT is being reported to SFP as being asserted.
> > > If really necessary I could ask the TOS developers to assist, not sure
> > > whether they would oblidge. Their Master branch build bot compiles twice a
> > > day.
> > > Would it just involve setting a kernel debug flag or something more
> > > elaborate?
> > > 
> > > > You probably aren't running that while loop, as it will exit when
> > > > it sees TX_FAULT asserted.  So, here's another bit of shell code
> > > > for you to run:
> > > > 
> > > > ip li set dev eth2 down; \
> > > > ip li set dev eth2 up; \
> > > > date
> > > > while :; do
> > > >     cat /proc/uptime
> > > >     while ! grep -A5 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done
> > > >     cat /proc/uptime
> > > >     while ! grep -A5 'tx-fault.*in  lo' /sys/kernel/debug/gpio; do :; done
> > > > done
> > > > 
> > > > This will give you output such as:
> > > > 
> > > > Fri 10 Jan 17:31:06 GMT 2020
> > > > 774869.13 1535859.48
> > > >    gpio-509 (                    |tx-fault            ) in  hi ...
> > > > 774869.14 1535859.49
> > > >    gpio-509 (                    |tx-fault            ) in  lo ...
> > > > 774869.15 1535859.50
> > > > 
> > > > The first date and "uptime" output is the timestamp when the interface
> > > > was brought up.  Subsequent "uptime" outputs can be used to calculate
> > > > the time difference in seconds between the state printed immediately
> > > > prior to the uptime output, and the first "uptime" output.
> > > > 
> > > > So in the above example, the tx-fault signal was hi at 10ms, and then
> > > > went low 20ms after the up.
> > > awfully nice of you to provide the code, this is the output when the iif is
> > > brought down and up again and exhibiting the transmit fault.
> > > 
> > > ip li set dev eth2 down; \
> > > > ip li set dev eth2 up; \
> > > > date
> > > Fri Jan 10 18:34:52 GMT 2020
> > > root@to:~# while :; do
> > > >     cat /proc/uptime
> > > >     while ! grep -A5 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done
> > > >     cat /proc/uptime
> > > >     while ! grep -A5 'tx-fault.*in  lo' /sys/kernel/debug/gpio; do :; done
> > > > done
> > Hmm, I missed a ; \ at the end of "date", so this isn't quite what
> > I wanted, but it'll do.  What that means is that:
> > 
> > > 1865.20 3224.67
> > doesn't bear the relationship that I wanted to the interface coming
> > up.
> > 
> > >   gpio-504 (                    |tx-fault            ) in  hi IRQ
> > >   gpio-505 (                    |tx-disable          ) out hi
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1871.77 3230.71
> > TX_FAULT is high at 1871.77 and TX_DISABLE is high, so the interface
> > is down.
> > 
> > >   gpio-504 (                    |tx-fault            ) in  lo IRQ
> > >   gpio-505 (                    |tx-disable          ) out lo
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1919.06 3309.55
> > Almost 47.3s later, TX_FAULT has gone low.
> 
> This correlates with invoking ifup

Yes, which concurs with my analysis.  Everything that happens from
this point on...

> > >   gpio-504 (                    |tx-fault            ) in  hi IRQ
> > >   gpio-505 (                    |tx-disable          ) out lo
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1919.07 3309.57
> > After 10ms, it goes high again - this will cause the first report of
> > a transmit fault.
> > 
> > >   gpio-504 (                    |tx-fault            ) in  lo IRQ
> > >   gpio-505 (                    |tx-disable          ) out lo
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1920.68 3312.28
> > About 1.6s later, it goes low, maybe as a result of the first attempt
> > to clear the fault by a brief pulse on TX_DISABLE.
> > 
> > So, we wait 1s before asserting TX_DISABLE for 10us, which would have
> > happened around 1920.07.  We then have 300ms for initialisation, which
> > would've taken us to 1920.37, so this may have been interpreted as the
> > fault still being present.  The next clearance attempt would have been
> > scheduled for about 1921.37.
> > 
> > >   gpio-504 (                    |tx-fault            ) in  hi IRQ
> > >   gpio-505 (                    |tx-disable          ) out lo
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1921.86 3314.21
> > 1.2s later, it re-asserts.
> > 
> > >   gpio-504 (                    |tx-fault            ) in  lo IRQ
> > >   gpio-505 (                    |tx-disable          ) out lo
> > >   gpio-506 (                    |rate-select0        ) in  lo
> > >   gpio-507 (                    |los                 ) in  lo IRQ
> > >   gpio-508 (                    |mod-def0            ) in  lo IRQ
> > > 1921.86 3314.21
> > and deasserts within the same 10ms.

... is the "funny stuff" that is triggering the TX fault warnings
and should not be happening if the module was compliant with the
SFP MSA.

> > > > However, bear in mind that even this will not be good enough to spot
> > > > transitory changes on TX_FAULT - as your I2C GPIO expander is interrupt
> > > > capable, watching /proc/interrupts may tell you more.
> > > > 
> > > > If the TX_FAULT signal is as stable as you claim it is, you should see
> > > > the interrupt count for it remaining the same.
> > > Once the iif is up those values remain stable indeed.
> > > 
> > > cat /proc/interrupts | grep sfp
> > >   52:          0          0   pca953x   4 Edge      sfp
> > >   53:          0          0   pca953x   3 Edge      sfp
> > >   54:          6          0   pca953x   0 Edge      sfp
> > > 
> > > and only incrementing with ifupdown action (which would be logical)
> > > 
> > > cat /proc/interrupts | grep sfp
> > >   52:          0          0   pca953x   4 Edge      sfp
> > >   53:          0          0   pca953x   3 Edge      sfp
> > >   54:         11          0   pca953x   0 Edge      sfp
> > According to this, TX_FAULT has toggled five times.
> > 
> > This would seem to negate your previous comment about TX_FAULT being
> > stable.
> 
> Maybe you misread of what I wrote - it is stable once the iff is up, the
> values do not change.

Define "stable once the interface is up".  Is that stable after ten
seconds?  Or stable in under the 300ms initialisation delay allowed
by the SFP MSA?

> The 5 toggles are resulting from manually invoking ifupdown action.
> 
> > Therefore, I'd say that the SFP state machines are operating as
> > designed, and as per the SFP MSA, and what we have is a module that
> > likes to assert TX_FAULT for unknown reasons, and this confirms the
> > hypothesis I've been putting forward.
> > 
> 
> This is based on the 5 IRQ toggles or the previous reading on the GPIO
> output?

On _both_.

> Surely I have no clue about the time frames the modules asserts / deasserts
> but since it works in general and only exhibits the issue intermittently
> with ifupdown action after it has been brought up initially it does not seem
> to be caused by the module.
> 
> If the module would be misbehaving in general it would never pass the sm
> check and thus be entirely unusable. Which though is not the case.
> 
> Suppose I have just to wait with fingers crossed that maybe at some point in
> the future the issue stops somehow, considering:
> 
> - the module may not meet SFP MSA 100%, though that MSA with "shall" and/or
> "may" wording does not appear obligatory and leaves wiggle room
> - the chipset designer / manufacturer may not provide all necessary
> documentation in the public domain a/o with GPL license
> - the vendor distributing the module cannot be bothered with support
> - downstream distros building from upstream source likely lacking the
> resources to look into this and anyway not patching SPF.C in the first place
> - upstream development has provided the most extensive support, trying to
> get to the bottom of it, and concluding the module misbehaving

Okay, I give up trying to help you.  Sorry, but I've spent a lot of
time over the last two days trying to help and explain stuff, and
you seem to want to constantly tell me I'm wrong, or misreading what
you're saying, or that there's some problem with the "sm check"
when I've already pointed out is a figment of your imagination.

Given also that your UTF-8 in your From: line _really_ screws up the
index in my mutt mail reader on the Linux console, disrupting my
ability to read other emails, it's now time for me to call an end to
this.

Sorry, but I'm not prepared to help any further.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
