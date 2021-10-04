Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E2542121C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhJDO60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:58:26 -0400
Received: from mail-eopbgr1410137.outbound.protection.outlook.com ([40.107.141.137]:30952
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231911AbhJDO6Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 10:58:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6h9G8aMCreNS2/ltquF1lsVjL4k0YZ5A9iNNCqcGzXmzQiMwgt79MUqClFUp6dOZL4L4HPbXowwRWoikn0U2eRPi51jvWF1bP+yBxMqi0xKgOXkDZ+cHzGytLee6kwC1Jf90ZMs+gOYHzWFAWHs070w03GhuaSY/ZnYAHdwPSkBY0Va0XDjjV01YGu9frrzVlbvk4RMTnIPvZ3rOWZSV0X8nXYN2rR6zovrXLMcH0uFa/NZnki8DINjgzAAgiH3JNm3ganlBUEQpUguNKxiCAgQg5UEC74u+nLQW0U2X++aRu9TGlqaO29lRZfArG9btInXnHJLdlKC4VLFyzdUfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNeivmgVx/R2tLitT6F1sz8zHwXpw3aDllqzkSiianU=;
 b=hPx8qmt3cIcaXQM3rjooFMIgMiMLs/g2JPHidU0ZkEQTIcw9tbz9oRRGgdpqRwkmvpwnrCC15scLTcdEiQszva/8CF+sbAx3WC+qX85ufTypzm3r+DHOsAGgrxQjWevaTbffsYQiOyR1CeXzXGIMeII8iwVULKl8T3T0h1FgSv66nYpT7eNikOxuBS6qs+aWJ/nadG8mGmBhKUtR3yRipkkv8DOg928v0TFpxBel+reI8p/Vnu6XVxxULDLXWsCQkmD3AlfpnmwVjgFdUcadiRQSRLdVVN3HN6kRUeEgK7WzUfpkLlU1Rt4zslbF1kl0lhnO0PC/2Zxo/1wriVZfAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNeivmgVx/R2tLitT6F1sz8zHwXpw3aDllqzkSiianU=;
 b=JN0YB67Gv1Xm2dkgzDwACly2kFy0MaY224yXOYzHOSQQWajhsggRhFuk1qVVdE/f7HLwveykarE4oGXdhDzD8qH82awJER02skYGFb5oE4JWIdcKuiHVIZKVETZYBFHwb+Jg7h9NcvYuokHU3i2P7jSHn1jBXgvzDLFMBjChKMc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5957.jpnprd01.prod.outlook.com (2603:1096:604:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 14:56:34 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 14:56:34 +0000
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
Subject: RE: [RFC/PATCH 16/18] ravb: Add Packet receive function for Gigabit
 Ethernet
Thread-Topic: [RFC/PATCH 16/18] ravb: Add Packet receive function for Gigabit
 Ethernet
Thread-Index: AQHXsISdJXewNoyMPUClLgnmZDx2sau+ck4AgASGH2A=
Date:   Mon, 4 Oct 2021 14:56:33 +0000
Message-ID: <OS0PR01MB5922B9698903E199C211C57A86AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-17-biju.das.jz@bp.renesas.com>
 <82f58946-b88b-8990-8788-a58f8d1468c2@omp.ru>
In-Reply-To: <82f58946-b88b-8990-8788-a58f8d1468c2@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18ec91e4-7486-4e95-da68-08d9874728a6
x-ms-traffictypediagnostic: OS3PR01MB5957:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB595772575E5BEBEAA9EA93D386AE9@OS3PR01MB5957.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KOpSX7OiwMFZKabNBMORuylqhjm3a+O7olTCsJBw9tDaTywi1uNuc8Tf0d2yXPHx21p3nlypDolVOlCmDgXKzK08y5vNVm/IPRyO/RTXkuQnzELTi2cpIHUrAbS9+DOEnxD6PVXqI9HDH96eY/uzkpGmhTZq7DLRfLJj+IixRfCZ8KnW/6sEplEJ+/g3XYyZBcidOCcYlJHvSHKOie27SDETA8sPwNEUYxFkd8rL1a816Uwlu4Xgv1lFsbwknnBETiK5DOi3izBdAZuOctF8pdE7bDeaqNxazFmCHnQ+9qgqaLFrtfBYp7INkEFvCbvpDOZQ7aGSxMy93bDttGG5bInZIo8XfNDIIDSqfNsUcJqEbd7tedjRHdHZCyO/aGd5X5rZTka3nor9cjc5hpQ0dy31fnOcjbRF7VKEy8V8/Or+NGdeGIPplIMxDA0fzFn7ksRNQGs8OxNTB0Pwcpq/oiF3aPMHXW9+Vk9nd4FbPTa3ALBYEIaIMqgO5i6gL8Sc3DTtTX9lw9EmgTPfRShu5nFgA2JbqE4RjYwj0XoM1imfmHzU8cLUlZerzDmJslEiZJjyfJZSuiMbshvjOzPdV5qQJemsElALRlf3Sobt6uBwJOppCzM0KaPkRHfAxNvF/rcv0ZPS/8a4BrK0d9m/b7Lud0dvmHvQ1J+UFCQk/wBIf/Xu4It6lncEE7kch/oYU6oQnNzbcYiLLQSBAUJBpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(64756008)(66556008)(66946007)(55016002)(33656002)(9686003)(122000001)(66476007)(38100700002)(8676002)(8936002)(4326008)(86362001)(52536014)(508600001)(7696005)(107886003)(2906002)(110136005)(5660300002)(71200400001)(83380400001)(316002)(186003)(54906003)(6506007)(38070700005)(53546011)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anY0cGZnakQ5YmFlTnZDeXlROE00dDdsMHRwSWhmcHdRUWZFUmVmVFZTeFZO?=
 =?utf-8?B?VHJ3dzRUamZjVWtsNkUzQUdHeGxFaUFQODBGVzQyWkxYSktjQ2U4SkJaOFg5?=
 =?utf-8?B?RkJQVVVMKzhKKzJKTzUwbUwvYnRycy9VUUpjRTFYczlYWkNGenovUTdCeERo?=
 =?utf-8?B?blIrZTNTcWt3WWtWcUFYR3Z1N3BQZUgySEVSMWdhNE5oeVBzcDlDVE9aNEl1?=
 =?utf-8?B?KzN4QjRiK1puTk1VVzVoalRSTHcrT2hWWGdKY3lOWjliWHlZdEhtcHVQeGxq?=
 =?utf-8?B?SHpMemxoL3lIVldyM1VSRENpVzlja05PKzEwM0s1RER5NjJrdXArTXp1T3JH?=
 =?utf-8?B?VXpOM3RPWC9QTTZKR0dZRnVydzNBTW9QS3ZHUDN5ZjUzUmJSQ05RQlZrVWIw?=
 =?utf-8?B?UzhYVXpPYmhLM2IxUHltWCtRNnV1NG5NRUZleWtXU1g3UTRvb2lZTVQ1ajNs?=
 =?utf-8?B?cVZoYlNnbWNScEdKWk9xM05SRnAwbndNWU9Hc0JhWDlvZ1MxWDB2N3M0L2tu?=
 =?utf-8?B?Rlh5R1JMcUErQW1PT3JRcVVaSHBEZmVHT3FCY0tlMWxMckt3RjIzRzR6STQ5?=
 =?utf-8?B?a1E3SlJGbUs4RWlDNE1XZU9kWVN6d25CeXhIZXV3STdtaVFWb3FNalZhWWFj?=
 =?utf-8?B?bGpCU3dMT1IySlp0d2lDQmJ5TXBLQThhL3RJVFV3bml6Vkdyb0I5alhDRmI5?=
 =?utf-8?B?clcwYlpmS3F6UHQvUTZlc2VucEExQW9NQWlTd2o2eDJkcVhLeUJqSC84SWpH?=
 =?utf-8?B?NXFWRS82MldvZExPQ3c2VnlLcDdxdXVwNlJZZ3d2ZWN3SVZUQ3h5NzlpRXdq?=
 =?utf-8?B?TG1vM1ZHV2hDVHdUemZCOVNjdFU3UmV4WkZnQnBGOWpJdnpvd25LZ3VoZmQv?=
 =?utf-8?B?Wm5XU3VlOEwvMnYzTXhqTUQxSVV5dEZCOUZabHYycGErUHVySmtkdnRtSVNQ?=
 =?utf-8?B?Ym1UbGo3REFpdWlhVHc5NzFqSWd1TVFzSU95eHl0ZlU3ckZnbHFta3dJNUxW?=
 =?utf-8?B?aUFIeWN5V2JoNzE2dVZveTNEcWw5VWJ1dEpqUVpFK2FPdklSTkxEN2VNVlVa?=
 =?utf-8?B?NlVVQTFIcEVVZWx2MklPZVpnU2V0NjRHZ3daaVArQWxVdmx1UVRiWEpnWkVK?=
 =?utf-8?B?cXpjYVFuYzRFenA5RjA3UlpKay9YeTZyR0dlcW41akZtUkNkT2dUenJCK1NP?=
 =?utf-8?B?czFSWnhIZmVvS0JTSW1mSCtwczVwOWJPV0JhaTJTODNlSE9BVHl1STZrOENt?=
 =?utf-8?B?SHNRYi9yN05pN3hxV2RBZjF3YmVMelhmRzlRMGtJVE9oelRsK3lFVnNJKy9J?=
 =?utf-8?B?WHkrQjQyV3pwTzd1S0RxMWQzRStyYnZnV2QxTk5Uci84VTBYNm5VOFhJSnJJ?=
 =?utf-8?B?SEE3d1hXd3BBR2FCd092a2t6VDNtZEdVdnEvRHNoVTV1Rk5ZUlZBbm9tcWxD?=
 =?utf-8?B?dVROb0pramo4S3BZWitoQUYwWFg1cE1vU1RReFhvb3M4M05OQklBd1ZKOCsr?=
 =?utf-8?B?Ulk0YnNnYTNhVlBBbXpGUnoxMW5uNDBxT01pMDRMQmpzSXJQYndXNm92Qk44?=
 =?utf-8?B?M2hMZG8wUy9jalZ4c21aQndQaTA4RWJwTm41dm9HV25oUXpjdkdySjBjNGU4?=
 =?utf-8?B?RGpnbWNpWUNIUlRKaEJHa3dtNVk5cHJ2RjBzNjZhQWFlSWlyWTVVZ0dGUzhl?=
 =?utf-8?B?NHBEdFVkeWRmQ1pINmRwQW0rTUd0MkZiNlRYcVVKeGgrK1d1WDMwZ0psVFlJ?=
 =?utf-8?Q?4JaW/vrQ6wTqrbLB3o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ec91e4-7486-4e95-da68-08d9874728a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 14:56:33.9517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +FoG/e7EfT+pci+/PM9QKEUKukh0XU3kMYbYDKPGRl3TyvHhOQiaJHC5w8pI3mVbeHjwWtmyLW15lhTXFtn1H+8/K5xLPVyXMgiAhS9vZeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5957
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAxNi8xOF0gcmF2YjogQWRkIFBhY2tldCByZWNlaXZlIGZ1bmN0aW9uIGZvcg0K
PiBHaWdhYml0IEV0aGVybmV0DQo+IA0KPiBPbiA5LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdy
b3RlOg0KPiANCj4gPiBUaGlzIHBhdGNoIHNlcmllcyBhZGRzIFJYKHBhY2tldCByZWNlaXZlKSBm
dW5jdGlvbiBmb3IgR2lnYWJpdA0KPiA+IEV0aGVybmV0IGZvdW5kIG9uIFJaL0cyTCBTb0MuDQo+
ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAg
ICAgfCAgIDEgKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
IHwgMTU3DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2Vk
LCAxNTYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBiMGUwNjdhNmE4ZWUuLjg1MjYwZjg5
ZTFjZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAg
LTEwOTIsNiArMTA5Miw3IEBAIHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+DQo+ID4gIAlpbnQg
ZHVwbGV4Ow0KPiA+ICAJc3RydWN0IHJhdmJfcnhfZGVzYyAqcmdldGhfcnhfcmluZ1tOVU1fUlhf
UVVFVUVdOw0KPiA+ICsJc3RydWN0IHNrX2J1ZmYgKnJ4dG9wX3NrYjsNCj4gDQo+ICAgIEknZCBw
cmVmZXIgZm9yIHRoaXMgb25lIGRlY2xhcmVkIGVhcmxlciBpbiB0aGUgKnN0cnVjdCosIGFzIHdl
bGwuIEFuZA0KPiB3aHkgbm90IGUuZyAncnhfMXN0X3NrYic/DQoNCk9LIFdpbGwgdXNlICdyeF8x
c3Rfc2tiJyBpbiB0aGUgbmV4dCBSRkMgdmVyc2lvbi4NCg0KPiANCj4gPg0KPiA+ICAJY29uc3Qg
c3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbzsNCj4gPiAgCXN0cnVjdCByZXNldF9jb250cm9sICpy
c3RjOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gaW5kZXggYTA4ZGE3YTM3YjkyLi44NjdlMTgwZTY2NTUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBAQCAtNzA1LDYgKzcwNSwyMyBA
QCBzdGF0aWMgdm9pZCByYXZiX2dldF90eF90c3RhbXAoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5k
ZXYpDQo+ID4gIAl9DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCByYXZiX3J4X2NzdW1f
cmdldGgoc3RydWN0IHNrX2J1ZmYgKnNrYikgew0KPiA+ICsJdTggKmh3X2NzdW07DQo+ID4gKw0K
PiA+ICsJLyogVGhlIGhhcmR3YXJlIGNoZWNrc3VtIGlzIGNvbnRhaW5lZCBpbiBzaXplb2YoX19z
dW0xNikgKDIpIGJ5dGVzDQo+ID4gKwkgKiBhcHBlbmRlZCB0byBwYWNrZXQgZGF0YQ0KPiA+ICsJ
ICovDQo+ID4gKwlpZiAodW5saWtlbHkoc2tiLT5sZW4gPCBzaXplb2YoX19zdW0xNikpKQ0KPiA+
ICsJCXJldHVybjsNCj4gPiArCWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBzaXpl
b2YoX19zdW0xNik7DQo+ID4gKw0KPiA+ICsJaWYgKCpod19jc3VtID09IDApDQo+ID4gKwkJc2ti
LT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsNCj4gPiArCWVsc2UNCj4gPiArCQlz
a2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX05PTkU7DQo+IA0KPiAgICBNaG0sIHdoYXQncyB0aGUg
cG9pbnQgb2YgdGhpcyB3aG9sZSBmdW5jdGlvbiB0aGVuPyBXaHkgaXQgY2FuJ3QgYmUgYQ0KPiBj
b3B5IG9mIHRoZSBSLUNhciBhbmFsb2c/DQoNClRoaXMgZnVuY3Rpb24gc2hvdWxkIGNvbWUgYWZ0
ZXIgQ1NSIGluaXRpYWxpemF0aW9uLiBOZXh0IFJGQyBJIHdpbGwgdGFrZW4gY2FyZSBvZiB0aGlz
Lg0KKmh3Y3N1bSA9PSAwIG1lYW5zLCB0aGVyZSBpcyBubyBlcnJvciBpbiBjaGVja3N1bS4gU28g
aXQgc2hvdWxkIGJlIE9LLg0KDQo+IA0KPiBbLi4uXQ0KPiA+IEBAIC03MjAsMTEgKzczNywxNDcg
QEAgc3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtKHN0cnVjdCBza19idWZmICpza2IpDQo+IFsuLi5d
DQo+ID4gIC8qIFBhY2tldCByZWNlaXZlIGZ1bmN0aW9uIGZvciBHaWdhYml0IEV0aGVybmV0ICov
ICBzdGF0aWMgYm9vbA0KPiA+IHJhdmJfcmdldGhfcngoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYs
IGludCAqcXVvdGEsIGludCBxKSAgew0KPiA+IC0JLyogUGxhY2UgaG9sZGVyICovDQo+ID4gLQly
ZXR1cm4gdHJ1ZTsNCj4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJp
dihuZGV2KTsNCj4gPiArCWludCBlbnRyeSA9IHByaXYtPmN1cl9yeFtxXSAlIHByaXYtPm51bV9y
eF9yaW5nW3FdOw0KPiA+ICsJaW50IGJvZ3VzY250ID0gcHJpdi0+ZGlydHlfcnhbcV0gKyBwcml2
LT5udW1fcnhfcmluZ1txXSAtIHByaXYtDQo+ID5jdXJfcnhbcV07DQo+ID4gKwlzdHJ1Y3QgbmV0
X2RldmljZV9zdGF0cyAqc3RhdHMgPSAmcHJpdi0+c3RhdHNbcV07DQo+IA0KPiAgICBbcV0gc2hv
dWxkIGJlIGRyb3BwZWQsIGFzIHdlJ3ZlIGFncmVlZC4uLg0KDQpuY19xdWV1ZSBmZWF0dXJlIGJp
dCB3aWxsIHRha2UgY2FyZSBvZiB0aGlzLiBTbyB0aGUgcSB3aWxsIGJlIGFsd2F5cyBSVkFCX0JF
Lg0KDQo+IA0KPiA+ICsJc3RydWN0IHJhdmJfcnhfZGVzYyAqZGVzYzsNCj4gPiArCXN0cnVjdCBz
a19idWZmICpza2I7DQo+ID4gKwlkbWFfYWRkcl90IGRtYV9hZGRyOw0KPiA+ICsJdTggIGRlc2Nf
c3RhdHVzOw0KPiA+ICsJdTggIGRpZV9kdDsNCj4gPiArCXUxNiBwa3RfbGVuOw0KPiA+ICsJaW50
IGxpbWl0Ow0KPiA+ICsNCj4gPiArCWJvZ3VzY250ID0gbWluKGJvZ3VzY250LCAqcXVvdGEpOw0K
PiA+ICsJbGltaXQgPSBib2d1c2NudDsNCj4gPiArCWRlc2MgPSAmcHJpdi0+cmdldGhfcnhfcmlu
Z1txXVtlbnRyeV07DQo+ID4gKwl3aGlsZSAoZGVzYy0+ZGllX2R0ICE9IERUX0ZFTVBUWSkgew0K
PiA+ICsJCS8qIERlc2NyaXB0b3IgdHlwZSBtdXN0IGJlIGNoZWNrZWQgYmVmb3JlIGFsbCBvdGhl
ciByZWFkcyAqLw0KPiA+ICsJCWRtYV9ybWIoKTsNCj4gPiArCQlkZXNjX3N0YXR1cyA9IGRlc2Mt
Pm1zYzsNCj4gPiArCQlwa3RfbGVuID0gbGUxNl90b19jcHUoZGVzYy0+ZHNfY2MpICYgUlhfRFM7
DQo+ID4gKw0KPiA+ICsJCWlmICgtLWJvZ3VzY250IDwgMCkNCj4gPiArCQkJYnJlYWs7DQo+ID4g
Kw0KPiA+ICsJCS8qIFdlIHVzZSAwLWJ5dGUgZGVzY3JpcHRvcnMgdG8gbWFyayB0aGUgRE1BIG1h
cHBpbmcgZXJyb3JzICovDQo+ID4gKwkJaWYgKCFwa3RfbGVuKQ0KPiA+ICsJCQljb250aW51ZTsN
Cj4gPiArDQo+ID4gKwkJaWYgKGRlc2Nfc3RhdHVzICYgTVNDX01DKQ0KPiA+ICsJCQlzdGF0cy0+
bXVsdGljYXN0Kys7DQo+ID4gKw0KPiA+ICsJCWlmIChkZXNjX3N0YXR1cyAmIChNU0NfQ1JDIHwg
TVNDX1JGRSB8IE1TQ19SVFNGIHwgTVNDX1JUTEYgfA0KPiBNU0NfQ0VFRikpIHsNCj4gPiArCQkJ
c3RhdHMtPnJ4X2Vycm9ycysrOw0KPiA+ICsJCQlpZiAoZGVzY19zdGF0dXMgJiBNU0NfQ1JDKQ0K
PiA+ICsJCQkJc3RhdHMtPnJ4X2NyY19lcnJvcnMrKzsNCj4gPiArCQkJaWYgKGRlc2Nfc3RhdHVz
ICYgTVNDX1JGRSkNCj4gPiArCQkJCXN0YXRzLT5yeF9mcmFtZV9lcnJvcnMrKzsNCj4gPiArCQkJ
aWYgKGRlc2Nfc3RhdHVzICYgKE1TQ19SVExGIHwgTVNDX1JUU0YpKQ0KPiA+ICsJCQkJc3RhdHMt
PnJ4X2xlbmd0aF9lcnJvcnMrKzsNCj4gPiArCQkJaWYgKGRlc2Nfc3RhdHVzICYgTVNDX0NFRUYp
DQo+ID4gKwkJCQlzdGF0cy0+cnhfbWlzc2VkX2Vycm9ycysrOw0KPiA+ICsJCX0gZWxzZSB7DQo+
ID4gKwkJCWRpZV9kdCA9IGRlc2MtPmRpZV9kdCAmIDB4RjA7DQo+ID4gKwkJCXN3aXRjaCAoZGll
X2R0KSB7DQo+ID4gKwkJCWNhc2UgRFRfRlNJTkdMRToNCj4gPiArCQkJCXNrYiA9IHJhdmJfZ2V0
X3NrYl9yZ2V0aChuZGV2LCBxLCBlbnRyeSwgZGVzYyk7DQo+ID4gKwkJCQlza2JfcHV0KHNrYiwg
cGt0X2xlbik7DQo+ID4gKwkJCQlza2ItPnByb3RvY29sID0gZXRoX3R5cGVfdHJhbnMoc2tiLCBu
ZGV2KTsNCj4gPiArCQkJCWlmIChuZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfUlhDU1VNKQ0KPiA+
ICsJCQkJCXJhdmJfcnhfY3N1bV9yZ2V0aChza2IpOw0KPiA+ICsJCQkJbmFwaV9ncm9fcmVjZWl2
ZSgmcHJpdi0+bmFwaVtxXSwgc2tiKTsNCj4gPiArCQkJCXN0YXRzLT5yeF9wYWNrZXRzKys7DQo+
ID4gKwkJCQlzdGF0cy0+cnhfYnl0ZXMgKz0gcGt0X2xlbjsNCj4gPiArCQkJCWJyZWFrOw0KPiA+
ICsJCQljYXNlIERUX0ZTVEFSVDoNCj4gPiArCQkJCXByaXYtPnJ4dG9wX3NrYiA9IHJhdmJfZ2V0
X3NrYl9yZ2V0aChuZGV2LCBxLA0KPiBlbnRyeSwgZGVzYyk7DQo+IA0KPiAgICBCdXQgZG9uJ3Qg
eW91IG5lZWQgdG8gIGNvcHkgdGhlIGRhdGEgaW4gdGhpcyBjYXNlPw0KDQpJdCBpcyBub3QgcmVx
dWlyZWQsIGhlcmUuIA0KDQo+IA0KPiA+ICsJCQkJc2tiX3B1dChwcml2LT5yeHRvcF9za2IsIHBr
dF9sZW4pOw0KPiA+ICsJCQkJYnJlYWs7DQo+ID4gKwkJCWNhc2UgRFRfRk1JRDoNCj4gPiArCQkJ
CXNrYiA9IHJhdmJfZ2V0X3NrYl9yZ2V0aChuZGV2LCBxLCBlbnRyeSwgZGVzYyk7DQo+ID4gKwkJ
CQlza2JfY29weV90b19saW5lYXJfZGF0YV9vZmZzZXQocHJpdi0+cnh0b3Bfc2tiLA0KPiA+ICsJ
CQkJCQkJICAgICAgIHByaXYtPnJ4dG9wX3NrYi0+bGVuLA0KPiA+ICsJCQkJCQkJICAgICAgIHNr
Yi0+ZGF0YSwNCj4gPiArCQkJCQkJCSAgICAgICBwa3RfbGVuKTsNCj4gPiArCQkJCXNrYl9wdXQo
cHJpdi0+cnh0b3Bfc2tiLCBwa3RfbGVuKTsNCj4gPiArCQkJCWRldl9rZnJlZV9za2Ioc2tiKTsN
Cj4gPiArCQkJCWJyZWFrOw0KPiA+ICsJCQljYXNlIERUX0ZFTkQ6DQo+ID4gKwkJCQlza2IgPSBy
YXZiX2dldF9za2JfcmdldGgobmRldiwgcSwgZW50cnksIGRlc2MpOw0KPiA+ICsJCQkJc2tiX2Nv
cHlfdG9fbGluZWFyX2RhdGFfb2Zmc2V0KHByaXYtPnJ4dG9wX3NrYiwNCj4gPiArCQkJCQkJCSAg
ICAgICBwcml2LT5yeHRvcF9za2ItPmxlbiwNCj4gPiArCQkJCQkJCSAgICAgICBza2ItPmRhdGEs
DQo+ID4gKwkJCQkJCQkgICAgICAgcGt0X2xlbik7DQo+ID4gKwkJCQlza2JfcHV0KHByaXYtPnJ4
dG9wX3NrYiwgcGt0X2xlbik7DQo+ID4gKwkJCQlkZXZfa2ZyZWVfc2tiKHNrYik7DQo+ID4gKwkJ
CQlwcml2LT5yeHRvcF9za2ItPnByb3RvY29sID0NCj4gPiArCQkJCQlldGhfdHlwZV90cmFucyhw
cml2LT5yeHRvcF9za2IsIG5kZXYpOw0KPiA+ICsJCQkJaWYgKG5kZXYtPmZlYXR1cmVzICYgTkVU
SUZfRl9SWENTVU0pDQo+ID4gKwkJCQkJcmF2Yl9yeF9jc3VtX3JnZXRoKHNrYik7DQo+ID4gKwkJ
CQluYXBpX2dyb19yZWNlaXZlKCZwcml2LT5uYXBpW3FdLA0KPiA+ICsJCQkJCQkgcHJpdi0+cnh0
b3Bfc2tiKTsNCj4gPiArCQkJCXN0YXRzLT5yeF9wYWNrZXRzKys7DQo+ID4gKwkJCQlzdGF0cy0+
cnhfYnl0ZXMgKz0gcHJpdi0+cnh0b3Bfc2tiLT5sZW47DQo+ID4gKwkJCQlicmVhazsNCj4gPiAr
CQkJfQ0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJZW50cnkgPSAoKytwcml2LT5jdXJfcnhbcV0p
ICUgcHJpdi0+bnVtX3J4X3JpbmdbcV07DQo+ID4gKwkJZGVzYyA9ICZwcml2LT5yZ2V0aF9yeF9y
aW5nW3FdW2VudHJ5XTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKiBSZWZpbGwgdGhlIFJYIHJp
bmcgYnVmZmVycy4gKi8NCj4gPiArCWZvciAoOyBwcml2LT5jdXJfcnhbcV0gLSBwcml2LT5kaXJ0
eV9yeFtxXSA+IDA7IHByaXYtPmRpcnR5X3J4W3FdKyspDQo+IHsNCj4gPiArCQllbnRyeSA9IHBy
aXYtPmRpcnR5X3J4W3FdICUgcHJpdi0+bnVtX3J4X3JpbmdbcV07DQo+ID4gKwkJZGVzYyA9ICZw
cml2LT5yZ2V0aF9yeF9yaW5nW3FdW2VudHJ5XTsNCj4gPiArCQlkZXNjLT5kc19jYyA9IGNwdV90
b19sZTE2KFJHRVRIX1JYX0RFU0NfREFUQV9TSVpFKTsNCj4gPiArDQo+ID4gKwkJaWYgKCFwcml2
LT5yeF9za2JbcV1bZW50cnldKSB7DQo+ID4gKwkJCXNrYiA9IG5ldGRldl9hbGxvY19za2IobmRl
diwNCj4gPiArCQkJCQkgICAgICAgUkdFVEhfUlhfQlVGRl9NQVggKyBSQVZCX0FMSUdOIC0gMSk7
DQo+IA0KPiAgICBBTElHTihSR0VUSF9SWF9CVUZGX01BWCwgUkFWQl9BTElHTik/DQoNCkl0IGlz
IHRha2VuIGNhcmUgaW4gbmV4dCBSRkMuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5d
DQo+IA0KPiBNQlIsIFNlcmdleQ0K
