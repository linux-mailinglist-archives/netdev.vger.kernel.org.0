Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE0504A3
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfFXIeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:34:18 -0400
Received: from mail-eopbgr30120.outbound.protection.outlook.com ([40.107.3.120]:37738
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfFXIeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 04:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtW8TNwL3nMci6PXQxTPxjx9kVsYY9xkqlI7JvXxawk=;
 b=EMfpHTNXGZBph+0eQj0rrr/Cmds27ksRe6yK3Kq78jl4fXoNz8NIVvi1w8Hk/U2l06FHvorhVRXbLuWeaoSFFQUvX4dyS0wbn7IDpz8Zy5Nzw9CMh7IZ9ry5NS47iChnFBI2tK8109eb/xsamrUqcNxiFEq5E+2ylU/X1NAYiIQ=
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (10.255.30.92) by
 AM0PR10MB2387.EURPRD10.PROD.OUTLOOK.COM (20.177.109.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 08:34:14 +0000
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162]) by AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162%7]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 08:34:14 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Topic: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Index: AQHVKmeahsDxJm0SfUSG50fnY2XQSw==
Date:   Mon, 24 Jun 2019 08:34:13 +0000
Message-ID: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR07CA0020.eurprd07.prod.outlook.com
 (2603:10a6:7:67::30) To AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:160::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0c1c281-f7d6-4fcf-9550-08d6f87ebcbb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB2387;
x-ms-traffictypediagnostic: AM0PR10MB2387:
x-microsoft-antispam-prvs: <AM0PR10MB2387FDA80145DEC038003EF48AE00@AM0PR10MB2387.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(376002)(39840400004)(346002)(199004)(189003)(26005)(102836004)(66946007)(36756003)(110136005)(71200400001)(42882007)(25786009)(8676002)(81166006)(81156014)(54906003)(486006)(8976002)(305945005)(4326008)(316002)(3846002)(71190400001)(53936002)(6116002)(256004)(8936002)(7736002)(6512007)(478600001)(4744005)(64756008)(66446008)(186003)(74482002)(1076003)(66066001)(99286004)(6506007)(386003)(6436002)(44832011)(50226002)(73956011)(6486002)(68736007)(476003)(2616005)(5660300002)(2906002)(14454004)(72206003)(66476007)(66556008)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2387;H:AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 36SNkUwLObqVNjHz4gVlASaEBdUGy2H9fXgLftHwYRAPE5AhDrKr8BxznJsK2CLwfNRqPjaAxfdGHbD9qeK7GioZ2Qn0J4my8W3y2xseacTd3Wn/hks+IvVz1Lfgot2h/BXzTrqXBpD7aanBAe+OwaW5MGDN/qI2rMPR6xSLWJKiHqDVCr0pHhj0JNimiwHmx0DgYkPVkrtij64l/SdV+2RA/cDmbbnnwk9W0gX/MTw6FyN8WPyplWQHiLYhoPLq3nBUxRTsoHC4Yze6F92L+qfqFo03zprUbG+IVfPMD9uPsjS4iVgBW88hNYJzgtHo4gq9lpTkzEPWDmgl1HDn4zHopVtypGNWkT2yRZoxfXA/D2AY2hpOX49tB8pqPA84qsvBgPYTfxL35fo2A/hGsBKQEBUxRfrms+Q/ynZLebw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c1c281-f7d6-4fcf-9550-08d6f87ebcbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 08:34:13.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2387
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q09ORklHX0NBTl9MRURTIGlzIGRlcHJlY2F0ZWQuIFdoZW4gdHJ5aW5nIHRvIHVzZSB0aGUgZ2Vu
ZXJpYyBuZXRkZXYNCnRyaWdnZXIgYXMgc3VnZ2VzdGVkLCB0aGVyZSdzIGEgc21hbGwgaW5jb25z
aXN0ZW5jeSB3aXRoIHRoZSBsaW5rDQpwcm9wZXJ0eTogVGhlIExFRCBpcyBvbiBpbml0aWFsbHks
IHN0YXlzIG9uIHdoZW4gdGhlIGRldmljZSBpcyBicm91Z2h0DQp1cCwgYW5kIHRoZW4gdHVybnMg
b2ZmIChhcyBleHBlY3RlZCkgd2hlbiB0aGUgZGV2aWNlIGlzIGJyb3VnaHQgZG93bi4NCg0KTWFr
ZSBzdXJlIHRoZSBMRUQgYWx3YXlzIHJlZmxlY3RzIHRoZSBzdGF0ZSBvZiB0aGUgQ0FOIGRldmlj
ZS4NCg0KU2lnbmVkLW9mZi1ieTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0Bw
cmV2YXMuZGs+DQotLS0NCiBkcml2ZXJzL25ldC9jYW4vZGV2LmMgfCAxICsNCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9kZXYu
YyBiL2RyaXZlcnMvbmV0L2Nhbi9kZXYuYw0KaW5kZXggYzA1ZTRkNTBkNDNkLi5mYWQyN2FjZTYy
NDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9jYW4vZGV2LmMNCisrKyBiL2RyaXZlcnMvbmV0
L2Nhbi9kZXYuYw0KQEAgLTEyNjAsNiArMTI2MCw3IEBAIGludCByZWdpc3Rlcl9jYW5kZXYoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldikNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAlkZXYtPnJ0bmxf
bGlua19vcHMgPSAmY2FuX2xpbmtfb3BzOw0KKwluZXRpZl9jYXJyaWVyX29mZihkZXYpOw0KIAly
ZXR1cm4gcmVnaXN0ZXJfbmV0ZGV2KGRldik7DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHJlZ2lz
dGVyX2NhbmRldik7DQotLSANCjIuMjAuMQ0KDQo=
