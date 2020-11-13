Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526C02B259C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKMUfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgKMUfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 15:35:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9948B2223C;
        Fri, 13 Nov 2020 20:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605299710;
        bh=cHeuOuncJHW+8hXxWpYa6tQZVFcKd3qiZmVck+KlPEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iRXJDAcuHA/br3g74i/3HDAiwIlZmon/0/XANIl4E9OtyDAVKz0YiO3i7lXUsSuhS
         rBNSGw2DuAEtF2eTlcpwClf59HbtTFf4J4zA1MyYu5numvEUZgKvrgQk+mQub2dWyx
         qmSqf7iUdvVzQgnnLeJ8Bu7h84537Wfx470wcMx8=
Date:   Fri, 13 Nov 2020 12:35:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
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
Message-ID: <20201113123508.3920de4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112115106.16224-4-l.stelmach@samsung.com>
References: <20201112115106.16224-1-l.stelmach@samsung.com>
        <CGME20201112115108eucas1p22790c6cdec17e5322424e026b3985305@eucas1p2.samsung.com>
        <20201112115106.16224-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 12:51:04 +0100 =C5=81ukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
>=20
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
>=20
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
>=20
> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104;6=
5;86&PLine=3D65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-=
artik/
>=20
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>=20
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

Please make sure the new code builds cleanly with W=3D1 C=3D1

../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: warning: initialized =
field overwritten [-Woverride-init]
  221 |  .get_msglevel  =3D ax88796c_ethtool_getmsglevel,
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: note: (near initializ=
ation for =E2=80=98ax88796c_ethtool_ops.get_msglevel=E2=80=99)
../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: warning: initialized =
field overwritten [-Woverride-init]
  222 |  .set_msglevel  =3D ax88796c_ethtool_setmsglevel,
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: note: (near initializ=
ation for =E2=80=98ax88796c_ethtool_ops.set_msglevel=E2=80=99)
In file included from ../drivers/net/ethernet/asix/ax88796c_main.h:15,
                 from ../drivers/net/ethernet/asix/ax88796c_ioctl.c:16:
../drivers/net/ethernet/asix/ax88796c_spi.h:25:17: warning: =E2=80=98tx_cmd=
_buf=E2=80=99 defined but not used [-Wunused-const-variable=3D]
   25 | static const u8 tx_cmd_buf[4] =3D {AX_SPICMD_WRITE_TXQ, 0xFF, 0xFF,=
 0xFF};
      |                 ^~~~~~~~~~
