Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E7357A52B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiGSR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiGSR0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:26:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0023E49B46;
        Tue, 19 Jul 2022 10:26:33 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r6so20576892edd.7;
        Tue, 19 Jul 2022 10:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgVQsDcIh7hMG88c9U3+sbfPk+o0H8fxritPjqEqUmM=;
        b=ewy8UWmTZSOlmHm93dXdsj+T9KMMunUesjU+yZoFsRUP5M4T1HZ6p/YEafbPWoBL77
         wtHP/Il2PgT+Yp3AbwsTQWLJkdwDOEvyeCF9DSnG/VizG+lDsMq7lKUGbn8gPe6AFaTh
         3KENwOUzWnXHBiEo5yfUzq2bVdE04Vqw29inUoV0BGuJr3XK98uNPqrvEoZu/gn+dxux
         xFoE51wcf/8GYqXOASHhUxTxhqAdkFf0YHe3LtMpa+kdF0sWKh5VKZ0E4HWTRFQQxoOB
         UlHiv/Q4JDjy/TTlngIwlpM53/xJXRnqyYiN1w+Lle3UOGNcvoXko4TmesLvyp+MUG1j
         2fZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgVQsDcIh7hMG88c9U3+sbfPk+o0H8fxritPjqEqUmM=;
        b=KY+AQ++wD8fPVnDLNvM2UpjgNNngPTfT30pvElXR73KckgRys2bbpdX7DHE7WbcivN
         y7xjUyQxrc3yQ0dARKnDSIHrB8lNzRJsNLHxXhrvvviBfK89Z9PzhrGvmegVrCgUeWPI
         +5wk0vaVzbP6KYQJyHK9Y6D8zVxzXqZRYshXRxCa40Az6/XfSTvG9z9J7bzp/kMoPD3C
         AKgGRHLJna6T9dHpY+fvMJ8ZWv5NvMkghWvGawVWu9vhBeEkMsOe5ouARibZfFvjKv+W
         oJV+SoZgjOAnoDDRfNEw41RHXI/or1TR+GJrynREG8XHgwx6ZwnqrdPeOBuLDTIF2wkB
         fMmw==
X-Gm-Message-State: AJIora+pDxkP/mmbd/EMry3JArSvS86wgyrAlSZPcjOFYevOR7gE5T4p
        cX1cxDEgUcBJQn1fyqFVXrw=
X-Google-Smtp-Source: AGRyM1stKEj1phZY3OyPjS19E+XvHR0R7QOcStoagXx3gBsiHUU0/m9fj5G6GcYPSUtAa1ULGUwL9A==
X-Received: by 2002:aa7:c9d3:0:b0:43a:67b9:6eea with SMTP id i19-20020aa7c9d3000000b0043a67b96eeamr44610946edt.94.1658251592341;
        Tue, 19 Jul 2022 10:26:32 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id h9-20020aa7c609000000b0043ab1ad0b6bsm10825065edq.37.2022.07.19.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 10:26:30 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:26:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 5/9] net: pcs: lynx: Use pcs_get_by_provider
 to get PCS
Message-ID: <20220719172628.vkkrarx5zkiyumze@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-6-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711160519.741990-6-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:05:15PM -0400, Sean Anderson wrote:
> There is a common flow in several drivers where a lynx PCS is created
> without a corresponding firmware node. Consolidate these into one helper
> function. Because we control when the mdiodev is registered, we can add
> a custom match function which will automatically bind our driver
> (instead of using device_driver_attach).
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        | 25 ++++---------------
>  drivers/net/dsa/ocelot/seville_vsc9953.c      | 25 ++++---------------
>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++-------------
>  drivers/net/pcs/pcs-lynx.c                    | 24 ++++++++++++++++++
>  include/linux/pcs-lynx.h                      |  1 +
>  5 files changed, 39 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 57634e2296c0..0a756c25d5e8 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -11,6 +11,7 @@
>  #include <net/tc_act/tc_gate.h>
>  #include <soc/mscc/ocelot.h>
>  #include <linux/dsa/ocelot.h>
> +#include <linux/pcs.h>
>  #include <linux/pcs-lynx.h>
>  #include <net/pkt_sched.h>
>  #include <linux/iopoll.h>
> @@ -1089,16 +1090,9 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>  		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
>  			continue;
>  
> -		mdio_device = mdio_device_create(felix->imdio, port);
> -		if (IS_ERR(mdio_device))
> +		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, port);
> +		if (IS_ERR(phylink_pcs))
>  			continue;
> -
> -		phylink_pcs = lynx_pcs_create(mdio_device);
> -		if (IS_ERR(phylink_pcs)) {
> -			mdio_device_free(mdio_device);
> -			continue;
> -		}
> -
>  		felix->pcs[port] = phylink_pcs;
>  
>  		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
> @@ -1112,17 +1106,8 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
>  	struct felix *felix = ocelot_to_felix(ocelot);
>  	int port;
>  
> -	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		struct phylink_pcs *phylink_pcs = felix->pcs[port];
> -		struct mdio_device *mdio_device;
> -
> -		if (!phylink_pcs)
> -			continue;
> -
> -		mdio_device = lynx_get_mdio_device(phylink_pcs);
> -		mdio_device_free(mdio_device);
> -		lynx_pcs_destroy(phylink_pcs);
> -	}
> +	for (port = 0; port < ocelot->num_phys_ports; port++)
> +		pcs_put(felix->pcs[port]);
>  	mdiobus_unregister(felix->imdio);
>  	mdiobus_free(felix->imdio);
>  }
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 8c52de5d0b02..9006dec85ef0 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -9,6 +9,7 @@
>  #include <linux/mdio/mdio-mscc-miim.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_platform.h>
> +#include <linux/pcs.h>
>  #include <linux/pcs-lynx.h>
>  #include <linux/dsa/ocelot.h>
>  #include <linux/iopoll.h>
> @@ -1044,16 +1045,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>  		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
>  			continue;
>  
> -		mdio_device = mdio_device_create(felix->imdio, addr);
> -		if (IS_ERR(mdio_device))
> +		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, addr);
> +		if (IS_ERR(phylink_pcs))
>  			continue;
> -
> -		phylink_pcs = lynx_pcs_create(mdio_device);
> -		if (IS_ERR(phylink_pcs)) {
> -			mdio_device_free(mdio_device);
> -			continue;
> -		}
> -
>  		felix->pcs[port] = phylink_pcs;
>  
>  		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
> @@ -1067,17 +1061,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
>  	struct felix *felix = ocelot_to_felix(ocelot);
>  	int port;
>  
> -	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		struct phylink_pcs *phylink_pcs = felix->pcs[port];
> -		struct mdio_device *mdio_device;
> -
> -		if (!phylink_pcs)
> -			continue;
> -
> -		mdio_device = lynx_get_mdio_device(phylink_pcs);
> -		mdio_device_free(mdio_device);
> -		lynx_pcs_destroy(phylink_pcs);
> -	}
> +	for (port = 0; port < ocelot->num_phys_ports; port++)
> +		pcs_put(felix->pcs[port]);
>  
>  	/* mdiobus_unregister and mdiobus_free handled by devres */
>  }
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 8c923a93da88..8da7c8644e44 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -8,6 +8,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
> +#include <linux/pcs.h>
>  #include <linux/pcs-lynx.h>
>  #include "enetc_ierb.h"
>  #include "enetc_pf.h"
> @@ -827,7 +828,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>  	struct device *dev = &pf->si->pdev->dev;
>  	struct enetc_mdio_priv *mdio_priv;
>  	struct phylink_pcs *phylink_pcs;
> -	struct mdio_device *mdio_device;
>  	struct mii_bus *bus;
>  	int err;
>  
> @@ -851,16 +851,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>  		goto free_mdio_bus;
>  	}
>  
> -	mdio_device = mdio_device_create(bus, 0);
> -	if (IS_ERR(mdio_device)) {
> -		err = PTR_ERR(mdio_device);
> -		dev_err(dev, "cannot create mdio device (%d)\n", err);
> -		goto unregister_mdiobus;
> -	}
> -
> -	phylink_pcs = lynx_pcs_create(mdio_device);
> +	phylink_pcs = lynx_pcs_create_on_bus(bus, 0);
>  	if (IS_ERR(phylink_pcs)) {
> -		mdio_device_free(mdio_device);
>  		err = PTR_ERR(phylink_pcs);
>  		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
>  		goto unregister_mdiobus;
> @@ -880,13 +872,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>  
>  static void enetc_imdio_remove(struct enetc_pf *pf)
>  {
> -	struct mdio_device *mdio_device;
> -
> -	if (pf->pcs) {
> -		mdio_device = lynx_get_mdio_device(pf->pcs);
> -		mdio_device_free(mdio_device);
> -		lynx_pcs_destroy(pf->pcs);
> -	}
> +	if (pf->pcs)
> +		pcs_put(pf->pcs);
>  	if (pf->imdio) {
>  		mdiobus_unregister(pf->imdio);
>  		mdiobus_free(pf->imdio);
> diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
> index 8272072698e4..adb9fd5ce72e 100644
> --- a/drivers/net/pcs/pcs-lynx.c
> +++ b/drivers/net/pcs/pcs-lynx.c
> @@ -403,6 +403,30 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
>  }
>  EXPORT_SYMBOL(lynx_pcs_create);
>  
> +struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr)
> +{
> +	struct mdio_device *mdio;
> +	struct phylink_pcs *pcs;
> +	int err;
> +
> +	mdio = mdio_device_create(bus, addr);
> +	if (IS_ERR(mdio))
> +		return ERR_CAST(mdio);
> +
> +	mdio->bus_match = mdio_device_bus_match;
> +	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias));
> +	err = mdio_device_register(mdio);

Yeah, so the reason why mdio_device_register() fails with -EBUSY for the
PCS devices created by felix_vsc9959.c is this:

int mdiobus_register_device(struct mdio_device *mdiodev)
{
	int err;

	if (mdiodev->bus->mdio_map[mdiodev->addr])
		return -EBUSY;

In other words, we already have an existing mdiodev on the bus at
address mdiodev->addr. Funnily enough, that device is actually us.
It was created at MDIO bus creation time, a dummy phydev that no one
connects to, found by mdiobus_scan(). I knew this was taking place,
but forgot/didn't realize the connection with this patch set, and that
dummy phy_device was completely harmless until now.

I can suppress its creation like this:

From b1d1cd1625a27a62fd02598c7015b8ff0afdd28a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 19 Jul 2022 20:15:52 +0300
Subject: [PATCH] net: dsa: ocelot: suppress PHY device scanning on the
 internal MDIO bus

This bus contains Lynx PCS devices, and if the lynx-pcs driver ever
decided to call mdio_device_register(), it would fail due to
mdiobus_scan() having created a dummy phydev for the same address
(the PCS responds to standard clause 22 PHY ID registers and can
therefore by autodetected by phylib which thinks it's a PHY).

On the Seville driver, things are a bit more complicated, since bus
creation is handled by mscc_miim_setup() and that is shared with the
dedicated mscc-miim driver. Suppress PHY scanning only for the Seville
internal MDIO bus rather than for the whole mscc-miim driver, since we
know that on NXP T1040, this bus only contains Lynx PCS devices.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 4 ++++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 927225e51f05..1ff71f1df316 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1062,6 +1062,10 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	bus->read = enetc_mdio_read;
 	bus->write = enetc_mdio_write;
 	bus->parent = dev;
+	/* Suppress PHY device creation in mdiobus_scan(),
+	 * we have Lynx PCSs
+	 */
+	bus->phy_mask = ~0;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = hw;
 	/* This gets added to imdio_regs, which already maps addresses
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 9006dec85ef0..9f400867fce3 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1018,12 +1018,16 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
 			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
-
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
 		return rc;
 	}
 
+	/* Suppress PHY device creation in mdiobus_scan(),
+	 * we have Lynx PCSs
+	 */
+	bus->phy_mask = ~0;
+
 	/* Needed in order to initialize the bus mutex lock */
 	rc = devm_of_mdiobus_register(dev, bus, NULL);
 	if (rc < 0) {
-- 
2.34.1

and then things start working (including traffic).

> +	if (err) {
> +		mdio_device_free(mdio);
> +		return ERR_PTR(err);
> +	}
> +
> +	pcs = pcs_get_by_provider(&mdio->dev);
> +	mdio_device_free(mdio);
> +	return pcs;
> +}
> +EXPORT_SYMBOL(lynx_pcs_create_on_bus);
> +
>  void lynx_pcs_destroy(struct phylink_pcs *pcs)
>  {
>  	pcs_put(pcs);
> diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
> index 5712cc2ce775..1c14342bb8c4 100644
> --- a/include/linux/pcs-lynx.h
> +++ b/include/linux/pcs-lynx.h
> @@ -12,6 +12,7 @@
>  struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
>  
>  struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
> +struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr);
>  
>  void lynx_pcs_destroy(struct phylink_pcs *pcs);
>  
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
