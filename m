Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955BA2D1C42
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgLGVoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgLGVoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 16:44:18 -0500
Date:   Mon, 7 Dec 2020 13:43:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607377417;
        bh=ZdgCiySmxnYeCPG0fk38ET6CeRw/+tGlOaM4V7yjNFY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=inxD7cCzD2PcOzMiozfvnpJXTywf4sbP7Ixew2J9yxnJPBOqWMOQUTo8wbWX+e0PR
         rUYP5WNZL1iuvOqZ5Gj+QRms+1oYhusPdEE5k3bdTnKkmBbFmGogDsBslccBySLx64
         KcW21gRyNPnXJN+qVQcRdNRZHAERUcusgYDE/VFx2fdlf2IBypZAtljx0PIen+ncgh
         HMdpj9+3UuyQ/090OsjCpowU9lM+HNsxoCyVfX+lwwaBIzPXKU0h244QOiOnuoLTQ3
         TV5OMRm2luTV+2RkGk++nsqsO9vBjTruiFXCROvjlmmHN8tK90dvDtYgBrLJDBvR11
         /zOP6Q0LPyxQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: lantiq: allow to use all GPHYs on
 xRX300 and xRX330
Message-ID: <20201207134335.6ef718c9@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201206132713.13452-2-olek2@wp.pl>
References: <20201206132713.13452-1-olek2@wp.pl>
        <20201206132713.13452-2-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Dec 2020 14:27:12 +0100 Aleksander Jan Bajkowski wrote:
> This patch allows to use all PHYs on GRX300 and GRX330. The ARX300 has 3
> and the GRX330 has 4 integrated PHYs connected to different ports compared
> to VRX200.
>=20
> Port configurations:
>=20
> xRX200:
> GMAC0: RGMII/MII/REVMII/RMII port
> GMAC1: RGMII/MII/REVMII/RMII port
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
>=20
> xRX300:
> GMAC0: RGMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
>=20
> xRX330:
> GMAC0: RGMII/GMII/RMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII) or GPHY3 (GMII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII/RMII port
>=20
> Tested on D-Link DWR966 with OpenWRT.
>=20
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Please make sure you don't add W=3D1 C=3D1 build warnings:

In file included from ../include/linux/kasan-checks.h:5,
                 from ../include/asm-generic/rwonce.h:26,
                 from ./arch/x86/include/generated/asm/rwonce.h:1,
                 from ../include/linux/compiler.h:246,
                 from ../include/linux/err.h:5,
                 from ../include/linux/clk.h:12,
                 from ../drivers/net/dsa/lantiq_gswip.c:28:
drivers/net/dsa/lantiq_gswip.c: In function =E2=80=98gswip_xrx300_phylink_v=
alidate=E2=80=99:
drivers/net/dsa/lantiq_gswip.c:1496:35: warning: unused variable =E2=80=98m=
ask=E2=80=99 [-Wunused-variable]
 1496 |  __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
      |                                   ^~~~
include/linux/types.h:11:16: note: in definition of macro =E2=80=98DECLARE_=
BITMAP=E2=80=99
   11 |  unsigned long name[BITS_TO_LONGS(bits)]
      |                ^~~~
drivers/net/dsa/lantiq_gswip.c:1496:2: note: in expansion of macro =E2=80=
=98__ETHTOOL_DECLARE_LINK_MODE_MASK=E2=80=99
 1496 |  __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/dsa/lantiq_gswip.c: At top level:
drivers/net/dsa/lantiq_gswip.c:2079:9: warning: initialization discards =E2=
=80=98const=E2=80=99 qualifier from pointer target type [-Wdiscarded-qualif=
iers]
 2079 |  .ops =3D &gswip_xrx200_switch_ops,
      |         ^
drivers/net/dsa/lantiq_gswip.c:2085:9: warning: initialization discards =E2=
=80=98const=E2=80=99 qualifier from pointer target type [-Wdiscarded-qualif=
iers]
 2085 |  .ops =3D &gswip_xrx300_switch_ops,
      |         ^
drivers/net/dsa/lantiq_gswip.c:2079:17: warning: incorrect type in initiali=
zer (different modifiers)
drivers/net/dsa/lantiq_gswip.c:2079:17:    expected struct dsa_switch_ops *=
ops
drivers/net/dsa/lantiq_gswip.c:2079:17:    got struct dsa_switch_ops const *
drivers/net/dsa/lantiq_gswip.c:2085:17: warning: incorrect type in initiali=
zer (different modifiers)
drivers/net/dsa/lantiq_gswip.c:2085:17:    expected struct dsa_switch_ops *=
ops
drivers/net/dsa/lantiq_gswip.c:2085:17:    got struct dsa_switch_ops const *
