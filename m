Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA4D311577
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhBEWcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhBEOOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:14:46 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCBCC061A2E;
        Fri,  5 Feb 2021 07:51:51 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w2so12573035ejk.13;
        Fri, 05 Feb 2021 07:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UBY9WwfzHzbKTwG1Konv0f4mD9hye80ZZHT6cIDn8Bs=;
        b=Z5iMXrD+Uhz30q3w0zBS6EWg0wLdRGCwN+ALMNiYa6z63DGFEnzy9Cz3wRpmaPPYvo
         5uPd9JRGHOH3GsZB4T+cVG6e96o6S7S3N6UhbRpadsZ0YjXr718VE1yNFO+84/iSotji
         3B6FynosdX5jdwGhxIBgqNzXy54wl3Kps1mpszXt8yWymSw6fSYXtYwek3pRvAToA3nV
         dyosrMNF9YtKQOU+Rhi2RTcsNkrEGBByyBtX4wm1kawntgdBQzf4CoV0m5KjN6+tm2qk
         Wh2zaMIMmbFNXAabrbCK74xNAzqrqnJ0xhF155s35IJZnFYwkYEtkV8RuW4i3/skb1vW
         fzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UBY9WwfzHzbKTwG1Konv0f4mD9hye80ZZHT6cIDn8Bs=;
        b=QOvHA3DlZdv1kC5ltJ0WPNrLiqIUiSBcFu53YeZRQH/QTKv6Tqvk8KHOCsPidaOuTb
         RoMcJI8mYw+b0mLAfkiqywhDYGHFtTIdj2CA4a4dtHbi6S56mR30hbiD9BHvQ64es2e5
         y4O/7GMac2x6tZuUw2ePciM4a1qkyWO+GO57uRE8YfIQMYyLBBysAG8Z7AaVXOQtIiiC
         WnoLQCarRzDRNLKQXT2TEexpHYIsaRV8wRajdcg+wNvEuWaUOKkRrz167O62hvIo3Yld
         O7sx7nvkVP9b8pMU1urqUuN37KLtdFj24q8nkrDEEmsDrbYRjyndVQ5NRE+tQ5yBEzFG
         DENg==
X-Gm-Message-State: AOAM531TF3tAmlPNqD5moplz8KpwCC3TYaubtfQuxZbHZzanALsrIINU
        00AxbIAvjELBCY52x0v0LmpY9QQKFAs=
X-Google-Smtp-Source: ABdhPJyxOgJFTKoL9b340GeKXDeNdMLpJ4Ln6XsflmsHAbAyKTc10sHXfnEWnCHHGvRHH50Wem3FRg==
X-Received: by 2002:aa7:d98f:: with SMTP id u15mr4021799eds.267.1612538683087;
        Fri, 05 Feb 2021 07:24:43 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s6sm3543284ejr.124.2021.02.05.07.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 07:24:41 -0800 (PST)
Date:   Fri, 5 Feb 2021 17:24:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Andrii Savka <andrii.savka@plvision.eu>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <20210205152440.v2ce6x5fbmycgn74@skbuf>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203165458.28717-6-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 06:54:56PM +0200, Vadym Kochan wrote:
> +static struct prestera_lag *prestera_lag_by_dev(struct prestera_switch *sw,
> +						struct net_device *dev)
> +{
> +	struct prestera_lag *lag;
> +	u16 id;
> +
> +	for (id = 0; id < sw->lag_max; id++) {
> +		lag = &sw->lags[id];
> +		if (lag->dev == dev)
> +			return lag;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct prestera_lag *prestera_lag_create(struct prestera_switch *sw,
> +						struct net_device *lag_dev)
> +{
> +	struct prestera_lag *lag;

You should initialize with NULL.

> +	u16 id;
> +
> +	for (id = 0; id < sw->lag_max; id++) {
> +		lag = &sw->lags[id];
> +		if (!lag->dev)
> +			break;
> +	}
> +	if (lag) {
> +		INIT_LIST_HEAD(&lag->members);
> +		lag->dev = lag_dev;
> +	}
> +
> +	return lag;
> +}
> +
> +static void prestera_lag_destroy(struct prestera_switch *sw,
> +				 struct prestera_lag *lag)
> +{
> +	WARN_ON(!list_empty(&lag->members));
> +	lag->member_count = 0;
> +	lag->dev = NULL;
> +}
> +
> +static int prestera_lag_port_add(struct prestera_port *port,
> +				 struct net_device *lag_dev)
> +{
> +	struct prestera_switch *sw = port->sw;
> +	struct prestera_lag *lag;
> +	int err;
> +
> +	lag = prestera_lag_by_dev(sw, lag_dev);
> +	if (!lag) {
> +		lag = prestera_lag_create(sw, lag_dev);
> +		if (!lag)
> +			return -ENOMEM;

I think ENOMEM is reserved for dynamic memory allocation. I think
-ENOSPC may be a better error code (here and everywhere else).
Maybe you would also like to propagate the netlink extack from the
changeupper event and say what went wrong?

> +	}
> +
> +	if (lag->member_count >= sw->lag_member_max)
> +		return -ENOMEM;
> +
> +	err = prestera_hw_lag_member_add(port, lag->lag_id);
> +	if (err) {
> +		if (!lag->member_count)
> +			prestera_lag_destroy(sw, lag);
> +		return err;
> +	}
> +
> +	list_add(&port->lag_member, &lag->members);
> +	lag->member_count++;
> +	port->lag = lag;
> +
> +	return 0;
> +}
> +
> +static int prestera_lag_port_del(struct prestera_port *port)
> +{
> +	struct prestera_switch *sw = port->sw;
> +	struct prestera_lag *lag = port->lag;
> +	int err;
> +
> +	if (!lag || !lag->member_count)
> +		return -EINVAL;
> +
> +	err = prestera_hw_lag_member_del(port, lag->lag_id);
> +	if (err)
> +		return err;
> +
> +	list_del(&port->lag_member);
> +	lag->member_count--;
> +	port->lag = NULL;
> +
> +	if (netif_is_bridge_port(lag->dev)) {
> +		struct netdev_notifier_changeupper_info br_info;
> +
> +		br_info.upper_dev = netdev_master_upper_dev_get(lag->dev);
> +		br_info.linking = false;
> +
> +		prestera_bridge_port_event(lag->dev, port->dev,
> +					   NETDEV_CHANGEUPPER, &br_info);
> +	}

I think it might be more intuitive if you just call
prestera_port_bridge_leave than simulate a notifier call.

> +
> +	if (!lag->member_count)
> +		prestera_lag_destroy(sw, lag);
> +
> +	return 0;
> +}
> +
> +bool prestera_port_is_lag_member(const struct prestera_port *port)
> +{
> +	return !!port->lag;
> +}
> +
> +u16 prestera_port_lag_id(const struct prestera_port *port)
> +{
> +	return port->lag->lag_id;
> +}
> +
> +static int prestera_lag_init(struct prestera_switch *sw)
> +{
> +	u16 id;
> +
> +	sw->lags = kcalloc(sw->lag_max, sizeof(*sw->lags), GFP_KERNEL);
> +	if (!sw->lags)
> +		return -ENOMEM;
> +
> +	for (id = 0; id < sw->lag_max; id++)
> +		sw->lags[id].lag_id = id;
> +
> +	return 0;
> +}
> +
> +static void prestera_lag_fini(struct prestera_switch *sw)
> +{
> +	u8 idx;
> +
> +	for (idx = 0; idx < sw->lag_max; idx++)
> +		WARN_ON(sw->lags[idx].member_count);
> +
> +	kfree(sw->lags);
> +}
> +
>  bool prestera_netdev_check(const struct net_device *dev)
>  {
>  	return dev->netdev_ops == &prestera_netdev_ops;
> @@ -507,19 +654,54 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
>  	return port;
>  }
>  
> -static int prestera_netdev_port_event(struct net_device *dev,
> +static int prestera_netdev_port_lower_event(struct net_device *dev,
> +					    unsigned long event, void *ptr)
> +{
> +	struct netdev_notifier_changelowerstate_info *info = ptr;
> +	struct netdev_lag_lower_state_info *lower_state_info;
> +	struct prestera_port *port = netdev_priv(dev);
> +	bool enabled;
> +
> +	if (!netif_is_lag_port(dev))
> +		return 0;
> +	if (!prestera_port_is_lag_member(port))
> +		return 0;
> +
> +	lower_state_info = info->lower_state_info;
> +	enabled = lower_state_info->tx_enabled;

You also need to check for info->link_up, otherwise the ports won't get
rebalanced for bonding interfaces with "mode balance-xor miimon 1" and such.
There is also a comment in net/dsa/port.c with more details.

> +
> +	return prestera_hw_lag_member_enable(port, port->lag->lag_id, enabled);
> +}
> +
> +static bool prestera_lag_master_check(struct net_device *lag_dev,
> +				      struct netdev_lag_upper_info *info,
> +				      struct netlink_ext_ack *ext_ack)
> +{
> +	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
> +		NL_SET_ERR_MSG_MOD(ext_ack, "Unsupported LAG Tx type");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int prestera_netdev_port_event(struct net_device *lower,
> +				      struct net_device *dev,
>  				      unsigned long event, void *ptr)
>  {
>  	struct netdev_notifier_changeupper_info *info = ptr;
> +	struct prestera_port *port = netdev_priv(dev);
>  	struct netlink_ext_ack *extack;
>  	struct net_device *upper;
> +	int err;
>  
>  	extack = netdev_notifier_info_to_extack(&info->info);
>  	upper = info->upper_dev;
>  
>  	switch (event) {
>  	case NETDEV_PRECHANGEUPPER:
> -		if (!netif_is_bridge_master(upper)) {
> +		if (!netif_is_bridge_master(upper) &&
> +		    !netif_is_lag_master(upper)) {

No 8021q uppers allowed on Marvell Prestera switch ports?

>  			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
>  			return -EINVAL;
>  		}
> @@ -531,12 +713,60 @@ static int prestera_netdev_port_event(struct net_device *dev,
>  			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
>  			return -EINVAL;
>  		}
> +
> +		if (netif_is_lag_master(upper) &&
> +		    !prestera_lag_master_check(upper, info->upper_info, extack))
> +			return -EINVAL;

-EOPNOTSUPP maybe?
In DSA we had a discussion and convened to do software fallback for
bonding modes that can't be offloaded, and just print an extack and
return 0. What is your take on that?

> +		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Master device is a LAG master and port has a VLAN");
> +			return -EINVAL;
> +		}
> +		if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
> +		    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Can not put a VLAN on a LAG port");
> +			return -EINVAL;
> +		}
>  		break;
>  
>  	case NETDEV_CHANGEUPPER:
>  		if (netif_is_bridge_master(upper))
> -			return prestera_bridge_port_event(dev, event, ptr);
> +			return prestera_bridge_port_event(lower, dev, event,
> +							  ptr);
> +
> +		if (netif_is_lag_master(upper)) {
> +			if (info->linking) {
> +				err = prestera_lag_port_add(port, upper);
> +				if (err)
> +					return err;
> +			} else {
> +				prestera_lag_port_del(port);
> +			}
> +		}
>  		break;
> +
> +	case NETDEV_CHANGELOWERSTATE:
> +		return prestera_netdev_port_lower_event(dev, event, ptr);
> +	}
> +
> +	return 0;
> +}
> +
> +static int prestera_netdevice_lag_event(struct net_device *lag_dev,
> +					unsigned long event, void *ptr)
> +{
> +	struct net_device *dev;
> +	struct list_head *iter;
> +	int err;
> +
> +	netdev_for_each_lower_dev(lag_dev, dev, iter) {
> +		if (prestera_netdev_check(dev)) {
> +			err = prestera_netdev_port_event(lag_dev, dev, event,
> +							 ptr);
> +			if (err)
> +				return err;
> +		}
>  	}
>  
>  	return 0;
> @@ -549,7 +779,9 @@ static int prestera_netdev_event_handler(struct notifier_block *nb,
>  	int err = 0;
>  
>  	if (prestera_netdev_check(dev))
> -		err = prestera_netdev_port_event(dev, event, ptr);
> +		err = prestera_netdev_port_event(dev, dev, event, ptr);
> +	else if (netif_is_lag_master(dev))
> +		err = prestera_netdevice_lag_event(dev, event, ptr);
>  
>  	return notifier_from_errno(err);
>  }
> @@ -603,6 +835,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  	if (err)
>  		goto err_dl_register;
>  
> +	err = prestera_lag_init(sw);
> +	if (err)
> +		goto err_lag_init;
> +
>  	err = prestera_create_ports(sw);
>  	if (err)
>  		goto err_ports_create;
> @@ -610,6 +846,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  	return 0;
>  
>  err_ports_create:
> +	prestera_lag_fini(sw);
> +err_lag_init:
>  	prestera_devlink_unregister(sw);
>  err_dl_register:
>  	prestera_event_handlers_unregister(sw);
> @@ -627,6 +865,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  static void prestera_switch_fini(struct prestera_switch *sw)
>  {
>  	prestera_destroy_ports(sw);
> +	prestera_lag_fini(sw);
>  	prestera_devlink_unregister(sw);
>  	prestera_event_handlers_unregister(sw);
>  	prestera_rxtx_switch_fini(sw);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> index 7736d5f498c9..3750c66a550b 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> @@ -180,6 +180,45 @@ prestera_port_vlan_create(struct prestera_port *port, u16 vid, bool untagged)
>  	return ERR_PTR(err);
>  }
>  
> +static int prestera_fdb_add(struct prestera_port *port,
> +			    const unsigned char *mac, u16 vid, bool dynamic)
> +{
> +	if (prestera_port_is_lag_member(port))
> +		return prestera_hw_lag_fdb_add(port->sw, prestera_port_lag_id(port),
> +					      mac, vid, dynamic);
> +	else
> +		return prestera_hw_fdb_add(port, mac, vid, dynamic);
> +}

I think checkpatch tells you that "else" after "return" is not really
necessary.

> +
> +static int prestera_fdb_del(struct prestera_port *port,
> +			    const unsigned char *mac, u16 vid)
> +{
> +	if (prestera_port_is_lag_member(port))
> +		return prestera_hw_lag_fdb_del(port->sw, prestera_port_lag_id(port),
> +					      mac, vid);
> +	else
> +		return prestera_hw_fdb_del(port, mac, vid);
> +}
> +
> +static int prestera_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
> +					u32 mode)
> +{
> +	if (prestera_port_is_lag_member(port))
> +		return prestera_hw_fdb_flush_lag_vlan(port->sw, prestera_port_lag_id(port),
> +						      vid, mode);
> +	else
> +		return prestera_hw_fdb_flush_port_vlan(port, vid, mode);
> +}
> +
> +static int prestera_fdb_flush_port(struct prestera_port *port, u32 mode)
> +{
> +	if (prestera_port_is_lag_member(port))
> +		return prestera_hw_fdb_flush_lag(port->sw, prestera_port_lag_id(port),
> +						 mode);
> +	else
> +		return prestera_hw_fdb_flush_port(port, mode);
> +}
> +
>  static void
>  prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
>  {
> @@ -199,11 +238,11 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
>  	last_port = port_count == 1;
>  
>  	if (last_vlan)
> -		prestera_hw_fdb_flush_port(port, fdb_flush_mode);
> +		prestera_fdb_flush_port(port, fdb_flush_mode);
>  	else if (last_port)
>  		prestera_hw_fdb_flush_vlan(port->sw, vid, fdb_flush_mode);
>  	else
> -		prestera_hw_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
> +		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
>  
>  	list_del(&port_vlan->br_vlan_head);
>  	prestera_bridge_vlan_put(br_vlan);
> @@ -394,9 +433,9 @@ prestera_bridge_port_add(struct prestera_bridge *bridge, struct net_device *dev)
>  }
>  
>  static int
> -prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
> +prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port,
> +			     struct prestera_port *port)
>  {
> -	struct prestera_port *port = netdev_priv(br_port->dev);
>  	struct prestera_bridge *bridge = br_port->bridge;
>  	int err;
>  
> @@ -423,6 +462,7 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
>  }
>  
>  static int prestera_port_bridge_join(struct prestera_port *port,
> +				     struct net_device *lower,
>  				     struct net_device *upper)
>  {
>  	struct prestera_switchdev *swdev = port->sw->swdev;
> @@ -437,7 +477,7 @@ static int prestera_port_bridge_join(struct prestera_port *port,
>  			return PTR_ERR(bridge);
>  	}
>  
> -	br_port = prestera_bridge_port_add(bridge, port->dev);
> +	br_port = prestera_bridge_port_add(bridge, lower);
>  	if (IS_ERR(br_port)) {
>  		err = PTR_ERR(br_port);
>  		goto err_brport_create;
> @@ -446,7 +486,7 @@ static int prestera_port_bridge_join(struct prestera_port *port,
>  	if (bridge->vlan_enabled)
>  		return 0;
>  
> -	err = prestera_bridge_1d_port_join(br_port);
> +	err = prestera_bridge_1d_port_join(br_port, port);
>  	if (err)
>  		goto err_port_join;
>  
> @@ -459,19 +499,17 @@ static int prestera_port_bridge_join(struct prestera_port *port,
>  	return err;
>  }
>  
> -static void prestera_bridge_1q_port_leave(struct prestera_bridge_port *br_port)
> +static void prestera_bridge_1q_port_leave(struct prestera_bridge_port *br_port,
> +					  struct prestera_port *port)
>  {
> -	struct prestera_port *port = netdev_priv(br_port->dev);
> -
> -	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
> +	prestera_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
>  	prestera_port_pvid_set(port, PRESTERA_DEFAULT_VID);
>  }
>  
> -static void prestera_bridge_1d_port_leave(struct prestera_bridge_port *br_port)
> +static void prestera_bridge_1d_port_leave(struct prestera_bridge_port *br_port,
> +					  struct prestera_port *port)
>  {
> -	struct prestera_port *port = netdev_priv(br_port->dev);
> -
> -	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
> +	prestera_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
>  	prestera_hw_bridge_port_delete(port, br_port->bridge->bridge_id);
>  }
>  
> @@ -506,6 +544,7 @@ static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
>  }
>  
>  static void prestera_port_bridge_leave(struct prestera_port *port,
> +				       struct net_device *lower,
>  				       struct net_device *upper)
>  {
>  	struct prestera_switchdev *swdev = port->sw->swdev;
> @@ -516,16 +555,16 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
>  	if (!bridge)
>  		return;
>  
> -	br_port = __prestera_bridge_port_by_dev(bridge, port->dev);
> +	br_port = __prestera_bridge_port_by_dev(bridge, lower);
>  	if (!br_port)
>  		return;
>  
>  	bridge = br_port->bridge;
>  
>  	if (bridge->vlan_enabled)
> -		prestera_bridge_1q_port_leave(br_port);
> +		prestera_bridge_1q_port_leave(br_port, port);
>  	else
> -		prestera_bridge_1d_port_leave(br_port);
> +		prestera_bridge_1d_port_leave(br_port, port);
>  
>  	prestera_hw_port_learning_set(port, false);
>  	prestera_hw_port_flood_set(port, false);
> @@ -533,8 +572,8 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
>  	prestera_bridge_port_put(br_port);
>  }
>  
> -int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
> -			       void *ptr)
> +int prestera_bridge_port_event(struct net_device *lower, struct net_device *dev,
> +			       unsigned long event, void *ptr)

It's odd that you have a net_device lower and a net_device dev.
You're only using "dev" to retrieve the struct prestera_port, can't you
just pass that as parameter? It will also help avoid possible mistakes
in the future between lower (which can be a LAG or a port) and which is
associated with a struct prestera_bridge_port, and dev which is only a
port, and is associated with struct prestera_port.
