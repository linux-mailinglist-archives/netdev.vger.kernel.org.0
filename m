Return-Path: <netdev+bounces-8590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CA1724AAC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A83281C20B45
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A54822E2A;
	Tue,  6 Jun 2023 17:54:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC822E22
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:54:47 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB44E47;
	Tue,  6 Jun 2023 10:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686074086; x=1717610086;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IYD/Dq1uKiMc9URke8oNfkDHDKI/MwRJhqZ3ugHHE5Y=;
  b=ZrkyM6DntWL8TIrTVrOC6k8Hf7nNhZnoDJoyTXWQE033/wJbr9r8DrKj
   ijhYK3o1y1yGi0OvC2Bgl4WR4dnwpHGTCJEp7vL6TPRPVCK1ICwcHW4cr
   S/G5yuNPDlghgVrOFlSu+AdbYSFOCvyYxg4fhgTFIUNNmaypeCi+cKnKO
   jBYH5epBlrwEzOHuiOrvIPG1ZPfli0wzXJyziaKxeNuynk0vSk+MROgw6
   6NQ86dI5oCCo471qWLSDBvesF+y73c6DS+cqZKSvRKEjoTA5FwCb2mu9K
   ISALG2e5KQV6RITeX0g+JPxzLOIuBANQRRvRnmHK50+sI9qXdUwDV5B3o
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="355612528"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355612528"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:54:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853534204"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="853534204"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 10:54:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:54:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:54:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFrh5ER/zS/3O47I5slBCfXRHeB6b+LlYejUUirg+Ga+aL5WtOJFEpNNC7/lfAXsdkxhh9Eo354BrWCPaYAraX8rUZhisjcTXLXDRCwXcgdc97uJ1Gis0OeRexjzJyq04WMwCrvrWOo/Ozmyaltnptu51aXG269tK3ermtWz2Zh9AZSlktbr5BUpqeTC2ypvIMmwHJwBBRjIUs3FH8jn0CFCLt6HiQlH4A2aRyrpIomNoO8YOPophD+hpwBvNiP5rygRNSNDor832a5v3hUui6CcXFu6SVx/IGd9heG/tT6ZXXQG3Xs6WWHIONws7EcSeieEQxgZkcGMAeph3eIQ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqfUSK4ZDyWxbwFnI6HM6sGVsllOb2DOtNKbFgPKbUE=;
 b=R1URTw9MpllxubEC1n7vzCRoOU1bmVyWtsu989KTZ6cmBcnGWUdoiOvEhozVTuljPrUa2FbTBepmD1cHQKkKOQRGLhpj/CkcdkJnT9jG6nqvMTX9IUYAmpBXXCsoO5fjSR/hM6FeoA5yKZzit0JqYBieFTc8fuQDaio+Cd9jAksPa+ptgeWmd3J40fM0l1+6b/WUPT/hzsFnqU/oNJwfgFO+oJiMeK8ANLbRtoAlR5DxJFo6tjyRnj2XDcCjCs3utC7tSXFJ86cO3SxPLLaNiFnQrxBclxo+5czfvEmkjP6QezvNCh0ruCYvrpyuzL9aYLm8wXdJmtuimUw4+1aKRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 17:54:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 17:54:38 +0000
Date: Tue, 6 Jun 2023 19:54:31 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC: <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: renesas: rswitch: Use hardware
 pause features
Message-ID: <ZH9y13KXF128Dgbf@boxer>
References: <20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com>
 <20230606085558.1708766-3-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230606085558.1708766-3-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: f27c9650-1da8-42ae-8e90-08db66b7186f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzIrVhr27kCJ12ag+8O7P27fTjkCxfUSd9iomISy1aPiz+OF1+TXU/1rpnEMMZ1BZz4ns/8AJrE8YAQ6ex5PFl3zr4YAAbJGRzWMz0UOiKM6yOaqpnKZx2RTo820XoFtqdj5IOih3ZL1KWvTB8xp7/R+qbyknUYLDLFwrW6hVBjS0rx+ht8HQLIMigcxy3THasjjwCF+nBoM1GSmpy5uaxZ3c4uo52vw81JYVXYvQEq0xAyf4PCtEZcdH2eexltIKw7P+x5eBZIb10IiF8ro7GXuPGQVmAMPXm5IWD+mI8tcrLIx+NOcaHmlmyIotasVolIi3DBrhvfnqma5FQw39auE2ZiFpBhgQsu2CIyteTxUE7A0bEVULCI9cxY6fOrPaX1nVt3Lm/17mNEgjgIzz0lNDQ1gvQxXRSlpYOD77dHTSqGdIN6oyz6B+KnHNRiOtvrO6Gav5coICx9puIDsDLMZ0MUfrBWUP2joNFPd6sSot1yuOMFQwUiTGVMHjEmngrQm0m9mDBdSYtZkqUnP2K837okwAvJd4L1txmGgy59TBwF7d2bnCnmztLeglrGb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199021)(41300700001)(316002)(44832011)(82960400001)(33716001)(5660300002)(66946007)(2906002)(66476007)(6916009)(4326008)(8936002)(8676002)(66556008)(478600001)(6666004)(6486002)(86362001)(186003)(38100700002)(9686003)(6506007)(26005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zejpKZP2YQXKOqeywLGla0Y87I8OqTIBIRAWDOFLlravRquNR/Pgf213FiYI?=
 =?us-ascii?Q?dE1gXWYpXIKu5AbNb92GgEMAE0p10CPO+orG+pjz8WAJ8+7ZiXKaKHXnUK6j?=
 =?us-ascii?Q?lCG7/DMoh2iQGFcRjnbFoNwzYJgKMSgIoZkGIhnLPvzTwSnooEqvWfsG+HQN?=
 =?us-ascii?Q?UxQLy78T3ENfcBUxhkX0Emd8iN1Z6V6KpdOWPRYLqSs5sMxj7FygzsWC/lWa?=
 =?us-ascii?Q?8ho7VIa7IMsu+2+w3cb83lMwI+P7MUvPLwNB16ItTb79B+B4vspyQTFIQ/Nq?=
 =?us-ascii?Q?HrrwveG2zMwvpJR4vXBgq/B4Wo3/ABja/jSMBrNFaMbmtZ6041NfK8KV1ay4?=
 =?us-ascii?Q?9Uvnlyz8n63RtMGvKys8TMsXwX2apKv7Gq9DCn6uPUMPC5UGGXGhqoLzWDFT?=
 =?us-ascii?Q?M6So6Lechp0KuX8LmQ085acEiJSYBvL+U3yiEcG5a9Qh/GAkN06EBbq6wT3r?=
 =?us-ascii?Q?TfFjro74QE9svOTs1UWQlVjD8HdjFSiWJA2H3YIBcIcSuyArpjRrDrWFR+5j?=
 =?us-ascii?Q?W5JM+5XWgMaQlIKSYdEBdkHnX5pJqlsZuTfgZSTE8d9K6flyohgsKgF2PyPy?=
 =?us-ascii?Q?Z1+sz4J9aJefpHUZ3Y+D1xmaACH0jI5vMbYBP2zcEbFULc0nGQ1NtGweMCAq?=
 =?us-ascii?Q?NfojERCAU6NOMpkJd02wOmjq3V2+tC9GOHWlHbxTA9kMxn8/FWlu7amLZzMj?=
 =?us-ascii?Q?z8650hWpqSXvAT+ScrmtQVxIuvNs4grzczpMmKqugRc2vY2OLF3sTMmj0CPo?=
 =?us-ascii?Q?qHjTd4IIbHNpUSk4mrSekxYyDxVll0eS43QWs5zjaXyhfSxVTK2dHsWldBZL?=
 =?us-ascii?Q?5obtscQBvD9Eek/E/OjgTwAMJ9oCTxFxtFc/gpI+y4+UQ4P1Ve2gKm608K5J?=
 =?us-ascii?Q?FwaIFfxW8FOZz225Tf4cvPgEPLpf8haK/WjbHPZ7Kn6CGnBKrIFzNiCVjZyk?=
 =?us-ascii?Q?ExGXXYvyAEbMZnUgWvHd4FeEzdaqPMhkPkd0xg3SVzUAeqadSt5Rz0TNGzU2?=
 =?us-ascii?Q?xAOBMeDui2hbXci2NDStDk2pP/G8i1PwxXo8HOB4uyIdiJZAsf3DsLMd/9GY?=
 =?us-ascii?Q?2xFxOoDg4+JPesGHzQxkWLHYhHhu+3Qk5nSTcN8X5fXDu0yYqMnrHytL5a90?=
 =?us-ascii?Q?UM1bxQBgkMJ/qFcYa3GHAxGsETwGPYBmQ3idfOz3kwF5GkpQoc742iOYkKs+?=
 =?us-ascii?Q?8+evHjPO7H/31ADoogdiAZD7vPFYxI5IIjq8rD7CivT1wSpCiTZASbsXbuSv?=
 =?us-ascii?Q?yjbXmN8bIFyr+I4Lyv3MKW6yCl7D8RjzBNc6wBfdlk5kLuXK3dLf6EXLGv8y?=
 =?us-ascii?Q?OJWUJ5NO241BBBwtwhWhrPsf2bPGv8ygENrA2QpmVZDfaF3R0i9GoWqq//19?=
 =?us-ascii?Q?jRqnPDloMvpyf2SBoz0XSB5tcWyuQkGmM+uYptN44SVG5N1w/+Vztw9irxTy?=
 =?us-ascii?Q?wlGXWLJS0gl+4D9QI73CEofHbltec30j0bLgSRXkITV5UIRaxSDXEh+vxjAV?=
 =?us-ascii?Q?DogaLwtvSDcHcqo2/M61HGVubGaZkkk70AUjH3lATywpZga3HDFUHxdYnOGZ?=
 =?us-ascii?Q?7DSf4GNUBJvE6fPUeBxRzF22IpOH59sAhpmKnfmo9wMH4KrE825qfPm4ACDP?=
 =?us-ascii?Q?RQk0jZJzyJdkx/0oDw3WKqo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f27c9650-1da8-42ae-8e90-08db66b7186f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:54:37.9224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5gHmUUiVRDmhy3Ddd/vE7U+YeakUrhxkO8mNhlaFUvCttwmSptcnhHEs7LvN1mRb1uofO/XPNkBwgR1jD2C0HDn2BFyab2bOTyDCOmnzmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:55:58PM +0900, Yoshihiro Shimoda wrote:
> Use "per priority pause" feature of GWCA and "global pause" feature of
> COMA instead of "global rate limiter" of GWCA. Otherwise TX performance
> will be low when we use multiple ports at the same time.

does it mean that global pause feature is completely useless?

> 
> Note that these features are not related to the ethernet PAUSE frame.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 36 ++++++++++----------------
>  drivers/net/ethernet/renesas/rswitch.h |  6 +++++
>  2 files changed, 20 insertions(+), 22 deletions(-)
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
> index b3e0411b408e..08dadd28001e 100644
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
> @@ -768,11 +769,13 @@ enum rswitch_gwca_mode {
>  #define GWARIRM_ARR		BIT(1)
>  
>  #define GWDCC_BALR		BIT(24)
> +#define GWDCC_DCP(prio)		(((prio) & 0x07) << 16)

I'd be glad to see defines for magic numbers above.

>  #define GWDCC_DQT		BIT(11)
>  #define GWDCC_ETS		BIT(9)
>  #define GWDCC_EDE		BIT(8)
>  
>  #define GWTRC(queue)		(GWTRC0 + (queue) / 32 * 4)
> +#define GWTPC_PPPL(ipv)		BIT(ipv)
>  #define GWDCC_OFFS(queue)	(GWDCC0 + (queue) * 4)
>  
>  #define GWDIS(i)		(GWDIS0 + (i) * 0x10)
> @@ -789,6 +792,8 @@ enum rswitch_gwca_mode {
>  #define CABPIRM_BPIOG		BIT(0)
>  #define CABPIRM_BPR		BIT(1)
>  
> +#define CABPPFLC_INIT_VALUE	0x00800080
> +
>  /* MFWD */
>  #define FWPC0_LTHTA		BIT(0)
>  #define FWPC0_IP4UE		BIT(3)
> @@ -863,6 +868,7 @@ enum DIE_DT {
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
> 

