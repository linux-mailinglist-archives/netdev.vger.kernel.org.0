Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6132307F
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhBWSTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:19:05 -0500
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:55296
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233758AbhBWSTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 13:19:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7fAYbBgGlE5mSCfERdNC1NOSV0dh2VSq7f2hel6sgafPKlqNEY9hVGjIpPHQdLIXuLjOGPWkqoVtaKtXxK7f5yx6yw37bdAYFPV03Yog6Mod6z3cCopUsud1Xnykmiv7o7/WeoWgUzamd29hR4KtnSUcbJ+KgVru40UV83juMnHUiSbC+Q8xRd7kjY0LLqrtx3SheSP9nnh5tKJVQ+4Xpfa/Qd/WrbkZaImkr851kCoph2CtxKhMiJiqAfc7kQZh1AkPKL/nyDBlJiczEXAe6XAJXzK92zbFcnl7PLUKVHmo/WJD1Y4VAN4+MtIy/y1b0wQRKHY6PF1m2VTrS7HBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oV1zOe9TtGxs+gvxKHM1RZrvqy/y1d7nugtYXPwK+Qg=;
 b=ZhGYVoAJ1/ZYlyS3ZIWG5LKqRPe0LAcgCFWJz5ASUq0r8GN3DzuBoR5ewebF/hJKeLlvAupkagMwVQGwQDI3DutyTlOgoDDjFzaLN7gPcxMkzwNu5q0ftJC60mG8K//j9nvqvaRwMkVUTeBdtYjxRQ8mY+gXhLhaAU9XKZ20Bb0O9JWUFRuJidBBmAcZhYZsSzan2Eb+wk2UOnnB5UHCM5IFrPt82W6p2l6JSoNq0R9NlsNwOAVP1q0iL/gYtLytf/zhUbyp3yjJnIBARzOt5u6WK9n8IVpX1eZX5BMPxv14O2nRd+aR5SyKe916zyqtU7zowmPcWAq3X9m20HiVPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oV1zOe9TtGxs+gvxKHM1RZrvqy/y1d7nugtYXPwK+Qg=;
 b=XJgAT/jbxqusj0EN/ljeAsGxNdLMpMi64eozViPQdiMUVROlNhhYC70n8bT8Jpzpo+Lc8HzQwkkC+d1CaOub26PKz9qpvcxKe3UIthFR7AmFhPQQ2R+Hj9kSetRLNxiKVrcWnpUxridWkvztO485GwAj+dDI+0HYNaxreRHegU8=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2240.eurprd04.prod.outlook.com
 (2603:10a6:800:29::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 18:18:13 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 18:18:13 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sven Schuchmann <schuchmann@schleissheimer.de>
CC:     Dan Murphy <dmurphy@ti.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: net: phy: ti: implement generic .handle_interrupt() callback
Thread-Topic: net: phy: ti: implement generic .handle_interrupt() callback
Thread-Index: AdcKC41VqgAALwodStOMhfH0LIc3FgABLF0A
Date:   Tue, 23 Feb 2021 18:18:13 +0000
Message-ID: <20210223181812.ti3r5net4v6vcutt@skbuf>
References: <DB8P190MB0634C73B4363753F62FCE4B6D9809@DB8P190MB0634.EURP190.PROD.OUTLOOK.COM>
In-Reply-To: <DB8P190MB0634C73B4363753F62FCE4B6D9809@DB8P190MB0634.EURP190.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: schleissheimer.de; dkim=none (message not signed)
 header.d=none;schleissheimer.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d6420488-19f0-466e-66b6-08d8d827624d
x-ms-traffictypediagnostic: VI1PR0401MB2240:
x-microsoft-antispam-prvs: <VI1PR0401MB2240D254853BA14D53E7E0C1E0809@VI1PR0401MB2240.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WEzL3mzWpX5WxzKWey3036US+2nTBYnKudw84+KjGFM6UrjqgZ1nocTl7e2022LMa/0KBejEfgxuCEzS7vdsfIKiq3CItl5Ta3a6KnTkouHQbxT91tlgVqs2Om7TeLY2tF3FUjP2kohwUDVHPQ0S/UoS1xKrx3o19IMty5YZnoBh3sXT+6+vn17ISFmrdl4+XwRT4v6txkFTR7UUb72vFJF0Ok08EVN56U1OEf2eq05oGduX3MqeyQKQTI2B1Qyrd0LrcBXVjvX3eMRDuW7zkQEDYLpcC5UBLp41AIiTdx4q8HmxaYkeWinoUnGlFaoU7gpU3rZKyNhbuFHC8N+0ceoXoVXLv7JCYsTsySaXOPM/nmAOjucTy6VZzIOwLbJpmhLUI/P1wtqF/WZ3LAzPDg6COymZnqO4esnWmeu8SsNGsZpOsjYyrIdfI1gu24o0ZKMGR/+GupRjxHxGoBEIRoU4s2S79SFI6iE9CXGxssg5Oo5I/OWf8O96erKP9T+Torexa7LtewgQoEj2T6Rc7BldnpEknziFrt+YdADfjxFFrSiSU97g3IwE9Lubfhya5u3WH/aJlhggd4DczsQow3AipyT0/LWKEXQ2BiGX0sdh61LTGpuJNTHT3S/eOqQPXzBLoU0xaWz+Pl1j7HEfDoDcfXuvawODnc19I6lJZ5o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(376002)(396003)(346002)(136003)(66946007)(66476007)(64756008)(66446008)(66556008)(91956017)(76116006)(33716001)(4326008)(186003)(2906002)(26005)(478600001)(8676002)(6916009)(6486002)(54906003)(1076003)(8936002)(44832011)(71200400001)(6506007)(5660300002)(966005)(86362001)(9686003)(4744005)(6512007)(316002)(41533002)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OaPZA8zIVKrvMTCKeYiSQ8KrBQM4n1OxUyV7GNffTwlqBAfHoFKkGuDFC3L+?=
 =?us-ascii?Q?t5SXUPX5o+erGNVCGdMQTBY/qFXr55YZLgIgvVJwBFWbyejPbA1x0vlaJ3mo?=
 =?us-ascii?Q?H0UrgnF+9MCKhVF0lIWsxQ72c2wdIYW2Jrl/3+QFDUW9s+fejEkYGqq/RFwH?=
 =?us-ascii?Q?MEyojhZ9R2BxNyQvn2kXDplYAqEuxDIeT7FeIL8n5sZLahTAaLB82py8xllo?=
 =?us-ascii?Q?P8HnukK9+Grz/M6n/dXeSGPcoXGlW/eqnkEJyYzyT4P3HD4iO359fGng5A7m?=
 =?us-ascii?Q?Gd6ReICCQhw1A02IeZCbYqolIEkktVc6AyM0d56+SLnbQxNkGqvZQM1thEP5?=
 =?us-ascii?Q?uS2DkMzlvP72wSYFOUd+Id+sdTVIjrDn18Cgdf6rAc91s1Z9HimZm04l8OrO?=
 =?us-ascii?Q?wQ0VUtsaop62B7xA63cB+cmHjG8PQBC/7XGONTNnEySR/2vhezBdwIm6LXGH?=
 =?us-ascii?Q?uj+EGBxvbVw3+z91dbO4M4348KAjwB6sobawYSUcDID8Ftg4pJrBXVyEIYTg?=
 =?us-ascii?Q?iuQ2+Ed70TaYyS9kagi5ZB9NA37EXYvw6QmMA6pMVAi0LeThLw9kpoY5MIXC?=
 =?us-ascii?Q?XRp/Lg0sBo1/JrJ8VAh6i0pJAphi1Fm/kivw2UkGyTGJELy6XRAtMnMQc8np?=
 =?us-ascii?Q?fTWJy1pOdnaI6YrlZLeVlaZfvSL/HC6A0Z2y+5XVn2i7CoDE0gG+SoJkBSqX?=
 =?us-ascii?Q?EzhhYC1D1CjrEV4bOknjmg0DpyCZzzwlKHr9nZBN+G6S6Jk7MN6ZoxVgtFEj?=
 =?us-ascii?Q?UqguEWsrawdBQQJwTgDqi88rzhai6ZmQuaO4mv2rX2fu5THhV9oeb+li4Buh?=
 =?us-ascii?Q?jwyipqqeXnJQLQHFTd+48uiwcZiXmBu1b4PwJROwTPI97lCiUduK4ELRrZWr?=
 =?us-ascii?Q?ox3Qs6IPPWzWb2DlhuZu0urXNuk7DWEwh7fmC1AhUVtdQJ6AH6wa7IZR3KZ5?=
 =?us-ascii?Q?TJZF9fss25CPVBfslwTN3bZ+X5zDjOgprhtVCoQzhJGMMyyK+XkwG+QaomYg?=
 =?us-ascii?Q?oojnYPchMxe15MHTMIRbE6IJU9unFksXlCEkc/eqPEQMbrURpi7Lst8p2MgF?=
 =?us-ascii?Q?fWBe15ME8q4JO+u4Uac8rfIyMzCqiz0kX4SBHYhuS1hs+F0GHCPx7mZ75OeV?=
 =?us-ascii?Q?bM6R6P3khSb0yRUPYVID7Eifelz99p9jIEIAP+ZSAGk8vIUgPxuS7SOiMBLJ?=
 =?us-ascii?Q?tt09Hv9UbrgZ7PW1Uw6G1m65t5ZJmAI3FSILBRZVHkMjzNB1yn5xfJtM6qGb?=
 =?us-ascii?Q?YZQbhaClnfZyZMXAySHccICMQH30mzTaRla0OxdZQsVNVjn/ZUjSv8XXjW67?=
 =?us-ascii?Q?K7aRRE823eTh2dY0Bx/HLDku?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E94AA35E4E2398469B6386A197282AF8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6420488-19f0-466e-66b6-08d8d827624d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 18:18:13.6289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NT2DjuwWKSPzkFG9r4s8BQGQW5LXTAb1/Ydv5CuW99bBRdZ67nomZuYZAZI8B16BNNd1z7ocdQgcvVgEc1zxwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 05:44:57PM +0000, Sven Schuchmann wrote:
> Hello all,
>=20
> I am working with the DP83TC811R but for now on the 5.10 kernel.
> I have seen this patch on the latest dev
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/drivers/net/phy/dp83tc811.c?h=3Dv5.11&id=3D1d1ae3c6ca3ff49843d73852bb2a815=
3ce16f432
>=20
> I did not test it yet, but I wonder about one thing:
> What happens when there are 2 Flags set e.g.
> in INT_STAT1 and one in INT_STAT2?
> What I see from the code is that it would
> only read (and acknowledge) the first one and
> then quit out to trigger_machine.
>=20
> Any thoughts about this?
>=20

Hi Sven,

Indeed, I didn't take into consideration the fact that all the status
registers should be acknowledged since multiple interrupt sources could
be asserted. This could really break a system with an edge-triggered
interrupt.

I'll send out a fixup patch.

Thanks!

Ioana=
