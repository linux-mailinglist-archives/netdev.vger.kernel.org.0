Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C145A6EE
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF1Wf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:35:57 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfF1Wf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:35:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=ry9E9R5lb6zBF+iMZhx0Y2MJ5j90lpjBP2o0IhVZgMx81YvRK9CScOO84a8X0mJ69uLHkzdPNZ3TD5I9uqQ3VAeyTDPt4yOkSmBOBaAueLCxby0CHLn8Xp2NmJjDWxrSfVl+OgsCdkNu0SL0utjvwM32Hl6sMQVy18LSWtSKKtU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDZng6uNSFVzsvGxDTER46RkOklXnA15mABEw0CRvns=;
 b=eWNCtIT255J2ANDRWcSjPRPkP+RRrN5/46izwrPvnp4GXUeyIZnXrecQMmcbBe3jlgarJVX3OWoBVMlyfEuz/yJKHlUIobEdxjTqJyoYlvpq15Bbj/1wCdNRGQ9lvPvHXk2hO7yfNS8tB8mCLpSZpWCYP5aJrA68uaT5ppVJ5MA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDZng6uNSFVzsvGxDTER46RkOklXnA15mABEw0CRvns=;
 b=Lxxrw29xNKvT1KnmAWoc3tS3COGdmJbpCaIszOMGo0wjsTvrj9jr2L+SgMrKu45NhLw0D7fKVprMgPQ34wTJF51ILNMuyhuicZnVk4hsQcW2U1wNhI5SX/WPyUxmtHUQxn1+MZTF/VdM26ndqIoKruOOlI7Deb6OtWeeNqU0qAM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:48 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 01/18] net/mlx5: Add hardware definitions for sub
 functions
Thread-Topic: [PATCH mlx5-next 01/18] net/mlx5: Add hardware definitions for
 sub functions
Thread-Index: AQHVLgHV4L+zG2pxwU6s1isNuIBmyQ==
Date:   Fri, 28 Jun 2019 22:35:48 +0000
Message-ID: <20190628223516.9368-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e3506cd6-a931-4237-a6a2-08d6fc18f775
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB23571E3D7AE29F7C2821ABD6BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Yb15utSBFf8FnoAEI5+qq3+DUu2pPbFuspnGwe1Z0FzwG5Y0KgJY6WRCjsV9kin7wTFYlS7/PgYR/j5W07JnadDXy5C6H7hHIKtAIA2/CkUxnM+dERnBODdslv6HVivtP+wc0kua9WNVbEFaEzEGVbiPsVDyFERkgpljDJyzLVEhP+iM8H3OekUW92bW+XhnzuvD+teDTsQRPWWnQCVhub8ikQyXh76MvmlHUCrUrlfKKRmOkCXes3wqOCP+46adcFlPnUzgq8w9jKEn365w28HWPjtb/YmhPT7IQmAiXvtuIsTsboRVl89IvljkDfyskx3Ry4u4xuWCVlH5ImnhtFmhL0zcIAq67tX+HO/ZNgDj7cMrp7xHLMikPieQuxko0tox64MbDct9kduGRJLB4pIiBGXwcBwZgIsnFH3z78w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3506cd6-a931-4237-a6a2-08d6fc18f775
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:48.6856
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

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNClVwZGF0ZSBtbHg1IGRl
dmljZSBpbnRlcmZhY2UgZGF0YSBzdHJ1Y3R1cmVzIGZvcjoNCjEuIE5ldyBjb21tYW5kIGRlZmlu
aXRpb25zIGZvciBhbGxvY2F0aW5nLCBkZWFsbG9jYXRpbmcgU0YNCjIuIFF1ZXJ5IFNGIHBhcnRp
dGlvbg0KMy4gRXN3aXRjaCBTRiBmaWVsZHMNCjQuIEhDQSBDQVAgU0YgZmllbGRzDQo1LiBFeHRl
bmQgRXN3aXRjaCBmdW5jdGlvbnMgY29tbWFuZCBmb3IgU0YNCg0KU2lnbmVkLW9mZi1ieTogUGFy
YXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBWdSBQaGFtIDx2
dWh1b25nQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggfCA5
OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCA5
NiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aW51eC9tbHg1L21seDVfaWZjLmggYi9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KaW5k
ZXggZDQ0MDk2NTRmNzYwLi5kYjAwZWZmYWE4M2EgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L21seDUvbWx4NV9pZmMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCkBA
IC0xMDYsNiArMTA2LDkgQEAgZW51bSB7DQogCU1MWDVfQ01EX09QX1FVRVJZX0lTU0kgICAgICAg
ICAgICAgICAgICAgID0gMHgxMGEsDQogCU1MWDVfQ01EX09QX1NFVF9JU1NJICAgICAgICAgICAg
ICAgICAgICAgID0gMHgxMGIsDQogCU1MWDVfQ01EX09QX1NFVF9EUklWRVJfVkVSU0lPTiAgICAg
ICAgICAgID0gMHgxMGQsDQorCU1MWDVfQ01EX09QX1FVRVJZX1NGX1BBUlRJVElPTiAgICAgICAg
ICAgID0gMHgxMTEsDQorCU1MWDVfQ01EX09QX0FMTE9DX1NGICAgICAgICAgICAgICAgICAgICAg
ID0gMHgxMTMsDQorCU1MWDVfQ01EX09QX0RFQUxMT0NfU0YgICAgICAgICAgICAgICAgICAgID0g
MHgxMTQsDQogCU1MWDVfQ01EX09QX0NSRUFURV9NS0VZICAgICAgICAgICAgICAgICAgID0gMHgy
MDAsDQogCU1MWDVfQ01EX09QX1FVRVJZX01LRVkgICAgICAgICAgICAgICAgICAgID0gMHgyMDEs
DQogCU1MWDVfQ01EX09QX0RFU1RST1lfTUtFWSAgICAgICAgICAgICAgICAgID0gMHgyMDIsDQpA
QCAtNzEzLDcgKzcxNiwxMSBAQCBzdHJ1Y3QgbWx4NV9pZmNfZV9zd2l0Y2hfY2FwX2JpdHMgew0K
IAl1OCAgICAgICAgIHJlc2VydmVkXzJiWzB4Nl07DQogCXU4ICAgICAgICAgbWF4X2VuY2FwX2hl
YWRlcl9zaXplWzB4YV07DQogDQotCXU4ICAgICAgICAgcmVzZXJ2ZWRfNDBbMHg3YzBdOw0KKwl1
OCAgICAgICAgIHJlc2VydmVkX2F0XzQwWzB4Yl07DQorCXU4ICAgICAgICAgbG9nX21heF9lc3df
c2ZbMHg1XTsNCisJdTggICAgICAgICBlc3dfc2ZfYmFzZV9pZFsweDEwXTsNCisNCisJdTggICAg
ICAgICByZXNlcnZlZF9hdF82MFsweDdhMF07DQogDQogfTsNCiANCkBAIC0xMzMwLDEzICsxMzM3
LDI0IEBAIHN0cnVjdCBtbHg1X2lmY19jbWRfaGNhX2NhcF9iaXRzIHsNCiAJdTggICAgICAgICBy
ZXNlcnZlZF9hdF82NDBbMHgxMF07DQogCXU4ICAgICAgICAgbnVtX3FfbW9uaXRvcl9jb3VudGVy
c1sweDEwXTsNCiANCi0JdTggICAgICAgICByZXNlcnZlZF9hdF82NjBbMHg0MF07DQorCXU4ICAg
ICAgICAgcmVzZXJ2ZWRfYXRfNjYwWzB4MjBdOw0KKw0KKwl1OCAgICAgICAgIHNmWzB4MV07DQor
CXU4ICAgICAgICAgc2Zfc2V0X3BhcnRpdGlvblsweDFdOw0KKwl1OCAgICAgICAgIHJlc2VydmVk
X2F0XzY4MlsweDFdOw0KKwl1OCAgICAgICAgIGxvZ19tYXhfc2ZbMHg1XTsNCisJdTggICAgICAg
ICByZXNlcnZlZF9hdF82ODhbMHg4XTsNCisJdTggICAgICAgICBsb2dfbWluX3NmX3NpemVbMHg4
XTsNCisJdTggICAgICAgICBtYXhfbnVtX3NmX3BhcnRpdGlvbnNbMHg4XTsNCiANCiAJdTggICAg
ICAgICB1Y3R4X2NhcFsweDIwXTsNCiANCiAJdTggICAgICAgICByZXNlcnZlZF9hdF82YzBbMHg0
XTsNCiAJdTggICAgICAgICBmbGV4X3BhcnNlcl9pZF9nZW5ldmVfdGx2X29wdGlvbl8wWzB4NF07
DQotCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNmM4WzB4MTM4XTsNCisJdTgJICAgcmVzZXJ2ZWRf
YXRfNmM4WzB4MjhdOw0KKwl1OAkgICBzZl9iYXNlX2lkWzB4MTBdOw0KKw0KKwl1OAkgICByZXNl
cnZlZF9hdF83MDBbMHgxMDBdOw0KIH07DQogDQogZW51bSBtbHg1X2Zsb3dfZGVzdGluYXRpb25f
dHlwZSB7DQpAQCAtOTc4Niw2ICs5ODA0LDgxIEBAIHN0cnVjdCBtbHg1X2lmY19xdWVyeV9lc3df
ZnVuY3Rpb25zX291dF9iaXRzIHsNCiAJc3RydWN0IG1seDVfaWZjX2hvc3RfcGFyYW1zX2NvbnRl
eHRfYml0cyBob3N0X3BhcmFtc19jb250ZXh0Ow0KIA0KIAl1OCAgICAgICAgIHJlc2VydmVkX2F0
XzI4MFsweDE4MF07DQorCXU4ICAgICAgICAgaG9zdF9zZl9lbmFibGVbMF1bMHg0MF07DQorfTsN
CisNCitzdHJ1Y3QgbWx4NV9pZmNfc2ZfcGFydGl0aW9uX2JpdHMgew0KKwl1OCAgICAgICAgIHJl
c2VydmVkX2F0XzBbMHgxMF07DQorCXU4ICAgICAgICAgbG9nX251bV9zZlsweDhdOw0KKwl1OCAg
ICAgICAgIGxvZ19zZl9iYXJfc2l6ZVsweDhdOw0KK307DQorDQorc3RydWN0IG1seDVfaWZjX3F1
ZXJ5X3NmX3BhcnRpdGlvbnNfb3V0X2JpdHMgew0KKwl1OCAgICAgICAgIHN0YXR1c1sweDhdOw0K
Kwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzhbMHgxOF07DQorDQorCXU4ICAgICAgICAgc3luZHJv
bWVbMHgyMF07DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNDBbMHgxOF07DQorCXU4ICAg
ICAgICAgbnVtX3NmX3BhcnRpdGlvbnNbMHg4XTsNCisNCisJdTggICAgICAgICByZXNlcnZlZF9h
dF82MFsweDIwXTsNCisNCisJc3RydWN0IG1seDVfaWZjX3NmX3BhcnRpdGlvbl9iaXRzIHNmX3Bh
cnRpdGlvblswXTsNCit9Ow0KKw0KK3N0cnVjdCBtbHg1X2lmY19xdWVyeV9zZl9wYXJ0aXRpb25z
X2luX2JpdHMgew0KKwl1OCAgICAgICAgIG9wY29kZVsweDEwXTsNCisJdTggICAgICAgICByZXNl
cnZlZF9hdF8xMFsweDEwXTsNCisNCisJdTggICAgICAgICByZXNlcnZlZF9hdF8yMFsweDEwXTsN
CisJdTggICAgICAgICBvcF9tb2RbMHgxMF07DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRf
NDBbMHg0MF07DQorfTsNCisNCitzdHJ1Y3QgbWx4NV9pZmNfZGVhbGxvY19zZl9vdXRfYml0cyB7
DQorCXU4ICAgICAgICAgc3RhdHVzWzB4OF07DQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfOFsw
eDE4XTsNCisNCisJdTggICAgICAgICBzeW5kcm9tZVsweDIwXTsNCisNCisJdTggICAgICAgICBy
ZXNlcnZlZF9hdF80MFsweDQwXTsNCit9Ow0KKw0KK3N0cnVjdCBtbHg1X2lmY19kZWFsbG9jX3Nm
X2luX2JpdHMgew0KKwl1OCAgICAgICAgIG9wY29kZVsweDEwXTsNCisJdTggICAgICAgICByZXNl
cnZlZF9hdF8xMFsweDEwXTsNCisNCisJdTggICAgICAgICByZXNlcnZlZF9hdF8yMFsweDEwXTsN
CisJdTggICAgICAgICBvcF9tb2RbMHgxMF07DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRf
NDBbMHgxMF07DQorCXU4ICAgICAgICAgZnVuY3Rpb25faWRbMHgxMF07DQorDQorCXU4ICAgICAg
ICAgcmVzZXJ2ZWRfYXRfNjBbMHgyMF07DQorfTsNCisNCitzdHJ1Y3QgbWx4NV9pZmNfYWxsb2Nf
c2Zfb3V0X2JpdHMgew0KKwl1OCAgICAgICAgIHN0YXR1c1sweDhdOw0KKwl1OCAgICAgICAgIHJl
c2VydmVkX2F0XzhbMHgxOF07DQorDQorCXU4ICAgICAgICAgc3luZHJvbWVbMHgyMF07DQorDQor
CXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNDBbMHg0MF07DQorfTsNCisNCitzdHJ1Y3QgbWx4NV9p
ZmNfYWxsb2Nfc2ZfaW5fYml0cyB7DQorCXU4ICAgICAgICAgb3Bjb2RlWzB4MTBdOw0KKwl1OCAg
ICAgICAgIHJlc2VydmVkX2F0XzEwWzB4MTBdOw0KKw0KKwl1OCAgICAgICAgIHJlc2VydmVkX2F0
XzIwWzB4MTBdOw0KKwl1OCAgICAgICAgIG9wX21vZFsweDEwXTsNCisNCisJdTggICAgICAgICBy
ZXNlcnZlZF9hdF80MFsweDEwXTsNCisJdTggICAgICAgICBmdW5jdGlvbl9pZFsweDEwXTsNCisN
CisJdTggICAgICAgICByZXNlcnZlZF9hdF82MFsweDIwXTsNCiB9Ow0KIA0KICNlbmRpZiAvKiBN
TFg1X0lGQ19IICovDQotLSANCjIuMjEuMA0KDQo=
