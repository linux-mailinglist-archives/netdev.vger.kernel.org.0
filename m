Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56222553170
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350199AbiFUL4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348633AbiFUL4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:56:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B4711460;
        Tue, 21 Jun 2022 04:56:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id kq6so26901743ejb.11;
        Tue, 21 Jun 2022 04:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gnl0wJDcbGyeG2Jzp9z8ykP0NivEyMSr5iKIZo5tXBk=;
        b=o7UBtpV1wF5UpMl03Q8Vi7f1/Gbekb5LSvxLJ0iQtBmQQpSbhSCgtxKLWHf6+bL+tq
         oGUJowxIKNN4DXzVzYee4SzLh7smMShK7Cdr0rsxRYg3EljpSlNFeCuBS6xzqSSZM6gv
         9hrIw2CNg4JxwjW2cAdpOn29sqDNmJ9qHC6zViXmFuOxA7pWdTf9LBEXuHyQE6MwO9BO
         Rx+ruavybv2yTcgPYqqBv7kiU/0egsKBI9rNxXwACQhVyADDnMcumcIWDPYXPgbuL4uJ
         x6LyN4x2jeFGWQB1+5iiTNyWZoSIswCxvg338E4Y3004/Wuef6O7RTqTrgQap7VJWQZY
         WUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gnl0wJDcbGyeG2Jzp9z8ykP0NivEyMSr5iKIZo5tXBk=;
        b=eDulhQSvVJznuWvcYlIjf1eFTbaURj/pMfWtP/vIy9oTBNB9PTQhONTIWsOr4X+pey
         VErdZmlvDlWFLefKFgFK9Zlw0YgGwYBoUXP+BX4JbDYOFd2ibXQbA+PXDQ+q36RPm+RW
         B8MskT9FMn63Gtao2bK0y0AOLwvuu104q48syCvW0c2Y2EX8z3Pnevc/eJeZl0xiSv4F
         qNuG72wNkSnOq6SOPddHyeKMYdLXQhlc56L0obs8HvHiS6P85IvKRcAJGPOtEPnWALQJ
         jK3DpWXOBRGfPYRvaO1W8r6epcjDRJAFHi1OjynW13WvdZ6vVed9gSOls2kS8LvhgFmB
         6/Kw==
X-Gm-Message-State: AJIora8LW4dW64h2912mg66RN9WTSgTk5q9H2Ss6/Weva2GFFJ0S5T9s
        gtQjbZUjXWGcYoiClfM75IY=
X-Google-Smtp-Source: AGRyM1vuZsNu3hanNf6cHV6qvU0DNqRqDR1yRqb3ASlaAkoAaM2oy0VZ68quEjqMht+YzCPnbe/TEw==
X-Received: by 2002:a17:907:7b8d:b0:722:def3:915f with SMTP id ne13-20020a1709077b8d00b00722def3915fmr4308432ejc.728.1655812566187;
        Tue, 21 Jun 2022 04:56:06 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b006f4cb79d9a8sm7519895ejc.75.2022.06.21.04.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:56:05 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:56:03 +0300
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
Subject: Re: [PATCH net-next v8 15/16] ARM: dts: r9a06g032-rzn1d400-db: add
 switch description
Message-ID: <20220621115603.yzcxcu7gzwng6bcg@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
 <20220620110846.374787-16-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-16-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:08:45PM +0200, Clément Léger wrote:
> Add description for the switch, GMAC2 and MII converter. With these
> definitions, the switch port 0 and 1 (MII port 5 and 4) are working on
> RZ/N1D-DB board.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Just minor comments below:

>  arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts | 117 ++++++++++++++++++++
>  1 file changed, 117 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> index 3f8f3ce87e12..36b898d9f115 100644
> --- a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> +++ b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> @@ -8,6 +8,8 @@
>  
>  /dts-v1/;
>  
> +#include <dt-bindings/pinctrl/rzn1-pinctrl.h>
> +#include <dt-bindings/net/pcs-rzn1-miic.h>
>  #include "r9a06g032.dtsi"
>  
>  / {
> @@ -31,3 +33,118 @@ &wdt0 {
>  	timeout-sec = <60>;
>  	status = "okay";
>  };
> +
> +&gmac2 {
> +	status = "okay";
> +	phy-mode = "gmii";
> +	fixed-link {
> +		speed = <1000>;
> +		full-duplex;
> +	};
> +};
> +
> +&switch {
> +	status = "okay";
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
> +
> +	dsa,member = <0 0>;

This doesn't really have any value for single-switch DSA trees, since
that is the implicit tree id/switch id, but it doesn't hurt, either.

> +
> +	mdio {
> +		clock-frequency = <2500000>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		switch0phy4: ethernet-phy@4{

Space between ethernet-phy@4 and {.

> +			reg = <4>;
> +			micrel,led-mode = <1>;
> +		};
> +
> +		switch0phy5: ethernet-phy@5{

Same thing here.

> +			reg = <5>;
> +			micrel,led-mode = <1>;
> +		};
> +	};
> +};
> +
> +&switch_port0 {
> +	label = "lan0";
> +	phy-mode = "mii";
> +	phy-handle = <&switch0phy5>;
> +	status = "okay";
> +};
> +
> +&switch_port1 {
> +	label = "lan1";
> +	phy-mode = "mii";
> +	phy-handle = <&switch0phy4>;
> +	status = "okay";
> +};
> +
> +&switch_port4 {
> +	status = "okay";
> +};
> +
> +&eth_miic {
> +	status = "okay";
> +	renesas,miic-switch-portin = <MIIC_GMAC2_PORT>;
> +};
> +
> +&mii_conv4 {
> +	renesas,miic-input = <MIIC_SWITCH_PORTB>;
> +	status = "okay";
> +};
> +
> +&mii_conv5 {
> +	renesas,miic-input = <MIIC_SWITCH_PORTA>;
> +	status = "okay";
> +};
> +
> +&pinctrl{
> +	pins_mdio1: pins_mdio1 {
> +		pinmux = <
> +			RZN1_PINMUX(152, RZN1_FUNC_MDIO1_SWITCH)
> +			RZN1_PINMUX(153, RZN1_FUNC_MDIO1_SWITCH)
> +		>;
> +	};
> +	pins_eth3: pins_eth3 {
> +		pinmux = <
> +			RZN1_PINMUX(36, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(37, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(38, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(39, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(40, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(41, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(42, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(43, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(44, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(45, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(46, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(47, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +		>;
> +		drive-strength = <6>;
> +		bias-disable;
> +	};
> +	pins_eth4: pins_eth4 {
> +		pinmux = <
> +			RZN1_PINMUX(48, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(49, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(50, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(51, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(52, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(53, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(54, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(55, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(56, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(57, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(58, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +			RZN1_PINMUX(59, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
> +		>;
> +		drive-strength = <6>;
> +		bias-disable;
> +	};
> +};
> -- 
> 2.36.1
> 

