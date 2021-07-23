Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973DD3D402C
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhGWRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:31:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhGWRbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 13:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SnyKszF9IGSCnB8C8UzqAvlywVOYc6keZr8Q4pVBP2M=; b=Fz+0iC28NzKyE1hGtIcZm6gFda
        LgMBIXhcaRp1vC20+uV1rfB5Fyyh6Ey9TcktgodqzOgG7FHc2NJquhXR9DVRlXrkVIeYhNKChBMpM
        dJ8sjQ28eILXLGvvNEbl8egz+pPhIJTagt3o7F1uzHi/Bizs3R4JMCeXaKuPYELrbVyU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6zeX-00EX8N-93; Fri, 23 Jul 2021 20:12:05 +0200
Date:   Fri, 23 Jul 2021 20:12:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <YPsGddTXtk/Hinmp@lunn.ch>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
 <YPrCiIz7baU26kLU@lunn.ch>
 <20210723170848.lh3l62l7spcyphly@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723170848.lh3l62l7spcyphly@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 07:08:49PM +0200, Oleksij Rempel wrote:
> Hi Andrew,
> 
> On Fri, Jul 23, 2021 at 03:22:16PM +0200, Andrew Lunn wrote:
> > On Fri, Jul 23, 2021 at 12:42:18PM +0200, Oleksij Rempel wrote:
> > > The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> > > that supports 10M single pair cable.
> > > 
> > > This driver provides basic support for this chip:
> > > - link status
> > > - autoneg can be turned off
> > > - master/slave can be configured to be able to work without autoneg
> > > 
> > > This driver and PHY was tested with ASIX AX88772B USB Ethernet controller.
> > 
> > Hi Oleksij
> > 
> > There were patches flying around recently for another T1L PHY which
> > added new link modes. Please could you work together with that patch
> > to set the phydev features correctly to indicate this PHY is also a
> > T1L, and if it support 2.4v etc.
> 
> ACK, thx. I was not able to spend enough time to investigate all needed
> caps, so I decided to go mainline with limited functionality first.

Limited functionality is fine, but what is implemented should be
correct. And from what i see in the patch, it is hard to know if the
PHYs basic features are correctly determined. What does ethtool show?
Is 100BaseT being offered? Half duplex?

> voltage depends on the end application: cable length, safety requirements. I do
> not see how this can be chosen only on auto negotiation. We would need proper
> user space interface to let user/integrator set the limits.

I think we are talking at cross purposes here. As far as i understand
T1L supports the data signals to be 2.4Vpp as well as the usual
1Vpp. This is something which can be negotiated in the same way as
master/slave, duplex etc.

I suspect you are talking about the PoE aspects. That is outside the
scope for phylib. PoE in general is not really supported in the Linux
kernel, and probably needs a subsystem of its own.

   Andrew
