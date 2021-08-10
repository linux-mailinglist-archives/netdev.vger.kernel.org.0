Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D34A3E5096
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhHJBVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:21:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:32466 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232781AbhHJBVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 21:21:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="275849907"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="275849907"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 18:20:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="502954277"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 09 Aug 2021 18:20:42 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 9 Aug 2021 18:20:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 9 Aug 2021 18:20:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 9 Aug 2021 18:20:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYR8/uHcsOrLrmcwgXmspU4pyccDsdSF4FN/Txi38CzqSwJwuRzAV6yYudmTrYrBBcCac8Yw5ftVcFg2urf/2pXdYMY8sk/VpIvmU5MIr5Q90aTxJ+vQMKzo+pgzkGwoMXrYS7/8Ws+dUUKXAFW7i1gYrZFYOX07yIX/ASc/XycmWQ54Jfd1Bk6EU8EBgYVstLXY0OUi9tQ4z9M1gXARplAf8oIOBXcwTLNSWK5gl1ip7zXl2u4jNCBRchNPDmIrRX5IBqugqZla7EabDLq6FlTDC5PdtN/aASdDqgxBEfFcUKSx5xPS7UyC/toWJllWzB6iDbd9bQUl0gaQ1nLDpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRsEiq8/t8KFLs+gx4VCTYMkhksQsuU5x8/riG3oMqY=;
 b=eOKE0Z/f5RxNeFstTaetYypxar5jmxodRRGgz+H/DM3rI4HNbDrsER6pV4DnWtcqW+MlPQ0YtOoaCa/LLG0pVFLebLaBHsKNTGWXGUvxl/SWBaLGK5zxhTPq42Ml8UAKZupTgSxqVa4iAQ1MXHElelspdtOERzQ0upvpPp9j2BYFLTQeVR4roC1UEE82zovEqxmMdxeCWoE6KFfr5J2HdatSFr52bArkKrHX2ZQjGO6t0VJuBG4OL3gAhrwKqKFIT0XYguSrRqiJSqbNyQ92jx8QpLbYnvNJSxJ8B0T4Dd49rrO4xMyWG+/7Hfm8mzGHGNg++ktJmv5SONlbWgzKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRsEiq8/t8KFLs+gx4VCTYMkhksQsuU5x8/riG3oMqY=;
 b=eX33wBBY9xPl9gg1dmPsVUW9RgAG1X6Iz9fXlW78PpxoyP6am/vYRw3sRaIlX24CQsxKL1WAX7rKzV46jO3sf+uPBouKarEfSJoEr4AXsCx2Z7KBbvORLDHNgVW6aVgJn4fbfzN87gzkXUxhKehL/3ypIBGRTvp3pLhC5t6mJ4g=
Received: from PH0PR11MB5207.namprd11.prod.outlook.com (2603:10b6:510:32::15)
 by PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 01:20:35 +0000
Received: from PH0PR11MB5207.namprd11.prod.outlook.com
 ([fe80::c42e:f6ab:d4d6:dc8a]) by PH0PR11MB5207.namprd11.prod.outlook.com
 ([fe80::c42e:f6ab:d4d6:dc8a%5]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 01:20:34 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
 queue_mapping
Thread-Topic: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
 queue_mapping
Thread-Index: AQHXjXdfhzVY05wmt0WZKnEG4uNcHqtr6K8AgAAEasA=
Date:   Tue, 10 Aug 2021 01:20:34 +0000
Message-ID: <PH0PR11MB5207C23E220FD910DB99BE45F1F79@PH0PR11MB5207.namprd11.prod.outlook.com>
References: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UfMqqSjF80VYNcax4Yer2F2u9f_cbm3DSLtdhz_JzWH-A@mail.gmail.com>
In-Reply-To: <CAKgT0UfMqqSjF80VYNcax4Yer2F2u9f_cbm3DSLtdhz_JzWH-A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 433c44ab-9860-43a1-42d2-08d95b9d0dd9
x-ms-traffictypediagnostic: PH0PR11MB5176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5176454966A2828707CFFCF7F1F79@PH0PR11MB5176.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5XQxDOi0GJ05OU3QYIO2puxpDHlI54qiz89f7aBCEVh9spXw4E/x65Kc78Er9PuWDSVbfoqYX7wTi3uQP9dmVfoaaBGbAPE0fTjIdtPe5ADPrrt14acULjK0LQ1GM9zb17pBsbfwEIN87P9Myce7XtazVR1ByRazOs7U+mAo48QhHRAOek/hvQArmdIPWfqSNuyA91PVyppcxcf4gt5MYOrtgVPWqSSAIHBgkuWVYij371XtFGfErdj/5Hbm9mYW1BtwCsCt660lGkGeS457saddPwuF33CyvfDURFUKylw7FACH2cW61xNZmKBFOPU0wDO/G6FpzcJy7pHx7cR5CdsrbRvSXR5KaDFh4stE5w16sg2ogFQ/y1cdMQ1wn3G4tVnfXPpOk929g7Ms3+ZoebRwCfYBRLe2NXpIEtl7RiBrAOmT4DPmdOQCcG+cedmlmGlRiYoPArGv/0KU3lRk/vFJsTqCuCqFmqmix81brOnO8rh1tW3Fag8jU2/oP0O3reizTa7Bp78OtY90kAZv2ogmnByQAzwVgNKLbPFtzcZzi9f1pSQRQUtiJ5c2ptYiw7Vv2JakMtT16Us1pGilsbZElPIAIEYIt2I0FPrlQsLiDPAzxWKPwurdzXdQB1XH7d6tlNA1aT4cZaYLyVFjcVv/PppF67YIlQVN4FcZLIESvJtmMw6ykFEv1+YSr1cbLegi9G6FVS0HsR+Uqk1c0aiRiNAXHeNXT8G9/KMvvq6P5rED3MEOer4J7szoV8WGlLpRjPqchJLBKyG1yAlT+Uf2gf0Ra1r0V1XcGXRvb7A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(52536014)(54906003)(66446008)(66556008)(64756008)(76116006)(66476007)(316002)(33656002)(55016002)(6916009)(7696005)(53546011)(66946007)(83380400001)(8676002)(6506007)(9686003)(26005)(186003)(107886003)(8936002)(38100700002)(2906002)(4326008)(122000001)(86362001)(71200400001)(38070700005)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFY3bWRkYkhKYmxGbmZBc2hIcEYwR0phU2s2cUYxampEa3BGY0ozQ1ppU0w0?=
 =?utf-8?B?d0FxQkVFZFRGd0JGVEpIclJ0NmhpRUQ2OEVqTjB2UCsrT2U0VVFybU80bkF4?=
 =?utf-8?B?LzBrWHlzSzBQc2JudTRxclgxYmE3N2dac3pHbzFEeTlpbE5kZ25QVzE2azJI?=
 =?utf-8?B?UjdramNPUEc4SWVGNlBRSWN6V0tMR1ZBNkszcWp0LzNnOGoxQVpYNVUwVXBS?=
 =?utf-8?B?cGJoVXowd0xYTEpuMWpQTTlGRzV1MkFacDlERzFJZW5PMzJTNnRiS041eExv?=
 =?utf-8?B?Tzd4VC9xSmJxSzUyYnQxN21RZzg0NjVRSkJuWmgrczlacEhqVndiTS8xNDhU?=
 =?utf-8?B?MDdXSVByQUxhbGpQOWQ3aDR6VkJObUErWFIzYy8wSFdRNGRNbE5IRm1iS2Jk?=
 =?utf-8?B?dno3dXRtRlZqVTUwcTI5Qmx3bEF5bERTeHhQdUpyRHBlaGFtamNrTzk0S0Y3?=
 =?utf-8?B?T3F1S1ltbE9iMS9PK3lKaFJ4ZVZTWk1XTnpzaUdnS3dtTXJ4Vm5IMGRvM013?=
 =?utf-8?B?Z0xma244cCtXOGJqMkZoSTVsY1ZqdHBYYjVTSXh1WnBnMlVtTGVTNHNoeWZx?=
 =?utf-8?B?YlFhb25aVm92QUZ2bTUxWlpGWWE1V1V0b3ZadmxOL0NuWXNBdStYODVsWnl1?=
 =?utf-8?B?bzk3azhvK2QzK1RDNUwwQmlVVlZ3a2tTb0NRQzRzcEVuRmNtNm13UnEyU3Zs?=
 =?utf-8?B?WWxudmJzVEtLM3c0eG14RVo5SHozNldBVXlId3IrZWdzTm9IMHdQWjQrZkNZ?=
 =?utf-8?B?a1UvK2J5cG5BVEkxSGo0OGxsNXJpd3p6bityREhXSEduQ3BkTlRmUjJoZW82?=
 =?utf-8?B?RWtGYzlMT0lRVm8rc3dxZlRpYWxzd1FKK3JHRS9wejJkZGVyUzlIMWwzbDhn?=
 =?utf-8?B?a09STlZyQU9yZzlwZFFVRkZjdnVkVHdmcWI4RkpxcjM5Q2hzNEZ5WjF0eGJM?=
 =?utf-8?B?dXhQdlhHWEZ1NjkrTGFZQ09CZUVIdXdtZm5WMkk3Z1Znb0hpYXRWa3NtR1hw?=
 =?utf-8?B?WVhKWHNsTTRwQ0ZhbVhERnZFQzNwN210UlZKQ1ZiU0U1N0JhdmEzUFlqckIz?=
 =?utf-8?B?ZlZOMGd0bEZJVm41eVk4d2hNNGQ4WHVUdENnQjdHOFhkSmM3ZGlIM0tQdkNt?=
 =?utf-8?B?aXFaY3hHN1dScFBDNmxVd0p5VFpTK01vWmFpc2hEckcvY2MwZjllcm9aRmlo?=
 =?utf-8?B?NTJob3BvUDVPNWdWenVzVmlmbHo1aUdlc21LL2NXQjlHSHFDU0dKR3RqMWhN?=
 =?utf-8?B?cnYxYi82ZmFoWVVpclFuRlRWNlZDN1p3a1pVb0NSWHFteEp4TEpZb3BhUXIx?=
 =?utf-8?B?MUVwWHAxdE1LVXNHYmpHMUtmejhqSmtpeWp5MDk5U0NIQU1EM1N2ank5d1R5?=
 =?utf-8?B?K09aL1JwKzZHay83TWtVVFBFYzBQc0UvOElqUWdreVI4OXhzOGkrbTR2Yjl3?=
 =?utf-8?B?OEN6WjUxOFFJVHJVRmlzVnlJZm9HUmJSWDltQWxaMTFTQmJZMit4Z0x2Q2Ri?=
 =?utf-8?B?VU90M2RYY0dnNEVEYk41b3MycC9oL3dNQWJlamJ6U0piMWIweml6UHFhQ1Ji?=
 =?utf-8?B?MEN1UFBSZHM1TGZqUVZDaERjWFJxbll2UWVMNFdKVkdXcnROZVlhVkxrV05J?=
 =?utf-8?B?M0dLYktLYjlyVExzWjJwLzNEbFFlcXJLT1dNNnhNY0d5b0ZJQWQwQmwzL2R2?=
 =?utf-8?B?enBmOTlGcjZpN2RhV2laQjBtMGU1YTBOQ3ZScVVmNlcyc3NwazFmTjZEYVRX?=
 =?utf-8?Q?EbGX2ZL8nkLWJjHxVU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433c44ab-9860-43a1-42d2-08d95b9d0dd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 01:20:34.8975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sp0pFwfJtZIcyD0RIoloPm9xAr23UrqyDrhYQQDBA2oeKGDvDWUnk7TG3UF+WEc/SafT86+Crxwh0ovSylnfe1OCIJoHPCCNvYpG4Bom0Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5176
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDksIDIwMjEg
NTo1MSBQTQ0KPiBUbzogTmFtYmlhciwgQW1yaXRoYSA8YW1yaXRoYS5uYW1iaWFyQGludGVsLmNv
bT4NCj4gQ2M6IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiBKYW1hbCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29t
PjsgSmlyaSBQaXJrbyA8amlyaUByZXNudWxsaS51cz47IENvbmcNCj4gV2FuZyA8eGl5b3Uud2Fu
Z2NvbmdAZ21haWwuY29tPjsgU2FtdWRyYWxhLCBTcmlkaGFyDQo+IDxzcmlkaGFyLnNhbXVkcmFs
YUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgUEFUQ0hdIG5ldDogYWN0X3Nr
YmVkaXQ6IEZpeCB0YyBhY3Rpb24gc2tiZWRpdA0KPiBxdWV1ZV9tYXBwaW5nDQo+IA0KPiBPbiBN
b24sIEF1ZyA5LCAyMDIxIGF0IDQ6MzYgUE0gQW1yaXRoYSBOYW1iaWFyDQo+IDxhbXJpdGhhLm5h
bWJpYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZvciBza2JlZGl0IGFjdGlvbiBxdWV1
ZV9tYXBwaW5nIHRvIHNlbGVjdCB0aGUgdHJhbnNtaXQgcXVldWUsDQo+ID4gcXVldWVfbWFwcGlu
ZyB0YWtlcyB0aGUgdmFsdWUgTiBmb3IgdHgtTiAod2hlcmUgTiBpcyB0aGUgYWN0dWFsDQo+ID4g
cXVldWUgbnVtYmVyKS4gSG93ZXZlciwgY3VycmVudCBiZWhhdmlvciBpcyB0aGUgZm9sbG93aW5n
Og0KPiA+IDEuIFF1ZXVlIHNlbGVjdGlvbiBpcyBvZmYgYnkgMSwgdHggcXVldWUgTi0xIGlzIHNl
bGVjdGVkIGZvcg0KPiA+ICAgIGFjdGlvbiBza2JlZGl0IHF1ZXVlX21hcHBpbmcgTi4gKElmIHRo
ZSBnZW5lcmFsIHN5bnRheCBmb3IgcXVldWUNCj4gPiAgICBpbmRleCBpcyAxIGJhc2VkLCBpLmUu
LCBhY3Rpb24gc2tiZWRpdCBxdWV1ZV9tYXBwaW5nIE4gd291bGQNCj4gPiAgICB0cmFuc21pdCB0
byB0eCBxdWV1ZSBOLTEsIHdoZXJlIE4gPj0xLCB0aGVuIHRoZSBsYXN0IHF1ZXVlIGNhbm5vdA0K
PiA+ICAgIGJlIHVzZWQgZm9yIHRyYW5zbWl0IGFzIHRoaXMgZmFpbHMgdGhlIHVwcGVyIGJvdW5k
IGNoZWNrLikNCj4gPiAyLiBUcmFuc21pdCB0byBmaXJzdCBxdWV1ZSBvZiBUQ3Mgb3RoZXIgdGhh
biBUQzAgc2VsZWN0cyB0aGUNCj4gPiAgICBuZXh0IHF1ZXVlLg0KPiA+IDMuIEl0IGlzIG5vdCBw
b3NzaWJsZSB0byB0cmFuc21pdCB0byB0aGUgZmlyc3QgcXVldWUgKHR4LTApIGFzDQo+ID4gICAg
dGhpcyBmYWlscyB0aGUgYm91bmRzIGNoZWNrLCBpbiB0aGlzIGNhc2UgdGhlIGZhbGxiYWNrDQo+
ID4gICAgbWVjaGFuaXNtIGZvciBoYXNoIGNhbGN1bGF0aW9uIGlzIHVzZWQuDQo+ID4NCj4gPiBG
aXggdGhlIGNhbGwgdG8gc2tiX3NldF9xdWV1ZV9tYXBwaW5nKCksIHRoZSBjb2RlIHJldHJpZXZp
bmcgdGhlDQo+ID4gdHJhbnNtaXQgcXVldWUgdXNlcyBza2JfZ2V0X3J4X3F1ZXVlKCkgd2hpY2gg
c3VidHJhY3RzIHRoZSBxdWV1ZQ0KPiA+IGluZGV4IGJ5IDEuIFRoaXMgbWFrZXMgaXQgc28gdGhh
dCAiYWN0aW9uIHNrYmVkaXQgcXVldWVfbWFwcGluZyBOIg0KPiA+IHdpbGwgdHJhbnNtaXQgdG8g
dHgtTiAoaW5jbHVkaW5nIHRoZSBmaXJzdCBhbmQgbGFzdCBxdWV1ZSkuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBBbXJpdGhhIE5hbWJpYXIgPGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+DQo+
ID4gUmV2aWV3ZWQtYnk6IFNyaWRoYXIgU2FtdWRyYWxhIDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRl
bC5jb20+DQo+ID4gLS0tDQo+ID4gIG5ldC9zY2hlZC9hY3Rfc2tiZWRpdC5jIHwgICAgMiArLQ0K
PiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQvYWN0X3NrYmVkaXQuYyBiL25ldC9zY2hlZC9hY3Rf
c2tiZWRpdC5jDQo+ID4gaW5kZXggZTVmM2ZiOGIwMGUzLi5hN2JiYTE1Yzc0YzQgMTAwNjQ0DQo+
ID4gLS0tIGEvbmV0L3NjaGVkL2FjdF9za2JlZGl0LmMNCj4gPiArKysgYi9uZXQvc2NoZWQvYWN0
X3NrYmVkaXQuYw0KPiA+IEBAIC01OSw3ICs1OSw3IEBAIHN0YXRpYyBpbnQgdGNmX3NrYmVkaXRf
YWN0KHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0DQo+IHN0cnVjdCB0Y19hY3Rpb24gKmEsDQo+
ID4gICAgICAgICB9DQo+ID4gICAgICAgICBpZiAocGFyYW1zLT5mbGFncyAmIFNLQkVESVRfRl9R
VUVVRV9NQVBQSU5HICYmDQo+ID4gICAgICAgICAgICAgc2tiLT5kZXYtPnJlYWxfbnVtX3R4X3F1
ZXVlcyA+IHBhcmFtcy0+cXVldWVfbWFwcGluZykNCj4gPiAtICAgICAgICAgICAgICAgc2tiX3Nl
dF9xdWV1ZV9tYXBwaW5nKHNrYiwgcGFyYW1zLT5xdWV1ZV9tYXBwaW5nKTsNCj4gPiArICAgICAg
ICAgICAgICAgc2tiX3NldF9xdWV1ZV9tYXBwaW5nKHNrYiwgcGFyYW1zLT5xdWV1ZV9tYXBwaW5n
ICsgMSk7DQo+ID4gICAgICAgICBpZiAocGFyYW1zLT5mbGFncyAmIFNLQkVESVRfRl9NQVJLKSB7
DQo+ID4gICAgICAgICAgICAgICAgIHNrYi0+bWFyayAmPSB+cGFyYW1zLT5tYXNrOw0KPiA+ICAg
ICAgICAgICAgICAgICBza2ItPm1hcmsgfD0gcGFyYW1zLT5tYXJrICYgcGFyYW1zLT5tYXNrOw0K
PiA+DQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgY29ycmVjdC4gSXQgaXMgY29uZmxhdGlu
ZyB0aGUgcnhfcXVldWVfbWFwcGluZw0KPiB2ZXJzdXMgdGhlIFR4IHF1ZXVlIG1hcHBpbmcuIFRo
aXMgaXMgc3VwcG9zZWQgdG8gYmUgc2V0dGluZyB0aGUgVHgNCj4gcXVldWUgbWFwcGluZyB3aGlj
aCBhcHBsaWVzIGFmdGVyIHdlIGhhdmUgZHJvcHBlZCB0aGUgUnggcXVldWUNCj4gbWFwcGluZywg
bm90IGJlZm9yZS4gU3BlY2lmaWNhbGx5IHRoaXMgaXMgcnVuIGF0IHRoZSBxZGlzYyBlbnF1ZXVl
DQo+IHN0YWdlIHdpdGggYSBzaW5nbGUgbG9ja2VkIHFkaXNjLCBhZnRlciBuZXRkZXZfcGlja190
eCBhbmQgc2tiX3R4X2hhc2gNCj4gaGF2ZSBhbHJlYWR5IHJ1bi4gSXQgaXMgc29tZXRoaW5nIHRo
YXQgZXhpc3RlZCBiZWZvcmUgbXEgYW5kIGlzIG1lYW50DQo+IHRvIHdvcmsgd2l0aCB0aGUgbXV0
bGlxIHFkaXNjLg0KPiANCj4gSWYgeW91IGFyZSB3YW50aW5nIHRvIGFkZCBhIHNlcGVyYXRlIG92
ZXJyaWRlIHRvIGFkZCBzdXBwb3J0IGZvcg0KPiBwcm9ncmFtbWluZyB0aGUgUnggcXVldWUgbWFw
cGluZyB5b3UgbWF5IHdhbnQgdG8gc3VibWl0IHRoYXQgYXMgYQ0KPiBkaWZmZXJlbnQgcGF0Y2gg
cmF0aGVyIHRoYW4gdHJ5aW5nIHRvIGNoYW5nZSB0aGUgZXhpc3RpbmcgVHggcXVldWUNCj4gbWFw
cGluZyBmZWF0dXJlLiBFaXRoZXIgdGhhdCBvciB5b3Ugd291bGQgbmVlZCB0byBjaGFuZ2UgdGhp
cyBzbyB0aGF0DQo+IGl0IGhhcyBhIGRpZmZlcmVudCBiZWhhdmlvciBkZXBlbmRpbmcgb24gd2hl
cmUgdGhlIGhvb2sgaXMgYWRkZWQgc2luY2UNCj4gdGhlIGJlaGF2aW9yIHdvdWxkIGJlIGRpZmZl
cmVudCBpZiB0aGlzIGlzIGNhbGxlZCBiZWZvcmUgc2tiX3R4X2hhc2guDQoNCkhpIEFsZXgsDQpU
aGFua3MgZm9yIHRoZSByZXZpZXcuIFRoZSBnb2FsIGlzIHRvIHNlbGVjdCBhIHRyYW5zbWl0IHF1
ZXVlIHVzaW5nIHRjIGVncmVzcyBydWxlDQphbmQgdGhlIGFjdGlvbiBza2JlZGl0ICh0aGF0IHdp
bGwgZ28gdGhyb3VnaCBuZXRkZXZfcGlja190eCBhbmQgc2tiX3R4X2hhc2gpLg0KSSBhbSBub3Qg
c3VyZSBvZiB0aGUgY29ycmVjdCBzeW50YXggZm9yIHRoZSBxdWV1ZS1tYXBwaW5nIHZhbHVlIGlu
IHRoZQ0KYWN0aW9uICh0eC1OIG9yIHR4LU4rMSkuIEFzIHBlciB0aGUgbWFuIHBhZ2UNCihodHRw
czovL21hbjcub3JnL2xpbnV4L21hbi1wYWdlcy9tYW44L3RjLXNrYmVkaXQuOC5odG1sKSwgSSBp
bnRlcnByZXRlZA0KaXQgYXMgImFjdGlvbiBza2JlZGl0IHF1ZXVlX21hcHBpbmcgTiIgd2lsbCB0
cmFuc21pdCB0byB0eC1OLiBCdXQsIHRoZQ0KMyBvYnNlcnZhdGlvbnMgSSBsaXN0ZWQgZG9uJ3Qg
cXVpdGUgc2VlbSB0byBiZSBmb2xsb3dpbmcgdGhlIHRjIHJ1bGUuDQpIZW5jZSwgdHJpZWQgdG8g
Zml4IHRoaXMgaW4gdGhlIGFjdGlvbiBtb2R1bGUuIA0KDQotQW1yaXRoYQ0K
