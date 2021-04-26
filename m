Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334CA36B324
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhDZMfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:35:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhDZMfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 08:35:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lb0RV-001AEf-Pb; Mon, 26 Apr 2021 14:34:25 +0200
Date:   Mon, 26 Apr 2021 14:34:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YIazUePJiIe+fuPs@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
 <20210422195921.utxdh5dn4ddltxkf@skbuf>
 <YIIGmpea6Mf0yzYS@lunn.ch>
 <291ac605fe404b90c571f23f457f7f855eebf970.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291ac605fe404b90c571f23f457f7f855eebf970.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What do you think on the following code?
> 
> 	struct dsa_port *dp = dsa_to_port(dev->ds, port);
> 	struct phy_device *phy_dev = dp->slave->phydev;
> 	.
> 	.
> 	.
> 
>     	if (!phydev || phy_driver_is_genphy(phydev)) {
> 		/*Add RGMII internal delay*/
>     	}
 
 
phy_driver_is_genphy(phydev) is probably a bad idea. If you get a
delay depends on if they driver is available? I would prefer you
assume the PHY can do delays. So you only need to consider when the
MII port is used for connecting to the CPU. So make use of
dsa_is_cpu_port().

	Andrew
