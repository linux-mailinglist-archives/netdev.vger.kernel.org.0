Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F2A2E886
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE2Wu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:50:28 -0400
Received: from mail-eopbgr60052.outbound.protection.outlook.com ([40.107.6.52]:31619
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfE2Wu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSWTOq3MiGgyuS1zhM/cG6YnSq1/6HfJJO1HK5q7Gxk=;
 b=GPTt+BTvg/ftkBuiRBLG0Ylf/kVGpQXN0j4ooVmpQHL+a7T4hCbEIjX8+80ipnNYF0Hd1CnScjOR9w3ri230FAtygak8wFdidZkfc1YTIEWjQFyhNDhTuX/akFUwSachk7YndEgZh0rTPSx66vzDnXmb2RNinPDSHceNzWbH2Dc=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB4351.eurprd05.prod.outlook.com (52.133.12.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 22:50:24 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 22:50:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH mlx5-next 1/6] net/mlx5: Add core dump register access HW bits
Thread-Topic: [PATCH mlx5-next 1/6] net/mlx5: Add core dump register access HW
 bits
Thread-Index: AQHVFnDm/3adMQJ2VEq238zYN8bK6Q==
Date:   Wed, 29 May 2019 22:50:24 +0000
Message-ID: <20190529224949.18194-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 41d3303f-c7fa-4e3a-cd56-08d6e4880843
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4351;
x-ms-traffictypediagnostic: VI1PR05MB4351:
x-microsoft-antispam-prvs: <VI1PR05MB435197764719ACFE4CF6DF12BE1F0@VI1PR05MB4351.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(66446008)(73956011)(66946007)(64756008)(186003)(305945005)(76176011)(68736007)(66476007)(52116002)(107886003)(86362001)(1076003)(50226002)(4326008)(450100002)(66556008)(85306007)(6636002)(99286004)(54906003)(53936002)(102836004)(478600001)(6506007)(36756003)(8936002)(6512007)(8676002)(81156014)(110136005)(476003)(3846002)(6486002)(2616005)(256004)(26005)(5660300002)(6436002)(446003)(486006)(25786009)(2906002)(71200400001)(71190400001)(386003)(316002)(14444005)(6116002)(66066001)(11346002)(14454004)(7736002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4351;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bPM2PW+apY8zG57x7iFF4vEHsfC97kzeDGVrdZ+EEbgXxPJU4FepXLJuMvzl6ba59IBTE2b/7RjKHfVQSQ6vWKQQnN5on7udepNDsff5Bz/CwKFbc3GHgYKHVbWl4+N8HptE5OuSRO7uh7LLWyaQ/pyQRxy+LKFxHhTdh4krnoljBL3eMd+t8p6qK9Yu0R9Wo9pCO5KkmArxrz57H747UG45IjND2sXlTBIxfoloZOuTdG3L3+CKyc8MqcUfHlAHn+UF/7ahNRmzLdvtjQ59kHUcXeXm8ACVbFbj00nrhpg1TmVqJSresQ733PqIbJKdsVzb7CNYGiFcm+wPJzR195963wTV8TiDHSlHpS0TGxXjkP9AviMhuRke8GFng6AN/1zvMOLwf0fi9/dON6aKe+x0/atERhFK+djSrWP+/FA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d3303f-c7fa-4e3a-cd56-08d6e4880843
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 22:50:24.0621
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

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpBZGQgRmlybXdhcmUg
Y29yZSBkdW1wIHJlZ2lzdGVycyBhbmQgSFcgZGVmaW5pdGlvbnMuDQoNClNpZ25lZC1vZmYtYnk6
IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IEVyYW4g
QmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC9tbHg1L2Ry
aXZlci5oICAgfCAgMSArDQogaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggfCAxNyArKysr
KysrKysrKysrKysrLQ0KIDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oIGIvaW5j
bHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQppbmRleCA1YTI3MjQ2ZGI4ODMuLmI1NDMxZjdkOTdj
YiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KKysrIGIvaW5jbHVk
ZS9saW51eC9tbHg1L2RyaXZlci5oDQpAQCAtMTA3LDYgKzEwNyw3IEBAIGVudW0gew0KIAlNTFg1
X1JFR19GUEdBX0NBUAkgPSAweDQwMjIsDQogCU1MWDVfUkVHX0ZQR0FfQ1RSTAkgPSAweDQwMjMs
DQogCU1MWDVfUkVHX0ZQR0FfQUNDRVNTX1JFRyA9IDB4NDAyNCwNCisJTUxYNV9SRUdfQ09SRV9E
VU1QCSA9IDB4NDAyZSwNCiAJTUxYNV9SRUdfUENBUAkJID0gMHg1MDAxLA0KIAlNTFg1X1JFR19Q
TVRVCQkgPSAweDUwMDMsDQogCU1MWDVfUkVHX1BUWVMJCSA9IDB4NTAwNCwNCmRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1
X2lmYy5oDQppbmRleCA1ZTc0MzA1ZTJlNTcuLjdlZTQyMmUzODgyNiAxMDA2NDQNCi0tLSBhL2lu
Y2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oDQorKysgYi9pbmNsdWRlL2xpbnV4L21seDUvbWx4
NV9pZmMuaA0KQEAgLTcxNSw3ICs3MTUsOSBAQCBzdHJ1Y3QgbWx4NV9pZmNfcW9zX2NhcF9iaXRz
IHsNCiB9Ow0KIA0KIHN0cnVjdCBtbHg1X2lmY19kZWJ1Z19jYXBfYml0cyB7DQotCXU4ICAgICAg
ICAgcmVzZXJ2ZWRfYXRfMFsweDIwXTsNCisJdTggICAgICAgICBjb3JlX2R1bXBfZ2VuZXJhbFsw
eDFdOw0KKwl1OCAgICAgICAgIGNvcmVfZHVtcF9xcFsweDFdOw0KKwl1OCAgICAgICAgIHJlc2Vy
dmVkX2F0XzJbMHgxZV07DQogDQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMjBbMHgyXTsNCiAJ
dTggICAgICAgICBzdGFsbF9kZXRlY3RbMHgxXTsNCkBAIC0yNTMxLDYgKzI1MzMsNyBAQCB1bmlv
biBtbHg1X2lmY19oY2FfY2FwX3VuaW9uX2JpdHMgew0KIAlzdHJ1Y3QgbWx4NV9pZmNfZV9zd2l0
Y2hfY2FwX2JpdHMgZV9zd2l0Y2hfY2FwOw0KIAlzdHJ1Y3QgbWx4NV9pZmNfdmVjdG9yX2NhbGNf
Y2FwX2JpdHMgdmVjdG9yX2NhbGNfY2FwOw0KIAlzdHJ1Y3QgbWx4NV9pZmNfcW9zX2NhcF9iaXRz
IHFvc19jYXA7DQorCXN0cnVjdCBtbHg1X2lmY19kZWJ1Z19jYXBfYml0cyBkZWJ1Z19jYXA7DQog
CXN0cnVjdCBtbHg1X2lmY19mcGdhX2NhcF9iaXRzIGZwZ2FfY2FwOw0KIAl1OCAgICAgICAgIHJl
c2VydmVkX2F0XzBbMHg4MDAwXTsNCiB9Ow0KQEAgLTg1NDYsNiArODU0OSwxOCBAQCBzdHJ1Y3Qg
bWx4NV9pZmNfcWNhbV9yZWdfYml0cyB7DQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMWMwWzB4
ODBdOw0KIH07DQogDQorc3RydWN0IG1seDVfaWZjX2NvcmVfZHVtcF9yZWdfYml0cyB7DQorCXU4
ICAgICAgICAgcmVzZXJ2ZWRfYXRfMFsweDE4XTsNCisJdTggICAgICAgICBjb3JlX2R1bXBfdHlw
ZVsweDhdOw0KKw0KKwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzIwWzB4MzBdOw0KKwl1OCAgICAg
ICAgIHZoY2FfaWRbMHgxMF07DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNjBbMHg4XTsN
CisJdTggICAgICAgICBxcG5bMHgxOF07DQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfODBbMHgx
ODBdOw0KK307DQorDQogc3RydWN0IG1seDVfaWZjX3BjYXBfcmVnX2JpdHMgew0KIAl1OCAgICAg
ICAgIHJlc2VydmVkX2F0XzBbMHg4XTsNCiAJdTggICAgICAgICBsb2NhbF9wb3J0WzB4OF07DQot
LSANCjIuMjEuMA0KDQo=
