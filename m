Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748AD699B48
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBPRaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBPRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:30:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36AB4D600
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676568620; x=1708104620;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L08jSgyRv+RdXG94zNe4o5eN+qUac4s6WGnRNlUMIJM=;
  b=GFk8O8Y+i4Lsfd9faN8e09S/qDbAsRTq1mzj9TIyjRNE2fwKxCUF3tZw
   Ob3vgI9JsSWb1o8P7fMMMURIP/2Yk+5n9GREDr9t6roRah27K7KQqSjSi
   0smhgtDNH4BcHm7WZkY3ITsdAJ4SdaYdvpKkrAWeS/epYNZ4UGCmNL2Cv
   S1nYwJBchteg2uhzgbMAoupsESzLNb+Rqya4fKga/kpRARaR4IH5cqjhx
   TEGvokhWA+C0YfvV/vOHu1Gc5MPHbu1kOjFdTaL+uVpJDQruVU4usMjs6
   JlPktoy3umpkAvs2OUmhO2rn8vgLsSWagLeP5XA0JlC0DzakpdpASk1f7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333129912"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333129912"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 09:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672267318"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="672267318"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 09:27:51 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:27:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 09:27:50 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 09:27:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn6t+R54jpkHc3L02S/gLfs3kqK+35Jrya3sDKIkqfFpl4YC9ESIDvOED59OehsLSg2zlEJ+EBGz1HsgManLRDNGASkUdZLqfin72ZBBb4/Wym/w4F8KkDdw4Jnea6wEaIkDdTrhYi7XUTpDKAe3feDiIbOMxZ+eZfhF8YySTP3wWlH/ezmU5G7RJ9MGW4zrzNxUJ9dzvxFXF1uzEUuTLcItIETtDJLfSeO4n7ADBQ6rl4PuiC8XLOct6E41+12J0NPobHTETJvyMY2Pi5rITZbegJEUvF6B/VSqKIwexnBxEzgR5yAt5n1E5XFzaj1BB6gWHXTP+ZJuzIQLgl2yHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up5pKge2t6lvxcwEy6e4YNBi6RTJEmGcxvMBPWxfCgc=;
 b=TTEygvaU/H7ObED7f27soJYdJCiETgg5MN1xY5WxVVYHhEQPVGz7By1CVGHhDHZS3O6gkTd2SyNMir43W9zoKufNPMwWYjewKu6EVbpMC6e1M0uX9DBThFWZD5SFGBHEy4a0XWR1+sPt0WcgAZWKP0rZGKRVpg665zFs/GOtBWM/LRSR0rp0iN/nu61aYvlymyoret+hhxOtG6L4Qsd1oN1RHHVzGofJ1yGa5eZZrAW14EXabbFWtDTy00XYlu2hRyPUV5LGlpbniQ7PeOkbJLdeYsIJpytDEBD1SoEh/WCy4thGwsvCw5ZKrki0uv4gLmINzAaAZMO8WATgDBTScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB7096.namprd11.prod.outlook.com (2603:10b6:510:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Thu, 16 Feb
 2023 17:27:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 17:27:48 +0000
Message-ID: <07a89ee6-2886-65b8-d2cb-ca154f1f1f4f@intel.com>
Date:   Thu, 16 Feb 2023 18:26:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [net-next 1/9] net/mlx5e: Switch to using napi_build_skb()
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-2-saeed@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230216000918.235103-2-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f51bc5f-d211-4f94-90b5-08db10431f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Nk0nw1uiYuliFyOrrCgAx4fuZS/l/2lLukDcZBDEyiXogmRRG/5J/fCKkHZ7OEKFn0049VbJaKuKkibHa4XK3thL8FgPRVBEwIsPQxeZmoX0VoDz7dFEZRN3IYn/uCOCZqnfdejni5hkz/iYvLhc5rIVEXjJ30PeKN4/Wwocrwo0s16Ht1c1IFg+L/L7cov/9jws5ExbykSNgwqZxp7U18t1p4EvxVMtl7BDxTTkLLsB4Zy2bq/VwPHbRcwIIhVh98GKBvi2ulUgjvzzYZGdLcpy3crtrkp6ywWsfJRTZaDGyFnLnFdQZVxFXTnFndtDCu3IytZc1CLoU02L4m+lJs9VjPZSfcYIH3dbGt+1XMs0MoPekouYzabcF07QwTC2huo+K+Tr5pR9xXaEfSe9TwX4JUk5LVMM+DS2xIemRCgBAWRVPJmYhmB8dntYLwFcQtYUZyIT3Nea5Z3j9D1acgY9OczAPYuZ4q2Az9koPjfsmL5anHN0k7sQopMy+4zBDYgjutO8cJXg7yf5Fj5tzcFqnWFNDTXI+m5ysl2m7UMFyB3+miNHqnjl0qZJ8AbuO2hi9Tw6p2krHy9YcrCLhIPFRSYAuwpLvVR/BZEm+QmuQ3X7vbl0NYg1g1ymV7Jl73AH+lOsU05fWY4iba5ExOLwwBsYjW0aVDH2u6RbS/k6TEIif7Z8W+IEe7G70CE2Dy1d72pLl4ClQK+y3Lw/iTxbUg2yvGvG/PQWSmuuLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199018)(41300700001)(8936002)(36756003)(6916009)(2906002)(38100700002)(5660300002)(82960400001)(186003)(6506007)(478600001)(31696002)(31686004)(83380400001)(86362001)(8676002)(6512007)(26005)(6486002)(4326008)(66476007)(66556008)(6666004)(66946007)(54906003)(316002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzRhak5jSEhmcTRqR1FCSSswOVlvZHg0MVdLdCtWRCs4allKSmNDdGVvcXJm?=
 =?utf-8?B?b3cydU1XOEtxV29RczlRMEhQc1NaQ2xiY1NOaG9oQk5BdXdzQVYxTTltdW01?=
 =?utf-8?B?aDNPNmNQZExSMGRLK2VTVG1xYW5OeW5RaU05bTAyOFZPRWFwTkFTS2ptZHhi?=
 =?utf-8?B?WHhjMEpldGZnRzh2ZDI0bkFwdlQzVlg1VGNxK3lkZ3ZET3BaMk9lenlLUk1m?=
 =?utf-8?B?bmp2THNST0RlNU5vRWRhNTFpQlVtTnNCcitTMEZPWTZqTERtQjRqblVZenY2?=
 =?utf-8?B?Q05TTDMxdFJEb0ZHdFJJSG10MC9DOElpZmtrTGpVOXlEcUg1a3ZWU2Y4bk5w?=
 =?utf-8?B?NHNSSUprZnlGNTBVVWRnSWR4RmJOZ3QwVStSYm9peFdpclZUbkkxK0lteSt5?=
 =?utf-8?B?TUMwZXc5clExSE1CbmRkTVlkeUNQd3JmNXpUY0ZsODl0dU5sS2M4T0ZLNWlZ?=
 =?utf-8?B?UjdzcDhQVStCbTZLM3hqb3R4SVZGM2xUQ1VnQ0RLZnZBRWdBSFVhYWlVN0JO?=
 =?utf-8?B?VTlELzBHYklsQXBERno1RkNndUJ6dGVwalVFRVYzWHUrNzZFZzhSUEd3WXg3?=
 =?utf-8?B?bDJKVEgrTmJpOFZqeUdYZS9hejlTbTV2YlN0c09wRFhQOXUwSHJJd1hCUmNW?=
 =?utf-8?B?SFpIc1hyb2dTYWhmYWtMaWMzalRIU2k4ZHMzNGI1bk1iQlBHN3FFMVRUUU85?=
 =?utf-8?B?UVljbnVPeG5sb1JDTEpGdFFTUlBhbTBtb1dzeVJ5cWg3eDRrV2xLdmJCT2dk?=
 =?utf-8?B?MmtvMmVpTExTZ2NVb0xWS3JSbGV4Z3RhNGsrbWRMOFNnemcrN1k0UTJDRkZN?=
 =?utf-8?B?SGl1YktrRHl6RzQ3NGgrTm9UV09Dc3ZKOHJwS1NqY2lRMHQ3bEw3cHVnL2xP?=
 =?utf-8?B?b2QrVzhPT1YyMkc1emtHcUdiRytrRGsxdTg0REtITGRFbGJ5NEsrOHZtWFZG?=
 =?utf-8?B?UURWRHNURVhlQ1N1dkRkRnhJRTRKOXdGUUJXSTh2S3VvSnp3bE5qRXpUNTlr?=
 =?utf-8?B?eDJiRXo3akdqUTh4L0FWdCt0RGhOMXYzWmNBekdrSm4vZHJFOUdscjJvVEoy?=
 =?utf-8?B?MlFKMy9HTFl3ZlJjbGp2bHp2T1ZLWE9QQ3hReXBQTVczbEdKMEtVQ2tGaU1h?=
 =?utf-8?B?ZUk3K2M0dFFBNGhBUTFJNzVLTWFjMmFuVGVmc1hNR255NGFsN3l0WCtuM0ZN?=
 =?utf-8?B?K3E1MmJocmxtdXVkTXRyMHdjdmt6MzgybDFtcklRSUFjbVF3ZHVUZlFibHJH?=
 =?utf-8?B?WDJKTThTdEF2VGRzOWd4YTJZTnA0cXhrMll4REhaR1h4R0poN2RkQmFKblh4?=
 =?utf-8?B?RE5JUmlhdytZa2tCU0pxNGIybmp0MUNkSjR5TGRGSHNUMUVhT3hPVSs4eVFs?=
 =?utf-8?B?YkhYR09JRXZzdlhXVTNWejVwQWR2NU5DRVdKMm9OdDNwaUIxREkwaForYUpV?=
 =?utf-8?B?SUlDR0lCcUFsa3RKVy93cDFwd2ExanRCQzFzdWlseUIweC9WbUd6N0gxVjBh?=
 =?utf-8?B?MlVENnBabVRlSnRON3ZKcHFLVWk1RW9KOFVFNnpaUTBReGdZSEZON2wxREwx?=
 =?utf-8?B?Sm5hbDEyUUQ5VDluUmRMSVF1dkd3RVRuWEc4VEdrRStVK1VuRGtHYW9naDkz?=
 =?utf-8?B?YmVsZEd0WlpJN0FNaU1uQ0hRNU5sVkM0aVZxRVkyRXVsdnY4TmlBeGRSUFRy?=
 =?utf-8?B?T2JxaGN0OEE3QzgwaThsMS9XM0swbTcxcjNJTjJsUmRlNXFoSnc5Zm5OQURh?=
 =?utf-8?B?YnhMcnZSTUJlVWN1RlByY2xsQ3FlTk5aUU5iZFgvdElkRklTV09hREdNUVZr?=
 =?utf-8?B?NktSU25HTTVjcTBmMzdQV0haL0NkRDUvQXNTamZhTmJXZWhsOUh3S0duUzdP?=
 =?utf-8?B?RDFPaEthWS9ERFp5Q3Z0M2VybDQ3bmFTWUZGUE5XQnJFcCtLakZnSkVUbW9S?=
 =?utf-8?B?REJpQ1hHZEpmVVdFY2VqWHdycVpOT01wZHk5RGpFUE5ZT3JHa0lJNFVRbUFz?=
 =?utf-8?B?SnB4cXNRUTYrRWNWTG5EajdYSmgwVUdaZllKVHFXYWpyMkVzbHdQSktWbWE5?=
 =?utf-8?B?K3ByZGhtbEhXamFtSDd2ZzduM2lsL1BMZHd3NFVzVHRVOGprN245ZHluMU1H?=
 =?utf-8?B?TTUxbGVsRG1IZ0thQ0NCWGFDb0d1VnIvbVJBOW5wT2tTQms1UTlPZ2Z4emsv?=
 =?utf-8?Q?Z0HFwwiBfW9wf3T59zYqmnc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f51bc5f-d211-4f94-90b5-08db10431f79
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 17:27:48.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPDeW2VKAT9nzXq7pVAZGq0YeqalpJZfW63EtLxp49Qze3Xhahi9GxH/6ZtrStDHQ0eZJUO2pssrXlAUnzid5AfeiXxqpeUHLGJOf73nvfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7096
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Wed, 15 Feb 2023 16:09:10 -0800

> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Use napi_build_skb() which uses NAPI percpu caches to obtain
> skbuff_head instead of inplace allocation.
> 
> napi_build_skb() calls napi_skb_cache_get(), which returns a cached
> skb, or allocates a bulk of NAPI_SKB_CACHE_BULK (16) if cache is empty.
> 
> Performance test:
> TCP single stream, single ring, single core, default MTU (1500B).
> 
> Before: 26.5 Gbits/sec
> After:  30.1 Gbits/sec (+13.6%)

+14%, gosh! Happy to see more and more vendors switching to it, someone
told me back then we have so fast RAM nowadays that it won't make any
sense to directly recycle kmem-cached objects. Maybe it's fast, but
seems like not *so* fast :D

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index a9473a51edc1..9ac2c7778b5b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1556,7 +1556,7 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
>  				       u32 frag_size, u16 headroom,
>  				       u32 cqe_bcnt, u32 metasize)
>  {
> -	struct sk_buff *skb = build_skb(va, frag_size);
> +	struct sk_buff *skb = napi_build_skb(va, frag_size);
>  
>  	if (unlikely(!skb)) {
>  		rq->stats->buff_alloc_err++;
Thanks,
Olek
