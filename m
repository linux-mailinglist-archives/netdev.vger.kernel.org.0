Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950E13F4263
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhHVXiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:38:17 -0400
Received: from mail-am6eur05on2102.outbound.protection.outlook.com ([40.107.22.102]:23187
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229969AbhHVXiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDaKre6ExfpH3FzmiVx/kqkH5zGGtYfKcoLfezHKRGRhWCTAfcwuFqTjYPFIDfJZAtH/doiUsYnF2GE6LnegkMvAGS1VvMaStcQSBMqM9Fo+nQ0rkWtMeb1XOgv278kucfQwkfHO1MN8uqr+0GpV83W+QkNW1VcpVHLkWHGAEAe7RoW/9mzjSv7OktoMkm1KrhChNLdaIi/D4uCQXJILouAwlxPl8ntA/wTBRb3qszvfe16Bf5wmTPokQLwLdgv6y+NKddlxmmSGSzwJNeMpxf6XKWF7d7P6DZ5Im3+SpMf8VQc25tB+wPs3y8R24gR5ypZ2Ax7qrycbz5tT4S0Wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hvr+Su/KpNlOJZ25hVpkgR9+fhA3YeA/KHhLbe1fL4=;
 b=CIqtTQ6xmyaX2vbAUNFddxbQla9jo6fYvGsm8F4GJYQXor2EbCoaYE3L233AvInPS9gUmK0XATQSdp5CCYqMFpdrV8IvlVqzNYRfryZjaBb1gEToosQdq8UWQ4izc9HouJARtWfueAUfEgFiABqHv2pPWQq6aLL4qdiJO3c8cp/mrbH6X73vW29q6wZN+VfoanycYJjy+ph4GAZDe/kObnwziWhrQGqIIS/R/USrhdMxKADSGfm9aaRmShi6k38Gl8/HFKcNlPr0PFzwsgVI0zpbfuW/d96onkNGPyP7mOBV2+AiHKMkoVpiEVembqD5Kz526rN2SUKWB+nqk6gmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hvr+Su/KpNlOJZ25hVpkgR9+fhA3YeA/KHhLbe1fL4=;
 b=WTWkSXjv6gqivFd8Ip3IxZBKP/bDOZhP5r7eCg4590WzadQnj0OtOfPjeCur5T39gjeXGNYsYD6jzE+vHoH6nwJIhjAHtop3MQHfTPEq33u16iNyFWFDd5C8CCIeUnvHO41SOj2kcUGlnH5oc7jpEBB2JlG8i1mSoN/Aes6nJ1M=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2601.eurprd03.prod.outlook.com (2603:10a6:3:ec::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Sun, 22 Aug 2021 23:37:28 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 23:37:28 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Topic: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Thread-Index: AQHXl4yAoQircf8Jw0+inLvWs8TmmauAFquAgAAQRACAAAP/AIAAA02A
Date:   Sun, 22 Aug 2021 23:37:28 +0000
Message-ID: <0606e849-5a4e-08c9-fcd1-d4661c10a51c@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <20210822221307.mh4bggohdvx2yehy@skbuf>
 <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
 <20210822232538.pkjsbipmddle5bdt@skbuf>
In-Reply-To: <20210822232538.pkjsbipmddle5bdt@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2feefe0-dfcc-426d-678c-08d965c5cd9d
x-ms-traffictypediagnostic: HE1PR0302MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB26011D37F7EC465BE772F0DC83C39@HE1PR0302MB2601.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +CyDODXdda05FACiflStXSwLpN8L2gi7LN3DIB6hS9pVlwHFTsRbhLse4Bpn30xHxhY5QjOEhWB+pQPiFSnmIOCx9Wj+G7sDcE7D8NmX5a+8yPigJMDBzzCBTZ4vhfYGlv9R7jmQkFbLhAv2HRgebKbl+/MOUiWMhUThQADMvDocKoYeWlIAaSc3PW0/4XDDUKS/tCb+K9t+BpUV3idpJcUnZg/bVZhFyNefI/2Fzs0Jtwtcc9yv5rAFHuE3mhpjWuGeugq8dp8jDpuEzY3et9fZrhdgkFoj9AhY0v0XeD1jIPCyaHu7lIph/jtS9q0Oc/HEAJdEbzLlvW0y4B/qLnxZ8R9cGHJU0HXjsbDZv2L+wz5LMxe01H+9qjlEyLTQj1Iy+DCW8AsHkM8OyphN+/bJZxBI5ZTmUloV9AwDORgiIPraFFrabe120P91STGsy8pONvSIyYgemuP/iDV3Swh78KZq61NqpG0SMuc1IjRt+V3qOz+OJDTBjblDTKI6ysoFshzcdm7I7EN2ixzJmJ1L3XZegM7Mmr+1vnae63UF53RVEtLf8eziB/c/xftXuZANLE1pUVVh/5bmjXCEqBJx2WPi2q7bW8RLTF9NgVyx203CaMsnVi6r/tac1j8I5IooOA0whql0FzmdGtZSqVXohjcRPJ6Sg8ObKyFbNBL0yshRg0d0/6AC52Vh1bBQUvk/uHq8dUzTz35MZG9p+7oln0vflas/O0u2MuaB3aaDK/GRej1Jf5xZ4+TI58nleF1kmW6zD0nZP4HEOGTBjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39840400004)(38070700005)(316002)(54906003)(26005)(85182001)(478600001)(8936002)(31696002)(8976002)(31686004)(6486002)(86362001)(53546011)(2616005)(36756003)(6506007)(71200400001)(66556008)(186003)(5660300002)(66446008)(6916009)(7416002)(8676002)(4326008)(66476007)(91956017)(76116006)(6512007)(66946007)(64756008)(66574015)(122000001)(38100700002)(83380400001)(2906002)(85202003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFNsalh2bkdRV3QrNUtjdEN5cDJpV2xwdlBadml4OFZ5cmhDeTNrOVhrRFhy?=
 =?utf-8?B?U25IVXEyT3dEMjQrczZ3NC81MVNWUk00UXg1VjIvM1NXbnJJbFQ5NFNBK2RG?=
 =?utf-8?B?c1V1SStBYkRMRjZSaEtiWVVUVlVCdmtaeXNzWldKV3hUdFhqYnpQTTRPd1ht?=
 =?utf-8?B?MkdQYUtLZkFsaW9LRUtkbk1UeTVDbHZ1czJJcGs5L0ZPUnVZOEFuRnQrcVNT?=
 =?utf-8?B?Y0kwM3V5V1lJQlFLbVhXTERDamVyajZnVnpjcUs3VUIxQTZxMHVnU2dWYXVr?=
 =?utf-8?B?Qjk3ejA5M05rbG51TnNTdEhsbTlBYU9QQXpvQmRESUpVMWlNU0FPbjNCR2N2?=
 =?utf-8?B?OXdDc0dqV1NNSUNQZFZGdVNzcUczV2ZCazg4dkcyZUUyMTIrMGsyaWJpM0pL?=
 =?utf-8?B?VHZRTmF1eWlPdExQVDV4WU16Y0hTd0praTlma3BMaGZMWVdrZGZ0VmZjRUxq?=
 =?utf-8?B?SFVWQTcyYi9xdE50OXdRdXpmaERtcHBlVUxDbmZGTjh0ZkdUd1cvZjR0bkdj?=
 =?utf-8?B?cENZYnNXUkRENU1oOHd3MytEYm41ZWx1WDc1cjMybmVvQ25LRXU0QmYzN0FK?=
 =?utf-8?B?TmZnMWF2c0VMS2ZzelJ2N3k5c1JnWXdVM1ZsNklQWnVxQkRjS0dkeGxveTlH?=
 =?utf-8?B?TjNVSGYwVXV2SVNSVHJqd3VCMENKR1F1bmk3d1ZoaFVtcklzaEpWK294WVV4?=
 =?utf-8?B?Q0pnTTZlSFdWc1lJSCtQZ0tldE9vRGNLeldxeExQQWYyQ3BGMWE2SVFlQVJk?=
 =?utf-8?B?c1dHQ0ZIdnk5Kzg0T2hJT0MvSk51Z251L2NZK2MrdllBZ2pKUXdUL1NoRmJz?=
 =?utf-8?B?QlRPWUJNSnhoM0gzZXdOOXNhanV0cmtBTDAyTFNhR1V1blBFMkNuNEZZK0pJ?=
 =?utf-8?B?ZUxzS0F0cDdLRXp5cDl5RmptczFmekhyWGplNFRFWHk5WkhzcnhLb3U1QllY?=
 =?utf-8?B?bTFxYWYySVNNRWw0ai80MnFuREpXSlFRUjJnZ1VrNllqYjlsZWFNT281KzZz?=
 =?utf-8?B?WnIvREprTUhCY3FxbmQ4MGZsRi9YUWdlcW9mYnV3amx2VkdsZHNBbEV5VG9P?=
 =?utf-8?B?OGdTTENydGM5RzkrTWZIaFZmVkNXa1JQR0IrdmhCT0dRb05rT2pGR2V3eXU0?=
 =?utf-8?B?QVpwbFVzakYxbmJHSFZteEVlME1wYi9XMmdTczVMTW9kVGlLdmg2VVpJTnAz?=
 =?utf-8?B?b0EyekhjYWJXUmU0a1RHdE9oc01SY25GUERGR0Q5eWdVNWkxbitGN01GVWFQ?=
 =?utf-8?B?NVhucUl3VFJRTnhUWTZra2VwQU81UmthUnNGajdlbENRK21yS2V2cUErODBt?=
 =?utf-8?B?Z2ROVU9Va1FrM25iaXErczF1cEkzSzIwOXBORWZXdG9QODVHdVNaTVJNTEZD?=
 =?utf-8?B?OHhXTFdvaU1jRGhBcmdoNjlnTjlmM0U1WU1ucGIvN20wTnJ3MTRvcjgza1Fx?=
 =?utf-8?B?SVl4ZkJMbUZsc2l5S1BGRW8za3d5V3JkaXJ1SEkzZXc4Q0htbDFWeEorclZJ?=
 =?utf-8?B?TlkzelhuTVpkTXF6dHg3UTlFaE1Lc1Via29VQTZjWlRmSnlQL2ZRQVhxb25V?=
 =?utf-8?B?ODhsMlM0bEx2VG5nT0g1Tk9vZ1ZVYnZnbEtQQWtzc2hTMmhpQnVETlk0cE1O?=
 =?utf-8?B?VlhNdWtrdmZITitaQ0NmWXBkaXFoRkxUa0N3TWwwa0xuZ0E5dStwaW1MYTNE?=
 =?utf-8?B?Q2hrcDlTM0JYM2RiVjBabVNTOFRiUXIySk1vc3M4VEVmWjNZVlplOGRjTm5N?=
 =?utf-8?Q?XWSUKvfrQQ31olm9FfRGi9a+DPBuKMITH57K1t2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D02F5A32DB1D45B4E257AF9B0BCA3F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2feefe0-dfcc-426d-678c-08d965c5cd9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 23:37:28.1044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zcez6lZPQzjpURvAqpxe3auEcGUgC50fYPgaUkBo/nd+ZpvZVtQ18eKCE+rxILEthpw/urKPf/rlEkFSmHDcVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2601
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIDgvMjMvMjEgMToyNSBBTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3Rl
Og0KPiBPbiBTdW4sIEF1ZyAyMiwgMjAyMSBhdCAxMToxMToyMVBNICswMDAwLCBBbHZpbiDFoGlw
cmFnYSB3cm90ZToNCj4+Pj4gKyAqICAgIEtFRVAgICAgICAgfCBwcmVzZXJ2ZSBwYWNrZXQgVkxB
TiB0YWcgZm9ybWF0DQo+Pj4NCj4+PiBXaGF0IGRvZXMgaXQgbWVhbiB0byBwcmVzZXJ2ZSBwYWNr
ZXQgVkxBTiB0YWcgZm9ybWF0PyBUcnlpbmcgdG8NCj4+PiB1bmRlcnN0YW5kIGlmIHRoZSBzYW5l
IHRoaW5nIGlzIHRvIGNsZWFyIG9yIHNldCB0aGlzIGJpdC4gRG9lcyBpdCBtZWFuDQo+Pj4gdG8g
c3RyaXAgdGhlIFZMQU4gdGFnIG9uIGVncmVzcyBpZiB0aGUgVkxBTiBpcyBjb25maWd1cmVkIGFz
DQo+Pj4gZWdyZXNzLXVudGFnZ2VkIG9uIHRoZSBwb3J0Pw0KPj4NCj4+IEkgc3VwcG9zZSB5b3Ug
bWVhbiAiRG9lcyBpdCBtZWFuIF9kb24ndF8gc3RyaXAgdGhlIFZMQU4gdGFnIG9uIGVncmVzcy4u
LiI/DQo+Pg0KPj4gSSdtIG5vdCBzdXJlIHdoYXQgdGhlIHNlbWFudGljcyBvZiB0aGlzIEtFRVAg
YXJlLiBXaGVuIEkgY29uZmlndXJlIHRoZQ0KPj4gcG9ydHMgdG8gYmUgZWdyZXNzLXVudGFnZ2Vk
LCB0aGUgcGFja2V0cyBsZWF2ZSB0aGUgcG9ydCB1bnRhZ2dlZC4gV2hlbiBJDQo+PiBjb25maWd1
cmUgdGhlIHBvcnRzIHdpdGhvdXQgZWdyZXNzLXVudGFnZ2VkLCB0aGUgcGFja2V0cyBsZWF2ZSB0
aGUgcG9ydA0KPj4gdGFnZ2VkLiBUaGlzIGlzIHdpdGggdGhlIGNvZGUgYXMgeW91IHNlZSBpdCAt
IHNvIEtFRVA9MC4gSWYgSSBhbSB0bw0KPj4gaGF6YXJkIGEgZ3Vlc3MsIG1heWJlIGl0IG92ZXJy
aWRlcyBhbnkgcG9ydC1iYXNlZCBlZ3Jlc3MtdW50YWdnZWQNCj4+IHNldHRpbmcuIEkgd2lsbCBy
dW4gc29tZSB0ZXN0cyB0b21vcnJvdy4NCj4gDQo+IE9rLCB0aGVuIGl0IG1ha2VzIHNlbnNlIHRv
IHNldCBLRUVQPTAgYW5kIG5vdCBvdmVycmlkZSB0aGUgcG9ydCBzZXR0aW5ncy4NCg0KT0ssIGds
YWQgeW91IGFncmVlLg0KDQo+IA0KPj4+DQo+Pj4+ICsJKnAgPSBodG9ucyh+KDEgPDwgMTUpICYg
QklUKGRwLT5pbmRleCkpOw0KPj4+DQo+Pj4gSSBhbSBkZWVwbHkgY29uZnVzZWQgYnkgdGhpcyBs
aW5lLg0KPj4+DQo+Pj4gfigxIDw8IDE1KSBpcyBHRU5NQVNLKDE0LCAwKQ0KPj4+IEJ5IEFORC1p
bmcgaXQgd2l0aCBCSVQoZHAtPmluZGV4KSwgd2hhdCBkbyB5b3UgZ2Fpbj8NCj4+DQo+PiBEZWxp
YmVyYXRlIHZlcmJvc2l0eSBmb3IgdGhlIGh1bWFuIHdobyB3YXMgZW5nYWdlZCBpbiB3cml0aW5n
IHRoZQ0KPj4gdGFnZ2luZyBkcml2ZXIgdG8gYmVnaW4gd2l0aCwgYnV0IG9idmlvdXNseSBzdHVw
aWQuIEknbGwgcmVtb3ZlLg0KPiANCj4gSSB3b3VsZG4ndCBzYXkgInN0dXBpZCIsIGJ1dCBpdCdz
IG5vbi1vYnZpb3VzLCBoYXJkIHRvIHJlYWQgYW5kIGF0IHRoZSBzYW1lIHRpbWUgcG9pbnRsZXNz
Lg0KPiBJIGhhZCB0byB0YWtlIG91dCB0aGUgYWJhY3VzIHRvIHNlZSBpZiBJJ20gbWlzc2luZyBz
b21ldGhpbmcuDQo+IA0KPj4+PiArCS8qIElnbm9yZSBGSURfRU4sIEZJRCwgUFJJX0VOLCBQUkks
IEtFRVAsIExFQVJOX0RJUyAqLw0KPj4+PiArCXAgPSAoX19iZTE2ICopKHRhZyArIDQpOw0KPj4+
DQo+Pj4gRGVsZXRlIHRoZW4/DQo+Pg0KPj4gRGVsaWJlcmF0ZSB2ZXJib3NpdHkgYWdhaW4gLSBi
dXQgSSBmaWd1cmUgYW55IGhhbGYtZGVjZW50IGNvbXBpbGVyIHdpbGwNCj4+IG9wdGltaXplIHRo
aXMgb3V0IHRvIGJlZ2luIHdpdGguIEkgdGhvdWdodCBpdCBzZXJ2ZXMgYXMgYSBwZXJmZWN0bHkg
ZmluZQ0KPj4gImFkZCBzdHVmZiBoZXJlIiBub3RpY2UgdG9nZXRoZXIgd2l0aCB0aGUgY29tbWVu
dCwgYnV0IEkgY2FuIHJlbW92ZSBpbiB2Mi4NCj4gDQo+IEtlZXBpbmcganVzdCB0aGUgY29tbWVu
dCBpcyBmaW5lLCBidXQgaGF2aW5nIHRoZSBsaW5lIG9mIGNvZGUgaXMgcHJldHR5DQo+IHBvaW50
bGVzcy4gSnVzdCBsaWtlIGFueSBoYWxmLWRlY2VudCBjb21waWxlciB3aWxsIG9wdGltaXplIGl0
IG91dCwgYW55DQo+IGRldmVsb3BlciB3aXRoIGhhbGYgYSBicmFpbiB3aWxsIGZpZ3VyZSBvdXQg
d2hhdCB0byBkbyB0byBwYXJzZQ0KPiBGSURfRU4gLi4uIExFQVJOX0RJUyB0aGFua3MgdG8gdGhl
IG90aGVyIGNvbW1lbnRzLg0KDQpQb2ludCB3ZWxsIG1hZGUgOi0pIEknbGwgY2xlYW4gdXAgaW4g
djIuIFRoYW5rcyENCg0KPiANCj4+Pg0KPj4+PiArDQo+Pj4+ICsJLyogSWdub3JlIEFMTE9XOyBw
YXJzZSBUWCAoc3dpdGNoLT5DUFUpICovDQo+Pj4+ICsJcCA9IChfX2JlMTYgKikodGFnICsgNik7
DQo+Pj4+ICsJdG1wID0gbnRvaHMoKnApOw0KPj4+PiArCXBvcnQgPSB0bXAgJiAweGY7IC8qIFBv
cnQgbnVtYmVyIGlzIHRoZSBMU0IgNCBiaXRzICovDQo+Pj4+ICsNCj4+Pj4gKwlza2ItPmRldiA9
IGRzYV9tYXN0ZXJfZmluZF9zbGF2ZShkZXYsIDAsIHBvcnQpOw0KPj4+PiArCWlmICghc2tiLT5k
ZXYpIHsNCj4+Pj4gKwkJbmV0ZGV2X2RiZyhkZXYsICJjb3VsZCBub3QgZmluZCBzbGF2ZSBmb3Ig
cG9ydCAlZFxuIiwgcG9ydCk7DQo+Pj4+ICsJCXJldHVybiBOVUxMOw0KPj4+PiArCX0NCj4+Pj4g
Kw0KPj4+PiArCS8qIFJlbW92ZSB0YWcgYW5kIHJlY2FsY3VsYXRlIGNoZWNrc3VtICovDQo+Pj4+
ICsJc2tiX3B1bGxfcmNzdW0oc2tiLCBSVEw4XzRfVEFHX0xFTik7DQo+Pj4+ICsNCj4+Pj4gKwlk
c2Ffc3RyaXBfZXR5cGVfaGVhZGVyKHNrYiwgUlRMOF80X1RBR19MRU4pOw0KPj4+PiArDQo+Pj4+
ICsJc2tiLT5vZmZsb2FkX2Z3ZF9tYXJrID0gMTsNCj4+Pg0KPj4+IEF0IHRoZSB2ZXJ5IGxlYXN0
LCBwbGVhc2UgdXNlDQo+Pj4NCj4+PiAJZHNhX2RlZmF1bHRfb2ZmbG9hZF9md2RfbWFyayhza2Ip
Ow0KPj4+DQo+Pj4gd2hpY2ggZG9lcyB0aGUgcmlnaHQgdGhpbmcgd2hlbiB0aGUgcG9ydCBpcyBu
b3Qgb2ZmbG9hZGluZyB0aGUgYnJpZGdlLg0KPj4NCj4+IFN1cmUuIENhbiB5b3UgZWxhYm9yYXRl
IG9uIHdoYXQgeW91IG1lYW4gYnkgImF0IHRoZSB2ZXJ5IGxlYXN0Ij8gQ2FuIGl0DQo+PiBiZSBp
bXByb3ZlZCBldmVuIGZ1cnRoZXI/DQo+IA0KPiBUaGUgZWxhYm9yYXRpb24gaXMgcmlnaHQgYmVs
b3cuIHNrYi0+b2ZmbG9hZF9md2RfbWFyayBzaG91bGQgYmUgc2V0IHRvDQo+IHplcm8gZm9yIHBh
Y2tldHMgdGhhdCBoYXZlIGJlZW4gZm9yd2FyZGVkIG9ubHkgdG8gdGhlIGhvc3QgKGxpa2UgcGFj
a2V0cw0KPiB0aGF0IGhhdmUgaGl0IGEgdHJhcHBpbmcgcnVsZSkuIEkgZ3Vlc3MgdGhlIHN3aXRj
aCB3aWxsIGRlbm90ZSB0aGlzDQo+IHBpZWNlIG9mIGluZm8gdGhyb3VnaCB0aGUgUkVBU09OIGNv
ZGUuDQoNClllcywgSSB0aGluayBpdCB3aWxsIGJlIGNvbW11bmljYXRlZCBpbiBSRUFTT04gdG9v
LiBJIGhhdmVuJ3QgZ290dGVuIHRvIA0KZGVjaXBoZXJpbmcgdGhlIGNvbnRlbnRzIG9mIHRoaXMg
ZmllbGQgc2luY2UgaXQgaGFzIG5vdCBiZWVuIG5lZWRlZCBzbyANCmZhcjogdGhlIHBvcnRzIGFy
ZSBmdWxseSBpc29sYXRlZCBhbmQgYWxsIGJyaWRnaW5nIGlzIGRvbmUgaW4gc29mdHdhcmUuDQoN
Cj4gDQo+IFRoaXMgYWxsb3dzIHRoZSBzb2Z0d2FyZSBicmlkZ2UgZGF0YSBwYXRoIHRvIGtub3cg
dG8gbm90IGZsb29kIHBhY2tldHMNCj4gdGhhdCBoYXZlIGFscmVhZHkgYmVlbiBmbG9vZGVkIGJ5
IHRoZSBzd2l0Y2ggaW4gaXRzIGhhcmR3YXJlIGRhdGEgcGF0aC4NCj4gDQo+IENvbnRyb2wgcGFj
a2V0cyBjYW4gc3RpbGwgYmUgcmUtZm9yd2FyZGVkIGJ5IHRoZSBzb2Z0d2FyZSBkYXRhIHBhdGgs
DQo+IGV2ZW4gaWYgdGhlIHN3aXRjaCBoYXMgdHJhcHBlZC9ub3QgZm9yd2FyZGVkIHRoZW0sIHRo
cm91Z2ggdGhlDQo+ICJncm91cF9md2RfbWFzayIgb3B0aW9uIGluICJtYW4gaXAtbGluayIpLg0K
DQpTaW5jZSB0aGUgZHJpdmVyIGRvZXNuJ3Qgc3VwcG9ydCBhbnkgb2ZmbG9hZGluZyByaWdodCBu
b3cgKHBvcnRzIGFyZSANCmlzb2xhdGVkKSwgd291bGQgeW91IGJlIE9LIHdpdGggbWUganVzdCBz
ZXR0aW5nIA0KZHNhX2RlZmF1bHRfb2ZmbG9hZF9md2RfbWFyayhza2IpIGZvciBub3c/IEkgd2ls
bCByZXZpc2l0IHRoaXMgaW4gdGhlIA0KZnV0dXJlIHdoZW4gSSBoYXZlIG1vcmUgdGltZSBhdCB3
b3JrIHRvIGltcGxlbWVudCBzb21lIG9mIHRoZSBvZmZsb2FkaW5nIA0KZmVhdHVyZXMsIGJ1dCBp
dCdzIG5vdCBzb21ldGhpbmcgSSBjYW4gY29tbWl0IHRvIGluIHRoZSBuZWFyIGZ1dHVyZS4NCg0K
PiANCj4+Pg0KPj4+IEFsc28gdGVsbCB1cyBtb3JlIGFib3V0IFJFQVNPTiBhbmQgQUxMT1cuIElz
IHRoZXJlIGEgYml0IGluIHRoZSBSWCB0YWcNCj4+PiB3aGljaCBkZW5vdGVzIHRoYXQgdGhlIHBh
Y2tldCB3YXMgZm9yd2FyZGVkIG9ubHkgdG8gdGhlIGhvc3Q/DQo+Pg0KPj4gQXMgSSB3cm90ZSB0
byBBbmRyZXcsIFJFQVNPTiBpcyB1bmRvY3VtZW50ZWQgYW5kIEkgaGF2ZSBub3QgaW52ZXN0aWdh
dGVkDQo+PiB0aGlzIGZpZWxkIHlldC4gSSBoYXZlIGFkZHJlc3NlZCBBTExPVyB1cHN0YWlycyBp
biB0aGlzIGVtYWlsLCBidXQNCj4+IHN1ZmZpY2UgdG8gc2F5IEkgYW0gbm90IHN1cmUuDQo+IA0K
PiBPbiB4bWl0LCB5b3UgaGF2ZS4gT24gcmN2IChzd2l0Y2gtPkNQVSksIEkgYW0gbm90IHN1cmUg
d2hldGhlciB0aGUNCj4gc3dpdGNoIHdpbGwgZXZlciBzZXQgQUxMT1cgdG8gMSwgYW5kIHdoYXQg
aXMgdGhlIG1lYW5pbmcgb2YgdGhhdC4NCg0KSSB0aGluayBBTExPVyBpcyBvbmx5IHJlbGV2YW50
IG9uIHhtaXQgKENQVS0+c3dpdGNoKS4gSSBjYW4gbWFrZSBpdCBtb3JlIA0KY2xlYXIgaW4gdGhl
IGNvbW1lbnQgaW4gdjIu
