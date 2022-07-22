Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EED57E2F4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 16:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiGVOTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 10:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiGVOTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 10:19:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F8A7226;
        Fri, 22 Jul 2022 07:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F8D62081;
        Fri, 22 Jul 2022 14:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC1BC341C6;
        Fri, 22 Jul 2022 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658499554;
        bh=MgM+cMYk0Gwmsorh6Dk3GwZiuKflFl6TUd0K9p3ouY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tk+CA2QiUv36zE/2P71sfKE8mgSSzorJmuK4eGnDVWK+KOUE/+4XO5atBa5trjoOj
         cX9Y6OP+ZLMBGOweqfMsnYrU9JV525ddvk8aL/pXlv0nM5YLrewVkaD2BejT8RGjAd
         Sa30cmL5iy3nwEJ6atHxstiOpPcWpluwd49AHp6Jyzbj/594tGCtZOBRhbaLfWTB65
         Q8Vj2x5i8hhTgVSpnf8+7YxT7rD5Te9OXPAhw9HWkPmbfPSp6kryu2V56YMepFWThm
         szunL7kxT3osMyMyyyzlUXQz/ihcKjbqH0qQvVuBLAm5sZOnaPUeyRdlVeI+B8PZim
         fvQtP9ucycmxA==
Date:   Fri, 22 Jul 2022 16:19:05 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220722161905.5d54685d@dellmb>
In-Reply-To: <YtqkxklImfR9gW1Z@shell.armlinux.org.uk>
References: <20220716123608.chdzbvpinso546oh@skbuf>
        <YtUec3GTWTC59sky@shell.armlinux.org.uk>
        <20220720224447.ygoto4av7odsy2tj@skbuf>
        <20220721134618.axq3hmtckrumpoy6@skbuf>
        <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
        <20220721151533.3zomvnfogshk5ze3@skbuf>
        <20220721192145.1f327b2a@dellmb>
        <20220721192145.1f327b2a@dellmb>
        <20220721182216.z4vdaj4zfb6w3emo@skbuf>
        <20220722145936.497ac73f@dellmb>
        <YtqkxklImfR9gW1Z@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 14:23:18 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Fri, Jul 22, 2022 at 02:59:36PM +0200, Marek Beh=C3=BAn wrote:
> >   The 2.5GBASE-X PCS does not support Clause 37 Auto-Negotiation.
> >   Hence, the 1000BASE-X PCS is expected to have its Clause 37
> >   Auto-Negotiation functionality disabled so that the /C/ ordered set
> >   will not be transmitted. If a 2.5GBASE-X PCS receives /C/ ordered
> >   set, then undefined behavior may occur.
> >   ... =20
>=20
> The reason that's probably stated is because there hasn't been any
> standardisation of it, different implementations behave differently,
> so they can't define a standard behaviour without breaking what's
> already out there.

I think they are also considering clause 73 AN, which is supported with
1000base-KX (if I am not mistaken). Maybe the intention was to use
clause 73 with >1G speeds, and so they've forbid clause 37 on
2500base-x.

