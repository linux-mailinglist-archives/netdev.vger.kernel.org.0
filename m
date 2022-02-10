Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCDF4B0845
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiBJIaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:30:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiBJIaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:30:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB215109E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:30:04 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id da4so9577955edb.4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nFVx2uyUwEL9JccJxCnRlNoz/WeSHaDLh1Q2sLN/nLc=;
        b=JeayG2uLl84LlrgN+b3XhZ/aZ35BlX3p/thApDPovpnzz6Q2hYUY31dDcrQWHnHFFy
         qriWgTk3hTEMkzzi4IZSK2yWhWbGwX0By6lqGcWL/Ykoe7XYW1WvZJpcu4fYeC5f4Ewu
         hCH5neeVzlpiIJDE9q02b/fFJaMO5gnGBGRQnbLtb9jNFzk6SkaCQxaciYcBaqeYIJL4
         ngZTsoHGKP5WcJvpJBtzwZtcPj3XVZgUaOLNCRfb1qKmHoA2tqp3XSDaJcykl8qUK79q
         OAHkRoM2i3qmUFxhJu1wNb7U20DYb1xLxt+vYmaS8BXJAkyhqvpoygjWcL7PNUBSRUTi
         NOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nFVx2uyUwEL9JccJxCnRlNoz/WeSHaDLh1Q2sLN/nLc=;
        b=tBfI220W7b7zLmBV4j50hJ+FIKsh04dpUUD9uhnBFRweiDCULD/IOSU0N7TrS/twex
         kgYn1EgYHRP87Tp1fOCMMCrCNgOZ10j2S9xuAox8aYwBeu3+DTSCpM8ZrBbdGarOwBKS
         gWcj6DC8NyvU8z87+SkN/pmTVlzOdPwzb+2VcbI9AJdamsKhnRLBwTT7AV5Hfpw2KepZ
         +HwiA1cSFoRmUHLh13p30Y6wnXhdt9xUPF+zDpYorpCpUVfMHzgV4ZOOm96xirNB95/K
         KE1o00RjIjqJuvklArHnObQDtv0wpA8cyXNfz46xfipYKSr5I8sYmEsY4T4x5GX3ziH/
         FEgA==
X-Gm-Message-State: AOAM53164gqindGGpT1OkOItF9Wh4ile4J9ZLpbpRTzf2GQ7WtOxL1nC
        UVqH2yC6YnKVlxJSE1TVx/HjelG/zpunS2H0nAA=
X-Google-Smtp-Source: ABdhPJz+sKZ2/lzyH0cTED44yAAMbF+VsjDbQ3W6kJBjl9PyJt5JaHSFnE19z0fwH2cQ/f/XIzMTJg==
X-Received: by 2002:a05:6402:50c8:: with SMTP id h8mr7153309edb.144.1644481803111;
        Thu, 10 Feb 2022 00:30:03 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id re22sm3495879ejb.51.2022.02.10.00.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 00:30:02 -0800 (PST)
Message-ID: <c821f05b-94e1-cf48-f2a6-40a689678c2b@blackwall.org>
Date:   Thu, 10 Feb 2022 10:30:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 1/5] net: bridge: Add support for bridge port
 in locked mode
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220209130538.533699-2-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220209130538.533699-2-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:05, Hans Schultz wrote:
> In a 802.1X scenario, clients connected to a bridge port shall not
> be allowed to have traffic forwarded until fully authenticated.
> A static fdb entry of the clients MAC address for the bridge port
> unlocks the client and allows bidirectional communication.
> 
> This scenario is facilitated with setting the bridge port in locked
> mode, which is also supported by various switchcore chipsets.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---

Hi,
I'm writing from my private email because for some reason I'm not receiving the full
patch-set in my nvidia mail, a few comments below..

>  include/linux/if_bridge.h    |  1 +
>  include/uapi/linux/if_link.h |  1 +
>  net/bridge/br_input.c        | 10 +++++++++-
>  net/bridge/br_netlink.c      |  6 +++++-
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 509e18c7e740..3aae023a9353 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -58,6 +58,7 @@ struct br_ip_list {
>  #define BR_MRP_LOST_CONT	BIT(18)
>  #define BR_MRP_LOST_IN_CONT	BIT(19)
>  #define BR_TX_FWD_OFFLOAD	BIT(20)
> +#define BR_PORT_LOCKED		BIT(21)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 6218f93f5c1a..a45cc0a1f415 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -537,6 +537,7 @@ enum {
>  	IFLA_BRPORT_MRP_IN_OPEN,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
> +	IFLA_BRPORT_LOCKED,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index b50382f957c1..469e3adbce07 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -69,6 +69,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
>  	enum br_pkt_type pkt_type = BR_PKT_UNICAST;
>  	struct net_bridge_fdb_entry *dst = NULL;
> +	struct net_bridge_fdb_entry *fdb_entry;

move fdb_entry below to where it is used

>  	struct net_bridge_mcast_port *pmctx;
>  	struct net_bridge_mdb_entry *mdst;
>  	bool local_rcv, mcast_hit = false;
> @@ -81,6 +82,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	if (!p || p->state == BR_STATE_DISABLED)
>  		goto drop;
>  
> +	br = p->br;
> +

please drop the extra new line

>  	brmctx = &p->br->multicast_ctx;
>  	pmctx = &p->multicast_ctx;
>  	state = p->state;
> @@ -88,10 +91,15 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  				&state, &vlan))
>  		goto out;
>  
> +	if (p->flags & BR_PORT_LOCKED) {

fdb_entry should be defined in this scope only, and please rename it to something
like fdb_src or just "src" as we already have "dst".

> +		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> +		if (!(fdb_entry && fdb_entry->dst == p))

if (!fdb_entry || READ_ONCE(fdb_entry->dst) != p

> +			goto drop;
> +	}
> +
>  	nbp_switchdev_frame_mark(p, skb);
>  
>  	/* insert into forwarding database after filtering to avoid spoofing */
> -	br = p->br;
>  	if (p->flags & BR_LEARNING)
>  		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, 0);
>  
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 2ff83d84230d..7d4432ca9a20 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -184,6 +184,7 @@ static inline size_t br_port_info_size(void)
>  		+ nla_total_size(1)	/* IFLA_BRPORT_VLAN_TUNNEL */
>  		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_SUPPRESS */
>  		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
> +		+ nla_total_size(1)	/* IFLA_BRPORT_LOCKED */
>  		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
>  		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
>  		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
> @@ -269,7 +270,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
>  							  BR_MRP_LOST_CONT)) ||
>  	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
>  		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
> -	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
> +	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
> +	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)))
>  		return -EMSGSIZE;
>  
>  	timerval = br_timer_value(&p->message_age_timer);
> @@ -827,6 +829,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
>  	[IFLA_BRPORT_GROUP_FWD_MASK] = { .type = NLA_U16 },
>  	[IFLA_BRPORT_NEIGH_SUPPRESS] = { .type = NLA_U8 },
>  	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
> +	[IFLA_BRPORT_LOCKED] = { .type = NLA_U8 },
>  	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
>  	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
>  };
> @@ -893,6 +896,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
>  	br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
>  	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
>  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
> +	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
>  
>  	changed_mask = old_flags ^ p->flags;
>  

Thanks,
 Nik
