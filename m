Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EEF51BEFB
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359821AbiEEMQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376445AbiEEMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:16:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2504E14007
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 05:12:52 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmaLa-0002HT-15; Thu, 05 May 2022 14:12:42 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmaLZ-0002cd-4m; Thu, 05 May 2022 14:12:41 +0200
Date:   Thu, 5 May 2022 14:12:41 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20220505121241.GA19896@pengutronix.de>
References: <20220505063318.296280-1-o.rempel@pengutronix.de>
 <20220505063318.296280-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220505063318.296280-8-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:11:52 up 36 days, 41 min, 82 users,  load average: 0.25, 0.18,
 0.15
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 08:33:18AM +0200, Oleksij Rempel wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> This driver was tested with NXP SJA1105, STMMAC and ASIX AX88772B USB Ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/Kconfig     |   6 ++
>  drivers/net/phy/Makefile    |   1 +
>  drivers/net/phy/dp83td510.c | 210 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 217 insertions(+)
>  create mode 100644 drivers/net/phy/dp83td510.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index bbbf6c07ea53..9fee639ee5c8 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -342,6 +342,12 @@ config DP83869_PHY
>  	  Currently supports the DP83869 PHY.  This PHY supports copper and
>  	  fiber connections.
>  
> +config DP83TD510_PHY
> +	tristate "Texas Instruments DP83TD510 Ethernet 10Base-T1L PHY"
> +	help
> +	  Support for the DP83TD510 Ethernet 10Base-T1L PHY. This PHY supports
> +	  a 10M single pair Ethernet connection for up to 1000 meter cable.
> +
>  config VITESSE_PHY
>  	tristate "Vitesse PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b82651b57043..b12b1d86fc99 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
>  obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
>  obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
>  obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
> +obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
>  obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
>  obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
>  obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
> diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
> new file mode 100644
> index 000000000000..5c3251602e4a
> --- /dev/null
> +++ b/drivers/net/phy/dp83td510.c
> @@ -0,0 +1,210 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Driver for the Texas Instruments DP83TD510 PHY
> + * Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define DP83TD510E_PHY_ID			0x20000181
> +
> +/* MDIO_MMD_VEND2 registers */
> +#define DP83TD510E_PHY_STS			0x10
> +#define DP83TD510E_STS_MII_INT			BIT(7)
> +#define DP83TD510E_LINK_STATUS			BIT(0)
> +
> +#define DP83TD510E_GEN_CFG			0x11
> +#define DP83TD510E_GENCFG_INT_POLARITY		BIT(3)
> +#define DP83TD510E_GENCFG_INT_EN		BIT(1)
> +#define DP83TD510E_GENCFG_INT_OE		BIT(0)
> +
> +#define DP83TD510E_INTERRUPT_REG_1		0x12
> +#define DP83TD510E_INT1_LINK			BIT(13)
> +#define DP83TD510E_INT1_LINK_EN			BIT(5)
> +
> +#define DP83TD510E_AN_STAT_1			0x60c
> +#define DP83TD510E_MASTER_SLAVE_RESOL_FAIL	BIT(15)
> +
> +static int dp83td510_config_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		/* Clear any pending interrupts */
> +		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
> +				    0x0);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
> +				    DP83TD510E_INTERRUPT_REG_1,
> +				    DP83TD510E_INT1_LINK_EN);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       DP83TD510E_GEN_CFG,
> +				       DP83TD510E_GENCFG_INT_POLARITY |
> +				       DP83TD510E_GENCFG_INT_EN |
> +				       DP83TD510E_GENCFG_INT_OE);
> +	} else {
> +		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
> +				    DP83TD510E_INTERRUPT_REG_1, 0x0);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 DP83TD510E_GEN_CFG,
> +					 DP83TD510E_GENCFG_INT_EN);
> +		if (ret)
> +			return ret;
> +
> +		/* Clear any pending interrupts */
> +		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
> +				    0x0);
> +	}
> +
> +	return ret;
> +}
> +
> +static irqreturn_t dp83td510_handle_interrupt(struct phy_device *phydev)
> +{
> +	int  ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS);
> +	if (ret < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	} else if (!(ret & DP83TD510E_STS_MII_INT)) {
> +		return IRQ_NONE;
> +	}
> +
> +	/* Read the current enabled interrupts */
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_INTERRUPT_REG_1);
> +	if (ret < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	} else if (!(ret & DP83TD510E_INT1_LINK_EN) ||
> +		   !(ret & DP83TD510E_INT1_LINK)) {
> +		return IRQ_NONE;
> +	}
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int dp83td510_read_status(struct phy_device *phydev)
> +{
> +	u16 phy_sts;
> +	int ret, cfg;

Heh, here is unused variable. Need to fix it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
