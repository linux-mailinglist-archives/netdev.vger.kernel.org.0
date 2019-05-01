Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA72610D3F
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfEATcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:13 -0400
Received: from mail-eopbgr30097.outbound.protection.outlook.com ([40.107.3.97]:30801
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbfEATcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 15:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71zvAjfjH4ynzyTNwTZNTXZbkluTFWQskiJa8JJCtyg=;
 b=JXps+lMjeyuO2IllpHPjSxxFmSRfvJ0IWQO80qRD0pvsTU3IkuoQ539RZz2obSy4VXocqabGKIEB5yhCAVg+fow73kDJvgbf+RPkyhvFWu+Wohs4xZVrB6bEG2vD35demQw4+Ed+a25ajDbPmJvWRDXn/2sdjpBSRGP+9fof/cE=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM (20.177.62.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Wed, 1 May 2019 19:32:09 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 19:32:09 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [RFC PATCH 0/5] net: dsa: POC support for mv88e6250
Thread-Topic: [RFC PATCH 0/5] net: dsa: POC support for mv88e6250
Thread-Index: AQHVAFSRHIigUpvFEU28a9MAvy8A0g==
Date:   Wed, 1 May 2019 19:32:08 +0000
Message-ID: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0005.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::15) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [5.186.118.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af794b5c-9b3f-42ac-0d2c-08d6ce6bb36c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2382;
x-ms-traffictypediagnostic: VI1PR10MB2382:
x-microsoft-antispam-prvs: <VI1PR10MB2382D8EBE914A65BD38E4FC58A3B0@VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(199004)(81166006)(6512007)(14454004)(186003)(50226002)(8676002)(107886003)(66066001)(3846002)(71190400001)(4326008)(6116002)(8976002)(478600001)(54906003)(81156014)(1076003)(8936002)(25786009)(71446004)(4744005)(72206003)(316002)(73956011)(71200400001)(305945005)(74482002)(68736007)(66476007)(44832011)(486006)(64756008)(53936002)(66446008)(66556008)(256004)(99286004)(110136005)(6436002)(386003)(476003)(6486002)(7736002)(26005)(6506007)(42882007)(2906002)(66946007)(2616005)(36756003)(52116002)(102836004)(5660300002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2382;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CjwG8b9lOF0UVv7wOqrphgQDJMH9BYBIk8i00CJV9UEusx6Ag4rK9+3wZlWzZ3f3wnLWf49k0vSlqMLLZQmh9cYx5f5OQnPxMk5lmOmFiIYLs9ndajG6ZjaMaDvmEJtHw/cF6wrLONdQXl09WRr8/b1v+EbpHHiRFuY4gMNavg4YZSrhU0I0mfHj9/zvT5S+uZg9aO/6zcLWqeYpQooCsfTJ45TCJ4QU3ViqkQuw6OHbwkHPRPH/0zY88oAUIVjXdZDQt7turrNa1ls2zpj6e+3/C7wrOGSNy7ANO3Ieyb0uWFwfhBxs2c3V6CJ1hz2GSoaws95qMlBxAgal0EHDoN9ixEP30q3eb/GRY1a5xEyc4ikOS/v8HTL50psWEd6zyXY6Z1zFUgMyBKdzcpzKx5dQ/Psv53ZUpbnz4jWSqqY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: af794b5c-9b3f-42ac-0d2c-08d6ce6bb36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 19:32:08.9481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBzb21lIG1vc3RseS13b3JraW5nIGNvZGUgYWRkaW5nIHN1cHBvcnQgZm9yIHRoZSBt
djg4ZTYyNTANCmNoaXAuIEknbSBub3QgcXVpdGUgZG9uZSBjaGVja2luZyB3aGV0aGVyIGFsbCB0
aGUgbWV0aG9kcyBpbiB0aGUgX29wcw0Kc3RydWN0dXJlIGFyZSBhcHByb3ByaWF0ZSwgYnV0IGJh
c2ljIHN3aXRjaGRldiBmdW5jdGlvbmFsaXR5IHNlZW1zIHRvDQp3b3JrLg0KDQpSYXNtdXMgVmls
bGVtb2VzICg1KToNCiAgbmV0OiBkc2E6IG12ODhlNnh4eDogaW50cm9kdWNlIHN1cHBvcnQgZm9y
IHR3byBjaGlwcyB1c2luZyBkaXJlY3Qgc21pDQogICAgYWRkcmVzc2luZw0KICBuZXQ6IGRzYTog
bXY4OGU2eHh4OiByZW5hbWUgc21pIHJlYWQvd3JpdGUgZnVuY3Rpb25zDQogIG5ldDogZHNhOiBw
cmVwYXJlIG12ODhlNnh4eF9nMV9hdHVfb3AoKSBmb3IgdGhlIG12ODhlNjI1MA0KICBuZXQ6IGRz
YTogaW1wbGVtZW50IHZ0dV9nZXRuZXh0IGFuZCB2dHVfbG9hZHB1cmdlIGZvciBtdjg4ZTYyNTAN
CiAgbmV0OiBkc2E6IGFkZCBzdXBwb3J0IGZvciBtdjg4ZTYyNTANCg0KIGRyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvY2hpcC5jICAgICAgICB8IDEyNSArKysrKysrKysrKysrKysrKysrLS0tLS0N
CiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuaCAgICAgICAgfCAgIDcgKysNCiBkcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYyAgICAgfCAgMjAgKysrKw0KIGRyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oICAgICB8ICAgNSArDQogZHJpdmVycy9uZXQvZHNh
L212ODhlNnh4eC9nbG9iYWwxX2F0dS5jIHwgICA1ICstDQogZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9nbG9iYWwxX3Z0dS5jIHwgIDU4ICsrKysrKysrKysrDQogZHJpdmVycy9uZXQvZHNhL212
ODhlNnh4eC9wb3J0LmggICAgICAgIHwgICAxICsNCiA3IGZpbGVzIGNoYW5nZWQsIDE5NiBpbnNl
cnRpb25zKCspLCAyNSBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjIwLjENCg0K
