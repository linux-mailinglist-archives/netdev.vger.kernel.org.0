Return-Path: <netdev+bounces-12117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180AF7363DA
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE8DE280F85
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29071FDC;
	Tue, 20 Jun 2023 06:55:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEBE1119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:55:37 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC2BE4D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:55:35 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-98862e7e3e6so342729166b.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1687244134; x=1689836134;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2IWzpQzZOfqthI1KIAwxlpiFO6S86wzjJ+IZ4AoJBy8=;
        b=ze29EKa1STK6AdFKQC27Mk1K9TTO7UsX6Lmt9ZCRL6JnDKgXWWFTcUiKhuIcIqkvAu
         a1PC3gKioPz7WrLHm1GCS8dfNUo9WWvmjdQJCZ5sIV+Ahp187WPTyhla44IgwdL0nhVq
         /dfB/fx753jE8MjZu0AsL+UbHGbwSl6Bb95F5thsEYEGS+BeR0thsXYbG78ElY2QNP0T
         cnby35DbSZGCVDAp5zJv55SuxJLA7B+MWlJdeIxWdh5FWUa15HoBbAgVdcp/favALavJ
         HP7QQA7LFxhK+K/Dtxnr8ofVz2rpXTKaiEtCSs8tztSXGJBBilPctAjiQSH3UdS8HiPH
         Q50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687244134; x=1689836134;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2IWzpQzZOfqthI1KIAwxlpiFO6S86wzjJ+IZ4AoJBy8=;
        b=Zt90t9LBhxmcTwSeNVc4PSUvAhw2WSTO+VwNNzwBSUl/1s/jhAGmxH2JJ6Deyc02KD
         dR9WaWIzmQvHy1rhzC9hweAnBmGzcmq09XKQwzsWNBsbnGSXfNMqc+52U9LnBpQO/o59
         YMTz3WPSDq30BA5Ni40CZnfgKQhw/HchaaNXTT4N7SZfmPO2CdIyBGuepuVB/FQHafzd
         AzmpfoRLG9Qfs1F2+XKKUt87W+Tch25nwtpvOgoE9hXoj08+qE1lQHCoP5IOB/3klg6l
         wf3sHdBCbRuCCjvlc7oZobYLjE1LxcVOFXabqH7TAN0J4oN61yR72P50JuIAE+TzZrUu
         SNkg==
X-Gm-Message-State: AC+VfDwOIzWUjQl4t6FD8W5iavkDNkgIoFwzMb33ST4RljChCN1RAYWG
	k9yFKf6vTiafqS6ib5N8dn1Q3g==
X-Google-Smtp-Source: ACHHUZ5Ado+kaR/Ce2adf16V6Kl7k1dlj/nOgtVMTi3fUD3FdS+8N6c9kcK3AAwUyVHKbhMmccFF4Q==
X-Received: by 2002:a17:906:4fc5:b0:974:4f34:b043 with SMTP id i5-20020a1709064fc500b009744f34b043mr11795119ejw.1.1687244133491;
        Mon, 19 Jun 2023 23:55:33 -0700 (PDT)
Received: from [192.168.8.136] ([37.63.21.25])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906b21000b00988b57d5146sm799933ejz.5.2023.06.19.23.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 23:55:33 -0700 (PDT)
Message-ID: <aac18591-b06b-d48d-368a-99fc3ac50e24@blackwall.org>
Date: Tue, 20 Jun 2023 09:55:31 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 2/3] bridge: Add a limit on learned FDB
 entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>, bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
 Vladimir Oltean <vladimir.oltean@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
 <20230619071444.14625-3-jnixdorf-oss@avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230619071444.14625-3-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 10:14, Johannes Nixdorf wrote:
> A malicious actor behind one bridge port may spam the kernel with packets
> with a random source MAC address, each of which will create an FDB entry,
> each of which is a dynamic allocation in the kernel.
> 
> There are roughly 2^48 different MAC addresses, further limited by the
> rhashtable they are stored in to 2^31. Each entry is of the type struct
> net_bridge_fdb_entry, which is currently 128 bytes big. This means the
> maximum amount of memory allocated for FDB entries is 2^31 * 128B =
> 256GiB, which is too much for most computers.
> 
> Mitigate this by adding a bridge netlink setting
> IFLA_BR_FDB_MAX_LEARNED_ENTRIES, which, if nonzero, limits the amount
> of learned entries to a user specified maximum.
> 
> For backwards compatibility the default setting of 0 disables the limit.
> 
> User-added entries by netlink or from bridge or bridge port addresses
> are never blocked and do not count towards that limit.
> 
> All changes to fdb_n_entries are under br->hash_lock, which means we do
> not need additional locking. The call paths are (✓ denotes that
> br->hash_lock is taken around the next call):
> 
>   - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
>                  |                     +- br_fdb_change_mac_address ✓
>                  |                     +- br_fdb_delete_by_port ✓
>                  +- br_fdb_find_delete_local ✓
>                  +- fdb_add_local <-+- br_fdb_changeaddr ✓
>                  |                  +- br_fdb_change_mac_address ✓
>                  |                  +- br_fdb_add_local ✓
>                  +- br_fdb_cleanup ✓
>                  +- br_fdb_flush ✓
>                  +- br_fdb_delete_by_port ✓
>                  +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
>                  +- br_fdb_external_learn_del ✓
>   - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
>                  |                  +- br_fdb_change_mac_address ✓
>                  |                  +- br_fdb_add_local ✓
>                  +- br_fdb_update ✓
>                  +- fdb_add_entry <--- __br_fdb_add ✓
>                  +- br_fdb_external_learn_add ✓
> 
> The flags that imply an entry does not come from learning
> (BR_FDB_NOT_LEARNED_MASK) are now only set or cleared under br->hash_lock
> as well, and when the boolean value of (fdb->flags &
> BR_FDB_NOT_LEARNED_MASK) changes the accounting is updated.
> 
> This introduces one additional locked update in br_fdb_update if
> BR_FDB_ADDED_BY_USER was set. This is only the case when creating a new
> entry via netlink, and never in the packet handling fast path.
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> 
> ---
> 
> Changes since v1:
>   - Do not initialize fdb_*_entries to 0. (from review)
>   - Do not skip decrementing on 0. (from review)
>   - Moved the counters to a conditional hole in struct net_bridge to
>     avoid growing the struct. (from review, it still grows the struct as
>     there are 2 32-bit values)
>   - Add IFLA_BR_FDB_CUR_LEARNED_ENTRIES (from review)
>   - Fix br_get_size()
>   - Only limit learned entries, rename to
>     *_(CUR|MAX)_LEARNED_ENTRIES. (from review)
> 
> Obsolete v1 review comments:
>   - Return better errors to users: Due to limiting the limit to
>     automatically created entries, netlink fdb add requests and changing
>     bridge ports are never rejected, so they do not yet need a more
>     friendly error returned.
> 
>   include/uapi/linux/if_link.h |  2 ++
>   net/bridge/br_fdb.c          | 67 +++++++++++++++++++++++++++++++++---
>   net/bridge/br_netlink.c      | 13 ++++++-
>   net/bridge/br_private.h      |  6 ++++
>   4 files changed, 83 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4ac1000b0ef2..165b9014379b 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -510,6 +510,8 @@ enum {
>   	IFLA_BR_VLAN_STATS_PER_PORT,
>   	IFLA_BR_MULTI_BOOLOPT,
>   	IFLA_BR_MCAST_QUERIER_STATE,
> +	IFLA_BR_FDB_CUR_LEARNED_ENTRIES,
> +	IFLA_BR_FDB_MAX_LEARNED_ENTRIES,
>   	__IFLA_BR_MAX,
>   };
>   
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index ac1dc8723b9c..bc61d1fd5fcf 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -301,6 +301,38 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>   	}
>   }
>   
> +/* Set a FDB flag that implies the entry was not learned, and account
> + * for changes in the learned status.
> + */
> +static void __fdb_set_flag_not_learned(struct net_bridge *br,
> +				       struct net_bridge_fdb_entry *fdb,
> +				       long nr)
> +{
> +	WARN_ON_ONCE(!(BIT(nr) & BR_FDB_NOT_LEARNED_MASK));

Please use *_bit

> +
> +	/* learned before, but we set a flag that implies it's manually added */
> +	if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))

Please use *_bit

> +		br->fdb_cur_learned_entries--;
> +	set_bit(nr, &fdb->flags);
> +}

Having a helper that conditionally decrements only is counterintuitive 
and people can get confused. Either add 2 helpers for inc/dec and use
them where appropriate or don't use helpers at all.

> +
> +/* Set a FDB flag that implies the entry was not learned, and account
> + * for changes in the learned status.
> + *
> + * This function takes a lock, so ensure it is not called in the fast
> + * path.
> + */
> +static void fdb_set_flag_not_learned(struct net_bridge *br,
> +				     struct net_bridge_fdb_entry *fdb,
> +				     long nr)
> +{
> +	spin_lock_bh(&br->hash_lock);
> +
> +	__fdb_set_flag_not_learned(br, fdb, nr);
> +

Unnecessary empty lines

> +	spin_unlock_bh(&br->hash_lock);
> +}
> +
>   /* When a static FDB entry is deleted, the HW address from that entry is
>    * also removed from the bridge private HW address list and updates all
>    * the ports with needed information.
> @@ -321,6 +353,8 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>   static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>   		       bool swdev_notify)
>   {
> +	bool learned = !(f->flags & BR_FDB_NOT_LEARNED_MASK);

*_bit

> +
>   	trace_fdb_delete(br, f);
>   
>   	if (test_bit(BR_FDB_STATIC, &f->flags))
> @@ -329,11 +363,16 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>   	hlist_del_init_rcu(&f->fdb_node);
>   	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>   			       br_fdb_rht_params);
> +	br->fdb_cur_learned_entries -= learned;

This looks confusing because of the conditional above, as I mentioned 
please make it explicit.

>   	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
>   	call_rcu(&f->rcu, fdb_rcu_free);
>   }
>   
> -/* Delete a local entry if no other port had the same address. */
> +/* Delete a local entry if no other port had the same address.
> + *
> + * This function should only be called on entries with BR_FDB_LOCAL set,
> + * so clear_bit never removes the last bit in BR_FDB_NOT_LEARNED_MASK.
> + */
>   static void fdb_delete_local(struct net_bridge *br,
>   			     const struct net_bridge_port *p,
>   			     struct net_bridge_fdb_entry *f)
> @@ -390,6 +429,11 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>   {
>   	struct net_bridge_fdb_entry *fdb;
>   	int err;
> +	bool learned = !(flags & BR_FDB_NOT_LEARNED_MASK);
> +

*_bit and also use reverse xmas tree order for local variables

> +	if (unlikely(learned && br->fdb_max_learned_entries &&
> +		     br->fdb_cur_learned_entries >= br->fdb_max_learned_entries))
> +		return NULL;
>   
>   	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
>   	if (!fdb)
> @@ -409,6 +453,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>   
>   	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
>   
> +	br->fdb_cur_learned_entries += learned;

I'd prefer to be explicit heere instead of adding a bool

> +
>   	return fdb;
>   }
>   
> @@ -894,7 +940,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>   			}
>   
>   			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
> -				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +				fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);

Unacceptable to take hash_lock and block all learning here, eventual 
consistency is ok or some other method that is much lighter and doesn't
block all learning or requires a lock.

>   			if (unlikely(fdb_modified)) {
>   				trace_br_fdb_update(br, source, addr, vid, flags);
>   				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
> @@ -1070,6 +1116,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>   			modified = true;
>   		}
>   
> +		if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))

*_bit

> +			br->fdb_cur_learned_entries--; >   		set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);

This looks like open-coded version of the helper above.

>   	}
>   
> @@ -1440,10 +1488,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>   		}
>   
>   		if (swdev_notify)
> -			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +			__fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
>   
>   		if (!p)
> -			set_bit(BR_FDB_LOCAL, &fdb->flags);
> +			__fdb_set_flag_not_learned(br, fdb, BR_FDB_LOCAL);
>   
>   		if (modified)
>   			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
> @@ -1508,3 +1556,14 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
>   	spin_unlock_bh(&p->br->hash_lock);
>   }
>   EXPORT_SYMBOL_GPL(br_fdb_clear_offload);
> +
> +u32 br_fdb_get_cur_learned_entries(struct net_bridge *br)
> +{
> +	u32 ret;
> +
> +	spin_lock_bh(&br->hash_lock);
> +	ret = br->fdb_cur_learned_entries;
> +	spin_unlock_bh(&br->hash_lock);
> +
> +	return ret;
> +}

It's unnecessary to take lock to read the value, it'd be better to have
inaccurate result and read it without locking and blocking learning.

> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 05c5863d2e20..954c468d52ec 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1527,6 +1527,12 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>   			return err;
>   	}
>   
> +	if (data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]) {
> +		u32 val = nla_get_u32(data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]);
> +
> +		br->fdb_max_learned_entries = val;
> +	}

Here you change the value without any locking, while you check it with 
locks held - kcsan won't be happy.

> +
>   	return 0;
>   }
>   
> @@ -1581,6 +1587,8 @@ static size_t br_get_size(const struct net_device *brdev)
>   	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_TOPOLOGY_CHANGE_TIMER */
>   	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_GC_TIMER */
>   	       nla_total_size(ETH_ALEN) +       /* IFLA_BR_GROUP_ADDR */
> +	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_CUR_LEARNED_ENTRIES */
> +	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_MAX_LEARNED_ENTRIES */
>   #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>   	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_ROUTER */
>   	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_SNOOPING */
> @@ -1620,6 +1628,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>   	u32 stp_enabled = br->stp_enabled;
>   	u16 priority = (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1];
>   	u8 vlan_enabled = br_vlan_enabled(br->dev);
> +	u32 fdb_cur_learned_entries = br_fdb_get_cur_learned_entries(br);
>   	struct br_boolopt_multi bm;
>   	u64 clockval;
>   
> @@ -1656,7 +1665,9 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>   	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
>   		       br->topology_change_detected) ||
>   	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
> -	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
> +	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
> +	    nla_put_u32(skb, IFLA_BR_FDB_CUR_LEARNED_ENTRIES, fdb_cur_learned_entries) ||
> +	    nla_put_u32(skb, IFLA_BR_FDB_MAX_LEARNED_ENTRIES, br->fdb_max_learned_entries))

I'd say export these only if max entries is > 0

>   		return -EMSGSIZE;
>   
>   #ifdef CONFIG_BRIDGE_VLAN_FILTERING
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2119729ded2b..df079191479e 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -275,6 +275,8 @@ enum {
>   	BR_FDB_LOCKED,
>   };
>   
> +#define BR_FDB_NOT_LEARNED_MASK (BIT(BR_FDB_LOCAL) | BIT(BR_FDB_ADDED_BY_USER))

Not learned sounds confusing and doesn't accurately describe the entry.
BR_FDB_DYNAMIC_LEARNED perhaps or some other name, that doesn't cause
double negatives (not not learned).

> +
>   struct net_bridge_fdb_key {
>   	mac_addr addr;
>   	u16 vlan_id;
> @@ -553,6 +555,9 @@ struct net_bridge {
>   	struct kobject			*ifobj;
>   	u32				auto_cnt;
>   
> +	u32				fdb_max_learned_entries;
> +	u32				fdb_cur_learned_entries;
> +
>   #ifdef CONFIG_NET_SWITCHDEV
>   	/* Counter used to make sure that hardware domains get unique
>   	 * identifiers in case a bridge spans multiple switchdev instances.
> @@ -838,6 +843,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
>   			      bool swdev_notify);
>   void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
>   			  const unsigned char *addr, u16 vid, bool offloaded);
> +u32 br_fdb_get_cur_learned_entries(struct net_bridge *br);
>   
>   /* br_forward.c */
>   enum br_pkt_type {


