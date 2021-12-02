Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9D8466BC7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349101AbhLBV52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:57:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:46721 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243133AbhLBV52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 16:57:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="235584008"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="235584008"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 13:54:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="541389964"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 02 Dec 2021 13:54:04 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 13:54:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 13:54:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 2 Dec 2021 13:54:04 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 2 Dec 2021 13:54:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kScEw431/Dw7HUMOtII0EvnmUMHJ8mmnxnfsxjF9nBkpv5Zwn1ku/EOORixg8NQY5J0XdFVdY/0O5hGRwbL+noh5ZscExkflDKXSFEVerKVIMIsVcy0XD4+N+E5sEab/MhX9i0TCRONpbwhrHFkiohKQf+CxzaoTsuKUqWCmHFgGcfbgxl2s7ExG44VvnSRsDLJKsoMgvehSHntL8P/DzpMIclnftwPZ+bKlCxMJvaQXhcfi2+e4hq27YQz+PDXWidUufVHmCjcERgrGZuPwSUkBY6FCfnnpQuJpLENVY8zQrK3VQ73we/1vbY29RhXMmqcVTCCgk4KXFwMfC9WXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjS5VW6eRJUPIOO/Wi8K9l8kiYR4B32osqo5CYMSi5A=;
 b=RArSEXeYYGRT4rxqKLduUi1NMA2wblztErNgKOzjgmu8IQyQ4YZSInRsp4UQ+wTga/bAumfUULhZhO/MKSpIINBy33GEPNjFTYwCEkYPrHNbh2kmKDmaTD+3hd7sNA7Om/E9e5Og/vDir+ofTwDO8TwxTHGD/B3kYhG3U3rPLMdx0Asb3ceUmsV3LJVLDGeF2dRD4PcDDeEaCHx337silVXlCd/wQ+djVpSRQqeeq9OKzyoGvrB9Ogu214gKxTHTrj3ows4STh5fzapFPMZ+6YWUtLAvQMa9zOLUq2imITtCSqwJKsMcXtlmnY/GWE8cFLL+3LZu3K1XfwgrqBdM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjS5VW6eRJUPIOO/Wi8K9l8kiYR4B32osqo5CYMSi5A=;
 b=ztp2rL6LCqBWx3FF/6nnz+g7Mz3AVfuWisk9KJ6xXL00uaWand2Sp5klnIy9J50e+BT8RS6nyQBlV4lVhK/VTwWsxHArZrEJD/EUbkGcvOdp6vj2Gn2wHQdVjpvg12r0aW+t1pFYR4UxTp5iuPlap6vOAhYMxdWPcZ4NN4TufkI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 21:54:03 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.027; Thu, 2 Dec 2021
 21:54:03 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Maloszewski, Michal" <michal.maloszewski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 2/6] iavf: Fix reporting when setting descriptor count
Thread-Topic: [PATCH net 2/6] iavf: Fix reporting when setting descriptor
 count
Thread-Index: AQHX5v7sT3iKEdA2okuHbCR4ZBset6weisMAgAE1LwA=
Date:   Thu, 2 Dec 2021 21:54:02 +0000
Message-ID: <94d191a609fdde77a3df8672fae838a674cc8822.camel@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
         <20211201215914.1200153-3-anthony.l.nguyen@intel.com>
         <20211201192622.10a2b139@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201192622.10a2b139@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 738836bb-ed8f-47d4-b13a-08d9b5de4138
x-ms-traffictypediagnostic: SA2PR11MB4873:
x-microsoft-antispam-prvs: <SA2PR11MB4873D50B545EB3EAF7371A93C6699@SA2PR11MB4873.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T8EUG/jmbbepTpl+E+erKYv/mOwyvm+8s5/03mSP6oNqqUrZtfPgr0TWRMuq3Vfz+SEu69cHkpZ6nPpk1enVBqDY7DHRaAB9mZDNEz0ZGHnyxIDRbb1NW9rPSdjn5oHd6H3iYg8YYgGX1bEhwMXJbW/DWU31c/2aGh2NhNx3SEySE91VnL+8K6Tgg3z7wvzdV1MM5VtzJaP3Fwhjep2rcKjZhNQFt5KNo8Z8oVcJdkV9e4+FyiEkBxR4d/ROEt1MSnztCp1hqXSku671amT1WC6MGJclNXIyJGGg8xvCcvB7ybVwqryA1+sWFLIQ570vZ23QbNgvWGKsDt1CrnF7SBTyWu1Piy7KlSPReRan+0pNg9m2AvyVWNyrjCpv+uw1NRit09nZdQLLlXvkpkgBMF78gjebMcmVjS/GJjp0Seb4sFScU9tZdbY2DSFGhAWc5ZrbUyVDdRtS1kIsfPrwS3KrSVy7l45udaQ+XgqQBW+jrGEo/RRlfDVqkV9XqoBdIKwLsZUXbpFxSTBiq1UQfi8JMEAO14x7lJ09wKLJNdPcWHSE83cQ91ULsu111qmAxIb4Aqts2vUTg7k04dbLpN3JXYCUej/gprMLBl8pHj63LFF3s3AUQvuHA5f2tULxrj2OqWk/1kQJbTM8e45TKi/+h5iS59qwec6Jyju+fx8vYBJLr/xHzxO/FBER0FO6RRyhg8UNQwvCyzkqhy6Apw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6512007)(4326008)(122000001)(8936002)(26005)(508600001)(316002)(6486002)(38100700002)(6506007)(5660300002)(36756003)(8676002)(4744005)(107886003)(2906002)(186003)(82960400001)(38070700005)(66556008)(64756008)(91956017)(76116006)(66476007)(66946007)(66446008)(2616005)(6916009)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2pNYWZLMy9UYktLd2RxQUY3MExXRWhGVUFrbXBucmY4ckRyaXltY0tDREJw?=
 =?utf-8?B?akZINzVtdW5OL0V5QklZSFFxTHFVd0t0QSsrNXNkWCtaZXNtWUJDWW5RdUZF?=
 =?utf-8?B?TGI0M3A4dDd0eWUwU01mRVRsZ2ZORk1HZGJzRE5sK1V5SlVyaWdvTkEwNVN2?=
 =?utf-8?B?K093VVFjS095dTZla2cvSTJtSVNzM3NRNzc2WTVJU2YyQ1NhcGN4RHZCREpq?=
 =?utf-8?B?Q3gwQTZVWFh6VldwR0VEMEV0cms0eUdpeFpmMndXaVlvd1hkUzVDTVhPQjEz?=
 =?utf-8?B?UUU4em9BdDh6Y2dkaHNmOTEyRUg4T2VyRExoOS95dzNMUFB3ZUFTOXVPZGlk?=
 =?utf-8?B?S1lJbnVYNHBMMVlHYzJqcmRKSUNrY0lTNi9yRmZXNXpReVdWVW1KZHdraUpZ?=
 =?utf-8?B?Y1hQa1Y4c3NIOExVQ3ozdmNnNGIyNzIydmZIdkowTFBXeWJWYXpBZzg2eXg4?=
 =?utf-8?B?dXh4VFlRVm90NW5mdDRmUWZLT1V6N1dHcUVHVVVTcjBobXFLUVpZYTFQL3lP?=
 =?utf-8?B?dmEzNmZXd3RPNmRLdklJNnM5OWJYUkJIcDRwWjlvbFpuR1Y5aDloZ3dIMkl1?=
 =?utf-8?B?M3VxdDlXMENHcVBISzZpVEtGbE5hWDR4dExMZkRlMjNubks1c05zeEUxSGhI?=
 =?utf-8?B?YThrV2hmN01JQ3Q1TVpTS0F3SE4yYThzVS9pR2NjM25HSWk2WnBtU1hNUEc5?=
 =?utf-8?B?cUs2SElncnRqRkRnaDJhcy9uaVNXcHpqWjJOUmpiNmpYNksrdGI4ek81R2Z3?=
 =?utf-8?B?Uy8vTHg1K3BCVlgzU05takJlbkRvb0U2ZEh0VEhxSEpSNzVsSXRTYUpheWFF?=
 =?utf-8?B?TFUrMlFqc2VsUUI1MjB2UmxmaHJBeERGdXFndUY2N1BSdG9xdVcvOTdYbGcy?=
 =?utf-8?B?VHV6blZFVWdhU0d4ZkJnQURad3RvMDlyV0RPc1FJTVJ4VU1RT0FwRWo1ODZT?=
 =?utf-8?B?a01tZXc3ZjdNNnk2MVEzc1VBMXM3bnQ1REM2SXZydjh3cWpZRDRUS0VBUDA4?=
 =?utf-8?B?TjBXMWdESWxpcm5nbXVVVnIrZm9CdVg3OFpzbjBjWnV2RERseHNxaG9jczhV?=
 =?utf-8?B?a2dtcm1JZzlUb2trdmJSQm92cWN5dzlQVTJuL0M2Z25yenRRaXZ2MWZXeVJJ?=
 =?utf-8?B?QURtekdKQU1YdGFFTCtOLy80aGNYZURmUzNjTEhzSzZlRGl1amVaL2JMNWZk?=
 =?utf-8?B?cW15RXFPak9PZjd3dFN5cURKWjdxNkRnWnJPYjRJS1ZIb216ejY4OTdCWExN?=
 =?utf-8?B?RG0vSU5DL1ZBZlVmc005Y0loYlYrTzd6WDVqbTlpUXdxanE0a3JFeGlDc1Jl?=
 =?utf-8?B?NEFveDBnejludDV3bmFzVjRRWER3SU81RW5hSjVEYSt6UnQ4bXdFZEJodTZq?=
 =?utf-8?B?c2JvaHRGL3h3YXk5YlNlMURrSmJxbXVPV0ZMaldBOE50ZDMrdDBlN0JZYStQ?=
 =?utf-8?B?ck1nQ2NIdTNwR3lvZjl2amtlRkFqbkllUzFMMXYrNnRqQytxeXF0Rkh5T1Jo?=
 =?utf-8?B?YnpnaFVqZlFOeCtUcHpGeGNjUDlneWhGNlJVd3F1L2hDeU4rZy8rVjlkSk9u?=
 =?utf-8?B?Z2laSkk3dmVmaDZNUVNNekJuSVB2ZldTZUtnUXlCUlo5QVY2V2U2WFdDYVhn?=
 =?utf-8?B?Umk4YjhXVlU0TlBWbktXVjF6aFVmZm9wVjYyd0dGVlNiZitCVm1Ib3JwcmZ4?=
 =?utf-8?B?VEZKdEdKUXE3bmFXZmUwRVRRVElXb0dMSERSNTIrTTFNSjJVNzhRS3ZJcktR?=
 =?utf-8?B?bjljRzJpMUJLcy9QMTA0T0g3aWh3OGFXRTg0T0NmaWZIWGdPaWthMCtkVDNG?=
 =?utf-8?B?eS9aUjFINUl6L1NOdmNjdlZTbFFqYURlcTdTQ1BFcm1HZERwd3VoVU5hWERJ?=
 =?utf-8?B?bFFjZXByWVkzUklhbEI1Wm56RVVrTTcyMGlhYnYvK3BKL1I1bGE3SHJzNG5G?=
 =?utf-8?B?Vmp2dzFUdTViQ3JTYWJCdDltcFEya0Y2QUJZd2pDUllFa0U3RHFvSkdqWWVo?=
 =?utf-8?B?L0VyVWpiLzQyanpvZkp3N3FUWVRKQlV5QUR3Q1czL0dmWXcxNnVYRFlqOGN5?=
 =?utf-8?B?UWVySGRrUEdKU2x6Q3d4c01waVNLVlFHcUlQMUhLMS9oL3c1M1F6dkQ4QlE1?=
 =?utf-8?B?UGZMZ2dydEdkaXhlWmhtZk85U0Z5ejd2QnRMQk1NaUFKU0VWaWVXOHJFSDhi?=
 =?utf-8?B?Mks5amhMZXdjeS9UZWZwRnAxM2F3U1Frd1M4S2tlb29zSkpuQWhIcEFIbWNn?=
 =?utf-8?Q?870ibHZMH41oZ/dKjYxD14SvMSP0xpVnXnuzMthCMQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7BEC56F1F81D34D93E9D4CA3C3B7A81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738836bb-ed8f-47d4-b13a-08d9b5de4138
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 21:54:03.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aypNubdXnYLefAuhYPqUJqcMQbj4DOdqCEKfQ2K9YsUCP8yLl6+v9fWZ85imYDZCOToCUXfB7I8cO1NEqQx55+tsDpw0nJySv3EVQKZHCH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTAxIGF0IDE5OjI2IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToK
PiBPbiBXZWQswqAgMSBEZWMgMjAyMSAxMzo1OToxMCAtMDgwMCBUb255IE5ndXllbiB3cm90ZToK
PiA+ICvCoMKgwqDCoMKgwqDCoGlmIChuZXdfdHhfY291bnQgIT0gYWRhcHRlci0+dHhfZGVzY19j
b3VudCkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5ldGRldl9pbmZvKG5l
dGRldiwgIkNoYW5naW5nIFR4IGRlc2NyaXB0b3IgY291bnQKPiA+IGZyb20gJWQgdG8gJWRcbiIs
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBhZGFwdGVyLT50eF9kZXNjX2NvdW50LCBuZXdfdHhfY291bnQpOwo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGFkYXB0ZXItPnR4X2Rlc2NfY291bnQgPSBuZXdfdHhfY291bnQ7
Cj4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAobmV3X3J4
X2NvdW50ICE9IGFkYXB0ZXItPnJ4X2Rlc2NfY291bnQpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBuZXRkZXZfaW5mbyhuZXRkZXYsICJDaGFuZ2luZyBSeCBkZXNjcmlwdG9y
IGNvdW50Cj4gPiBmcm9tICVkIHRvICVkXG4iLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYWRhcHRlci0+cnhfZGVzY19jb3VudCwgbmV3
X3J4X2NvdW50KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhZGFwdGVyLT5y
eF9kZXNjX2NvdW50ID0gbmV3X3J4X2NvdW50Owo+ID4gK8KgwqDCoMKgwqDCoMKgfQo+IAo+IEhv
dyBpcyB0aGlzIGRpZmZlcmVudCB0aGFuIHRoZSBNVFUgY2hhbmdlIG1zZyBJIF9qdXN0XyBjb21w
bGFpbmVkCj4gYWJvdXQ/Cj4gUGxlYXNlIGRvd25ncmFkZSB0byBkYmcoKS4KCldpbGwgZG8uCgpU
aGFua3MsClRvbnkK
