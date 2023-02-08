Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AC68F34C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjBHQh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjBHQh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:37:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC10F3644A;
        Wed,  8 Feb 2023 08:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675874270; x=1707410270;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wIoSnxC2p3BYFWW7PceB8u5aQ9g54nSpO99w7rfe57g=;
  b=OxA0QfZK/ErhQzo6wwDerqxhcx8dPOpWCNtDV3DkiSoBFV1xZagdvdZY
   84glZpP29mMYsWUJXrALIH30vO/GtuJ/oAUPcGifjDFQfX4Hi3Ysap34X
   OXiAFo/zX/e7Uf9yM7xcVaxhaZ3DMQAQ4nLs6x7VQUIhLQQnLXn99a7Oc
   8//AZiq00NlDGtVAQ8eyz4roFWkbXIjK+y+9envMO098P81KaGQBahexV
   eKmFvrSVqdK3p031P6bkShHfmFUpYYvNcjOCpZq9zvGjRsLt9KQMCByOI
   4vL7uVrfEEDpXTNkiFm+yk/Me5UXUjXzYnrtHZXolCqibrhMJ/2UgfDXL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="310206215"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="310206215"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:37:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="736001381"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="736001381"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 08 Feb 2023 08:37:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:37:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:37:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 08:37:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 08:37:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3BgZ7WfZC4kjaeR6FwVmZSfr2SDcWUXRrliuUjGfGU5uwo11wxuzpyTIUz4BJNHcc2v/9Ao1/EZDGOZVplbkS+XBNzZ4eRgEJ3pPLZkZ1oHN5NMFY0td1xAcBYeLEbUT9GnNDa0q3/4KWQ5ixgk4aV7pifZ6AQwG6TpgZ79fSAqKb0QK0PKsSAucPns1uN7RoBPPYj4Rk3+qkIOLjVtbGteP4AgGpMENkGwwyytalf3RMT6YxQW9jm8tATcCyEVHWLsSmIf8hoXzW5RJU7it3CM6arKlqm85+J4PY4Y4f7FelknRA3B0PbxcyVJ0+lY6hypc4eob/W+JAet1ZZbmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2w0GTvELaCn4vOBtrlpPAQ6ltp7HPPZNQHxf8pUN5w=;
 b=hupScsqe27HSWQn3v/o8A0dvfqrSaZqmUtfinlfntIfREwm3YX+OYOgoOtHO2/PiOelQtXuFOQJDZ+ckPtOB1VOUP0J4qCWHwiE07fzK6XdyQlSgVCa7cMa3ad7GjS4qhWOaHZHUUFDMEQzxegxxd6w8lj7RptxP5LxLx7vGtx9rgEpyMIVWIZvKIOvno+NoGTysrkWksKCkGuQdYbCQivxTwOudJm1+ABppgTNXtcGLzbDEs9WcNGUOIH7PPnO/WiPtAL3S+707QJa0YGtOAlcXXNC2NlnSph5vpvo73PPObaW9vxkbovSM4gL0OzYAT1GDVNaD48ZFfTKaWZpIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 16:37:42 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 16:37:42 +0000
Date:   Wed, 8 Feb 2023 17:37:35 +0100
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
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <Y+PPzz4AHRxZgs9r@boxer>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206100837.451300-12-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P265CA0223.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|LV2PR11MB5998:EE_
X-MS-Office365-Filtering-Correlation-Id: c5191358-b9bb-4b27-1b89-08db09f2cc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qu0e0O+Bl5T3UIDggCAUoZGVEST72AeAzRY1I+K8uwwbKv77slaTEsqAWc28M+zUKNy/rbTnUqxYQDEO00g3TgHEs7vH7KoPW3tF2qH9d/yAoPvMhAFzdCQjWu/Me7fs3qGEGq8TylYisuzZFPdhK3K/w325JvTUQ+MEQezid0j/K58q5SlQ2XOovin+VyXbo1BHbV71yBw9mD5UyTX7CHNr8j1zjQzOf0XYWcVGRDxt5xwvVtmBIHSod4fcv0O1qXu68YkCPcX/NXBxQnDHmx0N3KLI2W8FcKqlbl92svB4GhbXhdfoPCYuki8qr+Tr1jtFcd24M0rWHlfnVpUpxrSpZBHIkAXK6dcSCtVqhrvOINJvV3M4ZZKl8ocwjnZoeOnp6ZHfSp7E575G3bd4aXD1kbi1NzlN36ynwbBHwnc5AhNcyo4KB0sKN14Fye9771mWh6RLRRnNY4XBTsrWUBCLYpa7oGaajbJs2YTeCvh3+4qh3I+O13cSJaJfZhXuAxe2GbhgApRHmZAi8E5PcFALEOGpkikBz4QuPcbdela7C52oQnxRtCb/RPGUOj4ZEsSwAvAXahDts93r7ZEC+fvN2GyhSZ8jkXxFmdFkBa/xXUhVPaUQcKKFYR3lTPj4H29oRPIM0pdMli3L0ccjZzrt/SfGUqxgi0v4r7RWCYD2THLAtjuceSqPF97tASIy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(82960400001)(38100700002)(8936002)(6512007)(186003)(7416002)(26005)(5660300002)(9686003)(6486002)(44832011)(41300700001)(6506007)(4326008)(316002)(6666004)(6916009)(8676002)(66946007)(66556008)(33716001)(478600001)(86362001)(66476007)(54906003)(2906002)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+TysF/EG656P3ticTNhnuQOe/hqjpqxwAXIo1Yc7Z7J3DK5gIZHGhyJJc0jO?=
 =?us-ascii?Q?IMbCarasWz6SyaVIFK6NjV7seJRaZi6WWmAiurNL3eeBkABua7I6bs4zAKwK?=
 =?us-ascii?Q?wXAPzgt5vn3jcoqOOCEoGQXprJGfsBwgCD+Yjz2gqWY3H2PCJq4bXPWNsyPe?=
 =?us-ascii?Q?43zt35KWY2WAoHyjZEKv8xyEA77TeHPnoMkm5cKPZrcEWcW0bF8oejJ6CGUl?=
 =?us-ascii?Q?0SmxHc2/uY8dD7SxqbD4jD5tb7pDIXQFrRA3njSj71Pt6X1UFJ4XwZTVzdII?=
 =?us-ascii?Q?QrPs91+ja/8LYZGl1nVzxE2BN2B93AhLWCqaoDsSzUJPRm05Ylf1ObsTGNTp?=
 =?us-ascii?Q?kcIJgLylYKdZqvIu5EOu4k2/FrFAlGVY/AIgYCyQeJea4c9nyu3jhBhU5aQD?=
 =?us-ascii?Q?V/b1jikA9LNpxhwlJ/H+HSyekyr/KInnU5op/avL89kSe5/fycdByhapEuu7?=
 =?us-ascii?Q?dJcs3YBZpIUhUPf5lh6D2ZM3IaCIZfna17yRr1/411ZECm8MuEh0Z3psYrCY?=
 =?us-ascii?Q?uzG0IPcH4c29hnxT5qkWgOqYqtZJMMe4Q8ssH34uEMfBRGAPrAWXLt0VZUa6?=
 =?us-ascii?Q?NWq8MvfIEWCCW7NrPfKIYlGcWanvoAZXkVj+AJ8pbJ0InkYbqz4WVEGxFWbz?=
 =?us-ascii?Q?MBnxEmcFyNvVV9dEBdAqQxarPLsR4JBx02gfzx+s8O0bstIshLyURld955sh?=
 =?us-ascii?Q?xeByZx+6+O3yoK3XTMuxa9/qr2T/XucKtmoEdZphWz5+w0Rw4DuhN/ZxoeYn?=
 =?us-ascii?Q?jGUY6qcR+zxuk40H/hjebMlUVugwSbw0gdejRKm+eP/MZRKbOy8+mrcgCaaT?=
 =?us-ascii?Q?oKpqOQw468ogvVP9WW//7wAU7pcY1woabJsmb0M4rbPFv+ITI9DrzwK+ewN8?=
 =?us-ascii?Q?im7BeSCxrlxsO7NMaI6teYpY/6+Xea9IpXPiAvnJj3lGStZNZU2ROy+I8Evb?=
 =?us-ascii?Q?Cgr5wbUddHiMX2nRg7Ts5tk5dAH6o1+MaAUAcFOjah/xdyZumgT/9JjjQkyT?=
 =?us-ascii?Q?gL3ime/A6rySqM7GITxxLBuv29xTDxX3RfhalUCfBKL6AIothcnB3qcH8ZTS?=
 =?us-ascii?Q?slQmQ8eHyAnu8vU/daMwiqagJqo+EHaN8vdEDLctMcZDCE8HQonQ8VKPW379?=
 =?us-ascii?Q?/EF4AC41TeAUvE5OiFF+GbVrKlQV+FALvY+t5htEkMKuSDdRi01HtP6qjhAO?=
 =?us-ascii?Q?HZEZ3PAX15NeBLIj0x5oUoqveU7ZRMQxbzLDx+vbV7z5crIh8QD22SIMfTxW?=
 =?us-ascii?Q?bM4EGJeEoIsXMliMHSO+3XWk1MXLShKL64DyQd2xemFygUo2fTPJPFPWnJ29?=
 =?us-ascii?Q?jO01ZlJG8IxywtPcuhtvm7Wz+LFF5OIvaYCkRgRuUr2R9U67JDamJndYmWQ3?=
 =?us-ascii?Q?5+0vugL18ddn7d46Ra6Cw/bKMS/gSZoBkLNeyi0dOVRCUq2bo9Bd8t466/hN?=
 =?us-ascii?Q?720p0Owtp5oNV1LZojHCWpEdhRuUvVoyLiMCg0KhxDq6lhEipbaO06+DFekR?=
 =?us-ascii?Q?APBR+J3Kf6CHMzzBsWmbuCtBHHJE6Pfgq+d7swJ7py2lsI1LqAZFgJ3YbRy8?=
 =?us-ascii?Q?VQKwAVGXKe0eXqlHD6lyLi8LOD7Om/KPG60vHng7HvT5j3ZWKC79gXqlFnBE?=
 =?us-ascii?Q?8EeZm85HHxQIVg/OjXg9T5U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5191358-b9bb-4b27-1b89-08db09f2cc92
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:37:42.4419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eviIeAFcXuiHjrCWtkZP/lG2wNJPJvUv3tyN6GG/QPbyNtgFflT8HtLdCekj5gc5RttsPaEA3Jik16yiWNiX+rDsZk6w9HEooG6JQ3TKH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 12:08:37PM +0200, Vladimir Oltean wrote:

Hey Vladimir,

> Schedule NAPI by hand from enetc_xsk_wakeup(), and send frames from the
> XSK TX queue from NAPI context. Add them to the completion queue from
> the enetc_clean_tx_ring() procedure which is common for all kinds of
> traffic.
> 
> We reuse one of the TX rings for XDP (XDP_TX/XDP_REDIRECT) for XSK as
> well. They are already cropped from the TX rings that the network stack
> can use when XDP is enabled (with or without AF_XDP).
> 
> As for XDP_REDIRECT calling enetc's ndo_xdp_xmit, I'm not sure if that
> can run simultaneously with enetc_poll() (on different CPUs, but towards
> the same TXQ). I guess it probably can, but idk what to do about it.
> The problem is that enetc_xdp_xmit() sends to
> priv->xdp_tx_ring[smp_processor_id()], while enetc_xsk_xmit() and XDP_TX
> send to priv->xdp_tx_ring[NAPI instance]. So when the NAPI instance runs

Why not use cpu id on the latter then?

> on a different CPU that the one it is numerically equal to, we should
> have a lock that serializes XDP_REDIRECT with the others.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 102 ++++++++++++++++++-
>  drivers/net/ethernet/freescale/enetc/enetc.h |   2 +
>  2 files changed, 99 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 3990c006c011..bc0db788afc7 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -84,7 +84,7 @@ static void enetc_free_tx_swbd(struct enetc_bdr *tx_ring,
>  	struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
>  	struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
>  
> -	if (tx_swbd->dma)
> +	if (!tx_swbd->is_xsk && tx_swbd->dma)
>  		enetc_unmap_tx_buff(tx_ring, tx_swbd);
>  
>  	if (xdp_frame) {
> @@ -817,7 +817,8 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
>  	rx_ring->xdp.xdp_tx_in_flight--;
>  }
>  
> -static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
> +static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget,
> +				int *xsk_confirmed)
>  {
>  	int tx_frm_cnt = 0, tx_byte_cnt = 0, tx_win_drop = 0;
>  	struct net_device *ndev = tx_ring->ndev;
> @@ -854,7 +855,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
>  				tx_win_drop++;
>  		}
>  
> -		if (tx_swbd->is_xdp_tx)
> +		if (tx_swbd->is_xsk)
> +			(*xsk_confirmed)++;
> +		else if (tx_swbd->is_xdp_tx)
>  			enetc_recycle_xdp_tx_buff(tx_ring, tx_swbd);
>  		else if (likely(tx_swbd->dma))
>  			enetc_unmap_tx_buff(tx_ring, tx_swbd);
> @@ -1465,6 +1468,58 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
>  }
>  EXPORT_SYMBOL_GPL(enetc_xdp_xmit);
>  
> +static void enetc_xsk_map_tx_desc(struct enetc_tx_swbd *tx_swbd,
> +				  const struct xdp_desc *xsk_desc,
> +				  struct xsk_buff_pool *pool)
> +{
> +	dma_addr_t dma;
> +
> +	dma = xsk_buff_raw_get_dma(pool, xsk_desc->addr);
> +	xsk_buff_raw_dma_sync_for_device(pool, dma, xsk_desc->len);
> +
> +	tx_swbd->dma = dma;
> +	tx_swbd->len = xsk_desc->len;
> +	tx_swbd->is_xsk = true;
> +	tx_swbd->is_eof = true;
> +}
> +
> +static bool enetc_xsk_xmit(struct net_device *ndev, struct xsk_buff_pool *pool,
> +			   u32 queue_id)
> +{
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	struct xdp_desc *xsk_descs = pool->tx_descs;
> +	struct enetc_tx_swbd tx_swbd = {0};
> +	struct enetc_bdr *tx_ring;
> +	u32 budget, batch;
> +	int i, k;
> +
> +	tx_ring = priv->xdp_tx_ring[queue_id];
> +
> +	/* Shouldn't race with anyone because we are running in the softirq
> +	 * of the only CPU that sends packets to this TX ring
> +	 */
> +	budget = min(enetc_bd_unused(tx_ring) - 1, ENETC_XSK_TX_BATCH);
> +
> +	batch = xsk_tx_peek_release_desc_batch(pool, budget);
> +	if (!batch)
> +		return true;
> +
> +	i = tx_ring->next_to_use;
> +
> +	for (k = 0; k < batch; k++) {
> +		enetc_xsk_map_tx_desc(&tx_swbd, &xsk_descs[k], pool);
> +		enetc_xdp_map_tx_buff(tx_ring, i, &tx_swbd, tx_swbd.len);
> +		enetc_bdr_idx_inc(tx_ring, &i);
> +	}
> +
> +	tx_ring->next_to_use = i;
> +
> +	xsk_tx_release(pool);

xsk_tx_release() is not needed if you're using
xsk_tx_peek_release_desc_batch() above, it will do this for you at the end
of its job.

> +	enetc_update_tx_ring_tail(tx_ring);
> +
> +	return budget != batch;
> +}
> +
>  static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  				     struct xdp_buff *xdp_buff, u16 size)
>  {
> @@ -1881,6 +1936,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
>  	struct enetc_bdr *rx_ring = &v->rx_ring;
>  	struct xsk_buff_pool *pool;
>  	struct bpf_prog *prog;
> +	int xsk_confirmed = 0;
>  	bool complete = true;
>  	int work_done;
>  	int i;
> @@ -1888,7 +1944,8 @@ static int enetc_poll(struct napi_struct *napi, int budget)
>  	enetc_lock_mdio();
>  
>  	for (i = 0; i < v->count_tx_rings; i++)
> -		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
> +		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget,
> +					 &xsk_confirmed))
>  			complete = false;
>  
>  	prog = rx_ring->xdp.prog;
> @@ -1901,6 +1958,17 @@ static int enetc_poll(struct napi_struct *napi, int budget)
>  	else
>  		work_done = enetc_clean_rx_ring(rx_ring, napi, budget);
>  
> +	if (pool) {
> +		if (xsk_confirmed)
> +			xsk_tx_completed(pool, xsk_confirmed);
> +
> +		if (xsk_uses_need_wakeup(pool))
> +			xsk_set_tx_need_wakeup(pool);
> +
> +		if (!enetc_xsk_xmit(rx_ring->ndev, pool, rx_ring->index))
> +			complete = false;
> +	}
> +
>  	if (work_done == budget)
>  		complete = false;
>  	if (work_done)
> @@ -3122,7 +3190,31 @@ static int enetc_setup_xsk_pool(struct net_device *ndev,
>  
>  int enetc_xsk_wakeup(struct net_device *ndev, u32 queue_id, u32 flags)
>  {
> -	/* xp_assign_dev() wants this; nothing needed for RX */
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	struct enetc_int_vector *v;
> +	struct enetc_bdr *rx_ring;
> +
> +	if (!netif_running(ndev) || !netif_carrier_ok(ndev))
> +		return -ENETDOWN;
> +
> +	if (queue_id >= priv->bdr_int_num)
> +		return -ERANGE;
> +
> +	v = priv->int_vector[queue_id];
> +	rx_ring = &v->rx_ring;
> +
> +	if (!rx_ring->xdp.xsk_pool || !rx_ring->xdp.prog)
> +		return -EINVAL;
> +
> +	/* No way to kick TX by triggering a hardirq right away =>
> +	 * raise softirq. This might schedule NAPI on a CPU different than the
> +	 * smp_affinity of its IRQ would suggest, but that would happen anyway
> +	 * if, say, we change that affinity under heavy traffic.
> +	 * So enetc_poll() has to be prepared for it anyway.
> +	 */
> +	if (!napi_if_scheduled_mark_missed(&v->napi))
> +		napi_schedule(&v->napi);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> index e1a746e37c9a..403f40473b52 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> @@ -36,6 +36,7 @@ struct enetc_tx_swbd {
>  	u8 is_eof:1;
>  	u8 is_xdp_tx:1;
>  	u8 is_xdp_redirect:1;
> +	u8 is_xsk:1;
>  	u8 qbv_en:1;
>  };
>  
> @@ -86,6 +87,7 @@ struct enetc_xdp_data {
>  #define ENETC_RX_RING_DEFAULT_SIZE	2048
>  #define ENETC_TX_RING_DEFAULT_SIZE	2048
>  #define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
> +#define ENETC_XSK_TX_BATCH		ENETC_DEFAULT_TX_WORK
>  
>  struct enetc_bdr_resource {
>  	/* Input arguments saved for teardown */
> -- 
> 2.34.1
> 
