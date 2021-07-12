Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4423C656F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhGLVaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231837AbhGLVaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 17:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB734611CD;
        Mon, 12 Jul 2021 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626125238;
        bh=nC73cYPyGwWHRDNMRnmd00h7Q9ECZQNFVNYZNv1ba5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QgafERmATuDVM28B9m/a6+IETVz6QInrDBCTJD0uZNAtSZZP9qNt8riKlXtbNeUbn
         HZav1jjsWK5IlroadRF3kUHo7KqczHqRS6sJuYdhqV7khH7ejynbqXWGO79z0i5yrp
         mW6pWfLwLri7543N5Q/gYsOBj3y/gG7duKfiZxhE/er08oieJfe3yPYHKwlkCgXVCg
         E4/B4i71taJSzq+683KPMYANpWWdAiL+Bzd3iD6raBh17KdSiWXtZtBLZwefHSH1RQ
         /eZGrFiKDjEL9JrGDhmVaMQsfXFdIAaJbQO6eXaTNwSCenbUluWHTeY8+xOql7Lm0T
         gnf+fZSCGPphA==
Date:   Mon, 12 Jul 2021 23:27:13 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next] net: dpaa2-mac: add support for more
 ethtool 10G link modes
Message-ID: <20210712232713.5e4f6e15@thinkpad>
In-Reply-To: <E1m2y9G-0005vm-Vm@rmk-PC.armlinux.org.uk>
References: <E1m2y9G-0005vm-Vm@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Mon, 12 Jul 2021 16:47:10 +0100
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Phylink documentation says:
>  * Note that the PHY may be able to transform from one connection
>  * technology to another, so, eg, don't clear 1000BaseX just
>  * because the MAC is unable to BaseX mode. This is more about
>  * clearing unsupported speeds and duplex settings. The port modes
>  * should not be cleared; phylink_set_port_modes() will help with this.

At first I thought these are points as in Markdown. Maybe remove the
asterisks from the commit message, next time :)
>=20
> So add the missing 10G modes.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> net-next is currently closed, but I'd like to collect acks for this
> patch. Thanks.
>=20
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index ae6d382d8735..543c1f202420 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -140,6 +140,11 @@ static void dpaa2_mac_validate(struct phylink_config=
 *config,
>  	case PHY_INTERFACE_MODE_10GBASER:
>  	case PHY_INTERFACE_MODE_USXGMII:
>  		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseCR_Full);
> +		phylink_set(mask, 10000baseSR_Full);
> +		phylink_set(mask, 10000baseLR_Full);
> +		phylink_set(mask, 10000baseLRM_Full);
> +		phylink_set(mask, 10000baseER_Full);
>  		if (state->interface =3D=3D PHY_INTERFACE_MODE_10GBASER)
>  			break;
>  		phylink_set(mask, 5000baseT_Full);

Acked-by: Marek Beh=C3=BAn <kabel@kernel.org>
