Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7213DB375
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhG3GV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:21:56 -0400
Received: from mail-eopbgr1410099.outbound.protection.outlook.com ([40.107.141.99]:54080
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237427AbhG3GVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 02:21:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAi3e1/9nSkg+qcOWTiDjAr+0JluBtTQgcQLB0mGaHcW/VCmGvWfKJfjPY9gvTj5GXGbbxBXr1uaM3EAFJemWDUK0CFxDkuoYcnmItTeGmND2nzAJCT8l34LoJ3Q/IitCeSYFscLvmJFFRz35rO7GpW7l4SJIwTZVmCTCPV4gQS6rzj4YJtcC6F8qg3XFxCBVushey9kHbeRdaVbx+sQLJDaonDzFsJCRA91M6zyWy1qHKBGFyqv51DVpPEEVpqcZV7DZCFxcoNBuhZfaD0bnSGFuqu0opUKLf3gt/VLqdycdo8+bGjplNxKlD4Ebvk0ywLo5UZcF9OGlwpXf9xLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbph8Gvn4JRiWsEYNCzWPdxZNpG1x8lOzAE65OxkijA=;
 b=R/eViyPPaYaoFjINfEo9RTxmBkuk3OejS16FRt/U+b3sieymf7j4JczdpFOMcEyQgwryJJgRNNDC1qOZzQVipboHxguAMkTq3Kkg/9z0wgjuuQd0hLObYSshWA0XPLMSz1uSI3uAcm/x4psjCAiiOWXTox35KzEmBesemYWGNW5R4stloh1vzyP0CLzPglwb+KN03Zi/+nYpgdQDh/NRnl/57Qn1re00u8fhJXw8zDAcYu2D+yKAYIiYrBgKZgk+vtIvAsCgk/iCYBZNmaQCbOioqPgo0umZUkl/5YLp5dNfoO5ttjp8tSOy2fX5S3qwiWe6Pw6oymQj3WUGl+XOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbph8Gvn4JRiWsEYNCzWPdxZNpG1x8lOzAE65OxkijA=;
 b=heUsSmOXZRrpwc1FBDwX2yirb57fDIFCdKHnEXrGxMVuyzPlQ4nsT4+cvRKVcKlrCWMg9YrxcNPtKVDO+g8yBGkqOg4RBfDfBx1F8Z8L5PuzaXCe2nd0sD5fJ1QLQRqX3Oo2KzLa/NJNGSRr9iSQr6/wtXSxN0CPwpZgVpOMIco=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSYPR01MB5461.jpnprd01.prod.outlook.com (2603:1096:604:8e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 06:21:46 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 06:21:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
Thread-Topic: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
Thread-Index: AQHXfwPjvuoODNA+h0GIn7mNUk+qV6taSdWAgADKeAA=
Date:   Fri, 30 Jul 2021 06:21:45 +0000
Message-ID: <OS0PR01MB59223D88215676866ABD813586EC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-10-biju.das.jz@bp.renesas.com>
 <a0d1bb7e-0e0a-8237-c30a-e4533b5580dd@gmail.com>
In-Reply-To: <a0d1bb7e-0e0a-8237-c30a-e4533b5580dd@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4d91b60-2b2a-45fb-1ff1-08d953224e92
x-ms-traffictypediagnostic: OSYPR01MB5461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSYPR01MB5461C4F16F0729DD1123319486EC9@OSYPR01MB5461.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e+BMeTFK4CqK5eO3q8Agb6ZfhuuZjlgK3BAPeDEWIBWkWoeeoKdHEHP3haU1sxKLyfPCB5lVXms5ISu7eNXVqy9fDNR/Ob+5i+WSVFXXVwMQr8C1bmqE2Ziv0k7bUyma23K4cWWzvvhwXZ1uWazrs1wymtr+ydG82B+PRfpN5Rqjdn4ogG6YXdCCubyG3aWetVV6eFJB/eKZLgCCWtKSUBPm7G44AycPT2y0is3Q9+SvMNa3+wDfIcw+m1WXlUyF2WB1Idn3YITo7aN8hI+3FrY2bzO/nMugXv/G4y7X0rhXVHMJmOFGndfMHBZPdCBrwwkezENm/mTSjBj4bLtSZfrtGwHP6WnEoHvpgN7BSh9gMTr/BOXVkipV3UqpISvFJ3gV1/e0tY2sww3QqFYMQfmzJ7Gh7xWvvNkc0p+E4m1gryHlLGQomXa1l+SNsG2EhgYFOB/WOAwsSoe3IqV23WLVEFI/7v098QuE85+krDt/Bj1gnkk08xhr4j3UU+gv7T1QSlqKfcJZzgK1+lplVcOS1GjeUsZ9GAZQA5ufjGey1jZC45qQeEExWzOIIPNdp95wvBcONzKasiDKO3+pSTPg7UCWxZA0ZonubJ0GgZ1XQs9ZxhBXcM3LTm+9SiCRC9WpmXbthHU4SRjRkFjN1WEAOnMmnvtJR0EBs/T9xtwSdLaUek/J6IxAymlTNRCH9piaNtz9dTIjgHntdKmalQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(52536014)(38070700005)(122000001)(38100700002)(7696005)(33656002)(71200400001)(83380400001)(64756008)(66446008)(76116006)(8676002)(66476007)(66946007)(8936002)(66556008)(478600001)(7416002)(2906002)(9686003)(107886003)(55016002)(86362001)(316002)(26005)(53546011)(54906003)(5660300002)(6506007)(110136005)(186003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djFIZ1VKSTR3MGpsL210Rk5wdVdKempuQ0hrclQ3ZC9rSUVqc3U2MjhoNStT?=
 =?utf-8?B?S2lFbnR4eUF5T0ZPSHNCdUVjS1hvMURYWTE4U2ZlMXZYNTkvTDgzMGFsTHdX?=
 =?utf-8?B?RTJRVVNPd0lNYWJHRzhaalFTQXljOTFvWmNyVXZ6NGJLYzVqWFlLY05OMkZj?=
 =?utf-8?B?dmkwdStJdW1DQXBaS29rWDJpYXM4UzRuWVo2S0gwb0hzUWl1ZHVieWJJUCt4?=
 =?utf-8?B?eGZFK2tyN1RBaTJZeWtMVXU5eWJvUDJKVjJQajRJaUtyVHNQb1ZOS0Yva3Jy?=
 =?utf-8?B?Qlo0WmpiVlJwY1g3TFRxeGw5bzR2Z1F4SElVaEtWYk1xUSs2S1Z2ZnlNYlox?=
 =?utf-8?B?UC9ISU9RSm5URTJwRFdJTHRRb1VpWHkrU3ZoMVcya0xwU1RaYlRGVXZodFVZ?=
 =?utf-8?B?YUxLdGJKS0hNUWtjVG5KbUV1a1NjZ1R4M0Z4ZUpJWGQyR2MrOS9nbHJ3SXVQ?=
 =?utf-8?B?TWlUeHBTdUo1bWl1TFZYd3ZhaXRQVERhTUpESENyT3ZHajhBVklaMzc3azF6?=
 =?utf-8?B?T1lxVGx6ZUlCY0xnblZLcGRROWM4UGhRZFowcXJqM1NqcnNoRjRDRnY5NU93?=
 =?utf-8?B?bmlUa3hMbStaNEtMa3IyM3N2OVF0a2tKQmlXTlk5ZU0wQUpMWUJ2VERHMFBp?=
 =?utf-8?B?S3NMbHpYUGcvK0cvKzVBRFdsVjBEQXhyWk5PM3hOUnE2RGRtSHBCbThVcEZ3?=
 =?utf-8?B?OXdXOW1kclR5aUwyWVhWTWRaVGptem5UNmI4MGNIKy8rYmlZcUg0WlVmL0xw?=
 =?utf-8?B?OUM4cW9VaG9qWmlTQ2h5MTZRaEZYU0hpZzVjRVBTZ3VSNnlnVTYwZGl2cWNt?=
 =?utf-8?B?cEpMdzFEY2ZBa2xoWE5wajl3ODkydHZERkFNeW1TY2pMME5rbWovcjF3aGg3?=
 =?utf-8?B?ZkVTTTh1Z05oRW56NmVQclFqU3p4MnZENkV3SzJabEc2TVRJaVZSSmExYWh4?=
 =?utf-8?B?a2M1UFBzLzMyV2hCNWN6OUZGNnFBOGNpbDBnMTZJQUZtUUdzZkc4ZThxQ1VD?=
 =?utf-8?B?cXRKRWZ5NG5mbkZEN2dWOVFlV1QrUHE2aU1oeWRTNUszV0pwa2R5ODVkaXQ4?=
 =?utf-8?B?K2Y3U2ZJOEV2eWZ5VVZkOGRISDl3UStjWldOTC85WDJSd1d5YjQ2N1JmcU1v?=
 =?utf-8?B?UEdDcEozcFZhb2NldkdvWFNqWHAzZmc1cmNqcG5YbFJtdCsrYVFzS2RPTEEz?=
 =?utf-8?B?R1B6aFdsS2xSSnQ4Mzdwd0JveVVrY1h6bFNCQlR4M3djbncrdFBsZEpsOGhq?=
 =?utf-8?B?alVyTDM1dk5PQVNSdVF6U3NhNmZydkY3RjJxM1ZQeFRQSmNTRTlyRElDNWh0?=
 =?utf-8?B?c3BmWFVBNjJSaXdIRXpFOVFNVXBhL0txRlE0N0VqR3FmZzExZXRDUnQrTWNz?=
 =?utf-8?B?UWhSY1ljcmsrYkNFbHh4ZStxNERwRzIwSTY3TTJCaGJWMkdmT2REZHYwL0kz?=
 =?utf-8?B?dlVGZXNXMHY2SUJiUjllQWZaenFmbllVTTBTRzJvc3FEemc4SnNlVnBvWjI1?=
 =?utf-8?B?TExZdXgrc2NPbUxobzhPUEJKRjF1WE1zV1g5djJCbnJkaEZOSTNvaHJSSFpZ?=
 =?utf-8?B?aTIzNTliUFhmUXZLZU5MbkVCTGRXSjZKWnNiditSRFVrK0U1Sy96REdxU1N5?=
 =?utf-8?B?SHM4dXp3YXlyMDV5ZjhFcVlWWUNLcGczSi8yUkh0WW9xTXY2T01zUGE4RU5v?=
 =?utf-8?B?NXVJcTVLUDE5WXYwdzUreEl0eFpyZHpGa0kwQktyQmppZTZLVGJ1cUxvR0hK?=
 =?utf-8?Q?8fgKMCBK8Us8Cry+f3gHploN9UHrZpEwlq4WKda?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d91b60-2b2a-45fb-1ff1-08d953224e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 06:21:45.9020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: psC07vD9+35m9uSBUX4DJtX+jcMJcYlh/2EIPIZ+N+pQQmWHslscR01VjsRDaygE8GVk5ZN1roMOHEHRpfbmH2TKMY0E7Cej2QjFN6jrPF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDA5LzE4XSByYXZiOiBGYWN0b3Jpc2UgcmF2Yl9yaW5nX2ZyZWUNCj4g
ZnVuY3Rpb24NCj4gDQo+IEhlbGxvIQ0KPiANCj4gT24gNy8yMi8yMSA1OjEzIFBNLCBCaWp1IERh
cyB3cm90ZToNCj4gDQo+ID4gRXh0ZW5kZWQgZGVzY3JpcHRvciBzdXBwb3J0IGluIFJYIGlzIGF2
YWlsYWJsZSBmb3IgUi1DYXIgd2hlcmUgYXMgaXQNCj4gPiBpcyBhIG5vcm1hbCBkZXNjcmlwdG9y
IGZvciBSWi9HMkwuIEZhY3RvcmlzZSByYXZiX3JpbmdfZnJlZSBmdW5jdGlvbg0KPiA+IHNvIHRo
YXQgaXQgY2FuIHN1cHBvcnQgbGF0ZXIgU29DLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlq
dSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQg
UHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4g
LS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgNSAr
KysNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDQ5DQo+
ID4gKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzcgaW5z
ZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggYTQ3NGVkNjhkYjIyLi4zYTljZjZlODY3MWEgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC05ODgsNyAr
OTg4LDEyIEBAIGVudW0gcmF2Yl9jaGlwX2lkIHsNCj4gPiAgCVJDQVJfR0VOMywNCj4gPiAgfTsN
Cj4gPg0KPiA+ICtzdHJ1Y3QgcmF2Yl9vcHMgew0KPiA+ICsJdm9pZCAoKnJpbmdfZnJlZSkoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKTsNCj4gDQo+ICAgIEhtbSwgd2h5IG5vdCBzdG9y
ZSBpdCByaWdodCBpbiB0aGUgKnN0cnVjdCogcmF2Yl9kcnZfZGF0YT8NCg0KT0suDQoNCj4gDQo+
ID4gK307DQo+ID4gKw0KPiA+ICBzdHJ1Y3QgcmF2Yl9kcnZfZGF0YSB7DQo+ID4gKwljb25zdCBz
dHJ1Y3QgcmF2Yl9vcHMgKnJhdmJfb3BzOw0KPiA+ICAJbmV0ZGV2X2ZlYXR1cmVzX3QgbmV0X2Zl
YXR1cmVzOw0KPiA+ICAJbmV0ZGV2X2ZlYXR1cmVzX3QgbmV0X2h3X2ZlYXR1cmVzOw0KPiA+ICAJ
Y29uc3QgY2hhciAoKmdzdHJpbmdzX3N0YXRzKVtFVEhfR1NUUklOR19MRU5dOw0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggNGVmMjU2
NTUzNGQyLi5hM2I4YjI0M2ZkNTQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBAQCAtMjQ3LDMwICsyNDcsMzkgQEAgc3RhdGljIGludCBy
YXZiX3R4X2ZyZWUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4gaW50IHEsIGJvb2wgZnJl
ZV90eGVkX29ubHkpICB9DQo+ID4NCj4gPiAgLyogRnJlZSBza2IncyBhbmQgRE1BIGJ1ZmZlcnMg
Zm9yIEV0aGVybmV0IEFWQiAqLyAtc3RhdGljIHZvaWQNCj4gPiByYXZiX3JpbmdfZnJlZShzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcmluZ19m
cmVlX3J4KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkNCj4gDQo+ICAgIEhvdyBhYm91
dCByYXZiX3J4X3JpbmdfZnJlZSgpIGluc3RlYWQ/DQpBZ3JlZWQuDQoNCj4gDQo+ID4gIHsNCj4g
PiAgCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiAt
CWludCBudW1fdHhfZGVzYyA9IHByaXYtPm51bV90eF9kZXNjOw0KPiA+ICAJaW50IHJpbmdfc2l6
ZTsNCj4gPiAgCWludCBpOw0KPiA+DQo+ID4gLQlpZiAocHJpdi0+cnhfcmluZ1txXSkgew0KPiA+
IC0JCWZvciAoaSA9IDA7IGkgPCBwcml2LT5udW1fcnhfcmluZ1txXTsgaSsrKSB7DQo+ID4gLQkJ
CXN0cnVjdCByYXZiX2V4X3J4X2Rlc2MgKmRlc2MgPSAmcHJpdi0+cnhfcmluZ1txXVtpXTsNCj4g
PiArCWZvciAoaSA9IDA7IGkgPCBwcml2LT5udW1fcnhfcmluZ1txXTsgaSsrKSB7DQo+ID4gKwkJ
c3RydWN0IHJhdmJfZXhfcnhfZGVzYyAqZGVzYyA9ICZwcml2LT5yeF9yaW5nW3FdW2ldOw0KPiA+
DQo+ID4gLQkJCWlmICghZG1hX21hcHBpbmdfZXJyb3IobmRldi0+ZGV2LnBhcmVudCwNCj4gPiAt
CQkJCQkgICAgICAgbGUzMl90b19jcHUoZGVzYy0+ZHB0cikpKQ0KPiA+IC0JCQkJZG1hX3VubWFw
X3NpbmdsZShuZGV2LT5kZXYucGFyZW50LA0KPiA+IC0JCQkJCQkgbGUzMl90b19jcHUoZGVzYy0+
ZHB0ciksDQo+ID4gLQkJCQkJCSBSWF9CVUZfU1osDQo+ID4gLQkJCQkJCSBETUFfRlJPTV9ERVZJ
Q0UpOw0KPiA+IC0JCX0NCj4gPiAtCQlyaW5nX3NpemUgPSBzaXplb2Yoc3RydWN0IHJhdmJfZXhf
cnhfZGVzYykgKg0KPiA+IC0JCQkgICAgKHByaXYtPm51bV9yeF9yaW5nW3FdICsgMSk7DQo+ID4g
LQkJZG1hX2ZyZWVfY29oZXJlbnQobmRldi0+ZGV2LnBhcmVudCwgcmluZ19zaXplLCBwcml2LQ0K
PiA+cnhfcmluZ1txXSwNCj4gPiAtCQkJCSAgcHJpdi0+cnhfZGVzY19kbWFbcV0pOw0KPiA+IC0J
CXByaXYtPnJ4X3JpbmdbcV0gPSBOVUxMOw0KPiA+ICsJCWlmICghZG1hX21hcHBpbmdfZXJyb3Io
bmRldi0+ZGV2LnBhcmVudCwNCj4gPiArCQkJCSAgICAgICBsZTMyX3RvX2NwdShkZXNjLT5kcHRy
KSkpDQo+ID4gKwkJCWRtYV91bm1hcF9zaW5nbGUobmRldi0+ZGV2LnBhcmVudCwNCj4gPiArCQkJ
CQkgbGUzMl90b19jcHUoZGVzYy0+ZHB0ciksDQo+ID4gKwkJCQkJIFJYX0JVRl9TWiwNCj4gPiAr
CQkJCQkgRE1BX0ZST01fREVWSUNFKTsNCj4gPiAgCX0NCj4gPiArCXJpbmdfc2l6ZSA9IHNpemVv
ZihzdHJ1Y3QgcmF2Yl9leF9yeF9kZXNjKSAqDQo+ID4gKwkJICAgIChwcml2LT5udW1fcnhfcmlu
Z1txXSArIDEpOw0KPiA+ICsJZG1hX2ZyZWVfY29oZXJlbnQobmRldi0+ZGV2LnBhcmVudCwgcmlu
Z19zaXplLCBwcml2LT5yeF9yaW5nW3FdLA0KPiA+ICsJCQkgIHByaXYtPnJ4X2Rlc2NfZG1hW3Fd
KTsNCj4gPiArCXByaXYtPnJ4X3JpbmdbcV0gPSBOVUxMOw0KPiANCj4gICAgQ291bGRuJ3QgdGhp
cyBiZSBtb3ZlZCBpbnRvIHRoZSBuZXcgcmF2Yl9yaW5nX2ZyZWUoKSwgbGlrZSB0aGUgaW5pdGlh
bA0KPiBOVUxMIGNoZWNrPw0KDQpGb3IgUlovRzJMLCBpdCBpcyBwcml2LT5yZ2V0aF9yeF9yaW5n
LCB0aGF0IGlzIHRoZSByZWFzb24uDQoNCkkgY2FuIG1vdmUgdGhlIGluaXRpYWwgTlVMTCBjaGVj
ayBoZXJlLCBzbyB0aGUgZ2VuZXJpYyByYXZiX3JpbmdfZnJlZSBkb2VzIG5vdCBkaWZmZXJlbnRp
YXRlIGJldHdlZW4NCnByaXYtPnJ4X3JpbmcgYW5kIHByaXYtPnJnZXRoX3J4X3JpbmcuIFNlZSBi
ZWxvdy4NCg0KPiANCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgcmF2Yl9yaW5nX2Zy
ZWUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKSB7DQo+ID4gKwlzdHJ1Y3QgcmF2Yl9w
cml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKwljb25zdCBzdHJ1Y3QgcmF2
Yl9kcnZfZGF0YSAqaW5mbyA9IHByaXYtPmluZm87DQo+ID4gKwlpbnQgbnVtX3R4X2Rlc2MgPSBw
cml2LT5udW1fdHhfZGVzYzsNCj4gPiArCWludCByaW5nX3NpemU7DQo+ID4gKwlpbnQgaTsNCj4g
PiArDQo+ID4gKwlpZiAocHJpdi0+cnhfcmluZ1txXSkNCj4gPiArCQlpbmZvLT5yYXZiX29wcy0+
cmluZ19mcmVlKG5kZXYsIHEpOw0KPiANCj4gICAgLi4uIGhlcmU/DQoNCiAgICAgSXQgd2lsbCBi
ZSBqdXN0ICBpbmZvLT5yYXZiX29wcy0+cmluZ19mcmVlKG5kZXYsIHEpOw0KQW5kIE5VTEwgY2hl
Y2sgd2lsbCBiZSBoYW5kbGVkIHJlc3BlY3RpdmUgcnggaGVscGVyIGZ1bmN0aW9uLg0KDQpXaGF0
IGRvIHlvdSB0aGluaz8NCg0KQ2hlZXJzLA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJS
LCBTZXJnZWkNCg==
