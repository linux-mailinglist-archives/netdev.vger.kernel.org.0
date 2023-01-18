Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D89672ACA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjARVqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjARVqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:46:03 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B23810CC
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078362; x=1705614362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rHGO4kZL12n3exJQpaBCQdxFyUAjaR2CajSxVbC3kZ4=;
  b=CkTNrwoQKet8M8EvaLQ3DRDTlC6VSURl0bCDN48bcZ6wO3KwCtEItSe/
   ReYAXnDuS3ScdhCWzzeI8tVHB61B1FJxtCWVZIWTJsEgOnOXYDTNWpH2E
   wetU0gfMn16DmV+E11RMZaOYz0d2wJ3ujyoIv1iOSDveK719Uw7o7M/+q
   sJq43ktz5Maww3RJBDTeKd3KNBXMe9L5W51695PDs+WKt2VWbYG2BgIqu
   HMOS38lWbjkxZcm/JZftYKaxWrwjArEds5FmAMlxCa7f0g9VZAjSgHItk
   7RT6rBY3faXIg434B7G0nvCfj2re1jRaFRCc2nSgBAV1OkLqcH8R3RYgu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387461292"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387461292"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:46:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="748640328"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="748640328"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 13:46:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:46:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:46:00 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:46:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/zAygmCokZDKCkpHUXmn7BESSR8T5SMGx57FY9GBnZO5uRRvJcsilktWUxhJuMajY1qAR+OXyOj4B2hrDYKaOUCN0hSa5Od8LIiRPhPhhq5XWP7PwXZIaLasKAgIV38oDzB+voSDcyyAQy2Z52IN5TEL7fxznZE8svmZKN0XACHy0HnlkzH7akAfP3V+98Iv2szzxYZk4qv619xfF3G+hYcRg9VPYopGo/OwNfaa3GOk1Wau2OYBEh6+eQqhTh+YTwWvAkma5j+jWkjVaP4L3co8K37q/Snwrru00fhQNrPl5ZPPVH5lbcaUAR/Ynuh3PYj8nwiJaXIYZ40at+8gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=089lmd7ce/JRElTzadCqUyPWI3sISaH2ZxBYX9AcFfU=;
 b=IvjOT139NNCn9EPVtFLp+E1IFbFEECBeNDwPq1HW4lWI3rgQAgWVI8AcIbImBEc79Czo4yP3e8fcBhSbcMb1LlSnKOwYk3JAFvG+SS0InauF0DfKc2XUMUjF6T9rImREZXeSqcdHct52PhBReX79ZW5AM9922KE5VRxJdJ3hIZgzZN7lZB/u42PnJ0ZTV1JxKIrNZWV6b9lPk8zwo8omZztR51DgwqmEhc6EQ0SwqAJNX4gGcWB+4brYbPnQNl4t0XqgQpvaCld+Ig5LPq38fyhHLM36UFb3qO6HNVNAHJYIPhY5NZcMp+7aYJWtEY30c/2LLNf5dcw62dQy3oxgpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6061.namprd11.prod.outlook.com (2603:10b6:8:74::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Wed, 18 Jan 2023 21:45:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:45:58 +0000
Message-ID: <1bf7054b-4c48-80a8-b23e-967bd984c750@intel.com>
Date:   Wed, 18 Jan 2023 13:45:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 11/15] net/mlx5e: Warn when destroying mod hdr hash
 table that is not empty
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-12-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-12-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0062.namprd08.prod.outlook.com
 (2603:10b6:a03:117::39) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 73e359ad-2272-4f26-f23f-08daf99d6289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xd35IHkJkjfdDYQlJGjSQTXjczEn6459oSJIvC5VUVDKE3t4HGzga30xlqrWtTD0tQerIlbPBhKYDWuU6wybWsNFitrtAMMy8q9GBrjb+yHKZNa2D9g0xxSjkSoVrvIou+AmVcNrigoA4uMQ+12S+q8zIdIxhcgWoZzzzuBFS8TM81SiAotpMLwEXr0O94VFUGl2V7vBHzasbZxMkVYzSoQWJEl0sQIvEUp3xVa4fZrYTtLTIH1t4RoaglLGPdkTMYQqluBfOieH1RRZ37AYJppSpNoCnqshk3+3o2x/FRl5SDZDlba7/kmDSdHK9uXdhUpLWIzU+wt5Y9nJpt1xZNOYFrhOURgZfp3k3UTM1ANXayFuTXhQIB7VN+y4OAdtAV+YoeXDKBXdilTieJi4TLtyKjxfw3Vecotai0J95h2JqpyJbN5iAmQrC/HkmmA25LnT5lWBzjC6t7atEjYQWi9kE0Gc0POsVwN7GXvUoY4A69QhT5vnsltlreozGPrS7fBSNAi86UpHhdDtjETTftBiiaip9UiwQczjB6tB5hmasmiI3tdvSnrjvTM9CeSCsgdNgMSBS0AuuN51pRabm91v9gcihmyB/ePa6pVN2jN2TSxQpz3IEHD4w5/TXLbW54kNmXXifgpkrG0jJDlNDmTZWgSpT0xVre+RqiPq7Hi0pfH1hhP+2Y6KlQTE0naIeDhVWf+WukiErpSrYeE+452pMg3M5fYGIHH9P9YaMAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(31686004)(36756003)(4326008)(2906002)(66556008)(66476007)(8676002)(66946007)(8936002)(7416002)(5660300002)(38100700002)(82960400001)(83380400001)(31696002)(54906003)(110136005)(478600001)(86362001)(316002)(41300700001)(6512007)(53546011)(2616005)(6486002)(186003)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkowSHpjR0YvL3Bra1ljSG85Z0xLclhkb1ppNGV5M1RPc1EwWFlFc2lLMTd1?=
 =?utf-8?B?TjJkeURmb0pRM3hjNFFlRVl5eWE3eEZnUDFqb2NObHllYTBBN1BLN3d3YlBO?=
 =?utf-8?B?TjdGUmdJRzRwVlgxR3NFSFQxZ1VqRk1DZkd1NEZVR0YxOTgyZ3FYMXgxQkhy?=
 =?utf-8?B?UTROZHR1NE5zWjUzLzBma2Z5c2pNMHVPNE1GaWVlelB3STR5U0RoQXdGT1Zi?=
 =?utf-8?B?NloyS2ptQkUxTklOKzU0VWJ1Y2g4R0JxMlo5STdBS1NMcm9JdmZRUEs1clBV?=
 =?utf-8?B?dkJud2pQWWxSZVlCYUM3ZUUrNC93eVJpQnJ1azl2bDlGSE5GbEMxZlQvKzBs?=
 =?utf-8?B?MnRsMEEvZDlBU3ZkR2RzbWlnc3ZDaEhHaUprYllYVWpKclJmSldzcm0xV2di?=
 =?utf-8?B?T0ZtQUxiQzBBYVBlbzlOMjFqenFNbGJHNG5LV1JOSTJpdmJZZWdRLy8yNXRF?=
 =?utf-8?B?a25mSEFMZkhuOEx4QlVWZythVkNjOUo1ZDY3N3plU3pBeHBZYmc4My9wNy9C?=
 =?utf-8?B?YnJWQ1BHcjN2SXg1TURFVXhLNml3WDF4a1pLQWVESjJjNlp5RURLRU9GbEpr?=
 =?utf-8?B?ZG1IdmQwRnplNzZlUkVyYWFDaFZ3aTBPOHhzN3IyTUhUcFQ0MHRLU3liazdN?=
 =?utf-8?B?VmJtQk8yVzBRMXBtTmRmTlBCWTYzcHl1eVpKbzZSZU1kMWVYSzc1Y2ZWZitk?=
 =?utf-8?B?M2hIQWh2dmVJSnZNeUxEc3BRTkE1QTNmRXdIejM4ZGI4Nko0a1RlZHhaTWVs?=
 =?utf-8?B?TC9XZHVMck0rRVI4dm5oYjNlcnVjNzlVWnc0eUc1R2J3Um5jUW1GWGdLeHli?=
 =?utf-8?B?b1ViNmlrdXU5M1gwNkNWdC9zSnNYMDJySmEzRkJLaVBTT0dQbVFFaHQxcmxE?=
 =?utf-8?B?cWV6U0t5RUJhYy9VM24renVGSHpPTk1zUnMvL3djRUI1S1d2MWUxZUcwZ21T?=
 =?utf-8?B?aDFNSlNONlNBekdzNWJCOFlZUkEraTFkZThiejNNYkRkOFh5eG5TcVRJS2R0?=
 =?utf-8?B?WktJckZrdDJHMGdmKzRoZzBSTEhHVkx2d1BESnp5VjJMc25SY2QzajhIUG1R?=
 =?utf-8?B?dHJLaFNwYmpiV2NzVE5vSnFUTGFqT1NnZXBzT2NWQjFPaTlvd3lnNTdkV2xL?=
 =?utf-8?B?Q0dtQ3pYOTZqengzZ2E5dUJnTTI2VlB3dlhrQWM1dlFOZUtvK2pMeGxUdGYw?=
 =?utf-8?B?SnBmdGtCU3Vidk9EUzZhd05SbUhhWHZtcVFhakxSd1lma1p2NE1pTVMyMjdQ?=
 =?utf-8?B?a2F6S1RaTXEvTlg4ejlTd0hvRm5rTmJ3OGdYOS9XY3grWkdJNStVZVZRR2pM?=
 =?utf-8?B?N3Q5aXowdnRuNUpLdkVFemZWLzBqVjFReXJJcy84MFl5cVM0SGs1NGRsT0hW?=
 =?utf-8?B?R2xBcDBOY1Z0elIvQW04aEdSNW1JNlFFMUZEZXQxbXp4UDV5N0VEYit3WTNz?=
 =?utf-8?B?UWZXamRSc0J5ZG1ZSmhQaDJBWkM0RklJVzlYeFA1UnVxTEpOa2R6R3hPK3ZV?=
 =?utf-8?B?aDJETGVjVUZaYWQrc0U1ZkVxY05MeEdhd0lybVdvTTBTY1oxZ2FickNMM0pn?=
 =?utf-8?B?cXNqZENhVVVQb3pEYjlRTUovQWVhdStGWHpwOWtJTHhJVVIrK2M5NHYvV0t2?=
 =?utf-8?B?b2Znc3VKaUFrV2Z3STk4enp1ZjY0NXVFSmFGRzFDcmRSUjJtZHJjcDQwSUNL?=
 =?utf-8?B?ZVEydXR6UUU4dHo4TmhyOWNOMWlhUE04Sk9xTnZkNzdVbVVmS3gzdkt1UW5k?=
 =?utf-8?B?b3ZFemFlczB0TGlmZkI1NndBMENVditpS0FvZ0s1OTJYS01OeWR4YmU3MGJQ?=
 =?utf-8?B?Nng0RytqQjJPaGVuWnNidmxoY2VON2p6Mng3cm5OU0lCS3MyV3JPVWk3T0tw?=
 =?utf-8?B?UmwzQWxaYTBqS0dESU8zWVdJRk5COU9YS1A1aXk4dS9OY3NSUVNxbzdpTWJV?=
 =?utf-8?B?Y05qd3ljL3RUUkU4TGFvWVFCK1BsQlNpb0ZQRzIxVjkvdkVaV0RObFB2UlBr?=
 =?utf-8?B?Z0JnaktKMWkzMi9la0tlU2dYbDZDZ0VZMVFnZDRIMjBxZWJJZFp6RGxqMC9z?=
 =?utf-8?B?VFdUOFhHb0tqK0huVjdJSWZhU1BaY3EzWGs0YWU1SUVmc1Z3cDY4WmVjamMw?=
 =?utf-8?B?N1RQcWhhU1ppSHgzYWhoa2NUcURWbDFNTXViaDZSSGlidCs1VngwcHMwZVpO?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e359ad-2272-4f26-f23f-08daf99d6289
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:45:58.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgEefbQp681L/7IqKn57pG0jaYjCrbdNpohAAgV66vwfNlxMEPCTVOHOp93F/xy7OuLJ8TvvHozE/DdfXTNxs19Bgs0mlmQcwQUXKuPuY9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6061
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



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> To avoid memory leaks add a warn when destroying mod hdr hash table
> but the hash table is not empty.
> 

Strictly this is to help catch a memory leak, as the WARN_ON itself
doesn't prevent any leaking.. It does make it much easier to spot though.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
> index 17325c5d6516..cf60f0a3ff23 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
> @@ -47,6 +47,7 @@ void mlx5e_mod_hdr_tbl_init(struct mod_hdr_tbl *tbl)
>  
>  void mlx5e_mod_hdr_tbl_destroy(struct mod_hdr_tbl *tbl)
>  {
> +	WARN_ON(!hash_empty(tbl->hlist));
>  	mutex_destroy(&tbl->lock);
>  }
>  
