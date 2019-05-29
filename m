Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F212D39A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfE2CIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:14 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726508AbfE2CIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSQK+Gov9wjP/jiZE/gpZiQVKVTRfGvtxga1ZSzx3tI=;
 b=g9pjmBRYs1OSJLTreNdWbzQD65oQhRiemVx6TC9U+PHEZkei0tQKFZV/CgHjld2iWVO7NaG+gEEAnPNh2uZ/zfaeviZyhN8OMmThiycM9vTk31U/0fJAyZ6hNHQk5aPSnu6kNozB+PDKaWgVvCUdGj/MfDh21kf5n1ZOgCi1Neo=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:08:06 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:08:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/6] net/mlx5e: restrict the real_dev of vlan device is the same
 as uplink device
Thread-Topic: [net 5/6] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Index: AQHVFcNaicvcr4zI/kuQbmOY1pe9zQ==
Date:   Wed, 29 May 2019 02:08:06 +0000
Message-ID: <20190529020737.4172-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3f3ce396-5781-418f-9696-08d6e3da7d08
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB59476A6EA32CD16F2BA47921BE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(14444005)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(76176011)(66066001)(64756008)(6916009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Hxv3bDiAsOHB2N4FAiXmThhtLjBjErPH8v6AF/XBhEMNNTv+zLNF5pQ/bX4Fg+56VWcTvtammH3vsXB92jNN1/Q8ZaMQo+PScTaKUFIMw09cQu1RItkiDmByeiPYBaKDkG/WvJIjEDnWmnZZm096OWVg7d9J8N73TJM5gHzqBuwJmO5IlSRQmLo5cfK5LtjJnazg9keCtlxOwFwzmoqFPmjMx1TM4dh1vwqBRIFnNodlPmpcA/+pTGDQ6hxwfxrAm6byhXPb0y/22UQRBRnxa6ZRVDyC9empYbeXSfEB5vvXsBcukY11dQJZujiXKzwI/tTdcrFbRSRRAiDs6Zy/2sUuOc9uC7HR1BzXJcCf1X0qvxcx6IvBXG4IPqMAQo97EFDAnURhivBBXwBOsmXMHreu5wSJpywji0GfbwM6jOw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3ce396-5781-418f-9696-08d6e3da7d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:08:06.4091
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

RnJvbTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCg0KV2hlbiByZWdpc3RlciBpbmRyIGJsb2Nr
IGZvciB2bGFuIGRldmljZSwgaXQgc2hvdWxkIGNoZWNrIHRoZSByZWFsX2Rldg0Kb2YgdmxhbiBk
ZXZpY2UgaXMgc2FtZSBhcyB1cGxpbmsgZGV2aWNlLiBPciBpdCB3aWxsIHNldCBvZmZsb2FkIHJ1
bGUNCnRvIG1seDVlIHdoaWNoIHdpbGwgbmV2ZXIgaGl0Lg0KDQpGaXhlczogMzVhNjA1ZGIxNjhj
ICgibmV0L21seDVlOiBPZmZsb2FkIFRDIGUtc3dpdGNoIHJ1bGVzIHdpdGggaW5ncmVzcyBWTEFO
IGRldmljZSIpDQpTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KUmV2aWV3
ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVl
ZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KaW5kZXggNTI4M2UxNmM2OWU0Li45YWVh
OWM1YjJjZTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fcmVwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9yZXAuYw0KQEAgLTgxMyw3ICs4MTMsNyBAQCBzdGF0aWMgaW50IG1seDVlX25pY19y
ZXBfbmV0ZGV2aWNlX2V2ZW50KHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsDQogCXN0cnVjdCBu
ZXRfZGV2aWNlICpuZXRkZXYgPSBuZXRkZXZfbm90aWZpZXJfaW5mb190b19kZXYocHRyKTsNCiAN
CiAJaWYgKCFtbHg1ZV90Y190dW5fZGV2aWNlX3RvX29mZmxvYWQocHJpdiwgbmV0ZGV2KSAmJg0K
LQkgICAgIWlzX3ZsYW5fZGV2KG5ldGRldikpDQorCSAgICAhKGlzX3ZsYW5fZGV2KG5ldGRldikg
JiYgdmxhbl9kZXZfcmVhbF9kZXYobmV0ZGV2KSA9PSBycHJpdi0+bmV0ZGV2KSkNCiAJCXJldHVy
biBOT1RJRllfT0s7DQogDQogCXN3aXRjaCAoZXZlbnQpIHsNCi0tIA0KMi4yMS4wDQoNCg==
