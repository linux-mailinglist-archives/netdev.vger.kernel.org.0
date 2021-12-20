Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3D447B00F
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhLTPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbhLTPXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 10:23:07 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6BEC024B02;
        Mon, 20 Dec 2021 07:03:15 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id b188-20020a1c80c5000000b00345afe7e3c0so241788wmd.3;
        Mon, 20 Dec 2021 07:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=aILOLlggwaRUS/r4M7qPoyQAr7Vk7dn7e+wtRotl3+o=;
        b=CDbMDYekcNtQY2KWw1U/mDwYQMd3DJAtOEkfzDQyikZjIodVqxyFmLteNcOBPkoGr2
         dV/C+xZp0/3/aCRzYqYjvxapCiw5lUCnOpUJmOtu2D9lBeVEB5uyoIcXFIgZ0TOlllBg
         efHpHPIQ3va07KYoW/uKXGwFj/dX/898vWHEqHIzoGNEzAwnRLNMIU9/A8DpgHTcsphp
         5Ls8GBWYKYnW3MqMGBbFjdwiGtnWJ97pztG/twiWU6084TIsFYrABR9jCqe8oxYvuwe3
         CL7K5Q97aw0vg2/XxLXead/7gYQMpIK75ofKXuJ2ebs8PV+/gtiLAgeGFIW4r47u5SEL
         fr3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aILOLlggwaRUS/r4M7qPoyQAr7Vk7dn7e+wtRotl3+o=;
        b=gtwyP0brlkEkHtpn4v1wX08hPtUlfDTWtH4j7y8K+UCweA7dTtyCpKsKHFJGEcLNKA
         X/4XuJQAVJUW46pGk36iMVKj/wBJ9ElWUHir4/EZsbCzZCppixuHhCjwdJoL2dIWvSXU
         c1xnAKizgz4upFkM43KI8uFzOdpjxTQtOO6CtXxiSJPMaNg2miv6mqtdPzmN85ksnGSG
         3W6+0zZcocm/D/dgmZTmL3vWmn0W8dDmB9xDD0rAFq+KSwIuYgcl1+MevpkLxew4+sns
         uMlQzc7tNjIVzli50qQbxbN2tfC5JocF/mMT/cCy5770Gjkf4aiiDU8lzEIAwPmkZEWk
         Myiw==
X-Gm-Message-State: AOAM5315ef7PF2UjHqkGT0/MaoY+/cQyoQsPyeG5mVuv5EH+G/G0VDvl
        t/CtQvIYceaLW1Lf3y5JXok=
X-Google-Smtp-Source: ABdhPJwflwJkHBsIUM3AfKCsmVhas3iTzFiAZ7VGP4s3CdExuIz9SJIQtTaFPR25tVN3zkR9UXBvOA==
X-Received: by 2002:a1c:c908:: with SMTP id f8mr14381795wmb.193.1640012594571;
        Mon, 20 Dec 2021 07:03:14 -0800 (PST)
Received: from [10.0.0.4] ([37.165.147.173])
        by smtp.gmail.com with ESMTPSA id o10sm7800585wrc.55.2021.12.20.07.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 07:03:14 -0800 (PST)
Subject: Re: [PATCH v3] net: bonding: Add support for IPV6 ns/na
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f35ef160-ffdb-e6de-6079-440cd72ab389@gmail.com>
Date:   Mon, 20 Dec 2021 07:03:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/17/21 8:48 AM, Sun Shouxin wrote:
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
>                          Border-Leaf
>                          /        \
>                         /          \
>                      Tunnel1    Tunnel2
>                       /              \
>                      /                \
>                    Leaf-1--Tunnel3--Leaf-2
>                      \                /
>                       \              /
>                        \            /
>                         \          /
>                         NIC1    NIC2
>                          \      /
>                          server
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
> Reviewed-by: Jay Vosburgh<jay.vosburgh@canonical.com>
> Reviewed-by: Eric Dumazet<eric.dumazet@gmail.com>


??? I do not recall giving my Reviewed-by:


> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>   drivers/net/bonding/bond_alb.c | 131 +++++++++++++++++++++++++++++++++
>   1 file changed, 131 insertions(+)
>
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 533e476988f2..b14017364594 100644
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
> +			return NULL;
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
>
> base-commit: 6441998e2e37131b0a4c310af9156d79d3351c16
