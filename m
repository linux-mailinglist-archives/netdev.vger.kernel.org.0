Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144D189956
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfHLJFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:05:43 -0400
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:53509
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727181AbfHLJFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 05:05:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFmpaiDRtPGjKutyllLUgxvMBslQavPLQczVUqBSS1hVq+CmfZSVDrHms6IeJ2/9g2RsGsl0Nt8UGm6I1zg2hVHOysRQPvNB+D9LQDvwEl58q9XaLf31+1c+dnMGaq3QWROyuqB03yQ5Jp8R2p4ybCzI9o8vzjXMlInevU9zVMxMGHc9UO4YYX4tnGzs2vFgUG8aILamfeSm8XDGOkWbo6G14xHHqGJTihKmuPJg2DlrdVXwgRWWBQ7J5mU+n+7cxGQ2wHXf8QJbCYDK7ZOLqfnDed1qfn+JHdmWp0ZboezAukrGWgHY5MTRSNfR7QG0dBi/SeXYzQzuzDNicf6WVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaKv4UiFyOgemcQmmsOdXQLdo1Si4yTTeYfHSZf9XgQ=;
 b=E9WhdYqZ2Y7DA8FJHttHEercVAQaLV+FfQGgbOvtkf+1xGhCC80LXgPMA4gIBe52usA/qH3kfZVnEvr20so7zW33szVULNz9GJ3LlHQs8TQToGZCLVE/0nsIoEujsJKpLCZsJwWn30cczExtNino9iQZxqFNzkO+9Vt5Omi6WcSHQ9HU5aXVRwIVZ04V0vIoTa9EEejdqLxihZYA/FyUcSNnEUZ7tYzl3cmGXRKBeugd06pNnC+nsK9QfTlnUpULrm/u3vF8HJOfMNCkY551uUV1eyPLiajczqQPAdCwV2GPmeKvuvOHZjxNBkJYVcj548l2OpLXZ1o15ivShuLW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaKv4UiFyOgemcQmmsOdXQLdo1Si4yTTeYfHSZf9XgQ=;
 b=aPztfcN3uuIdyemXy4Vm7g5DXbh2aWQoEHAHW/20IRigfhCQdv34zXn9yQCpLBOa+QDpo7xhoMsX+1UZH5seqRLYGD6UyO2PzmrKqMO+Kyg8wsZcKKuoLtFsLA6kiiJl+5n5GgptaioUB1jT1z90TxrddjvUnIDA1qcaPB45OqI=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6554.eurprd05.prod.outlook.com (20.179.44.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Mon, 12 Aug 2019 09:04:59 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::c5c1:c1d:85e9:a16a]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::c5c1:c1d:85e9:a16a%6]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 09:04:59 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:MELLANOX ETHERNET DRIVER (mlx4_en)" 
        <netdev@vger.kernel.org>,
        "open list:MELLANOX MLX4 core VPI driver" 
        <linux-rdma@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx4_en: fix a memory leak bug
Thread-Topic: [PATCH] net/mlx4_en: fix a memory leak bug
Thread-Index: AQHVUNg+K+c1E2gjG02bEtXNUDsXd6b3OFQA
Date:   Mon, 12 Aug 2019 09:04:59 +0000
Message-ID: <75e09920-4ae3-0a19-4c2a-112d16bb81a5@mellanox.com>
References: <1565591765-6461-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565591765-6461-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a5ed917-807d-4454-05cc-08d71f0426e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6554;
x-ms-traffictypediagnostic: DBBPR05MB6554:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6554E94DDFDEB9B8981A0F44AED30@DBBPR05MB6554.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(199004)(189003)(25786009)(2171002)(54906003)(11346002)(446003)(2906002)(476003)(2616005)(52116002)(8676002)(76176011)(53936002)(3846002)(36756003)(6246003)(31686004)(6116002)(186003)(102836004)(6512007)(81156014)(99286004)(4326008)(86362001)(53546011)(386003)(31696002)(6506007)(256004)(14444005)(81166006)(26005)(66476007)(66446008)(64756008)(66556008)(66946007)(5660300002)(6486002)(66066001)(14454004)(6916009)(8936002)(229853002)(71190400001)(71200400001)(7736002)(6436002)(305945005)(316002)(486006)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6554;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1vvfTivX0uTIGkC7IFmnkz2JsJFtan30TcsWANDqBn8uf4ccdX0uRIgvaLwF9BmGcRwfD/P2qrkpJWqdFK8B3C6Gmim/bqS/HkmVHSZnMwXotvriusBnBV8oiP9lSETGXw6g1AI16r+YpxkA/Mp3AL6FxqBOqJISPiYLQW018bbhVcnvUp4yGiBoNvCL6FFQbFuWzuyQCvDEnXYoUwCkmPZZMd+Sa/qan441J5qdzQjzDIKaDCS+7kdrtr4ph10KXIP4/MkEZ/YQenW4rC0YW/nbt0VVFVqLowXBc7jDx/+AfE50370Hn+Pon4NMAu5QqQaXBYHjj6HqmkxrDVXnfz+TEQ50ktzYQhk8jIr2/l13lniYxDROO6VLGhJiT9hnSATojfkoOdqDxFKoQOjymwOTBSgMdG8ug/+wxQvrAYM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A6B1C4F980D244AB1DD60C0F10AF81E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5ed917-807d-4454-05cc-08d71f0426e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 09:04:59.2144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBNUJPbCJSr1TBbko808d2mW2ELgjCQgyLDSnnOfq/0jrL6OuUk48PWTntDR87RECw8jPDnFqZo5c8D1onZ+EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6554
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2Vud2VuLA0KDQpUaGFua3MgZm9yIHlvdXIgcGF0Y2guDQoNCk9uIDgvMTIvMjAxOSA5OjM2
IEFNLCBXZW53ZW4gV2FuZyB3cm90ZToNCj4gSW4gbWx4NF9lbl9jb25maWdfcnNzX3N0ZWVyKCks
ICdyc3NfbWFwLT5pbmRpcl9xcCcgaXMgYWxsb2NhdGVkIHRocm91Z2gNCj4ga3phbGxvYygpLiBB
ZnRlciB0aGF0LCBtbHg0X3FwX2FsbG9jKCkgaXMgaW52b2tlZCB0byBjb25maWd1cmUgUlNTDQo+
IGluZGlyZWN0aW9uLiBIb3dldmVyLCBpZiBtbHg0X3FwX2FsbG9jKCkgZmFpbHMsIHRoZSBhbGxv
Y2F0ZWQNCj4gJ3Jzc19tYXAtPmluZGlyX3FwJyBpcyBub3QgZGVhbGxvY2F0ZWQsIGxlYWRpbmcg
dG8gYSBtZW1vcnkgbGVhayBidWcuDQo+IA0KPiBUbyBmaXggdGhlIGFib3ZlIGlzc3VlLCBhZGQg
dGhlICdtbHg0X2VycicgbGFiZWwgdG8gZnJlZQ0KPiAncnNzX21hcC0+aW5kaXJfcXAnLg0KPiAN
Cg0KQWRkIGEgRml4ZXMgbGluZS4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBXZW53ZW4gV2FuZyA8d2Vu
d2VuQGNzLnVnYS5lZHU+ID4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NC9lbl9yeC5jIHwgMyArKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NC9lbl9yeC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NC9lbl9yeC5jDQo+IGluZGV4IDZjMDEzMTQuLjk0NzZkYmQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYw0KPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3J4LmMNCj4gQEAgLTExODcsNyArMTE4Nyw3IEBA
IGludCBtbHg0X2VuX2NvbmZpZ19yc3Nfc3RlZXIoc3RydWN0IG1seDRfZW5fcHJpdiAqcHJpdikN
Cj4gICAJZXJyID0gbWx4NF9xcF9hbGxvYyhtZGV2LT5kZXYsIHByaXYtPmJhc2VfcXBuLCByc3Nf
bWFwLT5pbmRpcl9xcCk7DQo+ICAgCWlmIChlcnIpIHsNCj4gICAJCWVuX2Vycihwcml2LCAiRmFp
bGVkIHRvIGFsbG9jYXRlIFJTUyBpbmRpcmVjdGlvbiBRUFxuIik7DQo+IC0JCWdvdG8gcnNzX2Vy
cjsNCj4gKwkJZ290byBtbHg0X2VycjsNCj4gICAJfQ0KPiAgIA0KPiAgIAlyc3NfbWFwLT5pbmRp
cl9xcC0+ZXZlbnQgPSBtbHg0X2VuX3NxcF9ldmVudDsNCj4gQEAgLTEyNDEsNiArMTI0MSw3IEBA
IGludCBtbHg0X2VuX2NvbmZpZ19yc3Nfc3RlZXIoc3RydWN0IG1seDRfZW5fcHJpdiAqcHJpdikN
Cj4gICAJCSAgICAgICBNTFg0X1FQX1NUQVRFX1JTVCwgTlVMTCwgMCwgMCwgcnNzX21hcC0+aW5k
aXJfcXApOw0KPiAgIAltbHg0X3FwX3JlbW92ZShtZGV2LT5kZXYsIHJzc19tYXAtPmluZGlyX3Fw
KTsNCj4gICAJbWx4NF9xcF9mcmVlKG1kZXYtPmRldiwgcnNzX21hcC0+aW5kaXJfcXApOw0KPiAr
bWx4NF9lcnI6DQoNCkkgZG9uJ3QgbGlrZSB0aGUgbGFiZWwgbmFtZS4gSXQncyB0b28gZ2VuZXJh
bCBhbmQgbm90IGluZm9ybWF0aXZlLg0KTWF5YmUgcXBfYWxsb2NfZXJyPw0KDQo+ICAgCWtmcmVl
KHJzc19tYXAtPmluZGlyX3FwKTsNCj4gICAJcnNzX21hcC0+aW5kaXJfcXAgPSBOVUxMOw0KPiAg
IHJzc19lcnI6DQo+IA0K
