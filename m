Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042DC39A218
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhFCNXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhFCNXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:23:00 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE57C06174A;
        Thu,  3 Jun 2021 06:21:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id cb9so7117542edb.1;
        Thu, 03 Jun 2021 06:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9BVci4qm9159zofCoZo7l0IIC4weKuMG5hMSv6qZYkI=;
        b=sjV1VRzIrBvUlFmsiDs/lwsaetaQWtXZP5TY0E6oA8oyVhlzm0+oau8wXmCNZz25+w
         v9wlNRTEV6oc/MqUe2hOBYdM172toqYyZkpjtL6ZnHTnUh5HcY4vzItZuBQg7DBmJKlZ
         9JQeffkLvY+WubtSDcC/lpZr4il7KUh5h+n2tdmd1BmkaUJtSIxyEGU7yuw/lI3rMMUC
         RaxnVg4YBoyRdARZSUEd5gduPEUsHCpFcCbut8J2TNBvKFrFh34kZ8uXPyjGoath5l8y
         elT3Q5F0ZDofBQWqXo2qjTsVX1rOryHzR2QCavtDWfu9LUHBlOscUkqJlXdaGY5xHl+9
         4IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9BVci4qm9159zofCoZo7l0IIC4weKuMG5hMSv6qZYkI=;
        b=PcyL9dCCywD4uoEbaxRLZ0IMVAFRwlwm6FPd++1vGIY3cpCHX+X+eDfjegT5z6V9z0
         fr+QzXU+fcq4LyfrH1KEnhxWu1Zx3qbuUhwIhEKG+9chJjQc+m0lfKI6NsmD55+UTqEh
         FG5g5TLqUtVYB6BlFXOF5uPSw6M3Eop6/rKWJhyBCGz+GOITHIPLh9YJBmYiB1Ykprfr
         K1+9acs0eM3Dq7E2xI2BJIF1ODSZExddwRM1paUF+q01t/k436I0z1Zzj4FFuUxUCawI
         wzFD7Om9/SuATw2OC8LrapkwQEU0pAx2vHIjND7RawssTdljXGoFJmc6kVGciOwJR1vE
         28zA==
X-Gm-Message-State: AOAM5325vpmMNeVdqTqXOwopBM02tORjd+irwvqzx5VU7QKz8HyNgzeZ
        cLRvtIF5TO+Bkiyz1Sqnzag=
X-Google-Smtp-Source: ABdhPJyrNXD3b7L77RUPeCvNSWt3b3Q3L0hsRyp5jGZaTxN3IQ53FOpRlwgchOs4JYzc0WyiGwJa5Q==
X-Received: by 2002:aa7:dd12:: with SMTP id i18mr1016495edv.278.1622726459446;
        Thu, 03 Jun 2021 06:20:59 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c7sm1530634ejs.26.2021.06.03.06.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:20:58 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:20:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v4 1/3] net: stmmac: split xPCS setup
 from mdio register
Message-ID: <20210603132056.zklgtbsslbkgqtsn@skbuf>
References: <20210603115032.2470-1-michael.wei.hong.sit@intel.com>
 <20210603115032.2470-2-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603115032.2470-2-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Jun 03, 2021 at 07:50:30PM +0800, Michael Sit Wei Hong wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> This patch is a preparation patch for the enabling of Intel mGbE 2.5Gbps
> link speed. The Intel mGbR link speed configuration (1G/2.5G) is depends on
> a mdio ADHOC register which can be configured in the bios menu.
> As PHY interface might be different for 1G and 2.5G, the mdio bus need be
> ready to check the link speed and select the PHY interface before probing
> the xPCS.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 73 ++++++++++---------
>  3 files changed, 46 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index b6cd43eda7ac..fd7212afc543 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -311,6 +311,7 @@ enum stmmac_state {
>  int stmmac_mdio_unregister(struct net_device *ndev);
>  int stmmac_mdio_register(struct net_device *ndev);
>  int stmmac_mdio_reset(struct mii_bus *mii);
> +int stmmac_xpcs_setup(struct mii_bus *mii);
>  void stmmac_set_ethtool_ops(struct net_device *netdev);
>  
>  void stmmac_ptp_register(struct stmmac_priv *priv);
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 13720bf6f6ff..eb81baeb13b0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7002,6 +7002,12 @@ int stmmac_dvr_probe(struct device *device,
>  		}
>  	}
>  
> +	if (priv->plat->mdio_bus_data->has_xpcs) {
> +		ret = stmmac_xpcs_setup(priv->mii);
> +		if (ret)
> +			goto error_xpcs_setup;
> +	}
> +

I don't understand why this change is necessary?

The XPCS probing code was at the end of stmmac_mdio_register().
You moved the code right _after_ stmmac_mdio_register().
So the code flow is exactly the same.

>  	ret = stmmac_phy_setup(priv);
>  	if (ret) {
>  		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
> @@ -7038,6 +7044,7 @@ int stmmac_dvr_probe(struct device *device,
>  	unregister_netdev(ndev);
>  error_netdev_register:
>  	phylink_destroy(priv->phylink);
> +error_xpcs_setup:
>  error_phy_setup:
>  	if (priv->hw->pcs != STMMAC_PCS_TBI &&
>  	    priv->hw->pcs != STMMAC_PCS_RTBI)
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index e293bf1ce9f3..3bb0a787f136 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -397,6 +397,44 @@ int stmmac_mdio_reset(struct mii_bus *bus)
>  	return 0;
>  }
>  
> +int stmmac_xpcs_setup(struct mii_bus *bus)
> +{
> +	int mode, max_addr, addr, found, ret;
> +	struct net_device *ndev = bus->priv;
> +	struct mdio_xpcs_args *xpcs;
> +	struct stmmac_priv *priv;
> +
> +	priv = netdev_priv(ndev);
> +	xpcs = &priv->hw->xpcs_args;
> +	mode = priv->plat->phy_interface;
> +	max_addr = PHY_MAX_ADDR;
> +
> +	priv->hw->xpcs = mdio_xpcs_get_ops();
> +	if (!priv->hw->xpcs)
> +		return -ENODEV;
> +
> +	/* Try to probe the XPCS by scanning all addresses. */
> +	xpcs->bus = bus;
> +	found = 0;
> +
> +	for (addr = 0; addr < max_addr; addr++) {
> +		xpcs->addr = addr;
> +
> +		ret = stmmac_xpcs_probe(priv, xpcs, mode);
> +		if (!ret) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		dev_warn(priv->device, "No xPCS found\n");
> +		return -ENODEV;
> +	}
> +
> +	return ret;
> +}
> +
>  /**
>   * stmmac_mdio_register
>   * @ndev: net device structure
> @@ -444,14 +482,6 @@ int stmmac_mdio_register(struct net_device *ndev)
>  		max_addr = PHY_MAX_ADDR;
>  	}
>  
> -	if (mdio_bus_data->has_xpcs) {
> -		priv->hw->xpcs = mdio_xpcs_get_ops();
> -		if (!priv->hw->xpcs) {
> -			err = -ENODEV;
> -			goto bus_register_fail;
> -		}
> -	}
> -
>  	if (mdio_bus_data->needs_reset)
>  		new_bus->reset = &stmmac_mdio_reset;
>  
> @@ -509,38 +539,11 @@ int stmmac_mdio_register(struct net_device *ndev)
>  		goto no_phy_found;
>  	}
>  
> -	/* Try to probe the XPCS by scanning all addresses. */
> -	if (priv->hw->xpcs) {
> -		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
> -		int ret, mode = priv->plat->phy_interface;
> -		max_addr = PHY_MAX_ADDR;
> -
> -		xpcs->bus = new_bus;
> -
> -		found = 0;
> -		for (addr = 0; addr < max_addr; addr++) {
> -			xpcs->addr = addr;
> -
> -			ret = stmmac_xpcs_probe(priv, xpcs, mode);
> -			if (!ret) {
> -				found = 1;
> -				break;
> -			}
> -		}
> -
> -		if (!found && !mdio_node) {
> -			dev_warn(dev, "No XPCS found\n");
> -			err = -ENODEV;
> -			goto no_xpcs_found;
> -		}
> -	}
> -
>  bus_register_done:
>  	priv->mii = new_bus;
>  
>  	return 0;
>  
> -no_xpcs_found:
>  no_phy_found:
>  	mdiobus_unregister(new_bus);
>  bus_register_fail:
> -- 
> 2.17.1
> 
