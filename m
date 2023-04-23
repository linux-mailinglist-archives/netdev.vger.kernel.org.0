Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD06EC076
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjDWOqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDWOqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:46:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E0E77;
        Sun, 23 Apr 2023 07:46:13 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso2673125b3a.2;
        Sun, 23 Apr 2023 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682261173; x=1684853173;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7SnPoFD3za4rwhlM2qxf5xphltNXOfgSLCqny9xzIU=;
        b=sVtFY/9syhTlTCGR2dtCDFX8VAYpI+CVfAox7WSRIm9j6Ar8zj6hb0yt6hxewzy7CG
         QBuxte569S2NINLOo/yP8YQh81EICibR5PHYk14H/Bz4ONXYhcEYXU2QmAm92yRSY7sJ
         OsediVyXbqqSGtWVIRc0s64zdao2Hv3pEOEwngSx5jKDrTpEdtKiSysddD1Ho7ZPV1Er
         k14llHCqo5EyPyjGovc5cYJXNuazDI45QXcEjd/mGLE8J6Zz4vO+oO78LCQtGdvPGat/
         L8W8x4+/xf9LcrySzzwkq58hYLcZWm271TkdYIPJssNibPxSmXFQKRSZK2MwED6KiRki
         dz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682261173; x=1684853173;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O7SnPoFD3za4rwhlM2qxf5xphltNXOfgSLCqny9xzIU=;
        b=eCpPypOyu+V0Vjm8NoQl+VLlMqPv8OVllx7Cw9WVOocyHz/BJFEYgFhD/5oL1HQX5C
         tu7SLoqp4J/yZSSN+4H+gsQijdPw0X6f3BV6Kl54pMe3vNA9gGtKXEJDIY1mI7DCn3rJ
         VcjOk/bxbdVGaSny8d1zf39nO5xJgRyyuCZOs/U8TKBejg3Wdw08y6kfNMtVp06gKKfE
         HSsv3d4KMHrDWSfg8Nf5wJqQ4UVK62Z+PPYCKvoxUVq0v+o2QzH9zoslJKdUmjErlcDH
         tRPR6BcWjHpGnHUfOmwWzJJi6/+RYucE15cS9IHFp19+1A6/BkObY1hztCkXHd8PNtkb
         5kAg==
X-Gm-Message-State: AAQBX9cj06SHiRTtvX6SMHQ1kX3DGtb5FeMfZfTIaU/lu/RgoJVHANq7
        OYKmZzKWPXaxtNWO9Qi/2HY=
X-Google-Smtp-Source: AKy350aSBzzoQCWcefxtSb/yUnhgCy6a8kAqBJ8ex4WwueTJPZxIgqpDVbfkSHrcWnK3eBkIJRvbng==
X-Received: by 2002:a17:902:c94c:b0:1a9:75a4:66c1 with SMTP id i12-20020a170902c94c00b001a975a466c1mr1024337pla.46.1682261172701;
        Sun, 23 Apr 2023 07:46:12 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:5905:623a:c41:59e1])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902eb4600b001a69c759af3sm5189929pli.35.2023.04.23.07.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 07:46:12 -0700 (PDT)
Date:   Sun, 23 Apr 2023 07:46:11 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, yoong.siang.song@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Message-ID: <644544b3206f0_19af02085e@john.notmuch>
In-Reply-To: <168182464270.616355.11391652654430626584.stgit@firesoul>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <168182464270.616355.11391652654430626584.stgit@firesoul>
Subject: RE: [PATCH bpf-next V2 1/5] igc: enable and fix RX hash usage by
 netstack
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
> hardware wasn't configured to provide RSS hash, thus it made sense to not
> enable net_device NETIF_F_RXHASH feature bit.
> 
> The NIC hardware was configured to enable RSS hash info in v5.2 via commit
> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
> forgot to set the NETIF_F_RXHASH feature bit.
> 
> The original implementation of igc_rx_hash() didn't extract the associated
> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
> this patch are about extracting the RSS Type from the hardware and mapping
> this to enum pkt_hash_types. This was based on Foxville i225 software user
> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).
> 
> For UDP it's worth noting that RSS (type) hashing have been disabled both for
> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
> because hardware RSS doesn't handle fragmented pkts well when enabled (can
> cause out-of-order). This results in PKT_HASH_TYPE_L3 for UDP packets, and
> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
> the effect that netstack will do a software based hash calc calling into
> flow_dissect, but only when code calls skb_get_hash(), which doesn't
> necessary happen for local delivery.
> 
> For QA verification testing I wrote a small bpftrace prog:
>  [0] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/monitor_skb_hash_on_dev.bt
> 
> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h      |   28 ++++++++++++++++++++++++++
>  drivers/net/ethernet/intel/igc/igc_main.c |   31 +++++++++++++++++++++++++----
>  2 files changed, 55 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
> index 34aebf00a512..f7f9e217e7b4 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -13,6 +13,7 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/timecounter.h>
>  #include <linux/net_tstamp.h>
> +#include <linux/bitfield.h>
>  
>  #include "igc_hw.h"
>  
> @@ -311,6 +312,33 @@ extern char igc_driver_name[];
>  #define IGC_MRQC_RSS_FIELD_IPV4_UDP	0x00400000
>  #define IGC_MRQC_RSS_FIELD_IPV6_UDP	0x00800000
>  
> +/* RX-desc Write-Back format RSS Type's */
> +enum igc_rss_type_num {
> +	IGC_RSS_TYPE_NO_HASH		= 0,
> +	IGC_RSS_TYPE_HASH_TCP_IPV4	= 1,
> +	IGC_RSS_TYPE_HASH_IPV4		= 2,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6	= 3,
> +	IGC_RSS_TYPE_HASH_IPV6_EX	= 4,
> +	IGC_RSS_TYPE_HASH_IPV6		= 5,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6_EX	= 6,
> +	IGC_RSS_TYPE_HASH_UDP_IPV4	= 7,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6	= 8,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6_EX	= 9,
> +	IGC_RSS_TYPE_MAX		= 10,
> +};
> +#define IGC_RSS_TYPE_MAX_TABLE		16
> +#define IGC_RSS_TYPE_MASK		GENMASK(3,0) /* 4-bits (3:0) = mask 0x0F */
> +
> +/* igc_rss_type - Rx descriptor RSS type field */
> +static inline u32 igc_rss_type(const union igc_adv_rx_desc *rx_desc)
> +{
> +	/* RSS Type 4-bits (3:0) number: 0-9 (above 9 is reserved)
> +	 * Accessing the same bits via u16 (wb.lower.lo_dword.hs_rss.pkt_info)
> +	 * is slightly slower than via u32 (wb.lower.lo_dword.data)
> +	 */
> +	return le32_get_bits(rx_desc->wb.lower.lo_dword.data, IGC_RSS_TYPE_MASK);
> +}
> +
>  /* Interrupt defines */
>  #define IGC_START_ITR			648 /* ~6000 ints/sec */
>  #define IGC_4K_ITR			980
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 1c4676882082..bfa9768d447f 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1690,14 +1690,36 @@ static void igc_rx_checksum(struct igc_ring *ring,
>  		   le32_to_cpu(rx_desc->wb.upper.status_error));
>  }
>  
> +/* Mapping HW RSS Type to enum pkt_hash_types */
> +static const enum pkt_hash_types igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
> +	[IGC_RSS_TYPE_NO_HASH]		= PKT_HASH_TYPE_L2,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV4]	= PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_IPV4]	= PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV6]	= PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_IPV6_EX]	= PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_IPV6]	= PKT_HASH_TYPE_L3,
> +	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX] = PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV4]	= PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV6]	= PKT_HASH_TYPE_L4,
> +	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX] = PKT_HASH_TYPE_L4,
> +	[10] = PKT_HASH_TYPE_NONE, /* RSS Type above 9 "Reserved" by HW  */
> +	[11] = PKT_HASH_TYPE_NONE, /* keep array sized for SW bit-mask   */
> +	[12] = PKT_HASH_TYPE_NONE, /* to handle future HW revisons       */
> +	[13] = PKT_HASH_TYPE_NONE,
> +	[14] = PKT_HASH_TYPE_NONE,
> +	[15] = PKT_HASH_TYPE_NONE,
> +};
> +
>  static inline void igc_rx_hash(struct igc_ring *ring,
>  			       union igc_adv_rx_desc *rx_desc,
>  			       struct sk_buff *skb)
>  {
> -	if (ring->netdev->features & NETIF_F_RXHASH)
> -		skb_set_hash(skb,
> -			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
> -			     PKT_HASH_TYPE_L3);
> +	if (ring->netdev->features & NETIF_F_RXHASH) {
> +		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
> +		u32 rss_type = igc_rss_type(rx_desc);
> +
> +		skb_set_hash(skb, rss_hash, igc_rss_type_table[rss_type]);

Just curious why not copy the logic from the other driver fms10k, ice, ect.

	skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
		     (IXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
		     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);

avoiding the table logic. Do the driver folks care?
