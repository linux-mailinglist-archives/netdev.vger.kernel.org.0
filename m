Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661D61373BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgAJQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:32:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44316 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgAJQcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:32:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fRBW+4qoW/E2RVp3mym6d/PdBOR1TGV/BbVw797KMvM=; b=yiJvYX+jIMpRw+wOTS6HKYPUh
        Ktr2Na0FVUttgGQI4tA/UamsT8qEHUuHnpRXqcjk37/OTrvAAW43Y8jEQzuJ3gSL+H17i7joQaFmm
        lT4soQGeST1V0FZYO/xdLxkNRIpci5lHV0SJdzbblO0Lj6/GU4MstOD6XHpvJLX8rMEh3kPHtZVdl
        K+LsOxLn6sdvhda0RUH9og3aqtgcx2pTgZUvIUBIO6X6MfgMqi4jpsiGnUuwty0Pz5HtPQsdqmz16
        U40bR0iHtTC1VzeqDNJGSDvJOZWkbAsEP0lu31qNGslRFu2RTObv8/prGYyRJ224LfE4ZkQjymjEU
        KYYljxehw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53164)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipxDA-0004EF-OI; Fri, 10 Jan 2020 16:32:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipxD9-0001eQ-6U; Fri, 10 Jan 2020 16:32:35 +0000
Date:   Fri, 10 Jan 2020 16:32:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110163235.GG25745@shell.armlinux.org.uk>
References: <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 03:45:15PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 10/01/2020 15:09, Russell King - ARM Linux admin wrote:
> > On Fri, Jan 10, 2020 at 03:02:51PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > On 10/01/2020 12:53, Russell King - ARM Linux admin wrote:
> > > > > > Which is also indicating everything is correct. When the problem
> > > > > > occurs, check the state of the signals again as close as possible
> > > > > > to the event - it depends how long the transceiver keeps it
> > > > > > asserted. You will probably find tx-fault is indicating
> > > > > > "in hi IRQ".
> > > > > just discovered userland - gpioinfo pca9538 - which seems more verbose
> > > > > 
> > > > > gpiochip2 - 8 lines:
> > > > >         line   0:      unnamed   "tx-fault"   input active-high [used]
> > > > >         line   1:      unnamed "tx-disable"  output active-high [used]
> > > > >         line   2:      unnamed "rate-select0" input active-high [used]
> > > > >         line   3:      unnamed        "los"   input active-high [used]
> > > > >         line   4:      unnamed   "mod-def0"   input active-low [used]
> > > > >         line   5:      unnamed       unused   input active-high
> > > > >         line   6:      unnamed       unused   input active-high
> > > > >         line   7:      unnamed       unused   input active-high
> > > > > 
> > > > > The above is depicting the current state with the module
> > > > > working, i.e. being
> > > > > online. Will do some testing and report back, not sure yet
> > > > > how to keep a
> > > > > close watch relating to the failure events.
> > > > However, that doesn't give the current levels of the inputs, so it's
> > > > useless for the purpose I've asked for.
> > > Fair enough. Operational (online) state
> > > 
> > > gpiochip2: GPIOs 504-511, parent: i2c/8-0071, pca9538, can sleep:
> > >  gpio-504 ( |tx-fault     ) in  lo IRQ
> > >  gpio-505 ( |tx-disable   ) out lo
> > >  gpio-506 ( |rate-select0 ) in  lo
> > >  gpio-507 ( |los          ) in  lo IRQ
> > >  gpio-508 ( |mod-def0     ) in  lo IRQ
> > > 
> > > And the same remained (unchanged) during/after the events (as
> > > closely I was
> > > able to monitor) -> module transmit fault indicated
> > Try:
> > 
> > while ! grep -A4 'tx-fault.*in hi' /sys/kernel/debug/gpio; do :; done
> > 
> > which may have a better chance of catching it.
> > 
> 
> Suppose you are not interested in what happens with ifdown wan, so just for
> posterity
> 
>  gpio-504 (                    |tx-fault            ) in  hi IRQ
>  gpio-505 (                    |tx-disable          ) out hi
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ

Right, because the state of TX_FAULT is not defined while TX_DISABLE
is high.

> When the iif is brought up again and happens to trigger a transmit fault the
> hi is not being triggered however. And it did not try 5 times to recover
> from the fault, unless dmesg missed some
> 
> [Fri Jan 10 15:30:57 2020] mvneta f1034000.ethernet eth2: Link is Down
> [Fri Jan 10 15:30:57 2020] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not
> ready

Here is where you brought the interface down.

> [Fri Jan 10 15:31:13 2020] mvneta f1034000.ethernet eth2: configuring for
> inband/1000base-x link mode

Here is where you brought the interface back up.

> [Fri Jan 10 15:31:13 2020] sfp sfp: module transmit fault indicated

The module failed to deassert TX_FAULT within the 300ms window.

> [Fri Jan 10 15:31:15 2020] mvneta f1034000.ethernet eth2: Link is Up -
> 1Gbps/Full - flow control off
> [Fri Jan 10 15:31:16 2020] sfp sfp: module transmit fault recovered

I'm not sure why these two messages are this way round; they should
be the other way (I guess that's something to do with printk() no
longer being synchronous.)  Given that it seems to have taken two
seconds to recover, that will be two reset attempts.

> [Fri Jan 10 15:31:16 2020] mvneta f1034000.ethernet eth2: Link is Down
> [Fri Jan 10 15:31:16 2020] sfp sfp: module transmit fault indicated

The module re-asserts TX_FAULT...

> [Fri Jan 10 15:31:19 2020] sfp sfp: module persistently indicates fault,
> disabling

After another three attempts, the module is still asserting TX_FAULT.

We don't report every attempt made to recover the fault; that would
flood the log.  Instead, we report when the fault occurred, then try
to reset the fault every second for up to five attempts _total_.  If
we exhaust the attempts, you get "module persistently indicates fault,
disabling".  If successfully recovered, you'll get "module transmit
fault recovered".

We don't reset the retries after a successful recovery as that would
mean a transitory safety fault occurring once every few seconds would
endlessly fill the kernel log, and also may go unnoticed.  If it's
spitting out safety faults like that, the module would be faulty.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
