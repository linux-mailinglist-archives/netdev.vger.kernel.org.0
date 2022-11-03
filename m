Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76EC6185CC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiKCRKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiKCRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:10:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1827C10FF
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667495358; x=1699031358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t8ZKObyZbXsR86fzmQj8nK8Sd/RYnnuk3rdsomeSWmU=;
  b=Eq4InyLhWnqM7r/pZ4KW7U1eTpCmpzb2EayqyU34qNfB139o6IHsNDst
   pNKFzEnRkRAn5Dn9gt3BS8UiSdeeUh6GtKjS2wvQLnHpV/Azb2WLSHRWr
   /cAsMD7nPIxZbfrwwY5z7nnrOnCTfYG03s8EWctqhkEUXtkzQnPuIYLcc
   sYwHcYfRWnp+BXsfgs7HS30m2zHxztRoNlMcGTDL97Ym/z7VwJvafGbi5
   9oNJnpHBdVKx/wUXmCZ3OTlzzdLyuIFdWzXa8DvYjUk28AIsH4dSw3nvV
   kwbOHXnSS9al/Au1Pgfe3HpwuU8Sl/D9oHVOnWMriv4FM21scWip2457d
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="371849088"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="371849088"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 10:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="668043066"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="668043066"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 03 Nov 2022 10:09:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:09:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:09:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 10:09:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 10:09:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yh/yrhnqNxQR48JcTLwenUrX7Y1IWF5p9CkYsaKSObfWd9Uo9ORKVvmZtCMB3XcIkAf819n8TnOW0DHrDNV2kpwGITa1RYLAO3obXVsougTPVgdQmQAvSMo6WYIE00phLxRT2f/imIJy6rD8w8plk9Z5VgFAP5LtF/wHPUGp+tjlDmWbNoR2OCnOqg0S6hGgMmlzVKfFlR1wRo65f8ddV1xOMfCM947sh74FxdDXVJOWR7vAzXbKTWCOwMbwv8XonodvFnSGAUvycdpr7NoVcl4mAQ6iy8eWZTMcYJq5k3YH6Bj9M9uoTKytJqTzBDcPUSSaPpaam/ACw2L5VZ4/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWAQVcTeYWA38eWeX88b/Q76YWo8SYLaZgw1Egq+F5c=;
 b=jtoZg1ffJ29lTOfr6luNuZSQpds86frLVecYHW3IVG8LY4Ue6nm3je5z0G3l/vM9j68758lCswfU54YyNH3QrdHwRJJK1loduH82kzcz/jhEnDS7eVt1sXvTximn3bPdoAw3IdKVHHNmMuHptJ5SJ6HfmNaGpu/A8wOr6sZajY+xNS+FN2inHilujv4MgpHeFsoZRbk+mruQPBfT8oJHFebnHMWiaadx1oy/XfdFXF6YUHccW27UeZDX7QeA5tvgkTzQJ6lECqbprVkLzaLeozzmYUgPuFbAyn+XjCNYvNnmqRHmjAczDXn8WJQiIBcAor/YfWS4PIPqi8xAp9x5Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 17:09:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 17:09:14 +0000
Message-ID: <3b07c567-1fbb-097e-a796-c9114a4ee501@intel.com>
Date:   Thu, 3 Nov 2022 10:09:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v2 00/13] genetlink: support per op type policies
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221102213338.194672-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221102213338.194672-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbfa0c8-65f1-46c9-1365-08dabdbe225d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Af/0U3xPtRKJ/x2hBWlMyfsiz8WAzHqjQ4rs3oO8BEMPgrw4tMdOmMeYUc9BQF7O+GGnKs7Q6ffok7Fr5Kr/Srs2y7t+07wbRRGrZPLcyDSun2nJbi3HnXZGidapCLsluowSemtL1X62j22azGcRuJqrNeDLOmZqDiQWO3TwMQQWg2Bkwimwj1DAT13hwF2D2rRzrUMHDobt5NpQEdw767y538rvT9HVAkUUugPW/uDvpZm08Ae4ebBEApZtpjTJmX/7Hf6XfakjCtAEzwaKMyR3VEc5hiP4O1uMfJDGIxb4XJj+fYMcytQVCJ0laXGNZbgVBhEPKAc86Of8KWesfHbrdJ/0Yty1HKb7Eh+1xuhNM0845kYHYDLSEr9wf6GqpthOM9rk8tbQir/bOxQYk3ChcN043Gvfocumdr/KFMPxjzw5V1Iw25x0Czwi6LFGoJJ5qyrEVu73lwfeuNRxBlRBNAZpUBTlUYot3JD47eb8qe3ZB9HwRHRvurWTjyICeEuikxEInvSEhQgpF5K//F5tYtYyGY6s05L02BCnd/btDLhhsgJUxRtM4gpXSTbQSum6eFVNJo1XctXWQHj/Jb//n093em572b/g5p5oo6uS8idzF6mVDyS8rap6CgL0iFRIxxCsKP1sfSGKxq1ml5jVNC8c7mtJ700NURSyOnJZyXNV/Lpq3TF+LXuA9qX01mriis6430Bk3TdnamwGHYFIaDqj5AAg6xOIditty502P96LjbP+mfVg4ItX9yS8XODFSlhqSYhMNG9SifewwggrkMXeMx+pIwvIwgY5NLXza6004G72pPlTU/TMzCtnTwcKNSVhdQ6CvIwkVKDGJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(31686004)(36756003)(41300700001)(8936002)(2906002)(966005)(7416002)(6666004)(5660300002)(66476007)(66946007)(316002)(82960400001)(38100700002)(66556008)(8676002)(31696002)(4326008)(478600001)(86362001)(6512007)(26005)(53546011)(6506007)(83380400001)(2616005)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUg5cjlYblNYM2p3L3ltNUhQd01Qdzl6YTFzQzVrb1RXRHpJejhTU0UzUDZ5?=
 =?utf-8?B?Q2pXelJidjQxRTJjSmI3TnRBblF2dXJSTyt2MTBvQ1FUY0ZWU1QreVZ6NGlk?=
 =?utf-8?B?K2VSKyttUGQ1bmFRVmNrVVRTMVdHTzBNT09SN1QwYThVUUJQOUpoazdKMUYr?=
 =?utf-8?B?eUtCSkxSOHl6SHMzS1gwU1JoZG1rbjl1YjRKbjBUVDMxa3ljSUhINkF0L0Rq?=
 =?utf-8?B?c3FncDIzbnVoNkViT3dROEltWEdlN2lqRWZaNWFPNkZ6UjA3R3I0SDBkb0Ri?=
 =?utf-8?B?eUhnT1BYajhldmYzQjRoRWxQL2k3OHAxTFhLRktTMHhoNlN6M0QxUGZaNUtN?=
 =?utf-8?B?dnQrd2Y5OGg3cU9vSjNKdTl0bmZlTDNUb1RHOHBENkxWd3ExelZUZkhGaHR1?=
 =?utf-8?B?OTBqaHZkMUdZbXd1UWFUb0MyK0p4ZENFK0RKSnI2cksrZmNVMEx4Zk95Q2dS?=
 =?utf-8?B?eHVZVGRUaEtySW45UEVZaC96OFJVSmQ2NWF6WlVyZ251OHZqZ1d3MStEZzRX?=
 =?utf-8?B?T2pqUlNaQjZpdUdid3ZPWTRHd2p4UzJST21EUnBlQkVvNVlVWmNMUDBqcXQw?=
 =?utf-8?B?SHVBckwwQlNwMkh2MUVXb1AvRUlmeFlFS08vdGxyb2tqNFcxdC8zTVc4MDRB?=
 =?utf-8?B?dTJSYytySlF6a3psa2tqNXVQV2JEa2wzaGtBUE5WVTZCWlN5LzlyaTdDWjAr?=
 =?utf-8?B?ZXlwZ0RFSGd6OS9TMDFtRXJ5NjBMQWI1Wk1MWjlqZ1pHRnlrMlplem9KOXVZ?=
 =?utf-8?B?YUV6UDBOZklIZ1Q0SFc4bzlGY3FnbnlGd1JiWGhPNy8xcmZXT0ZrbmliSVFL?=
 =?utf-8?B?LzZWU2I3V2pxOWdlbjdtcWRmV0tWNGpodmVYTmtVbW0zOEs4RVJDbDNFdER1?=
 =?utf-8?B?THg2SU5BQ1ZOQmVoVENkNUI3dFRsbThZODlHUVJGSE1rSnZ5RjRoQ01CUklG?=
 =?utf-8?B?ZzNIb3NiSnFNaUhKYWxibDZnRjVaMm5zT1RyVkdSc0lqeFF2R0FRYkFwRUpx?=
 =?utf-8?B?Y3U4Z21GK0ZyWjVRc2p6OU8wQ3lIeUR2THZyZHREVTJpMWt6OFhXZ3VjaGxF?=
 =?utf-8?B?d29uc1JqMzNXTzg4ZXRnUVhpV09DNnJQbjdWYUZNb3ovR1F4N3ZBWkFjRzJv?=
 =?utf-8?B?b1FyaktsV2l2dzlHY2tETExMaVlZTHBYMWxOWXByL2VHWkx3bTJOT0tKREIw?=
 =?utf-8?B?R0cyWXlOMjRPRWpMRk0zSjcxcjk4K1lvUmhBNWRGMTJWcTd3NXl6TkhHdGdY?=
 =?utf-8?B?UnAvQ0xJR2tvZk03WFM1akVlV3JBS09wQWNBR2prV1ZySGdRb1dVaklkRXlY?=
 =?utf-8?B?cnR0REJHQ2RkR2RLTVlYOFRKeWFyYXF2cjhZQ1g1TXJFcTRTSlUyZnZ0bjZu?=
 =?utf-8?B?c21LYkcwQzA0QS85b1d1b2ZmeE9DTjI2Mnh3ZkRBb0hCSVMyNUl5cDNpMm1L?=
 =?utf-8?B?OS80cVJlNER6MUl5SWxSOWVkaEo4OWNVNTh1eVJYeERhdkFobjZCQlEvdTNm?=
 =?utf-8?B?L21nVzBUOHo5eHJMRkZrcXJnb09oUFhJNG4wQzNtN0EwT1I4L0ZlZ01menJZ?=
 =?utf-8?B?NnNjT09qOW80RjdyNDZwVkt3R0ZLL0plMFFic2dGYVc2WE1yYi9lSzVPQTlN?=
 =?utf-8?B?Z1Q0b3dDdVJ3MmJkcDU1anJKNHdwQVBqWnJEcGh3MndTVFdvK01MYVhGeDNJ?=
 =?utf-8?B?V00zUEVhYjlScjBPeHIwdkNmSGcwQkx5djRNbFM4QmxWUzJ0aVgydXV4M201?=
 =?utf-8?B?MVM1Nlp5bUJFbXpIL3FNNldLeGxWV0dSbzVaZTRPQ050ekRiVFFQNFNOdCtk?=
 =?utf-8?B?R25yUEhFNWRqQUY3SU40cXRJd2s3MXJybEplL3U2bEFWUUNkeC9aNm5YZWs2?=
 =?utf-8?B?QVlZU3NWK2lVNThhOE5ob1B6V0VTNFhVSURSUjNHVEV6QVBKTzNUdlZIYk9p?=
 =?utf-8?B?aXZWL3krSngxUlUzRmtCbzRqUS9taDUxVE5OWklRNzNiZWg2OG1iaWV1KzNv?=
 =?utf-8?B?VUh1elh2enNaeW5aNm92YmxkZVArZU9ad0pGM01pZlFDaXZVUjNPRGxlMjVE?=
 =?utf-8?B?UXh3QnQzeTdwc0FFK2FZa1IxNTFaNkFHN0lWQ1U0d2pPOCszc3BXR1A4WW5T?=
 =?utf-8?B?ZVJNYTdldklVK2pBSjNsVzg1V3ZGRVp5R1ZCQXFjaCtiblJ0YWJvMSt2cFJ5?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbfa0c8-65f1-46c9-1365-08dabdbe225d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 17:09:14.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tS2Qb1v/86eqHaTTLk+tzuKWfnyGgOqphMkcl3654olufgyhwFNvESAFdXKya623pk+clk+DetdtV5RykhFhw1P1V4qHx7jQI1BNSf0DN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2022 2:33 PM, Jakub Kicinski wrote:
> While writing new genetlink families I was increasingly annoyed by the fact
> that we don't support different policies for do and dump callbacks.
> This makes it hard to do proper input validation for dumps which usually
> have a lot more narrow range of accepted attributes.
> 
> There is also a minor inconvenience of not supporting different per_doit
> and post_doit callbacks per op.
> 
> This series addresses those problems by introducing another op format.
> 
> v2:
>   - wait for net changes to propagate
>   - restore the missing comment in patch 1
>   - drop extra space in patch 3
>   - improve commit message in patch 4


The whole series looks good to me, thanks for improving the commit 
messages, it helps process the changes better. I like the end result, 
and it gets us some good ability without too much cost in size.


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

> v1: https://lore.kernel.org/all/20221018230728.1039524-1-kuba@kernel.org/
> 
> Jakub Kicinski (13):
>    genetlink: refactor the cmd <> policy mapping dump
>    genetlink: move the private fields in struct genl_family
>    genetlink: introduce split op representation
>    genetlink: load policy based on validation flags
>    genetlink: check for callback type at op load time
>    genetlink: add policies for both doit and dumpit in
>      ctrl_dumppolicy_start()
>    genetlink: support split policies in ctrl_dumppolicy_put_op()
>    genetlink: inline genl_get_cmd()
>    genetlink: add iterator for walking family ops
>    genetlink: use iterator in the op to policy map dumping
>    genetlink: inline old iteration helpers
>    genetlink: allow families to use split ops directly
>    genetlink: convert control family to split ops
> 
>   include/net/genetlink.h   |  76 +++++-
>   net/batman-adv/netlink.c  |   6 +-
>   net/core/devlink.c        |   4 +-
>   net/core/drop_monitor.c   |   4 +-
>   net/ieee802154/nl802154.c |   6 +-
>   net/netlink/genetlink.c   | 473 ++++++++++++++++++++++++++++----------
>   net/wireless/nl80211.c    |   6 +-
>   7 files changed, 433 insertions(+), 142 deletions(-)
> 
