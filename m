Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5E1370C1
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgAJPKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:10:00 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43088 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgAJPKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PVyKfU0KOZ8gGL+Fu9Gf5V5KBaRlg+OZhwYsGtQNLeg=; b=RoVDgKIQmZXTbsYZ4MUwkra/Y
        2iFJcyHD+ih94VW9ETez2d44tI1CK/mMoC32e1FZmdUNiEGafEBW6eJHZmjKSclFto8Jhq+l0uAHe
        cOOsFjVgCpZd869wnrFCFzik9zXojmVTgDYqUWBEO4tM6QUBohJb22vHuhlUKMTKoBWDVUa5UxjvW
        YuCPxba+KK9ZLyOPP+TYxRocUOF5HCwrLLe3jG02K6YOkam3VsKe3jaAj2Mq0tBPcSgCLWYZluIHB
        lqFiMKEptZnFNDWCj4+Z8lICNwHcjFL7T2NipIJXlIdJMHZE79zGD+4FxRaILglMQX2pEkS2jC4tG
        2XC4txbFQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53136)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipvvA-0003nF-Bg; Fri, 10 Jan 2020 15:09:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipvv9-0001bo-OV; Fri, 10 Jan 2020 15:09:55 +0000
Date:   Fri, 10 Jan 2020 15:09:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110150955.GE25745@shell.armlinux.org.uk>
References: <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 03:02:51PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 10/01/2020 12:53, Russell King - ARM Linux admin wrote:
> > 
> > > > Which is also indicating everything is correct.  When the problem
> > > > occurs, check the state of the signals again as close as possible
> > > > to the event - it depends how long the transceiver keeps it
> > > > asserted.  You will probably find tx-fault is indicating
> > > > "in  hi IRQ".
> > > just discovered userland - gpioinfo pca9538 - which seems more verbose
> > > 
> > > gpiochip2 - 8 lines:
> > >          line   0:      unnamed   "tx-fault"   input  active-high [used]
> > >          line   1:      unnamed "tx-disable"  output  active-high [used]
> > >          line   2:      unnamed "rate-select0" input active-high [used]
> > >          line   3:      unnamed        "los"   input  active-high [used]
> > >          line   4:      unnamed   "mod-def0"   input   active-low [used]
> > >          line   5:      unnamed       unused   input  active-high
> > >          line   6:      unnamed       unused   input  active-high
> > >          line   7:      unnamed       unused   input  active-high
> > > 
> > > The above is depicting the current state with the module working, i.e. being
> > > online. Will do some testing and report back, not sure yet how to keep a
> > > close watch relating to the failure events.
> > However, that doesn't give the current levels of the inputs, so it's
> > useless for the purpose I've asked for.
> 
> Fair enough. Operational (online) state
> 
> gpiochip2: GPIOs 504-511, parent: i2c/8-0071, pca9538, can sleep:
>  gpio-504 ( |tx-fault     ) in  lo IRQ
>  gpio-505 ( |tx-disable   ) out lo
>  gpio-506 ( |rate-select0 ) in  lo
>  gpio-507 ( |los          ) in  lo IRQ
>  gpio-508 ( |mod-def0     ) in  lo IRQ
> 
> And the same remained (unchanged) during/after the events (as closely I was
> able to monitor) -> module transmit fault indicated

Try:

while ! grep -A4 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done

which may have a better chance of catching it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
