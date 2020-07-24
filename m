Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8397722C5D5
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGXNLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:11:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53552 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgGXNLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:11:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyxTa-006g07-6H; Fri, 24 Jul 2020 15:11:02 +0200
Date:   Fri, 24 Jul 2020 15:11:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek Behun <marek.behun@nic.cz>, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 1/1] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200724131102.GD1472201@lunn.ch>
References: <20200723181319.15988-1-marek.behun@nic.cz>
 <20200723181319.15988-2-marek.behun@nic.cz>
 <20200723213531.GK1553578@lunn.ch>
 <20200724005349.2e90a247@nic.cz>
 <20200724102403.wyuteeql3jn5xouw@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724102403.wyuteeql3jn5xouw@duo.ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 12:24:03PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > I expect some of this should be moved into the phylib core. We don't
> > > want each PHY inventing its own way to do this. The core should
> > > provide a framework and the PHY driver fills in the gaps.
> > > 
> > > Take a look at for example mscc_main.c and its LED information. It has
> > > pretty similar hardware to the Marvell. And microchip.c also has LED
> > > handling, etc.
> > 
> > OK, this makes sense. I will have to think about this a little.
> > 
> > My main issue though is whether one "hw-control" trigger should be
> > registered via LED API and the specific mode should be chosen via
> > another sysfs file as in this RFC, or whether each HW control mode
> > should have its own trigger. The second solution would either result in
> > a lot of registered triggers or complicate LED API, though...
> 
> If you register say 5 triggers.... that's okay. If you do like 1024
> additional triggers (it happened before!)... well please don't.

Hi Pavel

There tends to be around 15 different blink patterns per LED. And
there can be 2 to 3 LEDs per PHY. The blink patterns can be different
per PHY, or they can be the same. For the Marvell PHY we are looking
at around 45. Most of the others PHYs tend to have the same patterns
for all LEDs, so 15 triggers could be shared.

But if you then think of a 10 port Ethernet switch, there could be 450
triggers, if the triggers are not shared at all.

So to some extent, it is a question of how much effort should be put
in to sharing triggers.

   Andrew
