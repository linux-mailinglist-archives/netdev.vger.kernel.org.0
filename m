Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829CA834AB
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbfHFPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbfHFPEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 11:04:40 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0C6214C6;
        Tue,  6 Aug 2019 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565103879;
        bh=aHlPSqURteCXq5aYR8ys59YNHgq+nw0ciN5A0T1mxbY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gEiwiE8OR3R557dGDdB0bDDJhV6LeLrNE87FFCWOyleTcLiW/rNmH+hpkOWL4Z814
         oQ5oFA2Yn/U7mIc2G9BKvWwJe+SuVTSrU8XL0el+l1YMGfulESJEaRA/PTZi6/TkRa
         +URb5nt8LV7QjLUVi54BokEySoyUeGkIJZXH77Ys=
Received: by mail-qt1-f176.google.com with SMTP id a15so84807757qtn.7;
        Tue, 06 Aug 2019 08:04:39 -0700 (PDT)
X-Gm-Message-State: APjAAAVKGeCzEIdD2zzA/9eb1C7yVxUCjJ3WfuRSUSa2SkF+CdqGZ7pb
        N4xOgVueQTYCCRj+WJwRTX+O6ClOeE+cnUoI7Q==
X-Google-Smtp-Source: APXvYqyT3ZFfpt3T2iSOcqP/jyt5Mm7aCcTnVaJPNDb/vLDX7EstGdT3164Dp4sqdhOarC49a1FWiaJKwZLli39Lmlg=
X-Received: by 2002:aed:3fb0:: with SMTP id s45mr3487316qth.136.1565103878256;
 Tue, 06 Aug 2019 08:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190805165453.3989-1-alexandru.ardelean@analog.com> <20190805165453.3989-17-alexandru.ardelean@analog.com>
In-Reply-To: <20190805165453.3989-17-alexandru.ardelean@analog.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 6 Aug 2019 09:04:26 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK6EqpcRj0JVkAQXRryPU1Jq+gA68EHCkFw16j_z95yvw@mail.gmail.com>
Message-ID: <CAL_JsqK6EqpcRj0JVkAQXRryPU1Jq+gA68EHCkFw16j_z95yvw@mail.gmail.com>
Subject: Re: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 7:55 AM Alexandru Ardelean
<alexandru.ardelean@analog.com> wrote:
>
> This change adds bindings for the Analog Devices ADIN PHY driver, detailing
> all the properties implemented by the driver.
>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin.yaml     | 93 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +
>  include/dt-bindings/net/adin.h                | 26 ++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
>  create mode 100644 include/dt-bindings/net/adin.h
>
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> new file mode 100644
> index 000000000000..fcf884bb86f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -0,0 +1,93 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/adi,adin.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Analog Devices ADIN1200/ADIN1300 PHY
> +
> +maintainers:
> +  - Alexandru Ardelean <alexandru.ardelean@analog.com>
> +
> +description: |
> +  Bindings for Analog Devices Industrial Ethernet PHYs
> +

Needs an:

allOf:
  - $ref: ethernet-phy.yaml#

> +properties:
> +  compatible:
> +    description: |
> +      Compatible list, may contain "ethernet-phy-ieee802.3-c45" in which case
> +      Clause 45 will be used to access device management registers. If
> +      unspecified, Clause 22 will be used. Use this only when MDIO supports
> +      Clause 45 access, but there is no other way to determine this.
> +    enum:
> +      - ethernet-phy-ieee802.3-c45

Then you can drop 'compatible' from here as it is covered by the above schema.

> +
> +  adi,phy-mode-internal:
> +    $ref: /schemas/types.yaml#/definitions/string

This has to be under an 'allOf' or it doesn't actually work. Same below.

> +    description: |

No special formatting here, you can drop '|'.

> +      The internal mode of the PHY. This assumes that there is a PHY converter
> +      in-between the MAC & PHY.
> +    enum: [ "rgmii", "rgmii-id", "rgmii-txid", "rgmii-rxid", "rmii", "mii" ]

Don't need quotes here.

> +
> +  adi,rx-internal-delay:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode (phy-mode
> +      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
> +      default value is 0 (which represents 2 ns)

Use 'default: 0' to specify defaults.

> +    enum: [ 0, 1, 2, 6, 7 ]
> +
> +  adi,tx-internal-delay:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode (phy-mode
> +      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
> +      default value is 0 (which represents 2 ns)
> +    enum: [ 0, 1, 2, 6, 7 ]
> +
> +  adi,fifo-depth:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      When operating in RMII mode, this option configures the FIFO depth.
> +      See `dt-bindings/net/adin.h`.
> +    enum: [ 0, 1, 2, 3, 4, 5 ]
> +
> +  adi,eee-enabled:

Isn't there a standard property for EEE control?

> +    description: |
> +      Advertise EEE capabilities on power-up/init (default disabled)
> +    type: boolean
> +
> +  adi,disable-energy-detect:
> +    description: |
> +      Disables Energy Detect Powerdown Mode (default disabled, i.e energy detect
> +      is enabled if this property is unspecified)
> +    type: boolean
> +
> +  reset-gpios:
> +    description: |
> +      GPIO to reset the PHY
> +      see Documentation/devicetree/bindings/gpio/gpio.txt.

Active high or low?

> +
> +examples:
> +  - |
> +    ethernet-phy@0 {
> +        compatible = "ethernet-phy-ieee802.3-c45";
> +        reg = <0>;
> +    };

Not really anything specific to this binding. Drop it.


> +  - |
> +    #include <dt-bindings/net/adin.h>
> +    ethernet-phy@1 {
> +        reg = <1>;
> +        adi,phy-mode-internal = "rgmii-id";
> +
> +        adi,rx-internal-delay = <ADIN1300_RGMII_1_80_NS>;
> +        adi,tx-internal-delay = <ADIN1300_RGMII_2_20_NS>;
> +    };
> +  - |
> +    #include <dt-bindings/net/adin.h>
> +    ethernet-phy@2 {
> +        reg = <2>;
> +        phy-mode = "rmii";
> +
> +        adi,fifo-depth = <ADIN1300_RMII_16_BITS>;
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index faf5723610c8..6ffbb266dee4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -944,6 +944,8 @@ L:  netdev@vger.kernel.org
>  W:     http://ez.analog.com/community/linux-device-drivers
>  S:     Supported
>  F:     drivers/net/phy/adin.c
> +F:     include/dt-bindings/net/adin.h
> +F:     Documentation/devicetree/bindings/net/adi,adin.yaml
>
>  ANALOG DEVICES INC ADIS DRIVER LIBRARY
>  M:     Alexandru Ardelean <alexandru.ardelean@analog.com>
> diff --git a/include/dt-bindings/net/adin.h b/include/dt-bindings/net/adin.h
> new file mode 100644
> index 000000000000..4c3afa550c59
> --- /dev/null
> +++ b/include/dt-bindings/net/adin.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/**
> + * Device Tree constants for Analog Devices Industrial Ethernet PHYs
> + *
> + * Copyright 2019 Analog Devices Inc.
> + */
> +
> +#ifndef _DT_BINDINGS_ADIN_H
> +#define _DT_BINDINGS_ADIN_H
> +
> +/* RGMII internal delay settings for rx and tx for ADIN1300 */
> +#define ADIN1300_RGMII_1_60_NS         0x1
> +#define ADIN1300_RGMII_1_80_NS         0x2
> +#define        ADIN1300_RGMII_2_00_NS          0x0
> +#define        ADIN1300_RGMII_2_20_NS          0x6
> +#define        ADIN1300_RGMII_2_40_NS          0x7
> +
> +/* RMII fifo depth values */
> +#define ADIN1300_RMII_4_BITS           0x0
> +#define ADIN1300_RMII_8_BITS           0x1
> +#define ADIN1300_RMII_12_BITS          0x2
> +#define ADIN1300_RMII_16_BITS          0x3
> +#define ADIN1300_RMII_20_BITS          0x4
> +#define ADIN1300_RMII_24_BITS          0x5
> +
> +#endif
> --
> 2.20.1
>
