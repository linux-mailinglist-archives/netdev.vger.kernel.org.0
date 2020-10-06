Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27511285234
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgJFTPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 15:15:21 -0400
Received: from mx2.securetransport.de ([188.68.39.254]:42366 "EHLO
        mx2.securetransport.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgJFTPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 15:15:21 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 15:15:19 EDT
Received: from mail.dh-electronics.com (business-24-134-97-169.pool2.vodafone-ip.de [24.134.97.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx2.securetransport.de (Postfix) with ESMTPSA id F2B7F5E8DA;
        Tue,  6 Oct 2020 21:07:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dh-electronics.com;
        s=dhelectronicscom; t=1602011247;
        bh=BmT0vZRW9XgQdo3qxJ8++9jtUBid7lvJhQ1LFw9FAOY=;
        h=From:To:CC:Subject:Date:From;
        b=SqeCcpNg+olHdPmeJQ8ZD4eT4KZvs9Y5ZJhaqX4Hp6xk/dzottg5Jh9/CC3WmkDjs
         KxK1emrjcqnvAn6R6CZVOirL/cWOm4LLPZu4QtsoykZ1pQseOdtS+VppKykcdxW3T/
         RVDoEqnPjrv2Gja66sxhALCSA/X6nJtVHU5qc51JDIgt7iuZNnq3tymCbJQIi0e08n
         6SqFDiKS/T85K4jNjVx/Xi6EaQ0wH9GPAHUqkhUw8cRAz1ZbL6ki5XZg8oV7oEWcmC
         qgYz7rtYADKB5doONgZ3vh00CTjFsAiX4CCKpRHFZa84UJhJIYnkCPd64Su1EalAOV
         U9X426sDpkIag==
Received: from DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) by
 DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.659.4;
 Tue, 6 Oct 2020 21:07:14 +0200
Received: from DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579]) by
 DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579%6]) with mapi id
 15.02.0659.006; Tue, 6 Oct 2020 21:07:14 +0200
From:   Christoph Niedermaier <cniedermaier@dh-electronics.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Richard Leitner <richard.leitner@skidata.com>,
        "David S . Miller" <davem@davemloft.net>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "'Marek Vasut'" <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: RE: [PATCH][RESEND] net: fec: Fix PHY init after
 phy_reset_after_clk_enable() [Klartext]
Thread-Topic: [PATCH][RESEND] net: fec: Fix PHY init after
 phy_reset_after_clk_enable() [Klartext]
Thread-Index: AdacE6O5bmOhz8xbSye/pXhDA6DR9w==
Date:   Tue, 6 Oct 2020 19:07:14 +0000
Message-ID: <f3ff40567ee44fc3a14b2ae8a9b18180@dh-electronics.com>
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
Sent: Tuesday, October 6, 2020 3:53 PM

> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
> loses its register settings. The fec_enet_mii_probe() starts the PHY
> and does the necessary calls to configure the PHY via PHY framework,
> and loads the correct register settings into the PHY. Therefore,
> fec_enet_mii_probe() should be called only after the PHY has been
> reset, not before as it is now.
>=20
> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support"=
)
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Richard Leitner <richard.leitner@skidata.com>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Richard Leitner <richard.leitner@skidata.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index c043afb38b6e..2d5433301843 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2983,17 +2983,17 @@ fec_enet_open(struct net_device *ndev)
>         /* Init MAC prior to mii bus probe */
>         fec_restart(ndev);
>=20
> -       /* Probe and connect to PHY when open the interface */
> -       ret =3D fec_enet_mii_probe(ndev);
> -       if (ret)
> -               goto err_enet_mii_probe;
> -
>         /* Call phy_reset_after_clk_enable() again if it failed during
>          * phy_reset_after_clk_enable() before because the PHY wasn't
> probed.
>          */
>         if (reset_again)
>                 phy_reset_after_clk_enable(ndev->phydev);
>=20
> +       /* Probe and connect to PHY when open the interface */
> +       ret =3D fec_enet_mii_probe(ndev);
> +       if (ret)
> +               goto err_enet_mii_probe;
> +
>         if (fep->quirks & FEC_QUIRK_ERR006687)
>                 imx6q_cpuidle_fec_irqs_used();
>=20
> --
> 2.28.0

Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
