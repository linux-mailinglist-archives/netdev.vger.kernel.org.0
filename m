Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D12D399
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfE2CIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:12 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbfE2CIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+hXGX9W3QTon4nejDwEe3W5ch4fPc1umAbmuZ0/tgw=;
 b=PU/e3eM1WZ4jGSl2coo7qrEI11JKBoOwWVj8GS9xopVUwmaxuIX3tlwNeJSKwZv2V7TWvmoqLgCRWmGIAWdvOka6V7t15fTKYzIFjfxRZUVIuQ1H+tQzX2drPuPG287pRVsIXFYWGHN97fCunnJNiiNfmEjPme74Josk6n1ps2k=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:08:04 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:08:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/6] net/mlx5: Allocate root ns memory using kzalloc to match
 kfree
Thread-Topic: [net 4/6] net/mlx5: Allocate root ns memory using kzalloc to
 match kfree
Thread-Index: AQHVFcNZ1BwMSWow90Sn1J8+R0rEYA==
Date:   Wed, 29 May 2019 02:08:04 +0000
Message-ID: <20190529020737.4172-5-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a706ff5-becf-4e2f-494e-08d6e3da7c0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB5947A9B85D072A7A8A125ADABE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(14444005)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(76176011)(66066001)(64756008)(6916009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: liKhtVqnEUVGhAGSR31gCRHMxsDPtbdRRWH9F2XbjGrDVYPwn7oJrnqq24WvfSMcZTbEY42ikqkgsc2gxDU9kMbatr2/W0AmmV2pfHXcdQa+ZpF6S2HzYemEOcDavfL3FRJzAAb/ACB+k3fKpSjK69SeeSkeHxX0YP2tHtN7N0UiJ7fVITfafcLR/RdPvDnZC75Jd8PXMGblKQceTP81T4hsvCfC7nERMnGW5KSnzzNjbULqjQ5E7ouhSMjki2reNdRvJqET9Gx1CU0ygztyJzC2UqaNxaUr4WK1f/ee1lyb/qzw2HSJtUTUpjKIuPntHMr7mJEWX/4a9p59tt+L21vvzXlpQBxcKdRTHUkdSg9DxBWvUe2aEdzZcXKiPU4MXq80bRgNVONP3cDfBQENwnlTJVs/x6QBna1VG9IJrdI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a706ff5-becf-4e2f-494e-08d6e3da7c0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:08:04.7091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCnJvb3QgbnMgaXMgeWV0
IGFub3RoZXIgZnMgY29yZSBub2RlIHdoaWNoIGlzIGZyZWVkIHVzaW5nIGtmcmVlKCkgYnkNCnRy
ZWVfcHV0X25vZGUoKS4NClJlc3Qgb2YgdGhlIG90aGVyIGZzIGNvcmUgb2JqZWN0cyBhcmUgYWxz
byBhbGxvY2F0ZWQgdXNpbmcga21hbGxvYw0KdmFyaWFudHMuDQoNCkhvd2V2ZXIsIHJvb3QgbnMg
bWVtb3J5IGlzIGFsbG9jYXRlZCB1c2luZyBrdnphbGxvYygpLg0KSGVuY2UgYWxsb2NhdGUgcm9v
dCBucyBtZW1vcnkgdXNpbmcga3phbGxvYygpLg0KDQpGaXhlczogMjUzMDIzNjMwM2Q5ZSAoIm5l
dC9tbHg1X2NvcmU6IEZsb3cgc3RlZXJpbmcgdHJlZSBpbml0aWFsaXphdGlvbiIpDQpTaWduZWQt
b2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBE
YW5pZWwgSnVyZ2VucyA8ZGFuaWVsakBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogTWFyayBC
bG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZnNfY29yZS5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9mc19jb3JlLmMNCmluZGV4IDM0Mjc2YTJiNmRhMi4uZmU3NmM2ZmQ2ZDgw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Zz
X2NvcmUuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Zz
X2NvcmUuYw0KQEAgLTIyODQsNyArMjI4NCw3IEBAIHN0YXRpYyBzdHJ1Y3QgbWx4NV9mbG93X3Jv
b3RfbmFtZXNwYWNlDQogCQljbWRzID0gbWx4NV9mc19jbWRfZ2V0X2RlZmF1bHRfaXBzZWNfZnBn
YV9jbWRzKHRhYmxlX3R5cGUpOw0KIA0KIAkvKiBDcmVhdGUgdGhlIHJvb3QgbmFtZXNwYWNlICov
DQotCXJvb3RfbnMgPSBrdnphbGxvYyhzaXplb2YoKnJvb3RfbnMpLCBHRlBfS0VSTkVMKTsNCisJ
cm9vdF9ucyA9IGt6YWxsb2Moc2l6ZW9mKCpyb290X25zKSwgR0ZQX0tFUk5FTCk7DQogCWlmICgh
cm9vdF9ucykNCiAJCXJldHVybiBOVUxMOw0KIA0KLS0gDQoyLjIxLjANCg0K
