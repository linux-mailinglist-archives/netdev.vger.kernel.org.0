Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57811355FE0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245183AbhDGAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:10:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235870AbhDGAKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:10:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTvm4-00FDVE-HV; Wed, 07 Apr 2021 02:10:24 +0200
Date:   Wed, 7 Apr 2021 02:10:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 04/18] net: phy: marvell10g: indicate 88X33x0
 only port control registers
Message-ID: <YGz4cIxizCjuEXNM@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406221107.1004-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -479,8 +479,8 @@ static int mv3310_config_init(struct phy_device *phydev)
>  	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
>  	if (val < 0)
>  		return val;
> -	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
> -			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
> +	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
> +			MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH);
>  
>  	/* Enable EDPD mode - saving 600mW */
>  	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
> -- 

So it appears that mv3310_config_init() should not be used with the
mv88x2110. Did i miss somewhere where mv3310_drivers was changed so it
actually does not use it?

	 Andrew
