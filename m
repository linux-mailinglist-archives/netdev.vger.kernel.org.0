Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1F6B3EEF
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCJMPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCJMPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:15:23 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C035AEE282;
        Fri, 10 Mar 2023 04:15:20 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 8AC87B8B;
        Fri, 10 Mar 2023 13:15:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678450516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksiA2zxyIIXuXWaNTFlfyJw/hUgGVKsFuq59jCd+r4E=;
        b=fltrcmQT6B8k+hGlfi2WLwYDjB4aso1Sxu7yQmAcnzym7FKHneedP+v7hh6fUsPgFckTKL
        DwXrSPEmHUjiZrFszRh8cSOvUWEFjZZSsIixknhPpNd0MTU42iu9gN7HE6gNyRO9O7dY4H
        bgUyv+RGv+/MindDlMxveDV3SAwmEQpmoyJVaJeYJwJWGwf9FhL8iGAHa1aNWLcPG8cdKS
        xkn5FyA0BbYtExxnDNDwldGjmVG8aRIWquF3OwnD2ohKeeAvGJcjsgwqqcOPRIpIl0izdV
        e18jtYFCm+BjUelIJBKpxNpwKqYf9fdTcHMlXQwfnrmhCZKZor9Z5bw8tXFcqg==
MIME-Version: 1.0
Date:   Fri, 10 Mar 2023 13:15:16 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>,
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
In-Reply-To: <20230310113533.l7flaoli7y3bmlnr@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+ Horatiu]

Am 2023-03-10 12:35, schrieb Vladimir Oltean:
> On Fri, Mar 10, 2023 at 11:48:52AM +0100, Köry Maincent wrote:
>> > From previous discussions, I believe that a device tree property was
>> > added in order to prevent perceived performance regressions when
>> > timestamping support is added to a PHY driver, correct?
>> 
>> Yes, i.e. to select the default and better timestamp on a board.
> 
> Is there a way to unambiguously determine the "better" timestamping on 
> a board?
> 
> Is it plausible that over time, when PTP timestamping matures and,
> for example, MDIO devices get support for PTP_SYS_OFFSET_EXTENDED
> (an attempt was here: https://lkml.org/lkml/2019/8/16/638), the
> relationship between PTP clock qualities changes, and so does the
> preference change?
> 
>> > I have a dumb question: if updating the device trees is needed in order
>> > to prevent these behavior changes, then how is the regression problem
>> > addressed for those device trees which don't contain this new property
>> > (all device trees)?
>> 
>> On that case there is not really solution,
> 
> If it's not really a solution, then doesn't this fail at its primary
> purpose of preventing regressions?
> 
>> but be aware that CONFIG_PHY_TIMESTAMPING need to be activated to
>> allow timestamping on the PHY. Currently in mainline only few (3)
>> defconfig have it enabled so it is really not spread,
> 
> Do distribution kernels use the defconfigs from the kernel, or do they
> just enable as many options that sound good as possible?
> 
>> maybe I could add more documentation to prevent further regression
>> issue when adding support of timestamp to a PHY driver.
> 
> My opinion is that either the problem was not correctly identified,
> or the proposed solution does not address that problem.
> 
> What I believe is the problem is that adding support for PHY 
> timestamping
> to a PHY driver will cause a behavior change for existing systems which
> are deployed with that PHY.
> 
> If I had a multi-port NIC where all ports share the same PHC, I would
> want to create a boundary clock with it. I can do that just fine when
> using MAC timestamping. But assume someone adds support for PHY
> timestamping and the kernel switches to using PHY timestamps by 
> default.
> Now I need to keep in sync the PHCs of the PHYs, something which was
> implicit before (all ports shared the same PHC). I have done nothing
> incorrectly, yet my deployment doesn't work anymore. This is just an
> example. It doesn't sound like a good idea in general for new features
> to cause a behavior change by default.
> 
> Having identified that as the problem, I guess the solution should be
> to stop doing that (and even though a PHY driver supports timestamping,
> keep using the MAC timestamping by default).
> 
> There is a slight inconvenience caused by the fact that there are
> already PHY drivers using PHY timestamping, and those may have been
> introduced into deployments with PHY timestamping. We cannot change the
> default behavior for those either. There are 5 such PHY drivers today
> (I've grepped for mii_timestamper in drivers/net/phy).
> 
> I would suggest that the kernel implements a short whitelist of 5
> entries containing PHY driver names, which are compared against
> netdev->phydev->drv->name (with the appropriate NULL pointer checks).
> Matches will default to PHY timestamping. Otherwise, the new default
> will be to keep the behavior as if PHY timestamping doesn't exist
> (MAC still provides the timestamps), and the user needs to select the
> PHY as the timestamping source explicitly.
> 
> Thoughts?

While I agree in principle (I have suggested to make MAC timestamping
the default before), I see a problem with the recent LAN8814 PHY
timestamping support, which will likely be released with 6.3. That
would now switch the timestamping to PHY timestamping for our board
(arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt-8g.dts). I could
argue that is a regression for our board iff NETWORK_PHY_TIMESTAMPING
is enabled. Honestly, I don't know how to proceed here and haven't
tried to replicate the regression due to limited time. Assuming,
that I can show it is a regression, what would be the solution then,
reverting the commit? Horatiu, any ideas?

I digress from the original problem a bit. But if there would be such
a whitelist, I'd propose that it won't contain the lan8814 driver.

Other than that, I guess I have to put some time into testing
before it's too late.

-michael
