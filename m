Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBFB6C7C77
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 11:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjCXKZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 06:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCXKZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 06:25:51 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E64F1E1DF;
        Fri, 24 Mar 2023 03:25:48 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4FC82C0008;
        Fri, 24 Mar 2023 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679653546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xv+ASSzcWiUf7WB1UddjxDgaUpS6QjUv6DsxIIFvx1w=;
        b=hl9OoFksAO9preOhRLTIo0SONnDHJIuXFwghucu/pBPo3zaA7osCDq9AyGtyOmgSyN7XUF
        +XYru/MB6/vken94g5WLx5HB/V8xxCe3VeE7twcYrsqfHkcaExDaS26KALR2XI1mpvsl/K
        SnbXosRs/KVijDPH3N1QMSg2pOhC7DPj3HIlBnPwiFoIWtrP5g58l/sQDDWQoizMoh5KIi
        ZR+e4ZLGcvkR/rEbhkRnVjQ+p8dYyd8KHF0BnkvCJYfPy4TtSGtUPiuEEQA54LKByF3RwN
        GHmrTJo2TrFW5uU0uHvpJUykvz4siTYpY1Ro4ty8npHV9HAV+5PvnZptqZg1pg==
Date:   Fri, 24 Mar 2023 11:25:41 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
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
Message-ID: <20230324112541.0b3dd38a@pc-7.home>
In-Reply-To: <20230310113533.l7flaoli7y3bmlnr@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308230321.liw3v255okrhxg6s@skbuf>
        <20230310114852.3cef643d@kmaincent-XPS-13-7390>
        <20230310113533.l7flaoli7y3bmlnr@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
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

Hello everyone,

I'm sorry to intervene late in this discussion, but since it looks like
the discussion is converging towards the creation of a new API (though
NDOs internally, and through netlink for userspace), I'd like to add a
small other use-case to consider. Of course, this can be addressed
later on.

On Fri, 10 Mar 2023 13:35:33 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Mar 10, 2023 at 11:48:52AM +0100, K=C3=B6ry Maincent wrote:
> > > From previous discussions, I believe that a device tree property
> > > was added in order to prevent perceived performance regressions
> > > when timestamping support is added to a PHY driver, correct? =20
> >=20
> > Yes, i.e. to select the default and better timestamp on a board. =20
>=20
> Is there a way to unambiguously determine the "better" timestamping
> on a board?

I'd like to point out a series sent a while ago :

https://lore.kernel.org/netdev/3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.=
com/

Here, the MAC's timestamping unit can be configured in 2 ways, which
boils down to either more accurate timestamps, or better accuracy in
frequency adjustments for the clock.

The need is to be able to change this mode at runtime, as we can change
the clock source for the timestamping unit to a very precise-one,
therefore using the "accurate timestamps mode" working as a
grand-master, or switching to slave mode, where we would sacrifice a
little bit the timestamping precision to get better frequency
precision.

So, we can consider here that not only the MAC's timestamping unit has
a non-fixed precision, but if we go through the route a a new API,
maybe we can also take this case into account, allowing for a bit of
configuration of the timestamping unit from userspace?=20

> Is it plausible that over time, when PTP timestamping matures and,
> for example, MDIO devices get support for PTP_SYS_OFFSET_EXTENDED
> (an attempt was here: https://lkml.org/lkml/2019/8/16/638), the
> relationship between PTP clock qualities changes, and so does the
> preference change?

I'm not exactly familiar with PTP_SYS_OFFSET_EXTENDED, but it looks a
bit similar in purpose to the above-mentionned use-case.

Thanks,

Maxime
