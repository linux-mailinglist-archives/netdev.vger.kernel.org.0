Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4CA270211
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIRQ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:27:10 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:57724 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRQ1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:27:10 -0400
Received: from relay3-d.mail.gandi.net (unknown [217.70.183.195])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 578A43A6003
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:28:29 +0000 (UTC)
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 1C26E6000E;
        Fri, 18 Sep 2020 15:27:56 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:27:56 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 4/8] net: mscc: ocelot: check for errors on memory
 allocation of ports
Message-ID: <20200918152756.GA9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:26+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Do not proceed probing if we couldn't allocate memory for the ports
> array, just error out.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> Stopped leaking the 'ports' OF node.
> 
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 65408bc994c4..904ea299a5e8 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -993,6 +993,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
>  				     sizeof(struct ocelot_port *), GFP_KERNEL);
> +	if (!ocelot->ports) {
> +		err = -ENOMEM;
> +		goto out_put_ports;
> +	}
>  
>  	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
