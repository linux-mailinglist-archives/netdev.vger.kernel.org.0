Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4A72002DD
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgFSHnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:45 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:62095
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730797AbgFSHno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deQNmT8r6iJ6s6KKSBNmBSU/SsXCO7pF9RiaLvzuV4W4E1bu8X+hu8LK1JM1KD5Z4NU8s9sXOwdv1pMm6pGAoTK0hgHHz9JTDHhBTnsaxvxXYO54fwRYs/y4SVs8s3Ze52JTdCYhhwPSviWlpqEjt5e8fGCTI5bQsVqpAg7VkNbT6X3N82cnQoEmPTw/BPmj7f/urfDqPGSYYD2qvM8odkMJu7KjF9aXOUoW6deGPMDQpf74wvBtyV7cdUy3ur3LA0aTvuy80gHL7jiDfxLpxzqUuL4rnazmwZl1fbw8+M5bg20otrEXh/obPgmwScGfApKkeGfQOfrt050sQSkl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo+uz+nBYlWzioibLaek//QW9d6WKvTL7Sv9YoNuEK4=;
 b=eVmcH5R6axATBTJESD9oqIfmqt4a1PxQbP1WRBHMTghvPzDTr31d9+b2T3VfqNnbPhNmEwmXL0z7tvTay8wUqhVJGvT9OKCuCA0kyddN9IDM47QWi+wrjpMASZi+AM22K6V75f1qZNS5GiGP6OEZBsHs6plTtenP+7CNd67JH6kRheZlUNQBzjaRBToUXiEIkra5i+CKgsucmE113T18bS8AzXYhNr148PSbOtGJ0TMNtRS4ndrAZ3wC82agWtLkM90Dio7hPH9gh3eeWFaB/UUrWCbLFws6EbqJf1+K8u92HGg41iMZMjNzPwKjNr9KpTpntDca6RQU1XuE65YZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo+uz+nBYlWzioibLaek//QW9d6WKvTL7Sv9YoNuEK4=;
 b=nwueO6Upa433c5ewo0KWYb/ZrQWVrRdnbx/U8cQ8KcBQuEGOwLfJjewKy111rPx/oLAWyHweVF762HHa6t3D9uD3ec4pVLFuUnfH9MqKnrVISu3iNCzdLiHdw49tjwSfIiPzsKhXxpSw2Je8urv7nocuCMimCgKbR55apLJKvG4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3437.eurprd04.prod.outlook.com
 (2603:10a6:803:7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.25; Fri, 19 Jun
 2020 07:43:39 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 07:43:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 5/5] net: dsa: felix: use the Lynx PCS helpers
Thread-Topic: [PATCH net-next 5/5] net: dsa: felix: use the Lynx PCS helpers
Thread-Index: AQHWRWlF3IkTiwo9yUq6QWAmsypP6KjehREAgAEKhWA=
Date:   Fri, 19 Jun 2020 07:43:39 +0000
Message-ID: <VI1PR0402MB387109B8E7D743A818D6AE3AE0980@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
        <20200618120837.27089-6-ioana.ciornei@nxp.com>
 <20200618084844.1540e6d2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618084844.1540e6d2@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7a5f4a6-fc64-4248-7928-08d814247baf
x-ms-traffictypediagnostic: VI1PR0402MB3437:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3437F224DD70DA0F34AF0689E0980@VI1PR0402MB3437.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l37B2il6HVtZQ8Jf7LJL3p+4eBAbD3UILqxYfIZlDx1pDxwMhGAkiFOcpDUij6+DUbCF0EXhvUkOAO897orM1qRTtVXlDa0C2KnRm+URsTAXqfg2Muh2ZLJADDAVXxbc/vfh/hus5yieUQNIinvpBFfAN6Gz/N9Gh2kHMTyK9nJDgkgRI+ARiivWiS3YS+du47Sz2L/VE+DeSZjA1NifIAOb/sbg87G6oJc7VWw+odpy4OZ6uoY2RLYMQueoabhFWDSlVTbYR7aK0aF7L2GNBi1aXbBqdL3jrBsgc6etl0+LTJBBpW6EcFN6shesb7US
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(33656002)(6506007)(86362001)(5660300002)(52536014)(4326008)(71200400001)(66446008)(66946007)(76116006)(2906002)(7696005)(6916009)(66476007)(66556008)(44832011)(64756008)(26005)(316002)(55016002)(54906003)(8676002)(9686003)(8936002)(478600001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rFzZFk3ObpJiMVl2LsxkdAqlBL6Yfr4aWlEMgpIKQJLJXn1/+8bt+IBS038M2R3KHxK+UKf5ymGLeikB+jiR6nCmftVZLouFhLS76Ogu4hdtRdF1Y+mGRJLKIFDkr16xwEpX8utdmWONtpbRx8oIuXiJ1OUXEfAHzeM3w3EKe40bLOXgrnI3/3z/yFeMgqSZvK3x8+EfiFjOCWq/nAVYXYALBFn9ioiPojmCywNbPeo5xru1qLxMyI1fLXCdcGrqNx64I5xg/O6QoQP8yD4eFggXzkO8fJQgNAHqsBpe+UWInYEl2vOpGWK83dF2UEmqb5yfZoVYlhwNUfJwSYGhF+iCSYDtQq4hyOlSWuFLUWWP08GbdrcOz7vEfjWUZOraOheljSMcrJxyl7S0u2HXl8dL0SNcFAP6LHd9rzW7gR0FvPgK1dZJ1UmuCucvw1DPbBE/+wSf1uCRNwIya0GaZGOoCsgeWftPObCNc5Mfs1I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a5f4a6-fc64-4248-7928-08d814247baf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 07:43:39.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3xsUZaJufJgugotW1sh/zvadq02S3FySNqLt+A2zqpMNaUa/ub0WxKK/WlOrMzNlsttoujixud2cEy6hjs+0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3437
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 5/5] net: dsa: felix: use the Lynx PCS helpe=
rs
>=20
> On Thu, 18 Jun 2020 15:08:37 +0300 Ioana Ciornei wrote:
> > Use the helper functions introduced by the newly added Lynx PCS MDIO
> > module.
> >
> > Instead of representing the PCS as a phy_device, a mdio_device
> > structure will be passed to the Lynx module which is now actually
> > implementing all the PCS configuration and status reporting.
> >
> > All code previously used for PCS momnitoring and runtime configuration
> > is removed and replaced will calls to the Lynx PCS operations.
> >
> > Tested on the following SERDES protocols of LS1028A: 0x7777
> > (2500Base-X), 0x85bb (QSGMII), 0x9999 (SGMII) and 0x13bb (USXGMII).
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Hm, this does not build with allmodconfig.
>=20
> drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_link_up':
> mdio-lynx-pcs.c:(.text+0x115): undefined reference to `mdiobus_modify'
> mdio-lynx-pcs.c:(.text+0x1a3): undefined reference to `mdiobus_write'
> drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_config':
> mdio-lynx-pcs.c:(.text+0x33a): undefined reference to `mdiobus_write'
> mdio-lynx-pcs.c:(.text+0x371): undefined reference to `mdiobus_modify'
> mdio-lynx-pcs.c:(.text+0x384): undefined reference to
> `phylink_mii_c22_pcs_config'
> mdio-lynx-pcs.c:(.text+0x3e4): undefined reference to `mdiobus_write'
> mdio-lynx-pcs.c:(.text+0x40d): undefined reference to `mdiobus_write'
> mdio-lynx-pcs.c:(.text+0x422): undefined reference to `mdiobus_write'
> drivers/net/phy/mdio-lynx-pcs.o: In function
> `lynx_pcs_get_state_usxgmii.isra.0':
> mdio-lynx-pcs.c:(.text+0x457): undefined reference to `mdiobus_read'
> mdio-lynx-pcs.c:(.text+0x4f1): undefined reference to `mdiobus_read'
> drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_get_state':
> mdio-lynx-pcs.c:(.text+0x650): undefined reference to
> `phylink_mii_c22_pcs_get_state'
> mdio-lynx-pcs.c:(.text+0x6fb): undefined reference to `phy_duplex_to_str'
> mdio-lynx-pcs.c:(.text+0x711): undefined reference to `phy_speed_to_str'
> mdio-lynx-pcs.c:(.text+0x7c0): undefined reference to `mdiobus_read'
> mdio-lynx-pcs.c:(.text+0x7d4): undefined reference to `mdiobus_read'
> drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_an_restart':
> mdio-lynx-pcs.c:(.text+0x954): undefined reference to `mdiobus_write'
> mdio-lynx-pcs.c:(.text+0x978): undefined reference to
> `phylink_mii_c22_pcs_an_restart'
> make[1]: *** [vmlinux] Error 1
> make: *** [__sub-make] Error 2

Hmm, it seems that making the Kconfig just bool instead of tristate is the =
problem.

Thank,
Ioana
