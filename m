Return-Path: <netdev+bounces-8788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49405725CB9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F4C92812A9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4198F58;
	Wed,  7 Jun 2023 11:08:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4106AB4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:08:33 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBF01FFD;
	Wed,  7 Jun 2023 04:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686136079; x=1717672079;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bkQ7VbJbZJwOa6DGpeR0I2chkxjxEIlOXSCXWEKnbUY=;
  b=Nz/o1bRX1TbqvhVu7sO95ggl0FcG0Au1ZiRndvFNbwyqTCcUpGJDRxQ8
   1FJFt1FKVZiOv9/s9DvgTqbxE1cTyZb2KzpGfVzGR+p5OwXYVIr89ut07
   kOHWh7ZgMyHGi36O0gWSMLCkorPH5Rg+lJI89Zt2Ign+eMT29/CzcmrNS
   X016vDUI/jHvXX47ykUO74qUjuTHKLOp0FkEPcztI9fnzg3QWYfXCN03I
   UUYDka/BVp8Mrh1750ANyRZnAeKqQYO1liKzHfXVOx/4wXeHu1mnnRC/P
   NpbOykF3XYZTooCnCyBvX+JB3bPpwBoTMIyYRSHWb351c6m/gHiFPQUNb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="356966729"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="356966729"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:07:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853838412"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="853838412"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2023 04:07:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:07:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 04:07:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 04:07:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxYxUGzcsqB5The0fBWiks8qDZP1ogfA8qYUA32GesbMmsG9CXao74FrtpZTfdwx2efYbkHatBiaWJRI1KJuEPZ5m/qwFzaiyb/kX90R/r/2dEenFQLVYJl5bsaZRPmXdFS2Bg6MG4abuQhAjgQgF01NZ6BVj2D7PNgxhftlH64QhqJbiphaaPioXI/NtyFMDDI+eenuF61CrxoTAtrZ3Fm/YwCkJ0FmvF1ms7zA20HqOViW017b56Otz0B9RUU7d1t1xwwJe8fx1qNtuiUNWysKJ9GrJjm2wkTxyjIVaTzpCMjHeBGZQjY8ygCrGJc8CRiz96BvP5tFuud/yIcKEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4gdmqUoIXU+MmKQlUqcovajCSIY8htjan+5gQP/8uE=;
 b=GMdWs6ivQ3ruRsSLh1oLdGKL1eLdKTeOHefBniQ/62Af4tajqdPZ2+hHIUs7awugvMiWz8NuFFDfSbOEQ0ok+D2qL7JsquGfb+wZFJY2dKHP/VU8YTJ5ICmoeuZBAtUB9xmVq/KHOepnCGKJZudqZI8y84IVmSOVxow60RwMqWg+qoyDpnf3aPlpaViEiwveOEE5Kl6eTtfLvHyqVhRzoqAeIjK8N8dvSw9Y4GYCu4+pJwJXHW6RG5C3P+hFp9NqmNmwotaoqHzg+g8Lt8fyghwZ+Ks3yp55SeCsCKnobbzYYl0alLwQSV3NiMRoGi+WBmyXmSou50HaaDEb00ExXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN2PR11MB4663.namprd11.prod.outlook.com (2603:10b6:208:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 11:07:19 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 11:07:19 +0000
Date: Wed, 7 Jun 2023 13:07:12 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: <wei.fang@nxp.com>
CC: <claudiu.manoil@nxp.com>, <vladimir.oltean@nxp.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net] net: enetc: correct the indexes of highest and
 2nd highest TCs
Message-ID: <ZIBk4P1MGWsdKozn@boxer>
References: <20230607091048.1152674-1-wei.fang@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607091048.1152674-1-wei.fang@nxp.com>
X-ClientProxiedBy: FR0P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::22) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN2PR11MB4663:EE_
X-MS-Office365-Filtering-Correlation-Id: 56510d7a-34e6-4258-50bd-08db67475c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UYnLnbKCPS5QMuguS4WDCNpAwJtDvLuoxSwgTuYwJtyUEoBconuiwOnWJHCyDkb6m3cB7ws8Ej86+Frq81fjTMbGryvU+6x/wLiOkI9SpKjuyOdPucb9z4FjDpHo6bOWnD3dB5t8+hxcf+qVb83+rL+rlE2sMPZ1rJiGQfpzV11WahGZ4V81WBWE2dn1kbEXyzdwdtmMMBbT3rIIZ9Ei9pQgREFKHxgzH9InxJwhNm3KCGGHKsFdSpSiaOQVkHGtENAGIKs14Dv6mjAJVh40Y497J4EvOi0JG/rnkDB+kZVUhO5UOjqqF9K+o/Q9aWYvN+oOVyvwQheoupCdhk6MWBhjoQeIGDn9UNlEb8HAyR9VXMYOsdAcN/Nk49I4aOgj+lbHEEHLZF+rMmo31zr5zKKwbYs8TmUOc3qQHdDIkl1wWqVlBlVsfIEDuAZyFuJHKKn4ry6HHtr5zsiSMHszDN4Vc0CTlkOg0t/LrAsrKnfAnfE/Z2IvJKPxtBXXAWZtCg47jaywZTu2+44+SypjjomlKIYJ3VF9RqGY36SRJBZIanX6TJl174LoIWumQjko
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199021)(478600001)(6916009)(44832011)(8936002)(66556008)(8676002)(2906002)(33716001)(5660300002)(86362001)(4326008)(66476007)(66946007)(316002)(82960400001)(38100700002)(6506007)(41300700001)(6512007)(9686003)(26005)(83380400001)(186003)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GLT+Tog0HzcVUdVS4EcYp5j7Uk0M/8dqM3yf6nsKxAf9irGd4j5C4LMEBhSo?=
 =?us-ascii?Q?Ib+mKc04GA6OTBpH8Z4qFPW5SkFprtL1L+rQVXEBxzym4KLG3thi2I13NGYl?=
 =?us-ascii?Q?RswSFPYm7WctKrmUlpnc3v4w8NbAqcc5jNlQf1dnLOCgaaGOmhni2znpyQp+?=
 =?us-ascii?Q?jtAqc6ClUGi5AjLQCBr+/MGVwXtDWiZfl1AaJ42y9QA5oWojqn/uSioeK+YI?=
 =?us-ascii?Q?fQd0/K1B9ZCpPOoBftvX7nV15JPeikjaCnpMuLGRRVhjHWiCgi0h0rEPOYB/?=
 =?us-ascii?Q?w7VKysx8hMwI6MsHlfXRf/9e4+WZRJll/s5yqtE7BeiHMkGpfYpuJU8yUZ2u?=
 =?us-ascii?Q?juqOofnijVRxZ/odNB4QvqSgzDkEmOjTRRHRs7ylZZZboZ7O06q8nzF8n/0Q?=
 =?us-ascii?Q?nGIEyXzMJ+aU++Y4vfUf0Kklvi1838HVINMmFoPr++zpJAF/wb+mTKFin2k0?=
 =?us-ascii?Q?CYmI8zMo8lkpj4RqqGe3Yp2Hn/G+IG3vWZ3yzd9akY9qYzqD6Wct8f1wG9tR?=
 =?us-ascii?Q?dU2ONOf+CzgsbKmR1pQj34FQNV8Z2gDVTKvRUDRj0wUKctgHa6ya5GH5QQ6M?=
 =?us-ascii?Q?3Sc5ptLI2t63QFl95gEJqjwm3mrao8g87SwOLv5L8qrIyHXLDzvgPlZAHOmY?=
 =?us-ascii?Q?x04kYguGYKRS07CrLFqkaZDBDdamtLfwKMRkQ2exX/VzJBX9XmFawyM6ohUQ?=
 =?us-ascii?Q?ASQXH4bXPsGOo10UF4bRa4J/KQaO7ihxc9f4dzF40KSTyFt6UJl0trCVDQhq?=
 =?us-ascii?Q?n638vfOASc1Hmd1TlKKbE6gWSd2hYSLyqe3ar9Tvt2/05VeeBwHpOOvzT6B7?=
 =?us-ascii?Q?mtvdoJDXLHIoNNe5PtKDz31Q0jHi+87S+xEvVszCIamLQ4IOxFZRIQB4TRbJ?=
 =?us-ascii?Q?wGoBKH/2Mlka2mXnknL2INMrXNBExuMdNYVJol00X0lKSQxoGoQrJ3nWAs5y?=
 =?us-ascii?Q?D6khQn0dUYEBdI42naEKFGNJCqFlb5wFJk0uWBtVuB9G8Oetir+saji7BR/1?=
 =?us-ascii?Q?WjYbQUzxjnP9wICgkXqyv0CaZ5YYNBoo747uqcrkWvdB7Id6vhi9LMn4na7V?=
 =?us-ascii?Q?BNJHgDsLGcz3gghE4ayniLLor3Vzwnwy6M1RsxETYZCm+c0xxDez6PXV2biA?=
 =?us-ascii?Q?PLTb3FBbVYOMtuF415LPrr9QwTkx/te9ZqjCTL4qEmLRBhb2BkY82A8+41As?=
 =?us-ascii?Q?JG/dz8DWKi5LUdmO4ZSnn4DwM1ESHhzWHsR5mdLHSMiz2+sbHTsl78ZxUFv0?=
 =?us-ascii?Q?twfjrFseZw8JQOAGdP9orVffYWLKlcLnPG+9Bh1gcGVryjT3MFegFC8TPFQK?=
 =?us-ascii?Q?uAo04sDWz9A8r9GvIAZ1jzAjlZtoEikX3ZPF1q25VO5BY9dL9et0DhpWM5Pc?=
 =?us-ascii?Q?HxQRTR6Q/QtUCDLkWtTceQrwVjNJC0Lshbz9ksKRm8hgGrnDGo5TnG7FRIdA?=
 =?us-ascii?Q?d5pcBV8ST1hHvnzn/v9IUkracsgsiRaQRnsmoo9NeklTIQ8dCKVk28GJuBwl?=
 =?us-ascii?Q?p8eZhlW0PjdQZHKqR9ey47eHG3gkcqBUucHWryTHIwsScduyHwgBbFKrNIU2?=
 =?us-ascii?Q?mZBLmX085SJnLK9L+/PgVKhg98KC4aiq7YwH+/cOxrasjzngNHceQ+WeLulw?=
 =?us-ascii?Q?Solib4cyJEAQth2gmL6TGrU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56510d7a-34e6-4258-50bd-08db67475c5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 11:07:19.4816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zdOJQ42j9ZmOu8rPAn949WgHzWNUz0sA3RDl0uwhoFVETySsgqEO8jNhak+zd3hagA/o2Vj8cW5W1h3EnJHNqg6s8WLsqUz6aDOq/7327hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4663
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 05:10:48PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> For ENETC hardware, the TCs are numbered from 0 to N-1, where N
> is the number of TCs. Numerically higher TC has higher priority.
> It's obvious that the highest priority TC index should be N-1 and
> the 2nd highest priority TC index should be N-2.
> 
> However, the previous logic uses netdev_get_prio_tc_map() to get
> the indexes of highest priority and 2nd highest priority TCs, it
> does not make sense and is incorrect to give a "tc" argument to
> netdev_get_prio_tc_map(). So the driver may get the wrong indexes
> of the two highest priotiry TCs which would lead to failed to set
> the CBS for the two highest priotiry TCs.
> 
> e.g.
> $ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
> 	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
> $ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
> 	sendslope -900000 hicredit 12 locredit -113 offload 1
> $ Error: Specified device failed to setup cbs hardware offload.
>   ^^^^^
> 
> In this example, the previous logic deems the indexes of the two
> highest priotiry TCs should be 3 and 2. Actually, the indexes are
> 5 and 4, because the number of TCs is 6. So it would be failed to
> configure the CBS for the two highest priority TCs.
> 
> Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Thanks!

> ---
> V2:
> Improved the commit message based on Maciej's comments.
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 83c27bbbc6ed..126007ab70f6 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -181,8 +181,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
>  	int bw_sum = 0;
>  	u8 bw;
>  
> -	prio_top = netdev_get_prio_tc_map(ndev, tc_nums - 1);
> -	prio_next = netdev_get_prio_tc_map(ndev, tc_nums - 2);
> +	prio_top = tc_nums - 1;
> +	prio_next = tc_nums - 2;
>  
>  	/* Support highest prio and second prio tc in cbs mode */
>  	if (tc != prio_top && tc != prio_next)
> -- 
> 2.25.1
> 

