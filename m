Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F794A7FD9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbiBCH1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiBCH1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 02:27:52 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86498C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 23:27:51 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id me13so5644522ejb.12
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 23:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=51kKfCzjNyw4Sk+AnDc5fNVlmTYRmXoEdLHxf4yP7Yo=;
        b=IvOS1LT6JLLP5zUP+tmG/IzJpjbrwl/MNlkNTWRBWGAstZssNGlH/MW7lhk7qlkaE2
         zHVbw4zmjZrxmlEK4yPPkNgvpYY9PUe3lKTqsvrytm7ATuteWGChimYEWi1S4Z9KRhQa
         KA48k1jXSuUa28MA7VRbV1SfY+SdC1myrwho1FvvuOnLGTHCARYloftSaU8tPKpQz36D
         nPS34JpFTXK4LHT8UqhNgNaj5hkLcH5TmdRzEI1TJxHjQloXjmJ7T625CJAUxwXkT/HA
         83fxzDOrzmxeQaahsBhhaHNkQp3y/K+7T/3gTUS7jh720SXDS3s5ioDsVyPAimV+osXb
         7IRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=51kKfCzjNyw4Sk+AnDc5fNVlmTYRmXoEdLHxf4yP7Yo=;
        b=QjM3KNauAjIIuPSA6Y2zMtLz6go5HOBI48SE+n3G96oHcUbDmUm4/EyYkRAiesTzP/
         di0dZtvMgXSa3bCXks6zZdrrjBeic+5PdJ/0HdBsgt2ZH6f8qXKCMuExd7PA3Yt2NsUR
         JkH4lBIyasTC2wEs4QzDMzlDo/s0jplr29k2iJUROE/bPPzShQTCAJakiO4G0GZeMaNf
         59lrNq2Wzl+zIgbWHy4r98vr729eK9GMAmjPnLKaH5tcEDFRsOmrW4JRsxGHpOn87KbE
         JwPkrHatCgjNQZcjD9A+x/s4AHo1n8wcJPJBUw7Dse88ufM8QqtYX9pXdDzRiB3bwJBb
         Hqkg==
X-Gm-Message-State: AOAM530Wn2pXWyxykSpoBLFNiLkzvJ58gdYFpd5QAGTPIjpQNAkt0nMe
        7xN17yc2Rjzsev8CqwJ0mBM=
X-Google-Smtp-Source: ABdhPJxRIjkRQF0ghnjZCrQF1ByEYJvdLK9Ra1T3ZEgksBAiaslaj1EoKc9yZltA2M+mTs7roWNu8w==
X-Received: by 2002:a17:907:720f:: with SMTP id dr15mr28086928ejc.182.1643873269568;
        Wed, 02 Feb 2022 23:27:49 -0800 (PST)
Received: from [192.168.0.108] ([77.126.86.139])
        by smtp.gmail.com with ESMTPSA id gg14sm16585319ejb.62.2022.02.02.23.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 23:27:49 -0800 (PST)
Message-ID: <3ec9a7cb-433c-41b3-f918-8b5746092482@gmail.com>
Date:   Thu, 3 Feb 2022 09:27:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 15/15] mlx5: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-16-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220203015140.3022854-16-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your patch!

On 2/3/2022 3:51 AM, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> mlx5 supports LSOv2.
> 
> IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
> 
> We need to ignore/skip this HBH header when populating TX descriptor.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 81 +++++++++++++++----
>   2 files changed, 65 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index bf80fb6124499fc4e6a0310ab92c91159b4ccbbb..1c4ce90e5d0f5186c402137b744258ff4ce6a348 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4888,6 +4888,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>   
>   	netdev->priv_flags       |= IFF_UNICAST_FLT;
>   
> +	netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
>   	mlx5e_set_netdev_dev_addr(netdev);
>   	mlx5e_ipsec_build_netdev(priv);
>   	mlx5e_tls_build_netdev(priv);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 7fd33b356cc8d191413e8259acd0b26b3ebd6ba9..fc945bd8219dcb69950b1840bb492649c8749976 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -40,6 +40,7 @@
>   #include "en_accel/en_accel.h"
>   #include "en_accel/ipsec_rxtx.h"
>   #include "en/ptp.h"
> +#include <net/ipv6.h>
>   
>   static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
>   {
> @@ -241,8 +242,11 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   		sq->stats->csum_none++;
>   }
>   
> +/* Returns the number of header bytes that we plan
> + * to inline later in the transmit descriptor
> + */
>   static inline u16
> -mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
> +mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
>   {
>   	struct mlx5e_sq_stats *stats = sq->stats;
>   	u16 ihs;
> @@ -252,15 +256,18 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
>   		stats->tso_inner_packets++;
>   		stats->tso_inner_bytes += skb->len - ihs;
>   	} else {
> -		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> +		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
>   			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
> -		else
> +		} else {
> +			if (ipv6_has_hopopt_jumbo(skb))
> +				*hopbyhop = sizeof(struct hop_jumbo_hdr);
>   			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
> +		}
>   		stats->tso_packets++;
> -		stats->tso_bytes += skb->len - ihs;
> +		stats->tso_bytes += skb->len - ihs - *hopbyhop;

AFAIU, *hopbyhop is already accounted inside ihs, why decrement it once 
more?

Probably it'd be cleaner to assign/fix both ihs and hopbyhop under 
ipv6_has_hopopt_jumbo branch():

		ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
		if (ipv6_has_hopopt_jumbo(skb)) {
			*hopbyhop = sizeof(struct hop_jumbo_hdr);
			ihs -= sizeof(struct hop_jumbo_hdr);
		}
...
		stats->tso_bytes += skb->len - ihs - *hopbyhop;
...
		return ihs;

>   	}
>   
> -	return ihs;
> +	return ihs - *hopbyhop;
>   }
>   
>   static inline int
> @@ -319,6 +326,7 @@ struct mlx5e_tx_attr {
>   	__be16 mss;
>   	u16 insz;
>   	u8 opcode;
> +	u8 hopbyhop;
>   };
>   
>   struct mlx5e_tx_wqe_attr {
> @@ -355,14 +363,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   	struct mlx5e_sq_stats *stats = sq->stats;
>   
>   	if (skb_is_gso(skb)) {
> -		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb);
> +		int hopbyhop;

missing init to zero. mlx5e_tx_get_gso_ihs() doesn't always write to it.

> +		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb, &hopbyhop);
>   
>   		*attr = (struct mlx5e_tx_attr) {
>   			.opcode    = MLX5_OPCODE_LSO,
>   			.mss       = cpu_to_be16(skb_shinfo(skb)->gso_size),
>   			.ihs       = ihs,
>   			.num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
> -			.headlen   = skb_headlen(skb) - ihs,
> +			.headlen   = skb_headlen(skb) - ihs - hopbyhop,
> +			.hopbyhop  = hopbyhop,
>   		};
>   
>   		stats->packets += skb_shinfo(skb)->gso_segs;
> @@ -476,7 +486,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   	struct mlx5_wqe_eth_seg  *eseg;
>   	struct mlx5_wqe_data_seg *dseg;
>   	struct mlx5e_tx_wqe_info *wi;
> -
> +	u16 ihs = attr->ihs;
> +	struct ipv6hdr *h6;
>   	struct mlx5e_sq_stats *stats = sq->stats;
>   	int num_dma;
>   
> @@ -490,15 +501,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   
>   	eseg->mss = attr->mss;
>   
> -	if (attr->ihs) {
> -		if (skb_vlan_tag_present(skb)) {
> -			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
> -			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
> +	if (ihs) {
> +		u8 *start = eseg->inline_hdr.start;
> +
> +		if (unlikely(attr->hopbyhop)) {
> +			/* remove the HBH header.
> +			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +			 */
> +			if (skb_vlan_tag_present(skb)) {
> +				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));
> +				ihs += VLAN_HLEN;
> +				h6 = (struct ipv6hdr *)(start + sizeof(struct vlan_ethhdr));
> +			} else {
> +				memcpy(start, skb->data, ETH_HLEN + sizeof(*h6));
> +				h6 = (struct ipv6hdr *)(start + ETH_HLEN);
> +			}
> +			h6->nexthdr = IPPROTO_TCP;
> +			/* Copy the TCP header after the IPv6 one */
> +			memcpy(h6 + 1,
> +			       skb->data + ETH_HLEN + sizeof(*h6) +
> +					sizeof(struct hop_jumbo_hdr),
> +			       tcp_hdrlen(skb));
> +			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */

You are not using ihs when preparing the inline part of the descriptor, 
so this might yield a mismatch between ihs and the sum of the sizes 
you're copying above. Is there a guarantee that this won't happen?

> +		} else if (skb_vlan_tag_present(skb)) {
> +			mlx5e_insert_vlan(start, skb, ihs);
> +			ihs += VLAN_HLEN;
>   			stats->added_vlan_packets++;
>   		} else {
> -			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
> -			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
> +			memcpy(start, skb->data, ihs);
>   		}
> +		eseg->inline_hdr.sz |= cpu_to_be16(ihs);
>   		dseg += wqe_attr->ds_cnt_inl;
>   	} else if (skb_vlan_tag_present(skb)) {
>   		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
> @@ -509,7 +541,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   	}
>   
>   	dseg += wqe_attr->ds_cnt_ids;
> -	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
> +	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
>   					  attr->headlen, dseg);
>   	if (unlikely(num_dma < 0))
>   		goto err_drop;
> @@ -1016,12 +1048,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>   	eseg->mss = attr.mss;
>   
>   	if (attr.ihs) {
> -		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> +		if (unlikely(attr.hopbyhop)) {
> +			/* remove the HBH header.
> +			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +			 */
> +			memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
> +			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
> +			h6->nexthdr = IPPROTO_TCP;
> +			/* Copy the TCP header after the IPv6 one */
> +			memcpy(h6 + 1,
> +			       skb->data + ETH_HLEN + sizeof(*h6) +
> +					sizeof(struct hop_jumbo_hdr),
> +			       tcp_hdrlen(skb));
> +			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
> +		} else {
> +			memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> +		}
>   		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
>   		dseg += wqe_attr.ds_cnt_inl;
>   	}
>   
> -	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
> +	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs + attr.hopbyhop,
>   					  attr.headlen, dseg);
>   	if (unlikely(num_dma < 0))
>   		goto err_drop;
