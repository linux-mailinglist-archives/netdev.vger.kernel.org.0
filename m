Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5D144603
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAUUjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:39:11 -0500
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:22157
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728904AbgAUUjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 15:39:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJa/XD+M5XZNyXjMLUABVIQwpaXSIRTxF141v1gYrLxuDC7eQaQn0THGnJoZIkCDr2aPEDOFrVXYarqqqizHTefWHwM3i+hpvABShxO59K0zx5j4d8GPF0T+Fi8DJvc6gX/9/FPbdzs3PSq+l4AKRLtR2v7RBb7tRVwgd2UBcoeg8yUSinsk5fsUWvCimoepPzUJUhCUhCtT4PiMiHcJLycfohdwA1f4AxXdgMNMyKpBnQKDSUaC4Rn69dDc2glGcpdIV2kjWDbUyx0KavfRPjUgNXS/1pL3NYQxbcAIa5DlY8S626mBp2+M4lWrgA+THHy1n18DjcC+nBx/ed+4Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ylzFMKK/GzZwNhmoaGt2HwHtwPGOXh8AFXGXkEwEhk=;
 b=ajRyGcZCuOkbE2hW+9fIpHPSQo6CTkf/koNa2jlbdbns2Gxdsljo2b0QkNerxmNuyaCGpQZyYM8drTUBlgXiHJK9YCsiiEWio2v2RrtX2/Ng+CPpX26MOVNGHfe3+4BoalDp+ohS3qHiRpct959Lixgtpw9qy0Ch3u83ZAnIUxbRnC7F6JreUBA2TSPW4o7eMiyA6t/qtsfvhCIpJl3n8Vw7JE6xMICZWYEt1Jb++JbTxdIu1EDN0szgEV+SsAVtfGQkGWfCy4mLC9XQvQqN+Tk5vJLU8wRUqLfdlwI8pvkvYQlCLFAx2x2rSgXUl10FqbuhdPaXttcaN2tMh81JtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ylzFMKK/GzZwNhmoaGt2HwHtwPGOXh8AFXGXkEwEhk=;
 b=E+X6mVz+gA8ZqNAT11bVTOjiRjmQdMHWz0nfBFiJwn7/7B+RLb0kZpN/WDoA+IXOG2xy8hkiWx/N4GEALgDmWT2+D4YBa2sW8BqJuSwSkRXTZ2k4VyyzY/wQgncOmWYOFp03r7QU+vGNmlPNowBszkc8UHh7LDbOXRt0RUXalxM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3503.eurprd05.prod.outlook.com (10.170.236.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Tue, 21 Jan 2020 20:39:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 20:39:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ecree@solarflare.com" <ecree@solarflare.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "alobakin@dlink.ru" <alobakin@dlink.ru>
CC:     "luciano.coelho@intel.com" <luciano.coelho@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
Thread-Topic: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
Thread-Index: AQHV0GzNGcLYgDu8uEmAjawQrOpYjKf1lMuA
Date:   Tue, 21 Jan 2020 20:39:06 +0000
Message-ID: <30db82e2a1bdcabd61a31e2e8dac58a035d7023d.camel@mellanox.com>
References: <20200121150917.6279-1-maximmi@mellanox.com>
In-Reply-To: <20200121150917.6279-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eefe4d80-7524-4fbd-b15b-08d79eb1f607
x-ms-traffictypediagnostic: VI1PR05MB3503:|VI1PR05MB3503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB35036BE97A6812FE3D025024BE0D0@VI1PR05MB3503.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2616005)(8676002)(86362001)(81166006)(81156014)(8936002)(71200400001)(36756003)(316002)(66946007)(66476007)(6486002)(66446008)(66556008)(64756008)(76116006)(26005)(91956017)(54906003)(6506007)(2906002)(478600001)(6512007)(5660300002)(4326008)(110136005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3503;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrcdKlbtJm70ty7CnhP0dFhk7+6jyzS1JKNz0Jb6sglA/H+UcfC+LAZTKhjV9Ds7LAnUL6dvPyp96XJVsDa/Ka731806EPwPlwFHEKgDaiJSTKwP4I6YJRuJSe7Fiooz2zR8fc406smMPo1vvoXr2pxmlYI2R6RYSzDcamupFerJWVaFWfXt/ttYdm8baApULV8xOfQbuYb18Om82x8/SNMQpgYllq2iBPVQf5J6+huwCetldw6EGReiIy9pTqePD7p3b0FGwVGrxz8cWtQbhFJeo8BstAlDnq/7OpYbjLuRPG/mD3f3ydKwqGTm4WAF5fi/sZpRZOfYalHR5CdRQLCXSv9FT12W54fFhaLESmZ4I0P66g/ZHOe8fSwdvG7cwfOA0GKH+SZqumGel3+XO6X3hDNZAP2UkMPIrWFmnRjy127ao4MOBTsLPMw7nuj7
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0C86A160E761C4FB8DFE844A07AA06C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefe4d80-7524-4fbd-b15b-08d79eb1f607
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 20:39:06.9554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TkWGXdSaKI31S2k75hN8MON2qgoB8f0TgfvSjZBDcxH1i39NH76O62lzTi64fW9lBba1EQ10i1lLiL2PQGTExA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3503
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAxLTIxIGF0IDE1OjA5ICswMDAwLCBNYXhpbSBNaWtpdHlhbnNraXkgd3Jv
dGU6DQo+IENvbW1pdCAzMjNlYmI2MWUzMmIgKCJuZXQ6IHVzZSBsaXN0aWZpZWQgUlggZm9yIGhh
bmRsaW5nIEdST19OT1JNQUwNCj4gc2ticyIpIGludHJvZHVjZXMgYmF0Y2hpbmcgb2YgR1JPX05P
Uk1BTCBwYWNrZXRzIGluDQo+IG5hcGlfZnJhZ3NfZmluaXNoLA0KPiBhbmQgY29tbWl0IDY1NzBi
Yzc5YzBkZiAoIm5ldDogY29yZTogdXNlIGxpc3RpZmllZCBSeCBmb3IgR1JPX05PUk1BTA0KPiBp
bg0KPiBuYXBpX2dyb19yZWNlaXZlKCkiKSBhZGRzIHRoZSBzYW1lIHRvIG5hcGlfc2tiX2Zpbmlz
aC4gSG93ZXZlciwNCj4gZGV2X2dyb19yZWNlaXZlICh0aGF0IGlzIGNhbGxlZCBqdXN0IGJlZm9y
ZSBuYXBpX3tmcmFncyxza2J9X2ZpbmlzaCkNCj4gY2FuDQo+IGFsc28gcGFzcyBza2JzIHRvIHRo
ZSBuZXR3b3JraW5nIHN0YWNrOiBlLmcuLCB3aGVuIHRoZSBHUk8gc2Vzc2lvbiBpcw0KPiBmbHVz
aGVkLCBuYXBpX2dyb19jb21wbGV0ZSBpcyBjYWxsZWQsIHdoaWNoIHBhc3NlcyBwcCBkaXJlY3Rs
eSB0bw0KPiBuZXRpZl9yZWNlaXZlX3NrYl9pbnRlcm5hbCwgc2tpcHBpbmcgbmFwaS0+cnhfbGlz
dC4gSXQgbWVhbnMgdGhhdCB0aGUNCj4gcGFja2V0IHN0b3JlZCBpbiBwcCB3aWxsIGJlIGhhbmRs
ZWQgYnkgdGhlIHN0YWNrIGVhcmxpZXIgdGhhbiB0aGUNCj4gcGFja2V0cyB0aGF0IGFycml2ZWQg
YmVmb3JlLCBidXQgYXJlIHN0aWxsIHdhaXRpbmcgaW4gbmFwaS0+cnhfbGlzdC4NCj4gSXQNCj4g
bGVhZHMgdG8gVENQIHJlb3JkZXJpbmdzIHRoYXQgY2FuIGJlIG9ic2VydmVkIGluIHRoZSBUQ1BP
Rk9RdWV1ZQ0KPiBjb3VudGVyDQo+IGluIG5ldHN0YXQuDQo+IA0KPiBUaGlzIGNvbW1pdCBmaXhl
cyB0aGUgcmVvcmRlcmluZyBpc3N1ZSBieSBtYWtpbmcgbmFwaV9ncm9fY29tcGxldGUNCj4gYWxz
bw0KPiB1c2UgbmFwaS0+cnhfbGlzdCwgc28gdGhhdCBhbGwgcGFja2V0cyBnb2luZyB0aHJvdWdo
IEdSTyB3aWxsIGtlZXANCj4gdGhlaXINCj4gb3JkZXIuIEluIG9yZGVyIHRvIGtlZXAgbmFwaV9n
cm9fZmx1c2ggd29ya2luZyBwcm9wZXJseSwNCj4gZ3JvX25vcm1hbF9saXN0DQo+IGNhbGxzIGFy
ZSBtb3ZlZCBhZnRlciB0aGUgZmx1c2ggdG8gY2xlYXIgbmFwaS0+cnhfbGlzdC4NCj4gDQo+IGl3
bHdpZmkgY2FsbHMgbmFwaV9ncm9fZmx1c2ggZGlyZWN0bHkgYW5kIGRvZXMgdGhlIHNhbWUgdGhp
bmcgdGhhdCBpcw0KPiBkb25lIGJ5IGdyb19ub3JtYWxfbGlzdCwgc28gdGhlIHNhbWUgY2hhbmdl
IGlzIGFwcGxpZWQgdGhlcmU6DQo+IG5hcGlfZ3JvX2ZsdXNoIGlzIG1vdmVkIHRvIGJlIGJlZm9y
ZSB0aGUgZmx1c2ggb2YgbmFwaS0+cnhfbGlzdC4NCj4gDQo+IEEgZmV3IG90aGVyIGRyaXZlcnMg
YWxzbyB1c2UgbmFwaV9ncm9fZmx1c2ggKGJyb2NhZGUvYm5hL2JuYWQuYywNCj4gY29ydGluYS9n
ZW1pbmkuYywgaGlzaWxpY29uL2huczMvaG5zM19lbmV0LmMpLiBUaGUgZmlyc3QgdHdvIGFsc28g
dXNlDQo+IG5hcGlfY29tcGxldGVfZG9uZSBhZnRlcndhcmRzLCB3aGljaCBwZXJmb3JtcyB0aGUg
Z3JvX25vcm1hbF9saXN0DQo+IGZsdXNoLA0KPiBzbyB0aGV5IGFyZSBmaW5lLiBUaGUgbGF0dGVy
IGNhbGxzIG5hcGlfZ3JvX3JlY2VpdmUgcmlnaHQgYWZ0ZXINCj4gbmFwaV9ncm9fZmx1c2gsIHNv
IGl0IGNhbiBlbmQgdXAgd2l0aCBub24tZW1wdHkgbmFwaS0+cnhfbGlzdCBhbnl3YXkuDQo+IA0K
PiBGaXhlczogMzIzZWJiNjFlMzJiICgibmV0OiB1c2UgbGlzdGlmaWVkIFJYIGZvciBoYW5kbGlu
ZyBHUk9fTk9STUFMDQo+IHNrYnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KPiBDYzogQWxleGFuZGVyIExvYmFraW4gPGFsb2Jh
a2luQGRsaW5rLnJ1Pg0KPiBDYzogRWR3YXJkIENyZWUgPGVjcmVlQHNvbGFyZmxhcmUuY29tPg0K
PiAtLS0NCj4gdjIgY2hhbmdlczoNCj4gDQo+IEZsdXNoIG5hcGktPnJ4X2xpc3QgYWZ0ZXIgbmFw
aV9ncm9fZmx1c2gsIG5vdCBiZWZvcmUuIERvIGl0IGluDQo+IGl3bHdpZmkNCj4gYXMgd2VsbC4N
Cj4gDQo+IFBsZWFzZSBhbHNvIHBheSBhdHRlbnRpb24gdGhhdCB0aGVyZSBpcyBncm9fZmx1c2hf
b2xkZXN0IHRoYXQgYWxzbw0KPiBjYWxscw0KPiBuYXBpX2dyb19jb21wbGV0ZSBhbmQgRE9FU04n
VCBkbyBncm9fbm9ybWFsX2xpc3QgdG8gZmx1c2ggbmFwaS0NCj4gPnJ4X2xpc3QuDQo+IEkgZ3Vl
c3MsIGl0J3Mgbm90IHJlcXVpcmVkIGluIHRoaXMgZmxvdywgYnV0IGlmIEknbSB3cm9uZywgcGxl
YXNlDQo+IHRlbGwNCj4gbWUuDQo+IA0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXds
d2lmaS9wY2llL3J4LmMgfCAgNCArLQ0KPiAgbmV0L2NvcmUvZGV2LmMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCA2NCArKysrKysrKysrLS0tLS0tDQo+IC0tLS0NCj4gIDIgZmlsZXMg
Y2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pDQo+IA0KDQpMR1RNLA0K
DQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCg==
