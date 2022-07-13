Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9A57392E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbiGMOt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiGMOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA632613E;
        Wed, 13 Jul 2022 07:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9640561E0B;
        Wed, 13 Jul 2022 14:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4B2C3411E;
        Wed, 13 Jul 2022 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657723794;
        bh=ZJlaya3bj+MoS5OVPgQllizfALxL2/jWhyLEifRnbl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sSYaYXACNRKzzvzpT00ioaFUcDG5yM5b4gVemr0HubsMlIIQHRKNc3EpjjglmOE3Y
         ptn1xrd+m1KVimqL2OOtZ9mi3/Io4iYQcIYH1tvpmdFC7e50E1f9RC0jPEtuwmH2hs
         20Tfb1vaUMzfkVTP4xUWOCM4A1XsZ0WDIuh+chFPwecQhKOs18udPveRTzkXBNjnE7
         bWYtueeALl7mCWbqgXxrAzEjCaWREQ4cPhna6fybe/fafEp15HSxgSJV/tQE3kwPrB
         Z9JaGIK/xx4BxTTZQTBbZpbUjcjprY3mitu6s4f2avNaE6Q9ssmRIpFibNt2D6OVcN
         Pf3XAS9zAUPFw==
Date:   Wed, 13 Jul 2022 16:49:44 +0200
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
Subject: Re: [PATCH RFC net-next v2 6/6] net: dsa: mv88e6xxx: remove
 handling for DSA and CPU ports
Message-ID: <20220713164944.317f5d9b@thinkpad>
In-Reply-To: <E1oBd28-006UDF-6Q@rmk-PC.armlinux.org.uk>
References: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
        <E1oBd28-006UDF-6Q@rmk-PC.armlinux.org.uk>
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

On Wed, 13 Jul 2022 15:08:08 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> As we now always use a fixed-link for DSA and CPU ports, we no longer
> need the hack in the Marvell code to make this work. Remove it.
>=20
> This is especially important with the conversion of DSA drivers to
> phylink_pcs, as the PCS code only gets called if we are using
> phylink for the port.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
