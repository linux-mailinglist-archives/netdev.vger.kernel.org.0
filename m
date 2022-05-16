Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531B15280DB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiEPJ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiEPJ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2BB212
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 02:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A9961275
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 09:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF09C385AA;
        Mon, 16 May 2022 09:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652693160;
        bh=h2BbS+9SvL4VsMlHgvZCCpsBsXkHzRPWk2kMp1zh4J8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IWnVlYPEQVHnAqYrTt7fuBANKHViO7nl8LzIem/UZGOppDbH1SW4IY0A702pljBCo
         MOsZ3GY1VWjhgM+d+gEQ6oVDbLxjYCJXJn1XdqVPaNxFaYdlNbyey3du29Rxa7z30v
         mmr5JFO0JIYM5Y/TmV43347lVmDtNmo2NVLTe8LvazCWHtLqF5ieoQtIvBuDjR94HB
         Cm1n4ANz7z5q9wH5g0KPxJy7lDFpXknjvXnb0ipWDfxdikf0nO5AB68KabsQ3iSBRI
         FpXFqRQqn2LbWrVzJF2CiRiDxHOzZb5vfBYCg4K8GpVd0d/TVXRtbf6PDgoirjJ8Ax
         igqw1c5LROeNw==
Date:   Mon, 16 May 2022 11:25:55 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, Leszek Polak <lpolak@arri.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
Message-ID: <20220516112555.3ed37e74@thinkpad>
In-Reply-To: <20220516070859.549170-1-sr@denx.de>
References: <20220516070859.549170-1-sr@denx.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 09:08:59 +0200
Stefan Roese <sr@denx.de> wrote:

> From: Leszek Polak <lpolak@arri.de>
>=20
> As per Errata Section 5.1, if EEE is intended to be used, some register
> writes must be done once after every hardware reset. This patch now adds
> the necessary register writes as listed in the Marvell errata.
>=20
> Without this fix we experience ethernet problems on some of our boards
> equipped with a new version of this ethernet PHY (different supplier).
>=20
> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> Rev. A0.
>=20
> Signed-off-by: Leszek Polak <lpolak@arri.de>
> Signed-off-by: Stefan Roese <sr@denx.de>
> Cc: Marek Beh=C3=BAn <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>
> ---
> v2:
> - Implement struct with errata reg values and loop over this
>   struct instead of using single phy_write() call for each PHY
>   reg value, as suggested by Marek
>=20
>  drivers/net/phy/marvell.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>=20
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 2702faf7b0f6..41353f615a66 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1177,7 +1177,44 @@ static int m88e1318_config_init(struct phy_device =
*phydev)
> =20
>  static int m88e1510_config_init(struct phy_device *phydev)
>  {
> +	static const struct {
> +		u16 reg17, reg16;
> +	} errata_vals[] =3D {
> +		{ 0x214b, 0x2144 },
> +		{ 0x0c28, 0x2146 },
> +		{ 0xb233, 0x214d },
> +		{ 0xcc0c, 0x2159 },
> +	};
>  	int err;
> +	int i;
> +
> +	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
> +	 * 88E1514 Rev A0, Errata Section 5.1:
> +	 * If EEE is intended to be used, the following register writes
> +	 * must be done once after every hardware reset.
> +	 */
> +	err =3D marvell_set_page(phydev, 0x00FF);
> +	if (err < 0)
> +		return err;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(errata_vals); ++i) {
> +		err =3D phy_write(phydev, 17, errata_vals[i].reg17);
> +		if (err)
> +			return err;
> +		err =3D phy_write(phydev, 16, errata_vals[i].reg16);
> +		if (err)
> +			return err;
> +	}
> +
> +	err =3D marvell_set_page(phydev, 0x00FB);
> +	if (err < 0)
> +		return err;
> +	err =3D phy_write(phydev, 07, 0xC00D);
> +	if (err < 0)
> +		return err;
> +	err =3D marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
> +	if (err < 0)
> +		return err;
> =20
>  	/* SGMII-to-Copper mode initialization */
>  	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_SGMII) {

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
