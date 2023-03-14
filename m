Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6B6B90F0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjCNLDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjCNLDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:03:41 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AED94F59;
        Tue, 14 Mar 2023 04:03:03 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 94BFB60004;
        Tue, 14 Mar 2023 11:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678791782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/Pyrc+0j32Pzqpvqp9+RC0Fn57awaYC1GCTjBgB3BE=;
        b=E35BV4u/rvNkk1jpt3KjjcSW7YiDm71zn2609Vts5vOJAdALVB6KKxK1Z5LEjfKo8axqsJ
        8Jtk3bXVOAEWJgxoIVrr/8VyvkC6rlIUnhFEbadYz/SbG3PSlEmQ8qVCSReb+1y7DJSlS0
        THWBxU7Cs/nswRRwOe9aD4hc2nOenSxLYOZxJZ4Up/xj2esWq1F+DxNuKg5gQOdvHuhQRB
        iOkwLblWglILgeUhdlRU29ALeJjtotWYOTPy/m482SHxuf928etw36wWhK+RioznA0DBNS
        mJJV38a5giZI95Jn73lewGo8OEZpFRqzVOtbQ0DOEx3nrt82huzJFk6s5mkaMg==
Date:   Tue, 14 Mar 2023 12:02:54 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <20230314120254.76f8360c@kmaincent-XPS-13-7390>
In-Reply-To: <20230313084059.GA11063@pengutronix.de>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de>
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

On Mon, 13 Mar 2023 09:40:59 +0100
Oleksij Rempel <o.rempel@pengutronix.de> wrote:

> > But, as you point out, with K=C3=B6ry's/Richard's proposal, the MAC dri=
ver
> > will be bypassed when the selected timestamping layer is the PHY, and
> > that's a problem currently.
> >=20
> > May I suggest the following? There was another RFC which proposed the
> > introduction of a netdev notifier when timestamping is turned on/off:
> > https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean=
@nxp.com/
> >
> > If we have a notifier, then we can make switch drivers do things
> > differently. They can activate timestamping per se in the timestamping
> > NDO (which is only called when the MAC is the active timestamping layer=
),
> > and they can activate PTP traps in the netdev notifier (which is called
> > any time a timestamping status change takes place - the notifier info
> > should contain details about which net_device and timestamping layer
> > this is, for example).
> >=20
> > It's just a proposal of how to create an alternative notification path
> > that doesn't disturb the goals of this patch set.=20

I will take a look at your patch but indeed adding a timestamp notifier cou=
ld
be a good idea.

> To make things even more complicated - I  have a project where the DSA ma=
ster
> should be used for time stamping. Due to board specific limitations, we
> are forced to use FEC PHC instead of dsa KSZ switch PHC. So, it is not
> a choice between MAC and PHY, it is more the MAC before MAC and PHY.
> PTP sync in this case will have more jitter, but it still good enough
> for this project.
> Currently I use quick hack to do so, but mainlinamble solution working for
> most use cases will be nice.

In this case it is not a PHY/MAC PTP choice anymore but more a device
PTP choice which bring a lot more of complexity. Or maybe we could simply a=
dd a
"switch" timestamp layer later on. As Andrew said we will maybe increase the
number of timestamp layers in the future.

Regards,
K=C3=B6ry
