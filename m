Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAB66BDE5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjAPMdU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Jan 2023 07:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAPMdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:33:19 -0500
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9401C338;
        Mon, 16 Jan 2023 04:33:18 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id cm26-20020a056830651a00b00684e5c0108dso2292330otb.9;
        Mon, 16 Jan 2023 04:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F61H973BIjXBatem9Exy4ACFKfXqK3XYvjoCLybvptw=;
        b=urS35smwwuNshpl0oM6fGqd1FUOAUSSCG6iA9TwpE6BUtpsYi/YpbzTmZMgjHpcAfd
         HGsvbGF7Dw15wCdOnlpyNU5lisCA/0nS+X/2EGhE344d65eB4eHn/IdE3tb8fzP8RyPy
         PHBfqHASoxMerIsu4s+QfAOaqj1fDbox2n6NyyqbfLeZXhamLIIyIc6vt1ndqgHpp/6y
         JzVV1hcdonSrOP+L8ngIu4VnyMqjAjzg94I2CjiVQ0wFJ5CxK3n1fv24j5ZBbSrVKCip
         Fqt+NrnE2omBjKmea25KMRJR7T+8/3phO+8q5lDX7reWI9gwuHWN3iyaxYRkvbRHnzys
         LcWw==
X-Gm-Message-State: AFqh2kr5AsMBreOS8pc3dhjc4i2heHPTqTYsOOHydPBshOteu7kCN5KY
        atc9jQ+8mAnXSNENqYgvRM4bV0Fk6l1Xig==
X-Google-Smtp-Source: AMrXdXtzSsNph0ejn7p8tIAE0wWLdos/hFo+vZ3ENfRhvFwTvGYdif1ebIp2V3Kjt1CZrmTBvLG4aA==
X-Received: by 2002:a05:6830:2084:b0:685:134:b73d with SMTP id y4-20020a056830208400b006850134b73dmr2168892otq.23.1673872397164;
        Mon, 16 Jan 2023 04:33:17 -0800 (PST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id cb2-20020a056830618200b0068460566f4bsm14613187otb.30.2023.01.16.04.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 04:33:17 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id d6-20020a056830138600b0068585c52f86so1403698otq.4;
        Mon, 16 Jan 2023 04:33:16 -0800 (PST)
X-Received: by 2002:a25:5189:0:b0:7bf:d201:60cb with SMTP id
 f131-20020a255189000000b007bfd20160cbmr1936519ybb.365.1673872073848; Mon, 16
 Jan 2023 04:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20230116103926.276869-1-clement.leger@bootlin.com> <20230116103926.276869-5-clement.leger@bootlin.com>
In-Reply-To: <20230116103926.276869-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 16 Jan 2023 13:27:42 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVsa4t61AOnEHzuda7czE1fk-16-R8fXsp-MB3hZMJTEQ@mail.gmail.com>
Message-ID: <CAMuHMdVsa4t61AOnEHzuda7czE1fk-16-R8fXsp-MB3hZMJTEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] dt-bindings: net: renesas,rzn1-gmac:
 Document RZ/N1 GMAC support
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

Thanks for your patch!

On Mon, Jan 16, 2023 at 11:37 AM Clément Léger
<clement.leger@bootlin.com> wrote:
> Add "renesas,rzn1-gmac" binding documention which is compatible which

documentation

> "snps,dwmac" compatible driver but uses a custom PCS to communicate
> with the phy.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/renesas,rzn1-gmac.yaml       | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> new file mode 100644
> index 000000000000..effb9a312832
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,rzn1-gmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas GMAC1 Device Tree Bindings
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - renesas,r9a06g032-gmac
> +          - renesas,rzn1-gmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +
> +properties:
> +  compatible:
> +    additionalItems: true
> +    maxItems: 3
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-gmac
> +          - renesas,rzn1-gmac
> +    contains:
> +      enum:
> +        - snps,dwmac

Why not just

    items:
      - enum:
          - renesas,r9a06g032-gmac
          - renesas,rzn1-gmac
          - snps,dwmac

?

> +examples:
> +  - |
> +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet@44000000 {
> +      compatible = "renesas,rzn1-gmac";

Documentation/devicetree/bindings/net/renesas,rzn1-gmac.example.dtb:
ethernet@44000000: compatible: ['renesas,rzn1-gmac'] does not contain
items matching the given schema

> +      reg = <0x44000000 0x2000>;
> +      interrupt-parent = <&gic>;
> +      interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
> +             <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
> +             <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
> +      interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +      clock-names = "stmmaceth";
> +      clocks = <&sysctrl R9A06G032_HCLK_GMAC0>;
> +      snps,multicast-filter-bins = <256>;
> +      snps,perfect-filter-entries = <128>;
> +      tx-fifo-depth = <2048>;
> +      rx-fifo-depth = <4096>;
> +      pcs-handle = <&mii_conv1>;
> +      phy-mode = "mii";
> +    };
> +
> +...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
