Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883ED31A18D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhBLPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:23:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhBLPVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 10:21:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAaF9-005qpk-Ms; Fri, 12 Feb 2021 16:20:27 +0100
Date:   Fri, 12 Feb 2021 16:20:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Message-ID: <YCacux8K+ocWbRQ2@lunn.ch>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:06:41PM +0100, Bjarni Jonasson wrote:
> +static u32 vsc85xx_csr_read(struct phy_device *phydev,
> +			    enum csr_target target, u32 reg);
> +static int vsc85xx_csr_write(struct phy_device *phydev,
> +			     enum csr_target target, u32 reg, u32 val);
> +

Hi Bjarni

No forward definitions please. Move the code around so they are not
required. Sometimes it is best to do such a move as a preparation
patch.

> @@ -1569,8 +1664,16 @@ static int vsc8514_config_pre_init(struct phy_device *phydev)
>  		{0x16b2, 0x00007000},
>  		{0x16b4, 0x00000814},
>  	};
> +	struct device *dev = &phydev->mdio.dev;
>  	unsigned int i;
>  	u16 reg;
> +	int ret;

Hard to say from the limited context, but is reverse christmass tree
being preserved here?

      Andrew
