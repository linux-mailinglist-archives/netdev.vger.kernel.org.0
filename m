Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36C696742
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjBNOqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbjBNOqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:46:30 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44983586;
        Tue, 14 Feb 2023 06:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676385989; x=1707921989;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ur//5LJb0xBMZ29KpapanRNKh+mw05AFdJR9xotzgF0=;
  b=kXyuU/pqTGcQrfUYFVAFGn8MHQvBs8yh02P190wXUtPCkPfBFBXmSrq3
   SVa2NbAM3pIMFGqqxyGCen41n/Gr9/hLxEFUARMFwXwq6oHvnolPo2IjO
   BgPSpkjisaWC6Sz3Jol6CU4LUTtPkNjsCjMWNnsEw3tGmt30GMjANWoN7
   4Sb74SRszyPRo2U2OK0vRk5ACuhuSrZLDfogNueLPJPmMKupXwGViuhDv
   qTQxu52Co4ZlEFnvmNPBc3CRFa53i5uIM6igD4GtgKx6tR+WPxh05EIC9
   IKzSxbeDLJIUgO54Oq8bJ51Jh5htOSafjsIZOiiiDS8Er7PYcxSU9X/kR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331172294"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="331172294"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 06:46:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914762540"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="914762540"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 06:46:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 06:46:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 06:46:28 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 06:46:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvV91bQpdyJdsUKW3HHlTFKnN9gxeZnl3gdyBWCPfmsk3IOL7ug0p59zjbq+ow84ieZLS1Nwhlc/yPaJ115w7GC56a/xHgDV4AxWSAHDS8ho70ZRJXc2rcMfy/+Xr6xGmYDX1Jxvcq/YZ3CR3e5heDpKqq+CYALLpJdTyLyZxAXBLOZEPfvooH6MVllLFGWKFb7jdwIaiT0ssJ8jps/uLp9n73pbe3Rfpj4jowxWf5RjcHXGdAez1JD+hw2+4q+e7TW0leDnwWmO/OoIqamjWTbkGE3g1ySk9j3/fn6vcD5X4puX6hwU9DwiRIyb2EU+mXYqWeT78QwNyiXgDbqyFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srm9u0QDzcMTohiKPHOqFTIKgiKZf6e/fLG8Xc/IxhE=;
 b=d+8X2Vn9rHvsJkHt2Zv1akyE7Rxa7Ms0pS2YbK4t4duRSUWUnAxouAJOsbIKjlYdwPRo4TGqesc/Hi/HkZklSjCYkRxS+TDEvOhC5HqI7/Nzusgml7ZsxjXEP9F4hzvvyG0YLiGlCDUIWQfh6YhlKCjFI2KJZX4g6N3XMA+sjK+SwfvinbPU+/7dZjBy2muGZkj2pmZlgZ++eSGWW7LB17HSmJ+lrYnAKO/fYPuJctXAIL2jDrmoNzqE2m0hO/SWSO/07QpTiLrD1P7PbevneNG7w/cvKTb9VZ0btZcb9dShkHKeoQK5jgAEb45op9hLo1zaingMyf0A91NpFAmEGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB8150.namprd11.prod.outlook.com (2603:10b6:208:44c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 14:46:24 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 14:46:24 +0000
Message-ID: <3cfe3c9b-1c8c-363c-6dcb-343cabc2f369@intel.com>
Date:   Tue, 14 Feb 2023 15:45:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3] xsk: support use vaddr as ring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB8150:EE_
X-MS-Office365-Filtering-Correlation-Id: 99967eb3-4161-4ec1-6b60-08db0e9a3e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/kmYCOISPiqXdH7xaPvKrk+vA3MVfPNp8lH4oKoIobj9BE9dH8+VW8joFwCoiGk9/nUYkrXKM754mFiIVkuATRF9XHN9Xh01PY2VeKrMtfSwu2Ge5Bz57SZF59tf7PV7RcZist9yylFfJBwB0vKSdPFKKFHWSM2R8BoDOekhGbwq/EbX1lKRswchWhqNk2Wj/+wWhXhiBeH/oWR5n/hg2Fk8ueLZWwriGHELm7xulI/7CN3N9tvboI8NYgXnpTQvCgasAW8w2goaEXBto1aUkrlyDOY/D6JQBysvhIxMywp9ZaBGJupWyokggY2/Shwng9aqVu7fWcCBJEJhsD2PSJJjnVLOOnJ+VyHvnKCv0cu9sAOake+N6L3QSOtS7JUnhw1PCPWh5Fs/+2CqevZe4/PL36nWPc5ZQ0zkBCPgQJIVwB8dkasVyDnu4/2MPdUcWd7kZJWEq84wvx5ftcXf0lYUJhtayZ4sMocMuS+H5219+gAmpix7r0BVGlfn2SlZU0vJwN3P1799uhlVCEKonXDOlHbWA04OPf4s5D7daRGHorzfrv2WZ0MtYtkHHrGlwLDU/tBtLaE6bHu8KCd9EX+1WWka/Nqgr7vVW2BkGgROY7+CJXh8FC0wjV7JhCe4xwDgi1Q3T4CJGedjYNevHWhgxZqgJxV5wzk/fKxV3nze2U2rv5cFtMEl46SXOP5sVOAEwJKbYpHJ0LbDs9VJESDSTa6uibHS1A+VDuRqjo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199018)(6506007)(31686004)(26005)(6666004)(186003)(82960400001)(6512007)(38100700002)(86362001)(2616005)(31696002)(478600001)(6486002)(2906002)(5660300002)(7416002)(41300700001)(8936002)(4326008)(6916009)(8676002)(36756003)(66946007)(66556008)(66476007)(83380400001)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHk4VzhiRFBtN0VqeXFwRzdlRzhzc20vc1NlK1BXSDl3Tll2VGhJT3A0bGE5?=
 =?utf-8?B?ejVwQlpwK2pOVFB4dnVzQTVIdWJuM3FzUytHWWlMcTB3QWxIdDZYMXB2bExE?=
 =?utf-8?B?T3dUbU9XR0dFK095L2o3QlRaY0c4UjRlM2FKZFhOUEM1SnNTR2FBMzVOcG5W?=
 =?utf-8?B?Mmp1TDQ5dXBGc0I3T1U3SG5HeG10cXJHTGo0cEFFVFVaaXJjeTE1Q3dndDN3?=
 =?utf-8?B?ck5uRHBCWTdKdnBlMWVaTDFkMFd4bm0rbS9tamNHaWd2V0duRUp4QnhjTklu?=
 =?utf-8?B?dnNTQVBuVllicUJVZEExWXpLelVMMnUyVTNqVXFoZUt3RU05bmw3QmVwd1Nt?=
 =?utf-8?B?eG1LTCtwWWk0S0s2dWRnUGo1bmNad05LQ0RTU0QvNHhMMzY0bmZSQWdITnNO?=
 =?utf-8?B?RlZ1dkovc2tDZlArMzJmZHlTeXN3azJwV1V4RmxiMWhUMnVnaHhVYXJtaWxK?=
 =?utf-8?B?YnlkQmV2STBsYWJQTm5GQ1AwSWxpVGJDSDhKVWluTHVsamRsOW1WQjY5Y3pv?=
 =?utf-8?B?bWM1aU9Vb1BTYk82K3RrV0NVSWhVM0ZQeTNLYzZNamJXWDFzRmhWdXVtSjFq?=
 =?utf-8?B?Z3p2eHp3L3R2ZmNSZGdUQmVDSTZISUkzd3UyUzcycWYvQWNZaVN4cTZQaENt?=
 =?utf-8?B?UWZGWG5jbTl4Q3lOWnBubnpTL1ppZWRxUGZFTkNiQnNMNnNEWmd3WXd3eDdF?=
 =?utf-8?B?Z1FUM2U5VFpPNFdhVkkxdk11SWtPeCtHYVdjWGt3dHRDRXFvUDZ2N0p1a0RE?=
 =?utf-8?B?OWNKc1lwTjdvTUlnRWQxR2lPVnE5eHdFbDBRaDg0VlVvUHBLSWZvUmF5VGYr?=
 =?utf-8?B?ZExGbDBMNXBpYmo1U04yWVRsbEgwZUc3T0tEOGF0VFhyUEZMYmZ6d25TRHZi?=
 =?utf-8?B?c2ZUeERjekxqNzcraitBckMyUEpEamJvYmhKNk1PSHZnODlmcktjWU1vRGpy?=
 =?utf-8?B?VEwxL0RmalBCSmxjMitaMGtJRWZkNWFiZm5YaEE4aXB4SCs2Z3ZoRUw4ZTFl?=
 =?utf-8?B?RUdKZDV6R2UrK0I1QVkwVFZ2b2ZqSnBrZE5jNXMzdlU1anVuUHpZYXA1UTBB?=
 =?utf-8?B?QUlCRFBiVmxqSlh0ZURVQ0R2K0Z4bWkrWmhRQjY1NGRmL2x4LzJoSHhod3Fl?=
 =?utf-8?B?UHhhWjJvRXNJQmVkVTRJTEJUV1VDOGI5dVFkZ0thdEhKQ0trVWRnNjdkbUpz?=
 =?utf-8?B?V3dzUEJWb01YUUVXN1ZYMEpxWVRJV2dBRTBHVkJIV1ptYzQ0WkhmZ21uelVi?=
 =?utf-8?B?WDNoVzc4WCtnT0ZHS3JPY3lZMWR1UVVzbGdLU3FkN2phUDlqVUhHNXR5YWhm?=
 =?utf-8?B?bElNNkhyekhveUpnWHhUZkp2b2pEcXlqYlVPbm9IQ1pnTzFzVWRjdFVvdko2?=
 =?utf-8?B?M2tqQ0k1cWNHVWNyUUNnSzFIRTNwY0hFM2taVjE2TjJtOXhjQjZQd2NMZlNt?=
 =?utf-8?B?Y1RXZzdxL0pYbHBDRVVqaGpwNldhdGlJSW4yeDMzSThzRVc3WEVsTm1NTXM3?=
 =?utf-8?B?YXZwalMveHdnZ0JIa1dkZndwTUlyOTI2cjJZZDNXZTJlR2IvSll0Q2xFTGpw?=
 =?utf-8?B?MHhpSDVhSW16bkcwcTB2QmM2Ym1LQkVvc1pwZHFtQVd4cmxmMWxHcUJYV1Ja?=
 =?utf-8?B?cUxad25JWjh2WG43OGVqc0ZhWnVUeWpkeis2aE9aL2xxZkNmM1QyNkpmTWtY?=
 =?utf-8?B?K0lPbWIyRi9SSTNKL3h1Y2E2VElsQi9mekFTTEtNMHh1ZGVHdU8vNkRCREVx?=
 =?utf-8?B?bDlwZ0t0NXpvLy9vYzFHc1JmeWFBZGw1cVJCNmROWXJGak5zblBpSzlwbDlO?=
 =?utf-8?B?ai9HVDRYZkNyNzhFYjNtSkdJRVJpQU9Qc1dBeWxmdEZsMDIxSXNzWkVrZjh3?=
 =?utf-8?B?YWtOajJNRW1sdmdzK3ppOUFDckIxQmc3ZlZheE5iSG9XV242T1dNS3hJRXZs?=
 =?utf-8?B?QXhDSnU1MHN3eEdTSXk4NFlOblZxOWVLU0lNVzNBakRCZnJwU3lmZjVXTzJs?=
 =?utf-8?B?bW5QNmdWUHNHMjNkRVZ5R2EvZG14ZTljV2wzZk1XRmxRM0diYmNxUU9uNWFQ?=
 =?utf-8?B?MUpBL1kyWnBhODQrcHMxVWN1YVRXQXJ2aGZ0ZG81U1hEeXQ5RGN2dld1M2R4?=
 =?utf-8?B?cUIwdmIzMWVjTmN5R09UNEN5MVpTWXdZREczTEhsTFJPRWVQbU12Z3VnZGFY?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99967eb3-4161-4ec1-6b60-08db0e9a3e98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 14:46:24.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgS6sEtSTi1lXDed1eRLJO+FVE5NCTOwdu92WAZoXEXZab40rHScGLT7xBXXeBTUUCg5DEMr7vy65BI8cXe15L4DXlXBN0ANN8NPnGXJXw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8150
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Tue, 14 Feb 2023 09:51:12 +0800

> When we try to start AF_XDP on some machines with long running time, due
> to the machine's memory fragmentation problem, there is no sufficient
> contiguous physical memory that will cause the start failure.

[...]

> @@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>  
>  	/* Matches the smp_wmb() in xsk_init_queue */
>  	smp_rmb();
> -	qpg = virt_to_head_page(q->ring);
> -	if (size > page_size(qpg))
> +	if (size > PAGE_ALIGN(q->ring_size))

You can set q->ring_size as PAGE_ALIGN(size) already at the allocation
to simplify this. I don't see any other places where you use it.

>  		return -EINVAL;
>  
> -	pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
> -	return remap_pfn_range(vma, vma->vm_start, pfn,
> -			       size, vma->vm_page_prot);
> +	return remap_vmalloc_range(vma, q->ring, 0);
>  }
>  
>  static int xsk_notifier(struct notifier_block *this,
> diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
> index 6cf9586e5027..247316bdfcbe 100644
> --- a/net/xdp/xsk_queue.c
> +++ b/net/xdp/xsk_queue.c
> @@ -7,6 +7,7 @@
>  #include <linux/slab.h>
>  #include <linux/overflow.h>
>  #include <net/xdp_sock_drv.h>
> +#include <linux/vmalloc.h>

Alphabetic order maybe?

>  
>  #include "xsk_queue.h"
>  
> @@ -23,7 +24,6 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
>  struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
>  {
>  	struct xsk_queue *q;
> -	gfp_t gfp_flags;
>  	size_t size;
>  
>  	q = kzalloc(sizeof(*q), GFP_KERNEL);
> @@ -33,12 +33,10 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
>  	q->nentries = nentries;
>  	q->ring_mask = nentries - 1;
>  
> -	gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
> -		    __GFP_COMP  | __GFP_NORETRY;
>  	size = xskq_get_ring_size(q, umem_queue);
>  
> -	q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
> -						      get_order(size));
> +	q->ring_size = size;

Maybe assign size only after successful allocation?

> +	q->ring = (struct xdp_ring *)vmalloc_user(size);

The cast from `void *` is redundant. It was needed for
__get_free_pages() since it returns pointer as long.

>  	if (!q->ring) {
>  		kfree(q);
>  		return NULL;
> @@ -52,6 +50,6 @@ void xskq_destroy(struct xsk_queue *q)
>  	if (!q)
>  		return;
>  
> -	page_frag_free(q->ring);
> +	vfree(q->ring);
>  	kfree(q);
>  }
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index c6fb6b763658..35922b8b92a8 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -45,6 +45,7 @@ struct xsk_queue {
>  	struct xdp_ring *ring;
>  	u64 invalid_descs;
>  	u64 queue_empty_descs;
> +	size_t ring_size;
>  };
>  
>  /* The structure of the shared state of the rings are a simple
Thanks,
Olek
