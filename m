Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20511010FD
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfKSBtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:49:33 -0500
Received: from mail-eopbgr40085.outbound.protection.outlook.com ([40.107.4.85]:49219
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbfKSBtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 20:49:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKqc692O3VhOeK76nUC+3hfv2PaSd0C1125wVc4wUA3cVgt5bBAVKaGeUyir7MuulVnKAxORVOzbzuQogGI0+QDPHMVzspcVQwv0M3KrMC4xjESwMrq+dNRNMhufz4fuH0Jg9M8HBlfx0crVkTrO7OoMdch+WAAdUSJHnfFesMS78vcDqf7iEu33Z2lJG6T0AazExuKRk0a6FbF8t7U3CgEodswF97xcQRsrOhCWo84BTFHkdNBMQyTSP28NmtM+YkZPZKnQJFub3d8mt34co9N7yfVFP98TOjNfhyC+NbmkxeuuTup7aBruo+6B4e4giot94KabpFLOu5By8t4xDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCLhzJ9wvl/gyXPLwHU4QdBzQszX9ifWJT2HFr6dKQo=;
 b=gKaYlLALHZCNJdaZ93CzY8EzoLxai40NUe9bZozsoxw5r4/LFv67a+oO90BCRmaqb4ooIYTRFt0fVNzF9Hr0S9/lIyLiIMzTtuWvdoZ1anjDBTllnfir8jNpe6i80wpoTZeHsm24JkzF9r0F0iAab2U5uZ2BKluwZD4ChO7/sXfW1hwoknJaCeo1MRC3i051xV5mNw4HfFPsh5yc0mA/BTfrZoBlgMM4WElAWCpCyhfMTFloNgIseCubK9B9ZvZMoOWS6NqCCFXXYf5V6y5n/5Gl8mAGXz6Sr/WjzcjXorwdRw+sopHkAQkYWFIPJObT/Tb5T8VDSQ4ojenqIvmdPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCLhzJ9wvl/gyXPLwHU4QdBzQszX9ifWJT2HFr6dKQo=;
 b=TFTnmKHFlaDWapdFbAw8NUPfCdopJwA8LjEt+nyDcoCYHpWUUxZQeAU9lCt/tWAuIHWPv9c4aYP1x/EGScgUiG2eX7o19ryzOiF+6eowX9rzTZj5gWN66N21D2fBmsXYC//tBCzDDmWA4fUMjHhzS5nZnObaev4MzYhQRyDHfFU=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3503.eurprd04.prod.outlook.com (52.134.6.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 01:49:30 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 01:49:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH net v3] net: fec: fix clock count mis-match
Thread-Topic: [EXT] [PATCH net v3] net: fec: fix clock count mis-match
Thread-Index: AQHVngpPN2duB9UCX06qCEzQ+nC0SKeRup8A
Date:   Tue, 19 Nov 2019 01:49:29 +0000
Message-ID: <VI1PR0402MB3600A4B2E81637B834D7DCC4FF4C0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191118121826.26353-1-hslester96@gmail.com>
In-Reply-To: <20191118121826.26353-1-hslester96@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6997faa9-a88f-4b56-d913-08d76c92b7bd
x-ms-traffictypediagnostic: VI1PR0402MB3503:
x-microsoft-antispam-prvs: <VI1PR0402MB35036C7B5772456A6AD52178FF4C0@VI1PR0402MB3503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(189003)(199004)(9686003)(66556008)(64756008)(66446008)(66476007)(81166006)(81156014)(7696005)(86362001)(5660300002)(66946007)(186003)(229853002)(6246003)(4326008)(26005)(7736002)(14454004)(305945005)(6916009)(52536014)(6506007)(102836004)(71190400001)(3846002)(25786009)(476003)(76116006)(55016002)(8676002)(446003)(256004)(14444005)(8936002)(6116002)(478600001)(71200400001)(11346002)(99286004)(1411001)(66066001)(2906002)(74316002)(54906003)(316002)(6436002)(76176011)(486006)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3503;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdyZYiVA95MpWEGJD+m2hgUqG+pWsYKn2WMHiaa+BxPwZN99OjM2FZrLutX+obAIeTjAufo4IwNFwsYYDH3Xr6q+wwIIHs42csYpqnlFqeNgzRCc/l9scmbtf4+3KRW+3wqM+zwCyo3LbOH4t4uwiR/BdH610ieGXPlrA1PAcLFTIE/uBJNAGDwTzQ0DkeppdmMk83OMl132q7dzjB/LYpHHqOSy+ZT0YF8gBc9HWLm4sNBnphayXIeIq/TsRvNUPKpvirvSSBzaa9653kPIs10fy0s+V86SIVVsrT0Xa+S7ZASlcCFzn2MGyCZZGrfDcka+R3RIOX7ZMLJ8oamOJtUZ7pPdfGMajGcXky8F5VMpdaPyjUk5V24abvSws7Lwv1vyifUaKsK8svbv9Di2hI/KPXJrqXlFT+RvrI5HVdsHwNeXseisJFidtcRF5Sk9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6997faa9-a88f-4b56-d913-08d76c92b7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 01:49:29.7913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Gg8BJGMslUyczq7RvRQ/kpSL80PVDhulZiYTs1EYTi1Ydma/K5XacQCLU0m0jBwQHHjw5HQS/JuYf6LNk+xzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3503
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com> Sent: Monday, November 18, 2019 8=
:18 PM
> pm_runtime_put_autosuspend in probe will call suspend to disable clks
> automatically if CONFIG_PM is defined. (If CONFIG_PM is not defined, its
> implementation will be empty, then suspend will not be called.)

suspend -> runtime suspend
>=20
> Therefore, we can call pm_runtime_get_sync to resume it first to enable c=
lks,
resume -> runtime resume
> which matches the suspend. (Only when CONFIG_PM is defined, otherwise
suspend -> runtime suspend
> pm_runtime_get_sync will also be empty, then resume will not be called.)
>=20
> Then it is fine to disable clks without causing clock count mis-match.
>=20
> Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in
> remove")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index a9c386b63581..4bb30761abfc 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3636,6 +3636,11 @@ fec_drv_remove(struct platform_device *pdev)
>         struct net_device *ndev =3D platform_get_drvdata(pdev);
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
>         struct device_node *np =3D pdev->dev.of_node;
> +       int ret;
> +
> +       ret =3D pm_runtime_get_sync(&pdev->dev);
> +       if (ret < 0)
> +               return ret;
>=20
>         cancel_work_sync(&fep->tx_timeout_work);
>         fec_ptp_stop(pdev);
> @@ -3643,15 +3648,17 @@ fec_drv_remove(struct platform_device *pdev)
>         fec_enet_mii_remove(fep);
>         if (fep->reg_phy)
>                 regulator_disable(fep->reg_phy);
> -       pm_runtime_put(&pdev->dev);
> -       pm_runtime_disable(&pdev->dev);
> -       clk_disable_unprepare(fep->clk_ahb);
> -       clk_disable_unprepare(fep->clk_ipg);
> +
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(fep->phy_node);
>         free_netdev(ndev);
>=20
> +       clk_disable_unprepare(fep->clk_ahb);
> +       clk_disable_unprepare(fep->clk_ipg);
> +       pm_runtime_put_noidle(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +
>         return 0;
>  }
>=20
> --
> 2.24.0

