Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75A36F225
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhD2Vht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:37:49 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:40459 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhD2Vhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 17:37:47 -0400
Received: by mail-oi1-f172.google.com with SMTP id u16so50678999oiu.7;
        Thu, 29 Apr 2021 14:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=boOMjil7NyRPPxSfGbH8NqLTaQoANhvid5nxhOE8Ll0=;
        b=AAiHEh0UQ3W8srr6chHZEcwkilHhiRSONA/2BRbynmaHhS9kWYAXv7+Wbut6QjGH1w
         moXUZ4GR42ysCgQxP/REF4OClaPHzAPjXyzwHwEsuZBptOpP28ObrwPYoQxPghCY0uAO
         o9id5xh967kfligCSU4ku56Mq6HHhzu41O3v6/x6ufk3UrpNhe7KDPI1xkdP+3t4Ngqp
         VHiM9gb2w/5iTthT7mEuyvFVf3uZ9TAqurOqbfRncJ3lEWPrO/txE+tXyz2my7t2bABT
         REKIEd5Cf9ieJH9l34su8bGrU4XbRdev84VcrSw9bIybiErO9ppwSj9ddUBXKuar+NWB
         n73Q==
X-Gm-Message-State: AOAM533Bjiv0p1ruVfEliICboAZDeI77obbBD1iPORsWhscOxH+Z+SJc
        WE+cJYnrmi3q6Ssfy4S5fA==
X-Google-Smtp-Source: ABdhPJyHYzw16n2HkrM5iDIBUTOhmroKn636bn+qDW8o9FPD2Hgl+PVNy1tQuaXRQfjjRqz/KRRoaw==
X-Received: by 2002:aca:4056:: with SMTP id n83mr8725262oia.47.1619732220318;
        Thu, 29 Apr 2021 14:37:00 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m13sm225077otp.71.2021.04.29.14.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 14:36:59 -0700 (PDT)
Received: (nullmailer pid 1818964 invoked by uid 1000);
        Thu, 29 Apr 2021 21:36:57 -0000
Date:   Thu, 29 Apr 2021 16:36:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Johan Jonker <jbx6244@gmail.com>, kernel@collabora.com
Subject: Re: [PATCH 3/3] dt-bindings: net: convert rockchip-dwmac to
 json-schema
Message-ID: <20210429213657.GA1812381@robh.at.kernel.org>
References: <20210426024118.18717-1-ezequiel@collabora.com>
 <20210426024118.18717-3-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426024118.18717-3-ezequiel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 11:41:18PM -0300, Ezequiel Garcia wrote:
> Convert Rockchip dwmac controller dt-bindings to YAML.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  .../bindings/net/rockchip-dwmac.txt           |  76 -----------
>  .../bindings/net/rockchip-dwmac.yaml          | 120 ++++++++++++++++++
>  2 files changed, 120 insertions(+), 76 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml


> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> new file mode 100644
> index 000000000000..5acddb6171bf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> @@ -0,0 +1,120 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/rockchip-dwmac.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Rockchip 10/100/1000 Ethernet driver(GMAC)
> +
> +maintainers:
> +  - David Wu <david.wu@rock-chips.com>
> +
> +# We need a select here so we don't match all nodes with 'snps,dwmac'

No you don't because there isn't 'snps,dwmac' in the compatible.

> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - rockchip,px30-gmac
> +          - rockchip,rk3128-gmac
> +          - rockchip,rk3228-gmac
> +          - rockchip,rk3288-gmac
> +          - rockchip,rk3328-gmac
> +          - rockchip,rk3366-gmac
> +          - rockchip,rk3368-gmac
> +          - rockchip,rk3399-gmac
> +          - rockchip,rv1108-gmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - rockchip,px30-gmac
> +          - rockchip,rk3128-gmac
> +          - rockchip,rk3228-gmac
> +          - rockchip,rk3288-gmac
> +          - rockchip,rk3328-gmac
> +          - rockchip,rk3366-gmac
> +          - rockchip,rk3368-gmac
> +          - rockchip,rk3399-gmac
> +          - rockchip,rv1108-gmac
> +
> +  clocks:
> +    minItems: 5
> +    maxItems: 8
> +
> +  clock-names:
> +    contains:
> +      enum:
> +        - stmmaceth
> +        - mac_clk_tx
> +        - mac_clk_rx
> +        - aclk_mac
> +        - pclk_mac
> +        - clk_mac_ref
> +        - clk_mac_refout
> +        - clk_mac_speed

This would be an example of one too complex to define any order.

> +
> +  clock_in_out:
> +    description:
> +      For RGMII, it must be "input", means main clock(125MHz)
> +      is not sourced from SoC's PLL, but input from PHY.
> +      For RMII, "input" means PHY provides the reference clock(50MHz),
> +      "output" means GMAC provides the reference clock.
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum: [input, output]
> +
> +  rockchip,grf:
> +    description: The phandle of the syscon node for the general register file.
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +
> +  tx_delay:
> +    description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.

range, default, those are constraints. Make a schema.

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  rx_delay:
> +    description: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  phy-supply:
> +    description: PHY regulator
> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/rk3288-cru.h>
> +
> +    gmac: ethernet@ff290000 {
> +        compatible = "rockchip,rk3288-gmac";
> +        reg = <0xff290000 0x10000>;
> +        interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "macirq";
> +        clocks = <&cru SCLK_MAC>,
> +                 <&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
> +                 <&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
> +                 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
> +        clock-names = "stmmaceth",
> +                      "mac_clk_rx", "mac_clk_tx",
> +                      "clk_mac_ref", "clk_mac_refout",
> +                      "aclk_mac", "pclk_mac";
> +        assigned-clocks = <&cru SCLK_MAC>;
> +        assigned-clock-parents = <&ext_gmac>;
> +
> +        rockchip,grf = <&grf>;
> +        phy-mode = "rgmii";
> +        clock_in_out = "input";
> +        tx_delay = <0x30>;
> +        rx_delay = <0x10>;
> +    };
> -- 
> 2.30.0
> 
