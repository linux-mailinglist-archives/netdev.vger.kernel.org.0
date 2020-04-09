Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1731A3CC1
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgDIXHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 19:07:50 -0400
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:32741
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726734AbgDIXHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 19:07:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gdn2W/8UAtxUr+LGXUNgCT2OTQCsEJB8EluBDsVXe9eus8Z9jvZSqi9tVIlarJcB7CDOrqwfQqmHNRR4IC2nRQiEOoEVLp8AxaFfC7Kq2QJfwxEI69eNRfg9ZfZT1aJwaWLpXLkDvnHlWDKMADssZLxud+2JuTM5mzKzL8JfrncAx2WItUa8/En5PLmtTwusIkKcVFfoJGM53jLTaVH0IgA6SBj58b9xD2Of6Jta/XWVme6Kvtie3xsfHQd/gYXSzjxV34JAXgZEgyff9BYLIVeOSdxAswdho73fFC7T1ryrICHFvYBgXdzkKMLX0CAw4eb3wWVI6dYcBv3K8isHpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57XNf6TvXBAL1zdN7hslTymk7wMuu2C9zU5Crz0J3bw=;
 b=N98zu/yJ6wWWElOyv9aOqcH6EwaTUUBYyYlNyR1+nn1vQ3So1ZP2sR19x8jEQXw7N/DnFz/vMSeBjbqOGg75eMzHgSc8fUwRok+JGkg45cCJuR3C/s9FV1ZIaAmgtDsGmEpuDbZSANBoAH3IKWoYqYbGd6d2TBO5snfseg5PgU+vzrfiRs2B7UDRn2zzQDb6KsC68t6xxtIvMizRQ2TTFhBhqNKbRCTUiSfG9v4+GWgRRieO6l4JhheUB06BxoCAfDJGfolPqjWTkX87cB7Dyq35QVILUbIyyVvB7clZSv/g0j554XTyBt4G73znFOzyeXMT/nIvht3818iw9swrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57XNf6TvXBAL1zdN7hslTymk7wMuu2C9zU5Crz0J3bw=;
 b=S+rD1UK+mPgljK7MAYD5wefno3LnFnN39x+yeSb1iIJmdKG7iv4KUFX0yV5kdqQ2IOa5l9E2LPJqsW8jvZn4+CIwi1gIx2bgg3fPvhcp5LRKYwshCswRkshgUHAn1KXm7hyvQ/y/3KUSuObeMyBj2UAtXEd+2YAB/hUdoHbTmSk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6349.eurprd05.prod.outlook.com (2603:10a6:803:f6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 23:07:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 23:07:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Topic: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Index: AQHWDZv32mnm8kot3EKhksvfBkWZN6hvggyAgABz5gCAAAbkAIABbhYA
Date:   Thu, 9 Apr 2020 23:07:42 +0000
Message-ID: <7a92118a956a29bbc62373af43832e30a39225f5.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634663936.707275.3156718045905620430.stgit@firesoul>
         <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
         <a101ea0284504b65edcd8f83bd7a05747c6f8014.camel@mellanox.com>
         <20200408181308.4e1cf9fc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200408181308.4e1cf9fc@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 443b3cff-a224-45bd-80dc-08d7dcdacec8
x-ms-traffictypediagnostic: VI1PR05MB6349:
x-microsoft-antispam-prvs: <VI1PR05MB63494A1FD9924E3680F4E378BEC10@VI1PR05MB6349.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(81156014)(91956017)(6512007)(7416002)(54906003)(64756008)(186003)(71200400001)(66446008)(66556008)(81166007)(66946007)(4326008)(6916009)(5660300002)(66476007)(86362001)(478600001)(6486002)(2616005)(8676002)(76116006)(36756003)(8936002)(6506007)(2906002)(316002)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4nmqUB6Nvai1FaOXIA6A8ZqKtZrn3QQFWyVPVtwcgbDR7T9XK82zlR0UbfBL4pdFK6VlBjAo4EAQraD5t005vcRzvi0G0G+hLOmysbtJbu0xHpWlUK+/yElFV/mdzAOBw787yManvUmG+0rzeGnK02Xl64xIDOmpczEiAGz+XFi091BDFQTQtls6B/VgB+fYfL7bCEecHzWVgEdMJEO3M8L07omaniGlgEQvEOk5eIDZ+K7P8Q6yo11mxlNT8WzBJTrD4TQ0iidZBt4ptNJvB5bFFUCbPOCFVSC9Ynhozy5R+FXPzLzj+96My9BwPBAgS5Si2edsiJm1vWxyDvXgMM+OYxepaJRSOSBvRWRUSOgujdpm0Egi3QWr2XJrzMwk8m9BZx9MBZhcgblymu9Ptcc8HYcZjU8RSd5wqivYnm+2UJpuCdechT8v0Jqv3+M
x-ms-exchange-antispam-messagedata: ZAu8dPvdLoJv674GDRcJTPU4QxOeFnS5TAdJYd38PoNjYy6yHjVWfh1eSc9NQsBO9WVvpXridcLR1uB2sT7LGibJHHk2WrHoc9/ddqsI9MWNMjph7N4bzrxtvAv1KBgMdbqcp7QDXDcoOuFo1Lqshg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <189D3AAB3F54354097D1D8BA88FF9ED8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443b3cff-a224-45bd-80dc-08d7dcdacec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 23:07:42.5253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u1IILYGf5UqI/v+e7GCV4JMzo8rPK+X4eLE1SsyCY3bhqVsUb23vZihTmQsVQAo6YOI0sAX1qgUcNRare2o+dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6349
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDE4OjEzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA5IEFwciAyMDIwIDAwOjQ4OjMwICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+ID4gPiArICogVGhpcyBtYWNybyByZXNlcnZlcyB0YWlscm9vbSBpbiB0aGUgWERQIGJ1
ZmZlciBieSBsaW1pdGluZw0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gKyAqIFhEUC9CUEYgZGF0YSBh
Y2Nlc3MgdG8gZGF0YV9oYXJkX2VuZC4gIE5vdGljZSBzYW1lIGFyZWENCj4gPiA+ID4gKGFuZA0K
PiA+ID4gPiBzaXplKQ0KPiA+ID4gPiArICogaXMgdXNlZCBmb3IgWERQX1BBU1MsIHdoZW4gY29u
c3RydWN0aW5nIHRoZSBTS0IgdmlhDQo+ID4gPiA+IGJ1aWxkX3NrYigpLg0KPiA+ID4gPiArICov
DQo+ID4gPiA+ICsjZGVmaW5lIHhkcF9kYXRhX2hhcmRfZW5kKHhkcCkJCQkJXA0KPiA+ID4gPiAr
CSgoeGRwKS0+ZGF0YV9oYXJkX3N0YXJ0ICsgKHhkcCktPmZyYW1lX3N6IC0JXA0KPiA+ID4gPiAr
CSBTS0JfREFUQV9BTElHTihzaXplb2Yoc3RydWN0IHNrYl9zaGFyZWRfaW5mbykpKSAgDQo+ID4g
PiANCj4gPiA+IEkgdGhpbmsgaXQgc2hvdWxkIGJlIHNhaWQgc29tZXdoZXJlIHRoYXQgdGhlIGRy
aXZlcnMgYXJlIGV4cGVjdGVkDQo+ID4gPiB0bw0KPiA+ID4gRE1BIG1hcCBtZW1vcnkgdXAgdG8g
eGRwX2RhdGFfaGFyZF9lbmQoeGRwKS4NCj4gPiA+ICAgDQo+ID4gDQo+ID4gYnV0IHRoaXMgd29y
a3Mgb24gYSBzcGVjaWZpYyB4ZHAgYnVmZiwgZHJpdmVycyB3b3JrIHdpdGggbXR1DQo+ID4gDQo+
ID4gYW5kIHdoYXQgaWYgdGhlIGRyaXZlciB3YW50IHRvIGhhdmUgdGhpcyBhcyBhbiBvcHRpb24g
cGVyIHBhY2tldA0KPiA+IC4uIA0KPiA+IGkuZS46IGlmIHRoZXJlIGlzIGVub3VnaCB0YWlsIHJv
b20sIHRoZW4gYnVpbGRfc2tiLCBvdGhlcndpc2UNCj4gPiBhbGxvYyBuZXcgc2tiLCBjb3B5IGhl
YWRlcnMsIHNldHVwIGRhdGEgZnJhZ3MuLiBldGMNCj4gPiANCj4gPiBoYXZpbmcgc3VjaCBsaW1p
dGF0aW9ucyBvbiBkcml2ZXIgY2FuIGJlIHZlcnkgc3RyaWN0LCBpIHRoaW5rIHRoZQ0KPiA+IGRl
Y2lzaW9uIG11c3QgcmVtYWluIGR5bmFtaWMgcGVyIGZyYW1lLi4NCj4gPiANCj4gPiBvZi1jb3Vy
c2UgZHJpdmVycyBzaG91bGQgb3B0aW1pemUgdG8gcHJlc2VydmUgZW5vdWdoIHRhaWwgcm9vbSBm
b3INCj4gPiBhbGwNCj4gPiByeCBwYWNrZXRzLi4gDQo+IA0KPiBNeSBjb25jZXJuIGlzIHRoYXQg
ZHJpdmVyIG1heSBhbGxvY2F0ZSBhIGZ1bGwgcGFnZSBmb3IgZWFjaCBmcmFtZSBidXQNCj4gb25s
eSBETUEgbWFwIHRoZSBhbW91bnQgdGhhdCBjYW4gcmVhc29uYWJseSBjb250YWluIGRhdGEgZ2l2
ZW4gdGhlDQo+IE1UVS4NCj4gVG8gc2F2ZSBvbiBETUEgc3luY3MuDQo+IA0KPiBUb2RheSB0aGF0
IHdvdWxkbid0IGJlIGEgcHJvYmxlbSwgYmVjYXVzZSBYRFBfUkVESVJFQ1Qgd2lsbCByZS1tYXAN
Cj4gdGhlDQo+IHBhZ2UsIGFuZCBYRFBfVFggaGFzIHRoZSBzYW1lIE1UVS4NCj4gDQoNCkkgYW0g
bm90IHdvcnJpZWQgYWJvdXQgZG1hIGF0IGFsbCwgaSBhbSB3b3JyaWVkIGFib3V0IHRoZSB4ZHAg
cHJvZ3MNCndoaWNoIGFyZSBub3cgYWxsb3dlZCB0byBleHRlbmQgcGFja2V0cyBiZXlvbmQgdGhl
IG10dSBhbmQgZG8gWERQX1RYLg0KYnV0IGFzIGkgYW0gdGhpbmtpbmcgYWJvdXQgdGhpcyBpIGp1
c3QgcmVhbGl6ZWQgdGhhdCB0aGlzIGNhbiBhbHJlYWR5DQpoYXBwZW4gd2l0aCB4ZHBfYWRqdXN0
X2hlYWQoKS4uDQoNCmJ1dCBhcyB5b3Ugc3RhdGVkIGFib3ZlIHRoaXMgcHV0cyBhbG90IG9mIGFz
c3VtcHRpb25zIG9uIGhvdyBkcml2ZXINCnNob3VsZCBkbWEgcnggYnVmZnMgDQoNCj4gSW4gdGhp
cyBzZXQgeGRwX2RhdGFfaGFyZF9lbmQgaXMgdXNlZCBib3RoIHRvIGZpbmQgdGhlIGVuZCBvZiBt
ZW1vcnkNCj4gYnVmZmVyLCBhbmQgZW5kIG9mIERNQSBidWZmZXIuIEltcGxlbWVudGF0aW9uIG9m
DQo+IGJwZl94ZHBfYWRqdXN0X3RhaWwoKQ0KPiBhc3N1bWVzIGFueXRoaW5nIDwgU0tCX0RBVEFf
QUxJR04oc2l6ZW9mKHN0cnVjdCBza2Jfc2hhcmVkX2luZm8pKQ0KPiBmcm9tDQo+IHRoZSBlbmQg
aXMgZmFpciBnYW1lLg0KPiANCg0KYnV0IHdoeSBza2Jfc2hhcmVkX2luZm8gaW4gcGFydGljdWxh
ciB0aG91Z2ggPyB0aGlzIGFzc3VtZXMgc29tZW9uZQ0KbmVlZHMgdGhpcyB0YWlsIGZvciBidWls
ZGluZyBza2JzIC4uIGxvb2tzIHdlaXJkIHRvIG1lLg0KDQo+IFNvIEkgd2FzIHRyeWluZyB0byBz
YXkgdGhhdCB3ZSBzaG91bGQgd2FybiBkcml2ZXIgYXV0aG9ycyB0aGF0IHRoZQ0KPiBETUENCj4g
YnVmZmVyIGNhbiBub3cgZ3JvdyAvIG1vdmUgYmV5b25kIHdoYXQgdGhlIGRyaXZlciBtYXkgZXhw
ZWN0IGluDQo+IFhEUF9UWC4NCg0KQWNrLCBidXQgY2FuIHdlIGRvIGl0IGJ5IGRlc2luZyA/IGku
ZSBpbnN0ZWFkIG9mIGhhdmluZyBoYXJkY29kZWQNCmxpbWl0cyAoZS5nLiBTS0JfREFUQV9BTElH
TihzaGluZm8pKSBpbiBicGZfeGRwX2FkanVzdF90YWlsKCksIGxldCB0aGUNCmRyaXZlciBwcm92
aWRlIHRoaXMsIG9yIGFueSBvdGhlciByZXN0cmljdGlvbnMsIGUuZyBtdHUgZm9yIHR4LCBvcg0K
ZHJpdmVyIHNwZWNpZmljIG1lbW9yeSBtb2RlbCByZXN0cmljdGlvbnMgLi4gDQoNCj4gRHJpdmVy
cyBjYW4gZWl0aGVyIERNQSBtYXAgZW5vdWdoIG1lbW9yeSwgb3IgaGFuZGxlIHRoZSBjb3JuZXIg
Y2FzZQ0KPiBpbg0KPiBhIHNwZWNpYWwgd2F5Lg0KPiANCj4gSURLIGlmIHRoYXQgbWFrZXMgc2Vu
c2UsIHdlIG1heSBiZSB0YWxraW5nIHBhc3QgZWFjaCBvdGhlciA6KQ0K
