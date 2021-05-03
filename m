Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7274B37102E
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 02:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhECA4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 20:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhECA4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 20:56:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D2C06174A;
        Sun,  2 May 2021 17:55:30 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l4so5378738ejc.10;
        Sun, 02 May 2021 17:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/0wYV+KQRkgUT3x70I08SzMx0S7g+ViUaU9GbXRInDw=;
        b=IbczB7VFtSBFa7r1QD6Iq4AyHLnfMLZQQJnWryWqhGJOMBeNJcJiM9IeloWMJ09myt
         K+gmUvQQoxUi934k4z754PBvB2ezLKezGeAHfT7pkztKbMwoK629M4nK7JaPrwd29Vjy
         o0SdivdhOD16xTNQn+Djh38NV54H0z430d8VGnfkAAz1hyE3uFu2W+MCebfkfRsr5Vq2
         +yZNAHQ3DGf6L7iQU0gOvaVPR09glD1t5BXgdj2USHgf3oQ3GifisbrU/kqc6fli+kKL
         urd2BbnFBjm/M1qWD8gZu0m4NPDiezceN+Bc1sFPWtg8MDeav1GXSrNq2/2Kr1lY7FeI
         Am6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/0wYV+KQRkgUT3x70I08SzMx0S7g+ViUaU9GbXRInDw=;
        b=rQ8FZrhjtFZq9LXGoMet6AvxqRzrhVbFRTisK3dB4WkfHg3ePwIiLa+WsJbExWK8qq
         r6aB2ogyz8G4TSuQ5PR7r8Vcp8fEL8mX2cb0HYO3XeWJ2dJd06NiSzncb3fRMyH5vScV
         0PC2k1mwjChrFg5tsySRn/QZ8/Oq6qxIyX6H1aMI4+6Cvnh8vGMxtIywke70UwEasjH1
         vGf7TM0N5fniLGbHnjKK19pCstTSmpbKY+pegcSgAEgpRQK8Rp5zAJRiKTHs+NMnqccR
         WG6ACs1oTJOndqYq5czg5ZXgMohpItZg2hXzz7rNGioLwG8D/ZV2/IHuv5TulUHVaDZG
         1eSw==
X-Gm-Message-State: AOAM531W7KWtIXr7yR+2Nx9Wp0E4Btjgv1bAaNaZbCSCro2+eMDxPCa/
        dDve8dBC7Ig3wGqm+5Joqbo=
X-Google-Smtp-Source: ABdhPJzDEZ0yimmyOg/I6uoW70xBlmonrOxaYY4Nmqe76ab9xHmEkibvYwrQepF4Qp9MHxm7opV5Rw==
X-Received: by 2002:a17:906:5248:: with SMTP id y8mr13944251ejm.150.1620003329351;
        Sun, 02 May 2021 17:55:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id lg20sm10174716ejb.13.2021.05.02.17.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 17:55:28 -0700 (PDT)
Date:   Mon, 3 May 2021 02:54:01 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v2 10/17] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YI9Jqd6bF37MqrWx@Ansuel-xps.localdomain>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
 <20210502230710.30676-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210502230710.30676-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 01:07:02AM +0200, Ansuel Smith wrote:
> The legacy qsdk code used a different delay instead of the max value.
> Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
> using the standard rx/tx-internal-delay-ps ethernet binding and apply
> qsdk values by default. The connected gmac doesn't add any delay so no
> additional delay is added to tx/rx.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h | 11 +++++----
>  2 files changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 5478bee39c6e..d522398d504e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -763,6 +763,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
>  	return 0;
>  }
>  
> +static int
> +qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
> +{
> +	struct device_node *ports, *port;
> +	u32 val;
> +
> +	ports = of_get_child_by_name(priv->dev->of_node, "ports");
> +	if (!ports)
> +		return -EINVAL;
> +
> +	/* Assume only one port with rgmii-id mode */
> +	for_each_available_child_of_node(ports, port) {
> +		if (!of_property_match_string(port, "phy-mode", "rgmii-id"))
> +			continue;
> +
> +		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
> +			val = 2;
> +
> +		if (val > QCA8K_MAX_DELAY) {
> +			dev_err(priv->dev, "rgmii rx delay is limited to more than 3ps, setting to the max value");
> +			priv->rgmii_rx_delay = 3;
> +		} else {
> +			priv->rgmii_rx_delay = val;
> +		}
> +
> +		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
> +			val = 1;
> +

Sorry some mistake here. Will be fixed in v3 for sure.

> +		if (val > QCA8K_MAX_DELAY) {
> +			dev_err(priv->dev, "rgmii tx delay is limited to more than 3ps, setting to the max value");
> +			priv->rgmii_tx_delay = 3;
> +		} else {
> +			priv->rgmii_rx_delay = val;

And here.

> +		}
> +	}
> +
> +	of_node_put(ports);
> +
> +	return 0;
> +}
> +
>  static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
> @@ -792,6 +833,10 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	ret = qca8k_setup_of_rgmii_delay(priv);
> +	if (ret)
> +		return ret;
> +
>  	/* Enable CPU Port */
>  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
>  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> @@ -1003,8 +1048,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		 */
>  		qca8k_write(priv, reg,
>  			    QCA8K_PORT_PAD_RGMII_EN |
> -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
>  		/* QCA8337 requires to set rgmii rx delay */
>  		if (data->id == QCA8K_ID_QCA8337)
>  			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 0b503f78bf92..80830bb42736 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -36,12 +36,11 @@
>  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
>  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
>  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> -#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
> -						((0x8 + (x & 0x3)) << 22)
> -#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
> -						((0x10 + (x & 0x3)) << 20)
> -#define   QCA8K_MAX_DELAY				3
> +#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
> +#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
> +#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
>  #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
> +#define   QCA8K_MAX_DELAY				3
>  #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
>  #define QCA8K_REG_PWS					0x010
>  #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
> @@ -251,6 +250,8 @@ struct qca8k_match_data {
>  
>  struct qca8k_priv {
>  	u8 switch_revision;
> +	u8 rgmii_tx_delay;
> +	u8 rgmii_rx_delay;
>  	struct regmap *regmap;
>  	struct mii_bus *bus;
>  	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
> -- 
> 2.30.2
> 
