Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F001421766
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhJDTZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:25:35 -0400
Received: from mail-eopbgr1410097.outbound.protection.outlook.com ([40.107.141.97]:50334
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238708AbhJDTZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb93T7Yn2sw8kHhookfsru3Bdo2SJfB/ieQ7XbeNSCtzND14s9LWfM0yRPSoA8MDvZ8yE3aPz9glhB//cDigs4HMIZw2Be70iHviueAOD3PYHTBQvd6Sdclw/kJU2yxuE12pNC/j5o62cC45T/OIkU5Bg0Y815d/2/Wpp2Bm46CVzuO5xEoXv6KqVIK94604rVC4Lov/a1Z9OaozfveF526yFpU0OiQ2lk5+es7+v38TPj1V+jEB9cyS6M5LVumvlmKc6QWdZ4gBZPmFwaVlwMcsGMsCPAwIYSkozfrOIc2v2qsKyLh/mR6Bp1hn6qVRaCMGyhI6KLZNxFiVCCWQXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eM6vsHRMRXieBTZZiGL4etOonGT7rFFzuqHsWq3uaOo=;
 b=Rbld8DeWZLOV78ySIEGg6YHDyghudGEv8/+7WMzrcF84Az0kXjMdVmvtDvZmgAzTPskv6XFhfuae3Cx4Yj1EaiXeN+JsFrE4DBPG7h1x0qKdu82QBxy6cqwPf05JuZlTgwdN9x4FSw6Q2cpSYKADgJzSl0BWsdysTUzcLoU0vshinjE6XjorVWyI3sHwNud4/gOCeaKVUfr3uM0WCI7TdeWYkub+iBxghJULXmnn4/bv3wMxwiD4zMj92f/nnsb6Egt7ZdwsXntzlofUHS9d6JXoOW7x8y2Eb7HhBanz7Vlf8avT+5kL5kWIVR4gm7HGklS96V61cp29xeGo3NAqEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM6vsHRMRXieBTZZiGL4etOonGT7rFFzuqHsWq3uaOo=;
 b=geB3GN9Tc6Qb4HKZ8xz3scS/186HgNZ4gMnBGYk1r3JdTDIfQBp8iJDIcluhFkwjj8tOzmT47vp2VZAUEh0cfw52jh+FvJ7LRSI+jAFhUHxYesl3khDVcgGTgynDxXDvGeOlTuccgEIUtzO8eQbxdljpnrSM02iRLKNwzM4l2AU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4181.jpnprd01.prod.outlook.com (2603:1096:604:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Mon, 4 Oct
 2021 19:23:41 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:23:41 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [PATCH 10/10] ravb: Initialize GbEthernet E-MAC
Thread-Topic: [PATCH 10/10] ravb: Initialize GbEthernet E-MAC
Thread-Index: AQHXttYI4a5ceI8hlUKdgFCw+KNoBavDNUAAgAAGlsA=
Date:   Mon, 4 Oct 2021 19:23:41 +0000
Message-ID: <OS0PR01MB5922AD9E0E01812FC4A11E1386AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-11-biju.das.jz@bp.renesas.com>
 <9e7f271f-fc49-a85a-b790-af3a9bdc4be1@omp.ru>
In-Reply-To: <9e7f271f-fc49-a85a-b790-af3a9bdc4be1@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ccd9943-31dc-4662-2256-08d9876c796c
x-ms-traffictypediagnostic: OSBPR01MB4181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4181E0E494E457545745F28286AE9@OSBPR01MB4181.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wI3/6mPN34YavJQHkwDnzH1slhL0hJ4G9Tkdff9fAW4DOdkuC9IkJOPcIW71KirBijNPwxA9uBk2Etlpxk619ak4ACrYxcpEJJxN2WgqzBOt3CLxwgrFr9wlBLFCasnDEVui78rRJKcVfCGmsaQ9hlZrRFheY2hquITrX/tNUQELvJi1JIwCuHxpZ+I0EMYZrPgf7CMS5KUopks3JXuchMCIluCU2Ldtffl9wUHLwnCX6R8C4iGHzRfb3kuMGgTx873s7nNqqMXpfJQB58yqsS+dm3rQOuGURJ+ae5o3Y7/pickhglRDGI9AcMK6oFdWxFcKwraPjHcba5Pd3xJbOQ2ZzUL4pj7XitzSst9zopeHofM5tPCr/XXC7SyGCmMNdOW97hfBJAYR3RVu9p1EuvHA677rB8C0vl1o9Al7qHGSBIp4FVjRhfevYZoQg3dua2uofQqs5iXMOkURfIVX8+PsEqeFlKah8AcTJTBCUwD6q95OYmswe6fJYk/mkMOKSGXVHF7XPvkqXMqOXb6wIdnF4J9yjh7eUjhslK6bFgDK7Sr7W2uiuk3I6Vwmg1A9teq9VQfg9FXina1nEWhXMfXadY5CdPzi1rgv5PuTaeN9IHorC9CZISQ7rU4JDHCGdSHk21dIrgYwJs2Y4y0fhcfODl2lfD0aT1Vox5BRbdkKncSdZ2CZTZ4hJysYaUIah0TvXJge/S/yn6AkcbyoPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(38070700005)(508600001)(2906002)(66476007)(55016002)(64756008)(66556008)(66946007)(66446008)(38100700002)(122000001)(33656002)(4326008)(52536014)(7696005)(8676002)(8936002)(83380400001)(26005)(186003)(6506007)(5660300002)(7416002)(9686003)(110136005)(54906003)(86362001)(71200400001)(76116006)(53546011)(107886003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWIyeGdoSW51MWJ6QjBwR1QzYnh3T3M4MUczMzFHRmdXei9ZNWoyU0xZcUg4?=
 =?utf-8?B?am9kWE1oZ3VIWDRCZVZVUkdEcjNObklYVHBoM3pJYkthZVhickFweHdNaFZN?=
 =?utf-8?B?aSt0NUxYbTVRd0NCc0YzL3RVbjB3TXRVU2txQm14aFRwbU8zNVJsR1UxU0I3?=
 =?utf-8?B?Uko5TDRzYVoxaUpHVXBPYlZBUmU0cmJ4eTFLamIxeE9FdFR5OVVmVVJGZ0Mw?=
 =?utf-8?B?a1ZaTTdzOTY0OGZlcDBzR1dFSENQNElpeEdGZTY5cWE4dGJpTEh3aGRMWTFk?=
 =?utf-8?B?eU0yZk9BTDNzM0NOd1huRDNtOUkrMlZXNEhqN3pMMGJVL0ZIQVRTcTVvKzJQ?=
 =?utf-8?B?NW1jQWo5a1RFb3dpNTJZNVFCUlZoYmJGQTl4YUN5bVlHMHBJVk5MZE5QbVkz?=
 =?utf-8?B?UENINGRoMENBS0phS1pjWWJ4Tnc0V1U4b1JUZGkvdUh3QkxmS0lYZURESEw5?=
 =?utf-8?B?blY2a2cvbmJJSExKVVNMUFhFbmFxMlVoVWhYUzh2d0poOWVvbWU1UXhKMVJ3?=
 =?utf-8?B?UXhjYlZjVVJCaUZDcUpQWENRaFZSZVRsVHRncU1EbzJJUEdRVm14UDhSeDlv?=
 =?utf-8?B?MmRFMHV0emRPU0pYTHVleTZpOEFkeWpwQ0d0WnV5dUkzNDlBWmxjZEk0OStN?=
 =?utf-8?B?SHR2aWFxYi9sT1RhMk5MQnp0bm8xUzF5MzVPQ0RXOFNtL2hTTHQ0Mmg2eTZm?=
 =?utf-8?B?endBczRIYjhWWDVtRThaV3NjMDZFUDl2RGpoVzY4ejNqTzYyMG9SS1BkWlNS?=
 =?utf-8?B?YVMwWCt2YzNwb3F3UFpHbHNNU1VLQzI4YXNjTnovcmk1TkJ5R3k5czdnSVZi?=
 =?utf-8?B?Q3JZai9veWpxcDQ1UEJMRkNJRElnK09NUlRJZHNuZUhiS1d2aVRFZ01xZVVy?=
 =?utf-8?B?eWJpZEozRmF6NFNnalRhcFoxRE9kRkpBSkdGQThoY1ArSHBGSzFwR3A2cU9Y?=
 =?utf-8?B?aEVNRmQxVUplZUZNczRlbWljcENWb3VLUGFxaC9tMVVuVjVKbllWSHV2QTNG?=
 =?utf-8?B?N2xrOWtibUM4eFRzOWJiZW9jUlBsZ201bnYrYWZoa296dzZqK1VLdThpOFZI?=
 =?utf-8?B?ZjRFM2Z4eTh2bEZycGpsQlc5M2dIMFcxb0oxb21CVlFvRVhkVzZBZUxQZGFP?=
 =?utf-8?B?U2tnaTExckFaUWxac0pTTGIzQ1JsdnkyUVkrWk0xT1YvSTJmaFBydTJQdyto?=
 =?utf-8?B?TnJVYzY5MmpPSG5PcVVjYnZLd0F4U3d1TFdPN2c3aWVib3d1RXJlTnppTS8r?=
 =?utf-8?B?bUJGMTBqN0dzU1VRNEVNb0RDbXRqUVRZUlJMOFlpd2s4K3daejJRNWNVNjBJ?=
 =?utf-8?B?SjRUMkdtNnNmVEJXYzRVV3FoMnR3R1N5dytQeEkzOVNBanRMUTNWVE9EcFpK?=
 =?utf-8?B?ODR5NnBveUtVWXBBbi9QdURnMEtrOGFzWVlhWG5wYUkyQ1NSR2RqTWY1RnY2?=
 =?utf-8?B?T0htZll1ZDkrTHB1Z1BtNGdGbjNVam9SOWNTNDg2M1BBNlVIT3BmQythVWNn?=
 =?utf-8?B?WjBXV2RrQ1BKamFXdkFraVU3Vjdsb0luU3JIWHZRampVUklKYjhhRXBhRldo?=
 =?utf-8?B?N0pvYTM5ZkU2aWRnWHNYMWRBRmtTSEI4NlJJVVIrOU9BK20wUmo0cWF4cnpt?=
 =?utf-8?B?U2RpakVLWWxZRmpKbTBuSnJhaitITUYwRWpvV3lKSVBVUG5VU0hmdHBObzNn?=
 =?utf-8?B?dDJHUXBCS3RpWFc0aUFVT2NxaXQ5WVhraWx3Vy9IdXVVc2U0bFd3T1k1eVNy?=
 =?utf-8?Q?Vo2+b7Fi2HnZtnjnIk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccd9943-31dc-4662-2256-08d9876c796c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 19:23:41.1509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AuhM+ckvKZsVsFS5nTlYSpuWkERZ3hhhBrmKQhqyuMZTY9o/IetptG3C/duiO2fJIgGw1wlquMrCKIsxuSXPD1fe5SSwVlnCMX0oaS6zL5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogMDQgT2N0b2JlciAyMDIxIDE5OjU2DQo+IFRv
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+OyBEYXZpZCBTLiBNaWxsZXIN
Cj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
Pg0KPiBDYzogU2VyZ2VpIFNodHlseW92IDxzZXJnZWkuc2h0eWx5b3ZAZ21haWwuY29tPjsgR2Vl
cnQgVXl0dGVyaG9ldmVuDQo+IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtDQo+IEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1a2EN
Cj4gPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvIFNoaW1vZGENCj4gPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
cmVuZXNhcy0NCj4gc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47IEJpanUNCj4gRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZCA8cHJhYmhha2FyLm1haGFkZXYtDQo+IGxhZC5yakBi
cC5yZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxMC8xMF0gcmF2YjogSW5pdGlh
bGl6ZSBHYkV0aGVybmV0IEUtTUFDDQo+IA0KPiBPbiAxMC8xLzIxIDY6MDYgUE0sIEJpanUgRGFz
IHdyb3RlOg0KPiANCj4gPiBJbml0aWFsaXplIEdiRXRoZXJuZXQgRS1NQUMgZm91bmQgb24gUlov
RzJMIFNvQy4NCj4gPiBUaGlzIHBhdGNoIGFsc28gcmVuYW1lcyByYXZiX3NldF9yYXRlIHRvIHJh
dmJfc2V0X3JhdGVfcmNhciBhbmQNCj4gPiByYXZiX3JjYXJfZW1hY19pbml0IHRvIHJhdmJfZW1h
Y19pbml0X3JjYXIgdG8gYmUgY29uc2lzdGVudCB3aXRoIHRoZQ0KPiA+IG5hbWluZyBjb252ZW50
aW9uIHVzZWQgaW4gc2hfZXRoIGRyaXZlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUg
RGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFBy
YWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+IC0t
LQ0KPiA+IFJGQy0+djE6DQo+ID4gICogTW92ZWQgQ1NSMCBpbnRpYWxpemF0aW9uIHRvIGxhdGVy
IHBhdGNoLg0KPiA+ICAqIHN0YXJ0ZWQgdXNpbmcgcmF2Yl9tb2RpZnkgZm9yIGluaXRpYWxpemlu
ZyBsaW5rIHJlZ2lzdGVycy4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmggICAgICB8IDIwICsrKysrKystLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgNTUNCj4gPiArKysrKysrKysrKysrKysrKysrKy0tLS0N
Cj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBk
ODNkM2I0ZjNmNWYuLjVkYzEzMjQ3ODZlMCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yi5oDQo+IFsuLi5dDQo+ID4gQEAgLTgyNCw2ICs4MjYsNyBAQCBlbnVtIEVDU1Jf
QklUIHsNCj4gPiAgCUVDU1JfTVBECT0gMHgwMDAwMDAwMiwNCj4gPiAgCUVDU1JfTENITkcJPSAw
eDAwMDAwMDA0LA0KPiA+ICAJRUNTUl9QSFlJCT0gMHgwMDAwMDAwOCwNCj4gPiArCUVDU1JfUEZS
SQk9IDB4MDAwMDAwMTAsDQo+IA0KPiAgICBEb2N1bWVudGVkIG9uIGdlbjMgYW5kIFJaL0cyTCBv
bmx5Pw0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+IGluZGV4IDNlNjk0NzM4ZTY4My4uOWE0ODg4NTQzMzg0IDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+IFsuLi5dDQo+
ID4gQEAgLTQ0OSwxMCArNDYxLDM1IEBAIHN0YXRpYyBpbnQgcmF2Yl9yaW5nX2luaXQoc3RydWN0
IG5ldF9kZXZpY2UNCj4gPiAqbmRldiwgaW50IHEpDQo+ID4NCj4gPiAgc3RhdGljIHZvaWQgcmF2
Yl9lbWFjX2luaXRfZ2JldGgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+ID4gLQkvKiBQ
bGFjZSBob2xkZXIgKi8NCj4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZf
cHJpdihuZGV2KTsNCj4gPiArDQo+ID4gKwkvKiBSZWNlaXZlIGZyYW1lIGxpbWl0IHNldCByZWdp
c3RlciAqLw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCBHQkVUSF9SWF9CVUZGX01BWCArIEVUSF9G
Q1NfTEVOLCBSRkxSKTsNCj4gPiArDQo+ID4gKwkvKiBQQVVTRSBwcm9oaWJpdGlvbiAqLw0KPiAN
Cj4gICAgIFNob3VsZCBiZToNCj4gDQo+IAkvKiBFTUFDIE1vZGU6IFBBVVNFIHByb2hpYml0aW9u
OyBEdXBsZXg7IFRYOyBSWCAqLw0KPiANCj4gPiArCXJhdmJfd3JpdGUobmRldiwgRUNNUl9aUEYg
fCAoKHByaXYtPmR1cGxleCA+IDApID8gRUNNUl9ETSA6IDApIHwNCj4gPiArCQkJIEVDTVJfVEUg
fCBFQ01SX1JFIHwgRUNNUl9SQ1BUIHwNCj4gPiArCQkJIEVDTVJfVFhGIHwgRUNNUl9SWEYgfCBF
Q01SX1BSTSwgRUNNUik7DQo+ID4gKw0KPiA+ICsJcmF2Yl9zZXRfcmF0ZV9nYmV0aChuZGV2KTsN
Cj4gPiArDQo+ID4gKwkvKiBTZXQgTUFDIGFkZHJlc3MgKi8NCj4gPiArCXJhdmJfd3JpdGUobmRl
diwNCj4gPiArCQkgICAobmRldi0+ZGV2X2FkZHJbMF0gPDwgMjQpIHwgKG5kZXYtPmRldl9hZGRy
WzFdIDw8IDE2KSB8DQo+ID4gKwkJICAgKG5kZXYtPmRldl9hZGRyWzJdIDw8IDgpICB8IChuZGV2
LT5kZXZfYWRkclszXSksIE1BSFIpOw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAobmRldi0+ZGV2
X2FkZHJbNF0gPDwgOCkgIHwgKG5kZXYtPmRldl9hZGRyWzVdKSwNCj4gPiArTUFMUik7DQo+ID4g
Kw0KPiA+ICsJLyogRS1NQUMgc3RhdHVzIHJlZ2lzdGVyIGNsZWFyICovDQo+ID4gKwlyYXZiX3dy
aXRlKG5kZXYsIEVDU1JfSUNEIHwgRUNTUl9MQ0hORyB8IEVDU1JfUEZSSSwgRUNTUik7DQo+ID4g
Kw0KPiA+ICsJLyogRS1NQUMgaW50ZXJydXB0IGVuYWJsZSByZWdpc3RlciAqLw0KPiA+ICsJcmF2
Yl93cml0ZShuZGV2LCBFQ1NJUFJfSUNESVAsIEVDU0lQUik7DQo+IA0KPiAgICBUb28gbXVjaCBy
ZXBldGl0aXZlIGNvZGUsIEkgdGhpbmsuLi4NCg0KQ2FuIHlvdSBwbGVhc2UgY2xhcmlmeSB3aGF0
IGFyZSB0aGUgY29kZXMgcmVwZXRpdGl2ZSBoZXJlPw0KDQo+IA0KPiA+ICsNCj4gPiArCXJhdmJf
bW9kaWZ5KG5kZXYsIENYUjMxLCBDWFIzMV9TRUxfTElOSzEsIDApOw0KPiA+ICsJcmF2Yl9tb2Rp
ZnkobmRldiwgQ1hSMzEsIENYUjMxX1NFTF9MSU5LMCwgQ1hSMzFfU0VMX0xJTkswKTsNCj4gDQo+
ICAgIENhbid0IGJlIGRvbmUgaW4gYSBzaW5nbGUgUk1XPw0KDQpXaWxsIGRvLg0KDQo+IA0KPiBb
Li4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
