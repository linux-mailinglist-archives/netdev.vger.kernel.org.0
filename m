Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B8F759F0
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfGYV7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:59:13 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:33942
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbfGYV7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 17:59:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz1+b44mtva4eE9s16u5EANMHvs/yOtZtKDk5kyjIDNGYd8ir6HOY1uQXIyHucTm75fUjU6IW9Ph+IRmR1K7RxQKzaGQq/7Za3uzf62Maf01S1VyTyLl7xC7BThAKU2UirXBupT0XWtxiJJZpBGEQ8ksOlXhLnWVcyXyJ4pdqdAxi8+xA7kxe3w9oUQn8yerZQCtLVfU4fKESTWizZi6xva2+KntdtQT1/OF7vcV3Iaqp4QNSlaC5JZ7dLf2UQur/cPx0mxJ8pcVGtTtaWri+HxmpNIyT9ZBKy1d6MypKcAzzRjgeUn9/2kHdXdSnzFVkOojQajSv09X1Je2IwIKLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNwkeJIjqstjTu07nZQzNtqjXw8q8i2KX8RXwL8IDVY=;
 b=JnVa94gNcuG4gYd1JqPo9ed/HMaw9AWk/QgGAjtXp5dy9YmjEMYx/1QrQqcLjxxzYaJFFi4/3dyGymyRQVFaaLyAXy9xfKPhd2J7++ZFiXAqhiogth37PVgq6Lzt2eulBEfSle6YZsaDJIVTSz37c6qFaLERDjqYZqs2WdT7pVaMAxQFBMVO+z8+N9v9LmoLhkIXovGnbLdB73mD9z0Gh/Yk4nr9YZlBk0QkXLNBvMxOwZLCsgutExhbKF4d5hL5BER5hfTqePzmp+SCYxhFhdfOdGJfLxkOfVh5rk4YdFfwReufuScA3Hiz+VpoY/Muif2o4gRXFu7zsVZyMwKwhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNwkeJIjqstjTu07nZQzNtqjXw8q8i2KX8RXwL8IDVY=;
 b=cYaS5wVdrTeT7AE/O8VOJst7kjlBK4Q+ddXzP/Ll1vdh1N+lzL1AYgjWa4HFqQVuewq33D5+vDb6TBHhbLt2+JjEPugUap4yBxNQo0ernZ0ceyCupu75M484VU77971afmLujGanUmZDLy5BelSAVY+1nc4YTFiDPsZ7VXCUEKU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2567.eurprd05.prod.outlook.com (10.168.71.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 25 Jul 2019 21:59:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 21:59:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 07/11] net: hns3: adds debug messages to identify
 eth down cause
Thread-Topic: [PATCH net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
Thread-Index: AQHVQc7zCe+NYHPG9Uy99SJMowXJu6baI8sAgAEhZYCAAJ+NAA==
Date:   Thu, 25 Jul 2019 21:59:08 +0000
Message-ID: <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
         <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
         <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
         <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
In-Reply-To: <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 941c26da-9f6c-47cf-696e-08d7114b518b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2567;
x-ms-traffictypediagnostic: DB6PR0501MB2567:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2567E31284E2F45DA97845B2BEC10@DB6PR0501MB2567.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(6116002)(71190400001)(186003)(14444005)(26005)(81156014)(316002)(2501003)(66556008)(66476007)(66066001)(8936002)(476003)(486006)(64756008)(66446008)(6306002)(3846002)(5660300002)(102836004)(91956017)(76116006)(478600001)(66946007)(4326008)(81166006)(86362001)(36756003)(2616005)(11346002)(71200400001)(229853002)(2201001)(6246003)(446003)(7736002)(6486002)(305945005)(25786009)(53546011)(2906002)(110136005)(8676002)(53936002)(99286004)(54906003)(76176011)(118296001)(15650500001)(58126008)(966005)(68736007)(256004)(6436002)(6512007)(14454004)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2567;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hSM7jgW26v+mT5PWziKAVfysAER995b+O069OO3gT3LFcC/XphDmAnz2IqKoUdiuJx6yKjJqTzi6KDj7IytLTzPQoKkBOtW6sON1x1Zc8HVefxR/pjLHWaUKVg/Nt3+2zCFasoLTpk/p37heH8ymBCnydvoItr5JviNGJVL8HkaYwsZYfpqR03axW0xCYU12us4CHA59LiitYcM6dplefc9DQ3/pXtUhw+FnXSNohP582XE4gT3+9+dR2dem1AF07Kt7KTGk8fGUcAw0NTjx9ML7CYfWiyJLKS82qKAXk2g7gwlyTs+xpo3ZeSYR7my0BYVbl1I9opJT/V/uQcxwEKiuUhd/KEIlVEiG0+ViEBd01Cfw3NSQoP1BNflzT33p18TQA7OhHRsuYRZ/hjLr/6VCtCf3fcz3lyvVNyARmyk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C75C041434C0994B908C8B80DF515F5C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941c26da-9f6c-47cf-696e-08d7114b518b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 21:59:08.2935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDIwOjI4ICswODAwLCBsaXV5b25nbG9uZyB3cm90ZToNCj4g
DQo+IE9uIDIwMTkvNy8yNSAzOjEyLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBXZWQs
IDIwMTktMDctMjQgYXQgMTE6MTggKzA4MDAsIEh1YXpob25nIFRhbiB3cm90ZToNCj4gPiA+IEZy
b206IFlvbmdsb25nIExpdSA8bGl1eW9uZ2xvbmdAaHVhd2VpLmNvbT4NCj4gPiA+IA0KPiA+ID4g
U29tZSB0aW1lcyBqdXN0IHNlZSB0aGUgZXRoIGludGVyZmFjZSBoYXZlIGJlZW4gZG93bi91cCB2
aWENCj4gPiA+IGRtZXNnLCBidXQgY2FuIG5vdCBrbm93IHdoeSB0aGUgZXRoIGRvd24uIFNvIGFk
ZHMgc29tZSBkZWJ1Zw0KPiA+ID4gbWVzc2FnZXMgdG8gaWRlbnRpZnkgdGhlIGNhdXNlIGZvciB0
aGlzLg0KPiA+ID4gDQo+ID4gDQo+ID4gSSByZWFsbHkgZG9uJ3QgbGlrZSB0aGlzLiB5b3VyIGRl
ZmF1bHQgbXNnIGx2bCBoYXMgTkVUSUZfTVNHX0lGRE9XTg0KPiA+IHR1cm5lZCBvbiAuLiBkdW1w
aW5nIGV2ZXJ5IHNpbmdsZSBvcGVyYXRpb24gdGhhdCBoYXBwZW5zIG9uIHlvdXINCj4gPiBkZXZp
Y2UNCj4gPiBieSBkZWZhdWx0IHRvIGtlcm5lbCBsb2cgaXMgdG9vIG11Y2ggISANCj4gPiANCj4g
PiBXZSBzaG91bGQgcmVhbGx5IGNvbnNpZGVyIHVzaW5nIHRyYWNlIGJ1ZmZlcnMgd2l0aCB3ZWxs
IGRlZmluZWQNCj4gPiBzdHJ1Y3R1cmVzIGZvciB2ZW5kb3Igc3BlY2lmaWMgZXZlbnRzLiBzbyB3
ZSBjYW4gdXNlIGJwZiBmaWx0ZXJzDQo+ID4gYW5kDQo+ID4gc3RhdGUgb2YgdGhlIGFydCB0b29s
cyBmb3IgbmV0ZGV2IGRlYnVnZ2luZy4NCj4gPiANCj4gDQo+IFdlIGRvIHRoaXMgYmVjYXVzZSB3
ZSBjYW4ganVzdCBzZWUgYSBsaW5rIGRvd24gbWVzc2FnZSBpbiBkbWVzZywgYW5kDQo+IGhhZA0K
PiB0YWtlIGEgbG9uZyB0aW1lIHRvIGZvdW5kIHRoZSBjYXVzZSBvZiBsaW5rIGRvd24sIGp1c3Qg
YmVjYXVzZQ0KPiBhbm90aGVyDQo+IHVzZXIgY2hhbmdlZCB0aGUgc2V0dGluZ3MuDQo+IA0KPiBX
ZSBjYW4gY2hhbmdlIHRoZSBuZXRfb3Blbi9uZXRfc3RvcC9kY2JubF9vcHMgdG8gbXNnX2RydiAo
bm90IGRlZmF1bHQNCj4gdHVybmVkIG9uKSwgIGFuZCB3YW50IHRvIGtlZXAgdGhlIG90aGVycyBk
ZWZhdWx0IHByaW50IHRvIGtlcm5lbCBsb2csDQo+IGlzIGl0IGFjY2VwdGFibGU/DQo+IA0KDQph
Y2NlcHRhYmxlIGFzIGxvbmcgYXMgZGVidWcgaW5mb3JtYXRpb24gYXJlIGtlcHQgb2ZmIGJ5IGRl
ZmF1bHQgYW5kDQp5b3VyIGRyaXZlciBkb2Vucyd0IHNwYW0gdGhlIGtlcm5lbCBsb2cuDQoNCnlv
dSBzaG91bGQgdXNlIGR5bmFtaWMgZGVidWcgWzFdIGFuZC9vciAib2ZmIGJ5IGRlZmF1bHQiIG1z
ZyBsdmxzIGZvcg0KZGVidWdnaW5nIGluZm9ybWF0aW9uLi4NCg0KSSBjb3VsZG4ndCBmaW5kIGFu
eSBydWxlcyByZWdhcmRpbmcgd2hhdCB0byBwdXQgaW4ga2VybmVsIGxvZywgTWF5YmUNCnNvbWVv
bmUgY2FuIHNoYXJlID8uIGJ1dCBpIHZhZ3VlbHkgcmVtZW1iZXIgdGhhdCB0aGUgcmVjb21tZW5k
YXRpb24NCmZvciBkZXZpY2UgZHJpdmVycyBpcyB0byBwdXQgbm90aGluZywgb25seSBlcnJvci93
YXJuaW5nIG1lc3NhZ2VzLg0KDQpbMV0gDQpodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1s
L3Y0LjE1L2FkbWluLWd1aWRlL2R5bmFtaWMtZGVidWctaG93dG8uaHRtbA0KDQo+ID4gPiBAQCAt
MTU5Myw2ICsxNjAzLDExIEBAIHN0YXRpYyBpbnQgaG5zM19uZG9fc2V0X3ZmX3ZsYW4oc3RydWN0
DQo+ID4gPiBuZXRfZGV2aWNlICpuZXRkZXYsIGludCB2ZiwgdTE2IHZsYW4sDQo+ID4gPiAgCXN0
cnVjdCBobmFlM19oYW5kbGUgKmggPSBobnMzX2dldF9oYW5kbGUobmV0ZGV2KTsNCj4gPiA+ICAJ
aW50IHJldCA9IC1FSU87DQo+ID4gPiAgDQo+ID4gPiArCWlmIChuZXRpZl9tc2dfaWZkb3duKGgp
KQ0KPiA+IA0KPiA+IHdoeSBtc2dfaWZkb3duID8gbG9va3MgbGlrZSBuZXRpZl9tc2dfZHJ2IGlz
IG1vcmUgYXBwcm9wcmlhdGUsIGZvcg0KPiA+IG1hbnkNCj4gPiBvZiB0aGUgY2FzZXMgaW4gdGhp
cyBwYXRjaC4NCj4gPiANCj4gDQo+IFRoaXMgb3BlcmF0aW9uIG1heSBjYXVzZSBsaW5rIGRvd24s
IHNvIHdlIHVzZSBtc2dfaWZkb3duLg0KPiANCg0KaWZkb3duIGlzbid0IGxpbmsgZG93bi4uIA0K
DQp0byBiZSBob25lc3QsIEkgY291bGRuJ3QgZmluZCBhbnkgZG9jdW1lbnRhdGlvbiBleHBsYWlu
aW5nIGhvdy93aGVuIHRvDQp1c2UgbXNnIGx2bHMsIChpIGRpZG4ndCBsb29rIHRvbyBkZWVwIHRo
b3VnaCksIGJ5IGxvb2tpbmcgYXQgb3RoZXINCmRyaXZlcnMsIG15IGludGVycHJldGF0aW9ucyBp
czoNCg0KaWZkdXAgKG9wZW4vYm9vdCB1cCBmbG93KQ0KaWZkd29uIChjbG9zZS90ZWFyZG93biBm
bG93KQ0KZHJ2IChkcml2ZXIgYmFzZWQgb3IgZHluYW1pYyBmbG93cykgDQpldGMgLi4gDQoNCi1T
YWVlZC4NCg==
