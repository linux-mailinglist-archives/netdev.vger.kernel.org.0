Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6B67FDFF
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjA2KHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2KHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:07:36 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33361E1D7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:07:34 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mg12so24302241ejc.5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TP9Ml2FDYPGxxKwwrsUwsn2C2bokVxitIs5PgjLkxlA=;
        b=4Sdj/tn8sSo9EuwyIp03S7gRePWwPzbRgppr4OViltqzWyMxoTNzUguKW5I/Y3v6vy
         1mCYJ0+BGf/4YJibhYqg89D4YXBOv1daPxgw+hVktGVSWCi5d0kGFXnnwJT9ow1r1Bdw
         UHUHaEQhbydm4hWDjAMWxtTwbc6rbLwXJgG8IMk3P7ubFuCipeHSPhco52+PXOam2qcB
         hyxHo3LqFvB4ZFlQeGOqiAuNif1o53MqE8XPUEKXaGv0r7/G0k6/2npMwyRvFl3FyOAm
         cPXwoJN96HTLGFcoFoLB8Ukto/o+RXN1AwpDjBWGc27oy+gSYFtBzP2MqCRCfox2FAQx
         +r9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TP9Ml2FDYPGxxKwwrsUwsn2C2bokVxitIs5PgjLkxlA=;
        b=FiWvBOjp/dWTZIuWFpD9tXUHwriGEaxDbAW3z1dAcZHlh2g5/wc3xUXzSt6wdMlLx1
         4dEA+VxdeaOhrIaur3bRVtCp6rnXsBUHPBUbTMyxxDGHApORleGQJwLUjPgbCTMceHHB
         Ua86NgPKKX6PmTnK89ZbxlRwmXK2fVap8z4FXDHHwicDBNPW02DNgGNQaq4YUjKahRr4
         LuF0NZX3c2MzqfATFI5+rV5P0O6ss7831YnaGqqvCRYFRAD2jeQIxydSPwwQxcuzXpln
         B+79K7FeZpettn+F6BxL/NP4ridBHn3atgElcvy8GLsDHg9+mgnErjud9cWsD5QvPFSn
         sjhw==
X-Gm-Message-State: AO0yUKXZG8Ziwsq/pFdFIT85rBMZ6YAXR0Bej54DxYh6uSaw0zaLT02G
        6gFVhQj6FN6eXc66QzjOiq2SJA==
X-Google-Smtp-Source: AK7set+tNBVpRiyUVqGHkZtb8Um1XM4dnKlCH3QVr5qul1NrhYNauwtvY/S/zRyP04uqsJFL+bzKqg==
X-Received: by 2002:a17:906:7806:b0:878:61c4:1bd5 with SMTP id u6-20020a170906780600b0087861c41bd5mr11599592ejm.50.1674986853218;
        Sun, 29 Jan 2023 02:07:33 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id i11-20020a50870b000000b004a0f9d31d18sm4657139edb.71.2023.01.29.02.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:07:32 -0800 (PST)
Message-ID: <e46f0af5-ef19-5260-5524-e53b4e4438f1@blackwall.org>
Date:   Sun, 29 Jan 2023 12:07:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 08/16] net: bridge: Add netlink knobs for number
 / maximum MDB entries
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <1bb4bfeaeb14e4b484c6d71adef0b21686468153.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1bb4bfeaeb14e4b484c6d71adef0b21686468153.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> The previous patch added accounting for number of MDB entries per port and
> per port-VLAN, and the logic to verify that these values stay within
> configured bounds. However it didn't provide means to actually configure
> those bounds or read the occupancy. This patch does that.
> 
> Two new netlink attributes are added for the MDB occupancy:
> IFLA_BRPORT_MCAST_N_GROUPS for the per-port occupancy and
> BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS for the per-port-VLAN occupancy.
> And another two for the maximum number of MDB entries:
> IFLA_BRPORT_MCAST_MAX_GROUPS for the per-port maximum, and
> BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS for the per-port-VLAN one.
> 
> Note that the two new IFLA_BRPORT_ attributes prompt bumping of
> RTNL_SLAVE_MAX_TYPE to size the slave attribute tables large enough.
> 
> The new attributes are used like this:
> 
>  # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
>                                       mcast_vlan_snooping 1 mcast_querier 1
>  # ip link set dev v1 master br
>  # bridge vlan add dev v1 vid 2
> 
>  # bridge vlan set dev v1 vid 1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
>  # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
>  Error: bridge: Port-VLAN is already a member in mcast_max_groups (1) groups.
> 
>  # bridge link set dev v1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
>  Error: bridge: Port is already a member in mcast_max_groups (1) groups.
> 
>  # bridge -d link show
>  5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
>      [...] mcast_n_groups 1 mcast_max_groups 1
> 
>  # bridge -d vlan show
>  port              vlan-id
>  br                1 PVID Egress Untagged
>                      state forwarding mcast_router 1
>  v1                1 PVID Egress Untagged
>                      [...] mcast_n_groups 1 mcast_max_groups 1
>                    2
>                      [...] mcast_n_groups 0 mcast_max_groups 0
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/uapi/linux/if_bridge.h |  2 +
>  include/uapi/linux/if_link.h   |  2 +
>  net/bridge/br_multicast.c      | 96 ++++++++++++++++++++++++++++++++++
>  net/bridge/br_netlink.c        | 19 ++++++-
>  net/bridge/br_private.h        | 16 +++++-
>  net/bridge/br_vlan.c           | 11 ++--
>  net/bridge/br_vlan_options.c   | 33 +++++++++++-
>  net/core/rtnetlink.c           |  2 +-
>  8 files changed, 173 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index d9de241d90f9..d60c456710b3 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -523,6 +523,8 @@ enum {
>  	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
>  	BRIDGE_VLANDB_ENTRY_STATS,
>  	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
> +	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
> +	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
>  	__BRIDGE_VLANDB_ENTRY_MAX,
>  };
>  #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 1021a7e47a86..1bed3a72939c 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -564,6 +564,8 @@ enum {
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
>  	IFLA_BRPORT_LOCKED,
>  	IFLA_BRPORT_MAB,
> +	IFLA_BRPORT_MCAST_N_GROUPS,
> +	IFLA_BRPORT_MCAST_MAX_GROUPS,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index de531109b947..04261dd2380b 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -766,6 +766,102 @@ static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
>  	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
>  }
>  
> +static int
> +br_multicast_pmctx_ngroups_set_max(struct net_bridge_mcast_port *pmctx,
> +				   u32 max, struct netlink_ext_ack *extack)
> +{
> +	if (max && max < pmctx->mdb_n_entries) {
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Can't set mcast_max_groups=%u, which is below mcast_n_groups=%u",
> +				       max, pmctx->mdb_n_entries);

Why not? All new entries will be rejected anyway, at most some will expire and make room.

> +		return -EINVAL;
> +	}
> +
> +	pmctx->mdb_max_entries = max;
> +	return 0;
> +}
> +
> +u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port)
> +{
> +	u32 n;
> +
> +	spin_lock_bh(&port->br->multicast_lock);
> +	n = port->multicast_ctx.mdb_n_entries;
> +	spin_unlock_bh(&port->br->multicast_lock);

This is too much just to read the value, we block all IGMP/MLD processing and potentially
block packet processing on the same core just to read it. These reads are done for notifications,
getlink and also for fill_slave_info. I think we can just use WRITE/READ_ONCE helpers to access
it. Especially since the lock is taken for both values (max and current count). We still get a
snapshop that can be wrong by the time it's returned and about changing it we'll start enforcing
the new limit with a minor delay which is not a big deal.

> +
> +	return n;
> +}
> +
> +int br_multicast_vlan_ngroups_get(struct net_bridge *br,
> +				  const struct net_bridge_vlan *v,
> +				  u32 *n)
> +{
> +	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
> +		return -EINVAL;
> +
> +	spin_lock_bh(&br->multicast_lock);
> +	*n = v->port_mcast_ctx.mdb_n_entries;
> +	spin_unlock_bh(&br->multicast_lock);
> +

ditto and for all accesses below that require the lock..

> +	return 0;
> +}
> +
> +int br_multicast_port_ngroups_set_max(struct net_bridge_port *port, u32 max,
> +				      struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	spin_lock_bh(&port->br->multicast_lock);
> +	err = br_multicast_pmctx_ngroups_set_max(&port->multicast_ctx, max,
> +						 extack);
> +	spin_unlock_bh(&port->br->multicast_lock);
> +
> +	return err;
> +}
> +
> +int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
> +				      struct net_bridge_vlan *v, u32 max,
> +				      struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Multicast snooping disabled on this VLAN");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_bh(&br->multicast_lock);
> +	err = br_multicast_pmctx_ngroups_set_max(&v->port_mcast_ctx, max,
> +						 extack);
> +	spin_unlock_bh(&br->multicast_lock);
> +
> +	return err;
> +}
> +
> +u32 br_multicast_port_ngroups_get_max(const struct net_bridge_port *port)
> +{
> +	u32 max;
> +
> +	spin_lock_bh(&port->br->multicast_lock);
> +	max = port->multicast_ctx.mdb_max_entries;
> +	spin_unlock_bh(&port->br->multicast_lock);


> +
> +	return max;
> +}
> +
> +int br_multicast_vlan_ngroups_get_max(struct net_bridge *br,
> +				      const struct net_bridge_vlan *v,
> +				      u32 *max)
> +{
> +	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
> +		return -EINVAL;
> +
> +	spin_lock_bh(&br->multicast_lock);
> +	*max = v->port_mcast_ctx.mdb_max_entries;
> +	spin_unlock_bh(&br->multicast_lock);


> +
> +	return 0;
> +}
> +
>  static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
>  {
>  	struct net_bridge_port_group *pg;
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index a6133d469885..063c1646dfe8 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -202,6 +202,8 @@ static inline size_t br_port_info_size(void)
>  		+ nla_total_size_64bit(sizeof(u64)) /* IFLA_BRPORT_HOLD_TIMER */
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
> +		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_N_GROUPS */
> +		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_MAX_GROUPS */
>  #endif
>  		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
> @@ -298,7 +300,11 @@ static int br_port_fill_attrs(struct sk_buff *skb,
>  	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
>  			p->multicast_eht_hosts_limit) ||
>  	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
> -			p->multicast_eht_hosts_cnt))
> +			p->multicast_eht_hosts_cnt) ||
> +	    nla_put_u32(skb, IFLA_BRPORT_MCAST_N_GROUPS,
> +			br_multicast_port_ngroups_get(p)) ||
> +	    nla_put_u32(skb, IFLA_BRPORT_MCAST_MAX_GROUPS,
> +			br_multicast_port_ngroups_get_max(p)))
>  		return -EMSGSIZE;
>  #endif
>  
> @@ -883,6 +889,8 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
>  	[IFLA_BRPORT_MAB] = { .type = NLA_U8 },
>  	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
>  	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
> +	[IFLA_BRPORT_MCAST_N_GROUPS] = { .type = NLA_REJECT },
> +	[IFLA_BRPORT_MCAST_MAX_GROUPS] = { .type = NLA_U32 },
>  };
>  
>  /* Change the state of the port and notify spanning tree */
> @@ -1017,6 +1025,15 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
>  		if (err)
>  			return err;
>  	}
> +
> +	if (tb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
> +		u32 max_groups;
> +
> +		max_groups = nla_get_u32(tb[IFLA_BRPORT_MCAST_MAX_GROUPS]);
> +		err = br_multicast_port_ngroups_set_max(p, max_groups, extack);
> +		if (err)
> +			return err;
> +	}
>  #endif
>  
>  	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 49f411a0a1f1..86b7a221e806 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -978,6 +978,19 @@ void br_multicast_uninit_stats(struct net_bridge *br);
>  void br_multicast_get_stats(const struct net_bridge *br,
>  			    const struct net_bridge_port *p,
>  			    struct br_mcast_stats *dest);
> +u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port);
> +int br_multicast_vlan_ngroups_get(struct net_bridge *br,
> +				  const struct net_bridge_vlan *v,
> +				  u32 *n);
> +int br_multicast_port_ngroups_set_max(struct net_bridge_port *port,
> +				      u32 max, struct netlink_ext_ack *extack);
> +int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
> +				      struct net_bridge_vlan *v, u32 max,
> +				      struct netlink_ext_ack *extack);
> +u32 br_multicast_port_ngroups_get_max(const struct net_bridge_port *port);
> +int br_multicast_vlan_ngroups_get_max(struct net_bridge *br,
> +				      const struct net_bridge_vlan *v,
> +				      u32 *max);
>  void br_mdb_init(void);
>  void br_mdb_uninit(void);
>  void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
> @@ -1761,7 +1774,8 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>  bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
>  			   const struct net_bridge_vlan *range_end);
> -bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
> +bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
> +		       const struct net_bridge_port *p);
>  size_t br_vlan_opts_nl_size(void);
>  int br_vlan_process_options(const struct net_bridge *br,
>  			    const struct net_bridge_port *p,
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index bc75fa1e4666..8a3dbc09ba38 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1816,6 +1816,7 @@ static bool br_vlan_stats_fill(struct sk_buff *skb,
>  /* v_opts is used to dump the options which must be equal in the whole range */
>  static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
>  			      const struct net_bridge_vlan *v_opts,
> +			      const struct net_bridge_port *p,
>  			      u16 flags,
>  			      bool dump_stats)
>  {
> @@ -1842,7 +1843,7 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
>  		goto out_err;
>  
>  	if (v_opts) {
> -		if (!br_vlan_opts_fill(skb, v_opts))
> +		if (!br_vlan_opts_fill(skb, v_opts, p))
>  			goto out_err;
>  
>  		if (dump_stats && !br_vlan_stats_fill(skb, v_opts))
> @@ -1925,7 +1926,7 @@ void br_vlan_notify(const struct net_bridge *br,
>  		goto out_kfree;
>  	}
>  
> -	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags, false))
> +	if (!br_vlan_fill_vids(skb, vid, vid_range, v, p, flags, false))
>  		goto out_err;
>  
>  	nlmsg_end(skb, nlh);
> @@ -2030,7 +2031,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
>  
>  			if (!br_vlan_fill_vids(skb, range_start->vid,
>  					       range_end->vid, range_start,
> -					       vlan_flags, dump_stats)) {
> +					       p, vlan_flags, dump_stats)) {
>  				err = -EMSGSIZE;
>  				break;
>  			}
> @@ -2056,7 +2057,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
>  		else if (!dump_global &&
>  			 !br_vlan_fill_vids(skb, range_start->vid,
>  					    range_end->vid, range_start,
> -					    br_vlan_flags(range_start, pvid),
> +					    p, br_vlan_flags(range_start, pvid),
>  					    dump_stats))
>  			err = -EMSGSIZE;
>  	}
> @@ -2131,6 +2132,8 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
>  	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
>  	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
>  	[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]	= { .type = NLA_U8 },
> +	[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]	= { .type = NLA_REJECT },
> +	[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]	= { .type = NLA_U32 },
>  };
>  
>  static int br_vlan_rtm_process_one(struct net_device *dev,
> diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
> index a2724d03278c..43d8f11ce79c 100644
> --- a/net/bridge/br_vlan_options.c
> +++ b/net/bridge/br_vlan_options.c
> @@ -48,7 +48,8 @@ bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
>  	       curr_mc_rtr == range_mc_rtr;
>  }
>  
> -bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
> +bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
> +		       const struct net_bridge_port *p)
>  {
>  	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE, br_vlan_get_state(v)) ||
>  	    !__vlan_tun_put(skb, v))
> @@ -58,6 +59,20 @@ bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
>  	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
>  		       br_vlan_multicast_router(v)))
>  		return false;
> +	if (p && !br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
> +		u32 mdb_max_entries;
> +		u32 mdb_n_entries;
> +
> +		if (br_multicast_vlan_ngroups_get(p->br, v, &mdb_n_entries) ||
> +		    nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
> +				mdb_n_entries))
> +			return false;
> +		if (br_multicast_vlan_ngroups_get_max(p->br, v,
> +						      &mdb_max_entries) ||
> +		    nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
> +				mdb_max_entries))
> +			return false;
> +	}
>  #endif
>  
>  	return true;
> @@ -70,6 +85,8 @@ size_t br_vlan_opts_nl_size(void)
>  	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_TINFO_ID */
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  	       + nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_MCAST_ROUTER */
> +	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS */
> +	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS */
>  #endif
>  	       + 0;
>  }
> @@ -212,6 +229,20 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
>  			return err;
>  		*changed = true;
>  	}
> +	if (tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]) {
> +		u32 val;
> +
> +		if (!p) {
> +			NL_SET_ERR_MSG_MOD(extack, "Can't set mcast_max_groups for non-port vlans");
> +			return -EINVAL;
> +		}
> +
> +		val = nla_get_u32(tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]);
> +		err = br_multicast_vlan_ngroups_set_max(p->br, v, val, extack);
> +		if (err)
> +			return err;
> +		*changed = true;
> +	}
>  #endif
>  
>  	return 0;
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 64289bc98887..e786255a8360 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -58,7 +58,7 @@
>  #include "dev.h"
>  
>  #define RTNL_MAX_TYPE		50
> -#define RTNL_SLAVE_MAX_TYPE	40
> +#define RTNL_SLAVE_MAX_TYPE	42
>  
>  struct rtnl_link {
>  	rtnl_doit_func		doit;

