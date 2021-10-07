Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275AE425F95
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbhJGWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:00:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhJGWAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 18:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GWWYbc2+vO/PEIHlMWF7rJOhS4dum7WGiKpMPll9bHA=; b=HDhxpnIBZ4XQF82MzQGKKwqEqs
        04BXQrj/oDbtSYXKJB1PSxSaElC2xy+PGr3hpsPyZfIrnqw3eZVFSPk2B95gZgvEjE7v8vKbUdawf
        qpjwobjxMcYOTtgUML00OyfWLyRQGgagygBCrrkFy7bSqZTbdEdjQ6HXj47pcyiMu9s4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYbPf-009zyW-NJ; Thu, 07 Oct 2021 23:58:51 +0200
Date:   Thu, 7 Oct 2021 23:58:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YV9tmyitHLlbV6XJ@lunn.ch>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-6-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct ksz_device *dev = bus->priv;
> +	u16 val;
> +	int ret;
> +

It would be good to check for C45 regnum values and return -EOPNOTSUPP.


> +	ret = lan937x_internal_phy_read(dev, addr, regnum, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
> +}
> +
> +static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
> +				 u16 val)
> +{
> +	struct ksz_device *dev = bus->priv;
> +

Same here.

     Andrew
