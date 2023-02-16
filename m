Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF836997BB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjBPOnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjBPOn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:43:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03E44DE3D;
        Thu, 16 Feb 2023 06:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676558590; x=1708094590;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h3ce9AUgfx49YqTHXKX0wEqZheVDf9P9c5t68VVbr/w=;
  b=W9pLGccFnTf7Hnr8ggHMKWf0A9VZSw2NNW42vPPMtP7HItBQ3FcF0lDY
   3ReoHVje3W6phs09t4ZNWu25jvd/4fYprPv+9PXfve1V8O/sSu7BCyIIb
   Opr/PTA9DMMeGNboU1f76tNWRwAF3le7Zd78zu1SxvWYmI/BUvPv5F5v6
   A0c64nTio+PKqAsmshuE7hKEB511cCcNWOykcVk8m/lKdChcrYn9kVNck
   Cp+Me7s3KLI6pHbJxTjwR5vkZdFF+858StO2dnhsm0C6vsd6lh+Flz/eM
   hkwCldcmb34n8di3xRd+2zy321vf0EbmxOZ6ei/K7cq4FjMWLvAuZiJdj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359162109"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359162109"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:43:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="844165598"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="844165598"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2023 06:43:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:43:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:43:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:43:09 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:43:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZIrde26Q6zUccLyDnQmKSXlUoMyVSntEIzglVHUF3PjUX9RbQnRxftz0jENMMI9V/lnZxiW397qsdQQphbUdkvEsopjTzbaTTPFgXHEdTkG6o/wvn3T8RZvkMV2HUv+4c5gu+WNVzbZnhdYy1+h+y4PEp7Q2Jr1//0xWYGvMg+Ca3kwkEdoMK5URoFeQtBTzAEuP5Tub3OG8d8OGjf/bODtqkBIJvlGlX2FZWBuWXMMe2xApzHiOwi1mJXe3MOCbYt76HDmbAgrpQ82ISydrUHsfHH2zz6dv8v1xHYp100ZVjGiDtpE5fkiOcAxpzJuXsct5s6nkegPTpuLYm+G7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRfCYS4rMDFFQHa6GwHCvoXpkX687/WAtf8txRqKj1Y=;
 b=Pk2lgTB5ZlFROOeqKcLOPT0bB/fme4cn9UyzJO5dMqZvewKt17qNmWHNuRbUS+58rsnRFR9YVis0AgpQSRUp2RudziNryKBRTuHdtYnajqqOLJq5wkqcbAKNbsQJr2nfQwXcARB7K8DUjTf7FfI6k/GSg8uOuJLmZtQF/iL7AcHHpK+dVQb4v/MQr287dgVRVVoAyOflDTs5SLvF8hDAHlXbzC2YoINAUPl/d/9iNPiT0fRCxT/LqgWntoN43ZkwnzYKiO734EID+GTFh++wTM70iZMu5U633jioq/cXhEN7H/R59q1rPotTMlLWRmyslNeFScUA9zae4BQotNeBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 14:43:06 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 14:43:06 +0000
Date:   Thu, 16 Feb 2023 15:43:00 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-next v5 0/8] i40e: support XDP multi-buffer
Message-ID: <Y+5A9BV7E5IEQ4o2@boxer>
References: <20230216140043.109345-1-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216140043.109345-1-tirthendu.sarkar@intel.com>
X-ClientProxiedBy: FR0P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8f5f58-834d-4072-615e-08db102c1d7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p47cSVP1wdtuZYYlJm2noj5NPck/jtsPEGXyKPugJb4W4xHjkEoGzWvcjWTmnEOS6omJKSq4f+mHfmE265AvDQs5gqH5x1DVsM7xwP81UQErqzlhpRtLkpIZSKEwbM5mpSpWS1/CdNvwp5mVCSvUs+kCznaJy7O1R5FMPjJdraIV3/7X7YhKRcbL8INpNicg8qP1KOWug48LPrBLjT8cLv1RKSAWiOiJInkuHh0J7eU7a/bwoIS28rUmtm4H72NOz7xi1fjeBcMiAfT4k5bWxMecEq60H9EMUti8HqMi4Yqm/sia+4LT+Gixe+xEpvexwEwBUPaO3IP8XyZlwbjLq3gGZg1CMr/rzfgDkem8ZcRrtgZWzUR2CcB2Div8ESpfmIMj3+ubjvSB1cyTalrEdfTRs21ADqGLS9mbgWL0L/gDPfA07ntW46677BL9brI8WjFsAho6DBpIBUqzQtR0oISNNF2/HMFI0xTI3kGWotcrDzqivbfiCWsVQrcjDEcpwmCBUt6f/7WS8FkwmeGgFoooof0us1CPg8nABYzaXkiLToepkhred6v9tGK90m9vxO5AvfBjXaZQkgO4PChkdd1MlRzhJLB0mobIjXDxVUWXpRlkONjLzsNxN14fLlCbWuQQ0RRMQyqFZCgwlOy53wvYMoUS9tzdNWWh07qEY8IVASyFyu/lefiyrfZmd0UK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199018)(6636002)(83380400001)(478600001)(6486002)(6506007)(6666004)(6512007)(186003)(26005)(107886003)(9686003)(44832011)(41300700001)(38100700002)(82960400001)(5660300002)(86362001)(6862004)(8936002)(33716001)(316002)(66556008)(66946007)(2906002)(4326008)(8676002)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PVysifteMYnE+HnwYAULCn7DgQrL6SyYz+DdITuMCkG+fsQZt48waZNxdh7W?=
 =?us-ascii?Q?SSUISKKzFco/TN49Gx0CjRXJICm89oKF2oKGScGHxzizHZWSTg4kFi/MSBkt?=
 =?us-ascii?Q?JokYcmlwGJ0FZ2Hwdrwn74uxroXlNL6id8SGinkAEQpFlgL1E4KX9GYo0pSA?=
 =?us-ascii?Q?hsIGjopzO6XZsA6T/5dTYWAB2En1Pj7xCbhM+5QFdVCenKaqDamwrMf6BX4g?=
 =?us-ascii?Q?4tfPvkujQhKsVln2Dk3DH4qc/yQ+OYiDVu59WMRFnZainXj3BkZUgbXfdx/I?=
 =?us-ascii?Q?6RnEHCF7E3vjMF6leBmOVrd7Gpe896JMHOJH9BF09G7Bq9IoVVeeuREL1HPr?=
 =?us-ascii?Q?ziv5nwlKyN5RaRxWz9q88I4UZtl0zWKk/Z5xjjITjRzV224yZymGGswkdkhD?=
 =?us-ascii?Q?hSrNVmLt6kz2Vy5zL801RjglH45m93tPWMni7gJVyNuIsUv/rkBkh6waIVvC?=
 =?us-ascii?Q?yLlW0GOXhC+wlMS+SMEiGSp3vRqAIgDUpenYWEagiLBdlYlo5xsZt8cGPLuo?=
 =?us-ascii?Q?Ze6Nu0X+hMTgE3JeumlvHyLWnfwz1VKiJZkdi+YS9fRql7/656bgXycsB1QN?=
 =?us-ascii?Q?9+GGmH56QAynhDUdgopLhU7JOkfvZ1GulDtRIZGjmqQkInOlH3jqeEG/M947?=
 =?us-ascii?Q?nozoQjNEmZtdVfj9dsWVtfQKDEJGI/35iahOn0X3gHzs4ZSA/66wSZVMWFoS?=
 =?us-ascii?Q?jqKQ/qRSGziEGHLza3pLbEMY27RRY80lHGDPm6K5849Ll172QlHhMpR/s0x+?=
 =?us-ascii?Q?3LwIjRiTtByDqHrXdXykgadPs9IWZrEHqdh16pbb0/4Ktf8odZs3O1NhkEtG?=
 =?us-ascii?Q?k8rPKW6PBvsAF4FKl7B9jXSiqkNKknf4SPycKlMMLpZoS8vNrq0r42sZrIt3?=
 =?us-ascii?Q?0cLmFkQ2JufBK1OVvJfmQxSYbMP/x3+HhdkixmXd+r0twq3io8569IW45ZUY?=
 =?us-ascii?Q?WgNO8I5HQtVHiBVTCJ3hMxNZx7iwHC7n/ix1P5+n5zS9P72hpzGo1yWh1iIZ?=
 =?us-ascii?Q?/bFG+dzEANPAfkZcl5Sz+URdF3OCi1kkKQM9iHjIFgrkU+/r9/f6FX7kFPPH?=
 =?us-ascii?Q?yHikm7I7APfi2d9VZDP26DJpAwSBAxDXPKnZxOIVvoG+quUg7g+b7/PJz/DI?=
 =?us-ascii?Q?5fHgFzt/v+Ma1vvpn/xHF6WCMcEjux23EVvBCkezLI/2uO3wI/AK1XOaXOoO?=
 =?us-ascii?Q?VBcKNsuCSDjzCFZVv2jY6AwnJjGI5GjEZVMLV7oK3AWTCrJsJ9rGvq/VE2YW?=
 =?us-ascii?Q?EmdjO4zSa4nL4z590QCGBenB+95Po5fWNpAzZISWBIl2ZbBabaJqymkrgn2R?=
 =?us-ascii?Q?BbQrd20g5ldvD1qxySANjlG4OtnAnkHwdJ4GjQGCMZRCzI0SE64ZdUoEn5Hx?=
 =?us-ascii?Q?f8XI8P6vGsZv9J7A4TokwIx6MPhPcQqmX8VWDUOW5AA1jF1dyPo1j23xEygM?=
 =?us-ascii?Q?No74Sh7jddFTip8maezuP34xUfGDtRhve5NTOjyMtubAFDTJGuElIOjTYCsG?=
 =?us-ascii?Q?yxEPVD+mguBdUkWjpnuC8Xd5VKcWcGvAnsoyT5Gz0EeDus2N4XK9WvXsunzC?=
 =?us-ascii?Q?0anY5EVrV1uF9UTNEOwB/kQs14kECF2Sn6Lj5doS6xqOk+Uwn6r78vSiI/wY?=
 =?us-ascii?Q?bpIuoEWXZEOByjpVs+CZ2jI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8f5f58-834d-4072-615e-08db102c1d7f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:43:06.4112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPpNyAGXV3WT8S6h1aTJwNg5bloSE5l796kNL2Qxq86QdCpJ7hybtdEMLEw2eNg/hns50kXirVyS6Xm1amNSm8gd/gL7d5gmnswuOdJycvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5181
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

On Thu, Feb 16, 2023 at 07:30:35PM +0530, Tirthendu Sarkar wrote:
> This patchset adds multi-buffer support for XDP. Tx side already has
> support for multi-buffer. This patchset focuses on Rx side. The last
> patch contains actual multi-buffer changes while the previous ones are
> preparatory patches.
> 
> On receiving the first buffer of a packet, xdp_buff is built and its
> subsequent buffers are added to it as frags. While 'next_to_clean' keeps
> pointing to the first descriptor, the newly introduced 'next_to_process'
> keeps track of every descriptor for the packet. 
> 
> On receiving EOP buffer the XDP program is called and appropriate action
> is taken (building skb for XDP_PASS, reusing page for XDP_DROP, adjusting
> page offsets for XDP_{REDIRECT,TX}).
> 
> The patchset also streamlines page offset adjustments for buffer reuse
> to make it easier to post process the rx_buffers after running XDP prog.
> 
> With this patchset there does not seem to be any performance degradation
> for XDP_PASS and some improvement (~1% for XDP_TX, ~5% for XDP_DROP) when
> measured using xdp_rxq_info program from samples/bpf/ for 64B packets.

For series:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Changelog:
>     v4 -> v5:
>     - Change s/size/truesize [Tony]
>     - Rebased on top of commit 9dd6e53ef63d ("i40e: check vsi type before
>       setting xdp_features flag") [Lorenzo]
>     - Changed size of on stack variable to u32 from u16.
> 
>     v3 -> v4:
>     - Added non-linear XDP buffer support to xdp_features. [Maciej]
>     - Removed double space. [Maciej]
> 
>     v2 -> v3:
>     - Fixed buffer cleanup for single buffer packets on skb alloc
>       failure.
>     - Better naming of cleanup function.
>     - Stop incrementing nr_frags for overflowing packets.
>  
>     v1 -> v2:
>     - Instead of building xdp_buff on eop now it is built incrementally.
>     - xdp_buff is now added to i40e_ring struct for preserving across
>       napi calls. [Alexander Duyck]
>     - Post XDP program rx_buffer processing has been simplified.
>     - Rx buffer allocation pull out is reverted to avoid performance 
>       issues for smaller ring sizes and now done when at least half of
>       the ring has been cleaned. With v1 there was ~75% drop for
>       XDP_PASS with the smallest ring size of 64 which is mitigated by
>       v2 [Alexander Duyck]
>     - Instead of retrying skb allocation on previous failure now the
>       packet is dropped. [Maciej]
>     - Simplified page offset adjustments by using xdp->frame_sz instead
>       of recalculating truesize. [Maciej]
>     - Change i40e_trace() to use xdp instead of skb [Maciej]
>     - Reserve tailroom for legacy-rx [Maciej]
>     - Centralize max frame size calculation
> 
> Tirthendu Sarkar (8):
>   i40e: consolidate maximum frame size calculation for vsi
>   i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
>   i40e: add pre-xdp page_count in rx_buffer
>   i40e: Change size to truesize when using i40e_rx_buffer_flip()
>   i40e: use frame_sz instead of recalculating truesize for building skb
>   i40e: introduce next_to_process to i40e_ring
>   i40e: add xdp_buff to i40e_ring struct
>   i40e: add support for XDP multi-buffer Rx
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c  |  78 ++--
>  drivers/net/ethernet/intel/i40e/i40e_trace.h |  20 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 420 +++++++++++--------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h  |  21 +-
>  4 files changed, 307 insertions(+), 232 deletions(-)
> 
> -- 
> 2.34.1
> 
