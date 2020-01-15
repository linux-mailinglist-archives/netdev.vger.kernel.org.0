Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33113C23A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgAONEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:04:55 -0500
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:44035
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgAONEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:04:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHFrzMBpMgNzL9kuW5HzYx7xOHFBDv0bdvexLdiiP1+lFogOw+o62Km0H7c2qw5cMIMdZPGnl3VhEnVhpJi5MyKnNuG3Cp2tDSNO8X+PMK+huEjTjDXJLTbTqlGFL9RJCXTnKtgS5P+13TpVaPyYSoNIKA81KrerYfFSQzI7amBRoIwd8K67Vr0g6djBMzAAsUf3izTzUW+izA8e1+w3fyQHvOVfBXhkm5/NOXzmU43/GMjnOCgGzQB0hjCWzu0gUx2+AnyufuFm7JwFrKrT0SUFJIJJ9NXQALBxRzELcHtElDCtiuLXLJ8+L1qEt5b7yc7DkJsqaQr02L6ViO+v5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRjU3N98cs1/yxFFNyp7wjNF4ya8LjYllBil+VgCvOo=;
 b=nZo+2Dk7cO9/WAg9F/fJbZ4GbdLHFBBZFlQDeod9HBQt/bLYoZjGK1lrr8AUJ2ZdA1IbfYe8QMCZ8krkmV0po75WT1zPEZLyNVyD+1Nr4TNgVcdvQJjbTg3jLC3zAX1hui0tjtppghHranqxyuN+J2Bb9RdScjR+MGnwmv4ixi0OnKwdWJGGJGBD1Akp0FeNLJZFAz4PkR6Caw8pp50qsmt0yDclwOJUPNLnrdnOq32UPBC91bOHUR/yLSclj0TYM8CGLveh3tROK+ydHrevIVQhjC2Ci1xa30y3bI0RVEQnBQ0lXxFoAWGNK3GiXCJkvhFePx9uF2h+06FuaQLQGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRjU3N98cs1/yxFFNyp7wjNF4ya8LjYllBil+VgCvOo=;
 b=Ma/yxClyQ13qrwTkC0GzC1IEmP37X4bcrk1vPvcdgCcewmo/MU1h5g3pIkZzRTDQJlE8aCRyyw+RNB1APAMsX9XxlEOyCOAIH+IEygIzohyN6S26eF789C/KpczXUBZmDZmoAz0S0tXV/2ZFo+JBWKcfLkHotoAxu79cVPB4Nn8=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB4178.eurprd05.prod.outlook.com (52.134.94.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 13:04:49 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:04:49 +0000
Received: from [10.80.3.21] (193.47.165.251) by AM0PR10CA0031.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Wed, 15 Jan 2020 13:04:48 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Thread-Topic: Expose bond_xmit_hash function
Thread-Index: AQHVy3oG0EtUwers0UGLm6hc+vG4CqfregOAgAA3wQA=
Date:   Wed, 15 Jan 2020 13:04:49 +0000
Message-ID: <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
In-Reply-To: <20200115094513.GS2131@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR10CA0031.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::11) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea9b4b5e-c1ee-4c9d-7853-08d799bb80cc
x-ms-traffictypediagnostic: AM0PR05MB4178:|AM0PR05MB4178:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4178138369B77254D8B81828D3370@AM0PR05MB4178.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(189003)(199004)(53546011)(478600001)(52116002)(8936002)(6486002)(81166006)(8676002)(81156014)(186003)(107886003)(31686004)(26005)(2906002)(4326008)(16526019)(31696002)(2616005)(66946007)(7116003)(956004)(66556008)(71200400001)(66476007)(36756003)(66446008)(5660300002)(64756008)(16576012)(86362001)(54906003)(316002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4178;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jq5PuurpEUOdXS+RJ8zoeV9TKDsLfZXjml/Czpx4YbAENxB6A/6xVMyxl58T5bdW9nPq2BdPk74x9icVNAzF9GbEYV0NfxClGEzuQ0gcY2kAItOCXuUl6pkoTr8N2E6AYmC4o6n90o+18uz6S6PJlDPLgkA9VfkQDnmilCRJVyITgHgEmx3CJyMewn7pWAsV/53dsjMOorF0Ai7EzI3e2LENVDCDaJE/OjkRbFqZB13xwFC5gpK37+ZZAF1gkegkaUUgcXQ9QiklNJ23sVPBgz9o5JckNhDAWZYw/hZln57KU1JTe3wk9/6aRIHcoBkGvXWTpF7yWnTJnbepzhWJ9xbR9oXTz5uVrEwhgXSVNnxMeBw3eLgzt/svJ/wj+8Gz1OpPckgkI31xN49ZIZHXiU68kaIB6VSd1Gacix5zJxplFwQHcA8Hn4HnObop6M7H
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE30D78D3EB53E4EB536089895797E8B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9b4b5e-c1ee-4c9d-7853-08d799bb80cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:04:49.6651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VfIMrigVxEhfa1lP6cNLQBn3wuslNKsS5gBrV+CE51l/wgpsAnU4iR4K5Ko6X+KelbXCaZ+QiSGy53DFj1m+Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4178
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE1LzIwMjAgMTE6NDUgQU0sIEppcmkgUGlya28gd3JvdGU6DQo+IFdlZCwgSmFuIDE1
LCAyMDIwIGF0IDA5OjAxOjQzQU0gQ0VULCBtYW9yZ0BtZWxsYW5veC5jb20gd3JvdGU6DQo+PiBS
RE1BIG92ZXIgQ29udmVyZ2VkIEV0aGVybmV0IChSb0NFKSBpcyBhIHN0YW5kYXJkIHByb3RvY29s
IHdoaWNoIGVuYWJsZXMNCj4+IFJETUHigJlzIGVmZmljaWVudCBkYXRhIHRyYW5zZmVyIG92ZXIg
RXRoZXJuZXQgbmV0d29ya3MgYWxsb3dpbmcgdHJhbnNwb3J0DQo+PiBvZmZsb2FkIHdpdGggaGFy
ZHdhcmUgUkRNQSBlbmdpbmUgaW1wbGVtZW50YXRpb24uDQo+PiBUaGUgUm9DRSB2MiBwcm90b2Nv
bCBleGlzdHMgb24gdG9wIG9mIGVpdGhlciB0aGUgVURQL0lQdjQgb3IgdGhlDQo+PiBVRFAvSVB2
NiBwcm90b2NvbDoNCj4+DQo+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gfCBMMiB8IEwzIHwgVURQIHxJQiBCVEggfCBQ
YXlsb2FkfCBJQ1JDIHwgRkNTIHwNCj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pg0KPj4gV2hlbiBhIGJvbmQgTEFHIG5l
dGRldiBpcyBpbiB1c2UsIHdlIHdvdWxkIGxpa2UgdG8gaGF2ZSB0aGUgc2FtZSBoYXNoDQo+PiBy
ZXN1bHQgZm9yIFJvQ0UgcGFja2V0cyBhcyBhbnkgb3RoZXIgVURQIHBhY2tldHMsIGZvciB0aGlz
IHB1cnBvc2Ugd2UNCj4+IG5lZWQgdG8gZXhwb3NlIHRoZSBib25kX3htaXRfaGFzaCBmdW5jdGlv
biB0byBleHRlcm5hbCBtb2R1bGVzLg0KPj4gSWYgbm8gb2JqZWN0aW9uLCBJIHdpbGwgcHVzaCBh
IHBhdGNoIHRoYXQgZXhwb3J0IHRoaXMgc3ltYm9sLg0KPiBJIGRvbid0IHRoaW5rIGl0IGlzIGdv
b2QgaWRlYSB0byBkbyBpdC4gSXQgaXMgYW4gaW50ZXJuYWwgYm9uZCBmdW5jdGlvbi4NCj4gaXQg
ZXZlbiBhY2NlcHRzICJzdHJ1Y3QgYm9uZGluZyAqYm9uZCIuIERvIHlvdSBwbGFuIHRvIHB1c2gg
bmV0ZGV2DQo+IHN0cnVjdCBhcyBhbiBhcmcgaW5zdGVhZD8gV2hhdCBhYm91dCB0ZWFtPyBXaGF0
IGFib3V0IE9WUyBib25kaW5nPw0KDQpObywgSSBhbSBwbGFubmluZyB0byBwYXNzIHRoZSBib25k
IHN0cnVjdCBhcyBhbiBhcmcuIEN1cnJlbnRseSwgdGVhbSANCmJvbmRpbmcgaXMgbm90IHN1cHBv
cnRlZCBpbiBSb0NFIExBRyBhbmQgSSBkb24ndCBzZWUgaG93IE9WUyBpcyByZWxhdGVkLg0KDQo+
DQo+IEFsc28sIHlvdSBkb24ndCByZWFsbHkgbmVlZCBhIGhhc2gsIHlvdSBuZWVkIGEgc2xhdmUg
dGhhdCBpcyBnb2luZyB0byBiZQ0KPiB1c2VkIGZvciBhIHBhY2tldCB4bWl0Lg0KPg0KPiBJIHRo
aW5rIHRoaXMgY291bGQgd29yayBpbiBhIGdlbmVyaWMgd2F5Og0KPg0KPiBzdHJ1Y3QgbmV0X2Rl
dmljZSAqbWFzdGVyX3htaXRfc2xhdmVfZ2V0KHN0cnVjdCBuZXRfZGV2aWNlICptYXN0ZXJfZGV2
LA0KPiAJCQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCg0KVGhlIHN1Z2dlc3Rpb24gaXMgdG8g
cHV0IHRoaXMgZnVuY3Rpb24gaW4gdGhlIGJvbmQgZHJpdmVyIGFuZCBjYWxsIGl0IA0KaW5zdGVh
ZCBvZiBib25kX3htaXRfaGFzaD8gaXMgaXQgc3RpbGwgbmVjZXNzYXJ5IGlmIEkgaGF2ZSB0aGUg
Ym9uZCBwb2ludGVyPw0KDQo=
