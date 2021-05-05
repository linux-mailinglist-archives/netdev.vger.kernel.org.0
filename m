Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED99373B16
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhEEMZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:25:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232314AbhEEMZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 08:25:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1leGZr-002fb1-Lj; Wed, 05 May 2021 14:24:31 +0200
Date:   Wed, 5 May 2021 14:24:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH v1 1/9] net: phy: micrel: move phy reg offsets to
 common header
Message-ID: <YJKOf3hs/ApJt3hz@lunn.ch>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505092025.8785-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define PHY_REG_CTRL			0

MII_BMCR

> +
> +#define PHY_RESET			BIT(15)
> +#define PHY_LOOPBACK			BIT(14)
> +#define PHY_SPEED_100MBIT		BIT(13)
> +#define PHY_AUTO_NEG_ENABLE		BIT(12)
> +#define PHY_POWER_DOWN			BIT(11)
> +#define PHY_MII_DISABLE			BIT(10)
> +#define PHY_AUTO_NEG_RESTART		BIT(9)
> +#define PHY_FULL_DUPLEX			BIT(8)
> +#define PHY_COLLISION_TEST_NOT		BIT(7)

All the above appear to be standard BMCR bits. Please use the existing
#defines in include/uapi/linux/mii.h

> +#define PHY_HP_MDIX			BIT(5)
> +#define PHY_FORCE_MDIX			BIT(4)
> +#define PHY_AUTO_MDIX_DISABLE		BIT(3)
> +#define PHY_REMOTE_FAULT_DISABLE	BIT(2)
> +#define PHY_TRANSMIT_DISABLE		BIT(1)
> +#define PHY_LED_DISABLE			BIT(0)

Since you are moving into a global scope header, please add a device
prefix.

> +
> +#define PHY_REG_STATUS			1

MII_BMSR

> +
> +#define PHY_100BT4_CAPABLE		BIT(15)
> +#define PHY_100BTX_FD_CAPABLE		BIT(14)
> +#define PHY_100BTX_CAPABLE		BIT(13)
> +#define PHY_10BT_FD_CAPABLE		BIT(12)
> +#define PHY_10BT_CAPABLE		BIT(11)
> +#define PHY_MII_SUPPRESS_CAPABLE_NOT	BIT(6)
> +#define PHY_AUTO_NEG_ACKNOWLEDGE	BIT(5)
> +#define PHY_REMOTE_FAULT		BIT(4)
> +#define PHY_AUTO_NEG_CAPABLE		BIT(3)
> +#define PHY_LINK_STATUS			BIT(2)
> +#define PHY_JABBER_DETECT_NOT		BIT(1)
> +#define PHY_EXTENDED_CAPABILITY		BIT(0)

These also look to be pretty standard BMSR defines.

> +
> +#define PHY_REG_ID_1			2
> +#define PHY_REG_ID_2			3

MII_PHYSID1 & MII_PHYSID2

Please remove everything which directly matches the existing defines.
Just add defines for bits which don't follow 802.3 c22.

     Andrew
