Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418132B3B0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449930AbhCCEE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:4401 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581057AbhCBSir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 13:38:47 -0500
IronPort-SDR: jn+2ZX/hXMAWI6XD1gcBsBZXrAgnfIw3quOw1HsyNLZ5YhoC5Dlbw3LMqCFeDaXu1/cDiKOajj
 qefrMxSAvvSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="174065368"
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="174065368"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 10:31:19 -0800
IronPort-SDR: udlla3t/G2tmj3/rSXyD/AD3M+TwFb33raC89KBXpHgOaK4UtESjqD1eNT3HUPj4q4uKgGVDLV
 Lj0RpbYpTIZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="373685007"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 02 Mar 2021 10:31:16 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 10:31:15 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 10:31:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Mar 2021 10:31:14 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.57) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 2 Mar 2021 10:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNokBAc7zX2FPhSfqTyqR6NEGhTwz4dVnj0I5OqtlQ0lYU9oENZ2eJuzw2mhwgME9xTFP7hQ3FQkx73RHjMUjUTk+UttrYduN9Ws6Gy+JBhnyGAYGqP6q7x0CrSD5rISYM35ip0TkgmWPjl3fxH+QbKGnjpx40H+FgvwGHp46m9p1W6hWK1/FunrydFQyG1qgN6gpLNwfpaa1VF9Qf99js3KJf2nBepZYuF0qfk1oXbQJsKMLOjpNMk8npQ+6QFQpLofincE7iDNPNVjDumTjNi1NpaSZw+Jk2uhBA7vmmItISeUX7O9Q8jrts/U4EIJVkvp/u3tQ66YxQ4qrPIQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiZ9D6+YcXe28JYtyeICuT9jHmbiaAvIQtdsvYVceCA=;
 b=PElP5WvKAHhKlBEYfbqMQjlRVrdPJSYvIckAV0Eu+z/QcaHtKlPedn9AldYOjO878cDWDHuhAwr4kBEHWXgQFgBxDgty6pR+c/N3HXiBtheqbmpVzCmuANBkCMDJsnT22cuIXSjOc4iCB8iWy2Vh90b8whQEPM4P1ZLRTaeYCJgEkR0EX+4K0+ZeUGsOi1edEgoJ/a0ME8ez258lKLGrOqLbnMNSDHtfQU1JDpWiIWahRL+4G1SDjC2jm3qPk0VIF6b9bvSvl/lHcDhl4NxjIw7aRjbjSbQqIj7sFOUgNtqayOJ85+rbTYPfPGtnn+KV6NXf/vr2jdRlpOa9maNb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiZ9D6+YcXe28JYtyeICuT9jHmbiaAvIQtdsvYVceCA=;
 b=Nx1EWV4xquHlYKsGCqHuRoGnY6rTJyUz59H4qs2Px9nVEXp20wpUWqhb22HctFVhVs53BRdzCcUY1Fdjpffw9BqdNirO3Cd6SuZv8KhLCrQB2TElhF0YrsQLIU54L+l7LuEPJLa/gwADb2Ya35v2aPrrXWtaOyRRT9m5yf59lvM=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB5072.namprd11.prod.outlook.com (2603:10b6:a03:2db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 2 Mar
 2021 18:31:12 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf%3]) with mapi id 15.20.3890.023; Tue, 2 Mar 2021
 18:31:12 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "nathan@kernel.org" <nathan@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "gil.adam@intel.com" <gil.adam@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Thread-Topic: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Thread-Index: AQHXCesNOiAtSHfJpEaaXnkq3FBcxapq8rcAgACgUcSABX2QAA==
Date:   Tue, 2 Mar 2021 18:31:11 +0000
Message-ID: <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
         <20210226210640.GA21320@MSI.localdomain> <87h7ly9fph.fsf@codeaurora.org>
In-Reply-To: <87h7ly9fph.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 703bde8d-0640-4b76-eeea-08d8dda95b28
x-ms-traffictypediagnostic: SJ0PR11MB5072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB507204101696CFFF7A6577B090999@SJ0PR11MB5072.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zz+npyGgYCbBHkiTsGhTyBXzxekixNxJKsp0ERl9oVelgI39o9bNzPsrMbckkWVq2ZrQPXkCFvLjKIlJ8vRiIQ4/xms6ypd2G8g1TU5bPAvyrK+jiBY1PHLM9kWwqmNhY8r1WXuDQb0iR8BCEUDDYBpPPaqeKurk/2MOxU2dPL9P2J5wrEsvH/SF5m0TRmLwVzSfWeYa01FG6I2bC+zN+UWIht2TP5v3+RQJxJQy5zngTMxE2UHYQCFYthET+a6QFDgCxL1Qs8ChaMZid8IozmAMlq6bffF2WakyfZMKhalkTwyBYDHI0A+KUCmbqvsAuaAsiVnL1rP5x/vEewS9uRr9COcjrOGsEjmBFcm4gzp6KSNgbAOwqSXnVpi0je5LvoNgLwIMvwimS6eQGgrnSNaoezIbyAY/Q/qqX4WwcrpJacm6GchCz4WLcBlxla5RwvfqQfnCH1bHS+VWRqyq5t+4/bcPQHSXw7vO4qG50N0mOBP7voINYwGkDQweuSb7bPdtymqAwtgTeHckdncJjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(71200400001)(8936002)(316002)(6512007)(478600001)(76116006)(5660300002)(54906003)(4326008)(2616005)(110136005)(91956017)(2906002)(6506007)(66556008)(86362001)(8676002)(66446008)(186003)(66946007)(64756008)(26005)(6486002)(4744005)(36756003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eTRSaGxtdFc1NWF6enRyTm5iRnFIS1hXQmJlQS9XS3B0UnRoS3hlVjJjWXBR?=
 =?utf-8?B?NmZHTTVHUGhXZkZoTk9seTkxZnNjV1J5K0VTbU5UemFSNU5xRWNoZmNjcTVN?=
 =?utf-8?B?WW1HamVSN1ltVjFsUTNxZzk0UUdqMDlpYXZsb0lqbjlZcnNVU0ZXOEVWSEVn?=
 =?utf-8?B?eEN1TDBSMElScHZDNjNyRlhGRCtaQzhoWVZqdjZIZG1ubWNNbmw4ZVovbVBE?=
 =?utf-8?B?RXgvVStDbUZiMnFBMWFacHRsaVd6Z3lOUlJxNWUyMFBnK1VCUmNWTVdINVR6?=
 =?utf-8?B?bTF1KzA1blJuVlFha3VQbUJQZ1NvKzc3clFxb0NNY21jVzZHeXZvNXhlek5h?=
 =?utf-8?B?UG56YW1jRVRJcVE1VDg2QmVNSUNkWGhmSDMxcWN4NzRoMFB5L2F2WWZGTmI3?=
 =?utf-8?B?bDRtdldVcjRzTVNYTWw3Q0Rvc1BHcXJzQlVwUEplNmFEOWRJZWV1VWV2L0pN?=
 =?utf-8?B?RkxrYUkzRktDbDVMNHlLRTk4WEhqNFROcWE0MlMza0R0MXp5NTErQXVoTTZG?=
 =?utf-8?B?MW9hUzRsSnpsNnFHTGpTdUZ1WENjU05sVjRHV2xVQzRzSjlHYXh4NzVGa3lm?=
 =?utf-8?B?SVJaVGVDOFdibnN0aURRa1dXa2FzTkJybWNOVkpEWWpETmNiWjFKUDZiL0dj?=
 =?utf-8?B?UmZNKzBXZW9oRksxakpscmFzQkwzdEc1QXhROXFTYkhJRFprdGdZTUlCMEFj?=
 =?utf-8?B?SGRFcG04NlI4bUNxNEF0R2VZYW8zMjByMG5qSUtldmV3ZkVRWFNzMU54VGFh?=
 =?utf-8?B?bWxhYWtlSFg5Zmx6MVFTM1FpM3Y5bkRBT20xSzN0Tkd4cWNXc2VkanFWejBa?=
 =?utf-8?B?WWtGTE9jK0hqaENmZjhsNWhvNmtjclFkenFtNUZsQ2s1RWMzVnQxV0Njck5x?=
 =?utf-8?B?QmFZMmVEQ1NLVlpHdE5TQWMxemkzTW5zM3dMOVJQa0dYZVBGK1dSN0pmQWVV?=
 =?utf-8?B?YUlpNVBtVU9sZ1FyNEd0K3hnRjV0Y0xIYjA4YTM4N0ZUbVJ3ZU9ONjQ3ZlU4?=
 =?utf-8?B?OGh3bVhGSUNrQU1uWnB3ZTRwSXpXMStBK2JyOUlvY3cycmkvTCs1VVBKd2pS?=
 =?utf-8?B?SDlwa1dRS0t5M1hOLytScnV4dk8vcENNT3NMZnFkc0VySHVVL3JDbkJVVTZY?=
 =?utf-8?B?TDVWM0R4T2Z5OXJBaGZMdnFaZlc5d05Yd0RmZmVEWEw1Q0J5TDRXand2enZq?=
 =?utf-8?B?cW5saG5lempoOUZIbTFTeExRbU5jSkNHYmJoZkZzMVZscHNydzZvNGpwQ3dQ?=
 =?utf-8?B?M2dpRWVncVhzc2ZrckRvTUVJWGZRTHpMSmFpSm5BUFkyRGdQaFBkRmNXUFNa?=
 =?utf-8?B?d1h1eG1hUnJHL2g3UFF4VXZGTUxkc0FraWM5YmdmNXgzQThKNjR4ZjlUNSt4?=
 =?utf-8?B?Nm1hYTdzM0RiYWRNeHhZdnVNMFFDUWZwYVZjS0pia0RWT3JEcHg1YU5KdGdQ?=
 =?utf-8?B?SnZTYzlMMzJ0TTEwOThwRHY5OEJTenF5bHg1Q2xsVytzVm90Y3g5ekphK0JI?=
 =?utf-8?B?WDgxODFLQUFpcEhQaldBc09nL0xHdlhvczBZaFpid3BIK3BkVWNGQTFMT3lr?=
 =?utf-8?B?RFJkQTVnQ0lqOHFFbmE3SkJZM1JlZWYxVW5hWCtRZHhaVUZxMjdxa1B0MEZI?=
 =?utf-8?B?VEZIRi9JSHA4ZFcwaFVnbzhWTnZ2WnlreXpDeDVVOHpweXhIWVpHTFhBMXdr?=
 =?utf-8?B?MnJJcldmQW91NVRlTzliNjVCYWRSeTBvenF6UTZGeXJJeC9JQnVmamZKSlM2?=
 =?utf-8?Q?fODtE6vM49/9RYAMZxRmRUhMnmfSvhM1NpxeKII?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4841D4F9A60878439C2C3BDC487E5B3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703bde8d-0640-4b76-eeea-08d8dda95b28
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 18:31:12.0566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5djDE62nBZ6k4UvxhnUsjFg8jEw76jfcaYrtOIqF8YLYBetjNxP7BhMN/VZgvPLYH9p8QPFIpam/Z33fnLgslDlRYHvyQfq3SzQvW9rPHm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5072
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAyLTI3IGF0IDA4OjM5ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBO
YXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5lbC5vcmc+IHdyaXRlczoNCj4gDQo+ID4gT24g
VHVlLCBGZWIgMjMsIDIwMjEgYXQgMDI6MDA6MzlQTSArMDAwMCwgV2VpIFlvbmdqdW4gd3JvdGU6
DQo+ID4gPiBNYWtlIHN1cmUgZG1pX3N5c3RlbV9pZCB0YWJsZXMgYXJlIE5VTEwgdGVybWluYXRl
ZC4NCj4gPiA+IA0KPiA+ID4gRml4ZXM6IGEyYWMwZjQ4YTA3YyAoIml3bHdpZmk6IG12bTogaW1w
bGVtZW50IGFwcHJvdmVkIGxpc3QgZm9yIHRoZSBQUEFHIGZlYXR1cmUiKQ0KPiA+ID4gUmVwb3J0
ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogV2VpIFlvbmdqdW4gPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+DQo+ID4gDQo+ID4gV2UgcmVj
ZWl2ZWQgYSByZXBvcnQgYWJvdXQgYSBjcmFzaCBpbiBpd2x3aWZpIHdoZW4gY29tcGlsZWQgd2l0
aCBMVE8gYW5kDQo+ID4gdGhpcyBmaXggcmVzb2x2ZXMgaXQuDQo+IA0KPiBUaGF0IGluZm9ybWF0
aW9uIHNob3VsZCBiZSBhZGRlZCB0byB0aGUgY29tbWl0IGxvZy4NCj4gDQo+IEx1Y2EsIHNob3Vs
ZCBJIHRha2UgdGhpcyB0byB3aXJlbGVzcy1kcml2ZXJzPw0KDQpJIGp1c3Qgc2F3IEplbnMnIHBh
dGNoIG5vdyBhbmQgSSBkb24ndCByZW1lbWJlciBpZiBJIGFja2VkIHRoaXMgb25lPw0KDQpJbiBh
bnksIEkgYXNzaWduZWQgaXQgdG8geW91IGluIHBhdGNod29yaywgc28gcGxlYXNlIHRha2UgaXQg
ZGlyZWN0bHkNCnRvIHctZC4NCg0KVGhhbmtzIQ0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1
Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
