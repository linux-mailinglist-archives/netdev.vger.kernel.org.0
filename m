Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3787A55985
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfFYU5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:57:52 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:20873
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbfFYU5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:57:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=X5gGf3mxj6j0pFPrs/VJ+vh8THAQfXVRg0BqPuFsSjj/mNv5blg7tMOg7/7pjfjNHZoGOj8cFWVkftHzYergX6kzlWby1DxXsIlsn9eSFRMLbT7BzVuOESI/JFEvoZP1Ogf5dHbozJ1Nqz/sb4ZuJQMzsDoEcz5EfRKkW0/X1JE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwP8kka38PxEGJJ6FcsgYbg1157HOpmFsbx6RT1P0PA=;
 b=vDET05alZ/W8SX2aa9szqM+9pRcm1GghXVtqyg76v1S/uEB9PQRU58uy15CoCYFG1TxbWATEYDb/XAXOMQM1bqFuXr5utDvB6vLke+497smAfQnW+udMSSd1ByQNuq7ZHS/JaWpYwolS/D+bNw5BPGg1WSZlXJZTw5LLER/hx9c=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwP8kka38PxEGJJ6FcsgYbg1157HOpmFsbx6RT1P0PA=;
 b=J5wMeFQLDvPC4LSeyme8TuGZ4KvONCpZ0ahlHaft3UuuCJcNQDHlv4UuBE6nxgJ2QoCF7sA0SQZT0OLl3qtrUz0CCkMvgmTn6n9jv6m1lSNX50zdGxMmkbjR4+FXnrsLJhyy0hJoX71dcFVgQ0CsLbA+DeTT25ZQBoD+nFBAIqQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2696.eurprd05.prod.outlook.com (10.172.225.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 20:57:38 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 20:57:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V2 04/10] linux/dim: Rename net_dim_sample() to
 net_dim_update_sample()
Thread-Topic: [for-next V2 04/10] linux/dim: Rename net_dim_sample() to
 net_dim_update_sample()
Thread-Index: AQHVK5ifnBb8A8YgVki6AwGobVlNVA==
Date:   Tue, 25 Jun 2019 20:57:38 +0000
Message-ID: <20190625205701.17849-5-saeedm@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
In-Reply-To: <20190625205701.17849-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 288fc102-a9e1-4618-a5a5-08d6f9afc149
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2696;
x-ms-traffictypediagnostic: DB6PR0501MB2696:
x-microsoft-antispam-prvs: <DB6PR0501MB2696CE165EB316928E342C65BEE30@DB6PR0501MB2696.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:230;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(6512007)(66476007)(186003)(86362001)(305945005)(3846002)(26005)(6116002)(68736007)(7736002)(102836004)(50226002)(99286004)(14444005)(53936002)(6636002)(76176011)(1076003)(2906002)(5660300002)(6436002)(64756008)(14454004)(66556008)(25786009)(486006)(52116002)(73956011)(71190400001)(6486002)(6506007)(11346002)(81166006)(71200400001)(446003)(386003)(66946007)(256004)(81156014)(66446008)(478600001)(4326008)(66066001)(8676002)(107886003)(2616005)(36756003)(316002)(476003)(8936002)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2696;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iNjksdF2Ti7mJSpwdnhlUtYP511Kn6Q7PuWrWp7t9i291hIt9kdC/KAMuRyzU2auC/o2wznFU4F1ovdH/pIPD5Bo1wNivIkn+rq9IVR56is+hrWvGHq3HivvOqA0y6i00Pxj4s1HwUZbx7IuzF2+oIQ6ALnH1125F+k33cDAibTVE+uEx44z2o/xlV7oy/Y5jjiyEJtDpnabqXZNI15eP1TBQLjXVi1nMNbONwKgKtFJXZ/L1c9xt/yOCMLvBtgoRJVxa7Mn5J+cda1ZjmzZmZTcYNS4ceHWTwNDdfxKV5h0jb8sNlUGIUl3fD18JCwrdITtGRBfhvmxIs0xmry8bKsNnFKt7HIUoGbnnho9Ne+D/PaURuuBRkL6RROFkhIllErrXa695RUGcDKrOimD9c8nxC0wah6nvz3GLa5nONk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288fc102-a9e1-4618-a5a5-08d6f9afc149
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 20:57:38.0629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFsIEdpbGJvYSA8dGFsZ2lAbWVsbGFub3guY29tPg0KDQpJbiBvcmRlciB0byBhdm9p
ZCBjb25mdXNpb24gYmV0d2VlbiB0aGUgZnVuY3Rpb24gYW5kIHRoZSBzaW1pbGFybHkNCm5hbWVk
IHN0cnVjdC4NCkluIHByZXBhcmF0aW9uIGZvciByZW1vdmluZyB0aGUgJ25ldCcgcHJlZml4IGZy
b20gZGltIG1lbWJlcnMuDQoNClNpZ25lZC1vZmYtYnk6IFRhbCBHaWxib2EgPHRhbGdpQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jICAg
ICAgICB8IDQgKystLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5j
ICAgICAgICAgfCA4ICsrKystLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2Vu
ZXQvYmNtZ2VuZXQuYyAgICB8IDQgKystLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl90eHJ4LmMgfCA2ICsrLS0tLQ0KIGluY2x1ZGUvbGludXgvZGltLmggICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAzICsrLQ0KIGluY2x1ZGUvbGludXgvbmV0X2Rp
bS5oICAgICAgICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCiA2IGZpbGVzIGNoYW5nZWQs
IDE0IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jDQppbmRleCBiNWUyZjlkMmNiNzEuLmZhYWY4YWRlMTVl
NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JjbXN5c3BvcnQu
Yw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jDQpAQCAt
MTAxOSw4ICsxMDE5LDggQEAgc3RhdGljIGludCBiY21fc3lzcG9ydF9wb2xsKHN0cnVjdCBuYXBp
X3N0cnVjdCAqbmFwaSwgaW50IGJ1ZGdldCkNCiAJfQ0KIA0KIAlpZiAocHJpdi0+ZGltLnVzZV9k
aW0pIHsNCi0JCW5ldF9kaW1fc2FtcGxlKHByaXYtPmRpbS5ldmVudF9jdHIsIHByaXYtPmRpbS5w
YWNrZXRzLA0KLQkJCSAgICAgICBwcml2LT5kaW0uYnl0ZXMsICZkaW1fc2FtcGxlKTsNCisJCW5l
dF9kaW1fdXBkYXRlX3NhbXBsZShwcml2LT5kaW0uZXZlbnRfY3RyLCBwcml2LT5kaW0ucGFja2V0
cywNCisJCQkJICAgICAgcHJpdi0+ZGltLmJ5dGVzLCAmZGltX3NhbXBsZSk7DQogCQluZXRfZGlt
KCZwcml2LT5kaW0uZGltLCBkaW1fc2FtcGxlKTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vYm54dC9ibnh0LmMNCmluZGV4IDQ5ZGU4NzMwNDNjMC4uZWFlYzk0OWMzNjdh
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54dC9ibnh0LmMN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jDQpAQCAtMjEz
MCwxMCArMjEzMCwxMCBAQCBzdGF0aWMgaW50IGJueHRfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3Qg
Km5hcGksIGludCBidWRnZXQpDQogCWlmIChicC0+ZmxhZ3MgJiBCTlhUX0ZMQUdfRElNKSB7DQog
CQlzdHJ1Y3QgbmV0X2RpbV9zYW1wbGUgZGltX3NhbXBsZTsNCiANCi0JCW5ldF9kaW1fc2FtcGxl
KGNwci0+ZXZlbnRfY3RyLA0KLQkJCSAgICAgICBjcHItPnJ4X3BhY2tldHMsDQotCQkJICAgICAg
IGNwci0+cnhfYnl0ZXMsDQotCQkJICAgICAgICZkaW1fc2FtcGxlKTsNCisJCW5ldF9kaW1fdXBk
YXRlX3NhbXBsZShjcHItPmV2ZW50X2N0ciwNCisJCQkJICAgICAgY3ByLT5yeF9wYWNrZXRzLA0K
KwkJCQkgICAgICBjcHItPnJ4X2J5dGVzLA0KKwkJCQkgICAgICAmZGltX3NhbXBsZSk7DQogCQlu
ZXRfZGltKCZjcHItPmRpbSwgZGltX3NhbXBsZSk7DQogCX0NCiAJcmV0dXJuIHdvcmtfZG9uZTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5l
dC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYw0KaW5k
ZXggNTI4NmE0NmVjZmIwLi4yOTdhZTc4NmZmZWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jDQpAQCAtMTkwOSw4ICsxOTA5LDggQEAgc3Rh
dGljIGludCBiY21nZW5ldF9yeF9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwgaW50IGJ1
ZGdldCkNCiAJfQ0KIA0KIAlpZiAocmluZy0+ZGltLnVzZV9kaW0pIHsNCi0JCW5ldF9kaW1fc2Ft
cGxlKHJpbmctPmRpbS5ldmVudF9jdHIsIHJpbmctPmRpbS5wYWNrZXRzLA0KLQkJCSAgICAgICBy
aW5nLT5kaW0uYnl0ZXMsICZkaW1fc2FtcGxlKTsNCisJCW5ldF9kaW1fdXBkYXRlX3NhbXBsZShy
aW5nLT5kaW0uZXZlbnRfY3RyLCByaW5nLT5kaW0ucGFja2V0cywNCisJCQkJICAgICAgcmluZy0+
ZGltLmJ5dGVzLCAmZGltX3NhbXBsZSk7DQogCQluZXRfZGltKCZyaW5nLT5kaW0uZGltLCBkaW1f
c2FtcGxlKTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl90eHJ4LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fdHhyeC5jDQppbmRleCBmOTg2MmJmNzU0OTEuLjA3NDMyZTY0MjhjZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4
LmMNCkBAIC01Myw4ICs1Myw3IEBAIHN0YXRpYyB2b2lkIG1seDVlX2hhbmRsZV90eF9kaW0oc3Ry
dWN0IG1seDVlX3R4cXNxICpzcSkNCiAJaWYgKHVubGlrZWx5KCF0ZXN0X2JpdChNTFg1RV9TUV9T
VEFURV9BTSwgJnNxLT5zdGF0ZSkpKQ0KIAkJcmV0dXJuOw0KIA0KLQluZXRfZGltX3NhbXBsZShz
cS0+Y3EuZXZlbnRfY3RyLCBzdGF0cy0+cGFja2V0cywgc3RhdHMtPmJ5dGVzLA0KLQkJICAgICAg
ICZkaW1fc2FtcGxlKTsNCisJbmV0X2RpbV91cGRhdGVfc2FtcGxlKHNxLT5jcS5ldmVudF9jdHIs
IHN0YXRzLT5wYWNrZXRzLCBzdGF0cy0+Ynl0ZXMsICZkaW1fc2FtcGxlKTsNCiAJbmV0X2RpbSgm
c3EtPmRpbSwgZGltX3NhbXBsZSk7DQogfQ0KIA0KQEAgLTY2LDggKzY1LDcgQEAgc3RhdGljIHZv
aWQgbWx4NWVfaGFuZGxlX3J4X2RpbShzdHJ1Y3QgbWx4NWVfcnEgKnJxKQ0KIAlpZiAodW5saWtl
bHkoIXRlc3RfYml0KE1MWDVFX1JRX1NUQVRFX0FNLCAmcnEtPnN0YXRlKSkpDQogCQlyZXR1cm47
DQogDQotCW5ldF9kaW1fc2FtcGxlKHJxLT5jcS5ldmVudF9jdHIsIHN0YXRzLT5wYWNrZXRzLCBz
dGF0cy0+Ynl0ZXMsDQotCQkgICAgICAgJmRpbV9zYW1wbGUpOw0KKwluZXRfZGltX3VwZGF0ZV9z
YW1wbGUocnEtPmNxLmV2ZW50X2N0ciwgc3RhdHMtPnBhY2tldHMsIHN0YXRzLT5ieXRlcywgJmRp
bV9zYW1wbGUpOw0KIAluZXRfZGltKCZycS0+ZGltLCBkaW1fc2FtcGxlKTsNCiB9DQogDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kaW0uaCBiL2luY2x1ZGUvbGludXgvZGltLmgNCmluZGV4
IDk4OWRiYmRmOWQ0NS4uZjBmMjBlZDI1NDk3IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9k
aW0uaA0KKysrIGIvaW5jbHVkZS9saW51eC9kaW0uaA0KQEAgLTEyMyw3ICsxMjMsOCBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgZGltX3BhcmtfdGlyZWQoc3RydWN0IG5ldF9kaW0gKmRpbSkNCiB9DQog
DQogc3RhdGljIGlubGluZSB2b2lkDQotbmV0X2RpbV9zYW1wbGUodTE2IGV2ZW50X2N0ciwgdTY0
IHBhY2tldHMsIHU2NCBieXRlcywgc3RydWN0IG5ldF9kaW1fc2FtcGxlICpzKQ0KK25ldF9kaW1f
dXBkYXRlX3NhbXBsZSh1MTYgZXZlbnRfY3RyLCB1NjQgcGFja2V0cywgdTY0IGJ5dGVzLA0KKwkJ
ICAgICAgc3RydWN0IG5ldF9kaW1fc2FtcGxlICpzKQ0KIHsNCiAJcy0+dGltZQkgICAgID0ga3Rp
bWVfZ2V0KCk7DQogCXMtPnBrdF9jdHIgICA9IHBhY2tldHM7DQpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9uZXRfZGltLmggYi9pbmNsdWRlL2xpbnV4L25ldF9kaW0uaA0KaW5kZXggZTBjOTdm
ODI0ZGQwLi5kNGI0MGFkYzdmYTEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L25ldF9kaW0u
aA0KKysrIGIvaW5jbHVkZS9saW51eC9uZXRfZGltLmgNCkBAIC0yNjEsOCArMjYxLDggQEAgc3Rh
dGljIGlubGluZSB2b2lkIG5ldF9kaW0oc3RydWN0IG5ldF9kaW0gKmRpbSwNCiAJCX0NCiAJCS8q
IGZhbGwgdGhyb3VnaCAqLw0KIAljYXNlIERJTV9TVEFSVF9NRUFTVVJFOg0KLQkJbmV0X2RpbV9z
YW1wbGUoZW5kX3NhbXBsZS5ldmVudF9jdHIsIGVuZF9zYW1wbGUucGt0X2N0ciwgZW5kX3NhbXBs
ZS5ieXRlX2N0ciwNCi0JCQkgICAgICAgJmRpbS0+c3RhcnRfc2FtcGxlKTsNCisJCW5ldF9kaW1f
dXBkYXRlX3NhbXBsZShlbmRfc2FtcGxlLmV2ZW50X2N0ciwgZW5kX3NhbXBsZS5wa3RfY3RyLA0K
KwkJCQkgICAgICBlbmRfc2FtcGxlLmJ5dGVfY3RyLCAmZGltLT5zdGFydF9zYW1wbGUpOw0KIAkJ
ZGltLT5zdGF0ZSA9IERJTV9NRUFTVVJFX0lOX1BST0dSRVNTOw0KIAkJYnJlYWs7DQogCWNhc2Ug
RElNX0FQUExZX05FV19QUk9GSUxFOg0KLS0gDQoyLjIxLjANCg0K
