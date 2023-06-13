Return-Path: <netdev+bounces-10388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0752D72E3D2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40CD81C20C6C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326E628C23;
	Tue, 13 Jun 2023 13:13:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7D522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:13:22 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24201AA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662000; x=1718198000;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UvMdC5dJH1lrVHYGzCUv7nrZGaFlJ6cvGUeZdeddDx4=;
  b=Yjv2ru5aBmc17K3odpeiNeEoDJfduWsZ/QZ8SfCRFI+5mUwUhpN+Kk/L
   L6HMvXqjx4/lTL+5l7tfYBPgTS98WscdCFjuhnWl4egIHhTr8UsIaNLid
   bHwxCF1ssfTIPCqCLnA/mWyMdNPqcZDqvbd4RH7kmb2gm0l1MIThuxWol
   MgE/1kvmKDEjtrFrtdWl1A6uzkB+IJgymk/zx2YYT3LLW43AUxVHJdeyp
   0MhDBAqwtzDc2NrPnXK3dWCICXbaCGIt5vbJSa/A+FvC4riPsh4O8XhXA
   Xh1GKUbf+Up+dUvfswkJQyn7adJDemZl5d6KD4OFjn2lLHf83/WVF2Cou
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="347978362"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="347978362"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="1041762164"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="1041762164"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 06:13:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:13:19 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:13:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:13:18 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:13:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbK4i3ZGhK8BKcJKwPechuj8C/5XvB4tdN0wy7XcQRjemVc3syTf0VTN/H9dzF6yRjneQO6yzkSNiQcPEJUpo7dB7How6pNdNS1RQxPk/NHLgbfAsuQ9qHqQgo1DabTI1080nAVIvKw/ImFaOcQk0IwVXrdHj8uqKJsRHwDF/C6cZbyMYu6roZjPWxUY73IKkkBdXHEW3NShojmaogVd80FwqjOg23Ul2VDm0AxEMfZRmVdkXn6Hn4U6MJYEahvqgBYf02I+uGwtClKb6sFDmzbaDmSed4AFaKP8TGZKDX4RO0Ix4bt+XfI9YZP98d7qEQkSsTUISO+Z3BjREIMMRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/Sfy8QQ9MQ3yNfJeBtqHeQMH19YnDjMIynMLm+bYWU=;
 b=DsRtnlKZRtS8NhT8SLDwdUXSQy0DcneFo/J07qnFLsahc/dtabXftwSmXbwRGfLf8p9I8/hhCyt8/4OuEQW2iMRN6he7EbNDZoT9dcLqrTYHVUMnoL8I1muna1wEJtfXPKQKfUd6LtNNiX1XyD04LiQAvXtuT36lhlGgRpe9Wc1fJFawM/yzKSvQhoh0ehZ2zQXLd5QHlBsCScyRgjtP4aHw2gZFpsytW+/q2DTkiE7ksWVp6xJq5OPgvSAPFfy0LyvT8RnoeP+7YrfmoDp0LyVuhWNOb38CzxkMbDuxhSVggQvJh1YmlkgPfNcYEAxR1V9MibvxtafL788jV61Q/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 LV8PR11MB8486.namprd11.prod.outlook.com (2603:10b6:408:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Tue, 13 Jun
 2023 13:13:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 13:13:16 +0000
Date: Tue, 13 Jun 2023 15:13:09 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <kuba@kernel.org>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next v2 3/3] ice: remove unnecessary check for old
 MAC == new MAC
Message-ID: <ZIhrZc0DT78eheL7@boxer>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-4-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230613122420.855486-4-piotrx.gardocki@intel.com>
X-ClientProxiedBy: FR2P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|LV8PR11MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: 0156c7f7-2c31-48ac-cca3-08db6c0ff2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Siay3Wc6MDErc0sxNczzwUSuD5knQjHgpdCt6uQ93u1BPzeuKMQV8IEqFgQ95l3MxLoCLSJvz2mjD0Dgk/DcHG4XY54oC//kwEG+sUQwJsaGwgOUJP8Xvh17znSBah53AtwID+g5Iy2NKq0pIaevLqnjxru4vRRiNPjojvs6RfMbWy8QnTEhAtJ8vRHCeaI8z8408by1iB80W+2vUb1oflPXel9uim365fbSXEynlHpZssRqI6cQtcyGmMiLsnjdP8MwJzAPmthjFe9aA4dTxFJ/svac1fLsEYFeuuTfIR5MdraNDK0Xr8oX5p1f/+ktO1gYwP71NVR1afCiZ0Z0CgA0DzZwlMaBSqzOPHgv14L2g5JzWitiY1jBR43OL2wWcwu7uMD2vsTSYTJgrFH5CqODjuWn+TdJxZvWucJUSMHAm2Xc8G3bSSoJp/3hvS3xn0IXroLA2y+D5456U+AJ7zOKUaJDD/yWC7w/Hn+AqR2UFhWD+AGFhCzvD7vYrvn+G7pi0id9fv4KP5tNy5BdrDIO3aN9DE9XGA2zWTdyPSfpwfqIhWIzg+D3GRWYBWDj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199021)(6636002)(66556008)(5660300002)(44832011)(82960400001)(86362001)(66476007)(41300700001)(8936002)(38100700002)(316002)(6862004)(8676002)(66946007)(4326008)(83380400001)(6486002)(6506007)(6512007)(9686003)(186003)(33716001)(2906002)(26005)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oeWkic+TS6etaQysaviKaZYolqJ4m3tM/J8XhHHhSq+GyCHm9N09qYQs9wSE?=
 =?us-ascii?Q?BBOEqvoyLMmVZ6148SSZHZy0Z80E+F6bfRJTNpKEVCSCGw5fro3HG+C9Oska?=
 =?us-ascii?Q?y5Adt//GDnSdLT7He+js7LXw10rrUckIdDIlA1gfdP0bopnXCyDLV8dTPGTj?=
 =?us-ascii?Q?m8YXTPL+wkiAslSpJPyzVvnMugK2F+827rcZ41oL+e0MPHVeyVGX/x8i+daN?=
 =?us-ascii?Q?6tQl7abwQOBi8Ksh6oTNpFBdLTNv9/1BKOUPZDpvOwLd2+956sdAL3Ahl8xq?=
 =?us-ascii?Q?DQ3BJDaMo3/FORnsAUSQCeWzj1I4ONBaotE8GgiiCPKcfGd4Zbw9KgkE0X/E?=
 =?us-ascii?Q?b14fmdNDGx8fE+hOooo2NnIz9fcKEUFOD02Ie8VXcn2Z0zuDjLjjiFygRX6k?=
 =?us-ascii?Q?0IKteyXdiKlJgCqtQ0Z0mLf5H6hCSDbmnnM3Zbhr4tCKFhU15Y3N5o9oOA6Q?=
 =?us-ascii?Q?ITBcDnJNaWrvhbZqNkvXk+dlCJ+nE1HmEs0/fKuKvuEsCJHIW/c9Ma8S2R0V?=
 =?us-ascii?Q?2bIgmfwE/D8je0YtLsmMYGg2wEMisfTmfI+FbNNRJkHzFFds/BckCLyx4U2R?=
 =?us-ascii?Q?0GuHCYKJ/pl+xVfj4K/5ipeCW79segJgueC56vO5fD6CNqjnrekoo7g+P050?=
 =?us-ascii?Q?zDFESibgczu73ImlWv57XGA32yvCs9Pj/FSSL0RoNVJYBwyLmg4XwE3zfT+T?=
 =?us-ascii?Q?dqpZhdb4r2jB9vPYvAZINcojpilgxxN1xw3Zdy649+DjkNB+yUAyh5+sjXTs?=
 =?us-ascii?Q?MCr/b7wLixdDu9Ia7+LTR0PHbWDdIwUPjtan4GEkETzwGsmjdZtzKfi8PrRp?=
 =?us-ascii?Q?iGRAQpfzglZWegmGlxt+X21KEs05aMR44S0YLkPWyGMeZdE4/Jx3rI0n1izi?=
 =?us-ascii?Q?Hd8eQpin3Ki6NdyUZJ8kF9aXrMzWlbkpulSpztKXB3BEE/K/o/wsnKAZ6601?=
 =?us-ascii?Q?Na7wHSLSmL4a9kH2j4unFZ4mJ8G2XPfKE+at80/mjych8VcuJ/vMA8ghO4kq?=
 =?us-ascii?Q?SosiT37N2t6mjsmDka+K3K1bBQjj4L80a6qOUL2lqMsQTgWm0xVi/IGgbwHA?=
 =?us-ascii?Q?uADjKQUbqTipYf2rDDj5fsKZitbgjQ2IYqkhG/fe88dI0vU9yWmpLjASCarR?=
 =?us-ascii?Q?4JqXV47x6LzJmbKuSIvltuq96UjZztb416+truYzcBgj/uu7DUTB6K8MD9oL?=
 =?us-ascii?Q?iwHbCqnyMGEZt3hHhH3z1DXFM5IyFivEeFxUnFuNuV2nRxfNnj+Xa1X3wQxU?=
 =?us-ascii?Q?1Dgfgq8sfLBfgSgbCWycpyADhLGbxnmzYhMDAe7b2oqL5BfwKGQYjWbrT4QA?=
 =?us-ascii?Q?sjY+kKaLQ3CrsQKlZZuHDCDezzRlBFEYvjiZlG3z3/qM/8e4zwTnZYG5Ne6A?=
 =?us-ascii?Q?hy+FNqnCV2mp454IhirpKhJJ1Z9sWKpvcmjjGWsDUaCtITKhfP5hEGt5woHQ?=
 =?us-ascii?Q?Q4RqugW73bC7bX1AR4hd6vMTglK684UOw7eacoNuaGB3AkxgDP6IGRnIO2rW?=
 =?us-ascii?Q?67/lmGij/LrNbLfmR6nq9mt+G6YJOeFhATEDGu83YQHW090pXXClp3EOvBuL?=
 =?us-ascii?Q?OZSmEUnQ+nCNoupJqrmKx75EPEbMbZcgzfS2zj2I7iBt8BDwGLkeXcx4SOyA?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0156c7f7-2c31-48ac-cca3-08db6c0ff2fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 13:13:16.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTKJ4/AqNkHruMImjGLZEsSi8dtg0Pa63k7TztQsdpoVnUfXeXUSKN89/U+qxdr0hGmwTG1l6p0skLQq1oJxpprAWzg1jZRnE+rT8S5ywho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8486
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:24:20PM +0200, Piotr Gardocki wrote:
> The check has been moved to core. The ndo_set_mac_address callback
> is not being called with new MAC address equal to the old one anymore.
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index caafb12d9cc7..f0ba896a3f46 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5624,11 +5624,6 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
>  	if (!is_valid_ether_addr(mac))
>  		return -EADDRNOTAVAIL;
>  
> -	if (ether_addr_equal(netdev->dev_addr, mac)) {
> -		netdev_dbg(netdev, "already using mac %pM\n", mac);
> -		return 0;
> -	}
> -
>  	if (test_bit(ICE_DOWN, pf->state) ||
>  	    ice_is_reset_in_progress(pf->state)) {
>  		netdev_err(netdev, "can't set mac %pM. device not ready\n",
> -- 
> 2.34.1
> 

