Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5551666770
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbjALAMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjALAM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:12:29 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70BA5F4A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673482348; x=1705018348;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tvFvqvnQz0lV2ZrSwvxsUi9DI1TsQo2sxLs3bqvSJMo=;
  b=FboFLE8QOIRpxIEhVrDtM+6OxKXT/Ad5ph0lxg7xPjaREaDbIwKeVdD3
   hWnp+BaNTPRXB2mEbYWnLdhu2fyIgfaQtpsCHr2S+4hZ+UZ1MLb88EpXW
   IXTBVMoxgB5GOyq+poNnT2Q2nkg6FiFcPvSoxmBgM+nxbudu9rbHC/Qo9
   rQHuTo/ES3KsOsZ+Y160WYC8HSYHXTlN9RyDeW/cdXDV0hs7ySvUXHGVc
   nDz0vUI2yrC62FWE5LBuvY+JapsPNXqa4vFpwqOsQy2vMa7WBJGJQRiid
   i2PFkSS4A6JjVysQTe0gukGuMox3Ig6QnjwFP9JyifHv/V7+dKN2WXqSS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="324810738"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="324810738"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 16:12:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659565440"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="659565440"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jan 2023 16:12:27 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 16:12:27 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 16:12:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 16:12:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maPJBwOxxDcxwV7tVfhV5ndVWNyk53IsbkAH4k1SZIKCqwBo/MHFy1an72kIN4UdAyB59l3758gfu1wuTAuuQb67I6yl9NuhXqsBCB3K0lWvnwfIHqHGcQDoajyoUBRud+0KuIY/sppqVFpKuklN0irucgU9ncifbP53f6zFFfWdn9TUvokeM9x8R8JNdQzuzdDQFWYftItzkLFuk5d/xs19YznK3l0dW5VAB/FxJCOiKy07nzjbXvrHx3+WnVdVRhH+L55gxYnCBWXk8K+h8EIq3R1koJxkZrlVbP8FgLaEcvHoYl/rmR0H9VziBeDfQhresvs4HARofhnDVuyxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ky1cPpqzwJyuzxD+/X7tP6fjWZwkycboV3aJTn1SQms=;
 b=XuentmF3kfFYI1oM6stH73BiwujecwqSBKqHBZL9wQyo8fNn0EXQufqSdQL4zCGNpHP4mZd7U+03c7/JEBhKZZJeAF68JmF6XZBpUfefyAqNRQb0R5VmVm/ZpZ03XUYyT8vkPITNtPQEmQz5aWMFAaKHKqf7rxXClt4QdL78MHSDpouJRDXVYPSDhQ2D0xZRoGZlXIzy18FFQ5tlM6Ds6sJAzgqwvvRN/MDhG7YKhWhkayNzkCsWitENZrl2qGNFn8wyM4a2Bgt4kVP0t1Z07q7RxPJc+xlswSMpjf0916yuzTtWSruMRufx9w4xHofpv4eX8nqhkh6K9y33RgBF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by DM4PR11MB5278.namprd11.prod.outlook.com (2603:10b6:5:389::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 00:12:25 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8%6]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 00:12:25 +0000
Message-ID: <fcc5e230-f50d-486f-9f01-b9c7d52efda0@intel.com>
Date:   Wed, 11 Jan 2023 16:12:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v4 00/10] devlink: linecard and reporters locking
 cleanup
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230111090748.751505-1-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::36) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|DM4PR11MB5278:EE_
X-MS-Office365-Filtering-Correlation-Id: 3acf9d07-c23d-423c-e1b0-08daf431af29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2hV3HYZ3gHoBKWCDES/ci5REjtTsXqtYoFG6Ods3WILALQ6McKF8hCLBNWbhWc3dFEFWmsALrvQ8SRF651B+duto2dtCT4caGK/GCDa8ZW/YNLmgEnaeHu2U8kUqEZLjmpwjw5PITuzb8qNuxZw6kdrP/QanyxBzwYw22Jb/n0Kb3ZAa/k2CkwdH4lbNOtbaJHIVwVjxrm3nuN8TQM7/swv+x1FKrolKHCeD/9cW7vpOw+ABmtRWW822W4q8eWe87iC+LwUp1gZWeMRWOxaZLf4OAYOiuxSJmV53S/h2GWtAGo1emrztjsh9ZeLjap9gMMmIZlwG9d8oeksYeHMusO5og/hNDxV5Ws+102ZvZHm2Bnv/pJmD7g9dSw/D4/E/tSdEKVcBkbSAyVvv05UlsFMg11/HPcdNgkdWtSWFw00k/aZMoUw6qdYG0xBRwW/CXRUGM77Q0le0u7Deprb0kGl4lZcNNqZcFPvpYnbAI4N6pZt/LGuzc7Fk+sNecIV0i1BRG9ofmBSIVAZZxQ/+v+L5ie9f7L7M/Nwr2IXWxY6mSHh0mVs20xqS7IlN8LZiLNNg2lvB9PJBbXRK7M6U01sH0wOE68f5y1OXS3pSuY6NGxft32Usv788ywXH5ulYGZnu86x0ShLg9DXnHzCcHSPJKoy1K+fvqLvZhr2eAMetHiOtCf+428XVmdYim4kWSQwyt9lLDrUXkB7roFi/bfUPGN3VzNgwi9xIyzwbwU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(8676002)(186003)(316002)(26005)(5660300002)(6512007)(86362001)(6486002)(478600001)(2616005)(7416002)(31696002)(41300700001)(66556008)(4326008)(66476007)(66946007)(36756003)(8936002)(83380400001)(31686004)(6506007)(82960400001)(38100700002)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0NjMU1WUWVuRW1pOGRMOHo2WGdwdnpXS0FjVWJxcVU5TXh5SVNzMUlScXMx?=
 =?utf-8?B?TkNHbzZ0ZDcrM2RMSjJNNmVVanhPc3A3UVBKVEFCQ2ZxWGpwZ2FhZEd5VDN5?=
 =?utf-8?B?Sy91YWczUEhHVTU1eU1YcGtoMi9ORzB5ZVp2MzRGTVZ1Ry9IR1pLdjkvWUtu?=
 =?utf-8?B?Zm9ZR3NNcnhvN1lUSWN5Tit0Wk04dW9TNHI2R00vSFBqWVJRRzNFTXorK05U?=
 =?utf-8?B?NlFZOUZmdUIwRzJTa04yVU9GcFBJTlI3Z3RiYlJzOWNua2V4SXZRVFdqRkRW?=
 =?utf-8?B?Yy9kblVtbDE3QXR4YkswdXdDM0w3aHhtWVJ1WmxqRGNpVXR1LzA4NEJOSUU4?=
 =?utf-8?B?RjVUUFB3UEhPckdESzdXQnQ4VU1CekQzQ29ZNlBKT0tDdVI5QzNFaHZ2OEVF?=
 =?utf-8?B?Q3Y3eHRwQWtXdTJNQVpUTjF5WUNzblZtU21POXgzTGxwVkh0MFN4VFduajgx?=
 =?utf-8?B?aE5haU9FcnlXM3Q3cnBxdUJUK1NLUE5aLzZKbzJXK1p5S2dEazc0NHoxQXho?=
 =?utf-8?B?NGRTN1ZkbS9uemhyQkdJbzJoZ3BPcUxhcExDUm9FL2pLcitHZzRueTM2K2sv?=
 =?utf-8?B?a1dBdk1UeVhBK0tQM0JwZmhBVTdDdURjbWRlazFIeDVBOWlVM2xycjdiYmhQ?=
 =?utf-8?B?SEMxVXFyTnoya3ozQThQTkJZYWJmNXc4a3J6UUp6My9WS1d6RUYvbU5ubi9D?=
 =?utf-8?B?a2NkL2RVL3ArVTRvNFU2NHdpSklBUFp4UHVFTDRtYU5Ya0JhT1RWR0NXSFF2?=
 =?utf-8?B?NXMxNGltM0xvYjZ6SE9COERVN0Z5b2pITDVwSW1TNXNTL0M3RytmcDFFOFRM?=
 =?utf-8?B?ZDA2SW5KcXIzTEpHdlI5R3lrekFhUUhSTC9Sd21qSEp1Rm52V3VMam45RmdM?=
 =?utf-8?B?WGRKUGhkdzBNRHQvaDdzZ2NCRU5OMXJHK1NPL0RLN2VmcFoxdlBkZG9lSklm?=
 =?utf-8?B?cEVzMkVTZkx2YjBlUDh1SnpiZXRHcGNZTE9Vc09FbGFEelY1SlUzZTdpMlBx?=
 =?utf-8?B?NUJxakFzSUMvbU9vTmhKOVJLdDVESysreG9SZDF6MlFSKzlRenNyTWw1WDNv?=
 =?utf-8?B?b1RWR3JQNEZJWjlEZzhmWTJoZTJ2bkMxUlVIYlQ0TkZ0SE94VVNHQTl4NWlw?=
 =?utf-8?B?Uy94alJ3cEVrQ3gySDlyZ3BRWGk4TlVPOXE3YjZ5L0NkNTZLSWl0cEhCR3h5?=
 =?utf-8?B?clFITjdENXRFV0NWRGlpZnNEdDkzSk15Mmp5dlB1TGRMcTJON3JqM0cxK1BM?=
 =?utf-8?B?ZzQzalY5Y0gxQTV1VzE3RXZreVpjMWU5ekYvMG5kQ1JEWituNjhpTGJvQzdP?=
 =?utf-8?B?TUs2K1F0QjdHM0x4TmZ1Mi91U3JZUTFhQzF0YXUwbERQeWJCZUJoZWlyeEZC?=
 =?utf-8?B?cWZjTU5EdEh5YVRPaUFIejI3WWdKVE10Tm0rV0F5L1MxQVRmNXNYQ05ZcFJl?=
 =?utf-8?B?T3ZiTk1zVVJTR3NLMThLY0EvQVRGMFBpVnhKelRtU1lOQk1LTExXY0g2QmdH?=
 =?utf-8?B?WkZVenlKNW1XNzMwVmlES2ovZEdnQ2tFNzFFRjVuenk4K2tjeS9zR3B4VHF6?=
 =?utf-8?B?TlFUZzU2MitoL3pLTGY2TFpMN20xY0EwbGk1Vmc1dGxwUElSU1lOTWhMU0dv?=
 =?utf-8?B?YVk3cXFmK3dveFVjank5Qnc4VFVzNzYxaFlZdWJVeVBNd3BIcFBENk0zWkhh?=
 =?utf-8?B?WEVZd1RsMHZ3bVF5dnB2eHZUYSszL3BQV0l3MVovVUhlRXNPZkU1ay9pdW5t?=
 =?utf-8?B?dFB6U1dLYmhQVlNmZFJWM2RqZEFTRHVCOE9BZUhRK3BNOUtZdTJTdkRrMmVm?=
 =?utf-8?B?S1R2ZXg2U05ZT3FtVlZOeGd3bElyQXE1MHlCeWNTZEd4bGEwRUczOUNMYjFL?=
 =?utf-8?B?STdOK3prOXdZb0pVWmM5cEtmMUIzRkgybW5nQVkwQjJ6WXJCNnM4d0x0L0Yz?=
 =?utf-8?B?U0hxUjhnczE3WDdpZkxZSDc2bGYyMnJFS0lVSHp4eWJhWUdzZFdjOWh4c3lY?=
 =?utf-8?B?UUI4eTR1RTA1aUN3NGpSSklvSXpDeTEzTTZibEtMaW1xOFhXWHFvOHFQTzJr?=
 =?utf-8?B?bkxBb0JNbHJUTHJoWWtNd05nTS90ZzRVaVFwY1BDeTd4SUNheWJUY3hra0kr?=
 =?utf-8?B?dUtNK2xmRkFVZEhZeGliMHZ4UkV6dG4vWnNxVmJvck55Q3JsRmtmcVk2NWIr?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acf9d07-c23d-423c-e1b0-08daf431af29
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 00:12:25.8334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXoZ91FUmBBNcX8y00YQ/IpuVuppuTHhRXirfxZIYTiHNMwHdUy1OZrkfOCUb1NHm2CYVSF9BD7UN9DnF7XKY/F9Uzku4I7OBL0sxzp41jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5278
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2023 1:07 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset does not change functionality.
> 
> Patches 1-6 removes linecards and reporters locks and reference counting,
> converting them to be protected by devlink instance lock as the rest of
> the objects.
> 
> Patches 7 and 8 convert linecards and reporters dumpit callbacks to
> recently introduced devlink_nl_instance_iter_dump() infra.
> Patch 9 removes no longer needed devlink_dump_for_each_instance_get()
> helper.
> 
> The last patch adds assertion to devl_is_registered() as dependency on
> other locks is removed.
> 
> ---

I think you said a v5 would be posted rebased on top of Kuba's fix, but
the whole series looks good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> v3->v4:
> - patch #1 was removed from the set and will be sent as a part of
>   another patchset
> v2->v3:
> - see individual patches for changelog, mainly original patch #4 was
>   split into 3 patches for easier review
> v1->v2:
> - patch 7 bits were unsquashed to patch 8
> 
> 
> Jiri Pirko (10):
>   devlink: remove linecards lock
>   devlink: remove linecard reference counting
>   devlink: protect health reporter operation with instance lock
>   devlink: remove reporters_lock
>   devlink: remove devl_port_health_reporter_destroy()
>   devlink: remove reporter reference counting
>   devlink: convert linecards dump to devlink_nl_instance_iter_dump()
>   devlink: convert reporters dump to devlink_nl_instance_iter_dump()
>   devlink: remove devlink_dump_for_each_instance_get() helper
>   devlink: add instance lock assertion in devl_is_registered()
> 
>  .../ethernet/mellanox/mlx5/core/en/health.c   |  12 +
>  .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
>  .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
>  .../ethernet/mellanox/mlxsw/core_linecards.c  |   8 +-
>  drivers/net/netdevsim/health.c                |  20 +-
>  include/net/devlink.h                         |  26 +-
>  net/devlink/core.c                            |   4 -
>  net/devlink/devl_internal.h                   |  20 +-
>  net/devlink/leftover.c                        | 428 +++++++-----------
>  net/devlink/netlink.c                         |  12 +-
>  11 files changed, 213 insertions(+), 337 deletions(-)
> 
