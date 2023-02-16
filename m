Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB71699886
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjBPPQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjBPPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:16:28 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84F13A850
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676560585; x=1708096585;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UO4/UB6u1mRTJOcbS3I3wTxXVSPFfTEjooYuY+Ty5w8=;
  b=A1jxXgUHD+M/VwMkZ8ecHbbe95diYKNm3/ByJheEOJHum0R+GfVBqfI4
   rwSZds3ywqc+hvcKj8PWfHH7TwIM19VSLHfLOEOhFCsAzyI8Xoy09GwBH
   UJbAaILu9tn86UNqjjatt45U8hP8VEBlNvQWh06B0e5DaQej//5tf6O4d
   G22/f41W0FM4W4fZ9FPx/IntOZxSr4+JnHmj7KL5scXBUUCGx5FlWRs3W
   AembWjnTPR0aTgTxM+42c6v0iOM5SRN1KD9YXkKWVzzmUGImjsCxaMguq
   0htWJu3kmjOVAssaV539IxZ1nb1Kqzlf/xIb83ZTjF7BgSFLExfnZUeyR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="330377464"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="330377464"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:13:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="700522308"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="700522308"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2023 07:13:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:13:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:13:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:13:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsxSy1ZcvtLyrZmuCTAihTXXRh51ksk7tTZCwEfveY0icI2SDZD783jpgOBtR8cGxQ4vqhElJTXNppQYiRzgz/0PoBLegv9DJwUkNoBzQEoztYs+oVl3O/FQ3ZwZr1Hvj/3gVeyS6aflTkTdBW7zMYTJB96Db2v0uUHVUXCHm3rq6spQoD7Y1SBGzeJL69j/mCejFGT9DaB4UAtDrJru7KL9JtM7+UwxAa24ODo7cB/RYNAl0MsfYr+gpWERGf6a1E5McgjSzqfk4Iu+Vjkfzdi16DVBPHi52E8HEGRf1zgVJXKenPv7MHIJkDIGI2xbYaU/oF4k1u2kQJ3ueYx2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAv9uYoKwoo9KM7r25z8gy43Rixaj8FuqGheA1Nka6o=;
 b=jv6IWGJ0nMAZgcTg6RTY8u9vNJCwTbOgrCrzSbabuPY/S1DLFsLsYR2z3dIBNzQzJbad7QITGLmLxnOySrjh7q2Z/ck7aw/0woXUXOLDed/vjueMs+eQi1QlH79ed72rdt7ORe/bebebR0N1FbktTNMKjmTM3B0GARGQtUgJ2jEWnAkwFLCNQ79f6HBaFx2GEB5tpFSLz1tkHItl0YPE4wX8PzhUiGuvd4Qj6Lu8AwOZ8A0FGIJ8y8P9+2nv7NyHK4CP2w2IDaDIgrJJ+c9T/yPr+5Z8v43Cz8GhChKuHy4YR/fz1kdOv67TMXMbsuQz3clcpU1oZ5/+/dUf7fPAOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 15:13:27 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 15:13:27 +0000
Date:   Thu, 16 Feb 2023 16:13:20 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [net-next 3/9] net/mlx5e: Remove redundant page argument in
 mlx5e_xdp_handle()
Message-ID: <Y+5IEDPwVfT9O8Fx@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-4-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-4-saeed@kernel.org>
X-ClientProxiedBy: LO4P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::23) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ca76b6-62f3-48f1-2e06-08db10305ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hb6KpGFaCMP9odZtCRgWREp+3MHBIn6k6hogrtxcArCwDNM7CKSNbVf9rJCsUZfVkV8coJ+4We6Q4flWwHbHoVQGdVAgG8GIpPP8XpaXLBUTXO5UH2JKtEw7D/SLOUrajSDGgVbQhJuNCQThoz5goFNZz8JY8eWKWqDQnIAmBIJVKh7zYlvyg3i9wpR/eLcb135De47HEp/BIB1F8ybYaS7CXcQbJZcJ704CE+g4o75x4DwO9ljyKkLZvazgbIJ28nVEo4SXBFG3pXXsIH9/4Xtp+06kokEGYyvUCA0Stop2cf3xstejQQjyFkhOoS8Q2XdW8Th/RlwBh5KPK3QWQ57tUzN1knceqNLTR1AF6zcfmtlw3bQPLku8xmfuaRQpnlK6X92YbkZ64MqKZqCDM2AwZjTtLTYTVUQbte72CvylwCki/K5hKYS+ZjSPyFtJGt/Vms9ILN1j0hdbPl49Rk779JUvW0HsCK7Di83G6oiJWriRwsKqoai69N04Em7SX5FzB83v4UmticzAgtsqlPquivrxeOGV4C1iXLU+c2Yvx0gwdfdhVDM/AS8a0d4SbM0cSu1Df+4KOjDkJLCBlloSw0xSTA8tkHw+UbElLnjyv6CD+6eK0RMZHWF+/7fmj2k1uYTr/+gIHvBSSxXxgNi0SYE+MKzhNwoeHh87utYwTuMYyxEbGQ9L/LwyRB9f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199018)(83380400001)(6486002)(86362001)(33716001)(9686003)(186003)(26005)(6666004)(6506007)(6512007)(478600001)(38100700002)(316002)(8936002)(44832011)(2906002)(82960400001)(54906003)(6916009)(41300700001)(8676002)(4326008)(5660300002)(66946007)(66476007)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/LU8PNnvNqYcc7kwTw0L1BSmOtQ9mz/BCHDdqDinJZwDddXZdS4fBMi5f3pr?=
 =?us-ascii?Q?QSeLtG1MneavIYQ6h/O7Ng4f7rMPShR2e3LHF1wTpU4KryPmwh13g13IQRtT?=
 =?us-ascii?Q?XllrgX5yKO99eAAg2keokGevR9sNprD3Rvk76l9zWHAk6yk0O9KVSjHyujNk?=
 =?us-ascii?Q?AoJXvy/8oZiMxIPefEyHNdA3Q3rCXEVCUh8hVWxT04AaSKwntO3G6q6rR25b?=
 =?us-ascii?Q?xTEpe6107QVGA9EaD1hnYvsdl0oJPku1UV5IF4ENREpuWzAycYr0c6oocYpx?=
 =?us-ascii?Q?E2k4HzGoaLx4Trh6ty4P7jcMLjbi6nlblmeGbmPcIlUrrLgNB61v5t/VvaT6?=
 =?us-ascii?Q?I1jAFOzJ04/FqaE3m2u7QYhP5gLQ6EVj8WZ3xx91jSctozWNLy41lttMDPmz?=
 =?us-ascii?Q?qslkNCO1jb3wwKK3eD8L03aw3MFaqs2eC5pX45USTGNe0JpS7CdipcR5CiY9?=
 =?us-ascii?Q?6qkcYf7pefiZ60pKyCcvS8l0PNu+azPwWfvN6ipw3xlVtSnkhzM36ZAWw76p?=
 =?us-ascii?Q?p2+CK8XZJNPSMYj1cv3YpYH6werEUj+whSc5ftIOXNVjR4CK3XH1iMhp4XK3?=
 =?us-ascii?Q?RPvrsQk5rDwkMPoXVr8dcsutCzSj46iG2CKOmZNIu9WE1h7GCitl2rE1rTeO?=
 =?us-ascii?Q?NWyZr7Hwv4YO+xGo6TZuM2qJ/IzgXQnEgS2XZruPMmcYFx8XYDAbzRdnF9Ym?=
 =?us-ascii?Q?WrQkIyIOItnzdfzx4zJjxwLx75dRNLvoffIqmn1yCUw+Vyu3vUkOIIcJHhtL?=
 =?us-ascii?Q?XVr02CWPx+Y/whsM0SNgklviurkEQL2j0qrk/VjJMj8l9MvEZyDKu5nu5map?=
 =?us-ascii?Q?5EHfQrJAkP2uBsXksBmRZGws6gJlbR2r/VLtkNpwSb6UGpqwGjDS/wYwfglz?=
 =?us-ascii?Q?VnjFVmvoSWb/WbEIJt0ZKuQaKmCLO/PutcIEM0Aaz8iFWqrycJ8mVjheBmJ4?=
 =?us-ascii?Q?5MaBHunVlc9Ew8uYNlsPPnLUylr2CI6FILqohkR1riXRD/Qk47EkD2gqHd00?=
 =?us-ascii?Q?5K0vo/zPRMfVZjG9ffunu3lGY+37soL82Rx9eBtk1SUteL7OIDvGXf3bo/rw?=
 =?us-ascii?Q?1Q0LxY1wmblh6zCV/UFXot8ZPZ6ROEtdxErx0yKEIaSAjkGtgkwbwqLNFgS3?=
 =?us-ascii?Q?q/hMaNszzh6Mrso1enJ60hM3CFOioqzVidoF+viNARVQHnN4OdEnztsYWS11?=
 =?us-ascii?Q?dFbmwNS6X4T7Ku2+9GVfjK1ro/7NJJboDEZlEnTStNU4ecARQk8sfKPYhwWA?=
 =?us-ascii?Q?NYdf7jSl5rAcaHUxccscC0WL2qvFy7yalj+46+FZVjy9jCmqgghd+CiNhst4?=
 =?us-ascii?Q?0IVi3ZCp2321bGyTUv7OGjGFMW5fM1frPwbVzjY8CMI7nzoDUUsSTdg7BlOy?=
 =?us-ascii?Q?2E1fNzTvar6hN2DQW9FS8jODeNC5YOntAXX+c/AMIgsSAiPYb9qGVy1+QdAJ?=
 =?us-ascii?Q?aJrsHCWuPfB7F4MsMtg2HvoRcR4SCxfMPI+nRgFgrklq26gfiSnWy1QMP6bz?=
 =?us-ascii?Q?s49sdZbXR88Ea1/R4fbjrl1UWH6arPQMLMM978Y+q1RGm1fTDbO5mRCiPs05?=
 =?us-ascii?Q?GPNPDhwOP2j37uVU5xaoxS5KDz8L/n3/00tP3WbD+xAn0+6gbNdYAOzi9ACI?=
 =?us-ascii?Q?fIniax3zs5t8gE6pYrOe5Pc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ca76b6-62f3-48f1-2e06-08db10305ae3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:13:27.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PG2H6NjGpk39zNm26HQ7mVlwtxVIVH00YQyiYVHhFFXC5ogymJnPx87eW328qBDyyuIg9RenRHhQR7yesps2a43ZJy1HIocoV2/wiwuepJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5923
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:12PM -0800, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Remove the page parameter, it can be derived from the xdp_buff member
> of mlx5e_xdp_buff.

Okay that's nice cleanup. How about squashing this with the previous patch
that does the same thing for xmit xdp_buff routine?

> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    |  4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h    |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 10 ++++------
>  4 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 4b9cd8ef8d28..bcd6370de440 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -186,7 +186,7 @@ const struct xdp_metadata_ops mlx5e_xdp_metadata_ops = {
>  };
>  
>  /* returns true if packet was consumed by xdp */
> -bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> +bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
>  		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
>  {
>  	struct xdp_buff *xdp = &mxbuf->xdp;
> @@ -210,7 +210,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
>  		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
>  		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
>  		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
> -			mlx5e_page_dma_unmap(rq, page);
> +			mlx5e_page_dma_unmap(rq, virt_to_page(xdp->data));
>  		rq->stats->xdp_redirect++;
>  		return true;
>  	default:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index 69f338bc0633..10bcfa6f88c1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -52,7 +52,7 @@ struct mlx5e_xdp_buff {
>  
>  struct mlx5e_xsk_param;
>  int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
> -bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> +bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
>  		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mlctx);
>  void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
>  bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index b7c84ebe8418..fab787600459 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -289,7 +289,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>  	 */
>  
>  	prog = rcu_dereference(rq->xdp_prog);
> -	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf))) {
> +	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf))) {
>  		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
>  			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
>  		return NULL; /* page/packet was consumed by XDP */
> @@ -323,7 +323,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>  	net_prefetch(mxbuf->xdp.data);
>  
>  	prog = rcu_dereference(rq->xdp_prog);
> -	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf)))
> +	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf)))
>  		return NULL; /* page/packet was consumed by XDP */
>  
>  	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 9ac2c7778b5b..ac570945d5d2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1610,7 +1610,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
>  
>  		net_prefetchw(va); /* xdp_frame data area */
>  		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
> -		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
> +		if (mlx5e_xdp_handle(rq, prog, &mxbuf))
>  			return NULL; /* page/packet was consumed by XDP */
>  
>  		rx_headroom = mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
> @@ -1698,10 +1698,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>  		wi++;
>  	}
>  
> -	au = head_wi->au;
> -
>  	prog = rcu_dereference(rq->xdp_prog);
> -	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
> +	if (prog && mlx5e_xdp_handle(rq, prog, &mxbuf)) {
>  		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
>  			int i;
>  
> @@ -1718,7 +1716,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>  	if (unlikely(!skb))
>  		return NULL;
>  
> -	page_ref_inc(au->page);
> +	page_ref_inc(head_wi->au->page);
>  
>  	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
>  		int i;
> @@ -2013,7 +2011,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
>  
>  		net_prefetchw(va); /* xdp_frame data area */
>  		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
> -		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
> +		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
>  			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
>  				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
>  			return NULL; /* page/packet was consumed by XDP */
> -- 
> 2.39.1
> 
