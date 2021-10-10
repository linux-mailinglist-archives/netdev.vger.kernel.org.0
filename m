Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9146642815D
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhJJMtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhJJMtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:49:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56288C061745;
        Sun, 10 Oct 2021 05:47:35 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b8so55970646edk.2;
        Sun, 10 Oct 2021 05:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OS0MBKfnqyglG28DvY1QiRG3YhG3y071RIW9V3K+ZJo=;
        b=FVQx+D1nE2INiVnJ+PyG9T3Lxh7kJLEBnviKdnvqmm7A+1kzWyfl342fwDXk6gcQGh
         DChzuIB7swdab7txfWto+o6lt0Mb+sw9ds+qmyFNEFhj5zZCLGXaTGfA6xkfos7TyPLD
         elpDGNGsg9CIuQqsoceZ5Or8yoIcEzlnS2oK4pky7jYay0mj5XnANX7sJzp7rJ3Ea6I7
         VoHA0+ylW60PwGdT6dsBhHcomSZnVhl4PPi9S5hjQ5dDqii407S3SozCHkszPgQqo/QQ
         FnMXs/m9cvcncERKVrBSDLGC5eETUL8z3NNg7uefkJFxRh0v8KvhVkNXPasksT30eaEX
         CcUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OS0MBKfnqyglG28DvY1QiRG3YhG3y071RIW9V3K+ZJo=;
        b=V/m+0iwEaCAR4uaqqUHGh7e9VCx4UkoXiGNu5qOHlaW1XFOC8e1Lw7ZPckA3U1EsXr
         xC0OACOvxl12aOtAs5hnjx8x6bnMqGek+HzBHtzWCAsmwF0FmeHVzVA3M34EQA3eNM48
         G2YG5SufNrhFNQEBsJPfNKIJ/4xHG0q/qrcPbrFoN3Rmak0dYMluYO7W80eSEq9IL2/a
         1DTAmAqJWLrWpIifv0BSAOUCoj2lRRwiQOghGGHSJEzPn7JX2d89zWxqgvqUY65+FjGY
         Oq4rJrZB0O1vzMEjDJL7wem7y6B23s6HAwNISpBj8vuLIc6V6aV4vZM2z3zBI+ijF/Kh
         7aiw==
X-Gm-Message-State: AOAM532xbed7z7W1itaWATqA8et6cb3D/HsOEjH6cl0qzEufTTXic/Al
        V4MsVW4BVzJUXcfYhcNbVcc=
X-Google-Smtp-Source: ABdhPJz3wVn0C4XeCRzhMpjo+HFLN8Y5j/TLV+UaSP6c/xMaMogrpbgNi54lV6v8CRfLxN453NZs+A==
X-Received: by 2002:a50:d80d:: with SMTP id o13mr32677044edj.204.1633870053851;
        Sun, 10 Oct 2021 05:47:33 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id l8sm2053708ejn.103.2021.10.10.05.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:47:33 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:47:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay
 detection to phylink mac_config
Message-ID: <20211010124732.fageoraoweqqfoew@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:49PM +0200, Ansuel Smith wrote:
> Future proof commit. This switch have 2 CPU port and one valid
> configuration is first CPU port set to sgmii and second CPU port set to
> regmii-id. The current implementation detects delay only for CPU port
> zero set to rgmii and doesn't count any delay set in a secondary CPU
> port. Drop the current delay scan function and move it to the phylink
> mac_config to generilize and implicitly add support for secondary CPU
> port set to rgmii-id.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 121 +++++++++++++++-------------------------
>  drivers/net/dsa/qca8k.h |   2 -
>  2 files changed, 44 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index df0a622acdd7..126f20b0b94c 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -888,68 +888,6 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
>  	return 0;
>  }
>  
> -static int
> -qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)

I was actually going to say that since RGMII delays are runtime
invariants, you should move their entire programming to probe time, now
you move device tree parsing to runtime :-/

> -{
> -	struct device_node *port_dn;
> -	phy_interface_t mode;
> -	struct dsa_port *dp;
> -	u32 val;
> -
> -	/* CPU port is already checked */
> -	dp = dsa_to_port(priv->ds, 0);
> -
> -	port_dn = dp->dn;
> -
> -	/* Check if port 0 is set to the correct type */
> -	of_get_phy_mode(port_dn, &mode);
> -	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
> -	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
> -	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
> -		return 0;
> -	}
> -
> -	switch (mode) {
> -	case PHY_INTERFACE_MODE_RGMII_ID:
> -	case PHY_INTERFACE_MODE_RGMII_RXID:

Also, since you touch this area.
There have been tons of discussions on this topic, but I believe that
your interpretation of the RGMII delays is wrong.
Basically a MAC should not apply delays based on the phy-mode string (so
it should treat "rgmii" same as "rgmii-id"), but based on the value of
"rx-internal-delay-ps" and "tx-internal-delay-ps".
The phy-mode is for a PHY to use.

> -		if (of_property_read_u32(port_dn, "rx-internal-delay-ps", &val))
> -			val = 2;
> -		else
> -			/* Switch regs accept value in ns, convert ps to ns */
> -			val = val / 1000;
> -
> -		if (val > QCA8K_MAX_DELAY) {
> -			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
> -			val = 3;
> -		}
> -
> -		priv->rgmii_rx_delay = val;
> -		/* Stop here if we need to check only for rx delay */
> -		if (mode != PHY_INTERFACE_MODE_RGMII_ID)
> -			break;
> -
> -		fallthrough;
> -	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		if (of_property_read_u32(port_dn, "tx-internal-delay-ps", &val))
> -			val = 1;
> -		else
> -			/* Switch regs accept value in ns, convert ps to ns */
> -			val = val / 1000;
> -
> -		if (val > QCA8K_MAX_DELAY) {
> -			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
> -			val = 3;
> -		}
> -
> -		priv->rgmii_tx_delay = val;
> -		break;
> -	default:
> -		return 0;
> -	}
> -
> -	return 0;
> -}
> -
>  static int
>  qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
>  {
> @@ -1019,10 +957,6 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> -	ret = qca8k_setup_of_rgmii_delay(priv);
> -	if (ret)
> -		return ret;
> -
>  	ret = qca8k_setup_mac_pwr_sel(priv);
>  	if (ret)
>  		return ret;
> @@ -1190,7 +1124,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  {
>  	struct qca8k_priv *priv = ds->priv;
>  	struct dsa_port *dp;
> -	u32 reg, val;
> +	u32 reg, val, delay;
>  	int ret;
>  
>  	switch (port) {
> @@ -1241,17 +1175,50 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
> -		/* RGMII_ID needs internal delay. This is enabled through
> -		 * PORT5_PAD_CTRL for all ports, rather than individual port
> -		 * registers
> +		dp = dsa_to_port(ds, port);
> +		val = QCA8K_PORT_PAD_RGMII_EN;
> +
> +		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +		    state->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +			if (of_property_read_u32(dp->dn, "tx-internal-delay-ps", &delay))
> +				delay = 1;
> +			else
> +				/* Switch regs accept value in ns, convert ps to ns */
> +				delay = delay / 1000;
> +
> +			if (delay > QCA8K_MAX_DELAY) {
> +				dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
> +				delay = 3;
> +			}
> +
> +			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
> +			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
> +		}
> +
> +		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +		    state->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +			if (of_property_read_u32(dp->dn, "rx-internal-delay-ps", &delay))
> +				delay = 2;
> +			else
> +				/* Switch regs accept value in ns, convert ps to ns */
> +				delay = delay / 1000;
> +
> +			if (delay > QCA8K_MAX_DELAY) {
> +				dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
> +				delay = 3;
> +			}
> +
> +			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
> +			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
> +		}
> +
> +		/* Set RGMII delay based on the selected values */
> +		qca8k_write(priv, reg, val);
> +
> +		/* QCA8337 requires to set rgmii rx delay for all ports.
> +		 * This is enabled through PORT5_PAD_CTRL for all ports,
> +		 * rather than individual port registers.
>  		 */
> -		qca8k_write(priv, reg,
> -			    QCA8K_PORT_PAD_RGMII_EN |
> -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
> -			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> -		/* QCA8337 requires to set rgmii rx delay */
>  		if (priv->switch_id == QCA8K_ID_QCA8337)
>  			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
>  				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 5df0f0ef6526..a790b27bc310 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -259,8 +259,6 @@ struct qca8k_match_data {
>  struct qca8k_priv {
>  	u8 switch_id;
>  	u8 switch_revision;
> -	u8 rgmii_tx_delay;
> -	u8 rgmii_rx_delay;
>  	bool legacy_phy_port_mapping;
>  	struct regmap *regmap;
>  	struct mii_bus *bus;
> -- 
> 2.32.0
> 

