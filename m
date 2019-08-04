Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC66E809D6
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 09:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfHDHpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 03:45:25 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:9952
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfHDHpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 03:45:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZRXbygt9bHRJ/BGra6tDZk/ga68yoSg3FX3gqJJ4MpPZSwAkGLw1KU8/wc8sEgskgMlZqJLxnG3lG4OTTvZKjYnA44V76FY4M75ewjfWDZZ/PD6tWhziWyWcGUlXsNrW0JYWisK9etz6Ku0tTwUf7x+VcWLoRIaDZo4rt0DgrFaIhgvaur7PmFOmuB1bgv7NVIA2Ohlm5jNKaXld0U0+LsKRvqxfg8tB4IJhkZvI9E2e9bofdnb7FUTB9DzZC7VXwoMNlFPqeq+b885/OqG9EmTa5nSViDnD7CpJOKwXzXp87Mk2OUdLbq433RCM5V7VMORgBuHdaHjvd3IuGaUGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUFPEYT7zByV+VTbK8DzYTHaxU6WKqeKiRiqigM8Eyc=;
 b=Gn73xoOSZ8C5Ec5QNG4AOooO4ooO3w7cm7sTbaSyai8m39bZxrQJJLG2TvkYxIVObvjsr77Q6MiEQXyyj1SZDioOZLBbP6gqW0QDCCcFt8O632K5spYfPVJ26QbofeP7tEq9115FZd1JH4gLeBmmAgrKHVmJ3mK5U+oi/4Xquv68TXgXxYBgEkjAgq9mlsMrZui4qw8sPxXFSnO5o62CKTQVpWUtVq5kpkMOvf4NVN+RJT1xLsBrT3UVT9Q7PQxWs0IM9i06pcUUXOJalmo0wHDZpDP0vhWRzZwXGCtwD2SqoSwcH8QKaGRcmXE+1PDO/GEImrXWQbh5n0RJ/d4gdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUFPEYT7zByV+VTbK8DzYTHaxU6WKqeKiRiqigM8Eyc=;
 b=PLJRVsuDmRJrxvIK+8lBbM+ipxZ3LtQonUQGXu0FwuJ3NExaVSxWSqQLmYQLp8XBhn1BsaBrVBIJ6MOfAot7vlJEm78mjZjr/hTgLeYYVp4r4St4I4u9oyvCKbCi6r3BaRvpsgP41yyOQRwZbjfwhZwmTbCgjwx1SD6y8kZ+syM=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6282.eurprd05.prod.outlook.com (20.179.40.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Sun, 4 Aug 2019 07:45:18 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2136.018; Sun, 4 Aug 2019
 07:45:18 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Qian Cai <cai@lca.pw>, "davem@davemloft.net" <davem@davemloft.net>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: always initialize frag->last_in_page
Thread-Topic: [PATCH v2] net/mlx5e: always initialize frag->last_in_page
Thread-Index: AQHVSHB34dK83pz4DEOTZ9OpSt9xaabqoDkA
Date:   Sun, 4 Aug 2019 07:45:18 +0000
Message-ID: <c7fc8950-29c3-aa38-b356-e58a4e516bf5@mellanox.com>
References: <1564667574-31542-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564667574-31542-1-git-send-email-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::23)
 To DBBPR05MB6283.eurprd05.prod.outlook.com (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f39b18a-cc58-4878-b5be-08d718afb240
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6282;
x-ms-traffictypediagnostic: DBBPR05MB6282:
x-microsoft-antispam-prvs: <DBBPR05MB6282637BBF38D84BB03F7E84AEDB0@DBBPR05MB6282.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(102836004)(2906002)(2501003)(6116002)(3846002)(316002)(66446008)(53546011)(66066001)(76176011)(4326008)(36756003)(31686004)(52116002)(6506007)(486006)(11346002)(476003)(2616005)(446003)(26005)(386003)(68736007)(54906003)(186003)(71190400001)(71200400001)(66946007)(8936002)(64756008)(66556008)(66476007)(81166006)(8676002)(81156014)(256004)(6512007)(6246003)(99286004)(478600001)(86362001)(25786009)(53936002)(14454004)(7736002)(31696002)(6486002)(110136005)(229853002)(5660300002)(6436002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6282;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C6vmwmtShlMDNyqobaLABJjqO+j1quX3dAM3084diDGxoGB31Zarm68U9WEwZQxafDBss+q1rfT1QRf/7gOz77TzTLG3ekJjiurmNosCJM73+JAjvD1qbjv69k6Dq1lTErTGL9iVz1gOD+trK91934H+KB4V8fM+pFtA/qYm7nyg/43LJOkr25v9GU2Q3t3jOkwvj24FjWm94cEdYhN0CaUm6B9gCH5wscijT84WdmOb+27qzxG6EHWMLEzhNuDoCRGRYceOHqtELAXkvYI/5kHX8Mej2gVa28E2Q6siSLW4a0iGtOvhYSb08aTq3YoDGQV1PaP/z4ygJQw+nSzxC+ycJOGSFNBkzNUPTaBi+vKA5EIGJG7k06mimqzmPDfoxH1kOP723Lm0OKC2sldgzsmFyDB4CrM2x6y01B8nbxw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A395A004120734D91B657E9C953DBCB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f39b18a-cc58-4878-b5be-08d718afb240
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2019 07:45:18.6942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6282
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMS8yMDE5IDQ6NTIgUE0sIFFpYW4gQ2FpIHdyb3RlOg0KPiBUaGUgY29tbWl0IDA2
OWQxMTQ2NWE4MCAoIm5ldC9tbHg1ZTogUlgsIEVuaGFuY2UgbGVnYWN5IFJlY2VpdmUgUXVldWUN
Cj4gbWVtb3J5IHNjaGVtZSIpIGludHJvZHVjZWQgYW4gdW5kZWZpbmVkIGJlaGF2aW91ciBiZWxv
dyBkdWUgdG8NCj4gImZyYWctPmxhc3RfaW5fcGFnZSIgaXMgb25seSBpbml0aWFsaXplZCBpbiBt
bHg1ZV9pbml0X2ZyYWdzX3BhcnRpdGlvbigpDQo+IHdoZW4sDQo+IA0KPiBpZiAobmV4dF9mcmFn
Lm9mZnNldCArIGZyYWdfaW5mb1tmXS5mcmFnX3N0cmlkZSA+IFBBR0VfU0laRSkNCj4gDQo+IG9y
IGFmdGVyIGJhaWxlZCBvdXQgdGhlIGxvb3AsDQo+IA0KPiBmb3IgKGkgPSAwOyBpIDwgbWx4NV93
cV9jeWNfZ2V0X3NpemUoJnJxLT53cWUud3EpOyBpKyspDQo+IA0KPiBBcyB0aGUgcmVzdWx0LCB0
aGVyZSBjb3VsZCBiZSBzb21lICJmcmFnIiBoYXZlIHVuaW5pdGlhbGl6ZWQNCj4gdmFsdWUgb2Yg
Imxhc3RfaW5fcGFnZSIuDQo+IA0KPiBMYXRlciwgZ2V0X2ZyYWcoKSBvYnRhaW5zIHRob3NlICJm
cmFnIiBhbmQgY2hlY2sgImZyYWctPmxhc3RfaW5fcGFnZSIgaW4NCj4gbWx4NWVfcHV0X3J4X2Zy
YWcoKSBhbmQgdHJpZ2dlcnMgdGhlIGVycm9yIGR1cmluZyBib290LiBGaXggaXQgYnkgYWx3YXlz
DQo+IGluaXRpYWxpemluZyAiZnJhZy0+bGFzdF9pbl9wYWdlIiB0byAiZmFsc2UiIGluDQo+IG1s
eDVlX2luaXRfZnJhZ3NfcGFydGl0aW9uKCkuDQo+IA0KPiBVQlNBTjogVW5kZWZpbmVkIGJlaGF2
aW91ciBpbg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcngu
YzozMjU6MTINCj4gbG9hZCBvZiB2YWx1ZSAxNzAgaXMgbm90IGEgdmFsaWQgdmFsdWUgZm9yIHR5
cGUgJ2Jvb2wnIChha2EgJ19Cb29sJykNCj4gQ2FsbCB0cmFjZToNCj4gICBkdW1wX2JhY2t0cmFj
ZSsweDAvMHgyNjQNCj4gICBzaG93X3N0YWNrKzB4MjAvMHgyYw0KPiAgIGR1bXBfc3RhY2srMHhi
MC8weDEwNA0KPiAgIF9fdWJzYW5faGFuZGxlX2xvYWRfaW52YWxpZF92YWx1ZSsweDEwNC8weDEy
OA0KPiAgIG1seDVlX2hhbmRsZV9yeF9jcWUrMHg4ZTgvMHgxMmNjIFttbHg1X2NvcmVdDQo+ICAg
bWx4NWVfcG9sbF9yeF9jcSsweGNhOC8weDFhOTQgW21seDVfY29yZV0NCj4gICBtbHg1ZV9uYXBp
X3BvbGwrMHgxN2MvMHhhMzAgW21seDVfY29yZV0NCj4gICBuZXRfcnhfYWN0aW9uKzB4MjQ4LzB4
OTQwDQo+ICAgX19kb19zb2Z0aXJxKzB4MzUwLzB4N2I4DQo+ICAgaXJxX2V4aXQrMHgyMDAvMHgy
NmMNCj4gICBfX2hhbmRsZV9kb21haW5faXJxKzB4YzgvMHgxMjgNCj4gICBnaWNfaGFuZGxlX2ly
cSsweDEzOC8weDIyOA0KPiAgIGVsMV9pcnErMHhiOC8weDE0MA0KPiAgIGFyY2hfY3B1X2lkbGUr
MHgxYTQvMHgzNDgNCj4gICBkb19pZGxlKzB4MTE0LzB4MWIwDQo+ICAgY3B1X3N0YXJ0dXBfZW50
cnkrMHgyNC8weDI4DQo+ICAgcmVzdF9pbml0KzB4MWFjLzB4MWRjDQo+ICAgYXJjaF9jYWxsX3Jl
c3RfaW5pdCsweDEwLzB4MTgNCj4gICBzdGFydF9rZXJuZWwrMHg0ZDQvMHg1N2MNCj4gDQo+IEZp
eGVzOiAwNjlkMTE0NjVhODAgKCJuZXQvbWx4NWU6IFJYLCBFbmhhbmNlIGxlZ2FjeSBSZWNlaXZl
IFF1ZXVlIG1lbW9yeSBzY2hlbWUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBRaWFuIENhaSA8Y2FpQGxj
YS5wdz4NCj4gLS0tDQo+IA0KPiB2MjogemVyby1pbml0IHRoZSB3aG9sZSBzdHJ1Y3QgaW5zdGVh
ZCBwZXIgVGFyaXEuDQo+IA0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9tYWluLmMgfCA1ICsrLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiBpbmRleCA0N2VlYTZiM2ExYzMuLmUxODEw
YzAzYTUxMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fbWFpbi5jDQo+IEBAIC0zMzEsMTIgKzMzMSwxMSBAQCBzdGF0aWMgaW5saW5l
IHU2NCBtbHg1ZV9nZXRfbXB3cWVfb2Zmc2V0KHN0cnVjdCBtbHg1ZV9ycSAqcnEsIHUxNiB3cWVf
aXgpDQo+ICAgDQo+ICAgc3RhdGljIHZvaWQgbWx4NWVfaW5pdF9mcmFnc19wYXJ0aXRpb24oc3Ry
dWN0IG1seDVlX3JxICpycSkNCj4gICB7DQo+IC0Jc3RydWN0IG1seDVlX3dxZV9mcmFnX2luZm8g
bmV4dF9mcmFnLCAqcHJldjsNCj4gKwlzdHJ1Y3QgbWx4NWVfd3FlX2ZyYWdfaW5mbyBuZXh0X2Zy
YWcgPSB7fTsNCj4gKwlzdHJ1Y3QgbWx4NWVfd3FlX2ZyYWdfaW5mbyAqcHJldiA9IE5VTEw7DQo+
ICAgCWludCBpOw0KPiAgIA0KPiAgIAluZXh0X2ZyYWcuZGkgPSAmcnEtPndxZS5kaVswXTsNCj4g
LQluZXh0X2ZyYWcub2Zmc2V0ID0gMDsNCj4gLQlwcmV2ID0gTlVMTDsNCj4gICANCj4gICAJZm9y
IChpID0gMDsgaSA8IG1seDVfd3FfY3ljX2dldF9zaXplKCZycS0+d3FlLndxKTsgaSsrKSB7DQo+
ICAgCQlzdHJ1Y3QgbWx4NWVfcnFfZnJhZ19pbmZvICpmcmFnX2luZm8gPSAmcnEtPndxZS5pbmZv
LmFyclswXTsNCj4gDQoNClJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5v
eC5jb20+DQoNClRoYW5rcy4NCg==
