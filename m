Return-Path: <netdev+bounces-2959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D37E6704AEB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F47B281680
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063AB34CCC;
	Tue, 16 May 2023 10:42:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353934CC0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:42:53 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF81E8;
	Tue, 16 May 2023 03:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684233772; x=1715769772;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xV88Pv9O9p3Z28S3NHVynfZVzRQB5z5Yee63yQoG7zE=;
  b=V2sgTjj8YHgPjb2z6Yzav/PLtBsH8grVPPUPQS2Ai1IQ5+j9zcsSjBQA
   DmHicRzLGBV0l3rhAQkECbyOG8yFxx+xXZms8egc6hM9XXDA4oDluV5gt
   3CO+kPvKbPcUO1DJN+wYO/8NTiSqiyebsZQMjOBO+Ocq+5CLRWHcY/1QD
   8LMOhUQvDS2U+9yPS/eTlRW7xM/CdnOkSbRhlSbqkGRabyH8a+dGz0ZoJ
   uoqvu/ZpBbdVd95wiWuFD45cRy4eLUkzXTYL36A3quHWgSSyqNa+FT7ER
   8LBpUMV3zYsDRYgAyqCet0/CdZ3RjZ4Vg1Nwiepw6mxqiDGbDo+O56Lk7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331805001"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331805001"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 03:42:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="701305961"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="701305961"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2023 03:42:51 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 03:42:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 03:42:50 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 03:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZppPvAErQy8Qt4157pnnnWEQ4yb1kFPDBbaTrbMDoXPForD7tG/Oye5fMrksA6QWT1s8LAPk6cw0eqFwWS/KIaEaXgQmkSErV2PShAc82kkhQ1iX8BHG3d0hCarJ/4FyXG+4ollAg8muPjbke3+AzrIO6E7LqqDk2AACAPZi9rgBG7Wkp0qGg9pf7S80w9QOU7Ih9KOP4wZ7OBXIAyA2rUH36SEcz9yKmZZxP06szLKtWTUifkF14HhBZKcYzd5iL42qp2QbLdIIPn9xjjeQDGOVtrklFXjOeZBN/4paCo/CVJHxO8gRwEnXqXqMQHc8qSI/xcq2Hg26B7cAA9D8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWc8xW0YWNm/tDyJ6lFEjxojDDMgWTfx/2qc/yExnrU=;
 b=SYKfVAtfbH2lv5RLKvUEyio/glHhvmK7Xl4XRcgY2BNC71XgqYtSZcc1WUY3HC6akOxqPoNb7Hv87D5kCVFvbvJARFZk8+qN/JG1cux8s/s4ulHAcGqvsbzicA+BcMb4uLMznPLrIvlDs9PD4UCsrV8GSUI6AWpvkzu7QPI98DnZ+h7/WGA4Z8yZwWYNc3H2BNJYajOMlXvanC9qoD0J7urVcnByY+oOHfxJjC3KoVnwlcrElZdLVpkyVM/s6SPBJ8ZdvjfpHzLEx+P2oYR6VeacKBq6osTq1zQhqUeEAe2sSnK1YAPVGepEz7FcX7xvUtGL2jE15aYuofnLsPbkMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA3PR11MB7656.namprd11.prod.outlook.com (2603:10b6:806:320::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 10:42:42 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:42:42 +0000
Date: Tue, 16 May 2023 12:42:35 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Kai-Heng Feng <kai.heng.feng@canonical.com>
CC: <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
	<chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
	<m.chetan.kumar@linux.intel.com>, <ricardo.martinez@linux.intel.com>, "Loic
 Poulain" <loic.poulain@linaro.org>, Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wwan: t7xx: Ensure init is completed before system
 sleep
Message-ID: <ZGNeG1O1yS229nPO@nimitz>
References: <20230516080327.359825-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230516080327.359825-1-kai.heng.feng@canonical.com>
X-ClientProxiedBy: LO2P265CA0139.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::31) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA3PR11MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: 81aa33e0-99e3-4df2-9526-08db55fa4693
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5HB4uoKD5oqrWD5hvVwtVXPLktGGmaAJqsHxON84hGdOQZXO7gn72rJrIQh+HGZd3fjsFBfIfv4YiK3kszKsaJJ6lh1SC3STRgShRnbzTUwL3SdQ1iIY3hrkt5uNReO2P+Cxg9R3HKdnL5hEjcDc7l8TKOSx+tABMY0nHpFmtHnlkM25S/luOB46KajS5GQJLR/0JWayZLCqkkmksrTSsLio3V/gOHUxu7cnck6udmsZTT7897ZcszTSLN9FkvsyQ5O8AnwznOXmBE+MdeFFaJCZVqSOf4YN+Cs71yd7E/g88IY/l+XxVhBUiyelu7e+MX7l7svq7q+7jD6w1mF6RSqX9OBwHvfMdC8x4BcbuJUUUdrF9oTbPBxxuLxHAmntE4xitT5+w/u/6bej8TkymKnXG6CXIWeUSdMHgcoXChNnsGkBkn1vTY5DV+HjHTxiY7vdon2ShJwJ06l9DlGeFQMeuhhoNwf2LqzM+co1PaVEAfPfwVDRaCyzlO9IQgOQcJwAnCugAnEjp9zOPtzUQtCz8N4id0FjwhVbRHODdrmr3hVMXl/vk3umD85/aHj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199021)(66556008)(66476007)(54906003)(6916009)(4326008)(478600001)(66946007)(7416002)(6486002)(316002)(6666004)(8676002)(8936002)(41300700001)(44832011)(2906002)(5660300002)(26005)(82960400001)(33716001)(86362001)(83380400001)(6512007)(186003)(6506007)(38100700002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DG3PdQx1qK+YJVnBJrX0vIq7HuTKlTOUrGYw/zieqTjopyzaiTqK4EFbLcSv?=
 =?us-ascii?Q?RhnbchWTll2vZntTxu3iV6/DVhI7bIQ94KvJBorFpayxi5TaM6j/hO5G79sv?=
 =?us-ascii?Q?947zpcCzXviPslyrTGYEbV9j6fj6BLNrg/kLdhRJFhFiPVZKrvhsYGxLHLUu?=
 =?us-ascii?Q?Eh8EiO3wkw22Q1N9si50LhPF0zzCncj2OWqbLIhupUpxOcuRqVbrih/pYlpV?=
 =?us-ascii?Q?twViAIu2PPxARfLdvu7ubU944DtowQzVo0u4Tqq4E41gzUaRWS6iIhlyVtJd?=
 =?us-ascii?Q?EvPLNlVH1BCrhT7LCa6MW9pFN9M0NGaXhs44bIJ6yO8aJ6lw3mDrEv5Qvq3N?=
 =?us-ascii?Q?knMGfHdQHNecLRUIryV0q1EyprrBxGgV3KFw12hwDtlh/rB45pkpW/ss8wgi?=
 =?us-ascii?Q?6xbwHY3zWWL0PM35iFwP0vhr3FQqQQIn4w6p6SXUzmSOknMwh9j7ZNfeegqk?=
 =?us-ascii?Q?9xZhSzUSxsmHmq7Oo7BdAOrMpndQYgPfiC76e4T1g9IkV+idmCoaabmLpUbV?=
 =?us-ascii?Q?28lIIga4+JmwgoIjIUARtLWSRGTyZTdYl/s4KEbTs69OZXdypm/dixgexWqD?=
 =?us-ascii?Q?pN/63kJT3RUTJO0W6kxH/1YgbZM8YomxSghw2kjZ+9+prMZTp9mYXOGWTnfY?=
 =?us-ascii?Q?TLGK57YfLUJyON4kSDVcs0TUtC/cWRNdlO0lVqYWQPWWoezV9cWHoLRgV3Rv?=
 =?us-ascii?Q?oJmG0kukvOiHm31myLIoLUWd1G7Dn5lXD47YHV5bONJu+LlSa2w6ly3c4WTP?=
 =?us-ascii?Q?N13+KYYY07C6J9G+i4k6htqByRsgw6ptR3mzhdpFdK5WDS1c3m/47QM8DTJK?=
 =?us-ascii?Q?JgRw7uHDGFzhrAvcQE18Y6grXPH3KYItmOtFLpTg3F+jp6rk1Ilt8Q/a+fOA?=
 =?us-ascii?Q?DLRVSxCHVhGFvtT+smKevoxfhC5ucnUFshinIjJ/SO7ygdt2cRrXPC6V82fK?=
 =?us-ascii?Q?54xFcc/uns/M3m1YA6WpafGWpRQXZmjTvTzb0tu0xV5NnHDOzQt0Wa/fhFrS?=
 =?us-ascii?Q?sl/kgfWJlXg+tHR8nuxSb01+fgLG0c0/54yC6EmngoptD7g0T3txVXm6auvD?=
 =?us-ascii?Q?SNAS3X0LY5IlNIyb3S3B/6cBaDFpjsVsoStNxESEOJoDLuPeT4FfWzcSs2el?=
 =?us-ascii?Q?Xnew32DfVRTFFcKh/AgF2Q+JKcpjPNWSvgvhu2oFJ8bSbwMSbsXqe+0vc5DJ?=
 =?us-ascii?Q?x0AT9C/lESiykwjTgPDhWqW7dTvPcx9sqmiiszd2jwyGXXpslxJLuA+BlymL?=
 =?us-ascii?Q?L9zkNxmAMAE7jDgoiEnbZor9TE3cWKpVO7OFUYBjlUmPapHd/T11giOxaF1b?=
 =?us-ascii?Q?2y8fuMM/Mu5TxU+jYBfSkadqYduUVgKw8RecTiesWhZNw0oRuh16dVBFLeMC?=
 =?us-ascii?Q?aXJwkMNWm1XDN9oftMPwfi7BcxNf+XBkNoW2ckg64QgtzcIcBqXPJwjWOoOP?=
 =?us-ascii?Q?rU8q2EprlQEXMOrEj6jGnqE6mgEZpICwWMLmSUAQkDhS0cHP0vUKV1leNBg/?=
 =?us-ascii?Q?mNx0nXEl+CT98PLhVyVsuCphHsV6+RpCoIGZ4iuhORbF18cYniYJteyKbNqY?=
 =?us-ascii?Q?XNFCrG0NaD7MDoMux6lopovRk39LoykunnpYijtdmQeb7xv90IaZSS0YyvRm?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81aa33e0-99e3-4df2-9526-08db55fa4693
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:42:42.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAZ5R7WS5CBvhDXNeudcZMy2zyZ4SJDN/jaoaapJ4PqCAHuGRajLzk+lh6zGOpJ49j1hv1txyAL1B2sbVDzqX8fc9ZMnQHgoL8hvDwIIMUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7656
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 04:03:27PM +0800, Kai-Heng Feng wrote:
> When the system attempts to sleep while mtk_t7xx is not ready, the driver
> cannot put the device to sleep:
> [   12.472918] mtk_t7xx 0000:57:00.0: [PM] Exiting suspend, modem in invalid state
> [   12.472936] mtk_t7xx 0000:57:00.0: PM: pci_pm_suspend(): t7xx_pci_pm_suspend+0x0/0x20 [mtk_t7xx] returns -14
> [   12.473678] mtk_t7xx 0000:57:00.0: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x1b0 returns -14
> [   12.473711] mtk_t7xx 0000:57:00.0: PM: failed to suspend async: error -14
> [   12.764776] PM: Some devices failed to suspend, or early wake event detected
> 
> Mediatek confirmed the device can take a rather long time to complete
> its initialization, so wait for up to 20 seconds until init is done.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Does it fix any issue? Anyway target tree would help here I guess.

[...]

> +static int t7xx_pci_pm_prepare(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct t7xx_pci_dev *t7xx_dev;
> +
> +	t7xx_dev = pci_get_drvdata(pdev);
> +	if (!wait_for_completion_timeout(&t7xx_dev->init_done, 20 * HZ))

#define T7XX_INIT_TIMEOUT or something similar wouldn't do any harm here.

> +		dev_warn(dev, "Not ready for system sleep.\n");
> +
> +	return 0;

So in case of a timeout you still return 0, is that OK?

[...]
Thanks, Piotr.

