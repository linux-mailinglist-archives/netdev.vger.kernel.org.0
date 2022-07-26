Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04B58118B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiGZLCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:02:34 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158430552
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:02:32 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id os14so25512268ejb.4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QwaufTLNnXB5FddtANksePws8x1bJKS0eE9Pm+G0XqM=;
        b=YVQgyvSE1TTA9HP4CfjwEZ5pD024aBwaEG6tumZpIwPTepKRd4xor4erirIYcMu7Vf
         PXvpFQYpOvOcn1wZ14F2obB+GE6UVDBsvQ+elOSzesmL6nhSkv9p8uXBqIKDD8WBbS4x
         izND7aXMAznRKWKA8+Q2b5J+JJsO938lERMIe8xE6XL9RGTPv5iTSs/L5X3i3ck9rslK
         XjlzFTHfcNPxwQBZHByztlIn0++YVKiTZLwLN8frQIy74G9ZWKn7RgTnK5DHRQjPlsse
         vN0uO8O9QvFxAn/TgoHASZxX/63XzM/z62O/tO8x/q3f9hY218WHSgMec+U9Pqgot7wd
         rOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QwaufTLNnXB5FddtANksePws8x1bJKS0eE9Pm+G0XqM=;
        b=4J5TYZeRm3JCWWzaiDCI+XGfR7155KC5AV/kVHJDlA9S32qUJ4WpAujpR/ZU/RsO9D
         bYjkgm/ccPDEqva2B10ZKLrJg3ig1REjJRRNpYpgHUC1HUB+jawN1VA8Vk1zASc34+tZ
         UtKPgEJCIj8UN01TJBKINw8LefYKoOxyFIzf6g/jgEY2V/FstxCOCqc/BAZtIhZ/jHcv
         HhtL9xjUOC3b+2c8xobh0KziW+3lf7shLRVIVs24G+lK4yNH0P8L4/M0Oeez4WFv9lZu
         qP/8rIvSPJibpFiA5Mf9G+YEjLaa8bMG6QFr9oA5aM92OtMeDv1+CWLSMW+pksEH8Czr
         dM2Q==
X-Gm-Message-State: AJIora/TWRMfFigh9CZoBJnmn0sVjVupIaIX6rbFFKrgCS/4zJI5swjh
        qNzZ1rKaIl/gER3tTVccMTw=
X-Google-Smtp-Source: AGRyM1su5awHQLIj661/xGrW2G0urV0BCjzcFku6iv/dHXtVBJFg7k+Srb0wA5WsQfBCV1SsNCM7Ew==
X-Received: by 2002:a17:906:84e1:b0:72b:b109:7636 with SMTP id zp1-20020a17090684e100b0072bb1097636mr14643940ejb.10.1658833351190;
        Tue, 26 Jul 2022 04:02:31 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kx19-20020a170907775300b0072fc952b57csm3497764ejc.55.2022.07.26.04.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 04:02:30 -0700 (PDT)
Date:   Tue, 26 Jul 2022 14:02:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8366rb: Configure ports
 properly
Message-ID: <20220726110228.eook6krfpnb7gtwj@skbuf>
References: <20220725202957.2460420-1-linus.walleij@linaro.org>
 <20220725202957.2460420-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220725202957.2460420-1-linus.walleij@linaro.org>
 <20220725202957.2460420-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Mon, Jul 25, 2022 at 10:29:57PM +0200, Linus Walleij wrote:
> Instead of just hammering the CPU port up at 1GBit at
> .phylink_mac_link_up calls for that specific port, support
> configuring any port: this works like a charm.

Could you clarify what is intended to be functionally improved with this
change, exactly?

According to your phylink_get_caps() implementation, I see that all
ports are internal, so presumably the CPU ports too (and the user ports
are connected to internal PHYs).

Is it just to act upon the phylink parameters rather than assuming the
CPU port is at gigabit? Can you actually set the CPU port at lower rates?

As for the internal PHY ports, do they need their link speed to be
forced at 10/100, or did those previously work at those lower speeds,
just left unforced?

> 
> Drop the code to enable/disable the port in the
> .phylink_mac_link_up/.phylink_mac_link_down callbacks:
> this is handled perfectly well by the callbacks to
> .port_enable/.port_disable.
> 
> Tested on the D-Link DIR-685.
> 
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/net/dsa/realtek/rtl8366rb.c | 155 ++++++++++++++++++++--------
>  1 file changed, 111 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
> index 25f88022b9e4..6ef8449d3e7a 100644
> --- a/drivers/net/dsa/realtek/rtl8366rb.c
> +++ b/drivers/net/dsa/realtek/rtl8366rb.c
> @@ -95,12 +95,6 @@
>  #define RTL8366RB_PAACR_RX_PAUSE	BIT(6)
>  #define RTL8366RB_PAACR_AN		BIT(7)
>  
> -#define RTL8366RB_PAACR_CPU_PORT	(RTL8366RB_PAACR_SPEED_1000M | \
> -					 RTL8366RB_PAACR_FULL_DUPLEX | \
> -					 RTL8366RB_PAACR_LINK_UP | \
> -					 RTL8366RB_PAACR_TX_PAUSE | \
> -					 RTL8366RB_PAACR_RX_PAUSE)
> -
>  /* bits 0..7 = port 0, bits 8..15 = port 1 */
>  #define RTL8366RB_PSTAT0		0x0014
>  /* bits 0..7 = port 2, bits 8..15 = port 3 */
> @@ -1049,63 +1043,134 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
>  	return DSA_TAG_PROTO_RTL4_A;
>  }
>  
> -static void
> -rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
> -		      phy_interface_t interface, struct phy_device *phydev,
> -		      int speed, int duplex, bool tx_pause, bool rx_pause)
> +static void rtl8366rb_link_get_caps(struct dsa_switch *ds, int port,
> +				    struct phylink_config *config)
>  {
> -	struct realtek_priv *priv = ds->priv;
> -	int ret;
> +	/* The SYM and ASYM pause is RX and TX pause */

No, SYM and ASYM pause are not RX and TX pause, but rather they are
advertisement bits. After autoneg completes, the 4 SYM and ASYM pause
advertisement bits of you and your link partner get resolved independently
by you and your link partner according to the table described in
linkmode_resolve_pause(), and the result of that resolution is what RX
and TX pause are.

> +	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> +				   MAC_10 | MAC_100 | MAC_1000;
>  
> -	if (port != priv->cpu_port)
> -		return;
> +	/* These are all internal, no external interfaces supported */
> +	__set_bit(PHY_INTERFACE_MODE_INTERNAL, config->supported_interfaces);
>  
> -	dev_dbg(priv->dev, "MAC link up on CPU port (%d)\n", port);
> +	/* GMII is the default interface mode for phylib, so
> +	 * we have to support it for ports with integrated PHY.
> +	 */
> +	__set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
> +}
>  
> -	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
> -	ret = regmap_update_bits(priv->map, RTL8366RB_MAC_FORCE_CTRL_REG,
> -				 BIT(port), BIT(port));
> -	if (ret) {
> -		dev_err(priv->dev, "failed to force 1Gbit on CPU port\n");
> -		return;
> +static int rtl8366rb_config_link(struct realtek_priv *priv, int port, bool link,
> +				 int speed, int duplex, bool tx_pause, bool rx_pause)
> +{
> +	u32 paacr;
> +	u32 portreg;
> +	u32 portmask;
> +	u32 portshift;
> +	int ret;
> +
> +	switch (port) {
> +	case 0:
> +		portreg = RTL8366RB_PAACR0;
> +		portshift = 0;
> +		break;
> +	case 1:
> +		portreg = RTL8366RB_PAACR0;
> +		portshift = 8;
> +		break;
> +	case 2:
> +		portreg = RTL8366RB_PAACR1;
> +		portshift = 0;
> +		break;
> +	case 3:
> +		portreg = RTL8366RB_PAACR1;
> +		portshift = 8;
> +		break;
> +	case 4:
> +		portreg = RTL8366RB_PAACR2;
> +		portshift = 0;
> +		break;
> +	case 5:
> +		portreg = RTL8366RB_PAACR2;
> +		portshift = 8;
> +		break;
> +	default:
> +		dev_err(priv->dev, "illegal port %d\n", port);
> +		return -EINVAL;
>  	}
>  
> -	ret = regmap_update_bits(priv->map, RTL8366RB_PAACR2,
> -				 0xFF00U,
> -				 RTL8366RB_PAACR_CPU_PORT << 8);
> -	if (ret) {
> -		dev_err(priv->dev, "failed to set PAACR on CPU port\n");
> -		return;
> +	portmask = GENMASK(portshift + 7, portshift);
> +
> +	if (link) {
> +		switch (speed) {
> +		case SPEED_1000:
> +			paacr = RTL8366RB_PAACR_SPEED_1000M;
> +			dev_dbg(priv->dev, "set port %d to 1Gbit\n", port);
> +			break;
> +		case SPEED_100:
> +			paacr = RTL8366RB_PAACR_SPEED_100M;
> +			dev_dbg(priv->dev, "set port %d to 100Mbit\n", port);
> +			break;
> +		case SPEED_10:
> +			paacr = RTL8366RB_PAACR_SPEED_10M;
> +			dev_dbg(priv->dev, "set port %d to 10Mbit\n", port);
> +			break;
> +		default:
> +			dev_err(priv->dev, "illegal speed request on port %d\n", port);
> +			return -EINVAL;
> +		}
> +
> +		if (duplex == DUPLEX_FULL)
> +			paacr |= RTL8366RB_PAACR_FULL_DUPLEX;
> +		dev_dbg(priv->dev, "set port %d to %s duplex\n", port,
> +			(duplex == DUPLEX_FULL) ? "full" : "half");
> +
> +		if (tx_pause)
> +			paacr |= RTL8366RB_PAACR_TX_PAUSE;
> +
> +		if (rx_pause)
> +			paacr |= RTL8366RB_PAACR_RX_PAUSE;
> +
> +		/* We are in the link up function so force it up */
> +		paacr |= RTL8366RB_PAACR_LINK_UP;
> +	} else {
> +		/* If link goes down just zero the register including link up */
> +		paacr = 0;
>  	}
>  
> -	/* Enable the CPU port */
> -	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
> -				 0);
> +	ret = regmap_update_bits(priv->map, portreg, portmask, paacr << portshift);
>  	if (ret) {
> -		dev_err(priv->dev, "failed to enable the CPU port\n");
> -		return;
> +		dev_err(priv->dev, "failed to set PAACR on port %d\n", port);
> +		return ret;
>  	}
> +	dev_dbg(priv->dev, "Updated port %d reg %08x, mask %08x, shift %d with value %08x\n",
> +		port, portreg, portmask, portshift, paacr);
> +
> +	return 0;
>  }
>  
>  static void
> -rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
> -			phy_interface_t interface)
> +rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
> +		      phy_interface_t interface, struct phy_device *phydev,
> +		      int speed, int duplex, bool tx_pause, bool rx_pause)
>  {
>  	struct realtek_priv *priv = ds->priv;
>  	int ret;
>  
> -	if (port != priv->cpu_port)
> -		return;
> +	ret = rtl8366rb_config_link(priv, port, true, speed, duplex, tx_pause, rx_pause);
> +	if (ret)
> +		dev_err(priv->dev, "error configuring link on port %d\n", port);
> +}
>  
> -	dev_dbg(priv->dev, "MAC link down on CPU port (%d)\n", port);
> +static void
> +rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
> +			phy_interface_t interface)
> +{
> +	struct realtek_priv *priv = ds->priv;
> +	int ret;
>  
> -	/* Disable the CPU port */
> -	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
> -				 BIT(port));
> -	if (ret) {
> -		dev_err(priv->dev, "failed to disable the CPU port\n");
> -		return;
> -	}
> +	ret = rtl8366rb_config_link(priv, port, false, 0, 0, false, false);
> +	if (ret)
> +		dev_err(priv->dev, "error configuring link on port %d\n", port);
>  }
>  
>  static void rb8366rb_set_port_led(struct realtek_priv *priv,
> @@ -1796,6 +1861,7 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
>  static const struct dsa_switch_ops rtl8366rb_switch_ops_smi = {
>  	.get_tag_protocol = rtl8366_get_tag_protocol,
>  	.setup = rtl8366rb_setup,
> +	.phylink_get_caps = rtl8366rb_link_get_caps,
>  	.phylink_mac_link_up = rtl8366rb_mac_link_up,
>  	.phylink_mac_link_down = rtl8366rb_mac_link_down,
>  	.get_strings = rtl8366_get_strings,
> @@ -1821,6 +1887,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops_mdio = {
>  	.setup = rtl8366rb_setup,
>  	.phy_read = rtl8366rb_dsa_phy_read,
>  	.phy_write = rtl8366rb_dsa_phy_write,
> +	.phylink_get_caps = rtl8366rb_link_get_caps,
>  	.phylink_mac_link_up = rtl8366rb_mac_link_up,
>  	.phylink_mac_link_down = rtl8366rb_mac_link_down,
>  	.get_strings = rtl8366_get_strings,
> -- 
> 2.36.1
> 

