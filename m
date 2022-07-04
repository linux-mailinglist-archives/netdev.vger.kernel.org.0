Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC19564E45
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbiGDHHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiGDHHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:07:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9573B26FD
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 00:07:40 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1o8GB2-0005bm-4f; Mon, 04 Jul 2022 09:07:24 +0200
Message-ID: <751e1ec6-2d34-44f6-a6c3-775df8a3cea2@pengutronix.de>
Date:   Mon, 4 Jul 2022 09:07:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/3] arm64: dts: imx8ulp: Add the fec support
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     aisheng.dong@nxp.com, devicetree@vger.kernel.org, peng.fan@nxp.com,
        ping.bai@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, sudeep.holla@arm.com, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-3-wei.fang@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220704101056.24821-3-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Wei,

On 04.07.22 12:10, Wei Fang wrote:
> +	clock_ext_rmii: clock-ext-rmii {
> +		compatible = "fixed-clock";
> +		clock-frequency = <50000000>;
> +		#clock-cells = <0>;
> +		clock-output-names = "ext_rmii_clk";
> +	};
> +
> +	clock_ext_ts: clock-ext-ts {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-output-names = "ext_ts_clk";
> +	};

How are these SoC-specific? They sound like they belong
into board DT.

> +				clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
> +					 <&pcc4 IMX8ULP_CLK_ENET>,
> +					 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
> +					 <&clock_ext_rmii>;
> +				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";

I think the default should be the other way round, assume MAC to provide reference
clock and allow override on board-level if PHY does it instead.

Cheers,
Ahmad


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
