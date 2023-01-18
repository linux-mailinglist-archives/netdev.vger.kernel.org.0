Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7B672AD4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjARVsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjARVsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:48:23 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A7618146
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078501; x=1705614501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y8CCdpAVkKCPtwEG+yy0nMSTnpme/YlV3RTC4aPm6YI=;
  b=Q3FScoafDGK+4Ku2/eQz/dZ9QEnj/ZYJJyZ2oK6UrzwtGxk87G2Lso7o
   M65vCVmdk4j6onU18NeVLcQH5ksUFORqDpDRnfD528djdwi3CsAV1NaBT
   lV3VREk8XshesMT0bAVOiXhdhf3i7HpWL7GCSVdGahwz8U3zzqmQsDSyH
   IgfCAjzUPlfh/VR9IRXwJsnLeDV38HmUW8suCYlJZfshpsDX+708B4hBc
   lBwwGS9tszQ1rMAbLsRc5lWXdK9k8ytF9QtFjns9n1m3rgj841QXSyrDP
   ADfIcE3oDxTMPOIOiz0dK4jk9TPGVnCgM0pxTbUYudVmygxym59g0xSIY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411351302"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411351302"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:48:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692178373"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="692178373"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 18 Jan 2023 13:48:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:48:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:48:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:48:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:48:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGev0y7QabcsUkQyGatFn1BtJQJsGJ7lfGPrzu1na24BWErywk5YSNk2BT0ih/TQ4ep37LzsaU7/b/unRYN3OTlqIZOd0A+WIKPDwWc6U8AWMQftkJFAFYLXVulOtEB11SUWTy8qW+o3V/1CpWoQnJsOtRCYacrQkXz0FFg8Ee9tiWZKEIDK6DNmt4QetVp8rFfeCHJ9mhBMDHk99A7lVx3M/GvRVfekUh20pDcQijQZ9RBZWANNNkANyasaVBcny4QMVsepy25iTeThwgAZSHUYw8+LrEUrJgb+39tnBCvOw4u4t2Yjk+Lvt6NlzDIlJd3XjszFrxzdY5SOMrbK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9O9/09CBz/1LDlp1QivfBIX4mIVBA3qrkiLfPEZf+k=;
 b=UySOuoLs9bqo2+nQFWkILhwprSNcu8RaTvD4ETFAOFqFNK3qPGgSPd04Z4oII8xi7hgLU5sHkcUJQirBj66xz+AsCaZQJcGqHtPwE4lXnISF5UhRTU6rNiSqfyrUNngpTcyjVkuNtGfw0QOh6B71p4D0KsXuyKJ3/A/x+57UY2qwqGuLGi55wUQMcrtK5fNxARBJRmQTzVmTcHFKnjQ9ElSE5lYfFW4nGwjhOV1ZVvpZx/s3Lg7O6wPg1Z/IdWceihmqDrn5Kpft2N0z9KihIOZcs7XvGaz0l1onqc/qVTn9kwm/xZXNSvhuk/1l6CjYzPMgmHil8aj4EMhH4CdnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7451.namprd11.prod.outlook.com (2603:10b6:510:27b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:48:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:48:16 +0000
Message-ID: <48a1d4c5-c764-644a-4c60-d928df32db3e@intel.com>
Date:   Wed, 18 Jan 2023 13:48:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 13/15] net/mlx5e: Support Geneve and GRE with VF tunnel
 offload
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-14-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-14-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7451:EE_
X-MS-Office365-Filtering-Correlation-Id: 038cee6a-6ee0-450c-3246-08daf99db4b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQt1rG61NGocObEpt2SIe6+mSgn79rMpiWSOLVL0F+LtrjGLGwj/z0RGXCL2ayrJoROnuoN8IQUU/gMAjfpWFtDhMfB9/SA72JfDWh2O0tUHrmYf8dU8d6TP6LvL7JuDZbTzM359l3hs8ib8rAhMDg2B/RA/kKOjeykSC3bzYVponEUsgODDaKODNHt8ocgb4/yUXxIZJVmpX9SMgMeed1deH9UETD6mgqHW9RIMJ9sE8dtn/SsOSTB5Vl4o6v5+zaZLg4BxsbGW5eEmRotQGb2zZ+09u5aPqMGpNNZqJh8We9CrX4nbrrsx2GHoJuqCTjDvawBlyeqgLvp4tRGkX6RBYbXVnBuOqYJxmhP3AUi9XfGT3pbeXcWowihKNcZgTksoLdJIX3rcLikYP6MReJxMEBGto3QrnR4mQFVJPjDObehmjMXjhg2XfmvGRZgWkNeQU9ElqRMhLHcQKotW1I2tZofcet9UZvoIw9z33fw1mbxW2gDqopos7u7l2V+cPkl3d2tkz/HI1k78Rb3q2cqx07gfHHyHFu478txfTb05pwrynE4UU78GxXtwLsGycddhAQqBMW2d71BJbfSbzqXIJPneQuBJN7Mr4LyjPcY9qdpgaQO7j3EPQYdnMxFpDY9mBxMF2tNo9qZCnragj9asqEQwllVRWR/3erN4pMmkWRXdubYfDBbSa9u8XBZUBoMaBRB2Iwu2NRS9Tvjq/Ao4WlJ0lgSFfedgpS+sjL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199015)(66899015)(31686004)(36756003)(8936002)(8676002)(86362001)(66556008)(66946007)(478600001)(31696002)(2906002)(4326008)(7416002)(30864003)(5660300002)(83380400001)(38100700002)(82960400001)(66476007)(316002)(110136005)(54906003)(6486002)(41300700001)(2616005)(53546011)(6512007)(26005)(6506007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXVoMFB6UjZicHR4ZXVkVEFGTEM2TkNMbHphNVpDMWRoNHl0bnZ5My8xT01T?=
 =?utf-8?B?RWlMUFhhb2pua3JlUmw3YU9vOFNCbzhnUVF3d0FCcVNyeHVUc1N3UU9WUEpV?=
 =?utf-8?B?cmI0VnJpcTg3OWF6bVVseE1DT09ocGNjaUtpam5iY0lEL1BIY1BYYnBMMm9R?=
 =?utf-8?B?cTFlS3JMUnFwaVVqQ3lqSlVDbFBJM04zK0N0TmFNbEp2a2djR0N0TndRc084?=
 =?utf-8?B?b2xndTEybnNUZVRCWWQvUUZyNGJNUjdzTi9jQ0czbU5rSmoxT1dxSjFxcVFK?=
 =?utf-8?B?NmVZOU9JNU9aTTRUUGc2bUI2Q25Od210R2ZoWmxzcnM2VUdJU1kyeTZ2dkpk?=
 =?utf-8?B?R1MrRUF4dUJZVDA4dzNCS1R2R1VGUGE5QTg2OGl3MEE4cnlRRTVURHZIalhN?=
 =?utf-8?B?MWZmSkxpRXMrdVlPRXg2dkZkc3FVSldZVlpZcDIxMGJiQWxBZUxOOEI4Rklv?=
 =?utf-8?B?ZFdpN3AxaFVKMW5GNE5KSU5rL1Y5VGFyeHBkMUpkZXRVWXFVeHZVdm16U2w5?=
 =?utf-8?B?cFQ1ODZQZ3NtaGVtUEphajhSY3owWjI1TkZwdm9lb28zWDVzK3pES0EwTzdt?=
 =?utf-8?B?eEM4SHVBOTRGTXJvSVhXVDRWWXhCYkxaVVBmU1RRQWh0L2ZjbGg4WDh3SU9n?=
 =?utf-8?B?TGxCeWE1MlNSZllQUjl6MGd4eVY2NzlJUlVOSnJoYXk0Mm9wQVN2eFVxaW9R?=
 =?utf-8?B?QWlkRkRrbEd1Ti9kM2dQMENVaUhyNlJYV1IzaGxGZXFwM2hJdEs5ZGc0TUNE?=
 =?utf-8?B?Titmc3NZNk4wQkpvcVE5L2pmTW9iWHFUSHUzcE5VK281MmkrbTMwV1JpVjFB?=
 =?utf-8?B?dUdiZ2VEdjRKMS9KdzVCTGhVSUdNZURwbk1ITUlEZmgwaDFzK1hVRWQvRjd5?=
 =?utf-8?B?WE5objgwL2xLQ1g4MkkxaFIwQmpJYWt2a0h2STlXeTZTN1Vhc0V1Y3JZT28z?=
 =?utf-8?B?ajU3Rlptc204T0Z1c1pWQXllODUwRkRZajEvMFZnUS9Ka3JwL2FtV08xb3di?=
 =?utf-8?B?cjNkNkJYVlg4WVltaXZXaHhZYjVxUFdhMUR1eWRGc2paMm1hditkcUVxKzFa?=
 =?utf-8?B?UmpBZ01ldkJTbEJ3UGpEZTUxMDMwb29GRjlGVnRSSzZuM2Z0VXF1b2dycS9W?=
 =?utf-8?B?alZEK1duOTQ1V1QvVjRzZVJoVGJiMEpVQjd1OU93dDdnbzJoeitDdW5PSFkz?=
 =?utf-8?B?WVg2REozQXVweDBiMjZiUG9wSTdGVit4Y2FEcFVKZ0lQTDczd0tsOHkrOEc5?=
 =?utf-8?B?UDUxeWg1YWZqN0VvOElPWVJyWDJhNXdKTUlGWmJPV0lHUHNFblRkOEdnZ0dt?=
 =?utf-8?B?TFhXem93alMwL3I3U1k0ODU1cTNPQ2x3UW5oVU1MelAydzE4VDI2dEszMmhm?=
 =?utf-8?B?eStWWW9lQUd5UmpLQ3M4dzhnNU5FeWwwRjRkcUNuRmU0elExV3Z1RStsRGVi?=
 =?utf-8?B?aWc5cERiZzJnVkduY29YMkpvTHBPSittTEFhQS85WGNuMUpjcHF6QVJueXFv?=
 =?utf-8?B?aHNkTnFnL21USUxEMkMvdlVVaFo2TUs3VHBIK1BwZ0RlZnRaVUhKbkMzQzVo?=
 =?utf-8?B?aFpKcjFQNW5nVC9EM3cxdDJzSjZVUmhuZGhSQnV6dWxOK2VQTmFOSm9mM2R2?=
 =?utf-8?B?WGZPUEh1amlhNmZSVjFIS0pFQXZKV2xtRjBzQ0VpUkxjSjQxSE9iTG1weWZP?=
 =?utf-8?B?NUtBVEVkWW4zcjRwb2ZqamtZSWtERWRmTXNKS1ZxeFVQSERldStYenMwZXFG?=
 =?utf-8?B?ZkwzMHNQRHE3NnVReXROZnQwMFZTN29OaHdPVmNkUGZ1ZFVmNzVybWNvOGdw?=
 =?utf-8?B?a0h5WVZVTjZxaEdsZ2tKTTBTSUtFMjdsSmpBQUI4Q0JDRHBFT3BmYk5pcmlj?=
 =?utf-8?B?ak81SGNibzZzKzBVRy8xbk1CT1d0cS82bVFROFJIN0RxMTFPbGxsVlA0TkxG?=
 =?utf-8?B?UDJuVHpWbjZWVWFSSzJCUEhES0lSVVFtaFlTd2NIb2habDg2eml6M3VmR2Zw?=
 =?utf-8?B?ODNoWGNzRStnVXhYQnQ1WEpWY1RZb3BtdEViZ0JTWG45citHQ1JUc3dtS3hR?=
 =?utf-8?B?QUUray9MQzJFNXdmQ0RwZ2pjaUZsOUpxSFRQenBtUnI5cEI3dlZxbjRVcGY5?=
 =?utf-8?B?czgxNE4yMkZyS0NOOHZrR1FHUlhpSjZCeFlFMjE4d1NiOThZN1R1M3hYeVdw?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 038cee6a-6ee0-450c-3246-08daf99db4b3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:48:16.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LH8PL6GF0nOpzjaGT1l9nu6bwJPam+iJyMDTH3mnxYEIVVekJ90X35zj8ximMQRU5mcityQJFZBHYqx6QOPwTAfSnmv4o5HoVwyDwi6Y9BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7451
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



On 1/18/2023 10:36 AM, Saeed Mahameed wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> Today VF tunnel offload (tunnel endpoint is on VF) is implemented
> by indirect table which use rules that match on VXLAN VNI to
> recirculated to root table, this limit the support for only
> VXLAN tunnels.
> 
> This patch change indirect table to use one single match all rule
> to recirculated to root table which is added when any tunnel decap
> rule is added with tunnel endpoint is VF. This allow support of
> Geneve and GRE with this configuration.
> 
> Signed-off-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |   2 -
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   2 -
>  .../mellanox/mlx5/core/esw/indir_table.c      | 203 +++---------------
>  .../mellanox/mlx5/core/esw/indir_table.h      |   4 -
>  .../mellanox/mlx5/core/eswitch_offloads.c     |  23 +-
>  6 files changed, 48 insertions(+), 195 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> index e6f64d890fb3..83bb0811e774 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> @@ -745,8 +745,6 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
>  		if (err)
>  			goto out;
>  
> -		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
> -						      misc_parameters.vxlan_vni);
>  		esw_attr->rx_tun_attr->decap_vport = vport_num;
>  	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
>  		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index c978f4b12131..c8377b4c8c8e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2595,13 +2595,13 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  		err = mlx5e_tc_set_attr_rx_tun(flow, spec);
>  		if (err)
>  			return err;
> -	} else if (tunnel && tunnel->tunnel_type == MLX5E_TC_TUNNEL_TYPE_VXLAN) {
> +	} else if (tunnel) {
>  		struct mlx5_flow_spec *tmp_spec;
>  
>  		tmp_spec = kvzalloc(sizeof(*tmp_spec), GFP_KERNEL);
>  		if (!tmp_spec) {
> -			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for vxlan tmp spec");
> -			netdev_warn(priv->netdev, "Failed to allocate memory for vxlan tmp spec");
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for tunnel tmp spec");
> +			netdev_warn(priv->netdev, "Failed to allocate memory for tunnel tmp spec");
>  			return -ENOMEM;
>  		}
>  		memcpy(tmp_spec, spec, sizeof(*tmp_spec));
> @@ -4623,9 +4623,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
>  	if (err)
>  		goto err_free;
>  
> -	/* always set IP version for indirect table handling */
> -	flow->attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
> -
>  	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
>  	if (err)
>  		goto err_free;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> index 66e8d9d89082..ce516dc7f3fd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> @@ -84,7 +84,6 @@ struct mlx5_flow_attr {
>  	struct mlx5_flow_table *dest_ft;
>  	u8 inner_match_level;
>  	u8 outer_match_level;
> -	u8 ip_version;
>  	u8 tun_ip_version;
>  	int tunnel_id; /* mapped tunnel id */
>  	u32 flags;
> @@ -136,7 +135,6 @@ struct mlx5_rx_tun_attr {
>  		__be32 v4;
>  		struct in6_addr v6;
>  	} dst_ip; /* Valid if decap_vport is not zero */
> -	u32 vni;
>  };
>  
>  #define MLX5E_TC_TABLE_CHAIN_TAG_BITS 16
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> index c9a91158e99c..8a94870c5b43 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
> @@ -16,18 +16,12 @@
>  #include "lib/fs_chains.h"
>  #include "en/mod_hdr.h"
>  
> -#define MLX5_ESW_INDIR_TABLE_SIZE 128
> -#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
> +#define MLX5_ESW_INDIR_TABLE_SIZE 2
> +#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
>  #define MLX5_ESW_INDIR_TABLE_FWD_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 1)
>  
>  struct mlx5_esw_indir_table_rule {
> -	struct list_head list;
>  	struct mlx5_flow_handle *handle;
> -	union {
> -		__be32 v4;
> -		struct in6_addr v6;
> -	} dst_ip;
> -	u32 vni;
>  	struct mlx5_modify_hdr *mh;
>  	refcount_t refcnt;
>  };
> @@ -38,12 +32,10 @@ struct mlx5_esw_indir_table_entry {
>  	struct mlx5_flow_group *recirc_grp;
>  	struct mlx5_flow_group *fwd_grp;
>  	struct mlx5_flow_handle *fwd_rule;
> -	struct list_head recirc_rules;
> -	int recirc_cnt;
> +	struct mlx5_esw_indir_table_rule *recirc_rule;
>  	int fwd_ref;
>  
>  	u16 vport;
> -	u8 ip_version;
>  };
>  
>  struct mlx5_esw_indir_table {
> @@ -89,7 +81,6 @@ mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
>  	return esw_attr->in_rep->vport == MLX5_VPORT_UPLINK &&
>  		vf_sf_vport &&
>  		esw->dev == dest_mdev &&
> -		attr->ip_version &&
>  		attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE;
>  }
>  
> @@ -101,27 +92,8 @@ mlx5_esw_indir_table_decap_vport(struct mlx5_flow_attr *attr)
>  	return esw_attr->rx_tun_attr ? esw_attr->rx_tun_attr->decap_vport : 0;
>  }
>  
> -static struct mlx5_esw_indir_table_rule *
> -mlx5_esw_indir_table_rule_lookup(struct mlx5_esw_indir_table_entry *e,
> -				 struct mlx5_esw_flow_attr *attr)
> -{
> -	struct mlx5_esw_indir_table_rule *rule;
> -
> -	list_for_each_entry(rule, &e->recirc_rules, list)
> -		if (rule->vni == attr->rx_tun_attr->vni &&
> -		    !memcmp(&rule->dst_ip, &attr->rx_tun_attr->dst_ip,
> -			    sizeof(attr->rx_tun_attr->dst_ip)))
> -			goto found;
> -	return NULL;
> -
> -found:
> -	refcount_inc(&rule->refcnt);
> -	return rule;
> -}
> -
>  static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
>  					 struct mlx5_flow_attr *attr,
> -					 struct mlx5_flow_spec *spec,
>  					 struct mlx5_esw_indir_table_entry *e)
>  {
>  	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
> @@ -130,73 +102,18 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
>  	struct mlx5_flow_destination dest = {};
>  	struct mlx5_esw_indir_table_rule *rule;
>  	struct mlx5_flow_act flow_act = {};
> -	struct mlx5_flow_spec *rule_spec;
>  	struct mlx5_flow_handle *handle;
>  	int err = 0;
>  	u32 data;
>  
> -	rule = mlx5_esw_indir_table_rule_lookup(e, esw_attr);
> -	if (rule)
> +	if (e->recirc_rule) {
> +		refcount_inc(&e->recirc_rule->refcnt);
>  		return 0;
> -
> -	if (e->recirc_cnt == MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX)
> -		return -EINVAL;
> -
> -	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
> -	if (!rule_spec)
> -		return -ENOMEM;
> -
> -	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> -	if (!rule) {
> -		err = -ENOMEM;
> -		goto out;
>  	}
>  
> -	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS |
> -					   MLX5_MATCH_MISC_PARAMETERS |
> -					   MLX5_MATCH_MISC_PARAMETERS_2;
> -	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version)) {
> -		MLX5_SET(fte_match_param, rule_spec->match_criteria,
> -			 outer_headers.ip_version, 0xf);
> -		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_version,
> -			 attr->ip_version);
> -	} else if (attr->ip_version) {
> -		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
> -				 outer_headers.ethertype);
> -		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ethertype,
> -			 (attr->ip_version == 4 ? ETH_P_IP : ETH_P_IPV6));
> -	} else {
> -		err = -EOPNOTSUPP;
> -		goto err_ethertype;
> -	}
> -
> -	if (attr->ip_version == 4) {
> -		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
> -				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
> -		MLX5_SET(fte_match_param, rule_spec->match_value,
> -			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
> -			 ntohl(esw_attr->rx_tun_attr->dst_ip.v4));
> -	} else if (attr->ip_version == 6) {
> -		int len = sizeof(struct in6_addr);
> -
> -		memset(MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
> -				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
> -		       0xff, len);
> -		memcpy(MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
> -				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
> -		       &esw_attr->rx_tun_attr->dst_ip.v6, len);
> -	}
> -
> -	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
> -			 misc_parameters.vxlan_vni);
> -	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters.vxlan_vni,
> -		 MLX5_GET(fte_match_param, spec->match_value, misc_parameters.vxlan_vni));
> -
> -	MLX5_SET(fte_match_param, rule_spec->match_criteria,
> -		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
> -	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
> -		 mlx5_eswitch_get_vport_metadata_for_match(esw_attr->in_mdev->priv.eswitch,
> -							   MLX5_VPORT_UPLINK));
> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> +	if (!rule)
> +		return -ENOMEM;
>  
>  	/* Modify flow source to recirculate packet */
>  	data = mlx5_eswitch_get_vport_metadata_for_set(esw, esw_attr->rx_tun_attr->decap_vport);
> @@ -219,13 +136,14 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
>  
>  	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
>  	flow_act.flags = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
> +	flow_act.fg = e->recirc_grp;
>  	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>  	dest.ft = mlx5_chains_get_table(chains, 0, 1, 0);
>  	if (IS_ERR(dest.ft)) {
>  		err = PTR_ERR(dest.ft);
>  		goto err_table;
>  	}
> -	handle = mlx5_add_flow_rules(e->ft, rule_spec, &flow_act, &dest, 1);
> +	handle = mlx5_add_flow_rules(e->ft, NULL, &flow_act, &dest, 1);
>  	if (IS_ERR(handle)) {
>  		err = PTR_ERR(handle);
>  		goto err_handle;
> @@ -233,14 +151,10 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
>  
>  	mlx5e_mod_hdr_dealloc(&mod_acts);
>  	rule->handle = handle;
> -	rule->vni = esw_attr->rx_tun_attr->vni;
>  	rule->mh = flow_act.modify_hdr;
> -	memcpy(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
> -	       sizeof(esw_attr->rx_tun_attr->dst_ip));
>  	refcount_set(&rule->refcnt, 1);
> -	list_add(&rule->list, &e->recirc_rules);
> -	e->recirc_cnt++;
> -	goto out;
> +	e->recirc_rule = rule;
> +	return 0;
>  
>  err_handle:
>  	mlx5_chains_put_table(chains, 0, 1, 0);
> @@ -250,89 +164,44 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
>  err_mod_hdr_regc1:
>  	mlx5e_mod_hdr_dealloc(&mod_acts);
>  err_mod_hdr_regc0:
> -err_ethertype:
>  	kfree(rule);
> -out:
> -	kvfree(rule_spec);
>  	return err;
>  }
>  
>  static void mlx5_esw_indir_table_rule_put(struct mlx5_eswitch *esw,
> -					  struct mlx5_flow_attr *attr,
>  					  struct mlx5_esw_indir_table_entry *e)
>  {
> -	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
> +	struct mlx5_esw_indir_table_rule *rule = e->recirc_rule;
>  	struct mlx5_fs_chains *chains = esw_chains(esw);
> -	struct mlx5_esw_indir_table_rule *rule;
>  
> -	list_for_each_entry(rule, &e->recirc_rules, list)
> -		if (rule->vni == esw_attr->rx_tun_attr->vni &&
> -		    !memcmp(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
> -			    sizeof(esw_attr->rx_tun_attr->dst_ip)))
> -			goto found;
> -
> -	return;
> +	if (!rule)
> +		return;
>  
> -found:
>  	if (!refcount_dec_and_test(&rule->refcnt))
>  		return;
>  
>  	mlx5_del_flow_rules(rule->handle);
>  	mlx5_chains_put_table(chains, 0, 1, 0);
>  	mlx5_modify_header_dealloc(esw->dev, rule->mh);
> -	list_del(&rule->list);
>  	kfree(rule);
> -	e->recirc_cnt--;
> +	e->recirc_rule = NULL;
>  }
>  
> -static int mlx5_create_indir_recirc_group(struct mlx5_eswitch *esw,
> -					  struct mlx5_flow_attr *attr,
> -					  struct mlx5_flow_spec *spec,
> -					  struct mlx5_esw_indir_table_entry *e)
> +static int mlx5_create_indir_recirc_group(struct mlx5_esw_indir_table_entry *e)
>  {
>  	int err = 0, inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
> -	u32 *in, *match;
> +	u32 *in;
>  
>  	in = kvzalloc(inlen, GFP_KERNEL);
>  	if (!in)
>  		return -ENOMEM;
>  
> -	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS |
> -		 MLX5_MATCH_MISC_PARAMETERS | MLX5_MATCH_MISC_PARAMETERS_2);
> -	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
> -
> -	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version))
> -		MLX5_SET(fte_match_param, match, outer_headers.ip_version, 0xf);
> -	else
> -		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ethertype);
> -
> -	if (attr->ip_version == 4) {
> -		MLX5_SET_TO_ONES(fte_match_param, match,
> -				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
> -	} else if (attr->ip_version == 6) {
> -		memset(MLX5_ADDR_OF(fte_match_param, match,
> -				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
> -		       0xff, sizeof(struct in6_addr));
> -	} else {
> -		err = -EOPNOTSUPP;
> -		goto out;
> -	}
> -
> -	MLX5_SET_TO_ONES(fte_match_param, match, misc_parameters.vxlan_vni);
> -	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
> -		 mlx5_eswitch_get_vport_metadata_mask());
>  	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
> -	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX);
> +	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX);
>  	e->recirc_grp = mlx5_create_flow_group(e->ft, in);
> -	if (IS_ERR(e->recirc_grp)) {
> +	if (IS_ERR(e->recirc_grp))
>  		err = PTR_ERR(e->recirc_grp);
> -		goto out;
> -	}
>  
> -	INIT_LIST_HEAD(&e->recirc_rules);
> -	e->recirc_cnt = 0;
> -
> -out:
>  	kvfree(in);
>  	return err;
>  }
> @@ -366,6 +235,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
>  	}
>  
>  	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +	flow_act.fg = e->fwd_grp;
>  	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
>  	dest.vport.num = e->vport;
>  	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
> @@ -384,7 +254,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
>  
>  static struct mlx5_esw_indir_table_entry *
>  mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr,
> -				  struct mlx5_flow_spec *spec, u16 vport, bool decap)
> +				  u16 vport, bool decap)
>  {
>  	struct mlx5_flow_table_attr ft_attr = {};
>  	struct mlx5_flow_namespace *root_ns;
> @@ -412,15 +282,14 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
>  	}
>  	e->ft = ft;
>  	e->vport = vport;
> -	e->ip_version = attr->ip_version;
>  	e->fwd_ref = !decap;
>  
> -	err = mlx5_create_indir_recirc_group(esw, attr, spec, e);
> +	err = mlx5_create_indir_recirc_group(e);
>  	if (err)
>  		goto recirc_grp_err;
>  
>  	if (decap) {
> -		err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
> +		err = mlx5_esw_indir_table_rule_get(esw, attr, e);
>  		if (err)
>  			goto recirc_rule_err;
>  	}
> @@ -430,13 +299,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
>  		goto fwd_grp_err;
>  
>  	hash_add(esw->fdb_table.offloads.indir->table, &e->hlist,
> -		 vport << 16 | attr->ip_version);
> +		 vport << 16);
>  
>  	return e;
>  
>  fwd_grp_err:
>  	if (decap)
> -		mlx5_esw_indir_table_rule_put(esw, attr, e);
> +		mlx5_esw_indir_table_rule_put(esw, e);
>  recirc_rule_err:
>  	mlx5_destroy_flow_group(e->recirc_grp);
>  recirc_grp_err:
> @@ -447,13 +316,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
>  }
>  
>  static struct mlx5_esw_indir_table_entry *
> -mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_version)
> +mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport)
>  {
>  	struct mlx5_esw_indir_table_entry *e;
> -	u32 key = vport << 16 | ip_version;
> +	u32 key = vport << 16;
>  
>  	hash_for_each_possible(esw->fdb_table.offloads.indir->table, e, hlist, key)
> -		if (e->vport == vport && e->ip_version == ip_version)
> +		if (e->vport == vport)
>  			return e;
>  
>  	return NULL;
> @@ -461,24 +330,23 @@ mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_ver
>  
>  struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
>  						 struct mlx5_flow_attr *attr,
> -						 struct mlx5_flow_spec *spec,
>  						 u16 vport, bool decap)
>  {
>  	struct mlx5_esw_indir_table_entry *e;
>  	int err;
>  
>  	mutex_lock(&esw->fdb_table.offloads.indir->lock);
> -	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
> +	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
>  	if (e) {
>  		if (!decap) {
>  			e->fwd_ref++;
>  		} else {
> -			err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
> +			err = mlx5_esw_indir_table_rule_get(esw, attr, e);
>  			if (err)
>  				goto out_err;
>  		}
>  	} else {
> -		e = mlx5_esw_indir_table_entry_create(esw, attr, spec, vport, decap);
> +		e = mlx5_esw_indir_table_entry_create(esw, attr, vport, decap);
>  		if (IS_ERR(e)) {
>  			err = PTR_ERR(e);
>  			esw_warn(esw->dev, "Failed to create indirection table, err %d.\n", err);
> @@ -494,22 +362,21 @@ struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
>  }
>  
>  void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
> -			      struct mlx5_flow_attr *attr,
>  			      u16 vport, bool decap)
>  {
>  	struct mlx5_esw_indir_table_entry *e;
>  
>  	mutex_lock(&esw->fdb_table.offloads.indir->lock);
> -	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
> +	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
>  	if (!e)
>  		goto out;
>  
>  	if (!decap)
>  		e->fwd_ref--;
>  	else
> -		mlx5_esw_indir_table_rule_put(esw, attr, e);
> +		mlx5_esw_indir_table_rule_put(esw, e);
>  
> -	if (e->fwd_ref || e->recirc_cnt)
> +	if (e->fwd_ref || e->recirc_rule)
>  		goto out;
>  
>  	hash_del(&e->hlist);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
> index 21d56b49d14b..036f5b3a341b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
> @@ -13,10 +13,8 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir);
>  
>  struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
>  						 struct mlx5_flow_attr *attr,
> -						 struct mlx5_flow_spec *spec,
>  						 u16 vport, bool decap);
>  void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
> -			      struct mlx5_flow_attr *attr,
>  			      u16 vport, bool decap);
>  
>  bool
> @@ -44,7 +42,6 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir)
>  static inline struct mlx5_flow_table *
>  mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
>  			 struct mlx5_flow_attr *attr,
> -			 struct mlx5_flow_spec *spec,
>  			 u16 vport, bool decap)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
> @@ -52,7 +49,6 @@ mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
>  
>  static inline void
>  mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
> -			 struct mlx5_flow_attr *attr,
>  			 u16 vport, bool decap)
>  {
>  }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index c981fa77f439..4eeb2dcbfc0f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -179,15 +179,14 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
>  
>  static int
>  esw_setup_decap_indir(struct mlx5_eswitch *esw,
> -		      struct mlx5_flow_attr *attr,
> -		      struct mlx5_flow_spec *spec)
> +		      struct mlx5_flow_attr *attr)
>  {
>  	struct mlx5_flow_table *ft;
>  
>  	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
>  		return -EOPNOTSUPP;
>  
> -	ft = mlx5_esw_indir_table_get(esw, attr, spec,
> +	ft = mlx5_esw_indir_table_get(esw, attr,
>  				      mlx5_esw_indir_table_decap_vport(attr), true);
>  	return PTR_ERR_OR_ZERO(ft);
>  }
> @@ -197,7 +196,7 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
>  			struct mlx5_flow_attr *attr)
>  {
>  	if (mlx5_esw_indir_table_decap_vport(attr))
> -		mlx5_esw_indir_table_put(esw, attr,
> +		mlx5_esw_indir_table_put(esw,
>  					 mlx5_esw_indir_table_decap_vport(attr),
>  					 true);
>  }
> @@ -235,7 +234,6 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
>  		  struct mlx5_flow_act *flow_act,
>  		  struct mlx5_eswitch *esw,
>  		  struct mlx5_flow_attr *attr,
> -		  struct mlx5_flow_spec *spec,
>  		  int i)
>  {
>  	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
> @@ -243,7 +241,7 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
>  	dest[i].ft = attr->dest_ft;
>  
>  	if (mlx5_esw_indir_table_decap_vport(attr))
> -		return esw_setup_decap_indir(esw, attr, spec);
> +		return esw_setup_decap_indir(esw, attr);
>  	return 0;
>  }
>  
> @@ -298,7 +296,7 @@ static void esw_put_dest_tables_loop(struct mlx5_eswitch *esw, struct mlx5_flow_
>  			mlx5_chains_put_table(chains, 0, 1, 0);
>  		else if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
>  						     esw_attr->dests[i].mdev))
> -			mlx5_esw_indir_table_put(esw, attr, esw_attr->dests[i].rep->vport,
> +			mlx5_esw_indir_table_put(esw, esw_attr->dests[i].rep->vport,
>  						 false);
>  }
>  
> @@ -384,7 +382,6 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
>  		      struct mlx5_flow_act *flow_act,
>  		      struct mlx5_eswitch *esw,
>  		      struct mlx5_flow_attr *attr,
> -		      struct mlx5_flow_spec *spec,
>  		      bool ignore_flow_lvl,
>  		      int *i)
>  {
> @@ -399,7 +396,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
>  			flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
>  		dest[*i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>  
> -		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr, spec,
> +		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr,
>  						       esw_attr->dests[j].rep->vport, false);
>  		if (IS_ERR(dest[*i].ft)) {
>  			err = PTR_ERR(dest[*i].ft);
> @@ -408,7 +405,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
>  	}
>  
>  	if (mlx5_esw_indir_table_decap_vport(attr)) {
> -		err = esw_setup_decap_indir(esw, attr, spec);
> +		err = esw_setup_decap_indir(esw, attr);
>  		if (err)
>  			goto err_indir_tbl_get;
>  	}
> @@ -511,14 +508,14 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
>  		err = esw_setup_mtu_dest(dest, &attr->meter_attr, *i);
>  		(*i)++;
>  	} else if (esw_is_indir_table(esw, attr)) {
> -		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
> +		err = esw_setup_indir_table(dest, flow_act, esw, attr, true, i);
>  	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
>  		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
>  	} else {
>  		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
>  
>  		if (attr->dest_ft) {
> -			err = esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
> +			err = esw_setup_ft_dest(dest, flow_act, esw, attr, *i);
>  			(*i)++;
>  		} else if (attr->dest_chain) {
>  			err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
> @@ -727,7 +724,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
>  	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  	for (i = 0; i < esw_attr->split_count; i++) {
>  		if (esw_is_indir_table(esw, attr))
> -			err = esw_setup_indir_table(dest, &flow_act, esw, attr, spec, false, &i);
> +			err = esw_setup_indir_table(dest, &flow_act, esw, attr, false, &i);
>  		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
>  			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
>  							       &i);
