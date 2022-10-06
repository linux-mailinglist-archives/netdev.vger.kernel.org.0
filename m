Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EE95F5D96
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 02:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJFARR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 20:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJFARP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 20:17:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048DB4B980
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 17:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665015424; x=1696551424;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R+lW0TY45kgGN+GKO/yLTrwJXsBFNE5OoTZf0TFNc3M=;
  b=MX1PbyWxjC2Bu3dgdpsK18y+U+OWeSVQOkOWZpH2oehYCrvX0+3ul8/0
   jmUGXHaDTy9AUJrJ4SrogyLetlOpQ9NXgyH2i4WCKK/aEW22JEz4XP+Js
   GFIu9WF6AVyem9Xpaydr9ccjh7vDMojRDXYJpQvP65LeGjyr621LZv5+y
   dXFhOtQ6zDAJM9IqBOZKC6euk7bo9R8dvf3AvRP4yew/9n0l/gUSAYDwX
   tUTEeoJohigaPYU3vKBES8yjAl5AvK0As0cC0xw5jcVLojHDme9Ad+Dux
   Z4F441IVjXfxTbguquGCp31CmhVhRKYRpa6MXn6d04lB88R6xyo5BO1dB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="283674920"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="283674920"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 17:17:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="657717248"
X-IronPort-AV: E=Sophos;i="5.95,162,1661842800"; 
   d="scan'208";a="657717248"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 05 Oct 2022 17:17:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 17:17:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 17:17:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 17:17:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 17:17:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eq2Bg90qbdTtXnZ1h89qjNG95MKFrL+GJL7gsh5LmWQC99DU22cdV2ktyRC2sFPUirSWmgly7AMAgTkrhT78S0eC7HXFSf0IV2DsGq+OmrgwcSqDW1Y3J+BQXGBSCLnjMqpWovJZhjSYrLMC05k7gjU6qqyPef19bhpYAFBECKDolSo/jOCjEFQB94/PP01M/loXQ8K8LA9coyFhLha1dbXjjN5eCmTyxDCpROygGDkVd6rAfOOdv5XDhisiHZH4+YMXl8zDmGRbwRHgIc5+5bybGze84gN+04slYEk/JHCUVaJ+bWr2+ewEDB9+J9VVbtRlP0x2LZGeJrbWDqYsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7b8sefECkrMDECaTzzygDP5OC/kTyc+h2lNfA/x4zvg=;
 b=PN9dHMb9SaP2kDzbfjeqWU1YcIThxzwJ3gYPKaPj1QG0vmh+ru8Co57iao6uJMfWWYm4AMQpzVHdsQSMNCSY8eKkEZOMSqzg/A/86oye4kaqNN3yMh+dnVnuxTUTUz3tyLvQeL6Ht0gD8zBi2kclaaqabLApLOLo5IEAVnBVDNHcqvFJ+Pfwc8JgSGjJyTq0/274uZ4y1UzLNSsL9Ong5WZpIWgS6V3CWKJjhago6F3ixWJ+s4dPcGtSJpwRKIZ0nAbwd2/WVEi0SebzdHMBhpHcaKBQoj+HZ8uKkxcoj+S9ccPwuvJFJfX+kPCQ2pl55JrIES+G0uE5B4vgJLJRZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 00:17:00 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::65f0:bb9b:623e:49e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::65f0:bb9b:623e:49e%6]) with mapi id 15.20.5676.030; Thu, 6 Oct 2022
 00:17:00 +0000
Message-ID: <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
Date:   Wed, 5 Oct 2022 19:16:56 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <jesse.brandeburg@intel.com>,
        <maciej.fijalkowski@intel.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <1665004913-25656-3-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0056.prod.exchangelabs.com (2603:10b6:a03:94::33)
 To PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d483dc2-5b84-4f45-e158-08daa7301626
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TUdhgN5lkRBM2GWN8fPof5OlWGLx/afzbGi3NrPt6KPFYWO+xNeg8/hJR5ll8/sOS2FH7F193cEOx95rjTalEi+4yT0wN8KXTLErn9JFc90jYtRrqPGJzWZp3Mee/MHvJiPpPfH+KNEo8Oj1JFE1+A8bkoZbVhB6c3bZuD+q+mxpAFf0PmhhIu0nqw0hzu+NXOUjobqN3PftneVr46DiiE82dvoG2li8E4sk0w2Kj4RZc6WJEW4mTFSnXrMX2d9MUoa+SDFvbIM2mCkwIMsQiGxAjXM9CmQuW5f+aEVdTOc8fIS/FEF3xD/1pYpp9LxwDfidR5v+iNjPTI5xHf2Hha3rkb+ZQDlNE4tJuIkqDfry3xVKtfRzidkrGgqCJ6Zq3kOhewHpnmGMFlVm3aqR1q3stVSVulROIUp/DS21+18c2xVib9w2P3La7rjYFeb1/CdWY1oshi3rECQWrCHsNAclmgFBlSAi3c+TNBM+MUeGEcozxDUHLYgsJCc6x6Gm9tk88yzZmW2bqFLvthf2I0dMdwdLEidfcJXUsIOcF9tr8irpinVo7AM8A0Li2p/3oT4NWUlq56F2quY/t8ecyxhrSGQpVcOJWhiCxq4cJXsj+g9Os6RiulCzWp1TUFruRd0mHHodS5FzYIgwg2xeJaStQP3Rjs2xxMEz5zOMr2hUtpQGmPEnH8JoTUuFmuvyNkbE0xVRCV8J65YSNTkLXnxUFMl+om01Hty7jVnshqEyAnwh0OO4ZKfjfFWn6H1h7hWmyRBa1eiuUOdTY/Tk8ElptUDCeyjVgOVoN5NEP4GyG2c6xKVjfPiTCa7dAxL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(83380400001)(186003)(2616005)(82960400001)(38100700002)(5660300002)(2906002)(8936002)(4326008)(8676002)(41300700001)(66476007)(6486002)(478600001)(6666004)(107886003)(26005)(6512007)(6506007)(53546011)(316002)(66556008)(66946007)(31696002)(31686004)(36756003)(86362001)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUJVTjdILzRTMEVFVDQ2YXh1U1I3Qkt6cU9UZ0kzaHF4TkRkK21RNVQ2RWdn?=
 =?utf-8?B?ekpSOG9lQjdMTTcwV1VzaTVlNk45a0EzT2dzTUtvUjl2VXl2OVhIOCs3QmFS?=
 =?utf-8?B?MlByaDFqaCtTQVQ0bnd4RCtFdlJLb1pha2IwSTROc0dQOVkrUGZ0WGJ5Rm1S?=
 =?utf-8?B?V3k1K0NQak5PUDFvZTFHYmdzM3F1dS9rNzZnNlc5RkhPQm1IU3QrdlpoMjJ3?=
 =?utf-8?B?WWxCVUJjbWFLMWg0c1A1VThJSWxNQTh2R1hQKzNqTGVJZFk4M2ZDRklhOTVG?=
 =?utf-8?B?d0cyMkd1cFUrZEhmYjRoTEpmTjVrUzhCUlcvUExYOHNORW5OdkdWSE9jbm52?=
 =?utf-8?B?cVNsd3M4WS9FYlJ0N0N4NzFnamJ2bXBlVS9MaGJWdnd6eGtnc2VKeVVML2po?=
 =?utf-8?B?TnpNM05rVU9WTU5KSGpHdUppYjJBZ0dxdGt4Nk1GdUIvZFVYQjBOVFZoeHFs?=
 =?utf-8?B?YVJTRHhyUHNQR29CdUlOV2xkcEFjMHpvL3dmM2l4K1crT0VhT3FGMjZwRXpZ?=
 =?utf-8?B?QVVDZWo2RHA3UkpPaGR1ZjlxR0JxdW5sQ3hJWjFoTTJTRnM2dkY1NUQ4YWxs?=
 =?utf-8?B?TExtd3dLKzAyR2FPTitOcENHYjNqUjZ1WURYSkx0NlZrRFRGbTFiRm9VaUh6?=
 =?utf-8?B?OVBtbzZSVDRqcjA1d3g1blFhTnN4a0hTZ1hKWnkvZ3psSnFDMEhuSXhnanNZ?=
 =?utf-8?B?WTVybHhPNUE4UG5EYWt5RGpHcE5QRTJwQWprZ0pKSm9uQWMzU2toR2pxZU5B?=
 =?utf-8?B?KzdiRG9lYXZJQk12OVdDS01MWWYrKzlUR3F4T3NKYlFrbzVJZjFiV1h4Y2tY?=
 =?utf-8?B?dkpqelc4YmhmLzduRFJ1WHZwVUVOVnpBWEhiZXY3R3ltVW82T1lQZzY1bmhP?=
 =?utf-8?B?cXpTWHJRaFhQQ2xEdE50NXkwTC9HNTZzTkFmeXR2dW52N0VrR3N1TnorU1ZZ?=
 =?utf-8?B?WWNwdnlMRFBtYTNwaEZoMkphMmF5dWhhdnlQU2F4VzVlTGYvK2V0V1lqeHpI?=
 =?utf-8?B?RG5KU3VWZDdaU3g5aFNodDlseUhNS2FMK0xwOE9wNVovVUxPU1U5MjRHNndO?=
 =?utf-8?B?akZSZi9uSXlhTFpQTTVsTkQ3aTV0UDVsazluaXVTY3A3bHRCUXFqK2FjeFZJ?=
 =?utf-8?B?eEYzZEpoTEtSbS9HUTFHQUhhS1ZRMzVIcHVnS000cEdUeXNyQXFuVWt2YlR3?=
 =?utf-8?B?ZFY5U29DMWdzTVM0YW81NnNNNVBESVFKWTA3RkFxcTRVUStJSVZFanN3STVa?=
 =?utf-8?B?Zzg0RVh5YkhaNmczQWtqSTBnQkR5MDVLMUduS2QvSG1xQlJSc3hpS3hzUm9B?=
 =?utf-8?B?c052S3VBTXlTNmlucDhWdzZPaTQ4UnRwZ0NnTTcyR01jUEVwcDUvcjVoaGg5?=
 =?utf-8?B?aURIbEh2bW1iU2NMcXdHbnlmZk9oMUZVTWJxdjJFK3g3bS9CQ0syejRiVnVE?=
 =?utf-8?B?bjAydVV5QVp0R1VMZ2tDS3ZianQvY1pwZG5KdTJRNlhlMFBQVmlldG1MYUh6?=
 =?utf-8?B?SDUwaGFPSVh5d2cvUHVYb2tWN3hSYzNBQ2VPU0lQbkdXQ0JOTWowanBqd25l?=
 =?utf-8?B?T1BudzlHT1dxZDA2V2JDSHh3N2pwSVJZQXpHejhTTklqaVorc1JPakIxaXRR?=
 =?utf-8?B?a3ZNVDFEZ2NXSllNL0E0ZXNqeHlXbmExeWlETm1rcHRyaVhuWEhJeFJLYkhS?=
 =?utf-8?B?WUpMaHZORXRZRmJ3K2Z3eU5DZEFUTkpXcEJ1cEhqTVZuSmdZZXZHL29Md1kr?=
 =?utf-8?B?eHEwTVIzaml5TjdkLy9EcDcxQmR0RTB6ZXJJZjBiVWdlME1sbDBSaGlnZVZk?=
 =?utf-8?B?WjBGRVhZWWRhRFJBaGxOdk9TTDF1em9tSllKZFVENnVQOWh6QW8ycjRZaEtR?=
 =?utf-8?B?dXlkY2xLNkRRR0xoNWdmR0tDNGs2WVlJaVdjbE5OREFsanF1OVg4cTk5QXRn?=
 =?utf-8?B?Sjk5Qlk3azE2amRhcU1xSWd6bDhvQlZ5RHlqRU1Wb2krYXpoNEsxdEZIVUN2?=
 =?utf-8?B?NDVFM3hYTHRFSVZZUWtqcS9uN01qMVcySTdvc2hsanQ4b1JaLzhCdWx5WUJK?=
 =?utf-8?B?OGJuNy96ajFLV3NvWDRsS2t1ZUU1dGZPTEtPTFQzbGZZUkhNUkdwRVF4cVBV?=
 =?utf-8?B?a1hoRGp3QVZmWVFUc3BGOGpJL3FEOGpsQmsyaW1uZC9DUm9tRlNEd0pGejRB?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d483dc2-5b84-4f45-e158-08daa7301626
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 00:16:59.9980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwhJnCCQapvWwDeXmw5LDc1Di1zoz3s7++SFrMJEYXS2WnjmfZsGjKkB5TiUat3/dc2kXbL7ng70kbHf2GxvVLjbh7/t6BclJgNhFsWOe8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/2022 4:21 PM, Joe Damato wrote:
> Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
> the number TXs cleaned.
>
> Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
>
> Care has been taken to avoid changing the control flow of any functions
> involved.
>
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
>   drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
>   3 files changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index b97c95f..a2cc98e 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
>    * @vsi: the VSI we care about
>    * @tx_ring: Tx ring to clean
>    * @napi_budget: Used to determine if we are in netpoll
> + * @tx_cleaned: Out parameter set to the number of TXes cleaned
>    *
>    * Returns true if there's any budget left (e.g. the clean is finished)
>    **/
>   static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> -			      struct i40e_ring *tx_ring, int napi_budget)
> +			      struct i40e_ring *tx_ring, int napi_budget,
> +			      unsigned int *tx_cleaned)
>   {
>   	int i = tx_ring->next_to_clean;
>   	struct i40e_tx_buffer *tx_buf;
> @@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>   	i40e_arm_wb(tx_ring, vsi, budget);
>   
>   	if (ring_is_xdp(tx_ring))
> -		return !!budget;
> +		goto out;
>   
>   	/* notify netdev of completed buffers */
>   	netdev_tx_completed_queue(txring_txq(tx_ring),
> @@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>   		}
>   	}
>   
> +out:
> +	*tx_cleaned = total_packets;
>   	return !!budget;
>   }
>   
> @@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>   			       container_of(napi, struct i40e_q_vector, napi);
>   	struct i40e_vsi *vsi = q_vector->vsi;
>   	struct i40e_ring *ring;
> +	bool tx_clean_complete = true;
>   	bool clean_complete = true;
>   	bool arm_wb = false;
>   	int budget_per_ring;
>   	int work_done = 0;
> +	unsigned int tx_cleaned = 0;
>   
>   	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
>   		napi_complete(napi);
> @@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>   	 */
>   	i40e_for_each_ring(ring, q_vector->tx) {
>   		bool wd = ring->xsk_pool ?
> -			  i40e_clean_xdp_tx_irq(vsi, ring) :
> -			  i40e_clean_tx_irq(vsi, ring, budget);
> +			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
> +			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
>   
>   		if (!wd) {
> -			clean_complete = false;
> +			clean_complete = tx_clean_complete = false;
>   			continue;
>   		}
>   		arm_wb |= ring->arm_wb;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 790aaeff..f98ce7e4 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
>    * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
>    * @xdp_ring: XDP Tx ring
>    * @budget: NAPI budget
> + * @tx_cleaned: Out parameter of the TX packets processed
>    *
>    * Returns true if the work is finished.
>    **/
> -static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> +static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
> +			 unsigned int *tx_cleaned)
>   {
>   	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
>   	u32 nb_pkts, nb_processed = 0;
>   	unsigned int total_bytes = 0;
>   
>   	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> -	if (!nb_pkts)
> +	if (!nb_pkts) {
> +		*tx_cleaned = 0;
>   		return true;
> +	}
>   
>   	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
>   		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> @@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
>   
>   	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
>   
> +	*tx_cleaned = nb_pkts;

With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
May be we need 2 counters for xdp.


>   	return nb_pkts < budget;
>   }
>   
> @@ -581,10 +586,12 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
>    * i40e_clean_xdp_tx_irq - Completes AF_XDP entries, and cleans XDP entries
>    * @vsi: Current VSI
>    * @tx_ring: XDP Tx ring
> + * @tx_cleaned: out parameter of number of TXes cleaned
>    *
>    * Returns true if cleanup/tranmission is done.
>    **/
> -bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
> +bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
> +			   unsigned int *tx_cleaned)
>   {
>   	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
>   	u32 i, completed_frames, xsk_frames = 0;
> @@ -634,7 +641,7 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
>   	if (xsk_uses_need_wakeup(tx_ring->xsk_pool))
>   		xsk_set_tx_need_wakeup(tx_ring->xsk_pool);
>   
> -	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
> +	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring), tx_cleaned);
>   }
>   
>   /**
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> index 821df24..396ed11 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> @@ -30,7 +30,8 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
>   bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
>   int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
>   
> -bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
> +bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
> +			   unsigned int *tx_cleaned);
>   int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
>   int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
>   void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);

