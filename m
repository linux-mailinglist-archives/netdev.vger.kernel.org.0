Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29B929F37
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbfEXTlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfEXTlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 15:41:51 -0400
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36732184E;
        Fri, 24 May 2019 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558726909;
        bh=CkGzYYO+vGgbv0d+nRAEF3GYLYvk85XbDtSLeEjkPq4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wJ2EFxVFh2WeG6rUfgp6P/V3ObUJVG290SC5oaznWPy/Ay1wlCEXjZdD/HBD4uAv7
         2Lw0EPluNUS3LjELueSW6G41HIGvz7obiqUTCCCW4cbKBUGxjHt97L1OM1LciQWqin
         IUaKG2tThRXdDXZ3Tqk6jv4dNm0vSciLeKZZQ/oU=
Received: by mail-qk1-f173.google.com with SMTP id p26so6660365qkj.5;
        Fri, 24 May 2019 12:41:49 -0700 (PDT)
X-Gm-Message-State: APjAAAXrl1ZEnarCX7K7yKGCwb5ezDflgbmxYtkZ2VWsg2DriqPP7phC
        BHoLXpD1gL8l/Dca1Q3egDrke3tCuYevk/2SdA==
X-Google-Smtp-Source: APXvYqw9CzhKv4gwvm0e+yC8SQI5HZrcGpsWEfdqVf/JQYaDYeEHbOhQseeOXnlPKf/EjH1EIdSLrtfahMdHnv9GdQQ=
X-Received: by 2002:ac8:7688:: with SMTP id g8mr59817341qtr.224.1558726908834;
 Fri, 24 May 2019 12:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162229.9185-1-linus.walleij@linaro.org>
In-Reply-To: <20190524162229.9185-1-linus.walleij@linaro.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 24 May 2019 14:41:36 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+bZsJ+SBiJa2hzXU9RkTNBhDk_Uv_Fk6V6DqRGh-xPRg@mail.gmail.com>
Message-ID: <CAL_Jsq+bZsJ+SBiJa2hzXU9RkTNBhDk_Uv_Fk6V6DqRGh-xPRg@mail.gmail.com>
Subject: Re: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 11:22 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> This adds device tree bindings for the IXP4xx ethernet.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  .../bindings/net/intel,ixp4xx-ethernet.yaml   | 53 +++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> new file mode 100644
> index 000000000000..4575a7e5aa4a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2018 Linaro Ltd.
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/intel-ixp4xx-ethernet.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Intel IXP4xx ethernet
> +
> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>
> +
> +description: |
> +  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
> +  Processing Engine) and the IXP4xx Queue Mangager to process
> +  the ethernet frames. It can optionally contain an MDIO bus to
> +  talk to PHYs.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +        - const: intel,ixp4xx-ethernet

You can drop the oneOf and items.

> +
> +  reg:
> +    maxItems: 1
> +    description: Ethernet MMIO address range
> +
> +  queue-rx:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1

This doesn't actually do what you think it is doing. A $ref plus
additional constraints need to be under an 'allOf' list.

> +    description: phandle to the RX queue on the NPE

But this is a phandle plus 1 cell, right?

- allOf:
    - $ref: '/schemas/types.yaml#/definitions/phandle-array'
    - items:
        - items:
            - description: phandle to the RX queue on the NPE
            - description: whatever the cell contains
              enum: [ 1, 2, 3, 4 ] # any constraints you can put on the cell

This implicitly says you have 1 of a phandle + 1 cell.

I need to add this to example-schema.yaml...

> +
> +  queue-txready:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the TX READY queue on the NPE
> +
> +required:
> +  - compatible
> +  - reg
> +  - queue-rx
> +  - queue-txready
> +
> +examples:
> +  - |
> +    ethernet@c8009000 {
> +        compatible = "intel,ixp4xx-ethernet";
> +        reg = <0xc8009000 0x1000>;
> +        status = "disabled";

Don't show status in examples.

> +        queue-rx = <&qmgr 3>;
> +        queue-txready = <&qmgr 20>;
> +    };
> --
> 2.20.1
>
