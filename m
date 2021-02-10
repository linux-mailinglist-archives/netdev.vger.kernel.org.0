Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838553173B0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhBJWvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:51:18 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:35917 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhBJWvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:51:09 -0500
Received: by mail-oi1-f181.google.com with SMTP id k204so4005746oih.3;
        Wed, 10 Feb 2021 14:50:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BlKdWC9EZwU0qeYCVAvxDTeo3iSF+eFw4n8X391mQjc=;
        b=bpHRqoCg3fsRtJpBT4ijAxidt1vgCbhdyeCc87Hf6lqdBbqscSwRKR/ieJ0WwOTLMI
         el13H/ueHGZIJHFvH7IpV5Rfvm9HoAwlwmDm6UHumhnkukkAGhM7Jx2XZ38S6UEaDdkM
         TwqQ+RVg66vg4J588bHYoeu6CEuZ7MZkStPjuzRcL10OrOl3YowX0kEDWW8TRwJryLrj
         6Cxkipcpf7fvIsA2h3WGSIFqwUKXTIJ0jal7LOJYIzBbobYRigdjjZ92WzErtg73uJ3V
         VseRNSm9TyWz6Adh+OMZvhG8VLQrJo2kkWMT0eQWIRcONQ6VduBi+2uQGAahVEbKDEQo
         Z2OQ==
X-Gm-Message-State: AOAM5327EQcbn+KiCJiF3r+km+NrlIr9222m4+QNXzj+f+PzwtOGo+Ya
        VMp3CvRA+ZE4fKFLKOCs0Q==
X-Google-Smtp-Source: ABdhPJxziduVw3rfiU3DyzsyjbtxP45LUPOkmM6HwK2KWtO+txEu0K6965ad0hz9/tP2VBij5vPZjA==
X-Received: by 2002:aca:54c9:: with SMTP id i192mr917001oib.3.1612997427878;
        Wed, 10 Feb 2021 14:50:27 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k32sm665330otc.74.2021.02.10.14.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:50:26 -0800 (PST)
Received: (nullmailer pid 2960948 invoked by uid 1000);
        Wed, 10 Feb 2021 22:50:25 -0000
Date:   Wed, 10 Feb 2021 16:50:25 -0600
From:   Rob Herring <robh@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 net-next 2/4] dt-bindings: net: Add bindings for
 Qualcomm QCA807x
Message-ID: <20210210225025.GA2953160@robh.at.kernel.org>
References: <20210210125523.2146352-1-robert.marko@sartura.hr>
 <20210210125523.2146352-3-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210125523.2146352-3-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:55:21PM +0100, Robert Marko wrote:
> Add DT bindings for Qualcomm QCA807x PHYs.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
> Changes in v2:
> * Drop LED properties
> * Directly define PSGMII/QSGMII SerDes driver values
> 
>  .../devicetree/bindings/net/qcom,qca807x.yaml | 70 +++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,qca807x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,qca807x.yaml b/Documentation/devicetree/bindings/net/qcom,qca807x.yaml
> new file mode 100644
> index 000000000000..0867f5e698cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,qca807x.yaml
> @@ -0,0 +1,70 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,qca807x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm QCA807x PHY
> +
> +maintainers:
> +  - Robert Marko <robert.marko@sartura.hr>
> +
> +description: |
> +  Bindings for Qualcomm QCA807x PHYs
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  qcom,fiber-enable:
> +    description: |
> +      If present, then PHYs combo port is configured to operate in combo
> +      mode. In combo mode autodetection of copper and fiber media is
> +      used in order to support both of them.
> +      Combo mode can be strapped as well, if not strapped this property
> +      will set combo support anyway.
> +    type: boolean
> +
> +  qcom,psgmii-az:
> +    description: |
> +      If present, then PSMGII PHY will advertise 802.3-az support to
> +      the MAC.

Sounds like a standard thing that should be common?

> +    type: boolean
> +
> +  gpio-controller: true
> +  "#gpio-cells":
> +    const: 2
> +
> +  qcom,tx-driver-strength:
> +    description: PSGMII/QSGMII SerDes TX driver strength control in mV.

Use standard unit suffix as defined in property-units.txt.

Again, seems like a common property?

> +    $ref: /schemas/types.yaml#/definitions/uint32

Then you can drop this.

> +    enum: [140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 400, 500, 600]
> +
> +  qcom,control-dac:
> +    description: Analog MDI driver amplitude and bias current.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3, 4, 5, 6, 7]
> +
> +required:
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/net/qcom-qca807x.h>
> +
> +    mdio {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      ethphy0: ethernet-phy@0 {
> +        compatible = "ethernet-phy-ieee802.3-c22";
> +        reg = <0>;
> +
> +        qcom,control-dac = <QCA807X_CONTROL_DAC_DSP_VOLT_QUARTER_BIAS>;
> +      };
> +    };
> -- 
> 2.29.2
> 
