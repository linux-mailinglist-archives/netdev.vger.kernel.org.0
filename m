Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3EF21F00
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfEQUTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:49 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbfEQUTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkKzOnn11FSkqoMVKpby/Lmtz8aEd3m+TH1hPVP2CSk=;
 b=ZXKtSX3edD9zIiPX3Bro/GFaOh0gSsADCmD0p58NbM+AO3/3o5lecKMyhMEk9ZQq60wZFi6hjf5r6XLlCuzYwGNcX5KQ1dmvUawx53VDf99Oj/tKb+eM69FxBAre6AeypEEt93TcOdH61KlQ7hybqEjsh75lcTvVKHaqWrkNxs8=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:36 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Valentine Fatiev <valentinef@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/11] net/mlx5: Add meaningful return codes to status_to_err
 function
Thread-Topic: [net 02/11] net/mlx5: Add meaningful return codes to
 status_to_err function
Thread-Index: AQHVDO3Z6FybqKaA80a9+a/oCNHfYw==
Date:   Fri, 17 May 2019 20:19:36 +0000
Message-ID: <20190517201910.32216-3-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20743bb5-0f5d-4592-dc23-08d6db04fa92
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB613803A5573C83630E1F78D0BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CGP87cRg5dBwAVra3zOgtDHP/msVKbBPC6PH1wCpn4+vhWJyr9m+6cFtNXs3zYNA6FJDav1azoFIxKvgsN86SUIsWgI+0O2FcbcBht6uBNN/SGFNB4AZHqaK7iTf7IMtRfZRi+Xd+yXR+xRolF+6k4GZsunHl/LDhsgXiSvX4AUTHnsHgvEdqDZ7VmgEJMbWgcWoMjqIMq0aowacra7xDp5fslZ0xlog6bjNtMtt8ULF7qRbaxv7FCFbhk/CoZBnTtXEkYq98KfAiAMb0KDXJ1XG+E5x2xno8zJCwUtyX6DKsfzK+tOl0xF0fEL7HHGREnaEdMa2YZwdw8X4DlNJULerB4QdOU/gl+ILrSNj0FOXwwitDjEfatC2leMFNu4wHdRI+UnOkfkfgOFWJobFSAF9oYiWkc8hsZ7HgkRuXfo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20743bb5-0f5d-4592-dc23-08d6db04fa92
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:36.5285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVmFsZW50aW5lIEZhdGlldiA8dmFsZW50aW5lZkBtZWxsYW5veC5jb20+DQoNCkN1cnJl
bnQgdmVyc2lvbiBvZiBmdW5jdGlvbiBzdGF0dXNfdG9fZXJyIHJldHVybiAtMSBmb3IgYW55DQpz
dGF0dXMgcmV0dXJuZWQgYnkgbWx4NV9jbWRfaW52b2tlIGZ1bmN0aW9uLiBJbiBjYXNlIHN0YXR1
cyBpcw0KTUxYNV9EUklWRVJfU1RBVFVTX0FCT1JURUQgd2Ugc2hvdWxkIHJldHVybiAwIHRvIHRo
ZSBjYWxsZXIgYXMgd2UNCmFzc3VtZSBjb21tYW5kIGNvbXBsZXRlZCBzdWNjZXNzZnVsbHkgb24g
RlcuIElmIGVycm9yIHJldHVybmVkIHdlIGFyZQ0KZ2V0dGluZyBjb25mdXNpbmcgbWVzc2FnZXMg
aW4gZG1lc2cuIEluIGFkZGl0aW9uLCBjdXJyZW50bHkgcmV0dXJuZWQNCnZhbHVlIC0xIGlzIGNv
bmZ1c2luZyB3aXRoIC1FUEVSTS4NCg0KTmV3IGltcGxlbWVudGF0aW9uIGFjdHVhbGx5IGZpeCBv
cmlnaW5hbCBjb21taXQgYW5kIHJldHVybiBtZWFuaW5nZnVsDQpjb2RlcyBmb3IgY29tbWFuZHMg
ZGVsaXZlcnkgc3RhdHVzIGFuZCBwcmludCBtZXNzYWdlIGluIGNhc2Ugb2YgZmFpbHVyZS4NCg0K
Rml4ZXM6IGUxMjZiYTk3ZGJhOSAoIm1seDU6IEFkZCBkcml2ZXIgZm9yIE1lbGxhbm94IENvbm5l
Y3QtSUIgYWRhcHRlcnMiKQ0KU2lnbmVkLW9mZi1ieTogVmFsZW50aW5lIEZhdGlldiA8dmFsZW50
aW5lZkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9jbWQuYyB8IDIyICsrKysrKysrKysrKysrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgMjEg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2NtZC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2NtZC5jDQppbmRleCA5MzdiYTRiY2IwNTYuLmQyYWI4Y2Q4YWQ5
ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9j
bWQuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2NtZC5j
DQpAQCAtMTYwNCw3ICsxNjA0LDI3IEBAIHZvaWQgbWx4NV9jbWRfZmx1c2goc3RydWN0IG1seDVf
Y29yZV9kZXYgKmRldikNCiANCiBzdGF0aWMgaW50IHN0YXR1c190b19lcnIodTggc3RhdHVzKQ0K
IHsNCi0JcmV0dXJuIHN0YXR1cyA/IC0xIDogMDsgLyogVEJEIG1vcmUgbWVhbmluZ2Z1bCBjb2Rl
cyAqLw0KKwlzd2l0Y2ggKHN0YXR1cykgew0KKwljYXNlIE1MWDVfQ01EX0RFTElWRVJZX1NUQVRf
T0s6DQorCWNhc2UgTUxYNV9EUklWRVJfU1RBVFVTX0FCT1JURUQ6DQorCQlyZXR1cm4gMDsNCisJ
Y2FzZSBNTFg1X0NNRF9ERUxJVkVSWV9TVEFUX1NJR05BVF9FUlI6DQorCWNhc2UgTUxYNV9DTURf
REVMSVZFUllfU1RBVF9UT0tfRVJSOg0KKwkJcmV0dXJuIC1FQkFEUjsNCisJY2FzZSBNTFg1X0NN
RF9ERUxJVkVSWV9TVEFUX0JBRF9CTEtfTlVNX0VSUjoNCisJY2FzZSBNTFg1X0NNRF9ERUxJVkVS
WV9TVEFUX09VVF9QVFJfQUxJR05fRVJSOg0KKwljYXNlIE1MWDVfQ01EX0RFTElWRVJZX1NUQVRf
SU5fUFRSX0FMSUdOX0VSUjoNCisJCXJldHVybiAtRUZBVUxUOyAvKiBCYWQgYWRkcmVzcyAqLw0K
KwljYXNlIE1MWDVfQ01EX0RFTElWRVJZX1NUQVRfSU5fTEVOR1RIX0VSUjoNCisJY2FzZSBNTFg1
X0NNRF9ERUxJVkVSWV9TVEFUX09VVF9MRU5HVEhfRVJSOg0KKwljYXNlIE1MWDVfQ01EX0RFTElW
RVJZX1NUQVRfQ01EX0RFU0NSX0VSUjoNCisJY2FzZSBNTFg1X0NNRF9ERUxJVkVSWV9TVEFUX1JF
U19GTERfTk9UX0NMUl9FUlI6DQorCQlyZXR1cm4gLUVOT01TRzsNCisJY2FzZSBNTFg1X0NNRF9E
RUxJVkVSWV9TVEFUX0ZXX0VSUjoNCisJCXJldHVybiAtRUlPOw0KKwlkZWZhdWx0Og0KKwkJcmV0
dXJuIC1FSU5WQUw7DQorCX0NCiB9DQogDQogc3RhdGljIHN0cnVjdCBtbHg1X2NtZF9tc2cgKmFs
bG9jX21zZyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQgaW5fc2l6ZSwNCi0tIA0KMi4y
MS4wDQoNCg==
