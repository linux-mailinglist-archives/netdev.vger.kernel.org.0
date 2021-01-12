Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6285A2F36CC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392362AbhALRPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:15:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:21860 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732317AbhALRPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:15:18 -0500
IronPort-SDR: nQ8ZCb4vf1SivN6FlTR9qBQ3adooGElwxDXj5kcTbmV45aUcN8FZTo4dLFfg8s8aGOeMyRIMO0
 /64G1mgHF+GA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="177299697"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="177299697"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 09:14:16 -0800
IronPort-SDR: k7zCHiA9loa0GUt88gt7jhiZDjHrAcw9fYJOnj7VYhGo8cz837nM366/ZaDg8VnIn7QJ8YxHA+
 cQwCQNlOVDoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="353103825"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2021 09:14:05 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 09:14:04 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 09:14:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Jan 2021 09:14:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 12 Jan 2021 09:14:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksBEi3yOsT12X5vxnSLtK4MMbq5wN0KX1pnPLcprHwPa4lAxcX0le+WCVbf8yZQKoz6oDKPLwjuT6zUvWnxzMP8DPlx/qLfV2PWmCDKc6+1z4//diGeiOBvOsQZQNLfZ7WOfdoQQQKJH6fXyjI8ESqBTUKpz4dvPO9DdFx3kVDdc4bNuBoxYrIVH8EYv+PjecHyFVvIDXwsKBWWGT9jBPgE/m/mEZDa8IlgzA1wRGUG507XcNtVwhWk8N7126B70mB9piO6P8nIrJZ+1AabAySJwxH1ocuUGMxX8VkxPI44OGSxlmsDBDc3jrFW8+26E/nsrsfr43SLa6W7ajq39Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDoNyLElP7e6Ko2p7PbmB4uGHguMeezXX/ZNU2sdwMA=;
 b=B9CsVZlUXvWk9T9h+8liskALAz2XEo1D1PdzWBHkYX/i3qXT0K/uvi7CW76RH4TATNnTFAKzmKh1NOhM6bM7BIapQgAgnqbsNOq0AUCst6VxD82wKf1I2qLqqifsCp00ZXXQirCoOG3MtoIbFC8vxCNPvX3TgJY/aP+bHUh/vO7Ac/kl4d/ZEFlT5GmKboNTj5jDhG7n+SBERqXVJxNKhOeoK0p2aUmyF2PhUzOBN4hI8BJWKAVrEVuLubb91yuH/L9PCvB6FIhbye7TikYyyrR0HjIJ/9EGhKsPHg8oCiCE2+KDEhAATY4kR9EfvKGLllfn7Ut8JRGPHf5j6fdGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDoNyLElP7e6Ko2p7PbmB4uGHguMeezXX/ZNU2sdwMA=;
 b=e3aVIa4GQWsZ5CMak8bjBeR+DHzbrEJ+FrC2jhS9xbgMpY8QQpHVfnv7moFy65xAPf/TcgkzQN+/uz8ThZ2VwmrBuhSDfxqFdrYaMeqKKQ5CYL3NgDeTl4AG0VAYdVRby77mBpE6Mhxb1BDZDaB272jJn1N30zcstyKjj8C7d0Y=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB3432.namprd11.prod.outlook.com (2603:10b6:a03:8a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 17:13:59 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701%4]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:13:59 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "tiwai@suse.de" <tiwai@suse.de>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
Thread-Topic: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
Thread-Index: AQHW6OZZL2sg2IFFok+0mSt2v/kWxqokI7jwgAAD6ICAABMzAA==
Date:   Tue, 12 Jan 2021 17:13:59 +0000
Message-ID: <636fdc5b53b6f4855e25981e0454064524e6905d.camel@intel.com>
References: <20210112132449.22243-1-tiwai@suse.de>
         <20210112132449.22243-3-tiwai@suse.de> <87pn2arw69.fsf@codeaurora.org>
         <s5h4kjmqgxw.wl-tiwai@suse.de>
In-Reply-To: <s5h4kjmqgxw.wl-tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c7e74b4-a230-4402-14b9-08d8b71d73a8
x-ms-traffictypediagnostic: BYAPR11MB3432:
x-microsoft-antispam-prvs: <BYAPR11MB343258C981BA13116CCD1D8C90AA0@BYAPR11MB3432.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lv05Lr4c3jh+lBAiIrvrodYTbvT5kJz3R0kT1zQuWFTtxQQ6x6P1IB/OQFeOUuawEPvnsh/7U0vrLYHXYe0MsWZwGIUkcz4KPE/4GQ10MKrC7jWThYJmBh6fIyfiC2PWXiD6Q4LWUL1PoSo2OFJ79tFxFjTgPQOxYErK+EjtWRZk+yc/G6vSX6G63ApGw+vlcoLMtM1b8tiSETatEqeNGYyowv7gPJ2ylrXdXs9OGf4Cj89YMihpNgaykg7D6focqtmxzonpAvX6gsLgCfeN3zlvZ57hQKjDj2QEMTNNAyBbF0YwXkdGmia2/c3Pnk2YuOOhMnpClUrRmRZfxTJqEHnlwOPutt/B1L+F9qox/B84byHgoenqj8yZTzH1bGroJUDhv7OEL+FqzFPHm7E+dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(71200400001)(54906003)(76116006)(83380400001)(110136005)(4326008)(66946007)(66446008)(91956017)(6512007)(478600001)(66556008)(316002)(86362001)(66476007)(36756003)(64756008)(8936002)(6506007)(186003)(8676002)(2616005)(5660300002)(2906002)(26005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NkZOS2lZZFpkblZJRU80M0gxWm03d2l1a2xWSkJsMHp4TW02MXNHY2xiam00?=
 =?utf-8?B?elhrTmRKYmFteXA4Sm5sNkVzZmF4cjNWQW1JdFB5Q3FCL0FocE9NQkRJWjE3?=
 =?utf-8?B?S0Y1eG4wc01RKzAwU2dEOW82bVZPYVFFTHBXQ0ZsY293d2VWam00M0haMFZh?=
 =?utf-8?B?V0NQSXQ5S2srd2syUUVrc3NJa3lhWDlRdVlteWpMSTArc1YwRXo2UFRKSmVs?=
 =?utf-8?B?Y3VEMGF5M1FQRVdxZFExajNtWStoc1BHWWhFcHFEU1FlRGFmUjg2YmVQYnZh?=
 =?utf-8?B?YXd2N3d6YlM0RFhjUW5rZVFISDhMQ284QlFpcHRMVmVXUzVUc2hLUlp2alhu?=
 =?utf-8?B?dGp2aXhKb2QrUTNWNXRWVHVLRVRxM0FSSTg5ZFU5Q0FxckhkUXNwQ1NtZTNl?=
 =?utf-8?B?TkNnRkM1cnpRcmF1Q0syRzlrMTZBZjJUc1pOLy9tR3UyQmFpSnBQempXWE9O?=
 =?utf-8?B?TkMxT1N6V2duRWoyUXorQlNvUVcrVWdqQk1KNncyKzFoVWQ2aEhqQ2hKR01G?=
 =?utf-8?B?RHBvV3YxVXdXZXlIYnhrUWZLTFVhMjJqUE1Cank2YlV4Z29qMnR5NVpmaEdl?=
 =?utf-8?B?b1FFOUlZYzZjVUlJa3NYYS9yaXRJNk42cHJGNXZDcVE1eDNKREpJMWk5UkFm?=
 =?utf-8?B?aHlkODczNGNyZGNZc1o1VDI4TFQ3Zk1GQk4xc1NZdzVoenBPelZYWnA3RVRw?=
 =?utf-8?B?OUxiS1M3WGZ4OTgxek1FWnVkNkZkZjR6T2R0WUV4bG12Q3RDWXFIYUdPdTMx?=
 =?utf-8?B?TVpTankxUDlnMHVlaEZNZW9TUGtGaGVmQ2t1NEFMNGJibDkvVkhyMklZZk9K?=
 =?utf-8?B?bWdkSUpQeEt6eUNXaGROUTdiK01jb1Q0VDRkUVEyMlJNZUFvd0xmdVUrYXdk?=
 =?utf-8?B?RUxJNXJ3cnZEbEpaVEdBbEVUakY3dEVlTDdhN1pqdHVIOWR2OEJqeXd3b3hO?=
 =?utf-8?B?T2MrN0owblVmMFJxdjlTUzdiNFc5MjgvK2twSlJ6MVRNLzM4MmZxWktnWG1o?=
 =?utf-8?B?Vk9nZlA0NE9vZ2lGVHdxVDgvbENvRmliRkpxOE5EVm9vR2JoWk1jRG4yODNj?=
 =?utf-8?B?N3FYY29Oa2p3STkxam9GQ05IYTFZcDBGUEMxeW42RU9hYUw4YlZlNThPRStj?=
 =?utf-8?B?aWNwM3c1MHFHZEc0MTVXcFNsOUFPblJFMGZBWGxrUU4zN2RNUHFwb3ZhYTNW?=
 =?utf-8?B?cUE3WTNONHozTUlycGRydXdaWHNkajdiU2VYYUtJNTJINFZlYzJnQ1c2NnFr?=
 =?utf-8?B?V0VJMkd2czFFTVhjV2dlNm5yWjhLVnh6bTJFQTJjZk5nMWZaWHJsNGp6MWJ4?=
 =?utf-8?Q?qf94UZGDZpshb+7HcuAETU/pMv+ptzH4Xp?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A3B81CD5E671E43A67E9151FAEB8927@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7e74b4-a230-4402-14b9-08d8b71d73a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 17:13:59.4355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDkUcrysUVKNrj9+row3zvh+U26SAgGG/L7GcjqWS0v+Wtyq/huaQhkJlt3cmMqzDkD8OmSoH5n4qZZtMBHQv1dqvqQKgiJ1i9T99jcS5Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3432
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTEyIGF0IDE3OjA1ICswMTAwLCBUYWthc2hpIEl3YWkgd3JvdGU6DQo+
IE9uIFR1ZSwgMTIgSmFuIDIwMjEgMTY6NTA6NTQgKzAxMDAsDQo+IEthbGxlIFZhbG8gd3JvdGU6
DQo+ID4gDQo+ID4gVGFrYXNoaSBJd2FpIDx0aXdhaUBzdXNlLmRlPiB3cml0ZXM6DQo+ID4gDQo+
ID4gPiBUaGUgdWNvZGUgVExWIGRhdGEgbWF5IGJlIHJlYWQtb25seSBhbmQgc2hvdWxkIGJlIHRy
ZWF0ZWQgYXMgY29uc3QNCj4gPiA+IHBvaW50ZXJzLCBidXQgY3VycmVudGx5IGEgZmV3IGNvZGUg
Zm9yY2libHkgY2FzdCB0byB0aGUgd3JpdGFibGUNCj4gPiA+IHBvaW50ZXIgdW5uZWNlc3Nhcmls
eS4gIFRoaXMgZ2F2ZSBkZXZlbG9wZXJzIGEgd3JvbmcgaW1wcmVzc2lvbiBhcyBpZg0KPiA+ID4g
aXQgY2FuIGJlIG1vZGlmaWVkLCByZXN1bHRpbmcgaW4gY3Jhc2hpbmcgcmVncmVzc2lvbnMgYWxy
ZWFkeSBhIGNvdXBsZQ0KPiA+ID4gb2YgdGltZXMuDQo+ID4gPiANCj4gPiA+IFRoaXMgcGF0Y2gg
YWRkcyB0aGUgY29uc3QgcHJlZml4IHRvIHRob3NlIGNhc3QgcG9pbnRlcnMsIHNvIHRoYXQgc3Vj
aA0KPiA+ID4gYXR0ZW1wdCBjYW4gYmUgY2F1Z2h0IG1vcmUgZWFzaWx5IGluIGZ1dHVyZS4NCj4g
PiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogVGFrYXNoaSBJd2FpIDx0aXdhaUBzdXNlLmRlPg0K
PiA+IA0KPiA+IFNvIHRoaXMgbmVlZCB0byBnbyB0byAtbmV4dCwgcmlnaHQ/DQo+IA0KPiBZZXMs
IHRoaXMgaXNuJ3QgdXJnZW50bHkgbmVlZGVkIGZvciA1LjExLg0KDQpBY2tlZC1ieTogTHVjYSBD
b2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KDQo+ID4gRG9lcyB0aGlzIGRlcGVu
ZCBvbiBwYXRjaCAxIG9yIGNhbg0KPiA+IHRoaXMgYmUgYXBwbGllZCBpbmRlcGVuZGVudGx5Pw0K
PiANCj4gSXQgZGVwZW5kcyBvbiB0aGUgZmlyc3QgcGF0Y2gsIG90aGVyd2lzZSB5b3UnbGwgZ2V0
IHRoZSB3YXJuaW5nIGluIHRoZQ0KPiBjb2RlIGNoYW5naW5nIHRoZSBjb25zdCBkYXRhIChpdCBt
dXN0IHdhcm4gLS0gdGhhdCdzIHRoZSBwdXJwb3NlIG9mDQo+IHRoaXMgY2hhbmdlIDopDQo+IA0K
PiBTbywgaWYgYXBwbHlpbmcgdG8gYSBzZXBhcmF0ZSBicmFuY2ggaXMgZGlmZmljdWx0LCBhcHBs
eWluZyB0b2dldGhlcg0KPiBmb3IgNS4xMSB3b3VsZCBiZSBhbiBvcHRpb24uDQoNCkl0IGRvZXNu
J3QgbWF0dGVyIHRvIG1lIGhvdyB5b3UgYXBwbHkgaXQuICBBcHBseWluZyB0b2dldGhlciBpcw0K
b2J2aW91c2x5IGdvaW5nIHRvIGJlIGVhc2llciwgYnV0IGFwcGx5aW5nIHNlcGFyYXRlbHkgd291
bGRuJ3QgYmUgdGhhdA0KaGFyZCBlaXRoZXIuICBZb3UnZCBqdXN0IGhhdmUgdG8gdHJhY2sgd2hl
biAxLzIgd2VudCBpbnRvIG5ldC1uZXh0DQpiZWZvcmUgYXBwbHlpbmcgdGhpcyBvbmUuICBLYWxs
ZSdzIGNhbGwuDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
