Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD2401502
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 04:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhIFCah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 22:30:37 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:50039
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232050AbhIFCag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 22:30:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV0QfLZ5GYLHSv5y3euggHSde/1CBvELcr+qvUooZvEGp1HSvtcpDhDfrNJ7B9hDkWs4yMrNywlAN3t31IIAAv4jpIXMQ9A2YmhcGwlat9hHCKSru3rvO9ZqbxiM1xJ57ikWkCereMbpr/Jes6sZ/MfWxLJaTVkko/Rr7wzTGr9alDNFUqNFVkLunGMR9fbChdueVnUeEXID+AMOmpdVDyWnZAYaQygasMTERNnOMAhvpTBSoL8/iroQQzQbXyR+z318z+tGKd4zgXDjn2PmXzIyaVhUcKiGClU0TwGO0fenrYNliEIM3K6Wy0e9syAoqKQcp9EfB53pwCXAWKm7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1BfTLAgU9nceHW/4AM1wOR1fdHmVXU0A9FxXzpoZCqs=;
 b=ef8tT7bC3JwRd6x4Q2Eqjiv1Ygl4G2MgMDADqbSPGdMvI0bcPibkXhZFa3ftfAR1guPl5w93dRo4EiAF5s50Inf9Zuw2VEcDCjfJuM3+Cg2QxZpN3Lg4lfLSnavG0vrCFl3fsKncOE4DhJoNxIAUBMKH8YrfM96jcKGJoAgfi2ldd/t5vr+Qz3UjijcgTTpYx22LUYOLa2Opz1VV5EW6habDy6JwIZuhzC/tlgiZ3X7RLVdFA2itXM3EYzFnciBpoo7NSAwaxf9V5sRyAyVGd/dREInmcq5z+q0Oyc7ND9mrZ3RGzt1M9/a2uNrAKhvvQgT/wj43Q/mZJz1TP9HFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BfTLAgU9nceHW/4AM1wOR1fdHmVXU0A9FxXzpoZCqs=;
 b=QeYFQ56ez8Ib4Ewq9IxKmKi0soetKcsVi88eIh8G7ajSolFzvwDaSCn+gTiV32TjrbP5g4uF6Lj2WPj+EdhI9SVnqGfNjq1OxGm7WPqbe+Jp8u6BkC8YzebWOO7uh2xkAHEs/N21NmwKh+mOVxvN+PyM6NdVmnoXcUhrf0l557o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2727.eurprd04.prod.outlook.com (2603:10a6:4:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Mon, 6 Sep
 2021 02:29:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 02:29:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Topic: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO53WAgAAPWNCAAAsFgIAACEPggAAhioCAAQx9sIAAM98AgAAW9HCAAA9qgIAAAa+AgAAYrQCAAOF04IAAZ5oAgAAFMvCAABQ5AIAADizAgAAbXoCAAIkbAIADjA8g
Date:   Mon, 6 Sep 2021 02:29:30 +0000
Message-ID: <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
In-Reply-To: <20210903201210.GF1350@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a01c675d-6ba2-4578-5d68-08d970de280e
x-ms-traffictypediagnostic: DB6PR0402MB2727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27277D1678CE5EC9B5489DF1E6D29@DB6PR0402MB2727.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GkI0KM42rzt6Bh/K6AlXiEr5H+g+IzXVqswd4dM4xlvFaooE9th2/RoylGVZaWTK6BG8zLxFoonbQJ0CGjenRFY3S1rTjFOXQQstxWNKSOxMi/y2hCLIOjoW2t6TRTpqW2ncWBDFQNyOxzvI15Junm53zmlZyeSTTmv3JlKEw7qa0Sy5hzZ5kWMFuw0XqoA7FAdiOUPghFuYH6Uxu56TrLukIvNlH6nnG4qLgZCSmFhyDX9t8ZtOGYXBYuwSGXn+Q9JKTJ910WP5tUBOtqXSJteA/TlPPvWGL0dfkFcFD+KVb67d/QGvpSA5EJvZyiRkw2dpwg4C8K958jjNzw8QXVQLH7Kuh9wup4C2nloIv0IfUDK2e6z4y4R786HXNObG2WF6Ozt34IkszQo2HVFzspH3HU2j8mnTrwmCaOlZjCxVHWpfKJ1DbB8PgiF9ehiyrKgCyKvssnGiIQhqAMF/GP9vl2KMVzA2/zggeEwKn6r2RlyYthp/LB7WuKlOM5K3VUiVmMPz8/+H0Ub97rDMaubE8ULxOWHK7A7I9CXm6UVdFy7Y7veM27/8RVc8l7qP39CgFIimxzi/4ZXRyAU5tCMJCRtLqnIuqlwjcvDf8DfQ34gL09ht8rMAaQWQIQnf0ejybj0KVGC++o8qfIoo44TcV4LmnVzTyzBJ3ZCCYbik4dYoiakulEZSidsba/1pTsx0iGOwJu94lNnjdkH+TQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(186003)(86362001)(71200400001)(66476007)(7696005)(2906002)(122000001)(38100700002)(8936002)(54906003)(6916009)(6506007)(26005)(53546011)(66556008)(64756008)(38070700005)(66946007)(76116006)(33656002)(316002)(4326008)(52536014)(5660300002)(55016002)(9686003)(7416002)(83380400001)(478600001)(8676002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2NKKzgwZDdEUkp0WFVpREgzQjlIMzN5d3k4dEw2ZmRNSWpOSkxycTRaelhF?=
 =?utf-8?B?T0UwY0t2SFRYMy9jWnpUMFltcWhpNjUwR08rUFdxUTBLS0JJYUdlQ3ZId1E0?=
 =?utf-8?B?NGduUXNkZlVqYUgrV1BtMGpVd1ZUTXd1a0xBbXBKZk1adnk1dE84eERPMkpy?=
 =?utf-8?B?N3VzdUk2aGhWVnlFTy9kUnprZWozWmIxRWUySGVUOFBBVzZyUU12RW1tN2Fk?=
 =?utf-8?B?UTFmVE1DUUhtV0t2U1dUYW13WjBncHU1amlpRzNZcmdJT2pSM1lmcEVzYkdp?=
 =?utf-8?B?RHM0bHdra3EwUzIzTklvWDJiUlhQWlpjSjA4T1Z6R2xpcStRMHNCRi9Ob0Nv?=
 =?utf-8?B?aE5pYzVjNlhHNXVVTDBlVWNKWnhWKzJQYVIyYUQrWXVLY3BFb2RnZ3NHcnEv?=
 =?utf-8?B?TFp0M0ltL05Kbnp2M2Nvcld6d245VnBsTS9xQjNxc05rQkNaT0ZwOTYzUG90?=
 =?utf-8?B?WU5CZkxKdlpGL0lKay9RUGkzNlFTbGgra1lYWllSUldNRmE4QTNqRDlsT05E?=
 =?utf-8?B?SnUwQjNmOC9rYjNyMEhMc2xzWmU2V0VuT1FoQzBBWndzYkM2OUh4QndPRlN4?=
 =?utf-8?B?TE95K0FiejR5Y2duUjA4ZVdtckpWUzVqSXBYdzQrU0pqd2grMWJXNTdHUTVC?=
 =?utf-8?B?Z2hibWhMQ0pBb3ZLVzZvT1E2YU1VZW4zclZYZVlIcjdXdXJvNzV3eitzdnh5?=
 =?utf-8?B?MHRCNitqcHBqSVlrSXR4WE81Mk9Mai84MjFZWVkzN2xmTUF5NjN1Nmc3cVpx?=
 =?utf-8?B?VWI3Q3JIRWdEOTVRV0NOUjB3R25rSW5qbXRyeU5zZVhXQ2JsWE5qNmFRZmVJ?=
 =?utf-8?B?d1NhMlA2dWFWVmJMZVJheVp5YU9oZm5FQWt2YVB5OHp5S0U3cXMxZjgzc1FG?=
 =?utf-8?B?MUJTbFNLNDZZZUF0OFo4d2Fhc3lqTkpjdnIyMDRXU2ZDQXhvQlhmWG1iVU9I?=
 =?utf-8?B?OHdiRU5UZ1hoL3dtOThJZi9wY01DL0g3YUhIdjR2Uzh2WEM0elB5bTZTTmFW?=
 =?utf-8?B?dXp2bm9kb2FOb1k2QllteEU0dzBwZ1lhUW45VUVQbC9nbzhhajBDYVIrRS9v?=
 =?utf-8?B?Tk41Rm9kTFFZRmVTeEZLUHdhSVVlcDNva2hjcmRta1k1VDRBNmJqa1h3QUxR?=
 =?utf-8?B?Vm1mcCtwNUdBcktaeVY4dGR1RzVYZjZWS3hQblYwaG5uS0dtTExoR2dzQUla?=
 =?utf-8?B?cVRtcUVRTzdBdmVscmN2WVM1MWJDWU8raVprbFJCeUNaNzQzSFpES0RSd0Y2?=
 =?utf-8?B?b1VORThWcFNkWG1rbWNmeE5vTmpwUWhLbGliMUFkM0FSQStvZjBQWjV2bWdM?=
 =?utf-8?B?Y0NWRE1WTTdTL3ZwbEdHWDUyQjJtYVZHamFYaUU2YXQxNWpVM21kOXB1eDFs?=
 =?utf-8?B?dmoxT2dJZUlNKzh0QmRuRFZKa2ZPcmVwRHNHSzlTRWQ4WHRyU2R2VXpJMjVi?=
 =?utf-8?B?SldydkNQV2hBb3kxMzZQRnA2VFBwZTBTL3RXM0pUVklEVUdTbW8rakhkTHRO?=
 =?utf-8?B?OGVJTFBhVC9YajBGRit1NW5DQU96M0M5YXB1KzU2L1Bua25vMWk5RDNIK1dy?=
 =?utf-8?B?WUd0dW1qTEFmbytZWWVVWXdNbGt1SUJnbGczQ2NXS0tJMXBBalQzUVg4ejUx?=
 =?utf-8?B?bTFKMFFQblVxUThOdW9tOHJTVmV3VW5tTElIVUhtUGNzNHRvcEhhMGt6YzJQ?=
 =?utf-8?B?SDJpZmYrY0x1OU9zTXMrYy93VXlWNW9WaWY2dWo3MVpTWkhSdGY2S2NpQWVo?=
 =?utf-8?Q?lIZD48DyRXd+Uy0NS88eXkz5a94vRAzjYE6GzzU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01c675d-6ba2-4578-5d68-08d970de280e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 02:29:30.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERD4XGrq4gjhb7Tu2NLLAVom3ew6TXzjM7Tf4BgbwsSugBkO3xoILiKi68fMaZ849JDE+0qWFPHLbzFa80n/Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2727
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIx5bm0OeaciDTm
l6UgNDoxMg0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Q2M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFu
dkBnbWFpbC5jb20+Ow0KPiBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5kcmUudG9yZ3Vl
QGZvc3Muc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsga3ViYUBrZXJuZWwub3JnOw0KPiBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsNCj4gaGthbGx3ZWl0MUBnbWFp
bC5jb207IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0hdIG5ldDogc3RtbWFjOiBmaXggTUFDIG5vdCB3b3JraW5nIHdoZW4gc3lzdGVtIHJlc3Vt
ZQ0KPiBiYWNrIHdpdGggV29MIGVuYWJsZWQNCj4gDQo+IEhpLA0KPiANCj4gSGVyZSdzIGEgcGF0
Y2ggdG8gdHJ5IC0geW91J2xsIG5lZWQgdG8gaW50ZWdyYXRlIHRoZSBuZXcgY2FsbHMgaW50byBz
dG1tYWMncw0KPiBzdXNwZW5kIGFuZCByZXN1bWUgaG9va3MuIE9idmlvdXNseSwgZ2l2ZW4gbXkg
cHJldmlvdXMgY29tbWVudHMsIHRoaXMgaXNuJ3QNCj4gdGVzdGVkIQ0KPiANCj4gSSBkaWRuJ3Qg
bmVlZCB0byByZXBlYXQgdGhlIG1hY193b2wgYm9vbGVhbiB0byBwaHlsaW5rX3Jlc3VtZSBhcyB3
ZSBjYW4NCj4gcmVjb3JkIHRoZSBzdGF0ZSBpbnRlcm5hbGx5IC0gbWFjX3dvbCBzaG91bGQgbm90
IGNoYW5nZSBiZXR3ZWVuIGEgY2FsbCB0bw0KPiBwaHlsaW5rX3N1c3BlbmQoKSBhbmQgc3Vic2Vx
dWVudCBwaHlsaW5rX3Jlc3VtZSgpIGFueXdheS4NCj4gDQo+IG1hY193b2wgc2hvdWxkIG9ubHkg
YmUgdHJ1ZSBpZiB0aGUgTUFDIGlzIGludm9sdmVkIGluIHByb2Nlc3NpbmcgcGFja2V0cyBmb3IN
Cj4gV29MLCBmYWxzZSBvdGhlcndpc2UuDQo+IA0KPiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgdGhp
cyByZXNvbHZlcyB5b3VyIHN0bW1hYyBXb0wgaXNzdWUuDQoNClRoYW5rcyBhIGxvdCBmb3IgeW91
ciB3b3JrLiDwn5iKDQoNClRoZXJlIGlzIGEgYnVpbGQgaXNzdWUgaW4gdGhpcyBwYXRjaCwgY291
bGQgeW91IHBsZWFzZSBoYXZlIGEgY2hlY2s/IEkgd29yayBvbiB0aGUgbGF0ZXN0IG5ldC1uZXh0
IHJlcG8uDQoNCj4gVGhhbmtzLg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9w
aHlsaW5rLmMgYi9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jIGluZGV4DQo+IGYwYzc2OTAyNzE0
NS4uYzRkMGRlMDQ0MTZhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvcGh5bGluay5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMNCj4gQEAgLTMzLDYgKzMzLDcgQEAN
Cj4gIGVudW0gew0KPiAgCVBIWUxJTktfRElTQUJMRV9TVE9QUEVELA0KPiAgCVBIWUxJTktfRElT
QUJMRV9MSU5LLA0KPiArCVBIWUxJTktfRElTQUJMRV9NQUNfV09MLA0KPiAgfTsNCj4gDQo+ICAv
KioNCj4gQEAgLTEzMTMsNiArMTMxNCw5IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHBoeWxpbmtfc3Rh
cnQpOw0KPiAgICogbmV0d29yayBkZXZpY2UgZHJpdmVyJ3MgJnN0cnVjdCBuZXRfZGV2aWNlX29w
cyBuZG9fc3RvcCgpIG1ldGhvZC4gIFRoZQ0KPiAgICogbmV0d29yayBkZXZpY2UncyBjYXJyaWVy
IHN0YXRlIHNob3VsZCBub3QgYmUgY2hhbmdlZCBwcmlvciB0byBjYWxsaW5nIHRoaXMNCj4gICAq
IGZ1bmN0aW9uLg0KPiArICoNCj4gKyAqIFRoaXMgd2lsbCBzeW5jaHJvbm91c2x5IGJyaW5nIGRv
d24gdGhlIGxpbmsgaWYgdGhlIGxpbmsgaXMgbm90DQo+ICsgYWxyZWFkeQ0KPiArICogZG93biAo
aW4gb3RoZXIgd29yZHMsIGl0IHdpbGwgdHJpZ2dlciBhIG1hY19saW5rX2Rvd24oKSBtZXRob2QN
Cj4gKyBjYWxsLikNCj4gICAqLw0KPiAgdm9pZCBwaHlsaW5rX3N0b3Aoc3RydWN0IHBoeWxpbmsg
KnBsKQ0KPiAgew0KPiBAQCAtMTMzOCw2ICsxMzQyLDgxIEBAIHZvaWQgcGh5bGlua19zdG9wKHN0
cnVjdCBwaHlsaW5rICpwbCkgIH0NCj4gRVhQT1JUX1NZTUJPTF9HUEwocGh5bGlua19zdG9wKTsN
Cj4gDQo+ICsNCj4gKy8qKg0KPiArICogcGh5bGlua19zdXNwZW5kKCkgLSBoYW5kbGUgYSBuZXR3
b3JrIGRldmljZSBzdXNwZW5kIGV2ZW50DQo+ICsgKiBAcGw6IGEgcG9pbnRlciB0byBhICZzdHJ1
Y3QgcGh5bGluayByZXR1cm5lZCBmcm9tIHBoeWxpbmtfY3JlYXRlKCkNCj4gKyAqIEBtYWNfd29s
OiB0cnVlIGlmIHRoZSBNQUMgbmVlZHMgdG8gcmVjZWl2ZSBwYWNrZXRzIGZvciBXYWtlLW9uLUxh
bg0KPiArICoNCj4gKyAqIEhhbmRsZSBhIG5ldHdvcmsgZGV2aWNlIHN1c3BlbmQgZXZlbnQuIFRo
ZXJlIGFyZSBzZXZlcmFsIGNhc2VzOg0KPiArICogLSBJZiBXYWtlLW9uLUxhbiBpcyBub3QgYWN0
aXZlLCB3ZSBjYW4gYnJpbmcgZG93biB0aGUgbGluayBiZXR3ZWVuDQo+ICsgKiAgIHRoZSBNQUMg
YW5kIFBIWSBieSBjYWxsaW5nIHBoeWxpbmtfc3RvcCgpLg0KPiArICogLSBJZiBXYWtlLW9uLUxh
biBpcyBhY3RpdmUsIGFuZCBiZWluZyBoYW5kbGVkIG9ubHkgYnkgdGhlIFBIWSwgd2UNCj4gKyAq
ICAgY2FuIGFsc28gYnJpbmcgZG93biB0aGUgbGluayBiZXR3ZWVuIHRoZSBNQUMgYW5kIFBIWS4N
Cj4gKyAqIC0gSWYgV2FrZS1vbi1MYW4gaXMgYWN0aXZlLCBidXQgYmVpbmcgaGFuZGxlZCBieSB0
aGUgTUFDLCB0aGUgTUFDDQo+ICsgKiAgIHN0aWxsIG5lZWRzIHRvIHJlY2VpdmUgcGFja2V0cywg
c28gd2UgY2FuIG5vdCBicmluZyB0aGUgbGluayBkb3duLg0KPiArICovDQo+ICt2b2lkIHBoeWxp
bmtfc3VzcGVuZChzdHJ1Y3QgcGh5bGluayAqcGwsIGJvb2wgbWFjX3dvbCkgew0KPiArCUFTU0VS
VF9SVE5MKCk7DQo+ICsNCj4gKwlpZiAobWFjX3dvbCAmJiAoIXBsLT5uZXRkZXYgfHwgcGwtPm5l
dGRldi0+d29sX2VuYWJsZWQpKSB7DQo+ICsJCS8qIFdha2Utb24tTGFuIGVuYWJsZWQsIE1BQyBo
YW5kbGluZyAqLw0KPiArCQltdXRleF9sb2NrKCZwbC0+c3RhdGVfbXV0ZXgpOw0KPiArDQo+ICsJ
CS8qIFN0b3AgdGhlIHJlc29sdmVyIGJyaW5naW5nIHRoZSBsaW5rIHVwICovDQo+ICsJCV9fc2V0
X2JpdChQSFlMSU5LX0RJU0FCTEVfTUFDX1dPTCwNCj4gJnBsLT5waHlsaW5rX2Rpc2FibGVfc3Rh
dGUpOw0KPiArDQo+ICsJCS8qIERpc2FibGUgdGhlIGNhcnJpZXIsIHRvIHByZXZlbnQgdHJhbnNt
aXQgdGltZW91dHMsDQo+ICsJCSAqIGJ1dCBvbmUgd291bGQgaG9wZSBhbGwgcGFja2V0cyBoYXZl
IGJlZW4gc2VudC4NCj4gKwkJICovDQo+ICsJCW5ldGlmX2NhcnJpZXJfb2ZmKHBsLT5uZXRkZXYp
Ow0KPiArDQo+ICsJCS8qIFdlIGRvIG5vdCBjYWxsIG1hY19saW5rX2Rvd24oKSBoZXJlIGFzIHdl
IHdhbnQgdGhlDQo+ICsJCSAqIGxpbmsgdG8gcmVtYWluIHVwIHRvIHJlY2VpdmUgdGhlIFdvTCBw
YWNrZXRzLg0KPiArCQkgKi8NCj4gKwkJbXV0ZXhfdW5sb2NrKCZwbC0+c3RhdGVfbXV0ZXgpOw0K
PiArCX0gZWxzZSB7DQo+ICsJCXBoeWxpbmtfc3RvcChwbCk7DQo+ICsJfQ0KPiArfQ0KPiArRVhQ
T1JUX1NZTUJPTF9HUEwocGh5bGlua19zdXNwZW5kKTsNCj4gKw0KPiArLyoqDQo+ICsgKiBwaHls
aW5rX3Jlc3VtZSgpIC0gaGFuZGxlIGEgbmV0d29yayBkZXZpY2UgcmVzdW1lIGV2ZW50DQo+ICsg
KiBAcGw6IGEgcG9pbnRlciB0byBhICZzdHJ1Y3QgcGh5bGluayByZXR1cm5lZCBmcm9tIHBoeWxp
bmtfY3JlYXRlKCkNCj4gKyAqDQo+ICsgKiBVbmRvIHRoZSBlZmZlY3RzIG9mIHBoeWxpbmtfc3Vz
cGVuZCgpLCByZXR1cm5pbmcgdGhlIGxpbmsgdG8gYW4NCj4gKyAqIG9wZXJhdGlvbmFsIHN0YXRl
Lg0KPiArICovDQo+ICt2b2lkIHBoeWxpbmtfcmVzdW1lKHN0cnVjdCBwaHlsaW5rICpwbCkgew0K
PiArCUFTU0VSVF9SVE5MKCk7DQo+ICsNCj4gKwlpZiAodGVzdF9iaXQoUEhZTElOS19ESVNBQkxF
X01BQ19XT0wsICZwbC0+cGh5bGlua19kaXNhYmxlX3N0YXRlKSkgew0KPiArCQkvKiBXYWtlLW9u
LUxhbiBlbmFibGVkLCBNQUMgaGFuZGxpbmcgKi8NCj4gKw0KPiArCQkvKiBDYWxsIG1hY19saW5r
X2Rvd24oKSBzbyB3ZSBrZWVwIHRoZSBvdmVyYWxsIHN0YXRlIGJhbGFuY2VkLg0KPiArCQkgKiBE
byB0aGlzIHVuZGVyIHRoZSBzdGF0ZV9tdXRleCBsb2NrIGZvciBjb25zaXN0ZW5jeS4gVGhpcw0K
PiArCQkgKiB3aWxsIGNhdXNlIGEgIkxpbmsgRG93biIgbWVzc2FnZSB0byBiZSBwcmludGVkIGR1
cmluZw0KPiArCQkgKiByZXN1bWUsIHdoaWNoIGlzIGhhcm1sZXNzIC0gdGhlIHRydWUgbGluayBz
dGF0ZSB3aWxsIGJlDQo+ICsJCSAqIHByaW50ZWQgd2hlbiB3ZSBydW4gYSByZXNvbHZlLg0KPiAr
CQkgKi8NCj4gKwkJbXV0ZXhfbG9jaygmcGwtPnN0YXRlX211dGV4KTsNCj4gKwkJcGh5bGlua19s
aW5rX2Rvd24ocGwpOw0KPiArCQltdXRleF91bmxvY2soJnBsLT5zdGF0ZV9tdXRleCk7DQo+ICsN
Cj4gKwkJLyogUmUtYXBwbHkgdGhlIGxpbmsgcGFyYW1ldGVycyBzbyB0aGF0IGFsbCB0aGUgc2V0
dGluZ3MgZ2V0DQo+ICsJCSAqIHJlc3RvcmVkIHRvIHRoZSBNQUMuDQo+ICsJCSAqLw0KPiArCQlw
aHlsaW5rX21hY19pbml0aWFsX2NvbmZpZyhwbCwgdHJ1ZSk7DQo+ICsJCXBoeWxpbmtfZW5hYmxl
X2FuZF9ydW5fcmVzb2x2ZShwbCwgUEhZTElOS19ESVNBQkxFX01BQ19XT0wpOw0KDQpUaGVyZSBp
cyBubyAicGh5bGlua19lbmFibGVfYW5kX3J1bl9yZXNvbHZlICIgc3lzYm9sLCBJIGd1ZXNzIHlv
dSB3YW50IGRvIGJlbG93IG9wZXJhdGlvbnMgaW4gdGhpcyBmdW5jdGlvbjoNCgljbGVhcl9iaXQo
UEhZTElOS19ESVNBQkxFX01BQ19XT0wsICZwbC0+cGh5bGlua19kaXNhYmxlX3N0YXRlKTsNCglw
aHlsaW5rX3J1bl9yZXNvbHZlKHBsKTsNCg0KPiArCX0gZWxzZSB7DQo+ICsJCXBoeWxpbmtfc3Rh
cnQocGwpOw0KPiArCX0NCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHBoeWxpbmtfcmVzdW1l
KTsNCj4gKw0KPiAgLyoqDQo+ICAgKiBwaHlsaW5rX2V0aHRvb2xfZ2V0X3dvbCgpIC0gZ2V0IHRo
ZSB3YWtlIG9uIGxhbiBwYXJhbWV0ZXJzIGZvciB0aGUgUEhZDQo+ICAgKiBAcGw6IGEgcG9pbnRl
ciB0byBhICZzdHJ1Y3QgcGh5bGluayByZXR1cm5lZCBmcm9tIHBoeWxpbmtfY3JlYXRlKCkgZGlm
ZiAtLWdpdA0KPiBhL2luY2x1ZGUvbGludXgvcGh5bGluay5oIGIvaW5jbHVkZS9saW51eC9waHls
aW5rLmggaW5kZXgNCj4gYmRlZWM4MDBkYTVjLi5iYTBhYjcxMjZiOTYgMTAwNjQ0DQo+IC0tLSBh
L2luY2x1ZGUvbGludXgvcGh5bGluay5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvcGh5bGluay5o
DQo+IEBAIC00NjIsNiArNDYyLDkgQEAgdm9pZCBwaHlsaW5rX21hY19jaGFuZ2Uoc3RydWN0IHBo
eWxpbmsgKiwgYm9vbCB1cCk7DQo+IHZvaWQgcGh5bGlua19zdGFydChzdHJ1Y3QgcGh5bGluayAq
KTsgIHZvaWQgcGh5bGlua19zdG9wKHN0cnVjdCBwaHlsaW5rICopOw0KPiANCj4gK3ZvaWQgcGh5
bGlua19zdXNwZW5kKHN0cnVjdCBwaHlsaW5rICpwbCwgYm9vbCBtYWNfd29sKTsgdm9pZA0KPiAr
cGh5bGlua19yZXN1bWUoc3RydWN0IHBoeWxpbmsgKnBsKTsNCj4gKw0KPiAgdm9pZCBwaHlsaW5r
X2V0aHRvb2xfZ2V0X3dvbChzdHJ1Y3QgcGh5bGluayAqLCBzdHJ1Y3QgZXRodG9vbF93b2xpbmZv
ICopOyAgaW50DQo+IHBoeWxpbmtfZXRodG9vbF9zZXRfd29sKHN0cnVjdCBwaHlsaW5rICosIHN0
cnVjdCBldGh0b29sX3dvbGluZm8gKik7DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
