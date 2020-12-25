Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523012E296E
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 02:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgLYBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 20:35:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgLYBfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 20:35:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ksbzv-00DrmH-Lz; Fri, 25 Dec 2020 02:34:27 +0100
Date:   Fri, 25 Dec 2020 02:34:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, torii.ken1@fujitsu.com
Subject: Re: [PATCH] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <20201225013427.GV3107610@lunn.ch>
References: <20201225004751.26075-1-ashiduka@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225004751.26075-1-ashiduka@fujitsu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int rtl9000a_ack_interrupt(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = phy_read(phydev, RTL8211F_INSR);
> +
> +	return (err < 0) ? err : 0;
> +}
> +
> +static int rtl9000a_config_intr(struct phy_device *phydev)
> +{
> +	u16 val;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		val = (u16)~RTL9000A_GINMR_LINK_STATUS;
> +	else
> +		val = ~0;
> +
> +	return phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
> +}

You need to rework this for the recent change to interrupt handling.

    Andrew
