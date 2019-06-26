Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3754356943
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfFZMff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:35:35 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:7003
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfFZMff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/Jvc0rxBnf3iH5P+oMQ3+lNN/pf3mgzTLGqbf3H41Q=;
 b=slJHcxHJ9ciq5XUPSgAFNOjwCwpUOVOuMl98xFJLz99J1JzrZeQ3NlqXXslnVBbDmTw4b6HqwiU47t0IEVmAjSgJkuqquzid52e1BgKA2LrNPxCCnu5emr9PfNaFHgaNMZRyQu/JXza85euSnfOb4yMVGcYlZK5shAYhpU+Uaio=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:35:31 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 12:35:31 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v3 0/8] net: aquantia: implement vlan offloads
Thread-Topic: [PATCH net-next v3 0/8] net: aquantia: implement vlan offloads
Thread-Index: AQHVLBuk3FdWCkyXjUStm+nsvLGQ7w==
Date:   Wed, 26 Jun 2019 12:35:30 +0000
Message-ID: <cover.1561552290.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:7:16::14) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14ad24ef-2202-4797-e966-08d6fa32c669
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1549;
x-ms-traffictypediagnostic: MWHPR11MB1549:
x-microsoft-antispam-prvs: <MWHPR11MB1549370818440FFBA0851B0098E20@MWHPR11MB1549.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(136003)(396003)(39850400004)(189003)(199004)(14444005)(6512007)(99286004)(53936002)(486006)(107886003)(6116002)(71190400001)(478600001)(54906003)(3846002)(71200400001)(6436002)(6486002)(2616005)(316002)(44832011)(476003)(72206003)(66556008)(64756008)(66446008)(86362001)(73956011)(66946007)(66476007)(5660300002)(8676002)(6916009)(25786009)(50226002)(14454004)(81156014)(81166006)(2906002)(8936002)(66066001)(186003)(102836004)(7736002)(305945005)(52116002)(68736007)(256004)(6506007)(386003)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1549;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /JA02M9RD+TvXT+KxzTs6OkCY3NW87uKaNVU4PoR/gqT1hMJ973gBsyGqYhJiOFBcntEA2yDHARackCEzDn3ACVoRLw70UAdA2uMP3l0OQ/Q0zPwVUvkeDQHYHhMSa8EoARfZlUw95wUVv0fwTWFvH664Zh8KxzPcowtrNkvJaz2S44eikdIyoYJeG2MTRea121bkgQ23Stu0dhxt5C3O0czF3YK06njhVE3qzr+pQRu77ftShB7sk6NW0uXAAiC9eHRxaPhSgHibnKN1EZwxBLTzAjgfCdkkcciAr2EYKShO4Dy1ZM/H9QazMq28nYOihSByFLPfubNbcN6BCUD4LFAfQLUpo09uVw6JljLGXgyRnd71xv5BMHHDQzf3WrHkR92omR2sFXOM/8MZ8wRVagnIA0rfxgVlOVz7GjjNQc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ad24ef-2202-4797-e966-08d6fa32c669
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:35:30.9617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIGhhcmR3YXJlIFZMQU4gb2ZmbG9hZCBzdXBwb3J0IGFu
ZCBhbHNvIGRvZXMgc29tZQ0KbWFpbnRlbmFuY2U6IHdlIHJlcGxhY2UgZHJpdmVyIHZlcnNpb24g
d2l0aCB1dHMgdmVyc2lvbiBzdHJpbmcsIGFkZA0KZG9jdW1lbnRhdGlvbiBmaWxlIGZvciBhdGxh
bnRpYyBkcml2ZXIsIGFuZCB1cGRhdGUgbWFpbnRhaW5lcnMNCmFkZGluZyBJZ29yIGFzIGEgbWFp
bnRhaW5lci4NCg0KdjM6IHNodWZmbGUgZG9jIHNlY3Rpb25zLCBwZXIgQW5kcmV3J3MgY29tbWVu
dHMNCg0KdjI6IHVwZGF0ZXMgaW4gZG9jLCBncGwgc3BkeCB0YWcgY2xlYW51cA0KDQpJZ29yIFJ1
c3NraWtoICg4KToNCiAgbmV0OiBhcXVhbnRpYTogcmVwbGFjZSBpbnRlcm5hbCBkcml2ZXIgdmVy
c2lvbiBjb2RlIHdpdGggdXRzDQogIG5ldDogYXF1YW50aWE6IGFkZCBkb2N1bWVudGF0aW9uIGZv
ciB0aGUgYXRsYW50aWMgZHJpdmVyDQogIG1haW50YWluZXJzOiBkZWNsYXJlIGFxdWFudGlhIGF0
bGFudGljIGRyaXZlciBtYWludGVuYW5jZQ0KICBuZXQ6IGFxdWFudGlhOiBtYWtlIGFsbCBmaWxl
cyBHUEwtMi4wLW9ubHkNCiAgbmV0OiBhcXVhbnRpYTogYWRkZWQgdmxhbiBvZmZsb2FkIHJlbGF0
ZWQgbWFjcm9zIGFuZCBmdW5jdGlvbnMNCiAgbmV0OiBhcXVhbnRpYTogYWRkaW5nIGZpZWxkcyBh
bmQgZGV2aWNlIGZlYXR1cmVzIGZvciB2bGFuIG9mZmxvYWQNCiAgbmV0OiBhcXVhbnRpYTogdmxh
biBvZmZsb2FkcyBsb2dpYyBpbiBkYXRhcGF0aA0KICBuZXQ6IGFxdWFudGlhOiBpbXBsZW1lbnQg
dmxhbiBvZmZsb2FkIGNvbmZpZ3VyYXRpb24NCg0KIC4uLi9kZXZpY2VfZHJpdmVycy9hcXVhbnRp
YS9hdGxhbnRpYy50eHQgICAgICB8IDQzOSArKysrKysrKysrKysrKysrKysNCiBNQUlOVEFJTkVS
UyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDkgKw0KIC4uLi9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmggICB8ICAgNyArLQ0KIC4uLi9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmMgICB8ICAgMiArLQ0KIC4uLi9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmggICB8ICAgMiArLQ0KIC4uLi9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmMgICB8ICAgMiArLQ0KIC4uLi9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmggICB8ICAgMiArLQ0KIC4uLi9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbWFpbi5jICB8ICAzNCArLQ0KIC4uLi9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMgICB8ICAyOCArLQ0KIC4uLi9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmggICB8ICAgMiArDQogLi4uL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9yaW5nLmMgIHwgICA0ICsNCiAuLi4vbmV0L2V0aGVy
bmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3JpbmcuaCAgfCAgIDkgKy0NCiAuLi4vYXF1YW50aWEv
YXRsYW50aWMvaHdfYXRsL2h3X2F0bF9hMC5jICAgICAgfCAgIDIgKy0NCiAuLi4vYXF1YW50aWEv
YXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5jICAgICAgfCAgNjIgKystDQogLi4uL2F0bGFudGlj
L2h3X2F0bC9od19hdGxfYjBfaW50ZXJuYWwuaCAgICAgIHwgICA3ICsNCiAuLi4vYXF1YW50aWEv
YXRsYW50aWMvaHdfYXRsL2h3X2F0bF9sbGguYyAgICAgfCAgMTYgKw0KIC4uLi9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX2xsaC5oICAgICB8ICAgNSArDQogLi4uL2F0bGFudGljL2h3
X2F0bC9od19hdGxfbGxoX2ludGVybmFsLmggICAgIHwgIDE4ICsNCiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaCAgfCAgIDUgLQ0KIDE5IGZpbGVzIGNoYW5nZWQs
IDYwOCBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQg
RG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmljZV9kcml2ZXJzL2FxdWFudGlhL2F0bGFudGlj
LnR4dA0KDQotLSANCjIuMTcuMQ0KDQo=
