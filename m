Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6AA48E47
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfFQTXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:20 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:14178
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727051AbfFQTXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIkdWd3PfnViHMic7MqLs2WFOL3emsUBlqPM7ZcBm9Q=;
 b=rJpSZxQqguZEBoYpzzLaWpBFCdJhWpxqxHCbbd8zegJMFU9olvJH0RCqGJXdrNTXl4heacyCmiiUHpps/FtZ+UsJXfqWTSrzIpZH+KlH6BIXsDcVfnW6ic2BmPYkOIcW8mN6Zwvy10g6+wMOk9+aiKmvQn7oji+F+9ew4jZrCRc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:11 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 02/15] net/mlx5: Get vport ACL namespace by vport
 index
Thread-Topic: [PATCH mlx5-next 02/15] net/mlx5: Get vport ACL namespace by
 vport index
Thread-Index: AQHVJUIasGPzX69B3kOtqsmnNRghXg==
Date:   Mon, 17 Jun 2019 19:23:11 +0000
Message-ID: <20190617192247.25107-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 535dfb2c-4afb-462c-d24a-08d6f3593c6a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB27896EE05E3CC871095A0DB0BEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FKIq2vIaV4GJId9TOSl7CJ8cOf3YCSW7ZdJQOF2C5Dtr9s0VNF+0b2U7XtYYtZ8oQncXc8NlwlV9w3x0CuCuvEvEkPrbc+vO30ASbbeBKfUJujClvPeT61p3KgeHWUxGBtI5ixSdWHyjSt3Kw9YJ98rKO6qmpJYQiXN9i5keLPRv9l0XVHV9U+zLctUDcthH8PBnN1Dh4Hsz9CfnNSdGfFC6ETLcgP4fSR5Lje80CbGVCpZ+B8bWj1ajBfLYhMa+n1my5ZK09lJoFKc/MhnLwDjl5JFnVNqeNiEGLCMCsJV22oWuDGhnSXIdlceOSTGUN55jVvQ0F8uapkzGFXfRK+q20gNKrjWO8kKlEYKQIkTrvu/aNiSh2EsJwX4wuqt4q1OOS6bn08EhB9fT/FFJI/rpRw/R052g+eKSXJZPpWY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535dfb2c-4afb-462c-d24a-08d6f3593c6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:11.5740
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

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNClRoZSBpbmdyZXNzIGFu
ZCBlZ3Jlc3MgQUNMIHJvb3QgbmFtZXNwYWNlcyBhcmUgY3JlYXRlZCBwZXIgdnBvcnQgYW5kDQpz
dG9yZWQgaW50byBhcnJheXMuIEhvd2V2ZXIsIHRoZSB2cG9ydCBudW1iZXIgaXMgbm90IHRoZSBz
YW1lIGFzIHRoZQ0KaW5kZXguIFBhc3NpbmcgdGhlIGFycmF5IGluZGV4LCBpbnN0ZWFkIG9mIHZw
b3J0IG51bWJlciwgdG8gZ2V0IHRoZQ0KY29ycmVjdCBpbmdyZXNzIGFuZCBlZ3Jlc3MgYWNsIG5h
bWVzcGFjZS4NCg0KRml4ZXM6IDliOTNhYjk4MWUzYiAoIm5ldC9tbHg1OiBTZXBhcmF0ZSBpbmdy
ZXNzL2VncmVzcyBuYW1lc3BhY2VzIGZvciBlYWNoIHZwb3J0IikNClNpZ25lZC1vZmYtYnk6IEpp
YW5ibyBMaXUgPGppYW5ib2xAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IE96IFNobG9tbyA8
b3pzaEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVs
bGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQpS
ZXZpZXdlZC1ieTogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jIHwgNCArKy0tDQogMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQppbmRleCAxMjAx
MGY4NWZhMzUuLmE0MmEyM2U1MDVkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCkBAIC05MzksNyArOTM5LDcgQEAgaW50IGVz
d192cG9ydF9lbmFibGVfZWdyZXNzX2FjbChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQogCQkg
IHZwb3J0LT52cG9ydCwgTUxYNV9DQVBfRVNXX0VHUkVTU19BQ0woZGV2LCBsb2dfbWF4X2Z0X3Np
emUpKTsNCiANCiAJcm9vdF9ucyA9IG1seDVfZ2V0X2Zsb3dfdnBvcnRfYWNsX25hbWVzcGFjZShk
ZXYsIE1MWDVfRkxPV19OQU1FU1BBQ0VfRVNXX0VHUkVTUywNCi0JCQkJCQkgICAgdnBvcnQtPnZw
b3J0KTsNCisJCQltbHg1X2Vzd2l0Y2hfdnBvcnRfbnVtX3RvX2luZGV4KGVzdywgdnBvcnQtPnZw
b3J0KSk7DQogCWlmICghcm9vdF9ucykgew0KIAkJZXN3X3dhcm4oZGV2LCAiRmFpbGVkIHRvIGdl
dCBFLVN3aXRjaCBlZ3Jlc3MgZmxvdyBuYW1lc3BhY2UgZm9yIHZwb3J0ICglZClcbiIsIHZwb3J0
LT52cG9ydCk7DQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQpAQCAtMTA1Nyw3ICsxMDU3LDcgQEAg
aW50IGVzd192cG9ydF9lbmFibGVfaW5ncmVzc19hY2woc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3
LA0KIAkJICB2cG9ydC0+dnBvcnQsIE1MWDVfQ0FQX0VTV19JTkdSRVNTX0FDTChkZXYsIGxvZ19t
YXhfZnRfc2l6ZSkpOw0KIA0KIAlyb290X25zID0gbWx4NV9nZXRfZmxvd192cG9ydF9hY2xfbmFt
ZXNwYWNlKGRldiwgTUxYNV9GTE9XX05BTUVTUEFDRV9FU1dfSU5HUkVTUywNCi0JCQkJCQkgICAg
dnBvcnQtPnZwb3J0KTsNCisJCQltbHg1X2Vzd2l0Y2hfdnBvcnRfbnVtX3RvX2luZGV4KGVzdywg
dnBvcnQtPnZwb3J0KSk7DQogCWlmICghcm9vdF9ucykgew0KIAkJZXN3X3dhcm4oZGV2LCAiRmFp
bGVkIHRvIGdldCBFLVN3aXRjaCBpbmdyZXNzIGZsb3cgbmFtZXNwYWNlIGZvciB2cG9ydCAoJWQp
XG4iLCB2cG9ydC0+dnBvcnQpOw0KIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KLS0gDQoyLjIxLjAN
Cg0K
