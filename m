Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2177C63B5FE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiK1XhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiK1XhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:37:12 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6333432B92
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678631; x=1701214631;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u6eUqVwHib66cefNLeG5uT94Br0JzK8vqP8cJRgFIXM=;
  b=TngZe9Zj+dwQ4neGhStphwXXIQEZdqAnOwTkQPbbeiDuy2p6Y11Sdvsa
   4OZCYd5dO9pzgpJeq9BQK2g3d9o96KrmlngR7jkyOCqNFEn8xrhe5ZdYT
   3vsAya1/n6dNz5EqJZt/l8eFHBgVwkka8qHPPU4hrusep12krphwY6SHj
   EaySd787dHFbnZGo5HmH2Qxew8RGP3RiwkbLgLecvuSpPi7W5BVCxAWcG
   m7eM0+CmAXmqFKaS8PQax1COSNQP8VW9oGZ5U3zZNt8vGfh8OsBH1D+YL
   I8aFf/5g3EXkI3x1kxAbmSDG1H8bHSYloiB1icM0MEvaTfv90EteGsJ6w
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302558449"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302558449"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:37:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="643578652"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="643578652"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 28 Nov 2022 15:37:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:37:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:37:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:37:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4hN9ZMRQkVOgZYvwkvHVuvDqS43TkTtEI2tqEJ4ng7t8Nk+c9gnMwlh7atSR4R65kY8tp3dc1EnFqcgk8ZnmhMQMjJ7wLf8OFDPv5RKLTzCnVtasikAabcj5+FGhNIXeZppTJQfG6NkJrlPK94VfMyQvL/Xnm34QpgmbUOUz6oMvkLW8X1Opnu6wT6LXQKQ4XdB2Bpr1h56kLdY7woZIy9zSWMxjsBRzWCcvFVHDsDKdGt/zV5xPwSO62oV2xxTk9xmyf8x2sOCfG0aWb9K219ak2y0Owrd4xA/afC3SUXJlP0RdTwZS+oc5pkDvbtcITpQv/dbY8D7FquN61scQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfxUi+F+MtkDg0K5G+0DVmPHCWujhYsbp2tC2oazVvY=;
 b=agZmLG0niYguDHRYY9KMizGKgNXV4WGGItRS+Mc/P5UNi8FU4c5vP6caZ7NSjzKUM5FDqVZFbdJgN1IU+jP65PaoLKM2hwCC9/VhXPrwV4VNHgTTnH0zVJkCLBFvd60y8e+b3lQ4ylPlwBPuWJyB+1xLCiqhRG0YRHyDVXYu5dELg+tNMnnZusL2MXtA4PXP3NiV4wWfUs9X9wl18j+BmQh3Wj3hK7UgvjZ5+h2jXnfvZcG0fiWd5ZSwf/6UKJDojIixAUlkWFiw1fQTrdm1Mzfv4qPFPrOWgsanOI+Z0FeZT2aZPRKYv6z3Gq1wjDoQbTEtziJ2mk2uvjo352oUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:37:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:37:07 +0000
Message-ID: <9f778faa-76a3-f7af-d0f7-63d989934c59@intel.com>
Date:   Mon, 28 Nov 2022 15:37:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 10/15] net/mlx5e: MACsec, fix update Rx secure channel
 active field
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-11-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-11-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: a1110091-ce5a-4f94-605a-08dad1997678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCuaskvGLhR16Iey/x1/XCosSAb/s7FlMVeAKvgBVFg7hnHPTiJQoUSYbDoE+wAOFRPBgDlnUoeAQKSFpYVWFS/rw67rlFxFcK38vfTkLje8Mwm+v4v8CbR1jm/zB4GeC3LmEBIQKmqvsCx4YREO+ngAAl/fU7FEPgBAkWf1zk54ry2KK6j7K8wVBhqZppjxd/B24ZmxJnNsbQO8CQeb6MDRA1OtU5/p28ANAtNUKQRyne09dEZkpw8hD91bWmjOXybNDesuV87fefpVy+crSsz+hHM7DlwFs4aTuS4gkQrQAOMQAQ6cSDKQySOgcgz5TkTsKMEXxUpmSPQ1OPJptscqUfITdoHwcOr3Tl6/qg+VZYFTo+1wVpnW8dl+gegkyTzzZZbH8zoRFD/kmZmm36m4QgAHHGt0ORILgF/XJ8qEknFZV4HfTUPfjXzdhBvNj6dfW8ljuGxqB+JSpPiY5I2HUpXi8GZ13AuFZB/IwTwzbrY4ktG3Tp+IYxEd8vxmiXf8zUvZlD3Eb+hdPvmSZhrLuj7nSuCjDZOqjnEY0xqXwgqzrfFyLdB4Wq6RjzH7SCEBWetJAm6kPn5BBmP7ozlrYe8VVOEt8gBv38rNz7tOZC+Br28jHsiPT4BJDnIY3JHZEkdxjWtFFvjcIZW7kUzYLFZZxLdHk3/obV4+5VqxYare8pwekwe4iXJ5RWDofdffvAGVqdBw9n0I06fK9dKKfECTeOWp9Pc0RlWc/y8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(2616005)(82960400001)(38100700002)(26005)(6512007)(7416002)(36756003)(110136005)(54906003)(2906002)(15650500001)(5660300002)(186003)(31696002)(53546011)(478600001)(86362001)(6486002)(6506007)(66556008)(41300700001)(66476007)(66946007)(4326008)(8676002)(31686004)(8936002)(83380400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmxpMVpUMHFDTlVTVFBmSlc3cUsybS9OQmdxeTRjYVJDM3F3ankyZW1mQzcv?=
 =?utf-8?B?bE1aTW0wb2VEb2JsZmZwS0QvWFV0cklNcmNVQ2Y4cWExYWt3TFVMaUIrRlBz?=
 =?utf-8?B?SVF3MnZKcitSMFdFSGJJWlhzcmVVZFFnZldXYmNodmg4QlZFckhGNUlFQkox?=
 =?utf-8?B?ZDg2Y0NCNFVXOU01OXNTTlUwL2JzU01BR01yTlE1RmgxWUg4bzkyL2tCcmZW?=
 =?utf-8?B?NTdpMGp5OHNGb3B3OGYzdlMwWktSNThRTXJYczIwNVFDa3JMZUxRVHRDbC95?=
 =?utf-8?B?TzBMajNNdHBtQTEzR2lzdllHMHozL3Y4cnRBbmlaT082STNDWXJTeHFtSjFI?=
 =?utf-8?B?eXpWQ2tKSDZCMkhyc3JBNWpySktQZEhjYzY0K3g4RysyVTJlRU9Ra0hrUG52?=
 =?utf-8?B?N2JJZHBiV3lFdG1zbTNhaTVJZ0lLVDFQWE9qVGVqbFdUNWVEZmFHSnlSKzlZ?=
 =?utf-8?B?Q0NTS0hoa3Bwa24xemNnVzFISW4xWmNVUXN1QUdQM0ZZSXdGMUx4VG90dTk2?=
 =?utf-8?B?TTd3VzlnRExjRkJGNEZReFF0SUozV2FVWTFxRGhmSDlpQSswdVVkb2pFRGVM?=
 =?utf-8?B?aDZkc29EdkxIWUthNGg3cGRreDdydGxoanRudlNKSlF6WW5CaUl1aHpBM1hW?=
 =?utf-8?B?eGhqdGtxc0N1RVhjSWZEaG50Yy9vTjdQNnZrMzJlenM1QnhCNDBVOFhyMHZv?=
 =?utf-8?B?bGNOZ09KVkt3amdtV2hlUk5hQkFJdDhYNU9GdmtlNmFQTEFMUWNOKzNqNUxo?=
 =?utf-8?B?N0syQ3NHTklUOHh6SVlVYTVSSXJ5TUVsbVNFL3F5VlFnN1dBdkUrKzVMWnNW?=
 =?utf-8?B?eGsybFlmemQwNWN5OEttNUtBTVZiV2p2bWNWSSs2R3pCK3FnWEUzTGxwbWQ3?=
 =?utf-8?B?Nm1NV0JTZlZURXhUWm1KM2hPUGQ4UlZsTjk4c0tjTWNvUXZyQzhIYTk5b3dI?=
 =?utf-8?B?UGFFRzR4VHpSQVVIcHUyWDRUbC9sbmdVeFpndjVnSHRlRFJnaUoyRjFvd0Vy?=
 =?utf-8?B?dVlIWXVKUzFjTjRSQlNCaHRqR2VaNW1nek9qVGZDRjNTYWdTb1F1RzhoaHBk?=
 =?utf-8?B?cHlHK1JQS2I0VDFFZklONjNkNUs1UjFnY3dqeHhFSTFZMGYrdlFSaU9VZEpH?=
 =?utf-8?B?a2VEVFFNS21aMDJaeGRGK1VPSUhVckNpVGVEZ1B3aW9zaEJYY0ZGdittTXVv?=
 =?utf-8?B?T2RaWlAyUjJ5S3VlYXBudkExWUZLNThiREgrUm9EZ2RhN2JLamluUW9jTm5T?=
 =?utf-8?B?bkpUVTRxWDR5U3NYbVVYV2M0M1NWd2NvU0d4RzNwVDBtT0EzMVRGekNzalVY?=
 =?utf-8?B?ZERndXlVRWNXeDU0Yk5VMVZnblZ2aEk5QlIrckVIOUtFTVdBc0xwWVh1VmEw?=
 =?utf-8?B?RVFrTGhLdFZ0K3Z0MnVXK3VVV2xwKzUrY0FpcFRKQkJKZEdWd1g3Y1JkQlA4?=
 =?utf-8?B?ZHgxd25PbW15M2dGVEhnRUxqVTlQQnhOMDFxR2tLRldQMHRTc3VkWE5iTVN6?=
 =?utf-8?B?T3lHQ3NWQ1pRY0dQd0kweUd2SW5pUWFsVUlNSytqRmZicFVmUFpWRkV2Rmdq?=
 =?utf-8?B?VlNsYW9QZzZaZE5MYklFbXl1QXpjQ2lMQVpLNUpLYis1dzZoNytpa1hoN2Fv?=
 =?utf-8?B?UXJwbzFXVGkwSkxjR1FQdVp3QkcybFpVVDY2dkU5VldjZ2FqdXU3Y2wzUGNH?=
 =?utf-8?B?S1NaZTNKSFpDQXBoS0NPdFVCR3VWenVGMXhtcmc0VFhHc1l2ZUtKU0xFTG54?=
 =?utf-8?B?R1p5eGprTmJ5dlBkL1NYNzYySFBUcW1KbWh1c3ZnQnhKWW5YOTBzR0loc3ln?=
 =?utf-8?B?djZSR1pJKy8xM2lvMnk5MEJmaC9HZGdUZ1FyWVZCWEZYZmhKZHEvSmY2NFp2?=
 =?utf-8?B?QmRObXVGaTFEdHZOKytqYkdyMXYxZ1JKemVyVHdFcmlFUktRYmRqWkJ3d1Y5?=
 =?utf-8?B?OTlrVVdVWFBaV3V4aDRHRk9NalV2elVSNUFzbUp1N0Q4REF2dFZrQ3p2NktU?=
 =?utf-8?B?NVU0eGdGMjBQMEdHREJRZlZhMHFnd3Z0NlhpampLbmNncElmQWpOOUIvWTBm?=
 =?utf-8?B?a0p4bno3R1djZjBiYm54eUxmdUZGT1ovVWpUUlpyWWoxd2kwcEQxUTlsWWp5?=
 =?utf-8?B?MFloR3VaU2U0QmdxRklxd2h6Y1Y4TjMxOHkxajVVM2ZYNFp1azFLYmlJLy8v?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1110091-ce5a-4f94-605a-08dad1997678
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:37:07.5554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4aHMUsgMTP6st2zV14GRK9G5Fsd3Bm0W3UhLSA5OEXTEpt22Yyj4QSNnQUcJsAk2P4vsvphUphX37PhdYQU8hMyJkBxIn5xM2y1p4sxWx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
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



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Raed Salem <raeds@nvidia.com>
> 
> The main functionality for this operation is to update the
> active state of the Rx security channel (SC) if the new
> active setting is different from the current active state
> of this Rx SC, however the relevant active state check is
> done post updating the current active state to match the
> new active state, effectively blocks any offload state
> update for the Rx SC in question.
> 
> Fix by delay the assignment to be post the relevant check.
> 

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index b51de07d5bad..9c891a877998 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -803,10 +803,10 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
>   		goto out;
>   	}
>   
> -	rx_sc->active = ctx_rx_sc->active;
>   	if (rx_sc->active == ctx_rx_sc->active)
>   		goto out;
>   
> +	rx_sc->active = ctx_rx_sc->active;
>   	for (i = 0; i < MACSEC_NUM_AN; ++i) {
>   		rx_sa = rx_sc->rx_sa[i];
>   		if (!rx_sa)
