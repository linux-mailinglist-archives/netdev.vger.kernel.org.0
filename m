Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80AF3F4275
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhHVX4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:56:54 -0400
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:43617
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233168AbhHVX4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:56:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrnDXj6a5Pxzi6ts8Z6XfLcPvUbGPuCwhr6PLFGDLd3t/IxRGP5P3o4N3jpPgoVfOh3HWD+GCsIcJznINagnoMRRy4/TR2neIY1Sb+rj251vLjQn3l/O6Ib5d1r7/44urLOd3HJ4zx9yQmF3r5/i/vVaVKfsli/LqJ5lNJ2s0OOmEsbSdtARvQ1yN1o8dm6ZTP05khnirrzdGxi+dA9YpZz9xoZmLDSf/YJtqd4HB5JnukWQkEwFQRrOSmTr1ORQtpCSyZHdIAVqUhiiu3mlkDFkqj0q+D5UYb0p8QCXtyg2bSsPKQt9I94WxYe1lKCxlVM6YmSuu+suv1sU7lOaAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=219aaw1Yp4Nx+Vw+J/uY+aLmhRKvZZddZx50vxBK0Ak=;
 b=FjfdNIXW0i+/utXPY0hdUr14VHF99nJ4fbbIw2ma5YpRA5UTVy5KBTG9OqH/uXYC6S6eDQCFaLE0B0lExH78LWVaPu31+yX6aI3XPI2GBJLcpqHy7lJ6+WucKrly8O/Ofs2wQxvlTp5Vj2hXBQBNIzcljzx/DgQvLZuE+XflgKCkeC7AtjVmo7/9naPS/p8midxlx0l8MQdfzSi8l6vyMgRX1JbPUktqWZKpPX3hBlOjSqeA898ey4vMPK8Y4KJWGV7SKDHA/k8dQT6D8tkIk0hyzC8I29hICzGC1hjOlqsjLSzhHuvcJjBafmp12gOl/M10gDE+wj21dTI49xpXtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=219aaw1Yp4Nx+Vw+J/uY+aLmhRKvZZddZx50vxBK0Ak=;
 b=FuP5SJheFwrb03hIcq/sOMPfjV5T3RPX/VGcsl6Tbvr777hPg9QKfMyvAgj7hCACm1qgeskBAiCLIFgPhCdNsOLemu8y4Y6OSf23fq4XyKJIs5LhjdhrpK/ZnPKMNZ8HeeiS/GeNmignrJ4maOe8XvlFw9a07CRoRQ2JE/GEWLQ=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2601.eurprd03.prod.outlook.com (2603:10a6:3:ec::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Sun, 22 Aug 2021 23:56:04 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 23:56:04 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXl4yCe3G+ndzNv0qmlobhUV7pTauAIHCAgAAS/oA=
Date:   Sun, 22 Aug 2021 23:56:04 +0000
Message-ID: <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
In-Reply-To: <20210822224805.p4ifpynog2jvx3il@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e7a16ea-e95e-4e6c-66d7-08d965c866f8
x-ms-traffictypediagnostic: HE1PR0302MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB2601F4FC6CE23EFB0A3849DE83C39@HE1PR0302MB2601.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 73POKqlysLlCkUVDPaKrS2zqMgwm1dSNSGlnNxZ2MGvapSICaf001ZFigiRK39LKI1lQ1944c1G1++B+WpGYRPj4DHgXzNqJgw3XUfPbXCbGK8ijBxrbk0F9zW8yIa/gVq/QF9NyhrMsL+9wjCW9xQKsh/UjfiWjbuXtjaSdiig/091Sw66Z1kacEZl9KBPuHpdafJMldnScxQ+D5LeOjTHB1gThGtyeMXhtUZHp2sZuKaHG/hG5CPQ4w8K/Bd96Q+g+1iujQBh8ZZJFdmWH+gP5m2glB/3wNVwR6mQCsGNYBsMwVuG3rFGvNYPRrnrw2655MOZhtuFKuE/HtfBF47kY9YEDV4OyecyeT8VREXwyst735WexUek7ROnOICCheNSwJo34+SiJjnIeqaY41T/qfVI5gAr5NT+MXkXjpOZP63ETW0dvR/JvR9pXtoBzxbOaqiW9ZF3lkd9jxDyunDIjAinvHhPixUT4RvScpD/c5MLz4C9ME9ruGo3GP9gmAwLppkPF0t8rhOyzz0n1R40UQXXZuKai89hlM8ZhnUxuifjk5dfFeRFjT0/bsbrS5pXQLvBhRLKQxN3LVBlQ8tNZKpis/ww1/Qf6ijY9IYW5X3gbSHAwLJb0rGf7cSXYwaPIc2UV9qFxYNzpYG9Yj3ksmz/xhlCgbAfgtoaA0u4WalOZiUpK2GDHp30ylOVvLdC69Ftx7PyF0lkd+0vg4tQfiiVHLJIgZ5qDuJaYNxs/aw9PSqBI17JlLG4NwAcCG24f09sd8Ima1J6CB2J27g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(38070700005)(316002)(54906003)(26005)(110136005)(85182001)(478600001)(8936002)(31696002)(8976002)(31686004)(6486002)(86362001)(53546011)(36756003)(2616005)(6506007)(71200400001)(66556008)(186003)(5660300002)(66446008)(7416002)(8676002)(4326008)(91956017)(76116006)(6512007)(66476007)(66946007)(64756008)(122000001)(38100700002)(83380400001)(66574015)(2906002)(85202003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V24wT2JEMkRRbG41cTA5TVFPRmpUR01LcDAvR3Z2TjAzRWpDNlJjaHlzWjJK?=
 =?utf-8?B?Mkl1N1VDL09iRkdxY3pUTXZWd2t0RWNBVXZpa3ZOVXhmZXBrajNrS3RmYTBS?=
 =?utf-8?B?c2dEZng3eFR4Zkk3ajIwS2R4ZmJkM0tZRSs4dVlkQU9rWHZFbmhqa2VPTnR5?=
 =?utf-8?B?RmZLQ3FpZC9kUFZBcm9wRFNCZm5MSVdvcW5ydDk5bldtd1JRdGpGZ0dwcGk0?=
 =?utf-8?B?aUJXUnFZVzltTDhYVzU4czFieWdueWEyWk5BMFpOTnhGeE5LSytWbzZ1RUYw?=
 =?utf-8?B?SHIvRnovTEljYnJWVmhRSkU3ZVMzTW0rc3YvaXhLUEdnc3lqUHVjTnVtWTE2?=
 =?utf-8?B?TFVNYVdITGo0b2w4c1QyalBsOEhZTWtLOEdVdlFlaWpHbzZYczhpWG5HaUlS?=
 =?utf-8?B?NlRlZGswa2xUTDZRUHB1NW5CNldwSjJqdlNMR1lndUU4OFB3L0FhalhVLzFq?=
 =?utf-8?B?YzV4Skk3aFo5MG1qZXkyMmdzN0ZsRnk0Mm9rZkdOU2ZnYllOL3pCY0ExMmZ2?=
 =?utf-8?B?cVlFaS9PTEtRNlB0Tk5hRVJacUZlaDZvS0t4NGhLYlhnTjlyMUcwaHluRmdu?=
 =?utf-8?B?RnlhTHJXYlczWng2YWw0b3BTK0VPSXVpaXdGSGU0Y2dIdjN5bExqQjl4bHQ1?=
 =?utf-8?B?U3drNFlzYnZORUViaVJkTm4wTWJpWG0vQjV4UnUwMTJZcm1pVnJFRkNJTDk5?=
 =?utf-8?B?OXhkT3VEYmxLRVZYM1c4N29TSEE1YUJpZ29pM0k0ellIaWpFNk5xcndPb2Fm?=
 =?utf-8?B?Yy83R2NMMUdSb2M5dnZ6cSt2NzJWNStCTit0bGhwTzRIM3RzWUtVZkZKdkFR?=
 =?utf-8?B?TmlBakZnbTNzc3NRSlJZc0dHME9nS0dETC9MekEyL0h6SlMreDdGUElFb2ZU?=
 =?utf-8?B?cGdkR1ZlS1VlR0h3YkkyRzhiTktHSVlEYmpEVW5ML3FTeS8wdTdjQlNzTU1p?=
 =?utf-8?B?M1lCVW9Fak5xSUI2UVBlOUV6SXhmRlZTMytnT1FGcFZRK2VWNFBrK2pwaWFq?=
 =?utf-8?B?dFFJRUF0NEtsR05qL0RFdmlSb2FuS2V0MW5WbVpERVVSY0hlVnd1Y2RyS3BF?=
 =?utf-8?B?QVFYOEFLbC9SN3NHaGQzQXpuT2lMTko1RnZseFZYckZWU3lrck5HcGpYMldV?=
 =?utf-8?B?RktRbDlxVWY4d3pxY1VPRjV0ODNqclpnZU1PRFRYNWxsbTJzbFZ2K3dSTWg0?=
 =?utf-8?B?ZzRyeHF2NmtDVUVWNzVoMG1FWlpzaDU0SG95T2VWT01VUzlJUzQ0TXZXODQ2?=
 =?utf-8?B?OG0rdGZiL21ybjNuRXlrZGRKL1gyemJMam5lZ1Q3bC9oN0xGdlBXeEJCMkZF?=
 =?utf-8?B?eEV5Q1NLclh0VW9ZSnl2dXh4M1JNUFBJSWZaU0lMMGVzTFMvR3JSME0rTWc0?=
 =?utf-8?B?ZUdkZXJ4Zks4R3BMR2NDZlJyRk5PMVp2bTh5VVR2UlNVbGQ5RjQ2SXQzdkFT?=
 =?utf-8?B?ayszM3BnODdsL3dhNzQzSGwvYmpmNk5TTXRUcVE1dmIrT3NyRGRLSUVHNEpM?=
 =?utf-8?B?S21qeE8xazZ4bnRzTXIzQWRzb3ZhYlczQUQ2ak1qTi9ud292eE9VSkNXOEZv?=
 =?utf-8?B?UUJCOU5oUmpiZ2NQb2QzN0VUanNLM3NNYjd2WVhmaGtEbWlzbTJLVTBvdDZ4?=
 =?utf-8?B?MFIwQ0twNHQramNNQ05CejgxbzJtcml4VUdZbUhCcmNJenh2TzNUVDRJU2NY?=
 =?utf-8?B?VEl4bW9ZYmVMaUMzdHluVHVqcFBjSU50TWdJZlpVQWVva1R3YzN5U2NoQ2dZ?=
 =?utf-8?Q?JNhLwV8X1vhkPuG91w2PmWK3uXg2ja83CYXv4xT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E3CD0D231D6794198080A28F8750553@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7a16ea-e95e-4e6c-66d7-08d965c866f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 23:56:04.3346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Ek2QeOy0yQJEBgNoPMDWFrWB3g6gw79SxL7pHYgIoc0TAADZB6TgTsl6y9ACipFpzbcD2kXeTMeFdLNobcJcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2601
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMy8yMSAxMjo0OCBBTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBPbiBTdW4sIEF1
ZyAyMiwgMjAyMSBhdCAwOTozMTo0MlBNICswMjAwLCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4+
ICtzdGF0aWMgYm9vbCBydGw4MzY1bWJfaXNfdmxhbl92YWxpZChzdHJ1Y3QgcmVhbHRla19zbWkg
KnNtaSwgdW5zaWduZWQgaW50IHZsYW4pDQo+IA0KPiBNYXliZSBpdCB3b3VsZCBiZSBtb3JlIGVm
ZmljaWVudCB0byBtYWtlIHNtaS0+b3BzLT5pc192bGFuX3ZhbGlkIG9wdGlvbmFsPw0KDQpUaGF0
IHdvdWxkIHdvcmsuIEknbGwgbWFrZSBhIG5vdGUgdG8gZG8gaXQgZm9yIHYyLg0KDQo+IA0KPj4g
K3sNCj4+ICsJaWYgKHZsYW4gPiBSVEw4MzY1TUJfVklETUFYKQ0KPj4gKwkJcmV0dXJuIGZhbHNl
Ow0KPj4gKw0KPj4gKwlyZXR1cm4gdHJ1ZTsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGludCBy
dGw4MzY1bWJfZW5hYmxlX3ZsYW4oc3RydWN0IHJlYWx0ZWtfc21pICpzbWksIGJvb2wgZW5hYmxl
KQ0KPj4gK3sNCj4+ICsJZGV2X2RiZyhzbWktPmRldiwgIiVzIFZMQU5cbiIsIGVuYWJsZSA/ICJl
bmFibGUiIDogImRpc2FibGUiKTsNCj4+ICsJcmV0dXJuIHJlZ21hcF91cGRhdGVfYml0cygNCj4+
ICsJCXNtaS0+bWFwLCBSVEw4MzY1TUJfVkxBTl9DVFJMX1JFRywgUlRMODM2NU1CX1ZMQU5fQ1RS
TF9FTl9NQVNLLA0KPj4gKwkJRklFTERfUFJFUChSVEw4MzY1TUJfVkxBTl9DVFJMX0VOX01BU0ss
IGVuYWJsZSA/IDEgOiAwKSk7DQo+PiArfQ0KPj4gKw0KPj4gK3N0YXRpYyBpbnQgcnRsODM2NW1i
X2VuYWJsZV92bGFuNGsoc3RydWN0IHJlYWx0ZWtfc21pICpzbWksIGJvb2wgZW5hYmxlKQ0KPj4g
K3sNCj4+ICsJcmV0dXJuIHJ0bDgzNjVtYl9lbmFibGVfdmxhbihzbWksIGVuYWJsZSk7DQo+PiAr
fQ0KPiANCj4gSSdtIG5vdCBnb2luZyB0byBsaWUsIHRoZSByZWFsdGVrX3NtaV9vcHMgVkxBTiBt
ZXRob2RzIHNlZW0gaGlnaGx5DQo+IGNyeXB0aWMgdG8gbWUuIFdoeSBkbyB5b3UgZG8gdGhlIHNh
bWUgdGhpbmcgZnJvbSAuZW5hYmxlX3ZsYW40ayBhcyBmcm9tDQo+IC5lbmFibGVfdmxhbj8gV2hh
dCBhcmUgdGhlc2Ugc3VwcG9zZWQgdG8gZG8gaW4gdGhlIGZpcnN0IHBsYWNlPw0KPiBPciB0byBx
dW90ZSBmcm9tIHJ0bDgzNjZfdmxhbl9hZGQ6ICJ3aGF0J3Mgd2l0aCB0aGlzIDRrIGJ1c2luZXNz
PyINCg0KSSB0aGluayByZWFsdGVrLXNtaSB3YXMgd3JpdHRlbiB3aXRoIHJ0bDgzNjZyYi5jIGlu
IG1pbmQsIHdoaWNoIGFwcGVhcnMgDQp0byBoYXZlIGRpZmZlcmVudCBjb250cm9sIHJlZ2lzdGVy
cyBmb3IgVkxBTiBhbmQgVkxBTjRrIG1vZGVzLCB3aGF0ZXZlciANCnRoYXQncyBzdXBwb3NlZCB0
byBtZWFuLiBTaW5jZSB0aGUgUlRMODM2NU1CIGRvZXNuJ3QgZGlzdGluZ3Vpc2ggYmV0d2VlbiAN
CnRoZSB0d28sIEkganVzdCByb3V0ZSBvbmUgdG8gdGhlIG90aGVyLiBUaGUgYXBwcm9hY2ggaXMg
b25lIG9mIGNhdXRpb24sIA0Kc2luY2UgSSBkb24ndCB3YW50IHRvIGJyZWFrIHRoZSBvdGhlciBk
cml2ZXIgKEkgZG9uJ3QgaGF2ZSBoYXJkd2FyZSB0byANCnRlc3QgZm9yIHJlZ3Jlc3Npb25zKS4g
TWF5YmUgTGludXMgY2FuIGNoaW1lIGluPw0KDQo+IA0KPiBBbHNvLCBzdHVwaWQgcXVlc3Rpb246
IHdoYXQgZG8geW91IG5lZWQgdGhlIFZMQU4gb3BzIGZvciBpZiB5b3UgaGF2ZW4ndA0KPiBpbXBs
ZW1lbnRlZCAucG9ydF9icmlkZ2Vfam9pbiBhbmQgLnBvcnRfYnJpZGdlX2xlYXZlPyBIb3cgaGF2
ZSB5b3UNCj4gdGVzdGVkIHRoZW0/DQoNCkkgaGF2ZSB0byBhZG1pdCB0aGF0IEkgYW0gYWxzbyBp
biBzb21lIGRvdWJ0IGFib3V0IHRoYXQuIFRvIGlsbHVzdHJhdGUsIA0KdGhpcyBpcyBhIHR5cGlj
YWwgY29uZmlndXJhdGlvbiBJIGhhdmUgYmVlbiB0ZXN0aW5nOg0KDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgYnIwDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KICAgICAgICAgICAgICAgKy0tLS0tLS0t
LS0rLS0tLS0rLS0tLS0rLS0tLS0tLS0tLSsNCiAgICAgICAgICAgICAgIHwgICAgICAgICAgfCAg
ICAgICAgICAgfCAgICAgICAgICB8DQooREhDUCkgICAgICAgICsgICAgICAgICAgKyAgICAgICAg
ICAgKyAgICAgICAgICArICAgICAgKHN0YXRpYyBJUCkNCiAgd2FuMCAgICAgIGJyd2FuMCAgICAg
ICBzd3AyICAgICAgICBzd3AzICAgICBicnByaXYwICAgICAgcHJpdjANCiAgIHwgICAgICAgICAg
ICsgMSBQIHUgICAgKyAxIFAgdSAgICAgKyAxIFAgdSAgICArICAgICAgICAgICArDQogICB8ICAg
ICAgICAgICB8ICAgICAgICAgIHwgICAgICAgICAgIHwgMiAgICAgICAgfCAyIFAgdSAgICAgfA0K
ICAgfCAgICAgICAgICAgfCAgICAgICAgICB8ICAgICAgICAgICB8ICAgICAgICAgIHwgICAgICAg
ICAgIHwNCiAgICstLS0tLS0tLS0tLSsgICAgICAgICAgKyAgICAgICAgICAgKyAgICAgICAgICAr
LS0tLS0tLS0tLS0rDQogICAgICAgICAgICAgICAgICAgICAgICAgTEFOICAgICAgICAgUFJJVg0K
DQogICAgICAgICAgbiBQIHUNCiAgICAgICAgICBeIF4gXg0KICAgICAgICAgIHwgfCB8DQogICAg
ICAgICAgfCB8IGAtLS0gRWdyZXNzIFVudGFnZ2VkDQogICAgICAgICAgfCBgLS0tLS0gUG9ydCBW
TEFOIElEIChQVklEKQ0KICAgICAgICAgIGAtLS0tLS0tIFZMQU4gSUQgbg0KDQpJbiB0aGlzIGNv
bmZpZ3VyYXRpb24sIHByaXYwIGlzIHVzZWQgdG8gY29tbXVuaWNhdGUgZGlyZWN0bHkgd2l0aCB0
aGUgDQpQUklWIGRldmljZSBvdmVyIFZMQU4yLiBQUklWIGNhbiBhbHNvIGFjY2VzcyB0aGUgd2lk
ZXIgTEFOIGJ5IA0KdHJhbnNtaXR0aW5nIHVudGFnZ2VkIGZyYW1lcy4gTXkgdW5kZXJzdGFuZGlu
ZyB3YXMgdGhhdCB0aGUgVkxBTiANCmNvbmZpZ3VyYXRpb24gaXMgbmVjZXNzYXJ5IGZvciBlLmcu
IHBhY2tldHMgdG8gYmUgdW50YWdnZWQgcHJvcGVybHkgb24gDQpzd3AyIGVncmVzcy4gQnV0IGFy
ZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IHRoaXMgaXMgYmVpbmcgZG9uZSBpbiBzb2Z0d2FyZSANCmFs
cmVhZHk/IEkuZS4gd2UgYXJlIHNlbmRpbmcgdW50YWdnZWQgZnJhbWVzIGZyb20gQ1BVLT5zd2l0
Y2ggd2l0aG91dCANCmFueSBWTEFOIHRhZz8NCg0KSW4gY2FzZSB5b3UgdGhpbmsgdGhlIFZMQU4g
b3BzIGFyZSB1bm5lY2Vzc2FyeSBnaXZlbiB0aGF0IA0KLnBvcnRfYnJpZGdlX3tqb2luLGxlYXZl
fSBhcmVuJ3QgaW1wbGVtZW50ZWQsIGRvIHlvdSB0aGluayB0aGV5IHNob3VsZCANCmJlIHJlbW92
ZWQgaW4gdGhlaXIgZW50aXJldHkgZnJvbSB0aGUgY3VycmVudCBwYXRjaD8=
