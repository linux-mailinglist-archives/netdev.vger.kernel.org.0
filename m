Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487572DB0DD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbgLOQE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:04:57 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:60527 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730648AbgLOQEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:04:42 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 527DD20010;
        Tue, 15 Dec 2020 16:03:52 +0000 (UTC)
Date:   Tue, 15 Dec 2020 17:03:52 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 06/16] net: mscc: ocelot: use ipv6 in the
 aggregation code
Message-ID: <20201215160352.GJ1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:52+0200, Vladimir Oltean wrote:
> IPv6 header information is not currently part of the entropy source for
> the 4-bit aggregation code used for LAG offload, even though it could be.
> The hardware reference manual says about these fields:
> 
> ANA::AGGR_CFG.AC_IP6_TCPUDP_PORT_ENA
> Use IPv6 TCP/UDP port when calculating aggregation code. Configure
> identically for all ports. Recommended value is 1.
> 
> ANA::AGGR_CFG.AC_IP6_FLOW_LBL_ENA
> Use IPv6 flow label when calculating AC. Configure identically for all
> ports. Recommended value is 1.
> 
> Integration with the xmit_hash_policy of the bonding interface is TBD.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 7a5c534099d3..13e86dd71e5a 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1557,7 +1557,10 @@ int ocelot_init(struct ocelot *ocelot)
>  	ocelot_write(ocelot, ANA_AGGR_CFG_AC_SMAC_ENA |
>  			     ANA_AGGR_CFG_AC_DMAC_ENA |
>  			     ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA |
> -			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, ANA_AGGR_CFG);
> +			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA |
> +			     ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA |
> +			     ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA,
> +			     ANA_AGGR_CFG);
>  
>  	/* Set MAC age time to default value. The entry is aged after
>  	 * 2*AGE_PERIOD
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
