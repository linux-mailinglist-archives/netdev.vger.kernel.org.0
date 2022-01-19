Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4B49334E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351188AbiASDHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:07:12 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:41853 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiASDHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:07:11 -0500
Received: by mail-oi1-f170.google.com with SMTP id q186so1998712oih.8;
        Tue, 18 Jan 2022 19:07:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZG6b7uz1PB4E2oe2QeAcnHF46q6pw+U4MECvO3MKSCw=;
        b=hB+ho+Id4F2clX1mRHbPlg/C0vexa9EX5bW74vCiF755T5VMZepI+ol6ghsQ1KwC6z
         bqIoS22yoB9OMCIhKu0YmFNL7/QWoS/9YEStPGCCFkzROsTukFh+oXGyWddGoai7gPzW
         xCbnT+oSlBssPL6ofP/19o/y1KFQM3mbA3Pir/Nca8qE1ZvQ+WDwRXBzH7pxbbA874re
         ef96jk3wxn3d9obfBsTpYuD1BjDsNbD1QeAD0yha8c3wTE9nqydrftA8W8NrHM99o36N
         EUkNFNeWxhMhLv7pBXVUmTRcnD4T4GUOV+i2QYumBFCPN6/rk50txzHrwdBKQF/XCzDL
         k7sw==
X-Gm-Message-State: AOAM533R6mzsdzTfbU14OJN7BNoXZmBKeGmai6sIr06T1+x3Aso2gGmx
        7KK0YU/uMAi8yU3j1qTHRA==
X-Google-Smtp-Source: ABdhPJxws2eRhptEN549//3CvsKN266kS9zY1g70eqi83+1D1kdUwALIO5rNbFeHwdXB8B1RTkY0qQ==
X-Received: by 2002:a05:6808:1188:: with SMTP id j8mr1278242oil.101.1642561631142;
        Tue, 18 Jan 2022 19:07:11 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id o16sm6431863otk.7.2022.01.18.19.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 19:07:10 -0800 (PST)
Received: (nullmailer pid 2557216 invoked by uid 1000);
        Wed, 19 Jan 2022 03:07:09 -0000
Date:   Tue, 18 Jan 2022 21:07:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree v2] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <YeeAXSHSCn6PtqKW@robh.at.kernel.org>
References: <20220112181602.13661-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220112181602.13661-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 07:16:02PM +0100, Marek Behún wrote:
> Common PHYs and network PCSes often have the possibility to specify
> peak-to-peak voltage on the differential pair - the default voltage
> sometimes needs to be changed for a particular board.
> 
> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> purpose. The second property is needed to specify the mode for the
> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> is to be used only for speficic mode. More voltage-mode pairs can be
> specified.
> 
> Example usage with only one voltage (it will be used for all supported
> PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> case):
> 
>   tx-p2p-microvolt = <915000>;
> 
> Example usage with voltages for multiple modes:
> 
>   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
>   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> 
> Add these properties into a separate file phy/transmit-amplitude.yaml,
> selecting it for validation if either of the `tx-p2p-microvolt`,
> `tx-p2p-microvolt-names` properties is set for a node.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  .../bindings/phy/transmit-amplitude.yaml      | 110 ++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
> new file mode 100644
> index 000000000000..90a491b75f61
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
> @@ -0,0 +1,110 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/transmit-amplitude.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Common PHY and network PCS transmit amplitude property binding
> +
> +description:
> +  Binding describing the peak-to-peak transmit amplitude for common PHYs
> +  and network PCSes.
> +
> +maintainers:
> +  - Marek Behún <kabel@kernel.org>
> +
> +properties:
> +  tx-p2p-microvolt:
> +    description:
> +      Transmit amplitude voltages in microvolts, peak-to-peak. If this property
> +      contains multiple values for various PHY modes, the
> +      'tx-p2p-microvolt-names' property must be provided and contain
> +      corresponding mode names.
> +
> +  tx-p2p-microvolt-names:
> +    description: |
> +      Names of the modes corresponding to voltages in the 'tx-p2p-microvolt'
> +      property. Required only if multiple voltages are provided.
> +
> +      If a value of 'default' is provided, the system should use it for any PHY
> +      mode that is otherwise not defined here. If 'default' is not provided, the
> +      system should use manufacturer default value.
> +    minItems: 1
> +    maxItems: 16
> +    items:
> +      enum:
> +        - default
> +
> +        # ethernet modes
> +        - sgmii
> +        - qsgmii
> +        - xgmii
> +        - 1000base-x
> +        - 2500base-x
> +        - 5gbase-r
> +        - rxaui
> +        - xaui
> +        - 10gbase-kr
> +        - usxgmii
> +        - 10gbase-r
> +        - 25gbase-r
> +
> +        # PCIe modes
> +        - pcie
> +        - pcie1
> +        - pcie2
> +        - pcie3
> +        - pcie4
> +        - pcie5
> +        - pcie6
> +
> +        # USB modes
> +        - usb
> +        - usb-ls
> +        - usb-fs
> +        - usb-hs
> +        - usb-ss
> +        - usb-ss+
> +        - usb-4
> +
> +        # storage modes
> +        - sata
> +        - ufs-hs
> +        - ufs-hs-a
> +        - ufs-hs-b
> +
> +        # display modes
> +        - lvds
> +        - dp
> +        - dp-rbr
> +        - dp-hbr
> +        - dp-hbr2
> +        - dp-hbr3
> +        - dp-uhbr-10
> +        - dp-uhbr-13.5
> +        - dp-uhbr-20
> +
> +        # camera modes
> +        - mipi-dphy
> +        - mipi-dphy-univ
> +        - mipi-dphy-v2.5-univ
> +
> +dependencies:
> +  tx-p2p-microvolt-names: [ tx-p2p-microvolt ]
> +
> +select:

This should be omitted and this schema should be referenced by any 
binding that uses it. That is necessary so all properties get evaluated.

> +  anyOf:
> +    - required:
> +      - 'tx-p2p-microvolt'
> +    - required:
> +      - 'tx-p2p-microvolt-names'
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +    phy: phy {
> +      #phy-cells = <1>;
> +      tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
> +      tx-p2p-microvolt-names = "2500base-x", "usb-hs", "usb-ss";
> +    };
> -- 
> 2.34.1
> 
> 
