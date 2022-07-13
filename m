Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C05573917
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiGMOn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbiGMOn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874F8357C0;
        Wed, 13 Jul 2022 07:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2531461DB4;
        Wed, 13 Jul 2022 14:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF853C34114;
        Wed, 13 Jul 2022 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657723405;
        bh=OMC/8S6LiF+qzzd+fptFo0oW68RWQkcm1BdUkffx2BE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEOavb3jOPgiLiP0dPxNj9Nnnp5eKx0WU9oEANNElWh2f1LJthjt+UzPLE80jWLFd
         UjJj4vgFwP/49WeGfgFlZUW44Qbyrm6pOc9w12Yabn46070+I3eI1NAjUB+acaWJ4d
         lSa92zMDWWCwYzzHdCmzGu6zj55gknpc9RX6u6c0tQ4VWA9B+ZL1wRDKQ8y2vG/Ero
         QPVYHTFOi9AQHimUWXIA/BpyDM8MjPA87F9YFUablsGtCq5kUbiyUyUq60EpENR35s
         fYVmhFfQ4WiiZjzIuU0kxtcRd1x6E21VDCqCwt2JE0p1bViNTyNfgIPw0Od+QVkL+C
         Xhp+IWey6EImA==
Date:   Wed, 13 Jul 2022 16:43:14 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next v2 2/6] software node: allow named software
 node to be created
Message-ID: <20220713164314.6c813e26@thinkpad>
In-Reply-To: <E1oBd1n-006UCq-JK@rmk-PC.armlinux.org.uk>
References: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
        <E1oBd1n-006UCq-JK@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 15:07:47 +0100
Russell King (Oracle) <rmk+kernel@armlinux.org.uk> wrote:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Allow a named software node to be created, which is needed for software
> nodes for a fixed-link specification for DSA.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
