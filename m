Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24BC33B75
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFCWg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:36:56 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:6068
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfFCWgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 18:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHTpNX/9HtwuZ2OPp+C+3MdRhI8Sb79JfX2p81AA7t0=;
 b=SwCJwaFR1HTk3wia2bmU/iO4zb+NT/byWTlzxhe48rmaGHnf+f6xLgYhQjzZW43DpvZsGaTQ90WQ7YGTBlrtj5i95fyXfycFNw5Yq4oROOY6JRBB1tl+lpJYTbsTM7DcI/woAM9uK7CPch4oqaQ6mv3EYZKbl3vQ+5bKimyOTgs=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3250.eurprd05.prod.outlook.com (10.170.126.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Mon, 3 Jun 2019 22:36:47 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899%5]) with mapi id 15.20.1922.021; Mon, 3 Jun 2019
 22:36:47 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next 2/2] net: vlan: Inherit MPLS features from parent
 device
Thread-Topic: [PATCH net-next 2/2] net: vlan: Inherit MPLS features from
 parent device
Thread-Index: AQHVGlzT2OnZmiBtIk6HdG4jK+ELag==
Date:   Mon, 3 Jun 2019 22:36:47 +0000
Message-ID: <1559601394-5363-3-git-send-email-lariel@mellanox.com>
References: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0106.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::22) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7233167b-378c-4533-56b5-08d6e873f62d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3250;
x-ms-traffictypediagnostic: AM4PR05MB3250:
x-microsoft-antispam-prvs: <AM4PR05MB3250E89294FE882C3B0AAC29BA140@AM4PR05MB3250.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(189003)(199004)(14454004)(86362001)(3846002)(256004)(186003)(6116002)(2501003)(4720700003)(99286004)(4326008)(107886003)(2351001)(25786009)(66476007)(26005)(386003)(6506007)(11346002)(6916009)(52116002)(36756003)(446003)(71200400001)(76176011)(71190400001)(316002)(305945005)(508600001)(66066001)(486006)(5640700003)(14444005)(2616005)(68736007)(476003)(81166006)(73956011)(8676002)(1730700003)(81156014)(6512007)(8936002)(2906002)(7736002)(5660300002)(66446008)(64756008)(66556008)(6436002)(50226002)(66946007)(102836004)(53936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3250;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: knH1+inQn6LRkX7UMzuvIt5gGfXrEg+RuqSsLNiv579For3V3JJNo7D8MGfysGsNQF0Y6FCV763Yw3lrzMxhSEXL3xYQwn76Z+ez1bl3PS2Ry5AZtFZo2xhZS+EuThSY5DkeZsX2mQ9jOyOPngcA5yPBo0GXDYyd1wN+6vGxTR5WEZ+Y/IqyMYY7kO0RPRaQE0+fcqhyeH5kB8O7R8f1CMcBgiF43hpRwLHVCI2qNFKr6hUAb1ZZZIsTQaq3L4+4NlBDbj1u4i+yOQCfNwKzB8inxwsWMlFgkVYCs+pqwgw0VEOYGb7v9OpiQp5kYRLGBSLUNJVio+N/ZIU5FTMq8qyAwLzn8c2kffOoer92pW1WHIxnxFvCvZg+qo5fTDp+0CqGhnafUAa5iYbIj5Hr8Nttgv3P90un4ZH3EdCDy4E=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7233167b-378c-4533-56b5-08d6e873f62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 22:36:47.2291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3250
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RHVyaW5nIHRoZSBjcmVhdGlvbiBvZiB0aGUgVkxBTiBpbnRlcmZhY2UgbmV0IGRldmljZSwNCnRo
ZSB2YXJpb3VzIGRldmljZSBmZWF0dXJlcyBhbmQgb2ZmbG9hZHMgYXJlIGJlaW5nIHNldCBiYXNl
ZA0Kb24gdGhlIHBhcmVudCBkZXZpY2UncyBmZWF0dXJlcy4NClRoZSBjb2RlIGluaXRpYXRlcyB0
aGUgYmFzaWMsIHZsYW4gYW5kIGVuY2Fwc3VsYXRpb24gZmVhdHVyZXMNCmJ1dCBkb2Vzbid0IGFk
ZHJlc3MgdGhlIE1QTFMgZmVhdHVyZXMgc2V0IGFuZCB0aGV5IHJlbWFpbiBibGFuay4NCkFzIGEg
cmVzdWx0LCBhbGwgZGV2aWNlIG9mZmxvYWRzIHRoYXQgaGF2ZSBzaWduaWZpY2FudCBwZXJmb3Jt
YW5jZQ0KZWZmZWN0IGFyZSBkaXNhYmxlZCBmb3IgTVBMUyB0cmFmZmljIGdvaW5nIHZpYSB0aGlz
IFZMQU4gZGV2aWNlIHN1Y2gNCmFzIGNoZWNrc3VtbWluZyBhbmQgVFNPLg0KDQpUaGlzIHBhdGNo
IG1ha2VzIHN1cmUgdGhhdCBNUExTIGZlYXR1cmVzIGFyZSBhbHNvIHNldCBmb3IgdGhlDQpWTEFO
IGRldmljZSBiYXNlZCBvbiB0aGUgcGFyZW50IHdoaWNoIHdpbGwgYWxsb3cgSFcgb2ZmbG9hZHMg
b2YNCmNoZWNrc3VtbWluZyBhbmQgVFNPIHRvIGJlIHBlcmZvcm1lZCBvbiBNUExTIHRhZ2dlZCBw
YWNrZXRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcmllbCBMZXZrb3ZpY2ggPGxhcmllbEBtZWxsYW5v
eC5jb20+DQotLS0NCiBuZXQvODAyMXEvdmxhbl9kZXYuYyB8IDEgKw0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0LzgwMjFxL3ZsYW5fZGV2LmMgYi9u
ZXQvODAyMXEvdmxhbl9kZXYuYw0KaW5kZXggZjA0NGFlNS4uNTg1ZTczZCAxMDA2NDQNCi0tLSBh
L25ldC84MDIxcS92bGFuX2Rldi5jDQorKysgYi9uZXQvODAyMXEvdmxhbl9kZXYuYw0KQEAgLTU4
Miw2ICs1ODIsNyBAQCBzdGF0aWMgaW50IHZsYW5fZGV2X2luaXQoc3RydWN0IG5ldF9kZXZpY2Ug
KmRldikNCiANCiAJZGV2LT52bGFuX2ZlYXR1cmVzID0gcmVhbF9kZXYtPnZsYW5fZmVhdHVyZXMg
JiB+TkVUSUZfRl9BTExfRkNPRTsNCiAJZGV2LT5od19lbmNfZmVhdHVyZXMgPSB2bGFuX3RubF9m
ZWF0dXJlcyhyZWFsX2Rldik7DQorCWRldi0+bXBsc19mZWF0dXJlcyA9IHJlYWxfZGV2LT5tcGxz
X2ZlYXR1cmVzOw0KIA0KIAkvKiBpcHY2IHNoYXJlZCBjYXJkIHJlbGF0ZWQgc3R1ZmYgKi8NCiAJ
ZGV2LT5kZXZfaWQgPSByZWFsX2Rldi0+ZGV2X2lkOw0KLS0gDQoxLjguMy4xDQoNCg==
