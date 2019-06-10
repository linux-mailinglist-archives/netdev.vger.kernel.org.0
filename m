Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC96A3BC83
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbfFJTNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389003AbfFJTNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:13:40 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56D08206E0;
        Mon, 10 Jun 2019 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560194018;
        bh=SgAPMSaEUxvxq+9qr8UuEon1HzDQp4Hiw9yj0J1fbLI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ez/nmrRNsPHgsY5xzL1r12IX0ajrww8M/MHyf8XgflzsUcIYvHP0VDnhvQ7hUfHxB
         0XD3smTqM3/MqaGGkNakHx1qIevpamrjbMopQmadZIKDQgGwZbuJHv+AQyjfLkOvVJ
         gnLgChBqjXulcX5VUSL5ZK6Nus8beTCr7s0Qm/dI=
Received: by mail-qt1-f173.google.com with SMTP id x47so11683320qtk.11;
        Mon, 10 Jun 2019 12:13:38 -0700 (PDT)
X-Gm-Message-State: APjAAAX7rbysryNQOtX0DC16juNWy8OG6enqatfyr554A6JLyDOihoiK
        0XVRjCyqO6W6OwDA2h4IKc80gU+77yO5MOx+LQ==
X-Google-Smtp-Source: APXvYqxbnmxR/67G3EBBYhGrNCQfby3DtGX9zIaXC09ldJAJl/I3aiimS6VzdJ3ubnmfORfjtQnlREGXbzQlzoT2oZA=
X-Received: by 2002:a0c:b786:: with SMTP id l6mr33383198qve.148.1560194017564;
 Mon, 10 Jun 2019 12:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <40b91798a807cc3c232119ec74285325ebb6692a.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <40b91798a807cc3c232119ec74285325ebb6692a.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 13:13:25 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ_Y4nzN+BCKcUu7jBDwtT+6w5FFOR5S1eYtLm-uUjGqA@mail.gmail.com>
Message-ID: <CAL_JsqJ_Y4nzN+BCKcUu7jBDwtT+6w5FFOR5S1eYtLm-uUjGqA@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] dt-bindings: net: stmmac: Convert the binding to
 a schemas
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 3:26 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
> schema to enable the DT validation.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v1:
>   - Restrict snps,tso to only a couple of compatibles
>   - Use an enum for the compatibles
>   - Add a custom select statement with the compatibles of all the generic
>     compatibles, including the deprecated ones. Remove the deprecated ones
>     from the valid compatible values to issue a warning when used.
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 389 +++++++++++-
>  Documentation/devicetree/bindings/net/stmmac.txt      | 179 +-----
>  2 files changed, 390 insertions(+), 178 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> new file mode 100644
> index 000000000000..5983715ac5bc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -0,0 +1,389 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/snps,dwmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys DesignWare MAC Device Tree Bindings
> +
> +maintainers:
> +  - Alexandre Torgue <alexandre.torgue@st.com>
> +  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
> +  - Jose Abreu <joabreu@synopsys.com>
> +
> +# Select every compatible, including the deprecated ones. This way, we
> +# will be able to report a warning when we have that compatible, since
> +# we will validate the node thanks to the select, but won't report it
> +# as a valid value in the compatible property description
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - snps,dwmac
> +          - snps,dwmac-3.50a
> +          - snps,dwmac-3.610
> +          - snps,dwmac-3.70a
> +          - snps,dwmac-3.710
> +          - snps,dwmac-4.00
> +          - snps,dwmac-4.10a
> +          - snps,dwxgmac
> +          - snps,dwxgmac-2.10
> +
> +          # Deprecated
> +          - st,spear600-gmac
> +
> +  required:
> +    - compatible
> +
> +properties:
> +
> +  # We need to include all the compatibles from schemas that will
> +  # include that schemas, otherwise compatible won't validate for
> +  # those.
> +  compatible:
> +    contains:
> +      enum:
> +        - snps,dwmac
> +        - snps,dwmac-3.50a
> +        - snps,dwmac-3.610
> +        - snps,dwmac-3.70a
> +        - snps,dwmac-3.710
> +        - snps,dwmac-4.00
> +        - snps,dwmac-4.10a
> +        - snps,dwxgmac
> +        - snps,dwxgmac-2.10
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      - description: Combined signal for various interrupt events
> +      - description: The interrupt to manage the remote wake-up packet detection
> +      - description: The interrupt that occurs when Rx exits the LPI state
> +
> +  interrupt-names:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      - const: macirq
> +      - const: eth_wake_irq
> +      - const: eth_lpi
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      - description: GMAC main clock
> +      - description: Peripheral registers interface clock
> +      - description:
> +          PTP reference clock. This clock is used for programming the
> +          Timestamp Addend Register. If not passed then the system
> +          clock will be used and this is fine on some platforms.
> +
> +  clock-names:
> +    additionalItems: true
> +    contains:
> +      enum:
> +        - stmmaceth
> +        - pclk
> +        - ptp_ref
> +
> +  resets:
> +    maxItems: 1
> +    description:
> +      MAC Reset signal.
> +
> +  reset-names:
> +    const: stmmaceth
> +
> +  snps,axi-config:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      AXI BUS Mode parameters. Phandle to a node that can contain the
> +      following properties
> +        * snps,lpi_en, enable Low Power Interface
> +        * snps,xit_frm, unlock on WoL
> +        * snps,wr_osr_lmt, max write outstanding req. limit
> +        * snps,rd_osr_lmt, max read outstanding req. limit
> +        * snps,kbbe, do not cross 1KiB boundary.
> +        * snps,blen, this is a vector of supported burst length.
> +        * snps,fb, fixed-burst
> +        * snps,mb, mixed-burst
> +        * snps,rb, rebuild INCRx Burst
> +
> +  snps,mtl-rx-config:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Multiple RX Queues parameters. Phandle to a node that can
> +      contain the following properties
> +        * snps,rx-queues-to-use, number of RX queues to be used in the
> +          driver
> +        * Choose one of these RX scheduling algorithms
> +          * snps,rx-sched-sp, Strict priority
> +          * snps,rx-sched-wsp, Weighted Strict priority
> +        * For each RX queue
> +          * Choose one of these modes
> +            * snps,dcb-algorithm, Queue to be enabled as DCB
> +            * snps,avb-algorithm, Queue to be enabled as AVB
> +          * snps,map-to-dma-channel, Channel to map
> +          * Specifiy specific packet routing
> +            * snps,route-avcp, AV Untagged Control packets
> +            * snps,route-ptp, PTP Packets
> +            * snps,route-dcbcp, DCB Control Packets
> +            * snps,route-up, Untagged Packets
> +            * snps,route-multi-broad, Multicast & Broadcast Packets
> +          * snps,priority, RX queue priority (Range 0x0 to 0xF)
> +
> +  snps,mtl-tx-config:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Multiple TX Queues parameters. Phandle to a node that can
> +      contain the following properties
> +        * snps,tx-queues-to-use, number of TX queues to be used in the
> +          driver
> +        * Choose one of these TX scheduling algorithms
> +          * snps,tx-sched-wrr, Weighted Round Robin
> +          * snps,tx-sched-wfq, Weighted Fair Queuing
> +          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
> +          * snps,tx-sched-sp, Strict priority
> +        * For each TX queue
> +          * snps,weight, TX queue weight (if using a DCB weight
> +            algorithm)
> +          * Choose one of these modes
> +            * snps,dcb-algorithm, TX queue will be working in DCB
> +            * snps,avb-algorithm, TX queue will be working in AVB
> +              [Attention] Queue 0 is reserved for legacy traffic
> +                          and so no AVB is available in this queue.
> +          * Configure Credit Base Shaper (if AVB Mode selected)
> +            * snps,send_slope, enable Low Power Interface
> +            * snps,idle_slope, unlock on WoL
> +            * snps,high_credit, max write outstanding req. limit
> +            * snps,low_credit, max read outstanding req. limit
> +          * snps,priority, TX queue priority (Range 0x0 to 0xF)
> +
> +  snps,reset-gpio:
> +    maxItems: 1
> +    description:
> +      PHY Reset GPIO
> +
> +  snps,reset-active-low:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Indicates that the PHY Reset is active low
> +
> +  snps,reset-delays-us:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint32-array
> +      - minItems: 3
> +        maxItems: 3
> +    description:
> +      Triplet of delays. The 1st cell is reset pre-delay in micro
> +      seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
> +      cell is reset post-delay in micro seconds.
> +
> +  snps,aal:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Use Address-Aligned Beats
> +
> +  snps,fixed-burst:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Program the DMA to use the fixed burst mode
> +
> +  snps,mixed-burst:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Program the DMA to use the mixed burst mode
> +
> +  snps,force_thresh_dma_mode:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Force DMA to use the threshold mode for both tx and rx
> +
> +  snps,force_sf_dma_mode:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Force DMA to use the Store and Forward mode for both tx and
> +      rx. This flag is ignored if force_thresh_dma_mode is set.
> +
> +  snps,en-tx-lpi-clockgating:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Enable gating of the MAC TX clock during TX low-power mode
> +
> +  snps,multicast-filter-bins:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Number of multicast filter hash bins supported by this device
> +      instance
> +
> +  snps,perfect-filter-entries:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Number of perfect filter entries supported by this device
> +      instance
> +
> +  snps,ps-speed:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Port selection speed that can be passed to the core when PCS
> +      is supported. For example, this is used in case of SGMII and
> +      MAC2MAC connection.
> +
> +  mdio:
> +    type: object
> +    description:
> +      Creates and registers an MDIO bus.
> +
> +    properties:
> +      compatible:
> +        const: snps,dwmac-mdio
> +
> +    required:
> +      - compatible
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - phy-mode
> +
> +dependencies:
> +  snps,reset-active-low: ["snps,reset-gpio"]
> +  snps,reset-delay-us: ["snps,reset-gpio"]
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - snps,dwxgmac
> +              - snps,dwxgmac-2.10
> +              - st,spear600-gmac
> +
> +    then:
> +      properties:
> +        snps,pbl:
> +          allOf:
> +            - $ref: /schemas/types.yaml#definitions/uint32-array
> +            - enum: [2, 4, 8]

As this is an array, I think this needs to be:

- items:
    enum: [2, 4, 8]


And the next 2, too.

> +          description:
> +            Programmable Burst Length (tx and rx)
> +
> +        snps,txpbl:
> +          allOf:
> +            - $ref: /schemas/types.yaml#definitions/uint32-array
> +            - enum: [2, 4, 8]
> +          description:
> +            Tx Programmable Burst Length. If set, DMA tx will use this
> +            value rather than snps,pbl.
> +
> +        snps,rxpbl:
> +          allOf:
> +            - $ref: /schemas/types.yaml#definitions/uint32-array
> +            - enum: [2, 4, 8]
> +          description:
> +            Rx Programmable Burst Length. If set, DMA rx will use this
> +            value rather than snps,pbl.
> +
> +        snps,no-pbl-x8:
> +          $ref: /schemas/types.yaml#definitions/flag
> +          description:
> +            Don\'t multiply the pbl/txpbl/rxpbl values by 8. For core
> +            rev < 3.50, don\'t multiply the values by 4.
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - snps,dwmac-4.00
> +              - snps,dwmac-4.10a
> +              - snps,dwxgmac
> +              - snps,dwxgmac-2.10
> +              - st,spear600-gmac
> +
> +    then:
> +        snps,tso:
> +          $ref: /schemas/types.yaml#definitions/flag
> +          description:
> +            Enables the TSO feature otherwise it will be managed by
> +            MAC HW capability register.
> +
> +examples:
> +  - |
> +    stmmac_axi_setup: stmmac-axi-config {
> +        snps,wr_osr_lmt = <0xf>;
> +        snps,rd_osr_lmt = <0xf>;
> +        snps,blen = <256 128 64 32 0 0 0>;
> +    };
> +
> +    mtl_rx_setup: rx-queues-config {
> +        snps,rx-queues-to-use = <1>;
> +        snps,rx-sched-sp;
> +        queue0 {
> +            snps,dcb-algorithm;
> +            snps,map-to-dma-channel = <0x0>;
> +            snps,priority = <0x0>;
> +        };
> +    };
> +
> +    mtl_tx_setup: tx-queues-config {
> +        snps,tx-queues-to-use = <2>;
> +        snps,tx-sched-wrr;
> +        queue0 {
> +            snps,weight = <0x10>;
> +            snps,dcb-algorithm;
> +            snps,priority = <0x0>;
> +        };
> +
> +        queue1 {
> +            snps,avb-algorithm;
> +            snps,send_slope = <0x1000>;
> +            snps,idle_slope = <0x1000>;
> +            snps,high_credit = <0x3E800>;
> +            snps,low_credit = <0xFFC18000>;
> +            snps,priority = <0x1>;
> +        };
> +    };
> +
> +    gmac0: ethernet@e0800000 {
> +        compatible = "st,spear600-gmac";
> +        reg = <0xe0800000 0x8000>;
> +        interrupt-parent = <&vic1>;
> +        interrupts = <24 23 22>;
> +        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +        mac-address = [000000000000]; /* Filled in by U-Boot */
> +        max-frame-size = <3800>;
> +        phy-mode = "gmii";
> +        snps,multicast-filter-bins = <256>;
> +        snps,perfect-filter-entries = <128>;
> +        rx-fifo-depth = <16384>;
> +        tx-fifo-depth = <16384>;
> +        clocks = <&clock>;
> +        clock-names = "stmmaceth";
> +        snps,axi-config = <&stmmac_axi_setup>;
> +        snps,mtl-rx-config = <&mtl_rx_setup>;
> +        snps,mtl-tx-config = <&mtl_tx_setup>;
> +        mdio0 {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            compatible = "snps,dwmac-mdio";
> +            phy1: ethernet-phy@0 {
> +            };
> +        };
> +    };
> +
> +# FIXME: We should set it, but it would report all the generic
> +# properties as additional properties.
> +# additionalProperties: false
> +
> +...
