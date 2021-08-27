Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0154A3F946A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 08:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbhH0G24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 02:28:56 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:47008
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230456AbhH0G2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 02:28:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W81FC8J6xBDi5I5Yc4TIxMvUQGjtfawypKyll4K/0UvGUMCdhwPi5PyaCAKvRg72tgIxDYZ+vIEk2+0DzuQUOhRKoJa22gII3zpfuG2jJTqYDj/F4rHaMFvtrqynHbzz09QPkdvgemPZsEUr/2sjm3fply6mtmoXnSd8udXWgJ/yzn1yb9oCFIfqugJs91QR/s/6GijWEjnQGfmkH8UwThY1qCX8FND7e5cIMelN6bEXwFhe7Bcvl4MV3PgLDDYelC5XPEy/CUufF8RgUK3rtUdx9D6RaYNGF//ktjhxOxCnpJcmCMcz+iZSfV8MMCyTympI4jN/7CQG+tzobVHHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qghDpSfTTT/98h+sPb+CiW5jJix2/e81zNzM8jwx3Q=;
 b=YglZJuChBfsTC37ZIJ90nC5NLOT6cngZrbTwF02v96fD/3yriE1smiEzTw7rZGzgkJWVQlmsDYk+ZPc87s2/IgR5Ohco826ZiLzREUWIsjnIXbwinF5tCjNt2gIWB426FlnIPUtXE1a7+L3ITWBC1S1kEbe0YsYjIGaz/z+EF6cgYm51U0k/NOB2RyeVImX24+LmpwrdzAkSG8POldYDw5KNO+usdvBs8p1+gt3Jr0dQWAbSyj4+3+EXN/H9GdSXG1Rk5T2WkCze0g06WvrrMENwRdGxYy3TA1RWEdcCzpYDnR39fCLN2D4oaI9s0V1duziIlJS6nLvcFk7VVM00ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qghDpSfTTT/98h+sPb+CiW5jJix2/e81zNzM8jwx3Q=;
 b=c2KgVMQSjoS8L/4g+OpEhGgTC4/MZouNtsnMUt1DhVNiQu4IGQ97tiWSZ5urfv9DMkMKjztzbwIgoNvZNgZo8byQ5EH/eMTKvZtSCa2C/AmDPlIDjImbM7jxiyAOwL3V8BDPH2v9r7mKg58exdcnJ2aVa7sshZLn5abPI2+lPeY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB7018.jpnprd01.prod.outlook.com (2603:1096:604:13a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 06:28:02 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Fri, 27 Aug 2021
 06:28:02 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 08/13] ravb: Factorise ravb_rx function
Thread-Topic: [PATCH net-next 08/13] ravb: Factorise ravb_rx function
Thread-Index: AQHXmX8sXf0DZjE8wEGoiKZgWRONiauGQn2AgACgkyA=
Date:   Fri, 27 Aug 2021 06:28:01 +0000
Message-ID: <OS0PR01MB5922615FBFE033E4AA12112686C89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-9-biju.das.jz@bp.renesas.com>
 <38945153-ae69-2817-91c3-3cec6ac9350d@omp.ru>
In-Reply-To: <38945153-ae69-2817-91c3-3cec6ac9350d@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2288bd57-d5cd-40f2-f0ce-08d96923d244
x-ms-traffictypediagnostic: OSZPR01MB7018:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB7018C6D7714E2B21E84E220D86C89@OSZPR01MB7018.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: haeLMv1/P0J81NtKu5gwleY3oLSqhOGthEX03OuSq9bsxaPlAEjfcbE5G9kLaKxQlHLxEEFBsN2fGmPkOlVi4xXmqRGx4GNZe2dzE2cptK1nlLTZh7LbySj8ZsdFAYtOC/ByIE3MdecSfmvxoKgapIZUbA9vvx2j3Vn4+FMwcdSicg6dCFydKBaIm0oCWYOTe7kyVxJZgg7NU4dLT5aRtCy4pdurBZI3t2YH/m5BFRJngBv8zfwc9Lq0mWWyQj8H0KKoFsv3ErQszS1+C1cH8eyyVzBATb1dbOP00GtoXN3/n6gJT6ktWwFsAficftmjdyAQY5f78LnzHlgUFV4cxGXRmsh+W03XK7WiN7cF8TeX5+/xzbPr5y9uW4MRei3N/LS4VURtnNSjB7fqkzx1jEOqRQ4HQwuIC/WrJPUCO0B1ws3VT9HH09ixbxgEAHiXGqizGKp3c5zr0vkX9Vx3Fp7ERRoj2hqZUHH12C5p0/n4hsA2H40Zvhb+PcDzuAUYvSx5B/KPx9M8yZs6A4kbE3tRYTGxF44wsK9NLuobg+Sp0pSlZ8LzCplBye5/2ImuOKe4k5tZnZHiUKuV/MXcRRROe7EpvUaWepiHdYTZBzg3DZGotbdrvNLxJd9YCCSeFUPcOv3FyOdS05A/xvaBxuET0NOHwiS3OEI/itMpLtnGWeGCqPOobBB+bPqydBexPfj64hSOzsSNE3WsBsmlJJMBPCZVJrFj3s0Ig2aLfhLIvTsQ3FZOobfVIO+8SVIfsS8QjhF5OLYmmHW0tQ5kn6+LPdnLkfACYISo83o8WZk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(71200400001)(83380400001)(7696005)(110136005)(966005)(6506007)(38100700002)(33656002)(508600001)(53546011)(4326008)(66476007)(66446008)(55016002)(76116006)(2906002)(38070700005)(26005)(86362001)(8936002)(8676002)(66556008)(186003)(107886003)(66946007)(9686003)(5660300002)(52536014)(64756008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V212Q2toanNTbXZSVjVRSlhzS0NScU9oTnBBanJKRVVsSFBkUEVxNWl0RzNX?=
 =?utf-8?B?SGdSQnlhaEc3aklHdjdPZ00xemhkaENDTWdxUVZFR3Q0ck1kN2x6Qys2bWY0?=
 =?utf-8?B?bW8wYTEwdTJGdXN1Z3lCSXVUWHAvdVI4b3RQb1hyaCt6M3ozQnNTOGtFS0tN?=
 =?utf-8?B?V3dVdUFKcngvVVdlQjdKQnEvN3oxVm1zdzl4V0lLRGpMN05KUlBzUGsxdFVs?=
 =?utf-8?B?LzB0OUFHK0VhbEtRU0YwaVh5VnBjRXd4UGxjRGprc1BVVnhFbXNEd2FwR0I2?=
 =?utf-8?B?bS9SZUttc1BKdHF5bzhpL0trdmtSNWhVQWtEVG1YZE9adjFCK0R2KzBKbHNM?=
 =?utf-8?B?RTRYWVNrMVIwbTEyeml6Zm4zT1h0SkY5LzZBMmZJVllvTCs0R0JHOWpFZDU0?=
 =?utf-8?B?aGZtRFFkeEZRTFRvbXQ4SEk3U1luY05sbFF6aTduU0JoT3M4cXoxQ3ZiV2Ix?=
 =?utf-8?B?M21qMTI4KzkxUWFpbk0rV1g5UzdhSlF4UG1PSVJZRUpoMzY4M1V6c3NwMjI4?=
 =?utf-8?B?RG5PZW9QbWpjSlFhUjlid2ZhcXBuN0ptcXdXV3JYeW03eGhkbVZoMWxNN3hZ?=
 =?utf-8?B?M3ZhZlRGVzdHU0NHbG45WGNmRVhnS3U4WG9IbGdsVEFVa0ZUaHRUQ0FMek11?=
 =?utf-8?B?NUpBVTdFbVlBdWRMbjdGWVpSMzh0ZXJvR2lHemdHNEowR1JuaGRjeENFcVRH?=
 =?utf-8?B?RUEvcHFEdzR6UzJZSjIxRGVyVVFuR3VCa3Z1MlVNaUsvajhGMHdwSWRGMDE1?=
 =?utf-8?B?MEdqSm1rbXVOcVZlRnBMUHk0R0tJNUpyVGt1SThzSDdIVkNFK1dxbVpkWXZp?=
 =?utf-8?B?dnBQSStFMHVYVWNVd1M0Q1JOSDFiTVdaOTlPVkZZWUljZmk3SmdWUkdqN2Fm?=
 =?utf-8?B?NnJ3TFFWa2FaVGg5WjgrOHBtcy94NHBmWmgyQStMYVUxN3BGbCtCdGtGUTJy?=
 =?utf-8?B?TlJRSDRRQzRYR0U1V1BOSGJ0Z3RSNVdsbnFCODg0U3BveFcrMjFnVzNhMG9t?=
 =?utf-8?B?eHNEZXdzVXl2RVV2dkpTRWZCNVY0SnhTdExYNFVMSjdBQ2tVVHM4bk1KZHNp?=
 =?utf-8?B?SHprb2E2VGkxYUc1bVBYS2xiYi9YMDlydWxMT1ZqTFN5Yk5XVUtsblZMOE52?=
 =?utf-8?B?MEZUZmU2Q1NkTmZ5ZDJ5V2xBeTFsS3FuVnYwdkhWckwybm5GQ1JkbGRsNGtn?=
 =?utf-8?B?SzZPcWVicTFxU2dyUHQwRE9UYVdjdnBsYW5oMXhpQkwwMlJaN1lLZ0ZBWU9G?=
 =?utf-8?B?QlUwTGdDMHAyL0c5d1lybUVyeU9HcHF6NmdoMWc2T0xmYjI4bWhrOWhtQTVm?=
 =?utf-8?B?cGE2dzBxWWxYN1E3MFROcFNja0VIUnVnOFJtd3dtYzcyNjZYc0lacTg4aU14?=
 =?utf-8?B?aFBsaGM2TkhWM0hpc2R0a2MrMjZZdi9aTmlUTncxR2JYVzRwL2VXMGorUWli?=
 =?utf-8?B?eTZ5cTJTZDBjMGZOOVMyQWVsNE01NjJjeUp5L1ZZbE8ycFd6V3VvUVJlTWhD?=
 =?utf-8?B?ekluanFlOWJ4L2p5cUlXWkt5Ky9BTEJqZkg3Y1hlcm92d2drZFludzk1T1VR?=
 =?utf-8?B?SGI1M2ZrR3NhWHZmZHVBdloxam1DODgrd3lyM04xcXB5cmp6eS9jNjN1aDc1?=
 =?utf-8?B?L3BwcENlUTQxOGRoTGdtZzcvaUZQWEQzd0U0VWFPYlRBTDJVSUs3eFlJTnc1?=
 =?utf-8?B?RUhERXZWUmlGMW10UmRpeEpXMlBaN1N1QTRKeVZSTzhjZ2R0ZzE0TDhWaG5n?=
 =?utf-8?Q?lULaAl9TT1jJAy7XMY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2288bd57-d5cd-40f2-f0ce-08d96923d244
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 06:28:01.8805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oV6KbYgc/cxlEvG7yVaFGCd4tFnqt9OPGw3/4FSAvJLnORdMJ1ZXm7c9HMx3OCH6J74T0M/Cof+9Zd578A97CYZwgN1cjYX0TD3iMOFzByY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDgvMTNdIHJhdmI6
IEZhY3RvcmlzZSByYXZiX3J4IGZ1bmN0aW9uDQo+IA0KPiBPbiA4LzI1LzIxIDEwOjAxIEFNLCBC
aWp1IERhcyB3cm90ZToNCj4gDQo+ID4gUi1DYXIgdXNlcyBhbiBleHRlbmRlZCBkZXNjcmlwdG9y
IGluIFJYIHdoZXJlYXMsIFJaL0cyTCB1c2VzIG5vcm1hbA0KPiA+IGRlc2NyaXB0b3IgaW4gUlgu
IEZhY3RvcmlzZSB0aGUgcmF2Yl9yeCBmdW5jdGlvbiB0byBzdXBwb3J0IHRoZSBsYXRlcg0KPiA+
IFNvQy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5y
ZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1h
aGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggMTQ4Yzk3NDQ5OWI0Li4x
Y2FjZTUzMjQyNjEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yl9tYWluLmMNCj4gPiBAQCAtNTYyLDggKzU2Miw3IEBAIHN0YXRpYyB2b2lkIHJhdmJfcnhfY3N1
bShzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiA+ICAJc2tiX3RyaW0oc2tiLCBza2ItPmxlbiAtIHNp
emVvZihfX3N1bTE2KSk7ICB9DQo+ID4NCj4gPiAtLyogUGFja2V0IHJlY2VpdmUgZnVuY3Rpb24g
Zm9yIEV0aGVybmV0IEFWQiAqLyAtc3RhdGljIGJvb2wNCj4gPiByYXZiX3J4KHN0cnVjdCBuZXRf
ZGV2aWNlICpuZGV2LCBpbnQgKnF1b3RhLCBpbnQgcSkNCj4gPiArc3RhdGljIGJvb2wgcmF2Yl9y
Y2FyX3J4KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgKnF1b3RhLCBpbnQgcSkNCj4gDQo+
ICAgIE1obSwgaXNuJ3QgdGhpcyB0b28gbGFyZ2UgYSBmdW5jdGlvbiB0byBkdXBsaWNhdGUgaXQg
YWxsIGZvciBSWi1HMj8NCg0KRm9yIHlvdXIgcmVmZXJlbmNlLCBpdCBpcyBhIGxhcmdlIGNoYW5n
ZS4gU2VlIFsxXS4NClsxXSBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGlu
dXgtcmVuZXNhcy1zb2MvcGF0Y2gvMjAyMTA3MjIxNDEzNTEuMTM2NjgtMTgtYmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20vDQoNCkN1cnJlbnRseSBJIGFtIHdvcmtpbmcgb24gdGhlIG5hbWUgY2hh
bmdlIGFuZCBuZXh0IFJGQyBwYXRjaHNldCBmb3Igc3RhcnRlZCBhZGRpbmcNCkluaXRpYWwgc3Vw
cG9ydCBmb3IgUlovRzIuIEkgYW0gZXhwZWN0aW5nIHlvdXIgdmFsdWFibGUgc3VnZ2VzdGlvbiBv
biB0aGF0IGdyYW51bGFyDQpSRkMgUGF0Y2ggZm9yIFJaL0cyKHJhdmJfcngpIGZ1bmN0aW9uLg0K
DQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
