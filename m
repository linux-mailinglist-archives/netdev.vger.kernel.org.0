Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABE213D95
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 07:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfEEFlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 01:41:35 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55405 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfEEFle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 01:41:34 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hN9tp-0000vQ-Py; Sun, 05 May 2019 07:41:21 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hN9tn-0007wk-6c; Sun, 05 May 2019 07:41:19 +0200
Date:   Sun, 5 May 2019 07:41:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Chuanhong Guo <gch981213@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/3] net: ethernet: add ag71xx driver
Message-ID: <20190505054119.ac3jxtonkpn4pszn@pengutronix.de>
References: <20190422064046.2822-1-o.rempel@pengutronix.de>
 <20190422064046.2822-4-o.rempel@pengutronix.de>
 <20190422132533.GA12718@lunn.ch>
 <CAJsYDVJ84RsNVe9Mj9sYYwwLmmMkinRSJW4ziW22Sf04wS5gyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsYDVJ84RsNVe9Mj9sYYwwLmmMkinRSJW4ziW22Sf04wS5gyw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:36:45 up 106 days, 10:18, 78 users,  load average: 0.00, 0.00,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 04, 2019 at 11:40:53PM +0800, Chuanhong Guo wrote:
> Hi!
> 
> On Mon, Apr 22, 2019 at 9:28 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > [...]
> > > +     /*
> > > +      * On most (all?) Atheros/QCA SoCs dual eth interfaces are not equal.
> > > +      *
> > > +      * That is to say eth0 can not work independently. It only works
> > > +      * when eth1 is working.
> > > +      */
> >
> > Please could you explain that some more? Is there just one MDIO bus
> > shared by two ethernet controllers? If so, it would be better to have
> > the MDIO bus controller as a separate driver.
> 
> mdio registers exists on both ethernet blocks. And due to how reset
> works on this ethernet IP, it's hard to split it into a separated
> driver. (Only asserting both eth and mdio resets together will reset
> everything including register values.)
> The reason why gmac1 should be brought up first is that on some chips,
> mdio on gmac0 connects to nothing and phy used by gmac0 is on mdio bus
> of gmac1.

It could be implemented as mfd device. Not sure if it is worth it.
Pro/contra argumentation is welcome.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
