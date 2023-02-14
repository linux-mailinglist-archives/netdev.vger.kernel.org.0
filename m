Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574C1696AB3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjBNRCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjBNRCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:02:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066602E83E;
        Tue, 14 Feb 2023 09:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676394127; x=1707930127;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WWNnKkTjBM10FrBareb9TqNgMnPiLmzVrNWtU39Cf/4=;
  b=ik0Fqm99wRCKj4NPD/POmWO5wQ3GBBGaP9qtkxsN7BG0oJULvcdpHQck
   SwEeGOkRyQlxhI8U14Q0GgA479VLGtYg2KKLAYC3NPbflQ33z5tgUVMMi
   iyVA1DSwh1sgXfDAV7rNGPihvN9+QE1+wZe43vdzYLPkA1oVobTq0UDtF
   Uk+tDZddWk/ankLPtJLlmO7JQIodFM9u0gVjOjBhpnnt3wnzjUtNNk1Xu
   +fIDtt731006Qh+CywhGjyxYxHNLCGt1yMt7sAR0WPixtutZhWvsUorUG
   jKaRQ9eI7TK9siThbQZauSLiRgwwgNe2jhN70TwbKrcHa2OO8VsphnfPc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358623174"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="358623174"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:01:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669254066"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="669254066"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 14 Feb 2023 09:01:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:01:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:01:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:01:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:01:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7HNZwFu/AhKwObaK38gEbpxXAlpA9pD5YLmJjMCQLWdpKrU6U7eYqcYVuJ3kH99OMi4hOxxQrhqNYktYcdjrwJd+Bbc8YsYyLCjF+E5PD/glYZxzHCmcMQtUFvUzc5F5teARiBvjQt2CVAf8Y5kgu4KUpgfaFOhuYZX/MIEzht/7afL9LkErNYFu3p+9tsALoQWJrFIo9xrstO6PAyXH6iMCYUKrmkdjgnE87pXC+sZ1QncU5/ojTH5MxeELg1WxG7TmGCaWW17E4GRB8jQ7+5m1JwaLyQ4cXJ61MWCfTyHXubLh4kPRYqtDd6lpF4PeM0CnqsWyzfzkcnLwexQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+6Of+nv0Zf87QLFlr/Og6X+gzRYdAXVKMzkJCOzF2o=;
 b=YcmyPPknlBy34AfqgYhQz+Nkv04NseWzGTnG6LS9G/4vHbQgpJD4/DRFUBPx3Bn6p8O0+Xu+pvd27zI2RQl43dJZ7WXCBnW6dToOyE2nxgbvwSH3GjBSgtjw8Xm8VRnnNSDLyin7dOd0xv8LETiwW1UZOjccvlVUTG24zCeeuKnfaJ8I5u9Ksz9m/OsBpDutPIV0/oB3iYz7mCI2T5l7/DgyPaEUveWZeO868yr2Zd8u+8VXnRauzpbBdfNQKeTuAW0NIk5IfU1YjaAQRXe9uX2xXwzk3xUmdY7LVaTY/5DS+ZxzTblwDAwE5K5MUESIYDL8QJLfw3OaUS8qMf39XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7244.namprd11.prod.outlook.com (2603:10b6:930:97::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Tue, 14 Feb 2023 17:01:36 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 17:01:36 +0000
Date:   Tue, 14 Feb 2023 18:01:29 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Message-ID: <Y+u+aUJJ2EQYEdJB@boxer>
References: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
 <20230214123018.54386-9-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214123018.54386-9-tirthendu.sarkar@intel.com>
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7244:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a228a36-a52b-47ad-c949-08db0ead21ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/iWH24O6KdGmK40/nqcH2IsNpJqHYF0XLVpAzEDIEw/hlMWQ2PvrZ8QIVIyfFx1kBK4WcCUjSHWeVxVAjsR0pHtAEYO2dVnY4AoUEtuVLbvUaoT8Co/oyMnoC6Qz4mztEEzLV8h9pJshh9YPXBf/gYZMAGWNLSIspCctekEJv60NyaVbZCDCqOmURViCXR8wX4C18LcxbAE/f+yiDhQI/6VfGPvu5ebi+qSrUJxrELDV4FGR/dAp8fjJ54E5FgmodKfdG9sPFWRpN2GkahainoTnV+fwvSV7jYVC5hvRdOgIC6CGa4SEVakbdNJLnMhq1VhRvhsSHZORN3vLQSWhJFsU2bdq10HmmaSMMcPDpH6wE+vRXoX8dV3cbqOCmZSRLqTGOOUzOzxb1eGDYGwPKyrKq3ag2CZxjhHXNhc5XtnKNPKlXlOzKpJTQcWbK1vISbExasrMZuFgkWrb8zqShP49peFunEkKUahtLBE7eTueu85sZQCxcoSU4ULwErxhKbdgel8rS0URZmqBgU7h/lM1QUOuXsO4xt0bD7K/+LtCkYqb30zQqED5RbPyDR757BzfQviPASwK0Pj55VHAS3O6+g2qOw3Zbg3ji/gP2/Sh3UA45LG/pILYgRwQgIkicD/y/rnJ+4z2FaJrUyXfne7FREdg5yNw/fgCYLnoyTq01W2iHOj6eN5oXmWNU8TEgdvXPeMBhF1JQo2dL/wkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199018)(107886003)(6486002)(6506007)(6512007)(186003)(26005)(6666004)(9686003)(478600001)(82960400001)(38100700002)(86362001)(83380400001)(2906002)(33716001)(41300700001)(5660300002)(66476007)(66946007)(66556008)(4326008)(8676002)(6862004)(8936002)(316002)(44832011)(6636002)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mp57971P0IEPoX+mqk+xZgbnDogFolTfZqBoOl6uisohcr9XEfFcvq2hgcwp?=
 =?us-ascii?Q?0Kfs5lzwdnloHvFZjh0DUrd0z7KV2L1SshxwwAx2UW8UlbE+azKPCvjeZdP3?=
 =?us-ascii?Q?6Zyqn+9thRqPfMzVyacbv2gY1W52iVNq/25dvUPptd0eFOTE5/coJtDwiY7J?=
 =?us-ascii?Q?eHjt2BeiS4bZRTBowoDcPih7ug4i6Z1fhCAtcR1HGE2dFxCHv2XtrK6QylMB?=
 =?us-ascii?Q?j0MM+hmNP3hsVKW0LZ3ny8CwU0yGOxgGuaAwVYD2fR2GkfA/qdpBPnJTQXnQ?=
 =?us-ascii?Q?A76Rzu9Fn7iAsEeT2Di0ij8Kw7oZvfo2lB6IA0A3k/+Y8/yvGhjtI/9gEjum?=
 =?us-ascii?Q?seuuZiZUXyeGWKomufRknLFmWD1zXVbFF1PFBID6pStKWzi6/ZSMPb8TE6M+?=
 =?us-ascii?Q?NgZyBP8jSbhTJIIHW7dQGDDXMfxohAoJj4qPlSahNkL2TXge6d3f3YQZz6IB?=
 =?us-ascii?Q?cYHd3MSULguIsquOleCWBLwVx/9ZS4NeXXSipezXPVD6vaoj/wVdk34wPC+r?=
 =?us-ascii?Q?6WYzS287NWcwhjyGyF/D5HVzkW7g0lCq2H+pJWC2Kon4trYGin/qZZkMxXyH?=
 =?us-ascii?Q?ApTPw4VYcpnk92/oDtFO3dfLDp/iunOBmEoQI0Bs3j8K8Snxq2RmFabR0n0a?=
 =?us-ascii?Q?kOw+yI+vvhmFqvCAUAmLdY5vIsuLXnIdgEgICQW2/W0+TfiI00+VzlqPG9rd?=
 =?us-ascii?Q?jb8l5evnAYfCvHvVLvzQ92dhup3v6k/l8Q0rFe6QGvKgk5IntOULHilRNAIm?=
 =?us-ascii?Q?xO0ljDNdfG/0XpvDtcOIcnyeoAbZjvSWQlVm/XY4MCIOgHOYQbssRyjyhxLY?=
 =?us-ascii?Q?4wWytVDKWxomAi9Y4o55bBcAGEB5E6rVMvKd8q8dStjE0pp+95MjziKeyuZq?=
 =?us-ascii?Q?pGWIC7vv1OaSXw+tijxmm1FeCtaiZxXP/aPnC5BuzKFvCk2GdISI2FB0EIyB?=
 =?us-ascii?Q?f6EbvydO8SQoPHE2w1FXpKjCFhLATmPGq5DMKlEnC2aMZSMBBaGFIfQMwrlA?=
 =?us-ascii?Q?3Ht2BEWay2Q85RyUkwollrYWFLZpinJ0eku8jXUwgc79kUCd3CSRxYUR7+U9?=
 =?us-ascii?Q?u0b8kgT9qAJMch1HxfZfA44qobKhx8njHhHOdas/UhJ4mzrXzTPy5ICzcmXa?=
 =?us-ascii?Q?z3TJ3Kru421GP/3hGkJ5+NUkVPy6bM1b+lZf7tvhPCazphmKW9qSsIQ45+Gu?=
 =?us-ascii?Q?MCibO/l/Un131NY2bIb1AXU8JcDNkfalPdwttdp+mFOI/4z0htg439uP54Fr?=
 =?us-ascii?Q?lKqZKh5YMKDCAbIF2Dk/SbOr8lu+7LE263bqpn1ykw9Ze5VZ5nOvExhgvyhs?=
 =?us-ascii?Q?Tz8Evt0XAdvHpeJi07gD0c7xLsZkTbbTT+38iLK0uflFRFgEkLjD12TP6E/m?=
 =?us-ascii?Q?mQDJJw4gagiT4Pcw8xQIpyuCEWGEWsrMy1ELCgj/lTlLYKBgabpEkXBcEh4B?=
 =?us-ascii?Q?QvBFJQ7YrSXYji92zaK5RlXlMpq278qqqX/8+5+7ZxJ1sdC6CzKK+51sVzvH?=
 =?us-ascii?Q?zQa3F3b/JtOi8dkrUtNj4XIBGpVdRfwBCo+CWcWrgK0zQuS8hMjxRJbbYnGG?=
 =?us-ascii?Q?FDa1jRA5Vc+cOXwxmXHU0TuAuxmXbGziaDjbuSqDLz/+8FVdYhkSqp3eqb8B?=
 =?us-ascii?Q?m9OdV2tJSk0caeerW5c0HJg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a228a36-a52b-47ad-c949-08db0ead21ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:01:36.5295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okQw51/p1Fg3KrpUEHNHie+hXd/Xi9A88yPgYgN6kZ3HUL8FBhb40bKWXtv5Em00IhyR7Yo4YzndpQ/9n1S6dI1BqbjS1IX+LDBuHxRfzAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7244
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

On Tue, Feb 14, 2023 at 06:00:18PM +0530, Tirthendu Sarkar wrote:
> This patch adds multi-buffer support for the i40e_driver.
> 
> i40e_clean_rx_irq() is modified to collate all the buffers of a packet
> before calling the XDP program. xdp_buff is built for the first frag of
> the packet and subsequent frags are added to it. 'next_to_process' is
> incremented for all non-EOP frags while 'next_to_clean' stays at the
> first descriptor of the packet. XDP program is called only on receiving
> EOP frag.
> 
> New functions are added for adding frags to xdp_buff and for post
> processing of the buffers once the xdp prog has run. For XDP_PASS this
> results in a skb with multiple fragments.
> 
> i40e_build_skb() builds the skb around xdp buffer that already contains
> frags data. So i40e_add_rx_frag() helper function is now removed. Since
> fields before 'dataref' in skb_shared_info are cleared during
> napi_skb_build(), xdp_update_skb_shared_info() is called to set those.
> 
> For i40e_construct_skb(), all the frags data needs to be copied from
> xdp_buffer's shared_skb_info to newly constructed skb's shared_skb_info.
> 
> This also means 'skb' does not need to be preserved across i40e_napi_poll()
> calls and hence is removed from i40e_ring structure.
> 
> Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
> buffers. For multi-buffers this may not be optimal as there may be more
> cleaned buffers in each i40e_clean_rx_irq() call. So this is now called
> when at least half of the ring size has been cleaned.

Please align this patch with xdp_features update

> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |   4 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 314 +++++++++++++-------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
>  3 files changed, 209 insertions(+), 117 deletions(-)
> 

(...)

>  }
>  
> +/**
> + * i40e_add_xdp_frag: Add a frag to xdp_buff
> + * @xdp: xdp_buff pointing to the data
> + * @nr_frags: return number of buffers for the packet
> + * @rx_buffer: rx_buffer holding data of the current frag
> + * @size: size of data of current frag
> + */
> +static int i40e_add_xdp_frag(struct xdp_buff *xdp, u32 *nr_frags,
> +			     struct i40e_rx_buffer *rx_buffer, u32 size)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +
> +	if (!xdp_buff_has_frags(xdp)) {
> +		sinfo->nr_frags = 0;
> +		sinfo->xdp_frags_size = 0;
> +		xdp_buff_set_frags_flag(xdp);
> +	} else if (unlikely(sinfo->nr_frags >= MAX_SKB_FRAGS)) {
> +		/* Overflowing packet: All frags need to be dropped */
> +		return  -ENOMEM;

nit: double space

> +	}
> +
> +	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buffer->page,
> +				   rx_buffer->page_offset, size);
> +
> +	sinfo->xdp_frags_size += size;
> +
> +	if (page_is_pfmemalloc(rx_buffer->page))
> +		xdp_buff_set_frag_pfmemalloc(xdp);
> +	*nr_frags = sinfo->nr_frags;
> +
> +	return 0;
> +}
> +
> +/**
> + * i40e_consume_xdp_buff - Consume all the buffers of the packet and update ntc
> + * @rx_ring: rx descriptor ring to transact packets on
> + * @xdp: xdp_buff pointing to the data
> + * @rx_buffer: rx_buffer of eop desc
> + */
> +static void i40e_consume_xdp_buff(struct i40e_ring *rx_ring,
> +				  struct xdp_buff *xdp,
> +				  struct i40e_rx_buffer *rx_buffer)
> +{
> +	i40e_process_rx_buffs(rx_ring, I40E_XDP_CONSUMED, xdp);
> +	i40e_put_rx_buffer(rx_ring, rx_buffer);
> +	rx_ring->next_to_clean = rx_ring->next_to_process;
> +	xdp->data = NULL;
> +}
> +
>  /**
>   * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
>   * @rx_ring: rx descriptor ring to transact packets on
> @@ -2405,9 +2495,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  {
>  	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>  	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
> +	u16 clean_threshold = rx_ring->count / 2;
>  	unsigned int offset = rx_ring->rx_offset;
>  	struct xdp_buff *xdp = &rx_ring->xdp;
> -	struct sk_buff *skb = rx_ring->skb;
>  	unsigned int xdp_xmit = 0;
>  	struct bpf_prog *xdp_prog;
>  	bool failure = false;
> @@ -2419,11 +2509,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  		u16 ntp = rx_ring->next_to_process;
>  		struct i40e_rx_buffer *rx_buffer;
>  		union i40e_rx_desc *rx_desc;
> +		struct sk_buff *skb;
>  		unsigned int size;
> +		u32 nfrags = 0;
> +		bool neop;
>  		u64 qword;
>  
>  		/* return some buffers to hardware, one at a time is too slow */
> -		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
> +		if (cleaned_count >= clean_threshold) {
>  			failure = failure ||
>  				  i40e_alloc_rx_buffers(rx_ring, cleaned_count);
>  			cleaned_count = 0;
> @@ -2461,76 +2554,83 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  			break;
>  
>  		i40e_trace(clean_rx_irq, rx_ring, rx_desc, xdp);
> +		/* retrieve a buffer from the ring */
>  		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
>  
> -		/* retrieve a buffer from the ring */
> -		if (!skb) {
> +		neop = i40e_is_non_eop(rx_ring, rx_desc);
> +		i40e_inc_ntp(rx_ring);
> +
> +		if (!xdp->data) {
>  			unsigned char *hard_start;
>  
>  			hard_start = page_address(rx_buffer->page) +
>  				     rx_buffer->page_offset - offset;
>  			xdp_prepare_buff(xdp, hard_start, offset, size, true);
> -			xdp_buff_clear_frags_flag(xdp);
>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
>  			xdp->frame_sz = i40e_rx_frame_truesize(rx_ring, size);
>  #endif
> -			xdp_res = i40e_run_xdp(rx_ring, xdp, xdp_prog);
> +		} else if (i40e_add_xdp_frag(xdp, &nfrags, rx_buffer, size) &&
> +			   !neop) {
> +			/* Overflowing packet: Drop all frags on EOP */
> +			i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
> +			break;
>  		}
>  
> +		if (neop)
> +			continue;
> +
> +		xdp_res = i40e_run_xdp(rx_ring, xdp, xdp_prog);
> +
>  		if (xdp_res) {
> -			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> -				xdp_xmit |= xdp_res;
> +			xdp_xmit |= xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR);

what was wrong with having above included in the

	} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {

branch?

> +
> +			if (unlikely(xdp_buff_has_frags(xdp))) {
> +				i40e_process_rx_buffs(rx_ring, xdp_res, xdp);
> +				size = xdp_get_buff_len(xdp);
> +			} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
>  				i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
>  			} else {
>  				rx_buffer->pagecnt_bias++;
>  			}
>  			total_rx_bytes += size;
> -			total_rx_packets++;
> -		} else if (skb) {
> -			i40e_add_rx_frag(rx_ring, rx_buffer, skb, size);
> -		} else if (ring_uses_build_skb(rx_ring)) {
> -			skb = i40e_build_skb(rx_ring, rx_buffer, xdp);
>  		} else {
> -			skb = i40e_construct_skb(rx_ring, rx_buffer, xdp);
> -		}
> +			if (ring_uses_build_skb(rx_ring))
> +				skb = i40e_build_skb(rx_ring, xdp, nfrags);
> +			else
> +				skb = i40e_construct_skb(rx_ring, xdp, nfrags);
> +
> +			/* drop if we failed to retrieve a buffer */
> +			if (!skb) {
> +				rx_ring->rx_stats.alloc_buff_failed++;
> +				i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
> +				break;
> +			}
>  
> -		/* exit if we failed to retrieve a buffer */
> -		if (!xdp_res && !skb) {
> -			rx_ring->rx_stats.alloc_buff_failed++;
> -			rx_buffer->pagecnt_bias++;
> -			break;
> -		}
> +			if (i40e_cleanup_headers(rx_ring, skb, rx_desc))
> +				goto process_next;
>  
> -		i40e_put_rx_buffer(rx_ring, rx_buffer);
> -		cleaned_count++;
> +			/* probably a little skewed due to removing CRC */
> +			total_rx_bytes += skb->len;
>  
> -		i40e_inc_ntp(rx_ring);
> -		rx_ring->next_to_clean = rx_ring->next_to_process;
> -		if (i40e_is_non_eop(rx_ring, rx_desc))
> -			continue;
> +			/* populate checksum, VLAN, and protocol */
> +			i40e_process_skb_fields(rx_ring, rx_desc, skb);
>  
> -		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
> -			skb = NULL;
> -			continue;
> +			i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
> +			napi_gro_receive(&rx_ring->q_vector->napi, skb);
>  		}
>  
> -		/* probably a little skewed due to removing CRC */
> -		total_rx_bytes += skb->len;
> -
> -		/* populate checksum, VLAN, and protocol */
> -		i40e_process_skb_fields(rx_ring, rx_desc, skb);
> -
> -		i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
> -		napi_gro_receive(&rx_ring->q_vector->napi, skb);
> -		skb = NULL;
> -
>  		/* update budget accounting */
>  		total_rx_packets++;
> +process_next:
> +		cleaned_count += nfrags + 1;
> +		i40e_put_rx_buffer(rx_ring, rx_buffer);
> +		rx_ring->next_to_clean = rx_ring->next_to_process;
> +
> +		xdp->data = NULL;
>  	}
>  
>  	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
> -	rx_ring->skb = skb;
>  
>  	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> index e86abc25bb5e..14ad074639ab 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> @@ -393,14 +393,6 @@ struct i40e_ring {
>  
>  	struct rcu_head rcu;		/* to avoid race on free */
>  	u16 next_to_alloc;
> -	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq() must
> -					 * return before it sees the EOP for
> -					 * the current packet, we save that skb
> -					 * here and resume receiving this
> -					 * packet the next time
> -					 * i40e_clean_rx_ring_irq() is called
> -					 * for this ring.
> -					 */

this comment was valuable to me back when i was getting started with i40e,
so maybe we could have something equivalent around xdp_buff now?

>  
>  	struct i40e_channel *ch;
>  	u16 rx_offset;
> -- 
> 2.34.1
> 
