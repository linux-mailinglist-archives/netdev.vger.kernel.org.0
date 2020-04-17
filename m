Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EA11AE878
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgDQXCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:02:24 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:38582
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbgDQXCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:02:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs+nEhSi/Q4Yp8TFBmIRzJMAk3TWzzfoOu5gvIC4MOn+rd8Jxg3qQOrMFt+GjfTt9xvQ+zN0cXDwFjXLwmnaxFl2zpMmb7K2plS17GLU7DJZVxjtAxE/I3hedCXWr4ZQl/Q+8qxucG75GWH+VCAoswol4j2hmd0800AopqoZvW/Ve0K9o1TmyZSLtHaMGvrZQCKMvL65N8pSCmCrNjF8PDgcdW3f4F8KsesY5OZ6BOD73G86/iNP9AAZvKk5QRx2hok9V/fI2vIVqK09Gvunyn3dAZGTmr1SCYo09ZKm6BASgMY8CzhU9a4N+aTAmcGf2gFry0/5WrdgVr1+aTSrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1aJXDFpjvcUzYggvBpKgOMfp/C0VuaTLqyGVhEvXuI=;
 b=czoNuNJVjartQhLViRF/xr1qWUVtIu2Mdy3N8zRO9NWzcyQUXssGv7eySuQ6MEnnXUIK9zKTQUwH2Qw6+9keNw04XbTI0yV7II6+mmtFIMNc26Bycd/4UYRt+TOhHQUrBRzExgKbkpGBaT+WzldkVBF7EAoou6EUyjCdKwCCgfKZWMDLAvhG56Mi9qOsnIzoN/Iu6vZTfvLrK9QZJfxQDslEj2V5+YTL615e2QGfYkKxer0Qy1aMh9GzFv5a+MyS0fiWE+fAZM9v3nwpLVsJu6rYi0WIb82dUJvckAFjl0Tbu2chxVeV40ukFAgHV8wKs395/32iXxEdWoHLgsUUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1aJXDFpjvcUzYggvBpKgOMfp/C0VuaTLqyGVhEvXuI=;
 b=d+3iM9EUjN/OidkFir+gIB7TAr4w2LAKGfmX8NEJVChKindGLRuzjrixKq53gvL99hHgqM1VJgJJDE8cLAQedcb9BtvXEaPI2mPkB3ONZQZpXJyhkx40f5pEwYi/i2jUYQ8w4vY98JcCWRRVMW+efQYfSLg5xtQJHTqMwNHGMLc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5407.eurprd05.prod.outlook.com (2603:10a6:803:93::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Fri, 17 Apr
 2020 22:59:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 22:59:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "edumazet@google.com" <edumazet@google.com>
CC:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
Thread-Topic: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
Thread-Index: AQHWFBIDv40ebB4u9EyyQ97YK5VRKah8r+GAgACKCoCAALWzAA==
Date:   Fri, 17 Apr 2020 22:59:44 +0000
Message-ID: <05bc2889c7ee8be8e33dcf635b85c237927317e9.camel@mellanox.com>
References: <20200415164652.68245-1-edumazet@google.com>
         <761fa4422e5576b087c8e6d26a9046126f5dff2f.camel@mellanox.com>
         <CANn89i+Vs63kwJZXXHTvhnNgDLPsPmXzJ99pSD5GimXd5Qt0EA@mail.gmail.com>
In-Reply-To: <CANn89i+Vs63kwJZXXHTvhnNgDLPsPmXzJ99pSD5GimXd5Qt0EA@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: f09cd02c-d725-4ce8-b369-08d7e323056b
x-ms-traffictypediagnostic: VI1PR05MB5407:|VI1PR05MB5407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5407FF26117897CC98EA5220BED90@VI1PR05MB5407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(2616005)(53546011)(6486002)(76116006)(91956017)(2906002)(86362001)(71200400001)(4326008)(186003)(66946007)(6506007)(66446008)(66476007)(26005)(64756008)(81156014)(66556008)(6512007)(36756003)(498600001)(6916009)(5660300002)(8936002)(54906003)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AUhfyjPuNBmDR8yh+4i3CPbi98gXUxKfFMhYKXfEbViIZLkqtz2c9THsmhU52SDMO4EXg+l918Mq4F9t+B0CtdXSeWFbFEuIki1vWKibyp9NqI8kkprzxNs+Tp6ecpIlXptmQZ7OCMMRTy4yWgPN3FqdG37MgerE/VW+KYkLMIIhgnVrWcmuCVW0ldfD33jojArV1++J7fyuR/P8u3Czn+k8YQ1GQtre94puNNm/P7vXjVVEhjAd78yycC/6L0AZz+cddfXdGCv+nEw7ifUUh6uGCJRrllfM4vl4olQ+ktaMaGRDTsp1DZ3GJb4h0+4bphyzlF26ZekfFD1+vpxY0vL0vbL87X2gJRAqoR7CymMx5KPWjVXhJY8S2w83WlfzmHachFExEEQWSf4En8RO0jCBsrwuyTca9A9B9toD2TRg9aIZOzz0Xh3BHLU/xTLU
x-ms-exchange-antispam-messagedata: v057BvXZwwwUl8r2wtrq24yxKTq4SkExIQCRss/5YCbOVq8rM9s7pu3QM6e5HetdWPr4SvjrdzVPXJhcIeN2wc5DA1Skw/qTt27QwBhOGFHmSc4E2AIiJLHT0xkrFOhSEc5GTpG1saGySa5x/lxcpQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9C1C466C8CB3848A200421C0DD1A07D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09cd02c-d725-4ce8-b369-08d7e323056b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 22:59:44.9050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k6zUzx/prXpB2FvfhIDpVL/5VBZDpGLzNwAF/9RcdsUNQ0FWLdqGz+SGzQSgOzTPp1xjiQXex6PMacyWFj4kMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTE3IGF0IDA1OjA5IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IE9uIFRodSwgQXByIDE2LCAyMDIwIGF0IDg6NTUgUE0gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBt
ZWxsYW5veC5jb20+DQo+IHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMC0wNC0xNSBhdCAwOTo0NiAt
MDcwMCwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPiA+ID4gQ29tbWl0IDllY2MyZDg2MTcxYSAoIm5l
dC9tbHg0X2VuOiBhZGQgeGRwIGZvcndhcmRpbmcgYW5kIGRhdGENCj4gPiA+IHdyaXRlDQo+ID4g
PiBzdXBwb3J0IikNCj4gPiA+IGJyb3VnaHQgYW5vdGhlciBpbmRpcmVjdCBjYWxsIGluIGZhc3Qg
cGF0aC4NCj4gPiA+IA0KPiA+ID4gVXNlIElORElSRUNUX0NBTExfMigpIGhlbHBlciB0byBhdm9p
ZCB0aGUgY29zdCBvZiB0aGUgaW5kaXJlY3QNCj4gPiA+IGNhbGwNCj4gPiA+IHdoZW4vaWYgQ09O
RklHX1JFVFBPTElORT15DQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEVyaWMgRHVtYXpl
dCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+IENjOiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBt
ZWxsYW5veC5jb20+DQo+ID4gPiBDYzogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtYkBnb29nbGUu
Y29tPg0KPiA+ID4gLS0tDQo+ID4gDQo+ID4gSGkgRXJpYywgSSBiZWxpZXZlIG5ldC1uZXh0IGlz
IHN0aWxsIGNsb3NlZC4NCj4gPiANCj4gPiBCdXQgRldJVywNCj4gPiANCj4gPiBSZXZpZXdlZC1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gDQo+IA0KPiBXZWxs
LCB0aGlzIGNhbiBiZSBwdXNoZWQgdG8gbmV0IHRoZW4sIHNpbmNlIHRoaXMgaXMgYSB0cml2aWFs
IHBhdGNoDQo+IHRoYXQgaGVscHMgcGVyZm9ybWFuY2UuDQo+IA0KPiBXaXRoIHRoaXMgQ09WSUQt
MTkgdGhpbmcsIHdlIG5lZWQgbW9yZSBjYXBhY2l0eSBmcm9tIHRoZSBzZXJ2aW5nDQo+IGZsZWV0
DQo+IChZb3V0dWJlIGFuZCBhbGwuLikNCj4gZGlzdHJpYnV0ZWQgYWxsIG92ZXIgdGhlIHdvcmxk
IGFuZCB1c2luZyBhIGhpZ2ggbnVtYmVyIG9mIENYLTMgTklDLg0KPiANCj4gVGhhbmtzLg0KPiAN
Cg0KSSBkb24ndCBtaW5kLCBlaXRoZXIgbmV0IG9yIG5ldC1uZXh0IGlzIGZpbmUgYnkgbWUsIHVw
IHRvIERhdmUsIA0KDQphbHRob3VnaCB3ZSBhcmUgbWlzc2luZyB0aGUgRml4ZXMgVGFnIC4uIA0K
DQpGaXhlczogOWVjYzJkODYxNzFhICgibmV0L21seDRfZW46IGFkZCB4ZHAgZm9yd2FyZGluZyBh
bmQgZGF0YSB3cml0ZQ0Kc3VwcG9ydCIpDQoNCg==
