Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57114605231
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJSVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJSVqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:46:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB3C16D88E
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666215978; x=1697751978;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TQa8q7QwDqLAGpUU3DpXf44GoYMKRqHjDvWaWRdPwsA=;
  b=oJ1x4qsIgjYw6EC6YlIxgRclYu+zhp63Efp/p2LRmCvPvbFyAJ8v8lla
   6Tk197vAE7mKO2yaGde25NvPr56rIOaFuAT7Zm3Ug7WoXtN+tBjdu6mcU
   2aRGSgVbz/dCRojHIYvEgcDQNARQyZhRs6k2W1jsoZKRLgOJMFK3Arg5z
   jG7okiEy2r4Ote8O75YUAD2U/0qtyBs7wOIBfx7Z0jvS9hgV5G2Z4TxY6
   IvOTB+wEl3W6Og476/SSlkLMDg2Zsw4CYKlTGZlSE4DjlhC68fSPIcdK6
   25rK8sgQoTSUHs8tQVNgDtCoXxj5AgslgiflO5UnZisp884Gwkf7FgsF/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="308220331"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="308220331"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="958545369"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="958545369"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2022 14:46:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:46:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:46:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:46:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uh8N3rgQucKhM6tUes1rZxzpiU7eQM52uoT2T4xaJvR7k2YkeaISEYoJ5cSCelDB1tSpo46P6miqsUdzkVL5oKa5HIelKsAHwYX6I4eWwRosCuMGSGuMC+4DQfnQXFia21i/gkLV7N6RxxUHfsBLhmGlBVwEOaiFEgoCWTj10C4xpVzbGp64jvrG875yhXDp1okH1utlK8WHtT68Y5mS377T9gXdmcdJVs/cZSXxlzKXFjmf/R6aeLTRWAcJRwHDRBsv3mHrbazlvB4ClkbQSVOw0Gv4ghu3DLia2ZqPJB9Iuq3Vpr+A5db+jYe2bfq5ij0Mo2rzNhhHHA13295p1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fAG2+MVXGX13zjEFFCV6ZhfsJV3uUk04+S1YKetrtw=;
 b=GhsvzBSKZ04aTyKJlIAEdCwoTUOSYePDa/uTxieCS4itkEKVsWjQatew2DX6C9143FpTq/qfltwe7jh5ySM54jOFXmLQk8A/Cb0G0R1tjPydBlz8GD/rC0VwnkJtg5FZ34PHtWOvbesfjwrboIc3RGaU9RDK9MnuHEsp6F9KjbbOxaZxdo07GM5SJa2wxB16Fto0hF/qMXAPIspi+35+uJbPS9mAFbiQuz50kTgXaZpyoq5xr3nXt28S2oXDCCAcYFWwYTvDUdHVjjNdW9uM8qvrG1/pGoFvTpmO4zHq0XOmhYDDx8oy60bRl3dvFGk8Uyq4PUbgDbauGGvnSEhTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6724.namprd11.prod.outlook.com (2603:10b6:510:1b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 21:46:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:46:13 +0000
Message-ID: <d3ef5be8-6fcb-3fe3-97f1-c0b8321230f4@intel.com>
Date:   Wed, 19 Oct 2022 14:46:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 08/13] genetlink: inline genl_get_cmd()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0145.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 30286e9c-a0f1-4932-ee63-08dab21b5787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZruvhm8TL7rYGtfZmvygxTXj4xV7wYwSX4X+7xupTDI2nxBM4+6hHbKV2ZBzco2QMulWvUZkI6V8dZBFSdFOpkkvzCVhk1uif+6X1SriKLJn0la4tap0T+0M+lMig+doRKdHUmmNfOZxN84T2YUaj/sNTo9yODv0WNQFFPbbLSIhYL78McF6yJv7Lj8lsMR8mUrEvqoZFq/qSBszSlnaWjVVtVOBcx1yUkJm5ANiKFYkw8fr5GChLGzYz4nGW8agx5EPY3POy3S31e+QbNgLduopOrXpKkP4UvXwIhvM0cxKlEvHzBx9NZDyXF24954yhI1E5DUk2vWJGVaJj1hfhMqqMNz803VTa0rP7AHLc6MzKEcyv57buj81GfOE40qs0nwSgEzHN/2fDaOCyngSnRHYKIZDGxlHDUK0dpKLo79PEHHCvwWsO12z6pAVslJOPfKB4DJQAXahuGwfwiCsfUrjlDHE611n2hdWbyais0v9/3016MVBCkPhZGe+H395DFkc/9ObYDt3Nu7AYePDykSzREdtzI0njqEsTUTW1ZCsSm7Cn4j2+0svNu89P4GYQWoZUFrYNBi8JbguanyTzNwAu918DoaIGw8KR/MxYyRYDnoQE5rkoWxicCw3dDuxx+gi0KgOLK36/aMbCigQuG9huPthwXS2f/tQNXu9713V7v9RBOi0g6NsNKaPE+wLilPFH2j9AT5mSM7nEzBT6SuXNsniaNrpBufeeLojvmKaIrUELLK2O6IFIAUWwiqplPoZnlxm/itPCFZvbsf+aE4+4O33E/L5vMTM46pGRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(31696002)(86362001)(36756003)(31686004)(82960400001)(38100700002)(2906002)(83380400001)(7416002)(5660300002)(53546011)(6506007)(26005)(6666004)(6512007)(2616005)(186003)(6486002)(316002)(478600001)(66556008)(66946007)(8676002)(4326008)(41300700001)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ak92MFZTU04zNVZ1L29sVXZISHFFOEdkSzRmRGgyZ0pEUGtjT2Q2QkhSWWZx?=
 =?utf-8?B?bFpDVjY2S09WZk5QZ3NtZlJ6enBuL1BCRHYxSTYzY0Jud2dtbmVTZTY1NEpn?=
 =?utf-8?B?RFlCU3g1RE5xU012NGEveW1wUW1rWlNJWVVrNWpvaGRTTGxrQkhHcEFwOUJa?=
 =?utf-8?B?ZkdWSGV0ZW1Qdlp5bGx3NGZWTDE1L21VRzNIU1lSMFlvT2JRUXNoOVJpQk9r?=
 =?utf-8?B?ZDEvS2FCZjRndFlIaUcrOE5wckxZaSt3ckpBK0djQ05nZmxDMTBzVStrNGMx?=
 =?utf-8?B?ZDVMb3lDdTNjRFJRUXVVKzhNRVRmNFhDekgwb3Y2MlN1UDliL2dvSXdOZGsx?=
 =?utf-8?B?M3RpUVNKNFlOTG5XalRRbWszTnA4bVI0amFXT3pEeEcvV1ZSQ0RCK3BMdzBt?=
 =?utf-8?B?elI4SVppTVJwMlZoYWZXaDNPMzdPOEJHcVViU1Niei83bmVjTVJ5TDBPY2E3?=
 =?utf-8?B?clY1Zm1pNlQyUnlHYjhvMklVNzJzN2Y3K2NiWHFRZ1ZZdm53VDh6OFBlWXFJ?=
 =?utf-8?B?Q3ZGZXVJcldBUVBySTB6UUVDZjYyc25xZU8zY2R1M2kzNFZUS0NPb0xzc0l3?=
 =?utf-8?B?Wmk3aFJBNUc3WkFBSEJrVDRHYWk1TDFCUDdjQlVCdmJXaFliSTFTSXpERU1I?=
 =?utf-8?B?MEZPbGdkaU5JT0RaSmgwYWpBTVB5T1pKenl3VjAxcWxSN291NUxJUFpCSDBp?=
 =?utf-8?B?UnRobjdidkxLcWd6eXFtbWNpdzZLU01yODZWRWg2aWtHdW5RVHpFWFEvTGxy?=
 =?utf-8?B?ME94ZEV2cGI0SlBXaW85eXpJSHpmRmp5QU5BUjRXalBNb01HcFhIQUErYmc3?=
 =?utf-8?B?UG9iSHl2enNNbkdCTlhLOXRvRUhwQklhd0JmSHc2L1d0cTdoTVd2czVST29k?=
 =?utf-8?B?R3JzaFZGTzYvUFZYZHA5SVJhVDBXL1gwZ1dQeU9QaUwvZEtkUlY2WW9UWmw3?=
 =?utf-8?B?YzhYS1JleEtGbmQ3MmFTSmxqQjhsdnlTS3BQUUU1enR0VGx0UEZ3SFpQcHlH?=
 =?utf-8?B?QkxmMXE5VGJkM2JRcDFEYXNzcS90NUpjZEpoQThGTTNnZGRZTWN4Z3B6YWox?=
 =?utf-8?B?NzRQYmlLL3F2VkhTZjg5SlFtdDJSNXFMYWtYeVVUSnVYZnN6VkxuY2NpOUFP?=
 =?utf-8?B?bTI5aDg1RFcvQ0p5WFA3M1kvYkdaUVNOS0Z2M0tDaG5UYjJBWUo2aEZ6UldK?=
 =?utf-8?B?ZFFSN1hMWktLS2FVSUdQNm9OQ1E5QkpoaWFLL2xManVnWnk3NGdaL2ZNTnR1?=
 =?utf-8?B?WmtWRDRpNHg1dGp5YkFjbGJvVnVvc1VHaFFqVW5vSjFHNTZETWprOVF6U0lS?=
 =?utf-8?B?c25tOE5mN2g1YkE3Qkl2Mml0eXUzblpZcTUrTFdCeFBmTWRVUXVwNU0yZWY2?=
 =?utf-8?B?K0VoeXpHQlJtSWZNd0FJT3pQOVR4dmZUbzJTUzgxV1MybTdsVjZkOVN5dmxw?=
 =?utf-8?B?NWRCNUk3VytCclk5REVWeVJINlRST1BPTS8vZDJFSG5GTXJpN1hsU1IvQ0V3?=
 =?utf-8?B?emNCQnljazJBTnBPbWt4VWpVeUFRcUdZN2loYlpPR1d4c0pkTjRwZENJa205?=
 =?utf-8?B?eGh5YjE3NE1Rb0pEQTlES0xPeHNub3JXbkR4cGQ1cTFlaEJWc0tRVXhtaXRU?=
 =?utf-8?B?RzE2N3lvY29MUlNZV0U3aFdGdG5IRUZqb0QwRUtCazFYZXg3NG1OYUNuWEhk?=
 =?utf-8?B?SnA4VEFHWUsya1JhelQ0ejI0NUQwL1VPVGVrR0RZNyt5M1hMNG15N3NmbkdI?=
 =?utf-8?B?M25TdjkxWUpRWWtXS3pGT2d0T1Nob3QzMm56Q0h0UDBsMktiTDlaSC9hcFUv?=
 =?utf-8?B?UFpQQ2VsVEc1NkhMeHFWK2FtT29FM21mZENKSzUxb2N6STBvRTJDVTBKUFFp?=
 =?utf-8?B?TWxnZHR1NzZ3T24wTkpkV2gvSlRxME9uYUUzWGEweG1heXFlMkxldWRnNHdw?=
 =?utf-8?B?QUU5QXBFVmFDTkhFOEpwMVpYaHI5ZC9ENmdxZXN1V0d2WThTV3JVOGlzODVw?=
 =?utf-8?B?d1hXZk9FVldKWEFESi9YdUZLRGFVQVVNb2lHMVl2Qlp1M3NjTDZlYU5rVzF0?=
 =?utf-8?B?Wm0vSEJyMXNDaUltVWRiWXFUNXJLSlVSR3JVdlVJRUJzcE43Vkt6dThoc3JY?=
 =?utf-8?B?bVNHcXltUjFQSGt3WTl6UEhueGNKUUJBeUpZMnoxTTQ5YkRHaTQvbW92NEJG?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30286e9c-a0f1-4932-ee63-08dab21b5787
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:46:12.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKdZ3MIgFQZ0pM2VwhWWeObmkkBXkpi4LMn06btqtQ2Sk+SOF+/NJUItKMcv4Xxb/tkDpBMg3J59yLw0OM8YeNsskA6V0pQDrxbrKCVCbCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6724
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 4:07 PM, Jakub Kicinski wrote:
> All callers go via genl_get_cmd_split() now,
> so merge genl_get_cmd() into it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Ah nice. A lot of the time I would see code like this where the first
refactor and this merge were just done as a single thing. (it is easier
to manage but much harder to review). Thanks for keeping it split out.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  net/netlink/genetlink.c | 30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 3e821c346577..9bfb110053c7 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -158,14 +158,6 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
>  	return -ENOENT;
>  }
>  
> -static int genl_get_cmd(u32 cmd, const struct genl_family *family,
> -			struct genl_ops *op)
> -{
> -	if (!genl_get_cmd_full(cmd, family, op))
> -		return 0;
> -	return genl_get_cmd_small(cmd, family, op);
> -}
> -
>  static int
>  genl_cmd_full_to_split(struct genl_split_ops *op,
>  		       const struct genl_family *family,
> @@ -207,13 +199,15 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
>  }
>  
>  static int
> -genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
> -		   struct genl_split_ops *op)
> +genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
> +	     struct genl_split_ops *op)
>  {
>  	struct genl_ops full;
>  	int err;
>  
> -	err = genl_get_cmd(cmd, family, &full);
> +	err = genl_get_cmd_full(cmd, family, &full);
> +	if (err == -ENOENT)
> +		err = genl_get_cmd_small(cmd, family, &full);
>  	if (err) {
>  		memset(op, 0, sizeof(*op));
>  		return err;
> @@ -841,7 +835,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
>  
>  	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
>  		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;

Ahhh this is where the GENL_CMD_CAP_DUMP vs GENL_CMD_CAP_DO is kept
separate. Either NLM_F_DUMP is set or not set so only one of these flags
will be set. Ok.

> -	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
> +	if (genl_get_cmd(hdr->cmd, flags, family, &op))
>  		return -EOPNOTSUPP;
>  
>  	if ((op.flags & GENL_ADMIN_PERM) &&
> @@ -1239,8 +1233,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  		ctx->single_op = true;
>  		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
>  
> -		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> -		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
> +		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> +		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
>  			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
>  			return -ENOENT;
>  		}
> @@ -1380,10 +1374,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  		struct genl_ops op;
>  
>  		if (ctx->single_op) {
> -			if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO,
> -					       ctx->rt, &doit) &&
> -			    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP,
> -					       ctx->rt, &dumpit)) {
> +			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
> +					 ctx->rt, &doit) &&
> +			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> +					 ctx->rt, &dumpit)) {
>  				WARN_ON(1);
>  				return -ENOENT;
>  			}
