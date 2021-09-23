Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E554165F1
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhIWTaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:30:39 -0400
Received: from mail-eopbgr1410130.outbound.protection.outlook.com ([40.107.141.130]:6071
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242796AbhIWTai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 15:30:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSXaQCaflcCS9q7aEHWvDpAJeMQboYHpuIN0trnmJ+w74Yt1XNSCQbvCsYpznccm++YDEz/WeEFqN+0A447rGmeatMCqusYuVa3CAYv2vKKwU+bshET22JylOwHVONV83GDst1aHNuYISf6QOCszuomEdydgiV9oEiCYkzCqnNiVAjd6aKHY2sQiDXBBa5lgGgANvBSaUWkzkMWO4GD7aJI++oH4fw+KiCAXMpIEu8NagN5bAwqFEX0VY2pg+a7+WvhbC1gclYUnElCJjdcTWfEdSY5zJPsLmNtQSyMgFlK/WmryekA3z/HqXj7RfAGQgTiM7FIDpWiLWDfCWNzbQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZwFczrMPfKG2xu0eqRUUTZPiXiu3jHNJB58tptk0TUo=;
 b=e57SEFPvwxZjUPDZhX7wFXLx/VAN3xY+HJMrY8KMGDbiceQFG6O8RhnbGM7rE/m39E3Xlhb7QCH8zI2PzG+Acyc7BjJr00DTbnTQEVPWmTaiJ53u46H5a8m6WuE2GDOo6JiPBelpbj+4liBFK21wxk/LJ994B0dOVYAoEcF0gH8YVCD176iG8IYwetZ2moqTz88lfTuYIQB5LspXIMwcJ1poNdSlN+Kd70Q0n0bzu7OK2fqubTEOf3L7Cd/pjt2h/HC987mMppqwaGehJZ1HhnOUM9QmFbbTbXa/s7ZX+oTbOOY7AsyA7qWjVMpIdSxnroQMEE319/6fzYFEVFytBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwFczrMPfKG2xu0eqRUUTZPiXiu3jHNJB58tptk0TUo=;
 b=r+oI0ozYMpscDVreUQcOsd92S9DnJ6R/7AwtE4mczJuwhIWLXSDmdi/Ibdlfk5v8e3TTa5vrWsXYO2TqgtyRL/irsxlG9c9efNe7OgtX0SkWDsJFoHGhHgT89BoOnGonVzBtu01dEIU64KWqGFEwVc3iLNChwthH77GeN9DNAOM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3862.jpnprd01.prod.outlook.com (2603:1096:604:48::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 19:29:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 19:29:01 +0000
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
Subject: RE: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
Thread-Topic: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
Thread-Index: AQHXsIR809ll8TcGVk6ArGR8VNmdYaux+3GAgAAB9ACAAAMFoA==
Date:   Thu, 23 Sep 2021 19:29:01 +0000
Message-ID: <OS0PR01MB59227181DCFC6A860B7063BC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
 <183fd9d2-353d-1985-7145-145a03967f6e@omp.ru>
 <OS0PR01MB592208B398BED9F36677B59B86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592208B398BED9F36677B59B86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51be6b72-ab51-4d2b-69cf-08d97ec865d6
x-ms-traffictypediagnostic: OSBPR01MB3862:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB386247D6E9EC6674AA9170E186A39@OSBPR01MB3862.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5r+ypmw4bmJHUpiyrz2IBungkfBuzi3vSXiRNY7XTPnXRMfkcit/HoIJ65VlH8CDB21qMdc4jCa4ZpVJHF6E5ZzzDTPHgl5MZ2pyeFyt5YlXWSdGyYPO2m84H4ZLW3KMulJRqqJraiHm4K67w+miwm45fznaDywZ8a/BbCmQwv101ks5/MvLRUX7Te6FZoDrV3fm06Ao6NpLeU+E7+AJNcwF0D7291KMy5oo/WnVo5pWl2966m2GwGtGNiiRxHHO8n/Cm3StYSHg1ewXE5Bc2+KjFdlQOZbP461g7pm9uqGzt9Oulwp1FjK83XLDFCEh6t+1pUCXFndbMmfd773TZ21DQGZRNukwEVnMisHHUOHJ092U3YQL9OYQCL5th6mNlWGdnjQ4G2b52WnHuHsRVmyKuyHLPYl9g0XVW//u716dN3shC2uISXJjtgLPSAf2Avcb9T1nVEvJmvX5A9561Z0AmXVsrweBcjEXDJ6nWs2lgA0h+HpaiA7rd/9oOtgufc8VMCTNRDHtWFVmWT4eZ3lajP8eO7SJ1dgUyDCz7ZDAflXw9Hc6eFo/mlPhNgOVUse9offsmGsS8DSxdjmDrnYzJiUYQ8sy7QlVJ6dle1+9q0bPLOVMH02ORZWBQGAMy6JFeR0wsCaNPcRe0KvEnnoHZSipjzflMylfuMai5c8CD1Ojz31gcxLOt9oZwGNycDaGXPLhl7FO27kJMxFw4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(5660300002)(33656002)(26005)(8936002)(64756008)(76116006)(66946007)(66446008)(4326008)(38070700005)(71200400001)(52536014)(6506007)(53546011)(55016002)(83380400001)(7696005)(54906003)(86362001)(508600001)(9686003)(122000001)(38100700002)(316002)(8676002)(110136005)(107886003)(2940100002)(66476007)(2906002)(186003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjJ0MlRFOGdVRjh3UkJtSEpma2dFcUxjSjNINXpLZ3ltZ0R4eTMxUFZPR0ZM?=
 =?utf-8?B?WkZlRmVwd1U1WWZ3T1htSTdEaEJRWGVHNHpSbTQxNis0bWs0Y212bUtEUDhy?=
 =?utf-8?B?RGJ6Z1lOS2hheWJWYjMrUnFta3NxYmJ2ejFEN2t1OC9IekRMMi9JN3BrYTZy?=
 =?utf-8?B?TjI0YnJNeitWOXpVYUFaaHQ3U0Jjbjg5Ykh0UTY2akVHQmtSRlFFdCtjSXVq?=
 =?utf-8?B?VXRUZkNJZ2g5Nk82K1NleE54OGxsUXdldGZBK2dPMFcrc3J4QXpVN1ZHeEJK?=
 =?utf-8?B?OCsrNXdCM1k5TnJUTWJFakhFeFd4RVI1aXkwN1dLRFQ4WUNBS2FPdk9NMjlu?=
 =?utf-8?B?ZmdKem81cEJKVzRKZVJnYW0valdvTHBDOWU1VDZYZUtqS0FNZ3ZOR0ZzVFFP?=
 =?utf-8?B?S0VvQjRoK0lXSldXMUI4WEtmaVpLRGZuRzJYWmUzcFFkVkk3UDJJMzFZWXp5?=
 =?utf-8?B?QmhXbTFIbFhxWmcvZFlacnlTVkU1cjdWZEZVWnJuQmJhYkpxOXV6RlJvUWRF?=
 =?utf-8?B?L2dqMlhLMXdHQ3pvNlJqWEVEN2N0NURHMEtHQWtiNi8yM1l0bVRLVU54M2lt?=
 =?utf-8?B?Sm8rSzM2N3VHbVlzRW9BZkxreDFaaFNCZnptQXBvbXN3TVN2cWhZU3lhaERN?=
 =?utf-8?B?RmVoVlVtcXJMSjZhYm14NEZxS0N2S2VvaURGZzZGd3RjR1FvRFcxN2ZLbTBI?=
 =?utf-8?B?NzR0Qkt3dXNaa0pTdWdFQ09jNjdoM3g0T0xoQjhXQkJCYVBtNmJMVTlldXJW?=
 =?utf-8?B?eEJxTDJPaWllb01pT0QrNU91RkRuclpYbDhqYkQ4VURYREtmZVJRUytYeDB0?=
 =?utf-8?B?bXZUUGlYdWs3b1ZGa2QwdUg1aWVSYlRqWFl0WFhSajF4SUJGNVVkbkhlUFpi?=
 =?utf-8?B?UE5sanA2MGQvbGhuOFh3cUtmcXViM3FPaWoxOUdzZUZsZnFzaUNIazBZY0lX?=
 =?utf-8?B?aWJDQjU5NXZXRVovK2RwOWV4QU1IaDlCUnlHalp6SW5VbUxWYzViWlJ4RURU?=
 =?utf-8?B?Sm9aekRkMzcyUlFRQnJLbElNOUR3OCtJRGxrYjhqTUlvK3JtZnl3VHNtR1hH?=
 =?utf-8?B?YkM2amhrSUVVSHBBd0ZwdTlqa1VCOThEYkRWdjRsaFpCQkRwdm1EaDdPajBz?=
 =?utf-8?B?RVdkLys4VjAybjE4K3AyVnFPYk9DVkdqLzRzbFFQdHZCK3NWTWNRcm9CV0lq?=
 =?utf-8?B?NXZGc1B4SHd4NVRtT2I1ZWo5azBrUUhoK3RxTHNUUk9jbjlmRktCK1JzWC9E?=
 =?utf-8?B?dmtJRU5RSTduV2ZjT1Y0S2RWOFpoT1N3UklFOXRBVXFTV0J3cU9uL05yR29X?=
 =?utf-8?B?dEJXODJGUWlQT0wzUmdPMWJHWHR1YnhHR3VIWWxYL25MK0VuT2NSc0J1UDFa?=
 =?utf-8?B?b1JLRS9nSWxDWDEzOUVYSHNZUmNNZStnMEJ4OHl0bmpSYjdQc0F4VkFENHZG?=
 =?utf-8?B?M2ZpMnFWTG9nZG5ZTEVjd3lyNkV6UlFKVTVlSzV3ZnhWaVBRaGxpV2FrNWgz?=
 =?utf-8?B?K1NCMjRTWFk1L0NNdWkyQjRxSlowdUFWTHhraFF6SjJ3c0hSOWZoT0JPNjJm?=
 =?utf-8?B?RnlqRFRXVUZUNGI5aWVnYk1MckNycVdQUGlrWkJxVzlET2ZnWWp4VjZ5d29l?=
 =?utf-8?B?RTRncFAzYklxZVUzaVRpM1FSWVpCNUsxSktJbEExMHVSQ1FScFJ6TkU4bUFn?=
 =?utf-8?B?blVPTTl5MXRzeW9RREplVk1OYlNJUDROSFoxaG1XZmI1ZitsSEpKbEJrWW1K?=
 =?utf-8?Q?f3SjTtanny7SE5Wf7vnfmgwHl7OaZpE74TBSFul?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51be6b72-ab51-4d2b-69cf-08d97ec865d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 19:29:01.4953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NAjtmVZvFYzLYoKk8W7wAer+ZjUxHlF6oCbQZLPMzdTRDaatfAfMQbqqQr0ibaWfNdBrkQYku9hajtnACizLG3p9TqA5bW+OWhb/kTKVGz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDAzLzE4XSByYXZiOiBJbml0
aWFsaXplIEdiRXRoZXJuZXQgZG1hYw0KPiANCj4gSEkgU2VyZ2VpLA0KPiANCj4gPiBTdWJqZWN0
OiBSZTogW1JGQy9QQVRDSCAwMy8xOF0gcmF2YjogSW5pdGlhbGl6ZSBHYkV0aGVybmV0IGRtYWMN
Cj4gPg0KPiA+IE9uIDkvMjMvMjEgNTowNyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4NCj4gPiA+
IEluaXRpYWxpemUgR2JFdGhlcm5ldCBkbWFjIGZvdW5kIG9uIFJaL0cyTCBTb0MuDQo+ID4gPiBU
aGlzIHBhdGNoIGFsc28gcmVuYW1lcyByYXZiX3JjYXJfZG1hY19pbml0IHRvIHJhdmJfZG1hY19p
bml0X3JjYXINCj4gPiA+IHRvIGJlIGNvbnNpc3RlbnQgd2l0aCB0aGUgbmFtaW5nIGNvbnZlbnRp
b24gdXNlZCBpbiBzaF9ldGggZHJpdmVyLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgNCArKw0KPiA+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA4NA0KPiA+ID4gKysrKysr
KysrKysrKysrKysrKysrKystDQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA4NSBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmIuaA0KPiA+ID4gaW5kZXggMGNlMGMxM2VmOGNiLi5iZWUwNWU2ZmI4MTUgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+IEBAIC04
MSw2ICs4MSw3IEBAIGVudW0gcmF2Yl9yZWcgew0KPiA+ID4gIAlSUUMzCT0gMHgwMEEwLA0KPiA+
ID4gIAlSUUM0CT0gMHgwMEE0LA0KPiA+ID4gIAlSUEMJPSAweDAwQjAsDQo+ID4gPiArCVJUQwk9
IDB4MDBCNCwJLyogUlovRzJMIG9ubHkgKi8NCj4gPg0KPiA+ICAgIE15IGdlbjMgbWFudWFsIHNh
eXMgdGhlIHJlZ2l1c3RlciBleGlzdHMgdGhlcmUuLi4NCg0KVGhlIGV4aXN0aW5nIGRyaXZlciBp
cyBub3QgdXNpbmcgaXQuIFNpbmNlIG1hbnVhbCBzYXlzIHRoZXJlIGlzIFJUQywgSSB3aWxsIGRv
Y3VtZW50IGZvciBHZW4zIGFzIHdlbGwuDQoNCj4gPg0KPiA+ID4gIAlVRkNXCT0gMHgwMEJDLA0K
PiA+ID4gIAlVRkNTCT0gMHgwMEMwLA0KPiA+ID4gIAlVRkNWMAk9IDB4MDBDNCwNCj4gPiA+IEBA
IC0xNTYsNiArMTU3LDcgQEAgZW51bSByYXZiX3JlZyB7DQo+ID4gPiAgCVRJUwk9IDB4MDM3QywN
Cj4gPiA+ICAJSVNTCT0gMHgwMzgwLA0KPiA+ID4gIAlDSUUJPSAweDAzODQsCS8qIFItQ2FyIEdl
bjMgb25seSAqLw0KPiA+ID4gKwlSSUMzCT0gMHgwMzg4LAkvKiBSWi9HMkwgb25seSAqLw0KPiA+
DQo+ID4gICAgQWdhaW4sIHRoaXMgcmVnaXN0ZXIgKGFsb25nIHdpdGggUklTMykgZXhpc3RzIG9u
IGdlbjMuLi4NCg0KUklTMyBpcyBub3QgdXNlZCBieSBSLUNhciBvciBSWi9HMkwgaGVuY2UgaXQg
bm90IGRvY3VtZW50ZWQuDQpCdXQgUklDMyBpcyB1c2VkIGJ5IFJaL0cyTC4gQXMgcGVyIGdlbjMg
aHcgbWFudWFsIGl0IGlzIHByZXNlbnQsIHNvIEkgd2lsbCB1cGRhdGUgdGhlIGNvbW1lbnQuDQoN
Cj4gPg0KPiA+ID4gIAlHQ0NSCT0gMHgwMzkwLA0KPiA+ID4gIAlHTVRUCT0gMHgwMzk0LA0KPiA+
ID4gIAlHUFRDCT0gMHgwMzk4LA0KPiA+ID4gQEAgLTk1Niw2ICs5NTgsOCBAQCBlbnVtIFJBVkJf
UVVFVUUgew0KPiA+ID4NCj4gPiA+ICAjZGVmaW5lIFJYX0JVRl9TWgkoMjA0OCAtIEVUSF9GQ1Nf
TEVOICsgc2l6ZW9mKF9fc3VtMTYpKQ0KPiA+ID4NCj4gPiA+ICsjZGVmaW5lIFJHRVRIX1JYX0JV
RkZfTUFYIDgxOTINCj4gPiA+ICsNCj4gPiA+ICBzdHJ1Y3QgcmF2Yl90c3RhbXBfc2tiIHsNCj4g
PiA+ICAJc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiA+ID4gIAlzdHJ1Y3Qgc2tfYnVmZiAqc2ti
Ow0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+ID4gaW5kZXggMjQyMmU3NGQ5YjRmLi41NGM0ZDMxYTY5NTAgMTAwNjQ0DQo+ID4gPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBAQCAtODMsNiAr
ODMsMTEgQEAgc3RhdGljIGludCByYXZiX2NvbmZpZyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikN
Cj4gPiA+ICAJcmV0dXJuIGVycm9yOw0KPiA+ID4gIH0NCj4gPiA+DQo+ID4gPiArc3RhdGljIHZv
aWQgcmF2Yl9yZ2V0aF9zZXRfcmF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgew0KPiA+ID4g
KwkvKiBQbGFjZSBob2xkZXIgKi8NCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiAgc3RhdGljIHZv
aWQgcmF2Yl9zZXRfcmF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgIHsNCj4gPiA+ICAJc3Ry
dWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOyBAQCAtMjE3LDYgKzIy
MiwxMQ0KPiA+ID4gQEAgc3RhdGljIGludCByYXZiX3R4X2ZyZWUoc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYsIGludCBxLCBib29sDQo+ID4gZnJlZV90eGVkX29ubHkpDQo+ID4gPiAgCXJldHVybiBm
cmVlX251bTsNCj4gPiA+ICB9DQo+ID4gPg0KPiA+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcnhfcmlu
Z19mcmVlX3JnZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkgew0KPiA+ID4gKwkv
KiBQbGFjZSBob2xkZXIgKi8NCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiAgc3RhdGljIHZvaWQg
cmF2Yl9yeF9yaW5nX2ZyZWUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKSAgew0KPiA+
ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7IEBAIC0y
ODMsNiArMjkzLDExDQo+ID4gPiBAQCBzdGF0aWMgdm9pZCByYXZiX3JpbmdfZnJlZShzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4gPiAgCXByaXYtPnR4X3NrYltxXSA9IE5VTEw7
DQo+ID4gPiAgfQ0KPiA+ID4NCj4gPiA+ICtzdGF0aWMgdm9pZCByYXZiX3J4X3JpbmdfZm9ybWF0
X3JnZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQNCj4gPiA+ICtxKSB7DQo+ID4gPiAr
CS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICBzdGF0aWMgdm9p
ZCByYXZiX3J4X3JpbmdfZm9ybWF0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkgIHsN
Cj4gPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOyBA
QCAtMzU2LDYgKzM3MSwxMg0KPiA+ID4gQEAgc3RhdGljIHZvaWQgcmF2Yl9yaW5nX2Zvcm1hdChz
dHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4gPiAgCWRlc2MtPmRwdHIgPSBjcHVf
dG9fbGUzMigodTMyKXByaXYtPnR4X2Rlc2NfZG1hW3FdKTsNCj4gPiA+ICB9DQo+ID4gPg0KPiA+
ID4gK3N0YXRpYyB2b2lkICpyYXZiX3JnZXRoX2FsbG9jX3J4X2Rlc2Moc3RydWN0IG5ldF9kZXZp
Y2UgKm5kZXYsIGludA0KPiA+ID4gK3EpIHsNCj4gPiA+ICsJLyogUGxhY2UgaG9sZGVyICovDQo+
ID4gPiArCXJldHVybiBOVUxMOw0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICBzdGF0aWMgdm9p
ZCAqcmF2Yl9hbGxvY19yeF9kZXNjKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkgIHsN
Cj4gPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOyBA
QCAtNDI2LDYgKzQ0NywxMQ0KPiA+ID4gQEAgc3RhdGljIGludCByYXZiX3JpbmdfaW5pdChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4gPiAgCXJldHVybiAtRU5PTUVNOw0KPiA+
ID4gIH0NCj4gPiA+DQo+ID4gPiArc3RhdGljIHZvaWQgcmF2Yl9yZ2V0aF9lbWFjX2luaXQoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYpIHsNCj4gPiA+ICsJLyogUGxhY2UgaG9sZGVyICovDQo+ID4g
PiArfQ0KPiA+ID4gKw0KPiA+ID4gIHN0YXRpYyB2b2lkIHJhdmJfcmNhcl9lbWFjX2luaXQoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+ID4gPiAgCS8qIFJlY2VpdmUgZnJhbWUgbGltaXQg
c2V0IHJlZ2lzdGVyICovIEBAIC00NjEsNyArNDg3LDMyIEBAIHN0YXRpYw0KPiA+ID4gdm9pZCBy
YXZiX2VtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiA+ICAJaW5mby0+ZW1h
Y19pbml0KG5kZXYpOw0KPiA+ID4gIH0NCj4gPiA+DQo+ID4gPiAtc3RhdGljIHZvaWQgcmF2Yl9y
Y2FyX2RtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiA+ICtzdGF0aWMgdm9p
ZCByYXZiX2RtYWNfaW5pdF9yZ2V0aChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgew0KPiA+ID4g
KwkvKiBTZXQgQVZCIFJYICovDQo+ID4gPiArCXJhdmJfd3JpdGUobmRldiwgMHg2MDAwMDAwMCwg
UkNSKTsNCj4gPiA+ICsNCj4gPiA+ICsJLyogU2V0IE1heCBGcmFtZSBMZW5ndGggKFJUQykgKi8N
Cj4gPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAweDdmZmMwMDAwIHwgUkdFVEhfUlhfQlVGRl9NQVgs
IFJUQyk7DQo+ID4NCj4gPiAgICBTaG91bGQgYmUgaW5pdCdlZCBvbiBnZW4zIGFzIHdlbGw/DQo+
IA0KPiBSY2FyIGdlbjMgaGFzIHNlcGFyYXRlIGluaXRpYWxpemF0aW9uIHJvdXRpbmUsIFRoaXMg
cGFydCBpcyBSWi9HMkwNCj4gc3BlY2lmaWMsIHRoZSBidWZmZXIgc2l6ZSBpcyBkaWZmZXJlbnQu
DQo+IA0KPiA+DQo+ID4gPiArDQo+ID4gPiArCS8qIFNldCBGSUZPIHNpemUgKi8NCj4gPiA+ICsJ
cmF2Yl93cml0ZShuZGV2LCAweDAwMjIyMjAwLCBUR0MpOw0KPiA+ID4gKw0KPiA+ID4gKwlyYXZi
X3dyaXRlKG5kZXYsIDAsIFRDQ1IpOw0KPiA+ID4gKw0KPiA+ID4gKwkvKiBGcmFtZSByZWNlaXZl
ICovDQo+ID4gPiArCXJhdmJfd3JpdGUobmRldiwgUklDMF9GUkUwLCBSSUMwKTsNCj4gPiA+ICsJ
LyogRGlzYWJsZSBGSUZPIGZ1bGwgd2FybmluZyAqLw0KPiA+ID4gKwlyYXZiX3dyaXRlKG5kZXYs
IDB4MCwgUklDMSk7DQo+ID4gPiArCS8qIFJlY2VpdmUgRklGTyBmdWxsIGVycm9yLCBkZXNjcmlw
dG9yIGVtcHR5ICovDQo+ID4gPiArCXJhdmJfd3JpdGUobmRldiwgUklDMl9RRkUwIHwgUklDMl9S
RkZFLCBSSUMyKTsNCj4gPiA+ICsNCj4gPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAweDAsIFJJQzMp
Ow0KPiA+DQo+ID4gICAgU2hvdWxkIGJlIGluaXQnZWQgb24gZ2VuMyBhcyB3ZWxsPyBNYXR0ZXIg
b2YgYSBzZXBhcmF0ZSBwYXRjaCwgSQ0KPiA+IGNhbiBkbyBpdCBwcm9sbHkuLi4NCj4gDQo+IE9L
LiBNYXkgYmUgYWZ0ZXIgY29tcGxldGluZyBSWi9HMkwsIEkgY2FuIGludmVzdGlnYXRlIG9uIGdl
bjMgc3R1ZmYgb3IgSWYNCj4geW91IGhhdmUgUi1DYXIgYm9hcmQgYW5kIGNvbmZpcm0gdGhpcyBj
aGFuZ2UgV29uJ3QgYnJlYWsgYW55dGhpbmcgb24gUi1DYXINCj4gZ2VuMywgeW91IGNhbiBzdWJt
aXQgdGhlIHBhdGNoLg0KPiANCj4gUmVnYXJkcywNCj4gQmlqdQ0KPiANCj4gDQo+ID4NCj4gPiBb
Li4uXQ0KPiA+DQo+ID4gTUJSLCBTZXJnZXkNCg==
