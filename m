Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA42DC3B7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgLPQFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:05:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgLPQFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 11:05:37 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpZIF-00CJSy-3I; Wed, 16 Dec 2020 17:04:47 +0100
Date:   Wed, 16 Dec 2020 17:04:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 1/2] net: phy: mchp: Add interrupt support
 for Link up and Link down to LAN8814 phy
Message-ID: <20201216160447.GJ2901580@lunn.ch>
References: <20201216152528.6457-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216152528.6457-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status;
> +
> +	irq_status = phy_read(phydev, LAN8814_INTS);
> +	if (irq_status < 0)
> +		return IRQ_NONE;
> +
> +	if (irq_status & LAN8814_INTS_ALL)
> +		phy_mac_interrupt(phydev);

This is a PHY driver, so it should not be using the MAC API
call. Please change to

phy_trigger_machine(phydev);

	Andrew
