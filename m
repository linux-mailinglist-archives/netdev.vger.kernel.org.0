Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1901B977
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfEMPFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:05:36 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:7317
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728169AbfEMPFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 11:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFDSK5DxBJQzwHbDhWqgFS3jl7aDFNqPf8+m1OOKD6E=;
 b=Bc/2eLFnguG0XmPIJcrZbsFMP2t/z8VWJr4T291YJE1R28rgw1UZHNHG66EhaWRKGZH2ng8OUB0GDAWA+ydy6pNdekWmkvzBQs2SPKRMYqomgrVkTD8jSFtaeyfHWJBdRk5Z+4L6kqBzBz/Kih9fAu2rO7HuaFalRhGUN3ZvAa8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6200.eurprd05.prod.outlook.com (20.178.95.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Mon, 13 May 2019 15:05:29 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 15:05:29 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [RFC 1] Validate required parameters in inet6_validate_link_af
Thread-Topic: [RFC 1] Validate required parameters in inet6_validate_link_af
Thread-Index: AQHVCZ1NeDPGjPYhgkO1bTpE25PzGw==
Date:   Mon, 13 May 2019 15:05:29 +0000
Message-ID: <20190513150513.26872-2-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 24c79cbc-ab3e-40f5-40b3-08d6d7b4702a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6200;
x-ms-traffictypediagnostic: AM6PR05MB6200:
x-microsoft-antispam-prvs: <AM6PR05MB6200DDB2F7CF889A35B3EF60D10F0@AM6PR05MB6200.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(199004)(189003)(86362001)(50226002)(478600001)(186003)(6436002)(6486002)(5660300002)(476003)(26005)(81166006)(99286004)(6116002)(14454004)(81156014)(256004)(3846002)(14444005)(53936002)(4326008)(107886003)(25786009)(8676002)(2616005)(71190400001)(71200400001)(8936002)(486006)(7736002)(316002)(73956011)(102836004)(305945005)(2906002)(52116002)(66066001)(110136005)(54906003)(11346002)(386003)(36756003)(6506007)(15650500001)(68736007)(6512007)(76176011)(64756008)(66446008)(1076003)(66556008)(66476007)(446003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6200;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RN2PNpOfNgIbjNyZ57LCWw3jExlQlJEaCPMMzZV1mW89YwDIm3A8o8VOY1Bv5EI4yuZEYV2fEgEQ2omTIlG8fcJu8lcjaB3fZiWTuNWUl+JHHmlbXtY9K2EtiiT+xmHQQxhRg942R/MSlX0G1zgde0iSX5mQIgNoe/jxrQIJBvFPNaDyQlr3j7xSldxkGLttZbscCOZtAQQckAwfSlb0NfV+FRZ22D9bK0JFZN2WGDF0zlJ1xPMYHoRb+1oo6j9eVV7787pLqbpKaAbm6qsAzpgFljiUBq4omxmy7pEnBwWVzggHg3SAN/cu9DfisXvYX6uYJnz0AM/XggkmPfTPnnx72hFDrhv3z3gS6te4Ok/ooMYdlLYNf9LOnmeGPFlghIr8bckgKqDGkddB3FOqiken5rlKs49qmSZYKXcR/Fs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c79cbc-ab3e-40f5-40b3-08d6d7b4702a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 15:05:29.8504
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
aW5rIGRvZXMNCmFueXRoaW5nLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNraXkg
PG1heGltbWlAbWVsbGFub3guY29tPg0KLS0tDQogbmV0L2lwdjYvYWRkcmNvbmYuYyB8IDEyICsr
KysrKysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvYWRkcmNvbmYuYyBiL25ldC9pcHY2L2FkZHJj
b25mLmMNCmluZGV4IGY5NmQxZGU3OTUwOS4uZWYzOGQzODFjY2JkIDEwMDY0NA0KLS0tIGEvbmV0
L2lwdjYvYWRkcmNvbmYuYw0KKysrIGIvbmV0L2lwdjYvYWRkcmNvbmYuYw0KQEAgLTU2NjUsMTIg
KzU2NjUsMjAgQEAgc3RhdGljIGludCBpbmV0Nl92YWxpZGF0ZV9saW5rX2FmKGNvbnN0IHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYsDQogCQkJCSAgY29uc3Qgc3RydWN0IG5sYXR0ciAqbmxhKQ0KIHsN
CiAJc3RydWN0IG5sYXR0ciAqdGJbSUZMQV9JTkVUNl9NQVggKyAxXTsNCisJaW50IGVycjsNCiAN
CiAJaWYgKGRldiAmJiAhX19pbjZfZGV2X2dldChkZXYpKQ0KIAkJcmV0dXJuIC1FQUZOT1NVUFBP
UlQ7DQogDQotCXJldHVybiBubGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0ZWQodGIsIElGTEFfSU5F
VDZfTUFYLCBubGEsDQotCQkJCQkgICBpbmV0Nl9hZl9wb2xpY3ksIE5VTEwpOw0KKwllcnIgPSBu
bGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0ZWQodGIsIElGTEFfSU5FVDZfTUFYLCBubGEsDQorCQkJ
CQkgIGluZXQ2X2FmX3BvbGljeSwgTlVMTCk7DQorCWlmIChlcnIpDQorCQlyZXR1cm4gZXJyOw0K
Kw0KKwlpZiAoIXRiW0lGTEFfSU5FVDZfVE9LRU5dICYmICF0YltJRkxBX0lORVQ2X0FERFJfR0VO
X01PREVdKQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQorDQorCXJldHVybiAwOw0KIH0NCiANCiBzdGF0
aWMgaW50IGNoZWNrX2FkZHJfZ2VuX21vZGUoaW50IG1vZGUpDQotLSANCjIuMTkuMQ0KDQo=
