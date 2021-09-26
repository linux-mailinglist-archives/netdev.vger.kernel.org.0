Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C9841892E
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhIZN6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:58:43 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:32544
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231743AbhIZN6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxF1paF7Jsdlu528V3s0IfU/WWhDLew13sC4pLAsre9htnX6cr+HpWDf6NG2ZLfibbpKnsewD47cn3pJ0feGgMW4jTrubljlrOeSmnXfx5tA+ON2AYQCkZxGWHnpl/ck+V+VmBMDrrLeT1Zv/3pbFXN3D8qMXfa1Uch/Ert0mVrfMpkQFTXfIqQiq5IwlClARhIelODt3HXtcCN4A4lktE3jml6GVo23UGhILUSi19DjzlzoNj5JdVI43iKHgV6AvT9jgePWUNPuKbjo6O8/GjaFaRJ7BXeVEYZita5cXsc+9B35lkxwcUquu1/mTZe8j9cyi7llh5/Me8Un3a0J6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Yfd+v5bJlaPAuhyrtuQQuOscNxPCWerlKCb8ygw29Uc=;
 b=Oh5pu45dMMyOev6RB0Dpng6ut+I/uHKdZCp6XRChgj2SO6Rf1ID+PpSQtMouB1AylcKQN3a4/MnyOwSqd7tzDIZFOrPr0MdFfL2mtPQ6F/d7p4ouFIRXEEUA79Lcnh43fg3XUlTVfppQeQ0+kmi0TxamBdbmdoyUMYeRKdo1j8Moag9XB1S2LDfs7zLBNgFdjzLDicg0ONF9yzU0gGB3EEaRw4lCQCKCnD4Yx7Tzf1wsUBmLpS0CgkjuUw/Ps8c7jM3+D1uimSO/pxi5svVmqVhN6OxdcdaXv1Ck2FDg2QjFw81bzku1qg4maSOgeeZewLgqr6sfL18LdxDfeIkgvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yfd+v5bJlaPAuhyrtuQQuOscNxPCWerlKCb8ygw29Uc=;
 b=XFiropgMlmWwkfNLsb/8+gSME6e5k6RK0szb/fj0xZXfdQ3PM8QRiZuykyS4FIAvw7sMbl33Ok+F26etE8+Zwt89sYEo+KljWKUE8+9Nx5bfV83asmOPW/q0UwWNt699gY8D39QDMgJ42D35SE46Z8qCTXCPTw0AMfmdQKgVEQw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB5153.jpnprd01.prod.outlook.com (2603:1096:604:6b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Sun, 26 Sep
 2021 13:56:59 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:56:59 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
Thread-Index: AQHXsISFpoqrwDdNgk21tf8nTdCLNKuyFfWAgACha9CAA6PkYA==
Date:   Sun, 26 Sep 2021 13:56:59 +0000
Message-ID: <OS0PR01MB59226404CEE3EE227E2B5AC686A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-8-biju.das.jz@bp.renesas.com>
 <6bb4004f-2770-b67e-10ce-a438cb939148@omp.ru>
 <OS0PR01MB5922800C5282BDB42985A11286A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922800C5282BDB42985A11286A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b1ad7d5-ff75-4298-4e67-08d980f58296
x-ms-traffictypediagnostic: OSAPR01MB5153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB5153BC075293BD85EC8EC80886A69@OSAPR01MB5153.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HDesppj22rUV6J/LVMa0cUqbyKiNP1dQ65LF+4PHIEXxFyYpEayA2DNUm0o9JqzXS4gEh0zRJodVit75SQ6djdTDmFLje73aHRa7awYUO22MacFYQJSlYYlRtA6ikmA5uzr0LT4osa+JJidbXdxJyLYFHydwxbluHNHwsCl4rR7i/+Sxl7mqNH3QQbhLbCeP6117y8CufyODqM9jMGffSQr4Sa2le0KpdmmsrB5IFYLlJqImFMGfsLsZoqZ29azOxjhVC0rr37waiIHrpZQZyUIW8METJao9M+Nuo6OjdYLYOogn0fcc/wUcicisIderAgdOomzG+geSrPgMEcKYeOw4JMzvh2kYEZ3L2fqwPj1eelyqdPEGIhosdzlrMUROYIewAKTJC1+ZzSaIHwfzbT9SZmbj4KqO/idy2DoL0z0vuXOQ4o3vv90gLQ5dMxIgQFyd7qjR1ryY/kqlUMRH04WHE4QLg35i8XY1UCJKLrJ5lTDkgSc0C4eOjYJrujZNFJvuiDhUBlAAnbou2seTvzJdKHXTIS6OSHeqX2cVVrWig0LWLKYViHcmtWWBxRbqGyjq5sYfYii+kLv4pw3NC2YlUdAwwOqn/haVvOfi89Vn1rsQ5zMomLDUBq5gAJpDGLsSZK9J+kjvrz7S6dOdbcA9e7Qs8aGFzutZSORAj9lQFGJ0vZfhi4uhMmsRAtkfY/q3W5VfEduETyLRBZAgeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(86362001)(316002)(9686003)(52536014)(6506007)(26005)(53546011)(508600001)(110136005)(186003)(54906003)(83380400001)(38070700005)(122000001)(5660300002)(38100700002)(4326008)(2906002)(7696005)(107886003)(66946007)(71200400001)(66556008)(66476007)(55016002)(8936002)(64756008)(66446008)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEprWmNzZjlkYW4zZjE1K2pCWmJYRnFwSUZWeEwvc0ozbEJRWmErTURzNVNS?=
 =?utf-8?B?S25wb3V3TGhiS29GcEM3U0hqbmRKTmRnSFZadlpoZEdTeEpKYk1pTEsxL3lm?=
 =?utf-8?B?VlF2WnJid0JEUk5MM2VCc2EraktvM0NMclptM3U3WWJnUG1kZkpSeHkvV3Mz?=
 =?utf-8?B?T2Z1TmkvNTREekhuZUlxbVpCMUUyTTg4UFRVM2VRN0xJVTUrdkE5bDFmUjgr?=
 =?utf-8?B?VXpsejRYS2pIU2srMFQ5UnpoY1VqWFZFdDBLNDhsdEhNVThMQUVXWHF1N1I4?=
 =?utf-8?B?SnJBSVRQWGRRaTBweksyT3hiMzBGKzduRDdqMldwKzZSK0pNSmtMY3BqVG9y?=
 =?utf-8?B?U1pBVTdneW15Wll0SWE5Vkc1UVpqakltOWNtZGVtR2tRMnFLcGlYMXVsUXJP?=
 =?utf-8?B?WEtoWE5rVWt6QnM0MFBxWVZkVVNiSTgxTUZNb0tpRzhHNXRkV2JqR1VqSEdN?=
 =?utf-8?B?bkE5Z1ZQMzdvZi92d3o2c0I4NUIvQzZ1YVZWQ2lnbW9WbitualdXYjJrUEl0?=
 =?utf-8?B?dlJZdCtuNTJoNWRrb1JXb1JTUHIrWUJZQVVhQ1U1bkZ4TC9sbi94d0d5WUxP?=
 =?utf-8?B?NzdLd3E1MllTUkNnUU92RDVzeFFSeVZQVElKTkxEY3FTWjlyemlHWll0T3ox?=
 =?utf-8?B?SDQ3eStUZCs4UlZiUkZBb3RFakV1TEwwYk81aElsWEUzb1R6Ym0zZnRLN1dw?=
 =?utf-8?B?Z1U0a2VjMmY4WlhXeGNQckFZV1hqc1VVTDBDTVRRUDc0NlRrQjk1MklXTERR?=
 =?utf-8?B?cjcrK2hEazVHTm1rUlQ0YUJLcVZzbmd6UzFnam0vR3JLUlo3c2ppTWtiSi96?=
 =?utf-8?B?R1paR0dzWHhiV056NkZ1TW9jWGRVOWZFVkVhcWVEMi94TFY5bm9ld29DWG5S?=
 =?utf-8?B?dUtUZVVBWElzdVdmL3JDVUdhRzgyeXd0Y2YwdjFWdWUyNEV3ZGVqODhWaTVw?=
 =?utf-8?B?a09tWlEwVjhMVUJVV2Y4NW5nRStGQ0NkY0M4V1lUeXpPNmpBU2xvSTNYVnVT?=
 =?utf-8?B?bm1CdE4wK1dhaTFrNklTenoyaXA2Z0ZDQkFhMG1RNFV2QWVnMzhWZVp5a2Vi?=
 =?utf-8?B?cml6ckdkL1ZHU3NYbURtckdtODFJcE9hbTlDRXlmQVI5ZVpiYnJ6U3RMU2dW?=
 =?utf-8?B?N3dYVllOSWY4NngwbkJ3TTdJZGtueXBOYVkvblFJaU52YXN1c0lwejhxcTc4?=
 =?utf-8?B?ZUYwanJVYkZDMzNlSEYxWlJubmd3YVE0eFhoTDloM0tnd1RIcmZadXhDYUw0?=
 =?utf-8?B?WVQ3WGg3NHdCd0Q0Qko4OEprQ1EvTFBrL1JIVHBnU050ZDhzckREbkIwSzNm?=
 =?utf-8?B?ODd0SzFzNzRmWXlzblozYjU0TTZQaUk5SkFlRVBHbGtDVWovM1Q3NW56K2Rn?=
 =?utf-8?B?bWVKcGZ1N3JpUW40UUo4SEhwc1krRUZiNGtGZS80NUh1MFl4dmRXWDBoQnNr?=
 =?utf-8?B?Zk5UOWRYS0phNlo0WkFTd0UxQ2h4OVEwd1hFRHZCUUkycUpDWFhPZUt5Rk5X?=
 =?utf-8?B?ZnRIYXdTY3BsSkF5SGg0WEZkTkZzaHpDdHViYzBLRlJoVkppUWNwWDV4UVlv?=
 =?utf-8?B?V1dHM0JROVFwdU1nZlUxSjFNbHZzRUpJL0x3d2Z4aS9TMk9hVkVjZzk1WHVx?=
 =?utf-8?B?VHRtUnBJbjNjNFFJVnBSMExDSmpCa2czSWp6ODNDRFFSS05HV3UxUTU3UlRS?=
 =?utf-8?B?dHgyZzcydUZLYk5tRlVmTzRRNHlTL3B4eUVYOWRTSHowaVV2N1hVWExiaHMx?=
 =?utf-8?Q?Vey25/9khw1q/FVtuR8Aa11RhT1b2G/YGbu2Pvo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1ad7d5-ff75-4298-4e67-08d980f58296
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:56:59.4184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dVCP+JGbMe0dzXlrEL1mOj6zdUYktafTksx93aSU0DXAicsRj2mk6iOZHG8KEfv/gkFsUYiE0cmeKj1ZD69JNWudNdBp/Z137p5OXnKnFYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDA3LzE4XSByYXZiOiBBZGQg
bWFnaWNfcGt0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IEhpIFNlcmdlaSwNCj4gDQo+
IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KPiANCj4gPiBTdWJqZWN0OiBSZTogW1JGQy9QQVRD
SCAwNy8xOF0gcmF2YjogQWRkIG1hZ2ljX3BrdCB0byBzdHJ1Y3QNCj4gPiByYXZiX2h3X2luZm8N
Cj4gPg0KPiA+IE9uIDkvMjMvMjEgNTowOCBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4NCj4gPiA+
IEUtTUFDIG9uIFItQ2FyIHN1cHBvcnRzIG1hZ2ljIHBhY2tldCBkZXRlY3Rpb24sIHdoZXJlYXMg
UlovRzJMIGRvDQo+ID4gPiBub3Qgc3VwcG9ydCB0aGlzIGZlYXR1cmUuIEFkZCBtYWdpY19wa3Qg
dG8gc3RydWN0IHJhdmJfaHdfaW5mbyBhbmQNCj4gPiA+IGVuYWJsZSB0aGlzIGZlYXR1cmUgb25s
eSBmb3IgUi1DYXIuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFsuLi5dDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBpbmRleCBkMzdkNzNmNmQ5ODQu
LjUyOTM2NGQ4ZjdmYiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiA+IEBAIC04MTEsMTIgKzgxMSwxMyBAQCBzdGF0aWMgaW50IHJh
dmJfc3RvcF9kbWEoc3RydWN0IG5ldF9kZXZpY2UNCj4gPiA+ICpuZGV2KSAgc3RhdGljIHZvaWQg
cmF2Yl9lbWFjX2ludGVycnVwdF91bmxvY2tlZChzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ID4gKm5k
ZXYpICB7DQo+ID4gPiAgCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihu
ZGV2KTsNCj4gPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmlu
Zm87DQo+ID4gPiAgCXUzMiBlY3NyLCBwc3I7DQo+ID4gPg0KPiA+ID4gIAllY3NyID0gcmF2Yl9y
ZWFkKG5kZXYsIEVDU1IpOw0KPiA+ID4gIAlyYXZiX3dyaXRlKG5kZXYsIGVjc3IsIEVDU1IpOwkv
KiBjbGVhciBpbnRlcnJ1cHQgKi8NCj4gPiA+DQo+ID4gPiAtCWlmIChlY3NyICYgRUNTUl9NUEQp
DQo+ID4gPiArCWlmIChpbmZvLT5tYWdpY19wa3QgJiYgKGVjc3IgJiBFQ1NSX01QRCkpDQo+ID4N
Cj4gPiAgICBJIHRoaW5rIG1hc2tpbmcgdGhlIE1QRCBpbnRlcnJ1cHQgd291bGQgYmUgZW5vdWdo
Lg0KPiANCj4gQWdyZWVkLg0KPiANCj4gPg0KPiA+ID4gIAkJcG1fd2FrZXVwX2V2ZW50KCZwcml2
LT5wZGV2LT5kZXYsIDApOw0KPiA+ID4gIAlpZiAoZWNzciAmIEVDU1JfSUNEKQ0KPiA+ID4gIAkJ
bmRldi0+c3RhdHMudHhfY2Fycmllcl9lcnJvcnMrKzsNCj4gPiA+IEBAIC0xNDE2LDggKzE0MTcs
OSBAQCBzdGF0aWMgdm9pZCByYXZiX2dldF93b2woc3RydWN0IG5ldF9kZXZpY2UNCj4gPiA+ICpu
ZGV2LCBzdHJ1Y3QgZXRodG9vbF93b2xpbmZvICp3b2wpDQo+ID4NCj4gPiAgICBEaWRuJ3QgeW91
IG1pc3MgcmF2Yl9nZXRfd29sKCkgLS0gaXQgbmVlZHMgYSBjaGFuZ2UgYXMgd2VsbC4uLg0KPiAN
Cj4gSSBkb24ndCB0aGluayBpdCBpcyByZXF1aXJlZC4gRnJhbWV3b3JrIGlzIHRha2luZyBjYXJl
IG9mIHRoaXMuIFBsZWFzZSBzZWUNCj4gdGhlIG91dHB1dCBmcm9tIHRhcmdldC4NCj4gDQo+IHJv
b3RAc21hcmMtcnpnMmw6fiMgZXRodG9vbCAtcyBldGgwIHdvbCBnIG5ldGxpbmsgZXJyb3I6IE9w
ZXJhdGlvbiBub3QNCj4gc3VwcG9ydGVkIHJvb3RAc21hcmMtcnpnMmw6fiMNCj4gDQo+ID4NCj4g
PiA+ICBzdGF0aWMgaW50IHJhdmJfc2V0X3dvbChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgc3Ry
dWN0DQo+ID4gPiBldGh0b29sX3dvbGluZm8gKndvbCkgIHsNCj4gPiA+ICAJc3RydWN0IHJhdmJf
cHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ID4gKwljb25zdCBzdHJ1Y3Qg
cmF2Yl9od19pbmZvICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPiA+DQo+ID4gPiAtCWlmICh3b2wt
PndvbG9wdHMgJiB+V0FLRV9NQUdJQykNCj4gPiA+ICsJaWYgKCFpbmZvLT5tYWdpY19wa3QgfHwg
KHdvbC0+d29sb3B0cyAmIH5XQUtFX01BR0lDKSkNCj4gPiA+ICAJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCj4gPiA+DQo+ID4gPiAgCXByaXYtPndvbF9lbmFibGVkID0gISEod29sLT53b2xvcHRzICYg
V0FLRV9NQUdJQyk7DQo+ID4gWy4uLl0NCj4gPg0KDQpBcyBkaXNjdXNzZWQsIHRoZSBuZXcgcGF0
Y2ggcmVtb3ZlcyBpbmZvLT5tYWdpY19wa3QgZnJvbSBpbnRlcnJ1cHQgcm91dGluZS4NCg0KUmVn
YXJkcywNCkJpanUNCg0K
