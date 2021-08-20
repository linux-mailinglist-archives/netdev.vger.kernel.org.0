Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29D43F34BA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 21:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhHTTow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 15:44:52 -0400
Received: from mail-eopbgr1400108.outbound.protection.outlook.com ([40.107.140.108]:6496
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229693AbhHTTov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 15:44:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmfyK72la2X1V5XSxYGIzhWzNAhCGtRS9oftYI3iI4UtTFcKu886HA+9UcV/I5e2AMLrGuAVTX/AnEHcPgJt3sqzGbX/Fe5WbCzsPQo62lG37qe5usLdpYMaFy3pFODC5Gn+3KLezzECyobTuyA+gwf9HbJKwNgKcETD2o4gHBQcGMBK4qNfIn6tSOw/9yhQHzFWJeXXzIysnKfjFdlqVm9ZgK8G62PaqyXPQOncMbADaVnHRLGfCaZ5+hWEY8zfr5eXjt58NS8zkY9QTTJQpfWWwZjeb7U7LVgJvgBEJXNnYLEqa1UKwDqxdQCg+cMZ9BYz8F3PFJ2+63IrpyhhZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw8oVe5rTVpds8rDT3tir/UrpdRqeQP+maRIkDa9NkY=;
 b=VaDSbyAu2BJ+QhIEKAedyzUEp8xxa8zlGYvqfyfM3CK1gPNBsgCi676GkRgootcRAxGSSuh7HYNFe3OypyvZjbYaE8oi3zQksojmmD2ANwvd190VqS+9ULGchugv8LeoAokLYQYfqVMsbxklkkTh5rcmnyG/YlCx2GfiQhIxchYktIeudxf2rY8UFyKqFupCy0BKBfgzhs7K9H6sVyLCE/139bZsESOOeSORb29zIcZO96cdPjw5vlNDp7LbGkNJdnIpuGSe5qN5q74oUE6f8Y61/vAV44HU87T3RDOG00nmfpMXXKzVN1sha0oom4rekYsiyzb0dQw860ey4nWy9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw8oVe5rTVpds8rDT3tir/UrpdRqeQP+maRIkDa9NkY=;
 b=E6EMkgu/w0z6cC1zcJJA1Kpin9gLd3ROWghEqaFMFj2tiK9lNwxCZupO2QzzzSuwRFBAFKyJU0EiO1fSwQ2R2xw8i42Q3ME9Om10BTE6loCD+/nfZ6IjI0RGiz/B8P7BHY6nNqJurfFOjzztIYcFKs6p86p7PutDn1vFJ7vj8mo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6659.jpnprd01.prod.outlook.com (2603:1096:604:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 19:44:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Fri, 20 Aug 2021
 19:44:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
Thread-Topic: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
Thread-Index: AQHXfwPqpgs0zBUPBkKt0bRkdV6LC6tgrtUAgBwE95CAADiHAIAACrcw
Date:   Fri, 20 Aug 2021 19:44:07 +0000
Message-ID: <OS0PR01MB59229A8B5D56755163EF83C986C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
 <1bd80ea3-c216-a42a-c46c-0bb13173d793@gmail.com>
 <OS0PR01MB5922828353A987C9A474522C86C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <1dbfc326-5e15-d533-5b02-ef0680a8221f@omp.ru>
In-Reply-To: <1dbfc326-5e15-d533-5b02-ef0680a8221f@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4a08498-b1c2-4496-856c-08d96412dfbe
x-ms-traffictypediagnostic: OS3PR01MB6659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB665910E088638492D24D6A8E86C19@OS3PR01MB6659.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mVIlCcnoJsMqlvTmbfTWo2aUIULHL9gKQiCfGKzNoJgbKT8QbtYqtVvL90gOyIxV2xgwRJrAa2XHFIZSZm8395x5CTKpScFV9HS7XYQBmSYvvUz0b9WcgMQ65hqPzYQ7YPs4rmYhD2il9by44cVYTVFlqMPA5jxJI5CXZH7v+anaeEVeB9M6vOZY4GFU8CzCMNzsk6mnF+n86S0OURwwZ3xe/VeFWcJWTVJ2ualRyaxa2uGvjzjrW5mGpOoy2WQQ9hHm6WZqwEJmwN59wKzdPyVtXL8KtIsdxEy7lS8K3rqyZJ0OvUV38sMLdnI/blnfKkHCT+hPNIxIbTM3G8eAJ1zXtTd3WWhJ2xPqkEr/Y3fYoGgTaOlfYFaKUNm1RskS2w3vdIQoGDSJ6iHdJXsC4KLrxiM6RRpX/I1WQWufBBaktJoFyp1vsRQnkZ2gpiA7XO3osGqSes5lMa9SS5d4oPB+LVqn6mQ99QX6hc07V9m08SgOBCI1A5zNrffEJx1J6EVb94sJqAZ9ZDTGJKcXTucIL22FeGiyK99C+BqAFFnWSVSr0omNfpItv+yZ3t/pSvHnx1ATx03tFYBORxSdOb1dtzEpX2PqFjQO/RoZZIqxehHL2OPyZD4tk146xQmrRZtEtE/76Kg2SrlpXqw14VpJtL0HQHauXCR6u7dFSS3hMqdiChzIxogxI0gRhAGgrP87Vgg7CpOM5P/bz7/hSaQG/WPULcvyQyfJfGGe2dJ1mddvHg2tcHd4SGQwcueF5wO3wRiTyW34YLGcl10O2qwqoIORUTUqk1K+T3uVuSg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(366004)(346002)(136003)(376002)(396003)(66476007)(66946007)(66556008)(5660300002)(66446008)(33656002)(6506007)(76116006)(64756008)(26005)(2906002)(107886003)(53546011)(186003)(8676002)(8936002)(316002)(52536014)(4326008)(110136005)(966005)(86362001)(54906003)(71200400001)(7696005)(478600001)(7416002)(122000001)(38100700002)(38070700005)(83380400001)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHNFa2FoMWlld1hLVm5kbWlUS2l6dlM2NXdEcGVIbTRqVWtTbG54VGNKcDd1?=
 =?utf-8?B?TzNpbHVJWmNPZm0vOXpUR0t4TWZ3Z1lVQlBtdW1hckh5azgrKzNUcUVJd0xG?=
 =?utf-8?B?U0dMcXRFQXJEOS83Zk1jNUlrVzRORldNRnBBOGtTQndaQXlFbHlRT2dyaU90?=
 =?utf-8?B?RVZQNnhlUXJ0TlE2a2x6ZFJQd1ZYM3RLd3liNUNBTll2RFZVRENvMkZIUU9V?=
 =?utf-8?B?cXRYakxMVWlOSTd5KzQyV2FoZ0M4VG5KZlR1L2x4bW8yYzlaSE8rM3l1RlVQ?=
 =?utf-8?B?a3ppZk1JQ05Rcm9KRXlZV2JHdVVtTmZWK3lNdzN5OHp4NWc2ZnVSendZOUFa?=
 =?utf-8?B?MSs4ajlwNHVSOE9SWmhoRXFXMC9wVEpueHNpS1N6dG5zbWVTK3dMbHp6bEpH?=
 =?utf-8?B?S3dFQWU0ODlTQ0ZoRU5McElreTc3a2NjcUVjT2lwVTJZUVAwUmt1ckRLblRh?=
 =?utf-8?B?ZUV0K3hqdlJmRW5iZlNXZnovOTVIR0t0RjBuZmdEeUFMU1dkTjhpOHdhTXc3?=
 =?utf-8?B?VlFEOXZxNDUwcXJPblhuTkJOQUZ4OEgwTC9jTTc2NUJiSWM4ek1KYXIwUGZr?=
 =?utf-8?B?MWwzVXpJa21jdVZrNDgzekk1NzdWbk1xTldjcE52TVZCanFkLzdEdCsvUWtP?=
 =?utf-8?B?MmJQcUhkLzdWM1hoQnNVVEl4Y1hKWFYya3hvZUdyejRMcVFnRUVLUjNjU0lr?=
 =?utf-8?B?UWNlZVRDWTBBWDlZQTRGUjcxNlFteTY1T21nd3FHbTlDTmRxU0RlWkpEUDlj?=
 =?utf-8?B?MlNEZ0RVN1ZoZWUwaGxnbVhZL1VhQXNYcG1XLzU5SkltZ0hZWTM1QWkxSStF?=
 =?utf-8?B?aExacmJFNkU5QWFXQ000RXUxT0dKRU56THh2ak1DVzNWV3BoL2pITXZUWVVT?=
 =?utf-8?B?a3RLL1lhTGRzUXhYYVdzLzFDM3MralVqSEo0cTFIRk9VaWRPL3dJTDVpUml4?=
 =?utf-8?B?R3Z5R0piTjN4UTR5SnpRMDQ1NE5hL2sxV2tsSmdodnRUbWIzQ1FOYXA3MXV5?=
 =?utf-8?B?NWRHUTdYbzMyZnFRNlN6cEVLdElZZk5ROCtsN1FuVm92OUpoRnJic3V5dURu?=
 =?utf-8?B?SnVWZ2QrYW5WVUZaUTI5Um1nWko5eFdFRDdjUGJtVlVMZ2JZbUhjaW5keE5U?=
 =?utf-8?B?R3pVVGNoMzFHZDU5VVkrRk9qTGpNdjI3dzF1KytFY1ljOGtTRExCOGRsdTdj?=
 =?utf-8?B?MnNFaVZ0WEljK21BdlpnZnFTM0prQ0k4MXJ5ZGxQaVF0bzBZK0F2V3BmRCs4?=
 =?utf-8?B?V3BSaDZoUWZndGdLK1BOVXdNUGNsQTZjYnpndklSNmlhVElwZVBkSXJXTkdM?=
 =?utf-8?B?Tnpsd0wvZStHTlVibVhLdVJnSTBpN0ZCbWJ2OEFRNjkzcmEwV09INndqNEtl?=
 =?utf-8?B?L3hNcEY1S1BiYkJLVVQ3Yk5TS0s1czU3dCswTmdGMjBWUW9FNzBuaEMwOUxV?=
 =?utf-8?B?enZUR1JjazlxTlhwYVc1eVAwcm5iUmdVM0NqUEluRjZ2c0IzVVJkeFFnZDRR?=
 =?utf-8?B?S1JzYm5DakxCZWtZaEFNT0FNdVFrUHoyN3ozU092WmlQK2FaSHZDWWNWNFk0?=
 =?utf-8?B?cis3SUNlUjh3Y1JpVVF5L21aL3Q4eVJTMVFXS1M5Y29XakJpTzhxZ2J0U2dS?=
 =?utf-8?B?alNMZHNIeFJNeisxTy9vNlJQU2ZVNTYwSWhSS20zVlZUaWFXS1ZKMC8xMGlk?=
 =?utf-8?B?dnZ5dlg1L3dTU3BwT3U5a291ZGlrQUVTRTJIeEI2K3VETUpwVkh4cGpsVVd1?=
 =?utf-8?Q?kdor68U133diOM7EEk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a08498-b1c2-4496-856c-08d96412dfbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 19:44:07.3663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i3VkaHfJmrH0I5Svr6nsL4KcudjM3YMsw6q7HV67wiJW9YqInW9u9/ir05xiyaDiMs1X5Mf141QPZSnEmasocGYPgNSBV7o7kevJ+2VujGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMTIvMThdIHJhdmI6
IEZhY3RvcmlzZSB7ZW1hYyxkbWFjfSBpbml0DQo+IGZ1bmN0aW9uDQo+IA0KPiBPbiA4LzIwLzIx
IDY6NDIgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+IFRoZSBSLUNhciBB
VkIgbW9kdWxlIGhhcyBNYWdpYyBwYWNrZXQgZGV0ZWN0aW9uLCBtdWx0aXBsZSBpcnEncyBhbmQN
Cj4gPj4+IHRpbWVzdGFtcCBlbmFibGUgZmVhdHVyZXMgd2hpY2ggaXMgbm90IHByZXNlbnQgb24g
UlovRzJMIEdpZ2FiaXQNCj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
IGFyZQ0KPiA+DQo+ID4gT0suIFdpbGwgZml4IHRoaXMgaW4gbmV4dCBwYXRjaCBzZXQuDQo+ID4N
Cj4gPj4NCj4gPj4+IEV0aGVybmV0IG1vZHVsZS4gRmFjdG9yaXNlIGVtYWMgYW5kIGRtYWMgaW5p
dGlhbGl6YXRpb24gZnVuY3Rpb24gdG8NCj4gPj4+IHN1cHBvcnQgdGhlIGxhdGVyIFNvQy4NCj4g
Pj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+DQo+ID4+PiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFk
ZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8ICAyICsNCj4gPj4+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgNTgNCj4gPj4+ICsrKysrKysrKysrKysrKyst
LS0tLS0tLQ0KPiA+Pj4gIDIgZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMjAgZGVs
ZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oDQo+ID4+PiBpbmRleCBkODJiZmE2ZTU3YzEuLjRkNTkxMGRjZGE4NiAxMDA2NDQNCj4gPj4+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gQEAgLTk5Miw2ICs5OTIs
OCBAQCBzdHJ1Y3QgcmF2Yl9vcHMgew0KPiA+Pj4gIAl2b2lkICgqcmluZ19mcmVlKShzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwgaW50IHEpOw0KPiA+Pj4gIAl2b2lkICgqcmluZ19mb3JtYXQpKHN0
cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSk7DQo+ID4+PiAgCWJvb2wgKCphbGxvY19yeF9k
ZXNjKShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpOw0KPiA+Pj4gKwl2b2lkICgqZW1h
Y19pbml0KShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldik7DQo+ID4+PiArCXZvaWQgKCpkbWFjX2lu
aXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4gPj4+ICB9Ow0KPiA+Pj4NCj4gPj4+ICBz
dHJ1Y3QgcmF2Yl9kcnZfZGF0YSB7DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiBpbmRleCAzZDBmNjU5OGI5MzYuLmUyMDAxMTQzNzZl
NCAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPj4+IEBAIC00NTQsNyArNDU0LDcgQEAgc3RhdGljIGludCByYXZiX3JpbmdfaW5pdChz
dHJ1Y3QgbmV0X2RldmljZQ0KPiA+Pj4gKm5kZXYsIGludCBxKSAgfQ0KPiA+Pj4NCj4gPj4+ICAv
KiBFLU1BQyBpbml0IGZ1bmN0aW9uICovDQo+ID4+PiAtc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2lu
aXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4+PiArc3RhdGljIHZvaWQgcmF2Yl9lbWFj
X2luaXRfZXgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4+PiAgew0KPiA+Pj4gIAkvKiBS
ZWNlaXZlIGZyYW1lIGxpbWl0IHNldCByZWdpc3RlciAqLw0KPiA+Pj4gIAlyYXZiX3dyaXRlKG5k
ZXYsIG5kZXYtPm10dSArIEVUSF9ITEVOICsgVkxBTl9ITEVOICsgRVRIX0ZDU19MRU4sDQo+ID4+
PiBSRkxSKTsgQEAgLTQ4MCwzMCArNDgwLDE5IEBAIHN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0
KHN0cnVjdA0KPiA+PiBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+Pj4gIAlyYXZiX3dyaXRlKG5kZXYs
IEVDU0lQUl9JQ0RJUCB8IEVDU0lQUl9NUERJUCB8IEVDU0lQUl9MQ0hOR0lQLA0KPiA+Pj4gRUNT
SVBSKTsgIH0NCj4gPj4+DQo+ID4+PiAtLyogRGV2aWNlIGluaXQgZnVuY3Rpb24gZm9yIEV0aGVy
bmV0IEFWQiAqLw0KPiA+Pg0KPiA+PiAgICBHcnIsIHRoaXMgY29tbWVudCBzZWVtcyBvdWRhdGVk
Li4uDQo+ID4NCj4gPiBPSy4NCj4gDQo+ICAgIEp1c3QgZG9uJ3QgbW92ZSB0aGUgY29tbWVudC4g
Oi0pDQo+IA0KPiA+Pj4gLXN0YXRpYyBpbnQgcmF2Yl9kbWFjX2luaXQoc3RydWN0IG5ldF9kZXZp
Y2UgKm5kZXYpDQo+ID4+PiArc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXQoc3RydWN0IG5ldF9k
ZXZpY2UgKm5kZXYpDQo+ID4+PiAgew0KPiA+Pj4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2
ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4+PiAgCWNvbnN0IHN0cnVjdCByYXZiX2Rydl9kYXRh
ICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPj4+IC0JaW50IGVycm9yOw0KPiA+Pj4NCj4gPj4+IC0J
LyogU2V0IENPTkZJRyBtb2RlICovDQo+ID4+PiAtCWVycm9yID0gcmF2Yl9jb25maWcobmRldik7
DQo+ID4+PiAtCWlmIChlcnJvcikNCj4gPj4+IC0JCXJldHVybiBlcnJvcjsNCj4gPj4+IC0NCj4g
Pj4+IC0JZXJyb3IgPSByYXZiX3JpbmdfaW5pdChuZGV2LCBSQVZCX0JFKTsNCj4gPj4+IC0JaWYg
KGVycm9yKQ0KPiA+Pj4gLQkJcmV0dXJuIGVycm9yOw0KPiA+Pj4gLQllcnJvciA9IHJhdmJfcmlu
Z19pbml0KG5kZXYsIFJBVkJfTkMpOw0KPiA+Pj4gLQlpZiAoZXJyb3IpIHsNCj4gPj4+IC0JCXJh
dmJfcmluZ19mcmVlKG5kZXYsIFJBVkJfQkUpOw0KPiA+Pj4gLQkJcmV0dXJuIGVycm9yOw0KPiA+
Pj4gLQl9DQo+ID4+PiArCWluZm8tPnJhdmJfb3BzLT5lbWFjX2luaXQobmRldik7DQo+ID4+PiAr
fQ0KPiA+Pg0KPiA+PiAgICBUaGUgd2hvbGUgcmF2Yl9lbWFjX2luaXQoKSBub3cgY29uc2lzdHMg
b25seSBvZiBhIHNpbmdsZSBtZXRob2QNCj4gY2FsbD8NCj4gPj4gV2h5IGRvIHdlIG5lZWQgaXQg
YXQgYWxsPw0KPiA+DQo+ID4gT0sgd2lsbCBhc3NpZ24gaW5mby0+ZW1hY19pbml0IHdpdGggcmF2
Yl9lbWFjX2luaXQsIHNvIEdiRXRoZXJuZXQganVzdA0KPiA+IG5lZWQgdG8gZmlsbCBlbWFjX2lu
aXQgZnVuY3Rpb24uIEkgd2lsbCByZW1vdmUgdGhlIGZ1bmN0aW9uDQo+ICJyYXZiX2VtYWNfaW5p
dF9leCIuDQo+IA0KPiAgIFdpbGwgdGhlIEVNQUMgaW5pdCBtZXRob2RzIGRpZmZlciBzbyBtdWNo
IGFzIHRvIHdlIHNob3VsZCBwcm92aWRlIDINCj4gc2VwYXJhdGUgaW1wbGVtZW50YXRpb25zPw0K
PiANCj4gWy4uLl0NCj4gPj4+ICtzdGF0aWMgdm9pZCByYXZiX2RtYWNfaW5pdF9leChzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldikNCj4gPj4NCj4gPj4gICAgUGxlYXNlIG5vIF9leCBzdWZmaXhlcyAt
LSByZW1pbmRzIG1lIG9mIFdpbmRvemUgdG9vIG11Y2guIDotKQ0KPiA+DQo+ID4gT0suIFdpbGwg
Y2hhbmdlIGl0IHRvIHJhdmJfZGV2aWNlX2luaXQNCj4gDQo+ICAgIFVnaCEgV2h5IG5vdCBsZWF2
ZSBpdCBuYW1lZCByYXZiX2RtYWNfaW5pdCgpPw0KDQpQbGVhc2Ugc2VlIFsxXSBiZWxvdyBhbmQg
YWxzbyBwbGFubmluZyB0byBzZW5kIGFub3RoZXIgMTAgc21hbGwgaW5jcmVtZW50YWwgcGF0Y2hl
cywNClNvIHRoYXQgaXQgaXMgY2xlYXIgdG8gZXZlcnkgb25lLg0KDQo+IA0KPiA+IFJlZ2FyZHMs
DQo+ID4gQmlqdQ0KPiA+DQo+ID4+DQo+ID4+PiArew0KPiA+Pj4gKwlzdHJ1Y3QgcmF2Yl9wcml2
YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4+PiArCWNvbnN0IHN0cnVjdCByYXZi
X2Rydl9kYXRhICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPj4+DQo+ID4+PiAgCS8qIFNldCBBVkIg
UlggKi8NCj4gPj4+ICAJcmF2Yl93cml0ZShuZGV2LA0KPiA+Pj4gQEAgLTUzMCw2ICs1MTksMzMg
QEAgc3RhdGljIGludCByYXZiX2RtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmRldikN
Cj4gPj4+ICAJcmF2Yl93cml0ZShuZGV2LCBSSUMyX1FGRTAgfCBSSUMyX1FGRTEgfCBSSUMyX1JG
RkUsIFJJQzIpOw0KPiA+Pj4gIAkvKiBGcmFtZSB0cmFuc21pdHRlZCwgdGltZXN0YW1wIEZJRk8g
dXBkYXRlZCAqLw0KPiA+Pj4gIAlyYXZiX3dyaXRlKG5kZXYsIFRJQ19GVEUwIHwgVElDX0ZURTEg
fCBUSUNfVEZVRSwgVElDKTsNCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+PiArc3RhdGljIGludCBy
YXZiX2RtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgew0KPiA+Pj4gKwlzdHJ1Y3Qg
cmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4+PiArCWNvbnN0IHN0
cnVjdCByYXZiX2Rydl9kYXRhICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPj4+ICsJaW50IGVycm9y
Ow0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiBTZXQgQ09ORklHIG1vZGUgKi8NCj4gPj4+ICsJZXJyb3Ig
PSByYXZiX2NvbmZpZyhuZGV2KTsNCj4gPj4+ICsJaWYgKGVycm9yKQ0KPiA+Pj4gKwkJcmV0dXJu
IGVycm9yOw0KPiA+Pj4gKw0KPiA+Pj4gKwllcnJvciA9IHJhdmJfcmluZ19pbml0KG5kZXYsIFJB
VkJfQkUpOw0KPiA+Pj4gKwlpZiAoZXJyb3IpDQo+ID4+PiArCQlyZXR1cm4gZXJyb3I7DQo+ID4+
PiArCWVycm9yID0gcmF2Yl9yaW5nX2luaXQobmRldiwgUkFWQl9OQyk7DQo+ID4+PiArCWlmIChl
cnJvcikgew0KPiA+Pj4gKwkJcmF2Yl9yaW5nX2ZyZWUobmRldiwgUkFWQl9CRSk7DQo+ID4+PiAr
CQlyZXR1cm4gZXJyb3I7DQo+ID4+PiArCX0NCj4gPj4+ICsNCj4gPj4+ICsJLyogRGVzY3JpcHRv
ciBmb3JtYXQgKi8NCj4gPj4+ICsJcmF2Yl9yaW5nX2Zvcm1hdChuZGV2LCBSQVZCX0JFKTsNCj4g
Pj4+ICsJcmF2Yl9yaW5nX2Zvcm1hdChuZGV2LCBSQVZCX05DKTsNCj4gPj4+ICsNCj4gPj4+ICsJ
aW5mby0+cmF2Yl9vcHMtPmRtYWNfaW5pdChuZGV2KTsNCj4gPj4+DQo+ID4+PiAgCS8qIFNldHRp
bmcgdGhlIGNvbnRyb2wgd2lsbCBzdGFydCB0aGUgQVZCLURNQUMgcHJvY2Vzcy4gKi8NCj4gPj4+
ICAJcmF2Yl9tb2RpZnkobmRldiwgQ0NDLCBDQ0NfT1BDLCBDQ0NfT1BDX09QRVJBVElPTik7IEBA
IC0yMDE4LDYNCj4gPj4+ICsyMDM0LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX29wcyBy
YXZiX2dlbjNfb3BzID0gew0KPiA+Pj4gIAkucmluZ19mcmVlID0gcmF2Yl9yaW5nX2ZyZWVfcngs
DQo+ID4+PiAgCS5yaW5nX2Zvcm1hdCA9IHJhdmJfcmluZ19mb3JtYXRfcngsDQo+ID4+PiAgCS5h
bGxvY19yeF9kZXNjID0gcmF2Yl9hbGxvY19yeF9kZXNjLA0KPiA+Pj4gKwkuZW1hY19pbml0ID0g
cmF2Yl9lbWFjX2luaXRfZXgsDQo+ID4+PiArCS5kbWFjX2luaXQgPSByYXZiX2RtYWNfaW5pdF9l
eCwNCj4gPj4NCj4gPj4gICAgSG1tLCB3aHkgbm90IGFsc28gZ2VuMj8hDQo+IA0KPiAgICBUaGUg
cXVlc3Rpb24gcmVtYWluZWQgdW5yZXBsaWVkPy4uLiA6LS8NCg0KcmF2Yl9vcHMgZm9yIGdlbjMg
YW5kIGdlbjIgc2FtZS4gQnV0IFJaL0cyTCBoYXZlIGRpZmZlcmVudCBmdW5jdGlvbiBwb2ludGVy
c1sxXS4NCg0KQXMgYWdyZWVkIG9uIG5leHQgcGF0Y2hzZXQsIHdlIGFyZSBhdm9pZGluZyBpbmRp
cmVjdGlvbiBhbmQgaXQgd2lsbCBiZSBod19pZm8uDQpJbiB0aGF0IGNhc2UgdGhlcmUgd2lsbCBi
ZSAxIGVudHJ5IGluIGdlbjMgYW5kIDEgZW50cnkgaW4gZ2VuMi4gSG9wZSB0aGlzIGNsZWFycw0K
WW91ciBkb3VidHMuDQoNClsxXSBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bGludXgtcmVuZXNhcy1zb2MvcGF0Y2gvMjAyMTA3MjIxNDEzNTEuMTM2NjgtMTgtYmlqdS5kYXMu
anpAYnAucmVuZXNhcy5jb20vDQoNCkNoZWVycywNCkJpanUNCg==
