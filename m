Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A564F988FA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 03:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfHVB3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 21:29:11 -0400
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:19886
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730240AbfHVB3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 21:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JReQzDpzQbYtdWkrtrSnBXMmm5Ra+XwTRaBlnicKm5VE3HPDksYILcVksH8icxMdgeB/Wu6VgDk9voIPN2sz4WfjXGyI3KeLtZNeFwr4v/19D4r6ys46H49zEne4/jfjDNyqwQ89V8OxouS9E25RHkiLJKeKOKgugdDnDPPXLfqC2qxReAhlJDxURlMpdOf2OhxzvcIXX6Ib/W8V0++UmWj+i/BbVIl0ANd8MM3yW0NQsaHW5VSAhlY4wRLfH4c19BaIXXUtWhl+jyXarRmBfPRwUqBy5u9SVZKEFnBeEWifdAgw0hbazDhGYHXQ3EsackBcK4dqeVFXDsKTMNwyRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMq0eEGh+bMoUHVMK67/aHQrZSU4I1JT7rt85KVFbX4=;
 b=RgF5APWhd5YSyeJBfQ9TWJmIxqapJh9/sKfDO7bT6FAVwaDXydBPKqwW1KC4JbF4d762OqEfmiD+Tqcqq14JSNvPREyiJ5SiJq3UpJtkbF4fRFzWH3BZq0ocix8Hk9upWD4GxfXTCJmv22ehK4p2NBI7+3hZdM39CXXRyZH88EyDGZgTj0sPyFYZQrwLNiEZ6RYYi4SsY18O45yCaUThHBOIMYEjMlHiwXIjwXiCBhSu/skJ4dqvH/2ToSNXICAKUB9CTyF12+khKJsqcVA5w5MrnPB9gsaaw0TNJ9mETDKLM9n+0PeGEU7Kd3fZpIsWq6zuX35rTfaZu0WFTyIU6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMq0eEGh+bMoUHVMK67/aHQrZSU4I1JT7rt85KVFbX4=;
 b=jC6r+UF/3Bf9H95pOOianAoy/g7keYl9Ac2VJnocdi+qPtPCwh6U+JzuE7aSd0AlZv7US/a0vO/jJbK9rxk7v9cG0ZC7h7x9k22RXurBQpYEzCjoH5YL4hCGilqVI47W9yevPgsOzDDc5Zv5rUswaUhToxvBleyTG6TAWibjGE4=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3358.eurprd04.prod.outlook.com (52.134.1.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 01:29:04 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::8026:902c:16d9:699d%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 01:29:04 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: RE: [PATCH v2 net-next] net: fec: add C45 MDIO read/write support
Thread-Topic: [PATCH v2 net-next] net: fec: add C45 MDIO read/write support
Thread-Index: AQHVWBWy5sM1nf/Z2EaYMo3nP8kt5KcGYaGg
Date:   Thu, 22 Aug 2019 01:29:04 +0000
Message-ID: <VI1PR0402MB3600ECF5617C72C6B3A97F5EFFA50@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1566387814-7034-1-git-send-email-marco.hartmann@nxp.com>
In-Reply-To: <1566387814-7034-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbfe1899-5b0c-49ae-2e66-08d726a01ead
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3358;
x-ms-traffictypediagnostic: VI1PR0402MB3358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB33585959EE5C5305BD0299EBFFA50@VI1PR0402MB3358.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(33656002)(71200400001)(66066001)(256004)(7696005)(71190400001)(55016002)(76176011)(6636002)(14454004)(25786009)(229853002)(14444005)(316002)(6246003)(6436002)(6116002)(2501003)(3846002)(64756008)(66476007)(76116006)(66556008)(66446008)(74316002)(11346002)(5660300002)(53936002)(478600001)(476003)(2201001)(305945005)(66946007)(2906002)(486006)(99286004)(110136005)(26005)(9686003)(81156014)(6506007)(81166006)(186003)(52536014)(446003)(102836004)(7736002)(8676002)(8936002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3358;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tJMKzWlQHi9MjKsuYPIoFwKdLuqUazRp/zcwU/fLC7IEyZAid4q4YIyAVg8/bAtLu/QC92TvT3mOD8eUKraJcoCzFvCTRjza7tjhde6adY8h0xwwYc7t6TM/IQZjP/d87QA968zcw0iOdQ2rHBmmPWVCvQa50bgaDaqDf1EPAczFSAOTMhJmSPdx4yfEp+O/wwhyCo6kQ3WjgktBVe2NBgboQLPSJ1p17wC1fWQ4mwIpBOub1FY+j7UWiK2p73Yp5APwvxtFw7aPX7zDb9eU1B6C3X8yNxzk2ZSPLKrQjE7X8bAppa/QtD5sSfm7ODB0kb1jM1ABtOd8fEYQqo7mp762ALgIVZU8BGusXsa/59wM4VnU6R4fvekTRx17S46IHWH2biUq8QXb9VL+JduinQqvlM9qfj7s2x1NUedT4wE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbfe1899-5b0c-49ae-2e66-08d726a01ead
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 01:29:04.5884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DwQ9KEety9mJY9F4J18aXGKqXX4tFxygFUeeeNK3edo8lOpNmUK95GcYcAjK0kmrU/UDY1fU8HARerjfXg0c+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartman Sent: Wednesday, August 21, 2019 7:44 PM
> IEEE 802.3ae clause 45 defines a modified MDIO protocol that uses a two
> staged access model in order to increase the address space.
>=20
> This patch adds support for C45 MDIO read and write accesses, which are
> used whenever the MII_ADDR_C45 flag in the regnum argument is set.
> In case it is not set, C22 accesses are used as before.
>=20
> Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
> Changes in v2:
> - use bool variable is_c45
> - add missing goto statements
> ---
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 70
> ++++++++++++++++++++++++++++---
>  1 file changed, 64 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index c01d3ec3e9af..cb3ce27fb27a 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -208,8 +208,11 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet
> MAC address");
>=20
>  /* FEC MII MMFR bits definition */
>  #define FEC_MMFR_ST		(1 << 30)
> +#define FEC_MMFR_ST_C45		(0)
>  #define FEC_MMFR_OP_READ	(2 << 28)
> +#define FEC_MMFR_OP_READ_C45	(3 << 28)
>  #define FEC_MMFR_OP_WRITE	(1 << 28)
> +#define FEC_MMFR_OP_ADDR_WRITE	(0)
>  #define FEC_MMFR_PA(v)		((v & 0x1f) << 23)
>  #define FEC_MMFR_RA(v)		((v & 0x1f) << 18)
>  #define FEC_MMFR_TA		(2 << 16)
> @@ -1767,7 +1770,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> int mii_id, int regnum)
>  	struct fec_enet_private *fep =3D bus->priv;
>  	struct device *dev =3D &fep->pdev->dev;
>  	unsigned long time_left;
> -	int ret =3D 0;
> +	int ret =3D 0, frame_start, frame_addr, frame_op;
> +	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	ret =3D pm_runtime_get_sync(dev);
>  	if (ret < 0)
> @@ -1775,9 +1779,37 @@ static int fec_enet_mdio_read(struct mii_bus
> *bus, int mii_id, int regnum)
>=20
>  	reinit_completion(&fep->mdio_done);
>=20
> +	if (is_c45) {
> +		frame_start =3D FEC_MMFR_ST_C45;
> +
> +		/* write address */
> +		frame_addr =3D (regnum >> 16);
> +		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		       FEC_MMFR_TA | (regnum & 0xFFFF),
> +		       fep->hwp + FEC_MII_DATA);
> +
> +		/* wait for end of transfer */
> +		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> +				usecs_to_jiffies(FEC_MII_TIMEOUT));
> +		if (time_left =3D=3D 0) {
> +			netdev_err(fep->netdev, "MDIO address write timeout\n");
> +			ret =3D -ETIMEDOUT;
> +			goto out;
> +		}
> +
> +		frame_op =3D FEC_MMFR_OP_READ_C45;
> +
> +	} else {
> +		/* C22 read */
> +		frame_op =3D FEC_MMFR_OP_READ;
> +		frame_start =3D FEC_MMFR_ST;
> +		frame_addr =3D regnum;
> +	}
> +
>  	/* start a read op */
> -	writel(FEC_MMFR_ST | FEC_MMFR_OP_READ |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +	writel(frame_start | frame_op |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
>  		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
>=20
>  	/* wait for end of transfer */
> @@ -1804,7 +1836,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,
>  	struct fec_enet_private *fep =3D bus->priv;
>  	struct device *dev =3D &fep->pdev->dev;
>  	unsigned long time_left;
> -	int ret;
> +	int ret, frame_start, frame_addr;
> +	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
>  	ret =3D pm_runtime_get_sync(dev);
>  	if (ret < 0)
> @@ -1814,9 +1847,33 @@ static int fec_enet_mdio_write(struct mii_bus
> *bus, int mii_id, int regnum,
>=20
>  	reinit_completion(&fep->mdio_done);
>=20
> +	if (is_c45) {
> +		frame_start =3D FEC_MMFR_ST_C45;
> +
> +		/* write address */
> +		frame_addr =3D (regnum >> 16);
> +		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		       FEC_MMFR_TA | (regnum & 0xFFFF),
> +		       fep->hwp + FEC_MII_DATA);
> +
> +		/* wait for end of transfer */
> +		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> +			usecs_to_jiffies(FEC_MII_TIMEOUT));
> +		if (time_left =3D=3D 0) {
> +			netdev_err(fep->netdev, "MDIO address write timeout\n");
> +			ret =3D -ETIMEDOUT;
> +			goto out;
> +		}
> +	} else {
> +		/* C22 write */
> +		frame_start =3D FEC_MMFR_ST;
> +		frame_addr =3D regnum;
> +	}
> +
>  	/* start a write op */
> -	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +	writel(frame_start | FEC_MMFR_OP_WRITE |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
>  		FEC_MMFR_TA | FEC_MMFR_DATA(value),
>  		fep->hwp + FEC_MII_DATA);
>=20
> @@ -1828,6 +1885,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,
>  		ret  =3D -ETIMEDOUT;
>  	}
>=20
> +out:
>  	pm_runtime_mark_last_busy(dev);
>  	pm_runtime_put_autosuspend(dev);
>=20
> --
> 2.7.4

