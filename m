Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF812B95EE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgKSPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:16:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgKSPQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 10:16:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kflft-007xDF-Qm; Thu, 19 Nov 2020 16:16:41 +0100
Date:   Thu, 19 Nov 2020 16:16:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201119151641.GJ1853236@lunn.ch>
References: <20201119152246.085514e1@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119152246.085514e1@bootlin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime

> The way this works is that the PHY is internally configured by chaining
> 2 internal PHYs back to back. One PHY deals with the Host interface and
> is configured as an SGMII to QSGMII converter (the QSGMII is only used
> from within the PHY), and the other PHY acts as the Media-side PHY,
> configured in QSGMII to auto-media (RJ45 or Fiber (SFP)) :
> 
>                 +- 88e1543 -----------------------+
> +-----+         | +--------+          +--------+  |  /-- Copper (RJ45)
> |     |--SGMII----| Port 0 |--QSGMII--| Port 1 |----<
> |     |         | +--------+          +--------+  |  \--- Fiber
> | MAC |         |                                 |
> |     |         | +--------+          +--------+  |  /-- Copper (RJ45)
> |     |--SGMII----| Port 2 |--QSGMII--| Port 3 |----<
> +-----+         | +--------+          +--------+  |  \-- Fiber
>                 +---------------------------------+

Does this mean you need a dual port MAC as well?

Do we need to configure the MUX in the MAC?

	  Andrew
