Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8DB632B76
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiKURux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKURuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:50:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD70D08B5;
        Mon, 21 Nov 2022 09:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669053050; x=1700589050;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r+953HMwDKOcmDJwvnlW1k3y1+bJ4gNABfR4YZbFCmI=;
  b=TUpbR3HTAXkU9c98PN/J/azo0oTTl/EIwHndYgU1610XtJTUgwcq7lrm
   J5R4oegdl5HC5Z0M4ncb4j6+o72GYD5EdIkwrGxMwAFsj6/AkTNjoBeMv
   ot92w5qH1A5vsWFN1dYnA9zA3gfqUO09QFqWKPSf2Gbg8+Lgjf7TPr2zf
   9/rW/xM7CRoJnFEEaxfoOaYRCAGHEl1IoSS1aBY3ZB1TPZ5UEIvgrU/9Z
   tMKRhbCBQlAViLB4EhnZkhRYzQbeYMMjA8IFWim2aXJcLV3emrmCTPfQt
   r6ap6CcTGKaUP+gGBUMgjuhQxS6gOUpbNsmKC2lc/lWKiXWzt022V2kRg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293329786"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="293329786"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:50:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="618905441"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="618905441"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Nov 2022 09:50:21 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:50:15 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:50:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:50:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:50:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/CvlifYCa7Yn7BZsMDPo9F0+WU6eV5+sy+JP7YHSd4QazLD5Csat7jfra0XAhS4eNEAnFhH/JQmvjxs87OkNLP5beOZ4WjaMusyQI+CI9p/CNivSYlsPzpfhEOMv2AI57A7A8kRMLH71EINQWhoG6+MGBqP2smmBaqXWMYnDAOODb0lutB9Js9wT0jtxgks7wWcQtMvRFCpDuhgHsWP86FBOxahNbzigQKdeqxK3SYtE5aH4/lEEDI/VH4YUsm8gVOI2NghsxcwYxEowWBwQbG86ZJG0b7y4RZSKkd1zsara3sr2FWrCAWm9XCX4mOMMZJ1X4QWPNx69oQLUO8EGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWLOz1+/mSdryCVEPkQnodX8W4KjhtGN80NoHFP5uBY=;
 b=FfKg+Lw0t/NJ5eYO3CEzh2vT4GhltVFzxIDEmiNjco7GlgS1dI7BqTaVyr+OvieeJUB8T+KkjDX3oCoc8/Ccwm7ejzeKrH7tS4Qzuk/muf42wAq5EdbKW1mFUxjQr48wYMpYngDVl4mRmSMnh7Az2gpXgYRGObMhrTtTRrPnfAWMiB21j+fEMmXw4L3nj+fow1kQyVb6PfQSRUV1UIlwBznWlfVLfT9QPKo8h443u0yuY/vdpPvR5xJEnizG3X7bZ9e3akkgRnCwlEugLZkOmqUfaU8YAgmDiBxuVbMgzCyNC8bQB6S1A8jkfEFIw7i156PkeTuM7Jef10GfJf8Dew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5879.namprd11.prod.outlook.com (2603:10b6:510:142::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.9; Mon, 21 Nov 2022 17:50:13 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 17:50:13 +0000
Date:   Mon, 21 Nov 2022 18:50:01 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Roger Quadros <rogerq@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] net: ethernet: ti: am65-cpsw: Fix set channel
 operation
Message-ID: <Y3u6Sdh22CBfBUV1@boxer>
References: <20221121142300.9320-1-rogerq@kernel.org>
 <20221121142300.9320-2-rogerq@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221121142300.9320-2-rogerq@kernel.org>
X-ClientProxiedBy: FR3P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d42b86-b958-4681-7eb2-08dacbe8d714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KhX8QJjcksYWR0KzpYeOm9uXiatCiKao+8WCWBPQb5Yb3ASgeT0JBPAxjhfYiWHi+1+B3kz6L+6Co1cmTu0fSi7qCRjffkz1OGYC6unfs6qRLlOBFNdPEEdjvbHHO2EU4MMGIIZokwodVV6woHLuNYahcnt6ox5uB3ezroOiZH88OM8izIB1HUg+mfK+BPV60TcRhqElHmuSvz9B1Er3q2LsHwHH/f2+gcypuEoFOVr51/aFal5VFP/zjwcQm0OBEY4H2yUiQInTjDJD0xsBxIGMrTMZlL11BwtwIjj0Z4/SQq5YexIG6jXHLPyu3r5I6bMzW0EddsuoHbcefM90YJSLs6rzCY9/83OrBOAJGoqjIkC/0YCCYbg/zdpGnw6xuft40VqGDJEAK67mXqcvkxTh9hzaAw+9LqsuU9F76zLTS5MWUXXKovsn2wP7JDYv+oPjSskdv7330zHeFwYccHhM7I3n0IZAXofrQyaOPXZZCudNGxQvPynqznErMO2Qe5WUJs5y2GPB0+cmw6tf6VWudbKeFOpmo67qP7BBO8Iensy37xWITlaY3AyPG1mAYO+UQxOOa4yco/90Kha/yOBaQIrG/wCOq9uBGUWu7pmbFQCRbicBRaOnlzLVLDHa+hKwrPS0e5i3mnDAtXZ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199015)(54906003)(9686003)(83380400001)(316002)(26005)(6512007)(8936002)(186003)(6916009)(66946007)(86362001)(4326008)(82960400001)(30864003)(44832011)(8676002)(5660300002)(66476007)(2906002)(66556008)(41300700001)(38100700002)(6486002)(6666004)(478600001)(45080400002)(6506007)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hOwGY8cwiKRyUmzFR9k4W6ySi0EHQioJJyBuoPZ5QyAZGeITYrGHlUF+Hwlg?=
 =?us-ascii?Q?7BfH2MD7oBVdz9h0M5C5r6C/jWRvZpH5QN1hgPqC2m1oz0e6zNmGapJ0aEyQ?=
 =?us-ascii?Q?OFAJOU9ZYlUYu2MM2IKl4Qb8z49gBeHFURA6jL1B+Pi7nEampMCSBxOb+GPe?=
 =?us-ascii?Q?gA+Isp/ncIk18dECs5H2lHxE/keA1qSKru/jjDSZEmHG/mUEVTKhbOViaPsd?=
 =?us-ascii?Q?6ScWnCCJH5P1VFqmyFW7Ln732kZ52iod5vv4eLAoJLA65HL4mFuVjVH+WeYz?=
 =?us-ascii?Q?uUdAWgxIZt2eAmEXRI4dEr8MHbnXhK+Q5AoPI1D4MpmlP5IPQ4KcCNao/knI?=
 =?us-ascii?Q?zbArrf1BeAhF0lM1ptLvI0PoDEmgEY7idxzc1hHmatlYs+5VbadNxOzlV1pm?=
 =?us-ascii?Q?ZUwViFwooiQyBBPUn385ZWr0vQTAv7j/qVIToNdUXbJ8l5ih8EHBcvBCLTzB?=
 =?us-ascii?Q?/f7DyasC5IRJkQVPI8B9DcrFzf1U8m+nwxYmsFC7vWHiH5acskC4rGjb58N2?=
 =?us-ascii?Q?57fzMJA6EQd4hf3VjThwkdhs3iynJCUNMb+p5E2uU2pXBBc/S3Ed4j3G7uQ/?=
 =?us-ascii?Q?l61rq2TpQfr++EaKW9ZSHzF97W5/h1acj2W8ObQH+2l4/LEOTk2nNLvjVWkQ?=
 =?us-ascii?Q?8klMOTfhLOQF6E8YrUZEB07XjGDcZONkV3/Be4BRAhEM3f+zHDs8g6Lq7UqF?=
 =?us-ascii?Q?cW67GTfMVSSm8nW1BF43DQN2ae+xnTTAfCZUO4NrBXRU21HCke9e+tFyhL8u?=
 =?us-ascii?Q?5MOG3XT0S2+FSPB3KJXt8N0b7/Nmr4uS821hlzpAmOJ6KJ4Sw+fbZFA+60lv?=
 =?us-ascii?Q?CUw7MIXZ1/tQ/kiFtLroVaBjwVYcJTKMCfXWt9hNPyEUgV45BMcTXQJ8vJIB?=
 =?us-ascii?Q?pJEUxJxOHMN6YA76l4SL4xIAasm6KrSZYtyzyH4ezfop8uy4zzqTya3Q7hWq?=
 =?us-ascii?Q?wf30lPeKyw+pU94ald60oT2PXsOBy+NiM26t5fw0EpC22D7NnMH8CXj2CS55?=
 =?us-ascii?Q?hTtkwLvhcoT7aegZHHsz59rRks59H2lXy73rd+wOSGRNaEHYWcS7iH9KhHVT?=
 =?us-ascii?Q?mpdydwWuzBc/2MHojOQ9QrWwlyDS/jks24fRttInT1y1NRVfdRIpBXUV9DTV?=
 =?us-ascii?Q?oUI41k558yjSpkx0TAQKY8vTd5f2L+gzng0FElp80Mvnk0LFdIkskda1LguN?=
 =?us-ascii?Q?StAI2Ss/V0PknUd2kO2akQhoH6AwLcqd0R5sKnAhI1zZASi6bQGR0zPw5M+z?=
 =?us-ascii?Q?dN99nwIFexj2v7IFY/9CdiOSkUikX95Yekk7LyxUroDQ4uNLsNzKzQscZnf5?=
 =?us-ascii?Q?JBp3KkG+G3+uOrPMSVgWuGd/qgoNK+Z5CmdiUIgWsnUFoBV6uGCKlTUgCp9U?=
 =?us-ascii?Q?paI6y0u+1rWY4wuMOFqdwCU3JaDpI9KhMGwnHWslAmf9Oht63K+xpV9+V98s?=
 =?us-ascii?Q?wy8laxQWwd6lQGNFh7T+k2CY7rn3IVbDy1SF3Vb+ZNK/TFb35Q+fzUAlnhOx?=
 =?us-ascii?Q?YpwRH1kP0C46e7lKWdOP2SYHEUcHcri2ZDt5VPGR3+AsLW0ogrVcnWZSn6oy?=
 =?us-ascii?Q?VqqnwbqgJqi2CU7mPwe345kvh9ec/fsr85j9vvDMibfD5Jx+ux31iKF4KAdz?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d42b86-b958-4681-7eb2-08dacbe8d714
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:50:12.9985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kY7yqExwTOhaFjEiFeoPeB/P21ibSAmvNCRHwTOSrGFvYBE+MUJhnvK1YBP3FGsYIgk11rOitS0dFhyqYK7nK+VGFa9JxKBMyB0FJYKPbVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5879
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 03:22:57PM +0100, Roger Quadros wrote:
> The set channel operation "ethtool -L tx <n>" broke with
> the recent suspend/resume changes.

Would be worth just dropping here the SHA-1 of offending commit, I deduce
that it is the one that fixes tag points to.

> 
> Revert back to original driver behaviour of not freeing
> the TX/RX IRQs at am65_cpsw_nuss_common_stop(). We will
> now free them only on .suspend() as we need to release
> the DMA channels (as DMA looses context) and re-acquiring
> them on .resume() may not necessarily give us the same
> IRQs.
> 
> Introduce am65_cpsw_nuss_remove_rx_chns() which is similar
> to am65_cpsw_nuss_remove_tx_chns() and invoke them both in
> .suspend().
> 
> At .resume() call am65_cpsw_nuss_init_rx/tx_chns() to
> acquire the DMA channels.
> 
> To as IRQs need to be requested after knowing the IRQ
> numbers, move am65_cpsw_nuss_ndev_add_tx_napi() call to
> am65_cpsw_nuss_init_tx_chns().
> 
> Also fixes the below warning during suspend/resume on multi

s/fixes/fix ?

> CPU system.
> 
> [   67.347684] ------------[ cut here ]------------
> [   67.347700] Unbalanced enable for IRQ 119
> [   67.347726] WARNING: CPU: 0 PID: 1080 at kernel/irq/manage.c:781 __enable_irq+0x4c/0x80
> [   67.347754] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 libarc4 cfg80211 rfkill crct10dif_ce sch_fq_codel ipv6
> [   67.347803] CPU: 0 PID: 1080 Comm: rtcwake Not tainted 6.1.0-rc4-00023-gc826e5480732-dirty #203
> [   67.347812] Hardware name: Texas Instruments AM625 (DT)
> [   67.347818] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   67.347829] pc : __enable_irq+0x4c/0x80
> [   67.347838] lr : __enable_irq+0x4c/0x80
> [   67.347846] sp : ffff80000999ba00
> [   67.347850] x29: ffff80000999ba00 x28: ffff0000011c1c80 x27: 0000000000000000
> [   67.347863] x26: 00000000000001f4 x25: ffff000001058358 x24: ffff000001059080
> [   67.347876] x23: ffff000001058080 x22: ffff000001060000 x21: 0000000000000077
> [   67.347888] x20: ffff0000011c1c80 x19: ffff000001429600 x18: 0000000000000001
> [   67.347900] x17: 0000000000000080 x16: fffffc000176e008 x15: ffff0000011c21b0
> [   67.347913] x14: 0000000000000000 x13: 3931312051524920 x12: 726f6620656c6261
> [   67.347925] x11: 656820747563205b x10: 000000000000000a x9 : ffff80000999ba00
> [   67.347938] x8 : ffff800009121068 x7 : ffff80000999b810 x6 : 00000000fffff17f
> [   67.347950] x5 : ffff00007fb99b18 x4 : 0000000000000000 x3 : 0000000000000027
> [   67.347962] x2 : ffff00007fb99b20 x1 : 50dd48f7f19deb00 x0 : 0000000000000000
> [   67.347975] Call trace:
> [   67.347980]  __enable_irq+0x4c/0x80
> [   67.347989]  enable_irq+0x4c/0xa0
> [   67.347999]  am65_cpsw_nuss_ndo_slave_open+0x4b0/0x568
> [   67.348015]  am65_cpsw_nuss_resume+0x68/0x160
> [   67.348025]  dpm_run_callback.isra.0+0x28/0x88
> [   67.348040]  device_resume+0x78/0x160
> [   67.348050]  dpm_resume+0xc0/0x1f8
> [   67.348057]  dpm_resume_end+0x18/0x30
> [   67.348063]  suspend_devices_and_enter+0x1cc/0x4e0
> [   67.348075]  pm_suspend+0x1f8/0x268
> [   67.348084]  state_store+0x8c/0x118
> [   67.348092]  kobj_attr_store+0x18/0x30
> [   67.348104]  sysfs_kf_write+0x44/0x58
> [   67.348117]  kernfs_fop_write_iter+0x118/0x1a8
> [   67.348127]  vfs_write+0x31c/0x418
> [   67.348140]  ksys_write+0x6c/0xf8
> [   67.348150]  __arm64_sys_write+0x1c/0x28
> [   67.348160]  invoke_syscall+0x44/0x108
> [   67.348172]  el0_svc_common.constprop.0+0x44/0xf0
> [   67.348182]  do_el0_svc+0x2c/0xc8
> [   67.348191]  el0_svc+0x2c/0x88
> [   67.348201]  el0t_64_sync_handler+0xb8/0xc0
> [   67.348209]  el0t_64_sync+0x18c/0x190
> [   67.348218] ---[ end trace 0000000000000000 ]---
> 
> Fixes: fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 161 +++++++++++++----------
>  1 file changed, 90 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index f2e377524088..505c9edf98ff 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -133,10 +133,7 @@
>  			 NETIF_MSG_IFUP	| NETIF_MSG_PROBE | NETIF_MSG_IFDOWN | \
>  			 NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
>  
> -static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common);
> -static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common);
> -static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common);
> -static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common);
> +static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common);
>  
>  static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
>  				      const u8 *dev_addr)
> @@ -379,20 +376,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  	if (common->usage_count)
>  		return 0;
>  
> -	/* init tx/rx channels */
> -	ret = am65_cpsw_nuss_init_tx_chns(common);
> -	if (ret) {
> -		dev_err(common->dev, "init_tx_chns failed\n");
> -		return ret;
> -	}
> -
> -	ret = am65_cpsw_nuss_init_rx_chns(common);
> -	if (ret) {
> -		dev_err(common->dev, "init_rx_chns failed\n");
> -		am65_cpsw_nuss_free_tx_chns(common);
> -		return ret;
> -	}
> -
>  	/* Control register */
>  	writel(AM65_CPSW_CTL_P0_ENABLE | AM65_CPSW_CTL_P0_TX_CRC_REMOVE |
>  	       AM65_CPSW_CTL_VLAN_AWARE | AM65_CPSW_CTL_P0_RX_PAD,
> @@ -453,8 +436,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  						  GFP_KERNEL);
>  		if (!skb) {
>  			dev_err(common->dev, "cannot allocate skb\n");
> -			ret = -ENOMEM;
> -			goto err;
> +			return -ENOMEM;
>  		}
>  
>  		ret = am65_cpsw_nuss_rx_push(common, skb);
> @@ -463,7 +445,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  				"cannot submit skb to channel rx, error %d\n",
>  				ret);
>  			kfree_skb(skb);
> -			goto err;
> +			return ret;
>  		}
>  		kmemleak_not_leak(skb);
>  	}
> @@ -472,7 +454,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  	for (i = 0; i < common->tx_ch_num; i++) {
>  		ret = k3_udma_glue_enable_tx_chn(common->tx_chns[i].tx_chn);
>  		if (ret)
> -			goto err;
> +			return ret;
>  		napi_enable(&common->tx_chns[i].napi_tx);
>  	}
>  
> @@ -484,12 +466,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  
>  	dev_dbg(common->dev, "cpsw_nuss started\n");
>  	return 0;
> -
> -err:
> -	am65_cpsw_nuss_free_tx_chns(common);
> -	am65_cpsw_nuss_free_rx_chns(common);
> -
> -	return ret;
>  }
>  
>  static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma);
> @@ -543,9 +519,6 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
>  	writel(0, common->cpsw_base + AM65_CPSW_REG_CTL);
>  	writel(0, common->cpsw_base + AM65_CPSW_REG_STAT_PORT_EN);
>  
> -	am65_cpsw_nuss_free_tx_chns(common);
> -	am65_cpsw_nuss_free_rx_chns(common);
> -
>  	dev_dbg(common->dev, "cpsw_nuss stopped\n");
>  	return 0;
>  }
> @@ -597,8 +570,8 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>  	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
>  
>  	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
> -	dev_info(common->dev, "down msc_sl %08x tmo %d\n",
> -		 cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
> +	dev_dbg(common->dev, "down msc_sl %08x tmo %d\n",
> +		cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);

Looks like unncecessary noise?

>  
>  	cpsw_sl_ctl_reset(port->slave.mac_sl);
>  
> @@ -1548,9 +1521,9 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
>  	cpsw_sl_ctl_reset(port->slave.mac_sl);
>  }
>  
> -static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
> +static void am65_cpsw_nuss_free_tx_chns(void *data)
>  {
> -	struct device *dev = common->dev;
> +	struct am65_cpsw_common *common = data;
>  	int i;
>  
>  	for (i = 0; i < common->tx_ch_num; i++) {
> @@ -1562,11 +1535,7 @@ static void am65_cpsw_nuss_free_tx_chns(struct am65_cpsw_common *common)
>  		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
>  			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
>  
> -		/* Don't clear tx_chn memory as we need to preserve
> -		 * data between suspend/resume
> -		 */
> -		if (!(tx_chn->irq < 0))
> -			devm_free_irq(dev, tx_chn->irq, tx_chn);
> +		memset(tx_chn, 0, sizeof(*tx_chn));
>  	}
>  }
>  
> @@ -1575,10 +1544,12 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
>  	struct device *dev = common->dev;
>  	int i;
>  
> +	devm_remove_action(dev, am65_cpsw_nuss_free_tx_chns, common);
> +
>  	for (i = 0; i < common->tx_ch_num; i++) {
>  		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
>  
> -		if (!(tx_chn->irq < 0))
> +		if (tx_chn->irq)
>  			devm_free_irq(dev, tx_chn->irq, tx_chn);
>  
>  		netif_napi_del(&tx_chn->napi_tx);
> @@ -1648,7 +1619,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
>  		}
>  
>  		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
> -		if (tx_chn->irq < 0) {
> +		if (tx_chn->irq <= 0) {
>  			dev_err(dev, "Failed to get tx dma irq %d\n",
>  				tx_chn->irq);
>  			goto err;
> @@ -1657,41 +1628,59 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
>  		snprintf(tx_chn->tx_chn_name,
>  			 sizeof(tx_chn->tx_chn_name), "%s-tx%d",
>  			 dev_name(dev), tx_chn->id);
> -
> -		ret = devm_request_irq(dev, tx_chn->irq,
> -				       am65_cpsw_nuss_tx_irq,
> -				       IRQF_TRIGGER_HIGH,
> -				       tx_chn->tx_chn_name, tx_chn);
> -		if (ret) {
> -			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
> -				tx_chn->id, tx_chn->irq, ret);
> -			tx_chn->irq = -EINVAL;
> -			goto err;
> -		}
>  	}
>  
> -	return 0;
> +	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
> +	if (ret) {
> +		dev_err(dev, "Failed to add tx NAPI %d\n", ret);
> +		goto err;
> +	}
>  
>  err:
> -	am65_cpsw_nuss_free_tx_chns(common);
> +	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);

Can you explain why you're using devm_ variant instead of a direct call in
the commit message? Couldn't these (devm_{add,remove}_action) be pulled
out the separate commit on top of this one?

> +	if (i) {
> +		dev_err(dev, "Failed to add free_tx_chns action %d\n", i);
> +		return i;
> +	}
>  
>  	return ret;
>  }
>  
> -static void am65_cpsw_nuss_free_rx_chns(struct am65_cpsw_common *common)
> +static void am65_cpsw_nuss_free_rx_chns(void *data)
> +{
> +	struct am65_cpsw_common *common = data;
> +	struct am65_cpsw_rx_chn *rx_chn;
> +
> +	rx_chn = &common->rx_chns;
> +
> +	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
> +		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
> +
> +	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
> +		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
> +}
> +
> +static void am65_cpsw_nuss_remove_rx_chns(void *data)
>  {
> +	struct am65_cpsw_common *common = data;
>  	struct am65_cpsw_rx_chn *rx_chn;
> +	struct device *dev = common->dev;
>  
>  	rx_chn = &common->rx_chns;
> +	devm_remove_action(dev, am65_cpsw_nuss_free_rx_chns, common);
>  
>  	if (!(rx_chn->irq < 0))
> -		devm_free_irq(common->dev, rx_chn->irq, common);
> +		devm_free_irq(dev, rx_chn->irq, common);
> +
> +	netif_napi_del(&common->napi_rx);
>  
>  	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
>  		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
>  
>  	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
>  		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
> +
> +	common->rx_flow_id_base = -1;
>  }
>  
>  static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
> @@ -1709,7 +1698,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
>  
>  	rx_cfg.swdata_size = AM65_CPSW_NAV_SW_DATA_SIZE;
>  	rx_cfg.flow_id_num = AM65_CPSW_MAX_RX_FLOWS;
> -	rx_cfg.flow_id_base = -1;
> +	rx_cfg.flow_id_base = common->rx_flow_id_base;
>  
>  	/* init all flows */
>  	rx_chn->dev = dev;
> @@ -1781,20 +1770,24 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
>  		}
>  	}
>  
> +	netif_napi_add(common->dma_ndev, &common->napi_rx,
> +		       am65_cpsw_nuss_rx_poll);
> +
>  	ret = devm_request_irq(dev, rx_chn->irq,
>  			       am65_cpsw_nuss_rx_irq,
>  			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
>  	if (ret) {
>  		dev_err(dev, "failure requesting rx irq %u, %d\n",
>  			rx_chn->irq, ret);
> -		rx_chn->irq = -EINVAL;
>  		goto err;
>  	}
>  
> -	return 0;
> -
>  err:
> -	am65_cpsw_nuss_free_rx_chns(common);
> +	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
> +	if (i) {
> +		dev_err(dev, "Failed to add free_rx_chns action %d\n", i);
> +		return i;
> +	}
>  
>  	return ret;
>  }
> @@ -2114,24 +2107,33 @@ static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
>  			return ret;
>  	}
>  
> -	netif_napi_add(common->dma_ndev, &common->napi_rx,
> -		       am65_cpsw_nuss_rx_poll);
> -
>  	return ret;
>  }
>  
>  static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
>  {
> -	int i;
> +	struct device *dev = common->dev;
> +	int i, ret = 0;
>  
>  	for (i = 0; i < common->tx_ch_num; i++) {
>  		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
>  
>  		netif_napi_add_tx(common->dma_ndev, &tx_chn->napi_tx,
>  				  am65_cpsw_nuss_tx_poll);
> +
> +		ret = devm_request_irq(dev, tx_chn->irq,
> +				       am65_cpsw_nuss_tx_irq,
> +				       IRQF_TRIGGER_HIGH,
> +				       tx_chn->tx_chn_name, tx_chn);
> +		if (ret) {
> +			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
> +				tx_chn->id, tx_chn->irq, ret);
> +			goto err;

Shouldn't you rewind all of the successful irq requests on error path?

> +		}
>  	}
>  
> -	return 0;
> +err:
> +	return ret;
>  }
>  
>  static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
> @@ -2597,7 +2599,11 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>  	struct am65_cpsw_port *port;
>  	int ret = 0, i;
>  
> -	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
> +	/* init tx channels */
> +	ret = am65_cpsw_nuss_init_tx_chns(common);
> +	if (ret)
> +		return ret;
> +	ret = am65_cpsw_nuss_init_rx_chns(common);
>  	if (ret)
>  		return ret;
>  
> @@ -2645,10 +2651,8 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
>  
>  	common->tx_ch_num = num_tx;
>  	ret = am65_cpsw_nuss_init_tx_chns(common);
> -	if (ret)
> -		return ret;
>  
> -	return am65_cpsw_nuss_ndev_add_tx_napi(common);
> +	return ret;
>  }
>  
>  struct am65_cpsw_soc_pdata {
> @@ -2756,6 +2760,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
>  	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
>  		return -ENOENT;
>  
> +	common->rx_flow_id_base = -1;
>  	init_completion(&common->tdown_complete);
>  	common->tx_ch_num = 1;
>  	common->pf_p0_rx_ptype_rrobin = false;
> @@ -2918,6 +2923,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
>  
>  	am65_cpts_suspend(common->cpts);
>  
> +	am65_cpsw_nuss_remove_rx_chns(common);
> +	am65_cpsw_nuss_remove_tx_chns(common);
> +
>  	return 0;
>  }
>  
> @@ -2929,6 +2937,17 @@ static int am65_cpsw_nuss_resume(struct device *dev)
>  	int i, ret;
>  	struct am65_cpsw_host *host_p = am65_common_get_host(common);
>  
> +	ret = am65_cpsw_nuss_init_tx_chns(common);
> +	if (ret)
> +		return ret;
> +	ret = am65_cpsw_nuss_init_rx_chns(common);
> +	if (ret)
> +		return ret;
> +
> +	/* If RX IRQ was disabled before suspend, keep it disabled */
> +	if (common->rx_irq_disabled)
> +		disable_irq(common->rx_chns.irq);
> +
>  	am65_cpts_resume(common->cpts);
>  
>  	for (i = 0; i < common->port_num; i++) {
> -- 
> 2.17.1
> 
