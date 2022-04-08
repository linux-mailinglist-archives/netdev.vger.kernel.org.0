Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D356F4F9FAF
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiDHWm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiDHWmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:42:25 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C951A2A30;
        Fri,  8 Apr 2022 15:40:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u15so1316156ejf.11;
        Fri, 08 Apr 2022 15:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QgewujonrGkQK+XVyjLSChHR93fLROybP0cOHE8EdtE=;
        b=JejY7v4g3aLThCo1WQ1QMVCiPQVl7ElI0l5mPA37Yfh2wi3sx5omZ3SHy7FhZDMrWc
         Um9T+2ymnqWYFMYQyQnMCyF5tYg1puzNRpQFDaJz8Tp773c0hmlLy2s4WNzNm8HiQb85
         oHbzSwHH69AFOAc9sdcYFaFBdKnbMDr40LuvIM2cKjYxJTU6OQ5gREq3i/IGJHY29feP
         Nbl2H7jxXTO/H68DPwZT8r44Bk08c0R62rrbSFEAgD6kcOEkVwzCJx5Lk7/5KUVAsjTU
         Wavyu5at6k3CQaaU3LCfWjfNFoYQldeeddkRdAhDZpeiopROwo+jjBtEUsSp3cP6M81G
         t6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QgewujonrGkQK+XVyjLSChHR93fLROybP0cOHE8EdtE=;
        b=y0Lc9f+102AXq/JNvr3+NYwl87QB7Oi3emdV6msuyBlJT6SunG7JrlCw6Hm803HRG9
         BJO3jNJ3Nlp9ViZwnul173DZ9CP9Pp5V1ARfqh+AstFNB1BrPl34BNhaoDYRP7yscJZX
         P40aVmKFlK2eqCKi1dJBn9IPfsOXGI6ooftOFbmMuvuqzDmAWIZqkmyhfDMqVDrN086J
         IR5ZUgO2bOeBR0YfTeGQDt0zdJ54whTxQcq39DaOSZYHMdWeteZinISvFVgq0Dj31lp7
         eykwWcXEbLUcQEuhEYW1Od5PzG5m12/H+txU1EM8M/BTcfcMU7iobqjI2Ckp1J7yvg/9
         c6Mw==
X-Gm-Message-State: AOAM5332EMzKqIfYjh9tlXmxGcHHpbd7sUOr+lwMmR3Xf/mDFp7u0SCj
        8mhY2osOazckC5wU8TFYvf+IgvXi9x8=
X-Google-Smtp-Source: ABdhPJxOQhiELDDhk9Wi1zloXXtB95qTIiQgHRs5FKFUkX9NMJnPKNdVXNjzR8OiR/naAufSLuvUIw==
X-Received: by 2002:a17:907:980a:b0:6db:799c:cb44 with SMTP id ji10-20020a170907980a00b006db799ccb44mr20222548ejc.485.1649457617413;
        Fri, 08 Apr 2022 15:40:17 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id e19-20020a056402105300b004162d0b4cbbsm10874220edu.93.2022.04.08.15.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 15:40:16 -0700 (PDT)
Date:   Sat, 9 Apr 2022 01:40:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, pabeni@redhat.com,
        Rob Herring <robh@kernel.org>
Subject: Re: [RFC PATCH v11 net-next 02/10] dt-bindings: net: dsa: dt
 bindings for microchip lan937x
Message-ID: <20220408224015.bfxjnuoabwo2bypb@skbuf>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
 <20220325165341.791013-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165341.791013-3-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 10:23:33PM +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed.
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports only the delay value of 0ns and 2ns.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/net/dsa/microchip,lan937x.yaml   | 160 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> new file mode 100644
> index 000000000000..8974506d8f69
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> @@ -0,0 +1,160 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN937x Ethernet Switch Series Tree Bindings
> +
> +maintainers:
> +  - UNGLinuxDriver@microchip.com
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - microchip,lan9370
> +      - microchip,lan9371
> +      - microchip,lan9372
> +      - microchip,lan9373
> +      - microchip,lan9374
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 50000000
> +
> +  reset-gpios:
> +    description: Optional gpio specifier for a reset line
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false
> +
> +  tx-internal-delay-ps:
> +    enum: [0, 2000]
> +    default: 0
> +
> +  rx-internal-delay-ps:
> +    enum: [0, 2000]
> +    default: 0

Why are "tx-internal-delay-ps" and "rx-internal-delay-ps" properties of
the switch node and not of individual port nodes?

> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    //Ethernet switch connected via spi to the host

Comment seems off, this node doesn't correspond to an Ethernet switch
but to the DSA master.

> +    ethernet {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      lan9374: switch@0 {
> +        compatible = "microchip,lan9374";
> +        reg = <0>;
> +
> +        spi-max-frequency = <44000000>;
> +
> +        ethernet-ports {
> +          #address-cells = <1>;
> +          #size-cells = <0>;

Some blank lines here and there to separate the nodes from the
properties and from each other would go a long way. Similarly,
properties don't need new lines between each other ("reg" and
"spi-max-frequency").

> +          port@0 {
> +            reg = <0>;
> +            label = "lan1";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy0>;
> +          };
> +          port@1 {
> +            reg = <1>;
> +            label = "lan2";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy1>;
> +          };
> +          port@2 {
> +            reg = <2>;
> +            label = "lan4";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy2>;
> +          };
> +          port@3 {
> +            reg = <3>;
> +            label = "lan6";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy3>;
> +          };
> +          port@4 {
> +            reg = <4>;
> +            phy-mode = "rgmii";
> +            ethernet = <&ethernet>;

shouldn't the "ethernet" node have a label for this to work? Does this
example compile?

> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@5 {
> +            reg = <5>;
> +            label = "lan7";
> +            phy-mode = "rgmii";
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@6 {
> +            reg = <6>;
> +            label = "lan5";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy6>;
> +          };
> +          port@7 {
> +            reg = <7>;
> +            label = "lan3";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy7>;
> +          };
> +        };
> +
> +        mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          t1phy0: ethernet-phy@0{
> +            reg = <0x0>;
> +          };
> +          t1phy1: ethernet-phy@1{
> +            reg = <0x1>;
> +          };
> +          t1phy2: ethernet-phy@2{
> +            reg = <0x2>;
> +          };
> +          t1phy3: ethernet-phy@3{
> +            reg = <0x3>;
> +          };
> +          t1phy6: ethernet-phy@6{
> +            reg = <0x6>;
> +          };
> +          t1phy7: ethernet-phy@7{
> +            reg = <0x7>;
> +          };
> +        };
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 91c04cb65247..373eaee3c8b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12719,6 +12719,7 @@ M:	UNGLinuxDriver@microchip.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>  F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
> -- 
> 2.30.2
> 
