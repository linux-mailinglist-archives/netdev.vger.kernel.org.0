Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3021881D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgGHMz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgGHMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:55:28 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6B1C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:55:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dm19so35448490edb.13
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=iz+5wSpIVRs4R8n3xUJBv3kHO5LLz2FlYZJTTaGzw6s=;
        b=C1nOEjsDzVJkJPSSTwb/y1Ik0abhSEzRM7S+R4RjZxYCYkWpZq+6dCAnzhk8qjG4Wz
         cvPNHawpHSPlCcI6qqnZWqF+CJ8TV3a1iFYOZ35QymIoOyNLJqfAcdB2mj5z56euOn5M
         WBcvnoykP1ma/CbjM+cvhB67SPi9JNtfkn2vQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=iz+5wSpIVRs4R8n3xUJBv3kHO5LLz2FlYZJTTaGzw6s=;
        b=gxwEBz1GUepnt5eShFg6PeigIBciyJZYrDiMpU8+635Yy0XoP+RoJSUaxYcc9jWnsh
         g6oijrokvVP+cna+FNwN+k1a+YtMV86laNWLE6DSVwtj2tRG/GTcL208wqBTTA/UQKci
         mZ2/GQ5y9vQowcaTd2NEuJ3E0mb82UyY18PtgQXlKLAcrkdvm/pJyG99OthAvP9n1cdU
         Ep4hXaMHwsuXDJku78ckFLYokK+HPAG/2Nev/RE4bHR6wK0V60IOC9Yl/sqzIFrSOmLt
         ryv1EsYkBL6+u4o/ekb8UgMGmHQTG1Aa+ckyISL9wYM9//rikXEGu6k5gBAmzStdfKfA
         2Zbw==
X-Gm-Message-State: AOAM533jUzADFdvcyFR87BZX+u03aLyrGASDTHWyzO2e3/92RJUeEQSQ
        72fsy82Zh4Z6UEHZv39vJmmY8tnx7VNcDQ==
X-Google-Smtp-Source: ABdhPJxuKlLrOeX+3PpUYoMye3lRX9Whmz6hA5lh+Yy06XJCMmML8h7JqzKqVxLhybdgb7d3NnmWLg==
X-Received: by 2002:a05:6402:cb9:: with SMTP id cn25mr55646276edb.247.1594212926247;
        Wed, 08 Jul 2020 05:55:26 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s23sm2006590ejz.53.2020.07.08.05.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:55:25 -0700 (PDT)
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
 <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
 <20200708094200.p6lprjdpgncspima@skbuf>
 <0d554adb-29c3-3b4a-d696-4d4bfd567767@cumulusnetworks.com>
 <7a64aacf-51fd-4697-6af9-229bbbe97d0b@cumulusnetworks.com>
Message-ID: <9621e436-b674-ea12-eabd-9908ca6d5ee8@cumulusnetworks.com>
Date:   Wed, 8 Jul 2020 15:55:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7a64aacf-51fd-4697-6af9-229bbbe97d0b@cumulusnetworks.com>
Content-Type: multipart/mixed;
 boundary="------------B52A5D14F4621F72FAEB10BF"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------B52A5D14F4621F72FAEB10BF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 08/07/2020 14:17, Nikolay Aleksandrov wrote:
> On 08/07/2020 14:07, Nikolay Aleksandrov wrote:
>> On 08/07/2020 12:42, Vladimir Oltean wrote:
>>> On Wed, Jul 08, 2020 at 12:16:27PM +0300, Nikolay Aleksandrov wrote:
>>>> On 08/07/2020 12:04, Vladimir Oltean wrote:
[snip]
>>>>
>>>
>>> Thanks, Nikolay.
>>> Isn't mdb_modify() already netlink-based? I think you're talking about
>>> some changes to 'struct br_mdb_entry' which would be necessary. What
>>> changes would be needed, do you know (both in the 'workaround' case as
>>> well as in 'fully netlink')?
>>>
>>> -Vladimir
>>>
>>
>> That is netlink-based, but the uAPI (used also for add/del/dump) uses a fixed-size struct
>> which is very inconvenient and hard to extend. I plan to add MDBv2 which uses separate
>> netlink attributes and can be easily extended as we plan to add some new features and will
>> need that flexibility. It will use a new container attribute for the notifications as well.
>>
>> In the workaround case IIRC you'd have to add a new protocol type to denote the L2 routes, and
> 
> Actually drop the whole /workaround/ comment altogether. It can be implemented fairly straight-forward
> even with the struct we got now. You don't need any new attributes.
> I just had forgotten the details and spoke too quickly. :)
> 
>> re-work the lookup logic to include L2 in non-IP case. You'd have to edit the multicast fast-path,
>> and everything else that assumes the frame has to be IP/IPv6. I'm sure I'm missing some details as
>> last I did this was over an year ago where I made a quick and dirty hack that implemented it with proto = 0
>> to denote an L2 entry just as a proof of concept.
>> Also you would have to make sure all of that is compatible with current user-space code. For example
>> iproute2/bridge/mdb.c considers that proto can be only IPv4 or IPv6 if it's not v4, i.e. it will
>> print the new L2 entries as :: IPv6 entries until it's fixed.
>>
>> Obviously some of the items for the workaround case are valid in all cases for L2 routes (e.g. fast-path/lookup edit).
>> But I think it's not that hard to implement without affecting the fast path much or even at all.
>>
>> Cheers,
>>  Nik
>>

I found the patch and rebased it against net-next. I want to stress that it is unfinished and
barely tested, it was just a hack to enable L2 entries and forwarding.
If you're interested and find it useful please feel free to take it over as
I don't have time right now.

Thanks,
 Nik



--------------B52A5D14F4621F72FAEB10BF
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-bridge-multicast-add-support-for-L2-entries.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-net-bridge-multicast-add-support-for-L2-entries.patch"

From 87ad93d5953932eb14739572743d049de1ba8b1d Mon Sep 17 00:00:00 2001
From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Wed, 8 Jul 2020 15:49:26 +0300
Subject: [RFC] net: bridge: multicast: add support for L2 entries

Unfinished.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_bridge.h |  2 ++
 net/bridge/br_device.c         |  2 +-
 net/bridge/br_input.c          |  2 +-
 net/bridge/br_mdb.c            | 35 ++++++++++++++++++++++++++--------
 net/bridge/br_multicast.c      | 12 +++++++++---
 net/bridge/br_private.h        |  7 +++++--
 7 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b3a8d3054af0..4c95eff22c8e 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -20,6 +20,7 @@ struct br_ip {
 		struct in6_addr ip6;
 #endif
 	} u;
+	__u8 mac_addr[ETH_ALEN];
 	__be16		proto;
 	__u16           vid;
 };
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index c114c1c2bd53..73e129370662 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -437,10 +437,12 @@ struct br_mdb_entry {
 	__u8 state;
 #define MDB_FLAGS_OFFLOAD	(1 << 0)
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
+#define MDB_FLAGS_L2		(1 << 2)
 	__u8 flags;
 	__u16 vid;
 	struct {
 		union {
+			__u8 mac_addr[ETH_ALEN];
 			__be32	ip4;
 			struct in6_addr ip6;
 		} u;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8c7b78f8bc23..b32421f484f3 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -91,7 +91,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb)))
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
 			br_multicast_flood(mdst, skb, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 59a318b9f646..d31b5c18c6a1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -134,7 +134,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	case BR_PKT_MULTICAST:
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb))) {
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
 			if ((mdst && mdst->host_joined) ||
 			    br_multicast_is_router(br)) {
 				local_rcv = true;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index da5ed4cf9233..c80218a5e6fa 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -62,6 +62,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 		e->flags |= MDB_FLAGS_OFFLOAD;
 	if (flags & MDB_PG_FLAGS_FAST_LEAVE)
 		e->flags |= MDB_FLAGS_FAST_LEAVE;
+	if (flags & MDB_PG_FLAGS_L2)
+		e->flags |= MDB_FLAGS_L2;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
@@ -72,9 +74,11 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 	if (ip->proto == htons(ETH_P_IP))
 		ip->u.ip4 = entry->addr.u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	else
+	else if (ip->proto == htons(ETH_P_IPV6))
 		ip->u.ip6 = entry->addr.u.ip6;
 #endif
+	else
+		memcpy(ip->mac_addr, entry->addr.u.mac_addr, ETH_ALEN);
 }
 
 static int __mdb_fill_info(struct sk_buff *skb,
@@ -103,9 +107,12 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	if (mp->addr.proto == htons(ETH_P_IP))
 		e.addr.u.ip4 = mp->addr.u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (mp->addr.proto == htons(ETH_P_IPV6))
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
 		e.addr.u.ip6 = mp->addr.u.ip6;
 #endif
+	else
+		memcpy(e.addr.u.mac_addr, mp->addr.mac_addr, ETH_ALEN);
+
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
@@ -399,9 +406,11 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
 	if (entry->addr.proto == htons(ETH_P_IP))
 		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
-	else
+	else if (entry->addr.proto == htons(ETH_P_IPV6))
 		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
 #endif
+	else
+		memcpy(mdb.addr, entry->addr.u.mac_addr, ETH_ALEN);
 
 	mdb.obj.orig_dev = port_dev;
 	if (p && port_dev && type == RTM_NEWMDB) {
@@ -447,6 +456,7 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 		entry.ifindex = port->dev->ifindex;
 	else
 		entry.ifindex = dev->ifindex;
+	memcpy(entry.addr.u.mac_addr, group->mac_addr, ETH_ALEN);
 	entry.addr.proto = group->proto;
 	entry.addr.u.ip4 = group->u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -529,18 +539,24 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
 	if (entry->ifindex == 0)
 		return false;
 
-	if (entry->addr.proto == htons(ETH_P_IP)) {
+	switch (entry->addr.proto) {
+	case htons(ETH_P_IP):
 		if (!ipv4_is_multicast(entry->addr.u.ip4))
 			return false;
 		if (ipv4_is_local_multicast(entry->addr.u.ip4))
 			return false;
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
+	case htons(ETH_P_IPV6):
 		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
 			return false;
+		break;
 #endif
-	} else
-		return false;
+	default:
+		if (entry->addr.proto != 0)
+			return false;
+	}
+
 	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY)
 		return false;
 	if (entry->vid >= VLAN_VID_MASK)
@@ -616,6 +632,9 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return err;
 	}
 
+	if (mp->l2 && state != MDB_PERMANENT)
+		return -EINVAL;
+
 	/* host join */
 	if (!port) {
 		/* don't allow any flags for host-joined groups */
@@ -642,7 +661,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	if (unlikely(!p))
 		return -ENOMEM;
 	rcu_assign_pointer(*pp, p);
-	if (state == MDB_TEMPORARY)
+	if (state == MDB_TEMPORARY && !mp->l2)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
 
 	return 0;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 83490bf73a13..79af5b656df1 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -133,7 +133,8 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 		break;
 #endif
 	default:
-		return NULL;
+		ip.proto = 0;
+		memcpy(&ip.mac_addr, eth_hdr(skb)->h_dest, ETH_ALEN);
 	}
 
 	return br_mdb_ip_get_rcu(br, &ip);
@@ -457,6 +458,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 
 	mp->br = br;
 	mp->addr = *group;
+	mp->l2 = !!(group->proto == 0);
 	timer_setup(&mp->timer, br_multicast_group_expired, 0);
 	err = rhashtable_lookup_insert_fast(&br->mdb_hash_tbl, &mp->rhnode,
 					    br_mdb_rht_params);
@@ -486,6 +488,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->addr = *group;
 	p->port = port;
 	p->flags = flags;
+	if (group->proto == htons(0))
+		p->flags |= MDB_PG_FLAGS_L2;
 	rcu_assign_pointer(p->next, next);
 	hlist_add_head(&p->mglist, &port->mglist);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
@@ -519,7 +523,9 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 			br_mdb_notify(mp->br->dev, NULL, &mp->addr,
 				      RTM_NEWMDB, 0);
 	}
-	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
+	if (!mp->l2)
+		mod_timer(&mp->timer,
+			  jiffies + mp->br->multicast_membership_interval);
 }
 
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
@@ -2252,7 +2258,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth);
+	ret = br_multicast_querier_exists(br, &eth, NULL);
 
 unlock:
 	rcu_read_unlock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 65d2c163a24a..ea0a13d9fbea 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -213,6 +213,7 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
+#define MDB_PG_FLAGS_L2		BIT(3)
 
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
@@ -233,6 +234,7 @@ struct net_bridge_mdb_entry {
 	struct timer_list		timer;
 	struct br_ip			addr;
 	bool				host_joined;
+	bool				l2;
 	struct hlist_node		mdb_node;
 };
 
@@ -816,7 +818,8 @@ __br_multicast_querier_exists(struct net_bridge *br,
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
-					       struct ethhdr *eth)
+					       struct ethhdr *eth,
+					       const struct net_bridge_mdb_entry *mdb)
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
@@ -828,7 +831,7 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 			&br->ip6_other_query, true);
 #endif
 	default:
-		return false;
+		return !!(mdb && mdb->l2);
 	}
 }
 
-- 
2.25.4


--------------B52A5D14F4621F72FAEB10BF--
