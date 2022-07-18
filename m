Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C80577C1D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 09:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiGRHFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 03:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiGRHFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 03:05:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695ECDFD5
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:05:12 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1oDKoD-0003yH-CX; Mon, 18 Jul 2022 09:04:49 +0200
Message-ID: <b5f5f87e-c690-2525-4b5f-4d178157a4d3@pengutronix.de>
Date:   Mon, 18 Jul 2022 09:04:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH V3 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Content-Language: en-US
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     aisheng.dong@nxp.com, devicetree@vger.kernel.org, peng.fan@nxp.com,
        ping.bai@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, sudeep.holla@arm.com, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
References: <20220718142257.556248-1-wei.fang@nxp.com>
 <20220718142257.556248-4-wei.fang@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220718142257.556248-4-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.07.22 16:22, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Enable the fec on i.MX8ULP EVK board.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> Add clock_ext_rmii and clock_ext_ts. They are both related to EVK board.
> V3 change:
> No change.
> ---
>  arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
> index 33e84c4e9ed8..ebce716b10e6 100644
> --- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
> @@ -19,6 +19,21 @@ memory@80000000 {
>  		device_type = "memory";
>  		reg = <0x0 0x80000000 0 0x80000000>;
>  	};
> +
> +	clock_ext_rmii: clock-ext-rmii {
> +		compatible = "fixed-clock";
> +		clock-frequency = <50000000>;
> +		clock-output-names = "ext_rmii_clk";
> +		#clock-cells = <0>;
> +	};
> +
> +	clock_ext_ts: clock-ext-ts {
> +		compatible = "fixed-clock";
> +		/* External ts clock is 50MHZ from PHY on EVK board. */
> +		clock-frequency = <50000000>;
> +		clock-output-names = "ext_ts_clk";
> +		#clock-cells = <0>;
> +	};
>  };
>  
>  &lpuart5 {
> @@ -38,7 +53,49 @@ &usdhc0 {
>  	status = "okay";
>  };
>  
> +&fec {
> +	pinctrl-names = "default", "sleep";
> +	pinctrl-0 = <&pinctrl_enet>;
> +	pinctrl-1 = <&pinctrl_enet>;
> +	clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
> +		 <&pcc4 IMX8ULP_CLK_ENET>,
> +		 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
> +		 <&clock_ext_rmii>;
> +	clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
> +	assigned-clocks = <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
> +	assigned-clock-parents = <&clock_ext_ts>;
> +	phy-mode = "rmii";
> +	phy-handle = <&ethphy>;
> +	status = "okay";
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ethphy: ethernet-phy {

@1

> +			reg = <1>;
> +			micrel,led-mode = <1>;
> +		};
> +	};
> +};
> +
>  &iomuxc1 {
> +	pinctrl_enet: enetgrp {
> +		fsl,pins = <
> +			MX8ULP_PAD_PTE15__ENET0_MDC     0x43
> +			MX8ULP_PAD_PTE14__ENET0_MDIO    0x43
> +			MX8ULP_PAD_PTE17__ENET0_RXER    0x43
> +			MX8ULP_PAD_PTE18__ENET0_CRS_DV  0x43
> +			MX8ULP_PAD_PTF1__ENET0_RXD0     0x43
> +			MX8ULP_PAD_PTE20__ENET0_RXD1    0x43
> +			MX8ULP_PAD_PTE16__ENET0_TXEN    0x43
> +			MX8ULP_PAD_PTE23__ENET0_TXD0    0x43
> +			MX8ULP_PAD_PTE22__ENET0_TXD1    0x43
> +			MX8ULP_PAD_PTE19__ENET0_REFCLK  0x43
> +			MX8ULP_PAD_PTF10__ENET0_1588_CLKIN 0x43
> +		>;
> +	};
> +
>  	pinctrl_lpuart5: lpuart5grp {
>  		fsl,pins = <
>  			MX8ULP_PAD_PTF14__LPUART5_TX	0x3


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
