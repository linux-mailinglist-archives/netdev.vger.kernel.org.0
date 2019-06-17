Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAE748E60
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfFQTX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:57 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:28142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728929AbfFQTXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JZmUT8RJkFZv8UYsulFnBA1YnEpqcqHLPYHq8vKjJA=;
 b=VjG2fQ6qE2OeP1I6aocGTXSA+IFekl9ndWe+9pcvwlwVS2ZGgTxcoLfJJJ+oGp7wZnuWJ6B5IppvbwhDQqY/4kRbn/GJFm+OqZvZX7luDfayvDxRjEQhsiHY5bauNkAWvjC/WX5YUnDkaGRjvFB0CZYs2PLO2QxB4KTr1jlyh1M=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:39 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 15/15] RDMA/mlx5: Cleanup rep when doing unload
Thread-Topic: [PATCH mlx5-next 15/15] RDMA/mlx5: Cleanup rep when doing unload
Thread-Index: AQHVJUIq9S1HPm0+6062g5fTpQ2fnQ==
Date:   Mon, 17 Jun 2019 19:23:39 +0000
Message-ID: <20190617192247.25107-16-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da696439-c977-4e8d-c6d5-08d6f3594cee
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB2789D85A65F4B3A0A74ACCCBBEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(14444005)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bbvfukotLMQ6c4+8vzf8DLT1c7YKNaWR7/xrheJgMmeqrsh7HE0s6iQVitH/VjEFWXzqfVsgoJlO1TwAo/3N72MPARlm97ZHiFPaVpKBU3lLOsjqSP+VO2W1zCO8toEEVTHuNg3OUuH5i4pbLfqV/EUEm/ljDUuUeO3tuGhrpFuLrno3NNxL1885JuJEolBtr2cba0wTnDINV/9QmZwuhM/lAeKfAtprm5Ye1Zps5vlycJUEqnpN1MMQFpw/J9/jfdyMBnJ1oMDMpcdOsTWWDSr9T7dhRVhfuWlXT8y2mXc9VC1yyUb1KfHF8mOy9I5l9pRyro9TyKtVIP8jpbmhGnVRdufmF4RFqMAxJp42SO3Nced8GKD2fMp4fbAFYwIJZbA1sEnECLrSwPtwSDYbSOK9SrF3c1vzc+/btUvPdBc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da696439-c977-4e8d-c6d5-08d6f3594cee
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:39.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCldoZW4gYW4gSUIgcmVw
IGlzIGxvYWRlZCwgbmV0ZGV2IGZvciB0aGUgc2FtZSB2cG9ydCBpcyBzYXZlZCBmb3IgbGF0ZXIN
CnJlZmVyZW5jZS4gSG93ZXZlciwgaXQncyBub3QgY2xlYW5lZCB1cCB3aGVuIGRvaW5nIHVubG9h
ZC4gRm9yIEVDUEYsDQprZXJuZWwgY3Jhc2hlcyB3aGVuIGRyaXZlciBpcyByZWZlcnJpbmcgdG8g
dGhlIGFscmVhZHkgcmVtb3ZlZCBuZXRkZXYuDQoNCkZvbGxvd2luZyBzdGVwcyBsZWFkIHRvIGEg
c2hvd24gY2FsbCB0cmFjZToNCjEuIENyZWF0ZSBuIFZGcyBmcm9tIGhvc3QgUEYNCjIuIERpc3Ry
b3kgdGhlIFZGcw0KMy4gUnVuICJyZG1hIGxpbmsiIGZyb20gQVJNDQoNCkNhbGwgdHJhY2U6DQog
IG1seDVfaWJfZ2V0X25ldGRldisweDljLzB4ZTggW21seDVfaWJdDQogIG1seDVfcXVlcnlfcG9y
dF9yb2NlKzB4MjY4LzB4NTU4IFttbHg1X2liXQ0KICBtbHg1X2liX3JlcF9xdWVyeV9wb3J0KzB4
MTQvMHgzNCBbbWx4NV9pYl0NCiAgaWJfcXVlcnlfcG9ydCsweDljLzB4ZmMgW2liX2NvcmVdDQog
IGZpbGxfcG9ydF9pbmZvKzB4NzQvMHgyOGMgW2liX2NvcmVdDQogIG5sZGV2X3BvcnRfZ2V0X2Rv
aXQrMHgxYTgvMHgxZTggW2liX2NvcmVdDQogIHJkbWFfbmxfcmN2X21zZysweDE2Yy8weDFjMCBb
aWJfY29yZV0NCiAgcmRtYV9ubF9yY3YrMHhlOC8weDE0NCBbaWJfY29yZV0NCiAgbmV0bGlua191
bmljYXN0KzB4MTg0LzB4MjE0DQogIG5ldGxpbmtfc2VuZG1zZysweDI4OC8weDM1NA0KICBzb2Nr
X3NlbmRtc2crMHgxOC8weDJjDQogIF9fc3lzX3NlbmR0bysweGJjLzB4MTM4DQogIF9fYXJtNjRf
c3lzX3NlbmR0bysweDI4LzB4MzQNCiAgZWwwX3N2Y19jb21tb24rMHhiMC8weDEwMA0KICBlbDBf
c3ZjX2hhbmRsZXIrMHg2Yy8weDg0DQogIGVsMF9zdmMrMHg4LzB4Yw0KDQpDbGVhbnVwIHRoZSBy
ZXAgYW5kIG5ldGRldiByZWZlcmVuY2Ugd2hlbiB1bmxvYWRpbmcgSUIgcmVwLg0KDQpGaXhlczog
MjY2MjhlMmQ1OGM5ICgiUkRNQS9tbHg1OiBNb3ZlIHRvIHNpbmdsZSBkZXZpY2UgbXVsdGlwb3J0
IHBvcnRzIGluIHN3aXRjaGRldiBtb2RlIikNClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxi
b2RvbmdAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxh
bm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0t
DQogZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMgfCAxOCArKysrKysrKysrKy0t
LS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jIGIvZHJp
dmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCmluZGV4IGRhNGI5MzZiMzIxOS4uYTRh
NTRkZGViYjcxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVw
LmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jDQpAQCAtMTcsNiAr
MTcsNyBAQCBtbHg1X2liX3NldF92cG9ydF9yZXAoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwg
c3RydWN0IG1seDVfZXN3aXRjaF9yZXAgKnJlcCkNCiAJdnBvcnRfaW5kZXggPSByZXAtPnZwb3J0
X2luZGV4Ow0KIA0KIAlpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucmVwID0gcmVwOw0KKwlyZXAt
PnJlcF9kYXRhW1JFUF9JQl0ucHJpdiA9IGliZGV2Ow0KIAl3cml0ZV9sb2NrKCZpYmRldi0+cG9y
dFt2cG9ydF9pbmRleF0ucm9jZS5uZXRkZXZfbG9jayk7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2lu
ZGV4XS5yb2NlLm5ldGRldiA9DQogCQltbHg1X2liX2dldF9yZXBfbmV0ZGV2KGRldi0+cHJpdi5l
c3dpdGNoLCByZXAtPnZwb3J0KTsNCkBAIC02OCwxNSArNjksMTggQEAgbWx4NV9pYl92cG9ydF9y
ZXBfbG9hZChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBzdHJ1Y3QgbWx4NV9lc3dpdGNoX3Jl
cCAqcmVwKQ0KIHN0YXRpYyB2b2lkDQogbWx4NV9pYl92cG9ydF9yZXBfdW5sb2FkKHN0cnVjdCBt
bHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogew0KLQlzdHJ1Y3QgbWx4NV9pYl9kZXYgKmRldjsNCi0N
Ci0JaWYgKCFyZXAtPnJlcF9kYXRhW1JFUF9JQl0ucHJpdiB8fA0KLQkgICAgcmVwLT52cG9ydCAh
PSBNTFg1X1ZQT1JUX1VQTElOSykNCi0JCXJldHVybjsNCisJc3RydWN0IG1seDVfaWJfZGV2ICpk
ZXYgPSBtbHg1X2liX3JlcF90b19kZXYocmVwKTsNCisJc3RydWN0IG1seDVfaWJfcG9ydCAqcG9y
dDsNCiANCi0JZGV2ID0gbWx4NV9pYl9yZXBfdG9fZGV2KHJlcCk7DQotCV9fbWx4NV9pYl9yZW1v
dmUoZGV2LCBkZXYtPnByb2ZpbGUsIE1MWDVfSUJfU1RBR0VfTUFYKTsNCisJcG9ydCA9ICZkZXYt
PnBvcnRbcmVwLT52cG9ydF9pbmRleF07DQorCXdyaXRlX2xvY2soJnBvcnQtPnJvY2UubmV0ZGV2
X2xvY2spOw0KKwlwb3J0LT5yb2NlLm5ldGRldiA9IE5VTEw7DQorCXdyaXRlX3VubG9jaygmcG9y
dC0+cm9jZS5uZXRkZXZfbG9jayk7DQogCXJlcC0+cmVwX2RhdGFbUkVQX0lCXS5wcml2ID0gTlVM
TDsNCisJcG9ydC0+cmVwID0gTlVMTDsNCisNCisJaWYgKHJlcC0+dnBvcnQgPT0gTUxYNV9WUE9S
VF9VUExJTkspDQorCQlfX21seDVfaWJfcmVtb3ZlKGRldiwgZGV2LT5wcm9maWxlLCBNTFg1X0lC
X1NUQUdFX01BWCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkICptbHg1X2liX3Zwb3J0X2dldF9wcm90
b19kZXYoc3RydWN0IG1seDVfZXN3aXRjaF9yZXAgKnJlcCkNCi0tIA0KMi4yMS4wDQoNCg==
