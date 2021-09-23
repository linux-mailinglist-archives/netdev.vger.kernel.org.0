Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2733F416617
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbhIWTrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:47:05 -0400
Received: from mail-eopbgr1400124.outbound.protection.outlook.com ([40.107.140.124]:41888
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242796AbhIWTrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 15:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFRWZyB6JUClVStJ55AdJj5YyMuZuDXRdt9HKTy2WuNIUvWAZDwR0erCmVyYYmucrQOch9EjVfOOq3reZCw+TP6YgOWhanzfCBRZLYi60ag73DuGHHABFr1+4ia/QvSo0KNHbpYJczAW6wAOplknNbTwsvQ6vqar7K3Em6mLhK4ooMwJH1W2vNE7SKYFB73Ywti31x5ByBEcxfJrWmLrUYIEerK2GZX30X71GrD0Le+zC1Bv4jVgDyhOxKwuo3dmi7CXN/SWW7WCCQO09MwqH/TnLpX4kvjiR9nmfLFH4hkcbHGMuk4wy013RW4QWtXE+SUMbwtj6bwVHYk0BBsCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=S/xbgpEVLPcBbUC61C5BLVJzT1MD9TL7gS1Vq+LgKRE=;
 b=F6eucuZpAScjUJF16eJuIb4V/KFPbnNp4yvVjBYoOA3hgp4Sen8baFt51eDsTYROk/AT+sAWaDTfwbr1ezK9DF70QBpUmj7FEhTQR7c23vKkcqTvkyC+C9GWGmibF9se1AyGu/m+0ulkfARbUm0uSjW+r14iC9wt53axSSyhAAFg46WmGLLkVjov4se2sXY9Sk3luYrobxSwiAFpGpBSr1gtlsvPHg4iFOx9IjDtXdimfyY+BkWjRTKjUqYPrCCpcNM7j3aGztJvxwj//DpjfHmZrYOnP6WXNwrlh6k2r4XEFULVFDMmqlYLDbhG9HrpVz8mEgjdN7JKbEPTszRdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/xbgpEVLPcBbUC61C5BLVJzT1MD9TL7gS1Vq+LgKRE=;
 b=VITW+KP6172i+HEEzWGgg3evflyOILO8vAbbUNGxN1NbqxTjaxvWE90vFM9m6+BXybWOyL6ZoZE1WkVDhGimFY2Md6V9iMbzWg0hdw5t8WDh0q3yK7yIGrXG/znKQOiJdG/qlKrVGKIa78iRkP722kGUS87mPwDD6q6X+7dsFQw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1875.jpnprd01.prod.outlook.com (2603:1096:603:2d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 19:45:30 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 19:45:30 +0000
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
Subject: RE: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Index: AQHXsISAOfY/2JLZEkuO1R4Mf2Gbvaux+WeAgAABF/CAAAqGgIAAADgw
Date:   Thu, 23 Sep 2021 19:45:29 +0000
Message-ID: <OS0PR01MB5922FCB43284B938A4E12D1686A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
 <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
 <OS0PR01MB5922F3EE90E79FDB0703BCEC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <484f6f91-c34d-935d-1f42-456d01e9b8ca@omp.ru>
In-Reply-To: <484f6f91-c34d-935d-1f42-456d01e9b8ca@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0cf63aa-171a-47b7-2476-08d97ecab309
x-ms-traffictypediagnostic: OSAPR01MB1875:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB18752085361B7C50DA4DBDDD86A39@OSAPR01MB1875.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GqdH8QNryODTI5hkwl0mgmC2STndOAergtRplfn2b1jpcq1LsUPc7HoVzamJvGP/lrthVeq6yXD8K2apYvVPnPPcoC43h5zBFxJRIKyJOdOYCL7bWbOmLAjCFlYyspGRpaq7podIJA2CmKH2yfqhJElKTcXycT3yPaVszYd6sKo0DEb6vCeBVaDo8A++nMVqHgfNVfM6z2fulbpJ4n/HXES6pVgs+xLmgEmf/1t3kclXNxRRldxjGQK6yzjXZAAXAOC6Ok+aeWfGg5PRmZP2ZEiqKQj1AVSJ3heNdUMeaFsEQjGbDyQSF0iJU74iYxZKtImtrTWni4cZ/IA2IU/4uzNidXYOwfq5XMjz7q66tPymbaJbKv+VCoeD1rxZYWT5JEc2aeeD3z9OGwDwRw4hsCxgplGtYXkS17x25vpYDBaucYKcCHgENFVt5IfT1RctQaRXuvmb+3Yz4Y6Jy0GUkMZDONe0GcdoquBq/oyhuKV209gfje3DzHSQDV+iiPsH8gTJUR+ax1AY1dKGPYQRxcOZmK0EKxZFVafMVGYrxgWRRQht1sbiAocc0Hd3bzGUK0vbyECZ3g7nqpy2yeWIduIk5Rdww7OPbXbD5K59VCPKRnCpeHPg3dqwp9jdApKlXmWtK+DZcyt8Jh/9adZPT1BUtcqwyY39q7ofIUsYDrxoaUlmKmWqeYTwxWptyhYTjhWqn4WIk29JNa6DkWmlYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(316002)(5660300002)(33656002)(508600001)(2906002)(54906003)(53546011)(52536014)(66446008)(66476007)(8936002)(110136005)(66556008)(76116006)(9686003)(86362001)(55016002)(83380400001)(8676002)(7696005)(64756008)(26005)(186003)(38070700005)(71200400001)(6506007)(38100700002)(107886003)(122000001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjVhSW9OSG5zN0ozS3lMVVE2Vnd6eGdtVnZGdWRqVksyU1ByYnRKczVOVzhP?=
 =?utf-8?B?UjF4OHk1bUJablNaWlp6TmxKZ0YxcXRjRW5xQ2VnU0VmTlBYVzZPTVZIZ0lx?=
 =?utf-8?B?L0lMUC8vL0lPVnhRL0cxU1JXYTBmbXdYekRBL3dPbEs4YkVRZGZPWXUzZGVX?=
 =?utf-8?B?QzM4NlZCOWtJWjYxVWRISUZjMi9UZi9ZSkRzNXU4bmR3SjFxTHhKQWhQNTNG?=
 =?utf-8?B?eUcvcTZldjY3NUZkOXhYVnhHTGJYRy9TMlJoeWI1YU10RGxJSncvNjdIaEdE?=
 =?utf-8?B?TG95VmYvUjRBMGx4T0RFZWU3bFNuRUEyTUxJK1FyVEc4WkJqR1ZSOHM1M1dC?=
 =?utf-8?B?QlY1RUpPUWErcFpvQzVMUWdmU2QzRUpheWx0MjdWN2EzdnJLREFKbFYwYURN?=
 =?utf-8?B?TDRYamF2amdnOVkwYzhWVUx0QXBGbFhKSGR4QkNyNGJkYjBYaC8zTFU5SHhJ?=
 =?utf-8?B?SDZrNVZhUmRiS0s4Smk3a3VoNmoxdCtnZFd2VHU0bGMzMnNZQ1ErVHQ5Y25M?=
 =?utf-8?B?ckFqNlRabk5BQ3JpQ2FEcEFiN0Z1OE9ldVlLMFZwTk1nWGM4RGMvNWUvMVFF?=
 =?utf-8?B?MGNIZndkNzd3bHJSR1Jlb051Y1dkZklWMFVkRXdwcUI3T2x0MXJIMXBlOWhh?=
 =?utf-8?B?S3JIRHIvS3NVMGNnTzVvek1XNDdNSi9Vd1krYzdRdDgvWitLTmpiTjJ2M0pF?=
 =?utf-8?B?cXZWSXp3YkszbDBzcTJ0U1QwdlAxUDR6VVYyT0todXFRR0VWT1hOUnk1SitY?=
 =?utf-8?B?ZDJUUk1yTU9kQ1B3YnZwNnVRVTArNk5sZE5aWFBycjA3aGErVVg1NUZ5QlBs?=
 =?utf-8?B?b1ZtV2JDT05EaWdvaytWdGZaNkMveHhIZEZaZngyOVZ3L2RDbmxGbWxCMmVv?=
 =?utf-8?B?eEZtRlJwclMwdms0aHo1dzBYeExKOUtuZHJCZ0xIMXkybllOd0xYQ25pOUNn?=
 =?utf-8?B?bmlHbURVTGlXQTE1Uzk4UGE3bGN3UUhya3E1QUx3UnhKT0ppR0U5elpUMG9S?=
 =?utf-8?B?MExEV3NaY2p3Wm1DU2kwRmpmTkVpVkU1N21ZODRrcGtYZ1loMFVFRU9wbE9I?=
 =?utf-8?B?b21Ick9hYWVVRGY0KytTSDFmcU5nNUNYci9LeXg0dTVsQnQrK1g1TmNaZVh3?=
 =?utf-8?B?MWovMjc5ZFpQWUVFeWtaVG5pcFFyTW92R25ac1Roc2k0VnJWNGV3NlBEaHBV?=
 =?utf-8?B?YjdEZ1ZFNnpWUnNLV1V0NnlJalJsc1hQK2dLbFhCVFZQOWlLR1l1eHRJVyti?=
 =?utf-8?B?clBXRjNSclhrY2oyMWpBbUlrSW0veGt0MDB2Kzd3c0dJVUZGZGxPRHQxdjV1?=
 =?utf-8?B?Rkw1TCtPWXM2Y0xRZTRPQ3M3ZWdPQ0NMcGY2T0k4N1YwRDVNWjR2dldIV1VF?=
 =?utf-8?B?TW9YbHlFc29GSElsSTJzVDRQYkhNYnJ1RWdjRDJWSlh6LzVOZ05hTHFBYlpQ?=
 =?utf-8?B?QlR1dDNleU8wZW5TclNmWjF6S3RLWE9QbWkyeGRMNXh0SWNvYkFqanNKK1Fq?=
 =?utf-8?B?Tnlad3pvdGltbGZ1bFFvQnpIUnFNb3Y4Qlc1MTZIbkdIVGNaUHl4ZEJwenNK?=
 =?utf-8?B?NCs3cCtPZWR2TEpYVkprWlhvblg1MHpaVUgrK2NKOTJaMks3NVFNSTl3ZGxt?=
 =?utf-8?B?blJsKzFVZEJKNWdQZ3M3b0dJZkJSOGZUNW91djM3UXhpRSs4MzRHdU1kRVFS?=
 =?utf-8?B?bi9NdDhOUWdWTXpIT1ZYTFVMNXVNWVlLN2R0WjFKR1k3MkkxL1I0QTA3ZWcz?=
 =?utf-8?Q?g/YNQ9i4VhKtkv+j35n+3kFIJHZnL1VG5EGAWfE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0cf63aa-171a-47b7-2476-08d97ecab309
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 19:45:29.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5klMYWSfd2J053XeH6QhVPmEHwBUpzp8/hUkJXlowQ05UTYU11tNon4DL+myRz29oK4oTWqBeyijkuiCafoNju/sxn9KKgNNVS3/l7fO7a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1875
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDA1LzE4XSByYXZiOiBFeGNs
dWRlIGdQVFAgZmVhdHVyZSBzdXBwb3J0IGZvcg0KPiBSWi9HMkwNCj4gDQo+IE9uIDkvMjMvMjEg
MTA6MTMgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+IFItQ2FyIHN1cHBv
cnRzIGdQVFAgZmVhdHVyZSB3aGVyZWFzIFJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IGl0Lg0KPiA+
Pj4gVGhpcyBwYXRjaCBleGNsdWRlcyBndHAgZmVhdHVyZSBzdXBwb3J0IGZvciBSWi9HMkwgYnkg
ZW5hYmxpbmcNCj4gPj4+IG5vX2dwdHAgZmVhdHVyZSBiaXQuDQo+ID4+Pg0KPiA+Pj4gU2lnbmVk
LW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4gLS0t
DQo+ID4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDQ2DQo+
ID4+PiArKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgMjgg
aW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4gaW5kZXggZDM4ZmMzM2E4
ZTkzLi44NjYzZDgzNTA3YTAgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+IFsuLi5dDQo+ID4+PiBAQCAtOTUzLDcgKzk1NCw3IEBA
IHN0YXRpYyBpcnFyZXR1cm5fdCByYXZiX2ludGVycnVwdChpbnQgaXJxLCB2b2lkDQo+ID4+ICpk
ZXZfaWQpDQo+ID4+PiAgCX0NCj4gPj4+DQo+ID4+PiAgCS8qIGdQVFAgaW50ZXJydXB0IHN0YXR1
cyBzdW1tYXJ5ICovDQo+ID4+PiAtCWlmIChpc3MgJiBJU1NfQ0dJUykgew0KPiA+Pg0KPiA+PiAg
ICBJc24ndCB0aGlzIGJpdCBhbHdheXMgMCBvbiBSWi9HMkw/DQo+ID4NCj4gPiBUaGlzIENHSU0g
Yml0KEJJVDEzKSB3aGljaCBpcyBwcmVzZW50IG9uIFItQ2FyIEdlbjMgaXMgbm90IHByZXNlbnQg
aW4NCj4gPiBSWi9HMkwuIEFzIHBlciB0aGUgSFcgbWFudWFsDQo+ID4gQklUMTMgaXMgcmVzZXJ2
ZWQgYml0IGFuZCByZWFkIGlzIGFsd2F5cyAwLg0KPiA+DQo+ID4+DQo+ID4+PiArCWlmICghaW5m
by0+bm9fZ3B0cCAmJiAoaXNzICYgSVNTX0NHSVMpKSB7DQo+IA0KPiAgICBUaGVuIGV4dGVuZGlu
ZyB0aGlzIGNoZWNrIGRvZXNuJ3Qgc2VlbSBuZWNlc3Nhcnk/DQo+IA0KPiA+Pj4gIAkJcmF2Yl9w
dHBfaW50ZXJydXB0KG5kZXYpOw0KPiA+Pj4gIAkJcmVzdWx0ID0gSVJRX0hBTkRMRUQ7DQo+ID4+
PiAgCX0NCj4gWy4uLl0NCj4gPj4+IEBAIC0yMTE2LDYgKzIxMTksNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHJhdmJfaHdfaW5mbyByZ2V0aF9od19pbmZvID0NCj4gew0KPiA+Pj4gIAkuZW1hY19p
bml0ID0gcmF2Yl9yZ2V0aF9lbWFjX2luaXQsDQo+ID4+PiAgCS5hbGlnbmVkX3R4ID0gMSwNCj4g
Pj4+ICAJLnR4X2NvdW50ZXJzID0gMSwNCj4gPj4+ICsJLm5vX2dwdHAgPSAxLA0KPiA+Pg0KPiA+
PiAgICBNaG0sIEkgZGVmaW5pdGVseSBkb24ndCBsaWtlIHRoZSB3YXkgeW91ICJleHRlbmQiIHRo
ZSBHYkV0aGVybmV0DQo+ID4+IGluZm8gc3RydWN0dXJlLiBBbGwgdGhlIGFwcGxpY2FibGUgZmxh
Z3Mgc2hvdWxkIGJlIHNldCBpbiB0aGUgbGFzdA0KPiA+PiBwYXRjaCBvZiB0aGUgc2VyaWVzLCBu
b3QgYW1pZHN0IG9mIGl0Lg0KPiA+DQo+ID4gQWNjb3JkaW5nIHRvIG1lLCBJdCBpcyBjbGVhcmVy
IHdpdGggc21hbGxlciBwYXRjaGVzIGxpa2UsIHdoYXQgd2UgaGF2ZQ0KPiBkb25lIHdpdGggcHJl
dmlvdXMgMiBwYXRjaCBzZXRzIGZvciBmYWN0b3Jpc2F0aW9uLg0KPiA+IFBsZWFzZSBjb3JyZWN0
IG1lLCBpZiBhbnkgb25lIGhhdmUgZGlmZmVyZW50IG9waW5pb24uDQo+IA0KPiAgICBJJ20gYWZy
YWlkIHlvdSdkIGdldCBhIHBhcnRseSBmdW5jdGlvbmluZyBkZXZpY2Ugd2l0aCB0aGUgUlovRzIg
aW5mbw0KPiBpbnRyb2R1Y2VkIGFtaWRzdCBvZiB0aGUgc2VyaWVzIGFuZCB0aGVuIHRoZSBuZWNl
c3NhcnkgZmxhZ3MvdmFsdWVzIGFkZGVkDQo+IHRvIGl0LiBUaGlzIHNob3VsZCBkZWZpbml0ZWx5
IGJlIGF2b2lkZWQuDQoNCkl0IGlzIG9rLCBJdCBpcyB1bmRlcnN0b29kLCBBZnRlciByZXBsYWNp
bmcgYWxsICB0aGUgcGxhY2UgaG9sZGVycyBvbmx5IHdlIGdldCBmdWxsIGZ1bmN0aW9uYWxpdHku
DQpUaGF0IGlzIHRoZSByZWFzb24gcGxhY2UgaG9sZGVycyBhZGRlZCBpbiBmaXJzdCBwYXRjaCwg
c28gdGhhdCB3ZSBjYW4gZmlsbCBlYWNoIGZ1bmN0aW9uIGF0IGxhdGVyIHN0YWdlDQpCeSBzbWFs
bGVyIHBhdGNoZXIuIFNhbWUgY2FzZSBmb3IgZmVhdHVyZSBiaXRzLg0KDQpSZWdhcmRzLA0KQmlq
dQ0K
