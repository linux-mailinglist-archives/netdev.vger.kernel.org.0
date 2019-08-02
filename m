Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41857FC8C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395028AbfHBOuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:50:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbfHBOuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 10:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wFufv2A3VsleW9NhhqWmZQk/O8vzeBMOQMi+FRL3uZk=; b=sSq7JSiLEkL/Qu7pBt+3s/Obzj
        G8JwPwZS1T0WVqB57yZXxCvVf2QIIawUP6uxAzuXsQq0kzkgixEE5dG0/bwZeBJsAEYi4apzeYV+q
        AoKjNmoU+H7PbtN1VDnh/6vE0bi1lHbWKn/LJ4w1MHHyykhWmM2YgsOSAtjW4Z4wRUns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1htYsl-0001GD-Kc; Fri, 02 Aug 2019 16:50:11 +0200
Date:   Fri, 2 Aug 2019 16:50:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <taoren@fb.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next v2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Message-ID: <20190802145011.GH2099@lunn.ch>
References: <20190801235839.290689-1-taoren@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801235839.290689-1-taoren@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int bcm54616s_read_status(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = genphy_read_status(phydev);
> +
> +	/* 1000Base-X register set doesn't provide speed fields: the
> +	 * link speed is always 1000 Mb/s as long as link is up.
> +	 */
> +	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX &&
> +	    phydev->link)
> +		phydev->speed = SPEED_1000;
> +
> +	return err;
> +}

This function is equivalent to bcm5482_read_status(). You should use
it, rather than add a new function.

    Andrew
