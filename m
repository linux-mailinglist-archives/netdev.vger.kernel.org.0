Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718096D04F0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjC3Miw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjC3Mig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:38:36 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5072C72BA;
        Thu, 30 Mar 2023 05:38:34 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EE1A824000E;
        Thu, 30 Mar 2023 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680179911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCYhB/ohRuc+DVtWM6806sL+h/G0zdL7RlQsyRs9dkA=;
        b=l6iJoOIeUNqwhp9BRmerGiqKLGaatcZ4QREzrooUEyGMsdx06XkudItjqEgzcjDHnu0geT
        GHHOHTxoNvrEPVv3bIeMpJSCJvqULxICQZIvYoB+ZeO7hJh7I1EM2NR1H/PHgiqKN+NSeH
        4Pl7Qg9yACQV2DmYZqAxOAblg+wkOzuaE4Z4x0/ThPWwvK/IkcvRCkN6ZnWRIPtvXpPUwD
        /ra3v/Mn/giO+NoaNlctY669eBkpsyHc5s72uz74X9OLen9hNQMumEFo4Jqz5yT53V4uVk
        dnxTvCI1u1lsbgEzt/m9Ehnijgqm9KMunMnZ0uhl9OJ+C3LpViUlSzFhe7wxvQ==
Date:   Thu, 30 Mar 2023 14:38:24 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308230321.liw3v255okrhxg6s@skbuf>
        <20230310114852.3cef643d@kmaincent-XPS-13-7390>
        <20230310113533.l7flaoli7y3bmlnr@skbuf>
        <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
        <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
        <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
        <20230313084059.GA11063@pengutronix.de>
        <20230316160920.53737d1c@kmaincent-XPS-13-7390>
        <20230317152150.qahrr6w5x4o3eysz@skbuf>
        <20230317120744.5b7f1666@kernel.org>
        <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Max,

On Fri, 17 Mar 2023 13:43:34 -0600
Max Georgiev <glipus@gmail.com> wrote:

> Jakub,
>=20
> I started working on a patch introducing NDO functions for hw
> timestamping, but unfortunately put it on hold.
> Let me finish it and send it out for review.

What is your timeline for it? Do you think of sending it in the followings
weeks, months, years? If you don't have much time ask for help, I am not re=
ally
a PTP core expert but I would gladly work with you on this.

K=C3=B6ry
