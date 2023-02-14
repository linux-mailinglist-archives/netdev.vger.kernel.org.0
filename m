Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF23696497
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjBNNXk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 08:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBNNXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:23:39 -0500
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0EF11C;
        Tue, 14 Feb 2023 05:23:38 -0800 (PST)
Received: by mail-qt1-f175.google.com with SMTP id w3so17286477qts.7;
        Tue, 14 Feb 2023 05:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4d/IW4N4wxgQvgkiL75RXQZp2sQYcrN7W4VVjwtQeMs=;
        b=yrsD0B7eQdObgEyJDsdrOf9rwaUs8079M3UyK2E2LHP6ROQO0rRQeXbxK1kgSDfFow
         kEcqxFUxOubvOgQnugiiCm9LcElp9ReB8ku7KN5vwCQIr2NiJbVSNW7q4L+opFuHnUlJ
         xx7NniSGYbHgLqUdC9wfwIuSJq3rsnKt7FsNjdepehUqhnt08+nghANuFHVD6Z0NskPE
         BXqzL/e0bMq1b/2KicJ0zbdTd/+d7pBDZlcLO1vJ7cTMuh3oYLtkNsfV6ybuJd8XZ1/2
         OGEK1AwloyJuFqkBPJkGoJNtxKlPsb6kI13ELHTdUXcquJw45ZM17BiMILAIJ0pUFw5N
         AnHA==
X-Gm-Message-State: AO0yUKUsc7kB3j39yq4smA6W/H/BV4VsHD5WMXX4bwwDh42LNaPGcLGU
        rHd57pWBfxW1yThZlKvUGzTWAAVl4M4EdTiI
X-Google-Smtp-Source: AK7set+GZjcSjigTsXi0AbuGWMH3MZfG8SAaFewuani7bIXtfV/tNrA8dB0sT+yxFVQXrj1CaX9+yQ==
X-Received: by 2002:a05:622a:1ba2:b0:3b9:b70c:9697 with SMTP id bp34-20020a05622a1ba200b003b9b70c9697mr3344291qtb.5.1676381017395;
        Tue, 14 Feb 2023 05:23:37 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id u123-20020a379281000000b0073b4d9e2e8dsm2611494qkd.43.2023.02.14.05.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 05:23:37 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-52ecd867d89so157739377b3.8;
        Tue, 14 Feb 2023 05:23:37 -0800 (PST)
X-Received: by 2002:a05:690c:ea2:b0:4fc:962d:7dc1 with SMTP id
 cr2-20020a05690c0ea200b004fc962d7dc1mr197860ywb.301.1676380647699; Tue, 14
 Feb 2023 05:17:27 -0800 (PST)
MIME-Version: 1.0
References: <20230209151632.275883-1-clement.leger@bootlin.com> <20230209151632.275883-7-clement.leger@bootlin.com>
In-Reply-To: <20230209151632.275883-7-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Feb 2023 14:17:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVpkX=_GBacD7i2+fCkTuMoGS+Y0Gh1U2fWZ2RDj6aX1g@mail.gmail.com>
Message-ID: <CAMuHMdVpkX=_GBacD7i2+fCkTuMoGS+Y0Gh1U2fWZ2RDj6aX1g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 6/6] ARM: dts: r9a06g032: describe GMAC1
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, Feb 9, 2023 at 4:14 PM Clément Léger <clement.leger@bootlin.com> wrote:
> RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> port 1. Since this MII converter is represented using a PCS driver, it
> uses the renesas specific compatible driver which uses this PCS.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -304,6 +304,24 @@ dma1: dma-controller@40105000 {
>                         data-width = <8>;
>                 };
>
> +               gmac1: ethernet@44000000 {
> +                       compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
> +                       reg = <0x44000000 0x2000>;
> +                       interrupt-parent = <&gic>;
> +                       interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +                       clock-names = "stmmaceth";

Please move clock-names below clocks, like in all other nodes.

> +                       clocks = <&sysctrl R9A06G032_HCLK_GMAC0>;

Missing power-domains property.

> +                       snps,multicast-filter-bins = <256>;
> +                       snps,perfect-filter-entries = <128>;
> +                       tx-fifo-depth = <2048>;
> +                       rx-fifo-depth = <4096>;
> +                       pcs-handle = <&mii_conv1>;
> +                       status = "disabled";
> +               };
> +
>                 gmac2: ethernet@44002000 {
>                         compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
>                         reg = <0x44002000 0x2000>;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
