Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D72AAED0
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 02:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgKIBto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 20:49:44 -0500
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:51614
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727979AbgKIBto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 20:49:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eh7TeJILTW5YYHB4TkfpDF6IOB/8WoXVj6Tqu60kIxG8jV2DLZ3Tf9UGZcMOz3ezjA4XDEXKSklHwrLeNqz/GKgopxpjuTL1L4gUuB12613Cwq30RTlRPJ38GfFKqa2798d5HlFXDD5YXTN3wJ6wP/KxhpPuU9Qwl1Q/D/VAh6aXd2IEZaXJDlDkdlQeJvqvJd0+RgeG51OtvqmbyRs9xW/3ZuDlpGeDgQw5m3oo17nKhTeacv5wgq5rviPaF3bLwDa81J3XwvSaQ/lUS118zSFHwUO84oqIcUFdsiR7mez9qkMd4VMG4Irao1M2QwP7tel3H72JhWjqxhDkjMc/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbBzdCADfHlUxWEjd2NpXKlj/CzVE1S5y3KpuC5g7sE=;
 b=Fli5a0bvtpzZMULbb2LDPkfG4O5joiNGkxURUiXrsONVducm5bZtX/MTAUOJGIboAGgYIqMtIW8juu14d2uIHhi7mzGgRQXbBsBa2vbW+CvXtbeczE0R65m6nlKiJwxxajlibvseQEqERqFlUuUwu4zk4Glh2hghiWl8yO4eoqKiMd8zZb6BpEWP+aswG7sKN+cZZJuTnI7FL/tNDOs1RXtjg3RQ+0B5RiRzrjzjLOYXHze0KnZ21j9SyyxSYchHt1yP9noEzT7sz6G+KzY8+d/Fiih+QNQkYd81hwXcT0pi/aCB3kGxJCB0zQ7I1biQLrKsKXACvmi2TWeINIMPuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbBzdCADfHlUxWEjd2NpXKlj/CzVE1S5y3KpuC5g7sE=;
 b=pyovM9HfyWOUJEbYyfDIGC0767YWiITLdyxvdFecZAy+VGFHnsX7xRjga2XBS5OEMj3vMsvZ4sZ4ky+dBhIjuGcqosnSv37Pb8/X0p+XLj7dNcRLJnFSC0YeZSeBeuGYMgwApCliIvNFQz7DstDNaAByfNRb39i7IHmInCQp7eY=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR0402MB3585.eurprd04.prod.outlook.com (2603:10a6:208:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 01:49:40 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 01:49:40 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Zhang Qilong <zhangqilong3@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: fec: Fix reference count leak in fec series ops
Thread-Topic: [PATCH] net: fec: Fix reference count leak in fec series ops
Thread-Index: AQHWtbR0cLl78/z7wEeCrdGvuGMwFam/CZHw
Date:   Mon, 9 Nov 2020 01:49:40 +0000
Message-ID: <AM8PR04MB731568128C08B0730519E9D3FFEA0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <20201108095310.2892555-1-zhangqilong3@huawei.com>
In-Reply-To: <20201108095310.2892555-1-zhangqilong3@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24d0b115-e8f5-4afc-4cff-08d88451b918
x-ms-traffictypediagnostic: AM0PR0402MB3585:
x-microsoft-antispam-prvs: <AM0PR0402MB3585A2150AA7CA32FE7124B5FFEA0@AM0PR0402MB3585.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f3m9LlzYe0teBZYRFzbVFKMFUP21Hfwezicplvfnw1rCAK81nN70RY38PgM0DYw5JAAKQQuke9m1pe/cmvmeQWtopVOe8sN6kiJ4vL/4k1Qub+QcSQwjfmPACHqSDEyXHkvmiQnC1rzMJDdOGNk1bv4H+KsmQwbySoW27z8sfUfiavtxosL/HFIatp/yM+i1RoCU2NKDJN/YjutCsdbBBnupeBdOuLPoViyRZBLTXNdce3K+Un7+i0z0phQdwt0TDFNG+4RFZo8/a8fy+uXC31NiuEd/IAh9V8FMilJg/doMeAoknW4PIFByoypVTwi9tIiGmLxi2ERnCg9+PqIe28KkWALPJo00SYjcla96pTCMP/5MhXRmu8/rUQYf2b8q8OnEMHus16JyCAuwcnHXnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(26005)(86362001)(9686003)(55016002)(316002)(7696005)(6506007)(71200400001)(76116006)(4326008)(8676002)(186003)(5660300002)(83380400001)(2906002)(52536014)(966005)(478600001)(33656002)(110136005)(66946007)(66446008)(8936002)(64756008)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6SLyjSvh93xoA82XR5DNf/pApEcWaSV0qgAqX1JWr1QcwiQoCmle5EIklY+sjeuI9t4ox1GBY/1VoAi4GYmLRW2183EH1RvC6WaInjCg89S2MeQu17KDONFjocuku0V2AP0jeJ79IivGcOSBMAOQfj4IWx1mCliBHR8Rflai+w4TxDFeAz4K1WZ+aYxprqp7OFiQNdGQVXZEKvYjeAz7eMqXPZ0Qu8q+5vfA6LB62R4DnWi4exMQGF8dI3ovYpMfjrwVQ8WAmTCPpuzf9drBqiWF47KH7YiSphyjVLgld8w+P/QJniNP8BwxpK8rfehYloBahHx2W91Nplck9IWVGvw9ah7rw5fWaua8vP/3Y/FZxrcBrK8AJD0uPpXWhPoNjRnPrwHXrD6hEG+knGXOTUmOEkBEfAVQMW4Tj7kPMHX5AIFeivBT+oRjtVg4L5e1cfzVpSKxtPH2IgsdCiSYf4BuG7qbnVXtmYOHo6CE9V5yDwX4JCEA5IFuo2z9dxeeUFdoFLOiQ7iM3wSuN7CxxBfLQDMW6MEWRPVEF4MdGQpMhN1EoVJFmfs7KIC+0fq5zl+QKJXoI9tWyV9IPIWfBpd0K29Fd9HhX4V9Br29rvn9k/u5pjrCJ+wUBpysV9PN8oBTDrlnMcYpi6XvfrJK1g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d0b115-e8f5-4afc-4cff-08d88451b918
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 01:49:40.4882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cy5BJUHRQyGy6FvAd8b5i/cqyzOq0rcFNO0zPsXW2T1n8SMaW03qmMSxPbxTYQ+FeXQbmkApYbZkgbe2zEn41w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com> Sent: Sunday, November 8, 2020=
 5:53 PM
> pm_runtime_get_sync() will increment pm usage at first and it will resume=
 the
> device later. If runtime of the device has error or device is in inaccess=
ible
> state(or other error state), resume operation will fail. If we do not cal=
l put
> operation to decrease the reference, it will result in reference count le=
ak.
> Moreover, this device cannot enter the idle state and always stay busy or=
 other
> non-idle state later. So we fixed it through adding pm_runtime_put_noidle=
.
>=20
> Fixes: 8fff755e9f8d0 ("net: fec: Ensure clocks are enabled while using md=
io bus")
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

From early discussion for the topic, Wolfram Sang wonder if such de-referen=
ce can
be better handled by pm runtime core code.

https://lkml.org/lkml/2020/6/14/76

Regards,
Andy
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index d7919555250d..6c02f885c67e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1809,8 +1809,10 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> int mii_id, int regnum)
>  	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	ret =3D pm_runtime_get_sync(dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(dev);
>  		return ret;
> +	}
>=20
>  	if (is_c45) {
>  		frame_start =3D FEC_MMFR_ST_C45;
> @@ -1868,10 +1870,12 @@ static int fec_enet_mdio_write(struct mii_bus
> *bus, int mii_id, int regnum,
>  	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	ret =3D pm_runtime_get_sync(dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(dev);
>  		return ret;
> -	else
> +	} else {
>  		ret =3D 0;
> +	}
>=20
>  	if (is_c45) {
>  		frame_start =3D FEC_MMFR_ST_C45;
> @@ -2276,8 +2280,10 @@ static void fec_enet_get_regs(struct net_device
> *ndev,
>  	int ret;
>=20
>  	ret =3D pm_runtime_get_sync(dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(dev);
>  		return;
> +	}
>=20
>  	regs->version =3D fec_enet_register_version;
>=20
> @@ -2977,8 +2983,10 @@ fec_enet_open(struct net_device *ndev)
>  	bool reset_again;
>=20
>  	ret =3D pm_runtime_get_sync(&fep->pdev->dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(&fep->pdev->dev);
>  		return ret;
> +	}
>=20
>  	pinctrl_pm_select_default_state(&fep->pdev->dev);
>  	ret =3D fec_enet_clk_enable(ndev, true); @@ -3771,8 +3779,10 @@
> fec_drv_remove(struct platform_device *pdev)
>  	int ret;
>=20
>  	ret =3D pm_runtime_get_sync(&pdev->dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(&pdev->dev);
>  		return ret;
> +	}
>=20
>  	cancel_work_sync(&fep->tx_timeout_work);
>  	fec_ptp_stop(pdev);
> --
> 2.25.4

