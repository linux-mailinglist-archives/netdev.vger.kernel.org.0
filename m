Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7603DE711
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhHCHNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:13:40 -0400
Received: from mail-eopbgr1400090.outbound.protection.outlook.com ([40.107.140.90]:8722
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234099AbhHCHNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 03:13:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZcU/QgxZcTAQb4sYJzmRE5AbfDbTc0W67ANUn/MUojIXkDlPe10+P+umjGacxKedTZo1tOfSfuxg6ZzkKkP5VM7UlFIkbRoStOykaTZbH0QwCokOBJU/wvhrpigFV9/l/KNaCudDqxGh2d6c29UvFwXz5eI9as3AQFN9MCpYXUXMfszKrgnGEBmXEIJEOfNvurflXmytp6h+sCFgWVsXSZrJImnn3tahGhSCeUbulprElNAIsYD4SOmhjsvUX21Ib66/94/dgaGDVadjoy2RIM3V21Kzv90Aydgs4TUHp8sDvlGt29/su8u8VQ3laB2xEyB0W7zf3QpFX2T3k02vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IROyaDzIB1+C6TgdL3ld5dSSv/8z6fobVeax7gXQFgk=;
 b=ewtzpPEjerfPybrTfZ8Sc4P+wBAjK/7nep1je8yEkoPk7NvtnOcdmMg3dhTmmRt+0YYVB0ATvbPLCWI4Ah2pR3vTRyc7AntQJI11O5qb5JQNG/fSF98Evmsm0eF84KwN7C0EjBdRtHZCTJQB1ESmOU1t7Mpl44NoWeY5mP+O7X2SlrDWtxhuYTHvb+ziyB0KZecwcNetPc3M0hy/ysjWCDXDyND962vla/upgM9u6cxjn1TRcqF+LxCd9pYBNk9Xjl26EoMkCS6yglZRb7lJl9UwYHozr7tNuL9VMgCVDRWxmZZLryjjVx4/3zj8Humzw1MyuodZIVfIiFueAEnWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IROyaDzIB1+C6TgdL3ld5dSSv/8z6fobVeax7gXQFgk=;
 b=bvO/3O5r95J9UP2dI520/tE2lshdJByRZ2ZAOYQyffoK5CDVCY6E8MwQ4RnATBlJLOpRShDi3GWJdHLn7/84xkfuZNG61bCfGX63FQmsOSrN08fyLyGvgo+ZooTNrrS84rXsVVrRBc+rtshoXzwHW/HDOjvZ/Mkh1ipIXndPY8o=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2632.jpnprd01.prod.outlook.com (2603:1096:604:15::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 07:13:27 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 07:13:26 +0000
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
Subject: RE: [PATCH net-next v2 2/8] ravb: Add skb_sz to struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 2/8] ravb: Add skb_sz to struct ravb_hw_info
Thread-Index: AQHXh4j3+qo7v7hTDUWzD4UdIscP/6tgsjcAgACq8VA=
Date:   Tue, 3 Aug 2021 07:13:26 +0000
Message-ID: <OS0PR01MB5922BC0F748E4FDC4FA904EB86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-3-biju.das.jz@bp.renesas.com>
 <58df29d2-c791-df23-994f-7d6176f79fb3@gmail.com>
In-Reply-To: <58df29d2-c791-df23-994f-7d6176f79fb3@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 285e9893-572e-445e-a089-08d9564e305d
x-ms-traffictypediagnostic: OSBPR01MB2632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB263258F44C1147A90434457786F09@OSBPR01MB2632.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4nSXtmXjUtdIQIyKTo0IOHWTsUUyUdGrhLwgbktJSHoRssxKGQEXrs+NoGUz0D5zvA5QFtPLbNAlnfqO2berXOZwAeefzsz0evlCpPYa5DbnIdhCmE12ivkqitBIJu3pH9QjVTjZCOWqO9h45hE/sJxVVEGr3iqodE+fTsVgeyVd4ULUdx9HA7STYOi7NTVp0agicd8DR0xG8MzV1WAX7Al1MAbAltR01sWGjhw9ViPKp5DPe9cDpOGUblIcoJzM99Z1hK5LiRI5w+0p+/VrIiC7JLYQhO1Mg53LbE7uypRVsz1K+D2egOeNwELY50xlbGoYi5lkze1ltcyNOT9lqpoM7zRZd/cfaBIe0sz1mWAx+3FQCK+fXhkxvELYSDta+zPdK09AXL5dtC+rpDQHZrwupnSgUdqwazg5UAdYuzYqWK9e4rLWg3KmES24nAQag59jW/2yg199yWgE8LZFQVVoebdT3J5ECBubnthvUjnFFZyFx9LLctTkhPLHyKwOCm0zdv9omzYvJu+37nR4twkhWsPLGCq34vWQGwYRiy6+EvdhYWjXekLF90+CgqifoVTpN+h2HvNKbnNLUqbqcJTlce6onRfQHhJDiFDZG+Iih/iILgp09OZgFqSmxaQQaplowPHg+/MlAj6jf7esg2pO3ZtwomTSLo9VrckD5er4EpXXag83IYldwLO6TzUheyvOrZ2z6Mmr+TqszaTAdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(71200400001)(86362001)(316002)(6506007)(53546011)(8676002)(122000001)(38100700002)(508600001)(66476007)(55016002)(9686003)(2906002)(66556008)(54906003)(64756008)(66946007)(66446008)(7416002)(8936002)(7696005)(83380400001)(26005)(76116006)(5660300002)(110136005)(52536014)(107886003)(38070700005)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzdNUTQ1b2oycFNBbzVESEZpeTVzdDhrTzg3YlE5YjVPK2kyQ1VteG9NMjFx?=
 =?utf-8?B?K3BSL0ZiMmlmSzBSRVUvbVZ5TkQ0YkdNanZZN2NmdGpud2xCVDJvNDNmWTJ5?=
 =?utf-8?B?TjFJTkc0QktZR1c5VnduSnU5VXRaNE10bFJ4N2FkcVQ2czhibUtzMGlETVFI?=
 =?utf-8?B?WUkxZ3BYK3NmZmk1eTh2clBhdklsWVFYdWRDOFQ1R1ZKc1VPZzRkN0ZBSEhq?=
 =?utf-8?B?ZmdyUnFWY29kN0lPK2YrMndJRW8zRXdrN2FSSVlNRmFHVzZ3R05lTm1CV3pl?=
 =?utf-8?B?NTlBRXhDeDBESVE0RzFRRkRxQVJFRitZUkV6L3N4Y0VMVzlZNmRzMExKNUtr?=
 =?utf-8?B?Y0JWVG5GRU5UM3NXOXZiMGVUNVdrZlp2Ny96SnA0ZGhxK3AwVnpMdWFDWHBF?=
 =?utf-8?B?Nkg2RzlTT2ZLNnZmTW9ieFZLeVVDRlNhbVkxVDdCaU4rVWxyLzZSRDNUSTJy?=
 =?utf-8?B?UUNUSjdTNVptWkpxMjVGMG11ZmdSd0ptamZOSGNXYmZ2MkwzVnd6cFBVY3hS?=
 =?utf-8?B?T1pja3ZoUUtSM05NWnV3b2JVMEFJeE5peXVCQ1RSSThpekJPeE5VS2NTVStQ?=
 =?utf-8?B?cXNGOXdQTDdueUM0TmVTZTVicW80b2VEMkczOFI1dVJ5bXk2aDkzejBKMTNP?=
 =?utf-8?B?NUxjSVBLUW1yK0RiOTk4ZkZUZmNNd0cxaVFXNXBwWU50L0dibEM5bHBCdkJR?=
 =?utf-8?B?czkrd2ZpbzBKdmNJckUxUkQvV2ttNm00dnRnMjBSYzU3Q1ZkUEJkQWtYakdj?=
 =?utf-8?B?WFYrbjYvMCt5NDJ6WVVpczRhZFAzZEdJZ0d4c0EvUy9abWpRM0JJU3NJSDBx?=
 =?utf-8?B?OEZFM2FxaDBWOUkyUjdTQ21JYS8xc1BqRC9sa3ZTekdQRDRxNnMxY0FPNmIz?=
 =?utf-8?B?SWZ4VGZ3VUV2SnpieVlZWjJWTHU3K3BrdEpXKzhSY0FKTVh2UFdoUG5NMzV1?=
 =?utf-8?B?VWZ0QlFDdGR5MG4xeisraTdpTlBQS3hEUThzcVlreWVoeVJrRUZHMkZkRDVS?=
 =?utf-8?B?bWlpdE55Lzg5MGkwaGlZL0RvR21xZmxZOFAxSC9zcGRvU2YvTjdBc0NKV2l4?=
 =?utf-8?B?SXVPMU12UWQ5Z0FHeDNrQjl5ZzZEMmlhaG9oaWlxRTkxcGxURDRnTk8vc0JS?=
 =?utf-8?B?ZU9oanl0ZVdMRVJXMklCT09tanRScUcrZkZ4LzNTMFkvNG00cGtOaXJzQUlW?=
 =?utf-8?B?OHpzVjBjU011Y0tGcWxLYW96bmFEN2ZKSzE3cW5jQ0hpVTJHQit4Z2FYRmRD?=
 =?utf-8?B?dWxzYWZyVGg1a2ppZDRSZWYyZE9nZGR0NGRnazRmSjFEK3ZwU3kxQU8rRWkx?=
 =?utf-8?B?aFU2NUxwUjg4emZORy9UNlNudi9VdkwyN2NFRVorZkhlendOeWk0NExjWjNs?=
 =?utf-8?B?aXRUbFZ0bUF0dXFTM3ZpRkpzMmdqdGNORkI5ZUZ0Rk0rcTBMakhQVWF2RC83?=
 =?utf-8?B?cVFVZVMrRHp1aEc0VVJKVWVRRWNtaHJKQStkcjE0VmtCTFg1LzgzMlVINDgz?=
 =?utf-8?B?K0ppTHZtS1JPOUdDMGx6ZjhJb3BwWmxNdjdIUUtmbjlXc1YrT1BxejFRQ29E?=
 =?utf-8?B?WUQ4azVzTEQzb1ZROXpkOHM0eEt1OUt5UVFGWGwvQVlWUUJweFplUHh2QXg4?=
 =?utf-8?B?Nmp5eHdRbW82Q3BEYmNTcmZoWHpSQk9lR1ZFaGp6TVZDd2FOUHMzZUp3cGp3?=
 =?utf-8?B?T0tPcnFZaFNXS25qZVFGT0YxSUJpUUxZNFFrREpYcktmdnZaVTZLdmd6Umhl?=
 =?utf-8?Q?2yh61zIvSn3tg/N1QCcSKu7MDybuQ5ux5r+oVIE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285e9893-572e-445e-a089-08d9564e305d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 07:13:26.6474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXIjPBhv8sOlgDaRqsTmXJwq4QT+tK/Lz/Ved2Q6r2KVTOxOSMr8+RI8PZgQIfGkY7ygvvwcaPs31K+QWsF1cPlMMZwPtI1ZNidroei+FG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2632
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZXJnZWksDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0LW5leHQgdjIgMi84XSByYXZiOiBBZGQgc2tiX3N6IHRvIHN0cnVjdA0KPiBy
YXZiX2h3X2luZm8NCj4gDQo+IE9uIDgvMi8yMSAxOjI2IFBNLCBCaWp1IERhcyB3cm90ZToNCj4g
DQo+ID4gVGhlIG1heGltdW0gZGVzY3JpcHRvciBzaXplIHRoYXQgY2FuIGJlIHNwZWNpZmllZCBv
biB0aGUgcmVjZXB0aW9uDQo+ID4gc2lkZSBmb3IgUi1DYXIgaXMgMjA0OCBieXRlcywgd2hlcmVh
cyBmb3IgUlovRzJMIGl0IGlzIDgwOTYuDQo+ID4NCj4gPiBBZGQgdGhlIHNrYl9zaXplIHZhcmlh
YmxlIHRvIHN0cnVjdCByYXZiX2h3X2luZm8gZm9yIGFsbG9jYXRpbmcNCj4gPiBkaWZmZXJlbnQg
c2tiIGJ1ZmZlciBzaXplcyBmb3IgUi1DYXIgYW5kIFJaL0cyTCB1c2luZyB0aGUNCj4gbmV0ZGV2
X2FsbG9jX3NrYiBmdW5jdGlvbi4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxi
aWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWth
ciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+
IHYyOg0KPiA+ICAqIEluY29ycG9yYXRlZCBBbmRyZXcgYW5kIFNlcmdlaSdzIHJldmlldyBjb21t
ZW50cyBmb3IgbWFraW5nIGl0DQo+IHNtYWxsZXIgcGF0Y2gNCj4gPiAgICBhbmQgcHJvdmlkZWQg
ZGV0YWlsZWQgZGVzY3JpcHRpb24uDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMgfCAxMCArKysrKystLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IGNmYjk3MmMwNWIzNC4uMTZkMTcxMWEwNzMx
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtOTkx
LDYgKzk5MSw3IEBAIGVudW0gcmF2Yl9jaGlwX2lkIHsgIHN0cnVjdCByYXZiX2h3X2luZm8gew0K
PiA+ICAJZW51bSByYXZiX2NoaXBfaWQgY2hpcF9pZDsNCj4gPiAgCWludCBudW1fdHhfZGVzYzsN
Cj4gPiArCXNpemVfdCBza2Jfc3o7DQo+IA0KPiAgICBCYWQgbmFtaW5nIC0tIHJlZmVycyB0byBz
b2Z0d2FyZSBJU08gaGF0ZHdhcmUsIEkgc3VnZ2VzdCBtYXhfcnhfbGVuIG9yDQo+IHMvdGggb2Yg
dGhhdCBzb3J0Lg0KDQpGcm9tIHRoZSBhcGkgZGVzY3JpcHRpb24NCioJbmV0ZGV2X2FsbG9jX3Nr
YiAtIGFsbG9jYXRlIGFuIHNrYnVmZiBmb3Igcnggb24gYSBzcGVjaWZpYyBkZXZpY2UNCioJQGxl
bmd0aDogbGVuZ3RoIHRvIGFsbG9jYXRlDQoNClNpbmNlIGl0IGFsbG9jYXRlcyBza2J1ZmYsIEkg
dGhvdWdodCBza2Jfc3ogKHNpemUgb2Ygc2tiIGJ1ZmZlcikgaXMgYSBnb29kIG5hbWUuDQoNCklz
IHRoZXJlIGFueSByZXN0cmljdGlvbiBpbiBMaW51eCwgbm90IHRvIHVzZSBza2Jfc3ogYmVjYXVz
ZSBvZiANCiJzb2Z0d2FyZSBJU08gaGFyZHdhcmUiIGFzIHlvdSBtZW50aW9uZWQ/DQpJIG1heSBo
YXZlIGNob3NlbiBiYWQgbmFtZSBiZWNhdXNlIG9mIHRoaXMgcmVzdHJpY3Rpb24uIA0KDQpQbGVh
c2UgY29ycmVjdCBtZSwgaWYgdGhhdCBpcyB0aGUgY2FzZS4NCg0KUmVnYXJkcywNCkJpanUNCg==
