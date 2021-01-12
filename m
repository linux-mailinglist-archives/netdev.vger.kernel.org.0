Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2968C2F3D7F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437993AbhALVhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436899AbhALUVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:21:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzQ9o-000DzE-B3; Tue, 12 Jan 2021 21:20:48 +0100
Date:   Tue, 12 Jan 2021 21:20:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/4EoCx9vjRBZleO@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111050044.22002-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> + * instead via address 0x51, when SFP page is set to 0x03 and password to
> + * 0xffffffff.
> + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> + * bus creation time, and expect it to remain set to 0x03 throughout the
> + * lifetime of the module plugged into the system. If the SFP code starts
> + * modifying SFP_PAGE in the future, this code will need to change.

Just an FYI: This is likely to change. NVIDIA are working on
generalizing the API ethtool -m uses. The new API should allow access
to pages and banks. I've already said i will implement the API in the
generic phylink SFP code. But no need to address this now.

	Andrew
