Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6763811BF1A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLKVY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:24:28 -0500
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:25475
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbfLKVY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 16:24:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5ERManz8g/42TfkhntsP/a/iBwt4tBauv3cjtvEQA8ilhlXvm5hZSvtQ3zOY2oaCsJ3fVrlkrLpPXBzw7/3NB22abh7jwphc6LSF+VgOxxML3qOM9vuDhwtZTVa344T2eIIpo1yhBZJENMBGgCnmYytTRyvX8gFQ1jSjZ40bvhVl9/5SPhC4DCqDoPBAAALlVXSVubYQTPEXj0b0oSxXbAOTtn4qChdSTdR0kU0e22jhp4KLeNd99bbXcsFjsKNNgRxluG52i7BUJjTLDVdpXLNwpX24gC8WLtF7OZNxXsW1ppKHBBX4xJsemRhz1t5BDhp9X5cDMEK5Yv+i/jMLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOhtLHHwMr/H9UKN2oC5D0yuoAv1OI2mdQE+IbBuO+I=;
 b=n6eRnvOiehfHzXUALPDy0dzNsrRzKEKkxelDbL3QXZ+cYt6e/vQ1+4qMruUzth3t4621uxcy8Vf2Yh8n5xyj3X0fKlfYi/cQlV4YL9/FgYOXEpLpTqifmpmCWuGWF42g4dpWzdLBTjBEo+VMO1AYmbfjfhpJWRZJCZ0G5t7wOBeSYSmkcnMvE4H2V36CHdNGnSebJP/IZsq31prB/EYybEflUZECoJyQMayjfzy9qJuSloB7D7mJsMXiqDTTlH+NFabPoY9jIUG097wauPxWlFIb6gmsduvAYggLzGeTwdjsEXzcTjSY01RcNVKnGjRMvan1KN13R99uc22MlvdOsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOhtLHHwMr/H9UKN2oC5D0yuoAv1OI2mdQE+IbBuO+I=;
 b=RDbMiyBc90qD7TKUg8E58STkh+bQfzaSI9zpmxXTjldpGHrqWNswoH0/wgWv1WRk6OhNBLRtJf/seCS7CPnFguZcyEqTRWbsmnUVJ3DAWpbkb5V3cgkALDrQheU9v4SCecrGd6gkA83zB1Mym2DTS4awyXpPVxnyY3dwSNUAidk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6333.eurprd05.prod.outlook.com (20.179.26.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 21:24:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2516.019; Wed, 11 Dec 2019
 21:24:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAdD7ICAACs2gA==
Date:   Wed, 11 Dec 2019 21:24:23 +0000
Message-ID: <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
         <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
         <20191211194933.15b53c11@carbon>
In-Reply-To: <20191211194933.15b53c11@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fbb11d27-3214-43e7-877a-08d77e807e41
x-ms-traffictypediagnostic: VI1PR05MB6333:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB6333D49A53688A55EE283D5BBE5A0@VI1PR05MB6333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(189003)(199004)(51444003)(26005)(6512007)(81166006)(81156014)(6506007)(5660300002)(6486002)(86362001)(8936002)(2616005)(478600001)(186003)(4001150100001)(76116006)(91956017)(66946007)(2906002)(8676002)(64756008)(66476007)(54906003)(66446008)(316002)(6916009)(71200400001)(4326008)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6333;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NsVeUaKgnmZ6+i1mQakNvaXmTv3DdrmBu7PS4icIbaTGwE61ZUmSEg3GKIcgvvE/X6gEUD1Mu+Ufzsny/usdKruzt9R9cJIK9ha/0bYRIsFBhea4sd+1Ww0R35FY9BbosdTvbDvdIaHvZYXd76KZ9S/wugv97ytyS+2N4uqZPrIFG2FU3gnxHbSshGLrDA57wdvljoAwyPo7QcKa5yTaBaFyxOLpdUGT8f+ozuL1zY6MWgRqP33V5pOcGYdCbyujM7rGCw4zWSiwgbaC04uXVhz2FMeLtNXL0zf5s8BiYeEMKlvO5QAAvqdT9mY7Ovjc8fn8gqA5hcHLv2MaByDGhah0kg0F0h6EevV+cu0IhcghZZoegHL3fkq3Xo1vbhkOH6nJKIo7r3McuswpU/EjE8enNOrnzQieuxkeUyYSp4uMOB3rSgJoD/iayYo3GeSJdvcREzeOu/1J/oSL2BftK8Zoxun+oGTp5YYxkkSiPbL67IpZdbw2fJOK0JIamB7z
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <93E2EA6A45F7CA4F87AC4A3CBEFD83AF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb11d27-3214-43e7-877a-08d77e807e41
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 21:24:23.4478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbVokWlgn3PGBdFWlTW2Fw9/dVtZlGYkgE5qonTC9ZCDy7rVaym75mpFnTJvhVXSObAVmx3bjX23HcCOMCneqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDE5OjQ5ICswMTAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBTYXQsIDcgRGVjIDIwMTkgMDM6NTI6NDEgKzAwMDANCj4gU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4gPiBJIGRvbid0IHRoaW5r
IGl0IGlzIGNvcnJlY3QgdG8gY2hlY2sgdGhhdCB0aGUgcGFnZSBuaWQgaXMgc2FtZSBhcw0KPiA+
IG51bWFfbWVtX2lkKCkgaWYgcG9vbCBpcyBOVU1BX05PX05PREUuIEluIHN1Y2ggY2FzZSB3ZSBz
aG91bGQgYWxsb3cNCj4gPiBhbGwNCj4gPiBwYWdlcyB0byByZWN5Y2xlLCBiZWNhdXNlIHlvdSBj
YW4ndCBhc3N1bWUgd2hlcmUgcGFnZXMgYXJlDQo+ID4gYWxsb2NhdGVkDQo+ID4gZnJvbSBhbmQg
d2hlcmUgdGhleSBhcmUgYmVpbmcgaGFuZGxlZC4NCj4gDQo+IEkgYWdyZWUsIHVzaW5nIG51bWFf
bWVtX2lkKCkgaXMgbm90IHZhbGlkLCBiZWNhdXNlIGl0IHRha2VzIHRoZSBudW1hDQo+IG5vZGUg
aWQgZnJvbSB0aGUgZXhlY3V0aW5nIENQVSBhbmQgdGhlIGNhbGwgdG8gX19wYWdlX3Bvb2xfcHV0
X3BhZ2UoKQ0KPiBjYW4gaGFwcGVuIG9uIGEgcmVtb3RlIENQVSAoZS5nLiBjcHVtYXAgcmVkaXJl
Y3QsIGFuZCBpbiBmdXR1cmUNCj4gU0tCcykuDQo+IA0KPiANCj4gPiBJIHN1Z2dlc3QgdGhlIGZv
bGxvd2luZzoNCj4gPiANCj4gPiByZXR1cm4gIXBhZ2VfcGZtZW1hbGxvYygpICYmIA0KPiA+ICgg
cGFnZV90b19uaWQocGFnZSkgPT0gcG9vbC0+cC5uaWQgfHwgcG9vbC0+cC5uaWQgPT0gTlVNQV9O
T19OT0RFDQo+ID4gKTsNCj4gDQo+IEFib3ZlIGNvZGUgZG9lc24ndCBnZW5lcmF0ZSBvcHRpbWFs
IEFTTSBjb2RlLCBJIHN1Z2dlc3Q6DQo+IA0KPiAgc3RhdGljIGJvb2wgcG9vbF9wYWdlX3JldXNh
YmxlKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHN0cnVjdCBwYWdlDQo+ICpwYWdlKQ0KPiAgew0K
PiAJcmV0dXJuICFwYWdlX2lzX3BmbWVtYWxsb2MocGFnZSkgJiYNCj4gCQlwb29sLT5wLm5pZCAh
PSBOVU1BX05PX05PREUgJiYNCj4gCQlwYWdlX3RvX25pZChwYWdlKSA9PSBwb29sLT5wLm5pZDsN
Cj4gIH0NCj4gDQoNCnRoaXMgaXMgbm90IGVxdWl2YWxlbnQgdG8gdGhlIGFib3ZlLiBIZXJlIGlu
IGNhc2UgcG9vbC0+cC5uaWQgaXMNCk5VTUFfTk9fTk9ERSwgcG9vbF9wYWdlX3JldXNhYmxlKCkg
d2lsbCBhbHdheXMgYmUgZmFsc2UuDQoNCldlIGNhbiBhdm9pZCB0aGUgZXh0cmEgY2hlY2sgaW4g
ZGF0YSBwYXRoLg0KSG93IGFib3V0IGF2b2lkaW5nIE5VTUFfTk9fTk9ERSBpbiBwYWdlX3Bvb2wg
YWx0b2dldGhlciwgYW5kIGZvcmNlDQpudW1hX21lbV9pZCgpIGFzIHBvb2wtPnAubmlkIHdoZW4g
dXNlciByZXF1ZXN0cyBOVU1BX05PX05PREUgYXQgcGFnZQ0KcG9vbCBpbml0LCBhcyBhbHJlYWR5
IGRvbmUgaW4gYWxsb2NfcGFnZXNfbm9kZSgpLiANCg0Kd2hpY2ggd2lsbCBpbXBseSByZWN5Y2xp
bmcgd2l0aG91dCBhZGRpbmcgYW55IGV4dHJhIGNvbmRpdGlvbiB0byB0aGUNCmRhdGEgcGF0aC4N
Cg0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jIGIvbmV0L2NvcmUvcGFnZV9wb29s
LmMNCmluZGV4IGE2YWVmZTk4OTA0My4uMDBjOTkyODJhMzA2IDEwMDY0NA0KLS0tIGEvbmV0L2Nv
cmUvcGFnZV9wb29sLmMNCisrKyBiL25ldC9jb3JlL3BhZ2VfcG9vbC5jDQpAQCAtMjgsNiArMjgs
OSBAQCBzdGF0aWMgaW50IHBhZ2VfcG9vbF9pbml0KHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsDQog
DQogICAgICAgIG1lbWNweSgmcG9vbC0+cCwgcGFyYW1zLCBzaXplb2YocG9vbC0+cCkpOw0KIA0K
KwkvKiBvdmVyd3JpdGUgdG8gYWxsb3cgcmVjeWNsaW5nLi4gKi8NCisgICAgICAgaWYgKHBvb2wt
PnAubmlkID09IE5VTUFfTk9fTk9ERSkgDQorICAgICAgICAgICAgICAgcG9vbC0+cC5uaWQgPSBu
dW1hX21lbV9pZCgpOyANCisNCg0KQWZ0ZXIgYSBxdWljayBsb29rLCBpIGRvbid0IHNlZSBhbnkg
cmVhc29uIHdoeSB0byBrZWVwIE5VTUFfTk9fTk9ERSBpbg0KcG9vbC0+cC5uaWQuLiANCg0KDQo+
IEkgaGF2ZSBjb21waWxlZCBkaWZmZXJlbnQgdmFyaWFudHMgYW5kIGxvb2tlZCBhdCB0aGUgQQ0K
PiBTTSBjb2RlIGdlbmVyYXRlZA0KPiBieSBHQ0MuICBUaGlzIHNlZW1zIHRvIGdpdmUgdGhlIGJl
c3QgcmVzdWx0Lg0KPiANCj4gDQo+ID4gMSkgbmV2ZXIgcmVjeWNsZSBlbWVyZ2VuY3kgcGFnZXMs
IHJlZ2FyZGxlc3Mgb2YgcG9vbCBuaWQuDQo+ID4gMikgYWx3YXlzIHJlY3ljbGUgaWYgcG9vbCBp
cyBOVU1BX05PX05PREUuDQo+IA0KPiBZZXMsIHRoaXMgZGVmaW5lcyB0aGUgc2VtYW50aWNzLCB0
aGF0IGEgcGFnZV9wb29sIGNvbmZpZ3VyZWQgd2l0aA0KPiBOVU1BX05PX05PREUgbWVhbnMgc2tp
cCBOVU1BIGNoZWNrcy4gIEkgdGhpbmsgdGhhdCBzb3VuZHMgb2theS4uLg0KPiANCj4gDQo+ID4g
dGhlIGFib3ZlIGNoYW5nZSBzaG91bGQgbm90IGFkZCBhbnkgb3ZlcmhlYWQsIGEgbW9kZXN0IGJy
YW5jaA0KPiA+IHByZWRpY3RvciB3aWxsIGhhbmRsZSB0aGlzIHdpdGggbm8gZWZmb3J0Lg0KPiAN
Cj4gSXQgc3RpbGwgYW5ub3lzIG1lIHRoYXQgd2Uga2VlcCBhZGRpbmcgaW5zdHJ1Y3Rpb25zIHRv
IHRoaXMgY29kZQ0KPiBob3QtcGF0aCAoSSBjb3VudGVkIDM0IGJ5dGVzIGFuZCAxMSBpbnN0cnVj
dGlvbnMgaW4gbXkgcHJvcG9zZWQNCj4gZnVuY3Rpb24pLg0KPiANCj4gSSB0aGluayB0aGF0IGl0
IG1pZ2h0IGJlIHBvc3NpYmxlIHRvIG1vdmUgdGhlc2UgTlVNQSBjaGVja3MgdG8NCj4gYWxsb2Mt
c2lkZSAoaW5zdGVhZCBvZiByZXR1cm4vcmVjeWNsZXMgc2lkZSBhcyB0b2RheSksIGFuZCBwZXJo
YXBzDQo+IG9ubHkNCj4gb24gc2xvdy1wYXRoIHdoZW4gZGVxdWV1aW5nIGZyb20gcHRyX3Jpbmcg
KGFzIHJlY3ljbGVzIHRoYXQgY2FsbA0KPiBfX3BhZ2VfcG9vbF9yZWN5Y2xlX2RpcmVjdCgpIHdp
bGwgYmUgcGlubmVkIGR1cmluZyBOQVBJKS4gIEJ1dCBsZXRzDQo+IGZvY3VzIG9uIGEgc21hbGxl
ciBmaXggZm9yIHRoZSBpbW1lZGlhdGUgaXNzdWUuLi4NCj4gDQoNCkkga25vdy4gSXQgYW5ub3lz
IG1lIHRvbywgYnV0IHdlIG5lZWQgcmVjeWNsaW5nIHRvIHdvcmsgaW4gcHJvZHVjdGlvbiA6DQp3
aGVyZSByaW5ncy9uYXBpIGNhbiBtaWdyYXRlIGFuZCBudW1hIG5vZGVzIGNhbiBiZSBOVU1BX05P
X05PREUgOi0oLg0KDQoNCg==
