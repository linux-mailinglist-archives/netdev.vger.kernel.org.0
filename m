Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6205EF40B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiI2LMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiI2LMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:12:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413972A264;
        Thu, 29 Sep 2022 04:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664449939; x=1695985939;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aoqUOZ/f/a+6kueBdC7li6JRGjuCeYa/DISv/MEkVjA=;
  b=MckqHcEidNAy6YX+RmbYPtXhJCwRh9yWXfmxyVB5Hf9fNc3atypmYmaQ
   c/fdmJXRxyqp9b22WdVpbmN8MJl85ezOaNTmRunolyyIhphMERNo6YK9g
   tnZYDgPJu2JlV/nK0v+C/OsRIUo4uf+rLRWuyLrY2D/Ucirh8Wgs97LWu
   pWHepGHVlhpA2ZO/x2aBkD9ZLNUzGvPnECPaCjz6z0JCj3Cs/gvCYyTmr
   7AkQddZlxINOAokEi05cYxJQ10idc28mxd1OOPaT6FtWFEEMhKLPcAjTb
   5PH36hfg9MGsJFEdzIJn26KgUaf1qL6/UB5tPTlZvv+HyyuLAZH75yuq7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="282229677"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="282229677"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 04:12:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="711342950"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="711342950"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Sep 2022 04:12:18 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 04:12:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 04:12:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 04:12:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 04:12:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ8WDWW9v4Kccz62KIP2heX20b2G6yNEVd0LX+NawtkrQA4IG6bpRS2Pqpl3kVisFWVhO9QrXwdN+Uf93gj0N4IYC6HaTS1f/qESIqK42lxk+dZIDNKglifpCNH1FmdO8x19rgl7zGJCUPtmltVJGRDluHeYTNG55jdtv1Sa7OrXhYGScwrHRr5ijjdsoizm5B3mwKHkIDsXsvYet9ksnHsEEDlRIp6DfknAk5C4jDm681udm88eTd1G1PZNsRwZv0vJpr0XWDKvfnJAzpYWuqpsZAdH5OBQ/VqtxYXuH98+UcqnhVHzgYH4ZxMBe1qmXNMR3xIQlnNyDKKFjc/FCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uQ+AKrrZNf6A0FMLrMANs1ygMZi2v3LVT07Pay1OME=;
 b=YK2L4q0KOyBbwf2RKQyc7AtYTR3TE2l+BWOpo+/RgFTB874Z+AsvCWSwgW5t2CYNnsckxRSRMJMrbjPrAbaxc3RnmRM9+KWEpta4eqFIF4WVxupqKPI6qVIYvKnvt8sChNfeqATw9M8a5j44ZsBaSPqw+y7qJnHXwCxYU/0rT70VchCm9F2jt7RKfQEKhh3EDMGNzbA4A8Z4OO9s6hRmUm8YoGtzWsLfiIBeRjd4rvIwZIsvBPuj3qOCywMvMwjUsHvLwpfr7Wh/unFDoWZSdexC/ON40Ykqf9y91rMassX5Ogkc6jxXc329Vjh7Y/KhpFAcMHdb4cwiEp6JXX/1Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Thu, 29 Sep 2022 11:12:15 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::60e2:11d4:5b77:2e67]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::60e2:11d4:5b77:2e67%7]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 11:12:15 +0000
Date:   Thu, 29 Sep 2022 13:12:01 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, Jan Sokolowski <jan.sokolowski@intel.com>,
        <netdev@vger.kernel.org>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        Chandan <chandanx.rout@intel.com>
Subject: Re: [PATCH net v2 2/2] i40e: Fix DMA mappings leak
Message-ID: <YzV9gXMMPMjmQWDE@boxer>
References: <20220928202138.409759-1-anthony.l.nguyen@intel.com>
 <20220928202138.409759-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220928202138.409759-3-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR0P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW3PR11MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f449fb1-dd0f-4463-c9af-08daa20b7743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fb5vPmsxeQzcA6DvOKbYcmYMyUJ/QuA/q8lVWLnfnijOsVH8OQS65+355p+zcgAD0trSk/CNyBB2jIA8I1/ITmv2X8CoI4dh+XTdMMeAiw8ubYSHqvXlwLA3XCeHT2Phy4iBn/BPoosmWEBgAleX4fbWb4vqQ6YgmFv61VNLzr5Aim0T+LOW7nhfHaLixkGgZMd6jA1GEpjFW5+96+hk69wtGPqB+TBt6SKFuFeXiRvChaUpn3ghbdXSCbeZ1i95AVzhgZ0MvGgMuQCrSfJg/a2K7HNk+H2WEybv9PybFwbK83EbocgcXt/LSVm1qKR+2AyIiBDUrT/1smokrE1g+A+quInsfaeMWYdeYgTQ7TRqQS3Ip6vekG9iVRMlYhSqbhiJhi5nEwtxUHHV7wy/5tZUdURMGar6C6ITMUcewKsQ+mwBl5Hj7PdchkH8xZz+vDJ9cf8JYtr2q6g75SWyJ7EAVmvkV4yUq6SbMx9WwfwMWLwmBDHV8LMYt82zqsvC3jCqUV5QVwvupMLpHq0c340OhubwVK60xw7sHZC0lidSTsfTarybxwwYI7qdnyTylRpiJErZtzXMjrGhJ4kSeisP47MoEQI3OjadGXkIu1+cnyxDBaMr8dZZZkUpaX3+Ofq+XaM5kQZrDbx8CJmr8kEhX+ih3h08f5AXPLIABbziNhND22I1i810Vr08SENqjQZs5mKJm2LJ6cdDDb3Keg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(186003)(8676002)(83380400001)(7416002)(86362001)(8936002)(6506007)(6862004)(38100700002)(26005)(9686003)(2906002)(6512007)(5660300002)(6636002)(6666004)(107886003)(82960400001)(478600001)(66556008)(66476007)(54906003)(66946007)(316002)(44832011)(41300700001)(33716001)(4326008)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6EKmnxHoVaa2YM5v+uESXG+lEox9q8XAF26vlRYZSM9BlcXkRCE2R9AWu/z?=
 =?us-ascii?Q?9b6DgQpdOLoIQ9mFaApuLrNDmHtOS+xFyUnazpA/8YqWde2A/mdw7pQwep4S?=
 =?us-ascii?Q?6L8fe9biLqqHsL4qZWsyp3etHhdDjyTNpkQXgB1VlilZ8xi3vOwGJtZ8QBEe?=
 =?us-ascii?Q?nluXDU+PSNN7rMmlTzNJcVxMLFDojp7cHVBzXAaxhgYE3nddggCXOPPIWnPB?=
 =?us-ascii?Q?wHW3+xPMqNCY4I61UvP+SghvJGU6HNajxMIbldrGFVBBzfRXFmSXFJcSFmLn?=
 =?us-ascii?Q?fO6lwM8ExJX9ym6ZhPfC2sw6SzmvVBPI9xJsIlLotf0WvRUGAmzNRrsvMHGQ?=
 =?us-ascii?Q?Ess3uEt6QhkEXt8AFvV6HNsUQkVbXNuf2TTnaBAh1xE84i8bRaz+XsniHQUb?=
 =?us-ascii?Q?rPWH0hXc/R7eIMMvN+5d1lhu7OHFwoKQ9o/B+ycCZ9nVocmHFdgEejIbRSGa?=
 =?us-ascii?Q?LoRiI56wDdr84450f/AOO4HTiJLhmCT1fUwAHZMGDfXxBsobiRZ0KzmRxUqH?=
 =?us-ascii?Q?skMQySlYxDlzudEVQwM/OE6+fj/ZWAMNrjkeO/tJktiNlC+nFmAWGib1ied9?=
 =?us-ascii?Q?evjcPnTMZq+vvM283zB91vkC/9zkefCruHDgv8Sb/blG7fx+Pj1z9ixWQv4R?=
 =?us-ascii?Q?ye4iYOwjaNfZyZzysnOfNqCIEYyUF939OcjNBXOHK/WGmZrB3nUk2E6MjQaX?=
 =?us-ascii?Q?Eaqp9gmY6z5477IxNhzyMSALWHjvHjWw6sZ/RfjAL+cNb0CzcEniM/i9Ayed?=
 =?us-ascii?Q?D+PlMWNQLh1M+IkVQ/B0EzvwMo3adF4hxHLahZImt6Vynlt2nTLdezJLeGIH?=
 =?us-ascii?Q?mXBb9c7VN/UOqd3V4NwX9umvj4PeVTtPurC2/M9E0CZ8tgG5ZMgdZ6BYVut1?=
 =?us-ascii?Q?avVS6+B09gJmW1rK72Z9bpDAeBXJ+6P8GldS+aQhUBP37w+doPxoD3hGElIa?=
 =?us-ascii?Q?JWHb0NW1luB/0OnL9fDNkhf97avmRjbDZIrxkoTEbLtPr3GyuSm3pan5k5Tv?=
 =?us-ascii?Q?kxDZuUKox1Q0GJq8N/6kcxiy7uhiifZJ1tu8ectwjGmhPkFqpiWHYSSBolBx?=
 =?us-ascii?Q?afiRaaNIh24vhzJOZzxnEAPSXVbUcZDRso+VkNn6a83tKvgFfDvyzHc53N2q?=
 =?us-ascii?Q?/N8YmBLbJWMMA8CYOO7LbeIFkXGMlU0M52MzQEjmU13SlHenD3hq234nUSx/?=
 =?us-ascii?Q?Lnnerna6i/jSo1WO3REQCjqKcoxB50Xjv6fNkYOdFWXeaTOSJHdBg/LUL1Zf?=
 =?us-ascii?Q?wh+o1rvnC0H9CmmEIzvBZnTARnE65TDTZfRJzgBDa2hD2PJdLMcWmPvQzjxA?=
 =?us-ascii?Q?cLiNExx0mEXzBSoY9Te+7zqM9eJCMwaftGi+u6kNztM6dRCoKbMmF49owDhj?=
 =?us-ascii?Q?4rqhqfKvK/OsLMPPTCPog7TKYoZUyWVXyf4FpWSqGX4BJmAoDUEKdF8p8XQf?=
 =?us-ascii?Q?ZIEV+5cwG/sN1UUGwayqu8E3ygaiMQRAZ40DQ5j732aAh19mvKxkNKtMCs7f?=
 =?us-ascii?Q?sUTCHJmNS1W1L6A6E+8OtZDGxbcistVt/JFoAC2xexoihrCcrC/Az/5M7QG7?=
 =?us-ascii?Q?ye0yaZ08AC5sb+/PrCYVeICeCVDB3J/khlNVQMTsHe2Hbq2UUMZgYXKoV/No?=
 =?us-ascii?Q?LiircdeN16YTK7jGqM40aGA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f449fb1-dd0f-4463-c9af-08daa20b7743
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 11:12:15.8117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDTqJhJZ/kr0bBgdTyzdJazdSgoUNBJ0op4eQBE7UVkB+MmEIhDAi8pcmfEn2e5uWI1FxkKuQ/2iUA9CMDP1Hvezr1w6JBKVX+GR4jPzB/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 01:21:38PM -0700, Tony Nguyen wrote:
> From: Jan Sokolowski <jan.sokolowski@intel.com>

Hi Jan, Tony,

> 
> During reallocation of RX buffers, new DMA mappings are created for
> those buffers. New buffers with different RX ring count should
> substitute older ones, but those buffers were freed in
> i40e_configure_rx_ring and reallocated again with i40e_alloc_rx_bi,
> thus kfree on rx_bi caused leak of already mapped DMA.
> 
> In case of non XDP ring, do not free rx_bi and reuse already existing

Out of the sudden you talk about non XDP ring so I would expect some
reference to XDP ring before that?

TBH I was having a hard time reading the commit message from ice based
patch and it was c&ped from there.

For example, it says nothing about newly introduced
i40e_realloc_rx_xdp_bi(), i40e_realloc_rx_bi_zc().

> buffer, move kfree to XDP rings only, remove unused i40e_alloc_rx_bi
> function.
> 
> steps for reproduction:
> while :
> do
> for ((i=0; i<=8160; i=i+32))
> do
> ethtool -G enp130s0f0 rx $i tx $i
> sleep 0.5
> ethtool -g enp130s0f0
> done
> done
> 
> Fixes: be1222b585fd ("i40e: Separate kernel allocated rx_bi rings from AF_XDP rings")
> Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
> Tested-by: Chandan <chandanx.rout@intel.com> (A Contingent Worker at Intel)

I looked through my inbox and it seems that you provide different names
{Chandan, Chandan Rout, Chandan Kumar Rout} with your tested-by tag, why?

> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  .../net/ethernet/intel/i40e/i40e_ethtool.c    |  3 -
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 ++--
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 13 ++--
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 -
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 67 ++++++++++++++++---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  2 +-
>  6 files changed, 71 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index e518aaa2c0ca..0f2042f1597c 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> @@ -2181,9 +2181,6 @@ static int i40e_set_ringparam(struct net_device *netdev,
>  			 */
>  			rx_rings[i].tail = hw->hw_addr + I40E_PRTGEN_STATUS;
>  			err = i40e_setup_rx_descriptors(&rx_rings[i]);
> -			if (err)
> -				goto rx_unwind;
> -			err = i40e_alloc_rx_bi(&rx_rings[i]);
>  			if (err)
>  				goto rx_unwind;
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index e3d9804aeb25..ad15749a2dd3 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -3565,12 +3565,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
>  	if (ring->vsi->type == I40E_VSI_MAIN)
>  		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
>  
> -	kfree(ring->rx_bi);
>  	ring->xsk_pool = i40e_xsk_pool(ring);
>  	if (ring->xsk_pool) {
> -		ret = i40e_alloc_rx_bi_zc(ring);
> -		if (ret)
> -			return ret;
>  		ring->rx_buf_len =
>  		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
>  		/* For AF_XDP ZC, we disallow packets to span on
> @@ -3588,9 +3584,6 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
>  			 ring->queue_index);
>  
>  	} else {
> -		ret = i40e_alloc_rx_bi(ring);
> -		if (ret)
> -			return ret;
>  		ring->rx_buf_len = vsi->rx_buf_len;
>  		if (ring->vsi->type == I40E_VSI_MAIN) {
>  			ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
> @@ -13304,6 +13297,11 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
>  		i40e_reset_and_rebuild(pf, true, true);
>  	}
>  
> +	if (!i40e_enabled_xdp_vsi(vsi) && prog)
> +		i40e_realloc_rx_bi_zc(vsi, true);
> +	else if (i40e_enabled_xdp_vsi(vsi) && !prog)
> +		i40e_realloc_rx_bi_zc(vsi, false);

why retvals are ignored?

Please explain this better in the commit message so that in future we will
be able to refer to it and understand the reason why we're doing it in
this way.

> +
>  	for (i = 0; i < vsi->num_queue_pairs; i++)
>  		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
>  
> @@ -13536,6 +13534,7 @@ int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair)
>  
>  	i40e_queue_pair_disable_irq(vsi, queue_pair);
>  	err = i40e_queue_pair_toggle_rings(vsi, queue_pair, false /* off */);
> +	i40e_clean_rx_ring(vsi->rx_rings[queue_pair]);
>  	i40e_queue_pair_toggle_napi(vsi, queue_pair, false /* off */);
>  	i40e_queue_pair_clean_rings(vsi, queue_pair);
>  	i40e_queue_pair_reset_stats(vsi, queue_pair);
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index 69e67eb6aea7..b97c95f89fa0 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1457,14 +1457,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
>  	return -ENOMEM;
>  }
>  
> -int i40e_alloc_rx_bi(struct i40e_ring *rx_ring)
> -{
> -	unsigned long sz = sizeof(*rx_ring->rx_bi) * rx_ring->count;
> -
> -	rx_ring->rx_bi = kzalloc(sz, GFP_KERNEL);
> -	return rx_ring->rx_bi ? 0 : -ENOMEM;
> -}
> -
>  static void i40e_clear_rx_bi(struct i40e_ring *rx_ring)
>  {
>  	memset(rx_ring->rx_bi, 0, sizeof(*rx_ring->rx_bi) * rx_ring->count);
> @@ -1593,6 +1585,11 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
>  
>  	rx_ring->xdp_prog = rx_ring->vsi->xdp_prog;
>  
> +	rx_ring->rx_bi =
> +		kcalloc(rx_ring->count, sizeof(*rx_ring->rx_bi), GFP_KERNEL);
> +	if (!rx_ring->rx_bi)
> +		return -ENOMEM;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> index 41f86e9535a0..768290dc6f48 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> @@ -469,7 +469,6 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size);
>  bool __i40e_chk_linearize(struct sk_buff *skb);
>  int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
>  		  u32 flags);
> -int i40e_alloc_rx_bi(struct i40e_ring *rx_ring);
>  
>  /**
>   * i40e_get_head - Retrieve head from head writeback
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 6d4009e0cbd6..790aaeff1b47 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -10,14 +10,6 @@
>  #include "i40e_txrx_common.h"
>  #include "i40e_xsk.h"
>  
> -int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
> -{
> -	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
> -
> -	rx_ring->rx_bi_zc = kzalloc(sz, GFP_KERNEL);
> -	return rx_ring->rx_bi_zc ? 0 : -ENOMEM;
> -}
> -
>  void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring)
>  {
>  	memset(rx_ring->rx_bi_zc, 0,
> @@ -29,6 +21,58 @@ static struct xdp_buff **i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
>  	return &rx_ring->rx_bi_zc[idx];
>  }
>  
> +/**
> + * i40e_realloc_rx_xdp_bi - reallocate for either XSK or normal buffer

reallocate SW ring

> + * @rx_ring: Current rx ring
> + * @pool_present: is pool for XSK present
> + *
> + * Try allocating memory and return ENOMEM, if failed to allocate.
> + * If allocation was successful, substitute buffer with allocated one.
> + * Returns 0 on success, negative on failure
> + */
> +static int i40e_realloc_rx_xdp_bi(struct i40e_ring *rx_ring, bool pool_present)
> +{
> +	size_t elem_size = pool_present ? sizeof(*rx_ring->rx_bi_zc) :
> +					  sizeof(*rx_ring->rx_bi);
> +	void *sw_ring = kcalloc(rx_ring->count, elem_size, GFP_KERNEL);
> +
> +	if (!sw_ring)
> +		return -ENOMEM;
> +
> +	if (pool_present) {
> +		kfree(rx_ring->rx_bi);
> +		rx_ring->rx_bi = NULL;
> +		rx_ring->rx_bi_zc = sw_ring;
> +	} else {
> +		kfree(rx_ring->rx_bi_zc);
> +		rx_ring->rx_bi_zc = NULL;
> +		rx_ring->rx_bi = sw_ring;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * i40e_realloc_rx_bi_zc - reallocate xdp queue pairs

queue pairs?? rather Rx SW rings?

> + * @vsi: Current VSI
> + * @zc: is zero copy set
> + *
> + * Reallocate buffer for rx_rings that might be used by XSK.
> + * XDP requires more memory, than rx_buf provides.
> + * Returns 0 on success, negative on failure
> + */
> +int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc)
> +{
> +	struct i40e_ring *rx_ring;
> +	unsigned long q;
> +
> +	for_each_set_bit(q, vsi->af_xdp_zc_qps, vsi->alloc_queue_pairs) {
> +		rx_ring = vsi->rx_rings[q];
> +		if (i40e_realloc_rx_xdp_bi(rx_ring, zc))
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  /**
>   * i40e_xsk_pool_enable - Enable/associate an AF_XDP buffer pool to a
>   * certain ring/qid
> @@ -69,6 +113,10 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
>  		if (err)
>  			return err;
>  
> +		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], true);
> +		if (err)
> +			return err;
> +
>  		err = i40e_queue_pair_enable(vsi, qid);
>  		if (err)
>  			return err;
> @@ -113,6 +161,9 @@ static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
>  	xsk_pool_dma_unmap(pool, I40E_RX_DMA_ATTR);
>  
>  	if (if_running) {
> +		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], false);
> +		if (err)
> +			return err;
>  		err = i40e_queue_pair_enable(vsi, qid);
>  		if (err)
>  			return err;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> index bb962987f300..821df248f8be 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> @@ -32,7 +32,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
>  
>  bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
>  int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
> -int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring);
> +int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
>  void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
>  
>  #endif /* _I40E_XSK_H_ */
> -- 
> 2.35.1
> 
