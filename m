Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7691046CB93
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243903AbhLHDgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbhLHDgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:36:18 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE15C061574;
        Tue,  7 Dec 2021 19:32:47 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so874485wmc.2;
        Tue, 07 Dec 2021 19:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=wDEmxTBdgX7D13A4R8Dti9PbZbUUGoTcO8eWmQO2hW8=;
        b=hIhG1tEtZETOX3SNFSIlbBAj4XpKWOjEZyK1PBXQH40kYPyCtl3W2RQTJakVWX+XND
         52LFUXIZ3EwN04ucQ6/JwMU1Gufeov6+dcEB8CnCh09AcncfaQ8w+glBfAhJGua2Yegq
         7kuwBgMqqJzsdyN5zXdv0aYsaq+6DE3T57QrW2pi9XrZAhSNwVXOelcSbztTDWhiCGEK
         lQX3/Jk/mGA/BVMDYgTp99h8bAHbbFEmO3tLDUvaEG5mnQkK5QuvL/es/cFcQk6X3KCo
         mCvOI4vl+AZRdUmt8sfLj6/WX+QWnIRmp3mpfH8j9L9VaMryzOc1ZPotTOkWCBxwSD0C
         z4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=wDEmxTBdgX7D13A4R8Dti9PbZbUUGoTcO8eWmQO2hW8=;
        b=TVqGuhH6sGav1zzeZpHF8Ld4F4O1lqMzAkcxsw/6w/nBZc7X3rBdz6LgOnLPVmMp3H
         smieZei69CeVg3yGYZ1TxGJegKjGnuU8CUc1sr7DTU6r/2UqycrflDJnVaDOGu04IbXC
         OcM72pl7xMRYtSrJpiDdpinn1JzexnfFgkdahQkJhyEhJgfL+4LVdJs8AWgIHUBa89pI
         r3fyE9xUelzJRBr6xaVQjWCHr9+3ePs/NoGihENZZ78mTViF3t6kwB5z5XiJHsDA80KU
         97G4ZATPlq1mVpdyz8ogkhOXM5RycCx5jSKI+o9pe+KFqXxQ1kcTQbhgs8INOMMRXNt0
         SoCw==
X-Gm-Message-State: AOAM530E8xMDXQPaMGQVfm1tpU+97idn0Uc/dYHHLbVEutS5mXk1K/KU
        qufR1H7v5WaH1znzy7jAWJU=
X-Google-Smtp-Source: ABdhPJzDpaB3XZJpLzvMlfLoLg1Y80YUEaUkB0D2qWgUrhass7ylNfr+cHcodXxjxkDb3I5OvPpaIA==
X-Received: by 2002:a05:600c:21c3:: with SMTP id x3mr12353047wmj.13.1638934365776;
        Tue, 07 Dec 2021 19:32:45 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id d6sm1441218wrn.53.2021.12.07.19.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:32:45 -0800 (PST)
Message-ID: <61b0275d.1c69fb81.efd64.83fb@mx.google.com>
X-Google-Original-Message-ID: <YbAnW4FeLczEOOGF@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 04:32:43 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
 <20211208000432.5nq47bjz3aqjvilp@skbuf>
 <20211208004051.bx5u7rnpxxt2yqwc@skbuf>
 <61afff9e.1c69fb81.92f07.6e7d@mx.google.com>
 <20211208010947.xavzcnih3xx4dxxs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208010947.xavzcnih3xx4dxxs@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 03:09:47AM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 01:42:59AM +0100, Ansuel Smith wrote:
> > On Wed, Dec 08, 2021 at 02:40:51AM +0200, Vladimir Oltean wrote:
> > > On Wed, Dec 08, 2021 at 02:04:32AM +0200, Vladimir Oltean wrote:
> > > > On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> > > > > > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > > > > > driver can use N tag drivers. So we need the switch driver to be sure
> > > > > > the tag driver is what it expects. We keep the shared state in the tag
> > > > > > driver, so it always has valid data, but when the switch driver wants
> > > > > > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > > > > > if it does not match, the core should return -EINVAL or similar.
> > > > > 
> > > > > In my proposal, the tagger will allocate the memory from its side of the
> > > > > ->connect() call. So regardless of whether the switch driver side
> > > > > connects or not, the memory inside dp->priv is there for the tagger to
> > > > > use. The switch can access it or it can ignore it.
> > > > 
> > > > I don't think I actually said something useful here.
> > > > 
> > > > The goal would be to minimize use of dp->priv inside the switch driver,
> > > > outside of the actual ->connect() / ->disconnect() calls.
> > > > For example, in the felix driver which supports two tagging protocol
> > > > drivers, I think these two methods would be enough, and they would
> > > > replace the current felix_port_setup_tagger_data() and
> > > > felix_port_teardown_tagger_data() calls.
> > > > 
> > > > An additional benefit would be that in ->connect() and ->disconnect() we
> > > > get the actual tagging protocol in use. Currently the felix driver lacks
> > > > there, because felix_port_setup_tagger_data() just sets dp->priv up
> > > > unconditionally for the ocelot-8021q tagging protocol (luckily the
> > > > normal ocelot tagger doesn't need dp->priv).
> > > > 
> > > > In sja1105 the story is a bit longer, but I believe that can also be
> > > > cleaned up to stay within the confines of ->connect()/->disconnect().
> > > > 
> > > > So I guess we just need to be careful and push back against dubious use
> > > > during review.
> > > 
> > > I've started working on a prototype for converting sja1105 to this model.
> > > It should be clearer to me by tomorrow whether there is anything missing
> > > from this proposal.
> > 
> > I'm working on your suggestion and I should be able to post another RFC
> > this night if all works correctly with my switch.
> 
> Ok. The key point with my progress so far is that Andrew may be right
> and we might need separate tagger priv pointers per port and per switch.
> At least for the cleanliness of implementation. In the end I plan to
> remove dp->priv and stay with dp->tagger_priv and ds->tagger_priv.
> 
> Here's what I have so far. I have more changes locally, but the rest it
> isn't ready and overall also a bit irrelevant for the discussion.
> I'm going to sleep now.
>

BTW, I notice we made the same mistake. Don't know if it was the problem
and you didn't notice... The notifier is not ready at times of the first
tagger setup and the tag_proto_connect is never called.
Anyway sending v2 with your suggestion applied.

> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index bdf308a5c55e..f0f702774c8d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -82,12 +82,15 @@ enum dsa_tag_protocol {
>  };
>  
>  struct dsa_switch;
> +struct dsa_switch_tree;
>  
>  struct dsa_device_ops {
>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
>  	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
>  	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
>  			     int *offset);
> +	int (*connect)(struct dsa_switch_tree *dst);
> +	void (*disconnect)(struct dsa_switch_tree *dst);
>  	unsigned int needed_headroom;
>  	unsigned int needed_tailroom;
>  	const char *name;
> @@ -279,6 +282,8 @@ struct dsa_port {
>  	 */
>  	void *priv;
>  
> +	void *tagger_priv;
> +
>  	/*
>  	 * Original copy of the master netdev ethtool_ops
>  	 */
> @@ -337,6 +342,8 @@ struct dsa_switch {
>  	 */
>  	void *priv;
>  
> +	void *tagger_priv;
> +
>  	/*
>  	 * Configuration data for this switch.
>  	 */
> @@ -689,6 +696,8 @@ struct dsa_switch_ops {
>  						  enum dsa_tag_protocol mprot);
>  	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
>  				       enum dsa_tag_protocol proto);
> +	int	(*connect_tag_protocol)(struct dsa_switch *ds,
> +					enum dsa_tag_protocol proto);
>  
>  	/* Optional switch-wide initialization and destruction methods */
>  	int	(*setup)(struct dsa_switch *ds);
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 8814fa0e44c8..3787cbce1175 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -248,8 +248,12 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
>  
>  static void dsa_tree_free(struct dsa_switch_tree *dst)
>  {
> -	if (dst->tag_ops)
> +	if (dst->tag_ops) {
> +		if (dst->tag_ops->disconnect)
> +			dst->tag_ops->disconnect(dst);
> +
>  		dsa_tag_driver_put(dst->tag_ops);
> +	}
>  	list_del(&dst->list);
>  	kfree(dst);
>  }
> @@ -1136,6 +1140,36 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
>  	dst->setup = false;
>  }
>  
> +static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
> +				   const struct dsa_device_ops *tag_ops)
> +{
> +	struct dsa_notifier_tag_proto_info info;
> +	int err;
> +
> +	if (dst->tag_ops && dst->tag_ops->disconnect)
> +		dst->tag_ops->disconnect(dst);
> +
> +	if (tag_ops->connect) {
> +		err = tag_ops->connect(dst);
> +		if (err)
> +			return err;
> +	}
> +
> +	info.tag_ops = tag_ops;
> +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info);
> +	if (err && err != -EOPNOTSUPP)
> +		goto out_disconnect;
> +
> +	dst->tag_ops = tag_ops;
> +
> +	return 0;
> +
> +out_disconnect:
> +	if (tag_ops->disconnect)
> +		tag_ops->disconnect(dst);
> +	return err;
> +}
> +
>  /* Since the dsa/tagging sysfs device attribute is per master, the assumption
>   * is that all DSA switches within a tree share the same tagger, otherwise
>   * they would have formed disjoint trees (different "dsa,member" values).
> @@ -1173,7 +1207,9 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
>  	if (err)
>  		goto out_unwind_tagger;
>  
> -	dst->tag_ops = tag_ops;
> +	err = dsa_tree_bind_tag_proto(dst, tag_ops);
> +	if (err)
> +		goto out_unwind_tagger;
>  
>  	rtnl_unlock();
>  
> @@ -1307,7 +1343,9 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
>  		 */
>  		dsa_tag_driver_put(tag_ops);
>  	} else {
> -		dst->tag_ops = tag_ops;
> +		err = dsa_tree_bind_tag_proto(dst, tag_ops);
> +		if (err)
> +			return err;
>  	}
>  
>  	dp->master = master;
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 38ce5129a33d..0db2b26b0c83 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -37,6 +37,7 @@ enum {
>  	DSA_NOTIFIER_VLAN_DEL,
>  	DSA_NOTIFIER_MTU,
>  	DSA_NOTIFIER_TAG_PROTO,
> +	DSA_NOTIFIER_TAG_PROTO_CONNECT,
>  	DSA_NOTIFIER_MRP_ADD,
>  	DSA_NOTIFIER_MRP_DEL,
>  	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 9c92edd96961..06948f536829 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -647,6 +647,17 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
>  	return 0;
>  }
>  
> +static int dsa_switch_connect_tag_proto(struct dsa_switch *ds,
> +					struct dsa_notifier_tag_proto_info *info)
> +{
> +	const struct dsa_device_ops *tag_ops = info->tag_ops;
> +
> +	if (!ds->ops->connect_tag_protocol)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->connect_tag_protocol(ds, tag_ops->proto);
> +}
> +
>  static int dsa_switch_mrp_add(struct dsa_switch *ds,
>  			      struct dsa_notifier_mrp_info *info)
>  {
> @@ -766,6 +777,9 @@ static int dsa_switch_event(struct notifier_block *nb,
>  	case DSA_NOTIFIER_TAG_PROTO:
>  		err = dsa_switch_change_tag_proto(ds, info);
>  		break;
> +	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
> +		err = dsa_switch_connect_tag_proto(ds, info);
> +		break;
>  	case DSA_NOTIFIER_MRP_ADD:
>  		err = dsa_switch_mrp_add(ds, info);
>  		break;
> diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
> index 6c293c2a3008..53362a0f0aab 100644
> --- a/net/dsa/tag_sja1105.c
> +++ b/net/dsa/tag_sja1105.c
> @@ -722,11 +722,59 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
>  	*proto = ((__be16 *)skb->data)[(VLAN_HLEN / 2) - 1];
>  }
>  
> +static void sja1105_disconnect(struct dsa_switch_tree *dst)
> +{
> +	struct dsa_port *dp;
> +
> +	dsa_tree_for_each_user_port(dp, dst) {
> +		if (dp->tagger_priv) {
> +			kfree(dp->tagger_priv);
> +			dp->tagger_priv = NULL;
> +		}
> +
> +		if (dp->ds->tagger_priv) {
> +			kfree(dp->ds->tagger_priv);
> +			dp->ds->tagger_priv = NULL;
> +		}
> +	}
> +}
> +
> +static int sja1105_connect(struct dsa_switch_tree *dst)
> +{
> +	struct sja1105_tagger_data *data;
> +	struct sja1105_port *sp;
> +	struct dsa_port *dp;
> +
> +	dsa_tree_for_each_user_port(dp, dst) {
> +		if (!dp->ds->tagger_priv) {
> +			data = kzalloc(sizeof(*data), GFP_KERNEL);
> +			if (!data)
> +				goto out;
> +
> +			dp->ds->tagger_priv = data;
> +		}
> +
> +		sp = kzalloc(sizeof(*sp), GFP_KERNEL);
> +		if (!sp)
> +			goto out;
> +
> +		dp->tagger_priv = sp;
> +	}
> +
> +	return 0;
> +
> +out:
> +	sja1105_disconnect(dst);
> +	return -ENOMEM;
> +}
> +
>  static const struct dsa_device_ops sja1105_netdev_ops = {
>  	.name = "sja1105",
>  	.proto = DSA_TAG_PROTO_SJA1105,
>  	.xmit = sja1105_xmit,
>  	.rcv = sja1105_rcv,
> +	.connect = sja1105_connect,
> +	.disconnect = sja1105_disconnect,
>  	.needed_headroom = VLAN_HLEN,
>  	.flow_dissect = sja1105_flow_dissect,
>  	.promisc_on_master = true,
> @@ -740,6 +788,8 @@ static const struct dsa_device_ops sja1110_netdev_ops = {
>  	.proto = DSA_TAG_PROTO_SJA1110,
>  	.xmit = sja1110_xmit,
>  	.rcv = sja1110_rcv,
> +	.connect = sja1105_connect,
> +	.disconnect = sja1105_disconnect,
>  	.flow_dissect = sja1110_flow_dissect,
>  	.needed_headroom = SJA1110_HEADER_LEN + VLAN_HLEN,
>  	.needed_tailroom = SJA1110_RX_TRAILER_LEN + SJA1110_MAX_PADDING_LEN,
> -- 
> 2.25.1

-- 
	Ansuel
