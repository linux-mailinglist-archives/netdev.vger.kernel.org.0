Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3F1042A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfEADVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:21:09 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:56542
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725909AbfEADVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 23:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ux6pwabGnJbeU8NbbB8i3Vca060ip0bl2wqzBiS08NA=;
 b=dZR0fXMbMfHCmOiCdvPYee85DZyk357l1//L5k/MGaXjswYK5E05AMvdJlsbhNDxZTSMW6jdvkPmfPtm0hIGve1kwktmi5UGUFgCVAbmzWhTgwauswcwDsrxJSp+z8HgidCy599raAFR3xSTnQVdTc1X+OQ86v2cDzdjsrhRq9c=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 1 May 2019 03:21:05 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 03:21:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Qian Cai <cai@lca.pw>, Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: [PATCH mlx5-next] net/mlx5: Fix broken hca cap offset
Thread-Topic: [PATCH mlx5-next] net/mlx5: Fix broken hca cap offset
Thread-Index: AQHU/8zpKZTG0FipW0mErfSWRt/QQQ==
Date:   Wed, 1 May 2019 03:21:05 +0000
Message-ID: <20190501032037.30846-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:a03:100::26) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6d56374-9a74-4592-92ff-08d6cde40bb7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB594788FDD1486D63F331DACFBE3B0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:457;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(86362001)(102836004)(52116002)(316002)(99286004)(26005)(50226002)(110136005)(2906002)(85306007)(54906003)(186003)(6636002)(476003)(7736002)(486006)(3846002)(2616005)(305945005)(386003)(6116002)(6506007)(478600001)(256004)(6436002)(107886003)(8676002)(81166006)(81156014)(71190400001)(53936002)(36756003)(71200400001)(66946007)(66476007)(73956011)(66556008)(64756008)(6512007)(68736007)(8936002)(66066001)(25786009)(4326008)(1076003)(14454004)(6486002)(66446008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FH87viHzFhIZg0NAVGDr/ede2Qnluz9rVVpCeFS6DLVTmrfiarguHxqgZGU1jpIAW+srmtdwLcuszxGD/0cHPR7B1j1/A4HpRPrbG8yxgA9EAdotg9MYMvAErenP5Io+O6/n/TnwQStYWtYikjDPnOjAI77hGahsOsSeHd+7/4rwLyBgJrchcZXBJ/hAtvrmKrcsoCv46G1DV6ZZ2SVfH8hHIYjTVb1jv7tOIHYPPkwIcymq0AvO8J00JVRyE7VXL4sqBYDn+vUXr82nHOotfvXHWfr/hhW4ydeHM19Uq6Y61CFwuqR1uID66JLaGOEVrWSfU5Xbsmex1jiFv0Bam9ntxzgok5OK0+SXjM4F67W26xQDOBgu+p3Tdr8I1W3NwrOQxkujg1zUgEnlpjYhEfgfFqFZy0wNHQvpjmoB8ag=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d56374-9a74-4592-92ff-08d6cde40bb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 03:21:05.7034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGNpdGVkIGNvbW1pdCBicm9rZSB0aGUgb2Zmc2V0cyBvZiBoY2EgY2FwIHN0cnVjdCwgZml4
IGl0Lg0KV2hpbGUgYXQgaXQsIGNsZWFudXAgYSB3aGl0ZSBzcGFjZSBpbnRyb2R1Y2VkIGJ5IHRo
ZSBzYW1lIGNvbW1pdC4NCg0KRml4ZXM6IGIxNjllNjRhMjQ0NCAoIm5ldC9tbHg1OiBHZW5ldmUs
IEFkZCBmbG93IHRhYmxlIGNhcGFiaWxpdGllcyBmb3IgR2VuZXZlIGRlY2FwIHdpdGggVExWIG9w
dGlvbnMiKQ0KUmVwb3J0ZWQtYnk6IFFpYW4gQ2FpIDxjYWlAbGNhLnB3Pg0KQ2M6IFlldmdlbnkg
S2xpdGV5bmlrIDxrbGl0ZXluQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC9tbHg1L21s
eDVfaWZjLmggfCA0ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgg
Yi9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KaW5kZXggNmE3ZmMxOGE5ZmUzLi42YjJl
NmI3MTBhYzAgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KKysr
IGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCkBAIC0xMjY1LDcgKzEyNjUsNyBAQCBz
dHJ1Y3QgbWx4NV9pZmNfY21kX2hjYV9jYXBfYml0cyB7DQogCXU4ICAgICAgICAgbWF4X2dlbmV2
ZV90bHZfb3B0aW9uX2RhdGFfbGVuWzB4NV07DQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfNTcw
WzB4MTBdOw0KIA0KLQl1OCAgICAgICAgIHJlc2VydmVkX2F0XzU4MFsweDFjXTsNCisJdTggICAg
ICAgICByZXNlcnZlZF9hdF81ODBbMHgzY107DQogCXU4ICAgICAgICAgbWluaV9jcWVfcmVzcF9z
dHJpZGVfaW5kZXhbMHgxXTsNCiAJdTggICAgICAgICBjcWVfMTI4X2Fsd2F5c1sweDFdOw0KIAl1
OCAgICAgICAgIGNxZV9jb21wcmVzc2lvbl8xMjhbMHgxXTsNCkBAIC05NTY2LDcgKzk1NjYsNyBA
QCBzdHJ1Y3QgbWx4NV9pZmNfc3dfaWNtX2JpdHMgew0KIAl1OCAgICAgICAgIHN3X2ljbV9zdGFy
dF9hZGRyWzB4NDBdOw0KIA0KIAl1OCAgICAgICAgIHJlc2VydmVkX2F0X2MwWzB4MTQwXTsNCi19
OyANCit9Ow0KIA0KIHN0cnVjdCBtbHg1X2lmY19nZW5ldmVfdGx2X29wdGlvbl9iaXRzIHsNCiAJ
dTggICAgICAgICBtb2RpZnlfZmllbGRfc2VsZWN0WzB4NDBdOw0KLS0gDQoyLjIwLjENCg0K
