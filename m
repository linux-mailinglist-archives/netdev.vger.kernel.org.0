Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943F3262AC
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 13:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhBZMYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 07:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBZMYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 07:24:07 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DE3C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 04:23:26 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u4so10381448ljh.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 04:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=2SagZnFm7c6tCzk0Ilauo6MN7hStdeGSotExBPTGk80=;
        b=NOHjaDS9X3I+Vm7oxLRyjupxLtWPiFt8tDB91Gps0VPT1Gl2zbHRn7pHLl4YJmWSsx
         /2Lj0+JO5SZi/RjgoD0FZ6r2AxJiA6Wft9HNybebFa5o7xOvKpRQg9B4NMKJUs2Kg+cc
         goaOh7zSlGsyBVsvLLVyqCbavoxn5Pn7OU2LFwsKiOt72EXMkni/BPWAiabX0V+gMhkW
         NEBWB12osYc2vsA+BRBalGu1YgE4gHVdvlCMTgTXuR4KlGSDpPO4chuZKHIqN8inx8Mb
         qTax0dbQ3oSFo1yJSUMJ0BQpOL5zPSVtiZNo8d/KShVvaZaZCAyDRMTiMOFDrueLZrLf
         xyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2SagZnFm7c6tCzk0Ilauo6MN7hStdeGSotExBPTGk80=;
        b=DeiylaFguvxi3aD69FzHJt7LbrnlRy4K66izBWNPbExx6DNuIpUAbcj0zBXf42a5/O
         0XGmkv8jSFcjvkOvpeR/uCB2urfeyQ5lD7bEDsF102sX/trnTTrJRuE0VI5mgg08oYhY
         K8bhu+wvnXW4vRSi30MpECbPMJ/jYdGJRnhTL1OQbDC+2w27UbS49AD+Tpn8qVl1tfqY
         /d+BWvCY/tAVZcMXM4QgcHGu8FO2xzX1Aaql8l8jX5KRRNCRX4VzFVMcX2MSvos8v0KJ
         YXzyvXYPO/2zKRx/sQrQJGJi9rvKRiJ4+mDbUhhtG2w2zg9QEHrCey5ARC4dGskArkZu
         5+eg==
X-Gm-Message-State: AOAM530tylq//pk5/SJ39MJZ3d91TYEBansDQ+rQoLRHl+9iJPj8CSL9
        FVbxcNB/76VpaCtffpHVbuUEaA==
X-Google-Smtp-Source: ABdhPJxWzKwanDS5Rn5nXpSvJq9oTEs4tWE/K7aoQ4218ptE4siHokkiI2sHBN5RTe+vIVT/FSAkjA==
X-Received: by 2002:a05:651c:30f:: with SMTP id a15mr1599281ljp.487.1614342204970;
        Fri, 26 Feb 2021 04:23:24 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q16sm1381674lfa.261.2021.02.26.04.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:23:24 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 15/17] net: dsa: replay port and local fdb entries when joining the bridge
In-Reply-To: <20210224114350.2791260-16-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com> <20210224114350.2791260-16-olteanv@gmail.com>
Date:   Fri, 26 Feb 2021 13:23:23 +0100
Message-ID: <87mtvrqapw.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 13:43, Vladimir Oltean <olteanv@gmail.com> wrote:
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
>  include/linux/if_bridge.h | 10 ++++++++
>  include/net/switchdev.h   |  1 +
>  net/bridge/br_fdb.c       | 53 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/slave.c           |  7 +++++-
>  4 files changed, 70 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 2f0e5713bf39..2a90ac638b06 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -144,6 +144,8 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>  				    __u16 vid);
>  void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
> +int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,
> @@ -162,6 +164,14 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
>  {
>  	return false;
>  }
> +
> +static inline int br_fdb_replay(struct net_device *br_dev,
> +				struct net_device *dev,
> +				struct notifier_block *nb)
> +{
> +	return -EINVAL;
> +}
> +
>  #endif
>  
>  #endif
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index f1a5a9a3634d..5b63dfd444c6 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -206,6 +206,7 @@ struct switchdev_notifier_info {
>  
>  struct switchdev_notifier_fdb_info {
>  	struct switchdev_notifier_info info; /* must be first */
> +	struct list_head list;
>  	const unsigned char *addr;
>  	u16 vid;
>  	u8 added_by_user:1,
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 1d54ae0f58fb..9eb776503b02 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -726,6 +726,59 @@ static inline size_t fdb_nlmsg_size(void)
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
> +	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
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
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 10b4a0f72dcb..5fa5737e622c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2290,7 +2290,8 @@ bool dsa_slave_dev_check(const struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
>  
> -/* Circular reference */
> +/* Circular references */
> +static struct notifier_block dsa_slave_switchdev_notifier;
>  static struct notifier_block dsa_slave_switchdev_blocking_notifier;
>  
>  static int dsa_slave_changeupper(struct net_device *dev,
> @@ -2306,6 +2307,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
>  			err = dsa_port_bridge_join(dp, bridge_dev);
>  			if (!err) {
>  				dsa_bridge_mtu_normalization(dp);
> +				br_fdb_replay(bridge_dev, dev,
> +					      &dsa_slave_switchdev_notifier);
>  				br_mdb_replay(bridge_dev, dev,
>  					      &dsa_slave_switchdev_blocking_notifier);

If VLAN filtering is enabled, we would also have to replay that. Port
attributes also, right?

I like the pull model, because it saves the bridge from doing lots of
dumpster diving. However, should there be a single `bridge_replay` that
takes care of everything?

Rather than this kit-car approarch which outsources ordering etc to each
switchdev driver, you issue a single call saying: "bring me up to
speed". It seems right that that knowledge should reside in the bridge
since it was the one who sent the original events that are being
replayed.

>  			}
> @@ -2370,6 +2373,8 @@ dsa_slave_lag_changeupper(struct net_device *dev,
>  	}
>  
>  	if (netif_is_bridge_master(info->upper_dev) && !err) {
> +		br_fdb_replay(info->upper_dev, dev,
> +			      &dsa_slave_switchdev_notifier);
>  		br_mdb_replay(info->upper_dev, dev,
>  			      &dsa_slave_switchdev_blocking_notifier);
>  	}
> -- 
> 2.25.1
