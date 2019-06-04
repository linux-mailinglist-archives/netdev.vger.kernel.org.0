Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D391F34044
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfFDHep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:34:45 -0400
Received: from mail-eopbgr00119.outbound.protection.outlook.com ([40.107.0.119]:36579
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbfFDHeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=987R//YVqi0cvNOk97EH5a/ZpgvdUuDdRoXjuZJnUHI=;
 b=ShgZdwXnnxv/RXpXNdJZ8yNCRvmNrf5heMMGkBWLXJWwUTEfFg9WvRqrTJN5FofzId/3ItJHIUwcWG5j5xb2Aa6iSWtcX9Nd55X/CBVNi/5oqA7au657FFDr+Dpo4F5xNvufW74bvmRxKlV7gpRbvrI/F+/JSB5DfJkRZWklJfA=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM (10.255.19.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:35 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:35 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 10/10] net: dsa: mv88e6xxx: refactor
 mv88e6352_g1_reset
Thread-Topic: [PATCH net-next v4 10/10] net: dsa: mv88e6xxx: refactor
 mv88e6352_g1_reset
Thread-Index: AQHVGqf17q8Evgd5XEqT1Wmw3jFofQ==
Date:   Tue, 4 Jun 2019 07:34:35 +0000
Message-ID: <20190604073412.21743-11-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b::43)
 To DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 425e284d-7d2b-4322-e798-08d6e8bf1746
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3068;
x-ms-traffictypediagnostic: DB8PR10MB3068:
x-microsoft-antispam-prvs: <DB8PR10MB3068D77BE8B0F05E870B497E8A150@DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(136003)(376002)(396003)(346002)(189003)(199004)(4326008)(8976002)(8936002)(71200400001)(71190400001)(6436002)(6486002)(68736007)(446003)(486006)(2616005)(11346002)(81156014)(8676002)(66066001)(50226002)(36756003)(81166006)(42882007)(476003)(53936002)(186003)(52116002)(73956011)(76176011)(66946007)(66476007)(66556008)(64756008)(66446008)(99286004)(7736002)(44832011)(25786009)(72206003)(305945005)(478600001)(74482002)(1076003)(256004)(6512007)(102836004)(3846002)(26005)(6116002)(386003)(6506007)(316002)(14454004)(54906003)(5660300002)(2906002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3068;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wuvwoEh2CFRDNUDVjPMnWtGCBpk63MRGt856KIpBaYs/dLJ4R8Dpo0uu7dA0wlR/IEanckW076XcasqOdVTHmteQMb8awFcLE1N5OxdAo/aYgo5bmxwWQ90Id2WOMIpCLQpWVxisLEbYEEygk9TGStO6D8MmY++ZhbwTwWFh7T3pb8+hcdiZxBAnlLQfsb7DElul+OWblsoBvmpJhx74CkBI6Kqh4njR1CgVJNcS+CbjG3dHYpMdhA2OW0r1qZlJOst65HExaunuhrJdAVPuHzoiJgd6KktnbtDCyGpNZIEMJ+v60lL2T2nbcjn+xv4/TZnWY59b79rtvH+u/L42suC1XyHpBXMHPfKJ0sIh2chU+D1XW20pwasn5ojMsSkP7gQLecOwSIPV/M+sRz8L1P4l+kB9UoSUoN7qj7uzI/g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 425e284d-7d2b-4322-e798-08d6e8bf1746
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:35.1961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIG5ldyBtdjg4ZTYyNTBfZzFfcmVzZXQoKSBpcyBpZGVudGljYWwgdG8gbXY4OGU2MzUyX2cx
X3Jlc2V0KCkgZXhjZXB0DQpmb3IgdGhlIGNhbGwgb2YgbXY4OGU2MzUyX2cxX3dhaXRfcHB1X3Bv
bGxpbmcoKSwgc28gcmVmYWN0b3IgdGhlIDYzNTINCnZlcnNpb24gaW4gdGVybSBvZiB0aGUgNjI1
MCBvbmUuIE5vIGZ1bmN0aW9uYWwgY2hhbmdlLg0KDQpSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4g
PGFuZHJld0BsdW5uLmNoPg0KU2lnbmVkLW9mZi1ieTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVz
LnZpbGxlbW9lc0BwcmV2YXMuZGs+DQotLS0NCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2ds
b2JhbDEuYyB8IDE0ICstLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4
ZTZ4eHgvZ2xvYmFsMS5jIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCmlu
ZGV4IGZjMTBiNmU0OTVmNS4uNDFjMDc5MmEyZTJiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
Z2xvYmFsMS5jDQpAQCAtMjAzLDIxICsyMDMsOSBAQCBpbnQgbXY4OGU2MjUwX2cxX3Jlc2V0KHN0
cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCkNCiANCiBpbnQgbXY4OGU2MzUyX2cxX3Jlc2V0KHN0
cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCkNCiB7DQotCXUxNiB2YWw7DQogCWludCBlcnI7DQog
DQotCS8qIFNldCB0aGUgU1dSZXNldCBiaXQgMTUgKi8NCi0JZXJyID0gbXY4OGU2eHh4X2cxX3Jl
YWQoY2hpcCwgTVY4OEU2WFhYX0cxX0NUTDEsICZ2YWwpOw0KLQlpZiAoZXJyKQ0KLQkJcmV0dXJu
IGVycjsNCi0NCi0JdmFsIHw9IE1WODhFNlhYWF9HMV9DVEwxX1NXX1JFU0VUOw0KLQ0KLQllcnIg
PSBtdjg4ZTZ4eHhfZzFfd3JpdGUoY2hpcCwgTVY4OEU2WFhYX0cxX0NUTDEsIHZhbCk7DQotCWlm
IChlcnIpDQotCQlyZXR1cm4gZXJyOw0KLQ0KLQllcnIgPSBtdjg4ZTZ4eHhfZzFfd2FpdF9pbml0
X3JlYWR5KGNoaXApOw0KKwllcnIgPSBtdjg4ZTYyNTBfZzFfcmVzZXQoY2hpcCk7DQogCWlmIChl
cnIpDQogCQlyZXR1cm4gZXJyOw0KIA0KLS0gDQoyLjIwLjENCg0K
