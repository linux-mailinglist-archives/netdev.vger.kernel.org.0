Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992E034049
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfFDHfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:35:12 -0400
Received: from mail-eopbgr50125.outbound.protection.outlook.com ([40.107.5.125]:15586
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726719AbfFDHfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6BHss+HZx9fDVHZ//L79DuH6RnqEY4+s8IE+pQ1cz4=;
 b=iqgIOjvVtcoHHkcjyqHe4hz3jvoi8f+bjda2ATNncOTRvL/3onEY1mDmL69vCW1X2U0RpMTymvAzADl2gwaoBxxK0YMDd+WUTA+fut7ECjLcVClmaxfJrm19xDx0ot5TUEJEG5l5aALwGYi17w561c474OF75eBozqlTDJecrw4=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM (10.255.17.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:22 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:22 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [PATCH net-next v4 00/10] net: dsa: mv88e6xxx: support for mv88e6250
Thread-Topic: [PATCH net-next v4 00/10] net: dsa: mv88e6xxx: support for
 mv88e6250
Thread-Index: AQHVGqftsl1YP7nTFUS4ZaU4A3wHoQ==
Date:   Tue, 4 Jun 2019 07:34:22 +0000
Message-ID: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: 8a8587a7-f6f0-4410-74a2-08d6e8bf0fc8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR10MB3435;
x-ms-traffictypediagnostic: DB8PR10MB3435:
x-microsoft-antispam-prvs: <DB8PR10MB343542A2D940A3CFC86207AC8A150@DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39850400004)(396003)(189003)(199004)(5660300002)(66446008)(73956011)(2501003)(66476007)(66556008)(66946007)(64756008)(99286004)(66066001)(386003)(6506007)(8976002)(52116002)(110136005)(316002)(7736002)(305945005)(81166006)(81156014)(8676002)(8936002)(476003)(74482002)(486006)(2616005)(256004)(44832011)(14444005)(186003)(42882007)(71190400001)(1076003)(102836004)(71200400001)(50226002)(6436002)(26005)(36756003)(478600001)(25786009)(6486002)(68736007)(6116002)(3846002)(53936002)(2906002)(6512007)(2201001)(72206003)(107886003)(14454004)(4326008)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3435;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j4b7QEF7sa4TTgvnkfMGO/au8rM9v6MRKVbrO7oOnqxMqHGmf1w6g3rtDgi0/o6TaJKW1nBZhCIH424BtQo5QZrg75Yp1VoOwR//37PcsR/yRioR1rYx/1rQ6EexP5t3rLo0MALs2FjG3o6AJhKV1oUyIknjk1ZDpnspG9up8mxoXXF/0XFuGpYIE4jHW59ba//RSWfpXoB2dpnsvX1DEkyEM0UC8JgtpYY8X2Ujw3kk68DUvGKBRam6OP/MqLDrLm26c0T1JhcDyqh7IMvqopSj5PrRCfBAUmKRUNKrY1nLAwGn9Y/VLqgNwnT5dE31vdyt0vOHUUOD9YGifQkgLpoG8DyWEcOc1JNgtEdyd4/b3T2m+Ch5aiRCxfMcKPoG1C3JC9L+e+/ccGB/qV+5qVtuEkYVpe8dpyStbfpMSTU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8587a7-f6f0-4410-74a2-08d6e8bf0fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:22.3994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3435
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHN1cHBvcnQgZm9yIHRoZSBtdjg4ZTYyNTAgY2hpcC4gSW5pdGlhbGx5IGJhc2Vk
IG9uIHRoZQ0KbXY4OGU2MjQwLCB0aGlzIHRpbWUgYXJvdW5kLCBJJ3ZlIGJlZW4gdGhyb3VnaCBl
YWNoIC0+b3BzIGNhbGxiYWNrIGFuZA0KY2hlY2tlZCB0aGF0IGl0IG1ha2VzIHNlbnNlLCBlaXRo
ZXIgcmVwbGFjaW5nIHdpdGggYSA2MjUwIHNwZWNpZmljDQp2YXJpYW50IG9yIGRyb3BwaW5nIGl0
IGlmIG5vIGVxdWl2YWxlbnQgZnVuY3Rpb25hbGl0eSBzZWVtcyB0byBleGlzdA0KZm9yIHRoZSA2
MjUwLiBBbG9uZyB0aGUgd2F5LCBJIGZvdW5kIGEgZmV3IG9kZGl0aWVzIGluIHRoZSBleGlzdGlu
Zw0KY29kZSwgbW9zdGx5IHNlbnQgYXMgc2VwYXJhdGUgcGF0Y2hlcy9xdWVzdGlvbnMuDQoNClRo
ZSBvbmUgcmVsZXZhbnQgdG8gdGhlIDYyNTAgaXMgdGhlIGllZWVfcHJpX21hcCBjYWxsYmFjaywg
d2hlcmUgdGhlDQpleGlzdGluZyBtdjg4ZTYwODVfZzFfaWVlZV9wcmlfbWFwKCkgaXMgYWN0dWFs
bHkgd3JvbmcgZm9yIG1hbnkgb2YgdGhlDQpleGlzdGluZyB1c2Vycy4gSSd2ZSBwdXQgdGhlIG12
ODhlNjI1MF9nMV9pZWVlX3ByaV9tYXAoKSBwYXRjaCBmaXJzdA0KaW4gY2FzZSBzb21lIG9mIHRo
ZSBleGlzdGluZyBjaGlwcyBnZXQgc3dpdGNoZWQgb3ZlciB0byB1c2UgdGhhdCBhbmQNCml0IGlz
IGRlZW1lZCBpbXBvcnRhbnQgZW5vdWdoIGZvciAtc3RhYmxlLg0KDQp2NDoNCi0gZml4IHN0eWxl
IGlzc3VlIGluIDEvMTANCi0gYWRkIEFuZHJldydzIHJldmlld2VkLWJ5IHRvIDEsNiw3LDgsOSwx
MC4NCg0KdjM6DQotIHJlYmFzZSBvbiB0b3Agb2YgbmV0LW5leHQvbWFzdGVyDQotIGFkZCByZXZp
ZXdlZC1ieXMgdG8gcGF0Y2hlcyB1bmNoYW5nZWQgZnJvbSB2MiAoMiwzLDQsNSkNCi0gYWRkIDYy
NTAtc3BlY2lmaWMgLT5pZWVlX3ByaV9tYXAsIC0+cG9ydF9zZXRfc3BlZWQsIC0+cG9ydF9saW5r
X3N0YXRlICgxLDYsNykNCi0gaW4gYWRkaXRpb24sIHVzZSBtdjg4ZTYwNjVfcGh5bGlua192YWxp
ZGF0ZSBmb3IgLT5waHlsaW5rX3ZhbGlkYXRlLA0KICBhbmQgZG9uJ3QgaW1wbGVtZW50IC0+cG9y
dF9nZXRfY21vZGUsIC0+cG9ydF9zZXRfanVtYm9fc2l6ZSwNCiAgLT5wb3J0X2Rpc2FibGVfbGVh
cm5fbGltaXQsIC0+cm11X2Rpc2FibGUNCi0gZHJvcCBwdHAgc3VwcG9ydA0KLSBhZGQgcGF0Y2gg
YWRkaW5nIHRoZSBjb21wYXRpYmxlIHN0cmluZyB0byB0aGUgRFQgYmluZGluZyAoOSkNCi0gYWRk
IHNtYWxsIHJlZmFjdG9yaW5nIHBhdGNoICgxMCkNCg0KdjI6DQotIHJlYmFzZSBvbiB0b3Agb2Yg
bmV0LW5leHQvbWFzdGVyDQotIGFkZCByZXZpZXdlZC1ieSB0byB0d28gcGF0Y2hlcyB1bmNoYW5n
ZWQgZnJvbSB2MSAoMiwzKQ0KLSBhZGQgc2VwYXJhdGUgd2F0Y2hkb2dfb3BzDQoNClJhc211cyBW
aWxsZW1vZXMgKDEwKToNCiAgbmV0OiBkc2E6IG12ODhlNnh4eDogYWRkIG12ODhlNjI1MF9nMV9p
ZWVlX3ByaV9tYXANCiAgbmV0OiBkc2E6IG12ODhlNnh4eDogaW50cm9kdWNlIHN1cHBvcnQgZm9y
IHR3byBjaGlwcyB1c2luZyBkaXJlY3Qgc21pDQogICAgYWRkcmVzc2luZw0KICBuZXQ6IGRzYTog
bXY4OGU2eHh4OiBwcmVwYXJlIG12ODhlNnh4eF9nMV9hdHVfb3AoKSBmb3IgdGhlIG12ODhlNjI1
MA0KICBuZXQ6IGRzYTogbXY4OGU2eHh4OiBpbXBsZW1lbnQgdnR1X2dldG5leHQgYW5kIHZ0dV9s
b2FkcHVyZ2UgZm9yDQogICAgbXY4OGU2MjUwDQogIG5ldDogZHNhOiBtdjg4ZTZ4eHg6IGltcGxl
bWVudCB3YXRjaGRvZ19vcHMgZm9yIG12ODhlNjI1MA0KICBuZXQ6IGRzYTogbXY4OGU2eHh4OiBp
bXBsZW1lbnQgcG9ydF9zZXRfc3BlZWQgZm9yIG12ODhlNjI1MA0KICBuZXQ6IGRzYTogbXY4OGU2
eHh4OiBpbXBsZW1lbnQgcG9ydF9saW5rX3N0YXRlIGZvciBtdjg4ZTYyNTANCiAgbmV0OiBkc2E6
IG12ODhlNnh4eDogYWRkIHN1cHBvcnQgZm9yIG12ODhlNjI1MA0KICBkdC1iaW5kaW5nczogbmV0
OiBkc2E6IG1hcnZlbGw6IGFkZCAibWFydmVsbCxtdjg4ZTYyNTAiIGNvbXBhdGlibGUNCiAgICBz
dHJpbmcNCiAgbmV0OiBkc2E6IG12ODhlNnh4eDogcmVmYWN0b3IgbXY4OGU2MzUyX2cxX3Jlc2V0
DQoNCiAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL21hcnZlbGwudHh0ICAgfCAgNyAr
LQ0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jICAgICAgICAgICAgICB8IDgxICsr
KysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuaCAgICAg
ICAgICAgICAgfCAgOCArKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jICAg
ICAgICAgICB8IDE3ICsrKy0NCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuaCAg
ICAgICAgICAgfCAgNyArKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUu
YyAgICAgICB8ICA1ICstDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX3Z0dS5j
ICAgICAgIHwgNTggKysrKysrKysrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xv
YmFsMi5jICAgICAgICAgICB8IDI2ICsrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
Z2xvYmFsMi5oICAgICAgICAgICB8IDE0ICsrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L3BvcnQuYyAgICAgICAgICAgICAgfCA3NyArKysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL25l
dC9kc2EvbXY4OGU2eHh4L3BvcnQuaCAgICAgICAgICAgICAgfCAxNCArKysrDQogZHJpdmVycy9u
ZXQvZHNhL212ODhlNnh4eC9zbWkuYyAgICAgICAgICAgICAgIHwgMjUgKysrKystDQogMTIgZmls
ZXMgY2hhbmdlZCwgMzMzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4y
MC4xDQoNCg==
