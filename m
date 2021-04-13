Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417DB35E9D2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhDMXxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 19:53:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:36216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhDMXw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 19:52:59 -0400
IronPort-SDR: iRxmBU6OlTbJoN1yj+7WBK45rQlvWfwH4vPbdx/4Nywy4jeS4GI9k4/0hKnhgEhjM7AxIEHQXp
 KurPQ5ObFp6g==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="182037069"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="182037069"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 16:52:38 -0700
IronPort-SDR: G7kQshUs7Urg9jiGdTEFGrdM62d45mk4yCpjjHakEZEve1yOyUfPzsvhsr9R39sGLuT0IyhpGb
 JEfB4ikp1/oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="450590164"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Apr 2021 16:52:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 16:52:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 13 Apr 2021 16:52:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 13 Apr 2021 16:52:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksJkPSuJlkRz4lVE0XYdCBDK/NFJyDlyqyEVozcCqIcgRceH2fPsVypmvQua3eGAEIVbY4gB4hE/XvjhiNJxzNMzMZ1CsQawoW6TSk5ieLhsVlZdOj5irFdc3unIkiO+svzZe7ITLq2JyKc62xms1SFNikzQVkm825uBeo/uqA0/u25iCy/lXkeQWafnn/cG1BsEemYzRAJM+yETfYt5mOHqpqCVUV9h8d/0Kv8SnPBK30T6lGGh6Kkab6S9jDJJb/rwVIMNIc1AQClyHc3qRBwePBqs3i69+xaN6hxckL0jsa0Y8SLh3fTcGWQoL/TS7S2rsv6qFKQnGk8OGVcDYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgHassLPa/bQG2cV9qz4C+loC0/sGHd5jUXoD7lLKoE=;
 b=XI4Cjv8g/LpMUDRW8vF+janUWCE9+o0LIhLAquV2Ondmn2fxXjxiZMyTHpFtAJRWJOwrpwrmvQkwC/uw9VTZBuMVyezf1KMK0wGX+SKJT5Dz9IXUISkL2it3jA6+TVhkAm+6ckDYdE9l0pELYUgzgzij+DXB1rKWVAAQNmoNN6tUFZg9UOuHFFK/HdAhcXSJKod1CsDCOxPttlwxG67Qm6NyAGY+t74L3U0pozkRDmJNA5A8U5R5C/vaA/glcSP3tBGf95Ws1sI6uI758Cn9dqlEgEdv3IJ2vss6DzuHjoaXsyZrlAABWuq0qsXbc5JSvDvfNzr7Z5H7JDIWq5velg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgHassLPa/bQG2cV9qz4C+loC0/sGHd5jUXoD7lLKoE=;
 b=gQnX8702p6/IdMmSQYzisGjGdzJhjGQpv0tBItDXxyNb6aZw3ulYQ6tsj/OKNVaeIOG2CYEwlNBc8tuFSg3ZE0xcQXKM8f0fScZqFhj95w0sABFKW6RxATDmiBh2PrwD1jwFIm6kousQDcJk/BbDGDCiDrDw4HgyLLDZd9mNe2o=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (52.135.112.28) by
 SA0PR11MB4557.namprd11.prod.outlook.com (20.181.61.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.22; Tue, 13 Apr 2021 23:52:36 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:52:36 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Tyl, RadoslawX" <radoslawx.tyl@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 2/4] ixgbe: aggregate of all receive errors
 through netdev's rx_errors
Thread-Topic: [PATCH net-next 2/4] ixgbe: aggregate of all receive errors
 through netdev's rx_errors
Thread-Index: AQHXLXLISt6VExO6JEW+ZLBLx1Ua/qqs7s0AgAY2dIA=
Date:   Tue, 13 Apr 2021 23:52:36 +0000
Message-ID: <424968219126961b51bef798dc554eb2867a9809.camel@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
         <20210409190314.946192-3-anthony.l.nguyen@intel.com>
         <20210409180008.1f23bb7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409180008.1f23bb7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b65580cc-cc6b-4f62-998f-08d8fed736ab
x-ms-traffictypediagnostic: SA0PR11MB4557:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4557260FD4799EFF9F876C0FC64F9@SA0PR11MB4557.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBLSSlnI5hwjDLf7sz98E1QNxQm/ubmJJXORgGI73oVA9FYqdZLFCz0nDgC7HKNgSIBaWKyL4O9nrCYYuV5Ko6m2sd73fv+It/tF35nG3RrXTe+nalCjIhqzi7GgApv+MfWPxETYKU0tQlxzwM9E7B+ntCOWPaLcaPNIKf2ESN059KI9XM2m9ilclSv0KYsGDII7YOwnCb9oy3jMr16RPx0itqJEuw27Y9V1yQ5C6sdTjYfQML4tyY7Bo1+XLyiMNarPMFi1Dfq/iJUuTfFOEPeV4RgXlaLQAXbyagU+sE5vnsfbDHH8EoTgGloKDihRwgGdVgJ/E71UR1JxiZXN/77vwCgxYCi+mD/FMiD2j2t6taktjdDHE6mbOaJ8XVMM2KudjRE17hqRsyYcsxMpVvst3gW2pu/seQy0EWyvXbfjUq4ENRbwqTVTZaeOXgeTssApT71DVGxIl13j5QzOVnXkQ5iXgdxTGXo8jkTiGjS5RawftJQ/MAgLYpmHGJCk6rVeHl0oUa8SeV+JS57OQQZ6EuPdxtCE9dT+g5V1SbqihtEmP9lA9+tNw3EERQnWYqniHuJtHElbPknt50QzqgXZgXyv1x69n2FBxjQDl1AV1xjVTwTHKLrIZ1ZCWDHfe9HB9IJfYwV4U2ap2SVmcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(366004)(376002)(396003)(346002)(26005)(64756008)(66946007)(66556008)(66446008)(66476007)(91956017)(6512007)(76116006)(316002)(107886003)(186003)(6916009)(86362001)(83380400001)(2616005)(2906002)(5660300002)(8936002)(6506007)(6486002)(36756003)(122000001)(4326008)(478600001)(8676002)(38100700002)(71200400001)(54906003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SnFuQ0hSVlNGVXdFZjdDTlVvOWZNUjRMVis2bXczY3Nsc1VCSnNCRWVlQk1v?=
 =?utf-8?B?blNiRHVpTEphbm1sNC91dUxGa3FkNTVHNHNjN1VPU3E3d0FHQXBuaTF4SEhG?=
 =?utf-8?B?N3BKNTlPeHZTaXdvU3QwZFFUcnJQaW1GYW8wNEVVU2ZzRU9DL00vUUozaTJq?=
 =?utf-8?B?eW9sYnBXRDFPR0Fvd0VmVWdkS28rUHcrN3VpNWZ0bzF0SkZmc2czWWFDTFdW?=
 =?utf-8?B?OFFpTk9nSmxuMGZoc1d4cWxYZzVoakdVMjZ4OHRLZUpwUUdzTlM4OUw1ZzFx?=
 =?utf-8?B?U2s0K2Yvcng0bC8yMmcwdXhwZzhGRG9Eck80MmhnZGFXdlZZS2daR2RLaGIw?=
 =?utf-8?B?azRHc0JEQllPZGlWSW1mYm9hZkMwb0Q0MC94QXBHWHB3M21FOTRIdDBtRXRW?=
 =?utf-8?B?QzB5eE41eS9uUG0xMW9heFNGZUZ0Z3FVTnY0c1pVZXlvRVN6UTRXRHlQUXV0?=
 =?utf-8?B?bXEvczVWbDVFbGtPREtkek1iVEtQWkg0RW1RUDh2NWVnN0dSVkVaTCt4eDVU?=
 =?utf-8?B?RXlSY2JlQTBvZHpueU9KaUs0N3BqaVhvRFJpZmNoTytXU2lleVk4MlhISEho?=
 =?utf-8?B?dHozT0lLRHlNMnRjQTNOUDByUG9zTHM5SUVaM1RIeU5VZi94MXVWOWtmRytx?=
 =?utf-8?B?Mi9NU0dxYVQ3Rjl3cmdpZlF3VFo1bW5mZVJ6TWhQUUx4MEpPdFRIRlFteS84?=
 =?utf-8?B?SlA5S3NJLzd1Ulp6L1NmU0R0bm9oMVE3Y2RGMEt5Y0tsY21xZ3NGdEs4b3Nz?=
 =?utf-8?B?elZhV1ArdFZLSjNpbURoRFM3SG1oeW5udTNkeTB1bEswQUxRREZGWkFGcnZE?=
 =?utf-8?B?T1NTeC9NQjFkOGlwcGJkUUNadXpOcVk0YkgxNHhFc3BjOTZ6bjdoa0VDTFVa?=
 =?utf-8?B?T3lhUE5IMnVLU2NUUlkwZnVnQXlhY0JWU1RYL0ZhQ1Y4VE5nNi9hZlU0L09K?=
 =?utf-8?B?MWZlajR5bEY0aWthQ2tHdEdWWnl2Yk1WMGFXN2F3K0ZTTk5kbEFENllxWTY0?=
 =?utf-8?B?bm84VTlFakd4QVZicHk1TExmS1RYZ0ZKcmpjU1FLcVpkMnpOVUFsZlZVbHNK?=
 =?utf-8?B?WlpCL3pQUG5oMlFHUXIvWDYxVlQvOTJXVHdVOXF4dXJabWFvekx0b3Rmc3o0?=
 =?utf-8?B?TC9HekRLMUtvRkVQQmVyMXI1UVFFdlAzUHhaS0ZZNU9oT2FQTlhNOWRNTDdR?=
 =?utf-8?B?S3c3RzdkWktLRTh4ODFzZ1haems4TXRPdkhESy96NkQ3cGN2RFJjVFdjdi85?=
 =?utf-8?B?YVl1clNTWDk5RFN2Z3NuU3VXVVlWekFqRzYycGtIR1lVZkZhTzdHNWpXbmNj?=
 =?utf-8?B?VThzMUVwaVNsNEkxSTZaZWVuakJ6S2FPSDF4dDVCZlNoZ1J6RjhEMlNKOWF6?=
 =?utf-8?B?cGRpTmNVNUZZZTJuMTJKZ2RXd2wvVFE3ZTRQeHhKdWllVHpOR3o4c1NBWVdv?=
 =?utf-8?B?VkVLS0dSZXZ6TTFMWkVWSzltMWozM09pNHpRSzdSdldBL1ZMeHVsZWJESy9r?=
 =?utf-8?B?cXpVb1N0T2x4WWRDaVFxK3pHSGtwck44dVljVDdJa01RTjhLelBxNCszbGg1?=
 =?utf-8?B?eGdtRGVjclFZZzJVZEFPRkR2d1paM3RJYjhadDdTNzNkeWJ4VllMaWJuYkFU?=
 =?utf-8?B?MWNWVys0VTlrdis4OUpGNm84ZllUUklsWmZrSXMyRGVwSFkwY3dTNU11Z2hO?=
 =?utf-8?B?alFaUDZYS2svQnNPeEZuYW1QUzZIWTc4aitrNHhNT3drbDBaR2ZvQlF4bWMx?=
 =?utf-8?B?UnhKR2FYMmN5VFdLZlI4MXJicUxxLzZCQTBGWkkxWllRd0dLM1Rkd1VXK2pq?=
 =?utf-8?B?ZzJSakxMTHZ1eTRuQnVCZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAF192DE2577544D9A3694897BF9563D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b65580cc-cc6b-4f62-998f-08d8fed736ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 23:52:36.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8BpA+XUR+Z2Eg7pufI6ytERkjeAgbfsOmpAQo3Yg/aBcxK/AlSMgrbiKe+l1kevNUBAuDn1BKyeeP90Gcd0qsT3pwtixzT69mK8lPa4WrLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA0LTA5IGF0IDE4OjAwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAgOSBBcHIgMjAyMSAxMjowMzoxMiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBSYWRvc2xhdyBUeWwgPHJhZG9zbGF3eC50eWxAaW50ZWwuY29tPg0KPiA+IA0K
PiA+IFRoZSBnbG9iYWwgcnggZXJyb3IgZG9lcyBub3QgdGFrZSBpbnRvIGFjY291bnQgYWxsIHRo
ZSBlcnJvcg0KPiA+IGNvdW50ZXJzDQo+ID4gdGhhdCBhcmUgY291bnRlZCBieSBkZXZpY2UuDQo+
ID4gDQo+ID4gRXh0ZW5kIHJ4IGVycm9yIHdpdGggdGhlIGZvbGxvd2luZyBjb3VudGVyczoNCj4g
PiAtIGlsbGVnYWwgYnl0ZSBlcnJvcg0KPiA+IC0gbnVtYmVyIG9mIHJlY2VpdmUgZnJhZ21lbnQg
ZXJyb3JzDQo+ID4gLSByZWNlaXZlIGphYmJlcg0KPiA+IC0gcmVjZWl2ZSBvdmVyc2l6ZSBlcnJv
cg0KPiA+IC0gcmVjZWl2ZSB1bmRlcnNpemUgZXJyb3INCj4gPiAtIGZyYW1lcyBtYXJrZWQgYXMg
Y2hlY2tzdW0gaW52YWxpZCBieSBoYXJkd2FyZQ0KPiA+IA0KPiA+IFRoZSBhYm92ZSB3ZXJlIGFk
ZGVkIGluIG9yZGVyIHRvIGFsaWduIHN0YXRpc3RpY3Mgd2l0aCBvdGhlcg0KPiA+IHByb2R1Y3Rz
Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhZG9zbGF3IFR5bCA8cmFkb3NsYXd4LnR5bEBp
bnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5OiBUb255IEJyZWxpbnNraSA8dG9ueXguYnJlbGluc2tp
QGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5n
dXllbkBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2l4Z2JlL2l4Z2JlX21haW4uYyB8IDExICsrKysrKysrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYw0KPiA+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gaW5kZXggN2Jh
MWMyOTg1ZWY3Li43NzExODI4NDAxZDkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gQEAgLTcyNDAsMTIgKzcyNDAsMjEg
QEAgdm9pZCBpeGdiZV91cGRhdGVfc3RhdHMoc3RydWN0DQo+ID4gaXhnYmVfYWRhcHRlciAqYWRh
cHRlcikNCj4gPiAgCWh3c3RhdHMtPnB0YzEwMjMgKz0gSVhHQkVfUkVBRF9SRUcoaHcsIElYR0JF
X1BUQzEwMjMpOw0KPiA+ICAJaHdzdGF0cy0+cHRjMTUyMiArPSBJWEdCRV9SRUFEX1JFRyhodywg
SVhHQkVfUFRDMTUyMik7DQo+ID4gIAlod3N0YXRzLT5icHRjICs9IElYR0JFX1JFQURfUkVHKGh3
LCBJWEdCRV9CUFRDKTsNCj4gPiArCWh3c3RhdHMtPmlsbGVycmMgKz0gSVhHQkVfUkVBRF9SRUco
aHcsIElYR0JFX0lMTEVSUkMpOw0KPiA+ICANCj4gPiAgCS8qIEZpbGwgb3V0IHRoZSBPUyBzdGF0
aXN0aWNzIHN0cnVjdHVyZSAqLw0KPiA+ICAJbmV0ZGV2LT5zdGF0cy5tdWx0aWNhc3QgPSBod3N0
YXRzLT5tcHJjOw0KPiA+ICANCj4gPiAgCS8qIFJ4IEVycm9ycyAqLw0KPiA+IC0JbmV0ZGV2LT5z
dGF0cy5yeF9lcnJvcnMgPSBod3N0YXRzLT5jcmNlcnJzICsgaHdzdGF0cy0+cmxlYzsNCj4gPiAr
CW5ldGRldi0+c3RhdHMucnhfZXJyb3JzID0gaHdzdGF0cy0+Y3JjZXJycyArDQo+ID4gKwkJCQkg
ICAgaHdzdGF0cy0+aWxsZXJyYyArDQo+ID4gKwkJCQkgICAgaHdzdGF0cy0+cmxlYyArDQo+ID4g
KwkJCQkgICAgaHdzdGF0cy0+cmZjICsNCj4gPiArCQkJCSAgICBod3N0YXRzLT5yamMgKw0KPiA+
ICsJCQkJICAgIGh3c3RhdHMtPnJvYyArDQo+ID4gKwkJCQkgICAgaHdzdGF0cy0+cnVjICsNCj4g
DQo+IElESyB3aGF0IHRoZSBIVyBjb3VudHMgZXhhY3RseSBidXQgcGVyaGFwcyBybGVjIGluY2x1
ZGVzIG90aGVyDQo+IGNvdW50ZXJzPyBOb3RlIHRoYXQgdGhlIHN0YXRzIHlvdSBhZGQgd2l0aCB0
aGlzIHBhdGNoIGFyZSBSRkMgMjgxOSAvDQo+IFJNT04gY291bnRlcnMsIGFuZCBBRkFJVSB0aGV5
IG92ZXJsYXAgd2l0aCBJRUVFIGNvdW50ZXJzLg0KPiANCj4gSWYgdGhlIFJNT04gY291bnRlcnMg
YXJlIHNvbWVob3cgZXhjbHVzaXZlbHkgY291bnRpbmcgdGhlaXIgZXZlbnRzDQo+IHlvdQ0KPiBz
aG91bGQgdXBkYXRlIHJ4X2xlbmd0aF9lcnJvcnMgYXMgd2VsbC4NCg0KVGhhbmtzIGZvciB0aGUg
ZmVlZGJhY2suIEknbSBnb2luZyB0byBkcm9wIHRoaXMgcGF0Y2ggZm9yIG5vdyBzbyB3ZSBjYW4N
CmRvdWJsZSBjaGVjayB0aGF0IGV2ZXJ5dGhpbmcgaXMgYmVpbmcgcHJvcGVybHkgaW5jbHVkZWQv
ZXhjbHVkZWQuDQoNCg==
