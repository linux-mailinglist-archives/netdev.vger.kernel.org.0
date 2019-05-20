Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0C22DF1
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfETIIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:08:12 -0400
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:16101
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728105AbfETIIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 04:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLM5ywsIwuDp9+rlaI2Y/hQkhAcMy0z90keHajofKxo=;
 b=efhR2G/xJpvwvl9YvFURwTiZiQ/78LS2GmZtHHKRISUZYdQqwWhE6Ioz9FJCe9O4HJrWHpqkFC4Wej5lBBTFIHxkPCk6J3NwCwSR1uvTxgStkmQJP9+QuOSkqGqMWWdW+swZnmFjMzEgmF+siQCJUvCb5UP8DV9EeuNTs9GRgD4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6549.eurprd05.prod.outlook.com (20.179.18.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 08:08:07 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 08:08:07 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net] Validate required parameters in inet6_validate_link_af
Thread-Topic: [PATCH net] Validate required parameters in
 inet6_validate_link_af
Thread-Index: AQHVDuMo9eD6jfwmo02sGoxxFXlriA==
Date:   Mon, 20 May 2019 08:08:07 +0000
Message-ID: <20190520080755.2542-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0417.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::21) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3eae0e5-1439-489c-e696-08d6dcfa4a6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6549;
x-ms-traffictypediagnostic: AM6PR05MB6549:
x-microsoft-antispam-prvs: <AM6PR05MB6549ADFB05AC1CA587BB9843D1060@AM6PR05MB6549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(396003)(366004)(346002)(199004)(189003)(53936002)(14454004)(6506007)(486006)(386003)(6512007)(71190400001)(71200400001)(81166006)(8676002)(81156014)(110136005)(478600001)(476003)(8936002)(2616005)(50226002)(99286004)(25786009)(54906003)(6486002)(6436002)(6116002)(3846002)(66066001)(102836004)(15650500001)(107886003)(68736007)(4326008)(52116002)(305945005)(36756003)(86362001)(66556008)(66946007)(66476007)(64756008)(66446008)(256004)(186003)(14444005)(316002)(7736002)(26005)(1076003)(5660300002)(2906002)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6549;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d1y/f37lOczzIlgAYXHLq61tHoqCJZ9lhi1K6UM88tgCrWquXa/eaF4do+vMGWVfbwswiM9OrS4ZoQgb8yKzSSYoDjPg7MLrMeOPHLEqAUcAsE4dSQQmCtuZVpbKJg3PLDjk7QO4d0gLkQUStHXImnp3IG2rvlMNEVEbLYqMWU+aLfDkKEf3a6vvmvd8TnhQQyolfwQxDomS9lxYQ3JcZYQ1ckW9taStOfUr6cGHT89z3fL0jDYZJts3Ou6r353l4v6Gn3ZJ+i8pZHd3hjHPgfTiy2EoEYrmp5hXxe2rFU5gZeLI2cZpjM2243IewsakKxPpF4opjkhfkUCUCQbyngSGmeljjX7dIAcJPPIfTxIiL+KCkW2pD9HRdRf2uwkrgz48kr4k74daihQG1ZAdvqqhD3vcP6T/zOzbnTacLvs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3eae0e5-1439-489c-e696-08d6dcfa4a6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 08:08:07.2078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6549
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
a2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCi0tLQ0KIG5ldC9pcHY2L2FkZHJjb25mLmMgfCA1
NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUg
Y2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pDQoNCkNoYW5nZXM6IE1h
ZGUgdGhlIHZhbGlkYXRpb24gY29kZSBtb3JlIHJlYWRhYmxlIGFmdGVyIEpha3ViJ3MgcmVxdWVz
dC4NCg0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L2FkZHJjb25mLmMgYi9uZXQvaXB2Ni9hZGRyY29u
Zi5jDQppbmRleCBmOTZkMWRlNzk1MDkuLjQ1YmU0NGU5ZTUyZSAxMDA2NDQNCi0tLSBhL25ldC9p
cHY2L2FkZHJjb25mLmMNCisrKyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCkBAIC01NjYxLDE4ICs1
NjYxLDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBubGFfcG9saWN5IGluZXQ2X2FmX3BvbGljeVtJ
RkxBX0lORVQ2X01BWCArIDFdID0gew0KIAlbSUZMQV9JTkVUNl9UT0tFTl0JCT0geyAubGVuID0g
c2l6ZW9mKHN0cnVjdCBpbjZfYWRkcikgfSwNCiB9Ow0KIA0KLXN0YXRpYyBpbnQgaW5ldDZfdmFs
aWRhdGVfbGlua19hZihjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KLQkJCQkgIGNvbnN0
IHN0cnVjdCBubGF0dHIgKm5sYSkNCi17DQotCXN0cnVjdCBubGF0dHIgKnRiW0lGTEFfSU5FVDZf
TUFYICsgMV07DQotDQotCWlmIChkZXYgJiYgIV9faW42X2Rldl9nZXQoZGV2KSkNCi0JCXJldHVy
biAtRUFGTk9TVVBQT1JUOw0KLQ0KLQlyZXR1cm4gbmxhX3BhcnNlX25lc3RlZF9kZXByZWNhdGVk
KHRiLCBJRkxBX0lORVQ2X01BWCwgbmxhLA0KLQkJCQkJICAgaW5ldDZfYWZfcG9saWN5LCBOVUxM
KTsNCi19DQotDQogc3RhdGljIGludCBjaGVja19hZGRyX2dlbl9tb2RlKGludCBtb2RlKQ0KIHsN
CiAJaWYgKG1vZGUgIT0gSU42X0FERFJfR0VOX01PREVfRVVJNjQgJiYNCkBAIC01NjkzLDE0ICs1
NjgxLDQ0IEBAIHN0YXRpYyBpbnQgY2hlY2tfc3RhYmxlX3ByaXZhY3koc3RydWN0IGluZXQ2X2Rl
diAqaWRldiwgc3RydWN0IG5ldCAqbmV0LA0KIAlyZXR1cm4gMTsNCiB9DQogDQorc3RhdGljIGlu
dCBpbmV0Nl92YWxpZGF0ZV9saW5rX2FmKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQor
CQkJCSAgY29uc3Qgc3RydWN0IG5sYXR0ciAqbmxhKQ0KK3sNCisJc3RydWN0IGluZXQ2X2RldiAq
aWRldiA9IE5VTEw7DQorCXN0cnVjdCBubGF0dHIgKnRiW0lGTEFfSU5FVDZfTUFYICsgMV07DQor
CWludCBlcnI7DQorDQorCWlmIChkZXYpIHsNCisJCWlkZXYgPSBfX2luNl9kZXZfZ2V0KGRldik7
DQorCQlpZiAoIWlkZXYpDQorCQkJcmV0dXJuIC1FQUZOT1NVUFBPUlQ7DQorCX0NCisNCisJZXJy
ID0gbmxhX3BhcnNlX25lc3RlZF9kZXByZWNhdGVkKHRiLCBJRkxBX0lORVQ2X01BWCwgbmxhLA0K
KwkJCQkJICBpbmV0Nl9hZl9wb2xpY3ksIE5VTEwpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVy
cjsNCisNCisJaWYgKCF0YltJRkxBX0lORVQ2X1RPS0VOXSAmJiAhdGJbSUZMQV9JTkVUNl9BRERS
X0dFTl9NT0RFXSkNCisJCXJldHVybiAtRUlOVkFMOw0KKw0KKwlpZiAodGJbSUZMQV9JTkVUNl9B
RERSX0dFTl9NT0RFXSkgew0KKwkJdTggbW9kZSA9IG5sYV9nZXRfdTgodGJbSUZMQV9JTkVUNl9B
RERSX0dFTl9NT0RFXSk7DQorDQorCQlpZiAoY2hlY2tfYWRkcl9nZW5fbW9kZShtb2RlKSA8IDAp
DQorCQkJcmV0dXJuIC1FSU5WQUw7DQorCQlpZiAoZGV2ICYmIGNoZWNrX3N0YWJsZV9wcml2YWN5
KGlkZXYsIGRldl9uZXQoZGV2KSwgbW9kZSkgPCAwKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKwl9
DQorDQorCXJldHVybiAwOw0KK30NCisNCiBzdGF0aWMgaW50IGluZXQ2X3NldF9saW5rX2FmKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNvbnN0IHN0cnVjdCBubGF0dHIgKm5sYSkNCiB7DQotCWlu
dCBlcnIgPSAtRUlOVkFMOw0KIAlzdHJ1Y3QgaW5ldDZfZGV2ICppZGV2ID0gX19pbjZfZGV2X2dl
dChkZXYpOw0KIAlzdHJ1Y3QgbmxhdHRyICp0YltJRkxBX0lORVQ2X01BWCArIDFdOw0KLQ0KLQlp
ZiAoIWlkZXYpDQotCQlyZXR1cm4gLUVBRk5PU1VQUE9SVDsNCisJaW50IGVycjsNCiANCiAJaWYg
KG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRlZCh0YiwgSUZMQV9JTkVUNl9NQVgsIG5sYSwgTlVM
TCwgTlVMTCkgPCAwKQ0KIAkJQlVHKCk7DQpAQCAtNTcxNCwxNSArNTczMiwxMCBAQCBzdGF0aWMg
aW50IGluZXQ2X3NldF9saW5rX2FmKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNvbnN0IHN0cnVj
dCBubGF0dHIgKm5sYSkNCiAJaWYgKHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pIHsNCiAJ
CXU4IG1vZGUgPSBubGFfZ2V0X3U4KHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pOw0KIA0K
LQkJaWYgKGNoZWNrX2FkZHJfZ2VuX21vZGUobW9kZSkgPCAwIHx8DQotCQkgICAgY2hlY2tfc3Rh
YmxlX3ByaXZhY3koaWRldiwgZGV2X25ldChkZXYpLCBtb2RlKSA8IDApDQotCQkJcmV0dXJuIC1F
SU5WQUw7DQotDQogCQlpZGV2LT5jbmYuYWRkcl9nZW5fbW9kZSA9IG1vZGU7DQotCQllcnIgPSAw
Ow0KIAl9DQogDQotCXJldHVybiBlcnI7DQorCXJldHVybiAwOw0KIH0NCiANCiBzdGF0aWMgaW50
IGluZXQ2X2ZpbGxfaWZpbmZvKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBpbmV0Nl9kZXYg
KmlkZXYsDQotLSANCjIuMTkuMQ0KDQo=
