Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188AD3DF3C9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhHCRS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:18:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:33112 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhHCRSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:18:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200929810"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200929810"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="636676219"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2021 10:18:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 10:18:11 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 10:18:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 3 Aug 2021 10:18:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 3 Aug 2021 10:18:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrRbV1c7edZ7EUKtdTb3/IAwcymkDO4VlGeYLNoX9Czts8fSpw40dRct1gcx1Es12XA8dRE9QtJ6Js3m6XlFI5OhFBXggrobkmX+ftIN++alNiVMl34R1PHt9yrYsOtlBxXzxzfZl+nJ+Wl3nCZKazqCTx88R+TBfoFpeOVK2SZxF7udoVFcZcNqJkE5bBJOtHlYXUU9zu8MvJmWN03Exdq7iVH3nWYvhURN8n1E7NLUTfuQtst8Q6BLjyr58aMA7AWBRTSur+WK+vqVQY4iHPmt5ci4hoObIEOUdf8hl/CeL1rGs3QMRvZGIZpXVwRzcQ4rnAtzGOhROHrdbfUM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JlK5UV/XCvDwNnuDRM6Z+Idxzoq5SoResqNmxvOKOQ=;
 b=heaAXZFJJINnqFwxEbJMQP8GKZTnz7IT/JVst7/abD4vFAEtT4lQteSoUAayua9XEKZJH1Jt3un61lfVbpKXLbPquiW4OaSWQQjVlb5wOv6KCD7vmOg/zyhpIWU6lkUfPRJ32ZJT6rHJEf1P/+bc3UJ0C6f5Jm0FJiZkUSFqZ8V1Vf3ERc70sbmk2oR+giRJY/yCkL157y9JNCgwSi3cFXsBTSVwbqoyoilPIdbktUaTAS3vZkOahJVQbpkJX3A713ZMGmPujHibsXWepbPe8Hmb+vQlNCUkIWbtDX/gS4XlWFaOa1tfvLa2mMeKIN+BCTHxvcfhf0SeK3AxSSn2Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JlK5UV/XCvDwNnuDRM6Z+Idxzoq5SoResqNmxvOKOQ=;
 b=QeqGRXbyIepTlt+EyT83z68+U1bTaxQ0Tkp994x0d8id3W/GqVflCkv18nA5DoOBaVE9uFnv/zzT8uIm0viBLfkhUw97gUTPMWJchUK9/aBvNesme6C6LbeVHAoOryDCH+0mpkyLG1RFCFhJNWSlL6Issc+OoC2bL4Igsm5i8ZU=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4604.namprd11.prod.outlook.com (2603:10b6:303:2f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 17:18:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 17:18:06 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Nicolas Pitre <nico@fluxnic.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAADaFgIAAgzoAgACWAgCAAAU1AIAADOyAgAAEIGA=
Date:   Tue, 3 Aug 2021 17:18:06 +0000
Message-ID: <CO1PR11MB50892EAF3C871F6934B85852D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org>
 <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 156ebfbd-2388-4046-5abf-08d956a2a8d5
x-ms-traffictypediagnostic: MW3PR11MB4604:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4604F67AAEE16412C8EB25C6D6F09@MW3PR11MB4604.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uRnfSCCTMf7EXvbs/1ecDLnuV69jmrPua7+XwVLn3g59MClVw3yvlQTYHu0QCOc2kQDqLD2rogS4mBMLQmmJRV7DoRs2GOpSTRCt1crvlgtxGFd7JhVWyPbMMpZM/CmvhP8/I/frEVp4rFr3rtOEZStd13uJLNAxLZR5jhChqkAtHZdYK7XURruXot9CM1tHPDKQ7q9LxRhYACBPv9YF48CBJ+gVBFrzybVTwLbWh0ZSk+KzZ0RZgNPA/2l+LHOnyLMHY5pz/4j8YU60AO50HOzth4SeCBQeZ8tsuudY/bahGnjnPcD4pkWsWCQ4lQk0tdLfskSznCcSdWR9+Uv3qxDzYF8brMzXUwMzqXPwD4DmEd2iq1Y3zfCpV47ccT0ikv0bxFxxaTGBY83vsWXeRJbtPaqkn4pEb8H5Ix/j20aM014w58O8mV99k2q6zpNt+kpUikYC6Gdpzschdib/Biou1tu5wLZNA8swMD+m4GmtAAXwsaqUp+6WrM3kVTLoR1h10Cl/sXxBTEsBsoM1Pmdgx4nFRz6LKlMdWp7hVaWZ3FudluHEgfXRJLIkM1M8UX0/PcWma4zhu+n0djI6Z/X9l/rdy6g/jcg98r+08cBk3I7v8jcc5xx5F97ybaG9IymzKPZtcG25f1hgZIHBDdta2osXVheXNWnW7t3wNzUYlmWtYrpjM9EQxEdwlPkcO9nM/Ebp5r62cD1oueJ8jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(54906003)(55016002)(5660300002)(38070700005)(7416002)(33656002)(316002)(110136005)(86362001)(38100700002)(71200400001)(8676002)(122000001)(83380400001)(478600001)(53546011)(26005)(52536014)(186003)(9686003)(7696005)(76116006)(6506007)(2906002)(4326008)(66446008)(64756008)(66556008)(8936002)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVpBbkJkTEs5NGVHN0hZTGU0QytSYzJvRE9PcjRuK25XMW04ZkNNZmNiNGN5?=
 =?utf-8?B?ZWxJYnR2R3ZKUmhCUkoySldHT1kwdnpyci84bS9vUkJZa1NNQ0JQZVdPZzhL?=
 =?utf-8?B?SngrL3lpQ2hheDlibjloTWc0aUkrOVVRanJOQ0grMW1Hb0hKY2M4UjFxR2Yv?=
 =?utf-8?B?NngwZUtMQmlQUmIrYzEvVnJhQWRrNjZOQlVFZ3FVQjJjZVNKRWJBdGRvd3hI?=
 =?utf-8?B?KzF4UVVqNHJMZVlPNFBBdUF4OERRUVdOa3l4WEtCMWQ3SWZtTXlMcVNHMllE?=
 =?utf-8?B?cjVPTlJlUXhQYnRxQjJ2VTUwK3drY3ExeWhWYnhuRXRWdmRrK2pLNXArakhN?=
 =?utf-8?B?NEhZbXlpd1VEUitLM2RaOE5QUzdVRTRkaWJYREVYclR4VW9xWGVmelIyd2Nj?=
 =?utf-8?B?MlZNRFlVNFZsS3FWWnZnd0s5UkZZMVh4dGNPVktNQy9ieDZFSC9xRGVacjVk?=
 =?utf-8?B?VTNnMUk4K1pRZ3Z0bjlLQk1yUXE4Z1cwbkFMUWtKamVwM1hNUGJtUEMxdjhM?=
 =?utf-8?B?M0JXWngrUWM5ZUJ0UnN5LzN6TmY1Uk05S3Nrc3hJVHZHdlNoTS8zdTQ1SWM5?=
 =?utf-8?B?clRwOWxlS3Fwa0lmc0t0U3dGWitFaWpsaEFHL0FhTVBMMWVwOWozczFNM3R1?=
 =?utf-8?B?a216TG53TjFYVnFlTHZGcTQ0dGVKeU5ZdFlCbDFEUjhLd283TFd0VFNWNEhq?=
 =?utf-8?B?bVNCVWJEeW1PSDJBVEo2ajNQVkZzVUZkMTlIK0hTbEc4NDR0aWZSOVkvbFZN?=
 =?utf-8?B?NmdZNjMwTnVQL24xUW0zN0F0RHZHNUJHOUpGMnNWQ2Zjd1c0cUdsZHFjd2pY?=
 =?utf-8?B?elQxWUpuczkzUWNMVTlDNE90Ujc3MUFLc0VKcUs2Zmt2TkxzQnAvYktaV2NC?=
 =?utf-8?B?a3ZySGUwYmNGQWJLT0YxVWNCRUdZd3VGdjhlV0VqTGN0U3kwRHRwQSsyZTho?=
 =?utf-8?B?eFVTb040anVhMmwyZVJVaVJ4akF4c2g5TVhGRUNDV0o5YVd6bjgrM245bDVm?=
 =?utf-8?B?YkRJUzR1Z0UwQVlSZjEwdVNnaFVnSWRRSEtCVE1WZFpLZ0ViQWZoWGllSUN2?=
 =?utf-8?B?eUsxTzZHZXkrcXNXU2Z0TzhEd1NYdnAvbEFFSlJDQVF5dG5sNlBqYzFCUmlO?=
 =?utf-8?B?ZXZMWGI5bDMxSzV2NndGUjJLajY2Q1ZRWGs2dmQ2b3JSczlMMkczbzZVdmht?=
 =?utf-8?B?dGZjdzF5eWVRS0lSRTVBd0U2dTMramZ5QXMwdDlmU015M0JQWElEd1lNNXRt?=
 =?utf-8?B?Qlg4U0hzaXlDb3B6ZytnbWRGZHVvUXBNalYyVmtoWk1Wc1VSWHhSeUo1Z2dh?=
 =?utf-8?B?VVVvZ2E2NjZac3FsRnpVOUVzNHpwdVdyaVVJTUVXeEhFbnlycnNCVkZXbDJp?=
 =?utf-8?B?Q2RDeUszTUcrLzdUSG41aUR5N1RBUHF6Wm1XWTlJeThUekJlZUdmckt5WmRY?=
 =?utf-8?B?ZjhNQ1IwOU1vQWNrbW5TQkxWSlNxaHk0Zlh2KzlIMkthRlRsdWtza3htQmxF?=
 =?utf-8?B?VzBoK1N6bUZDdEhuK3RlTFpZekp5Nm1iYzFWVE1kdkNaeHZzeUNYd3VHSEZV?=
 =?utf-8?B?VUswalJXOHAxdXFwYThFUGEyandwcm5yYmpzR2VLalBjVE5hR0wxNTVmYVhr?=
 =?utf-8?B?VU1UQUtud29UZnMrUU8zUkg4V2g4cHFxRi9sb2w2RnhpNjlxbWQ0NGVOcDZy?=
 =?utf-8?B?ZUx2ek05TGwvV1NrMjNGYUo2a1FHcEUrMWpRVlBFZXBGcXhuN2NGa3hXWXFx?=
 =?utf-8?Q?VJx0nKGQjq0h2wMrCkqDoqEsrmAVGXJZojAN5ha?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156ebfbd-2388-4046-5abf-08d956a2a8d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 17:18:06.5845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kk+h7YYMoQ+z4sRPYAO1Ey+7Q8AORgtzihd6j8/kO0GKxpee64YslBUzY/0LgNcPuO1hDu1MVsByQzysDtoPetWHdjLgRCAnxxKLp2npnC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4604
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBBdWd1c3QgMDMsIDIwMjEgMTA6MDEg
QU0NCj4gVG86IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBD
YzogTmljb2xhcyBQaXRyZSA8bmljb0BmbHV4bmljLm5ldD47IEtlbGxlciwgSmFjb2IgRSA8amFj
b2IuZS5rZWxsZXJAaW50ZWwuY29tPjsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5k
ZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhvbnkubC5uZ3V5ZW5A
aW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIN
Cj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIu
ZGU+OyBLdXJ0DQo+IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47IFNhbGVlbSwgU2hp
cmF6IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47DQo+IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQu
bS5lcnRtYW5AaW50ZWwuY29tPjsgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gZXRoZXJuZXQvaW50ZWw6IGZpeCBQVFBf
MTU4OF9DTE9DSw0KPiBkZXBlbmRlbmNpZXMNCj4gDQo+IE9uIFR1ZSwgQXVnIDMsIDIwMjEgYXQg
NjoxNCBQTSBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gd3Jv
dGU6DQo+ID4gT24gVHVlLCBBdWcgMDMsIDIwMjEgYXQgMDg6NTU6NTZBTSAtMDcwMCwgUmljaGFy
ZCBDb2NocmFuIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBdWcgMDMsIDIwMjEgYXQgMDg6NTk6MDJB
TSArMDIwMCwgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gPiA+ID4gSXQgbWF5IHdlbGwgYmUgYSBs
b3N0IGNhdXNlLCBidXQgYSBidWlsZCBmaXggaXMgbm90IHRoZSB0aW1lIHRvIG5haWwgZG93bg0K
PiA+ID4gPiB0aGF0IGRlY2lzaW9uLiBUaGUgZml4IEkgcHJvcG9zZWQgKHdpdGggdGhlIGFkZGVk
DQo+IE1BWV9VU0VfUFRQXzE1ODhfQ0xPQ0sNCj4gPiA+ID4gc3ltYm9sKSBpcyBvbmx5IHR3byBl
eHRyYSBsaW5lcyBhbmQgbGVhdmVzIGV2ZXJ5dGhpbmcgZWxzZSB3b3JraW5nIGZvciB0aGUNCj4g
PiA+ID4gbW9tZW50Lg0KPiA+ID4NCj4gPiA+IFdlbGwsIHRoZW4gd2UnbGwgaGF2ZSBUV08gdWds
eSBhbmQgaW5jb21wcmVoZW5zaWJsZSBLY29uZmlnIGhhY2tzLA0KPiA+ID4gaW1wbHkgYW5kIE1B
WV9VU0UuDQo+IA0KPiBJJ20gYWxsIGluIGZhdm9yIG9mIHJlbW92aW5nIGltcGx5IGVsc2V3aGVy
ZSBhcyB3ZWxsLCBidXQgdGhhdCBuZWVkcyBtdWNoDQo+IGJyb2FkZXIgY29uc2Vuc3VzIHRoYW4g
cmVtb3ZpbmcgaXQgZnJvbSBQVFBfMTU4OF9DTE9DSy4NCj4gDQo+IEl0IGhhcyBhbHJlYWR5IGNy
ZXB0IGludG8gY3J5dG8vIGFuZCBzb3VuZC9zb2MvY29kZWNzLywgYW5kIGF0IGxlYXN0IGluDQo+
IHRoZSBsYXR0ZXIgY2FzZSBpdCBkb2VzIHNlZW0gdG8gZXZlbiBtYWtlIHNlbnNlLCBzbyB0aGV5
IGFyZSBsZXNzDQo+IGxpa2VseSB0byByZW1vdmUgaXQuDQo+IA0KPiA+ID4gQ2FuJ3Qgd2UgZml4
IHRoaXMgb25jZSBhbmQgZm9yIGFsbD8NCj4gPiA+DQo+ID4gPiBTZXJpb3VzbHksICJpbXBseSIg
aGFzIGJlZW4gbm90aGluZyBidXQgYSBtYWpvciBQSVRBIHNpbmNlIGRheSBvbmUsDQo+ID4gPiBh
bmQgYWxsIHRvIHNhdmUgMjIga2IuICBJIGNhbid0IHRoaW5rIG9mIGFub3RoZXIgc3Vic3lzdGVt
IHdoaWNoDQo+ID4gPiB0b2xlcmF0ZXMgc28gbXVjaCBwYWluIGZvciBzbyBsaXR0bGUgZ2Fpbi4N
Cj4gPg0KPiA+IEhlcmUgaXMgd2hhdCBJIHdhbnQgdG8gaGF2ZSwgaW4gYWNjb3JkYW5jZSB3aXRo
IHRoZSBLSVNTIHByaW5jaXBsZToNCj4gPg0KPiA+IGNvbmZpZyBQVFBfMTU4OF9DTE9DSw0KPiA+
ICAgICAgICAgYm9vbCAiUFRQIGNsb2NrIHN1cHBvcnQiDQo+ID4gICAgICAgICBzZWxlY3QgTkVU
DQo+ID4gICAgICAgICBzZWxlY3QgUE9TSVhfVElNRVJTDQo+ID4gICAgICAgICBzZWxlY3QgUFBT
DQo+ID4gICAgICAgICBzZWxlY3QgTkVUX1BUUF9DTEFTU0lGWQ0KPiA+DQo+ID4gIyBkcml2ZXIg
dmFyaWFudCAxOg0KPiA+DQo+ID4gY29uZmlnIEFDTUVfTUFDDQo+ID4gICAgICAgICBzZWxlY3Qg
UFRQXzE1ODhfQ0xPQ0sNCj4gPg0KPiA+ICMgZHJpdmVyIHZhcmlhbnQgMjoNCj4gPg0KPiA+IGNv
bmZpZyBBQ01FX01BQw0KPiA+DQo+ID4gY29uZmlnIEFDTUVfTUFDX1BUUA0KPiA+ICAgICAgICAg
ZGVwZW5kcyBvbiBBQ01FX01BQw0KPiA+ICAgICAgICAgc2VsZWN0IFBUUF8xNTg4X0NMT0NLDQo+
ID4NCj4gPiBIbT8NCj4gDQo+IFNlbGVjdGluZyBhIHN1YnN5c3RlbSAoTkVULCBQT1NJWF9USU1F
UywgUFBTLCBORVRfUFRQX0NMQVNTSUZZKQ0KPiBmcm9tIGEgZGV2aWNlIGRyaXZlciBpcyB0aGUg
bmlnaHRtYXJlIHRoYXQgJ2ltcGx5JyB3YXMgbWVhbnQgdG8gc29sdmUgKGJ1dCBkaWQNCj4gbm90
KTogdGhpcyBjYXVzZXMgZGVwZW5kZW5jeSBsb29wcywgYW5kIHVuaW50ZW5kZWQgYmVoYXZpb3Ig
d2hlcmUgeW91DQo+IGVuZCB1cCBhY2NpZGVudGFsbHkgZW5hYmxpbmcgYSBsb3QgbW9yZSBkcml2
ZXJzIHRoYW4geW91IGFjdHVhbGx5IG5lZWQNCj4gKHdoZW4gb3RoZXIgc3ltYm9scyBkZXBlbmQg
b24gdGhlIHNlbGVjdGVkIG9uZXMsIGFuZCBkZWZhdWx0IHRvIHkpLg0KPiANCj4gSWYgeW91IHR1
cm4gYWxsIHRob3NlICdzZWxlY3QnIGxpbmVzIGludG8gJ2RlcGVuZHMgb24nLCB0aGlzIHdpbGwg
d29yaywgYnV0IGl0J3MNCj4gbm90IGFjdHVhbGx5IG11Y2ggZGlmZmVyZW50IGZyb20gd2hhdCBJ
J20gc3VnZ2VzdGluZy4gTWF5YmUgd2UgY2FuIGRvIGl0DQo+IGluIHR3byBzdGVwczogZmlyc3Qg
Zml4IHRoZSBidWlsZCBmYWlsdXJlIGJ5IHJlcGxhY2luZyBhbGwgdGhlICdpbXBseScNCj4gc3Rh
dGVtZW50cw0KPiB3aXRoIHRoZSBjb3JyZWN0IGRlcGVuZGVuY2llcywgYW5kIHRoZW4geW91IHNl
bmQgYSBwYXRjaCBvbiB0b3AgdGhhdA0KPiB0dXJucyBQUFMgYW5kIFBUUF8xNTg4X0NMT0NLIGlu
dG8gYm9vbCBvcHRpb25zLg0KPiANCj4gICAgICBBcm5kDQoNClRoZXJlIGlzIGFuIGFsdGVybmF0
aXZlIHNvbHV0aW9uIHRvIGZpeGluZyB0aGUgaW1wbHkga2V5d29yZDoNCg0KTWFrZSB0aGUgZHJp
dmVycyB1c2UgaXQgcHJvcGVybHkgYnkgKmFjdHVhbGx5KiBjb25kaXRpb25hbGx5IGVuYWJsaW5n
IHRoZSBmZWF0dXJlIG9ubHkgd2hlbiBJU19SRUFDSEFCTEUsIGkuZS4gZml4IGljZSBzbyB0aGF0
IGl0IHVzZXMgSVNfUkVBQ0hBQkxFIGluc3RlYWQgb2YgSVNfRU5BQkxFRCwgYW5kIHNvIHRoYXQg
aXRzIHN0dWIgaW1wbGVtZW50YXRpb24gaW4gaWNlX3B0cC5oIGFjdHVhbGx5IGp1c3Qgc2lsZW50
bHkgZG9lcyBub3RoaW5nIGJ1dCByZXR1cm5zIDAgdG8gdGVsbCB0aGUgcmVzdCBvZiB0aGUgZHJp
dmVyIHRoaW5ncyBhcmUgZmluZS4NCg0KVGhpcyB3b3VsZCBtYWtlIGl0IHdvcmsgY29ycmVjdGx5
IGZvciB1c2VycyB3aG8gd2FudCB0aW5pZmljYXRpb24sICphbmQqIGl0IHdvdWxkIG1ha2UgdGhl
cmUgYmUgbm8gc3Ryb25nIGRlcGVuZGVuY3kgYmV0d2VlbiBhbnl0aGluZywgd2hpbGUgc3RpbGwg
YWxsb3dpbmcgb3B0aW9uYWxseSBkZWZhdWx0aW5nIHRvIHllcy4NCg0KVGhhdCBiZWluZyBzYWlk
LCBJIGRvbid0IHRoaW5rIHNhdmluZyAyMmtiIGlzIHdvcnRoIHRoZSBjaGFuY2UgdG8gZ2V0IHRo
aW5ncyB3cm9uZyAoYXMgd2UndmUgc2VlbikuDQoNClRoYW5rcywNCkpha2UNCg==
