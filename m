Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFDF27DBC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfEWNKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWNKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 09:10:36 -0400
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BDF2177E;
        Thu, 23 May 2019 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558617034;
        bh=yQOVQ566valsneVZyfgxXzv5YskSU7oQ6frVUOTuLE8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SQcFF6xa+m+WmHonfCGlasiFEctiMUOgqwEG/bPx1+eY4r7XXVkjEs/TPZlK4vAFz
         FHo+RLzqssceYCHDlBxTpEDGLWW+4h5fLYBwdKdxfnhPEZrSJcL/75h9VgIa0XNkPH
         uUzsE7yOGb9i4ppDRjP9NQbuoQqSZ14srZ/c4tJ8=
Received: by mail-qk1-f178.google.com with SMTP id o2so3419012qkb.3;
        Thu, 23 May 2019 06:10:34 -0700 (PDT)
X-Gm-Message-State: APjAAAXC8Q5vyftiia3/UGREy35YG1Uy77cJI4N4xZslXgzlIjDy8xsQ
        p80I555214s2VjsHow/Tz6UesyPwTk6YDPxfIA==
X-Google-Smtp-Source: APXvYqxNxuVlO743jHXGktt6IjmNrBbsGGHuvjRcmD+UnvjpCrfPxZBN2tIYxZlFWkTlzS8cI9C3yfYgtn5h7GlUA1U=
X-Received: by 2002:ae9:c208:: with SMTP id j8mr1893282qkg.264.1558617033788;
 Thu, 23 May 2019 06:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 23 May 2019 08:10:22 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
Message-ID: <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
Subject: Re: [PATCH 1/8] dt-bindings: net: Add YAML schemas for the generic
 Ethernet options
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
> The Ethernet controllers have a good number of generic options that can be
> needed in a device tree. Add a YAML schemas for those.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 197 +++++++-
>  Documentation/devicetree/bindings/net/ethernet.txt             |  68 +--
>  Documentation/devicetree/bindings/net/fixed-link.txt           |  55 +--
>  3 files changed, 199 insertions(+), 121 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-controller.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> new file mode 100644
> index 000000000000..1c6e9e755481
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -0,0 +1,197 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-controller.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet Controller Generic Binding
> +
> +maintainers:
> +  - David S. Miller <davem@davemloft.net>
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet(@.*)?$"
> +
> +  local-mac-address:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - minItems: 6
> +        maxItems: 6
> +    description:
> +      Specifies the MAC address that was assigned to the network device.
> +
> +  mac-address:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - minItems: 6
> +        maxItems: 6
> +    description:
> +      Specifies the MAC address that was last used by the boot
> +      program; should be used in cases where the MAC address assigned
> +      to the device by the boot program is different from the
> +      local-mac-address property.
> +
> +  max-frame-size:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Maximum transfer unit (IEEE defined MTU), rather than the
> +      maximum frame size (there\'s contradiction in the Devicetree
> +      Specification).
> +
> +  max-speed:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      Specifies maximum speed in Mbit/s supported by the device.
> +
> +  nvmem-cells:
> +    maxItems: 1
> +    description:
> +      Reference to an nvmem node for the MAC address
> +
> +  nvmem-cells-names:
> +    const: mac-address
> +
> +  phy-connection-type:
> +    description:
> +      Operation mode of the PHY interface
> +    oneOf:

While yes, this lets us have descriptions, oneOf makes for poor error
messages. I'd just make the descriptions comments instead.

> +      - const: internal
> +        description:
> +          there is not a standard bus between the MAC and the PHY,
> +          something proprietary is being used to embed the PHY in the
> +          MAC.
> +      - const: mii
> +      - const: gmii
> +      - const: sgmii
> +      - const: qsgmii
> +      - const: tbi
> +      - const: rev-mii
> +      - const: rmii
> +      - const: rgmii
> +        description:
> +          RX and TX delays are added by the MAC when required
> +      - const: rgmii-id
> +        description:
> +          RGMII with internal RX and TX delays provided by the PHY,
> +          the MAC should not add the RX or TX delays in this case
> +      - const: rgmii-rxid
> +        description:
> +          RGMII with internal RX delay provided by the PHY, the MAC
> +          should not add an RX delay in this case
> +      - const: rgmii-txid
> +        description:
> +          RGMII with internal TX delay provided by the PHY, the MAC
> +          should not add an TX delay in this case
> +      - const: rtbi
> +      - const: smii
> +      - const: xgmii
> +      - const: trgmii
> +      - const: 1000base-x
> +      - const: 2500base-x
> +      - const: rxaui
> +      - const: xaui
> +      - const: 10gbase-kr
> +        description:
> +          10GBASE-KR, XFI, SFI
> +
> +  phy-mode:
> +    $ref: "#/properties/phy-connection-type"
> +    description:
> +      Deprecated in favor of phy-connection-type
> +
> +  phy-handle:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Specifies a reference to a node representing a PHY device.
> +
> +  phy:
> +    $ref: "#/properties/phy-handle"
> +    description:
> +      Deprecated in favor of phy-handle
> +
> +  phy-device:
> +    $ref: "#/properties/phy-handle"
> +    description:
> +      Deprecated in favor of phy-handle
> +
> +  rx-fifo-depth:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      The size of the controller\'s receive fifo in bytes. This is used
> +      for components that can have configurable receive fifo sizes,
> +      and is useful for determining certain configuration settings
> +      such as flow control thresholds.
> +
> +  tx-fifo-depth:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description:
> +      The size of the controller\'s transmit fifo in bytes. This
> +      is used for components that can have configurable fifo sizes.
> +
> +  managed:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/string
> +      - default: auto
> +        enum:
> +          - auto
> +          - in-band-status
> +    description:
> +      Specifies the PHY management type. If auto is set and fixed-link
> +      is not specified, it uses MDIO for management.
> +
> +  fixed-link:
> +    allOf:
> +      - if:
> +          type: array
> +        then:
> +          minItems: 1
> +          maxItems: 1
> +          items:
> +            type: array
> +            minItems: 5
> +            maxItems: 5
> +          description:
> +            An array of 5 cells, with the following accepted values
> +              - At index 0, the emulated PHY ID, choose any but but
> +                unique to the all specified fixed-links, from 0 to 31
> +              - at index 1, duplex configuration with 0 for half duplex
> +                or 1 for full duplex
> +              - at index 2, link speed in Mbits/sec, accepted values are
> +                10, 100 and 1000
> +              - at index 3, pause configuration with 0 for no pause, 1
> +                for pause
> +              - at index 4, asymmetric pause configuration with 0 for no
> +                asymmetric pause, 1 for asymmetric pause

Looks like constraints to me:

items:
  - minimum: 0
    maximum: 31
  - enum: [ 0, 1 ]
  - enum: [ 10, 100, 1000 ]
...

> +
> +
> +      - if:

Couldn't this be an 'else' and avoid the allOf?

> +          type: object
> +        then:
> +          properties:
> +            speed:
> +              allOf:
> +                - $ref: /schemas/types.yaml#definitions/uint32
> +                - enum: [10, 100, 1000]
> +              description:
> +                Link speed.
> +
> +            full-duplex:
> +              $ref: /schemas/types.yaml#definitions/flag
> +              description:
> +                Indicates that full-duplex is used. When absent, half
> +                duplex is assumed.
> +
> +            asym-pause:
> +              $ref: /schemas/types.yaml#definitions/flag
> +              description:
> +                Indicates that asym_pause should be enabled.
> +
> +            link-gpios:
> +              description:
> +                GPIO to determine if the link is up

Only 1?

> +
> +          required:
> +            - speed
> +
> +...
