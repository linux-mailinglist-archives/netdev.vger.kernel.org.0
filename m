Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B472EB18A
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbhAERiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:38:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbhAERiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:38:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwqHY-00GCrG-5S; Tue, 05 Jan 2021 18:38:08 +0100
Date:   Tue, 5 Jan 2021 18:38:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] [RFC] net: phy: smsc: Add magnetics VIO regulator support
Message-ID: <X/SkAOV6s9vbSYh1@lunn.ch>
References: <20210105161533.250865-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105161533.250865-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void smsc_link_change_notify(struct phy_device *phydev)
> +{
> +	struct smsc_phy_priv *priv = phydev->priv;
> +
> +	if (!priv->vddio)
> +		return;
> +
> +	if (phydev->state == PHY_HALTED)
> +		regulator_disable(priv->vddio);
> +
> +	if (phydev->state == PHY_NOLINK)
> +		regulator_enable(priv->vddio);

NOLINK is an interesting choice. Could you explain that please.

I fear this is not going to be very robust to state machine
changes. And since it is hidden away in a driver, it is going to be
forgotten about. You might want to think about making it more robust.

	  Andrew
