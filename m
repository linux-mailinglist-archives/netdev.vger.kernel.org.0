Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61D369228
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbhDWMcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242410AbhDWMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:32:49 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C3DC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:32:12 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h141so4657267iof.2
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qiNPM584FkcAWOXr3fMf7X5paY6VSGkTbcaBn012VKw=;
        b=L8kbNPqkg0QbJUO/hNhns7fuS8rhnaLPviTW7Z4VE7Z6fCvLv9gFRdahgojRUOzVpT
         ufzdBKA9/as8azpaQ1eZoUKi1qbX/3kGwYA8stCsTkHOa4u5AVpW+UjoSGdLQq5PO5wl
         xn8r/4rqgHwC1BSp9s8s2f29gup92uYJbrE/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qiNPM584FkcAWOXr3fMf7X5paY6VSGkTbcaBn012VKw=;
        b=hkupLk04xFrkTGu/j8FVkml9BeNcX/Kj+wOw6ZRsWV6JzgzArCV74j2dFDHJZo+AVj
         A7a4D7xcbkQsO2aRJTq0LwtOi/0KB4GoglXEktvxBlAU/ZXqD/V+t36C+AB6Ojad6eM8
         VMYXI4wehDR+CQZ7ktMpXiTEliq+lAjwx3w6AJptfFkl6zC1nhO1Dl8d/370GUx31Rxz
         3/E6IDavDsxKW6DovUGYHNfJFiDgvqhvSfOPikjcSGCblt5/46yaoCMq3ugx+FBGZrOH
         d2QDvkzCjl7qXhtmL05Uk00gWwUuP8SpCAdmX0DfO+jgZMNnC3HkpmRT22Jhc794c1VP
         CGCQ==
X-Gm-Message-State: AOAM533Jql/IOiC3+pQ8JgdGvb6TfyGJty81wIX+0RPCeUD/i53R4KHa
        GstKoHz3Ncunkzrp0fH8qZcjZyAGyQIwBg==
X-Google-Smtp-Source: ABdhPJzjF5lgjijnSXTPGCEuNAYOatVbu6NGEae6YqXG9sTzMFFSZ6L8FGTTCFs4ckjJ8scPay60HA==
X-Received: by 2002:a5d:9401:: with SMTP id v1mr3219900ion.101.1619181131935;
        Fri, 23 Apr 2021 05:32:11 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f18sm2539771ile.40.2021.04.23.05.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 05:32:11 -0700 (PDT)
Subject: Re: [PATCH net-next v4 3/3] net: ethernet: rmnet: Add support for
 MAPv5 egress packets
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1619121731-17782-1-git-send-email-sharathv@codeaurora.org>
 <1619121731-17782-4-git-send-email-sharathv@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <31bc24d6-0e4c-4538-b6f7-91e03af9707b@ieee.org>
Date:   Fri, 23 Apr 2021 07:32:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619121731-17782-4-git-send-email-sharathv@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 3:02 PM, Sharath Chandra Vurukala wrote:
> Adding Support for MAPv5 egress packets.
> Based on the configuration Request HW for csum offload
> by setting the csum_valid_required of Mapv5 packet.

Please try to re-word this description.  I'm not sure
I understand what it means.

I see what I think is a bug below.  Please either
fix or explain.

> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
> ---
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  4 +-
>   .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 12 ++-
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  8 +-
>   .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 93 ++++++++++++++++++++--
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |  3 +-
>   include/uapi/linux/if_link.h                       |  1 +
>   6 files changed, 107 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> index 8d8d469..8e64ca9 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> @@ -1,5 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0-only */
> -/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2013-2014, 2016-2018, 2021 The Linux Foundation.
> + * All rights reserved.
>    *
>    * RMNET Data configuration engine
>    */
> @@ -56,6 +57,7 @@ struct rmnet_priv_stats {
>   	u64 csum_fragmented_pkt;
>   	u64 csum_skipped;
>   	u64 csum_sw;
> +	u64 csum_hw;

Why is this new statistic type added?  Would it be
meaningful to use before--with only QMAPv4?  Or is
there something different about QMAPv5 (inline) checksum
offload that makes this necessary or desirable?

This is something new that ought to be at least
mentioned in the description at the top.  And for
future reference, this could likely have been
defined in a separate patch, before this one.

>   };
>   
>   struct rmnet_priv {
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 706a225..f8432e6 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -133,7 +133,7 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
>   				    struct rmnet_port *port, u8 mux_id,
>   				    struct net_device *orig_dev)
>   {
> -	int required_headroom, additional_header_len;
> +	int required_headroom, additional_header_len, csum_type = 0;
>   	struct rmnet_map_header *map_header;
>   
>   	additional_header_len = 0;
> @@ -142,6 +142,10 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
>   	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
>   		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
>   		required_headroom += additional_header_len;
> +		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +	} else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
> +		additional_header_len = sizeof(struct rmnet_map_v5_csum_header);

Does additional_header_len need to be added to required_headroom,
as it is for QMAPv4 above?

If so, this is a bug and must be fixed.

What I tested last week (and verified work for IPA v3.5.1 and
IPA v4.2) looked like this:

     if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
         additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
         csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
     } else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
         additional_header_len = sizeof(struct rmnet_map_v5_csum_header);
         csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
     }
     required_headroom += additional_header_len;

					-Alex

> +		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
>   	}
>   
>   	if (skb_headroom(skb) < required_headroom) {
> @@ -149,10 +153,10 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
>   			return -ENOMEM;
>   	}
>   
> -	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
> -		rmnet_map_checksum_uplink_packet(skb, orig_dev);
> +	if (csum_type)
> +		rmnet_map_checksum_uplink_packet(skb, port, orig_dev, csum_type);
>   
> -	map_header = rmnet_map_add_map_header(skb, additional_header_len, 0);
> +	map_header = rmnet_map_add_map_header(skb, additional_header_len, port, 0);
>   	if (!map_header)
>   		return -ENOMEM;
>   
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index 1a399bf..e5a0b38 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -43,11 +43,15 @@ enum rmnet_map_commands {
>   struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>   				      struct rmnet_port *port);
>   struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
> -						  int hdrlen, int pad);
> +						  int hdrlen,
> +						  struct rmnet_port *port,
> +						  int pad);
>   void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
>   int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
>   void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
> -				      struct net_device *orig_dev);
> +				      struct rmnet_port *port,
> +				      struct net_device *orig_dev,
> +				      int csum_type);
>   int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
>   
>   #endif /* _RMNET_MAP_H_ */
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index f427018..a8918d2 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -12,6 +12,7 @@
>   #include "rmnet_config.h"
>   #include "rmnet_map.h"
>   #include "rmnet_private.h"
> +#include <linux/bitfield.h>
>   
>   #define RMNET_MAP_DEAGGR_SPACING  64
>   #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
> @@ -251,12 +252,69 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>   }
>   #endif
>   
> +static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
> +						struct rmnet_port *port,
> +						struct net_device *orig_dev)
> +{
> +	struct rmnet_priv *priv = netdev_priv(orig_dev);
> +	struct rmnet_map_v5_csum_header *ul_header;
> +
> +	if (!(port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5))
> +		return;
> +
> +	ul_header = skb_push(skb, sizeof(*ul_header));
> +	memset(ul_header, 0, sizeof(*ul_header));
> +	ul_header->header_info = RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD <<
> +					MAPV5_HDRINFO_HDR_TYPE_SHIFT;
> +
> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		void *iph = (char *)ul_header + sizeof(*ul_header);
> +		__sum16 *check;
> +		void *trans;
> +		u8 proto;
> +
> +		if (skb->protocol == htons(ETH_P_IP)) {
> +			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
> +
> +			proto = ((struct iphdr *)iph)->protocol;
> +			trans = iph + ip_len;
> +		} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +			u16 ip_len = sizeof(struct ipv6hdr);
> +
> +			proto = ((struct ipv6hdr *)iph)->nexthdr;
> +			trans = iph + ip_len;
> +#else
> +			priv->stats.csum_err_invalid_ip_version++;
> +			goto sw_csum;
> +#endif /* CONFIG_IPV6 */
> +		} else {
> +			priv->stats.csum_err_invalid_ip_version++;
> +			goto sw_csum;
> +		}
> +
> +		check = rmnet_map_get_csum_field(proto, trans);
> +		if (check) {
> +			skb->ip_summed = CHECKSUM_NONE;
> +			/* Ask for checksum offloading */
> +			ul_header->csum_info |= MAPV5_CSUMINFO_VALID_FLAG;
> +			priv->stats.csum_hw++;
> +			return;
> +		}
> +	}
> +
> +sw_csum:
> +	priv->stats.csum_sw++;
> +}
> +
>   /* Adds MAP header to front of skb->data
>    * Padding is calculated and set appropriately in MAP header. Mux ID is
>    * initialized to 0.
>    */
>   struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
> -						  int hdrlen, int pad)
> +						  int hdrlen,
> +						  struct rmnet_port *port,
> +						  int pad)
>   {
>   	struct rmnet_map_header *map_header;
>   	u32 padding, map_datalen;
> @@ -267,6 +325,10 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
>   			skb_push(skb, sizeof(struct rmnet_map_header));
>   	memset(map_header, 0, sizeof(struct rmnet_map_header));
>   
> +	/* Set next_hdr bit for csum offload packets */
> +	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5)
> +		map_header->flags |= MAP_NEXT_HEADER_FLAG;
> +
>   	if (pad == RMNET_MAP_NO_PAD_BYTES) {
>   		map_header->pkt_len = htons(map_datalen);
>   		return map_header;
> @@ -394,11 +456,8 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
>   	return 0;
>   }
>   
> -/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
> - * packets that are supported for UL checksum offload.
> - */
> -void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
> -				      struct net_device *orig_dev)
> +static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
> +						struct net_device *orig_dev)
>   {
>   	struct rmnet_priv *priv = netdev_priv(orig_dev);
>   	struct rmnet_map_ul_csum_header *ul_header;
> @@ -417,10 +476,12 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>   
>   		if (skb->protocol == htons(ETH_P_IP)) {
>   			rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
> +			priv->stats.csum_hw++;
>   			return;
>   		} else if (skb->protocol == htons(ETH_P_IPV6)) {
>   #if IS_ENABLED(CONFIG_IPV6)
>   			rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
> +			priv->stats.csum_hw++;
>   			return;
>   #else
>   			priv->stats.csum_err_invalid_ip_version++;
> @@ -437,6 +498,26 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>   	priv->stats.csum_sw++;
>   }
>   
> +/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
> + * packets that are supported for UL checksum offload.
> + */
> +void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
> +				      struct rmnet_port *port,
> +				      struct net_device *orig_dev,
> +				      int csum_type)
> +{
> +	switch (csum_type) {
> +	case RMNET_FLAGS_EGRESS_MAP_CKSUMV4:
> +		rmnet_map_v4_checksum_uplink_packet(skb, orig_dev);
> +		break;
> +	case RMNET_FLAGS_EGRESS_MAP_CKSUMV5:
> +		rmnet_map_v5_checksum_uplink_packet(skb, port, orig_dev);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>   /* Process a MAPv5 packet header */
>   int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
>   				      u16 len)
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> index 41fbd2c..bc6d6ac 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> @@ -174,6 +174,7 @@ static const char rmnet_gstrings_stats[][ETH_GSTRING_LEN] = {
>   	"Checksum skipped on ip fragment",
>   	"Checksum skipped",
>   	"Checksum computed in software",
> +	"Checksum computed in hardware",
>   };
>   
>   static void rmnet_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
> @@ -354,4 +355,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
>   	}
>   
>   	return 0;
> -}
> \ No newline at end of file
> +}
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 21529b3..1691f3a 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1236,6 +1236,7 @@ enum {
>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
> +#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
>   
>   enum {
>   	IFLA_RMNET_UNSPEC,
> 

