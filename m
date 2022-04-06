Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6E64F6E25
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiDFXDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiDFXDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:03:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E126770851
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:01:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id p15so7258934ejc.7
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 16:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ody+iLOEZIsPkUwf3gVfaji/FmFQG/IIPCaui9ebbO4=;
        b=B4xx0kKNZyG3JPtR0vqYfPfVN3usaF7+htJTwwmoYdf3+76tdRgLJbWuHOCSFGeNmi
         oa94kNTvGk/SC2+6N/xzJdHQcJBdZbEQLJRlsoYi14BidWcLuel/eyUejKVu0GMSL5df
         xyEDvkSa6q5TMW6Z4DgPF8LbJGHdmhLrhog2U5Tev6WZudLoPQtRMq+KK39SQQ5rUkhs
         2nPPfSD2ibUe6Me2gMhpX2X02fJbkqJqKSAk90rWmmF/P6HLhj3rAnU1Hf/Xia4ub+8K
         8MwtiyVnni5mcJFcCgK0VKfpYOw0nMGpL461OvOc11SV8a5Vr9y6lwTOoK9AxqhBtEDi
         kz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ody+iLOEZIsPkUwf3gVfaji/FmFQG/IIPCaui9ebbO4=;
        b=Woy1POWmc6lgrD7pqXJyGGUC6U5ZdKKVWnKeaAjwLJdEpeI0E6hq2ppJNNIm3baUqJ
         cqqaLi8Luk1ZLfAtDGCl6BjUCvEwhBzeBlXUMPgseweK6my67F+hWRNyf9zINXB5iTOH
         bIE4zJL1tKpGIexCELjBx9AR7nHUeURV4MonFZShKNL+FGZyxP2AvUKLcRJbWj3lZnND
         eF7uW8X+cvZ3oAwJ4aonNctSKI2yhN190k3kPFWL1i23R61p7I/jOkcV3bTHiqVwjdDK
         aD6dUmvCB7N3CbHR2tl/HVb4Sw137ERYbKzpWpv0WPUdaln42+GIPLR4m7TXBnBkyPB/
         wlhA==
X-Gm-Message-State: AOAM532krLsdlQWTM4wi4MawXlCRIGm3Q3gdk40xygseNnx/Dot/+KAQ
        bxBflZl6sKceaFuNOXchTYE=
X-Google-Smtp-Source: ABdhPJx7UMLqIFyjrSWg6pDQebA2zo48u3wIh1TZ+/IhUO1UvbpkuxvJFP0Ep3vBBbag0mPXcbQj9w==
X-Received: by 2002:a17:906:7210:b0:6d6:7881:1483 with SMTP id m16-20020a170906721000b006d678811483mr10522814ejk.227.1649286097138;
        Wed, 06 Apr 2022 16:01:37 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id o22-20020a170906289600b006e44a0c1105sm7083354ejd.46.2022.04.06.16.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:01:36 -0700 (PDT)
Date:   Thu, 7 Apr 2022 02:01:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 1/2] net: tc: dsa: Add the matchall filter
 with drop action for bridged DSA ports.
Message-ID: <20220406230135.cdhd3rwugz4m4lw3@skbuf>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
 <20220404104826.1902292-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404104826.1902292-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please remove the "tc: " prefix from the commit message, you're not
modifying anything in that subsystem. Also remove the full stop at the
end of the commit message.

On Mon, Apr 04, 2022 at 12:48:25PM +0200, Mattias Forsblad wrote:
> Use the flow indirect framework on bridged DSA ports to be
> able to set up offloading of matchall filter with drop target.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h  |  14 +++
>  net/dsa/dsa2.c     |   5 +
>  net/dsa/dsa_priv.h |   3 +
>  net/dsa/port.c     |   2 +
>  net/dsa/slave.c    | 224 ++++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 244 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index ca6af86964bc..e87ceb841a70 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -247,6 +247,9 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
>  	INIT_LIST_HEAD(&dst->list);
>  	list_add_tail(&dst->list, &dsa_tree_list);
>  
> +	INIT_LIST_HEAD(&dst->tc_indr_block_list);
> +	dsa_setup_bridge_tc_indr(dst);
> +
>  	kref_init(&dst->refcount);
>  
>  	return dst;
> @@ -254,6 +257,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
>  
>  static void dsa_tree_free(struct dsa_switch_tree *dst)
>  {
> +	dsa_cleanup_bridge_tc_indr(dst);
> +
>  	if (dst->tag_ops)
>  		dsa_tag_driver_put(dst->tag_ops);
>  	list_del(&dst->list);
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 5d3f4a67dce1..456bcbe730ba 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -320,6 +320,9 @@ void dsa_slave_setup_tagger(struct net_device *slave);
>  int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
>  int dsa_slave_manage_vlan_filtering(struct net_device *dev,
>  				    bool vlan_filtering);
> +int dsa_setup_bridge_tc_indr(struct dsa_switch_tree *dst);
> +void dsa_cleanup_bridge_tc_indr(struct dsa_switch_tree *dst);
> +bool dsa_slave_dev_check(const struct net_device *dev);
>  
>  static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>  {
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 32d472a82241..0c4522cc9eae 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -361,6 +361,8 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
>  	refcount_set(&bridge->refcount, 1);
>  
>  	bridge->dev = br;
> +	bridge->local_rcv = 1;

Instead of 1 and 0 you should use true and false.

> +	bridge->local_rcv_effective = 1;
>  
>  	bridge->num = dsa_bridge_num_get(br, ds->max_num_bridges);
>  	if (ds->max_num_bridges && !bridge->num) {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 41c69a6e7854..62219210d3ea 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1246,6 +1246,67 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
>  	return err;
>  }
>  
> +static int dsa_slave_bridge_foreign_if_check(struct net_device *dev,
> +					     struct dsa_mall_drop_tc_entry *drop)
> +{
> +	struct net_device *lower_dev;
> +	struct dsa_port *dp = NULL;
> +	bool foreign_if = false;
> +	struct list_head *iter;
> +
> +	/* Check port types in this bridge */
> +	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> +		if (dsa_slave_dev_check(lower_dev))
> +			dp = dsa_slave_to_port(lower_dev);

This is subtly buggy, because "dp" may have a NULL dp->bridge (software
forwarding), which is effectively equivalent to "foreign_if = true" in
that it requires sending traffic to the CPU. Yet you don't set
"foreign_if = true" when you detect such a port.

> +		else
> +			foreign_if = true;

And this is really buggy, because the bridge port may be an offloaded
LAG device which doesn't require forwarding to the CPU, yet you mark it
as foreign_if = true.

This is actually more complicated to treat, because not only do you need
to dig deeper through the lowers of the bridge port itself, but you have
to monitor CHANGEUPPER events where info->upper_dev isn't a bridge at all.
Just consider the case where a DSA port joins a LAG which is already a
bridge port, in a bridge with foreign interfaces.

> +	}
> +
> +	/* Offload only if we have requested it and the bridge only
> +	 * contains dsa ports
> +	 */
> +	if (!dp || !dp->bridge)
> +		return 0;

And this is subtly buggy too, because you only look at the last dp you
see. But in a mixed bridge with offloaded and unoffloaded DSA interfaces,
you effectively fail to update dp->bridge->local_rcv_effective, because
the dp->bridge of the last dp may be NULL, yet you've walked through
non-NULL dp->bridge structures which you've ignored.

> +
> +	if (!foreign_if)
> +		dp->bridge->local_rcv_effective = dp->bridge->local_rcv;
> +	else
> +		dp->bridge->local_rcv_effective = 1;
> +
> +	return dp->ds->ops->bridge_local_rcv(dp->ds, dp->index, drop);

Why does this function take an "int port" as argument, if the port you
provide is just one of many? Pass the struct dsa_bridge as argument.
Not to mention this should be a cross-chip notifier, maybe a cross-tree
notifier. And that you should only call ds->ops->bridge_local_rcv() only
if "A && B" changes in logical value.

> +}
> +
> +static int
> +dsa_slave_add_cls_matchall_drop(struct net_device *dev,
> +				struct tc_cls_matchall_offload *cls,
> +				bool ingress)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_slave_priv *p = netdev_priv(dev);
> +	struct dsa_mall_tc_entry *mall_tc_entry;
> +	struct dsa_mall_drop_tc_entry *drop;
> +	struct dsa_switch *ds = dp->ds;
> +	int err;
> +
> +	if (!ds->ops->bridge_local_rcv)
> +		return -EOPNOTSUPP;
> +
> +	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
> +	if (!mall_tc_entry)
> +		return -ENOMEM;
> +
> +	mall_tc_entry->cookie = cls->cookie;
> +	mall_tc_entry->type = DSA_PORT_MALL_DROP;
> +	drop = &mall_tc_entry->drop;
> +	drop->enable = true;
> +	dp->bridge->local_rcv = 0;
> +	err = dsa_slave_bridge_foreign_if_check(dp->bridge->dev, drop);

Please check error before adding to list, and free mall_tc_entry.
In fact we have no reason to call dsa_slave_bridge_foreign_if_check(),
we need a smaller sub-function that doesn't uselessly walk again through
the lowers of dp->bridge->dev, as nothing changed there.

> +
> +	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
> +
> +	return err;
> +}
> +
>  static int
>  dsa_slave_add_cls_matchall_police(struct net_device *dev,
>  				  struct tc_cls_matchall_offload *cls,
> @@ -1320,6 +1381,9 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
>  	else if (flow_offload_has_one_action(&cls->rule->action) &&
>  		 cls->rule->action.entries[0].id == FLOW_ACTION_POLICE)
>  		err = dsa_slave_add_cls_matchall_police(dev, cls, ingress);
> +	else if (flow_offload_has_one_action(&cls->rule->action) &&
> +		 cls->rule->action.entries[0].id == FLOW_ACTION_DROP)
> +		err = dsa_slave_add_cls_matchall_drop(dev, cls, ingress);
>  
>  	return err;
>  }
> @@ -1347,6 +1411,13 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
>  		if (ds->ops->port_policer_del)
>  			ds->ops->port_policer_del(ds, dp->index);
>  		break;
> +	case DSA_PORT_MALL_DROP:
> +		if (!dp->bridge)
> +			return;
> +		dp->bridge->local_rcv = 1;
> +		mall_tc_entry->drop.enable = false;
> +		dsa_slave_bridge_foreign_if_check(dp->bridge->dev, &mall_tc_entry->drop);
> +		break;
>  	default:
>  		WARN_ON(1);
>  	}
> @@ -1430,7 +1501,8 @@ static int dsa_slave_setup_tc_cls_flower(struct net_device *dev,
>  	}
>  }
>  
> -static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
> +static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type,
> +				       void *cls,
>  				       void *cb_priv, bool ingress)
>  {
>  	struct net_device *dev = cb_priv;
> @@ -1440,9 +1512,9 @@ static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
>  
>  	switch (type) {
>  	case TC_SETUP_CLSMATCHALL:
> -		return dsa_slave_setup_tc_cls_matchall(dev, type_data, ingress);
> +		return dsa_slave_setup_tc_cls_matchall(dev, cls, ingress);
>  	case TC_SETUP_CLSFLOWER:
> -		return dsa_slave_setup_tc_cls_flower(dev, type_data, ingress);
> +		return dsa_slave_setup_tc_cls_flower(dev, cls, ingress);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -1514,6 +1586,133 @@ static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
>  	return master->netdev_ops->ndo_setup_tc(master, TC_SETUP_FT, type_data);
>  }
>  
> +static LIST_HEAD(dsa_slave_block_indr_cb_list);
> +
> +struct dsa_slave_indr_block_cb_priv {
> +	struct dsa_switch_tree *dst;
> +	struct net_device *bridge;
> +	struct list_head list;
> +};
> +
> +static int dsa_slave_setup_bridge_block_cb(enum tc_setup_type type,
> +					   void *type_data,
> +					   void *cb_priv)
> +{
> +	struct dsa_slave_indr_block_cb_priv *priv = cb_priv;
> +	struct tc_cls_matchall_offload *cls;
> +	struct dsa_port *dp;
> +	int ret = 0;
> +
> +	cls = (struct tc_cls_matchall_offload *)type_data;
> +	list_for_each_entry(dp, &priv->dst->ports, list) {
> +		if (!dp->bridge || !dp->slave)
> +			continue;
> +
> +		if (dp->bridge->dev != priv->bridge)
> +			continue;
> +
> +		ret += dsa_slave_setup_tc_block_cb(type, cls, dp->slave, true);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct dsa_slave_indr_block_cb_priv *
> +dsa_slave_tc_indr_block_cb_lookup(struct dsa_switch_tree *dst, struct net_device *netdev)
> +{
> +	struct dsa_slave_indr_block_cb_priv *cb_priv;
> +
> +	list_for_each_entry(cb_priv, &dst->tc_indr_block_list, list)
> +		if (cb_priv->bridge == netdev)
> +			return cb_priv;
> +
> +	return NULL;
> +}
> +
> +static void dsa_slave_setup_tc_indr_rel(void *cb_priv)
> +{
> +	struct dsa_slave_indr_block_cb_priv *priv = cb_priv;
> +
> +	list_del(&priv->list);
> +	kfree(priv);
> +}
> +
> +static int
> +dsa_slave_setup_bridge_tc_indr_block(struct net_device *netdev, struct Qdisc *sch,
> +				     struct dsa_switch_tree *dst,
> +				     struct flow_block_offload *f, void *data,
> +				     void (*cleanup)(struct flow_block_cb *block_cb))
> +{
> +	struct dsa_slave_indr_block_cb_priv *cb_priv;
> +	struct flow_block_cb *block_cb;
> +
> +	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> +		return -EOPNOTSUPP;
> +
> +	switch (f->command) {
> +	case FLOW_BLOCK_BIND:
> +		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
> +		if (!cb_priv)
> +			return -ENOMEM;
> +
> +		cb_priv->bridge = netdev;
> +		cb_priv->dst = dst;
> +		list_add(&cb_priv->list, &dst->tc_indr_block_list);
> +
> +		block_cb = flow_indr_block_cb_alloc(dsa_slave_setup_bridge_block_cb,
> +						    cb_priv, cb_priv,
> +						    dsa_slave_setup_tc_indr_rel, f,
> +						    netdev, sch, data, cb_priv, cleanup);
> +		if (IS_ERR(block_cb)) {
> +			list_del(&cb_priv->list);
> +			kfree(cb_priv);
> +			return PTR_ERR(block_cb);
> +		}
> +
> +		flow_block_cb_add(block_cb, f);
> +		list_add_tail(&block_cb->driver_list, &dsa_slave_block_indr_cb_list);
> +		break;
> +	case FLOW_BLOCK_UNBIND:
> +		cb_priv = dsa_slave_tc_indr_block_cb_lookup(dst, netdev);
> +		if (!cb_priv)
> +			return -ENOENT;
> +
> +		block_cb = flow_block_cb_lookup(f->block,
> +						dsa_slave_setup_bridge_block_cb,
> +						cb_priv);
> +		if (!block_cb)
> +			return -ENOENT;
> +
> +		flow_indr_block_cb_remove(block_cb, f);
> +		list_del(&block_cb->driver_list);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsa_slave_setup_bridge_tc_indr_cb(struct net_device *netdev, struct Qdisc *sch,
> +					     void *cb_priv,
> +					     enum tc_setup_type type, void *type_data,
> +					     void *data,
> +					     void (*cleanup)(struct flow_block_cb *block_cb))
> +{
> +	if (!netdev || !netif_is_bridge_master(netdev))
> +		return -EOPNOTSUPP;
> +
> +	switch (type) {
> +	case TC_SETUP_BLOCK:
> +		return dsa_slave_setup_bridge_tc_indr_block(netdev, sch, cb_priv,
> +						     type_data, data, cleanup);
> +	default:
> +		break;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +
>  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			      void *type_data)
>  {
> @@ -1535,6 +1734,17 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
>  }
>  
> +int dsa_setup_bridge_tc_indr(struct dsa_switch_tree *dst)
> +{
> +	return flow_indr_dev_register(dsa_slave_setup_bridge_tc_indr_cb, dst);

I wish I could help you here but unfortunately I'm no flow offload
expert either. existing_qdiscs_register() looks interesting, and I see
it was added in commit 74fc4f828769 ("net: Fix offloading indirect
devices dependency on qdisc order creation"), however I just see that
the flow block is bound, not that the filters are reoffloaded.
My elementary intuition says that the logic you're searching for simply
has not been written, but you should ask Eli Cohen or Ido Schimmel or
Jiri Pirko or Pablo Neira or Baowen Zheng about what to do, since the
extra logic is probably not trivial.

Under normal conditions I would have taken a deeper look at this, but it
would take me an absurd amount of time in this case, and the truth is
that I have a lot more emails to get up to speed and respond to. Sorry.

> +}
> +
> +void dsa_cleanup_bridge_tc_indr(struct dsa_switch_tree *dst)
> +{
> +	flow_indr_dev_unregister(dsa_slave_setup_bridge_tc_indr_cb,
> +				 dst, dsa_slave_setup_tc_indr_rel);
> +}
> +
>  static int dsa_slave_get_rxnfc(struct net_device *dev,
>  			       struct ethtool_rxnfc *nfc, u32 *rule_locs)
>  {
> @@ -2717,7 +2927,12 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  
>  		break;
>  	}
> -	case NETDEV_CHANGEUPPER:
> +	case NETDEV_CHANGEUPPER: {
> +		struct netdev_notifier_changeupper_info *info = ptr;
> +
> +		if (netif_is_bridge_master(info->upper_dev))
> +			dsa_slave_bridge_foreign_if_check(info->upper_dev, NULL);

I don't like this. The function returns an error code yet you are
ignoring it. I can see why that is, so please could you take this patch,
which I had in my tree for some undisclosed reason, and add it to your
series prior to yours? You may make adjustments to it as you wish.

-----------------------------[ cut here ]-----------------------------
From 9d9b9c145c3edf5e14711eed70fd96f02c733f0d Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 28 Mar 2022 16:34:13 +0300
Subject: [PATCH] net: dsa: walk through all changeupper notifier functions

Traditionally, DSA has had a single netdev notifier handling function
for each device type.

For the sake of code cleanliness, we would like to introduce more
handling functions which do one thing, but the conditions for entering
these functions start to overlap. Example: a handling function which
tracks whether any bridges contain both DSA and non-DSA interfaces.
Either this is placed before dsa_slave_changeupper(), case in which it
will prevent that function from executing, or we place it after
dsa_slave_changeupper(), case in which we will prevent it from
executing. The other alternative is to ignore errors from the new
handling function (not ideal).

To support this usage, we need to change the pattern. In the new model,
we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
if there is nothing to do. This allows the sub-functions to be
relatively free-form and independent from each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f47048a624fb..f87109e7696d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2463,6 +2463,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2517,6 +2520,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2537,6 +2543,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2566,6 +2575,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2687,22 +2699,29 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
+
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-----------------------------[ cut here ]-----------------------------

> +
>  		if (dsa_slave_dev_check(dev))
>  			return dsa_slave_changeupper(dev, ptr);
>  
> @@ -2725,6 +2940,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  			return dsa_slave_lag_changeupper(dev, ptr);
>  
>  		break;
> +	}
>  	case NETDEV_CHANGELOWERSTATE: {
>  		struct netdev_notifier_changelowerstate_info *info = ptr;
>  		struct dsa_port *dp;
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 934958fda962..0ddfce552002 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -171,6 +171,9 @@ struct dsa_switch_tree {
>  
>  	/* Track the largest switch index within a tree */
>  	unsigned int last_switch;
> +
> +	/* For tc indirect bookkeeping */
> +	struct list_head tc_indr_block_list;
>  };
>  
>  /* LAG IDs are one-based, the dst->lags array is zero-based */
> @@ -212,6 +215,7 @@ static inline int dsa_lag_id(struct dsa_switch_tree *dst,
>  enum dsa_port_mall_action_type {
>  	DSA_PORT_MALL_MIRROR,
>  	DSA_PORT_MALL_POLICER,
> +	DSA_PORT_MALL_DROP,
>  };
>  
>  /* TC mirroring entry */
> @@ -220,6 +224,11 @@ struct dsa_mall_mirror_tc_entry {
>  	bool ingress;
>  };
>  
> +/* TC drop entry */
> +struct dsa_mall_drop_tc_entry {
> +	bool enable;
> +};
> +
>  /* TC port policer entry */
>  struct dsa_mall_policer_tc_entry {
>  	u32 burst;
> @@ -234,6 +243,7 @@ struct dsa_mall_tc_entry {
>  	union {
>  		struct dsa_mall_mirror_tc_entry mirror;
>  		struct dsa_mall_policer_tc_entry policer;
> +		struct dsa_mall_drop_tc_entry drop;
>  	};
>  };
>  
> @@ -241,6 +251,8 @@ struct dsa_bridge {
>  	struct net_device *dev;
>  	unsigned int num;
>  	bool tx_fwd_offload;
> +	u8 local_rcv:1;
> +	u8 local_rcv_effective:1;

I think there's value in tracking foreign interfaces as a completely
independent process from just making the "local_rcv" effective or not.
So that would affect the naming.

Would you mind working with this change?

-----------------------------[ cut here ]-----------------------------
From fe9088bbc9d341bee6170494b9860c6f21f4c8e2 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 7 Apr 2022 00:11:37 +0300
Subject: [PATCH] net: dsa: track whether bridges have foreign interfaces in
 them

There are certain optimizations which can be done for bridges where all
bridge ports are offloaded DSA interfaces. For instance, there is no
reason to enable flooding towards the CPU, given some extra checks (the
switch supports unicast and multicast filtering, the ports aren't
promiscuous - the bridge makes them promiscuous anyway, which we need
to change - etc).

As a preparation for those optimizations, create a function called
dsa_bridge_foreign_dev_update() which updates a new boolean of struct
dsa_bridge called "have_foreign".

Note that when dsa_port_bridge_create() is first called,
dsa_bridge_foreign_dev_update() is not called. It is called slightly
later (still under rtnl_mutex), leading to some DSA switch callbacks
(->port_bridge_join) being called with a potentially not up-to-date
"have_foreign" property. This can be changed if necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  3 +-
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     |  6 ++++
 net/dsa/slave.c    | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2352d82e37b..0ea45a4acc80 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -240,8 +240,9 @@ struct dsa_mall_tc_entry {
 struct dsa_bridge {
 	struct net_device *dev;
 	unsigned int num;
-	bool tx_fwd_offload;
 	refcount_t refcount;
+	u8 tx_fwd_offload:1;
+	u8 have_foreign:1;
 };
 
 struct dsa_port {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..d610776ecd76 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,7 @@ void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index af9a815c2639..55fc54a78870 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -656,8 +656,14 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	if (err)
 		goto err_bridge_join;
 
+	err = dsa_bridge_foreign_dev_update(bridge_dev);
+	if (err)
+		goto err_foreign_update;
+
 	return 0;
 
+err_foreign_update:
+	dsa_port_bridge_leave(dp, bridge_dev);
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f87109e7696d..12a4b8dda493 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2595,6 +2595,18 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	return err;
 }
 
+static int dsa_bridge_changelower(struct net_device *dev,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	int err;
+
+	if (!netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	err = dsa_bridge_foreign_dev_update(info->upper_dev);
+	return notifier_from_errno(err);
+}
+
 static int
 dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -2720,6 +2732,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_bridge_changelower(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
 		break;
 	}
 	case NETDEV_CHANGELOWERSTATE: {
@@ -2874,6 +2890,64 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	return true;
 }
 
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
+{
+	struct net_device *first_slave = NULL, *lower;
+	bool have_foreign = false, dig_deeper = false;
+	struct dsa_bridge *bridge = NULL;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(bridge_dev, lower, iter) {
+		if (dsa_slave_dev_check(lower)) {
+			struct dsa_port *dp = dsa_slave_to_port(lower);
+
+			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
+				bridge = dp->bridge;
+				if (!first_slave)
+					first_slave = lower;
+			} else {
+				/* Unoffloaded bridge port requires software
+				 * forwarding too. In effect this is the same
+				 * as a foreign interface.
+				 */
+				have_foreign = true;
+			}
+		} else if (netif_is_lag_master(lower)) {
+			/* If the bridge port is a LAG, we don't know for sure
+			 * whether it's foreign or not, so we'll have to go
+			 * through a second pass, after we find at least one
+			 * DSA slave interface.
+			 */
+			dig_deeper = true;
+		} else {
+			have_foreign = true;
+		}
+
+		/* No need to continue if we've found all we need to know */
+		if (bridge && have_foreign)
+			goto update;
+	}
+
+	/* Bridge with no DSA interface in it. */
+	if (!bridge)
+		return NOTIFY_DONE;
+
+	if (dig_deeper) {
+		netdev_for_each_lower_dev(bridge_dev, lower, iter) {
+			if (dsa_foreign_dev_check(first_slave, lower)) {
+				have_foreign = true;
+				break;
+			}
+		}
+	}
+
+update:
+	bridge->have_foreign = have_foreign;
+	/* TODO update all other consumers of this information */
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-----------------------------[ cut here ]-----------------------------

>  	refcount_t refcount;
>  };
>  
> @@ -1034,6 +1046,8 @@ struct dsa_switch_ops {
>  	int	(*port_policer_add)(struct dsa_switch *ds, int port,
>  				    struct dsa_mall_policer_tc_entry *policer);
>  	void	(*port_policer_del)(struct dsa_switch *ds, int port);
> +	int	(*bridge_local_rcv)(struct dsa_switch *ds, int port,
> +				    struct dsa_mall_drop_tc_entry *drop);
>  	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
>  				 enum tc_setup_type type, void *type_data);
>  
> -- 
> 2.25.1
> 
