Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143F9672A61
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjARVZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjARVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:25:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D86A61D5F;
        Wed, 18 Jan 2023 13:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077102; x=1705613102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uCXgfUJSZz3ahdqUNkDxnsvotB342iTrCVxIkk5mpt4=;
  b=Up0nq+R5R8Pn6s4iyhB+gGHzRVUI3ZPaHJixZZRhLOkVcZDkL33KKh0d
   nCnwOOgnUmPkh+A0caKVLP2RB+GM5JZKllf57kj7fBu9tHY1WkxK633jU
   gJ93MJezyF31pCre46N+b1zvccVn3QT+qkxJTtG/y9cANm9YjKk66O9qj
   DHiOHOUqBJvENuv/bv0Jy4eGfMEdrgVymVg2V9eCHEwpvULMmo0Ff9isJ
   4cAMC8v6Kos+2xaoWrm2838KeyartX/+b6PUgTmCQowa8x1RbryQreV4S
   ZVXADOmB5xz9W2ZYpDbb5QkyTe4cEpDit43oatEwlrbdrmOtxEr0lYT+H
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="325156570"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="325156570"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:25:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728390211"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728390211"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 13:25:01 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:25:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:25:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:25:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:25:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7cqf3XZP8kshftMYG/+W5qNXsHO4ZKsbmQB2R1caDuQojD1f0BgylL5ExmO7haDVukftjBJbInfUMdF4NlKydRoH3Mfr3gsvdRgRUEJpb1DYRfdTHHIe3xxNH+IIaVz1CywQy314zm4MGiukVCuq26LJO9LFtjQnouLjGMIFI6Y3HibJEQowULc32tCw0mj26j3z1Z3DCN2Q91mUiBtmR7RAotRfzdmx+r0KsO4Zxw3ifF9yzV58y4Tn3OXBR7SRF6NgrqTwk6WeWArbEOI1Aa9XFHYdIEeLBqit0u6bECcKn3p5PiLOWXCMF9ePApQ29QXZ3Gp1rGRpHSulOIQUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XduN9LDQotqau206fJFA4RhbHBNCdz+NX1/cV5Kb0G8=;
 b=Iglv1GbuCRNI47n8ogw7BOxBvaG+RXNYQiGYBf/cLzmhtlnoWIcN4Lpl+BulRcc+kgPhuCnWMYJd37oo9gcF77agIlOzaTwEy2u6CrcG9XntzmlRanCKKc8us10Drb3C2nCG0m/SbsBwAK0Fo1AZGlIwuU5kJfup3wJ5I6RztYfhYmqWPbeZzI1t+giBC7gFnsddEMXywVGkjJMu1H9+bz58+mXgC2R9SgIXlaXxKWADogddWZvysMU9TFrPr1aS4g/yvnfVCoAg+2w46QYfOO5ks5SXX/ZJGpqTJvfDl0SQmssKl7IfMbAXT/Gzz/VqwsncroYOA2UGRWC1ZT33yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:24:58 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 21:24:58 +0000
Message-ID: <3d5435a0-b01f-9015-3d7f-525001bf77ad@intel.com>
Date:   Wed, 18 Jan 2023 13:24:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v3 0/2] Fix CPTS release action in am65-cpts
 driver
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>
References: <20230118095439.114222-1-s-vadapalli@ti.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118095439.114222-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::7) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY5PR11MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5d9813-ea00-4a40-ba33-08daf99a7369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3sxH4CdLluUuu6j1nH0SF5hlX2TcGQaObLTy6fjAlQDnS7/oxDkCBW4+rPUmDJnQ6dOpD0mmRz2XzVaSni1RP8dAHj/8RA/crHZOTlfsyG3TAJgbhtY9YL/fJ4LBsVHU1xuNze/1xY0SAN5NkjfwKadqP3Jv146K2yg+kXL9JLloNWqj7Sk0/VuNW9CBEsredVDkt33dHXqJfxCkSdYDXgYyphUqxSAkF9J4LubratrrAR3B0sWBZve3DGlWyA2dYXRc1zZDYgLiTNh5vL7qczTPTtvVdWRYO1uyp1sUQ+os7NUgkleB3CLJfht3lWNYgR8Loj7Sq3uMEnZEd6pFmd+4/95qpp80YUhSbX/JzVRBfIe10i8hieWw8GHQ2NBjnT3iylm72HJUHjb0k3D7DiE01ahk1waDKrAcvG96oiU6jeeSvhUBr0JuZcSGEZRx+kpDzxRLxPDsa6LGBBWu75Li08uKuaPHyQ3fTFkG/f2SMzlRMzrKZjPWueKrvN7lDJzP/lZ025OEYACDLuZKWfIwwPjPMxkvmR43dx66a4itrCaXQnjM1hYhVA4rK8y2f9hli7l12GqZ9XmVZ4X5ghcvp1nye2vKN3JjHZ0Wtlf3zsHsXDyvELqJ8g7QM2l3h+bVtNriSulRw+3WHHcmW8z3g4HawTuEzHSLcoktHFcLS9NJBka8ngfoiwALkFTLr0N+CokZlM6JWFaR8lmlJ00731Zz76ZHU13+bYi4xfom8561EKcFn+S+4fBhk+sf8rqLuNBS3X12fGiCDmUwyNqlSIsWGwVIC1uZSpELgURDDyLdatfkXEDhFHjlsqIi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(8936002)(31686004)(66476007)(4326008)(66556008)(8676002)(83380400001)(6506007)(53546011)(7416002)(5660300002)(41300700001)(66946007)(316002)(2906002)(186003)(26005)(6666004)(38100700002)(82960400001)(2616005)(36756003)(478600001)(86362001)(31696002)(6512007)(6486002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTl6amdRU3AxLzJMekppQXJxalFwa2xpZ0VIb1lFYnFvcldYRjVMUWxPRlNQ?=
 =?utf-8?B?MElNaTJCZ3hpSDJHYitnZjlVYjhadkZBSHQ3RHAxRUk1ZXlFSUNKOWkyM3hS?=
 =?utf-8?B?bTFKR0dqaUljUGxZSjhHSjI3T1pBa1pLdHcyVDhjY0owRHR6THlBdHFWNkhz?=
 =?utf-8?B?dE1MWHlqTzE3OUtzbWZMVTB0QWlVRGpJMDJOSzV3WnN0blk0M0VQaGFYQzF3?=
 =?utf-8?B?bmRlSVVYMWo0VCt0NjJ0RFVGM2ZGb3NPU2VyZFlJYjRVdVA1dnhML28zbzdV?=
 =?utf-8?B?ZHRYejh6aFpKVG5sZSt4RERCNHV5RVFDQWZvazd2RVdLMWRjTUUwVW81UXhs?=
 =?utf-8?B?RG9UQkNHVkxFN0hMM2dFZmNJNHdXaUZmQlE0Z0VzdGdUbU01MFdzcWNuMkNs?=
 =?utf-8?B?RTFpd21FNHR2T3p6YjBqTnl3bThCWVJlNnRXK0dpY2RxM3k3MkJiZmlpQXVq?=
 =?utf-8?B?b0VmK2ZKQVFLSE5QcWpoMEVYL25XYWtTWmU3cXlocjVCYWxpR0FwMGY0eE9t?=
 =?utf-8?B?d0J3LzF2T0NVWmdkVFJaaHl3Ri93bU95SjhtenROcG5qNGJaRjI5V2RxcWZL?=
 =?utf-8?B?c1lUUW9rTzJ2RzNQOEZCWVQyNWVtMitobFd3Uk0wRzFaQjk2YkVQTFNKazlm?=
 =?utf-8?B?Z1ozcEJRUEVpRUx4b1RGQ1dnWFgveTZnc1FDWi9OQ0FwTW93eElicmJ0V1hu?=
 =?utf-8?B?bHZLL3MyQ3dkUmpvWXlCNEF3SldwSXEraGlZNzNCVDZ3SDZKY0xVN0M5b3hi?=
 =?utf-8?B?N0Z0bFQvWGxNWmJEdm11eXE0Q1BVOHMyWENDVjBya2pxL1YyZEN2clk1RTcw?=
 =?utf-8?B?T0wrMWxNeThGakVkc3lkSk4rNWd6TVBzTWp5QUVsemZSR0Z1RWxuRlk0RjFU?=
 =?utf-8?B?QzJ2YjdGUE1iSkE5VU1jb1M4TEF6WmpQZlc1L3YwL3Z4T1h2M1A4SytISmpQ?=
 =?utf-8?B?dm5YaC9vY2I4Mkd5aVdEVkdndmJLaXJOMVdIc0E1TVBHeXVxR1lyUnJldDl5?=
 =?utf-8?B?aDRzb1c5ZUp3U25ha0M5ZWphZ0FQZFhobmtuSUE1OGt2Ymg2S1pZSzVlRTVy?=
 =?utf-8?B?VFdack1OUzg1SG1nTVRiZGo3Uitpa2xYbzdyeWdyMnJ0U0hwU0hoemJDSDRT?=
 =?utf-8?B?bkdwMWRzKzJPRXNXOG5VVnZuUDRQMzgvVXc0bmRMU1cwL0FaZ3VQc2paYWhj?=
 =?utf-8?B?ejhaVDZzVVN4VlUyZ0hacjJoQzhieVd2bmUwWDVTSzQyQXhTbEI5Z3BGVTYx?=
 =?utf-8?B?YTU5Rkc2d25Jak1iTkhVcW1HNkZYazNlMnI3WmNjcThyeFZ3VmVuUmkwUllm?=
 =?utf-8?B?dEZ4Sjk5T0g2V2V0MW1rTEt6eHhoK1FBWWllQndtVGlLeGxJajhDdll3SmtL?=
 =?utf-8?B?Vm9hWDJGVlFycm96blZrTERQTTRua0FMNTEvL2JoYU9OTkRjTkk4M014Y3Bz?=
 =?utf-8?B?UDlTYm1lQ3U4N3plVkN1QzZ2c2VkUjErU2QybHZObEdsakFLbjZqRXRUM3Vn?=
 =?utf-8?B?NnRLOG1MZmxoQ3RENytTMEVpUFZIczVQZ1hkWXlYU0tWUmdEd0tGL2x1R1p3?=
 =?utf-8?B?Y2hDVm53bXRLQi9tRnh6UGI2VERCUXhVSXlNcXd0K2k2QUthMnF0K0c5a3pB?=
 =?utf-8?B?d1VndkJKQUc0SHpzNk1xNXdhZGFlQjQzc2J4bDE2R2w4bFcrOWhMWUM2WDRh?=
 =?utf-8?B?eDl1OGJScVAyNzY1OWtCZ2NVVnJHb2dFSTIxUnFGTHJhendONkJmQlpNZVBj?=
 =?utf-8?B?OXBYYXJ2dnJKVVNhSlZQTkZCMTYrd21sNlRCckNpaWdLektETWFBU0FXNXcy?=
 =?utf-8?B?eTQ4TVNsd3c2WnFLNXRadjRrMDFqNkFVek94WExTeG5aUzAwd2NXZlkwZHha?=
 =?utf-8?B?dmp1RjM0LzVmZFQzNUQzUXNacTh1Z0ZLbWF2S2ZoWUV4YUZlcjZQbUxLd1dK?=
 =?utf-8?B?Qk01MzBHdkJ6bEdPR0VWbzRDemEzN3FVUkhOc0NOenhsYk9vZTJNNStuK29S?=
 =?utf-8?B?U2FJUTQ2ODl4TUtqeWRDbWtPa3M1Si80NmYrUmhoRit0TEd4VFd6d0lVaU1n?=
 =?utf-8?B?eFBZdFFpQm5QRm5vcDNldHNoYnA0WFlkQmRFWm8ydEJ1MTlwdWtMVzBleXZm?=
 =?utf-8?B?OEx3cEpNVjF2S0JVbzNCbjJoQ2pRa1NlUW93SG9kOXFFQWVORVhrYXIrRU1l?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5d9813-ea00-4a40-ba33-08daf99a7369
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:24:58.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7ifQhMrFHFUdF/DfDTN0qAYaVGy8vTkPsfgY+BxORd+T9YSz3G9G2NhZz9hGQeWMIhC+/G5cWoVlKO5pAbfGbOLtJq881MlBB+QbNzb0MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6139
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/2023 1:54 AM, Siddharth Vadapalli wrote:
> Delete unreachable code in am65_cpsw_init_cpts() function, which was
> Reported-by: Leon Romanovsky <leon@kernel.org>
> at:
> https://lore.kernel.org/r/Y8aHwSnVK9+sAb24@unreal
> 
> Remove the devm action associated with am65_cpts_release() and invoke the
> function directly on the cleanup and exit paths.
> 
> Changes from v2:
> 1. Drop Reviewed-by tag from Roger Quadros.
> 2. Add cleanup patch for deleting unreachable error handling code in
>     am65_cpsw_init_cpts().
> 3. Drop am65_cpsw_cpts_cleanup() function and directly invoke
>     am65_cpts_release().
> 
> Changes from v1:
> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>     error was reported by kernel test robot <lkp@intel.com> at:
>     https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
> 2. Collect Reviewed-by tag from Roger Quadros.
> 
> v2:
> https://lore.kernel.org/r/20230116044517.310461-1-s-vadapalli@ti.com/
> v1:
> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
> 
> Siddharth Vadapalli (2):
>    net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
>    net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
> 
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c |  7 ++-----
>   drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>   drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>   3 files changed, 12 insertions(+), 15 deletions(-)

Seems reasonable to me.

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
