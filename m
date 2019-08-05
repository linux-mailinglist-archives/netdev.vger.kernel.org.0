Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7181FF3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfHEPRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:17:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfHEPRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kQntIczxltjRO+CoHAjfAguUpoFs+LsiO0HmyFytLYg=; b=Wvg1k6auDTfCMs8bc8SewCGOJ/
        L/K1dWT7yfXpNb2mSMn9+XIUghZBXu/DK3HjLwWDrI3gbu01hmSWL2EnrFirl+dH9AK5q05kXEJ0h
        Z7oLSqAy+APSa23YNI+LzwXAqNm6pk0nJ/P9B+B5kUIet4WDgKqQ+fh3rcMCFgsOm5t0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huejw-0007oz-Fl; Mon, 05 Aug 2019 17:17:36 +0200
Date:   Mon, 5 Aug 2019 17:17:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices PHYs
Message-ID: <20190805151736.GQ24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct phy_driver adin_driver[] = {
> +	{
> +		.phy_id		= PHY_ID_ADIN1200,
> +		.name		= "ADIN1200",
> +		.phy_id_mask	= 0xfffffff0,
> +		.features	= PHY_BASIC_FEATURES,

Do you need this? If the device implements the registers correctly,
phylib can determine this from the registers.

> +		.config_init	= adin_config_init,
> +		.config_aneg	= genphy_config_aneg,
> +		.read_status	= genphy_read_status,
> +	},
> +	{
> +		.phy_id		= PHY_ID_ADIN1300,
> +		.name		= "ADIN1300",
> +		.phy_id_mask	= 0xfffffff0,
> +		.features	= PHY_GBIT_FEATURES,

same here.

> +		.config_init	= adin_config_init,
> +		.config_aneg	= genphy_config_aneg,
> +		.read_status	= genphy_read_status,
> +	},
> +};
> +
> +module_phy_driver(adin_driver);
> +
> +static struct mdio_device_id __maybe_unused adin_tbl[] = {
> +	{ PHY_ID_ADIN1200, 0xfffffff0 },
> +	{ PHY_ID_ADIN1300, 0xfffffff0 },

PHY_ID_MATCH_VENDOR().

	Andrew
