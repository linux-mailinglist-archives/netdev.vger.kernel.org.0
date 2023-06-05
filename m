Return-Path: <netdev+bounces-8078-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8CE722A08
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 659C128035D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78987209A5;
	Mon,  5 Jun 2023 14:54:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6067E10FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:54:16 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13479E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976854; x=1717512854;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WAdqdh+jImfe/3dHXqJYpNRy6p1BuC8q/a/Y5nJmtCs=;
  b=Ax2ORCBrM1jee55bkkFivfxW4ZjS8UOy7UtaZlLfNs5O1CeZzZBvbfQx
   YLHTgXUFd1s+AegyIfppm7F/tc+Xv5AXH4MjlwfM6EFvJ/TVb+AgsZthx
   EU4corg3XfRcPW9IzN9pjqQUqx1VVTTBmn24HXAEMKzDwMZS8GJ1wfvra
   UZgHlMgyxJqJ3y+ND0/1OIRgHxTQQm1CGmUuY/Ni9DPDZsk/9rxaGEWUz
   zGABUYJsnJG1jfK4YCZSt5U+pqg+p1IJ9zSbbutgIb8HsoEvKl4oc1/R3
   30SozJ8aFd2M6qdUvnNs6OEVKi6pwC3LUVdfXAOlKOuayIvpKS0Y+6iOH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384691966"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="384691966"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:54:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="741753792"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="741753792"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 05 Jun 2023 07:54:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 07:54:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 07:54:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 07:54:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFlSUhS90J+9rvc6OcOeptra/APCFmiPwqVwlm8JQjbNBAAYR2afw5JLlLawNeGP58ANjw2xuOqyP7lDNmVIvkxpcvB+qObZyttlkgDpZqe8K/b2V+0rqMqi8CQxjhbnEN91IzRmiN92VyGukqUMvsxDJxQ5xWSIk6MGJmg++LufPeSSSmzm3BUH2boM6t1ncKMCzZedUkoGieaQPRODNwViAsoOdcZ6bgFEsaisA5NM9Q9M7kvG4ZxZr5tBXMfg06RFYYrZviBGoCbjv7MfhUdZwiPlFLKkOeIXrcITeRXrJ1StRJKWdn4g+5aDv9xD5FdjoPfUiNcCiDzmOnVkFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0z+nuY+gM/c5guaOHlTwdQ3+6377Q5t+9l3hvOl9Cc=;
 b=fF8rFxHtpy3i1VKI9q0obTcRJOYmOnNl9cC+TiNhuHYksO0AA+t8j9V0NJLPzVTcIqL4Ftiz+EIILC7elqDskT4BWHZFqVeHrw1kFdrzk6WDMlF9RWnbwo5cDNoMY1JQH6m9/0p7PNdp9sayMjI0wBbxTjzhtMGT7UXtyC83rnCABQKJZNJDPd9nd4AcrJwYOYTdUYV7T1wS4r5ysYqha4Axy/ULhfs4peFcbwt75TXDgfWJ/vti1WHxTHRAeSRP7J+MTQR/CwRNI42lAOIgayI1FGGNKX4jsvhKSyHSAzteD124Och50Dfx4AG5Sklmy07w3Uh/vbVrBwgIy0aCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH7PR11MB6553.namprd11.prod.outlook.com (2603:10b6:510:1a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 14:54:08 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 14:54:08 +0000
Date: Mon, 5 Jun 2023 16:51:21 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Juhee Kang <claudiajkang@gmail.com>
CC: <netdev@vger.kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <leon@kernel.org>,
	<saeedm@nvidia.com>
Subject: Re: [net-next PATCH] net/mlx5: Add header file for events
Message-ID: <ZH32aens11biN5Hy@lincoln>
References: <20230605075136.1878-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605075136.1878-1-claudiajkang@gmail.com>
X-ClientProxiedBy: FR2P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::15) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH7PR11MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: 922d8d06-6713-4f94-b15e-08db65d4b673
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIPaYLDUt/sTC4li6uB6VviCbkYd2LIdNjYcZ6TOP4fQUuPHH7fwpARK3zqX0RY1/JuK6xzXGanDzqcmE4AU0AmTyv+GtAMEYa8nmhOAzqKrPKfKkbxBE4++jzTC0EKT6Ox+hxs+zt5hL8OOPkZVeGrPEejxxwa4Yyw86FW1MAZE+jGyyrcaDyPg71BcuNZxye32PF3Y+8y6iKaVeI3ori3YamAn/rgwuSjo+28ZSRwbfYZ+AAFXWLs/2aJbHtvanNvhboCRVGDhzTcaIBx+/JTmfVbP9CxFJsPOqMJVFv13iaWi4/noV7fQAbXxkeWzt8QmVU8Xr3pNGtStbqrJVqn/19RYlkXBIgMIher8URfxJ6iUviSgbFymQQOxT42pMehOZdJZle2eG1YWY+sRSxtLqXgqqbGZTGPoBxWPZtgBm+u0pzMkg3nZG0A93UCy1ONrS903HO8lF4k3NdYz0RXTIA82hiGZOo+NUgLz2RQX4SjjF1oed1YMLLnUpur2RdB69tEk5X14MNJvM3DXWp+JxKivLASg+Ljn5RP8o33y0yyn9ldKuME7hs4mtV7J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(9686003)(6512007)(6506007)(26005)(83380400001)(86362001)(82960400001)(33716001)(38100700002)(186003)(41300700001)(44832011)(2906002)(478600001)(66946007)(66476007)(66556008)(6916009)(4326008)(8936002)(8676002)(316002)(5660300002)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F1qseqtsuEkhNV/pZ7Y+tAJ6DaNvo1vzPHpkBBqk3Ar7sNWFk6dXmz15vak1?=
 =?us-ascii?Q?P+RAZ2fJkhWltVxTR87jhzCX2Iy/iUhLaX9PScsj4+cB9EXuBDEpfM1fyd5B?=
 =?us-ascii?Q?QhCJnPMjEtvC6XirfpLfRIpHMTFGDWt/sELcWtUMTKCCbnnAyDfrhHXVyk5d?=
 =?us-ascii?Q?2YmjqK/wdJNPmqdlkYBvo27LNtKF6KtlJTTerYn1UZRhEcf0Mmrs4R+RLG/f?=
 =?us-ascii?Q?f8yTo/MDKfNcO1R8Acnm4ZriyJCcAmBtCPvCGLP1L90mTt6NESx/ekFJEQea?=
 =?us-ascii?Q?RtHjz05h/5hbGveMG7o7TLGdEDXUyn0Tfan6IZIKW/q2ljYY8D4RIzhn1fdr?=
 =?us-ascii?Q?Sm8zep94LC98jhrCWSKx0QXvPLsL1Nao+NPPjSFr2AEa4MgJKmOmQfI7zC2o?=
 =?us-ascii?Q?wcXFFD68d335MNPMY78iI7R/N8XCJRcLh/hnsCesPYGYASnnWTct0zkRojxX?=
 =?us-ascii?Q?hcjeXEIYhUcrrAK6exWInGKoYjrx7jdRcd2pumiw/VYDYRb9ZawcDwCRM7nS?=
 =?us-ascii?Q?XQ7IKQFOOqrTyXP/hXfigX2qbzq3RVJImAkehvBxTAUlc8vUmGMrKvzuEdSx?=
 =?us-ascii?Q?UOgH7Dn01xVIOFeZDPAoiJJr0vvr9A68BSRnI8yZjHEVCbA/lT2E6BiWx1SE?=
 =?us-ascii?Q?g+hDwH8BflvHH8mXhCJXpFLB4PpJq8jyUNuPnWNSeNWqqZharB/2nlaqmyHK?=
 =?us-ascii?Q?J6yb/hjoG1W+M2yj/AEHCIUrGdiNQ+YZOy2NXIrr+q66wll5en9EbKjdO1YU?=
 =?us-ascii?Q?9cEcs9oyW6JuLLFogUTNMVONQgG540YNqhkr4j60HJ79Xo8d5IvYErXRr8nr?=
 =?us-ascii?Q?e8FaPLkpYRjy5u+ke3uv7u94EIUs3AfF3uCxnbA2YWrlv6nIuvOoqsHwABr0?=
 =?us-ascii?Q?MbkAFAzciRJlzmsFYEJWETljc9UTLYlQrE9xUf4/ETcc4f3FbyMcBkO/PE+u?=
 =?us-ascii?Q?GipBPYZR7a8lzzob6Do7qmwQ8UfMgmShk0DAn7oq6t1Oozp0zpzFLju3Qs82?=
 =?us-ascii?Q?6vprPfiwdQFiCJu1wcJxv1vccsri0yWSR3bVXdrNl7RaZlpmC28xoVFPWNjh?=
 =?us-ascii?Q?ERdAKdW+3PFuFhHAIv7V+tH6omceAn646quntz2rE/NYzvkVwiGTjLfnd0kY?=
 =?us-ascii?Q?/KmSJyWW8RcpPFzrQUC9OZOjNeyELSQWFc3a1Aq/6BEURHQ8kn3bMV1euU/W?=
 =?us-ascii?Q?GyFm4Dg83L/SsnUNxtwZYhmmXsAnP1or4jDgPP9sajv6VYtKUBs2RLdFcgcg?=
 =?us-ascii?Q?u2VPcTQjse9Zv4rEuf+3+0s5KXJiIRldI7xF6KdnAOeb7Cevc4nMS4GU+jHP?=
 =?us-ascii?Q?5u16TSQZGCs6Puuv/0O6xv02w1VUsSZ3UTJa3Ul1zyksFBTEwbO9d+EPWNXm?=
 =?us-ascii?Q?9ZplNWg02e7kk6mnToT2Fy/jix7PUPy5/1/h3I9MG+SwqgIQheVerYDjPGaD?=
 =?us-ascii?Q?2UtaeSbh4MvPc7wUi/AVmebdKROySeDiX7ZM/ycohUBWJwi6H4mssrFUGM6p?=
 =?us-ascii?Q?ZWq9Ux/eiUXj+4gTd04YFHVNAJMv7oFhikujl1+aTlo3958Bb7IfHZYkv5iU?=
 =?us-ascii?Q?e9nX1XdQp7/QyGxO1eGzRjxdij/D+xRSgKItPRnHfZQ0ok+wyfiXYMx+GO0Q?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 922d8d06-6713-4f94-b15e-08db65d4b673
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 14:54:08.1138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJmtejBZIdfxO9scFNF/VU1D4hb0U5l1rCH5thR1U+dwmoXwIAmqIOdoEhhzmzACibZ5u0bHFF4lMef9lpp+ZmDcD01CNVCic8H4vCs4u0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:51:36PM +0900, Juhee Kang wrote:
> Separate the event API defined in the generic mlx5.h header into
> a dedicated header. And remove the TODO comment in commit
> 69c1280b1f3b ("net/mlx5: Device events, Use async events chain").
>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/events.c  |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/health.c  |  1 +
>  .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  2 +-
>  .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
>  .../ethernet/mellanox/mlx5/core/lib/events.h  | 40 +++++++++++++++++++
>  .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 34 ----------------
>  7 files changed, 45 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/events.h
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index f1d9596905c6..1ba70a90a476 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -30,7 +30,7 @@
>   * SOFTWARE.
>   */
> 
> -#include "lib/mlx5.h"
> +#include "lib/events.h"
>  #include "en.h"
>  #include "en_accel/ktls.h"
>  #include "en_accel/en_accel.h"
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> index 718cf09c28ce..3ec892d51f57 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> @@ -5,7 +5,7 @@
> 
>  #include "mlx5_core.h"
>  #include "lib/eq.h"
> -#include "lib/mlx5.h"
> +#include "lib/events.h"
> 
>  struct mlx5_event_nb {
>  	struct mlx5_nb  nb;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index 871c32dda66e..168c9e9ed2a7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -39,6 +39,7 @@
>  #include "mlx5_core.h"
>  #include "lib/eq.h"
>  #include "lib/mlx5.h"
> +#include "lib/events.h"
>  #include "lib/pci_vsc.h"
>  #include "lib/tout.h"
>  #include "diag/fw_tracer.h"
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
> index d85a8dfc153d..00da17d502e6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
> @@ -7,7 +7,7 @@
>  #include "lag/mp.h"
>  #include "mlx5_core.h"
>  #include "eswitch.h"
> -#include "lib/mlx5.h"
> +#include "lib/events.h"
> 
>  static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
>  {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index 0c0ef600f643..604bb1914d9a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -6,7 +6,7 @@
>  #include "lag/lag.h"
>  #include "eswitch.h"
>  #include "esw/acl/ofld.h"
> -#include "lib/mlx5.h"
> +#include "lib/events.h"
> 
>  static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
>  {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h
> new file mode 100644
> index 000000000000..a0f7faea317b
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
> +
> +#ifndef __LIB_EVENTS_H__
> +#define __LIB_EVENTS_H__
> +
> +#include "mlx5_core.h"
> +
> +#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
> +#define PORT_MODULE_EVENT_ERROR_TYPE_MASK    0xF
> +
> +enum port_module_event_status_type {
> +	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
> +	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
> +	MLX5_MODULE_STATUS_ERROR     = 0x3,
> +	MLX5_MODULE_STATUS_DISABLED  = 0x4,
> +	MLX5_MODULE_STATUS_NUM,
> +};
> +
> +enum  port_module_event_error_type {
> +	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED    = 0x0,
> +	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX  = 0x1,
> +	MLX5_MODULE_EVENT_ERROR_BUS_STUCK                = 0x2,
> +	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT  = 0x3,
> +	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST = 0x4,
> +	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
> +	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
> +	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
> +	MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,
> +	MLX5_MODULE_EVENT_ERROR_NUM,
> +};
> +
> +struct mlx5_pme_stats {
> +	u64 status_counters[MLX5_MODULE_STATUS_NUM];
> +	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
> +};
> +
> +void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
> +int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
> +#endif
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
> index ccf12f7db6f0..2b5826a785c4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
> @@ -45,40 +45,6 @@ int mlx5_crdump_enable(struct mlx5_core_dev *dev);
>  void mlx5_crdump_disable(struct mlx5_core_dev *dev);
>  int mlx5_crdump_collect(struct mlx5_core_dev *dev, u32 *cr_data);
> 
> -/* TODO move to lib/events.h */
> -
> -#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
> -#define PORT_MODULE_EVENT_ERROR_TYPE_MASK    0xF
> -
> -enum port_module_event_status_type {
> -	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
> -	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
> -	MLX5_MODULE_STATUS_ERROR     = 0x3,
> -	MLX5_MODULE_STATUS_DISABLED  = 0x4,
> -	MLX5_MODULE_STATUS_NUM,
> -};
> -
> -enum  port_module_event_error_type {
> -	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED    = 0x0,
> -	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX  = 0x1,
> -	MLX5_MODULE_EVENT_ERROR_BUS_STUCK                = 0x2,
> -	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT  = 0x3,
> -	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST = 0x4,
> -	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
> -	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
> -	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
> -	MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,
> -	MLX5_MODULE_EVENT_ERROR_NUM,
> -};
> -
> -struct mlx5_pme_stats {
> -	u64 status_counters[MLX5_MODULE_STATUS_NUM];
> -	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
> -};
> -
> -void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
> -int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
> -
>  static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
>  {
>  	return devlink_net(priv_to_devlink(dev));
> --
> 2.34.1
> 
> 

