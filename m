Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C53285381
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgJFU4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:56:12 -0400
Received: from mx3.securetransport.de ([116.203.31.6]:52260 "EHLO
        mx3.securetransport.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgJFU4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:56:12 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 16:56:11 EDT
Received: from mail.dh-electronics.com (business-24-134-97-169.pool2.vodafone-ip.de [24.134.97.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx3.securetransport.de (Postfix) with ESMTPSA id CF2D95DDFF;
        Tue,  6 Oct 2020 22:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dh-electronics.com;
        s=dhelectronicscom; t=1602017139;
        bh=R4NL/sDTi0byg2CU6DOF2Z0Vu02sJlShbQ+0TANq80U=;
        h=From:To:CC:Subject:Date:From;
        b=XBKX3iw++BGZg0xLLcI8fw+HCwt/IRom6y+7eaWPYpLXSW3WNsE6HyxVv84Qk6zxe
         CenIz7DHa0tMfXhcNsJEXMKoAd3xhprdH+LE60OtTK4ss1NZMK5uAm8EiwtJB3JNTl
         mRULAiv/CulOPbkmXYiMA9TlK1VS/rMnWDE8bSWlgc112S9DrkC+lk7+u4JG4BkCJI
         Rqq+eLR42UrxCOAkaOsiusmlUfAJ+0oN3KDx5BNJXxZ2qaeP6AKozcZMeT4IpTLTae
         Sc5Zeo3dkfpOtRJkDUiGUjaWY6ZRTeBM6VX4oVOlP92tKPAX9joKt7z+9AFJ1OV8kn
         5tmFNa67DNyDQ==
Received: from DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) by
 DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.659.4;
 Tue, 6 Oct 2020 22:45:30 +0200
Received: from DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579]) by
 DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579%6]) with mapi id
 15.02.0659.006; Tue, 6 Oct 2020 22:45:30 +0200
From:   Christoph Niedermaier <cniedermaier@dh-electronics.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>, 'Marek Vasut' <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: RE: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable() [Klartext]
Thread-Topic: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable() [Klartext]
Thread-Index: AdacIaCISjyNtCxjQvmT6uTEexR7kg==
Date:   Tue, 6 Oct 2020 20:45:30 +0000
Message-ID: <6c67262d252d42fdaae8ff4736748b3b@dh-electronics.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.2.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Sent: Tuesday, October 6, 2020 10:20 PM

> The phy_reset_after_clk_enable() is always called with ndev->phydev,
> however that pointer may be NULL even though the PHY device instance
> already exists and is sufficient to perform the PHY reset.
>=20
> If the PHY still is not bound to the MAC, but there is OF PHY node
> and a matching PHY device instance already, use the OF PHY node to
> obtain the PHY device instance, and then use that PHY device instance
> when triggering the PHY reset.
>=20
> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support"=
)
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Richard Leitner <richard.leitner@skidata.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 2d5433301843..5a4b20941aeb 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1912,6 +1912,24 @@ static int fec_enet_mdio_write(struct mii_bus *bus=
,
> int mii_id, int regnum,
>         return ret;
>  }
>=20
> +static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
> +{
> +       struct fec_enet_private *fep =3D netdev_priv(ndev);
> +       struct phy_device *phy_dev =3D ndev->phydev;
> +
> +       /*
> +        * If the PHY still is not bound to the MAC, but there is
> +        * OF PHY node and a matching PHY device instance already,
> +        * use the OF PHY node to obtain the PHY device instance,
> +        * and then use that PHY device instance when triggering
> +        * the PHY reset.
> +        */
> +       if (!phy_dev && fep->phy_node)
> +               phy_dev =3D of_phy_find_device(fep->phy_node);
> +
> +       phy_reset_after_clk_enable(phy_dev);
> +}
> +
>  static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>  {
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> @@ -1938,7 +1956,7 @@ static int fec_enet_clk_enable(struct net_device
> *ndev, bool enable)
>                 if (ret)
>                         goto failed_clk_ref;
>=20
> -               phy_reset_after_clk_enable(ndev->phydev);
> +               fec_enet_phy_reset_after_clk_enable(ndev);
>         } else {
>                 clk_disable_unprepare(fep->clk_enet_out);
>                 if (fep->clk_ptp) {
> @@ -2987,7 +3005,7 @@ fec_enet_open(struct net_device *ndev)
>          * phy_reset_after_clk_enable() before because the PHY wasn't
> probed.
>          */
>         if (reset_again)
> -               phy_reset_after_clk_enable(ndev->phydev);
> +               fec_enet_phy_reset_after_clk_enable(ndev);
>=20
>         /* Probe and connect to PHY when open the interface */
>         ret =3D fec_enet_mii_probe(ndev);
> --
> 2.28.0

Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
