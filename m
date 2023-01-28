Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDADF67F2CB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjA1AK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjA1AK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:10:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4828C2692
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674864644; x=1706400644;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xWSrWnO1ps59EmVKkOJyArmaFGjaGXsZiJ9PpZodaEQ=;
  b=gXK2Slmi6rboRVTwIUY9z19RKfRqwoPFOuSf9qOOwQPuvVYUhGoRBeph
   rU5wlwD8cJAa6wR+2QZ3xExlx1sO/6F7HgmGIirg/DKZvEfHCK6c1SNxy
   IJehsmpX9XGjpyMQokSqNXDh/eUfm0PJIBMFiZTS6rEdB1Ay99HOLT0Wz
   VKfShdNeYBYswSwmFK4mLnPZkelEtmP5WOlBhvBpc0LW2W8Q+FSXE4747
   bpJqE5xA15MG6vzAxN4L49CLtjapOuYPcX4vAchxMoBQUK1KtOa8dex6U
   bZ3AIfBtVRSzZMoNdP1SR3H+PlXDZjX3oSGkZmSPFdHU3PRELD6N+KU1T
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="329356253"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="329356253"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 16:09:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="837304938"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="837304938"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 27 Jan 2023 16:08:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 16:08:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwJaKQSnRUp7m15lXPRy754jTOeCYGe9AIoYBcdB3P3U14m9Ali1eDsUzFxOxbcfdylX6TJWt+sdPu0PFle1k0A15eHgEHjJI6/IVt+w3zamny9NxSsue6jJjWlnQHYkWjAYDTwVzH1SGO+cMDBaoupNHlKcpF+SdfKt6g6L4xUd5PBCg3oKTELWvISvQZjI+J351ejuknqUil6zSkDn6X6oYmoFiagS5fqtRATgd7iXjmaDn+ALHuMDPEiRy8s/Huq3al4ZUNw2SMij+7RIjyB7RjBlONt8A5d7ejzx3OEQ6zkRy5ZGJQsxjzGfzMCCdihvQO3gLuiv4UnbjOehbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQWCbZZ8OEyDK1paGGQJACeBDpew75FqEt7YtlV81QE=;
 b=FRaUy9cGYmylOhNnmCGM6ft9v0RtFZp0Y4SQ5v2pDtriDGdiRxnuqh9o3wVb4e8xoS5rUTyoSGgJyOc1N6KwOLj7qRXtwbOQ/THuXMj5aORXUeidVhD8zKGDiXkOVZHhyfU/I4Mr2/4odqiDbuO+fI0Oj8YbWc7cOZCHLNhXTulZo1scyHJDTlyXu55483b9ay6jHiu+kIOdnFNOQzr2vuLS5E2n6HpKpggk+LRLChiEriYwK/s2OinnYWfcmHNebeOueEy2DoNjm/W94mjVfPEcyuKfMq9d0ht8C7uJhwFFW3HwovTi315KnWk63nXLgjrcupq9udhstG3agDUdAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA0PR11MB7751.namprd11.prod.outlook.com (2603:10b6:208:43a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 00:08:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 00:08:51 +0000
Message-ID: <6e0c608a-fa54-6943-7b33-0f5520fef5f4@intel.com>
Date:   Fri, 27 Jan 2023 16:08:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 3/3] devlink: remove devlink features
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>, <gal@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>
References: <20230127155042.1846608-1-jiri@resnulli.us>
 <20230127155042.1846608-4-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230127155042.1846608-4-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:332::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA0PR11MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: 35cfe575-244b-4c37-1b75-08db00c3d5e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7GXHKNBk8Z1WKTFJkvB/wPIpxZi83IlHxDze/yfwzIH7Wl0KODsPKUb0YON9rE9qT+2kxQDc1H9MM2ADJoaikooMRa4EO9ox4BKvhzs8XD97bDhmDbFwtwplZl7HKPKZxHGBFksYQ2xv3Z9bB4LCyPyFm0u4W6+jI850w1NUYfqX9IIKnyNfgKOVSsj8GYSrLocOMzePOx4AX14ctGWin8u1OD9T3OElGn55L1qFytfgmzuMv16KHICBQyRc93ScMapcOCyVBEX0j/F9wesrtNQ9Ni2XcXVzDNzJ2aasojwb+9iLWwvFlBFc/8HJCvZL3mn4G7unUY8Dqep0ntQolIUMBcLM2PHopKmAyMEbAUS/P39eGbUxokaNN4n9W5+zIvj3mfXN1wWIu1/tVQ6UW4WNqbRJzRPlpD8wuw/uTWHSxgNt3rXPVEmgFGohZ0HsLNB8ZH4Ez3HFsbbywr0PAwa7p2zT42jhnSjQx4+RXZt8xxbczNsnUAR9tvF8TuQDNm6/WOevUBMtQux4NMHiWz/YXaPEiENdoL/CH/ZuGuwjL+R4QOlKtsKoC7RLHL0nknnwWbn1fQqT6XcyXSo9UjT/xTk/UZyK9pSKya3fwqPhJTh3PYgaCaO31FcPE/NQPFG8SVKvhcNTKlFZe5hk4FeDfS4ZVuZVRzT1DudwUX2DbQX0HKbqXF4dbVM9u/m2/t6j6IzlVf03SH/eFw1ApHBVHPXofacRpNNmmoj6eIvZ8Q7ZYCWV/1zTok+xMoDAfjDYh2I+EaZhj6LZ/ZIM0eqP8AkTQmwWL6L7pxu+mU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199018)(82960400001)(186003)(6506007)(2906002)(53546011)(31686004)(6512007)(26005)(38100700002)(36756003)(478600001)(2616005)(8936002)(41300700001)(66946007)(316002)(86362001)(31696002)(6486002)(83380400001)(8676002)(4326008)(6666004)(66476007)(66556008)(5660300002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rzdyblh0WXBJMGwyMHh4K2NhMC91UW9wdThtWlFpcUVRK1lsa09ybGo4aStH?=
 =?utf-8?B?bHNqa2FGSFdMM1BqS0dzYXF2NldFMjhvMzZMcDBuQS9LMldlVzBQZTdsRUsz?=
 =?utf-8?B?Ry9EWnB5ekxwa0Vpb3RCMTBranlLWVZLUGVFeW84anpDNGFjM1RMNlpnVHVE?=
 =?utf-8?B?NXpQZnFzN3hSd0xmUkZyU3hnLzBWUk9aZkNMMGI3clpNbUpEQkQrSjZMZk5j?=
 =?utf-8?B?VkpwU2JhM3ZaZ3dvZG4xNmpTSGh1SHdBSlpWMWNoNXh4MldBbGp5T2JMUWcr?=
 =?utf-8?B?eGpsaWkzczE2NU5JVTEyMjNHeWRwL245dENSYllJb2NDeW4vS0NJZG5TRFlj?=
 =?utf-8?B?NEZGSUI2VHRyVG4rVWRiKzI4MTZ4SklsUEgvTVVjcHZpMnN4MjBTb0dFaHFL?=
 =?utf-8?B?TkZpN2I3UTI1VUpCUGpNbk1NWlY1L25xVFU0K1lKR09WbTF6Mzl1SzE5NFFE?=
 =?utf-8?B?b0d6V0JDT1ZkSHlJbGdoOEhqN2pVUDlUTDczSGtCNzNwcGk2SVhVSFlpaG4x?=
 =?utf-8?B?c1JOdEN6dmZjTUhtY1NWNEw2YmUraXQ2bDN3bDFlRFh2WkV0dHUrTTJwU0s0?=
 =?utf-8?B?a3N6djBCSzdBTGY5bDlVSVpYdUljOTdxYkl5d0E0UVZERFhjaGZlTnRLNUpE?=
 =?utf-8?B?K25RcUJVcGlRL1FsMTRJb0dNMm90UEY2ZEk4SUZkeWNGL1JzNlV1Tlhhc0Ey?=
 =?utf-8?B?bWlIN2lCUk1kREtqUzRIdHNiYktZdE1JRE9GeXJFcjYzWGlGR2xCSlRubVUr?=
 =?utf-8?B?c29FSGs2RGdhMVFNVXVqUXNDazBXYkpuam1KNm9NbDB6NkVSVnoybWozTlFW?=
 =?utf-8?B?QkJxWHlqMWxNaTlGcE5WY1ZabUJsb1VsRnA3RVdnMEY1bmFnejROV1NuQzE5?=
 =?utf-8?B?MDVlc2xXWHRrMUlWL2d6UjZqVHhKNWtpbHpoQU9yQ2FBb01icWwxbDlyM1lN?=
 =?utf-8?B?U0pldXlRZnE1UkRQVXJEbDBFTy9BdTZFbGFENmNKK29jdjVYOUFtd0NwL2NN?=
 =?utf-8?B?WEV5N0xuYUJIMVZPRldSTGdLK2dTNU0rdzJLcmk0RncxUkdxWCtSS0hWYmF6?=
 =?utf-8?B?Slh5RmZ2SGs4WXNGa0I5MDJoYm5ncGlTV2ZqNkpCa0JmYzJSckFkVERNeFNF?=
 =?utf-8?B?OUMxVDBEV3VGZEIvSWZDVFNraitwRC9rTVRjS1ZWQlNNRWVBUHBRbmdxYTV1?=
 =?utf-8?B?Ty9yQmoxamZKZjhISnFRUVRHQkU5VnhKUko4UStrVHUrdm9xL3o3OHlwR2dC?=
 =?utf-8?B?R005MFEzUk12dStCQ2VDYVhKMGl1QmI4Uzh6MWdIaU56YzRpekVJL1R4b3lL?=
 =?utf-8?B?QXY1K3BrUjRlUmtuVytHU2R1M0g0U3BWUytMKzNIbUVIMTdLM3gyWUxuY0ha?=
 =?utf-8?B?c2I0ZWxVYUlySDZhWG11UVBxemJ2SitmQmc0V0FkQlFXMk41NzBGZG1tM2NS?=
 =?utf-8?B?TTJ3NlF5Y0lhQlN4Qm1LWk4zUWUxdHVkYUV0ZEthUXBoaFZ2Vjc3MWU3aWlt?=
 =?utf-8?B?Nll5K3FtTkw4VkMrOVE3cytCUWEzYnA2OW56Ylp5S2s2VnBkWkloeWMxZ0J1?=
 =?utf-8?B?dnAwajhLanFhd3NFS2VrR2lQdUl5a2czbmVlb2pZTmJDZFpPSUcraEthTDRU?=
 =?utf-8?B?Q1NLUyt1ODdWVXRvaGk3dGc4YmFxeFdUNklxZjVxRVVCSWJId0V5OW1ScmhB?=
 =?utf-8?B?T3ZDbHhLV3FvVGQ2cDBjbTAybXNiL2hIZDZSUEJCVHlHQlNDTnpHT0R5Rnk0?=
 =?utf-8?B?a013SVlhUlJDeDNReFcrdEllOXJXVEphK3dPdlJXeStFbVdUaW1kRGdmbUQ5?=
 =?utf-8?B?QmdBV1MxZjd5aUc4cDYyeWlXOFNWeGFsUUpZYjZuUkpNYVhGWFllQjY3cWFT?=
 =?utf-8?B?bWRDYVhDRzRWdEZwN0lzNmVRZlp6dHVtZUhjRFR2WC9pK0pGVmxBalFzb1RD?=
 =?utf-8?B?eElBNjRuaExLTmI3WnE4ME9XS1JYeUFCOFpUbWU3ck9HK1VFRmpsM25iWkI3?=
 =?utf-8?B?Y3lzNW5valBxWWFyWkVIZ2J4bXpJNmNZUW1MRVBxdlEzTGVSTyt1UVRZbXg5?=
 =?utf-8?B?OW5hcVY4S1NyZVRNS0JZMTNrUkVTLytzdUN4ZzRvSzVra2JISW9UQUkzRDJB?=
 =?utf-8?B?SEhNSGhQcjhtTXErbUZ6WFNHU3hXZHhNVzlDVUZiNGZTMDhDSVhYMXdIRnIy?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35cfe575-244b-4c37-1b75-08db00c3d5e6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 00:08:51.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGkQLVDRiRV9q5F3ume1ewlEG1cJbjlV8Zeh6lfCS5lA558eSMdZeNX9t20W9VhWsTQzgPEoUgkhSo8eSdkz27JOgINufwAgm/HOyYHYzEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 7:50 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Devlink features were introduced to disallow devlink reload calls of
> userspace before the devlink was fully initialized. The reason for this
> workaround was the fact that devlink reload was originally called
> without devlink instance lock held.
> 
> However, with recent changes that converted devlink reload to be
> performed under devlink instance lock, this is redundant so remove
> devlink features entirely.
> 
> Note that mlx5 used this to enable devlink reload conditionally only
> when device didn't act as multi port slave. Move the multi port check
> into mlx5_devlink_reload_down() callback alongside with the other
> checks preventing the device from reload in certain states.
> 

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++----
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
>  drivers/net/netdevsim/dev.c                   |  1 -
>  include/net/devlink.h                         |  2 +-
>  net/devlink/core.c                            | 19 -------------------
>  net/devlink/devl_internal.h                   |  1 -
>  net/devlink/leftover.c                        |  3 ---
>  12 files changed, 6 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 26913dc816d3..8b3e7697390f 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -1303,7 +1303,6 @@ int bnxt_dl_register(struct bnxt *bp)
>  	if (rc)
>  		goto err_dl_port_unreg;
>  
> -	devlink_set_features(dl, DEVLINK_F_RELOAD);
>  out:
>  	devlink_register(dl);
>  	return 0;
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> index 3d3b69605423..9a939c0b217f 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
> @@ -114,7 +114,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
>  	priv->hdev = hdev;
>  	hdev->devlink = devlink;
>  
> -	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  	devlink_register(devlink);
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> index a6c3c5e8f0ab..1b535142c65a 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
> @@ -116,7 +116,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
>  	priv->hdev = hdev;
>  	hdev->devlink = devlink;
>  
> -	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  	devlink_register(devlink);
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index ce753d23aba9..88497363fc4c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -1376,7 +1376,6 @@ void ice_devlink_register(struct ice_pf *pf)
>  {
>  	struct devlink *devlink = priv_to_devlink(pf);
>  
> -	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  	devlink_register(devlink);
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 6152f77dcfd8..277738c50c56 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -4031,7 +4031,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto err_params_unregister;
>  
>  	pci_save_state(pdev);
> -	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  	devl_unlock(devlink);
>  	devlink_register(devlink);
>  	return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index 95a69544a685..63fb7912b032 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -156,6 +156,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (mlx5_core_is_mp_slave(dev)) {
> +		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported for multi port slave");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (pci_num_vf(pdev)) {
>  		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
>  	}
> @@ -744,7 +749,6 @@ void mlx5_devlink_traps_unregister(struct devlink *devlink)
>  
>  int mlx5_devlink_params_register(struct devlink *devlink)
>  {
> -	struct mlx5_core_dev *dev = devlink_priv(devlink);
>  	int err;
>  
>  	err = devl_params_register(devlink, mlx5_devlink_params,
> @@ -762,9 +766,6 @@ int mlx5_devlink_params_register(struct devlink *devlink)
>  	if (err)
>  		goto max_uc_list_err;
>  
> -	if (!mlx5_core_is_mp_slave(dev))
> -		devlink_set_features(devlink, DEVLINK_F_RELOAD);
> -
>  	return 0;
>  
>  max_uc_list_err:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index f8623e8388c8..42422a106433 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -2285,7 +2285,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>  	}
>  
>  	if (!reload) {
> -		devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  		devl_unlock(devlink);
>  		devlink_register(devlink);
>  	}
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index f88095b0f836..6045bece2654 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1609,7 +1609,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>  		goto err_hwstats_exit;
>  
>  	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> -	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  	devl_unlock(devlink);
>  	return 0;
>  
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index ab654cf552b8..2e85a5970a32 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1645,7 +1645,7 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
>  {
>  	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
>  }
> -void devlink_set_features(struct devlink *devlink, u64 features);
> +
>  int devl_register(struct devlink *devlink);
>  void devl_unregister(struct devlink *devlink);
>  void devlink_register(struct devlink *devlink);
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index 6c0e2fc57e45..aeffd1b8206d 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -125,23 +125,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
>  	goto retry;
>  }
>  
> -/**
> - *	devlink_set_features - Set devlink supported features
> - *
> - *	@devlink: devlink
> - *	@features: devlink support features
> - *
> - *	This interface allows us to set reload ops separatelly from
> - *	the devlink_alloc.
> - */
> -void devlink_set_features(struct devlink *devlink, u64 features)
> -{
> -	WARN_ON(features & DEVLINK_F_RELOAD &&
> -		!devlink_reload_supported(devlink->ops));
> -	devlink->features = features;
> -}
> -EXPORT_SYMBOL_GPL(devlink_set_features);
> -
>  /**
>   * devl_register - Register devlink instance
>   * @devlink: devlink
> @@ -303,7 +286,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>  	 * all devlink instances from this namespace into init_net.
>  	 */
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
> -		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
>  		devl_lock(devlink);
>  		err = 0;
>  		if (devl_is_registered(devlink))
> @@ -313,7 +295,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>  					     &actions_performed, NULL);
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
> -
>  		if (err && err != -EOPNOTSUPP)
>  			pr_warn("Failed to reload devlink instance into init_net\n");
>  	}
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index d0d889038138..ba161de4120e 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -38,7 +38,6 @@ struct devlink {
>  	struct list_head trap_policer_list;
>  	struct list_head linecard_list;
>  	const struct devlink_ops *ops;
> -	u64 features;
>  	struct xarray snapshot_ids;
>  	struct devlink_dev_stats stats;
>  	struct device *dev;
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 4f78ef5a46af..92210587d349 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -4387,9 +4387,6 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  	u32 actions_performed;
>  	int err;
>  
> -	if (!(devlink->features & DEVLINK_F_RELOAD))
> -		return -EOPNOTSUPP;
> -
>  	err = devlink_resources_validate(devlink, NULL, info);
>  	if (err) {
>  		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
