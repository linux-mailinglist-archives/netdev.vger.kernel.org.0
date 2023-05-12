Return-Path: <netdev+bounces-2220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8A0700C11
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48BB6281C8E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A85B14286;
	Fri, 12 May 2023 15:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD7524137;
	Fri, 12 May 2023 15:40:24 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E4B3AA9;
	Fri, 12 May 2023 08:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683906023; x=1715442023;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LBMdZszcipZq7GFOLi9irdzkGR8UrnxfEl+dIydJQAs=;
  b=h4uGOPKWlao+M3AjC1xmOxgodZPU1oQNImox0W8NzT3GvqFY6Md0qIOl
   +hdGvcaMyxfAHZZ6zClLNu5EowR2NYvEAR1nD6w/ehpVhKu38107QoPEq
   pDrmfPHTvt/N+yVXl9k48IIhkVjx4c0Pj/Z6HnGLjPlqv/qg2jUJDbVX/
   QSFnNCfdLrAeIIiKTyiDUJ+hGXflwZKlmzBWkfNnpEceikswSj6E0GEAd
   Z/HS4tqr57qJ61YrzEyWSmMGZdQzBfBsBgSrZNfuX30PbQAEBvmwyraP6
   ZIRR+CnS4M7/zo/MyuQL5xyUiqbPLKfnnxQLpsskpQxkj1YcnAb8OUpDX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="437153775"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437153775"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:40:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="946670233"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="946670233"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2023 08:40:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 08:40:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 08:40:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 08:40:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 08:40:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFJ2ZjArf3vH29d2CYLsuCNefFvs1e8QPNzzgdPJDIlLbvPhH5yaILwPv8zYuV9NHtLR9cr/cFRIBHShitvYt1yUo1YwX8YnazmjKYOpvQhA3WNXRjB0OmIZ9D2dK6VEzTUB8/q87eiyJg0OV1SP8C8e9IfTqNaLOR0QeHs8Qvc53QeVAmPmzSWaPA5qNpO8Q4JbL9n7yJ4H265oqPTh3TRKXMsqEoRju/wF0cTX+1Smbrx3Ao/LVgyB8wocdhOrxwIWcSoWwhY2+CDHTS0DIlY7wIiDIf1+eAUVMs7d1uctmQQj3qye5vsFNm4hkV8oTZrN1JDzpJU/WmuyiaKYrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEzYISd88yrfTDZ0iJvfyHNFdUxQ4JqsJJOYeWNz0Qs=;
 b=k8tAagQOUsGKPEmN9IRm28IZc3+ha60Ep/sldR/O4ZdG+xWRK3/YcZndxAalu7EeqdYdPE0OlwdYfjcB83YHpuCmtBgvklqnN3L8zfnIklPFSkfZxA7iHFM+iZxj6neqZb4p5c6M6iBBfDg5Tgwzx9KpcLgwYz55iIIgb7XZS8J9DV0UnpZ5sCsp+bg67yfBs1eol2ZMbytHbmHqJqYS7EgDbyBOl9A6i42crKx1WWzB+7riXLZgfgVHwemmanmjiCov//xIM/OREhRp6daJ2JiH0u9hK8b0HdLAtPqXs8m+nEKpddCz75C9PlTFkKqlizvUil6zEBPAqpaB2DxjxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Fri, 12 May
 2023 15:40:20 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:40:20 +0000
Date: Fri, 12 May 2023 17:40:11 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<bpf@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<magnus.karlsson@intel.com>
Subject: Re: [PATCH iwl-net] ice: recycle/free all of the fragments from
 multi-buffer packet
Message-ID: <ZF5d22ib3IYUMHK9@nimitz>
References: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: LO2P265CA0339.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::15) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SN7PR11MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a5d147-9cc7-47c2-1426-08db52ff3115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8TdfZeJ2oZF7lWRsQacZuDzFOugxynBEjOr3PH3pNX3xkvbLTPD3JHi0STwOuQuK3QYPxLZZj5+J1yO/kpNraVp5O6MLiC05wkPrAFC9kWghDqV4NNT+tqOhE+AKBAtpXHA/VdGjiOYosqfu0xq1bWr4lyjBd4UI+lDBJWz6AtO4d7YrkuOz+rrXq72xp/Zny0ICNmvZbir0pbMGsYQSR1pdGtdzdwhJO84xIXOWhBum8rMnCCMXGO725EMYkqayJ6W8FMiEmvVgMR1Gt6UIZNGTXEq0L5vWwGdTMYvizsMmPaT82ikUYWumUChiYr5cCQL0NADK02P18xejjLk0xMPTlgf37kHsGRa8ZLhDdtY4TP79OLd/RosZC8seJ8FrynEri4BErr8nXTcVvEXFl196OCnmCw8KfJT1konEBXbAYvYS6B4b9oqonFDsJ92ezmF1QtIaXNNJ6voYrEbldU5XigTUw0PJRFKyc9AFwAJKZoXmcuFBmXO/O2MT41IddFRgwX5SEydTgj1eCIv4lq822f+JUJN6YZfNnfrHLT0pqJy9INUBm7xjDe3Fz6T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199021)(86362001)(66556008)(66946007)(66476007)(2906002)(107886003)(83380400001)(9686003)(6506007)(6512007)(38100700002)(82960400001)(6666004)(478600001)(6486002)(186003)(26005)(6862004)(33716001)(316002)(44832011)(8936002)(8676002)(4744005)(4326008)(6636002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z912/9ItMzDfKdIqPSTiEXpW4AAz6ieIpRZ5H2FE+XqllLqmWzXjbRHtAMKe?=
 =?us-ascii?Q?BZ33fk1AsX1eNEmcJUnFuuWQ1khb4AvAC+ci3ZEDLDy8VBB6CngBqfqYRDqS?=
 =?us-ascii?Q?45cBHj4STx5L6md2QkPiWNicVFHLB6Pv6jBj9nsY1oZc2cLct/Dn8Wrb6It9?=
 =?us-ascii?Q?y8s9ZrKZS1lRTKyU0NT1ytCdKFQGUBJYx6yVHP5eVj5MHPJGKywLWrcpjzxf?=
 =?us-ascii?Q?a3pwe5FS5M5Vy41nDbeTiSr+v4a8o5iaFvy19c1yrUgZIbIdS3txqo63udvX?=
 =?us-ascii?Q?y4hvjum5+9FgVmI2v7zZyUAxox9FfOBIKMp937JTRcqPk1DpgXeDhFCdHqfb?=
 =?us-ascii?Q?X3Lq5vzG2olytXVWlLcRJAX2m38f0LrZM8N3D+NApOOMtHw4ZSrmCziYMw/b?=
 =?us-ascii?Q?tSCOI4h9h5C1CApPEMbWa4qaiOp9NDxr/zuICKRUpPEnE7i0t0tSWAA91cRo?=
 =?us-ascii?Q?hpKN/hqyRTKxnSFlwPPscUo9Mb9Nilo+wOVxybqWCAXRaPyOKEVb+tSpCzS5?=
 =?us-ascii?Q?fI/iwDpJXq2bwNJXmXo4MhfxabZdMikL67c9/58G42GsyW90RskyLGobhOhW?=
 =?us-ascii?Q?JFljTaNFTt7+m+xECJi/mceio3Jpwgki/CbUnxAlzLwsHpANTmpzeG9/h9DY?=
 =?us-ascii?Q?CXebnMzrhlS7rG0GLqtanp3ecvbSEWiOyrxIhUI7ALCIc+EMx8LWvR0hBtOj?=
 =?us-ascii?Q?bqK5ic5ZbcJkdyp8UH9VtiQ6nCIHp6/q8j8Vuqvxteg2t+15/LnqjSpvVNEd?=
 =?us-ascii?Q?x9/J29TuwifKZ6XIWcmq7JgxIOOU1StMRzdtb0ZUcBK9RuOTfLN9Two/4mMt?=
 =?us-ascii?Q?hwZKZJeBWfpz0nik8WrsKP/3fklCor1De/6U5SiiqQlgqXdDBVOlRqa6UXrG?=
 =?us-ascii?Q?NmAngfh+w9p22I138uvauR0+Fisu0GewITh73P10twZekt54gwJW/U7Musaq?=
 =?us-ascii?Q?0aIyHKWL2EK4eZXw8gIa51x4HSUnXjdRmyNjtaAJR21I2H15eyZwBklMDXhU?=
 =?us-ascii?Q?jU8Vzxbm1+0p1RpvkXRwoApM1o85yLzGtbLFWv/PIc3YcoA/ImqCBxdBgiAp?=
 =?us-ascii?Q?jWQ7iVpe+U750B+nFdiCPXhQlTK7nh9omJXNwXy0cXNW+pSD/3O9kv67EB2T?=
 =?us-ascii?Q?rGTqZeu+KG7iUbbVM2yKJhlCUNvSEfINol04vGbunZJp3OFrkFRlm12aQQ7S?=
 =?us-ascii?Q?REjf1MCcCziULPQjjPrDZyVLBI4iNY5FGnknkhMu8roJKA5rCviawrCl7b0v?=
 =?us-ascii?Q?bvDllcqRVLftWmwsQCjEvn3ORVKyIGEgmgFxGYYByPdStQywBlbhOEKunQEK?=
 =?us-ascii?Q?r9I8KKHZdUl0ykFwjo1fK6766+8nW9XDA0sx8BM84p3ZXyKQCMWl24IR9YTJ?=
 =?us-ascii?Q?Ir1PZ9KZ1fF+ewS5CxvoT3Ssz0o/HMH2+qeDuwNMD8xQIJtRqelWwuDijH/P?=
 =?us-ascii?Q?72eqWmhDsAXDGqR+yal2GHwxFoLP7yxc4ImHnVPjyrpRDRvimK+NUQsYaEHy?=
 =?us-ascii?Q?cg+6RU8Ok86d3fWg4Acq2rSznfP0Iu/YNevAoWnxD2Lz6DKldnuEtcXwkaxq?=
 =?us-ascii?Q?WshaOi8j9mgBM8DWOqA1oyNO7SXjrcnqMaCu++U0RC0IBmcuYMVkn+/9kyAn?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a5d147-9cc7-47c2-1426-08db52ff3115
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:40:19.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWZiR7lIK9qPqTxm5LSDBh8tvD4cHIyzwnXNA1HtH4CuO7Dx540X1lKNV6Fe4lFpK6fsmNgFLplnDHb3K8jT6huG7cyzyooZwxe4NA+byLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> @@ -1162,6 +1162,9 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
>  	bool failure;
>  	u32 first;
>  
> +	if (ntc != rx_ring->first_desc)
> +		cached_ntc = rx_ring->first_desc;
> +
Would it make sense to apply likely/unlikely here since  we check it per
packet?

Piotr
>  	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
>  #if (PAGE_SIZE < 8192)

> 

