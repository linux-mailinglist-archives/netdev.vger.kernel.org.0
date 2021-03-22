Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75938344988
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCVPoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhCVPop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:44:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE19C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:44:44 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id b14so8761526lfv.8
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=/Ace+TqkoceKwGzTakCDUPQSg5WHLL/3NqzonMEWOW8=;
        b=Ylmm5UptUOeJe/83/kzLRIvpZQRyzUweCvhm/IjphAp1QwCHEZommi51jORuYiIZYA
         3IbIU5FVyS+k2G7EC8OYRBjocirU9/AqobHznZBTUD47jJ1YOTj6QZnD8QtcCnwyq9QS
         LQ5XRA8HPO0DZKX6k+H9hCMVTmoo1g8gEeTDNfNEtq0d4fh/TcH5IipHB1qWt/W4Sqwo
         PFmyTsQ5i2mKvV5HN7m8JK5zZ5tNXPOi/dkJbKyeOFJ4DgHGggnW1vTUYJJpr5g/HYSf
         T5UTCNHUmi6xGNwwxqeQkjpKeBl0t79MIRglgxD/UC9+cSfMgDqsfcOCRDgH9KlVq1A5
         CMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/Ace+TqkoceKwGzTakCDUPQSg5WHLL/3NqzonMEWOW8=;
        b=iThL7faLaKMKFN4K2WPwxhFk+AcKniVBIXajfT2zhbqTiPwEfWQ+ZJHklp0lCwaczY
         HTN7XvW/Uu3dTgRwVWO2wU9/l3KX4wBLVdaBb7HTGO448IiqI0DvKldrmtaPDvLdfiCZ
         fgW1uXhKyBY/Cq2OQGWrJOjlap2UaFjYGjqOp8k+Ge3oUNACtPy3pZkoHNPWt7/93Rtn
         YdGi5f3ac2RuZOMVT/xn5ThUXYyCbrMJ/HGHX04Yw4m4s3fh+n73s0v7W4iX0P7icorB
         onFLDcD+tJ1q2Hki49ZnBttM9HLbQAlKwqvtymVRBwdOMzD6BUfv/GmBYrMbeg1zNtzB
         7v0Q==
X-Gm-Message-State: AOAM531pNiFui3yh94f/8i1n8dUtu3pKbzXwXXb0vk301Kbu8IZ5iGNk
        FFQnNEpy4+c3krve81vbOaH9Ig==
X-Google-Smtp-Source: ABdhPJyfgG9pUdaudab2jTwcOXFJ5SOBeP6A/DCX28jm7W1o4K5yvDG9yD2j553DPBAoPq+ohmZhVA==
X-Received: by 2002:a05:6512:c2a:: with SMTP id z42mr20386lfu.630.1616427883066;
        Mon, 22 Mar 2021 08:44:43 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g3sm1141549lfb.94.2021.03.22.08.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 08:44:42 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 09/16] net: dsa: replay port and local fdb entries when joining the bridge
In-Reply-To: <20210318231829.3892920-10-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-10-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 16:44:41 +0100
Message-ID: <87wntzmbva.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> When a DSA port joins a LAG that already had an FDB entry pointing to it:
>
> ip link set bond0 master br0
> bridge fdb add dev bond0 00:01:02:03:04:05 master static
> ip link set swp0 master bond0
>
> the DSA port will have no idea that this FDB entry is there, because it
> missed the switchdev event emitted at its creation.
>
> Ido Schimmel pointed this out during a discussion about challenges with
> switchdev offloading of stacked interfaces between the physical port and
> the bridge, and recommended to just catch that condition and deny the
> CHANGEUPPER event:
> https://lore.kernel.org/netdev/20210210105949.GB287766@shredder.lan/
>
> But in fact, we might need to deal with the hard thing anyway, which is
> to replay all FDB addresses relevant to this port, because it isn't just
> static FDB entries, but also local addresses (ones that are not
> forwarded but terminated by the bridge). There, we can't just say 'oh
> yeah, there was an upper already so I'm not joining that'.
>
> So, similar to the logic for replaying MDB entries, add a function that
> must be called by individual switchdev drivers and replays local FDB
> entries as well as ones pointing towards a bridge port. This time, we
> use the atomic switchdev notifier block, since that's what FDB entries
> expect for some reason.
>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  9 +++++++
>  include/net/switchdev.h   |  1 +
>  net/bridge/br_fdb.c       | 52 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h        |  1 +
>  net/dsa/port.c            |  4 +++
>  net/dsa/slave.c           |  2 +-
>  6 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 4c25dafb013d..89596134e88f 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -147,6 +147,8 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
>  clock_t br_get_ageing_time(struct net_device *br_dev);
> +int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,
> @@ -175,6 +177,13 @@ static inline clock_t br_get_ageing_time(struct net_device *br_dev)
>  {
>  	return 0;
>  }
> +
> +static inline int br_fdb_replay(struct net_device *br_dev,
> +				struct net_device *dev,
> +				struct notifier_block *nb)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index b7fc7d0f54e2..7688ec572757 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -205,6 +205,7 @@ struct switchdev_notifier_info {
>  
>  struct switchdev_notifier_fdb_info {
>  	struct switchdev_notifier_info info; /* must be first */
> +	struct list_head list;
>  	const unsigned char *addr;
>  	u16 vid;
>  	u8 added_by_user:1,
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index b7490237f3fc..49125cc196ac 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -726,6 +726,58 @@ static inline size_t fdb_nlmsg_size(void)
>  		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
>  }
>  
> +static int br_fdb_replay_one(struct notifier_block *nb,
> +			     struct net_bridge_fdb_entry *fdb,
> +			     struct net_device *dev)
> +{
> +	struct switchdev_notifier_fdb_info item;
> +	int err;
> +
> +	item.addr = fdb->key.addr.addr;
> +	item.vid = fdb->key.vlan_id;
> +	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
> +	item.info.dev = dev;
> +
> +	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
> +	return notifier_to_errno(err);
> +}
> +
> +int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb)
> +{
> +	struct net_bridge_fdb_entry *fdb;
> +	struct net_bridge *br;
> +	int err = 0;
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return -EINVAL;
> +
> +	if (!netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(br_dev);
> +
> +	rcu_read_lock();
> +
> +	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
> +		struct net_device *dst_dev;
> +
> +		dst_dev = fdb->dst ? fdb->dst->dev : br->dev;
> +		if (dst_dev != br_dev && dst_dev != dev)
> +			continue;
> +

I do not know if it is a problem or not, more of an observation: This is
not guaranteed to be an exact replay of the events that the bridge port
(i.e. bond0 or whatever) has received since, in fdb_insert, we exit
early when adding local entries if that address is already in the
database.

Do we have to guard against this somehow? Or maybe we should consider
the current behavior a bug and make sure to always send the event in the
first place?

> +		err = br_fdb_replay_one(nb, fdb, dst_dev);
> +		if (err)
> +			break;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(br_fdb_replay);
> +
>  static void fdb_notify(struct net_bridge *br,
>  		       const struct net_bridge_fdb_entry *fdb, int type,
>  		       bool swdev_notify)
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index b14c43cb88bb..92282de54230 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -262,6 +262,7 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
>  
>  /* slave.c */
>  extern const struct dsa_device_ops notag_netdev_ops;
> +extern struct notifier_block dsa_slave_switchdev_notifier;
>  extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
>  
>  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 6670612f96c6..9850051071f2 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -205,6 +205,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = br_fdb_replay(br, brport_dev, &dsa_slave_switchdev_notifier);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	return 0;
>  }
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index b974d8f84a2e..c51e52418a62 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2392,7 +2392,7 @@ static struct notifier_block dsa_slave_nb __read_mostly = {
>  	.notifier_call  = dsa_slave_netdevice_event,
>  };
>  
> -static struct notifier_block dsa_slave_switchdev_notifier = {
> +struct notifier_block dsa_slave_switchdev_notifier = {
>  	.notifier_call = dsa_slave_switchdev_event,
>  };
>  
> -- 
> 2.25.1
