Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5954248436B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiADOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiADOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:32:37 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAEEC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 06:32:37 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l4so23360770wmq.3
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 06:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ehGBWqd8R0ymWvD1TaxWLLIG3AmbBq8t3LiR9wa8KvI=;
        b=fEZz9tfyZe4KqcoUvaqhTXrevQqkBTx8jstWi9S7tGhRa092kZlV/r8PBeuQasAMt4
         pUoY08k+dcdoh3+oWmlM3YKu2BmvKzSqMiy4ZF9d2XwCU4fvv4vW/3w7IqKSqVXebIOk
         qCnnF0K7OHPxpbHFCqtlz8oUZDyo3ymbDHB7EuBzp7FFi2D6Gn784TZjiiILbjh8zmE9
         4fguA2gTSTJ1GZc+2IiXnYfV/jgaQri/w43hcztMsaGCnft+iQXnBT9adruJddozlwH7
         /upNBeFhY3E5Ptnc2g3BG2GxlOKDmu4ka8C1aYgRf/Fu/m+3nzQdYft+ATwocD/Fl0oh
         dVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ehGBWqd8R0ymWvD1TaxWLLIG3AmbBq8t3LiR9wa8KvI=;
        b=1/2Fn9CCCj6MHcmgQUUMJ8ob2+y0ortJcxZWv8BqWN1kd/fQ5B0tn8BJnvewDpSI3A
         aJHIEyIiuPtQRN/a1BmvstGlaOdEHElVdY52EF/L6VIuW7mN09oBrJP8UOgHsk8zexib
         SDRAveql5TElqWISIgm3QEufk5X0Gt2ImF5UcrwBSQ1/GrEe80BHQYRgpLJ7nK1fx+HQ
         o2Krd1pH1bTMtUsbcHqdCYoMVZfZDZkVR/+p2ulJBM5V5EDPNfthbWuKJarzl8TeVsJ1
         CpAiT72pPl9DzpvH3tSSsEX+VZCMxlAWxYhHjEHw4MtfLX2Ro1mEO7MKBt/axSZJRjwX
         vucA==
X-Gm-Message-State: AOAM5319nCXhcGmwSmRFH5pzR3cf+AVNdEB/H2VzVVKh1MrI80czAEjs
        b5tkyyp8ZqC/515zDoenkV9sKscHGbtrTA==
X-Google-Smtp-Source: ABdhPJwuUge8+rkpLYvt2SivAUjEH14S5g2jNilADpLEyDM4coTJq9FhN+lZ3iVyVu+5TLRBlaYsGA==
X-Received: by 2002:a05:600c:1f19:: with SMTP id bd25mr42207635wmb.42.1641306755671;
        Tue, 04 Jan 2022 06:32:35 -0800 (PST)
Received: from [10.0.0.4] ([37.165.184.46])
        by smtp.gmail.com with ESMTPSA id z5sm37136388wru.87.2022.01.04.06.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 06:32:35 -0800 (PST)
Message-ID: <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
Date:   Tue, 4 Jan 2022 06:32:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, idosch@idosch.org,
        nicolas.dichtel@6wind.com, nikolay@nvidia.com
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220104081053.33416-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/4/22 00:10, Lahav Schlesinger wrote:
> Under large scale, some routers are required to support tens of thousands
> of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> vrfs, etc).
> At times such routers are required to delete massive amounts of devices
> at once, such as when a factory reset is performed on the router (causing
> a deletion of all devices), or when a configuration is restored after an
> upgrade, or as a request from an operator.
>
> Currently there are 2 means of deleting devices using Netlink:
> 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> or by name using IFLA_IFNAME)
> 2. Delete all device that belong to a group (using IFLA_GROUP)
>
> Deletion of devices one-by-one has poor performance on large scale of
> devices compared to "group deletion":
> After all device are handled, netdev_run_todo() is called which
> calls rcu_barrier() to finish any outstanding RCU callbacks that were
> registered during the deletion of the device, then wait until the
> refcount of all the devices is 0, then perform final cleanups.
>
> However, calling rcu_barrier() is a very costly operation, each call
> taking in the order of 10s of milliseconds.
>
> When deleting a large number of device one-by-one, rcu_barrier()
> will be called for each device being deleted.
> As an example, following benchmark deletes 10K loopback devices,
> all of which are UP and with only IPv6 LLA being configured:
>
> 1. Deleting one-by-one using 1 thread : 243 seconds
> 2. Deleting one-by-one using 10 thread: 70 seconds
> 3. Deleting one-by-one using 50 thread: 54 seconds
> 4. Deleting all using "group deletion": 30 seconds
>
> Note that even though the deletion logic takes place under the rtnl
> lock, since the call to rcu_barrier() is outside the lock we gain
> some improvements.
>
> But, while "group deletion" is the fastest, it is not suited for
> deleting large number of arbitrary devices which are unknown a head of
> time. Furthermore, moving large number of devices to a group is also a
> costly operation.
>
> This patch adds support for passing an arbitrary list of ifindex of
> devices to delete with a new IFLA_IFINDEX attribute. A single message
> may contain multiple instances of this attribute).
> This gives a more fine-grained control over which devices to delete,
> while still resulting in rcu_barrier() being called only once.
> Indeed, the timings of using this new API to delete 10K devices is
> the same as using the existing "group" deletion.
>
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
> v5 -> v6
>   - Convert back to single IFLA_IFINDEX_LIST attribute instead of
>     IFLA_IFINDEX
>   - Added struct net_device::bulk_delete to avoid sorting ifindex list,
>     in order to call ->dellink() only once per potentially duplicated ifindex
>     (no increase in struct size)
>   - Make sure IFLA_IFINDEX_LIST cannot be used in
>     setlink()/newlink()/getlink()
>
> v4 -> v5
>   - Don't call ->dellink() multiple times if device is duplicated.
>
> v3 -> v4
>   - Change single IFLA_INDEX_LIST into multiple IFLA_IFINDEX
>   - Fail if passing both IFLA_GROUP and at least one IFLA_IFNEX
>
> v2 -> v3
>   - Rename 'ifindex_list' to 'ifindices', and pass it as int*
>   - Clamp 'ops' variable in second loop.
>
> v1 -> v2
>   - Unset 'len' of IFLA_IFINDEX_LIST in policy.
>   - Use __dev_get_by_index() instead of n^2 loop.
>   - Return -ENODEV if any ifindex is not present.
>   - Saved devices in an array.
>   - Fix formatting.
>
>   include/linux/netdevice.h    |  3 ++
>   include/uapi/linux/if_link.h |  1 +
>   net/core/rtnetlink.c         | 77 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 81 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index df049864661d..c3cfbfaf7f06 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1926,6 +1926,8 @@ enum netdev_ml_priv_type {
>    *
>    *	@threaded:	napi threaded mode is enabled
>    *
> + *	@bulk_delete:	Device is marked for of bulk deletion
> + *
>    *	@net_notifier_list:	List of per-net netdev notifier block
>    *				that follow this device when it is moved
>    *				to another network namespace.
> @@ -2258,6 +2260,7 @@ struct net_device {
>   	bool			proto_down;
>   	unsigned		wol_enabled:1;
>   	unsigned		threaded:1;
> +	unsigned		bulk_delete:1;
>   
>   	struct list_head	net_notifier_list;
>   
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index eebd3894fe89..f950bf6ed025 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -348,6 +348,7 @@ enum {
>   	IFLA_PARENT_DEV_NAME,
>   	IFLA_PARENT_DEV_BUS_NAME,
>   
> +	IFLA_IFINDEX_LIST,
>   	__IFLA_MAX
>   };
>   
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index fd030e02f16d..530371767565 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>   	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
>   	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
>   	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
> +	[IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY },
>   };
>   
>   static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -3009,6 +3010,11 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   		goto errout;
>   	}
>   
> +	if (tb[IFLA_IFINDEX_LIST]) {
> +		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in setlink");
> +		goto errout;
> +	}
> +
>   	err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
>   errout:
>   	return err;
> @@ -3050,6 +3056,57 @@ static int rtnl_group_dellink(const struct net *net, int group)
>   	return 0;
>   }
>   
> +static int rtnl_list_dellink(struct net *net, int *ifindices, int size,
> +			     struct netlink_ext_ack *extack)
> +{
> +	const int num_devices = size / sizeof(int);
> +	struct net_device *dev;
> +	LIST_HEAD(list_kill);
> +	int i, j, ret;
> +
> +	if (size <= 0 || size % sizeof(int))
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_devices; i++) {
> +		const struct rtnl_link_ops *ops;
> +
> +		ret = -ENODEV;
> +		dev = __dev_get_by_index(net, ifindices[i]);


What happens if one device is present multiple times in ifindices[] ?

This should be an error.


> +		if (!dev) {
> +			NL_SET_ERR_MSG(extack, "Unknown ifindex");
> +			goto cleanup;
> +		}
> +
> +		ret = -EOPNOTSUPP;
> +		ops = dev->rtnl_link_ops;
> +		if (!ops || !ops->dellink) {
> +			NL_SET_ERR_MSG(extack, "Device cannot be deleted");
> +			goto cleanup;
> +		}
> +
> +		dev->bulk_delete = 1;
> +	}
> +
> +	for_each_netdev(net, dev) {

This is going to be very expensive on hosts with 1 million netdev.

You should remove this dev->bulk_delete and instead use a list.

You already use @list_kill, you only need a second list and possibly 
reuse dev->unreg_list

If you do not feel confortable about reusing dev->unreg_list, add a new 
anchor (like dev->bulk_kill_list)

> +		if (dev->bulk_delete) {
> +			dev->rtnl_link_ops->dellink(dev, &list_kill);
> +			dev->bulk_delete = 0;
> +		}
> +	}
> +
> +	unregister_netdevice_many(&list_kill);
> +
> +	return 0;
> +
> +cleanup:
> +	for (j = 0; j < i; j++) {
> +		dev = __dev_get_by_index(net, ifindices[j]);
> +		dev->bulk_delete = 0;
> +	}
> +
> +	return ret;
> +}
> +
>   int rtnl_delete_link(struct net_device *dev)
>   {
>   	const struct rtnl_link_ops *ops;
> @@ -3093,6 +3150,11 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   			return PTR_ERR(tgt_net);
>   	}
>   
> +	if (tb[IFLA_GROUP] && tb[IFLA_IFINDEX_LIST]) {
> +		NL_SET_ERR_MSG(extack, "Can't pass both IFLA_GROUP and IFLA_IFINDEX_LIST");
> +		return -EOPNOTSUPP;
> +	}
> +
>   	err = -EINVAL;
>   	ifm = nlmsg_data(nlh);
>   	if (ifm->ifi_index > 0)
> @@ -3102,6 +3164,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   				   tb[IFLA_ALT_IFNAME], NULL);
>   	else if (tb[IFLA_GROUP])
>   		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> +	else if (tb[IFLA_IFINDEX_LIST])
> +		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
> +					nla_len(tb[IFLA_IFINDEX_LIST]), extack);
>   	else
>   		goto out;
>   
> @@ -3285,6 +3350,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	else
>   		ifname[0] = '\0';
>   
> +	err = -EINVAL;
> +	if (tb[IFLA_IFINDEX_LIST]) {
> +		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in newlink");
> +		return err;
> +	}
> +
>   	ifm = nlmsg_data(nlh);
>   	if (ifm->ifi_index > 0)
>   		dev = __dev_get_by_index(net, ifm->ifi_index);
> @@ -3577,6 +3648,12 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	if (err < 0)
>   		return err;
>   
> +	err = -EINVAL;
> +	if (tb[IFLA_IFINDEX_LIST]) {
> +		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in getlink");
> +		return err;
> +	}
> +
>   	if (tb[IFLA_TARGET_NETNSID]) {
>   		netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
>   		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
