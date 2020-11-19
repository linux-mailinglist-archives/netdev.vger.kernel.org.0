Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC72B8909
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgKSA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:29:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSA3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:29:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXp5-007pZ3-TU; Thu, 19 Nov 2020 01:29:15 +0100
Date:   Thu, 19 Nov 2020 01:29:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt
 where possible
Message-ID: <20201119002915.GJ1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-7-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-7-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	case BR_STATE_DISABLED:
>  		data |= PORT_LEARN_DISABLE;
> -		if (port < SWITCH_PORT_NUM)
> +		if (port < dev->phy_port_cnt)
>  			member = 0;
>  		break;

So this, unlike all the other patches so far, is not obviously
correct. What exactly does phy_port_cnt mean? Can there be ports
without PHYs? What if the PHYs are external? You still need to be able
to change the STP state of such ports.

Andrew
