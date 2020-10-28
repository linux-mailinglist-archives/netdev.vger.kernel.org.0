Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872FC29DA32
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390123AbgJ1XQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390120AbgJ1XQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:16:29 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FE3C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:16:27 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 184so942222lfd.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qjYXXZRe/xw5gtRoEe7DQnY4qPFqWgHo1R87mDhFCiY=;
        b=O8W08HR5tmVvNTuSQwvUdg7d070SMPgUZpoHwS8sHowEsveX/LivdbBJKbQW5fft46
         VuRAH0my5Ngb+CkVqz+MQHmjjox9AxuM9WRSaHsyRxhy/904DEUDVMc8YNKL8raBlI5Q
         tpigXcRJz47qNGOa+3+i1I8Ot89u2bJCYObewvcKTUuSRO4NN20W9bkWObCcDzg03IWd
         qjIIDV3F2RDuhdGwAx3CVlOMJFw7rein3eQxbsj7T9dSFREOiA5DD2LbBZEWxfz1DKBV
         r/K7TAnTusSEjWLVkTJN60OkTwSv1r8GXcgyO3t+Ie4r/44J37eeVvh+39lIwIlV2LbT
         97vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qjYXXZRe/xw5gtRoEe7DQnY4qPFqWgHo1R87mDhFCiY=;
        b=mz0VTiQ2N2JaenZz5Gnj6mO/OLdHsNM8kW8ZYzdrdYFYmG6xrpXBlVGibsD6ZcBi0e
         YHRHh5lxQO2j8m8eCbH+wnlWZuY05RuxqiGR7PpGo71yM7TTSDiwXecJVwDcO5OvaT7e
         Wr0gnhngc3V223d4o8di9GASORqf/iBZfnTBhHcYH0q/49LtJFdCw9STDopgBMasP+C8
         5GDL4dnX7aqwvcM7OAKr66qWthV2gf6KBwlYqHCfE1wEf+lDH+kxTDLsXalfxHlws4fd
         qGjqSJU610OM+bTaK+YF9xM1J6fbgfR3T/pFQfiJSDn8tBb97H5VysqCKxgfxUKF/ChJ
         HwxA==
X-Gm-Message-State: AOAM533OSntL59cBTpFnx186UicEvERlDLxVwsyB42GgUizXCwZjLGTF
        L55+O/BRSBW4xr8Gh3KFiFET/kCcyU8=
X-Google-Smtp-Source: ABdhPJyOClpmJYNtjqi6EWqHF/+NKY+C5SvFhJxjmbvNtWYBB/kQZbaikEXKN9VB6AHFDzjzWV1kLw==
X-Received: by 2002:a50:8426:: with SMTP id 35mr5154289edp.156.1603846736579;
        Tue, 27 Oct 2020 17:58:56 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h26sm1836056edr.71.2020.10.27.17.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 17:58:56 -0700 (PDT)
Date:   Wed, 28 Oct 2020 02:58:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] net: dsa: link aggregation support
Message-ID: <20201028005855.2xgvheizr5cz6s3a@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027105117.23052-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:51:15AM +0100, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and

When you use dsa_broadcast, it is reachable from _all_ switch trees, not
from "the" switch tree. This was added to support "islands" of
inter-compatible DSA switches separated by other DSA switches with
incompatible taggers. Not sure if it was a voluntary decision to use
that as opposed to plain dsa_port_notify. Not a problem either way.

> from each associated port.
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  68 +++++++++++++++++++++
>  net/dsa/dsa2.c     |   3 +
>  net/dsa/dsa_priv.h |  16 +++++
>  net/dsa/port.c     | 146 +++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/slave.c    |  53 ++++++++++++++--
>  net/dsa/switch.c   |  64 ++++++++++++++++++++
>  6 files changed, 346 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 35429a140dfa..58d73eafe891 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -145,6 +145,9 @@ struct dsa_switch_tree {
>  	/* List of switch ports */
>  	struct list_head ports;
>  
> +	/* List of configured LAGs */
> +	struct list_head lags;
> +
>  	/* List of DSA links composing the routing table */
>  	struct list_head rtable;
>  };
> @@ -178,6 +181,48 @@ struct dsa_mall_tc_entry {
>  	};
>  };
>  
> +struct dsa_lag {
> +	struct net_device *dev;
> +	int id;
> +
> +	struct list_head ports;
> +
> +	/* For multichip systems, we must ensure that each hash bucket
> +	 * is only enabled on a single egress port throughout the
> +	 * whole tree.

Or else?
I don't really understand this statement.

> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -193,6 +193,152 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
>  }
>  
> +static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
> +				   struct net_device *dev)
> +{
> +	struct dsa_lag *lag;
> +	unsigned long busy = 0;

Reverse Christmas notation please?

> +	int id;
> +
> +	list_for_each_entry(lag, &dst->lags, list) {
> +		set_bit(lag->id, &busy);
> +
> +		if (lag->dev == dev) {
> +			kref_get(&lag->refcount);
> +			return lag;
> +		}
> +	}
> +
> +	id = find_first_zero_bit(&busy, BITS_PER_LONG);
> +	if (id >= BITS_PER_LONG)
> +		return ERR_PTR(-ENOSPC);
> +
> +	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
> +	if (!lag)
> +		return ERR_PTR(-ENOMEM);
> +
> +	kref_init(&lag->refcount);
> +	lag->id = id;
> +	lag->dev = dev;
> +	INIT_LIST_HEAD(&lag->ports);
> +	INIT_LIST_HEAD(&lag->tx_ports);
> +
> +	INIT_LIST_HEAD(&lag->list);
> +	list_add_tail_rcu(&lag->list, &dst->lags);
> +	return lag;
> +}
> +
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 3bc5ca40c9fb..e5e4f3d096c0 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -334,7 +334,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  	struct switchdev_obj_port_vlan vlan;
>  	int vid, err;
>  
> -	if (obj->orig_dev != dev)
> +	if (!(obj->orig_dev == dev ||
> +	      (dp->lag && obj->orig_dev == dp->lag->dev)))

A small comment here maybe?

>  		return -EOPNOTSUPP;
>  
>  	if (dsa_port_skip_vlan_configuration(dp))
> @@ -421,7 +422,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
>  	struct switchdev_obj_port_vlan *vlan;
>  	int vid, err;
>  
> -	if (obj->orig_dev != dev)
> +	if (!(obj->orig_dev == dev ||
> +	      (dp->lag && obj->orig_dev == dp->lag->dev)))
>  		return -EOPNOTSUPP;
>  
>  	if (dsa_port_skip_vlan_configuration(dp))
