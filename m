Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862C1416E39
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244872AbhIXIwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:52:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:28072 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244334AbhIXIwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 04:52:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="287701730"
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="287701730"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 01:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="559209175"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 24 Sep 2021 01:50:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 24 Sep 2021 01:50:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 24 Sep 2021 01:50:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 24 Sep 2021 01:50:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 24 Sep 2021 01:50:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0bKVXeSuWnIe1EqrLb3Trh0K1jrVv+RWQJtToArjvMP7m0Hqt/9kGR+lSbxxbwlSF/dDbAyOFjCZ1+OPcNYW1e7E1OjwJYDAUI0ZYtgIj1Bec148njtnwA6mhaNrD4qv3Bu9l/E6lI97HxvDPaEwJpwH3RaFzD1yyCR5xKtCj0+yLiYxAiee0AHSvRqfpGS2z9Nu5sOd/4O3c8JJ+LkQN3aNd3zHxR2JIqPof+SbYumlMwkH/6QFBkNhoKe3ojKX9ueboXHZU16ZwDlz8D8CQjI5/s+tEL7JQhA3FflbiHSp5HwYR/xTK22vzhuIT97g2D/OYGBi71dtNtpF5J7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=03UcgnKVSDiXwF5sA+rhB7RxStbJ0uBmh0bRQMfEu7Q=;
 b=Agg5R0zKLJORtnjjBhgLJ81eYvcV64NhYDN6QDZ8kcHaDYej/N5FL/UQey2Eq5Il+5+4gGdAJfeDcC7eF0lEZpLq5z0ezeVb68ZS/R7UmaPQuCdAZUQM6JhOZ/tcySBBj2Pxnl/bFn8TmY8xuKIWS02BIYonFiWEH8utbUIq3/7Exkt1pZv9Qwv0UXppHWqIGjm7nhoBc0O1mICpwYzEOefGIqRUvbz9JO+PG8F9VkgBoFEhWA0zZFTZXq40mogfDUXFVTQPryGx1yMkZKHJCNuxyJuIBDT2oUWPR2rMOszZ1ALhgp9S5AdfcyJwoFFy7Pml9XFcZ2UivsK+plpgXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03UcgnKVSDiXwF5sA+rhB7RxStbJ0uBmh0bRQMfEu7Q=;
 b=ji9Pdb9ndpDZ25bkjCIan5RTuiMAJ5c+9y7o6oKCseO+dHdD4baijSf4FW1N9a10RAVQ3sZYpbU3UcvrCZ8Wxl3qWHRzOI7oGCy0LAKv43EiczGvw2c/bXBJYWYZhynCaJlHAJh5hXbEEz1EkPFyNeXe4iHz61NOsxwytvOAH2A=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 08:50:45 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52%6]) with mapi id 15.20.4544.013; Fri, 24 Sep 2021
 08:50:46 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "vladimir.zapolskiy@linaro.org" <vladimir.zapolskiy@linaro.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "felash@gmail.com" <felash@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter on
 Dell XPS 15
Thread-Topic: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter
 on Dell XPS 15
Thread-Index: AQHXsIjSc3mRlFN9WkO3yXaqPJ8to6uyz4gkgAARlICAAABXAA==
Date:   Fri, 24 Sep 2021 08:50:45 +0000
Message-ID: <863360d037e6032773c09ade99562a7331580210.camel@intel.com>
References: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
         <87k0j6to00.fsf@codeaurora.org>
         <b2225a355ecc840cddb2b6aeb15db79624998338.camel@intel.com>
In-Reply-To: <b2225a355ecc840cddb2b6aeb15db79624998338.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ed1ef80-c5fb-435d-61a6-08d97f386643
x-ms-traffictypediagnostic: BYAPR11MB2854:
x-microsoft-antispam-prvs: <BYAPR11MB2854FB58619299A41EAB14B390A49@BYAPR11MB2854.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /81CI2opZ1dEYAkj1vlMA9EVbY4ySVNRjUfOEP5WbL/nZWFsoZIFvfDmv/lOUEAFUP3Ne60cpfrTDtl4zvjUbrpPw/zgu/WHZUqM+7JnBAoHVN+YfYlbAbrDFuI9Ljpa861aqBq+bV3mPOSntEgHgmhj/h3O7wZSmzK4B2mulDa1BLvbj0pH5RgW7He+quGFopmiXlQMib9fQkAdCj+x+Clyl8QuEey7llaVJbKKGyInsryBCnlZvROxCA2L3YRRu9/5M9TU2h3oJ8YyIa6s8n7EIaCqhC6t+a/V3mS1MPXP+1+XyykwbPbzSMD/hwtQcY8TD1J49Uvj9NZkWmb5UtS/1WjCHN8+cPkH+1NE/yYPVQ2aicZJtKEdJYWS+vo6lO8V1d/nmFoyN8m4BAhLkuQ59DGN+McEs1oa8kVn42Jpy6isIjAfUkH+PqFy05VrmI/XLQU4UYnPAkQpq9MNW9QDJyj4kq2xWS5oVYnuOosl7dRG9qJuEcQsz80jlQ8ynIw8RDrGZnO9XCbWy4sZDCrjrG14XZoPERiIh4U7K6tGTN0K5KZxhAVWNSDZ8UIOSZ7RPhjesakIp5dIyKz3LvlZfUb29hBKX2mddcPcyE5jaJPw+3HLF6U+rBvWgTK+7f/sYdp09tukgexJswjIfl0gozKUsjJeIPGi6XRoRIygda2eaCJuvlA3ZNC7acp1vGyeBkesQno3UTux6G9+GSBoMdGFNdR2OkBxVNh4wL3w67xx3J/iRNpnqu1SWowZcYGmxn0/1moE7Rjk0/q8gw3TjYV2nNf/Gzmh4ISnsGc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(54906003)(26005)(186003)(4326008)(38070700005)(8936002)(6506007)(8676002)(2616005)(71200400001)(6486002)(2906002)(5660300002)(91956017)(86362001)(66556008)(66946007)(316002)(64756008)(66476007)(508600001)(966005)(122000001)(110136005)(76116006)(66446008)(38100700002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejAxSU96a2VvRzFKWHVFcHJ0SVhrVU53bHJsOHZTb0RlekQ5ZUloUVdTUDNn?=
 =?utf-8?B?aDFBMENxc2dodk5ydWJ4QlcyWlFXKzkxUTRIN3FEb3ZpT1B2UW85UzE3MEJl?=
 =?utf-8?B?cW9tOFVWQjdOQWZPaGRjdE5wb09XSTdXbjFNeWs5aThySFZOcEJiMm4rVlUz?=
 =?utf-8?B?YlphTm9VOENFNk5LMHpaYnplU28vY2NCb2xITDdxbitpL01Tc0FibVhydndW?=
 =?utf-8?B?WE5rNEorMTd3NUFPeHFRMURpTWpzMFJGVmkxc1BRWkhLNi8xbXpGRE82dDFi?=
 =?utf-8?B?cDRxVklDNWVtMVZqakNnTWp0MXltNS96UjBNaXJvYkhnSjFka3BCNG9zSHI4?=
 =?utf-8?B?bWlwVTA0K2lUWUFBTFE0bmxsZUhaYlVSZjFYeUY5Tldtd3ErSWh3eGdrL1N6?=
 =?utf-8?B?ZE1Mb04xdHVhTUFleXc4L1ZHbU94aGt5dkZqRGxaTmpwNkc4SUZMOVNDVTNB?=
 =?utf-8?B?RktCcFlpZnJUNGtYekx4K3ozWVNiL2FxaExNS3V3OGpNa1o1RmNiNkR1VXNX?=
 =?utf-8?B?ZUZkNzJTM2MrU3dxcDFZajdiTlIzalZ4djZtZ1orVzlGeXJQNkpJTi9CRFJ1?=
 =?utf-8?B?M0hqRTlrSEh5ZWIrQUFHNVM3V0pvdThUSTkrakxpYmVIcjk2eVpTYmdDRjJC?=
 =?utf-8?B?S2swRlNVaTBLa2ZvL0IrMXhEV2pzY1dSUWdBY3NHNVVkOW5LZlpSU290cDRi?=
 =?utf-8?B?TTJrQ0VZcWlmWDdRNzJkWHhOMzJpWHhEWjN2RS9TdmhQWlJWcEF4Z1hnZ0Fl?=
 =?utf-8?B?L0ZrcGJUYmF1YjZpanJlaWZCeVZDOUlMZHYzWFFHV3k0RURPeFNicFJSc3A5?=
 =?utf-8?B?aWtwTGwraFR6TzNZQ1MzamE0YnBsZDE3R3NKRGNHa0hJQkFIbkoweXhRZzlK?=
 =?utf-8?B?M1BWbndJY29KVGVEb0x1US82WG9lU2k2YWZ5ZC9udHdBaURTRnV2RklOdml0?=
 =?utf-8?B?WnhzSXlzYTI3RTB0Y1REYmpjU01GendDaGRISldjRHd3SDQxNktqNEVFVXdn?=
 =?utf-8?B?aTZta0pyU0xYc0ZTK0lWMERiK0FQTkdnTitSMFduTlZkTHEyZEV6M2lPOUl2?=
 =?utf-8?B?VlZhWEg5MjBIT0M1c1VoTWpWTTFER1M2MWJFWXMrUDc3UzZ0SmVMMVBaM0M4?=
 =?utf-8?B?ckNTRUhEM2tCUDRFRExjaUt1NzZhczlNam8vQkVKQkp1dUU0QVF3Z3NTaG9X?=
 =?utf-8?B?UUhSVnhYUzhGalJrM0t3UTdQUC9seG1WZTlSOUdiNEQrN0xsdDI5MWlqNWM1?=
 =?utf-8?B?QzVsbVZXM1o5ODFzbzFHeXFhUHRFUU43aFpmZ3NLc3JKZzFJSC82M1RGQmE3?=
 =?utf-8?B?dk11V1FrbGY0RzdVMGlYQXcvdXJZQmRPalJIalBpMVVpbldDanBBaE9iUnN2?=
 =?utf-8?B?c3RBTW9rcDJZa2FOb1pYdGhUYzkrTjJwOGdUVkJzYXBmcCtPWTlCNDFaN2JG?=
 =?utf-8?B?TnZtRjZPYVk5SzJXNEFxcHJTbmVPTTl3MGNaTHpxQVVXUmxVRmxDRkNxNkNY?=
 =?utf-8?B?OTlKejBJUzNMZmpMVSsxMWExbUM1eDJDZ0FMa01RNFF1ME0wYUQ4MXd0ZTI5?=
 =?utf-8?B?VDNkbFRUdmwySE1rb2ZLRU0xNjBqSUNPV2pmais5Q2Y1R2U1UHQ0OFY3bmtx?=
 =?utf-8?B?S0hmWUxOV2tQc21nZDI3VVAvdGgzcEh3VVNPczkzRnBJbnVHS0daODM1VUxP?=
 =?utf-8?B?VUowNVI4OWZhUUc2a1E5SGRRY0pRR1NoTVl1NnJXZk1lanJFdit1a00yRUh5?=
 =?utf-8?B?QU8rbTRqL1J1YlYza1EzMGttaFhsTWZOSVZrSmFlT1hhZ2NHZ0dEdzZDM3FL?=
 =?utf-8?B?VVRtTVhnLzNFOSt1WCtZdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <272CB6362CAEA741BBADD5B14772E19F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed1ef80-c5fb-435d-61a6-08d97f386643
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 08:50:45.9314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ihPt/DuDaTMdNGCrW9m57G6tGEUhp15DDt2B9gG/K8gBnkN9rGDOG49F22/yXW5osdj6mKil6pPKC/4gMBADvaktuhXtGocdQf1cRmFFUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2854
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA5LTI0IGF0IDExOjQ5ICswMzAwLCBMdWNpYW5vIENvZWxobyB3cm90ZToN
Cj4gT24gRnJpLCAyMDIxLTA5LTI0IGF0IDEwOjQ2ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0K
PiA+IFZsYWRpbWlyIFphcG9sc2tpeSA8dmxhZGltaXIuemFwb2xza2l5QGxpbmFyby5vcmc+IHdy
aXRlczoNCj4gPiANCj4gPiA+IFRoZXJlIGlzIGEgS2lsbGVyIEFYMTY1MCAyeDIgV2ktRmkgNiBh
bmQgQmx1ZXRvb3RoIDUuMSB3aXJlbGVzcyBhZGFwdGVyDQo+ID4gPiBmb3VuZCBvbiBEZWxsIFhQ
UyAxNSAoOTUxMCkgbGFwdG9wLCBpdHMgY29uZmlndXJhdGlvbiB3YXMgcHJlc2VudCBvbg0KPiA+
ID4gTGludXggdjUuNywgaG93ZXZlciBhY2NpZGVudGFsbHkgaXQgaGFzIGJlZW4gcmVtb3ZlZCBm
cm9tIHRoZSBsaXN0IG9mDQo+ID4gPiBzdXBwb3J0ZWQgZGV2aWNlcywgbGV0J3MgYWRkIGl0IGJh
Y2suDQo+ID4gPiANCj4gPiA+IFRoZSBwcm9ibGVtIGlzIG1hbmlmZXN0ZWQgb24gZHJpdmVyIGlu
aXRpYWxpemF0aW9uOg0KPiA+ID4gDQo+ID4gPiDCoMKgSW50ZWwoUikgV2lyZWxlc3MgV2lGaSBk
cml2ZXIgZm9yIExpbnV4DQo+ID4gPiDCoMKgaXdsd2lmaSAwMDAwOjAwOjE0LjM6IGVuYWJsaW5n
IGRldmljZSAoMDAwMCAtPiAwMDAyKQ0KPiA+ID4gwqDCoGl3bHdpZmk6IE5vIGNvbmZpZyBmb3Vu
ZCBmb3IgUENJIGRldiA0M2YwLzE2NTEsIHJldj0weDM1NCwgcmZpZD0weDEwYTEwMA0KPiA+ID4g
wqDCoGl3bHdpZmk6IHByb2JlIG9mIDAwMDA6MDA6MTQuMyBmYWlsZWQgd2l0aCBlcnJvciAtMjIN
Cj4gPiA+IA0KPiA+ID4gQnVnOiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcu
Y2dpP2lkPTIxMzkzOQ0KPiA+ID4gRml4ZXM6IDNmOTEwYTI1ODM5YiAoIml3bHdpZmk6IHBjaWU6
IGNvbnZlcnQgYWxsIEFYMTAxIGRldmljZXMgdG8gdGhlIGRldmljZSB0YWJsZXMiKQ0KPiA+ID4g
Q2M6IEp1bGllbiBXYWpzYmVyZyA8ZmVsYXNoQGdtYWlsLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFZsYWRpbWlyIFphcG9sc2tpeSA8dmxhZGltaXIuemFwb2xza2l5QGxpbmFyby5vcmc+DQo+
ID4gDQo+ID4gTHVjYSwgY2FuIEkgdGFrZSB0aGlzIHRvIHdpcmVsZXNzLWRyaXZlcnM/IEFjaz8N
Cj4gDQo+IEkgc2VudCBhIHNtYWxsIGNvbW1lbnQsIGxldCdzIHdhaXQgZm9yIHYyPw0KDQpJIG1l
YW50IHYzLCBvYnZpb3VzbHkuIDopDQoNCi0tDQpMdWNhLg0K
