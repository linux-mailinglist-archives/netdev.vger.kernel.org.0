Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E350638D0C
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKYPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKYPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:07:32 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB18193E0;
        Fri, 25 Nov 2022 07:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388846; x=1700924846;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HDaq+DmLj+TLoos0/GpLIXsStzsgz85wgrL+CB8X7NE=;
  b=HN44FGFhc31gdaowzGsHkO0SepCB0gv2atWvl1ySMgYPjV0ig/imuOfs
   s+Mpyd2VCbZrbVLJ3+fmceoLyEARkhJbZV37YZMge6ArHWmiqz/BsWC3t
   pQ2C0c59DsVR/gRQGdh4P9i4LmS33bm1tysh4YDNbxs0w1GtRAECeh3dR
   jryqfvviI72pYZ/+iilBUkhur/vyWf+hCkqvw2VOb2HBNrtZdFBz08iKd
   FzIISmk8P5mv/zc+p1WXZ8w23poO6DuZQA4+WH5IS6D99SZrYycQmtYVr
   TT7Q740R0O8oKrw99mWUFzCCA/5NeDyXkpJG/fxo5a3M8PMoiFtWdJ06K
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294200209"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294200209"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:07:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="748614798"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="748614798"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 25 Nov 2022 07:05:28 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 07:05:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 07:05:27 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:21:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emqidH1LcKa1pn5NG3RgKxDIHVK5ORbOSSa2l2+fmMAnoeq/ezlUDS+vTRI2izGOCIRutjZYGQ3ZQjh12Cbbl25VFu1iO1aDZORBQKKAPAhjdLC5B036wQEcOyLEokygWI1az2awqbvddthtHi6exriO6P6PQRBocwG0hmtd/eswYvgcsCVjSERX1aDgEdhcOsF3/lzNvJxMmX3ojsTXaFQKdfD6Cv+XBr7KdKSzdkTFiyb97kxE34QhigSCz97ra1cDNEGKkVA9r6XXzUsxWeePdCPOec0/eRpRyVokMm9bLd9W5JH8RyDIHJafaXEGEGI77bK6oMg+2YB+97KkWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2FcTYFP9QiIJ4zo4+NfS56EwauGcNeQIF4MK1i85Bc=;
 b=ef6FW1HT/tKyRonxAIVGVcRiisXKu76pLiy4uT8qGvhTPUMG9DXLINQ8lmfieiHysxkX1uCezsDIOmHECjInROE480tX5X25d/5CEefIzukfI3C4XpbLZmeka7a4HQFryzYx5Rc1SVvTal7RkOZS5agcuYs8rfvgqtoC/u6DtCNdaQ9+4aSYWUkVaBuZEgNX2FOUruxeSRmcHOGm+tTdB/d4B296KLx9+vHoBq/7721QY9+cNdCHCmuW41GKtwxN1+n0zmcOYbVS1nOJyRa0VEH0oVTg94pdpdgPc7Ig7Hlipk4KuEsqowkzPCJjTExdSu7hQVhIHuK0BGUhpHRiNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB4936.namprd11.prod.outlook.com (2603:10b6:510:42::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 13:21:23 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 13:21:23 +0000
Date:   Fri, 25 Nov 2022 14:21:17 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Roger Quadros <rogerq@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 5/6] net: ethernet: ti: am65-cpsw: retain
 PORT_VLAN_REG after suspend/resume
Message-ID: <Y4DBTbVxUpbJ5sEl@boxer>
References: <20221123124835.18937-1-rogerq@kernel.org>
 <20221123124835.18937-6-rogerq@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221123124835.18937-6-rogerq@kernel.org>
X-ClientProxiedBy: FR3P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::21) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd679a0-3c00-4dcb-9d77-08dacee7f2e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYNHi8raazPxXrwNShp8MscW5pQS9OoGOEMA32iNwl0nDQ03APgg+JbM7CtUPayczMhiYl1Bn9xytf7fn1t+nL4vmdwbl6tqsnzR07Pg5B3v2RRS3QLCvodUqBlSz2ox4HOUWKEcKKesYeRq6VTJPugXNWCihICHYwF3Y5JPkadedXqD/LzCI54O/KIJzLR+CYQYmcZven4+p5BNbTqbszJQuPWBF7UEkLMX7HIvTrqoaWwk7dUBaFmT1kkdZbIVn6lkEkiIh4bAWmTDZLTcZkgrWjgAVeEtZWJ35JX1A9guyZA+E0R/FZC/Sv6qXDMzFjocC3wySaDw2a8OcA1xEq2dYk6W3GDZcYgY08W3qW1PHdQhjEL4tAAnFu8Tw+7oNd/kXZzFDh255ZhfNeyOPUmKJUQxSVLgfqnLdyRwGAZVdm92UDuNk/fVi6I5Bf9f21qyKOKgtEryEpbRHEp37n+RwyPzXnfyEqiyg1nB/bY3l5gHBVAUoarYc9DEfeNJIRB9sbj+dzrBw2WS8UxhmxUl6/1w3b/qYw9VBHE2Y2mHIGV00/CFnS1z6xS4BWCh1dZmP3Z1aKtBywfkysV1f0TSROzPAk/MthYPMH1jOyFSjAJIHwQZpcvQ0k4+EcTb0lKd2FzRaqEcPaGoHPBU7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(8676002)(15650500001)(86362001)(83380400001)(6916009)(316002)(2906002)(5660300002)(44832011)(4326008)(38100700002)(82960400001)(41300700001)(8936002)(186003)(6666004)(478600001)(6486002)(33716001)(6512007)(26005)(9686003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ls2NeYrEhkMofNjwin56dMF8jsZ+pPb0lLNqt/Mc5w7Wg7Lr2cZsCrZlYVh2?=
 =?us-ascii?Q?ytxm6K1w4mZeaDQZuEvg3oAeONsj6V2Yr1fcOABWlFKTU8cOSTiZb8ZEp0l7?=
 =?us-ascii?Q?mHKAaogOkLKIeXkgZJfbAjLTxoEkILEi1nPC5AeSl1mExZdRloEQKa6B/cbb?=
 =?us-ascii?Q?OFGhMFvGlNKcoPAwRgi7YSFnZMf2yS46kZ+Wk+v6OZ8ZRgTXOVObTiJwfGsW?=
 =?us-ascii?Q?c+JxROciw5zSpeT669FPhqtDt2FWNA8JunyhqLYMYycpPVS7O70xoWe08Tuo?=
 =?us-ascii?Q?1ua4kaBiv8fOGD/LFeRdLFZGZv4CtM18PmLsBsBLlIhmbCXFBz54l7FIXQ7P?=
 =?us-ascii?Q?kZW/g6glZKCpmhHXHC8xGXHChpH//MykmZ7f/s+IcnDihNYQVY860l6vs2ha?=
 =?us-ascii?Q?i6V6eTPp7ezZPOYxWPQASj4pL/hXJm4C1xTTqurFsysYSJLDpbjXBHBBXwYm?=
 =?us-ascii?Q?OiI70cQhIv0S2Eh2beaeMbJImzj6zcidSB5T/rORfQa4lIpK1S75ZBQAAEZz?=
 =?us-ascii?Q?mD2LqcGzIra1HFlc7Ncuk9G7eV39lwgEzy6dwgURUrp5d+jBMiltKMfi2lbA?=
 =?us-ascii?Q?cv/Q0+584RD4F9mlQKddP9MWn3j5ZWq8GMvRMEeG4utoMVWPf9mOT6LIaMxK?=
 =?us-ascii?Q?dw36N5iDsUBKfFoxfxyVv+PduyTvzinLzpk79mKBA0bm3kH7//7Yj11qMzUR?=
 =?us-ascii?Q?0790BC8PNgQcCVi8Vn/RpC5Oxkb0n9B5Jv2f0DpzUBKS+67+qSSZRfXk3Mu4?=
 =?us-ascii?Q?YfH91yyGUCqTkSEmFbbaPN6I8qcvSGlmwgXUucR/HcSeACKWURE2jo46EBX2?=
 =?us-ascii?Q?7q5Q3yx5qS7++6Clv3b66hgI21AZSa6/5a4bAsgtpQlSpRfasqE9IGvY4wdQ?=
 =?us-ascii?Q?qQfEp9vskYKwx4hWwNLM3Fui1NkqKvIHfoyf/hB1dPgbG7JpiKVGQtZg+US9?=
 =?us-ascii?Q?4qZgSqwNDjgzhkrlWIQvjoC3T3Oie+nT3fc+tzlfnSuKeTg1uaMmWYAGLqHl?=
 =?us-ascii?Q?IKuYQH6z/GzIQX+lxalILRzrBpRQg/OtEORVIgaeLCUTZSP6dfnSb1KOMw8u?=
 =?us-ascii?Q?6Qrx/5TzT8/FfPd0wHm+Zf5OF2tOyyA19LEQ3yTqOwFKv40CmZWnXscChlt1?=
 =?us-ascii?Q?w06Z5daIPOChgprihVDIBT+82PN54eXh3A01hApTrXMu7TEnU0p1s2wqWjQr?=
 =?us-ascii?Q?pzjo0bm8e1SqZQJx0IgCPJ5N7jmiBFJJf7pPlTu+6uNfuYoZmmHXZKRDpi8n?=
 =?us-ascii?Q?xpANUD7rDdbfsPr935TzF68x+GhresmmpiR8HZmkzbwFXWOhZYVaaH7w9WJs?=
 =?us-ascii?Q?++DCRoSn//bGNFzc7hSBm2jgfAsqbHAZcmqxlxKMiMD1d3dyrt4aGqBqm1m5?=
 =?us-ascii?Q?+jKhIiT+noklMZM8mHmu+Ap2DcFSQQdedyPVmPN8UkOpBWY6YbIBfHlLH5c5?=
 =?us-ascii?Q?JqXSqEDGraoYJm8nFuU/xH6mKd3cvPqQyHGR3Js+2GEEWhlOZQvJjAdTTXA6?=
 =?us-ascii?Q?Gc+AgXQ/sSboObJxJzKw/a79OnrQ27E0TbnVYV6D62KYk9+83UJIY71pdqea?=
 =?us-ascii?Q?n9Dm66ADJKofHVQesJvHt/UwR+VZdNEbIrO6AraibEJELv/4uLzTVl9Rm7x9?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd679a0-3c00-4dcb-9d77-08dacee7f2e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:21:23.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1yf4DHJCnkJOOA6ddQmjTWsQKy8aDjUXY80/JINHOWgrHThCKrd1xLOmkw5Lb1hfYqxPM/WS1c5O8C/2T6nournkCvpjNe/r02s5giLIgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4936
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:48:34PM +0200, Roger Quadros wrote:
> During suspend resume the context of PORT_VLAN_REG is lost so
> save it during suspend and restore it during resume for
> host port and slave ports.
> 
> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
>  drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 0b59088e3728..f5357afde527 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2875,7 +2875,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
>  	struct am65_cpsw_port *port;
>  	struct net_device *ndev;
>  	int i, ret;
> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);

Nit: I see that retrieving host pointer depends on getting the common
pointer first from dev_get_drvdata(dev) so pure RCT is not possible to
maintain here but nonetheless I would move this line just below the common
pointer:

	struct am65_cpsw_common *common = dev_get_drvdata(dev);
	struct am65_cpsw_host *host = am65_common_get_host(common);
	struct am65_cpsw_port *port;
	struct net_device *ndev;
	int i, ret;

Also I think plain 'host' for variable name is just fine, no need for _p
suffix to indicate it is a pointer. in that case you should go with
common_p etc.

>  
> +	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>  	for (i = 0; i < common->port_num; i++) {
>  		port = &common->ports[i];
>  		ndev = port->ndev;
> @@ -2883,6 +2885,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
>  		if (!ndev)
>  			continue;
>  
> +		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>  		netif_device_detach(ndev);
>  		if (netif_running(ndev)) {
>  			rtnl_lock();
> @@ -2909,6 +2912,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
>  	struct am65_cpsw_port *port;
>  	struct net_device *ndev;
>  	int i, ret;
> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);
>  
>  	ret = am65_cpsw_nuss_init_tx_chns(common);
>  	if (ret)
> @@ -2941,8 +2945,11 @@ static int am65_cpsw_nuss_resume(struct device *dev)
>  		}
>  
>  		netif_device_attach(ndev);
> +		writel(port->vid_context, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>  	}
>  
> +	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
> +
>  	return 0;
>  }
>  #endif /* CONFIG_PM_SLEEP */
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> index 2c9850fdfcb6..e95cc37a7286 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> @@ -55,12 +55,16 @@ struct am65_cpsw_port {
>  	bool				rx_ts_enabled;
>  	struct am65_cpsw_qos		qos;
>  	struct devlink_port		devlink_port;
> +	/* Only for suspend resume context */
> +	u32				vid_context;
>  };
>  
>  struct am65_cpsw_host {
>  	struct am65_cpsw_common		*common;
>  	void __iomem			*port_base;
>  	void __iomem			*stat_base;
> +	/* Only for suspend resume context */
> +	u32				vid_context;
>  };
>  
>  struct am65_cpsw_tx_chn {
> -- 
> 2.17.1
> 
