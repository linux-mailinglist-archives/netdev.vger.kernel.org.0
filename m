Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F45A70F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfF1Wgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:51 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727074AbfF1Wgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=yXERfPUn0uO6Y+EguzP8VmibOj8Rht3olIy42Cf/3lFejH6ILu97fTGa+GISUuMQfnXAO7v08ztHJaTkXgVusIKGOmvR+HWfc53FJx1hq5JuoyzVK+FfixVSH0esGQ+qjt+Zn3/YpV32gUtBoH2GBZVKt3ccpAXHxehN6Vot0Gs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSFZ5A8TZfI4dMYNG28NJ+MK2Q8sR1zCq+auD1Z1EQE=;
 b=Q3QgpntFOt9qI5/JVDCHahgOe3Nf7SM5tsB+1zagKBnhYOP/lm4JQvlOW+qB+5vKIc79xCCbIucTL7XkMqkczfAA5c/0c4e5YA5Zwjkr1j0lIZuFGsw+WjkVKd7eBmwG+c1/RfqCp8Z9sEe1xJ5T9ezIPF/nhRHaY9JzaUhX9iM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSFZ5A8TZfI4dMYNG28NJ+MK2Q8sR1zCq+auD1Z1EQE=;
 b=m1g3fgPFQpy2OaG4aoGUM1wrd+NEnx7w3Dn91fjmunVBY9t5VKcSXETeix1wJSUJ4BS6RE067b1h4syKjIUfNBnsxI00YDoQD1a+x6wTbChjJNwmKg8DgYC0b2D/Nqc8jsNgCHueTS0jQjkqOCVjbhvPaB/Quc7ADbha2bvQ8r8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:23 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>
Subject: [PATCH mlx5-next 18/18] net/mlx5: E-Switch, Handle UC address change
 in switchdev mode
Thread-Topic: [PATCH mlx5-next 18/18] net/mlx5: E-Switch, Handle UC address
 change in switchdev mode
Thread-Index: AQHVLgHq3WJ4LGI5dU6mL4Zjscg9Ig==
Date:   Fri, 28 Jun 2019 22:36:23 +0000
Message-ID: <20190628223516.9368-19-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e52a8292-a84e-4497-9b41-08d6fc190c5b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357831CC3D23130B54AF3FFBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LSxzV+EXcoP7mG5TYmiAoxyeBFt6jxIsnSrhc/4nGFYE7n+YO7cZSEUBizjYQXINzVRmu7LaS+e80SKmRMx0YZ2zd5Kjer+zylGQkP/HlV+/MGFhXbHV0nFwv7vnPWX8IjcMUcX+okjTUFW8DuIRJkRQFa1Yw4LAEsYIL4QwvSikNh8KoL35O6Qol+JJ+K/Qkfs9mt+zfczmGVdrlMOd3t07jX2020I2Wsqh0REvweErs//QOuEJPq3G33EM7zkcwgvvHPCYFN4rvgYmQa2In+g7M5XqkGimZYoCH4nbNCUg741IMEnpq2AvqSYAlUHxAOHWi/p/6FfuLKlDXDpyAPbVJpbKb1LB12ElrQJMeSa+tS3Q8ffQia2XVdLWeogLBnViaClvbwkjUDx1K62Oj6z7A+uhCFByL4bURnIZIZg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52a8292-a84e-4497-9b41-08d6fc190c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:23.3768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCldoZW4gTlZNRSBkZXZp
Y2UgZW11bGF0aW9uIG1vZGUgaXMgZW5hYmxlZCwgbW9yZSB0aGFuIG9uZSBQRnMgdXNlIHRoZQ0K
c2FtZSBwaHlzaWNhbCBwb3J0LiBJbiB0aGlzIGNhc2UsIE1QRlMgaXMgcmVxdWlyZWQgdG8gcHJv
Z3JhbSBMMg0KYWRkcmVzc2VzLg0KDQpJdCB1c2VkIHRvIHJlbHkgb24gbmV0ZGV2IHNldF9yeF9t
b2RlIGluIHN3aXRjaGRldiBtb2RlLCBidXQgZHJpdmVyDQpsYXRlciBjaGFuZ2VkIHRvIG5vdCBj
cmVhdGUgbmV0ZGV2IGZvciBlc3dpdGNoIG1hbmFnZXIgb25jZSBpbg0Kc3dpdGNoZGV2IG1vZGUu
IFNvLCBVQyBhZGRyZXNzIGV2ZW50IHNob3VsZCBiZSBoYW5kbGVkLg0KDQpTaWduZWQtb2ZmLWJ5
OiBCb2RvbmcgV2FuZyA8Ym9kb25nQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jIHwgMjEgKysrKysrKystLS0tLS0tLS0tLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCmluZGV4
IDkzNWI5NDI5YmIyYS4uODlmNTIzNzBlNzcwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KQEAgLTE3MjcsMTAgKzE3MjcsMTAg
QEAgaW50IG1seDVfZXN3X3F1ZXJ5X2Z1bmN0aW9ucyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
LCB1MzIgKm91dCwgaW50IG91dGxlbikNCiANCiBzdGF0aWMgdm9pZCBtbHg1X2Vzd2l0Y2hfZXZl
bnRfaGFuZGxlcnNfcmVnaXN0ZXIoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIHsNCi0JaWYg
KGVzdy0+bW9kZSA9PSBNTFg1X0VTV0lUQ0hfTEVHQUNZKSB7DQotCQlNTFg1X05CX0lOSVQoJmVz
dy0+bmIsIGVzd2l0Y2hfdnBvcnRfZXZlbnQsIE5JQ19WUE9SVF9DSEFOR0UpOw0KLQkJbWx4NV9l
cV9ub3RpZmllcl9yZWdpc3Rlcihlc3ctPmRldiwgJmVzdy0+bmIpOw0KLQl9IGVsc2UgaWYgKG1s
eDVfZXN3aXRjaF9pc19mdW5jc19oYW5kbGVyKGVzdy0+ZGV2KSkgew0KKwlNTFg1X05CX0lOSVQo
JmVzdy0+bmIsIGVzd2l0Y2hfdnBvcnRfZXZlbnQsIE5JQ19WUE9SVF9DSEFOR0UpOw0KKwltbHg1
X2VxX25vdGlmaWVyX3JlZ2lzdGVyKGVzdy0+ZGV2LCAmZXN3LT5uYik7DQorDQorCWlmIChlc3ct
Pm1vZGUgPT0gTUxYNV9FU1dJVENIX09GRkxPQURTICYmIG1seDVfZXN3aXRjaF9pc19mdW5jc19o
YW5kbGVyKGVzdy0+ZGV2KSkgew0KIAkJTUxYNV9OQl9JTklUKCZlc3ctPmVzd19mdW5jcy5uYiwg
bWx4NV9lc3dfZnVuY3NfY2hhbmdlZF9oYW5kbGVyLA0KIAkJCSAgICAgRVNXX0ZVTkNUSU9OU19D
SEFOR0VEKTsNCiAJCW1seDVfZXFfbm90aWZpZXJfcmVnaXN0ZXIoZXN3LT5kZXYsICZlc3ctPmVz
d19mdW5jcy5uYik7DQpAQCAtMTczOSwxMSArMTczOSwxMSBAQCBzdGF0aWMgdm9pZCBtbHg1X2Vz
d2l0Y2hfZXZlbnRfaGFuZGxlcnNfcmVnaXN0ZXIoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0K
IA0KIHN0YXRpYyB2b2lkIG1seDVfZXN3aXRjaF9ldmVudF9oYW5kbGVyc191bnJlZ2lzdGVyKHN0
cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCiB7DQotCWlmIChlc3ctPm1vZGUgPT0gTUxYNV9FU1dJ
VENIX0xFR0FDWSkNCi0JCW1seDVfZXFfbm90aWZpZXJfdW5yZWdpc3Rlcihlc3ctPmRldiwgJmVz
dy0+bmIpOw0KLQllbHNlIGlmIChtbHg1X2Vzd2l0Y2hfaXNfZnVuY3NfaGFuZGxlcihlc3ctPmRl
dikpDQorCWlmIChlc3ctPm1vZGUgPT0gTUxYNV9FU1dJVENIX09GRkxPQURTICYmIG1seDVfZXN3
aXRjaF9pc19mdW5jc19oYW5kbGVyKGVzdy0+ZGV2KSkNCiAJCW1seDVfZXFfbm90aWZpZXJfdW5y
ZWdpc3Rlcihlc3ctPmRldiwgJmVzdy0+ZXN3X2Z1bmNzLm5iKTsNCiANCisJbWx4NV9lcV9ub3Rp
Zmllcl91bnJlZ2lzdGVyKGVzdy0+ZGV2LCAmZXN3LT5uYik7DQorDQogCWZsdXNoX3dvcmtxdWV1
ZShlc3ctPndvcmtfcXVldWUpOw0KIH0NCiANCkBAIC0xNzg5LDExICsxNzg5LDggQEAgaW50IG1s
eDVfZXN3aXRjaF9lbmFibGUoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LCBpbnQgbW9kZSkNCiAJ
aWYgKGVycikNCiAJCWVzd193YXJuKGVzdy0+ZGV2LCAiRmFpbGVkIHRvIGNyZWF0ZSBlc3dpdGNo
IFRTQVIiKTsNCiANCi0JLyogRG9uJ3QgZW5hYmxlIHZwb3J0IGV2ZW50cyB3aGVuIGluIE1MWDVf
RVNXSVRDSF9PRkZMT0FEUyBtb2RlLCBzaW5jZToNCi0JICogMS4gTDIgdGFibGUgKE1QRlMpIGlz
IHByb2dyYW1tZWQgYnkgUEYvVkYgcmVwcmVzZW50b3JzIG5ldGRldnMgc2V0X3J4X21vZGUNCi0J
ICogMi4gRkRCL0Vzd2l0Y2ggaXMgcHJvZ3JhbW1lZCBieSB1c2VyIHNwYWNlIHRvb2xzDQotCSAq
Lw0KLQllbmFibGVkX2V2ZW50cyA9IChtb2RlID09IE1MWDVfRVNXSVRDSF9MRUdBQ1kpID8gU1JJ
T1ZfVlBPUlRfRVZFTlRTIDogMDsNCisJZW5hYmxlZF9ldmVudHMgPSAobW9kZSA9PSBNTFg1X0VT
V0lUQ0hfTEVHQUNZKSA/IFNSSU9WX1ZQT1JUX0VWRU5UUyA6DQorCQlVQ19BRERSX0NIQU5HRTsN
CiANCiAJLyogRW5hYmxlIFBGIHZwb3J0ICovDQogCXZwb3J0ID0gbWx4NV9lc3dpdGNoX2dldF92
cG9ydChlc3csIE1MWDVfVlBPUlRfUEYpOw0KLS0gDQoyLjIxLjANCg0K
