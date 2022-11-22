Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB5633AC7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiKVLKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiKVLKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:10:44 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBF2CCAC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:10:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j4so23108623lfk.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+lumkSANeVYN39oKSfvZrAR/Mw6IxYn5W+438PdGoU=;
        b=GpncHk39WOYTmUb3Rr+o4xTv2bRvSTGGcDX/29Os+HHdP2Y1LWP+6hxUdJjsvvuaCi
         3WJgK23q7GcS1S0BVWjNRWqBKYUEselyQgin/9cX40QvnJudtpmSJiRXvC3bTHzFfJh/
         shYj7o8cuBbW0Wkq2tauFVFhR2koue7P6pNa3lc0xJV8fP8IXBPfVaY8gmQ5B0eEdMk1
         n65TIwn8lw781l+Ti4+48cCHHvCS7GM64Ns1R7K1lG7ZZiGaLoE0bDVDQOqCYLuJVwc0
         KbYcxH7Kl7n4OHklKL+bL+qv6kb2UoZQX/5suvprSfjQxrEP4dPH6uOCamO2W4ZWxI+f
         g9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+lumkSANeVYN39oKSfvZrAR/Mw6IxYn5W+438PdGoU=;
        b=FTyxjkQz/wmBynhuJk7Pyy7qrWNN4twYnG2/95XsUdn/gBa9yz33QtKlydRH6hyExU
         H5w1EjnUrkL/W4fOm9sQ+1s4pcWoyVPq6rXQY3OHPt3BKYfAD4/QJPrFpczeMzHnJMVg
         MyW7z2sDZX4BqJL0zyQyMeYaezdjQKgwp4Oh29SqAKnzXRSh7ecrtKPisiR1O7hCa9UD
         UFTl39xdXGXETeaBqGnDkcxOVZngQkOHUTWmW4pU/7h0O9gr7KDDHirD+8N3u0Nh9C5B
         JfP3IXyN9lipqjjOZCYo8roY7x8jmeL7V6pMC70deeyj7WXVTmelETJzhBXI4UWY7Fb2
         nQ2A==
X-Gm-Message-State: ANoB5pn9XJzcl+XygJq1/uWpw4FVDMmwje45DDnn0ueRG2KYXpRixoow
        8jyW5C+tZqigA3u5AfNw1mdkiQ==
X-Google-Smtp-Source: AA0mqf7czya88nL8uLXBENV8SqQL7ahBZMH/wfPdIKsODvU5jhTA4yZHA2oF8xUGBTDiY0eAjtCl5w==
X-Received: by 2002:a05:6512:3147:b0:4a7:7daf:905b with SMTP id s7-20020a056512314700b004a77daf905bmr7353168lfi.665.1669115440128;
        Tue, 22 Nov 2022 03:10:40 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id o15-20020a05651205cf00b0049ad2619becsm2451218lfo.131.2022.11.22.03.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 03:10:39 -0800 (PST)
Message-ID: <e74b7496-cd3d-0f20-0308-ce285e7e5dd6@linaro.org>
Date:   Tue, 22 Nov 2022 12:10:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next V3] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20221122102437.1702630-1-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221122102437.1702630-1-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2022 11:24, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> 
> Changes in V3:
> 1) Moved RFC to PATCH.
> 2) Addressed below review comments
> 	a) Indentation.
> 	b) maxItems:3 does not match your description.
> 	c) Filename matching compatibles.
> 
> Changes in V2:
> 1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
> 2) Fix DT check warning('device_type' does not match any of the regexes:
>    'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
>     /xilinx_axienet.yaml).
> ---
>  .../bindings/net/xilinx_axienet.txt           |  99 ------------
>  .../bindings/net/xlnx,axi-ethernet.yaml       | 150 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 151 insertions(+), 99 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> deleted file mode 100644
> index 1aa4c6006cd0..000000000000
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
> diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> new file mode 100644
> index 000000000000..5dc41ab7584b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
> @@ -0,0 +1,150 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,axi-ethernet.yaml#
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
> +  - $ref: ethernet-controller.yaml#
> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - xlnx,axi-ethernet-1.00.a
> +      - xlnx,axi-ethernet-1.01.a
> +      - xlnx,axi-ethernet-2.01.a
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
> +      Ethernet core interrupt is optional. If axistream-connected property is
> +      present DMA node should contains TX/RX DMA interrupts else DMA interrupt
> +      resources are mentioned on ethernet node.
> +    maxItems: 3

This does not fully match the old bindings and you did not mention in
commit msg any changes during conversion. IOW, old binding allowed only
core interrupt. You do not allow it. Was this your intention?

This affects both reg and interrupts which otherwise should have
allOf:if:then constraints.


Best regards,
Krzysztof

