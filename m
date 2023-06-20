Return-Path: <netdev+bounces-12127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6578573654B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 109C22810BE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428DA79DF;
	Tue, 20 Jun 2023 07:51:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F77468
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:51:08 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3C1FD4;
	Tue, 20 Jun 2023 00:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687247444; x=1718783444;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fvLUFhTIhknns24s/DCDf8fQR3EzPUFBNok0MNSRKE0=;
  b=E4K4CDTgPevRSaAWSvj1/4Qn+FouKHmhEPZlkzgDF43WxEbP2VXxMvtm
   ZaOnrNXxINJ0mpJ2FrcZUzX9W5s2A2YCu2XtzcmIqY3tW18+UdxfT/5lU
   6Cg5kRJXU+5KgEiKkTl7wvPGoEDHM+udQF6yRkfrh4wZ/byJSAna5W+Ui
   W/jLFUyhE2LS3YfOMtdInUArXcV1oFMJD9OXlhby6fiymJuuMknYD/Bea
   Q084NnjbHidEJgzfKSbVFQLMVBk/c7Ddd+uOBp4E5YFZnftGadXsa/Vwx
   DCXdvNYpYAGa2pthBEtXVWvai4mkHwqjZaexlWt5Ka5qcp1iNQUqvqtbi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="358664306"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="358664306"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 00:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="826882234"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="826882234"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jun 2023 00:50:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 00:50:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 00:50:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 00:50:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk4hqdmkhD3pczzcVWf9M4HvSo+F3QKc4PisnWEuhPncJedCjg73zrOEXSAeSWvQ3RVQVMif972/viO1fvgQocvh5acJ958fqb2aOnrRLGcsXl9Q3+nldv28arjBQ2jRpdjfrcGXwV3ucHCWRtttL/eglHjwSUD7bX9v92WVeHKfH2mq7ewYv9oVY+h4P5bJQoIjRBTejyPtjhID8ENqYcrGTwzwWqJlhjS2zsk+/0Vcu+zidcURvvqn4IY6Ey6Sz+zKx6OiRcWDOJ0a/2AoS5jNQvUUqFAKk9ySz7FbsOmvt56l8boFhr+uxZodQQobDjBsowiPnxrDZnzZn1QDpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wp06jGfSiNORAXDoIxSkGOazTiWfFZUYWjkDXsoRPEE=;
 b=ZjqqtUj16vH5R6EU4GGo3huJ6BS9AcUQHh2zW7ydAALUqIcWtg69/HmR8AQn7S6Gp2HaiYCQ+ig9sGQ+OSsrkK82gNXgw7Nu40x9ZE93tSmkRK5fIXD5BnpKAr0djuq2CpOhpQsJSdGFk2i31VsnA1ErgXObtZfsTzdS4pQaKbMyELyNdwN3NZwz/l9EGiHOZIBDBmR8bNrvXCWlv1sgOYDlzmioyg072aGaaRCrD2HkRisiycV7x2brRcOfSO2jBTKXpGBXZL/B8c2zf9hePT59QLRmc0oBHRXlAJw9jC2UDmWffhQ3f1+7v24yOQWk36aaC2T+QZ2dzQ8qLU0lfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW4PR11MB8290.namprd11.prod.outlook.com (2603:10b6:303:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 07:50:31 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 07:50:31 +0000
Date: Tue, 20 Jun 2023 09:50:15 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Petr Oros <poros@redhat.com>
CC: <netdev@vger.kernel.org>, <pmenzel@molgen.mpg.de>,
	<intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
	<linux-kernel@vger.kernel.org>, <edumazet@google.com>,
	<anthony.l.nguyen@intel.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net v2] ice: Unregister netdev and
 devlink_port only once
Message-ID: <ZJFaN5Yg+SrHfUSM@boxer>
References: <20230619105813.369912-1-poros@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230619105813.369912-1-poros@redhat.com>
X-ClientProxiedBy: DUZPR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW4PR11MB8290:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e4096f-b7c7-4d77-2194-08db71630535
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2+jMhwAEZyh7o3ohG+bp4erSYUPXWVrShkgILaYtannQND2zKuLLOsHmoCpKqeme9MljAOXnFZXe5YFgaipxRIQrEPAukNEGSt4Teig26dQgD655fbTf1C2hPzhnSArAkcxzc+NLhZkzYmT9Xj67RMqem5hH2Rv0eAN3ZMETt51mtoOdF9vmqxLsxnmggVMLybCCkUsyFJpOm7pxeW1ZgMwogpVF0y46wzBsufNUACsVcjOWUR2X5r+N6uU61YdsmpSZcLBxf/3oTrbtJvEysbxFE4SVixx6eZXVBZncVdoBoSxFMaljWtQTowajTZs0EzvCPGMlOT5KH0ccxKv4kaM8djsLE1nZ2eGrleEOD9ki9MHJXoCzj6zGnIBc0xRWJp2yDMUWi9g6L3lZt4yG3VLWCzd6lk5mEb+dfaw6SWYGC9wG8b60vMSHSLzL8v+e94bkCv1JDLRHIPRAkP23uoRy9ao6xht/42yrnk3hqoFZ794u5+0gi2bz90PtXnL7L4kbWruHNsfuPAQx7vmxlC4A52cAVeILir5PXMRbnx7zBdudfwhhIvaCP118gnyp2T/J8fLW+NsuaJZFdaVnBrDr3sDRDNOw4W3vGyTqJhTqY0ETqkhzVLCzW9Osvt8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(478600001)(2906002)(66899021)(966005)(6486002)(6666004)(86362001)(33716001)(9686003)(26005)(186003)(6506007)(6512007)(8936002)(8676002)(66476007)(66556008)(66946007)(5660300002)(38100700002)(316002)(44832011)(6916009)(4326008)(83380400001)(82960400001)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G7oTP+cnJVI6k5Lbt3waI5LQnFmfvlc6z3hXPGvVa65XZMdqVvR9XuZfBHdu?=
 =?us-ascii?Q?e4L1cHbBeL1iJd3GkzvTa/ZDr+xQT2+1ukRymS0bXUJrl3iGNDRbKx08IeW7?=
 =?us-ascii?Q?IFE7Q1dGg/2H++LzzBS1hCHXPU+BxMBOR4MYZq50Ej4kMDBRlRoElJ11nAq9?=
 =?us-ascii?Q?+v7LdraRZA7ocUBgbiH/MTDTePht9LmidyTyQsU6yZyAZ8ScdrI8vm5kpkwd?=
 =?us-ascii?Q?NlzXz610bcZbZSXaJNGuWTk8snZqDU9lQVSoSizvafS7YSPJvLFcRKxzRW+q?=
 =?us-ascii?Q?7/zBZjad+Yab1LF0GxOKY1sKoM3NBEZhdWCt1js1PVceziCUBe5qfARdLrni?=
 =?us-ascii?Q?G9tSL9+YMJi9Q9XhWySPjM1c3RcuHZ85Oiq01gIet7XON5Z8Ee267yQzswVl?=
 =?us-ascii?Q?NPub7BBimwirNKKwBRNXY9lsXxe7cf1IdeC8+fpYIx85i5dQhg5x/8zaQC1Q?=
 =?us-ascii?Q?/r546h8yFuRF6z+d8y0s3EeiUFalBAbAEoG/MBXgZASviZmL4Ga6t9YsUNhf?=
 =?us-ascii?Q?szmjpwOfFtZ8w0lYdV7Oyf3CXmHbkqeIILo4R5A0bnDXNjosoEHzr+qS8tgB?=
 =?us-ascii?Q?8lqU/cfrRgjeGIrtHP3twx5xvN+rqmvnE5/01d4X0sg7bUWpLeICTKugWDdr?=
 =?us-ascii?Q?btJKesj0+pWctbY555V+/TGV1cTgHikPpLwZ8ZAaWggMvNqEOS6lphRLgCF7?=
 =?us-ascii?Q?iUUkstMhcvTTHl27wxmmwmeyng5133Ly+aAFU8wEICuatdhbqpU2218g5QWA?=
 =?us-ascii?Q?KxIWw8//AP4H6dqHMBFHoobbK9vu+Fi8GZfTffB4hqKqgJiXurdIJpypRM2W?=
 =?us-ascii?Q?sqqZ4y26qjRYGqrXVfLLm/oIM5+PKZGBbEmPRaqhBDQqKaB2qTAATgIX/eM4?=
 =?us-ascii?Q?7fnvz8TNdFUuBiv9LlJl9KUwH+NtY6Jgam5ipYyv1zoCk9oxRROAHMgcVk+D?=
 =?us-ascii?Q?G5blcRvpf6k9RUYPw3dxx7ZcTe8oTARKv23oPooNLVwMBv2h9r2tM705QDJ6?=
 =?us-ascii?Q?XThKL/U/ABlXghLQa4rjKC+SE15Ilxz38d9+18SryusKDPBIR8sO/aQaqHsb?=
 =?us-ascii?Q?ZD4Xm3ZW2TpASttPx/mC0QSukaxL40eIU+mM51HfCPJCwtHCXhXOaeuKX86y?=
 =?us-ascii?Q?7Dc4NO8WKuIl5viet00KYncJEiSZG6Oo8zZeG5qlpRBkgS61TYx3CWLMtuYo?=
 =?us-ascii?Q?K+Zv2Qbl7TrIxVKP4VDlnlCoRDbslDtdEKkj4t4U58dgLboiPLrbhMhyRsH9?=
 =?us-ascii?Q?0K79T2fkgn5Myg8SJHWTtK+w1lOzLy/ivPuI165zFxpjj5OKDGDpIWPG9Bam?=
 =?us-ascii?Q?vFfEQJ2AzNek4RBvIpNibhlkz6/XNx8MlGWObvBLAI3SGSFNGgivIgLgNq+5?=
 =?us-ascii?Q?qPW3e2CUXa0AeVSQt/FZm+2LxI4yNfPu5F15YiyyNv4t4I92evp8yVBTrzy0?=
 =?us-ascii?Q?8BplngBGggDQo56Xm8QA2Cx6IPgsKqUlw9HcWWqtBXKbk0GjfHg6wUzKe57n?=
 =?us-ascii?Q?icN+csGvGxtsD8gb/SDJzm4UdUu3tfgEnn9m0BZmPDncucANp30pDuZpYfTk?=
 =?us-ascii?Q?XioRQC9kAyen1GbVUljk1fPTegnG6MIdSa8XIBFGh2CwEaSf+aFXD58Roaxg?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e4096f-b7c7-4d77-2194-08db71630535
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 07:50:30.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: priNvBhAyt/E85McWY2Frgedt+Ky9QWZv+fkcH3pV3HR+VnzWLrLUh/2enwNr0At3B6VSXGq9tNdOVogbeYxGIpxbd2gufYZPJ7nqXukjr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8290
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 12:58:13PM +0200, Petr Oros wrote:
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
> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
> v2: reword subject
> 
> v1: https://lore.kernel.org/netdev/20230619084948.360128-1-poros@redhat.com/
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

Hmm it's a bit messy:D

I agree that ice_deinit_eth() should be the one that takes care of netdev
clean up as ice_init_eth() was the one to alloc and register it. I believe
that part of the split up work was to come up with entities that are
scoped to alloc/dealloc related resources...as this was even more messed
up before.

It would be worth to exercise other code paths where ice_vsi_release() is
used - like do a loopback test (ethtool -t $IFACE) or go through a reset.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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

