Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2856129285
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfLWHuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:50:16 -0500
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:62373
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfLWHuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 02:50:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wiwzj75EeLKxFkJwk3YMTaTVVgkFTYbaA3wwSMFQz4KeJCK4onRGCutbPJHnZCXpxrS8Yg4rxiRWQIIoXUHdtaetgQCLfVZYkysADap/ZFCNA0a5fSs/LhLpVQ1euTaev9uHbrsFKwmqaZ0mFJH8S+GAQSND++ht5uLYu3K+7HjhVVLNG07gsltGM5zaXk34kuU6EvcYQyxVnpMTiMcVp/j1m2AiDElyDh1ggcHASrPhnkDjvbJhAoAN8MBOCN7n915V3ctw0DWmZnaVJNi4m95iAgbo5xC49rOMddAybTxzWb80GpzZb1ZAvN3vFV5OsScZovOgiIj5D//dukpxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmIoqhEZgdz7pAnorhCOvuOIFn7T8c/QJpZE6zjoVmg=;
 b=YoX4barpghfgVQd8BDSU2/r3hKy1+Ch3wthS0mE+xsQQLl/8uOh5gBWFflE3LRhOI896fjLbcsKqdVFH+MNR5JjrDHNdxJO0iko9jDch+cY+JqY9SQ5fqvNcAQAp5EwT+CStSjMbxK98OD5EAUZx2Cj3Nsp/kWX84JGQJeLzthPQvEKOjSTknkzr2yfudpBavLBaGt1OjB/ZKE6Wo8wZiBYH/l6gdbMVo+6fO1u7Wvfg0PV8KbJ4XTrblYXZu2xzXwqcTnD8OwLzo8V2U6JMF1y++k8J+4YF0ELwisDLmn98PzxlFAnFXVD+AauFJwKDMtR+g/lt9BY1xJ10Lbzafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmIoqhEZgdz7pAnorhCOvuOIFn7T8c/QJpZE6zjoVmg=;
 b=UWa1a3zMRQzYBd0ZtlbbipN9V31eVAdlRumuGuxt+U0SL02JYbw2SE+Y6Af62DJ6njWF3xRPYwvMkhWyhWMvXh1shcqdpr01bqOOZzqw7d13ppXOMPFL5M0kBfEATfqFjHSlzWpqWDNg1kVTp2ZnRH7PocZDyPYE+ZkGs+1seuE=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB6975.eurprd04.prod.outlook.com (52.133.246.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.17; Mon, 23 Dec 2019 07:50:08 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 07:50:08 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAR9oCAAAh2AIAAKmuAgAAEEQCAAKSigIAAG14AgAADcACAAALUAIAAB5aAgASPfwA=
Date:   Mon, 23 Dec 2019 07:50:08 +0000
Message-ID: <VI1PR04MB556727A95090FFB4F9836DA2EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
 <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220100617.GE24174@lunn.ch>
In-Reply-To: <20191220100617.GE24174@lunn.ch>
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
x-ms-office365-filtering-correlation-id: b3287390-ac8e-4296-31e3-08d7877cbb71
x-ms-traffictypediagnostic: VI1PR04MB6975:|VI1PR04MB6975:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB69756D801F14D7DE7ED832C1AD2E0@VI1PR04MB6975.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(13464003)(189003)(199004)(53546011)(186003)(54906003)(6506007)(110136005)(478600001)(7416002)(33656002)(55016002)(9686003)(5660300002)(8936002)(2906002)(26005)(8676002)(52536014)(64756008)(19627235002)(81166006)(81156014)(76116006)(66946007)(7696005)(86362001)(66446008)(66556008)(316002)(71200400001)(4326008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6975;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9+/th3r/zgi7zXrug7reXD9kCtHWGyY9qwHXIixLCu7zereocMDnve3tDeAYbCzrp+dCoCJiv2sjCjkMfMAe93N5NAxCg37cOSJsZCPDepSBbSObN/Av5LBVnWhWSq/haT3jiPyAsj7HlJAIJdmjDlAAlPZouwNLfUmHIojZ7OlTkfwjKvb5KssLLAnU3z7tpXz+dIwP44xWCjsYANWkGJwVYJDB7838kg9KpgNSpMlMuHO3DW/nHc+W5gZ6tzUgWRuI3V720ijznsOxKaU6MPPSizhKj6oUvUYKjHOrf0CS2Z8l8m8LMiQzAO3V91a3aU0tk+ZjCWMvLAdRYVsbWO52ZmNrwLEKeoyV+IWpvPhk+FOD+I46tqvBs/LOigIorhZcQNw3Cnemi0qcu5pX4/qkR5D0vfzUSHDkFfoNp0oUJKvsIW/QVAUXTxYRlLRw7wWSiX/jkDILX1Lo5z8WrXjQ8z/jl0iFhiymCYGdhJjs+KLckKGzTs5nnqT3uas/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3287390-ac8e-4296-31e3-08d7877cbb71
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 07:50:08.3578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WDJmp+lE8l2loKqFlcboDqgmF+LJbKDW8y6sD6c02suv+h9sRMghbEkWKlK+1zztAdz+RgmQQLpcUzngV1Nl0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6975
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, December 20, 2019 12:06 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> antoine.tenart@free-electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
> hkallweit1@gmail.com; shawnguo@kernel.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Fri, Dec 20, 2019 at 09:39:08AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Friday, December 20, 2019 11:29 AM
> > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> antoine.tenart@free-
> > > electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> davem@davemloft.net;
> > > netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > > shawnguo@kernel.org; devicetree@vger.kernel.org
> > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > >
> > > > How does this help us when we can't simply change the existing
> usage?
> > > > We can update the DT but we can't free up the usage of "10gbase-kr"=
.
> > >
> > > Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
> > > link. If we ever have a true 10gbase-kr, 802.3ap, one meter of copper
> > > and two connectors, we are going to have to add a new mode to
> > > represent true 10gbase-kr.
> > >
> > > 	Andrew
> >
> > Hi, actually we do have that. What would be the name of the new mode
> > representing true 10GBase-KR that we will need to add when we upstream
> > support for that?
>=20
> Ah!
>=20
> This is going to be messy.
>=20
> Do you really need to differentiate? What seems to make 802.3ap
> different is the FEC, autoneg and link training. Does you hardware
> support this? Do you need to know you are supposed to be using 802.3ap
> in order to configure these features?

Yes, it does.

> What are we going to report to user space? 10gbase-kr, or
> 10gbase-kr-true? How do we handle the mess this makes with firmware
> based cards which correctly report
> ETHTOOL_LINK_MODE_10000baseKR_Full_BIT to user space?
>=20
> What do we currently report to user space? Is it possible for us to
> split DT from user space? DT says 10gbase-kr-true but to user space we
> say ETHTOOL_LINK_MODE_10000baseKR_Full_BIT?
>=20
> I think in order to work through these issues, somebody probably needs
> the hardware, and the desire to see it working. So it might actually
> be you who makes a proposal how we sort this out, with help from
> Russell and I.
>=20
> 	Andrew

We're overcomplicating the fix. As far as I can see only some Marvell board=
s
declared 10GBase-KR as PHY interface type. These either support 10GBase-KR =
or
they don't. When we learn this, we'll need to set things straight in the de=
vice
trees and code. Until then it will remain as is, there is no trouble with t=
hat.
I'll reorder and resend the patches that introduce the XFI and SFI types.

Regards,
Madalin
