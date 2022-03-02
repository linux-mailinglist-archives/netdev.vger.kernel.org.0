Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A838B4C9DD3
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiCBGep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCBGem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:34:42 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF205F4D7
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:33:59 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 29so819060ljv.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 22:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ombcz4xJo7oypoeoeMOucGgGLK6Cp900zYZ0bJ6q3hM=;
        b=K0inFXDPHftLguJLa9HQlr1JOt3DFzQk4U9nkegBHd6IG5vEThaygjIsw7nHYD8jG+
         I+bkN4t9cPiFXklE2UyqkFQTsZTLdO5VdAJoGJi+5DX3AHVX03QeZ2SLx40gi19aV07K
         xblqXwWVnobdl+opqJVEJVrTcPmy3tq4VTLQKE90OK8bXJCzjmJdj1CuOjHkLrY/6Lvs
         cFcBJVblDJrbBztQ7+cPNpTb0uGCNhPYMqapSc5oPrFHLf56UeGrq2S02kdrCd0iFZMd
         g8+Mnjz0zTRJVM1ViOGFdQlji8qT+RCnnpfl0+/L0s7kMFxcXEBsjX02CINKhw2SV2Gy
         F5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ombcz4xJo7oypoeoeMOucGgGLK6Cp900zYZ0bJ6q3hM=;
        b=RwZCErNjopqAnmTNUNb9VhlpjrEBWIHzonfcDsJcM9A07RVzsMIQo+queB4ODXQBCE
         PnWypkALhI+ODDChjx5AyFKQJe73eLnFk/f3GlJlqRqwKyYt3hEfwXstbAIVwXu8CYvA
         /N8P08p8xYqvxnccpCXkBgs6Ip80Oh36wdF/daQyg5Y88hORhFzPq+QDoYLQLwEnvOMV
         eSMAt9JCiRUk0PI3HaCk+v59g1xNPU48XZBWFbn4Ji02Cid/lGBbeNVwFmxwfX80EE1M
         BN37HkNqpHZGzdnwtltw7xdDjIGUswq9A2VT5dMRY0psf8Nc7nopWJO2t314HQw0J+xI
         Nccg==
X-Gm-Message-State: AOAM533uWdNUMzXZDpV5vNJQDHARC9sPo9EJUGiFCHMcFw9w7YQU52cY
        pshO4tH+pNZaD7q/5Z0B94c=
X-Google-Smtp-Source: ABdhPJyQ7Nufaj7N2KtLR1QOdKk9PC2ZsZI1xvfH7rD4QaRuGU/ioHPb86t/MtFnO8mVAZRij3Fi3g==
X-Received: by 2002:a2e:964a:0:b0:23d:6a74:7a7b with SMTP id z10-20020a2e964a000000b0023d6a747a7bmr20047633ljh.12.1646202837313;
        Tue, 01 Mar 2022 22:33:57 -0800 (PST)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id d31-20020a0565123d1f00b0044360b2d5d4sm1891581lfv.44.2022.03.01.22.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 22:33:56 -0800 (PST)
Message-ID: <16ba12c0-9582-afad-382b-8547a0224926@gmail.com>
Date:   Wed, 2 Mar 2022 07:33:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: mattias.forsblad+netdev@gmail.com
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <520758A5-F615-4B36-A24C-6F03C527DDC5@blackwall.org>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <520758A5-F615-4B36-A24C-6F03C527DDC5@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-01 23:43, Nikolay Aleksandrov wrote:
> On 1 March 2022 13:31:02 CET, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>> This patch implements the bridge flag local_receive. When this
>> flag is cleared packets received on bridge ports will not be forwarded up.
>> This makes is possible to only forward traffic between the port members
>> of the bridge.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
>> ---
>> include/linux/if_bridge.h      |  6 ++++++
>> include/net/switchdev.h        |  2 ++
>> include/uapi/linux/if_bridge.h |  1 +
>> include/uapi/linux/if_link.h   |  1 +
>> net/bridge/br.c                | 18 ++++++++++++++++++
>> net/bridge/br_device.c         |  1 +
>> net/bridge/br_input.c          |  3 +++
>> net/bridge/br_ioctl.c          |  1 +
>> net/bridge/br_netlink.c        | 14 +++++++++++++-
>> net/bridge/br_private.h        |  2 ++
>> net/bridge/br_sysfs_br.c       | 23 +++++++++++++++++++++++
>> net/bridge/br_vlan.c           |  8 ++++++++
>> 12 files changed, 79 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>> index 3aae023a9353..e6b77d18c1d2 100644
>> --- a/include/linux/if_bridge.h
>> +++ b/include/linux/if_bridge.h
>> @@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>> struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>> 				    const unsigned char *addr,
>> 				    __u16 vid);
>> +bool br_local_receive_enabled(const struct net_device *dev);
>> void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>> bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>> u8 br_port_get_stp_state(const struct net_device *dev);
>> @@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
>> 	return NULL;
>> }
>>
>> +static inline bool br_local_receive_enabled(const struct net_device *dev)
>> +{
>> +	return true;
>> +}
>> +
>> static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
>> {
>> }
>> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>> index 3e424d40fae3..aec5c1f9b5c7 100644
>> --- a/include/net/switchdev.h
>> +++ b/include/net/switchdev.h
>> @@ -25,6 +25,7 @@ enum switchdev_attr_id {
>> 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
>> 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
>> 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
>> +	SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
>> 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
>> 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>> 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
>> @@ -50,6 +51,7 @@ struct switchdev_attr {
>> 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
>> 		bool mc_disabled;			/* MC_DISABLED */
>> 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
>> +		bool local_receive;			/* BRIDGE_LOCAL_RECEIVE */
>> 	} u;
>> };
>>
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 2711c3522010..fc889b5ccd69 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -72,6 +72,7 @@ struct __bridge_info {
>> 	__u32 tcn_timer_value;
>> 	__u32 topology_change_timer_value;
>> 	__u32 gc_timer_value;
>> +	__u8 local_receive;
>> };
>>
>> struct __port_info {
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index e315e53125f4..bb7c25e1c89c 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -482,6 +482,7 @@ enum {
>> 	IFLA_BR_VLAN_STATS_PER_PORT,
>> 	IFLA_BR_MULTI_BOOLOPT,
>> 	IFLA_BR_MCAST_QUERIER_STATE,
>> +	IFLA_BR_LOCAL_RECEIVE,
> 
> Please use the boolopt api for new boolean options
> We're trying to limit the nl options expansion as the bridge is the
> largest user.
> 

I'll move to that api, thanks!

>> 	__IFLA_BR_MAX,
>> };
>>
>> diff --git a/net/bridge/br.c b/net/bridge/br.c
>> index b1dea3febeea..ff7eb4f269ec 100644
>> --- a/net/bridge/br.c
>> +++ b/net/bridge/br.c
>> @@ -325,6 +325,24 @@ void br_boolopt_multi_get(const struct net_bridge *br,
>> 	bm->optmask = GENMASK((BR_BOOLOPT_MAX - 1), 0);
>> }
>>
>> +int br_local_receive_change(struct net_bridge *p,
>> +			    bool local_receive)
>> +{
>> +	struct switchdev_attr attr = {
>> +		.orig_dev = p->dev,
>> +		.id = SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
>> +		.flags = SWITCHDEV_F_DEFER,
>> +		.u.local_receive = local_receive,
>> +	};
>> +	int ret;
>> +
>> +	ret = switchdev_port_attr_set(p->dev, &attr, NULL);
>> +	if (!ret)
>> +		br_opt_toggle(p, BROPT_LOCAL_RECEIVE, local_receive);
>> +
>> +	return ret;
>> +}
>> +
>> /* private bridge options, controlled by the kernel */
>> void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
>> {
>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>> index 8d6bab244c4a..7cd9c5880d18 100644
>> --- a/net/bridge/br_device.c
>> +++ b/net/bridge/br_device.c
>> @@ -524,6 +524,7 @@ void br_dev_setup(struct net_device *dev)
>> 	br->bridge_hello_time = br->hello_time = 2 * HZ;
>> 	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
>> 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>> +	br_opt_toggle(br, BROPT_LOCAL_RECEIVE, true);
>> 	dev->max_mtu = ETH_MAX_MTU;
>>
>> 	br_netfilter_rtable_init(br);
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index e0c13fcc50ed..5864b61157d3 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>> 		break;
>> 	}
>>
>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>> +		local_rcv = false;
>> +
> 
> this affects the whole fast path, it can be better localized to make sure
> it will not affect all use cases
> 
>> 	if (dst) {
>> 		unsigned long now = jiffies;
>>
>> diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
>> index f213ed108361..abe538129290 100644
>> --- a/net/bridge/br_ioctl.c
>> +++ b/net/bridge/br_ioctl.c
>> @@ -177,6 +177,7 @@ int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
>> 		b.topology_change = br->topology_change;
>> 		b.topology_change_detected = br->topology_change_detected;
>> 		b.root_port = br->root_port;
>> +		b.local_receive = br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;
> 
> ioctl is not being extended anymore, please drop it
> 

I'll drop it, thanks!

>>
>> 		b.stp_enabled = (br->stp_enabled != BR_NO_STP);
>> 		b.ageing_time = jiffies_to_clock_t(br->ageing_time);
>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>> index 7d4432ca9a20..5e7f99950195 100644
>> --- a/net/bridge/br_netlink.c
>> +++ b/net/bridge/br_netlink.c
>> @@ -1163,6 +1163,7 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
>> 	[IFLA_BR_MCAST_IGMP_VERSION] = { .type = NLA_U8 },
>> 	[IFLA_BR_MCAST_MLD_VERSION] = { .type = NLA_U8 },
>> 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
>> +	[IFLA_BR_LOCAL_RECEIVE] = { .type = NLA_U8 },
>> 	[IFLA_BR_MULTI_BOOLOPT] =
>> 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
>> };
>> @@ -1434,6 +1435,14 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>> 			return err;
>> 	}
>>
>> +	if (data[IFLA_BR_LOCAL_RECEIVE]) {
>> +		u8 val = nla_get_u8(data[IFLA_BR_LOCAL_RECEIVE]);
>> +
>> +		err = br_local_receive_change(br, !!val);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> 	return 0;
>> }
>>
>> @@ -1514,6 +1523,7 @@ static size_t br_get_size(const struct net_device *brdev)
>> 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_ARPTABLES */
>> #endif
>> 	       nla_total_size(sizeof(struct br_boolopt_multi)) + /* IFLA_BR_MULTI_BOOLOPT */
>> +	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_LOCAL_RECEIVE */
>> 	       0;
>> }
>>
>> @@ -1527,6 +1537,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>> 	u32 stp_enabled = br->stp_enabled;
>> 	u16 priority = (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1];
>> 	u8 vlan_enabled = br_vlan_enabled(br->dev);
>> +	u8 local_receive = br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;
>> 	struct br_boolopt_multi bm;
>> 	u64 clockval;
>>
>> @@ -1563,7 +1574,8 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>> 	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
>> 		       br->topology_change_detected) ||
>> 	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
>> -	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
>> +	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
>> +	    nla_put_u8(skb, IFLA_BR_LOCAL_RECEIVE, local_receive))
>> 		return -EMSGSIZE;
>>
>> #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 48bc61ebc211..01fa5426094b 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -445,6 +445,7 @@ enum net_bridge_opts {
>> 	BROPT_NO_LL_LEARN,
>> 	BROPT_VLAN_BRIDGE_BINDING,
>> 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
>> +	BROPT_LOCAL_RECEIVE,
>> };
>>
>> struct net_bridge {
>> @@ -720,6 +721,7 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
>> void br_boolopt_multi_get(const struct net_bridge *br,
>> 			  struct br_boolopt_multi *bm);
>> void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on);
>> +int br_local_receive_change(struct net_bridge *p, bool local_receive);
>>
>> /* br_device.c */
>> void br_dev_setup(struct net_device *dev);
>> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
>> index 3f7ca88c2aa3..9af0c2ba929c 100644
>> --- a/net/bridge/br_sysfs_br.c
>> +++ b/net/bridge/br_sysfs_br.c
>> @@ -84,6 +84,28 @@ static ssize_t forward_delay_store(struct device *d,
>> }
>> static DEVICE_ATTR_RW(forward_delay);
>>
>> +static ssize_t local_receive_show(struct device *d,
>> +				  struct device_attribute *attr, char *buf)
>> +{
>> +	struct net_bridge *br = to_bridge(d);
>> +
>> +	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_LOCAL_RECEIVE));
>> +}
>> +
>> +static int set_local_receive(struct net_bridge *br, unsigned long val,
>> +			     struct netlink_ext_ack *extack)
>> +{
>> +	return br_local_receive_change(br, !!val);
>> +}
>> +
>> +static ssize_t local_receive_store(struct device *d,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t len)
>> +{
>> +	return store_bridge_parm(d, buf, len, set_local_receive);
>> +}
>> +static DEVICE_ATTR_RW(local_receive);
>> +
> 
> Drop sysfs too, netlink only
> 

Yes, will do, thanks!

>> static ssize_t hello_time_show(struct device *d, struct device_attribute *attr,
>> 			       char *buf)
>> {
>> @@ -950,6 +972,7 @@ static struct attribute *bridge_attrs[] = {
>> 	&dev_attr_group_addr.attr,
>> 	&dev_attr_flush.attr,
>> 	&dev_attr_no_linklocal_learn.attr,
>> +	&dev_attr_local_receive.attr,
>> #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>> 	&dev_attr_multicast_router.attr,
>> 	&dev_attr_multicast_snooping.attr,
>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> index 7557e90b60e1..57dd14d5e360 100644
>> --- a/net/bridge/br_vlan.c
>> +++ b/net/bridge/br_vlan.c
>> @@ -905,6 +905,14 @@ bool br_vlan_enabled(const struct net_device *dev)
>> }
>> EXPORT_SYMBOL_GPL(br_vlan_enabled);
>>
>> +bool br_local_receive_enabled(const struct net_device *dev)
>> +{
>> +	struct net_bridge *br = netdev_priv(dev);
>> +
>> +	return br_opt_get(br, BROPT_LOCAL_RECEIVE);
>> +}
>> +EXPORT_SYMBOL_GPL(br_local_receive_enabled);
>> +
> 
> What the hell is this doing in br_vlan.c???
> 
>> int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
>> {
>> 	struct net_bridge *br = netdev_priv(dev);
> 

