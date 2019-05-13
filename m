Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994C01B978
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfEMPFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:05:38 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:7317
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727725AbfEMPFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 11:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtpazz5orILbT1CBu6c4J2+YxLVQEkUm2CU1aFi/ljM=;
 b=OJ03/wZHcFdEZyDB1o45JUloGX1AwZl0LxnuL2cXEFSX+yfyJYl7yW4sDWVRbMgBLM2rR8IQagIWNztkZQccqOT9m+xaCRth5Tza7tNMZAb6I2KQS9caitpid9gFqNw+mGqK2pe6zVYYF3m8dGFLtqs/mRLdP5JSAODOFFP/5s4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6200.eurprd05.prod.outlook.com (20.178.95.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Mon, 13 May 2019 15:05:31 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 15:05:31 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [RFC 2] Validate required parameters in inet6_validate_link_af
Thread-Topic: [RFC 2] Validate required parameters in inet6_validate_link_af
Thread-Index: AQHVCZ1Od/+t/BfWfU6JV9D+RXp2Qg==
Date:   Mon, 13 May 2019 15:05:30 +0000
Message-ID: <20190513150513.26872-3-maximmi@mellanox.com>
References: <20190513150513.26872-1-maximmi@mellanox.com>
In-Reply-To: <20190513150513.26872-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0447.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::27) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6456c072-c0d0-4bf5-6481-08d6d7b470d1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6200;
x-ms-traffictypediagnostic: AM6PR05MB6200:
x-microsoft-antispam-prvs: <AM6PR05MB62003C27F5280828E60243E6D10F0@AM6PR05MB6200.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(199004)(189003)(86362001)(50226002)(478600001)(186003)(6436002)(6486002)(5660300002)(476003)(26005)(81166006)(99286004)(6116002)(14454004)(81156014)(256004)(3846002)(14444005)(53936002)(4326008)(107886003)(25786009)(8676002)(2616005)(71190400001)(71200400001)(8936002)(486006)(7736002)(316002)(73956011)(102836004)(305945005)(2906002)(52116002)(66066001)(110136005)(54906003)(11346002)(386003)(36756003)(6506007)(15650500001)(68736007)(6512007)(76176011)(64756008)(66446008)(1076003)(66556008)(66476007)(446003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6200;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7xa9Z9DXIrFTtcb+wRbo+m58mSqej/6tJX9/YejdpAYNRTP4wx5F1AwBoFB6R8vg/IdrQhjuuIYMNn7PJurjaAFKSJI/YVN37um47V+UQdjzMkS11z0j2iY5CLhtsztwrw6Eq7P3qKm1qYMvY5Sh9SNg70tZNvw6T/cvV/tNGeVN8TCMB6rkWA5KXdzLz6oyRrPP9XRoxwcXJP3OizrNgz/IgdgX8w/ALWBXYzbFamzfcp8lG7OzLsVg1fkZqnj0Ke8ZMx0sciNbxibRQP/m/SFPnNQbGJ+qUnjVKq8C0ID9qAbdoo1y2w6ql4tznXd/egiZIp1IhHVhlxNCt6iu2rBFs6GVTE7DvUxkW/6ANRzMgC+cXpI4wQbBSx6EaLzvJlue4L3UDyaiqMObKAaWb1NfoRNWaoFyFwaLzKrKBi4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6456c072-c0d0-4bf5-6481-08d6d7b470d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 15:05:30.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

aW5ldDZfc2V0X2xpbmtfYWYgcmVxdWlyZXMgdGhhdCBhdCBsZWFzdCBvbmUgb2YgSUZMQV9JTkVU
Nl9UT0tFTiBvcg0KSUZMQV9JTkVUNl9BRERSX0dFVF9NT0RFIGlzIHBhc3NlZC4gSWYgbm9uZSBv
ZiB0aGVtIGlzIHBhc3NlZCwgaXQNCnJldHVybnMgLUVJTlZBTCwgd2hpY2ggbWF5IGNhdXNlIGRv
X3NldGxpbmsoKSB0byBmYWlsIGluIHRoZSBtaWRkbGUgb2YNCnByb2Nlc3Npbmcgb3RoZXIgY29t
bWFuZHMgYW5kIGdpdmUgdGhlIGZvbGxvd2luZyB3YXJuaW5nIG1lc3NhZ2U6DQoNCiAgQSBsaW5r
IGNoYW5nZSByZXF1ZXN0IGZhaWxlZCB3aXRoIHNvbWUgY2hhbmdlcyBjb21taXR0ZWQgYWxyZWFk
eS4NCiAgSW50ZXJmYWNlIGV0aDAgbWF5IGhhdmUgYmVlbiBsZWZ0IHdpdGggYW4gaW5jb25zaXN0
ZW50IGNvbmZpZ3VyYXRpb24sDQogIHBsZWFzZSBjaGVjay4NCg0KQ2hlY2sgdGhlIHByZXNlbmNl
IG9mIGF0IGxlYXN0IG9uZSBvZiB0aGVtIGluIGluZXQ2X3ZhbGlkYXRlX2xpbmtfYWYgdG8NCmRl
dGVjdCBpbnZhbGlkIHBhcmFtZXRlcnMgYXQgYW4gZWFybHkgc3RhZ2UsIGJlZm9yZSBkb19zZXRs
aW5rIGRvZXMNCmFueXRoaW5nLiBBbHNvIHZhbGlkYXRlIHRoZSBhZGRyZXNzIGdlbmVyYXRpb24g
bW9kZSBhdCBhbiBlYXJseSBzdGFnZS4NCg0KU2lnbmVkLW9mZi1ieTogTWF4aW0gTWlraXR5YW5z
a2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCi0tLQ0KIG5ldC9pcHY2L2FkZHJjb25mLmMgfCA2
MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUg
Y2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9uZXQvaXB2Ni9hZGRyY29uZi5jIGIvbmV0L2lwdjYvYWRkcmNvbmYuYw0KaW5kZXggZjk2ZDFk
ZTc5NTA5Li45MDRiZDZmNTQ3MmYgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9hZGRyY29uZi5jDQor
KysgYi9uZXQvaXB2Ni9hZGRyY29uZi5jDQpAQCAtNTY2MSwxOCArNTY2MSw2IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbmxhX3BvbGljeSBpbmV0Nl9hZl9wb2xpY3lbSUZMQV9JTkVUNl9NQVggKyAx
XSA9IHsNCiAJW0lGTEFfSU5FVDZfVE9LRU5dCQk9IHsgLmxlbiA9IHNpemVvZihzdHJ1Y3QgaW42
X2FkZHIpIH0sDQogfTsNCiANCi1zdGF0aWMgaW50IGluZXQ2X3ZhbGlkYXRlX2xpbmtfYWYoY29u
c3Qgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCi0JCQkJICBjb25zdCBzdHJ1Y3QgbmxhdHRyICpu
bGEpDQotew0KLQlzdHJ1Y3QgbmxhdHRyICp0YltJRkxBX0lORVQ2X01BWCArIDFdOw0KLQ0KLQlp
ZiAoZGV2ICYmICFfX2luNl9kZXZfZ2V0KGRldikpDQotCQlyZXR1cm4gLUVBRk5PU1VQUE9SVDsN
Ci0NCi0JcmV0dXJuIG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRlZCh0YiwgSUZMQV9JTkVUNl9N
QVgsIG5sYSwNCi0JCQkJCSAgIGluZXQ2X2FmX3BvbGljeSwgTlVMTCk7DQotfQ0KLQ0KIHN0YXRp
YyBpbnQgY2hlY2tfYWRkcl9nZW5fbW9kZShpbnQgbW9kZSkNCiB7DQogCWlmIChtb2RlICE9IElO
Nl9BRERSX0dFTl9NT0RFX0VVSTY0ICYmDQpAQCAtNTY5MywxNCArNTY4MSw0OCBAQCBzdGF0aWMg
aW50IGNoZWNrX3N0YWJsZV9wcml2YWN5KHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYsIHN0cnVjdCBu
ZXQgKm5ldCwNCiAJcmV0dXJuIDE7DQogfQ0KIA0KK3N0YXRpYyBpbnQgaW5ldDZfdmFsaWRhdGVf
bGlua19hZihjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KKwkJCQkgIGNvbnN0IHN0cnVj
dCBubGF0dHIgKm5sYSkNCit7DQorCXN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYgPSBOVUxMOw0KKwlz
dHJ1Y3QgbmxhdHRyICp0YltJRkxBX0lORVQ2X01BWCArIDFdOw0KKwlpbnQgZXJyOw0KKw0KKwlp
ZiAoZGV2KSB7DQorCQlpZGV2ID0gX19pbjZfZGV2X2dldChkZXYpOw0KKwkJaWYgKCFpZGV2KQ0K
KwkJCXJldHVybiAtRUFGTk9TVVBQT1JUOw0KKwl9DQorDQorCWVyciA9IG5sYV9wYXJzZV9uZXN0
ZWRfZGVwcmVjYXRlZCh0YiwgSUZMQV9JTkVUNl9NQVgsIG5sYSwNCisJCQkJCSAgaW5ldDZfYWZf
cG9saWN5LCBOVUxMKTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorDQorCWVyciA9IC1F
SU5WQUw7DQorDQorCWlmICh0YltJRkxBX0lORVQ2X0FERFJfR0VOX01PREVdKSB7DQorCQl1OCBt
b2RlID0gbmxhX2dldF91OCh0YltJRkxBX0lORVQ2X0FERFJfR0VOX01PREVdKTsNCisNCisJCWlm
IChjaGVja19hZGRyX2dlbl9tb2RlKG1vZGUpIDwgMCkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisJ
CWlmIChkZXYgJiYgY2hlY2tfc3RhYmxlX3ByaXZhY3koaWRldiwgZGV2X25ldChkZXYpLCBtb2Rl
KSA8IDApDQorCQkJcmV0dXJuIC1FSU5WQUw7DQorDQorCQllcnIgPSAwOw0KKwl9DQorDQorCWlm
ICh0YltJRkxBX0lORVQ2X1RPS0VOXSkNCisJCWVyciA9IDA7DQorDQorCXJldHVybiBlcnI7DQor
fQ0KKw0KIHN0YXRpYyBpbnQgaW5ldDZfc2V0X2xpbmtfYWYoc3RydWN0IG5ldF9kZXZpY2UgKmRl
diwgY29uc3Qgc3RydWN0IG5sYXR0ciAqbmxhKQ0KIHsNCi0JaW50IGVyciA9IC1FSU5WQUw7DQog
CXN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYgPSBfX2luNl9kZXZfZ2V0KGRldik7DQogCXN0cnVjdCBu
bGF0dHIgKnRiW0lGTEFfSU5FVDZfTUFYICsgMV07DQotDQotCWlmICghaWRldikNCi0JCXJldHVy
biAtRUFGTk9TVVBQT1JUOw0KKwlpbnQgZXJyOw0KIA0KIAlpZiAobmxhX3BhcnNlX25lc3RlZF9k
ZXByZWNhdGVkKHRiLCBJRkxBX0lORVQ2X01BWCwgbmxhLCBOVUxMLCBOVUxMKSA8IDApDQogCQlC
VUcoKTsNCkBAIC01NzE0LDE1ICs1NzM2LDEwIEBAIHN0YXRpYyBpbnQgaW5ldDZfc2V0X2xpbmtf
YWYoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgY29uc3Qgc3RydWN0IG5sYXR0ciAqbmxhKQ0KIAlp
ZiAodGJbSUZMQV9JTkVUNl9BRERSX0dFTl9NT0RFXSkgew0KIAkJdTggbW9kZSA9IG5sYV9nZXRf
dTgodGJbSUZMQV9JTkVUNl9BRERSX0dFTl9NT0RFXSk7DQogDQotCQlpZiAoY2hlY2tfYWRkcl9n
ZW5fbW9kZShtb2RlKSA8IDAgfHwNCi0JCSAgICBjaGVja19zdGFibGVfcHJpdmFjeShpZGV2LCBk
ZXZfbmV0KGRldiksIG1vZGUpIDwgMCkNCi0JCQlyZXR1cm4gLUVJTlZBTDsNCi0NCiAJCWlkZXYt
PmNuZi5hZGRyX2dlbl9tb2RlID0gbW9kZTsNCi0JCWVyciA9IDA7DQogCX0NCiANCi0JcmV0dXJu
IGVycjsNCisJcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRpYyBpbnQgaW5ldDZfZmlsbF9pZmluZm8o
c3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGluZXQ2X2RldiAqaWRldiwNCi0tIA0KMi4xOS4x
DQoNCg==
