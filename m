Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C492FDDD2D
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 09:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfJTH3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 03:29:11 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:59296
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfJTH3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 03:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ3EyHoAVET1PISJ6FVzZjpEdCrcVl0s1+UbSGNX3v017DCIIx2A3Z7woXmsfNlcaQNWBQFLQdxB4/UYy9hArmP/+g8UKJv8AswuoBTt/yilGVb83B2w2+XMKLKy42I0brTezekbWhgYRXEG1GaDutlMqgMz2VIoY9Ny1wlnBlB6Z8+EFf1AipIGs7umLik/wGo3F3hNe6pB/9xEXy9RxKL3DXbYZQYPMruqCqKhcIrRrRLGNEFZU2+6MWNTk+pL/6tlWwE8AZy5UkXnZ+hIs8C4S71YEF3W9zShqT2Who6AQz+kTX01ffwghZNNyRq0VSrFIFvJ3RMuAee/rC50Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6u+bcWBZUjSHphGunFyZ0iFwKGR+bA6C3+RFHUi6Tg=;
 b=i7MDURIQ1r/6/Qt1YT8BQHD0+qCIwFMNXJ4242Geh0Tv1ntDYvWDXvzP13Vrx1Vw+81ZSKU6vRlaIGmfxRDnRjz6Gj4yVLJLKcj2aCXm4j26w8lQW/wULpTa7VR47g0LjfX7Fdh+eDOSQ0c+NbsssZcIpR/UWS+MQBUSNSJe0DvgUVDSDTDTRk1Tm0J/C8aIMgjbB/qOFJQ0sriCpxcNg+lcPNrir87Cpz8SjCeTDWPR+flB2sEwGoYz58faA7k3jbjb/m/r87yO1E/Xc5FigkRdoeFJw3C5lgE0+4J0Q2toW0fdpSvLc4i7Zg3IcVE2OJY1x1oE3dBcQuQehlJ59Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6u+bcWBZUjSHphGunFyZ0iFwKGR+bA6C3+RFHUi6Tg=;
 b=PpvJSGJgfQnUTSx3lF2JPMgEgECO10B16NC6y4EPcmxCLuku4oJMWzT7uShWT2V2XXdstabD9UgEryRf6CvcYqF3HU/PQcoMeLQur7BkcYS6CjYckzmwql8xV/oGB5tWHz1KV2J+0WiKDwIWI80lv71cMAblrFjGQ2hj406mgVY=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6587.eurprd05.prod.outlook.com (20.179.42.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Sun, 20 Oct 2019 07:29:07 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::80c3:88d8:12c7:b861]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::80c3:88d8:12c7:b861%7]) with mapi id 15.20.2347.028; Sun, 20 Oct 2019
 07:29:07 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        Netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Thread-Topic: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Thread-Index: AQHVhHQvVxXE1BIxiUKuJghT7DucGadg41cAgAA3HQCAAgy7gA==
Date:   Sun, 20 Oct 2019 07:29:07 +0000
Message-ID: <b73c8c15-3f10-d539-f648-5a0c772d9fc0@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-2-jonathan.lemon@gmail.com>
 <7852500cd0008893985094fa20e2790436391e49.camel@mellanox.com>
 <7C9F38DB-6164-4ACB-A717-1699ACC9DCB0@gmail.com>
In-Reply-To: <7C9F38DB-6164-4ACB-A717-1699ACC9DCB0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0096.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::37) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.124.18.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e02c98-b446-4ff3-6925-08d7552f3108
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DBBPR05MB6587:|DBBPR05MB6587:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6587A55F94A77AD5F15B4001AE6E0@DBBPR05MB6587.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0196A226D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39850400004)(136003)(376002)(396003)(199004)(189003)(66556008)(6512007)(66446008)(2616005)(6436002)(6306002)(6116002)(64756008)(66476007)(66946007)(486006)(53546011)(3846002)(6246003)(446003)(2906002)(31696002)(86362001)(11346002)(4326008)(26005)(8936002)(229853002)(6486002)(5660300002)(102836004)(81166006)(81156014)(8676002)(476003)(36756003)(6506007)(386003)(14444005)(966005)(14454004)(52116002)(31686004)(316002)(99286004)(256004)(54906003)(110136005)(478600001)(76176011)(6636002)(186003)(25786009)(66066001)(71200400001)(71190400001)(305945005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6587;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ME0qD9EBoDRd2970jiEflDTl6BnWV2nJsOT+2STNt5yPsYxsWepCxnAUv1zJ+wYzXFq4rGG7MQOZNhAseLM1O+Ne9/5G09hMmbQxbND/rPcKn69yKi2VQF4r3IC6Bgu1zENXznm9iW6bqSKaC53BaaLOGtiOKaINBSaEdUSihvGRyCX72ZlMcPO5p65Mp2TRj6YmndKZcZ9SDtWYBUyNKUPylkiBXr/kQDzMvAxItjy3/pG5jTl/+mwKK+TdSq4f2PBDIF4wbpmUbwU+RP3AJZgYStWBNfdIoIO/rGV0SX0RZdpNThET26EeuRiNMgL6zCR2l3Hp42qNe2UWneADozB00jvC2xtd/n7SAcn/7b8QXZcG9kctjLoehUOuupkGMpyGq3lagMxfa9/mAsz1tiPpVCZQLcikY7LOKVKPHljtWB/HGGet+bwbfRzgpGaaoi7/5gV51nfj8kN/UA5Y0A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD52108C3FA7F54D8B3D9B17DF675EE3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e02c98-b446-4ff3-6925-08d7552f3108
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2019 07:29:07.2801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pUUZCyeMF5DpxGqm4X4DbWShyhWlYhLFRAph3pbMLvT1i6PkNKVoUrON+rxjYfFUXcwC3FPyeR9rWQJ7/CziDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE5LzIwMTkgMzoxMCBBTSwgSm9uYXRoYW4gTGVtb24gd3JvdGU6DQo+IEkgd2Fz
IHJ1bm5pbmcgdGhlIHVwZGF0ZWQgcGF0Y2hlcyBvbiBtYWNoaW5lcyB3aXRoIHZhcmlvdXMgd29y
a2xvYWRzLCBhbmQNCj4gaGF2ZSBhIGJ1bmNoIG9mIGRpZmZlcmVudCByZXN1bHRzLg0KPiANCj4g
Rm9yIHRoZSBmb2xsb3dpbmcgbnVtYmVycywNCj4gICAgRWZmZWN0aXZlID0gaGl0IC8gKGhpdCAr
IGVtcHR5ICsgc3RhbGwpICogMTAwDQo+IA0KPiBJbiBvdGhlciB3b3Jkcywgc2hvdyB0aGUgaGl0
IHJhdGUgZm9yIGZvciBldmVyeSB0cmlwIHRvIHRoZSBjYWNoZSwNCj4gYW5kIHRoZSBjYWNoZSBm
dWxsIHN0YXQgaXMgaWdub3JlZC4NCj4gDQo+IE9uIGEgd2Vic2VydmVyOg0KPiANCj4gW3dlYl0g
IyAuL2VmZg0KPiAoJ3J4X3Bvb2xfY2FjaGVfaGl0OicsICczNjAxMjc2NDMnKQ0KPiAoJ3J4X3Bv
b2xfY2FjaGVfZnVsbDonLCAnMCcpDQo+ICgncnhfcG9vbF9jYWNoZV9lbXB0eTonLCAnNjQ1NTcz
NTk3NycpDQo+ICgncnhfcG9vbF9yaW5nX3Byb2R1Y2U6JywgJzQ3NDk1OCcpDQo+ICgncnhfcG9v
bF9yaW5nX2NvbnN1bWU6JywgJzAnKQ0KPiAoJ3J4X3Bvb2xfcmluZ19yZXR1cm46JywgJzQ3NDk1
OCcpDQo+ICgncnhfcG9vbF9mbHVzaDonLCAnMTQ0JykNCj4gKCdyeF9wb29sX25vZGVfY2hhbmdl
OicsICcwJykNCj4gY2FjaGUgZWZmZWN0aXZlbmVzczogIDUuMjgNCj4gDQo+IE9uIGEgcHJveHln
ZW46DQo+ICMgZXRodG9vbCAtUyBldGgwIHwgZ3JlcCByeF9wb29sDQo+ICAgICAgIHJ4X3Bvb2xf
Y2FjaGVfaGl0OiAxNjQ2Nzk4DQo+ICAgICAgIHJ4X3Bvb2xfY2FjaGVfZnVsbDogMA0KPiAgICAg
ICByeF9wb29sX2NhY2hlX2VtcHR5OiAxNTcyMzU2Ng0KPiAgICAgICByeF9wb29sX3JpbmdfcHJv
ZHVjZTogNDc0OTU4DQo+ICAgICAgIHJ4X3Bvb2xfcmluZ19jb25zdW1lOiAwDQo+ICAgICAgIHJ4
X3Bvb2xfcmluZ19yZXR1cm46IDQ3NDk1OA0KPiAgICAgICByeF9wb29sX2ZsdXNoOiAxNDQNCj4g
ICAgICAgcnhfcG9vbF9ub2RlX2NoYW5nZTogMA0KPiBjYWNoZSBlZmZlY3RpdmVuZXNzOiAgOS40
OA0KPiANCj4gT24gYm90aCBvZiB0aGVzZSwgb25seSBwYWdlcyB3aXRoIHJlZmNvdW50ID0gMSBh
cmUgYmVpbmcga2VwdC4NCj4gDQo+IA0KPiBJIGNoYW5nZWQgdGhpbmdzIGFyb3VuZCBpbiB0aGUg
cGFnZSBwb29sIHNvOg0KPiANCj4gMSkgdGhlIGNhY2hlIGJlaGF2ZXMgbGlrZSBhIHJpbmcgaW5z
dGVhZCBvZiBhIHN0YWNrLCB0aGlzDQo+ICAgICBzYWNyaWZpY2VzIHRlbXBvcmFsIGxvY2FsaXR5
Lg0KPiANCj4gMikgaXQgY2FjaGVzIGFsbCBwYWdlcyByZXR1cm5lZCByZWdhcmRsZXNzIG9mIHJl
ZmNvdW50LCBidXQNCj4gICAgIG9ubHkgcmV0dXJucyBwYWdlcyB3aXRoIHJlZmNvdW50PTEuDQo+
IA0KPiBUaGlzIGlzIHRoZSBzYW1lIGJlaGF2aW9yIGFzIHRoZSBtbHg1IGNhY2hlLiAgU29tZSBn
YWlucw0KPiB3b3VsZCBjb21lIGFib3V0IGlmIHRoZSBzb2pvdXJuIHRpbWUgdGhvdWdoIHRoZSBj
YWNoZSBpcw0KPiBncmVhdGVyIHRoYW4gdGhlIGxpZmV0aW1lIG9mIHRoZSBwYWdlIHVzYWdlIGJ5
IHRoZSBuZXR3b3JraW5nDQo+IHN0YWNrLCBhcyBpdCBwcm92aWRlcyBhIGZpeGVkIHdvcmtpbmcg
c2V0IG9mIG1hcHBlZCBwYWdlcy4NCj4gDQo+IE9uIHRoZSB3ZWIgc2VydmVyLCB0aGlzIGlzIGEg
bmV0IGxvc3M6DQo+IFt3ZWJdICMgLi9lZmYNCj4gKCdyeF9wb29sX2NhY2hlX2hpdDonLCAnNjA1
MjY2MicpDQo+ICgncnhfcG9vbF9jYWNoZV9mdWxsOicsICcxNTYzNTU0MTUnKQ0KPiAoJ3J4X3Bv
b2xfY2FjaGVfZW1wdHk6JywgJzQwOTYwMCcpDQo+ICgncnhfcG9vbF9jYWNoZV9zdGFsbDonLCAn
MzAyNzg3NDczJykNCj4gKCdyeF9wb29sX3JpbmdfcHJvZHVjZTonLCAnMTU2NjMzODQ3JykNCj4g
KCdyeF9wb29sX3JpbmdfY29uc3VtZTonLCAnOTkyNTUyMCcpDQo+ICgncnhfcG9vbF9yaW5nX3Jl
dHVybjonLCAnMjc4Nzg4JykNCj4gKCdyeF9wb29sX2ZsdXNoOicsICc5NicpDQo+ICgncnhfcG9v
bF9ub2RlX2NoYW5nZTonLCAnMCcpDQo+IGNhY2hlIGVmZmVjdGl2ZW5lc3M6ICAxLjk1NzIwODQ2
Nzc4DQo+IA0KPiBGb3IgcHJveHlnZW4gb24gdGhlIG90aGVyIGhhbmQsIGl0J3MgYSB3aW46DQo+
IFtwcm94eV0gIyAuL2VmZg0KPiAoJ3J4X3Bvb2xfY2FjaGVfaGl0OicsICc2OTIzNTE3NycpDQo+
ICgncnhfcG9vbF9jYWNoZV9mdWxsOicsICczNTQwNDM4NycpDQo+ICgncnhfcG9vbF9jYWNoZV9l
bXB0eTonLCAnNDYwODAwJykNCj4gKCdyeF9wb29sX2NhY2hlX3N0YWxsOicsICc0MjkzMjUzMCcp
DQo+ICgncnhfcG9vbF9yaW5nX3Byb2R1Y2U6JywgJzM1NzE3NjE4JykNCj4gKCdyeF9wb29sX3Jp
bmdfY29uc3VtZTonLCAnMjc4Nzk0NjknKQ0KPiAoJ3J4X3Bvb2xfcmluZ19yZXR1cm46JywgJzQw
NDgwMCcpDQo+ICgncnhfcG9vbF9mbHVzaDonLCAnMTA4JykNCj4gKCdyeF9wb29sX25vZGVfY2hh
bmdlOicsICcwJykNCj4gY2FjaGUgZWZmZWN0aXZlbmVzczogIDYxLjQ3MjE2MDg2MjQNCj4gDQo+
IFNvIHRoZSBjb3JyZWN0IGJlaGF2aW9yIGlzbid0IHF1aXRlIGNsZWFyIGN1dCBoZXJlIC0gY2Fj
aGluZyBhDQo+IHdvcmtpbmcgc2V0IG9mIG1hcHBlZCBwYWdlcyBpcyBiZW5lZmljaWFsIGluIHNw
aXRlIG9mIHRoZSBIT0wNCj4gYmxvY2tpbmcgc3RhbGxzIGZvciBzb21lIHdvcmtsb2FkcywgYnV0
IEknbSBzdXJlIHRoYXQgaXQgd291bGRuJ3QNCj4gYmUgdG9vIGRpZmZpY3VsdCB0byBleGNlZWQg
dGhlIFdTIHNpemUuDQo+IA0KPiBUaG91Z2h0cz8NCj4gDQoNCldlIGhhdmUgYSBXSVAgaW4gd2hp
Y2ggd2UgYXZvaWQgdGhlIEhPTCBibG9jaywgYnkgaGF2aW5nIHBhZ2VzIHJldHVybmVkIA0KdG8g
dGhlIGF2YWlsYWJsZS1xdWV1ZSBvbmx5IHdoZW4gdGhlaXIgcmVmY250IHJlYWNoZXMgYmFjayB0
byAxLiBUaGlzIA0KcmVxdWlyZXMgY2F0Y2hpbmcgdGhpcyBjYXNlIGluIHRoZSBwYWdlL3NrYiBy
ZWxlYXNlIHBhdGguDQoNClNlZToNCmh0dHBzOi8vZ2l0aHViLmNvbS94ZHAtcHJvamVjdC94ZHAt
cHJvamVjdC90cmVlL21hc3Rlci9hcmVhcy9tZW0NCg==
