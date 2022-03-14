Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4474A4D8814
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbiCNPcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiCNPcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:32:07 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F31AF19;
        Mon, 14 Mar 2022 08:30:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C5C633200583;
        Mon, 14 Mar 2022 11:30:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 14 Mar 2022 11:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pEToz/RLY6LFPSFhK
        SUFSFy9Ab9OvwzMQVPbQ7N0Y0w=; b=S/6p7N5kFPA3uChrVyQtn/rnjAMnHfA1g
        jplH1MadhbhRYELfvfDWQnMoAimlhvvt79ogseAIza1GKpmgUzwqGQ4Y+4t70CVe
        dedzEfWWTPtY8CHVyh1fyyl8gvj5S7y+pmOrjy0Qa2K2wtVpDNYwYB5RCZHXlhq9
        +jTEfYluqNpvvg+bHvYlR+JIUccw1qyfeg6aeL7Sb6WYxRD/FxhKY2HVEiPFvjiS
        /dLbOornuOu2kw82ttC2hRdVj3Dq0zAF8Qx2GbmVj8fpE7mBuOhW3tbFeDHFGd9U
        hkSkIIYGS+OKUaJfm7XkjKUp8ix8NLGbu3k0GqXla/puDSHJQ0ePg==
X-ME-Sender: <xms:rV8vYmtka-43_JCKySr_kMEJbJeUkQ3YTT-F3LXDfcLlc4CNkTeuWg>
    <xme:rV8vYrf_i6S658A0MzdVN9sI5IvnpYHYt4_nYk206S2YIr5WdYTIj8mjCn81-4jhU
    z5K4CI383GoANQ>
X-ME-Received: <xmr:rV8vYhyjbj24W4YxdSZZFsqryPTrDvoiRCymLSWAyfXGJxc62K2EjW-wnZf0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rV8vYhMHWnkoreSC-dAIr0OlTTrMEMVZ_YyDLICKYN-tepsVXr7dUA>
    <xmx:rV8vYm_Zd8k_d2dRODlplnWgo_kyxciZ27eaUgQl4JfxHGR-mvnOog>
    <xmx:rV8vYpXqm6oy5oDPpWyIKU6XCEPyi9ckOmsFGK3f5aFTE6NZLhynuA>
    <xmx:rl8vYqUDJpzFYodJKvdhDYLMSoj4t6GL8ne20qgT1cQJxoRZwULgOQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 11:30:52 -0400 (EDT)
Date:   Mon, 14 Mar 2022 17:30:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked
 port feature
Message-ID: <Yi9fqkQ9wH3Duqhg@shredder>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 03:23:18PM +0100, Hans Schultz wrote:
> Add an intermediate state for clients behind a locked port to allow for
> possible opening of the port for said clients. This feature corresponds
> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> latter defined by Cisco.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  include/uapi/linux/neighbour.h |  1 +
>  net/bridge/br_fdb.c            |  6 ++++++
>  net/bridge/br_input.c          | 11 ++++++++++-
>  net/bridge/br_private.h        |  3 ++-
>  4 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index db05fb55055e..83115a592d58 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -208,6 +208,7 @@ enum {
>  	NFEA_UNSPEC,
>  	NFEA_ACTIVITY_NOTIFY,
>  	NFEA_DONT_REFRESH,
> +	NFEA_LOCKED,
>  	__NFEA_MAX
>  };
>  #define NFEA_MAX (__NFEA_MAX - 1)
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..396dcf3084cf 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>  	struct nda_cacheinfo ci;
>  	struct nlmsghdr *nlh;
>  	struct ndmsg *ndm;
> +	u8 ext_flags = 0;
>  
>  	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>  	if (nlh == NULL)
> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>  		ndm->ndm_flags |= NTF_EXT_LEARNED;
>  	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>  		ndm->ndm_flags |= NTF_STICKY;
> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
> +		ext_flags |= 1 << NFEA_LOCKED;
>  
>  	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>  		goto nla_put_failure;
>  	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>  		goto nla_put_failure;
> +	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
> +		goto nla_put_failure;
> +
>  	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>  	ci.ndm_confirmed = 0;
>  	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..897908484b18 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	struct net_bridge_mcast *brmctx;
>  	struct net_bridge_vlan *vlan;
>  	struct net_bridge *br;
> +	unsigned long flags = 0;
>  	u16 vid = 0;
>  	u8 state;
>  
> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>  
>  		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
> +			if (!fdb_src) {
> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);

This flag is read-only for user space, right? That is, the kernel needs
to reject it during netlink policy validation.

> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
> +			}
>  			goto drop;
> +		} else {

IIUC, we get here in case there is a non-local FDB entry with the SA
that points to our port. Can you write it as:

if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
    	if (!fdb_src) {
	...
	}
	goto drop;
}

> +			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
> +				goto drop;
> +		}
>  	}
>  
>  	nbp_switchdev_frame_mark(p, skb);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 48bc61ebc211..f5a0b68c4857 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -248,7 +248,8 @@ enum {
>  	BR_FDB_ADDED_BY_EXT_LEARN,
>  	BR_FDB_OFFLOADED,
>  	BR_FDB_NOTIFY,
> -	BR_FDB_NOTIFY_INACTIVE
> +	BR_FDB_NOTIFY_INACTIVE,
> +	BR_FDB_ENTRY_LOCKED,
>  };
>  
>  struct net_bridge_fdb_key {
> -- 
> 2.30.2
> 
