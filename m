Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9FA305320
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhA0GUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:20:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:29310 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234817AbhA0GDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 01:03:02 -0500
IronPort-SDR: kkwcBDU4X+qi/K0IjpSf1PGXZyEh496oxL/4DO54fNPPYb3W7nn03kHIx8RLVS1izV35m0mviE
 udlcglREw9pQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="244098494"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="244098494"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 22:02:15 -0800
IronPort-SDR: giLQ9MSmv/pdLmT2l/JeqTKsSpVPq4Hmg8B2mRYH03eUdZqvXFfq5KPzgPgqlkXyRvJTcAuBEl
 Yilf0U5YDf/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="369368615"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 26 Jan 2021 22:02:15 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 22:02:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 22:02:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Jan 2021 22:02:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 26 Jan 2021 22:02:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8acDckrYP/9uAD/a6+bTRkQUhFINlPYOmrAwdGvrpt+kuMkxeb3kAkjSnIWchv70qWMbUle+9oFytMjqr3vIXqvm/Pp1I4AlF2KOfgmad+ySKpHA/W+EbJ6JMyLhuqMZU75YQD/uUgxevjrTnZABav/ehrcn7NDeRlXsA5/Pp16IGnpukDhCbgpiaM8jpdi+jeWrazfRDQmby80DWaxAUl8tQErAYEoa+re+sEA48E+XCov2hqA44EDuHXkZChtt5hjQmYb0L0uc+GAfaIrKFFobk9Sqvn5PMuU67n2+Z0QNVdpmmR1Ilw9MFajcKmH82GgjUktkpXlagerAy4jxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKg1/69WosH7M9W/Y+lnCqNu8U8Bbz4g9QUCr3cAcI0=;
 b=ASiXUeAY0Na4MhuQ1SOONiby5+Gea7IBrPnaCvii+ZUIb5YBytr9UqGwWNYvPyL/JkHRdyUjJkr6eyL/RJA7yHObSeeCd3fGCAVc3pwYcu5LoW+6Uc0EvAbna5S2o1bhjCTjXPSTudp9tdSG3a54zk89QDULOm19yWmefSyDfedwq6qekP9n3aKjRFvGNd0VQfMwQuiEAPKJNVVyPeHw8wJF6JKClGp9Olb5K5h0dqJXkkChkUeKPz9Er8No5TsvORi/lszx6XmSYGdgimIjo5PJofSiUFO8KkVWAxVl1JoX8m/O8vqBX7fpJT7DOq4obJX4soiBl4llQr8niEl+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKg1/69WosH7M9W/Y+lnCqNu8U8Bbz4g9QUCr3cAcI0=;
 b=G9E6nAwQXTc1UfMW31/AfFIXpNL6UpKUXr3zf5nGqMqc+HEJFIrC5aXmUv1/IhTRXXwE+7YCemCIMR17Hs9PattqRSAPZy2z42D9CqZta8tYF8xjFnVoz38TrILQwXo7biZon7F3JSYbhBVW4lCHN0aSDlQc/uXn4uuzu/Xc0Ew=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB3511.namprd11.prod.outlook.com (2603:10b6:a03:84::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Wed, 27 Jan
 2021 06:02:13 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701%4]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 06:02:13 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "greearb@candelatech.com" <greearb@candelatech.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
Thread-Topic: [PATCH net] iwlwifi: provide gso_type to GSO packets
Thread-Index: AQHW8ywtHSecGWSmXk+L+BCYPe50eao6XkiAgAAGbACAAJjagA==
Date:   Wed, 27 Jan 2021 06:02:12 +0000
Message-ID: <3aedacff5e5c37a735a2a6da2a8042efcd530eb2.camel@intel.com>
References: <20210125150949.619309-1-eric.dumazet@gmail.com>
         <20210126123207.5c79f4c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <596880294af8224f2f28311c39491bdfa3b39f2e.camel@sipsolutions.net>
In-Reply-To: <596880294af8224f2f28311c39491bdfa3b39f2e.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e86b497c-3c8f-4cd4-ebe6-08d8c289174e
x-ms-traffictypediagnostic: BYAPR11MB3511:
x-microsoft-antispam-prvs: <BYAPR11MB3511622A7D0AF8D600E2670C90BB0@BYAPR11MB3511.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ML6uXxTnaiTMhxjIUSQIPWE04loqEKgl7rSHzWfUJKecDVhb3tz/Zfr6xXVdDcZ/kw8qiK2e2EyVkB1peyN4gCB0BMjoOkA5vswKIfmNUbBH1vwjmBv3JJ2idKe0T9csvqBBA4c/Gr5R1+3hv05iSKXutRwlkGw58NNCKVFdKpKdzmTGA0a1Igg1immEIrxZeK0pJKxz+5tUSKEXTft5ki6gn4yxjkAGbBTKP0K5pCYlrI/gr/1laA44oyUj4HMY3ANTL7VyWtujWr8GK4wfuvCGWdIFk3a8CmWfQqxTsmVQF/FY8Z76tztVgX1rkbC2ONyHWalbQBqYQgseLMxNHt7ONaMQRkmDQ+DomKrnDqPpngxAgttFiMP46TwSnvwp+vIflctw6Ncp1WG6V7zb71Capy4+3NhwuqwC2dvPW9LrTXhRFpyy5fXfNhiJC7privppIOyKic0ydO86ChuK8oQ8FFQST7t59JVHFFwELh4k+onsYFoQ7HnoKaYXol3R0pRX2vc0qYwHiIRB20QmyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(186003)(83380400001)(26005)(71200400001)(478600001)(6512007)(8676002)(5660300002)(4326008)(316002)(6486002)(110136005)(86362001)(66946007)(66476007)(2906002)(36756003)(76116006)(91956017)(64756008)(66556008)(66446008)(6506007)(54906003)(2616005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S2QyaHJjWGVuZlkyNVNXVmhhOVJiYUg3S1RLUXhtK09BblVHaGprQ1J5UW03?=
 =?utf-8?B?amJ3ZTNzeEoxYnBCMnMrU2MrdHVUbzVDVENvT0JVMXBadVlSLzRnNXJrdFlY?=
 =?utf-8?B?QVlORE9mVllDditwUkxudGREbExVSm9NWkxNM21yZGdBWStoc3EvVnllQW5I?=
 =?utf-8?B?WTVIeEUrZnVubWJxbmdUNUxIWW5vdEpKNEpLd1BiVGdvb0d5WVVRQS9xU0Jz?=
 =?utf-8?B?b28wR1ltaTF0cVk3NUVmbVhIMnNwVi9CT2VKc1lJdUJZYXRkU3BKRWowMGJ0?=
 =?utf-8?B?N0tiU1hnTW5KYk9sZGJoM0hXdkIyL3NiS1QyTWFESXMvbTNtaXo1Y2JWaXFa?=
 =?utf-8?B?NjZaY28xb2k3UzZzRllSVjVBUGhUWG8rajdZRzh5cnc2aTIrYXJEMFpyQzdZ?=
 =?utf-8?B?TFI1TWRWSmoveEZDN0E2ODJNK3FVSkdKbUJZRFM4SG9mUjM4aFNwUVNFRWxF?=
 =?utf-8?B?SitQSDZBOVdpVjlDYnpQdGlmeW8yM2VCSGZBZ3Y1OVVic2svN3lwYjRacDFx?=
 =?utf-8?B?Z3VuVkkxVDRTd2ozWGNZY0hma1RubGQ0dkt6bnBmMGl0bzl5TUFUVXJYbGtO?=
 =?utf-8?B?ZEJ5bmtITDlsUUF6enFSYU5kMklBb1d5MmQxdnF6Vk02eVp1Z2syclQzK2Nx?=
 =?utf-8?B?elVIR0EzaWhJNEJ3MXEySVJoVVg1U3hoZmhqdkhTWGcrekJEcWtCYVFwcXpo?=
 =?utf-8?B?QUEvYy9HRndhU0ZqN29EbVA5V1J4REUzcXcrME1rRFUzd0l3QzVlcFNjaEI2?=
 =?utf-8?B?Y1h6Y0drVHFOTlBmQWkyWFN0RXZ6NkpCam9uNTFPSVc2aFpNaGRiajVsZXhE?=
 =?utf-8?B?d0dmU2xXVkZ1Y0R4V1RVRm1QZGY3RlZzVzA5OVV1RTNJYVRTOUMwbm5WOHl4?=
 =?utf-8?B?L0dwWjF5NUxhcThrK1R4Sm9BWDFTTTNNWmwxcDNiU2FMcjRqQ1AwOTJNdWh6?=
 =?utf-8?B?NTczcHZMbGYxZENSeU5VcGhFYTZTQUpVMkJ1Q1VrUVkzNGFGZlgyamxKV0tU?=
 =?utf-8?B?Z3RZTnUrYzlPOWFJTGx3V1hwT0pnYk00U0UwdStiaXVrNnZYWUdlc3RtV0Z5?=
 =?utf-8?B?T0tEbEdrSE1PRjUyZ3BPSk82aFVFbjJUeVpreWVVeEsyY3REQmZCd1BDOWtQ?=
 =?utf-8?B?c0QzeWl4T01Kd2lyU1E4SVYrUXpjWExraWpadG4yUkxYOG5nTlBnOXp4SUty?=
 =?utf-8?B?bUlMVFh4V3hwamsveFV1aGdRajAzN1dMVUV3WGZUUktwYnFUVzRVaVhnYndS?=
 =?utf-8?B?UVFEUmtqVzFaMWQxUjhYaU1XN3AyYTFzTnFQNmM4K01lRWhWQW5JMzlpbkFI?=
 =?utf-8?B?NFo4c1pwbkdvUXFOQk1NNlVRU1dhZUNRTENQZDBsNEdSS2pobkE3RnZycFh6?=
 =?utf-8?B?TEszSlNoclVLNFBNMDJscHZQMG1ib1A2QTRXaWNPcjFQVDBXZ3ozeDE0RHJ2?=
 =?utf-8?B?dGFpL2ZubGMraFNHU2NGN1hGQU9BU1BoMElHcUJ3PT0=?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <52D891BA238F8B4E99CEF28CEA3EABD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e86b497c-3c8f-4cd4-ebe6-08d8c289174e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 06:02:12.9212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhLDa0rXo7+Xz2LSc7aeRKn1iABwqghRH4HHT2gz1eCuiwjdYVct9svyz8xrfQ8hWFhE0LYxk2abgtYAl9+vUIqQ05TOWJdpUAjN2ULfpEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3511
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTI2IGF0IDIxOjU1ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUdWUsIDIwMjEtMDEtMjYgYXQgMTI6MzIgLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3Rl
Og0KPiA+IE9uIE1vbiwgMjUgSmFuIDIwMjEgMDc6MDk6NDkgLTA4MDAgRXJpYyBEdW1hemV0IHdy
b3RlOg0KPiA+ID4gRnJvbTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KPiA+
ID4gDQo+ID4gPiBuZXQvY29yZS90c28uYyBnb3QgcmVjZW50IHN1cHBvcnQgZm9yIFVTTywgYW5k
IHRoaXMgYnJva2UgaXdsZmlmaQ0KPiA+ID4gYmVjYXVzZSB0aGUgZHJpdmVyIGltcGxlbWVudGVk
IGEgbGltaXRlZCBmb3JtIG9mIEdTTy4NCj4gPiA+IA0KPiA+ID4gUHJvdmlkaW5nIC0+Z3NvX3R5
cGUgYWxsb3dzIGZvciBza2JfaXNfZ3NvX3RjcCgpIHRvIHByb3ZpZGUNCj4gPiA+IGEgY29ycmVj
dCByZXN1bHQuDQo+ID4gPiANCj4gPiA+IEZpeGVzOiAzZDViNDU5YmEwZTMgKCJuZXQ6IHRzbzog
YWRkIFVEUCBzZWdtZW50YXRpb24gc3VwcG9ydCIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFcmlj
IER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+ID4gPiBSZXBvcnRlZC1ieTogQmVuIEdy
ZWVhciA8Z3JlZWFyYkBjYW5kZWxhdGVjaC5jb20+DQo+ID4gPiBCaXNlY3RlZC1ieTogQmVuIEdy
ZWVhciA8Z3JlZWFyYkBjYW5kZWxhdGVjaC5jb20+DQo+ID4gPiBUZXN0ZWQtYnk6IEJlbiBHcmVl
YXIgPGdyZWVhcmJAY2FuZGVsYXRlY2guY29tPg0KPiA+ID4gQ2M6IEx1Y2EgQ29lbGhvIDxsdWNp
YW5vLmNvZWxob0BpbnRlbC5jb20+DQo+ID4gPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnDQo+ID4gPiBDYzogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5l
dD4NCj4gPiANCj4gPiBKb2hhbm5lcywgRXJpYyB0YWdnZWQgdGhpcyBmb3IgbmV0LCBhcmUgeW91
IG9rYXkgd2l0aCBtZSB0YWtpbmcgaXQ/DQo+ID4gTm8gc3Ryb25nIHByZWZlcmVuY2UgaGVyZS4N
Cj4gDQo+IEkgZ3Vlc3MgdGhhdCByZWFsbHkgd291bGQgbm9ybWFsbHkgZ28gdGhyb3VnaCBMdWNh
J3MgYW5kIEthbGxlJ3MgdHJlZXMsDQo+IGJ1dCB5ZXMsIHBsZWFzZSBqdXN0IHRha2UgaXQsIGl0
J3MgYmVlbiBsb25nIGFuZCBpdCB3b24ndCBjb25mbGljdCB3aXRoDQo+IGFueXRoaW5nLg0KDQpZ
ZXMsIHRoYXQncyBmaW5lIGJ5IG1lIHRvby4gIEp1c3QgdGFrZSBpdCB2aWEgbmV0IGFuZCB3ZSds
bCBnZXQgaXQgaW50bw0Kb3VyIHRyZWVzIGV2ZW50dWFsbHkuDQoNCi0tDQpDaGVlcnMsDQpMdWNh
Lg0K
