Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11374DC692
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiCQMzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbiCQMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:54:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2727F1F1267
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD19DB81E8F
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43391C340E9;
        Thu, 17 Mar 2022 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647521545;
        bh=RaU//42Lpd6FXzCBzvOPkAh4rpsm9ZOcQNZlNPYLCNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FX/fgwAK9f6taffwXGSoolrh5Af2CWN5L2Tm7jY/tSdvaHxK07ijsqf6jyqlNLE0Z
         HNqnCfCbrfDrYCVHQzFON3MhBB4sMhAHTfgd7Mf3mh6dT+z24gfVeeeEcMHkzrb+a/
         DKT6qym6mAoKyehBN46A1l02unG+5Sbbz9hf43AD+/QB+/YhGwNZp+CfeW0ktHSNWS
         bPuCgWC3rT93urmGjEaK0AYBPlMNenpsMWGtUEma8NW6Pu9C5t7idk+FR38gNr+Pc9
         PjAiZSpz+tk+HeKTLXq/Qnp9HVXGc//jtAQnLY6kNvc25aZ0MKmb5riGt/eMaKuI+o
         gao5PFzCsygdQ==
Date:   Thu, 17 Mar 2022 13:52:20 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
Message-ID: <20220317135220.329610f7@dellmb>
In-Reply-To: <96f69525-53e1-f77e-e0f4-3146c2310551@denx.de>
References: <20220315074827.1439941-1-sr@denx.de>
        <20220315170929.5f509600@dellmb>
        <96f69525-53e1-f77e-e0f4-3146c2310551@denx.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 07:43:52 +0100
Stefan Roese <sr@denx.de> wrote:

> On 3/15/22 17:09, Marek Beh=C3=BAn wrote:
> > On Tue, 15 Mar 2022 08:48:27 +0100
> > Stefan Roese <sr@denx.de> wrote:
> >  =20
> >> From: Leszek Polak <lpolak@arri.de>
> >>
> >> As per Errata Section 5.1, if EEE is intended to be used, some register
> >> writes must be done once after every hardware reset. This patch now ad=
ds
> >> the necessary register writes as listed in the Marvell errata.
> >>
> >> Without this fix we experience ethernet problems on some of our boards
> >> equipped with a new version of this ethernet PHY (different supplier).
> >>
> >> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> >> Rev. A0.
> >>
> >> Signed-off-by: Leszek Polak <lpolak@arri.de>
> >> Signed-off-by: Stefan Roese <sr@denx.de>
> >> Cc: Andrew Lunn <andrew@lunn.ch>
> >> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> >> Cc: Russell King <linux@armlinux.org.uk>
> >> Cc: David S. Miller <davem@davemloft.net>
> >> ---
> >>   drivers/net/phy/marvell.c | 42 +++++++++++++++++++++++++++++++++++++=
++
> >>   1 file changed, 42 insertions(+)
> >>
> >> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> >> index 2429db614b59..0f4a3ab4a415 100644
> >> --- a/drivers/net/phy/marvell.c
> >> +++ b/drivers/net/phy/marvell.c
> >> @@ -1179,6 +1179,48 @@ static int m88e1510_config_init(struct phy_devi=
ce *phydev)
> >>   {
> >>   	int err;
> >>  =20
> >> +	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
> >> +	 * 88E1514 Rev A0, Errata Section 5.1:
> >> +	 * If EEE is intended to be used, the following register writes
> >> +	 * must be done once after every hardware reset.
> >> +	 */
> >> +	err =3D marvell_set_page(phydev, 0x00FF);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 17, 0x214B);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 16, 0x2144);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 17, 0x0C28);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 16, 0x2146);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 17, 0xB233);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 16, 0x214D);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 17, 0xCC0C);
> >> +	if (err < 0)
> >> +		return err;
> >> +	err =3D phy_write(phydev, 16, 0x2159);
> >> +	if (err < 0)
> >> +		return err; =20
> >=20
> > Can you please create a static const struct and then do this in a for
> > cycle? Somethign like this
> >=20
> > static const struct { u16 reg17, reg16; } errata_vals =3D {
> >    { 0x214B, 0x2144 }, ...
> > };
> >=20
> > for (i =3D 0; i < ARRAY_SIZE(errata_vals); ++i) {
> >    err =3D phy_write(phydev, 17, errata_vals[i].reg17);
> >    if (err)
> >      return err;
> >    err =3D phy_write(phydev, 16, errata_vals[i].reg16);
> >    if (err)
> >      return err;
> > } =20
>=20
> I could do this, sure. But frankly I'm not so sure, if this really
> improves the code much. This list will most likely never be extended.
> And in this current version, it's easier to compare the values written
> with the one described in the errata.
>=20
> But again, I have no hard feeling here. If it's the general option to
> move to the "loop version", then I'll gladly send an updated patch
> version.

I always try to do something like that. Look for example at

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/net/dsa/mv88e6xxx/serdes.c?h=3Dv5.17-rc8#n1417

Marek
