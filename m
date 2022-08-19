Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A55599B44
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348309AbiHSLr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348061AbiHSLr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:47:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF43FFFF52
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:47:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u6so272042eda.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=DCJuzy6zZ9t4eWTRXtzN5mvCox1a2Lta0khLHLZH4QY=;
        b=bdvkrsf9vGss6nm30qlp47n0W+aJ2u0uRsrhSItfGhXsg8TtupwBbZHQHoGSaWFsJd
         nIikD9mpIDQvsSuO+egdAHJ26NuGo/LeqvfWauXNVPq/B5aB0NV90X4+Vs0wXAse8GTw
         2413bVNh1+KDnq1JigkuJkCNqQ4AC7EDy9l6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DCJuzy6zZ9t4eWTRXtzN5mvCox1a2Lta0khLHLZH4QY=;
        b=L05V3i7+7mIVFdlEMFIvNapm6qAm/7lyX6D2KntYWn4fTxurPEE7OSt9QZUtBZpBSh
         e4H14I7+ysA5f9Vhx5lUVvctkOkDQRD45OMSCbPpV6b1v7cUTPwA62Skkoy9EO3iRhqU
         hpzF4FqysqMD11fK045RN7AxPYxUcf61CU30ipkg6hfJjw6+E0KuqRKNdp0bTnH4Jr25
         tg+Y3xxDMfWrm9pcJuGIXOW2dn42nL6W+mqF7dxnV8UzIyENV9qjIT1iAT7g5sx3pqJf
         5YjfQDwXgMNqNzTs0YBNTiP6gdlYRYUHRvX0YLFhNPWUcHjxt+BtnObaV+JLyDR3CCSb
         UrWQ==
X-Gm-Message-State: ACgBeo1BxGn9MXWHbbP1fP6NF5nh1qTWsIvQ1oRA5jcuUYujKxaRMXc5
        Q7ZOfgK6Goo8g9ONUyqSEeau2w==
X-Google-Smtp-Source: AA6agR76TRi6pkP8t344QyG4KilAUsbddNQWbibtKUzquCsk8WZLuVG+mqeTAROzwekAdRWAPqE5dA==
X-Received: by 2002:a05:6402:289e:b0:445:f327:1c14 with SMTP id eg30-20020a056402289e00b00445f3271c14mr5866013edb.394.1660909674265;
        Fri, 19 Aug 2022 04:47:54 -0700 (PDT)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id ks11-20020a170906f84b00b00722d5b26ecesm2181173ejb.205.2022.08.19.04.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 04:47:53 -0700 (PDT)
Message-ID: <5c9aa2f3-689f-6dd7-ed26-de11e14f5ba0@rasmusvillemoes.dk>
Date:   Fri, 19 Aug 2022 13:47:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Craig McQueen <craig@mcqueen.id.au>,
        Tim Harvey <tharvey@gateworks.com>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk>
 <20220819105700.5a226titio5m2uop@skbuf>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <20220819105700.5a226titio5m2uop@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 12.57, Vladimir Oltean wrote:
> On Fri, Aug 19, 2022 at 12:19:12PM +0200, Rasmus Villemoes wrote:
>> Well, there's also e.g. arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
>> which sets the phy-mode but not the phy-handle:
>>
>>                         port@0 {
>>                                 reg = <0>;
>>                                 label = "lan1";
>>                                 phy-mode = "internal";
>>                         };
> 
> Yeah, it looks like there's also that variation, curious.
> 
>> And doing that in my case seems to fix things (I wouldn't know what
>> phy-handle to point at anyway), so since we're still in development, I
>> think I'll do that. But if I want to follow the new-world-order to the
>> letter, should I also figure out a way to point at a phy-handle?
> 
> So if by "new world order" you mean
> https://patchwork.kernel.org/project/netdevbpf/cover/20220818115500.2592578-1-vladimir.oltean@nxp.com/
> then no, that patch set doesn't change the requirements for *user* ports
> (what you have here) but for CPU and DSA ports, where no phy-handle/
> fixed-link/phy-mode means something entirely different than it means for
> user ports.

No, I meant the new world order as of the things merged into v5.19.
Which does seem to require an explicit phy-mode, and I'm happy to add that.

> To give you an idea of how things work for user ports. If a user port
> has a phy-handle, DSA will connect to that, irrespective of what OF-based
> MDIO bus that is on. If not, DSA looks at whether ds->slave_mii_bus is
> populated with a struct mii_bus by the driver. If it is, it connects in
> a non-OF based way to a PHY address equal to the port number. If
> ds->slave_mii_bus doesn't exist but the driver provides
> ds->ops->phy_read and ds->ops->phy_write, DSA automatically creates
> ds->slave_mii_bus where its ops are the driver provided phy_read and
> phy_write, and it then does the same thing of connecting to the PHY in
> that non-OF based way.

Thanks, that's quite useful. From quick grepping, it seems that ksz9567
currently falls into the latter category?

> So to convert a driver that currently relies on DSA allocating the
> ds->slave_mii_bus, you need to allocate/register it yourself (using the
> of_mdiobus_* variants), and populate ds->slave_mii_bus with it. Look at
> lan937x_mdio_register() for instance.
> 
> For existing device trees which connect in a non-OF based way, you still
> need to keep ds->ops->phy_read and ds->ops->phy_write, and let DSA
> create the ds->slave_mii_bus. The phy_read and phy_write can be the same
> between your MDIO bus ops and DSA's MDIO bus ops.
> 
>>> Fixes: 2c709e0bdad4 ("net: dsa: microchip: ksz8795: add phylink support")
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216320
>>> Reported-by: Craig McQueen <craig@mcqueen.id.au>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> I've also tested this patch on top of v5.19 without altering my .dts,
>> and that also seems to fix things, so I suppose you can add
>>
>> Fixes: 65ac79e18120 ("net: dsa: microchip: add the phylink get_caps")
>> Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> 
> So I don't intend to make you modify your device tree in this case, 

No, but it's actually easier for me to just do that rather than carry an
extra patch until the mainline fix hits 5.19.y.

but
> there is something to be said about U-Boot compatibility. In U-Boot,
> with DM_DSA, I don't intend to support any unnecessary complexity and
> alternative ways of describing the same thing, so there, phy-mode and
> one of phy-handle or fixed-link are mandatory for all ports. 

OK. I suppose that means the linux driver for the ksz9477 family  should
learn to check if there's an "mdio" subnode and if so populate
ds->slave_mii_bus, but unlike lan937x, absence of that node should not
be fatal?

And since
> U-Boot can pass its own device tree to Linux, it means Linux DSA drivers
> might need to gradually gain support for OF-based phy-handle on user
> ports as well. So see what Tim Harvey has done in drivers/net/ksz9477.c
> in the U-Boot source code, and try to work with his device tree format,
> as a starting point.

Hm. It does seem like that driver has the mdio bus optional (as in,
probe doesn't fail just because the subnode isn't present). But I'm
curious why ksz_probe_mdio() looks for a subnode called "mdios" rather
than "mdio". Tim, just a typo?

Thanks,
Rasmus
