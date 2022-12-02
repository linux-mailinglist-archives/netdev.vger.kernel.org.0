Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EAD63FFFF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiLBFx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiLBFxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:53:25 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40592D585B;
        Thu,  1 Dec 2022 21:53:23 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 125FA24DBCB;
        Fri,  2 Dec 2022 13:53:20 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 13:53:20 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 13:53:18 +0800
Message-ID: <40c1995e-07ea-9c84-e36f-8d179daa5c0b@starfivetech.com>
Date:   Fri, 2 Dec 2022 13:53:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 6/7] riscv: dts: starfive: jh7110: Add ethernet device
 node
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-7-yanhong.wang@starfivetech.com> <Y4joSiz0gKvyuecn@spud>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <Y4joSiz0gKvyuecn@spud>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS063.cuchost.com (172.16.6.23) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/2 1:45, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:02:41PM +0800, Yanhong Wang wrote:
>> Add JH7110 ethernet device node to support gmac driver for the JH7110
>> RISC-V SoC.
>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 80 ++++++++++++++++++++++++
>>  1 file changed, 80 insertions(+)
>> 
>> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> index c22e8f1d2640..97ed5418d91f 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>> @@ -433,5 +433,85 @@
>>  			reg-shift = <2>;
>>  			status = "disabled";
>>  		};
>> +
>> +		stmmac_axi_setup: stmmac-axi-config {
>> +			snps,wr_osr_lmt = <4>;
>> +			snps,rd_osr_lmt = <4>;
>> +			snps,blen = <256 128 64 32 0 0 0>;
>> +		};
>> +
>> +		gmac0: ethernet@16030000 {
>> +			compatible = "starfive,dwmac", "snps,dwmac-5.20";
>> +			reg = <0x0 0x16030000 0x0 0x10000>;
>> +			clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
>> +				 <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
>> +				 <&aoncrg JH7110_AONCLK_GMAC0_TX>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXC>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXCLK>;
>> +			clock-names = "stmmaceth",
>> +					"pclk",
>> +					"ptp_ref",
>> +					"tx",
>> +					"gtxc",
>> +					"gtx";
> 
> Can you sort this into fewer lines please?

Will sort in the next version.

> 
>> +			resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
>> +				 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
>> +			reset-names = "stmmaceth", "ahb";
>> +			interrupts = <7>, <6>, <5> ;
> 
> Please also remove the space before the ;

Will remove the space.

> 
>> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> 
> The answer is probably "the dw driver needs this" but my OCD really
> hates "macirq" vs "eth_wake_irq"..

The definition of  "macirq" and "eth_wake_irq"  is to reuse stmmac_get_platform_resources() API. 

> 
>> +			phy-mode = "rgmii-id";
>> +			snps,multicast-filter-bins = <64>;
>> +			snps,perfect-filter-entries = <8>;
>> +			rx-fifo-depth = <2048>;
>> +			tx-fifo-depth = <2048>;
>> +			snps,fixed-burst;
>> +			snps,no-pbl-x8;
>> +			snps,force_thresh_dma_mode;
>> +			snps,axi-config = <&stmmac_axi_setup>;
>> +			snps,tso;
>> +			snps,en-tx-lpi-clockgating;
>> +			snps,lpi_en;
>> +			snps,txpbl = <16>;
>> +			snps,rxpbl = <16>;
>> +			status = "disabled";
>> +		};
>> +
>> +		gmac1: ethernet@16040000 {
>> +			compatible = "starfive,dwmac", "snps,dwmac-5.20";
>> +			reg = <0x0 0x16040000 0x0 0x10000>;
>> +			clocks = <&syscrg JH7110_SYSCLK_GMAC1_AXI>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC1_AHB>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC1_PTP>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC1_TX>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC1_GTXC>,
>> +				 <&syscrg JH7110_SYSCLK_GMAC1_GTXCLK>;
>> +			clock-names = "stmmaceth",
>> +					"pclk",
>> +					"ptp_ref",
>> +					"tx",
>> +					"gtxc",
>> +					"gtx";
>> +			resets = <&syscrg JH7110_SYSRST_GMAC1_AXI>,
>> +				 <&syscrg JH7110_SYSRST_GMAC1_AHB>;
>> +			reset-names = "stmmaceth", "ahb";
>> +			interrupts = <78>, <77>, <76> ;
> 
> Same comments for this node.

Will remove the space.

> 
>> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
>> +			phy-mode = "rgmii-id";
>> +			snps,multicast-filter-bins = <64>;
>> +			snps,perfect-filter-entries = <8>;
>> +			rx-fifo-depth = <2048>;
>> +			tx-fifo-depth = <2048>;
>> +			snps,fixed-burst;
>> +			snps,no-pbl-x8;
>> +			snps,force_thresh_dma_mode;
>> +			snps,axi-config = <&stmmac_axi_setup>;
>> +			snps,tso;
>> +			snps,en-tx-lpi-clockgating;
>> +			snps,lpi_en;
>> +			snps,txpbl = <16>;
>> +			snps,rxpbl = <16>;
>> +			status = "disabled";
>> +		};
>>  	};
>>  };
>> -- 
>> 2.17.1
>> 
