Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A67D3D5607
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 11:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhGZIVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 04:21:05 -0400
Received: from mail-eopbgr1410130.outbound.protection.outlook.com ([40.107.141.130]:13387
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231728AbhGZIVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 04:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl8pfp1Xthxxx7ZrziYD9TRnAqUE1B8wqBYKmXKbz5SuaErEMYqbmM2mcwmjBfqt/PBUYy3Rb4z1i6OrzRCvhL7nC8hwVlTysTKSropi/87oTCPewC+N8W8WWNQGJnkksuSluEPfiL932zheMzCYsngOi4JH7o2vqhlGwj6OQj8pMkdS3KCmLzdNrT6nI3pFP4z1eKyQuOFij3QuWDRk/3rbJfiOlCFprp+Za97OIjTvhv3zWNZR3/g/sbY66Yst1xhNh+i+bREi6ho/7AsLVDOvxNIYhzzGehX+OW69Bs1v3Ni8RjOMjn/2637QmPZaRbjlsFSUT3xjdy9WVJSA1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SdSZE3NcGKFKyq2d9ipAV+fCUdIYY3BvgQ5OvQ7dyc=;
 b=N/6RtX+FJBGhgihogaweSS11ZhUenVlfDOSEscDdZPQPlh6R+Xar3i2QOqI0Vngcm+ymM7dIvK3y2h3fQh499UHwlZsPuXFqF6/jsgLEvUwXbcXYWB7c4nAWg7svAT8D3vkv/WTT1n9EqJZVql3g93AZJUc/ISOqnWTa08NfOrBsemjqpudmuF/sUM4L/EWs8hcOmUvrdpY0WNo9r+O9HGMta+rMPjerFb7pi7MTy3Iom1qlc2MHPpMitwsbzBNrexq+XEP9brswe7wv4Q9a6tIPtBGPLoNDAqQ1PpYacGl9G92lLV17J6Rc5Ona2Yy/R2vy47hZAx8nrtLExQbsjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SdSZE3NcGKFKyq2d9ipAV+fCUdIYY3BvgQ5OvQ7dyc=;
 b=hu4GoG2tz9+HtN6jp8BWff73/uJ4yGRh27E+yJBsX45E+VUyKzaujLb81CEApfktRHiwPmlCQluTeiPKuOdNuGvYbt3Kkb0PUP+YSpSoTtMHD2SPzAEZAHwHdLuSiu+eOegYKneh+QI79n1rGdO9l32S+WK+iq1cxQLXd8vOHf0=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4520.jpnprd01.prod.outlook.com (2603:1096:604:76::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Mon, 26 Jul
 2021 09:01:29 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 09:01:29 +0000
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
Subject: RE: [PATCH net-next 06/18] ravb: Factorise ptp feature
Thread-Topic: [PATCH net-next 06/18] ravb: Factorise ptp feature
Thread-Index: AQHXfwPcEE3uxo4VyE6TwdT22KqiVqtRDH2AgAPiWDA=
Date:   Mon, 26 Jul 2021 09:01:29 +0000
Message-ID: <OS0PR01MB5922DF642B0549BFCFCDA77C86E89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
 <bff55135-c801-0a9e-e194-460469688afe@gmail.com>
In-Reply-To: <bff55135-c801-0a9e-e194-460469688afe@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11708c24-d6bd-4052-d9dd-08d95013f524
x-ms-traffictypediagnostic: OSBPR01MB4520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB45205320B1014C95F538BFBC86E89@OSBPR01MB4520.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WHSDlnNXyYrKKe5Lz67oR4gR2FPelUPqv97TBzEUA5YG+ZvKqmoG7KTFmxgyhxNqI3VKn30HczMSL0+W0PbDOc2H6WsQv212aOGBV4VYZGhWclV9i8rjtjlwtc0U7S5h0XXefFHixRcHRMfVGOF8v28X/QS4OHPbAHxit7KjJcBXLSb4dlK4b9vjuh+LUZ8EHJkZFQoNXOdGXJ5dW/V4CJujsgV3JCiROQto1Kw2elMY1UksRZXA3Vkwnmqxps+8gtrsOeeLblnQnS8c/0JmRtOgtWgt8aWGJ01PlPucc4xQQy5GNO6lRCMnDJl2ZPd5BtTrF89AF8NEruT8kxTNaCsAm3NtPjo3Z4XqvEoozICjyMmVbCfDNtZqg7X8x5VxQS9ChozbBtI10/kQk+rYp8mfGgXWxHkU4vg6zRsEyevXIs5i54tAsXI6Ki4yLg2yewhcUSUnNtXHChv4y5UiZLjbdFn4/TVDabXCOjmTRt5juS7xZy2UcuQ0EP5CzTOFEna8jHUGo7zBSS0rNKRhY+RkHjNh3NnAZiOe6CfOFxETJxkdzOzZTVsyKzSLJbvb/8GgQygBg1l6W9N0mrfMEsLofvlUbDiPsC2GdMEsxpB95Tfd8tAXezLyA5134O8J1IRkV7kyFGqK6ByOLObgl3WJR8m7SKMJr8wmdjdLZDCtL26eBHsPch2UE9cpjnshZWopdtkbqmwkfzZLl5UKCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39850400004)(366004)(76116006)(6506007)(66446008)(64756008)(7696005)(53546011)(66476007)(66556008)(66946007)(33656002)(9686003)(26005)(107886003)(52536014)(5660300002)(8676002)(54906003)(71200400001)(186003)(8936002)(110136005)(86362001)(4326008)(478600001)(316002)(2906002)(7416002)(122000001)(83380400001)(38100700002)(55016002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVhqUEptaUZ3NE85UThPTjBoV2dVVTFLZmJyUnJOR05KamlQbE9SbmthWWNu?=
 =?utf-8?B?RGszWnlySW03V0JJdDFBRWxORXdTeEhXVTRET2hEY3lrWlhKOW05LzBDTWpa?=
 =?utf-8?B?RTRpbXRHb3RWbVczUzVSaisyOXhjcm00R0RvcG1iZnljcmluSDBqY3gyZUhk?=
 =?utf-8?B?MHFJZFVBUHJIRENFMzhSUmdrMy9Yb05MWVFxMTZyYTdhZkhkR3B4cUM4Q0RX?=
 =?utf-8?B?SG54TkswNTRqN0ZWV0ZVK2l3NDA1QlFrYStVVU5TUTJrazBIaHMvOEZMWXZK?=
 =?utf-8?B?SUFhMWQ2WDJsWVFwQ1FnK0E5Z05GRkpyeDcwMW1KeEROV1Jwc3dRelpkYW9u?=
 =?utf-8?B?Q013RzMwaGpFQjVvZkpnaFpjUlZyWExEVUlNVnI5VmR4V3JkWUQzTFM5bU1O?=
 =?utf-8?B?QVlSYUpoT1p0bjc2ZHN0WGo3ZzNUU09teTEvS1ZkeUlYbzVNK3hobWp5TFl0?=
 =?utf-8?B?aEMvN2R5UkxzYUhpdkJwK0IzWnFVYWRmTHFwTCtBQUlRZlZQR0NLN3ppRHZr?=
 =?utf-8?B?c2ZHR09DNm84TFp0Z09INk5LU1Q0bTByWkJBZUNJNEpBd0M3U2htUG9Xd1NU?=
 =?utf-8?B?YXlldSt3VEdjR1NCby9zcWk3QmlEcGdQMkJySld1ejRyUW5JZUpuVUlNbFVC?=
 =?utf-8?B?MHdIb3NQNUFkd01NQ0RFQlBmWmc3TGR3TzVZWENiYnR0VENXY3J1WmluLzR4?=
 =?utf-8?B?Z2RZZ2wrTmNGNmNNSkEwdlQzWUhlL2RSeDJlR0dheE5UOGRBRkRQWGFMSnJu?=
 =?utf-8?B?WmhmaFVvMHFSTDFTTDR0Rlh2VjRiVzN6TlRqdzJ5ZWI5eFlDMGVjWXFVUnRh?=
 =?utf-8?B?N25iNmdtTGgzRUJJR3d1c1VidHpGMDE4a2RHS1V3V0x6Z3UrUm9PS0FhbEFh?=
 =?utf-8?B?dHlnYkhQYWt2YWdVSnRMbE5DaDErZjJBSElSNzV4U0pJcWhpOVkyTkJodFU1?=
 =?utf-8?B?UEhnNjVRZG91TEUrK0xiYnVRbkt4bUgxYUZpR1AzK0dPRXZKVDByMUU5ZDkw?=
 =?utf-8?B?NHlPa0xzWFJoc0FUcXFnWlFSWEtpbFF0SU5yd2RkSFlUdG96UmNwT0draEtR?=
 =?utf-8?B?c2IrRDFzMEU0cVVRZlBueHJzRFBwdmQ3QWtIY21UTjlNdy9pYXIwQTd4M1ZF?=
 =?utf-8?B?Zkh2cTYzYWRZbDNlakNZY2diUE9tdkFOeHlqSnloSVNGUmtmb1paOFc2N01k?=
 =?utf-8?B?WFk2U1g5SEpNMm8weUlCWU5EVUQycGhoN2t0YnllQXc3ckxaV0MrNXRSSlJ0?=
 =?utf-8?B?VUlYTXFWS3N3NW42TmJlK21iZFdIRlF0bzMyS2dkQ0FaVytNZzczQ0lxSkUz?=
 =?utf-8?B?K2FlMU5OYXg3TThCK1ZtcU5LMWJlZGhLaXZmQStUZkhGSFlEZHQwS2p2NnlI?=
 =?utf-8?B?MTBnWFJIQ2NTZUE0Z1VKMWJlaU5FVjRSKzAzckU2NEhHeDZaeE9zSFdLRzdm?=
 =?utf-8?B?cVUxaVYrSVMvb1ZjMUJib2ZLa2J3c2NtYmp4c0xnVjZ3TTRFYlJuRXNubzdH?=
 =?utf-8?B?SS8xdHlmbTRhbXp6VG54U08zc01tczNwU3gyRy9rajBrNmt5NGc0V2tmMklj?=
 =?utf-8?B?THl5dFNxR0xOVGNWMkZaLzBZek1TY0tHWmVxcGpFbSs1Z1Rqek9TTDNBbDFG?=
 =?utf-8?B?cFowQU41U2tlWjd0UHpWVUllcW1lMVdXWHJUQ3dJT1c3RmhGeUt5VlV2VTFY?=
 =?utf-8?B?TlBrelgxNENZM2lJQXVrcE5pRFlrZ08rUmNnNXRRV2p0ZXdVdDhkS0hUVHBG?=
 =?utf-8?Q?gytLORj7l3NQuVpGeVVaktk2tplzyH0gULXZiIm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11708c24-d6bd-4052-d9dd-08d95013f524
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 09:01:29.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CQ+kn25chRLuiuJWkWakvArfJ9Ly3noHGBwVvD/QZ+lL3fseV4aKCmrb2mWYd/if+3sugQ2FDg9anGwJqsBM9gLQBzgRpBFI7xiLyeU5iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4520
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDA2LzE4XSByYXZiOiBGYWN0b3Jpc2UgcHRwIGZlYXR1cmUNCj4gDQo+
IEhFbGxvIQ0KPiANCj4gT24gNy8yMi8yMSA1OjEzIFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+
ID4gR3B0cCBpcyBhY3RpdmUgaW4gQ09ORklHIG1vZGUgZm9yIFItQ2FyIEdlbjMsIHdoZXJlIGFz
IGl0IGlzIG5vdA0KPiANCj4gICAgSXQncyBnUFRQLCB0aGUgbWFudWFscyBzYXkuIDotKQ0KDQpP
ay4NCg0KPiANCj4gPiBhY3RpdmUgaW4gQ09ORklHIG1vZGUgZm9yIFItQ2FyIEdlbjIuIEFkZCBm
ZWF0dXJlIGJpdHMgdG8gaGFuZGxlIGJvdGgNCj4gPiBjYXNlcy4NCj4gDQo+ICAgIEkgaGF2ZSBu
byBpZGVhIHdoeSB0aGlzIHNpbmdsZSBkaWZmIHJlcXVpcmVzIDIgZmV0YXVyZSBiaXRzLi4uLg0K
DQpCYXNpY2FsbHkgdGhpcyBpcyBhIEhXIGZlYXR1cmUuDQoNCjEpIGZvciBSLUNhciBHZW4zLCBn
UFRQIGlzIGFjdGl2ZSBpbiBjb25maWcgbW9kZSAoUi1DYXIgR2VuMykNCjIpIGZvciBSLUNhciBH
ZW4yLCBnUFRQIGlzIG5vdCBhY3RpdmUgaW4gY29uZmlnIG1vZGUgKFItQ2FyIEdlbjIpDQozKSBS
Wi9HMkwgZG9lcyBub3Qgc3VwcG9ydCBwdHAgZmVhdHVyZS4NCg0KPiANCj4gPiBSWi9HMkwgZG9l
cyBub3Qgc3VwcG9ydCBwdHAgZmVhdHVyZS4NCj4gDQo+ICAgIEFoLCB0aGF0IGV4cGxhaW5zIGl0
LiA6LSkNCj4gICAgSXQgZG9lc24ndCBleHBsYWluIHdoeSB3ZSBzaG91bGQgYm90aGVyIHdpdGgg
dGhlIDJuZCBiaXQgaW4gdGhlIHNhbWUNCj4gcGF0Y2ggdGhvLi4uDQoNClNlZSBhYm92ZSBpdCBp
cyBIVyBmZWF0dXJlIGRpZmYgYmV0d2VlbiBSLUNhciBHZW4zIGFuZCBSLUNhciBHZW4yLg0KDQo+
IA0KPiA+IEZhY3RvcmlzZSBwdHAgZmVhdHVyZQ0KPiA+IHNwZWNpZmljIHRvIFItQ2FyLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29t
Pg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi1sYWQu
cmpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yi5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMgfCA4MQ0KPiA+ICsrKysrKysrKysrKysrKystLS0tLS0tLQ0KPiA+ICAy
IGZpbGVzIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IDBlZDIxMjYy
ZjI2Yi4uYTQ3NGVkNjhkYjIyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiBAQCAtOTk4LDYgKzk5OCw3IEBAIHN0cnVjdCByYXZiX2Rydl9kYXRhIHsNCj4g
PiAgCXNpemVfdCBza2Jfc3o7DQo+ID4gIAl1OCBudW1fdHhfZGVzYzsNCj4gPiAgCWVudW0gcmF2
Yl9jaGlwX2lkIGNoaXBfaWQ7DQo+ID4gKwl1MzIgZmVhdHVyZXM7DQo+IA0KPiAgICBZb3UgZGlk
bid0IGxpa2UgYml0ZmVsZHMgKGluIHNoX2V0aCkgc28gbXVjaD8gOi0pDQoNCk9LLiBJIHdpbGwg
Y2hhbmdlIHRvIGJpdCBmaWVsZHMsIGlmIHRoZXJlIGlzIG5vIG9iamVjdGlvbi4NCg0KPiANCj4g
Wy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+IGluZGV4IDg0ZWJkNmZlZjcxMS4uZTk2NmI3NmRmMzJjIDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTQwLDYgKzQwLDE0IEBA
DQo+ID4gIAkJIE5FVElGX01TR19SWF9FUlIgfCBcDQo+ID4gIAkJIE5FVElGX01TR19UWF9FUlIp
DQo+ID4NCj4gPiArI2RlZmluZSBSQVZCX1BUUF9DT05GSUdfQUNUSVZFCQlCSVQoMCkNCj4gPiAr
I2RlZmluZSBSQVZCX1BUUF9DT05GSUdfSU5BQ1RJVkUJQklUKDEpDQo+IA0KPiAgICBJZiBib3Ro
IGJpdHMgYXJlIDAsIGl0IG1lYW5zIEdiRXRoPw0KDQpZZXMgdGhhdCBpcyBjb3JyZWN0LiBwdHAg
aXMgbm90IHN1cHBvcnRlZCBpbiBHYkV0aC4NCg0KPiANCj4gPiArDQo+ID4gKyNkZWZpbmUgUkFW
Ql9QVFAJKFJBVkJfUFRQX0NPTkZJR19BQ1RJVkUgfA0KPiBSQVZCX1BUUF9DT05GSUdfSU5BQ1RJ
VkUpDQo+IA0KPiAgICBIbT8NCj4gDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFJBVkJfUkNBUl9HRU4z
X0ZFQVRVUkVTCVJBVkJfUFRQX0NPTkZJR19BQ1RJVkUNCj4gPiArI2RlZmluZSBSQVZCX1JDQVJf
R0VOMl9GRUFUVVJFUwlSQVZCX1BUUF9DT05GSUdfSU5BQ1RJVkUNCj4gDQo+ICAgIE5vdCBzdXJl
IHdodGVociB0aGVzZSBhcmUgbmVjZXNzYXJ5Li4uDQoNCklmIHRoZXJlIGlzIG5vIG9iamVjdGlv
biBmb3IgdXNpbmcgYml0IGZpZWxkcywgdGhlbiB0aGUgYWJvdmUgZGVmaW5pdGlvbnMgbm90IHJl
cXVpcmVkLg0KDQo+IA0KPiBbLi4uXQ0KPiA+ICAJfQ0KPiA+DQo+ID4gIAkvKiBnUFRQIGludGVy
cnVwdCBzdGF0dXMgc3VtbWFyeSAqLw0KPiA+IC0JaWYgKGlzcyAmIElTU19DR0lTKSB7DQo+ID4g
KwlpZiAoKGluZm8tPmZlYXR1cmVzICYgUkFWQl9QVFApICYmIChpc3MgJiBJU1NfQ0dJUykpIHsN
Cj4gDQo+ICAgIFRoaXMgaXMgbm90IGEgdHJhbnNwYXJlbnQgY2hhbmdlIC0tIHRoZSBmZWFydHVy
ZSBjaGVjayBjYW1lIGZyb21uDQo+IG5vd25lcmUuLi4NCg0KSSBoYXZlIGFkZGVkIGNvbW1pdCBz
dGF0ZW1lbnQgdG8gbWFrZSBpdCBjbGVhciwgIlJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IHB0cCBm
ZWF0dXJlLiBGYWN0b3Jpc2UgcHRwIGZlYXR1cmUNCnNwZWNpZmljIHRvIFItQ2FyIi4NCg0KRG8g
eW91IHNlZSBhbnkgaXNzdWVzIHdpdGggdGhpcz8gSWYgbmVlZGVkIHdlIGNhbiBmYWN0b3JpemUg
dGhpcyBwb3J0aW9uIG9mIHRoZSBjb2RlIGFnYWluIHRvIG1ha2UgDQpJdCBzaW1wbGVyLiBGaXJz
dCBwYXRjaCBpcyBwdHAgZmVhdHVyZSBmb3Igci1jYXIgZGlmZmVyZW5jZXMoUi1DYXIgR2VuMyBh
bmQgUi1DYXIgR2VuMikgYW5kIHNlY29uZCBwYXRjaCggd2l0aCAidHJhbnNwYXJlbnQiIGNvbW1l
bnRzIHlvdSBoYXZlIG1lbnRpb25lZCBpbiB0aGlzIHBhdGNoKQ0KDQpQbGVhc2UgbGV0IG1lIGtu
b3cuDQoNCj4gDQo+ID4gIAkJcmF2Yl9wdHBfaW50ZXJydXB0KG5kZXYpOw0KPiA+ICAJCXJlc3Vs
dCA9IElSUV9IQU5ETEVEOw0KPiA+ICAJfQ0KPiBbLi4uXQ0KPiA+IEBAIC0xMjc1LDcgKzEyODYs
OCBAQCBzdGF0aWMgaW50IHJhdmJfZ2V0X3RzX2luZm8oc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5k
ZXYsDQo+ID4gIAkJKDEgPDwgSFdUU1RBTVBfRklMVEVSX05PTkUpIHwNCj4gPiAgCQkoMSA8PCBI
V1RTVEFNUF9GSUxURVJfUFRQX1YyX0wyX0VWRU5UKSB8DQo+ID4gIAkJKDEgPDwgSFdUU1RBTVBf
RklMVEVSX0FMTCk7DQo+ID4gLQlpbmZvLT5waGNfaW5kZXggPSBwdHBfY2xvY2tfaW5kZXgocHJp
di0+cHRwLmNsb2NrKTsNCj4gPiArCWlmIChkYXRhLT5mZWF0dXJlcyAmIFJBVkJfUFRQKQ0KPiAN
Cj4gICAgQWdhaW4sIG5vdCB0cmFuc3BhcmVudC4uLg0KDQpTZWUgYWJvdmUuDQoNCj4gDQo+ID4g
KwkJaW5mby0+cGhjX2luZGV4ID0gcHRwX2Nsb2NrX2luZGV4KHByaXYtPnB0cC5jbG9jayk7DQo+
ID4NCj4gPiAgCXJldHVybiAwOw0KPiA+ICB9DQo+IFsuLi5dDQo+ID4gQEAgLTE5OTIsMTQgKzIw
MDksMjAgQEAgc3RhdGljIGludCByYXZiX3NldF9ndGkoc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAq
bmRldikgIHN0YXRpYyB2b2lkIHJhdmJfc2V0X2NvbmZpZ19tb2RlKHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2KSAgew0KPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2
KG5kZXYpOw0KPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfZHJ2X2RhdGEgKmluZm8gPSBwcml2LT5p
bmZvOw0KPiA+DQo+ID4gLQlpZiAocHJpdi0+Y2hpcF9pZCA9PSBSQ0FSX0dFTjIpIHsNCj4gPiAr
CXN3aXRjaCAoaW5mby0+ZmVhdHVyZXMgJiBSQVZCX1BUUCkgew0KPiA+ICsJY2FzZSBSQVZCX1BU
UF9DT05GSUdfSU5BQ1RJVkU6DQo+ID4gIAkJcmF2Yl9tb2RpZnkobmRldiwgQ0NDLCBDQ0NfT1BD
LCBDQ0NfT1BDX0NPTkZJRyk7DQo+ID4gIAkJLyogU2V0IENTRUwgdmFsdWUgKi8NCj4gPiAgCQly
YXZiX21vZGlmeShuZGV2LCBDQ0MsIENDQ19DU0VMLCBDQ0NfQ1NFTF9IUEIpOw0KPiA+IC0JfSBl
bHNlIHsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgUkFWQl9QVFBfQ09ORklHX0FDVElWRToN
Cj4gPiAgCQlyYXZiX21vZGlmeShuZGV2LCBDQ0MsIENDQ19PUEMsIENDQ19PUENfQ09ORklHIHwN
Cj4gPiAgCQkJICAgIENDQ19HQUMgfCBDQ0NfQ1NFTF9IUEIpOw0KPiA+ICsJCWJyZWFrOw0KPiA+
ICsJZGVmYXVsdDoNCj4gPiArCQlyYXZiX21vZGlmeShuZGV2LCBDQ0MsIENDQ19PUEMsIENDQ19P
UENfQ09ORklHKTsNCj4gICAgTm90IHRyYXNwYXJlbnQgYWdhaW4uLi4NCg0KU2VlIGFib3ZlLg0K
DQpGaXJzdCBDYXNlIGlzIGZvciBSLUNhciBHZW4zIHdoZXJlIHB0cCBpcyBhY3RpdmUgaW4gY29u
ZmlnIG1vZGUuDQpTZWNvbmQgQ2FzZSBpcyBmb3IgUi1DYXIgR2VuMiB3aGVyZSBwdHAgaXMgbm90
IGFjdGl2ZSBpbiBjb25maWcgbW9kZS4NClRoaXJkIENhc2UgaXMgZGVmYXVsdCBmb3IgUlovRzJM
IHdoZXJlIHB0cCBpcyBub3QgcHJlc2VudC4NCg0KRG8geW91IHNlZSBhbnkgaXNzdWVzIHdpdGgg
dGhpcz8NCg0KPiANCj4gWy4uLl0NCj4gPiBAQCAtMjE4MiwxMyArMjIwNSwxNSBAQCBzdGF0aWMg
aW50IHJhdmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgCS8q
IFNldCBBVkIgY29uZmlnIG1vZGUgKi8NCj4gPiAgCXJhdmJfc2V0X2NvbmZpZ19tb2RlKG5kZXYp
Ow0KPiA+DQo+ID4gLQkvKiBTZXQgR1RJIHZhbHVlICovDQo+ID4gLQllcnJvciA9IHJhdmJfc2V0
X2d0aShuZGV2KTsNCj4gPiAtCWlmIChlcnJvcikNCj4gPiAtCQlnb3RvIG91dF9kaXNhYmxlX3Jl
ZmNsazsNCj4gPiArCWlmIChpbmZvLT5mZWF0dXJlcyAmIFJBVkJfUFRQKSB7DQo+IA0KPiAgICBO
b3QgdHJhbnNwYXJlbnQgZW5vdWdoIHlldCBhZ2Fpbi4uLg0KDQpTZWUgYWJvdmUuDQoNCj4gDQo+
ID4gKwkJLyogU2V0IEdUSSB2YWx1ZSAqLw0KPiA+ICsJCWVycm9yID0gcmF2Yl9zZXRfZ3RpKG5k
ZXYpOw0KPiA+ICsJCWlmIChlcnJvcikNCj4gPiArCQkJZ290byBvdXRfZGlzYWJsZV9yZWZjbGs7
DQo+ID4NCj4gPiAtCS8qIFJlcXVlc3QgR1RJIGxvYWRpbmcgKi8NCj4gPiAtCXJhdmJfbW9kaWZ5
KG5kZXYsIEdDQ1IsIEdDQ1JfTFRJLCBHQ0NSX0xUSSk7DQo+ID4gKwkJLyogUmVxdWVzdCBHVEkg
bG9hZGluZyAqLw0KPiA+ICsJCXJhdmJfbW9kaWZ5KG5kZXYsIEdDQ1IsIEdDQ1JfTFRJLCBHQ0NS
X0xUSSk7DQo+ID4gKwl9DQo+ID4NCj4gPiAgCWlmIChwcml2LT5jaGlwX2lkICE9IFJDQVJfR0VO
Mikgew0KPiA+ICAJCXJhdmJfcGFyc2VfZGVsYXlfbW9kZShucCwgbmRldik7DQo+IFsuLi5dDQo+
ID4gQEAgLTIzNzcsMTMgKzI0MDQsMTUgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCByYXZi
X3Jlc3VtZShzdHJ1Y3QNCj4gZGV2aWNlICpkZXYpDQo+ID4gIAkvKiBTZXQgQVZCIGNvbmZpZyBt
b2RlICovDQo+ID4gIAlyYXZiX3NldF9jb25maWdfbW9kZShuZGV2KTsNCj4gPg0KPiA+IC0JLyog
U2V0IEdUSSB2YWx1ZSAqLw0KPiA+IC0JcmV0ID0gcmF2Yl9zZXRfZ3RpKG5kZXYpOw0KPiA+IC0J
aWYgKHJldCkNCj4gPiAtCQlyZXR1cm4gcmV0Ow0KPiA+ICsJaWYgKGluZm8tPmZlYXR1cmVzICYg
UkFWQl9QVFApIHsNCj4gDQo+ICAgIE5vdCB0cmFuc3BhcmVudCBlbm91Z2ggYWdhaW4uLi4NCg0K
U2VlIGFib3ZlLg0KDQpDaGVlcnMsDQpCaWp1DQo=
