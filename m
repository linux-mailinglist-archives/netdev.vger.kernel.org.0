Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAEAE9D8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfD2SOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:24 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:51170
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729031AbfD2SOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJP9jUMu0vvXJryKUuSX2y7QYQjf+RDnPaxuYObHPHQ=;
 b=vFBUxd+HB3GeMkl5mhBn5StAQa1T7I2Ttl5jKrpsf76e2M54qAPOCTMr5Uuu4tPJJgrWXs4LT1WZqGay8/0jdnNlpQytf60/wftp+32TosHZplU2jmB05ZBZ2khShShXtmilZJkR4KJjEK0/9jxN09crDQTOvcXG7H3XRksFc78=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6619.eurprd05.prod.outlook.com (20.179.12.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 18:14:01 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:14:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH V2 mlx5-next 01/11] net/mlx5: E-Switch: Introduce prio tag
 mode
Thread-Topic: [PATCH V2 mlx5-next 01/11] net/mlx5: E-Switch: Introduce prio
 tag mode
Thread-Index: AQHU/rdSVi+SJrjGx0W7btCusIX5rA==
Date:   Mon, 29 Apr 2019 18:14:01 +0000
Message-ID: <20190429181326.6262-2-saeedm@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:a03:40::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9bef33a-0f43-4cff-caec-08d6ccce7442
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6619;
x-ms-traffictypediagnostic: DB8PR05MB6619:
x-microsoft-antispam-prvs: <DB8PR05MB661906AFBB84C5AE3CE81770BE390@DB8PR05MB6619.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(366004)(39860400002)(136003)(376002)(396003)(189003)(199004)(6636002)(316002)(66066001)(386003)(6506007)(7736002)(68736007)(36756003)(305945005)(54906003)(110136005)(6512007)(102836004)(186003)(26005)(99286004)(76176011)(14454004)(52116002)(478600001)(14444005)(8936002)(85306007)(81156014)(8676002)(81166006)(1076003)(4744005)(2906002)(5660300002)(86362001)(107886003)(6116002)(71200400001)(71190400001)(66946007)(450100002)(73956011)(4326008)(6436002)(97736004)(66556008)(66446008)(66476007)(64756008)(486006)(476003)(2616005)(25786009)(53936002)(6486002)(3846002)(50226002)(11346002)(446003)(256004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6619;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nll1Lv7goFTQX1FZiAvQ1naGeBgj/c1UUGBVyjwy4AxDTa5aXkKBptJ3gano3AnwPSiHR507t6YTnMKkzC3umDQZ6t8S8EfSs6zIHB5EaHsjYYW4nWX3yqwHskQ6NtaxkebAABWGwyfuncmaswUa8o+0x+gibze3/dwEzdxcdmWQGHny+oIU0IAoLSP30VARVhr2BNISo0AZ4Bq1eh/KwM/TzOON8QeafXt3yryOR6aHg85ORyCSsMJair+C3RR1L/M64blwN6OdGDVdoQUj4EwQxrIeKS4d+BDmQf5w440eP3hBmJaImP+R6oSlzCK2dJxd0UMVYUqUxtvaX6KFIC7ufJEZU3WQmDV+s2hlV9GE1xzGINiyReyuprzg/RPhnBa99vmQmPyquszhCL4xSIP3mnhHPNuu/ROalFLb4dw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bef33a-0f43-4cff-caec-08d6ccce7442
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:14:01.0621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpDdXJyZW50IENvbm5l
Y3RYIEhXIGlzIHVuYWJsZSB0byBwZXJmb3JtIFZMQU4gcG9wIGluIFRYIHBhdGggYW5kIFZMQU4N
CnB1c2ggb24gUlggcGF0aC4gVG8gd29ya2Fyb3VuZCB0aGF0IGxpbWl0YXRpb24gdW50YWdnZWQg
cGFja2V0cyB3aWxsIGJlDQp0YWdnZWQgd2l0aCBWTEFOIElEIDB4MDAwIChwcmlvcml0eSB0YWcp
IGFuZCBwb3AvcHVzaCBhY3Rpb25zIHdpbGwgYmUNCnJlcGxhY2VkIGJ5IFZMQU4gcmUtd3JpdGUg
YWN0aW9ucyAod2hpY2ggYXJlIHN1cHBvcnRlZCBieSB0aGUgSFcpLg0KSW50cm9kdWNlIHByaW8g
dGFnIG1vZGUgYXMgYSBwcmUtc3RlcCB0byBjb250cm9sbGluZyB0aGUgd29ya2Fyb3VuZA0KYmVo
YXZpb3IuDQoNClNpZ25lZC1vZmYtYnk6IEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94LmNv
bT4NClJldmlld2VkLWJ5OiBPeiBTaGxvbW8gPG96c2hAbWVsbGFub3guY29tPg0KU2lnbmVkLW9m
Zi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiBpbmNsdWRl
L2xpbnV4L21seDUvbWx4NV9pZmMuaCB8IDQgKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWx4
NS9tbHg1X2lmYy5oIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCmluZGV4IDRiMzc1
MTliZDZhNS4uZWVlZGYzZjUzZWQzIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L21s
eDVfaWZjLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oDQpAQCAtOTUxLDcg
Kzk1MSw5IEBAIHN0cnVjdCBtbHg1X2lmY19jbWRfaGNhX2NhcF9iaXRzIHsNCiANCiAJdTggICAg
ICAgICBsb2dfbWF4X3NycV9zelsweDhdOw0KIAl1OCAgICAgICAgIGxvZ19tYXhfcXBfc3pbMHg4
XTsNCi0JdTggICAgICAgICByZXNlcnZlZF9hdF85MFsweGJdOw0KKwl1OCAgICAgICAgIHJlc2Vy
dmVkX2F0XzkwWzB4OF07DQorCXU4ICAgICAgICAgcHJpb190YWdfcmVxdWlyZWRbMHgxXTsNCisJ
dTggICAgICAgICByZXNlcnZlZF9hdF85OVsweDJdOw0KIAl1OCAgICAgICAgIGxvZ19tYXhfcXBb
MHg1XTsNCiANCiAJdTggICAgICAgICByZXNlcnZlZF9hdF9hMFsweGJdOw0KLS0gDQoyLjIwLjEN
Cg0K
