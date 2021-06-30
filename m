Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D119F3B803E
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhF3Jqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhF3Jqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 05:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625046249;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BZW/Rn0ajcqxcEumszhyBNvuyU3u+upm9NLSeqr1nAA=;
        b=aoQhi9umhSILOqVZ3pqfUwz9+NTs17MPbGV66HLN0ktkhCQ5fMjrpDNCIxVmpBJoFBBBdI
        wk12W2LAYVTPLFSsBppDCgPer9gW9GjNUquwqfpVqT28gNKRBScORLh7FRbElQArapuQSh
        FXotx4VTvzW/ZE3tg67B6vkGmZiwE48=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-oLov0DfqOJ6y8e5Y8iaudg-1; Wed, 30 Jun 2021 05:44:08 -0400
X-MC-Unique: oLov0DfqOJ6y8e5Y8iaudg-1
Received: by mail-wr1-f72.google.com with SMTP id p12-20020a5d59ac0000b0290125818b9a60so638011wrr.19
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 02:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BZW/Rn0ajcqxcEumszhyBNvuyU3u+upm9NLSeqr1nAA=;
        b=sClMDSzTM7GTG587/gGX7gvtdYauGHn9aNTQEh11MzpSrFJLzXy2m+FXpB9zIODA2o
         aUt70zz1ip9H/2cDZ6mNRRJa0jGzeaza8Q+gHtSZ9WqAvBiPI52WE5Qpuq8+iSPNtava
         sWeut7+2d0zIhontOYIQWHy7q5A7nEe8988wy78OETYoghnjSVqjlIMjWbzdJuaB6rE8
         bpLwYlz3CC20SaSdrDHgJpke30YfYvu6ACXeovlakd4xDOl8+Zic0ZOtEu/9ni+HSmys
         IT+yZLB8vUd34o1NCAaNZf6P1GZnGtZk24iMvyPz/9kD7obOyILBH6Izucc/Ov3aob62
         +X8A==
X-Gm-Message-State: AOAM530b5+3gUolF6skfqTq2L0NfoF4OmePrR/sdAKP9NybKegoBduje
        psJt8XS1CcVlSznQ40qdkqHYXgW7ufBp5XYbctO0+X0xHR0sx2TWvUjsJfbtP7iJGTCTOh0f5bf
        9dzK/ZoVSqp/leCCD
X-Received: by 2002:a7b:c351:: with SMTP id l17mr37559824wmj.120.1625046247205;
        Wed, 30 Jun 2021 02:44:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTTbkT2HBVl61YopYP0Lb3ln1jlymnM000T/Zzqbocs5jOOAsAB96bIoc1NeGssng0xISUAQ==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr37559782wmj.120.1625046246797;
        Wed, 30 Jun 2021 02:44:06 -0700 (PDT)
Received: from magray.users.ipa.redhat.com ([109.79.14.233])
        by smtp.gmail.com with ESMTPSA id w3sm5761734wmi.24.2021.06.30.02.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 02:44:06 -0700 (PDT)
Reply-To: Mark Gray <mark.d.gray@redhat.com>
Subject: Re: [ovs-dev] [RFC net-next] openvswitch: Introduce per-cpu upcall
 dispatch
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org
References: <20210430153325.28322-1-mark.d.gray@redhat.com>
 <YLFJWoj6+N1FTmka@p50>
From:   Mark Gray <mark.d.gray@redhat.com>
Message-ID: <5a2c4440-cb08-cf5d-e03e-ec292d5909e6@redhat.com>
Date:   Wed, 30 Jun 2021 10:44:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLFJWoj6+N1FTmka@p50>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2021 20:49, Flavio Leitner wrote:
> 
> Hi Mark,
> 
> I think this patch is going in the right direction but there
> are some points that I think we should address. See below.
> 
> On Fri, Apr 30, 2021 at 11:33:25AM -0400, Mark Gray wrote:
>> The Open vSwitch kernel module uses the upcall mechanism to send
>> packets from kernel space to user space when it misses in the kernel
>> space flow table. The upcall sends packets via a Netlink socket.
>> Currently, a Netlink socket is created for every vport. In this way,
>> there is a 1:1 mapping between a vport and a Netlink socket.
>> When a packet is received by a vport, if it needs to be sent to
>> user space, it is sent via the corresponding Netlink socket.
>>
>> This mechanism, with various iterations of the corresponding user
>> space code, has seen some limitations and issues:
>>
>> * On systems with a large number of vports, there is a correspondingly
>> large number of Netlink sockets which can limit scaling.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
>> * Packet reordering on upcalls.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
>> * A thundering herd issue.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
>>
>> This patch introduces an alternative, feature-negotiated, upcall
>> mode using a per-cpu dispatch rather than a per-vport dispatch.
>>
>> In this mode, the Netlink socket to be used for the upcall is
>> selected based on the CPU of the thread that is executing the upcall.
>> In this way, it resolves the issues above as:
>>
>> a) The number of Netlink sockets scales with the number of CPUs
>> rather than the number of vports.
>> b) Ordering per-flow is maintained as packets are distributed to
>> CPUs based on mechanisms such as RSS and flows are distributed
>> to a single user space thread.
>> c) Packets from a flow can only wake up one user space thread.
>>
>> The corresponding user space code can be found at:
>> https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html
> 
> Thanks for writing a nice commit description.
> 
>>
>> Bugzilla: https://bugzilla.redhat.com/1844576
>> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
>> ---
>>  include/uapi/linux/openvswitch.h |  8 ++++
>>  net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
>>  net/openvswitch/datapath.h       | 18 ++++++++
>>  net/openvswitch/flow_netlink.c   |  4 --
>>  4 files changed, 94 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>> index 8d16744edc31..6571b57b2268 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -70,6 +70,8 @@ enum ovs_datapath_cmd {
>>   * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
>>   * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
>>   * not be sent.
>> + * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
>> + * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
>>   * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
>>   * datapath.  Always present in notifications.
>>   * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
>> @@ -87,6 +89,9 @@ enum ovs_datapath_attr {
>>  	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
>>  	OVS_DP_ATTR_PAD,
>>  	OVS_DP_ATTR_MASKS_CACHE_SIZE,
>> +	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
>> +				     * dispatch mode
>> +				     */
>>  	__OVS_DP_ATTR_MAX
>>  };
>>  
>> @@ -127,6 +132,9 @@ struct ovs_vport_stats {
>>  /* Allow tc offload recirc sharing */
>>  #define OVS_DP_F_TC_RECIRC_SHARING	(1 << 2)
>>  
>> +/* Allow per-cpu dispatch of upcalls */
>> +#define OVS_DP_F_DISPATCH_UPCALL_PER_CPU	(1 << 3)
>> +
>>  /* Fixed logical ports. */
>>  #define OVSP_LOCAL      ((__u32)0)
>>  
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 9d6ef6cb9b26..98d54f41fdaa 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -121,6 +121,8 @@ int lockdep_ovsl_is_held(void)
>>  #endif
>>  
>>  static struct vport *new_vport(const struct vport_parms *);
>> +static u32 ovs_dp_get_upcall_portid(const struct datapath *, uint32_t);
>> +static int ovs_dp_set_upcall_portids(struct datapath *, const struct nlattr *);
>>  static int queue_gso_packets(struct datapath *dp, struct sk_buff *,
>>  			     const struct sw_flow_key *,
>>  			     const struct dp_upcall_info *,
>> @@ -238,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>>  
>>  		memset(&upcall, 0, sizeof(upcall));
>>  		upcall.cmd = OVS_PACKET_CMD_MISS;
>> -		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
>> +
>> +		if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
>> +			upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
>> +		else
>> +			upcall.portid = ovs_vport_find_upcall_portid(p, skb);
>> +
> 
> We don't expect that to change during packet processing, so I
> wondered if that could be improved. However, user_feature is
> in the same cache line as stats_percpu which is also used.

I haven't changed anything here but I am open to changing it. We *will*
need to check something here as we need to make a decision as to how to
select the "portid". As you state, there could be a performance issue
depending on which cache line we use to make our check and whether or
not multiple cores are writing that cache line (and the cache
architecture of the CPU on which we are running). I have not seen any
major degradation in performance from this change but I am not ruling it
out. Do you have a suggestion for a better approach?

> 
> 
>>  		upcall.mru = OVS_CB(skb)->mru;
>>  		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
>>  		if (unlikely(error))
>> @@ -1590,16 +1597,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>>  
>>  DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
>>  
>> +static int ovs_dp_set_upcall_portids(struct datapath *dp,
>> +				     const struct nlattr *ids)
>> +{
>> +	struct dp_portids *old, *dp_portids;
>> +
>> +	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
>> +		return -EINVAL;
>> +
>> +	old = ovsl_dereference(dp->upcall_portids);
>> +
>> +	dp_portids = kmalloc(sizeof(*dp_portids) + nla_len(ids),
>> +			     GFP_KERNEL);
>> +	if (!dp)
> 
> I suspect you meant dp_portids.

Yes, Dan Carpenter also caught this.

> 
>> +		return -ENOMEM;
>> +
>> +	dp_portids->n_ids = nla_len(ids) / sizeof(u32);
>> +	nla_memcpy(dp_portids->ids, ids, nla_len(ids));
>> +
>> +	rcu_assign_pointer(dp->upcall_portids, dp_portids);
>> +
>> +	if (old)
>> +		kfree_rcu(old, rcu);
> 
> IIRC, the kfree_rcu() checks for NULL pointers.
> 
> 

I checked and it does.
>> +	return 0;
>> +}
>> +
>> +static u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
>> +{
>> +	struct dp_portids *dp_portids;
>> +
>> +	dp_portids = rcu_dereference_ovsl(dp->upcall_portids);
>> +
>> +	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && dp_portids) {
> 
> The OVS_DP_F_DISPATCH_UPCALL_PER_CPU needs to be verified
> by the caller to decide whether to use this function or
> ovs_vport_find_upcall_portid(), so perhaps function could
> check only if dp_portids is set.


Yes, I have removed this check

> 
> 
>> +		if (cpu_id < dp_portids->n_ids) {
>> +			return dp_portids->ids[cpu_id];
>> +		} else if (dp_portids->n_ids > 0 && cpu_id >= dp_portids->n_ids) {
>> +			/* If the number of netlink PIDs is mismatched with the number of
>> +			 * CPUs as seen by the kernel, log this and send the upcall to an
>> +			 * arbitrary socket (0) in order to not drop packets
>> +			 */
>> +			pr_info_ratelimited("cpu_id mismatch with handler threads");
>> +			return dp_portids->ids[0];
> 
> Instead of returning a fixed pid for all other unmapped CPUs, perhaps
> it could distribute among mapped ones to help with the load:
> 
>             return dp_portids->ids[cpu_id % dp_portids->n_ids]

I have changed as you suggested. I actually thought it might make
debugging issues easier but, in retrospect, it could affect the
performance too much in case of an issue.

> 
> 
>> +		} else {
>> +			return 0;
>> +		}
>> +	} else {
>> +		return 0;
>> +	}
>> +}
>> +
>>  static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>>  {
>>  	u32 user_features = 0;
>> +	int err;
>>  
>>  	if (a[OVS_DP_ATTR_USER_FEATURES]) {
>>  		user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
>>  
>>  		if (user_features & ~(OVS_DP_F_VPORT_PIDS |
>>  				      OVS_DP_F_UNALIGNED |
>> -				      OVS_DP_F_TC_RECIRC_SHARING))
>> +				      OVS_DP_F_TC_RECIRC_SHARING |
>> +				      OVS_DP_F_DISPATCH_UPCALL_PER_CPU))
>>  			return -EOPNOTSUPP;
>>  
>>  #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>> @@ -1620,6 +1678,14 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>>  
>>  	dp->user_features = user_features;
>>  
>> +	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
>> +	    a[OVS_DP_ATTR_PER_CPU_PIDS]) {
>> +		/* Upcall Netlink Port IDs have been updated */
>> +		err = ovs_dp_set_upcall_portids(dp, a[OVS_DP_ATTR_PER_CPU_PIDS]);
>> +		if (err)
>> +			return err;
>> +	}
> 
> It is possible to switch between per_cpu_pids and per_ports_pids
> and vice versa. It seems this patch doesn't count for that.

Yes, it is possible (see also thread with Pravin for partially related
question). There is nothing that needs to be done here, *i think*. In
the case going from "per-cpu" to "per-vport", user space will recreate
the dpif instance and recreate all threads. This will force netlink
sockets to be assigned to each vport and it should behave as before. Its
worth noting that assigning netlink sockets to vports happens as part of
the vport code rather than the datapath code. This seems to work as per
my testing (feel free to reproduce in case I am missing something). In
the case "per-vport" to "per-cpu", the dpif will get recreated and the
threads recreated which will send a message and trigger the
ovs_dp_change() clause above.

FYI: As part of checking this, I noticed I wasn't freeing the 'struct
dp_nlsk_portid' structure on deletion of a datapath. I have rectified that.

> 
> 
>> +
>>  	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
>>  		static_branch_enable(&tc_recirc_sharing_support);
>>  	else
>> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
>> index 38f7d3e66ca6..6003eba81958 100644
>> --- a/net/openvswitch/datapath.h
>> +++ b/net/openvswitch/datapath.h
>> @@ -50,6 +50,21 @@ struct dp_stats_percpu {
>>  	struct u64_stats_sync syncp;
>>  };
>>  
>> +/**
>> + * struct dp_portids - array of netlink portids of for a datapath.
>> + *                     This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
>> + *                     is enabled and must be protected by rcu.
>> + * @rcu: RCU callback head for deferred destruction.
>> + * @n_ids: Size of @ids array.
>> + * @ids: Array storing the Netlink socket PIDs indexed by CPU ID for packets
>> + *       that miss the flow table.
>> + */
>> +struct dp_portids {
>> +	struct rcu_head rcu;
>> +	u32 n_ids;
>> +	u32 ids[];
>> +};
> 
> It doesn't have any relation to ports, so the name is somewhat
> misleading and confusing with the existing one.  What do you
> think about the suggestion below:
> 
> 	struct dp_nlsk_pids {
> 		struct rcu_head rcu;
> 		u32 n_pids;
> 		u32 pids[];
> 	};
> 

Port refers to "Netlink Ports" rather than vports. The equivalent
structure in the vport case is 'vport_portids'. However, it is
misleading. I have taken your suggestion.

>> +
>>  /**
>>   * struct datapath - datapath for flow-based packet switching
>>   * @rcu: RCU callback head for deferred destruction.
>> @@ -61,6 +76,7 @@ struct dp_stats_percpu {
>>   * @net: Reference to net namespace.
>>   * @max_headroom: the maximum headroom of all vports in this datapath; it will
>>   * be used by all the internal vports in this dp.
>> + * @upcall_portids: RCU protected 'struct dp_portids'.
>>   *
>>   * Context: See the comment on locking at the top of datapath.c for additional
>>   * locking information.
>> @@ -87,6 +103,8 @@ struct datapath {
>>  
>>  	/* Switch meters. */
>>  	struct dp_meter_table meter_tbl;
>> +
>> +	struct dp_portids __rcu *upcall_portids;
>>  };
>>  
>>  /**
>> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
>> index fd1f809e9bc1..97242bc1d960 100644
>> --- a/net/openvswitch/flow_netlink.c
>> +++ b/net/openvswitch/flow_netlink.c
>> @@ -2928,10 +2928,6 @@ static int validate_userspace(const struct nlattr *attr)
>>  	if (error)
>>  		return error;
>>  
>> -	if (!a[OVS_USERSPACE_ATTR_PID] ||
>> -	    !nla_get_u32(a[OVS_USERSPACE_ATTR_PID]))
>> -		return -EINVAL;
>> -
> 
> It can't be removed because it is still required by ovs_dp_upcall().
> 
> There is a problem with the action output_userspace which still
> uses the netlink OVS_USERSPACE_ATTR_PID to set upcall.portid.
> Later ovs_dp_upcall() returns -ENOTCONN if that is missing.
> 
> The userspace patchset posted together with this patch does:
> 
>   static uint32_t
>   dpif_netlink_port_get_pid(const struct dpif *dpif_, odp_port_t port_no)
>   {
>       const struct dpif_netlink *dpif = dpif_netlink_cast(dpif_);
>       uint32_t ret;
>   
>       /* In per-cpu dispatch mode, vports do not have an associated PID */
>       if (DISPATCH_MODE_PER_CPU(dpif)) {
>           return 0;
>       }
>   
> That is used by compose_slow_path() to create userspace actions. So,
> it seems all userspace actions would be using id 0 and that would
> discarded by the kernel with -ENOTCONN.

I fixed this.

>  
> --
> fbl
> 

