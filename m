Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766B97425E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbfGXXwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:52:42 -0400
Received: from mail-eopbgr40046.outbound.protection.outlook.com ([40.107.4.46]:36771
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726431AbfGXXwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 19:52:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i52sCDfdpF5tAGQjuO1Q2VqQf+vWNq3OB3fINIncmsqTHdMTrxN6n1yvdFN88mgEG7wTBlZQi7t63/jFvDLDEFEmCO4c6JKEa0LUUhW6zgQbB5m+Yk/8FJihdjpZgjGPbZe6sVES09k4HI9ZusBTD76U3R8pUnDbiIuAvYqRFpGmYSkzGA1jyGrz/JTtUMRLGDGi3+eXsaltlcWGUIIYxwKK5PpmGIjhu7RnfOJxPgj8d/EtHKKraoh+oF2gRLXpIzN2lXHBSUjtkW3Pq0NmEQF4YE3V5AcxZu/baDdg4SqmL7emIHwmG5ywzB02zR4NB0xMvEBD1CasmX9XvwsFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRheVUz3Ej54t4rUQp18tc8wSIs0JjTnGB9UhTUQo5I=;
 b=XyKBi+qiNvqxrDCabBr8fLmR7zp8MVT1blMN2sgK85SHI/l9jCh/pOJG+iy+l3jP1tNUqAtNAR91/iY3xj1eH7+LWaXKBtYCL0EkT+oAey71dzhzjL2oHu53Ldz7IuYNY1hrPik4G1h3DhnyAe3U+DMbZX68jFdxeiicYg4l9fkdW0hwx9sUQu+dbAdvritkKb8zfLOl2saAvsuFjtY9qSxxcoyr+zZOoUwpu18n4auAHEL+w3YDwLVZq146fZV4UKq6YNPTrwc1rM5w1UUQypZIkPYzClh3ETiJPBgulnv220pOa0278gik+ObP67hXleaa/pHtfJ83DWG1pSD76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRheVUz3Ej54t4rUQp18tc8wSIs0JjTnGB9UhTUQo5I=;
 b=sPTQBa6+eWTVJZ29pLxcNs5TlgY/R8a59I6zomntjVwS9DA/8OTzgtOuI6FjALLTHNoioP+8yV6F+vQ0gMOEtO7FBABKsfoIgRzasZcOP9iG/tJkxIDTWVxE8PLWNJCeotcewTGwlgRnAQMlZ2Yv6MuBas3fitfbQgwPFJYQlpM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2662.eurprd05.prod.outlook.com (10.172.230.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Wed, 24 Jul 2019 23:52:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 23:52:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "snelson@pensando.io" <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 10/19] ionic: Add management of rx filters
Thread-Topic: [PATCH v4 net-next 10/19] ionic: Add management of rx filters
Thread-Index: AQHVQNY3gRbc1AvSvEuoJvtZxyGdzabadA6A
Date:   Wed, 24 Jul 2019 23:52:37 +0000
Message-ID: <e8b4002b415a2174280472b98640dda45d32d11b.camel@mellanox.com>
References: <20190722214023.9513-1-snelson@pensando.io>
         <20190722214023.9513-11-snelson@pensando.io>
In-Reply-To: <20190722214023.9513-11-snelson@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457b097b-1918-4ac5-4bb3-08d7109201c4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2662;
x-ms-traffictypediagnostic: DB6PR0501MB2662:
x-microsoft-antispam-prvs: <DB6PR0501MB2662E07552A4109B941E6811BEC60@DB6PR0501MB2662.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(199004)(189003)(11346002)(6512007)(14454004)(5660300002)(71200400001)(8676002)(7736002)(478600001)(25786009)(71190400001)(305945005)(99286004)(3846002)(6116002)(118296001)(486006)(2501003)(2906002)(14444005)(446003)(2201001)(186003)(6506007)(36756003)(476003)(2616005)(76176011)(81156014)(26005)(110136005)(58126008)(6486002)(102836004)(86362001)(229853002)(316002)(81166006)(66066001)(8936002)(6436002)(66946007)(256004)(64756008)(66556008)(6246003)(66476007)(66446008)(76116006)(53936002)(68736007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2662;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3o7wxwE7F1Vbrka2l7SHfR+LZfTD88TyDBHt7+l1wqEK5C2uQcWN2lq1gjy4qzVhoeCGEBfZO6Y/has5LEur2AiZb+2/S49KDmrywdy5Sxwk8+RL/bdyZYuLKo04/VSexV73mx4R5wR6vsjhja6KxMyCRqPo0S3YStoRHFSOc13lk2AnTG4GEmk24ChHUSIcDpwfSdvUpbFhqdeKi9kDhmXU8fU1pE/VBBZI4a1/boyUCdwdct9aVBi3JDsK4ID2n0rNLdZbQOHQlcTdbpDDVj6I5zgJ0AV2Jre4aDNRT5/WdhEHufwPY57/a/2Rq6HpiJ9Lq1E2BlsmBGhEzhj7IByQhFr3pbUqek8iajxeEhKTmfjnxk6iw+mEUAKxqH43ShvMi2NLwN6mmsY7b9oucdFzaJaGIvNGELb1P03vIEg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4D62BBDB26D20469631444780DAF85A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457b097b-1918-4ac5-4bb3-08d7109201c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 23:52:37.6026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTIyIGF0IDE0OjQwIC0wNzAwLCBTaGFubm9uIE5lbHNvbiB3cm90ZToN
Cj4gU2V0IHVwIHRoZSBpbmZyYXN0cnVjdHVyZSBmb3IgbWFuYWdpbmcgUnggZmlsdGVycy4gIFdl
IGNhbid0IGFzayB0aGUNCj4gaGFyZHdhcmUgZm9yIHdoYXQgZmlsdGVycyBpdCBoYXMsIHNvIHdl
IGtlZXAgYSBsb2NhbCBsaXN0IG9mIGZpbHRlcnMNCj4gdGhhdCB3ZSd2ZSBwdXNoZWQgaW50byB0
aGUgSFcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTaGFubm9uIE5lbHNvbiA8c25lbHNvbkBwZW5z
YW5kby5pbz4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9wZW5zYW5kby9pb25pYy9N
YWtlZmlsZSAgfCAgIDQgKy0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvcGVuc2FuZG8vaW9uaWMvaW9u
aWNfbGlmLmMgICB8ICAgNiArDQo+ICAuLi4vbmV0L2V0aGVybmV0L3BlbnNhbmRvL2lvbmljL2lv
bmljX2xpZi5oICAgfCAgIDIgKw0KPiAgLi4uL2V0aGVybmV0L3BlbnNhbmRvL2lvbmljL2lvbmlj
X3J4X2ZpbHRlci5jIHwgMTQzDQo+ICsrKysrKysrKysrKysrKysrKw0KPiAgLi4uL2V0aGVybmV0
L3BlbnNhbmRvL2lvbmljL2lvbmljX3J4X2ZpbHRlci5oIHwgIDM1ICsrKysrDQo+ICA1IGZpbGVz
IGNoYW5nZWQsIDE4OCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3BlbnNhbmRvL2lvbmljL2lvbmljX3J4
X2ZpbHRlci5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
cGVuc2FuZG8vaW9uaWMvaW9uaWNfcnhfZmlsdGVyLmgNCj4gDQo+IA0KDQpbLi4uXQ0KDQo+ICsj
ZGVmaW5lIFJYUV9JTkRFWF9BTlkJCSgweEZGRkYpDQo+ICtzdHJ1Y3QgcnhfZmlsdGVyIHsNCj4g
Kwl1MzIgZmxvd19pZDsNCj4gKwl1MzIgZmlsdGVyX2lkOw0KPiArCXUxNiByeHFfaW5kZXg7DQo+
ICsJc3RydWN0IHJ4X2ZpbHRlcl9hZGRfY21kIGNtZDsNCj4gKwlzdHJ1Y3QgaGxpc3Rfbm9kZSBi
eV9oYXNoOw0KPiArCXN0cnVjdCBobGlzdF9ub2RlIGJ5X2lkOw0KPiArfTsNCj4gKw0KPiArI2Rl
ZmluZSBSWF9GSUxURVJfSEFTSF9CSVRTCTEwDQo+ICsjZGVmaW5lIFJYX0ZJTFRFUl9ITElTVFMJ
QklUKFJYX0ZJTFRFUl9IQVNIX0JJVFMpDQo+ICsjZGVmaW5lIFJYX0ZJTFRFUl9ITElTVFNfTUFT
SwkoUlhfRklMVEVSX0hMSVNUUyAtIDEpDQo+ICtzdHJ1Y3QgcnhfZmlsdGVycyB7DQo+ICsJc3Bp
bmxvY2tfdCBsb2NrOwkJCQkvKiBmaWx0ZXIgbGlzdCBsb2NrDQo+ICovDQo+ICsJc3RydWN0IGhs
aXN0X2hlYWQgYnlfaGFzaFtSWF9GSUxURVJfSExJU1RTXTsJLyogYnkgc2tiDQo+IGhhc2ggKi8N
Cj4gKwlzdHJ1Y3QgaGxpc3RfaGVhZCBieV9pZFtSWF9GSUxURVJfSExJU1RTXTsJLyogYnkNCj4g
ZmlsdGVyX2lkICovDQo+ICt9Ow0KPiArDQo+IA0KDQpGb2xsb3dpbmcgRGF2ZSdzIGNvbW1lbnQg
b24gdGhpcywgeW91IHVzZSB0b28gZ2VuZXJpYyBzdHJ1Y3QgYW5kIG1hY3JvDQovZGVmaW5lIG5h
bWVzLCBpIHN0cm9uZ2x5IHJlY29tbWVuZCB0byBhZGQgYSB1bmlxdWUgcHJlZml4IHRvIHRoaXMN
CmRyaXZlci4NCg==
