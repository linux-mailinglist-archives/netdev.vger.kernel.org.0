Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708C42D305F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgLHQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:59:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:20308 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgLHQ7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 11:59:37 -0500
IronPort-SDR: uoWO3ACqG80BDfOYmswGG9Lr/KZas+bSJ/RJ4E6g+RkJvoTnD5ids04/QsI5jzcAS/j6WHyGqw
 g2RuYGOTQy9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="160976213"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="160976213"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 08:58:56 -0800
IronPort-SDR: qlptI+akGD56CCH2n2/YwXzQ2rr4tVUIKlEgeDTxMBj66LWqdfSspFBH3R3C5UPPQ9d5fNWHfq
 Aqy/uOVhzS1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="542075966"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 08 Dec 2020 08:58:55 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Dec 2020 08:58:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Dec 2020 08:58:55 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 8 Dec 2020 08:58:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR4OR4I1v6God+Yl4fkeutoyErHV3MAqBmO1RgmTxJYAEUKLoj9T05RXCTvsxN/SQjh+hcHbfmBvaKrWNZ6vAWBr5ixDhsGZWADVIdKJoWJ0Hc9GH+8WtDkRK2haJWFa/YaidS97x7pPd5VhaFS4unyCoMHSfAdrrzgoGkGoV8y9uwH/WVmIDngidYK/nh1HG/m3U8pu5grrwg/mMNLEmQZmqptwpGcppUUtfAyFnPgjXbJyyb3qb8U38u+i50DbUREiAdFaTeZn+64bk0zejqoNIJIikYJbeo1ENwxVZ1jwqJrGLhKA29H5I1HM3+uh94b/Ftkq/bvWipze5Abn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7SJGGIJBKbWuP+u8kvDddF+hRgzk0pMzseW+oixZHc=;
 b=C7/e9ycKxScCmICQduIDJ5xMMj8lPepmFjmVOmvifz8KMgQV+tQMxGzGDeJgBKRZyqBfM6CVMul+kPgy22tl1YX3RR35aeRh7251yCw+OxHAzR42vbPSt8dr6J9lzt0pwFo7l9tdpWbdLde8eszlxoMUFacZQWcsGgb0oG7fPzxkFnUP+O1PbS4b4cSm3huZcv24ZeAovLWWJnWRJ9XXQh/Es26m3pMMIx0IovRIPMc04pWGatM12n3JOJ30gQzLCkFoRaAuPe2Ljj+uSjQy2VJPFVxlTdEKIfzG9BhGGeLglrwhKnDbLXrXjVijuvcVul0vYwecIDM/WqueyIrFuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7SJGGIJBKbWuP+u8kvDddF+hRgzk0pMzseW+oixZHc=;
 b=OdHxmpULwOnR+8kFzGJhVAucqcwDXOqnmBmuXazGp6CFaLTQAICN+IBt7sgBo81aUZ80M1JvcKBsStKXJlCftS0femhcv2LU8SKcjpzQJNe5IE1E37A2HbvnYUT6JyeIqm2wyMDDorimngXLaAO9zjAVzUk0a0RgiWK/0+zmjeU=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3006.namprd11.prod.outlook.com (2603:10b6:805:d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 16:58:53 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3632.024; Tue, 8 Dec 2020
 16:58:53 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next v3 05/15] ice: create flow profile
Thread-Topic: [net-next v3 05/15] ice: create flow profile
Thread-Index: AQHWugZDQ0KUjLzWCEaF3FhqdKPwsqnGvQ6AgAsNTYCAABK5gIAEjaeAgAAeq4CAFwldAA==
Date:   Tue, 8 Dec 2020 16:58:53 +0000
Message-ID: <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
         <20201113214429.2131951-6-anthony.l.nguyen@intel.com>
         <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
         <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
         <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
         <20201123152137.00003075@intel.com>
         <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7797bbc-58f4-4299-04c4-08d89b9a8b08
x-ms-traffictypediagnostic: SN6PR11MB3006:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3006E174CC6772B4F1C3BDFDC6CD0@SN6PR11MB3006.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tlhZhTr+sxJMCegUZcU/izEI08VcHKL2O209f+cGwyFq/MYMF3HybPYkngavVeadZcR4mR9rKo8V/923cuLGNx0gQVFKSjuiqDS3YPP0cpvVKSF/8QvvIHO20Imy31r5TD/aBL4jTgn/e2mQTUPURlBoJkxhuROwKcfAGRoO7e2NAdc56uKqttjI1wJOgBMpl6IyKsf6TlfmXK3sew1sHCecbPAiurUgTd0yx/KUKfyfHzbseYcGXn5Q/+CkVI+T6NSrK68ja4Bm/8Gc/j+uOm12nA9EUDDV6jQebv7IF9NDlai+wPJni85joZGHyFPFApXfkvqoXLJR9uOzL8mx+ReRCvzqIpkjqzgCmi+4PM7rFe+BQl83XJcKTuLf2cwK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(54906003)(36756003)(66556008)(66446008)(86362001)(76116006)(508600001)(4001150100001)(83380400001)(66946007)(53546011)(6506007)(91956017)(4326008)(6486002)(71200400001)(2616005)(8936002)(5660300002)(66476007)(26005)(6512007)(64756008)(2906002)(186003)(8676002)(110136005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Vk1BSHQwaTI2MVdLSUdIL3VjR0pma1JBcmNKUlF4Rm1YYVNHZjVDK0d0VXVh?=
 =?utf-8?B?V0dkOGszTU9qR0V5Qk1SUFlrdnJBR3JtZkJYbExVLytmOEJnVWh6K2U3NFVL?=
 =?utf-8?B?QWhrSUFvMFVrZ1lZVi9uZkZDektMSzdhZHJScTdJWVZpZ1UwNC9ubXY1Wk1i?=
 =?utf-8?B?TUZzZ2NXbjVkeURyNjkycGU2Z0lkRVV5RklEcnl3R2lHeXpCRE5RTGRSZm5V?=
 =?utf-8?B?elBrdTBZelY4UHVQdjBOeTJYNm85NE5WdzI2Sy9CY2dEN242c0tmQ0wxd0Fl?=
 =?utf-8?B?NVlJNzJoNHl5cjlNa3g0dWJlR1FLM2NhaHB6VkFvaVFTdDU3ZTloU1Jpa1NJ?=
 =?utf-8?B?VDRBdFl0MldMdWlKc0ZyMkthekpvTkRrY3hyTjJFV1FBQUNvVG55cmUzcmZF?=
 =?utf-8?B?R0VWRnc2OG4xbEd4MXBjcGdGY1pBZVlHNFA1NTRHVzZscENVMUltKy82S1lF?=
 =?utf-8?B?b25JM2xudElyTjQrb05VakxIMVdXbEtBdkJ1bzcvVUoxUzRDVm8zTzFBaGxU?=
 =?utf-8?B?c21UblpsUkRkYzFjMVJsdlJWbm5KNi9BUnhvUE9jNmxyUkRGakFOMUY5YTR2?=
 =?utf-8?B?cTdFTS8rYkVxeThmM1o3ZWlyYUs4Wm82Mm1ZZTBXdlpCL2ZoZGl6WSs5L1lD?=
 =?utf-8?B?NXU2djY2ZEc0d052WnJJd04zZkxpNDlaNEVkQ3loQ3Y0VFZoSDVhbHQ1SmRq?=
 =?utf-8?B?SFo5SVVmQ3RHc0Z1akU5R1M5eFkvQlpjRlovdjhJakNWWE03dU9BdVlJK2Jz?=
 =?utf-8?B?REJRN3UyYVdXbUVRVDJoR3hvbnpkRWIzWm53YUVLeCtHYTN6RU5NY3pTWkhy?=
 =?utf-8?B?UXdlZ2FnMG4wV3hEVU9DaXc1WU1WdnZPWVBKM0N5aDVqUXVxV0hBS282K3JS?=
 =?utf-8?B?OGJldWdqNFIvak85YnBQLzV1dGVrbDlhWHNtdGNBb05WSTZNdEhwbEl5NGRK?=
 =?utf-8?B?Q3llU3VZNWRuay9EcjhhdEZ1ZGdTcG9IYUZiYk5jYjg4YnJBNGd2NWFvakRk?=
 =?utf-8?B?c1ovaWRNSVdFbHRJczhTSmNTM3NoR2tKK2Z1RGpBWkJ0ZkUrNm84Yk1jaklG?=
 =?utf-8?B?RlJIV1JpTlppR2FHWWR6NGV6Y0Z3RkFqSWVWZ0FRMWtUSGFnV015c0FkWHNk?=
 =?utf-8?B?UmtKL2U3TnR1UUdwcEtVUGRVUUpsaitNTDRUWnJ2djMvZWNCMXZNZHJpdE9E?=
 =?utf-8?B?Tm1kL2hLbDI2VHgvR0RQR3FNcHFEbXdsd3RkbjBtSHB3aFpIbVEzYWlWYnpJ?=
 =?utf-8?B?YlQrR2psNWtvUnAxT0RiYjhhd21nYWdhMHBQTDdKRXRGQWdZYWNTVklRMU81?=
 =?utf-8?Q?vRjfg2Y8Ug/F4evssZ4l44oaT/Fhp3+skw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C3F5763D185094EBC3CF3EBD825C887@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7797bbc-58f4-4299-04c4-08d89b9a8b08
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 16:58:53.0913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /VFh+pbT3GOBWIeVlvL/M+L9L/qq4QgFLBI0/yKx3WQEyxHmXzsNUMmIQAQCfSAnysVpzJraPDQs7UyRRCVSfYIkBDoz/KnFP6vEZ+2whhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3006
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTIzIGF0IDE3OjExIC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIE1vbiwgTm92IDIzLCAyMDIwIGF0IDM6MjEgUE0gSmVzc2UgQnJhbmRlYnVyZw0KPiA8
amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFsZXhhbmRlciBE
dXljayB3cm90ZToNCj4gPiANCj4gPiA+ID4gPiBJJ20gbm90IHN1cmUgdGhpcyBsb2dpYyBpcyBj
b3JyZWN0LiBDYW4gdGhlIGZsb3cgZGlyZWN0b3INCj4gPiA+ID4gPiBydWxlcw0KPiA+ID4gPiA+
IGhhbmRsZQ0KPiA+ID4gPiA+IGEgZmllbGQgdGhhdCBpcyByZW1vdmVkPyBMYXN0IEkga25ldyBp
dCBjb3VsZG4ndC4gSWYgdGhhdCBpcw0KPiA+ID4gPiA+IHRoZSBjYXNlDQo+ID4gPiA+ID4geW91
IHNob3VsZCBiZSB1c2luZyBBQ0wgZm9yIGFueSBjYXNlIGluIHdoaWNoIGEgZnVsbCBtYXNrIGlz
DQo+ID4gPiA+ID4gbm90DQo+ID4gPiA+ID4gcHJvdmlkZWQuIFNvIGluIHlvdXIgdGVzdHMgYmVs
b3cgeW91IGNvdWxkIHByb2JhYmx5IGRyb3AgdGhlDQo+ID4gPiA+ID4gY2hlY2sNCj4gPiA+ID4g
PiBmb3INCj4gPiA+ID4gPiB6ZXJvIGFzIEkgZG9uJ3QgdGhpbmsgdGhhdCBpcyBhIHZhbGlkIGNh
c2UgaW4gd2hpY2ggZmxvdw0KPiA+ID4gPiA+IGRpcmVjdG9yDQo+ID4gPiA+ID4gd291bGQgd29y
ay4NCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBt
ZWFudCBieSBhIGZpZWxkIHRoYXQgaXMgcmVtb3ZlZCwgYnV0DQo+ID4gPiA+IEZsb3cNCj4gPiA+
ID4gRGlyZWN0b3IgY2FuIGhhbmRsZSByZWR1Y2VkIGlucHV0IHNldHMuIEZsb3cgRGlyZWN0b3Ig
aXMgYWJsZQ0KPiA+ID4gPiB0byBoYW5kbGUNCj4gPiA+ID4gMCBtYXNrLCBmdWxsIG1hc2ssIGFu
ZCBsZXNzIHRoYW4gNCB0dXBsZXMuIEFDTCBpcyBuZWVkZWQvdXNlZA0KPiA+ID4gPiBvbmx5IHdo
ZW4NCj4gPiA+ID4gYSBwYXJ0aWFsIG1hc2sgcnVsZSBpcyByZXF1ZXN0ZWQuDQo+ID4gPiANCj4g
PiA+IFNvIGhpc3RvcmljYWxseSBzcGVha2luZyB3aXRoIGZsb3cgZGlyZWN0b3IgeW91IGFyZSBv
bmx5IGFsbG93ZWQNCj4gPiA+IG9uZQ0KPiA+ID4gbWFzayBiZWNhdXNlIGl0IGRldGVybWluZXMg
dGhlIGlucHV0cyB1c2VkIHRvIGdlbmVyYXRlIHRoZSBoYXNoDQo+ID4gPiB0aGF0DQo+ID4gPiBp
ZGVudGlmaWVzIHRoZSBmbG93LiBTbyB5b3UgYXJlIG9ubHkgYWxsb3dlZCBvbmUgbWFzayBmb3Ig
YWxsDQo+ID4gPiBmbG93cw0KPiA+ID4gYmVjYXVzZSBjaGFuZ2luZyB0aG9zZSBpbnB1dHMgd291
bGQgYnJlYWsgdGhlIGhhc2ggbWFwcGluZy4NCj4gPiA+IA0KPiA+ID4gTm9ybWFsbHkgdGhpcyBl
bmRzIHVwIG1lYW5pbmcgdGhhdCB5b3UgaGF2ZSB0byBkbyBsaWtlIHdoYXQgd2UNCj4gPiA+IGRp
ZCBpbg0KPiA+ID4gaXhnYmUgYW5kIGRpc2FibGUgQVRSIGFuZCBvbmx5IGFsbG93IG9uZSBtYXNr
IGZvciBhbGwgaW5wdXRzLiBJDQo+ID4gPiBiZWxpZXZlIGZvciBpNDBlIHRoZXkgcmVxdWlyZWQg
dGhhdCB5b3UgYWx3YXlzIHVzZSBhIGZ1bGwgNA0KPiA+ID4gdHVwbGUuIEkNCj4gPiA+IGRpZG4n
dCBzZWUgc29tZXRoaW5nIGxpa2UgdGhhdCBoZXJlLiBBcyBzdWNoIHlvdSBtYXkgd2FudCB0bw0K
PiA+ID4gZG91YmxlDQo+ID4gPiBjaGVjayB0aGF0IHlvdSBjYW4gaGF2ZSBhIG1peCBvZiBmbG93
IGRpcmVjdG9yIHJ1bGVzIHRoYXQgYXJlDQo+ID4gPiB1c2luZyAxDQo+ID4gPiB0dXBsZSwgMiB0
dXBsZXMsIDMgdHVwbGVzLCBhbmQgNCB0dXBsZXMgYXMgbGFzdCBJIGtuZXcgeW91DQo+ID4gPiBj
b3VsZG4ndC4NCj4gPiA+IEJhc2ljYWxseSBpZiB5b3UgaGFkIGZpZWxkcyBpbmNsdWRlZCB0aGV5
IGhhZCB0byBiZSBpbmNsdWRlZCBmb3INCj4gPiA+IGFsbA0KPiA+ID4gdGhlIHJ1bGVzIG9uIHRo
ZSBwb3J0IG9yIGRldmljZSBkZXBlbmRpbmcgb24gaG93IHRoZSB0YWJsZXMgYXJlDQo+ID4gPiBz
ZXQNCj4gPiA+IHVwLg0KPiA+IA0KPiA+IFRoZSBpY2UgZHJpdmVyIGhhcmR3YXJlIGlzIHF1aXRl
IGEgYml0IG1vcmUgY2FwYWJsZSB0aGFuIHRoZSBpeGdiZQ0KPiA+IG9yDQo+ID4gaTQwZSBoYXJk
d2FyZSwgYW5kIHVzZXMgYSBsaW1pdGVkIHNldCBvZiBBQ0wgcnVsZXMgdG8gc3VwcG9ydA0KPiA+
IGRpZmZlcmVudA0KPiA+IHNldHMgb2YgbWFza3MuIFdlIGhhdmUgc29tZSBsaW1pdHMgb24gdGhl
IG51bWJlciBvZiBtYXNrcyBhbmQgdGhlDQo+ID4gbnVtYmVyIG9mIGZpZWxkcyB0aGF0IHdlIGNh
biBzaW11bHRhbmVvdXNseSBzdXBwb3J0LCBidXQgSSB0aGluaw0KPiA+IHRoYXQgaXMgcHJldHR5
IG5vcm1hbCBmb3IgbGltaXRlZCBoYXJkd2FyZSByZXNvdXJjZXMuDQo+ID4gDQo+ID4gTGV0J3Mg
anVzdCBzYXkgdGhhdCBpZiB0aGUgY29kZSBkb2Vzbid0IHdvcmsgb24gYW4gRTgxMCBjYXJkIHRo
ZW4NCj4gPiB3ZQ0KPiA+IG1lc3NlZCB1cCBhbmQgd2UnbGwgaGF2ZSB0byBmaXggaXQuIDotKQ0K
PiA+IA0KPiA+IFRoYW5rcyBmb3IgdGhlIHJldmlldyEgSG9wZSB0aGlzIGhlbHBzLi4uDQo+IA0K
PiBJIGdhdGhlciBhbGwgdGhhdC4gVGhlIGlzc3VlIHdhcyB0aGUgY29kZSBpbiBpY2VfaXNfYWNs
X2ZpbHRlcigpLg0KPiBCYXNpY2FsbHkgaWYgd2Ugc3RhcnQgZHJvcHBpbmcgZmllbGRzIGl0IHdp
bGwgbm90IHRyaWdnZXIgdGhlIHJ1bGUgdG8NCj4gYmUgY29uc2lkZXJlZCBhbiBBQ0wgcnVsZSBp
ZiB0aGUgZmllbGQgaXMgY29tcGxldGVseSBkcm9wcGVkLg0KPiANCj4gU28gZm9yIGV4YW1wbGUg
SSBjb3VsZCBkZWZpbmUgNCBydWxlcywgb25lIHRoYXQgaWdub3JlcyB0aGUgSVB2NA0KPiBzb3Vy
Y2UsIG9uZSB0aGF0IGlnbm9yZXMgdGhlIElQdjQgZGVzdGluYXRpb24sIG9uZSB0aGF0IGlnbm9y
ZXMgdGhlDQo+IFRDUCBzb3VyY2UgcG9ydCwgYW5kIG9uZSB0aGF0IGlnbm9yZXMgdGhlIFRDUCBk
ZXN0aW5hdGlvbiBwb3J0Lg0KDQpXZSBoYXZlIHRoZSBsaW1pdGF0aW9uIHRoYXQgeW91IGNhbiB1
c2Ugb25lIGlucHV0IHNldCBhdCBhIHRpbWUgc28gYW55DQpvZiB0aGVzZSBydWxlcyBjb3VsZCBi
ZSBjcmVhdGVkIGJ1dCB0aGV5IGNvdWxkbid0IGV4aXN0IGNvbmN1cnJlbnRseS4NCg0KPiBXaXRo
DQo+IHRoZSBjdXJyZW50IGNvZGUgYWxsIDQgb2YgdGhvc2UgcnVsZXMgd291bGQgYmUgY29uc2lk
ZXJlZCB0byBiZQ0KPiBub24tQUNMIHJ1bGVzIGJlY2F1c2UgdGhlIG1hc2sgaXMgMCBhbmQgbm90
IHBhcnRpYWwuDQoNCkNvcnJlY3QuIEkgZGlkIHRoaXMgdG8gdGVzdCBGbG93IERpcmVjdG9yOg0K
DQonZXRodG9vbCAtTiBlbnM4MDFmMCBmbG93LXR5cGUgdGNwNCBzcmMtaXAgMTkyLjE2OC4wLjEw
IGRzdC1pcA0KMTkyLjE2OC4wLjIwIHNyYy1wb3J0IDg1MDAgYWN0aW9uIDEwJyBhbmQgc2VudCB0
cmFmZmljIG1hdGNoaW5nIHRoaXMuDQpUcmFmZmljIGNvcnJlY3RseSB3ZW50IHRvIHF1ZXVlIDEw
Lg0KDQo+IElmIEkgZG8gdGhlIHNhbWUNCj4gdGhpbmcgYW5kIGlnbm9yZSBhbGwgYnV0IG9uZSBi
aXQgdGhlbiB0aGV5IGFyZSBhbGwgQUNMIHJ1bGVzLg0KDQpBbHNvIGNvcnJlY3QuIEkgZGlkIGFz
IGZvbGxvd3M6DQoNCidldGh0b29sIC1OIGVuczgwMWYwIGZsb3ctdHlwZSB0Y3A0IHNyYy1pcCAx
OTIuMTY4LjAuMTAgZHN0LWlwDQoxOTIuMTY4LjAuMjAgc3JjLXBvcnQgOTAwMCBtIDB4MSBhY3Rp
b24gMTUnDQoNClNlbmRpbmcgdHJhZmZpYyB0byBwb3J0IDkwMDAgYW5kIDkwMDAxLCB0cmFmZmlj
IHdlbnQgdG8gcXVldWUgMTUNClNlbmRpbmcgdHJhZmZpYyB0byBwb3J0IDgwMDAgYW5kIDkwMDAy
LCB0cmFmZmljIHdlbnQgdG8gb3RoZXIgcXVldWVzDQoNClRoYW5rcywNClRvbnkNCg0KPiBJbg0K
PiBhZGRpdGlvbiBJIGRvbid0IHNlZSBhbnl0aGluZyB0ZWxsaW5nIGZsb3cgZGlyZWN0b3IgaXQg
Y2FuIGlnbm9yZQ0KPiBjZXJ0YWluIGlucHV0cyBvdmVyIHZlcmlmeWluZyB0aGUgbWFzayBzbyBJ
IGFtIGFzc3VtaW5nIHRoYXQgdGhlDQo+IHByZXZpb3VzbHkgbWVudGlvbmVkIHJ1bGVzIHRoYXQg
ZHJvcCBlbnRpcmUgZmllbGRzIHdvdWxkIGxpa2VseSBub3QNCj4gd29yayB3aXRoIEZsb3cgRGly
ZWN0b3IuDQo+IA0KPiBBbnl3YXkgSSBqdXN0IHdhbnRlZCB0byBwb2ludCB0aGF0IG91dCBhcyB0
aGF0IHdvdWxkIGJlIGFuIGlzc3VlDQo+IGdvaW5nDQo+IGZvcndhcmQgYW5kIGl0IHNlZW1zIGxp
a2UgaXQgd291bGQgYmUgZWFzeSB0byBmaXggYnkgc2ltcGx5IGp1c3QNCj4gcmVqZWN0aW5nIHJ1
bGVzIHdoZXJlIHRoZSByZXF1aXJlZCBmbG93IGRpcmVjdG9yIGZpZWxkcyBhcmUgbm90DQo+IGVu
dGlyZWx5IG1hc2tlZCBpbi4NCj4gDQo+IC0gQWxleA0K
