Return-Path: <netdev+bounces-2902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0877047A1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8306C28155E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F12B200CF;
	Tue, 16 May 2023 08:21:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9201FB0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:21:29 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD36D1
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:21:27 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bc394919cso20194893a12.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684225286; x=1686817286;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XM2gUAmvU4vVBik+mvVxF1HnbcZzyCqA9HaeHIr5I5I=;
        b=yfGEdhKDlVR1agDkKB6PW2Dmq6ztfizmtuI6D+xRT0UfaEi/s0ZRLKY2NMcFM7graD
         4dRje8oa4VVJdB1onsHyLHorHtbiiBKJFPrHaeXrDf3R5UbzyfUBB2H00RBk1WmIOxsF
         ARoLjw9MdXoOBnb0dp+jM1NfJKe3ELjBjzrrs9buaytLhKvWe353dE8JFUz5AyB0Yeni
         Wqm7yeAU3uFO2Ub5hIqv4/T8IjVlh5uIQKNaKxww+Z46XHj+wmKTIXr9yM6MydWO09dD
         m0j09gLpn8hdjXzrCOwZdXm2n0jSXtKfaZxitqrMjOFsHN4XOTl7uWDDmC3YJzJPhrMZ
         /ZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684225286; x=1686817286;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XM2gUAmvU4vVBik+mvVxF1HnbcZzyCqA9HaeHIr5I5I=;
        b=PKZnO04fIrwDdxZbgZ+gV9cwwvt0DHKEf4F7rE1pc/bZJccVISPfN0i8dTPWILPpOl
         3Q6k3huKjWGAlEFbNp42/Zb1pQUrSxs6dQuKSvc7+KgsOQQdoRJmFlWkaVlqUlXbmksj
         sB2PtkSFKN2W/1hXg+ojuu9hlH6zil0ii6w51bxqsejIKGBxmQ7bbS4hlzYZvt9taRaV
         KG0CxxyT3nstMP6uVFFh5j316RMYkNR612KsU/s91vvwirvGfNU1qFA+Si9Dqk6RiPMN
         PLlQ4eNVdvBiStSRIyXGBFW4zYjlxQQjhAMBnVGjM74Ed0hY2g8ca8dbyc8Ewik02ERJ
         i0uw==
X-Gm-Message-State: AC+VfDzmUFBx/pAiIa/Ca6inSdWMffDbAN+xovAaDNzNzFpbwHKRmBmy
	InkQ6FaT4QUe1Qv7Rfg5CjJQww==
X-Google-Smtp-Source: ACHHUZ7ylDIti31B34YDzwxlURwMXIn1e5ZDWaUU3xi9TriekHV4e/mE13dcFQ7hAx4d9/mIlKR2FQ==
X-Received: by 2002:a50:fe92:0:b0:506:b8ca:e07e with SMTP id d18-20020a50fe92000000b00506b8cae07emr25065329edt.11.1684225285448;
        Tue, 16 May 2023 01:21:25 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id k23-20020a05640212d700b0050c0b9d31a7sm8102665edx.22.2023.05.16.01.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:21:25 -0700 (PDT)
Message-ID: <5d59f2f8-b211-8914-1793-bfaa299207cd@blackwall.org>
Date: Tue, 16 May 2023 11:21:24 +0300
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
To: Johannes Nixdorf <jnixdorf-oss@avm.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <e8d98be6-d540-59c6-79eb-353715625ea5@blackwall.org>
 <ZGM64ODoVwK8J4u2@u-jnixdorf.ads.avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZGM64ODoVwK8J4u2@u-jnixdorf.ads.avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 11:12, Johannes Nixdorf wrote:
> Hi,
> 
> On Mon, May 15, 2023 at 12:35:03PM +0300, Nikolay Aleksandrov wrote:
>> On 15/05/2023 11:50, Johannes Nixdorf wrote:
>>> A malicious actor behind one bridge port may spam the kernel with packets
>>> with a random source MAC address, each of which will create an FDB entry,
>>> each of which is a dynamic allocation in the kernel.
>>>
>>> There are roughly 2^48 different MAC addresses, further limited by the
>>> rhashtable they are stored in to 2^31. Each entry is of the type struct
>>> net_bridge_fdb_entry, which is currently 128 bytes big. This means the
>>> maximum amount of memory allocated for FDB entries is 2^31 * 128B =
>>> 256GiB, which is too much for most computers.
>>>
>>> Mitigate this by adding a bridge netlink setting IFLA_BR_FDB_MAX_ENTRIES,
>>> which, if nonzero, limits the amount of entries to a user specified
>>> maximum.
>>>
>>> For backwards compatibility the default setting of 0 disables the limit.
>>>
>>> All changes to fdb_n_entries are under br->hash_lock, which means we do
>>> not need additional locking. The call paths are (✓ denotes that
>>> br->hash_lock is taken around the next call):
>>>
>>>  - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
>>>                 |                     +- br_fdb_change_mac_address ✓
>>>                 |                     +- br_fdb_delete_by_port ✓
>>>                 +- br_fdb_find_delete_local ✓
>>>                 +- fdb_add_local <-+- br_fdb_changeaddr ✓
>>>                 |                  +- br_fdb_change_mac_address ✓
>>>                 |                  +- br_fdb_add_local ✓
>>>                 +- br_fdb_cleanup ✓
>>>                 +- br_fdb_flush ✓
>>>                 +- br_fdb_delete_by_port ✓
>>>                 +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
>>>                 +- br_fdb_external_learn_del ✓
>>>  - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
>>>                 |                  +- br_fdb_change_mac_address ✓
>>>                 |                  +- br_fdb_add_local ✓
>>>                 +- br_fdb_update ✓
>>>                 +- fdb_add_entry <--- __br_fdb_add ✓
>>>                 +- br_fdb_external_learn_add ✓
>>>
>>> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
>>> ---
>>>  include/uapi/linux/if_link.h | 1 +
>>>  net/bridge/br_device.c       | 2 ++
>>>  net/bridge/br_fdb.c          | 6 ++++++
>>>  net/bridge/br_netlink.c      | 9 ++++++++-
>>>  net/bridge/br_private.h      | 2 ++
>>>  5 files changed, 19 insertions(+), 1 deletion(-)
>>>
>>
>> Hi,
>> If you're sending a patch series please add a cover letter (--cover-letter) which
>> explains what the series are trying to do and why.
> 
> Thanks for the hint. I'll do that in the future, including a potential v2.
> 
>> I've had a patch that implements this feature for a while but didn't get to upstreaming it. :)
> 
> I'm not too attached to my name on it, so if your patch is further along,
> I'd be happy if you submitted your version instead.
> 

Nah, just mentioning it. I'd be happy to review and ack your patches. I don't have time
at the moment to polish and upstream it.

Please add a selftest as well.

>> Anyway more comments below,
> 
>>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>> index 4ac1000b0ef2..27cf5f2d8790 100644
>>> --- a/include/uapi/linux/if_link.h
>>> +++ b/include/uapi/linux/if_link.h
>>> @@ -510,6 +510,7 @@ enum {
>>>  	IFLA_BR_VLAN_STATS_PER_PORT,
>>>  	IFLA_BR_MULTI_BOOLOPT,
>>>  	IFLA_BR_MCAST_QUERIER_STATE,
>>> +	IFLA_BR_FDB_MAX_ENTRIES,
>>>  	__IFLA_BR_MAX,
>>>  };
>>>  
>>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>>> index 8eca8a5c80c6..d455a28df7c9 100644
>>> --- a/net/bridge/br_device.c
>>> +++ b/net/bridge/br_device.c
>>> @@ -528,6 +528,8 @@ void br_dev_setup(struct net_device *dev)
>>>  	br->bridge_hello_time = br->hello_time = 2 * HZ;
>>>  	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
>>>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>>> +	br->fdb_n_entries = 0;
>>> +	br->fdb_max_entries = 0;
>>
>> Unnecessary, the private area is already cleared.
> 
> This will be taken out in a v2.
> 
>>>  	dev->max_mtu = ETH_MAX_MTU;
>>>  
>>>  	br_netfilter_rtable_init(br);
>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>> index e69a872bfc1d..8a833e6dee92 100644
>>> --- a/net/bridge/br_fdb.c
>>> +++ b/net/bridge/br_fdb.c
>>> @@ -329,6 +329,8 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>  	hlist_del_init_rcu(&f->fdb_node);
>>>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>>>  			       br_fdb_rht_params);
>>> +	if (!WARN_ON(!br->fdb_n_entries))
>>> +		br->fdb_n_entries--;
>>
>> This is pointless, just put the WARN_ON(!br->fdb_n_entries) above decrementing, if we
>> hit that we are already in trouble and not decrementing doesn't help us.
> 
> This will now always be decremented in a v2.
> 
>>>  	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
>>>  	call_rcu(&f->rcu, fdb_rcu_free);
>>>  }
>>> @@ -391,6 +393,9 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>>>  	struct net_bridge_fdb_entry *fdb;
>>>  	int err;
>>>  
>>> +	if (unlikely(br->fdb_max_entries && br->fdb_n_entries >= br->fdb_max_entries))
>>> +		return NULL;
>>> +
>>
>> This one needs more work, fdb_create() is also used when user-space is adding new
>> entries, so it would be nice to return a proper error.
> 
> The callers usually map this return code to -ENOMEM, which I deemed an
> appropriate return code for violating the new limit, as I understood it
> as a memory limit for the FDB table.
> 
> Is there a different error return code you had in mind here, or would
> you rather only count dynamic entries towards the limit at all?
> 

I think we should be able to tell apart real ENOMEM from out of entries, the callers
should interpret the returned error and propagate a user-friendly and understandable extack.
The error could be E2BIG for example. That would require updating callers though.
Please split these into separate patches so they can be easier to review.

>>>  	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
>>>  	if (!fdb)
>>>  		return NULL;
>>> @@ -408,6 +413,7 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>>>  	}
>>>  
>>>  	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
>>> +	br->fdb_n_entries++;
>>>  
>>>  	return fdb;
>>>  }
>>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>>> index 05c5863d2e20..e5b8d36a3291 100644
>>> --- a/net/bridge/br_netlink.c
>>> +++ b/net/bridge/br_netlink.c
>>> @@ -1527,6 +1527,12 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>>>  			return err;
>>>  	}
>>>  
>>> +	if (data[IFLA_BR_FDB_MAX_ENTRIES]) {
>>> +		u32 val = nla_get_u32(data[IFLA_BR_FDB_MAX_ENTRIES]);
>>> +
>>> +		br->fdb_max_entries = val;
>>> +	}
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> @@ -1656,7 +1662,8 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>>>  	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
>>>  		       br->topology_change_detected) ||
>>>  	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
>>> -	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
>>> +	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
>>> +	    nla_put_u32(skb, IFLA_BR_FDB_MAX_ENTRIES, br->fdb_max_entries))
>>
>> You are not returning the current entry count, that is also needed.
> 
> For a v2 this now also returns the current entry count under
> IFLA_BR_FDB_CUR_ENTRIES.
> 
>>>  		return -EMSGSIZE;
>>>  
>>>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 2119729ded2b..64fb359c6e3e 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -494,6 +494,8 @@ struct net_bridge {
>>>  #endif
>>>  
>>>  	struct rhashtable		fdb_hash_tbl;
>>> +	u32				fdb_n_entries;
>>> +	u32				fdb_max_entries;
>>
>> These are not critical, so I'd use 4 byte holes in net_bridge and pack it better
>> instead of making it larger.
> 
> For a v2 I now moved it into (conditional) holes now in front of
> CONFIG_BRIDGE_VLAN_FILTERING (only a hole if it is enabled) and
> CONFIG_SWITCHDEV (only a hole if it is disabled). I could not find any
> other holes, but please tell me if you had any others in mind.
> 
>>>  	struct list_head		port_list;
>>>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>>>  	union {
>>
> 
> Thanks for your detailed feedback.


