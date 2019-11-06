Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133FBF13B8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfKFKSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:18:01 -0500
Received: from mail-eopbgr140073.outbound.protection.outlook.com ([40.107.14.73]:17735
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbfKFKSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 05:18:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9zgURoacrsJAqETsHCquii29l6p1Z7RpBqk4tKwOyF4/bCuSJz1MZDgdqZKpC1d+SgaM7VeMmZLvbzIZl19dBTcs55315GdixTt1VFiJBOns96QK/ZcXTPqQ4hRIE3/sVoK0O5HIOMKfoaoxelL1RA1kEYdQPj1xzQNsRXn+cbwZndhmPPk7KgiQIr8Q5rf3wswTJbdngcQGqUvwtdZOk1FPsln0z/Hf67lNC/bEaIEEQOfhCaxnvJRivwcmP4NO7DUI3LdhkVSm1rTH4cXIVJo/06EpGmWt+UPJaXi3tLJLCBBEb8A30VpV5BMqUSgXyjqGst4YgNz4IP+PhO7yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6APRCsm0oLHARIV0mhw5HTV7bCYFxz2Mlvx4uDkfVD8=;
 b=NdBav9d+C9ddw0rc+Z63Zh6s0wan89Oqk87kAThWBQUcuzHIYrhBftnV7o23mSi2jWTNKdd45VdXJaSqc9uul/4ZK3GdzW6DHgpX4ALsyGAAF/ywMbCVsORAGNiNqloZdHq/jmLVUpKC9Lcrmw9xGXYMTJ3tUL804lalkKtmiswOauMjHUI7G1384Ig39L4Ly2Y+f3oiQLnLmLFuDm60u22ORn2lzn3WYiuU6CFQJkjYIqqgNiG49BKPQTQ8y3E2+liP7dexI4T1xzfT2b2AIO5H/Dl6XoVnAw/o/wDc+U5u6JMleDY6uViwYphpwLlJ/xxhRO2Ee+IifZ45tr4zfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6APRCsm0oLHARIV0mhw5HTV7bCYFxz2Mlvx4uDkfVD8=;
 b=c96DzLGcgznNs+OFr4T9QgQP7WJpam8OrmjrOlY85/42FbILC3u97FsKRYyRVrfb6ZPQEI4aiMnJysuGl/2moiLna4Q+BkfSpgdCFGACmmoLOULgQhXHt9g6/GKztqVfoBeYanJEHPhc18nEySzwS40KeTM6rBDnmfZklkTCA34=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 6 Nov 2019 10:17:56 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 10:17:56 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Topic: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Index: AQHVlHh1RxWa9XB3VkWu+bqZPxdiDad9ymZQgAAFLwCAAB3EoA==
Date:   Wed, 6 Nov 2019 10:17:56 +0000
Message-ID: <VI1PR0402MB36000BE1C169ECA035BE3610FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191106080128.23284-1-hslester96@gmail.com>
 <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ1wZU92K=XTRCNU5HhOzZ761+S83zyjqOdZKpyQVuXrCw@mail.gmail.com>
In-Reply-To: <CANhBUQ1wZU92K=XTRCNU5HhOzZ761+S83zyjqOdZKpyQVuXrCw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ecddc062-baf6-4039-39d3-08d762a297c9
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB2800B55F33CD1F798789C7BFFF790@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(6246003)(486006)(476003)(11346002)(33656002)(256004)(186003)(6436002)(6916009)(446003)(14444005)(478600001)(102836004)(9686003)(7736002)(74316002)(53546011)(2906002)(76176011)(6506007)(26005)(7696005)(55016002)(25786009)(8676002)(52536014)(4326008)(1411001)(66066001)(99286004)(5660300002)(86362001)(305945005)(8936002)(14454004)(229853002)(71190400001)(66476007)(66556008)(76116006)(66446008)(64756008)(316002)(54906003)(66946007)(3846002)(6116002)(81166006)(71200400001)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2800;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNBxlm49DEbKUeij8l+jzGsxKhONhhCQAy6M0sSurFShqXL+wa+pg6H/waJ2aNegKxindFBcZdfZdmS9H7Hm5FUZy+dSDruQ4bGoQ0A90DJVLDudliHon8p+FtK/tCdUDhSKAnoiMjilVV2q4Byd+1AgMi5Sp+zvEufM8Oy78xott5PxNoNdvDXiem5mROpGtYja6lFs6Ku/kna+JqgGumDeCdyuLEVXP4BLH53OA4H0HdEg0bUf1qoTraYSX3EHdx5UeWKr1U6jrCdOWsRTS4XMkrEN80paC3uMk0DRYbjgh1ZCHypKiq0SDRb7D3zOIQsPek+sv1F/u2aUXjaOJ+pfTFWZeQ+952C0Czc/QTxG8eGuUEEM8KFPQ96qb97Ilrg/AsWQdSBnW2RGNM5bMeZ0q+tSILnpiDX4gV1P3y81wN/6aeE82MtFb+ANlHSl
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecddc062-baf6-4039-39d3-08d762a297c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 10:17:56.6695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clFXc4IDsLUbg9iA0L3nU82TFzn9OOIIj5jeNJN95q6jppUGDRFhM5IPAfysTWch5Ud7hQPU91mrtY1zyRYKgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDE5IDQ6MjkgUE0NCj4gT24gV2VkLCBOb3YgNiwgMjAxOSBhdCA0OjEz
IFBNIEFuZHkgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9t
OiBDaHVob25nIFl1YW4gPGhzbGVzdGVyOTZAZ21haWwuY29tPiBTZW50OiBXZWRuZXNkYXksIE5v
dmVtYmVyDQo+IDYsDQo+ID4gMjAxOSA0OjAxIFBNDQo+ID4gPiBJZiBDT05GSUdfUE0gaXMgZW5h
YmxlZCwgcnVudGltZSBwbSB3aWxsIHdvcmsgYW5kIGNhbGwNCj4gPiA+IHJ1bnRpbWVfc3VzcGVu
ZCBhdXRvbWF0aWNhbGx5IHRvIGRpc2FibGUgY2xrcy4NCj4gPiA+IFRoZXJlZm9yZSwgcmVtb3Zl
IG9ubHkgbmVlZHMgdG8gZGlzYWJsZSBjbGtzIHdoZW4gQ09ORklHX1BNIGlzDQo+IGRpc2FibGVk
Lg0KPiA+ID4gQWRkIHRoaXMgY2hlY2sgdG8gYXZvaWQgY2xvY2sgY291bnQgbWlzLW1hdGNoIGNh
dXNlZCBieSBkb3VibGUtZGlzYWJsZS4NCj4gPiA+DQo+ID4gPiBUaGlzIHBhdGNoIGRlcGVuZHMg
b24gcGF0Y2gNCj4gPiA+ICgibmV0OiBmZWM6IGFkZCBtaXNzZWQgY2xrX2Rpc2FibGVfdW5wcmVw
YXJlIGluIHJlbW92ZSIpLg0KPiA+ID4NCj4gPiBQbGVhc2UgYWRkIEZpeGVzIHRhZyBoZXJlLg0K
PiA+DQo+IA0KPiBUaGUgcHJldmlvdXMgcGF0Y2ggaGFzIG5vdCBiZWVuIG1lcmdlZCB0byBsaW51
eCwgc28gSSBkbyBub3Qga25vdyB3aGljaA0KPiBjb21taXQgSUQgc2hvdWxkIGJlIHVzZWQuDQoN
Ckl0IHNob3VsZCBiZSBtZXJnZWQgaW50byBuZXQtbmV4dCB0cmVlLg0KDQpBbmR5DQo+IA0KPiA+
IEFuZHkNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IENodWhvbmcgWXVhbiA8aHNsZXN0ZXI5NkBnbWFp
bC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZmVjX21haW4uYyB8IDIgKysNCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
DQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mZWNfbWFpbi5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jDQo+ID4gPiBpbmRleCBhOWMzODZiNjM1ODEuLjY5NjU1MGY0OTcyZiAxMDA2NDQNCj4g
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4g
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ID4g
QEAgLTM2NDUsOCArMzY0NSwxMCBAQCBmZWNfZHJ2X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlDQo+ICpwZGV2KQ0KPiA+ID4gICAgICAgICAgICAgICAgIHJlZ3VsYXRvcl9kaXNhYmxlKGZl
cC0+cmVnX3BoeSk7DQo+ID4gPiAgICAgICAgIHBtX3J1bnRpbWVfcHV0KCZwZGV2LT5kZXYpOw0K
PiA+ID4gICAgICAgICBwbV9ydW50aW1lX2Rpc2FibGUoJnBkZXYtPmRldik7DQo+ID4gPiArI2lm
bmRlZiBDT05GSUdfUE0NCj4gPiA+ICAgICAgICAgY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGZlcC0+
Y2xrX2FoYik7DQo+ID4gPiAgICAgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZShmZXAtPmNsa19p
cGcpOw0KPiA+ID4gKyNlbmRpZg0KPiA+ID4gICAgICAgICBpZiAob2ZfcGh5X2lzX2ZpeGVkX2xp
bmsobnApKQ0KPiA+ID4gICAgICAgICAgICAgICAgIG9mX3BoeV9kZXJlZ2lzdGVyX2ZpeGVkX2xp
bmsobnApOw0KPiA+ID4gICAgICAgICBvZl9ub2RlX3B1dChmZXAtPnBoeV9ub2RlKTsNCj4gPiA+
IC0tDQo+ID4gPiAyLjIzLjANCj4gPg0K
