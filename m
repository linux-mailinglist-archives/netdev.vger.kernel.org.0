Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB463A5C8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiK1KMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiK1KMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:12:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7A5F45;
        Mon, 28 Nov 2022 02:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669630354; x=1701166354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kTay5PkspGrQwnYxWuD+Ru2F83hd7Hmk8HzATrxn/r8=;
  b=ny/dgkjm1CDGY0Wan7b8I7N7m1OMvJqAFwTwh8XVQy36tVlczV428t8C
   MU+cMizUdJrGsffNLyUmcpilI/mApaCtjVweuJnarWUMlGZuia5j2x66u
   nEeAPIN59SCi7So08WOlzGPR8g3HTGgaONljJU9yaiqdOTgKv9XhCtb4z
   P1vHL56u9mUucicptVItS5BsE8DYtB18OpNjglgBYNO+idtsh+InLfEOm
   g2U+S8bgBn9AAHa77fwEE+JwsG5z1jxJ1EOMtMnssVLeab0o9dpBuwW1u
   Dqv4jdeV68YSZKdRsUAxddIEUoyqivlcc4PDScUI9k8Wlf5Wt17YiwhPc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="298151816"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="298151816"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 02:11:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="888360188"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="888360188"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 02:11:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 02:11:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 02:11:39 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 02:11:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhOWelea+77W8FkgqqtfIusO7wCCdDhhotxR785dv8a9MQ/M52a3Y3BlO2dq3PyZMGwuvKamvbAa9y9WwGG+KLSF36gAQ0XFTBQ0Y1SGVLiRDTgjyL5mXGdWBVnIOi2SYA4O6KUieBRCCVSh8hIk3Vy6OI4T8xUaatsN+I+IasO1e4Dw+gjoa6gdkrnFOR8nxEuCmwQwNil1eSIX7L0LHrxJaZIV3nscMP/XFWNSOn+Nwrw2823KE/JYkmflejTkNE8wsD0qf1VWkgbeYwpS64xTVSWXdb8Ys00+yUL4wPtQtDNwmKOopMDV2q1qeX6azIkYpbfbsn8OjTwQresUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmnLixmv6mIFKs+zEHz5vyq1LDtYBJaefrOYxerS5eA=;
 b=b4KhSKVXLkqAhS23MKS1KEmbiiectXFHGtJ0A4fg5J5ePjqBR5dfPdbeiZ0DmgViPBNnVXVxRRKLCGn2p3EZb0E0a7h2+FLHF/LQn2be5NLQSBcVPVOD3t/v1ahCu9Fzc+Rai3kPTARQs7CF/Lj9Pa2VH97ROKUnwADV2lkNEu80l1iSrEkY8J9SQN/0Goyc88JibQuNDpQZpSwmeoj+MXFQHrY0FZPDkom49fWsvHnqdZBfb0uOkZD1gCmw+Po59slS4DZFCzm2iizR7LaSpjPaNXsrPq7+BlaUuwEbUD4gs8wDqxBiP/HgZbaDdntYBnkj1BBZteibuh8W7NAg5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 10:11:37 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 10:11:37 +0000
Date:   Mon, 28 Nov 2022 11:11:30 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Roger Quadros <rogerq@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 5/6] net: ethernet: ti: am65-cpsw: retain
 PORT_VLAN_REG after suspend/resume
Message-ID: <Y4SJUgm5KXA5BdAE@boxer>
References: <20221123124835.18937-1-rogerq@kernel.org>
 <20221123124835.18937-6-rogerq@kernel.org>
 <Y4DBTbVxUpbJ5sEl@boxer>
 <d20d3b73-38b4-fb06-2daa-125f446aeb44@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d20d3b73-38b4-fb06-2daa-125f446aeb44@kernel.org>
X-ClientProxiedBy: FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d356995-92d5-44e7-a377-08dad128ef47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoiMrCQnkMjpASTwILTeUUUroPAaZog9QjM3bEY1LG04wZEReTpOVLoE+CcuYfC/Oq12a4J8dh/pgW0PbXZtbQhjBTO8qvbR23EzOiEEyFn+0Pkb4Qgvx/TmiqKLXYmfmOMItzYrTDRDfHDHiYf8WwAM8+BjEvKNK2/JIRb5EgCgWvPShflIxg1MTngKFOC4BXbMzHJdkhZq+5+dkJlUbrNw1UxQE8I0FswL2GmGLmIhBrgPgf9EqfTKM0oVOEHouUKO9oScqkZf0zdnLuAsxjqYHd1YxmAPJXyPNBpyqPEymmqiYkM+r7YO3R1nZPhtShsrevwvRO6A1ki/rbPtug8vxHan5fJ3/PF8fU8D8XI6zeKFdwTiG9tFlZOIQtBKAe6XZ24dWCNY1QdVr7IGwsbwQNqWRQckX8lP2fgzEUVWDaOa/AYUypRrtFr8UY2cJOKNukk4ly3Hdwf0rhxuz2eT48EYznqQPAwMhQ1cQXfiX4cRIDIh6UOdscEVLuHzXNCc2khVcrfRgGz+xouChDaErIFyhwc9zyYrY4bvlt2YciSq2rCNlSGFg0V0XGJMvOKsM+CLXQwx4XwZK+HfaZbdv9lo+DxtaRoJlNjQkIQhvlSz+Clk73MuvGS8xmu0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199015)(2906002)(15650500001)(8936002)(44832011)(5660300002)(6916009)(41300700001)(316002)(478600001)(83380400001)(4326008)(8676002)(66556008)(66946007)(6486002)(66476007)(33716001)(26005)(186003)(6666004)(6506007)(6512007)(9686003)(86362001)(82960400001)(38100700002)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5BqC9+DUWw4QvA94lJmyhbikfBQYAWqJ3541euwFeGf7yBsRwSxKpZcFhAv?=
 =?us-ascii?Q?b/BeXdYJZzDCYaGxq9ikm1T61q0yg30cLVp37y/7kD2myzQZIu6RZNNKLBnL?=
 =?us-ascii?Q?d6VceyhSauCOSmCas6y49f6lffOZnzIwYE5nySUdMl5O5XUyKglWvnYauUjW?=
 =?us-ascii?Q?hBjjnCuJgVkgc8abcj89pMOaj/dCJ88I0axdZN9wRGfZDi39Di9lsz1hJ8QR?=
 =?us-ascii?Q?txDUGRy6GOazcaqYX7d8g56XNIgEqtoex7By0rUUTsessztWjK5X7rNkKI2G?=
 =?us-ascii?Q?OvD32JkJMoYzTjmNg7Vazms36w4ojcyc+yog4VoaSk40ODZUa9OWH9sRKSA0?=
 =?us-ascii?Q?XfKk05qSfcS30AqoClGY+mUMf14D796NkIx7rbbQ1YLTS+58T3f+px3/X6NE?=
 =?us-ascii?Q?I/YPB0WSkXy6YQkXHtDjgNPVfo8+PFxwyndSqw3BOYG76uXheLeDuMemGbJ8?=
 =?us-ascii?Q?fkv00RkDpBZA7/OvN+RZ/QvXCYJxKC4wDkSvPx79E+yi7pc9DuDKd0pKktIL?=
 =?us-ascii?Q?x7ml+W1b/+GXriWZbxkjAQuP/6z8CGYexJdp0FdVjdzQ7lT1HTT0jh/rtCAF?=
 =?us-ascii?Q?VT3w/X3tgbD2DZdC869UNIEZUVTd3NpQ3D2t3lf6auMp+2e9IZZJ1vcXhrLC?=
 =?us-ascii?Q?ijXIKix7n7vTyMYZ1WFaWHInes1h8y6OGPRkz5wLge3CW47oNZR/mi4WTHsW?=
 =?us-ascii?Q?Q7RZhb5rp10vG1pyc1XmWtcW7nE4ySAJ03GGHtJYNCAh7ijmkknU5GlvRTRQ?=
 =?us-ascii?Q?BHMc8pfveKJeC3g2xZ1i7THt/IaMT5FfAvoMZzRRNj4/7jNe9LxaHYp6qqTO?=
 =?us-ascii?Q?I7aSo3ZyViwT6B7mzvbfzMc4LUKLVA/d1v9TbjeD1qx+0g8+IRYrpa2BrTiR?=
 =?us-ascii?Q?1rVf4gyXFlyf1J78LQMWmTOiPS827RlxEMcGleMLnuknB4p29gqbidK+nVwp?=
 =?us-ascii?Q?C5EI1M3e9CO5SS5muTNRw83xxtfml+JcDmPqh66gs6G8Yyp8owTCl8VRZ4P0?=
 =?us-ascii?Q?8++0+AR18Mx0oXz8KkHogiX6oL3+nz4qdEvKk3ep8d0eO09MxhseAVf4iiDI?=
 =?us-ascii?Q?egUC8sIEpg5iosJdfGVgEsLHCZIutxA7IY+3tBUPRZbGpqQf1XZuIsDWT7Kh?=
 =?us-ascii?Q?85Q1XavZrnYcg8jUTDVPLU5rGXpR9pCHKn64F4COUAh97a1lENMzjIy/1gX0?=
 =?us-ascii?Q?h956ef44jv6nl9mLMShdKSnOW5XyqDjo3YuWyhFuSpbO5KtTyYOtlKXAMwy3?=
 =?us-ascii?Q?0yYPoN9mdthmWrGtjiGI6QpK/nBbyXJQjGXl3GB+D7C7JzqwJhYyCWtyG9xq?=
 =?us-ascii?Q?LjSx1GbD+rA2a3r9Nc08mkMN/HIz0zyqFIbfHt6StFlkJUTr1ZcEg/6fytGE?=
 =?us-ascii?Q?bii3Q5LvQQOVB/fMtlcSas7dgmmKke0zoY8I/Al1q/jlgsaisVhUx2M7309d?=
 =?us-ascii?Q?RTmV+MOvupuKREsmL+HpwpYAUnwmOR1PyrdKf0gdTP/94ZoGh+v8cWKPRuex?=
 =?us-ascii?Q?2ibCj6Usmoi5Dglqb1n9NqWhTPCxn2PUbrQ9UMbZ8OJQ7l8VWcB96m1hgRgT?=
 =?us-ascii?Q?ZDbEPDFjvadsHTf9qgHn3G/VXcxbWNqAROUw2ksOsq6yKGRp8Ay/bCPvkxtU?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d356995-92d5-44e7-a377-08dad128ef47
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 10:11:37.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3Tx5jP2tBcZwL4OQiS0648jD1wlLgYPQzSRZAiAAEQAHDmKE541ebo77G7h6Rf0nx879c/W39rySxePUdNMzqJs/N7KgCguEc8t+r4TbA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 11:21:40AM +0200, Roger Quadros wrote:
> On 25/11/2022 15:21, Maciej Fijalkowski wrote:
> > On Wed, Nov 23, 2022 at 02:48:34PM +0200, Roger Quadros wrote:
> >> During suspend resume the context of PORT_VLAN_REG is lost so
> >> save it during suspend and restore it during resume for
> >> host port and slave ports.
> >>
> >> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> >> Signed-off-by: David S. Miller <davem@davemloft.net>
> >> ---
> >>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
> >>  drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ++++
> >>  2 files changed, 11 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> index 0b59088e3728..f5357afde527 100644
> >> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> @@ -2875,7 +2875,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
> >>  	struct am65_cpsw_port *port;
> >>  	struct net_device *ndev;
> >>  	int i, ret;
> >> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);
> > 
> > Nit: I see that retrieving host pointer depends on getting the common
> > pointer first from dev_get_drvdata(dev) so pure RCT is not possible to
> > maintain here but nonetheless I would move this line just below the common
> > pointer:
> > 
> > 	struct am65_cpsw_common *common = dev_get_drvdata(dev);
> > 	struct am65_cpsw_host *host = am65_common_get_host(common);
> > 	struct am65_cpsw_port *port;
> > 	struct net_device *ndev;
> > 	int i, ret;
> 
> OK.
> 
> > 
> > Also I think plain 'host' for variable name is just fine, no need for _p
> > suffix to indicate it is a pointer. in that case you should go with
> > common_p etc.
> 
> host_p is the naming convention used throughout the driver.
> Do think it is a good idea to change it at this one place?

No, maybe think of a refactor throughout whole codebase, changing it in a
single place would be odd.

> 
> > 
> >>  
> >> +	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
> >>  	for (i = 0; i < common->port_num; i++) {
> >>  		port = &common->ports[i];
> >>  		ndev = port->ndev;
> >> @@ -2883,6 +2885,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
> >>  		if (!ndev)
> >>  			continue;
> >>  
> >> +		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
> >>  		netif_device_detach(ndev);
> >>  		if (netif_running(ndev)) {
> >>  			rtnl_lock();
> >> @@ -2909,6 +2912,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
> >>  	struct am65_cpsw_port *port;
> >>  	struct net_device *ndev;
> >>  	int i, ret;
> >> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);
> >>  
> >>  	ret = am65_cpsw_nuss_init_tx_chns(common);
> >>  	if (ret)
> >> @@ -2941,8 +2945,11 @@ static int am65_cpsw_nuss_resume(struct device *dev)
> >>  		}
> >>  
> >>  		netif_device_attach(ndev);
> >> +		writel(port->vid_context, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
> >>  	}
> >>  
> >> +	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
> >> +
> >>  	return 0;
> >>  }
> >>  #endif /* CONFIG_PM_SLEEP */
> >> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> >> index 2c9850fdfcb6..e95cc37a7286 100644
> >> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> >> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> >> @@ -55,12 +55,16 @@ struct am65_cpsw_port {
> >>  	bool				rx_ts_enabled;
> >>  	struct am65_cpsw_qos		qos;
> >>  	struct devlink_port		devlink_port;
> >> +	/* Only for suspend resume context */
> >> +	u32				vid_context;
> >>  };
> >>  
> >>  struct am65_cpsw_host {
> >>  	struct am65_cpsw_common		*common;
> >>  	void __iomem			*port_base;
> >>  	void __iomem			*stat_base;
> >> +	/* Only for suspend resume context */
> >> +	u32				vid_context;
> >>  };
> >>  
> >>  struct am65_cpsw_tx_chn {
> >> -- 
> >> 2.17.1
> >>
> 
> --
> cheers,
> -roger
