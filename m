Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662AB45FE28
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 11:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349716AbhK0KmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 05:42:11 -0500
Received: from mail-eopbgr50134.outbound.protection.outlook.com ([40.107.5.134]:16705
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354266AbhK0KkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 05:40:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSo/w/I4PgtroxvR35C53UAQk4gwdgB6ivQx7vjv2rv/1T/m+LCv58mdSy+FWvCXULQ/3aqyklU4+a82Ia0kWl1TTyHsI7yenPCgBjhT0YvgwyOpqSe4728/+iGbaw38moDsW+VHf3QCXwqd4gNMZpxQJBPs+DC10KDKYFYh1JV7AAFXfkxygxcenE0p3YFcp74n5CmSARezkP4J3iYXT/ADnlxhy9a3WKnBlhtuQJ8l/gEwbL+XkovY6Am1H5rq8H0CtcVvKiQWQ9O5p3qzE1AuEktmKVQ0cjftz2fADaMKcvTiPJRMUn5sBTTT9njXAlrReymx7AnkXZrz1WuB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+u2HYU+eYEX6RW/sEMxBy1/goxyMP/nuMx4coQ2R9s4=;
 b=Rn0Qzq7HISuaCCZyeQHxd/Nq6wKVqw3pkR9tm5ODj1HzEjBhEgP6gZL20Sq8b8zp4d/oAyuhfE+U6ixo11mcLN31+71cOHdkdM5XFLXYBIilnys2p+5mPwt9n3ZfLEMrtxHH3SqlMLIqYVXEo+ru5q1TImUiy9WhyBwGIeFQViutd05TjgyEZuqS04ogjfA5bY/os+5QQuXwToZQ7+3a3TInCvPg+praH6LVWpfm5ec987Augfw5B0DaskV2vGIBnaZMIF7oAe+fHYAsnLioyWv+TQPHqGs2P69S5bIQV6I9njpVVOfsz0MOusy6rewbO4jMzyFyTlAkK1++X2xJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+u2HYU+eYEX6RW/sEMxBy1/goxyMP/nuMx4coQ2R9s4=;
 b=L5OYprAkcjeZ4IDvlcrXOUVofjlEb1/A5uRz0r/wMYBqOhqmk4lYKFKtMEskAB2ojcQFcJob1tckR3vkMe5EayMWRsNXmWLthIXXDrMTAVs2lyaR34vdV5oAAXHDp4K7+ZS2dAS3ExoZrd87pJZygZhrYxmDEf0XlzCxi8MyoBY=
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:103::8)
 by PR3P190MB0923.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:91::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 10:36:54 +0000
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::ac46:910d:6989:a309]) by PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::ac46:910d:6989:a309%4]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 10:36:54 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL
 instead of "0" if no IRQ is available
Thread-Topic: [PATCH] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL
 instead of "0" if no IRQ is available
Thread-Index: AQHX4tk+edkqRJbdE0CwrXboJp/yRKwV9wcAgAA8pICAAPu9IA==
Date:   Sat, 27 Nov 2021 10:36:53 +0000
Message-ID: <PA4P190MB1390D5F29BEAF13BC3B25097D9649@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
References: <20211126152040.29058-1-schuchmann@schleissheimer.de>
        <YaED/p7O0iYQF6bW@lunn.ch>
 <20211126113440.5463ff74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126113440.5463ff74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=schleissheimer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75df2ba-c76d-49eb-1d8f-08d9b191d466
x-ms-traffictypediagnostic: PR3P190MB0923:
x-microsoft-antispam-prvs: <PR3P190MB0923402B603C0EA3B9EC7767D9649@PR3P190MB0923.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A+g/r6KQPY8bPZaUksNg3v/Q6HWwCGES39/HhoPvNdZKtkHv5OqZSGqJ7oudTQM+7QXPEj2rL4/dHH81y4ivlBFC0lKtijrfVTNAaBOnSCspGKJ2nQ0xkv9cW2gaNt2g+EMOcikdcGqIxEGPnFrHwdMU/9QcbSab9bc5T4xvjjAM7QG8MVW3bNSuN+CiZBP078gMjiGBdlac2/PvnD0HGY9gxdU1pMLoIW8+gSzIyOg01DspAPemEhV9WkAZzFjw8JYH7/kGL/ndrxzVH8wvGd7lI97PJY4dUKzM0zfzxtrMLkBHbqfJyd1+VcFErEZPLTbc40JNiC+zBi9EI8k3W1VtP0re8icYnUt1IfGAZP9yUccPZKGhRa0tbJpGFf+g1Rbs2bfj7ousCkLMzgP5attAJDowmOf/I5tXFrfoKzLr00pNNJRtqqfGCMTzP0iXqFBosB7b2dpQAofV8Mv/mLt4pnyT6GS5Ra5puTb3ipFSF2AZP1ivOAqplPaIMov+imAYuuYYv9f83bRYcDCtgTmsbu2Ls3HgOP9LKycoUuEfKpHANX/bZhe2X1eOwbNfK0pwtricMVgk6SHzu51Lxg9lHfvasJHjHyFMoA79lw9Y83qAuVjLqAOLAy6d+xO8osjRbNu7O4Uodn0CXMVVBLXUFR2n4krKFoI7rRWNN7B5p1KjTUB9VQzkhNBieO99cu6qc3uUdmeu19O27iAnCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4P190MB1390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39830400003)(4326008)(52536014)(8936002)(26005)(316002)(7696005)(76116006)(83380400001)(66946007)(2906002)(4744005)(38100700002)(5660300002)(33656002)(66476007)(71200400001)(38070700005)(9686003)(55016003)(86362001)(6506007)(8676002)(64756008)(54906003)(508600001)(122000001)(66446008)(66556008)(186003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CmkLcfrtuKF+SC2cA8jHLvfmnreeLNQz9NySLOYEywNmKdtexmISI8hGimNX?=
 =?us-ascii?Q?/LPTtLMUqpe0gMAsJDRFD6Xe9+o/rihawQrGCUOpR+JkFafjJy5+2HPnIfxn?=
 =?us-ascii?Q?vWuaDnbwzQEWs2LF+o7ZbB1e7po7HBuw4llal83T7RVbh2F9CToPmfb3CDC/?=
 =?us-ascii?Q?DKsF3aE0nHto6EpDh451dBglnEVONewWWQktPmL58OGlQg+R/u9ZZmuDo5Ic?=
 =?us-ascii?Q?hy/pz0V1Z6Lfmblox9fZqj+8kF5vjKjuus+fj0QlaX+IJ55m6lCNlCXJPUZo?=
 =?us-ascii?Q?0IBGaR3EtdzZVA/SZJcUvLZjmc+Xsl25X0IjsHTuBeepRWalFIzY5hlQZvAQ?=
 =?us-ascii?Q?v9S3calxSqBZuHSbfdL38tY+jGosepgR7AwcAF3wgI6qE5QOOoFY7654/cC1?=
 =?us-ascii?Q?Hc9EFpAg0xsI1+XZSuhEqf0sBzAx3ExdTq8Gu6fewUr4axXLT4A8NJfulsFC?=
 =?us-ascii?Q?hKMT3zLvCUMdAKCHmcgfSeo6g9z0yjf0Gp/skDh6BVZJheAnXD2PF73tJVGn?=
 =?us-ascii?Q?gwg3en3I6gU+qS/EM9oMNrjeUsWpZO5zWIcIkUdPmhZxJKRDHFCnkqU1Lpxi?=
 =?us-ascii?Q?cdARmoNBt9YVQdu4ty9ceqOeyy1r0i7efr9MjmU+O6PlwJN3HChBr6FZ+/dm?=
 =?us-ascii?Q?AVj/yEH+vrhWUOQkmHNkNbOVyli+BFr8CHB22WLSPfsx6anZON2ufXtR9kny?=
 =?us-ascii?Q?Mh4+v81Uk+ij5sh1NPGRkD1vs3jFznIz7wtvX2+35HrpCaQP4BJZI7L31i92?=
 =?us-ascii?Q?W+Z27DPaYKiawwSzfESEaWrygIONVK8RTOyzF+0Rt/60yEQd/XI/FroL/QQj?=
 =?us-ascii?Q?3p92zu2TfEeWNTBZASyNYH8b2kYT3I2IC5+7EmN6z/yReyit9+mvIDJs/fzv?=
 =?us-ascii?Q?RBS40gd9j6zv65u/gM+bj7dXt72n+O4jRLzdTZAq7a4u0jGSm2zXJUim+9TH?=
 =?us-ascii?Q?fo2cvkuwijA3Vmi8XVCgc/9OuxMljQAti0IGToxYh4eyq/iYiUVHqEsI+9mh?=
 =?us-ascii?Q?OPnw5erBCDDHPuzlU3DhrB3NeweSoHX4s8Xmxmc/J2nveDcCQ9hNejw38Buy?=
 =?us-ascii?Q?r2cOJiFW3GGvBi4oETHZlEXtr4VGa2gnrqQ/XpnVd9YCNyN5RpCypel7u/10?=
 =?us-ascii?Q?TLHinK+pPHulN8Kkn4KlVB6saf0djUX30JzKASW2fEvN1BYoId9Ro7LBXOew?=
 =?us-ascii?Q?7j+BzUDwZd9KP9Gzce58L/s0oiM3SmWC9AgNrZSKjO3M/8tfz1oAr9q+fbTb?=
 =?us-ascii?Q?UcqI0nYvMWIxDaBSORmAZQCOvt4lHReMHiY+JOaWc8CTTDtcuxTzXqLURY5h?=
 =?us-ascii?Q?+AXk+jnNWSdBvq5LLvAm7r+V/fWWB/r6QSbLlMUynsNJeJgIgzndUUJhnjfy?=
 =?us-ascii?Q?gABbQvQIyzx9Tr/JKVlOc9nO1Pwzq9oZeNSyB/3pbktoo5h8WQ0GdUbKau1X?=
 =?us-ascii?Q?5/yblOEb217H3nIx4f+ZtMGtS+jVIYj3jmtZdGCB5GoFeSRaCQDPbnvxd4BF?=
 =?us-ascii?Q?DMKg4MyPSJ0oDMoXFHZCErepp91x8aNHVVKjnht4/+ZERjyjUjrZ/jGDXnoZ?=
 =?us-ascii?Q?tHqNoTvaZWPvVLtXO4pl78I9pkZlzQrO464Ec40tJ3KySbzpQFryEezgHVQV?=
 =?us-ascii?Q?so+uwwOQf+mHsC8zfQN6pfmzcbIDAKhmINtcJnYMb9oIoDE3IkEcDMRqAQkJ?=
 =?us-ascii?Q?9JONxg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d75df2ba-c76d-49eb-1d8f-08d9b191d466
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 10:36:54.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLd7e9i6xkuDPWhbbC+nGKzpJUPTBWhqU8tt0PZUrCfM86sQMjJvSdkR4DQaWnWnQu1i7ZstZQo5OPx7mN7vOvkvTleu7uIMDGI0z7kER3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P190MB0923
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

> Von: Jakub Kicinski <kuba@kernel.org>
> Gesendet: Freitag, 26. November 2021 20:35
> An: Andrew Lunn <andrew@lunn.ch>; Sven Schuchmann <schuchmann@schleisshei=
mer.de>
> Cc: Woojung Huh <woojung.huh@microchip.com>; UNGLinuxDriver@microchip.com=
; David S. Miller
> <davem@davemloft.net>; netdev@vger.kernel.org; linux-usb@vger.kernel.org;=
 linux-
> kernel@vger.kernel.org
> Betreff: Re: [PATCH] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL =
instead of "0" if
> no IRQ is available
>=20
> On Fri, 26 Nov 2021 16:57:50 +0100 Andrew Lunn wrote:
> > On Fri, Nov 26, 2021 at 04:20:40PM +0100, Sven Schuchmann wrote:
> > > On most systems request for IRQ 0 will fail, phylib will print an err=
or message
> > > and fall back to polling. To fix this set the phydev->irq to PHY_POLL=
 if no IRQ
> > > is available.
> > >
> > > Signed-off-by: Sven Schuchmann <schuchmann@schleissheimer.de>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB =
Int. EP")
>=20
> right?

Seems right, will send a v2

Sven
