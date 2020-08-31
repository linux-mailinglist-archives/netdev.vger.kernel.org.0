Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75187257B13
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 16:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgHaOIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 10:08:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgHaOIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 10:08:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCkUJ-00CeT1-1p; Mon, 31 Aug 2020 16:08:47 +0200
Date:   Mon, 31 Aug 2020 16:08:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
Message-ID: <20200831140847.GE2403519@lunn.ch>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831134836.20189-5-m.felsch@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	priv->refclk = devm_clk_get_optional(dev, NULL);
> +	if (IS_ERR(priv->refclk)) {
> +		if (PTR_ERR(priv->refclk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		/* Clocks are optional all errors should be ignored here */
> +		return 0;

Since you are calling devm_clk_get_optional() isn't an error a real
error, not that the clock is missing? It probably should be returned
as an error code.

   Andrew
