Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD88126C31
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfLSTBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:01:53 -0500
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:30183
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729954AbfLSSuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjgm3sP/xZZ+Uq5N9PMfOc/BOdYPmxX6FKes9WEtQSmO/COcw4pfpoHj6dBNWyDNYrsejXHRVDO/d8/0/WWfZh2eLSM1h7TIEhSLnVBbxUbk1PGX60xQDnuvY8gpTtQGxBVT5VnCE0VR03nj22AxIJCMDPMFajEhAg8Fk498PI8W8de6FkfLTbNGmUfvo5DohT8yCgCpLLLtUeD9csVBjjaJ1aUtxVQt4D6uPrYS6v/8vARwugz+2yfZ7AuWazK75xFK549qc6BjgFLo/XKYHEvQY+eARLn2XTVK+4IhPXPVFocYvJiXvni7GwBlXsoR6e9E5l+lge34spWJYx5Ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oGYvh3Tvye5Cz1ASfUZqcOvafB+pQUS1ydp0FwL0lM=;
 b=ifJG/PdvdKDogrh3/aMf+0UymVKYseWkkxYFIJbGcegHfUCHS2p/b3K7kGDx8vXyh/b87k5frY2K7QBbSpoTieOeY+JWkJioKvZtXFXROUaQtOL2cSNQt/nm/m6KoAHvrVzcWItNs8HYCTgrPeiCfe/TDKahQm0PRPAE++ueCiNIWIXT6RdKEdcnRyQ1mrnvWmmEIljloMm/Fmh3yx0lg7Ic/kVyaxVRG0X+TqKF3Seqnj82OkUDui1xseCc9Mg0XYxMKS6f++EX6bKUrRybMawAI7EDEAjsrewROqfQxOL8tq5OMmAtIASPtJ+9VFS05J493N0THPyGBXrYGtZD1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oGYvh3Tvye5Cz1ASfUZqcOvafB+pQUS1ydp0FwL0lM=;
 b=WSGNJYbxwjYz1vpADM0RDuIhJEUbg4SJ6WMfmT2K1aLwU/fFo4bOG2193gm6D58+M2VlvBiw4cCpYKpWkyGzhIRCijNI4+pGqPohsG9zNzoXmNZTKrs0COveR7p3w/uXIKmnUkL2QkcAVCwT9+y5dhJ9k8x4ak9Rtga5VcxFYfk=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB6160.eurprd04.prod.outlook.com (20.179.27.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Thu, 19 Dec 2019 18:50:16 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 18:50:16 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Subject: RE: [PATCH 5/6] net: fsl/fman: add support for PHY_INTERFACE_MODE_SFI
Thread-Topic: [PATCH 5/6] net: fsl/fman: add support for
 PHY_INTERFACE_MODE_SFI
Thread-Index: AQHVtpH/Ss+S3H5dGE+6PcWOMQG+h6fByyqg
Date:   Thu, 19 Dec 2019 18:50:16 +0000
Message-ID: <VI1PR04MB5567899CDB9A9F36297CF236EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-6-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219173016.GD25745@shell.armlinux.org.uk>
In-Reply-To: <20191219173016.GD25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06fe249f-30b8-40b6-ea7d-08d784b449c6
x-ms-traffictypediagnostic: VI1PR04MB6160:|VI1PR04MB6160:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6160A916B2033AB1262E5AF3AD520@VI1PR04MB6160.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(54094003)(199004)(189003)(13464003)(33656002)(186003)(4326008)(6916009)(26005)(9686003)(8936002)(53546011)(86362001)(6506007)(54906003)(2906002)(316002)(478600001)(5660300002)(76116006)(52536014)(8676002)(66946007)(81166006)(66556008)(64756008)(81156014)(66446008)(66476007)(7696005)(71200400001)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6160;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eC982kCEvyZNWhGGSyEd9gA9ngKOi/qBfwumSWnUIzLDOLi5Nu6ZcM5gDB4CbHq8BhXSd0QMKS68yXBHbaquKed4zTUAz3m46L8xcOxxTg0pbyi78y/hn13eMtt3pXfmAQvPbisF+ZRpGe1+srlyY1m3b3UpG9uCgCim5CAsPjvSJXb6Cg40qKP13g3g2Sg4FUrfZ/7QV4aMO6/kwJ5928xVJp4xCOGxJ5cueIxFSL03/7EnAECoK4Uh20Lf7h79+3HN4ayWSuYEY2Arivzkb0pNkvYEljXGPSxVdy/86b6KofW69Di0Rk7xYdjoWEF0PQwwPI1kaXsEZz/RkJQUWJ2mgUzoxgvyTfObqlAid26+zwf8qDasaa5Hmi1NE2Pq0RLZE8tpYPvZSSHt0w2vU4n/s6dXL8Yhbd2G3sQGMtiuYrX1EK+R2Ofx0sDtg3slhHICOXJIYNIi+X20paYzCZDD/+oig0aNPabPBZPKFrcnkA3An7FLCraJbYAiF9vfmd/T0Z22dz8yvE82oNhqEg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fe249f-30b8-40b6-ea7d-08d784b449c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:50:16.1268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PNZGcQSFcWYr/Ng8iSJ8b5z8gx8eW8dMhhhi0UPn6kkoGqEaawB5ZVf+wbCc6ZU6XprcZRKiNLNYeAd0TlsoFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Thursday, December 19, 2019 7:30 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> devicetree@vger.kernel.org; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>
> Subject: Re: [PATCH 5/6] net: fsl/fman: add support for
> PHY_INTERFACE_MODE_SFI
>=20
> On Thu, Dec 19, 2019 at 05:21:20PM +0200, Madalin Bucur wrote:
> > Add support for the SFI PHY interface mode.
> >
> > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/fman/fman_memac.c | 2 ++
> >  drivers/net/ethernet/freescale/fman/mac.c        | 2 ++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
> b/drivers/net/ethernet/freescale/fman/fman_memac.c
> > index d0b12efadd6c..09fdec935bf2 100644
> > --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> > +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> > @@ -440,6 +440,7 @@ static int init(struct memac_regs __iomem *regs,
> struct memac_cfg *cfg,
> >  	tmp =3D 0;
> >  	switch (phy_if) {
> >  	case PHY_INTERFACE_MODE_XFI:
> > +	case PHY_INTERFACE_MODE_SFI:
>=20
> No difference between these two.

Until we get to some erratum implementation or other HW that may need it
there's no difference. Then we'll add it and churn code wondering if it's
really XFI only or also SFI. Just as I wonder if AQR do support 10GBase-KR
backplane as a PHY-MAC interface...

> >  	case PHY_INTERFACE_MODE_XGMII:
> >  		tmp |=3D IF_MODE_10G;
> >  		break;
> > @@ -456,6 +457,7 @@ static int init(struct memac_regs __iomem *regs,
> struct memac_cfg *cfg,
> >  	/* TX_FIFO_SECTIONS */
> >  	tmp =3D 0;
> >  	if (phy_if =3D=3D PHY_INTERFACE_MODE_XFI ||
> > +	    phy_if =3D=3D PHY_INTERFACE_MODE_SFI ||
>=20
> Again, no difference between these two.
>=20
> >  	    phy_if =3D=3D PHY_INTERFACE_MODE_XGMII) {
> >  		if (slow_10g_if) {
> >  			tmp |=3D (TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G |
> > diff --git a/drivers/net/ethernet/freescale/fman/mac.c
> b/drivers/net/ethernet/freescale/fman/mac.c
> > index 2944188c19b3..5e6317742c38 100644
> > --- a/drivers/net/ethernet/freescale/fman/mac.c
> > +++ b/drivers/net/ethernet/freescale/fman/mac.c
> > @@ -542,6 +542,7 @@ static const u16 phy2speed[] =3D {
> >  	[PHY_INTERFACE_MODE_QSGMII]		=3D SPEED_1000,
> >  	[PHY_INTERFACE_MODE_XGMII]		=3D SPEED_10000,
> >  	[PHY_INTERFACE_MODE_XFI]		=3D SPEED_10000,
> > +	[PHY_INTERFACE_MODE_SFI]		=3D SPEED_10000,
>=20
> Again, no difference between these two.
>=20
> >  };
> >
> >  static struct platform_device *dpaa_eth_add_device(int fman_id,
> > @@ -800,6 +801,7 @@ static int mac_probe(struct platform_device
> *_of_dev)
> >
> >  	/* The 10G interface only supports one mode */
> >  	if (mac_dev->phy_if =3D=3D PHY_INTERFACE_MODE_XFI ||
> > +	    mac_dev->phy_if =3D=3D PHY_INTERFACE_MODE_SFI ||
>=20
> Again, no difference between these two.
>=20
> I just don't see the point of perpetuating the XFI and SFI names for
> something that is just plain 10GBASE-R.

If we do not let current maintainers properly describe their HW now,
when it's fresh and in active development, if we ever decide to
disambiguate later who will pick up the task of determining what 10G*
it's actually meant there? I kind of went through this exercise for
a similar change in u-boot (old platforms used XGMII instead of XFI/XAUI)
and tracking down each of them, making sure they work is a pain (still not
done testing all of them thus no patch sent yet).

Regards,
Madalin=20
