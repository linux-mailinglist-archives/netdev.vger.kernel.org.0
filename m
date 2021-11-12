Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7DD44EDB0
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhKLUIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 15:08:53 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:35551 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbhKLUIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 15:08:53 -0500
Received: by mail-oi1-f180.google.com with SMTP id m6so19995001oim.2;
        Fri, 12 Nov 2021 12:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oyHEoCbMEF48+l8kYeD/pLfiS+xeE7xkfFCLiVLSxpY=;
        b=MroNEcxvDJTa0aI1cOZTmVyyHAZtYLZ1dUc6fmd6TEMT8CrnOvwmjSO6FpaLDqVZYT
         GlOzsQu7MHJ/l9aKzG+3AARywfuOKJ5OYF6qMA1rU5E0P5lxfC1HDubvNEaWGOJNyxFg
         yBZMK8laePmySPNX5UyF1i7PEcVB7PC9jhNKr+qGn8keQKRSnW+aAo2mnLvg/PPD2Ilm
         Via048qhHc+n6zhkQauM6AIMeLOMcnjOgq9A3nQRGUAUuLtHNIBZckFzUdfSMcFH7Tf5
         TFxYwSXCd9hJXDeqAi8NNpZzGBWK385Q9GwzW8CaZAIGBBn56sVFkjz9bs/CSVM+Lu+F
         giQA==
X-Gm-Message-State: AOAM533ErsydfkqdQ0ZJWamiM7MZ0CcH3nS86qs69m8+/3fCuSsKA6Ww
        Hv1FqGTyumBILw4dJT3kONAMJKA+qQ==
X-Google-Smtp-Source: ABdhPJzvD+UXToT8P6L5ufsBvQofzszsfnV4av3vxKZ/ni+7V56LH6TvgJoQI0aSZw5kQw1GJXZipw==
X-Received: by 2002:aca:2408:: with SMTP id n8mr28869169oic.124.1636747561808;
        Fri, 12 Nov 2021 12:06:01 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id ay42sm1668772oib.22.2021.11.12.12.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 12:06:01 -0800 (PST)
Received: (nullmailer pid 3280416 invoked by uid 1000);
        Fri, 12 Nov 2021 20:06:00 -0000
Date:   Fri, 12 Nov 2021 14:06:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 2/6] dt-bindings: net: convert mscc,vsc7514-switch
 bindings to yaml
Message-ID: <YY7JKO/kisz+zmF8@robh.at.kernel.org>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103091943.3878621-3-clement.leger@bootlin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:39AM +0100, Clément Léger wrote:
> Convert existing bindings to yaml format. In the same time, remove non
> exiting properties ("inj" interrupt) and add fdma.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 184 ++++++++++++++++++
>  .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --------
>  2 files changed, 184 insertions(+), 83 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> new file mode 100644
> index 000000000000..0c96eabf9d2d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -0,0 +1,184 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mscc,vsc7514-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip VSC7514 Ethernet switch controller
> +
> +maintainers:
> +  - Vladimir Oltean <vladimir.oltean@nxp.com>
> +  - Claudiu Manoil <claudiu.manoil@nxp.com>
> +  - Alexandre Belloni <alexandre.belloni@bootlin.com>
> +
> +description: |
> +  The VSC7514 Industrial IoT Ethernet switch contains four integrated dual media
> +  10/100/1000BASE-T PHYs, two 1G SGMII/SerDes, two 1G/2.5G SGMII/SerDes, and an
> +  option for either a 1G/2.5G SGMII/SerDes Node Processor Interface (NPI) or a
> +  PCIe interface for external CPU connectivity. The NPI/PCIe can operate as a
> +  standard Ethernet port.
> +
> +  The device provides a rich set of Industrial Ethernet switching features such
> +  as fast protection switching, 1588 precision time protocol, and synchronous
> +  Ethernet. Advanced TCAM-based VLAN and QoS processing enable delivery of
> +  differentiated services. Security is assured through frame processing using
> +  Microsemi’s TCAM-based Versatile Content Aware Processor.
> +
> +  In addition, the device contains a powerful 500 MHz CPU enabling full
> +  management of the switch.
> +
> +properties:
> +  $nodename:
> +    pattern: "^switch@[0-9a-f]+$"
> +
> +  compatible:
> +    const: mscc,vsc7514-switch
> +
> +  reg:
> +    items:
> +      - description: system target
> +      - description: rewriter target
> +      - description: qs target
> +      - description: PTP target
> +      - description: Port0 target
> +      - description: Port1 target
> +      - description: Port2 target
> +      - description: Port3 target
> +      - description: Port4 target
> +      - description: Port5 target
> +      - description: Port6 target
> +      - description: Port7 target
> +      - description: Port8 target
> +      - description: Port9 target
> +      - description: Port10 target
> +      - description: QSystem target
> +      - description: Analyzer target
> +      - description: S0 target
> +      - description: S1 target
> +      - description: S2 target
> +      - description: fdma target
> +
> +  reg-names:
> +    items:
> +      - const: sys
> +      - const: rew
> +      - const: qs
> +      - const: ptp
> +      - const: port0
> +      - const: port1
> +      - const: port2
> +      - const: port3
> +      - const: port4
> +      - const: port5
> +      - const: port6
> +      - const: port7
> +      - const: port8
> +      - const: port9
> +      - const: port10
> +      - const: qsys
> +      - const: ana
> +      - const: s0
> +      - const: s1
> +      - const: s2
> +      - const: fdma
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description: PTP ready
> +      - description: register based extraction
> +      - description: frame dma based extraction
> +
> +  interrupt-names:
> +    minItems: 1
> +    items:
> +      - const: ptp_rdy
> +      - const: xtr
> +      - const: fdma
> +
> +  ethernet-ports:
> +    type: object

       additionalProperties: false

> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +        description: Ethernet ports handled by the switch
> +
> +        allOf:

You can drop 'allOf'.

> +          - $ref: ethernet-controller.yaml#

           unevaluatedProperties: false

> +
> +        properties:
> +          '#address-cells':
> +            const: 1
> +          '#size-cells':
> +            const: 0

Wrong level for these.

> +
> +          reg:
> +            description: Switch port number
> +
> +          phy-handle: true
> +
> +          mac-address: true
> +
> +        required:
> +          - reg
> +          - phy-handle
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - ethernet-ports
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    switch@1010000 {
> +      compatible = "mscc,vsc7514-switch";
> +      reg = <0x1010000 0x10000>,
> +            <0x1030000 0x10000>,
> +            <0x1080000 0x100>,
> +            <0x10e0000 0x10000>,
> +            <0x11e0000 0x100>,
> +            <0x11f0000 0x100>,
> +            <0x1200000 0x100>,
> +            <0x1210000 0x100>,
> +            <0x1220000 0x100>,
> +            <0x1230000 0x100>,
> +            <0x1240000 0x100>,
> +            <0x1250000 0x100>,
> +            <0x1260000 0x100>,
> +            <0x1270000 0x100>,
> +            <0x1280000 0x100>,
> +            <0x1800000 0x80000>,
> +            <0x1880000 0x10000>,
> +            <0x1040000 0x10000>,
> +            <0x1050000 0x10000>,
> +            <0x1060000 0x10000>,
> +            <0x1a0 0x1c4>;
> +      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> +            "port2", "port3", "port4", "port5", "port6",
> +            "port7", "port8", "port9", "port10", "qsys",
> +            "ana", "s0", "s1", "s2", "fdma";
> +      interrupts = <18 21 16>;
> +      interrupt-names = "ptp_rdy", "xtr", "fdma";
> +
> +      ethernet-ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port0: port@0 {
> +          reg = <0>;
> +          phy-handle = <&phy0>;
> +        };
> +        port1: port@1 {
> +          reg = <1>;
> +          phy-handle = <&phy1>;
> +        };
> +      };
> +    };
> +
> +...
> +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :

Please drop this. 

emacs settings are fine, but not vim. ;) JK, I don't use either.

