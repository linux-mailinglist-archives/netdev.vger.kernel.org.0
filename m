Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7941363F6B6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 18:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiLARsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 12:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLARrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 12:47:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F38B955D;
        Thu,  1 Dec 2022 09:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D87D062094;
        Thu,  1 Dec 2022 17:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1559DC433B5;
        Thu,  1 Dec 2022 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669916752;
        bh=diJq5nKrbt92ecplLzYvhikaJNLRnOYzNpmxyjrLq1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJZZ9Cl/vvp5kYzx9XhdC1nEFqIeiWUf6wKNqyOId3y0wIY3M8frb1c6Hynzh9wM4
         0Tj67odSTEFxeyKh/stoMFBJlfxoq7wLFYPDqz5PA9iIGMYiSLfXfjLfjNK4X+Clqp
         2OQL9zx7h9jA4RQViXW+cpfHtyOchkLIw/MCZX+WAdlnWoDiRptnm4Q00N8ZIRR/Nj
         ZOdkU9WRrXsk0p9lqSNvhhXytHk2q04yDz708B+3Dz9ojde+5d9CXSSnR/1LqHH3Kt
         GIN+3saySD/4oFnvf9rvS0LzVC+T6oGwccOFJMdGXRwP6xrLiyxHtkAuLwh2jJ3ADQ
         SMzTEeO0ddbLg==
Date:   Thu, 1 Dec 2022 17:45:46 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 6/7] riscv: dts: starfive: jh7110: Add ethernet device
 node
Message-ID: <Y4joSiz0gKvyuecn@spud>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-7-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201090242.2381-7-yanhong.wang@starfivetech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:02:41PM +0800, Yanhong Wang wrote:
> Add JH7110 ethernet device node to support gmac driver for the JH7110
> RISC-V SoC.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 80 ++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> index c22e8f1d2640..97ed5418d91f 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> @@ -433,5 +433,85 @@
>  			reg-shift = <2>;
>  			status = "disabled";
>  		};
> +
> +		stmmac_axi_setup: stmmac-axi-config {
> +			snps,wr_osr_lmt = <4>;
> +			snps,rd_osr_lmt = <4>;
> +			snps,blen = <256 128 64 32 0 0 0>;
> +		};
> +
> +		gmac0: ethernet@16030000 {
> +			compatible = "starfive,dwmac", "snps,dwmac-5.20";
> +			reg = <0x0 0x16030000 0x0 0x10000>;
> +			clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
> +				 <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
> +				 <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
> +				 <&aoncrg JH7110_AONCLK_GMAC0_TX>,
> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXC>,
> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXCLK>;
> +			clock-names = "stmmaceth",
> +					"pclk",
> +					"ptp_ref",
> +					"tx",
> +					"gtxc",
> +					"gtx";

Can you sort this into fewer lines please?

> +			resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
> +				 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
> +			reset-names = "stmmaceth", "ahb";
> +			interrupts = <7>, <6>, <5> ;

Please also remove the space before the ;

> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";

The answer is probably "the dw driver needs this" but my OCD really
hates "macirq" vs "eth_wake_irq"..

> +			phy-mode = "rgmii-id";
> +			snps,multicast-filter-bins = <64>;
> +			snps,perfect-filter-entries = <8>;
> +			rx-fifo-depth = <2048>;
> +			tx-fifo-depth = <2048>;
> +			snps,fixed-burst;
> +			snps,no-pbl-x8;
> +			snps,force_thresh_dma_mode;
> +			snps,axi-config = <&stmmac_axi_setup>;
> +			snps,tso;
> +			snps,en-tx-lpi-clockgating;
> +			snps,lpi_en;
> +			snps,txpbl = <16>;
> +			snps,rxpbl = <16>;
> +			status = "disabled";
> +		};
> +
> +		gmac1: ethernet@16040000 {
> +			compatible = "starfive,dwmac", "snps,dwmac-5.20";
> +			reg = <0x0 0x16040000 0x0 0x10000>;
> +			clocks = <&syscrg JH7110_SYSCLK_GMAC1_AXI>,
> +				 <&syscrg JH7110_SYSCLK_GMAC1_AHB>,
> +				 <&syscrg JH7110_SYSCLK_GMAC1_PTP>,
> +				 <&syscrg JH7110_SYSCLK_GMAC1_TX>,
> +				 <&syscrg JH7110_SYSCLK_GMAC1_GTXC>,
> +				 <&syscrg JH7110_SYSCLK_GMAC1_GTXCLK>;
> +			clock-names = "stmmaceth",
> +					"pclk",
> +					"ptp_ref",
> +					"tx",
> +					"gtxc",
> +					"gtx";
> +			resets = <&syscrg JH7110_SYSRST_GMAC1_AXI>,
> +				 <&syscrg JH7110_SYSRST_GMAC1_AHB>;
> +			reset-names = "stmmaceth", "ahb";
> +			interrupts = <78>, <77>, <76> ;

Same comments for this node.

> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +			phy-mode = "rgmii-id";
> +			snps,multicast-filter-bins = <64>;
> +			snps,perfect-filter-entries = <8>;
> +			rx-fifo-depth = <2048>;
> +			tx-fifo-depth = <2048>;
> +			snps,fixed-burst;
> +			snps,no-pbl-x8;
> +			snps,force_thresh_dma_mode;
> +			snps,axi-config = <&stmmac_axi_setup>;
> +			snps,tso;
> +			snps,en-tx-lpi-clockgating;
> +			snps,lpi_en;
> +			snps,txpbl = <16>;
> +			snps,rxpbl = <16>;
> +			status = "disabled";
> +		};
>  	};
>  };
> -- 
> 2.17.1
> 
