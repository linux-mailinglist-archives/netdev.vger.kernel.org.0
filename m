Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB00D4FB603
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbiDKIfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241378AbiDKIfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:35:36 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E40138D81
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:33:23 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4673F3201DFD;
        Mon, 11 Apr 2022 04:33:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Apr 2022 04:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649666001; x=
        1649752401; bh=63DL3gXe7MJNSMKanG26OImrqCC36Hcg2tJwp9gTWBE=; b=K
        cDGr/e949d97dbVz8Wn4LtQsQVvRVoEbP8Ps/U9gBYxdloPnwkce6oJsiiPuhbA2
        cr9bQH4Zs72hhB2fKwoervmonih6C0UTSzhjcScIgXCagLYlcXbcO6kABLL/6KXg
        YuUm+Kz2rn5aciVNoIghnAPQuok39zrJGSkAEKza4NXLhhlkh11UdTm3cuNTuJ7N
        /VY4fOyeWIsYuVMYwo84w1DiT4DdXmcA88wC92g2X5eDch0sR/++Q0pZlvsEEhEq
        mfvRPcX0PqT+AcUp2fs1+9OBSEfE/5CALXVH3HZvckvuIQRA6Bk06H4pnA+xxnhp
        d/fPDhFjR/g+Q+AxKMt6Q==
X-ME-Sender: <xms:0edTYjEOEOvP7_i0INKSVJrevGFN0Sp-Q6_SB3dXOlJJZL9fCSWXmw>
    <xme:0edTYgUtuF3QCWHJhradBdzXMLY7GsBAGSkL7s2hHFkB2Km-sgkHC0MrOJtqfcx8l
    sD47O4SyRTtfvE>
X-ME-Received: <xmr:0edTYlIB2i3TZ6cPAyWIT0_wmt7A7sM5qymQ1MM1x0bXs3XlyF9t0mXxtorx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfevgfevueduueffieffheeifffgje
    elvedtteeuteeuffekvefggfdtudfgkeevnecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0edTYhGoffvzS5IdQ8VY9hAelEQlkmyfsfao1_dvByB2QO0MK_zvWw>
    <xmx:0edTYpWZb-PeOKYLJgnhf_JQgk8BNfOWyiC4Z4F4HxPxQMO_WxAU7A>
    <xmx:0edTYsPewmZBjGXy_xC5TCxX-SpjYOsj8YgsGU5-ukSsG1ZrLNzVCQ>
    <xmx:0edTYsQ5UXwgyAzCk6JS1sX1y3WfhLE40_exdYFVnSSecsvmTNRO6Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:33:20 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:33:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/6] net: bridge: fdb: add new nl
 attribute-based flush call
Message-ID: <YlPnznOq3k8KZg2n@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-4-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105857.803667-4-razor@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:54PM +0300, Nikolay Aleksandrov wrote:
> Add a new fdb flush call which parses the embedded attributes in
> BRIDGE_FLUSH_FDB and fills in the fdb flush descriptor to delete only
> matching entries. Currently it's a complete flush, support for more
> fine-grained filtering will be added in the following patches.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  include/uapi/linux/if_bridge.h |  8 ++++++++
>  net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
>  net/bridge/br_netlink.c        |  8 ++++++++
>  net/bridge/br_private.h        |  2 ++
>  4 files changed, 42 insertions(+)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 221a4256808f..2f3799cf14b2 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -807,7 +807,15 @@ enum {
>  /* embedded in IFLA_BRIDGE_FLUSH */
>  enum {
>  	BRIDGE_FLUSH_UNSPEC,
> +	BRIDGE_FLUSH_FDB,
>  	__BRIDGE_FLUSH_MAX
>  };
>  #define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
> +
> +/* embedded in BRIDGE_FLUSH_FDB */
> +enum {
> +	FDB_FLUSH_UNSPEC,
> +	__FDB_FLUSH_MAX
> +};
> +#define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
>  #endif /* _UAPI_LINUX_IF_BRIDGE_H */
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 4b0bf88c4121..62f694a739e1 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -594,6 +594,30 @@ void br_fdb_flush(struct net_bridge *br,
>  	rcu_read_unlock();
>  }
>  
> +static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
> +	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
> +};
> +
> +int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *fdb_flush_tb[FDB_FLUSH_MAX + 1];
> +	struct net_bridge_fdb_flush_desc desc = {};
> +	int err;
> +
> +	err = nla_parse_nested(fdb_flush_tb, FDB_FLUSH_MAX, fdb_flush_attr,
> +			       br_fdb_flush_policy, extack);
> +	if (err)
> +		return err;
> +
> +	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
> +		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
> +
> +	br_fdb_flush(br, &desc);
> +
> +	return 0;
> +}
> +
>  /* Flush all entries referring to a specific port.
>   * if do_all is set also flush static entries
>   * if vid is set delete all entries that match the vlan_id
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 6e6dce6880c9..bd2c91e5723d 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -781,6 +781,7 @@ int br_process_vlan_info(struct net_bridge *br,
>  
>  static const struct nla_policy br_flush_policy[BRIDGE_FLUSH_MAX + 1] = {
>  	[BRIDGE_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
> +	[BRIDGE_FLUSH_FDB]	= { .type = NLA_NESTED },

In a previous submission [1] Jakub suggested using NLA_POLICY_NESTED()

[1] https://lore.kernel.org/netdev/20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

>  };
>  
>  static int br_flush(struct net_bridge *br, int cmd,
> @@ -804,6 +805,13 @@ static int br_flush(struct net_bridge *br, int cmd,
>  	if (err)
>  		return err;
>  
> +	if (flush_tb[BRIDGE_FLUSH_FDB]) {
> +		err = br_fdb_flush_nlattr(br, flush_tb[BRIDGE_FLUSH_FDB],
> +					  extack);
> +		if (err)
> +			return err;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index e6930e9ee69d..c7ea531d30ef 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -768,6 +768,8 @@ int br_fdb_hash_init(struct net_bridge *br);
>  void br_fdb_hash_fini(struct net_bridge *br);
>  void br_fdb_flush(struct net_bridge *br,
>  		  const struct net_bridge_fdb_flush_desc *desc);
> +int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
> +			struct netlink_ext_ack *extack);
>  void br_fdb_find_delete_local(struct net_bridge *br,
>  			      const struct net_bridge_port *p,
>  			      const unsigned char *addr, u16 vid);
> -- 
> 2.35.1
> 
