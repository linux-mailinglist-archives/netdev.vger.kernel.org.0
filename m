Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50D26B464B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjCJOlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjCJOlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:41:42 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B392A11F617;
        Fri, 10 Mar 2023 06:41:38 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E899F20004;
        Fri, 10 Mar 2023 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678459297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pUUgqFNlw24KGZBRs7B+tm6wf/ckBW4bRKWkK0IV5qc=;
        b=dkeyz0iftQK3fyQh6Ez4a61Wt+8pzqScxpLUL+5GznGPOhydR0DJ9JWely5kKlWH97Dz/b
        9rFEXI1DMZArRyMCRUas2PyYd6k7Yz3FoCXBbkC7IM7eZLuZSP3IwcEB2paeRAT/644Bfu
        yvNFZ7lYYMVUP0Zs6xGKFAi1+Umb22diGTyeMaY9Ho9CkbMyXHW/KYEeJEEAGQB4vM5xPS
        cv3TJ+dT1b+agqvZs28JKwn2y2F8/pJDrHHCtq7P3oCBom2+jJaiu/cUFASiKzqBNxVs8z
        FtSOZvV7+HffS8cxKX137Q9yS8/Wb8N4mTUeN76riK2KDVFCUsFYkA1HIOPZ4Q==
Date:   Fri, 10 Mar 2023 15:41:25 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <20230310154125.696a3eb3@kmaincent-XPS-13-7390>
In-Reply-To: <6408a9b3c7ae1_13061c2082a@willemb.c.googlers.com.notmuch>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
        <20230308135936.761794-4-kory.maincent@bootlin.com>
        <6408a9b3c7ae1_13061c2082a@willemb.c.googlers.com.notmuch>
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

On Wed, 08 Mar 2023 10:28:51 -0500
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> > =20
> > +	enum timestamping_layer selected_timestamping_layer;
> > + =20
>=20
> can perhaps be a single bit rather than an enum

I need at least two bits to be able to list the PTPs available.
Look at the ethtool_list_ptp function of the second patch.

> > +			err =3D -ENODEV;
> > +			WARN_ON(1); =20
>=20
> Please no WARN_ON on error cases that are known to be reachable
> and can be handled safely and reported to userspace.

Alright, thanks.

K=C3=B6ry
