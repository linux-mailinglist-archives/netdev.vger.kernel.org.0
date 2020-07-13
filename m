Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCF21DD65
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgGMQiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730523AbgGMQiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:38:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E50C061755;
        Mon, 13 Jul 2020 09:38:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id lx13so17952598ejb.4;
        Mon, 13 Jul 2020 09:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycdL8oVWbM+Oq87WaeorDM/hVkvLhqX9x6yYbZqoB6U=;
        b=HtOG6A1SyQY0JrPQZ1Yl8I4D91WDQCqtdXiCfxAK+BA0u3Qb681LblOWUwAB4ieMX9
         7/V8fu/0nbep6VIQGSa3HxR91Pfi95dzKbwHDWxFcK0YJQ4HTxSNFJYpGT2+955Ql4ld
         xLPQ2n0MCqwUSt9SUHuGSepsx9+jEjO8cHGezH6970ImCIan2d7rQeB3IilFn7/JBJUp
         f/h97T5fwSxpW2M4giJyuUktdk2ZB0V1BAbkfvQPW+hKUIrxF/j3+htWESQzMMdApKDV
         JMy46112S9Ps5cWpNxhv776ULLPD2wGIrGHT9Uyz+b68BgBF5FLSWMJYCiu4yEHS1Gdh
         3JGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ycdL8oVWbM+Oq87WaeorDM/hVkvLhqX9x6yYbZqoB6U=;
        b=aLq2IxmdF5o7uXCt/lk3jm4IidtaD9AZd0BJ0CT2BcU9z4o4DhNjXUbwLPGJ/oltuY
         99PzlvVrd39pI5ZY2HwSIl3USZ569eeX9FtnlvDk5O2xg/GEGk7kIwKlH/CXqP/Oan5x
         gien5NJkoVk5B1HEMIdqyfK4ReNvh1a6IR4OvcyMDxmQgRvMP8JuaKCGAXx+/2nFMA88
         4tpjMDIeij6dy3JnB+dTrEA7/sQ1dbB/sCqY5/jMCWG8sPYeNY0HwjQMu0GwAFH9Khm7
         KIZRaWpSAlUTOPEvu3+78x5g7UntCSo94rYo3Y3paynxtODspxItq/q19dRjphUWuFNa
         zPoA==
X-Gm-Message-State: AOAM531eSGek1vfQM0xwvsPVjbAbdVFtRMEU3yJJKpaPFMs34h7L0nPp
        Sbo7+OYSDbxkJAS4hgLnn3vvXysa
X-Google-Smtp-Source: ABdhPJzmRSiuWF4dj2ayKFimAwSZa2ooMZkXBaxLi+oSgit6zh4hge4aw1/KN17nzyHUOSbBoRz2vQ==
X-Received: by 2002:a17:906:b888:: with SMTP id hb8mr600558ejb.124.1594658302180;
        Mon, 13 Jul 2020 09:38:22 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id c15sm12578174edm.47.2020.07.13.09.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:38:21 -0700 (PDT)
Date:   Mon, 13 Jul 2020 19:38:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 3/4] net: enetc: Initialize SerDes for SGMII
 and USXGMII protocols
Message-ID: <20200713163819.uwb6rxlapexkoyre@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-4-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:25PM +0200, Michael Walle wrote:
> ENETC has ethernet MACs capable of SGMII, 2500BaseX and USXGMII. But in
> order to use these protocols some SerDes configurations need to be
> performed. The SerDes is configurable via an internal PCS PHY which is
> connected to an internal MDIO bus at address 0.
> 
> This patch basically removes the dependency on bootloader regarding
> SerDes initialization.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---

As mentioned earlier, this works for SGMII. For USXGMII, it would also
need this patch to work (something which is also true of Felix):

https://patchwork.ozlabs.org/project/netdev/patch/20200712164815.1763532-1-olteanv@gmail.com/

Considering that patch as external to this series:

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  .../net/ethernet/freescale/enetc/enetc_hw.h   |   3 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 135 ++++++++++++++++++
>  .../net/ethernet/freescale/enetc/enetc_pf.h   |   2 +
>  3 files changed, 140 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> index fc357bc56835..135bf46354ea 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -224,6 +224,9 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_PM0_MAXFRM	0x8014
>  #define ENETC_SET_TX_MTU(val)	((val) << 16)
>  #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
> +
> +#define ENETC_PM_IMDIO_BASE	0x8030
> +
>  #define ENETC_PM0_IF_MODE	0x8300
>  #define ENETC_PMO_IFM_RG	BIT(2)
>  #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 4fac57dbb3c8..662740874841 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  /* Copyright 2017-2019 NXP */
>  
> +#include <linux/mdio.h>
>  #include <linux/module.h>
>  #include <linux/fsl/enetc_mdio.h>
>  #include <linux/of_mdio.h>
> @@ -833,6 +834,135 @@ static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
>  		of_node_put(priv->phy_node);
>  }
>  
> +static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
> +{
> +	struct device *dev = &pf->si->pdev->dev;
> +	struct enetc_mdio_priv *mdio_priv;
> +	struct phy_device *pcs;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "Freescale ENETC internal MDIO Bus";
> +	bus->read = enetc_mdio_read;
> +	bus->write = enetc_mdio_write;
> +	bus->parent = dev;
> +	bus->phy_mask = ~0;
> +	mdio_priv = bus->priv;
> +	mdio_priv->hw = &pf->si->hw;
> +	mdio_priv->mdio_base = ENETC_PM_IMDIO_BASE;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
> +
> +	err = mdiobus_register(bus);
> +	if (err) {
> +		dev_err(dev, "cannot register internal MDIO bus (%d)\n", err);
> +		goto free_mdio_bus;
> +	}
> +
> +	pcs = get_phy_device(bus, 0, is_c45);
> +	if (IS_ERR(pcs)) {
> +		err = PTR_ERR(pcs);
> +		dev_err(dev, "cannot get internal PCS PHY (%d)\n", err);
> +		goto unregister_mdiobus;
> +	}
> +
> +	pf->imdio = bus;
> +	pf->pcs = pcs;
> +
> +	return 0;
> +
> +unregister_mdiobus:
> +	mdiobus_unregister(bus);
> +free_mdio_bus:
> +	mdiobus_free(bus);
> +	return err;
> +}
> +
> +static void enetc_imdio_remove(struct enetc_pf *pf)
> +{
> +	if (pf->pcs)
> +		put_device(&pf->pcs->mdio.dev);
> +	if (pf->imdio) {
> +		mdiobus_unregister(pf->imdio);
> +		mdiobus_free(pf->imdio);
> +	}
> +}
> +
> +static void enetc_configure_sgmii(struct phy_device *pcs)
> +{
> +	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
> +	 * for the MAC PCS in order to acknowledge the AN.
> +	 */
> +	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII | ADVERTISE_LPACK);
> +
> +	phy_write(pcs, ENETC_PCS_IF_MODE,
> +		  ENETC_PCS_IF_MODE_SGMII_EN |
> +		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
> +
> +	/* Adjust link timer for SGMII */
> +	phy_write(pcs, ENETC_PCS_LINK_TIMER1, ENETC_PCS_LINK_TIMER1_VAL);
> +	phy_write(pcs, ENETC_PCS_LINK_TIMER2, ENETC_PCS_LINK_TIMER2_VAL);
> +
> +	phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
> +}
> +
> +static void enetc_configure_2500basex(struct phy_device *pcs)
> +{
> +	phy_write(pcs, ENETC_PCS_IF_MODE,
> +		  ENETC_PCS_IF_MODE_SGMII_EN |
> +		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
> +
> +	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_RESET);
> +}
> +
> +static void enetc_configure_usxgmii(struct phy_device *pcs)
> +{
> +	/* Configure device ability for the USXGMII Replicator */
> +	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
> +		      ADVERTISE_SGMII | ADVERTISE_LPACK |
> +		      MDIO_LPA_USXGMII_FULL_DUPLEX);
> +
> +	/* Restart PCS AN */
> +	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
> +		      BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
> +}
> +
> +static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
> +{
> +	bool is_c45 = priv->if_mode == PHY_INTERFACE_MODE_USXGMII;
> +	struct enetc_pf *pf = enetc_si_priv(priv->si);
> +	int err;
> +
> +	if (priv->if_mode != PHY_INTERFACE_MODE_SGMII &&
> +	    priv->if_mode != PHY_INTERFACE_MODE_2500BASEX &&
> +	    priv->if_mode != PHY_INTERFACE_MODE_USXGMII)
> +		return 0;
> +
> +	err = enetc_imdio_init(pf, is_c45);
> +	if (err)
> +		return err;
> +
> +	switch (priv->if_mode) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +		enetc_configure_sgmii(pf->pcs);
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		enetc_configure_2500basex(pf->pcs);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		enetc_configure_usxgmii(pf->pcs);
> +		break;
> +	default:
> +		dev_err(&pf->si->pdev->dev, "Unsupported link mode %s\n",
> +			phy_modes(priv->if_mode));
> +	}
> +
> +	return 0;
> +}
> +
>  static int enetc_pf_probe(struct pci_dev *pdev,
>  			  const struct pci_device_id *ent)
>  {
> @@ -897,6 +1027,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  	if (err)
>  		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
>  
> +	err = enetc_configure_serdes(priv);
> +	if (err)
> +		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
> +
>  	err = register_netdev(ndev);
>  	if (err)
>  		goto err_reg_netdev;
> @@ -932,6 +1066,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
>  	priv = netdev_priv(si->ndev);
>  	unregister_netdev(si->ndev);
>  
> +	enetc_imdio_remove(pf);
>  	enetc_mdio_remove(pf);
>  	enetc_of_put_phy(priv);
>  
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> index 59e65a6f6c3e..2cb922b59f46 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> @@ -44,6 +44,8 @@ struct enetc_pf {
>  	DECLARE_BITMAP(active_vlans, VLAN_N_VID);
>  
>  	struct mii_bus *mdio; /* saved for cleanup */
> +	struct mii_bus *imdio;
> +	struct phy_device *pcs;
>  };
>  
>  int enetc_msg_psi_init(struct enetc_pf *pf);
> -- 
> 2.20.1
> 
