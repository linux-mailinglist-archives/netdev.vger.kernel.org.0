Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D085369227
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhDWMcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbhDWMcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:32:46 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F325C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:32:09 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v123so41858297ioe.10
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zk2zVOOGa71YdOOhRGFSS1SSsG6eJwKRZ/kdw1pClyw=;
        b=J3WUdzqkjNsb8Neb0yrZ/ay4YX6UlvAV8J+ywNgE9oisrCaDYJcTs2ZkQsX8ArAeHS
         TPYFP+gAKKxgq4XcfOMugbnOfPDdqEhz5xqwDdelflCRs5WHYfNdmZuZjLQcUa/7zuu2
         qodjfWAK8gltlgmE9/V9NkjCvDcowBjfZLFcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zk2zVOOGa71YdOOhRGFSS1SSsG6eJwKRZ/kdw1pClyw=;
        b=OTHVRG/8cdu+SKAp1Lk9q7cQ1ZUc2xy+F7TgNlWV/Cqi+WCUBH0IhBdUNJiLr6eEJ9
         pbaAEIssK7aqeDYGqv4iIrw7GdkQEqrU1ID2k12Y9FgZJTPK2x8pJfme/ud98EhMQp0e
         08e4hRaXzhFNayRfEpvMhmr7OXpHsdOfrG0f4TZptxYyUSRuiymMZpEyQ3SrNm0Z2zAx
         pS1SdA8fFN7Zv0EaJ1Or9DtCONzc6OWKxu9nYTsTQsTQ/FjTmGKWAa8Y5OSiMbM5lTXj
         iMHFJX/+sVoaxBPPH+QNCkiN+I8w+inkgWjcxyHjJ97aV7qNbq74eFLDmmK02jsZ1NcF
         OtMA==
X-Gm-Message-State: AOAM532ri/aPlkTwppE7SKB38A/ZHzHp2aNNcEQbauIQIoQZkoHAgEFG
        llMAxdKDJRYjpKXGSrKaEMHleQ==
X-Google-Smtp-Source: ABdhPJzomJFhQN/gGQ1PBfbHLjxowzDMAIKPiPgNmZYT1uAZ1nSyfQ5cYUl5SdVQ0HEVUIWWRHjhwg==
X-Received: by 2002:a02:1c81:: with SMTP id c123mr3511383jac.42.1619181128530;
        Fri, 23 Apr 2021 05:32:08 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id x5sm2545571ilj.67.2021.04.23.05.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 05:32:07 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] net: ethernet: rmnet: Support for ingress
 MAPv5 checksum offload
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1619121731-17782-1-git-send-email-sharathv@codeaurora.org>
 <1619121731-17782-3-git-send-email-sharathv@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <6961baad-c64d-22e5-4425-adb33b9b6236@ieee.org>
Date:   Fri, 23 Apr 2021 07:32:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619121731-17782-3-git-send-email-sharathv@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 3:02 PM, Sharath Chandra Vurukala wrote:
> Adding support for processing of MAPv5 downlink packets.
> It involves parsing the Mapv5 packet and checking the csum header
> to know whether the hardware has validated the checksum and is
> valid or not.
> 
> Based on the checksum valid bit the corresponding stats are
> incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
> or left as CHEKSUM_NONE to let network stack revalidate the checksum
> and update the respective snmp stats.
> 
> Current MAPV1 header has been modified, the reserved field in the
> Mapv1 header is now used for next header indication.
> 
> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>

I have a few minor things I recommend you fix.

I don't see any bugs, but I'm not going to offer
"Reviewed-by" until you've had a chance to either
update your patch or explain why you won't.

> ---
>   .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 17 ++++---
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  3 +-
>   .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 58 +++++++++++++++++++++-
>   include/linux/if_rmnet.h                           | 27 +++++++++-
>   include/uapi/linux/if_link.h                       |  1 +
>   5 files changed, 97 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 0be5ac7..706a225 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -1,5 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0-only
> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
>    *
>    * RMNET Data ingress/egress handler
>    */
> @@ -82,11 +82,16 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
>   
>   	skb->dev = ep->egress_dev;
>   
> -	/* Subtract MAP header */
> -	skb_pull(skb, sizeof(struct rmnet_map_header));
> -	rmnet_set_skb_proto(skb);
> -
> -	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
> +	if ((port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) &&
> +	    (map_header->flags & MAP_NEXT_HEADER_FLAG)) {
> +		if (rmnet_map_process_next_hdr_packet(skb, len))
> +			goto free_skb;
> +		skb_pull(skb, sizeof(*map_header));
> +		rmnet_set_skb_proto(skb);
> +	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
> +		/* Subtract MAP header */
> +		skb_pull(skb, sizeof(*map_header));
> +		rmnet_set_skb_proto(skb);
>   		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
>   			skb->ip_summed = CHECKSUM_UNNECESSARY;
>   	}
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index 2aea153..1a399bf 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -1,5 +1,5 @@
>   /* SPDX-License-Identifier: GPL-2.0-only */
> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
>    */
>   
>   #ifndef _RMNET_MAP_H_
> @@ -48,5 +48,6 @@ void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
>   int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
>   void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>   				      struct net_device *orig_dev);
> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
>   
>   #endif /* _RMNET_MAP_H_ */
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 0ac2ff8..f427018 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -1,5 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0-only
> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
>    *
>    * RMNET Data MAP protocol
>    */
> @@ -8,6 +8,7 @@
>   #include <linux/ip.h>
>   #include <linux/ipv6.h>
>   #include <net/ip6_checksum.h>
> +#include <linux/bitfield.h>
>   #include "rmnet_config.h"
>   #include "rmnet_map.h"
>   #include "rmnet_private.h"
> @@ -300,8 +301,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
>   struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>   				      struct rmnet_port *port)
>   {
> +	struct rmnet_map_v5_csum_header *next_hdr = NULL;
> +	unsigned char *data = skb->data;

If you define the data variable to have (void *) type you can
get rid of some casts below, and it won't need to use a cast
when assigned here either.

>   	struct rmnet_map_header *maph;
>   	struct sk_buff *skbn;
> +	u8 nexthdr_type;
>   	u32 packet_len;
>   
>   	if (skb->len == 0)
> @@ -312,6 +316,17 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>   
>   	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
>   		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
This block should be surrounded by curly braces.  If one block
in an if statement (or chain of them) has them, they all should.

> +	else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
> +		if (!(maph->flags & MAP_CMD_FLAG)) {
> +			packet_len += sizeof(struct rmnet_map_v5_csum_header);

		packet_len += sizeof(*next_hdr);

> +			if (maph->flags & MAP_NEXT_HEADER_FLAG)
> +				next_hdr = (struct rmnet_map_v5_csum_header *)
> +						(data + sizeof(*maph));


If data is a void pointer, this could be:
				next_hdr = data + sizeof(*maph);

> +			else
> +				/* Mapv5 data pkt without csum hdr is invalid */
> +				return NULL;
> +		}
> +	}
>   
>   	if (((int)skb->len - (int)packet_len) < 0)
>   		return NULL;
> @@ -320,6 +335,13 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>   	if (!maph->pkt_len)
>   		return NULL;
>   
> +	if (next_hdr) {
> +		nexthdr_type = u8_get_bits(next_hdr->header_info,
> +				MAPV5_HDRINFO_HDR_TYPE_FMASK);

Consider fixing the alignment of the second argument
above.

> +		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
> +			return NULL;
> +	}
> +
>   	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
>   	if (!skbn)
>   		return NULL;
> @@ -414,3 +436,37 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>   
>   	priv->stats.csum_sw++;
>   }
> +
> +/* Process a MAPv5 packet header */
> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
> +				      u16 len)
> +{
> +	struct rmnet_priv *priv = netdev_priv(skb->dev);
> +	struct rmnet_map_v5_csum_header *next_hdr;
> +	u8 nexthdr_type;
> +	int rc = 0;
> +
> +	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
> +			sizeof(struct rmnet_map_header));
> +
> +	nexthdr_type = u8_get_bits(next_hdr->header_info,
> +			MAPV5_HDRINFO_HDR_TYPE_FMASK);

The arguments in the above two assignments don't look
aligned very well.  Maybe it's just the way my mail
program is displaying it.

> +
> +	if (nexthdr_type == RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD) {
> +		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
> +			priv->stats.csum_sw++;
> +		} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
> +			priv->stats.csum_ok++;
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> +		} else {
> +			priv->stats.csum_valid_unset++;
> +		}
> +
> +		/* Pull csum v5 header */
> +		skb_pull(skb, sizeof(struct rmnet_map_v5_csum_header));

		skb_pull(skb, sizeof(*next_hdr);

> +	} else
> +		return -EINVAL;

Please add curly braces here too.

> +
> +	return rc;
> +}
> +
> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 4efb537..f82e37e 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -1,5 +1,5 @@
>   /* SPDX-License-Identifier: GPL-2.0-only
> - * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
>    */
>   
>   #ifndef _LINUX_IF_RMNET_H_
> @@ -14,8 +14,10 @@ struct rmnet_map_header {
>   /* rmnet_map_header flags field:
>    *  PAD_LEN:	number of pad bytes following packet data
>    *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
> + *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM header
>    */
>   #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
> +#define MAP_NEXT_HEADER_FLAG		BIT(6)
>   #define MAP_CMD_FLAG			BIT(7)
>   
>   struct rmnet_map_dl_csum_trailer {
> @@ -45,4 +47,27 @@ struct rmnet_map_ul_csum_header {
>   #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
>   #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
>   
> +/* MAP CSUM headers */
> +struct rmnet_map_v5_csum_header {
> +	u8 header_info;
> +	u8 csum_info;
> +	__be16 reserved;
> +} __aligned(1);
> +
> +/* v5 header_info field
> + * NEXT_HEADER:  Represents whether there is any other header
> + * HEADER TYPE: represents the type of this header
> + *
> + * csum_info field
> + * CSUM_VALID_OR_REQ:
> + * 1 = for UL, checksum computation is requested.
> + * 1 = for DL, validated the checksum and has found it valid
> + */
> +
> +#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
> +#define MAPV5_HDRINFO_HDR_TYPE_SHIFT	1
> +#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, MAPV5_HDRINFO_HDR_TYPE_SHIFT)

This is the only place you use MAPV5_HDRINFO_TYPE_SHIFT.
Defining and using it here immediately after its definition
subtracts, rather than adds value.  Just do:

#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, 1)

					-Alex

> +#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
> +
> +#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
>   #endif /* !(_LINUX_IF_RMNET_H_) */
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 91c8dda..21529b3 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1235,6 +1235,7 @@ enum {
>   #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> +#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
>   
>   enum {
>   	IFLA_RMNET_UNSPEC,
> 

