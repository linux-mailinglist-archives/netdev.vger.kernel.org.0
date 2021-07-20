Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F33D004C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhGTQwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhGTQvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C68E60234;
        Tue, 20 Jul 2021 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626802347;
        bh=ro/CHjcs0UBC2OW8hwzo1K8UKv2+cG9BJ4U9R80l1QI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UviF6JO0oSZx73mfK4YgSc+kae4SZkNrCEV1w+XjoWAXnIiJkVIm6T+tOQGWvDiLu
         LH2pYNo9imtlFN8C/GaQyVB6tSvpUvaI34ux+9h1OG00R/1ZoZaw8kMg47eS6OFTp6
         krBmzESWFrJne3BWPXWA0yqnUhG8MPADKPtL4Hpi0e+SNvjdlUBdMzn0T0rm56bSAS
         TuqZO4w60BFosz6J4x03+59oag1zBRFliq8KEVfUpDtWOOd8PF/GBawhrZ62ue1xtq
         042aQJAF7kR9QCk5VYU14/k4h7KpfOEDSI1/bSLUiwolMIdCJHxj8VLtUvh4GpIluz
         YAhlYDyFXaFNA==
Date:   Tue, 20 Jul 2021 19:32:23 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift
 tunable support
Message-ID: <20210720193223.194cb79e@dellmb>
In-Reply-To: <20210720171401.GV22278@shell.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
        <20210720170424.07cba755@dellmb>
        <20210720171401.GV22278@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 18:14:01 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Jul 20, 2021 at 05:04:24PM +0200, Marek Beh=C3=BAn wrote:
> > Hi Russell,
> >=20
> > On Tue, 20 Jul 2021 14:38:20 +0100
> > Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >  =20
> > > Add support for the downshift tunable for the Marvell 88x3310 PHY.
> > > Downshift is only usable with firmware 0.3.5.0 and later. =20
> >=20
> > mv3310_{g,s}et_features are also used for 88E211x, but there is no
> > such register in the documentation for these PHYs. (Also firmware
> > versions on those are different, the newest is 8.3.0.0, but thats
> > not important.) My solution would be to rename the current methods
> > prefix to mv211x_ and and add new mv3310_{g,s}et_tunable methods. =20
>=20
> There's more than just the tunables themselves - there's also
> config_init().
>=20
> We already need to reject downshift when old firmware is running,
> as that fails to work correctly. So, we can just do that for
> 88E211x as well, adding a flag to struct mv3310_chip to indicate
> whether downshift is present. Sound sensible?

Hmm, maybe add the flag to struct mv3310_priv, instead of struct
mv3310_chip, since the latter is static. And fill in the flag in
mv3310_probe() function, depending on firmware version?

BTW would you agree with a patch renaming the mv3310_ prefixes to
mv10g_ for all functions that are generic to both mv3310_ and mv2110_?
I was thinking about such a thing because it has become rather
confusing.

Marek
