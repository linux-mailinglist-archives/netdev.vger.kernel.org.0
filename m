Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF326E9C9E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjDTTrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTTrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:47:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584D340F0;
        Thu, 20 Apr 2023 12:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682020040; x=1713556040;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ucDqd/Hd6NzqqPKXvTnruKH6ZRDqKF7jDecsk0v9ocs=;
  b=e/yE8L4jz/aPtLQR7NbznCbpIHR3xfcsYeaxvzPgKhdswkAZJxm2/MqO
   PJReqUDoryBlHNYe6Mmqad6wMsajqLBH4ds1D7edyZxFuVnNg4i1DzPcJ
   irsQhH2O8L8BMEPCLLttastzAm5SnAMeeYNw2T4r2mcz/7WEhJ1yKum+4
   azoqRqxNVmAlPR1z4AI6Y5WrUaER5TirnpFFzzMdzURMRb8X/4D2TZ+cb
   y8SUsaD9/x1crcjQPDowEazRktArLqk8K3s0/g3g52x5pXC1KqE8n4QhL
   bdDAVqCXYECGQJB2Q/LOFyC+us0mGBzl1pFQw4gUbnF9ACvv4tACP9ejc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="325441821"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="325441821"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 12:47:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="642248658"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="642248658"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2023 12:47:19 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 12:47:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 12:47:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 12:47:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JApuTegbHdpX0hBFX9vE7+sXDILgjlUhppzaFp9fPAKRnqjOY+nUFDN6td1+MQDEz5o1pqfT0lwAlwFHf6zEAN4jItw6yeRY8MSQe5aJNGmSlAYJflxu8eVbfb/TFJy31GiF+JbcKaJpts5eGqRH95QUACrDJgzGYbNOEAkyM+IX7LgrTjREMXESCQxDsdjFni757rK+SLZNu8dsVosUxopFOr4aU4NpY3MCwbUe1WL/rgdlD2SXJmi5vUG2tY4MHi1Q7pCg2Vz7LkLYefKIxjB2Hnj6vG5Eg+V3/i/29Gw5278KW4E1akzAxXMArq2UxQxEPrpmsX1VxhzXSb+O5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teF3wVHj4XuVsOFQALC0eIC8SJY/RSMqKvy22QiBPmo=;
 b=m9AgmHrhWEz6sdAc7OLvatIOOovzsP2VF6BAs/zgbyqWgkkPQzp0f6+Kn3VKzWWUyDUEi5VRpyOzZoYRBfxkgBUmijqySgHZnxJGmfSJhlC7kqGahx2um67twkg6emUvg3Ge72Ov+pL/9U1Frvl7iZ1ORxIh/91YxJrFK0tEUvZSValHz5Q/HAURLVUDEmK91vJMsyOqum3jK34EjYKrEIrAJ2K/5DGEs+GIf937+3+lG+OJYepAznVMQh5jAgVy191fzUOGe3l2ttajw9Gx5cHWPDrPJD+w2xo4hrRHIbJjhv1tP+BTiqNgRPF5xG8Dq11X/Mzg+2niLVmIAxcM1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB6246.namprd11.prod.outlook.com (2603:10b6:8:99::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 20 Apr 2023 19:47:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 19:47:16 +0000
Date:   Thu, 20 Apr 2023 21:46:33 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 5/6] tsnep: Add XDP socket zero-copy RX
 support
Message-ID: <ZEGWmYmsM2uV48Lh@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-6-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230418190459.19326-6-gerhard@engleder-embedded.com>
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: d865541e-731a-4d5d-8a94-08db41d80b2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zvn+kjB9nXtSmPYYnsq7k9KbeoYcRiK31cq/DvzB/8xdimm0I8VWEaWu6+IkLZn+QhYgTmfKsY0bT0Rh4QO7/D90xbyQQGIPtynN7RQayaK5o/VKdHEJo6+lkj59PqVslFWioCKXRU5ZPenu0uOAiN5s/jm9/NBYum+jGTruF9Zr1f/mDFQ8/HavFr1erje1t28tJU+RFGQSmfRnlea888mVQg6qtBlmnohiKG2+mJhpR1rhmHgyaO8SMCkFX7LMy1XdJ2vebGGThsc6yYaFTGXVaxNpFCuSXqv6vvxcM9upzGymLadPsJhg23sOSOoCsk2YAOIGG4o76Egw+lm6W+iURNS6hc+LgFYra0x7/tpkiusW21zQBhy9ttmZLLHQ3ZOcKRPyzOleQ2khs916dv4pf7wrJEZkTEhePZ/cfHbAZ6Hn8pZtbCjCcPTSCF00oIC9RkWGhoZ2S2wAqL4AtBQIrwiIDEHGDPjv7vkCTkZra6hZn2XrKpt3LuDkyKkSmH7cqFwKEwwE5lZG16zXYdqaaWPd8VBoHM76eQ28LzEJdizUH0HT6Gb38k/zsgI/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(26005)(186003)(8676002)(38100700002)(9686003)(8936002)(6512007)(6506007)(478600001)(316002)(33716001)(66476007)(4326008)(66946007)(66556008)(6916009)(6666004)(6486002)(86362001)(82960400001)(41300700001)(44832011)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mKOBd4XLjDRyMaRdcCFeglCKsULNO2TDdGss+2EHCGDG6gfxjf8Q7c6bhIUi?=
 =?us-ascii?Q?bn4/2VFGqNszRgz55khkjYs+DYP7Yy2XrOhgdRMN+1xCsfn1G+R1lp+Aoy9D?=
 =?us-ascii?Q?+nr/LNHxlM95K7f4oy0oIfAjHXFN3b3/KLAEocAzlSHt24sTVA3tRcAaaNVi?=
 =?us-ascii?Q?0FM2yrVcrrvX7GSXZIFviP2wpAX3Pdml/vjtZeFI3i4oxfmZD3AlQ6MOjq9h?=
 =?us-ascii?Q?xDscFUCWRZLGZF1rm9f2x3MeNvYxpQwuTD8cTrp/5PzaTsrlvb9rshOOCejJ?=
 =?us-ascii?Q?jsvLubhpgyNcwxirv28X2v3cO+fW+BB/CD2xVj89Ckc3gqH1vkwnW6Vj447A?=
 =?us-ascii?Q?HdLWW/FYjkL9/sJWRD0k46PMgO9ZHIwQ2wLIQqM28niVzNpcc31SVj9e6eda?=
 =?us-ascii?Q?C+Va7DKDGVle+wMWunjYi26qVcijqVWKyiouDC5BYmimbQZKrGCan7K1QLnL?=
 =?us-ascii?Q?lYQqijgpjlnALS8iNKbe4SPM30J2tkVyzzdT5JaiGXZQDy8saZdM0gpsJDY5?=
 =?us-ascii?Q?hitCNPE9W6mErybPzLvkMILvD/za5ZsfTYH/ESMni3YpIgjhk4g6j//l0WEF?=
 =?us-ascii?Q?h3sPzyg3b9jtuxI0BmtLxm6vJwEYjTtsBFuUYnbR+qsDmJkfMK3YJmIrzsxJ?=
 =?us-ascii?Q?UPYt6OLDdRToG/q1DmT12dVDZCW2JoLS2CDCM3n8q1eXNnhYJrGLTEw3VOJk?=
 =?us-ascii?Q?ANvy44rnm+0Z9isc8TY19I+hreiKUIJHkrwaBP7U3rn77YCWXrVwQXPSIcVl?=
 =?us-ascii?Q?7PzXtz3Naunxt0v7NR+8SYDJseA6R9aH1jOg8u/3DorXwMCw45FREk9jGviH?=
 =?us-ascii?Q?xhiVfC6NYZ8e0VqnofwFm1IzdM7Cdy4yaxFnpMpi/wuoR6QuZOBVA4It3y/d?=
 =?us-ascii?Q?fsMwS6Ry628o2duEAkQDODnuNsHs2rIK3BV8EeF+nCTgt2dNAB4xymqfHxPb?=
 =?us-ascii?Q?2ytXaqmQfPIZWmIQ0yY9FyKtqdh6GDYnbt39hp9pKsMLyXZPs5FOoV9dLBM5?=
 =?us-ascii?Q?g1yZDX6XrF1PfPUlVd//7ps/QrM18oLVWh1efuDscYJFbTplQ40dCoVgXZdt?=
 =?us-ascii?Q?6Esa29dBv9lra/8eDd9A43M4pWg5T5a5/qikVCyPPIcqWhnzH4aNKRQCJMJ0?=
 =?us-ascii?Q?YIvUxyZ/Qab/nyscGBlyl7iO7j05ONS9VDT+smU2soKfYyahUMpkk6fkh/60?=
 =?us-ascii?Q?O8wCJivERt7kIKk5OURBIMGamJb7LYQZyxDme3DnXpPWdwAUW00gKM8XcWxC?=
 =?us-ascii?Q?W32JnnOAbJTSM/5LiJW+rxbXf/8gnJ7A0W6QHm/lL1CCq+g3TVEez31IkCaj?=
 =?us-ascii?Q?MSKhPpywQpUq1Z1uvEp9fF/jHwdQf7zqzmZ2OLLcmWFX88HqM5jCpjgeMX/i?=
 =?us-ascii?Q?yI5wi/mrQ7f6k2jxN3Wuyk7ZlHsGbDkvqVjE7X2B9FW+p2lrwnWmXXs2c6m1?=
 =?us-ascii?Q?4c2l7Oj54rJ9+/lfVZd4lcw+mfs6otOVa3kyY/9utR5jLSrv8gshggQQrPGz?=
 =?us-ascii?Q?tlZexZJsVBjqQg+pyeKEdTlvU1yIttZqBF8AJbwN5M8hwq5kkeeqDz2/e7dC?=
 =?us-ascii?Q?VVQBjHLt4CW4yy4TFg7z8Y57DrPFHB2LEC+b++K9FSpgMBD3mFXRGnSfwgE7?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d865541e-731a-4d5d-8a94-08db41d80b2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 19:47:16.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agzS/G1+QLFwoYBPq4pGv0s0fcPF2iIWWGGz7hLuo7pPhH0wEGWeMEA+5IBnI9J9q/9VpByqHVmOwzsDcusZXkMFoOihdl+Bh4+4px8+Gzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:04:58PM +0200, Gerhard Engleder wrote:
> Add support for XSK zero-copy to RX path. The setup of the XSK pool can
> be done at runtime. If the netdev is running, then the queue must be
> disabled and enabled during reconfiguration. This can be done easily
> with functions introduced in previous commits.
> 
> A more important property is that, if the netdev is running, then the
> setup of the XSK pool shall not stop the netdev in case of errors. A
> broken netdev after a failed XSK pool setup is bad behavior. Therefore,
> the allocation and setup of resources during XSK pool setup is done only
> before any queue is disabled. Additionally, freeing and later allocation
> of resources is eliminated in some cases. Page pool entries are kept for
> later use. Two memory models are registered in parallel. As a result,
> the XSK pool setup cannot fail during queue reconfiguration.
> 
> In contrast to other drivers, XSK pool setup and XDP BPF program setup
> are separate actions. XSK pool setup can be done without any XDP BPF
> program. The XDP BPF program can be added, removed or changed without
> any reconfiguration of the XSK pool.
> 
> Test results with A53 1.2GHz:
> 
> xdpsock rxdrop copy mode:
>                    pps            pkts           1.00
> rx                 856,054        10,625,775
> Two CPUs with both 100% utilization.
> 
> xdpsock rxdrop zero-copy mode:
>                    pps            pkts           1.00
> rx                 889,388        4,615,284
> Two CPUs with 100% and 20% utilization.
> 
> xdpsock l2fwd copy mode:
>                    pps            pkts           1.00
> rx                 248,985        7,315,885
> tx                 248,921        7,315,885
> Two CPUs with 100% and 10% utilization.
> 
> xdpsock l2fwd zero-copy mode:
>                    pps            pkts           1.00
> rx                 254,735        3,039,456
> tx                 254,735        3,039,456
> Two CPUs with 100% and 4% utilization.

Thanks for sharing the numbers. This is for 64 byte frames?

> 
> Packet rate increases and CPU utilization is reduced in both cases.
> 100% CPU load seems to the base load. This load is consumed by ksoftirqd
> just for dropping the generated packets without xdpsock running.
> 
> Using batch API reduced CPU utilization slightly, but measurements are
> not stable enough to provide meaningful numbers.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  13 +-
>  drivers/net/ethernet/engleder/tsnep_main.c | 494 ++++++++++++++++++++-
>  drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 +++
>  3 files changed, 558 insertions(+), 15 deletions(-)
> 

(...)

>  static const struct net_device_ops tsnep_netdev_ops = {
>  	.ndo_open = tsnep_netdev_open,
>  	.ndo_stop = tsnep_netdev_close,
> @@ -1713,6 +2177,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
>  	.ndo_setup_tc = tsnep_tc_setup,
>  	.ndo_bpf = tsnep_netdev_bpf,
>  	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
> +	.ndo_xsk_wakeup = tsnep_netdev_xsk_wakeup,
>  };
>  
>  static int tsnep_mac_init(struct tsnep_adapter *adapter)
> @@ -1973,7 +2438,8 @@ static int tsnep_probe(struct platform_device *pdev)
>  
>  	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
>  			       NETDEV_XDP_ACT_NDO_XMIT |
> -			       NETDEV_XDP_ACT_NDO_XMIT_SG;
> +			       NETDEV_XDP_ACT_NDO_XMIT_SG |
> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY;

In theory enabling this feature here before implementing Tx ZC can expose
you to some broken behavior, so just for the sake of completeness, i would
move this to Tx ZC patch.

>  
