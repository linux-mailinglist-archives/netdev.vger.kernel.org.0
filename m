Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C1A431F67
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhJROYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhJROYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:24:45 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAAFC06161C;
        Mon, 18 Oct 2021 07:22:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so74171596eda.4;
        Mon, 18 Oct 2021 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wbz6WGltBgut6hrUdYHzAG6b4KJe2di+kw3HuZ+pnWE=;
        b=E96/UEAUbTKHXb/OqsfNmFLzRtykIs0RBocBYylgP+/TdvdydWOWsZKtrENFGTcxz2
         5CR4ohKhO2WzqUKVdVl4vgbCqTS1joNjlZ4+b8yG9SOdyKfokG+icwuYDE8Na1A2xPvG
         vkYcsywqGMoX1Xl8HrGxAJrq6hnyknJB4SkiDrIyI6aR4r6IE2t0u44MsukVMh2xnV9Y
         CzJaBp32vaZSsLlgNB8amfA/OK1pBd+AFu+E4Ju4MMTDy7cdpYNCaPnpHw7NfwYFgyPT
         7eiqSBJxeNu+xwPPOMMT0FiJbHbcgvmtJYQ+H+1SnEU+Jwg+gQUiwOTE0OB+EhGq3CQf
         K81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wbz6WGltBgut6hrUdYHzAG6b4KJe2di+kw3HuZ+pnWE=;
        b=LvryVUp0wuMSb+7SA97ckAKgS71SP9KVYfjgx8mo+olUUIBstKV0ehR+jHfSEXq2HJ
         DrNtphPYFcPtJjqY75O9HhHwUzosmwqdzHKeuOul45T4Xla4+yTAbDFUh63UYT/df7tE
         MWfDiXFB+a+PW5imFVGqAytRy9SAah1ukF8gfeOCp7QUUsovdwhqHMcbPqRJckvO6mLp
         wUS8SLWBJNMPMrCX7JYKdqxFU5XkolqDwoOmIoRxKeY9S/viQz3lL+tDt1gMeb5dp0dc
         rYi4eRFIQ1koj9mkF8X0VPHg9daeglfq1YFMgicS/qeEas+h+oqV470yPe4gIyUuJorX
         Xs/Q==
X-Gm-Message-State: AOAM533P+aHE0nzGCDGjcLRa2Mak6GP3UksLF9rt0gfN1ZAxXaPtBfvy
        ncLGbELnKNC0zw9H6LHnmJM=
X-Google-Smtp-Source: ABdhPJyGDBaXlN2uCkATWqJFjXFTbqSmCzmkjy7/0zsNuTESyao9L+Tg9+8VbFGRdkh4jZma7Ok6Mg==
X-Received: by 2002:a17:907:1c0e:: with SMTP id nc14mr30709890ejc.103.1634566824622;
        Mon, 18 Oct 2021 07:20:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id g9sm8855291ejo.60.2021.10.18.07.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:20:24 -0700 (PDT)
Date:   Mon, 18 Oct 2021 16:20:23 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v7 16/16] dt-bindings: net: dsa: qca8k: convert
 to YAML schema
Message-ID: <YW2Cp6vWAYDM68rs@Ansuel-xps.localdomain>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
 <20211013223921.4380-17-ansuelsmth@gmail.com>
 <YW2BcC2izFM6HjG5@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW2BcC2izFM6HjG5@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:15:12AM -0500, Rob Herring wrote:
> On Thu, Oct 14, 2021 at 12:39:21AM +0200, Ansuel Smith wrote:
> > From: Matthew Hagan <mnhagan88@gmail.com>
> > 
> > Convert the qca8k bindings to YAML format.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
> >  2 files changed, 362 insertions(+), 245 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> 
> 
> 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > new file mode 100644
> > index 000000000000..48de0ace265d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -0,0 +1,362 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/qca8k.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Qualcomm Atheros QCA83xx switch family
> > +
> > +maintainers:
> > +  - John Crispin <john@phrozen.org>
> > +
> > +description:
> > +  If the QCA8K switch is connect to an SoC's external mdio-bus, each subnode
> > +  describing a port needs to have a valid phandle referencing the internal PHY
> > +  it is connected to. This is because there is no N:N mapping of port and PHY
> > +  ID. To declare the internal mdio-bus configuration, declare an MDIO node in
> > +  the switch node and declare the phandle for the port, referencing the internal
> > +  PHY it is connected to. In this config, an internal mdio-bus is registered and
> > +  the MDIO master is used for communication. Mixed external and internal
> > +  mdio-bus configurations are not supported by the hardware.
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - enum:
> 
> Don't need oneOf with one entry.
> 
> > +          - qca,qca8327
> > +          - qca,qca8328
> > +          - qca,qca8334
> > +          - qca,qca8337
> > +    description: |
> > +      qca,qca8328: referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
> > +      qca,qca8327: referenced as AR8327(N)-AL1A DR-QFN 148 pin package
> > +      qca,qca8334: referenced as QCA8334-AL3C QFN 88 pin package
> > +      qca,qca8337: referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  reset-gpios:
> > +    description:
> > +      GPIO to be used to reset the whole device
> > +    maxItems: 1
> > +
> > +  qca,ignore-power-on-sel:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Ignore power-on pin strapping to configure LED open-drain or EEPROM
> > +      presence. This is needed for devices with incorrect configuration or when
> > +      the OEM has decided not to use pin strapping and falls back to SW regs.
> > +
> > +  qca,led-open-drain:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Set LEDs to open-drain mode. This requires the qca,ignore-power-on-sel to
> > +      be set, otherwise the driver will fail at probe. This is required if the
> > +      OEM does not use pin strapping to set this mode and prefers to set it
> > +      using SW regs. The pin strappings related to LED open-drain mode are
> > +      B68 on the QCA832x and B49 on the QCA833x.
> > +
> > +  mdio:
> > +    type: object
> > +    description: Qca8k switch have an internal mdio to access switch port.
> > +                 If this is not present, the legacy mapping is used and the
> > +                 internal mdio access is used.
> > +                 With the legacy mapping the reg corresponding to the internal
> > +                 mdio is the switch reg with an offset of -1.
> 
> 2 spaces more than description.
> 
> > +
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> 
> The mdio bus provides these constraints already.
> 
> > +
> > +    patternProperties:
> > +      "^(ethernet-)?phy@[0-4]$":
> > +        type: object
> > +
> > +        allOf:
> 
> Don't need allOf.
> 
> > +          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
> 
> The phy is an mdio bus? 
> 
> You don't need any of this. Just:
> 
> mdio:
>   $ref: /schemas/net/mdio.yaml#
>   unevaluatedProperties: false
>   description: ...
> 
> > +
> > +        properties:
> > +          reg:
> > +            maxItems: 1
> > +
> > +        required:
> > +          - reg
> > +
> > +patternProperties:
> > +  "^(ethernet-)?ports$":
> > +    type: object
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^(ethernet-)?port@[0-6]$":
> > +        type: object
> > +        description: Ethernet switch ports
> > +
> > +        properties:
> > +          reg:
> > +            description: Port number
> > +
> > +          label:
> > +            description:
> > +              Describes the label associated with this port, which will become
> > +              the netdev name
> > +            $ref: /schemas/types.yaml#/definitions/string
> > +
> > +          link:
> > +            description:
> > +              Should be a list of phandles to other switch's DSA port. This
> > +              port is used as the outgoing port towards the phandle ports. The
> > +              full routing information must be given, not just the one hop
> > +              routes to neighbouring switches
> > +            $ref: /schemas/types.yaml#/definitions/phandle-array
> > +
> > +          ethernet:
> > +            description:
> > +              Should be a phandle to a valid Ethernet device node.  This host
> > +              device is what the switch port is connected to
> > +            $ref: /schemas/types.yaml#/definitions/phandle
> 
> All of this is defined in dsa.yaml. Add a $ref to it and don't duplicate 
> it here.
>

The reason I redefined it is because I didn't manage to find a way on
how to add additional bindings for the qca,sgmii... . Any hint about
that?

I tried with allOf but the make check still printed errors in the
example with not valid binding about qca,sgmii.

> > +
> > +          phy-handle: true
> > +
> > +          phy-mode: true
> > +
> > +          fixed-link: true
> > +
> > +          mac-address: true
> > +
> > +          sfp: true
> > +
> > +          qca,sgmii-rxclk-falling-edge:
> > +            $ref: /schemas/types.yaml#/definitions/flag
> > +            description:
> > +              Set the receive clock phase to falling edge. Mostly commonly used on
> > +              the QCA8327 with CPU port 0 set to SGMII.
> > +
> > +          qca,sgmii-txclk-falling-edge:
> > +            $ref: /schemas/types.yaml#/definitions/flag
> > +            description:
> > +              Set the transmit clock phase to falling edge.
> > +
> > +          qca,sgmii-enable-pll:
> > +            $ref: /schemas/types.yaml#/definitions/flag
> > +            description:
> > +              For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
> > +              Signal Detection. On the QCA8327 this should not be enabled, otherwise
> > +              the SGMII port will not initialize. When used on the QCA8337, revision 3
> > +              or greater, a warning will be displayed. When the CPU port is set to
> > +              SGMII on the QCA8337, it is advised to set this unless a communication
> > +              issue is observed.
> > +
> > +        required:
> > +          - reg
> > +
> > +        additionalProperties: false
> > +
> > +oneOf:
> > +  - required:
> > +      - ports
> > +  - required:
> > +      - ethernet-ports
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: true
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    mdio {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        external_phy_port1: ethernet-phy@0 {
> > +            reg = <0>;
> > +        };
> > +
> > +        external_phy_port2: ethernet-phy@1 {
> > +            reg = <1>;
> > +        };
> > +
> > +        external_phy_port3: ethernet-phy@2 {
> > +            reg = <2>;
> > +        };
> > +
> > +        external_phy_port4: ethernet-phy@3 {
> > +            reg = <3>;
> > +        };
> > +
> > +        external_phy_port5: ethernet-phy@4 {
> > +            reg = <4>;
> > +        };
> > +
> > +        switch@10 {
> > +            compatible = "qca,qca8337";
> > +            #address-cells = <1>;
> > +            #size-cells = <0>;
> > +            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
> > +            reg = <0x10>;
> > +
> > +            ports {
> 
> Use the preferred 'ethernet-ports'.
> 
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +
> > +                port@0 {
> > +                    reg = <0>;
> > +                    label = "cpu";
> > +                    ethernet = <&gmac1>;
> > +                    phy-mode = "rgmii";
> > +
> > +                    fixed-link {
> > +                        speed = <1000>;
> > +                        full-duplex;
> > +                    };
> > +                };
> > +
> > +                port@1 {
> > +                    reg = <1>;
> > +                    label = "lan1";
> > +                    phy-handle = <&external_phy_port1>;
> > +                };
> > +
> > +                port@2 {
> > +                    reg = <2>;
> > +                    label = "lan2";
> > +                    phy-handle = <&external_phy_port2>;
> > +                };
> > +
> > +                port@3 {
> > +                    reg = <3>;
> > +                    label = "lan3";
> > +                    phy-handle = <&external_phy_port3>;
> > +                };
> > +
> > +                port@4 {
> > +                    reg = <4>;
> > +                    label = "lan4";
> > +                    phy-handle = <&external_phy_port4>;
> > +                };
> > +
> > +                port@5 {
> > +                    reg = <5>;
> > +                    label = "wan";
> > +                    phy-handle = <&external_phy_port5>;
> > +                };
> > +            };
> > +        };
> > +    };
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    mdio {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        switch@10 {
> > +            compatible = "qca,qca8337";
> > +            #address-cells = <1>;
> > +            #size-cells = <0>;
> > +            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
> > +            reg = <0x10>;
> > +
> > +            ports {
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +
> > +                port@0 {
> > +                    reg = <0>;
> > +                    label = "cpu";
> > +                    ethernet = <&gmac1>;
> > +                    phy-mode = "rgmii";
> > +
> > +                    fixed-link {
> > +                        speed = <1000>;
> > +                        full-duplex;
> > +                    };
> > +                };
> > +
> > +                port@1 {
> > +                    reg = <1>;
> > +                    label = "lan1";
> > +                    phy-mode = "internal";
> > +                    phy-handle = <&internal_phy_port1>;
> > +                };
> > +
> > +                port@2 {
> > +                    reg = <2>;
> > +                    label = "lan2";
> > +                    phy-mode = "internal";
> > +                    phy-handle = <&internal_phy_port2>;
> > +                };
> > +
> > +                port@3 {
> > +                    reg = <3>;
> > +                    label = "lan3";
> > +                    phy-mode = "internal";
> > +                    phy-handle = <&internal_phy_port3>;
> > +                };
> > +
> > +                port@4 {
> > +                    reg = <4>;
> > +                    label = "lan4";
> > +                    phy-mode = "internal";
> > +                    phy-handle = <&internal_phy_port4>;
> > +                };
> > +
> > +                port@5 {
> > +                    reg = <5>;
> > +                    label = "wan";
> > +                    phy-mode = "internal";
> > +                    phy-handle = <&internal_phy_port5>;
> > +                };
> > +
> > +                port@6 {
> > +                    reg = <0>;
> > +                    label = "cpu";
> > +                    ethernet = <&gmac1>;
> > +                    phy-mode = "sgmii";
> > +
> > +                    qca,sgmii-rxclk-falling-edge;
> > +
> > +                    fixed-link {
> > +                        speed = <1000>;
> > +                        full-duplex;
> > +                    };
> > +                };
> > +            };
> > +
> > +            mdio {
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +
> > +                internal_phy_port1: ethernet-phy@0 {
> > +                    reg = <0>;
> > +                };
> > +
> > +                internal_phy_port2: ethernet-phy@1 {
> > +                    reg = <1>;
> > +                };
> > +
> > +                internal_phy_port3: ethernet-phy@2 {
> > +                    reg = <2>;
> > +                };
> > +
> > +                internal_phy_port4: ethernet-phy@3 {
> > +                    reg = <3>;
> > +                };
> > +
> > +                internal_phy_port5: ethernet-phy@4 {
> > +                    reg = <4>;
> > +                };
> > +            };
> > +        };
> > +    };
> > -- 
> > 2.32.0
> > 
> > 

-- 
	Ansuel
