Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE183F8C5E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbhHZQmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:42:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:2677 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhHZQmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 12:42:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="198024916"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="198024916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 09:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="643920243"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2021 09:41:36 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 09:41:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 26 Aug 2021 09:41:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 26 Aug 2021 09:41:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzBYKs9tD6d0P/FybPedqMseHibxp2qE66iptBGX8T2UsPOUb1YvwbBwBSwchAHMP0a1rNjnHOqSrD3vEzjnE4+q0KBylgTEJ9LJV+QQwU4MFns/eG4WxOZX8PS1jlT+EyS27wa3npr1kuCejNlMOFeL+hFUPnFmF9rQoUrNHWGAS5gOcgHj0mHy8NIIBSBoCNnKq7F+sVMD98Hlps6WvtgShXy/2NY2QUZqR16vVcLx2SLr+nAcSjUWGbKoJglxA68SZEi3QokFevuC3PP4aI9lQL50hAvLrqDb7tuPReP3dkr5Xm/KNDEgs3KROK4aKl3cUojYFg5GmtsZG/ofaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bz276nngrJZFsSQao7wZKf3/NgU/lnQmslgTYmHLdw=;
 b=LYruYUw2OTjogbHxoY0klJhqDeJqOYlFju57iv7tSirtQZ/Flm9LRoxHTlbRGPEco3hBO25HIX54DoqqYblLKr4QuJg2eXIfISyrigatePmjTd7YxYoMYebpp906WywH+pX/AX5y0kCj073SQvuB1ZwUi3e2j0yQYpkPOY24eTufplqjSlL4cyAHGkdaolMEFZm3Ck5DEXlLLD3nQRos3IUYJxrW9esrdIPGpk5ad6lHK0sazg1njHJr78DbmYyL4LbOkIgaIuHn78vfz/rOnR88a9++8fdsa8Fa6KSp5+wvGk3mKsAmn13LdQeoCMF5BVbqsWQGS8Or70A4REENFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bz276nngrJZFsSQao7wZKf3/NgU/lnQmslgTYmHLdw=;
 b=PCp+Aotpuw4if0d7r342qh+eT5+2e3drx0zFq0lWYK6SF5qmzb0dxfNbjezBUQSOk4gv1Rx0UyEOIvKsbIH5zTm/2MHJrPDV6P8105sqyLUSmrSXvD21FETKyio1+vbKX7XSMlOTWWOr7mP7TSJCA2W/ikHvvFHleILdS3y+3hY=
Authentication-Results: kuaishou.com; dkim=none (message not signed)
 header.d=none;kuaishou.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB2000.namprd11.prod.outlook.com (2603:10b6:300:2b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 16:41:21 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710%9]) with mapi id 15.20.4415.027; Thu, 26 Aug 2021
 16:41:21 +0000
To:     Eric Dumazet <eric.dumazet@gmail.com>, <kerneljasonxing@gmail.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
 <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
Message-ID: <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
Date:   Thu, 26 Aug 2021 09:41:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MW4P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 16:41:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ea1d46f-ede4-47f1-c5fe-08d968b055f5
X-MS-TrafficTypeDiagnostic: MWHPR11MB2000:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB2000B301749F655E50A5F2A697C79@MWHPR11MB2000.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9oD6t3nSRhXw1kkyJe4kX+jXlrkJrW6vwbSfXckvAgL9ciEO8JwVX2PjMeM9sAdOPrImL8Wdr4F6hXkZF4mjCSvlbcp3HNWSnpnNyZOp2uz3NmdXNkOF0OlcH00WD6L0eiC+pi8jZE1dTZFol3qyNSuwXY/rzJC9IPks0ZQ8Yg2+KXAC/y2mzUaAQRXr8ubQoAbcnaRt8XmA2jws9TWC1DayE+nrdlzLfMmte/3dXKq4a7z1Tw3BZ345KUfUKis9citkHMhVzV7gugZCF5xEGmYjZTLhsXo1YaRvGcnB1IXb5j8LDWOfEoDNvAHAGJTxT0HexgMTSFGG6U3SoOC6nPQ+ftU+wk31oh1V8sVD2RKQvJfLQO0q1HmWD4teNhMhgS/Gbl+jsw0F2UmdgHBPTQjQgR3zTErHNtP61b+uA+uO/ondYO4Oj7qeuG+RZDf9ntRU3SB/ZGrg5Q3MZVJoUCiDTqde3n+7IM9VPEQ05oWlcNA7rqS/3pqcJQmN7Ry96KHq7n5RwgC0TuLbMbfUX/hFemYXsrrbpw7JVymWmzzoo/pAvxqcKhKDrWx3IsNqGJ8SYxyX06dHthiG8DBWoYrBiMOCIhSPQLS1QUKnaXinf16bRReLarIKNLTZ615HV0DUc5fVoMdxOAft3ahzhrwWlR77TWOjZLUtiOlv2hXtM5aAIxl0Hp5oOYZqu9JfzMDCnl6g1pP4OsUUp4x3/5v8BBNxAp3NvisEjJL+QukZG93D389gzk7S7xT3l7MZTSF9pEYUOfAIPUhe9v3viUiFZ78q0HLrwCa2FonqPqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(86362001)(36756003)(316002)(921005)(31696002)(54906003)(8676002)(38100700002)(186003)(8936002)(5660300002)(66556008)(2906002)(6486002)(66946007)(66476007)(2616005)(4326008)(956004)(7416002)(44832011)(508600001)(16576012)(83380400001)(31686004)(26005)(40753002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEM3ZVB5TVhsNXg3Z2d4R0pJSXZNVkdHZzF0Nmk1U3F1U2JTbWlPZTJkVmww?=
 =?utf-8?B?bXBTSXJqcXNCVGZkQjYycFRmVnR3NXBxeE9ib09XOGVJSlB0ejloQ1NzMm1t?=
 =?utf-8?B?SUVPbXpwUiswaHJIb2o5dU1VKzFBZi94emJsM3Q4dkNIQXp1VnB0TWt2UUlM?=
 =?utf-8?B?aHg0Qm1GWG42N1FYSjhkL2MrSTdEV01zRUtJR2tCem1NR2Y4d2VwNGg0d1A5?=
 =?utf-8?B?eTBHTXBKK1BlY3U2a1Z2bHlkalg5c3NFLzdkc3pjSHZTV2FIY1FEZG51bkpX?=
 =?utf-8?B?MGFUS2E4UFArSEg0bWJLOUlCL0QzZ295S09JTDVMU1p3ZythTi9iUUkzNkox?=
 =?utf-8?B?N0kvd3N4Tm9KNFF4Mi8rNHNVRDJtdDlSTjZCUnk5WU5wSDlvQlFVWTZJWElz?=
 =?utf-8?B?cWtrdHRHc1RYQ3ZBcEw0dXVlMmZ2QmVsdDZuM2JnT2VINTcybVp3NGVtL0VS?=
 =?utf-8?B?U3VldkRQT0VTUVhWVnc0QVg4TDkza3BoeXg1SVFyc2xLdFo4UzBkUWdmOHgr?=
 =?utf-8?B?dVBHYmt2Zi94d1FlTC9ybDQxSTNtak5DNHpQaFBHN3hHSDFJK3pacmU0Q3cx?=
 =?utf-8?B?OUM4Y1kyM3BNNHh1TWNXTFBOUmx5WFZoQ1BITlkrMHNENHpiSGF6NmtsRlBh?=
 =?utf-8?B?ZXRlUTdvdzJsUnBhSERKWk9jbXVYRklIM0RqSVY2dkRJUi82M1pTS0RxMGx6?=
 =?utf-8?B?d2NjUHBnYkdTNmxMM1ZNa1h2QWJQSnFMamN0ZExGRm1USTlCUFZ3b09LUFkz?=
 =?utf-8?B?TDFTVVhGVjRCWGpqYnpGekNtTmoxUWNIcVNqNXUvWVBURGZwZTJVQzlGOFpM?=
 =?utf-8?B?NW9WQjU1WkVkL2VJZ1l2b1Z3TGFQQjhDTkk2V0JjYnNBVG5FQm1TN2FNc0l1?=
 =?utf-8?B?UFJXRDlqcWtkQjJJU1VGdHFCVVB2S1JIV2pHNXNaUlNUZUd0RTFRd1VzdW1M?=
 =?utf-8?B?dWZIalltNk1zMytzcUszb2szcCtOc0d3Z0l4RUZuSDExT0MzZFBhaFVnclBh?=
 =?utf-8?B?cVVPbkNGb0ZZNU1OeXZPNTBvMXhEWHNyakZyUTBmWTdVYVpyZkJXSmdwT3Jj?=
 =?utf-8?B?N0tJV0VCeHhRUTEyOTlsWHhtQk1Gd09vYTB5WUYxNjEyR0ZKcndsUlAvb1dV?=
 =?utf-8?B?VlZnN1BrTkdUWDRrYkJYM2dEeVBoRERvSDJkWktHbk9sS05oaFdOWnVoOCtI?=
 =?utf-8?B?UCtXVS9reGpTK2RwejJrTkl4VFdsNkZyQUhLeTA1bHBaZkxOQjYxeHZqdHpo?=
 =?utf-8?B?a3B4UGlDMWViY1dZTXAyODVaYnF4UjF1eU1UL2E1TmdpZDlJYTFkbk92cTRr?=
 =?utf-8?B?STFOVDl0Um1qUCtXUVVWMDhlNWt4WE9adXhtaDU2Syt4YWM1cTBKNUFlc01j?=
 =?utf-8?B?VGVKQTdrRkdJVi9tZU0rbUsyZFJ4SXRScWxKeHVuU0t4Ym12Ly8yYWNObzBF?=
 =?utf-8?B?bzlBSWlTdmErNWM3UHVXTnhIYXJzOXR5dWVIOFRUZyt4V0VQYnU0bWpFQUlE?=
 =?utf-8?B?ZXZmUkE0UFdxQndLTnlJSElPTTJ2ZlgvMHovOXFQcUU0S2NlRHhPUTkrMFZY?=
 =?utf-8?B?YjhORm4zRmdIVVMzU0xpMjUxdGpBTU90NUxtTG9sWlB3Ulk5SjQrWEhIQ0dT?=
 =?utf-8?B?NXRIZ2dMZUZFbUtVZEhicEZpNTVrTk9Da0dkTDNKajU5SllTN0NNdVg4UVQr?=
 =?utf-8?B?cHZGbC96d1NIYjdnSjMrUUxyb2h1a25WcE5Ld1M4TFZGR29ZVVpHc3dVc1B0?=
 =?utf-8?Q?nnByL/zIPAyfvkX/HLfZy1fnAnuK78FM4JlFqEk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea1d46f-ede4-47f1-c5fe-08d968b055f5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 16:41:21.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0BjUbWb+D18V+CX0Elm1EKzlbQmMLSkzO5XUKkFI8G6pAVPyjaMeO92gYinphfxx+x9rl6oUWxDa1L3Ekj5rGhZT6SVyYqFd9ciuvMVup4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2000
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/2021 9:18 AM, Eric Dumazet wrote:

>> +static inline int ixgbe_determine_xdp_q_idx(int cpu)
>> +{
>> +	if (static_key_enabled(&ixgbe_xdp_locking_key))
>> +		return cpu % IXGBE_MAX_XDP_QS;
>> +	else
>> +		return cpu;
> 
> Even if num_online_cpus() is 8, the returned cpu here could be
> 
> 0, 32, 64, 96, 128, 161, 197, 224
> 
> Are we sure this will still be ok ?

I'm not sure about that one myself. Jason?

> 
>> +}
>> +
>>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
>>  {
>>  	switch (adapter->hw.mac.type) {
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>> index 0218f6c..884bf99 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>> @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
>>  
>>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
>>  {
>> -	return adapter->xdp_prog ? nr_cpu_ids : 0;
>> +	int queues;
>> +
>> +	queues = min_t(int, IXGBE_MAX_XDP_QS, num_online_cpus());
> 
> num_online_cpus() might change later...

I saw that too, but I wonder if it doesn't matter to the driver. If a
CPU goes offline or comes online after the driver loads, we will use
this logic to try to pick an available TX queue. But this is a
complicated thing that is easy to get wrong, is there a common example
of how to get it right?

A possible problem I guess is that if the "static_key_enabled" check
returned false in the past, we would need to update that if the number
of CPUs changes, do we need a notifier?

Also, now that I'm asking it, I dislike the global as it would apply to
all ixgbe ports and each PF would increment and decrement it
independently. Showing my ignorance here, but I haven't seen this
utility in the kernel before in detail. Not sure if this is "OK" from
multiple device (with the same driver / global namespace) perspective.

