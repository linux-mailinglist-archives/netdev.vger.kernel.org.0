Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC6291461
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439043AbgJQUps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:45:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438722AbgJQUps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 16:45:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTt54-002Bvk-Sq; Sat, 17 Oct 2020 22:45:34 +0200
Date:   Sat, 17 Oct 2020 22:45:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] staging: octeon: repair "fixed-link" support
Message-ID: <20201017204534.GS456889@lunn.ch>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
> +				if (of_phy_register_fixed_link(priv->of_node)) {
> +					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
> +						   interface, priv->port);
> +					dev->netdev_ops = NULL;
> +				}
> +			}
> +
>  			if (!dev->netdev_ops) {
>  				free_netdev(dev);

Setting dev->netdev_ops to NULL to indicate an error is pretty
odd. But this is staging. How about cleaning this
up. of_phy_register_fixed_link() returns an -errno which you should
return.

	Andrew
