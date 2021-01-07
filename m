Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50D2EC7E6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbhAGCDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:03:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbhAGCDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 21:03:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxKdI-00GZPb-Jg; Thu, 07 Jan 2021 03:02:36 +0100
Date:   Thu, 7 Jan 2021 03:02:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X/ZrvOwsyrfmh3B2@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106153749.6748-2-pali@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* hwmon interface needs to access 16bit registers in atomic way to
> +	 * guarantee coherency of the diagnostic monitoring data. If it is not
> +	 * possible to guarantee coherency because EEPROM is broken in such way
> +	 * that does not support atomic 16bit read operation then we have to
> +	 * skip registration of hwmon device.
> +	 */
> +	if (sfp->i2c_block_size < 2) {
> +		dev_info(sfp->dev, "skipping hwmon device registration "
> +				   "due to broken EEPROM\n");
> +		dev_info(sfp->dev, "diagnostic EEPROM area cannot be read "
> +				   "atomically to guarantee data coherency\n");
> +		return;
> +	}

This solves hwmon. But we still return the broken data to ethtool -m.
I wonder if we should prevent that?

  Andrew
