Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB4E6955B5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBNBD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNBDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:03:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC2E1632D
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 17:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676336633; x=1707872633;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RMY3cB+stcK3DMT+4N+oTUxMo9a4P57tv+EAGpoP+HI=;
  b=fyjEfupAL+VKWQ7hDZGp+LQlZt4OEeubARCP4Pa4kuLaPeVsjTHiEmvY
   j79/I6L7D0SdjxMIe6l4hTqgFVM9Ab4ZVSC4ICHeLgSQApwDI6yOenTuF
   NiJWVk1nN0d7wVcZN7BFTFhoknGungl2kNSq6HyatWTyqygwzcS8WIfrD
   bSaRW2XWDSzpil5mchoaUfa6bhzjNnLmRLlM1E/b+Wbw0Oz0MyaMfIDjw
   gr80+8dWmEEcSXdz9/tho0tkpGuM7hJy0QUH1nr8AcUMygX61JWDwwjvH
   58myAHAZi0L1B5Vk5oG+D/ohhlgG8UHqll9mtgvuQsodjWnbM/uwopAzV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417262633"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="417262633"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 17:03:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="914544718"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="914544718"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2023 17:03:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 17:03:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 17:03:51 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 17:03:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTApwrzXGl6bHLB+VMSlNs+CfKK5ISjuA30FsReuOcPAjVJSYngb/m39acpD1Gw5KcpbyG6d4ijH/ptoYjFdElOSaXY6VizDcVGmlKbCLmj3JG92lmN0O8VIqmp0F3shkNeIH8j5hQOaluiFJjWSmCXYkttA32PTwRn4un+SOicB7/n1HVFruHMhLzKXJDozHxvUyE8Dkb2irgjbCJOqYgkLSJrb6GNlCRFJRK3O2AtNcuOo3CBzB6HOd/rl233FM6uGHxr+Jtay3WtWX7ZWXJ8OvHoCKAIa03y8fdl9tmYs50/YPKS6j6uBskoeRlAGtgvUo2Qb25xWmdNifFX6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0AdiKYXPzECQY51JhoSybU5eq0DF/nxZeT8w5K+B50=;
 b=BJeL/3yGQUe4TJqAPvpBP9dS+BUmJVowAbgX2eh3/Fx4aEE6cxv2p/QBE2T6KZyCCMFVIqfPs/8LIfapjH/cnUgJJqbefdM48kHfsSqLdoAH2Hb3ERfg/EJqXk1Neh54QJ1VT4uZzShyG07FEoq7RsDR/sh5l22selcqHmBhT6I2kWiN43NLkZT1UweSbaA0jbclrnxwq4moWfmPC5Zvho/UrFGVTJ9igYkapsrH/Tyo8+3WOrFvRywo08S1Uh5ld3iV541nKxJvny7vxV7LFULAa4y/cZsElczCwul3PpBmF2BzuY90ubl6K1HkzgmXYakdwyHAJn5O16WqKUuNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB6196.namprd11.prod.outlook.com (2603:10b6:208:3e8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 01:03:49 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 01:03:48 +0000
Date:   Tue, 14 Feb 2023 02:03:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Jeroen de Borst" <jeroendb@google.com>
Subject: Re: [PATCH net-next 3/4] gve: Add XDP REDIRECT support for GQI-QPL
 format
Message-ID: <Y+rd5ljmJuNPDwv1@boxer>
References: <20230207210058.2257219-1-pkaligineedi@google.com>
 <20230207210058.2257219-4-pkaligineedi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230207210058.2257219-4-pkaligineedi@google.com>
X-ClientProxiedBy: LO6P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f46951-1494-4f3d-aaf2-08db0e27547d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBpWZDr/kPVqC10T+NI1T32nDML6/clJCI1v+DnKt1ObAMXiDhx4WeZ65gDD+hVXjkQvROUEgGPjlWyF1vaFNmZeY4WDzH3lJt1qDihyc+QrUTw3X2EKtB2Do9zxuVIgUcO8WhqKCUj+78swnHen/sgnDqfNTPBMQ0/I2rhHyCpcYyKsZ+q5I6QSQoVDGqGB0C77BNo+GJZifXNAZYKrJ+eAePRgN3x1Yp4PccfbYUBzmDczjqfxsi2bXIxL3S6oNefylZXpZY1Pi/JIdJQBZV1KcOQ1ZWB/0ynxNALild3FV4+l1tetIfMX5PpyGBXNOlbEWY3cy2VTVjZDst+47tYYGg20ApTMuxUB+66Esal8ENtrF2syqmgkK/5QjdJ5qcbLERNdDUzUm/vHU40p1sLvz46wFz5Ztm/aOG0iDfl1jdOw//jaCmB4RKdEz07fBojJGf5r0LelhOAnd/WcObgRAQuKLxa6grm+LXEQ09hgIWSJduoiEDZE6t7MYeRpddMhurCuUn49L4tLsWB5ggfR7I1PPF2J/9KeygYuOuj8mOT2K7dEGWURTCTgKppSK8HjBDR+3XfghrH6hb55apCmHggUg6RZf4OeDZpnM05A5hSIOw+fuB0FgJ872jf5fDlDvjrMHgyyV7F17zSR1GzvidqdyEeAmsQwoK80ZCu1wpNT1gXhMcALTsimVGra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199018)(83380400001)(66476007)(66556008)(66946007)(8676002)(6916009)(4326008)(38100700002)(33716001)(82960400001)(6486002)(41300700001)(6506007)(6666004)(316002)(6512007)(9686003)(5660300002)(478600001)(186003)(86362001)(26005)(44832011)(2906002)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHYEZSP5foNLvv9tJYTaRGhhrYnuT0JFB2HPw484lEjNDx8/AR7lC+gRIemQ?=
 =?us-ascii?Q?L26uHdMut1csDHBBft899tha+sicSuizc31MOe7pU/zyjgfH8SyMzp5paLRl?=
 =?us-ascii?Q?OSdLZ+lGIffZOFusKBCnMVKOLwJ5gzTlTSIrDo0RUv+8yd+ZRQKXIdmnjM3+?=
 =?us-ascii?Q?tawt2Rf8CVJ0+9GE67Dv0EN9i9tA1qn6Wzq8xoQ/EhSP+woT4WMUh1fAwQFB?=
 =?us-ascii?Q?VPnmdSUxZErHe1cFsSbmKyKKlCHRY/8sVYRBWxWR/uOal+E0SNX32+GrY7Ob?=
 =?us-ascii?Q?uRftvwSOuSavh9Cu1lWRPd3LExcmRMvEAtW0B+liljV4C8RnC8kYloznbyU+?=
 =?us-ascii?Q?Y9RaLfG/QIF3g7hZfwtb2WqHtyRQMsn8llSj7nuUAy+bgaYA271Y24JtZPA+?=
 =?us-ascii?Q?6sUqKiKyc6m94+rnafPRUM456+SO2X/Qxk7AyYBCcjFeEBzZURiyBJLFQPMo?=
 =?us-ascii?Q?UTo0I3U96j9g4GdrfMTswKCupFaavkX8ASOuIgzMu3WbTbdjD6r7VwLt8evD?=
 =?us-ascii?Q?e9LhSTOl8G4wGlhAGIt0lEpqMioCySMOBVUn7M49oFVxdzGS8+QB+T5bwLvC?=
 =?us-ascii?Q?13OT8pXhtB/g94hgGQ14UN7hU+fO1V9iRhRMzMpxL1emvpupC/DYWsQJEysc?=
 =?us-ascii?Q?Jor/w2lFdi4EBjn5oQnS2IIyem/RAEpqV4QE0lBWzbD5on8MzvM9e9aA62sX?=
 =?us-ascii?Q?+3y0uboeFYswS/lq7gavp9PrGiLzFGdRcDeBNjivLGMK+bp2BXYtky61d5IQ?=
 =?us-ascii?Q?q8hZ8C7TBlisxnsW8UzLHlxQD6fgNzR8q4wfr+oJexUipYfjdyMFyg3pU3iO?=
 =?us-ascii?Q?RO4ADM5LHcgo08si0MRd5tnGTIPjehI9+Xjq+FHk38I3wgPKJh9cAefRBfgO?=
 =?us-ascii?Q?tSEF+7Q2Z/YMZHCoLEYBYpQI8MXuszoSGsC8TzZCvD1fvw/zIrT93Qm1TvfM?=
 =?us-ascii?Q?8Y8bqxEqsaDoYq67N/QjH/FZa0Gg1HJNAvcgifoHBcrkQ5+FJLUwHRlEhbSz?=
 =?us-ascii?Q?Vd5KOcrUqDuNfoPwuKRQIwlWX1Ri1BCLnYlafJdicD7kOPm99RlCyol7K3NJ?=
 =?us-ascii?Q?7IRd+w+s09sP3UoTLIJp5rbJ2aeSxOTk+/wK0JK9v2QDbbopNBd6UrwZx6bX?=
 =?us-ascii?Q?Yl4DfjjMsoTIdwYxluUahUqGx+qO5KW1v9iUlUYTReMjcNJnUDoTCc4h5JSY?=
 =?us-ascii?Q?iSJ+P/Dw6htUqQmH8n2a7ZgAtdaR+ZEnPlQTq2oE6R/B0dD4EDjqfvd5EI9P?=
 =?us-ascii?Q?qYNwVIenI2ACGgy+Im4YQSurE53kXywg1Fv/Uqv166RUmgI5gGgLUOhsxtcA?=
 =?us-ascii?Q?8KuYOG2cCEhpbeWIBR4OsLtpnxvBNmIH8ZWPAbyJDKEryQQpNwM/vsU4ADuz?=
 =?us-ascii?Q?8mOpnA5c4Pa6vH5MJMXTL5nYJh4qRTTLdcpQ80lNtMPQ2eK13uWa1/jQyiuF?=
 =?us-ascii?Q?T7ua04xsLKmbpojTwOAW0GyfkqYMICD7/NIHTGSQFfsbwkcH9mqKVgKk0k9M?=
 =?us-ascii?Q?1jj4zjhjNSvaBdySePK+jxwpT3iNavRWHR6fvRrHy9+Jn09pdl3mlOWXmitP?=
 =?us-ascii?Q?2xnuimNYtvWn32K8JvXXyo1tcETQHO5m71UyqO2NrpVD/CW3lDLzVfTf1JNE?=
 =?us-ascii?Q?/dRd0faP8APu3ioOgQ5gfoo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f46951-1494-4f3d-aaf2-08db0e27547d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 01:03:48.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Neght82QxGwDfK+KTi37SFtv8nEz4Afm8FWVfmrXR6w/7T4CUfqKZ2ECaD3rXe58JQVj3Fkf7HuiTP81LCGENLT4gRbjAFEfwmUdowIjJUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6196
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 01:00:57PM -0800, Praveen Kaligineedi wrote:
> Add support for XDP REDIRECT action.
> 
> This patch contains the following changes:
> 1) Support for XDP REDIRECT action on rx
> 2) ndo_xdp_xmit callback support
> 
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> Reviewed-by: Jeroen de Borst <jeroendb@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h         | 13 ++++-
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 26 ++++++----
>  drivers/net/ethernet/google/gve/gve_main.c    | 17 +++++++
>  drivers/net/ethernet/google/gve/gve_rx.c      | 45 +++++++++++++++--
>  drivers/net/ethernet/google/gve/gve_tx.c      | 48 +++++++++++++++++--
>  5 files changed, 132 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 8352f4c0e8d1..f89b1278db70 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -236,6 +236,7 @@ struct gve_rx_ring {
>  	u64 rx_frag_alloc_cnt; /* free-running count of rx page allocations */
>  	u64 xdp_tx_errors;
>  	u64 xdp_redirect_errors;
> +	u64 xdp_alloc_fails;
>  	u64 xdp_actions[GVE_XDP_ACTIONS];
>  	u32 q_num; /* queue index */
>  	u32 ntfy_id; /* notification block index */
> @@ -247,6 +248,7 @@ struct gve_rx_ring {
>  
>  	/* XDP stuff */
>  	struct xdp_rxq_info xdp_rxq;
> +	struct page_frag_cache page_cache;

few words about why you need that would be helpful

>  };
>  
>  /* A TX desc ring entry */
> @@ -267,7 +269,10 @@ struct gve_tx_iovec {
>   * ring entry but only used for a pkt_desc not a seg_desc
>   */
>  struct gve_tx_buffer_state {
> -	struct sk_buff *skb; /* skb for this pkt */
> +	union {
> +		struct sk_buff *skb; /* skb for this pkt */
> +		struct xdp_frame *xdp_frame; /* xdp_frame */
> +	};
>  	struct {
>  		u16 size; /* size of xmitted xdp pkt */
>  	} xdp;
> @@ -464,6 +469,8 @@ struct gve_tx_ring {
>  	dma_addr_t q_resources_bus; /* dma address of the queue resources */
>  	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
>  	struct u64_stats_sync statss; /* sync stats for 32bit archs */
> +	u64 xdp_xmit;
> +	u64 xdp_xmit_errors;
>  } ____cacheline_aligned;
>  
>  /* Wraps the info for one irq including the napi struct and the queues
> @@ -889,8 +896,10 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
>  		   enum dma_data_direction);
>  /* tx handling */
>  netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
> +int gve_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
> +		 u32 flags);
>  int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
> -		     void *data, int len, u32 flags);
> +		     void *data, int len, void *frame_p, u32 flags);
>  bool gve_tx_poll(struct gve_notify_block *block, int budget);
>  bool gve_xdp_poll(struct gve_notify_block *block, int budget);
>  int gve_tx_alloc_rings(struct gve_priv *priv);
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index d2f0b53eacbb..57940f90c6be 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -56,13 +56,14 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
>  	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
>  	"rx_xdp_aborted[%u]", "rx_xdp_drop[%u]", "rx_xdp_pass[%u]",
>  	"rx_xdp_tx[%u]", "rx_xdp_redirect[%u]",
> -	"rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]",
> +	"rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]", "rx_xdp_alloc_fails[%u]",
>  };
>  
>  static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
>  	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_consumed_desc[%u]", "tx_bytes[%u]",
>  	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
>  	"tx_dma_mapping_error[%u]",
> +	"tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
>  };
>  
>  static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
> @@ -312,9 +313,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  					data[i + j] = rx->xdp_actions[j];
>  				data[i + j++] = rx->xdp_tx_errors;
>  				data[i + j++] = rx->xdp_redirect_errors;
> +				data[i + j++] = rx->xdp_alloc_fails;
>  			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
>  						       start));
> -			i += GVE_XDP_ACTIONS + 2; /* XDP rx counters */
> +			i += GVE_XDP_ACTIONS + 3; /* XDP rx counters */
>  		}
>  	} else {
>  		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
> @@ -370,13 +372,21 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  			if (skip_nic_stats) {
>  				/* skip NIC tx stats */
>  				i += NIC_TX_STATS_REPORT_NUM;
> -				continue;
> -			}
> -			for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
> -				u64 value =
> -				be64_to_cpu(report_stats[tx_qid_to_stats_idx[ring] + j].value);
> -				data[i++] = value;
> +			} else {
> +				stats_idx = tx_qid_to_stats_idx[ring];
> +				for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
> +					u64 value =
> +						be64_to_cpu(report_stats[stats_idx + j].value);
> +					data[i++] = value;
> +				}
>  			}
> +			do {
> +				start = u64_stats_fetch_begin(&priv->tx[ring].statss);
> +				data[i] = tx->xdp_xmit;
> +				data[i + 1] = tx->xdp_xmit_errors;
> +			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
> +						       start));
> +			i += 2; /* XDP tx counters */
>  		}
>  	} else {
>  		i += num_tx_queues * NUM_GVE_TX_CNTS;
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 5050aa3aa1c3..4398e5887f3b 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -1015,6 +1015,21 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
>  	}
>  }
>  
> +static void gve_drain_page_cache(struct gve_priv *priv)
> +{
> +	struct page_frag_cache *nc;
> +	int i;
> +
> +	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
> +		nc = &priv->rx[i].page_cache;
> +		if (nc->va) {
> +			__page_frag_cache_drain(virt_to_page(nc->va),
> +						nc->pagecnt_bias);
> +			nc->va = NULL;
> +		}
> +	}
> +}
> +
>  static int gve_open(struct net_device *dev)
>  {
>  	struct gve_priv *priv = netdev_priv(dev);
> @@ -1098,6 +1113,7 @@ static int gve_close(struct net_device *dev)
>  	netif_carrier_off(dev);
>  	if (gve_get_device_rings_ok(priv)) {
>  		gve_turndown(priv);
> +		gve_drain_page_cache(priv);
>  		err = gve_destroy_rings(priv);
>  		if (err)
>  			goto err;
> @@ -1409,6 +1425,7 @@ static const struct net_device_ops gve_netdev_ops = {
>  	.ndo_tx_timeout         =       gve_tx_timeout,
>  	.ndo_set_features	=	gve_set_features,
>  	.ndo_bpf		=	gve_xdp,
> +	.ndo_xdp_xmit		=	gve_xdp_xmit,
>  };
>  
>  static void gve_handle_status(struct gve_priv *priv, u32 status)
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 3785bc150546..ea833388f895 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -593,6 +593,35 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
>  	return skb;
>  }
>  
> +static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
> +			    struct xdp_buff *orig, struct bpf_prog *xdp_prog)
> +{
> +	int total_len, len = orig->data_end - orig->data;
> +	int headroom = XDP_PACKET_HEADROOM;
> +	struct xdp_buff new;
> +	void *frame;
> +	int err;
> +
> +	total_len = headroom + SKB_DATA_ALIGN(len) +
> +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
> +	if (!frame) {
> +		u64_stats_update_begin(&rx->statss);
> +		rx->xdp_alloc_fails++;
> +		u64_stats_update_end(&rx->statss);
> +		return -ENOMEM;
> +	}
> +	xdp_init_buff(&new, total_len, &rx->xdp_rxq);
> +	xdp_prepare_buff(&new, frame, headroom, len, false);
> +	memcpy(new.data, orig->data, len);

can you explain why?

> +
> +	err = xdp_do_redirect(dev, &new, xdp_prog);
> +	if (err)
> +		page_frag_free(frame);
> +
> +	return err;
> +}
> +

(...)
