Return-Path: <netdev+bounces-11958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE577356FF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CD281C20A2A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A75AC2D9;
	Mon, 19 Jun 2023 12:38:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90AAD3C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:38:50 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC997D7;
	Mon, 19 Jun 2023 05:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687178328; x=1718714328;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HsW4aQ9K5WUQY+mGfC7nJqU8FhGmt8VDwGdYYXJ6dnE=;
  b=W3rKRQOnK/3z4XYFp4QInjkEDpnvIbhzxjjBKi1Z35nVsWFp+MNKuZCI
   ATQXqDNXrEkzUQvHP9T2e/iejr7QLVX8jHWbs0V1f/fVyLkRMIJ89qS87
   ot8JsBPKAYXUiDhpOJ8PZvgQw7FhwSb6tJb+dJvOGClXhVzlN7ybYXgbF
   q0DQLDo0Pkxgqa9svQYxbPaj/WbH4TAzyZvHygIZdabNXrJtWU2gYRz3N
   tA7EXWJVeiBZoclwebu2JVWdDxrsSQRHDI/YCw6wHxvj2xo+BDSTtH7TC
   adAuW8yeHEUJg8deqsona63SqhIkMCipt+tr5FMcRncsTk7bG8T/3oYPc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="423282667"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="423282667"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 05:38:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="960411308"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="960411308"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2023 05:38:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 05:38:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 05:38:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 05:38:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 05:38:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkAIeAcW27zohx2iuFcMXC0EDIlEW0MlB6uhmOfWXLGYIph10areOiPjY8NfvI8VJzuOEpXIWwKjfsxJydJbGFnUX0wUpcypvnX6HM7tO0eNnz28UXS6WIyseM+3skjgvYtukVXqzt+M0a0bcdwu+3svwbf7ZABYH8qyrBln/QqvoNdV84D1dzvmJj5j5V+MGaDVgIed1sQcdfpcyULg666Pb79GBa/kP5uJ5kDsOjJzcAWVZRfvZdJuxe8x87Hs0+nixWgRbxlA8+qCqAVwMWZaEZ5BGlgMj6nmZRYDlI0CIE8dUWUhS+aErqRiLzN0u0jnzXIh7jyB7V7uyoKyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rscGHZ+sAx8LFXPgC+EIGlqGPWyOypUEN7fVQPgkN8=;
 b=Sr0OrK2peWn1WSjH3zR/2jhNyxBpCE4lp4VP5sshaxJLqcEgxAN+2vIljA/xEHJNn+6yQvk60sqHNgog1tthzEgcQeLaxaJL87aCOq2xodEmesbuS5f9tVXjxuqO1s4WphPs8Pfzgm07TLeKo1zOpMTaSIQNDBaIXHvOqq//smAUbuwiIbgpKA/xTViFlB4luZ8QmNzV+qAXFjYLGxIKNCSGUDL55ddInMmaluZ8IRGRvQ/IzAlLudlyvhZE9GaQD+5cuNRsRqf/yzAcAwEB4Zrsm9ofwYKFDJCVZKH+cgXxFkj+PuzmLhGcFILOkOL1072uR3mhn7ksFvma9cvp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW6PR11MB8339.namprd11.prod.outlook.com (2603:10b6:303:24b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.35; Mon, 19 Jun 2023 12:38:41 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 12:38:41 +0000
Date: Mon, 19 Jun 2023 14:38:33 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Petr Oros <poros@redhat.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<jesse.brandeburg@intel.com>, <linux-kernel@vger.kernel.org>,
	<edumazet@google.com>, <anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <davem@davemloft.net>, <michal.swiatkowski@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: ice_vsi_release cleanup
Message-ID: <ZJBMSWygwtovyNgU@boxer>
References: <20230619084948.360128-1-poros@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230619084948.360128-1-poros@redhat.com>
X-ClientProxiedBy: LO4P123CA0537.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW6PR11MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: d332ab7b-bab0-42b0-bfee-08db70c21cfc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cSFWZOpcXgm8ylcORO1HY6diXmHigts5eMsFbl9dRfJZkpOVJNBflSFw2eculbwl18lVhGIT7lQVR7IlPjOu9b+PgKsaCpkG5X+ObOmaXvc3qjUgDaX8meSDbt8gvtxtRcyZnye+AAP8lfXt2wR8sVRgvXJkOJcp5h2KnTwVLBXG4Su5TwRsMc0ZqlJsY8wGUcQq+e/2ycr+S9dm03nyfhlK2Ti+0MiDLSDOtOPf54cXCehSBW1cM4GKxIkuULa4fEj/fsfo1LPr0/AFNkKEcAB5HI1CakRT5+kh4vIudwemx9js8aAUB2ZAJfU8fOX+1m8Vsw08S12OUruSi1TYjn+fZpEl66T+F8jdok/3KJZnFObR+Dp0diiw/Oe0GRYRFghjSsfxiK9vjtHG4T/xb708VrKc9AB3kguYhcAKTI5HU1f0j4QjPHv4Rq+l0gFtJ460DgixPgz9RcidefgO/U29ouktvkxNfKlF06PFcsoMxcpj1v2mSomU8pRpgdBnVSX23/JLsnA/b2NwwrD9Q2+Z0J+es98xZ44L35DoLak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(38100700002)(82960400001)(33716001)(86362001)(966005)(6666004)(6486002)(186003)(26005)(6512007)(6506007)(107886003)(8936002)(8676002)(44832011)(9686003)(5660300002)(2906002)(478600001)(316002)(66946007)(41300700001)(6916009)(4326008)(66556008)(66476007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRBoW1/VY/PE0IZm+MGECeSPcx/FBKlwuzJR2LpBsJDx/a71eb1Mcc1Mj6dk?=
 =?us-ascii?Q?UMhV68T8Td+w5C5UHiZC3Sp6pNTFjsvkXhzL1JQDEm1BQ7B8eHVG/5VKTlRq?=
 =?us-ascii?Q?DKmT0QdZ8HuYzCrQN5Lamweg9Hbg9uIPGyMuk3SrWWYtltmZAB8euO13dAq9?=
 =?us-ascii?Q?Z0MXRp2DxBgSrihLtZaEcFanCwlNNuv78owl+cMky2lX0rhgkVdrls5oWlk3?=
 =?us-ascii?Q?q8hS/DTU7M3qsrNOQJhJAI5TBiIcEGuU0rq1R/euF5+FwDkO3vThpSz4k/OA?=
 =?us-ascii?Q?u9nGULG9857OhujXT3UsA28h4yv90qjNSqNfwxs76DqJplx4Aq6cY8IZMFp5?=
 =?us-ascii?Q?bwYWtIrhs/KjhOTqt37I/aj6xUoBOKN+lI4vxFf6+AsBQLPg8pnU+Gu8X/lH?=
 =?us-ascii?Q?k8DsDav+K0mFMj35CmeACSo8VUxtlmuLlS2yaArLYMdzp9cSVRYr4RqgXaNk?=
 =?us-ascii?Q?fbEQTyH0uNFw27GIkcuKZRTmB2bqHTglqkJCugh1n1KJ6qbk+f7kLGt3I2px?=
 =?us-ascii?Q?Axw1TNijR4oBzkr1uPW4QzHSOO8UCpBBi44yMxM5ntVXDrB5Q3cicjw1PWqZ?=
 =?us-ascii?Q?DPuBfnXz2ezt94NLDqRQWhKIwU22hwo/G1MQVAFakuGHNrYRcjh/XOFq4eyj?=
 =?us-ascii?Q?XwcwNSmKtl61wP8g6FDZbaPxD31XHtE4Ac3hhY/2LfZGIPmwNurZkJHur/ll?=
 =?us-ascii?Q?+/4051Fcl+KphRdoI/wQ4quWFk8AVTE2yWSjJNT6Y4qHifwRuWv/JCrdcl0s?=
 =?us-ascii?Q?OKX8yjKfCyiAHidUJRqPaAFbiB4hReDHOCVBIdg6SWnNTJqBk01aes5H3NQt?=
 =?us-ascii?Q?4S8hzhDcbgadB5Rmx1/UgJ4kQ8OnP19OOcXKmtjD+EW79gydPaz4F1tO/x7Z?=
 =?us-ascii?Q?uX64ra85RvXQUoOv5mXGodDwY8+soTyQg0qTXuSqMBEiMK9pdEhU5ZXFa4xe?=
 =?us-ascii?Q?w8nIWVf89xHEVpTRuQiwXFL2ol8isoBX5+sN6xizwcmYmnwaNb0OoQF4CNwk?=
 =?us-ascii?Q?2BiMtjsFE23Vis51ZxY0r2A7b4H8DL9RukGNoeaPixnqFQ1MGn8VWdnIcndH?=
 =?us-ascii?Q?tDOdJDw9MIfSbjXjlUlZtTFDTsp6RVygCEUlM7ysZUD5KYmJt+/+pEcu1jHM?=
 =?us-ascii?Q?tUS3wnenUzm6PazVulSrPAdUrldqZkrKDGjSxCw5fY9iW/dYKLELkXyyJhte?=
 =?us-ascii?Q?LRXNdXYBWPDkUPAuHgyXSOOpturTvKg0AY6QprEZPxk+6EqUTYKbvx6xD1Za?=
 =?us-ascii?Q?7xkbhtAVkx0pGTJ2KfuMv/fB/qgERJovGFkELOuf26XkN59nrUAgaxL+jc87?=
 =?us-ascii?Q?yvVOaYuyeJChhvuoiP6RSf8wxhGIADP1bgFww3wdpR75k7yW9uM1pK9cAFdk?=
 =?us-ascii?Q?uha+EyqiinBCA3G5rvaRX4Pwlh4Ra515wfnQdgR5UF4zJKqg5XVHEQnfUSDq?=
 =?us-ascii?Q?Diu7ui3RcM3A7cbU5fva8pxGkYdx/9fe2N/7I4CIUVSWlxm9B/yM+f5r7gSF?=
 =?us-ascii?Q?w+kKMUcX8lfdlt+dDAEgcamciw1rr/19SVmJxTwidY1wHF64El3IXiXiZhKm?=
 =?us-ascii?Q?iZvq8PgfmBk/2hiIAvBUO6luBzdWvn8yAavyCNz7Vx3ZERhTSApF8R1Jw+Cc?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d332ab7b-bab0-42b0-bfee-08db70c21cfc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:38:41.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: td+0FXxx1qmn6S2+ImVpN1eDQN/CDbCd87DED3cl9eQ+8K82xBEdFF5nwukBtegGwDoTnmNjJNWjmALYYwtRXekyIEsF0wNyCiIOdQ7b6R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8339
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 10:49:48AM +0200, Petr Oros wrote:
> Since commit 6624e780a577fc ("ice: split ice_vsi_setup into smaller
> functions") ice_vsi_release does things twice. There is unregister
> netdev which is unregistered in ice_deinit_eth also.
> 
> It also unregisters the devlink_port twice which is also unregistered
> in ice_deinit_eth(). This double deregistration is hidden because
> devl_port_unregister ignores the return value of xa_erase.
> 
> [   68.642167] Call Trace:
> [   68.650385]  ice_devlink_destroy_pf_port+0xe/0x20 [ice]
> [   68.655656]  ice_vsi_release+0x445/0x690 [ice]
> [   68.660147]  ice_deinit+0x99/0x280 [ice]
> [   68.664117]  ice_remove+0x1b6/0x5c0 [ice]
> 
> [  171.103841] Call Trace:
> [  171.109607]  ice_devlink_destroy_pf_port+0xf/0x20 [ice]
> [  171.114841]  ice_remove+0x158/0x270 [ice]
> [  171.118854]  pci_device_remove+0x3b/0xc0
> [  171.122779]  device_release_driver_internal+0xc7/0x170
> [  171.127912]  driver_detach+0x54/0x8c
> [  171.131491]  bus_remove_driver+0x77/0xd1
> [  171.135406]  pci_unregister_driver+0x2d/0xb0
> [  171.139670]  ice_module_exit+0xc/0x55f [ice]

Hi Petr,
can you tell us when in particular this call trace was observed?

CC: Michal Swiatkowski <michal.swiatkowski@intel.com>

> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 27 ------------------------
>  1 file changed, 27 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 11ae0e41f518a1..284a1f0bfdb545 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -3272,39 +3272,12 @@ int ice_vsi_release(struct ice_vsi *vsi)
>  		return -ENODEV;
>  	pf = vsi->back;
>  
> -	/* do not unregister while driver is in the reset recovery pending
> -	 * state. Since reset/rebuild happens through PF service task workqueue,
> -	 * it's not a good idea to unregister netdev that is associated to the
> -	 * PF that is running the work queue items currently. This is done to
> -	 * avoid check_flush_dependency() warning on this wq
> -	 */
> -	if (vsi->netdev && !ice_is_reset_in_progress(pf->state) &&
> -	    (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state))) {
> -		unregister_netdev(vsi->netdev);
> -		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
> -	}
> -
> -	if (vsi->type == ICE_VSI_PF)
> -		ice_devlink_destroy_pf_port(pf);
> -
>  	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
>  		ice_rss_clean(vsi);
>  
>  	ice_vsi_close(vsi);
>  	ice_vsi_decfg(vsi);
>  
> -	if (vsi->netdev) {
> -		if (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state)) {
> -			unregister_netdev(vsi->netdev);
> -			clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
> -		}
> -		if (test_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state)) {
> -			free_netdev(vsi->netdev);
> -			vsi->netdev = NULL;
> -			clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
> -		}
> -	}
> -
>  	/* retain SW VSI data structure since it is needed to unregister and
>  	 * free VSI netdev when PF is not in reset recovery pending state,\
>  	 * for ex: during rmmod.
> -- 
> 2.41.0
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

