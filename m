Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CE3698BE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhDWR65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:58:57 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:34437 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhDWR6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:58:55 -0400
Received: by mail-ot1-f48.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so46010978otn.1;
        Fri, 23 Apr 2021 10:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4aci9N8Ge0QjDAS/mJvl8Fe/7qt/Qhc8QTVGcATfEqk=;
        b=uVFnP4H7uGi+vWDjBQZW5JKHa45GaxcX3aCpcoltv76dLtjr23yd8v0n20EGbOPadX
         IoL+czB6yiOXVV5U8RFJTqMKzu9oT/4yfKpTQPQV1eqssbg0lJ6PWqIv3mtOoit3A+lb
         AL8acVkyuRi2TZvZ3roRL8LLfz1k+50UWLSZlhJIhCNbJVxGQ0q3Of5WAoRFXISTJRfZ
         2ooqRTpysz0zbfHg6BYqWYzqtfuW9Zz5J5euHfEUyOYgmnM2KQahANvPoJH6RNKn4OGa
         76ci4779A7fJYCmuvhLxTUJ7Oe5DgvXpS0yXx1tKXCaDCiAy8YX6XNLldZ9ekNOsHeN7
         ItHw==
X-Gm-Message-State: AOAM5323HKNzi5B8uDcicQNOO4Ulu8ftlsCu6epsebpy2Wa7WFiDFrht
        Ho9YT5J+w7o2umTwuuc1fg==
X-Google-Smtp-Source: ABdhPJwGlPGXFac7obioUMhI2eKiG1eoOtQY8QFtFfiWTOAW8tV34BnJOzEKa8OdLJSdzLfsHojKYA==
X-Received: by 2002:a05:6830:120a:: with SMTP id r10mr4430301otp.47.1619200698667;
        Fri, 23 Apr 2021 10:58:18 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o64sm1357310oif.50.2021.04.23.10.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 10:58:18 -0700 (PDT)
Received: (nullmailer pid 1338644 invoked by uid 1000);
        Fri, 23 Apr 2021 17:58:16 -0000
Date:   Fri, 23 Apr 2021 12:58:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3 net-next v3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <20210423175816.GA1332201@robh.at.kernel.org>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423082208.2244803-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 10:22:06AM +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx ethernet
> controller with optional MDIO bridge.
> 
> Cc: Zoltan HERPAI <wigyori@uid0.hu>
> Cc: Raylynn Knight <rayknight@me.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Designate phy nodes with ethernet-phy@
> - Include phy-mode in the schema
> ChangeLog v1->v2:
> - Add schema for the (optional) embedded MDIO bus inside
>   the ethernet controller in an "mdio" node instead of just
>   letting the code randomly populate and present it to
>   the operating system.
> - Reference the standard schemas for ethernet controller and
>   MDIO buses.
> - Add intel,npe to indentify the NPE unit used with each
>   ethernet adapter.
> ---
>  .../bindings/net/intel,ixp4xx-ethernet.yaml   | 82 +++++++++++++++++++
>  1 file changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> new file mode 100644
> index 000000000000..978e7f236f3a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> @@ -0,0 +1,82 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2018 Linaro Ltd.
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/intel,ixp4xx-ethernet.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Intel IXP4xx ethernet
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>
> +
> +description: |
> +  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
> +  Processing Engine) and the IXP4xx Queue Mangager to process

typo

> +  the ethernet frames. It can optionally contain an MDIO bus to
> +  talk to PHYs.
> +
> +properties:
> +  compatible:
> +    const: intel,ixp4xx-ethernet
> +
> +  reg:
> +    maxItems: 1
> +    description: Ethernet MMIO address range
> +
> +  queue-rx:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the RX queue on the NPE
> +
> +  queue-txready:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the TX READY queue on the NPE
> +
> +  phy-mode: true
> +
> +  phy-handle: true
> +
> +  intel,npe:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3]
> +    description: which NPE (Network Processing Engine) this ethernet
> +      instance is using

Is there a node for the NPE? If so, make this a phandle.

> +
> +  mdio:
> +    type: object
> +    $ref: "mdio.yaml#"
> +    description: optional node for embedded MDIO controller
> +
> +required:
> +  - compatible
> +  - reg
> +  - queue-rx
> +  - queue-txready
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    ethernet@c8009000 {
> +      compatible = "intel,ixp4xx-ethernet";
> +      reg = <0xc8009000 0x1000>;
> +      status = "disabled";
> +      queue-rx = <&qmgr 3>;
> +      queue-txready = <&qmgr 20>;
> +      intel,npe = <1>;
> +      phy-mode = "rgmii";
> +      phy-handle = <&phy1>;
> +
> +      mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy1: ethernet-phy@1 {
> +          reg = <1>;
> +        };
> +      };
> +    };
> -- 
> 2.29.2
> 
