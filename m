Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9092579CE2
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfG2Xhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfG2Xhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:37:33 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10DF217F4;
        Mon, 29 Jul 2019 23:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564443451;
        bh=1qfSx+UsNMVlps6cSiR+Fnt7FDGRR1/iLTnDFyMcZUA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jY/kR7aYsvzGjePWSBWU1HZSgQVZSTJVa4kURbXxRC1hxgI3BhwGrz3TiOP7HyC02
         S3ZHlRUVebzVtesX/QoafRNxvkEDsc1dM5fWhNKSHAuy5nWFYqawNMUJgp6u15rAK3
         xl+4fDVdmCoNFixRMYwVv3JNUm+KgH/DHzxkzG+A=
Received: by mail-qk1-f171.google.com with SMTP id m14so19613501qka.10;
        Mon, 29 Jul 2019 16:37:31 -0700 (PDT)
X-Gm-Message-State: APjAAAWlBs+ClWyWxPqwiAJH8OZi1186lplF8nLh0SbWZ/LMKl9AjGgp
        tUYzUxmnXAPEJSdbXNf59k7kemtWKJtMvjkJXg==
X-Google-Smtp-Source: APXvYqx10EVolBe1nZc74TUTVuzkzQVea8UaThML/DaB+Laxs522U+FPo5bibjFkeIeUlaR3zWKjRDi9Ct5/EhcD1OM=
X-Received: by 2002:a37:6944:: with SMTP id e65mr68650213qkc.119.1564443450862;
 Mon, 29 Jul 2019 16:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190729043926.32679-1-andrew@aj.id.au> <20190729043926.32679-2-andrew@aj.id.au>
In-Reply-To: <20190729043926.32679-2-andrew@aj.id.au>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 29 Jul 2019 17:37:19 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLytwfsoyS6TSnpPgTjRTOR0TeQwroX21AHqj3A1mPJ5Q@mail.gmail.com>
Message-ID: <CAL_JsqLytwfsoyS6TSnpPgTjRTOR0TeQwroX21AHqj3A1mPJ5Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: net: Add aspeed,ast2600-mdio binding
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Joel Stanley <joel@jms.id.au>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 10:39 PM Andrew Jeffery <andrew@aj.id.au> wrote:
>
> The AST2600 splits out the MDIO bus controller from the MAC into its own
> IP block and rearranges the register layout. Add a new binding to
> describe the new hardware.
>
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> ---
>  .../bindings/net/aspeed,ast2600-mdio.yaml     | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> new file mode 100644
> index 000000000000..fa86f6438473
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/aspeed,ast2600-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ASPEED AST2600 MDIO Controller
> +
> +maintainers:
> +  - Andrew Jeffery <andrew@aj.id.au>
> +
> +description: |+
> +  The ASPEED AST2600 MDIO controller is the third iteration of ASPEED's MDIO
> +  bus register interface, this time also separating out the controller from the
> +  MAC.
> +

Should have a:

allOf:
  - $ref: "mdio.yaml#"

> +properties:
> +  compatible:
> +    const: aspeed,ast2600-mdio
> +  reg:
> +    maxItems: 1
> +    description: The register range of the MDIO controller instance

> +  "#address-cells":
> +    const: 1
> +  "#size-cells":
> +    const: 0

Then you can drop these 2.

> +
> +patternProperties:
> +  "^ethernet-phy@[a-f0-9]$":
> +    properties:
> +      reg:
> +        description:
> +          The MDIO bus index of the PHY

And this.

> +      compatible:
> +        enum:
> +          - ethernet-phy-ieee802.3-c22
> +          - ethernet-phy-ieee802.3-c45

This isn't specific to ASpeed either and is already covered by
ethernet-phy.yaml.

So that means none of the child node schema is needed here.

> +    required:
> +      - reg
> +
> +required:
> +  - compatible
> +  - reg
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    mdio0: mdio@1e650000 {
> +            compatible = "aspeed,ast2600-mdio";
> +            reg = <0x1e650000 0x8>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            status = "okay";

Don't show status in examples.

> +
> +            ethphy0: ethernet-phy@0 {
> +                    compatible = "ethernet-phy-ieee802.3-c22";
> +                    reg = <0>;
> +            };
> +    };
> --
> 2.20.1
>
