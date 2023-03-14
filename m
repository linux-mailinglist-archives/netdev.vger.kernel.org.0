Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541286B93F9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCNMgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCNMgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:36:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA949CBDF
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:36:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso13047271wmq.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678797310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pVIp7g2q/w3gUgwbSlzaQV0hcNAj9gmmGMjepwJpv3k=;
        b=sdUFUS6f0j2hkY1uaDLCJzh0NMjGoPd/Jat9dLhOac0kesFPsmEk85dxcVzFTs6/30
         3zJzSAMeRm2fZTcJeqGg6SC6MP95smAzjdo6EJttmteQVv66pTDbqoDLSnI4EwGVLgbA
         1pi7GIe9fel8lKxC4TP2RgpUCozojgCf9Lgw9I/al/k3OIaDakqu8EtpgHM0Jz6Q3c8+
         HfhXTq6SmbDOLNZyEorVzPoLF/bCW3O2FnpUrUZT3lbXCzOoCZ7KX9tj9cmWduG5R1Se
         JZw17vISJbZ+dYMJ/w5DdjC2zpzidlbwgNH6EdzeserXDbgeNcjOiB6zMUysol0A0+6U
         Djmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678797310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pVIp7g2q/w3gUgwbSlzaQV0hcNAj9gmmGMjepwJpv3k=;
        b=fAJtTgfg6X4BmEqy14zC1OLHhmg1wb/ehPQiYRrzc4MtBgon0zamtLHkA6BZrLO18G
         74Dyn2pGX706gUx7lALr1X6xVhoeyhqwF1I62EpC8UyI4u7kGw3kDLks0nxpdIbyzx4J
         vQ7E5Lli4BiqYbKQ0Toa9EPnwPRy7gjZvbG+4LeSc+deA9ep5K8zjqGHMgklV5/NgQKX
         AfHqppevunMxo0YAD5+3B84QtQrnz4ayaASI+nfWwybUUsLhBFkbeFVhEJim7oPiYnZ8
         f8TyB6aFFTOV4bieZE2cE1aeUnKDRhcs+HyLV94oqexH7apHi5CjzEzdtnFk6SrwhtZ6
         gYHg==
X-Gm-Message-State: AO0yUKWHovE0iSOOBkV5iHxgg9c4qOqXmiffiWH1+YNOr81sr5QtI96j
        lZ0SE1atHEmhLH6LiCQjkcKAnQ==
X-Google-Smtp-Source: AK7set//pIrcp8jUcf3JgMEK728z52zYkDOMryFo5bY5BGzgnMFiLeyAGc3+wkIA5dYYCN+dvceKbA==
X-Received: by 2002:a1c:f614:0:b0:3ea:fc95:7bf with SMTP id w20-20020a1cf614000000b003eafc9507bfmr14768496wmc.30.1678797309920;
        Tue, 14 Mar 2023 05:35:09 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id f3-20020a0560001b0300b002c559626a50sm2067133wrz.13.2023.03.14.05.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 05:35:09 -0700 (PDT)
Message-ID: <e695257a-58e2-c676-95cd-77df5c2b68cf@blackwall.org>
Date:   Tue, 14 Mar 2023 14:35:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 09/11] vxlan: Add MDB data path support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-10-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-10-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Integrate MDB support into the Tx path of the VXLAN driver, allowing it
> to selectively forward IP multicast traffic according to the matched MDB
> entry.
> 
> If MDB entries are configured (i.e., 'VXLAN_F_MDB' is set) and the
> packet is an IP multicast packet, perform up to three different lookups
> according to the following priority:
> 
> 1. For an (S, G) entry, using {Source VNI, Source IP, Destination IP}.
> 2. For a (*, G) entry, using {Source VNI, Destination IP}.
> 3. For the catchall MDB entry (0.0.0.0 or ::), using the source VNI.
> 
> The catchall MDB entry is similar to the catchall FDB entry
> (00:00:00:00:00:00) that is currently used to transmit BUM (broadcast,
> unknown unicast and multicast) traffic. However, unlike the catchall FDB
> entry, this entry is only used to transmit unregistered IP multicast
> traffic that is not link-local. Therefore, when configured, the catchall
> FDB entry will only transmit BULL (broadcast, unknown unicast,
> link-local multicast) traffic.
> 
> The catchall MDB entry is useful in deployments where inter-subnet
> multicast forwarding is used and not all the VTEPs in a tenant domain
> are members in all the broadcast domains. In such deployments it is
> advantageous to transmit BULL (broadcast, unknown unicast and link-local
> multicast) and unregistered IP multicast traffic on different tunnels.
> If the same tunnel was used, a VTEP only interested in IP multicast
> traffic would also pull all the BULL traffic and drop it as it is not a
> member in the originating broadcast domain [1].
> 
> If the packet did not match an MDB entry (or if the packet is not an IP
> multicast packet), return it to the Tx path, allowing it to be forwarded
> according to the FDB.
> 
> If the packet did match an MDB entry, forward it to the associated
> remote VTEPs. However, if the entry is a (*, G) entry and the associated
> remote is in INCLUDE mode, then skip over it as the source IP is not in
> its source list (otherwise the packet would have matched on an (S, G)
> entry). Similarly, if the associated remote is marked as BLOCKED (can
> only be set on (S, G) entries), then skip over it as well as the remote
> is in EXCLUDE mode and the source IP is in its source list.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c    |  15 ++++
>  drivers/net/vxlan/vxlan_mdb.c     | 114 ++++++++++++++++++++++++++++++
>  drivers/net/vxlan/vxlan_private.h |   6 ++
>  3 files changed, 135 insertions(+)
> 
[snip]> diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
> index b32b1fb4a74a..ea63c5178718 100644
> --- a/drivers/net/vxlan/vxlan_mdb.c
> +++ b/drivers/net/vxlan/vxlan_mdb.c
> @@ -1298,6 +1298,120 @@ int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
>  	return err;
>  }
>  
> +struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
> +						struct sk_buff *skb,
> +						__be32 src_vni)
> +{
> +	struct vxlan_mdb_entry *mdb_entry;
> +	struct vxlan_mdb_entry_key group;
> +
> +	if (!is_multicast_ether_addr(eth_hdr(skb)->h_dest) ||
> +	    is_broadcast_ether_addr(eth_hdr(skb)->h_dest))
> +		return NULL;
> +
> +	/* When not in collect metadata mode, 'src_vni' is zero, but MDB
> +	 * entries are stored with the VNI of the VXLAN device.
> +	 */
> +	if (!(vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA))
> +		src_vni = vxlan->default_dst.remote_vni;
> +
> +	memset(&group, 0, sizeof(group));
> +	group.vni = src_vni;
> +
> +	switch (ntohs(skb->protocol)) {

drop the ntohs and..

> +	case ETH_P_IP:

htons(ETH_P_IP)

> +		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> +			return NULL;
> +		group.dst.sa.sa_family = AF_INET;
> +		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
> +		group.src.sa.sa_family = AF_INET;
> +		group.src.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case ETH_P_IPV6:

htons(ETH_P_IPV6)

> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> +			return NULL;
> +		group.dst.sa.sa_family = AF_INET6;
> +		group.dst.sin6.sin6_addr = ipv6_hdr(skb)->daddr;
> +		group.src.sa.sa_family = AF_INET6;
> +		group.src.sin6.sin6_addr = ipv6_hdr(skb)->saddr;
> +		break;
> +#endif
> +	default:
> +		return NULL;
> +	}
> +
> +	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &group);
> +	if (mdb_entry)
> +		return mdb_entry;
> +
> +	memset(&group.src, 0, sizeof(group.src));
> +	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &group);
> +	if (mdb_entry)
> +		return mdb_entry;
> +
> +	/* No (S, G) or (*, G) found. Look up the all-zeros entry, but only if
> +	 * the destination IP address is not link-local multicast since we want
> +	 * to transmit such traffic together with broadcast and unknown unicast
> +	 * traffic.
> +	 */
> +	switch (ntohs(skb->protocol)) {
> +	case ETH_P_IP:

ditto

> +		if (ipv4_is_local_multicast(group.dst.sin.sin_addr.s_addr))
> +			return NULL;
> +		group.dst.sin.sin_addr.s_addr = 0;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case ETH_P_IPV6:

ditto

> +		if (ipv6_addr_type(&group.dst.sin6.sin6_addr) &
> +		    IPV6_ADDR_LINKLOCAL)
> +			return NULL;
> +		memset(&group.dst.sin6.sin6_addr, 0,
> +		       sizeof(group.dst.sin6.sin6_addr));
> +		break;
> +#endif
> +	default:
> +		return NULL;
> +	}
> +
> +	return vxlan_mdb_entry_lookup(vxlan, &group);
> +}
> +
[snip]

