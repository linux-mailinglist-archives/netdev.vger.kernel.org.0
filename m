Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3546658B7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 11:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbjAKKNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 05:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbjAKKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 05:12:24 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285EC2607;
        Wed, 11 Jan 2023 02:11:36 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pFY4r-0004GV-N7; Wed, 11 Jan 2023 11:11:25 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Anand Moon <anand@edgeble.ai>
Cc:     Johan Jonker <jbx6244@gmail.com>, Anand Moon <anand@edgeble.ai>,
        Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv4 linux-next 3/4] Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
Date:   Wed, 11 Jan 2023 11:11:24 +0100
Message-ID: <7148963.18pcnM708K@diego>
In-Reply-To: <20230111064842.5322-3-anand@edgeble.ai>
References: <20230111064842.5322-1-anand@edgeble.ai> <20230111064842.5322-3-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Mittwoch, 11. Januar 2023, 07:48:38 CET schrieb Anand Moon:
> Add Ethernet GMAC node for RV1126 SoC.
> 
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>

patches 2-4 have this Signed-off-by from Jagan again where he is not
not the author but also not the sender.

Also this patch here, needs a fixed subject with the correct prefixes.


Heiko

> ---
> v4: sort the node as reg adds. update the commit message.
> v3: drop the gmac_clkin_m0 & gmac_clkin_m1 fix clock node which are not
>     used, Add SoB of Jagan Teki.
> v2: drop SoB of Jagan Teki.
> ---
>  arch/arm/boot/dts/rv1126.dtsi | 49 +++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
> index 1cb43147e90b..1f07d0a4fa73 100644
> --- a/arch/arm/boot/dts/rv1126.dtsi
> +++ b/arch/arm/boot/dts/rv1126.dtsi
> @@ -332,6 +332,55 @@ timer0: timer@ff660000 {
>  		clock-names = "pclk", "timer";
>  	};
>  
> +	gmac: ethernet@ffc40000 {
> +		compatible = "rockchip,rv1126-gmac", "snps,dwmac-4.20a";
> +		reg = <0xffc40000 0x4000>;
> +		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "macirq", "eth_wake_irq";
> +		rockchip,grf = <&grf>;
> +		clocks = <&cru CLK_GMAC_SRC>, <&cru CLK_GMAC_TX_RX>,
> +			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_REF>,
> +			 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>,
> +			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_PTPREF>;
> +		clock-names = "stmmaceth", "mac_clk_rx",
> +			      "mac_clk_tx", "clk_mac_ref",
> +			      "aclk_mac", "pclk_mac",
> +			      "clk_mac_speed", "ptp_ref";
> +		resets = <&cru SRST_GMAC_A>;
> +		reset-names = "stmmaceth";
> +
> +		snps,mixed-burst;
> +		snps,tso;
> +
> +		snps,axi-config = <&stmmac_axi_setup>;
> +		snps,mtl-rx-config = <&mtl_rx_setup>;
> +		snps,mtl-tx-config = <&mtl_tx_setup>;
> +		status = "disabled";
> +
> +		mdio: mdio {
> +			compatible = "snps,dwmac-mdio";
> +			#address-cells = <0x1>;
> +			#size-cells = <0x0>;
> +		};
> +
> +		stmmac_axi_setup: stmmac-axi-config {
> +			snps,wr_osr_lmt = <4>;
> +			snps,rd_osr_lmt = <8>;
> +			snps,blen = <0 0 0 0 16 8 4>;
> +		};
> +
> +		mtl_rx_setup: rx-queues-config {
> +			snps,rx-queues-to-use = <1>;
> +			queue0 {};
> +		};
> +
> +		mtl_tx_setup: tx-queues-config {
> +			snps,tx-queues-to-use = <1>;
> +			queue0 {};
> +		};
> +	};
> +
>  	emmc: mmc@ffc50000 {
>  		compatible = "rockchip,rv1126-dw-mshc", "rockchip,rk3288-dw-mshc";
>  		reg = <0xffc50000 0x4000>;
> 




