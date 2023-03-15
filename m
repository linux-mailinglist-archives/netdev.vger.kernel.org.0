Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2006BABE1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjCOJQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjCOJQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:16:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E3037B66
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678871762; x=1710407762;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WPupLqJ2U44oLmNzvCNQpNWHSE1gMygwUBGaWz2d2f0=;
  b=gIBtQIpOWtL5k89bKCHroV5nfkN8qaJfcc+/eUiwP32Q01lwY3cvgb6/
   VXHmXEwav3RUzrBmhIsKvy3dw8fzq31ycoWJZkOmTKFB6iQ8VxkWvo7lD
   cz21puKpa2K7NCfeTKczc1yRdDC9c0DH0ble08ciUhZ/VZ3fsp5O8zXD0
   TU84azEVL2eahqilJFPA82ZDFV/BVZW8LErCj9iXfmfqpvBLKmBfuX1Ga
   bGHosP/LojbJBSEAdlgeWz0CFJlSMOXys5xCUo1NRLBe6UGTHEuqFgcj9
   SG1JqWbKwZIxj8XSNJHokFPzKcBVl/w5UvT11nkwfAyV3Xlr43q5xsE7Z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365331965"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365331965"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:15:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803196341"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803196341"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 02:15:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:15:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:15:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:15:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yfzw/MKeWfCype29id1DYY4oSrV52v0LZ6NPQEAp6dFfoyLsydgqitcfppw+8rO90qHSnouvDtumS9U8cicMIwhqH/6p6ACd+NdmWltFZxem/3cSPuqCWPOKd4iX9oNiqjo3TiLBCDb/ZtAdt8mNczKr8TT6bdXQXbmhncAO5V3C/TILNu6+EP5kfzPXJROjEa+Otqxsd1HL2jFRG1Kkf76bb6Lxag1gdfrqmz6PX89GO4iStkyEHfbBxcpNxBKm2o7/3YM0OFOuPiX/oGaSn+kL8yXk+252ipw2I2PxRuKaHmDIsoJIEIfwT2/zJc1YekcVDZxtdu5gBqBjuhA1xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEFIBGuvPiEpg6LSRC1U9WAQ7l/ZIByo8nGbElwRzRw=;
 b=k8MCTYe5pwuP/X/8ACX6gNh3YEsrTGutR9gIA+yPlg5Wmh8VH0oxmux9mkdg+fedbSiBwbvMNPQieCJCYeWtQSk7jGYxj5ktV3X8lGrAOh4dCjwI1zlS56FYVu4MzCd2BkmHgUe7gfkwAiGNHqVe8QCsbdvWP0FpAgL3paAQlYgFjrGS8QgJ7zc/naCPb+UH7QZOVpdWLsPdsO2LUAC9ND10NzVaE+w4lf6QHLyuI33kHdE6psIX7bOn9EhrS9zLAfYNGTIG0ljIeSHwKJh7JfH1VERvHrtQwkqD45u6gJq2a8+trv+M5JS5c/AfgVsKqNtO0GXUATL7f70me/CHug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CH0PR11MB5394.namprd11.prod.outlook.com (2603:10b6:610:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 09:15:24 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 09:15:24 +0000
Date:   Wed, 15 Mar 2023 10:15:21 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Liang He <windhl@126.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] ethernet: sun: add check for the mdesc_grab()
Message-ID: <ZBGMqfPQiR84NkMQ@nimitz>
References: <20230315060021.1741151-1-windhl@126.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230315060021.1741151-1-windhl@126.com>
X-ClientProxiedBy: LO4P123CA0290.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::7) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CH0PR11MB5394:EE_
X-MS-Office365-Filtering-Correlation-Id: c236852a-a510-4620-4ac0-08db2535cf0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZlM6GJnI11tKzCs2Zm6hTTYvVPaUOaOzyLyU19PPwIK/xVa6tbms+lO2U37nD/oRRgtvnXG83yzuuHe/Ramj3LIgzDxOb9K33Pind9uz4Arsanr2SI1+2jYaoWOQNqYwbLOr3T/rIkkzcaj3FKg3zfRe2En/eFU+yVEZujcPvb7aBXxsYMctRRSaprmMboTXOoW/kxmijuwsNZpYgEexwxNtc4SZX8rlQOBvohnZTRzH3JTaDNS3kOtERPK6GCCiXhKHj2b6dQnrk66pzFGB77glRquqDbPQqGdLKc1j9NxAQhB2Dswcxmp/na1xniktVwp048limpP0HDwr9e0APAw12IEjiSIwTdynlosa3XQXwMF9nCvn3F6iXl+2zeHzroV+IYhiFPn4eQIqxgCvqMK13q/Jgvr/3MpSssCUPAGg4YeChzNd4zYyDH/mLZaqEzhsRdoHUTBH18x1dXuQrKFwi8ymvZ2irtgMt3Jd6Fj4oQBNpnU3cndwQFq5razIrrvCZHjPM1u4xSDuetBABMER+dpFnjeEc1QyY7RfR76oJPRysaOVMwzWQoSNNrX4HlAauBw8nWl7F8kH0s20vOvNL/J9RvSjWVvkSDLYSvYZHwOXtS1okTjr9nrRgiCZXuUpbCFl4SJ6ltvVAzwTLqeIkfD3AhruGMEkcbX440y3qpirmHtdOsUU5meYhwG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199018)(186003)(9686003)(6506007)(26005)(6512007)(86362001)(33716001)(6486002)(66556008)(66476007)(478600001)(66946007)(83380400001)(8676002)(316002)(6666004)(6916009)(41300700001)(4326008)(8936002)(5660300002)(2906002)(38100700002)(44832011)(82960400001)(525324003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/0pm/oD/x0pRfCW/XiqSSg4Ye56aiSkgYNI8KPjV55kF3ozCzEY6ka7BmSA?=
 =?us-ascii?Q?vvmON1zA0uqPVdSNUEOp563YCJEPvO8XwajRikFI68KJRmBn22EBu3wvg6GV?=
 =?us-ascii?Q?pLZU0CkmxmXdA68YNWzGzBASHPEH9JzqWgqIF5MkXcjHGN8Yp6W5hPfz1aL3?=
 =?us-ascii?Q?GCsN73hsdFLwtRs/R+5KcVHVCFqy9SDUTyDeCBpCobtsZIUkzqXb2ToRHS6Y?=
 =?us-ascii?Q?kJsO4i/jqPrik713LmP5IAJ8grWw3HBUjaFQme7toq+G76QnCtrVMCNT1ZdV?=
 =?us-ascii?Q?RGtMYfn/Xy8Y2aue+k4BbRnS35dxWOPSa7iLKRlV+Z03eMWrW2SePUViNcCY?=
 =?us-ascii?Q?8DPwOc0Q9BB54+duyOBr4hefjHTiQmpI8ClLWaEfiZdOFLlRtcOxbdRwqKFp?=
 =?us-ascii?Q?yStHsdMTScTWq7MxF4F+ZFbRbrHNcrX74UydZejY59UmkctLMUCUQd6naoB5?=
 =?us-ascii?Q?TGF2IJyPVNiE24YbS4AwfK3+eU90DGtIauaSaeLOrbgyefMuVqfppkQ/5uvZ?=
 =?us-ascii?Q?VGzrlOLD7GOhfW6zZAY5JtVJ3Ivm/G2BHTI5YPcjO09if5dO/gRMgiOoN8E9?=
 =?us-ascii?Q?wdCk5QZIe4qxDz38j2WQZS9uIrZ5zroX6K8RhJgxh/JQapYodZtcp4sFPUsZ?=
 =?us-ascii?Q?RbCfy7d/dcXI65HyDJJF1sLKwJr0STdD5KBEqO1KYO+kw2QdwxtHUhAMoG9o?=
 =?us-ascii?Q?XvGOEXU4bwjvSAAD4Cp9YitzVoirEvjbMw6UlEXuAStE0mW67pvvdQRTKgDT?=
 =?us-ascii?Q?L6U2lqOpN/p0hx//YmfxzcnNo0Y1mAU+M8J3bWG64r7MU1/A9W80gBWOHBRb?=
 =?us-ascii?Q?40eE+NucshWdQw2pSY1QzP3h9BToREfADlzz8F14Jrlboi9lsYV2/7opl+Ih?=
 =?us-ascii?Q?+0tUSF9cV3XMkBb6footfhQ0k9DJugnm2V4lwytYgFTWoDuSYqBhPSxKlMr8?=
 =?us-ascii?Q?5yFUGR7tPoi9LOn/cYS0u/X6ASZBQb/zTb4tPsAA8K6mtRhWHPi7qxVELuBV?=
 =?us-ascii?Q?YMPdEM4zfPAYMARY4hvqj7Sp9RaSABC0M0EendhfSrz32MbrT7EGOORIXXOT?=
 =?us-ascii?Q?1Y4xKCv8OcLffR0Hj6jUC8roy/7VAz8k0JHQw2CHKwVzwQi8jG3NukL2e+q5?=
 =?us-ascii?Q?N2NRxDu4gGZozIZNkDBaL+1MvixLuJuHCJ1vbe+s77xUkqYUuJbGePeqdsIY?=
 =?us-ascii?Q?hITuRQaEsKuKfW2FitpiAewNFwU9ChEFgOZW1C9oRxH+zIPBGqC9emtoeF7U?=
 =?us-ascii?Q?JQHqgBwEsMxPeIs4wVrR5TSFz1tETYDSf0EIJE8iDnNxkndKFFaLfCpF8/cy?=
 =?us-ascii?Q?zT0cbGm477Pr8Wy9Lr8ivqOiaNATjTLeb1MKIwGiYGHtSdMl6fzvG3kzN763?=
 =?us-ascii?Q?sM+X5p+Vwn0MGsfnat/oO8s4gVALx+lK4YEIXw2Hjn4/VQAqsdzpaz41qL1r?=
 =?us-ascii?Q?iZ1hmrrrcdBZvfxZAT9eiKi+NZqDDLrEN+k+xlQBQKTsKsfdImkPIMnJEGbZ?=
 =?us-ascii?Q?8SpPToeGueaKTmJcPcmOe70Xm787fHVDzg2/Rv8FVY5PnNVMaPrjfsG7Ay2c?=
 =?us-ascii?Q?RHgAbU/DtLDNsqxNMWkLBfu7TlR/5fjRpZh6vThQ57O2Gyg4ZZqul/Xm9gWh?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c236852a-a510-4620-4ac0-08db2535cf0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:15:24.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NYUULjjZO4DFVd/Z+2K5+JJI9HPnOVmSxrn5mkj/CXpiVmjD+f8Dmi+aZ9FAykiU9ZiZnerRKSiPbi6tWpCZ2DM/Ua0Oy9fsoVz+uE7Ipk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5394
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:00:21PM +0800, Liang He wrote:
> In vnet_port_probe() and vsw_port_probe(), we should
> check the return value of mdesc_grab() as it may
> return NULL which can caused NPD bugs.
> 
> Fixes: 5d01fa0c6bd8 ("ldmvsw: Add ldmvsw.c driver code")
> Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/net/ethernet/sun/ldmvsw.c  | 3 +++
>  drivers/net/ethernet/sun/sunvnet.c | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
> index 8addee6d04bd..734a817d3c94 100644
> --- a/drivers/net/ethernet/sun/ldmvsw.c
> +++ b/drivers/net/ethernet/sun/ldmvsw.c
> @@ -287,6 +287,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  
>  	hp = mdesc_grab();
>  
> +	if (!hp)
> +		return -ENODEV;
> +
>  	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
>  	err = -ENODEV;
>  	if (!rmac) {
> diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
> index fe86fbd58586..e220620d0ffc 100644
> --- a/drivers/net/ethernet/sun/sunvnet.c
> +++ b/drivers/net/ethernet/sun/sunvnet.c
> @@ -433,6 +433,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  
>  	hp = mdesc_grab();
>  
> +	if (!hp)
> +		return -ENODEV;
> +
>  	vp = vnet_find_parent(hp, vdev->mp, vdev);
>  	if (IS_ERR(vp)) {
>  		pr_err("Cannot find port parent vnet\n");
> -- 
> 2.25.1
> 
Perfectly valid checks, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
