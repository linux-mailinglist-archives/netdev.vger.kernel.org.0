Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BA66E1515
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDMTSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjDMTSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:18:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CC869A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413489; x=1712949489;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gT6B83KdSdZanQa4fbQhyj6E4cRvbox020f1KKPp8uA=;
  b=me4VuytMct9Z4zFnI2YjRhH1bRNCVXps2PBfDuEPkjmvP+ZDNgPEBGn+
   PtSFpTILVUXz9eu2srnCPq2b9PunsHKidOdJJ+FjUeI86XUAtgbLcBJnQ
   SfdOEBlRPlFjEdp/8H7+MTWGGKncRP2uZxG1Qcfz2VJvHP4I8jR/sI3FX
   N6Ag3y3PfVCRTPhzHoeEiBTVu4TUGprXQFTvZnujfKwXWnJ5MDkrdDMoA
   mDV9l86FjN/ck7L5s/+iv7pu8iMMRskJG5DIl7hRCpq2LmrCz2+41XysI
   4xmM0jUw/X3wDKxUnyDZCksEHztn7+v2DITjm9Z9hiG/EEdTzP8lAzl0Y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="328422097"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="328422097"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:17:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="683059977"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="683059977"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 13 Apr 2023 12:17:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:17:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:17:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:17:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8j0Bf4G4akh3mzxMbcdhnTbT7J9MlCD3k20t3xpGHzS8dhU83Vomh3YwEwWWjlpr6C5HcbmS0e0pEwTDnZGg/ysYXtU5X/pUeu2gYjl7JCnTmW1edrVf2yEH3IIXr1W1hk1718bx6QK09WwqYFmaqf6r3qQSJcY0K6HSfVEAAqzcqRtNGkfnNqXJ/G7Ro9QnCzJxBxiFyXqLsRwFkefEf80cZSYgl2O3wNzqVewRtlSUtZ0ERqPgi+Kq103L1KIVsn692wp8bZ951VPo9Js/ivkKOjxnAmee0GY6oCdrHB+aOCOrQqOObAKRBxR03g2lmqdEGbL30Sw2DG483umiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhvyXTR/xUiwhh/RVAasZXYKNk49znVz4oBERTwOS9M=;
 b=It73hO8eZhYH26BXrLtb+ga/5j45zfw8L8ck+ihbvHjCyVUCxrizwO57hnyxHCegkENf2PZ4FmoeF7TKPMOgtw52ZnLxks6NilwVV/fVtfRC3nHXL24Ta14ox0jqh9+ORmxEDrWZZs2Fl7t7CAA2hL6OA5DLHRpzY0UJAzVNrsiho+YvF1TBPcKYWEOe4F3xY2I5qNmv/1ITj4/mHrb+QfqAfGeNHGwHKz35/xHhoSKWEdcWKfSx+WNfjJNYjHwUALmnCZ12l68M4XZfhRZ5yokIZR5hYZIDl7b2WMbrmyHiL59E4EFCuIZcyXvIjiN17zq+Hx/w7jlZZGL3i92Feg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7123.namprd11.prod.outlook.com (2603:10b6:510:20e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 19:17:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 19:17:47 +0000
Message-ID: <5de9e0e8-5276-1ba2-63e6-101a73063ca0@intel.com>
Date:   Thu, 13 Apr 2023 12:17:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 0/3] r8169: use new macros from netdev_queues.h
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d0b883-1045-4f38-d8ec-08db3c53c3b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Uu7sHYZ7uNRz5/Zco1HgmtGl9BuHBcbxL8q7tW+9i1GrcDb72Ll3++JYXfA1xDxxvk8yMMZcmgH0XnEuHZThox7q9DY4TU7tPlLxxoRJ7CmutS2c9V2W9eprpCUCKtm58RKR9fYXr6i85Yvt2sGVCQBnQKMd+j9b4v02YZ3Gihys9ZvrQVqxX9U6qktYnigAGCpzYPkgNJCZU4kC6tKy9tnqGLefUuaKjFMMacYn8Hkk9145ZgxnMznQDDfexa4TIxKKY6NafW4Vl7I6kmporEThA713LUCdX1Ubr6A7XKPBQZgL+aMM0ZVRnfyD8OenmAMBhd2CzbNjeqkM5RoTjOOll/sQnjsZk31PfRK+1cLfNP+GUnVhTrKgQH+bwWo7JHnHEiFGXzZRlv9SyGVU2t65ViJ57FOzV9Pxscem06ySMwgjQSlXUx+mLASItzpbYGqOvZDAUXaSyOJMFKb0+bEaJBs5hkUxUfgP/TlI7jwNUhzs6sMlno94EDWDYXDGsvQFKcKNFwDiiej7ynKpxSFfQ4suVo0F9J+Mu68419/+DzliRi45lePDXOH3FwC2BHBRz+wL9RNZApbezHrthtW6yLlUaFCQQVMTHKZj7kuNhRuLFM9U2Dcgk569+svv9JOC+q32TUJh/frhddcvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(31686004)(4326008)(316002)(110136005)(66556008)(66476007)(66946007)(6506007)(6512007)(26005)(186003)(38100700002)(83380400001)(2616005)(8676002)(41300700001)(5660300002)(8936002)(478600001)(6486002)(31696002)(86362001)(36756003)(4744005)(82960400001)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjB6dXhIL08vYUVEN3VjbWhTV1JzaTlmQW5UcmRtT2lTTTFHU3RmK2VPVzRh?=
 =?utf-8?B?dW9kZVhXMVh2SzNpdFJBaVBaamFMSkxsQ0x5SUVHeC9nODJONnpwckcyVEJj?=
 =?utf-8?B?V1VqSHBvbDlYN1YwQXhMUy9rUGlrUVB5Q2dwREZ1VkltcndBSnpNMEpIb0dj?=
 =?utf-8?B?dzlhUWdNdE5sTDh5WDlrWDc1U1EzWjhYTm5jNmJoUEYxTzExVDNVVDhPQ0J3?=
 =?utf-8?B?NEhmUXh2b3BFcWlyUUIvVnNML3AvaWlGeDlzdFNFK0FsTzlrVnhHdUliVHVS?=
 =?utf-8?B?eXVGR2ZDVENsbjdZZUZIYktESWFWdUFMSndFUDRPMFV1WWFaN2Y1MnR4TWV3?=
 =?utf-8?B?MmlrNnlpN3c0Zjd2eFpPeHYzTnRHejM1dmxKV2RybHBQSElONTNWamQ4cHdu?=
 =?utf-8?B?M3l3aHhwNjRiRG01Y1lYbFdRa00xdDBkWlFKSnovaUtteGlsOWJvRFQ0Mzdt?=
 =?utf-8?B?dzI2WmVQUjhtNjdQYjcxTkpFREFKajJOWGVsNzBLc2I0VGpZWE1wZ0QyWERj?=
 =?utf-8?B?Q1JrN3I1QUR0L0pEaStMdUhmSTExeUk2L2psT1AwYlpLNXpIc05nY2F4dmFj?=
 =?utf-8?B?cUFkY01UelRyK05oSHh2THh3aHgyVGVFR1NURDkzUTc1Y0NnakNxejhXa2FN?=
 =?utf-8?B?cFdzOTFYUENqSFNnaHRUakZGNHBxWDV3VzdGaW1uR3Y2NUhHc1MzVnk1ZzdN?=
 =?utf-8?B?aitNRUVYWXNnbGt3WWpkOGVTVk15cWRYVUptQWVZVStDZERFb2JCdWJCNW1D?=
 =?utf-8?B?dUN4YzNuNWNmd05PTmYzeVVVVFlqVm5SMUxHMDBUbE4vMlBSRERMNGtzQlNl?=
 =?utf-8?B?OFc3VnZ2a25CNVBZaEVkQmtPYzgrSmV2MDFTWEsrd2ltLzU2Uk40Q3V2Uzg5?=
 =?utf-8?B?K3l2SVFvWExHREE0aWM0R0ZYY2ZId0RXcVRMbEFyZ2k1S2pmWmVKUkdvZzIv?=
 =?utf-8?B?V0lPeEhsNWxjTEdaZks2T0hSbVI0ZkZSdWdqK0F5aEJXNGdqUkFkZmxXbFNW?=
 =?utf-8?B?WVpYNWFIUFA1VEdXWEFySHBnb3o3QXdieDBPN2xPYUc5enBLR2lnbDc3Z2hP?=
 =?utf-8?B?bjRveEFJY1pPRStqQ2pyT2pLTkU4a2ZjamNKNzhhUjRJVS9lOVJ5T2YvcFF6?=
 =?utf-8?B?ZVY5bFR0UEY3TkEreE9rZVBCVCtmbkNJZ3JVYndMMU0rRXhsSTRuY1lmT29Z?=
 =?utf-8?B?MHc5Z2pZeDlKWHFSS0IzcU9lQVBsOURmTnFTRysvWVpFSXRnbTZ4S2IxeVJS?=
 =?utf-8?B?Nmo1YWJGSGQ0MFIyVjhxeDhoUzRmQnN6cS9VMWE3eXFJT2ZRRFlJRVA1bHV6?=
 =?utf-8?B?MDhRWXIxYlJ5Ky8zNHYwR0sxMlc0WmZSWnFlTXpQTHlIL1NYU3p0Q2d5a1h6?=
 =?utf-8?B?MGpwaTRCOHFJbVZuV2t4b1dHTlFteXZWNGRrS1d4MnBlWGlkdVJqTXZ0N2sx?=
 =?utf-8?B?UGNnQit0Q3N6ZTRZMlRJd3I3dWVjSDdVMU5DSm9kRStQTm1WeDM4QXZuTlE0?=
 =?utf-8?B?dVNYenJ4c2E0ZnN2UWJ2ak9ha244OHVXRWNObE82MUlkOXplT1hLa1ZhZGNp?=
 =?utf-8?B?RzBBL3ZsdWtSMmozU3Q0LzIvYlNPbGd0TGZrT2ZGdC9raHZFWnVYaGdpWXNx?=
 =?utf-8?B?TWNYZUtsdmZXNzZxN2QzU1ZUbW5Mc3hINUEySFgxbWV4RVhiNWJnWlhRU0xR?=
 =?utf-8?B?MXkrS1QvV05VSDJ6dmlhaTRNOWhwdGFONy9NV0E2OStaUE8vOGdmVllwUmUw?=
 =?utf-8?B?MlA1cEhoSFU4bmtBS2Y0aUZYNzRFTG85YUhqMHZCQ3Y2Mkh3SnFBbFNxQTN5?=
 =?utf-8?B?RHZZZkdaWlJGbXZRYmZINnBSUC84bml6OEowRnYyY2xrZE14ZjN0dytieU94?=
 =?utf-8?B?RURkUjFGdFkyMUJYbnpJcE9JK0R4MWdaczNSejgvNVpyVXo4eGxvdWxTS2d3?=
 =?utf-8?B?VUhna1Q0Zk5CUWlwUWJoajNCaWV1am1PY2hUWlJ2Q0tVUUFLdzJDOFYxUG5y?=
 =?utf-8?B?WmJsbHYzV1JLam5LSWM1M2Y4K201KzRLZnpkZTBqWUhTejdscHR3N09VZXZJ?=
 =?utf-8?B?L3BHMjNpcE90a0txTjF4RDBaR2N5RW9ydWdIaEIyazRsdzcxdzJXVm9DcWo3?=
 =?utf-8?B?OGNhWDdOM2p3Ri9UdkJOMTA5ZU1RZ2ZHQkVDeDNzRWdiL2N3Mi96YlZIb1ZO?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d0b883-1045-4f38-d8ec-08db3c53c3b1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:17:47.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQ5+N1myJTBiPHhTxf1iZ8k9kjKKzMr2Jg2Kim09YYCuySbvtF/MSkJ/5S4TUAXSzUGqA8w0F1H4DTzAwkiLbo43fGc9yfTcorjGVIsQw8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7123
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 12:13 PM, Heiner Kallweit wrote:
> Add one missing subqueue version of the macros, and use the new macros
> in r8169 to simplify the code.
> 
> Heiner Kallweit (3):
>   net: add macro netif_subqueue_completed_wake
>   r8169: use new macro netif_subqueue_maybe_stop in rtl8169_start_xmit
>   r8169: use new macro netif_subqueue_completed_wake in the tx cleanup path
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 54 +++++++----------------
>  include/net/netdev_queues.h               | 10 +++++
>  2 files changed, 25 insertions(+), 39 deletions(-)
> 

The actual patches don't seem to have hit the list.
