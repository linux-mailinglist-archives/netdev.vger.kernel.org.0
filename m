Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674BB422007
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 09:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhJEIBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:01:41 -0400
Received: from mail-eopbgr70119.outbound.protection.outlook.com ([40.107.7.119]:40622
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232793AbhJEIBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 04:01:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO1LwtTe9QFm5PIi5zg4OBxCgQaMaDeQ+Qs8pXC5R7lVtr2OZNatcRC1QavSLG+GT9w6iUlP1kDMDS2l+xv4PqRwvgy1iCO6b2Gkq4SpY9U2pjBPlN14aSw/FW12ZTSsfex0FaHI5UKTza+G+GdPHWYtiom37mKVf3BjOKDKr3jPRzsvf1uscvU1gHuG5Y1sDiGwJJ2hK359uVXirsLWflOL+1i3P1BoRqyZ45KTvMQw66mROUccH2krAOXt5RtYPWkhwyIOnwP5qehNN0b+sy6D4oW/zvDKcj3YVfblYV/1hgtiJBy3BuU65eCHKZXdPKcR+PNkZeNPd6/8xmR2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/RoMj50UPF39H+gNw1iTLvmYczfBIeddhd6TH22E9Y=;
 b=FPbbS+j33IC+nKMmt5AD4CjPBqcch9XTwpsBtEpKZoXBowIP9XLAl1P1c0IfGEznWOt2H1Y3MD62ZmDZASOqTnYPPNW492WEVs6D3lZCqH3uWA9Qa25rjd4ATH026BTxEw6nA/wxFm6wPzwB+TMi/rK2UQJabw/NNmAGc5P3DLfoQZC5QU3KJROCJHoY3Jq+uF9vJqntNcJStm4RyIDAZ3i3j/BYos3sHcqsdtE/LaOkBCqxEy2PGKv0VS0GnWUuT4seXjaoBuO1H3SUVUPm+YFp7lVdrQKfCgMiIKuWL2PiM990ikRTXBhAP3l7ZrKctm4z5Ju/lJ+iHxobxfAKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/RoMj50UPF39H+gNw1iTLvmYczfBIeddhd6TH22E9Y=;
 b=UJUJJu1U1J662s+JqegIukx+X50I5Aul5ZIIIb9/xwE9b/orKpqCFrQErINu/4sxW9J9zSOe/TGUvuwt3hPj4BKQvQ2zR63vWlb2iGIrvU2UbnweyeiotnGiyw5QB3E30cyzNB68raCKMR4wy9LU620snZx4skdbPxnjzfghgAI=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2140.eurprd03.prod.outlook.com (2603:10a6:3:2c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.22; Tue, 5 Oct 2021 07:59:44 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 07:59:41 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Topic: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Index: AQHXtXXws06pLZ3f6EGMY4OLSctn3qu8ZZCAgAb0a4CAALkwAA==
Date:   Tue, 5 Oct 2021 07:59:41 +0000
Message-ID: <d255f7eb-a85d-6fb6-8e86-ccb9669dd339@bang-olufsen.dk>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org>
 <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
 <CACRpkdZ5O0pf+mZphr5ypDNXtkQwfomwBnUToY2arXvtDHki+g@mail.gmail.com>
In-Reply-To: <CACRpkdZ5O0pf+mZphr5ypDNXtkQwfomwBnUToY2arXvtDHki+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be9da8fb-8fcc-4185-d10b-08d987d6167f
x-ms-traffictypediagnostic: HE1PR0301MB2140:
x-microsoft-antispam-prvs: <HE1PR0301MB2140C489BB8E704737A1B2A483AF9@HE1PR0301MB2140.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LeQI3Y/81i9NyqJ5/+SjEOyWt1Nx/mk+yNvTZ1fXzX1wL+aKoUjb13P0Vgl2ESL6FS1fiUx+2b0Y292JX5KwKn0V5iwNJMyqCfqnx1DsS8R+IUAuBHAyb9gjIbOKF+h5RwWNVcfYBX9EI/P2a2ruajmeXR1pfiDjgbup6dQss48kvapA7qt1x//P8hjvkG/xHHcRk7boACk5bdHT97lq55890q3/Jg8i+2hUdqR1maM8BYeXxJhoUk1gEXnw54qKa7V0DdiW2R77U9chpJ40zYzxKq7G80ncdL/a3OLCN5US63N+67QmMDmgnGvdey76LpvCTdyx5N4WuDKi/xstRxSKsM6WAahxzWqsDHUVoXtJVGSTtg23D/GstCzqNbZdjfbuO0VIyATS3VAFSaLbgVZ8d5mV2DL8bhs5dhtptuPaLqfLL8fmjPeDeTYYy8PcmFQYfZy5wK8FGF2oTKw6h9v4FhZjRq1G/e4EDiQQKZ+yAe+ViYZQvmHyX7/tEbclKLXfMdTqZYHcuAXHgm5P5pLkCGJm8EuypOqaTGyZLwydwaJhed8dcE//d2qI7plNCwQkrV6lqZQaPZMqz6DZKX8Jjp8PwvnIOz1Si3t9Nu+YKyIcr5aSydRX3JWPtDcbpgaJ5nJk96TiR/LOQmUjtVbPHihttScMjrUPobWm0AXrZ6b0COuxAx0OjkMth/GtGDJ691+Nku+QkIrkbijaSlI+oqjQ0BIACBJlM3Y4fE2SvY/ScsV4sJw9K/NMXsRbRuCJIq2/ONBUF6uj6pCusw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(122000001)(38100700002)(6512007)(71200400001)(54906003)(8976002)(83380400001)(2906002)(6506007)(2616005)(8936002)(85202003)(316002)(6916009)(86362001)(66946007)(26005)(76116006)(6486002)(64756008)(7416002)(66476007)(91956017)(4326008)(85182001)(66446008)(36756003)(31696002)(38070700005)(508600001)(66556008)(186003)(31686004)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDQ4M3ZuVDlETGllMTMzK2ljaWhyZmF3Smcxem5vREIrTzh1UEtnSHRGUkJM?=
 =?utf-8?B?d2xlVEhoNXJVbXVFRmNzRjJxM0dYRC8vWWlDaFMwQmRtM0R2RWUvK1A1dktC?=
 =?utf-8?B?K2RkWVFyNEptZ2N0QjdCWWdzTkM1NldreUdQT2tnM3F5bElwTnJhZ0QweHVS?=
 =?utf-8?B?SWZXOUVmaThlVXdDRVFrVzhpb254L2wyVDlIeWY4ZFNQdHp0dElrdmtBcHFn?=
 =?utf-8?B?eWIrU1VlQTducEpVVXFPUUlXckhLcmpCYjAreVl6T09RYlRkaFRMSzAxYjhu?=
 =?utf-8?B?NzNQSk1tNUI5UVZTVHVINEVROHhNWHJVZU1vdnEzWE5QcThtdm5STzZUa05Y?=
 =?utf-8?B?VUZNdVZOQU5CV0EvR0l5ZWt3NU95MC9iazNEdzc2amdkY2s2NERVZmNvUFF5?=
 =?utf-8?B?d2E4a2s0Q08zWitCelc3L0ZIM3FlN2hSWG1UenRpcjhGNTgycEliY0g1L3Q2?=
 =?utf-8?B?RUtxcjNGSWtzM201bk1PMTZuUklsMlR3NnpsQWx3UTFqZXNmVnFMamJBVmNO?=
 =?utf-8?B?a0lQdHJPQWVHRDRidCt5ZFI4OGxuYndBbStURkY4SU1XRC9vUXBteDlYOFZh?=
 =?utf-8?B?dURyQ0w3ODBhd3prMFZnZEw5bVNOTzlqVGZITElKQmUvcGdnRHkwMzkvV3FZ?=
 =?utf-8?B?RXYxQ0ZVamxQUkoxYm11UnZqL0hKamxuK1VGdml3M0RpTWd3Z0RXUGx2OUNS?=
 =?utf-8?B?d0FDUlN6dS9UMGczSG5rVTU4emF0Tkl1MU8wMTJGZk4vNndvaVlBOEY1QjJz?=
 =?utf-8?B?d2FQZXM2UVU1ejhrWURVMFE5NStPTGFsSEVyVDBKbW1ycnVRT3NBZ2N4djhw?=
 =?utf-8?B?ZzduMjJaYm1NN0ZrdkRicktldWtvMXUrRkk2V3A5TnprcDlFdXVGSXFaRXFy?=
 =?utf-8?B?MUYzcG5NRjRDc25DTlAyY2lCbWdleTN4Vk90YVZSYnJ2N3ZOdkJEL1lQbG40?=
 =?utf-8?B?ZlJpUXZKVEpHZnk3dURTSzRLZnlZU29yelR3cm1pZDB1Y09zaHMvblNzbWtB?=
 =?utf-8?B?Kzg2SzZiMWdVZzhDWXZoTm1UMlVtcjdTd1Fjci9CZGRicDQzU29nUmFDZDVZ?=
 =?utf-8?B?SFQxTEQ2MXRHbjZrcVNnK0hldE81a1lMVGtvNjFveDVZc3QwQjFSNVVTaUVn?=
 =?utf-8?B?UXp5U1h6NVcvUFZCSVhEdE9pZlRsZGxnRURnNEVhTld3QXhTMFNROTdsd1k2?=
 =?utf-8?B?SEpIRFVsM1N1TDRGVzVqcWVDVnliSWpCell0aU9KbVNuRGFUeVFmU2NNU3Bm?=
 =?utf-8?B?cHU2eGR1TTdWcTJRWWdoUWNsZHF5MFQvQTZqK2xHSUh1eDd0cElzRFFiaFJO?=
 =?utf-8?B?ZWxLcDRqYWRPa3BYc2ZTakkxVVhNdC8vdTBnbXkwWVFnSTc5dFk5ckpTS085?=
 =?utf-8?B?alBra3VybTN0T0dtRExkdEpBMERzSW9XUWpqamVhZTZwTkFYSWxqQUJrb1pC?=
 =?utf-8?B?Q1g3TDMvZ0JlbjhydldnMHIweHlkbkVxbFVpVnV0c21BQ3VsZ1JqVmJoV3RP?=
 =?utf-8?B?c2JyMVFYRmw2QWdvWis4WXdTaU00VkR6VFdycEQ1aCthdnVBRC85VkxmY21B?=
 =?utf-8?B?ME1rNWxsS1NsRTJQekNEN1d2OUdtQmw3VER1Y1ZrcWlNVWJKdm1JMVpmbUJp?=
 =?utf-8?B?TitoZGczQzFoYm43ZkNubVlIWjcvK3B0VUVYZ21zTU1vd0IvSmlSOE5LU0c2?=
 =?utf-8?B?ZUFNY3pkY2F1eElpU0htSU5KZEo3MlJZZUNoUDZKRDhKSHZaaGhSNUpVMm8w?=
 =?utf-8?Q?0n+f3XTu+xl8Er19GkTephM4lJPlNcR/aoR5F1N?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3BD5E2502B90649A4807B515A79FF46@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be9da8fb-8fcc-4185-d10b-08d987d6167f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 07:59:41.8802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L4ambC85Gn1kXrHnLDt/7StFpSKlqxPl7LNLJplo8tQgpjQRfTayhvChomcP1th6ljyO0C90zKEfIpfjUq6sKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGludXMsDQoNCk9uIDEwLzQvMjEgMTA6NTcgUE0sIExpbnVzIFdhbGxlaWogd3JvdGU6DQo+
IE9uIFRodSwgU2VwIDMwLCAyMDIxIGF0IDEyOjQ1IFBNIEFsdmluIMWgaXByYWdhIDxBTFNJQGJh
bmctb2x1ZnNlbi5kaz4gd3JvdGU6DQo+IA0KPj4gRm9sbG93aW5nIHlvdXIgZGlzY3Vzc2lvbiB3
aXRoIFZsYWRpbWlyIFsxXSwgZGlkIHlvdSBjb21lIHRvIGENCj4+IGNvbmNsdXNpb24gb24gaG93
IHlvdSB3aWxsIGhhbmRsZSB0aGlzPw0KPiANCj4gSSBoYXZlbid0IGdvdHRlbiBhcm91bmQgdG8g
cnVubmluZyB0aGUgZXhwZXJpbWVudHMgKHNob3J0IG9uDQo+IHRpbWUpLCBzbyBJIGludGVuZGVk
IHRvIHBsYXkgaXQgc2FmZSBmb3Igbm93LiBVbmxlc3MgSSBmZWVsIEkgaGF2ZQ0KPiB0by4NCg0K
WWVhaCBJIHVuZGVyc3RhbmQsIGl0IHRha2VzIHNvbWUgdGltZSB0byBmaWd1cmUgb3V0IGhvdyB0
aGVzZSBzd2l0Y2hlcyANCnJlYWxseSBiZWhhdmUuLi4gOi0pDQoNCllvdSBoYXZlIFZsYWRpbWly
J3MgUmV2aWV3ZWQtYnk6IHRhZyBzbyBJIGd1ZXNzIHRoaXMgY2hhbmdlIGlzIE9LIGZyb20gDQp0
aGUgbWFpbnRhaW5lcidzIHBlcnNwZWN0aXZlLg0KDQo+IA0KPiBCVFc6IGFsbCB0aGUgcGF0Y2hl
cyBpIGhhdmUgbGVmdCBhcmUgZXh0ZW5zaW9ucyB0byBSVEw4MzY2UkINCj4gc3BlY2lmaWNhbGx5
IHNvIEkgdGhpbmsgaXQgc2hvdWxkIGJlIGZpbmUgZm9yIHlvdSB0byBzdWJtaXQgcGF0Y2hlcw0K
PiBmb3IgeW91ciBzd2l0Y2ggb24gdG9wIG9mIG5ldC1uZXh0LCBtYXliZSB3ZSBjYW4gdGVzdCB0
aGlzDQo+IG9uIHlvdSBjaGlwIHRvbywgSSBzdXNwZWN0IGl0IHdvcmtzIHRoZSBzYW1lIG9uIGFs
bCBSZWFsdGVrDQo+IHN3aXRjaGVzPw0KDQpHZW5lcmFsbHkgc3BlYWtpbmcgSSBkb24ndCB0aGlu
ayB0aGF0IHRoZSBwYXRjaGVzIHlvdSBoYXZlIHNlbnQgZm9yIDY2UkIgDQphcmUgcGFydGljdWxh
cmx5IHJlbGV2YW50IGZvciB0aGUgNjVNQiBiZWNhdXNlIHRoZSByZWdpc3RlciBsYXlvdXQgYW5k
IA0Kc29tZSBjaGlwIHNlbWFudGljcyBhcmUgdG90YWxseSBkaWZmZXJlbnQuIFJlZ2FyZGluZyBD
UFUgcG9ydCBsZWFybmluZyANCmZvciB0aGUgUlRMODM2NU1CIGNoaXA6IHJpZ2h0IG5vdyBJIGFt
IHBsYXlpbmcgYXJvdW5kIHdpdGggdGhlICJ0aGlyZCANCndheSIgVmxhZGltaXIgc3VnZ2VzdGVk
LCBieSBlbmFibGluZyBsZWFybmluZyBzZWxlY3RpdmVseSBvbmx5IGZvciANCmJyaWRnZS1sYXll
ciBwYWNrZXRzIChza2ItPm9mZmxvYWRfZndkX21hcmsgPT0gdHJ1ZSkuIFRvIGJlZ2luIHdpdGgg
SSdtIA0Kbm90IGV2ZW4gc3VyZSBpZiB5b3UgaGF2ZSB0aGlzIGNhcGFiaWxpdHkgd2l0aCB0aGUg
UlRMODM2NlJCLg0KDQoJQWx2aW4NCg0KPiANCj4gWW91cnMsDQo+IExpbnVzIFdhbGxlaWoNCj4g
DQoNCg==
