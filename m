Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6992349BF
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbgGaQy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:54:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729902AbgGaQy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 12:54:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1YJ5-007ioC-JJ; Fri, 31 Jul 2020 18:54:55 +0200
Date:   Fri, 31 Jul 2020 18:54:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, calvin.johnson@oss.nxp.com,
        kuldip.dwivedi@puresoftware.com, madalin.bucur@oss.nxp.com,
        vikas.singh@nxp.com
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of
 ACPI probe
Message-ID: <20200731165455.GD1748118@lunn.ch>
References: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:41:38PM +0530, Vikas Singh wrote:
> Auto-probe of c45 devices with extended scanning in xgmac_mdio works
> well but fails to update device "fwnode" while registering PHYs on
> MDIO bus.
> This patch is based on https://www.spinics.net/lists/netdev/msg662173.html
> 
> This change will update the "fwnode" while PHYs get registered and allow
> lookup for registered PHYs on MDIO bus from other drivers while probing.
> 
> Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
> ---
>  drivers/net/phy/mdio_bus.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 46b3370..7275eff 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -447,8 +447,25 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,

Why would a function called of_mdiobus_link_mdiodev() be poking
around trying to find ACPI properties?

       Andrew
