Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D351955642
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbfFYRsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:22 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:51759
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732667AbfFYRsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms40BfLt5wTrFmvttRwXj9RhnZHNYJdRMorRxHiQFwA=;
 b=skpihQNKUpCkZ5OIk+C7uJvkX2VSedIxnLa7jmSWmPgBkrsDmC/CfYHzPUVoRguiFv9LFDr2RsKTMP7fl/OpUxdq2m83loQ/7c9x7uBh2qGEvzUKPE8UPAPtOEim5Q4BdTwjrY0LsRGci2ZE13zzUagqXYUDvGaQWQP6y1Q77Xg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:48:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:48:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 12/13] RDMA/mlx5: Add vport metadata matching for
 IB representors
Thread-Topic: [PATCH V2 mlx5-next 12/13] RDMA/mlx5: Add vport metadata
 matching for IB representors
Thread-Index: AQHVK34oySKsDuAVWUaAYG3rwwbDgQ==
Date:   Tue, 25 Jun 2019 17:48:12 +0000
Message-ID: <20190625174727.20309-13-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 130f3b60-ddca-488a-06dd-08d6f9954ab7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB2216705C12F6992EBDB3FDF0BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 72RhMHZTcHizv4KRetn/63Hv6tfFdLLwIQfAWnY8uVErtJFltr4/NkuzVYm92zT8qR9dFSoJxOPX6vWfxM7tVQA3gJS60B+paWC9uKcrtdmd5zA0G8PRNBN3YWNpHgE+vAqP6cagQfaKoTCSDe8S4ePK5ehSHQp9MjXgPJ4vSbUE1jGWQUiEQvhQlapwk1mGfZ3aA+J+gV3sk2T0oHLjmngyfYYYFv71amFnOSY2o8meGd2iE0VUM8qkDNttqW/v7i2TQtzB6Yyyja0WX8wCMmW8UKecQbUoUMIIu5UdmxgTmT02j/3vwawc63CPK7fmX+0PGuoAv36no6jj3gSNMrzIF4CPDgG2fXkDA/gpc6AkZOdvwSNVz1FuW2k8at3eQEANpOn31jEz2gdJj8YLhLjGBOHcWMv2f/Jgneyjhvw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130f3b60-ddca-488a-06dd-08d6f9954ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:48:12.2449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCklmIHZwb3J0IG1ldGFk
YXRhIG1hdGNoaW5nIGlzIGVuYWJsZWQgaW4gZXN3aXRjaCwgdGhlIHJ1bGUgY3JlYXRlZA0KbXVz
dCBiZSBjaGFuZ2VkIHRvIG1hdGNoIG9uIHRoZSBtZXRhZGF0YSwgaW5zdGVhZCBvZiBzb3VyY2Ug
cG9ydC4NCg0KU2lnbmVkLW9mZi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+
DQpSZXZpZXdlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5
OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBN
YWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9o
dy9tbHg1L21haW4uYyB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCiAxIGZp
bGUgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4uYyBiL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9tbHg1L21haW4uYw0KaW5kZXggYmU0YzlhNjg3ZGY3Li42MDJhYzNmZWVhNWQgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMNCisrKyBiL2RyaXZlcnMv
aW5maW5pYmFuZC9ody9tbHg1L21haW4uYw0KQEAgLTM0NjksNiArMzQ2OSwzNyBAQCBzdGF0aWMg
aW50IGZsb3dfY291bnRlcnNfc2V0X2RhdGEoc3RydWN0IGliX2NvdW50ZXJzICppYmNvdW50ZXJz
LA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgdm9pZCBtbHg1X2liX3NldF9ydWxlX3Nv
dXJjZV9wb3J0KHN0cnVjdCBtbHg1X2liX2RldiAqZGV2LA0KKwkJCQkJIHN0cnVjdCBtbHg1X2Zs
b3dfc3BlYyAqc3BlYywNCisJCQkJCSBzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCAqcmVwKQ0KK3sN
CisJc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3ID0gZGV2LT5tZGV2LT5wcml2LmVzd2l0Y2g7DQor
CXZvaWQgKm1pc2M7DQorDQorCWlmIChtbHg1X2Vzd2l0Y2hfdnBvcnRfbWF0Y2hfbWV0YWRhdGFf
ZW5hYmxlZChlc3cpKSB7DQorCQltaXNjID0gTUxYNV9BRERSX09GKGZ0ZV9tYXRjaF9wYXJhbSwg
c3BlYy0+bWF0Y2hfdmFsdWUsDQorCQkJCSAgICBtaXNjX3BhcmFtZXRlcnNfMik7DQorDQorCQlN
TFg1X1NFVChmdGVfbWF0Y2hfc2V0X21pc2MyLCBtaXNjLCBtZXRhZGF0YV9yZWdfY18wLA0KKwkJ
CSBtbHg1X2Vzd2l0Y2hfZ2V0X3Zwb3J0X21ldGFkYXRhX2Zvcl9tYXRjaChlc3csDQorCQkJCQkJ
CQkgICByZXAtPnZwb3J0KSk7DQorCQltaXNjID0gTUxYNV9BRERSX09GKGZ0ZV9tYXRjaF9wYXJh
bSwgc3BlYy0+bWF0Y2hfY3JpdGVyaWEsDQorCQkJCSAgICBtaXNjX3BhcmFtZXRlcnNfMik7DQor
DQorCQlNTFg1X1NFVF9UT19PTkVTKGZ0ZV9tYXRjaF9zZXRfbWlzYzIsIG1pc2MsIG1ldGFkYXRh
X3JlZ19jXzApOw0KKwl9IGVsc2Ugew0KKwkJbWlzYyA9IE1MWDVfQUREUl9PRihmdGVfbWF0Y2hf
cGFyYW0sIHNwZWMtPm1hdGNoX3ZhbHVlLA0KKwkJCQkgICAgbWlzY19wYXJhbWV0ZXJzKTsNCisN
CisJCU1MWDVfU0VUKGZ0ZV9tYXRjaF9zZXRfbWlzYywgbWlzYywgc291cmNlX3BvcnQsIHJlcC0+
dnBvcnQpOw0KKw0KKwkJbWlzYyA9IE1MWDVfQUREUl9PRihmdGVfbWF0Y2hfcGFyYW0sIHNwZWMt
Pm1hdGNoX2NyaXRlcmlhLA0KKwkJCQkgICAgbWlzY19wYXJhbWV0ZXJzKTsNCisNCisJCU1MWDVf
U0VUX1RPX09ORVMoZnRlX21hdGNoX3NldF9taXNjLCBtaXNjLCBzb3VyY2VfcG9ydCk7DQorCX0N
Cit9DQorDQogc3RhdGljIHN0cnVjdCBtbHg1X2liX2Zsb3dfaGFuZGxlciAqX2NyZWF0ZV9mbG93
X3J1bGUoc3RydWN0IG1seDVfaWJfZGV2ICpkZXYsDQogCQkJCQkJICAgICAgc3RydWN0IG1seDVf
aWJfZmxvd19wcmlvICpmdF9wcmlvLA0KIAkJCQkJCSAgICAgIGNvbnN0IHN0cnVjdCBpYl9mbG93
X2F0dHIgKmZsb3dfYXR0ciwNCkBAIC0zNTIzLDE5ICszNTU0LDE1IEBAIHN0YXRpYyBzdHJ1Y3Qg
bWx4NV9pYl9mbG93X2hhbmRsZXIgKl9jcmVhdGVfZmxvd19ydWxlKHN0cnVjdCBtbHg1X2liX2Rl
diAqZGV2LA0KIAkJc2V0X3VuZGVybGF5X3FwKGRldiwgc3BlYywgdW5kZXJsYXlfcXBuKTsNCiAN
CiAJaWYgKGRldi0+aXNfcmVwKSB7DQotCQl2b2lkICptaXNjOw0KKwkJc3RydWN0IG1seDVfZXN3
aXRjaF9yZXAgKnJlcDsNCiANCi0JCWlmICghZGV2LT5wb3J0W2Zsb3dfYXR0ci0+cG9ydCAtIDFd
LnJlcCkgew0KKwkJcmVwID0gZGV2LT5wb3J0W2Zsb3dfYXR0ci0+cG9ydCAtIDFdLnJlcDsNCisJ
CWlmICghcmVwKSB7DQogCQkJZXJyID0gLUVJTlZBTDsNCiAJCQlnb3RvIGZyZWU7DQogCQl9DQot
CQltaXNjID0gTUxYNV9BRERSX09GKGZ0ZV9tYXRjaF9wYXJhbSwgc3BlYy0+bWF0Y2hfdmFsdWUs
DQotCQkJCSAgICBtaXNjX3BhcmFtZXRlcnMpOw0KLQkJTUxYNV9TRVQoZnRlX21hdGNoX3NldF9t
aXNjLCBtaXNjLCBzb3VyY2VfcG9ydCwNCi0JCQkgZGV2LT5wb3J0W2Zsb3dfYXR0ci0+cG9ydCAt
IDFdLnJlcC0+dnBvcnQpOw0KLQkJbWlzYyA9IE1MWDVfQUREUl9PRihmdGVfbWF0Y2hfcGFyYW0s
IHNwZWMtPm1hdGNoX2NyaXRlcmlhLA0KLQkJCQkgICAgbWlzY19wYXJhbWV0ZXJzKTsNCi0JCU1M
WDVfU0VUX1RPX09ORVMoZnRlX21hdGNoX3NldF9taXNjLCBtaXNjLCBzb3VyY2VfcG9ydCk7DQor
DQorCQltbHg1X2liX3NldF9ydWxlX3NvdXJjZV9wb3J0KGRldiwgc3BlYywgcmVwKTsNCiAJfQ0K
IA0KIAlzcGVjLT5tYXRjaF9jcml0ZXJpYV9lbmFibGUgPSBnZXRfbWF0Y2hfY3JpdGVyaWFfZW5h
YmxlKHNwZWMtPm1hdGNoX2NyaXRlcmlhKTsNCi0tIA0KMi4yMS4wDQoNCg==
