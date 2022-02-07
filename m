Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9774AB929
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiBGK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244812AbiBGKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:55:54 -0500
X-Greylist: delayed 383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 02:55:52 PST
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B1BC043181;
        Mon,  7 Feb 2022 02:55:52 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 79B445C01E0;
        Mon,  7 Feb 2022 05:49:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 07 Feb 2022 05:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TLHvkqnvKu+Cu1jgu
        lQq7VpWe7mcePPJ4UZ8y6nbUXU=; b=YaT8XGxe2r7OcLMTmBgGzNtKo8z5JtMK2
        20qSf7vcA449F+polHmIDX8Ut43AM7jg5/jShw5neeWKotINsrOmr7wu+vle5jKx
        D1MuSttwfPfCCiXPRDTyCAwzhbGHQC0AbKEB8WuZ9EIyL8HZGGjnPSDZU5S10SFO
        wzW9qzOopd3KB3uacTChG7J/GIQGYGsUyHcaESTvUqHLKlxxfYkYZ3gIIIfdnQ+y
        mrNuSz+3GQFz4cDNBcwRT9X8SRZYplZ72WhZbJb9KqAgJuhjy8DTPPR6IM3um7EL
        GbdG6dYErX6fKUSefgE2XYLLY2DNRYBp1BfqGIxEBgJtfMkVXZZ/g==
X-ME-Sender: <xms:N_kAYhS2OhRBctBZt3ijW2rOoB4AXOGVRWy6Ho-tjlmij9h2dUUnmA>
    <xme:N_kAYqya-9aTBbPxdSsaC3itDgXif2FH2G61_-DhUVkBTFVqlxI3DoPDwKyyWpANt
    wH7MkWWtZ41Jb4>
X-ME-Received: <xmr:N_kAYm27B0z0j4PeTHLXOJkh3HyrskEgPf4LUTT36EopY0VQ0ZKpaz6BWUt696i0Nhyrh8IGEN754atKO1ON-u_Cnh4DNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:N_kAYpAnDuUB5T1nzIcd-dmDokb3QjP8yH5jpIbwSr7vUYtqVuwd7Q>
    <xmx:N_kAYqj8ldN6jr93_YG1B_szJb2kJ6r2BQXPdL5UC8v0vqNwmD99Bw>
    <xmx:N_kAYtofovMcmBtSkBbuakcIiPqorY8xfyFuqcUXNrIrA7QO6XDokQ>
    <xmx:N_kAYlXI0UQYIGFYRhkYcnf1HSe-IG4jVqg2kScXTdW2noT0hjt8Zw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 05:49:26 -0500 (EST)
Date:   Mon, 7 Feb 2022 12:49:22 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/4] net: bridge: Add support for bridge port in
 locked mode
Message-ID: <YgD5MglBy/UbN0uX@shredder>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207100742.15087-2-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 11:07:39AM +0100, Hans Schultz wrote:
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
> index 6218f93f5c1a..8fa2648fbc83 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -532,6 +532,7 @@ enum {
>  	IFLA_BRPORT_GROUP_FWD_MASK,
>  	IFLA_BRPORT_NEIGH_SUPPRESS,
>  	IFLA_BRPORT_ISOLATED,
> +	IFLA_BRPORT_LOCKED,

Please add it at the end to avoid breaking uAPI

>  	IFLA_BRPORT_BACKUP_PORT,
>  	IFLA_BRPORT_MRP_RING_OPEN,
>  	IFLA_BRPORT_MRP_IN_OPEN,
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index b50382f957c1..469e3adbce07 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -69,6 +69,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
>  	enum br_pkt_type pkt_type = BR_PKT_UNICAST;
>  	struct net_bridge_fdb_entry *dst = NULL;
> +	struct net_bridge_fdb_entry *fdb_entry;
>  	struct net_bridge_mcast_port *pmctx;
>  	struct net_bridge_mdb_entry *mdst;
>  	bool local_rcv, mcast_hit = false;
> @@ -81,6 +82,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	if (!p || p->state == BR_STATE_DISABLED)
>  		goto drop;
>  
> +	br = p->br;
> +
>  	brmctx = &p->br->multicast_ctx;
>  	pmctx = &p->multicast_ctx;
>  	state = p->state;
> @@ -88,10 +91,15 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  				&state, &vlan))
>  		goto out;
>  
> +	if (p->flags & BR_PORT_LOCKED) {
> +		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> +		if (!(fdb_entry && fdb_entry->dst == p))
> +			goto drop;

I'm not familiar with 802.1X so I have some questions:

1. Do we need to differentiate between no FDB entry and an FDB entry
pointing to a different port than we expect?

2. Does user space care about SAs that did not pass the check? That is,
does it need to see notifications? Counters?

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
> -- 
> 2.30.2
> 
