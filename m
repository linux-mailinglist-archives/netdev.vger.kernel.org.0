Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C827833CA29
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 00:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhCOXub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 19:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhCOXt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 19:49:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860ECC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 16:49:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o19so19413501edc.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 16:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vgqly2UW9pgLlUXgoaXvuhEQGXnWOSTwi6Z1tT5n0TU=;
        b=TuA6PxI//bL+kRpcWmgaoHZ36FRTaZHrLpOkMr2s6ooQwW658hWUsv4o81eKhWL81f
         Foa4W81PFBxS2nWCPAZ83Tl2XTMAHQBcDsd9PMaV606SMcuP4ShaAwq6fS6tqBUpb4RZ
         /bRqQpxC7mX/KWJOCPqruJnKeocufmoaV/JsUptrsa2R9W5ywAMxeCTzqRdjYxq9Uws/
         zjGEvpqV2NADTRYuR7nzLpOaOqdPhBPjWAjnsvkmYKe55U3r6G8C1pp0RIsHMJwFeFA1
         sq41Uk35t7620AzEiS+xNIugGI5hRhil2gxLRpUKuLDneFFFEk3dcHMf0YDQkldIwQu1
         kgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vgqly2UW9pgLlUXgoaXvuhEQGXnWOSTwi6Z1tT5n0TU=;
        b=liMUnoeQQ7eHbEFwR6kyGipLzqe9BrJR8nJt5XnE/548e4UNf1t/XU+8QcdBOKZ11B
         H017w1wJOmoOTZgzxP1MNAwMS/aWQtomXmyBYbBTnpDBE2f0Nk54dNFCSgvnPjTTVerq
         SIHOZbU9Pihs8T+T+17Yl/hBR3C3poKuTiD0JUAcVQtYQUxPNXizqMfh0DxznA7koTM/
         IkrvxdLdhvMKG8aqOFdG3Sg0Jw+c8bWBuXdHwGCEVzKtY97goZzkNZcazqQ0g5wBlZi+
         6SZ0fm9WV5LGFHlQ01ood2+R1elKpEgT472QDRl3vHWbRG6TEeprnBaNDS42BHW2K2Lf
         oo2Q==
X-Gm-Message-State: AOAM530IktZJaHqLFY0ztvwQa1zjBhaF0hy3w0XB70Si8t0894Ce1pkB
        RSWzXfkGwVc+9Rse8dTC+6g=
X-Google-Smtp-Source: ABdhPJz2+eBFSgZXs8SnZmLxyqw5mIpghDLvbnEd5RUQNyPzSe0Ibax1YxyQ4VJscIFpMv/NusFsSA==
X-Received: by 2002:aa7:da04:: with SMTP id r4mr32869016eds.343.1615852197300;
        Mon, 15 Mar 2021 16:49:57 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id de17sm8152178ejc.16.2021.03.15.16.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 16:49:57 -0700 (PDT)
Date:   Tue, 16 Mar 2021 01:49:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <20210315234956.2yt4ypwzqaesw72b@skbuf>
References: <20210315195413.2679929-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315195413.2679929-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 08:54:13PM +0100, Tobias Waldekranz wrote:
> There are four kinds of events that have an inpact on VLAN

impact

> configuration of DSA ports:
> 
> - Adding VLAN uppers
>   (ip link add dev swp0.1 link swp0 type vlan id 1)
(..)
> +static bool dsa_8021q_uppers_are_coherent(struct dsa_switch_tree *dst,
> +					  struct net_device *br,
> +					  bool seen_vlan_upper,

have_8021q_uppers_in_bridge maybe?

> +					  unsigned long *upper_vids,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct net_device *lower, *upper;
> +	struct list_head *liter, *uiter;

It doesn't hurt to name them lower_iter, upper_iter?

> +	struct dsa_slave_priv *priv;
> +	bool seen_offloaded = false;
> +	u16 vid;
> +
> +	netdev_for_each_lower_dev(br, lower, liter) {
> +		priv = dsa_slave_dev_lower_find(lower);
> +		if (!priv || priv->dp->ds->dst != dst)
> +			/* Ignore ports that are not related to us in
> +			 * any way.
> +			 */
> +			continue;

So "priv" is the lower of a bridge port...

> +
> +		if (is_vlan_dev(lower)) {
> +			seen_vlan_upper = true;
> +			continue;
> +		}

But in the code path below, that bridge port is not a VLAN... So it must
be a LAG or a HSR ring....

> +		if (dsa_port_offloads_bridge(priv->dp, br) &&
> +		    dsa_port_offloads_bridge_port(priv->dp, lower))
> +			seen_offloaded = true;
> +		else
> +			/* Non-offloaded uppers can to whatever they

s/can to/can do/

> +			 * want.
> +			 */
> +			continue;

Which is offloaded..

> +		netdev_for_each_upper_dev_rcu(lower, upper, uiter) {
> +			if (!is_vlan_dev(upper))
> +				continue;

So this iterates through VLAN uppers of offloaded LAGs and HSR rings?
Does it also iterate through 8021q uppers of "priv" somehow?

> +			vid = vlan_dev_vlan_id(upper);
> +			if (!test_bit(vid, upper_vids)) {
> +				set_bit(vid, upper_vids);
> +				continue;
> +			}
> +
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Multiple VLAN interfaces cannot use the same VID");
> +			return false;
> +		}
> +	}
> +
> +	if (seen_offloaded && seen_vlan_upper) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "VLAN interfaces cannot share bridge with offloaded port");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool dsa_bridge_vlans_are_coherent(struct net_device *br,
> +					  u16 new_vid, unsigned long *upper_vids,

const unsigned long *upper_vids

> +					  struct netlink_ext_ack *extack)
> +{
> +	u16 vid;
> +
> +	if (new_vid && test_bit(new_vid, upper_vids))
> +		goto err;
> +
> +	for_each_set_bit(vid, upper_vids, VLAN_N_VID) {
> +		struct bridge_vlan_info br_info;
> +
> +		if (br_vlan_get_info(br, vid, &br_info))

You should only error out if VLAN filtering is enabled/turning on in the
bridge, no?

> +			/* Error means that the VID does not exist,
> +			 * which is what we want to ensure.
> +			 */
> +			continue;
> +
> +		goto err;
> +	}
> +
> +	return true;
> +
> +err:
> +	NL_SET_ERR_MSG_MOD(extack, "No bridge VID may be used on a related VLAN interface");
> +	return false;
> +}
> +
> +/**
> + * dsa_bridge_is_coherent - Verify that DSA tree accepts a bridge config.
> + * @dst: Tree to verify against.
> + * @br: Bridge netdev to verify.
> + * @mod: Description of the modification to introduce.
> + * @extack: Netlink extended ack for error reporting.
> + *
> + * Verify that the VLAN config of @br, its offloaded ports belonging
> + * to @dst and their VLAN uppers, can be correctly offloaded after
> + * introducing the change described by @mod. If this is not the case,
> + * an error is reported via @extack.
> + *
> + * Return: true if the config can be offloaded, false otherwise.
> + */
> +bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
> +			    struct dsa_bridge_mod *mod,
> +			    struct netlink_ext_ack *extack)
> +{
> +	unsigned long *upper_vids = NULL;

initialization with NULL is pointless.

> +	bool filter;
> +
> +	if (mod->filter)
> +		filter = *mod->filter;
> +	else
> +		filter = br && br_vlan_enabled(br);
> +
> +	if (!dsa_bridge_filtering_is_coherent(dst, filter, extack))
> +		goto err;
> +
> +	if (!filter)
> +		return true;
> +
> +	upper_vids = bitmap_zalloc(VLAN_N_VID, GFP_KERNEL);
> +	if (!upper_vids) {
> +		WARN_ON_ONCE(1);

if (WARN_ON_ONCE(!upper_vids))

> +		goto err;
> +	}
> +
> +	if (mod->upper_vid)
> +		set_bit(mod->upper_vid, upper_vids);
> +
> +	if (!dsa_8021q_uppers_are_coherent(dst, br, mod->bridge_upper,
> +					   upper_vids, extack))
> +		goto err_free;
> +
> +	if (!dsa_bridge_vlans_are_coherent(br, mod->br_vid, upper_vids, extack))
> +		goto err_free;
> +
> +	kfree(upper_vids);
> +	return true;
> +
> +err_free:
> +	kfree(upper_vids);
> +err:
> +	return false;
> +}
> +
>  /**
>   * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
>   * @dst: collection of struct dsa_switch devices to notify.
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 9d4b0e9b1aa1..8d8d307df437 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -361,6 +369,27 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
>  void dsa_switch_unregister_notifier(struct dsa_switch *ds);
>  
>  /* dsa2.c */
> +
> +/**
> + * struct dsa_bridge_mod - Modification of bridge related config
> + * @filter: If non-NULL, the new state of VLAN filtering.
> + * @br_vid: If non-zero, this VID will be added to the bridge.
> + * @upper_vid: If non-zero, a VLAN upper using this VID will be added to
> + *             a bridge port.
> + * @bridge_upper: If non-NULL, a VLAN upper will be added to the bridge.

I would name this "add_8021q_upper_to_bridge". Longer name, but clearer.

> + *
> + * Describes a bridge related modification that is about to be applied.
> + */
> +struct dsa_bridge_mod {
> +	bool *filter;
> +	u16   br_vid;
> +	u16   upper_vid;
> +	bool  bridge_upper;
> +};

Frankly this is a bit ugly, but I have no better idea, and the structure
is good enough for describing a state transition. Fully describing the
state is a lot more difficult, due to the need to list all bridges which
may span a DSA switch tree.

> +bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
> +			    struct dsa_bridge_mod *mod,
> +			    struct netlink_ext_ack *extack);
>  void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
>  void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
>  int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
(...)
> -static struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
> +struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
>  {
>  	struct netdev_nested_priv priv = {
>  		.data = NULL,
>  	};
>  
> +	if (dsa_slave_dev_check(dev))
> +		return netdev_priv(dev);
> +
>  	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
>  
>  	return (struct dsa_slave_priv *)priv.data;

Ah, so that's what you did there. I don't like it. If the function is
called "lower_find" and you come back with "dev" itself, I think that
would qualify as "unexpected". Could you create a new function called
dsa_slave_find_in_lowers_or_self, or something like that, which calls
dsa_slave_dev_lower_find with the extra identity check?
