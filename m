Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E57F1D3CFE
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgENTLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:11:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgENSwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Za+3ZMb7xHzue8msAwcSz9/IVxF8Kntejn/v5bSVMY=; b=k5pArpMPipxHuMUO1R7sFONOXr
        tIofq8Qa5rrQaoggQXefTCyyk0ryRf+rfm/EKa60JtlZVA/1gH2yJe3AVEqOZL/MOeTfnQCr5CWqB
        p44gcsQYsft64KdGT5qvpcDXPKOQD9qTOEArhRNDM+5/0E+5pU8pU3VyoErHvTkscd2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZIxt-002JVc-4J; Thu, 14 May 2020 20:52:17 +0200
Date:   Thu, 14 May 2020 20:52:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: DP83822: Add ability to advertise
 Fiber connection
Message-ID: <20200514185217.GX499265@lunn.ch>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514173055.15013-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dp83822_config_init(struct phy_device *phydev)
> +{
> +	struct dp83822_private *dp83822 = phydev->priv;
> +	int err = 0;
> +
> +	if (dp83822->fx_enabled) {
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->advertising);
> +
> +		/*  Auto negotiation is not available in fiber mode */
> +		phydev->autoneg = AUTONEG_DISABLE;
> +		phydev->speed = SPEED_100;
> +		phydev->duplex = DUPLEX_FULL;

Hi Dan

This is normally determined by reading the ability registers,
genphy_read_abilities(). When strapped to fibre mode, does it still
indicate all the usual copper capabilities, which it can not actually
do?

	Andrew
