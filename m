Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BED8357BEB
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 07:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhDHFms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 01:42:48 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:4366
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhDHFms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 01:42:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqTlLswtvOTr1cv+/3RAbxBKQmQB1yCbB2uwz6iKNP0F99lo0GCeqxalaygMqpRkKRadrFR1BU5Ez5FlWPDz7pBIx0/QKdPbrhv0UEhXi++fxB7vLEJNJPO69kdzZ58g/5bzc6IOx7VQasGD3dfgtdy9A/LELdvjeiwMPGO5kZUd8qN9XJfWA3DQY9plrUHRyO2GNTVJkOwkzOibDawCpG7G75XgMsvlROVTX+ALkmEO/2UZt0NI4L12dquVh/ofX6SCoHqFHquMVIYVfM1hdtdx9k2WGDm7S7/C5S2hFegaIa1rw4mLi89m7rFfFV0ZQP5UNc1ihkKuoz4ckkbqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkeV67da+Vi6XhuMk49Dv81Hlc0aCNh7DfHKaGs79Eg=;
 b=HgiQwb9JY6+sDYbXXTgc9jQkfqHwiVuRIE/7uvPJDrreVqczgwRz48cFxL1XWBwJJwNf7txV3fv6wae1ssf6J9qv3HAzZCXaWGOANejyWnR0z+hj2Ex+D3/YRuBQMpZjaHoctqv8dx2HPFrwMm2CjPWdL06VXIw49FFvYXZ1eWBdnl8B85YeX1Pz7aV9V2Akwl/sZgfy2nZnC4maoleA0XX5p70nvhHwl2gBway0+/Gyftj1oTNOm9IyART/Dt3weWuCYzj9raySSUR35KORGO/S1X4WYlkgdt2JhLKTHjMz/mimyVX2w9sK+kDAzbb08ucYliFvCtRAtv3ISvcOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkeV67da+Vi6XhuMk49Dv81Hlc0aCNh7DfHKaGs79Eg=;
 b=qPQ6VQzc324hAyvIdU/mVH/Sv0w36ghAYkmqtEpNnnlLgZurRhSPty9kE5i3pLWMEo6cX2YEaitQtozi4LxGB8/JWx3RJ1g5VbKYgHzsRebOQYp400SByF0dsdX2gR6KNr/8qzDYtZJYkhoY34ejKaGN6eJU4sRX3aB3evH0LT4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 05:42:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 05:42:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
Thread-Topic: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
Thread-Index: AQHXK8XMZ3cC8kubzE6EXv8NV9sia6qqG8xw
Date:   Thu, 8 Apr 2021 05:42:35 +0000
Message-ID: <DB8PR04MB6795C5587FB2FF7DB1B40160E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
In-Reply-To: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73dd487c-bebd-4ccd-7443-08d8fa511cd5
x-ms-traffictypediagnostic: DBAPR04MB7430:
x-microsoft-antispam-prvs: <DBAPR04MB74307900CDEB2D6E41812122E6749@DBAPR04MB7430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XPvo3LCyIWdr3iKHqaHstTAFtwPybbNwMKM6Ohaxs4SfU5J4t2kk16lLeVp2Taly0e0g7B72pFvh8MtNd9V/vxkMTJfJTCksSpx8gq9nSTYuwVe6y+iFSE4F6sFy9pmgKwFyv4wXaZEA/AQjkdytD9zJhBtzCMibPHCZJjB2qsX9VszLWwlV4MgEoPMgzwZnKWuedMy1tEH/VFYiZNhSAaxYXQtNPf5Vm+PgcE5ftHwZCH8bsuJyqDBYtg5bXiEf1m/5fFWAS8x0B0Pl6YDqATgPvhxb3iq9VQXAN/pPSsu83knhgf5ecOtSYVkWieE5NYseuUu1ZKBiGRiahK+E6I9QzYb2xLVNtHFqcacjZm9Ma5gj9HkmoQfiZBPG6C6KAR1rO4F5dDL3nvRCgAbwmlSXQXAVxDtquSnKxy8uL7r/ksNO6zsWi6/AzR3hiyORPu0HO4vNR6EFdvbH63RT3vQL2VYvIYMXwiS+3SBqWIP5Gil1sVNrg6hawUVNmyGtJe0pTZalOSlW0n7gzwRi9JSTTFbQh+VckPnlub/5r98AuR4CA8u3gUlE7H9Q/pdhhYV9zjNfbI7WJ5SGMEXMJsWOp7CUi+O472PkjDIi4dqgn8+1KlfrfYrDllPNVwRLt/tdWThOgafUOx3VhYKHGlDr9boUl+hrDVPeGyNpzwA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(66476007)(83380400001)(33656002)(66446008)(53546011)(110136005)(64756008)(5660300002)(86362001)(2906002)(6506007)(71200400001)(7696005)(52536014)(8676002)(186003)(8936002)(66556008)(478600001)(4326008)(66946007)(9686003)(55016002)(26005)(316002)(76116006)(6636002)(38100700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cUs5Y1FsQ1NHNHFFbFFjQWFSNUdScmRoTDNyTWJldFZDcDdvS3c4MkRxZERS?=
 =?utf-8?B?QVR0aVczNFVKL2FuK2lHdUJDUFIrQkp4cGN0MkFENEtiYkJDRStzZVg0akZS?=
 =?utf-8?B?cDA5NENNOVBkeTRTU3VUaXlsYkUwQXlrb3BEMzBtWUNndGNJakhKV2Q4UkR6?=
 =?utf-8?B?T0ZLYXdLSHg2MStJSHdnNzRudlRQNENWTDk2a0VhWmpvMTE5UEZ3aW9BeTZx?=
 =?utf-8?B?QldXWjF1ZlpZdWVZL0ZncmRleW5zSkJXamxta2RUVkpQQTE2SkYxaHNqNnpv?=
 =?utf-8?B?emJTbUJ4UFlXTUR0aFl0dDZCVVFCNWt3T0J4NDhhVVAzZEUzSmN2dWlDZWI2?=
 =?utf-8?B?Z1RheEliUVVKUGg2dWpqM0VXQWlmRlJwOUUvTk1xS3BZdkJobmQ3LytyaS9s?=
 =?utf-8?B?SjdoSGE0Wi85N3UvM0UvMEtWWHBteXlRdE54LzFlSU9zb1JXOFFIbER3OXZH?=
 =?utf-8?B?N3k2MjliWlM4cjFIVCsyb3AxbmNQUjRrWlR6dWN1MWlxaWp5SzYyWVRVaFJI?=
 =?utf-8?B?QVF2amhRSENJQXBIU05rZE9kUzUxc25nVFQ5UWFITzBPRVZVWlhyYVVhZDhq?=
 =?utf-8?B?ZXM1ZzgrY3JHaHR6bThnTEJDQSthSlVhTmttK3FDN2lqTkM3cG5nbC9qVVRV?=
 =?utf-8?B?bHAyU1QzTzBIM0RpdWV5ZGp6RW5SQ0lNUHhGLzlreHhkTWlPUU1WN2VyVFhD?=
 =?utf-8?B?b2pQTDVISWQ3T01mbmtSd3lCL3MzakphaGZrem5odVgvN2ozZGtINlloZHpL?=
 =?utf-8?B?Y1BKNGhURlBoVGszengzaysxdGlBQ3g2RlczTDRZb1diMU1XYTkzeFBoUmNw?=
 =?utf-8?B?MnQ5cytpRnBrQytQVk05QS9jbUZNb2xDMEp6SjM5UU9sSVl4b0xkazhsSlV3?=
 =?utf-8?B?dGtSSUFzSHpMZjRHVUNlcG9xZDErakYwRWZEaFNlaHRCUVMxNE1PRkF3ZHZn?=
 =?utf-8?B?cVdUVnpRbGtCbTgwRHh5L1dBenViUmJFZ3NpQnJiV1VCS1NMVUdyYUgxRlpX?=
 =?utf-8?B?UnhNTEppalB2eFpseGpCclExNDJ3RDRKTTQwa29VeWRsQTRoQUhMK0JySnRC?=
 =?utf-8?B?dThPQ2FncjBWQjA0T2phMC94WWpvQzJ0RlJqRFpobW8yRlc5Mi9kdFMwOGFx?=
 =?utf-8?B?UUExTkdOWEROeWlhdkxxRkJ3NmRRRWMyNm9FZTBQRUdLS2dYK2g1MUZUSEVG?=
 =?utf-8?B?Und0Zmk2M0gvbHEvaDZFL1hRUmM4RE9ScWlYTzFkOWk5cTg0R0phaVBaZ3Nq?=
 =?utf-8?B?cUdEV2hhOWJ0Uks0VDdBaUNHaFlyejYxREhnYXBJM3VCQTdCTEtsLy9zS0dT?=
 =?utf-8?B?NmFCc2k3MFBhOTBaUUNFWUxiRnk3eDJDa2hTTUVVNjVKSERxQ2VOdm1KOU5Y?=
 =?utf-8?B?dCs5NjBzUmgxdVBIZ2YvOG1sMG5BeE9VV0pzNklsTjYwTU9teUxELzNkNXdn?=
 =?utf-8?B?U2laTVJTUkhPMkp3cTBoNWRxRmFxU2U2cncwYndHTFk3K2t4ODdCWnIyellv?=
 =?utf-8?B?VXZ2VGV6TEVqMEtUOGVqb3k1MmtUUnMxeWJ6bkFUa29aZW5wWUFPVEJnbnBx?=
 =?utf-8?B?MWkzSHF0WkJmdWFZYWtNeDdlQkZ3bnZJclNzMC9pM05wMnVCTlF0ZzdXK1o2?=
 =?utf-8?B?THhudis0TUtMMHVWWHI3NHlmVThtTUxQU3c4ME9qWFZxczF0dnpqS2MvdlpW?=
 =?utf-8?B?bWpwbm9kUXZLZzk1cmxpVFpwSjhwak5LcUlTcDZwRWZoa3VZb2IwRG85MUVY?=
 =?utf-8?Q?WBptKErwRvG9/LNlsD/TKLZamWzZHbE3ILoFKzf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73dd487c-bebd-4ccd-7443-08d8fa511cd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 05:42:35.5572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GVb4RYZkoZwjgHXtLTFyCPvBM+szYFxMxlVT+o8Lu8kPbUKk/eCwf7Vooz0aSOgPUJVPI4NqMa+C1hFQko2DUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBIZWluZXIsDQoNCldoeSBub3QgdGFyZ2V0IHRoaXMgcGF0Y2ggc2V0IHRvIG5ldCByZXBv
IGFzIGEgYnVnIGZpeGVzPyBPdGhlcnMgbWF5IGFsc28gc3VmZmVyIGZyb20gdGhpcy4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDog
MjAyMeW5tDTmnIg35pelIDIzOjUxDQo+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
OyBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXgNCj4gPGxpbnV4QGFybWxpbnV4Lm9yZy51az47IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gQ2M6IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5j
b20+DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCAwLzNdIG5ldDogbWFrZSBQSFkgUE0gb3Bz
IGEgbm8tb3AgaWYgTUFDIGRyaXZlcg0KPiBtYW5hZ2VzIFBIWSBQTQ0KPiANCj4gUmVzdW1lIGNh
bGxiYWNrIG9mIHRoZSBQSFkgZHJpdmVyIGlzIGNhbGxlZCBhZnRlciB0aGUgb25lIGZvciB0aGUg
TUFDIGRyaXZlci4NCj4gVGhlIFBIWSBkcml2ZXIgcmVzdW1lIGNhbGxiYWNrIGNhbGxzIHBoeV9p
bml0X2h3KCksIGFuZCB0aGlzIGlzIHBvdGVudGlhbGx5DQo+IHByb2JsZW1hdGljIGlmIHRoZSBN
QUMgZHJpdmVyIGNhbGxzIHBoeV9zdGFydCgpIGluIGl0cyByZXN1bWUgY2FsbGJhY2suIE9uZSBp
c3N1ZQ0KPiB3YXMgcmVwb3J0ZWQgd2l0aCB0aGUgZmVjIGRyaXZlciBhbmQgYSBLU1o4MDgxIFBI
WSB3aGljaCBzZWVtcyB0byBiZWNvbWUNCj4gdW5zdGFibGUgaWYgYSBzb2Z0IHJlc2V0IGlzIHRy
aWdnZXJlZCBkdXJpbmcgYW5lZy4NCj4gDQo+IFRoZSBuZXcgZmxhZyBhbGxvd3MgTUFDIGRyaXZl
cnMgdG8gaW5kaWNhdGUgdGhhdCB0aGV5IHRha2UgY2FyZSBvZg0KPiBzdXNwZW5kaW5nL3Jlc3Vt
aW5nIHRoZSBQSFkuIFRoZW4gdGhlIE1BQyBQTSBjYWxsYmFja3MgY2FuIGhhbmRsZSBhbnkNCj4g
ZGVwZW5kZW5jeSBiZXR3ZWVuIE1BQyBhbmQgUEhZIFBNLg0KPiANCj4gSGVpbmVyIEthbGx3ZWl0
ICgzKToNCj4gICBuZXQ6IHBoeTogbWFrZSBQSFkgUE0gb3BzIGEgbm8tb3AgaWYgTUFDIGRyaXZl
ciBtYW5hZ2VzIFBIWSBQTQ0KPiAgIG5ldDogZmVjOiB1c2UgbWFjLW1hbmFnZWQgUEhZIFBNDQo+
ICAgcjgxNjk6IHVzZSBtYWMtbWFuYWdlZCBQSFkgUE0NCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyB8IDMgKysrDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L3JlYWx0ZWsvcjgxNjlfbWFpbi5jIHwgMyArKysNCj4gIGRyaXZlcnMvbmV0L3BoeS9waHlfZGV2
aWNlLmMgICAgICAgICAgICAgIHwgNiArKysrKysNCj4gIGluY2x1ZGUvbGludXgvcGh5LmggICAg
ICAgICAgICAgICAgICAgICAgIHwgMiArKw0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRp
b25zKCspDQo+IA0KPiAtLQ0KPiAyLjMxLjENCg0K
