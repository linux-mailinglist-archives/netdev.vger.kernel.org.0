Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B46312D2D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhBHJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhBHJVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:21:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FA8C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 01:20:45 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l92in-0005yN-37; Mon, 08 Feb 2021 10:20:41 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1l92ik-0003fs-QN; Mon, 08 Feb 2021 10:20:38 +0100
Date:   Mon, 8 Feb 2021 10:20:38 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1 5/7] ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
Message-ID: <20210208092038.cjmnycyctsapgy7w@pengutronix.de>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
 <20210203091857.16936-6-o.rempel@pengutronix.de>
 <20210203095628.GP1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203095628.GP1463@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:03:28 up 67 days, 23:09, 39 users,  load average: 0.10, 0.07,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 09:56:28AM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Feb 03, 2021 at 10:18:55AM +0100, Oleksij Rempel wrote:
> > This fixup removes the Lpi_en bit.
> > 
> > If this patch breaks functionality of your board, use following device
> > tree properties:
> > 
> > 	ethernet-phy@X {
> > 		reg = <0xX>;
> > 		eee-broken-1000t;
> > 		eee-broken-100tx;
> > 		....
> > 	};
> 
> That is the historical fix for this problem, but there is a better
> solution now in net-next - configuring the Tw parameter for gigabit
> connections. That solves the random link drop issue when EEE is
> enabled.

Do you mean this properties?
  qca,smarteee-tw-us-1g
  qca,smarteee-tw-us-100m

Do you have some recommendations, which values can be here used? Are
they same for all MACs? Or, can we calculate this values automatically?

Beside, I have seen this patch: "ARM: dts: imx6qdl-sr-som: fix some
cubox-i platforms"

I had similar issue and it was triggered by the boot loader, which
enabled 60 Ohm on-die termination. The fix was to remove this lines in
the boot loader: wm 32 0x020e07ac 0x00000200 /* 60 Ohm ODT */

> Support for this configuration has only recently been merged into
> net-next and other trees for this merge window, so I ask that you
> hold off at least this patch until the next cycle.

ok.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
