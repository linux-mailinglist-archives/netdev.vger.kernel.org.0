Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7082C3F5090
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhHWSoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:44:54 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:40495 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhHWSow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 14:44:52 -0400
Received: by mail-ot1-f47.google.com with SMTP id x9-20020a056830278900b0051b8be1192fso18235385otu.7;
        Mon, 23 Aug 2021 11:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kdAQTBVBdpO3tKzp/N2wLGvECx2POADKDdUfZBY9y4U=;
        b=eM965Yf6NIYc5SEkC+/+gDAUB0nhOnUDbrNb81A6A+R49acNOVTcmeTfUJDZChRSPF
         hLY9iaKJaQgyhne1yvOm93FXWkTFiDrN3XN2oWyazzOK7dOw+sik6eswbOovti1gZRVC
         aLkZdneJ1rtMpU9aSPN5IL88/2U5R5UVeskNg+h9NM+H6/tQWH/uenbbofVkyX1iZDC9
         3YlGUV3tJNnimw4dpQA0ylnAb5POUkyLHpvRq8EUHW0XeIPPpPqu3fqO97tUa0zTnHN0
         x6GOPCzcWAUJDomBTg3RuOBjUm2AjlfsfOtqxnVmuVz2Ov2mTsgS8joZyYK9WEHPr+Rl
         UQtg==
X-Gm-Message-State: AOAM533/Qw8O0LggqPR6vD4lkZmFoWRBRA2/H7ppZbpv1PXpTv9oihXy
        9AlleSlUjhckf3xgDINK+w==
X-Google-Smtp-Source: ABdhPJzZjR+Nj4QG2ogBy2F/h0usSwcnHjOq8GIRulKwQlUZzmGAcvWhHmwS0xgGWgh2ZYyIKkX38g==
X-Received: by 2002:a05:6808:1522:: with SMTP id u34mr4330332oiw.76.1629744249675;
        Mon, 23 Aug 2021 11:44:09 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j17sm3976492ots.10.2021.08.23.11.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 11:44:09 -0700 (PDT)
Received: (nullmailer pid 2499843 invoked by uid 1000);
        Mon, 23 Aug 2021 18:44:08 -0000
Date:   Mon, 23 Aug 2021 13:44:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
Message-ID: <YSPseMd1nDHnF/Db@robh.at.kernel.org>
References: <20210820074726.2860425-1-joel@jms.id.au>
 <20210820074726.2860425-2-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820074726.2860425-2-joel@jms.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 05:17:25PM +0930, Joel Stanley wrote:
> LiteETH is a small footprint and configurable Ethernet core for FPGA
> based system on chips.
> 
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2:
>  - Fix dtschema check warning relating to registers
>  - Add names to the registers to make it easier to distinguish which is
>    what region
>  - Add mdio description
>  - Includ ethernet-controller parent description
> 
>  .../bindings/net/litex,liteeth.yaml           | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> new file mode 100644
> index 000000000000..30f8f8b0b657
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> @@ -0,0 +1,79 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/litex,liteeth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LiteX LiteETH ethernet device
> +
> +maintainers:
> +  - Joel Stanley <joel@jms.id.au>
> +
> +description: |
> +  LiteETH is a small footprint and configurable Ethernet core for FPGA based
> +  system on chips.
> +
> +  The hardware source is Open Source and can be found on at
> +  https://github.com/enjoy-digital/liteeth/.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: litex,liteeth
> +
> +  reg:
> +    minItems: 3
> +    items:
> +      - description: MAC registers
> +      - description: MDIO registers
> +      - description: Packet buffer
> +
> +  reg-names:
> +    minItems: 3

Need to define the names here.

> +
> +  interrupts:
> +    maxItems: 1
> +

> +  rx-fifo-depth: true
> +  tx-fifo-depth: true

Needs a vendor prefix, type, description and constraints.

> +  mac-address: true
> +  local-mac-address: true
> +  phy-handle: true
> +
> +  mdio:
> +    $ref: mdio.yaml#
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
> +    mac: ethernet@8020000 {
> +        compatible = "litex,liteeth";
> +        reg = <0x8021000 0x100>,
> +              <0x8020800 0x100>,
> +              <0x8030000 0x2000>;
> +        reg-names = "mac", "mdio", "buffer";
> +        rx-fifo-depth = <1024>;
> +        tx-fifo-depth = <1024>;
> +        interrupts = <0x11 0x1>;
> +        phy-handle = <&eth_phy>;
> +
> +        mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          eth_phy: ethernet-phy@0 {
> +            reg = <0>;
> +          };
> +        };
> +    };
> +...
> +
> +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
> -- 
> 2.32.0
> 
> 
