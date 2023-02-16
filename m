Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6F699091
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBPJ5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBPJ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:57:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFD637726;
        Thu, 16 Feb 2023 01:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676541454; x=1708077454;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5ogfL/EATN4MUDktzE4Xoq5B3oF10jE2dC4gTPXwaAU=;
  b=bZ21gI3j1uggew1t4jleRc4fSVYnfD1p5ZRSRSl9QIj74AzQqZ3q9Zvm
   WLRb/an6+ha8WrtpTBSRgxb8h6GZugQiYHp+iwwYSIIWQ1P16yU5zgKQK
   nCVgBSr0wfTRL6ea/OXUMXUuxXqekGG5iommPll3t/Crmv1dC9wjpFkA6
   HarqWfMPcaoEc9Xmq8r523rKEFAsk2PrOdBwz5CToR6iVadURppyZz0qv
   XYLex7Y8CNRpn5pqjiUNZkoInbsuc6ZicIqrmTF//AdEc8As5WFE1Sf7o
   H74grau2Gf6VUCo2au1URVxU6I6hLjSLufvYuREYylnmFSGI4kk4cfrGh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="331676220"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331676220"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 01:57:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="844092565"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="844092565"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2023 01:57:33 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 01:57:33 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 01:57:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 01:57:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 01:57:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVaNDwuh/sVTR712oELAcVFo06IvtZJowQlkQu99kYtdAnLqCSUBEz9EoVu53W5efH7JBWErdYfOZwsj4TqQndHpoL6tplbYtemLisFBU7SzU+98L/Ye/WWNijHaC7tE8crys/Nimr/Qd5bS5ZGEMRmSUljO/2V7DOBXXupyOu+FnRxUZdZjywNhOi7o23pl65LI1zhnmtCMbEeBozXqvga+CQj197TYpAXJT6gzYdDmRKQOHpojHv8PPiw62n8azf/qL2oTDX6DJRcK4/wnbM9pFt9o5OpIj32ycYF+BtnZOSi1D01bywQNWTq6fWqhteFbBdkgGu0Y68IHcb4OCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOnsPv5F0+TLXJc3uQ09fJV895ppbVQ+XwMgaizlcds=;
 b=G4TMrgt/fOSJxuknIZocnuJu0rXA/t+K2z8T6SJIydM8MeK1UCjqN7Jcxh4GfL+ClbBnyQCT6u/9JfN/iOgn4fwou9zgTYaZ/p1ygUk99ZwO7FDFs0W0/DWBAHlQHTZDfKZKmXrVQLsELU7fZLyiB8rrSKsGvLRomcpYI+bLRG3GGeN2c0sLdCrCSqgWh1BFPnfbl2qrLXf1wMo0Q+oejrk6sO4ZwZyUFOZ6FrqzQGas4hEirT/m0MU9SvnAtUF4f/Z0DiHMGun+N9yMjtF3ZgfO4Itu957sMo3lTrcToINzrhfVvyjUCMWiJr+bhz1HtbfpqBqPsoVMxfp0AAGFbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5460.namprd11.prod.outlook.com (2603:10b6:610:d3::9)
 by IA1PR11MB7365.namprd11.prod.outlook.com (2603:10b6:208:423::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 09:57:26 +0000
Received: from CH0PR11MB5460.namprd11.prod.outlook.com
 ([fe80::47ef:28b0:73f2:84a2]) by CH0PR11MB5460.namprd11.prod.outlook.com
 ([fe80::47ef:28b0:73f2:84a2%8]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 09:57:26 +0000
Date:   Thu, 16 Feb 2023 10:39:05 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
CC:     <kgraul@linux.ibm.com>, <wenjia@linux.ibm.com>,
        <jaka@linux.ibm.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net v2] net/smc: fix potential panic dues to unprotected
 smc_llc_srv_add_link()
Message-ID: <Y+35uaLd03AqlWdG@lincoln>
References: <1676529456-30988-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1676529456-30988-1-git-send-email-alibuda@linux.alibaba.com>
X-ClientProxiedBy: FR0P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::16) To CH0PR11MB5460.namprd11.prod.outlook.com
 (2603:10b6:610:d3::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5460:EE_|IA1PR11MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: 582759c5-685f-400f-7b82-08db1004350b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQovB1loGl4WYyyE5K0niE6prJVNyajmKo9FaKrtKSW+ipKpLQ2+m3qFON1caW5MIus5lUyzbuAqW0E7iEhRJ2pVAvYp+vTlHZkpbQvpbYfAd1vyx4XNeGRqp9L94IuHE1KB8AIdhuB/746k445n5RACHIS5AlWZheMnfb5BZ0iOamXLlvi/n5z2ZzhWwqNwQ0BB50mzM3OXvyddcr3rlx0AC73OOJXPjNz3u82atSpLsIDXgnSBfRr1uAVwsvnt0wU/rHlAnaFxLFQ6pPDau+X75gxiQgrA5DMGlPlwRqa1Y5ycrj3VmnmJH9a30BXcD3WqvseTW4bsVn5wLwEchcrZO6sOEFSzTDeyNux5/TM6cfhLJ2fzVKQYKfR9nLZEllsAmqnzsVe6cqiqE+48LVL8NOxPvSLbjxbgPtzTxqI34O4mQ8QaJl/mgneKH7o/0odV94Lc/wob/hjSAlofhtDCsFcDiQafbH1MoAcqsp/D3mjdBrYVcZublHNkCqx0D+N5yGHehwrG0dn/zFXmmgEqNR/lBO9H5byHOJ5KP1X5laxikG34K6/FBXvaNcJT/aI5K9VoxkL/7qV1i/kY7/twTwSjIcqngdCjlmoVMWV64dSv8zqMJ4Fym/LOHVu0JkdyvLVKNaN0DlYp0R3VCwPenvWvfwURQ7BDKrQVz8hEFGX2DS7eFht06LBRBBYg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5460.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(44832011)(26005)(2906002)(186003)(5660300002)(8936002)(82960400001)(6512007)(6506007)(9686003)(38100700002)(316002)(83380400001)(6666004)(86362001)(66556008)(33716001)(41300700001)(66476007)(66946007)(478600001)(8676002)(4326008)(6916009)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4SxqGsVR2TqFHtFbV2Pqpvuhn4m/2OhgAoxiCa0q2lrFW/Q9QOolTEcuNome?=
 =?us-ascii?Q?yLCP8LWSyBZZmi2+cUw315U7UuGWdm5LyEfakd2OH/vMNmqJTQlRWuqvjvyr?=
 =?us-ascii?Q?S94hdLoTyVvheET/PIZI/Nm10jL14W7dBNYFdJ72FrbptVUf6NASWlPj0OfF?=
 =?us-ascii?Q?1lO4hC1RowwDUTcS/ps2e6GjXOWAChPxP5ltfDBcvZQzFvM4gObxNTgdSZDL?=
 =?us-ascii?Q?p5/La8oKI9C/GyZ41I4lH5tRVkNgtSSEPQXobdBkhgKcI7J2nFa1FbvyBeWo?=
 =?us-ascii?Q?4DHpDYDnNshF4G2kSuj118osZFztQLj29WXh2D64Dj+iv2q1Xgy4Tolw4Ouf?=
 =?us-ascii?Q?ewb50ma6x9SHczF7bjSv1kCj9t2vAlxijgNGQ31Bf3kzFqAvP4xb32MUsEtb?=
 =?us-ascii?Q?hvdT2SdYCjXBEOSKRfJ9Odnxc4+vbtT9Pnn/Heyp18RBDA2D/8vCJ+dvpI+D?=
 =?us-ascii?Q?MTRui5MHuMMjLmcu6cYiGPzn/l2hOz1g9tedMEFdXXJzGlbzrWlbg+Y3SvGS?=
 =?us-ascii?Q?u4QCG8a6ia+N4yaJe9H/EghLK10gOPVeJJh1+A6nvFQHzF+Wvkyw6MAA13Xo?=
 =?us-ascii?Q?E4NEt7w+2PTeM9NnVpMXQNuoplZmOGYH+59XGl178Aj2VNGHUidOOFXfN7lP?=
 =?us-ascii?Q?Kibc5wkCcaxYp65tct/fZ1u9NjsdmC4jbd8TpIUUYyBx+01aCJzdXe9oaKRC?=
 =?us-ascii?Q?kwzT7mVjkj6OXAPHCKb4pTFufwfBog2GRbgFCKJKaPYkJoOh5xYooy/doKYN?=
 =?us-ascii?Q?rLBV9quU/0rNSYMXcdCKFcXqMKBgTyo1s9REqBDae6ng0fPTyJdBtfP+upuF?=
 =?us-ascii?Q?f2rabMZjtdCvCjpMy32bCW9HY37yhHhqbM31heA7NjEtaHc84JEFdWi/tLZi?=
 =?us-ascii?Q?irB5fqIA4vzXJBAVdqFTYITYfpijgzSnua1QfC1cfH9AeLgFVODDp/+8nSMe?=
 =?us-ascii?Q?mtZJnsDAuCtOOKqg71rHUppMdYspf4GnCewAeakEK7dOMxeo6RY3+vOMjVRn?=
 =?us-ascii?Q?kUGNGR3S/lkD9a44BM+/N5OQ6X/s7UUXJ36I8ICJv6LbK3Bh835fj3UjDW6r?=
 =?us-ascii?Q?ZA6f/sWgoBjWPlo+YCxVfhUQoFRL6m8z3JJp318Bdvmu7x+spkpCFE62BuhJ?=
 =?us-ascii?Q?JYqRa/97YLCJlGPxoJ4hiwjSu6eqnVzRYJikI823+aAHwoEPgs9CIPTtxxYr?=
 =?us-ascii?Q?Z0GE2//A2uDRSsGpIKeX3gOqrSz8c1rwNwkSJwODAYb+r3Wd8Bo3iFW0w/TG?=
 =?us-ascii?Q?LhByaZW5jEcJd+L46ysmbdfg1FOcDelZ2q9PVJN7wlcjbrxv3GRIUWeCurrw?=
 =?us-ascii?Q?P6iBFVxQg2ZnshNax+/zV4I1dQNTfGIzItJpVD5Ihirv676IpWBTVQ7PeoiT?=
 =?us-ascii?Q?LXKbQIy1MkjyEdpOR1ZKxB9iH8AkQR/fAwaIv3NZhQZ9wHReHPtscrEd5Kg8?=
 =?us-ascii?Q?5cAPiQvKUJaj5TqxL4/NrTOro2xX5ZDbS91T4cLnQVapTMlhyi5XCYsRSnkV?=
 =?us-ascii?Q?ez97JyWzfN8WwgseDqhm5PzuN2Lku7htdAP+AXSizvBuPKHuJMVvG0vY5En3?=
 =?us-ascii?Q?AlV0z3xdsTAZZA6lRiKiMb2/rw8CsgMkWXsn1fDSpRWNMQL1nlAYS50GoYfY?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 582759c5-685f-400f-7b82-08db1004350b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5460.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 09:57:26.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyyKH7IT+yvT7O8o9ekA6hbziLGPpoYCec1YwJ8CD5dwm7rxTtDKye00prRD9KppewmA1NVsxhG0x9vzGMiDFIHSSaQKDjOjs68PVbapjV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7365
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:37:36PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a certain chance to trigger the following panic:
> 
> PID: 5900   TASK: ffff88c1c8af4100  CPU: 1   COMMAND: "kworker/1:48"
>  #0 [ffff9456c1cc79a0] machine_kexec at ffffffff870665b7
>  #1 [ffff9456c1cc79f0] __crash_kexec at ffffffff871b4c7a
>  #2 [ffff9456c1cc7ab0] crash_kexec at ffffffff871b5b60
>  #3 [ffff9456c1cc7ac0] oops_end at ffffffff87026ce7
>  #4 [ffff9456c1cc7ae0] page_fault_oops at ffffffff87075715
>  #5 [ffff9456c1cc7b58] exc_page_fault at ffffffff87ad0654
>  #6 [ffff9456c1cc7b80] asm_exc_page_fault at ffffffff87c00b62
>     [exception RIP: ib_alloc_mr+19]
>     RIP: ffffffffc0c9cce3  RSP: ffff9456c1cc7c38  RFLAGS: 00010202
>     RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000004
>     RDX: 0000000000000010  RSI: 0000000000000000  RDI: 0000000000000000
>     RBP: ffff88c1ea281d00   R8: 000000020a34ffff   R9: ffff88c1350bbb20
>     R10: 0000000000000000  R11: 0000000000000001  R12: 0000000000000000
>     R13: 0000000000000010  R14: ffff88c1ab040a50  R15: ffff88c1ea281d00
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff9456c1cc7c60] smc_ib_get_memory_region at ffffffffc0aff6df [smc]
>  #8 [ffff9456c1cc7c88] smcr_buf_map_link at ffffffffc0b0278c [smc]
>  #9 [ffff9456c1cc7ce0] __smc_buf_create at ffffffffc0b03586 [smc]
> 
> The reason here is that when the server tries to create a second link,
> smc_llc_srv_add_link() has no protection and may add a new link to
> link group. This breaks the security environment protected by
> llc_conf_mutex.
> 
> Fixes: 2d2209f20189 ("net/smc: first part of add link processing as SMC server")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
> v2: rebase it with lastest net tree
> 
>  net/smc/af_smc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e12d4fa..d9413d4 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1826,8 +1826,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
>  	smc_llc_link_active(link);
>  	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
>  
> +	mutex_lock(&link->lgr->llc_conf_mutex);
>  	/* initial contact - try to establish second link */
>  	smc_llc_srv_add_link(link, NULL);
> +	mutex_unlock(&link->lgr->llc_conf_mutex);
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 
