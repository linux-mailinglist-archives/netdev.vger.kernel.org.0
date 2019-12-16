Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC72112002F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLPIqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:46:52 -0500
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:36327
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbfLPIqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 03:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+49xjeEf7j06XMppQJ11X4YU4Rb7FkuEnMCiB5f1Y4VMGEVX4c0+cc/ZtoSKrfjgRa7AADvV/4mN67HJPlJApnGd+elzIli+Qtb51tK+35w4PUg0yEiy06FdPeATEH5mAdwZblceR3Ir5otdZye4/hJy6slFHGTGgZUJ1VYesuATp0wyjlNF5ZI+ADAZtjskBcO8gsw5JVxBAsCKxX2Sr4h+E0ppn06tkSGC6i6QGmGVOPzfITjr/S380nluXvTsmYLKAzlbYPDbh4yR/00fyvIA9pKLPI7jRnBX0Bu+QHo06HVjGzc+4UmzHPpKq+GQz2+NIDcucI1HofDWihy9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laQD9LzY/2bcEjM23eVTvkIybGJ6/ObyDiDvt2VJ3Gg=;
 b=Ibn16bACFs7vtfesk/Xlo5lb3utD23z1sM/2dbrZDGSZxMhoN10HMG+mvYcUN7ReoIWmggqFPT648fG8McdyvaWonUgYIHJdZmSmSBTEbFmZWnDLItxL6UJqlYeEzEVu94ndyR540vTuABrL6uG++wNi4PblfLNJ4gCJvWiz5Qt8sf9ZwPlwQmgBZm3dJ9ocJR3Y22s2EcdCu00QUtNvyryzV8emanvgHCT6ZVrJ9X0laNLie2Vlx5E7qAaEFRSySp0PHfz2EIY2Wio/umWOvy8vyRPDOZtPkLw7i+K/vmeTxDT1XGn0Q8qhE4YRFAR19EI87hnvgzpkQH9TFSx90A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laQD9LzY/2bcEjM23eVTvkIybGJ6/ObyDiDvt2VJ3Gg=;
 b=PCG50NQP+we+QFqV48lP36Grvk23y81YtxQvsGyg7wTRkXqNNK2+HiQZAKs2RNbswITnFlgqjMhc9rnGfKCUHzuK5KtGos732Gi9UKn/ay/lYUrmc57ZTzNFhIi2qYG/1dPFbk396Wv+0kxk+3QTKU+2DkFwXtFbBs8wmKWqZ2o=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5188.eurprd05.prod.outlook.com (20.178.20.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 08:46:45 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 08:46:45 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Topic: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Index: AQHVsIPZtKRJJ1k2sk+Nw8POrjaYSqe2EL8AgADZlgCAAAIPAIAAGscAgAANtQCAAARFgIAFHbSAgAAUygCAAC4FAA==
Date:   Mon, 16 Dec 2019 08:46:45 +0000
Message-ID: <94c9f6a9-cb9d-220c-6558-d7df4e146311@mellanox.com>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
 <20191212115228.2caf0c63@cakuba.netronome.com>
 <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
 <20191212133540.3992ac0c@cakuba.netronome.com>
 <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
 <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
 <b957e025-499d-3a56-80cd-654f4e6bb13a@mellanox.com>
 <435da9c6-b801-951f-ef5a-1cec31ce6493@pensando.io>
In-Reply-To: <435da9c6-b801-951f-ef5a-1cec31ce6493@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.20.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab8b8050-bb09-471a-0ad3-08d782047b6f
x-ms-traffictypediagnostic: AM0PR05MB5188:
x-microsoft-antispam-prvs: <AM0PR05MB51889902CC0D5174833AEF9AD1510@AM0PR05MB5188.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(316002)(31696002)(5660300002)(86362001)(31686004)(55236004)(53546011)(6506007)(2906002)(6486002)(110136005)(76116006)(91956017)(8936002)(66446008)(2616005)(81166006)(8676002)(71200400001)(478600001)(26005)(186003)(81156014)(66946007)(6512007)(36756003)(54906003)(64756008)(66556008)(66476007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5188;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/8N3lRIfE7Fzy4Vlu3UZJbTmoORBkwFbIaqSAikMpAkSJfNGSwr5elUAXCt357nMLsguH9fWqgG/8hBqhuidXSGR7hjUkPXBBmsbxwMT2A+z1NOfSCtA8ypRJzJVsPMJQmgwou0jnhkcFSzOTq3fqlZttOvl8nSbQhsrYBwsSPKOWfFd01MaSTOTwdIT+3gax7aGGs6RTjwkifqNGrtAUC9obV7vbf+scRBSqidrqqMwP57P1QCABCab8WKF3ps4jvfNzpwKnY8qvVSVkXTz93fo8/JToLIzb1mwfOCM3l1aJCpd0Lo5B/WYKWANAYHMrBGKpFJBBm/Wwa33OAzYWBtx9f2DeWaUk2dWzaf1gWYwNz+0HrF7Zv18NIvvIDuA+w9RDza3cN5fzclrl/n2dqfNdZggy9qOQvkdfe5wwZpOyxqlH/BIy5sinQUFjhX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7E35017E6A48B44A8882A9A7B4AF85E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8b8050-bb09-471a-0ad3-08d782047b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 08:46:45.7330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByNcubv6d1O4552kgkrMSDb7ELIZm4EynjspPPx4g7jdcVY72FMutYyQgYtuiZgQ5GRvtN4Ck1tc3XdTD59yWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5188
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTYvMjAxOSAxMTozMiBBTSwgU2hhbm5vbiBOZWxzb24gd3JvdGU6DQo+IE9uIDEyLzE1
LzE5IDg6NDcgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4+IE9uIDEyLzEzLzIwMTkgNDoxMCBB
TSwgU2hhbm5vbiBOZWxzb24gd3JvdGU6DQo+Pj4gT24gMTIvMTIvMTkgMjoyNCBQTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPj4+PiBPbiAxMi8xMi8yMDE5IDM6MzUgUE0sIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPj4+Pj4gT24gVGh1LCAxMiBEZWMgMjAxOSAxMTo1OTo1MCAtMDgwMCwgU2hhbm5v
biBOZWxzb24gd3JvdGU6DQo+Pj4+Pj4gT24gMTIvMTIvMTkgMTE6NTIgQU0sIEpha3ViIEtpY2lu
c2tpIHdyb3RlOg0KPj4+Pj4+PiBPbiBUaHUsIDEyIERlYyAyMDE5IDA2OjUzOjQyICswMDAwLCBQ
YXJhdiBQYW5kaXQgd3JvdGU6DQo+Pj4+Pj4+Pj4gwqDCoMKgIHN0YXRpYyB2b2lkIGlvbmljX3Jl
bW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCj4+Pj4+Pj4+PiDCoMKgwqAgew0KPj4+Pj4+Pj4+
IMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBpb25pYyAqaW9uaWMgPSBwY2lfZ2V0X2RydmRhdGEocGRl
dik7DQo+Pj4+Pj4+Pj4gQEAgLTI1Nyw2ICszMzgsOSBAQCBzdGF0aWMgdm9pZCBpb25pY19yZW1v
dmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+Pj4+Pj4+Pj4gwqDCoMKgwqDCoMKgwqAgaWYgKCFp
b25pYykNCj4+Pj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4+Pj4+Pj4+
PiDCoMKgwqAgK8KgwqDCoCBpZiAocGNpX251bV92ZihwZGV2KSkNCj4+Pj4+Pj4+PiArwqDCoMKg
wqDCoMKgwqAgaW9uaWNfc3Jpb3ZfY29uZmlndXJlKHBkZXYsIDApOw0KPj4+Pj4+Pj4+ICsNCj4+
Pj4+Pj4+IFVzdWFsbHkgc3Jpb3YgaXMgbGVmdCBlbmFibGVkIHdoaWxlIHJlbW92aW5nIFBGLg0K
Pj4+Pj4+Pj4gSXQgaXMgbm90IHRoZSByb2xlIG9mIHRoZSBwY2kgUEYgcmVtb3ZhbCB0byBkaXNh
YmxlIGl0IHNyaW92Lg0KPj4+Pj4+PiBJIGRvbid0IHRoaW5rIHRoYXQncyB0cnVlLiBJIGNvbnNp
ZGVyIGlnYiBhbmQgaXhnYmUgdG8gc2V0IHRoZQ0KPj4+Pj4+PiBzdGFuZGFyZA0KPj4+Pj4+PiBm
b3IgbGVnYWN5IFNSLUlPViBoYW5kbGluZyBzaW5jZSB0aGV5IHdlcmUgb25lIG9mIHRoZSBmaXJz
dCAodGhlDQo+Pj4+Pj4+IGZpcnN0PykNCj4+Pj4+Pj4gYW5kIEFsZXggRHV5Y2sgd3JvdGUgdGhl
bS4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gbWx4NCwgYm54dCBhbmQgbmZwIGFsbCBkaXNhYmxlIFNSLUlP
ViBvbiByZW1vdmUuDQo+Pj4+Pj4gVGhpcyB3YXMgbXkgdW5kZXJzdGFuZGluZyBhcyB3ZWxsLCBi
dXQgbm93IEkgY2FuIHNlZSB0aGF0IGl4Z2JlIGFuZA0KPj4+Pj4+IGk0MGUNCj4+Pj4+PiBhcmUg
Ym90aCBjaGVja2luZyBmb3IgZXhpc3RpbmcgVkZzIGluIHByb2JlIGFuZCBzZXR0aW5nIHVwIHRv
IHVzZQ0KPj4+Pj4+IHRoZW0sDQo+Pj4+Pj4gYXMgd2VsbCBhcyB0aGUgbmV3ZXIgaWNlIGRyaXZl
ci7CoCBJIGZvdW5kIHRoaXMgdG9kYXkgYnkgbG9va2luZyBmb3INCj4+Pj4+PiB3aGVyZSB0aGV5
IHVzZSBwY2lfbnVtX3ZmKCkuDQo+Pj4+PiBSaWdodCwgaWYgdGhlIFZGcyB2ZXJ5IGFscmVhZHkg
ZW5hYmxlZCBvbiBwcm9iZSB0aGV5IGFyZSBzZXQgdXAuDQo+Pj4+Pg0KPj4+Pj4gSXQncyBhIGJp
dCBvZiBhIGFzeW1tZXRyaWMgZGVzaWduLCBpbiBjYXNlIHNvbWUgb3RoZXIgZHJpdmVyIGxlZnQN
Cj4+Pj4+IFNSLUlPViBvbiwgSSBndWVzcy4NCj4+Pj4+DQo+Pj4+IEkgcmVtZW1iZXIgb24gb25l
IGVtYWlsIHRocmVhZCBvbiBuZXRkZXYgbGlzdCBmcm9tIHNvbWVvbmUgdGhhdCBpbiBvbmUNCj4+
Pj4gdXNlIGNhc2UsIHRoZXkgdXBncmFkZSB0aGUgUEYgZHJpdmVyIHdoaWxlIFZGcyBhcmUgc3Rp
bGwgYm91bmQgYW5kDQo+Pj4+IFNSLUlPViBrZXB0IGVuYWJsZWQuDQo+Pj4+IEkgYW0gbm90IHN1
cmUgaG93IG11Y2ggaXQgaXMgdXNlZCBpbiBwcmFjdGljZS9vciBwcmFjdGljYWwuDQo+Pj4+IFN1
Y2ggdXNlIGNhc2UgbWF5IGJlIHRoZSByZWFzb24gdG8ga2VlcCBTUi1JT1YgZW5hYmxlZC4NCj4+
PiBUaGlzIGJyaW5ncyB1cCBhIHBvdGVudGlhbCBjb3JuZXIgY2FzZSB3aGVyZSBpdCB3b3VsZCBi
ZSBiZXR0ZXIgZm9yIHRoZQ0KPj4+IGRyaXZlciB0byB1c2UgaXRzIG93biBudW1fdmZzIHZhbHVl
IHJhdGhlciB0aGFuIHJlbHlpbmcgb24gdGhlDQo+Pj4gcGNpX251bV92ZigpIHdoZW4gYW5zd2Vy
aW5nIHRoZSBuZG9fZ2V0X3ZmXyooKSBjYWxsYmFja3MsIGFuZCBhdCBsZWFzdA0KPj4+IHRoZSBp
Z2IgbWF5IGJlIHN1c2NlcHRpYmxlLg0KPj4gUGxlYXNlIGRvIG5vdCBjYWNoZSBudW1fdmZzIGlu
IGRyaXZlci4gVXNlIHRoZSBwY2kgY29yZSdzIHBjaV9udW1fdmYoKQ0KPj4gaW4gdGhlIG5ldyBj
b2RlIHRoYXQgeW91IGFyZSBhZGRpbmcuDQo+IA0KPiBJIGRpc2FncmVlLsKgIFRoZSBwY2lfbnVt
X3ZmKCkgdGVsbHMgdXMgd2hhdCB0aGUga2VybmVsIGhhcyBzZXQgdXAgZm9yDQo+IFZGcyBydW5u
aW5nLCB3aGlsZSB0aGUgZHJpdmVyJ3MgbnVtX3ZmcyB0cmFja3MgaG93IG1hbnkgcmVzb3VyY2Vz
IHRoZQ0KPiBkcml2ZXIgaGFzIHNldCB1cCBmb3IgaGFuZGxpbmcgVkZzOiB0aGVzZSBhcmUgdHdv
IGRpZmZlcmVudCBudW1iZXJzLCBhbmQNCj4gdGhlcmUgYXJlIHRpbWVzIGluIHRoZSBsaWZlIG9m
IHRoZSBkcml2ZXIgd2hlbiB0aGVzZSBudW1iZXJzIGFyZQ0KPiBkaWZmZXJlbnQuwqAgWWVzLCB0
aGVzZSBhcmUgc21hbGwgd2luZG93cyBvZiB0aW1lLCBidXQgdGhleSBhcmUgZGlmZmVyZW50DQo+
IGFuZCBuZWVkIHRvIGJlIHRyZWF0ZWQgZGlmZmVyZW50bHkuDQo+IA0KVGhleSBzaG91bGRuJ3Qg
YmUgZGlmZmVyZW50LiBXaHkgYXJlIHRoZXkgZGlmZmVyZW50Pw0KDQo+PiBNb3JlIGJlbG93Lg0K
Pj4+IElmIHRoZSBkcml2ZXIgaGFzbid0IHNldCB1cCBpdHMgdmZbXSBkYXRhDQo+Pj4gYXJyYXlz
IGJlY2F1c2UgdGhlcmUgd2FzIGFuIGVycm9yIGluIHNldHRpbmcgdGhlbSB1cCBpbiB0aGUgcHJv
YmUoKSwgYW5kDQo+Pj4gbGF0ZXIgc29tZW9uZSB0cmllcyB0byBnZXQgVkYgc3RhdGlzdGljcywg
dGhlIG5kb19nZXRfdmZfc3RhdHMgY2FsbGJhY2sNCj4+PiBjb3VsZCBlbmQgdXAgZGVyZWZlcmVu
Y2luZyBiYWQgcG9pbnRlcnMgYmVjYXVzZSB2ZiBpcyBsZXNzIHRoYW4NCj4+PiBwY2lfbnVtX3Zm
KCkgYnV0IG1vcmUgdGhhbiB0aGUgbnVtYmVyIG9mIHZmW10gc3RydWN0cyBzZXQgdXAgYnkgdGhl
DQo+Pj4gZHJpdmVyLg0KPj4+DQo+Pj4gSSBzdXBwb3NlIHRoZSBhcmd1bWVudCBjb3VsZCBiZSBt
YWRlIHRoYXQgUEYncyBwcm9iZSBzaG91bGQgaWYgdGhlIFZGDQo+Pj4gY29uZmlnIGZhaWxzLCBi
dXQgaXQgbWlnaHQgYmUgbmljZSB0byBoYXZlIHRoZSBQRiBkcml2ZXIgcnVubmluZyB0byBoZWxw
DQo+Pj4gZml4IHVwIHdoYXRldmVyIHdoZW4gc2lkZXdheXMgaW4gdGhlIFZGIGNvbmZpZ3VyYXRp
b24uDQo+Pj4NCj4+PiBzbG4NCj4+Pg0KPj4gSSBub3QgaGF2ZSBzdHJvbmcgb3BpbmlvbiBvbiBs
ZXR0aW5nIHNyaW92IGVuYWJsZWQvZGlzYWJsZWQgb24gUEYgZGV2aWNlDQo+PiByZW1vdmFsLg0K
Pj4gQnV0IGl0IHNob3VsZCBiZSBzeW1tZXRyaWMgb24gcHJvYmUoKSBhbmQgcmVtb3ZlKCkgZm9y
IFBGLg0KPj4gSWYgeW91IHdhbnQgdG8ga2VlcCBpdCBlbmFibGVkIG9uIFBGIHJlbW92YWwsIHlv
dSBuZWVkIHRvIGNoZWNrIG9uIHByb2JlDQo+PiBhbmQgYWxsb2NhdGUgVkYgbWV0YWRhdGEgeW91
IGhhdmUgYnkgdXNpbmcgaGVscGVyIGZ1bmN0aW9uIGluDQo+PiBzcmlvdl9jb25maWd1cmUoKSBh
bmQgaW4gcHJvYmUoKS4NCj4+IFRoaXMgaXMgZm9sbG93ZWQgYnkgbWx4NSBkcml2ZXIuDQo+IA0K
PiBBZ3JlZWQsIGFuZCB0aGlzIGNoZWNrIGF0IHByb2JlIHRpbWUgaXMgaW5jbHVkZWQgaW4gdGhl
IHYzIHBhdGNoIHRoYXQgSQ0KPiBzZW50IG91dCBvbiBGcmlkYXkuDQo+IA0Kb2suIFdpbGwgcmV2
aWV3LiBUaGFua3MuDQoNCj4gc2xuDQo+IA0KPiANCg0K
