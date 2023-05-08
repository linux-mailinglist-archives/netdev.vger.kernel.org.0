Return-Path: <netdev+bounces-850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 495736FB017
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04634280EDE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7154C193;
	Mon,  8 May 2023 12:34:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382915A5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:34:27 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3964C16;
	Mon,  8 May 2023 05:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683549265; x=1715085265;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=17U3HZnrgQKzEgcZkA+IWoXPMseBx4twxSpRucVuv48=;
  b=BuhYo83Nb0U7V1TjffyZAU/sTgyC2zeqmXSIM/zM6S48jfTKb9GyFZTZ
   mM2GzgX162ojao1mGnhlZV1wvVCNIuxDbu8dNikWm3OWsR47THpUaN4Nc
   Q04Osspweo4Hwne0oH0lEdZfZzugSVHorrZFiPTzcq95uAAHrMw8K2+yA
   z12XPCKE0nVs5dHvagyHUWxip+XCjTeMSOhVoP2VXVhZ5sEVdw8c0/enx
   VjgZXn83I59Snh3dZjCgF4XAjoBgFMVN8MKm6QcbzuZGVGzLb3E7bIo2x
   QRQ3oWgKor78ZZCkhlKuFdsPADR/4fIw52S+2uEfSTPEouH/BwMhkD4VW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="329254770"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="329254770"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 05:34:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="731280834"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="731280834"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 08 May 2023 05:34:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 05:34:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 05:34:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 05:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9KyMgqsr2qC021zS/j/qW75MksBJLUlpsRi8GX9KyQNIkwj3/qBdmWAQt/f8kAJforvpAOIkMZfjNqhqn37K/hKDWfLhWffaNEFNNGM5Vbo2tDScmV1TrthKS/oit0Y5H/IyqDGn3ey/jE3u1Hw4fBQMD/gHMCvItsTLUiHZSozpBugLTTdyOJ/R+GXVj7U00ZeyvqSpPuqLJATp6h2bcwJwr+F+euDh8HLqHrADCf6lwF753IL460waZ0397n8w08BPUBGbLBoPwpsrst2yhE5lPQ/PH7+O99aBoo0Y7lVCIt8squcrN/2KfccoqbZ20GxdbrUhwlu4vgdBArxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiU/GlABYMtQoFLa7C4efekEdy/fbKk1uM0NBhvSUp0=;
 b=DqY/aNfn3OEPcPtIxwxBJJe4rR66imX6uu9TTvUXTN5/G4kkLeICuPkVhoGpxhbVFJI6fW0hIj+kHC1Pf6nlqtEeP09Qyd2Qz0fz/a0QHi94ROK8oYBJotPhK+3hSuzV3BSCjBUCMhP5WAwzmNnW7ljQuyu8gkei2FibhnzuG9zRk2OvMGRD+dui3uXSpD8lyWIFDRJdyXMBIfi5TPnnHiTyjcgd8SfBqQuvz2NOnMiBsmlnd28aZCD1kQGa70IN+bZOfW9CJ8Xg7OMaD4NfhlloozaB2AzbGIoCb0xelNU72snvGkMC8U2OmLK1x1oe6h6THkP8f8UgTGMDNpwHGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 CH3PR11MB8212.namprd11.prod.outlook.com (2603:10b6:610:164::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 12:34:21 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 12:34:21 +0000
Date: Mon, 8 May 2023 14:34:13 +0200
From: Michal Kubiak <michal.kubiak@intel.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, "Paolo
 Abeni" <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Tal Gilboa <talgi@nvidia.com>, Leon Romanovsky
	<leonro@nvidia.com>, Roy Novich <royno@nvidia.com>, Aya Levin
	<ayal@nvidia.com>
Subject: Re: [PATCH net] linux/dim: Do nothing if no time delta between
 samples
Message-ID: <ZFjsRZzWIozLEgDW@localhost.localdomain>
References: <20230507135743.138993-1-tariqt@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230507135743.138993-1-tariqt@nvidia.com>
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|CH3PR11MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 820b5dfc-a8a9-408a-3e47-08db4fc08c86
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwjcOY7SBoYY5zQGPqrH8iO3xF6nUpuvrfK/mFcirgKJfbqS0dwkabtfPKipWMCwZWWpyhMzMadFhEghbZ1583yfWJuzIngPnxqXIWM9ZuVyw5YxW+liIR2Gm7IF7QWykQRNxa2xI4aAHeeIPD84f807khzFyHxq1H0VWVpo5JE4JVk9dxmOADqk55HWCFJftyqHBqn0K8BSpf1ERHV5DmLTI8eT6FSvgREnSV4B78LJeQ2BARJ5ho8+Ibf45nUzUtnbZ6RqrVYJW6llWwVuVYS0myZQLcqyJF3WnoWzGrgLPcIfMBFrPDEtuwD7T3INCLc0OHO9iO2veu6qBJBZgkl2+BWwUv+Bt1IiG4EcXYs3bKN9W58gD9DV7X1c/x/6eznMC451L7GvWsIxEivYzKF04Cnvo4WqDqJSLeUmlBHBhid3dOZVIiZGkv6yJaPqjtQuByOsVIhDARzlZdYOhozDMzIHn/sCcigZdPychOKEhFHSo8hyHMHTi1SGK0tBeomJ9IBfCKurn56CuuuzqIfgkqTM0qfhdNl7L0muM34uVPgbML+PWLtdJTQf4imu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199021)(6486002)(6666004)(54906003)(478600001)(9686003)(6512007)(6506007)(26005)(186003)(44832011)(4744005)(2906002)(7416002)(38100700002)(6916009)(66556008)(66946007)(66476007)(4326008)(82960400001)(41300700001)(8676002)(8936002)(5660300002)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjK+VTl1Nlv6veUN87z/xAN3MgH8CrwCeXUHl06Yf/L6uEZLNwV/g2hiBOMR?=
 =?us-ascii?Q?QFdxTIxQa2Qldb4GQaOPUS7JclidmCLz22aTO5AMhgTdPyIgYQ/wBdKswS7c?=
 =?us-ascii?Q?cHruaq5SaWv4e7YN5pViCl6UJMnb6AO1LoeC0lzZ+V0f446NJ+R00GgYkPch?=
 =?us-ascii?Q?0LQJMHPqIojP/YUnk16U0lv1VHTZy2MWU7ReNrxnw7eFvKaiQu9ROveYDTi2?=
 =?us-ascii?Q?NF6++3YLENPQwQPjgkr8IJcMGVB+iAXzl6GzW+CZPNwCuXxmhTobYS2FISWp?=
 =?us-ascii?Q?Y/iQE16txVgyQ0WxRySyJFgqmlr1rtuFK+zxbuIhH+WhMSlh92U9HZt3b7Jq?=
 =?us-ascii?Q?4V1/hSIYnv1MtS5HKQ20BmEIZcSNJmH4b+H/mf2aDIS6Bi9A0s7DQH3wqe9Y?=
 =?us-ascii?Q?2eLDml8eHed6zvGOgpFU6xU30FwR3fsq+7dBo0LQN3wt/4bc5didRqx9bx6t?=
 =?us-ascii?Q?NFD3brCXvYRdg+Qto4ezfBxyQk2qXPAxPIkBnwll1RyV/dw6rHYdepYkl3h1?=
 =?us-ascii?Q?uWCx1Lny98pQGoZ2bhcVub5DkqCbpx1ZY3YDDe7fqZZiPNDacDBVjR+Pf+t0?=
 =?us-ascii?Q?sZEqFtYF8I67sYkmUAFZde1AU9ngPyB466DMUNPdJKVMSbKtmPui5euDgD7K?=
 =?us-ascii?Q?wl1YnYEtSr3pqZ8EsIpu/zzSymFfyuEqgFaD2UdY1vyCDVTjbvkqdTLAND7h?=
 =?us-ascii?Q?LSZwV9cAgqgMJY2rhefHAAnUfMkCpgfnfJMcL8zTpTpbFLanGRUWl8F1K22+?=
 =?us-ascii?Q?pyeOxjxUevl3o1EZFPSMUstJryM7lfrBA3TKDaMrSLRT8/2/fYcKrYirKTsR?=
 =?us-ascii?Q?qkC7eUOrF9e36i/DhNziIWP2I7e3jTlU3ow4w5uQv3OZpi4fqiO4MPeQRevB?=
 =?us-ascii?Q?qJzcRXZMy64cEBjan/WeS3OfFqqB5jXKSL6OnPTsJXW6nrPIiZmlompGJWCg?=
 =?us-ascii?Q?2DGE4ZlWzGg2gCDjCpOWYmwLtmmBDfHOAADLR+c2rjtfd1X6Vgj41d6p/RLN?=
 =?us-ascii?Q?xGpEfCNqhrt5YeZrybUqkjBGUVEnmJb8iz0qiTrDMpGP1FFvHNoC4dxWq6xA?=
 =?us-ascii?Q?xCUsdXeR39Z5wnGxiex+kKwhq2F8NolyQjNWBRwzf0m2KPOdFNTKvRQ0V8G2?=
 =?us-ascii?Q?K+HzfRbck1N7edtE36xMy/2UrUz/avwoC2uE00vlfUvqlPm0vH4xbmz/EieL?=
 =?us-ascii?Q?rOXNo3hx6sk/Hsd5ViyngXKx/Bk+S5UxJobq/Nw52vXP8q/ezgxOEYtE/hAH?=
 =?us-ascii?Q?StrneZsaj81fGvZxD5C1L+VJZBvG/wqXCxdMJFmkClii7PgD4OkaTYUv/iNh?=
 =?us-ascii?Q?UeaZEGvLsns2sxwnMY8WRxGiK0xlFeqmY3V3XY4nGw6OgqaGg2mWkgJQa8N8?=
 =?us-ascii?Q?G27u3ox8TKSIJGBYD/z5oXWDeMEu0+SEJcPJncObAbpPr3ZcGQORP+kjR34h?=
 =?us-ascii?Q?zm+rP35rYLVFNyvxhjH4dRP9rnJXeBCBo8xW/12Polf5maMdPxh6OihvZW7e?=
 =?us-ascii?Q?gp38SAJlScSDmNwby2KDbxgsxwjXuEaTuhFH0Y9JeFnYHy6JF8MXA22F08e8?=
 =?us-ascii?Q?jfXN7+AlR5xiOgCzyG52+G1O2gaof43/T5sTvKLRL6c4quPIssyEXFfQiI+4?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 820b5dfc-a8a9-408a-3e47-08db4fc08c86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 12:34:21.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6INh/r/r1z7iwhMGgnfThFyIGufg98iFbWcMAwItKMo+2r+czbi4H9G5ZS/zqihcpsMugb+DBjUI48FzAQzT8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8212
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 04:57:43PM +0300, Tariq Toukan wrote:
> From: Roy Novich <royno@nvidia.com>
> 
> Add return value for dim_calc_stats. This is an indication for the
> caller if curr_stats was assigned by the function. Avoid using
> curr_stats uninitialized over {rdma/net}_dim, when no time delta between
> samples. Coverity reported this potential use of an uninitialized
> variable.
> 
> Fixes: 4c4dbb4a7363 ("net/mlx5e: Move dynamic interrupt coalescing code to include/linux")
> Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
> Signed-off-by: Roy Novich <royno@nvidia.com>
> Reviewed-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---

Looks good to me.

Thanks,
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>


