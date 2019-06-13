Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7526844DA7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfFMUkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:40:12 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2635
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730046AbfFMUkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 16:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjzw+xqVWGq5ZPIBgh4Tx4+YSRPW4ArENszEWDkrWoA=;
 b=TTSZtm2g4fwnb7JmIO9PNw7ozoBdlnbFuCEaGPvcgwDPvxBoj8M9UpkN5eCvlFz15xzWjqvfcNiQ7YfKAZghDjHJVUsnjsBh86JwJTCQ/NIk/MSgzafGku2Cwf5SByfAxAZcg77aPtHpO0pTb0kO7XSu2jzKG3d+ROIpjuQO7jQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2629.eurprd05.prod.outlook.com (10.172.225.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 20:39:40 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 20:39:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 13/15] net/mlx5: Add support for FW fatal reporter dump
Thread-Topic: [net-next v2 13/15] net/mlx5: Add support for FW fatal reporter
 dump
Thread-Index: AQHVIigf1C2IKuuwXUu+hV5rV9Wv/A==
Date:   Thu, 13 Jun 2019 20:39:40 +0000
Message-ID: <20190613203825.31049-14-saeedm@mellanox.com>
References: <20190613203825.31049-1-saeedm@mellanox.com>
In-Reply-To: <20190613203825.31049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be9f20db-8fcb-4f77-020f-08d6f03f41f0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2629;
x-ms-traffictypediagnostic: DB6PR0501MB2629:
x-microsoft-antispam-prvs: <DB6PR0501MB2629F109099743476BFA1301BEEF0@DB6PR0501MB2629.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(8676002)(6916009)(81156014)(81166006)(2616005)(316002)(11346002)(25786009)(4326008)(6512007)(86362001)(476003)(486006)(8936002)(6436002)(446003)(50226002)(6486002)(66066001)(36756003)(26005)(305945005)(7736002)(186003)(73956011)(66946007)(64756008)(66446008)(66556008)(66476007)(53936002)(6116002)(256004)(3846002)(1076003)(71190400001)(71200400001)(2906002)(478600001)(99286004)(52116002)(14454004)(102836004)(54906003)(76176011)(5660300002)(6506007)(107886003)(386003)(68736007)(505234006)(383094003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2629;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YXeBV1ax58rLueD+4PFXFRDzkUU6L2/CXZVZAGSKw/o9kGm4QHGr20CyR3qFO6SkwsQU9O9e40QYs9QIUuDCfw5j2GhHRQBpgsS2TnoWIFktdL7vM+V5vCMhXfL/4AmbyvWLd4efbX53OxB+wNV0aLKJy2yOCQGkEgY8lPgtdo9iUzaNHbOmcTcblSQjng+CZN2WWTwZfQmW0f+91YV200fk7gNSOv0guCI2joOQ3J4ujqR6h7ZrRO8X8B1lTWn1EPIXIZGoSKC6pKGgEnr/KtCQPUEJBnMCYQKEJtZR95V/zkD9rxNiPsvDrjAOGIuPqBkesewWBx1A8/9SsuzSDZu3Ldbim/nXETAsbW4xtn9WTLsPk21HAYP1kob2e+AbeSDl9R8M//aiM3r9iB7DtQYqaEsbHL6P+cCYzrhG8lU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be9f20db-8fcb-4f77-020f-08d6f03f41f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:39:40.5142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2629
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpBZGQgc3VwcG9ydCBv
ZiBkdW1wIGNhbGxiYWNrIGZvciBtbHg1IEZXIGZhdGFsIHJlcG9ydGVyLg0KVGhlIEZXIGZhdGFs
IGR1bXAgdXNlcyBjci1kdW1wIGZ1bmN0aW9uYWxpdHkgdG8gZ2F0aGVyIGNyLXNwYWNlIGRhdGEg
Zm9yDQpkZWJ1Zy4gVGhlIGNyLWR1bXAgdXNlcyB2c2MgaW50ZXJmYWNlIHdoaWNoIGlzIHZhbGlk
IGV2ZW4gaWYgdGhlIEZXDQpjb21tYW5kIGludGVyZmFjZSBpcyBub3QgZnVuY3Rpb25hbCwgd2hp
Y2ggaXMgdGhlIGNhc2UgaW4gbW9zdCBGVyBmYXRhbA0KZXJyb3JzLg0KDQpDb21tYW5kIGV4YW1w
bGUgYW5kIG91dHB1dDoNCiQgZGV2bGluayBoZWFsdGggZHVtcCBzaG93IHBjaS8wMDAwOjgyOjAw
LjAgcmVwb3J0ZXIgZndfZmF0YWwNCiBjcmR1bXBfZGF0YToNCiAgMDAgMjAgMDAgMDEgMDAgMDAg
MDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDANCiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDANCiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDANCiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDANCiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgODANCiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAN
CiAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgYmEgODIgMDAgMDANCiAgMGMg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMjANCiAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgZmEgMDANCiAgYTQgMGUgMDAgMDAgMDAg
MDAgMDAgMDAgODAgYzcgZmUgZmYgNTAgMGEgMDAgMDANCi4uLg0KLi4uDQoNClNpZ25lZC1vZmYt
Ynk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgIHwgNTAgKysrKysrKysrKysrKysrKysrKw0K
IDEgZmlsZSBjaGFuZ2VkLCA1MCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCmluZGV4IDgyYTY1ODgzNDY3NS4u
NGVmNjJjNmM2NDI0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2hlYWx0aC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvaGVhbHRoLmMNCkBAIC01NjUsOSArNTY1LDU5IEBAIG1seDVfZndfZmF0YWxfcmVw
b3J0ZXJfcmVjb3ZlcihzdHJ1Y3QgZGV2bGlua19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVyLA0K
IAlyZXR1cm4gbWx4NV9oZWFsdGhfdHJ5X3JlY292ZXIoZGV2KTsNCiB9DQogDQorI2RlZmluZSBN
TFg1X0NSX0RVTVBfQ0hVTktfU0laRSAyNTYNCitzdGF0aWMgaW50DQorbWx4NV9md19mYXRhbF9y
ZXBvcnRlcl9kdW1wKHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciAqcmVwb3J0ZXIsDQor
CQkJICAgIHN0cnVjdCBkZXZsaW5rX2Ztc2cgKmZtc2csIHZvaWQgKnByaXZfY3R4KQ0KK3sNCisJ
c3RydWN0IG1seDVfY29yZV9kZXYgKmRldiA9IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX3ByaXYo
cmVwb3J0ZXIpOw0KKwl1MzIgY3JkdW1wX3NpemUgPSBkZXYtPnByaXYuaGVhbHRoLmNyZHVtcF9z
aXplOw0KKwl1MzIgKmNyX2RhdGE7DQorCXUzMiBkYXRhX3NpemU7DQorCXUzMiBvZmZzZXQ7DQor
CWludCBlcnI7DQorDQorCWlmICghbWx4NV9jb3JlX2lzX3BmKGRldikpDQorCQlyZXR1cm4gLUVQ
RVJNOw0KKw0KKwljcl9kYXRhID0ga3ZtYWxsb2MoY3JkdW1wX3NpemUsIEdGUF9LRVJORUwpOw0K
KwlpZiAoIWNyX2RhdGEpDQorCQlyZXR1cm4gLUVOT01FTTsNCisJZXJyID0gbWx4NV9jcmR1bXBf
Y29sbGVjdChkZXYsIGNyX2RhdGEpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJ
aWYgKHByaXZfY3R4KSB7DQorCQlzdHJ1Y3QgbWx4NV9md19yZXBvcnRlcl9jdHggKmZ3X3JlcG9y
dGVyX2N0eCA9IHByaXZfY3R4Ow0KKw0KKwkJZXJyID0gbWx4NV9md19yZXBvcnRlcl9jdHhfcGFp
cnNfcHV0KGZtc2csIGZ3X3JlcG9ydGVyX2N0eCk7DQorCQlpZiAoZXJyKQ0KKwkJCWdvdG8gZnJl
ZV9kYXRhOw0KKwl9DQorDQorCWVyciA9IGRldmxpbmtfZm1zZ19hcnJfcGFpcl9uZXN0X3N0YXJ0
KGZtc2csICJjcmR1bXBfZGF0YSIpOw0KKwlpZiAoZXJyKQ0KKwkJZ290byBmcmVlX2RhdGE7DQor
CWZvciAob2Zmc2V0ID0gMDsgb2Zmc2V0IDwgY3JkdW1wX3NpemU7IG9mZnNldCArPSBkYXRhX3Np
emUpIHsNCisJCWlmIChjcmR1bXBfc2l6ZSAtIG9mZnNldCA8IE1MWDVfQ1JfRFVNUF9DSFVOS19T
SVpFKQ0KKwkJCWRhdGFfc2l6ZSA9IGNyZHVtcF9zaXplIC0gb2Zmc2V0Ow0KKwkJZWxzZQ0KKwkJ
CWRhdGFfc2l6ZSA9IE1MWDVfQ1JfRFVNUF9DSFVOS19TSVpFOw0KKwkJZXJyID0gZGV2bGlua19m
bXNnX2JpbmFyeV9wdXQoZm1zZywgY3JfZGF0YSwgZGF0YV9zaXplKTsNCisJCWlmIChlcnIpDQor
CQkJZ290byBmcmVlX2RhdGE7DQorCX0NCisJZXJyID0gZGV2bGlua19mbXNnX2Fycl9wYWlyX25l
c3RfZW5kKGZtc2cpOw0KKw0KK2ZyZWVfZGF0YToNCisJa2ZyZWUoY3JfZGF0YSk7DQorCXJldHVy
biBlcnI7DQorfQ0KKw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGV2bGlua19oZWFsdGhfcmVwb3J0
ZXJfb3BzIG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfb3BzID0gew0KIAkJLm5hbWUgPSAiZndfZmF0
YWwiLA0KIAkJLnJlY292ZXIgPSBtbHg1X2Z3X2ZhdGFsX3JlcG9ydGVyX3JlY292ZXIsDQorCQku
ZHVtcCA9IG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfZHVtcCwNCiB9Ow0KIA0KICNkZWZpbmUgTUxY
NV9SRVBPUlRFUl9GV19HUkFDRUZVTF9QRVJJT0QgMTIwMDAwMA0KLS0gDQoyLjIxLjANCg0K
