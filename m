Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C041373BAC
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhEEMsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:48:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233118AbhEEMsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 08:48:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1leGvv-002fo3-2r; Wed, 05 May 2021 14:47:19 +0200
Date:   Wed, 5 May 2021 14:47:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [RFC PATCH v1 8/9] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <YJKT173qkYZ+Iyp6@lunn.ch>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505092025.8785-9-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 11:20:24AM +0200, Oleksij Rempel wrote:
> This patch support for cable test for the ksz886x switches and the
> ksz8081 PHY.
> 
> The patch was tested on a KSZ8873RLL switch with following results:
> 
> - port 1:
>   - cannot detect any distance
>   - provides inverted values
>     (Errata: DS80000830A: "LinkMD does not work on Port 1",
>      http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf)
>     - Reports "short" on open or ok.
>     - Reports "ok" on short.

Quite broken. Distance is optional, simply don't report it.  Status is
harder. Reporting ETHTOOL_A_CABLE_RESULT_CODE_OK should really mean
the cable is O.K. If you cannot tell open from O.K, i would return
ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC.

More later.

	Andrew
