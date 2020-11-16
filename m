Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B752B4E63
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387964AbgKPRqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733186AbgKPRqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:46:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239CE20B80;
        Mon, 16 Nov 2020 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605548776;
        bh=Tcn07ajoqucV5eEbmU3nljgc9tKlfP7RCs7GJrg2B2w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JbdvB2akOije2Z4LDxW1zvExnXlyuWhD/NWUlL0JoLwMNlNsWYF0dSDsdYPkRInck
         MrdqDMLxsq8cEMdIMb3nb278Mnu+uoZ4QgZ4LEpowKsF+WEwQwKjyyePUHs3vb9++Y
         h/P7Rxm51RBXoPek59A7pOmV89qqGDSc7AbHSD/E=
Date:   Mon, 16 Nov 2020 09:46:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v6 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201116094614.035ceffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftjblfxl3jt.fsf%l.stelmach@samsung.com>
References: <20201113123508.3920de4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7@eucas1p2.samsung.com>
        <dleftjblfxl3jt.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:33:26 +0100 Lukasz Stelmach wrote:
> > Please make sure the new code builds cleanly with W=3D1 C=3D1
> >
> > ../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: warning: initiali=
zed field overwritten [-Woverride-init]
> >   221 |  .get_msglevel  =3D ax88796c_ethtool_getmsglevel,
> >       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: note: (near initi=
alization for =E2=80=98ax88796c_ethtool_ops.get_msglevel=E2=80=99)
> > ../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: warning: initiali=
zed field overwritten [-Woverride-init]
> >   222 |  .set_msglevel  =3D ax88796c_ethtool_setmsglevel,
> >       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: note: (near initi=
alization for =E2=80=98ax88796c_ethtool_ops.set_msglevel=E2=80=99)
> > In file included from ../drivers/net/ethernet/asix/ax88796c_main.h:15,
> >                  from ../drivers/net/ethernet/asix/ax88796c_ioctl.c:16:
> > ../drivers/net/ethernet/asix/ax88796c_spi.h:25:17: warning: =E2=80=98tx=
_cmd_buf=E2=80=99 defined but not used [-Wunused-const-variable=3D]
> >    25 | static const u8 tx_cmd_buf[4] =3D {AX_SPICMD_WRITE_TXQ, 0xFF, 0=
xFF, 0xFF};
> >       |                 ^~~~~~~~~~ =20
>=20
> I fixed the problems reported by W=3D1, but I am afraid I can't do
> anything about C=3D1. sparse is is reporting
>=20
> [...]
> ./include/linux/atomic-fallback.h:266:16: error: Expected ; at end ofdecl=
aration
> ./include/linux/atomic-fallback.h:266:16: error: got ret
> ./include/linux/atomic-fallback.h:267:1: error: Expected ; at the end of =
type declaration
> ./include/linux/atomic-fallback.h:267:1: error: too many errors
> Segmentation fault
>=20
> in the headers and gets killed.

That's fine, sparse is wobbly at times, thanks!
