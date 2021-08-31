Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D43FBFF2
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhHaAZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:25:14 -0400
Received: from mail-vi1eur05on2105.outbound.protection.outlook.com ([40.107.21.105]:46817
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230523AbhHaAZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 20:25:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwHGUz2rFmkkJzfdqF+vmfOWpP0OYDZsagCxC4rerYRm3BBe9PZlC6DZNPzsOzNDR3EcuDdSvv8DBj+T9nGL6JY2tCCzPVfsI+OhL8fYxOoGlzFXOFx+cC3jFpiTqKhe3efcRWKXQT8Vi5ppxUYWuRu0N3z+bXsNcHOG5qxbSU1iumx9Xu5lF/heVwApnTqqH4knfzgXcm60CekoRfJe1gRCiS4Pnpm2NHq+v6W6YYMHZByx92wkx0RG3D0/5ZIecSh8g8LlY4Sb7yT0rJbCtGVK4StkllsSqowqXXwKGWD8w/HgNaG+MFXgXdTet7VKj/RPW6pkflTd/6PKUOcAOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC48073iwVOWdazrFv9b6YU2oNxiCI2iag97HUy1EIc=;
 b=T+fk31EmDWOCP5yMlvzsMAJG2nOWTsLoSp/u3eK/ckpoYiRket88r3nXU5OQD8Rzhf2f0FJGpR/mlS9DFDFaaNZmuWXyuTDg+7wB+rPdek/YWeiLa3faJc2gqeOXsfr9PXQYXS8Pjd4mbQowY4uZFcbK6+yJkj4gWqsufJcvTXg35uckzhpKvHk4MVuNoA0yXcWygBZy5VNbcA9xhdbn78M/AVk5C1cCaz5VMcebQ+bNpwRBz5Oc/MPsBjzwfTGb2OVHEbwNS5bzu1bCXZYKtzXqnwxqSQ6xtQ7aN3IcTPMbtosQ3Nxxn3gO/pdQG3oMNmy3SYFVmbI76y5lSp+ZIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC48073iwVOWdazrFv9b6YU2oNxiCI2iag97HUy1EIc=;
 b=hJhayCQvacjoufm3H+8O53FkQoE6pMPKIzgs7qwgkNe05hhFf3Bg5lkmj7ltcRApsKnqX2k+dQi2Xtmh06uOoA9gBJ1QaI4Y7SNfo3VL4YafDNt//nc+Rzh/9967cZNDUIsknMCeUaBjViCAKbcNhXKZsthZ/XnD8S0GyR3NV8g=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB2955.eurprd03.prod.outlook.com (2603:10a6:7:5f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Tue, 31 Aug 2021 00:24:15 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 00:24:15 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Thread-Topic: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Thread-Index: AQHXnell+1Hhf81Zx0GCxMqTN3k3h6uMwToA
Date:   Tue, 31 Aug 2021 00:24:15 +0000
Message-ID: <9cb77524-cceb-1662-f40f-5ce5dc26ee2a@bang-olufsen.dk>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org>
In-Reply-To: <20210830214859.403100-6-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63f5e0ee-4b0d-4763-49de-08d96c15aa55
x-ms-traffictypediagnostic: HE1PR03MB2955:
x-microsoft-antispam-prvs: <HE1PR03MB295577FFD466FA73075C57F683CC9@HE1PR03MB2955.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a2X8yvKdCOHSgSFv9/di42ISwDwKNBuB7QTZjckXIVA4rvoJ26fHwL+g15pq8WWYpmFtfBFPPHit5tzNR4zz10x+4R24DR+7VJ+Ibsx/NWgxy9lfqkDxjcZUddA3s0VrWaXlZRzZrUlulJfGbcIh3+q+lGpZ/tecsnKQodCoZTvEIymMq0XrHWNqmLvGPjC9OILKV/GBU1/ystvYQs/5tzrCLB92m8H2chlB4tUVNNUslVkYUS1yn5nVeKSe1XnCrjRkAvroa/3jXbVLyQMcEpGFauX/PmzTv4P9Uw7lkWAOpF7iIyPC8e7bWfGO/VXAGlBkg8J6mjMkuPxiQ/GO/q/Y+EJII5AEaKP50VgwQ1deIOaFWyaBUzThKxEI7gPP0ren/FYVbPicJZa0fC39horYg9gjXMlup30leW3eWO0uTejrdL/GNblwZpmAofQar+3qiIhC43xUGN9AygkRF0F6PXNHWQmxgRKio/s9SUIAz6hm8fd+i981SLnRjhhfk6IIY5Q3lxAvKvKSVqLSDcYovCq1Wojpc6BFNlqTJ3hrV/jwXiLlQ3u6s0DOGCg90luA5UO+9gg9nGlwYJg3jsU3qCepMa5/uix45CegFj83x00qxhdZVe42898a/iZ0TeROQXmYHr1cZ+MLsZORHaTLkTa9nfcCUISGUnwDjOSvGh3exBT1n4xJ+mP5+Dl/mE1226/XTA/V/ouWBilV1GiAkl3twpyzxnHs1I+X98NS5ry16n5DhcHs6SO/Sk1RzO11Vfj6IJN4t4wdRHw4gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39850400004)(366004)(83380400001)(186003)(54906003)(478600001)(66446008)(66556008)(316002)(38070700005)(6486002)(110136005)(66476007)(66946007)(5660300002)(31686004)(8936002)(4326008)(6506007)(8976002)(91956017)(2616005)(85202003)(76116006)(26005)(64756008)(86362001)(122000001)(8676002)(85182001)(53546011)(38100700002)(6512007)(7416002)(2906002)(31696002)(36756003)(66574015)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3hnd3BudWIwUi9MRXV4eUFqQkEzSFVhN09HWWNINDBGb3NaYm1ndVVKdVcv?=
 =?utf-8?B?dVBoRjNkTHBkVmpySnZmYTJBd0JyNlRZVW41cmladi82VjdYYnBVVTBtSkFC?=
 =?utf-8?B?bzBraDVTclh5bWpzU0pKQi9GUGVEN09MSXpkMG1MY0ZEWTVjYTRabGRIOGNx?=
 =?utf-8?B?RmFyS24rOGp6ekFONFp1R3JORjlSQTdtMjV5V0NIZE5qZ2pYeTlPZmttbUow?=
 =?utf-8?B?QnlXYStpSW5keHN0RDNIOWUraGtwcWtNNkZaZTZ0U2ZpRGZWUmxVZm9KUzNV?=
 =?utf-8?B?ZWFPc2oxN0pVMkYwcGk1bDZkamJPWUtMM3M4MWEwS1JPK0ovNVJycWhPUXc0?=
 =?utf-8?B?cHVyNzFXdCtLSXZCMzkzQzlSalRkQWNreWp3TWRsQVBzeXFoZ2ZHUUp3aWor?=
 =?utf-8?B?SHAxL0cxUFpXT0czRmlKb1owOFRDQjNmUlhjWG42aDVLKzl2b1lmQ3dBeldi?=
 =?utf-8?B?aUlGKyttSW5wd0RFSGdOZ2ZhOHJFQzFydFBtK0U4cVJRVGpJU0ttMnB4WGl2?=
 =?utf-8?B?UlNoT05qdlIvU3NxSlp4MzVham1zS0JqVi8vWHNkV21CZTJlbUg4bHpnbUZJ?=
 =?utf-8?B?a3JtM3NJMzV3UWtvVGp1OThTeTZmSDBuKytQdmYvTkU4aGc5Q1JpVTZLSHBY?=
 =?utf-8?B?N0xwR0VOcG9ZUUxRRzhqQmF5WmszV1RlQWJTSHNWMXpLMzRIaEFPeld2cHM4?=
 =?utf-8?B?WVo1SkhhbEN3M2JLM3o3a045R0E0eTRjRlRhUFdYV2ZKeTVEUzFFdkZjR3RF?=
 =?utf-8?B?NS94YmUxbWJIVlVLSWUxUkNYSW05SVIwbWRVazBRc1NaWEpxOElNOVRCUFpJ?=
 =?utf-8?B?SG1ybFA5dU9SS0ZJUUloeWl2YWlYUWo3WmxvRjBpamhWN2hiOEp0NENFL0Fo?=
 =?utf-8?B?TW9qOGgwVlNWQ2kwWW13MVU5dURpTnZSdG9seTdVdVY4WG9RcjRrQU92M2Fj?=
 =?utf-8?B?MTFpWDBzMWxuVVF2MmV0cXZWUFBRQTNtYWhBU3Rlak5jSE1mZG4zdjY3RlZM?=
 =?utf-8?B?aW5CU1Zybk5tR0ZocWJZeWpYSXhTc0pwYnJ5djVSU0dYY2IyWGZqZElhSVZl?=
 =?utf-8?B?TzB4MmN4YXdyTDVNRnNHS0sxRlgyb1hIRG1kcGo0MlA1RG83T0l2SXoyRFR6?=
 =?utf-8?B?WlpjbmtOUWZPd3dCNXZXcVc1c3BqaThXb2hwZVpkbXM4dzVZS2ZNc1l2eVhW?=
 =?utf-8?B?ZEFiWDZJQTh2djd2OFBRaHdxbFRodVl4UkduaXRUUHRJUUJLVlI1OFM0Y0Nz?=
 =?utf-8?B?UndrR0VxRnJiY3VsNXlMbHQwZzY1VEpiSVVhV0dnVCtaU25GaUFEVEJpeFNX?=
 =?utf-8?B?SXEzTE1HbVdCYjdMbXRKYTJHczZPclNpbkhkK2FpK0xhdUJZVkxEKzJEenBG?=
 =?utf-8?B?cng0aGZXRlBNVEo4WXQ0VU9YbkZQenpIR3VzQUhHMlpXTmlmeUVzZXYxeTdF?=
 =?utf-8?B?dWkxUXo4RjFyNEtvcmw4a1hxMGJUcWFWOEJBekNZaG1xaXBISVYxUDd1R1gv?=
 =?utf-8?B?UUxuRS9GbFFPNGZDemYrVGFSck9zQmZVTWpSNG9Va3BZYzUzMjd3UHVwV21M?=
 =?utf-8?B?aFNZSmc3M0pmMnV3TGRjbmlMcllGL1VPQUtreG5xY1dwNmNhbjAzUE1rQ1Rs?=
 =?utf-8?B?S05JWWQzVjZ4bzRUdHJwQVY2QVBtV0lvYXI2a2FqUFluSHViaHoxNzViWi9s?=
 =?utf-8?B?SkMxL1pYYlNiSTMwRjRmbFNOK20wbjA4MXQrRXF0YkxyNWFsSDBnVEduVXUz?=
 =?utf-8?Q?QKWM9gGefdGHZnjEqWjlfT00WpoyxrAEiwDt5Rm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <49828208C2BD264DAE052A1418D4ADAE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f5e0ee-4b0d-4763-49de-08d96c15aa55
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 00:24:15.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aAqnH8M4Kk2eVLxkwZ5lSkY3gAzuRscoTV3sN+MEpWL2/gorlH+/0JiieOQIutjxmgtU6M2nL4+5YWCqpXAmdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMC8yMSAxMTo0OCBQTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gVGhpcyBpbXBsZW1l
bnRzIGZhc3QgYWdpbmcgcGVyLXBvcnQgdXNpbmcgdGhlIHNwZWNpYWwgInNlY3VyaXR5Ig0KPiBy
ZWdpc3Rlciwgd2hpY2ggd2lsbCBmbHVzaCBhbnkgTDIgTFVUcyBvbiBhIHBvcnQuDQo+IA0KPiBT
dWdnZXN0ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+IENjOiBB
bHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+IENjOiBNYXVyaSBTYW5kYmVy
ZyA8c2FuZGJlcmdAbWFpbGZlbmNlLmNvbT4NCj4gQ2M6IERFTkcgUWluZ2ZhbmcgPGRxZmV4dEBn
bWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpA
bGluYXJvLm9yZz4NCj4gLS0tDQoNClZsYWRpbWlyIGlzIHByb2JhYmx5IHJpZ2h0IGFib3V0ICJh
bnkiIGJlaW5nIGEgYml0IG1pc2xlYWRpbmcsIGJ1dCBJIA0KdGhpbmsgdGhpcyBpcyBkb2luZyB0
aGUgcmlnaHQgdGhpbmcuIEZpeGVkIExVVCBlbnRyaWVzIChub25leGlzdGVudCBhdCANCnRoZSBt
b21lbnQpIHNob3VsZCBub3QgYmUgYWZmZWN0ZWQgYnkgdGhlIGFnaW5nIHByb2Nlc3MuDQoNClJl
dmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gQ2hh
bmdlTG9nIHYxLT52MjoNCj4gLSBOZXcgcGF0Y2ggc3VnZ2VzdGVkIGJ5IFZsYWRpbWlyLg0KPiAt
LS0NCj4gICBkcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMgfCAxNCArKysrKysrKysrKysrKw0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5j
DQo+IGluZGV4IDRjYjBlMzM2Y2U2Yi4uNTQ4MjgyMTE5Y2M0IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZy
Yi5jDQo+IEBAIC0xMjE5LDYgKzEyMTksMTkgQEAgcnRsODM2NnJiX3BvcnRfYnJpZGdlX2ZsYWdz
KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICAgCXJldHVybiAwOw0KPiAgIH0N
Cj4gICANCj4gK3N0YXRpYyB2b2lkDQo+ICtydGw4MzY2cmJfcG9ydF9mYXN0X2FnZShzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0KQ0KPiArew0KPiArCXN0cnVjdCByZWFsdGVrX3NtaSAq
c21pID0gZHMtPnByaXY7DQo+ICsNCj4gKwkvKiBUaGlzIHdpbGwgYWdlIG91dCBhbnkgTDIgZW50
cmllcyAqLw0KPiArCXJlZ21hcF91cGRhdGVfYml0cyhzbWktPm1hcCwgUlRMODM2NlJCX1NFQ1VS
SVRZX0NUUkwsDQo+ICsJCQkgICBCSVQocG9ydCksIEJJVChwb3J0KSk7DQo+ICsJLyogUmVzdG9y
ZSB0aGUgbm9ybWFsIHN0YXRlIG9mIHRoaW5ncyAqLw0KPiArCXJlZ21hcF91cGRhdGVfYml0cyhz
bWktPm1hcCwgUlRMODM2NlJCX1NFQ1VSSVRZX0NUUkwsDQo+ICsJCQkgICBCSVQocG9ydCksIDAp
Ow0KPiArfQ0KPiArDQo+ICAgc3RhdGljIGludA0KPiAgIHJ0bDgzNjZyYl9wb3J0X2JyaWRnZV9q
b2luKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICAgCQkJICAgc3RydWN0IG5l
dF9kZXZpY2UgKmJyaWRnZSkNCj4gQEAgLTE2NzMsNiArMTY4Niw3IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2NnJiX3N3aXRjaF9vcHMgPSB7DQo+ICAgCS5wb3J0
X2Rpc2FibGUgPSBydGw4MzY2cmJfcG9ydF9kaXNhYmxlLA0KPiAgIAkucG9ydF9wcmVfYnJpZGdl
X2ZsYWdzID0gcnRsODM2NnJiX3BvcnRfcHJlX2JyaWRnZV9mbGFncywNCj4gICAJLnBvcnRfYnJp
ZGdlX2ZsYWdzID0gcnRsODM2NnJiX3BvcnRfYnJpZGdlX2ZsYWdzLA0KPiArCS5wb3J0X2Zhc3Rf
YWdlID0gcnRsODM2NnJiX3BvcnRfZmFzdF9hZ2UsDQo+ICAgCS5wb3J0X2NoYW5nZV9tdHUgPSBy
dGw4MzY2cmJfY2hhbmdlX210dSwNCj4gICAJLnBvcnRfbWF4X210dSA9IHJ0bDgzNjZyYl9tYXhf
bXR1LA0KPiAgIH07DQo+IA0K
