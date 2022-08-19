Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664E6599A56
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348240AbiHSK5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347912AbiHSK5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:57:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E78F43A2
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:57:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id j8so8089201ejx.9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=dX02Rc+pN7+4qfFHJSGNknLuB0PW1+jk5FRBT7oR698=;
        b=pXEfaco/xXS451l4PZDCw3foOl+XsCgM9EbRVDjjQsDW7fbLbs2qs0EoGOUoBfntAP
         5XO3YIVo8Aki28letHd26V8Atjx1MsvqQCBcPywHF/TTSclIOxl0ruA1R/7Sqsk+vpb6
         y/v9G7PL/9yFiGoPAY/ElIELqIp20H7ReJw0GVBjfpUBAIoOl9DTcJ+UL2ttu9V5n2Gy
         LsrAZbJDz1EUolOUbDWfiTsMENgkBnyAqyaggEi0NoMqh07LHXdeROJH948xHKfIsf+F
         PI+2gR7m6G2gLD8cfdJh747tU0psOJKyJkHwMhNcJRff5yPXpzsVOThJY/2hCbTcIjAB
         4VlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dX02Rc+pN7+4qfFHJSGNknLuB0PW1+jk5FRBT7oR698=;
        b=KeBo5fo3NxuANf46rNJNOJbOcYUNAhB4hTQ37WCs7EaZ2Whkx6GXaAj3zv4kfIfayg
         1e18W/NaACMxsRff1QvHwUZCW+u22GCXxgMMkrQqj9wSHogkO3GqayLADrcb1lvnhr2e
         AwUcHt+70qVwBnpO9yI8D20yAg38d+5nOX46H14iYzynIRcuZaItz3BH2M5q6ixZxcSC
         xHeBwWySju8R15pYUX/R0jC+6wlf8GJQOWuszg09Ws++8tIk4Zm7hjG3D8p5ctt7AT17
         WuTSttL6weFjVaRVzw6V5SeX6QJLyTk87zxzS9WoaYOXYD3j4LnTDLaiy7dpVF5ZZSzD
         tsRQ==
X-Gm-Message-State: ACgBeo2UtUyE2ed6pnAN4TOu7MnzFdeonATkmte3YEE7cA3vyfVmcajO
        UQwp7UjM0q5wILtac3a9K2c=
X-Google-Smtp-Source: AA6agR4PUjZSJhI8qev1IduJx+dWs6yxTswj1L56h/JE2U8vaWrMcK7VMklffF4p/SBd16H3KKXzyQ==
X-Received: by 2002:a17:906:4796:b0:734:b5b5:96ed with SMTP id cw22-20020a170906479600b00734b5b596edmr4427487ejc.251.1660906624443;
        Fri, 19 Aug 2022 03:57:04 -0700 (PDT)
Received: from skbuf ([188.25.231.48])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906319800b007373afafa41sm2164283ejy.188.2022.08.19.03.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 03:57:03 -0700 (PDT)
Date:   Fri, 19 Aug 2022 13:57:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Message-ID: <20220819105700.5a226titio5m2uop@skbuf>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 12:19:12PM +0200, Rasmus Villemoes wrote:
> Well, there's also e.g. arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
> which sets the phy-mode but not the phy-handle:
> 
>                         port@0 {
>                                 reg = <0>;
>                                 label = "lan1";
>                                 phy-mode = "internal";
>                         };

Yeah, it looks like there's also that variation, curious.

> And doing that in my case seems to fix things (I wouldn't know what
> phy-handle to point at anyway), so since we're still in development, I
> think I'll do that. But if I want to follow the new-world-order to the
> letter, should I also figure out a way to point at a phy-handle?

So if by "new world order" you mean
https://patchwork.kernel.org/project/netdevbpf/cover/20220818115500.2592578-1-vladimir.oltean@nxp.com/
then no, that patch set doesn't change the requirements for *user* ports
(what you have here) but for CPU and DSA ports, where no phy-handle/
fixed-link/phy-mode means something entirely different than it means for
user ports.

To give you an idea of how things work for user ports. If a user port
has a phy-handle, DSA will connect to that, irrespective of what OF-based
MDIO bus that is on. If not, DSA looks at whether ds->slave_mii_bus is
populated with a struct mii_bus by the driver. If it is, it connects in
a non-OF based way to a PHY address equal to the port number. If
ds->slave_mii_bus doesn't exist but the driver provides
ds->ops->phy_read and ds->ops->phy_write, DSA automatically creates
ds->slave_mii_bus where its ops are the driver provided phy_read and
phy_write, and it then does the same thing of connecting to the PHY in
that non-OF based way.

So to convert a driver that currently relies on DSA allocating the
ds->slave_mii_bus, you need to allocate/register it yourself (using the
of_mdiobus_* variants), and populate ds->slave_mii_bus with it. Look at
lan937x_mdio_register() for instance.

For existing device trees which connect in a non-OF based way, you still
need to keep ds->ops->phy_read and ds->ops->phy_write, and let DSA
create the ds->slave_mii_bus. The phy_read and phy_write can be the same
between your MDIO bus ops and DSA's MDIO bus ops.

> > Fixes: 2c709e0bdad4 ("net: dsa: microchip: ksz8795: add phylink support")
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216320
> > Reported-by: Craig McQueen <craig@mcqueen.id.au>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I've also tested this patch on top of v5.19 without altering my .dts,
> and that also seems to fix things, so I suppose you can add
> 
> Fixes: 65ac79e18120 ("net: dsa: microchip: add the phylink get_caps")
> Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

So I don't intend to make you modify your device tree in this case, but
there is something to be said about U-Boot compatibility. In U-Boot,
with DM_DSA, I don't intend to support any unnecessary complexity and
alternative ways of describing the same thing, so there, phy-mode and
one of phy-handle or fixed-link are mandatory for all ports. And since
U-Boot can pass its own device tree to Linux, it means Linux DSA drivers
might need to gradually gain support for OF-based phy-handle on user
ports as well. So see what Tim Harvey has done in drivers/net/ksz9477.c
in the U-Boot source code, and try to work with his device tree format,
as a starting point.
