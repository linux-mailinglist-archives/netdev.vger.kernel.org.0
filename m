Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E89553143
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbiFULoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349554AbiFULoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:44:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D92019C1F;
        Tue, 21 Jun 2022 04:44:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id o9so9734015edt.12;
        Tue, 21 Jun 2022 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b4SZYE3Hi8RUeUlm3jAB1Med63tggD/V2wg3L6fvsJs=;
        b=q3nkNg4eBftqV+Ct404C78m0pZ/KIZTV+GVwzh4+wzFIgABa3x4U6OX+xfz7KY9eOt
         AjvaXCNNGXU1jZERKZQoBoTRNh/5HPWFNFzv57fjcnx0C9Wcykz0lTzVlSOL4fNpvKwf
         uzC8XKkYZXnLj0PzoSJpDF11DLxwXAqJ9m7dIZzrBdotXfjjOUC2XmjJTjTLXvyXWT+F
         2VgH6ziiIfuVJZS3pSzxr9nm+kEnkxpxTwL26bHeARJrjiJM7Gx03wtpLBh44yIK1X1m
         0NbBnLJmxrDfisnlfpWat0ktoxD014DptDQo8g5DF0nTfpE1sZOwNzvbJyiVFBLIdqDK
         7LAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b4SZYE3Hi8RUeUlm3jAB1Med63tggD/V2wg3L6fvsJs=;
        b=N9TjO+ozjbQALlUdMykW4s2jtjwgb986yZrSUPRwZ5FWdbM5xrPBd6vOt+ARIEdn8c
         VJhVqOBZUzrepkbThiWkQtUO+waqpiavMUogmDzVLX8HNbYC8kmFp+5vZBy4p2e9xpW9
         Cshr2m/nmWU4HnVwkUh3pFGlNE16utCelgeirfECCE8kYSf3Uz9yNb8RLOV5Mp2KYa7X
         DptKN+ia6GdcXmYH9tpfvFRrMRRC8bx91lTC3AquwW4xTh+GAiVz0Bp6MPfWmG00SrvU
         adv5cL7+j1/BHZIz9ONhWWmYjSupb98LGlWaXhrcwdk7uCrWlXjIB2iSk+OcpBv8Vuo+
         R1Gw==
X-Gm-Message-State: AJIora8HGKalG95S65CHjJIiDhthKAvaV+byzXjX8ZGy6nVKXX3RfF+E
        hTj8a+sjMDH/1rAQUHkZE3I=
X-Google-Smtp-Source: AGRyM1sUX/XLpqVZR6VUFxp0XfHBRL/XL/+Di1HzIvqErmiguGsaJpAlJT243DZzxOiA3FsSBCpufg==
X-Received: by 2002:aa7:d94a:0:b0:435:75bf:48a0 with SMTP id l10-20020aa7d94a000000b0043575bf48a0mr16764056eds.187.1655811857674;
        Tue, 21 Jun 2022 04:44:17 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id sz23-20020a1709078b1700b00722e660f16fsm608262ejc.23.2022.06.21.04.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:44:17 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:44:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 05/16] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220621114415.zj37zmgkwkon6u7e@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
 <20220620110846.374787-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-6-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:08:35PM +0200, Clément Léger wrote:
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Pretty cool driver. I understand this to be more or less the same thing
as drivers/net/phy/xilinx_gmii2rgmii.c in principle, but this appears
nicer done and I'm glad you didn't follow the same model (the
phylink_pcs seems to be a much better fit than a chained PHY).
If PHY library maintainers don't have any objections you can add my:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +static void miic_reg_rmw(struct miic *miic, int offset, u32 mask, u32 val)
> +{
> +	u32 reg;
> +
> +	spin_lock(&miic->lock);
> +
> +	reg = miic_reg_readl(miic, offset);
> +	reg &= ~mask;
> +	reg |= val;
> +	miic_reg_writel(miic, offset, reg);
> +
> +	spin_unlock(&miic->lock);
> +}

Just a small comment: I don't think pcs_config and pcs_link_up need
serialization with respect to each other, so this read-modify-write
spinlock doesn't do much. But it doesn't really hurt either.

> +
> +static void miic_converter_enable(struct miic *miic, int port, int enable)
> +{
> +	u32 val = 0;
> +
> +	if (enable)
> +		val = MIIC_CONVRST_PHYIF_RST(port);
> +
> +	miic_reg_rmw(miic, MIIC_CONVRST, MIIC_CONVRST_PHYIF_RST(port), val);
> +}
> +
> +static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
> +		       phy_interface_t interface,
> +		       const unsigned long *advertising, bool permit)
> +{
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +	int port = miic_port->port;
> +	u32 speed, conv_mode, val;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		conv_mode = CONV_MODE_RMII;
> +		speed = CONV_MODE_100MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		conv_mode = CONV_MODE_RGMII;
> +		speed = CONV_MODE_1000MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		conv_mode = CONV_MODE_MII;
> +		/* When in MII mode, speed should be set to 0 (which is actually
> +		 * CONV_MODE_10MBPS)
> +		 */
> +		speed = CONV_MODE_10MBPS;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	val = FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode) |
> +	      FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
> +
> +	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
> +		     MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_CONV_SPEED, val);
> +	miic_converter_enable(miic_port->miic, miic_port->port, 1);
> +
> +	return 0;
> +}
> +
> +static void miic_link_up(struct phylink_pcs *pcs, unsigned int mode,
> +			 phy_interface_t interface, int speed, int duplex)
> +{
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +	u32 conv_speed = 0, val = 0;
> +	int port = miic_port->port;
> +
> +	if (duplex == DUPLEX_FULL)
> +		val |= MIIC_CONVCTRL_FULLD;
> +
> +	/* No speed in MII through-mode */
> +	if (interface != PHY_INTERFACE_MODE_MII) {
> +		switch (speed) {
> +		case SPEED_1000:
> +			conv_speed = CONV_MODE_1000MBPS;
> +			break;
> +		case SPEED_100:
> +			conv_speed = CONV_MODE_100MBPS;
> +			break;
> +		case SPEED_10:
> +			conv_speed = CONV_MODE_10MBPS;
> +			break;
> +		default:
> +			return;
> +		}
> +	}
> +
> +	val |= FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, conv_speed);
> +
> +	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
> +		     (MIIC_CONVCTRL_CONV_SPEED | MIIC_CONVCTRL_FULLD), val);
> +}
