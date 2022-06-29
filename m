Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D95855FC42
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiF2Jmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiF2Jmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410543C73B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C372961E79
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF0FC34114;
        Wed, 29 Jun 2022 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656495764;
        bh=MEl0vg9GTCB5iXg1ZWtAa7qkI3VVbL6aXBPDXXd1xSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ku4zM1hZMTWeMyJZKMslPkCvvXCEFAJkTIz6pDjPwdMCsf9nY7EJCeDQ8eWaGPcgH
         xlv56tDnnqoP8pPaF+jxvZMkm3i8pUiPJqRZ2XNngSPxFJfy4ij3SuHEQBbNNgVg+z
         mBHvvGGEPfiSRrsHisVYsn2X4N1ShnXV6+EXeZyGHgIbhMnasQng4d1zB6BEihr+GD
         SMlED15lHbCbcIBj89X4NRo/+2FQqxMUjcR0uJjK1S5f4K2pCvQ08v/NRN5SyBjrBf
         RTB2I4OANA9jO9icOKynxJkJNTsCSvnT+OjErgLuJM/Lp3i8t98lELrQjjY53oO2bv
         UNwy0NTZ3lDEw==
Date:   Wed, 29 Jun 2022 11:42:35 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?UTF-8?B?xaBp?= =?UTF-8?B?cHJhZ2E=?= 
        <alsi@bang-olufsen.dk>, Claudiu Manoil <claudiu.manoil@nxp.com>,
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
Message-ID: <20220629114235.6110eed0@thinkpad>
In-Reply-To: <YrwcpDbmnYpfJuYM@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
        <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
        <Yrv8snvIChmoNPwh@lunn.ch>
        <20220629112750.4e0ae994@thinkpad>
        <YrwcpDbmnYpfJuYM@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 10:34:28 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Jun 29, 2022 at 11:27:50AM +0200, Marek Beh=C3=BAn wrote:
> > On Wed, 29 Jun 2022 09:18:10 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > > I should point out that if a DSA port can be programmed in software=
 to
> > > > support both SGMII and 1000baseX, this will end up selecting SGMII
> > > > irrespective of what the hardware was wire-strapped to and how it w=
as
> > > > initially configured. Do we believe that would be acceptable?   =20
> > >=20
> > > I'm pretty sure the devel b board has 1000BaseX DSA links between its
> > > two switches. Since both should end up SGMII that should be O.K.
> > >=20
> > > Where we potentially have issues is 1000BaseX to the CPU. This is not
> > > an issue for the Vybrid based boards, since they are fast Ethernet
> > > only, but there are some boards with an IMX6 with 1G ethernet. I guess
> > > they currently use 1000BaseX, and the CPU side of the link probably
> > > has a fixed-link with phy-mode =3D 1000BaseX. So we might have an iss=
ue
> > > there. =20
> >=20
> > If one side of the link (e.g. only the CPU eth interface) has 1000base-x
> > specified in device-tree explicitly, the code should keep it at
> > 1000base-x for the DSA CPU port... =20
>=20
> So does that mean that, if we don't find a phy-mode property in the cpu
> port node, we should chase the ethernet property and check there? This
> seems to be adding functionality that wasn't there before.

It wasn't there before, but it would make sense IMO.

1. if cpu port has explicit phy-mode, use that
2. otherwise look at the mode defined for peer
3. otherwise try to compute the best possible mode for both peers

Marek
