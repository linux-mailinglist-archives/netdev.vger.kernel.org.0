Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6081A21DD9D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgGMQji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbgGMQja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:39:30 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A75C061755;
        Mon, 13 Jul 2020 09:39:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id br7so4127421ejb.5;
        Mon, 13 Jul 2020 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sYYg1qVVGGXBw/GUUamnS1vUTMkh98TJM2wDPy9E+j4=;
        b=SHYBl9E3+A41UcKb+jbw6VSpFlUDrtsHwWFZk1ystren5dx23MjEphN+eTUT5A1bSW
         QU/5NLfnhiZDH78f4gJ2PDcF1PHYDzOAweMxS0lRBkLXJ8ad3MRKfTkyoPSj06/NioHJ
         QX/qy4BTTwisESW3al5cXEpBFuRHoByfHKqVa495KL7e6vr67VGquuzVlElI/zBeQxN8
         MLP6SjmiQD/g62jYj/AYxcrw2nDtr2WlIbyM428H7E5dJvhiG0NZ6KNgKemuttCrdoxD
         QRCRF+DEhlpongtLJofakux1gsbV8dcZdDOElixlXIE1G/zj7cHAS8LqWwgzntmNFVkP
         n3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sYYg1qVVGGXBw/GUUamnS1vUTMkh98TJM2wDPy9E+j4=;
        b=BMb+RcHu5j9z20NrAdlR29r//AjXKacl8VBpjWhVVwqKwGP+uFOdTypQstOLJA3UAi
         h78ksKBog3YrTDH0fg9QW+GNq7p4RF28LFmFGikGggJW7rcTL1sdEqWRDZuwLYoG5yoQ
         +XdYapNkbQ6EzwVPUiEGVgFCJ2sByD7Sj72W1G5Z2j/byGDbRNn2m6sm0rSleXrNNUFr
         tbA1jkgxMYJKrI8SRLsevdPN15vBWIzJMv89nAqMt4a8FVqh/NiWlZQTWpSMbSauS/gd
         Tbdqr0C8kAoKYQLlthL/8pD24q6t4krRnZLTMqG9/tXGFZP6Sx9JYYnI5l+xQU9xHsCk
         vMgA==
X-Gm-Message-State: AOAM5315wGC6CI/xKmxHJFIEQ2l6/pZm4+n8i6K9dQepBjExXW1EEU6+
        IcO+WMBe3hiIk8BuniufECI=
X-Google-Smtp-Source: ABdhPJyx7i+hwbB0vK4h17NpnnPrlSd3LofIULxCm29FZ+oqdXNoVPuU+MFG5DiOkixIAQck9L8xMg==
X-Received: by 2002:a17:906:7694:: with SMTP id o20mr544368ejm.289.1594658369264;
        Mon, 13 Jul 2020 09:39:29 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id c9sm11945116edv.8.2020.07.13.09.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:39:28 -0700 (PDT)
Date:   Mon, 13 Jul 2020 19:39:26 +0300
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
Subject: Re: [PATCH net-next v6 4/4] net: enetc: Use DT protocol information
 to set up the ports
Message-ID: <20200713163926.fawm3qdfnr33bdhj@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-5-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:26PM +0200, Michael Walle wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> Use DT information rather than in-band information from bootloader to
> set up MAC for XGMII. For RGMII use the DT indication in addition to
> RGMII defaults in hardware.
> However, this implies that PHY connection information needs to be
> extracted before netdevice creation, when the ENETC Port MAC is
> being configured.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 57 ++++++++++---------
>  .../net/ethernet/freescale/enetc/enetc_pf.h   |  3 +
>  2 files changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 662740874841..dfc3acc841df 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -482,7 +482,8 @@ static void enetc_port_si_configure(struct enetc_si *si)
>  	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
>  }
>  
> -static void enetc_configure_port_mac(struct enetc_hw *hw)
> +static void enetc_configure_port_mac(struct enetc_hw *hw,
> +				     phy_interface_t phy_mode)
>  {
>  	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
>  		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
> @@ -498,9 +499,11 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
>  		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
>  		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
>  	/* set auto-speed for RGMII */
> -	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
> +	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
> +	    phy_interface_mode_is_rgmii(phy_mode))
>  		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
> -	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII)
> +
> +	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
>  		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
>  }
>  
> @@ -524,7 +527,7 @@ static void enetc_configure_port(struct enetc_pf *pf)
>  
>  	enetc_configure_port_pmac(hw);
>  
> -	enetc_configure_port_mac(hw);
> +	enetc_configure_port_mac(hw, pf->if_mode);
>  
>  	enetc_port_si_configure(pf->si);
>  
> @@ -776,27 +779,27 @@ static void enetc_mdio_remove(struct enetc_pf *pf)
>  		mdiobus_unregister(pf->mdio);
>  }
>  
> -static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
> +static int enetc_of_get_phy(struct enetc_pf *pf)
>  {
> -	struct enetc_pf *pf = enetc_si_priv(priv->si);
> -	struct device_node *np = priv->dev->of_node;
> +	struct device *dev = &pf->si->pdev->dev;
> +	struct device_node *np = dev->of_node;
>  	struct device_node *mdio_np;
>  	int err;
>  
> -	priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
> -	if (!priv->phy_node) {
> +	pf->phy_node = of_parse_phandle(np, "phy-handle", 0);
> +	if (!pf->phy_node) {
>  		if (!of_phy_is_fixed_link(np)) {
> -			dev_err(priv->dev, "PHY not specified\n");
> +			dev_err(dev, "PHY not specified\n");
>  			return -ENODEV;
>  		}
>  
>  		err = of_phy_register_fixed_link(np);
>  		if (err < 0) {
> -			dev_err(priv->dev, "fixed link registration failed\n");
> +			dev_err(dev, "fixed link registration failed\n");
>  			return err;
>  		}
>  
> -		priv->phy_node = of_node_get(np);
> +		pf->phy_node = of_node_get(np);
>  	}
>  
>  	mdio_np = of_get_child_by_name(np, "mdio");
> @@ -804,15 +807,15 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
>  		of_node_put(mdio_np);
>  		err = enetc_mdio_probe(pf);
>  		if (err) {
> -			of_node_put(priv->phy_node);
> +			of_node_put(pf->phy_node);
>  			return err;
>  		}
>  	}
>  
> -	err = of_get_phy_mode(np, &priv->if_mode);
> +	err = of_get_phy_mode(np, &pf->if_mode);
>  	if (err) {
> -		dev_err(priv->dev, "missing phy type\n");
> -		of_node_put(priv->phy_node);
> +		dev_err(dev, "missing phy type\n");
> +		of_node_put(pf->phy_node);
>  		if (of_phy_is_fixed_link(np))
>  			of_phy_deregister_fixed_link(np);
>  		else
> @@ -824,14 +827,14 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
>  	return 0;
>  }
>  
> -static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
> +static void enetc_of_put_phy(struct enetc_pf *pf)
>  {
> -	struct device_node *np = priv->dev->of_node;
> +	struct device_node *np = pf->si->pdev->dev.of_node;
>  
>  	if (np && of_phy_is_fixed_link(np))
>  		of_phy_deregister_fixed_link(np);
> -	if (priv->phy_node)
> -		of_node_put(priv->phy_node);
> +	if (pf->phy_node)
> +		of_node_put(pf->phy_node);
>  }
>  
>  static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
> @@ -994,6 +997,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  	pf->si = si;
>  	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
>  
> +	err = enetc_of_get_phy(pf);
> +	if (err)
> +		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
> +
>  	enetc_configure_port(pf);
>  
>  	enetc_get_si_caps(si);
> @@ -1008,6 +1015,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  	enetc_pf_netdev_setup(si, ndev, &enetc_ndev_ops);
>  
>  	priv = netdev_priv(ndev);
> +	priv->phy_node = pf->phy_node;
> +	priv->if_mode = pf->if_mode;
>  
>  	enetc_init_si_rings_params(priv);
>  
> @@ -1023,10 +1032,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  		goto err_alloc_msix;
>  	}
>  
> -	err = enetc_of_get_phy(priv);
> -	if (err)
> -		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
> -
>  	err = enetc_configure_serdes(priv);
>  	if (err)
>  		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
> @@ -1040,7 +1045,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  err_reg_netdev:
> -	enetc_of_put_phy(priv);
>  	enetc_free_msix(priv);
>  err_alloc_msix:
>  	enetc_free_si_resources(priv);
> @@ -1048,6 +1052,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  	si->ndev = NULL;
>  	free_netdev(ndev);
>  err_alloc_netdev:
> +	enetc_of_put_phy(pf);
>  err_map_pf_space:
>  	enetc_pci_remove(pdev);
>  
> @@ -1068,7 +1073,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
>  
>  	enetc_imdio_remove(pf);
>  	enetc_mdio_remove(pf);
> -	enetc_of_put_phy(priv);
> +	enetc_of_put_phy(pf);
>  
>  	enetc_free_msix(priv);
>  
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> index 2cb922b59f46..0d0ee91282a5 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
> @@ -46,6 +46,9 @@ struct enetc_pf {
>  	struct mii_bus *mdio; /* saved for cleanup */
>  	struct mii_bus *imdio;
>  	struct phy_device *pcs;
> +
> +	struct device_node *phy_node;
> +	phy_interface_t if_mode;
>  };
>  
>  int enetc_msg_psi_init(struct enetc_pf *pf);
> -- 
> 2.20.1
> 
