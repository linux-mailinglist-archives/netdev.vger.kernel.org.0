Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B9D5BA0E2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIOSmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 14:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIOSmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 14:42:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E0F95AD1
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 11:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663267325; x=1694803325;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1JlafcmtSfHtYECpS12ngjYLIUyv2R8Sn9/fGFzrZk0=;
  b=cbqi5Jj+jn3LShq/NcVM9PIypDQy/kNeSzjJGRlAx2PHXZRIspADGPut
   z8n8Ia5vO8GYZIl26nVoiaL71N1nUJxgCujoMthHKeLlaOF/ObY8NxzTx
   eq/wsDt+qkmNJWwoBEo/MgTcvwNylczHcAFusTovnDpjz7b8NQ4TNoZaW
   uJsAu3Y/USRzCUeN8CZnG2DTNNLAW46QopvEp0aJb+TBnqgOV9sGRvM6Y
   CQ9237nnyUVicFtiVx4RaVRUxIjr9QHBQhaWbEkgFOIhM8JdKF1ZOgvbT
   KjEXPx1e6Z4Uda8rx3KuM1PYuC+88s37SxkVwi5tvg2eAQPRPGtLgiy7n
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="281836796"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="281836796"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 11:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="706472925"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2022 11:42:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 11:42:04 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 11:42:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 11:42:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 11:42:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNKv5hDtA5JAF1YFdJGP30AOIUfSFgnbHt3vTgaLdUqbpYzXxkJp7MgymQKYNcrdWh9Oxuvc5/LSxn3Z0fCKC64ZMc+LCtxr6i4Ocr3Nqb72Rb7lDmvwLNVABag/Kruw7CBBhCIeNJIarAiuis/A9gtlZ8i0GEeZDA4q+pKVpTnG6cA4yfgEo8ITBUFttEdA0e4TZsTohuWnjmtLfjRRF5gbTUjmUcLTdlgHer9af0Vm97K1lFIRGX2SRQ/fWfJHpLnV3AUpk+qb+vaTjApbTQM9KCozYvfIeiGwevdRryG9seetyyBnGc/NtEYnsrsyihZoDtvZppO7MN8Pu7QXww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eek7yXofK+A76AvEVq95urkiTvCXHtTk2k4dYipjbsg=;
 b=NxfJUkdT5YPkDv9Kuw1XN2kUN96XIoHxWT4TENwagbCO6tWNNhmBe/3tdEBOtJmPKdKMFlT4QBXfRmgZOvlLgY8c1I+MEoy3WPX3I55gsQ6gipXsE/xeAraBUZW7QMeT6BM70aS0qks2yiiolNHRjOp71M29f25HHusa1haUFSvEHx4OJTJPAg8vymPP9v7kGCh+8oS+SaE8yqNTjugf+qH/SPNOFffrKGl58dCZtid9UvgKXhVbe5fCeUgTpZqsuidFBoUtjzaWr+16M3faS00UL2s4FZ0UnOeMe7Cbmg/GhOgNuzBIf8RF/co193HZIqzWBwGH2eevXOZsTJudjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM4PR11MB6309.namprd11.prod.outlook.com (2603:10b6:8:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 18:42:00 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 18:41:59 +0000
Message-ID: <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
Date:   Thu, 15 Sep 2022 20:41:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>
CC:     <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::15) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM4PR11MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: f9cb0255-fa3b-47f1-ceef-08da9749f92e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RbFzn/aSTf8YkXfEZNZm2M54C18gyQMosrzwfOB3kU8+I26hjczEX/oWe3dGnagNzJ1H8WgVfL0ltvKbEZZLfdzklUm0h2zZscl/hAWlURz760mAqSGmZLVFgzTv4n95GerV0/MANeJ0kbPmBTKcGIG92B97LALFtPZjAXy45YzFx5ienQGwU05OS9B71K4y6KCJarSXmyUmM+xG6qHM9AZNIVjz+7JZ+bi1TAEmHYYVdNyNY0qLiUm3OKv8fapax52v8yOJddOULCvo6dIXB+A8x73MDcHpTrhZD4C/8mchebefWNhlCyLmV34E1ubq1B5IEk/Gl8m9TtnOq3Lm2N+/wO/RITpKrOT02lRAJ3lDyYbQXQlKPVB6+/r2kXiOlj49wrGFiGvamek9Ajod9vQe0NpZkR4odtQiHVM5fjM1J9zDXK0rJ5/KvNkOkdSgRYT+cTcOvJirpI/hhu9St9Wbx0autGGN1blqXARUCaPz3eS0v1Q6dgNett2RMSTjQ1Fdb8sFAcdh9A+wTe4xIFYHmmT5sAV/3waQ1sR+q6yTh7ylDA8jNcu2SIO2wRxjAuo19b0GOxjroZdscNWaKyrE6PB6w3NZel9drYZVCjg2hi87d7TIhKAHUuZVduzCq5ZTd+d6+WpOcCZZAljSk8rUD1DR+T3COHKHCLZsDTvFNZlDob66tHWiN1+LU1bnOobyQXOISer2nHkAETKka70XlPpEPieI6mGrAKoi567a3IGJn68J8ulkITWhXQTU7wrDcIMq8gcsWsniLzEHKTepbXkknbKu7raSrsJofZBonPtRr7Mj1fvSHCl/B4cB0EAilZhX8p8T4HN8gUdNLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199015)(478600001)(186003)(6486002)(66556008)(4326008)(8936002)(66946007)(107886003)(2906002)(31686004)(2616005)(6512007)(36756003)(83380400001)(38100700002)(31696002)(82960400001)(8676002)(26005)(966005)(6666004)(5660300002)(86362001)(316002)(41300700001)(6506007)(53546011)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUFVNm42Z1laQjMyUkhUZS9sUlYvVjJuRlBDS2QxRGtxNEdML1V0cmROcFNh?=
 =?utf-8?B?dTNVR2pwQTUrMVpSalpXdXRlSldVeWQ0RjRXclZIaWo1aThhOXR1U0VYUUQz?=
 =?utf-8?B?TjI4TW1RV3NyMEszVmpHb2I5MndkbFQxeWN5NG5vbm5YQzJsOU1ZcTVrZmty?=
 =?utf-8?B?WklTU2M4aU9keDZMLzNSaER4MzVGclovN2U3NWFuSU9nRnYvaFYxKy9DMHli?=
 =?utf-8?B?ZHpHZEdNL1M0NVpkM0xiMGkzald4RHQzajJDc1JYZlU3SVVEUk5HNWY0YzFm?=
 =?utf-8?B?Wm9HMHFIRGVWOHFIVkhMZWxuNW1lZ2s4VGRweUVxcERXLytyQkViVXRZRCtj?=
 =?utf-8?B?a2Q1WnZoSkFiKyszZ3VwUDhRcmlvWVJWMWRNS3R5TkNyVU9tYjBvTWlnUmJJ?=
 =?utf-8?B?MW52U3pkajFwUEVEV25jcStFd2picEdFZmFka1NHNDRsUHpGOXEvUzI4RGRT?=
 =?utf-8?B?ZlhXRXUrb0wyNGV6K1pmUVluU1FETENhdEhWWDRtdVhZenUyZytJZVNrazds?=
 =?utf-8?B?NGJJQXl5S1EwaktSbEVRSHlvckRSQkhadHpac3FSVk5GY3ZRYkN6am1KaGd5?=
 =?utf-8?B?S2thSElZcXo3QlNVWWxwaUtjNFE4OWt5ZE5UdENaU3lBenlIeDJjQ0wzQ2Ns?=
 =?utf-8?B?ZlpJSHA1SEwrS3ZtNk11UjR3SmFkSk8rOUFJQ3Jqbm85RXNUbEFzR2RTYmNq?=
 =?utf-8?B?MUV2UU4xamZUeHJCQjRrRDZtenBUczRUN3BHcE9ocUxWbFhoWGlEQ2ZXZkNL?=
 =?utf-8?B?QlBmZHcvbG5ncjU1QmdTSlVGSlBwWld6V3hUV1dFa0dsYVlVcHhQdk0wd1Ri?=
 =?utf-8?B?MktUajNnNU5CQnNETVlFZEZtSVN4MXVWTmNtL0s5dTJaYTJlaVNjYlMveG5I?=
 =?utf-8?B?VHNPUkZjTy9CckRrZDdiVGM4ZnZKbWxUWjh0VHh3OUFNeVljY2F6SHlWSFcz?=
 =?utf-8?B?ZzdHdXpyUk1PVjhTbmNrZU13dTJHYWluZ1NxVHRyUC81d2Q3ZzB6dXBZQXk4?=
 =?utf-8?B?SE5YZTgrTjRRV0dTSEtURHlBeGFvamc2Tnp5VXVoUnJVNytCUmgrMjEwZzNV?=
 =?utf-8?B?SW9rUHhOL2ZOTllWZWlpRStlNzhKL2l4VUJYbUlOcFNySUQwRTd4MXNWWnZM?=
 =?utf-8?B?a3MxWXE4UFBVZjhsM1R5RDE1Y2lmcVk0M2d2eVpiSnYvZHI1RkVQaThwdE9x?=
 =?utf-8?B?Y25mcDBvMDVDYzErQmRaSVZnSURzY3dVTlBqVVZtZ2dNWVQ2ZFlack8vM2RR?=
 =?utf-8?B?b0l0R24vZHZEY3p1RDlFSGErR0MvQnlqQ1dZYzBqSXRGY2d4SWZZM2JCRzB1?=
 =?utf-8?B?c0N6d0paWFdhVmQyUmZFcTYrOXpWb0NxNGl6RzY0VFpucjRmSHptK0tuR2lB?=
 =?utf-8?B?eExEU01rME10cmR2OU0wVUVIUFJiaVMvR1NPYS9hYURTWEcxUk1MUmNOTWRi?=
 =?utf-8?B?Njl2ZENTS0h1cXl4RVRWNVJPMElJVFVZSDEvemkwaW1JZE5vNUpqME5KQ0VX?=
 =?utf-8?B?UnhQRDRjVzlIVlY3dTU4QkhpQU1maGRzcldPVytUczAwbndYQ1hlcUhnMmFO?=
 =?utf-8?B?RGt5bmRqUUp1SHFDY1lIT1BEdFR2QTNYTjNsRGNud3JmdEhrSFdDL0h0RkR4?=
 =?utf-8?B?VUxBYmtLU0hzOHByOXFPMVhHWUtHZ3YwaFhPMy9ZdGNHRkdTSEtERkk2YXFK?=
 =?utf-8?B?UURsVk9Kc0gvWHI4blg2cmp6aUY2UjMrcy83dldiMjlrWTZNajlVc2k1WVgy?=
 =?utf-8?B?QXpxWEZlS3VwdEd0aTlmdzV6ZXhuRzdqaGNtWmlaOTRzd3RPUmNaV1g1L2t2?=
 =?utf-8?B?ZXhURkYyeHB2ZmVEandVUHZla2F3TzY1VktUMUFtQlBKUHdDWTZvbTRsN3RG?=
 =?utf-8?B?b3dsdUVweVpzMkw5c215R2VkVWk2dkQ4aDJYdUxRcXd4T3RHTGlrYlVDUmNM?=
 =?utf-8?B?blk5NHVXcE41MTI3OXFDbnJZMzh3ekRtM1hFRG9yR0o0MGZrRnZSczd6RUlT?=
 =?utf-8?B?RERRWE1ReG5EM0pRRExRVWJvV3hwTkpXeHFrc1I5N0JQYXBLVjloc2Z4THJ0?=
 =?utf-8?B?aGhUdHRTTTAxNU4rQVJKdkgxOVJCU3o3aTNJc0FwK2F6Q0cxdUFmcm1FYlJ4?=
 =?utf-8?B?T25jMTAyQUg0cHdFUmdxa285OHoxL1hVUVRQN21wSUViWVU0OFk2RGlEQ053?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cb0255-fa3b-47f1-ceef-08da9749f92e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:41:59.8328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zou3r/2nfTvwicCx3Q+TSHSKD+XbYYbPII5k7VHqdWjyRm3QStoBf+UT8uEBxnYSg9nOwVYGSOcDj4Z1wJUI1sucVi8Q/Set9/B9f+2RTCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6309
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2022 5:31 PM, Edward Cree wrote:
> On 15/09/2022 14:42, Michal Wilczynski wrote:
>> Currently devlink-rate only have two types of objects: nodes and leafs.
>> There is a need to extend this interface to account for a third type of
>> scheduling elements - queues. In our use case customer is sending
>> different types of traffic on each queue, which requires an ability to
>> assign rate parameters to individual queues.
> Is there a use-case for this queue scheduling in the absence of a netdevice?
> If not, then I don't see how this belongs in devlink; the configuration
>   should instead be done in two parts: devlink-rate to schedule between
>   different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>   API) to schedule different queues within each single netdevice.
> Please explain why this existing separation does not support your use-case.
>
> Also I would like to see some documentation as part of this patch.  It looks
>   like there's no kernel document for devlink-rate unlike most other devlink
>   objects; perhaps you could add one?
>
> -ed

Hi,
Previously we discussed adding queues to devlink-rate in this thread:
https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
In our use case we are trying to find a way to expose hardware Tx 
scheduler tree that is defined
per port to user. Obviously if the tree is defined per physical port, 
all the scheduling nodes will reside
on the same tree.

Our customer is trying to send different types of traffic that require 
different QoS levels on the same
VM, but on a different queues. This requires completely different rate 
setups for that queue - in the
implementation that you're mentioning we wouldn't be able to arbitrarily 
reassign the queue to any node.
Those queues would still need to share a single parent - their netdev. 
This wouldn't allow us to fully take
advantage of the HQoS and would introduce arbitrary limitations.

Also I would think that since there is only one vendor implementing this 
particular devlink-rate API, there is
some room for flexibility.

Regarding the documentation,  sure. I just wanted to get all the 
feedback from the mailing list and arrive at the final
solution before writing the docs.

BTW, I'm going to be out of office tomorrow, so will respond in this 
thread on Monday.
BR,
Michał


