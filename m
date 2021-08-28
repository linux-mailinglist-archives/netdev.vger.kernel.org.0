Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D0A3FA5AC
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 14:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhH1MqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 08:46:16 -0400
Received: from mail-eopbgr1410105.outbound.protection.outlook.com ([40.107.141.105]:62545
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234012AbhH1MqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 08:46:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHwbXyY2E2a9broPralUdDboaPaQE3PDCNckIDGA7/UgZrDMSiMr4M5OZA1QArvE3xFl8qaQQVuYaxF6VT35IRAk69QLxk+45L0+6UPq95+b3AiWB8OXmytTewlYdr15t5cbzHed4P/Y1Ke/pOnFHNgPvuWuxdpBcwmg3owXWiu4RqLYpwuic1+IftyLLvbw3+kmnjR6voC2M24V0nl4xGlOMexLG9txkY0BX04TnUf7a5r/SFemY5Gd1Y6xkrdpGxneOC6fBGqmI1gCSUcmsajLfo8abxx1kaI+MsJ6vxRjIIyTDQ/xwIqlw8VSa3gTPnp1EY4IJYL+4iRyZJ5EuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBHHELmJLVeZzRo3hh9/zgsUs/eMUkxrc2Q6iD7xo2U=;
 b=cTLEPm/yoCL/kW0ioIo86CytMvz8Xhq+gmQeh+35ze2GVhRNF/L8X9JyNmCZG8Y6g/c2Kq1QicGkiKiffghB7+7pNY2YMxXguiNqukTHsB2cW/zQlCqDBy3IIaA0bligdXtyGNgafS7MIUTfl1fONne/dC/AtbbriEWLjeN05RWQtRZ0gMCTvfU4ameoDR32PozAGgM5NmzQi1Dp7+yOxnhyciaOBNt7uiEyVh+Bb3T+4Th5dF2ycGf5FdygnaSXoIDpIJH6OmOr3TudtdG0Q6fqCvkx+sbNotMiZUyoQvgyCDiA3M37v6yT2fRKgrccxGrvLau4ZbpVGzCXobQmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBHHELmJLVeZzRo3hh9/zgsUs/eMUkxrc2Q6iD7xo2U=;
 b=kuAkF/0vsEWVxgw2VkXu/31Of8+0RDJPemcKy3BjgoJAQ7Dzi8ITGeO3MB9O8C/QuR8o3GKWFaPnh2nsfLSYlxH4Fr1mqTt+diwJaP4tUz2pyJTNRemNyArLfjP3gyM671VI/Qz8QvhD92YIYIVag18aKFLNp8AhwwJqSiMjnH4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2135.jpnprd01.prod.outlook.com (2603:1096:603:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sat, 28 Aug
 2021 12:45:16 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%4]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 12:45:16 +0000
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
Subject: RE: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
Thread-Topic: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
Thread-Index: AQHXmX8wiUfxijLx1ESK/WmjrUoG+quHvSsAgADqaNCAACbqgIAAEy/A
Date:   Sat, 28 Aug 2021 12:45:16 +0000
Message-ID: <OS0PR01MB5922CEDA81D7B0468C48B34086C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-11-biju.das.jz@bp.renesas.com>
 <e08a1cf0-aac6-3ae2-fead-9b1f916fc27b@omp.ru>
 <OS0PR01MB5922B9A2B3A9ADDFFDF47E1486C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <194bcd09-4ea0-844b-fbb2-fe01b4d6e3d4@omp.ru>
In-Reply-To: <194bcd09-4ea0-844b-fbb2-fe01b4d6e3d4@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6da6aac-2585-4fdc-1459-08d96a21afcf
x-ms-traffictypediagnostic: OSBPR01MB2135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2135183A950BBA484A47DD2786C99@OSBPR01MB2135.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kcjcop5EJ4cqebVrsrxMiDTN8lqdFFnrZPLVopyTmwkbiN5A801X7sagXvfTepH3r7+f6p5TffauJDvZ4ZW6EVtcUA9c5e6HtibZEyDjPXr+SCY3VgSUwR5/+5Xg0SjtqVyVq8thlXHBQe3pp6koGjbVN4HJ85J/K0CMhuxjkNATJNjZmarzqLYql8chqXD0KTmWL3K9N6ouCUtE4/TuzJ1bga5QjtbsodgmKlx/fYLKMWiZDB1Uhs2heYhDUUA+3ziw+KGrPTcuLHjrIbhCx5B9Jp3DO9hOL0axcHdt+i7KtUHTPuLUGSAJ/zgqjnJ94X6fQfXB8CoTEpLWHIoHjCeJZ2sQkqenrzOpot7Ye5zzmjvXDYzESeMmszzD/M16DhSOkM+bbxqa+A9xXKvqUaaWI4CYAqqkPRiV5YlNdmomzxyq3yDP+Awqafj+lxIHhwyxK7EvcLQbVvOds3WEJlQIglS7rZb2Bb+1HmSqER2rhOETCyIeuV//CtHBhStwi0rvnggjp6QirHhXT2UfExx04Y5kqVfHuNdpM/D+B4G7FvBKWapxKJ7pGUQ4nx5bcqwZo2FTinsqxKPH9ImTpppGnru+9YioOZG1MKJtq/ScDM95CDd1JlGIa+wUY9lh8xp4bHzVUGy3IM760cz5ltd+hh4V964zRFzrrgDmVVBUN3LI8OkJ2iPiPUYF24QLOyCndr31IUduXmkDRmkqsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(366004)(396003)(376002)(33656002)(8676002)(66556008)(38070700005)(7696005)(8936002)(107886003)(316002)(2906002)(52536014)(110136005)(186003)(86362001)(66476007)(64756008)(4326008)(55016002)(66446008)(53546011)(6506007)(54906003)(9686003)(66946007)(38100700002)(71200400001)(122000001)(83380400001)(478600001)(26005)(5660300002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmtYZTRMTUZndXc4L1hHd21nTmpaRDJNWWhLMDFKY0NTaFlWYVdmbGZ4RnFF?=
 =?utf-8?B?LzVXbzI3SVFJVkx5aU1PR2ZjMGx4b2p6M1pncG9tRUZxUStwbksycTFISktw?=
 =?utf-8?B?VUVOZFh1YThPSUhQWHNJVjlwWGVJZWdrcURLREs3R1NZU3puZDE3cng5aDNK?=
 =?utf-8?B?a3dZclIwaFArT2FtdEt1MTlTK2pvNUt4ZHIwdmhrdVNNU0pDcUJodlcrZHNo?=
 =?utf-8?B?MkZKNjlPN3c0RjFBM1JFUFNOb1hUdExmbXd2WFFlK3FFTzR1cTNPckN5dlpJ?=
 =?utf-8?B?MS9QZ0dVa2xPcWdUUitvanQ4cjJBdzBGd2tMMWdaL1dhTjRjYVJsL0c0RkJB?=
 =?utf-8?B?dzBoWVozYWNBNGVJcURwYXdxZWNEakh4MTNDYXdkTGM4K3VnUy8yRmFPeVho?=
 =?utf-8?B?OElqOUx1MGRaeUNBMW1sTmwxTW5hcmRGZTBMQ1FLZDdDT01rbmY0dmZZNkJM?=
 =?utf-8?B?SldQSFFZcTFNVGo5U0pIelI2dlBOLy9KL1Z5Z2loWThHajZlc2NXZmNXcmRo?=
 =?utf-8?B?NThPZ1pmOTNlNkoxc0Y2S2RVY0dwUGF0b2RZQ0VKdjlLT2R3TjZKSk1SdlFo?=
 =?utf-8?B?US9NQkFsSkE0c01iWUYwSWxPSzZQYlBhMkdVdEhMV25wdWFvNVJIVUFLN25Z?=
 =?utf-8?B?eTByS0ZnTTdHRVVBVW1BMDhXbmFQOWF6QVRpWmY3c1hVYkx5M0gzRERucnVx?=
 =?utf-8?B?M1pTM0FCTnlaZmpaN2wrZERoT3UzYnhFeVNMRnByQXFEc0k5RUt6dEpPcXlN?=
 =?utf-8?B?eG1ZQjlXUDFEenBSbkVCU2IyOE1saWtXby9qOTNvSkhNeG9jVUFhYWNpTWYx?=
 =?utf-8?B?QUJJK0Z2NlNZdWdRUDg4c2wvQlNXV3NzcmtDdVBRN25JMjhvc3d6YTA2cE9D?=
 =?utf-8?B?ZFdqMWMxZnU2ZVdSbGo5WVlCZjEzaWhHQjg2YzRRcVEzWVN2WUk0TmpEd215?=
 =?utf-8?B?M0hjTkNlSVhqSUJkOFdTd291YkpHMm0yM2VrNndnUlFyWnBIRnF4dWQ4aWp4?=
 =?utf-8?B?L2xSVksraHNSRHZDRmo2V21YV2x5cEhlRXcxbm5wMHVtcjZvMmM1M3BuMDJF?=
 =?utf-8?B?eUw2TDhLcXM3dDRtN2I4NGQ2TXA2WHBWY3RnMEJBaGxMYWJTTlVPRlhlZno5?=
 =?utf-8?B?eFFINlB5TEg3eGo3RjZpTnhxVFV5ZzYvMnd1amVKZnJlV3R5RWF2M2JsYmU0?=
 =?utf-8?B?UnhlQVp5bVdzbGZrZ01FMDNvYXFsc1c5SHl4WlM3L0tDVERNbk1sTVlIZTJk?=
 =?utf-8?B?RlhoaDBxOGFVbGxyTEE0bzZWaVZ2TlBXODNEVlRTS0FWakRzSFVrbEtkdVoz?=
 =?utf-8?B?bmVIUDZIeVRESHhQVGdTdTFqZjViaEsvVExMRlBqK3VBYU9PTHNQRTFTL2FM?=
 =?utf-8?B?ZXBSWFNtRCtROHk5THZDZ3Zvbi9MUUo3NWpYc1B4TW1sU1FTbzJNWGVBMXdi?=
 =?utf-8?B?WXdYVWM3VU9hV0xHRzAxWXRMYU02QmkzWmx5UStMVThENjQ0d2Y1UkZtWHZy?=
 =?utf-8?B?VHI1a2xWMm5KZTFFajFMY1cyQm9UYlNBSDJLOUI5THJqQks1anVnZE93Tk1I?=
 =?utf-8?B?TGV1cElERXpvQzZjSkd6OFY4eE9UZjlaUmZPNTN3UDJqYlU1ME80akhyNGVh?=
 =?utf-8?B?Y1I2RWJLYlVJMVFHOUE5Qm9LeDFJbkZMeFptUGNPREJlNE00YmNiZTIzV3dG?=
 =?utf-8?B?R3N3aERIOW9CY2J6MkJuZVgxRXo3V2VzN2o5Wkd0dFlaSmQwTFNNUGxuRkY2?=
 =?utf-8?Q?cxtMeQv85Hw6tXfGMo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6da6aac-2585-4fdc-1459-08d96a21afcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 12:45:16.0328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GEl+kjefGpfTwkBDtV9pRDcHWo85QkPhRqBGEDALDhWIFHtsKRUh+uhHxA7tZt3UYjTzTyKI7Vq8KkW3Wzp9mPUV0fS/VV+wrQ1TCrYwA7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMTAvMTNdIHJhdmI6
IEZhY3RvcmlzZSByYXZiX3NldF9mZWF0dXJlcw0KPiANCj4gT24gMjguMDguMjAyMSAxMjoyMCwg
QmlqdSBEYXMgd3JvdGU6DQo+IA0KPiBbLi4uXQ0KPiA+Pj4gUlovRzJMIHN1cHBvcnRzIEhXIGNo
ZWNrc3VtIG9uIFJYIGFuZCBUWCB3aGVyZWFzIFItQ2FyIHN1cHBvcnRzIG9uIFJYLg0KPiA+Pj4g
RmFjdG9yaXNlIHJhdmJfc2V0X2ZlYXR1cmVzIHRvIHN1cHBvcnQgdGhpcyBmZWF0dXJlLg0KPiA+
Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPj4+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRl
di1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8ICAxICsNCj4gPj4+ICAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDE1ICsrKysrKysrKysrKystLQ0KPiA+Pj4g
ICAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+
Pg0KPiA+PiBbLi4uXQ0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+Pj4gaW5kZXggMWY5ZDlmNTRiZjFiLi4xNzg5MzA5YzRjMDMgMTAwNjQ0
DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+
PiBAQCAtMTkwMSw4ICsxOTAxLDggQEAgc3RhdGljIHZvaWQgcmF2Yl9zZXRfcnhfY3N1bShzdHJ1
Y3QgbmV0X2RldmljZQ0KPiA+PiAqbmRldiwgYm9vbCBlbmFibGUpDQo+ID4+PiAgIAlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7ICB9DQo+ID4+Pg0KPiA+Pj4gLXN0
YXRpYyBpbnQgcmF2Yl9zZXRfZmVhdHVyZXMoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4+
PiAtCQkJICAgICBuZXRkZXZfZmVhdHVyZXNfdCBmZWF0dXJlcykNCj4gPj4+ICtzdGF0aWMgaW50
IHJhdmJfc2V0X2ZlYXR1cmVzX3J4X2NzdW0oc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4+
PiArCQkJCSAgICAgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQo+ID4+DQo+ID4+ICAgICBI
b3cgYWJvdXQgcmF2Yl9zZXRfZmVhdHVyZXNfcmNhcigpIG9yIHMvdGggYWxpa2U/DQo+ID4NCj4g
PiBXaGF0IGFib3V0DQo+ID4NCj4gPiByYXZiX3JjYXJfc2V0X2ZlYXR1cmVzX2NzdW0oKT8NCj4g
Pg0KPiA+IGFuZA0KPiA+DQo+ID4gcmF2Yl9yZ2V0aF9zZXRfZmVhdHVyZXNfY3N1bSgpPw0KPiAg
Pg0KPiA+IElmIHlvdSBhcmUgb2sgd2l0aCB0aGlzIG5hbWUgY2hhbmdlIEkgd2lsbCBpbmNvcnBv
cmF0ZSB0aGlzIGNoYW5nZXMgaW4NCj4gbmV4dCAtIFJGQyBwYXRjaHNldD8NCj4gPg0KPiA+IElm
IHlvdSBzdGlsbCB3YW50IHJhdmJfc2V0X2ZlYXR1cmVzX3JjYXIoKSBhbmQNCj4gcmF2Yl9zZXRf
ZmVhdHVyZXNfcmdldGgoKSwgSSBhbSBvayB3aXRoIHRoYXQgYXMgd2VsbC4NCj4gPg0KPiA+IFBs
ZWFzZSBsZXQgbWUga25vdywgd2hpY2ggbmFtZSB5b3UgbGlrZS4NCj4gDQo+ICAgICBMb29raW5n
IGJhY2sgYXQgc2hfZXRoLCBteSB2YXJpYW50IHNlZW1zIHRvIGZpdCBiZXR0ZXIuLi4NCg0KT0ss
IHdpbGwgdGFrZSBjYXJlIHRoaXMgbmFtZSBjaGFuZ2UgaW4gbmV4dCBSRkMtIHBhdGNoc2V0IHdo
aWNoIGluY2x1ZGVzIFJaL0cyTCBzdXBwb3J0Lg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQoNCg==
