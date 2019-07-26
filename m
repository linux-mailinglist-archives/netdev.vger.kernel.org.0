Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9558774A1
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfGZWsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:48:00 -0400
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:51944
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfGZWr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 18:47:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Foa+MTTYpk0LcoVris74gpU7Ft4xdUzIrVTyyXkCYzk4hKsLTBorUn+WrXBM8RyeodOq42CPUX3diHmIwy+uwSlM9aJb7C7LgaVhP0xN06r33xpKzztnCNSyZJa6UCNUcML4D0+PUh03pQ3i+9ImltScLrVoM/azbz7mT/eqlY6W9D/zVrD9TkJJVU8GhCeyym+bUfOV6U5n8OyHH4gqj7CtNL7yqCyFZM+MzrfRJSnYnZCLR0EYj0kgFbBF+SfMyxuP0HqjW7ab0pZsRf1ngu5gcEWbS5wujLYfGWcEFavfEFGiNxjhPfslQN0BQs6q4exmKEuta/9byba5geYbag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaOn26F4WtocDMe2N4XXKO8jsA58A3V7FPiy4zcSypA=;
 b=oYghEKq4h/T0IsJ5hXuPSH/u9pC7gE78WAWKKSYsv7qgV8Lw1MVoLDnAiMufnI/7lt/luexb85zlbu5gLYw6ICraji0bbAjd20G+fz15xiMKDhg8I26nwJy0gD+yb7eN7x1hzCUkxew9ITIV8KNtEcL0nD1Vr/YBU61ZE5wrnrRceSrBTFY4zcvHeOdaLFb2c78jWdZ79i8x2qEcn/jaCauWg8nQvPo4NSR1QMnEODViFB0YJLPzmNT+H3jiEBVGwZrt2mbSIytTXddSyoGZMI7jQEO58m6Zl3Lw0SoC3OkQ60bHiesHRlPKsAeoJY+X3J3WoI5Y/Nf6y3qEs4sY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaOn26F4WtocDMe2N4XXKO8jsA58A3V7FPiy4zcSypA=;
 b=NKBNiHIFN75gZAa7NyATg5gPtjjRfUOGgKl84Xmk5Rqg23gym/elxLvyd5X6Q5HHu7yD83jIo4UpGdQAw4uac4Y5SCKYblLiKzmjq5Cgjwai6axAMOc9JI7m9h4FJcj4EmpykZl7GfxxbPhRyByz8yPhG1c7zUbBJZjD4CGM1Sk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 22:47:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 22:47:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net-next v2] mlx4/en_netdev: allow offloading VXLAN over
 VLAN
Thread-Topic: [PATCH net-next v2] mlx4/en_netdev: allow offloading VXLAN over
 VLAN
Thread-Index: AQHVQ96DWLEOfLx+/kOGTiHlu4ZC66bdgJSA
Date:   Fri, 26 Jul 2019 22:47:55 +0000
Message-ID: <bba5de399ae2143c2496ed1bf74926fe4031d092.camel@mellanox.com>
References: <2beb05557960e04aa588ecc09e9ee5e5a19fc651.1564164688.git.dcaratti@redhat.com>
In-Reply-To: <2beb05557960e04aa588ecc09e9ee5e5a19fc651.1564164688.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aecfe815-8a91-41a9-2946-08d7121b4cb1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:
x-microsoft-antispam-prvs: <DB6PR0501MB2598D518BD0652DD64189DF5BEC00@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(6436002)(86362001)(316002)(446003)(58126008)(486006)(2616005)(25786009)(110136005)(478600001)(8676002)(4744005)(66446008)(6486002)(229853002)(99286004)(53936002)(3846002)(11346002)(2201001)(6116002)(6512007)(305945005)(7736002)(8936002)(118296001)(66066001)(76116006)(186003)(36756003)(5660300002)(66946007)(91956017)(6506007)(26005)(66556008)(2501003)(64756008)(256004)(68736007)(66476007)(102836004)(81156014)(6246003)(2906002)(81166006)(71200400001)(14454004)(76176011)(71190400001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ByzHgTyrcOHU2Q3yDy4t4i4lIVIdlof6ae4mWwOhNsYHRqUlSm79JxAHusRGYDhN+A1ClbU5K07a2BLiPkQhu9rGGM88j1ekX+WR7ddCOVqEO4TS0p6zeviBVRa+wNQI8vB5Hbik0iAl1OPnaxHNd4HmpDPRcDfT7UmX7kQuhh8/T97NjYrQv3DXcJdjSFoNKKOlhkxtYkdIIBRiDXcFwHy92ZkIQmpxt057MIDyfymldgIpa9QgIZ+wg9ofH9ZrnrJeQ96j3EXo3tucWFw9W6R11S1ULfvdgL2jbF58zzSsZT3mfI1j1KnvjNl8YNZKsWb/6eXRFjRe32f+IxXOjX7J2ezlu4Ojx8+xy4BV6gCCHNG905h8OCes70XpQEz2+giNIU23gu/EGWv5/YwILjRggTDJZyHsSrhNuEDDIMw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <957E0F2AAB0B364FA1A45FBFDFDE768A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aecfe815-8a91-41a9-2946-08d7121b4cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 22:47:55.4621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTI2IGF0IDIwOjE4ICswMjAwLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToN
Cj4gQ29ubmVjdFgtMyBQcm8gY2FuIG9mZmxvYWQgdHJhbnNtaXNzaW9uIG9mIFZMQU4gcGFja2V0
cyB3aXRoIFZYTEFODQo+IGluc2lkZToNCj4gZW5hYmxlIHR1bm5lbCBvZmZsb2FkcyBpbiBkZXYt
PnZsYW5fZmVhdHVyZXMsIGxpa2UgaXQncyBkb25lIHdpdGgNCj4gb3RoZXINCj4gTklDIGRyaXZl
cnMgKGUuZy4gYmUybmV0IGFuZCBpeGdiZSkuDQo+IA0KPiBJdCdzIG5vIG1vcmUgbmVjZXNzYXJ5
IHRvIGNoYW5nZSBkZXYtPmh3X2VuY19mZWF0dXJlcyB3aGVuIFZYTEFOIGFyZQ0KPiBhZGRlZA0K
PiBvciByZW1vdmVkLCBzaW5jZSAubmRvX2ZlYXR1cmVzX2NoZWNrKCkgYWxyZWFkeSBjaGVja3Mg
Zm9yIFZYTEFODQo+IHBhY2tldA0KPiB3aGVyZSB0aGUgVURQIGRlc3RpbmF0aW9uIHBvcnQgbWF0
Y2hlcyB0aGUgY29uZmlndXJlZCB2YWx1ZS4gSnVzdCBzZXQNCj4gZGV2LT5od19lbmNfZmVhdHVy
ZXMgd2hlbiB0aGUgTklDIGlzIGluaXRpYWxpemVkLCBzbyB0aGF0IG92ZXJseWluZw0KPiBWTEFO
DQo+IGNhbiBjb3JyZWN0bHkgaW5oZXJpdCB0aGUgdHVubmVsIG9mZmxvYWQgY2FwYWJpbGl0aWVz
Lg0KPiANCj4gQ2hhbmdlcyBzaW5jZSB2MToNCj4gLSBhdm9pZCBmbGlwcGluZyBod19lbmNfZmVh
dHVyZXMsIGluc3RlYWQgb2YgY2FsbGluZyBuZXRkZXYNCj4gbm90aWZpZXJzLA0KPiAgIHRoYW5r
cyB0byBTYWVlZCBNYWhhbWVlZA0KPiAtIHNxdWFzaCB0d28gcGF0Y2hlcyBpbnRvIGEgc2luZ2xl
IG9uZQ0KPiANCj4gQ0M6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gQ0M6IE1h
cmNlbG8gUmljYXJkbyBMZWl0bmVyIDxtYXJjZWxvLmxlaXRuZXJAZ21haWwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBEYXZpZGUgQ2FyYXR0aSA8ZGNhcmF0dGlAcmVkaGF0LmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0K
