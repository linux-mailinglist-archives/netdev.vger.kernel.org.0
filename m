Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F84F65472A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 21:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLVUdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 15:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLVUdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 15:33:02 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4914510576;
        Thu, 22 Dec 2022 12:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671741181; x=1703277181;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/eDuLVRDrAsZPPp7KQymBM8M8/oxsGw22uld3LTqAUE=;
  b=VCA4oEwFgVMfG3y797QdsdvPtieAZ4+vKgKkGMMKKuF2KUwYRG6/V85U
   wDGlVchyJNK6MEEZf1JQh3BSkrPCoDDPCHBC6DktQHA2ATORw0S3Hmubq
   NRnIDpTOTLZxiJQ1BzXW6XJsfjWNVXzpXUDy5R4liG9HcgaK0jPM9Nrxj
   ZE045bz9BS/yzgV0wSfaGK/amrpGAvjsBMRJPummx/2vYTNawoE5u4QfA
   X3ayjxNlUijBHZblXPhd+PczjKG/t5iPathZOc2KHkW8UgMRcjdblIyXG
   J6c8OQcP+wAtlKf87st56JpOYO5nYg2vbpHr52ucjSvuqGYXXNNXfdHV2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="406457735"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="406457735"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 12:33:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="645383788"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="645383788"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 22 Dec 2022 12:32:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 12:32:59 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 12:32:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 12:32:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 12:32:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUrrYCn6KAjjJqVSNbC2O29CRlXbDDo4qF2Xi471scKu2UFhHdzZ/XUD3Bb5Et+GCwssZHwZCXpWNDWvvuXHa4n/CPYzffUhQRuDuMRj2P8BranKMlK0+Mtu1ZghEY4SwpN68kfrvTEXgKWbkg7hn5YJ12/TPNoi/sz9WIvvJ3/SCpfAnOzfIPkAWWB4WzmUlb02cjgy/pIrrgVEqHzJdz4uiRJ+xdAHhl4VWum8vgVXm//IQ8czMIiqkmfA26Kpuvbw94yCssWyJr99VLm1nX009em7k7CdayhsCZnGwuQeJtNJvVp7qTYJ6a9KMsxT2GivnolSjKypfdIPduRErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNQ0GrXWT9V3vtbq2DPZ2M4jeIRtUg5VUjCMJ//fuQI=;
 b=XG8xqoC5U0jspHd81/bSEPxAQpa/MF1MTHy2S4b0xRlFQCZvsQIiMcI5+o3vzPf0VTpGfVCQyJO5A0jn+W0d/rxhiSMM1H0EQ74iiJatAqAheolMeSyOhtBXwWcdt7hFvX5XxZhcw9bmcFuDORhQSVyh06o9UT+gePAwilpn6TcAKpZEHUi61AtiQ3ipjF3KYnIurl5I+J87yS8P2Wxbh0n9tuf6KyWlpde6GUfgbOxTKVUUcq/U5S9sK883nYa7QlzereoTu0rJaRCIqaEbbjB5L/PNv7hEhH7OWub6P0zPtrf49YD77nMPvP+je57vusbdDZCIczN2kRThGZlyOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by SJ1PR11MB6203.namprd11.prod.outlook.com
 (2603:10b6:a03:45a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 20:32:56 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e%7]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 20:32:56 +0000
Date:   Thu, 22 Dec 2022 21:32:56 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Clark Wang <xiaoning.wang@nxp.com>
CC:     <linux@armlinux.org.uk>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mcoquelin.stm32@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: phylink: add a function to resume phy alone to
 fix resume issue with WoL enabled
Message-ID: <Y6S++OT+6CfWGPiY@nimitz>
References: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
 <20221221080144.2549125-2-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221221080144.2549125-2-xiaoning.wang@nxp.com>
X-ClientProxiedBy: FRYP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::22)
 To BN6PR1101MB2227.namprd11.prod.outlook.com (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|SJ1PR11MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: f36f1ab4-b32e-470a-1bab-08dae45bb4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7ysi+iQzjRLLThRj70rXFu0XqlMSJR3USrKEmHonqMSRGagBQUMvSvVrKJQFnfKI3fCuKj8NWPh25yCPlFcGmh9fgvb6Y6FjW8vNs0RuKCce/akPmAQabsj6hmpqfjkF9HqT+JtalzW9ZUSZkHUP0FWJTNHu9wTk0e/4eaCONR/oIoNRxJV+4St6EUixA28n/8sbiKiGYGffYnGvvAODBI98J2yb/jjPGz05vIdDSecYPfqtD0k15R26S5A1+0hwmgF+0JxorDx5W6r4slDPTOow6mtUnA3l0rKKF3LP9Hx9ttufRdHO4/O7sRv7D2DaGPW0nsUpGYimQNjQpuclxbJ47ar9MlKGyTmEsa4CH8YtvjFtxT/5tihkyZiIu4rOvMb0iHNdT3uAMYesodKbOATrO4riM/APoCZ8YSLAanvnhbNhMazN/9vAsX9LGZHAMFCbgiy46y59FyHyD95auviT4qtnRnKb8eC46aeOJ0J4yIDzmiDKMO9IdnzUAmpdpoLEKL0GEht4dz3vzf93Z5vewwfC4w43p/CFWyl7EvzhDswxnlqbTE+V39Ekyn0sK8yzgW1eeJ3VLqV/ch+oxqwqm64pGWhcIXPwMRbMxqNtlaTvAzt4txCE3eOYVAJ8bD+c3XgYw3rSUKfBaChiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(82960400001)(38100700002)(41300700001)(8936002)(66946007)(66476007)(5660300002)(7416002)(4326008)(66556008)(8676002)(33716001)(478600001)(83380400001)(6486002)(6916009)(2906002)(44832011)(316002)(26005)(9686003)(186003)(6512007)(6506007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Jbu6lj9sUWFuvHsyb3rAUtpM+o88voUoWGt5Z+LA6eQEgwN58DcU8lg5v+P?=
 =?us-ascii?Q?2i67041HwY2djkMVmuGq/w9bfrw+ZfWpYY9m3JBEdNzaXvHa/8V6JsxI/WOo?=
 =?us-ascii?Q?Fjk6IJNf3/t/ZmDhlxM64bSYjPC5rIPEIlViiYoe3uGabPaANkcg4BN5YaDK?=
 =?us-ascii?Q?tiWhA8Lu4agAYfUUKfOcJTBqd3uOWmWfn5JSh3hE95bednYzeVSE4P9AjvdC?=
 =?us-ascii?Q?VJ0DErdLyhpWOT4NZkkH1ex0M/7ckiSElZZAX76CNZgciIwGuunn5qlEWHNG?=
 =?us-ascii?Q?WKvUplEZRV6qoZ1uD8Akmy11uhWH9Daayflh2tzC4oWD/lCSBEkXh3YZ0oTt?=
 =?us-ascii?Q?mQuvhdGJUhIrTs2gm1SWyTaAyko1HPA3654iHeCxQAEVsc0ODzVkp+jR4x8e?=
 =?us-ascii?Q?BD0sSjQLOxfs0QmXjRLvBsrj9qwW1dzhRlwIhOihfyeWl52oKUQipxnX4EE1?=
 =?us-ascii?Q?WEjtLCyV/G4wigRaJ5Vz17mC06Mnp2+jcWL15+xBLaUo9W0VXSGmlqpImU5n?=
 =?us-ascii?Q?TcwEJTlxqNkkjzKCToDDHFMiPQyCkUjXqvTo4y0oI2lwBGWdvb63vx9fW9+d?=
 =?us-ascii?Q?VCZO3OyosCQnqvFRopoaYeo+y+ZB0gHf88DpAjjcIUT9rd9WHCJ2qDdVLPSL?=
 =?us-ascii?Q?KJBuS6IZZtaElo/7wvP1T/skKYf69HB+0s2Jplg+1yQikqpYmrmPauAfxAWp?=
 =?us-ascii?Q?6jYP+p1cqaEyD18HaFtcm03DbVgL3cX2bb4hJ4jLHRq2ncsBzwxWsN7tgM/q?=
 =?us-ascii?Q?FTMovEf2DqCJIPmbcX/C51mUPPFhP+InsIreLU7K64JqE0gT08jg5EtU26a2?=
 =?us-ascii?Q?JxHd06wAqczAHbvx0MsheJCcb3BbHURKGkIWj6bcOjKzF1PV0NBHU3zR0Ehx?=
 =?us-ascii?Q?fITEveEf0dhsRBN9LWkPCYDQQ0MjPRbLd9d54fO6wfZCuBWRGDwdKRcFBZMa?=
 =?us-ascii?Q?U8f0bm+4/woYy41dpZbMEoieGkx9vf0hQb1jP3wCwA4lErRjiA/AKpQ5Pgeq?=
 =?us-ascii?Q?Cdh9tja0gDRe7Cd5LjvtPgEgH29/IMyDSEg9X4IMqmzw1G6xIQbn4X+zjKor?=
 =?us-ascii?Q?5m+gzfRRGRIK05/xi++QmCNhGUMOWSy3UcJbtoJOe0G8SG45CfVFceKwY8Vv?=
 =?us-ascii?Q?nardsmsuw3CkWA/kA5UgEg3I6NtZTDZNbJ+ogFOpQe7h8RGOpj9CDuKvGWqB?=
 =?us-ascii?Q?/3bb++ERFDOIX/QNylqpYREC8AwKgv2D9rRpKIDMQWnWzfyBToTpRW7TdfRt?=
 =?us-ascii?Q?3rSwTvc26L14TMtzz6ZN8UtSr6uRHa/kSHs0aZjQc8fDAYAYT4rRLwY1v30B?=
 =?us-ascii?Q?ygVi+plURN1xSvB213dufPAnpghTO0clVsQ59QYupvUCk1/Jc8oc7YncxV45?=
 =?us-ascii?Q?jCyE3xCVVdW539SvGQZ2rvRMlV/ZFICsqOhJ7z++cV8o9Z2S2RU4kVnaCP0y?=
 =?us-ascii?Q?61X03dR4N2XNxnUwc6akHt0ikdZD1MzVaOMI3EDLDP56bmBHQdtO/ynaRPFZ?=
 =?us-ascii?Q?0DIPC1INR5gyKl9b/l2fSTCqchs+F4Pc8YholJrwq7RHCNkal8O3MQ+seDuH?=
 =?us-ascii?Q?c6SFSkxmkFrHewkWuknM4e9Vwz+YwE9/FYvymn3LRTpUF/2s8l4woOjWTRBI?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f36f1ab4-b32e-470a-1bab-08dae45bb4fa
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 20:32:55.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20mmF9WthUxuOkOKovsQF5ydlX5H9c3tFPxSoK6mp9sZnFJmNBBoAjlMpGHGdjPXRK01XtasMn5hhBcL8qgNne8JIzr3VPZGJ7HM6429viI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6203
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 04:01:43PM +0800, Clark Wang wrote:
> Issue we met:
> On some platforms, mac cannot work after resumed from the suspend with WoL
> enabled.
> 
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immediately.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(), because mac need phy rx_clk to do the reset.
>    stmmac_core_init() is called in function stmmac_hw_setup(), which will
>    reset the mac and set the speed/duplex... to default value.
> Conclusion: Because phylink_resolve() cannot determine when it is called, it
>             cannot be guaranteed to be called after stmmac_core_init().
> 	    Once stmmac_core_init() is called after phylink_resolve(),
> 	    the mac will be misconfigured and cannot be used.
> 
> In order to avoid this problem, add a function called phylink_phy_resume()
> to resume phy separately. This eliminates the need to call phylink_resume()
> before stmmac_hw_setup().
> 
> Add another judgement before called phy_start() in phylink_start(). This way
> phy_start() will not be called multiple times when resumes. At the same time,
> it may not affect other drivers that do not use phylink_phy_resume().
> 
It'd be nice to see Fixes tag.

> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 21 ++++++++++++++++++++-
>  include/linux/phylink.h   |  1 +
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 09cc65c0da93..5bab59142579 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1939,7 +1939,7 @@ void phylink_start(struct phylink *pl)
>  	}
>  	if (poll)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
> -	if (pl->phydev)
> +	if (pl->phydev && pl->phydev->state < PHY_UP)
>  		phy_start(pl->phydev);
>  	if (pl->sfp_bus)
>  		sfp_upstream_start(pl->sfp_bus);
> @@ -2020,6 +2020,25 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
>  }
>  EXPORT_SYMBOL_GPL(phylink_suspend);
>  
> +/**
> + * phylink_phy_resume() - resume phy alone
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * In the MAC driver using phylink, if the MAC needs the clock of the phy
> + * when it resumes, can call this function to resume the phy separately.
> + * Then proceed to MAC resume operations.
> + */
> +void phylink_phy_resume(struct phylink *pl)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)
> +	    && pl->phydev)
you can fit && at the end of the previous line.
> +		phy_start(pl->phydev);
> +
this blank line is not necessary.
> +}
> +EXPORT_SYMBOL_GPL(phylink_phy_resume);
> +
>  /**
>   * phylink_resume() - handle a network device resume event
>   * @pl: a pointer to a &struct phylink returned from phylink_create()
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index c492c26202b5..6edfab5f754c 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -589,6 +589,7 @@ void phylink_stop(struct phylink *);
>  
>  void phylink_suspend(struct phylink *pl, bool mac_wol);
>  void phylink_resume(struct phylink *pl);
> +void phylink_phy_resume(struct phylink *pl);
>  
>  void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
>  int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
> -- 
> 2.34.1
> 
