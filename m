Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114922AF2EC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgKKOB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgKKOBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 09:01:19 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D815F207BB;
        Wed, 11 Nov 2020 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605103278;
        bh=vQz7S3QWeXy6BkXiot8J5wQei/JzRJQFCCQP/sei8xo=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=j44tFrL0G28orNFI5i/AjQGd0A962K1Ygz07nSK8V0Usrv+Q2KHGEa3EgBbrerzka
         p8qEnG+Zb/VGgxi19YTVYGL1cuhM5pVAIfnBLBnJqNeUYvbHw5OFuvrGYjWcz2BfQs
         QidAo6pytHkufquZmlqUG2HGDCo+uExE00eEJxYw=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201111095511.671539-1-steen.hegelund@microchip.com>
References: <20201111095511.671539-1-steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [net] net: phy: mscc: adjust the phy support for PTP and MACsec
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <160510327378.144114.15670288040387928079@surface.local>
Date:   Wed, 11 Nov 2020 15:01:14 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen!

Either this is a fix and it would need a Fixes: tag in addition to the
Signed-off-by: one (you can have a look at the git history to see what
is the format); or the patch is not a fix and then it should have
[net-next] in its subject instead of [net].

Please have a look at the relevant documentation,
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Thanks!
Antoine

Quoting Steen Hegelund (2020-11-11 10:55:11)
> The MSCC PHYs selected for PTP and MACSec was not correct
>=20
> - PTP
>     - Add VSC8572 and VSC8574
>=20
> - MACsec
>     - Removed VSC8575
>=20
> The relevant datasheets can be found here:
>   - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
>   - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574
>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  drivers/net/phy/mscc/mscc_macsec.c | 1 -
>  drivers/net/phy/mscc/mscc_ptp.c    | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/ms=
cc_macsec.c
> index 1d4c012194e9..72292bf6c51c 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)
>=20
>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>         case PHY_ID_VSC856X:
> -       case PHY_ID_VSC8575:
>         case PHY_ID_VSC8582:
>         case PHY_ID_VSC8584:
>                 INIT_LIST_HEAD(&vsc8531->macsec_flows);
> diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_=
ptp.c
> index b97ee79f3cdf..f0537299c441 100644
> --- a/drivers/net/phy/mscc/mscc_ptp.c
> +++ b/drivers/net/phy/mscc/mscc_ptp.c
> @@ -1510,6 +1510,8 @@ void vsc8584_config_ts_intr(struct phy_device *phyd=
ev)
>  int vsc8584_ptp_init(struct phy_device *phydev)
>  {
>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
> +       case PHY_ID_VSC8572:
> +       case PHY_ID_VSC8574:
>         case PHY_ID_VSC8575:
>         case PHY_ID_VSC8582:
>         case PHY_ID_VSC8584:
> --
> 2.29.2
>=20
