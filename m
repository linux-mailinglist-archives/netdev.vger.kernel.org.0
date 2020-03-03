Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED0177A18
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgCCPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:10:01 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35475 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729273AbgCCPKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:10:01 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 862F71C0003;
        Tue,  3 Mar 2020 15:09:59 +0000 (UTC)
Date:   Tue, 3 Mar 2020 16:09:58 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303150958.GD3179@kwain>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98m5-00057k-Q6@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1j98m5-00057k-Q6@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Tue, Mar 03, 2020 at 02:43:57PM +0000, Russell King wrote:
>  
> +static int mv3310_config_mdix(struct phy_device *phydev)
> +{
> +	u16 val;
> +	int err;
> +
> +	switch (phydev->mdix_ctrl) {
> +	case ETH_TP_MDI_AUTO:
> +		val = MV_PCS_CSCR1_MDIX_AUTO;
> +		break;
> +	case ETH_TP_MDI_X:
> +		val = MV_PCS_CSCR1_MDIX_MDIX;
> +		break;
> +	case ETH_TP_MDI:
> +		val = MV_PCS_CSCR1_MDIX_MDI;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
> +				     MV_PCS_CSCR1_MDIX_MASK, val);
> +	if (err < 0)
> +		return err;
> +
> +	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);

This helper is only introduced in patch 2.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
