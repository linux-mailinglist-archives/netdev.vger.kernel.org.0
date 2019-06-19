Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E024B5CE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfFSKCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:02:17 -0400
Received: from mail-eopbgr40122.outbound.protection.outlook.com ([40.107.4.122]:51326
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfFSKCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 06:02:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R3/DfLeWtBK0rONwx/vvXic/zkqzi9q3WzjJjlOcDs=;
 b=ZGvkIJ+cVRc1MuoI75Qi1fKG3QEb3Baw4c0ddAivhav1zjUe+1A7GsRX0/68XdYcEO7dzVTGfKZQavon5ls8d5uNAA1gg3zd6ENWwAmCkcRoBra3/wF0rBpKNXhJnBkkW4k4iXdqVQY1HU526W/EhZh1bSOzhrtEFpX+dQKQrfY=
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (10.255.30.92) by
 AM0PR10MB2450.EURPRD10.PROD.OUTLOOK.COM (20.177.110.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 10:02:13 +0000
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4c4f:7a8e:cfcc:5d5a]) by AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4c4f:7a8e:cfcc:5d5a%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 10:02:13 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6185_g1_vtu_loadpurge()
Thread-Topic: [PATCH net] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6185_g1_vtu_loadpurge()
Thread-Index: AQHVJoYRfeUHVxjOPU6bwM7pmbWvXQ==
Date:   Wed, 19 Jun 2019 10:02:13 +0000
Message-ID: <20190619100203.11749-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0102CA0064.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:7d::41) To AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:160::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ded65fa4-4417-4312-1b7c-08d6f49d3354
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB2450;
x-ms-traffictypediagnostic: AM0PR10MB2450:
x-microsoft-antispam-prvs: <AM0PR10MB2450E7189F5D4399357A1D368AE50@AM0PR10MB2450.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(39850400004)(376002)(136003)(199004)(189003)(3846002)(6116002)(5660300002)(25786009)(6436002)(6486002)(8936002)(8976002)(71190400001)(4326008)(71200400001)(53936002)(14444005)(256004)(2906002)(4744005)(6512007)(36756003)(1076003)(99286004)(66556008)(64756008)(66446008)(73956011)(66946007)(305945005)(66066001)(52116002)(74482002)(7736002)(66476007)(81166006)(81156014)(26005)(186003)(14454004)(2616005)(476003)(486006)(102836004)(8676002)(50226002)(6506007)(68736007)(316002)(386003)(44832011)(110136005)(54906003)(42882007)(72206003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2450;H:AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r02zuaGvRfOM6onJfAVE7iK6odJjkWbLUmcELT+lRcE57X35edCkQK2KCqiWtqNcfnaoWpvwa5NRqq+oKHmJBJI8epj/5UyOsa2IT9HcOwEft8WtoEHwCxxmp63X//zymfr0D4HfMycgWOx/LZ2rDOSTrido/ZpnVcMqCWPO9yH4dO9HR4yc0Ydyk2Gki/wvOpq7Nwi4sMU1hNMKld5b/jgATiQsGYg9mren5Yt8JeaMzvhAEmn5Sd7ImxDZKnj7JILUIFZrPQn8jk5I35q7RIWz65KeiV3a452DVt7HSv2MqUhn9im8kWWsctLHW9hKcnSHYivBxvg3a0oMxcRBUA4zeH9tdkjyqp1gQQJvCb8i+Hzbp8jXnffVtks10c4rlJNJ7AzaUD0URgABEB0KJC8pVObQSmdBZVg8dyGCqSg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: ded65fa4-4417-4312-1b7c-08d6f49d3354
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 10:02:13.2663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGNvbW1lbnQgaXMgY29ycmVjdCwgYnV0IHRoZSBjb2RlIGVuZHMgdXAgbW92aW5nIHRoZSBi
aXRzIGZvdXINCnBsYWNlcyB0b28gZmFyLCBpbnRvIHRoZSBWVFVPcCBmaWVsZC4NCg0KRml4ZXM6
IDExZWE4MDlmMWE3NCAobmV0OiBkc2E6IG12ODhlNnh4eDogc3VwcG9ydCAyNTYgZGF0YWJhc2Vz
KQ0KU2lnbmVkLW9mZi1ieTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2
YXMuZGs+DQotLS0NCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMgfCAy
ICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMgYi9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMNCmluZGV4IDRmN2I1MjJlNWU1OS4u
NzY0Mzc4ZGNiYzBjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9i
YWwxX3Z0dS5jDQorKysgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMN
CkBAIC00NzMsNyArNDczLDcgQEAgaW50IG12ODhlNjE4NV9nMV92dHVfbG9hZHB1cmdlKHN0cnVj
dCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJCSAqIFZUVSBEQk51bVs3OjRdIGFyZSBsb2NhdGVk
IGluIFZUVSBPcGVyYXRpb24gMTE6OA0KIAkJICovDQogCQlvcCB8PSBlbnRyeS0+ZmlkICYgMHgw
MDBmOw0KLQkJb3AgfD0gKGVudHJ5LT5maWQgJiAweDAwZjApIDw8IDg7DQorCQlvcCB8PSAoZW50
cnktPmZpZCAmIDB4MDBmMCkgPDwgNDsNCiAJfQ0KIA0KIAlyZXR1cm4gbXY4OGU2eHh4X2cxX3Z0
dV9vcChjaGlwLCBvcCk7DQotLSANCjIuMjAuMQ0KDQo=
