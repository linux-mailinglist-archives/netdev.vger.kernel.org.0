Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594D96BE210
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCQHpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCQHp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FB3B329B;
        Fri, 17 Mar 2023 00:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2781621DC;
        Fri, 17 Mar 2023 07:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4F0C433EF;
        Fri, 17 Mar 2023 07:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679039127;
        bh=uMC+mKisSczlSP5vnGYRs4BuFUpa/scNus377rX44J0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sR3e/4eBXDoo1W3Jp5JGHJIuY0EK//4Pc6SkXzWsmHNRPPWeWk5A++HMSz+evmAhV
         uVweUDEqfJ8E0ANk3QGoxnYfzl+Qs5dTXYEjhXGm+4v1r1oxGLry60xFLpEP6P9PhV
         C2CXnlIU78mjBM0m2zhMIMc1Ir8uVdrNPjtjeo8x3fSO+L1HlQAyIgteuTU2c4MXEJ
         AAnGDsVgHFIqKbYICDx2wrZhnbjvuARW/F/omqPeO+vBXa+GU+8J7Dp1zGVSaB9URk
         0+r4L8Bn4nn5bQhY0s9mYHMDybNH5RF6eMA/6smCj1IPkDD8A44PYjFpEthj90xNTe
         d94fS/VAl+DAA==
Date:   Fri, 17 Mar 2023 08:45:19 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <20230317084519.12d3587a@dellmb>
In-Reply-To: <20230317023125.486-5-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
        <20230317023125.486-5-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 03:31:15 +0100
Christian Marangi <ansuelsmth@gmail.com> wrote:

> +	cdev->brightness_set_blocking = phy_led_set_brightness;
> +	cdev->max_brightness = 1;
> +	init_data.devicename = dev_name(&phydev->mdio.dev);
> +	init_data.fwnode = of_fwnode_handle(led);
> +
> +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);

Since init_data.devname_mandatory is false, devicename is ignored.
Which is probably good, becuse the device name of a mdio device is
often ugly, taken from devicetree or switch drivers, for example:
  f1072004.mdio-mii
  fixed-0
  mv88e6xxx-1
So either don't fill devicename or use devname_mandatory (and maybe
fill devicename with something less ugly, but I guess if we don't have
much choice if we want to keep persistent names).

Without devname_mandatory, the name of the LED classdev will be of the
form
  color:function[-function-enumerator],
i.e.
  green:lan
  amber:lan-1

With multiple switch ethenret ports all having LAN function, it is
worth noting that the function enumerator must be explicitly used in the
devicetree, otherwise multiple LEDs will be registered under the same
name, and the LED subsystem will add a number at the and of the name
(function led_classdev_next_name), resulting in names
  green:lan
  green:lan_1
  green:lan_2
  ...
These names are dependent on the order of classdev registration.

Marek
