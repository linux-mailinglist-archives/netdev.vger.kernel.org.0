Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95059692721
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjBJTo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjBJToX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:44:23 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291B97D88
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676058208; x=1707594208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DCU+pgIjrYj0M+/RtK9tO1WNe/AIWmNfJueuL6eSKCE=;
  b=LhR+KcxWv7VaA6E8Ze4qn3y5vQEU9ALK6mrkUPy6z/eZ+iTM84TKlvGj
   V4cEZzcMSp2GCLfByRjgGEYgdGcrbThaOEpghZ5Tgb3Dm0V5RiA9v4BAN
   O60031++9mfuYej95u83C3LUCo3LpssCXiZtQmp20RTvgYo1Ojv5s1rJS
   f2G3WJTPbIpj2zuKtu3YxQqETMn+nuwr9pmKmDv4M0JPhvnMiniQKseqC
   o1IR54d+eibzsJmJQTKDm+WUYrohyFTTSKX+yRfhjpMp67Myr8Nb4mCmM
   EAnZei4Qq1tomyQnJ3X8g4Ga7o68sGkAJ1Km9byhIslyfsd6kaTaWcXUe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="318529055"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="318529055"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:41:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="913655587"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="913655587"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 10 Feb 2023 11:41:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:41:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:41:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:41:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=em0EZI6no/q8XtmzhvrzryMLlV3w9QW7vr/yBXJK+q2WI7tPNw2uOhoEPK3eCQeIA1lzp12TRNy/wsUfWdwKRQsAB/4CecVdwLJqVyxIpR2wMBzmBYw6mMPstw94u3R24+ORrPPpSDB2Dp/ltYRShPbLzJumXEO0UlHBtQD/7mi7W41v9vg7dQ7FwHd0QbUL+0BhTH9+gdI0qtKDYuwJD93YHXsNljZ6kQFvilXe6aYcNK884dMdauxZ7R+PFlmlYaNQdhTdT72c5r6LHBnDqdeaBXWw/pVJ6TMCXHNqDchMcHMxPHsm0VbQWLFKKeUAOZAytuuQzUqbVeFY8jQwLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+BCIQo+2HH9ECeDsrZMJcQ3XvLKO3I45R5cqwIJB4c=;
 b=Zw5Z9A9s7n4eV36gmQbMlqIt/eSjTSIeEzDo9mNwAogpufik5j6N0br1L9kKfrVDMb3UeHNtQHOgTOSPp4pvBi1mK12uAYrd82psRJ44hOLedOXaScXk6gDFS2JSsJDBtvWwhm1DhNK1qIFn7pr4bB0NUXtjFZsX73QbqrDRTpVoDjZL2LjVQlsDZ4pRxVmMELZ02kwMueKTS4dLRKnkAGXv9UiCT7ibt20OU5GRXZXM3OdnHzDhMHtnrQOTC2lRZWmFMdN65qDpuoY3B70Z3NLUDAwFNhIxsHr2811F8mSU2ca36YVbDQ39famxhldnPCl286UVbR5xB3AQmucLQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM8PR11MB5640.namprd11.prod.outlook.com (2603:10b6:8:3f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 19:41:31 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:41:31 +0000
Message-ID: <0a24ce1e-f918-338a-881f-fef2681b250c@intel.com>
Date:   Fri, 10 Feb 2023 11:41:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 6/7] devlink: allow to call
 devl_param_driverinit_value_get() without holding instance lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-7-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-7-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM8PR11MB5640:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f14e73-3f85-43fd-eb85-08db0b9ecee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXZbBLZkVnMq59QFjqTzWCdrNqCwPTdcMEzrpEBFeRcOl8XCVdyq8YKlvwR6j/Z7/GLUkJCqXJFMcvwWPZLUWWUMy8ebHCVAws4ih8NBcYsUfRbeiQz2hd1s6DKLb6w6vu2SG0gIaDl3Rngc1fiTQALmCUo1vzE2FqOoaOzpeiokHJFb/ofwG6gjAL6S/sIGtoLaOiDD0BFeE7xY4YQvrGweMV0uZrTkK2P1fkfctHxIYUhraz9XljJjjvPx0LmjvWBV5+ufUzS/XeBD0cm3ixtwCaTCd8Ko5Ttbb/yMu30cExhPR4i5gnGJYIl63vgTE2NZIC042l7lA0MwO+uQ8SQVpMyj4LND947wKrTgeKkZYD4ZT18QzVcyH/uZWOuGbWXUVnw0zben7whD6hGXz4PaHX4pZOqJMbVsKMbYLld4+/gh/m5/DtSCKpgjgWoSHTvbtiJOFcdbFDLPBuRag9cYChjVpBa4wSl+En823V2UoIIXyH3egjyq+aZyAc8pQWiFRlSxcp0LUlWMUk4TEGpy/RdrTLGL1SQo2hDEb9rHFj8fqLN8C78KJRtcjrZZ7FyzGLxZzF+By+xr4IdIlozNlPEn66v8B20PDEAxLxLVvGloRYXKe0d3OAfAZxNt3e24e1c9K2hHPxJNFS8PO6QyPgY9ny9YLxVSFzKlfO39yeptWRwKKDiT2PpuHkIYxqyBOtnYgWyjXMkDXW1Kp8e8sUist6H51PIzYPKqREuDdsm2Iw9EsF38cg4pb2q+fVJujG/9lja/AYdqviWkTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199018)(86362001)(36756003)(82960400001)(31696002)(38100700002)(66476007)(66556008)(41300700001)(66946007)(316002)(4326008)(5660300002)(8676002)(7416002)(2906002)(83380400001)(478600001)(8936002)(966005)(6486002)(6666004)(2616005)(186003)(26005)(6512007)(6506007)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3djM3RZQnFyNEVsbkVkRWFvb24rL3hLNFRmNHVmTjBEeGUrdWV6RWpUSjZQ?=
 =?utf-8?B?QjZUMlM3dXFNWGNBOGFKV2dZUjZuSlNhZlhBMzMrVFhVNnkwLzhNWGc2ZFVJ?=
 =?utf-8?B?SU9MejVRWVd0UkJFMElFVWl5QjBld1pQRTBUT0p0cyt2YkNQZ0dqemlMelhW?=
 =?utf-8?B?M1BMSWVrK1N5N0t5NTZ1bGZFekN3bVJ0ZmNZUEwwdWlrcGRvTTlpdzRNb3VV?=
 =?utf-8?B?angwelU1VkFGTjNUdVlNWGlhcHFqSG1ZMmxZVjBRTi9lblhvR05HalpOWEl5?=
 =?utf-8?B?a3lON0crZkxsOTJ3cGkzOVo3NGZHUFEwcWl2dG1oWnNhTlRJaDcyUXY0bGt2?=
 =?utf-8?B?QVF5YVNXNFNQOWlIMFZEdjFuTTVCM2J3SzJmM0VaSytnTjJQYUhIVkFPNTV1?=
 =?utf-8?B?VEU2WlZEcHhPUW5MdFR2c0x3VXU5Um9TZVRSWE1Odk12Vk9BVVBGYUlRTHZC?=
 =?utf-8?B?VUZZZDd4aEdzOEU3YXlCU203cWdQY1JOMXBMOUtTSWlUMlFIL0JZWXZCcDNE?=
 =?utf-8?B?RzlMRzErNjI4MG4yclRQSkNvbzdhV2RsVHpXM1JERnpmdGt6ODlLUkZCN0FJ?=
 =?utf-8?B?UHE0NmI4UVpmc1VlY2tvVW9rTHhXbG5xemJGbStkWHh5cXVhaHh2S1UrTEU1?=
 =?utf-8?B?cVBucUlyQ0FBNG9xeXpTSHlUNEpWeW9MM0xLOWt5K3FnM1FoYkxRT2lNWEgy?=
 =?utf-8?B?L3JNSGpCTStXL3gxayt3d2JsNmRhK2plT2lzaTlIR0cwUTFYV0NndlhMbHV3?=
 =?utf-8?B?K3F0clpZdDFDOVFGNXFVNVBmUDBNcWdFc1VCUkk1eml1RXg4T0ZnTmEzQ2dU?=
 =?utf-8?B?Zk1zQXlLZXpma29ERkpscTViZ1dKak01SW9ySTlpZ1dhOGFjSDRQc0YxM0Jn?=
 =?utf-8?B?MVJpVzgvZHJ2ZThCbXZ1am5CRksrc2pQVnhYVFV2bHdJMlh1WFNqMzRLSDFw?=
 =?utf-8?B?T212a1U0b0w5cnlHaEJDaGRHYXIxd3JmV1RxV1RpaUwvcjd2cUsxL25TTFlk?=
 =?utf-8?B?YWtxV0xFcU42NFp3TGU1TUExSXhSRzg4cW9ZV0VibzRkb3Y3RE9QVHk4ZnFL?=
 =?utf-8?B?QktkYmdSNGhveHJSVVV1aytRWmxGUkJJb1ErU0VKcXhDTkV0QnkzQ21KejBy?=
 =?utf-8?B?ekpWQVFzcXhGcytiOWJ4ak5yVUsxNytJUnRUY2h3dVNPclVTRnNVSFFNUXZO?=
 =?utf-8?B?bGoyNEFxK04xSEFScVhNbHZRS3dLRHFiYkNQSVB1Y3ZESnA4OWEyamhkVVgx?=
 =?utf-8?B?bHB6V283aGI2V2toTjFrWGJKakdxdjU1MkJlaC9SdzBkazJrQThoUVNZeEdq?=
 =?utf-8?B?RXgyS1dpb3lxL09ueXBZejI4NkJtUVRhdHpXWXNqZ0xDZmpHV1VzdHFFeHo0?=
 =?utf-8?B?NDNsV0xicE1WNVZiemFJOFJYK250M1lycDEzWUJzT0l2UCtDclVuZWZiYlpv?=
 =?utf-8?B?OE9Rc3VOOWFOR3REK1lXZHd1dG8rSjlNODFrMHU5VFBsWkFQNGkxRU02ZmZS?=
 =?utf-8?B?WUpHQ1FjYmVpNk16NHJac2dzM2syN3Fub3U2UkpGempnbnF0a00wOTUrMktz?=
 =?utf-8?B?Q1NJN2xwSDdaR1NFT2NQNlB0bXVWU2dNS2svbjFZb0REdXFja2tMNyt1bjVI?=
 =?utf-8?B?MmFMNGZVM2NtTG03SWw5Kys4U2tOU2xTeVJDRjVGM08wREFGZ0RmL0QxM29z?=
 =?utf-8?B?UWFaYWNuVG5PcUkrK3A0NUVyejNLTTRYQzBUTjErMEt1dzNLVTJZdzE5VWdv?=
 =?utf-8?B?RXNMTGsvTE91QU51aUcvV0dSRVJNVWM1OHM3dmtlcjY2SVBBY2h2WXFRNUNM?=
 =?utf-8?B?SDQwbHNlU24vUXBuNTB0SFl2dkEwUEY2NFNwVkhTNktzRUhHSldXRnROdmFC?=
 =?utf-8?B?WTFRL1VScHZsWDd6L1AwbE5ET2lLV1oySGVNVXFrOXoxZFdUQ2pwL1pYRWZL?=
 =?utf-8?B?bHZTWC9WeFg2bFNBWWhhalVBSnIvQ0dsdW14ZVA4VTlhQnpJQjhrclUrdkNv?=
 =?utf-8?B?U2dSTml3eFdKamhGY212ZFJzQ2RNZmo4NmpZekcwbzZBUDVGYldCWXd4a3NF?=
 =?utf-8?B?dHIyaVlJWEVsYWpRMFUvVDNiM0lUNU1Nd1NqTU1kcXJ0UytNa3pnVm1iQXRh?=
 =?utf-8?B?UjRqV3prUVY0VUIwR0VoU0J4MEh5YmtldFp3MkxjbVpORFYrcUU1TWZtbktj?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f14e73-3f85-43fd-eb85-08db0b9ecee9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:41:31.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwnbAkCH7iFv2orPoVMF2RdcYqqij71lCmGquiv29z/GIuvPS26kYM3iTb3j7nOEN6kjhcuj1gPcZVTD7odZfm6POvr3HeJGGKdgotNE1TA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5640
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2023 2:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If the driver maintains following basic sane behavior, the
> devl_param_driverinit_value_get() function could be called without
> holding instance lock:
> 
> 1) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with registering/unregistering the parameter with
>    the same parameter ID.
> 2) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with devl_param_driverinit_value_set() call with
>    the same parameter ID.
> 3) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with reload operation.
> 
> By the nature of params usage, these requirements should be
> trivially achievable. If the driver for some off reason
> is not able to comply, it has to take the devlink->lock while
> calling devl_param_driverinit_value_get().
> 
> Remove the lock assertion and add comment describing
> the locking requirements.
> 
> This fixes a splat in mlx5 driver introduced by the commit
> referenced in the "Fixes" tag.

Just to clarify, is it possible for mlx5 to take the instance lock
instead of these changes? I agree the improvements make sense here, but
it seems like an alternative fix would be to grab the lock around the
get function call in mlx5.

Either way, the assumptions here seem reasonable and the series makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

> 
> Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
> Reported-by: Kim Phillips <kim.phillips@amd.com>
> Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/devlink/leftover.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 6d3988f4e843..9f0256c2c323 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -9628,14 +9628,23 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
>   *
>   *	This function should be used by the driver to get driverinit
>   *	configuration for initialization after reload command.
> + *
> + *	Note that lockless call of this function relies on the
> + *	driver to maintain following basic sane behavior:
> + *	1) Driver ensures a call to this function cannot race with
> + *	   registering/unregistering the parameter with the same parameter ID.
> + *	2) Driver ensures a call to this function cannot race with
> + *	   devl_param_driverinit_value_set() call with the same parameter ID.
> + *	3) Driver ensures a call to this function cannot race with
> + *	   reload operation.
> + *	If the driver is not able to comply, it has to take the devlink->lock
> + *	while calling this.
>   */
>  int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>  				    union devlink_param_value *val)
>  {
>  	struct devlink_param_item *param_item;
>  
> -	lockdep_assert_held(&devlink->lock);
> -
>  	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
>  		return -EOPNOTSUPP;
>  
