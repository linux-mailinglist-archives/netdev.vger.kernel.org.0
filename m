Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3401B441437
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhKAHeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:34:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:45115 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhKAHet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 03:34:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="211016948"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="211016948"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 00:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="488533423"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 01 Nov 2021 00:32:16 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 1 Nov 2021 00:32:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 1 Nov 2021 00:32:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 1 Nov 2021 00:32:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9KJzMlwKKE6PM0VUmJFsrdhR+FLMZvNylv1VP8bGVpoiWN6Plmhs5kNho/sYRgMqUZCI/AQSzmz8U2pQLUN0FEqiJGRXzqvbKsUUoRghMGgzAEzVBsR9AjJwOcz7Znf3dc9McMHROxmJSLx6SVTQOGK8Fs6g+QdmxwZLVv6bTtqG5tAoyBfU3mhMWPP3B77EyLnPohim8CUeZH8vzJMFUd1KoY8gZqqwExiMQ6sDzTOb5Dosp/w3E26zTZOFHxzYCv6ZhYT+LTocicMCMcsUPuL+b4ApdqbjymEgeVjefCrQKAEfMqWY5WHpV3LGkD5fOADtWhLIDaVUNGS0gKZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KG/XsaAM7a4S7JXvtQ7Q5zXZzj7wASBXjNjkmpQEFI=;
 b=nBbajujaK5wDgeVZvvQA5qDeHhsH2MO/RBIbjxg5EhygsFT0OWsWVyBtl7BltcY1VBf6JQn4EF8CSFMOTdW4j80ELXmpY6TYOKe0kEftaaa1t1zVNYkeKUuAk+cZEA4G8urgqrCcKQBJhLzFE2er3sVKKFa/QYpPbfnpNO0yHYnK8OoD6yBRTE2xbD42XGZHsqooUZUDT7MJTXyw/V3qiuneAaL7bcnOxc1U+foPQcHcaVUO+Z9KyrgXOw/gFAhTGSnVfdm9jIPatA45x1eeDCrYCWTug5tB26Jfohgf5egUcy8OxyAJ13s10uen21KCNaoyGbQBy/w4lh17+KtJaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KG/XsaAM7a4S7JXvtQ7Q5zXZzj7wASBXjNjkmpQEFI=;
 b=WLRmOuJaYnrUTvBwqpGdPixwHgCJi4orBihMR1sRJbK5kRSA5INU82FQdXU5iscRei6+TtRIreDDIcGJBhC96oxAa/oyGGXi8MjG7bL2hon3e5upBqUvSxDbEjCQdS2wlYvONCXu68M+NLPRAY9riD7SjvvwUqqgCZGGVPv88e8=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2647.namprd11.prod.outlook.com (2603:10b6:a02:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 07:32:14 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 07:32:14 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "arnd@kernel.org" <arnd@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Baruch, Yaara" <yaara.baruch@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Gottlieb, Matti" <matti.gottlieb@intel.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: pcie: fix constant-conversion warning
Thread-Topic: [PATCH] iwlwifi: pcie: fix constant-conversion warning
Thread-Index: AQHXzNu91lvhoHPzmEaAAhHmpvVRJavssg70gAGYogCAAADDAA==
Date:   Mon, 1 Nov 2021 07:32:13 +0000
Message-ID: <bf9e17301c7d38e5b9f7e0e9989a7445e6dd7a3a.camel@intel.com>
References: <20211029154253.3824677-1-arnd@kernel.org>
         <87tugx3c7f.fsf@codeaurora.org>
         <4e1abf0c252ed1f049e1be77247626af369aa5e8.camel@intel.com>
In-Reply-To: <4e1abf0c252ed1f049e1be77247626af369aa5e8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0-2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c40813c-5c84-475e-2b85-08d99d09b967
x-ms-traffictypediagnostic: BYAPR11MB2647:
x-microsoft-antispam-prvs: <BYAPR11MB26472E52C8F5D294ACC0B52D908A9@BYAPR11MB2647.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UDi7375mlZE+s4kKjxuZWfgn5yNx/SRSN5gyCGxU87NEPeEdmop6PREQO6pT5+SriVSm8Gj4O/bzliXGakFbwQXKSdCb3RI439xJISObyk04Y9l8rO3QYbKg/JlLgmHX4S2Elq5u/0Y02Skd94QlEp6ngYrDGG1qSibSQKVZlqFEKZDGk4FGYcac0wGqLDZGfwhJNwAHFdnE7KiujCfoHZEMvuYlFTyJV1eQrPWtyUQZYQdnmb4wb5w9nTTDDmOCldkxES5hrdgKltmau3CiZCk4U3Q6gmMnkjMGNZR9nRQ3ZIq78AMx8qzVjudrKR6JG3Uqxzg1Y6nVIfUw66XqeM9vixKmmdOkMBkPrhn3p377D90YJjuPeSF2Kzc+to/Uji5mxtrLJeDoD/UMLT16nkKWbAUTLpdH9xtSyJklwl/f6mjINX4Q4YHQ2UBx53qNglfp4D5deu+3VnP8YgUbAZaYapsVZFXyeJ4Qlr+lLtFFUjJA2hGvwa7JvSEmR5rwV0wSIWRVEkUUQgQeW0W8pxJclUOfl8ZoU5mKVtdRD9rRUUWoN7/HsKB+wE9KEiXH9XKBOFvH0jb9GG7OrX9zZ7CTaF9+5HZVnDz3kvEejnVOqdtdL+0vQpFCE4OlXFCdilWk/qwJBTIZtUDaKA9UhZfCUzNr3Y7KidtWVONKdiXbWJSTsNf0UjzJLJ62TXyuvFA9R+ee5RvoXpQHBRbX6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(54906003)(316002)(110136005)(66476007)(91956017)(4326008)(8936002)(7416002)(36756003)(6486002)(8676002)(66556008)(38070700005)(66946007)(2906002)(76116006)(66446008)(64756008)(82960400001)(6506007)(122000001)(26005)(4001150100001)(71200400001)(6512007)(38100700002)(86362001)(2616005)(508600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVB6NUxXeHhyMWpjalR2aXAvL040TE92cVlheTFjM0o1b29IY25rTy8vM1JY?=
 =?utf-8?B?V3FZV05oVklZVVdEZFY2eFZ0bmEyZHFpL3ZURy9pZTBmcExHR0lwQ3dKdXdV?=
 =?utf-8?B?ZFQ1MUh2aWl6T0dCWEt4cnFTcWs0MjdCaC9idk05RmYyMjBtbGt4QmJXbldr?=
 =?utf-8?B?NjM2WkJNaFdFa29lUEdzZk1NQzN3OTNHM3lKbXp1TndrWk82VVdaYUM0OFZt?=
 =?utf-8?B?TTh4eU1RQUhjNmZCcUtpdlJBZVErS1ozVzBnSjFld3AzRUNmYisydWZyK1Z6?=
 =?utf-8?B?SWJjUkVSMUFKcVF6S1lKUkNCZ1ZLKzVINGZWZ25qWUtpVTVHWk1aT2dNM21X?=
 =?utf-8?B?UmQvVEZoWHE3REVaYjlMVnhuaHBvekhaVlFWUzkwVVhZREZlcGY1YUZMUGxI?=
 =?utf-8?B?a3BOMEZEM1lUYjZ3c1o5N1orUnptZ2grSHYxb0NJTDhCUUVxQjd1ZmRCT3g2?=
 =?utf-8?B?b1preS9JeVM1cS94bTdYbUxpYVVkYkNsa2M1dDZCUC9xUjBjcmtWWGFaSGVr?=
 =?utf-8?B?NktDeW5WOTNSLzk2SDQ1T3BEd0FkMXVJREdaV3lWbGthMVJwS3VReG9iS2dO?=
 =?utf-8?B?YTJ0K1l2S2ZLS1VCQVlZbzBOdEovTE56WW84UWd0Wi9LaXZHL0FiaFg5Wm5q?=
 =?utf-8?B?S0ZNdGk3bWpnZ1FwaVZGdGdnMllBNzR6WHRMbGVZSEs0TE5SSmRsN0ZSRkdz?=
 =?utf-8?B?VUxZc3RveGFxNzJIdWdLOUdMWUoxYXJDdWg0enM2OGt0V2M0R2VhTTA0blJz?=
 =?utf-8?B?UEM1YURIMXFxZHZCT09nTnZtQmx5eTV2andoV25UcmsrZ3E2emYva0tYM0J0?=
 =?utf-8?B?WkdzMFJnTnBpdTIrWDhnVm45Qk0wMnA3a3pRNFc3cyt1WUtMTmh4ZzhSSlM3?=
 =?utf-8?B?dDIvditsSlcwMUxOOVEzbEN1em1oVGFMMHhIQVMyYlROd0t3aGNMZFFzWmpJ?=
 =?utf-8?B?bkIxYUZ1SW1aZ1RMY3QyRUhwS2VCdGM0VG13azN6cUducE9qd0ZqcHdiMUR5?=
 =?utf-8?B?RFBZNnNXdytGNmt3QXJhaU1Ia3h3YWZQOVV5cjdtQVVyQ0hpQjBrekhYMFBW?=
 =?utf-8?B?Y2RUdzVCRFlMK0ZsWDRIb0FDNlZWWmFpbUk2TWQ3SHdKK0tpMHpjRlJSOTJ3?=
 =?utf-8?B?TXp0RHBMajlSeDJmYWhhUlAxQ1gvZWJ0ZjM5SlNZbXZmM3pCVmZzNk55Zldv?=
 =?utf-8?B?eGdrQnRCSXNHQ044SW1EQk5TbTduWEwwV2QxL0g2eHc0RGtWKzBjSm9mL1hU?=
 =?utf-8?B?Qm1ILzhOalpFSmZTQXhnU1oyTzFXOUdwWTVlQ3d0QXBSd1NhNHBodzNKbDdl?=
 =?utf-8?B?Vko3L0crakxWeHRwK0dsYWs1czJacUxjbmszV1FkRnZEREpPc0YzUG4vQUtH?=
 =?utf-8?B?YWR3dStXZEc4SlMvTzRzdGwzd0JJU2k1b3FnQWc3T2dHZ0lUalpwN2N0Q3Zu?=
 =?utf-8?B?M1pkU3FMWDFOTnFBUi9LMWlJUEE3YVJoTmtvSzVEQzFWOUZmUnlVeW5tS2JN?=
 =?utf-8?B?aDc4MDNnWjhUeisrcW5KVDNrTlBtUXpSREZ2Y2ZtdklhVW4wQk5ieFpHRTU3?=
 =?utf-8?B?V1lFWTlHTjM0V1R6TGZvNDVXQmQxb2JUZm15UTU1S2ovQXVWbTdHaEF1OVBw?=
 =?utf-8?B?VXFYZEU2WW9FdWF6aURLV0pmNXc2czYvMWJ3a202N2VpMUFzZ1cyTGJTVWZr?=
 =?utf-8?B?MzErUGQwZ05VSnA2blVISmVjdkFRL2FSbVk4NEVSTEY1SXRzNWw2LzhLaTBN?=
 =?utf-8?B?L1BHNk5IZ2F0VWxRV0xVL1pkeHZtbmk3TEhNMkNzNHZpS0Fic2RlWkZHbGFq?=
 =?utf-8?B?cDlPUzRVcU5KWjJBdXNUZ09QVTFlT3Y0WDIwZ0lCd2o4Q1ZDVXpxbjNGNVhx?=
 =?utf-8?B?WE45UVBYNk1xdlRkU1UydGJpTmxPbFRmZm5uaktuQldEZGhmQm9QeXJxdmJD?=
 =?utf-8?B?UlFLNjVCYkhLcTFXZ29mTW4rOG4xMXg2V2pxR2kwT3JsTGxIc0FjMWtzclls?=
 =?utf-8?B?YXNJazdCUEY1SGdtamlXZUMvRTZwN1NpbHB2dUhleFU2NVJFM2NweWVjRzBz?=
 =?utf-8?B?Skx1NklicnBWSS9ld2R3cUpqanU0VStFZXhRdmVtNU1meHV4MFBEdWZVckpo?=
 =?utf-8?B?Q3BsNmltRml0a1FyazhZLzNEdjA1TWo1RFhMdjFmbFpOWjdWREtVR1NqREZr?=
 =?utf-8?B?aU9mazREcFJDVC85YzR0dnhCOTZBSTdvRTB3c0JZcWhhTUNpUzByem4vbTVz?=
 =?utf-8?Q?BIi1ewYhY0Yo4+r9aSeoEV6j6+5WdwvSRuL3Z1UtZs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9ACA7E3D2CDB1F428CDA62C293E92512@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c40813c-5c84-475e-2b85-08d99d09b967
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 07:32:13.8819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vo+icH9SaxKybNeSudg4CNt+ShwGG7ORaSdKA+4mfE9tx2o2yciJEKlXc2opwBRJ+kRz3MbthSwgFLt5HandtH/VmGuIvHmsRNWEqV1Hy0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2647
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTExLTAxIGF0IDA5OjI5ICswMjAwLCBMdWNpYW5vIENvZWxobyB3cm90ZToN
Cj4gT24gU3VuLCAyMDIxLTEwLTMxIGF0IDA5OjA2ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0K
PiA+IEFybmQgQmVyZ21hbm4gPGFybmRAa2VybmVsLm9yZz4gd3JpdGVzOg0KPiA+IA0KPiA+ID4g
RnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPiA+IA0KPiA+ID4gY2xhbmcg
cG9pbnRzIG91dCBhIHBvdGVudGlhbCBpc3N1ZSB3aXRoIGludGVnZXIgb3ZlcmZsb3cgd2hlbg0K
PiA+ID4gdGhlIGl3bF9kZXZfaW5mb190YWJsZVtdIGFycmF5IGlzIGVtcHR5Og0KPiA+ID4gDQo+
ID4gPiBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmM6MTM0NDo0
MjogZXJyb3I6IGltcGxpY2l0IGNvbnZlcnNpb24gZnJvbSAndW5zaWduZWQgbG9uZycgdG8gJ2lu
dCcgY2hhbmdlcyB2YWx1ZSBmcm9tIDE4NDQ2NzQ0MDczNzA5NTUxNjE1IHRvIC0xIFstV2Vycm9y
LC1XY29uc3RhbnQtY29udmVyc2lvbl0NCj4gPiA+ICAgICAgICAgZm9yIChpID0gQVJSQVlfU0la
RShpd2xfZGV2X2luZm9fdGFibGUpIC0gMTsgaSA+PSAwOyBpLS0pIHsNCj4gPiA+ICAgICAgICAg
ICAgICAgIH4gfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fl5+fg0KPiA+ID4gDQo+ID4g
PiBUaGlzIGlzIHN0aWxsIGhhcm1sZXNzLCBhcyB0aGUgbG9vcCBjb3JyZWN0bHkgdGVybWluYXRl
cywgYnV0IGFkZGluZw0KPiA+ID4gYW4gKGludCkgY2FzdCBtYWtlcyB0aGF0IGNsZWFyZXIgdG8g
dGhlIGNvbXBpbGVyLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogM2Y3MzIwNDI4ZmE0ICgiaXdsd2lm
aTogcGNpZTogc2ltcGxpZnkgaXdsX3BjaV9maW5kX2Rldl9pbmZvKCkiKQ0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPiANCj4gPiBMdWNhLCBj
YW4gSSB0YWtlIHRoaXMgdG8gd2lyZWxlc3MtZHJpdmVycz8gQWNrPw0KPiANCj4gWWVzLCBwbGVh
c2UgZG8uDQo+IA0KPiBUaGFua3MuDQo+IA0KPiBBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2lh
bm8uY29lbGhvQGludGVsLmNvbT4NCg0KQWN0dWFsbHksIHdvdWxkbid0IGl0IGJlIHNpbXBsZXIg
dG8gY2hhbmdlIHRoZSBkZWNsYXJhdGlvbiBvZiBpIHRvIGJlDQp1bnNpZ25lZCBpbnQ/DQoNCi0t
DQpMdWNhLg0KDQoNCg==
