Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706C06DE7EA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjDKXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKXSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:18:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212892D73;
        Tue, 11 Apr 2023 16:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681255125; x=1712791125;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HFaEDqOb963rJoHslPiK14xwmi06htcodBRON+wHNIk=;
  b=YKyZ28z/cEprpO71NLaLKyGp6zGs4QTZLinVL3V2k1EF8MZH0XUh7Xuh
   RJVYMYsGnczdhpyaWF/p+Qjt9Uk9ppGGJFIHFULtiOSYcbtdklcX69ReZ
   LMvJi1Gf+JdzZfc6c+RcoXERsyFZt0FVDg1cKO1ZqJtxf5RaVIbQ3oxwf
   mrQN/VknHIXJa2qjvx0RhQS6Z3Te+7lSYHu+psbi8Y4PqVyKzsjjgqjMT
   DNUb6e/REtqkbkmutkOKdmjXPypbrFQg4b1/6Zzjp3nQhpC9TOpCkFOFt
   4zvbtuh3GyWKqa42PRpKHRCGzS2/kq04v0B6Kc1JvovtmUGCAsIm3aBT7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="341244090"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341244090"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:18:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778087423"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="778087423"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Apr 2023 16:18:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:18:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:18:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQxuYIvZ8N9IlWhXa2gx+B+2gR16GuQc4RAlQ8f9dQMdZxu3dd+SQvYw6GnsMEM/CIFXntxQNi+XWFwIz5D6JElv+1t7OoK+FvofJeZrnvA1YLRdrOrficX4FQ9tasPfvNwCekm0fLii20BuJeW525rxDCOLutQ0vim7AlmsesWU+wAPcji6jWglB1zYkEVSkAlOfhDN7/0sLuRBfgfq8x3Hsyxga4uZgpt6tQsOcHdB0OcKWvc/Zv7Mz02UVR2fFy+hyYUpGJkY2JEVQWBwrJw/URPNBTXDtBGhumiSPFLaTbBNUqVjdmYpcMIyeBzrDSwh4pmMI9G/R+xiaoNY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBLdAWpph9eGX9oTSAbXRprQGwrbQVZ5nBf6fKLzt+g=;
 b=jKWUyLAvE7sEDX+Kthn0NRJFGuHsAxwUTUVoMMTNsjRxEAmKhq6BWBoqOw/OjJcSZI+ZLDJDUge0S/wGSixC3Ak5/G8maN0QDovJzSUtRHAtiYVkaMkJ71SCrNoWvfYK6nH4HuEZzqs9nwKE4pb4SBWlvjF9a9KYrSS5n7NzSbR9gYEAuUErQrxvgDWDbMGf3o99GZ1cvg80AaaX2Wkox5dE5gbgqxpJ0/lnYc7W6RMxCWHfQhE1KALmfi9gtwLYANeEwik9V68C1fKQMMjRuawnthOCa5xqJxp9cZjv5ge6bl+ro3IKW7CtmbThJ5XdUmHxyjg9F7jmcOrOh0+u2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Tue, 11 Apr 2023 23:18:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:18:40 +0000
Message-ID: <8c9eb06c-28de-2e24-2758-9f5c913b36ab@intel.com>
Date:   Tue, 11 Apr 2023 16:18:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH rdma-next 2/4] RDMA/mlx5: Check
 pcie_relaxed_ordering_enabled() in UMR
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Avihai Horon <avihaih@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <8d39eb8317e7bed1a354311a20ae707788fd94ed.1681131553.git.leon@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <8d39eb8317e7bed1a354311a20ae707788fd94ed.1681131553.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a3eb3ef-ff50-4b3e-e557-08db3ae315e3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoenGI4SMfpZj+vZMI2MksPV0qwUCi4Kh48LepqM6RhcqLi/YcwV5JIHGnLca/SZReXH7qjhUW3fjvL99ixKLEUpfx8kA0vLPBnX/rdFn79w4+Yiz1FmzWzEFNMlYeeSPHDVnuKKX+hH/rnE11US55I+G9YJ9uscwlsxafKCu2bytUWK77uUBdig9k5bNRPUdxR2ktEKShz3RyX385VYSBvz4C/dPFHs9VVzhGTt2oD8c2WxUSxYQ55xWphgbm5wva/x3sguIco0xBT/+624l5oVSIUKNZaMX+E8ECkQHLC7h66KnCfb9zdee+zYmkvW0nTCVl+cA3fy8dc+KcwZf/wQ/KzHbs7wC9AUC/HMoQFk47Q/oeGqilyuArfebm4yHumDsRgKParJvfpxQmau52nkJkOqbcSSXKgq7SJqNPPxElnRaPdceiHCHblvSLsNi3UX13KlmwNFovlBI5XQt5FFXXNZZjE4qfhBNUis51TB+0Rtk+aM88CxM5NOZqhqw18LZC/NgMtMhq9ER3Bek2m/01gKz6BWUIJnMrsk2zLzJNyCqg1lAbKf2e7qtmQo0B0NMIgxt+44yi8clHG9XtI0QdynMtmYbA5NS/Zen1h1I8MgPozwqeILJsC6ahlnUSRJVSbkUbtcAyoMm1++kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(8936002)(2616005)(86362001)(66556008)(66946007)(66476007)(31696002)(4326008)(8676002)(82960400001)(478600001)(38100700002)(6486002)(316002)(54906003)(110136005)(36756003)(41300700001)(83380400001)(186003)(7416002)(31686004)(6512007)(53546011)(6506007)(2906002)(26005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0FkL2Vyd29jUW43VC96NSswYXRuVzNnODlHR28vL3FTSHVUNUV0blAvY3ZY?=
 =?utf-8?B?RVY3VzVOVDJ4ZkdkaFNhelBKaEt5d2RsaGdGenFwTy9TTzhRZTNuOHNRbXZW?=
 =?utf-8?B?NGdKMkVOd01OQlpqTWxjV2FZcXY0RnlwNWxOc0RNckRmWHd4Y2NSRUhreUYz?=
 =?utf-8?B?ZUVkVXFORXFJcFZDcTd6VUN1YVZpQXNadCs2eXNwZzJybkp5OVBON25hU0xP?=
 =?utf-8?B?UHlMR3FxZ25KNENZTlVJY1VNTFJTZVNrWEJQdXlOaUYzL2xvL0s5Z2xEMlpC?=
 =?utf-8?B?Z2U1T1NzbklCdkFpV0NqR3RORHhDVzdRRENDRkRhMWZ2b1F2YUVINDRBeGw0?=
 =?utf-8?B?ODJ0Y3FuSFltcDdDQUUxTjg4RDkzOWE0dUNZdm1QdFpmcUxsWFpHZUdIYVgr?=
 =?utf-8?B?WDc4SDdZMldoVEZxMGFBaVhUZUo1dGVVYUorR05JeE52bU5DQmYxVklNblZN?=
 =?utf-8?B?dTVJeTEvZFVLUFNVMExDcnJ6Q2xVdWRhSzc4dVJkUnhQMWdqbVVKc3lVUnd2?=
 =?utf-8?B?Um9MSTViRmRkekg5aFBRTzVGVkV3aUNQRGRCZ2Jrb1YxM0txWEhyamswbnlo?=
 =?utf-8?B?NU5yY0xuRzlsYm5vS0pnV29oYlBxRWpwbDF2NmNjeWw0S25ERjh1dkR1enJD?=
 =?utf-8?B?K216OXpscXRsQ2NhYndPSm9QNHVxOUtNRmErQ1p1YldyLzJjUzlxS1p5aFVQ?=
 =?utf-8?B?RG9ydFo4S2paVThZK1NDV1lwTVptQTNYSUZWaWRBaWlCdWVTN1FRZ3BTdlcy?=
 =?utf-8?B?OTZVU3lqbFJ1OUk3aWZKb2h6dFdHRjdhN0wzOUwrSERhSkRObHNUUHN0dm9G?=
 =?utf-8?B?cWluWks3VlpJR21aTkZyWURqdVF5dHdQbDlOV3BlQk1ScEJHakVQdnVURUJ2?=
 =?utf-8?B?TzNFckMvTGZ0V2JMSXBvL0labnAra0dwWkNFK1JYZThueEN4Z1FSZ3gyYTAx?=
 =?utf-8?B?REpTc2tmYUtZNkZyZ0ZPRjNJSHJhVXFsR2JONHdzTHNVcXhndXFXb2FEMlds?=
 =?utf-8?B?UjhIU01LSFd5dDN4VEQwL2dPZDFqQ3VrSXBpalJwRjRkMnczMk1ocEhCcWpP?=
 =?utf-8?B?S3JmNWc0N1FSRVNBSllnNy9Ha0FTbVpNZmFZa1JlUDRxa1ZRQUhOOTFkMEtW?=
 =?utf-8?B?eHNINGhCRFNWNUVRTzBMKzRwZm9GN0V1K3NxRVZLN0hWSFBKdHRnaENIOTQx?=
 =?utf-8?B?SkU5R2paY0sreVRPdU1HRVBUMFJwK1NzOCtrT2h6cDhvNGpzZjU4VDQyR09o?=
 =?utf-8?B?cjV0cENjaG4za2xWNjJ5SVpaZXNnbzY1THNhMk54M2FyMTJYSUczek1XZ3Ba?=
 =?utf-8?B?bWsyK3ZVcEFuYnhOb3FLcHM5eEZ5a1B0dzR3UjVBRnljMGFOaVMrQUFyRXYy?=
 =?utf-8?B?VEpXY2ozSlc4TDVlTWZ3NGQycGppUzRVMG9IbU1tRU5aY0h5TDVSYVNZOUtF?=
 =?utf-8?B?cDkxTENLWG1GeG15d05TeHczUXY5d0FzcXZzNENRaXMyV09nSVZDNG5qT0lQ?=
 =?utf-8?B?b0NXN2NpTjlqMGQrSkRhYUpDQTJKTHArNllwZ1hIay9kOGRqbzA4MFFUMHlZ?=
 =?utf-8?B?YWkrb2JnblgrZmZBc2s3NzRzallBc2cyZUxSK0FsN3V1RmdVeTV3c1hnQTk3?=
 =?utf-8?B?L05EUXRmQXNMZTZMaW84dEIxd1JLbUpGZDRSOXZ6cWFMUzliM2JaNTRXWXdU?=
 =?utf-8?B?cHFTOGxGbExZRXZnb0lzZnBhZUhVUDBsc1F6ZHVVZjU1NW5ub0tWMlhJc0kr?=
 =?utf-8?B?b21NZHF0V3JWamE2UXZyS0lMREJWZ25qakw5aUxZM243d0svWkN6VFNUeExI?=
 =?utf-8?B?c2FtTTNlN21OelVsNGZzK0gxVW55YVAxV1E3UzhiTEdkOEZzU00rNmc5L0cz?=
 =?utf-8?B?VmpSTEg2cFluZDB5WlBOY0RtS2lpQ0J0OGdtanZHOU9ocWoyajdBdmF5Mk1q?=
 =?utf-8?B?eE1NWmVqVmVWT0plTlJ1QVNHSnlzQTZ3bFM4cG9yT2JuV1phT0xYRW0wVTJI?=
 =?utf-8?B?WklCVmpkRnZrMnN3UXhhSGxpVlVjVkxMRGZoVyszMjJYUktUMklJNTM5TFRv?=
 =?utf-8?B?R0JJbUVaUGRrd1hpcGYvckROdEt5NnpvcHYzSjhLU1NFbkFxa2x6VUc3c01r?=
 =?utf-8?B?UHI4eGJtTmNZYm81UC9hSkRRVjZJR09tS2ZGa0RmRVZxeWRHeVpKMEFoTjh2?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3eb3ef-ff50-4b3e-e557-08db3ae315e3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:18:40.5811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtiEiIlWuCTy7XLdQDOXiP9upzUTJOExqjMIESYXrX5W79vke5tT2vXJ78DL5Eqjsy6wT71bLtvhF+fb+xjjB8xG8WiNQQqPDeCFztZZCxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 6:07 AM, Leon Romanovsky wrote:
> From: Avihai Horon <avihaih@nvidia.com>
> 
> relaxed_ordering_read HCA capability is set if both the device supports
> relaxed ordering (RO) read and RO is set in PCI config space.
> 
> RO in PCI config space can change during runtime. This will change the
> value of relaxed_ordering_read HCA capability in FW, but the driver will
> not see it since it queries the capabilities only once.
> 
> This can lead to the following scenario:
> 1. RO in PCI config space is enabled.
> 2. User creates MKey without RO.
> 3. RO in PCI config space is disabled.
>    As a result, relaxed_ordering_read HCA capability is turned off in FW
>    but remains on in driver copy of the capabilities.
> 4. User requests to reconfig the MKey with RO via UMR.
> 5. Driver will try to reconfig the MKey with RO read although it
>    shouldn't (as relaxed_ordering_read HCA capability is really off).
> 
> To fix this, check pcie_relaxed_ordering_enabled() before setting RO
> read in UMR.
> 
> Fixes: 896ec9735336 ("RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7")
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
