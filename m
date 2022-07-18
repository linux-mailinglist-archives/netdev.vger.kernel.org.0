Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E2F577C23
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 09:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiGRHFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 03:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiGRHFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 03:05:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE97CDFD5
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:05:31 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1oDKog-00044T-6h; Mon, 18 Jul 2022 09:05:18 +0200
Message-ID: <827f51b1-b280-3c99-241c-20af750277ba@pengutronix.de>
Date:   Mon, 18 Jul 2022 09:05:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH V3 2/3] arm64: dts: imx8ulp: Add the fec support
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
 <20220718142257.556248-3-wei.fang@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220718142257.556248-3-wei.fang@nxp.com>
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
> Add the fec support on i.MX8ULP platforms.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> ---
> V2 change:
> Remove the external clocks which is related to specific board.
> V3 change:
> No change.
> ---
>  arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> index 60c1b018bf03..3e8a1e4f0fc2 100644
> --- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> @@ -16,6 +16,7 @@ / {
>  	#size-cells = <2>;
>  
>  	aliases {
> +		ethernet0 = &fec;
>  		gpio0 = &gpiod;
>  		gpio1 = &gpioe;
>  		gpio2 = &gpiof;
> @@ -365,6 +366,16 @@ usdhc2: mmc@298f0000 {
>  				bus-width = <4>;
>  				status = "disabled";
>  			};
> +
> +			fec: ethernet@29950000 {
> +				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec", "fsl,imx6q-fec";
> +				reg = <0x29950000 0x10000>;
> +				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
> +				interrupt-names = "int0";
> +				fsl,num-tx-queues = <1>;
> +				fsl,num-rx-queues = <1>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		gpioe: gpio@2d000080 {


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
