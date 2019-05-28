Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0392C79E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfE1NRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:17:15 -0400
Received: from mail-eopbgr60136.outbound.protection.outlook.com ([40.107.6.136]:43908
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbfE1NRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 09:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHaZaOGYis4KUJX+dj+xYfH+RUarnUbgfcxFKteJuDk=;
 b=rjLhNF413AXMyNfpdMMe/53pMOTxEB1wTf+Tr/TGMJvqIOYW/bvuVHmDlEHFVxh1mTczbOZY0uFF0bgmldtfbcIB6cBm37DarzO3MSVkqHiY/1ue9nGs/oAw49pC6BnkmQltTw3HdcdwGfWtjoBFq/3IV2pdWqNukZvHWFJ1w30=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2368.EURPRD10.PROD.OUTLOOK.COM (20.177.62.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 13:17:11 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 13:17:11 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Thread-Topic: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Thread-Index: AQHVFVeoJSehSdMxnEmrURHzmpsI7Q==
Date:   Tue, 28 May 2019 13:17:10 +0000
Message-ID: <20190528131701.23912-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR02CA0113.eurprd02.prod.outlook.com
 (2603:10a6:7:29::42) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6391135-acc7-4100-e3b3-08d6e36eca7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR10MB2368;
x-ms-traffictypediagnostic: VI1PR10MB2368:
x-microsoft-antispam-prvs: <VI1PR10MB23689EF0439B2785C157D0C88A1E0@VI1PR10MB2368.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(39850400004)(396003)(189003)(199004)(102836004)(3846002)(6116002)(386003)(6506007)(256004)(66446008)(64756008)(66556008)(66476007)(73956011)(71190400001)(71200400001)(8936002)(8976002)(7736002)(14444005)(26005)(81166006)(81156014)(8676002)(6436002)(305945005)(6486002)(186003)(52116002)(2906002)(4744005)(5660300002)(50226002)(99286004)(25786009)(1076003)(72206003)(44832011)(14454004)(74482002)(66946007)(53936002)(316002)(478600001)(4326008)(68736007)(6512007)(486006)(2616005)(110136005)(54906003)(66066001)(36756003)(42882007)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2368;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XxG8nOCQO1Xo7HREx+GDdWuZYiiPYMBnDGxJOXjD9llatR0N8lB8kzgSpUgmm+nDuBFh7AYQhOdprzdqs+JxQBj5HiE/y2yo6/nc8YFqmk9XeJ9hDb2we8TNMKHmdH9Y74aG8PismEfxaOlF1BA9AKGik0nu+R42/AxXmKuIoSk4YjD0Tj9a/nDsicDECQS3nfckfkp/SWEHDnphl/7+3gWzjk2k5A7dY1YIi26wlmtjyaZ9Gk3oemLM6E/7PhfKnf61rcj3mzGPrLJNPiQDA28o9OtyV6Mgo6m7aUv5/Se7blSK6LIwhqZxmC4wv0ZJE5tlfNVXDqT4uKZ0QQo3UxIi/UFVhjjA2xgm73kYxMc+DSRBctU3HrexwnHPcYJxxXBoGQefasVRdaSNlDMtBZvLEpi7su1DlZs8wmiONTQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f6391135-acc7-4100-e3b3-08d6e36eca7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 13:17:10.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5LCB0aGUgdXBwZXIgaGFsZiBvZiBhIDQtYnl0ZSBTVEFUU19UWVBFX1BPUlQgc3Rh
dGlzdGljIGVuZHMNCnVwIGluIGJpdHMgNDc6MzIgb2YgdGhlIHJldHVybiB2YWx1ZSwgaW5zdGVh
ZCBvZiBiaXRzIDMxOjE2IGFzIHRoZXkNCnNob3VsZC4NCg0KU2lnbmVkLW9mZi1ieTogUmFzbXVz
IFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQotLS0NCkkgYWxzbyBub3Rp
Y2VkIHRoYXQgaXQncyBhIGJpdCBpbmNvbnNpc3RlbnQgdGhhdCB3ZSByZXR1cm4gVTY0X01BWCBp
Zg0KdGhlcmUncyBhIHJlYWQgZXJyb3IgaW4gU1RBVFNfVFlQRV9QT1JULCB3aGlsZQ0KbXY4OGU2
eHh4X2cxX3N0YXRzX3JlYWQoKSByZXR1cm5zIDAgaW4gY2FzZSBvZiBhIHJlYWQgZXJyb3IuIElu
DQpwcmFjdGljZSwgcmVnaXN0ZXIgcmVhZHMgcHJvYmFibHkgbmV2ZXIgZmFpbCBzbyBpdCBkb2Vz
bid0IG1hdHRlci4NCg0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jIHwgMiArLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgYi9kcml2ZXJzL25ldC9kc2Ev
bXY4OGU2eHh4L2NoaXAuYw0KaW5kZXggMzcwNDM0YmRiZGFiLi4zMTc1NTNkMmNiMjEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuYw0KKysrIGIvZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCkBAIC03ODUsNyArNzg1LDcgQEAgc3RhdGljIHVpbnQ2
NF90IF9tdjg4ZTZ4eHhfZ2V0X2V0aHRvb2xfc3RhdChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNo
aXAsDQogCQkJZXJyID0gbXY4OGU2eHh4X3BvcnRfcmVhZChjaGlwLCBwb3J0LCBzLT5yZWcgKyAx
LCAmcmVnKTsNCiAJCQlpZiAoZXJyKQ0KIAkJCQlyZXR1cm4gVTY0X01BWDsNCi0JCQloaWdoID0g
cmVnOw0KKwkJCWxvdyB8PSAoKHUzMilyZWcpIDw8IDE2Ow0KIAkJfQ0KIAkJYnJlYWs7DQogCWNh
c2UgU1RBVFNfVFlQRV9CQU5LMToNCi0tIA0KMi4yMC4xDQoNCg==
