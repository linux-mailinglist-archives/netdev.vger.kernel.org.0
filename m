Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4D93980A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfFGVsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:48:08 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731464AbfFGVsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVOsYKrDrHcRf/aLFByRrXTeV01DlTk8AvXqG5ZeEdQ=;
 b=d7n4e+DKvl9yD0EMLUa6G5sB57xpvGcxGh1bCcSDvtZwu8QGWU8wyga8JorKD43SDZlDPgP+AX+qPTsFNBtyigrpHRdfPXweLk4peiIzrLeGu10dqL3NpA27AvkiZ28yWb3EG4Aws4PY50LQrTXMACYAiUFazZwefumnrUMYM4I=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:46 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/7] net/mlx5e: Avoid detaching non-existing netdev under
 switchdev mode
Thread-Topic: [net 6/7] net/mlx5e: Avoid detaching non-existing netdev under
 switchdev mode
Thread-Index: AQHVHXqkjUp1APBnO0u5y3/ifLqFkw==
Date:   Fri, 7 Jun 2019 21:47:46 +0000
Message-ID: <20190607214716.16316-7-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45ee6c51-8fe4-407b-77d3-08d6eb91c715
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB61391BC16E309527D1EC1D66BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1/986Kwl/std4DnoMvTTe85adSrVEPRXn5f3ruIxAVhk3/mtTa7+i0ZhT9TSfuTJNdRDS2ju6aglREePzRSxIKRTOHcgdlV/46RDbsNu55XXDI+d5x81H+cDL+TinV9BwfIYiq8t4gpPRiyXaZCt4xIcF3CPij56osqAyCjhnDrS1NA335ruMEdMpCsYcCxW+QOl10KDKQHVtI4qt1pEPIZ43hBxuuZAqqCEvDNTKsE8l6K6j0kG7yaTsAOAId2WDhNwCcP+jU+o3w7rWCvm2oUcxI+9Ti2ziH/5zoEoJnHZHXkRqTH5kT6sY69Ji8GcZlajeYdBtv8VmpwujHO+mSXfVPHW4vX2gjSV/G7AowMBF+q9uGrlKM8Tdy6mdjMRs29EFmumUbrHHBynmFL/eCWf1LE+4FsJZFfm1DQlUW0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ee6c51-8fe4-407b-77d3-08d6eb91c715
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:46.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxhYSBIbGVpaGVsIDxhbGFhQG1lbGxhbm94LmNvbT4NCg0KQWZ0ZXIgaW50cm9kdWNp
bmcgZGVkaWNhdGVkIHVwbGluayByZXByZXNlbnRvciwgdGhlIG5ldGRldiBpbnN0YW5jZQ0Kc2V0
IG92ZXIgdGhlIGVzdyBtYW5hZ2VyIHZwb3J0IChQRikgYmVjYW1lIG5vIGxvbmdlciBpbiB1c2Us
IHNvIGl0IHdhcw0KcmVtb3ZlZCBpbiB0aGUgY2l0ZWQgY29tbWl0IG9uY2Ugd2UncmUgb24gc3dp
dGNoZGV2IG1vZGUuDQpIb3dldmVyLCB0aGUgbWx4NWVfZGV0YWNoIGZ1bmN0aW9uIHdhcyBub3Qg
dXBkYXRlZCBhY2NvcmRpbmdseSwgYW5kIGl0DQpzdGlsbCB0cmllcyB0byBkZXRhY2ggYSBub24t
ZXhpc3RpbmcgbmV0ZGV2LCBjYXVzaW5nIGEga2VybmVsIGNyYXNoLg0KDQpUaGlzIHBhdGNoIGZp
eGVzIHRoaXMgaXNzdWUuDQoNCkZpeGVzOiBhZWMwMDJmNmY4MmMgKCJuZXQvbWx4NWU6IFVuaW5z
dGFudGlhdGUgZXN3IG1hbmFnZXIgdnBvcnQgbmV0ZGV2IG9uIHN3aXRjaGRldiBtb2RlIikNClNp
Z25lZC1vZmYtYnk6IEFsYWEgSGxlaWhlbCA8YWxhYUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1i
eTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyB8IDUgKysrKysNCiAxIGZpbGUgY2hhbmdlZCwg
NSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX21haW4uYw0KaW5kZXggNTY0NjkyMjI3YzE2Li5hOGU4MzUwYjM4YWEgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFp
bi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFp
bi5jDQpAQCAtNTEwOCw2ICs1MTA4LDExIEBAIHN0YXRpYyB2b2lkIG1seDVlX2RldGFjaChzdHJ1
Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwgdm9pZCAqdnByaXYpDQogCXN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2ID0gdnByaXY7DQogCXN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYgPSBwcml2LT5uZXRk
ZXY7DQogDQorI2lmZGVmIENPTkZJR19NTFg1X0VTV0lUQ0gNCisJaWYgKE1MWDVfRVNXSVRDSF9N
QU5BR0VSKG1kZXYpICYmIHZwcml2ID09IG1kZXYpDQorCQlyZXR1cm47DQorI2VuZGlmDQorDQog
CWlmICghbmV0aWZfZGV2aWNlX3ByZXNlbnQobmV0ZGV2KSkNCiAJCXJldHVybjsNCiANCi0tIA0K
Mi4yMS4wDQoNCg==
