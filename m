Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0002E889
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfE2Wuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:50:37 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40056
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfE2Wuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHw6DYWMTf8fUd0R0dEElrFCQsJ7Zf8e7AWH7U/mczU=;
 b=RWt+zZYJHTwxYLT1klMpvCMGO1Mk9HN9b9qLtPR+c4a7ydLnETMJP/Qk5yVIwmJPP3QodNCD1wUTa9hSu0eHNbqYn8MzLhN1MRo5pJPR19Y5MtR49aDAr+5cfA/0Mwg8+mbpSfDfWo1/HocTWXlPYGdYIcsijd6gpA5Gga9t6+0=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB4351.eurprd05.prod.outlook.com (52.133.12.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 22:50:30 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 22:50:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH mlx5-next 2/6] net/mlx5: Introduce termination table bits
Thread-Topic: [PATCH mlx5-next 2/6] net/mlx5: Introduce termination table bits
Thread-Index: AQHVFnDpylWTnV+un024jSmvnGT3gQ==
Date:   Wed, 29 May 2019 22:50:29 +0000
Message-ID: <20190529224949.18194-3-saeedm@mellanox.com>
References: <20190529224949.18194-1-saeedm@mellanox.com>
In-Reply-To: <20190529224949.18194-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0683a8c0-eb2b-45f8-bfb4-08d6e4880a31
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4351;
x-ms-traffictypediagnostic: VI1PR05MB4351:
x-microsoft-antispam-prvs: <VI1PR05MB435104462BBDFC5877B4D89DBE1F0@VI1PR05MB4351.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(66446008)(73956011)(66946007)(64756008)(186003)(305945005)(76176011)(68736007)(66476007)(52116002)(107886003)(86362001)(1076003)(50226002)(4326008)(450100002)(66556008)(85306007)(6636002)(99286004)(54906003)(53936002)(102836004)(478600001)(6506007)(36756003)(8936002)(6512007)(8676002)(81156014)(110136005)(476003)(3846002)(6486002)(2616005)(256004)(26005)(5660300002)(6436002)(446003)(486006)(25786009)(2906002)(71200400001)(71190400001)(386003)(316002)(14444005)(6116002)(66066001)(11346002)(14454004)(7736002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4351;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 99Mya3T8EbB3tEBl4BO+sL6AufM3E4zCKa/o0Jz4C1ezZVTGWlTizDKTvHX9/mTCe9GUWjsoMHfgt34Nj4Ss8GhksoOY83e1UPSeNQQ4G9fSntbuK49dOTa60ETXRzkdXeEWIBDd8P/Vd6wboHwviCA3STATNX36oqePGOj2cxvP45Nki1l64upAiWvZQizZfs5AHRhA0K6afTCGKALKE4aIeKieyWKixujVriuzkxbaQzqotWpJ4/MnFpcZE9ndPTOscsb5rZYny3jQpHfLiVPfvjjC+id+5LE6L/C9JqX2791SZVhs3zTcCU8p3BL0Ov00IHGrNynOoJ8RtCuSaMlk2nOKECvOQIcKNf8zcxChP/8QoGpAEQvhAE9YpOC8Jl80H6hxIl+2nGd8GYmxSXqfGE31JVXljSc1KQ3cfa4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0683a8c0-eb2b-45f8-bfb4-08d6e4880a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 22:50:29.6768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpUZXJtaW5hdGlvbiB0
YWJsZSBpcyBhIGZsb3cgdGFibGUgd2l0aCBhIHRlcm1pbmF0aW9uIGZsYWcuIFRoZSBmbGFnDQph
bGxvd3MgdGhlIGZpcm13YXJlIHRvIGFzc3VtZSB0aGF0IHRoZSB0aGUgc3BlY2lmaWVkIGFjdGlv
bnMgYXJlIHRoZSBsYXN0DQphY3Rpb25zIGxpc3QuIFRoaXMgYXNzdW1wdGlvbiBhbGxvd3MgdGhl
IEZXIHRvIHNhZmVseSBwZXJmb3JtIHBvdGVudGlhbA0KbG9vcGluZyBsb2dpYyAoZS5nLiBoYWly
cGluKS4gSW50cm9kdWNlIHRoZSBiaXRzIGZvciB0aGlzIGF0dHJpYnV0ZS4NCg0KU2lnbmVkLW9m
Zi1ieTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IE96
IFNobG9tbyA8b3pzaEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9mc19jbWQuYyB8IDMgKysrDQogaW5jbHVkZS9saW51eC9tbHg1L2ZzLmgg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgMSArDQogaW5jbHVkZS9saW51eC9tbHg1L21seDVf
aWZjLmggICAgICAgICAgICAgICAgICAgIHwgNiArKysrLS0NCiAzIGZpbGVzIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jbWQuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9mc19jbWQuYw0KaW5kZXggMDEzYjFjYTRhNzkxLi5iYjI0
YzM3OTcyMTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZnNfY21kLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9mc19jbWQuYw0KQEAgLTE0Nyw2ICsxNDcsNyBAQCBzdGF0aWMgaW50IG1seDVfY21kX2Ny
ZWF0ZV9mbG93X3RhYmxlKHN0cnVjdCBtbHg1X2Zsb3dfcm9vdF9uYW1lc3BhY2UgKm5zLA0KIHsN
CiAJaW50IGVuX2VuY2FwID0gISEoZnQtPmZsYWdzICYgTUxYNV9GTE9XX1RBQkxFX1RVTk5FTF9F
Tl9SRUZPUk1BVCk7DQogCWludCBlbl9kZWNhcCA9ICEhKGZ0LT5mbGFncyAmIE1MWDVfRkxPV19U
QUJMRV9UVU5ORUxfRU5fREVDQVApOw0KKwlpbnQgdGVybSA9ICEhKGZ0LT5mbGFncyAmIE1MWDVf
RkxPV19UQUJMRV9URVJNSU5BVElPTik7DQogCXUzMiBvdXRbTUxYNV9TVF9TWl9EVyhjcmVhdGVf
Zmxvd190YWJsZV9vdXQpXSA9IHswfTsNCiAJdTMyIGluW01MWDVfU1RfU1pfRFcoY3JlYXRlX2Zs
b3dfdGFibGVfaW4pXSAgID0gezB9Ow0KIAlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2ID0gbnMt
PmRldjsNCkBAIC0xNjcsNiArMTY4LDggQEAgc3RhdGljIGludCBtbHg1X2NtZF9jcmVhdGVfZmxv
d190YWJsZShzdHJ1Y3QgbWx4NV9mbG93X3Jvb3RfbmFtZXNwYWNlICpucywNCiAJCSBlbl9kZWNh
cCk7DQogCU1MWDVfU0VUKGNyZWF0ZV9mbG93X3RhYmxlX2luLCBpbiwgZmxvd190YWJsZV9jb250
ZXh0LnJlZm9ybWF0X2VuLA0KIAkJIGVuX2VuY2FwKTsNCisJTUxYNV9TRVQoY3JlYXRlX2Zsb3df
dGFibGVfaW4sIGluLCBmbG93X3RhYmxlX2NvbnRleHQudGVybWluYXRpb25fdGFibGUsDQorCQkg
dGVybSk7DQogDQogCXN3aXRjaCAoZnQtPm9wX21vZCkgew0KIAljYXNlIEZTX0ZUX09QX01PRF9O
T1JNQUw6DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2ZzLmggYi9pbmNsdWRlL2xp
bnV4L21seDUvZnMuaA0KaW5kZXggZTY5MGJhMGY5NjVjLi4yZGRhYTk3ZjIxNzkgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL2xpbnV4L21seDUvZnMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L2Zz
LmgNCkBAIC00Nyw2ICs0Nyw3IEBAIGVudW0gew0KIGVudW0gew0KIAlNTFg1X0ZMT1dfVEFCTEVf
VFVOTkVMX0VOX1JFRk9STUFUID0gQklUKDApLA0KIAlNTFg1X0ZMT1dfVEFCTEVfVFVOTkVMX0VO
X0RFQ0FQID0gQklUKDEpLA0KKwlNTFg1X0ZMT1dfVEFCTEVfVEVSTUlOQVRJT04gPSBCSVQoMiks
DQogfTsNCiANCiAjZGVmaW5lIExFRlRPVkVSU19SVUxFX05VTQkgMg0KZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZj
LmgNCmluZGV4IDdlZTQyMmUzODgyNi4uZmVhYTkwOWJmMTRmIDEwMDY0NA0KLS0tIGEvaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lm
Yy5oDQpAQCAtMzgyLDcgKzM4Miw4IEBAIHN0cnVjdCBtbHg1X2lmY19mbG93X3RhYmxlX3Byb3Bf
bGF5b3V0X2JpdHMgew0KIAl1OAkgICByZWZvcm1hdF9hbmRfbW9kaWZ5X2FjdGlvblsweDFdOw0K
IAl1OCAgICAgICAgIHJlc2VydmVkX2F0XzE1WzB4Ml07DQogCXU4CSAgIHRhYmxlX21pc3NfYWN0
aW9uX2RvbWFpblsweDFdOw0KLQl1OCAgICAgICAgIHJlc2VydmVkX2F0XzE4WzB4OF07DQorCXU4
ICAgICAgICAgdGVybWluYXRpb25fdGFibGVbMHgxXTsNCisJdTggICAgICAgICByZXNlcnZlZF9h
dF8xOVsweDddOw0KIAl1OCAgICAgICAgIHJlc2VydmVkX2F0XzIwWzB4Ml07DQogCXU4ICAgICAg
ICAgbG9nX21heF9mdF9zaXplWzB4Nl07DQogCXU4ICAgICAgICAgbG9nX21heF9tb2RpZnlfaGVh
ZGVyX2NvbnRleHRbMHg4XTsNCkBAIC03MjM5LDcgKzcyNDAsOCBAQCBzdHJ1Y3QgbWx4NV9pZmNf
Y3JlYXRlX2Zsb3dfdGFibGVfb3V0X2JpdHMgew0KIHN0cnVjdCBtbHg1X2lmY19mbG93X3RhYmxl
X2NvbnRleHRfYml0cyB7DQogCXU4ICAgICAgICAgcmVmb3JtYXRfZW5bMHgxXTsNCiAJdTggICAg
ICAgICBkZWNhcF9lblsweDFdOw0KLQl1OCAgICAgICAgIHJlc2VydmVkX2F0XzJbMHgyXTsNCisJ
dTggICAgICAgICByZXNlcnZlZF9hdF8yWzB4MV07DQorCXU4ICAgICAgICAgdGVybWluYXRpb25f
dGFibGVbMHgxXTsNCiAJdTggICAgICAgICB0YWJsZV9taXNzX2FjdGlvblsweDRdOw0KIAl1OCAg
ICAgICAgIGxldmVsWzB4OF07DQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMTBbMHg4XTsNCi0t
IA0KMi4yMS4wDQoNCg==
