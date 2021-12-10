Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5000470C9C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 22:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbhLJVhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 16:37:35 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:36367 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbhLJVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 16:37:34 -0500
Received: by mail-oi1-f178.google.com with SMTP id t23so15032956oiw.3;
        Fri, 10 Dec 2021 13:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yu5JyXUXQanis8ivLDfcVQmyvi98iaKqWV+OHB7SUkQ=;
        b=KRwUbtqyXLso7qq0gVlfupAy3W0ndx1qXVGhLiuInwmLLSoBCo9ktK2mFeht3+Z5sH
         G7QszZZWdAUKTOAFHJxBs3mjCFHZezrzrA9SoJ/lW4bxIQQsCUAy6ujBLcUTGSLQeo5A
         lOmiMfKybbttxuMcIn+k7OZpvcrpdwoaltzvRHn1I6Kc+M+zqKaV/nNVTgn6yGoSF/mr
         utVuJgNC12o3GWW9ms0nHRjzD3h2ebuvmV66Zi5v2JW4Y+kkYCHiy3bKndaWVOU/nNrS
         zZFmVWErBDjdGolwVIDWJQmpWBEELiSjX8KqTFvjMJKvJCPo9Lx0zjQv89fwZeSinZXd
         RTAQ==
X-Gm-Message-State: AOAM532YlhF3nxrF1fjbKQ8A8XB5ZfTvtyN0JZ5XbTOtL0ZFlOtJdhZc
        /yelqBh/rQobwRObz0zkVA==
X-Google-Smtp-Source: ABdhPJxCGjILyJl6JsMuA7GEPN8mj7e5v19mhIGV1dcUYRZD17czTK6SmVLLrZueWsV51CWRYcYN8A==
X-Received: by 2002:a05:6808:10c9:: with SMTP id s9mr14521327ois.23.1639172038927;
        Fri, 10 Dec 2021 13:33:58 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y28sm516875oix.57.2021.12.10.13.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 13:33:58 -0800 (PST)
Received: (nullmailer pid 1964674 invoked by uid 1000);
        Fri, 10 Dec 2021 21:33:57 -0000
Date:   Fri, 10 Dec 2021 15:33:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, wells.lu@sunplus.com,
        vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v4 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
Message-ID: <YbPHxVf1vXZj9GOC@robh.at.kernel.org>
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
 <1638864419-17501-2-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638864419-17501-2-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 04:06:58PM +0800, Wells Lu wrote:
> Add bindings documentation for Sunplus SP7021.
> 
> Signed-off-by: Wells Lu <wellslutw@gmail.com>
> ---
> Changes in v4
>   - Addressed all comments from Mr. Andrew Lunn.
>     - Moved properties 'nvmem-cells' and 'nvmem-cell-names' to port of ethernet-ports.
>     - Changed value of property 'nvmem-cell-names' to "mac-address".
> 
>  .../bindings/net/sunplus,sp7021-emac.yaml          | 172 +++++++++++++++++++++
>  MAINTAINERS                                        |   7 +
>  2 files changed, 179 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> new file mode 100644
> index 0000000..efc987f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> @@ -0,0 +1,172 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) Sunplus Co., Ltd. 2021
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/sunplus,sp7021-emac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Sunplus SP7021 Dual Ethernet MAC Device Tree Bindings
> +
> +maintainers:
> +  - Wells Lu <wellslutw@gmail.com>
> +
> +description: |
> +  Sunplus SP7021 dual 10M/100M Ethernet MAC controller.
> +  Device node of the controller has following properties.
> +
> +properties:
> +  compatible:
> +    const: sunplus,sp7021-emac
> +
> +  reg:
> +    items:
> +      - description: the EMAC registers
> +      - description: the MOON5 registers
> +
> +  reg-names:
> +    items:
> +      - const: emac
> +      - const: moon5
> +
> +  interrupts:
> +    description: |
> +      Contains number and type of interrupt. Number should be 66.

Drop. That's every 'interrupts' and the exact number is outside the 
scope of the binding.

> +      Type should be high-level trigger.
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  ethernet-ports:
> +    type: object
> +    description: Ethernet ports to PHY
> +
> +    properties:
> +      "#address-cells":
> +        const: 1
> +
> +      "#size-cells":
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-1]$":
> +        type: object
> +        description: Port to PHY
> +
> +        properties:
> +          reg:
> +            minimum: 0
> +            maximum: 1
> +
> +          phy-handle:
> +            maxItems: 1
> +
> +          phy-mode:
> +            maxItems: 1
> +
> +          nvmem-cells:
> +            items:
> +              - description: nvmem cell address of MAC address
> +
> +          nvmem-cell-names:
> +            description: names corresponding to the nvmem cells
> +            items:
> +              - const: mac-address
> +
> +        required:
> +          - reg
> +          - phy-handle
> +          - phy-mode
> +          - nvmem-cells
> +          - nvmem-cell-names
> +
> +  mdio:

Just need:

       $ref: mdio.yaml#
       unevaluatedProperties: false

and drop the rest.

> +    type: object
> +    description: external MDIO Bus
> +
> +    properties:
> +      "#address-cells":
> +        const: 1
> +
> +      "#size-cells":
> +        const: 0
> +
> +    patternProperties:
> +      "^ethernet-phy@[0-9a-f]+$":
> +        type: object
> +        description: external PHY node
> +
> +        properties:
> +          reg:
> +            minimum: 0
> +            maximum: 30
> +
> +        required:
> +          - reg
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - clocks
> +  - resets
> +  - pinctrl-0
> +  - pinctrl-names
> +  - ethernet-ports
> +  - mdio
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    emac: emac@9c108000 {

ethernet@9c108000 {

> +        compatible = "sunplus,sp7021-emac";
> +        reg = <0x9c108000 0x400>, <0x9c000280 0x80>;
> +        reg-names = "emac", "moon5";
> +        interrupt-parent = <&intc>;
> +        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&clkc 0xa7>;
> +        resets = <&rstc 0x97>;
> +        pinctrl-0 = <&emac_demo_board_v3_pins>;
> +        pinctrl-names = "default";
> +
> +        ethernet-ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            port@0 {
> +                reg = <0>;
> +                phy-handle = <&eth_phy0>;
> +                phy-mode = "rmii";
> +                nvmem-cells = <&mac_addr0>;
> +                nvmem-cell-names = "mac-address";
> +            };
> +
> +            port@1 {
> +                reg = <1>;
> +                phy-handle = <&eth_phy1>;
> +                phy-mode = "rmii";
> +                nvmem-cells = <&mac_addr1>;
> +                nvmem-cell-names = "mac-address";
> +            };
> +        };
> +
> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            eth_phy0: ethernet-phy@0 {
> +                reg = <0>;
> +            };
> +
> +            eth_phy1: ethernet-phy@1 {
> +                reg = <1>;
> +            };
> +        };
> +    };
> +...
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0dc08cd..5b1ef9d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18245,6 +18245,13 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/dlink/sundance.c
>  
> +SUNPLUS ETHERNET DRIVER
> +M:	Wells Lu <wellslutw@gmail.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +W:	https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
> +F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> +
>  SUPERH
>  M:	Yoshinori Sato <ysato@users.sourceforge.jp>
>  M:	Rich Felker <dalias@libc.org>
> -- 
> 2.7.4
> 
> 
