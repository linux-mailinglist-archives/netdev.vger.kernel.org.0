Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51661E30EB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgEZVEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:04:30 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:34869 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgEZVEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:04:30 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 144C3FF805;
        Tue, 26 May 2020 21:04:26 +0000 (UTC)
Date:   Tue, 26 May 2020 23:04:26 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 1/4] net: phy: mscc-miim: use more reasonable
 delays
Message-ID: <20200526210426.GG3972@piout.net>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526162256.466885-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 18:22:53+0200, Antoine Ténart wrote:
> The MSCC MIIM MDIO driver uses delays to read poll a status register. I
> made multiple tests on a Ocelot PCS120 platform which led me to reduce
> those delays. The delay in between which the polling function is allowed
> to sleep is reduced from 100us to 50us which in almost all cases is a
> good value to succeed at the first retry. The overall delay is also
> lowered as the prior value was really way to high, 10000us is large
> enough.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/phy/mdio-mscc-miim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-miim.c
> index badbc99bedd3..0b7544f593fb 100644
> --- a/drivers/net/phy/mdio-mscc-miim.c
> +++ b/drivers/net/phy/mdio-mscc-miim.c
> @@ -44,7 +44,7 @@ static int mscc_miim_wait_ready(struct mii_bus *bus)
>  	u32 val;
>  
>  	readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> -			   !(val & MSCC_MIIM_STATUS_STAT_BUSY), 100, 250000);
> +			   !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50, 10000);
>  	if (val & MSCC_MIIM_STATUS_STAT_BUSY)
>  		return -ETIMEDOUT;
>  
> -- 
> 2.26.2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
