Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962586D408F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjDCJ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjDCJ1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:27:21 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B416919B4;
        Mon,  3 Apr 2023 02:27:17 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E166240019;
        Mon,  3 Apr 2023 09:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680514035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDTA5M0TPTdxazkjSb14CfP6TBrXBGZGlLYwzOvQD1Q=;
        b=Rj7qgoRWo77w1eixf97yibFJqGOVzruQFnRqYeJrwQOEaKrZK91izbnm1xCSwgLaTrZzGF
        f2KUZIg3GDP3YiEHAjOReM6DsVLuxXGg1X650YFUQ3ACdOyFKIJzYAnkzxzz7TR5pwH95c
        3XpI64BNPyHSM2qt4JncDZ41eE+lTrhqqhexTnJAEw/uMdDV6PhuhiYfLFp3qIorxca+Rs
        dBgpVCmo6cH3T38ugemL0x45W6RirrQWfVtF9sCQvY8e4OWP/ZEyxoIlIKNpoZP6b0n6um
        SK8kjGphtZ6qoYKvHeCAYTql449Lyb2HcYD8TU8TNVWjXRHQjq4xPRyRmHRmQw==
Date:   Mon, 3 Apr 2023 11:27:02 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Max Georgiev <glipus@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20230403112702.46e03c37@kmaincent-XPS-13-7390>
In-Reply-To: <20230402171249.ntszn3wwvkjuyesg@skbuf>
References: <20230310113533.l7flaoli7y3bmlnr@skbuf>
        <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
        <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
        <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
        <20230313084059.GA11063@pengutronix.de>
        <20230316160920.53737d1c@kmaincent-XPS-13-7390>
        <20230317152150.qahrr6w5x4o3eysz@skbuf>
        <20230317120744.5b7f1666@kernel.org>
        <CAP5jrPHep12hRbbcb5gXrZB5w_uzmVpEp4EhpfqW=9zC+zcu9A@mail.gmail.com>
        <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
        <20230402171249.ntszn3wwvkjuyesg@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Apr 2023 20:12:49 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Thu, Mar 30, 2023 at 02:38:24PM +0200, K=C3=B6ry Maincent wrote:
> > Hello Max,
> >=20
> > On Fri, 17 Mar 2023 13:43:34 -0600
> > Max Georgiev <glipus@gmail.com> wrote:
> >  =20
> > > Jakub,
> > >=20
> > > I started working on a patch introducing NDO functions for hw
> > > timestamping, but unfortunately put it on hold.
> > > Let me finish it and send it out for review. =20
> >=20
> > What is your timeline for it? Do you think of sending it in the followi=
ngs
> > weeks, months, years? If you don't have much time ask for help, I am not
> > really a PTP core expert but I would gladly work with you on this. =20
>=20
> K=C3=B6ry, I believe you can start looking at that PHY driver whitelist
> (for changing the default timestamping layer) in parallel with Maxim's
> ndo_hwtstamp_set() effort, since they shouldn't depend on each other?

Yes, that's true. I will also update the change from ioctl to netlink to ha=
ndle
the PTP layer selection.

K=C3=B6ry
