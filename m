Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C443B2A138
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404462AbfEXW1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:35 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:32916
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404421AbfEXW1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 18:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHTpNX/9HtwuZ2OPp+C+3MdRhI8Sb79JfX2p81AA7t0=;
 b=o1G/iLPfwl82BHhTWEXvf0RC4z5TtIgvZEA6dyKjgO+xYVRnclS7YQ0mlSVbWFHp4xynfqxUmvmneqCTbQdacJnOfCs9yBhoEz6CT/VRRGQVUbrhTVnPWog0giS0hXciNyzMfJXWsAxdqoGtvdLPEqJuWqLEywbbQthQaq69PLM=
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com (10.170.238.141) by
 VI1PR05MB5039.eurprd05.prod.outlook.com (20.177.52.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 22:27:24 +0000
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092]) by VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092%4]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 22:27:24 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH RFC 2/2] net: vlan: Inherit MPLS features from parent device
Thread-Topic: [PATCH RFC 2/2] net: vlan: Inherit MPLS features from parent
 device
Thread-Index: AQHVEn/cEOSSiGcu60GqnjvwcH/Kwg==
Date:   Fri, 24 May 2019 22:27:24 +0000
Message-ID: <1558736809-23258-3-git-send-email-lariel@mellanox.com>
References: <1558736809-23258-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1558736809-23258-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0457.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::13) To VI1PR05MB3328.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f50d136-479c-4148-b4b9-08d6e096fe8d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600147)(711020)(4605104)(1401326)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5039;
x-ms-traffictypediagnostic: VI1PR05MB5039:
x-microsoft-antispam-prvs: <VI1PR05MB5039A4FD32CA914E020972DCBA020@VI1PR05MB5039.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(396003)(346002)(199004)(189003)(66556008)(66946007)(66476007)(305945005)(4326008)(76176011)(64756008)(107886003)(66446008)(2501003)(25786009)(4720700003)(5660300002)(86362001)(81156014)(478600001)(8676002)(81166006)(386003)(102836004)(1730700003)(186003)(2906002)(14444005)(26005)(50226002)(316002)(6506007)(14454004)(8936002)(256004)(6486002)(6436002)(476003)(36756003)(53936002)(7736002)(2616005)(71190400001)(73956011)(5640700003)(71200400001)(99286004)(446003)(11346002)(3846002)(68736007)(6512007)(6116002)(6916009)(2351001)(486006)(66066001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5039;H:VI1PR05MB3328.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q3huX3PBe/PhscEPE3y+L0QilIseyZZzohdeEG6LaCjLQic5i8mq2HvWwEjrYQyWwyxcQkLR+LhxV+woyzjUpe0sSJir0lbw/jpjxdQEYxQg0sWM+vcWRb3X9kljwY6/lhwxe+sICHe8THHA34IGG9CNJL1Jnig8aX5nJ56G5ZV5s7KPzRHIKWclKwLduR59200/ng4ISNIV2W3bk5q/4946/U7iwe1EfMGDpOuq2+NZiq/uMmpzQDVda8kmhNr526pQxbOeJf+ura2U7mECZ5r1PWEVJdhYi8zo5ANhWssJfU4Qciwc6q2DY+IjTR6ugbUf8tiCXR85v+czRMrl9n/uNHAhxf5BD+gyITBjJBeRMIOnJnuLeNSQ0QkfTF/XssW1QkAVaBTCSZ1yamKg+FlyTYq5mzcVJdnpNvTs8S8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f50d136-479c-4148-b4b9-08d6e096fe8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 22:27:24.3677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5039
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
