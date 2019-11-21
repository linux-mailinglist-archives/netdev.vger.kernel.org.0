Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F89105976
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKUSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:24:36 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:26852
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfKUSYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 13:24:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADAm0PbXs0X8dnAaWsbAI0pp9+o4Bm/GbYWOGNJ0vfbsk1zh4rCbuwWqSBhiN/SWM5y0VSBVvZ8NN8HGHUPIMx9P1tmmdYDT0OTgUYyzov0Tsp4aCMSuT16CduXpf4Y8LvU6MCASXWVkLwIPT/YKZ54s7aXZmzOuVkgH1Rf5I+K0G2oeTNLI4QzWq4fTIlyWVuJdRUBSe8G+QFUHyIeYsZ2b/WIO6+5Bv2P078DuMb9yt2d6Qb5wOdGSsi6QjejOL4ehnsCf9zpUtO9tg+YDPpSp65iTzSQ8h2n3+TR8A54xP1aH3ckaOe2i7NzqwoTFs2bGw9M19gXbdEPFkr2QOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BzgjAvSukW+6BVfkZIQaPILwrZpGEkEPchcdVfF6gA=;
 b=OVOT9NnbRtbVmqXoon66eCb0Ox0yq8oXd/lkU/kt21U5BHznzUKueR3lY/tJmMAIlopx0G9ajSr9XG1bDDOVBKsX23R1TLhafzoi4uv90XOum5PGOh2LkUfcfCHPGJABnzvHqOm1KZyCVoFHO+UwD/k46UQ22Mf3bSjwPal7DAg6byC4UKLtpbFWUqDv/7gJuccVyR4LGX5rAe3ZNa3ZSxHSZbVLzNKiCAfhRSY4M2HCdaSfc7ecmr2CESTh6dxxdXqOyIHRFtwfZfSPFD+He9XVpzKcaahJwZPyF+M2EzrQU+3n0mEMZSRlZidXY2wFTsu33C8kuKKVSG9r2H91sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BzgjAvSukW+6BVfkZIQaPILwrZpGEkEPchcdVfF6gA=;
 b=n+g0fnKxsEUkgOF1zHmdEMN2KGpTr3/XfdQKuIbAUmT81chUIynDT5t922nqQqHDK9q6ijsLzeTeGZLs7aeXqnQyj3q46SWQYPz4Lfqx7EjcmEhVTIfiZQ06mhYK9sPOi9CFpVfDW4jwe2Qeg8IO0vo49QD4g3VWBsoh8CgqCVc=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3504.eurprd04.prod.outlook.com (52.134.4.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 21 Nov 2019 18:24:33 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661%11]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:24:33 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Topic: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Index: AQHVn55B+2XHK4O/1UyEg1IaXClvUKeVxsjwgAAJXYCAAB8p8A==
Date:   Thu, 21 Nov 2019 18:24:32 +0000
Message-ID: <VI1PR0402MB28008DC653496F25FC1F7A46E04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
 <20191121162113.GL19542@lunn.ch>
In-Reply-To: <20191121162113.GL19542@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5058f33f-fd68-4b70-0ba4-08d76eb00e5f
x-ms-traffictypediagnostic: VI1PR0402MB3504:
x-microsoft-antispam-prvs: <VI1PR0402MB350487FC5936E69B04868922E04E0@VI1PR0402MB3504.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(3846002)(446003)(305945005)(66946007)(6116002)(7696005)(66446008)(6246003)(6506007)(6916009)(4326008)(86362001)(8936002)(71190400001)(14444005)(66556008)(8676002)(256004)(7736002)(74316002)(26005)(71200400001)(76176011)(33656002)(66476007)(229853002)(11346002)(81166006)(14454004)(508600001)(44832011)(186003)(9686003)(64756008)(76116006)(52536014)(81156014)(316002)(25786009)(4744005)(54906003)(2906002)(6436002)(55016002)(5660300002)(66066001)(99286004)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3504;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pgncCyG6RiVzrL+AQ9n3NuY9eEyiWLHfV8VsczFXAVswKRYxD+VQ0Zzg+WoaIgvfrmxM4PwEkaS85y6G1sqjvUbUviiW6zMoqi0YURC0R/IO9F2Lu+OGYBlsKVRe9e+hpas0JAo2Bx1FY4QmcIbi0Zn6EUHcqxTcTuzsNIc/nmak5nLyo3Zpt0FQQFej0TI72bWSFR1PekLQoVFRGQoqlcpaVRzock1CbKnzfv3Qa1UsEIaitKAq4o0jN2G673yle6E1rF6mgPwBonAtSud23HU6RS4OZ1nbGEyi5lXAhmCBFKD7N5rUmWAWw0ede0zNkimFgFqUjJsXkpw7bXnQWTICZgNc5z2+wF21jAlE4uHuFPzFGxFbAwAZ52zyRaob4IBrdkVxAfp2PXgYFEE98LRTX1N6OOS5J8N/swGss4c3NmM92cw9G/6584K/plKd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5058f33f-fd68-4b70-0ba4-08d76eb00e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:24:32.7715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jOMUT95OUtNqVIZAPDSU3v4tz0gdJZMbNiAMhqSLJWcyZ1gjBam+zxroE1/B3Nz5h/UdmDIgFZv1wF5doc/5mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v2] net: sfp: soft status and control suppor=
t
>=20
> On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > > Subject: [PATCH net-next v2] net: sfp: soft status and control
> > > support
> > >
> > > Add support for the soft status and control register, which allows
> > > TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
> > > make use of this when the board does not support GPIOs for these
> signals.
> >
> > Hi Russell,
> >
> > With this addition, shouldn't the following print be removed?
> >
> > [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will always=
 be
> emitting.
>=20
> Hi Ioana
>=20
> Does the SFP you are using actually support soft status?
>=20
>      Andrew

Yes, it does. I am testing with a FINISAR FTLX8571D3BCL and checked its dat=
asheet
besides verifying that the laser is actually disabled.

Ioana
