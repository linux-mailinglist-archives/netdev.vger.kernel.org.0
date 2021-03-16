Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F1433D8BC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbhCPQI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238488AbhCPQId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:08:33 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF3C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:08:32 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u20so21174058lja.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=vyVrZvMKmWPOpAScB4nlD7pStEs4E0/yinO5ezihqbI=;
        b=i6iuy5UuYSngMzE0qQvkZkTLypKdZvx9qt8jgeZ0kBw3QqknwRmqyVzi1f/o6DIqvY
         v9BzIAD/kJQwiiJjt5COY33f75Ku+BsH0VUpgH1P/KsUF7qJMjYSanv5rgIGe/BliO+o
         ErL1gDRt85d+5wbCatzNODVJjZG76U1FGXvAGLmG72pIiJmUnhrdVNWaFLtzHB2xVvP+
         5ZMNod69zhDt2BUnea01MlstbA3EmNG/doI7sHTeL7VrHeNs4Z2DJ/fpUOfDq+Ytk9ZK
         4ZLtTxEO4UZVQVz0pj1NkZ4NpkLWaQhrwe2h+ExStxK0Rqp6CWETq8UmLIR/n7rHCiTb
         ynNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vyVrZvMKmWPOpAScB4nlD7pStEs4E0/yinO5ezihqbI=;
        b=J3QAte9XYZZCpwtyYA/BP6xEjiIqK64qmTH/4CisvHZOoh32Ksa/JcoTu5WguEvg/y
         tcS2E6zGLvkRWDUGmvHa2IHRxEW8MtrfzwQcimKaIGj/Zgxk93uDF5d7wZ5yNec2wThc
         V3zB2ehRcuXepHAXm0f4VBcw8IOowxO/dyCSHabYv6SwbNBGaEZ+cjt5pvvbG96ZJhr/
         J9/zh28gpza/gwr9FfuzotgyPsdnH6T4t15kiF4i/ppnABoerMV21JG4KLKlI3jP/pN5
         JOd6ZlkCtaiBKHEqw6P0RhcBwWyDwqBavl9KIE+AgTZ4KlA4VxCzBzyWfCP6NC8IdHVg
         aOzg==
X-Gm-Message-State: AOAM5310WOguWf8ldRDVG9eyM3j6NMTxB4kXd3Cd1nZfSWmWtTzOztnF
        DV2UmWflp+HMJJNow3T0lExJ40dtB4GhXqh2
X-Google-Smtp-Source: ABdhPJzMU+M/FJ0NOkE/TtL1vm1IvNblwoc9rywezd973QlYtUR4fQgZUP+WVJ685w7wNY96XTyIDA==
X-Received: by 2002:a2e:9857:: with SMTP id e23mr3151374ljj.78.1615910910173;
        Tue, 16 Mar 2021 09:08:30 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id j18sm3052564lfe.145.2021.03.16.09.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 09:08:29 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Centralize validation of VLAN configuration
In-Reply-To: <20210315234956.2yt4ypwzqaesw72b@skbuf>
References: <20210315195413.2679929-1-tobias@waldekranz.com> <20210315234956.2yt4ypwzqaesw72b@skbuf>
Date:   Tue, 16 Mar 2021 17:08:28 +0100
Message-ID: <878s6nozcz.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 01:49, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 08:54:13PM +0100, Tobias Waldekranz wrote:
>> There are four kinds of events that have an inpact on VLAN
>
> impact
>
>> configuration of DSA ports:
>> 
>> - Adding VLAN uppers
>>   (ip link add dev swp0.1 link swp0 type vlan id 1)
> (..)

Parse error; I need more context :)

>> +static bool dsa_8021q_uppers_are_coherent(struct dsa_switch_tree *dst,
>> +					  struct net_device *br,
>> +					  bool seen_vlan_upper,
>
> have_8021q_uppers_in_bridge maybe?

I like that the current name hints of a relation with
seen_offloaded. Your suggestion seems awfully long for an argument name.

>
>> +					  unsigned long *upper_vids,
>> +					  struct netlink_ext_ack *extack)
>> +{
>> +	struct net_device *lower, *upper;
>> +	struct list_head *liter, *uiter;
>
> It doesn't hurt to name them lower_iter, upper_iter?
>
>> +	struct dsa_slave_priv *priv;
>> +	bool seen_offloaded = false;
>> +	u16 vid;
>> +
>> +	netdev_for_each_lower_dev(br, lower, liter) {
>> +		priv = dsa_slave_dev_lower_find(lower);
>> +		if (!priv || priv->dp->ds->dst != dst)
>> +			/* Ignore ports that are not related to us in
>> +			 * any way.
>> +			 */
>> +			continue;
>
> So "priv" is the lower of a bridge port...
>
>> +
>> +		if (is_vlan_dev(lower)) {
>> +			seen_vlan_upper = true;
>> +			continue;
>> +		}
>
> But in the code path below, that bridge port is not a VLAN... So it must
> be a LAG or a HSR ring....
>
>> +		if (dsa_port_offloads_bridge(priv->dp, br) &&
>> +		    dsa_port_offloads_bridge_port(priv->dp, lower))
>> +			seen_offloaded = true;
>> +		else
>> +			/* Non-offloaded uppers can to whatever they
>
> s/can to/can do/
>
>> +			 * want.
>> +			 */
>> +			continue;
>
> Which is offloaded..
>
>> +		netdev_for_each_upper_dev_rcu(lower, upper, uiter) {
>> +			if (!is_vlan_dev(upper))
>> +				continue;
>
> So this iterates through VLAN uppers of offloaded LAGs and HSR rings?
> Does it also iterate through 8021q uppers of "priv" somehow?

As you discovered below, dsa_slave_dev_lower_find now also matches the
starting device as well as any device below it. So we iterate through
all uppers of any bridge port that this tree is offloading.

>> +			vid = vlan_dev_vlan_id(upper);
>> +			if (!test_bit(vid, upper_vids)) {
>> +				set_bit(vid, upper_vids);
>> +				continue;
>> +			}
>> +
>> +			NL_SET_ERR_MSG_MOD(extack,
>> +					   "Multiple VLAN interfaces cannot use the same VID");
>> +			return false;
>> +		}
>> +	}
>> +
>> +	if (seen_offloaded && seen_vlan_upper) {
>> +		NL_SET_ERR_MSG_MOD(extack,
>> +				   "VLAN interfaces cannot share bridge with offloaded port");
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static bool dsa_bridge_vlans_are_coherent(struct net_device *br,
>> +					  u16 new_vid, unsigned long *upper_vids,
>
> const unsigned long *upper_vids
>
>> +					  struct netlink_ext_ack *extack)
>> +{
>> +	u16 vid;
>> +
>> +	if (new_vid && test_bit(new_vid, upper_vids))
>> +		goto err;
>> +
>> +	for_each_set_bit(vid, upper_vids, VLAN_N_VID) {
>> +		struct bridge_vlan_info br_info;
>> +
>> +		if (br_vlan_get_info(br, vid, &br_info))
>
> You should only error out if VLAN filtering is enabled/turning on in the
> bridge, no?

We only validate upper and bridge VLAN coherency for filtering
bridges. Otherwise we return early from dsa_bridge_is_coherent.

>> +			/* Error means that the VID does not exist,
>> +			 * which is what we want to ensure.
>> +			 */
>> +			continue;
>> +
>> +		goto err;
>> +	}
>> +
>> +	return true;
>> +
>> +err:
>> +	NL_SET_ERR_MSG_MOD(extack, "No bridge VID may be used on a related VLAN interface");
>> +	return false;
>> +}
>> +
>> +/**
>> + * dsa_bridge_is_coherent - Verify that DSA tree accepts a bridge config.
>> + * @dst: Tree to verify against.
>> + * @br: Bridge netdev to verify.
>> + * @mod: Description of the modification to introduce.
>> + * @extack: Netlink extended ack for error reporting.
>> + *
>> + * Verify that the VLAN config of @br, its offloaded ports belonging
>> + * to @dst and their VLAN uppers, can be correctly offloaded after
>> + * introducing the change described by @mod. If this is not the case,
>> + * an error is reported via @extack.
>> + *
>> + * Return: true if the config can be offloaded, false otherwise.
>> + */
>> +bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
>> +			    struct dsa_bridge_mod *mod,
>> +			    struct netlink_ext_ack *extack)
>> +{
>> +	unsigned long *upper_vids = NULL;
>
> initialization with NULL is pointless.
>
>> +	bool filter;
>> +
>> +	if (mod->filter)
>> +		filter = *mod->filter;
>> +	else
>> +		filter = br && br_vlan_enabled(br);
>> +
>> +	if (!dsa_bridge_filtering_is_coherent(dst, filter, extack))
>> +		goto err;
>> +
>> +	if (!filter)
>> +		return true;
>> +
>> +	upper_vids = bitmap_zalloc(VLAN_N_VID, GFP_KERNEL);
>> +	if (!upper_vids) {
>> +		WARN_ON_ONCE(1);
>
> if (WARN_ON_ONCE(!upper_vids))
>
>> +		goto err;
>> +	}
>> +
>> +	if (mod->upper_vid)
>> +		set_bit(mod->upper_vid, upper_vids);
>> +
>> +	if (!dsa_8021q_uppers_are_coherent(dst, br, mod->bridge_upper,
>> +					   upper_vids, extack))
>> +		goto err_free;
>> +
>> +	if (!dsa_bridge_vlans_are_coherent(br, mod->br_vid, upper_vids, extack))
>> +		goto err_free;
>> +
>> +	kfree(upper_vids);
>> +	return true;
>> +
>> +err_free:
>> +	kfree(upper_vids);
>> +err:
>> +	return false;
>> +}
>> +
>>  /**
>>   * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
>>   * @dst: collection of struct dsa_switch devices to notify.
>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>> index 9d4b0e9b1aa1..8d8d307df437 100644
>> --- a/net/dsa/dsa_priv.h
>> +++ b/net/dsa/dsa_priv.h
>> @@ -361,6 +369,27 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
>>  void dsa_switch_unregister_notifier(struct dsa_switch *ds);
>>  
>>  /* dsa2.c */
>> +
>> +/**
>> + * struct dsa_bridge_mod - Modification of bridge related config
>> + * @filter: If non-NULL, the new state of VLAN filtering.
>> + * @br_vid: If non-zero, this VID will be added to the bridge.
>> + * @upper_vid: If non-zero, a VLAN upper using this VID will be added to
>> + *             a bridge port.
>> + * @bridge_upper: If non-NULL, a VLAN upper will be added to the bridge.
>
> I would name this "add_8021q_upper_to_bridge". Longer name, but clearer.

It is not like it is a global variable or anything, there is plenty of
context here I think. You know that you are describing a bridge related
VLAN modification.

>> + *
>> + * Describes a bridge related modification that is about to be applied.
>> + */
>> +struct dsa_bridge_mod {
>> +	bool *filter;
>> +	u16   br_vid;
>> +	u16   upper_vid;
>> +	bool  bridge_upper;
>> +};
>
> Frankly this is a bit ugly, but I have no better idea, and the structure
> is good enough for describing a state transition. Fully describing the
> state is a lot more difficult, due to the need to list all bridges which
> may span a DSA switch tree.

I am not sure what to make of this. Its job _is_ to describe a state
transition. Why would we want to describe the state? The kernel already
has the state, which is what dsa_bridge_is_coherent uses to figure out
if the change can be applied or not.

Is it sexy? No, I guess not. This type of code seldom is. The
alternative would be to cram the info into the argument list, but that
makes the wrappers harder to read and it makes it harder to extend when
we want to validate another invariant.

>> +bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
>> +			    struct dsa_bridge_mod *mod,
>> +			    struct netlink_ext_ack *extack);
>>  void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
>>  void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
>>  int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
> (...)

?

>> -static struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
>> +struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
>>  {
>>  	struct netdev_nested_priv priv = {
>>  		.data = NULL,
>>  	};
>>  
>> +	if (dsa_slave_dev_check(dev))
>> +		return netdev_priv(dev);
>> +
>>  	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
>>  
>>  	return (struct dsa_slave_priv *)priv.data;
>
> Ah, so that's what you did there. I don't like it. If the function is
> called "lower_find" and you come back with "dev" itself, I think that
> would qualify as "unexpected". Could you create a new function called
> dsa_slave_find_in_lowers_or_self, or something like that, which calls
> dsa_slave_dev_lower_find with the extra identity check?

My assumption was the opposite. Looking through the kernel, there seem
to be three other logical equivalents:

drivers/net/ethernet/marvell/prestera/prestera_main.c
495:struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)

drivers/net/ethernet/mellanox/mlxsw/spectrum.c
3406:struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev)

drivers/net/ethernet/rocker/rocker_main.c
3090:struct rocker_port *rocker_port_dev_lower_find(struct net_device *dev,

All three will check the starting device before walking any lowers.

Thank you!
