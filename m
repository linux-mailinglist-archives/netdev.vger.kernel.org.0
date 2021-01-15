Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2BC2F7728
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbhAOLGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOLGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:06:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBCEC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:05:50 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hs11so10373962ejc.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T9LxMSO4yU4eOLvQcqsmlegfVNc7zriGjdSFBAM3M1s=;
        b=aJr0lN3FP5313BjxEMDEuQGLuNyFsEi4XQuH/l8GiZwt+rkY1zyh+EZBtBlD0CN4Bh
         pwmjX63CinUd5v/m5KbNg2bMuSy5Of6upGHExsiAvGbUvTRdtS3SS2mN6jrZezByVgI2
         uD5PbADbOQ4L81tYBpYiqWK2gQ59hRvqkNxXt2f04sWRIlk6zlJtCHs02uZW98RVBJhq
         QufECdKzw+96vy7f3KdAm/VJrxiBMAUKNInuJ0d5XSMfo4+HcPlSuWVkOCy97D+1pl7i
         vpLpa9Qf1ppHiFwxiu6cjM8/CBy5bQIfT2pr6wwn/LAGD28lHsMCgRiBSo25MtXGqF8l
         ST0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T9LxMSO4yU4eOLvQcqsmlegfVNc7zriGjdSFBAM3M1s=;
        b=iqQ3g6Ljrmhv4JGvkIqvXytJqkzgAbIei4gfE/cDfZBjzcgGuY1IlTNJqfJhBjnunx
         smb0lBhrN4sv+YSjJnBsXs4yU1g5/nGkJXrBKbp/WtfU6u2mqIvnxVvQ4ZJt/wHF75l8
         R8wqwkJ2esPwJe8+Y8Ur9x1NpWkWn1Poi+cF+vy92/XIFnC5yOVPWc5bAqpAi+Acof/Y
         iTftYB7JAQ4bYqGvjmoyRg3UaA5IlHlDTLKLTycwTjVJP9PN7vIVVjpp70zRfLP5/Bzq
         RZL/TrYxplNlZXRouLdpZA7w+ZAvO2tKm4bVgfDeABzAjfbcPqwG3hqY7Ps5HrdjXjIn
         ErfA==
X-Gm-Message-State: AOAM5339K9XsLb+/lmXv1ygIV6avI8d/jkHhbsDMYNQmYFkqtzPTy2qt
        20s4ui8PPnCpkAi2n51TnV0=
X-Google-Smtp-Source: ABdhPJwTiLAQsmtc1/gt98VtCPfxTu1uVW/y2C67zPiMlfngXZZtuP94txMHnNa+if5YmRVzXkoiGw==
X-Received: by 2002:a17:906:3b56:: with SMTP id h22mr8115572ejf.491.1610708749544;
        Fri, 15 Jan 2021 03:05:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f13sm3136519ejf.42.2021.01.15.03.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 03:05:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:05:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 12/16] net: mscc: ocelot: drop the use of
 the "lags" array
Message-ID: <20210115110547.fwfyl3lnplbvqieu@skbuf>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-13-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-13-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 02:07:58PM +0200, Vladimir Oltean wrote:
> We can now simplify the implementation by always using ocelot_get_bond_mask
> to look up the other ports that are offloading the same bonding interface
> as us.
> 
> In ocelot_set_aggr_pgids, the code had a way to uniquely iterate through
> LAGs. We need to achieve the same behavior by marking each LAG as visited,
> which we do now by temporarily allocating an array of pointers to bonding
> uppers of each port, and marking each bonding upper as NULL once it has
> been treated by the first port that is a member. And because we now do
> some dynamic allocation, we need to propagate errors from
> ocelot_set_aggr_pgid all the way to ocelot_port_lag_leave.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 104 ++++++++++---------------
>  drivers/net/ethernet/mscc/ocelot.h     |   4 +-
>  drivers/net/ethernet/mscc/ocelot_net.c |   4 +-
>  include/soc/mscc/ocelot.h              |   2 -
>  4 files changed, 47 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 1a98c24af056..d4dbba66aa65 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -909,21 +909,17 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
>  	 * source port's forwarding mask.
>  	 */
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		if (ocelot->bridge_fwd_mask & BIT(port)) {
> -			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
> -			int lag;
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
>  
> -			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> -				unsigned long bond_mask = ocelot->lags[lag];
> +		if (!ocelot_port)
> +			continue;
>  
> -				if (!bond_mask)
> -					continue;
> +		if (ocelot->bridge_fwd_mask & BIT(port)) {
> +			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
> +			struct net_device *bond = ocelot_port->bond;
>  
> -				if (bond_mask & BIT(port)) {
> -					mask &= ~bond_mask;
> -					break;
> -				}
> -			}
> +			if (bond)
> +				mask &= ~ocelot_get_bond_mask(ocelot, bond);
>  
>  			ocelot_write_rix(ocelot, mask,
>  					 ANA_PGID_PGID, PGID_SRC + port);
> @@ -1238,10 +1234,16 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
>  }
>  EXPORT_SYMBOL(ocelot_port_bridge_leave);
>  
> -static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
> +static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  {
> +	struct net_device **bonds;
>  	int i, port, lag;
>  
> +	bonds = kcalloc(ocelot->num_phys_ports, sizeof(struct net_device *),
> +			GFP_KERNEL);
> +	if (!bonds)
> +		return -ENOMEM;
> +

I remember somebody complaining about the temporary memory allocation
done here, but I can't seem to find that email for some reason.

Is it ok if I still keep the dynamic allocation there, though? Felix has
up to 5 user ports, Seville has up to 9, Ocelot up to 11. I would like
to not hardcode anything, in case (who knows!) more switches get added.

>  	/* Reset destination and aggregation PGIDS */
>  	for_each_unicast_dest_pgid(ocelot, port)
>  		ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, port);
> @@ -1250,16 +1252,26 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
>  				 ANA_PGID_PGID, i);
>  
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +
> +		if (!ocelot_port)
> +			continue;
> +
> +		bonds[port] = ocelot_port->bond;
> +	}
> +
>  	/* Now, set PGIDs for each LAG */
>  	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
>  		unsigned long bond_mask;
>  		int aggr_count = 0;
>  		u8 aggr_idx[16];
>  
> -		bond_mask = ocelot->lags[lag];
> -		if (!bond_mask)
> +		if (!bonds[lag])
>  			continue;
>  
> +		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
> +
>  		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
>  			// Destination mask
>  			ocelot_write_rix(ocelot, bond_mask,
> @@ -1276,7 +1288,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  			ac |= BIT(aggr_idx[i % aggr_count]);
>  			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
>  		}
> +
> +		/* Mark the bonding interface as visited to avoid applying
> +		 * the same config again
> +		 */
> +		for (i = lag + 1; i < ocelot->num_phys_ports; i++)
> +			if (bonds[i] == bonds[lag])
> +				bonds[i] = NULL;
> +
> +		bonds[lag] = NULL;
>  	}
> +
> +	kfree(bonds);
> +	return 0;
>  }
>  
>  /* When offloading a bonding interface, the switch ports configured under the
> @@ -1315,59 +1339,22 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
>  int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond)
>  {
> -	u32 bond_mask = 0;
> -	int lag;
> -
>  	ocelot->ports[port]->bond = bond;
>  
> -	bond_mask = ocelot_get_bond_mask(ocelot, bond);
> -
> -	lag = __ffs(bond_mask);
> -
> -	/* If the new port is the lowest one, use it as the logical port from
> -	 * now on
> -	 */
> -	if (port == lag) {
> -		ocelot->lags[port] = bond_mask;
> -		bond_mask &= ~BIT(port);
> -		if (bond_mask)
> -			ocelot->lags[__ffs(bond_mask)] = 0;
> -	} else {
> -		ocelot->lags[lag] |= BIT(port);
> -	}
> -
>  	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
> -	ocelot_set_aggr_pgids(ocelot);
> -
> -	return 0;
> +	return ocelot_set_aggr_pgids(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_join);
>  
> -void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> -			   struct net_device *bond)
> +int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> +			  struct net_device *bond)
>  {
> -	int i;
> -
>  	ocelot->ports[port]->bond = NULL;
>  
> -	/* Remove port from any lag */
> -	for (i = 0; i < ocelot->num_phys_ports; i++)
> -		ocelot->lags[i] &= ~BIT(port);
> -
> -	/* if it was the logical port of the lag, move the lag config to the
> -	 * next port
> -	 */
> -	if (ocelot->lags[port]) {
> -		int n = __ffs(ocelot->lags[port]);
> -
> -		ocelot->lags[n] = ocelot->lags[port];
> -		ocelot->lags[port] = 0;
> -	}
> -
>  	ocelot_setup_logical_port_ids(ocelot);
>  	ocelot_apply_bridge_fwd_mask(ocelot);
> -	ocelot_set_aggr_pgids(ocelot);
> +	return ocelot_set_aggr_pgids(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_port_lag_leave);
>  
> @@ -1543,11 +1530,6 @@ int ocelot_init(struct ocelot *ocelot)
>  		}
>  	}
>  
> -	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
> -				    sizeof(u32), GFP_KERNEL);
> -	if (!ocelot->lags)
> -		return -ENOMEM;
> -
>  	ocelot->stats = devm_kcalloc(ocelot->dev,
>  				     ocelot->num_phys_ports * ocelot->num_stats,
>  				     sizeof(u64), GFP_KERNEL);
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index 739bd201d951..bef8d5f8e6e5 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -114,8 +114,8 @@ int ocelot_mact_forget(struct ocelot *ocelot,
>  		       const unsigned char mac[ETH_ALEN], unsigned int vid);
>  int ocelot_port_lag_join(struct ocelot *ocelot, int port,
>  			 struct net_device *bond);
> -void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> -			   struct net_device *bond);
> +int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
> +			  struct net_device *bond);
>  struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
>  int ocelot_netdev_to_port(struct net_device *dev);
>  
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 77957328722a..93aaa631e347 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1035,8 +1035,8 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
>  			err = ocelot_port_lag_join(ocelot, port,
>  						   info->upper_dev);
>  		else
> -			ocelot_port_lag_leave(ocelot, port,
> -					      info->upper_dev);
> +			err = ocelot_port_lag_leave(ocelot, port,
> +						    info->upper_dev);
>  	}
>  
>  	return notifier_from_errno(err);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index b812bdff1da1..0cd45659430f 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -639,8 +639,6 @@ struct ocelot {
>  	enum ocelot_tag_prefix		inj_prefix;
>  	enum ocelot_tag_prefix		xtr_prefix;
>  
> -	u32				*lags;
> -
>  	struct list_head		multicast;
>  	struct list_head		pgids;
>  
> -- 
> 2.25.1
> 
