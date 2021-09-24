Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF632416E34
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbhIXIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:51:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:45803 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244334AbhIXIvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 04:51:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="224060899"
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="224060899"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 01:49:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="551504296"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2021 01:49:34 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 24 Sep 2021 01:49:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 24 Sep 2021 01:49:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 24 Sep 2021 01:49:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYrgJz69bNxBKP7u0XTZSYwiCrPM4RuusdQNLwldzZnTK+6aPGg1Sa33Vw4VUYYJrYIEUQBLgdn2Js3n4vQOGx4TiP/mjAhOqEk7upVMGk6W1RKIoKaqAx7o1aE1+Y4e6QJNyPqi0OvobuNyO/Z1Rs2pwGxaTffHsi1/0zg4re5BcKJh74u/6T6VhR7M6YufhgZO1IneS6qZZRbHKKLDZc6WdPVFYWgyXVcEajbNyygzfCO4g8mJ905XIcTPO934BNa9a9SzB18G47cc1lYXR3SXMq3vt73PYvjxP1zfGHkkPI+0QBexO/+IPIislfwmPmC07HaAnKkuEXwD6+Hvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=27rz90EpVC3bBPMqpmvre54mD6hneJmXhX8sLHDrgao=;
 b=G8Q+sjia4MQqvJ73pZ7bXkO6dzazYYewbvBgv1nbNkrk73+Jq0jRbLgUSxnZkTMLXAbpMRcWLP0ntTUV7IcGTpesIcXgKkz00+ujYoenU5eqtAqTiB8ZFD8zU8p8bQjQxbYfPedUmpGXrbb7GEz0wMTP28sDSP14o9PxqPOXILjpe7padIFMNS1pCgMjstnfVgB8KqM1iAjon48RA8Qub2gI6bQW1e3OP6xtDd7bLODJyKdZbkLlrJjgSwRw7rMIaxjR/zxdSLRNHIYOo4Z4EjHPLOrylQOFEYiCNloSq+vVDJy9jN0rL8+se6Kh990E1pU1FpWECyzFGkTBTjSBdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27rz90EpVC3bBPMqpmvre54mD6hneJmXhX8sLHDrgao=;
 b=RJfdAZFA7byn3RIqCIgHfC3QfoCz3F2RjpEQhL9hxKEzc3DHdJld/Qil+MsC72G0oOk70ChkubRJ9licmdrWb7WuZzsUfvigsKqIMLuDn9ASFhLFDD5TcCOPu4M11+0XQ4HI4g26tmrXUZncQU83guaqVsVO94xLI4OAlzqMWjY=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 08:49:33 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52%6]) with mapi id 15.20.4544.013; Fri, 24 Sep 2021
 08:49:33 +0000
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
Thread-Index: AQHXsIjSc3mRlFN9WkO3yXaqPJ8to6uyz4gkgAARlIA=
Date:   Fri, 24 Sep 2021 08:49:33 +0000
Message-ID: <b2225a355ecc840cddb2b6aeb15db79624998338.camel@intel.com>
References: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
         <87k0j6to00.fsf@codeaurora.org>
In-Reply-To: <87k0j6to00.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6076e430-0476-483b-dcbd-08d97f383ad1
x-ms-traffictypediagnostic: BYAPR11MB2854:
x-microsoft-antispam-prvs: <BYAPR11MB2854A7FFBA4475435190097790A49@BYAPR11MB2854.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kwy3PC59LkxZ1BH+SmlFckerjQ5F14dob1ElELuWYarNVPPLZnKWNfVlelPxduoe4GFir0Q3bXhlh/xm76GcajmjvAmp2hvFB6KNpwQEHyEMOCr73458J8OyNYcZBWK7QVUiFx24qvk1h7jgCE25Us2FLtZZuw1mzj/X6gg9cm08zlmbiD/NEqU7BDK3/LUCadLO19KjA6cBI9a7DxF36UOMNbTseKZcEAnsffCQ2xhHARwsUZgDkk2QTRZ3UOwSJ++wTb3oqXn3gyXUXF8TcQvEqZoTougx1YqDcM6YGrnkmBX/DWo/lenmqrid8kFin7bMu9wTCLoIcCBNyzoaDQeNNcvQI4YUNLcHVfTheh9tQTqcvCFjLv3IRW1wJa8fOXAl3CvpQ+cj/MNne1jHk2Au8RcjJX8KgkaWIlSMB8Cu3iQ4bd32Yd4eKBn5P8OEE/llOhCcbp8/fx6ZXw0Cad9wSA7WpZPC6QmFszPYv/PlCj38AUVm2OoGy6C7xN2pl3aP55+iku5Bd71StUD5n0UWtTIUpIdUzAFrnM0NHkSdXjGGaNfxKL5prtASuuOviMTaVtNZQU2j+uH7JPkza6/harGP6grGXU4ocP/KrsR4lnuDmT3i9plmCqgyd4DcLKdUzLWQU1vb90m8YGHl122lLWrsS3UA3+9iup9NrWtmOt6jbCIUqk9EF8Dx/ZK60+39AscWJHWJUILnqg0WaF/MeyThFLNBYmGCt/9WOVB2Kj4z1a2sOFF9NTf7IdX27jbCHnrm2LVx40r8fbawICb9T4v3PYnpuvrnVq7ubGI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(54906003)(26005)(186003)(4326008)(38070700005)(8936002)(6506007)(8676002)(2616005)(71200400001)(6486002)(2906002)(5660300002)(91956017)(86362001)(66556008)(66946007)(316002)(64756008)(66476007)(508600001)(966005)(4744005)(122000001)(110136005)(76116006)(66446008)(38100700002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vld1cE1BVUloSXhrMnZVWnY0SVJiWlZPajQydnE3ZDMzV1IvUWFDdktsRmRm?=
 =?utf-8?B?MUFYNFhEcXAwR1RaZGFza3ZEYTN2QVhVdHYrYndYT2wzVjMyYzA1NFUyN2Uv?=
 =?utf-8?B?VTIwSEtQZUIzUU95Mnh1MnVERzlNMDdtejl0NTVqeHRZQ0xRLzJubHBtSWx1?=
 =?utf-8?B?Z0h5dllMaE9kaGttVjFDTnBmalNaRmhwUWtOM0hpL09ZWGJLcWxVblNyYkUw?=
 =?utf-8?B?OTlQaklUN09yRGhnRzJnMVFiajNtNk41a1ExN2M1ai8vS0ZJODNITEVLT1d6?=
 =?utf-8?B?QkNGTUE1Ry9nRTRNek1SVXY2YkVYeERWZ0pXQVd5bmJyV0FNQStXOXo4N3Vj?=
 =?utf-8?B?SW5vZklxOFRiQmNmZWYwQXRwZE5BYWxHNWFnOWJVNzZMRDVvKy9vRzRSVjlG?=
 =?utf-8?B?UWRoOStMU0NFb2x4SWJydnkyK1R5T0gvazBJVTE1ekw4alNtZ0dkNkdLMnYv?=
 =?utf-8?B?aWo0SWI0L2R5ZnpQdWZFR0RpZEM5MklhQjE0ZVFkZjVGVElHQUdHZm9pVXZZ?=
 =?utf-8?B?N1lpalVBdlNYWDhMSmdCTDJnOEREcDF1VUtXdTFVb1dpUE1FZnJOYWtMeXBM?=
 =?utf-8?B?Mm13Nk5TbGxDTkdFRHgyZnRTNFVTNXhwQVVzU2RLNTRBSXg1bFRVRGZTbG8x?=
 =?utf-8?B?YnBmWGZMM1plRHpIb0d3VXBkd1ZBTUxVbnI1cjQ5dzNhczR0alRaZ1lnNGZL?=
 =?utf-8?B?V01rRGpSdkY5VVF3bVY0SXpFT1A3M0RyOVprTWY5RmEwblpKWWV5V29uOXo4?=
 =?utf-8?B?ODhhOFpNZnN4YkUyejV3NEV3VnZ3RTl6cXdlVlpUcUZpOTBpNVA2d0RQcjFW?=
 =?utf-8?B?OHNuTURZL2pFbEFJMFBxSUJJU3FRSCtCQ3NYaDg2allDTjdhSXZOWXM2NmU4?=
 =?utf-8?B?ckZmcGp2TlE5a01uQ1VNTWVhaVZtMW44cm40MGh3MHh3ekZ5L0ZkVVZ3Q01U?=
 =?utf-8?B?eTRkOXZMZGhDZnBmRE16VituZXJqbThjUjZzWGJKUDE0VndSMnIxblR1K2k2?=
 =?utf-8?B?REE2OEY0S0tka0Jkb3dmOXFCN1Y0ZGZLbVozcTFpMk1EbHpOenRhSzloOWJQ?=
 =?utf-8?B?TkZpV2FXeEdZMFZvZzVvckhWSURpOExKSGh4YzYyZzRrblRkK0lEL0paeW1j?=
 =?utf-8?B?aTZwVEpCblN0bVdHZUNmZXhmZ2syMTEwVG04Wis4cUg4aHEzZkJmRFZaOGt6?=
 =?utf-8?B?cHp1NnJiSTUrTitnWWtHZXVtZ2tmMFpFN21ud2dTVEx0WUFTblk1RERoZmY0?=
 =?utf-8?B?MERzZC9XWlBYWjJJSFg0WjNDclRyb2w5WGhmQjViaFVLV0FXK1RGMmZhZi9K?=
 =?utf-8?B?Mld1SWd4dFN2TGxEQVYxbEljOWMxUVlQTjVEcURJbCtpMzJvWmxoYktKTG4y?=
 =?utf-8?B?T3lIbkptMTFZZmhoek1oSzFYc3prS3JIQy9RaEMwMHZDVHJIZWRnTXhUZ2lk?=
 =?utf-8?B?cnJzVDNwT1JUVXlycmNlQy9Vb3BTS2hRL2s5RStRN09RSkVaWEpLTUgrQmVV?=
 =?utf-8?B?Y2JsR0tUWWYyN21qQlRmaVlKY3VqL2Y2WnRaOGM1QjVSWXpPdzBZd0E4ZVA4?=
 =?utf-8?B?Y3J6TDRvaldGK2JVaXJVZEZ2L1R4UkNQclRHR2NyeFlFcFBtQnZWYlVob082?=
 =?utf-8?B?UGF0OS9YUytaL0dTZC95SHVsbU90SHVqR2FYNnZKai9JbHExSWltRi8wQmdU?=
 =?utf-8?B?cHFmMUMvZjJOZnFnajhDZThYM3FKRFFpK1Ixa3p5RHltVktHOHlJT2lqUkhO?=
 =?utf-8?B?SnYrSVEzMlNMUUIrRFNOOFNMZ2pkTHZtTHBxSy9ucFlPWGhvNXVoNW9kSTZX?=
 =?utf-8?B?OXA2elJqTXdlYjNqTjdGZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <62514D3A3F5D3B448F5BD773F58B9A1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6076e430-0476-483b-dcbd-08d97f383ad1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 08:49:33.0274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: inJzgT/Ycy06jWbefggRwrh2LfCVwALKGLLySo1uBxSvzpDTMVdDssMUoS2MsYLqRgJ2XheFvWtAvWl7/2kRMoAwBOIn8pVrlqBUs8jdL1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2854
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA5LTI0IGF0IDEwOjQ2ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBW
bGFkaW1pciBaYXBvbHNraXkgPHZsYWRpbWlyLnphcG9sc2tpeUBsaW5hcm8ub3JnPiB3cml0ZXM6
DQo+IA0KPiA+IFRoZXJlIGlzIGEgS2lsbGVyIEFYMTY1MCAyeDIgV2ktRmkgNiBhbmQgQmx1ZXRv
b3RoIDUuMSB3aXJlbGVzcyBhZGFwdGVyDQo+ID4gZm91bmQgb24gRGVsbCBYUFMgMTUgKDk1MTAp
IGxhcHRvcCwgaXRzIGNvbmZpZ3VyYXRpb24gd2FzIHByZXNlbnQgb24NCj4gPiBMaW51eCB2NS43
LCBob3dldmVyIGFjY2lkZW50YWxseSBpdCBoYXMgYmVlbiByZW1vdmVkIGZyb20gdGhlIGxpc3Qg
b2YNCj4gPiBzdXBwb3J0ZWQgZGV2aWNlcywgbGV0J3MgYWRkIGl0IGJhY2suDQo+ID4gDQo+ID4g
VGhlIHByb2JsZW0gaXMgbWFuaWZlc3RlZCBvbiBkcml2ZXIgaW5pdGlhbGl6YXRpb246DQo+ID4g
DQo+ID4gwqDCoEludGVsKFIpIFdpcmVsZXNzIFdpRmkgZHJpdmVyIGZvciBMaW51eA0KPiA+IMKg
wqBpd2x3aWZpIDAwMDA6MDA6MTQuMzogZW5hYmxpbmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpDQo+
ID4gwqDCoGl3bHdpZmk6IE5vIGNvbmZpZyBmb3VuZCBmb3IgUENJIGRldiA0M2YwLzE2NTEsIHJl
dj0weDM1NCwgcmZpZD0weDEwYTEwMA0KPiA+IMKgwqBpd2x3aWZpOiBwcm9iZSBvZiAwMDAwOjAw
OjE0LjMgZmFpbGVkIHdpdGggZXJyb3IgLTIyDQo+ID4gDQo+ID4gQnVnOiBodHRwczovL2J1Z3pp
bGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxMzkzOQ0KPiA+IEZpeGVzOiAzZjkxMGEy
NTgzOWIgKCJpd2x3aWZpOiBwY2llOiBjb252ZXJ0IGFsbCBBWDEwMSBkZXZpY2VzIHRvIHRoZSBk
ZXZpY2UgdGFibGVzIikNCj4gPiBDYzogSnVsaWVuIFdhanNiZXJnIDxmZWxhc2hAZ21haWwuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIFphcG9sc2tpeSA8dmxhZGltaXIuemFwb2xz
a2l5QGxpbmFyby5vcmc+DQo+IA0KPiBMdWNhLCBjYW4gSSB0YWtlIHRoaXMgdG8gd2lyZWxlc3Mt
ZHJpdmVycz8gQWNrPw0KDQpJIHNlbnQgYSBzbWFsbCBjb21tZW50LCBsZXQncyB3YWl0IGZvciB2
Mj8NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
