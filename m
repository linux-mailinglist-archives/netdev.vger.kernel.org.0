Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46BD33272
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfFCOmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:31 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:11233
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbfFCOma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6QMpieHLkvkyBIlb4nZPXfNl+s6uH/xyCLbzhLqwQw=;
 b=qg1uyDd0nZXfl4utkCEIWjxp69NJJBSyAqdbxgsm14Xl1TCyd1C/DUI1ZGl3IlxB0eKDpb/HxMEEzBPis6e4oAhFMYhcUTXa7uUYr3I8s3JKSIoCEJ2g0SkoeYlIBqiYNriPnq6htQVk69L7zd67lG+U+SCROIz0Uvvv2EUy6yc=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:19 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:19 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 06/10] net: dsa: mv88e6xxx: implement
 port_set_speed for mv88e6250
Thread-Topic: [PATCH net-next v3 06/10] net: dsa: mv88e6xxx: implement
 port_set_speed for mv88e6250
Thread-Index: AQHVGhqL87p2CfrdvkmC5ChBTRP4pg==
Date:   Mon, 3 Jun 2019 14:42:19 +0000
Message-ID: <20190603144112.27713-7-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:3:64::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c66e9dfe-cc66-4e18-b57c-08d6e831ade2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB25746191F3BE553C104FE3EA8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cIkRWDIfwWQKwQQxt77dJ+jTlkPS0Z2tHYsgLLQYxUCSEOOZFiArxcqL3bb8iCE8vXR3xB1M/HU9rQVHVw81syUq5h2XcZ3ZWNIZwTajojP/cdP8Ic4FUXJWtqzIZp+kUCByztI1DcfX7q+rFgRqOo6/FsCblh0zO/1AhlY6JbObFwHIfR7Tb5zl838/cG5WH3ORC+MvUmcRAgZfDwUVij6mLmAlwovzWvkXajtiQRk12y/2MIZzFngnzBLKPQyihXu+1lf4GUczmvi/7NuT45LQuaL3jgjyySOgKl0T39YGtKwz+KKgWldmKADdASCInLtOARGYeK+sbhUh8+LBp1PeHx1LDTc7DXguxWClKPnOKUVJz80nsRfPqx50uuMy4QheAWNi3AcU74KKClOFc4JEUVcobGYuO+1oQ0cy7cQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: c66e9dfe-cc66-4e18-b57c-08d6e831ade2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:19.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGRhdGEgc2hlZXQgYWxzbyBtZW50aW9ucyB0aGUgcG9zc2liaWxpdHkgb2Ygc2VsZWN0aW5n
IDIwMCBNYnBzIGZvcg0KdGhlIE1JSSBwb3J0cyAocG9ydHMgNSBhbmQgNikgYnkgc2V0dGluZyB0
aGUgRm9yY2VTcGQgZmllbGQgdG8NCjB4MiAoYWthIE1WODhFNjA2NV9QT1JUX01BQ19DVExfU1BF
RURfMjAwKS4gSG93ZXZlciwgdGhlcmUncyBhIG5vdGUNCnRoYXQgImFjdHVhbCBzcGVlZCBpcyBk
ZXRlcm1pbmVkIGJ5IGJpdCA4IGFib3ZlIiwgYW5kIGZsaXBwaW5nIGJhY2sgYQ0KcGFnZSwgb25l
IGZpbmRzIHRoYXQgYml0cyAxMzo4IGFyZSByZXNlcnZlZC4uLg0KDQpTbyB3aXRob3V0IGZ1cnRo
ZXIgaW5mb3JtYXRpb24gb24gd2hhdCBiaXQgOCBtZWFucywgbGV0J3Mgc3RpY2sgdG8NCnN1cHBv
cnRpbmcganVzdCAxMCBhbmQgMTAwIE1icHMgb24gYWxsIHBvcnRzLg0KDQpTaWduZWQtb2ZmLWJ5
OiBSYXNtdXMgVmlsbGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4NCi0tLQ0KIGRy
aXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5jIHwgMTIgKysrKysrKysrKysrDQogZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmggfCAgMSArDQogMiBmaWxlcyBjaGFuZ2VkLCAxMyBp
bnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3Bv
cnQuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5jDQppbmRleCBjNDRiMjgyMmU0
ZGQuLmE0MWJjYTE3Y2JhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
cG9ydC5jDQorKysgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3BvcnQuYw0KQEAgLTI5NCw2
ICsyOTQsMTggQEAgaW50IG12ODhlNjE4NV9wb3J0X3NldF9zcGVlZChzdHJ1Y3QgbXY4OGU2eHh4
X2NoaXAgKmNoaXAsIGludCBwb3J0LCBpbnQgc3BlZWQpDQogCXJldHVybiBtdjg4ZTZ4eHhfcG9y
dF9zZXRfc3BlZWQoY2hpcCwgcG9ydCwgc3BlZWQsIGZhbHNlLCBmYWxzZSk7DQogfQ0KIA0KKy8q
IFN1cHBvcnQgMTAsIDEwMCBNYnBzIChlLmcuIDg4RTYyNTAgZmFtaWx5KSAqLw0KK2ludCBtdjg4
ZTYyNTBfcG9ydF9zZXRfc3BlZWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9y
dCwgaW50IHNwZWVkKQ0KK3sNCisJaWYgKHNwZWVkID09IFNQRUVEX01BWCkNCisJCXNwZWVkID0g
MTAwOw0KKw0KKwlpZiAoc3BlZWQgPiAxMDApDQorCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQorDQor
CXJldHVybiBtdjg4ZTZ4eHhfcG9ydF9zZXRfc3BlZWQoY2hpcCwgcG9ydCwgc3BlZWQsIGZhbHNl
LCBmYWxzZSk7DQorfQ0KKw0KIC8qIFN1cHBvcnQgMTAsIDEwMCwgMjAwLCAxMDAwLCAyNTAwIE1i
cHMgKGUuZy4gODhFNjM0MSkgKi8NCiBpbnQgbXY4OGU2MzQxX3BvcnRfc2V0X3NwZWVkKHN0cnVj
dCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGludCBzcGVlZCkNCiB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmggYi9kcml2ZXJzL25ldC9kc2Ev
bXY4OGU2eHh4L3BvcnQuaA0KaW5kZXggMzljODVlOThmYjkyLi4xOTU3ZTNlMWNmNDcgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3BvcnQuaA0KKysrIGIvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9wb3J0LmgNCkBAIC0yNzksNiArMjc5LDcgQEAgaW50IG12ODhlNnh4
eF9wb3J0X3NldF9kdXBsZXgoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9ydCwg
aW50IGR1cCk7DQogDQogaW50IG12ODhlNjA2NV9wb3J0X3NldF9zcGVlZChzdHJ1Y3QgbXY4OGU2
eHh4X2NoaXAgKmNoaXAsIGludCBwb3J0LCBpbnQgc3BlZWQpOw0KIGludCBtdjg4ZTYxODVfcG9y
dF9zZXRfc3BlZWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9ydCwgaW50IHNw
ZWVkKTsNCitpbnQgbXY4OGU2MjUwX3BvcnRfc2V0X3NwZWVkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hp
cCAqY2hpcCwgaW50IHBvcnQsIGludCBzcGVlZCk7DQogaW50IG12ODhlNjM0MV9wb3J0X3NldF9z
cGVlZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsIGludCBwb3J0LCBpbnQgc3BlZWQpOw0K
IGludCBtdjg4ZTYzNTJfcG9ydF9zZXRfc3BlZWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlw
LCBpbnQgcG9ydCwgaW50IHNwZWVkKTsNCiBpbnQgbXY4OGU2MzkwX3BvcnRfc2V0X3NwZWVkKHN0
cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGludCBzcGVlZCk7DQotLSANCjIu
MjAuMQ0KDQo=
