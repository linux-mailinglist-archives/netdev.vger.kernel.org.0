Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07111105A58
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKUTYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUTYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:24:53 -0500
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F82E206DA;
        Thu, 21 Nov 2019 19:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574364291;
        bh=v8qwQtqO7+7IXbxNF6mpOp8cvKguvA76ua3zCs+gonk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fUeRdg6h8COOSs/5Nkm9wBl5fm+v7gyjB8Y2x3CPtKQ/O3IlZGaFkq2/wpFItK0gJ
         UOXDasy2HpPAPqor+OAy3nMDrP7ysE4YZy+OpB21jCJIgKlj9qXYb+GBqbAUphWtSq
         hX92GJw++WnO4iFH57Ex+ml++wkJ8rbZHR3fbGoM=
Received: by mail-qk1-f181.google.com with SMTP id i19so4133278qki.2;
        Thu, 21 Nov 2019 11:24:51 -0800 (PST)
X-Gm-Message-State: APjAAAUo5vQaLx+WOs+YkpweBOGNygkFaFc2HUUmtA8tWh2sY3/c5RAf
        rM3iGjk5uSf4ADPSYCiQ8NBb9+qxjVknFXx5/g==
X-Google-Smtp-Source: APXvYqzBsWNUu1nzTcj5u5+SkuECwizSqPemoqPhEa2uIgUAQSq3Vk/bIVg/iQeB116Ri4RGcaeCFiqA8mabOmm0WcA=
X-Received: by 2002:a37:81c6:: with SMTP id c189mr2575110qkd.223.1574364290557;
 Thu, 21 Nov 2019 11:24:50 -0800 (PST)
MIME-Version: 1.0
References: <20191119221925.28426-1-grygorii.strashko@ti.com> <20191119221925.28426-7-grygorii.strashko@ti.com>
In-Reply-To: <20191119221925.28426-7-grygorii.strashko@ti.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 21 Nov 2019 13:24:39 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKfWOZeXXxqyKtH98cbccXUoV7djRtxzyoq0hA_qx-bpQ@mail.gmail.com>
Message-ID: <CAL_JsqKfWOZeXXxqyKtH98cbccXUoV7djRtxzyoq0hA_qx-bpQ@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 06/13] dt-bindings: net: ti: add new cpsw
 switch driver bindings
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 4:19 PM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> Add bindings for the new TI CPSW switch driver. Comparing to the legacy
> bindings (net/cpsw.txt):
> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
> marked as "disabled" if not physically wired.
> - all deprecated properties dropped;
> - all legacy propertiies dropped which represent constant HW cpapbilities
> (cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
> active_slave)
> - TI CPTS DT properties are reused as is, but grouped in "cpts" sub-node
> - TI Davinci MDIO DT bindings are reused as is, because Davinci MDIO is
> reused.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,cpsw-switch.yaml          | 240 ++++++++++++++++++
>  1 file changed, 240 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml

I see David has applied this already, but it still has numerous
problems. Please send a follow-up.

>
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> new file mode 100644
> index 000000000000..81ae8cafabc1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -0,0 +1,240 @@
> +# SPDX-License-Identifier: GPL-2.0

For new bindings, please dual license:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,cpsw-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: TI SoC Ethernet Switch Controller (CPSW) Device Tree Bindings
> +
> +maintainers:
> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> +  - Sekhar Nori <nsekhar@ti.com>
> +
> +description:
> +  The 3-port switch gigabit ethernet subsystem provides ethernet packet
> +  communication and can be configured as an ethernet switch. It provides the
> +  gigabit media independent interface (GMII),reduced gigabit media
> +  independent interface (RGMII), reduced media independent interface (RMII),
> +  the management data input output (MDIO) for physical layer device (PHY)
> +  management.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: ti,cpsw-switch
> +      - items:
> +         - const: ti,am335x-cpsw-switch
> +         - const: ti,cpsw-switch
> +      - items:
> +        - const: ti,am4372-cpsw-switch
> +        - const: ti,cpsw-switch
> +      - items:
> +        - const: ti,dra7-cpsw-switch
> +        - const: ti,cpsw-switch
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +       The physical base address and size of full the CPSW module IO range
> +
> +  ranges: true
> +
> +  clocks:
> +    maxItems: 1
> +    description: CPSW functional clock
> +
> +  clock-names:
> +    maxItems: 1
> +    items:
> +      - const: fck
> +
> +  interrupts:
> +    items:
> +      - description: RX_THRESH interrupt
> +      - description: RX interrupt
> +      - description: TX interrupt
> +      - description: MISC interrupt
> +
> +  interrupt-names:
> +    items:
> +      - const: "rx_thresh"
> +      - const: "rx"
> +      - const: "tx"
> +      - const: "misc"
> +
> +  pinctrl-names: true
> +
> +  syscon:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Phandle to the system control device node which provides access to
> +      efuse IO range with MAC addresses

Can't you use nvmem binding for this?

> +
> +

Drop the extra blank line.

> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +          type: object

> +          minItems: 1
> +          maxItems: 2

These apply to arrays and don't make sense here.

> +          description: CPSW external ports
> +
> +          allOf:
> +            - $ref: ethernet-controller.yaml#
> +
> +          properties:
> +            reg:
> +              maxItems: 1
> +              enum: [1, 2]

You're mixing array and scalar constraints. What you want is:

reg:
  items:
    - enum: [1, 2]

> +              description: CPSW port number
> +
> +            phys:
> +              $ref: /schemas/types.yaml#definitions/phandle-array

Drop this. 'phys' is standard and has a type definition already.

> +              maxItems: 1
> +              description:  phandle on phy-gmii-sel PHY
> +
> +            label:
> +              $ref: /schemas/types.yaml#/definitions/string-array

Same here.

> +              maxItems: 1

This too. 'label' should never be an array.

> +              description: label associated with this port
> +
> +            ti,dual-emac-pvid:
> +              $ref: /schemas/types.yaml#/definitions/uint32
> +              maxItems: 1
> +              minimum: 1
> +              maximum: 1024

allOf:
  - $ref: /schemas/types.yaml#/definitions/uint32
minimum: 1
maximum: 1024

> +              description:
> +                Specifies default PORT VID to be used to segregate
> +                ports. Default value - CPSW port number.
> +
> +          required:
> +            - reg
> +            - phys
> +
> +  mdio:
> +    type: object
> +    allOf:
> +      - $ref: "ti,davinci-mdio.yaml#"
> +    description:
> +      CPSW MDIO bus.
> +
> +  cpts:
> +    type: object
> +    description:
> +      The Common Platform Time Sync (CPTS) module
> +
> +    properties:
> +      clocks:
> +        maxItems: 1
> +        description: CPTS reference clock
> +
> +      clock-names:
> +        maxItems: 1

Can drop this. Implied by 'items' list length.

> +        items:
> +          - const: cpts
> +
> +      cpts_clock_mult:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description:
> +          Numerator to convert input clock ticks into ns
> +
> +      cpts_clock_shift:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description:
> +          Denominator to convert input clock ticks into ns.
> +          Mult and shift will be calculated basing on CPTS rftclk frequency if
> +          both cpts_clock_shift and cpts_clock_mult properties are not provided.
> +
> +    required:
> +      - clocks
> +      - clock-names
> +
> +required:
> +  - compatible
> +  - reg
> +  - ranges
> +  - clocks
> +  - clock-names
> +  - interrupts
> +  - interrupt-names
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/dra7.h>
> +
> +    mac_sw: switch@0 {
> +        compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
> +        reg = <0x0 0x4000>;
> +        ranges = <0 0 0x4000>;
> +        clocks = <&gmac_main_clk>;
> +        clock-names = "fck";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        syscon = <&scm_conf>;
> +        inctrl-names = "default", "sleep";
> +
> +        interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "rx_thresh", "rx", "tx", "misc";
> +
> +        ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                cpsw_port1: port@1 {
> +                        reg = <1>;
> +                        label = "port1";
> +                        mac-address = [ 00 00 00 00 00 00 ];
> +                        phys = <&phy_gmii_sel 1>;
> +                        phy-handle = <&ethphy0_sw>;
> +                        phy-mode = "rgmii";
> +                        ti,dual_emac_pvid = <1>;
> +                };
> +
> +                cpsw_port2: port@2 {
> +                        reg = <2>;
> +                        label = "wan";
> +                        mac-address = [ 00 00 00 00 00 00 ];
> +                        phys = <&phy_gmii_sel 2>;
> +                        phy-handle = <&ethphy1_sw>;
> +                        phy-mode = "rgmii";
> +                        ti,dual_emac_pvid = <2>;
> +                };
> +        };
> +
> +        davinci_mdio_sw: mdio@1000 {
> +                compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> +                reg = <0x1000 0x100>;
> +                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
> +                clock-names = "fck";
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                bus_freq = <1000000>;
> +
> +                ethphy0_sw: ethernet-phy@0 {
> +                        reg = <0>;
> +                };
> +
> +                ethphy1_sw: ethernet-phy@1 {
> +                        reg = <1>;
> +                };
> +        };
> +
> +        cpts {
> +                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
> +                clock-names = "cpts";
> +        };
> +    };
> --
> 2.17.1
>
