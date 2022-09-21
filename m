Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1F85BF7FD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIUHnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIUHnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:43:51 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A928050C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:43:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s6so7796061lfo.7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=f9Mff2LXrMfrMT4fA5CnsMBw2xtgNuRgq4HPH3N9yhI=;
        b=pINZ+yMHTPcOxf7sXMrXBeYS/3YR9GsS4Ob/y2EZU3exT9wE89wqRha5DBwIupTNTs
         2X/T9iuxgZNr39Z3PZtWA8zW9L02a0A/PO95sCiX4n2JA5Ff7xT+ObZPkTP0LTUhOJMO
         ePrZKBFIwcFdm3kj+xKM8Uiw9m3m0Kxdi0xS71C5Ymub2vxB3OpDGYWx8UKmcA/cQCRY
         sEhs3zxxyIpP1edwcCTz0GJhwOWBNVwguSajxdVLiTRjgm9yIh5D+nl+88/jgoZldwoH
         mXgMkzaMCY9Jof+wQPOo4VD0R5F3Z8KW6so+mJXXSk3FDwUyausc55KhZD4EdEudUlwj
         pA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=f9Mff2LXrMfrMT4fA5CnsMBw2xtgNuRgq4HPH3N9yhI=;
        b=P8uDdyp2ujijrLa9Gl/SKrA/FrrF8AKBpD1g5LR9Z+8PrzRAYqW5VNDQJ6NaWoawlT
         sCz/M4LUB8WOHniUrpaTvFjvLUBscQGN9xbJg8FNRiGKpYz3NJvyT7Lnb/TsGcsP71Xk
         UgdOlrv1P8uWwY+eRuEIgi/QX23oAfRZow2s92afx5mNOI8eOTacPYsBOMNUHCh6rhHW
         qgBic2ArQa9TeFCyAoTwPQnbEf5nOUHX/ZBhSu9YEfdKGbOTRFytrJ1ggUNOxhGJILGX
         3XXNJOJuIxgIJI+VUhzu3Xtcw4oehS65dEShHLcMZHTkSNqlE7qUMB7pGiD00TYJkbTV
         9EGg==
X-Gm-Message-State: ACrzQf25GT0m5HPchhBJr6WqiomgtVuTXHemdKW7srgWNajViR+GlxKw
        wum6mUbeg7oXW2gkK0T1gdonAQ==
X-Google-Smtp-Source: AMsMyM7U9j7XVszv/+m/oSKhXfLt2Lw51enL57wwkMUlM31j79mw6t2Kxv/bmOrp8dBWJhgXKL19sg==
X-Received: by 2002:a05:6512:1047:b0:49d:a875:8d90 with SMTP id c7-20020a056512104700b0049da8758d90mr10138430lfb.630.1663746228004;
        Wed, 21 Sep 2022 00:43:48 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id v8-20020ac258e8000000b004947a12232bsm312618lfo.275.2022.09.21.00.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 00:43:46 -0700 (PDT)
Message-ID: <0ce705d1-4608-f0ae-47c4-c20cd6ad1079@linaro.org>
Date:   Wed, 21 Sep 2022 09:43:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC V2 PATCH 1/3] dt-bindings: net: xilinx_axienet:convert
 bindings document to yaml
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@xilinx.com,
        git@amd.com
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
 <20220920055703.13246-2-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220920055703.13246-2-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 07:57, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> Changes in V2:
> 1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
> 2) Fix DT check warning('device_type' does not match any of the regexes:
>    'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
>     /xilinx_axienet.yaml).

Why this is RFC? This would mean you do not expect full review (e.g. it
is not finished, not ready)?

> ---
>  .../devicetree/bindings/net/xilinx_axienet.txt     |   99 -------------
>  .../devicetree/bindings/net/xlnx,axiethernet.yaml  |  152 ++++++++++++++++++++
>  MAINTAINERS                                        |    1 +
>  3 files changed, 153 insertions(+), 99 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> deleted file mode 100644
> index 1aa4c60..0000000
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ /dev/null
> @@ -1,99 +0,0 @@
> -XILINX AXI ETHERNET Device Tree Bindings
> ---------------------------------------------------------
> -
> -Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
> -provides connectivity to an external ethernet PHY supporting different
> -interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
> -segments of memory for buffering TX and RX, as well as the capability of
> -offloading TX/RX checksum calculation off the processor.
> -
> -Management configuration is done through the AXI interface, while payload is
> -sent and received through means of an AXI DMA controller. This driver
> -includes the DMA driver code, so this driver is incompatible with AXI DMA
> -driver.
> -
> -For more details about mdio please refer phy.txt file in the same directory.
> -
> -Required properties:
> -- compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
> -		  "xlnx,axi-ethernet-1.01.a", "xlnx,axi-ethernet-2.01.a"
> -- reg		: Address and length of the IO space, as well as the address
> -                  and length of the AXI DMA controller IO space, unless
> -                  axistream-connected is specified, in which case the reg
> -                  attribute of the node referenced by it is used.
> -- interrupts	: Should be a list of 2 or 3 interrupts: TX DMA, RX DMA,
> -		  and optionally Ethernet core. If axistream-connected is
> -		  specified, the TX/RX DMA interrupts should be on that node
> -		  instead, and only the Ethernet core interrupt is optionally
> -		  specified here.
> -- phy-handle	: Should point to the external phy device if exists. Pointing
> -		  this to the PCS/PMA PHY is deprecated and should be avoided.
> -		  See ethernet.txt file in the same directory.
> -- xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
> -
> -Optional properties:
> -- phy-mode	: See ethernet.txt
> -- xlnx,phy-type	: Deprecated, do not use, but still accepted in preference
> -		  to phy-mode.
> -- xlnx,txcsum	: 0 or empty for disabling TX checksum offload,
> -		  1 to enable partial TX checksum offload,
> -		  2 to enable full TX checksum offload
> -- xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
> -- xlnx,switch-x-sgmii : Boolean to indicate the Ethernet core is configured to
> -		  support both 1000BaseX and SGMII modes. If set, the phy-mode
> -		  should be set to match the mode selected on core reset (i.e.
> -		  by the basex_or_sgmii core input line).
> -- clock-names: 	  Tuple listing input clock names. Possible clocks:
> -		  s_axi_lite_clk: Clock for AXI register slave interface
> -		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
> -		  ref_clk: Ethernet reference clock, used by signal delay
> -			   primitives and transceivers
> -		  mgt_clk: MGT reference clock (used by optional internal
> -			   PCS/PMA PHY)
> -
> -		  Note that if s_axi_lite_clk is not specified by name, the
> -		  first clock of any name is used for this. If that is also not
> -		  specified, the clock rate is auto-detected from the CPU clock
> -		  (but only on platforms where this is possible). New device
> -		  trees should specify all applicable clocks by name - the
> -		  fallbacks to an unnamed clock or to CPU clock are only for
> -		  backward compatibility.
> -- clocks: 	  Phandles to input clocks matching clock-names. Refer to common
> -		  clock bindings.
> -- axistream-connected: Reference to another node which contains the resources
> -		       for the AXI DMA controller used by this device.
> -		       If this is specified, the DMA-related resources from that
> -		       device (DMA registers and DMA TX/RX interrupts) rather
> -		       than this one will be used.
> - - mdio		: Child node for MDIO bus. Must be defined if PHY access is
> -		  required through the core's MDIO interface (i.e. always,
> -		  unless the PHY is accessed through a different bus).
> -
> - - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> -		  modes, where "pcs-handle" should be used to point
> -		  to the PCS/PMA PHY, and "phy-handle" should point to an
> -		  external PHY if exists.
> -
> -Example:
> -	axi_ethernet_eth: ethernet@40c00000 {
> -		compatible = "xlnx,axi-ethernet-1.00.a";
> -		device_type = "network";
> -		interrupt-parent = <&microblaze_0_axi_intc>;
> -		interrupts = <2 0 1>;
> -		clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
> -		clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
> -		phy-mode = "mii";
> -		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
> -		xlnx,rxcsum = <0x2>;
> -		xlnx,rxmem = <0x800>;
> -		xlnx,txcsum = <0x2>;
> -		phy-handle = <&phy0>;
> -		axi_ethernetlite_0_mdio: mdio {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -			phy0: phy@0 {
> -				device_type = "ethernet-phy";
> -				reg = <1>;
> -			};
> -		};
> -	};
> diff --git a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> new file mode 100644
> index 0000000..780edf3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> @@ -0,0 +1,152 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,axiethernet.yaml#

Filename matching compatibles, at least their common part:
xlnx,axi-ethernet.yaml

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: AXI 1G/2.5G Ethernet Subsystem
> +
> +description: |
> +  Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
> +  provides connectivity to an external ethernet PHY supporting different
> +  interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
> +  segments of memory for buffering TX and RX, as well as the capability of
> +  offloading TX/RX checksum calculation off the processor.
> +
> +  Management configuration is done through the AXI interface, while payload is
> +  sent and received through means of an AXI DMA controller. This driver
> +  includes the DMA driver code, so this driver is incompatible with AXI DMA
> +  driver.
> +
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"

Drop quotes.

> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> +
> +properties:
> +  compatible:
> +    oneOf:

That's not oneOf.

> +      - items:

You do not have more than one item.

> +          - enum:
> +              - xlnx,axi-ethernet-1.00.a
> +              - xlnx,axi-ethernet-1.01.a
> +              - xlnx,axi-ethernet-2.01.a
> +
> +  reg:
> +    description:
> +      Address and length of the IO space, as well as the address
> +      and length of the AXI DMA controller IO space, unless
> +      axistream-connected is specified, in which case the reg
> +      attribute of the node referenced by it is used.
> +    maxItems: 2
> +
> +  interrupts:
> +    description:
> +      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionally Ethernet
> +      core. If axistream-connected is specified, the TX/RX DMA interrupts should
> +      be on that node instead, and only the Ethernet core interrupt is optionally
> +      specified here.
> +    maxItems: 3

maxItems:3 does not match your description. Maybe description needs to
be updated?

> +
> +  phy-handle: true
> +
> +  xlnx,rxmem:
> +    description:
> +      Set to allocated memory buffer for Rx/Tx in the hardware.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  phy-mode: true
> +
> +  xlnx,phy-type:
> +    description:
> +      Do not use, but still accepted in preference to phy-mode.
> +    deprecated: true
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  xlnx,txcsum:
> +    description:
> +      TX checksum offload. 0 or empty for disabling TX checksum offload,
> +      1 to enable partial TX checksum offload and 2 to enable full TX
> +      checksum offload.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> +
> +  xlnx,rxcsum:
> +    description:
> +      RX checksum offload. 0 or empty for disabling RX checksum offload,
> +      1 to enable partial RX checksum offload and 2 to enable full RX
> +      checksum offload.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> +
> +  xlnx,switch-x-sgmii:
> +    type: boolean
> +    description:
> +      Indicate the Ethernet core is configured to support both 1000BaseX and
> +      SGMII modes. If set, the phy-mode should be set to match the mode
> +      selected on core reset (i.e. by the basex_or_sgmii core input line).
> +
> +  clocks:
> +    items:
> +      - description: Clock for AXI register slave interface.
> +      - description: AXI4-Stream clock for TXD RXD TXC and RXS interfaces.
> +      - description: Ethernet reference clock, used by signal delay primitives
> +                     and transceivers.
> +      - description: MGT reference clock (used by optional internal PCS/PMA PHY)
> +
> +  clock-names:
> +    items:
> +      - const: s_axi_lite_clk
> +      - const: axis_clk
> +      - const: ref_clk
> +      - const: mgt_clk
> +
> +  axistream-connected:
> +    type: object
> +    description: Reference to another node which contains the resources
> +      for the AXI DMA controller used by this device. If this is specified,
> +      the DMA-related resources from that device (DMA registers and DMA
> +      TX/RX interrupts) rather than this one will be used.
> +
> +  mdio: true
> +
> +  pcs-handle:
> +    description: Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> +      modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
> +      and "phy-handle" should point to an external PHY if exists.
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +
> +required:
> +  - compatible
> +  - interrupts
> +  - reg
> +  - xlnx,rxmem
> +  - phy-handle
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    axi_ethernet_eth: ethernet@40c00000 {
> +      compatible = "xlnx,axi-ethernet-1.00.a";
> +      interrupt-parent = <&microblaze_0_axi_intc>;
> +      interrupts = <2>, <0>, <1>;
> +      clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
> +      clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
> +      phy-mode = "mii";
> +      reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
> +      xlnx,rxcsum = <0x2>;
> +      xlnx,rxmem = <0x800>;
> +      xlnx,txcsum = <0x2>;
> +      phy-handle = <&phy0>;
> +      axi_ethernetlite_0_mdio: mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy0: ethernet-phy@1 {
> +          device_type = "ethernet-phy";
> +          reg = <1>;
> +          };

Messed up indentation.
x

Best regards,
Krzysztof
