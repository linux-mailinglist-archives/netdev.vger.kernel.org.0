Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890741BE621
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2SVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:21:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2SVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eGrD9gWsPxDdIMlmEz+zsRQrJkSuovhNPiqpGuaq0OE=; b=nyJODUDcFVQeP/x9Cg3ogEukB1
        Zbhd3+Da+qdchlKxXx5sm1p14w4FomScjBrio1YrT9MB8p2Vj+6TehXLEVhjxHB+N3fKo112uXB86
        RE21qu4BmFfOC4gilIYfe7whPyzw6IOFobeO+kYV5gIotI4q28Pt153x/xlEb1kL/DSY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTrKH-000J12-L5; Wed, 29 Apr 2020 20:20:53 +0200
Date:   Wed, 29 Apr 2020 20:20:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 2/2] net: phy: tja11xx: add support for
 master-slave configuration
Message-ID: <20200429182053.GM30459@lunn.ch>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428075308.2938-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int tja11xx_config_aneg(struct phy_device *phydev)
> +{
> +	u16 ctl = 0;
> +	int ret;
> +
> +	switch (phydev->master_slave_set) {
> +	case PORT_MODE_CFG_MASTER_FORCE:
> +	case PORT_MODE_CFG_MASTER_PREFERRED:
> +		ctl |= MII_CFG1_MASTER_SLAVE;
> +		break;
> +	case PORT_MODE_CFG_SLAVE_FORCE:
> +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> +		break;
> +	case PORT_MODE_CFG_UNKNOWN:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -ENOTSUPP;
> +	}

Does the hardware actually support PORT_MODE_CFG_SLAVE_PREFERRED and
PORT_MODE_CFG_MASTER_PREFERRED? I thought that required autoneg, which
this PHY does not support? So i would of expected these two values to
return ENOTSUPP?

       Andrew
