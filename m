Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BDB5ECE6C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiI0U0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiI0U0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:26:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE10956B5;
        Tue, 27 Sep 2022 13:26:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lh5so23055209ejb.10;
        Tue, 27 Sep 2022 13:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=IObHm7x/B3mer9US4+L/KhP1ybOSmVyEk1jk3KB/PfY=;
        b=ohO76xe/6hFtUzaEDmES8wTbgBpOwxhUybyOEtyeLFVw7+thNVOvCQ7/DagEjb2PV+
         IPRcWNAM83fCKoQu2WVksNu/8quq/xQnghtiMXsnkvVrfDNhthqd9T3hKzR4zM6sHemr
         8jLN1YAh8NOLqu0fs6V+8WYNVHqiPKzMhXTgaGJ29DzhKuKtwXOfU4OHpwyZXL12Fopz
         PQnIWuGP8jMYccAxEO5Xd3VAE5LNBf+cEeNwoU9uTUk5Hz0U+F4pPRv/oA5IG8dKI/lo
         VuDe5cqLVSwEWY+WhfJC5def8VoGhuvX1FtKmRX4el+8GEJNiQ1+QDTGvO2Q9FVLsbZ/
         vbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IObHm7x/B3mer9US4+L/KhP1ybOSmVyEk1jk3KB/PfY=;
        b=7cWqPqHa66D39ithRjzVxGsqN2hkkMBTBwCxRhaYeuAsTw6oV/PTKAc6aUCPf3JjTK
         Nc2BcgcWOV5mxjTgvvcTi6VmcXQ5AEp/Tzg/cUQ22qljtOYIkOLpOLVR87w6XUdoG569
         CQDpBDoNcIy76Foa2vZw9QxrKv/ozF95OtTlOg3l5ZRM07vKb4yZaJ9cBWL3Z3FDnhAK
         bXhw/Ncu3iBWnyDOnEZV2irfLleExdkFZCC75JKf8GZbpMRgmNvjmmRAvCrO/+0/Ergc
         RssPq3Hyb5E5bzQgoHHbxENZaPqD1ZLOuGzaLK7ILSMaS9yFLz5fbqC7YOJdIAtN02eS
         I3tg==
X-Gm-Message-State: ACrzQf2g1L1eemY+QbuQn0HMtjVQmVeP2CJgekh16IXdnplmAf22dUv3
        a5jOjwZGHCo2ERpPKgZcFj8=
X-Google-Smtp-Source: AMsMyM6Z9IyJADJzlLbZ8HlSTyHNGaVAAWGMNdZhuDsSEnGMu+lP50B4iNVRkcHnVje+fP5EroxlgA==
X-Received: by 2002:a17:907:2bf4:b0:76f:1053:6e4 with SMTP id gv52-20020a1709072bf400b0076f105306e4mr24539065ejc.443.1664310364048;
        Tue, 27 Sep 2022 13:26:04 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906308200b0073d70df6e56sm1297762ejv.138.2022.09.27.13.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 13:26:03 -0700 (PDT)
Date:   Tue, 27 Sep 2022 23:26:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926002928.2744638-13-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> ---
>  .../bindings/net/dsa/mscc,ocelot.yaml         | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> index 8d93ed9c172c..49450a04e589 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> @@ -54,9 +54,22 @@ description: |
>        - phy-mode = "1000base-x": on ports 0, 1, 2, 3
>        - phy-mode = "2500base-x": on ports 0, 1, 2, 3
>  
> +  VSC7412 (Ocelot-Ext):

VSC7512

> +
> +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> +    processor that natively support Linux. Additionally, all four devices
> +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> +    driver is for the external control portion.
> +
> +    The following PHY interface types are supported:
> +
> +      - phy-mode = "internal": on ports 0, 1, 2, 3

More PHY interface types are supported. Please document them all.
It doesn't matter what the driver supports. Drivers and device tree
blobs should be able to have different lifetimes. A driver which doesn't
support the SERDES ports should work with a device tree that defines
them, and a driver that supports the SERDES ports should work with a
device tree that doesn't.

Similar for the other stuff which isn't documented (interrupts, SERDES
PHY handles etc). Since there is already an example with vsc7514, you
know how they need to look, even if they don't work yet on your
hardware, no?

> +
>  properties:
>    compatible:
>      enum:
> +      - mscc,vsc7512-switch
>        - mscc,vsc9953-switch
>        - pci1957,eef0
>  
> @@ -258,3 +271,49 @@ examples:
>              };
>          };
>      };
> +  # Ocelot-ext VSC7512
> +  - |
> +    spi {
> +        soc@0 {
> +            compatible = "mscc,vsc7512";
> +            #address-cells = <1>;
> +            #size-cells = <1>;
> +
> +            ethernet-switch@0 {
> +                compatible = "mscc,vsc7512-switch";
> +                reg = <0 0>;

What is the idea behind reg = <0 0> here? I would expect this driver to
follow the same conventions as Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml.
The hardware is mostly the same, so the switch portion of the DT bindings
should be mostly plug and play between the switchdev and the DSA variant.
So you can pick the "sys" target as the one giving the address of the
node, and define all targets via "reg" and "reg-names" here.

Like so:

      reg = <0x71010000 0x00010000>,
            <0x71030000 0x00010000>,
            <0x71080000 0x00000100>,
            <0x710e0000 0x00010000>,
            <0x711e0000 0x00000100>,
            <0x711f0000 0x00000100>,
            <0x71200000 0x00000100>,
            <0x71210000 0x00000100>,
            <0x71220000 0x00000100>,
            <0x71230000 0x00000100>,
            <0x71240000 0x00000100>,
            <0x71250000 0x00000100>,
            <0x71260000 0x00000100>,
            <0x71270000 0x00000100>,
            <0x71280000 0x00000100>,
            <0x71800000 0x00080000>,
            <0x71880000 0x00010000>,
            <0x71040000 0x00010000>,
            <0x71050000 0x00010000>,
            <0x71060000 0x00010000>;
      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
            "port2", "port3", "port4", "port5", "port6",
            "port7", "port8", "port9", "port10", "qsys",
            "ana", "s0", "s1", "s2";

The mfd driver can use these resources or can choose to ignore them, but
I don't see a reason why the dt-bindings should diverge from vsc7514,
its closest cousin.

> +
> +                ethernet-ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +
> +                    port@0 {
> +                        reg = <0>;
> +                        label = "cpu";

label = "cpu" is not used, please remove.

> +                        ethernet = <&mac_sw>;
> +                        phy-handle = <&phy0>;
> +                        phy-mode = "internal";
> +                    };
> +
> +                    port@1 {
> +                        reg = <1>;
> +                        label = "swp1";
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy1>;
> +                    };
> +
> +                    port@2 {
> +                        reg = <2>;
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy2>;
> +                    };
> +
> +                    port@3 {
> +                        reg = <3>;
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy3>;
> +                    };
> +                };
> +            };
> +        };
> +    };
> -- 
> 2.25.1
> 
