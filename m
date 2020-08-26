Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E0A252F10
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgHZM5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:57:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbgHZM5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 08:57:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAuz4-00BwSf-PV; Wed, 26 Aug 2020 14:56:58 +0200
Date:   Wed, 26 Aug 2020 14:56:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de
Subject: Re: ethernet-phy-ieee802.3-c22 binding and reset-gpios
Message-ID: <20200826125658.GP2403519@lunn.ch>
References: <20200825090933.GN13023@pengutronix.de>
 <20200825131400.GO2588906@lunn.ch>
 <20200826085857.GO13023@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826085857.GO13023@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 10:58:57AM +0200, Sascha Hauer wrote:
> Hi Andrew,
> 
> Well there is only one phy connected to the bus, so it makes no
> difference if I say the reset GPIO is for the whole bus or for a single
> phy only. The per bus reset should work, but currently it doesn't. First
> reason I found out that mdiobus_register() doesn't handle -EPROBE_DEFER
> returned by the devm_gpiod_get_optional() properly, patch follows.

Thanks

> Second reason is that the phy is not detected (id read returns 0xffff)
> when the reset is attached to the bus. So far I haven't found the reason
> for that.

Try giving the PHY a bit longer to recover from the reset before
probing it.

And what SoC are you using? Is it FEC ethernet driver? That has MDIO
issues at the moment.

     Andrew
