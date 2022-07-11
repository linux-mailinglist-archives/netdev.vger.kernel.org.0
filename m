Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57756D518
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 09:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiGKHCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 03:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKHCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 03:02:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB8140C2;
        Mon, 11 Jul 2022 00:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e5DygZRkVsdgAVoVvUkLTk0a4j5tMEqZ72vV1XOoua4=; b=utA/8RhRmV4mRCGCKW1HNDroUa
        u+TNvmexxd+4YbsUz4aSv0LNfg0B/Fpc0V7Vp3OnKoqEV+qZb/Yr1ujFl/mmmNFBD66gWXCBEPCyQ
        QwkE9TVlZb1DjwZpqetPFEATyPP0U+uiG9tVhryUiV9KzO4gAqKlnh6Ox3eqJ+c5HTWk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oAnQt-009vSy-PO; Mon, 11 Jul 2022 09:02:15 +0200
Date:   Mon, 11 Jul 2022 09:02:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        peng.fan@nxp.com, ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V2 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Message-ID: <YsvK99Gb0JL3YbQB@lunn.ch>
References: <20220711094434.369377-1-wei.fang@nxp.com>
 <20220711094434.369377-4-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711094434.369377-4-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 07:44:34PM +1000, Wei Fang wrote:
> Enable the fec on i.MX8ULP EVK board.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> Add clock_ext_rmii and clock_ext_ts. They are both related to EVK board.
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

Do you need any PHY properties to turn this clock on? Or is it
strapped to be always on?

I'm surprised it is limited to Fast Ethernet. I know the Vybrid and
some of the older SoCs are Fast Ethernet only, but i thought all the
newer supported 1G?

	 Andrew

