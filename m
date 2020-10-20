Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23728D19F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgJMP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 11:57:12 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34949 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731302AbgJMP5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 11:57:11 -0400
Received: by mail-oi1-f193.google.com with SMTP id w141so23030294oia.2;
        Tue, 13 Oct 2020 08:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OZ/eS1qPTmzOSxijyOeTEv/iETW9q80iAo0sLSTFilA=;
        b=XCIz20HcArs9IXMapoZitc5f+MJDNUl6CtRTyoV6FBXMYhWXRLJQHBwt7l1i/hbj3E
         opZ7+Zh6r4+aa6UoOAkruMQAbBc3u7/eA2EtbdXmXBIR2kXcpGkXz3EGuziRzIf/Yq/o
         SPvxs2pNx9UtJ20ugwUPAjFicXbMegXLf45MyqeCnao08r1HK7Xl/5pnutEmtVf9Hqmg
         4vL7GT01sZy/QijxWWscvOKYvqD07U4xXG7RZ1CUkKPXOJYCyzyhNYkEsJFM2bLP5m0b
         Potk137WhzZSqPlnYEMlUiH/UQR+yBNAYIobqsnaj+1SyXcuSUPCGz7FHXL8Epk4h5e1
         sd2A==
X-Gm-Message-State: AOAM5338lrHgmM+b9AjRHQqC+pKjoGVx9cSeqGnnnDVsnNQovDHHktds
        J+Rw3ETT4zZFbhHZIeNqvgzISl4izlK0
X-Google-Smtp-Source: ABdhPJz+H4GxPSSrEPTmrPeF3MwsaF2EiDnEhhJZHgylYS4aQDW7pXDNfI6eE7csQEmkcYcnshh60g==
X-Received: by 2002:aca:c485:: with SMTP id u127mr249666oif.92.1602604630073;
        Tue, 13 Oct 2020 08:57:10 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m13sm47370otn.20.2020.10.13.08.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 08:57:09 -0700 (PDT)
Received: (nullmailer pid 3594570 invoked by uid 1000);
        Tue, 13 Oct 2020 15:57:08 -0000
Date:   Tue, 13 Oct 2020 10:57:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] dt-bindings: can: flexcan: convert fsl,*flexcan
 bindings to yaml
Message-ID: <20201013155708.GA3588169@bogus>
References: <20201009132912.7583-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009132912.7583-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 03:29:12PM +0200, Oleksij Rempel wrote:
> In order to automate the verification of DT nodes convert
> fsl-flexcan.txt to fsl,flexcan.yaml
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/can/fsl,flexcan.yaml         | 137 ++++++++++++++++++
>  .../bindings/net/can/fsl-flexcan.txt          |  57 --------
>  2 files changed, 137 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
> new file mode 100644
> index 000000000000..6486047f48b8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
> @@ -0,0 +1,137 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/fsl,flexcan.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Flexcan CAN controller on Freescale's ARM and PowerPC system-on-a-chip (SOC).
> +
> +maintainers:
> +  - Marc Kleine-Budde <mkl@pengutronix.de>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - fsl,imx8qm-flexcan
> +          - fsl,imx8mp-flexcan
> +          - fsl,imx6q-flexcan
> +          - fsl,imx53-flexcan
> +          - fsl,imx35-flexcan
> +          - fsl,imx28-flexcan
> +          - fsl,imx25-flexcan
> +          - fsl,p1010-flexcan
> +          - fsl,vf610-flexcan
> +          - fsl,ls1021ar2-flexcan
> +          - fsl,lx2160ar1-flexcan
> +      - items:
> +          - enum:
> +              - fsl,imx7d-flexcan
> +              - fsl,imx6ul-flexcan
> +              - fsl,imx6sx-flexcan
> +          - const: fsl,imx6q-flexcan
> +      - items:
> +          - enum:
> +              - fsl,ls1028ar1-flexcan
> +          - const: fsl,lx2160ar1-flexcan
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: ipg
> +      - const: per
> +
> +  clock-frequency:
> +    description: |
> +      The oscillator frequency driving the flexcan device, filled in by the
> +      boot loader. This property should only be used the used operating system
> +      doesn't support the clocks and clock-names property.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  xceiver-supply:
> +    description: Regulator that powers the CAN transceiver.
> +    maxItems: 1
> +
> +  big-endian:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description: |
> +      This means the registers of FlexCAN controller are big endian. This is
> +      optional property.i.e. if this property is not present in device tree
> +      node then controller is assumed to be little endian. If this property is
> +      present then controller is assumed to be big endian.
> +
> +  fsl,stop-mode:
> +    description: |
> +      Register bits of stop mode control.
> +
> +      The format should be as follows:
> +      <gpr req_gpr req_bit>
> +      gpr is the phandle to general purpose register node.
> +      req_gpr is the gpr register offset of CAN stop request.
> +      req_bit is the bit offset of CAN stop request.
> +    $ref: /schemas/types.yaml#/definitions/uint32-array

Should be a phandle-array.

> +    items:
> +      items:
> +        - description: The 'gpr' is the phandle to general purpose register node.
> +        - description: The 'req_gpr' is the gpr register offset of CAN stop request.
> +          maximum: 0xff
> +        - description: The 'req_bit' is the bit offset of CAN stop request.
> +          maximum: 0x1f
> +    minItems: 1
> +    maxItems: 1

Drop the outer 'items' and these 2. 

> +
> +  fsl,clk-source:
> +    description: |
> +      Select the clock source to the CAN Protocol Engine (PE). It's SoC
> +      implementation dependent. Refer to RM for detailed definition. If this
> +      property is not set in device tree node then driver selects clock source 1
> +      by default.
> +      0: clock source 0 (oscillator clock)
> +      1: clock source 1 (peripheral clock)
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 1
> +    minimum: 0
> +    maximum: 1
> +
> +  wakeup-source:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Enable CAN remote wakeup.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    can@1c000 {
> +        compatible = "fsl,p1010-flexcan";
> +        reg = <0x1c000 0x1000>;
> +        interrupts = <48 0x2>;
> +        interrupt-parent = <&mpic>;
> +        clock-frequency = <200000000>;
> +        fsl,clk-source = <0>;
> +    };
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    flexcan@2090000 {

can@...

> +        compatible = "fsl,imx6q-flexcan";
> +        reg = <0x02090000 0x4000>;
> +        interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&clks 1>, <&clks 2>;
> +        clock-names = "ipg", "per";
> +        fsl,stop-mode = <&gpr 0x34 28>;
> +    };
> diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
> deleted file mode 100644
> index e10b6eb955e1..000000000000
> --- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -Flexcan CAN controller on Freescale's ARM and PowerPC system-on-a-chip (SOC).
> -
> -Required properties:
> -
> -- compatible : Should be "fsl,<processor>-flexcan"
> -
> -  where <processor> is imx8qm, imx6q, imx28, imx53, imx35, imx25, p1010,
> -  vf610, ls1021ar2, lx2160ar1, ls1028ar1.
> -
> -  The ls1028ar1 must be followed by lx2160ar1, e.g.
> -   - "fsl,ls1028ar1-flexcan", "fsl,lx2160ar1-flexcan"
> -
> -  An implementation should also claim any of the following compatibles
> -  that it is fully backwards compatible with:
> -
> -  - fsl,p1010-flexcan
> -
> -- reg : Offset and length of the register set for this device
> -- interrupts : Interrupt tuple for this device
> -
> -Optional properties:
> -
> -- clock-frequency : The oscillator frequency driving the flexcan device
> -
> -- xceiver-supply: Regulator that powers the CAN transceiver
> -
> -- big-endian: This means the registers of FlexCAN controller are big endian.
> -              This is optional property.i.e. if this property is not present in
> -              device tree node then controller is assumed to be little endian.
> -              if this property is present then controller is assumed to be big
> -              endian.
> -
> -- fsl,stop-mode: register bits of stop mode control, the format is
> -		 <&gpr req_gpr req_bit>.
> -		 gpr is the phandle to general purpose register node.
> -		 req_gpr is the gpr register offset of CAN stop request.
> -		 req_bit is the bit offset of CAN stop request.
> -
> -- fsl,clk-source: Select the clock source to the CAN Protocol Engine (PE).
> -		  It's SoC Implementation dependent. Refer to RM for detailed
> -		  definition. If this property is not set in device tree node
> -		  then driver selects clock source 1 by default.
> -		  0: clock source 0 (oscillator clock)
> -		  1: clock source 1 (peripheral clock)
> -
> -- wakeup-source: enable CAN remote wakeup
> -
> -Example:
> -
> -	can@1c000 {
> -		compatible = "fsl,p1010-flexcan";
> -		reg = <0x1c000 0x1000>;
> -		interrupts = <48 0x2>;
> -		interrupt-parent = <&mpic>;
> -		clock-frequency = <200000000>; // filled in by bootloader
> -		fsl,clk-source = <0>; // select clock source 0 for PE
> -	};
> -- 
> 2.28.0
> 
