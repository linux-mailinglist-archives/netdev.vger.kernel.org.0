Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17E3FA4CD
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhH1Jm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 05:42:26 -0400
Received: from mail-eopbgr1410131.outbound.protection.outlook.com ([40.107.141.131]:46766
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230444AbhH1JmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 05:42:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQK0NeB+X/SQdaUJWAzxdBDN6W68XcF6APg30lNgeYylx/w6hdoJupIApcD5TU1cCLHd6VCuIFUIp97+XsWEGoRVTkooWO9AcGC9JJFKnwIA4fX+axzw3rqPmIO4vuBzcHknztKKl/cKXJgWoSLYCYxsOPTu0fnkgEbEIHtYjrAcCXZAkTbQmLAYJpD+XAmhJTMk+HbJfYrVJ+rW6L32ZnGB9zReA42Xg0FADoUhruDbfhyyYNuOCCIxKBJ4mY6K/kY+VIVowUDezMxQ7W3grgwOV8Izo/7n8rLhPPG/qzMdrXrVdccDdAtjP7wXvAF8aanx9/cxph3k7BMvt2tlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwbgv2liVkJo7MRD6eHP448iUFq7kO1EGEXZO6edQhs=;
 b=VajnW7ztFgBkhM3eZLxyBsxu0gQivhEPq4lbOp6WYdPCvdEAhN4rED3EqqnCdRI36uzGp3CZKKXMZSjS7MsinBId3Mf49lUQz5CZpGEJn5NjIBQzXr6UKo0BF9IsipTenSQnbW0g872W9NApfKYXwxY+G4p2yfgZB5+gajfZADGNYp395WyBhfnNUwxsbQSQTzZP3zIkH2q9D8RIjaRoToouTtOem8hBEqq5Rr2fXl5QPjrR6YxDriPZoKqZy7L93aQaHEV2cBw6MJcpA4hqk5hdKz1kNtBT4oGo9OqvR7iMdA0xJt5r9RTiod6xzhQJVmlLlLOirpdsip3XZyjyDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwbgv2liVkJo7MRD6eHP448iUFq7kO1EGEXZO6edQhs=;
 b=e+8LwRwqoOY87+g6h8z0s4qlaz9c7mvps9PXhec5fXtNA8XB/g6N4WTlvtQvoTGLGRrcM8h02Rv3e8zKIhzo+ksRGf3qfY7ll5tDDiykrGI/Ef7zWxVw3egE3NauQ4VGe0GLhB9Bdy/0aZnq9fQi7I/G58Gr4WhZlMFjc7Q3ZIk=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4804.jpnprd01.prod.outlook.com (2603:1096:604:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sat, 28 Aug
 2021 09:41:27 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%4]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 09:41:27 +0000
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
Subject: RE: [PATCH net-next 13/13] ravb: Add reset support
Thread-Topic: [PATCH net-next 13/13] ravb: Add reset support
Thread-Index: AQHXmX84wUEspOJam0OPHHDOnFoTNquHzgWAgADe05A=
Date:   Sat, 28 Aug 2021 09:41:27 +0000
Message-ID: <OS0PR01MB59220E9CE8125FE4D9D75F2986C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-14-biju.das.jz@bp.renesas.com>
 <3114f468-f454-4289-bc1f-befdadac9994@omp.ru>
In-Reply-To: <3114f468-f454-4289-bc1f-befdadac9994@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90a58274-4cd9-4112-351b-08d96a0801f6
x-ms-traffictypediagnostic: OSAPR01MB4804:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4804B46E943790ED598E138D86C99@OSAPR01MB4804.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: il7cuoLD+AhH1KVLojc/LF4M+yuRB5YA+ZEROBbn9Paud6GVC5/uU1Z5auf9GifhsNLDHKBHwbQ/3TpRWp6eWVG9sOGgrbGckji789uPMup5cAxwz+y9Cuja6sVs4agIYId3BTmf8504DRMHjpGovjY1iroAvuuo+o0RkoNvEmiXqjrUiprFNe2DhySCM5WdKrFUPzgEJnLL3tWru2XSt9VbaOx+9iDycs4w6cbTXqqcZVsiozblHnvTm16PzamY9OzYJytJFKyw+Ip9uBeWD3kLomUEWbKIbcfEqYpvfhp85uLn/G2uK00DeUuOsN570+kfIxxfxthx5NDGJRiUNpeiwBxdGoY1+v6vtppuxs+gjwJ6GmlUID9rl+MhBfUbc76pqy2CDng3Vk3gmAYNbNVJIYb2+gcbNPInTDcpqj8lM0NKmAdOHr5JRCPVOJqcAmicyOj9cD43GZxjUckORBTNduvuK/65mQvnQojgk1hk7AwZJADJuqNuyNh7it26qXNS9B2hz1jUU/fzjBC3Uk8Qn6uWHNjo3MPimgKar26R8ZpUUEUCrvyUL4w2K9sFa0NQUhKWVKKtdsv/c8g3P8oSoJGWMwm7E+HxWODFFvzSudmPtFIFvpPhNxEKRQzZpTSj5WYCAJP7m0u/y3i4aFX1W2W4Fr/i8wYA6uf1vZosjq8dk8k1bamYrvezZnJyos7T4uTbp8Xx3qJbJYq0jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(316002)(186003)(9686003)(53546011)(7696005)(55016002)(5660300002)(478600001)(66946007)(107886003)(38100700002)(2906002)(52536014)(66476007)(110136005)(64756008)(4326008)(66446008)(38070700005)(54906003)(122000001)(26005)(33656002)(71200400001)(86362001)(76116006)(83380400001)(66556008)(8936002)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2hZLy9hTGthTHV0M0Z6MVJuNTdoMGNIYVhycnFJcXg2bkROaUVLWGp2OVNu?=
 =?utf-8?B?UDgwNWJSYWl0VWNpL2JZcmJlb3A1czZMNzhwTmp4alM3ZW9MSGN4R095ejN2?=
 =?utf-8?B?L3JlenQvT0xzV2lib1lVeGNkUkU2MmpTOEs0NVJJQnhmdVRydU1wcWliUTNo?=
 =?utf-8?B?VlpTaFV0eDhXNEV2clU4d0ZpaFdld1VjZ0VHV3h6YVoyY0ZDWFlLbmdxQTVj?=
 =?utf-8?B?UytCeGNCV09saHhyL3lpbThzaWp3bjJPNzJ1ZXZjSDlmMitMTnVEbXROMklS?=
 =?utf-8?B?UG5lSklqNW45MXppdUhtdHVnejV6WU1JZkdScnV0d2c2UlNCdlEzT3RPQXNY?=
 =?utf-8?B?UUtXTXNxNE5LQVIrRmE0VVY2ak56VVRIbmdTRHExckc2MCtvN1VDamE2VkdU?=
 =?utf-8?B?UWNoN1VnTk0vbVU1OGZEQ2xBNjR5ek04by9WdGFLdUpNMkFxcHE2YmtEVnMy?=
 =?utf-8?B?eUdpcVcreEtqQ2pTWDFHdU5sTmFmVHRzQjRNWmM3ZGo4YW81eW1KV2cwWFBu?=
 =?utf-8?B?OHB0cDgvMkdMSW9GK2FtbVhjMVVreW1KL0YvTVF6MjE4cmlyRjByR0dRU2Uy?=
 =?utf-8?B?a3NRbzNNeFNNS2tTY1JuY3NSVUJEdm95NFE5eVU2MTFEdHNNL1dYMWNkeS93?=
 =?utf-8?B?UXhhY2tuWUhYZ1RtdkR5MXNGSk40a0EyLzI2T1Z4STJKQTJwN3pPdlM0dWxH?=
 =?utf-8?B?dk1BbjNoVW80bzAySVQra2NZMloyeHkralVxbjVGdXE1S2pGOU5DNzJMMGFz?=
 =?utf-8?B?RGJtdVVxcVZTaWlLdGowcUkyRksyQ3dvMXBmTUwxdURyVDN4Y1l1anhpa0ZU?=
 =?utf-8?B?aVVScUgvVkpDK0cxZlJRcGdLVWRteVVqSklZVDJ2VnpsWWl5WWlyZVlKS2d2?=
 =?utf-8?B?Um9xZE9iQ1ljQ3VJcmR4WGg2NEhHS09JRTdVYnNLeDRiMXpzTktlcUhWbFZq?=
 =?utf-8?B?SVQyeTRpS3dNQmZiOU91SkV5NTMreU94Wm1HNys0RnJWMkRGcTdTbmozaHBT?=
 =?utf-8?B?eE91SGpnNFR3cEZNZ1hUTU5qTTVYd0Z5eTRBVkcxUTc5TmtHaW04MEFSc3Vv?=
 =?utf-8?B?SEZDbzIwWHRtN0VDOTR4aWpkclc0OHJWeEJPQ0x0MTMwY2FlQXp0Z1FZK3hB?=
 =?utf-8?B?MXJyMG8xUTRzVmtsbjUvUVF2UmJFcWV4OWtQM0N4R2hKZkMzWFBZa29iTUd3?=
 =?utf-8?B?WUZTOTJFenltWk9yRmJJK3JoOUFyWUtwSGRhQXNpaXRCNlNFcnhKaDFHNXdO?=
 =?utf-8?B?cHpMUy9VWDNrelExN0pJMHU3OXkyNnJ3ZVBpMVlXSmNKb0RqZUZLNmpyL3ZX?=
 =?utf-8?B?ckZzSUZJSytOMVBmblhlckZ1OGVpRVVUMXBPR1RoQ0lBaWhqZGNhajdhQVBW?=
 =?utf-8?B?M1ZWNll2VjF4UzA3dG51MU1NS3BWYmlhMmhYK3FMR3dMQXUzUkZSNkNDVmFL?=
 =?utf-8?B?RCtPTHNObkg3YmZZcGs4S1FEUGN3UnRTdHIzaXNLTEFGQytvVXZaWUo1M2x6?=
 =?utf-8?B?Y1l0Nk9ZTUtzd0NzNkNzVEV6Uk9vY29WSUh5Wm5Tb3ErVXMzQXZRMHFFUWVD?=
 =?utf-8?B?ckdvQWRrMFVjVGI2ZTh0akUwbUR3TE9XcHZQNktJMDJnN0JaR1hTVWJXQm8z?=
 =?utf-8?B?VWE5OXY2YW1OaGhmWm11TmVtdFpvVVNkOC9GdHdleUNuS054ai9UV1NMeHdW?=
 =?utf-8?B?SGdMMVU2dXFZR2x2WDJMYmQ4ME4wYmc3WUswbUFpNktCNWpBSTZhWlBwWlRy?=
 =?utf-8?Q?Ny9q9j8igtKBd7R63o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a58274-4cd9-4112-351b-08d96a0801f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 09:41:27.3636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjHq6Hqsklx1VeaRfH8fY8Q54f3LGrDAyaq7M4aExlH0XZQlywWqFG1VJ3iVGOtn/Ibr4tfRchRuQV40N2aXkYTbE/9bj78zij0ZtTCOoqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDEzLzEzXSByYXZiOiBBZGQgcmVzZXQgc3VwcG9ydA0KPiANCj4gT24g
OC8yNS8yMSAxMDowMSBBTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IFJlc2V0IHN1cHBvcnQg
aXMgcHJlc2VudCBvbiBSLUNhci4gTGV0J3Mgc3VwcG9ydCBpdCwgaWYgaXQgaXMNCj4gPiBhdmFp
bGFibGUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAu
cmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5t
YWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IDdhMTQ0YjQ1ZTQxZC4u
MGY4NWYyZDk3YjE4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmJfbWFpbi5jDQo+IFsuLi5dDQo+IA0KPiA+IEBAIC0yMzQ5LDYgKzIzNTgsNyBAQCBzdGF0aWMg
aW50IHJhdmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiA+ICpwZGV2KQ0KPiA+DQo+
ID4gIAlwbV9ydW50aW1lX3B1dCgmcGRldi0+ZGV2KTsNCj4gPiAgCXBtX3J1bnRpbWVfZGlzYWJs
ZSgmcGRldi0+ZGV2KTsNCj4gPiArCXJlc2V0X2NvbnRyb2xfYXNzZXJ0KHJzdGMpOw0KPiA+ICAJ
cmV0dXJuIGVycm9yOw0KPiA+ICB9DQo+ID4NCj4gPiBAQCAtMjM3NCw2ICsyMzg0LDcgQEAgc3Rh
dGljIGludCByYXZiX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+ICpwZGV2KQ0KPiA+
ICAJbmV0aWZfbmFwaV9kZWwoJnByaXYtPm5hcGlbUkFWQl9CRV0pOw0KPiA+ICAJcmF2Yl9tZGlv
X3JlbGVhc2UocHJpdik7DQo+ID4gIAlwbV9ydW50aW1lX2Rpc2FibGUoJnBkZXYtPmRldik7DQo+
ID4gKwlyZXNldF9jb250cm9sX2Fzc2VydChwcml2LT5yc3RjKTsNCj4gPiAgCWZyZWVfbmV0ZGV2
KG5kZXYpOw0KPiA+ICAJcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwgTlVMTCk7DQo+ID4NCj4g
DQo+ICAgIElzIGl0IHBvc3NpYmxlIHRvIGdldCBpbnRvL291dCBvZiByZXNldCBpbiBvcGVuKCkv
Y2xvc2UoKSBtZXRob2RzPw0KDQpObywgUmVhc29uLCBOb3JtYWxseSByZXNldCB3aWxsIGJlIGNh
bGxlZA0KDQoJcmF2Yl9tZGlvX3JlbGVhc2UocHJpdik7DQoJcG1fcnVudGltZV9kaXNhYmxlKCZw
ZGV2LT5kZXYpOw0KCXJlc2V0X2NvbnRyb2xfYXNzZXJ0KHByaXYtPnJzdGMpOw0KDQpBZnRlciBy
ZXNldCBhc3NlcnQsIFdlIHNob3VsZCBub3QgYWNjZXNzIGFueSBSQVZCIHJlZ2lzdGVycywgb3Ro
ZXJ3aXNlIHN5c3RlbSB3aWxsIGhhbmcuDQpUaGVyZSBpcyBhIGhpZ2ggY2hhbmNlIHRoYXQgb3Ro
ZXIgdXNlcnMoZm9yIGVnOi0gbWRpbykgbWF5IGFjY2VzcyByYXZiIHJlZ2lzdGVycyBhbmQgc3lz
dGVtIGhhbmdzLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQoNCj4gICAgT3RoZXJ3aXNlLCBsb29rcyBn
b29kIChJJ20gbm90IG11Y2ggaW50byByZXNldCBoL3cpDQo+IA0KPiBSZXZpZXdlZC1ieTogU2Vy
Z2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
