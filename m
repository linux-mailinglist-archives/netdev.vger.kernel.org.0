Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630C73DC0FA
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhG3WUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:20:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:56328 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232533AbhG3WT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 18:19:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10061"; a="193456428"
X-IronPort-AV: E=Sophos;i="5.84,283,1620716400"; 
   d="scan'208";a="193456428"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 15:19:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,283,1620716400"; 
   d="scan'208";a="477199134"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2021 15:19:22 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Fri, 30 Jul 2021 15:19:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Fri, 30 Jul 2021 15:19:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Fri, 30 Jul 2021 15:19:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Fri, 30 Jul 2021 15:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxOnmoU5CdXVIAlJdI7ACVw+JLrhOxEgUT0dirr26sB49QKqOcz3XT1UrLdUiMoAizIXue2i1lqcb/ujD6PpQW3RazC60iLM1W+MnLCtm0A/iqC011WsuaAvu3237+bgJ/GvMDICua+pCv678k1h/4KpHLeJd0OqDBc0bVzdM9dBYMNID+mZwHkgi4X0GEHmRZvNk8oBx5AzXLjt76ejxIeAX+pQCdpNM+qpplhdyxIrcdON/lEiMST9ww6koXd44JnR6O6CSMM9qNLw2nTrErE8KUl6yP2L1o3TsScZCfmLCXbAme0z8goOW8q3ibm8MLBsUn4KYYV2X/hTNtODnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhDqZqkfDP7BPsp6M0Jc7OK2PsfPBqMlZrUCai4MFmU=;
 b=jxFoiIUXBMaa7qDlfncDcfZpDX1FwddZy2lIUuFaxMS2Wb2VoRCTeuU9aLp8+/jHnzCQ2cKSniy1eaKk/KEhHGnxrHp29iZPTyWtP07Kc+keit5I6fzBdLvwZ+RWe7RYUvIILllu2UpmrowqgXKwUZGdlIKdPBTeIHfFA9r9Y4yXCwf0rdIzZRJ6tbuLMdEaxsprmp7RGKCmGrXTJ0rMBWwfl+fDCKtnVHPU5z9UU3kguJSE0sr40aCBfsdaP+7yFSW6BiDNiB+h4V/AxBHaR9UXKUZq+/DUm6ChyynOlWJhTNdjRuoHRxSHOqX5/hZHZtuj+Prmfawohs/3YJpKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhDqZqkfDP7BPsp6M0Jc7OK2PsfPBqMlZrUCai4MFmU=;
 b=Pc+CJFquvjcxEDCzzDBKSPeGQ2qSr6J5061wjWYfWnGtd4wjMddzJPmbQgtGMTW4tCN1XwjpQ2xjc6Gg4cb4Jt9GWLxfFltV+o2PLlTVvzayAAu6hoVwk0J/7n3IcMTNeufLy/5va/aTK/zrO5rztJNDTtxCUJvBJq4LimRSa4g=
Received: from SJ0PR11MB5150.namprd11.prod.outlook.com (2603:10b6:a03:2d4::18)
 by BYAPR11MB3461.namprd11.prod.outlook.com (2603:10b6:a03:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Fri, 30 Jul
 2021 22:19:20 +0000
Received: from SJ0PR11MB5150.namprd11.prod.outlook.com
 ([fe80::15f9:1166:732a:313d]) by SJ0PR11MB5150.namprd11.prod.outlook.com
 ([fe80::15f9:1166:732a:313d%3]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 22:19:20 +0000
From:   "Williams, Dan J" <dan.j.williams@intel.com>
To:     "keescook@chromium.org" <keescook@chromium.org>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>
CC:     "keithpac@amazon.com" <keithpac@amazon.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 04/64] stddef: Introduce struct_group() helper macro
Thread-Topic: [PATCH 04/64] stddef: Introduce struct_group() helper macro
Thread-Index: AQHXhZDxZGHjIxWvvE6M0gb3lz9V/w==
Date:   Fri, 30 Jul 2021 22:19:20 +0000
Message-ID: <1d9a2e6df2a9a35b2cdd50a9a68cac5991e7e5f0.camel@intel.com>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-5-keescook@chromium.org>
         <41183a98-bdb9-4ad6-7eab-5a7292a6df84@rasmusvillemoes.dk>
         <202107281456.1A3A5C18@keescook>
In-Reply-To: <202107281456.1A3A5C18@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5acc0d7-b0b9-49e8-6312-08d953a813eb
x-ms-traffictypediagnostic: BYAPR11MB3461:
x-microsoft-antispam-prvs: <BYAPR11MB3461F42C55625C1E139BD8E7C6EC9@BYAPR11MB3461.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ocrIM4lNPAW+QMkfm0PtlwqWr0EynkIOL9w333QhL494qGGVq0ZvNtaMaFnZ1jCafKYky5dUiIrskt4SAfFbJiaIPMl/bCoDgW0vwHCBNajHSPU0WwvNgxW29Psd+XtSPKjoLFYWNIwl6XRVCqQ5DU8uR6GrvTXSgOQk4qM0jipqOAQcSGRqS/s6fapMq2+kW22oiUlVA0uJzF2D5OQEeF7qiabvybWM89t2BW1plWXkjYR6xP72JDMZLQgjwxxK9Gi7ZK/u9Q9gdMacm9eU71dj6vS3CMMgOHwLwG1QOV/T0fqwslZl5RXoqchyi5uXIkDJZEXIRUhZLikyK/98hjMMWCVcnXV85urVwKFeQytqQQxPrjVqjMzjHQc7rTz7i+tY6+OfLeaRwC22jLGFsaziIsEX2PqfN5uQ3ZwEZ1fJsAhhBmxQ/ROdp7uVvnh0tiwuwmreMuDoFRRX9mzTYJSjoA+hvHhXR8id4sw346nt+9lB9Qfr/XTkykjBtO4LFD2TpCcauXmZ4Q2IpomKRg8lmulxAsmBPI4JBrYCjtbiaZpESvoXCo2SA1TlXjcTTS3wKw1O0FqpSpTZddH2zbNCN/sBdnDkrFMh+gSXhgpg94CEoS3SIoRTQrFMGxmX9Y8NLK6cABo3sOhpJYp7T3h8KDDlkdEUqn9W1+KO6rGArnvnyWh4hl92UFKwhpAhDqZ5dfxTVG5MGDkFS30Ycw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5150.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(6506007)(71200400001)(64756008)(66476007)(66556008)(66946007)(6486002)(4326008)(110136005)(66446008)(83380400001)(6512007)(8676002)(54906003)(86362001)(478600001)(8936002)(2906002)(26005)(186003)(38100700002)(316002)(122000001)(36756003)(5660300002)(7416002)(2616005)(76116006)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTNPT01ZeEFDd0tqbTVzbDFHTVRjcWNjOVZ0ZDBuSmpKR0lZbEJaZjRTeXQr?=
 =?utf-8?B?ZTdHTFhZQmpJZjdianFLaHNJM2wrVk40MnJ2Rmk5c0tFbkNGVFhDbnBvU0x6?=
 =?utf-8?B?OXRRMGs0aThzL3FxSTZPOTQ1THZoZlc5OUY3ZEVUZnR2eVpUNDlXU0IxMUI2?=
 =?utf-8?B?ZXh1dldiOXJja3BkYjQ1VzZmVklCWjJOV2JFZFY2Tnp3ZmZ5UmU4bS9TeUE5?=
 =?utf-8?B?N3JwOHlYWTJ0VHR4eEIwbk9SZlFaM1NIQU4wWHNNelFNOWVwM3JBVGI0OSt4?=
 =?utf-8?B?WHNubXZwNDdLTEFhYTgweG5FSXlxTkl1cmNXQkNwQ1JoK0FabElENXFmUmxW?=
 =?utf-8?B?cTk2ZmdYNzVOU0lNcjZ1S0hPMUNjOUpuRUhPY0xoVmxSM1F4T3BubmJveW9o?=
 =?utf-8?B?aWp6YWJKUEJHbDJhTzVuS2dBdXV6VFRHai9GSGY3UXVkSEVNRnMvdDNqMzdS?=
 =?utf-8?B?aFovWWllNFBKSCttenZPSkZBZEJ6YzBhNEl3bjh5dTJRTmdJK0xJL2lUcDZO?=
 =?utf-8?B?S1YzbU5JNmx2dStzYi9IcG53VFZWdDQ0QUwrS1YxODR5Ukh1b1pIS0ZpaW5H?=
 =?utf-8?B?aU9mY3A2d0VTVWNwSW9GK2RNWVRObnV5SFA1L09YdGpQNXZqc2FweGdYOERH?=
 =?utf-8?B?eGFCNHVhdzhnVXdEb2hSRkVDZWhneENTZFQ2eEh2VUJGcW5Pamt3SjJybEdm?=
 =?utf-8?B?dysvakFyTTlCRFlHMDZmTEJaRTV6anlHT2xzOVFMSU52UEVyWjl6WDBkbFVr?=
 =?utf-8?B?eHF5d1FnWVgyMk5PSWRaUmpPcDZyOTRoZVl5WWFsSjBpMTBpOUU0dUlyamtE?=
 =?utf-8?B?bXpWNmNqTFJjQXhBcVk3MjFjdllwVnRlblVsWXJ5Z2hhVXhNbDU0S0Z4VnY4?=
 =?utf-8?B?ZXFwbzBTaXhvU0xDVFV6T3owTVl5V3JjUFR2N2w4cEdMZEx4R1FPdDdYUlVC?=
 =?utf-8?B?SmJUbGRNR0k5YytTVWZxd3hWek5RaW1sQXFZQlQvcWxlcExsZzhHaEN4WHE0?=
 =?utf-8?B?UzE3NWFpNTVwMFlUcDVrOGluS1RNT2RHR3hpSm5pWW94QXlXNGY3Rm54QjFY?=
 =?utf-8?B?dkxMOUc0NU0xMDB6OFR4TStwR0lDZHlZcklmWUFtVWVKdG9VNU5ycm1kOEs0?=
 =?utf-8?B?ditQbkVORFZqWnA5VThvemNQKzhBak03cTd4S1luZjhtcVJhZCszcm9OTXhV?=
 =?utf-8?B?MzdpdXR1andWNHJYU0JFemlOSTZNSk1BQlUzazFndkZRbnBCVEw0aVk1Q2Zr?=
 =?utf-8?B?ejRLN3BvdXVsT1R4b2dubnpqY3JFa2dMU1hVb0NVRjZlTVpIT2VhMHhQMU1r?=
 =?utf-8?B?YlQ3SCtQMlVRSUpraGVRTDEzV3dON2RvRWp5RXpVeTNJek1HRWtjVXYyUEx5?=
 =?utf-8?B?d0R4ckdkY0hSbjZmNzRrbmpKSUNkM0VTOElvMXI5NkJNN3dEc0tJQWZDTFRG?=
 =?utf-8?B?dk5kMmE2alFKNE5ZNW9makd6ZEhXaDRZZTVhaEk4TUY2ZXNJdUpheks1dTcv?=
 =?utf-8?B?UkU5SGowUTZ4YmJFQWdHcFNGVjltOS92ZE1UWXhOTmRmOEh3SjhxcWVWRjNu?=
 =?utf-8?B?R1o4UlpTNVROUlQ2ZEpCYVNLWmttVlhudno2NVlmMEFHM1JlU0NVd3FEbElW?=
 =?utf-8?B?YTc1SXdlbHRXaDVaa2hDM2tXc2wyUk5Od2JIYy92THY1VTg2QUhiWEVlaDFM?=
 =?utf-8?B?ZVhTclBSTEZCRGRsWmZJQTAvQ25NdmRFMXJZQTlWaGNiQlNTNWYvWG94RjZj?=
 =?utf-8?Q?j+vCawjgVERvPWF3kE8ziwuEifElhH7HmKxMxa4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2693B1DEE6BBA448203184C824748F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5150.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5acc0d7-b0b9-49e8-6312-08d953a813eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 22:19:20.2096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c4FbVQxHNfBAT1mt+U1jXpsr6dnYUaTjfnTnF8mHMk63Q9MJqRdvJgjsOVSftseNiAN4/UwRSgEq+LWrh1IYupr6fapNEsF0A1mub5pcHhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3461
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA3LTI4IGF0IDE0OjU5IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IFdlZCwgSnVsIDI4LCAyMDIxIGF0IDEyOjU0OjE4UE0gKzAyMDAsIFJhc211cyBWaWxsZW1vZXMg
d3JvdGU6DQo+ID4gT24gMjcvMDcvMjAyMSAyMi41NywgS2VlcyBDb29rIHdyb3RlOg0KPiA+IA0K
PiA+ID4gSW4gb3JkZXIgdG8gaGF2ZSBhIHJlZ3VsYXIgcHJvZ3JhbW1hdGljIHdheSB0byBkZXNj
cmliZSBhIHN0cnVjdA0KPiA+ID4gcmVnaW9uIHRoYXQgY2FuIGJlIHVzZWQgZm9yIHJlZmVyZW5j
ZXMgYW5kIHNpemluZywgY2FuIGJlIGV4YW1pbmVkIGZvcg0KPiA+ID4gYm91bmRzIGNoZWNraW5n
LCBhdm9pZHMgZm9yY2luZyB0aGUgdXNlIG9mIGludGVybWVkaWF0ZSBpZGVudGlmaWVycywNCj4g
PiA+IGFuZCBhdm9pZHMgcG9sbHV0aW5nIHRoZSBnbG9iYWwgbmFtZXNwYWNlLCBpbnRyb2R1Y2Ug
dGhlIHN0cnVjdF9ncm91cCgpDQo+ID4gPiBtYWNyby4gVGhpcyBtYWNybyB3cmFwcyB0aGUgbWVt
YmVyIGRlY2xhcmF0aW9ucyB0byBjcmVhdGUgYW4gYW5vbnltb3VzDQo+ID4gPiB1bmlvbiBvZiBh
biBhbm9ueW1vdXMgc3RydWN0IChubyBpbnRlcm1lZGlhdGUgbmFtZSkgYW5kIGEgbmFtZWQgc3Ry
dWN0DQo+ID4gPiAoZm9yIHJlZmVyZW5jZXMgYW5kIHNpemluZyk6DQo+ID4gPiANCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZm9vIHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaW50IG9uZTsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
c3RydWN0X2dyb3VwKHRoaW5nLA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaW50IHR3bywNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGludCB0aHJlZSwNCj4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKTsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaW50IGZvdXI7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgfTsNCj4gPiANCj4gPiBUaGF0IGV4
YW1wbGUgd29uJ3QgY29tcGlsZSwgdGhlIGNvbW1hcyBhZnRlciB0d28gYW5kIHRocmVlIHNob3Vs
ZCBiZQ0KPiA+IHNlbWljb2xvbnMuDQo+IA0KPiBPb3BzLCB5ZXMsIHRoYW5rcy4gVGhpcyBpcyB3
aHkgSSBzaG91bGRuJ3Qgd3JpdGUgY29kZSB0aGF0IGRvZXNuJ3QgZmlyc3QNCj4gZ28gdGhyb3Vn
aCBhIGNvbXBpbGVyLiA7KQ0KPiANCj4gPiBBbmQgeW91ciBpbXBsZW1lbnRhdGlvbiByZWxpZXMg
b24gTUVNQkVSUyBub3QgY29udGFpbmluZyBhbnkgY29tbWENCj4gPiB0b2tlbnMsIGJ1dCBhcw0K
PiA+IA0KPiA+IMKgIGludCBhLCBiLCBjLCBkOw0KPiA+IA0KPiA+IGlzIGEgdmFsaWQgd2F5IHRv
IGRlY2xhcmUgbXVsdGlwbGUgbWVtYmVycywgY29uc2lkZXIgbWFraW5nIE1FTUJFUlMNCj4gPiB2
YXJpYWRpYw0KPiA+IA0KPiA+ICNkZWZpbmUgc3RydWN0X2dyb3VwKE5BTUUsIE1FTUJFUlMuLi4p
DQo+ID4gDQo+ID4gdG8gaGF2ZSBpdCBzbHVycCB1cCBldmVyeSBzdWJzZXF1ZW50IGFyZ3VtZW50
IGFuZCBtYWtlIHRoYXQgd29yay4NCj4gDQo+IEFoISBQZXJmZWN0LCB0aGFuayB5b3UuIEkgdG90
YWxseSBmb3Jnb3QgSSBjb3VsZCBkbyBpdCB0aGF0IHdheS4NCg0KVGhpcyBpcyBncmVhdCBLZWVz
LiBJdCBqdXN0IHNvIGhhcHBlbnMgaXQgd291bGQgY2xlYW4tdXAgd2hhdCB3ZSBhcmUNCmFscmVh
ZHkgZG9pbmcgaW4gZHJpdmVycy9jeGwvY3hsLmggZm9yIGFub255bW91cyArIG5hbWVkIHJlZ2lz
dGVyIGJsb2NrDQpwb2ludGVycy4gSG93ZXZlciBpbiB0aGUgY3hsIGNhc2UgaXQgYWxzbyBuZWVk
cyB0aGUgbmFtZWQgc3RydWN0dXJlIHRvDQpiZSB0eXBlZC4gQW55IGFwcGV0aXRlIGZvciBhIHR5
cGVkIHZlcnNpb24gb2YgdGhpcz8NCg0KSGVyZSBpcyBhIHJvdWdoIGlkZWEgb2YgdGhlIGNsZWFu
dXAgaXQgd291bGQgaW5kdWNlIGluIGRyaXZlcnMvY3hsLzoNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY3hsL2N4bC5oIGIvZHJpdmVycy9jeGwvY3hsLmgNCmluZGV4IDUzOTI3ZjlmYTc3ZS4uYTIz
MDhjOTk1NjU0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jeGwvY3hsLmgNCisrKyBiL2RyaXZlcnMv
Y3hsL2N4bC5oDQpAQCAtNzUsNTIgKzc1LDE5IEBAIHN0YXRpYyBpbmxpbmUgaW50IGN4bF9oZG1f
ZGVjb2Rlcl9jb3VudCh1MzIgY2FwX2hkcikNCiAjZGVmaW5lIENYTERFVl9NQk9YX0JHX0NNRF9T
VEFUVVNfT0ZGU0VUIDB4MTgNCiAjZGVmaW5lIENYTERFVl9NQk9YX1BBWUxPQURfT0ZGU0VUIDB4
MjANCiANCi0jZGVmaW5lIENYTF9DT01QT05FTlRfUkVHUygpIFwNCi0gICAgICAgdm9pZCBfX2lv
bWVtICpoZG1fZGVjb2Rlcg0KLQ0KLSNkZWZpbmUgQ1hMX0RFVklDRV9SRUdTKCkgXA0KLSAgICAg
ICB2b2lkIF9faW9tZW0gKnN0YXR1czsgXA0KLSAgICAgICB2b2lkIF9faW9tZW0gKm1ib3g7IFwN
Ci0gICAgICAgdm9pZCBfX2lvbWVtICptZW1kZXYNCi0NCi0vKiBTZWUgbm90ZSBmb3IgJ3N0cnVj
dCBjeGxfcmVncycgZm9yIHRoZSByYXRpb25hbGUgb2YgdGhpcyBvcmdhbml6YXRpb24gKi8NCiAv
Kg0KLSAqIENYTF9DT01QT05FTlRfUkVHUyAtIENvbW1vbiBzZXQgb2YgQ1hMIENvbXBvbmVudCBy
ZWdpc3RlciBibG9jayBiYXNlIHBvaW50ZXJzDQogICogQGhkbV9kZWNvZGVyOiBDWEwgMi4wIDgu
Mi41LjEyIENYTCBIRE0gRGVjb2RlciBDYXBhYmlsaXR5IFN0cnVjdHVyZQ0KLSAqLw0KLXN0cnVj
dCBjeGxfY29tcG9uZW50X3JlZ3Mgew0KLSAgICAgICBDWExfQ09NUE9ORU5UX1JFR1MoKTsNCi19
Ow0KLQ0KLS8qIFNlZSBub3RlIGZvciAnc3RydWN0IGN4bF9yZWdzJyBmb3IgdGhlIHJhdGlvbmFs
ZSBvZiB0aGlzIG9yZ2FuaXphdGlvbiAqLw0KLS8qDQotICogQ1hMX0RFVklDRV9SRUdTIC0gQ29t
bW9uIHNldCBvZiBDWEwgRGV2aWNlIHJlZ2lzdGVyIGJsb2NrIGJhc2UgcG9pbnRlcnMNCiAgKiBA
c3RhdHVzOiBDWEwgMi4wIDguMi44LjMgRGV2aWNlIFN0YXR1cyBSZWdpc3RlcnMNCiAgKiBAbWJv
eDogQ1hMIDIuMCA4LjIuOC40IE1haWxib3ggUmVnaXN0ZXJzDQogICogQG1lbWRldjogQ1hMIDIu
MCA4LjIuOC41IE1lbW9yeSBEZXZpY2UgUmVnaXN0ZXJzDQogICovDQotc3RydWN0IGN4bF9kZXZp
Y2VfcmVncyB7DQotICAgICAgIENYTF9ERVZJQ0VfUkVHUygpOw0KLX07DQotDQotLyoNCi0gKiBO
b3RlLCB0aGUgYW5vbnltb3VzIHVuaW9uIG9yZ2FuaXphdGlvbiBhbGxvd3MgZm9yIHBlcg0KLSAq
IHJlZ2lzdGVyLWJsb2NrLXR5cGUgaGVscGVyIHJvdXRpbmVzLCB3aXRob3V0IHJlcXVpcmluZyBi
bG9jay10eXBlDQotICogYWdub3N0aWMgY29kZSB0byBpbmNsdWRlIHRoZSBwcmVmaXguDQotICov
DQogc3RydWN0IGN4bF9yZWdzIHsNCi0gICAgICAgdW5pb24gew0KLSAgICAgICAgICAgICAgIHN0
cnVjdCB7DQotICAgICAgICAgICAgICAgICAgICAgICBDWExfQ09NUE9ORU5UX1JFR1MoKTsNCi0g
ICAgICAgICAgICAgICB9Ow0KLSAgICAgICAgICAgICAgIHN0cnVjdCBjeGxfY29tcG9uZW50X3Jl
Z3MgY29tcG9uZW50Ow0KLSAgICAgICB9Ow0KLSAgICAgICB1bmlvbiB7DQotICAgICAgICAgICAg
ICAgc3RydWN0IHsNCi0gICAgICAgICAgICAgICAgICAgICAgIENYTF9ERVZJQ0VfUkVHUygpOw0K
LSAgICAgICAgICAgICAgIH07DQotICAgICAgICAgICAgICAgc3RydWN0IGN4bF9kZXZpY2VfcmVn
cyBkZXZpY2VfcmVnczsNCi0gICAgICAgfTsNCisgICAgICAgc3RydWN0X2dyb3VwX3R5cGVkKGN4
bF9jb21wb25lbnRfcmVncywgY29tcG9uZW50LA0KKyAgICAgICAgICAgICAgIHZvaWQgX19pb21l
bSAqaGRtX2RlY29kZXI7DQorICAgICAgICk7DQorICAgICAgIHN0cnVjdF9ncm91cF90eXBlZChj
eGxfZGV2aWNlX3JlZ3MsIGRldmljZV9yZWdzLA0KKyAgICAgICAgICAgICAgIHZvaWQgX19pb21l
bSAqc3RhdHVzLCAqbWJveCwgKm1lbWRldjsNCisgICAgICAgKTsNCiB9Ow0KIA0KIHN0cnVjdCBj
eGxfcmVnX21hcCB7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zdGRkZWYuaCBiL2luY2x1
ZGUvbGludXgvc3RkZGVmLmgNCmluZGV4IGNmN2Y4NjY5NDRmOS4uODRiN2RlMjRmZmI1IDEwMDY0
NA0KLS0tIGEvaW5jbHVkZS9saW51eC9zdGRkZWYuaA0KKysrIGIvaW5jbHVkZS9saW51eC9zdGRk
ZWYuaA0KQEAgLTQ5LDEyICs0OSwxOCBAQCBlbnVtIHsNCiAgKiBAQVRUUlM6IEFueSBzdHJ1Y3Qg
YXR0cmlidXRlcyAobm9ybWFsbHkgZW1wdHkpDQogICogQE1FTUJFUlM6IFRoZSBtZW1iZXIgZGVj
bGFyYXRpb25zIGZvciB0aGUgbWlycm9yZWQgc3RydWN0cw0KICAqLw0KLSNkZWZpbmUgc3RydWN0
X2dyb3VwX2F0dHIoTkFNRSwgQVRUUlMsIE1FTUJFUlMpIFwNCisjZGVmaW5lIHN0cnVjdF9ncm91
cF9hdHRyKE5BTUUsIEFUVFJTLCBNRU1CRVJTLi4uKSBcDQogICAgICAgIHVuaW9uIHsgXA0KICAg
ICAgICAgICAgICAgIHN0cnVjdCB7IE1FTUJFUlMgfSBBVFRSUzsgXA0KICAgICAgICAgICAgICAg
IHN0cnVjdCB7IE1FTUJFUlMgfSBBVFRSUyBOQU1FOyBcDQogICAgICAgIH0NCiANCisjZGVmaW5l
IHN0cnVjdF9ncm91cF9hdHRyX3R5cGVkKFRZUEUsIE5BTUUsIEFUVFJTLCBNRU1CRVJTLi4uKSBc
DQorICAgICAgIHVuaW9uIHsgXA0KKyAgICAgICAgICAgICAgIHN0cnVjdCB7IE1FTUJFUlMgfSBB
VFRSUzsgXA0KKyAgICAgICAgICAgICAgIHN0cnVjdCBUWVBFIHsgTUVNQkVSUyB9IEFUVFJTIE5B
TUU7IFwNCisgICAgICAgfQ0KKw0KIC8qKg0KICAqIHN0cnVjdF9ncm91cChOQU1FLCBNRU1CRVJT
KQ0KICAqDQpAQCAtNjcsNyArNzMsMTAgQEAgZW51bSB7DQogICogQE5BTUU6IFRoZSBuYW1lIG9m
IHRoZSBtaXJyb3JlZCBzdWItc3RydWN0DQogICogQE1FTUJFUlM6IFRoZSBtZW1iZXIgZGVjbGFy
YXRpb25zIGZvciB0aGUgbWlycm9yZWQgc3RydWN0cw0KICAqLw0KLSNkZWZpbmUgc3RydWN0X2dy
b3VwKE5BTUUsIE1FTUJFUlMpICAgIFwNCisjZGVmaW5lIHN0cnVjdF9ncm91cChOQU1FLCBNRU1C
RVJTLi4uKSBcDQogICAgICAgIHN0cnVjdF9ncm91cF9hdHRyKE5BTUUsIC8qIG5vIGF0dHJzICov
LCBNRU1CRVJTKQ0KIA0KKyNkZWZpbmUgc3RydWN0X2dyb3VwX3R5cGVkKFRZUEUsIE5BTUUsIE1F
TUJFUlMuLi4pIFwNCisgICAgICAgc3RydWN0X2dyb3VwX2F0dHJfdHlwZWQoVFlQRSwgTkFNRSwg
Lyogbm8gYXR0cnMgKi8sIE1FTUJFUlMpDQorDQogI2VuZGlmDQoNCg==
