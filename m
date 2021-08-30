Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413493FBF64
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbhH3XZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:25:18 -0400
Received: from mail-eopbgr70114.outbound.protection.outlook.com ([40.107.7.114]:5507
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232049AbhH3XZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:25:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBP0sPrroGKklu2iTi9K/oNHst2l4UGB28IqwhraLIpIn6Rtru4bhU8ClIfVKMiXVA9i1oL5AoXTJ9TGKBqSnIS9XLQmjen5JdFe4MZP2mhVmE32u9Jaw3ImxCbsyMG3j4Fy2dKgb5tTkzf/8DC5xvGag3YmDkX3MUa4papQ6YAWX5Ycq4eWYXvOf5atBVAi3mMZf/0pVoFY//EbWeABtKehL43xXm1abuVAM8QMMxE2SK6q1I3pg8ZcsSziq5wD8Zguuud//zsZJG1O7PzasXBxwLU1FfmxXtiEIlErcN3c8qeu76DU+7FCeVsV9WF9WuDe2CycbuaWWDIQgP3Lvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daP8MzyIKJAxiQgkMBaCQgXWAlMkBHPKZxDinSu509Y=;
 b=lQfUS13lD6Vt6M8gbzGIcdcRAnSihM267Lzw+pB91cGCX09VFZTeO9sdkJd9wT/WS/aQJKqAGKIhVS/Y+Ml0LZU+BDfdtgohrjI4xLViFf3x7zO2wtWJ07iF8slGxhDxVYmYMc6c4ztjWlNajSh7YQPNBfHe3uYM3Snx6wfW7FsW8pY95FklVEFRsEZEA1bLJ6XFvlDS79HHZsIXPZmH3PLyPE3KL7ik+uOEyyGN9TT4P/Nr3EK870b07QUXcMkJj9REl5P6ltIifNKbFMFcu1SFPu/eoWgAWxE3rxGh5osIX4OLDTPXJ7X2jk9zC8By7azGtojgYt/iRx5aur0ZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daP8MzyIKJAxiQgkMBaCQgXWAlMkBHPKZxDinSu509Y=;
 b=Fb+QStphqpkMTD1jaNxmRH51cYC1aIbiwgJds4KGCh989WCosD2p+cZJjyob7Z5AGUfTP8uL4EcE50nVfC6rEXTLzt0RXAg7AFbQz0UvLzHgHqv/bOh0EpBi3oLkwOdsJKX9hqQ4z6+5yK2eCErXeaVY2T/gmRd9FekxQw+gils=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2252.eurprd03.prod.outlook.com (2603:10a6:3:22::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Mon, 30 Aug 2021 23:24:19 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 23:24:18 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net-next 1/5 v2] net: dsa: rtl8366rb: support bridge
 offloading
Thread-Topic: [PATCH net-next 1/5 v2] net: dsa: rtl8366rb: support bridge
 offloading
Thread-Index: AQHXneliYD3puDyvPUKeOL+/eCgA0auMsHqA
Date:   Mon, 30 Aug 2021 23:24:18 +0000
Message-ID: <7864a0a7-2502-912b-3117-161d14256043@bang-olufsen.dk>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-2-linus.walleij@linaro.org>
In-Reply-To: <20210830214859.403100-2-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faae067b-317b-4996-1e62-08d96c0d4a65
x-ms-traffictypediagnostic: HE1PR0301MB2252:
x-microsoft-antispam-prvs: <HE1PR0301MB2252CA9D02E799EA4F898D9C83CB9@HE1PR0301MB2252.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uDulCtDubFdAClIKacOjxFY1IALrhUog8veRdDPvVnoKwTfq7U7jqvkS+VbbiQxNCnotMy9NQrH/F/bazevHkjlVZ4DluMaYzgM3zNjB9HVZ4Clea/XpvVNH0SYqBqifZvVlZU3qgNDMSqWmcuycRHF/kulsG4V3nD+x86nyY4evFnqR3hECvnB8RG7STW1Ncu6GNeG0irtSjtzmcr1sFvTHZwvjJCqTqZ7hiPmNReDAnr9IDOIMfYQxVk8NqjJmct3KJOb20Y3GHKYcNfnPo2ulOd4t4X7/RjZQnExu1w3Chrh8Ia4sezyX5clduxAjZkkvSrexDwucki/C/2eKxrMmcuf8o8VmziFQxiAdcMSnz9pG/gNg0D6szJcsAyYuRZcKJW0lfhcEeLWgUex38sLKSsfrhbUmL/VkW58Sxj+mQueEIIw/DwcFASW8+JrHr84CUusaJ1kW3ddMFuYMeKTLNyhUQcGeKnMenagxENNt6S0vxlOFc4u8CR8xnLLoavXPDLORwycadPvjTy7olLGUYGbGc6UifG7gHCyOeI37+FXWRL/I+UzjZLSOW07sT2QjjFRNulcP7KSssiC7MEUEVCHL9ytIrHM+XPYpx6hGFVXd6z+4r9YuN+uR2LHOvi2Zo4cXqmKbiSPNL/9ocP/XzrkXMT2DYOOdcCfTgyO32buGhgP5xdKC37BXi03hh/BZKDotdsMzxy/MJPJtypKLzzMLgRMcFAJkPyVuPY7IDbER7M/bAXQrzg00f3Z9wqeCUt0tL3vxtJ9B9MRRCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(478600001)(36756003)(71200400001)(54906003)(8976002)(66574015)(85182001)(122000001)(6512007)(8676002)(91956017)(86362001)(110136005)(6486002)(38100700002)(38070700005)(4326008)(26005)(31686004)(2906002)(2616005)(53546011)(66446008)(64756008)(66946007)(85202003)(83380400001)(66556008)(186003)(31696002)(316002)(6506007)(8936002)(5660300002)(76116006)(7416002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djZ1NmJVRmw0eDhDWXhaVDk1ZlpCRmI0aE92K3VSVzllY2RXRi9nSnBKbEJM?=
 =?utf-8?B?blVKTUdJRjRDTksrWlkvbFMvamlhem9NUE1QK2U3eG5vYm00ZFFXTGVFMXRF?=
 =?utf-8?B?NitzRmVDSFozbGhuaGRVdVVJMk9EaVBoWU50ZGtvOXNob01hMmNhd0gyMksv?=
 =?utf-8?B?R0wzLytqZVVmWEl0K2s5RHBOdzJ1R3BUdUh4Y3cxWmxhcTE3a0J0TktUaTEz?=
 =?utf-8?B?N3QzUUppZHF6MVMrc1ROdW9uZFdhM0ZYY0Fhakg1bmZiS1l6a0VuaE9JR0Fk?=
 =?utf-8?B?c0RJZTNmSE5jUTI0K05hSS8zOFQ5RThXL3pCOWtab1pxbHRPbk1BcDVWQjBC?=
 =?utf-8?B?VURBWGFYZzVsdStvdzhIS0RLTXd5UW9MWkhzM0JHcWVBMDdndkVrbWRud2tW?=
 =?utf-8?B?dkZLdXA2S0RVazl2OXVRR0d6Uk9YSVBXT29TaGpKbHVpcGp1Q0tPWC9tS01p?=
 =?utf-8?B?ajY5ckp1ZDB3ZExSZU5ORDh5Mk5ldklYZzYrT2liMVFlK0EzQ004VWtsSzVQ?=
 =?utf-8?B?eTJDVktNTU52NC9VU3p2emRXZFdzd3R3WlZOV0lHT2dFTnV1a0JObFN1bkh3?=
 =?utf-8?B?RStMbjhnRWJTSFdxQW84Q3FqOW01TVRKTjB3YUtYN0lVQzJxYTlkSmhQVXVN?=
 =?utf-8?B?VDFLeVhPQ0hKQWNkYU5XWWNpdXhEaHEzWFNEQ1N2am83RXZoZHRUZHo4YVFi?=
 =?utf-8?B?RUtnVU8zNEd2UDkvTlc1VTFEYUlxdUpPZTVqSHV1Wm1jTTBmR0FvN2JhcWM4?=
 =?utf-8?B?T1NIbWNjbDd3dG5WTWR5ZXpsUlRPcXJybUgvdTZ5eHBlY1BnOTNwMHNuN2t4?=
 =?utf-8?B?V0tIZ3pvRU9wN0licjFhNzUvS2NYWllaK0JVU2ZaVVVnbElnaHV1Y2YxU3Zr?=
 =?utf-8?B?bFlJYmExSVFaQXhMYzZyak1TZlh5RzB2S1U0RlBWTnFheG8xUGppWnczbFNo?=
 =?utf-8?B?OU43ekppZkREUU5QS0hXalp2d2JQdEdLaGNmYk9rVmhORmUwUWlPZm1XOWdo?=
 =?utf-8?B?OVVlUmZ1OGM2VHY0TDFYc1VacktrQzNXRXJmZjc5ek1uZ1ptQi9HWDl2RnZ0?=
 =?utf-8?B?d0xVZzdNWTVnRkE5emRGSEJVK3BleWc5b0VvdmZIWWQ2ZmkvU0tjNWl0S3Ev?=
 =?utf-8?B?VkF5RlJHM25uTEltQ3F1b3dVYlYwTElYeU9NTDdFbG4vc0pDcEdJbVR2V0hh?=
 =?utf-8?B?a1FiWldja1NCV0ZFZE9yWis4ZnJnZkkzYWJJQmRJdlFXNGNsSnBxVlI0Z3Z2?=
 =?utf-8?B?QnhUOWZIZE40SFZhVmdOdTR5MThIT0VGNG9VM0xuMTd0OHM2SGcrbzlRU1Zt?=
 =?utf-8?B?OVF5cWZWdThQU3VTY1l0Z0RZbVJBajVWbEFzNUNyekdSQk1zZ0lOTnk0UG1j?=
 =?utf-8?B?ZlhDMTkzclZ6M3FLRHNzWjRsTHNqZi9VVkdDSnFuZ1Mzc1RMMGdQTVFXMmVW?=
 =?utf-8?B?WlNyOFRhTy9uTVpQbU83MzhCbEJVNlZwM0RrTHhNYzQ1YmhBQVBvQ1c1eUNt?=
 =?utf-8?B?b3UxOU9IZ09scXdSZnJHUXFmZDVJYWgrS2QrdGZZKzV0SU5HL0JmOGVTaG5h?=
 =?utf-8?B?OFVLZlVUajhRWjZBblFKTFNFWU0va0MrTFUvbWJhejRoVU1Wb2Yrb0s2UEk1?=
 =?utf-8?B?dm5zUG9vTFFvSXRrdDNESmlZTndUK285Q2RyaEgrWnhDTzZhSXlBL1k2MDFP?=
 =?utf-8?B?OEhqenN0dTBGVDdyNnF4Sm96eHY0TWhSUVBjVUsrK0RDVzFTR2FVRTBiTUI3?=
 =?utf-8?Q?qT7owxufUpSEe/McTX1xZWThsb8tO6VB9uMGQC2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8855BCF51E5C5489536E473573D32AE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faae067b-317b-4996-1e62-08d96c0d4a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 23:24:18.5063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FLn2VEBczve7okOoUOJH2x4kNEIxRzNJEYmSLJ6AcLfcJOXZTvwT/HRPmGXro0dkWpgrDXuy6cRZzp3VgRIY8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMC8yMSAxMTo0OCBQTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gRnJvbTogREVORyBR
aW5nZmFuZyA8ZHFmZXh0QGdtYWlsLmNvbT4NCj4gDQo+IFVzZSBwb3J0IGlzb2xhdGlvbiByZWdp
c3RlcnMgdG8gY29uZmlndXJlIGJyaWRnZSBvZmZsb2FkaW5nLg0KPiANCj4gVGVzdGVkIG9uIHRo
ZSBELUxpbmsgRElSLTY4NSwgc3dpdGNoaW5nIGJldHdlZW4gcG9ydHMgYW5kDQo+IHNuaWZmaW5n
IHBvcnRzIHRvIG1ha2Ugc3VyZSBubyBwYWNrZXRzIGxlYWsuDQo+IA0KPiBDYzogVmxhZGltaXIg
T2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gQ2M6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJh
bmctb2x1ZnNlbi5kaz4NCj4gQ2M6IE1hdXJpIFNhbmRiZXJnIDxzYW5kYmVyZ0BtYWlsZmVuY2Uu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBERU5HIFFpbmdmYW5nIDxkcWZleHRAZ21haWwuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+
DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2Vu
LmRrPg0KDQo+IENoYW5nZUxvZyB2MS0+djI6DQo+IC0gaW50cm9kdWNlIFJUTDgzNjZSQl9QT1JU
X0lTT19QT1JUUygpIHRvIHNoaWZ0IHRoZSBwb3J0DQo+ICAgIG1hc2sgaW50byBwbGFjZSBzbyB3
ZSBhcmUgbm90IGNvbmZ1c2VkIGJ5IHRoZSBlbmFibGUNCj4gICAgYml0Lg0KPiAtIFVzZSB0aGlz
IHdpdGggZHNhX3VzZXJfcG9ydHMoKSB0byBpc29sYXRlIHRoZSBDUFUgcG9ydA0KPiAgICBmcm9t
IGl0c2VsZi4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jIHwgODcgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA4
NyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3J0bDgz
NjZyYi5jIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jDQo+IGluZGV4IGE4OTA5M2JjNmM2
YS4uNTBlZTdjZDYyNDg0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJi
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jDQo+IEBAIC0zMDAsNiArMzAw
LDEzIEBADQo+ICAgI2RlZmluZSBSVEw4MzY2UkJfSU5URVJSVVBUX1NUQVRVU19SRUcJMHgwNDQy
DQo+ICAgI2RlZmluZSBSVEw4MzY2UkJfTlVNX0lOVEVSUlVQVAkJMTQgLyogMC4uMTMgKi8NCj4g
ICANCj4gKy8qIFBvcnQgaXNvbGF0aW9uIHJlZ2lzdGVycyAqLw0KPiArI2RlZmluZSBSVEw4MzY2
UkJfUE9SVF9JU09fQkFTRQkJMHgwRjA4DQo+ICsjZGVmaW5lIFJUTDgzNjZSQl9QT1JUX0lTTyhw
bnVtKQkoUlRMODM2NlJCX1BPUlRfSVNPX0JBU0UgKyAocG51bSkpDQo+ICsjZGVmaW5lIFJUTDgz
NjZSQl9QT1JUX0lTT19FTgkJQklUKDApDQo+ICsjZGVmaW5lIFJUTDgzNjZSQl9QT1JUX0lTT19Q
T1JUU19NQVNLCUdFTk1BU0soNywgMSkNCj4gKyNkZWZpbmUgUlRMODM2NlJCX1BPUlRfSVNPX1BP
UlRTKHBtYXNrKQkocG1hc2sgPDwgMSkNCj4gKw0KPiAgIC8qIGJpdHMgMC4uNSBlbmFibGUgZm9y
Y2Ugd2hlbiBjbGVhcmVkICovDQo+ICAgI2RlZmluZSBSVEw4MzY2UkJfTUFDX0ZPUkNFX0NUUkxf
UkVHCTB4MEYxMQ0KPiAgIA0KPiBAQCAtODM1LDYgKzg0MiwyMiBAQCBzdGF0aWMgaW50IHJ0bDgz
NjZyYl9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+ICAgCWlmIChyZXQpDQo+ICAgCQly
ZXR1cm4gcmV0Ow0KPiAgIA0KPiArCS8qIElzb2xhdGUgYWxsIHVzZXIgcG9ydHMgc28gb25seSB0
aGUgQ1BVIHBvcnQgY2FuIGFjY2VzcyB0aGVtICovDQo+ICsJZm9yIChpID0gMDsgaSA8IFJUTDgz
NjZSQl9QT1JUX05VTV9DUFU7IGkrKykgew0KPiArCQlyZXQgPSByZWdtYXBfd3JpdGUoc21pLT5t
YXAsIFJUTDgzNjZSQl9QT1JUX0lTTyhpKSwNCj4gKwkJCQkgICBSVEw4MzY2UkJfUE9SVF9JU09f
RU4gfA0KPiArCQkJCSAgIFJUTDgzNjZSQl9QT1JUX0lTT19QT1JUUyhCSVQoUlRMODM2NlJCX1BP
UlRfTlVNX0NQVSkpKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXJldHVybiByZXQ7DQo+ICsJfQ0K
PiArCS8qIENQVSBwb3J0IGNhbiBhY2Nlc3MgYWxsIHBvcnRzICovDQo+ICsJZGV2X2luZm8oc21p
LT5kZXYsICJEU0EgdXNlciBwb3J0IG1hc2s6ICUwOHhcbiIsIGRzYV91c2VyX3BvcnRzKGRzKSk7
DQoNCk1heWJlIGRldl9kYmc/IE5vdCBhbGwgcGVvcGxlIGFwcHJlY2lhdGUgY2hhdHR5IGRyaXZl
cnMuLi4NCg0KPiArCXJldCA9IHJlZ21hcF93cml0ZShzbWktPm1hcCwgUlRMODM2NlJCX1BPUlRf
SVNPKFJUTDgzNjZSQl9QT1JUX05VTV9DUFUpLA0KPiArCQkJICAgUlRMODM2NlJCX1BPUlRfSVNP
X1BPUlRTKGRzYV91c2VyX3BvcnRzKGRzKSl8DQo+ICsJCQkgICBSVEw4MzY2UkJfUE9SVF9JU09f
RU4pOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVybiByZXQ7DQo+ICsNCj4gICAJLyogU2V0IHVw
IHRoZSAiZ3JlZW4gZXRoZXJuZXQiIGZlYXR1cmUgKi8NCj4gICAJcmV0ID0gcnRsODM2NnJiX2ph
bV90YWJsZShydGw4MzY2cmJfZ3JlZW5famFtLA0KPiAgIAkJCQkgIEFSUkFZX1NJWkUocnRsODM2
NnJiX2dyZWVuX2phbSksIHNtaSwgZmFsc2UpOw0KPiBAQCAtMTEyNyw2ICsxMTUwLDY4IEBAIHJ0
bDgzNjZyYl9wb3J0X2Rpc2FibGUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCkNCj4g
ICAJcmI4MzY2cmJfc2V0X3BvcnRfbGVkKHNtaSwgcG9ydCwgZmFsc2UpOw0KPiAgIH0NCj4gICAN
Cj4gK3N0YXRpYyBpbnQNCj4gK3J0bDgzNjZyYl9wb3J0X2JyaWRnZV9qb2luKHN0cnVjdCBkc2Ff
c3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICsJCQkgICBzdHJ1Y3QgbmV0X2RldmljZSAqYnJpZGdl
KQ0KPiArew0KPiArCXN0cnVjdCByZWFsdGVrX3NtaSAqc21pID0gZHMtPnByaXY7DQo+ICsJdW5z
aWduZWQgaW50IHBvcnRfYml0bWFwID0gMDsNCj4gKwlpbnQgcmV0LCBpOw0KPiArDQo+ICsJLyog
TG9vcCBvdmVyIGFsbCBvdGhlciBwb3J0cyB0aGFuIHRoaXMgb25lICovDQo+ICsJZm9yIChpID0g
MDsgaSA8IFJUTDgzNjZSQl9QT1JUX05VTV9DUFU7IGkrKykgew0KPiArCQkvKiBIYW5kbGVkIGxh
c3QgKi8NCj4gKwkJaWYgKGkgPT0gcG9ydCkNCj4gKwkJCWNvbnRpbnVlOw0KPiArCQkvKiBOb3Qg
b24gdGhpcyBicmlkZ2UgKi8NCj4gKwkJaWYgKGRzYV90b19wb3J0KGRzLCBpKS0+YnJpZGdlX2Rl
diAhPSBicmlkZ2UpDQo+ICsJCQljb250aW51ZTsNCj4gKwkJLyogSm9pbiB0aGlzIHBvcnQgdG8g
ZWFjaCBvdGhlciBwb3J0IG9uIHRoZSBicmlkZ2UgKi8NCj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0
ZV9iaXRzKHNtaS0+bWFwLCBSVEw4MzY2UkJfUE9SVF9JU08oaSksDQo+ICsJCQkJCSBSVEw4MzY2
UkJfUE9SVF9JU09fUE9SVFMoQklUKHBvcnQpKSwNCj4gKwkJCQkJIFJUTDgzNjZSQl9QT1JUX0lT
T19QT1JUUyhCSVQocG9ydCkpKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXJldHVybiByZXQ7DQo+
ICsNCj4gKwkJcG9ydF9iaXRtYXAgfD0gQklUKGkpOw0KPiArCX0NCj4gKw0KPiArCS8qIFNldCB0
aGUgYml0cyBmb3IgdGhlIHBvcnRzIHdlIGNhbiBhY2Nlc3MgKi8NCj4gKwlyZXR1cm4gcmVnbWFw
X3VwZGF0ZV9iaXRzKHNtaS0+bWFwLCBSVEw4MzY2UkJfUE9SVF9JU08ocG9ydCksDQo+ICsJCQkJ
ICBSVEw4MzY2UkJfUE9SVF9JU09fUE9SVFNfTUFTSywNCj4gKwkJCQkgIFJUTDgzNjZSQl9QT1JU
X0lTT19QT1JUUyhwb3J0X2JpdG1hcCkpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZA0KPiAr
cnRsODM2NnJiX3BvcnRfYnJpZGdlX2xlYXZlKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBv
cnQsDQo+ICsJCQkgICAgc3RydWN0IG5ldF9kZXZpY2UgKmJyaWRnZSkNCj4gK3sNCj4gKwlzdHJ1
Y3QgcmVhbHRla19zbWkgKnNtaSA9IGRzLT5wcml2Ow0KPiArCXVuc2lnbmVkIGludCBwb3J0X2Jp
dG1hcCA9IDA7DQo+ICsJaW50IHJldCwgaTsNCj4gKw0KPiArCS8qIExvb3Agb3ZlciBhbGwgb3Ro
ZXIgcG9ydHMgdGhhbiB0aGlzIG9uZSAqLw0KPiArCWZvciAoaSA9IDA7IGkgPCBSVEw4MzY2UkJf
UE9SVF9OVU1fQ1BVOyBpKyspIHsNCj4gKwkJLyogSGFuZGxlZCBsYXN0ICovDQo+ICsJCWlmIChp
ID09IHBvcnQpDQo+ICsJCQljb250aW51ZTsNCj4gKwkJLyogTm90IG9uIHRoaXMgYnJpZGdlICov
DQo+ICsJCWlmIChkc2FfdG9fcG9ydChkcywgaSktPmJyaWRnZV9kZXYgIT0gYnJpZGdlKQ0KPiAr
CQkJY29udGludWU7DQo+ICsJCS8qIFJlbW92ZSB0aGlzIHBvcnQgZnJvbSBhbnkgb3RoZXIgcG9y
dCBvbiB0aGUgYnJpZGdlICovDQo+ICsJCXJldCA9IHJlZ21hcF91cGRhdGVfYml0cyhzbWktPm1h
cCwgUlRMODM2NlJCX1BPUlRfSVNPKGkpLA0KPiArCQkJCQkgUlRMODM2NlJCX1BPUlRfSVNPX1BP
UlRTKEJJVChwb3J0KSksIDApOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJcmV0dXJuOw0KPiArDQo+
ICsJCXBvcnRfYml0bWFwIHw9IEJJVChpKTsNCj4gKwl9DQo+ICsNCj4gKwkvKiBDbGVhciB0aGUg
Yml0cyBmb3IgdGhlIHBvcnRzIHdlIGNhbiBhY2Nlc3MgKi8NCj4gKwlyZWdtYXBfdXBkYXRlX2Jp
dHMoc21pLT5tYXAsIFJUTDgzNjZSQl9QT1JUX0lTTyhwb3J0KSwNCj4gKwkJCSAgIFJUTDgzNjZS
Ql9QT1JUX0lTT19QT1JUUyhwb3J0X2JpdG1hcCksIDApOw0KPiArfQ0KPiArDQo+ICAgc3RhdGlj
IGludCBydGw4MzY2cmJfY2hhbmdlX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0
LCBpbnQgbmV3X210dSkNCj4gICB7DQo+ICAgCXN0cnVjdCByZWFsdGVrX3NtaSAqc21pID0gZHMt
PnByaXY7DQo+IEBAIC0xNTEwLDYgKzE1OTUsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRzYV9z
d2l0Y2hfb3BzIHJ0bDgzNjZyYl9zd2l0Y2hfb3BzID0gew0KPiAgIAkuZ2V0X3N0cmluZ3MgPSBy
dGw4MzY2X2dldF9zdHJpbmdzLA0KPiAgIAkuZ2V0X2V0aHRvb2xfc3RhdHMgPSBydGw4MzY2X2dl
dF9ldGh0b29sX3N0YXRzLA0KPiAgIAkuZ2V0X3NzZXRfY291bnQgPSBydGw4MzY2X2dldF9zc2V0
X2NvdW50LA0KPiArCS5wb3J0X2JyaWRnZV9qb2luID0gcnRsODM2NnJiX3BvcnRfYnJpZGdlX2pv
aW4sDQo+ICsJLnBvcnRfYnJpZGdlX2xlYXZlID0gcnRsODM2NnJiX3BvcnRfYnJpZGdlX2xlYXZl
LA0KPiAgIAkucG9ydF92bGFuX2ZpbHRlcmluZyA9IHJ0bDgzNjZfdmxhbl9maWx0ZXJpbmcsDQo+
ICAgCS5wb3J0X3ZsYW5fYWRkID0gcnRsODM2Nl92bGFuX2FkZCwNCj4gICAJLnBvcnRfdmxhbl9k
ZWwgPSBydGw4MzY2X3ZsYW5fZGVsLA0KPiANCg==
