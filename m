Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758BF1293E1
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:58:00 -0500
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:65092
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbfLWJ6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 04:58:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI1l4ImspjQYZ5llo5nCjNSa5s/VuvcYxcNEHLcb6E0LqfOdOip4aDT75aSoHRD/FHZusVgIU6ONPIiHa37+BBzXWWVyapO/1vCzviKYGLGVfjNpPxW0BWtRs870P2KTZGU3jMD633v4xSsaTQuIM7U4hrH6/tA7F7DJPa6GG+WK/sxFUB+D9ke2yWeFqNfVb72tA/OBDLDFS4aVb+LexWMQ9rZXzFsF4hwmET+gVysUDrPsBCCiAaaqp0M9NuHwzj2/xQyz/9RRbVW7Slkub9bR0RSEV2sEfbo9ccr902ukjmhag68bgQseo3gW7C+4+RL2PoYWn8Ny9YOZyCqjeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1Rs2H63nhV9VbxfL3M690n6tmuUtO7OqCM9b0yKuTQ=;
 b=Z9wOSwyTA8DCtP3e0PdHkSVC8Ip/BSmofvxs4HPuR3JsOZBFtWVCuLnJi3nS98KF0q97xr5MbiFEWK21y9xw5zKQCi/ggCFdRyyeBkX6T+9AOB6THz4cbDbaKUN5IN+VG158hPUV0mwB1PjC5krTh0Lt3aPEKQpZp90vGnipmDGi8PPCzgOw0ocYyAt2JG9g4xVfNx0U1we6iVgFER3ljTDFGVcUXX073hfKjWyFhdJmoS+cr+1Cqmor5y3kyyH/yD1I74TYdFACCyCDQxg8PpFrvYtNRnRagS/xLnRFM7v7GKycxaPUqLjmkSQ7WF5M62DCYqHq8GWUcpaPLSzR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1Rs2H63nhV9VbxfL3M690n6tmuUtO7OqCM9b0yKuTQ=;
 b=dV4ymOHmtMeY291E2gDUKL52pfQ4psqZ/+ZtGe+rAEtr8aBKdNWyGw8hpX6GN2Vq38/gNna+j0chGY3Rox2SJ1ArSed+aOXqmCd+jOJM0WxFb9hvYIPxKi7/+LBleM4ADf1PPjamHUpvPKVzl6PJk7+gHEFE9Ux1dNcvwCMUUoI=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5789.eurprd04.prod.outlook.com (20.178.126.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Mon, 23 Dec 2019 09:57:51 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 09:57:51 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAR9oCAAAh2AIAAKmuAgAAEEQCAAKSigIAAG14AgAADcACAAALUAIAAB5aAgASQ9QCAAApJgIAACbwg
Date:   Mon, 23 Dec 2019 09:57:51 +0000
Message-ID: <VI1PR04MB5567B6C8D56E03C96FF54D07EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
 <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220100617.GE24174@lunn.ch>
 <VI1PR04MB556727A95090FFB4F9836DA2EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223082657.GL25745@shell.armlinux.org.uk>
In-Reply-To: <20191223082657.GL25745@shell.armlinux.org.uk>
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
x-ms-office365-filtering-correlation-id: 7ff0a62a-26dc-4664-b7c4-08d7878e92fc
x-ms-traffictypediagnostic: VI1PR04MB5789:|VI1PR04MB5789:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB57897AF8194EC8A6621AA17CAD2E0@VI1PR04MB5789.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(199004)(13464003)(189003)(5660300002)(2906002)(66476007)(64756008)(66446008)(33656002)(76116006)(966005)(66556008)(66574012)(316002)(66946007)(7696005)(8936002)(7416002)(110136005)(478600001)(186003)(55016002)(81156014)(71200400001)(53546011)(52536014)(54906003)(4326008)(19627235002)(6506007)(26005)(8676002)(81166006)(86362001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5789;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tVG0ZGUK/m/ey3ch7sKYK50fnAparW4JmSxBUY+JXUSSIPZQi5/RBEIVzoRgQltBnyZ7kN5RTkgKqdv9PhU0Ud9wm+dDyljCRzVFKohKNP80G1DtBDTw8GgQTwF0AdxLNmvrd7/HwyurZE9c2A5UyxSkPJpezycZ/Hw0PFfkq/Whd+/ek8OLyLi2gMs/kIxqB7JNisUkPHy9QauU1Jz7zngs2kC/PdXpTKQ7H10mmfs6tY4Hg/KiqPe/QqHZ4vXUpQQOVZw+LW3NmLFP/5PvV5XnyXMee4zWtg7GGQMIErZYflX5nQiunWxSimvVot/49kwKkSefjdBByPRJuqaTUGD9KjVuFMKHarYfpaTWGDfzQ5agV5p4gQV83Cnc33Qs5gViePo3ekX033wlMvA3N3Jop0yCPTrhsiKt+mfM6DaPki7ySHCvFUkXs1jhsMdb9Z3UNtEBx273bXDEpCi693PX1sAWfKsPPG3XGyPMtLWmPRywtyCGh1lF8nOPyNsGpJS+pw7l6hQmUPspfgVu0qpG2ftv+FIk8Y4hrShLfjM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff0a62a-26dc-4664-b7c4-08d7878e92fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 09:57:51.3887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1JdLOwCn0HXZJjigRj5kv/VciPM+HauB8TonqS3RzScCxF/1TdWVzLD8MgjyuebVfi75WaZ5t9nbCbf0E6E/sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: devicetree-owner@vger.kernel.org <devicetree-owner@vger.kernel.org>
> On Behalf Of Russell King - ARM Linux admin
> Sent: Monday, December 23, 2019 10:27 AM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Mon, Dec 23, 2019 at 07:50:08AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Friday, December 20, 2019 12:06 PM
> > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> > > antoine.tenart@free-electrons.com; jaz@semihalf.com;
> baruch@tkos.co.il;
> > > davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
> > > hkallweit1@gmail.com; shawnguo@kernel.org; devicetree@vger.kernel.org
> > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > >
> > > On Fri, Dec 20, 2019 at 09:39:08AM +0000, Madalin Bucur (OSS) wrote:
> > > > > -----Original Message-----
> > > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > > Sent: Friday, December 20, 2019 11:29 AM
> > > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> > > antoine.tenart@free-
> > > > > electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> > > davem@davemloft.net;
> > > > > netdev@vger.kernel.org; f.fainelli@gmail.com;
> hkallweit1@gmail.com;
> > > > > shawnguo@kernel.org; devicetree@vger.kernel.org
> > > > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI,
> SFI
> > > > >
> > > > > > How does this help us when we can't simply change the existing
> > > usage?
> > > > > > We can update the DT but we can't free up the usage of "10gbase=
-
> kr".
> > > > >
> > > > > Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10=
G
> > > > > link. If we ever have a true 10gbase-kr, 802.3ap, one meter of
> copper
> > > > > and two connectors, we are going to have to add a new mode to
> > > > > represent true 10gbase-kr.
> > > > >
> > > > > 	Andrew
> > > >
> > > > Hi, actually we do have that. What would be the name of the new mod=
e
> > > > representing true 10GBase-KR that we will need to add when we
> upstream
> > > > support for that?
> > >
> > > Ah!
> > >
> > > This is going to be messy.
> > >
> > > Do you really need to differentiate? What seems to make 802.3ap
> > > different is the FEC, autoneg and link training. Does you hardware
> > > support this? Do you need to know you are supposed to be using 802.3a=
p
> > > in order to configure these features?
> >
> > Yes, it does.
> >
> > > What are we going to report to user space? 10gbase-kr, or
> > > 10gbase-kr-true? How do we handle the mess this makes with firmware
> > > based cards which correctly report
> > > ETHTOOL_LINK_MODE_10000baseKR_Full_BIT to user space?
> > >
> > > What do we currently report to user space? Is it possible for us to
> > > split DT from user space? DT says 10gbase-kr-true but to user space w=
e
> > > say ETHTOOL_LINK_MODE_10000baseKR_Full_BIT?
> > >
> > > I think in order to work through these issues, somebody probably need=
s
> > > the hardware, and the desire to see it working. So it might actually
> > > be you who makes a proposal how we sort this out, with help from
> > > Russell and I.
> > >
> > > 	Andrew
> >
> > We're overcomplicating the fix. As far as I can see only some Marvell
> boards
> > declared 10GBase-KR as PHY interface type. These either support 10GBase=
-
> KR or
> > they don't. When we learn this, we'll need to set things straight in th=
e
> device
> > trees and code. Until then it will remain as is, there is no trouble
> with that.
>=20
> No we aren't.
>=20
> You think we can just change the existing DT, switching them to use
> XFI/SFI and free up the "10gbase-kr" definition.  Yes, we can change
> the existing DT.  What we *can't* do is free up the existing definition
> for "10gbase-kr" because old device trees must continue to work with
> new kernels.  That is one of the rules we abide by with the kernel.

We do not need to "free up" the definition, if that particular device
does use 10GBase-KR then it does not need changing. Please note 10GBase-KR
is quite well established in the Ethernet nomenclature (802.3ap, 2007),
it's clear what it does so there is no need to "free it up" somewhere.

The phy-connection-type was introduced back in the day when this
connection was more aligned to the MAC-PHY MII. That resulted in
XGMII being used for all 10G interfaces when they were added.
But the clean MII separation does not align with today's HW, where
the asic/SoC to external PHY chip interface has evolved towards
high speed serial interfaces with obvious benefits. We're now seeing
the PCS, PMA blocks that are part of the PHY layer moved together with
the MAC.

I've recently seen how a certain PHY driver started using USXGMII and
rejected XGMII (please note the MII is still XGMII but it's buried
somewhere in the peer SoC) as a phy-conection-type. Some HW platforms
may use that PHY in USXGMII mode, others use it in one of the other
supported modes - XFI. Why is USXGMII a valid phy-connection-type
but XFI is not? Is it correct that I describe that HW as using
10GBase-KR instead of XFI, something that has a clearly different
meaning for anyone familiar with IEEE 802.3ap just because there was
a typo in a patch, be it a device tree one? I'm puzzled.

> Now, looking at the Armada 8040 data, it only mentions XFI.  It's
> described as "10GBASE-R (10GbE on single SERDES, including XFI)"
> and goes on to say that it is compliant with "IEEE 802.3 standard".
> However, there is no mention of a CDR, except for XAUI/XSGS mode,
> not for 10GBASE-R/XFI mode.

Is "10GBASE-R" in wide use? Although you can extract that from the
Ethernet nomenclature to mean 10G with 64B/66B encoding, I did not
see it used much by vendors. I do see more of the XFI, SFI terminology
in use.
=20
> So, it really isn't clear whether Marvell uses "XFI" to refer to a
> port with a CDR or not.
>=20
> Marvell's original MVPP2.2 and comphy drivers did used to distinguish
> between XFI and SFI, but there was absolutely no difference in the
> way the hardware was programmed.
>=20
> Then there's the matter that (I believe with some firmware) it can
> also support 10GBASE-KR (with clause 73 AN) after all.

Then there's not a real need to change that device tree, it's correct.
The HW can be used in 10GBASE-KR with appropriate SW so the HW description
is fine.
=20
> So, we can't just replace the existing usage in DT with "SFI" just
> because it's connected to a SFP cage, or "XFI" if it's connected
> to a PHY which also mentiones "XFI" in its datasheet. We can't tell
> whether the hardware _actually_ supports 1EEE 10GBASE-R, XFI or SFI.

We don't need to replace it. But if a certain HW is certain to use XFI
(or SFI), we just need to describe it as such in the device tree.

> Given that XFI and SFI are not actually documented (afaics) this is
> really not that surprising - and I would not be surprised if these
> three terms were used interchangably by some device manufacturers
> as a result.

XFI (and SFI?) are the result of MSA, multi-source agreements so they
must be documented somewhere (see http://www.xfpmsa.org/). Whether that
document is available for free or behind a paywall/membership it's
another discussion.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s
> up
> According to speedtest.net: 11.9Mbps down 500kbps up
OT: FTTB 1Gbps link, my phone reports 279Mbps down, 169Mbps up, limited by =
WiFi
Internet provider services vary wildly across the globe

Best regards,
Madalin
