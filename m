Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20235629848
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKOMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiKOMN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:13:58 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEC213E0C;
        Tue, 15 Nov 2022 04:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668514437; x=1700050437;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uSD3uOok+SUNufrX5f4zbVrajwNlZ/TfUcJH+S4xIMk=;
  b=JqYtoP/O+y2jDdVsGZqKXqZ8Fycq0qdFPqPDbH4xYlBjffgR5fQckM0h
   IdyYq52rSzBtfpauDoyAFr7+QxCX99gDfabRsEfbQUnGsCi8I0/kHoo10
   CuCTqsFMODByQt/5ZInHpoltjuYeblto/aNBm6MPm+rSYxG92cWWYLBqM
   flOofqik2d80N4c+7D7+o0n71zGx0FEAvMazXP3iNrO3m5uuYZWjdy8RN
   XX5Q/iMbodtbAukFRipfN1R3Y5CVhUhgQyAvv+YrtFEWb30w1NydXEnqi
   XTzld8gsE7afIRCu2sTG4gUqow/838heQfRO1WRcLv+cLcZyc4E7H91q8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="374370902"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="374370902"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 04:13:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633214258"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633214258"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 15 Nov 2022 04:13:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:13:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:13:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 04:13:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 04:13:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3waNNrJqseR5EfRXgyrQ65HaN4lacgL8Qb7NbsIIMY6j9gK/zcg9fpE/puMK/1yXSz0STn9ljgyidFIyNn8zl1nIctH18ZKZkTq3cDZT7HShPaTlIc4OqPMYF3ee6wBKDoSpV1UvRivL2f2Z5QT1GRQx839a3b8a6z+J68WTkCHMY9EBFkkTkWm0UJkZQXXd+WtESWSXGwwC/kAwuXj2ZAZ6b+JLvMrs7+XdoiNlVdjj5WZCO3itOuhyp3lhgjl896/8+cIyP4m8xqeCAzZXrWykIQkDMYMZ23SQXVRnvIUCj2KNmvtbdoom7Se2JAQvaUzx1LLAmo5BAmphO6JUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BT6H8zdd+UasN635F49QwaAp1xaJZIBzXQZJ/G9cDBk=;
 b=FN1jfuqOMrHXG7aBX+2gc5NWIi85mGtJywcMYxOHES4zzZ1Kop40y479lgkqwndYnQsoIu0H6GlzM5jifja/t8aGEBOUXyd4nosDPMSuap/MsrGoqmXbjOCIBHHc1OTQ/Mlj3NZOtf038Zjs/PCmXh9XFWRrGw0X7Hvm0b6AWtWx3IUkjmhKNEJApUxk7yX95BDwZEwqcLUVTvzejd518vbttq3mpXjEoXVmCFHFpVgVOYlF5jBEMZW4YHOVoG+W9st3xh2WQcHMPGqF2xcgvwCArlI1R+I3JCogmo9brHQsbQ3QZfJYeg6RBVtmtujZhdxwcMvxbQkBO3y5rqZNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 12:13:52 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Tue, 15 Nov 2022
 12:13:52 +0000
Date:   Tue, 15 Nov 2022 13:13:45 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <bjorn@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: Re: [PATCH net 1/2] i40e: Fix failure message when XDP is configured
 in TX only mode
Message-ID: <Y3OCeXZUWpJTDIQF@boxer>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221115000324.3040207-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221115000324.3040207-2-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM6P194CA0065.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::42) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d9d2532-5cca-4e70-0abb-08dac702dc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CsVZPFLD2vTa6CHNzhXkPAxEVExAzL3b1LJS/liR06dm7VMzPKR5pa7A6IXBkxxjYHCqivw2tMP0Xhb0UTN38uxkHlLby0Zgddq9dji4ew8daHSZUnPW5wBbxuKW+iSzudECp/QldW5+ZxU277kjg68/2LwJVjiIkcO3M774TV2DvxgfOVVCH7toEx+yNyKPraJEqJNVINlT6mXBVepIb4aQSj9WdE1rYNzBFkWbAavdSptqbq8bD0j472XlTRaVJ/NAAoZ9YktfcJ9TTb59lq/0Qb0E5mXHjVzesNxU+hRR/VtTsW62jDmaPSH4+M+JVLpV4XBCy5NfXvUnUJIHMfYblo2buQ6GgKVJdcK5G2NJDidB4Z8rSbnmMdxi/phHajK62q4lP2OBW+jNv1OPcMF4H11OhhpJ5L5l5iB9Zk1ZtJ2jqYP/vB32V3C3iHEHBqxyj8k1lt6O/OCYSwPgYo55CboMoKzhqccHTu9+8cNWB+v+oFJ2vOX2sz2UB/RPMGRqlp1XGje8R97oP+KLqNNJuhTztmnv9qaW411GsXZows5UIk6i2FEG0P4QXmUwUs6Y0tjxFhNHS4aBHco9UGKnw2C8DYwlnbAzoRx5PWlNLL6sVUByqtYYxNL5/iO5u6E6Q8GpdSvCr4nFBPKujWMdio7MNViVqBiaJI6ZhOiCKe5RLexUwDNmgbUPLIEc7Y17jDo+kcTaksd7ylP9Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(4326008)(86362001)(66946007)(66476007)(8676002)(66556008)(5660300002)(82960400001)(6666004)(41300700001)(83380400001)(38100700002)(33716001)(2906002)(186003)(107886003)(6506007)(26005)(6486002)(6512007)(478600001)(15650500001)(6636002)(316002)(54906003)(9686003)(7416002)(6862004)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?03VG/UKvU8mnDClOuRpMXO/KLIeeSc247/OEAxScmGPXTvu9hem3A/WTS6WQ?=
 =?us-ascii?Q?f/k2BAwKV3sxxw0/oSxCY9uyiFGoHboNHm+X0ykpPudm/7RUdebwJuYGCymt?=
 =?us-ascii?Q?/4MjpSQfcvmISA6ce1xKWrpIEdtPcVJeYmURENA0xMdtjUdfYx3YHB2dUsWf?=
 =?us-ascii?Q?l9osO8H6RvFW3QZ5ec1KHf1WpP7MiiEIzvnomBwp58YvemxueTD9GPvirgYi?=
 =?us-ascii?Q?8TE9y7QLOnTj6apnu40BG+rhXbHlGuKDzpDbq1GxR/F/vA9rKzwIRD2N8Miq?=
 =?us-ascii?Q?7AQU7MzszQWxHA6dnEoqnF8Ews0W4YnPzbROIjBHc58S5vMvCrhPgV3cvMH2?=
 =?us-ascii?Q?952fJhsTmD/kO8HmO0gG1KC+JwwzQXJaIHDtxgnvuBecQ/B7LkVSDTe9s7pZ?=
 =?us-ascii?Q?paY4YobliH4vwk1Wb5+YbMXPKnjDwX5LXP+VcnAYBGX7x3uhvelUZoK39GyB?=
 =?us-ascii?Q?QOuLYtnAr6DowE2K5f4MZKMC8iG67nBaZ7kzXKmLbaYcGQCP+bKGHCCVp9ha?=
 =?us-ascii?Q?Gr5FZm5iawWbDsxABaUtKLU2IlMedKAkFEbUGRLhyn7q6LPxT/HIXCH0MS5m?=
 =?us-ascii?Q?snfJqLXPdkfvk+MAAuk+aXFe3eX5y+9ROc1PnOsE5HqXsxxegmLg5+uz/xfZ?=
 =?us-ascii?Q?HTrLITUi89tAoe93WP2ZFmuxrnATIfQNcpcxBBhDMP0FKIVQLd59pRwZMX05?=
 =?us-ascii?Q?fmIJVPhy6PpS6hCq/X1/Ry+NcwJDajrmyyCSJ/Ick/HJeZrw5eImvTIQKrWg?=
 =?us-ascii?Q?5JPRJMQ6Xe/BjyKPBz5e2b2mA8NIM2BK52MCWpPWXVtKtz0f/Q+yzUx5ZFk6?=
 =?us-ascii?Q?DO5UEHEwWfRcuW8jtwVL90d2T9R/6F1s9fY0mX7BF2PkO8rJrmc68V56JyRy?=
 =?us-ascii?Q?7tDgCCRKF+zSaB7cn2qeULDQtSb7lBB3FUXrdOIlTZEJGnVsRwOnsxXKzSy/?=
 =?us-ascii?Q?dssHhDaZ48qQzNBMHPQ2RTg/iUXinYLwJY+q5AKr6utUgTAKNwWg7q72XFh8?=
 =?us-ascii?Q?baY1grL05H4W+e1lPE9uo6PiuQe+i1Q6xZXqNqCZJFbL9S/e9kTANnxelVII?=
 =?us-ascii?Q?uavX11nutzTeuFgD9C3agEFE7DbHljjiyzsUAUwPLp98NUD70WmIvj3bqscD?=
 =?us-ascii?Q?gRi/s6gklDDHnYpBvDPzSFTTS+BpJa2RZbJatA/PDYowX44Q8S0dvIsaqKrS?=
 =?us-ascii?Q?ZEalFvtkUibtEAXkY7Htx8EAgZWkACGE+G/fSjfgQuV5mJzZFSOqgDpaVQMg?=
 =?us-ascii?Q?aVwX1ryfb6qtgVl8ym+X9IXXyZmGKcJ4cTNzDDQ9hdMEEMDazBXHa+MIz4sX?=
 =?us-ascii?Q?/N5xf8fkMTnB+X8MOHs5xf0DLu4AW5pvl9b2xYKds9srFfYnaPF/Gu3TQIPE?=
 =?us-ascii?Q?2W5m7ZrSrHlc1WgULH6vtrhGzRSvSTvjZMOrtYCsmAI3IB9vCJabr70B8Ae1?=
 =?us-ascii?Q?03u78Eircl9kfuFD+ZtlfLOGzd3tVngJ3QKYKNzPfEgaFHm5oQ5CJt4HAWqX?=
 =?us-ascii?Q?NoDWFXGKnTFWjevklIgpWbB32FNwVnMNmt9dvBO0QFdfsUG/aQlaY+PlFQbE?=
 =?us-ascii?Q?s+tTmWYHsuLlsz0pO46z4wCy4PrZJGSKJ9zWOI0tOpag+b3+GmVEuX7lh9sy?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9d2532-5cca-4e70-0abb-08dac702dc09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 12:13:52.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pAnACd9i6LZ65OihCsTsTE0pXREbaGCbUeIVwA+hU9mKIqdXLeLvXaF73tzqdMSnqnROByzcgtS6jMr5GmCqoYZ6uPP5yglsDNjm3UpJgyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:03:23PM -0800, Tony Nguyen wrote:
> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> 
> When starting xdpsock program in TX only mode:
> 
> samples/bpf/xdpsock -i <interface> -t
> 
> there was an error on i40e driver:
> 
> Failed to allocate some buffers on AF_XDP ZC enabled Rx ring 0 (pf_q 81)
> 
> It was caused by trying to allocate RX buffers even though
> no RX buffers are available because we run in TX only mode.
> 
> Fix this by checking for number of available buffers
> for RX queue when allocating buffers during XDP setup.

I was not sure if we want to proceed with this or not. For sure it's not a
fix to me, behavior was not broken, txonly mode was working correctly.
We're only getting rid of the bogus message that caused confusion within
people.

I feel that if we want that in then we should route this via -next and
address other drivers as well. Not sure what are Magnus' thoughts on this.

> 
> Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
> Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index b5dcd15ced36..41112f92f9ef 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -3555,7 +3555,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
>  	struct i40e_hw *hw = &vsi->back->hw;
>  	struct i40e_hmc_obj_rxq rx_ctx;
>  	i40e_status err = 0;
> -	bool ok;
> +	bool ok = true;
>  	int ret;
>  
>  	bitmap_zero(ring->state, __I40E_RING_STATE_NBITS);
> @@ -3653,7 +3653,9 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
>  
>  	if (ring->xsk_pool) {
>  		xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
> -		ok = i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring));
> +		if (ring->xsk_pool->free_list_cnt)
> +			ok = i40e_alloc_rx_buffers_zc(ring,
> +						      I40E_DESC_UNUSED(ring));
>  	} else {
>  		ok = !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
>  	}
> -- 
> 2.35.1
> 
