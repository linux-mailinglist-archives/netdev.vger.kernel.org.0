Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15809696BFB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjBNRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBNRrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:47:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CBBAD30
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396832; x=1707932832;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v4b2ddtXV+4BAv96D/2AfEKuwhNQ+ol7cuL0SnCULqo=;
  b=cmWrGsIGp0GqZ+ucuHtTK24J2ycP7zz1w/Wo7Ovt1LqK/00I67s3UKH7
   Xs3BGsUpbS1xnyj73mpTkVSqEy3gSu3e9NnLxNKpxA3r3FBhci4q1OjwH
   UC7oVxa+HM9eUOPcS4WNILDjfFFezq20MIX9Hp30PdRApm1U7woXHNPlf
   jqKIgW0DeeuX9qtV0BQcSvi7R/xfvP1OvG1OC/y9Jy63DHJ0OiYZ7xUy5
   ZJfZeW0YW873SjDsM4iqPTAZQUEsEaVCuw04HizCRRtGEHS7aptstWdod
   HBixfqv8W9cCHz+St9VmhfyaSxM/nF+q8enWBnO+bltg9LXMLJ23MBwPL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358635382"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="358635382"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:47:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914825723"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="914825723"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 09:47:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:47:02 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:47:01 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:47:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:47:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+pS7ZuAXBUUGr9yOrGXCiPD8UEeAas6IfkKs0xym/Fm8USZHFyFBZIRSoXLz1zoTB8wzUk6m/5r/ukA1/XX+AVB0lKZQnPnPQA4WivjUvi9ezkBSuMKzRs7SuOsQgSU9SPZVKZckElG8fomc3BBgB6rWUbODwzq47+9lcMjIAD6UF9YlhMkOaEG6DR9B39oXOMzrpZdnUq/ac0EJXTPoVNlsy5gwdm9cd0GBHsFjEJ6u41w3iZMhcYMd2L8MEzFe8uxNN3NYgV9cAShynLgJb7ECygxmJ4iH93mAZjYsSkNICHNjDc/GuVdEPiVa/sxrJwcxL1HZhW8odW7eGsLvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R6EjSvCErtt/N07DHbay1vxvds662cDmMnGYBSKT+o=;
 b=SxpZKP+bqIQrGzeMW+HKIfXKzonwvIW0XCwUF2DENWJYO/kOXHFNRIX0jHxXhFQxBYy3w2JG95kT2Ha1hsa1Ub9dJD1cXnQE6tE74cpWoeY05PAHpK/LIKq/8zVEXrPIPeWnZVr0yGi0ramiwqorKdjVNOW+0i5I8nbcHjcPjBkwYAvuIoFFfuueTAaFhQHvS28P/m0OunC1Dq3Pq1bZ9EUtjbCmi//w4/JFBzYaBhDaA2Neo7uqreOrKgdxKDQKeamd8gEvKlUGSJ2HAO42NoYwRbk19ONk+aFlO9jZsEEt1wsZBXlHu/x9lB5ESv/tZIVkV795rOHfNulqBw0I8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB7131.namprd11.prod.outlook.com (2603:10b6:806:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 17:46:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:46:54 +0000
Message-ID: <69b34732-0779-3507-e370-b0c40262470b@intel.com>
Date:   Tue, 14 Feb 2023 18:45:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: use a bounce buffer for copying skb->mark
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>, syzbot <syzkaller@googlegroups.com>,
        Erin MacNeil <lnx.erin@gmail.com>
References: <20230213160059.3829741-1-edumazet@google.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230213160059.3829741-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 749219b7-44b8-4eea-9eb3-08db0eb375b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8vEPOSpg9wMIq5Wu+cldZ7yDT6aWNQVszjJ5dbYiHJFFx4r67H8LAxitTvX9vY8ydUS6j/BvNL4qPG5CWqbkE/4yKcTgLQi2yOrM7igeZ+FRjtPAFPW2JnPsFSqQJKhsyqmM6+y1CMhpr1nM0Fzchn+EFbz3Lsrvj/SnNqb0iXkQ+HlruOLKkDjaUhKW7A+GBoctg9lMHmuDdJ4+NhyxR0oblVYOOgUMylXpt27+jE5yXtVm9R4UpKVWuGT6VsrdFWVn5zrfByTLDJpMi4z2n4+yxsd2+ptscfY50WOgcFGWNZDhnwTWIHg5CyfqraX4rE2dZbxlerST92ExWm+aPV6h68Br1NSHsc3R5O4rE2ZQjipJMcOUHDkU0yVsVVn2oryDtcK4cjTz0o37RcDAbOEfiWGBn/y8yE+uItkHYUdz27LzZzRqMBgix7QNbLr+6fbxjSeVO01H4E/X2ylE2iA6n0obwvc5T8T4bZuPg9VaHp6WdA8ypXZUKDwK7+1mGwd1dZcdosBYGopdb0MC9wkV7k8AQkcj7pO3nQm3FnGWY9gv4RMDcQr7wH8S1W5B6BaRoe51WRo9ymYUI1xsc5ZCb/Mknsl2BzsURJ++Kyem6muUEKJW5e7QZmpfDNd3nXgk0AMwVVZZ/QLPAtl0cU66gGJw7btZnC4Vwwj+UaP6HeLv6Us39rCUa71IbrP51pxFLiH80TjQuK1qzys9qppMpy28u5szRMllHImrJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199018)(316002)(45080400002)(54906003)(6486002)(86362001)(31686004)(478600001)(6916009)(4326008)(8676002)(66556008)(66946007)(66476007)(41300700001)(5660300002)(8936002)(186003)(26005)(6666004)(6512007)(6506007)(36756003)(2616005)(83380400001)(38100700002)(31696002)(82960400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0NZSUEvOEFBbEkvZ3R0a0pZd1REbXRtejFYK21CSVo0MUF4UXptaS9SZE1u?=
 =?utf-8?B?dHF5RS9WUWxDL3puWWxsZG81WGZYa0JJNkFLeUowejZiY2YvcU5NV3hnOGpy?=
 =?utf-8?B?N2FVTU1ET2NWWjZPQmZISkZyVFNKeHljTHpGTU9HVkkzd2FhaEtpb1cwUnJH?=
 =?utf-8?B?eFp5cmhzQzhuUGlYOGMvVmdiVmZaTzgrenQydzY4SWRpMC9EcHhzMHl6UG15?=
 =?utf-8?B?R1dBazFZemh5cXVmL3JYUi9IRU9EQkprSnhNcVlmY0FBa2ZnY1ZXR2pTaXov?=
 =?utf-8?B?Q24wMW9qQXpydi9GMmRHWTN0aXRqM3V5WWdnbzZsQzl4R1pXVlBFTXJMazlR?=
 =?utf-8?B?VERNUWVyc3JoMXN0RWlOcDhBVkcrRzdQOW1JemxNK3RScTRIUHJPQ3lsbGhy?=
 =?utf-8?B?aHV2SllOZUlzdTgxZ1RDaEk3MGRLUklIZFJ4V2FyN010OWM3SWlUVlNSM09q?=
 =?utf-8?B?eU9wRFlIUXd6ZStwbU9PekZ0ckZzMDIvYk4rODU0R2tWaG1xTVBtNVJpbkFJ?=
 =?utf-8?B?dkxiZTg1ZVZ4MzIyNjZjaDdNK0ZlYTZ5RnNUQnhnWlhEUU9RV1J0QlQ3UWVv?=
 =?utf-8?B?aGtlSHBwUitxZ0VMY2MxWjZjU0VYYVU0UUE5YlE5MHNMRDNCbkx4dXY1dTVT?=
 =?utf-8?B?bXZuSnk4a1BNQmVmTTMzVEJsRG9RVFFibTdHeksvVldqT01OQjBrSDA1SURx?=
 =?utf-8?B?dVUyMlJOSGdjZkphUForRDMwbkRiV0h1RktPM3ByeGgwTFZYWVdzeERYS0Vw?=
 =?utf-8?B?bm1WZFdFSC9McWIvR05zdjlLdDZqYTFVc2JPN0hMeWpjTG54OTh6eUhTK1Zj?=
 =?utf-8?B?WXpaNFBUN1JXdTByNFRVNFZTeG93Q0VYWHA5WENuRDZSeVdROFBzellCTzJl?=
 =?utf-8?B?dVdYYUYvRlhvTEhLSTlQanpQaTRXSGNrYW1wK0VYbDBJVWpHSis0aU5jRTdF?=
 =?utf-8?B?V2dBZmkxWWwvZkQvdmVIZFBjSE9uN2J3YVg0cDRoQWszUmRXVHRndld1Ylp0?=
 =?utf-8?B?U2IwNnNFQkVlRERhLzJ4eCsrVlFOVjdJYnlKNDFRcnR6dWgzaXZKTTRLczFj?=
 =?utf-8?B?ZUhFTExuNmdUZDlDYStxMkJQeG9ZUm9NSjdSemdoWVM0TFl4bkEvL0k4WldV?=
 =?utf-8?B?Y1FQUk50SXZ3NW9xcEpLRDlOdkdDdi9CY2o1R1c5UktJbHFCU1Fzc3FUWDFE?=
 =?utf-8?B?VHJjektPdy94REJMTW5Kb2x1V0VwNXZDQnh1N2p4d3p6bHIvcG9Rck1wTzBk?=
 =?utf-8?B?T1ZKVW45dGs2QWR0RlpLbkFZL0t4MU9jMElaNThpeURUMmYzKzhQd09zOVpB?=
 =?utf-8?B?c3UwYWZzeVZjbFJ5aU9ueWZ0V25CYWJieXhheWtmb2ZoQW1uTG1SWVJSbm90?=
 =?utf-8?B?RTdrSnJBSngyUDdNTmNaWVhpSk4yak1STGg0eU1HYzB3RWJpYUp6U0FRYndk?=
 =?utf-8?B?cE1rY25rNVV6TTlPU0FMa08rQ29BdW5FbTZ4elVUaFp1VFNXb01KclFBZXVq?=
 =?utf-8?B?VzJoTkZVSGRkdnpmVTNoamgvS3Bkalc1bFFLbGFVWW9Bb2U3OXcwZmFBcVlU?=
 =?utf-8?B?a0wxVjJ2a2RFdWNicFk1dHF0T0hoN1RhTVltUEZqeFFXQXFWYWlGbWg4NkNn?=
 =?utf-8?B?cDg4THVzWUhPV1VYaS8vMng4YnJhQmM4RzNaOTBNVXNyMHl3aitVajRVVEl4?=
 =?utf-8?B?ek53Y2FzYjFIRmdlMnpDWWJWaCs5YVJtM2lETE55c3FMQWVyYlB3TmNQWXlZ?=
 =?utf-8?B?M0x6N2dvQ2dLWlpSZHMrM0pjbStTbzFvTEtTemhnbGY1Y1RMb1NaMVdGb2Fn?=
 =?utf-8?B?K0ptNVJsbS9qV2oxVzF0SUduZFNFSS9zUUVuS2w5NWtWNmI5UER6WFVQemdK?=
 =?utf-8?B?MFhUVHFYRWRXNHNYYU5xejZIbmthd1JBUmQ2a2Z3ZGFUcGpyQVRWanFrR0NJ?=
 =?utf-8?B?bytSbk9WbnczU2hkZHNoRXVESUgwcDN0bXd3SDNTZnNmMzBOU0J3Wi90amNW?=
 =?utf-8?B?c28walpCSlNRRDRXbEdteGd6TGxwRG80QWJLbjRoUEYvY21WUnpXc0dRQzJh?=
 =?utf-8?B?U3RiTWhLWjRRS05rbWQvOGJtemJrZXRvbC80a2c5alJtaHlLSC9zUWdScm1D?=
 =?utf-8?B?M3JzTGtxOWFBeDJVTGxRMlkreFJnV0UvdlZ3bm1HZXdVMmpKNzVDd01uVHhI?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 749219b7-44b8-4eea-9eb3-08db0eb375b1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:46:54.0504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48hCudmrpeukJZZJCkVVVY9S7s9xlj2+2u161Cj76VjP4eDYR5rRl1D0cyIdlAaRK1KIFqlTiMCxvVCeU7ab5Ud4Emcs/YMBnJe9MfJ1mpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7131
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 Feb 2023 16:00:59 +0000

> syzbot found arm64 builds would crash in sock_recv_mark()
> when CONFIG_HARDENED_USERCOPY=y
> 
> x86 and powerpc are not detecting the issue because
> they define user_access_begin.
> This will be handled in a different patch,
> because a check_object_size() is missing.
> 
> Only data from skb->cb[] can be copied directly to/from user space,
> as explained in commit 79a8a642bf05 ("net: Whitelist
> the skbuff_head_cache "cb" field")
> 
> syzbot report was:
> usercopy: Kernel memory exposure attempt detected from SLUB object 'skbuff_head_cache' (offset 168, size 4)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102 !
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 4410 Comm: syz-executor533 Not tainted 6.2.0-rc7-syzkaller-17907-g2d3827b3f393 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : usercopy_abort+0x90/0x94 mm/usercopy.c:90
> lr : usercopy_abort+0x90/0x94 mm/usercopy.c:90
> sp : ffff80000fb9b9a0
> x29: ffff80000fb9b9b0 x28: ffff0000c6073400 x27: 0000000020001a00
> x26: 0000000000000014 x25: ffff80000cf52000 x24: fffffc0000000000
> x23: 05ffc00000000200 x22: fffffc000324bf80 x21: ffff0000c92fe1a8
> x20: 0000000000000001 x19: 0000000000000004 x18: 0000000000000000
> x17: 656a626f2042554c x16: ffff0000c6073dd0 x15: ffff80000dbd2118
> x14: ffff0000c6073400 x13: 00000000ffffffff x12: ffff0000c6073400
> x11: ff808000081bbb4c x10: 0000000000000000 x9 : 7b0572d7cc0ccf00
> x8 : 7b0572d7cc0ccf00 x7 : ffff80000bf650d4 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : ffff0001fefbff08 x1 : 0000000100000000 x0 : 000000000000006c
> Call trace:
> usercopy_abort+0x90/0x94 mm/usercopy.c:90
> __check_heap_object+0xa8/0x100 mm/slub.c:4761
> check_heap_object mm/usercopy.c:196 [inline]
> __check_object_size+0x208/0x6b8 mm/usercopy.c:251
> check_object_size include/linux/thread_info.h:199 [inline]
> __copy_to_user include/linux/uaccess.h:115 [inline]
> put_cmsg+0x408/0x464 net/core/scm.c:238
> sock_recv_mark net/socket.c:975 [inline]
> __sock_recv_cmsgs+0x1fc/0x248 net/socket.c:984
> sock_recv_cmsgs include/net/sock.h:2728 [inline]
> packet_recvmsg+0x2d8/0x678 net/packet/af_packet.c:3482
> ____sys_recvmsg+0x110/0x3a0
> ___sys_recvmsg net/socket.c:2737 [inline]
> __sys_recvmsg+0x194/0x210 net/socket.c:2767
> __do_sys_recvmsg net/socket.c:2777 [inline]
> __se_sys_recvmsg net/socket.c:2774 [inline]
> __arm64_sys_recvmsg+0x2c/0x3c net/socket.c:2774
> __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> invoke_syscall+0x64/0x178 arch/arm64/kernel/syscall.c:52
> el0_svc_common+0xbc/0x180 arch/arm64/kernel/syscall.c:142
> do_el0_svc+0x48/0x110 arch/arm64/kernel/syscall.c:193
> el0_svc+0x58/0x14c arch/arm64/kernel/entry-common.c:637
> el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
> el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> Code: 91388800 aa0903e1 f90003e8 94e6d752 (d4210000)
> 
> Fixes: 6fd1d51cfa25 ("net: SO_RCVMARK socket option for SO_MARK with recvmsg()")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Erin MacNeil <lnx.erin@gmail.com>

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> ---
>  net/socket.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 77626e4d96900b946e340e59e6984e5bab672bbe..4080b4ba7daf35a3a0b88a160299f4abd3afc88f 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -982,9 +982,12 @@ static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
>  static void sock_recv_mark(struct msghdr *msg, struct sock *sk,
>  			   struct sk_buff *skb)
>  {
> -	if (sock_flag(sk, SOCK_RCVMARK) && skb)
> -		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32),
> -			 &skb->mark);
> +	if (sock_flag(sk, SOCK_RCVMARK) && skb) {
> +		/* We must use a bounce buffer for CONFIG_HARDENED_USERCOPY=y */
> +		__u32 mark = skb->mark;
> +
> +		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32), &mark);
> +	}
>  }
>  
>  void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
Thanks,
Olek 
