Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBBC4FB5D8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343688AbiDKIXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343687AbiDKIXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:23:08 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247803E0F1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:20:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 5AAED3201F27;
        Mon, 11 Apr 2022 04:20:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 11 Apr 2022 04:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649665251; x=
        1649751651; bh=dHdCNUO3dPTJm9yrEeHeG1wWaiGHm3Q9QFpcLvdPavA=; b=e
        V+FCzUjqDsYK8Tbxj2R0vTH01vkX02gbiXvapts+duoiQKvaDXhnZwbmh3bPh5QT
        vzeQD+InZNKjKM7d2Ktj27QdPuwr6R90Ejeez3zZmWSBULEhUGvVB6AL+McfBH4p
        YkUfHAjaQf8ihn8qg79cnFDN0N5Yi8ap59RiiOP1+S4piU5OTFbflA1jc8/svBni
        kjiOjSrvZRYFy79c+LmNhC3M+6xCGgUJLC27JsadvXlu/SX7n+tnT+TBpJwrfJqF
        SpQB3ttU9psmKZwW07PCRdd29JbQIaohKYTjmtuPWuM2WPc9FLqyur4BVMLHt2tZ
        xVJdwkZHrZ/+CrohFUSvA==
X-ME-Sender: <xms:4-RTYv4x6DIVYKTY0UhN0i3pKCJeXhD9wVzaaiqEuEGNPHuyviMysQ>
    <xme:4-RTYk6Z5evFQ3bFRye_b2TkUEotKipPK5U3Ibxs8i-7iujIeCUWHI1c9iIgOlCw1
    pb9m8g6YoOfD-k>
X-ME-Received: <xmr:4-RTYmeyxqfnrHX1a41gMdw6vbvf60Pl4wOenR5sZR5Qh-nshExTxXgXiUbE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4-RTYgLsuQGa0mLyc0cvjZ79qKZ0575fLv1tphwSoQykLcPKSNEvSQ>
    <xmx:4-RTYjINT1C3YoERrDifRyLG29nnMw7YI1qlg4Kmoc9dMX6fOIo3EQ>
    <xmx:4-RTYpwmgj5aJsUkoEPrSweqmcyRZZarKE_uROhfnOt_AE5JjeFY1g>
    <xmx:4-RTYr1D9kI4CqpOa5nEPSmXK-FfMj4LqHXHcGhwQaQNUMhZQEYlnw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:20:51 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:20:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 2/6] net: bridge: fdb: add support for
 fine-grained flushing
Message-ID: <YlPk4GGqcAGCEZ4s@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-3-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105857.803667-3-razor@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:53PM +0300, Nikolay Aleksandrov wrote:
> Add the ability to specify exactly which fdbs to be flushed. They are
> described by a new structure - net_bridge_fdb_flush_desc. Currently it
> can match on port/bridge ifindex, vlan id and fdb flags. It is used to
> describe the existing dynamic fdb flush operation.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  net/bridge/br_fdb.c      | 36 +++++++++++++++++++++++++++++-------
>  net/bridge/br_netlink.c  |  9 +++++++--
>  net/bridge/br_private.h  | 10 +++++++++-
>  net/bridge/br_sysfs_br.c |  6 +++++-
>  4 files changed, 50 insertions(+), 11 deletions(-)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..4b0bf88c4121 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -558,18 +558,40 @@ void br_fdb_cleanup(struct work_struct *work)
>  	mod_delayed_work(system_long_wq, &br->gc_work, work_delay);
>  }
>  
> -/* Completely flush all dynamic entries in forwarding database.*/
> -void br_fdb_flush(struct net_bridge *br)
> +static bool __fdb_flush_matches(const struct net_bridge *br,
> +				const struct net_bridge_fdb_entry *f,
> +				const struct net_bridge_fdb_flush_desc *desc)
> +{
> +	const struct net_bridge_port *dst = READ_ONCE(f->dst);
> +	int port_ifidx, br_ifidx = br->dev->ifindex;
> +
> +	port_ifidx = dst ? dst->dev->ifindex : 0;
> +
> +	return (!desc->vlan_id || desc->vlan_id == f->key.vlan_id) &&
> +	       (!desc->port_ifindex ||
> +		(desc->port_ifindex == port_ifidx ||
> +		 (!dst && desc->port_ifindex == br_ifidx))) &&
> +	       (!desc->flags_mask ||
> +		((f->flags & desc->flags_mask) == desc->flags));

I find this easier to read:

port_ifidx = dst ? dst->dev->ifindex : br_ifidx;

if (desc->vlan_id && desc->vlan_id != f->key.vlan_id)
	return false;
if (desc->port_ifindex && desc->port_ifindex != port_ifidx)
	return false;
if (desc->flags_mask && (f->flags & desc->flags_mask) != desc->flags)
	return false;

return true;

> +}
> +
> +/* Flush forwarding database entries matching the description */
> +void br_fdb_flush(struct net_bridge *br,
> +		  const struct net_bridge_fdb_flush_desc *desc)
>  {
>  	struct net_bridge_fdb_entry *f;
> -	struct hlist_node *tmp;
>  
> -	spin_lock_bh(&br->hash_lock);
> -	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
> -		if (!test_bit(BR_FDB_STATIC, &f->flags))
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
> +		if (!__fdb_flush_matches(br, f, desc))
> +			continue;
> +
> +		spin_lock_bh(&br->hash_lock);
> +		if (!hlist_unhashed(&f->fdb_node))
>  			fdb_delete(br, f, true);
> +		spin_unlock_bh(&br->hash_lock);
>  	}
> -	spin_unlock_bh(&br->hash_lock);
> +	rcu_read_unlock();
>  }
>  
>  /* Flush all entries referring to a specific port.
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index fe2211d4c0c7..6e6dce6880c9 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1366,8 +1366,13 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>  		br_recalculate_fwd_mask(br);
>  	}
>  
> -	if (data[IFLA_BR_FDB_FLUSH])
> -		br_fdb_flush(br);
> +	if (data[IFLA_BR_FDB_FLUSH]) {
> +		struct net_bridge_fdb_flush_desc desc = {
> +			.flags_mask = BR_FDB_STATIC
> +		};
> +
> +		br_fdb_flush(br, &desc);

I wanted to ask why you are not doing the same for IFLA_BRPORT_FLUSH,
but then I read the implementation of br_fdb_delete_by_port() and
remembered the comment in the cover letter regarding fdb_delete vs
fdb_delete_local. Probably best to note it in the commit message

> +	}
>  
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  	if (data[IFLA_BR_MCAST_ROUTER]) {
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 6e62af2e07e9..e6930e9ee69d 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -274,6 +274,13 @@ struct net_bridge_fdb_entry {
>  	struct rcu_head			rcu;
>  };
>  
> +struct net_bridge_fdb_flush_desc {
> +	unsigned long			flags;
> +	unsigned long			flags_mask;
> +	int				port_ifindex;
> +	u16				vlan_id;
> +};
> +
>  #define MDB_PG_FLAGS_PERMANENT	BIT(0)
>  #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
>  #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
> @@ -759,7 +766,8 @@ int br_fdb_init(void);
>  void br_fdb_fini(void);
>  int br_fdb_hash_init(struct net_bridge *br);
>  void br_fdb_hash_fini(struct net_bridge *br);
> -void br_fdb_flush(struct net_bridge *br);
> +void br_fdb_flush(struct net_bridge *br,
> +		  const struct net_bridge_fdb_flush_desc *desc);
>  void br_fdb_find_delete_local(struct net_bridge *br,
>  			      const struct net_bridge_port *p,
>  			      const unsigned char *addr, u16 vid);
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 3f7ca88c2aa3..612e367fff20 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -344,7 +344,11 @@ static DEVICE_ATTR_RW(group_addr);
>  static int set_flush(struct net_bridge *br, unsigned long val,
>  		     struct netlink_ext_ack *extack)
>  {
> -	br_fdb_flush(br);
> +	struct net_bridge_fdb_flush_desc desc = {
> +		.flags_mask = BR_FDB_STATIC
> +	};
> +
> +	br_fdb_flush(br, &desc);
>  	return 0;
>  }
>  
> -- 
> 2.35.1
> 
