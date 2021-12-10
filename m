Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D7470C3C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 22:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbhLJVJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 16:09:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:49471 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235022AbhLJVJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 16:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639170355; x=1670706355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YnhdP0RIhYCJKbiW+ietl5A/bpKNqKsS6WUqbAvZGdE=;
  b=MPeeNhy2ENQiJTv13Gf/3okn4ZVECyA66SqoLJJIygM9kG6lfdMxvGjH
   78VkOVrUBtLvjVRrOyvY7HqRwIfyzPNe+80MafuWJH841p7uElt31k5lH
   fAnrx7DWEWWn2DYGqU6Jzm9hT6GK9yQuQ8JfVNQoJBFAZ/og3+JUUzN+9
   tDdUJvC6QXeHS3pSWszzF8fKf5XWSb2+YsDQHDE52lkynoeiN3geGTwdM
   P2RXKgsFZ+TMNL3z6o/NcuGPRXuTMA3DrFkL2QXQ4RPziWvXGRRNZzCSi
   yb8vUMR9aQVNYbN5pmBXlyu+u79Zz3h7kI536aizvGN24CDwBkxprVXmD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237177878"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="237177878"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 13:05:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="516931635"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 10 Dec 2021 13:05:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 13:05:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 13:05:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 13:05:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mc1lLSREtHrNO4ZtI62zHm/4wflUZug58BlTvONNsbPrHBfJ7eUlZ0BP3kQdezjshe+SNKDbiSPKqgM4KsAvmFWDbcysE82OU0Ow7r31XQlsIX+Nu7xhri/OBhAqpcfx0VIHeaS7k+D69YtA+smS6LzU5SeTIF+HDiw2mBLExPZjI+0Oj69swY/funYnUGTKYarIDWsUObk0tMkq2YAsyCt7Q0M0HyIj8rKzMYP38SFdPOCmEzAkCTRl9I+14y9wJ55We8YIDUWDbCOPFrCJd+8UQatXetxfOn+gcQXD5LEK8sy/SoEvcZgW8xqW6d7+3T57ybZvWUhceo8+p1LLLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnhdP0RIhYCJKbiW+ietl5A/bpKNqKsS6WUqbAvZGdE=;
 b=R57bsepl1spbZtG0XQhXjZ0CNHqbESAhhyl3sYIPsuNA4RNNMLF2vrnWgpCoEfcjgAOZtcZU/T36oArDQpf4qipjGmxmhRz3NxjORq+vhCi9qCNbJzlRCzHIDcKb81UFKwlYhGJUufJ2Pm+uVt8cuGiIVrs0Qp8iJgINcydox3VUQ0AP+vJnMoIylKjZdmscFOR0Z7oO/aYXoBZxcs9C3LepYN5Z/yJsRWEmAw9ERHlhA/g3Ds7jY0+mR5La5Kyoj2upLUp8AEx+tT/Lv/BjB9TqwrZdd+fEY1ggRCLDi12FsTkNat6T62h1wuWRmF8cxUoGeRBFLqjZrKjGITnSXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnhdP0RIhYCJKbiW+ietl5A/bpKNqKsS6WUqbAvZGdE=;
 b=TDIphU6xTU+/Ng0JImW03QINNrKT7KI3iUxVQWcMWXm7CJaendD8E38nNhs/cJPXmQzy1JiWXqi1qsJcx1pXUqcZTo5aUQ2YCsBMvvLH3vzW50g3maIKwmUPEbPP0VLqr9tOFBdXAeaSwJ0pQS78G1SfBfKlmUSG71iipmAd/0o=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3517.namprd11.prod.outlook.com (2603:10b6:805:dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 21:05:29 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 21:05:29 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Mathew, Elza" <elza.mathew@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH intel-net 2/5] ice: xsk: allocate separate memory for XDP
 SW ring
Thread-Topic: [PATCH intel-net 2/5] ice: xsk: allocate separate memory for XDP
 SW ring
Thread-Index: AQHX7daj0ZF7xQHwV0WzzfKt7J+GEawsN1+A
Date:   Fri, 10 Dec 2021 21:05:29 +0000
Message-ID: <b7ccf744f0fc8959991e5f4071953b260ae55f7a.camel@intel.com>
References: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
         <20211210145941.5865-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20211210145941.5865-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 376f91f7-1a63-4f00-1833-08d9bc20cbed
x-ms-traffictypediagnostic: SN6PR11MB3517:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB3517350734F8B9C1832D274FC6719@SN6PR11MB3517.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kuFrFgGXTiHCsl9ao6DKMS03czF91gHRtib4jeO0OzETE6evh7WDGG8w3bOEBcUJfKTvqgJUtCjylDmoTOSjXTV0vl8inAKsR6FJQtOc8PYcn2lN9Gmqdz4XdY6ysip2XRbbBEZt8JyfAazejkLI+ANeI9w9U7RNX/aCNOrG1Fy6jHhKO8rWiu0iEk00r1X0w8zey105nIWKOu2uFwrnKk5FqwlfR92JHasWQiQPP0WtLxTxcFNVITDjSObvPsqhKuWH6AY8OePjGFERPBYRz0E3CrbmXvjh3pfakhMqb5b9Ms9xMSStSrfMXGtE4YHdJnIknrx5eC68E6K7Eau18YTa0uKdf1diEyHUNHTfPgN3nheT+dPbgaEUfOYkPfmhnr8GKfr4qJ0fmJGwOiJKvH5w/v2f3ipk9+KfzuNkKehkWCbhIRLCp/nx33D5VOwK7fFXU2Lm4OveS0Kjeyc/U3PYsyCdNbeImFKXszaxoV3RGJfMLPXSa/rvA8t9UxOYYR9qm7+N5VNqYSl5VMSta6x5VlLakz1YXlacoPJ//HiWP8YZop2geZy1R7BR5AKVbrABB3hWxrIu0x6Q09pXdu8t2wXCnhXFj+b6TBfRYBxII5H9floi3Kzt+gD8tgYq/wRogoly5/7ZqkSVXtPYMfd2plFbXM+4tVUorRI4Pw1bNJmm3sEBxCFKK6xbMggvWc25Pd5w20EvnYsbQGP4iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(38070700005)(36756003)(54906003)(4326008)(66446008)(110136005)(76116006)(5660300002)(64756008)(66476007)(8676002)(316002)(122000001)(186003)(86362001)(2906002)(26005)(71200400001)(8936002)(508600001)(4001150100001)(2616005)(6506007)(82960400001)(66946007)(6486002)(38100700002)(91956017)(83380400001)(66556008)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2dMQWN3T1RBU3NzZTlXWHNaMTBVdytRQ3hyZkZDY3JsdmpLVUNhc0VDUWVo?=
 =?utf-8?B?QzhoeEFvWUVRZWE3R3I2cS9IbjI5T3Y5bWNscUdJWWczeWQ5K3M2V1NvZGZq?=
 =?utf-8?B?TldnNjhDMkZnWjNFS2MyMVorSnFBMTJLdEMzODZyU1VSVHpPTG5LdVBPN0xB?=
 =?utf-8?B?aFJTTzk1bGFOVVBDWlQrNWp3Q2dabE5CalVMVUo4aFpDbFBUUktPOGk0Z0hT?=
 =?utf-8?B?K01sTXVhMTE4NklGaXJmdVcwNDY1b2F3ejVvT1JMSDlHQ01ZY3VId2U1b3Rv?=
 =?utf-8?B?YnVQNzZxNGpXNUJsampnaXRtTncxRmpRSHc4cGpsdVpSYVBTSTdmQTdOSFUz?=
 =?utf-8?B?YjZNc2xITmFKVVZhcDNNQnhZbFlBdjVSUHNpZVJJYXp4WGxwYldPWllFdEF0?=
 =?utf-8?B?SE05VFNpdXg1aTc5V2k2UDlrNXA4OWc3eDVtRmpSY3AyY3dTT0t4ZC9EUFNv?=
 =?utf-8?B?OWlNd2ZHK05tQlArcmVleFczOFp6aEFWRlVLclpudHZZS2FnOG9qSS9QcUt4?=
 =?utf-8?B?NzhVZEJON0h1cWdSQ0V5MllHZTlNZ3czcnk1RjFTSWYxUUk3OEFUa0V2TDlW?=
 =?utf-8?B?NnV4ME9jSkdJQ21mU0NweFlTWkx6bVpBb213NVlzL0RmejZTc1NtQU5hV2t6?=
 =?utf-8?B?U2pwUHlpSWwwdytsOGswMytsN2tWRTFWT1pYVzA4bGZyNy8zN0FGUlFqdjlh?=
 =?utf-8?B?dUwvWG9SZzg5T21KVjRQQjBNTml6bzJyUy9nWThvTGlPdU1FZVhVdzlSZDM2?=
 =?utf-8?B?c3YxTk1BemhxeklidWhnbDN5UDQwRFQwbXJZSllRWXFXUnZ2YTE2UUhaT21y?=
 =?utf-8?B?NzZFMFJ5ODVySGdZb24yTzU5akw5REZWb2h2b3ZyRE9OVmppS0VJMndCZXJh?=
 =?utf-8?B?U3N0Z2cxajdkdTlJVDFPVVUzWmROUWZ1dncyWGx3c1NUY1RtUWNnT25KeDlT?=
 =?utf-8?B?S1MydFBvRHBlemVjMS90dndhS215RlZKa2dETTBvRWRrRFU1bStTaFdVVHdO?=
 =?utf-8?B?WENSVVZpbldrMEx4UVkwRUdURUJYcTVEc0Fza1U3SjhrakRTR0MwUlZraW5J?=
 =?utf-8?B?SkdGdUh0bEJCYlU1ZUJiSGM4V2NwVjgrQmRYMW9wN2xjRUZIbWJRQ1dLSStz?=
 =?utf-8?B?cnNiUGhEUS9OTWkzNEF0eXhyU0FqWmUvTFJnbU9wWUhRZnRWaUJpWGsvRHRE?=
 =?utf-8?B?TnpDQ25IWllqUXROZmJEb1ZrOTdtNzV4N2o5Z3pUcisxNFFlTkpqdmpSeWVI?=
 =?utf-8?B?bXA5TEhFV1o4NzFOTThSUjUvdUkzdjhJRnkyOFdIVWdONjhrd1FKNVBOd1JH?=
 =?utf-8?B?OHhUUkxWMmhCZGtxUEVTWktWZWhMbHJuOXQ2U3pUTHdURDJTTlEzK0ZyOW5U?=
 =?utf-8?B?WlJPK0JpS3NLbGEvT2NHZFpGY0h0a3VHMUdzTFNlYXcybHJqNkNJOEtFemF0?=
 =?utf-8?B?VUV0eUwrMW13Qm1RYnJyUllwQTk3RHc2Wk5pcXp2NmZIQ1ZqWU45T0ZYOFBY?=
 =?utf-8?B?azNVaVpoL2xZV3FqN290dEVjU3RNWXZvYndXb3NacjhKYUpFWGZxak1QOVNG?=
 =?utf-8?B?WEJSRmxEbTI1MXN5UFhpTXZkRFZsUzE2V2lFVEdCQThiRkZRZXdaUGhTTUdW?=
 =?utf-8?B?ZzhZYU03ZHF4OUpkeng1K2g1SW53aVd1RjI1MUFCS0dWb0NjUFpYL2RRek9v?=
 =?utf-8?B?LzlINEhTRGVIZkNackZpVmRRc3JhY0t1STRVTHFTODBvUTZhT3JBSVAzL3ph?=
 =?utf-8?B?WWVRc1JJVUtNanJBb05ZTklCV0JZOFNibmJQNUhYcDByODVrV055aEp3MFRK?=
 =?utf-8?B?dnhjR3gxb0swMm1ESHdZcFpiYm43TDNCNnVJdGJXd2V0NGUyWm9yV3RZTGpz?=
 =?utf-8?B?dDVmalBrQjRMWmdvbXNvc3E1dHcraTZuRUhwcGlqY2JSWGlQVVF0ajRrd2Zu?=
 =?utf-8?B?WlVYMnBZcFdHeXh5aGNuSzFaWTlQdEc5MU1DYmNUSTRJTVdLUCt0amJ2ZXZp?=
 =?utf-8?B?VDh0am9adHhlVDRZS2tXM1NzbzhOcDZ5cWs2S0RlU1hVM1RnYm5CWktGNWg3?=
 =?utf-8?B?TzcrN0xVM3dCNXErQ2cwREtYQlIrRTBYMkJGam1lZmJaZFJiamRsWlZ4b2l0?=
 =?utf-8?B?VVNOaGZqd0NvZyt3VWthVkZ0ZUJ3OUJFNzViWmwzUHphc044TVgrMWVYMVd5?=
 =?utf-8?B?Tm03RndabEtoMHRiR1lFUklhUndjakhHK0VJUUUzMDFXM0wxUnI4cFRXTTVq?=
 =?utf-8?Q?u69HfjntNipY99SvcyeZTz5ykZZMfJXAg8bsCOMZWw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <662FBE77960D0F41A9DDA7C59DD5FB60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376f91f7-1a63-4f00-1833-08d9bc20cbed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 21:05:29.5024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: koX/7iuSIyZ6nWowPNOM8THVVnHNeWTr7FV8bYpi/n83C/5oyNvygvOM0ndLoVgCvItb8VIVt+DlRqNVdDvOXTGijr+MsE9xwy38pp2Lx6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3517
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTEyLTEwIGF0IDE1OjU5ICswMTAwLCBNYWNpZWogRmlqYWxrb3dza2kgd3Jv
dGU6DQo+IEBAIC00MjUsOSArNDMwLDggQEAgc3RhdGljIHZvaWQgaWNlX2J1bXBfbnRjKHN0cnVj
dCBpY2VfcnhfcmluZw0KPiAqcnhfcmluZykNCj4gwqAgKiBSZXR1cm5zIHRoZSBza2Igb24gc3Vj
Y2VzcywgTlVMTCBvbiBmYWlsdXJlLg0KPiDCoCAqLw0KPiDCoHN0YXRpYyBzdHJ1Y3Qgc2tfYnVm
ZiAqDQo+IC1pY2VfY29uc3RydWN0X3NrYl96YyhzdHJ1Y3QgaWNlX3J4X3JpbmcgKnJ4X3Jpbmcs
IHN0cnVjdCB4ZHBfYnVmZg0KPiAqKnhkcF9hcnIpDQo+ICtpY2VfY29uc3RydWN0X3NrYl96Yyhz
dHJ1Y3QgaWNlX3J4X3JpbmcgKnJ4X3JpbmcsIHN0cnVjdCB4ZHBfYnVmZg0KPiAqeGRwKQ0KDQpU
aGVyZSdzIGEga2RvYyBpc3N1ZSBoZXJlLg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
Y2UvaWNlX3hzay5jOjQzNjogd2FybmluZzogRnVuY3Rpb24NCnBhcmFtZXRlciBvciBtZW1iZXIg
J3hkcCcgbm90IGRlc2NyaWJlZCBpbiAnaWNlX2NvbnN0cnVjdF9za2JfemMnDQpkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jOjQzNjogd2FybmluZzogRXhjZXNzIGZ1bmN0
aW9uDQpwYXJhbWV0ZXIgJ3hkcF9hcnInIGRlc2NyaXB0aW9uIGluICdpY2VfY29uc3RydWN0X3Nr
Yl96YycNCg0KVGhhbmtzLA0KVG9ueQ0KDQo=
