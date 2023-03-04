Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362A86AAD0B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 23:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCDW5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 17:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCDW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 17:57:41 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61B4DBC0
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 14:57:37 -0800 (PST)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3595441304
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 22:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677970656;
        bh=Vju82LMq7Hb3dulxwnm87osrgbRmnYPvBM1vXLn4dUA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=eVuXfteV4OyfoBeHCOKLBLDrTUF2AN4RIQ5VxgHsDYFtbUUswzwmUqj1MBx6ZwlFZ
         geielPHAU7QBpSgAE4Z7UaG5Qp0kaQoM46PY1GAeNg9fpXTiAJWUyF7gMZG5uSlmc3
         ry5G4pe9DRTd6F4A08fo+Cq7i98rMj7+Hl5keO3b4bkxKlQxlJUsogWIsFOf7Ci+1f
         ptkYyy+OW+M14Z4zrsmKX6IkmibnmijAqbHnLSAAcrIOGEjEj81WsRqeMvut59hTj6
         OWwDqf9qJDPIW0g0bISKeZAUzscm0OVnPQUJ1jbo1iCWyFChDFLimDT87slvaxq8TN
         lZatfuLgALM8Q==
Received: by mail-qt1-f200.google.com with SMTP id z1-20020ac87ca1000000b003ba2a2c50f9so3385074qtv.23
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 14:57:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677970654;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vju82LMq7Hb3dulxwnm87osrgbRmnYPvBM1vXLn4dUA=;
        b=48p9BQ6r1NSNcBzEl863svN4jGxVTVUE02lyItBswqRjLxG8F83SzcoS4PwOgtCezf
         XVcEZBI/X+IYGcslzVFWiONcOZP2x087mcB6kIyIOOrkuLn+4oMWbrf3jFRRuXQ3KV1P
         BJAVAocoH0M86nLBPqHFJrVf9P0+1il8Rwvk9BciAwAj2h0DDr3x0xtgerqwnUSOvDfe
         hnCrnwYsORo8h/gHsCd54MHmruR4cZKdKIBoX5UBZfp0LhO2eLq4NLCrOc0LQabwyCJJ
         f6OH871ZddukuUbD7WgdiRMVglk094Nu/iBD+S6RW8STD4xQ2zCgMzlYUB6QtxZoRNXX
         TPSg==
X-Gm-Message-State: AO0yUKVLi4jRNi+NkhRy6sTXAIE/X9mBny+OYmS2O261EW1uITaNs3jN
        elOxdYwZ216MRT5k2nh45g9QtfF3wkcUSGxf1k4HljXlkj7oPJc5GdwZ/ovi9dCcYCBcBP0fIcv
        SImkIRyqvnGFKNeUIcq1epVjrKIpjKO/hCtHruX+Dq0mqtClu/Q==
X-Received: by 2002:a05:6214:933:b0:571:1409:5ee1 with SMTP id dk19-20020a056214093300b0057114095ee1mr1789519qvb.0.1677970654695;
        Sat, 04 Mar 2023 14:57:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9OCpr8hRBc/QazhmBC/md4LdexEqTNSjYLrirDk7uhU3nwpz+1l8MCPf/QOPXZH2D1Js8bjRxfqR+PGxy3+lk=
X-Received: by 2002:a05:6214:933:b0:571:1409:5ee1 with SMTP id
 dk19-20020a056214093300b0057114095ee1mr1789506qvb.0.1677970654498; Sat, 04
 Mar 2023 14:57:34 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com> <20230303085928.4535-6-samin.guo@starfivetech.com>
In-Reply-To: <20230303085928.4535-6-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Sat, 4 Mar 2023 23:57:18 +0100
Message-ID: <CAJM55Z_SV3ig56JY9BF5LeWt4M+bKYh_HdxSY02CP+9i7F0vCQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/12] riscv: dts: starfive: jh7110: Add ethernet
 device nodes
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
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>
> Add JH7110 ethernet device node to support gmac driver for the JH7110
> RISC-V SoC.
>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 91 ++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
>
> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> index 09806418ed1b..2ce28292b721 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> @@ -233,6 +233,13 @@
>                 #clock-cells = <0>;
>         };
>
> +       stmmac_axi_setup: stmmac-axi-config {
> +               snps,lpi_en;
> +               snps,wr_osr_lmt = <4>;
> +               snps,rd_osr_lmt = <4>;
> +               snps,blen = <256 128 64 32 0 0 0>;
> +       };
> +
>         tdm_ext: tdm-ext-clock {
>                 compatible = "fixed-clock";
>                 clock-output-names = "tdm_ext";
> @@ -518,5 +525,89 @@
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                 };
> +
> +               gmac0: ethernet@16030000 {
> +                       compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
> +                       reg = <0x0 0x16030000 0x0 0x10000>;
> +                       clocks = <&aoncrg JH7110_AONCLK_GMAC0_AXI>,
> +                                <&aoncrg JH7110_AONCLK_GMAC0_AHB>,
> +                                <&syscrg JH7110_SYSCLK_GMAC0_PTP>,
> +                                <&aoncrg JH7110_AONCLK_GMAC0_TX_INV>,
> +                                <&syscrg JH7110_SYSCLK_GMAC0_GTXC>;
> +                       clock-names = "stmmaceth", "pclk", "ptp_ref",
> +                                     "tx", "gtx";
> +                       resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
> +                                <&aoncrg JH7110_AONRST_GMAC0_AHB>;
> +                       reset-names = "stmmaceth", "ahb";
> +                       interrupts = <7>, <6>, <5>;
> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +                       phy-mode = "rgmii-id";
> +                       snps,multicast-filter-bins = <64>;
> +                       snps,perfect-filter-entries = <8>;
> +                       rx-fifo-depth = <2048>;
> +                       tx-fifo-depth = <2048>;
> +                       snps,fixed-burst;
> +                       snps,no-pbl-x8;
> +                       snps,force_thresh_dma_mode;
> +                       snps,axi-config = <&stmmac_axi_setup>;
> +                       snps,tso;
> +                       snps,en-tx-lpi-clockgating;
> +                       snps,txpbl = <16>;
> +                       snps,rxpbl = <16>;
> +                       status = "disabled";
> +                       phy-handle = <&phy0>;
> +
> +                       mdio {
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               compatible = "snps,dwmac-mdio";
> +
> +                               phy0: ethernet-phy@0 {
> +                                       reg = <0>;
> +                               };
> +                       };
> +               };
> +
> +               gmac1: ethernet@16040000 {
> +                       compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
> +                       reg = <0x0 0x16040000 0x0 0x10000>;
> +                       clocks = <&syscrg JH7110_SYSCLK_GMAC1_AXI>,
> +                                <&syscrg JH7110_SYSCLK_GMAC1_AHB>,
> +                                <&syscrg JH7110_SYSCLK_GMAC1_PTP>,
> +                                <&syscrg JH7110_SYSCLK_GMAC1_TX_INV>,
> +                                <&syscrg JH7110_SYSCLK_GMAC1_GTXC>;
> +                       clock-names = "stmmaceth", "pclk", "ptp_ref",
> +                                     "tx", "gtx";
> +                       resets = <&syscrg JH7110_SYSRST_GMAC1_AXI>,
> +                                <&syscrg JH7110_SYSRST_GMAC1_AHB>;
> +                       reset-names = "stmmaceth", "ahb";
> +                       interrupts = <78>, <77>, <76>;
> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +                       phy-mode = "rgmii-id";
> +                       snps,multicast-filter-bins = <64>;
> +                       snps,perfect-filter-entries = <8>;
> +                       rx-fifo-depth = <2048>;
> +                       tx-fifo-depth = <2048>;
> +                       snps,fixed-burst;
> +                       snps,no-pbl-x8;
> +                       snps,force_thresh_dma_mode;
> +                       snps,axi-config = <&stmmac_axi_setup>;
> +                       snps,tso;
> +                       snps,en-tx-lpi-clockgating;
> +                       snps,txpbl = <16>;
> +                       snps,rxpbl = <16>;
> +                       status = "disabled";
> +                       phy-handle = <&phy1>;
> +
> +                       mdio {
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               compatible = "snps,dwmac-mdio";
> +
> +                               phy1: ethernet-phy@1 {
> +                                       reg = <0>;

I'm getting errors on eth1 unless this is set to <1>. In any case the
number after @ in the node name should match the reg value.

> +                               };
> +                       };
> +               };
>         };
>  };
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
