Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B2B24EF66
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHWTNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:13:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgHWTNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:13:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9vQS-00BQBj-Id; Sun, 23 Aug 2020 21:13:08 +0200
Date:   Sun, 23 Aug 2020 21:13:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sumera Priyadarsini <sylphrenadin@gmail.com>
Cc:     davem@davemloft.net, Julia.Lawall@lip6.fr, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: dsa: Add of_node_put() before break statement
Message-ID: <20200823191308.GG2588906@lunn.ch>
References: <20200823185056.16641-1-sylphrenadin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823185056.16641-1-sylphrenadin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 8dcb8a49ab67..e81198a65c26 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1327,6 +1327,7 @@ mt7530_setup(struct dsa_switch *ds)
>  			if (phy_node->parent == priv->dev->of_node->parent) {
>  				ret = of_get_phy_mode(mac_np, &interface);
>  				if (ret && ret != -ENODEV)
> +					of_node_put(mac_np)
>  					return ret;
>  				id = of_mdio_parse_addr(ds->dev, phy_node);
>  				if (id == 0)

You are missing some { }. And a ; . I'm surprised gcc did not warn
you!

    Andrew
