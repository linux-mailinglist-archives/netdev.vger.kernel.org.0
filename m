Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B776D4ED0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjDCRTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbjDCRTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:19:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F74510EA;
        Mon,  3 Apr 2023 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680542380; x=1712078380;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HJDHGsrbfFfixGJbgB40Zen/pTkl5lzCZdDYYQEM3QY=;
  b=Ffvaov+zDIpgFpl7lqHtB21i4kUhtQF0/kjVMq18KtneFy3Eqqtj8Ily
   UA65QLyHn4BDbTp9sRrF46Y5PPRHZwsmp79y9VBVbrVC9zIrkrEHg9/vi
   Y66L3HuJ0QcgWKcml6qYBXWeXez5UhHpSLOzbuuU4nZP6rGjXRIgEu9qx
   g2jd1SBLh3FXHDaxoxDwari45wsXHpeXM+Wy50mJqOgV7GDg+fCUQJA80
   dICxeca3e6vzTkP74mJbYIWLIS4lSLPREkpWDtlWLPcR3gMxNNkaemn8j
   KJLb1FJjGfMgFCwMoZy35W1AML+5YYR1ekSvXPoFFxE4YbPQ0hd+vkUhT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330535981"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="330535981"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 10:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="797139861"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="797139861"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 03 Apr 2023 10:19:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:19:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:19:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 10:19:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 10:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWr6G7yqyV5U4+Zz6cIqHiQSt758/qQTolDrKFxpTRiT0Ikni4sblD//nqcoqp9M4eLcLgisgphWjM/FgOKJTvMI9DaWI5RKHg0SWsIXI7NPsHIkapUrOYNkmR6J9JfeKUlayhMw8kxeGzI22V0cuoAkd1NsULhZkLfrTX82ustNNsucgIrtNcrIxQ5yd9x6H8uTWpHMOcsM5n/rKUWKOIFBsFGHQtkp1CW/4HfnmWkWPRQydczkuKYtohPG2STk8T9+MozHsr5XF8fuT7z69+39ORMTf7NH2c1zcyDmDTHhsC3EhoR1k4cMfA2VXNOQJnLtasagCpdN+3y9tsxBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ephHBTO0G3Gmo9JWHluzQybZmko0tbBYOwkf0v7TiPc=;
 b=NNwbJx2f/l7rXMoHqr3kYrCNZ519/NbXrnnBagrbg1/pW3mjgvm1vPfiuxx5yiPaZ2S2jw0zEm7cPmoBjGrRB7llwb5TOsFFlvKkkWIGGad5eys1qpNzMaXWj52Gk6ewD4hKaCEpjGlJdq8rTj5hHApP6rrRYFtDiFnRd8kl0E9DbeY7Ya2vH3I3pfEzDExf3McgbubnVISJrqPuVt5sV/uFQbwzDNpdrF2SXa2CPpTm1LROkGa1UygWero/p5jKXOuuLek6TZSxu4QiIjxFASOP2Xmvh7wNDdZHPNqHx8zSDII4DgSynuPloQrEyAHCUAXLTDPCw1fg5BWQwd3rPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB5861.namprd11.prod.outlook.com (2603:10b6:510:133::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.26; Mon, 3 Apr 2023 17:19:35 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 17:19:35 +0000
Date:   Mon, 3 Apr 2023 19:19:15 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 4/5] tsnep: Add XDP socket zero-copy RX support
Message-ID: <ZCsKkygVjB3J+XrO@boxer>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-5-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230402193838.54474-5-gerhard@engleder-embedded.com>
X-ClientProxiedBy: DUZPR01CA0198.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::29) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e6c1bd-df50-4eb0-2678-08db34679886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBLywb6yIoGSDB1ZVKiddRIa4K0MgpbcFhI0qgIYipY5Fmefrf1NfZY6rxucjdckvgjLMdT4DrxPb3gKVBPiid6Gw1zGhH4VPXxh0riF79D0hok1P6P9dTX58Ojf+zsxMJfiygNg15aVmSv4zsKinh164U0WIKM1DDJUwPcs681uw5X9h0jpCYC4YWL5+BeMBmpKX6uYG/qUKnc0DXuQEWBpXoyY1HJvt8gRo7GcLTVV9CwIZ1z7LjR3bZEzvunv4617RVcishMFT4TQ0SrOp6LuFEOnxfD+KK+xCTRW2fOuyOMeVOb3aVpo7zphzNZ2KSXRSTOwHsVg95T/4x+7mAoFPJKya5N7pXDAtZXW0mgRVanNpDTY+wpo8SOTBuN5EAsGVVTc/L64XVF9bAOREAeQyOO0vd6ur/HPWaY9FVnsAziorpaR3+H5b6V088AiTMJJy2nTRYjVan3ZUAXsinZ3UXyOOZxTmRYFGgG9UTXG4KX85HZPyyqp6/iutPXw4Z2mckQG+8+dpcANRtg/1Uwz4IhWqaZmWaQe3OMcNdYDx1R496wecP8R8+jr3CF90JpAn0op6uabW+jUy8e7MktsVjrThMCOO9ifo5Jz660=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(6666004)(26005)(6512007)(8676002)(6916009)(6486002)(66946007)(4326008)(66476007)(66556008)(316002)(83380400001)(38100700002)(186003)(6506007)(9686003)(41300700001)(33716001)(5660300002)(478600001)(8936002)(86362001)(82960400001)(2906002)(30864003)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jw78XlKvC+4RfknrIgUWZoH8up2It7icmnrTFfjjP0n0k70PxOVDDMNJ8g4j?=
 =?us-ascii?Q?IYCCIyBvjsLZS+T+Cs+zxuUt1gbKSKSmJ7aaO8ZYUJB5ogLXpcSwYIKPpF/L?=
 =?us-ascii?Q?f+CAtW+C+Ou12RFnFSWKbs7MVCaWoNwXLGPp4oWdlMnANEAOuy3FkXTJDaGp?=
 =?us-ascii?Q?DtnGYvXE5HvmbKpsVskJCWXthWuWB3WNhxxljz7jinxgEyDmFLAuS7duUwt+?=
 =?us-ascii?Q?xUTF9c3j7zH0S8AjBkiGwg8kyiiwrATHn9khBOfNW2YulBk7MVJEUR2cayja?=
 =?us-ascii?Q?JlHy1eYOc9p6O0byYBTIClrD3p1Z/2Sw0S1Kq6GisyRM37UmBOXOrNAX/xP7?=
 =?us-ascii?Q?KpDZ06ATKrIee8On7ihGcCSebUO9vn6joSczf4Ktn2x5Yodrjr8rKm33fFcZ?=
 =?us-ascii?Q?aXClh43Yhj8RlMKgtHPpk+sDURCXuBOzyjzqJCWbqRoj66VqqoTGpujSGE8+?=
 =?us-ascii?Q?o6MIcAoIdSNBTqND245Ok1WHKmcb3oRx5jmLkpadx0SfHH/y0pjQqsBhkaXu?=
 =?us-ascii?Q?ZP1ighpUWaYKhKdCX7drGEW+c8LLnt7lY5UFGxrxny9Dl9EeCtt2diYm9lmw?=
 =?us-ascii?Q?yITd6AacS0zaeTgdNkibDxGe5F9rJpnWn4tK/17GhAj/jQo4IMQwZJhImZIY?=
 =?us-ascii?Q?gi58i8VMB+8XH9U6YZjBIUSgL8BSECME+dXn9yXYVY4WqOKyP7qf4E1snvV4?=
 =?us-ascii?Q?OE5aZX5W2xZixZiCXpChoEJIlRhYrDlZTapM9BlE0e9REdaxt5n8mgj07Qsp?=
 =?us-ascii?Q?X0NCs/1keVX0jNc4X1GHON7H8ju0z+M/e9IXrY9AU1ShmagRmb3IwjKkYP6a?=
 =?us-ascii?Q?gZF4yFu6JxhBz4/0r7XtzHwEa/d0KMd9+FZxVU+jtw1L4irxxdndJO0GM4em?=
 =?us-ascii?Q?zGA/LYxQn4aMYupt/jrGzIs/SKqGvrhHIoJtklrBMa0hFZbxKWfQEJPMWfvW?=
 =?us-ascii?Q?PjCKNEiQVpY5/LuTaExZGm5tRyEDI5vhCbE3sNeGbRPFmjTa0Q/Aj0MUT27n?=
 =?us-ascii?Q?kD26hPi7DmoKAuU4Hqq9VapMM3G97LX+xlUKZeX8GbsEWx1iVwR5HLi2LzPn?=
 =?us-ascii?Q?RJLLBLgbtZdiGoFtIaNcgFtnskBneFja+OZgm6U+i1oY12oufLWwoyHHtn1i?=
 =?us-ascii?Q?O7n/2QbCrz7bKJ3dcC03BUH76+Sd56kTTeIX9Zv9KPY6jO5PZYFFmbq5UYqg?=
 =?us-ascii?Q?lLvfPQfcO8sc/64xIR3sgorDDomMBZ8WoHZ0qjgV5I4WUskDuW/rB+flegBA?=
 =?us-ascii?Q?HaQj5pAhx+KfoevUDuf5IFiIJTR+AfwzhjHIxOIwYafC0dSadk+XXV1GLDzV?=
 =?us-ascii?Q?e5flyRhe6qhpjiGidGLYPkw+6Hx/x2Sxa5qO0Z5jlzvqYSSMeUQtflM0ed2E?=
 =?us-ascii?Q?MeYgSlPsBQeCg6jIrC+rUMwiUC/joSMMGa0ZuqyCR1hb1cpvCwgkChDodBmU?=
 =?us-ascii?Q?POqPnVU2677A7WyCMy/fLjDHUShb2Czr8B486qpCLc23FpGrJEgF1B54bq9n?=
 =?us-ascii?Q?966RO5eNVyes1yuXvQDtHCnfHDYZkEkmCqnURz97/+L14ROYNii8yg7eKzPG?=
 =?us-ascii?Q?dh7uhrAH5a/BOlSipN4b0LjJGrMqi9v7l8Kphxz7waeJQe/YYlRIGasnbeni?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e6c1bd-df50-4eb0-2678-08db34679886
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 17:19:35.0846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lqIO5ptch68uOTfh+/YEY+7KRxU+zlifBTURkzkZfU6rSL7gP92a6ewiqx/W7oqWzeCxdfbj+WqjOC1ZgLAZ2fDmMjhOHjPKHcOM+bJIW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5861
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 09:38:37PM +0200, Gerhard Engleder wrote:

Hey Gerhard,

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

I won't argue about your design, but I'd be glad if you would present any
perf numbers (ZC vs copy mode) just to give us some overview how your
implementation works out. Also, please consider using batching APIs and
see if this gives you any boost (my assumption is that it would).

> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |   7 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
>  drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
>  3 files changed, 488 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index 058c2bcf31a7..836fd6b1d62e 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -101,6 +101,7 @@ struct tsnep_rx_entry {
>  	u32 properties;
>  
>  	struct page *page;
> +	struct xdp_buff *xdp;

couldn't page and xdp be a union now?

>  	size_t len;
>  	dma_addr_t dma;
>  };
> @@ -120,6 +121,7 @@ struct tsnep_rx {
>  	u32 owner_counter;
>  	int increment_owner_counter;
>  	struct page_pool *page_pool;
> +	struct xsk_buff_pool *xsk_pool;
>  
>  	u32 packets;
>  	u32 bytes;
> @@ -128,6 +130,7 @@ struct tsnep_rx {
>  	u32 alloc_failed;
>  
>  	struct xdp_rxq_info xdp_rxq;
> +	struct xdp_rxq_info xdp_rxq_zc;
>  };
>  
>  struct tsnep_queue {
> @@ -213,6 +216,8 @@ int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
>  
>  int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
>  			 struct netlink_ext_ack *extack);
> +int tsnep_xdp_setup_pool(struct tsnep_adapter *adapter,
> +			 struct xsk_buff_pool *pool, u16 queue_id);
>  
>  #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
>  int tsnep_ethtool_get_test_count(void);
> @@ -241,5 +246,7 @@ static inline void tsnep_ethtool_self_test(struct net_device *dev,
>  void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
>  int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs);
>  u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue);
> +int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool);
> +void tsnep_disable_xsk(struct tsnep_queue *queue);
>  
>  #endif /* _TSNEP_H */
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index 6d63b379f05a..e05835d675aa 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -28,11 +28,16 @@
>  #include <linux/iopoll.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
> +#include <net/xdp_sock_drv.h>
>  
>  #define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
>  #define TSNEP_HEADROOM ALIGN(TSNEP_RX_OFFSET, 4)
>  #define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
>  			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +/* XSK buffer shall store at least Q-in-Q frame */
> +#define TSNEP_XSK_RX_BUF_SIZE (ALIGN(TSNEP_RX_INLINE_METADATA_SIZE + \
> +				     ETH_FRAME_LEN + ETH_FCS_LEN + \
> +				     VLAN_HLEN * 2, 4))
>  
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>  #define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
> @@ -781,6 +786,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  			page_pool_put_full_page(rx->page_pool, entry->page,
>  						false);
>  		entry->page = NULL;
> +		if (entry->xdp)
> +			xsk_buff_free(entry->xdp);
> +		entry->xdp = NULL;
>  	}
>  
>  	if (rx->page_pool)
> @@ -927,7 +935,7 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
>  {
>  	struct tsnep_rx_entry *entry = &rx->entry[index];
>  
> -	/* TSNEP_MAX_RX_BUF_SIZE is a multiple of 4 */
> +	/* TSNEP_MAX_RX_BUF_SIZE and TSNEP_XSK_RX_BUF_SIZE are multiple of 4 */
>  	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
>  	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>  	if (index == rx->increment_owner_counter) {
> @@ -979,6 +987,24 @@ static int tsnep_rx_alloc(struct tsnep_rx *rx, int count, bool reuse)
>  	return i;
>  }
>  
> +static int tsnep_rx_prealloc(struct tsnep_rx *rx)
> +{
> +	struct tsnep_rx_entry *entry;
> +	int i;
> +
> +	/* prealloc all ring entries except the last one, because ring cannot be
> +	 * filled completely
> +	 */
> +	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
> +		entry = &rx->entry[i];
> +		entry->page = page_pool_dev_alloc_pages(rx->page_pool);
> +		if (!entry->page)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
>  static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  {
>  	int desc_refilled;
> @@ -990,22 +1016,118 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  	return desc_refilled;
>  }
>  
> +static void tsnep_rx_set_xdp(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
> +			     struct xdp_buff *xdp)
> +{
> +	entry->xdp = xdp;
> +	entry->len = TSNEP_XSK_RX_BUF_SIZE;
> +	entry->dma = xsk_buff_xdp_get_dma(entry->xdp);
> +	entry->desc->rx = __cpu_to_le64(entry->dma);
> +}
> +
> +static int tsnep_rx_alloc_buffer_zc(struct tsnep_rx *rx, int index)
> +{
> +	struct tsnep_rx_entry *entry = &rx->entry[index];
> +	struct xdp_buff *xdp;
> +
> +	xdp = xsk_buff_alloc(rx->xsk_pool);
> +	if (unlikely(!xdp))
> +		return -ENOMEM;
> +	tsnep_rx_set_xdp(rx, entry, xdp);
> +
> +	return 0;
> +}
> +
> +static void tsnep_rx_reuse_buffer_zc(struct tsnep_rx *rx, int index)
> +{
> +	struct tsnep_rx_entry *entry = &rx->entry[index];
> +	struct tsnep_rx_entry *read = &rx->entry[rx->read];
> +
> +	tsnep_rx_set_xdp(rx, entry, read->xdp);
> +	read->xdp = NULL;
> +}
> +
> +static int tsnep_rx_alloc_zc(struct tsnep_rx *rx, int count, bool reuse)
> +{
> +	bool alloc_failed = false;
> +	int i, index, retval;
> +
> +	for (i = 0; i < count && !alloc_failed; i++) {
> +		index = (rx->write + i) % TSNEP_RING_SIZE;

If your ring size is static (256) then you could use the trick of:

		index = (rx->write + i) & (TSNEP_RING_SIZE - 1);

since TSNEP_RING_SIZE is of power of 2. This way you avoid modulo op in
hotpath.

> +
> +		retval = tsnep_rx_alloc_buffer_zc(rx, index);
> +		if (unlikely(retval)) {

retval is not needed. just do:
		if (unlikely(tsnep_rx_alloc_buffer_zc(rx, index))) {

> +			rx->alloc_failed++;
> +			alloc_failed = true;
> +
> +			/* reuse only if no other allocation was successful */
> +			if (i == 0 && reuse)
> +				tsnep_rx_reuse_buffer_zc(rx, index);
> +			else
> +				break;

isn't the else branch not needed as you've set the alloc_failed to true
which will break out the loop?

> +		}
> +		tsnep_rx_activate(rx, index);
> +	}
> +
> +	if (i)
> +		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
> +
> +	return i;
> +}
> +
> +static void tsnep_rx_free_zc(struct tsnep_rx *rx, struct xsk_buff_pool *pool)
> +{
> +	struct tsnep_rx_entry *entry;

can be scoped within loop

> +	int i;
> +
> +	for (i = 0; i < TSNEP_RING_SIZE; i++) {
> +		entry = &rx->entry[i];
> +		if (entry->xdp)
> +			xsk_buff_free(entry->xdp);
> +		entry->xdp = NULL;
> +	}
> +}
> +
> +static void tsnep_rx_prealloc_zc(struct tsnep_rx *rx,
> +				 struct xsk_buff_pool *pool)
> +{
> +	struct tsnep_rx_entry *entry;

ditto

> +	int i;
> +
> +	/* prealloc all ring entries except the last one, because ring cannot be
> +	 * filled completely, as many buffers as possible is enough as wakeup is
> +	 * done if new buffers are available
> +	 */
> +	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
> +		entry = &rx->entry[i];
> +		entry->xdp = xsk_buff_alloc(pool);

anything stops you from using xsk_buff_alloc_batch() ?

> +		if (!entry->xdp)
> +			break;
> +	}
> +}
> +
> +static int tsnep_rx_refill_zc(struct tsnep_rx *rx, int count, bool reuse)
> +{
> +	int desc_refilled;
> +
> +	desc_refilled = tsnep_rx_alloc_zc(rx, count, reuse);
> +	if (desc_refilled)
> +		tsnep_rx_enable(rx);
> +
> +	return desc_refilled;
> +}
> +
>  static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>  			       struct xdp_buff *xdp, int *status,
> -			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
> +			       bool zc)
>  {
>  	unsigned int length;
> -	unsigned int sync;
>  	u32 act;
>  
>  	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>  
>  	act = bpf_prog_run_xdp(prog, xdp);
> -
> -	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> -	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> -	sync = max(sync, length);
> -
>  	switch (act) {
>  	case XDP_PASS:
>  		return false;
> @@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>  		trace_xdp_exception(rx->adapter->netdev, prog, act);
>  		fallthrough;
>  	case XDP_DROP:
> -		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> -				   sync, true);
> +		if (zc) {
> +			xsk_buff_free(xdp);
> +		} else {
> +			unsigned int sync;
> +
> +			/* Due xdp_adjust_tail: DMA sync for_device cover max
> +			 * len CPU touch
> +			 */
> +			sync = xdp->data_end - xdp->data_hard_start -
> +			       XDP_PACKET_HEADROOM;
> +			sync = max(sync, length);
> +			page_pool_put_page(rx->page_pool,
> +					   virt_to_head_page(xdp->data), sync,
> +					   true);
> +		}
>  		return true;
>  	}
>  }
> @@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  					 length, false);
>  
>  			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
> -						     &xdp_status, tx_nq, tx);
> +						     &xdp_status, tx_nq, tx,
> +						     false);
>  			if (consume) {
>  				rx->packets++;
>  				rx->bytes += length;
> @@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  	return done;
>  }
>  
> +static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
> +			    int budget)
> +{
> +	struct tsnep_rx_entry *entry;
> +	struct netdev_queue *tx_nq;
> +	struct bpf_prog *prog;
> +	struct tsnep_tx *tx;
> +	int desc_available;
> +	int xdp_status = 0;
> +	struct page *page;
> +	int done = 0;
> +	int length;
> +
> +	desc_available = tsnep_rx_desc_available(rx);
> +	prog = READ_ONCE(rx->adapter->xdp_prog);
> +	if (prog) {
> +		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
> +					    rx->tx_queue_index);
> +		tx = &rx->adapter->tx[rx->tx_queue_index];
> +	}
> +
> +	while (likely(done < budget) && (rx->read != rx->write)) {
> +		entry = &rx->entry[rx->read];
> +		if ((__le32_to_cpu(entry->desc_wb->properties) &
> +		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
> +		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
> +			break;
> +		done++;
> +
> +		if (desc_available >= TSNEP_RING_RX_REFILL) {
> +			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
> +
> +			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
> +							     reuse);
> +			if (!entry->xdp) {
> +				/* buffer has been reused for refill to prevent
> +				 * empty RX ring, thus buffer cannot be used for
> +				 * RX processing
> +				 */
> +				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> +				desc_available++;
> +
> +				rx->dropped++;
> +
> +				continue;
> +			}
> +		}
> +
> +		/* descriptor properties shall be read first, because valid data
> +		 * is signaled there
> +		 */
> +		dma_rmb();
> +
> +		prefetch(entry->xdp->data);
> +		length = __le32_to_cpu(entry->desc_wb->properties) &
> +			 TSNEP_DESC_LENGTH_MASK;
> +		entry->xdp->data_end = entry->xdp->data + length;
> +		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
> +
> +		/* RX metadata with timestamps is in front of actual data,
> +		 * subtract metadata size to get length of actual data and
> +		 * consider metadata size as offset of actual data during RX
> +		 * processing
> +		 */
> +		length -= TSNEP_RX_INLINE_METADATA_SIZE;
> +
> +		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
> +		desc_available++;
> +
> +		if (prog) {
> +			bool consume;
> +
> +			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
> +			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
> +
> +			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
> +						     &xdp_status, tx_nq, tx,
> +						     true);

reason for separate xdp run prog routine for ZC was usually "likely-fying"
XDP_REDIRECT action as this is the main action for AF_XDP which was giving
us perf improvement. Please try this out on your side to see if this
yields any positive value.

> +			if (consume) {
> +				rx->packets++;
> +				rx->bytes += length;
> +
> +				entry->xdp = NULL;
> +
> +				continue;
> +			}
> +		}
> +
> +		page = page_pool_dev_alloc_pages(rx->page_pool);
> +		if (page) {
> +			memcpy(page_address(page) + TSNEP_RX_OFFSET,
> +			       entry->xdp->data - TSNEP_RX_INLINE_METADATA_SIZE,
> +			       length + TSNEP_RX_INLINE_METADATA_SIZE);
> +			tsnep_rx_page(rx, napi, page, length);
> +		} else {
> +			rx->dropped++;
> +		}
> +		xsk_buff_free(entry->xdp);
> +		entry->xdp = NULL;
> +	}
> +
> +	if (xdp_status)
> +		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
> +
> +	if (desc_available)
> +		desc_available -= tsnep_rx_refill_zc(rx, desc_available, false);
> +
> +	if (xsk_uses_need_wakeup(rx->xsk_pool)) {
> +		if (desc_available)
> +			xsk_set_rx_need_wakeup(rx->xsk_pool);
> +		else
> +			xsk_clear_rx_need_wakeup(rx->xsk_pool);
> +
> +		return done;
> +	}
> +
> +	return desc_available ? budget : done;
> +}
>  

(...)

>  static int tsnep_mac_init(struct tsnep_adapter *adapter)
> @@ -1974,7 +2369,8 @@ static int tsnep_probe(struct platform_device *pdev)
>  
>  	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
>  			       NETDEV_XDP_ACT_NDO_XMIT |
> -			       NETDEV_XDP_ACT_NDO_XMIT_SG;
> +			       NETDEV_XDP_ACT_NDO_XMIT_SG |
> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
>  
>  	/* carrier off reporting is important to ethtool even BEFORE open */
>  	netif_carrier_off(netdev);
> diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
> index 4d14cb1fd772..6ec137870b59 100644
> --- a/drivers/net/ethernet/engleder/tsnep_xdp.c
> +++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
> @@ -6,6 +6,8 @@
>  
>  #include "tsnep.h"
>  
> +#define TSNEP_XSK_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC)

This is not introducing any value, you can operate directly on
DMA_ATTR_SKIP_CPU_SYNC

(...)
