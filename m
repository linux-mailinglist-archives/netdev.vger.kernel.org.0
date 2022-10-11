Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A145FBD2A
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJKVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJKVqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:46:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A09E0D6;
        Tue, 11 Oct 2022 14:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665524778; x=1697060778;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qf4vJi3XeY4Wejx7NAAuC5npNtXSLbnHiYiJZgs1Ow8=;
  b=UPO318US74mNE6oYBmh17/ko1bIJvkzDahWai1aZZkTXOGxIGJl7aM2k
   EKlL9/8jpRjZoKsejfouqJcFmvropsHnCJuhGUhpwSyIqvxO661xj+utJ
   sNiodt4DZ5+9yFAlbW2uT2rHkc3j7XnC9J/i/AH8IyMqZ/YEjqncdYRmg
   1rr+u8HSlQGxd+KqAyB+tzAWkHGicr+nIMJBb0ATkrHDfJ93AEFCydeEv
   bN+kvOpx8ZDGbkKgCJB6XeAPixpiw/7aqefuDFBLKRMdR1IEWI4R14z/+
   ZrMjLVe/d4jb+DQKjGF53wyj35+bwB4tY/p9/xmOnGsw/gVDPXjx+N6/X
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="390939294"
X-IronPort-AV: E=Sophos;i="5.95,177,1661842800"; 
   d="scan'208";a="390939294"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 14:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="626529172"
X-IronPort-AV: E=Sophos;i="5.95,177,1661842800"; 
   d="scan'208";a="626529172"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 11 Oct 2022 14:46:17 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 14:46:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 14:46:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 11 Oct 2022 14:46:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 11 Oct 2022 14:46:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHPF8P6Un3M5BzKjc6oRBnCcuDui0N2CoGxxLdUYbtNzQHd4KNvyGwByu0Z0DSYDgOUs9JOxZb23cgu8MtTPv+qkAbDA0mVmglZ+UJWeDjIeOy0LRmcnfch8HJAEMWa+JJKUhZj/aq315r0M/pnNNgQMBzuUKtLq71a7AtzFypnlUYFIrllgtuXLkmn8nZ9GaikFxnfgmBvUcP8ApfqZA5K6eZAXeoQbwJnXnQOgHsjJPfgCZAEM2jD/F9Aj/NW2UZVrGtJ8h+L8JlsQ84sdwKo/x0hLCgsMvgNP8/IF5ZfQiFVy8sRrt8XsXwb5KEywepkBEua7rax9sjj1QKwRkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdKBi99ENiyXiVOzszEa6iddQsRrAlgFGFm6VK6GjAQ=;
 b=JxXR1/tJnAAqkxUBbrXK3jwa5LszwBe+8nMoz7Vo6V9AEyZz7wYvzvd4GO2BQgvMUzly+Bu+EhuOKpjwi2jSQWfJn9WlOToWDFZ3cbpdtmA7jmeeHpMEKiwfr8mUyE0XOrhk8/uX159rmYMVHbAtTjb8lLOKwXUKTI7xh5psKz37xF+4XpPFCS1btNckOSgw3gG91JFJsKSl5lQdARrkdUl1YzzfjrspLR6v1bFwfeTo45hGgqJbnk5iwBpQjW6vU3v+8lvtmxiqOOaD6WaQWAaVTO0PMJS93NL23XygWfYlG5y1sLhJTaavqJwwC2/aDrCZB/85KHFIpr3BDrap6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM6PR11MB4611.namprd11.prod.outlook.com (2603:10b6:5:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 21:46:09 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1%9]) with mapi id 15.20.5709.019; Tue, 11 Oct 2022
 21:46:09 +0000
Message-ID: <2e38c0f1-1b6c-1825-12c1-5ad135865c0c@intel.com>
Date:   Tue, 11 Oct 2022 14:46:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH linux-next] iavf: Replace __FUNCTION__ with __func__
Content-Language: en-US
To:     <yexingchen116@gmail.com>, <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ye xingchen <ye.xingchen@zte.com.cn>
References: <20221011111638.324346-1-ye.xingchen@zte.com.cn>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221011111638.324346-1-ye.xingchen@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DM6PR11MB4611:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dbdb21f-8020-43e8-ec2b-08daabd2020a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fe5S8/wTtMpyLLkRnAPxZ77VElkBQ+jVYae+QJ03xg+br/mOP3ym1GO+/DQZIskL4cHJMh60CLqlfKS7+BWk+JwylCr9FWjor4S1N+1t1xKFVgcPYCo+sHKNjlXG3JDWlp+ThaPZ3ZpFUYIZl0Xmu/yN4zY2HwmODAVYx8GjcN/6OIFfzNcVpv2P6rSsemWarBFI5MSxieP1pnFHrMOTUU+xqo9puKR9a6E+c6AvyoP2jgJaVNkfFTAhyacZfAQ6NesGY+ezrbrAC28+WdWspe0nTn99SXWwRX3ngl83Se7xYDBKh5WvRR103GgQTg5fSjtPkpMf0aO93aUDj2r3xrVRwmaOXS4x6TPFjy6Lb0Z72cxcxSayUzAwUX+5a1Xp7cHN0DT9j70FwrN52NlsfYrd0/S7KW+Twe9ioOrGFP7viby33foVyTJDQjj6BrM5AwaeCe/f/+Ed0rQz/W6SICjcv+abTCPGu0pQLJ/Noee+2RDXnbhOz4CvGo7AcHdiBrN0Reyy+r2gKIrpsW0FhAAaJAn0R2P8/pWAO+0PQWTOOD7gJhNcLHwjWr9Wfj2+VcHt5P634bDvItaTDjlybdWapqkluV9tBbumT9FyNaIe7dj9VsPUa7kzCQVQwhyeIr9U3ckk4OdwWA31sUPCENe9K3m1xB2Y8BWuM6/NjIzsa40HQI07kJ8x7T9TmwlhcZ5jk75b68uY3v8CNt1duJGF40DlTMKab/Pe5hZ1nKpiwzYAwUg5RhMJLXx9SmUKDfT9NYOt2ht9UzJwpfnM5bxRZqgHCL3oDQ7/PF3DaIQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(82960400001)(478600001)(6486002)(2906002)(6512007)(26005)(186003)(2616005)(6506007)(53546011)(66946007)(86362001)(66476007)(31696002)(66556008)(6636002)(316002)(8676002)(5660300002)(8936002)(44832011)(38100700002)(83380400001)(41300700001)(4326008)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWVZc3M5VDVGR3NzcW56L3dVbWVvNmtya3ZMVnMzUWRFVWY4V2p1TnFOUTIw?=
 =?utf-8?B?ZjVGNW9HZnFud29nSUdUeVJ4YjczMStMc0FHaCs1K3lkN2U4SGVIamJONThJ?=
 =?utf-8?B?Uno1cmVWdGZPbmxpSGlQNGFCUGVBTCt6aDFvbkxNTExOZm1GQXlEOU5GN0Zv?=
 =?utf-8?B?VEo5Q1UveVNleUx6eUp5WW9mUGE3UjN5bnMvcVFHUE1QZ3oxbFhrVUdsVTNI?=
 =?utf-8?B?d2JZSDVBb244RHBVaGMyaTFKOU5Eb043QTVlTmF5MDRqZnk1aGp6d09sQ0xN?=
 =?utf-8?B?bDcvUmhXYXV4eHVDSmlRRVBpaG9iUDZoMHFEVXVla3JXbHp3OURkcEJINDFu?=
 =?utf-8?B?ODVsTU8yYjdESzJSbnU5Z2ZZMkEvQ0VhcVFPT1NOZnI1T0VkZWpQT0wwUkUw?=
 =?utf-8?B?aUVpY1FnQnFQSXA5RnBLNkdoK1A2dXo2SlBua1Z2MWR4bDdYSm53U2I4Nitt?=
 =?utf-8?B?cnNNUWZvbGZhVGZDV2g1WGlNS09TTTI5T0VsbHBNVk84NGkyVFFvbHdwekFX?=
 =?utf-8?B?akl5UzVBU0dJZHowZC9QSFI5andjUjdlRDAxRXJ2ZU8rRHd5N3pVVFhHSXRx?=
 =?utf-8?B?aVpWbEN4V1NsTUMxN2lVekhFUStVL25OZVpBMWdETWl4ZVJkV2xxVkVYUGJO?=
 =?utf-8?B?dU5LZk9WMHdOUW5oRW9yaFlCcE13ZnhSc29mUHZPQXcyQ0V6TzJMajNTWVl2?=
 =?utf-8?B?UlMyeDVDa1RlRjhKd2NlSUlQZGQyWTJlU0M1VmgvcDlzVnFKeWNrMkZtdVhH?=
 =?utf-8?B?dVJnUFR2RHBWVFd2Wmkzbm9lQ2xSTDIvNU5XUTZiV1hEMWFhYitGU1NOaUZM?=
 =?utf-8?B?bEJTRkxUZkNjM2JVRm9YcXBSUktrNkwzSy9mT21Xam9sZjNIQlRWeWNIV252?=
 =?utf-8?B?N0FTeTR0NmlhdWxwSkZZektGOTFER3hvZUNRNmZ1NEF6TEhob1g5bU55T1Jw?=
 =?utf-8?B?dk1uQzRSbmFLbVN3TERlL08ycEZuc28zMWtuS2lBMmNYNG5tcVNtUUVjbUJ3?=
 =?utf-8?B?RE1lUW9LSFBsaWxPM1Rrd0JNWHVGYjFoeUl6YW43SytnR0gwZk5MbmgvVlBK?=
 =?utf-8?B?ZVVWeDhvNERodWRPa01zZkhCVjdJVFdMdGRGbUppcDY1Q2JmQkNsanVVbXNv?=
 =?utf-8?B?NVJLODJJU0V6RkNkVjAzbW1BUVZzV0dKL3BqaVhkQlFBdG5PZXh0M3ZuVHpw?=
 =?utf-8?B?cDhJTVhHV1lNRjhjRFBDZC93NDMrYUc0M0Z4blVTL0lGQjNNQ1N5Wk1VbnA5?=
 =?utf-8?B?MEo5dFFWNWg2dFhtSDZIVUNnQ1J2YlE5aTFzZnVzTDlUNTFuYlprSWs1VDE2?=
 =?utf-8?B?TEx5ek1xdjFqRTJ0bjZYdHZGemRyTTRGZVBYUzIzZ29EN1QwYnpZK2Ixc0Rh?=
 =?utf-8?B?WHFlWUk5U3d5M2VwSitPRmlCdGhBdDhweDJiUG5sdXQzUUNwRm8vcE8yMTdJ?=
 =?utf-8?B?YWpUa28za0ZDNzVNTVZsZFZQck9RQTkwTnRFdk5WV3c3M2lQNDl2UEVHN2ww?=
 =?utf-8?B?cEpUdlhQTEJkTXRQMy9JYXlFSmdPd0xMSGVzMzR0RFUrckVoNWpRYi9yRjlF?=
 =?utf-8?B?WWtwalFSSWZJMjZUdUVtenNDVExQaVNoNWd0QnR4QnBNLzdlQWlxck0wdUtI?=
 =?utf-8?B?N2NqajlNVmVqa0tobzYyUm1oVUVlY1d6VHhPbUN1azJYU1JneGhBT1VjSmZL?=
 =?utf-8?B?OWVmTXF4Zk0zKzk1eDFBYzRKd2JJZ1NZWW5Jb1ptb0FmbnZ3OHYydnQ4YW5N?=
 =?utf-8?B?cWNFL1hnelpZMkZxQVgwWTN0YytNQXBuR3VDbTI3bitScW14Mlk5Njh5MFhn?=
 =?utf-8?B?UnhmK3hzTnNGakRPM0hGaHlJRkphcVRKMUVKWE1MTVUwRGo3Wlo5NWV3YkVh?=
 =?utf-8?B?OHVVSnh4RnI5MTc2MXJRM3VxMWZOa3EwMlhnMFVmcUtKeXFhY3BNUnNlcVZN?=
 =?utf-8?B?ajhKN2lKdStWUC8veXE1V1YzMWVwUXVTU24weTRGUGVoeVkxZmxoRFR1RGxv?=
 =?utf-8?B?d1VsUERzcGJFN0R3anEyTmdEL3JRcHRZdWM4MHNLMWRkZjJYYUxrUHZGRjVa?=
 =?utf-8?B?cUg1YUNYYXN2TGlMMFNQM1ZUcTVkOHVlZFB3RUY5b3dsaWRObW9SaS9hcjJW?=
 =?utf-8?B?L1pKRlVSYmM0NU44anFDajhYT0lmWTlNWm1Ud2o1MVEvWEFxR3hxRnV4UXFo?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbdb21f-8020-43e8-ec2b-08daabd2020a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 21:46:09.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /w47VSJIvZ+yORlel/yuFOSyVJhP26KCTP1/QVtb7cslatqLG1k97Ch9l41Ahr9JM3um4SIOYuRG0JZHZ7+lvlyMcasUH5m3gdjUp5C4wCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4611
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 4:16 AM, yexingchen116@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> __FUNCTION__ exists only for backwards compatibility reasons with old
> gcc versions. Replace it with __func__.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>   drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3fc572341781..98ab11972f5c 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
>   		iavf_close(netdev);
>   
>   	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
> -		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
> +		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __func__);
>   	/* Prevent the watchdog from running. */
>   	iavf_change_state(adapter, __IAVF_REMOVE);
>   	adapter->aq_required = 0;

yeah, how'd that sneak in there? Thanks!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

