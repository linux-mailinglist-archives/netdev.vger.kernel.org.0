Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B962519596E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgC0PAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:00:33 -0400
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:30198
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727287AbgC0PAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 11:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l18I+/d526Jl8+CeBjlADLzo5DG/FkZpi1jnfEcktUB1e+eOE+3kaDf/x3xqy65gyi4PM2ynsUrzv56jPgt0X3rjs/QUzQ0NplQI7dBCgf0YfkHkcGiZThOoyHb+aVWEovktlmu1UZMAJDf9dakqFM9Mb0c2OHMqEMfZ7/11IKRItQ09MfzHGhjUYKXTJjHaSfiY28Bz+IPkzEzQ7IhMaROgWvDnlsYybyn53TohI1E6WpopYpwMrYiK3aSu8qCadm+g7V/zsMSuj+MS7YNYOcqBlLlcKKbStkbURcT1OoJ7rfTlJGjvxtA4a7zRbsU+WA/pXHX6m39QI/FkV1Tl+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXh7cGCMY7ukNkIKhhUygyaHobBsn+tYPkkAmPAsjNg=;
 b=doLOxtQ88/dHu6+4Q68Dpa8wxEcy24yZzeGFPQcxC3ewFnzRFBCGZydP5/znCNHQkW57JxWxNvz0WCgTOj+Cgdx87PaM57SrflacKhG0W9hAbTxBmN2t7Itw2kJTupQOkLeDxbNupGuvG4g0AARRraS3LCgTE+L0uKXx1GJNZF/DbkF8cRijABirCOfOhFVcnB0M4ig0JIoenIzsub8wyEK7+nQOU6Y64rK5CMTfjR33RzQpiaLAXtxLJBBLfVDroLBk/0gnu3xahvy5xQZDUhTu3pT0BAK9nHu1BkdayT2GY5Ny1MQqEBGqgmKZw333LwIvePUxY6HMFea1FT4Sdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXh7cGCMY7ukNkIKhhUygyaHobBsn+tYPkkAmPAsjNg=;
 b=Aur+39AvTHabyOfWlEmStAxoREakYrSbBZXIN/FZrL45XPLwN3ycHhjFgdcz7sjbLnvPW2bn25kpmydQ7y/vBDLCDNOgHAftrbJDPvbI/PR3YJzVFIPQX+b6nNy+mew1LLv8Ql9n3Fj6GyedbKAI0lRQc3KNzZ8Jce2qSRd/DUo=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB4659.eurprd04.prod.outlook.com (52.135.144.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Fri, 27 Mar 2020 15:00:22 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 15:00:22 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt
 bindings
Thread-Topic: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane
 dt bindings
Thread-Index: AQHWA3W21iOEOBCSMUyOOEOFmYZ41KhboFSAgADoIOA=
Date:   Fri, 27 Mar 2020 15:00:22 +0000
Message-ID: <AM0PR04MB5443185A1236F621B9EC9873FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
 <20200327010411.GM3819@lunn.ch>
In-Reply-To: <20200327010411.GM3819@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 424e84a1-f41b-4355-b20d-08d7d25f92d2
x-ms-traffictypediagnostic: AM0PR04MB4659:|AM0PR04MB4659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB465932103C8CC2FA64F03972FBCC0@AM0PR04MB4659.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(316002)(7416002)(71200400001)(478600001)(7696005)(6916009)(54906003)(33656002)(5660300002)(76116006)(186003)(8676002)(6506007)(64756008)(55016002)(66446008)(52536014)(66476007)(81156014)(9686003)(44832011)(2906002)(66556008)(8936002)(81166006)(4326008)(86362001)(66946007)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7ndZRJdXiygoLz5Tjs2VcoegMSM4A0sYtsha5bOHDeHrY5BhqyAwbmthjEH3Prn/hehTi408s71DMSlZYU1yLzO+CV5XTBjy5TTPMKKqSOb8eQK2bVzk96I968SOEXPgaiRywLcXqmeT3XEynRCuHKQD3Pi9M1cIRp9ANJMcPVVVqpFaaHamWyd9klJycqtL9rxHyn+gZQI41oaypLMggJR6+wuSBpvYnY3IwABiiO02WQdYC/ekoyA58WZiygEBcF1lQuxH2qjuTa5REOqRvoboXiYg3MUT0+HQXaffwYYOv+XuN96yAI8aJS0/94+fLL01+x3tyN6y95hFYunQWgXk2joWOWCL99+eELRu5AxKR1wkneSWpgNnltrod3+o1VeUfRUaX8TGTv6J3y0Aidfeg5B61+kfC7BliQvJc8aoo5EIVrAC4BCc84MxQp/
x-ms-exchange-antispam-messagedata: aeF1NAw18xOH8xS/lrxdfmc5Cuyr29+L0JecrLYTvjBlDpWpt1qgCJWnNogmbZfaaz/9N6r9hQ4an66UXcfMtaDoyK7DdzhFwSZNCer4J4NThrmAZcckwHb/OUsokTIIjgb67n5B2INOiva570NXKQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424e84a1-f41b-4355-b20d-08d7d25f92d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 15:00:22.1883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7MvblYJz0PnCSBPaMzZ4IJkZyXuI41UAr0nZOpA5ZJvMhVSbn+IPGyQ6e1QR/9g8OkTKy2qjrJpYyxhXqLy+MnQM8mrQA8EihYDo2m+Sag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Mar 26, 2020 at 03:51:15PM +0200, Florinel Iordache wrote:
> > Add ethernet backplane device tree bindings
>=20
> > +  - |
> > +    /* Backplane configurations for specific setup */
> > +    &mdio9 {
> > +        bpphy6: ethernet-phy@0 {
> > +            compatible =3D "ethernet-phy-ieee802.3-c45";
> > +            reg =3D <0x0>;
> > +            lane-handle =3D <&lane_d>; /* use lane D */
> > +            eq-algorithm =3D "bee";
> > +            /* 10G Short cables setup: up to 30 cm cable */
> > +            eq-init =3D <0x2 0x5 0x29>;
> > +            eq-params =3D <0>;
> > +        };
> > +    };
>=20
> So you are modelling this as just another PHY? Does the driver get loaded=
 based
> on the PHY ID in registers 2 and 3? Does the standard define these IDs or=
 are
> they vendor specific?
>=20
> Thanks
>         Andrew

Hi Andrew,
Thank you all for the feedback.
I am currently working to address the entire feedback received=20
so far for this new Backplane driver.

Yes, we are modelling backplane driver as a phy driver.
The driver is loaded based on PHY ID in registers 2 and 3 which=20
are specified by the standard but it is a vendor specific value:=20
32-Bit identifier composed of the 3rd through 24th bits of the=20
Organizationally Unique Identifier (OUI) assigned to the device=20
manufacturer by the IEEE, plus a six-bit model number, plus a=20
four-bit revision number.
This is done in the device specific code and not in backplane=20
generic driver.
You can check support for QorIQ devices where qoriq_backplane_driver=20
is registered as a phy_driver:
=20
@file: qoriq_backplane.c
+static struct phy_driver qoriq_backplane_driver[] =3D {
+	{
+	.phy_id		=3D PCS_PHY_DEVICE_ID,
+	.name		=3D QORIQ_BACKPLANE_DRIVER_NAME,
+	.phy_id_mask	=3D PCS_PHY_DEVICE_ID_MASK,
+	.features       =3D BACKPLANE_FEATURES,
+	.probe          =3D qoriq_backplane_probe,
+	.remove         =3D backplane_remove,
+	.config_init    =3D qoriq_backplane_config_init,
+	.aneg_done      =3D backplane_aneg_done,

Here we register the particular phy device ID/mask and driver name=20
specific for qoriq devices.=20
Also we can use generic routines provided by generic backplane driver=20
if they are suitable for particular qoriq device or otherwise we can use=20
more specialized specific routines like: qoriq_backplane_config_init
