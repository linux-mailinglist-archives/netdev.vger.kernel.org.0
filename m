Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961434A84D9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350700AbiBCNEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350698AbiBCNEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:04:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1883AC06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:04:52 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m11so5790412edi.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 05:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2mwUPXoHw2U3pchucMh1Dyc/z3652kHLkK9mHdVy47M=;
        b=dC3CCO5oWgfnSmwG25SBVs4HxEQtsXZ5r+KZMBkM4lUhbhT8W/jCXglpAHKxMlpcqd
         kBGrOrgrTwYx8iifSVNrY40uSASoy08FeD7AZElq/zg4lYyMt4OMWvmS6RtGpKT36qIg
         +GtqPRsOaL5DNEa2+Xup5OnJv530ZFja7OJ7hFlUNGWPO6TPFk58PI8c6RgG6eGM2wo3
         QNCekdZ9ZUuXZ/Obxwgsl1/jwN9D8cbaIfn7nD3YYs2fNff9KmBzpbuROM1njmODNoh2
         FXgkUcDedawPawOnrOMRcdNnApBlE6Z06kPGzl4BiL+OeRtExHOQtU/2MA8JfWjijT72
         onww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2mwUPXoHw2U3pchucMh1Dyc/z3652kHLkK9mHdVy47M=;
        b=V7HLsO8TbrRz8QOSfzyEXSWq9B4sOpFybB87ajI9/MLNB9GMenOZo+g6Psn4MsLmmJ
         U3Ahf7cP9JTioS8n6f4jfaKpWy7D9drn1u8Ed8uQUHDc31AWU6lz6IwNC/vtkkwhVzQA
         DjC9QwlT7H15KYStsHWNyyW1rLvXNAJRttnVfivUC1CLl7O/l0qparar6F8UYdfoHh+8
         bSnQHhgQo18mvvpo7agqAkPHavEVjRLWL6zN3AqewpsxHDRDOOcuZf6ZEWpLsPKzNj2P
         Y45Qg/ujTsLtjvHO+JEGeiAwR5URMqzBGNaUXXiNA7GYYjx+Nfni4SE/vznewS0E8K2m
         mS+A==
X-Gm-Message-State: AOAM5307WEwrTopiPgfVguLsR61bycpO2PfjYpsgbCxOkkokcj9BQRpP
        qtNi2toF2S3pbxYH7qbIWsQ=
X-Google-Smtp-Source: ABdhPJxxtrWrIQXaxw699Fb2j0iae+Y/LD2lnxXSd7ZxILvvYfJ+iJDW1Gnv/nQAjpvJbF4n4Pgjyg==
X-Received: by 2002:aa7:d949:: with SMTP id l9mr35515760eds.348.1643893490518;
        Thu, 03 Feb 2022 05:04:50 -0800 (PST)
Received: from [192.168.0.108] ([77.126.86.139])
        by smtp.gmail.com with ESMTPSA id d3sm11991745edq.13.2022.02.03.05.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 05:04:50 -0800 (PST)
Message-ID: <00066e2f-048b-16ac-c3d0-eb480593bdfb@gmail.com>
Date:   Thu, 3 Feb 2022 15:04:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 14/15] mlx4: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-15-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220203015140.3022854-15-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2022 3:51 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> mlx4 supports LSOv2 just fine.
> 
> IPv6 stack inserts a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
> 
> We need to ignore the HBH header when populating TX descriptor.
> 
> Tested:
> 
> Before: (not enabling bigger TSO/GRO packets)
> 
> ip link set dev eth0 gso_ipv6_max_size 65536 gro_ipv6_max_size 65536
> 
> netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> Local /Remote
> Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> 
> 262144 540000 70000   70000  10.00   6591.45  0.86   1.34   62.490  97.446
> 262144 540000
> 
> After: (enabling bigger TSO/GRO packets)
> 
> ip link set dev eth0 gso_ipv6_max_size 185000 gro_ipv6_max_size 185000
> 
> netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> Local /Remote
> Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> 
> 262144 540000 70000   70000  10.00   8383.95  0.95   1.01   54.432  57.584
> 262144 540000
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++++++++----
>   2 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index c61dc7ae0c056a4dbcf24297549f6b1b5cc25d92..76cb93f5e5240c54f6f4c57e39739376206b4f34 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -3417,6 +3417,9 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
>   	dev->min_mtu = ETH_MIN_MTU;
>   	dev->max_mtu = priv->max_mtu;
>   
> +	/* supports LSOv2 packets, 512KB limit has been tested. */
> +	netif_set_tso_ipv6_max_size(dev, 512 * 1024);
> +
>   	mdev->pndev[port] = dev;
>   	mdev->upper[port] = NULL;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 817f4154b86d599cd593876ec83529051d95fe2f..c89b3e8094e7d8cfb11aaa6cc4ad63bf3ad5934e 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -44,6 +44,7 @@
>   #include <linux/ipv6.h>
>   #include <linux/moduleparam.h>
>   #include <linux/indirect_call_wrapper.h>
> +#include <net/ipv6.h>
>   
>   #include "mlx4_en.h"
>   
> @@ -635,19 +636,28 @@ static int get_real_size(const struct sk_buff *skb,
>   			 struct net_device *dev,
>   			 int *lso_header_size,
>   			 bool *inline_ok,
> -			 void **pfrag)
> +			 void **pfrag,
> +			 int *hopbyhop)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
>   	int real_size;
>   
>   	if (shinfo->gso_size) {
>   		*inline_ok = false;
> -		if (skb->encapsulation)
> +		*hopbyhop = 0;
> +		if (skb->encapsulation) {
>   			*lso_header_size = (skb_inner_transport_header(skb) - skb->data) + inner_tcp_hdrlen(skb);
> -		else
> +		} else {
> +			/* Detects large IPV6 TCP packets and prepares for removal of
> +			 * HBH header that has been pushed by ip6_xmit(),
> +			 * mainly so that tcpdump can dissect them.
> +			 */
> +			if (ipv6_has_hopopt_jumbo(skb))
> +				*hopbyhop = sizeof(struct hop_jumbo_hdr);
>   			*lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);
> +		}
>   		real_size = CTRL_SIZE + shinfo->nr_frags * DS_SIZE +
> -			ALIGN(*lso_header_size + 4, DS_SIZE);
> +			ALIGN(*lso_header_size - *hopbyhop + 4, DS_SIZE);
>   		if (unlikely(*lso_header_size != skb_headlen(skb))) {
>   			/* We add a segment for the skb linear buffer only if
>   			 * it contains data */
> @@ -874,6 +884,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>   	int desc_size;
>   	int real_size;
>   	u32 index, bf_index;
> +	struct ipv6hdr *h6;
>   	__be32 op_own;
>   	int lso_header_size;
>   	void *fragptr = NULL;
> @@ -882,6 +893,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>   	bool stop_queue;
>   	bool inline_ok;
>   	u8 data_offset;
> +	int hopbyhop;
>   	bool bf_ok;
>   
>   	tx_ind = skb_get_queue_mapping(skb);
> @@ -891,7 +903,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>   		goto tx_drop;
>   
>   	real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
> -				  &inline_ok, &fragptr);
> +				  &inline_ok, &fragptr, &hopbyhop);
>   	if (unlikely(!real_size))
>   		goto tx_drop_count;
>   
> @@ -944,7 +956,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>   		data = &tx_desc->data;
>   		data_offset = offsetof(struct mlx4_en_tx_desc, data);
>   	} else {
> -		int lso_align = ALIGN(lso_header_size + 4, DS_SIZE);
> +		int lso_align = ALIGN(lso_header_size - hopbyhop + 4, DS_SIZE);
>   
>   		data = (void *)&tx_desc->lso + lso_align;
>   		data_offset = offsetof(struct mlx4_en_tx_desc, lso) + lso_align;
> @@ -1009,14 +1021,31 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>   			((ring->prod & ring->size) ?
>   				cpu_to_be32(MLX4_EN_BIT_DESC_OWN) : 0);
>   
> +		lso_header_size -= hopbyhop;
>   		/* Fill in the LSO prefix */
>   		tx_desc->lso.mss_hdr_size = cpu_to_be32(
>   			shinfo->gso_size << 16 | lso_header_size);
>   
> -		/* Copy headers;
> -		 * note that we already verified that it is linear */
> -		memcpy(tx_desc->lso.header, skb->data, lso_header_size);
>   
> +		if (unlikely(hopbyhop)) {
> +			/* remove the HBH header.
> +			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +			 */
> +			memcpy(tx_desc->lso.header, skb->data, ETH_HLEN + sizeof(*h6));
> +			h6 = (struct ipv6hdr *)((char *)tx_desc->lso.header + ETH_HLEN);
> +			h6->nexthdr = IPPROTO_TCP;
> +			/* Copy the TCP header after the IPv6 one */
> +			memcpy(h6 + 1,
> +			       skb->data + ETH_HLEN + sizeof(*h6) +
> +					sizeof(struct hop_jumbo_hdr),
> +			       tcp_hdrlen(skb));
> +			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */

Hi Eric,
Many thanks for your patches.
Impressive improvement indeed!

I am concerned about not using lso_header_size in this flow.
The num of bytes copied here might be out-of-sync with the value 
provided in the descriptor (tx_desc->lso.mss_hdr_size).
Are the two values guaranteed to be equal?
I think this is an assumption that can get broken in the future by 
unaware patches to the kernel stack.

Thanks,
Tariq

> +		} else {
> +			/* Copy headers;
> +			 * note that we already verified that it is linear
> +			 */
> +			memcpy(tx_desc->lso.header, skb->data, lso_header_size);
> +		}
>   		ring->tso_packets++;
>   
>   		i = shinfo->gso_segs;
