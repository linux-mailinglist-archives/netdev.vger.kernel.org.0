Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FFE1E30ED
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgEZVE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:04:59 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:34727 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgEZVE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:04:59 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 15147FF80A;
        Tue, 26 May 2020 21:04:56 +0000 (UTC)
Date:   Tue, 26 May 2020 23:04:56 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 2/4] net: phy: mscc-miim: remove redundant
 timeout check
Message-ID: <20200526210456.GH3972@piout.net>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-3-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526162256.466885-3-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 18:22:54+0200, Antoine Ténart wrote:
> readl_poll_timeout already returns -ETIMEDOUT if the condition isn't
> satisfied, there's no need to check again the condition after calling
> it. Remove the redundant timeout check.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/phy/mdio-mscc-miim.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-miim.c
> index 0b7544f593fb..42119f661452 100644
> --- a/drivers/net/phy/mdio-mscc-miim.c
> +++ b/drivers/net/phy/mdio-mscc-miim.c
> @@ -43,12 +43,8 @@ static int mscc_miim_wait_ready(struct mii_bus *bus)
>  	struct mscc_miim_dev *miim = bus->priv;
>  	u32 val;
>  
> -	readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> -			   !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50, 10000);
> -	if (val & MSCC_MIIM_STATUS_STAT_BUSY)
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	return readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> +				  !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50, 10000);
>  }
>  
>  static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
> -- 
> 2.26.2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
