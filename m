Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5AF4F5FA
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVNpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:45:14 -0400
Received: from mail-eopbgr790059.outbound.protection.outlook.com ([40.107.79.59]:57275
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbfFVNpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 09:45:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=332LcyWPNzL5Vu0V7/tOlT4fhCKQav50v6oO8isRVW0=;
 b=iRqieLQkd5qObBV1apgY4nOXaYxcuzf6PN3TnVk19IXxRjbwuKzj2URncTBgP2Wz/LKX6CXyJk7E4M/M2Iyconk1eYLfTdy2RLoiRPlMiRQVOGu0u2nNLgkyUJJTAUHsBNDjPLL8bl2r5czn58LDMj8FmjFb71ugwZUDhDuK7q4=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1389.namprd11.prod.outlook.com (10.169.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sat, 22 Jun 2019 13:45:10 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.014; Sat, 22 Jun 2019
 13:45:10 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 0/7] net: aquantia: implement vlan offloads
Thread-Topic: [PATCH net-next 0/7] net: aquantia: implement vlan offloads
Thread-Index: AQHVKQC1fAdoIXt1EUiVrjc9gdywZw==
Date:   Sat, 22 Jun 2019 13:45:10 +0000
Message-ID: <cover.1561210852.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::32) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 720ebcfc-fd95-4ad8-3f3e-08d6f717d7f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1389;
x-ms-traffictypediagnostic: MWHPR11MB1389:
x-microsoft-antispam-prvs: <MWHPR11MB1389AE3F8DA2148F608130C898E60@MWHPR11MB1389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(346002)(136003)(39840400004)(199004)(189003)(478600001)(68736007)(8676002)(486006)(7736002)(81166006)(2616005)(44832011)(81156014)(66066001)(14444005)(3846002)(256004)(72206003)(6116002)(50226002)(2906002)(99286004)(64756008)(66446008)(36756003)(86362001)(6916009)(66556008)(66476007)(73956011)(71190400001)(71200400001)(476003)(66946007)(54906003)(6486002)(53936002)(6512007)(52116002)(386003)(6506007)(5660300002)(25786009)(107886003)(305945005)(6436002)(316002)(8936002)(14454004)(4326008)(186003)(26005)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1389;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eKr0SFFgeVnUm29lhZq+1s6kAyOXOtPRvlfr6iUD+m+DSmF3Iav9tnCa0sN9eREEISfWVZwFxFqo0Fdd0WofOOLZqvjakU0hT1FRn5CRP5SlBHdgBEAj3ivN5QuSkwWheyJDkf1cbdYozgObNVzYD8kI26bnISNSoqSOVMU6R3hsfE+FVXz5TF42vwgmy8gCpMXMKY/q1yvWKsex7fDpuRE9wR1RZEjgLQQ3APlaaqtHAdQROghFKzORk5tMEz1lg/OGqC75CcjFxZGJQO/Qkk6vAxjnVSdFJ3bfPu8QnH5BAOsqnyfJBDB8D7rSugN2+eJhQEJl+Ibzt4mwNCeEUPyM32I869BswI7AlEUbJ7D0ff8Rtwl1ExSLbck/XfmxcCVFqnPaFm9rcefpazqZB6ipo9iaUSVMgnZxX4JeuvM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 720ebcfc-fd95-4ad8-3f3e-08d6f717d7f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 13:45:10.4920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIGhhcmR3YXJlIFZMQU4gb2ZmbG9hZCBzdXBwb3J0IGFu
ZCBhbHNvIGRvZXMgc29tZQ0KbWFpbnRlbmFuY2U6IHdlIHJlcGxhY2UgZHJpdmVyIHZlcnNpb24g
d2l0aCB1dHMgdmVyc2lvbiBzdHJpbmcsIGFkZA0KZG9jdW1lbnRhdGlvbiBmaWxlIGZvciBhdGxh
bnRpYyBkcml2ZXIsIGFuZCB1cGRhdGUgbWFpbnRhaW5lcnMNCmFkZGluZyBJZ29yIGFzIGEgbWFp
bnRhaW5lci4NCg0KSWdvciBSdXNza2lraCAoNyk6DQogIG5ldDogYXF1YW50aWE6IHJlcGxhY2Ug
aW50ZXJuYWwgZHJpdmVyIHZlcnNpb24gY29kZSB3aXRoIHV0cw0KICBuZXQ6IGFxdWFudGlhOiBh
ZGQgZG9jdW1lbnRhdGlvbiBmb3IgdGhlIGF0bGFudGljIGRyaXZlcg0KICBtYWludGFpbmVyczog
ZGVjbGFyZSBhcXVhbnRpYSBhdGxhbnRpYyBkcml2ZXIgbWFpbnRlbmFuY2UNCiAgbmV0OiBhcXVh
bnRpYTogYWRkZWQgdmxhbiBvZmZsb2FkIHJlbGF0ZWQgbWFjcm9zIGFuZCBmdW5jdGlvbnMNCiAg
bmV0OiBhcXVhbnRpYTogYWRkaW5nIGZpZWxkcyBhbmQgZGV2aWNlIGZlYXR1cmVzIGZvciB2bGFu
IG9mZmxvYWQNCiAgbmV0OiBhcXVhbnRpYTogdmxhbiBvZmZsb2FkcyBsb2dpYyBpbiBkYXRhcGF0
aA0KICBuZXQ6IGFxdWFudGlhOiBpbXBsZW1lbnQgdmxhbiBvZmZsb2FkIGNvbmZpZ3VyYXRpb24N
Cg0KIC4uLi9kZXZpY2VfZHJpdmVycy9hcXVhbnRpYS9hdGxhbnRpYy50eHQgICAgICB8IDQ1MSAr
KysrKysrKysrKysrKysrKysNCiBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDggKw0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
Y2ZnLmggICB8ICAgNyArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
bWFpbi5jICB8ICAzNCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
bmljLmMgICB8ICAyOCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
bmljLmggICB8ICAgMiArDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9y
aW5nLmMgIHwgICA0ICsNCiAuLi4vbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3Jp
bmcuaCAgfCAgIDkgKy0NCiAuLi4vYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9hMC5j
ICAgICAgfCAgIDIgKy0NCiAuLi4vYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5j
ICAgICAgfCAgNjIgKystDQogLi4uL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjBfaW50ZXJuYWwu
aCAgICAgIHwgICA3ICsNCiAuLi4vYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9sbGgu
YyAgICAgfCAgMTYgKw0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2xsaC5o
ICAgICB8ICAgNSArDQogLi4uL2F0bGFudGljL2h3X2F0bC9od19hdGxfbGxoX2ludGVybmFsLmgg
ICAgIHwgIDE4ICsNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIu
aCAgfCAgIDUgLQ0KIDE1IGZpbGVzIGNoYW5nZWQsIDYxNSBpbnNlcnRpb25zKCspLCA0MyBkZWxl
dGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2Rl
dmljZV9kcml2ZXJzL2FxdWFudGlhL2F0bGFudGljLnR4dA0KDQotLSANCjIuMTcuMQ0KDQo=
