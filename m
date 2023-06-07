Return-Path: <netdev+bounces-8808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E85DD725DBE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FAF6281295
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DC633C8C;
	Wed,  7 Jun 2023 11:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2E233C81
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:55:59 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875381BC7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686138952; x=1717674952;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z1/emCr5ff38vBZcyus8cVT8921THNNyEtuxtcnx9w0=;
  b=dhCmEuQi9+ZkCcCVzSWJoKJuHLehGkmwAiSMti0v27XeIgPH5EExK7kt
   gyO3QNru2UmIuTUjd3ezZUCcY5peGpArR3cUssQTOvmR6IqBaQw5VuQIT
   urU+onvVnot4TqwGeqHyRUm9wa+quGDGFhkChU7Au6FIn9z5EK5Y2w6SS
   junrMc9gSh2CZbCnPbNU3/ZbYhUZpkKHfAz88MABsw0zVrbw3zgEhpFvQ
   F79X3muzw20tQK4qzTRSShK0f5xAQyPBQmXLIrT1tYNyNOFGV/bb5JDnt
   viuy9zGZ4qW7nIvnne7Hv/YEavd/GEOEJFvhk7rCYf2Zp8TMM0DGlUgk/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="356975322"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="356975322"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:55:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="774565017"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="774565017"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jun 2023 04:55:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:55:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:55:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 04:55:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 04:55:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=US5khAnGPPwkOe3CK4/0c2VmD9ySI7zXVP6iOZ85IMGuwJKT91dffNz/3veojUD1sxhZ9FchafbZlj7e1OBoWSDdtPm1whzGA/IIv6JfLogo67kG1JseWCG7NzphEMGS+NYakwWqPLCXlrMkyBtKgjEqzUQSxywRyyML/vxXZ7CFNCoCKSH+0NLTK9bTSVHjlvAqNgjyW9Ls5ex/T7kF4hY5LZqTUnSXWQB9NJsxeUCMCjpRQgWYwd+z+nf1PVnewHtbjI9o49LtbYn3FnFIiicpc6GFDrsTqAiVlpPftn6ued8Kq1YX02tnxh2clw0uDrpyzt3IVJh7C+rd9yml4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBXHf13VElfq1BOc7NiP6XvCNAbkuFsjnzVfvxMzIdY=;
 b=NK0HNlU/JprA7A0AjoRzqfi2RFOtJDmHbbU+XgnmJP8eIEphVXcajz8nFGafJCjOC4jxThz5xOH5JCG2+cwbrAAhO5VNAQPsF4isOggKqShtPMx9NTMD02fvhRW5hyMpmF1SEhkkpoVUEiwEjlkzpc6MNmD0VJF3OeI96gJm5PQVX6Bbvw3g75qmHwocvV/cwU+d3stsNEUN615stqg3VBZ7AjOlFygt0DE/CpVHChsrGkX+iK8TanMiIxlKn0hvNDBGFsD1eSrmxDmgUjaxOb4fpwe3W2HBqi1AhI2oiXIUk13PMDz1EqKzlPiYB76pUv8ch2x+ycCU1g1JUy0tyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ1PR11MB6084.namprd11.prod.outlook.com (2603:10b6:a03:489::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 11:55:48 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 11:55:48 +0000
Date: Wed, 7 Jun 2023 13:55:41 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Feiyang Chen <chenfeiyang@loongson.cn>
CC: <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
	<joabreu@synopsys.com>, <maxime.chevallier@bootlin.com>,
	<netdev@vger.kernel.org>, <loongson-kernel@lists.loongnix.cn>,
	<chris.chenfeiyang@gmail.com>, Yanteng Si <siyanteng@loongson.cn>
Subject: Re: [PATCH] net: stmmac: Fix stmmac_mdio_unregister() build errors
Message-ID: <ZIBwPc95jooavl86@boxer>
References: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ1PR11MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: cae26779-81b2-4300-b688-08db674e221f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BT3/lSkNutboqIMqHa7YCLS5z4PkfEy9WMhzwzoiP8SEfxrC9mSl15NQKh+oVff3Nb5bXjtF2yiVRcIqqER7xOdZKg7wd9HlKsjE9rV3o+bT381h9yk6ImzDMafbIam2h/6GmDkYxFYFUDSEv3UE5stpbwyf86l7EqNGIONYCyVIk2sG/F/XXe2REkhPvqru6jDKBcbCAZYgW3+tIjr/ETLrAMVIbm4vYI9LADDvOydMwhpGzs9XmsdXY95L0HMxPauUEHQDxV4K7vBAUow8z9t2pIcAHsLr7VtsNvT3wdQmQvoLAuVFOtgcdmCZwx9gpCfgqLTR8mKZ2eBmAF61YUx1yHWSeCHx2UhOgsiuCu+YQTZKMiWcFkwMkaUDPlM0VDzR8jZdnDSvrTBqZ95TsWKeQCqPGs75AAxIa4GqjYmnO4c6v9SRQKytnqwfPZE9W79nuARgAKPacGsRtlPDalFtg1wyrsp0E762snmrrdXlUQDK3XTIkQ2zY1dFARde08opeIOBMfezqj0OrTHp8hAaWPwKnrU9uM2ll+B+A/drrRF69Owk/I3uvii9y9LI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(8936002)(33716001)(8676002)(44832011)(5660300002)(6666004)(66476007)(66556008)(6916009)(4326008)(38100700002)(66946007)(316002)(6486002)(82960400001)(41300700001)(86362001)(478600001)(186003)(26005)(6512007)(6506007)(9686003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gat1L9LKs//dLHcV+LiyIcfx4LPR917BfBMsIU1fNrUpWed/iYXSlIdOPyr7?=
 =?us-ascii?Q?+kNJx/hrdohZTmlk8dtoDyNvmLAv+U7w8Z9In66Q0IHODOPqzGpXx4k+9JD8?=
 =?us-ascii?Q?dy0NZ9vsm34c4TXhthmbjb7OdM3aXeXBY8/F7PjL0rBdr+9ti360QnjvEOhJ?=
 =?us-ascii?Q?XCxeEziyPliYDMGsKbpkNSq4PuP/aNzBdIahAiV6eekM1AiVzTDJPWU40j0E?=
 =?us-ascii?Q?TE8lSJDQ9N6VhHPNhIYg8U5yQCBks6PxS7TtCS4wrnzbqR96AKf3o4m1c/co?=
 =?us-ascii?Q?nz/pu9MK02cmohpv/SwTqdBjylgNMv/BjVr1IVCH+/TihBw60RezfU+CBMEp?=
 =?us-ascii?Q?EEEw3Q6eQb5JIUCZ2WTm3Ab6hRvdLakSmPdcP83Lau5zA+0Z/P/G6Co0Xuj6?=
 =?us-ascii?Q?eLiRjwoU1F8TFKP1ceod6FFartr10krKcZbpn/evoUL2TXG5VN5fk+u4MxNJ?=
 =?us-ascii?Q?Rv1Mh/dgEBdNIOc7Z8ahOiEpfycclAvLroAN/n1k6NiIn8AS0u30YcEMJVfW?=
 =?us-ascii?Q?NqoDJ0oC223vFP4lNGI5BTWM7m7oZtrzjOfqZK+Tn1i+R+0CucE4kyJWD0u2?=
 =?us-ascii?Q?6LzhoHiLKhRbfSCk6b8csEbwM4+XT7Ap7Aufrlp+pfsqu5rAYFjndyr4I+bO?=
 =?us-ascii?Q?OGhPoJ2k4WkvLWDZOQ7RAcQ4sbwgWsd8hQQaMfh5Q3UsgxkhZXaT45qUQQDX?=
 =?us-ascii?Q?BdIrasn5WveZaYlxWG5fpAtkYNBxXvv6/sHZWZ3U1imAPsimE/GMpiMJL7dl?=
 =?us-ascii?Q?bAvJSYr1LagSacWOWDVfESLCDWM4AOx2v4dg+m1dEa1ZRvazbB8heOWxSv7E?=
 =?us-ascii?Q?uJ4SRDGxJgtVnHwficqweVBqRPxoOZ8wqA5TnmD9nj4b6vLpMyu65MBBDaso?=
 =?us-ascii?Q?7b7dpk6oFEuza6EJLRjV05zriUXQ4k33P3j2qeo/1WK/8S8LA7TQ2pfHhBZ5?=
 =?us-ascii?Q?sQcEdvPKQ5tiVGXikeOke3w1K8iPg0J5J8+t1QrXRXVbAER04RBfTq5ASbTw?=
 =?us-ascii?Q?fB2z1+SlJwLjj2z6Mc29XnmL7mJYJhtl0TyJdJ13Kvf2WiEDkkT+jAQQ1e+Y?=
 =?us-ascii?Q?wY3OKvn/+FEefNw/95Pyq8fpFFEJHSa89Ksmla5VpfwItxOi9KXPoNBR1cYd?=
 =?us-ascii?Q?KmrvFPpc1gK5Mt/dYXYh1o74LHMJvICoC83fhUGgVx5FVzxdv6+shWYtIDl1?=
 =?us-ascii?Q?ZcraiDf+pl7SEJI6m3Fcy6s9RBYwM7C41w7WaSVCGEtjTJh30Ssaa5ewpjlX?=
 =?us-ascii?Q?5Cx/pWVos7fhG79aACspI+7Mtzv5y3BNLSpWJ0evQojRBxw6Njb142JmXuDJ?=
 =?us-ascii?Q?M1yjnWqxe5WomNzlGWFvmiJ0B3spbG8Sr/ChQvIsT6h6xfq60irSq/GMIEER?=
 =?us-ascii?Q?V9rUGXH3avK/Rt+GmWDIwsm17icyF9KJQcLHGQvgQ737Y1dnKWiRDkRiMBfF?=
 =?us-ascii?Q?Y08VlvzzUBhxLZwsFCMK5QQdOb7w4WKSyec3VEsMZ+IjDSIMJUKf8Da7U0kY?=
 =?us-ascii?Q?7MD0g0A+/zMPWZwiR1SwD/RIN72qd/z66WXC1QcYoAv207rHx6wbQ6CYmOnQ?=
 =?us-ascii?Q?RYhX7PkQUH9gZlrqwUsyfpxBs9LG1zw2SkDY/Mtx1QDUWC1QHHebVa4yk4uS?=
 =?us-ascii?Q?sO5WZwQnlNfYmAobHrkQo3U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cae26779-81b2-4300-b688-08db674e221f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 11:55:48.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9+QNLz2gEN1JsSx63WT7HkdTj+8iUBTx6pWoC4peQxz0Bfdv89CNiF+y79tAMB2AVpTCWNTF+hrANlu7OdNmsR8uYSr+eVQthONGGXxG58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6084
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 05:34:40PM +0800, Feiyang Chen wrote:
> When CONFIG_PCS_LYNX is not set, lynx_pcs_destroy() will not be
> exported. Add #ifdef CONFIG_PCS_LYNX around that code to avoid
> build errors like these:
> 
> ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> stmmac_mdio.c:(.text+0x1440): undefined reference to `lynx_pcs_destroy'
> 
> Reported-by: Yanteng Si <siyanteng@loongson.cn>
> Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
> Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index c784a6731f08..c1a23846a01c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -665,8 +665,10 @@ int stmmac_mdio_unregister(struct net_device *ndev)
>  	if (priv->hw->xpcs)
>  		xpcs_destroy(priv->hw->xpcs);
>  
> +#ifdef CONFIG_PCS_LYNX

wouldn't it be better to provide a stub of lynx_pcs_destroy() for
!CONFIG_PCS_LYNX ? otherwise all of the users will have to surrounded with
this ifdef.

>  	if (priv->hw->lynx_pcs)
>  		lynx_pcs_destroy(priv->hw->lynx_pcs);
> +#endif
>  
>  	mdiobus_unregister(priv->mii);
>  	priv->mii->priv = NULL;
> -- 
> 2.39.3
> 
> 

