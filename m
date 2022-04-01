Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AFD4EE987
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 10:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245087AbiDAIMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 04:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbiDAIMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 04:12:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C84DF5C;
        Fri,  1 Apr 2022 01:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648800619; x=1680336619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pcNg5AUNdgvVG/alTyK196RDDB8rr0C4JUI+z/qK754=;
  b=DFhiOLQl0YiUDn2XXH1OyDCM8UNQeTJzSRQJ5APRQpOxaxfY4368JYVk
   ad01kaOcptBHIBRw7TCglBjiCqUixgEkXQYQ9lAiX4KOhTR7/TFepveR0
   c6d0BmxsOuKLJNQKmyvB14kON4G9h6M2Qcj2SIaOBBelH2XBjp6qb2Pq1
   yGyRGJ7YMdjMu6G+2iCYWItd10gB4Wt4YoCi/66rVVGWyIPtu0DXpcqkh
   1QEdFwfX4j+97dd4j+E+txKxhaMZTm19JM/hQgQqxm0lbTGyRTBoV8vrK
   ONEHssFGWiQQSYXVJmzquj8R1QWh5WUt0YVZPydpVEqsrbGkEHVvGU1ey
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="260061848"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="260061848"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 01:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="640459559"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Apr 2022 01:10:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 01:10:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Apr 2022 01:10:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Apr 2022 01:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjxC0FfkVtkFjyrX7svfrF9IN6x8buEyv0+qS6a9ozbr3rZqAT3PH4zmDGu/fSgtjFh/q7fdS4rrMGK4nkYXDrPNcyVbcyO9DwZ9enYqwDtqUMJpXvZa82pA2TBwh0Ny5/XLxVtVx5nYySomHIRSP9/mEMq5F86xJKZG+ETB/hqnjKtgl7bomnlZqxOkdhfflH5q/pEGVunPk803q6YFtQLF6U1xEba+QR+Fv6EZC91M7uWwwyv1IIyPZ4TKfv4tqT9B+HMdDQDg5I9HQnNtnCSvJmr2lT6oO/MB0Tp/16UGeMzZ4n3aiGMJ+BN85kFENbznrBTInHouKfNTqRreVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcNg5AUNdgvVG/alTyK196RDDB8rr0C4JUI+z/qK754=;
 b=K9C6k4unwOVI265HjDDkZ08HrXLe0KqPi20aMoubQ5Z1q5AMMzsCqDQIwkBWNOSglyGNhfAjhWVPaLLW96L9HnuesuFBikqRXXvJZwyw1CjJhrvt1wykq8rT9L5IJG+AWPhWcQ4UO0nQfaofBN+iIfulD0ZLA1IcSbo5V4XgeUTJvmj8M9+BuYQnvlxMZjRq8WrtVjeup+40zq2EsgMVnkRRT19oOBfE3JqEKbQE9YuAfDJtm/VYRamsfc8Oj2TPvV05xHp+v4Yl7Fn5uW9ceyZml0IPnEHGW5I/xSG3xhzlNJqUNpzjjfKr7/bZpQP2TKwdpFwoOD0PpJmmjB1bYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SA2PR11MB5113.namprd11.prod.outlook.com (2603:10b6:806:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Fri, 1 Apr
 2022 08:10:06 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167%7]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 08:10:06 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
Thread-Topic: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
Thread-Index: AQHYI21jHY5tKErWjEeBQUrjgtiXR6yWoosAgDpqSoCAA3sq8oAACfeAgAZm+YA=
Date:   Fri, 1 Apr 2022 08:10:06 +0000
Message-ID: <e25130e4a99700c80824575a9957e847c261452a.camel@intel.com>
References: <20220216195015.GA904148@embeddedor>
         <202202161235.2FB20E6A5@keescook> <20220326003843.GA2602091@embeddedor>
         <871qym1vck.fsf@kernel.org>
         <4c520e2e-d1a5-6d2b-3ef1-b891d7946c01@embeddedor.com>
In-Reply-To: <4c520e2e-d1a5-6d2b-3ef1-b891d7946c01@embeddedor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.43.3-1+b1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f84c61a6-529a-427b-05ff-08da13b7082d
x-ms-traffictypediagnostic: SA2PR11MB5113:EE_
x-microsoft-antispam-prvs: <SA2PR11MB51136854D35F90A976C5412090E09@SA2PR11MB5113.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PS1edal+DgB3CQAHvjuhcSo7qJSVdnr0q+lJXrpIuKpINaY1PLOt1aT6vt5JdAdhcvvlTobKVUVRSOS/5nMMc0rhaAmt8kSEaUPKzrJc1G5k/7X9k1Q0uGSq+CorrC4cG/LHjCcYiUU23XWAzBk6dDbhtbx/yEtI1dorxYFK88Nl03PWozUCA9stoDs76bO8cEisdVHm0mPBmptNQPrxbFFNiwfw2uYO45kyvLgGTfi5GAKKsnJgx8F62PhIin03yTCiWDKKI9XQqigBPHiN3uo7GBEJhgMP6L52IG4AKGjJviQbW8YKyiZ5bF36UIVx8NDz3UC8oaKILs8RPkG/pMvidURBwmzt3v1pMY7cSE9dVKKErriQp8B9SPMZmiS2uSjixFY1pPLUfMKOamjkroTRQ++foG9EQK1bbEBjLBl+ujb8IdFwIyOMjcPcwUVk/kgwuCDzcYNnqRIm1qrCsUNO1OZuiR9VBYxuHWLgi4JdOn2Qv3NACe8Pjq94MHr20PWmDpiqE0fpwLITIbRTRl6X53QVJzHTjHXFwfVielszEj5AFmhNoAt8C/HksEIylO7DtIsyS+nqwUbTF4Xp8NMR5wEP8stdg5vhl0uyxmgoBvISRiely9yMtwBEQuPT7DziJryJ/LUrob6dRQgpiOQ9Z1DthXWIH/DpzKkOr8R5bx6ib8BXaMUw7mMysM+wQP1cdODAfMnbu+0uteYfn7uQMmEH9f7SGhkzOcgq/E70oyQbg1vbOVKXLEufza7j6coNOAOgvOT3IVQKSBC3CaZWCYVz0V9EV+rKUuPPeVPXhGJSIHPpJz3EYkmce3VKgrOegwBFHXzDn3CubX1e1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(186003)(26005)(53546011)(966005)(110136005)(316002)(6512007)(36756003)(71200400001)(54906003)(6506007)(86362001)(4326008)(66556008)(82960400001)(8936002)(38100700002)(66946007)(76116006)(91956017)(2616005)(38070700005)(8676002)(66476007)(122000001)(7416002)(66446008)(5660300002)(2906002)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHlFSzRDU3hIanlZaGxMb0ZyUk5SME9Ndkhra2R6RThvY2dKdEZmZ1MrZ3FN?=
 =?utf-8?B?cjlpZkdmWlFrNjgzT0ZNRFJCNmdmbko3bmhlbjdoczlSWjNKc3F1WnVYaFBM?=
 =?utf-8?B?cnpyamQwcEF0dy8vYndLZXU3OWVDc3B5RXhrZGsvQ1pLNjAwUnNXY1ZLRmNa?=
 =?utf-8?B?RW5yWCtBbVpaWi9sNVRJY0phWHh2bERPRERudUJkMERZR2pReUFta1VER1NW?=
 =?utf-8?B?YTVBYnVyYVVyUmpwTzFEbEZyVmJQcTFXbE5CQTN1K2RxNUk1RVBVbzN3UEpi?=
 =?utf-8?B?byt0Sm13TU9LelhqMWsxNTFLYkRUbzAyUFFmdnpvZTdnZDgrT2hRU3ZvMkdO?=
 =?utf-8?B?bGRqazZjN0N1c0RKc3RlREF4TFMyNXQzU1UyNVdwSnU3bG95cGR0UjBrbVk5?=
 =?utf-8?B?b2dGcnVSOEdhRDVVbU9zdEY0VnRGMHFONERhSFFoMnFtaFowRGxUdTF5RGtR?=
 =?utf-8?B?U05XajcvclVVL1FNemNBYzVXV3k2TFpudk9tei9PdVlEOUpjcXZxcUx1dzZ1?=
 =?utf-8?B?RTJBRC9YSGQrTjZnZkMvencxTDkyUHk1bEhaN2JSQ0pPRXVNdGRtb0dvRTJW?=
 =?utf-8?B?TUo2SkJNRE5pUVhDMk8xYVFObmJrMjdjOWp6eUhwVkZXNXJkSUlvZWRBSkRz?=
 =?utf-8?B?Z0VtMU1tdWZUMVg1azhPRjU4MXozb2dKbStUQ3JTZHY0SVFTYlhqaStLWG44?=
 =?utf-8?B?bm9GaE9POGJsYWdaVHVMclNvYlQ2REVZcjZNZ0lBUUhyUTc2Rk0zZDJsalp4?=
 =?utf-8?B?d3ZFbGkza0lCWGk1MExBY3lucU9CWVp1TWFyU3hzN2lVaklYSGpIWGZuTkxK?=
 =?utf-8?B?RDcwWCt1K25FVkN4d1NiVXZlK1o0K1lYb3NHVjhOa1hGNFE3L0dQUUx1K0hG?=
 =?utf-8?B?NnBLTXFQRWxYWTQ0bDFJcDg4Q2tqOHhuOG03OWRNZlFvNGthU3J5VzJ1Rk9D?=
 =?utf-8?B?M0tGT3RvQlpBcTJsOWxHZklhMlU3OHpOVGt0Q3VWSE45OFVBTDRCVmRjUU9W?=
 =?utf-8?B?Y2l1R3dkZ1h4NzV0clpCNnpzRUNCUFIyeXpITzh2VnR2dGxucmpueHJBWjRx?=
 =?utf-8?B?bWVDQkJHVnRpWXJCUDc2MXZxUHhrV2U3Vm1DeTRITUZ6T1lUMWNxOGdkOWY1?=
 =?utf-8?B?ZTBYdDFBWnFndlZkK1FqNThVTVE4YlRMbWtiTng5aTlkaTRsczltVUxLUlFF?=
 =?utf-8?B?NWNWWjg5ZmJOZW1DRVdNSW8zMHMwVnJ0T1ZtQlZaRnlKdjFZRE5VZ2dKbXJJ?=
 =?utf-8?B?L2J0TnFRQTgrMDB6aFRja0dJMzl2U21aTm15cWVJSFIxeE8rMjJJYlE5dWtF?=
 =?utf-8?B?Z2V1enQvbVpjU2taZmRwV1RTZzc4WkJyMDNjWjZGU3RpVysxdVF0Snh6THhs?=
 =?utf-8?B?UDJKTThjN1IrdWVMOFVTaGo1Q1REaG5OalpNL1hFb3FhbXVhc2Z1cjRFZUEz?=
 =?utf-8?B?MlpOdjlndHZhdTRCSmxGdXZyN2V0UWtCaENNN1ppZVN1SjlGcE9Cd1dJS0Iz?=
 =?utf-8?B?NDNzc3BrelVOUDNhUmV0Vk9OcWdVYktXTzRnZmFHSy9HSkU2ejJ3S1RSY2RC?=
 =?utf-8?B?R21IRHg1RGV1cjY4T3c4ZnB3QlFZcVgrckx5Y0cxYmxmS0NOOE9tNFRJNHhJ?=
 =?utf-8?B?OE1LUEw0N3hWaDh0M3BPRVk1a0ZQQll6T0RCTnM1WGNFcGZadXNOcm04YjVI?=
 =?utf-8?B?TG41L0lJV05RZ2dWdWpXVlk1dWVSanVvaGxSWXlWbVJCbTUzOHdyRWhUNFh3?=
 =?utf-8?B?QkRBb2xaYklTeXJIaXVOc3M2R1JTVk9Nbm5jM0FlZ0c4ZFZ1VFZ2QXZENkRP?=
 =?utf-8?B?Ly9KZCthbjE5ckJGbERYOFE5cEVrS3F1WXR0RVhmbTFDcS9zVGhpY2I1Vlpm?=
 =?utf-8?B?MXBRL3cxMGJlZURIQzUwVVNKcVZnMWROU0p1UjM0ckxzRVNWd1EyWE9seHpH?=
 =?utf-8?B?NkExQkJkNmpEUU42USt4VkYyQ0V6TXpPRTVYK2JZVjlSbExlaWEyMFpFWm54?=
 =?utf-8?B?ZGhSdjF0SmdtWjFpM2YwU0NPNy8vbDJXZU5KRkV5UG82WjhURUhMWlRFQ3Fa?=
 =?utf-8?B?U0tyakdLZkR5SG1tR0RNbytGNmtDVHpkSFhIU1pQNWVLa3B3YjlQM3hxbU1z?=
 =?utf-8?B?Z2NTWThNM2tUbjluRm5OZ2xrODFZb2k4NnhNUDd4S2R6L2hMOUx4WTUyei9r?=
 =?utf-8?B?L2ZzUHdidkV6Z0hCWjZJc01qMU1JRFkvd0lqY0FjU0gyb3R4bUVlSmNyWCtG?=
 =?utf-8?B?Z3RrNXlSZHAzd1crTmp1YzJ1MnZwZkxGU2h2dnAxSEh6dEZlTjUwd0tVd2d6?=
 =?utf-8?B?a2hlc1JTcU9wd1VxTzVQUndESmZnNmRLcHJrRTNsa1MvZitJUEVLam1UNWNY?=
 =?utf-8?Q?BG/2kwsJfQOllCmp+hhZ0EslgagnMunMHdvKJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE00414AB5920E49BFF34E4F2426B676@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84c61a6-529a-427b-05ff-08da13b7082d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 08:10:06.2832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIM1lFRSrOSYegI+e8lf2GnipqtU1zXlQQYb9EQuOvGhgrgiPgCV0BT9QLWsstIg9IHq6d4IjIA24AVHbCL/+c69yk7NUwMTO+2Wc2E0X20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5113
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTI4IGF0IDAxOjIzIC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiANCj4gT24gMy8yOC8yMiAwMDo0NywgS2FsbGUgVmFsbyB3cm90ZToNCj4gPiAiR3Vz
dGF2byBBLiBSLiBTaWx2YSIgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4gd3JpdGVzOg0KPiA+IA0K
PiA+ID4gT24gV2VkLCBGZWIgMTYsIDIwMjIgYXQgMTI6MzU6MTRQTSAtMDgwMCwgS2VlcyBDb29r
IHdyb3RlOg0KPiA+ID4gPiBPbiBXZWQsIEZlYiAxNiwgMjAyMiBhdCAwMTo1MDoxNVBNIC0wNjAw
LCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdyb3RlOg0KPiA+ID4gPiA+IFRoZXJlIGlzIGEgcmVndWxh
ciBuZWVkIGluIHRoZSBrZXJuZWwgdG8gcHJvdmlkZSBhIHdheSB0byBkZWNsYXJlDQo+ID4gPiA+
ID4gaGF2aW5nIGEgZHluYW1pY2FsbHkgc2l6ZWQgc2V0IG9mIHRyYWlsaW5nIGVsZW1lbnRzIGlu
IGEgc3RydWN0dXJlLg0KPiA+ID4gPiA+IEtlcm5lbCBjb2RlIHNob3VsZCBhbHdheXMgdXNlIOKA
nGZsZXhpYmxlIGFycmF5IG1lbWJlcnPigJ1bMV0gZm9yIHRoZXNlDQo+ID4gPiA+ID4gY2FzZXMu
IFRoZSBvbGRlciBzdHlsZSBvZiBvbmUtZWxlbWVudCBvciB6ZXJvLWxlbmd0aCBhcnJheXMgc2hv
dWxkDQo+ID4gPiA+ID4gbm8gbG9uZ2VyIGJlIHVzZWRbMl0uDQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gWzFdIGh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0ZsZXhpYmxlX2FycmF5X21lbWJl
cg0KPiA+ID4gPiA+IFsyXQ0KPiA+ID4gPiA+IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0
bWwvdjUuMTYvcHJvY2Vzcy9kZXByZWNhdGVkLmh0bWwjemVyby1sZW5ndGgtYW5kLW9uZS1lbGVt
ZW50LWFycmF5cw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNv
bS9LU1BQL2xpbnV4L2lzc3Vlcy83OA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8g
QS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCj4gPiA+ID4gDQo+ID4gPiA+IFJl
dmlld2VkLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4NCj4gPiA+IA0KPiA+
ID4gSGkgYWxsLA0KPiA+ID4gDQo+ID4gPiBGcmllbmRseSBwaW5nOiBjYW4gc29tZW9uZSB0YWtl
IHRoaXMsIHBsZWFzZT8NCj4gPiA+IA0KPiA+ID4gLi4uSSBjYW4gdGFrZSB0aGlzIGluIG15IC1u
ZXh0IHRyZWUgaW4gdGhlIG1lYW50aW1lLg0KPiA+IA0KPiA+IExpa2Ugd2UgaGF2ZSBkaXNjdXNz
ZWQgYmVmb3JlLCBwbGVhc2UgZG9uJ3QgdGFrZSBhbnkgd2lyZWxlc3MgcGF0Y2hlcyB0bw0KPiA+
IHlvdXIgdHJlZS4gVGhlIGNvbmZsaWN0cyBqdXN0IGNhdXNlIG1vcmUgd29yayBvZiB1cy4NCj4g
DQo+IFN1cmUgdGhpbmcuIEkganVzdCByZW1vdmVkIGl0IGZyb20gbXkgdHJlZS4NCj4gDQo+IEkg
ZGlkbid0IGdldCBhbnkgcmVwbHkgZnJvbSB3aXJlbGVzcyBwZW9wbGUgaW4gbW9yZSB0aGFuIGEg
bW9udGgsIGFuZA0KPiB0aGF0J3Mgd2h5IEkgdGVtcG9yYXJpbHkgdG9vayBpdCBpbiBteSB0cmVl
IHNvIGl0IGRvZXNuJ3QgZ2V0IGxvc3QuIDopDQo+IA0KPiA+IEkgYXNzaWduZWQgdGhpcyBwYXRj
aCB0byBtZSBvbiBwYXRjaHdvcmsgYW5kIEknbSBwbGFubmluZyB0byB0YWtlIGl0IHRvDQo+ID4g
d2lyZWxlc3MtbmV4dCBvbmNlIGl0IG9wZW5zLiBMdWNhLCBhY2s/DQoNClNvcnJ5IGZvciB0aGUg
ZGVsYXksIEkgd2FzIG9uIHZhY2F0aW9uLg0KDQpBcyB5b3Ugc29tZSBvZiB5b3UgYWxyZWFkeSBr
bm93LCBJJ20gc3RlcHBpbmcgYXNpZGUgZnJvbSBteSByb2xlIGFzDQppd2x3aWZpIG1haW50YWlu
ZXIgKEZXSVcgSSdtIG1vdmluZyB0byBJbnRlbCBHcmFwaGljcykuICBJIGNhbiBzdGlsbA0KYWNr
IHRoaXMgY2hhbmdlLCBidXQgd2UnbGwgc29vbiBzZW5kIGFuIHVwZGF0ZSB0byBNQUlOVEFJTkVS
UyB0bw0KcmVmbGVjdCB0aGUgY2hhbmdlLg0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2lh
bm8uY29lbGhvQGludGVsLmNvbT4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
