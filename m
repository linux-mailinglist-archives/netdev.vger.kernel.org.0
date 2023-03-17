Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356876BF0C5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCQShK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCQShJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:37:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA14A497E1
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679078226; x=1710614226;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VMb5MN6sxtABetztIuCmgeeKCRzMpIZEiupuVakaZqc=;
  b=NZgqOKUq2RIk5oKdsjc1ZSeAkb2S92dUosHKn2uALUiyDzTlSIAoeH80
   fWjaUMA41TPk0ZsidVeeiyeRZ37cBx31F/3vGa0OL6Ps5QtoKnUdPYXSc
   92p8ZraWNsNCAxSB2lQH5I9GKU7T+jUQAt0mjCKYG7UAWbMepjvC5ZUay
   CwYcSbOiH+Y549QBLpGUuijnnXtxCExLqFzAvGO1X1XMGcrf6uVMXbFDT
   bgG3Owt9J6Pm4NWnouHBHzYDyafMft4dblczUAV4pCfL9jvsHGlKQtI+/
   hloz8eekqgdpvyqd09qH7nuaNg6a6omIf/iyO2usK0/tUFqw1v+2MAQAv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="403204255"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="403204255"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="926240313"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926240313"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2023 11:37:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:37:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:37:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:37:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O98rvoWVGVO8d1rC3Rlg9aWqp/Xd7kXoPAvdSXs0NQwiFzdD3ZLiWG8aD2UEQBddZFIUKAvkV6XYV0I4BQsgnpLkF4Wq7CaUZnkTjHhu0z40QkMTmO4LDOK7AxS0gGtj6JvUIaB+48kW1kuD0ZAH5Kf8G99S8HLGqdYpgWgEMYd9ZjST8ZTz9nHKgv61xWgzixQepJew7QbH+ddo3goXTSwgDxCX1xnHywb8uKcQfE2+3QIlWXeGkA1F7eRWnYkMPMUpzkV8MESYY2iWGH+ip/kxXCc8bygaZZlc2b3DSRjE3aNonDiTCn8KYqzbMvi/lbD4iSRx2WgPAoeLADd6iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VW+oiLh+KxUnroANbqmhhjzGoUbvpaaNpVLBp9mAtQ=;
 b=KoKCeh7LVO4xF3rwsd2Hw7NxbDFhv0qyagNQxat7ROYmNjCMlOCwFUYiGVWXTN36E7Lg4HtKMbbMOiBtYFW1MmEaRJWBblKq7punq9ppZ8tK672G0WnsGkK1H22lyogQPB1ncashiLXFivpYd+dQE6A5gKv7cBXMwHT/1cQ6JuNbLFyjy9t+jgm3TNG8CmbWo8WJBd7QGoJuqkDiUaW8fu3VLujXLfK/rdkKI5m/BzLc2cA838rDxAL72dIRYPlA8wFJYNCx55V4SYY9ku30QEPeEXUE6TQjIdYllkKbN7mfkE6jTBMeKOuzTKRIcxyeVSKNxt9cbrzYidJwj8JRLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH7PR11MB6377.namprd11.prod.outlook.com (2603:10b6:510:1fb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:37:03 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 18:37:03 +0000
Date:   Fri, 17 Mar 2023 19:37:03 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Nick Child <nnac123@linux.ibm.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: Catch invalid index in XPS mapping
Message-ID: <ZBSzTzAahMARSPzy@nimitz>
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317181941.86151-1-nnac123@linux.ibm.com>
X-ClientProxiedBy: FR0P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::7) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH7PR11MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: 383b5687-bbd9-41b8-8406-08db271699fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQlLXJZDgGsAJuaRXRxfa3t8JC32pKoY062eXxolS9ApYtAYdtod/VMxaJv+cc42SQKOp4w6IW9VZziYkJTA9IaMJhl1rAWMkOk4EE3dzDC29M2g9YQBpTV46t7CWxVp4EvZKFiiyedAFJGAIN37hdmLx40DeWlz0nO/rhcoOiO3vfuQmaxoJlgD6/7oMT/avXP8FhtXNjCk7teArc0lnvnz/eOl6gR+hPTtCyAEZ0r3pP+dmesgvZyQpY/vBtuZfIStPOHj3rvoGLoZx2LK/rB2cyRHZSyVynxa9e3rBspfWd69ivP8V6NNr0aCo9vvpb/IU/NKT7RI/ELF6+49A2c1VC15/2hmJZxqJnLew2zRTg1ALwrKV1UuljzP/pHCRuj7wtoRTIqrOJCyMw0n0wlkZRavkhGvH8RLW9cohBe/MR3Ww/wO/C91ThSUeS8zv5KW8yXujOIX9Nhpxkfv/L7x/WD3+FpflUHPquwQAvu5asWmBx5CD8QPZqcU2Ucw7cSzr9gy75T/4gcZXHioiK5jryIMpVBOuLss9ZEOZ1I8XRIoLmqfoLxqvZFoHmlMVFJZW4WKLotUUSOwXvQ5m5swDmyed4NjCvLNRfy7qLASMARjj+STId5LjVjevcMx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199018)(9686003)(5660300002)(82960400001)(8936002)(38100700002)(186003)(44832011)(6506007)(6512007)(41300700001)(26005)(86362001)(2906002)(66556008)(4326008)(478600001)(6916009)(8676002)(66946007)(66476007)(316002)(33716001)(966005)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KbAYagl+QaCfwz8Zg/akjUxOSi3QnCsvh1+O+MlOPe57wHFY0yJzB+vVxII0?=
 =?us-ascii?Q?l1br59Z3PBO9tDBHfCGtZmELmI8pF8a1oEihT8M8w0/bDRykgKuBYUmVSu5u?=
 =?us-ascii?Q?JK8H621bYBQO2imfwaBOJs/VU9y8fipNfdkrtRtX3xFFAQQ5QTq6AWIWdn5k?=
 =?us-ascii?Q?BgqyYkCe16SPffJBy6nkZdXWFpvVhh9zKwNDi4/yXw8EMkN+1ml+XhrGTb9k?=
 =?us-ascii?Q?AWIucCnWHSur0rU7gYYrip5kK1Kfn4I7xnNnXxhl3NdG5BJ9KXb1usacukwB?=
 =?us-ascii?Q?X/2CYJp31r5DYNsyjOMmaa+N23/mSMf0zLNxqQKGIKlUVjpNt76dJEWt0nhg?=
 =?us-ascii?Q?ofm1OK2GJBXYZkVRhOPe71ZYNYA4Z3BgK7y05Uyrzoh2G2YIq5LK3w3K3EkT?=
 =?us-ascii?Q?LQgMFAPwnyd6CHc8RU1TQ/jv7nNCAox+Xv8PHCd8OOOKpBMmfOwSiiX2Iv3k?=
 =?us-ascii?Q?H7uXvlJLQt84Liz7G4qiKFm/Laqy93QhHJ9bC6t5xfjQwGPjQaN7r6K06ctV?=
 =?us-ascii?Q?pzbBswc60W9Ybn8vf/zR+ztBu/nr/T9Yt2OwgInTHzexqZbMvTt1hD7xNf1o?=
 =?us-ascii?Q?ss63hPcsakm+khvluVE+GQb/2uKIQo/t2Fvh2pGvwjQ6QZysf94hmbjiIDLH?=
 =?us-ascii?Q?KO9UeoUOYtMe7zLERDAZgydJz7UlGT+yx3haKP47SBucuQAwNwHXezOWBmil?=
 =?us-ascii?Q?oFVzsYvJXPvrH+VbUFlu83OOLOMtjXDBfeoFvXuqFUVqLHWbMrKF2V6viJLn?=
 =?us-ascii?Q?WuL6+UkBLpzPYyVtW32mEfdbRVC26d6EeMpGRdvWZY/nQefZ7LVGaeezdrRu?=
 =?us-ascii?Q?PmON10AiwzX6vkDJGuxQyms2OZnM6LwGsJevkdkJdZAUphdBc7Ua/s2OWJ84?=
 =?us-ascii?Q?bvDzmUnIcjq1MgndiyVM3d8ms+fKenTO7ZFPpbRbAVAnPQ9UQuXIaEEUlZ+2?=
 =?us-ascii?Q?odvIyyegbZS2S9a4EQkwYc4HP8qZoeo/MrwD0xcO9+S1GEMxb4EAmQquDZk1?=
 =?us-ascii?Q?8HIn9ENy1jmTUpoJHdY3ZZxsMzvfE5PFuzdBxGfXxXVsKryuc57hSzbz6s8t?=
 =?us-ascii?Q?d2Q42vR4rptKprH8DKWXIoN9kIcgAHrc88YRpFuW813M9o/UKjICSnnQ+bp2?=
 =?us-ascii?Q?Oyq/LNrJO8HHfI7Y2HTruLj6esgO/95hlWVjHzrP0YNeQ8eQn4kl1F81QoJk?=
 =?us-ascii?Q?RGPzqNxxjX98KReDFsMp6T/dBGAYHob5F5Y4o4Ol7IoRUd2S6hDWS3ebSJV1?=
 =?us-ascii?Q?kvx+GIRpfJgpZP32Q6tuSOqoNiZwNOH7/kFduCZMSf5lRUPIhwEdCzAnM7Ys?=
 =?us-ascii?Q?sDmsY7KktnY60b27OXf1tf7zivwpJP69dS40lXZHgyQY0az+lmr5l1K/3xlB?=
 =?us-ascii?Q?Gx5oXPCXl3oYwIn9LCbkgSW5yVqsTgcNJ0xQ9Ck6lb3+gOlRQB9s4bzo1oRH?=
 =?us-ascii?Q?7XZwM4ZbuiiUEaDQW6qQ9O+3M+AjvbBduTkeof9V/w10sCfm9dy0H7KqLm3p?=
 =?us-ascii?Q?y9vJShxyGE9wKCiW5X57vuC5MZAQA6oW7oggvmsZRXwM5oVptwia0WjNc4rA?=
 =?us-ascii?Q?PUqNUqsmfIqObvzLLpQYZYurDuqfUOqs8KoUUvYZoR8V7TDKNI1Bs8/92ua3?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 383b5687-bbd9-41b8-8406-08db271699fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:37:03.0755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TDgb3V5jzZmEM3LyIsC5p2quDKIV75RhhRWZOUdIxJxKxeWlkPDR2wnNG0RFCTI+laXPYfMQBSLltOU9uWv9E8n4SrfjLVqQCc9nc7LXRXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6377
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:19:40PM -0500, Nick Child wrote:
> When setting the XPS value of a TX queue, add a conditional to ensure
> that the index of the queue is less than the number of allocated TX
> queues.
> 
> Previously, this scenario went uncaught. In the best case, it resulted
> in unnecessary allocations. In the worst case, it resulted in
> out-of-bounds memory references through calls to `netdev_get_tx_queue(
> dev, index)`.
> 
> Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
> ---
> This is a result of my own foolish mistake of giving an invalid
> index to __netif_set_xps_queue [1]. While the function adds the queue to
> the cpu's XPS queue map, the queue is never used due to a conditional
> in __get_xps_queue_idx. But there is a risk of random memory reading
> and writing that should be prevented.
> 
> 1. https://lore.kernel.org/netdev/20230224183659.2a7bfeea@kernel.org/
> 
>  net/core/dev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c7853192563d..cd3878043846 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2535,6 +2535,9 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  	struct xps_map *map, *new_map;
>  	unsigned int nr_ids;
>  
> +	if (index >= dev->num_tx_queues)
> +		return -EINVAL;
> +
>  	if (dev->num_tc) {
>  		/* Do not allow XPS on subordinate device directly */
>  		num_tc = dev->num_tc;
> -- 
> 2.31.1
> 
Reasonable check added, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
