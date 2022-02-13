Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964024B38CD
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 02:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiBMBJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 20:09:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBMBJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 20:09:44 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9570B60056
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 17:09:38 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id o9so12633339ljq.4
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 17:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=IOTBOr7HqcRkFBJvTH3AYISElS5/+E4cQP2QuDuBvDU=;
        b=s8IbHT6mLNnVyTPKPmNdLVD8W6ftLtpQ2gsjQESj+8ZrknjWPFaxjXJZgNztbNCTsr
         Jps3HAUoochsDL62+FO8/9MRzyx4r6FYekZE19AmyW8eOlMpcYgOajJM1VEvgfAkSV7C
         n4bMhEZmKCE6gOoextu6D9c4LaXAhOkpYB3s3hADWNX8OjIBjke7WG5VYTYOz2qAbu91
         cQWQSR9BBcVOEPqSyw6aYMnZ+3guPsAwkVyOyXbb6236aHIv8hBVYc/CsOVk1FWhwJox
         IHCWAvYsfb4A71HZ+xdZuq3ha9eUvaQdDFDZ4NywOpNTWjx335ydYW8NXvEfQA9aLJPV
         uo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IOTBOr7HqcRkFBJvTH3AYISElS5/+E4cQP2QuDuBvDU=;
        b=WmOXSHdTEi+ThCaKfP3yodZ/0QELvTmP/PL1XElnSJckGZFgNX30pDFtJSKkqIJ7Js
         Nffgz3Fswrm9Trgm/xdHSkJraNGQYrovuYGOrPHpGjKt0fHCUSScRitqVzmfL8h3jh6N
         h7SVK/Utm/EntOSw93jQr5gwtQQU9W8qkGge36VgglEGTLAECgaVViRe4wJhgFPoj5X0
         OqTclubXZXYOHB4F79wJz9uA6WkKYUpyCB8ryYuUZk5cSQX5ETnE+3zlt2UALQ3DPcJb
         IrEqHQCPfHDAkN3y8aKA1VN1UEsxOn92IDIeejTX2KCSD9qGWONa747f/0zg1SblGDF7
         nDEw==
X-Gm-Message-State: AOAM530HDL7kGlwELTzORevjlckxWVmI338lPDDIfKFBC5Z2Bf0SoESV
        AWgEJD08cX8rSMLfuLGssO93Xg==
X-Google-Smtp-Source: ABdhPJzo70Wow9QYuc4VeRCBXxIWJ15wX3rgNWhhL9b41k8FnHP/+u/XpHJlNP2cXDxdLCXufQ5dmg==
X-Received: by 2002:a2e:b88d:: with SMTP id r13mr4937864ljp.452.1644714576685;
        Sat, 12 Feb 2022 17:09:36 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id i29sm3619138lfv.131.2022.02.12.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 17:09:36 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: Re: [RFC PATCH net-next 5/5] net: dsa: add explicit support for
 host bridge VLANs
In-Reply-To: <20220209213044.2353153-6-vladimir.oltean@nxp.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <20220209213044.2353153-6-vladimir.oltean@nxp.com>
Date:   Sun, 13 Feb 2022 02:09:35 +0100
Message-ID: <87wnhza7xs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vladimir,

Thanks for working on this!

On Wed, Feb 09, 2022 at 23:30, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Currently, DSA programs VLANs on shared (DSA and CPU) ports each time it
> does so on user ports. This is good for basic functionality but has
> several limitations:
>
> - the VLAN group which must reach the CPU may be radically different
>   from the VLAN group that must be autonomously forwarded by the switch.
>   In other words, the admin may want to isolate noisy stations and avoid
>   traffic from them going to the control processor of the switch, where
>   it would just waste useless cycles. The bridge already supports
>   independent control of VLAN groups on bridge ports and on the bridge
>   itself, and when VLAN-aware, it will drop packets in software anyway
>   if their VID isn't added as a 'self' entry towards the bridge device.
>
> - Replaying host FDB entries may depend, for some drivers like mv88e6xxx,
>   on replaying the host VLANs as well. The 2 VLAN groups are
>   approximately the same in most regular cases, but there are corner
>   cases when timing matters, and DSA's approximation of replicating
>   VLANs on shared ports simply does not work.
>
> - It is possible to artificially fill the VLAN table of a switch, by
>   walking through the entire VLAN space, adding and deleting them.
>   For each VLAN added on a user port, DSA will add it on shared ports
>   too, but for each VLAN deletion on a user port, it will remain
>   installed on shared ports, since DSA has no good indication of whether
>   the VLAN is still in use or not. If the hardware has a limited number
>   of VLAN table entries, this may uselessly consume that space.
>
> Now that the bridge driver emits well-balanced SWITCHDEV_OBJ_ID_PORT_VLAN
> addition and removal events, DSA has a simple and straightforward task
> of separating the bridge port VLANs (these have an orig_dev which is a
> DSA slave interface, or a LAG interface) from the host VLANs (these have
> an orig_dev which is a bridge interface), and to keep a simple reference
> count of each VID on each shared port.
>
> Forwarding VLANs must be installed on the bridge ports and on all DSA
> ports interconnecting them. We don't have a good view of the exact
> topology, so we simply install forwarding VLANs on all DSA ports, which
> is what has been done until now.
>
> Host VLANs must be installed primarily on the dedicated CPU port of each
> bridge port. More subtly, they must also be installed on upstream-facing
> and downstream-facing DSA ports that are connecting the bridge ports and
> the CPU. This ensures that the mv88e6xxx's problem (VID of host FDB
> entry may be absent from VTU) is still addressed even if that switch is
> in a cross-chip setup, and it has no local CPU port.
>
> Therefore:
> - user ports contain only bridge port (forwarding) VLANs, and no
>   refcounting is necessary
> - DSA ports contain both forwarding and host VLANs. Refcounting is
>   necessary among these 2 types.
> - CPU ports contain only host VLANs. Refcounting is also necessary.

This is pretty much true, though this does not take foreign interfaces
into account. It would be great if the condifion could be refined to:

    The CPU port should be a member of all VLANs where either (a) the
    host is a member, or (b) at least one foreign interface is a member.

I.e. in a situation like this:

   br0
   / \
swp0 tap0

If br0 is not a member of VLAN X, but tap0 is, then the CPU port still
needs to be a member of X. Otherwise the (software) bridge will never
get a chance to software forward it over the tunnel.

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h  |  12 +++
>  net/dsa/dsa2.c     |   2 +
>  net/dsa/dsa_priv.h |   7 ++
>  net/dsa/port.c     |  42 +++++++++++
>  net/dsa/slave.c    |  97 ++++++++++++++----------
>  net/dsa/switch.c   | 179 +++++++++++++++++++++++++++++++++++++++++++--
>  6 files changed, 295 insertions(+), 44 deletions(-)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index fd1f62a6e0a8..313295c1b0c6 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -312,6 +312,12 @@ struct dsa_port {
>  	struct mutex		addr_lists_lock;
>  	struct list_head	fdbs;
>  	struct list_head	mdbs;
> +
> +	/* List of host VLANs that CPU and upstream-facing DSA ports
> +	 * are members of.
> +	 */
> +	struct mutex		vlans_lock;
> +	struct list_head	vlans;
>  };
>  
>  /* TODO: ideally DSA ports would have a single dp->link_dp member,
> @@ -332,6 +338,12 @@ struct dsa_mac_addr {
>  	struct list_head list;
>  };
>  
> +struct dsa_vlan {
> +	u16 vid;
> +	refcount_t refcount;
> +	struct list_head list;
> +};
> +
>  struct dsa_switch {
>  	struct device *dev;
>  
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index e498c927c3d0..1df8c2356463 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -453,8 +453,10 @@ static int dsa_port_setup(struct dsa_port *dp)
>  		return 0;
>  
>  	mutex_init(&dp->addr_lists_lock);
> +	mutex_init(&dp->vlans_lock);
>  	INIT_LIST_HEAD(&dp->fdbs);
>  	INIT_LIST_HEAD(&dp->mdbs);
> +	INIT_LIST_HEAD(&dp->vlans);
>  
>  	if (ds->ops->port_setup) {
>  		err = ds->ops->port_setup(ds, dp->index);
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 2bbfa9efe9f8..6a3878157b0a 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -34,6 +34,8 @@ enum {
>  	DSA_NOTIFIER_HOST_MDB_DEL,
>  	DSA_NOTIFIER_VLAN_ADD,
>  	DSA_NOTIFIER_VLAN_DEL,
> +	DSA_NOTIFIER_HOST_VLAN_ADD,
> +	DSA_NOTIFIER_HOST_VLAN_DEL,
>  	DSA_NOTIFIER_MTU,
>  	DSA_NOTIFIER_TAG_PROTO,
>  	DSA_NOTIFIER_TAG_PROTO_CONNECT,
> @@ -234,6 +236,11 @@ int dsa_port_vlan_add(struct dsa_port *dp,
>  		      struct netlink_ext_ack *extack);
>  int dsa_port_vlan_del(struct dsa_port *dp,
>  		      const struct switchdev_obj_port_vlan *vlan);
> +int dsa_port_host_vlan_add(struct dsa_port *dp,
> +			   const struct switchdev_obj_port_vlan *vlan,
> +			   struct netlink_ext_ack *extack);
> +int dsa_port_host_vlan_del(struct dsa_port *dp,
> +			   const struct switchdev_obj_port_vlan *vlan);
>  int dsa_port_mrp_add(const struct dsa_port *dp,
>  		     const struct switchdev_obj_mrp *mrp);
>  int dsa_port_mrp_del(const struct dsa_port *dp,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index bd78192e0e47..cca5cf686f74 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -904,6 +904,48 @@ int dsa_port_vlan_del(struct dsa_port *dp,
>  	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
>  }
>  
> +int dsa_port_host_vlan_add(struct dsa_port *dp,
> +			   const struct switchdev_obj_port_vlan *vlan,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct dsa_notifier_vlan_info info = {
> +		.sw_index = dp->ds->index,
> +		.port = dp->index,
> +		.vlan = vlan,
> +		.extack = extack,
> +	};
> +	struct dsa_port *cpu_dp = dp->cpu_dp;
> +	int err;
> +
> +	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
> +	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
> +
> +	return err;
> +}
> +
> +int dsa_port_host_vlan_del(struct dsa_port *dp,
> +			   const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct dsa_notifier_vlan_info info = {
> +		.sw_index = dp->ds->index,
> +		.port = dp->index,
> +		.vlan = vlan,
> +	};
> +	struct dsa_port *cpu_dp = dp->cpu_dp;
> +	int err;
> +
> +	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
> +	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
> +
> +	return err;
> +}
> +
>  int dsa_port_mrp_add(const struct dsa_port *dp,
>  		     const struct switchdev_obj_mrp *mrp)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 2b5b0f294233..769dabe7db91 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -348,9 +348,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  			      const struct switchdev_obj *obj,
>  			      struct netlink_ext_ack *extack)
>  {
> -	struct net_device *master = dsa_slave_to_master(dev);
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct switchdev_obj_port_vlan vlan;
> +	struct switchdev_obj_port_vlan *vlan;
>  	int err;
>  
>  	if (dsa_port_skip_vlan_configuration(dp)) {
> @@ -358,14 +357,14 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  		return 0;
>  	}
>  
> -	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
> +	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
>  
>  	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
>  	 * the same VID.
>  	 */
>  	if (br_vlan_enabled(dsa_port_bridge_dev_get(dp))) {
>  		rcu_read_lock();
> -		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
> +		err = dsa_slave_vlan_check_for_8021q_uppers(dev, vlan);
>  		rcu_read_unlock();
>  		if (err) {
>  			NL_SET_ERR_MSG_MOD(extack,
> @@ -374,21 +373,33 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  		}
>  	}
>  
> -	err = dsa_port_vlan_add(dp, &vlan, extack);
> -	if (err)
> -		return err;
> +	return dsa_port_vlan_add(dp, vlan, extack);
> +}
> +
> +static int dsa_slave_host_vlan_add(struct net_device *dev,
> +				   const struct switchdev_obj *obj,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct switchdev_obj_port_vlan vlan;
>  
> -	/* We need the dedicated CPU port to be a member of the VLAN as well.
> -	 * Even though drivers often handle CPU membership in special ways,
> +	if (dsa_port_skip_vlan_configuration(dp)) {
> +		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
> +		return 0;
> +	}
> +
> +	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
> +
> +	/* Even though drivers often handle CPU membership in special ways,
>  	 * it doesn't make sense to program a PVID, so clear this flag.
>  	 */
>  	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
>  
> -	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
> -	if (err)
> -		return err;
> +	/* Skip case 3 VLANs from __vlan_add() from the bridge driver */
> +	if (!(vlan.flags & BRIDGE_VLAN_INFO_BRENTRY))
> +		return 0;
>  
> -	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
> +	return dsa_port_host_vlan_add(dp, &vlan, extack);
>  }
>  
>  static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
> @@ -415,10 +426,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
>  		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> -		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
> -			return -EOPNOTSUPP;
> +		if (netif_is_bridge_master(obj->orig_dev)) {
> +			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
> +				return -EOPNOTSUPP;
> +
> +			err = dsa_slave_host_vlan_add(dev, obj, extack);
> +		} else {
> +			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
> +				return -EOPNOTSUPP;
>  
> -		err = dsa_slave_vlan_add(dev, obj, extack);
> +			err = dsa_slave_vlan_add(dev, obj, extack);
> +		}
>  		break;
>  	case SWITCHDEV_OBJ_ID_MRP:
>  		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
> @@ -444,26 +462,29 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
>  static int dsa_slave_vlan_del(struct net_device *dev,
>  			      const struct switchdev_obj *obj)
>  {
> -	struct net_device *master = dsa_slave_to_master(dev);
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	struct switchdev_obj_port_vlan *vlan;
> -	int err;
>  
>  	if (dsa_port_skip_vlan_configuration(dp))
>  		return 0;
>  
>  	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
>  
> -	/* Do not deprogram the CPU port as it may be shared with other user
> -	 * ports which can be members of this VLAN as well.
> -	 */
> -	err = dsa_port_vlan_del(dp, vlan);
> -	if (err)
> -		return err;
> +	return dsa_port_vlan_del(dp, vlan);
> +}
>  
> -	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
> +static int dsa_slave_host_vlan_del(struct net_device *dev,
> +				   const struct switchdev_obj *obj)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct switchdev_obj_port_vlan *vlan;
>  
> -	return 0;
> +	if (dsa_port_skip_vlan_configuration(dp))
> +		return 0;
> +
> +	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> +
> +	return dsa_port_host_vlan_del(dp, vlan);
>  }
>  
>  static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
> @@ -489,10 +510,17 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
>  		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> -		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
> -			return -EOPNOTSUPP;
> +		if (netif_is_bridge_master(obj->orig_dev)) {
> +			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
> +				return -EOPNOTSUPP;
>  
> -		err = dsa_slave_vlan_del(dev, obj);
> +			err = dsa_slave_host_vlan_del(dev, obj);
> +		} else {
> +			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
> +				return -EOPNOTSUPP;
> +
> +			err = dsa_slave_vlan_del(dev, obj);
> +		}
>  		break;
>  	case SWITCHDEV_OBJ_ID_MRP:
>  		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
> @@ -1405,7 +1433,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  	}
>  
>  	/* And CPU port... */
> -	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &extack);
> +	ret = dsa_port_host_vlan_add(dp, &vlan, &extack);
>  	if (ret) {
>  		if (extack._msg)
>  			netdev_err(dev, "CPU port %d: %s\n", dp->cpu_dp->index,
> @@ -1413,7 +1441,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  		return ret;
>  	}
>  
> -	return vlan_vid_add(master, proto, vid);
> +	return 0;
>  }
>  
>  static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> @@ -1428,16 +1456,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>  	};
>  	int err;
>  
> -	/* Do not deprogram the CPU port as it may be shared with other user
> -	 * ports which can be members of this VLAN as well.
> -	 */
>  	err = dsa_port_vlan_del(dp, &vlan);
>  	if (err)
>  		return err;
>  
> -	vlan_vid_del(master, proto, vid);
> -
> -	return 0;
> +	return dsa_port_host_vlan_del(dp, &vlan);
>  }
>  
>  static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 4866b58649e4..9e4570bdea2f 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -558,6 +558,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
>  	return err;
>  }
>  
> +/* Port VLANs match on the targeted port and on all DSA ports */
>  static bool dsa_port_vlan_match(struct dsa_port *dp,
>  				struct dsa_notifier_vlan_info *info)
>  {
> @@ -570,6 +571,118 @@ static bool dsa_port_vlan_match(struct dsa_port *dp,
>  	return false;
>  }
>  
> +/* Host VLANs match on the targeted port's CPU port, and on all DSA ports
> + * (upstream and downstream) of that switch and its upstream switches.
> + */
> +static bool dsa_port_host_vlan_match(struct dsa_port *dp,
> +				     struct dsa_notifier_vlan_info *info)
> +{
> +	struct dsa_port *targeted_dp, *cpu_dp;
> +	struct dsa_switch *targeted_ds;
> +
> +	targeted_ds = dsa_switch_find(dp->ds->dst->index, info->sw_index);
> +	targeted_dp = dsa_to_port(targeted_ds, info->port);
> +	cpu_dp = targeted_dp->cpu_dp;
> +
> +	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
> +		return dsa_port_is_dsa(dp) || dp == cpu_dp;
> +
> +	return false;
> +}
> +
> +static struct dsa_vlan *dsa_vlan_find(struct list_head *vlan_list,
> +				      const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct dsa_vlan *v;
> +
> +	list_for_each_entry(v, vlan_list, list)
> +		if (v->vid == vlan->vid)
> +			return v;
> +
> +	return NULL;
> +}
> +
> +static int dsa_port_do_vlan_add(struct dsa_port *dp,
> +				const struct switchdev_obj_port_vlan *vlan,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int port = dp->index;
> +	struct dsa_vlan *v;
> +	int err = 0;
> +
> +	/* No need to bother with refcounting for user ports */
> +	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> +		return ds->ops->port_vlan_add(ds, port, vlan, extack);
> +
> +	mutex_lock(&dp->vlans_lock);
> +
> +	v = dsa_vlan_find(&dp->vlans, vlan);
> +	if (v) {
> +		refcount_inc(&v->refcount);
> +		goto out;
> +	}
> +
> +	v = kzalloc(sizeof(*v), GFP_KERNEL);
> +	if (!v) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = ds->ops->port_vlan_add(ds, port, vlan, extack);
> +	if (err) {
> +		kfree(v);
> +		goto out;
> +	}
> +
> +	v->vid = vlan->vid;
> +	refcount_set(&v->refcount, 1);
> +	list_add_tail(&v->list, &dp->vlans);
> +
> +out:
> +	mutex_unlock(&dp->vlans_lock);
> +
> +	return err;
> +}
> +
> +static int dsa_port_do_vlan_del(struct dsa_port *dp,
> +				const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int port = dp->index;
> +	struct dsa_vlan *v;
> +	int err = 0;
> +
> +	/* No need to bother with refcounting for user ports */
> +	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
> +		return ds->ops->port_vlan_del(ds, port, vlan);
> +
> +	mutex_lock(&dp->vlans_lock);
> +
> +	v = dsa_vlan_find(&dp->vlans, vlan);
> +	if (!v) {
> +		err = -ENOENT;
> +		goto out;
> +	}
> +
> +	if (!refcount_dec_and_test(&v->refcount))
> +		goto out;
> +
> +	err = ds->ops->port_vlan_del(ds, port, vlan);
> +	if (err) {
> +		refcount_set(&v->refcount, 1);
> +		goto out;
> +	}
> +
> +	list_del(&v->list);
> +	kfree(v);
> +
> +out:
> +	mutex_unlock(&dp->vlans_lock);
> +
> +	return err;
> +}
> +
>  static int dsa_switch_vlan_add(struct dsa_switch *ds,
>  			       struct dsa_notifier_vlan_info *info)
>  {
> @@ -581,8 +694,8 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
>  
>  	dsa_switch_for_each_port(dp, ds) {
>  		if (dsa_port_vlan_match(dp, info)) {
> -			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
> -						     info->extack);
> +			err = dsa_port_do_vlan_add(dp, info->vlan,
> +						   info->extack);
>  			if (err)
>  				return err;
>  		}
> @@ -594,15 +707,61 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
>  static int dsa_switch_vlan_del(struct dsa_switch *ds,
>  			       struct dsa_notifier_vlan_info *info)
>  {
> +	struct dsa_port *dp;
> +	int err;
> +
>  	if (!ds->ops->port_vlan_del)
>  		return -EOPNOTSUPP;
>  
> -	if (ds->index == info->sw_index)
> -		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
> +	dsa_switch_for_each_port(dp, ds) {
> +		if (dsa_port_vlan_match(dp, info)) {
> +			err = dsa_port_do_vlan_del(dp, info->vlan);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsa_switch_host_vlan_add(struct dsa_switch *ds,
> +				    struct dsa_notifier_vlan_info *info)
> +{
> +	struct dsa_port *dp;
> +	int err;
> +
> +	if (!ds->ops->port_vlan_add)
> +		return -EOPNOTSUPP;
> +
> +	dsa_switch_for_each_port(dp, ds) {
> +		if (dsa_port_host_vlan_match(dp, info)) {
> +			err = dsa_port_do_vlan_add(dp, info->vlan,
> +						   info->extack);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsa_switch_host_vlan_del(struct dsa_switch *ds,
> +				    struct dsa_notifier_vlan_info *info)
> +{
> +	struct dsa_port *dp;
> +	int err;
> +
> +	if (!ds->ops->port_vlan_del)
> +		return -EOPNOTSUPP;
> +
> +	dsa_switch_for_each_port(dp, ds) {
> +		if (dsa_port_host_vlan_match(dp, info)) {
> +			err = dsa_port_do_vlan_del(dp, info->vlan);
> +			if (err)
> +				return err;
> +		}
> +	}
>  
> -	/* Do not deprogram the DSA links as they may be used as conduit
> -	 * for other VLAN members in the fabric.
> -	 */
>  	return 0;
>  }
>  
> @@ -764,6 +923,12 @@ static int dsa_switch_event(struct notifier_block *nb,
>  	case DSA_NOTIFIER_VLAN_DEL:
>  		err = dsa_switch_vlan_del(ds, info);
>  		break;
> +	case DSA_NOTIFIER_HOST_VLAN_ADD:
> +		err = dsa_switch_host_vlan_add(ds, info);
> +		break;
> +	case DSA_NOTIFIER_HOST_VLAN_DEL:
> +		err = dsa_switch_host_vlan_del(ds, info);
> +		break;
>  	case DSA_NOTIFIER_MTU:
>  		err = dsa_switch_mtu(ds, info);
>  		break;
> -- 
> 2.25.1
