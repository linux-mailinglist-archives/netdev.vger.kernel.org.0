Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8166308C0
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiKSBvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiKSBvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:51:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02FB5F5A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668821131; x=1700357131;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Yl+X5eDBKNwPMbXorxbvScb4Qd2k/2v2+TFCZbAJdz4=;
  b=b8TywxCjBiXUS+Qu8/2vJi0KXRgqHCskbB2zKE2wrE3WYSmrhuizUeFh
   DEK9bW74NzcHFg03KRRFf7GsXVEtUzWEIzdCiDxAfwJfg8w6vxazTJk0H
   eXv00dEvujXR2CaZiCQahcpaepHENMOfsCNq6TolYc6rsvG32IcrPb6eP
   QiImetIIG4Nxxt8HfV7hvR9t22Ulq/wlAB/p020hnRNzTqnImkJTpG1ab
   6uLtkR6tXYyom8HZGD3el/dpMR2ACLUiYAVXWO72O4HdHNWCrc2vcGDOt
   sykgKQ7VVDcKwbP9nngD1BZfjjeyNWC9kMii7pcxvSVxcWbBg0f/ADPT6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="300815655"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="300815655"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 17:25:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="969479310"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="969479310"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 18 Nov 2022 17:25:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 17:25:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 17:25:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 17:25:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mh+4a2jytWonBUYQB/d61i+iIhu5p4a9HtqEVi/rg3MJRB9MKu8sSUxxGG+unXgZa0GSEcRi8yi0BW3Nw7uu5x3xYNDLeEP2zKvQfjHVHP2Nd517biTZU9RcoIQYfS6znCq8x7SyXIv1RoVmfnsspZQJbLkDACbXydAdJB+rZtv1Xsyu6Y5RfPvVQxBp8WcAvFcmhUDc/XEubxyLQp/6V6QuYvvIPQoQ8gUcOgLtJQPDHOvspAg+VdQOKRI2/CsfThMB39ATaRu6yqRBK9/MUt50OcWhX4K0jS59R8WCy1IKcmJjXbLZYjdvkwjmZQvo/06gDUUtiow0QmMQa11nlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mI6BuH0YBgy2YPQTJ0GIO2/kl0m+I6FvMQiqmVMHQLU=;
 b=DFE07V8HLbnYO7c+dkrvgHVXI+nnhHfnGPl8yL/R0uVjSwwiKe7jxdKEXc54CTC7/kzAe/LhWL74smj1GM03BjSXegiq0BBNd1j0sASQy2ycBC3bBQodZkrqSDa4uU04PflTSaMPGroc4XtJgpOfiGpnKgLmsjiPPXNmiTHaW5bGRcsjTZeAOKJVc5gyzC/gE+bdeFrq2lSjP6yUoE/wwuAcXbZ4jsWm7woxpmFTX1cjMU4fZp2y/IlT5NkQmDGWNmfD0BlAgRONXgEy64foyUBGZyCWOVEI1VqvX/SQW+mtoQbkUIm2Bl3WGrGixz2Hbio5MbOPO1EkfuHUUZIvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Sat, 19 Nov
 2022 01:25:29 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::5236:c530:cc10:68f]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::5236:c530:cc10:68f%5]) with mapi id 15.20.5813.019; Sat, 19 Nov 2022
 01:25:29 +0000
Date:   Fri, 18 Nov 2022 17:25:25 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
CC:     <netdev@vger.kernel.org>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Martin Habets" <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of
 kmap_atomic()
Message-ID: <Y3gwheEmSDTc5A7j@iweiny-desk3>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
X-ClientProxiedBy: SJ0PR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:332::32) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|IA1PR11MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 58c7f1a8-d4b6-45af-e4b7-08dac9ccf188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/zwfx6SdPMJ3u6HbM6JsRuKYSJDtrTvSWG4TZ2fzgy6DmiqhQVjGLjO1VVPBz6iAph4A6O2Qo4Nye70lO33NHZAP8NhsDMxoeEImPDFzv2TKME+7ECvlsFBk61X76kB0NJ4wJsxQJh4lovTWb2sepR7Ah03PQtfAvnyaTRfw9PegfY0ub1CvPomny0Sm0J9iqINNKUpi32f4jqUEsdpCvMaa7dafye5f2Ppu0N0Z0biJShNLSNztAUGfnSdj5+JhzrF3rUOia40fawax/m9qEnRhlifXVEmfpMtan3N42YO+F8IH/J7gJ9LMOWWbLjR6tdi60KBmec/S+HirpITCALKaQWbIOtT5DA7mtE5/iUo67hTmYANDOWEEmK+1qbvdcRMdGxcmXCIP0jYzSNZtZB8nILwUa+EMir8mxxo8RijR1574F3uIUEDSSjRoRfAaQwCTtHuIB9UUnL4MRpNgyF5ArHpKnXYzuHpb0RXuYLpgN8QudqwCMPgqakhqllowa1v6CgQnytyF75+selrPRrrL5K7oEcD3Z4epC2LF3VN8KyXtAoUM0LOEmsFLezRaEZwRMsZ7HKk/EWWhG6xiejiMyP/bQb6hsVO/OpqBdt1+YtndkvVLnmmTxqah9xt8vav1egX6EW3yd3p35gkew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6666004)(6486002)(26005)(6862004)(4326008)(8936002)(66476007)(8676002)(66946007)(9686003)(6512007)(66556008)(5660300002)(186003)(44832011)(6506007)(316002)(54906003)(6636002)(83380400001)(2906002)(33716001)(86362001)(82960400001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3TrfS8gwQptbSsCbh3KJeJs0Ag524M8rk99arunoGAfjSamlrSYGUWzp1BR2?=
 =?us-ascii?Q?V5nxqyx/F0zInYqbTbRJ1Hbh8FC0IFcbWslm0uueM809trctkFCIQP2WjtMA?=
 =?us-ascii?Q?9gDDzHADiLPcBpw4Xq65xnd0/Elof8/KUbmNUG6Vpljq7sdatU+akQjY/teJ?=
 =?us-ascii?Q?KuD69L8X2Lwp0LGs3hVEKxuugfUl8D6un9kMXoqW6Yj52BP7ggUfVrmdHFOp?=
 =?us-ascii?Q?O63zGO1mC2yLzVjHB6sXPQOzTjWSIS224mYwg87h6ShUtobcYzUiNuTFc7pN?=
 =?us-ascii?Q?TwSgIvVsm+OziGDbr+KPg5pq/Cfcl0CZOoCzrDW8HVT4hQytNJlAHw7cKeZm?=
 =?us-ascii?Q?WbOBOF3BhddkOofl150ORGyEqWXtowTvQlfLPQQuZwFgBJngCLYXxg+dIZ0y?=
 =?us-ascii?Q?rDY8Tz3+s0/hvmN3LNS2vSTrANOOsdr43PKR4n5l+hYbwKg0MSmW0C9wScni?=
 =?us-ascii?Q?LUswV0N5ySnq2lhdMjIPi0vkvOs8BRuir1Ys2Z7KNOxsqSjaVfTiKLuJ8umo?=
 =?us-ascii?Q?D+qLdwU/8njRCvGY5awbgOVYwoh+QbrZtDk+lK1s8lR8zdCrpLOPAWLagOOG?=
 =?us-ascii?Q?ejTCv5EDWmLKI9cyj9CrFEytKEM1z/VW3qu6l/PWBCE9vOTn+G3zTmKXYfpG?=
 =?us-ascii?Q?SbBnmnTl//HHrz73V/fw+46b9U8QZmXdnolfp6giF8UJTUtBg9QllcF76/t9?=
 =?us-ascii?Q?7PFW+zfaMlrSO1k97aDghUKgNa2RuxfSrV7r76N1XcPTjia5YhMsJsU9/HCP?=
 =?us-ascii?Q?2ghNB6wNavUC0kj8LsyIMhLHku4alZJle8gN2FlP5oOa06NRPIEWVAnchIFa?=
 =?us-ascii?Q?JWmDFg+vqTQPMwwhKl4Sr+ckwxp8NreYZgoWnAHKrfJFhtOxnHFiRG6dsCji?=
 =?us-ascii?Q?lIBFiCPAFbJ9CUph2m7vgyqoCgkpIEgMdQnf8L9ExIRHIG/+stVL7ezrFw4o?=
 =?us-ascii?Q?ZPI8cTdNReWDSgYhejt7cywXNOOnqgc0Il67F6BpeZwTNv4mZphZqZKwO7pR?=
 =?us-ascii?Q?jxS9u61DQBJrQED0GHhmvOc9UuW6cW3XD6+FBdkPu7w1irfRKxEPV8xIbGgk?=
 =?us-ascii?Q?fSSvwyiMbJu05+EfYsyVlg6M1x9E3UiABjpKyHu5VtazPGT47C0zilhZSQGp?=
 =?us-ascii?Q?g4sMoPIgPbn29xxNntmVOv+37r2CTALbro4vcReMb34+fr52cjqmXxGGmL2W?=
 =?us-ascii?Q?OIQNa5FKLRBas3I1FbPmv8WUNvGUDtxu+n9v9iUu3tAtbazsBt81xL4DXaqt?=
 =?us-ascii?Q?XPHJJyGD/pki5unP3Ao7nehSikGak4UA3yac5qQj1Z//jFDZLkPOQcQFOxWb?=
 =?us-ascii?Q?/nqurLJvc1qJkzbDFFzMkoJdJikyRtW9ogN4k2v4SBTDfn/lObP/MGzRSm9Q?=
 =?us-ascii?Q?WqSqFnd58Epp3y4+q14FYSBLQ45bCwK463Osgxg5xv4jeLZ8O8FLAznJKrYk?=
 =?us-ascii?Q?kq8YjBgVz7D9vpWPInYHFbIKl1yU6a4Q6FzXfvM+JOqs8V6X20Y16h5Bgb4q?=
 =?us-ascii?Q?bOrtinapdcQK2HY2owORAgStTNI0Z7Rnw2AEzGWfPOaimwcBZtKfoe/vD7ed?=
 =?us-ascii?Q?hMmpsruLaHrQrt0UNelqBo28KgCZE8tl1jS/bYuC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c7f1a8-d4b6-45af-e4b7-08dac9ccf188
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 01:25:29.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57Z+YAhSs/6Xq4aXpV0z9wlMqaz8AqVV9DjB/QYLaaZ7kwPH/agDKW6NPoVYAqSF8spnebw01wbUW2sCUCSJuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 02:25:54PM -0800, Venkataramanan, Anirudh wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> and kunmap_local() respectively.
> 
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. Converting the former to the latter is safe only
> if there isn't an implicit dependency on preemption and page-fault handling
> being disabled, which does appear to be the case here.

Oh reading this here I see you meant that 'there is not an implicit
dependency'...  :-/  Ok read that too quick.

Still it is not an appearance it is true right?

Ok

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> Also note that the page being mapped is not allocated by the driver, and so
> the driver doesn't know if the page is in normal memory. This is the reason
> kmap_local_page() is used as opposed to page_address().
> 
> I don't have hardware, so this change has only been compile tested.
> 
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/ethernet/sfc/tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index c5f88f7..4ed4082 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -207,11 +207,11 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
>  		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
>  		u8 *vaddr;
>  
> -		vaddr = kmap_atomic(skb_frag_page(f));
> +		vaddr = kmap_local_page(skb_frag_page(f));
>  
>  		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + skb_frag_off(f),
>  					   skb_frag_size(f), copy_buf);
> -		kunmap_atomic(vaddr);
> +		kunmap_local(vaddr);
>  	}
>  
>  	EFX_WARN_ON_ONCE_PARANOID(skb_shinfo(skb)->frag_list);
> -- 
> 2.37.2
> 
