Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87BC3DAFF9
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhG2XkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:40:22 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:36824 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbhG2XkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:40:20 -0400
Received: by mail-io1-f44.google.com with SMTP id f11so9235103ioj.3;
        Thu, 29 Jul 2021 16:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1t2AXPvOdOUBmD9xd+h6gJFk3YFkGT3HaJ45f/XVxGQ=;
        b=N3qJ+jtgYJMdyuZ2uKR3/fHdpPj+JH8a4E1HyGvfsPYdpM1vk8fa6sfzk+esQj3aPk
         qED1tF544OSLpJr/dPrU9dXWWYCw7D0vo0ZPIhfe/H1PvsTXQdpxmldEzPUsxQnDdDe4
         7fo7DBjPbc1z/ndzW86aOOc0tZzh0c7+Q+Nhk5ZWCAGIf15Ukl0zoowzvgSN1d83QCje
         NzKJ/By5m4cI9XM7nGM4CLRAqryd6xITQN/vkUGw5L9gS0538/Cxohrk+mxm+QKGPfEY
         RdpehReLWY0DsrKIoiFWsaZf1gQl43AwUd7amCDL+U1N1myo3nGOwm+YZHMxPzF02QGl
         9P2Q==
X-Gm-Message-State: AOAM533je5vih7Zyg5Q/9xzPOV8ZW+mP6Zj+vzJE/feBCDtkEGyOTvlB
        Rx7/yzzpP9dOEbJ0EU7Kow==
X-Google-Smtp-Source: ABdhPJzqsF+rDEd7h163s4cKHLXQDw5/COgwx2T08qL8uDHhqYhXYt0Q44uhfs0B22IBZP45VCfvfg==
X-Received: by 2002:a6b:2bd4:: with SMTP id r203mr6286207ior.157.1627602016280;
        Thu, 29 Jul 2021 16:40:16 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id h6sm3247379iop.40.2021.07.29.16.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 16:40:15 -0700 (PDT)
Received: (nullmailer pid 1129401 invoked by uid 1000);
        Thu, 29 Jul 2021 23:40:14 -0000
Date:   Thu, 29 Jul 2021 17:40:14 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dt-bindings: net: can: c_can: convert to
 json-schema
Message-ID: <YQM8XjZ8cqde61IU@robh.at.kernel.org>
References: <20210726131526.17542-1-dariobin@libero.it>
 <20210726131526.17542-2-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726131526.17542-2-dariobin@libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 03:15:26PM +0200, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Correct nodename in the example.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> 
> ---
> 
> Changes in v2:
>  - Drop Documentation references
> 
>  .../bindings/net/can/bosch,c_can.yaml         | 83 +++++++++++++++++++
>  .../devicetree/bindings/net/can/c_can.txt     | 65 ---------------
>  2 files changed, 83 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> new file mode 100644
> index 000000000000..f937c37e9199
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> @@ -0,0 +1,83 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Bosch C_CAN/D_CAN controller Device Tree Bindings
> +
> +description: Bosch C_CAN/D_CAN controller for CAN bus
> +
> +maintainers:
> +  - Dario Binacchi <dariobin@libero.it>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - bosch,c_can
> +          - bosch,d_can
> +          - ti,dra7-d_can
> +          - ti,am3352-d_can
> +      - items:
> +          - enum:
> +              - ti,am4372-d_can
> +          - const: ti,am3352-d_can
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  power-domains:
> +    description: |
> +      Should contain a phandle to a PM domain provider node and an args
> +      specifier containing the DCAN device id value. It's mandatory for
> +      Keystone 2 66AK2G SoCs only.
> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      CAN functional clock phandle.
> +    maxItems: 1
> +
> +  clock-names:
> +    maxItems: 1
> +
> +  syscon-raminit:

Needs a type (phandle-array) and size (maxItems: 2)

> +    description: |
> +      Handle to system control region that contains the RAMINIT register,
> +      register offset to the RAMINIT register and the CAN instance number (0
> +      offset).
> +
> +required:
> + - compatible
> + - reg
> + - interrupts
> + - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    can@481d0000 {
> +        compatible = "bosch,d_can";
> +        reg = <0x481d0000 0x2000>;
> +        interrupts = <55>;
> +        interrupt-parent = <&intc>;
> +        status = "disabled";
> +    };
> +  - |
> +    can@0 {
> +        compatible = "ti,am3352-d_can";
> +        reg = <0x0 0x2000>;
> +        clocks = <&dcan1_fck>;
> +        clock-names = "fck";
> +        syscon-raminit = <&scm_conf 0x644 1>;
> +        interrupts = <55>;
> +        status = "disabled";
> +    };
> diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
> deleted file mode 100644
> index 366479806acb..000000000000
> --- a/Documentation/devicetree/bindings/net/can/c_can.txt
> +++ /dev/null
> @@ -1,65 +0,0 @@
> -Bosch C_CAN/D_CAN controller Device Tree Bindings
> --------------------------------------------------
> -
> -Required properties:
> -- compatible		: Should be "bosch,c_can" for C_CAN controllers and
> -			  "bosch,d_can" for D_CAN controllers.
> -			  Can be "ti,dra7-d_can", "ti,am3352-d_can" or
> -			  "ti,am4372-d_can".
> -- reg			: physical base address and size of the C_CAN/D_CAN
> -			  registers map
> -- interrupts		: property with a value describing the interrupt
> -			  number
> -
> -The following are mandatory properties for DRA7x, AM33xx and AM43xx SoCs only:
> -- ti,hwmods		: Must be "d_can<n>" or "c_can<n>", n being the
> -			  instance number
> -
> -The following are mandatory properties for Keystone 2 66AK2G SoCs only:
> -- power-domains		: Should contain a phandle to a PM domain provider node
> -			  and an args specifier containing the DCAN device id
> -			  value. This property is as per the binding,
> -			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
> -- clocks		: CAN functional clock phandle. This property is as per the
> -			  binding,
> -			  Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
> -
> -Optional properties:
> -- syscon-raminit	: Handle to system control region that contains the
> -			  RAMINIT register, register offset to the RAMINIT
> -			  register and the CAN instance number (0 offset).
> -
> -Note: "ti,hwmods" field is used to fetch the base address and irq
> -resources from TI, omap hwmod data base during device registration.
> -Future plan is to migrate hwmod data base contents into device tree
> -blob so that, all the required data will be used from device tree dts
> -file.
> -
> -Example:
> -
> -Step1: SoC common .dtsi file
> -
> -	dcan1: d_can@481d0000 {
> -		compatible = "bosch,d_can";
> -		reg = <0x481d0000 0x2000>;
> -		interrupts = <55>;
> -		interrupt-parent = <&intc>;
> -		status = "disabled";
> -	};
> -
> -(or)
> -
> -	dcan1: d_can@481d0000 {
> -		compatible = "bosch,d_can";
> -		ti,hwmods = "d_can1";
> -		reg = <0x481d0000 0x2000>;
> -		interrupts = <55>;
> -		interrupt-parent = <&intc>;
> -		status = "disabled";
> -	};
> -
> -Step 2: board specific .dts file
> -
> -	&dcan1 {
> -		status = "okay";
> -	};
> -- 
> 2.17.1
> 
> 
