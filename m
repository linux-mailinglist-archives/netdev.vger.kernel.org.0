Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAFDAF0C2
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfIJR6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:58:03 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:2614
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfIJR6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 13:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LV6sOEEG1NUuovhGZV8SLgz9wZbKP0VR6K/1fGz6m45gr5an1MzKwvYUQhEi+a1CL+3Bqns4M0MHmGFf9J8ey3YU8W7pvMMbbIg6msDZcxz7iHLMSgOs8a7NVzOroQKIqFgpR5tlDWG0tWDgx+dLDt8D2DMivCbU0CYau5HA4UGiWsxd32UZv1yOnVLAisLlV5rgEELwyKLF5tKBzgO+n9XlCUdn+PRQ+yFqc//7P7riZ2axWNjnnFFcGzilu4QTXbJnIO9z8/bXGHRcfOAmDyaEigN05lqS8uiLhreDjQPMZRlkjw7u1IvofK8wTYdO/2kT82rZS/d5i4/88cNjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qdDXE5Td/sNuJJ1MItAu6td+lVokrtfnCsvzx0VXNs=;
 b=jdRgs3VzbByoXw3pHD4rAHC7y/DTx4DuBNnnozikjRymM4gSdgRJ/ljVWMM0u8V4U/pbVoO9OjqQm/BzVi8p3JRKbv8hVCtT4bHIVpCPVHj/GUtaMlZwrbxVtOVzEoQupNUCCn3EfWnlkmfmpn/zQvZCFzopMu8Hf1yjGaC/AcQ/CkZ8dBplAO/MT7BMubt0itWVIdVjF2ecaUe7g/5BJdE1QEx/3tYclVNpU7awv/Zili2WvVH29kmcoctlAJK2c8K4eiBYeCC7FabKBfdHNPVb4lsDrMiZH7YJWj8rIKpBvsKvP66BW+3s5PQPoTq5IqfUTAlwjRqKXR42gatwzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qdDXE5Td/sNuJJ1MItAu6td+lVokrtfnCsvzx0VXNs=;
 b=pVJdXUMPEuSxk2FB1ArJNZFQPm+Dte3B/9u7zlTmGkweY6lhNTxbB9ccBHzL3ZvEkw1i4Oo2isXUXs26iMZaBk2qwg14eqNkHmZ0i8NILyidLW8PLsEWsdWTFzxvOA+Waui0lZ8CcEGHXR0N5nK8HPSiFWM00vQupkncwhHHVCk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2517.eurprd05.prod.outlook.com (10.168.77.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 17:56:53 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 17:56:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "arnd@arndb.de" <arnd@arndb.de>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlx5: fix type mismatch
Thread-Topic: [PATCH net-next 2/2] mlx5: fix type mismatch
Thread-Index: AQHVZ0ftxc7vqg/WeEiTpQ2hWssQwaclM6+A
Date:   Tue, 10 Sep 2019 17:56:53 +0000
Message-ID: <8311cb643690d3e80dddd5d4f2f6a7d923b9fbbc.camel@mellanox.com>
References: <20190909195024.3268499-1-arnd@arndb.de>
         <20190909195024.3268499-2-arnd@arndb.de>
In-Reply-To: <20190909195024.3268499-2-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afd1e2d4-d236-4229-6f01-08d73618436f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2517;
x-ms-traffictypediagnostic: DB6PR0501MB2517:|DB6PR0501MB2517:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB25179CAE2086299AB02AF623BEB60@DB6PR0501MB2517.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(199004)(189003)(186003)(53936002)(66556008)(64756008)(229853002)(25786009)(6306002)(71190400001)(71200400001)(14444005)(305945005)(446003)(11346002)(7736002)(118296001)(478600001)(110136005)(14454004)(58126008)(66066001)(5660300002)(6116002)(3846002)(66946007)(6512007)(6486002)(66476007)(76116006)(107886003)(81156014)(2906002)(966005)(2501003)(316002)(54906003)(6246003)(256004)(2201001)(102836004)(6506007)(76176011)(6436002)(86362001)(8676002)(26005)(36756003)(91956017)(2616005)(81166006)(486006)(8936002)(66446008)(99286004)(476003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2517;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0oVo8nqrD8ksOh31yWkxjYCNwguSNH+ienMyo1aYWShAuzhF9PoJVyLxpUugy84fHfxTm7uCgf2zbvVvCVl54WhYFa7nkq/JhoFvyXvvkwl/QAoAkPAxj9mBEOpjB/xXy/qvn+mjGbvKvaJY/QkP/A9aPLgpMvZ75fWxWJrajVLdwMHLfWNn9VnluB+XSEJSLfggafwm9rZeWKdzNeJXn3+0F49NnJPotL2Bd+xVSLvFObhO9OG1H50foPbkXV+lF4zlLyDdHUdC3ElzkUCfFEPagdxakoHYrjtneJUIXVqXLT+Pz8bcSdzC0Xb7RDyg1eAYS19sqQHmV1s7szuBNWWMwJimnfh3jfyJOGDRPpmGZ7+LtabcnC4ncBzRG4Tbr/lebPlTAagq2P52oGzTHPSCsOJVVrab0rjxG0DrBcA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA9C1C7972D52B45857CAC353E6244AC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd1e2d4-d236-4229-6f01-08d73618436f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 17:56:53.2167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 21mhpEs/XYxV9/gb4J6KkPUVf47hMevcYnAsIY1BYamedi9rpxyX09rfk/3fM+tj9Oer3/zF5fxFsvq3SCnM1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2517
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTA5IGF0IDIxOjUwICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBJbiBtbHg1LCBwb2ludGVycyB0byAncGh5c19hZGRyX3QnIGFuZCAndTY0JyBhcmUgbWl4ZWQg
c2luY2UgdGhlDQo+IGFkZGl0aW9uDQo+IG9mIHRoZSBwb29sIG1lbW9yeSBhbGxvY2F0b3IsIGxl
YWRpbmcgdG8gaW5jb3JyZWN0IGJlaGF2aW9yIG9uIDMyLWJpdA0KPiBhcmNoaXRlY3R1cmVzIGFu
ZCB0aGlzIGNvbXBpbGVyIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvc3RlZXJpbmcvZHJfaWNtX3Bvb2wuYzoxMjE6ODoNCj4gZXJyb3I6IGlu
Y29tcGF0aWJsZSBwb2ludGVyIHR5cGVzIHBhc3NpbmcgJ3U2NCAqJyAoYWthICd1bnNpZ25lZCBs
b25nDQo+IGxvbmcgKicpIHRvIHBhcmFtZXRlciBvZiB0eXBlICdwaHlzX2FkZHJfdCAqJyAoYWth
ICd1bnNpZ25lZCBpbnQgKicpDQo+IFstV2Vycm9yLC1XaW5jb21wYXRpYmxlLXBvaW50ZXItdHlw
ZXNdDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmljbV9tci0+ZG0uYWRk
ciwgJmljbV9tci0NCj4gPmRtLm9ial9pZCk7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0KPiBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmg6
MTA5MjozOTogbm90ZTogcGFzc2luZyBhcmd1bWVudCB0bw0KPiBwYXJhbWV0ZXIgJ2FkZHInIGhl
cmUNCj4gICAgICAgICAgICAgICAgICAgICAgICAgIHU2NCBsZW5ndGgsIHUxNiB1aWQsIHBoeXNf
YWRkcl90ICphZGRyLCB1MzINCj4gKm9ial9pZCk7DQo+IA0KPiBDaGFuZ2UgdGhlIGNvZGUgdG8g
dXNlICd1NjQnIGNvbnNpc3RlbnRseSBpbiBwbGFjZSBvZiAncGh5c19hZGRyX3QnDQo+IHRvDQo+
IGZpeCB0aGlzLiBUaGUgYWx0ZXJuYXRpdmUgb2YgdXNpbmcgcGh5c19hZGRyX3QgbW9yZSB3b3Vs
ZCByZXF1aXJlIGENCj4gbGFyZ2VyDQo+IHJld29yay4NCj4gDQo+IEZpeGVzOiAyOWNmOGZlYmQx
ODUgKCJuZXQvbWx4NTogRFIsIElDTSBwb29sIG1lbW9yeSBhbGxvY2F0b3IiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KDQpIaSBBcm5kLA0KDQpOYXRo
YW4gQ2hhbmNlbGxvciBBbHJlYWR5IHN1Ym1pdHRlZCBhIHBhdGNoIHRvIGZpeCB0aGlzIGFuZCBp
dCBpcyBtb3JlDQptaW5pbWFsOg0KaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8x
MTU4MTc3Lw0KDQpJIHdvdWxkIGxpa2UgdG8gdXNlIHRoYXQgcGF0Y2ggaWYgaXQgaXMgb2sgd2l0
aCB5b3UuLiANCg0KPiAtLS0NCj4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2NtZC5jICAg
ICAgICAgICAgICAgICB8IDQgKystLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21k
LmggICAgICAgICAgICAgICAgIHwgNCArKy0tDQo+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4
NS9tbHg1X2liLmggICAgICAgICAgICAgfCAyICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbGliL2RtLmMgfCA0ICsrLS0NCj4gIGluY2x1ZGUvbGludXgvbWx4
NS9kcml2ZXIuaCAgICAgICAgICAgICAgICAgICAgICB8IDQgKystLQ0KPiAgNSBmaWxlcyBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21kLmMNCj4gYi9kcml2ZXJzL2luZmluaWJhbmQv
aHcvbWx4NS9jbWQuYw0KPiBpbmRleCA0OTM3OTQ3NDAwY2QuLmZiY2FkNzBlZjZkYyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21kLmMNCj4gKysrIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2h3L21seDUvY21kLmMNCj4gQEAgLTgyLDcgKzgyLDcgQEAgaW50IG1seDVf
Y21kX21vZGlmeV9jb25nX3BhcmFtcyhzdHJ1Y3QNCj4gbWx4NV9jb3JlX2RldiAqZGV2LA0KPiAg
CXJldHVybiBtbHg1X2NtZF9leGVjKGRldiwgaW4sIGluX3NpemUsIG91dCwgc2l6ZW9mKG91dCkp
Ow0KPiAgfQ0KPiAgDQo+IC1pbnQgbWx4NV9jbWRfYWxsb2NfbWVtaWMoc3RydWN0IG1seDVfZG0g
KmRtLCBwaHlzX2FkZHJfdCAqYWRkciwNCj4gK2ludCBtbHg1X2NtZF9hbGxvY19tZW1pYyhzdHJ1
Y3QgbWx4NV9kbSAqZG0sIHU2NCAqYWRkciwNCj4gIAkJCSB1NjQgbGVuZ3RoLCB1MzIgYWxpZ25t
ZW50KQ0KPiAgew0KPiAgCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBkbS0+ZGV2Ow0KPiBA
QCAtMTU3LDcgKzE1Nyw3IEBAIGludCBtbHg1X2NtZF9hbGxvY19tZW1pYyhzdHJ1Y3QgbWx4NV9k
bSAqZG0sDQo+IHBoeXNfYWRkcl90ICphZGRyLA0KPiAgCXJldHVybiAtRU5PTUVNOw0KPiAgfQ0K
PiAgDQo+IC1pbnQgbWx4NV9jbWRfZGVhbGxvY19tZW1pYyhzdHJ1Y3QgbWx4NV9kbSAqZG0sIHBo
eXNfYWRkcl90IGFkZHIsIHU2NA0KPiBsZW5ndGgpDQo+ICtpbnQgbWx4NV9jbWRfZGVhbGxvY19t
ZW1pYyhzdHJ1Y3QgbWx4NV9kbSAqZG0sIHU2NCBhZGRyLCB1NjQgbGVuZ3RoKQ0KPiAgew0KPiAg
CXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBkbS0+ZGV2Ow0KPiAgCXU2NCBod19zdGFydF9h
ZGRyID0gTUxYNV9DQVA2NF9ERVZfTUVNKGRldiwNCj4gbWVtaWNfYmFyX3N0YXJ0X2FkZHIpOw0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21kLmgNCj4gYi9kcml2
ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9jbWQuaA0KPiBpbmRleCAxNjljYWI0OTE1ZTMuLjJlYTdh
NDVhNmFiYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21kLmgN
Cj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY21kLmgNCj4gQEAgLTQ0LDkgKzQ0
LDkgQEAgaW50IG1seDVfY21kX3F1ZXJ5X2NvbmdfcGFyYW1zKHN0cnVjdCBtbHg1X2NvcmVfZGV2
DQo+ICpkZXYsIGludCBjb25nX3BvaW50LA0KPiAgaW50IG1seDVfY21kX3F1ZXJ5X2V4dF9wcGNu
dF9jb3VudGVycyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KPiB2b2lkICpvdXQpOw0KPiAg
aW50IG1seDVfY21kX21vZGlmeV9jb25nX3BhcmFtcyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRl
diwNCj4gIAkJCQl2b2lkICppbiwgaW50IGluX3NpemUpOw0KPiAtaW50IG1seDVfY21kX2FsbG9j
X21lbWljKHN0cnVjdCBtbHg1X2RtICpkbSwgcGh5c19hZGRyX3QgKmFkZHIsDQo+ICtpbnQgbWx4
NV9jbWRfYWxsb2NfbWVtaWMoc3RydWN0IG1seDVfZG0gKmRtLCB1NjQgKmFkZHIsDQo+ICAJCQkg
dTY0IGxlbmd0aCwgdTMyIGFsaWdubWVudCk7DQo+IC1pbnQgbWx4NV9jbWRfZGVhbGxvY19tZW1p
YyhzdHJ1Y3QgbWx4NV9kbSAqZG0sIHBoeXNfYWRkcl90IGFkZHIsIHU2NA0KPiBsZW5ndGgpOw0K
PiAraW50IG1seDVfY21kX2RlYWxsb2NfbWVtaWMoc3RydWN0IG1seDVfZG0gKmRtLCB1NjQgYWRk
ciwgdTY0DQo+IGxlbmd0aCk7DQo+ICB2b2lkIG1seDVfY21kX2RlYWxsb2NfcGQoc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldiwgdTMyIHBkbiwgdTE2DQo+IHVpZCk7DQo+ICB2b2lkIG1seDVfY21k
X2Rlc3Ryb3lfdGlyKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUzMiB0aXJuLCB1MTYNCj4g
dWlkKTsNCj4gIHZvaWQgbWx4NV9jbWRfZGVzdHJveV90aXMoc3RydWN0IG1seDVfY29yZV9kZXYg
KmRldiwgdTMyIHRpc24sIHUxNg0KPiB1aWQpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZp
bmliYW5kL2h3L21seDUvbWx4NV9pYi5oDQo+IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUv
bWx4NV9pYi5oDQo+IGluZGV4IDJjZWFlZjNlYTNmYi4uNDc2ZDQ0NDdmOTAxIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmgNCj4gKysrIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5oDQo+IEBAIC01NjEsNyArNTYxLDcgQEAgZW51
bSBtbHg1X2liX210dF9hY2Nlc3NfZmxhZ3Mgew0KPiAgDQo+ICBzdHJ1Y3QgbWx4NV9pYl9kbSB7
DQo+ICAJc3RydWN0IGliX2RtCQlpYmRtOw0KPiAtCXBoeXNfYWRkcl90CQlkZXZfYWRkcjsNCj4g
Kwl1NjQJCQlkZXZfYWRkcjsNCj4gIAl1MzIJCQl0eXBlOw0KPiAgCXNpemVfdAkJCXNpemU7DQo+
ICAJdW5pb24gew0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2xpYi9kbS5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2xpYi9kbS5jDQo+IGluZGV4IGUwNjVjMmY2OGY1YS4uYWQ0ZDc0ODRmYTYzIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2Rt
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9k
bS5jDQo+IEBAIC05MCw3ICs5MCw3IEBAIHZvaWQgbWx4NV9kbV9jbGVhbnVwKHN0cnVjdCBtbHg1
X2NvcmVfZGV2ICpkZXYpDQo+ICB9DQo+ICANCj4gIGludCBtbHg1X2RtX3N3X2ljbV9hbGxvYyhz
dHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBlbnVtDQo+IG1seDVfc3dfaWNtX3R5cGUgdHlwZSwN
Cj4gLQkJCSB1NjQgbGVuZ3RoLCB1MTYgdWlkLCBwaHlzX2FkZHJfdCAqYWRkciwgdTMyDQo+ICpv
YmpfaWQpDQo+ICsJCQkgdTY0IGxlbmd0aCwgdTE2IHVpZCwgdTY0ICphZGRyLCB1MzIgKm9ial9p
ZCkNCj4gIHsNCj4gIAl1MzIgbnVtX2Jsb2NrcyA9IERJVl9ST1VORF9VUF9VTEwobGVuZ3RoLA0K
PiBNTFg1X1NXX0lDTV9CTE9DS19TSVpFKGRldikpOw0KPiAgCXUzMiBvdXRbTUxYNV9TVF9TWl9E
VyhnZW5lcmFsX29ial9vdXRfY21kX2hkcildID0ge307DQo+IEBAIC0xNzUsNyArMTc1LDcgQEAg
aW50IG1seDVfZG1fc3dfaWNtX2FsbG9jKHN0cnVjdCBtbHg1X2NvcmVfZGV2DQo+ICpkZXYsIGVu
dW0gbWx4NV9zd19pY21fdHlwZSB0eXBlLA0KPiAgRVhQT1JUX1NZTUJPTF9HUEwobWx4NV9kbV9z
d19pY21fYWxsb2MpOw0KPiAgDQo+ICBpbnQgbWx4NV9kbV9zd19pY21fZGVhbGxvYyhzdHJ1Y3Qg
bWx4NV9jb3JlX2RldiAqZGV2LCBlbnVtDQo+IG1seDVfc3dfaWNtX3R5cGUgdHlwZSwNCj4gLQkJ
CSAgIHU2NCBsZW5ndGgsIHUxNiB1aWQsIHBoeXNfYWRkcl90IGFkZHIsIHUzMg0KPiBvYmpfaWQp
DQo+ICsJCQkgICB1NjQgbGVuZ3RoLCB1MTYgdWlkLCB1NjQgYWRkciwgdTMyIG9ial9pZCkNCj4g
IHsNCj4gIAl1MzIgbnVtX2Jsb2NrcyA9IERJVl9ST1VORF9VUF9VTEwobGVuZ3RoLA0KPiBNTFg1
X1NXX0lDTV9CTE9DS19TSVpFKGRldikpOw0KPiAgCXUzMiBvdXRbTUxYNV9TVF9TWl9EVyhnZW5l
cmFsX29ial9vdXRfY21kX2hkcildID0ge307DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L21seDUvZHJpdmVyLmgNCj4gYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCj4gaW5kZXgg
M2U4MGYwM2EzODdmLi5lMDdmOWRhZjdkNDIgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgv
bWx4NS9kcml2ZXIuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCj4gQEAg
LTEwODksOSArMTA4OSw5IEBAIGludCBtbHg1X2xhZ19xdWVyeV9jb25nX2NvdW50ZXJzKHN0cnVj
dA0KPiBtbHg1X2NvcmVfZGV2ICpkZXYsDQo+ICBzdHJ1Y3QgbWx4NV91YXJzX3BhZ2UgKm1seDVf
Z2V0X3VhcnNfcGFnZShzdHJ1Y3QgbWx4NV9jb3JlX2Rldg0KPiAqbWRldik7DQo+ICB2b2lkIG1s
eDVfcHV0X3VhcnNfcGFnZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwgc3RydWN0DQo+IG1s
eDVfdWFyc19wYWdlICp1cCk7DQo+ICBpbnQgbWx4NV9kbV9zd19pY21fYWxsb2Moc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldiwgZW51bQ0KPiBtbHg1X3N3X2ljbV90eXBlIHR5cGUsDQo+IC0JCQkg
dTY0IGxlbmd0aCwgdTE2IHVpZCwgcGh5c19hZGRyX3QgKmFkZHIsIHUzMg0KPiAqb2JqX2lkKTsN
Cj4gKwkJCSB1NjQgbGVuZ3RoLCB1MTYgdWlkLCB1NjQgKmFkZHIsIHUzMiAqb2JqX2lkKTsNCj4g
IGludCBtbHg1X2RtX3N3X2ljbV9kZWFsbG9jKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIGVu
dW0NCj4gbWx4NV9zd19pY21fdHlwZSB0eXBlLA0KPiAtCQkJICAgdTY0IGxlbmd0aCwgdTE2IHVp
ZCwgcGh5c19hZGRyX3QgYWRkciwgdTMyDQo+IG9ial9pZCk7DQo+ICsJCQkgICB1NjQgbGVuZ3Ro
LCB1MTYgdWlkLCB1NjQgYWRkciwgdTMyIG9ial9pZCk7DQo+ICANCj4gICNpZmRlZiBDT05GSUdf
TUxYNV9DT1JFX0lQT0lCDQo+ICBzdHJ1Y3QgbmV0X2RldmljZSAqbWx4NV9yZG1hX25ldGRldl9h
bGxvYyhzdHJ1Y3QgbWx4NV9jb3JlX2Rldg0KPiAqbWRldiwNCg==
