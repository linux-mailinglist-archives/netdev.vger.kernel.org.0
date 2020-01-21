Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AF14382F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAUI0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:26:39 -0500
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:35078
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgAUI0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OinljLwjBbphJIeoczmp3gMaJaRrVxESjFwmGK+saBwSlHxMdqPiXczXVO99A1LcFgshnoWpagCQguakLLXv9sna1RHPytZIoW97I8CEK2rDlE1CCcGnQ0L9ecFlGgR6wYmHEumvzLlLwAHwKycx6zjdWAL1gHd6VjT3i5hPzq47H0zp9cbWrdjVdtPrwbH7nYmn4WgBkNUJ8Z6gcFIdcdR7Bk4oNlReCttObv5KtZJ3qKx4fUzYafq1IJlKGRU1pHu7dS5cu11aCUmzBhh2f2NC0sq97583HEgLJdTSvsfy/ToihLd+3aBVmT4hYmZwJzstRLgekH1+on+FvpbHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql66VqBhXNR/bD/+WnvxjJzMhRZBXD7wsuGkkfUzjFU=;
 b=fbCYx65qBfdhwyG3Z7ROIdUUFNzJtOlhtg0nXYHc+70IZGu6uyqQtlolGuFqqvDO0B80Fe0zIRTnl7uNjQbFE/iXyAbgk1vNwPoPMekOPgfbqhzTOZRAhJX5a6fTJC19bnP2Eyd2tuT8dk4NwrHA1qWFDoCs/iw1YIwFSuaXk2uFaS+rhQZ+OjdUfP2hJhp63XPRndLLQIL7xK/S2WYvhHGFwJ1pNUVFEoB+w0JtXwmmU5wS/k1ZuOj2zqTXrgxjRoobywZmg8Y4hyuxEHyzQZFj8U0jW/6n0cOYAE7KbM6wCU1JMXsbIuBF2KOyGybAmkp2dJYfh4ONuMFUCHt4Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql66VqBhXNR/bD/+WnvxjJzMhRZBXD7wsuGkkfUzjFU=;
 b=P/tBqr7fLZO63DYomTEpDiX23fh8Cqqq8TQKkfIa5vG5slcewneQQ2pQPQqr7vNwxP03uhZcd3/I0IUubCF0O5jeCYD11Vh7vvXeGpuDoRuvhTZZ/ASwJRpFrKX/d04KpBdv7OzkVds/C6MKrXvK1YBzqa8g+43EfdgLBO8HW3M=
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) by
 AM4PR05MB3394.eurprd05.prod.outlook.com (10.171.189.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Tue, 21 Jan 2020 08:26:23 +0000
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720]) by AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720%2]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 08:26:23 +0000
Received: from [10.223.0.122] (193.47.165.251) by AM0PR02CA0102.eurprd02.prod.outlook.com (2603:10a6:208:154::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Tue, 21 Jan 2020 08:26:22 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2] tc: flower: fix print with oneline option
Thread-Topic: [PATCH iproute2] tc: flower: fix print with oneline option
Thread-Index: AQHVxTv53t8Z95UNlUW/KR2WF5pnq6fz5qYAgAD3zAA=
Date:   Tue, 21 Jan 2020 08:26:23 +0000
Message-ID: <db8bbb1d-bd67-2ccb-5722-95a62d7980fc@mellanox.com>
References: <20200107092210.1562-1-roid@mellanox.com>
 <20200120093926.1bf3ce01@hermes.lan>
In-Reply-To: <20200120093926.1bf3ce01@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
x-clientproxiedby: AM0PR02CA0102.eurprd02.prod.outlook.com
 (2603:10a6:208:154::43) To AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6769bb92-14d4-4c00-955a-08d79e4b995b
x-ms-traffictypediagnostic: AM4PR05MB3394:|AM4PR05MB3394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3394539115917E13C28A1946B50D0@AM4PR05MB3394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:26;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(189003)(199004)(81156014)(31696002)(2616005)(956004)(16576012)(8676002)(6916009)(54906003)(26005)(8936002)(81166006)(86362001)(71200400001)(53546011)(66946007)(4326008)(6486002)(316002)(66556008)(64756008)(2906002)(66476007)(52116002)(107886003)(66446008)(478600001)(36756003)(31686004)(5660300002)(186003)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3394;H:AM4PR05MB3396.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3xii1iXt2Czz/Sc9Jl3SoXJ4Yq0EywS0bAeI2/ma7+p6x18exz8K6pN9DUYInvnlNCP6anmisBblPeAaUfWwFU1D3gfL2scbu8so0EEAKniI+3GQlakeEp8e64t5ivAiMojQiU9Z5Ok+oXf+oY4D7ocYmkZEVYQ9BXYlZxRBy6G8HzlX84JpzoogQoL8c/girj31X/cJuQzK2OGEGehTNOyUadwnZBU8V2Qq5DRiopuob6t6x0VhqaiGeIZ53CYzEHGu0qFpTgbRDAJzZ1CmW004qnqmjVH1bgU66esK1s8VOpANqJcKTYUBBk3m44/wAI5HDlNxneDlG3ew+SCCQln2QUVSg4K1VmmUO6HK1lXiX71R1oM4T+ujTbtIfQ3erdFoBoEBG3wwvs7mABIVgi3gj6XZngiyp6Zoyu3tmkT0lJkQHIi6uYsCw2mn4lIy
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E1A1969F2E9994597232BC365429224@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6769bb92-14d4-4c00-955a-08d79e4b995b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 08:26:23.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyd3lbFfso952k6P3jPNQBkNDNNbAmaoPI3VqaYl3aNuCMpVdengMbi5LOQXPKqyJhHeG/njPr3RCnwtdH0Byw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjAtMDEtMjAgNzozOSBQTSwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+IE9u
IFR1ZSwgIDcgSmFuIDIwMjAgMTE6MjI6MTAgKzAyMDANCj4gUm9pIERheWFuIDxyb2lkQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQo+IA0KPj4gVGhpcyBjb21taXQgZml4IGFsbCBsb2NhdGlvbiBpbiBm
bG93ZXIgdG8gdXNlIF9TTF8gaW5zdGVhZCBvZiBcbiBmb3INCj4+IG5ld2xpbmUgdG8gYWxsb3cg
c3VwcG9ydCBmb3Igb25lbGluZSBvcHRpb24uDQo+Pg0KPj4gRXhhbXBsZSBiZWZvcmUgdGhpcyBj
b21taXQ6DQo+Pg0KPj4gZmlsdGVyIHByb3RvY29sIGlwIHByZWYgMiBmbG93ZXIgY2hhaW4gMCBo
YW5kbGUgMHgxDQo+PiAgIGluZGV2IGVuczFmMA0KPj4gICBkc3RfbWFjIDExOjIyOjMzOjQ0OjU1
OjY2DQo+PiAgIGV0aF90eXBlIGlwdjQNCj4+ICAgaXBfcHJvdG8gdGNwDQo+PiAgIHNyY19pcCAy
LjIuMi4yDQo+PiAgIHNyY19wb3J0IDk5DQo+PiAgIGRzdF9wb3J0IDEtMTBcICB0Y3BfZmxhZ3Mg
MHg1LzUNCj4+ICAgaXBfZmxhZ3MgZnJhZw0KPj4gICBjdF9zdGF0ZSAtdHJrXCAgY3Rfem9uZSA0
XCAgY3RfbWFyayAyNTUNCj4+ICAgY3RfbGFiZWwgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAw
MDAwMDANCj4+ICAgc2tpcF9odw0KPj4gICBub3RfaW5faHdcICAgIGFjdGlvbiBvcmRlciAxOiBj
dCB6b25lIDUgcGlwZQ0KPj4gICAgICAgICAgaW5kZXggMSByZWYgMSBiaW5kIDEgaW5zdGFsbGVk
IDI4NyBzZWMgdXNlZCAyODcgc2VjDQo+PiAgICAgICAgIEFjdGlvbiBzdGF0aXN0aWNzOlwgICAg
IFNlbnQgMCBieXRlcyAwIHBrdCAoZHJvcHBlZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkN
Cj4+ICAgICAgICAgYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwXA0KPj4NCj4+IEV4YW1wbGUgb3V0
cHV0IGFmdGVyIHRoaXMgY29tbWl0Og0KPj4NCj4+IGZpbHRlciBwcm90b2NvbCBpcCBwcmVmIDIg
Zmxvd2VyIGNoYWluIDAgaGFuZGxlIDB4MSBcICBpbmRldiBlbnMxZjBcICBkc3RfbWFjIDExOjIy
OjMzOjQ0OjU1OjY2XCAgZXRoX3R5cGUgaXB2NFwgIGlwX3Byb3RvIHRjcFwgIHNyY19pcCAyLjIu
Mi4yXCAgc3JjX3BvcnQgOTlcICBkc3RfcG9ydCAxLTEwXCAgdGNwX2ZsYWdzIDB4NS81XCAgaXBf
ZmxhZ3MgZnJhZ1wgIGN0X3N0YXRlIC10cmtcICBjdF96b25lIDRcICBjdF9tYXJrIDI1NVwgIGN0
X2xhYmVsIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwXCAgc2tpcF9od1wgIG5vdF9p
bl9od1xhY3Rpb24gb3JkZXIgMTogY3Qgem9uZSA1IHBpcGUNCj4+ICAgICAgICAgIGluZGV4IDEg
cmVmIDEgYmluZCAxIGluc3RhbGxlZCAzNDYgc2VjIHVzZWQgMzQ2IHNlYw0KPj4gICAgICAgICBB
Y3Rpb24gc3RhdGlzdGljczpcICAgICBTZW50IDAgYnl0ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3Zl
cmxpbWl0cyAwIHJlcXVldWVzIDApDQo+PiAgICAgICAgIGJhY2tsb2cgMGIgMHAgcmVxdWV1ZXMg
MFwNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0K
Pj4gQWNrZWQtYnk6IEppcmkgUGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPiANCj4gSW4gZ2Vu
ZXJhbCB0aGlzIGlzIGZpbmUuIEEgY291cGxlIG9mIHNtYWxsIHN0eWxlIGlzc3Vlcy4NCj4gWW91
IG1heSBoYXZlIG5vdGljZWQgdGhhdCBpcHJvdXRlMiB1c2VzIGtlcm5lbCBmb3JtYXR0aW5nIHN0
eWxlLg0KPiBUaGVyZWZvcmUgY2hlY2twYXRjaCBpcyB1c2VmdWwgdG9vbCB0byBsb29rIGZvciB0
aGVzZS4NCj4gDQo+IEVSUk9SOiBzcGFjZSByZXF1aXJlZCBhZnRlciB0aGF0ICcsJyAoY3R4OlZ4
VikNCj4gIzE4NzogRklMRTogdGMvZl9mbG93ZXIuYzoxODk4OnENCj4gKwlzcHJpbnRmKG5hbWVm
cm0sIiAgJXMgJSV1IiwgbmFtZSk7DQo+ICAJICAgICAgICAgICAgICAgXg0KPiANCj4gRVJST1I6
IGVsc2Ugc2hvdWxkIGZvbGxvdyBjbG9zZSBicmFjZSAnfScNCj4gIzMyNjogRklMRTogdGMvZl9m
bG93ZXIuYzoyMjk1Og0KPiAgCQl9DQo+ICsJCWVsc2UgaWYgKGZsYWdzICYgVENBX0NMU19GTEFH
U19OT1RfSU5fSFcpIHsNCj4gDQo+IA0KPiBFUlJPUjogc3BhY2UgcmVxdWlyZWQgYWZ0ZXIgdGhh
dCAnLCcgKGN0eDpWeFYpDQo+ICMxODc6IEZJTEU6IHRjL2ZfZmxvd2VyLmM6MTg5ODoNCj4gKwlz
cHJpbnRmKG5hbWVmcm0sIiAgJXMgJSV1IiwgbmFtZSk7DQo+ICAJICAgICAgICAgICAgICAgXg0K
PiANCj4gRVJST1I6IGVsc2Ugc2hvdWxkIGZvbGxvdyBjbG9zZSBicmFjZSAnfScNCj4gIzMyNjog
RklMRTogdGMvZl9mbG93ZXIuYzoyMjk1Og0KPiAgCQl9DQo+ICsJCWVsc2UgaWYgKGZsYWdzICYg
VENBX0NMU19GTEFHU19OT1RfSU5fSFcpIHsNCj4gDQoNCm1pc3NlZCBjaGVja3BhdGNoLiBzb3Jy
eS4gaSdsbCBmaXggYW5kIHNlbmQgdjIuIHRoYW5rcy4NCg==
