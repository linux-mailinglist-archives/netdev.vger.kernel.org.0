Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416F72FD90B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392517AbhATTE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:04:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392493AbhATTDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 14:03:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2Ikk-001gxZ-DG; Wed, 20 Jan 2021 20:02:50 +0100
Date:   Wed, 20 Jan 2021 20:02:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
Message-ID: <YAh+Wtxpm+L2qVpg@lunn.ch>
References: <20210120030502.617185-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120030502.617185-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 04:05:02AM +0100, Marek Vasut wrote:
> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
> rise enough to release the reset.
> 
> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>                     VDDIO - VIH
>   t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
>                        VDDIO
> so we need ~95 ms for the reset to really de-assert, and then the
> original 100us for the switch itself to come out of reset. Simply
> msleep() for 100 ms which fits the constraint with a bit of extra
> space.
> 
> Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended reset timing")
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Paul Barker <pbarker@konsulko.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
