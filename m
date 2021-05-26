Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FFF391A22
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhEZO3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:29:52 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39139 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234572AbhEZO3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 10:29:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622039299; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hZRLPobXp8gBnCBGqmvdOiloFOGnp/H1h+3cbGxrgUY=;
 b=oZEOSk56460NgQRDYV1xlkmPdeQoZVS9CZpGGdAJQnoi/yLhCMxeXmitZFyq0kD9JwM1wVQp
 TzZRsFi7EVmedSmvGWss1oL7llQMfAZh7g2AlaDR8PsvkEVmY64Qyfqdxq5nyiC5JHNxv++K
 KAuMEfJ6Aiu2x4kFF7samckQKNY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60ae5b01c229adfeffe26a5e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 26 May 2021 14:28:17
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A9621C4360C; Wed, 26 May 2021 14:28:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12FC6C4338A;
        Wed, 26 May 2021 14:28:16 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 May 2021 19:58:15 +0530
From:   sharathv@codeaurora.org
To:     Alex Elder <elder@ieee.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/3] net: ethernet: rmnet: Support for ingress
 MAPv5 checksum offload
In-Reply-To: <cfbc5a5e-9b28-f9d3-f1ba-06c0ce0a7ca7@ieee.org>
References:  <stranche@codeaurora.org linux-doc@vger.kernel.org
 corbet@lwn.net> <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
 <1619180343-3943-3-git-send-email-sharathv@codeaurora.org>
 <cfbc5a5e-9b28-f9d3-f1ba-06c0ce0a7ca7@ieee.org>
Message-ID: <9bdefa9d45d24547590bcc7bd77d09da@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-23 18:18, Alex Elder wrote:
> On 4/23/21 7:19 AM, Sharath Chandra Vurukala wrote:
>> Adding support for processing of MAPv5 downlink packets.
>> It involves parsing the Mapv5 packet and checking the csum header
>> to know whether the hardware has validated the checksum and is
>> valid or not.
>> 
>> Based on the checksum valid bit the corresponding stats are
>> incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
>> or left as CHEKSUM_NONE to let network stack revalidate the checksum
>> and update the respective snmp stats.
>> 
>> Current MAPV1 header has been modified, the reserved field in the
>> Mapv1 header is now used for next header indication.
>> 
>> Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
>> Acked-by: Alex Elder <elder@linaro.org>
> 
> I did not acknowledge this message.  I did for patch 1
> only, which only updates the documentation.
> 
> I have a few other minor things I recommend you fix.
> 
> I don't see any bugs, but I'm not going to offer
> "Reviewed-by" until you've had a chance to either
> update your patch or explain why you won't.
> 
Sorry Alex for Adding Acked-by on all the patches, will remove in the 
subsequent patch.

>> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
>> ---
>>   .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 17 ++++---
>>   drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  3 +-
>>   .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 58 
>> +++++++++++++++++++++-
>>   include/linux/if_rmnet.h                           | 27 +++++++++-
>>   include/uapi/linux/if_link.h                       |  1 +
>>   5 files changed, 97 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> index 0be5ac7..706a225 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> @@ -1,5 +1,5 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights 
>> reserved.
>> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights 
>> reserved.
>>    *
>>    * RMNET Data ingress/egress handler
>>    */
>> @@ -82,11 +82,16 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
>>     	skb->dev = ep->egress_dev;
>>   -	/* Subtract MAP header */
>> -	skb_pull(skb, sizeof(struct rmnet_map_header));
>> -	rmnet_set_skb_proto(skb);
>> -
>> -	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
>> +	if ((port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) &&
>> +	    (map_header->flags & MAP_NEXT_HEADER_FLAG)) {
>> +		if (rmnet_map_process_next_hdr_packet(skb, len))
>> +			goto free_skb;
>> +		skb_pull(skb, sizeof(*map_header));
>> +		rmnet_set_skb_proto(skb);
>> +	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
>> +		/* Subtract MAP header */
>> +		skb_pull(skb, sizeof(*map_header));
>> +		rmnet_set_skb_proto(skb);
>>   		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
>>   			skb->ip_summed = CHECKSUM_UNNECESSARY;
>>   	}
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> index 2aea153..1a399bf 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> @@ -1,5 +1,5 @@
>>   /* SPDX-License-Identifier: GPL-2.0-only */
>> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights 
>> reserved.
>> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights 
>> reserved.
>>    */
>>     #ifndef _RMNET_MAP_H_
>> @@ -48,5 +48,6 @@ void rmnet_map_command(struct sk_buff *skb, struct 
>> rmnet_port *port);
>>   int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 
>> len);
>>   void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>>   				      struct net_device *orig_dev);
>> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
>>     #endif /* _RMNET_MAP_H_ */
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> index 0ac2ff8..43813cf 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> @@ -1,5 +1,5 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>> -/* Copyright (c) 2013-2018, The Linux Foundation. All rights 
>> reserved.
>> +/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights 
>> reserved.
>>    *
>>    * RMNET Data MAP protocol
>>    */
>> @@ -8,6 +8,7 @@
>>   #include <linux/ip.h>
>>   #include <linux/ipv6.h>
>>   #include <net/ip6_checksum.h>
>> +#include <linux/bitfield.h>
>>   #include "rmnet_config.h"
>>   #include "rmnet_map.h"
>>   #include "rmnet_private.h"
>> @@ -300,8 +301,11 @@ struct rmnet_map_header 
>> *rmnet_map_add_map_header(struct sk_buff *skb,
>>   struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>   				      struct rmnet_port *port)
>>   {
>> +	struct rmnet_map_v5_csum_header *next_hdr = NULL;
>> +	unsigned char *data = skb->data;
> 
> If you define the data variable to have (void *) type you can
> get rid of some casts below, and it won't need to use a cast
> when assigned here either.
> 

I will correct this and the all the comments related to the "data" 
variable in the subsequent patch.


>>   	struct rmnet_map_header *maph;
>>   	struct sk_buff *skbn;
>> +	u8 nexthdr_type;
>>   	u32 packet_len;
>>     	if (skb->len == 0)
>> @@ -312,6 +316,17 @@ struct sk_buff *rmnet_map_deaggregate(struct 
>> sk_buff *skb,
>>     	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
>>   		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
> 
> This block should be surrounded by curly braces.  If one block
> in an if statement (or chain of them) has them, they all should.
> 
Will correct this in the next patch.

>> +	else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
>> +		if (!(maph->flags & MAP_CMD_FLAG)) {
>> +			packet_len += sizeof(struct rmnet_map_v5_csum_header);
> 
> 			packet_len += sizeof(*next_hdr);
> 
>> +			if (maph->flags & MAP_NEXT_HEADER_FLAG)
>> +				next_hdr = (struct rmnet_map_v5_csum_header *)
>> +						(data + sizeof(*maph));
> 
> If data is a void pointer, this could be:
> 				next_hdr = data + sizeof(*maph);
> 
>> +			else
>> +				/* Mapv5 data pkt without csum hdr is invalid */
>> +				return NULL;
>> +		}
>> +	}
>>     	if (((int)skb->len - (int)packet_len) < 0)
>>   		return NULL;
>> @@ -320,6 +335,13 @@ struct sk_buff *rmnet_map_deaggregate(struct 
>> sk_buff *skb,
>>   	if (!maph->pkt_len)
>>   		return NULL;
>>   +	if (next_hdr) {
>> +		nexthdr_type = u8_get_bits(next_hdr->header_info,
>> +					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
>> +		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
>> +			return NULL;
>> +	}
>> +
>>   	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, 
>> GFP_ATOMIC);
>>   	if (!skbn)
>>   		return NULL;
>> @@ -414,3 +436,37 @@ void rmnet_map_checksum_uplink_packet(struct 
>> sk_buff *skb,
>>     	priv->stats.csum_sw++;
>>   }
>> +
>> +/* Process a MAPv5 packet header */
>> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
>> +				      u16 len)
>> +{
>> +	struct rmnet_priv *priv = netdev_priv(skb->dev);
>> +	struct rmnet_map_v5_csum_header *next_hdr;
>> +	u8 nexthdr_type;
>> +	int rc = 0;
>> +
>> +	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
>> +			sizeof(struct rmnet_map_header));
>> +
>> +	nexthdr_type = u8_get_bits(next_hdr->header_info,
>> +				   MAPV5_HDRINFO_HDR_TYPE_FMASK);
>> +
>> +	if (nexthdr_type == RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD) {
>> +		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
>> +			priv->stats.csum_sw++;
>> +		} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
>> +			priv->stats.csum_ok++;
>> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
>> +		} else {
>> +			priv->stats.csum_valid_unset++;
>> +		}
>> +
>> +		/* Pull csum v5 header */
>> +		skb_pull(skb, sizeof(struct rmnet_map_v5_csum_header));
> 
>         skb_pull(skb, sizeof(*next_hdr);
> 
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	return rc;
>> +}
>> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
>> index 4efb537..f82e37e 100644
>> --- a/include/linux/if_rmnet.h
>> +++ b/include/linux/if_rmnet.h
>> @@ -1,5 +1,5 @@
>>   /* SPDX-License-Identifier: GPL-2.0-only
>> - * Copyright (c) 2013-2019, The Linux Foundation. All rights 
>> reserved.
>> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights 
>> reserved.
>>    */
>>     #ifndef _LINUX_IF_RMNET_H_
>> @@ -14,8 +14,10 @@ struct rmnet_map_header {
>>   /* rmnet_map_header flags field:
>>    *  PAD_LEN:	number of pad bytes following packet data
>>    *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
>> + *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM 
>> header
>>    */
>>   #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
>> +#define MAP_NEXT_HEADER_FLAG		BIT(6)
>>   #define MAP_CMD_FLAG			BIT(7)
>>     struct rmnet_map_dl_csum_trailer {
>> @@ -45,4 +47,27 @@ struct rmnet_map_ul_csum_header {
>>   #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
>>   #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
>>   +/* MAP CSUM headers */
>> +struct rmnet_map_v5_csum_header {
>> +	u8 header_info;
>> +	u8 csum_info;
>> +	__be16 reserved;
>> +} __aligned(1);
>> +
>> +/* v5 header_info field
>> + * NEXT_HEADER:  Represents whether there is any other header
>> + * HEADER TYPE: represents the type of this header
>> + *
>> + * csum_info field
>> + * CSUM_VALID_OR_REQ:
>> + * 1 = for UL, checksum computation is requested.
>> + * 1 = for DL, validated the checksum and has found it valid
>> + */
>> +
>> +#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
>> +#define MAPV5_HDRINFO_HDR_TYPE_SHIFT	1
>> +#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, 
>> MAPV5_HDRINFO_HDR_TYPE_SHIFT)
>> +#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
> 
> This is the only place you use MAPV5_HDRINFO_TYPE_SHIFT.
> Defining and using it here immediately after its definition
> subtracts, rather than adds value.  Just do:
> 
> #define MAPV5_HDRINFO_HDR_TYPE_FMASK    GENMASK(7, 1)
> 
> 					-Alex
> 

The MAPV5_HDRINFO_HDR_TYPE_SHIFT is used in the uplink to set the 
header_type in the
header_info field. Will use u8_encode_bits and get rid of this in next 
patch.

>> +#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
>>   #endif /* !(_LINUX_IF_RMNET_H_) */
>> diff --git a/include/uapi/linux/if_link.h 
>> b/include/uapi/linux/if_link.h
>> index 91c8dda..21529b3 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -1235,6 +1235,7 @@ enum {
>>   #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
>>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
>>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
>> +#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
>>     enum {
>>   	IFLA_RMNET_UNSPEC,
>> 
