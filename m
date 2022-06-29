Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2173C55FC01
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiF2J2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiF2J2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6248439158
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECFEA61E1E
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B7FC34114;
        Wed, 29 Jun 2022 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656494879;
        bh=zIzhNyDC6fL9K9eUM/aov3cJHME6f/of4wgLpItd2wg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gL5d1pDXiFrYmG1vipwNaPNaeo24jSfkfosQHThuaPsHqY/kw7NisJebTx8Cap+aw
         xZLsVP8zkxiSWDbwbwR06IxiblOwZfCQ/HU19xiJWQ9O3TbNmYTpZTf5xqPofYt7y3
         K52iRF/WIsV/CzDHbLpaBb6Phvwl/viS/5Jy8CQfh74LTYWrtdiAlW7C8nw0JrmZGf
         ROtIHjc+8DIzb9dI5+xNXZwXC30i8U3ElT6vDoNbzT35rEdB9UfXrlP6nguAApbyyA
         L6IRhPrxCDPBGk6CDOrKXzC5f3EY6+nFMRpA4WbnHhDJ2RkN3KnfbnfoLEEbSGWb2M
         L74KvBGl1belQ==
Date:   Wed, 29 Jun 2022 11:27:50 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 0/4] net: dsa: always use phylink
Message-ID: <20220629112750.4e0ae994@thinkpad>
In-Reply-To: <Yrv8snvIChmoNPwh@lunn.ch>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
        <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
        <Yrv8snvIChmoNPwh@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 09:18:10 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > I should point out that if a DSA port can be programmed in software to
> > support both SGMII and 1000baseX, this will end up selecting SGMII
> > irrespective of what the hardware was wire-strapped to and how it was
> > initially configured. Do we believe that would be acceptable?  
> 
> I'm pretty sure the devel b board has 1000BaseX DSA links between its
> two switches. Since both should end up SGMII that should be O.K.
> 
> Where we potentially have issues is 1000BaseX to the CPU. This is not
> an issue for the Vybrid based boards, since they are fast Ethernet
> only, but there are some boards with an IMX6 with 1G ethernet. I guess
> they currently use 1000BaseX, and the CPU side of the link probably
> has a fixed-link with phy-mode = 1000BaseX. So we might have an issue
> there.

If one side of the link (e.g. only the CPU eth interface) has 1000base-x
specified in device-tree explicitly, the code should keep it at
1000base-x for the DSA CPU port...

Marek
