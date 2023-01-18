Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47765672A9B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjARVfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjARVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:35:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E1618A9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077735; x=1705613735;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k4zzZZw8glVWWZXjXI3Ej0u79qifT5QOsw8G90eZGJI=;
  b=cUsTVprVpx9CYB5JELG9PVzaLqmNteJFqlZ1BTysekRvN3aFD9tiZaK5
   uS01MYYVdvynuRxi4ZtD8gnbKqgzaLmQSUwvxYwQgLm0k4ibpkGnDkLgE
   vVJ+v0hykkXFbsBOg9/H+qgpwzouxJVzLpwbJmUh92sWB6itKgaAVnnq6
   bDZB0KnbD6BqjN9rPq0rchJcC0eKtQg+yk2KOCCjYMYp0uYt84KGfUp2Q
   d1zpJec4IWYbY+2oUbHia4urkLYU9N5jQKPwEWTe2mDOHrTC27z8ZS23T
   phKeUD6kQOJkSGqNutAGt8ApF64GswSKFGLeccYmY0qXmtX+Cmv6p/p/N
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352359558"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352359558"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:35:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905277128"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905277128"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 13:35:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:35:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:35:34 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:35:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=falgdf7eKWSYyukCcv1UWk4QfEbtg5Avlhkhd6JR21jiP9cjD1umQUYy3B5NwFxGde5jW/Xb79GtYwv//aWTSEaWj+7CkTM7syjiVOE+QKTjnz808KUD34b8llCLesJrRjua6gudkQTWFmcg0uQ8rB/N0928y95PwTibymPCBeodjMsYndNWWuOsusyVDEbDipGfAuOKlGKP+ugOkUehgqnnF8SRExB+BNEaIayRgpQrHbMosrxcXonW1QhWRGF7swltDU5TdWDw/D+xTnRN6fBM+HVFtnTgJoxXRrbijBK3+YgCcKFjHq/cw8drZTNKPCN1QYvUjfRX1fCYnNW6eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5podg5SK04IXZFFUo8KNygGhzvGKCz5UmVM4ROdr9bo=;
 b=Jqul0h2eKrnaiNktmPjzS+xUQVMQ+ehG/ogYC7o9KlTX53nxpiw+WOCEeRQu/ikshWzNEfRf19OVlz9cjh+6rRMWwHeZKbq7mRg9Yi7QxxMVhXtVK9GvWoxCz2pXXdnIR81gxIMrq6cYcXe29GS1Io44vZtuAPeXFkBs4OxrAlAK22jP7G5VSA4qHmpe4enR5siDsYo4c8LOfLFlLk5p0+Ym8CJLwuh1824fc7Swb4HBZen4Se9RR+2fuEBYZLzHqQNbP7x9YC8HUBNGVVGNBYXitX2CaX8wioI3l1LK4ZfTazPcl+VAsYIw/KVvliI32SHWdACDGInQYWpHXDvqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6886.namprd11.prod.outlook.com (2603:10b6:303:224::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:35:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:35:32 +0000
Message-ID: <725bf5eb-ce75-413f-fe41-3ba9c9872e20@intel.com>
Date:   Wed, 18 Jan 2023 13:35:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 04/15] net/mlx5: Add hardware extended range support
 for PTP adjtime and adjphase
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-5-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-5-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed4fc98-d09d-4425-ff2a-08daf99bed72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+mWoVkMu6v9HOtKsU9wAEUuZ4AciM2AvMOSoRf1wtdNlXnvvkfRJS6hbwxVrcmG4YTzCgbw0QbHkZpsP58+nfWbRDl63gX2iZOcx6Xf9/1vPUL13nhGP5z/eYJTupkZe2qhu386a/D7jcl3yztMBwNDtfixSqU06lTZvQQe2U6Muj2hLhWau5rTqXZ2wCnCNQt07vZY3oifdSFE5gZ3+aBYI+JwSHo4EYA9rb8DN7XsyOBUmUrjstYErdFvWNyj1E2SL5MctV7DNA1y3vOsaGaOE6BG1AkWt5TkTymgKMgAXeP0vbW1Xe/As2oheSVn20/RyH7qo0IkU5u9RPROH1DBtPcBz8+CL0dgg8X92M+h24wKhdtevs6ZNsp/TYFW8Tq+kbQ9C6FLorI603n++KES4RVIsJx8cCfdgzStpSaG8FKn3673Qq8GDubHC68kPOC6TKYCRyxzNhOhqFhYbwV7xufWY0Qofh4Cwxet/YXsc/eY/VxCtHpBXWs1moKiQBOgnYubejULja57VryojoV5X3mNEuUFoQ+l9ncGAXJ07RhDnjNKtPSU0cmSZV1QQ0jImeCYOtLc6dgfCJO2os+92McPbYAwO6MT3ecQ4eSyyAYq1k7Lu33EBv7HfpOTVA+029SXt7MswyvXs+dc/k5ii7ZxjUlnQH2SHCFGv4udsB1AvES8cwoCoYjXqSH1M23wWzZFx9FYQEfdZG1jT8s0WDYG0ZZcd/ed1wNAVO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(53546011)(6506007)(6486002)(26005)(186003)(6512007)(478600001)(2616005)(31686004)(110136005)(66476007)(8676002)(66946007)(4326008)(66556008)(54906003)(41300700001)(316002)(83380400001)(5660300002)(8936002)(7416002)(2906002)(31696002)(38100700002)(86362001)(82960400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDNndXFUbmhrTUF6OHRsa3hIc1lkMnNuUjBUaXNRVGVvblJueFc2ZDMyV0xQ?=
 =?utf-8?B?THBwQ0lVNnkyTGMwbCtSNnlrdHlpSU1TcytDc1JRTXRKQzFCdzRUa3NwQU81?=
 =?utf-8?B?VzlMRktCblFRWEhNak1DOFJlTzR3dVhLSkdEcE4wY1lKYkdvUFpaalNuTlJ1?=
 =?utf-8?B?ZndiZytLNFY4WmZtKzBQdW85a0dHekpxUkNVZ0hyYzlMa3hZWUNGSFd3S09S?=
 =?utf-8?B?VzdaYnhEYS9XN2pmK3Nqa05tMkpxbTVlb015eEVJbXFmZ1A2M1BwbTN5OWNr?=
 =?utf-8?B?YWtwWVB1WmVDK3A5WkU1UThZdjlUeUdFWGZ2Z1VtYmsvY3hWUERxT01oQ05o?=
 =?utf-8?B?b2gxTG9KalkyeU9FS1VEZjVYYUdPSDFBb09tcXZseEdaL2JBVDFOQ2JFOUdR?=
 =?utf-8?B?Ny9YL3lBYW1wTGhROGhnZC8rYzVPQTZ6QktOYjlPVXZ1dkFCL0dZdXRzelBi?=
 =?utf-8?B?eWluVUxoaUVFSVJUY3pUSDFRZytWc0dTOFZHWk5aVVl1ako4eFl3MDBGT1hM?=
 =?utf-8?B?Z08zbGNQL3NBNncvNXJzalgwc2NwSFI1dEhBQlU3UDJ6UVBmLzE0YktpQ3VK?=
 =?utf-8?B?b2RwdVYyOHoxOUR6YkVvOVJ2cVFaTVE0R0NJazVUbUl4QWtZeHlScUs5QlYz?=
 =?utf-8?B?eEFjTXMzRXV4OU9OMGRqOWpsTXh0dis1eWZXWGtEcGdLZVBudUpyY1BDNmJW?=
 =?utf-8?B?eWJxWDlYM0x6TTM2dm5nc29RTFc3QUNiRTJhdUVJbGFxM2tRemJXWXFmWjFY?=
 =?utf-8?B?cDRrdktneFFnVjhRSldnMm5yaHRJMFBnOW5aSVNISForTHkySDdWdENiYnBN?=
 =?utf-8?B?RVkzZHRKUm1RQk1PeW51STV1TjN6ZGJucEVVQitlWnpUTFhMbXJQSkFSZ3RQ?=
 =?utf-8?B?eUtPMkgvVGRlYW1XREkraVYxYVRrcnRWcU4xU0JvVFVYdEpXT1pXdGsyMjZR?=
 =?utf-8?B?Nis1LzZhbWhNS0JrR2t6Sm9YbGJRajVpUDBNVDF2dWJKbWExanR5R2Q3N0R0?=
 =?utf-8?B?ZjRhWXorakV6c0ttSU4wQ0VRUDZKcE15N0p1a3VzdDFmN2tjV0QzbGxmL2lU?=
 =?utf-8?B?d1QwQWkrYUhLMjJjQ2tqUVlKVnprNnNQNWh0cE5JSDYyYjltblM2cUtKTmtS?=
 =?utf-8?B?eU0xcWlkR0pZbi9SODJlVXk3bGd5YmhCaUc0eStWSVZDOVVEMGhicDNmMjhx?=
 =?utf-8?B?UWtvN25NOVlibUlWNURaKzIyQWgwMWRqdjRZRHNhNVVxQ1BMSlFDTjQ1dlRl?=
 =?utf-8?B?V0pKVXN6bjVtUTBacXBTWjUxMGk3VlRwMEhuU0pJZXdsZVJUWGs3YWZPYWtZ?=
 =?utf-8?B?cDg4cHcrTDBUbnNFeDR1UDBxN21MVHpnTGFmbUJ3Wld1YWpPbFBydUY1c21j?=
 =?utf-8?B?NWg0S1lMTEkrU2N3YnVwSVdScUlNQm5zbGkydVB2aExmSjJSTCtNOGtJU3FV?=
 =?utf-8?B?dEVLazFsQjZWWWowSjRBeWhRZE5VVVNZRktVSzhkOXhlVy8vSG4xN2lxaUdB?=
 =?utf-8?B?ZXhYclFZR1VNMUF3dHkxZ1VXclB1eGk1dGFkeW52eFhpZ0hWejRmMmM2bGcv?=
 =?utf-8?B?TXRsVE51cGFNcG1paTg0NnFoSzFEQjVNTFR2d1BBT09EbDZBY3k1enZoSmY1?=
 =?utf-8?B?REJyWVRLaEpsc1o0Y2JmUnJUemJOdlFscGZuOVk3cHUrZmxkdXVmZElkMVlO?=
 =?utf-8?B?ODZGNjVUYlIyZFhha1RnUlVpK3RSRzVBR1lYRnRvWDVPZXZGbFAybm0xZFo0?=
 =?utf-8?B?ekxjNUJjZmV5STJqbGpmSlhkZ1NkbnFDUytzNFh5VEU2dVhaWjk3bTNyc09S?=
 =?utf-8?B?VVhQMGhHZzE1Q05razlRbHZZb1RCaE5KRXBWY0wrTDBkZG12Q3BTOWtaVXY5?=
 =?utf-8?B?T0xLRWNicGVIL3YxRGpLejBrSWE3UDIwaHlIU01Rcmh3Wk9NMHQrTEhNd1F0?=
 =?utf-8?B?NC8rQU9DV0RQTDdheWd2NWJzdHNaQW94a1k4RTBabjdTVEhJNjRteXllSGVm?=
 =?utf-8?B?WTBPdmNhb1F2aG1vMkF6aUxGMFdPdDBRc1J1MHRacmx4cTFxMDV5cTloMWoz?=
 =?utf-8?B?VEtRazFsVUJJS2dldUc2VlBWUW5oSVBFVmt3b0F1cjhvUVRGY3BNTW1pRkRG?=
 =?utf-8?B?T1p3U2hKK2E2SG5MQllDYUNmSmd0WUNDd2xETFVLZ2p3aEtpdGdBd1dFVXVQ?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed4fc98-d09d-4425-ff2a-08daf99bed72
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:35:32.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TH0eIbmuWizP/wLjeM+hc5O2tZcGykbhv2AV96PMqWGGxm6e414AMGnTMoQwiNL+/gm/eSlTrGqOaR9obdRXagSbXAHzU0WsM4B1NL3/I5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6886
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> Capable hardware can use an extended range for offsetting the clock. An
> extended range of [-200000,200000] is used instead of [-32768,32767] for
> the delta/phase parameter of the adjtime/adjphase ptp_clock_info callbacks.
> 
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  .../ethernet/mellanox/mlx5/core/lib/clock.c   | 34 +++++++++++++++++--
>  include/linux/mlx5/mlx5_ifc.h                 |  4 ++-
>  2 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> index ecdff26a22b0..75510a12ab02 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> @@ -69,6 +69,13 @@ enum {
>  	MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS     = BIT(0xa),
>  };
>  
> +enum {
> +	MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN          = S16_MIN,
> +	MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX          = S16_MAX,
> +	MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MIN = -200000,
> +	MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX = 200000,
> +};
> +
>  static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
>  {
>  	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
> @@ -86,6 +93,22 @@ static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
>  	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
>  }
>  
> +static bool mlx5_is_mtutc_time_adj_cap(struct mlx5_core_dev *mdev, s64 delta)
> +{
> +	s64 min = MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN;
> +	s64 max = MLX5_MTUTC_OPERATION_ADJUST_TIME_MAX;
> +
> +	if (MLX5_CAP_MCAM_FEATURE(mdev, mtutc_time_adjustment_extended_range)) {
> +		min = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MIN;
> +		max = MLX5_MTUTC_OPERATION_ADJUST_TIME_EXTENDED_MAX;
> +	}
> +
> +	if (delta < min || delta > max)
> +		return false;
> +
> +	return true;
> +}
> +
>  static int mlx5_set_mtutc(struct mlx5_core_dev *dev, u32 *mtutc, u32 size)
>  {
>  	u32 out[MLX5_ST_SZ_DW(mtutc_reg)] = {};
> @@ -288,8 +311,8 @@ static int mlx5_ptp_adjtime_real_time(struct mlx5_core_dev *mdev, s64 delta)
>  	if (!mlx5_modify_mtutc_allowed(mdev))
>  		return 0;
>  
> -	/* HW time adjustment range is s16. If out of range, settime instead */
> -	if (delta < S16_MIN || delta > S16_MAX) {
> +	/* HW time adjustment range is checked. If out of range, settime instead */
> +	if (!mlx5_is_mtutc_time_adj_cap(mdev, delta)) {
>  		struct timespec64 ts;
>  		s64 ns;
>  
> @@ -328,7 +351,12 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  
>  static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
>  {
> -	if (delta < S16_MIN || delta > S16_MAX)
> +	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
> +	struct mlx5_core_dev *mdev;
> +
> +	mdev = container_of(clock, struct mlx5_core_dev, clock);
> +
> +	if (!mlx5_is_mtutc_time_adj_cap(mdev, delta))
>  		return -ERANGE;
>  
>  	return mlx5_ptp_adjtime(ptp, delta);
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index a84bdeeed2c6..0b102c651fe2 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -9941,7 +9941,9 @@ struct mlx5_ifc_pcam_reg_bits {
>  };
>  
>  struct mlx5_ifc_mcam_enhanced_features_bits {
> -	u8         reserved_at_0[0x5d];
> +	u8         reserved_at_0[0x51];
> +	u8         mtutc_time_adjustment_extended_range[0x1];
> +	u8         reserved_at_52[0xb];
>  	u8         mcia_32dwords[0x1];
>  	u8         out_pulse_duration_ns[0x1];
>  	u8         npps_period[0x1];
