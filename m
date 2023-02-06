Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF6F68C502
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBFRmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBFRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:42:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C5C1D902
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675705321; x=1707241321;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w2KQwl34j6EUqCPEKDKgJqwLgOh08X0J/4WJ/7Eemc8=;
  b=aBNR7gPxd6QnevEM/xh9RbFgPhiZFjoOtEYGcfSb9jcz2UaSiVeQjvTf
   n2jPoUVXjZUU+LCr59Soib9oK5H8pfJCm+XvKosWLUX0CA90fpJia6xgl
   19Lbn8DbmhybrHCmpWbx+KDNFwYwcRON0RooIJ4LA4Eq2RW0QfFe+o6cM
   +YWlt1lZNwhkhXRXTdp0NtulB4uSrMpgP7c/aX1zg+i353pe5hCiKK3OS
   L9Gu7hU6D+b9qZ5arMyh8OIXSjl+UKA7nQi5mVeagDIP1RMVccwxmV0zd
   hW5v6RP+GEhhiWGBLr8conQAkVX9X5iYZUAaLFbW7FDvd61sPNwSpVGix
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317276311"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317276311"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:41:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616511098"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616511098"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 09:41:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:41:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 09:41:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 09:41:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvzjNUGw8n2XVr2Okrag3GKSj5wC+m+RYOB+ahITSyaZj4jINuUYHGqmbk7ZG+kO2zZRsoh6AjvRaplpu56YJRND182yPwheknjVfp0hjHkK1glutwNHbHYTvUXWMYaCDqGOU3/P33Guo/fe+Vaw5lrlPqW8Svn2hXjTbMxdsSw2sok6mA/21vLcfsnMHyYbwrtlY0Nno+YK4kzohDktNK83+FVK4yrBMl6fsLmHpxFD1+cDjoqLUoIClB/c1Hn114BbAv7oqIQ7dL2dybW6I7ddgocXEn2RGQGGtKDSYDnNL/oDL4ANXj+fe9647OpBLP3LPoQhxL1if09phRrb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57ruhh0OIuYTWPsTdezVp+y4O10L2O3fVGVLYv1MIGA=;
 b=WhUQrVaVgUyqJpkTdf4/eo0otGwfFuxMFs6+6C4eS7kja1oumlqIFYRQmgKTVzXRRaRQhd4EVSO7UzWLsY7ttfe8YubA9QXTVotZyMMR2a0jKQAi0Os09jMS7UkR3aO03HR2gWlfdzSVId1bQzFeWOy46Xt3Kf2yTsE7cqm5eshN9BsOzbhujSVSNVUcky1zFUHpv4xTXxradMBQJnEzqO2/Dj+NmZmRsDW9NFP28V9sscXUOzFhYbTL1V+9v7lkXh8ao8Y9lheip6brt5YM2+IT4hRUJlHaKqRgDXQVmYUpUP8O2CcNT+5/a5LsVkmsNK4C04tIXkD1e9egogLaoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5108.namprd11.prod.outlook.com (2603:10b6:303:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Mon, 6 Feb
 2023 17:41:56 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 17:41:56 +0000
Message-ID: <a296797b-84b8-87e7-e266-08078c49b0a8@intel.com>
Date:   Mon, 6 Feb 2023 09:41:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/6] mlxsw: Misc devlink changes
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
References: <cover.1675692666.git.petrm@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5bb9a6-3e8b-464f-dc47-08db086970ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNHh3qkkgUthvYSLekiuSscTHe+VRAY43+fY+vqf69Tw4YUwM/hZTeMXrcp7dchu+/KtYLr1y5XMy8tqXJQUvhnCXHKaCN/IQQVPQ+65xOJWJ9Qk7vvOLS6ulFIfSjzopPX1DNxK7qMHl2/jNwP11Yf4HDFlpw0YRtffdidb9j51V+26uP77UMMWoZ/RG0JGh1aYLZ7dtOrJjlFRiO63RzrDyV0c+cMI5IYXgBcPVWhJCLHBmtOMPKY0fdCzAGlIL9JLQvUEFW1XZKrDf81I+lyy4KKao/gW6ZuEpZu3Q1rvqnBXSLtrHk0gPEgBVGEdK2ykwGaWJtQgSY2ddSDoE+CEqPbaL+r3wEQj+aiQya++8T5Z6Yh4wT5ZdHMkn9B5MDplw2jCu6O5IHhuQaIZYxozy5/2ntOkjNfqnlddBef+rF9gnFY6JaYk3UlWXAQsTr5AwvOlRmoSA9IPTGMGc9f7noFeSDezKq3U5wTc/4jgARir7RlFkVfxFgk3wUjd8TQ9sWxWi+4LmF7A2D2Fxd4f1wShnSxKxXF+SAu4Sn4cxVFvd5IGcSckO6NsDjXL4fnsZuHTk67vugN63nqlQ6uI9Y0zcBpBW0xz0drO+PHARYwZku6ktawbqRU2FVDHSZfjCGa6A9TK+zEp7OFdbJMDzrQIgQIRzSwjvFyH93ZmgiGb6f62ZCBtskPYFPMgtsBC96WS1g42ZTd+K3W9686RLxrmAszeJ6XAlsTppfk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199018)(36756003)(31696002)(86362001)(38100700002)(316002)(8676002)(66946007)(66476007)(66556008)(4326008)(6486002)(478600001)(54906003)(110136005)(5660300002)(41300700001)(8936002)(2906002)(7416002)(6506007)(53546011)(6512007)(26005)(186003)(6666004)(83380400001)(2616005)(82960400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlFBUk1obk9WcGN3ZjNmYjhrTVVZZDI2ZlVaeFRpRzlia2R6a1hTZ09CQVAw?=
 =?utf-8?B?OVB5cmZKS05UYzAvK2NsYnFlRk5POHQ2YUZySmVBeW1jV1BQeDVRMlpLN1U3?=
 =?utf-8?B?dDVQM1U5aTluMnhla0lwV01pYWM3ME5IdlRPT3RyUUR1V3ZCdmFjQzJzVkhD?=
 =?utf-8?B?M2NzUzlEcEF5c1RLNHU3cGE4SHR1K0hVMEdzMGxnNzQ4TGNsZ2JEK3dlOS9V?=
 =?utf-8?B?MFlmL01VOFgwZTZYQUhmeDcvc2dOdnQrL1IxZzd4bUNrMkZJM1hEZjVuV2lZ?=
 =?utf-8?B?NFJLN2YwRW1nUXUxMmhiTDR2bVNMOHZzUmlpSmFuZGFFTTViWU1nSTluNXJH?=
 =?utf-8?B?eE5JUE9aSlBjNVFYemdMazZKTVVJSHQ3WFlDYkRyZ2MyRzZtaGJ5Z05yV1hp?=
 =?utf-8?B?Z0Q4b1k3dk1BbjNoNEJNMzVkOHllZm1CWGVmY1lhZzBGWjZKMlY0N3JwQVJ0?=
 =?utf-8?B?MnZSS3EyU1gxY3ZpR1REamxKdTlERXl5dkFRTWVNOTRCQkNnbVNDSzN6WW95?=
 =?utf-8?B?SzFCWDlxQzdHKzdDN3RRNWljd1BvbHo1Y0FDditCSDNVeDRiRmY0U2xEY1B1?=
 =?utf-8?B?eUNCZFlOZVBhYlh4YXVMcVlENUpmcXMrWlNxd3VpYUplQTdleTNuN3dTb3FG?=
 =?utf-8?B?eVVOeElEOWRraEFybjlLUjJIWUoxN01PdmVPTUhvSGprQ1Y0d25qS1d4dk8w?=
 =?utf-8?B?NysyYVBxUWN0cmFVUzJtWWNsSTFtL0dKRTZ3ODlxN1R6UnRldDVDYzdpYXQ0?=
 =?utf-8?B?RnNwYU1yQjFWdGxVamUzNGpSa2RtZTBNbXl0SzZqQXZDdFVBTkFyMS9JRXFS?=
 =?utf-8?B?LytMaTdvcVRMNHlVWEREV0NCbVVBNlIrOXVmWW03QWg0ODVXbXhreFZEQU5q?=
 =?utf-8?B?eml1VzRIc1hxcVY2L1R4QUNtQnhYZWk1Y0Y0ek4vbXdmeG4zTFdMd09OMmth?=
 =?utf-8?B?SGFnMFhicTRoSldmbmtrRkhjWnJqaUJlK0plbHRZSXpFV1dtVHVkaFhnM2g0?=
 =?utf-8?B?RGR4L0txcmwydEF4cHJ3bStlSzdpQytrdUJrQnB6dmU3eUdZTUVlK2tmMDJQ?=
 =?utf-8?B?ajBIVFh5ajNSMGtNdk9tamZjdTY3L1JjTmw3TzlEd0xKa1UvbEpIRHMrbVcx?=
 =?utf-8?B?UHhJNHNoUGtLOEwwMDhabVREVjJ0aGhKY3VYdXYreEF4a3pib1hBOHBWVnFH?=
 =?utf-8?B?Y0Uwb2tEVDhRTmJTc3g3WmFseXltcXlqYkZ4dkxJYTJQYXZXcXZERlJZdzRS?=
 =?utf-8?B?QVFHV3k5TFpwdHQrd1lDVXJIUzBEUGc0TENVbGd3SUhkN09DaHJWM2F4LzZz?=
 =?utf-8?B?V1hIUTk3WVpMdTJwRjR2a1p6aWxSVys4dW5MU2hIelNJQUtqc0N2eGx3Y2tk?=
 =?utf-8?B?T3NHWitVUGMxQzBUOTh3SitCd0d4bWNObEZub0hNc3RkUTkvS0d3cE1udWRz?=
 =?utf-8?B?dFM2RzFhQXNwZ3BBdENialJIQUY3Ymd1R3lpVFVzKytjQTV0NmpJNU5HWVpW?=
 =?utf-8?B?SDFrNkcydkgyWnovNjZlcEJUL21vV0dOUGpPZndLTFRZa1JzR1o4S1EwN0Zu?=
 =?utf-8?B?bDRRbTc0SFpaK2wzZG1vUFd0eC9Hdkk3YkQybmc4Qm96UlZHUmQ5ZWluSSsv?=
 =?utf-8?B?Y1dzb2pXVURJcGNaTlhxOTJoSzI4Y0JTTTg3UU9jT3JhaDFMYkZ3NXZZRjRn?=
 =?utf-8?B?NjFvdC9JemJ5R1l0OWRiY21KZEFUcnNueUFodHY3ZDQrRzBQS0lGZUxPRTM0?=
 =?utf-8?B?WVZtRDh2TFFCVUYxVUZ2L3lvc2xDTXd2aGhRaDNLYUt3aTY4cWc5bG05R3ZW?=
 =?utf-8?B?MkFBdTNXSFRhUEpzOWxnVnNyVWxOd0FqMlVhQUdqY2Y1ZEs3OW1kelhabi9q?=
 =?utf-8?B?WnFmK0tyck9PcjFjTnptZEs2c0V3dmhidk43QThhRWVGcVdTVkNNdmYxRW93?=
 =?utf-8?B?RFFydGlsU2VnY1hzSjdaVGljeG14ZW1FQVBEbVRGbEVnWitxczV4L2lvRHFZ?=
 =?utf-8?B?S1l2MTVBZ2FPVndkMmN0SEdKVWJjbGRSR0tGczhrOEVudUFtWXZab2NWelRl?=
 =?utf-8?B?OWtMdkxFNnR3NzRGV2xhb1lzZ2w0cTZwbWF2Z2daaDVOSHBKUU9mMUdRbkxr?=
 =?utf-8?B?VnpmQytRTDhkUUtsZ1dQY1BjUURUb0tJdFMzY0VzUUsxOHNuVmZYWkRjb3Zp?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5bb9a6-3e8b-464f-dc47-08db086970ab
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:41:55.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9EWidxPWGiZWdLneh6XRxB6OKclJcW9iDPeNGrJMLa+xc/hqyaGFmUzc93GcA5B6cpS2bJnaKC9v8qBMvVaroYCudet8/wJ2ZiDMA/JvdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5108
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



On 2/6/2023 7:39 AM, Petr Machata wrote:
> This patchset adjusts mlxsw to recent devlink changes in net-next.
> 
> Patch #1 removes a devl_param_driverinit_value_set() call that was
> unnecessary, but now additionally triggers a WARN_ON.
> 
> Patches #2-#4 are non-functional preparations for the following patches.
> 
> Patch #5 fixes a use-after-free that is triggered while changing network
> namespaces.
> 
> Patch #6 makes mlxsw consistent with netdevsim by having mlxsw register
> its devlink instance before its sub-objects. It helps us avoid a warning
> described in the commit message.
> 

The whole series makes sense to me :)

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Danielle Ratson (1):
>   mlxsw: spectrum: Remove pointless call to
>     devlink_param_driverinit_value_set()
> 
> Ido Schimmel (5):
>   mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
>   mlxsw: spectrum_acl_tcam: Make fini symmetric to init
>   mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward
>     declarations
>   mlxsw: spectrum_acl_tcam: Move devlink param to TCAM code
>   mlxsw: core: Register devlink instance before sub-objects
> 
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  31 +--
>  drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 -
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  62 -----
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +-
>  .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  21 +-
>  .../mellanox/mlxsw/spectrum_acl_tcam.c        | 244 +++++++++++-------
>  .../mellanox/mlxsw/spectrum_acl_tcam.h        |   5 -
>  7 files changed, 161 insertions(+), 207 deletions(-)
> 
