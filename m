Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747CD473DE9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 09:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhLNIFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 03:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhLNIFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 03:05:24 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0C4C061574;
        Tue, 14 Dec 2021 00:05:23 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so30879763wrs.12;
        Tue, 14 Dec 2021 00:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2XyIwchJfBVTQQPr8dAusu0O41VdkfczIUPCghzYk7o=;
        b=B32cexYxpERfS5WghjcuxzLPAfkcFY4en+fIyHX5nEcPIKuyJkZHCbpDLFzvgB2PGs
         VJEiOKfjL24MEoeiKmOCmX/YTraaVmSEM01O/PFoWqJxhhCbfBRKy7VGis2UhXNy20qc
         oAdyHIxGpv6Zwt3r8TzQCGTCYBxXdmWdF2OctUOZAI80MnYmOxIRGUw0wh0SVLsDaPQx
         glSfwcpxo80lJfDMlv4WztxXzpWOdsOr7UCg8zFub2bEeOAz2VFpws0VTayGH261D+V/
         V/4F5F245FWseOWaOvXzRK/zMz/OvwBDx5eBLyIKtI4NRP99hyYejAaZSevIa2NiWI9K
         qvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2XyIwchJfBVTQQPr8dAusu0O41VdkfczIUPCghzYk7o=;
        b=jo8tSZFC4SLmBg5tUxl1RkbOcKXH0k08yGAUI+Tq6ha0VE/Yv3rqurBVqMWUNZcYsV
         OpHuceRa4LGdtDA0YvrRjx1x/stmKtd1pA90GnrIw1DRIBnODe1s6OIqs5ykD7znh/eN
         DFyi6WrKDCz+0MFTSZv6KmHJcaVnY/Ds/nPYCq+6WQaooT3hVgNMmQ8zjsChcRYnc5T+
         0lzn4BQpWsY9PDH3QlC5r6NcluB4JVlCX1ARZFz9DLCBzuGfj39zQoj1Y1MmgSaI3nfV
         UOInx2qAHtEJY6Nq6v/Xdjk1Nj1bNvQVRVRyOg/a7yX9FzsFNMdxOpvIrkS4+O6Qrjzl
         ZyJQ==
X-Gm-Message-State: AOAM531BnBoLj2uD3nM/iC8z/O3EJlcqB2iWFLTMAdCndg+TGCmkiYZL
        Sf21nldjcshGlRXu4zpXSOg=
X-Google-Smtp-Source: ABdhPJzyPMBiDzREvcgFSi5LjE2Kq6Y6ofRK/FdBOodBuhEflvENCxhXqAnB7QckOJCRE2+tR/6ptQ==
X-Received: by 2002:a05:6000:18ad:: with SMTP id b13mr4065756wri.195.1639469122253;
        Tue, 14 Dec 2021 00:05:22 -0800 (PST)
Received: from [10.0.0.11] ([37.166.135.72])
        by smtp.gmail.com with ESMTPSA id b13sm13752267wrh.32.2021.12.14.00.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 00:05:21 -0800 (PST)
Subject: Re: [PATCH V2] net: bonding: Add support for IPV6 ns/na
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dad92c6d-d5b2-38a9-a8ad-e36a6a987a79@gmail.com>
Date:   Tue, 14 Dec 2021 00:05:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/10/21 5:08 AM, Sun Shouxin wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bonding6 driver, we can see packet
> drop due to inconsistency bewteen mac address in the option
> message and source MAC .
>
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host brighe, the src mac
> mighe be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
>
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
>
> 			Border-Leaf
> 			/        \
> 		       /          \
> 		    Tunnel1    Tunnel2
> 		     /              \
> 	            /                \
> 		  Leaf-1--Tunnel3--Leaf-2
> 		    \                /
> 		     \              /
> 		      \            /
> 		       \          /
> 		       NIC1    NIC2
> 			\      /
> 			server
>
> We can see in our lab the Border-Leaf receives occasionally
> a NA packet which is assigned to NIC1 mac in ND/NS option
> message, but actaully send out via NIC2 mac due to tx-alb,
> as a result, it will cause inconsistency between MAC table
> and ND Table in Border-Leaf, i.e, NIC1 = Tunnel2 in ND table
> and  NIC1 = Tunnel1 in mac table.
>
> And then, Border-Leaf starts to forward packet destinated
> to the Server, it will only check the ND table entry in some
> switch to encapsulate the destination MAC of the message as
> NIC1 MAC, and then send it out from Tunnel2 by ND table.
> Then, Leaf-2 receives the packet, it notices the destination
> MAC of message is NIC1 MAC and should forword it to Tunne1
> by Tunnel3.
>
> However, this traffic forward will be failure due to split
> horizon of VxLAN tunnels.
>
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>   drivers/net/bonding/bond_alb.c | 131 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 131 insertions(+)
>
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 533e476..afa386b 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -22,6 +22,7 @@
>   #include <asm/byteorder.h>
>   #include <net/bonding.h>
>   #include <net/bond_alb.h>
> +#include <net/ndisc.h>
>   
>   static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
>   	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
> @@ -1269,6 +1270,119 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>   	return res;
>   }
>   
> +/*determine if the packet is NA or NS*/
> +static bool alb_determine_nd(struct icmp6hdr *hdr)
> +{
> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void alb_change_nd_option(struct sk_buff *skb, void *data)
> +{
> +	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
> +	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
> +	struct net_device *dev = skb->dev;
> +	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
> +	struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
> +	u8 *lladdr = NULL;
> +	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
> +				offsetof(struct nd_msg, opt));
> +
> +	while (ndoptlen) {
> +		int l;
> +
> +		switch (nd_opt->nd_opt_type) {
> +		case ND_OPT_SOURCE_LL_ADDR:
> +		case ND_OPT_TARGET_LL_ADDR:
> +		lladdr = ndisc_opt_addr_data(nd_opt, dev);
> +		break;
> +
> +		default:
> +		lladdr = NULL;
> +		break;
> +		}
> +
> +		l = nd_opt->nd_opt_len << 3;
> +
> +		if (ndoptlen < l || l == 0)
> +			return;
> +
> +		if (lladdr) {
> +			memcpy(lladdr, data, dev->addr_len);

I am not sure it is allowed to change skb content without

making sure skb ->head is private.

(Think of tcpdump -i slaveX : we want to see the packet content before 
your change)

I would think skb_cow_head() or something similar is needed.

This is tricky of course, since all cached pointers (icmp6h, ip6hdr, 
msg, nd_opt)

would need to be fetched again, since skb->head/data might be changed

by skb_cow_head().





> +			icmp6h->icmp6_cksum = 0;
> +
> +			icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
> +							      &ip6hdr->daddr,
> +						ntohs(ip6hdr->payload_len),
> +						IPPROTO_ICMPV6,
> +						csum_partial(icmp6h,
> +							     ntohs(ip6hdr->payload_len), 0));
> +		}
> +		ndoptlen -= l;
> +		nd_opt = ((void *)nd_opt) + l;
> +	}
> +}
> +
> +static u8 *alb_get_lladdr(struct sk_buff *skb)
> +{
> +	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
> +	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
> +	struct net_device *dev = skb->dev;
> +	u8 *lladdr = NULL;
> +	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
> +				offsetof(struct nd_msg, opt));
> +
> +	while (ndoptlen) {
> +		int l;
> +
> +		switch (nd_opt->nd_opt_type) {
> +		case ND_OPT_SOURCE_LL_ADDR:
> +		case ND_OPT_TARGET_LL_ADDR:
> +			lladdr = ndisc_opt_addr_data(nd_opt, dev);
> +			break;
> +
> +		default:
> +			break;
> +		}
> +
> +		l = nd_opt->nd_opt_len << 3;
> +
> +		if (ndoptlen < l || l == 0)
> +			return lladdr;

                          return NULL ?

                     (or risk out-of-bound access ?)

> +
> +		if (lladdr)
> +			return lladdr;
> +
> +		ndoptlen -= l;
> +		nd_opt = ((void *)nd_opt) + l;
> +	}
> +
> +	return lladdr;
> +}
> +
> +static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
> +			      struct slave *tx_slave)
> +{
> +	struct ipv6hdr *ip6hdr;
> +	struct icmp6hdr *hdr = NULL;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6)) {
> +		if (tx_slave && tx_slave !=
> +		    rcu_access_pointer(bond->curr_active_slave)) {
> +			ip6hdr = ipv6_hdr(skb);
> +			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> +				hdr = icmp6_hdr(skb);
> +				if (alb_determine_nd(hdr))
> +					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
> +			}
> +		}
> +	}
> +}
> +
>   /************************ exported alb functions ************************/
>   
>   int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
> @@ -1415,6 +1529,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>   	}
>   	case ETH_P_IPV6: {
>   		const struct ipv6hdr *ip6hdr;
> +		struct icmp6hdr *hdr = NULL;
>   
>   		/* IPv6 doesn't really use broadcast mac address, but leave
>   		 * that here just in case.
> @@ -1446,6 +1561,21 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>   			break;
>   		}
>   
> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> +			hdr = icmp6_hdr(skb);
> +			if (alb_determine_nd(hdr)) {
> +				u8 *lladdr = NULL;
> +
> +				lladdr = alb_get_lladdr(skb);
> +				if (lladdr) {
> +					if (!bond_slave_has_mac_rx(bond, lladdr)) {
> +						do_tx_balance = false;
> +						break;
> +					}
> +				}
> +			}
> +		}
> +
>   		hash_start = (char *)&ip6hdr->daddr;
>   		hash_size = sizeof(ip6hdr->daddr);
>   		break;
> @@ -1489,6 +1619,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>   	struct slave *tx_slave = NULL;
>   
>   	tx_slave = bond_xmit_alb_slave_get(bond, skb);
> +	alb_set_nd_option(skb, bond, tx_slave);
>   	return bond_do_alb_xmit(skb, bond, tx_slave);
>   }
>   
