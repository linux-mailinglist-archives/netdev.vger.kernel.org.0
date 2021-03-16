Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9633E21A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCPX2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:28:53 -0400
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:24864
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhCPX2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:28:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1Wq60N/v+8y/udLie5lAgHaVXcJfngDLZtth3oJV14V7Kn3BrAUSlfwVEbaqe8LwNwEO7Z8hXXeHz0TIS3TM966cmAt8AsIHNOsmVJjVSX6PzMcB8wEOQoPAHMrcvbNeBqwRRNGtFqfB97V15r/+Ne4IpN3ADfmac0G++/LD5lKKvsRU4dZEabXy1wO86f+0W9Wq49Z5WeSWJAA3Cdurb9Yjp/44ytgX/MidPQ3IeuUORNMyK/xsPTZAbZEn1oV3OY9xARsCd35RQEMSEhbBc5dFkHSUsrbuHr+XdP4W4s0N9dHOdO/u+G/R74anFLyIYllXcSyxuklyuEBHLDiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx4xTw35PBQMePpiI0tDCcxlyGxM8VG0vlGfjAPSf8k=;
 b=XSBU37QNoAzwFmr7cv2xML3DaTU+Jr9JJtd68/OJfdsQ7p1nqnI/AnWD6UfwCRXRO9goTKkQUtb9yjVruxxYPygfurcqsrwqvJvE4c7E3SbujCikhx9HTgJ3XiAH6rUZ9fOT5xrK6buh32Mub5QFYb0TIXreTDoPuS3puQKSGUwUhj8TqA0J4o2pX5fNFyThyaaqBw6arFd/TCv4J9GtGYJXIcCfTvCFBwwR6YujHLp3975wj8RazzhTEB9B0WkiPrFT8t8/KqFaET6QRRJRTaN8Yl3X0bvz21t3wJ1T3lOICcd+Lv4o2PNi9rcsa6OfIlf2T9nCXGxDpDFhOaBNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx4xTw35PBQMePpiI0tDCcxlyGxM8VG0vlGfjAPSf8k=;
 b=tSdnJ5nRNxOvQekgcpLSuO9eRjBszc39ysfVEBibIltDx9S4P5B4MIDBy4NpAsa21Yk5emQSc+47B0g3xjo7dgdSRM/YtrkTW3lbFzdNvxx92pyhnjguyH0V8MMBwccIIC5b6Bmy+TfgtDbgdz9YobHkox1BDE/nt/xxur5UWWXe4eT4qVHXsAZS3AyMSoURN0doOfXfO6gFAvaCen+MrIc9e53ucpnOPKsvk6OtY2lqmKC15x2dO5xXp3c/yfAqYvqD7WDyoZF5M402uYpFupe4DJSBUimh40SV93Wc44eupwbYo6MBRVyAQvxXPq78u1pKkipLHqMOzjTErf1Wew==
Received: from MN2PR12MB2975.namprd12.prod.outlook.com (2603:10b6:208:ce::14)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 23:28:29 +0000
Received: from MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::2de7:6756:b3ff:2d67]) by MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::2de7:6756:b3ff:2d67%5]) with mapi id 15.20.3955.018; Tue, 16 Mar 2021
 23:28:29 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXFatuzchVdMpJhE6oZ9hIKfPRqap/oO0AgAeovSA=
Date:   Tue, 16 Mar 2021 23:28:28 +0000
Message-ID: <MN2PR12MB297560E219744B3B1E2A768FC76B9@MN2PR12MB2975.namprd12.prod.outlook.com>
References: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
 <YErPsvwjcmOMMIos@lunn.ch>
In-Reply-To: <YErPsvwjcmOMMIos@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94b97b5d-dd16-4180-3bde-08d8e8d3348b
x-ms-traffictypediagnostic: MN2PR12MB2880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB28802FE9938DA77CBB9DFBFDC76B9@MN2PR12MB2880.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7eY8O3GfutYcdkFMa79iALPfnT8aniO7yGVbpd+cdxRFsUNorFRXRkzNNmwpotxk9SK6D7VOCHVl3gGE2bh8iLa/LOUipGTVSlIos/H2e5p1SZ7N3SdgrUw5LBGPZBIJJSsox2zafe+9gagnqv2aJjGXLnq7kYVjp5T18JhJ8alg7fyBkwFRO2rwa7RYaGrt0VamSiJcTrwK/bg7vy7ND29i8IYSXjgDLLZV45YfcdnFLzEvR5fTN685/Qr0AuBLn+Ab9WJ5lvDp0kc1hcKnQfoU3beKLhW+IzZGoiNzKIB1QMTVV6WrjXHfmWhNxDI2Rm+ApWSGjwRHAL6FfT1buJcx3xQsPVnHm/B1Mkzei9viZgISn3rBW+lLu/ZPE/30NtqpK2nwE2EFSoR5ldESvkcMmSHODV0jfz6lQBEulHkt5zUJ3FlMpP+sdoazd7+2pjwOhEg99qsdPFKzCq1uglcU/6JCQWo9jrYna2+INGbtj2jakXurJhZNuE8bHCiyvo7N3ZZHKjPfBgSaj5KzVIc303R361nuYZ5DIzRgmV/LDcrVKBoHiOBU3y9pzvVx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2975.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(83380400001)(316002)(5660300002)(2906002)(66446008)(33656002)(55016002)(6916009)(86362001)(54906003)(6506007)(9686003)(478600001)(107886003)(4326008)(8676002)(71200400001)(7696005)(52536014)(26005)(53546011)(66946007)(186003)(76116006)(66476007)(66556008)(8936002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VYJH6Bg5tI0AxnMXkOrXk4rbpIXJf2y07aq5+PiRwLf1Ec5HDnemWLcxc7QA?=
 =?us-ascii?Q?/PX+Mdj0KBffzHlGoxA1a6xCnMdt5IRNQt1qNxCJc0q+ICOXGiIzJRjcwQJK?=
 =?us-ascii?Q?eigWEMSRTa/9S6hzZHnXVR2l9Kn5OumXwL6G4Ij2Vw2n4s9a8yDGx6dxLZuo?=
 =?us-ascii?Q?zazYY0rM3fDkkb1doD6ed/N5GJNOoRYydZ6OlGgvaYjM+jyzCQ7W2dhH5PbZ?=
 =?us-ascii?Q?zB0u+6vSzDcn6o6JrV19DHpC5xYfShyhtLMvVbmNtsJG3zuPGPyy/rEKC915?=
 =?us-ascii?Q?2QCgN/vjs6XylgZo4/+gaIrpYv1tdtSM3dSiwLlw6G4dKtI4WwtbzP7XRNaB?=
 =?us-ascii?Q?+xAki+2tSktsGwwXZGkIzOA5+jWM/nuQUzNqPPfNXO5YkPf3e4jO9gyexfWy?=
 =?us-ascii?Q?A9eveYVtoeUkgKGjPWSGKcdHb8+gseEkrdlvYN6MKxoNlyvNCrqPBtxwDOze?=
 =?us-ascii?Q?DKQ0ja9FiUdpu5yFmLHtAYp7kC73iBWmQ3HgDJQvYVpxWXV3YYHn4xp/VVwx?=
 =?us-ascii?Q?Ig+vi1S9FKcLvMU2H1Wu441k8aXyRsGdyEKMpg3aJo0cgWHH+d43f6rAyOyg?=
 =?us-ascii?Q?np8xIaxMRRcfEYPgRc5QPTBFQfp4zM9YUCx68t8vMKb432HvvNPcFTL5Ce8V?=
 =?us-ascii?Q?k4n5Xs3lxNN6tXwMA7GBJLwD4YF+OUQaLq9YOLIRd5BbPcjZHvB26lqrS6Vq?=
 =?us-ascii?Q?MsvfbVRh/5etrylLhMxWWCGIoqt6VlJJJ+kt4V/bEAT5nL5+XXi3ScCjiQtQ?=
 =?us-ascii?Q?K1mpuFIi4Ky9QzrCBwOl+53ukIa0Jrci51mKP0wQUfD6WGkDwLIcx950jn21?=
 =?us-ascii?Q?7jNecHW69rNrtexMDgz1fuPZe4nPV4b2oReLuH/O5PDbkCrV/+xwsQcyq4Hg?=
 =?us-ascii?Q?L1j5KsrTotS86AOlprzBY+FctFfbPckr83KKdbmfm1AjxViBmIf2f8OSYs6b?=
 =?us-ascii?Q?BBb3nTDvaXJ4X4sUnHjhFzDYwaz/D8NaeUYrbF8FZG4w2z15lWhwkpV+P0DO?=
 =?us-ascii?Q?c2oYMk8xnkbSyn733qkZzGO9n8M1MChfoutcNHhZu71RmNgNNMhUOh6NCghh?=
 =?us-ascii?Q?/PNUu59D5D0LoMNsK/NOIN2+ovHCAGLG9E/+7jfb1oZoAJATh3axl7n55sMq?=
 =?us-ascii?Q?YM14DZI8jmc8MukZkyLcBYbQadu+fqXkn59Ii1OCIgG6SFAO6KPlYAf9Ansh?=
 =?us-ascii?Q?hflL0BepVpwPgkqYU8po0wsqEt1VPsb2W+LoCnhjnjAtV2oUte+Z4gmthXLy?=
 =?us-ascii?Q?DEbNqhSGwkJKNKJ2QgBZomzyli2pGmpDuKKGT4pPPHSzFOyCwmODYskgwD9W?=
 =?us-ascii?Q?pEwspgMtmJBX0sEBhfPdupIk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2975.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b97b5d-dd16-4180-3bde-08d8e8d3348b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 23:28:28.9179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NvjdMnfi2Y4c7UdrcSPIa3mN13ACsWVdiqJWQf6khVPFcKG2nS3ph0ul1BjA5F2nqO2hQZAsQ4yEHHqCJapDNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, March 11, 2021 9:20 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; Liming
> Sun <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet =
driver
>=20
> > +#define DRV_VERSION 1.19
>=20
> > +static int mlxbf_gige_probe(struct platform_device *pdev) {
> > +	unsigned int phy_int_gpio;
> > +	struct phy_device *phydev;
> > +	struct net_device *netdev;
> > +	struct resource *mac_res;
> > +	struct resource *llu_res;
> > +	struct resource *plu_res;
> > +	struct mlxbf_gige *priv;
> > +	void __iomem *llu_base;
> > +	void __iomem *plu_base;
> > +	void __iomem *base;
> > +	int addr, version;
> > +	u64 control;
> > +	int err =3D 0;
> > +
> > +	if (device_property_read_u32(&pdev->dev, "version", &version)) {
> > +		dev_err(&pdev->dev, "Version Info not found\n");
> > +		return -EINVAL;
> > +	}
>=20
> Is this a device tree property? ACPI? If it is device tree property you n=
eed to
> document the binding, Documentation/devicetree/bindinds/...
>=20

This driver gets its properties from an ACPI table, not from device tree.
The "version" property is read from the ACPI table, and if an incompatible
table version is found the driver does not load.  This logic allows the ver=
sion
of the driver and the version of the ACPI table to change and compatibility
is ensured.  If there's a different/better way to do this, please let me kn=
ow.

> > +
> > +	if (version !=3D (int)DRV_VERSION) {
> > +		dev_err(&pdev->dev, "Version Mismatch. Expected %d
> Returned %d\n",
> > +			(int)DRV_VERSION, version);
> > +		return -EINVAL;
> > +	}
>=20
> That is odd. Doubt odd. First of, why (int)1.19? Why not just set DRV_VER=
SION
> to 1? This is the only place you use this, so the .19 seems pointless. Se=
condly,
> what does this version in DT/ACPI actually represent? The hardware versio=
n?
> Then you should be using a compatible string? Or read a hardware register=
 which
> tells you have hardware version.
>=20

The value of DRV_VERSION is 1.19 because it specifies the <major>.<minor>
version of the driver.  This value is used by the MODULE_VERSION() macro.
During the review of a prior patch version I was told to remove the use of
the MODULE_VERSION() macro, so it is not shown here in this review.  Please
let me know if the removal of MODULE_VERSION() is advised.   There could=20
be a different #define, e.g. "ACPI_TABLE_VERSION 1" instead of overloading
the DRV_VERSION via the (int) cast.  That would probably make more sense.

> > +
> > +	err =3D device_property_read_u32(&pdev->dev, "phy-int-gpio",
> &phy_int_gpio);
> > +	if (err < 0)
> > +		phy_int_gpio =3D MLXBF_GIGE_DEFAULT_PHY_INT_GPIO;
>=20
> Again, this probably needs documenting. This is not how you do interrupts=
 with
> DT. I also don't think it is correct for ACPI, but i don't know ACPI.
>=20

Right, the "phy-int-gpio" is a property read from the ACPI table.
Is there a convention for ACPI table use/documentation?

> > +	phydev =3D phy_find_first(priv->mdiobus);
> > +	if (!phydev) {
> > +		mlxbf_gige_mdio_remove(priv);
> > +		return -ENODEV;
> > +	}
>=20
> If you are using DT, please use a phandle to the device on the MDIO bus.
>=20

The code is not using DT.

> > +	/* Sets netdev->phydev to phydev; which will eventually
> > +	 * be used in ioctl calls.
> > +	 * Cannot pass NULL handler.
> > +	 */
> > +	err =3D phy_connect_direct(netdev, phydev,
> > +				 mlxbf_gige_adjust_link,
> > +				 PHY_INTERFACE_MODE_GMII);
>=20
> It does a lot more than just set netdev->phydev. I'm not sure this commen=
t has
> any real value.
>=20
> 	Andrew

Yes, good point.  This comment will be updated for completeness or removed.

Regards,
Dave
