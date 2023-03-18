Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D956BF7A7
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCREDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BB82ED4B;
        Fri, 17 Mar 2023 21:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F69BB826CF;
        Sat, 18 Mar 2023 04:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43718C433EF;
        Sat, 18 Mar 2023 04:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679112188;
        bh=H9EbyS8K2S7SEq58TANWWZRpHx5Rzyfkt1/MmniP7Eg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dzCyC/t0ucqwZiPYsI/y1BnpT99ixyXeiddt04Scm19lvYn3jXZb9Y1usopVeCZHJ
         l8B6vmG13rnDPH0IdYDA+QcfdkyDN7NkEdoxACGJTLa6NNe3hpsHF2u9cVr5IOMdce
         IztO0e609CIacl8mH4jg1ec1wg2h2v/yUHc1JzpuB23q7jQWP/Bn4IOmBv8G8cLbNX
         eLmGSBwbBA891x9enuLuWk1gXgLtT/2kld9uow1Qv7aShJCtsoQl4WrzH7AVdlN9q2
         LIIap4IBKbteH/UO8t2ZzN+w4G9SSxT3cBOYkws31Rhi2rx+EQWGtGktkfsJBQCdJ8
         BvqZfheduJicg==
Date:   Fri, 17 Mar 2023 21:03:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
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
Message-ID: <20230317210306.346e80ea@kernel.org>
In-Reply-To: <ZBUyST3kDP1ZE1lF@hoboy.vegasvil.org>
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
        <ZBUyST3kDP1ZE1lF@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 20:38:49 -0700 Richard Cochran wrote:
> On Fri, Mar 17, 2023 at 05:21:50PM +0200, Vladimir Oltean wrote:
> > On Thu, Mar 16, 2023 at 04:09:20PM +0100, K=C3=B6ry Maincent wrote: =20
> > > Was there any useful work that could be continued on managing timesta=
mp through
> > > NDOs. As it seem we will made some change to the timestamp API, maybe=
 it is a
> > > good time to also take care of this. =20
> >=20
> > Not to my knowledge. Yes, I agree that it would be a good time to add an
> > NDO for hwtimestamping (while keeping the ioctl fallback), then
> > transitioning as many devices as we can, and removing the fallback when
> > the transition is complete. =20
>=20
> Um, user space ABI cannot be removed.

NDO meaning a dedicated callback in struct net_device_ops, so at least
for netdevs we can copy the data from user space, validate in the core
and then call the driver with a normal kernel pointer. So just an
internal refactoring, no uAPI changes.
