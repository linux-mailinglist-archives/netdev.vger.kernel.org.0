Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5828019
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbfEWOpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbfEWOpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 10:45:05 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C8221851;
        Thu, 23 May 2019 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558622704;
        bh=UJ6x3F7sdFiOx8Qz/M2AGY26AYeMGeaR3viNAzUA7p4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JUBp0myiJ7iWl85P2mfSxSP+8boBDZ0T0Qznd0KYDovFON67XvzlmO5HI2uwS3yGM
         4jCxZsd5xuKN7Fsuc/LcspQVTm4izKpyKkRnHC7yUxgno7WpMQVNP7pdSpN/IpXX5v
         gMITLGxP3+FH+QMPFqgYsHoWszMEnP6mv62g2Vy4=
Received: by mail-qk1-f181.google.com with SMTP id t64so3754563qkh.1;
        Thu, 23 May 2019 07:45:03 -0700 (PDT)
X-Gm-Message-State: APjAAAXCql+sWrZzAcMKzrk9WgzlegTj+EkiRGL39npv552i7mKC6aT6
        PJ7re9oyfgvxbQ3vdPfZYQ/gNz4KRhIRNi3xSw==
X-Google-Smtp-Source: APXvYqyW7iDCtnwbv4EZaFOhy7TBsqR2kCrTlF0HdyA4uTDUp13t2mH2O1gAJ3Mc9pvOziiL7skpu0AaShDUQLHjP+s=
X-Received: by 2002:ae9:c208:: with SMTP id j8mr2382677qkg.264.1558622703175;
 Thu, 23 May 2019 07:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 23 May 2019 09:44:51 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJvgUAmON5Vew-mnwkFjNuRkx_f7quiy_7Rv_55JpzOOA@mail.gmail.com>
Message-ID: <CAL_JsqJvgUAmON5Vew-mnwkFjNuRkx_f7quiy_7Rv_55JpzOOA@mail.gmail.com>
Subject: Re: [PATCH 2/8] dt-bindings: net: Add a YAML schemas for the generic
 PHY options
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
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 4:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The networking PHYs have a number of available device tree properties that
> can be used in their device tree node. Add a YAML schemas for those.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 148 +++++++++-
>  Documentation/devicetree/bindings/net/phy.txt           |  80 +-----
>  2 files changed, 149 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> new file mode 100644
> index 000000000000..eb79ee6db977
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -0,0 +1,148 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet PHY Generic Binding
> +
> +maintainers:
> +  - David S. Miller <davem@davemloft.net>
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet-phy(@[a-f0-9])?$"
> +
> +  compatible:
> +    oneOf:
> +      - const: ethernet-phy-ieee802.3-c22
> +        description: PHYs that implement IEEE802.3 clause 22
> +      - const: ethernet-phy-ieee802.3-c45
> +        description: PHYs that implement IEEE802.3 clause 45
> +      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> +        description:
> +          The first group of digits is the 16 bit Phy Identifier 1
> +          register, this is the chip vendor OUI bits 3:18. The
> +          second group of digits is the Phy Identifier 2 register,
> +          this is the chip vendor OUI bits 19:24, followed by 10
> +          bits of a vendor specific ID.
> +
> +  reg:
> +    maxItems: 1
> +    minimum: 0
> +    maximum: 31

min/max need to be under 'items'. I don't think these would ever be
valid if the type is an array.

I've modified the meta-schema to catch this.

> +    description:
> +      The ID number for the PHY.
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  max-speed:
> +    enum:
> +      - 10
> +      - 100
> +      - 1000
> +    description:
> +      Maximum PHY supported speed in Mbits / seconds.
> +
> +  broken-turn-around:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      If set, indicates the PHY device does not correctly release
> +      the turn around line low at the end of a MDIO transaction.
> +
> +  enet-phy-lane-swap:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      If set, indicates the PHY will swap the TX/RX lanes to
> +      compensate for the board being designed with the lanes
> +      swapped.
> +
> +  eee-broken-100tx:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  eee-broken-1000t:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  eee-broken-10gt:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  eee-broken-1000kx:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  eee-broken-10gkx4:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  eee-broken-10gkr:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      Mark the corresponding energy efficient ethernet mode as
> +      broken and request the ethernet to stop advertising it.
> +
> +  phy-is-integrated:
> +    $ref: /schemas/types.yaml#definitions/flag
> +    description:
> +      If set, indicates that the PHY is integrated into the same
> +      physical package as the Ethernet MAC. If needed, muxers
> +      should be configured to ensure the integrated PHY is
> +      used. The absence of this property indicates the muxers
> +      should be configured so that the external PHY is used.
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    const: phy
> +
> +  reset-gpios:
> +    description:
> +      The GPIO phandle and specifier for the PHY reset signal.

maxItems: 1

I have a meta-schema change to catch this, but It will require updates
to some existing cases.


> +
> +  reset-assert-us:
> +    description:
> +      Delay after the reset was asserted in microseconds. If this
> +      property is missing the delay will be skipped.
> +
> +  reset-deassert-us:
> +    description:
> +      Delay after the reset was deasserted in microseconds. If
> +      this property is missing the delay will be skipped.
> +
> +required:
> +  - reg
> +  - interrupts
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet-phy@0 {
> +            compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c22";
> +            interrupt-parent = <&PIC>;
> +            interrupts = <35 1>;
> +            reg = <0>;
> +
> +            resets = <&rst 8>;
> +            reset-names = "phy";
> +            reset-gpios = <&gpio1 4 1>;
> +            reset-assert-us = <1000>;
> +            reset-deassert-us = <2000>;
> +        };
> +    };
