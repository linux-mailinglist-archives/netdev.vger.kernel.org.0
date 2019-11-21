Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EA410495E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUD3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:29:39 -0500
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:58241
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfKUD3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 22:29:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HH/R8YEOBoGCQ3JaV4Bykv7/h0L/TvaRpPKdghTE5T1I668yuGbfTA90gUQYeoBpPnVIZPh1ODkL0lnSBo2UistDkTZtYxijMHK9UgLvIeSoMO3dANqxAxdy0w7gJ3xzrP1cYZEw+RZ787rbsCYedLI+oMeVtE8bYBaX180uagyoCf5RNR2Vqft5giwFoAT+8ePToe/8RTbxQ60Wt8X4qruoiV2lFdAOVNhNkTA7XNUcgJ13kJ6n8lD3RMOa+vwPw75wOp61W4QTTFCDJ9LbHlkv6TTSYhdR7B3JHG1wtLCl2avSPYSmpIwBg+lW0xI3f+z6ooaePSTYNSDMDgArmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryZAfIonAG6T97iHOWM41DdVxdvKPnc6wUTLBTzFwVE=;
 b=PooEEITcFLxA6YmlJPmaOu8EyFSeQUd3KbwiESrpdjW72tb1f7ItlRrGSdc0we336m/8wi/qqqNlE9UtFWBdyXT6EmkPi2jUg2Pln4S5UnTiQSs/yXPOeYoiBN1boFYE0z2D8xALU7RWWsdg3ogGRdKnE9tUPxayB0G5Ha3phv4Ata6Jt/DGhJZDAEZ02koaWRlvllD5P7tXfahtlwWyBvDrs2KU1N6Zrsvnm2ndFEPLtEJ1f+muTn2JOnnhOyC1oatpp0w9Ds9J8VoOWZ53SmKop+zXeuPbM7lw/XgG2JFymUkGhD28ExpoHS632tWfLiIFyuL/xBmjorCUmDfWpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryZAfIonAG6T97iHOWM41DdVxdvKPnc6wUTLBTzFwVE=;
 b=UppHdviV5y0QSrkXjjrib+YKEH6apAYxSZFXn545gpnJ6xBDr5IDFEYZZNNioCemlh1QbZwSp0PtdDVIhcAlgTjYCY2e0J6RpT0e4UOYrUhFyboeiaoXx8VcRaZ3jJtZ1ZJ06lHAZwkjH7I3hgeBEpQ7bGJvYKfj0tBqAxkkojE=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2607.eurprd04.prod.outlook.com (10.168.66.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Thu, 21 Nov 2019 03:29:36 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2d81:2d60:747c:d0ad]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2d81:2d60:747c:d0ad%3]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 03:29:35 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH 5/5] net: dsa: ocelot: add hardware timestamping support
 for Felix
Thread-Topic: [PATCH 5/5] net: dsa: ocelot: add hardware timestamping support
 for Felix
Thread-Index: AQHVn3vT5anZ2SIeYkGi0HvtelcSgKeU73wAgAAHq9A=
Date:   Thu, 21 Nov 2019 03:29:35 +0000
Message-ID: <VI1PR0401MB2237DBAA2897CBDADC34A80AF84E0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-6-yangbo.lu@nxp.com> <20191121025610.GO18325@lunn.ch>
In-Reply-To: <20191121025610.GO18325@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 241afee3-afa0-425c-2f6e-08d76e33086c
x-ms-traffictypediagnostic: VI1PR0401MB2607:|VI1PR0401MB2607:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2607FB80E0E27E82F23BC55BF84E0@VI1PR0401MB2607.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(13464003)(199004)(189003)(7696005)(186003)(52536014)(33656002)(55016002)(229853002)(74316002)(86362001)(9686003)(486006)(14454004)(5660300002)(2906002)(7736002)(6916009)(76176011)(6436002)(305945005)(71200400001)(26005)(8936002)(76116006)(316002)(99286004)(71190400001)(102836004)(478600001)(256004)(6246003)(8676002)(54906003)(6506007)(11346002)(64756008)(66556008)(81156014)(476003)(66476007)(446003)(3846002)(66446008)(4326008)(66946007)(6116002)(81166006)(66066001)(25786009)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2607;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0JIW+Yji3rB8+7Hxl3i0Fcwpa03zh0lHpt/hNTkf4fX5DL2h+QBDc5zo09koCv6gWPY7wYhbmM3diaM/ExhYaLkQYtm0LhrBZ0dB+waY9Lscr/J2REfCX4QmFjvbvQ5Uz+ouKB8MT5wp/wCsspQwv9W7U1s+3uXm57ZhVdProfMhP1h+TbisfRINnQbZ724FlbUWxzramXQKkXkw3kMVO89fGAmkJZ4St93gHhALa6Mj7kkE5OPR29ylFbhILrc4btsjGl1jXZ77GZiU79HaovErwjL20zrk2KE9G59ZFYB4ywkjJss/eGuagu2ABGsdwrnKUd9cPF2UzjCTBQiRSpGNc4avG7IdZRDSglyACppGAJyOHt89SIFguLdoj4x9vVX2833xCRyzZUXZxBQGsvaTjx1Heoblcaf4RV2kD6d3Y3p7r27lc1LXL3mQ9ix1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241afee3-afa0-425c-2f6e-08d76e33086c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 03:29:35.8760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: keyRKLoGBNroZsDLGa1aXQQrZy6ZGTyK5iGxMlF/mG0BUq5M0iXFJ/orxtkOCYVYaMcnTRl2CGC1qQssBdxBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2607
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andrew Lunn
> Sent: Thursday, November 21, 2019 10:56 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; Microchip Linux Driver Support
> <UNGLinuxDriver@microchip.com>; David S . Miller <davem@davemloft.net>;
> Vladimir Oltean <vladimir.oltean@nxp.com>; Claudiu Manoil
> <claudiu.manoil@nxp.com>; Vivien Didelot <vivien.didelot@gmail.com>;
> Florian Fainelli <f.fainelli@gmail.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH 5/5] net: dsa: ocelot: add hardware timestamping supp=
ort
> for Felix
>=20
> > +static irqreturn_t felix_irq_handler(int irq, void *data) {
> > +	struct ocelot *ocelot =3D (struct ocelot *)data;
> > +
> > +	/* The INTB interrupt is used for both PTP TX timestamp interrupt
> > +	 * and preemption status change interrupt on each port.
> > +	 *
> > +	 * - Get txtstamp if have
> > +	 * - TODO: handle preemption. Without handling it, driver may get
> > +	 *   interrupt storm.
> > +	 */
>=20
> I assume there are no register bits to enable/disable these two interrupt
> sources?
>=20
> What is preemption?

[Y.b. Lu] For PTP timestamp interrupt, there are not register bits to enabl=
e/disable interrupt source, and to clean interrupt status.
That's why use threaded handler with oneshot flag.
For preemption, it is a feature of TSN Qbu. I'm not familiar with it. The f=
unction hasn't been supported/enabled in driver.
It seems it has status bit to check, but has no bits to enable/disable inte=
rrupt source either.

Thanks.
>=20
>      Andrew
