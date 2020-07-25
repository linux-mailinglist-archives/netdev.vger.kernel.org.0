Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4E22D914
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgGYRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:48:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgGYRsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 13:48:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzOH8-006piy-Gj; Sat, 25 Jul 2020 19:47:58 +0200
Date:   Sat, 25 Jul 2020 19:47:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725174758.GM1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
 <20200725092339.GB29492@amd>
 <20200725113450.0d4c936b@nic.cz>
 <20200725150342.GG1472201@lunn.ch>
 <20200725193950.20cc9732@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200725193950.20cc9732@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 07:39:50PM +0200, Marek Behun wrote:
> On Sat, 25 Jul 2020 17:03:42 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > Does hi-z mean off? In the implementation i did, i did not list off
> > and on as triggers. I instead used them for untriggered
> > brightness. That allowed the software triggers to work, so i had the
> > PHY blinking the heartbeat etc. But i had to make it optional, since a
> > quick survey of datasheets suggested not all PHYs support simple
> > on/off control.
> 
> I don't actually know what hi-z means, but enabling it disabled the LED.
> But there is another register value for OFF...

Can the pin be used for other things? Maybe it needs to be configured
for high impedance when it is used as a shared interrupt?  If it does
not seem like a useful LED setting, i would drop it for the moment.

> > Something beyond the scope of this patchset is implementing etHool -p
> > 
> >        -p --identify
> >               Initiates adapter-specific action intended to enable an operator to
> > 	      easily identify the adapter by sight. Typically this involves  blink‐
> >               ing one or more LEDs on the specific network port.
> > 
> > If we have software controlled on/off, then a software trigger seems
> > like i good way to do this.
> 
> I'll look into this.

No rush. As i said, out of scope for this patchset. Just keep it in
mind. It should be something we can implement once in phylib, and then
all phy drivers which have LED support get it for free.

    Andrew
