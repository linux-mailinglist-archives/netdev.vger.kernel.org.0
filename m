Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582D76BF16F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQTHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCQTHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4698870;
        Fri, 17 Mar 2023 12:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04570612D1;
        Fri, 17 Mar 2023 19:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202BBC433D2;
        Fri, 17 Mar 2023 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679080066;
        bh=Gsdncf/qiu/s2AG5ocFRXuKmxU5etz+BAA6JXthNkTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MFBsmnKzMjA/SiIMAP6+w1lyl6U6PLUM+Tr45QLlarriW2iEsiPeBWtnWCDPxwCqi
         +h30c+vJ2b7w0fpMncEnnIENUBn/KCLqnGAHgRx6xPpGmiiqqFIVoDsdZ03QJCYtDj
         sbSuS9yp7fq8/vB8XjdqbN6qKMBg4uPlH330Qe1EuRQ7+/N22c13fU5fc3YNgqwW0d
         43MR3D4QsaM3t61vXj/+RFNvdmcmch4QtWbjw9pzyK9XcxrrY7rT1yxgHzz+DO21Qe
         HKoFfpDR4jy3tCbm5MjXlkrIecOugh8XT1WPe+V7oNcfoSvBxgI2Kf4Om6z0gzJuIF
         3kGO5nU55WPqQ==
Date:   Fri, 17 Mar 2023 12:07:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
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
        Marco Bonelli <marco@mebeim.net>,
        Max Georgiev <glipus@gmail.com>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230317120744.5b7f1666@kernel.org>
In-Reply-To: <20230317152150.qahrr6w5x4o3eysz@skbuf>
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308230321.liw3v255okrhxg6s@skbuf>
        <20230310114852.3cef643d@kmaincent-XPS-13-7390>
        <20230310113533.l7flaoli7y3bmlnr@skbuf>
        <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
        <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
        <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
        <20230313084059.GA11063@pengutronix.de>
        <20230316160920.53737d1c@kmaincent-XPS-13-7390>
        <20230317152150.qahrr6w5x4o3eysz@skbuf>
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

On Fri, 17 Mar 2023 17:21:50 +0200 Vladimir Oltean wrote:
> On Thu, Mar 16, 2023 at 04:09:20PM +0100, K=C3=B6ry Maincent wrote:
> > Was there any useful work that could be continued on managing timestamp=
 through
> > NDOs. As it seem we will made some change to the timestamp API, maybe i=
t is a
> > good time to also take care of this. =20
>=20
> Not to my knowledge. Yes, I agree that it would be a good time to add an
> NDO for hwtimestamping (while keeping the ioctl fallback), then
> transitioning as many devices as we can, and removing the fallback when
> the transition is complete.

I believe Max was looking into it - hi Max! Did you make much
progress? Any code you could share to build on?
