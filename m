Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8F634976C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCYQ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhCYQ4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 12:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78F9961A1E;
        Thu, 25 Mar 2021 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616691393;
        bh=wRaAhLbh9NCbtCyYhkmo3GWSVY0PKP/VKh1PPalCLQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ykc3aQxKdPkFUY9o30U1Dx0+ACkFptR9D2p8CRnaHOyOOCfC7Ic0Ond8Af7QS8i6I
         FkaWUCHDFmdeKMUIuwUIWwfj2uRzitDW2R7j0wWPJUh4bigGzW4Xwv0OxSJrVMJKsh
         DXZ/YoXHDdVpzasxhiiaUUO0gX+fLozz0PjGiEr9aLvDkLuHfx/GDcwn0nY7uJ3+IV
         z3Li1stcHmHU9TfTv0VYqk4iwVht8Bra+Sp2fxGT7ZXQ6YL8wrYqx4zoOP++4X0K/u
         nOlXNPbRBliYLG4U98fz/G8EPMPToCpi/gK18oYcMFLO6G1aRbPopCz4zjZchin1uS
         YTHK+zGowi0kA==
Date:   Thu, 25 Mar 2021 17:56:29 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact
 model
Message-ID: <20210325175629.7e670f34@thinkpad>
In-Reply-To: <20210325155452.GO1463@shell.armlinux.org.uk>
References: <20210325131250.15901-1-kabel@kernel.org>
        <20210325131250.15901-12-kabel@kernel.org>
        <20210325155452.GO1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 15:54:52 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Thu, Mar 25, 2021 at 02:12:49PM +0100, Marek Beh=C3=BAn wrote:
> > @@ -443,12 +446,24 @@ static int mv3310_probe(struct phy_device *phydev)
> > =20
> >  	switch (phydev->drv->phy_id) {
> >  	case MARVELL_PHY_ID_88X3310:
> > +		ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_XGSTAT);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		has_macsec =3D !(ret & MV_PMA_XGSTAT_NO_MACSEC);
> > +
> >  		if (nports =3D=3D 4)
> >  			priv->model =3D MV_MODEL_88X3340;
> >  		else if (nports =3D=3D 1)
> >  			priv->model =3D MV_MODEL_88X3310;
> >  		break; =20
>=20
> The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
> In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
> 0x09a8..0x09af. We could add a separate driver structure, which would
> then allow the kernel to print a more specific string via standard
> methods, like we do for other PHYs. Not sure whether that would work
> for the 88X21x0 family though.

OK I will look into this. What are your thoughts on the other patches?

Marek
