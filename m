Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667DD435301
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJTSwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:52:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:42880 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhJTSv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:51:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="227626448"
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="227626448"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 11:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="720520665"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 20 Oct 2021 11:49:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 20 Oct 2021 11:49:42 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 20 Oct 2021 11:49:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 20 Oct 2021 11:49:42 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 20 Oct 2021 11:49:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbsaJVzfpGztfM7vxI2fOSJQFHakOqLs0S9DFJbXymE7bUgsPAXaVrjhRV06SxiCMWv6bwGsNchuCszb9MlvSrfWcdWsYfC9kTjcj0cBYV3OQ7sSENpQ3Gt3sTn9li/d6aX3Gv6A4CYG74ITLv2LVSx0nVIUZ32IJZQkzgcYdkuK6RrRCiO+JsBOPaXFWg/tLcc0lW1RnyiWquroNa5Ck3+kEHt1W5MGIN+nozf1WEj7+VN2jdMfCXC3R9jHvB+FV/woyDHXL6edS0GAwVpCM8gBnYg8zAB+H8ZX9yZGeMaYOP2pFn4Mlu0/2aMUSHipTOB57Q/si8H8CPXZOKcEww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6cSmwUBTR818DHnTiTpbBQvnpgc52IkUm+Zl3laloU=;
 b=QrxnlTkZNlFC3ywUKGit61YCco3EedmAhAKvfRyYbreY8b3Fxf5+1Ht0UcssnxtegTKBCB1+ghZ2/p3y2f0MMeXA/JpNCOY54emI9TPQiorNBSA+TbwZu853EG5+g1RLq5bPPkQHimdHh1NCZWKcpu8P3jyKsK94Ay0xXT7tY8OJsJXIeYHA5AEcIS9F/48wypKOyZ0hOCU8Hl1OOOwMroo6iZYZFocclP/+H76SXsnow4IoNKQLrB4CDG+mR0izNYPpjKTqS9kf/5nJkU1q6Z92O4TpZWENldKsBFWJMIwMOjhL5r/NgLZBSs0c4B5wBd+Mgshvb0W2VQaPMNDgKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6cSmwUBTR818DHnTiTpbBQvnpgc52IkUm+Zl3laloU=;
 b=fBL7XoMvPIFnBqoziEla6Iu2F8wYlNlCeqnDP1ro8iR5UiYxjkDVUm/EMfurdw5KfdamfZ4j61dc1DE3yipHpFs0tgWilEKoVQFVMU/NwKa/5EBKnlfUIR+7i0mBwVYNon5YmTATktXB3rrF+lAYyd184BnO+V7njy5DrfvuvSw=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 18:49:40 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 18:49:40 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 1/1] ice: remove the unused function
 ice_aq_nvm_update_empr
Thread-Topic: [PATCH 1/1] ice: remove the unused function
 ice_aq_nvm_update_empr
Thread-Index: AQHXxIoY+1oke4+2l0OxBPD15Q8mlavcPOqA
Date:   Wed, 20 Oct 2021 18:49:40 +0000
Message-ID: <adf52e0ca3fbe0c9726f283a9690bd335afbf3a6.camel@intel.com>
References: <20211019091743.12046-1-yanjun.zhu@linux.dev>
In-Reply-To: <20211019091743.12046-1-yanjun.zhu@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a4bb9f3-50de-459a-c06c-08d993fa5fc3
x-ms-traffictypediagnostic: SA0PR11MB4560:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB45604F1FB9C9E97FEED1A340C6BE9@SA0PR11MB4560.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTBTYnJGc74Dp9gPXKey9yVglo4T40NbK5p8Dha/nmVhWOIUD5Xx0Tqva277WhuLoVoNIWTpbLcBJkRMG3EObiWvoeDWo2aiD69L8a8+zjCErdjZAjW6XJ0ApVLiwSVdtej5/PqRPeDwFDgXVoD+DcdYIj0+8+RXF51lrHbNG2buPSOBYGbOa/ydYymzrRNwW3HLLHr1i4LRau9AAPkf50D5Z4XE79FK/X6HLQbZPnGsC4wLi7GJCkh5Am4B6KjVkh8opbwIGdVBQdO3gDC0Vc0NAXsB08bK9OpIchIt8n5qfMa4IJ5oItRhENtpINdJKZps6ZfPq8JKsj9Rkl+fASAv/1qiB6v9oI5BJ4HZG/qKJDjGNH6neE34d3RV26ic16w6x84fcGMhEI5uzYceFw2c1lfnL9nD0MshTmwwLHOcGp755BholGOd1iY0/1ug7bAJ6iT14hFFv/5rvDLTMnVSeos1aWLGRHmcpDbdVKbhjjZxmgkO/A7LIuPhcWhEVoLpSOly1aidI+y6cN7+mbc7r0/FzJWkQbfo1YcLsK4vNJbwcHv4X6XnfifRYstDyo7BQj772ikOdm2adh5Orj9Oiney1wFyU6MaaxycwdhU0TFWGuL4Dh20kqch8OYkCzu5aPy/GN6pxIbUhsUDvUR4wiqq5PHS++zkepRTNdw/9BjIK1w84fmHXi8Bwf+bpF0/9tcmq5ePdABqcpBKIrR+l3H1HTPgDjuQWqeVK3BY8NsJP4JfityCRXzGtmTBUGGiX+iuks+/9NRWpOC19hz/RTkcWArFSW0HgD+9SlA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(76116006)(2616005)(83380400001)(66946007)(6512007)(38100700002)(66476007)(66556008)(6506007)(508600001)(36756003)(110136005)(966005)(8936002)(86362001)(5660300002)(66446008)(2906002)(71200400001)(91956017)(38070700005)(122000001)(64756008)(6486002)(82960400001)(8676002)(316002)(4001150100001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXFLc01LYm01cUgza0FZL2tNdHhNcDlRbm83TDdSc1FzOGdjRlNIUlUvbElr?=
 =?utf-8?B?S2lFUFNSL0szOUdOTnI0QmU5S3dZdXRKb3FmeDBIYVhQaG44c3I3WFgzeURi?=
 =?utf-8?B?ZjdSdno0MW5pSU5saEhHWERGNVJ1dWwyUTdKZUU0c3JlNTJHSXkzbE5tY2ZX?=
 =?utf-8?B?QWk4S1ZaaS9YSnZybzh5QmF2R3hHbS8rS2JZZkpEVmlZVytIWVBaR1ZJZW5C?=
 =?utf-8?B?YWNTQTUvdEUyT1hzMEZpZlRXVGErczMzV1ZuUUkxQVNnVnNpN0NIeHlmdHhp?=
 =?utf-8?B?WXRkMFA5dkVwRGg0MGg1YjlBeW9KdURWYmFoaE9tLzNDUURTU2M1OFg0Uzdv?=
 =?utf-8?B?RkZxcGEyMGNmQkE1TkNSL1oxL1VxdVloTWRuZnpHdTZtV1lkT0h3T2pOTkR2?=
 =?utf-8?B?c2dwTUQzak4rM2VONnAwT2NCdVFmZHdJZmNob21jR0JvbVkwQkhZRWxRSC9D?=
 =?utf-8?B?MTBueUxUTkxzaG1WUmJDTUJBZTl3NG5TampmWmVSUWlsUmQ4UkQwVUlPbHJh?=
 =?utf-8?B?am56OTJ0c1Jrd2JGUmJjS1pSVnlIU25CMEFudkIyNFR4WUU3dkRvZGJzUlhj?=
 =?utf-8?B?a0JFc2RBbVN3K3prb2wzRU1xalFoVXNDN1BEYTRVWFBab0pMTjFDYWUyVExa?=
 =?utf-8?B?Nlk4RWNDUCttSkltWHB1V1ZQYk4zeDBoNHFCbUUvOVR1NGptYUFDdDRkZDhW?=
 =?utf-8?B?YUcxWTZKcFVuMnZsd25kRURIWFBEekVLNGN3bWZOYmRkVi8yaS9ISnhINUUz?=
 =?utf-8?B?akdOMnE0WFlKUXZ4Rk9lZHlZdE5FMXdCK3JYVGxSQ21VTTFzSis0aS9IVlYw?=
 =?utf-8?B?MWRhY0JxWEVUbGU3SHVmYmUyREI4Qlp4Y3dTekhKZlUzTisyRW0rQTlWeTZE?=
 =?utf-8?B?cFpXNHkra0doZWpmSFhFWlQ2QVdxUXJMSU0wb3ZkdTByMHVkYzlkYmd3T0dC?=
 =?utf-8?B?QldNMTZjRlBMd1RQR1FZYjh1Si90S0Y4OFBMcjBTVHNjREY3bmZwb1dZSzBY?=
 =?utf-8?B?Q2RJNWhQejNZNC9MV2taOGgwQTJqeGEvekxGQlNPcDVhazRRZXhwblFZdHF6?=
 =?utf-8?B?a2xsalZvY1hXdGlJNEtjK3UveFBRbHAxdmVqRUYyajlRK3F5dFlXQkpqNVRh?=
 =?utf-8?B?RGRTUkwxbjFFcVlkM1psVnMyYTliVjh2SkQ4YjBRYVh3T1NHd3l4QVo2Z1pK?=
 =?utf-8?B?VnE2cE1TTDQxWU92OXZkM0V4cFNvUmJ5cU12NUFTRWJiN2tEYXluS290amFz?=
 =?utf-8?B?ZnBWTEhZYjg2M0RSMkZWL2ZSMEtWTU1NaHVxVmV1Q2RzZWhpdmlNTHBWUzNC?=
 =?utf-8?B?U05IcjJWdmE0ajVxejNuRU1kUWRjTUNEc2JkTHJFejFqMzdWZ3NVcFdSSGYr?=
 =?utf-8?B?aWE3WlA1VzhZSjFRSmM5REFuYkpBM0xRRGRjM0U3RHZXVERuLzNTb0VnMEcr?=
 =?utf-8?B?R055Q2FPQjFUR2ZTU2ZVZjBTS2dGZ2g0SjB1UldGcUZpTlRZeE91bWtJSWFo?=
 =?utf-8?B?TnkvNGdhYzZGbml6eTZieUl6ZkZjamJFeUlOc2R3dUNvQW45MW9pZEQyMmYz?=
 =?utf-8?B?WHc3TXlmV0Y5ZU5FZGEwcTRqV2R5aWpyZ0RTaE1Ia2taeHA2TEVYN3lVMTNW?=
 =?utf-8?B?UjBiaTdvb2FrZkZUaGVhSDBSZ1ZnRkgzd0ZRWllqdEZaYWRIVlJvVzRoTEVr?=
 =?utf-8?B?RTNZZElGVXQ4U1JYcVZidTdCbDJ2RzVZYWw3eVIzWkY1dENEYnlhOC9Fa2Np?=
 =?utf-8?B?bFBEZjREZTQxQ05qWEUrbXFxc2tTUUpBdE56OVAzcHFuNE5sY2JiODVnR21n?=
 =?utf-8?B?V1hlamtCV0NVUXFYbld2QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B200B75D0898D144A0541A338DE0A867@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4bb9f3-50de-459a-c06c-08d993fa5fc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 18:49:40.6407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anthony.l.nguyen@intel.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTE5IGF0IDA1OjE3IC0wNDAwLCB5YW5qdW4uemh1QGxpbnV4LmRldiB3
cm90ZToNCj4gRnJvbTogWmh1IFlhbmp1biA8eWFuanVuLnpodUBsaW51eC5kZXY+DQo+IA0KPiBU
aGUgZnVuY3Rpb24gaWNlX2FxX252bV91cGRhdGVfZW1wciBpcyBub3QgdXNlZCwgc28gcmVtb3Zl
IGl0Lg0KDQpUaGFua3MgZm9yIHRoZSBwYXRjaCwgYnV0IHRoZXJlIGlzIGFub3RoZXIgb25lIGNv
bWluZyBzb29uIHRoYXQgd2lsbCBiZQ0KdXNpbmcgdGhpcyBmdW5jdGlvblsxXS4gSSdkIHByZWZl
ciB0byBrZWVwIHRoaXMgdG8gc2F2ZSB1cyBmcm9tIGFub3RoZXINCnBhdGNoIHJlaW50cm9kdWNp
bmcgaXQgaW4gdGhlIG5lYXIgZnV0dXJlLg0KDQpUaGFua3MsDQpUb255DQoNClsxXSBodHRwczov
L3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvaW50ZWwtd2lyZWQtDQpsYW4vcGF0Y2gvMjAy
MTEwMTkyMTU0MjMuMzM4Mzc1MC0xLWphY29iLmUua2VsbGVyQGludGVsLmNvbS8NCg0KDQo+IFNp
Z25lZC1vZmYtYnk6IFpodSBZYW5qdW4gPHlhbmp1bi56aHVAbGludXguZGV2Pg0KPiAtLS0NCj4g
wqBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX252bS5jIHwgMTYgLS0tLS0tLS0t
LS0tLS0tLQ0KPiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbnZtLmggfMKg
IDEgLQ0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMTcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9udm0uYw0KPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbnZtLmMNCj4gaW5kZXggZmVlMzdhNTg0NGNm
Li5iYWQzNzRiZDdhYjMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfbnZtLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9udm0uYw0KPiBAQCAtMTEwNiwyMiArMTEwNiw2IEBAIGVudW0gaWNlX3N0YXR1cyBpY2VfbnZt
X3dyaXRlX2FjdGl2YXRlKHN0cnVjdA0KPiBpY2VfaHcgKmh3LCB1OCBjbWRfZmxhZ3MpDQo+IMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gaWNlX2FxX3NlbmRfY21kKGh3LCAmZGVzYywgTlVMTCwgMCwg
TlVMTCk7DQo+IMKgfQ0KPiDCoA0KPiAtLyoqDQo+IC0gKiBpY2VfYXFfbnZtX3VwZGF0ZV9lbXBy
DQo+IC0gKiBAaHc6IHBvaW50ZXIgdG8gdGhlIEhXIHN0cnVjdA0KPiAtICoNCj4gLSAqIFVwZGF0
ZSBlbXByICgweDA3MDkpLiBUaGlzIGNvbW1hbmQgYWxsb3dzIFNXIHRvDQo+IC0gKiByZXF1ZXN0
IGFuIEVNUFIgdG8gYWN0aXZhdGUgbmV3IEZXLg0KPiAtICovDQo+IC1lbnVtIGljZV9zdGF0dXMg
aWNlX2FxX252bV91cGRhdGVfZW1wcihzdHJ1Y3QgaWNlX2h3ICpodykNCj4gLXsNCj4gLcKgwqDC
oMKgwqDCoMKgc3RydWN0IGljZV9hcV9kZXNjIGRlc2M7DQo+IC0NCj4gLcKgwqDCoMKgwqDCoMKg
aWNlX2ZpbGxfZGZsdF9kaXJlY3RfY21kX2Rlc2MoJmRlc2MsDQo+IGljZV9hcWNfb3BjX252bV91
cGRhdGVfZW1wcik7DQo+IC0NCj4gLcKgwqDCoMKgwqDCoMKgcmV0dXJuIGljZV9hcV9zZW5kX2Nt
ZChodywgJmRlc2MsIE5VTEwsIDAsIE5VTEwpOw0KPiAtfQ0KPiAtDQo+IMKgLyogaWNlX252bV9z
ZXRfcGtnX2RhdGENCj4gwqAgKiBAaHc6IHBvaW50ZXIgdG8gdGhlIEhXIHN0cnVjdA0KPiDCoCAq
IEBkZWxfcGtnX2RhdGFfZmxhZzogSWYgaXMgc2V0IHRoZW4gdGhlIGN1cnJlbnQgcGtnX2RhdGEg
c3RvcmUgYnkNCj4gRlcNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfbnZtLmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX252
bS5oDQo+IGluZGV4IGM2ZjA1ZjQzZDU5My4uOTI1MjI1OTA1NDkxIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX252bS5oDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbnZtLmgNCj4gQEAgLTM5LDcgKzM5LDYgQEAgZW51
bSBpY2Vfc3RhdHVzDQo+IMKgaWNlX2FxX2VyYXNlX252bShzdHJ1Y3QgaWNlX2h3ICpodywgdTE2
IG1vZHVsZV90eXBlaWQsIHN0cnVjdA0KPiBpY2Vfc3FfY2QgKmNkKTsNCj4gwqBlbnVtIGljZV9z
dGF0dXMgaWNlX252bV92YWxpZGF0ZV9jaGVja3N1bShzdHJ1Y3QgaWNlX2h3ICpodyk7DQo+IMKg
ZW51bSBpY2Vfc3RhdHVzIGljZV9udm1fd3JpdGVfYWN0aXZhdGUoc3RydWN0IGljZV9odyAqaHcs
IHU4DQo+IGNtZF9mbGFncyk7DQo+IC1lbnVtIGljZV9zdGF0dXMgaWNlX2FxX252bV91cGRhdGVf
ZW1wcihzdHJ1Y3QgaWNlX2h3ICpodyk7DQo+IMKgZW51bSBpY2Vfc3RhdHVzDQo+IMKgaWNlX252
bV9zZXRfcGtnX2RhdGEoc3RydWN0IGljZV9odyAqaHcsIGJvb2wgZGVsX3BrZ19kYXRhX2ZsYWcs
IHU4DQo+ICpkYXRhLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHUxNiBsZW5ndGgsIHN0cnVjdCBpY2Vfc3FfY2QgKmNkKTsNCg0K
