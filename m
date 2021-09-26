Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC513418A0D
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhIZPxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 11:53:20 -0400
Received: from mail-eopbgr1410104.outbound.protection.outlook.com ([40.107.141.104]:45216
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232020AbhIZPxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 11:53:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YG1pWn6KY55BCaEtc5J0FFHVkCltYw3yuG+Ddd2GMZn6gSf/U+E2LMe0xgT13O0J5ra5seHIqAe9WGfymkx/AIf2H2bbvKV5UyJVr1EEfQeGKAjqBtaKPkrYjoPp/AucTGaD31DV6TQDJ+6YaIWQxPJJ+VCs0chRkxLkmwuby89FPqL4U/xcCNHEj22Ml+lVb3PEi6xE+6Qfmahav7DA7s4+uzQ3EXiSqs+bfGDM/2z2FHctaN1ghjeEdre0l6Iiqi510T8tkpALgVHggvr9RaoiswtPJUEtF/wWT6AwniBXa6nmH0BwhTxsPEQeSzunPUJMrUS8gJoWIAegk/t8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YFKOtOOpq0kHFjLAe5mQkgbDpwn0hUP7uflq2xoFugU=;
 b=GRVpP3lb7G+flioZC3OA/s2/9yxbgInWVEfa/tP1FBUqGDdTU4KeH4PUe+32vv0XESpmff1DwrnASQOIu33HPFvo70p6bKhq2Ei8N5UfZ6clew3V/9nOz8JmQEYV6XoC7pRMf2bTDAiKSyqW7kV7Y0xT/tIGzZlYC+gkabOE9Nfjk+rVMU5CWO4B8LYZm7VW2UKVL0HgWQlJX7wRA42pWZvWVOGTtneQ2k9Il4Nwvx8WPCca8f0lyL6gjbWrs3VzO3DSmvata1yikB1fPVG1Qf+4ITQD//33tjarhvAzNfRiJH3BYKtAvbNAIZoPE05TRa3IH8eqHedb4YCY4XgIUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFKOtOOpq0kHFjLAe5mQkgbDpwn0hUP7uflq2xoFugU=;
 b=egwkKH93/KKzfRf7kr8m41BLOZk1fcnoXVms8ehnaobeN8qurVtvLHOjTFlnj+oHkZEQEEtDiVDzOl/efqh3It8PAop+NT9AhrXtWjBJVmZ3CJdkyWvvt/jEu6fk4sLJf7sHYDuh9fwfq24uhvmNH1M8TypU71yfUmo8upmwOQQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2097.jpnprd01.prod.outlook.com (2603:1096:603:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 15:51:38 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 15:51:38 +0000
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
Subject: RE: [RFC/PATCH 09/18] ravb: Add half_duplex to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 09/18] ravb: Add half_duplex to struct ravb_hw_info
Thread-Index: AQHXsISJy9LH6bM3Z06mQG036IrPmKuznpWAgALcwbA=
Date:   Sun, 26 Sep 2021 15:51:38 +0000
Message-ID: <OS0PR01MB592254EC06E320BC261A2F5086A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-10-biju.das.jz@bp.renesas.com>
 <ef5073e2-ceb6-6b6b-c36d-d13dc7856a4e@omp.ru>
In-Reply-To: <ef5073e2-ceb6-6b6b-c36d-d13dc7856a4e@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58fcfc84-9a39-4e5d-a70f-08d9810586dd
x-ms-traffictypediagnostic: OSAPR01MB2097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2097FC72FF262CD994BFD8FB86A69@OSAPR01MB2097.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6PZl1zYe+Shf8PVziJMx2sniLzhss0MJUo8iX7y8TlNC7u1PEMvE8h1aa8B15+nKDCsC3N1z3cTGNbma7DyAdBcTszUQUZtZJ/VnGmf6LJ78kwYBEmywJv+lQCxywPJjnjbrlJphjvUnba7eF9X3kHo0glganhRZrBPRp2AWbPS8yYxQlnyFqa9cvh/TsyFIpXaeKl1Pl0Zr+3cllZRK2kmIjfenwJYEo5ZBlmXwRhBJXhMg28e7RJ1rkpojxMFzmCmA5uK58cZV9coiLa8KAT3jvVvNZCgZI4+VRmXbsV8dmSyzBe5hbaoDqY5CpJvuedsxgxZBRnA5kCUv+uhWO/Kf+JNMYvGLCqbKjhyhu5LPNeGrnwQRwe9SDOQ6eCp5kCVx4/NDKuhKSIVGHXn6hlKWbcRHGkjcH3B+58fP9Nqj36b4bP+GS/gb/bEv23KH6iMa2JyEIVBxEMz49en6hvrlZOGBLYZIvaXaw4pI69xkKaztS5hrAFsRh7Or3JPktZ35IeIk6cJ4fwoh5PNbEUeFXxA0TG7IgNUaokDmDDMotGbb8i8YE1Js13AU3K7iGbviQ2YhnBMC06uaguN+JJu0t68M6e3V9ZKAUwRBcEcaddoPz8pWJXivZ9lfeCWFkBEvQYdTdvZ/NEByVxCw8k5MUTBnIrefT6epDwrf3J3fjcN7VDhFOwXq7WBurSr3A2iU9byC9N5aZM/AJHvpiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(4326008)(508600001)(33656002)(2906002)(71200400001)(5660300002)(38070700005)(6506007)(8676002)(107886003)(316002)(38100700002)(186003)(76116006)(26005)(8936002)(66946007)(9686003)(53546011)(86362001)(66476007)(64756008)(66446008)(7696005)(122000001)(66556008)(55016002)(54906003)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHV5Y3g4WXRYOFpJLzlaZ1BBSVdFRnNRcjZ6MVg2Y3EyYWZYM0cwWGFKUkJI?=
 =?utf-8?B?QzJMdnZZRHBScEFFSUdWelF0SW4yalBqV2poMDFlMGpHVUt3QmdaZ2ppa3pP?=
 =?utf-8?B?d2lTem82SnM2K3UvL0FpSGhuZnVLTzcxaTBjUTk0Y0IyeDEyQ3J1T3cxUk56?=
 =?utf-8?B?UUtOWnRwSGNQVkNYbGVtL2ZIUGdkTE9TZHlncmloZE9uTFVsZmxlQ3JZNkI1?=
 =?utf-8?B?N05peCtHRzFDYytYbDJvTDRRTllobVNGMlVHRUJEeUR5LzZWSTFNZTAwTFA5?=
 =?utf-8?B?U0tjL0xMcXhqQ2tDeVVibzFhZkRpMWM2c0FvUW4rb0xZZ0pLSjAxNzRaY0s2?=
 =?utf-8?B?cTV2aWJsRktDWUptSU5YMUo0ZnBjQUpleStScklhYkZrNkI0cXErRjhOUlJR?=
 =?utf-8?B?RC83SSs2S1hablBIQUxMM0dyZkJEbGZlUXY1ZmhDRFlqbWp5MjhxYUNKODRj?=
 =?utf-8?B?WjM1Z0FoYk93NUpMYUNQekY4MTdDYjVrVFJJbXc4RFVCeWxsSkdxOTF5Mm95?=
 =?utf-8?B?d2E1RG0wcmtycWNWR3dsRlZSYUVhSzZPTnlGdnpIdXpCWlN1RHVIWlFlMTR0?=
 =?utf-8?B?QUV2WWRudjhWSGF5eGVJQ09aYk5UUGgydDJodU4zQnl2blJmL3VQVUtHTGhI?=
 =?utf-8?B?N2NkbnNpTkNERjVQZllRZG1CNk9xcFlpNHMrYWlVN1c2VUVOYUxKaHdLOHhY?=
 =?utf-8?B?ZEtYaUNyMWhwRndNU3dRT0NGY3VENnI4SFZvQnIzN1NOS3J0SFY5K0lmeVRo?=
 =?utf-8?B?Q1pvajRiNG9maHlkOFZYRXZRaXMvMDBhYXg1WXM5K3VVc0pjdGNuM01sbjc5?=
 =?utf-8?B?ODVRdG9YT3RVZmxGVXNBd0VST0tDSUJTR2VEODJuWHJBKzdNOHpSQW5rUFoy?=
 =?utf-8?B?WFJRRWMxSnN0TW5nQjEwVHVFdkZKeTM5VmVXZGExajVvZUNRbjJ2ZE05TDF6?=
 =?utf-8?B?MVdlSlNYYU9RWHM1dVBoQTlRZVhSWS9hNEpaM1pXU0JiK2F6bFVWNDdDZk8z?=
 =?utf-8?B?RjdqMHh2UEs4QUxlOGdUdmM1ZWRwN1ArZDFsMEIwUmtHaXdGbmZNVUdsZnNO?=
 =?utf-8?B?Tjhha0QvUVgremdPaWZCdkNSRFFPaVhMam1KZkNpU3ErMjNrUElNVnQ3Y3RM?=
 =?utf-8?B?UWhTOFRlKzlXRXQ5eGdTdEdMM3lpM2d3V3VyZjAyd2JNdmRyZEhoV2Y5M0dN?=
 =?utf-8?B?VWZqRllZVGEyeUc3RW1zSU8rV3dmaUZJdEZKOWlzbS9WL0s2SlZYcDhacWxZ?=
 =?utf-8?B?YzRINFRoUDVHKzkxVWZIeFhKVHdkT3ZMMGVZU29ycEZSMjllQ3VLNzJyTWpG?=
 =?utf-8?B?VCtpL3ByQ0liQmtlV0ZYcTJ0ZzhYMmp3d2xRL3N3azh3UVA1MlRGRldOeE0z?=
 =?utf-8?B?bldTYVVzcVg2RW5pcUJzNGI5ZHUzRlplNmxhM1NISVd5WDhTUUtCK04xSkUv?=
 =?utf-8?B?amZ3YndPUTNoU1hxMy8zRldQMWNDall4L2pqWGxGN0pnWjJGRy9Hcng1Ti9J?=
 =?utf-8?B?Z2kvQWduaFRnQUJSSkF2RWtBTTFlRmdZZnNxS2FPUTdDdXg2Zi9IUnphYzNl?=
 =?utf-8?B?UExHM3lVUThwTlozUitDcXBwbGxJTUVLM044TGVRVzNwalUzTzErNkd3WlpO?=
 =?utf-8?B?cnB0dDRZZklRbjMvdDhaNDRSQkJnRTVyR2dMdW9kUzJLd2RUSkV6MENyTGM5?=
 =?utf-8?B?YzFlNlZRYzhYOS81Z1E0WXdVQkttV2R2dFI3VU9DZ04xUVdSeFZkRUpKeXhM?=
 =?utf-8?Q?7FNAq/qrEmE8yA66k6v0WrZ5uK8J0msC4yfALuw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fcfc84-9a39-4e5d-a70f-08d9810586dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 15:51:38.4868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oUA1jNACfE/W5LQENNlAyF9/FGMoZLelLbacVCXu0+o0JNJnBPF0zzpfjhKW3AkloSLCGM7kEzxFDVxM0NHhR0sIRqPteCzrNj/KRSG3zGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDA5LzE4XSByYXZiOiBBZGQg
aGFsZl9kdXBsZXggdG8gc3RydWN0DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOS8yMy8yMSA1
OjA4IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gUlovRzJMIHN1cHBvcnRzIGhhbGYgZHVw
bGV4IG1vZGUuDQo+ID4gQWRkIGEgaGFsZl9kdXBsZXggaHcgZmVhdHVyZSBiaXQgdG8gc3RydWN0
IHJhdmJfaHdfaW5mbyBmb3Igc3VwcG9ydGluZw0KPiA+IGhhbGYgZHVwbGV4IG1vZGUgZm9yIFJa
L0cyTC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5y
ZW5lc2FzLmNvbT4NCj4gWy4uLl0NCj4gDQo+IFJldmlld2VkLWJ5OiBTZXJnZXkgU2h0eWx5b3Yg
PHMuc2h0eWx5b3ZAb21wLnJ1Pg0KPiANCj4gICAgSnVzdCBhIGxpdHRsZSBiaXQgb2YgY2hhbmdl
IG5lZWRlZC4uLg0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IDVkMTg2ODE1ODJiOS4uMDRiZmY0NGI3NjYwIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4g
QEAgLTEwNzYsNiArMTA3NiwxOCBAQCBzdGF0aWMgaW50IHJhdmJfcG9sbChzdHJ1Y3QgbmFwaV9z
dHJ1Y3QgKm5hcGksDQo+IGludCBidWRnZXQpDQo+ID4gIAlyZXR1cm4gYnVkZ2V0IC0gcXVvdGE7
DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCByYXZiX3NldF9kdXBsZXhfcmdldGgoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYpIHsNCj4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYg
PSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiArCXUzMiBlY21yID0gcmF2Yl9yZWFkKG5kZXYsIEVD
TVIpOw0KPiA+ICsNCj4gPiArCWlmIChwcml2LT5kdXBsZXggPiAwKQkvKiBGdWxsICovDQo+ID4g
KwkJZWNtciB8PSAgRUNNUl9ETTsNCj4gPiArCWVsc2UJCQkvKiBIYWxmICovDQo+ID4gKwkJZWNt
ciAmPSB+RUNNUl9ETTsNCj4gPiArCXJhdmJfd3JpdGUobmRldiwgZWNtciwgRUNNUik7DQo+IA0K
PiAgICBJIHRoaW5rIHdlIHNob3VsZCBkbyB0aGF0IGxpa2Ugc2hfZXRoLmM6DQo+IA0KPiAJcmF2
Yl9tb2RpZnkobmRldiwgRUNNUiwgRUNNUl9ETSwgcHJpdi0+ZHVwbGV4ID4gMCA/IEVDTVJfRE0g
OiAwKTsNCj4gDQoNCkkgaGF2ZSBwcmVwYXJlZCBhIHBhdGNoIHdpdGggdGhpcyBjaGFuZ2VzIGFu
ZCBhbHNvIHJlbmFtZWQgdGhlIGZ1bmN0aW9uICJyYXZiX3NldF9kdXBsZXhfcmdldGgiIHRvICIg
cmF2Yl9zZXRfZHVwbGV4X2diZXRoIg0KQXMgeW91IHN1Z2dlc3RlZC4NCg0KUmVnYXJkcywNCkJp
anUNCg==
