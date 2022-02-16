Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306064B8CC5
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiBPPpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:45:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiBPPpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:45:33 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398E129C120
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:45:21 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x5so4565064edd.11
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NCJ1gg6xUqcIKO+Iy3gjvKwJyu2pifvFc9uwUl/mE7g=;
        b=RnOgZTDsaU+6dE/IwDFxBqQ4PE6BCEXzV++1VRO2eJny/6/hsnKSWHnYDqRnd/XcKO
         3Y2GKmY3Pwxex1CNVz20BHTbJDzzDXdlYX52WdlAYU67EhqTCmVsOrYdYY9sp0XXoXDx
         qE/fkT6DGHPFpE7kaCEYBSzEbaFHUUH4K9Q8N0253GGWFVHFHFzr9h1lmP5CQQB0l8ZU
         HXWcs+dIWKKiBLqgA0y+63mOqKJpI5i8Zkeqjl/8M27MRCqutUrKSHU/+4m2u6Uj0Tm0
         pUO9OvRPCzFX7a6QxaQNE4M0R4fQBtmattI96t9LUMS4pQipK/z+b5p6cEWUg5rKr0yp
         lVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NCJ1gg6xUqcIKO+Iy3gjvKwJyu2pifvFc9uwUl/mE7g=;
        b=I9zcSrpfIXOAodKfeF4iJbxGJSInBwy34+25dvbOoNVqtCsg/vgXJinMXPDrV1xlrv
         vIvxRi2KeXacnypYyZagePdhbAEC74tQmtsGdZc4ra0Sq0qUap+VIm7aLgmF1c0tvP65
         bPNMV2C33sdMRElAamoyhwFDsheOu8G3OqSpfcV0JzwbT1N257VYfUoEweZIqwAGthYB
         Yt+x8rc05X85IKK5Zi8MsSi7OrojDQUHasfF5IUPXmwOUfFF2dxCUe+oDblEYHwhylOy
         hnMsLli2VEcKwCgQtdjkz8/X3vBKYmfKPcoA5WLPoKE5p51odfth1pCuNFOtnPe9J/ZA
         Fsxg==
X-Gm-Message-State: AOAM532wFSGop5kmmNK1tsY7s28C0f/BwDiPpT6lZKE6k1D/Sf+jt81I
        Vlxol86Z3PdXbhvmwF3bOOI=
X-Google-Smtp-Source: ABdhPJxXDa1sbBttGASJ9RrAe6CRB5xoWQ1Tcs7H4H8XHeKVsD6SDD1p19IAniGUfuUY2giC8A71YA==
X-Received: by 2002:a05:6402:d6e:b0:410:8169:46de with SMTP id ec46-20020a0564020d6e00b00410816946demr3626529edb.328.1645026319796;
        Wed, 16 Feb 2022 07:45:19 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id m25sm44936ejl.38.2022.02.16.07.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 07:45:19 -0800 (PST)
Date:   Wed, 16 Feb 2022 17:45:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 5/6] net: dsa: qca8k: move pcs configuration
Message-ID: <20220216154518.piewevdckvxhzkbe@skbuf>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
 <E1nKLsr-009NN1-HQ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nKLsr-009NN1-HQ@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 03:06:21PM +0000, Russell King (Oracle) wrote:
> @@ -1981,6 +1917,89 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  			    const unsigned long *advertising,
>  			    bool permit_pause_to_mac)
>  {
> +	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
> +	int cpu_port_index, ret, port;
> +	u32 reg, val;
> +
> +	port = pcs_to_qca8k_pcs(pcs)->port;
> +	switch (port) {
> +	case 0:
> +		reg = QCA8K_REG_PORT0_PAD_CTRL;
> +		cpu_port_index = QCA8K_CPU_PORT0;
> +		break;
> +
> +	case 6:
> +		reg = QCA8K_REG_PORT6_PAD_CTRL;
> +		cpu_port_index = QCA8K_CPU_PORT6;
> +		break;
> +
> +	default:
> +		WARN_ON(1);
> +	}
> +
> +	/* Enable/disable SerDes auto-negotiation as necessary */
> +	ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
> +	if (ret)
> +		return ret;
> +	if (phylink_autoneg_inband(mode))
> +		val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> +	else
> +		val |= QCA8K_PWS_SERDES_AEN_DIS;
> +	qca8k_write(priv, QCA8K_REG_PWS, val);
> +
> +	/* Configure the SGMII parameters */
> +	ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
> +	if (ret)
> +		return ret;
> +
> +	val |= QCA8K_SGMII_EN_SD;
> +
> +	if (priv->ports_config.sgmii_enable_pll)
> +		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +		       QCA8K_SGMII_EN_TX;
> +
> +	if (dsa_is_cpu_port(priv->ds, port)) {
> +		/* CPU port, we're talking to the CPU MAC, be a PHY */
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +		val |= QCA8K_SGMII_MODE_CTRL_PHY;
> +	} else if (interface == PHY_INTERFACE_MODE_SGMII) {
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +		val |= QCA8K_SGMII_MODE_CTRL_MAC;
> +	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +		val |= QCA8K_SGMII_MODE_CTRL_BASEX;
> +	}
> +
> +	qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
> +
> +	/* From original code is reported port instability as SGMII also
> +	 * require delay set. Apply advised values here or take them from DT.
> +	 */
> +	if (interface == PHY_INTERFACE_MODE_SGMII)
> +		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
> +	/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
> +	 * falling edge is set writing in the PORT0 PAD reg
> +	 */
> +	if (priv->switch_id == QCA8K_ID_QCA8327 ||
> +	    priv->switch_id == QCA8K_ID_QCA8337)
> +		reg = QCA8K_REG_PORT0_PAD_CTRL;
> +
> +	val = 0;
> +
> +	/* SGMII Clock phase configuration */
> +	if (priv->ports_config.sgmii_rx_clk_falling_edge)
> +		val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> +
> +	if (priv->ports_config.sgmii_tx_clk_falling_edge)
> +		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> +
> +	if (val)
> +		ret = qca8k_rmw(priv, reg,
> +				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> +				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> +				val);
> +
> +

Would be nice to avoid two consecutive empty lines at the end.

>  	return 0;
>  }
>  
> -- 
> 2.30.2
> 

