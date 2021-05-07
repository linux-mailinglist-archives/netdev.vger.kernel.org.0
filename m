Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F37E37618E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhEGH6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:58:53 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:24662 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhEGH6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:58:51 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2021 03:58:51 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1620373908; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=YHa9NaoAclxm/+pAiVBhPlwFcQ0eEUXftZ4JU10U5b0uHE8Vy8ktSZnRGdnLMVm0WR
    mBm/16grRYV+EmejiQpSsmh07F50hv4BYIVLpOazvdhlu9+lZGe/I9UM7VAo6tdPZ0/f
    m3sJKPOVAuylGx9KBVRQ0zoUo2sMg4ECqcfhiOKuwEUjcKZhgulX7mmurw5nk1NJUb+P
    MoMXRfy60r5oHcneCRy7ytQMK3a7Xi27JeRQuhT96V09Xd0s2XyE1aR4IeewHAHF1Bap
    3iiiGPmMPhVJBZDkDP+nONsig183c047vORiNXfabIVlVMS42EYnnLlA3vgbEwK79yQN
    ZESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1620373908;
    s=strato-dkim-0002; d=strato.com;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=uU/igvcIo3Zn0TvoZRA886pcFAg6+u1H+x1uDvYRi+Y=;
    b=BxhRB6qINMcCjDYxwyni4Cb/dYB5kbWH6YDGesgK6okwFH+y735a9ehaD9bMT5BHfF
    yuQ41Z+wMx2zZWR0ZTBKl5wwRNTStxD2w9rZmpKX8jGnFlDk0shjc34p9kttz7v8MqN3
    1kuyGzqW/ojNbavyBHwZSoIUQ+exdTDEqSFBQSkM4vAw3uAv4IZS3rTOcs7mvgDIDSrp
    YoBpU6GJKwqe6ofZsXJM2efZ3/bFjArWR5CPIkPw/+JtbEIsHCwJdtL1CMylzE6w3I0/
    uMK0WqsJ2fBeG7+XL5dEnVHo7UF4dUIodwMRpnjYk2py1QJ4/4pG5doC8GBWoJFaR9JP
    E/MQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1620373908;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=uU/igvcIo3Zn0TvoZRA886pcFAg6+u1H+x1uDvYRi+Y=;
    b=LEFZR4FIdY7hQaQ5z2//cmlh3k/8TkQT5Oq336+BgmQOPIwtlcbJ967ER2qoQ6L4Pm
    k5JSMAdWHAg44YDiF8lpZmRgWoczS5irfCtP36VuUXma/TN8ISmSVSb3YBFReCLgK+ls
    qPJ+TPDys1Q2CECPWMJ2zduHGtIcfk6/w21i7PCs4QQkZjCT4u4Yuuvh7CYvfRepNOvb
    shvdGtEtDsJVWTAalr0aZcxIMbb3MSOBLk7lJe4WTJHrUWGWuwBKC43CEEPC75bl7RwZ
    Z7gC6rhMWmCIb0JJyEG8egO4WV+w7AHoIXQU37JjQZatmQ+S32iiUsWXWkObXIeVu/3+
    EQig==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCv/x28jVM="
X-RZG-CLASS-ID: mo00
Received: from oxapp06-01.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.25.6 AUTH)
    with ESMTPSA id 30a8b7x477pm3an
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Fri, 7 May 2021 09:51:48 +0200 (CEST)
Date:   Fri, 7 May 2021 09:51:48 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-can@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <75917435.1034822.1620373908866@webmail.strato.com>
In-Reply-To: <905134c87f72e2d8e37c309e0ce28ecd7d4f3992.1620323639.git.geert+renesas@glider.be>
References: <cover.1620323639.git.geert+renesas@glider.be>
 <905134c87f72e2d8e37c309e0ce28ecd7d4f3992.1620323639.git.geert+renesas@glider.be>
Subject: Re: [PATCH 2/2] dt-bindings: can: rcar_canfd: Convert to
 json-schema
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.4-Rev22
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 05/06/2021 7:55 PM Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> 
>  
> Convert the Renesas R-Car CAN FD Controller Device Tree binding
> documentation to json-schema.
> 
> Document missing properties.
> The CANFD clock needs to be configured for the maximum frequency on
> R-Car V3M and V3H, too.
> Update the example to match reality.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I have listed Fabrizio as the maintainer, as Ramesh is no longer
> available.  Fabrizio: Please scream if this is inappropriate ;-)
> ---
>  .../bindings/net/can/rcar_canfd.txt           | 107 ---------------
>  .../bindings/net/can/renesas,rcar-canfd.yaml  | 122 ++++++++++++++++++
>  2 files changed, 122 insertions(+), 107 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> deleted file mode 100644
> index 248c4ed97a0a078e..0000000000000000
> --- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> +++ /dev/null
> @@ -1,107 +0,0 @@
> -Renesas R-Car CAN FD controller Device Tree Bindings
> -----------------------------------------------------
> -
> -Required properties:
> -- compatible: Must contain one or more of the following:
> -  - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
> -  - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
> -  - "renesas,r8a774b1-canfd" for R8A774B1 (RZ/G2N) compatible controller.
> -  - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
> -  - "renesas,r8a774e1-canfd" for R8A774E1 (RZ/G2H) compatible controller.
> -  - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
> -  - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
> -  - "renesas,r8a77965-canfd" for R8A77965 (R-Car M3-N) compatible controller.
> -  - "renesas,r8a77970-canfd" for R8A77970 (R-Car V3M) compatible controller.
> -  - "renesas,r8a77980-canfd" for R8A77980 (R-Car V3H) compatible controller.
> -  - "renesas,r8a77990-canfd" for R8A77990 (R-Car E3) compatible controller.
> -  - "renesas,r8a77995-canfd" for R8A77995 (R-Car D3) compatible controller.
> -
> -  When compatible with the generic version, nodes must list the
> -  SoC-specific version corresponding to the platform first, followed by the
> -  family-specific and/or generic versions.
> -
> -- reg: physical base address and size of the R-Car CAN FD register map.
> -- interrupts: interrupt specifiers for the Channel & Global interrupts
> -- clocks: phandles and clock specifiers for 3 clock inputs.
> -- clock-names: 3 clock input name strings: "fck", "canfd", "can_clk".
> -- pinctrl-0: pin control group to be used for this controller.
> -- pinctrl-names: must be "default".
> -
> -Required child nodes:
> -The controller supports two channels and each is represented as a child node.
> -The name of the child nodes are "channel0" and "channel1" respectively. Each
> -child node supports the "status" property only, which is used to
> -enable/disable the respective channel.
> -
> -Required properties for R8A774A1, R8A774B1, R8A774C0, R8A774E1, R8A7795,
> -R8A7796, R8A77965, R8A77990, and R8A77995:
> -In the denoted SoCs, canfd clock is a div6 clock and can be used by both CAN
> -and CAN FD controller at the same time. It needs to be scaled to maximum
> -frequency if any of these controllers use it. This is done using the below
> -properties:
> -
> -- assigned-clocks: phandle of canfd clock.
> -- assigned-clock-rates: maximum frequency of this clock.
> -
> -Optional property:
> -The controller can operate in either CAN FD only mode (default) or
> -Classical CAN only mode. The mode is global to both the channels. In order to
> -enable the later, define the following optional property.
> - - renesas,no-can-fd: puts the controller in Classical CAN only mode.
> -
> -Example
> --------
> -
> -SoC common .dtsi file:
> -
> -		canfd: can@e66c0000 {
> -			compatible = "renesas,r8a7795-canfd",
> -				     "renesas,rcar-gen3-canfd";
> -			reg = <0 0xe66c0000 0 0x8000>;
> -			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
> -				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&cpg CPG_MOD 914>,
> -			       <&cpg CPG_CORE R8A7795_CLK_CANFD>,
> -			       <&can_clk>;
> -			clock-names = "fck", "canfd", "can_clk";
> -			assigned-clocks = <&cpg CPG_CORE R8A7795_CLK_CANFD>;
> -			assigned-clock-rates = <40000000>;
> -			power-domains = <&cpg>;
> -			status = "disabled";
> -
> -			channel0 {
> -				status = "disabled";
> -			};
> -
> -			channel1 {
> -				status = "disabled";
> -			};
> -		};
> -
> -Board specific .dts file:
> -
> -E.g. below enables Channel 1 alone in the board in Classical CAN only mode.
> -
> -&canfd {
> -	pinctrl-0 = <&canfd1_pins>;
> -	pinctrl-names = "default";
> -	renesas,no-can-fd;
> -	status = "okay";
> -
> -	channel1 {
> -		status = "okay";
> -	};
> -};
> -
> -E.g. below enables Channel 0 alone in the board using External clock
> -as fCAN clock.
> -
> -&canfd {
> -	pinctrl-0 = <&canfd0_pins>, <&can_clk_pins>;
> -	pinctrl-names = "default";
> -	status = "okay";
> -
> -	channel0 {
> -		status = "okay";
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> new file mode 100644
> index 0000000000000000..0b33ba9ccb47d1ab
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> @@ -0,0 +1,122 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/renesas,rcar-canfd.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas R-Car CAN FD Controller
> +
> +maintainers:
> +  - Fabrizio Castro <fabrizio.castro.jz@renesas.com>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - renesas,r8a774a1-canfd     # RZ/G2M
> +              - renesas,r8a774b1-canfd     # RZ/G2N
> +              - renesas,r8a774c0-canfd     # RZ/G2E
> +              - renesas,r8a774e1-canfd     # RZ/G2H
> +              - renesas,r8a7795-canfd      # R-Car H3
> +              - renesas,r8a7796-canfd      # R-Car M3-W
> +              - renesas,r8a77965-canfd     # R-Car M3-N
> +              - renesas,r8a77970-canfd     # R-Car V3M
> +              - renesas,r8a77980-canfd     # R-Car V3H
> +              - renesas,r8a77990-canfd     # R-Car E3
> +              - renesas,r8a77995-canfd     # R-Car D3
> +          - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    items:
> +      - description: Channel interrupt
> +      - description: Global interrupt
> +
> +  clocks:
> +    maxItems: 3
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +      - const: canfd
> +      - const: can_clk
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  renesas,no-can-fd:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      The controller can operate in either CAN FD only mode (default) or
> +      Classical CAN only mode.  The mode is global to both the channels.
> +      Specify this property to put the controller in Classical CAN only mode.
> +
> +  assigned-clocks:
> +    description:
> +      Reference to the CANFD clock.  The CANFD clock is a div6 clock and can be
> +      used by both CAN (if present) and CAN FD controllers at the same time.
> +      It needs to be scaled to maximum frequency if any of these controllers
> +      use it.
> +
> +  assigned-clock-rates:
> +    description: Maximum frequency of the CANFD clock.
> +
> +patternProperties:
> +  "^channel[01]$":
> +    type: object
> +    description:
> +      The controller supports two channels and each is represented as a child
> +      node.  Each child node supports the "status" property only, which
> +      is used to enable/disable the respective channel.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - power-domains
> +  - resets
> +  - assigned-clocks
> +  - assigned-clock-rates
> +  - channel0
> +  - channel1
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/r8a7795-cpg-mssr.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/power/r8a7795-sysc.h>
> +
> +    canfd: can@e66c0000 {
> +            compatible = "renesas,r8a7795-canfd",
> +                         "renesas,rcar-gen3-canfd";
> +            reg = <0xe66c0000 0x8000>;
> +            interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +            clocks = <&cpg CPG_MOD 914>,
> +                     <&cpg CPG_CORE R8A7795_CLK_CANFD>,
> +                     <&can_clk>;
> +            clock-names = "fck", "canfd", "can_clk";
> +            assigned-clocks = <&cpg CPG_CORE R8A7795_CLK_CANFD>;
> +            assigned-clock-rates = <40000000>;
> +            power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> +            resets = <&cpg 914>;
> +
> +            channel0 {
> +            };
> +
> +            channel1 {
> +            };
> +    };
> -- 
> 2.25.1

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
