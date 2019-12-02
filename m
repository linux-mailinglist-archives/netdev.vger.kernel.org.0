Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3C10E7AB
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfLBJam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:30:42 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:62436
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfLBJam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 04:30:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+xLpQGC2tRbNOEwDCH4jAmN3lE2vhUV4hxK4d4FyAYCdPJzDwOssGGaaPeubfwh00sjpf7R2cCuFwlDYUTJb3s1G2g6GrsttREFdIpvWdazC7vwpeVwDsLe7sBJwXsHEoTL7yCd43hYYI5z6lTbc7vkzSX3/PJAG+25EBCqPHYu/MhJYbafxlsZmmYixTPtAekgxTLmhQi2I5Q+3OTXGAMus+uP208SeuSG4JXzNYbyPQD8SEtf4nA7rOPmJfALX+WMHCAaK2UuNTSmVboP4bnfTpbh3o82WCycpA6YBspAKslbfMwFKed1c8QKDz8/QQFy5eS/RBtZ5foqqOdEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i4fcA5WdnpL53pDcD2coFMi9oKUJfYk7gVOO90YW+w=;
 b=kICHvbQn8+CPL1b8sGx81ipG20DVZ8eT/SK8FqBqVST5J0s97zDBiO8+c59uzcuDij8I/luky01VEElSpu/lTInhODYOWSuNK8aA3QP0KlYvvYcS92AO1LwMmZh7TM7YF7alq7uIjwRiiN0WG/WQ3n/119xN/5QFNHMsyP3kK8Fr82Y62WGuGr4rFNftODzKBtHzP4/MnnxIWllEv67hwPXwFUHbAZRzI1XnvRSzdlvwQt7rG7Z/t+NbAA/QJ+N7yavcQjAOpYVoychkx1reUDImV9DQq8EoGpUVbNweGiny0/5JZr6GTYlPzC0xRoZl0VVIQvzhcLrH0Ko3oIyMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i4fcA5WdnpL53pDcD2coFMi9oKUJfYk7gVOO90YW+w=;
 b=KFhLMWWT2OWBRSA22OObpeph8pdYq6vsAHVkM1RFluSYTEdUxNTwooFFPnRDUnK9h4YaRPjYfwRFvZdz8DUS2bW08h28Rm2WLbYg/vJ5qzlzjDHgbBo/a7tuOOeRQE6EaXm5iEiCs5gbHHhLhVF29wj5nwQcWtJw8DvFWcCEJAM=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4563.eurprd05.prod.outlook.com (52.133.60.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Mon, 2 Dec 2019 09:30:36 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 09:30:36 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] xsk: add missing memory barrier in xskq_has_addrs()
Thread-Topic: [PATCH bpf] xsk: add missing memory barrier in xskq_has_addrs()
Thread-Index: AQHVppqPi+AsYvY1aEii0ZfX9z5g9KemmRWA
Date:   Mon, 2 Dec 2019 09:30:36 +0000
Message-ID: <c15a81e1-252f-936c-26f0-f21e8165c622@mellanox.com>
References: <1575021070-28873-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1575021070-28873-1-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0005.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::18) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.75.144.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc1f6e1e-4b30-49b5-e6ab-08d7770a496f
x-ms-traffictypediagnostic: AM0PR05MB4563:
x-microsoft-antispam-prvs: <AM0PR05MB456305E116DB36782DE3006ED1430@AM0PR05MB4563.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(199004)(189003)(66066001)(316002)(14444005)(305945005)(229853002)(6486002)(6512007)(86362001)(31686004)(6436002)(31696002)(36756003)(99286004)(54906003)(66946007)(66556008)(71200400001)(66476007)(2906002)(4326008)(2616005)(446003)(52116002)(81156014)(76176011)(4001150100001)(256004)(8936002)(25786009)(14454004)(6246003)(386003)(6116002)(6506007)(81166006)(102836004)(7736002)(8676002)(64756008)(6916009)(26005)(478600001)(186003)(11346002)(5660300002)(3846002)(53546011)(71190400001)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4563;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VavRqngb/IkW7NIJPnlYLJD/Txj90sjqVoETrGWMsZ0vPCEgwNgQ0Kedpgtedkfhq8cMPVUqQF7/sbLWXRHY8Ii/gqTYbpMwlI8PJDe7MSrIj6gnZFkdMiyNDQV0by3okmR6zoY/rJMBtUpO7V+lQa9NbPfKdbAieFMZVAOY72BUw8PQU08XVqnQ1KAEm2ytKHLGDY+P0/JVDdF87NFza9tqTCc0rZXEfjsTtC5i31CgaXjBwF4PqZACxWDZqdlLm+y/G/ubxKLgNjVICot3L4rAADq4/orFVbpBbOoNVcv+hNR/7+TwH9CTPluadvatVjrw8f6VJmiHfxQamy3tXbf+W8o45BkchCxO3Qq/eOXHgp3zLLDZIN6GieKh378tMXB2bOSpeYdqpAEWrmleMgBgC+Z042pSG1/1ZWwQOLnsKL51nLlNOpYIcO2/uvP9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4FD6383804C894BA08EA8C927850561@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1f6e1e-4b30-49b5-e6ab-08d7770a496f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 09:30:36.4081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8IBdCZvxw9NMtlNK3fZ46cw35TuVz7VLecQM80Wq1ZXtlbCjWhyFbYvdJeQS6Bb2hwd1OMtPUC4YWLKclzqnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4563
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0xMS0yOSAxMTo1MSwgTWFnbnVzIEthcmxzc29uIHdyb3RlOg0KPiBUaGUgcmluZ3Mg
aW4gQUZfWERQIGJldHdlZW4gdXNlciBzcGFjZSBhbmQga2VybmVsIHNwYWNlIGhhdmUgdGhlDQo+
IGZvbGxvd2luZyBzZW1hbnRpY3M6DQo+IA0KPiBwcm9kdWNlciAgICAgICAgICAgICAgICAgICAg
ICAgICBjb25zdW1lcg0KPiANCj4gaWYgKExPQUQgLT5jb25zdW1lcikgeyAgICAgICAgICAgTE9B
RCAtPnByb2R1Y2VyDQo+ICAgICAgICAgICAgICAgICAgICAgKEEpICAgICAgICAgICBzbXBfcm1i
KCkgICAgICAgKEMpDQo+ICAgICBTVE9SRSAkZGF0YSAgICAgICAgICAgICAgICAgICBMT0FEICRk
YXRhDQo+ICAgICBzbXBfd21iKCkgICAgICAgKEIpICAgICAgICAgICBzbXBfbWIoKSAgICAgICAg
KEQpDQo+ICAgICBTVE9SRSAtPnByb2R1Y2VyICAgICAgICAgICAgICBTVE9SRSAtPmNvbnN1bWVy
DQo+IH0NCj4gDQo+IFRoZSBjb25zdW1lciBmdW5jdGlvbiB4c2txX2hhc19hZGRycygpIGJlbG93
IGxvYWRzIHRoZSBwcm9kdWNlcg0KPiBwb2ludGVyIGFuZCB1cGRhdGVzIHRoZSBsb2NhbGx5IGNh
Y2hlZCBjb3B5IG9mIGl0LiBIb3dldmVyLCBpdCBkb2VzDQo+IG5vdCBpc3N1ZSB0aGUgc21wX3Jt
YigpIG9wZXJhdGlvbiByZXF1aXJlZCBieSB0aGUgbG9ja2xlc3MgcmluZy4gVGhpcw0KPiB3b3Vs
ZCBoYXZlIGJlZW4gb2sgaGFkIHRoZSBmdW5jdGlvbiBub3QgdXBkYXRlZCB0aGUgbG9jYWxseSBj
YWNoZWQNCj4gY29weSwgYXMgdGhhdCBjb3VsZCBub3QgaGF2ZSByZXN1bHRlZCBpbiBuZXcgZGF0
YSBiZWluZyByZWFkIGZyb20gdGhlDQo+IHJpbmcuIEJ1dCBhcyBpdCB1cGRhdGVzIHRoZSBsb2Nh
bCBwcm9kdWNlciBwb2ludGVyLCBhIHN1YnNlcXVlbnQgcGVlaw0KPiBvcGVyYXRpb24sIHN1Y2gg
YXMgeHNrcV9wZWVrX2FkZHIoKSwgbWlnaHQgbG9hZCBkYXRhIGZyb20gdGhlIHJpbmcNCj4gd2l0
aG91dCBpc3N1aW5nIHRoZSByZXF1aXJlZCBzbXBfcm1iKCkgbWVtb3J5IGJhcnJpZXIuDQoNClRo
YW5rcyBmb3IgcGF5aW5nIGF0dGVudGlvbiB0byBpdCwgYnV0IEkgZG9uJ3QgdGhpbmsgaXQgY2Fu
IHJlYWxseSANCmhhcHBlbi4geHNrcV9oYXNfYWRkcnMgb25seSB1cGRhdGVzIHByb2RfdGFpbCwg
YnV0IHhza3FfcGVla19hZGRyIA0KZG9lc24ndCB1c2UgcHJvZF90YWlsLCBpdCByZWFkcyBmcm9t
IGNvbnNfdGFpbCB0byBjb25zX2hlYWQsIGFuZCBldmVyeSANCmNvbnNfaGVhZCB1cGRhdGUgaGFz
IHRoZSBuZWNlc3Nhcnkgc21wX3JtYi4NCg0KQWN0dWFsbHksIHRoZSBzYW1lIHRoaW5nIGhhcHBl
bnMgd2l0aCB4c2txX25iX2F2YWlsLiBJbiB4c2txX2Z1bGxfZGVzYywgDQp3ZSBkb24ndCBoYXZl
IGFueSBiYXJyaWVyIGFmdGVyIHhza3FfbmJfYXZhaWwsIGFuZCB4c2txX3BlZWtfZGVzYyBjYW4g
YmUgDQpjYWxsZWQgYWZ0ZXIgeHNrcV9mdWxsX2Rlc2MsIGJ1dCBpdCdzIGFic29sdXRlbHkgZmlu
ZSwgYmVjYXVzZSANCnhza3FfbmJfYXZhaWwgZG9lc24ndCB0b3VjaCBjb25zX2hlYWQuIFRoZSBz
YW1lIGhhcHBlbnMgd2l0aCANCnhza3FfaGFzX2FkZHJzIGFuZCB4c2txX3BlZWtfYWRkci4NCg0K
U28sIEkgZG9uJ3QgdGhpbmsgdGhpcyBjaGFuZ2UgaXMgcmVxdWlyZWQuIFBsZWFzZSBjb3JyZWN0
IG1lIGlmIEknbSB3cm9uZy4NCg0KPiBzdGF0aWMgaW5saW5lIGJvb2wgeHNrcV9oYXNfYWRkcnMo
c3RydWN0IHhza19xdWV1ZSAqcSwgdTMyIGNudCkNCj4gew0KPiAgICAgICAgICB1MzIgZW50cmll
cyA9IHEtPnByb2RfdGFpbCAtIHEtPmNvbnNfdGFpbDsNCj4gDQo+ICAgICAgICAgIGlmIChlbnRy
aWVzID49IGNudCkNCj4gICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4gDQo+ICAgICAg
ICAgIC8qIFJlZnJlc2ggdGhlIGxvY2FsIHBvaW50ZXIuICovDQo+ICAgICAgICAgIHEtPnByb2Rf
dGFpbCA9IFJFQURfT05DRShxLT5yaW5nLT5wcm9kdWNlcik7DQo+IAkqKiogTUlTU0lORyBNRU1P
UlkgQkFSUklFUiAqKioNCj4gICAgICAgICAgZW50cmllcyA9IHEtPnByb2RfdGFpbCAtIHEtPmNv
bnNfdGFpbDsNCj4gDQo+ICAgICAgICAgIHJldHVybiBlbnRyaWVzID49IGNudDsNCj4gfQ0KPiAN
Cj4gRml4IHRoaXMgYnkgYWRkaW5nIHRoZSBtaXNzaW5nIG1lbW9yeSBiYXJyaWVyIGF0IHRoZSBp
bmRpY2F0ZWQgcG9pbnQNCj4gYWJvdmUuDQo+IA0KPiBGaXhlczogZDU3ZDc2NDI4YWU5ICgiQWRk
IEFQSSB0byBjaGVjayBmb3IgYXZhaWxhYmxlIGVudHJpZXMgaW4gRlEiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBNYWdudXMgS2FybHNzb24gPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+DQo+IC0tLQ0K
PiAgIG5ldC94ZHAveHNrX3F1ZXVlLmggfCAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQveGRwL3hza19xdWV1ZS5oIGIvbmV0L3hk
cC94c2tfcXVldWUuaA0KPiBpbmRleCBlZGRhZTQ2Li5iNTQ5MmMzIDEwMDY0NA0KPiAtLS0gYS9u
ZXQveGRwL3hza19xdWV1ZS5oDQo+ICsrKyBiL25ldC94ZHAveHNrX3F1ZXVlLmgNCj4gQEAgLTEy
Nyw2ICsxMjcsNyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgeHNrcV9oYXNfYWRkcnMoc3RydWN0IHhz
a19xdWV1ZSAqcSwgdTMyIGNudCkNCj4gICANCj4gICAJLyogUmVmcmVzaCB0aGUgbG9jYWwgcG9p
bnRlci4gKi8NCj4gICAJcS0+cHJvZF90YWlsID0gUkVBRF9PTkNFKHEtPnJpbmctPnByb2R1Y2Vy
KTsNCj4gKwlzbXBfcm1iKCk7IC8qIEMsIG1hdGNoZXMgQiAqLw0KPiAgIAllbnRyaWVzID0gcS0+
cHJvZF90YWlsIC0gcS0+Y29uc190YWlsOw0KPiAgIA0KPiAgIAlyZXR1cm4gZW50cmllcyA+PSBj
bnQ7DQo+IA0KDQo=
