Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E68696747
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjBNOrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjBNOq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:46:57 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABAA2119
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676386014; x=1707922014;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TSdYMzBwd8F6fRW8VQi2CDQQwwx97CC38iyFpNIWNBc=;
  b=ctd9MKq5E6w6iJgncP0OlWL8unX+nA9g1He2o/1FUiJWM/JaBubbS5+m
   TvIRdQX+YubhRTCdKApRBKtAzdyRVe1vZjLCv6eXiSRF9JjNyyyz/z/Yk
   R+JaSOHW5gkTyehcJlasMExueGThJIXY8Bzdgj4L9KIdWvbKtj8crI6eu
   j3aOEu9Knse6m42IyD41Ig+1vH7u4MxfbSkn43UA+0OFYYc0AVXwzqDom
   fe6Vr+sqPmGxtoSnxUTHcy/2YmZ/yCLSfpmc1n12kqdgDoRVxmMbpnPq2
   /Kdi+svgD+Z73uQrqOPva9jv+DIOAjvI2qcctRfxSXUmOs9lux7O+Rj39
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393576287"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="393576287"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 06:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699548393"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="699548393"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 06:46:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 06:46:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 06:46:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 06:46:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7cW77gSbLJCZe4+PCwR8iPXKa343Bd1EbF9XA026QAUv8B7/Q8Cu4hliO5JEqWDy4feH4xlmonXLF0BYFBnKArLxFVwOZ6tioe8yCKpW6RXDV6ORLewkHGuXz9A5+Cd1z6M77mwvokixQbCY1XVaFJqmHf/xe/MaQPlMnXrfrVnBZIeyRmY9yyYCC9aJFcFE/efSyDK0DH/vGmxcGcOusmXmRpzVrq1wXw8zvmpYXVstt4cmCDouf6cQPD3K7qiJAmmHKdWb7/2T0iuaQyKplfadFHXmaX7a9B/f5Ls1huw6CgWptaPe6UOJ41LD0YH+WyRS5zYOnBqDl4UOXEOqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nswn1K64pmUE2rLoMyEKomhNam2dlBrh6bXF9Ne5JHA=;
 b=mpGzITr5Gq3r58TgxYGYRVlISXH5TJQHxFLZPt/XCLr32CpKu6nOi/7LHY3sHJSvcs/n9fdhW/aWDBtSVM26cLql3mPhCHqbBTETZXeJ2CV3WoFeWeusPcgrLZQBrvi5oGbwPlNRDt1SsFEUEg+R7Jjls+gyBqiEteWul1FW5HyD3yPeeLdKqdM8iWeGK1AYlAF/mrV2Dv5ykp2SgfooKN9Xkje8yKWGyDNhPdiDFTw8VJ6SraLkozCpcIm4xvDLVkLTfHRAwn86w1eotHzpK7LO233yn+S159t1zSss8KpyuA9aEq2c9YoJPv5Lm+6FzqTagePidxs51ZEJFpuCnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB6972.namprd11.prod.outlook.com (2603:10b6:806:2ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 14:46:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 14:46:51 +0000
Date:   Tue, 14 Feb 2023 15:46:37 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Jeroen de Borst" <jeroendb@google.com>
Subject: Re: [PATCH net-next 4/4] gve: Add AF_XDP zero-copy support for
 GQI-QPL format
Message-ID: <Y+uezQZParX1zpxI@boxer>
References: <20230207210058.2257219-1-pkaligineedi@google.com>
 <20230207210058.2257219-5-pkaligineedi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230207210058.2257219-5-pkaligineedi@google.com>
X-ClientProxiedBy: FR3P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::21) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7c17c1-8e6a-4a25-1173-08db0e9a4e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ef30qq6Akkl1HD8djC3IAp5COT8EJ77byAZ08gF0J+sBVG7I9Pd6pzQa8N8ixtxlDARGR+ReZSgRMA1tY8izRMx6ADbNnusNxMI8uV17c71RjGjK+f6cyhiZ6gWratWodfrEUWqUx9CmiYLBTGqi/0g1mEUpbRG7rfEEvBK4jZmkKy1aCnKS79a/Gnd54ysMTuRM+DMcKgL+lKCY2rKhGCO6yruxjDNHe9cEcBSe0GGyDk6Gopl+CqYu/v7J0oWosMeW3CTNwZGFz4jdZ5dnA45AWHqmxGStoOjTRDCWg0kZlHEJ09pDbqJhyhX9ZErFdRA2JV9UhiJGSTM+9DYQCCww/MTDrgQ6iSVF4UeM1mitAemBMers3zohXAXXu3dXHQmcK1VfFuNZP6apkQhs+TACFGMpelKN9CK7U9cl0G6Vgd9KwIHj1Y14HukIbbC1IHVSKaHnG00G/p2d+DoGflTe+O2EPBF0l1EYPaQ+EBbfCeMZfhcgqM8fiyOr1ODoZXxAo18KW+2OUeBgrqYxkLQ1KmLdU0khs8SS5ThQkyNDuKJ3GvoalpRqk7bMR/3h+Az+Lb5QZOnB0700bdXOEYxN86BuGM+HnrLS0r49cnOuEAfAS10cl9UfgYlAJKQzE3n+NtFf+D+gfiw2bV3tiYRaOciFCB9VFZgLzzvt6/m2l+rkQWEs16Dgvl4htKnp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(478600001)(6666004)(2906002)(26005)(6512007)(9686003)(6506007)(186003)(33716001)(82960400001)(38100700002)(30864003)(44832011)(6486002)(8936002)(86362001)(316002)(5660300002)(6916009)(66476007)(66556008)(41300700001)(83380400001)(4326008)(8676002)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qhD7zGpjaifvhOFXNGHCp2UBmLDcw5xjBLnWoDsMm96XYijxofCcYbflbHb7?=
 =?us-ascii?Q?AD3z3jF0OOc0282D4n6rgTA/scN2T9eUYUxQ61WdKkRO6fGkqhl88rN0aQLQ?=
 =?us-ascii?Q?o00rY4d0akFrD1NmuFUMuY33zdrwOrOs/kxjoo8f45QWZEUWC3eTCg6mAET1?=
 =?us-ascii?Q?rZDYzGBJYfsa2VfR8mdRGESA0LdrTR4HOxx4vHBUV1BgurP2WlnAduZb9aq9?=
 =?us-ascii?Q?WjIUBF68nXplGAqymCmCpT2N7WvcP8ePlSYtuRnwFHC3qWYY+0seOzbG0cCo?=
 =?us-ascii?Q?kLRoF1CHYwMbpEaY8mL0Bins1pcOBF1BGIot9105i2D+tltfEjovUbk7EKK3?=
 =?us-ascii?Q?82+ZreHSOEh+76WBHaqq/w9CXp/ZgGd81Ao/tsYpkmbA23Ea00+TL67NjRhl?=
 =?us-ascii?Q?W1orkMHONKhe4X83za2YFNvm+yntwqKs47AC2Pgonmg8BwAIq8NYHcX3n1tP?=
 =?us-ascii?Q?gYnj/E9C3ORlOQz46OoGMlFwq+ZkFkf0iL8yL4aO8VOLskBXGMvDaq+8ynY3?=
 =?us-ascii?Q?nfJ1j72dis+REhDhmzLrrBuItlLK9rkHJf8sVBgE0PQ2cKvSXylm4svt2xFT?=
 =?us-ascii?Q?QUnxdDPCFJCE71lp2GgYEZ5nkDvdt6cWGpJV+6EG+KEAg7AguvMCcNsXPDFA?=
 =?us-ascii?Q?kRkNDGOZtMHk9kcO0xNQtEax6UxPjy3b19ZcS9xkUEtqhPZJY2eRYW8aVm0q?=
 =?us-ascii?Q?Yuh1ZyWY8bd5lU+rTSbhNTuE59HYszsrI+5Rjb7xGzwlX/wpVoUOK5vXhpVK?=
 =?us-ascii?Q?J3jLesvKqytWXwXHTiE06YHxRD7Dz2fH0GhuQ1Jz1yC3vgx6DC6TeRKg7cKc?=
 =?us-ascii?Q?mRvNYWprGGiw/JE6lxmC+60tsXGjCUDSx32Ojv6a88y8Wu0kyHex1vSVT0GZ?=
 =?us-ascii?Q?gcwsMqwGZSHndKwfhq4PeaIN9r+qVbxJsxGn8GQsvTQOrXAuO/gvb11O/dSL?=
 =?us-ascii?Q?FZM93m0qMPEUVt45yjt0hT6/verL0dEtIx5MXaxDYvHhibhcvzQjdB8ALIFn?=
 =?us-ascii?Q?EALxHHst3mARHxlwjSl/FQHgfFjXX1TZR9N/vMDQN7YhpjsaeSIIFqCtHL0R?=
 =?us-ascii?Q?0ZJPeOrL00p+vp4M3xQmor/7xtSaNRX6BcFOOrmROG5c04EmYKTNFmTUVIEJ?=
 =?us-ascii?Q?4uGdLdQTbwKvDNLqTX4l77dteCCp0Rauo7tK51LB98js5HTZ4sdZMNzS0nVe?=
 =?us-ascii?Q?AotnndeZTkBhdEBzIb/IQUcrLSjbkTkkCIYKPs3s/fFoeoTZfQhiRDSuXCBv?=
 =?us-ascii?Q?PN3MzkjorNfZWpyvIFfJ/Z7YXB+u3TWfnpzRYc+6Bi7he5ZycCJ9ULa6wXAs?=
 =?us-ascii?Q?av951A3hFKczYCVXr9ABMjjDZNeQv06AUSjPLm/m7QLbP+2PR3m/R4fi6F4U?=
 =?us-ascii?Q?E9QDALBrK5D47sLXBJy+BNdIZRHDo6JPfKo8bgC+4/clqJxORioibX0FVjgz?=
 =?us-ascii?Q?Gmg4MQq6sx/kLkPKynNj+rg1qNgIMAECq2IQGGJB6FaGCf4Jj7ExbgF2ZhCN?=
 =?us-ascii?Q?7z5blOB4jNzxHbBYWh0XwH5eWG4OJU5jpHz7Ga/3ItngWN+pJ0niVz1TQWv+?=
 =?us-ascii?Q?nN2OTrh8iEAAPZzi7ydbuzOmHWkRGuFSOHrp9hHIaPyPpzTkEt2jO4hGGjNP?=
 =?us-ascii?Q?O1q7NokvORo9zK3E6DJzcNU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7c17c1-8e6a-4a25-1173-08db0e9a4e9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 14:46:51.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxUdhtU/GHQI/WlQbCNeCjDcLOHc7jdoue9fhUCCnQaxyu57s+5HBlWaT3siEv18/h88AwY3Lpd/Swb23wiJrXuNdCE3r1nMNSvFaza630Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6972
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 01:00:58PM -0800, Praveen Kaligineedi wrote:
> Adding AF_XDP zero-copy support.
> 
> Note: Although these changes support AF_XDP socket in zero-copy
> mode, there is still a copy happening within the driver between
> XSK buffer pool and QPL bounce buffers in GQI-QPL format.
> 

Please share the perf for copy mode and zero copy mode. As long as ZC
outperforms copy mode supporting this makes sense, but to me you're just
changing the place where copy mode happens (at least on Rx side). Can you
also explain what stops you from feeding buffers from xsk pool to QPL
bounce buffers?

> This patch contains the following changes:
> 1) Enable and disable XSK buffer pool
> 2) Copy XDP packets from QPL bounce buffers to XSK buffer on rx
> 3) Copy XDP packets from XSK buffer to QPL bounce buffers and
>    ring the doorbell as part of XDP TX napi poll
> 4) ndo_xsk_wakeup callback support
> 
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> Reviewed-by: Jeroen de Borst <jeroendb@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h         |   7 +
>  drivers/net/ethernet/google/gve/gve_ethtool.c |  14 +-
>  drivers/net/ethernet/google/gve/gve_main.c    | 134 +++++++++++++++++-
>  drivers/net/ethernet/google/gve/gve_rx.c      |  30 ++++
>  drivers/net/ethernet/google/gve/gve_tx.c      |  58 +++++++-
>  5 files changed, 233 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index f89b1278db70..793b054580e3 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -248,6 +248,8 @@ struct gve_rx_ring {
>  
>  	/* XDP stuff */
>  	struct xdp_rxq_info xdp_rxq;
> +	struct xdp_rxq_info xsk_rxq;
> +	struct xsk_buff_pool *xsk_pool;
>  	struct page_frag_cache page_cache;
>  };
>  
> @@ -275,6 +277,7 @@ struct gve_tx_buffer_state {
>  	};
>  	struct {
>  		u16 size; /* size of xmitted xdp pkt */
> +		u8 is_xsk; /* xsk buff */
>  	} xdp;
>  	union {
>  		struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
> @@ -469,6 +472,10 @@ struct gve_tx_ring {
>  	dma_addr_t q_resources_bus; /* dma address of the queue resources */
>  	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
>  	struct u64_stats_sync statss; /* sync stats for 32bit archs */
> +	struct xsk_buff_pool *xsk_pool;
> +	u32 xdp_xsk_wakeup;
> +	u32 xdp_xsk_done;
> +	u64 xdp_xsk_sent;
>  	u64 xdp_xmit;
>  	u64 xdp_xmit_errors;
>  } ____cacheline_aligned;
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index 57940f90c6be..89accad6c13a 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -62,8 +62,8 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
>  static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
>  	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_consumed_desc[%u]", "tx_bytes[%u]",
>  	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
> -	"tx_dma_mapping_error[%u]",
> -	"tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
> +	"tx_dma_mapping_error[%u]", "tx_xsk_wakeup[%u]",
> +	"tx_xsk_done[%u]", "tx_xsk_sent[%u]", "tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
>  };
>  
>  static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
> @@ -380,13 +380,17 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  					data[i++] = value;
>  				}
>  			}
> +			/* XDP xsk counters */
> +			data[i++] = tx->xdp_xsk_wakeup;
> +			data[i++] = tx->xdp_xsk_done;
>  			do {
>  				start = u64_stats_fetch_begin(&priv->tx[ring].statss);
> -				data[i] = tx->xdp_xmit;
> -				data[i + 1] = tx->xdp_xmit_errors;
> +				data[i] = tx->xdp_xsk_sent;
> +				data[i + 1] = tx->xdp_xmit;
> +				data[i + 2] = tx->xdp_xmit_errors;
>  			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
>  						       start));
> -			i += 2; /* XDP tx counters */
> +			i += 3; /* XDP tx counters */
>  		}
>  	} else {
>  		i += num_tx_queues * NUM_GVE_TX_CNTS;
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 4398e5887f3b..a0edf94d20db 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -17,6 +17,7 @@
>  #include <linux/utsname.h>
>  #include <linux/version.h>
>  #include <net/sch_generic.h>
> +#include <net/xdp_sock_drv.h>
>  #include "gve.h"
>  #include "gve_dqo.h"
>  #include "gve_adminq.h"
> @@ -983,7 +984,7 @@ static void gve_turnup(struct gve_priv *priv);
>  
>  static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
>  {
> -	int err = 0, i;
> +	int err = 0, i, tx_qid;
>  
>  	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
>  		struct gve_rx_ring *rx = &priv->rx[i];
> @@ -998,6 +999,24 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
>  						 MEM_TYPE_PAGE_SHARED, NULL);
>  		if (err)
>  			goto out;
> +		err = xdp_rxq_info_reg(&rx->xsk_rxq, dev, i,
> +				       napi->napi_id);
> +		if (err)
> +			goto out;
> +		err = xdp_rxq_info_reg_mem_model(&rx->xsk_rxq,
> +						 MEM_TYPE_XSK_BUFF_POOL, NULL);

I don't like registering this unconditionally, you could at least move
this inside if (rx->xsk_pool) below.

> +		if (err)
> +			goto out;
> +		rx->xsk_pool = xsk_get_pool_from_qid(dev, i);
> +		if (rx->xsk_pool) {
> +			xsk_pool_set_rxq_info(rx->xsk_pool,
> +					      &rx->xsk_rxq);

we normally also pull the frame size from pool via
xsk_pool_get_rx_frame_size() and assign this to Rx HW ring as buffer
length, but since you implement this ZC support in some quirked way then
it doesn't matter at that point

> +		}
> +	}
> +
> +	for (i = 0; i < priv->num_xdp_queues; i++) {
> +		tx_qid = gve_xdp_tx_queue_id(priv, i);
> +		priv->tx[tx_qid].xsk_pool = xsk_get_pool_from_qid(dev, i);
>  	}
>  
>  out:
> @@ -1006,12 +1025,19 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
>  
>  static void gve_unreg_xdp_info(struct gve_priv *priv)
>  {
> -	int i;
> +	int i, tx_qid;
>  
>  	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
>  		struct gve_rx_ring *rx = &priv->rx[i];
>  
>  		xdp_rxq_info_unreg(&rx->xdp_rxq);
> +		xdp_rxq_info_unreg(&rx->xsk_rxq);
> +		rx->xsk_pool = NULL;
> +	}
> +
> +	for (i = 0; i < priv->num_xdp_queues; i++) {
> +		tx_qid = gve_xdp_tx_queue_id(priv, i);
> +		priv->tx[tx_qid].xsk_pool = NULL;
>  	}
>  }
>  
> @@ -1182,6 +1208,104 @@ static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
>  	return 0;
>  }
>  
> +static int gve_xsk_pool_enable(struct net_device *dev,
> +			       struct xsk_buff_pool *pool,
> +			       u16 qid)
> +{
> +	struct gve_priv *priv = netdev_priv(dev);
> +	int tx_qid;
> +	int err;
> +
> +	if (qid >= priv->rx_cfg.num_queues) {
> +		dev_err(&priv->pdev->dev, "xsk pool invalid qid %d", qid);
> +		return -EINVAL;
> +	}
> +	if (pool->frame_len < priv->dev->max_mtu + sizeof(struct ethhdr)) {
> +		dev_err(&priv->pdev->dev, "xsk pool frame_len too small");
> +		return -EINVAL;
> +	}
> +
> +	err = xsk_pool_dma_map(pool, &priv->pdev->dev,
> +			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
> +	if (err)
> +		return err;
> +	xsk_pool_set_rxq_info(pool, &priv->rx[qid].xsk_rxq);
> +	tx_qid = gve_xdp_tx_queue_id(priv, qid);
> +	priv->rx[qid].xsk_pool = pool;
> +	priv->tx[tx_qid].xsk_pool = pool;
> +
> +	return 0;
> +}
> +
> +static int gve_xsk_pool_disable(struct net_device *dev,
> +				u16 qid)
> +{
> +	struct gve_priv *priv = netdev_priv(dev);
> +	struct napi_struct *napi_tx;
> +	struct xsk_buff_pool *pool;
> +	int sleep = 2000;
> +	int tx_qid;
> +
> +	pool = xsk_get_pool_from_qid(dev, qid);
> +	if (!pool)
> +		return -EINVAL;
> +	if (qid >= priv->rx_cfg.num_queues)
> +		return -EINVAL;
> +
> +	tx_qid = gve_xdp_tx_queue_id(priv, qid);
> +	priv->rx[qid].xsk_pool = NULL;
> +	priv->tx[tx_qid].xsk_pool = NULL;
> +
> +	/* Make sure it is visible to the workers on datapath */
> +	smp_mb();
> +
> +	if (!netif_running(dev) || !priv->xdp_prog)
> +		goto done;
> +
> +	napi_tx = &priv->ntfy_blocks[priv->tx[tx_qid].ntfy_id].napi;
> +	napi_disable(napi_tx); /* make sure current tx poll is done */
> +	napi_enable(napi_tx); /* simply pair with disable */
> +	if (gve_tx_clean_pending(priv, &priv->tx[tx_qid]))
> +		napi_schedule(napi_tx);
> +
> +	/* make sure no xdp_buff floating */
> +	while (pool->free_heads_cnt < pool->heads_cnt && sleep > 0) {

please don't access these fields directly from driver and figure out other
way of waiting for your napi processing to finish rather then this what we
call lately "sleep driven development" - you probably would be good to go
with having synchronize_rcu() here?

> +		usleep_range(1000, 2000);
> +		sleep--;
> +	}
> +	if (sleep <= 0)
> +		return -EBUSY;

return and leave dma mappings dangling?

> +
> +done:
> +	xsk_pool_dma_unmap(pool,
> +			   DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
> +	return 0;
> +}
> +
> +static int gve_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
> +{
> +	struct gve_priv *priv = netdev_priv(dev);
> +	int tx_queue_id = gve_xdp_tx_queue_id(priv, queue_id);
> +
> +	if (queue_id >= priv->rx_cfg.num_queues || !priv->xdp_prog)
> +		return -EINVAL;
> +
> +	if (flags & XDP_WAKEUP_TX) {
> +		struct gve_tx_ring *tx = &priv->tx[tx_queue_id];
> +		struct napi_struct *napi =
> +			&priv->ntfy_blocks[tx->ntfy_id].napi;
> +
> +		/* Call local_bh_enable to trigger SoftIRQ processing */
> +		local_bh_disable();
> +		napi_schedule(napi);
> +		local_bh_enable();

is this going to honor irq affinity from napi POV? we normally use
napi_if_scheduled_mark_missed() so napi stays where it was and move to a
cpu that issued ndo_xsk_wakeup()

> +
> +		tx->xdp_xsk_wakeup++;
> +	}
> +
> +	return 0;
> +}
> +
>  static int verify_xdp_configuration(struct net_device *dev)
>  {
>  	struct gve_priv *priv = netdev_priv(dev);
> @@ -1225,6 +1349,11 @@ static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  	switch (xdp->command) {
>  	case XDP_SETUP_PROG:
>  		return gve_set_xdp(priv, xdp->prog, xdp->extack);
> +	case XDP_SETUP_XSK_POOL:
> +		if (xdp->xsk.pool)
> +			return gve_xsk_pool_enable(dev, xdp->xsk.pool, xdp->xsk.queue_id);
> +		else
> +			return gve_xsk_pool_disable(dev, xdp->xsk.queue_id);
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1426,6 +1555,7 @@ static const struct net_device_ops gve_netdev_ops = {
>  	.ndo_set_features	=	gve_set_features,
>  	.ndo_bpf		=	gve_xdp,
>  	.ndo_xdp_xmit		=	gve_xdp_xmit,
> +	.ndo_xsk_wakeup		=	gve_xsk_wakeup,
>  };
>  
>  static void gve_handle_status(struct gve_priv *priv, u32 status)
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index ea833388f895..1ee95c56ce2b 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -10,6 +10,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/filter.h>
>  #include <net/xdp.h>
> +#include <net/xdp_sock_drv.h>
>  
>  static void gve_rx_free_buffer(struct device *dev,
>  			       struct gve_rx_slot_page_info *page_info,
> @@ -593,6 +594,31 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
>  	return skb;
>  }
>  
> +static int gve_xsk_pool_redirect(struct net_device *dev,
> +				 struct gve_rx_ring *rx,
> +				 void *data, int len,
> +				 struct bpf_prog *xdp_prog)
> +{
> +	struct xdp_buff *xdp;
> +	int err;
> +
> +	if (rx->xsk_pool->frame_len < len)
> +		return -E2BIG;
> +	xdp = xsk_buff_alloc(rx->xsk_pool);
> +	if (!xdp) {
> +		u64_stats_update_begin(&rx->statss);
> +		rx->xdp_alloc_fails++;
> +		u64_stats_update_end(&rx->statss);
> +		return -ENOMEM;
> +	}
> +	xdp->data_end = xdp->data + len;
> +	memcpy(xdp->data, data, len);
> +	err = xdp_do_redirect(dev, xdp, xdp_prog);
> +	if (err)
> +		xsk_buff_free(xdp);
> +	return err;
> +}
> +
>  static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
>  			    struct xdp_buff *orig, struct bpf_prog *xdp_prog)
>  {
> @@ -602,6 +628,10 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
>  	void *frame;
>  	int err;
>  
> +	if (rx->xsk_pool)
> +		return gve_xsk_pool_redirect(dev, rx, orig->data,
> +					     len, xdp_prog);
> +
>  	total_len = headroom + SKB_DATA_ALIGN(len) +
>  		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index b5261985a1fc..caaae2fe701e 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -11,6 +11,7 @@
>  #include <linux/tcp.h>
>  #include <linux/vmalloc.h>
>  #include <linux/skbuff.h>
> +#include <net/xdp_sock_drv.h>
>  
>  static inline void gve_tx_put_doorbell(struct gve_priv *priv,
>  				       struct gve_queue_resources *q_resources,
> @@ -666,7 +667,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
>  }
>  
>  static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
> -			   void *data, int len, void *frame_p)
> +			   void *data, int len, void *frame_p, bool is_xsk)
>  {
>  	int pad, nfrags, ndescs, iovi, offset;
>  	struct gve_tx_buffer_state *info;
> @@ -678,6 +679,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
>  	info = &tx->info[reqi & tx->mask];
>  	info->xdp_frame = frame_p;
>  	info->xdp.size = len;
> +	info->xdp.is_xsk = is_xsk;
>  
>  	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
>  				   &info->iov[0]);
> @@ -755,7 +757,7 @@ int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
>  	if (!gve_can_tx(tx, len))
>  		return -EBUSY;
>  
> -	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p);
> +	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p, false);
>  	tx->req += nsegs;
>  
>  	if (flags & XDP_XMIT_FLUSH)
> @@ -771,6 +773,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
>  	u32 clean_end = tx->done + to_do;
>  	u64 pkts = 0, bytes = 0;
>  	size_t space_freed = 0;
> +	u32 xsk_complete = 0;
>  	u32 idx;
>  	int i;
>  
> @@ -783,6 +786,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
>  
>  		bytes += info->xdp.size;
>  		pkts++;
> +		xsk_complete += info->xdp.is_xsk;
>  
>  		info->xdp.size = 0;
>  		if (info->xdp_frame) {
> @@ -799,6 +803,8 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
>  	}
>  
>  	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
> +	if (xsk_complete > 0 && tx->xsk_pool)
> +		xsk_tx_completed(tx->xsk_pool, xsk_complete);
>  	u64_stats_update_begin(&tx->statss);
>  	tx->bytes_done += bytes;
>  	tx->pkt_done += pkts;
> @@ -877,11 +883,43 @@ u32 gve_tx_load_event_counter(struct gve_priv *priv,
>  	return be32_to_cpu(counter);
>  }
>  
> +static int gve_xsk_tx(struct gve_priv *priv, struct gve_tx_ring *tx,
> +		      int budget)
> +{
> +	struct xdp_desc desc;
> +	int sent = 0, nsegs;
> +	void *data;
> +
> +	spin_lock(&tx->xdp_lock);
> +	while (sent < budget) {
> +		if (!gve_can_tx(tx, GVE_TX_START_THRESH))
> +			goto out;
> +
> +		if (!xsk_tx_peek_desc(tx->xsk_pool, &desc)) {

you could use batch API here

> +			tx->xdp_xsk_done = tx->xdp_xsk_wakeup;
> +			goto out;
> +		}
> +
> +		data = xsk_buff_raw_get_data(tx->xsk_pool, desc.addr);
> +		nsegs = gve_tx_fill_xdp(priv, tx, data, desc.len, NULL, true);
> +		tx->req += nsegs;
> +		sent++;
> +	}
> +out:
> +	if (sent > 0) {
> +		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
> +		xsk_tx_release(tx->xsk_pool);
> +	}
> +	spin_unlock(&tx->xdp_lock);
> +	return sent;
> +}
> +
>  bool gve_xdp_poll(struct gve_notify_block *block, int budget)
>  {
>  	struct gve_priv *priv = block->priv;
>  	struct gve_tx_ring *tx = block->tx;
>  	u32 nic_done;
> +	bool repoll;
>  	u32 to_do;
>  
>  	/* If budget is 0, do all the work */
> @@ -892,7 +930,21 @@ bool gve_xdp_poll(struct gve_notify_block *block, int budget)
>  	nic_done = gve_tx_load_event_counter(priv, tx);
>  	to_do = min_t(u32, (nic_done - tx->done), budget);
>  	gve_clean_xdp_done(priv, tx, to_do);
> -	return nic_done != tx->done;
> +	repoll = nic_done != tx->done;
> +
> +	if (tx->xsk_pool) {
> +		int sent = gve_xsk_tx(priv, tx, budget);
> +
> +		u64_stats_update_begin(&tx->statss);
> +		tx->xdp_xsk_sent += sent;
> +		u64_stats_update_end(&tx->statss);
> +		repoll |= (sent == budget);
> +		if (xsk_uses_need_wakeup(tx->xsk_pool))
> +			xsk_set_tx_need_wakeup(tx->xsk_pool);
> +	}
> +
> +	/* If we still have work we want to repoll */
> +	return repoll;
>  }
>  
>  bool gve_tx_poll(struct gve_notify_block *block, int budget)
> -- 
> 2.39.1.581.gbfd45094c4-goog
> 
