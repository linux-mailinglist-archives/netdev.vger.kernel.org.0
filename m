Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E939C3F4858
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhHWKMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:12:12 -0400
Received: from mail-vi1eur05on2094.outbound.protection.outlook.com ([40.107.21.94]:9600
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233145AbhHWKMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 06:12:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geGmhiSAJhIpwfx4e+IUNgPElIrU/k0DQy5e/zDdJkItzTqzbbJnBuhtlYfz41HkQWCJlWPilipxjb2s7ICYEBpPfDvyg7N7I1/5itxtMqVtPxZt/a4sdOyhwQJA0EWEAVmNrXUpPAk9+uMBa/GEs30bHgIGH0uclVW/RzZzczBuinNKP4ZuInDCUC1LSW2QbVOsdgFFzG5DN7LdbrWJTgJlgCWpXqj+P9zxe5lz8uOEywWdqyDLc8AdAAKQgb2pPSICGEHxpKuGN2oPuVprdGV94tnID1UpHiTBt4G3J5lRlzNW/HDgw91kiqhiYzDdmJHnKpD/z1UdgPkS4YHPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FABxNln5w/rjyixxFhMfNNAOouNYsb+6hJ3ZMdyjAao=;
 b=dkUCO0g0YNH0qn6qTkq1pmPAI2kKCwBYq/rO6QmTWk2bbEqkKB+tlT6FG8u/6uodEXHgsVx7OtR57+TpjFnDKoa1AhQIeA/T/+HB3aYvb/CpmgzXspTunWt9++PTh9eQEdnv3phRdkztG+o7KoOeg+koA40CgVyZoiiQyvSMbJiuwjIAYYFjFDnA6/Tvkt9LE6wpbxw8Yz9a8oYngTa7TrCjK0I1/EX9CZfBg5/oLP5AiTcGOMKzDEHDOP0QknG/k6fDfIg8pF1MZHzVWTvcu1qNhK96qav0F80+jr2ZoBNvAhUeF5m7Se46JdkMNW9RzJGyOuGXKqRWmPfgwL+r1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FABxNln5w/rjyixxFhMfNNAOouNYsb+6hJ3ZMdyjAao=;
 b=lWJeh9PyFaP61E6Kh9mdBxz3vvR1VEJXmIvMKWf/ZHatx959HvCOpVSWfWwdzEIrMgQCiSo05GkN9N+RHb1xhP+f1q+gxCjQqSbj8faLePxIZ/Z7OF3qHXMn+mjHOVCrIqWVdRQ+ilm8WE+o7t5nUh2ksn4usyjZwzbr5X/b5is=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2282.eurprd03.prod.outlook.com (2603:10a6:3:24::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Mon, 23 Aug 2021 10:11:23 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Mon, 23 Aug 2021
 10:11:23 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Thread-Index: AQHXl4yCe3G+ndzNv0qmlobhUV7pTauAgguAgABdTgA=
Date:   Mon, 23 Aug 2021 10:11:23 +0000
Message-ID: <9e85c688-e5c1-e7ed-8a5d-87e22e5a72e8@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210823043725.163922-1-dqfext@gmail.com>
In-Reply-To: <20210823043725.163922-1-dqfext@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2249beb8-62cb-4774-96ed-08d9661e5c9e
x-ms-traffictypediagnostic: HE1PR0301MB2282:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0301MB2282763D73DCB7D8727384EF83C49@HE1PR0301MB2282.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gye/0dh8fqrZNJRp0x48oK3BI89i1jxSJIX+Rv5cf7i+py9zxHeZtdkplheIgw3Gl2x/wSUK4KScF3dVDQzmxGS0u9p9mWFwqPvColUbdGocv5KuXBsSIfxsS254AaKspnKsu6acQ+/a3ct8/7zoJdgwxJgS37KEWBegyMbvwMTG8dB6fyGozesOigA0n08SIyftzbh7mEkymdLfRTz21iiPQ4qDLVGdEH0sLMDsncVRCafrvMY1SKHoePsp9lbutxnNFNr1J7utMY0oKnOkK3j+bPxPngCDZ42OhSlRl3ScFvETpDgptzdidUMqh7zf1wYjiXgDSG9Bi59oT/KLmAy03GFgaf6NIJRfRm+KtD0Qi8+CH10+GH2nKKTrFSbo8zg+CVvyAn6KST6PmV8OW8TnGJQfLPF8kaeQ6iB2cz2ypFc+hC5skJG6hExm0+2ijp/KHzxWHqmOwqhUEF02QccPJC7QdY1gCx7N0lNqwqKiatK1gmCC6vYNW3KUyFTBdTVGeOw+/oHSzhHWkLZ1flJ5nrRHDMFPV9I1ClnC+CRbstp+KIFcQcBFDs+MOIO4DYhTvczXgE8f4GaJF89e9dvDxji+kB0cDsll3Tp6XI1hAAArbqtbHeu+8/aE52OM5jphyj5CZ/7H/mfrWrAfIicsFMZDT2p0d3UgJOux7Znb2T4rwEwKBVKxGQV6qFI7UlwCBHySZx9ea5M93fjpwJdfkGGXFywxA5MvhSmbaPEWdJbnzvkg9qx8y4UgFLIGMcB7xrVA587JZ6qnllvctPttEuxslGmrq84UO1zehWPu/MUa8Ox71DvY5wTufAbKqFIXzXbFk/NFm0cSv9gpMbDzFELe1/eqGNAB1dXxgtk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39840400004)(346002)(366004)(136003)(396003)(54906003)(316002)(66556008)(66946007)(110136005)(31696002)(38070700005)(2616005)(91956017)(6506007)(76116006)(66446008)(966005)(64756008)(66476007)(86362001)(31686004)(7416002)(85202003)(8976002)(8936002)(8676002)(5660300002)(2906002)(26005)(478600001)(85182001)(38100700002)(6486002)(66574015)(71200400001)(186003)(36756003)(4326008)(122000001)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHl2RitWcUZ5WFlSb3E4OVUzVkNJcEo1ejU4UmxhOGdGSUhPNFdQZ1R6VU5r?=
 =?utf-8?B?eS9DSFJNd3ZaU0hXdktiS1FTUzJ1L0hlZ3FoeE5abnh1YTJXNG4yNXVnbHlj?=
 =?utf-8?B?cmg2dzN4aEdPSnZjaHFCeW5valVmdUFBejVjNE5ydXRZVnc3Y0VHcmNjQk9I?=
 =?utf-8?B?bVBTN0FYc3pXVklpOENhTXBoOHFSUGR5NzFIUlFGbElyNlJQc2QvVzQ0RlBs?=
 =?utf-8?B?OVlaQkJnNGJYTlZqbnNrVFdzb3dYQ0tJRWhaUXNwZkpHQzNRZlErTTRENUpC?=
 =?utf-8?B?ZEErem1aRGtvY0lsSVM0ZURicXlpNUtQZHdqR0xrazdmT2w2R01KL2ZUOHk3?=
 =?utf-8?B?OTI3Q0Zpb1hOYnVNMDVibmhCYTlMY1VRUy8yZk1yY2tSRktHemU4ZkE5Q3Nz?=
 =?utf-8?B?bmFRR0RsbGRtVUZzNXJITjFqOWt5VXdnSVcwU0pMT2VxQ1hFRG8xWWZvbHd4?=
 =?utf-8?B?TFFmUWw2a3ZCT2Urek0velgzT1Z2a29DdnZaWExYYkZ0dmdHMkxFOExDanUw?=
 =?utf-8?B?WGd0T3l4VTAzTU5wN24xV09ZKzBUelJDUWxLRWZ3Q2NZRzd6cyszZXB5YXRu?=
 =?utf-8?B?MnlZazY5cXlEV29nQmJZVUFReG80UzA1Zm13ZmNDZG5qaGI3bkIrejJHM0Q5?=
 =?utf-8?B?eFlKZDVsVTFDc2lGMTVhOE5Ybitza0RtUGl4R0ZFWElNMklPQmFhMkdhcDdC?=
 =?utf-8?B?Qmw1L3N1aTVudk10b1FZaUxWZGRkRndTMTBPRHJ4eGV6L2kzQVljMTBHMkVl?=
 =?utf-8?B?TjVkblJYU2lLbk5wQWE1dTZsRnc5OEdIT0dRZGNxOHdrTFdHaGFHdFpQUTBK?=
 =?utf-8?B?MkxzZ1hmcVkvdXVYMUxFWFI1NHBZQ01SRFQ1eHUyek45ejFUWHo2RVZkWWhi?=
 =?utf-8?B?ejU2R1NaWXY5QTFJRHB2eW1Kb0wzZTlxOXk3Tm5FT29Jb2FDY3ppZS9oN29y?=
 =?utf-8?B?dzdMa2dLTTNWbDhyaVRBZ2RLVTgyazRlT1JGc20yYVA0a0dFYy9oV0k1Q1VO?=
 =?utf-8?B?ZzhyU2FJVkVmZmY1cjJUZWgxaDUzWDVTellVVENDSmNiaWxqR2Zxb1dPUGdX?=
 =?utf-8?B?RW9ndG03RWVPSTBxU2RlNFdoVDJBWXdqTVhyVHYxS1BQK3AxcmlMdmwyclRu?=
 =?utf-8?B?amdlalJFU0dUK3BLcEx1TVRCWHNuNnR0dkd6bjlIQXhwSVF3c2VvQkI1Mldx?=
 =?utf-8?B?TUtJRGx4ZUQ1OFFlZ0F3MHY0aEppYUUvOUw1ektsdHZnZEVuODEzeUpvc3VM?=
 =?utf-8?B?a0VXNTZzQ2V4S3laWXBXZzN0alRmVnd4OHJJQWdTQys5RkduVVFPUWRYeG5Q?=
 =?utf-8?B?RFdkNnBUZWNmWkxMVWt2bG96dWhDK0FCdmFheUx1OVFseGhvbGhGWFVMLzRK?=
 =?utf-8?B?eUZ2djBjUWd4V0pKMm1QbUJFU2NvZkE1blgwWWx6K0kwRlkrblVkYnlXRDFL?=
 =?utf-8?B?SHV6VVh1ODdLb2t2OXd5cEp3OGFUbDFTTjFzQkN3QkJQNHd4b3dXMXFPMEt5?=
 =?utf-8?B?ODh3WjYrUHZ1aEJ2bUhpSjlTVXlQNDJJTkNIWElzVlpkV3U2Zk5RQUZaWVll?=
 =?utf-8?B?bzVhNktFb2lUS21rREZWcTNsald1VExLNlkxWDVOOUt3NkxteEl3WU1LL0NL?=
 =?utf-8?B?cllNNjBMNUtKTjhpcHdMSFdiT1IwcjhIYTB3QUlyclliTU1rYlgxMUVHWFdI?=
 =?utf-8?B?cTc1Tk5RMTNqTjBRZVcvcTlKVTVTTERVVUVicFJpRnRYQzExR0J5WG8xYjBV?=
 =?utf-8?Q?f3S3b4o9dLSgSVHpUUvRLULVqtJhrZlnKURkDtl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E04830228D2BE448B95CC364BE1AC3D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2249beb8-62cb-4774-96ed-08d9661e5c9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 10:11:23.6856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bwuIi4Lj4reuNuNb01JMdORpdyWgT+s7AI0fCIIC2hjoKTYrOfu6h9nnEcSPJ+C8aj+kc956J1AY+00nW2tAAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMy8yMSA2OjM3IEFNLCBERU5HIFFpbmdmYW5nIHdyb3RlOg0KPiBPbiBTdW4sIEF1ZyAy
MiwgMjAyMSBhdCAwOTozMTo0MlBNICswMjAwLCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4+ICsv
KiBUYWJsZSBMVVQgKGxvb2stdXAtdGFibGUpIGFkZHJlc3MgcmVnaXN0ZXIgKi8NCj4+ICsjZGVm
aW5lIFJUTDgzNjVNQl9UQUJMRV9MVVRfQUREUl9SRUcJCQkweDA1MDINCj4+ICsjZGVmaW5lICAg
UlRMODM2NU1CX1RBQkxFX0xVVF9BRERSX0FERFJFU1MyX01BU0sJMHg0MDAwDQo+PiArI2RlZmlu
ZSAgIFJUTDgzNjVNQl9UQUJMRV9MVVRfQUREUl9CVVNZX0ZMQUdfTUFTSwkweDIwMDANCj4+ICsj
ZGVmaW5lICAgUlRMODM2NU1CX1RBQkxFX0xVVF9BRERSX0hJVF9TVEFUVVNfTUFTSwkweDEwMDAN
Cj4+ICsjZGVmaW5lICAgUlRMODM2NU1CX1RBQkxFX0xVVF9BRERSX1RZUEVfTUFTSwkJMHgwODAw
DQo+PiArI2RlZmluZSAgIFJUTDgzNjVNQl9UQUJMRV9MVVRfQUREUl9BRERSRVNTX01BU0sJCTB4
MDdGRg0KPiANCj4gRkRCL01EQiBvcGVyYXRpb25zIHNob3VsZCBiZSBwb3NzaWJsZS4NCg0KWWVz
LCB0aGUgc3dpdGNoIHN1cHBvcnRzIHRoZXNlLg0KDQo+IA0KPj4gKy8qIFBvcnQgaXNvbGF0aW9u
IChmb3J3YXJkaW5nIG1hc2spIHJlZ2lzdGVycyAqLw0KPj4gKyNkZWZpbmUgUlRMODM2NU1CX1BP
UlRfSVNPTEFUSU9OX1JFR19CQVNFCQkweDA4QTINCj4+ICsjZGVmaW5lIFJUTDgzNjVNQl9QT1JU
X0lTT0xBVElPTl9SRUcoX3BoeXNwb3J0KSBcDQo+PiArCQkoUlRMODM2NU1CX1BPUlRfSVNPTEFU
SU9OX1JFR19CQVNFICsgKF9waHlzcG9ydCkpDQo+PiArI2RlZmluZSAgIFJUTDgzNjVNQl9QT1JU
X0lTT0xBVElPTl9NQVNLCQkJMHgwN0ZGDQo+IA0KPiBCcmlkZ2Ugb2ZmbG9hZCBzaG91bGQgYmUg
aW1wbGVtZW50ZWQgd2l0aCB0aGVzZSBpc29sYXRpb24gcmVnaXN0ZXJzLg0KDQpUaGF0IHdhcyBt
eSBwbGFuLCBhbGJlaXQgbm90IHlldCBpbXBsZW1lbnRlZCBpbiB0aGlzIHNlcmllcy4NCg0KPiAN
Cj4gDQo+IA0KPiBGWUk6DQo+IGh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9naC9saWJjMDYwNy9S
ZWFsdGVrX3N3aXRjaF9oYWNraW5nQGZpbGVzL1JlYWx0ZWtfVW5tYW5hZ2VkX1N3aXRjaF9Qcm9n
cmFtbWluZ0d1aWRlLnBkZj4+IA0KDQpZZXMsIHRoaXMgaXMgdGhlIGRvY3VtZW50IHdlIGdvdCBm
cm9tIFJlYWx0ZWsgYW5kIHdoZXJlIHRoZSBsYXlvdXQgb2YgDQp0aGUgQ1BVIHRhZyBmb3JtYXQg
d2FzIGxpZnRlZCBmcm9tLiBPdGhlciByZXZpZXdlcnMgbWlnaHQgZmluZCBpdCANCmhlbHBmdWwg
dG8gY2hlY2sgdGhpcyBvdXQuIFRoYW5rcyENCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
