Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7406C55634
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbfFYRsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:01 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbfFYRr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIkdWd3PfnViHMic7MqLs2WFOL3emsUBlqPM7ZcBm9Q=;
 b=HG2cA8jxmGex4wYbDQwQmUuNkA7+2LWlrd0WcDhhtQuMuAp90t8L7cE2VWBw3yzy1ZAfXmI1tTmHVyFqHqlOx8w0ci45ko8OYw2udD9Z815LIJSWZF3FxejaOXD7FWlt9n0JyzssDVL3jnpthXBHPWQhC+EULyM6ANJhjPNSw9Y=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:47:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:47:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 02/13] net/mlx5: Get vport ACL namespace by vport
 index
Thread-Topic: [PATCH V2 mlx5-next 02/13] net/mlx5: Get vport ACL namespace by
 vport index
Thread-Index: AQHVK34cltXiKVpZB0WkWaW1uE3cPA==
Date:   Tue, 25 Jun 2019 17:47:52 +0000
Message-ID: <20190625174727.20309-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0927ae86-30fa-4ceb-4c76-08d6f9953f0d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB2216F5B6D8C26CCC502204F2BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O8YoY3vayE3dpIB3ALAtkgReAxu0cMDxNpC2lRlI4LY0GJG03+iZsJSgU/AlRoK9Kg85+u1HVYNG+kSlh6UPmQCUNpNUBvdeKM8SwHrV7Vbp7q7qmsWfwW+0ObPC9KoAe0s6gWNz7UNoJs60u2ymWVHPv9/LGuCX6TnY/iA6LKN11LrqFT4ibw3fgFSzG1ahx9n3yk+kIY3izzxLUmqZnw0Pc2/Rm4U2oPZC6vsaOEpbzuTKG/IyeC3yqLYeJQglg5vdkTlbAtuDI13FVGeL+6lzegI09X8kSDZBbIA17pTW3Kl4brrNBvbraGQfaNEjplMERGtShqFqJf3yhUnaQKc+WOMJwTMh/4rMEmm7GD96L51qRuYZ4WBPAk6X46h73/MeWTYfR7y4nBniBAVWL9f+hVb7VzJUQlsyoZF/nm0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0927ae86-30fa-4ceb-4c76-08d6f9953f0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:47:52.5956
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
