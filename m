Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9937848E59
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfFQTXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:47 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:28142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728891AbfFQTXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pnc127BJDlgJfDmfOO5H1rFILUVcC4FqDMXDaOfuz9A=;
 b=guBmzQ8YWMwHX7LJxoM+QI4rXSvu1EugxECtKPMBvbKC4cWfryz606b1mqe0ilHBx2B+xjexymi8OfKiRTxqReOW+P8T3Nnbf6sk5NtODwuNCZxJX/YQOFm4lcY838oiVhsFvzorIkqce7kfLuS5vX72EDLlCe7vXCpf33CPzqM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metadata
 matching if firmware supports it
Thread-Topic: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport
 metadata matching if firmware supports it
Thread-Index: AQHVJUImg6mGjsOB30G61VX4w8wChA==
Date:   Mon, 17 Jun 2019 19:23:32 +0000
Message-ID: <20190617192247.25107-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 41a14378-03d5-4ce0-00b9-08d6f359490e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB278908F435DCCF9FCC866D54BEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WSWBwS5d72yVyTf+c9uCSnXotLUs9nNzSk4ZTYkxUVmX2/za0Jvx0XDsDifdAh1lIjFcgv6QgEjVLBQyQ/LDkPTfbN2Zph0qWqFJ4n3UuUdR/5L4oFNl8ia93a9JH6Lf7nxKPe4K94VNGs/b6odI9JSgpN/h5XOWUQwf43QAcQMfcBjwOQCOE1uiGd1HHimvKGfk1w7yPqcXKMiLSRdH6JFSOwtfLWZlTjYGevf1sxAQ9bq5PileNKT1fK3WX9W/LWdHXaVMSljOKDf4UFB03IywSUeKRXBud6386Qay7LfcEtrCFWLVhlpVXMYwqIqOL1WM+Dwkt99WS2J2rfS9rs0tDRXru+y/pgHnD4PxHPF1C0z4yJ3y6muvWlazB0LwFfW8FgvqLO5+JRvflZ7zlM2SgmbJwfXOug2CGIXkXpo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a14378-03d5-4ce0-00b9-08d6f359490e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:32.6520
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

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkFzIHRoZSBpbmdyZXNz
IEFDTCBydWxlcyBzYXZlIHZoY2EgaWQgYW5kIHZwb3J0IG51bWJlciB0byBwYWNrZXQncw0KbWV0
YWRhdGEgUkVHX0NfMCwgYW5kIHRoZSBtZXRhZGF0YSBtYXRjaGluZyBmb3IgdGhlIHJ1bGVzIGlu
IGJvdGggZmFzdA0KcGF0aCBhbmQgc2xvdyBwYXRoIGFyZSBhbGwgYWRkZWQsIGVuYWJsZSB0aGlz
IGZlYXR1cmUgaWYgc3VwcG9ydGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFu
Ym9sQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3gu
Y29tPg0KUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NClNpZ25l
ZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4u
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgIHwgMTMgKysr
KysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkcy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hf
b2ZmbG9hZHMuYw0KaW5kZXggMzYzNTE3ZTI5ZDRjLi41MTI0MjE5YTMxZGUgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fk
cy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkcy5jDQpAQCAtMTkwNiwxMiArMTkwNiwyNSBAQCBzdGF0aWMgaW50IGVzd192cG9y
dF9pbmdyZXNzX2NvbW1vbl9jb25maWcoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LA0KIAlyZXR1
cm4gZXJyOw0KIH0NCiANCitzdGF0aWMgaW50IGVzd19jaGVja192cG9ydF9tYXRjaF9tZXRhZGF0
YV9zdXBwb3J0ZWQoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KK3sNCisJcmV0dXJuIChNTFg1
X0NBUF9FU1dfRkxPV1RBQkxFKGVzdy0+ZGV2LCBmZGJfdG9fdnBvcnRfcmVnX2NfaWQpICYNCisJ
CU1MWDVfRkRCX1RPX1ZQT1JUX1JFR19DXzApICYmDQorCSAgICAgICBNTFg1X0NBUF9FU1dfRkxP
V1RBQkxFKGVzdy0+ZGV2LCBmbG93X3NvdXJjZSkgJiYNCisJICAgICAgIE1MWDVfQ0FQX0VTVyhl
c3ctPmRldiwgZXN3X3VwbGlua19pbmdyZXNzX2FjbCkgJiYNCisJICAgICAgICFtbHg1X2NvcmVf
aXNfZWNwZl9lc3dfbWFuYWdlcihlc3ctPmRldikgJiYNCisJICAgICAgICFtbHg1X2VjcGZfdnBv
cnRfZXhpc3RzKGVzdy0+ZGV2KTsNCit9DQorDQogc3RhdGljIGludCBlc3dfY3JlYXRlX29mZmxv
YWRzX2FjbF90YWJsZXMoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIHsNCiAJc3RydWN0IG1s
eDVfdnBvcnQgKnZwb3J0Ow0KIAlpbnQgaSwgajsNCiAJaW50IGVycjsNCiANCisJaWYgKGVzd19j
aGVja192cG9ydF9tYXRjaF9tZXRhZGF0YV9zdXBwb3J0ZWQoZXN3KSkNCisJCWVzdy0+ZmxhZ3Mg
fD0gTUxYNV9FU1dJVENIX1ZQT1JUX01BVENIX01FVEFEQVRBOw0KKw0KIAltbHg1X2Vzd19mb3Jf
YWxsX3Zwb3J0cyhlc3csIGksIHZwb3J0KSB7DQogCQllcnIgPSBlc3dfdnBvcnRfaW5ncmVzc19j
b21tb25fY29uZmlnKGVzdywgdnBvcnQpOw0KIAkJaWYgKGVycikNCi0tIA0KMi4yMS4wDQoNCg==
