Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17B225261
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgGSPFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:05:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgGSPFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 11:05:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxAs1-005srb-NY; Sun, 19 Jul 2020 17:04:53 +0200
Date:   Sun, 19 Jul 2020 17:04:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1] net: phy: at803x: add mdix configuration
 support for AR9331 and AR8035
Message-ID: <20200719150453.GE1383417@lunn.ch>
References: <20200719080530.24370-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719080530.24370-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 10:05:30AM +0200, Oleksij Rempel wrote:
> This patch add MDIX configuration ability for AR9331 and AR8035. Theoretically
> it should work on other Atheros PHYs, but I was able to test only this
> two.
> 
> Since I have no certified reference HW able to detect or configure MDIX, this
> functionality was confirmed by oscilloscope.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 78 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 96c61aa75bd7..101651b2de54 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -21,6 +21,17 @@
>  #include <linux/regulator/consumer.h>
>  #include <dt-bindings/net/qca-ar803x.h>
>  
> +#define AT803X_SPECIFIC_FUNCTION_CONTROL	0x10
> +#define AT803X_SFC_ASSERT_CRS			BIT(11)
> +#define AT803X_SFC_FORCE_LINK			BIT(10)
> +#define AT803X_SFC_MDI_CROSSOVER_MODE_M		GENMASK(6, 5)
> +#define AT803X_SFC_AUTOMATIC_CROSSOVER		0x3
> +#define AT803X_SFC_MANUAL_MDIX			0x1
> +#define AT803X_SFC_MANUAL_MDI			0x0

Interestingly, these are the same bits as for the Marvell PHY. I had a
quick look at 802.3. The functionality is standardized, but not the
registers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
