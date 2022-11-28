Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0571463B618
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiK1XnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbiK1XnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:43:12 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0893E31FA9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678991; x=1701214991;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iwdk9Minde/vYjlG9XdJ9+Bpb5vr8NesXgZ3vIb/kBg=;
  b=ZAEGTqmt/TBcPD65Kx65Hy7THQwscm7Efx14XIw6Iu3J3O92SY5+STAF
   sR643QUcGHEPzD9mymIU1dO9bhcBY8ESaG0tUPOEXluGrV34PeNbkUZsi
   Gu7mLyqQuOg/mGHy9GnbLNOu4zsqhp64yQ/duqpw7OFNslp5q41qYUCJJ
   7ATLFoPDoFleNH2G5tfMaZ7mYcVsBLNH8Hi32jN+u+jbx7EN2NFNnyapG
   GXaV0/dIyTFQ7CrwOF2dQ0psr7dNN0oP6dh8LYpoe9Ofsol9qNMLZAJzh
   O2BZEqE1CDue11LkPkg9XTHL+cC9Q9vKeR4ZibmOrs+E4zMtf2JIWAl7M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302560309"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302560309"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:43:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674412446"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="674412446"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 15:43:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:43:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:43:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:43:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2PJgtrJkMmDbB78fTd/LmRMzei+KtOItXvMNIYntwuxzPpR6fGQ//Xe48TmXfTlDQtY8LSPFPlekuolUm1E1AVfjLNxiqKj1vWyPvH2wUowm0/Iwa+ookOHZSix/2Ag/3Tdp2MWcNf4MHCx6kgj9yeFufHLVMgC4I15Y9zvOU92I2I97X8ub5rTDoLY5OSgpb7Ck8NwBLJ2VurEyCvSfJ0zGZoeJFqIzzfdnTYDTxH1HSTAz1WtqnZR38uvayv56Eq/F1c+GcDTWxlhv5zXfKf+1FoJdfZyrJbo8ucIX37vNx6cPhbbhmTIt6epw8TzcfrI9O6U/U3SjwQ312X44Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UI/0q5HELTqErc5SHe4Txzy0t+T2Fr1/kqx2SztBe4=;
 b=Y5AKXJmgoqDXe9kloUykiI6wmDzze3Hn3++/MlRTl+LdU1G2f1hh7nAlCaw4NRxXCi+CskaRsSPBWTchPHw1nSGXClbY+7kgZBlytWurDTfYtlWIteocGnXwrMakpWO4VwetauqFlSQf070R/mGxnc8dzlB8dv3zt4Sr+QqCnX93W0rf35V1ld+y/eSlyDSECrJX9cONMdylC6uAkja6NziPAENJmYYh4MkjM4JwyQSo125N6z1q/XkIjvS2dJ58TNj6w2LnsITrX6GHUHbP2ukZA5Su7/Cn7DRH7UTG7+26HsRXDIWLhe1FAuWeMC1HDdqXvHFdkMQnS6cWisb47Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5253.namprd11.prod.outlook.com (2603:10b6:208:310::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:43:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:43:07 +0000
Message-ID: <62c233a0-a63d-beae-b027-d9449c4816a5@intel.com>
Date:   Mon, 28 Nov 2022 15:43:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 14/15] net/mlx5e: MACsec, fix Tx SA active field update
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
 <20221124081040.171790-15-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-15-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::6) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5253:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e3b62a-c718-4ea3-32fd-08dad19a4c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2S0b9KozZFBy6FMcXnVBl6d+pLxxyZuB2WVaWFVbr7aLYzAAH9WGnkOn1YjAiwKdp8MIfSoV6FaF0c58O9TGYJwHKj3JWuBbAnNHToIRt95sZAKybTlUmL7pdId8kSL5/ba/CKc/02dNQE1qgd1lbJ5U8be6+1F9a9LhHLxcQWNlqf65/CD3+JC04e4c0CNW59frPV4oYyuk4O6cNxNtrO0ZrbUdqXPmmGeM4OLY9YgIOdOy9MkIxKMcTWZaYDuu3SXLY883KnTruC4vULkan0W7vm1yEkXNnxEitEg6oLrsaOCBeg3d39EUu52UkDcZeaeKNK2CkVg+x8Sr8pRAke4RcefJ+5UI10tyo/ZaEQYCWmnydUnEbA7vu7KSLdrJWHxQUtan5t/wcinTIRFsJx3Vb8Y7gs1nepeM/e1HGb4fEivs9G3WZK+MjEjkEAp+rvpoLMguRDjWpSI6SNr69J2wNvzRhjBPITQcvf+7iTx+Irlu2pO5blUL6PrMb8PUQs8stekvccMF37HEvKkXXBXxVb0o9S1DPBDV69thwCJN3HOMzM+BrXpz/0HJB7XSSgkX0inHX71LK/JfSJH7TaPv+SFD2E4UzkkKagqdqA7/m+RBcC+xmT8o8WSimN8oxowFpexh3yBVaAHOnCOgf2mEIKQdXUELFBAf2GJTSGkZnHNIEpDN61hJ1YbAr4JA18REw/tiNrLm/Pi9VT0c4w8uwegwxCgGB14Ok2xNvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199015)(83380400001)(31686004)(26005)(86362001)(6666004)(6506007)(110136005)(54906003)(6486002)(6512007)(31696002)(36756003)(38100700002)(82960400001)(186003)(2616005)(478600001)(5660300002)(8936002)(7416002)(8676002)(53546011)(66476007)(66946007)(66556008)(15650500001)(41300700001)(4326008)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlVXcXY0RmxBcFlObi9ZdFBLNnRRZndVU0p1b21tMjdMaGNud3J3ZVNFRHFa?=
 =?utf-8?B?cmlpQmRhcHFDbGNad0FJTW85YmxEZ3ZpWS9DcWM0elBGWUh5c01hclMyeFpO?=
 =?utf-8?B?cFBUemlUY0hUS1RJcDl6MkErbVMxUVZwT2FIcHI4YXVKaWVXMUNqM250VDY3?=
 =?utf-8?B?VnJSYzk4OWtJNGlxU3F4Ym5vODd2aWhTamNCSE1uUmpXQytIRE4wNmxaVmFz?=
 =?utf-8?B?Tmh0MWhieXZnSmNVRGFxQzhXTlVzT1cxbE54OU9YalZCRktqZ0Zyay9aeUxO?=
 =?utf-8?B?Zk8zeXNjR25ua3M5eVFISEFkVDNaZFh0UW1MV2p4Zk1URjh6Skl2OUVEZ1FS?=
 =?utf-8?B?dG1HL0Y0NmdobkE4aW8wUTRSUTlaamNGR1NXV0lKeXdEazlFTEhYaGtvekFm?=
 =?utf-8?B?dXdJaWVGRFFZZ3JzejQySWxpRmVpTnpLMXR3SVJOZW45UVZ2Z09pdTJUS0JR?=
 =?utf-8?B?RmxIdDFFM0VYRml0S1NXdWpCM3lFdEU4K1dEemhwZGdCdnkrWXdIcGllSHgr?=
 =?utf-8?B?NDFuS0s2OGl4Um1SS0hOd09neXBQUFRyTE95Vk44VVlScytHRHRNT0ZhOS9j?=
 =?utf-8?B?QXRsTWc1Sm1nQXlEMFRIREI0T2JULzNzMWNFK25Fb2tEZHpua1dZV1E2S1JN?=
 =?utf-8?B?aUg5Nk5EcHY0MFNSd0QwK1BDNWlxSk8yWkFHc0hvekpXTEpncmlCUk5aQW1V?=
 =?utf-8?B?bHllMkhTZzQrOWZJbFJJdDV0NUZIazNjOE9KYkNrZ0UwdFlBUXpITXhURTAv?=
 =?utf-8?B?c25rZkhEaHl1N21nN3BGa3hEYnFLb255QVJ3UVJCeFhpMWViUzJhWWc0UjRv?=
 =?utf-8?B?T0xoZ0Rna0xQMkM5VFptU21jbVRGVFBmMjRQLzkydXVNTFFsN2FINzMwclNY?=
 =?utf-8?B?UjNCeWlzTThralJHQi94Rk0xL1dGTDhoWkxRM0J4S1dodDBsbGJOZG1ZOUk1?=
 =?utf-8?B?TU1PR1VrTE9DVVlaUWJ2UUpoUFFTZEJ4N2RaQXc5aXcyV2dKdmJNVG5aVklZ?=
 =?utf-8?B?WndiUm4ybWdjR1ZFUHlkY2tKU2NvaHo3T3hLNHNQdXI3d0JNNE1ORWl4SHNx?=
 =?utf-8?B?Y1Q2M2NBWnZJUTZNZ2xQaVJNM3oxaGdPbFhEcU40ZTVmSkdYMks2dlc4VnA5?=
 =?utf-8?B?dDVPL3g4OUxUM1MvWHVEQWJPZTFZNlMvekhMcXFtOFM2R3dyNm0yb01YMlRB?=
 =?utf-8?B?cWJWVFlRRlVXUHR2UW5KeGkxMzZEZUs2TGdYYWxNeHdZTElaM3hZcExBRUwv?=
 =?utf-8?B?OHk0aGdUejZEelFnQ2lvQ0NLVlBxcGg5RC9yTFBmcDdwS3l3ZzNnSDZBVkt3?=
 =?utf-8?B?ZHIrNm8zVE9vYnNZaHdVZnZKWkF6VEpiRE85WGNXbEgyZm56V2JRRmczNDZs?=
 =?utf-8?B?ODdkeGFkMDVCam04WEVNK0JXTXdJVXJXMEJLWU9RdmF6T1FkdHd5YWhPTkJy?=
 =?utf-8?B?NlhCY1BUOENJakhDcW9CK09ibStKNzl0WmQ0UCtWWFZqM2lmUXBKZ0dxU1pu?=
 =?utf-8?B?cWh5SW1Sb3AvcTU3WCtsY3dsNlpQUG8rcldvd2xNeUtWenlPMmFTUTlZazVa?=
 =?utf-8?B?cWlaWk1iUlRYZ1ljZFBNUGpQU1BORTdwTTJvYzhQeDNyMWlTdkkydDNnekMy?=
 =?utf-8?B?OGxmWmhkVi9WVHJSTDlpZUNRRVpodm1wS1ZuQldWMDd3enVmN1lpSzlVVkpu?=
 =?utf-8?B?OTMzclFLVkxhRytacnZjM2UvZG9idE5UTUhiVnVFS2ZrSXVHS0FmeUMrQmo1?=
 =?utf-8?B?a1NMQ1NnN2MwRTZmcWNwZ2dKRFZxZ3lPUnF0eFh5QlUxeDBaMlpEY0RVNUJS?=
 =?utf-8?B?ZmhzRXNONGhBZVZsMzdiQTZsNTZjMzRuT2pxSk1HM2VQZlJlWS9vMkhLcncz?=
 =?utf-8?B?Y3hBWTVnQ0hQUE9EalZtSHpuMmNtKzZtNXJQc0RlZVZaRFdadGtraDFLRFdG?=
 =?utf-8?B?R242eFk0ZUljWFpmaXJWWGg0TGI4U3lzZzZIS1o5eVZSU2Q5YzRzSnBHUFEz?=
 =?utf-8?B?dVVTLzJKdzNDbXhDQ3VSSmo0eTI0YStFdWQwQzlBNUdGaVl6VHBldVF1eEg1?=
 =?utf-8?B?VWM0elRBUkRhRkgzNk5lV3JOUDIyaW1qdjdVVHEvNUoxN2dpQkduWCtBN0tS?=
 =?utf-8?B?N0ZIQWxaMEhSM2xBS2lDTkd2Zm4xbWxMbS9jZDYyVkhCN2JOMVUxbHZNV0cv?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e3b62a-c718-4ea3-32fd-08dad19a4c8e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:43:06.9652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdciroD8tWEvyZMuY+JJvsJMZij6QnXGcJwVRay3ryUd3fDZymvOg5IyBgYsibJB7SwStLsMIqOn8IcegTpaWHI6wS7or6hihPvyCWvxea4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5253
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
> Currently during update Tx security association (SA) flow, the Tx SA
> active state is updated only if the Tx SA in question is the same SA
> that the MACsec interface is using for Tx,in consequence when the
> MACsec interface chose to work with this Tx SA later, where this SA
> for example should have been updated to active state and it was not,
> the relevant Tx SA HW context won't be installed, hence the MACSec
> flow won't be offloaded.
> 
> Fix by update Tx SA active state as part of update flow regardless
> whether the SA in question is the same Tx SA used by the MACsec
> interface.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> 
> Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 72f8be65fa90..137b34347de1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -602,6 +602,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
>   	if (tx_sa->active == ctx_tx_sa->active)
>   		goto out;
>   
> +	tx_sa->active = ctx_tx_sa->active;
>   	if (tx_sa->assoc_num != tx_sc->encoding_sa)
>   		goto out;
>   
> @@ -617,8 +618,6 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
>   
>   		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
>   	}
> -
> -	tx_sa->active = ctx_tx_sa->active;
>   out:
>   	mutex_unlock(&macsec->lock);
>   
