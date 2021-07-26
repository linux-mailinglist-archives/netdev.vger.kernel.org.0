Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72933D6A4D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhGZWzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhGZWzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 18:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F23A60F57;
        Mon, 26 Jul 2021 23:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627342538;
        bh=BhSzlHOBklx3QMM+H8naJ7vMpheLxh6tdksvcXd60Sg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W/f6/n1MeUWg4xE6OpiHdnXJtenhbNPXZHGdjLYMVIULq+tkzzYnnzn7PADWI+0fE
         kCAKLOE0zJ40SziWTjs4GcZ11walmYYcVWBs4nLybNK5o+PWV9LQISH+mHqJ77Djj5
         xXbIfyZ4g1/ePm5u46Yr+kkTckOz/9M5nv2Hatdi2ceqZPxITZztH9wEAD9+fuDjdV
         ZWtb+ezIDZTXNoFCOy2keHUe5zklfDYLa6AKy7IBV4GOGISXZUquLqZUbMPyfggTWq
         SGeWxQQlcuKsuZPOMkLTnQRrh7l5pkEscqnCN1N5jCCfR6eqTaEjXAG8J085+6Z0pA
         p3pC1KNgY3Ftg==
Received: by mail-qt1-f171.google.com with SMTP id t18so8285691qta.8;
        Mon, 26 Jul 2021 16:35:38 -0700 (PDT)
X-Gm-Message-State: AOAM531nAmxWfiJriY7EiX/bSJSMz0zcUbrl6r/uA7Pe84xPekYXEZCg
        /31DiQp4x9fsLJ1U1WYW8NF2qGqQ7ktIz4h8ag==
X-Google-Smtp-Source: ABdhPJwnO8H1hogKZ7pQCzmG31mxXbN8hoFu0rEe75obmvygOnK399k2WaICitmzfrT8LqZlRmIzeHPfSIkdF6bXupE=
X-Received: by 2002:ac8:58d3:: with SMTP id u19mr17416002qta.306.1627342537300;
 Mon, 26 Jul 2021 16:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com> <20210726194603.14671-3-gerhard@engleder-embedded.com>
In-Reply-To: <20210726194603.14671-3-gerhard@engleder-embedded.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 26 Jul 2021 17:35:26 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
Message-ID: <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 1:46 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
>
> It is integrated as normal Ethernet controller with
> ethernet-controller.yaml and ethernet-phy.yaml.
>
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  .../bindings/net/engleder,tsnep.yaml          | 77 +++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> new file mode 100644
> index 000000000000..ef2ca45d36a0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> @@ -0,0 +1,77 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/engleder,tsnep.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: TSN endpoint Ethernet MAC binding
> +
> +maintainers:
> +  - Gerhard Engleder <gerhard@engleder-embedded.com>
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:

Don't need oneOf when there is only one entry.

> +      - enum:
> +        - engleder,tsnep

tsnep is pretty generic. Only 1 version ever? Or differences are/will
be discoverable by other means.

> +
> +  reg: true

How many? And what is each entry if more than 1.

> +  interrupts: true

How many?

> +
> +  local-mac-address: true
> +  mac-address: true
> +  nvmem-cells: true

How many?

> +  nvmem-cells-names: true

Need to define the names.

> +
> +  phy-connection-type: true
> +  phy-mode: true

All the modes the generic binding support are supported by this device?

> +
> +  phy-handle: true
> +
> +  '#address-cells':
> +    description: Number of address cells for the MDIO bus.

No need to re-describe common properties unless you have something
special to say.

Anyway, put an MDIO bus under an 'mdio' node.

> +    const: 1
> +
> +  '#size-cells':
> +    description: Number of size cells on the MDIO bus.
> +    const: 0
> +
> +patternProperties:
> +  "^ethernet-phy@[0-9a-f]$":
> +    type: object
> +    $ref: ethernet-phy.yaml#

Referencing mdio.yaml will do all this.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phy-mode
> +  - phy-handle
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    axi {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +        tnsep0: ethernet@a0000000 {
> +            compatible = "engleder,tsnep";
> +            reg = <0x0 0xa0000000 0x0 0x10000>;
> +            interrupts = <0 89 1>;
> +            interrupt-parent = <&gic>;
> +            local-mac-address = [00 00 00 00 00 00];
> +            phy-mode = "rgmii";
> +            phy-handle = <&phy0>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            phy0: ethernet-phy@1 {
> +                reg = <1>;
> +            };
> +        };
> +    };
> --
> 2.20.1
>
