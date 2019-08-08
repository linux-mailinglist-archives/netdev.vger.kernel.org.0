Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259DA86D9A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 01:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404810AbfHHXDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 19:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731914AbfHHXDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 19:03:33 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C3921882;
        Thu,  8 Aug 2019 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565305412;
        bh=QRiWcpOmqSG478GZ6dRD3+tP13fLbIjZos1PdD7Y5L4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jLBaHUAViZFbtrocqWEYJAPF9vAtzKL+5lyIgZBkWIUog030rRnlQi97X5WJhkHUt
         OFOvJStvASD4661JQthdAS85ezqsRxB/O42H55s7bpuqz2cLLHbTmxEzPhhKY5WdBK
         LL9orqnKTDrfq7sJadOwOAIwjw/qiA3FH8Y38LiQ=
Received: by mail-qk1-f182.google.com with SMTP id w190so70249480qkc.6;
        Thu, 08 Aug 2019 16:03:32 -0700 (PDT)
X-Gm-Message-State: APjAAAUdxw5uGMbmZON/tPOG2CjUyhDWthXTFWGyKRwLC2zVcHw+FnLr
        iEygwMuNPcqzwVHapVV8/LgIqeYJFCuP27BKJQ==
X-Google-Smtp-Source: APXvYqzYXzfAJhXKOkku9dmFfozi4Ar6VsA5bWi/9Kt+tWJnLEPC7bk/B5cZWZWAZ+rF3sSMan2C01cu5QJg5ONoRb0=
X-Received: by 2002:a37:a44a:: with SMTP id n71mr15405204qke.393.1565305411726;
 Thu, 08 Aug 2019 16:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190808123026.17382-1-alexandru.ardelean@analog.com> <20190808123026.17382-16-alexandru.ardelean@analog.com>
In-Reply-To: <20190808123026.17382-16-alexandru.ardelean@analog.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 8 Aug 2019 17:03:20 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+zH9cL5-8aDARzPar+xoD71WbESTckGjzaUTodu-+Trg@mail.gmail.com>
Message-ID: <CAL_Jsq+zH9cL5-8aDARzPar+xoD71WbESTckGjzaUTodu-+Trg@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] dt-bindings: net: add bindings for ADIN PHY driver
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

On Thu, Aug 8, 2019 at 6:31 AM Alexandru Ardelean
<alexandru.ardelean@analog.com> wrote:
>
> This change adds bindings for the Analog Devices ADIN PHY driver, detailing
> all the properties implemented by the driver.
>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin.yaml     | 76 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> new file mode 100644
> index 000000000000..86177c8fe23a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -0,0 +1,76 @@
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
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  adi,rx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
> +    enum: [ 1600, 1800, 2000, 2200, 2400 ]
> +    default: 2000

This doesn't actually do what you think. The '$ref' has to be under an
'allOf' to work. It's an oddity of json-schema. However, anything with
a standard unit suffix already has a schema to define the type, so you
don't need to here and can just drop $ref.

> +
> +  adi,tx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
> +    enum: [ 1600, 1800, 2000, 2200, 2400 ]
> +    default: 2000
> +
> +  adi,fifo-depth-bits:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      When operating in RMII mode, this option configures the FIFO depth.
> +    enum: [ 4, 8, 12, 16, 20, 24 ]
> +    default: 8
> +
> +  adi,disable-energy-detect:
> +    description: |
> +      Disables Energy Detect Powerdown Mode (default disabled, i.e energy detect
> +      is enabled if this property is unspecified)
> +    type: boolean
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        phy-mode = "rgmii-id";
> +
> +        ethernet-phy@0 {
> +            reg = <0>;
> +
> +            adi,rx-internal-delay-ps = <1800>;
> +            adi,tx-internal-delay-ps = <2200>;
> +        };
> +    };
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        phy-mode = "rmii";
> +
> +        ethernet-phy@1 {
> +            reg = <1>;
> +
> +            adi,fifo-depth-bits = <16>;
> +            adi,disable-energy-detect;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e8aa8a667864..fd9ab61c2670 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -944,6 +944,7 @@ L:  netdev@vger.kernel.org
>  W:     http://ez.analog.com/community/linux-device-drivers
>  S:     Supported
>  F:     drivers/net/phy/adin.c
> +F:     Documentation/devicetree/bindings/net/adi,adin.yaml
>
>  ANALOG DEVICES INC ADIS DRIVER LIBRARY
>  M:     Alexandru Ardelean <alexandru.ardelean@analog.com>
> --
> 2.20.1
>
