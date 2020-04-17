Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8D91AE5EF
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgDQTjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:39:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbgDQTjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5wbOmjfBKlirMRvp5xkC4Vfb3UzqF4kW6GaX+rtLC0w=; b=MysNWm+Y2KusXIbmHXxDn1//Qv
        lmbrRrLEkeVCG+iEB0C0OrfMinRn1UVeI6mD+HHpRourTk3OftiF7Lz3FKcGF89362FLHYkjt1Nxz
        DIuA5NLySaGnnqp7dNYaGovpinRPtaPD2Qb9+KeQUBxfC4d6VEvx+/2ETsh4TwlDY808=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPWpN-003LEM-6k; Fri, 17 Apr 2020 21:39:05 +0200
Date:   Fri, 17 Apr 2020 21:39:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: phy: add Broadcom BCM54140 support
Message-ID: <20200417193905.GF785713@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417192858.6997-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 09:28:57PM +0200, Michael Walle wrote:

> +static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
> +{
> +	struct bcm54140_phy_priv *priv = phydev->priv;
> +	struct mii_bus *bus = phydev->mdio.bus;
> +	int addr, min_addr, max_addr;
> +	int step = 1;
> +	u32 phy_id;
> +	int tmp;
> +
> +	min_addr = phydev->mdio.addr;
> +	max_addr = phydev->mdio.addr;
> +	addr = phydev->mdio.addr;
> +
> +	/* We scan forward and backwards and look for PHYs which have the
> +	 * same phy_id like we do. Step 1 will scan forward, step 2
> +	 * backwards. Once we are finished, we have a min_addr and
> +	 * max_addr which resembles the range of PHY addresses of the same
> +	 * type of PHY. There is one caveat; there may be many PHYs of
> +	 * the same type, but we know that each PHY takes exactly 4
> +	 * consecutive addresses. Therefore we can deduce our offset
> +	 * to the base address of this quad PHY.
> +	 */

Hi Michael

How much flexibility is there in setting the base address using
strapping etc? Is it limited to a multiple of 4?

