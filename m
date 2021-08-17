Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC53EE4AB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhHQC7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:59:48 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:61261
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233678AbhHQC7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 22:59:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtouDZWWkEqoeeqlb5HyAAO89h8kRS1QpO+yD1Fqgltuag5HA2CP1lsq83hwRkJTXqCCZYRz6TDqdxwvdfEtgf5fN46St0ipYudbfME3CmsveLNeHgWc+R4Ywc2driGoutq8rQxby0naDR+E1lk4kAe7BxWoYQl89GQkMdx/hsBNDlo97SXpTUV0FmuryDgKO7jur/d22c1GT+e69hRE2l/4I/9En04UrO7XPQGCvKfL2YcQ5AMYXBhcOG5/chrhDVtoNM04Tcgct9Cyyhz1Aqj5HSujsliUyL14xOk3Qg3DfKO3MOTYU8f87O2MEoWCkBK05RdMHLcmKu5XUhVQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE7AZSEh2dSjXAwu583aPSkSdFMlFI2psrG5K74sJN8=;
 b=LGVRDK2XDk4GcsVD/ZL/MVY+WdyK/JPCbmu/JiyDwr6fUnoeDo+OFz6z+qdhpLlRqIZ63xYji5p/Cs8xm2VWzWWKXhwcjQATOsmBFpUqfJwLmZoBbMXLyHRnmwWBfUGHsvOPeRXeDF4+mqrI1F/R1yxo8YWxA5Ki9sME4K9gOD+f7AlpykW0Ghc0D06O/1ESNPmbp1Du+jgsNoR61itQj+NYMGMCxydCRTuLR0Ol2hZqZ9qFHMrUjo0kJUtCnp05PfrIUs1PVbrTOW8N0u+AIy6aD3ODMUss0Ua+xBscoitBtif7Ue7QRJaZTm68MHWsLSxXz0Ycz5x0wdMbWV6mSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE7AZSEh2dSjXAwu583aPSkSdFMlFI2psrG5K74sJN8=;
 b=pDfHNskskmTzlAodIe8PsPqQtFot0OdICx0cqKZiOVGLCYPDA7E7aCcV4RvbBJCVZcje57oiVGyAvjwRvC0tvT/Lvy6i7bGiam56BTvm3kkPz0NMv3K5YAm4J82MrKA9U2Ge4Kfise98XsGDp9MzN1Env9n/Xxm5dgRi834aMJs=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB4830.eurprd04.prod.outlook.com (2603:10a6:803:62::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 02:59:08 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23%3]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 02:59:07 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Hongjun Chen <hongjun.chen@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Topic: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Index: AQHXj+75u2Pfw5dj90eW5XnXIP17J6txaSUAgAAItjCAAAd1AIAELgBQgADGioCAAJX5gA==
Date:   Tue, 17 Aug 2021 02:59:07 +0000
Message-ID: <VI1PR04MB5677BA91547DC2228F615CEFE1FE9@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210813140745.fwjkmixzgvikvffz@skbuf>
 <VI1PR04MB56777E60653203A471B9864EE1FD9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210816174803.k53gqgw45hda7zh2@skbuf>
In-Reply-To: <20210816174803.k53gqgw45hda7zh2@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6903d69e-97e6-4140-3de4-08d9612afafc
x-ms-traffictypediagnostic: VI1PR04MB4830:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4830A3A087207E1DEECEC6B1E1FE9@VI1PR04MB4830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Y7lV7T1LtE6oJcp/vAaqCSbFQREAffDdG5gm69kSeIRwvKE/2quQwZrSIdeh1g1DZHRbs6Tb2tySCEAQjZbbjNwdVCkWd65jBCP562yiQDnbtWT2SqlsvPwRZvFCgx/T35vXDSp4IsuAS4niZFK/WBhrx5Ghh4IOKr2xfEZRrZSIClwRClZ5O8PSVBsFdlpdHZLmgwYXmUrX2ualRuletK4A3FhVhHgUzOqjdd1aejF8HKEaQmMtoIk4s9WC/Dqesf+brhaUl67ZybYvdC6/+P4zEif9RnTA/di9LUJlznOgAQTaLaePXf+3vKfrS9N+8IfBBDYmEeOmCeHPd0Xz54Fhf24Ajl3DNSi8kZaIHMa7nMBVBpiKOvy/lVc6riCRiZjhD4fFAPDQv0F0MWS0vk3DP++mubWber6CoGxUUqYwMFNRB+lMRgRPmabIoePM4V9we8YmNIzJzIQQZq1mBKyUpFQ1eJKsnZka6Kke4Q8EucBilDf+EQ9yRyorB1McP2z6vieezLhjG7HW3QD6eO+NPCrEFfDnZoiNEQbztLd06Pmkliw0ipnpIl8Gt/frpsk6EUNxrQ5nQRW0W9O1InjhsSPzelFAQMCtcm5kY3oO6psnWLA0UodlFE1SyFJ6cu+oJlkiW15DTUr1r4U1567QyyrnFbe+UbUY6Za/hgSwywDcC3D+M3iyusPS5kQIvjdSm+kCCkVmZ9bstMVKZwp3j7glPCwMvDBuSttxHQ7kVzsESCasaEg7zXXSeJ3gr5G36giQzKT5bu8reEQoPtoeoZHmHYLSauob9jSaba+16631K9dbMTUMups+Tft9dXsLGLQKhy/Sv3fBwNZrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(478600001)(7696005)(7416002)(8936002)(33656002)(8676002)(122000001)(4326008)(38070700005)(38100700002)(71200400001)(966005)(44832011)(6862004)(83380400001)(26005)(316002)(9686003)(6636002)(5660300002)(52536014)(54906003)(55016002)(6506007)(186003)(2906002)(64756008)(76116006)(66556008)(66946007)(86362001)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HfO7JRQppvjNN/MQdk0EjHeuEG4TiHXIdsMQDFHu8Tlbnp2YJ7+LC02kYOjm?=
 =?us-ascii?Q?RQhngOX3N9Qtmabr7OBBm4UxQ9azVRYc14jUVmldCHzwOhh+ZCNnaDsPrgHV?=
 =?us-ascii?Q?oAWS1CB0WzXLFvSfrhyaq+AyGmLLCAJq/jbh7HweUrAfOAMpeaupEVuLLFDM?=
 =?us-ascii?Q?c9LtX+uCWvAw4037GJOBp3JYfjXsbcnNz8LGYSxRbbeVsC9pRMk1h75gC2eg?=
 =?us-ascii?Q?sUrInRsMj9NdKjn3UBMPor7FeBY+15tMjCEVfpF8ePUaFpNCAlswJp8btivJ?=
 =?us-ascii?Q?VCPVSGB+evkBW7Awhg9Abv0VctSTvj+7S03nncOynHRsMbPOkbZEP/l6FJdx?=
 =?us-ascii?Q?rTCm4H/PPkTSy466Hbv1sGArfEVsRjR3vpjXL5CQyxpnduoHYPz7V/XbIish?=
 =?us-ascii?Q?ToFweJ6cU/8AYf1EPL1l9xU4LvO9t3iCg/2d3GY/minyJvALba0Zmr/v5+mO?=
 =?us-ascii?Q?6WCSxLDRvjwr0U9RHIVGOXvyM3MMV1BBEQRWtmQHyvgcL31uoDIRMruT8xcA?=
 =?us-ascii?Q?egkSUf397ahJOvUIc8ck6RC2RzGF+Ar+vtSGkoUOZ4acZahMRw3xbe1POB/A?=
 =?us-ascii?Q?zRZuQsbpy6pkXT8cZlMJ6N1qS1qc/0uxg48untpkwKH3FDdZxxJlhDcn+hbn?=
 =?us-ascii?Q?4phBUMNh/Fi7CBttyHtSXp4SO4LYoocOCiZuRoxD/l/x7Wya0MvbvtfaW31g?=
 =?us-ascii?Q?NSDl1VcKuBvvBjN2cBDD+XlQj6/OqcRBuqkr7FGGZxTnauuyXtuw8iTwl9ng?=
 =?us-ascii?Q?O5pn/4aU/jHGZH0TYbQMCU/YZI5pqQSR32yhcFEqPfDbsG9ior2EQhPNVdOt?=
 =?us-ascii?Q?BUvfTez1APycja0QMVxdjJSyQ777TTxPt7z2r8stailnLlUaCu3X+GN41zCi?=
 =?us-ascii?Q?Rf/fgxU4tRCJ+V04wRK53q3x2ny1APf5U9eAeuMqpX2dEoXRLDhLQsJRFklS?=
 =?us-ascii?Q?wry886+8nTCHraRj1JQCqGq72OKS6ZLTjTw4H0YRiVnIXG9kbgLoB5YrG/tZ?=
 =?us-ascii?Q?S6hNwpJCXqSd14V21uYBBx93Ubh1QtsYhFRiPrSrd67z8cX+SnK2to+Qr4mF?=
 =?us-ascii?Q?RVNNkm0B3QYDjhRfxH5O4NzqWqHefyHKsQTeVtChhHA0KtZiDvoOPdiv7x4d?=
 =?us-ascii?Q?o0SSn7k2dIR2MbPVpzLDALZIc+Xzz9guWRmU5Xpd8dU+/JvIDtvvTnFezXWw?=
 =?us-ascii?Q?9W93exCdhMCKNqOCW5oh5+IQ09/V7k/ICCwPDS8hHPnZt/c404pq67vK7wkb?=
 =?us-ascii?Q?WOv6UpSCOFv6bo73eo86jUl0vtGrN173rbZV/r6b1sEXDYfNTK7C7YaP4tZI?=
 =?us-ascii?Q?UmM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6903d69e-97e6-4140-3de4-08d9612afafc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 02:59:07.4952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKqsMT15aoRhdmC/mGNpCRkkhLsQf+FFT4RNggEsEAdJHZ9g05yGAYFDTpcqAKvG3cQT7kdA9wmt4yH4kdT44w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4830
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mon, Aug 16, 2021 at 06:03:52AM +0000, Hongbo Wang wrote:
> > > I was going to suggest as an alternative to define a device tree
> > > overlay file with the changes in the CPU port assignment, instead of
> > > defining a wholly new DTS for the LS1028A reference design board.
> > > But I am pretty sure that it is not possible to specify a
> > > /delete-property/ inside a device tree overlay file, so that won't ac=
tually
> work.
> >
> > hi Vladimir,
> >
> >   if don't specify "/delete-property/" in this dts file, the
> > corresponding dtb will not work well, so I add it to delete 'ethernet' =
property
> from mscc_felix_port4 explicitly.
>=20
> Judging by the reply, I am not actually sure you've understood what has b=
een
> said.
>=20
> I said:
>=20
> There is an option to create a device tree overlay:
>=20
> https://www.kernel.org/doc/html/latest/devicetree/overlay-notes.html
>=20
> We use these for the riser cards on the LS1028A-QDS boards.
>=20
> https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tree/=
ar
> ch/arm64/boot/dts/freescale/fsl-ls1028a-qds-13bb.dts?h=3DLSDK-20.12-V5.4
>=20
> They are included as usual in a U-Boot ITB file:
>=20
> / {
> 	images {
> 		/* Base DTB */
> 		ls1028aqds-dtb {
> 			description =3D "ls1028aqds-dtb";
> 			data =3D
> /incbin/("arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dtb");
> 			type =3D "flat_dt";
> 			arch =3D "arm64";
> 			os =3D "linux";
> 			compression =3D "none";
> 			load =3D <0x90000000>;
> 			hash@1 {
> 				algo =3D "crc32";
> 			};
> 		};
> 		/* Overlay */
> 		fdt@ls1028aqds-13bb {
> 			description =3D "ls1028aqds-13bb";
> 			data =3D
> /incbin/("arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-13bb.dtb");
> 			type =3D "flat_dt";
> 			arch =3D "arm64";
> 			load =3D <0x90010000>;
> 		};
> 	};
> };
>=20
> In U-Boot, you apply the overlay as following:
>=20
> tftp $kernel_addr_r boot.itb && bootm
> $kernel_addr_r#ls1028aqds#ls1028aqds-13bb
>=20
> It would have been nice to have a similar device tree overlay that change=
s the
> DSA master from eno2 to eno3, and for that overlay to be able to be appli=
ed
> (or not) from U-Boot.
>=20
> But it's _not_ possible, because you cannot put the /delete-property/ (th=
at you
> need to have) in the .dtbo file. Or if you put it, it will not delete the=
 property
> from the base dtb.
>=20
> That's all I said.

thanks for the detailed explanation,
I have got your point.

thanks,
hongbo

