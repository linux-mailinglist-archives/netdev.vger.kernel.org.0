Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A65364FE5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhDTBgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 21:36:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhDTBgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 21:36:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYfIq-0001Zu-Hw; Tue, 20 Apr 2021 03:35:48 +0200
Date:   Tue, 20 Apr 2021 03:35:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: Re: [PATCH 2/3] net: ethernet: ixp4xx: Support device tree probing
Message-ID: <YH4v9AWjVMtGqLAw@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <20210419225133.2005360-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419225133.2005360-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	phy_np = of_parse_phandle(np, "phy-handle", 0);
> +	if (phy_np) {
> +		ret = of_property_read_u32(phy_np, "reg", &val);
> +		if (ret) {
> +			dev_err(dev, "cannot find phy reg\n");
> +			return NULL;
> +		}
> +		of_node_put(phy_np);
> +	} else {
> +		dev_err(dev, "cannot find phy instance\n");
> +		val = 0;
> +	}
> +	plat->phy = val;

phy-handle can point to a PHY on any bus. You should not assume it is
the devices own bus. Once you have phy_np call of_phy_find_device()
which gives you the actual phy device. Please don't let the
limitations of the current platform data limit you from implementing
this correctly.

      Andrew

