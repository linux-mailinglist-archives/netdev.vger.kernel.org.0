Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CE53F2FBF
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbhHTPnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:43:04 -0400
Received: from mail-eopbgr1410095.outbound.protection.outlook.com ([40.107.141.95]:17976
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241034AbhHTPnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:43:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHkVG3si/48UEx5AAOGwfOBJez2CaCnoDyIdrKwVUVMq03Utgqdr5V51UTfDrKFntxT/lugR+m3oDeQMSJlZr7tiQ0s7M3ZXnp4tgmfJBId5vaRu2Z4gPf3BZh61XTknsmqo1O0LZKGp0WMMRkt/xNky3FoJYKAMEy7rqlnlCOXQneKmw8mNjzKoVCUUWAj3bDSgeOaBdXmng6QozctBA5y1Biac4tq02yg6ksacVc4woaulfyi32DsExSTuRGZ33WDvIuQVWKAil7gvpzYlxjKk0BVnCMRse9k68WGzKDjH5HqDuCKteLjI/V34K2krbFWrxlK0BX9If6eoXCvz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPSBl1R9gmU8Hvj+sRsuxxc/NFkahnHHa+9oz70E2xs=;
 b=OLx8LaYx+WXt8x5GMJe2aKEg4VI781xGjcu7foGLlHB17pjlA6E46li6Nvi1kl6CmXf5hNO25xu6TM8Dvrqb0y0qzR7XXRYMx3JirkyyRjdoAh88SjLaGqa0O0+Xd3q+87hcXeZ8xEHmrgnuhKsDYShAejJD9bwdT88tDB5Ufmt88ooktmBcqg1c0NrEWoMqLdMcemwd7sUedp1XOz23qyoSIE7eRyDYoi5GHRHagUc5/H4/9lqmil/JT2E5Fu3ny8j6lFuauUP7LUAbsgSEI1dYdDJm1PWdguYyVec+CMgRENHwN2v1JXew8tsSQiLjU6CQsdM6G27v2vVnc/V9gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPSBl1R9gmU8Hvj+sRsuxxc/NFkahnHHa+9oz70E2xs=;
 b=j7cB7nbifLxEUd+kuv8WweuXnBqTQ6pUkGbnGrUJ8jHSyeBxzmpuCMEDWPSZUHKcPUjQrsJ7A1YOUr3BMeLa2+GxDlQ4dmooe+yQmLWk94wPbnjPw1YfPDh8gLJtgh1BkV972LawoFjLD3yJJ/owvAsoV4NMDu0leup0dGEwQ6w=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2936.jpnprd01.prod.outlook.com (2603:1096:604:18::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.20; Fri, 20 Aug
 2021 15:42:22 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Fri, 20 Aug 2021
 15:42:22 +0000
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
Subject: RE: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
Thread-Topic: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
Thread-Index: AQHXfwPqpgs0zBUPBkKt0bRkdV6LC6tgrtUAgBwE95A=
Date:   Fri, 20 Aug 2021 15:42:22 +0000
Message-ID: <OS0PR01MB5922828353A987C9A474522C86C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
 <1bd80ea3-c216-a42a-c46c-0bb13173d793@gmail.com>
In-Reply-To: <1bd80ea3-c216-a42a-c46c-0bb13173d793@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c7fd8b7-ac88-4f06-e627-08d963f119da
x-ms-traffictypediagnostic: OSBPR01MB2936:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2936D2619D386DBD2ED844A786C19@OSBPR01MB2936.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKRSTPsEy/aNPv8UAc9pNKoy6QiwNYwazgd93BzZexf6o409JBsLkNnULnTbVODOjb2a8/WCzU2BIFHinZJUQEmiiB5gFzXA0GUvfMznWja4JzcMCi1P7u6Izvlma5ee8Woi4054kijKJYdrP1zZe35z/ZolKs3Db0HLzCXMTQfjsAJM6HqqHKZkOc0cts/2pWaCUkCfCxcmno9qiq1/DJ4N0I7/pHvhF83NE4HM3TB83TBqp4+VMVd8ZvNLlpfK9nrvHngvYbYqth/j0MeoDc6CMRUZHrKrYivGaGpmSk43y4KrZMcUhdIAw+8cV/ihEeK+psrAZfRncukxPjxDczivpaQ7jFhQdqbfCZkYH1JUpYbKyL9LcrKKv9Yfu5MZ2uC23DijKrlte/CojGEM/8u6hqFxMnJsA/h+av1S5sDg6FpY4AqX333Lfmx6bA3v9udT4w9Vh5l5x91k+kKwXLNBxc0+7nl93u0fXyP40shR7s3OPuqslmuHoZpg1123HtBHs/nGM/+FCB1EIv4vF6Uek4JVcFaXdfwp3PtKVkqbnc0AsnZxaLnniF9ux/ZhrAsV+CCYy5888tQw8yD+QUgCpY7naCRkHN9RdD6rKCNgJCh49nizR5kmDyrCiIsbKL7JAcC0rHYORi9q0utMSC+Gqij5n71MnoAX0BFsOisrTaVOD7Pmw7y+84rWlJlwNDpoq2Ceaq1PaBcCOMKFFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(366004)(396003)(9686003)(38070700005)(6506007)(110136005)(86362001)(107886003)(7416002)(64756008)(8676002)(52536014)(54906003)(71200400001)(55016002)(7696005)(33656002)(316002)(26005)(38100700002)(478600001)(83380400001)(66946007)(66556008)(122000001)(2906002)(53546011)(5660300002)(186003)(66446008)(8936002)(76116006)(4326008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1NSa3ltRUtUajlmZDl0TVZUSWxhMGlyMWVpQXhOZjhXM28zdXhvV1N1dVMr?=
 =?utf-8?B?ZmpSblR4UThGRWkyd2VoWEp5RWpaVzE2TVhrODFFdWFsSHdLYUhmRHlRVlQy?=
 =?utf-8?B?RXdxTzUwVzdIUXV3N2Q0QUErT0t3bUp4MkUyaFN2dnY1UWNXUzNIaXRhRWFx?=
 =?utf-8?B?WWNLZ1ZWRSthZ25kTjB6eDIrZkNLOHhRNjhFSFY5Wk1Pb3paS290bG9iY1hP?=
 =?utf-8?B?dDN2Q3laVDJickE5T21GMjZDNjFqNW5vbkVmRWNJUTRrY0NSZjhOSWE3ZFg0?=
 =?utf-8?B?bmJlOTRCK0dyU3RFeGlZL1FVZ1U2YjJhWXphTnpNMVVMWkw2MDB1Mk85dXQ3?=
 =?utf-8?B?OHBrM3YxTVRmS0Y1eG92dUhLNEhNUTNOVVJTZ0lUYld1R0ZIcFRSTlR3a0Ex?=
 =?utf-8?B?UmxQTzNQc2lPdFZEY3MwSmJrL3gwOGVscGFPYVBxcFgyVEtocGZFR3RjNitn?=
 =?utf-8?B?dDYrS01Rc0JLYXNkYVlHTEJkN0NnSlhxbit5cm5WTjMzQXJmUjVOQUpYKzgw?=
 =?utf-8?B?ZkRVWGk2MkVHeDgzcVNobHVyOWZoSXF6aTJ6VVVTcTNLTEo5TzFsYXBOMFc0?=
 =?utf-8?B?TFR3S01MUjd6VGlsWCtDaXhUMFM2Q0JETDJYYmJzNWxMazE0NWUwbStxc25v?=
 =?utf-8?B?V2xFMlpBRFN6a2ZEc2NNcUJ4dTdsZXJuZy9tMWdLbzgyVVVIZTFCdkZmOTVK?=
 =?utf-8?B?Zmxoem1SMnZCcElVZ3NDYXFCTTE0SU1QalNwWXpOTVErcFcvNSs5RVlJZVZB?=
 =?utf-8?B?Qk1HTE16U0hySnYzQmRIRVRDdnBFMnREbFo1SFAwSWJVeVBuYXlOVGRWeWZ4?=
 =?utf-8?B?RXplN3NRZzRjMExLcGM5a3c5eEFFbXk2QzZNMys1VmNPMkE0Zmx1cnFCSVBZ?=
 =?utf-8?B?b21SRjRFbkZyZ0VhalJGZkN5WUdKbDFLOEhDNGN0YTAvNHU1SGJYVVZCZmxP?=
 =?utf-8?B?MWQ3aVJ3blk5RXIvUEJ1NFRLVFNpSUVhSzBFNXNnbUxrZHViV3ljU1Y0ek12?=
 =?utf-8?B?YXhUUUVNYjRIc3VhVEdsamF5c2VQdnZmOFkrbE1URlA2Lzg3UEd2cmJKNG9w?=
 =?utf-8?B?Y3BkMVlHUSt1ejg3ay84VTd1Qjl5L0YvUzhQSnNHYk9rRlp4czdtSU9nNG1z?=
 =?utf-8?B?dCtYOVlKVWpMbmtkMFhIWld4ckZqV3dMMW9JZEd2ZTZWb0lnaXNBWnNVcnFV?=
 =?utf-8?B?Rk5HbUZMQWZubjB1VHduNzJSYy9wOCtpMDZpWEtWVVZORm84QW1SQTdzZkZo?=
 =?utf-8?B?U1J2TlFlam56K1AvQWRURUJZQXIvVllUc1laRWkyUUkxTE00QmRBVXA0Q283?=
 =?utf-8?B?dzhEYTQ1NTBzbzZ2SlBKdDIvL3NyYUhRTUp2WmR0cVU3clJwVFJPZHdtay95?=
 =?utf-8?B?U2oxRTVJdDhwOWZzTGhaZXQvcnFSNlRNQk05OUMrUWxaRDQ3RW5UOVYyYjV2?=
 =?utf-8?B?cmVQYW1qS1RKL3M4NTJwK2ZqajBaa1RRelN3OVVZYmhUYTFsMXRTSHBKMHNj?=
 =?utf-8?B?Tnhobks1eklmVXIyVUEwYWxWRXYrU29pdFdwVjNRSlZHcEFkOG5nY0t6by9O?=
 =?utf-8?B?NklJRy93cjBwU0lnc0VidXFjQlNvNVVOVEw1SlhQMVJycG9nK21UOHBLOXhD?=
 =?utf-8?B?K2xiQS9RT2JjM1g5YVZuTW91eFdMd2VlL1NtMXVBWm55MHFYVWpqSnArakQ2?=
 =?utf-8?B?TkYrbnhjREtQOUNQaDBDNk9EdVIvUDVkUGRSOG9CaGdha21uRStVSHMzZ3My?=
 =?utf-8?Q?rgm9dIna58w/CNr3+o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c7fd8b7-ac88-4f06-e627-08d963f119da
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 15:42:22.0400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2s0CC55akDo4Cu+NS34tchHwnwzhf/daG6MNQlR/zt+YOWtgHyQdII0yBEdjcJugWkw1BpmcOCDhFOt5XCSJqCnDFnZ56QDoSZTnCjm1i1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiA8cHJhYmhha2FyLm1h
aGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1u
ZXh0IDEyLzE4XSByYXZiOiBGYWN0b3Jpc2Uge2VtYWMsZG1hY30gaW5pdA0KPiBmdW5jdGlvbg0K
PiANCj4gSGVsbG8hDQo+IA0KPiBPbiA3LzIyLzIxIDU6MTMgUE0sIEJpanUgRGFzIHdyb3RlOg0K
PiANCj4gPiBUaGUgUi1DYXIgQVZCIG1vZHVsZSBoYXMgTWFnaWMgcGFja2V0IGRldGVjdGlvbiwg
bXVsdGlwbGUgaXJxJ3MgYW5kDQo+ID4gdGltZXN0YW1wIGVuYWJsZSBmZWF0dXJlcyB3aGljaCBp
cyBub3QgcHJlc2VudCBvbiBSWi9HMkwgR2lnYWJpdA0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF4gYXJlDQoNCk9LLiBXaWxsIGZpeCB0aGlzIGluIG5leHQgcGF0Y2ggc2V0
Lg0KDQo+IA0KPiA+IEV0aGVybmV0IG1vZHVsZS4gRmFjdG9yaXNlIGVtYWMgYW5kIGRtYWMgaW5p
dGlhbGl6YXRpb24gZnVuY3Rpb24gdG8NCj4gPiBzdXBwb3J0IHRoZSBsYXRlciBTb0MuDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5y
akBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmggICAgICB8ICAyICsNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYyB8IDU4DQo+ID4gKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDIg
ZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggZDgyYmZhNmU1
N2MxLi40ZDU5MTBkY2RhODYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaA0KPiA+IEBAIC05OTIsNiArOTkyLDggQEAgc3RydWN0IHJhdmJfb3BzIHsNCj4gPiAgCXZv
aWQgKCpyaW5nX2ZyZWUpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSk7DQo+ID4gIAl2
b2lkICgqcmluZ19mb3JtYXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSk7DQo+ID4g
IAlib29sICgqYWxsb2NfcnhfZGVzYykoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKTsN
Cj4gPiArCXZvaWQgKCplbWFjX2luaXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4gPiAr
CXZvaWQgKCpkbWFjX2luaXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4gPiAgfTsNCj4g
Pg0KPiA+ICBzdHJ1Y3QgcmF2Yl9kcnZfZGF0YSB7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCAzZDBmNjU5OGI5MzYuLmUyMDAxMTQz
NzZlNCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+IEBAIC00NTQsNyArNDU0LDcgQEAgc3RhdGljIGludCByYXZiX3JpbmdfaW5pdChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwNCj4gPiBpbnQgcSkgIH0NCj4gPg0KPiA+ICAvKiBFLU1BQyBp
bml0IGZ1bmN0aW9uICovDQo+ID4gLXN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0KHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2KQ0KPiA+ICtzdGF0aWMgdm9pZCByYXZiX2VtYWNfaW5pdF9leChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiAgew0KPiA+ICAJLyogUmVjZWl2ZSBmcmFtZSBsaW1p
dCBzZXQgcmVnaXN0ZXIgKi8NCj4gPiAgCXJhdmJfd3JpdGUobmRldiwgbmRldi0+bXR1ICsgRVRI
X0hMRU4gKyBWTEFOX0hMRU4gKyBFVEhfRkNTX0xFTiwNCj4gPiBSRkxSKTsgQEAgLTQ4MCwzMCAr
NDgwLDE5IEBAIHN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0KHN0cnVjdA0KPiBuZXRfZGV2aWNl
ICpuZGV2KQ0KPiA+ICAJcmF2Yl93cml0ZShuZGV2LCBFQ1NJUFJfSUNESVAgfCBFQ1NJUFJfTVBE
SVAgfCBFQ1NJUFJfTENITkdJUCwNCj4gPiBFQ1NJUFIpOyAgfQ0KPiA+DQo+ID4gLS8qIERldmlj
ZSBpbml0IGZ1bmN0aW9uIGZvciBFdGhlcm5ldCBBVkIgKi8NCj4gDQo+ICAgIEdyciwgdGhpcyBj
b21tZW50IHNlZW1zIG91ZGF0ZWQuLi4NCg0KT0suDQo+IA0KPiA+IC1zdGF0aWMgaW50IHJhdmJf
ZG1hY19pbml0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+ICtzdGF0aWMgdm9pZCByYXZi
X2VtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiAgew0KPiA+ICAJc3RydWN0
IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICAJY29uc3Qgc3Ry
dWN0IHJhdmJfZHJ2X2RhdGEgKmluZm8gPSBwcml2LT5pbmZvOw0KPiA+IC0JaW50IGVycm9yOw0K
PiA+DQo+ID4gLQkvKiBTZXQgQ09ORklHIG1vZGUgKi8NCj4gPiAtCWVycm9yID0gcmF2Yl9jb25m
aWcobmRldik7DQo+ID4gLQlpZiAoZXJyb3IpDQo+ID4gLQkJcmV0dXJuIGVycm9yOw0KPiA+IC0N
Cj4gPiAtCWVycm9yID0gcmF2Yl9yaW5nX2luaXQobmRldiwgUkFWQl9CRSk7DQo+ID4gLQlpZiAo
ZXJyb3IpDQo+ID4gLQkJcmV0dXJuIGVycm9yOw0KPiA+IC0JZXJyb3IgPSByYXZiX3JpbmdfaW5p
dChuZGV2LCBSQVZCX05DKTsNCj4gPiAtCWlmIChlcnJvcikgew0KPiA+IC0JCXJhdmJfcmluZ19m
cmVlKG5kZXYsIFJBVkJfQkUpOw0KPiA+IC0JCXJldHVybiBlcnJvcjsNCj4gPiAtCX0NCj4gPiAr
CWluZm8tPnJhdmJfb3BzLT5lbWFjX2luaXQobmRldik7DQo+ID4gK30NCj4gDQo+ICAgIFRoZSB3
aG9sZSByYXZiX2VtYWNfaW5pdCgpIG5vdyBjb25zaXN0cyBvbmx5IG9mIGEgc2luZ2xlIG1ldGhv
ZCBjYWxsPw0KPiBXaHkgZG8gd2UgbmVlZCBpdCBhdCBhbGw/DQoNCk9LIHdpbGwgYXNzaWduIGlu
Zm8tPmVtYWNfaW5pdCB3aXRoIHJhdmJfZW1hY19pbml0LCBzbyBHYkV0aGVybmV0IGp1c3QgbmVl
ZCB0bw0KZmlsbCBlbWFjX2luaXQgZnVuY3Rpb24uIEkgd2lsbCByZW1vdmUgdGhlIGZ1bmN0aW9u
ICJyYXZiX2VtYWNfaW5pdF9leCIuDQoNCg0KPiANCj4gPg0KPiA+IC0JLyogRGVzY3JpcHRvciBm
b3JtYXQgKi8NCj4gPiAtCXJhdmJfcmluZ19mb3JtYXQobmRldiwgUkFWQl9CRSk7DQo+ID4gLQly
YXZiX3JpbmdfZm9ybWF0KG5kZXYsIFJBVkJfTkMpOw0KPiA+ICsvKiBEZXZpY2UgaW5pdCBmdW5j
dGlvbiBmb3IgRXRoZXJuZXQgQVZCICovDQo+IA0KPiAgICBzL0RldmljZS9ETUFDLy4gT3IgdGhp
cyBjb21tZW50IHNob3VsZG4ndCBoYXZlIGJlZW4gbW92ZWQuDQoNCk9LLg0KDQo+IA0KPiA+ICtz
dGF0aWMgdm9pZCByYXZiX2RtYWNfaW5pdF9leChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4g
DQo+ICAgIFBsZWFzZSBubyBfZXggc3VmZml4ZXMgLS0gcmVtaW5kcyBtZSBvZiBXaW5kb3plIHRv
byBtdWNoLiA6LSkNCg0KT0suIFdpbGwgY2hhbmdlIGl0IHRvIHJhdmJfZGV2aWNlX2luaXQNCg0K
UmVnYXJkcywNCkJpanUNCg0KPiANCj4gPiArew0KPiA+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAq
cHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfZHJ2X2Rh
dGEgKmluZm8gPSBwcml2LT5pbmZvOw0KPiA+DQo+ID4gIAkvKiBTZXQgQVZCIFJYICovDQo+ID4g
IAlyYXZiX3dyaXRlKG5kZXYsDQo+ID4gQEAgLTUzMCw2ICs1MTksMzMgQEAgc3RhdGljIGludCBy
YXZiX2RtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiAgCXJhdmJfd3JpdGUo
bmRldiwgUklDMl9RRkUwIHwgUklDMl9RRkUxIHwgUklDMl9SRkZFLCBSSUMyKTsNCj4gPiAgCS8q
IEZyYW1lIHRyYW5zbWl0dGVkLCB0aW1lc3RhbXAgRklGTyB1cGRhdGVkICovDQo+ID4gIAlyYXZi
X3dyaXRlKG5kZXYsIFRJQ19GVEUwIHwgVElDX0ZURTEgfCBUSUNfVEZVRSwgVElDKTsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCByYXZiX2RtYWNfaW5pdChzdHJ1Y3QgbmV0X2Rldmlj
ZSAqbmRldikgew0KPiA+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2
KG5kZXYpOw0KPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfZHJ2X2RhdGEgKmluZm8gPSBwcml2LT5p
bmZvOw0KPiA+ICsJaW50IGVycm9yOw0KPiA+ICsNCj4gPiArCS8qIFNldCBDT05GSUcgbW9kZSAq
Lw0KPiA+ICsJZXJyb3IgPSByYXZiX2NvbmZpZyhuZGV2KTsNCj4gPiArCWlmIChlcnJvcikNCj4g
PiArCQlyZXR1cm4gZXJyb3I7DQo+ID4gKw0KPiA+ICsJZXJyb3IgPSByYXZiX3JpbmdfaW5pdChu
ZGV2LCBSQVZCX0JFKTsNCj4gPiArCWlmIChlcnJvcikNCj4gPiArCQlyZXR1cm4gZXJyb3I7DQo+
ID4gKwllcnJvciA9IHJhdmJfcmluZ19pbml0KG5kZXYsIFJBVkJfTkMpOw0KPiA+ICsJaWYgKGVy
cm9yKSB7DQo+ID4gKwkJcmF2Yl9yaW5nX2ZyZWUobmRldiwgUkFWQl9CRSk7DQo+ID4gKwkJcmV0
dXJuIGVycm9yOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qIERlc2NyaXB0b3IgZm9ybWF0ICov
DQo+ID4gKwlyYXZiX3JpbmdfZm9ybWF0KG5kZXYsIFJBVkJfQkUpOw0KPiA+ICsJcmF2Yl9yaW5n
X2Zvcm1hdChuZGV2LCBSQVZCX05DKTsNCj4gPiArDQo+ID4gKwlpbmZvLT5yYXZiX29wcy0+ZG1h
Y19pbml0KG5kZXYpOw0KPiA+DQo+ID4gIAkvKiBTZXR0aW5nIHRoZSBjb250cm9sIHdpbGwgc3Rh
cnQgdGhlIEFWQi1ETUFDIHByb2Nlc3MuICovDQo+ID4gIAlyYXZiX21vZGlmeShuZGV2LCBDQ0Ms
IENDQ19PUEMsIENDQ19PUENfT1BFUkFUSU9OKTsgQEAgLTIwMTgsNg0KPiA+ICsyMDM0LDggQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX29wcyByYXZiX2dlbjNfb3BzID0gew0KPiA+ICAJLnJp
bmdfZnJlZSA9IHJhdmJfcmluZ19mcmVlX3J4LA0KPiA+ICAJLnJpbmdfZm9ybWF0ID0gcmF2Yl9y
aW5nX2Zvcm1hdF9yeCwNCj4gPiAgCS5hbGxvY19yeF9kZXNjID0gcmF2Yl9hbGxvY19yeF9kZXNj
LA0KPiA+ICsJLmVtYWNfaW5pdCA9IHJhdmJfZW1hY19pbml0X2V4LA0KPiA+ICsJLmRtYWNfaW5p
dCA9IHJhdmJfZG1hY19pbml0X2V4LA0KPiANCj4gICAgSG1tLCB3aHkgbm90IGFsc28gZ2VuMj8h
DQoNCg==
