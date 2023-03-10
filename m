Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843286B42A7
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjCJOFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjCJOE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:04:56 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B1310C738;
        Fri, 10 Mar 2023 06:04:53 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EF22220008;
        Fri, 10 Mar 2023 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678457091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OLDH45p1qG8y4EdPpmyGB/Q5c9zloIChc2+wUWU2DFQ=;
        b=at+4MyMNlbycCZ9yplHkkHBQYpSdfxZylE3/YfdOhPm6DaihUBgNeWGVSOcWA8Jd1Q+sMo
        gyWOP70vq9jtmiLUHI+fDvxzQgU0qUPWjfqT4auPDB4r7lLDd/Ul9RELLEC0pOtfxi23Uk
        3YuOel2Uk0Lk90KaxD1yWzxHVrxNgN8iCKzzuBUdFMNjKTdtz3OJ81X7TRZYm52q0jWCjZ
        I6VV9WlyeYMdrB1OrNHShl/c44TUd7435qGt8LQPRUVJXcDsgpDij8HDC+eZfuAIsGA+CP
        gOF4EASefCiExwLFhbCahM4ofMElOvvWHtAkL8nOHrElMMT7QrLPxmBei3Jl3w==
Date:   Fri, 10 Mar 2023 15:04:36 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230310150436.40ed168d@kmaincent-XPS-13-7390>
In-Reply-To: <0d2304a9bc276a0d321629108cf8febd@walle.cc>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308230321.liw3v255okrhxg6s@skbuf>
        <20230310114852.3cef643d@kmaincent-XPS-13-7390>
        <20230310113533.l7flaoli7y3bmlnr@skbuf>
        <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
        <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
        <0d2304a9bc276a0d321629108cf8febd@walle.cc>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 14:34:07 +0100
Michael Walle <michael@walle.cc> wrote:

> >> > There is a slight inconvenience caused by the fact that there are
> >> > already PHY drivers using PHY timestamping, and those may have been
> >> > introduced into deployments with PHY timestamping. We cannot change =
the
> >> > default behavior for those either. There are 5 such PHY drivers today
> >> > (I've grepped for mii_timestamper in drivers/net/phy).
> >> >
> >> > I would suggest that the kernel implements a short whitelist of 5
> >> > entries containing PHY driver names, which are compared against
> >> > netdev->phydev->drv->name (with the appropriate NULL pointer checks).
> >> > Matches will default to PHY timestamping. Otherwise, the new default
> >> > will be to keep the behavior as if PHY timestamping doesn't exist
> >> > (MAC still provides the timestamps), and the user needs to select the
> >> > PHY as the timestamping source explicitly.
> >> >
> >> > Thoughts? =20
> >>=20
> >> While I agree in principle (I have suggested to make MAC timestamping
> >> the default before), I see a problem with the recent LAN8814 PHY
> >> timestamping support, which will likely be released with 6.3. That
> >> would now switch the timestamping to PHY timestamping for our board
> >> (arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt-8g.dts). I could
> >> argue that is a regression for our board iff NETWORK_PHY_TIMESTAMPING
> >> is enabled. Honestly, I don't know how to proceed here and haven't
> >> tried to replicate the regression due to limited time. Assuming,
> >> that I can show it is a regression, what would be the solution then,
> >> reverting the commit? Horatiu, any ideas?

Adding this whitelist will add some PHY driver specific name in the phy API
core.
Will it be accepted? Is it not better to add a "legacy_default_timestamping"
boolean in the phy_device struct and set it for these 5 PHY drivers?
Then move on the default behavior to MAC default timestamping on the otehr
cases.
=20
> >> I digress from the original problem a bit. But if there would be such
> >> a whitelist, I'd propose that it won't contain the lan8814 driver. =20
> >=20
> > I don't have anything against having a whitelist the PHY driver names. =
=20
>=20
> Yeah, but my problem right now is, that if this discussion won't find
> any good solution, the lan8814 phy timestamping will find it's way
> into an official kernel and then it is really hard to undo things.

Yes and we need to find a solution as the issue will raise at each new PHY =
PTP
support.

K=C3=B6ry
