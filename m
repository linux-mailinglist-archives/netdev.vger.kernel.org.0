Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00ABF455CF4
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhKRNtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhKRNtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:49:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE1C619E1;
        Thu, 18 Nov 2021 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637243195;
        bh=QHqQPi8P1i+84cjdOy4HqiOaX+p+/hK9BBiupE4Sh/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bleB7O/7czzQzQHvbkYpguDyVNGRLZqw7iIMHhC+ojgdQaINEoWo0d3dB/3s8CrXP
         rvAUiXu43hLlhNXljPBi5yYsi7LqTgltQB8AoF/XLEXwIk/qm9RtLg9q534xjQPye4
         BffEzsLESZBRzU/KpBwpCtglqocCxtSdFCBy0hLA3Dwv6GLqXsLx88IGmKjTgRQrdT
         ChBjopPE/xkKwsChw//UYM7kXU3a0gf9SuuzVR2vCTbUcnWeVvdbNvZaU7bYwuUjvQ
         a9tGlzpB3nFqtEJnkcJWUFywsR8TPwD/YUoW15vb999/Afwe2ZnUVC16DeZLfKy2GT
         fYhY3TFFMeCHQ==
Date:   Thu, 18 Nov 2021 14:46:28 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host
 interface configuration
Message-ID: <20211118144628.1925ae03@thinkpad>
In-Reply-To: <YZYfxyGbWTiXuHwP@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
        <20211117225050.18395-9-kabel@kernel.org>
        <YZYfxyGbWTiXuHwP@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 09:41:27 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Beh=C3=BAn wrote:
> > +static int mv3310_select_mactype(unsigned long *interfaces)
> > +{
> > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER; =20
>=20
> Hi,
>=20
> There are differences in the MACTYPE register between the 88X3310
> and 88X3340. For example, the 88X3340 has no support for XAUI.
> This is documented in the data sheet, and in the definitions of
> these values - note that MV_V2_3310_PORT_CTRL_MACTYPE_XAUI and
> MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH are only applicable
> to the 88X3310 (they don't use MV_V2_33X0_*).

Yes, but 88X3340 does not support XAUI, only RXAUI, it is defined in
supported_interfaces. So PHY_INTERFACE_MODE_XAUI will never be set in
interfaces, and thus this function can be used for both 88X3310 and
88X3340.

Marek
