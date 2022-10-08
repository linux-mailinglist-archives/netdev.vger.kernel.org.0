Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392E35F8866
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJHW4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 18:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJHW4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 18:56:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBD133373;
        Sat,  8 Oct 2022 15:56:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u21so11394370edi.9;
        Sat, 08 Oct 2022 15:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6VH5NDIzcp7fJXtMgvbmUefDmE2RrqbTEDEbwjqt8MY=;
        b=F/wCTdaGDtylRoVdcS4cDFh/5sI7hfRCO1QDt3FfK0j9g7Ly6lb9eSMnbOj+dS+JNo
         KufpOrwPh+bIIb8IOvDDYb8NvPGBcN6+XlEtk39oEhpcXyp/NznrRuS0sJrHJdRntDa6
         AoUIrAIMw3RMVpXlx9akNgOt4cvqAN4AQwuOoVe6O8ohIN0DOf/t6oLhRbiu3N5Rmwoh
         CjuGVS0hxUj8iPeDj01u2Xl+5smGOfAyxhcN2ZbrThfR9LIEZiL/42zn7tN62I13kqt0
         fNlersZj2CWqsZ5jhcaL+mAyKN96MeXMWTvg6SsPzo+/VkgnovTC1fGUL+iw1mzOwtuP
         Kvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VH5NDIzcp7fJXtMgvbmUefDmE2RrqbTEDEbwjqt8MY=;
        b=SPdI+IqjOCNlS5zOg15x2/S/AKSbzJ1gAj5ORxGOhJslF3J0YFaqjft1r3OllQJyF8
         OXU4RwNewkeFH3kmT0ViFvsi+B/XPt8lrELTk6ZtRQw+aj6oYxm/YzSgkHSNPvxuRSP6
         qwAPEPw506Y7v2383G+Kwqun2KMXdLErmjkQpBikog4jYpuZaELQSBEgEMSyLRLofRaW
         fBI/v+Tq/FIKRfjAUvqHN5B2CpJ6aByFquvrvOM/LICW21uJazwcc626S3ABoBNs3VRE
         YYxF0n1gPFlZ6PkVqmxvKQFW90LTzzG2qnWvWpKy1etvN8/Xud+UVQnAnHBbQk8gfT8+
         aYyQ==
X-Gm-Message-State: ACrzQf1Dge3ochuqRk24iJa5xQ0DH7H73HwPXR60GNml1bnsC5U92Rc/
        q50848FXYHNHorGJwRnlsTY=
X-Google-Smtp-Source: AMsMyM5jEUNZygRNI7UaoF+A18zmA52rMmCUAWiCEKe1AsoKggJqzTUhzyh1uqbWh9F6nQEyQXqLAw==
X-Received: by 2002:a05:6402:1052:b0:459:2c49:1aed with SMTP id e18-20020a056402105200b004592c491aedmr10889998edu.212.1665269792277;
        Sat, 08 Oct 2022 15:56:32 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b0078c213ad441sm3291604ejo.101.2022.10.08.15.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 15:56:31 -0700 (PDT)
Date:   Sun, 9 Oct 2022 01:56:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221008225628.pslsnwilrpvg3xdf@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 11:46:24AM -0500, Jerry Ray wrote:
> ---
> v3->v4:
>  - Addressed v3 community feedback

More specifically?

> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    // Ethernet switch connected via mdio to the host
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy-handle = <&lan9303switch>;
> +        phy-mode = "rmii";
> +        fixed-link {
> +            speed = <100>;
> +            full-duplex;
> +        };

I see the phy-handle to the switch is inherited from the .txt dt-binding,
but I don't understand it. The switch is an mdio_device, not a phy_device,
so what will this do?

Also, any reasonable host driver will error out if it finds a phy-handle
and a fixed-link in its OF node. So one of phy-handle or fixed-link must
be dropped, they are bogus.

Even better, just stick to the mdio node as root and drop the DSA master
OF node, like other DSA dt-binding examples do. You can have dangling
phandles, so "ethernet = <&ethernet>" below is not an issue.

> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            lan9303switch: switch@0 {
> +                compatible = "smsc,lan9303-mdio";
> +                reg = <0>;
> +                dsa,member = <0 0>;

Redundant, please remove.

> +                ethernet-ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +                        port@0 {
> +                            reg = <0>;
> +                            phy-mode = "rmii";

FWIW, RMII has a MAC mode and a PHY mode. Two RMII interfaces connected
in MAC mode to one another don't work. You'll have problems if you also
have an RMII PHY connected to one of the xMII ports, and you describe
phy-mode = "rmii" for both. There exists a "rev-rmii" phy-mode to denote
an RMII interface working in PHY mode. Wonder if you should be using
that here.

> +                            ethernet = <&ethernet>;
> +                            fixed-link {
> +                                speed = <100>;
> +                                full-duplex;
> +                            };
> +                        };
> +                        port@1 {
> +                            reg = <1>;
> +                            max-speed = <100>;
> +                            label = "lan1";
> +                        };
> +                        port@2 {
> +                            reg = <2>;
> +                            max-speed = <100>;
> +                            label = "lan2";
> +                        };
> +                    };
> +                };
> +            };
> +        };
> +
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    // Ethernet switch connected via i2c to the host
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy-mode = "rmii";
> +            speed = <100>;
> +        fixed-link {
> +            full-duplex;
> +        };
> +    };

No need for this node.

> +
> +    i2c {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        lan9303: switch@1a {
> +            compatible = "smsc,lan9303-i2c";
> +            reg = <0x1a>;
> +            ethernet-ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@0 {
> +                    reg = <0>;
> +                    phy-mode = "rmii";
> +                    ethernet = <&ethernet>;
> +                    fixed-link {
> +                        speed = <100>;
> +                        full-duplex;
> +                    };
> +                };
> +                port@1 {
> +                    reg = <1>;
> +                    max-speed = <100>;
> +                    label = "lan1";
> +                };
> +                port@2 {
> +                    reg = <2>;
> +                    max-speed = <100>;
> +                    label = "lan2";
> +                };
> +            };
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5d58b55c5ae5..89055ff2838a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13386,6 +13386,14 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/microchip/lan743x_*
>  
> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
> +M:	Jerry Ray <jerry.ray@microchip.com>
> +M:	UNGLinuxDriver@microchip.com
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> +F:	drivers/net/dsa/lan9303*
> +

Separate patch please? Changes to the MAINTAINERS file get applied to
the "net" tree.

>  MICROCHIP LAN966X ETHERNET DRIVER
>  M:	Horatiu Vultur <horatiu.vultur@microchip.com>
>  M:	UNGLinuxDriver@microchip.com
> -- 
> 2.25.1
> 

