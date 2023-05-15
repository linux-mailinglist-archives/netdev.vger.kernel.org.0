Return-Path: <netdev+bounces-2589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C007028F2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BAB11C20A36
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EDDC2C7;
	Mon, 15 May 2023 09:35:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48FBD2E3
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:35:10 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D9910E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:35:07 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50bc5197d33so22877566a12.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684143306; x=1686735306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b6FHZG952yMeP5d9uy/Sr8OyCyw/Y1TfApSk7BaVv4s=;
        b=HCWk+uwwmnNzMMeFpIcqFsZbLUsDRIeEHwo1VQDDLHp4Kxy+MKDbJs/9LEH/an1nHo
         52YfiUmhHZBk21K/ogwZ0iTfjHETHeHt/oyDQSoRUH0RMVPuwyf+ErqHPIPthVNI8MZs
         NyhVAfV25jd3pdZZnkhSXLvcyoDnVpV0unslH4x8UMFVLDhwDHW1QH+ecJo5leo6GFd6
         FPpjypqwOjuUuRwwYX4GBuh6/YLCe77FqMu77N4GDFRyF+8VH/aivB6dNyffMg421ypV
         kyz4WOZNKDpRYVHUCI5ILNR8sIpp3hl+X2m+5EHqFD55Op50jGDstMgmM80KQQ+kkfgC
         Q0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684143306; x=1686735306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b6FHZG952yMeP5d9uy/Sr8OyCyw/Y1TfApSk7BaVv4s=;
        b=kG1acZyTr9mYxiheigi6tI50CqH4ieHIz2mbitTkkJo8Sj/EzFbplzCVXyFiSR1x27
         iGedjaALxo3LSDy76JVB9ydeSSiW+NO+w1+5NEq71va6sdSan+/ByxQhCBnv5uzXddEz
         1q5NOaE1s+Q5WHsClUAMWyB9P9EkhfV02lYR48SSHY863sN41/DxVvpVzvxvp6z0NlzW
         loshiX4tVPNyDZnQgrqeapxrGmW9o83AQeUikKRDaw/hcFNZBeG4xrhAJK9eeLRmPXqG
         sbmRa1WKFNJzABHII2MEKWyTbZZylHusGRhWrdWAXt5CgYi7JfSykCK+i0ci6RESND4f
         qwGw==
X-Gm-Message-State: AC+VfDwTyCg9OSGvBEH536v9dsxui42V5cYwyxulfoUseHZCIXwm0vQZ
	WvaPbdFlVjn9MeVtgNOiVOkWew==
X-Google-Smtp-Source: ACHHUZ66vWCtLvXIxys9HxPVVhXKGwpoDvnNATiGt01x/wHNdVOVPRNLYWbBerSN4okyWIHUPWh5WQ==
X-Received: by 2002:aa7:c15a:0:b0:510:47a2:2b0c with SMTP id r26-20020aa7c15a000000b0051047a22b0cmr3188710edp.35.1684143305585;
        Mon, 15 May 2023 02:35:05 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id b12-20020aa7dc0c000000b0050be1c28a0fsm7148224edu.7.2023.05.15.02.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 02:35:05 -0700 (PDT)
Message-ID: <e8d98be6-d540-59c6-79eb-353715625ea5@blackwall.org>
Date: Mon, 15 May 2023 12:35:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230515085046.4457-1-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/05/2023 11:50, Johannes Nixdorf wrote:
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
> Mitigate this by adding a bridge netlink setting IFLA_BR_FDB_MAX_ENTRIES,
> which, if nonzero, limits the amount of entries to a user specified
> maximum.
> 
> For backwards compatibility the default setting of 0 disables the limit.
> 
> All changes to fdb_n_entries are under br->hash_lock, which means we do
> not need additional locking. The call paths are (✓ denotes that
> br->hash_lock is taken around the next call):
> 
>  - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
>                 |                     +- br_fdb_change_mac_address ✓
>                 |                     +- br_fdb_delete_by_port ✓
>                 +- br_fdb_find_delete_local ✓
>                 +- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_cleanup ✓
>                 +- br_fdb_flush ✓
>                 +- br_fdb_delete_by_port ✓
>                 +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
>                 +- br_fdb_external_learn_del ✓
>  - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_update ✓
>                 +- fdb_add_entry <--- __br_fdb_add ✓
>                 +- br_fdb_external_learn_add ✓
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> ---
>  include/uapi/linux/if_link.h | 1 +
>  net/bridge/br_device.c       | 2 ++
>  net/bridge/br_fdb.c          | 6 ++++++
>  net/bridge/br_netlink.c      | 9 ++++++++-
>  net/bridge/br_private.h      | 2 ++
>  5 files changed, 19 insertions(+), 1 deletion(-)
> 

Hi,
If you're sending a patch series please add a cover letter (--cover-letter) which
explains what the series are trying to do and why.
I've had a patch that implements this feature for a while but didn't get to upstreaming it. :)
Anyway more comments below,

> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4ac1000b0ef2..27cf5f2d8790 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -510,6 +510,7 @@ enum {
>  	IFLA_BR_VLAN_STATS_PER_PORT,
>  	IFLA_BR_MULTI_BOOLOPT,
>  	IFLA_BR_MCAST_QUERIER_STATE,
> +	IFLA_BR_FDB_MAX_ENTRIES,
>  	__IFLA_BR_MAX,
>  };
>  
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 8eca8a5c80c6..d455a28df7c9 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -528,6 +528,8 @@ void br_dev_setup(struct net_device *dev)
>  	br->bridge_hello_time = br->hello_time = 2 * HZ;
>  	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
> +	br->fdb_n_entries = 0;
> +	br->fdb_max_entries = 0;

Unnecessary, the private area is already cleared.

>  	dev->max_mtu = ETH_MAX_MTU;
>  
>  	br_netfilter_rtable_init(br);
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index e69a872bfc1d..8a833e6dee92 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -329,6 +329,8 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>  	hlist_del_init_rcu(&f->fdb_node);
>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>  			       br_fdb_rht_params);
> +	if (!WARN_ON(!br->fdb_n_entries))
> +		br->fdb_n_entries--;

This is pointless, just put the WARN_ON(!br->fdb_n_entries) above decrementing, if we
hit that we are already in trouble and not decrementing doesn't help us.

>  	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
>  	call_rcu(&f->rcu, fdb_rcu_free);
>  }
> @@ -391,6 +393,9 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>  	struct net_bridge_fdb_entry *fdb;
>  	int err;
>  
> +	if (unlikely(br->fdb_max_entries && br->fdb_n_entries >= br->fdb_max_entries))
> +		return NULL;
> +

This one needs more work, fdb_create() is also used when user-space is adding new
entries, so it would be nice to return a proper error.

>  	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
>  	if (!fdb)
>  		return NULL;
> @@ -408,6 +413,7 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>  	}
>  
>  	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
> +	br->fdb_n_entries++;
>  
>  	return fdb;
>  }
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 05c5863d2e20..e5b8d36a3291 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1527,6 +1527,12 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>  			return err;
>  	}
>  
> +	if (data[IFLA_BR_FDB_MAX_ENTRIES]) {
> +		u32 val = nla_get_u32(data[IFLA_BR_FDB_MAX_ENTRIES]);
> +
> +		br->fdb_max_entries = val;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1656,7 +1662,8 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>  	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
>  		       br->topology_change_detected) ||
>  	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
> -	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
> +	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
> +	    nla_put_u32(skb, IFLA_BR_FDB_MAX_ENTRIES, br->fdb_max_entries))

You are not returning the current entry count, that is also needed.

>  		return -EMSGSIZE;
>  
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2119729ded2b..64fb359c6e3e 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -494,6 +494,8 @@ struct net_bridge {
>  #endif
>  
>  	struct rhashtable		fdb_hash_tbl;
> +	u32				fdb_n_entries;
> +	u32				fdb_max_entries;

These are not critical, so I'd use 4 byte holes in net_bridge and pack it better
instead of making it larger.

>  	struct list_head		port_list;
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  	union {


