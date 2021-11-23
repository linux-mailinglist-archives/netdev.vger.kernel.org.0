Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE445A6B5
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhKWPnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:43:18 -0500
Received: from mail-tycjpn01on2093.outbound.protection.outlook.com ([40.107.114.93]:37696
        "EHLO JPN01-TYC-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233462AbhKWPnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 10:43:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmIHKTEeujLMVLzHbNxUUZX/SgKQtsOVEEqW+UWVNCLUEZdYngEEWnigvcrF29K+2gyhp2xt2Sbpz0Q7zuQutTrOf205hzxNG/hKJ8MUod5ZgsBouSQAhz9cHgEsEVbkSNE8nA10JB4wdveFAcUq5FOtktdWTFoDmdFVhY0IjaSMMhqKa/0g6MkOVTfKkMYg7wLNjmwGzCQxzGqO2+kc4grstc3fQtihMpUJ4ttz6dlxzOeMC/Rc/fLZx4MSCPjk+zesxlJQ0msmwuV1o7MVxq4/rwvnUGQRj+Yp1ZwpeiaJVOJ04Zb6QoIZLVdtFeTsOLL5o52o61VJaZ6htlgPfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g402sIT9/Zk227DSsYxF/NzIo0aJ6oCm8JGRLQo6Mac=;
 b=Rbz4KDo4SWhYHnb/xvvkgbE0SYOkiqIHGq5od9KGWpQp550RThNyUDT7sViddMIY1gKDzUNpcAfhvJ5/eSVkdrw70UrSYxCvTK64S9+XfWOaMIPmpise1ykL+oI6FydDEshNmAbkFf24QN8l8BCB9986e7rUTuP4jFKj9XsUf8CEypo24FPZG1s0jHTWDaNOSB8Hlb8iL6aB4AgD/0zktwWVhb7TTpzfwfykBh5pB+tPh523gImxaXJ8eInxdeGx0uugcerZBLsMpQWhsM9HgcoEcr6Q0EfMfyH15H2frC6JwGnUBikX2eAVwgGbAEUoiJFWowHNV3FlZCBcBMeO7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g402sIT9/Zk227DSsYxF/NzIo0aJ6oCm8JGRLQo6Mac=;
 b=haUJzhgspCRdOPVPzQZMt0x2dJ5Mt0YWzpAr8o0TKtq+vS84IIE+CuPw5APwe+aZ+xvKgf9frJ1lwBFnh4/1aHjjMdvzeT64vW7AYKMnym9x3uaoQU8c2gZQcUHS668PhonA/7MX0g+Sqv6Hlv6wwRfkkGagccu9Lm9y1RghEcA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5956.jpnprd01.prod.outlook.com (2603:1096:604:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 15:40:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153%9]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 15:40:06 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC 0/2] Add Rx checksum offload support
Thread-Topic: [RFC 0/2] Add Rx checksum offload support
Thread-Index: AQHX4G6BPnL1RhDFrUy043gm2E9zIawRN2YAgAAGeFA=
Date:   Tue, 23 Nov 2021 15:40:06 +0000
Message-ID: <OS0PR01MB5922BE719B872BAC734A1A7E86609@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
 <b43b2323-e83f-209b-bdff-33c6800d27e3@omp.ru>
In-Reply-To: <b43b2323-e83f-209b-bdff-33c6800d27e3@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58603b72-3259-4911-154d-08d9ae978684
x-ms-traffictypediagnostic: OS0PR01MB5956:
x-microsoft-antispam-prvs: <OS0PR01MB595666DCB649DC1A8C976E0D86609@OS0PR01MB5956.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZUzo4d/K5fVZWI7Vhf1ZzU+7MXQweEJRb1DlytXKJU7wqlnatyiPI7fsooH0eelQPXgqnmsJ/D3iLZCjpIGacEMS1lqfGyAz1oxMBDTQ2y3i2oX6MqNgtOioOQwS3Ibv3RjXGMnaoccor1sEpOL8Q+y9eAmdJux6EjanlAYlytdKjgakBxdAejll0hirRmbsECllxB12LHedkIacn2tGzWNLBhavaSbQXy7IAFAHP+K/384AJeMPEwqEifT3JVvZv2X6prprk44jkwTT3Y2zKd3/LfCLnuPrbZNAe1gasojpLNR7Vx8ai+noGV3HQj/umrvEYJ2pjAqdNe8wKvhyA1glNgIg8jz3dnVzUpMICKe+YabD2f+31doOVNSAP2xVJYNndHI/OKUcloXaAxpDrBsEK+6c649CaVjiOzbhZwLByjkLDIapQhQcd0+0CVsTFje/nv7m8nG1384WKemriGFlSFXYU2+IuL26v05RK5ZmuJXMXLj37UytMpnlhMNGxYadatssqrEJfw+axEYjIwnP0E+xpBFCK60HRnOu1U/Ar0giReb4FKRuvJwRj08VByimjyx/YrKmkdO7VnHZSROWOeNQ4tzjGiMt7p8RUhBnfNQKKpNMnJ2G5BV4ARhXKtHtCIL7bJkiJt+lUPiRqPqYqnRx8O34XvbTCInvCML3h8fsoqK3RBrrUep8gnPe70uFn0o/WZPJ3E/UaSvh7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(8676002)(66946007)(2906002)(33656002)(122000001)(86362001)(110136005)(54906003)(66476007)(83380400001)(9686003)(107886003)(316002)(66556008)(64756008)(66446008)(186003)(4326008)(38100700002)(5660300002)(26005)(7696005)(53546011)(6506007)(38070700005)(71200400001)(52536014)(55016003)(508600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmUvdC9YSnR3Wkhoc1VUc21xYngxMDVpZzdTNjIyTFlRQzViV1hYKzRUMVJY?=
 =?utf-8?B?YnluUnVTR0NoQmhqc20vcU1wSkNYL2NaOC90ak9pdTBaQ3hUZTJ1ZzE2Tmtw?=
 =?utf-8?B?cnliK2UyNllZbnhSYUl0QVpESWQ0ZnY5aHRUTmZUZzZUSUthTjc5QXJYd095?=
 =?utf-8?B?ZmQ4SmxTL3liMGl1NTNnVXdjaVBBVVpuS0NreGpRbE5DU3AxNTR2emxOOVFs?=
 =?utf-8?B?UWIrUzhLZDdMNVNoMzVxVHROQTBpUW5lVFl5MjZGYVdSUVllQ1NxTmhEMUlF?=
 =?utf-8?B?Z2xRcElDNzVWZi9FTkF0SzBCSWJtREpXK0VkZ1dPZll3bmE4WlJTV2c5T0dD?=
 =?utf-8?B?VUliZXRqTUJXNXJidHVlcElUcEFXNHNNciswWVRDQXA5OEVJMHdsdXg0WTNH?=
 =?utf-8?B?YkEzOTZmdU9hMWc5cmhNLzFXcmdkYi9zalFLQlFlZWFNN2Z4T25FTEJzTjdm?=
 =?utf-8?B?Z2xCZXJZYjhQS0R0OUExRWlhWHFsWDFWcDVCL28vUEFyMG01Q3diWktpbTNE?=
 =?utf-8?B?R2Erak5zUnNmU2hWdXNBOG11YmV2S3FhaHZ4SXVhRE8waW5WMVhtRnlVQTla?=
 =?utf-8?B?UVlrQjY4YUxaNnc2SUU1NHpaNWNYWDdZQXMxbFhRRTgrQVZwY1d1QjROOFpQ?=
 =?utf-8?B?OU8xdUgvWlU1WlBaM01VYzRzZFVsZm9XRlREMjF5eHlKNFJKSlNBWFNWM0gx?=
 =?utf-8?B?ZTcxbXl4cUpUc0FtSmc2ZENORWlaVm5GdEE5bnQzaXdMcHZmTS85cFJJcW5q?=
 =?utf-8?B?ejJoRlhpaXorTFRJUWRROGpSYTlPTVFGekxUU2FXdTA2VXgzZmp5eXJ0OUR2?=
 =?utf-8?B?M0J3Y0llNGZFWVdPUTNjZHhyeDlpT0xubCtlZW9WS2c3K281amUvWlBJWW5I?=
 =?utf-8?B?cElSS295YkhlT0tpSGRzZ3FFS3FFUktxSnFMMGY0UnRpd2pPTlZTMVNhNTYw?=
 =?utf-8?B?THVEcEp4bk5JTDMzWWM2WHdLMXF3S0NuSCtqSWRNMWRVOVFmTjV6MEVKcFZR?=
 =?utf-8?B?ZzY3YzluandTemJWbWs1M1pJeXRYNXpOUjdDaHFoWG9ndXc1bUJvQ1ZIRGdG?=
 =?utf-8?B?Zm1waTZTS0dLNW9ldDNXTEl5MDNOMFoyREFXWlJqUnFPTmx0M2F4UEt1dzVq?=
 =?utf-8?B?WlVMRUNyazIySEQ3QTJ2MVdtVk5sMWFLeHI3QVpKdlE4NVJTSnc5dzVFVEsv?=
 =?utf-8?B?SkNMczNqMTFNOG13VHdLb3lRNWo4N1UzQkpGS21tVmtKQ2x1dHNHZXBlTmdH?=
 =?utf-8?B?dFdFUkw5bklwSXhuRUludHQrWVltRnpRN0pFWVdJbFdpRStWZzlaZTFSbkVn?=
 =?utf-8?B?WDgySHYxZ3grdjhITldOT0xWSWo2WThaK3NZRkpyK1JhWExrbU00QnpRdWtT?=
 =?utf-8?B?QVVYYi8wRnFyZDRPU05PRDFwMUM1V2lYRmZDMmFQdERzaFhrdHhhZERaa1FY?=
 =?utf-8?B?eVptSEhNRy9ZTlQrdHZROTdVN3hVOWRQd21xV2h6NFhkWjQwWUdvamFIVE1p?=
 =?utf-8?B?ZnczdUFvNmpEc3BtWTZ3OHpqNDdpRFFpcHU4ajZ6T3lHQWN6WW1mdTBGRDBK?=
 =?utf-8?B?Sk1odkZaZW9Ed2d6T0RjSDg0SkNjVy9XZVZTektSeU45czZreHlLcnBWK0NH?=
 =?utf-8?B?TFBrUGJUck14Sk5FZGxITWhXOUFub2xnSVBiR2N0VUo5UWtvaGc3WS83S2pn?=
 =?utf-8?B?M1VKYS9DdW50N3IvMVhqbjM3bmk5ZGg3ZjI5VnRNaFVhSE5YSHdyc05OZHpM?=
 =?utf-8?B?blhlZVJYbkZlWTRoZVljMDY3M3M2RFVNNkhRZnpUQStEbXFKdDc4K3Q5Y0VJ?=
 =?utf-8?B?Q3Jha0lGUTZYbEdPWDZXbUoxcHFscXhQeE45bnViMUF1em5KZzNORk1LS3Vl?=
 =?utf-8?B?Z3J2Y0tuQTIyWWEwVi9xQ1hBQWVoN1pWMHdxV2tyNGVVREQ3VGZkMkNSck5s?=
 =?utf-8?B?bkV0TVNrOGN4SzRqaFNEQkV6dVhMMFJUQURsRW1HdVIxdnN2Zm5zQXcwMGNW?=
 =?utf-8?B?bzBTREk5dmw0Kzhzc00rZlQ1MlhpNlo5ZTIzdVBiUjNzWEovQ056MkZVNyts?=
 =?utf-8?B?citKaURVQmJsd3VTSlROTFVzNGJsT2NWSUJDbjVkbUxXNldscE9EaldaZktM?=
 =?utf-8?B?NUdiTWx5YlFKUlFvVitzWUpVdmZvS3Q2WEpNdjNHTFZZSFhIMjhSZ2llTitM?=
 =?utf-8?B?UXhKcnZyOWVqbkRDYXl6UFdCRWJJRVVrRVpobFJtYjlHTnk0dnY4ZjhZRHdK?=
 =?utf-8?B?aVMySHJaRHFHZnJhZVNQeDdpdHFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58603b72-3259-4911-154d-08d9ae978684
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 15:40:06.7075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQh6M1uAaBVpTZ+RvmSZ4HAwzi/1XpaIF/G35igIlnmZ5aTHCilGGhOZObNXPRv5fethw5o/vKihRZZDKeE/rdL4+iX4VLR4nBS6ixc8hWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5IFNodHlseW92LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDAvMl0gQWRkIFJ4IGNo
ZWNrc3VtIG9mZmxvYWQgc3VwcG9ydA0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiAyMy4xMS4yMDIx
IDE2OjMxLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVE9FIGhhcyBodyBzdXBwb3J0IGZvciBj
YWxjdWxhdGluZyBJUCBoZWFkZXIgY2hlY2t1bSBmb3IgSVBWNCBhbmQNCj4gDQo+ICAgICBodyA9
PSBoYXJkd2FyZT8gQW5kIGNoZWNrc3VtLiA6LSkNCg0KT29wcyB0eXBvLiBNeSBtaXN0YWtlLg0K
DQo+IA0KPiA+IFRDUC9VRFAvSUNNUCBjaGVja3N1bSBmb3IgYm90aCBJUFY0IGFuZCBJUFY2Lg0K
PiA+DQo+ID4gVGhpcyBwYXRjaCBzZXJpZXMgYWltcyB0byBhZGRzIFJ4IGNoZWNrc3VtIG9mZmxv
YWQgc3VwcG9ydGVkIGJ5IFRPRS4NCj4gPg0KPiA+IEZvciBSWCwgVGhlIHJlc3VsdCBvZiBjaGVj
a3N1bSBjYWxjdWxhdGlvbiBpcyBhdHRhY2hlZCB0byBsYXN0IDRieXRlDQo+ID4gb2YgZXRoZXJu
ZXQgZnJhbWVzLiBGaXJzdCAyYnl0ZXMgaXMgcmVzdWx0IG9mIElQVjQgaGVhZGVyIGNoZWNrc3Vt
IGFuZA0KPiA+IG5leHQgMiBieXRlcyBpcyBUQ1AvVURQL0lDTVAuDQo+ID4NCj4gPiBpZiBmcmFt
ZSBkb2VzIG5vdCBoYXZlIGVycm9yICIwMDAwIiBhdHRhY2hlZCB0byBjaGVja3N1bSBjYWxjdWxh
dGlvbg0KPiA+IHJlc3VsdC4gRm9yIHVuc3VwcG9ydGVkIGZyYW1lcyAiZmZmZiIgaXMgYXR0YWNo
ZWQgdG8gY2hlY2tzdW0NCj4gPiBjYWxjdWxhdGlvbiByZXN1bHQuIENhc2VzIGxpa2UgSVBWNiwg
SVBWNCBoZWFkZXIgaXMgYWx3YXlzIHNldCB0bw0KPiAiRkZGRiIuDQo+IA0KPiAgICAgWW91IGp1
c3Qgc2FpZCBJUHY0IGhlYWRlciBjaGVja3N1bSBpcyBzdXBwb3J0ZWQ/DQoNClllcyB5b3UgYXJl
IGNvcnJlY3QuIA0KDQpmb3IgSVBWNCwgSVB2NCBoZWFkZXIgY2hlY2tzdW0gaXMgc3VwcG9ydGVk
LiBJZiBpdCBpcyBzdXBwb3J0ZWQgY2FzZSBhbmQgbm8gZXJyb3INCiAgICAgICAgICB0aGUgcmVz
dWx0IGlzIHNldCB0byAiMDAwMCIgYnkgdGhlIGhhcmR3YXJlLg0KDQpXaGVyZSBhcyBmb3IgSVB2
NiwgSVBWNCBoZWFkZXIgaXMgdW5zdXBwb3J0ZWQgY2FzZSwNCiAgICAgICAgc28gdGhlIHJlc3Vs
dCBpcyBhbHdheXMgc2V0IHRvICJmZmZmIiBieSB0aGUgaGFyZHdhcmUNCg0KQ2hlZXJzLA0KQmlq
dQ0KPiANCj4gPiB3ZSBjYW4gdGVzdCB0aGlzIGZ1bmN0aW9uYWxpdHkgYnkgdGhlIGJlbG93IGNv
bW1hbmRzDQo+ID4NCj4gPiBldGh0b29sIC1LIGV0aDAgcnggb24gLS0+IHRvIHR1cm4gb24gUngg
Y2hlY2tzdW0gb2ZmbG9hZCBldGh0b29sIC1LDQo+ID4gZXRoMCByeCBvZmYgLS0+IHRvIHR1cm4g
b2ZmIFJ4IGNoZWNrc3VtIG9mZmxvYWQNCj4gPg0KPiA+IEJpanUgRGFzICgyKToNCj4gPiAgICBy
YXZiOiBGaWxsdXAgcmF2Yl9zZXRfZmVhdHVyZXNfZ2JldGgoKSBzdHViDQo+ID4gICAgcmF2Yjog
QWRkIFJ4IGNoZWNrc3VtIG9mZmxvYWQgc3VwcG9ydA0KPiA+DQo+ID4gICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMjAgKysrKysrKysrDQo+ID4gICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgNTUgKysrKysrKysrKysrKysrKysr
KysrKystDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDc0IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4gDQo+ICAgICBEYXZlLCBKYWt1YiwgSSdsbCB0cnkgcmV2aWV3aW5nIHRoZXNlIGxh
dGVyIHRvZGF5Lg0KPiANCj4gTUJSLCBTZXJnZXkNCg==
