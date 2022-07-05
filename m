Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9056784B
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiGEUY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiGEUY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:24:27 -0400
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E623183B7;
        Tue,  5 Jul 2022 13:24:26 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id m13so12284915ioj.0;
        Tue, 05 Jul 2022 13:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kK1t7Hsd/FWgXecyEjcQLgVat5DGCZVjcpXVyINHGBo=;
        b=366Acw/9VOC/KcFqzL0HGYEvOkIKBunQKbBnrqjG9azai8mF+iWmziSBdHxow+8kvW
         cmHn607XEb31mS1ifDbH5MCnw0RP5od+9a0rARlrvJHL+5/occCJ0Kc3SlHeAMjYe49L
         2Q32MxroptPOZZN7KnXh2C5XExgfy51Ez2nrR52buayGYOZDu6tP7QoneNifl5lZI26y
         R3HxsN7aLYHKHOptCG8M+juJ9mFnQ6n76Bcy3+WyPfE1yK4uY1Vr9f9lcJq28NPcWfad
         FUgEa21csqBHUCtpVTbRn8N73QgULme3rbLRuCmUMCdgPEe3AbrpHXL6GRGEY49G7+gj
         N9pQ==
X-Gm-Message-State: AJIora8j+32yYuoN0yNMYZmaQd4I+ziupIpezkGK1IaWORcigzANaB+w
        eURP1pS7BiTahYOJgj6bUA==
X-Google-Smtp-Source: AGRyM1uOd2VwN/NQZ6fbCzM4AMMTvkP+YCGyiaB2dEnQSdz8YKrXriD1uBiy6KqPbSVj0mdL/0Sl/g==
X-Received: by 2002:a05:6638:1507:b0:33d:7bd:9479 with SMTP id b7-20020a056638150700b0033d07bd9479mr20173096jat.34.1657052665674;
        Tue, 05 Jul 2022 13:24:25 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q23-20020a05663810d700b003322a709c7esm15126088jad.30.2022.07.05.13.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 13:24:25 -0700 (PDT)
Received: (nullmailer pid 2564283 invoked by uid 1000);
        Tue, 05 Jul 2022 20:24:22 -0000
Date:   Tue, 5 Jul 2022 14:24:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Message-ID: <20220705202422.GA2546662-robh@kernel.org>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 12:26:00PM -0700, Colin Foster wrote:
> The patch set in general is to add support for the VSC7512, and
> eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> SPI. Specifically this patch set enables pinctrl, serial gpio expander
> access, and control of an internal and an external MDIO bus.
> 
> I have mentioned previously:
> The hardware setup I'm using for development is a beaglebone black, with
> jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
> board has been modified to not boot from flash, but wait for SPI. An
> ethernet cable is connected from the beaglebone ethernet to port 0 of
> the dev board. Network functionality will be included in a future patch set.
> 
> The device tree I'm using is included in the documentation, so I'll not
> include that in this cover letter. I have exported the serial GPIOs to the
> LEDs, and verified functionality via
> "echo heartbeat > sys/class/leds/port0led/trigger"
> 
> / {
> 	vscleds {
> 		compatible = "gpio-leds";
> 		vscled@0 {
> 			label = "port0led";
> 			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
> 			default-state = "off";
> 		};
> 		vscled@1 {
> 			label = "port0led1";
> 			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
> 			default-state = "off";
> 		};
> [ ... ]
> 	};
> };
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 5.19.0-rc3-00745-g30c05ffbecdc (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #826 SMP PREEMPT Fri Jul 1 11:26:44 PDT 2022
> ...
> [    1.952616] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
> [    1.956522] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
> [    1.967188] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
> [    1.983763] mscc-miim ocelot-miim0.2.auto: DMA mask not set
> [    3.020687] mscc-miim ocelot-miim1.3.auto: DMA mask not set
> 
> 
> I only have hardware to test the last patch, so any testers are welcome.
> I've been extra cautious about the ocelot_regmap_from_resource helper
> function, both before and after the last patch. I accidentally broke it
> in the past and would like to avoid doing so again.
> 
> 
> RFC history:
> v1 (accidentally named vN)
> 	* Initial architecture. Not functional
> 	* General concepts laid out
> 
> v2
> 	* Near functional. No CPU port communication, but control over all
> 	external ports
> 	* Cleaned up regmap implementation from v1
> 
> v3
> 	* Functional
> 	* Shared MDIO transactions routed through mdio-mscc-miim
> 	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
> 	felix->info->enable_npi_port
> 	* NPI port tagging functional - Requires a CPU port driver that supports
> 	frames of 1520 bytes. Verified with a patch to the cpsw driver
> 
> v4
>     * Functional
>     * Device tree fixes
>     * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
>     * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
>     * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
>     is to have an ocelot_pcs that will work for each configuration of
>     every port.
> 
> v5
>     * Restructured to MFD
>     * Several commits were split out, submitted, and accepted
>     * pinctrl-ocelot believed to be fully functional (requires commits
>     from the linux-pinctrl tree)
>     * External MDIO bus believed to be fully functional
> 
> v6
>     * Applied several suggestions from the last RFC from Lee Jones. I
>       hope I didn't miss anything.
>     * Clean up MFD core - SPI interaction. They no longer use callbacks.
>     * regmaps get registered to the child device, and don't attempt to
>       get shared. It seems if a regmap is to be shared, that should be
>       solved with syscon, not dev or mfd.
> 
> v7
>     * Applied as much as I could from Lee and Vladimir's suggestions. As
>       always, the feedback is greatly appreciated!
>     * Remove "ocelot_spi" container complication
>     * Move internal MDIO bus from ocelot_ext to MFD, with a devicetree
>       change to match
>     * Add initial HSIO support
>     * Switch to IORESOURCE_REG for resource definitions
> 
> v8
>     * Applied another round of suggestions from Lee and Vladimir
>     * Utilize regmap bus reads, which speeds bulk transfers up by an
>       order of magnitude
>     * Add two additional patches to utilize phylink_generic_validate
>     * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
>     * Remove initial hsio/serdes changes from the RFC
> 
> v9
>     * Submitting as a PATCH instead of an RFC
>     * Remove switch functionality - will be a separate patch set
>     * Remove Kconfig tristate module options
>     * Another round of suggestions from Lee, Vladimir, and Andy. Many
>       thanks!
>     * Add documentation
>     * Update maintainers
> 
> v10
>     * Fix warming by removing unused function
> 
> v11
>     * Suggestions from Rob and Andy. Thanks!
>     * Add pinctrl module functionality back and fixing those features
>     * Fix aarch64 compiler error
> 
> v12
>     * Suggestions from Vladimir, Andy, Randy, and Rob. Thanks as always!

Not all that useful as a changelog. I have no idea what I told you as 
that was probably 100s of reviews ago. When writing changelogs for patch 
revisions, you need to describe what changed. And it's best to put that 
into the relevant patch. IOW, I want to know what I said to change so I 
know what I need to look at again in particular.

And now that I've found v11, 'suggestions from Rob' isn't really 
accurate as you fixed errors reported by running the tools.

Rob
