Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DA53DE6C7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhHCGhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:37:02 -0400
Received: from mail-eopbgr1400095.outbound.protection.outlook.com ([40.107.140.95]:21126
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233902AbhHCGhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 02:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa2aHHu74UGdPeNubJ5JvxdJYbihQdm8dRfEQIHw6rJRIJswkwnxgmz7bis6XQ2rFox4OAHQB2rHLpyIInD7P7LEXFPuRtW6vgIs3AvcbZHeuvxIqurFD4LolQJEOTlJuf/4IF7kqQIDBe1PBQcN9CPof45m09u4d3dYq4RtZbtti9VrqhTg6MNTFRiq0eNOwayS/vvTMehXefJ4jYNE9LhGyW7nZEFH3vSR5XyU7I2v8sVc8sFm8SDkWJSt/oaJhmIzWF8wCKoab7bwMs3bR2v483PvYbO63cU0smkufk3bMjvrDxHlEoebzUA45MIEL9bgJfdToswJilbfQDEWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTYCSqeUxSCXTdaa3CeeHSGnmQpTQO1sv27+VbvP0oQ=;
 b=fTDAMV3EXP979PlLRoBn8euOCbL2l+J9sCcT7CLCvU4NMLJkFjyZCAK5hv3NwhrdZjFuK+HGi67mrWbtMWoA6BgmV0BnoWZi5LmHzaW84a33TFCb2sza4kRmt9ldyiJJj1WzVD0BlJakzFZzU7XX2D3u3TkSV627pqdGKNx4tVX1YZ+Ku8+/oCJCjgjQ4AK9WVreFwG5qLFT1U0tT4B503K1bAbtkwp37iRGZLcmVFre0l4j5W+6T92sOymKaEzUUC5gu0jtacpR25zOEo3ifypNgqpbpZM5WYqWZBaI6LLhrjScpOC1Yn73wLF+5np+xmMsf3cgmUd8CeKij0vUfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTYCSqeUxSCXTdaa3CeeHSGnmQpTQO1sv27+VbvP0oQ=;
 b=rYhj8HnBSXiLaxQ4V8p0dPbaoLrZmgJahJDOjUleT+vdlFJx7T9PKBx46oHk6aabv1P9dOWFC/0+G4tdRY8V4QTFHCClR6IyH8tMvABvSa9eYA9I3MYUhAFUuJyV6Kj+nFzF2Ok9U1C59ZiaqUav5Ygc/yOFVpRw37SmEX1z23k=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4802.jpnprd01.prod.outlook.com (2603:1096:604:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Tue, 3 Aug
 2021 06:36:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 06:36:47 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Topic: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtgrrIAgACX9QCAAAwKcA==
Date:   Tue, 3 Aug 2021 06:36:46 +0000
Message-ID: <OS0PR01MB5922A5DA85FA9F59EEE92F7E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
 <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebdcdd15-6145-476f-e21c-08d95649113e
x-ms-traffictypediagnostic: OSAPR01MB4802:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4802E48D6242F8ED7B9AFED686F09@OSAPR01MB4802.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7rVK0a8PBvNrO2JcexO/AJkCtXl/unxoylBBvhiviIG57G4MUEayZJtSGyE++BBUb6oCPM+puRDOz5vVSK+v8FXisi2ykS5Mep+slvmTKNtwQgYbIXJAI3Oc1RsNaTHavMyayK2YZzbF8yO33WyCUlzS+Rlf8irhioodCjt9AaV+QEBcyh1Bh3cA8ZXpGm6fRizcfIacXD2ioIEmYNZpVaYYMkeZ8ylJaEa8ojgpkroE7zrzt7bGDyUVOJPga4cJUJ0mg4flm1xWUi18opQS0XZe6DaBfWjqIhubSdxqnDrZi9+SZaDHQ5GLQO/j//IsYffdAQ17RP9nC69al6ZyFchjr4cfzh25qClXuemFPO/fwneBy0QiJwtp3FMjsqNoFGHvTszB/X2SXNTvV4tD4BNKkuS5c6ER9bX2uXznnur65eKOBh91cK5oXLib9l7MhrbmS2BXuqVTgjpB7BJN5maGPI8Ob8z1KJtmSkg2aOIv7HOlfA+UUOvmgY9uO7CIxsfmYFfoEm2POo/UTtSv4J9PtYmBgYQTSs/eu3hKemlVKUsSI/xvYeypYF5O/DvwIt+Hxoyy3ZjQfGCkRA0M7Y1SOXBDDw/KGbpJvl+sSv9fsUc/49LElI4iZGG97QfbnwfdCm25AzoLWE69oDz1u22T6YT3FLchKJfEv8adzSHyMbjNdvKKmT8Jr46xhs5cIiUsioV593F7G83AHDPOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(83380400001)(478600001)(86362001)(53546011)(71200400001)(64756008)(66556008)(7696005)(66476007)(66446008)(66946007)(2940100002)(9686003)(4326008)(55016002)(8676002)(33656002)(107886003)(7416002)(6506007)(5660300002)(316002)(76116006)(2906002)(110136005)(54906003)(52536014)(26005)(38070700005)(8936002)(38100700002)(186003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVFUQXJDV1c1S293c2tqc0x0eEVmRUhrWFVlTGw4NWNHQjRPTGFnaThLZGh3?=
 =?utf-8?B?a3V0encwZ1Fic0FPcTdReitZQlVvMVpjL0wwUFQvbHpPK3ZpaDFWTTdVejUw?=
 =?utf-8?B?ZXVjNzJKd0FOcm5UeWZrbWwrQXA3dTdOeXVGRXkwTGYvQ04wdW41Njc4MmJj?=
 =?utf-8?B?V0pzZmhhekg2TVpneW80YURoWUFpQzh1V1g5SENRMDZqQ21NTEVpV0IrYXVs?=
 =?utf-8?B?cGt2UkxUemtaWm5vUFU5cklnakViVURTbFNSZ1g2eGMrTEluc1M4eFIrV3Nk?=
 =?utf-8?B?Q0p0cVR4Q28wV2lYSUFMdEVDZlJEVWJsbGhwRzJYNlFKV1FaL2ZzU1Jabktv?=
 =?utf-8?B?SjVVNGdkc1IyVk9ZckVONnVUT3Z4b1NDRDRLVzlLZ0IraUpHMEdSRlZZQ0JC?=
 =?utf-8?B?RExPZFovemRaYzRXMU5XSXFqQkh3dkg1clFZUFFlNGw2KzhkZWZNYStzOFlu?=
 =?utf-8?B?RkoybGNPZmJwNUptNnJCckp2dUxhMWZ1RWZKTEhSTVNRYjluREUvbG1TZHYx?=
 =?utf-8?B?ZHN2SDU4TnI5djlDa1p2WmJPd21iN2lpeWNkQ0ZlUjRRZ3JaM2J6bEUxaG8y?=
 =?utf-8?B?SStwNlU2VUZIUHZmQm9mZ3VpZytyNWxMOWVYc2dodDh1S0twOWVoTWxGb0FY?=
 =?utf-8?B?ZytTZ0VId2NMK2liVWtpcUdldGhIS0liR3ZhM2wrVDVGeE42M3ZKZ1hCbUR4?=
 =?utf-8?B?QUMrSUJtL2FGWUN0ekVTTDdmbUxEdms5cXhZeVZJNUx4eGxLZ2NmWi9UQUVz?=
 =?utf-8?B?emo2RDNzOTVhenNReit4d2ZZczZKS0l5djJUdDNJa1ZCdFpkTVJDYkZsdVBW?=
 =?utf-8?B?RFBUQWlBV1pvdWRyUytXY3ZXczVjK1lIRGhxQ0hYZTZ2RHpkVUoxWHEwV0J5?=
 =?utf-8?B?K1RjeFM3SXlvT2prMTg4TlF4VlRJTnZUTDdWWEprcWY1R2hVY0lhZXJHdWtC?=
 =?utf-8?B?MGRWYVptUmRnY09GZjVJdVBhaU5HMzN0NDhMSSt0dmR6ZUZ3RVFqTi9WUUU0?=
 =?utf-8?B?NS9RZXozVkZIVVRJS3pabFZzUVdWdUk3alEvYWRYTXJRU21xV1B5TGJaeGxT?=
 =?utf-8?B?UnNYRk1yNUY1SWloQTVsYXRGTjNvMlFQVWdzQWZNcU52Q1VDYVoyTURKMklr?=
 =?utf-8?B?VDdHZG5waWhSMXZuZ3JvSHpzTTFVYVZKYm9RSUFSNnVvSnpIYS9aenVldFZB?=
 =?utf-8?B?dGpMVG9iSEtIRHBsZFgzdGRGUkMvaG5tRkZ4NWFid2ZtL2dxZmxmdEpzNUVx?=
 =?utf-8?B?TWxweHI0S3p5ZGJJd3FnZ3k0amthRnErNHhSbkpuWkkzTGVuZHNtTXhUVUtq?=
 =?utf-8?B?RmY4N0tKakxCZDVGUm01ZGtzNzdNMDJ6aFF3R1prWXRwcE51azR6YlZDOW9W?=
 =?utf-8?B?ZmkvYVZ2RTZRUys4bVVmWEN4ZWhsdUlYRmNxOHRwTlBkbGdTcXRhenpJUDNm?=
 =?utf-8?B?YThqeFZtTVkxYjlhQVdDSVBGL2JOOG96amVDYStyNHRuTlloblJ2dkZ4QXZv?=
 =?utf-8?B?TnVleHhQOEwxc1ppQzJTZXRnblNsSUUybnlKRDJoSks2Z2xSd2FGVjdxME44?=
 =?utf-8?B?Qi9hU2pROEtld2E2cXpEQzFhdEtmRzNwb2xJR09jU0QzbTRWUzA3VXdKL0tM?=
 =?utf-8?B?TUFPZ25tZ2w0VDFlODlIV2FTaVJnNVB4RnhLc096cDVKbVhrbHh5VllMZ1Rk?=
 =?utf-8?B?NkJpWERlRzVoeEJhQzJZN0RqeHlGM1V3aFgzL0dPSjFTRHE0bVpoUSt5bGwr?=
 =?utf-8?Q?yH55CIUo9z/8Q8zx3VSfEA+wg28aO9OGcy2kUjG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdcdd15-6145-476f-e21c-08d95649113e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 06:36:47.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nh3ouV3JPiQId99HJybYFQHoyfyBLnWXQzQB5e9L7DikU3HA15g8mC0HPHsOA++2whcNzfCDA5jGvhgV1G0ZfY6e89duOMN3I59IW0dGMEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZi
OiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0bw0KPiBkcml2ZXIgZGF0YQ0KPiANCj4gSGkgU2Vy
Z2VpLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQo+IA0KPiA+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZiOiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0
bw0KPiA+IGRyaXZlciBkYXRhDQo+ID4NCj4gPiBPbiA4LzIvMjEgMToyNiBQTSwgQmlqdSBEYXMg
d3JvdGU6DQo+ID4NCj4gPiA+IFRoZSBETUFDIGFuZCBFTUFDIGJsb2NrcyBvZiBHaWdhYml0IEV0
aGVybmV0IElQIGZvdW5kIG9uIFJaL0cyTCBTb0MNCj4gPiA+IGFyZSBzaW1pbGFyIHRvIHRoZSBS
LUNhciBFdGhlcm5ldCBBVkIgSVAuIFdpdGggYSBmZXcgY2hhbmdlcyBpbiB0aGUNCj4gPiA+IGRy
aXZlciB3ZSBjYW4gc3VwcG9ydCBib3RoIElQcy4NCj4gPiA+DQo+ID4gPiBDdXJyZW50bHkgYSBy
dW50aW1lIGRlY2lzaW9uIGJhc2VkIG9uIHRoZSBjaGlwIHR5cGUgaXMgdXNlZCB0bw0KPiA+ID4g
ZGlzdGluZ3Vpc2ggdGhlIEhXIGRpZmZlcmVuY2VzIGJldHdlZW4gdGhlIFNvQyBmYW1pbGllcy4N
Cj4gPiA+DQo+ID4gPiBUaGUgbnVtYmVyIG9mIFRYIGRlc2NyaXB0b3JzIGZvciBSLUNhciBHZW4z
IGlzIDEgd2hlcmVhcyBvbiBSLUNhcg0KPiA+ID4gR2VuMiBhbmQgUlovRzJMIGl0IGlzIDIuIEZv
ciBjYXNlcyBsaWtlIHRoaXMgaXQgaXMgYmV0dGVyIHRvIHNlbGVjdA0KPiA+ID4gdGhlIG51bWJl
ciBvZiBUWCBkZXNjcmlwdG9ycyBieSB1c2luZyBhIHN0cnVjdHVyZSB3aXRoIGEgdmFsdWUsDQo+
ID4gPiByYXRoZXIgdGhhbiBhIHJ1bnRpbWUgZGVjaXNpb24gYmFzZWQgb24gdGhlIGNoaXAgdHlw
ZS4NCj4gPiA+DQo+ID4gPiBUaGlzIHBhdGNoIGFkZHMgdGhlIG51bV90eF9kZXNjIHZhcmlhYmxl
IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gYW5kDQo+ID4gPiBhbHNvIHJlcGxhY2VzIHRoZSBkcml2
ZXIgZGF0YSBjaGlwIHR5cGUgd2l0aCBzdHJ1Y3QgcmF2Yl9od19pbmZvIGJ5DQo+ID4gPiBtb3Zp
bmcgY2hpcCB0eXBlIHRvIGl0Lg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFz
IDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJh
Ymhha2FyIDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gPiAt
LS0NCj4gPiA+IHYyOg0KPiA+ID4gICogSW5jb3Jwb3JhdGVkIEFuZHJldyBhbmQgU2VyZ2VpJ3Mg
cmV2aWV3IGNvbW1lbnRzIGZvciBtYWtpbmcgaXQNCj4gPiBzbWFsbGVyIHBhdGNoDQo+ID4gPiAg
ICBhbmQgcHJvdmlkZWQgZGV0YWlsZWQgZGVzY3JpcHRpb24uDQo+ID4gPiAtLS0NCj4gPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgIDcgKysrKysNCj4gPiA+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgMzgNCj4gPiA+ICsr
KysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0
aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBpbmRleCA4MGU2MmNhMmUzZDMuLmNmYjk3MmMwNWIz
NCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5o
DQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ID4g
QEAgLTk4OCw2ICs5ODgsMTEgQEAgZW51bSByYXZiX2NoaXBfaWQgew0KPiA+ID4gIAlSQ0FSX0dF
TjMsDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiArc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4g
PiArCWVudW0gcmF2Yl9jaGlwX2lkIGNoaXBfaWQ7DQo+ID4gPiArCWludCBudW1fdHhfZGVzYzsN
Cj4gPg0KPiA+ICAgIEkgdGhpbmsgdGhpcyBpcyByYXRoZXIgdGhlIGRyaXZlcidzIGNob2ljZSwg
dGhhbiB0aGUgaC93IGZlYXR1cmUuLi4NCj4gPiBQZXJoYXBzIGEgcmVuYW1lIHdvdWxkIGhlbHAg
d2l0aCB0aGF0PyA6LSkNCj4gDQo+IEl0IGlzIGNvbnNpc3RlbnQgd2l0aCBjdXJyZW50IG5hbWlu
ZyBjb252ZW50aW9uIHVzZWQgYnkgdGhlIGRyaXZlci4NCj4gTlVNX1RYX0RFU0MgbWFjcm8gaXMg
cmVwbGFjZWQgYnkgbnVtX3R4X2Rlc2MuDQogICAgICANClNvIHRoZSBuYW1lIHNob3VsZCBiZSBv
ay4gDQoNCkluZGVlZCB3ZSBhcmUgYWdyZWVkIHRvIGFkZCBmdW5jdGlvbiBwb2ludGVycyB0byBz
dHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGF2b2lkIGFub3RoZXIgbGV2ZWwgb2YgaW5kaXJlY3Rpb24u
DQoNCklmIHRoZSBjb25jZXJuIGlzIHJlbGF0ZWQgdG8gZHVwbGljYXRpb24gb2YgZGF0YShpZSxw
cml2LT5udW1fdHhfZGVzYyB2cyBpbmZvLT5udW1fdHhfZGVzYykNCkkgaGF2ZSBhIHBsYW4gdG8g
cmVtb3ZlIHByaXYtPm51bV90eF9kZXNjIHdpdGggaW5mby0+bnVtX3R4X2Rlc2MgIGxhdGVyLg0K
DQpSZWdhcmRzLA0KQmlqdQ0KDQoNCg0KDQo=
