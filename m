Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5863424836
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 08:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEUGkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 02:40:09 -0400
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:53379
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfEUGkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 02:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPy6zuy6WtcS/8RrsGPUQLQypXpJgx5VvcCf4j+e3Ck=;
 b=GeeM7WIKrpU+UpWmkf9b4tyizA7V+coIRKLclSLTxHgw7hk9xE2ANa5wbuU1chv38Icq9so2OP1ng1bCv1TItZRSbtk9qSsKPBp0tCy/bLEIgBcDeE1XvlgZLOfqJI61JguxxFq/5nxynLCvy0fZmRUt8B3IgsnajrA3SVbDhjg=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5112.eurprd05.prod.outlook.com (20.177.190.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Tue, 21 May 2019 06:40:04 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 06:40:04 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2] Validate required parameters in inet6_validate_link_af
Thread-Topic: [PATCH net v2] Validate required parameters in
 inet6_validate_link_af
Thread-Index: AQHVD6AFTi+u8kJV8UmGG73D0HNr4w==
Date:   Tue, 21 May 2019 06:40:04 +0000
Message-ID: <20190521063941.7451-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0127.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::19) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80574553-323d-44ca-2381-08d6ddb727f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5112;
x-ms-traffictypediagnostic: AM6PR05MB5112:
x-microsoft-antispam-prvs: <AM6PR05MB5112F429A656CC3F1815D6BCD1070@AM6PR05MB5112.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(66946007)(71190400001)(71200400001)(52116002)(99286004)(73956011)(36756003)(102836004)(1076003)(7736002)(66556008)(14444005)(68736007)(478600001)(6486002)(256004)(66476007)(6506007)(386003)(66446008)(64756008)(305945005)(8676002)(81166006)(81156014)(110136005)(2616005)(5660300002)(53936002)(54906003)(107886003)(86362001)(476003)(4326008)(8936002)(50226002)(15650500001)(14454004)(66066001)(6116002)(3846002)(486006)(6436002)(2906002)(6512007)(316002)(25786009)(186003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5112;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UU/af5wf9nMZGKCAhxCZXci8zvroXvxIunNfowxqita49u5k90GjdnbYRk3jrVQh5oaaoxcHtZpCd8dfXC+fqDlYuwAYEiorGJmlCmxe5Yoj9LO0DtNckScXw0NcIUirhyo0cMC+8LJgr2q+9obJo0kzhbJG0T5BB0cwiD6BIVazQMt+NViiBjBQ7qDkiO8yXg9a2R6wyccPEkvMwjwVmdDWLjZXc4vYY+GFdeDV3Cyt59mNL7j1EEN+JlbPd3NQ0sPZU7O+vPdBt7gP4WITydkVkHUnLI5YiOmrpSkwEZmEv7kdckzFoskBL3tBmCcxQf/l5fQRLOSLyDgQXEYooDftX7urWZJ/zFwJ2xS+1rpGN046Q+ZEn59hGXkoi+1iiO5I7XdyZcqC/UGlgLoffjW3D1hxust8wiIrKo3yvbE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80574553-323d-44ca-2381-08d6ddb727f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 06:40:04.1625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5112
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
dCwNCnJldmVyc2VkIGEgQ2hyaXN0bWFzIHRyZWUuDQoNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9h
ZGRyY29uZi5jIGIvbmV0L2lwdjYvYWRkcmNvbmYuYw0KaW5kZXggZjk2ZDFkZTc5NTA5Li5iNTE2
MzBkZGI3MjggMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9hZGRyY29uZi5jDQorKysgYi9uZXQvaXB2
Ni9hZGRyY29uZi5jDQpAQCAtNTY2MSwxOCArNTY2MSw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
bmxhX3BvbGljeSBpbmV0Nl9hZl9wb2xpY3lbSUZMQV9JTkVUNl9NQVggKyAxXSA9IHsNCiAJW0lG
TEFfSU5FVDZfVE9LRU5dCQk9IHsgLmxlbiA9IHNpemVvZihzdHJ1Y3QgaW42X2FkZHIpIH0sDQog
fTsNCiANCi1zdGF0aWMgaW50IGluZXQ2X3ZhbGlkYXRlX2xpbmtfYWYoY29uc3Qgc3RydWN0IG5l
dF9kZXZpY2UgKmRldiwNCi0JCQkJICBjb25zdCBzdHJ1Y3QgbmxhdHRyICpubGEpDQotew0KLQlz
dHJ1Y3QgbmxhdHRyICp0YltJRkxBX0lORVQ2X01BWCArIDFdOw0KLQ0KLQlpZiAoZGV2ICYmICFf
X2luNl9kZXZfZ2V0KGRldikpDQotCQlyZXR1cm4gLUVBRk5PU1VQUE9SVDsNCi0NCi0JcmV0dXJu
IG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRlZCh0YiwgSUZMQV9JTkVUNl9NQVgsIG5sYSwNCi0J
CQkJCSAgIGluZXQ2X2FmX3BvbGljeSwgTlVMTCk7DQotfQ0KLQ0KIHN0YXRpYyBpbnQgY2hlY2tf
YWRkcl9nZW5fbW9kZShpbnQgbW9kZSkNCiB7DQogCWlmIChtb2RlICE9IElONl9BRERSX0dFTl9N
T0RFX0VVSTY0ICYmDQpAQCAtNTY5MywxNCArNTY4MSw0NCBAQCBzdGF0aWMgaW50IGNoZWNrX3N0
YWJsZV9wcml2YWN5KHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYsIHN0cnVjdCBuZXQgKm5ldCwNCiAJ
cmV0dXJuIDE7DQogfQ0KIA0KK3N0YXRpYyBpbnQgaW5ldDZfdmFsaWRhdGVfbGlua19hZihjb25z
dCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KKwkJCQkgIGNvbnN0IHN0cnVjdCBubGF0dHIgKm5s
YSkNCit7DQorCXN0cnVjdCBubGF0dHIgKnRiW0lGTEFfSU5FVDZfTUFYICsgMV07DQorCXN0cnVj
dCBpbmV0Nl9kZXYgKmlkZXYgPSBOVUxMOw0KKwlpbnQgZXJyOw0KKw0KKwlpZiAoZGV2KSB7DQor
CQlpZGV2ID0gX19pbjZfZGV2X2dldChkZXYpOw0KKwkJaWYgKCFpZGV2KQ0KKwkJCXJldHVybiAt
RUFGTk9TVVBQT1JUOw0KKwl9DQorDQorCWVyciA9IG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRl
ZCh0YiwgSUZMQV9JTkVUNl9NQVgsIG5sYSwNCisJCQkJCSAgaW5ldDZfYWZfcG9saWN5LCBOVUxM
KTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorDQorCWlmICghdGJbSUZMQV9JTkVUNl9U
T0tFTl0gJiYgIXRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pDQorCQlyZXR1cm4gLUVJTlZB
TDsNCisNCisJaWYgKHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pIHsNCisJCXU4IG1vZGUg
PSBubGFfZ2V0X3U4KHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pOw0KKw0KKwkJaWYgKGNo
ZWNrX2FkZHJfZ2VuX21vZGUobW9kZSkgPCAwKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKwkJaWYg
KGRldiAmJiBjaGVja19zdGFibGVfcHJpdmFjeShpZGV2LCBkZXZfbmV0KGRldiksIG1vZGUpIDwg
MCkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3Rh
dGljIGludCBpbmV0Nl9zZXRfbGlua19hZihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBjb25zdCBz
dHJ1Y3QgbmxhdHRyICpubGEpDQogew0KLQlpbnQgZXJyID0gLUVJTlZBTDsNCiAJc3RydWN0IGlu
ZXQ2X2RldiAqaWRldiA9IF9faW42X2Rldl9nZXQoZGV2KTsNCiAJc3RydWN0IG5sYXR0ciAqdGJb
SUZMQV9JTkVUNl9NQVggKyAxXTsNCi0NCi0JaWYgKCFpZGV2KQ0KLQkJcmV0dXJuIC1FQUZOT1NV
UFBPUlQ7DQorCWludCBlcnI7DQogDQogCWlmIChubGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0ZWQo
dGIsIElGTEFfSU5FVDZfTUFYLCBubGEsIE5VTEwsIE5VTEwpIDwgMCkNCiAJCUJVRygpOw0KQEAg
LTU3MTQsMTUgKzU3MzIsMTAgQEAgc3RhdGljIGludCBpbmV0Nl9zZXRfbGlua19hZihzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2LCBjb25zdCBzdHJ1Y3QgbmxhdHRyICpubGEpDQogCWlmICh0YltJRkxB
X0lORVQ2X0FERFJfR0VOX01PREVdKSB7DQogCQl1OCBtb2RlID0gbmxhX2dldF91OCh0YltJRkxB
X0lORVQ2X0FERFJfR0VOX01PREVdKTsNCiANCi0JCWlmIChjaGVja19hZGRyX2dlbl9tb2RlKG1v
ZGUpIDwgMCB8fA0KLQkJICAgIGNoZWNrX3N0YWJsZV9wcml2YWN5KGlkZXYsIGRldl9uZXQoZGV2
KSwgbW9kZSkgPCAwKQ0KLQkJCXJldHVybiAtRUlOVkFMOw0KLQ0KIAkJaWRldi0+Y25mLmFkZHJf
Z2VuX21vZGUgPSBtb2RlOw0KLQkJZXJyID0gMDsNCiAJfQ0KIA0KLQlyZXR1cm4gZXJyOw0KKwly
ZXR1cm4gMDsNCiB9DQogDQogc3RhdGljIGludCBpbmV0Nl9maWxsX2lmaW5mbyhzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCBzdHJ1Y3QgaW5ldDZfZGV2ICppZGV2LA0KLS0gDQoyLjE5LjENCg0K
