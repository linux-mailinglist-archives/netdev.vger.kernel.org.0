Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CAF4280E0
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhJJLml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhJJLmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D13C061764;
        Sun, 10 Oct 2021 04:40:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b8so55516008edk.2;
        Sun, 10 Oct 2021 04:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwHHSl6iZFkJFRf7Rx7RAcQVkeUEshDkhUR0gfMkh98=;
        b=S0+Xca3eP7sEa6Y/D2sXWtKshGHKw62dsaYuv9uvDLjnFyzpzfcRze691IvPS1/EGa
         hKDyVtRvj7ZmFJqabg2jdSMGpWp/sUw3M/nBIbz3j8cdHcYnTFlzAc2wi48xTslcstJC
         mEZbrlUWScXx1NYBioV6nnBpDkJuDBBwe6HJvq61hGbcn76M7ZWwr+gWYlU5q/z4mJRW
         qntp1uS5fUX+Sq4qID/mhEXRAXQw9BCNi+vXH3Ls1Ge8s3aCukl8eH2A1SIHW1EszOM2
         ApneXSOGvEa1m6rwcwUjGKhMORAy7g489uOhWMQCqBQvYpvsLPvFXce+YEys+ff5TBbg
         ro9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZwHHSl6iZFkJFRf7Rx7RAcQVkeUEshDkhUR0gfMkh98=;
        b=45QtJ0/Zpo1UWJeJm/hlk8eIXBgIl/fj3YvmJyf4nXx665irGmLksQ1vbsDY4FR5wZ
         Ex3MSsmcT4PHryE3VtWc4uyTovdohSDVVaoAmghpBOmaTRZsEAZ/7VglsdSH7lU9oaZG
         3VuCrAaLnAmJSW9ZrvuNSBeLKbTmKVmTn4IalkUlEBm/FBaRDFx+qT5CPkaFkTQgWM0G
         nYJ5CPnAngqhfGpJPnLprT8OUn0vWugvi4cxYARdfzHkkJkW0gj9vJbz7LWP/FfRWCcI
         1CW5GJF+dl8jJsLO4JxjFqNuUVaVUaO8WSTNviuOUs6Mz5TG7vMW2KcxoKF5v5LaVDMP
         h5OQ==
X-Gm-Message-State: AOAM530+agQoBIz1KYxk8FDTVulpwehChpo7otg/VWh6mVNAlHPiapDo
        l9yOGh1Feujnxd9/AJfQUqU=
X-Google-Smtp-Source: ABdhPJwiShsIHfMG7RhBDJFf5zBNvqiWrgyNebz12Ge/FvGRVUM04yjEYomLUmeJW069ama1yILrsQ==
X-Received: by 2002:a17:907:6010:: with SMTP id fs16mr15356405ejc.266.1633866039360;
        Sun, 10 Oct 2021 04:40:39 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id g17sm2425195edv.72.2021.10.10.04.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:40:38 -0700 (PDT)
Date:   Sun, 10 Oct 2021 14:40:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH 07/13] net: dsa: qca8k: add support for
 mac6_exchange, sgmii falling edge
Message-ID: <20211010114037.2xy65gbdeshpwg2s@skbuf>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:57AM +0200, Ansuel Smith wrote:
> Some device set the switch to exchange the mac0 port with mac6 port. Add
> support for this in the qca8k driver. Also add support for SGMII rx/tx
> clock falling edge. This is only present for pad0, pad5 and pad6 have
> these bit reserved from Documentation.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  3 +++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 5bce7ac4dea7..3a040a3ed58e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -973,6 +973,34 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
>  	return ret;
>  }
>  
> +static int
> +qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
> +{
> +	struct device_node *node = priv->dev->of_node;
> +	u32 mask = 0;
> +	int ret = 0;
> +
> +	/* Swap MAC0-MAC6 */
> +	if (of_property_read_bool(node, "qca,mac6-exchange"))
> +		mask |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;
> +
> +	/* SGMII Clock phase configuration */
> +	if (of_property_read_bool(node, "qca,sgmii-rxclk-falling-edge"))
> +		mask |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> +
> +	if (of_property_read_bool(node, "qca,sgmii-txclk-falling-edge"))
> +		mask |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> +
> +	if (mask)
> +		ret = qca8k_rmw(priv, QCA8K_REG_PORT0_PAD_CTRL,
> +				QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG |
> +				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> +				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> +				mask);
> +
> +	return ret;
> +}
> +
>  static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
> @@ -1006,6 +1034,11 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Configure additional PORT0_PAD_CTRL properties */
> +	ret = qca8k_setup_port0_pad_ctrl_reg(priv);
> +	if (ret)
> +		return ret;
> +
>  	/* Enable CPU Port */
>  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
>  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index fc7db94cc0c9..3fded69a6839 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -35,6 +35,9 @@
>  #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
>  #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
>  #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> +#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)

Where can I find more information about this mac0/mac6 exchange? In this
document for ar8327, bit 31 of PORT0 PAD MODE CTRL is reserved.
http://www.datasheet.es/PDF/771154/AR8327-pdf.html

> +#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> +#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
>  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
>  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
>  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> -- 
> 2.32.0
> 
