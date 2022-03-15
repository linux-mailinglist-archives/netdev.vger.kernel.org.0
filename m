Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AB64DA23D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350963AbiCOSXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiCOSXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:23:22 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFD15A0A0
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:22:08 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 317CB3F07E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647368522;
        bh=o4vBB3byYIgH7wTAStk4E/hm0oFDkpJuAFEqsLoQDWg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=nDQEbMWmlJhGLiYjUm9lxNQWgDsNAmr25Zx2OlH913M9ICYaVqwyGI3/tG+jwuQL5
         ps/n777RoGvBMo4Px+OAbqap38FyJjzAxn+A1olIuLCHR4J5dJ+jHlkMn2o8VFLVn3
         ROXLQDPSPLVGkiSubaTOmjba9aKKBY1+eVkC6EY8pQIoFv50FO1elaT4Tt+HkCSg09
         E/BwGIj6JUSK5shxDDx9UHa35yeMZuH3KHmdXi/KsK0CFobyxk/tfYRgjVO+Nk8cbU
         2D0Ke56qucwFSPpdoHu/0mb9Uaqmb9q8trA9JJv2YTTt1x4O9O/7ZPr019RDimTJE1
         eIXLAhdt+LkXQ==
Received: by mail-ej1-f70.google.com with SMTP id el10-20020a170907284a00b006db9df1f3bbso6714611ejc.5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o4vBB3byYIgH7wTAStk4E/hm0oFDkpJuAFEqsLoQDWg=;
        b=mZQ/Dj1x9bLhYOthE6VQwPcBxTvFrDwtxnB6rCzVlSTH1ewWRgEsFipgEWn/AivR08
         iUTP2tlFg2DUyNoeuRbIHhKZrh8TbXh76qlSjjAGM977JahbdN25EyPdg6yrlj8XeI+V
         vR/Rzu1pVivlKcbbTpgQu6C0/U5zmOpgSqRnbxONej0oL/6XQhlxwenBY5kq6tcWlLXX
         0HdiM55GHXHoFbOhHItv6hxRTO/Nq6hJdw+050KPl9ESMOxTN7WFxbdpcTAko6Ph+L37
         v20XJ51kCioBUbz53cSCNHX3uX/T/qkjL+6UrynVwZTtxasFUNh/oOC1ur02jqsK49Un
         Vbzw==
X-Gm-Message-State: AOAM532oWBJuLAEBIwYKAZFl4LQgOMMtbeG5LDjF9MlZi5P5TP7zf7V5
        DMGDwaNpaHL7aTo1C+v1+4OhLPJnOdhUnSvAqHwj8rL6o/tIcC0IGCowLx/nqhYGQNuHJrMcOA8
        MMPilsyu5X8e+KkSUZhn5WEoUX/xBZu6jXw==
X-Received: by 2002:a17:906:1603:b0:6ce:362:c938 with SMTP id m3-20020a170906160300b006ce0362c938mr23485940ejd.253.1647368521734;
        Tue, 15 Mar 2022 11:22:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ0Qf9HZB+W4hIye+HsaI5LZ49pbRg5RooLgxOjgoaF9U66T8i8zhCvMVgJtsSDnoe/R/xbw==
X-Received: by 2002:a17:906:1603:b0:6ce:362:c938 with SMTP id m3-20020a170906160300b006ce0362c938mr23485920ejd.253.1647368521425;
        Tue, 15 Mar 2022 11:22:01 -0700 (PDT)
Received: from [10.227.148.193] (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm8768266edz.35.2022.03.15.11.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 11:22:00 -0700 (PDT)
Message-ID: <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
Date:   Tue, 15 Mar 2022 19:21:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220315123315.233963-1-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2022 13:33, Ioana Ciornei wrote:
> Convert the sff,sfp.txt bindings to the DT schema format.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  .../devicetree/bindings/net/sff,sfp.txt       |  85 ------------
>  .../devicetree/bindings/net/sff,sfp.yaml      | 130 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 131 insertions(+), 85 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
>  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
> deleted file mode 100644
> index 832139919f20..000000000000
> --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> -Transceiver
> -
> -Required properties:
> -
> -- compatible : must be one of
> -  "sff,sfp" for SFP modules
> -  "sff,sff" for soldered down SFF modules
> -
> -- i2c-bus : phandle of an I2C bus controller for the SFP two wire serial
> -  interface
> -
> -Optional Properties:
> -
> -- mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
> -  module presence input gpio signal, active (module absent) high. Must
> -  not be present for SFF modules
> -
> -- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
> -  Indication input gpio signal, active (signal lost) high
> -
> -- tx-fault-gpios : GPIO phandle and a specifier of the Module Transmitter
> -  Fault input gpio signal, active (fault condition) high
> -
> -- tx-disable-gpios : GPIO phandle and a specifier of the Transmitter Disable
> -  output gpio signal, active (Tx disable) high
> -
> -- rate-select0-gpios : GPIO phandle and a specifier of the Rx Signaling Rate
> -  Select (AKA RS0) output gpio signal, low: low Rx rate, high: high Rx rate
> -  Must not be present for SFF modules
> -
> -- rate-select1-gpios : GPIO phandle and a specifier of the Tx Signaling Rate
> -  Select (AKA RS1) output gpio signal (SFP+ only), low: low Tx rate, high:
> -  high Tx rate. Must not be present for SFF modules
> -
> -- maximum-power-milliwatt : Maximum module power consumption
> -  Specifies the maximum power consumption allowable by a module in the
> -  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
> -
> -Example #1: Direct serdes to SFP connection
> -
> -sfp_eth3: sfp-eth3 {
> -	compatible = "sff,sfp";
> -	i2c-bus = <&sfp_1g_i2c>;
> -	los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> -	mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> -	maximum-power-milliwatt = <1000>;
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> -	tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> -	tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> -};
> -
> -&cps_emac3 {
> -	phy-names = "comphy";
> -	phys = <&cps_comphy5 0>;
> -	sfp = <&sfp_eth3>;
> -};
> -
> -Example #2: Serdes to PHY to SFP connection
> -
> -sfp_eth0: sfp-eth0 {
> -	compatible = "sff,sfp";
> -	i2c-bus = <&sfpp0_i2c>;
> -	los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> -	mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cps_sfpp0_pins>;
> -	tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> -	tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> -};
> -
> -p0_phy: ethernet-phy@0 {
> -	compatible = "ethernet-phy-ieee802.3-c45";
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> -	reg = <0>;
> -	interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> -	sfp = <&sfp_eth0>;
> -};
> -
> -&cpm_eth0 {
> -	phy = <&p0_phy>;
> -	phy-mode = "10gbase-kr";
> -};
> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> new file mode 100644
> index 000000000000..bceeff5ccedb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> @@ -0,0 +1,130 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/sff,sfp.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> +  Transceiver
> +
> +maintainers:
> +  - Russell King <linux@armlinux.org.uk>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - sff,sfp  # for SFP modules
> +      - sff,sff  # for soldered down SFF modules
> +
> +  i2c-bus:

Thanks for the conversion.

You need here a type because this does not look like standard property.

> +    description:
> +      phandle of an I2C bus controller for the SFP two wire serial
> +
> +  maximum-power-milliwatt:
> +    maxItems: 1
> +    description:
> +      Maximum module power consumption Specifies the maximum power consumption
> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> +      be up to 1W, 1.5W or 2W.
> +
> +patternProperties:
> +  "mod-def0-gpio(s)?":

This should be just "mod-def0-gpios", no need for pattern. The same in
all other places.

> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
> +      presence input gpio signal, active (module absent) high. Must not be
> +      present for SFF modules
> +
> +  "los-gpio(s)?":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
> +      input gpio signal, active (signal lost) high
> +
> +  "tx-fault-gpio(s)?":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
> +      signal, active (fault condition) high
> +
> +  "tx-disable-gpio(s)?":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Transmitter Disable output gpio
> +      signal, active (Tx disable) high
> +
> +  "rate-select0-gpio(s)?":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
> +      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
> +      present for SFF modules
> +
> +  "rate-select1-gpio(s)?":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
> +      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
> +      not be present for SFF modules

This and other cases should have a "allOf: if: ...." with a
"rate-select1-gpios: false", to disallow this property on SFF modules.

> +
> +required:
> +  - compatible
> +  - i2c-bus
> +
> +additionalProperties: false
> +
> +examples:
> +  - | # Direct serdes to SFP connection
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    sfp_eth3: sfp-eth3 {

Generic node name please, so maybe "transceiver"? or just "sfp"?

> +      compatible = "sff,sfp";
> +      i2c-bus = <&sfp_1g_i2c>;
> +      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> +      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> +      maximum-power-milliwatt = <1000>;
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> +      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> +      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> +    };
> +
> +    cps_emac3 {

This is not related, so please remove.

> +      phy-names = "comphy";
> +      phys = <&cps_comphy5 0>;
> +      sfp = <&sfp_eth3>;
> +    };
> +
> +  - | # Serdes to PHY to SFP connection
> +    #include <dt-bindings/gpio/gpio.h>

Are you sure it works fine? Double define?

> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    sfp_eth0: sfp-eth0 {

Same node name - generic.

> +      compatible = "sff,sfp";
> +      i2c-bus = <&sfpp0_i2c>;
> +      los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> +      mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&cps_sfpp0_pins>;
> +      tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> +      tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> +    };
> +
> +    mdio {

Not related.

> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      p0_phy: ethernet-phy@0 {
> +        compatible = "ethernet-phy-ieee802.3-c45";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> +        reg = <0>;
> +        interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> +        sfp = <&sfp_eth0>;
> +      };
> +    };
> +
> +    cpm_eth0 {

Also not related.

> +      phy = <&p0_phy>;
> +      phy-mode = "10gbase-kr";
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1397a6b039fb..6da4872b4efb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17498,6 +17498,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
>  M:	Russell King <linux@armlinux.org.uk>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/net/sff,sfp.yaml

Mention this in the commit msg, please.

Thanks!

>  F:	drivers/net/phy/phylink.c
>  F:	drivers/net/phy/sfp*
>  F:	include/linux/mdio/mdio-i2c.h


Best regards,
Krzysztof
