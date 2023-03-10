Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0226B3CC2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCJKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjCJKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:49:06 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242FC5F6F8;
        Fri, 10 Mar 2023 02:49:03 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 00AF024000E;
        Fri, 10 Mar 2023 10:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678445342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXK5+wC62JoKME3nEZqOQhQA/bUpiBeggPC719tdP5s=;
        b=bitzjo8Zb6zDvux2zrRGEQ84tScQ0MOpBXj+QCPMgP91wvsg74WjMYBNS329LKZ5xnxIFk
        SW9/FpbbvA5/tr21em3NedjZNPyrbSR2Yp8p0AfXHM0pIFFCVsg2aYkU/GgUbPOPE0hVfi
        F6ZLSh/Ask3v5rfDCcqmcdDWAaFuE0QnopZ7OzVj7HE0LNJTp57qq3xkKEzn2MMq4k5AJM
        PZTROOQMFGqa7cbSl51g+s6p3XGZfZWQIeIxfxx124wqsph9vYmqaOXVWhvZO14LC7mvpe
        RHSu2VJfH0URGTFQjAhSk4tBNSda4GB8DseTH8f1yO56jjfG2QPr957bw6kfaQ==
Date:   Fri, 10 Mar 2023 11:48:52 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
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
Message-ID: <20230310114852.3cef643d@kmaincent-XPS-13-7390>
In-Reply-To: <20230308230321.liw3v255okrhxg6s@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <20230308230321.liw3v255okrhxg6s@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

On Thu, 9 Mar 2023 01:03:21 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> (trimmed CC list of bouncing email addresses)
 =20
Thanks, I will be more careful on next patch series version.
=20
> From previous discussions, I believe that a device tree property was
> added in order to prevent perceived performance regressions when
> timestamping support is added to a PHY driver, correct?

Yes, i.e. to select the default and better timestamp on a board.
=20
> I have a dumb question: if updating the device trees is needed in order
> to prevent these behavior changes, then how is the regression problem
> addressed for those device trees which don't contain this new property
> (all device trees)?

On that case there is not really solution, but be aware that
CONFIG_PHY_TIMESTAMPING need to be activated to allow timestamping on the P=
HY.
Currently in mainline only few (3) defconfig have it enabled so it is really
not spread, maybe I could add more documentation to prevent further regress=
ion
issue when adding support of timestamp to a PHY driver.

Regards,
K=C3=B6ry
