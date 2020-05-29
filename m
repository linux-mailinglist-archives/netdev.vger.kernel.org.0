Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A21E8B80
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgE2WrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:47:20 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6236
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbgE2WrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:47:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKRiw1s2Ld6pTpHlsD2wpti1p7eF0bg8N709etnSuxUbWUIn1f2VAeVD6YUKIOw3xeC1HM3fftCwg3kVmS9TMOD+QSAbw3qvuMwLP2sy6thsGWc7Txx5VQ3OmHMryNRXaJiRJKF9ElyRfd5siTJ6cEvagBNM6l74iqhSDXm4ecPpLxjdrOznz+GwPPsBCADvFhjLEOdykanGNXygR26nAmb4CDzIDhL0aCPd9zxGGjGlYNqBkrjM/swCAFNJ+5AbMmWStm+qcXIFfu1mdirN+e0NHFem9pBFK/DAoHiglDro53TABEs5dlTZUhKTsyZLy1ZeI4eVYCvv1LptABJkjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMgVMWfStctnBH5muqQcknls73hzkZ3rxCtHxTtvI9o=;
 b=ELQhTGf1A9F4nao3i68fivjoTgoZjv35pZr4KY4H3VvSwRcYzPu4ggNi6jlE9GKvuMcbJWkRoxdWghSPnYJkyd41WaSurf6xzrAhg3akWWRx0Dfp/59W83TIKNfmXdJCw3BQhayJJlXpoEM0ifWvdhaLLqYP+wcnU4ssLQ1i17BsIOKkb8cbaxF8MvTVTOXl3izGudIzoNHbIkHwLxY6htcWgdCm6FhFvR+W6BalL1PbAyOpE1oZNoFGrzw6Q29IYORl1+mndZ6hKhqosbc3XiKpjHLDt4Fm9SZKqr3DMu1TnxnAaU8B+3k+Wey1FuDVORV0HqYt81lVuSpdc1QBTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMgVMWfStctnBH5muqQcknls73hzkZ3rxCtHxTtvI9o=;
 b=WLSAq0UWRaVh4wQaMbV0IY/XuiMnZhIsMyC++ec89Acf0KXeSTe2g93pEq2ZTTyemhfc1AhW+6q2yywdUXGNEPFYfEdFKNl9iV9+uHVbIBjKu/ZaIJzNgadcOZxsWaxNoOJ5mIMzzJvs2NhHokBbAicrPYG4nbtx3OqP/MNKWXo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5871.eurprd05.prod.outlook.com (2603:10a6:803:e9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 22:47:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 22:47:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Topic: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Index: AQHWNfH6mom1hs1JjU+8qCOucXKJOKi/gDGAgAAHzoCAABKDgIAAD8gA
Date:   Fri, 29 May 2020 22:47:14 +0000
Message-ID: <715f6826c876f78dd79264cc5bc0ae4601a95630.camel@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
         <20200529194641.243989-11-saeedm@mellanox.com>
         <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
         <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd958380-936c-42c1-f622-08d804223b8a
x-ms-traffictypediagnostic: VI1PR05MB5871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB587190EF51108C6760A8EFBBBE8F0@VI1PR05MB5871.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UG7c5MhfuCdasTtpRoZMjhZdiUfQB1FrBFb1htgl+8RgcMVvMhZoMQplszawNN4xaYnrRrQdoSsYjTUcX+yiXz+g5R/xxHD+frNu12p2IA4WUuHp5nBRZM6daL3IaX0JvhCEwi+wKbD61p+uCj2Ub5zwmRe59q9NRCuofFgAfqO6FLom5UuHg1Z4fzpZcWRGHLzMqkZJNaT/83FQObrvWLIkAby5+1UBJgDShjbKEikO4Iw18qN0BZ9x7IMjw2zI94F8Mh5cZS6XkFDgBdX3q8dLgUfYPCAH455Nhby5dk5CnezFG3qRVkx1VpCa2yYHt+raR1Son2dLd2uiACuHbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(8936002)(86362001)(6506007)(2616005)(8676002)(2906002)(4326008)(186003)(5660300002)(54906003)(316002)(26005)(110136005)(6486002)(107886003)(478600001)(83380400001)(66446008)(66556008)(66946007)(66476007)(6512007)(64756008)(71200400001)(36756003)(91956017)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0Y0mVVH5OF0ouQNiXaS1U+5jV0L6OkDvYlCEuCfuknwCUslYFUblnMoUJehhSK9PCm6PHmkRRzsAOwzpNNKkAaLq3QXQHKocfHhv+ryjbowyQZUK3AZ7/PDIYWk4p4+OFMYpg1zgkfQTA2V6H3cuNLQbiscRueTgCDo/oPxRyXRuLH8D0KHMjfG1XDSMk5tW4HVBrwplqyt87cIPxn09jhjenP+WrIc4/BKl4MbysE27S23toCMt/p23XeFbh6OxNybCFSq0yPOXBBl9OAQZJ6dpw7YrisTvk5OgcTkMdG3IGQLRI2BUd2V8Gm4jh6ri8JiDzE77/r9e1QtMt027LCE+08rgt0VxVKHIVAVa2OipT1pA2/wgDPsyzexXhIc7HSwe+6uHxVGMMHGm03BlwDlmcn3Egy/BBi9sobICaHLgRmLzDBr56bKYQJabrCIvqIIDJ+7DZgd1eIvlz9WZeKw8PHFfidH1ntok9PiUJ6U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68E7E47E2CC2C249AAA8CA478A80F7BE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd958380-936c-42c1-f622-08d804223b8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 22:47:14.4988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G0KhLanhCE6sRlDj1OF0YKqs4bGnwI3HS8wM0TSu3gRhJsb91bAlH0ci+D+4NzIkQD8fZYoeGh1wWJFQCNSW3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTI5IGF0IDE0OjUwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyOSBNYXkgMjAyMCAyMDo0NDoyOSArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiA+IEkgdGhvdWdodCB5b3Ugc2FpZCB0aGF0IHJlc3luYyByZXF1ZXN0cyBhcmUgZ3Vh
cmFudGVlZCB0byBuZXZlcg0KPiA+ID4gZmFpbD8NCj4gPiANCj4gPiBJIGRpZG4ndCBzYXkgdGhh
dCA6KSwgIG1heWJlIHRhcmlxIGRpZCBzYXkgdGhpcyBiZWZvcmUgbXkgcmV2aWV3LA0KPiANCj4g
Qm9yaXMgOykNCj4gDQo+ID4gYnV0IGJhc2ljYWxseSB3aXRoIHRoZSBjdXJyZW50IG1seDUgYXJj
aCwgaXQgaXMgaW1wb3NzaWJsZSB0bw0KPiA+IGd1YXJhbnRlZQ0KPiA+IHRoaXMgdW5sZXNzIHdl
IG9wZW4gMSBzZXJ2aWNlIHF1ZXVlIHBlciBrdGxzIG9mZmxvYWRzIGFuZCB0aGF0IGlzDQo+ID4g
Z29pbmcNCj4gPiB0byBiZSBhbiBvdmVya2lsbCENCj4gDQo+IElJVUMgZXZlcnkgb29vIHBhY2tl
dCBjYXVzZXMgYSByZXN5bmMgcmVxdWVzdCBpbiB5b3VyIGltcGxlbWVudGF0aW9uDQo+IC0NCj4g
aXMgdGhhdCB0cnVlPw0KPiANCg0KRm9yIHR4IHllcywgZm9yIFJYIGkgYW0gbm90IHN1cmUsIHRo
aXMgaXMgYSBodyBmbG93IHRoYXQgSSBhbSBub3QgZnVsbHkNCmZhbWlsaWFyIHdpdGguDQoNCkFu
eXdheSBhY2NvcmRpbmcgdG8gVGFyaXEsIFRoZSBodyBtaWdodCBnZW5lcmF0ZSBtb3JlIHRoYW4g
b25lIHJlc3luYw0KcmVxdWVzdCBvbiB0aGUgc2FtZSBmbG93LCBhbmQgdGhpcyBpcyBhbGwgYmVp
bmcgaGFuZGxlZCBieSB0aGUgZHJpdmVyDQpjb3JyZWN0bHkuIEkgYW0gbm90IHN1cmUgaWYgdGhp
cyBpcyB3aGF0IHlvdSBhcmUgbG9va2luZyBmb3IuDQoNCk1heWJlIFRhcmlxL0JvcmlzIGNhbiBl
bGFib3JhdGUgbW9yZSBvbiB0aGUgaHcgcmVzeW5jIG1lY2hhbmlzbS4NCg0KPiBJdCdkIGJlIGdy
ZWF0IHRvIGhhdmUgbW9yZSBpbmZvcm1hdGlvbiBhYm91dCB0aGUgb3BlcmF0aW9uIG9mIHRoZQ0K
PiBkZXZpY2UgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLi4NCj4gDQoNCkhvdyBhYm91dDoNCg0KUmVz
eW5jIGZsb3cgb2NjdXJzIHdoZW4gcGFja2V0cyBoYXZlIGJlZW4gbG9zdCBhbmQgdGhlIGRldmlj
ZSBsb3N0DQp0cmFjayBvZiBUTFMgcmVjb3Jkcy4gVGhlIGRldmljZSBhdHRlbXB0cyB0byByZXN5
bmMgYnkgdHJhY2tpbmcgVExTDQpyZWNvcmRzLCBhbmQgc2VuZHMgYSByZXN5bmMgcmVxdWVzdCB0
byBkcml2ZXIuIFRoZSBUTFMgUHJvZ3Jlc3MgUGFyYW1zDQpDb250ZXh0IGhvbGRzIHRoZSBUQ1At
U04gb2YgdGhlIHJlY29yZCB3aGVyZSB0aGUgZGV2aWNlIGJlZ2FuIHRyYWNraW5nDQpyZWNvcmRz
IGFuZCBjb3VudGluZyB0aGVtLiBUaGUgZHJpdmVyIHdpbGwgYWNrbm93bGVkZ2UgdGhlIFRDUC1T
TiBpZiBpdA0KbWF0Y2hlcyBhIGxlZ2FsIHJlY29yZCBieSBzZXR0aW5nIHRoZSBUTFMgU3RhdGlj
IFBhcmFtcyBDb250ZXh0Lg0KDQo/IA0Kd2UgY2FuIGVsYWJvcmF0ZSBtb3JlIHdpdGggYSBzdGVw
IGJ5IHN0ZXAgcHJvY2VkdXJlLi4gaWYgeW91IHRoaW5rIGl0DQppcyByZXF1aXJlZC4NCg0KPiA+
IFRoaXMgaXMgYSByYXJlIGNvcm5lciBjYXNlIGFueXdheSwgd2hlcmUgbW9yZSB0aGFuIDFrIHRj
cA0KPiA+IGNvbm5lY3Rpb25zDQo+ID4gc2hhcmluZyB0aGUgc2FtZSBSWCByaW5nIHdpbGwgcmVx
dWVzdCByZXN5bmMgYXQgdGhlIHNhbWUgZXhhY3QNCj4gPiBtb21lbnQuIA0KPiANCj4gSURLIGFi
b3V0IHRoYXQuIENlcnRhaW4gYXBwbGljYXRpb25zIGFyZSBhcmNoaXRlY3RlZCBmb3IgbWF4DQo+
IGNhcGFjaXR5LA0KPiBub3QgZWZmaWNpZW5jeSB1bmRlciBzdGVhZHkgbG9hZC4gU28gaXQgbWF0
dGVycyBhIGxvdCBob3cgdGhlIHN5c3RlbQ0KPiBiZWhhdmVzIHVuZGVyIHN0cmVzcy4gV2hhdCBp
ZiB0aGlzIGlzIHRoZSBjaGFpbiBvZiBldmVudHM6DQo+IA0KPiBvdmVybG9hZCAtPiBkcm9wcyAt
PiBUTFMgc3RlYW1zIGdvIG91dCBvZiBzeW5jIC0+IGFsbCB0cnkgdG8gcmVzeW5jDQo+IA0KPiBX
ZSBkb24ndCB3YW50IHRvIGFkZCBleHRyYSBsb2FkIG9uIGV2ZXJ5IHJlY29yZCBpZiBIVyBvZmZs
b2FkIGlzDQo+IGVuYWJsZWQuIFRoYXQncyB3aHkgdGhlIG5leHQgcmVjb3JkIGhpbnQgYmFja3Mg
b2ZmLCBjaGVja3Mgc29ja2V0IA0KPiBzdGF0ZSBldGMuDQo+IA0KPiBCVFcgSSBhbHNvIGRvbid0
IHVuZGVyc3RhbmQgd2h5IG1seDVlX2t0bHNfcnhfcmVzeW5jKCkgaGFzIGENCj4gdGxzX29mZmxv
YWRfcnhfZm9yY2VfcmVzeW5jX3JlcXVlc3Qoc2spIGF0IHRoZSBlbmQuIElmIHRoZSB1cGRhdGUg
DQo+IGZyb20gdGhlIE5JQyBjb21lcyB3aXRoIGEgbGF0ZXIgc2VxIHRoYW4gY3VycmVudCwgcmVx
dWVzdCB0aGUgc3luYyANCj4gZm9yIF90aGF0XyBzZXEuIEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGUg
bmVlZCB0byBmb3JjZSBhIGNhbGwgYmFjayBvbg0KPiBldmVyeSByZWNvcmQgaGVyZS4gDQoNCkdv
b2QgcG9pbnQgdGhlb3JldGljYWxseSBzaG91bGQgd29yaywgdW5sZXNzIHdlIGhhdmUgc29tZSBs
aW1pdGF0aW9ucw0KdGhhdCBpIGFtIG5vdCBzZWVpbmcsIGkgd2lsbCBsZXQgVGFyaXEgY29tbWVu
dCBvbiB0aGlzLg0KDQo+IA0KPiBBbHNvIGlmIHRoZSBzeW5jIGZhaWxlZCBiZWNhdXNlIHF1ZXVl
IHdhcyBmdWxsLCBJIGRvbid0IHNlZSBob3cNCj4gZm9yY2luZyANCj4gYW5vdGhlciBzeW5jIGF0
dGVtcHQgZm9yIHRoZSBuZXh0IHJlY29yZCBpcyBnb2luZyB0byBtYXRjaD8NCg0KSW4gdGhpcyBj
YXNlIGkgZ3Vlc3Mgd2UgbmVlZCB0byBhYm9ydCBhbmQgd2FpdCBmb3IgdGhlIGh3IHRvIGlzc3Vl
IGFuZXcgcmVzeW5jIHJlcXVlc3QgLi4gDQo=
