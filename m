Return-Path: <netdev+bounces-12128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3424073656A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECE011C20B34
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767AE8469;
	Tue, 20 Jun 2023 07:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6696846A5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:56:00 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31922112;
	Tue, 20 Jun 2023 00:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687247758; x=1718783758;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=P5Q4IPOXLjX+bleM9UppIEFXIxY65YYGq2VuQfRRpIw=;
  b=BsDM27hNlSlDqX8dLPQCWtqqS+vodVA33tqfYCnzARkejeUEqekM8chF
   eVJE3i4nX15HqeobEW/d6bBLI/A/nZg0CmeehQG6Q1mN2ik+e9JzgPxN8
   qUgvCk/JHkx2Kq86LIWVJHVA/y+XWFqfs6akp1qSd+8CsfsvPRHFAwHz4
   YPYXnmGh4FdPeapy8LZ6xx9BMsvZobD0rb2K+vVyBvN8T7LJbQ1Qo20ZP
   0kJ+KzsYhsN4K20Ad9/xjglxbhIxAXn+uORCvrm5huxyu5phvNHrnPeR/
   SDxo0AhgOP1qulVVA2Pgk9Fq08uAYmtECKRUVkzoE6nr26vY/XPQX7hXM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="446172782"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="446172782"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 00:55:58 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="747958363"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="747958363"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 20 Jun 2023 00:55:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 00:55:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 00:55:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 00:55:57 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 00:55:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaIzpsxDkS/vlO+i6BqiI/KQRDO9Nwwr6JuLkuIw1R9q5IJf3CTNS2iq6+wJD0YhdGgFTF3pVmX7rd0c0F4ye7MqWnUop1g1Y097h1kr+ZhHGVOADaLBF6OeI845E8+NdJeu3xwJzBtuxHkeiAUsBIw9Be2dz1/6yU/s+hRDbhrDaNNUHGKXJFHmRNQD/ylf4BiuJJmGByfaXVF9E85Zqe63m46EfoRVOjC04SlZnkHmUIPeaoxymlU1zthy8f89fgLpd3nTyXd+fgmhHzjmC4v1ZD0HntpZGH3SMcj6bHIP9rz+d7aew9uzV+wtKkOpFusLKbYGsAFT35FAjBdXDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPPuQu3f98FWEUEThECp3Dr4fOyiO6nHpSBjs9zA3Wk=;
 b=kEiH6aN/lKNet6M2ztw0fRuw4Ad64HCvXOeAZ9UAsGtixyF+ibT7yeZ/vIl/MhtzMw1q5SWR5PLicGCRsFNI1ixjMG9bL4I7Uo+Fuw66/px2TjDHJ1iiEmbyTi6DguAVXxb+39bDlVzhuJxYwvFAcmNXwps/8QlJ3+KSRaxnos+A5HbIqtIZiWtAXGAf/Sj3y1+88kf6zl7aNBEyslD2pz3h6EKWYsjlhC9zdV9X1GJFCzHmG2Ff0ik30SCMN3ISOH6jqc526K1sZTY9brlAHZgeKrE0kdfxuaXguoeDxVTelLVPziG/R4N5wwrOYl4+2ZlYl8mGrKTpTP4dxMbOcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW3PR11MB4762.namprd11.prod.outlook.com (2603:10b6:303:5d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 07:55:49 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 07:55:49 +0000
Date: Tue, 20 Jun 2023 09:55:41 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Petr Oros <poros@redhat.com>, <netdev@vger.kernel.org>,
	<jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <michal.swiatkowski@linux.intel.com>,
	<jacob.e.keller@intel.com>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>, <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH net v2] ice: Unregister netdev and devlink_port only once
Message-ID: <ZJFbfQaQkkfhZjFY@boxer>
References: <20230619105813.369912-1-poros@redhat.com>
 <ZJBvKVf7Yfh6WpsO@nanopsycho>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJBvKVf7Yfh6WpsO@nanopsycho>
X-ClientProxiedBy: DU2PR04CA0052.eurprd04.prod.outlook.com
 (2603:10a6:10:234::27) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW3PR11MB4762:EE_
X-MS-Office365-Filtering-Correlation-Id: a10ee551-900d-48bb-c144-08db7163c305
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ald5KiWM9Lr+yp7Q0Ntkrxg0GOD+Ie+2zdu4v6j1cCoIa7icPIBkgKGF9DoACLno2k29DerBHWLhwhbkZhjrSVrRpPfdGCCt0YTlkwL2vwOuQq0donLVbev0ti1zMyab2xS5CDb2v0Rh/+YrFV0w0HTzJVBh6W9ha5F+WXidZMezXU+tP7Mt1vphwydafwKmW4O1MgoNvoEnQC/KZU/ao61aSpGIdKee1ajT8b3Cu7YHWTLZOxg6nn0bFksZE88eJ2wY7pkBuw8SdYWos3wwp4KDTKPpzqPnBz/Dz4ptSa036Pcl/PNHlypf2NzvIimnr0AAXZn1m51tKsi6m1zSO9J0lemYOD7K0u9FM9srj8Rc4QuKF8iluMwxrztMj1p7YUuXTVKAsa+Yj+UiXgDVnKo36E/e/j9p9rU2iFI2E0GWKr0MvwDf9E/6+zz1r+JTZxnFYsIW+l8RSZRPsCsHVJ0nlQN3e/lXURya0IS0UaxDRqjD3WZfiAcZMgm5ZGhpe7N/hHKFA+tmBR46KLEWBs/bWWK5oMuH/lGyEwKhtVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199021)(478600001)(2906002)(966005)(6486002)(6666004)(86362001)(33716001)(26005)(186003)(6506007)(6512007)(9686003)(8676002)(8936002)(66476007)(66556008)(66946007)(7416002)(5660300002)(38100700002)(316002)(44832011)(6916009)(4326008)(83380400001)(82960400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TvwGfKRi/ngKOeL7DCHxru4Kvav+z7gjBXehJzT7q8ad4pE47zx6wDpXyv/n?=
 =?us-ascii?Q?VneGRWWi9TKrtylqlzleDTj90WrZbN5++nrOX5+U1Wb2wqbnh5fuBb9qkzfC?=
 =?us-ascii?Q?/uhXk5sTt1BNVZhPRJJbUkaAdbGe+tBXyOwJE6yc157Zpp7Jaf2zOsa95v6g?=
 =?us-ascii?Q?VPmKCq9bA7OWjjJZIYCEXLYL2/l01kMbaMx+0iybuFEpaoi7QsgRBd7dcUB2?=
 =?us-ascii?Q?YhmbLJqDft7r92ssF3UVDPEzZjMokCzGiHlFJn9UY4gqREQtNIFdWH8Nz/Hf?=
 =?us-ascii?Q?xhYfsF+wCoxQ7OtrIYv+VSBstaPGzG/ZZunBUhftlNmQd89alHZ3231Lulc2?=
 =?us-ascii?Q?euK2vPCn7x8+yqiUyktMvLCL6Fs817SOw1l1xa+ihMH5ZPu3G6CM2dhf/3qf?=
 =?us-ascii?Q?Dg0ECGGegQcd/iAjNA6qXQvj+fOTnTwqzqZaEowyNqMltXCmUAUGlT+iqqm3?=
 =?us-ascii?Q?WcX0cCGWpD9BIvwarFYGt3DKAvIHleZ/18i9glu5MkpH8ZLZB3un7C5xsNSq?=
 =?us-ascii?Q?jSdhLqVKVIOwdoGc++buiyTmHn3KTQuZXgSVxGINhM4I1oDnHKLnahIVL+p8?=
 =?us-ascii?Q?mH3bXO0GJ/5rc+xsT535+XMhOneLwm8J06PUwTqDmo65mtFwYzR4x+02SOZN?=
 =?us-ascii?Q?oZ4osIvMrVOFKnOcCvKfTrGfFJEsqVPhOS0UpxPhh/6A2IheDqk46fPkJ3JI?=
 =?us-ascii?Q?BQxHikmhOKgMJWup5jmZTUfOVo4Auihio+a/RMxn0JZ3sbmBxnSSh0CPz6BL?=
 =?us-ascii?Q?xaxfuZsfTk5Dxfzw0k+z1QbAqD5g6BjjNFyLx2W2hk6FQjdNRlqLE8FxHxvr?=
 =?us-ascii?Q?Ez+E9kJKgYdn9ojCgWOCrOm35YRd638o+V1+PpuNZ0g5DEhcbQDZBzqpsE4F?=
 =?us-ascii?Q?Y4jUzLDJViomqVMw6XtjrU0zfKTj+cyMemrJ8Y7hKq45KzWlTbS12Z559bNG?=
 =?us-ascii?Q?p705IP73Ph5plQC8SwQbv93IfkxvxFckbEAQUn+H6HWtBFFo9BzhLRXduLAQ?=
 =?us-ascii?Q?Cp9F5gA/lNjolePWIhvJ106KhSZbjBb/+ekUGTPEmLuANPQ94Cypa/YNGyDn?=
 =?us-ascii?Q?oqTMWwMWbbf1bCmaiMnozS65SczO9SNnxRPP+VqfG2Qg8lkxkWx/gqr8vNgW?=
 =?us-ascii?Q?KExm8Zhnlx5zXLESwCnWj+t0RAWwvd26loHyq16na2E7upO895kIAh0VPjNC?=
 =?us-ascii?Q?3uQSqFmV8BMAob2lrCLRPVCNI1/fphaOgPAcM9/MR2RIRbwzqnw3E66ax8tz?=
 =?us-ascii?Q?Xr15qEy6W6DQQh5L1cBNRI3Gybzx8qYfDh32EBk2x17HcMRArZ1pcg56P0rO?=
 =?us-ascii?Q?JZg7lu17ixoyu1YzPBP3yPi9IB5eE83ohcI3g5CH9y+HSVo9KT5EFVSYp//2?=
 =?us-ascii?Q?0f0Xrg55pam1g/gkgAM/trrjf//yOd7nMyUk28iTuZdFPmOeqGBUy62c7aHi?=
 =?us-ascii?Q?ev5ZJSPCQdXerj5D+lwuzhat3MdkM+04TxPt5NLOE02+NfxO8c9cehAnqYZ3?=
 =?us-ascii?Q?3XN3yJs+sXlmEp5Y2ojbEPpfeSssuP+9Nq/HxDKQEzHSGCinOeduXHED8kt1?=
 =?us-ascii?Q?Vj7+NolPii6dU22vMNg3pmGwEKcOVjPH7rllXcBFOK3led3Iuer8uwhXbiiG?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a10ee551-900d-48bb-c144-08db7163c305
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 07:55:49.3213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ih+ohaOlAAHGH7LEe/JHbpCog+VuKTdFP0wJR3lRuRQoaPm5oY2XIIZLfR+qMD4bk4iyUB3LO8AQ7CvFvAvE+mfuAmD8bQvAnXwyb+3sFtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 05:07:21PM +0200, Jiri Pirko wrote:
> Mon, Jun 19, 2023 at 12:58:13PM CEST, poros@redhat.com wrote:
> >Since commit 6624e780a577fc ("ice: split ice_vsi_setup into smaller
> >functions") ice_vsi_release does things twice. There is unregister
> >netdev which is unregistered in ice_deinit_eth also.
> 
> You need to describe more relationship between ice_vsi_release() and
> ice_deinit_eth(). From a quick look, I don't see that ice_deinit_eth()
> is always called before/afeter ice_vsi_release().
> 

Only relation between them is that they both are called on .remove() pci
callback. Clearly ice_vsi_release() should not be cleaning up stuff that
ice_init_eth() has brought up. I was staring at the code and jumping
around these flows and fix seems reasonable.

> Ice init/release flows are very hard to follow :/
> 
> 
> >
> >It also unregisters the devlink_port twice which is also unregistered
> >in ice_deinit_eth(). This double deregistration is hidden because
> >devl_port_unregister ignores the return value of xa_erase.
> 
> This call for another patch, doesn't it? :)

+1 :)

> 
> 
> >
> >[   68.642167] Call Trace:
> >[   68.650385]  ice_devlink_destroy_pf_port+0xe/0x20 [ice]
> >[   68.655656]  ice_vsi_release+0x445/0x690 [ice]
> >[   68.660147]  ice_deinit+0x99/0x280 [ice]
> >[   68.664117]  ice_remove+0x1b6/0x5c0 [ice]
> >
> >[  171.103841] Call Trace:
> >[  171.109607]  ice_devlink_destroy_pf_port+0xf/0x20 [ice]
> >[  171.114841]  ice_remove+0x158/0x270 [ice]
> >[  171.118854]  pci_device_remove+0x3b/0xc0
> >[  171.122779]  device_release_driver_internal+0xc7/0x170
> >[  171.127912]  driver_detach+0x54/0x8c
> >[  171.131491]  bus_remove_driver+0x77/0xd1
> >[  171.135406]  pci_unregister_driver+0x2d/0xb0
> >[  171.139670]  ice_module_exit+0xc/0x55f [ice]
> >
> >Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> >Signed-off-by: Petr Oros <poros@redhat.com>
> >---
> >v2: reword subject
> >
> >v1: https://lore.kernel.org/netdev/20230619084948.360128-1-poros@redhat.com/
> >---
> > drivers/net/ethernet/intel/ice/ice_lib.c | 27 ------------------------
> > 1 file changed, 27 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> >index 11ae0e41f518a1..284a1f0bfdb545 100644
> >--- a/drivers/net/ethernet/intel/ice/ice_lib.c
> >+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> >@@ -3272,39 +3272,12 @@ int ice_vsi_release(struct ice_vsi *vsi)
> > 		return -ENODEV;
> > 	pf = vsi->back;
> > 
> >-	/* do not unregister while driver is in the reset recovery pending
> >-	 * state. Since reset/rebuild happens through PF service task workqueue,
> >-	 * it's not a good idea to unregister netdev that is associated to the
> >-	 * PF that is running the work queue items currently. This is done to
> >-	 * avoid check_flush_dependency() warning on this wq
> >-	 */
> >-	if (vsi->netdev && !ice_is_reset_in_progress(pf->state) &&
> >-	    (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state))) {
> >-		unregister_netdev(vsi->netdev);
> >-		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
> >-	}
> >-
> >-	if (vsi->type == ICE_VSI_PF)
> >-		ice_devlink_destroy_pf_port(pf);
> >-
> > 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
> > 		ice_rss_clean(vsi);
> > 
> > 	ice_vsi_close(vsi);
> > 	ice_vsi_decfg(vsi);
> > 
> >-	if (vsi->netdev) {
> >-		if (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state)) {
> >-			unregister_netdev(vsi->netdev);
> >-			clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
> >-		}
> >-		if (test_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state)) {
> >-			free_netdev(vsi->netdev);
> >-			vsi->netdev = NULL;
> >-			clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
> >-		}
> >-	}
> >-
> > 	/* retain SW VSI data structure since it is needed to unregister and
> > 	 * free VSI netdev when PF is not in reset recovery pending state,\
> > 	 * for ex: during rmmod.
> >-- 
> >2.41.0
> >
> >
> 

