Return-Path: <netdev+bounces-8183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD8F722FC6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3517228106A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448332415B;
	Mon,  5 Jun 2023 19:25:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2B0DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:25:50 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BD3FD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685993146; x=1717529146;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5XsKNU7eOCH04ZEQ507gCUC0PjJAg8SYKk/pTh1qVMw=;
  b=eIGGudsuRuMbXDryKVUywDgArEbH1PDpxLjezP+2Yz7VNUpuPsVJllYh
   p1b8A7I3KqSY0J+oj/4jWJbOuqVpndqxsLQZFwoGCTpmNj6BsygY70I50
   1DVyKfw2soJKIvM/j7G7UhyKjRZ3gIO5ukOt7WVk+YgJ93WBqlH6Q1KBn
   2UQJtehEo+MLeKsUEPowdGTDOugR1rbR0JQ3rSHYgELe4fYBZiJxQ5joK
   rD6pgwRYNxEdUgii1S1Ivd4tK2jNZYl8ni6fFQyIVdonIlzWgyqVcpo4l
   WGb2J7PR17Zq2LsJhr1SMjo57OwppOLfz87Z3AtSKPbLRincn6ueImdgD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355314856"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="355314856"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659224093"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="659224093"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2023 12:25:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:25:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:25:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 12:25:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 12:25:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw2btgU+mRra2UhB5bWWiQyaaxBhUI+epd5AWV5l+Q/nlQQmDuvpU6kCGGkeEFb0OmGb9uMddxXUJT5D//7M+1bt30h6VZGFKTmGtnu5xeUrEiLyrG3Po1kQ5URu/I/m8yn+g9ZZAFP3yKrBgx8FJDO91gGLxowdd9Pqyh9fpP3PGRoI3c07HYUJjGzre8G6FjWhXdrwLqBx2ZqiTIXXIJaYYixf0hl5pnWptyeZQZ4hxLOIf9Y2lzBBkCdEeFYrwdDkxUM133L72rmsfkGBDx78wlAcHwfEPy0oNncHw7v7YBCbWsy/ortOBeb9HssOwfnYcv4ljR/azOeltqyAGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wB6TQdycSzjtbuMhPH3+WL77p6jZxmxIx+tL8eb8SEo=;
 b=CwCBugQA6GUwGoLEn1m4mENcohRlZqVBwm14XHZ3BfytkDtLrtrjNCtibIJeWRo2n5VpJK3nd40WUwiC7YxHmpfOJ95xFWmeu6VFYCkswZ0N0NLXXMyt5R1vEvUXmolRvhp/1w4Ov9FIW8LiD85U6oRWPR238daQN44JGnshrTNEnfvx4gQ307x4WCKwDOTzCVGgOYFRBPzyVFejKlSgI5qLU3mO50jBEKMLUD2jzphZvCvzSOoor1KHrZO7zZxrleyjJ4a00Hjis078QmcmgglZ4zxnh34IoF/Atxkh3E+qPC/uMdqm9fPY596fYLuvacANRIQ/fAsW62ynjznSlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW4PR11MB6911.namprd11.prod.outlook.com (2603:10b6:303:22d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 19:25:34 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 19:25:34 +0000
Date: Mon, 5 Jun 2023 21:25:26 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Ahmed Zaki
	<ahmed.zaki@intel.com>, Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
Message-ID: <ZH42phazuTdyiNTm@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-4-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: DB8PR06CA0006.eurprd06.prod.outlook.com
 (2603:10a6:10:100::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW4PR11MB6911:EE_
X-MS-Office365-Filtering-Correlation-Id: b87544f5-0514-4075-8d2e-08db65faa266
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6KuSeZT0jQx2cT6p6JPnqcZ+rXgpWcc7fFTtV0dX7/amLZ55XLpxatZPlRwKrXwGvEKa4RE0Eq5riB55lVahVDlVmRL5PULs6WWz8YMMjMdnY1vcaEa+4Gt/o5J9wmWm6mbUTCXaA2XfZ7SK+QmIcdNqD94QSoAT5CiLGw5k0ts+cBBZDCG347hMo+IQtiNsxDyLFghy0uSjqmhuvfvSmwKILzfn6IZydb+O/OUUPSkMuHXpx+E9MRoN/9AbHTyX3fmB7bEJjNIR4NY3BHQNn1nTtcA5k7cpra0SOJxAXt8P3xLDnLE7GxzC4jWbnjQR1QEuvoE+RrN0ULvD+0C/7NbXO++SoeuLLjbpqxEN01iSDujmqwop+kQjE+itRGgTFvhAllhg9pJr0SuPqXFpiAVmAu5BsFtw6Ly0por8tLKKuHOr9ktjChzELSHVh43C92tbKbBPGHT/q02BdzBskuWz+uShJbqQzeBuWkrHsOhJw7vIBunXMq0pO7gVLBTLL+RIyfDXlcMUSYn0VslrXRBIFbEKtQTIzB92rIOPtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199021)(54906003)(478600001)(6862004)(8936002)(5660300002)(8676002)(44832011)(2906002)(86362001)(33716001)(4326008)(6636002)(66476007)(66556008)(316002)(66946007)(82960400001)(6506007)(38100700002)(41300700001)(107886003)(9686003)(6512007)(26005)(186003)(966005)(83380400001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8QXnABVsDiXr+8gxvs8UsVXGVddJnyZuXRyuRxH3TCBrFbmdzIUD4x8ktO4p?=
 =?us-ascii?Q?WwNmGPfznKraQH5OCTuUjUX7F9rcd60UKkSViVt0yE3s2e9HUvmWpRIz3NSW?=
 =?us-ascii?Q?GGL1eBSkd6jTJoaQUD3NL02JsjzVYB6z91Rbvya4MTp/ou/ArqQLCfSBQnkA?=
 =?us-ascii?Q?wSw5wBwez+yPXIBA3jFU/aQRb0yivTJq+sAcD4xRteueTeOsUDgCpU5ymPOm?=
 =?us-ascii?Q?xhu77vSO/8bWmO/n3NibXFzs/HmPoFDwTN1Uz2PYHoozwi8y77qu5SdvSVbX?=
 =?us-ascii?Q?Luxfpt9OOV4M2SFVMc6SUqfgrQm2AOIujiml0FFarEZqL/5afiBKf+hVwlg4?=
 =?us-ascii?Q?GhrBJfgsl5vpGX+pLJN30++gqJmUsUiojNjbFH89eYql95Dw7joMNO0Kj58S?=
 =?us-ascii?Q?70v/EOhew1mdsUua8b2Nz1kAm+eIH0Qt+DJN99SmKuRgZawsFhNlRgdd9Jpu?=
 =?us-ascii?Q?oUvZbuG60d3J5rB/rY/072dhuHSRFBfYSEI+SbA5a7wSPoO42fsOcVdDcUrP?=
 =?us-ascii?Q?Jok3lsprGLaOmyYNooj24A1VYA6w6kUuYFj8qAH7IH9u2EqIZ3FylbKNOW+5?=
 =?us-ascii?Q?EeABTCCwWwR2y/lnZcwkrloHg+WzO1Mme0F5CRD7gmQjbRK351JQTBj+liSD?=
 =?us-ascii?Q?+iB0kPELVzsRh9YqlyCrGBZGzxWICG69CnqY+DyADNsQxJXFwQMYRWrXQgMX?=
 =?us-ascii?Q?szGb3TItVQdRVsb4nhMncHxClTnMZK+02VufQbUatYpSVn/GffFCqGwg9hQ0?=
 =?us-ascii?Q?CWPb0JvmiaNB8KPi3ASeUzG0dpcQ8mKVzC/kMmItrqE1av2S7aTSIy1GYEjK?=
 =?us-ascii?Q?6RM/XWkpGJFvfUhHbB3PTN7L8LDyoOMYi8VbvKl+VX+oGtqZQqBSYDwrZ5BF?=
 =?us-ascii?Q?LzW6Vlp4mtwKxnVKZ9omXnNJU32o4DqWPftymUWK2EmrW6XF4arZe98u8xMy?=
 =?us-ascii?Q?+Sjvoj4N/NO0AChIdP1YkzgAi5Y6fiFMVhoJpHFSvdSHkVvgfgrSaednbxD6?=
 =?us-ascii?Q?X2uEptYupyseMbtKCTvGROb/G8qfyWfT0m+44W8YYdfndx8faAqJ+3h1lkrI?=
 =?us-ascii?Q?mhEp/Rd5j+6LPMjpWs1y8r5rnOB16Im9LhAthyhzvivBBt9Fcce8Sls/GXNL?=
 =?us-ascii?Q?oVvNgUO3VbkJGT1w0tbIwiWQFf7ZN3ycifVy4shB45MSyklD2WMRamSPhgyB?=
 =?us-ascii?Q?UfrfPD9aV+Bz9QXkvKeX9oWaUZvFEz4m4q8OGHL2gU2e64tceIFp49ZfQHZg?=
 =?us-ascii?Q?USaLsLHbQuJmX1VazNwDh5S497xSEEzg9ea0nahcY4DAafm30p8+ZTulLG/j?=
 =?us-ascii?Q?rlx5B+3Lt8VWi64w6nPQIEWY3zhJwJG5UcB1TNmBGUvjZY8Wqjyukph+Pj60?=
 =?us-ascii?Q?iQ5VQdhZ2P01kzt1ljreN/yb/V0UoAfjvgJ6jEj76morDqOOGWiD7EJiFMCR?=
 =?us-ascii?Q?86YXREI5t6ExB8hx/LhlzSuIt2QD8/Dl2DIxb1StNMNDS3brSJgpa8e38MX3?=
 =?us-ascii?Q?IwPkTvP0J0C2aqKMb2jnc+lU9yv85b6qKiqYTa7I0plbRjCciHKqLP/e3tsW?=
 =?us-ascii?Q?xbR5JTs4OmugGmau9tRfcurbEauBpc+nlpcZuLocGbyOKRQrz1eoVL4TxnBk?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b87544f5-0514-4075-8d2e-08db65faa266
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:25:34.5824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKXNPP+9Z6Qqq47AeMnfmcLUptwZ9aenbOsx5G+D04i/+nX2ay+3Gs5T4yGOH6JbmIO14FxBfmugR8KBFWna2fQQegaLNSTf8LSFKVqDNyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:02AM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> Enable more than 32 IRQs by removing the u32 bit mask in
> iavf_irq_enable_queues(). There is no need for the mask as there are no
> callers that select individual IRQs through the bitmask. Also, if the PF
> allocates more than 32 IRQs, this mask will prevent us from using all of
> them.
> 
> The comment in iavf_register.h is modified to show that the maximum
> number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].

please use imperative mood:
"modify the comment in..."

besides, it sounds to me like a bug, we were not following the spec, no?

> 
> link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/iavf/iavf.h          |  2 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c     | 15 ++++++---------
>  drivers/net/ethernet/intel/iavf/iavf_register.h |  2 +-
>  3 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
> index 9abaff1f2aff..39d0fe76a38f 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> @@ -525,7 +525,7 @@ void iavf_set_ethtool_ops(struct net_device *netdev);
>  void iavf_update_stats(struct iavf_adapter *adapter);
>  void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
>  int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask);
> +void iavf_irq_enable_queues(struct iavf_adapter *adapter);
>  void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
>  void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
>  
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3a78f86ba4f9..1332633f0ca5 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -359,21 +359,18 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
>  }
>  
>  /**
> - * iavf_irq_enable_queues - Enable interrupt for specified queues
> + * iavf_irq_enable_queues - Enable interrupt for all queues
>   * @adapter: board private structure
> - * @mask: bitmap of queues to enable
>   **/
> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask)
> +void iavf_irq_enable_queues(struct iavf_adapter *adapter)
>  {
>  	struct iavf_hw *hw = &adapter->hw;
>  	int i;
>  
>  	for (i = 1; i < adapter->num_msix_vectors; i++) {
> -		if (mask & BIT(i - 1)) {
> -			wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
> -			     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> -			     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
> -		}
> +		wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
> +		     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> +		     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
>  	}
>  }
>  
> @@ -387,7 +384,7 @@ void iavf_irq_enable(struct iavf_adapter *adapter, bool flush)
>  	struct iavf_hw *hw = &adapter->hw;
>  
>  	iavf_misc_irq_enable(adapter);
> -	iavf_irq_enable_queues(adapter, ~0);
> +	iavf_irq_enable_queues(adapter);
>  
>  	if (flush)
>  		iavf_flush(hw);
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_register.h b/drivers/net/ethernet/intel/iavf/iavf_register.h
> index bf793332fc9d..a19e88898a0b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_register.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_register.h
> @@ -40,7 +40,7 @@
>  #define IAVF_VFINT_DYN_CTL01_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTL01_INTENA_SHIFT)
>  #define IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT 3
>  #define IAVF_VFINT_DYN_CTL01_ITR_INDX_MASK IAVF_MASK(0x3, IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT)
> -#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...15 */ /* Reset: VFR */

so this was wrong even before as not indicating 31 as max?

> +#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...63 */ /* Reset: VFR */
>  #define IAVF_VFINT_DYN_CTLN1_INTENA_SHIFT 0
>  #define IAVF_VFINT_DYN_CTLN1_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTLN1_INTENA_SHIFT)
>  #define IAVF_VFINT_DYN_CTLN1_SWINT_TRIG_SHIFT 2
> -- 
> 2.38.1
> 
> 

