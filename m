Return-Path: <netdev+bounces-8789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F745725CC5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F0482810E5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0109456;
	Wed,  7 Jun 2023 11:10:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679828C01
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:10:46 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BFC1FCE;
	Wed,  7 Jun 2023 04:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686136219; x=1717672219;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UZZiV7J7ZxMJLD3fkexdeuIoe8Emtx4rKnSbEv/2a/U=;
  b=Du8jtjd2RDBRFnhx6Vo/eCZz69DDPrlcdtzgr6rC3bapuDnX/In7oNbA
   KkQDy6BTCF09pIf68FHNHVWwPUNfA3VKSwgGxMr72WsfN2nMZmMh/iI1h
   YgmaGkDXzKF1zfP7/vO1EpSaaV8+DFWG1kJ8aC9ygGu5KsQVgGWMP4PKz
   Lln8alzeEIvPDfnTTRz6J0Vc1REOqMTfaDGDI5YYn5UWmxnoGzErXB3Em
   UGXgXSuiDdfLisZ87zLNbfgOjr0/jYPBHOqIOMA4RlGwIk8DRMBuvpmIo
   RnVIKpuLl7/gz4Ap39P3Tmk91jvhYU0mdUBoKEihUKQsJQDmPvdWhxB3A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337315670"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="337315670"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="883720457"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="883720457"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Jun 2023 04:09:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:09:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 04:09:14 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 04:09:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX4dan8+KxVHY2nUGe3HOCb14bs9CtgLF08+LInNB+FjDJu7RADDYOobG/zrUVvZzbKv5e21RO9rTBHfmjSXP9mh1hCaE9X/cRWuOlBO1J4QOMy9K4+XRjOBqoB3pCut5EMORp3WnTXe4BTwabKQ2vPMG3zyCLAe6ctr08SqVHA4T+Hlii6pUMDVPXpCkMU7qp05KDOleOb70k0z+VsuEmiqEPPXUJUgToUMvG3F0Qfp7Pch0HXYryM/IlymOYXrOhMN5Q/eeqK08lJRqaEEGx9m0k8IWD1Ncq5qwgHQTMwRL1LvNXq9HGcxM+Ed+4mzQf0F9ntKKuJhtfvdPZ+QGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k331g7BEwYY3W6uvheTiv31Z4o6tmaIn51LWAHVyQKY=;
 b=fAj+5bXVttZLwJEpsoZLsBYO/GUH6ih27rhLh8ko9mtfL0yoQmn/cp/uXpInLYqpkEspdBGIW3K5vwmdE8eaEzu7itNJT4CKKebMB5Bg1Mw+QebsZuTaZjhJgLtIalnkM5h2ERc4DronsNtykJRKb/+WCFs7nNQGYo8nTkbKQO27q45RdnZi2f9knV1YhKH2S+U3xCoLcz5lH/EAupZXfCOn4CRSIUzpbRDhcscMXjT96nMbzbyymY9EcevbxiNFWYajfLuBFKkrPPzQa7xUBW7yRax/gicItpnvU4FP1iwIDCaMoNUkY42fMim0gSV6oswt1neIBLKSmOm4l5mf4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH3PR11MB8239.namprd11.prod.outlook.com (2603:10b6:610:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Wed, 7 Jun
 2023 11:09:11 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 11:09:11 +0000
Date: Wed, 7 Jun 2023 13:09:04 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC: <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/2] net: renesas: rswitch: Use hardware
 pause features
Message-ID: <ZIBlUHsVE9fyIGjC@boxer>
References: <20230607015641.1724057-1-yoshihiro.shimoda.uh@renesas.com>
 <20230607015641.1724057-3-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607015641.1724057-3-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: FR2P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH3PR11MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: 961d0892-5606-4860-0f9a-08db67479efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05jJYm5S2u9uXew6zbroAQ8SyqAdr7UFvaR6otLQkUEzfhILX9xUneSExnTBXeB4ijeBlIc+wZgLRHf9ZfT0Eh56hj5qRwsgGJcIix7H1IByK7ssdmS9xK6C8FrS02QLXZKtLETKc5JwQ4Z10nCeBJZPpH+stBS87bsRE4xrw4XyPGiPMghVG3eTJen1veZMeBvKLoyGazt6I4sd1NBJHskXApZt3Sur4ytid6xuKsH/Z5lL1/ac88VlI1g63TK+rb1PPD5NiBSi+eTIs6ZdneF9lhRHZjebfMKzkmQoyDGp/Raxv3INM0GB0QGiZNC1HquZQsZ98+06qnqG5mtiCXXmF2gvswQC3bPSSa0lLHL7TAg+YZPwMhJgp+AgpOB6NPy8xybOwbpWBWVnfihwBk80+OeZ2Wmf5Ca2Lvj/rKKqPW7SxpbL8u9318g2sBvUWPUyTpe+5MuBz/z4ozs/OEzTBGVKICHzVpFKlM4m4TqEa1sCy5DDEX/nzUYmsbVFXYkloXnb3pIkl+jv+waLMvnJmL2A5TR66EoHgQAm5fsQeUptrHgEWEaxXkGSBdTE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(6506007)(6512007)(9686003)(26005)(38100700002)(83380400001)(41300700001)(6486002)(6666004)(186003)(82960400001)(478600001)(2906002)(66476007)(66946007)(6916009)(66556008)(316002)(4326008)(44832011)(8936002)(86362001)(8676002)(5660300002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZyrNK5sUf3RspVkXjRFR8vlWYaeHQxOul6EvE5tvOigFwm3S1QA+f/MYQH4K?=
 =?us-ascii?Q?c3grQAojmI0r++7n2U4qhHGjpPor8ezw1tBMuz3bYZuYfkJf5ij6qS//NlCS?=
 =?us-ascii?Q?J9CbLSTjuZ/WAqFCv2yt8GIW7n+2nQSFDSpcGbjbHBBvgJIe7jQfYmK13UUi?=
 =?us-ascii?Q?RVOlsk/d0t29c96JUobFeO7z1bu6YJ97jljcN8djJ3MakpqRlheUUUWGGbbf?=
 =?us-ascii?Q?W9K6peJHoNTIVkH5LhERkfTRqKbzHKrwJXDBPksFMg1iYDg95+ACVlIDA/+L?=
 =?us-ascii?Q?1NT38IkjJ8VfSgY2vwXbg0Zoo8ypcR17cc0sHfgg1X4aKyFv/x1NC/A/fS78?=
 =?us-ascii?Q?CGDDLMJsN3kIalenbDR8u5O+whwbbu+ta5A3X8NT1cRAu5s5NMsuT6r0IZX4?=
 =?us-ascii?Q?awmExeXNUwyzZZ2hniNrVjPMB8Lr4CIQtp1drZfUr5mtnUOJ4hJMVs6Wae2D?=
 =?us-ascii?Q?UFg+fXFLFmW94jKTMNSeM1KZ5XwxB6lXwUKBuikJyhW0DruQs3e3FahMCTOs?=
 =?us-ascii?Q?h2Hp6Gy8773TbWIQwFLYGSUW0SzzhYDxe/zLDPXhMdyQraGAxhd9TQp20q7O?=
 =?us-ascii?Q?GOjQ3dKW+P+LmOed+L+BU2bjdtkl6UMR5geUXuN9ZmeUyvOuIvR0yzON8quQ?=
 =?us-ascii?Q?NQGrLYemSMHIa1CrvuFsiwB0aJl/U8VFRSpoWbDpEIuwXBRsFecUy+ASB46j?=
 =?us-ascii?Q?7/y6q+nOaCCu9oyYUlZGZz5hFMiwjMtU5eXuC16eUF7+j6g2H6GA4nQNqdiV?=
 =?us-ascii?Q?HiJP9POYQQ8i6AZkZ6bpMSxmG4ELi10Ipu64GBO1gs+vyofAmPbvb/ENXTAC?=
 =?us-ascii?Q?lWAQ/88AkpV4Zn0s93OTVYv5dEOIZcgzujsaEiDSTS5m+2XpiFcQGtyA8AoV?=
 =?us-ascii?Q?vmnmJ4YlUjgbpzJPIoFUXHXaCNqRNkIHLvwjgjfwnjAQYlxjiyEQCpaDO2uj?=
 =?us-ascii?Q?tX3fW6eiRKS0FP+Aw7U+uWV/HG7KT6j0Xwgu4afCpJxHzzBoiNwEQBPHvmQI?=
 =?us-ascii?Q?X95zrZFLybzVMhTAHXkfcc/enJd5dBx3mWp14r8GXzrLId6AW4EtLCNpMdAE?=
 =?us-ascii?Q?IGp/ShCQBZyzLY6Mjim5YYgjEq/Xb8G7XAYvvqIvEYDWhpba0x07kArDr5LZ?=
 =?us-ascii?Q?dcDpM9nU1CB1444p2fc9oeSv1dWQq7UTQgsanOtNF7ffGKYNG/UZVRKeZJtB?=
 =?us-ascii?Q?tUHd4M2aDdVz1fh0f6AFgtL87hEWL2Ngx6AOfg2IU0JJBPzv5NYUKuS1+LDA?=
 =?us-ascii?Q?WCu2G3QerJSXbOH4oiwfokmMpWFmdSe3cOq7PAZ/RdZAfRzV0yjcc8NCT+cX?=
 =?us-ascii?Q?zc+RDub2GMVlyUHIYWdjZFFxz7UgcrowsPAsL+SEERWyfCuJ+dopvFc7cuMW?=
 =?us-ascii?Q?yNdAFQ/lPrueHnK5nA97+v+o0RYEuMSenqDcx7z8+GYMV5pOtwBMynJ5RhBC?=
 =?us-ascii?Q?MzVzwueA1ZdbnuBmsIXmSaU75VrBdwN2Kcjq3OKcEB9129mjx6xL9DPcvg1h?=
 =?us-ascii?Q?VYDfrRmDVP6W6Qn2upCH8wL/SHtJYyxg2Wihch0Vl3R4bCWpHnBeg3NB1x07?=
 =?us-ascii?Q?72a4/6csbcTEBocLkzgTZVXRWt5qBZIqR8NLr6t/DGRxbs5vjQHHE67jT/IT?=
 =?us-ascii?Q?ToKEKuTOPFNBVG0i0kvx52M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 961d0892-5606-4860-0f9a-08db67479efe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 11:09:11.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRENp4dOpA46N63eXKjrVv4AsbSHv/wwlVWgsemYy5kMqyd1CmggMg4Rc67p5vNm/wREK6gxygDbtERlkapv/Uw4z16MjImsA5mboX2A45s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8239
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:56:41AM +0900, Yoshihiro Shimoda wrote:
> Since this driver used the "global rate limiter" feature of GWCA,
> the TX perfromance of each port was reduced when multiple ports
> transmitted frames simultaneously. To improve perfromance, remove
> the use of the "global rate limiter" feature and use "hardware pause"
> features of the following:
>  - "per priority pause" of GWCA
>  - "global pause" of COMA
> 
> Note that these features are not related to the ethernet PAUSE frame.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/renesas/rswitch.c | 36 ++++++++++----------------
>  drivers/net/ethernet/renesas/rswitch.h |  7 +++++
>  2 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index 7bb0a6d594a0..84f62c77eb8f 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -90,6 +90,11 @@ static int rswitch_bpool_config(struct rswitch_private *priv)
>  	return rswitch_reg_wait(priv->addr, CABPIRM, CABPIRM_BPR, CABPIRM_BPR);
>  }
>  
> +static void rswitch_coma_init(struct rswitch_private *priv)
> +{
> +	iowrite32(CABPPFLC_INIT_VALUE, priv->addr + CABPPFLC0);
> +}
> +
>  /* R-Switch-2 block (TOP) */
>  static void rswitch_top_init(struct rswitch_private *priv)
>  {
> @@ -156,24 +161,6 @@ static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
>  	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR);
>  }
>  
> -static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
> -{
> -	u32 gwgrlulc, gwgrlc;
> -
> -	switch (rate) {
> -	case 1000:
> -		gwgrlulc = 0x0000005f;
> -		gwgrlc = 0x00010260;
> -		break;
> -	default:
> -		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", __func__, rate);
> -		return;
> -	}
> -
> -	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
> -	iowrite32(gwgrlc, priv->addr + GWGRLC);
> -}
> -
>  static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 *dis, bool tx)
>  {
>  	u32 *mask = tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
> @@ -402,7 +389,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
>  	linkfix->die_dt = DT_LINKFIX;
>  	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
>  
> -	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DQT : 0) | GWDCC_EDE,
> +	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DCP(GWCA_IPV_NUM) | GWDCC_DQT : 0) | GWDCC_EDE,
>  		  priv->addr + GWDCC_OFFS(gq->index));
>  
>  	return 0;
> @@ -500,7 +487,8 @@ static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
>  	linkfix->die_dt = DT_LINKFIX;
>  	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
>  
> -	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DQT : 0) | GWDCC_ETS | GWDCC_EDE,
> +	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DCP(GWCA_IPV_NUM) | GWDCC_DQT : 0) |
> +		  GWDCC_ETS | GWDCC_EDE,
>  		  priv->addr + GWDCC_OFFS(gq->index));
>  
>  	return 0;
> @@ -649,7 +637,8 @@ static int rswitch_gwca_hw_init(struct rswitch_private *priv)
>  	iowrite32(lower_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC10);
>  	iowrite32(upper_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC00);
>  	iowrite32(GWCA_TS_IRQ_BIT, priv->addr + GWTSDCC0);
> -	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
> +
> +	iowrite32(GWTPC_PPPL(GWCA_IPV_NUM), priv->addr + GWTPC0);
>  
>  	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
>  		err = rswitch_rxdmac_init(priv, i);
> @@ -1502,7 +1491,8 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
>  	rswitch_desc_set_dptr(&desc->desc, dma_addr);
>  	desc->desc.info_ds = cpu_to_le16(skb->len);
>  
> -	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) | INFO1_FMT);
> +	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) |
> +				  INFO1_IPV(GWCA_IPV_NUM) | INFO1_FMT);
>  	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
>  		struct rswitch_gwca_ts_info *ts_info;
>  
> @@ -1772,6 +1762,8 @@ static int rswitch_init(struct rswitch_private *priv)
>  	if (err < 0)
>  		return err;
>  
> +	rswitch_coma_init(priv);
> +
>  	err = rswitch_gwca_linkfix_alloc(priv);
>  	if (err < 0)
>  		return -ENOMEM;
> diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
> index b3e0411b408e..bb9ed971a97c 100644
> --- a/drivers/net/ethernet/renesas/rswitch.h
> +++ b/drivers/net/ethernet/renesas/rswitch.h
> @@ -48,6 +48,7 @@
>  #define GWCA_NUM_IRQS		8
>  #define GWCA_INDEX		0
>  #define AGENT_INDEX_GWCA	3
> +#define GWCA_IPV_NUM		0
>  #define GWRO			RSWITCH_GWCA0_OFFSET
>  
>  #define GWCA_TS_IRQ_RESOURCE_NAME	"gwca0_rxts0"
> @@ -768,11 +769,14 @@ enum rswitch_gwca_mode {
>  #define GWARIRM_ARR		BIT(1)
>  
>  #define GWDCC_BALR		BIT(24)
> +#define GWDCC_DCP_MASK		GENMASK(18, 16)
> +#define GWDCC_DCP(prio)		FIELD_PREP(GWDCC_DCP_MASK, (prio))
>  #define GWDCC_DQT		BIT(11)
>  #define GWDCC_ETS		BIT(9)
>  #define GWDCC_EDE		BIT(8)
>  
>  #define GWTRC(queue)		(GWTRC0 + (queue) / 32 * 4)
> +#define GWTPC_PPPL(ipv)		BIT(ipv)
>  #define GWDCC_OFFS(queue)	(GWDCC0 + (queue) * 4)
>  
>  #define GWDIS(i)		(GWDIS0 + (i) * 0x10)
> @@ -789,6 +793,8 @@ enum rswitch_gwca_mode {
>  #define CABPIRM_BPIOG		BIT(0)
>  #define CABPIRM_BPR		BIT(1)
>  
> +#define CABPPFLC_INIT_VALUE	0x00800080
> +
>  /* MFWD */
>  #define FWPC0_LTHTA		BIT(0)
>  #define FWPC0_IP4UE		BIT(3)
> @@ -863,6 +869,7 @@ enum DIE_DT {
>  
>  /* For transmission */
>  #define INFO1_TSUN(val)		((u64)(val) << 8ULL)
> +#define INFO1_IPV(prio)		((u64)(prio) << 28ULL)
>  #define INFO1_CSD0(index)	((u64)(index) << 32ULL)
>  #define INFO1_CSD1(index)	((u64)(index) << 40ULL)
>  #define INFO1_DV(port_vector)	((u64)(port_vector) << 48ULL)
> -- 
> 2.25.1
> 

