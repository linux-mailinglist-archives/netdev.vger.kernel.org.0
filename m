Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03112DB304
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgLORuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:50:46 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44354 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgLORuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:50:46 -0500
Received: by mail-ot1-f66.google.com with SMTP id f16so20196188otl.11;
        Tue, 15 Dec 2020 09:50:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TtEN0qeUEFJtej+0NqYqcBgmDeRXe5i3bl1rddfJtGk=;
        b=EiWXyqnRrPi12ejQ65y1LsL/va+yqTVdTMz0IXyqf1dZo2p7m5bUUyE8MXtLeY39Ij
         7Zkdmo+/2o5n4eMHjXf0znhxXp2yPLQxkw0hs99Wl+g+HV0gRkEtpQYB+p0bbr48Ltjs
         3w22i/8bE8mevu7c4JsBIsDIvziSd7pyBWRBIS9gRCOm3wVRu+KML0eyIWhNCdU/Qo6n
         HGPgZZ1seecMcrkNlFH6NbnrP7+vxqNBFsgCO0Az1W5HbhdB0ul3res0us6EObZgNcNN
         FyXjDnIVKETSMrzuUpPpd5wP2IbKNk3hJ4xoFz1XgXpz/vzpX/pN7+vL6WtdOif9oW3j
         Vr9Q==
X-Gm-Message-State: AOAM531uUBHvp+2IWbi40V8+l8WNk2QGFgqeqO+6CQAKZxD4IbU64CsV
        fVx0xizCTetHC4iKFRs4Jw==
X-Google-Smtp-Source: ABdhPJxbVBZx9Mhv6ck1Loj48EH72/hoWr/0eCy25FEC3zL8+XfOfxlxH17fOBKcLvccgg+/2FSO1g==
X-Received: by 2002:a9d:6450:: with SMTP id m16mr23406700otl.344.1608054604452;
        Tue, 15 Dec 2020 09:50:04 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 73sm572541otv.26.2020.12.15.09.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:50:03 -0800 (PST)
Received: (nullmailer pid 4102332 invoked by uid 1000);
        Tue, 15 Dec 2020 17:50:02 -0000
Date:   Tue, 15 Dec 2020 11:50:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/25] dt-bindings: net: dwmac: Detach Generic DW MAC
 bindings
Message-ID: <20201215175002.GA4074883@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-8-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-8-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:15:57PM +0300, Serge Semin wrote:
> Currently the snps,dwmac.yaml DT bindings file is used for both DT nodes
> describing generic DW MAC devices and as DT schema with common properties
> to be evaluated against a vendor-specific DW MAC IP-cores. Due to such
> dual-purpose design the "compatible" property of the common DW MAC schema
> needs to contain the vendor-specific strings to successfully pass the
> schema evaluation in case if it's referenced from the vendor-specific DT
> bindings. That's a bad design from maintainability point of view, since
> adding/removing any DW MAC-based device bindings requires the common
> schema modification. In order to fix that let's detach the schema which
> provides the generic DW MAC DT nodes evaluation into a dedicated DT
> bindings file preserving the common DW MAC properties declaration in the
> snps,dwmac.yaml file. By doing so we'll still provide a common properties
> evaluation for each vendor-specific MAC bindings which refer to the
> common bindings file, while the generic DW MAC DT nodes will be checked
> against the new snps,dwmac-generic.yaml DT schema.

I'm okay with the change, but it needs a big fat note that 
snps,dwmac-generic.yaml should not have new users. New users should have 
an SoC specific compatible. History has shown that even IP versions are 
not enough to handle all the integration crap vendors do.

> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../bindings/net/snps,dwmac-generic.yaml      | 148 ++++++++++++++++++
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 139 +---------------
>  2 files changed, 149 insertions(+), 138 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> new file mode 100644
> index 000000000000..f1b387911390
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> @@ -0,0 +1,148 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/snps,dwmac-generic.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys DesignWare Generic MAC Device Tree Bindings
> +
> +maintainers:
> +  - Alexandre Torgue <alexandre.torgue@st.com>
> +  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
> +  - Jose Abreu <joabreu@synopsys.com>
> +
> +# Select the DT nodes, which have got compatible strings either as just a
> +# single string with IP-core name optionally followed by the IP version or
> +# two strings: one with IP-core name plus the IP version, another as just
> +# the IP-core name.
> +select:
> +  properties:
> +    compatible:
> +      oneOf:
> +        - items:
> +            - pattern: "^snps,dw(xg)+mac(-[0-9]+\\.[0-9]+a?)?$"
> +        - items:
> +            - pattern: "^snps,dwmac-[0-9]+\\.[0-9]+a?$"
> +            - const: snps,dwmac
> +        - items:
> +            - pattern: "^snps,dwxgmac-[0-9]+\\.[0-9]+a?$"
> +            - const: snps,dwxgmac
> +
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - description: Generic Synopsys DW MAC
> +        oneOf:
> +          - items:
> +              - enum:
> +                  - snps,dwmac-3.50a
> +                  - snps,dwmac-3.610
> +                  - snps,dwmac-3.70a
> +                  - snps,dwmac-3.710
> +                  - snps,dwmac-4.00
> +                  - snps,dwmac-4.10a
> +                  - snps,dwmac-4.20a
> +              - const: snps,dwmac
> +          - const: snps,dwmac
> +      - description: Generic Synopsys DW xGMAC
> +        oneOf:
> +          - items:
> +              - enum:
> +                  - snps,dwxgmac-2.10
> +              - const: snps,dwxgmac
> +          - const: snps,dwxgmac
> +      - description: ST SPEAr SoC Family GMAC
> +        deprecated: true
> +        const: st,spear600-gmac
> +
> +  reg:
> +    maxItems: 1
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    gmac0: ethernet@e0800000 {
> +      compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
> +      reg = <0xe0800000 0x8000>;
> +      interrupt-parent = <&vic1>;
> +      interrupts = <24 23 22>;
> +      interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +      mac-address = [000000000000]; /* Filled in by U-Boot */
> +      max-frame-size = <3800>;
> +      phy-mode = "gmii";
> +      snps,multicast-filter-bins = <256>;
> +      snps,perfect-filter-entries = <128>;
> +      rx-fifo-depth = <16384>;
> +      tx-fifo-depth = <16384>;
> +      clocks = <&clock>;
> +      clock-names = "stmmaceth";
> +      snps,axi-config = <&stmmac_axi_setup>;
> +      snps,mtl-rx-config = <&mtl_rx_setup>;
> +      snps,mtl-tx-config = <&mtl_tx_setup>;
> +      mdio0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        compatible = "snps,dwmac-mdio";
> +        phy1: ethernet-phy@0 {
> +          reg = <0>;
> +        };
> +      };
> +    };
> +  - |
> +    gmac1: ethernet@f8010000 {
> +      compatible = "snps,dwmac-4.10a", "snps,dwmac";
> +      reg = <0xf8010000 0x4000>;
> +      interrupts = <0 98 4>;
> +      interrupt-names = "macirq";
> +      clock-names = "stmmaceth", "ptp_ref";
> +      clocks = <&clock 4>, <&clock 5>;
> +      phy-mode = "rgmii";
> +      snps,txpbl = <8>;
> +      snps,rxpbl = <2>;
> +      snps,aal;
> +      snps,tso;
> +
> +      snps,axi-config {
> +        snps,wr_osr_lmt = <0xf>;
> +        snps,rd_osr_lmt = <0xf>;
> +        snps,blen = <256 128 64 32 0 0 0>;
> +      };
> +
> +      snps,mtl-rx-config {
> +        snps,rx-queues-to-use = <1>;
> +        snps,rx-sched-sp;
> +        queue0 {
> +          snps,dcb-algorithm;
> +          snps,map-to-dma-channel = <0x0>;
> +          snps,priority = <0x0>;
> +        };
> +      };
> +
> +      snps,mtl-tx-config {
> +        snps,tx-queues-to-use = <2>;
> +        snps,tx-sched-wrr;
> +
> +        queue0 {
> +          snps,weight = <0x10>;
> +          snps,dcb-algorithm;
> +          snps,priority = <0x0>;
> +        };
> +
> +        queue1 {
> +          snps,avb-algorithm;
> +          snps,send_slope = <0x1000>;
> +          snps,idle_slope = <0x1000>;
> +          snps,high_credit = <0x3E800>;
> +          snps,low_credit = <0x1FC18000>;
> +          snps,priority = <0x1>;
> +        };
> +      };
> +    };
> +...
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 74820f491346..72b58f86bc41 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -11,31 +11,7 @@ maintainers:
>    - Giuseppe Cavallaro <peppe.cavallaro@st.com>
>    - Jose Abreu <joabreu@synopsys.com>
>  
> -# Select every compatible, including the deprecated ones. This way, we
> -# will be able to report a warning when we have that compatible, since
> -# we will validate the node thanks to the select, but won't report it
> -# as a valid value in the compatible property description
> -select:
> -  properties:
> -    compatible:
> -      contains:
> -        enum:
> -          - snps,dwmac
> -          - snps,dwmac-3.50a
> -          - snps,dwmac-3.610
> -          - snps,dwmac-3.70a
> -          - snps,dwmac-3.710
> -          - snps,dwmac-4.00
> -          - snps,dwmac-4.10a
> -          - snps,dwmac-4.20a
> -          - snps,dwxgmac
> -          - snps,dwxgmac-2.10
> -
> -          # Deprecated
> -          - st,spear600-gmac
> -
> -  required:
> -    - compatible
> +select: false
>  
>  allOf:
>    - $ref: "ethernet-controller.yaml#"
> @@ -62,35 +38,6 @@ allOf:
>              MAC HW capability register.
>  
>  properties:
> -
> -  # We need to include all the compatibles from schemas that will
> -  # include that schemas, otherwise compatible won't validate for
> -  # those.
> -  compatible:
> -    contains:
> -      enum:
> -        - allwinner,sun7i-a20-gmac
> -        - allwinner,sun8i-a83t-emac
> -        - allwinner,sun8i-h3-emac
> -        - allwinner,sun8i-r40-emac
> -        - allwinner,sun8i-v3s-emac
> -        - allwinner,sun50i-a64-emac
> -        - amlogic,meson6-dwmac
> -        - amlogic,meson8b-dwmac
> -        - amlogic,meson8m2-dwmac
> -        - amlogic,meson-gxbb-dwmac
> -        - amlogic,meson-axg-dwmac
> -        - snps,dwmac
> -        - snps,dwmac-3.50a
> -        - snps,dwmac-3.610
> -        - snps,dwmac-3.70a
> -        - snps,dwmac-3.710
> -        - snps,dwmac-4.00
> -        - snps,dwmac-4.10a
> -        - snps,dwmac-4.20a
> -        - snps,dwxgmac
> -        - snps,dwxgmac-2.10
> -
>    reg:
>      minItems: 1
>      maxItems: 2
> @@ -543,88 +490,4 @@ dependencies:
>    snps,reset-delay-us: ["snps,reset-gpio"]
>  
>  additionalProperties: true
> -
> -examples:
> -  - |
> -    gmac0: ethernet@e0800000 {
> -        compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
> -        reg = <0xe0800000 0x8000>;
> -        interrupt-parent = <&vic1>;
> -        interrupts = <24 23 22>;
> -        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> -        mac-address = [000000000000]; /* Filled in by U-Boot */
> -        max-frame-size = <3800>;
> -        phy-mode = "gmii";
> -        snps,multicast-filter-bins = <256>;
> -        snps,perfect-filter-entries = <128>;
> -        rx-fifo-depth = <16384>;
> -        tx-fifo-depth = <16384>;
> -        clocks = <&clock>;
> -        clock-names = "stmmaceth";
> -        snps,axi-config = <&stmmac_axi_setup>;
> -        snps,mtl-rx-config = <&mtl_rx_setup>;
> -        snps,mtl-tx-config = <&mtl_tx_setup>;
> -        mdio0 {
> -            #address-cells = <1>;
> -            #size-cells = <0>;
> -            compatible = "snps,dwmac-mdio";
> -            phy1: ethernet-phy@0 {
> -                reg = <0>;
> -            };
> -        };
> -    };
> -  - |
> -    gmac1: ethernet@f8010000 {
> -        compatible = "snps,dwmac-4.10a", "snps,dwmac";
> -        reg = <0xf8010000 0x4000>;
> -        interrupts = <0 98 4>;
> -        interrupt-names = "macirq";
> -        clock-names = "stmmaceth", "ptp_ref";
> -        clocks = <&clock 4>, <&clock 5>;
> -        phy-mode = "rgmii";
> -        snps,txpbl = <8>;
> -        snps,rxpbl = <2>;
> -        snps,aal;
> -        snps,tso;
> -
> -        snps,axi-config {
> -            snps,wr_osr_lmt = <0xf>;
> -            snps,rd_osr_lmt = <0xf>;
> -            snps,blen = <256 128 64 32 0 0 0>;
> -        };
> -
> -        snps,mtl-rx-config {
> -            snps,rx-queues-to-use = <1>;
> -            snps,rx-sched-sp;
> -            queue0 {
> -               snps,dcb-algorithm;
> -               snps,map-to-dma-channel = <0x0>;
> -               snps,priority = <0x0>;
> -            };
> -        };
> -
> -        snps,mtl-tx-config {
> -            snps,tx-queues-to-use = <2>;
> -            snps,tx-sched-wrr;
> -            queue0 {
> -                snps,weight = <0x10>;
> -                snps,dcb-algorithm;
> -                snps,priority = <0x0>;
> -            };
> -
> -            queue1 {
> -                snps,avb-algorithm;
> -                snps,send_slope = <0x1000>;
> -                snps,idle_slope = <0x1000>;
> -                snps,high_credit = <0x3E800>;
> -                snps,low_credit = <0xFFC18000>;
> -                snps,priority = <0x1>;
> -            };
> -        };
> -    };
> -
> -# FIXME: We should set it, but it would report all the generic
> -# properties as additional properties.
> -# additionalProperties: false
> -
>  ...
> -- 
> 2.29.2
> 
