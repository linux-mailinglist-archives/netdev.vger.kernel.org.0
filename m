Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B294493247
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350651AbiASBYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:24:35 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:45082 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1343527AbiASBYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:24:34 -0500
X-UUID: 99360b13b4844085a0d83d85c2b0a391-20220119
X-UUID: 99360b13b4844085a0d83d85c2b0a391-20220119
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 537623481; Wed, 19 Jan 2022 09:24:30 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 19 Jan 2022 09:24:29 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Jan 2022 09:24:28 +0800
Message-ID: <6d9edd18e64a973265b92d98395f8ce7470e59e6.camel@mediatek.com>
Subject: Re: [PATCH net-next v12 4/7] arm64: dts: mt2712: update ethernet
 device node
From:   Biao Huang <biao.huang@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <angelogioacchino.delregno@collabora.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Date:   Wed, 19 Jan 2022 09:24:28 +0800
In-Reply-To: <20220117070706.17853-5-biao.huang@mediatek.com>
References: <20220117070706.17853-1-biao.huang@mediatek.com>
         <20220117070706.17853-5-biao.huang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Matthias,

	Any comments about this dts patch?
	Thanks in advance.

Regards!
Biao

On Mon, 2022-01-17 at 15:07 +0800, Biao Huang wrote:
> Since there are some changes in ethernet driver:
> update ethernet device node in dts to accommodate to it.
> 
> 1. stmmac_probe_config_dt() in stmmac_platform.c will initialize
> specified
>    parameters according to compatible string "snps,dwmac-4.20a",
> then,
>    dwmac-mediatek.c can skip the initialization if add compatible
> string
>    "snps,dwmac-4.20a" in eth device node.
> 2. commit 882007ed7832 ("net-next: dt-binding: dwmac-mediatek: add
> more
>    description for RMII") added rmii internal support, we should add
>    corresponding clocks/clocks-names in eth device node.
> 3. add "snps,reset-delays-us = <0 10000 10000>;" to ensure reset
> delay
>    can meet PHY requirement.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  arch/arm64/boot/dts/mediatek/mt2712-evb.dts |  1 +
>  arch/arm64/boot/dts/mediatek/mt2712e.dtsi   | 14 +++++++++-----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> index 7d369fdd3117..11aa135aa0f3 100644
> --- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> @@ -110,6 +110,7 @@ &eth {
>  	phy-handle = <&ethernet_phy0>;
>  	mediatek,tx-delay-ps = <1530>;
>  	snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
> +	snps,reset-delays-us = <0 10000 10000>;
>  	pinctrl-names = "default", "sleep";
>  	pinctrl-0 = <&eth_default>;
>  	pinctrl-1 = <&eth_sleep>;
> diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> index a9cca9c146fd..9e850e04fffb 100644
> --- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> @@ -726,7 +726,7 @@ queue2 {
>  	};
>  
>  	eth: ethernet@1101c000 {
> -		compatible = "mediatek,mt2712-gmac";
> +		compatible = "mediatek,mt2712-gmac", "snps,dwmac-
> 4.20a";
>  		reg = <0 0x1101c000 0 0x1300>;
>  		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
>  		interrupt-names = "macirq";
> @@ -734,15 +734,19 @@ eth: ethernet@1101c000 {
>  		clock-names = "axi",
>  			      "apb",
>  			      "mac_main",
> -			      "ptp_ref";
> +			      "ptp_ref",
> +			      "rmii_internal";
>  		clocks = <&pericfg CLK_PERI_GMAC>,
>  			 <&pericfg CLK_PERI_GMAC_PCLK>,
>  			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -			 <&topckgen CLK_TOP_ETHER_50M_SEL>;
> +			 <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +			 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
>  		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -				  <&topckgen CLK_TOP_ETHER_50M_SEL>;
> +				  <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +				  <&topckgen
> CLK_TOP_ETHER_50M_RMII_SEL>;
>  		assigned-clock-parents = <&topckgen
> CLK_TOP_ETHERPLL_125M>,
> -					 <&topckgen CLK_TOP_APLL1_D3>;
> +					 <&topckgen CLK_TOP_APLL1_D3>,
> +					 <&topckgen
> CLK_TOP_ETHERPLL_50M>;
>  		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
>  		mediatek,pericfg = <&pericfg>;
>  		snps,axi-config = <&stmmac_axi_setup>;

