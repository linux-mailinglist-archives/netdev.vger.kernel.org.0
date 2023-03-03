Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82A46A98DC
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCCNpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjCCNps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:45:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F193519F;
        Fri,  3 Mar 2023 05:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vCUwgnXLxyg9qDht5YTmjyoMI+qrHGKVL555AkmUbTA=; b=Efwk7DEyDhBlquVRzWAwkICeKt
        VieoX5LuR9BCQ7fYtC9WUXyKAcRA+ZZJED2ALmnZ/95OZ/rnGy8S9ece/GekoeLekctkMicI6HYuw
        TYWH8uKF09RQeQmg9ElKO+91i+vUul/XMrqh/LqcdoqTzuys4oD4MzuwjgM4jhBWUCQQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pY5jE-006OAo-EP; Fri, 03 Mar 2023 14:45:44 +0100
Date:   Fri, 3 Mar 2023 14:45:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samin Guo <samin.guo@starfivetech.com>
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 05/12] riscv: dts: starfive: jh7110: Add ethernet
 device nodes
Message-ID: <ZAH6CGoXBKz0FmW3@lunn.ch>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-6-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303085928.4535-6-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		gmac0: ethernet@16030000 {
> +			compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
> +			reg = <0x0 0x16030000 0x0 0x10000>;
> +			clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
> +				 <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
> +				 <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
> +				 <&aoncrg JH7110_AONCLK_GMAC0_TX_INV>,
> +				 <&syscrg JH7110_SYSCLK_GMAC0_GTXC>;
> +			clock-names = "stmmaceth", "pclk", "ptp_ref",
> +				      "tx", "gtx";
> +			resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
> +				 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
> +			reset-names = "stmmaceth", "ahb";
> +			interrupts = <7>, <6>, <5>;
> +			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +			phy-mode = "rgmii-id";

phy-mode is a board property, not a SoC property. It should be in the
board .dts file, not the SoC .dtsi file.

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
> +			snps,txpbl = <16>;
> +			snps,rxpbl = <16>;
> +			status = "disabled";
> +			phy-handle = <&phy0>;

The PHY is external, so this is also a board property, not a SoC
property. 

> +
> +			mdio {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "snps,dwmac-mdio";
> +
> +				phy0: ethernet-phy@0 {
> +					reg = <0>;
> +				};

The PHY is also a board property. You could for example design a board
where both PHYs are on one MDIO bus, in order to save two SoC pins.

      Andrew
