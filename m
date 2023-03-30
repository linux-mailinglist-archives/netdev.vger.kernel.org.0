Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C686D0B02
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjC3Q04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjC3Q0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1EC159;
        Thu, 30 Mar 2023 09:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496AA620FB;
        Thu, 30 Mar 2023 16:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D38C433D2;
        Thu, 30 Mar 2023 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680193613;
        bh=OTht3a35wO9ZxOdDuztv9uVBcSe4Zhlcnodcxs7W1WM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XvgMvf6FdRDzWddB6VRohM5pC+Uj0wFELzD+Z6dy0Qt/Rh2tw0Pt+KGa2GnPr4owc
         LDj3IFQMi0BqJQqT19paE2ytsuYa+Vj5MUZpmiFEe6kx7e6/o/tsWdAyewr+nGSvk5
         x6ohs7C7r66BUVk82fDEL7274i+Qupy0Qt6Glyo1xbatObsoOA3UX0XFXbu/8DThY0
         1o3mxJgKDeF5P6SpeGxjVCujWhUjY2zzrLOoi4PKrwQA8O6c+Ud2zPhH6eAD6obHI0
         xRmjUFxQplfm+NzytrBeZ3C8F77a6ajgoLM5ynqwmeXLdoUEG0yJDpyhzuVke97g/I
         GICTG0rfsh2Pw==
Date:   Thu, 30 Mar 2023 09:26:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Max Georgiev <glipus@gmail.com>,
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
Message-ID: <20230330092651.4acb7b64@kernel.org>
In-Reply-To: <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
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
        <20230330143824.43eb0c56@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 14:38:24 +0200 K=C3=B6ry Maincent wrote:
> > I started working on a patch introducing NDO functions for hw
> > timestamping, but unfortunately put it on hold.
> > Let me finish it and send it out for review. =20
>=20
> What is your timeline for it? Do you think of sending it in the followings
> weeks, months, years? If you don't have much time ask for help, I am not =
really
> a PTP core expert but I would gladly work with you on this.

+1 Max, could you push what you have to GitHub or post as an RFC?
