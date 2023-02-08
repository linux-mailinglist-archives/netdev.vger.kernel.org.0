Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21DB68F344
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjBHQg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjBHQgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:36:54 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBBC125BA;
        Wed,  8 Feb 2023 08:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675874211; x=1707410211;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uDjxiZCpJ5YKucWCwn9INEpyKBTrRWuPg0H+PvygxsQ=;
  b=V7/MjOVD1w9spNq6NxqCkj3c9QJbeTsYY3hLZkfzrTvm+0Cyiv6C+bJ+
   KjUmn7q3BAdlO6Ehhup1WyzuO9pHxpP1XUYNIX02RxfEuvduQWYuYZUaQ
   bImf4C6Dp2F/XYCDhaBC3ukPDB5FSJALf07Kp2R+97yHiewaxLsdgXwRf
   X1+HALuX9Z6UyYcoIZfPNrQoCTQzmVCadiT8nBtHkzVhxCsyTdmvq1Ytr
   J6iCFKBv74ANuUi2cLw/Ia6OJNr3r2Fws8nVpzg06dysfoB2YMtb+040n
   E4a5E5p0GG+zMLWa4SbG9r3S1gLJ7Sq38UlMyp+2av1HBesMUQWcMgD8M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="357247138"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="357247138"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:36:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="912775045"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="912775045"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 08 Feb 2023 08:36:49 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:36:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 08:36:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 08:36:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKTCDLGXR5l3IG9vM0NaLnYCHNez2RChvX5HhgtaxwJfllm12q/nP69id9yOwQTke9mXf98Zxykzex68jpQJn6YzNQc2fO1idtHnnKVTcjtV794eZ6zM9HTDyEAIuSK0qdXb58QZtYVgHev4zFhloHNZBScKU5TcXkzyRLHk/1BTgPNC8k4gwP7mLk+pv30lhtcWpqUGPgBwwytfooyG3QjwoEOUlOOlgacvF7FqeuIYmKePJ0HMm7nFA22/9qJ36HqeN55rbV/jZRwLNBURyd2dpvUgHxIAbFhNnaQO8WOdX8q82B2ovKNiIJ5r5GCsgaw9JDR0aEiHXA5YAQ11bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTj5zkKhrBeL14fjJB+RQEZk4POfpwVoISkIcgFEWoA=;
 b=VAC2lMf02cDXMzs8Jd1NHTslRPdWV5j0tudl5WOyd2dSnWHFKKvSUD9opAYfGlHdrHIauptZVChDrf6lLjnraY15SawN6StbZIOh6caH9mE4gYlRfc0p56+4bRxomupp7iRkSeBMRA77arkejfkrkXZOSRvnAGheVM9MgMPbbBwdgCO/GS3ozHlUGC/4aPOQqyk/uSjU0sRdXWFZkiXyuoDNjRMG6nFhHivxmGwb2rxJt72hFVxA9KR6PvHoVb8rhIOcBY+oAiGKVRZiQMUNRZVw7H7G1bdM5NPykQJTX4TmnFpmMugh0NlCc94J9+SY4imb5u6N+xu15hX8+Wt0ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 16:36:40 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 16:36:40 +0000
Date:   Wed, 8 Feb 2023 17:36:33 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 10/11] net: enetc: add RX support for
 zero-copy XDP sockets
Message-ID: <Y+PPkcu1aS+oIH0o@boxer>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206100837.451300-11-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|LV2PR11MB5998:EE_
X-MS-Office365-Filtering-Correlation-Id: e82d3413-bebf-4b63-ba14-08db09f2a7a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcS549H/rPFB1Exs5bOQMpXRqYcwlI9ZajMKmoDncvjlSiP5Ky/OwUgvDW5YME6X1nVpelMez5vc6BUanUvblv3UwXF5oUz00zgPm/OU3giumOlii3GWYnk/yEJMo1+FphUgua90xPGltOp8rxndXPbqJXiSJDI7XyujmuDb1xDE01+lvXpSHfwrTSIfAv3b3aB1t2InK/CQ4kCwJYxS60u7JJ6kzabICxbePIllF8oXp+J5P6tOtmgarcoucRJPlOgzxrpOYC1oTX4hsoRHIfKKA+Xz86gOUPuB5DNWRiH0koBdayYSMB16gKdyqdulsEsuIVvMHz49aDSLiSbppK+w7g9U+GfvJVhsEJfRKx3Nr7eX7wzsx+jxxhb3RWTIWGeY1+L4YF1CUhDOjhUCQ3IPwMroWHBBT5iQhFsd5uCxtvQmbTejHeosnW3Cy86etArbxLOOUlOGCRWL3MbDLuhLxSn3cH3ILhvYNYOjQN5fZchFX1sNxv2KPwvZXXcKvvdK+SaBchs8h1woTigLOPj0Xmf/bdSbCXi6c5PYa/vzRIbjQy99JwH9m8g3kV+CQmG8Bvd8OX7pPYRKE8JU5pcgubokUYbRPnvuga9ehoL+qDnLvvgBkdKmU1jBhj+IiGQlSksfB0/nGBAYbPfjlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199018)(6486002)(8936002)(9686003)(6512007)(186003)(26005)(5660300002)(7416002)(6666004)(4326008)(316002)(66946007)(66556008)(6916009)(8676002)(41300700001)(6506007)(2906002)(54906003)(83380400001)(86362001)(478600001)(33716001)(66476007)(44832011)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7aEhDipLs8jfxnS+vClkquW26oymNk8lBik/f2zwNV4L3AGoRbshjMRZCWw5?=
 =?us-ascii?Q?WWF0ukagiOeTkl1WAvwO1DDWFmnZDJrJuQTn044Fg7xokjsQ3eXnsRmvT1Vb?=
 =?us-ascii?Q?gW4qi6sFo27BoKalcn7P0U2sT5wfiWiD7BQpMz2Lb1Fc5GImY6MWYEY5Y8d+?=
 =?us-ascii?Q?xOWb0HAyQawqXSfNUYDTVbJD5SrvjZpHADZdCa3uL7A66srcTKouBfl6xlaL?=
 =?us-ascii?Q?/QwP/Faw4VlygJg6zlwIXC9zXjH36vk2Ga+BCsuV5uoG2/7KtUuDKrLwNkQF?=
 =?us-ascii?Q?dKsi6LW8mOrx5f3blQDwauyUamaQ6oIdfyYz+lmpBEslCwGfhcmgb1/h/lAj?=
 =?us-ascii?Q?Vowmrj66dV1nH0Z4CG8ZcgHCWPEx3SHETgp+8ZwdY1WROG5qmUXLAU4HNATd?=
 =?us-ascii?Q?zSOuMllw8GZQCMftyx40rZ9JStAeinUGH8YIX6jNEYYqFjDOJ3/gTNPLRdxW?=
 =?us-ascii?Q?YywtP30/sQTwECP8LGxbMoInmhxjlanr8Up5/dMy8k5QvAnb1yjW7PRjchPs?=
 =?us-ascii?Q?8Hbny2CHAXCb8NYpihw1p/OHAj/6/WeOQiwC3fyTEkccAOXaZz3GzynNNuzl?=
 =?us-ascii?Q?O2ep8bzwU/AEtB9WnIF1KNN3Cd6qUG+UJYEg6fKh+/UfDJjRymuIV/84HHub?=
 =?us-ascii?Q?cPAN2gm/9F8+Xcf0PdGMvUSPaa/EcFAiuXLu0TaZ3l/5T4ZXDWEsqe8rr621?=
 =?us-ascii?Q?EYOVlgkV89SGWuUwKZ3qJoxIZE32Y5Xq9VkBNZAdfHcvzO+cXfLwuXONt/l7?=
 =?us-ascii?Q?1LzMjhUFB4PGBd/xuJ/YTKjFvMN7PYvMxJcoi7B7CJPk0wBg9ZCP67JpRbjA?=
 =?us-ascii?Q?3cIKyQBGycQnn52MBj2EcXt67ADasQN2u1GlPHrdSC1BfHcKByOgkOkib5uC?=
 =?us-ascii?Q?m+giCITRunsuNw7Fr75dA6UmkYC3queNFnSV+Y5pL544Qk9PJvn07rY7I1t4?=
 =?us-ascii?Q?d6tAXbXdJp3Jl9812vXZEUaMJ2O/tsMGKH9GdULh3EtYSx/6rNn83Znbw1zB?=
 =?us-ascii?Q?zs0/eH1ttdZNRcBSMdHgrxs7b2oWownHezEH6BNmZTFifs2ZJpD2O4LrD198?=
 =?us-ascii?Q?I+HDYi9PyYZaizSnrp8nds8IPik0tCi6PUfkQbnwjqjU8ueIw1z86LwsmsHg?=
 =?us-ascii?Q?WeM5C+DdNbkYUwtLBJbRGybNbfxib+QznHNOvyQDtGBWBStqcuScVakTOWQ4?=
 =?us-ascii?Q?+yCbSJ1J0FwDjHiSIaywcW43NQt0q+MH/KjWDMR7dy1FmujY3pFDt6QUufgb?=
 =?us-ascii?Q?nptS/GkU8MldttaGELMNUE3+/+HMflwlcCR7iFDxC4U9hYNUdGNVym3xsgY3?=
 =?us-ascii?Q?2vYOewNBumHoyWbKRVQ6QZ9sKCazzRVOGJKNe8rW/J9//iWvHwovhDDNkF43?=
 =?us-ascii?Q?WdcDq9qz1+aMeQirIolEOS3/15CHsk3vaGa3eMMXTBYDSD2AIz0x5Ezay5z2?=
 =?us-ascii?Q?xdKWB9cmoI6GKPo5aTo3sREyhAdollLy94aqkVg2HKNOiisXlHpPjaN4/jnp?=
 =?us-ascii?Q?AOT/6IJS6JVx3NmX2LqFczSoJFD0vbEsGzMajTblx4nMBwYbnKY/dZbYDX+1?=
 =?us-ascii?Q?YcuCGT8xPQ7u9SBTVES3lIBBFk4ME31lVksUTzDmO3e0cMBRKUkOVglCCKmx?=
 =?us-ascii?Q?GVlJlP9NItZReOILQAe2vV0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e82d3413-bebf-4b63-ba14-08db09f2a7a1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:36:40.4061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpQ7G8/WccWiLJTtGGYuBRxOVfy8OjEo8tKHETe8epFgNuqTUhP43Ya5Qq5DzDneqkHVihvc2oJHRM88H/msdUuHg292S9fLofLbtQURQqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 12:08:36PM +0200, Vladimir Oltean wrote:
> Add support for filling an RX ring with buffers coming from an XSK umem.
> Although enetc has up to 8 RX rings, we still use one of the 2 per-CPU
> RX rings for XSK.
> 
> To set up an XSK pool on one of the RX queues, we use the
> reconfiguration procedure which temporarily stops the rings.
> 
> Since the RX procedure in the NAPI poll function is completely different
> (both the API for creating an xdp_buff, as well as refilling the ring
> with memory from user space), create a separate enetc_clean_rx_ring_xsk()
> function which gets called when we have both an XSK pool and an XDK
> program on this RX queue.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c  | 377 +++++++++++++++++-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
>  3 files changed, 373 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index dee432cacf85..3990c006c011 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -10,6 +10,7 @@
>  #include <net/ip6_checksum.h>
>  #include <net/pkt_sched.h>
>  #include <net/tso.h>
> +#include <net/xdp_sock_drv.h>
>  
>  u32 enetc_port_mac_rd(struct enetc_si *si, u32 reg)
>  {
> @@ -103,6 +104,9 @@ static void enetc_free_rx_swbd(struct enetc_bdr *rx_ring,
>  			       rx_swbd->dir);
>  		__free_page(rx_swbd->page);
>  		rx_swbd->page = NULL;
> +	} else if (rx_swbd->xsk_buff) {
> +		xsk_buff_free(rx_swbd->xsk_buff);
> +		rx_swbd->xsk_buff = NULL;
>  	}
>  }
>  
> @@ -979,6 +983,44 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
>  	return j;
>  }
>  
> +static int enetc_refill_rx_ring_xsk(struct enetc_bdr *rx_ring, int buff_cnt)
> +{
> +	struct xsk_buff_pool *pool = rx_ring->xdp.xsk_pool;
> +	struct enetc_rx_swbd *rx_swbd;
> +	struct xdp_buff *xsk_buff;
> +	union enetc_rx_bd *rxbd;
> +	int i, j;
> +
> +	i = rx_ring->next_to_use;
> +	rxbd = enetc_rxbd(rx_ring, i);
> +
> +	for (j = 0; j < buff_cnt; j++) {
> +		xsk_buff = xsk_buff_alloc(pool); // TODO use _batch?

yes, use batch:P

> +		if (!xsk_buff)
> +			break;
> +
> +		rx_swbd = &rx_ring->rx_swbd[i];
> +		rx_swbd->xsk_buff = xsk_buff;
> +		rx_swbd->dma = xsk_buff_xdp_get_dma(xsk_buff);
> +
> +		/* update RxBD */
> +		rxbd->w.addr = cpu_to_le64(rx_swbd->dma);
> +		/* clear 'R" as well */
> +		rxbd->r.lstatus = 0;
> +
> +		enetc_rxbd_next(rx_ring, &rxbd, &i);
> +	}
> +
> +	if (likely(j)) {
> +		rx_ring->next_to_use = i;
> +
> +		/* update ENETC's consumer index */
> +		enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
> +	}
> +
> +	return j;
> +}
> +
>  #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
>  static void enetc_get_rx_tstamp(struct net_device *ndev,
>  				union enetc_rx_bd *rxbd,
> @@ -1128,6 +1170,18 @@ static void enetc_add_rx_buff_to_skb(struct enetc_bdr *rx_ring, int i,
>  	enetc_flip_rx_buff(rx_ring, rx_swbd);
>  }
>  
> +static void enetc_put_rx_swbd(struct enetc_bdr *rx_ring, int i)
> +{
> +	struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[i];
> +
> +	if (rx_swbd->xsk_buff) {
> +		xsk_buff_free(rx_swbd->xsk_buff);
> +		rx_swbd->xsk_buff = NULL;
> +	} else {
> +		enetc_put_rx_buff(rx_ring, rx_swbd);
> +	}
> +}
> +
>  static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
>  					      u32 bd_status,
>  					      union enetc_rx_bd **rxbd, int *i,
> @@ -1136,7 +1190,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
>  	if (likely(!(bd_status & ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))))
>  		return false;
>  
> -	enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
> +	enetc_put_rx_swbd(rx_ring, *i);
>  	(*buffs_missing)++;
>  	enetc_rxbd_next(rx_ring, rxbd, i);
>  
> @@ -1144,7 +1198,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
>  		dma_rmb();
>  		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
>  
> -		enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
> +		enetc_put_rx_swbd(rx_ring, *i);
>  		(*buffs_missing)++;
>  		enetc_rxbd_next(rx_ring, rxbd, i);
>  	}
> @@ -1484,6 +1538,43 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
>  	}
>  }
>  
> +static struct xdp_buff *enetc_build_xsk_buff(struct xsk_buff_pool *pool,
> +					     struct enetc_bdr *rx_ring,
> +					     u32 bd_status,
> +					     union enetc_rx_bd **rxbd, int *i,
> +					     int *buffs_missing, int *rx_byte_cnt)
> +{
> +	struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[*i];
> +	u16 size = le16_to_cpu((*rxbd)->r.buf_len);
> +	struct xdp_buff *xsk_buff;
> +
> +	/* Multi-buffer frames are not supported in XSK mode */

Nice! I realized we need to forbid that on ice now.

> +	if (unlikely(!(bd_status & ENETC_RXBD_LSTATUS_F))) {
> +		while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
> +			enetc_put_rx_swbd(rx_ring, *i);
> +
> +			(*buffs_missing)++;
> +			enetc_rxbd_next(rx_ring, rxbd, i);
> +			dma_rmb();
> +			bd_status = le32_to_cpu((*rxbd)->r.lstatus);
> +		}
> +
> +		return NULL;
> +	}
> +
> +	xsk_buff = rx_swbd->xsk_buff;
> +	xsk_buff_set_size(xsk_buff, size);
> +	xsk_buff_dma_sync_for_cpu(xsk_buff, pool);
> +
> +	rx_swbd->xsk_buff = NULL;
> +
> +	(*buffs_missing)++;
> +	(*rx_byte_cnt) += size;
> +	enetc_rxbd_next(rx_ring, rxbd, i);
> +
> +	return xsk_buff;
> +}
> +
>  /* Convert RX buffer descriptors to TX buffer descriptors. These will be
>   * recycled back into the RX ring in enetc_clean_tx_ring.
>   */
> @@ -1659,11 +1750,136 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
>  	return rx_frm_cnt;
>  }
>  
> +static void enetc_xsk_buff_to_skb(struct xdp_buff *xsk_buff,
> +				  struct enetc_bdr *rx_ring,
> +				  union enetc_rx_bd *rxbd,
> +				  struct napi_struct *napi)
> +{
> +	size_t len = xdp_get_buff_len(xsk_buff);
> +	struct sk_buff *skb;
> +
> +	skb = napi_alloc_skb(napi, len);
> +	if (unlikely(!skb)) {
> +		rx_ring->stats.rx_alloc_errs++;
> +		goto out;
> +	}
> +
> +	skb_put_data(skb, xsk_buff->data, len);
> +
> +	enetc_get_offloads(rx_ring, rxbd, skb);
> +
> +	skb_record_rx_queue(skb, rx_ring->index);
> +	skb->protocol = eth_type_trans(skb, rx_ring->ndev);
> +
> +	rx_ring->stats.packets += skb->len;
> +	rx_ring->stats.bytes++;
> +
> +	napi_gro_receive(napi, skb);
> +out:
> +	xsk_buff_free(xsk_buff);
> +}
> +
> +static int enetc_clean_rx_ring_xsk(struct enetc_bdr *rx_ring,
> +				   struct napi_struct *napi, int work_limit,
> +				   struct bpf_prog *prog,
> +				   struct xsk_buff_pool *pool)
> +{
> +	struct net_device *ndev = rx_ring->ndev;
> +	union enetc_rx_bd *rxbd, *orig_rxbd;
> +	int rx_frm_cnt = 0, rx_byte_cnt = 0;
> +	int xdp_redirect_frm_cnt = 0;
> +	struct xdp_buff *xsk_buff;
> +	int buffs_missing, err, i;
> +	bool wakeup_xsk = false;
> +	u32 bd_status, xdp_act;
> +
> +	buffs_missing = enetc_bd_unused(rx_ring);
> +	/* next descriptor to process */
> +	i = rx_ring->next_to_clean;
> +
> +	while (likely(rx_frm_cnt < work_limit)) {
> +		if (buffs_missing >= ENETC_RXBD_BUNDLE) {
> +			buffs_missing -= enetc_refill_rx_ring_xsk(rx_ring,
> +								  buffs_missing);
> +			wakeup_xsk |= (buffs_missing != 0);
> +		}
> +
> +		rxbd = enetc_rxbd(rx_ring, i);
> +		bd_status = le32_to_cpu(rxbd->r.lstatus);
> +		if (!bd_status)
> +			break;
> +
> +		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
> +		dma_rmb(); /* for reading other rxbd fields */
> +
> +		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
> +						      &rxbd, &i,
> +						      &buffs_missing))
> +			continue;
> +
> +		orig_rxbd = rxbd;
> +
> +		xsk_buff = enetc_build_xsk_buff(pool, rx_ring, bd_status,
> +						&rxbd, &i, &buffs_missing,
> +						&rx_byte_cnt);
> +		if (!xsk_buff)
> +			continue;
> +
> +		xdp_act = bpf_prog_run_xdp(prog, xsk_buff);
> +		switch (xdp_act) {
> +		default:
> +			bpf_warn_invalid_xdp_action(ndev, prog, xdp_act);
> +			fallthrough;
> +		case XDP_ABORTED:
> +			trace_xdp_exception(ndev, prog, xdp_act);
> +			fallthrough;
> +		case XDP_DROP:
> +			xsk_buff_free(xsk_buff);
> +			break;
> +		case XDP_PASS:
> +			enetc_xsk_buff_to_skb(xsk_buff, rx_ring, orig_rxbd,
> +					      napi);
> +			break;
> +		case XDP_REDIRECT:
> +			err = xdp_do_redirect(ndev, xsk_buff, prog);
> +			if (unlikely(err)) {
> +				if (err == -ENOBUFS)
> +					wakeup_xsk = true;
> +				xsk_buff_free(xsk_buff);
> +				rx_ring->stats.xdp_redirect_failures++;
> +			} else {
> +				xdp_redirect_frm_cnt++;
> +				rx_ring->stats.xdp_redirect++;
> +			}

no XDP_TX support? I don't see it being added on next patch.

> +		}
> +
> +		rx_frm_cnt++;
> +	}
> +
> +	rx_ring->next_to_clean = i;
> +
> +	rx_ring->stats.packets += rx_frm_cnt;
> +	rx_ring->stats.bytes += rx_byte_cnt;
> +
> +	if (xdp_redirect_frm_cnt)
> +		xdp_do_flush_map();
> +
> +	if (xsk_uses_need_wakeup(pool)) {
> +		if (wakeup_xsk)
> +			xsk_set_rx_need_wakeup(pool);
> +		else
> +			xsk_clear_rx_need_wakeup(pool);
> +	}
> +
> +	return rx_frm_cnt;
> +}
> +
>  static int enetc_poll(struct napi_struct *napi, int budget)
>  {
>  	struct enetc_int_vector
>  		*v = container_of(napi, struct enetc_int_vector, napi);
>  	struct enetc_bdr *rx_ring = &v->rx_ring;
> +	struct xsk_buff_pool *pool;
>  	struct bpf_prog *prog;
>  	bool complete = true;
>  	int work_done;
> @@ -1676,10 +1892,15 @@ static int enetc_poll(struct napi_struct *napi, int budget)
>  			complete = false;
>  
>  	prog = rx_ring->xdp.prog;
> -	if (prog)

(...)
