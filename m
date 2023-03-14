Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707ED6B9A75
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCNP5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCNP53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:57:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8E28F70A;
        Tue, 14 Mar 2023 08:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678809448; x=1710345448;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mdSFqdWtrMdOJHI6ftYayg8Hob+j3FeXcPwydiXvBTs=;
  b=dCQn+UMvZwFnVgy59dzNJHwtD26nTn3Jx12EG6Pl4AP9ATSM+i/pLnJt
   VNa+8ybD4wpAIz9rJJU4CjfIu6CszivTyTlmdOhr8PzoBBni/yWtrSBft
   q4zEbB5mo0R73/z1TLI6QKduyofMa2RPSGZojF6PcfLrm6kNzCEzVYo+T
   VbFDp1zoQkgjuOerhcvXVVIdYnm60NPUvDW+5OMunemqQqike7QWJ1hRe
   XG4DByr+mDxm3VDDczHxfcxrpVGGb2neLQ4iaDjzP+7QloapQyEwfQbeH
   dIf/MCzD1bOYh+Dhzgn+bFdtiVRpdV9yH2Y01xvR6GcBKBT7G9ufnLFpx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="334952215"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="334952215"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711568571"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="711568571"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 08:57:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:57:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:57:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 08:57:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 08:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChITdzJtKPXDhxPaTHSML2DnBdMVGjUxlWw4H/H1DttOBoNL0xtxRVIgi6ZE53G5bHFxYgvrcWzmU8oLufpipx8LnrEWTQKU7J0xcJFkyYTqOrj3t7ioo5BxeLI9TqOm7QWqp7ccb08236AaIA37Cjyx83EIOjro3cqmnBJNk5GegYblNUdrOXsTXEy58wH2MN/rZY/Lcw0RwMmpJeD2/nehj74n67utGAfYS4N4ti5I049rx3+pffOURphj3o+XnZ7hcTSN+YskSZw47CuL4K931CxPuSU6GjZJyCgryvcB7B+NUQMoEMOUXmVB3oWnf5fTKyCqgfL3GoNfMAsiFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvtdUNwDy0/u2rX0AP97YpNERWnIJ3ZEro3b24+b//E=;
 b=W+GWgQsYApLCvQtKd/NAywpYkQGEw+lkU3lWIwlpSbqwLrvRFCCy7yGzBlx3lVLaDyQ+H+FCYzcjMMoBdtEqc/F2ZYQvd+t792IlCr56JDvj1nISIvstcwo686GBWsmFq8vUvYNjGGmYaCsbD/FBPmcl3aBe1sZLH9gBKIi1fgEiNqALj1tuktlUkzlSAiSGAuYqkt1WH8a0GOvJ+jHvD7ctSUtM2tFkTpzGSmWhYrAHAw5DhvW32WDfpbpjwzYP7lepiior76HBdmiYQJx+fsgDoN5JGiSpPBdUOjHF+DFlcc94PJChLx0fJtGZrK7Nx4ypFQKSXWeYZFDbvhFsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH8PR11MB7144.namprd11.prod.outlook.com (2603:10b6:510:22c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 15:57:04 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:57:04 +0000
Date:   Tue, 14 Mar 2023 16:56:53 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 0/4] net: set 'mac_managed_pm' at probe time
Message-ID: <ZBCZRYSOCBvG8O2u@localhost.localdomain>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: FR3P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::6) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH8PR11MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5eb03b-ecf0-4333-0f95-08db24a4c17c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEjXzGiIu3ose+l2M1PrQzrn0EDNIPTQdXQ0bWW0DbiwBxgzCJ0ww+uR2GQGRdKIPS4w+B6YC7UDLnshSe7voYeGUXhzYsiUF0/7OZSMumJj7bW2smdBXvfoZQXOtt4LKjMqQuqajinwR9KKad8pygL/56qO/teQcNu1RyS+vdyAr4O4jbr45dzjdNUraveRcxZC9j/147E0aWZ1MCyZ6o2wa/RZ38xPQ91VbXCRQDSRrfDA0mvOJSCSXb8hldvlDH2meJM5koxb0a9VGlXJP/hmHBIYxLJymjj2/F0s/toKypuSvjdYcc2jGpp7iaIoFGkTyKFCqlQw6zqi0uYu0P7osiAmGkmAqzYoKBPNyNC3gAsgWKJWRAxLlKh7Hz2kTdzbcoNJOmP0+Cc2hQ7FV0Of1iUlc+QcOK5dogxhm+G5jAtQkWhauk3SIZIzBRE1X3089rK4pIKp7IS0wK/IKDy9ilTeyGC7qpsrMmYApOZl+sVtGEVI4Dh7SRmb4tTlFZqcsrASewbQvj9t+95kUR37oWwhj6Og2v6ucdloOBmGJouEAdljjomJQYAKO+No26mdBCvOqaw4QMqEWU3ggBFQx/3S9SgMUuS1Iy6v2pBApj1kfW2SnwpNgo3++bZxiMihzUcDHE2PZJZJSXCvGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199018)(66899018)(2906002)(82960400001)(83380400001)(5660300002)(44832011)(66476007)(66946007)(41300700001)(8676002)(8936002)(4326008)(38100700002)(316002)(86362001)(478600001)(66556008)(186003)(9686003)(6506007)(6512007)(26005)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z4O95wUWOFe4xhXwsl/R64EiDM1atpHoGatqg7GA6YXBR4ujx7R82qLpxpPd?=
 =?us-ascii?Q?tZe/N1/8TcQmcUEBkkrVildzlGJED604TPVNQM1UIcW6NhyLWv3UltXKgl53?=
 =?us-ascii?Q?aQSZNRgZ+67ot4lM6cd7u+S0pO3tnmHLTNGZLh2IsEJqKhjg1M38WHo0Mclv?=
 =?us-ascii?Q?eGOVTvU62UeDpp0MbErMhf+lxCxhvsJh/BkoncigNMgab4szKEqaLjQF8fOk?=
 =?us-ascii?Q?OtdNhTHNTELtAtGo4PPf9cipeFmYemiKbGaOQqsS5O8inXUMKAsVisXOsMF0?=
 =?us-ascii?Q?RmdfMOfXpItgyONn6nRoEtqXaEDgWMcJw8qir67D/DYXmnSooeKOIdwVYaMs?=
 =?us-ascii?Q?MQpAUKv8OEc+J8lO+DgFi+noe3MMI5ydnfedJ1jOjfmbKCHgT22ejOZ7+USA?=
 =?us-ascii?Q?ZzU2LV+/na6w9AuwPrbVCg/UDNEstROc6mZKXJRUGRa3trmpy5pjgIcFHWjy?=
 =?us-ascii?Q?O929YxbREEDiQERqPsiLbPMnnB8dApxzFiTD8sB/PVsL5+79a06gg0EzQEhC?=
 =?us-ascii?Q?fgCul93PeVesagyvEPLMSG4TTM9c8nG1XG4tTWB97Wo5rdNjBI7zHGLxdMH0?=
 =?us-ascii?Q?61pwp22kQZk5uy1xuw7ILp8DqwdQ1K87//LGphoN69A7QOxpvNfDDtqlyUk9?=
 =?us-ascii?Q?NePnyQ45z+vWkaQ6SldTBPsi592Z5fBBBPJ1aMbOF50XFr8zIIt2z3HFGlnO?=
 =?us-ascii?Q?z0+9oZjci1Bu+jWg0YG4Cv2EpFslXj9I5rY2V9n/zHGUsVuXLmKFQsm59rhv?=
 =?us-ascii?Q?1IXfv56OfrBfqboo5hiBRzHy74DMAh2nsf3aIJyBHNhFUmCjx8B72pRrbpzj?=
 =?us-ascii?Q?F5gPh66OQS5pokMQP17w10ygpGNKZ6T83pgKlGL9A5h0ltJqcpzJl/EKtAi8?=
 =?us-ascii?Q?XSSgSbHM9mWUsiJgd9FSc4iTgHuVVBg0pZ8hjlaWWegP2m02h4yxuJZhFlOl?=
 =?us-ascii?Q?cnG0gPwLLeaa836sDySgVi4h7aJF6+66bjgzZPuxUZ/IeMszT3FTHnUXZorh?=
 =?us-ascii?Q?TaUNZMaczhwO8U3Zd7tJ4WtgavHDlZxZbuxdB6160PG58QL3WNLbzzOavOsX?=
 =?us-ascii?Q?ta/xBDGROxVGYCySPpxqEQIxF7mAYclVW/WhPXqZG3FFa8h1pM9Hd5DLrjhz?=
 =?us-ascii?Q?OYMpReOZFWsndndAldGa2pkLyZb4xSUNJJZjok7mZ+0L8oGICajjF+Ms3Q2K?=
 =?us-ascii?Q?nepvnsgomz18AdzlGU+D/MQaO6pWknIVIQD+cKTvVcjd+/xTTdZEgqf+I5E1?=
 =?us-ascii?Q?esp7SB3Z1JM3GkwimQbsmHPFd7kcAxYXV4ECnyYwqeBZWy0l+XeeRh5YWdB6?=
 =?us-ascii?Q?VA+2qpYbHRsL09OCwaViOIZ7hNXzd2zM6+JK4MvG4tmLlsdDNhYNiGxUl/4u?=
 =?us-ascii?Q?af+pE2UmiNxs+EDWC4yIwXFGOgVGlAV6yC/0M+GsXlUqw4TBtmsAkdpif7wL?=
 =?us-ascii?Q?psdyv8ZRUfdL5TPIh5jl1/b7VDANgh1kgt6yg5h+otSV1uKRmmHcyVo6URpz?=
 =?us-ascii?Q?pTqVutViv54Jh+5GESg+XSzEXyySc8RVjJJbHO9LAPXJuquDpdPQvNjdxOZ2?=
 =?us-ascii?Q?57cBTZoY9MWCLTaKNhKAKNTS1O0LZQHPXhxIGJXe0GafbYlrCe+FM4G0rwzT?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5eb03b-ecf0-4333-0f95-08db24a4c17c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:57:04.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIUGvymTcdf7x0aZDpvOfdrUNOAzTSyLjkprcbMDbBiHcXS+hQACwm8nPefT9wVG3/arBLIcqupB9IDUmobgHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7144
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:14:38PM +0100, Wolfram Sang wrote:
> When suspending/resuming an interface which was not up, we saw mdiobus
> related PM handling despite 'mac_managed_pm' being set for RAVB/SH_ETH.
> Heiner kindly suggested the fix to set this flag at probe time, not at
> init/open time. I implemented his suggestion and it works fine on these
> two Renesas drivers. These are patches 1+2.
> 
> I then looked which other drivers could be affected by the same problem.
> I could only identify two where I am quite sure. Because I don't have
> any HW, I opted to at least add a FIXME and send this out as patches
> 3+4. Ideally, they will never need to go upstream because the relevant
> people will see their patch and do something like I did for patches 1+2.
> 
> Looking forward to comments. Thanks and happy hacking!
> 
> 
> Wolfram Sang (4):
>   ravb: avoid PHY being resumed when interface is not up
>   sh_eth: avoid PHY being resumed when interface is not up
>   fec: add FIXME to move 'mac_managed_pm' to probe
>   smsc911x: add FIXME to move 'mac_managed_pm' to probe
> 
>  drivers/net/ethernet/freescale/fec_main.c |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c  | 12 ++++++++++--
>  drivers/net/ethernet/renesas/sh_eth.c     | 12 ++++++++++--
>  drivers/net/ethernet/smsc/smsc911x.c      |  1 +
>  4 files changed, 22 insertions(+), 4 deletions(-)
> 
> -- 
> 2.30.2
> 

Unfortunately, I wasn't able to check the series in terms of content, but
I have no objections to the logic and coding style.

For the series.
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Thanks,
Michal
