Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988D413C5E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEEAdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:33:02 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:14048
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbfEEAdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRWsz8Uy5n6Qg3wQzUWljiXDcE5ZD4hR5Qt9vlEnrGg=;
 b=MMBGOOp6uIHaEVpAYoqiiIOxS+3gj+8yDO4mmGITLAYHyv/ZRopgu3O0a+JAQt21SQhCOSrAyHb2XgiICjG3l6fmUkuNuo0oHM0/eTgm3scsbiIn/oy4vSAAoC/NpOnZdnORtRgvWWv+scFLG6ebGsB+549ROHWJzrbmFD8VP/0=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:32:55 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:32:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5: Move all devlink related functions calls
 to devlink.c
Thread-Topic: [net-next 01/15] net/mlx5: Move all devlink related functions
 calls to devlink.c
Thread-Index: AQHVAtoUOKUe8hLhh0CdLgexXl4EzA==
Date:   Sun, 5 May 2019 00:32:55 +0000
Message-ID: <20190505003207.1353-2-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
In-Reply-To: <20190505003207.1353-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecd81832-9e36-491f-bd05-08d6d0f13745
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB58819B96EC65F81F1CCAA77BBE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(14444005)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TS5xb4UX5PyBn3kgAzDmm7vjHCgrrjjjFH6hyN8SeKQ/lvhip83pc/xRqRWOZDzCXxP3vnbyBE2QP7VWYeXJA5qJBcX7TNM0ufORZswKISoYIRRd9BMhdxZ5B0ntsz4gL/WbKbplFjX43ptnbCBmuSO2KH5XZVfDeqRlo3Wb4cda3Y2YRQvglQnDZbVCOw0qb1fJ3mMCJwVJJE4ONyVnGImAlgHuD36razpIVo5d/vFvhQUQ/HqxN/yKFnPHnF+O8X/WQfDfKDqP8gGP0mXXXX7br+20D66XJGtWzOlq/pq5NhpvdCA2+TChNXLdlu8vhn5IuzzEHxJvRNBgafHKADJhnBwNEXNYyRlgXSaz9JXW0UukSBr1FS+gMBkRKLJz9nFNwEYTNRdWEXDUsb91gjcyh7dfRUsq4nQ2Vu5GpLc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd81832-9e36-491f-bd05-08d6d0f13745
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:32:55.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0KDQpDZW50cmFsaXpl
IGFsbCBkZXZsaW5rIHJlbGF0ZWQgY2FsbGJhY2tzIGluIG9uZSBmaWxlLg0KSW4gdGhlIGRvd25z
dHJlYW0gcGF0Y2gsIHNvbWUgbW9yZSBmdW5jdGlvbmFsaXR5IHdpbGwgYmUgYWRkZWQsIHRoaXMN
CnBhdGNoIGlzIHByZXBhcmluZyB0aGUgZHJpdmVyIGluZnJhc3RydWN0dXJlIGZvciBpdC4NCg0K
Q3VycmVudGx5LCBtb3ZlIGRldmxpbmsgdW4vcmVnaXN0ZXIgZnVuY3Rpb25zIGNhbGxzIGludG8g
dGhpcyBmaWxlLg0KDQpTaWduZWQtb2ZmLWJ5OiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxs
YW5veC5jb20+DQpSZXZpZXdlZC1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29t
Pg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQot
LS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUgIHwg
IDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGV2bGluay5j
IHwgMTQgKysrKysrKysrKysrKysNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZGV2bGluay5oIHwgMTIgKysrKysrKysrKysrDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyAgICB8ICA1ICsrKy0tDQogNCBmaWxlcyBjaGFuZ2Vk
LCAzMCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGV2bGluay5jDQogY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZXZs
aW5rLmgNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9N
YWtlZmlsZQ0KaW5kZXggMjQzMzY4ZGMyM2RiLi4wMzgzMWExYzAyZmQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUNCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZQ0KQEAgLTE1LDcg
KzE1LDcgQEAgbWx4NV9jb3JlLXkgOj0JbWFpbi5vIGNtZC5vIGRlYnVnZnMubyBmdy5vIGVxLm8g
dWFyLm8gcGFnZWFsbG9jLm8gXA0KIAkJaGVhbHRoLm8gbWNnLm8gY3EubyBhbGxvYy5vIHFwLm8g
cG9ydC5vIG1yLm8gcGQubyBcDQogCQl0cmFuc29iai5vIHZwb3J0Lm8gc3Jpb3YubyBmc19jbWQu
byBmc19jb3JlLm8gXA0KIAkJZnNfY291bnRlcnMubyBybC5vIGxhZy5vIGRldi5vIGV2ZW50cy5v
IHdxLm8gbGliL2dpZC5vIFwNCi0JCWxpYi9kZXZjb20ubyBkaWFnL2ZzX3RyYWNlcG9pbnQubyBk
aWFnL2Z3X3RyYWNlci5vDQorCQlsaWIvZGV2Y29tLm8gZGlhZy9mc190cmFjZXBvaW50Lm8gZGlh
Zy9md190cmFjZXIubyBkZXZsaW5rLm8NCiANCiAjDQogIyBOZXRkZXYgYmFzaWMNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGV2bGluay5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RldmxpbmsuYw0KbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uNzJmZjI3ZjU3ODE3DQotLS0gL2Rl
di9udWxsDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGV2
bGluay5jDQpAQCAtMCwwICsxLDE0IEBADQorLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjAgT1IgTGludXgtT3BlbklCDQorLyogQ29weXJpZ2h0IChjKSAyMDE5IE1lbGxhbm94IFRl
Y2hub2xvZ2llcyAqLw0KKw0KKyNpbmNsdWRlIDxkZXZsaW5rLmg+DQorDQoraW50IG1seDVfZGV2
bGlua19yZWdpc3RlcihzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywgc3RydWN0IGRldmljZSAqZGV2
KQ0KK3sNCisJcmV0dXJuIGRldmxpbmtfcmVnaXN0ZXIoZGV2bGluaywgZGV2KTsNCit9DQorDQor
dm9pZCBtbHg1X2RldmxpbmtfdW5yZWdpc3RlcihzdHJ1Y3QgZGV2bGluayAqZGV2bGluaykNCit7
DQorCWRldmxpbmtfdW5yZWdpc3RlcihkZXZsaW5rKTsNCit9DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RldmxpbmsuaCBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZXZsaW5rLmgNCm5ldyBmaWxlIG1vZGUgMTAw
NjQ0DQppbmRleCAwMDAwMDAwMDAwMDAuLjIyNDJkNzNlODQyMA0KLS0tIC9kZXYvbnVsbA0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RldmxpbmsuaA0KQEAg
LTAsMCArMSwxMiBAQA0KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wIE9SIExp
bnV4LU9wZW5JQiAqLw0KKy8qIENvcHlyaWdodCAoYykgMjAxOSwgTWVsbGFub3ggVGVjaG5vbG9n
aWVzICovDQorDQorI2lmbmRlZiBfX01MWDVfREVWTElOS19IX18NCisjZGVmaW5lIF9fTUxYNV9E
RVZMSU5LX0hfXw0KKw0KKyNpbmNsdWRlIDxuZXQvZGV2bGluay5oPg0KKw0KK2ludCBtbHg1X2Rl
dmxpbmtfcmVnaXN0ZXIoc3RydWN0IGRldmxpbmsgKmRldmxpbmssIHN0cnVjdCBkZXZpY2UgKmRl
dik7DQordm9pZCBtbHg1X2RldmxpbmtfdW5yZWdpc3RlcihzdHJ1Y3QgZGV2bGluayAqZGV2bGlu
ayk7DQorDQorI2VuZGlmIC8qIF9fTUxYNV9ERVZMSU5LX0hfXyAqLw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQppbmRleCA2MWZhMWQxNjJkMjgu
Ljk2OTE3ZjQ0NGJlZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9tYWluLmMNCkBAIC01Niw2ICs1Niw3IEBADQogI2luY2x1ZGUgImZzX2NvcmUuaCIN
CiAjaW5jbHVkZSAibGliL21wZnMuaCINCiAjaW5jbHVkZSAiZXN3aXRjaC5oIg0KKyNpbmNsdWRl
ICJkZXZsaW5rLmgiDQogI2luY2x1ZGUgImxpYi9tbHg1LmgiDQogI2luY2x1ZGUgImZwZ2EvY29y
ZS5oIg0KICNpbmNsdWRlICJmcGdhL2lwc2VjLmgiDQpAQCAtMTMxMiw3ICsxMzEzLDcgQEAgc3Rh
dGljIGludCBpbml0X29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9k
ZXZpY2VfaWQgKmlkKQ0KIA0KIAlyZXF1ZXN0X21vZHVsZV9ub3dhaXQoTUxYNV9JQl9NT0QpOw0K
IA0KLQllcnIgPSBkZXZsaW5rX3JlZ2lzdGVyKGRldmxpbmssICZwZGV2LT5kZXYpOw0KKwllcnIg
PSBtbHg1X2RldmxpbmtfcmVnaXN0ZXIoZGV2bGluaywgJnBkZXYtPmRldik7DQogCWlmIChlcnIp
DQogCQlnb3RvIGNsZWFuX2xvYWQ7DQogDQpAQCAtMTMzNyw3ICsxMzM4LDcgQEAgc3RhdGljIHZv
aWQgcmVtb3ZlX29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCiAJc3RydWN0IG1seDVfY29yZV9k
ZXYgKmRldiAgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7DQogCXN0cnVjdCBkZXZsaW5rICpkZXZs
aW5rID0gcHJpdl90b19kZXZsaW5rKGRldik7DQogDQotCWRldmxpbmtfdW5yZWdpc3RlcihkZXZs
aW5rKTsNCisJbWx4NV9kZXZsaW5rX3VucmVnaXN0ZXIoZGV2bGluayk7DQogCW1seDVfdW5yZWdp
c3Rlcl9kZXZpY2UoZGV2KTsNCiANCiAJaWYgKG1seDVfdW5sb2FkX29uZShkZXYsIHRydWUpKSB7
DQotLSANCjIuMjAuMQ0KDQo=
