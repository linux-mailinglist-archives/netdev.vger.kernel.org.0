Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE22342F71F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbhJOPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:47:01 -0400
Received: from mail-sn1anam02on2057.outbound.protection.outlook.com ([40.107.96.57]:51342
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236778AbhJOPrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 11:47:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS5i4+mHtTvbeGgK2Zy0CtG6eBiRof8tElM6X8cO9LqrRbQwkfLYED/IEZhGHsgsG7OZ7x1XCf42dvqfAzT+QbOEKht6SadVhhSmRMMa56tgFrRirl7LzHVRPVXNYA6t1mF7HVz2Gp0ysBd5y8Q0bjmtfD5jL7AxKTr4q3QkeOGgbP5UTqNSZpkAPWBOkc4vFkmsNgbzFvbMna4g36NN54HP5QhrW9VAD64yv4Rb8C/YItVd8l0GaYi6rZMt0wFdrL/q7Z0Ly6jF5iHMn97epCesy1T3iCECH4sG2kzun8OavrC12Gz2jj2FunjSymT9dCz2pGFF3FeYgav+yh0ivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOEHMemagXsFtCYRjwTil2lmp/rMFYjQR6yR0AVOYhk=;
 b=igeJF9yGXXi0nHmaXFf1gY5aqt70I8k3QVNh63C6bjEp1NGO8F3H2ZybQG91k3RLfFiS0VIq1WBuCo0E3lpDCd/fhk4gDobZLqYQBF3meGN2H95mkMvVPxbLlYIi0Xgf+ye+mGmTRZQIlmZtt5naRXOleDAv1UYM3klA+w7iwkUlLE/ELuo1lP/RNoR9DaCdmz+jzdr2zroIGXpmpmZelDohBOam8LXxEunG7aAIGCqxYlPCo2gNJ8cICHfWQF5xKOYH3f9B/fsTRqkoBpVBu6QSbMGJ2plTilKjWqMKweuCAQNaFHUzybIwpEDtrdwV9D/r9y3pzSTDjffeV/cEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOEHMemagXsFtCYRjwTil2lmp/rMFYjQR6yR0AVOYhk=;
 b=usKonTvxAqWk6dYa278dcL8H0wjVgdsnYInn8aGp5ZdlMLR7vM7QCUMChGa1zTUo5+BA4dVbW3QNjXF/0DAdotYzbzeaUDbJlqMmbjmrZgwqoRtXbAVQpeHeZdUFx1pyry2GfHl4fWJkK3fRAB83PnlrM6nvg0EiChXPGBMjfEpI8bWglOmdyW0CuORXu4ZS6qYKTZQER+3BEaRhMVHeOG87qp/z5+weAV+WQaOnfvQTUfMH8egJZkCk7sYae5JDqSiH/wt8bEzNnLY1RoKT9tEgHR6ctL8/e+REHDypBnynqh78heMhz3+huuX1rq7hNZpg4LWTgdy79m4o9wXrvQ==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3797.namprd12.prod.outlook.com (2603:10b6:610:27::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 15:44:52 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4587.032; Fri, 15 Oct 2021
 15:44:51 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v4 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v4 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXvFPEwyqz3iDSKUGtUdmTo3g2jKvTrD0AgABb7/A=
Date:   Fri, 15 Oct 2021 15:44:51 +0000
Message-ID: <CH2PR12MB3895191A29D54F3A77750E81D7B99@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20211008144920.10975-1-asmaa@nvidia.com>
 <20211008144920.10975-2-asmaa@nvidia.com>
 <CAMRc=Mc4yJZ2qv7W+mk-jJhhxEwe+7VowJt51ZekpVrZ=4LsZA@mail.gmail.com>
In-Reply-To: <CAMRc=Mc4yJZ2qv7W+mk-jJhhxEwe+7VowJt51ZekpVrZ=4LsZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59f1138d-b668-4b39-c1ff-08d98ff2ba2f
x-ms-traffictypediagnostic: CH2PR12MB3797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3797C3ECE9A15F732CCFD796D7B99@CH2PR12MB3797.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: au95G+4P4v2bYU7in7bG0gh4Jn7DQD6QiMj5UG3bFQr0UJReYdPZyluGOHN74Cg9WbeBGy/kftVgW5Ur12h4At1RXvAFP5CKjBY68q6dJFbeTg1BQOe/sBb+Rll34o2YD7MHl8rUHYMRG2n0dsf5yIkDvO9jRPUG+qaXtu9xJ1EJOIqrQv41j2v5mKN3DNiaA2ImpfLExem+qewsavqYcvStLgenTAq0f/3IjOA1sqxbm4JaEZYCx9G3hd9HnRfRqqLeefBfiirU3hvci+z670DRyqlzkljBxm2am6S3UzJiSpO5+w2tcmi2PCcWwwYC5zApdpPJnX53PH8DS8rZ6rM9crxzmeqmyPPN4nmtkAoQZf8M2oHWORd1AdZUwCCERqLvqbUf44EuCa/ZmQAWpkprENuDsI5nYLVL+KtT5cfz4zPGD928HIs/73c/wWB6pR2XegMxTUZZaqezPVdgIa56hgd1DNk7QtYdW0d0R4Y0UvL6n3l1ffKb/COpnhhbLI8RXyDOueW47h6HW1NlAIhKM1+JHEajj1LtxuKreD/HdndpLAroX0FnAnqy6RoAzMHW81yfJ5uKICkGLVrrF9X2XStb4VHSjQTFJV1dHy2dZ+MtTdd2/rxIjvuWVxS20CovbXQEcYZ3Vn6rKQ5hKL8zOVZKMwqI4/+pFuIwcVHDWczAdn95rb0krBRPLi06OKNTcZEfND4wuH+1Yl2Erg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(71200400001)(8676002)(64756008)(66446008)(52536014)(107886003)(186003)(110136005)(8936002)(508600001)(9686003)(76116006)(38070700005)(66556008)(66946007)(2906002)(5660300002)(7416002)(7696005)(122000001)(6506007)(86362001)(4326008)(38100700002)(316002)(33656002)(83380400001)(54906003)(26005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2RUWmZlejRoTFhpNG4xREJsNFNwUmlOL2pPR1NhTlVkdGhjYnlCbmlKOXo2?=
 =?utf-8?B?T2paRUxxbmlZT21tT2RBZktrR3g1RjNURDgrc1ZoMjk2TkJ1UExBODZSZHVn?=
 =?utf-8?B?ck84V3BPVEVwbmY2NFl2QXVNYk1SQ0kzMEpuQTdQZFlUcUFteXFmcmhQUFFz?=
 =?utf-8?B?bk5RNkN2bkVwVGZPeXJhZnJ5dVRPajBKdnU5V2JIK0ttUGJxS1JoVVhrUzNN?=
 =?utf-8?B?TUx0MWRpVkJDaVZyc0oyNjVsNjdtdU9kb1ZIQXFzWUV5Z2crWXgvdmg0TzJR?=
 =?utf-8?B?SUFnOUVkQU5DTDd4QzJTZmlPK050UlNqN01TL216cjhONVVmUWdrVG9HT1Bs?=
 =?utf-8?B?M2t3aFlkRmhWcUtYNlJBb1hPcVcyU0hwYWpLTDFBbFpTbXF5ZkZ2U0lITzVP?=
 =?utf-8?B?MWVVN2NTbHd6UEJTWi81bHZ3THVGTFA5eTZiSkVFRVZrQzZhSDdyenJTNGVF?=
 =?utf-8?B?MlJrdFdRbm1zRk9RaDExZHNhUDIyMGVIYmlDS2xEblJxSTRwWjJIdWhQZWlm?=
 =?utf-8?B?ZVJQQ1laWDZBLytWeGdOM0xrcExTbmpmaUtxQ0hsOUhuVkJLNmRPU2tDRmM2?=
 =?utf-8?B?aXpwdCt5cVdLYy84dGptWG4rc051TGFFNWExeUVqTWJ2VFpPLzlqRnpuMFZB?=
 =?utf-8?B?d2doMlUrMUNQTXpmcHBnVUJoUXRLWXRhM0JGMTArOVh0V28vUUNZMndaa0Z0?=
 =?utf-8?B?TTVUOEhZN1VzY1pyQVk1L0dmbzl0T1V3MWNDNlFqWFI5anFZT3FGS0c1eGtK?=
 =?utf-8?B?TEs5MjQ3QjM2OWdDUTE2V3Z3M1RtVk1EbHdpTnpRRWtwV2tnQUJJRkY5N0hu?=
 =?utf-8?B?bk1oOWQ4VXNDTUVtd0F0RjBsbGkvMzRUVURRRDg0a3ZvVkJsL3YxaE9XSzRI?=
 =?utf-8?B?T25Lb05lb29Jd05sVERuWXVWeDNhUlEwKzZvOCtXZXFpVVVOR05iRnUrbVlv?=
 =?utf-8?B?T3ZLeGhNS3lQTjlvbDVVTG1GZEVxeFZrb2wrVUhzdEVjYU5DVGxJRmdLTGZG?=
 =?utf-8?B?VEQ2dTgxWkVBMmFGTnpRWHpoY2lMNHhYdGZjS0UyTko0Q1BKVHFlaGVCcXBO?=
 =?utf-8?B?WVoxUk1YcWVmSGNHcDJTNnl3UTZnZjc0R25yQWUxMTdPR2JyS1RyOUxQTCtw?=
 =?utf-8?B?WEJ0R3ljTVdQaG1USzRTM1RROVJ6a1FRZ3RZcXVUZS9YVkM0cmtydHZReHR0?=
 =?utf-8?B?am0zMUlyQW1LTEdDaER6RkNtTE4zMjFrbW1JNFhFYllUS09SOUxvQ25NYnNE?=
 =?utf-8?B?T0pRM3dYamY4OVJwNGJKL0hiQzMxQnZpQ0dPUU1NSkJVbldEN2paRTBtUHpL?=
 =?utf-8?B?ZjJ5S2Q5dVM5MndxWi92UXRiaFJIeFNSY0dSZHBSN0RjMDhGdzU2NzF1NlVX?=
 =?utf-8?B?ZFd5RHZ1blNVL1prMG5pWTZKek9DUExOYy9QbzFZRVRpNDU0bzBCNEFMaldJ?=
 =?utf-8?B?QUNUS0dEZThyS0xhcW0vbEJ3Q0ZremNrRWJmK2JrSS9pV1VpVmk5ZUxCOHhP?=
 =?utf-8?B?Z0ZIczRXTFV3dzBySUEwRjNReG5PNk5HUGg5SEhXdHZWQ3E1aE80ZDZIUUtx?=
 =?utf-8?B?STRCZXVjaWVPOUw2KzAreVBSOUs4MkFXaitMMlRXMldEdE9WSUNkdTVPTEUw?=
 =?utf-8?B?QVhTaWhvTUpYaWVKV2lUcENob3M4YzRycGgvY1VCQXFSUGI3V0JxNFNnRUM1?=
 =?utf-8?B?U1dYUjlreC9QZHJyNGdna1h5TzJRd2gyb0xDWDZRU1BkcVJGeVo5RnBJbUc5?=
 =?utf-8?Q?AOacanB936qvdvI+iFu1Nk81GKcDK2RyM6/Iiez?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f1138d-b668-4b39-c1ff-08d98ff2ba2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 15:44:51.7335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHHWgMLFH/ROhw3w+3+ULyTQJifeIE5VwoufSHeiFqmuoBxeNmwhswN+E3MFSIO1alDlHbqx+oNzgCymBrvleA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAgLyogQmx1ZUZpZWxkLTIgR1BJTyBkcml2ZXIgaW5pdGlhbGl6YXRpb24gcm91dGluZS4gKi8g
IHN0YXRpYyBpbnQgIA0KPiBtbHhiZjJfZ3Bpb19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2KSAgew0KPiAgICAgICAgIHN0cnVjdCBtbHhiZjJfZ3Bpb19jb250ZXh0ICpnczsNCj4g
ICAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcGRldi0+ZGV2Ow0KPiArICAgICAgIHN0cnVj
dCBncGlvX2lycV9jaGlwICpnaXJxOw0KPiAgICAgICAgIHN0cnVjdCBncGlvX2NoaXAgKmdjOw0K
PiAgICAgICAgIHVuc2lnbmVkIGludCBucGluczsNCj4gLSAgICAgICBpbnQgcmV0Ow0KPiArICAg
ICAgIGNvbnN0IGNoYXIgKm5hbWU7DQo+ICsgICAgICAgaW50IHJldCwgaXJxOw0KPiArDQo+ICsg
ICAgICAgbmFtZSA9IGRldl9uYW1lKGRldik7DQo+DQo+ICAgICAgICAgZ3MgPSBkZXZtX2t6YWxs
b2MoZGV2LCBzaXplb2YoKmdzKSwgR0ZQX0tFUk5FTCk7DQo+ICAgICAgICAgaWYgKCFncykNCj4g
QEAgLTI1NiwxMSArMzY2LDQ0IEBAIG1seGJmMl9ncGlvX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIE5VTEwsDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgIDApOw0KPg0KPiArICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAg
ICAgICAgIGRldl9lcnIoZGV2LCAiYmdwaW9faW5pdCBmYWlsZWRcbiIpOw0KPiArICAgICAgICAg
ICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICB9DQoNCj4gVGhpcyBpcyBhIGNvcnJlY3QgZml4
IGJ1dCBpdCBzaG91bGQgYmUgc2VudCBhcyBhIGZpeCBhaW1lZCBmb3Igc3RhYmxlIGluIGEgc2Vw
YXJhdGUgYnJhbmNoLCBhcyB3ZSB3YW50IHRoYXQgdG8gYmUgYmFja3BvcnRlZC4NCk9rISBTbyBJ
IHdpbGwgc2VuZCB2NSBwYXRjaCwgbGVhdmluZyB0aGVzZSA0IGxpbmVzIG91dCwgdGhlbiB3aWxs
IGFkZCB0aGlzIHNtYWxsIGZpeCB0byBhIHNlcGFyYXRlIHBhdGNoIGFpbWVkIHRvIHRoZSBzdGFi
bGUgYnJhbmNoLg0KDQo+IE90aGVyIHRoYW4gdGhhdCBpdCBsb29rcyBnb29kIHRvIG1lLCB3aGlj
aCB0cmVlIGRvIHlvdSB3YW50IGl0IHRvIGdvIHRocm91Z2g/DQoNClNpbmNlIHRoZSBtbHhiZi1n
aWdlIGRyaXZlciBpcyBkZXBlbmRlbnQgb24gdGhpcyBjb21taXQsIEkgd291bGQgbGlrZSB0byBw
dXNoIGJvdGggdGhpcyBncGlvDQpjb21taXQgYW5kDQoiW1BBVENIIHY0IDIvMl0gbmV0OiBtZWxs
YW5veDogbWx4YmZfZ2lnZTogUmVwbGFjZSBub24tc3RhbmRhcmQgaW50ZXJydXB0IGhhbmRsaW5n
Ig0KdG8gdGhlIHNhbWUgdHJlZS9icmFuY2guDQoNCkkgYXBvbG9naXplIEkgYW0gbm90IHZlcnkg
ZmFtaWxpYXIgd2l0aCB0aGUgcHVzaCBwcm9jZXNzIHdoZW4gMiBkZXBlbmRlbnQgY29tbWl0cw0K
dGFyZ2V0IGRpZmZlcmVudCBkcml2ZXJzLiBTbyBhbnkgaW5wdXQgaXMgZ3JlYXRseSBhcHByZWNp
YXRlZCENClNpbmNlIHRoZSBtbHhiZl9naWdlIGRyaXZlciBpcyB0YXJnZXRpbmcgdGhlIG5ldCBt
YXN0ZXIgYnJhbmNoLCB3b3VsZCBpdCBiZSBwb3NzaWJsZSB0byBwdXNoDQpUaGUgR3BpbyBjaGFu
Z2UgYXMgd2VsbCB0byBuZXQ/IA0KSWYgdGhpcyBpcyBub3QgcG9zc2libGUsIG1heWJlIHdlIGNh
biBwdXNoIHRoZSBjb21taXQgdG8gbGludXgtZ3BpbyBtYXN0ZXIgYW5kDQpUaGUgbWx4YmZfZ2ln
ZSB0byB0aGUgbmV0IGJyYW5jaC4gQnV0IHdlIHdpbGwgbmVlZCB0byBzeW5jIHRoZSB0aW1pbmcg
Zm9yIHdoZW4gYm90aA0KcmVxdWVzdHMgZ28gdG8gdGhlIG1haW5saW5lLg0KDQpEYXZpZCBNaWxs
ZXIsIEFuZHJldyBMdW5uLCBJIGtub3cgeW91IGhhdmUgYWNrZWQvcmV2aWV3ZWQgdjEgYW5kIHYy
IHBhdGNoZXMgZm9yDQp0aGUgbWx4YmZfZ2lnZSBkcml2ZXIuIEkganVzdCB3YW50IHRvIG1ha2Ug
c3VyZSB5b3UgYXJlIHN0aWxsIG9rIHdpdGggdGhpcyBpbXBsZW1lbnRhdGlvbi4NCkkgbWVudGlv
bmVkIGluIGEgcHJldmlvdXMgZW1haWwgdGhhdCBvdXIgbWFuYWdlbWVudC9wcm9kdWN0IG1hbmFn
ZXIgYXBwcm92ZWQgdXNpbmcgDQpQSFkgaW50ZXJydXB0IGluc3RlYWQgb2YgcG9sbGluZy4NCg0K
VGhhbmsgeW91Lg0KQXNtYWENCg==
