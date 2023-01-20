Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33183674922
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 03:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjATCFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 21:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjATCFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 21:05:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BB5A5780
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 18:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674180303; x=1705716303;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E9/OdZ/zs3YPCs5+LSrmnFsblNoQ/ImII+/iQlLtp4w=;
  b=PuD4nat54PlDrJaLYdDW0IpPD+KKaccyb3hqVxSMZiLpUJpQMRAbNqrC
   JZAQ4hfmonNea9/ehqN1MuzvV3aPQXtrO1AAn5EVbXMU5OnZkph51Cspo
   PBJrCOBv2zxU0B/qaDTzHMofMF+Heg3E+6TWFj3dz60YQnR4Mxqk8knQH
   JL0UnGxiwXa3SQxPz5FINdR2FE58EFUibsrA60XdUSPBGHthu8JeZdB+3
   YuQJGAQ6v5pDn2CCWGfL9SQqoYi/+Fb6lHmPYM3Qo6C5CImYCs9sYRs3X
   E+WQdp/H4T3L5Coi9TEzbx/CV+kgMR2XjpDOehTRxtrQJw42hmd0CpH9F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="390005500"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="390005500"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 18:05:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="653636594"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="653636594"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 19 Jan 2023 18:05:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 18:05:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 18:05:02 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 18:05:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AS9l2oy9lKhvNEwwA2pe6+nsUp4BKXgYuVLkfsDxNi9csVdOHkYvv0oWsbJ8cMKHeOU04UIfHf7HNemk+BOt1qIQt0Df+Tcxzyza85ahzXfF+Zwx5fm9WZEDmip5m/1NtgZ3t2mFTSa3tdzu8ArSsVHvnFVDCkLMKo0DyDvXZdp+IZe6og9BxV9Ruz+DYq0LV1kMb3f40jFw0oR7MCP20cb3D35Z0jSyiPy46V1s1W8Pw0uk5SWuOJJUUNIYuER2GzBS/S4hItRlT7LNmQVPHlbgAYJwj80QdfhVdHwhUjlvdpe2JZmBWQZ4bTR6OZ7dUQTcWWzrodOn18V1pF0fdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1/VDeK6vIDEHPO/AIIJxM9P2sOdErLIU4Ig92VSRns=;
 b=QJ0t4TjTZOhWjXIFML/0n5XF1fRE15QUGXrgsnk4/ahHDAIisUAbSgokrPraZYikOkF3tkPO7f87J8czyfVZHOwqQ4N3ajCwBVzWEgWWUEVJJVi/YhCqe29uDW2riSIeCwY5fEx41JABp1uNrtdhf26CRWNa8V6Tr1pji53M9hFFovj+/LO7TCtoc7eQmHFcFwC+5/SNtrs4qNh/lSkKmI06saY9GOy4QXfQM3EnyZQiGymxmOjsX4bTEed5nXJTyqy8ftlhkAjD4uj7CwJhhz0vgQYtaNPvVqmODoF1OdMCE5vtKgOM3d9Rxow1bW9zPhewjQzjzLeln8G2+Xx7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SA1PR11MB7013.namprd11.prod.outlook.com (2603:10b6:806:2be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Fri, 20 Jan
 2023 02:05:00 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%5]) with mapi id 15.20.6002.026; Fri, 20 Jan 2023
 02:05:00 +0000
Message-ID: <6f64703a-19f7-ca61-af7c-af1ac72cccc0@intel.com>
Date:   Thu, 19 Jan 2023 18:04:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: microchip: vcap: use kmemdup() to allocate
 memory
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, <netdev@vger.kernel.org>
CC:     <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20230119092210.3607634-1-yangyingliang@huawei.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230119092210.3607634-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SA1PR11MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 298afd30-94b4-4c74-7d01-08dafa8abcb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkU8zxX4HUgNORsSF+VB95ellGE1ThYopBjnsfTZTTjn/DPJxLvBS8c39HO60+bII976zADVcaA/kiSY51qMj5GzgK0hGbpYOD3f0QKczkWmhY3/4HbDfJoL4OX0XIhBC5kCgZz4/0jBMKKV8ER+6CD8s3RTbO9c/DJoR12gUM9hMS8NnGAVuu6cg2Cuj/9BC97FV987rKWhlYopZtlYJHaA9LcdYLrvwPHWbwDJzxGFBN97cqgEUH8+H2K9pNBozkZZ7Xz9CJa16eGvoaXSq5Kwi6gdYTGwCDn0dU4RCzT4hGUJKYaxKa62LbrEwH3Sm3tFIFNkZOJ8Ya76LqKPpsLkjd9w9cfElkVGur+YsFVnEXsr/ap7hpktwXx5xIJDw6mEcBqjBQ4BJdiKQkmJgmo1Qcrt7iDFqbmO9vFZkuw8SGXHyA8+IsRhTktUHJ1YXgj8Zed5NFkDxS8pELQG1W6ake3vxh2gX7r6uHPEkiAhYBqQC+XTEAelY/hQEz9/LTOG+V6QTkbsj1eh9MWI/zQku4kAHB3QKA1hXI4Gw9QzUH/lduQ6v4q01nrH6XX6zuryQVaRLkDO/4B7y9b2J9W/T3rmyIb4LXNNpUblNO1wciPK/2NGvm2dm3eAduUAauDADrmk8aHQgXcEbuAjTujldUpo0bmCCgYRBb1DEcPe344c1pog+HNZB0MEAW+MM54CPMiOLPsPNHGQgV41DOVQMq3ZefRu38P8Ee9uQ9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(53546011)(6506007)(38100700002)(7416002)(5660300002)(4744005)(83380400001)(2906002)(2616005)(82960400001)(8936002)(44832011)(186003)(6512007)(26005)(86362001)(36756003)(6486002)(316002)(41300700001)(31696002)(31686004)(8676002)(66476007)(66556008)(478600001)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGduWXh2UU9HQ1RXbkRsSWFhUXBlKzVMNm9jcEFOQzdBWEJidnV6YnlmQ0tL?=
 =?utf-8?B?UnFjd09nMVFDT2pNMkIyWWtsOUNNSUZCYzFqWW1WV0RzamhBcDh0SW0zblJR?=
 =?utf-8?B?UXBVaGhFdFlldGQ2WmNETjJxcEovVUdEd1NhTm5XVVdmUUdFdHBrZ0F4bm5s?=
 =?utf-8?B?UGVXUDF0M284YWxaUjBxcGpHVkp5Q1lCdnN0R1VJcmgxcVBnYlhYSmNpSnpj?=
 =?utf-8?B?QUdhTHdCbWZpbGZrN1FkQW93cStUOTRGWEFjM1IwaXNuRnZmYTdFWksrU2JY?=
 =?utf-8?B?Ty9WTXVmeW8xL0h3eXdOOG9CZ3lZL2JTL0NrN3gvV25STWhVZkFUckJ6Sm1a?=
 =?utf-8?B?OEJUODc3UUlKcnFqS0hBSFlyejVheUZpNG5oYlNNeVZVK3Z3c2tFMXJrOWNz?=
 =?utf-8?B?cTN5TEdoblkyWVIvSUhKMjNoWE8xT05ZTDFaOHN0SG1OdGlzR2lPVXI3RnY3?=
 =?utf-8?B?cEFReVhvOWxQaWlORUh4NTRWWU1DZ09ranNpaG90QVJkV2Y2OFNRb2txRnUz?=
 =?utf-8?B?K2JqNTRkNFh6eUlYMCt6aXBXU0w5MFFPeGtrVUdIMXNQUWU5dmwxN0k5S2d3?=
 =?utf-8?B?MzRWWDZZZ2Z0UnlLalBPekRnNE5DUHgvWDdvcWxHdEdBRnRZRXZEZCt4TUxB?=
 =?utf-8?B?UlNnOG14L002b01udTJsZlNUTlVqYm95TXpEK2JML1MyUDkyV0hxR1FzWTIr?=
 =?utf-8?B?bUxucndXZlBydXZmRXQ5Mm1EYWJrQjB2czBXWE4wVVRPR09UblRhUmJRSVVw?=
 =?utf-8?B?Mkw0dmZLa0pHb214SFI3VTc4UUFPZWRGbkQyNkkzQnBwUHNmV1MzTDl1NlRO?=
 =?utf-8?B?Qjc4NE9QbTB5cnJSOVJpN05ya2FiOTNBYlRKUWRNS3JwWnFDSi9HaFBOa0Er?=
 =?utf-8?B?cXY2QVRlZ1RrU1FZaklVeFlNa2RsZmpsdGFBSEVKc05aRUNIeUx0OGJUbk4x?=
 =?utf-8?B?eEgzMldYTzY3MXlKMzIzalpWd1VINnhUOS9HajlsWFdwYjdkdC9NRTNiYU96?=
 =?utf-8?B?KzM4ZzBDN1VFRjdsOWVJUzhVZ1h3UWJMQTA1NFZ2VVBEaWRrK1RLbUFUVk1v?=
 =?utf-8?B?T051cHpqTkVtVHNGNDZrU3hpQ2FxRU4wdW5qVXJKcWhiU1BkenFXL1hxQy9P?=
 =?utf-8?B?Z1hialkwZUxKemhKMllYRytKdWVmdW5RRkJxdEI1ZHhyQkRkazc4QytkRGFq?=
 =?utf-8?B?ekY3ZkN6WDZpeEluQ3VlbVQzb04xZFA2NUNZOU9aN2hCUXZ4YUtLelpjZi9y?=
 =?utf-8?B?enh6Nm41c2o4MWNmeXZ5eGxsNUxTOFZzNW04QTl2ejFmTHlVQlROdWtSV0hi?=
 =?utf-8?B?aXVnQ2xKb0pmcWZBMGFRYWVNWTR1cVhkYVdHSGEzMCt0Q3RwL2JFWVZVZEVt?=
 =?utf-8?B?aGhyS2VveGpORHE2eUhNYzRxUjA1bUNsODBEK1p6MlFKelgxVE1tWFluV3hj?=
 =?utf-8?B?T0pwdFZUT2k2SmNtVGhFK2pBMkVSQzI2aVh5OXlOb1A1aGxIaysydVdxM0Vk?=
 =?utf-8?B?cW1sUG1kT3hvM2U5MVNRbWhrNFdPc1NtUmxiZU5OUjlkQTJHc0oxc1BhbzYy?=
 =?utf-8?B?ZURTRkplYjc0S2QvZ25GK0tNdGVLYU1uMGZ0bzQ2Y2JlclV1RlRSYkJhU1kw?=
 =?utf-8?B?dkRxaVMxNUlQLzBqSTRLNzNqNGNUOXo3RWFQRTdVb1dvYjBKd2EvdVpzeW1C?=
 =?utf-8?B?V2NzY0JteTJBQ1NhM0RYMitWbWczajVkRU1Bc1VKRlZVYmtqVXdkTlY0NERL?=
 =?utf-8?B?cTcxNWo5eEtzZVNpdUIvcUZSZGFKME9QMXVydGZ6Qm5NWGt3ZjltNkhpMS91?=
 =?utf-8?B?cmhjNzVocTZRSEdyVW5pNnR5MGRZOElpM1FienVXbjI5OWVnQzhjcmtMN2Fn?=
 =?utf-8?B?MjFLaGFPWGltZjhrbTVPYlhlQ2RwYXVwTS9SUE9DYnB2amRBaWd3OEgxcEFo?=
 =?utf-8?B?RjlIMGNwc0tOWml1c3FrTlBDS3NTQXN3aXM1cC9yOXZKUEVOL2E1T0lWRWdp?=
 =?utf-8?B?N2lDZ0hCUjAvY0NiL3F4MHlBQlhESWFjMk1BQ0VtaFVxYTRjWENQT05mdHlF?=
 =?utf-8?B?N3BEeXExQlR2ZWdpbGtoRDBxcUtJNUFwNVEzSzV5STEyVG9vS0FuOG5qamdl?=
 =?utf-8?B?RS9FMUlqR2RpQzFhd0ZldVgrTTdyOG9KMGpGOERCVDJTVHIxNUpzTWsyS0s0?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 298afd30-94b4-4c74-7d01-08dafa8abcb5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 02:05:00.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yf0YzmJ//z7pDfYoBhjApbBY2DdZtiAI0R3opXtK1QMtd4Ub4TXpeIH/Pk7mW5RmJCn8nM/ntLEZbDj/Vc1EGlnvMxuHzJFFmY0otaf08Zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7013
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

On 1/19/2023 1:22 AM, Yang Yingliang wrote:
> Use kmemdup() helper instead of open-coding to simplify
> the code when allocating newckf and newcaf.
> 
> Generated by: scripts/coccinelle/api/memdup.cocci
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/net/ethernet/microchip/vcap/vcap_api.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)

I don't like kmemdup much as you have to be very careful to make sure 
the original memory is freed in the error case. However this code seems 
like it works correctly since it was already having to free the source 
memory earlier.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

