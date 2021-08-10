Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F763E5A60
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhHJMuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:50:16 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:33027 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbhHJMuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:50:14 -0400
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 38CCC20004;
        Tue, 10 Aug 2021 12:49:50 +0000 (UTC)
Date:   Tue, 10 Aug 2021 14:49:49 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
Message-ID: <YRJ17eMJPjx2fOtm@piout.net>
References: <20210810123748.47871-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810123748.47871-1-broonie@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2021 13:37:48+0100, Mark Brown wrote:
> The ocelot driver makes use of regmap, wrapping it with driver specific
> operations that are thin wrappers around the core regmap APIs. These are
> exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
> exports which is frowned upon. Add _GPL suffixes to at least the APIs that
> are doing register I/O.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_io.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
> index ea4e83410fe4..7390fa3980ec 100644
> --- a/drivers/net/ethernet/mscc/ocelot_io.c
> +++ b/drivers/net/ethernet/mscc/ocelot_io.c
> @@ -21,7 +21,7 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
>  		    ocelot->map[target][reg & REG_MASK] + offset, &val);
>  	return val;
>  }
> -EXPORT_SYMBOL(__ocelot_read_ix);
> +EXPORT_SYMBOL_GPL(__ocelot_read_ix);
>  
>  void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
>  {
> @@ -32,7 +32,7 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
>  	regmap_write(ocelot->targets[target],
>  		     ocelot->map[target][reg & REG_MASK] + offset, val);
>  }
> -EXPORT_SYMBOL(__ocelot_write_ix);
> +EXPORT_SYMBOL_GPL(__ocelot_write_ix);
>  
>  void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
>  		     u32 offset)
> @@ -45,7 +45,7 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
>  			   ocelot->map[target][reg & REG_MASK] + offset,
>  			   mask, val);
>  }
> -EXPORT_SYMBOL(__ocelot_rmw_ix);
> +EXPORT_SYMBOL_GPL(__ocelot_rmw_ix);
>  
>  u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
>  {
> @@ -58,7 +58,7 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
>  	regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val);
>  	return val;
>  }
> -EXPORT_SYMBOL(ocelot_port_readl);
> +EXPORT_SYMBOL_GPL(ocelot_port_readl);
>  
>  void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
>  {
> @@ -69,7 +69,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
>  
>  	regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val);
>  }
> -EXPORT_SYMBOL(ocelot_port_writel);
> +EXPORT_SYMBOL_GPL(ocelot_port_writel);
>  
>  void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
>  {
> @@ -77,7 +77,7 @@ void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
>  
>  	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
>  }
> -EXPORT_SYMBOL(ocelot_port_rmwl);
> +EXPORT_SYMBOL_GPL(ocelot_port_rmwl);
>  
>  u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
>  			    u32 reg, u32 offset)
> @@ -128,7 +128,7 @@ int ocelot_regfields_init(struct ocelot *ocelot,
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(ocelot_regfields_init);
> +EXPORT_SYMBOL_GPL(ocelot_regfields_init);
>  
>  static struct regmap_config ocelot_regmap_config = {
>  	.reg_bits	= 32,
> @@ -148,4 +148,4 @@ struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res)
>  
>  	return devm_regmap_init_mmio(ocelot->dev, regs, &ocelot_regmap_config);
>  }
> -EXPORT_SYMBOL(ocelot_regmap_init);
> +EXPORT_SYMBOL_GPL(ocelot_regmap_init);
> -- 
> 2.20.1
> 

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
