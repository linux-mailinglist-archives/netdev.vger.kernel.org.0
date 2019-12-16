Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5C11FDA7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLPErm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:47:42 -0500
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:2785
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbfLPErm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 23:47:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dn8ZEiV5myjP+XdQlNAFTHcbj0FAAtO8DrMHtWll3YDEmKpc8Dp4EnyMvk0NE3dHNM2tfTE2WMH1z/4NiXzOXOZqT4itszcfjoe4Eb0l4a+yJglEFdbIRQRztvBSQWEA8gcnKMNx6bvLoM2Loj5qtdV4avkQXCx/gmDAVIAFRUGfutekHOWvmHyXasia9rwlW6naN6seuAchyWbt9Zx/W7pG0MfCQoM2VYuHMZaF+B/wP8ZugUmGWD8YFzGXwqZhwyBi2G5QFQQoav9xYxkNlN76B7MFZIIFkMSx2jSmqBPwn9dQEwdkZFvfGNMma9zkYEr8Eca1OSZgltTBNdbB/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H5NdO0xpFM/vhbIge7nrnsC7e1/eBRzxwO8jOzwfbY=;
 b=jNHInoDOYKXRcCtO8pWxJ2Ei+4k82lBmQr9ln1U46VOWUl8LrxqE8AQyOLHWXmex8df1ANaFVYVytB68nCEkrT3USy0lO6eGt5RWW8Y7wGn1yoFSu74PzbNnIwadq5hnVDFMvxUBG0fvE5+ANxHCbXg3Hu+oW1AilrdNlOq8yHcwEI8G8GF8R459mFWUXwY8NiamxDsaw11naLBCj+DfRMqqrVGHt6x5MPRQC4IRQNXlW5mUwnfJL0Cbmo7Qnr+M2T2kDuNMoYUYROja9gvof/vrEwrF6DdXSgwg37HorCEsH89kMoSA0/FtNSkFecpLQTDp+wbMZ4Dq1zuzA5+plg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H5NdO0xpFM/vhbIge7nrnsC7e1/eBRzxwO8jOzwfbY=;
 b=aFpe2/E5wC1F6sCuDG+x9zo+L5UHC0df/LM64aTIyg3LF2JzC4qW1rarDjoj4T509EdhjV3ZJFp0HowV5rrCfRlhw0+129yobkc+T/bXxYmqrrR7GlEs9A6gJt+iNcZj3LCA2VMKv+vgmcXztFEL3VnWZNFL3bYNobQCbqiHiz0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4289.eurprd05.prod.outlook.com (52.134.126.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 04:47:38 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 04:47:38 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Topic: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Index: AQHVsIPZtKRJJ1k2sk+Nw8POrjaYSqe2EL8AgADZlgCAAAIPAIAAGscAgAANtQCAAARFgIAFHbSA
Date:   Mon, 16 Dec 2019 04:47:38 +0000
Message-ID: <b957e025-499d-3a56-80cd-654f4e6bb13a@mellanox.com>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
 <20191212115228.2caf0c63@cakuba.netronome.com>
 <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
 <20191212133540.3992ac0c@cakuba.netronome.com>
 <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
 <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
In-Reply-To: <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.20.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a73ba6d7-26d3-4b09-aa49-08d781e3139c
x-ms-traffictypediagnostic: AM0PR05MB4289:
x-microsoft-antispam-prvs: <AM0PR05MB4289C2BCB66C3FE604F015E9D1510@AM0PR05MB4289.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(55236004)(186003)(66556008)(91956017)(110136005)(31686004)(64756008)(2906002)(54906003)(36756003)(66476007)(5660300002)(66446008)(8676002)(81166006)(6486002)(71200400001)(86362001)(81156014)(6512007)(2616005)(8936002)(4326008)(53546011)(66946007)(316002)(478600001)(6506007)(76116006)(31696002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4289;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 59UfF79gUxU91+y8rmXUgH9PTBMSMzrbits0BGuUA+aoDCVtC4Jh6K8vlQxt7EPGcguDpLSmzZgQOwWKgu+p+bxJgDyupNIOYS7HPa/V/ijT6GeA77ew105y7R66cgqxTJCyRVqytuchoa/y6Cdkoqb0CcTn+gYqvn2kkQEq9LoQbFu52GOX5NXithW+LTlhPHoIAAMkDO38Bmsg/D5ix5txBIX0l8R54qQQ0Wl1RyqyMCsTF3fUnq8JfqkNf2fWswGC9Ow/rqJlm7hh58EaRKdjnPBheNhfx9TaLmrMogqQEvfRUyCP9gYeJtVOJw08dzu/E/vcaAtI1lV2gLx3upDScpPbdp8z5QrUgZrdDKo61abRwLuW+tyrhyPNTLIenr0tZuRNmm6uORYetf6wn0e3Bk+CPCUjMl+hHtqFWEvHyzSavQ+pQgkj8ZkaZvEA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03B7E2AF93749141AEF06AAF770D0859@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73ba6d7-26d3-4b09-aa49-08d781e3139c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 04:47:38.0599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WhanfpR+1uTTjYm43rc4t2Y0hwWxNKACGogJ67zJ2hEsHad6DK29oKUgAd0WVfh9K+RFq/UVdyKJu8fam5gD/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTMvMjAxOSA0OjEwIEFNLCBTaGFubm9uIE5lbHNvbiB3cm90ZToNCj4gT24gMTIvMTIv
MTkgMjoyNCBQTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPj4gT24gMTIvMTIvMjAxOSAzOjM1IFBN
LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBUaHUsIDEyIERlYyAyMDE5IDExOjU5OjUw
IC0wODAwLCBTaGFubm9uIE5lbHNvbiB3cm90ZToNCj4+Pj4gT24gMTIvMTIvMTkgMTE6NTIgQU0s
IEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+Pj4gT24gVGh1LCAxMiBEZWMgMjAxOSAwNjo1Mzo0
MiArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPj4+Pj4+PiDCoMKgIHN0YXRpYyB2b2lkIGlv
bmljX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCj4+Pj4+Pj4gwqDCoCB7DQo+Pj4+Pj4+
IMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaW9uaWMgKmlvbmljID0gcGNpX2dldF9kcnZkYXRhKHBkZXYp
Ow0KPj4+Pj4+PiBAQCAtMjU3LDYgKzMzOCw5IEBAIHN0YXRpYyB2b2lkIGlvbmljX3JlbW92ZShz
dHJ1Y3QgcGNpX2RldiAqcGRldikNCj4+Pj4+Pj4gwqDCoMKgwqDCoMKgIGlmICghaW9uaWMpDQo+
Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4+Pj4+Pj4gwqDCoCArwqDCoMKg
IGlmIChwY2lfbnVtX3ZmKHBkZXYpKQ0KPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaW9uaWNfc3Jp
b3ZfY29uZmlndXJlKHBkZXYsIDApOw0KPj4+Pj4+PiArDQo+Pj4+Pj4gVXN1YWxseSBzcmlvdiBp
cyBsZWZ0IGVuYWJsZWQgd2hpbGUgcmVtb3ZpbmcgUEYuDQo+Pj4+Pj4gSXQgaXMgbm90IHRoZSBy
b2xlIG9mIHRoZSBwY2kgUEYgcmVtb3ZhbCB0byBkaXNhYmxlIGl0IHNyaW92Lg0KPj4+Pj4gSSBk
b24ndCB0aGluayB0aGF0J3MgdHJ1ZS4gSSBjb25zaWRlciBpZ2IgYW5kIGl4Z2JlIHRvIHNldCB0
aGUNCj4+Pj4+IHN0YW5kYXJkDQo+Pj4+PiBmb3IgbGVnYWN5IFNSLUlPViBoYW5kbGluZyBzaW5j
ZSB0aGV5IHdlcmUgb25lIG9mIHRoZSBmaXJzdCAodGhlDQo+Pj4+PiBmaXJzdD8pDQo+Pj4+PiBh
bmQgQWxleCBEdXljayB3cm90ZSB0aGVtLg0KPj4+Pj4NCj4+Pj4+IG1seDQsIGJueHQgYW5kIG5m
cCBhbGwgZGlzYWJsZSBTUi1JT1Ygb24gcmVtb3ZlLg0KPj4+PiBUaGlzIHdhcyBteSB1bmRlcnN0
YW5kaW5nIGFzIHdlbGwsIGJ1dCBub3cgSSBjYW4gc2VlIHRoYXQgaXhnYmUgYW5kDQo+Pj4+IGk0
MGUNCj4+Pj4gYXJlIGJvdGggY2hlY2tpbmcgZm9yIGV4aXN0aW5nIFZGcyBpbiBwcm9iZSBhbmQg
c2V0dGluZyB1cCB0byB1c2UgdGhlbSwNCj4+Pj4gYXMgd2VsbCBhcyB0aGUgbmV3ZXIgaWNlIGRy
aXZlci7CoCBJIGZvdW5kIHRoaXMgdG9kYXkgYnkgbG9va2luZyBmb3INCj4+Pj4gd2hlcmUgdGhl
eSB1c2UgcGNpX251bV92ZigpLg0KPj4+IFJpZ2h0LCBpZiB0aGUgVkZzIHZlcnkgYWxyZWFkeSBl
bmFibGVkIG9uIHByb2JlIHRoZXkgYXJlIHNldCB1cC4NCj4+Pg0KPj4+IEl0J3MgYSBiaXQgb2Yg
YSBhc3ltbWV0cmljIGRlc2lnbiwgaW4gY2FzZSBzb21lIG90aGVyIGRyaXZlciBsZWZ0DQo+Pj4g
U1ItSU9WIG9uLCBJIGd1ZXNzLg0KPj4+DQo+PiBJIHJlbWVtYmVyIG9uIG9uZSBlbWFpbCB0aHJl
YWQgb24gbmV0ZGV2IGxpc3QgZnJvbSBzb21lb25lIHRoYXQgaW4gb25lDQo+PiB1c2UgY2FzZSwg
dGhleSB1cGdyYWRlIHRoZSBQRiBkcml2ZXIgd2hpbGUgVkZzIGFyZSBzdGlsbCBib3VuZCBhbmQN
Cj4+IFNSLUlPViBrZXB0IGVuYWJsZWQuDQo+PiBJIGFtIG5vdCBzdXJlIGhvdyBtdWNoIGl0IGlz
IHVzZWQgaW4gcHJhY3RpY2Uvb3IgcHJhY3RpY2FsLg0KPj4gU3VjaCB1c2UgY2FzZSBtYXkgYmUg
dGhlIHJlYXNvbiB0byBrZWVwIFNSLUlPViBlbmFibGVkLg0KPiANCj4gVGhpcyBicmluZ3MgdXAg
YSBwb3RlbnRpYWwgY29ybmVyIGNhc2Ugd2hlcmUgaXQgd291bGQgYmUgYmV0dGVyIGZvciB0aGUN
Cj4gZHJpdmVyIHRvIHVzZSBpdHMgb3duIG51bV92ZnMgdmFsdWUgcmF0aGVyIHRoYW4gcmVseWlu
ZyBvbiB0aGUNCj4gcGNpX251bV92ZigpIHdoZW4gYW5zd2VyaW5nIHRoZSBuZG9fZ2V0X3ZmXyoo
KSBjYWxsYmFja3MsIGFuZCBhdCBsZWFzdA0KPiB0aGUgaWdiIG1heSBiZSBzdXNjZXB0aWJsZS7C
oCANClBsZWFzZSBkbyBub3QgY2FjaGUgbnVtX3ZmcyBpbiBkcml2ZXIuIFVzZSB0aGUgcGNpIGNv
cmUncyBwY2lfbnVtX3ZmKCkNCmluIHRoZSBuZXcgY29kZSB0aGF0IHlvdSBhcmUgYWRkaW5nLg0K
TW9yZSBiZWxvdy4NCj4gSWYgdGhlIGRyaXZlciBoYXNuJ3Qgc2V0IHVwIGl0cyB2ZltdIGRhdGEN
Cj4gYXJyYXlzIGJlY2F1c2UgdGhlcmUgd2FzIGFuIGVycm9yIGluIHNldHRpbmcgdGhlbSB1cCBp
biB0aGUgcHJvYmUoKSwgYW5kDQo+IGxhdGVyIHNvbWVvbmUgdHJpZXMgdG8gZ2V0IFZGIHN0YXRp
c3RpY3MsIHRoZSBuZG9fZ2V0X3ZmX3N0YXRzIGNhbGxiYWNrDQo+IGNvdWxkIGVuZCB1cCBkZXJl
ZmVyZW5jaW5nIGJhZCBwb2ludGVycyBiZWNhdXNlIHZmIGlzIGxlc3MgdGhhbg0KPiBwY2lfbnVt
X3ZmKCkgYnV0IG1vcmUgdGhhbiB0aGUgbnVtYmVyIG9mIHZmW10gc3RydWN0cyBzZXQgdXAgYnkg
dGhlIGRyaXZlci4NCj4gDQo+IEkgc3VwcG9zZSB0aGUgYXJndW1lbnQgY291bGQgYmUgbWFkZSB0
aGF0IFBGJ3MgcHJvYmUgc2hvdWxkIGlmIHRoZSBWRg0KPiBjb25maWcgZmFpbHMsIGJ1dCBpdCBt
aWdodCBiZSBuaWNlIHRvIGhhdmUgdGhlIFBGIGRyaXZlciBydW5uaW5nIHRvIGhlbHANCj4gZml4
IHVwIHdoYXRldmVyIHdoZW4gc2lkZXdheXMgaW4gdGhlIFZGIGNvbmZpZ3VyYXRpb24uDQo+IA0K
PiBzbG4NCj4gDQpJIG5vdCBoYXZlIHN0cm9uZyBvcGluaW9uIG9uIGxldHRpbmcgc3Jpb3YgZW5h
YmxlZC9kaXNhYmxlZCBvbiBQRiBkZXZpY2UNCnJlbW92YWwuDQpCdXQgaXQgc2hvdWxkIGJlIHN5
bW1ldHJpYyBvbiBwcm9iZSgpIGFuZCByZW1vdmUoKSBmb3IgUEYuDQpJZiB5b3Ugd2FudCB0byBr
ZWVwIGl0IGVuYWJsZWQgb24gUEYgcmVtb3ZhbCwgeW91IG5lZWQgdG8gY2hlY2sgb24gcHJvYmUN
CmFuZCBhbGxvY2F0ZSBWRiBtZXRhZGF0YSB5b3UgaGF2ZSBieSB1c2luZyBoZWxwZXIgZnVuY3Rp
b24gaW4NCnNyaW92X2NvbmZpZ3VyZSgpIGFuZCBpbiBwcm9iZSgpLg0KVGhpcyBpcyBmb2xsb3dl
ZCBieSBtbHg1IGRyaXZlci4NCg0K
