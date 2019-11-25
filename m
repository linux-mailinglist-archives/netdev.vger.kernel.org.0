Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272E810967D
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKYXMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:12:42 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:15078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727379AbfKYXMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 18:12:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZcZurUnupDh44w7IY6F6ADYA0S4ExGOXJsodn5UmLqvaL2g5coCgcq28Dg2lQK+F3c7L/0sfaxTW3bxBawzVR/crHHmHlCioEoVURFjeW5LGbHvUYbWQHcsWgHx/qJV0Bt0EZvLb6aCUICgYEcFF6Ox2SD6PoD70z290wg14fUHcJn3pfZnm0Vq0jhbKbglkK/jFns6D6d9XFhJw5bC01vVkefXw35pYeYOq2Cn9FOwQ73Vg/PiVKw+xwSGDWBCIrPaEnSKc/QIJbP6IuIvBfp7lkGWpaUqAm3Psk7IhYAiVhdsWrdv8YiqHvMoYjQUwgrQ7MxlIOuyyoi/HGH0mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQw4QYDTzFGj4mrWT/iif/8pJbbMbLfrC8vISv8u6so=;
 b=G/m5w5vAlR5+oerngcF/Mnd+pqUaKAJURYXUy2769eV33HT6bnQN1xLqtrdUFww5lyujXofx/fKUf/BsDoWISw2PhQvSMjUOXgumSDchlUcOo+PWC6Fi1eaQtizusJ0ENC1jsVN/QR2OIqK4WJ2qtsU4voG34Nk165e//MkiODTisj3CiATGKc1R+E55DAyfv1KJRl9I6IBD/JF9Vap9DmENGoWKvmHVIs6e9DSQjI1Iyuo3/CY122VShbYW2MHqnhawtBaD8nQnz4v1QBbZIhgjafv0xl9w3wy7CTMi4j9Mcp/dqXnyNbj85F626NXU/D/Jj2r98RJFmLGhRuCHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQw4QYDTzFGj4mrWT/iif/8pJbbMbLfrC8vISv8u6so=;
 b=eh85s84P+Jys9bo0cURzyWXdmsEUEeHx0JEqz0NRxT6a+8JXAewAYE9ROAp6enC2UVgipuZqVaAPPjRAFRVpkmAU5YevjVdPyf2Hi7K1KFTc5QYSPu2PFhjpApS9VHz4n7+p70gi5k4k6fmSNm09GooI2LQB2SUJzvcPl7aeNjc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3439.eurprd05.prod.outlook.com (10.170.239.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.23; Mon, 25 Nov 2019 23:12:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 23:12:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
Thread-Topic: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
Thread-Index: AQHVoYYFLiIobYES3Umik1b3xPm7DaeZgRWAgAIm05yAAOCwgA==
Date:   Mon, 25 Nov 2019 23:12:37 +0000
Message-ID: <7f40c553f1fd16fc6a1ee538af77fbfef19f598c.camel@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
         <20191122224126.24847-2-saeedm@mellanox.com>
         <20191123165655.5a9b8877@cakuba.netronome.com>
         (sfid-20191124_015708_074656_C114DF73)
 <613b2aa1f9612898df7bb2e54bbb49b4115d29ae.camel@sipsolutions.net>
In-Reply-To: <613b2aa1f9612898df7bb2e54bbb49b4115d29ae.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00f0ef63-beeb-4ce6-a0fa-08d771fcf638
x-ms-traffictypediagnostic: VI1PR05MB3439:|VI1PR05MB3439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB343924F8C8E8C5371AA5C396BE4A0@VI1PR05MB3439.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(4326008)(14454004)(26005)(6116002)(186003)(25786009)(4001150100001)(446003)(3846002)(7736002)(6506007)(2616005)(66946007)(2906002)(478600001)(305945005)(66556008)(11346002)(66476007)(76176011)(76116006)(91956017)(5660300002)(66446008)(64756008)(6246003)(256004)(81166006)(81156014)(8676002)(54906003)(2501003)(6436002)(6486002)(86362001)(36756003)(99286004)(110136005)(66066001)(102836004)(6512007)(118296001)(58126008)(8936002)(316002)(71190400001)(71200400001)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3439;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pKh4Tj5uJa6xFARuGeiwatxyQBmxLGy0037Fj/cq1dpX7ae8U8IflNk8Iht1w4xf5ZUl/aqt336sqQznEGNDyQa/6mRH4rxYm0FsVm9JzPngFexRNGzwl5LFdnHDqq6eP4gZr3KxRcs1qcJHW4LEdnSXyYvguX/hPHYKt7Of43QSR8Ns+JTA4nYHsbQkkqJREvdgguOvPpSm47Aq7hfsK72GAdxIPxDZ0+/ZMt5q211ECjQeVYYtdKJ3d/GH3aRu1aRi4CV28QKvopM8Ammm7JWWei+MncVgEamG4Me/yU9VAVM2cOq8eQ73lXvg8kSxexT5/+YgXkEVGGqFYUDeFsA0UvbOj8naVBMSTH63rMcEo01oqFBbOnXK1yfXTDWLn0MFXMbogPWQmzjdscpY5t0OOxmxSv50oT98tvWqq5+CeXKekRWf1vP9AvecPSjw
Content-Type: text/plain; charset="utf-8"
Content-ID: <7334C5E96AEFD349BD763B2B37FAC271@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f0ef63-beeb-4ce6-a0fa-08d771fcf638
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 23:12:37.1548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PXMbuJloie8BQufVEVhY0DEAkUglmacHPlYl76TGRlTYpgmaCFwZ5LMD5xNcNZr55A6dztUjxPbFGgXAj+IMOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3439
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTExLTI1IGF0IDEwOjQ4ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBIaSBKYWt1YiwNCj4gDQo+IE9uIFNhdCwgMjAxOS0xMS0yMyBhdCAxNjo1NiAtMDgwMCwgSmFr
dWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gPiAtLyogQWx3YXlzIHVzZSB0aGlzIG1hY3JvLCB0aGlz
IGFsbG93cyBsYXRlciBwdXR0aW5nIHRoZQ0KPiA+ID4gLSAqIG1lc3NhZ2UgaW50byBhIHNlcGFy
YXRlIHNlY3Rpb24gb3Igc3VjaCBmb3IgdGhpbmdzDQo+ID4gPiAtICogbGlrZSB0cmFuc2xhdGlv
biBvciBsaXN0aW5nIGFsbCBwb3NzaWJsZSBtZXNzYWdlcy4NCj4gDQo+IFJlZ2FyZGluZyB5b3Vy
IG90aGVyIGVtYWlsIGFsc28gLSB0aGlzIGhlcmUgd2FzIG9uZSBzdGF0ZWQgcHVycG9zZSAtDQo+
IHdoYXQgSSBoYWQgYWxzbyAobWF5YmUgZXZlbiBtb3JlKSBpbiBtaW5kIGJhY2sgdGhlbiB3YXMg
dGhhdCB3ZSdkIGJlDQo+IGFibGUgdG8gZWxpZGUgdGhlIHN0cmluZ3MgZW50aXJlbHkgZm9yIHJl
YWxseSBzbWFsbCBlbWJlZGRlZCBidWlsZHMuDQo+IElmDQo+IGl0J3Mgbm90IHVzZWQgaW50ZXJh
Y3RpdmVseSwgdGhlcmUgaXNuJ3QgdGhhdCBtdWNoIHZhbHVlIGluIHRoZQ0KPiBzdHJpbmdzDQo+
IGFmdGVyIGFsbC4NCj4gDQo+ID4gPiAtICogQ3VycmVudGx5IHN0cmluZyBmb3JtYXR0aW5nIGlz
IG5vdCBzdXBwb3J0ZWQgKGR1ZQ0KPiA+ID4gLSAqIHRvIHRoZSBsYWNrIG9mIGFuIG91dHB1dCBi
dWZmZXIuKQ0KPiA+ID4gLSAqLw0KPiA+ID4gLSNkZWZpbmUgTkxfU0VUX0VSUl9NU0coZXh0YWNr
LCBtc2cpIGRvIHsJCVwNCj4gPiA+IC0Jc3RhdGljIGNvbnN0IGNoYXIgX19tc2dbXSA9IG1zZzsJ
CVwNCj4gPiA+ICsjZGVmaW5lIE5MX01TR19GTVQoZXh0YWNrLCBmbXQsIC4uLikgXA0KPiA+ID4g
KwlXQVJOX09OKHNucHJpbnRmKGV4dGFjay0+X21zZywgTkxfRVhUQUNLX01BWF9NU0dfU1osIGZt
dCwgIyMNCj4gPiA+IF9fVkFfQVJHU19fKSBcDQo+ID4gPiArCQk+PSBOTF9FWFRBQ0tfTUFYX01T
R19TWikNCj4gPiANCj4gPiBJJ2QgcGVyc29uYWxseSBhcHByZWNpYXRlIGEgd29yZCBvZiBhbmFs
eXNpcyBhbmQgcmVhc3N1cmFuY2UgaW4gdGhlDQo+ID4gY29tbWl0IG1lc3NhZ2UgdGhhdCB0aGlz
IHNucHJpbnRmICsgV0FSTl9PTiBpbmxpbmVkIGluIGV2ZXJ5DQo+ID4gbG9jYXRpb24NCj4gPiB3
aGVyZSBleHRhY2sgaXMgdXNlZCB3b24ndCBibG9hdCB0aGUga2VybmVsIDpTDQo+IA0KPiBUaGF0
IGRvZXMgc2VlbSBxdWl0ZSBleGNlc3NpdmUsIGluZGVlZC4NCj4gDQo+IEkgdGhpbmsgX2lmXyB3
ZSB3YW50IHRoaXMgYXQgYWxsIHRoZW4gSSdkIHNheSB0aGF0IHdlIHNob3VsZCBtb3ZlDQo+IHRo
aXMNCj4gb3V0LW9mLWxpbmUsIHRvIGhhdmUgYSBoZWxwZXIgZnVuY3Rpb24gdGhhdCB3aWxsIGth
c3ByaW50ZigpIGlmDQo+IG5lY2Vzc2FyeSwgYW5kIHVzZSBhIGJpdCBzb21ld2hlcmUgdG8gaW5k
aWNhdGUgImhhcyBiZWVuIGFsbG9jYXRlZCINCj4gc28NCj4gaXQgY2FuIGJlIGZyZWVkIGxhdGVy
Pw0KPiANCj4gSG93ZXZlciwgdGhpcyB3aWxsIG5lZWQgc29tZSBraW5kIG9mICJyZWxlYXNlIGV4
dGFjayIgQVBJIGZvciB0aG9zZQ0KPiBwbGFjZXMgdGhhdCBkZWNsYXJlIHRoZWlyIG93biBzdHJ1
Y3Qgb24gdGhlIHN0YWNrLCBhbmQgd291bGQgbmVlZCB0bw0KPiBiZQ0KPiByZWVudHJhbnQgKGlu
IHRoZSBzZW5zZSB0aGF0IG9sZCBlcnJvciBtZXNzYWdlcyBtYXkgYmUgb3ZlcndyaXR0ZW4sDQo+
IGFuZA0KPiBtdXN0IGJlIGZyZWVkIGF0IHRoYXQgcG9pbnQpLi4uDQo+IA0KPiBNYXliZSBhbiBh
bHRlcm5hdGl2ZSB3b3VsZCBiZSB0byBoYXZlIGEgImNhbiBzcHJpbnRmIiBmbGFnLCBhbmQgdGhl
bg0KPiBwcm92aWRlIGEgYnVmZmVyIGluIGFub3RoZXIgcG9pbnRlcj8gVGhlIGNhbGxlciBjYW4g
dGhlbiBkZWNpZGUNCj4gd2hldGhlcg0KPiB0aGlzIHNob3VsZCBiZSBwZXJtaXR0ZWQsIGUuZy4g
bmV0bGlua19yY3Zfc2tiKCkgY291bGQgcHJvdmlkZSBpdCwNCj4gYnV0DQo+IG90aGVyIHBsYWNl
cyBtYXliZSBkb24ndCBuZWVkIHRvPw0KPiANCg0KSSB0aG91Z2h0IGFib3V0IGFsbCBvZiB0aGVz
ZSBhbHRlcm5hdGl2ZXMgYmVmb3JlIGkgd3JvdGUgdGhpcyBwYXRjaCwNCnRoZSBpZGVhIGhlcmUg
aXMgdG8ga2VlcCBpdCBzaW1wbGUgYW5kIG5vdCBpbnRyb2R1Y2UgYW55IHN0YXRlIGJpdHMgb3IN
Cm11bHRpcGxlIGJ1ZmZlcnMgdG8gY2hvb3NlIGZyb20sIGFsc28gaXQgaXMgaGFyZCB0byBndWFy
YW50ZWUgdGhhdCB3ZQ0KYXJlIGdvaW5nIHRvIGhpdCB0aGUgbGluZSBvZiBjb2RlIHRoYXQgaXMg
Z29pbmcgdG8gZnJlZSB0aGUgYWxsb2NhdGVkDQpleHRhY2sgbWVzc2FnZS4NCg0Kb25seSB0aGUg
ZHJpdmVyIGtub3dzIGlmIGl0IHdhbnQgYSBmb3JtYXR0YWJsZSBtZXNzYWdlIGFuZCBpdCBzaG91
bGQNCmFsbG9jYXRlIGl0LCBhbmQgb25seSB0aGUgbmV0bGluayBjb3JlIHNob3VsZCBmcmVlIGl0
LCBJIHBlcnNvbmFsbHkNCmRvbid0IGxpa2Ugc3VjaCBhc3ltbWV0cmllcyBpbiB0aGUga2VybmVs
IGNvZGUsIHdpdGhvdXQgYSBwcm9wZXINCmNvbnRyYWN0IG9yIGluZnJhc3RydWN0dXJlIHRoYXQg
d2lsbCBndWFyYW50ZWUgY29ycmVjdG5lc3MgYW5kIG5vDQptZW1sZWFrcy4NCg0KPiANCj4gSGVy
ZSBpbiB0aGUgcGF0Y2hzZXQgdGhvdWdoLCBJIGJhc2ljYWxseSBmb3VuZCB0aHJlZSBjYXNlcyB1
c2luZyB0aGlzDQo+IGNhcGFiaWxpdHk6DQo+IA0KPiArCU5MX1NFVF9FUlJfTVNHX01PRChleHRh
Y2ssIE1MWEZXX0VSUl9QUkZYICIlcyIsDQo+ICsJCQkgICBtbHhmd19mc21fc3RhdGVfZXJyX3N0
cltmc21fc3RhdGVfZXJyXSk7DQo+IA0KPiBUaGlzIG9uZSBzZWVtcyBzb21ld2hhdCB1bm5lY2Vz
c2FyeSAtIGl0IGp1c3QgdGFrZXMgYSBmaXhlZCBzdHJpbmcNCj4gYW5kDQo+IGFkZHMgYSBwcmVm
aXgsIHRoYXQgbWF5IGJlIGVhc2llciB0aGlzIHdheSBidXQgaXQgd291bGRuJ3QgYmUgKnRoYXQq
DQo+IGhhcmQgdG8gImV4cGxvZGUiIHRoYXQgaW50byBhIGJ1bmNoIG9mIE5MX1NFVF9FUlJfTVNH
X01PRCgpDQo+IHN0YXRlbWVudHMgSQ0KPiBndWVzcy4NCj4gDQo+ICsJCU5MX1NFVF9FUlJfTVNH
X01PRChleHRhY2ssICJGU00gc3RhdGUgcXVlcnkgZmFpbGVkLCBlcnINCj4gKCVkKSIsDQo+ICsJ
CQkJICAgZXJyKTsNCj4gDQo+IFRoaXMgKGFuZCBvdGhlciBzaW1pbGFyIGluc3RhbmNlcykgaXMg
cHJldHR5IHVzZWxlc3MsIHRoZSBlcnJvcg0KPiBudW1iZXINCj4gaXMgYWxtb3N0IGNlcnRhaW5s
eSByZXR1cm5lZCB0byB1c2Vyc3BhY2UgYW55d2F5Pw0KPiANCj4gKwkJTkxfU0VUX0VSUl9NU0df
TU9EKGV4dGFjaywNCj4gKwkJCQkgICAiRlNNIGNvbXBvbmVudCBxdWVyeSBmYWlsZWQsDQo+IGNv
bXBfbmFtZSglcykgZXJyICglZCkiLA0KPiArCQkJCSAgIGNvbXBfbmFtZSwgZXJyKTsNCj4gDQo+
IFRoaXMgKGFuZCBzaW1pbGFyKSBvbmUgc2VlbXMgbGlrZSB0aGUgb25seSBvbmUgdGhhdCdzIHJl
YXNvbmFibGUuDQo+IE5vdGUNCj4gdGhhdCAiY29tcF9uYW1lIiBpcyBhY3R1YWxseSBqdXN0IGEg
bnVtYmVyIHRob3VnaC4NCj4gDQoNClllcywgbW9zdCBvZiB0aGUgdXNlIGNhc2VzIGRvbid0IHJl
YWxseSByZXF1aXJlIGEgZm9ybWF0dGFibGUgbWVzc2FnZS4NCkkgb25seSBkaWQgaXQgYWZ0ZXIg
c29tZSBpbnRlcm5hbCBjb2RlIHJldmlld3MgdGhhdCBwb2ludGVkIG91dCB0aGF0DQpkb2luZyB0
aGlzIHdpbGwgbWFrZSBteSBjb2RlIG1vcmUgZWFzeSBvbiB0aGUgZXllLCBzaW5jZSBpIGNvdWxk
IHdyYXANCmV2ZXJ5dGhpbmcgaW4gb25lIGZ1bmN0aW9uIHRoYXQgd291bGQgZHVtcCBkbWVzZyBh
bmQgZXh0YWNrIG1lc3NhZ2VzIGluDQpvbmUgc2hvdC4NCg0KSSB3aWxsIGRyb3AgdGhpcyBwYXRj
aCBmb3Igbm93Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
