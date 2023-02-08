Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486F268F325
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjBHQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBHQ21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:28:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D4F45BEB;
        Wed,  8 Feb 2023 08:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675873706; x=1707409706;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z89rTPitGUrbWuo9gZTw7VpNJ+i3jfBlqVuJvGDq/qc=;
  b=LKXo1Maq/lPbARkLsg6qNkexwiCaDFy6q+R8sDlnl63tkVLVD+97EUtg
   tJChJ+3YlC9RlJRIqY1uDz6gy/S7CLQGVFcmPZk8kwVTYvh8mfIp9lU/Z
   ph6X8TUftBtWc4ws5J1eFOXjVK05RQ18y2CA77n1d4GJPsJUelikSILVB
   YJlZkllyF0D/cQNK0vBSBHcawNhGJo0SAmRFADOgezg1K/0rg0c3toRnN
   bN66ZM12elNcb0NZC8PvJz2ru0SP1+4OKnuUBvfJcQfbZcxjr9t6o5k9a
   RnuqwsBIa1GJpY5h+6j/K/xlwLAh5p7Df7tenJW+L7HH+UFbGnIBiXtCu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="331131433"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="331131433"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:28:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667305537"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="667305537"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 08 Feb 2023 08:28:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:28:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:28:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 08:28:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 08:28:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7w/bhnpenBlM7oETyDMDPGF1KD0ui5XtF3u8bdiMUfs05Gm79Uapan+OacJZGgg8DWkQ5Hera9+N15KgBi4NP5O24LTVk5n0UwYTIkcHGTKk3rsQasi0sX8F4U0FDaENi1O2pBY2ePSP6vn+kdp8rp29blHZxOEKIhHWDyUssM/WZ1IibK+ROkg4TnwT6/B68fru4ReNhdNvH18WMivf3tP2MtFAHZQxu4zMW+1wD344ctZsmyTIsyyzbB3LwfVR1X/Qq+jHaoeK63K0hS1Lgb6WkERSFMqqBd3ZF5+amtxCWj23qtT5xSI7BJIogVA+gNCY2A6Nr2qmNyDrLXueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gea97zMvkQWUD+j64Pn48sKeSEt38GfDi0BzE86ylCg=;
 b=RypHhQcTXP6agpuNwMzTvQJrm2w+aYj2biHeELxEV/NdL6S+pGfUZzJhaPHNvsrsRmgnd6CEDSmjrvOMEdW8bEm0vfYOyImLoI5zqCRXGqD/q+8OMVdy4Y+zzoqZf+/D8wAR10W/1TUWF/eR+kb/pBaFjFf7Aicl4kAM/wSKFFfvpyxggF7/87LI9RCoEb4I/PR7KdxEe2zX0Wj89aplfH00kQOWEB7zlntkjnhwkpnQMVDWXfwIBALCBXUKSo98vQHma2YwNXkRc9P9jVRH2oD1TFyVrkDvXfRIm+3sQ66E8bxy9Wnc5CeHZLbGLk5GrG/DznblhoHZgyqRkT4log==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB7638.namprd11.prod.outlook.com (2603:10b6:806:34b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 16:28:15 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 16:28:13 +0000
Date:   Wed, 8 Feb 2023 17:27:57 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
CC:     Jason Xing <kerneljasonxing@gmail.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net v4 1/3] ixgbe: allow to increase MTU to 3K with XDP
 enabled
Message-ID: <Y+PNjcrSxKc0vD3s@boxer>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
 <2bfcd7d92a6971416f58d9aac6e74840d5ae240a.camel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2bfcd7d92a6971416f58d9aac6e74840d5ae240a.camel@gmail.com>
X-ClientProxiedBy: LNXP265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::36) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: 3221f783-3ead-42a8-1b68-08db09f17976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmOshQERTKN0MEj6nBLKCgn/896MSi6CelxSsjILApP6BlezxQgdeH2bbqKrIwovEMrtaNYoNwchkX/DwkzaRlNk+nJt/NaulIeTIVcUA1i6CTWUsd2aaL4/TcnbvgNm1/Xku5e9vYixaiLxmUQTLvcy+oi1zMcqspn83I7bwAWMsbFCcuv4XTVN2I8eF3uWKaiX7vykd+4J5uI36RzptHIJwzEEL6DuRCEZovthDS4qSDunhkw5LJixUCodGLclo2H+jIIgeu5wzaL3+l8nj5DhgnxPRw1YWMJ/5PvBfp/E0RNzSbrXdRhcWdUOOJefw7WBYJDyeooVt9JzEbQet6V9kJVqM2Zqz3uCVGPEo5O5l3+Y/KHNUw5vgPlfSs+Ri9GGQN9bZBIUDd2fbHBXxtkg+O6WAFN8k/rRjkCV7co5U3RnSfy45TsV9Fl93lggdJ1JopKCf9TrCie5ZCFTiJ8ssTEMrgOCGFPp8qCw1zIs/wIIrBMZxSdWgGiwM7E+/syCR5r0gTeRalfwel8/i6BLx01fyJxVrPbHBpJTnhJU+V/C9PRw+y5+GBMou7LzR/3AkhBRKMvAPxaCElDZWsBsArmb79btK7U/uhk7EjJ37OkIPAueSpw1NDFLRkP93p0raG79eoNnnbA6r7M7zDUMTDqm0ZrbGhBENyJeoiUkugYayyy4H0w4g0z03NWT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199018)(316002)(83380400001)(54906003)(8676002)(44832011)(8936002)(2906002)(41300700001)(7416002)(5660300002)(33716001)(86362001)(38100700002)(6916009)(66946007)(66556008)(66476007)(82960400001)(4326008)(26005)(9686003)(478600001)(186003)(6512007)(6486002)(6506007)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9qcTQJjWts6DBA6llvgLOkNx/cTaIdaqdos4N1n7HsAdKI3KCJrjFWJJpe5?=
 =?us-ascii?Q?DgVrnpwpcMiOR7WpTDOdvU/2JVabtPk3Tzbgs/eQENMbBLlSEGhGZ4T7hE2O?=
 =?us-ascii?Q?EKgqWztl61amyWebwzPmaCISpxmb/FaKlke5tP9bbpalu6f2f4kiF0KxlV6d?=
 =?us-ascii?Q?DDdl+Kd8/pA/BNKYkOreSthWDi5YPrZZmMjIrTLCmVbbCGPD3pfW6O6s2Egx?=
 =?us-ascii?Q?jn08hH0bB8P9a82sRHAAfcn1mXqCvutCsskdonmr6wlkOZ0kbR1IOUtwNxFY?=
 =?us-ascii?Q?6ccpsvsLsirTzLzsj0S7Epu2yzbJk6dpWL/k0rrx3PpDON0ChYT+wpC4CT1A?=
 =?us-ascii?Q?xwIuGlBVR4ph2xsey6hPFct+T3eyekMafPdG/KcVKYSMMmg8ErN+ip5j0CDa?=
 =?us-ascii?Q?GxS8wk5GAsXelqT2l1YVALR6eU3jfxNqsVYmoTYWMyXyLjjn8uFbmzSMjO8U?=
 =?us-ascii?Q?cRBA3RjcTmL03I+QwWf3Lbn26rbQmwkDzwWfMu7GvHHftpeKseGQkHBFHfoZ?=
 =?us-ascii?Q?Hrg/2LNgOY7B+e8Sz11cJb9bBoqFSM8vtY/rWhhovajzFsBCvZyoHlV6jv4k?=
 =?us-ascii?Q?kvKHr/OFsWOyvMaiMq7mXDmsS7SiHJmzTovKuO9x1WAMmcOVGvA4bsit72m4?=
 =?us-ascii?Q?j9JayXIE63rkl1URFHI90s3iSOVWdt/z8SNCU0SOTpv8c9AyrO8OuYytjRWn?=
 =?us-ascii?Q?qWLZngah1KHYoPk12yEaG6p152kU9S5IztiXQVgo7c8ACdG8HeQvZny08Rhq?=
 =?us-ascii?Q?Ytc0+keE/GWtgWyBtEtSCNOhHC4RRGMTNhIoqDbihM8b1WMSrzu8YwEpZ5Ao?=
 =?us-ascii?Q?3FqI0s+66kVn1Oh1dYSLda+zJVGt2uHR2KvVshv3ZW6AwqakAKc/chbEl3ep?=
 =?us-ascii?Q?tffMR44ojXycD1YOi6U8f8Or11QjHgeUSw32/8PgT6gbmgm+3klg7kdl1Yh5?=
 =?us-ascii?Q?C5dTMos8KX0xxMYgC5v70pgzWQ+t7NoROffZ0o4ErSZF9UB24+CHGzSuPKJR?=
 =?us-ascii?Q?RQg8PZstMm0zB8m20a62uEQEoOOZlC8LPewdRyVBUCKTt32Tlhl3NbLMEX9O?=
 =?us-ascii?Q?jPCZgiXQFn+hEj6LbLlN5olJYR+P3JnAMUBA4frCjhCPPQEuZnULuyw0OqAs?=
 =?us-ascii?Q?N7+uCu66XH6PCHEJlS6wwaFaCDXYwwYPAxmmQLhP+n95AoPBgAuEdF5Kg8JO?=
 =?us-ascii?Q?YFSlCjLzbPlAyaPHuPYxQ2uz07hnaSiou4fPEu15gGhEDVBnb+LYw9dzoJxe?=
 =?us-ascii?Q?YrWo/CvZUhlJSzv/cMxsAIOkStbMzeIvKTDa8j1A3OdIhh7A7uDZkgcb85SP?=
 =?us-ascii?Q?rzgoHMsrVJX7cCMVD0TUL4rETjxFks7WimB00KzVuyce+HS8e7RNMOGIL5Uq?=
 =?us-ascii?Q?KnYnIQT2RpX6af2ApND3j9t005pH9hT5Vu0BpSGFzocBLT1WnRPcq295X/Fd?=
 =?us-ascii?Q?Ow5ktjasQ10PBaFagA/e+Q+BUgbJ7cBPulwR9gByvsSFhi7FoGWGdGC8H7yM?=
 =?us-ascii?Q?eUh3v06TlO1+Q4xPiqGvWvpHVQBPZmF2rKfk167FOZHDY3Mequh9Wm4rXl/k?=
 =?us-ascii?Q?4bZOHbrEJ7vHEvc8Cr/CPXr/S/eXosvHUrTxvo37sFEMh0JslIeI0l2gv/RV?=
 =?us-ascii?Q?A1Bqw04o1B/WodebZkburq8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3221f783-3ead-42a8-1b68-08db09f17976
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:28:13.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2z0K3ZleH42H9YTEgDfM/mPmM728udb5rcuk/Q1LWDZoOhxfDeuiNLi6kqwTlO7VNWa23TNj2KemPuMpElXDm12RF2OUFVxiJtuUFU6YdMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7638
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

On Wed, Feb 08, 2023 at 07:37:57AM -0800, Alexander H Duyck wrote:
> On Wed, 2023-02-08 at 10:43 +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> > 
> > Recently I encountered one case where I cannot increase the MTU size
> > directly from 1500 to a much bigger value with XDP enabled if the
> > server is equipped with IXGBE card, which happened on thousands of
> > servers in production environment. After appling the current patch,
> > we can set the maximum MTU size to 3K.
> > 
> > This patch follows the behavior of changing MTU as i40e/ice does.
> > 
> > Referrences:
> > [1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
> > [2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> > 
> > Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> 
> This is based on the broken premise that w/ XDP we are using a 4K page.
> The ixgbe driver isn't using page pool and is therefore running on
> different limitations. The ixgbe driver is only using 2K slices of the
> 4K page. In addition that is reduced to 1.5K to allow for headroom and
> the shared info in the buffer.
> 
> Currently the only way a 3K buffer would work is if FCoE is enabled and
> in that case the driver is using order 1 pages and still using the
> split buffer approach.

Hey Alex, interesting, we based this on the following logic from
ixgbe_set_rx_buffer_len() I guess:

#if (PAGE_SIZE < 8192)
		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);

		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
#endif

so we assumed that ixgbe is no different than i40e/ice in these terms, but
we ignored whole overhead of LRO/RSC that ixgbe carries.

I am not actively working with ixgbe but I know that you were the main dev
of it, so without premature dive into the datasheet and codebase, are you
really sure that 3k mtu for XDP is a no go?

> 
> Changing the MTU to more than 1.5K will allow multi-buffer frames which
> would break things when you try to use XDP_REDIRECT or XDP_TX on frames
> over 1.5K in size. For things like XDP_PASS, XDP_DROP, and XDP_ABORT it
> should still work as long as you don't attempt to reach beyond the 1.5K
> boundary.
> 
> Until this driver supports XDP multi-buffer I don't think you can
> increase the MTU past 1.5K. If you are wanting a larger MTU you should
> look at enabling XDP multi-buffer and then just drop the XDP
> limitations entirely.
> 
> > ---
> > v4:
> > 1) use ':' instead of '-' for kdoc
> > 
> > v3:
> > 1) modify the titile and body message.
> > 
> > v2:
> > 1) change the commit message.
> > 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index ab8370c413f3..25ca329f7d3c 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
> >  			ixgbe_free_rx_resources(adapter->rx_ring[i]);
> >  }
> >  
> > +/**
> > + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > + * @adapter: device handle, pointer to adapter
> > + */
> > +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> > +{
> > +	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> > +		return IXGBE_RXBUFFER_2K;
> > +	else
> > +		return IXGBE_RXBUFFER_3K;
> > +}
> > +
> 
> There is no difference in the buffer allocation approach for LEGACY vs
> non-legacy. The difference is if we are building the frame around the
> buffer using build_skb or we are adding it as a frag and then copying
> out the header.
> 
> >  /**
> >   * ixgbe_change_mtu - Change the Maximum Transfer Unit
> >   * @netdev: network interface device structure
> > @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
> >  {
> >  	struct ixgbe_adapter *adapter = netdev_priv(netdev);
> >  
> > -	if (adapter->xdp_prog) {
> > +	if (ixgbe_enabled_xdp_adapter(adapter)) {
> >  		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
> >  				     VLAN_HLEN;
> > -		int i;
> > -
> > -		for (i = 0; i < adapter->num_rx_queues; i++) {
> > -			struct ixgbe_ring *ring = adapter->rx_ring[i];
> >  
> > -			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> > -				e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > -				return -EINVAL;
> > -			}
> > +		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> > +			e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > +			return -EINVAL;
> >  		}
> >  	}
> >  
> 
