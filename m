Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA1F3DC224
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhGaA4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231337AbhGaA4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5EB61019;
        Sat, 31 Jul 2021 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627692967;
        bh=lBqecP5y/H397gsmUWmJ2Yisrg7kLSnOctgIB24eM/g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AmkxTvtJYDXfp51xmEm1BZ7cCVSF79Y1vBYl/x+hxCv0Qt22GiJeASdbhbk/BC56H
         mtdh1Efhal/QEfUErWnSgnua/iRKTu31mi4P2beLN4Q3o8++E1kzeO6BCtN8bYYBDF
         QDLRPexnypPYTUQw+GrTiuyTmZpoESQpEncU9H2gdeDEAMrAL5M7VEvJS3g7VHzo13
         N0aJ9abyJmhHSfmgCc6JEItg2y/gv3op8aWlEZvx5f/nMA9nmqRRR5E3BASncdCCFC
         06pmqNkpb3Fq6q2nlFt9s1Y5Fas/zKaVXNjmoYG5SbLjzLoNN7RsMcM6FvCaLxEDnF
         SIbm9EaP6BI9Q==
Received: by mail-ed1-f54.google.com with SMTP id ec13so15072409edb.0;
        Fri, 30 Jul 2021 17:56:07 -0700 (PDT)
X-Gm-Message-State: AOAM533KImPiOV0B9aKV2uV7PAczH0JhLXCwCSIXoyJIlt4J62ZCRJRp
        gdMPlmHAh/Isp1I2yAZwZzqanuyYrajhnauS1A==
X-Google-Smtp-Source: ABdhPJwsAPljYk/f23f1n3c+/nsSBqjHdyQ7XqubhqLGZe6OOevcnRH7+bJ+mMnt6Usy+cnD0CvZ8XMFG5HBLrO4fU4=
X-Received: by 2002:a05:6402:254a:: with SMTP id l10mr6592331edb.258.1627692965663;
 Fri, 30 Jul 2021 17:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210730171646.2406-1-dariobin@libero.it>
In-Reply-To: <20210730171646.2406-1-dariobin@libero.it>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 30 Jul 2021 18:55:53 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK0bVV7s3Pw5=_JSo171jnDrCTM5erKz5-dVWA0wR+b7g@mail.gmail.com>
Message-ID: <CAL_JsqK0bVV7s3Pw5=_JSo171jnDrCTM5erKz5-dVWA0wR+b7g@mail.gmail.com>
Subject: Re: [PATCH v3] dt-bindings: net: can: c_can: convert to json-schema
To:     Dario Binacchi <dariobin@libero.it>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 11:16 AM Dario Binacchi <dariobin@libero.it> wrote:
>
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
> Changes in v3:
>  - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
>    property.
>
> Changes in v2:
>  - Drop Documentation references.
>
>  .../bindings/net/can/bosch,c_can.yaml         | 85 +++++++++++++++++++
>  .../devicetree/bindings/net/can/c_can.txt     | 65 --------------
>  2 files changed, 85 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
>
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> new file mode 100644
> index 000000000000..416db97fbf9d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> @@ -0,0 +1,85 @@
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
> +    description: |
> +      Handle to system control region that contains the RAMINIT register,
> +      register offset to the RAMINIT register and the CAN instance number (0
> +      offset).
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    maxItems: 2

Sorry, I misread that and counted 2, not 3 items. But you should have
run the checks.

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

Don't show 'status' in examples. Why would one want an example disabled?

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
> -- compatible           : Should be "bosch,c_can" for C_CAN controllers and
> -                         "bosch,d_can" for D_CAN controllers.
> -                         Can be "ti,dra7-d_can", "ti,am3352-d_can" or
> -                         "ti,am4372-d_can".
> -- reg                  : physical base address and size of the C_CAN/D_CAN
> -                         registers map
> -- interrupts           : property with a value describing the interrupt
> -                         number
> -
> -The following are mandatory properties for DRA7x, AM33xx and AM43xx SoCs only:
> -- ti,hwmods            : Must be "d_can<n>" or "c_can<n>", n being the
> -                         instance number
> -
> -The following are mandatory properties for Keystone 2 66AK2G SoCs only:
> -- power-domains                : Should contain a phandle to a PM domain provider node
> -                         and an args specifier containing the DCAN device id
> -                         value. This property is as per the binding,
> -                         Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
> -- clocks               : CAN functional clock phandle. This property is as per the
> -                         binding,
> -                         Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
> -
> -Optional properties:
> -- syscon-raminit       : Handle to system control region that contains the
> -                         RAMINIT register, register offset to the RAMINIT
> -                         register and the CAN instance number (0 offset).
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
> -       dcan1: d_can@481d0000 {
> -               compatible = "bosch,d_can";
> -               reg = <0x481d0000 0x2000>;
> -               interrupts = <55>;
> -               interrupt-parent = <&intc>;
> -               status = "disabled";
> -       };
> -
> -(or)
> -
> -       dcan1: d_can@481d0000 {
> -               compatible = "bosch,d_can";
> -               ti,hwmods = "d_can1";
> -               reg = <0x481d0000 0x2000>;
> -               interrupts = <55>;
> -               interrupt-parent = <&intc>;
> -               status = "disabled";
> -       };
> -
> -Step 2: board specific .dts file
> -
> -       &dcan1 {
> -               status = "okay";
> -       };
> --
> 2.17.1
>
