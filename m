Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6545B6E9CEE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjDTUSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDTUSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:18:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2602C1FC2;
        Thu, 20 Apr 2023 13:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682021879; x=1713557879;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zJO2WvBRjTSR+K9SAPFSMaGwLQP+WbkQRmGxxOSP0JQ=;
  b=e3ANwBiZqQS0cRqZx1dd9Ep1Sk8z6C7s3aph654EZ4Rjm8v01dHE4Z07
   mRh3wfIakY1c6EUzOquiGXAEb2R3mX57PivgYvhwxF9OdawnGY9KZSTVQ
   xA3T+fV9sThri2OlNsDSwI1Q1vDMCnY1JBeCRC0qyeFrgdfB5AJv3xnB2
   2GNDbz3hd2mOvl4aB9VG4+uNv9IoSuPGXBr4ZAJP0ptY/oY5EJaqIUTr2
   b37CtA+SlNcclzf9yGa+csF/yJdGv3QuP7xunyPuVVEEJfTHIhqVonm/C
   t1cZCWLGOYncNtxXnqaeB+vz9tBQZ1yAFkxejymB/RuSxjQ8L/a1Az7n3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408777059"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="408777059"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="669472986"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="669472986"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2023 13:17:56 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:17:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:17:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:17:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBEb4NeJo3HskDWvEgymdyafy7rCOfl6R39NLC8iJxyIid7vAAEneOriXDh6CIVQVED/dlafKf9Nz2gDXTuwx5dNB0NkqZMXjxDx0/JwtampTDH9aCAxbdgJuOP0HmW0nNSVxlYR5eonZbA5AOfS2ZciUZv7dFf7TC3d/EYHVWxceRA0Fy3RkcyM6ZYjSvoleNKU9hy0Rupz42HYppDcf78CajtqRNLpj6ccmMNwhakHDBjapVRaS/vVMnjdgdxPqnSexQ+gE4ylbFAD0YuUqDqjgM/E/CSfvHHtAYbEeVxTZVwyCJRO77qgTMDBb/dOxM2IMtbkUm2BzXMCfAfrdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+iWa8kW2Yz3hTc3PxLT9EaJFD9V4/rTjQP+v5wpMIw=;
 b=MMkY4gi9xIdlB5LGmy/eZe/z9TEEjkQMP6/+UCm4OzNU0++1goVMY4HsQ1Jb0np4d+er4k3GtSxrsesTsBpi5lsKxM49UQtdCCRdiRzryPBk0ke17VxgJhEAg9i+bpEz6+/uuQxBM/FLEZgZpD01jLAHKLeQ3Lu8idDujjXPxvPyQLK2UXf1LpRnpYzEtm/Fml3a+OblPE+hTxqwUm4i9jTpnuPOzN91jDu/q4tMyPawPUIfw0w+gsFornPcvYKcWmFIN9Y8nFDYDWc32jbc1/SqfOzNPZrYQlN4b12a9raq6sSApYJD4YyaP/imWhbejfDaoKcwlXMnXAKWdpyaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO6PR11MB5636.namprd11.prod.outlook.com (2603:10b6:5:357::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20; Thu, 20 Apr 2023 20:17:53 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 20:17:53 +0000
Date:   Thu, 20 Apr 2023 22:17:41 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 6/6] tsnep: Add XDP socket zero-copy TX
 support
Message-ID: <ZEGd5QHTInP8WRlZ@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230418190459.19326-7-gerhard@engleder-embedded.com>
X-ClientProxiedBy: FR2P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO6PR11MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: 980c1838-3880-436b-f888-08db41dc5260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFzA805mxKa8vt+MgaHAtyztjv/IPTBzRmUaR0hfrmnbI2CDxxvhv8t1gkD5iduOfwdkN3ZtCiUXWew/2BNhc/xxMT17kROBo80n6BMx9X3GpmnkOvgM0MmE3cno7rBypVq++o9WIe+hX0O4sHmp8YzkdqrqUYQezxbP6zetqe4SNLUdFQePCMyc+sahPesKQTkjhuPOo787GKBVtXYWeoSv++7Z8nUSc8jfLonkFWiQyQIEMhifLIUJ97qphD9E7bnFvVB5qxv7+GrF4q5CwIY/OHvNgI7SP8rApbrjDYwCovP2dj+VHhpT2aUOuPZKw4TneAFrXeYPkCapSxP1d+iQqCog7T2pdHItn/Gp3GCF6hvSNWOt1NVZWhisHpwSxJiImFdnEvMz1dwMBELFkPd+8THlibsaPDkb+PQcf0Vl9x3ln6a6LoeyiXZULwesaJ36BzShibH4xhgPbGHQlGsF+nc1PgU6vxXUtcuE11YpLk4tttuALtNpdwaXxfMr4h7ogAVeoVqQX8fCRaVl+C8NkkCMoB+v/cpGU3CQK0HvfhjCK327fWVH7SeWgEqB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(6486002)(6666004)(478600001)(86362001)(83380400001)(9686003)(82960400001)(26005)(38100700002)(6512007)(186003)(6506007)(316002)(33716001)(66476007)(66556008)(66946007)(2906002)(6916009)(44832011)(8936002)(8676002)(5660300002)(41300700001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yPXt9+RA08tRvP97uXNn5v8rCybJ5IkOKEAcRyh3rHkMZHc+x9b78GI6DYno?=
 =?us-ascii?Q?DzhAYoOu1CtwctvIxN8JfCv1BMsVQDUq0QCMvFgPcQL1xftgREPmZF1y3TD0?=
 =?us-ascii?Q?qEL7ZcZriWBxI4vP/zh3pDVTZnCZIhuRsPZbAPHxxlG06f8io9Oj5iCyZ/nv?=
 =?us-ascii?Q?y2OJ3tB2jDmKFhaqKRFTMr1eshJSu9PlwJPu2Q7Myy8Pq856WQQUWyyiPtD4?=
 =?us-ascii?Q?RUonzJSRurOhyv2HyB5WP8U2OICXRlPwdGG9V90oHxCrjZH2T3Ufym5UuKZo?=
 =?us-ascii?Q?tCixDY4Eu4cajszvsdpxzPcNShTG4scuYUft6J+Ik8WfvzGzw+WVz0YYNmiY?=
 =?us-ascii?Q?43ZbyZQlpxndzfm2Q4g/lLVmgeEUMdMubcs37hNci4FHqJhnDda33YKPlxWW?=
 =?us-ascii?Q?l57Va2ribIjpekGca++Aw05U0yb/Dsluefsnjw40jbOwSS7FadtrPhKv0rjZ?=
 =?us-ascii?Q?laKxGoncC9QqdnkzOZlpAj82Rh+eEHsjFMAI+veRdpHKYpzIueBiKsqV0RS7?=
 =?us-ascii?Q?kzXam/s1oVRJR6JVULBFhh4vInk0vO5tHItm/7vrUBBYOWRWg2vri5rRtK3e?=
 =?us-ascii?Q?QZiU/bfd2qXbgLxRAlidPMLUHpRylmIWKeZaMSPwyuVKu00gTCtaDcgw5RRc?=
 =?us-ascii?Q?P8MIrr5Gh8/bguMNbG4B1bEdAxPFx49UhqCnkxc4uM5dL5m6npRRHRdAtBGH?=
 =?us-ascii?Q?1A/Um60TqtTY/2dq+umwnQh8Z29/IBNgUowYo13SHQappa9jhf5kL6hpwuqE?=
 =?us-ascii?Q?BGXVTbBQw/lcu+eYlJDG/Lg+4rMlASIZ3tAAZevz0lVDdYK/5bMJmr4NVEGL?=
 =?us-ascii?Q?SXTODmBdePXDD6WQFYM3CdT0uk1/HGXF8UEV00SwWOeHTSN7sq6W+MT44760?=
 =?us-ascii?Q?u4EzySrmTaCWoZAMhu3Jv0Sy7IUZVD8XGULKt8tI8CO3hsL58uxufpVrcV/V?=
 =?us-ascii?Q?zz64rQJcylGfkWyY3wuM4GwfwMPtQg6PF6lLyzB9CsBlZGz87euE6dLS1J2i?=
 =?us-ascii?Q?2893iFDD86RnmkHO1onuTV6bGW+b8a1iGqsof8kweybA8BrkdGWOkumfm5ke?=
 =?us-ascii?Q?Rt9eUi6S+rTwheYXnRxeVsUo9S9xeBXrE0vmCpoYtvquc3+GMlSYm4g8aRWr?=
 =?us-ascii?Q?nAmnc6xcmL+meIzTNh1Tf3zt1gM3Ajo8HOlv0hq+j++Be8RtYkvUSL0vgivL?=
 =?us-ascii?Q?5E8d68hoj9I1qpPHDm+Zep+xZigQ5lNi3dCfWOZtGBETGeHWV8J89Vns2CLL?=
 =?us-ascii?Q?auXQPnuc2Ex4C0B/hNm/6VDxKUByTEU9aZjEJOgA1oDARCfQP7FS7FzgrBB9?=
 =?us-ascii?Q?XugCJahfxFD5Rz1FyMb3NIdSkG9O68P6gtLYmApSPjDUqgWeMS+r4VNPutQu?=
 =?us-ascii?Q?dc8YkAaf7r4VSuVpBBST6pbPKKvkUSHyi7g5ilLFDzHLlXaLe0mqysi1TNjJ?=
 =?us-ascii?Q?vOLOFQ5BY92OwoF8uKGPmF83Vzt8U5URBoyjyeFcjmWt8N47EaoPCf9JdyTQ?=
 =?us-ascii?Q?PaV24xW4c/yV5l0myBP8FdqnReNztkXPBhi+aYrmW//+4f5uCRYIItvG8/po?=
 =?us-ascii?Q?rWXz/ZjTAeMTB9FxO1KAprpEgRRqecxuWognGHUE8JZzRCH76gE8zIfY1mjK?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 980c1838-3880-436b-f888-08db41dc5260
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 20:17:53.5232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlHp0TbTQsZuMoR8Z3MIVTAyXftOT4tJoyy6E4bSndd4y9lUHtWXH3WTlvSfmiyje+C+4roT9Y7Fs/uX3RPWoZQyCxBSdTrVETFbgKKM+1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5636
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:04:59PM +0200, Gerhard Engleder wrote:
> Send and complete XSK pool frames within TX NAPI context. NAPI context
> is triggered by ndo_xsk_wakeup.
> 
> Test results with A53 1.2GHz:
> 
> xdpsock txonly copy mode:
>                    pps            pkts           1.00
> tx                 284,409        11,398,144
> Two CPUs with 100% and 10% utilization.
> 
> xdpsock txonly zero-copy mode:
>                    pps            pkts           1.00
> tx                 511,929        5,890,368
> Two CPUs with 100% and 1% utilization.

Hmm, I think l2fwd ZC numbers should be included here not in the previous
patch?

> 
> Packet rate increases and CPU utilization is reduced.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |   2 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 127 +++++++++++++++++++--
>  2 files changed, 119 insertions(+), 10 deletions(-)
> 

(...)

> +static int tsnep_xdp_tx_map_zc(struct xdp_desc *xdpd, struct tsnep_tx *tx)
> +{
> +	struct tsnep_tx_entry *entry;
> +	dma_addr_t dma;
> +
> +	entry = &tx->entry[tx->write];
> +	entry->zc = true;
> +
> +	dma = xsk_buff_raw_get_dma(tx->xsk_pool, xdpd->addr);
> +	xsk_buff_raw_dma_sync_for_device(tx->xsk_pool, dma, xdpd->len);
> +
> +	entry->type = TSNEP_TX_TYPE_XSK;
> +	entry->len = xdpd->len;
> +
> +	entry->desc->tx = __cpu_to_le64(dma);
> +
> +	return xdpd->len;
> +}
> +
> +static void tsnep_xdp_xmit_frame_ring_zc(struct xdp_desc *xdpd,
> +					 struct tsnep_tx *tx)
> +{
> +	int length;
> +
> +	length = tsnep_xdp_tx_map_zc(xdpd, tx);
> +
> +	tsnep_tx_activate(tx, tx->write, length, true);
> +	tx->write = (tx->write + 1) & TSNEP_RING_MASK;
> +}
> +
> +static void tsnep_xdp_xmit_zc(struct tsnep_tx *tx)
> +{
> +	int desc_available = tsnep_tx_desc_available(tx);
> +	struct xdp_desc *descs = tx->xsk_pool->tx_descs;
> +	int batch, i;
> +
> +	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
> +	 * will be available for normal TX path and queue is stopped there if
> +	 * necessary
> +	 */
> +	if (desc_available <= (MAX_SKB_FRAGS + 1))
> +		return;
> +	desc_available -= MAX_SKB_FRAGS + 1;
> +
> +	batch = xsk_tx_peek_release_desc_batch(tx->xsk_pool, desc_available);
> +	for (i = 0; i < batch; i++)
> +		tsnep_xdp_xmit_frame_ring_zc(&descs[i], tx);
> +
> +	if (batch) {
> +		/* descriptor properties shall be valid before hardware is
> +		 * notified
> +		 */
> +		dma_wmb();
> +
> +		tsnep_xdp_xmit_flush(tx);
> +	}
> +}
> +
>  static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  {
>  	struct tsnep_tx_entry *entry;
>  	struct netdev_queue *nq;
> +	int xsk_frames = 0;
>  	int budget = 128;
>  	int length;
>  	int count;
> @@ -676,7 +771,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
>  		    skb_shinfo(entry->skb)->nr_frags > 0)
>  			count += skb_shinfo(entry->skb)->nr_frags;
> -		else if (!(entry->type & TSNEP_TX_TYPE_SKB) &&
> +		else if ((entry->type & TSNEP_TX_TYPE_XDP) &&
>  			 xdp_frame_has_frags(entry->xdpf))
>  			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
>  
> @@ -705,9 +800,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  
>  		if (entry->type & TSNEP_TX_TYPE_SKB)
>  			napi_consume_skb(entry->skb, napi_budget);
> -		else
> +		else if (entry->type & TSNEP_TX_TYPE_XDP)
>  			xdp_return_frame_rx_napi(entry->xdpf);
> -		/* xdpf is union with skb */
> +		else
> +			xsk_frames++;
> +		/* xdpf and zc are union with skb */
>  		entry->skb = NULL;
>  
>  		tx->read = (tx->read + count) & TSNEP_RING_MASK;
> @@ -718,6 +815,14 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  		budget--;
>  	} while (likely(budget));
>  
> +	if (tx->xsk_pool) {
> +		if (xsk_frames)
> +			xsk_tx_completed(tx->xsk_pool, xsk_frames);
> +		if (xsk_uses_need_wakeup(tx->xsk_pool))
> +			xsk_set_tx_need_wakeup(tx->xsk_pool);
> +		tsnep_xdp_xmit_zc(tx);

would be good to signal to NAPI if we are done with the work or is there a
need to be rescheduled (when you didn't manage to consume all of the descs
from XSK Tx ring).

> +	}
> +
>  	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
>  	    netif_tx_queue_stopped(nq)) {
>  		netif_tx_wake_queue(nq);
> @@ -765,12 +870,6 @@ static int tsnep_tx_open(struct tsnep_tx *tx)
>  
>  static void tsnep_tx_close(struct tsnep_tx *tx)
>  {
> -	u32 val;
> -
> -	readx_poll_timeout(ioread32, tx->addr + TSNEP_CONTROL, val,
> -			   ((val & TSNEP_CONTROL_TX_ENABLE) == 0), 10000,
> -			   1000000);
> -
>  	tsnep_tx_ring_cleanup(tx);
>  }
>  
> @@ -1786,12 +1885,18 @@ static void tsnep_queue_enable(struct tsnep_queue *queue)
>  	napi_enable(&queue->napi);
>  	tsnep_enable_irq(queue->adapter, queue->irq_mask);
>  
> +	if (queue->tx)
> +		tsnep_tx_enable(queue->tx);
> +
>  	if (queue->rx)
>  		tsnep_rx_enable(queue->rx);
>  }
>  
>  static void tsnep_queue_disable(struct tsnep_queue *queue)
>  {
> +	if (queue->tx)
> +		tsnep_tx_disable(queue->tx, &queue->napi);
> +
>  	napi_disable(&queue->napi);
>  	tsnep_disable_irq(queue->adapter, queue->irq_mask);
>  
> @@ -1908,6 +2013,7 @@ int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool)
>  	if (running)
>  		tsnep_queue_disable(queue);
>  
> +	queue->tx->xsk_pool = pool;
>  	queue->rx->xsk_pool = pool;
>  
>  	if (running) {
> @@ -1928,6 +2034,7 @@ void tsnep_disable_xsk(struct tsnep_queue *queue)
>  	tsnep_rx_free_zc(queue->rx);
>  
>  	queue->rx->xsk_pool = NULL;
> +	queue->tx->xsk_pool = NULL;
>  
>  	if (running) {
>  		tsnep_rx_reopen(queue->rx);
> -- 
> 2.30.2
> 
