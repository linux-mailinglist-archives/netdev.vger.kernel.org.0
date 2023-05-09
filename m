Return-Path: <netdev+bounces-1097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B7DD6FC2B4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AB171C20AD8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5648E8C07;
	Tue,  9 May 2023 09:23:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8FF3FFE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:23:40 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2AC10E50
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683624196; x=1715160196;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b/pMi7eVKjNk7D+EXIiQrSnx9NrGfJklwUfX2OqfpPA=;
  b=U4Sjhf6q3X9Bv+aSl8U4L0fepTU1ExCom+9ZWyVLoiJgO7DdypF6mOoP
   MV+eaYnOEp4ic8qDCCYElARK8lzKjCdd/smIPUSQmHh4TiluMgTDnl607
   gANLFRJsxvv8c0MnTl0GHQv/Z2RRXdgF2AUAAoQSYZIj2ITTPKIs4jCxI
   g1F4ia6HKhf7B+ru8suCLqTI30ADJgA3ir9IdMysopW6DFf6QG6bvrYl2
   dCQjtc+WT9DUTiHniiGlPy0qb9vBFDtaG6dbqBpaEJ7DuhJHJIx+LQk0a
   49ATtDL4R/cQgsFiB175eKFoY3GuNWg1qsZielXCLiKobs4Yn8+gX6exX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="329486431"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="329486431"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 02:23:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="768407425"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="768407425"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 May 2023 02:22:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 02:22:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 02:22:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 02:22:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR3es6dg1T4yIUtCKzUJDx+3/VYFAeaXunjAqEcq+L8/f5MfRQNNz0tRVWkqooi76OmuWzgo7czpc1UYux56VF6HV86LwfqkckuWEMkycSsaNHfWLe4+UDG+Nk6WZHDzSvidA+zalHCxI7PKyONOsQZTjEm56n3CUkICTwOEJ77cnCliJZpPVuCe+XVmodhEBMM8labKnykhadXpUMfI6LjnpZuYC2X3eSiehWBHk+vk8NJiM+K0Jy+6DGenhg9UbRzd30boMOPQO1Tdw+6vE/Hxbi8HuH2qceqtbi6O/631L80J2FIJp+iq28GsmHNGmBclPYoG3ewp/ykAyGYDmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05n3fvOc0GsNC+NVynZtWUwLopFI+rI4wv6mrKoR04w=;
 b=VjuFRproNf3qTQM0yflFs+A6ySgQTqCrLBtW5hnma/IQly3NEzRL9PKpnvBPOmplwwfxT1jqateQJlM6gjqnT8tjdWiCkG/ivD1puFcqfOVqThzrrW7AikpnJc4m8M3da75JxAjmV6ZMsQkTe8qaCtlX02vIg62CHT1vrkWsPLvIkgm81Aifbi6dFBAuTPlSfrWJhzu1RBox0PpC0LyFPxahvOSGIcChNu8Oti1fxLujo3uVmXslrJzNt+IvC2zuZJKUKLNaEZcNqioOjlaDXXJ/ajegHJC7Zm06KK3jOAfukWxcjunuHZDxDk1xw2acrxK6xK3ThWj6N3Zvyzz8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by DS0PR11MB7288.namprd11.prod.outlook.com (2603:10b6:8:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 09:22:53 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 09:22:53 +0000
Date: Tue, 9 May 2023 11:22:44 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Lukas Wunner <lukas@wunner.de>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, Philipp Rosenberger
	<p.rosenberger@kunbus.com>, Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <ZFoQ5EN+XPXjzQ2e@nimitz>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
X-ClientProxiedBy: LO6P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::10) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|DS0PR11MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: a25a789e-da68-4e22-7166-08db506ef71f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mnq/ALUbiJTmKlxLQUoPuHxHMEC0qtEeoJUhqE8fecpc0rmJvx4GLTI5tqSmW/gz4yO4FkGOC+ruW0q0+yzRthAXI56yh9UlF0AjcCxznCRBQ2ciTkZEGfD28QU/ybYMgMGUkZrwkVAzvIXDS+WehSrk3ei0cUNFy1WbC3fH1Rh1/1foInM8EJYA1pkKUBzineUNDXI+so2+spPcRqqr9l9ZBLaMZuwnGkrA4ScVIcysHySbse0UgoCvy6T+MJxcQ/forTDOSjMei6V98fnCdlAtkIJYnP1wdZ5rKk/GCg8h4iautfkXiuBDr7QGFd1k5PlhMCKUsVo5avDQITJTUPFldP/lq1p24yvqFRLXKV2A1pVymW8vtZuCX7+9sTvX5lB4nB+KBNcGGs6SKfXWB8nYYrMZg8U4Ub9jDzhVMJQYHJjgpKlCovMjyH+ptVQprD2XQt8RImijmjc2dWxX7v6OXp8D6Ltk0FyfJDyDx8mqeBIwAGBvJy8xTA+Umck8KDt1bg0Ouz1cEtI7mL3i537RGjr9WBTJlvyT9gjYKeUUQFnXU0ZstzJ9459Jb0Vzl1LNyOx7c3dcq8asEqB+9GVxU2KlOuke3sJhlZBrvBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(316002)(6666004)(6486002)(54906003)(478600001)(86362001)(41300700001)(66556008)(66476007)(4326008)(6916009)(66946007)(83380400001)(26005)(6512007)(9686003)(186003)(6506007)(38100700002)(2906002)(33716001)(44832011)(8936002)(8676002)(5660300002)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpPCtMRzrUgAnX138yMz3TMDDn7tipX8uTwrA0u4NzMlSlq8TXoTI5SsfTTs?=
 =?us-ascii?Q?/n2hanHebkkt7vZJJ6mwVKVsOysEHMUhuXjjsulZ1uA2gvEGjRzkjAE6An2m?=
 =?us-ascii?Q?O55DW01ckUGRn5lu1UT3EZRFfMIjGgOQOezI7zahkk2N1R0p0fmP4O7bM5cR?=
 =?us-ascii?Q?VStmABGVTZDyDVM8GY7HtTqMzPUVlcvfOGbxzAf+15ZyoBYQFNdRpQHZluaj?=
 =?us-ascii?Q?+EKj9FGkPcvTBuGu/AjHo0tWpDjsWDPrIA1IjLqK2exCPUZK1Sgq6Y26MFI/?=
 =?us-ascii?Q?VKoy5BP8MUYMlTvT5r0UCBD5rM2VHlgqcFPRhevzQ7+LU/J9es53Z1LIJP67?=
 =?us-ascii?Q?Aeiv6YexADyl7/dz7u8sm6fl13vikn9ahSruz6y9lCYxogtY3loZ7AKAVtxZ?=
 =?us-ascii?Q?YXWRkXgaOZRGmN7M9jZjVIlWdmmj5xtEG7HaWlYxbZFZwyviW8no0C+57DbY?=
 =?us-ascii?Q?M3VkQvpX8lH+0EEZBm1sw2CQ2tJlR2ShgappnIpnagkAvUHC6mSr6g+RemTJ?=
 =?us-ascii?Q?5SKR3YR0ZP0sBGPyr3iaJPZPH5+QZWPqkzUVLlZbc/tVPrWBr2Kx64NAEQr+?=
 =?us-ascii?Q?jjgNCiVK/mib6i3azILZZrlpKWCjFz/npetNyumd8mww95/1C231tU+N1UG4?=
 =?us-ascii?Q?yr65t0qf5xmxoj/8yqfxJGuorqiHWqqMz6fQQa2Jg6P1MKl7/0EDoBCTdE9H?=
 =?us-ascii?Q?6456jHmWb6e5lG8pYf8BKFHu3ueGRmAXtk76SWVA3zCdf22FXP81vCws/fXw?=
 =?us-ascii?Q?p6E++N3TR2kTn57YHC87CC1IaAYlBZg7TQmAzc6lksEk1jF8B4z9gp+ZIvL/?=
 =?us-ascii?Q?2iNQQ00MGZsm+dgbWkK25BGZrPDRJZgSMA8r3/O6fA7Y2gZN8GXs2ESI7bfu?=
 =?us-ascii?Q?AyNyho9Cq+WTm8RMOBI4a5G9ywR/yuOwMmctEimSqwBhvdHIQmtmwPQOvsDj?=
 =?us-ascii?Q?es6f1z2Vgc191urbbB6UosgJupABxvMC+01E0+OhJp/Te02iEt2DAgLuBrHa?=
 =?us-ascii?Q?D1fFKAYsT5xd0rvs5rxBFzAgPr8sXeFWMbBm+dtSP0YThNA/OqjSn7gnlID7?=
 =?us-ascii?Q?akxTasp75butq4qyLGVT97THca3SfVGI2nfQO38ZPMDQyygYKJ6FY3GhINlz?=
 =?us-ascii?Q?PHMbwyIQMTvOMX+WtpLbzQWrz/w/wYxeisvTo8WM/rVF31PLcm0voZwQC4k6?=
 =?us-ascii?Q?M43QVSsIaDnXF4gt+i35ZOiyC/VqA9HwujeuxqUrRE/RB81Dwo/NcyDWKlUk?=
 =?us-ascii?Q?27KdiqhuJyU1qm+4k3hCSN6sHY6geMrtit9rOkpvOcfeTuA4XD+ggnZ0mDVa?=
 =?us-ascii?Q?9cJHYqWSNeKY1x+OFHtqd6yFbxInkH00wvkWm/REizTsvMyz+pbNwi6ZAKyX?=
 =?us-ascii?Q?sv3MFCbgWzfADgDoHU1mfVw1IyEymfA2GYCSqDKa7r5d83WCHBkwkMtjSKB/?=
 =?us-ascii?Q?B26vMvYLC9uk4o6eHfMjfydPyuVLe2b69vFBeJQEbDvE9Vzdg5/EsTfPjcE6?=
 =?us-ascii?Q?xMFfLhfp8dTuV6EeFG3RHb/pPKvzOKyno7D22oL9qwdM5tnasQO/tYxI25W+?=
 =?us-ascii?Q?uaZeHmYBQcXQiqqSIMjix8BQ5fSB8L61xz/entGRQfaFdgsMcMb81qdfDEyT?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a25a789e-da68-4e22-7166-08db506ef71f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 09:22:53.0216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrYhzwadRiJ+J/rz0mhnoOBFyDPmu/qxtKHue5pTuNtY/7cW1P6AJvy4NECJo49n/d4MFDdB+FIj6kfYZt3ti2C6vHe06hOU3OuomwZnYF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7288
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 06:28:56AM +0200, Lukas Wunner wrote:
> From: Philipp Rosenberger <p.rosenberger@kunbus.com>
> 
> The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
> the interrupt handler because accesses to the SPI bus may sleep.
> 
> On PREEMPT_RT (which forces interrupt handling into threads) this
> old-fashioned approach unnecessarily increases latency because an
> interrupt results in first waking the interrupt thread, then scheduling
> the work item.  So, a double indirection to handle an interrupt.
> 
> Avoid by converting the driver to modern threaded interrupt handling.
> 
> Signed-off-by: Philipp Rosenberger <p.rosenberger@kunbus.com>
> Signed-off-by: Zhi Han <hanzhi09@gmail.com>
> [lukas: rewrite commit message, linewrap request_threaded_irq() call]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Other than commit message commented by Leon, LGTM.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/microchip/enc28j60.c | 28 +++++------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
> index 176efbeae127..d6c9491537e4 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -58,7 +58,6 @@ struct enc28j60_net {
>  	struct mutex lock;
>  	struct sk_buff *tx_skb;
>  	struct work_struct tx_work;
> -	struct work_struct irq_work;
>  	struct work_struct setrx_work;
>  	struct work_struct restart_work;
>  	u8 bank;		/* current register bank selected */
> @@ -1118,10 +1117,9 @@ static int enc28j60_rx_interrupt(struct net_device *ndev)
>  	return ret;
>  }
>  
> -static void enc28j60_irq_work_handler(struct work_struct *work)
> +static irqreturn_t enc28j60_irq(int irq, void *dev_id)
>  {
> -	struct enc28j60_net *priv =
> -		container_of(work, struct enc28j60_net, irq_work);
> +	struct enc28j60_net *priv = dev_id;
>  	struct net_device *ndev = priv->netdev;
>  	int intflags, loop;
>  
> @@ -1225,6 +1223,8 @@ static void enc28j60_irq_work_handler(struct work_struct *work)
>  
>  	/* re-enable interrupts */
>  	locked_reg_bfset(priv, EIE, EIE_INTIE);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  /*
> @@ -1309,22 +1309,6 @@ static void enc28j60_tx_work_handler(struct work_struct *work)
>  	enc28j60_hw_tx(priv);
>  }
>  
> -static irqreturn_t enc28j60_irq(int irq, void *dev_id)
> -{
> -	struct enc28j60_net *priv = dev_id;
> -
> -	/*
> -	 * Can't do anything in interrupt context because we need to
> -	 * block (spi_sync() is blocking) so fire of the interrupt
> -	 * handling workqueue.
> -	 * Remember that we access enc28j60 registers through SPI bus
> -	 * via spi_sync() call.
> -	 */
> -	schedule_work(&priv->irq_work);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static void enc28j60_tx_timeout(struct net_device *ndev, unsigned int txqueue)
>  {
>  	struct enc28j60_net *priv = netdev_priv(ndev);
> @@ -1559,7 +1543,6 @@ static int enc28j60_probe(struct spi_device *spi)
>  	mutex_init(&priv->lock);
>  	INIT_WORK(&priv->tx_work, enc28j60_tx_work_handler);
>  	INIT_WORK(&priv->setrx_work, enc28j60_setrx_work_handler);
> -	INIT_WORK(&priv->irq_work, enc28j60_irq_work_handler);
>  	INIT_WORK(&priv->restart_work, enc28j60_restart_work_handler);
>  	spi_set_drvdata(spi, priv);	/* spi to priv reference */
>  	SET_NETDEV_DEV(dev, &spi->dev);
> @@ -1578,7 +1561,8 @@ static int enc28j60_probe(struct spi_device *spi)
>  	/* Board setup must set the relevant edge trigger type;
>  	 * level triggers won't currently work.
>  	 */
> -	ret = request_irq(spi->irq, enc28j60_irq, 0, DRV_NAME, priv);
> +	ret = request_threaded_irq(spi->irq, NULL, enc28j60_irq, IRQF_ONESHOT,
> +				   DRV_NAME, priv);
>  	if (ret < 0) {
>  		if (netif_msg_probe(priv))
>  			dev_err(&spi->dev, "request irq %d failed (ret = %d)\n",
> -- 
> 2.39.2
> 
> 

