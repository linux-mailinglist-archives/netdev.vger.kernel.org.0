Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DDE2B4605
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgKPOil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:38:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgKPOil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:38:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kefeI-007MMi-6h; Mon, 16 Nov 2020 15:38:30 +0100
Date:   Mon, 16 Nov 2020 15:38:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: lantiq: Wait for the GPHY firmware to be ready
Message-ID: <20201116143830.GD1716542@lunn.ch>
References: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 05:57:57PM +0100, Martin Blumenstingl wrote:
> A user reports (slightly shortened from the original message):
>   libphy: lantiq,xrx200-mdio: probed
>   mdio_bus 1e108000.switch-mii: MDIO device at address 17 is missing.
>   gswip 1e108000.switch lan: no phy at 2
>   gswip 1e108000.switch lan: failed to connect to port 2: -19
>   lantiq,xrx200-net 1e10b308.eth eth0: error -19 setting up slave phy
> 
> This is a single-port board using the internal Fast Ethernet PHY. The
> user reports that switching to PHY scanning instead of configuring the
> PHY within device-tree works around this issue.
> 
> The documentation for the standalone variant of the PHY11G (which is
> probably very similar to what is used inside the xRX200 SoCs but having
> the firmware burnt onto that standalone chip in the factory) states that
> the PHY needs 300ms to be ready for MDIO communication after releasing
> the reset.
> 
> Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
> firmware had enough time to initialize and to appear on the MDIO bus.
> Unfortunately there is no (known) documentation on what the minimum time
> to wait after releasing the reset on an internal PHY so play safe and
> take the one for the external variant. Only wait after the last GPHY
> firmware is loaded to not slow down the initialization too much (
> xRX200 has two GPHYs but newer SoCs have at least three GPHYs).
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
