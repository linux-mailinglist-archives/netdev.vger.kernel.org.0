Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB1032FE45
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 02:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhCGA6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 19:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhCGA63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 19:58:29 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637BEC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 16:58:29 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id t1so9099181eds.7
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 16:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JGVC8eljnS1bmU/U5y3da8byk8k68uxQaOII3+uvvIo=;
        b=J2rnXkvNrUxz9qx83ZmXUHr5nmYpvX1Y0vQc+qrpWDIAHGnPU+qtrg+l1FwF5zyu2F
         vWhd8MG8beNZrCoBaQGmZES8IjvrJouTpowlXDGK3xATw4HGOC+YThyH6H9JRvThdxZC
         95zc2gIamT+pJalSfR2bm+WQIRRpErIer/Wd0CYfrKvIxxGLpBgtjlB52ZD46JN4qvT2
         bfJhqLfNOWyU0fBVEXz5fAQFMyaFobMKF1G1B1J9uXSHwaL2sjGejzzp3KBfXvdLejNc
         FS5fFXjQv+fJunlxUTtxp22SDKsyAr/0LL8jkvjrFyrfKjfJQV8nF7ece9qzjVQE1857
         af+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JGVC8eljnS1bmU/U5y3da8byk8k68uxQaOII3+uvvIo=;
        b=iLVbK7inOKsTWXa8kJpXEBVdnwo8OtO5nSH2h0mztOfZqA/KlqVpod2Hj6ZZdH6zoA
         U1aLlAqnLhOiiqV4LV7mGczI8E4B3QpjnK2P1GPbXjNmXrSbYlhvk6C5cW90GSfPK5Mp
         Dg4vj4EeCqBW1DZOubmoMSvPeqkMtWsJqbIwm6h/J5h6Q3/31fImV/VSD6hIaCjyzRQa
         p1OWFbotnyUhkNvuhp+BHzPSCYqCAOTIF7CGKLVYx0rxVTisV2t2p1Bi/Onb8/yOlqgD
         TzWr3dHBDIAre2SuHDTrD3iCNXSl8WoSkGjcoH9XyepuizFsdYDbpsvA8GRAwIMB8eAM
         aN5w==
X-Gm-Message-State: AOAM530t8jAFYUjXEyKtjbr25WKBK/FtwX2vCg5Ar3sV5H+vJhKQ7aWb
        aa5iPNrCzbpO6WnZ/a60JGc5zxzxc6A=
X-Google-Smtp-Source: ABdhPJwLJeY7/vQOfwf0KwuEw3wPJ2yhydmGUAwqOTXTeh3bcSBX8ZBGuPy2dmFjjZK2SZNu1TWyMA==
X-Received: by 2002:a50:fd83:: with SMTP id o3mr16304249edt.90.1615078707938;
        Sat, 06 Mar 2021 16:58:27 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id i10sm4000152ejv.106.2021.03.06.16.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 16:58:27 -0800 (PST)
Date:   Sun, 7 Mar 2021 02:58:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge
 attribute changes
Message-ID: <20210307005826.mj6jqyov4kzhqsti@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
 <20210306002455.1582593-3-tobias@waldekranz.com>
 <20210306140033.axpbtqamaruzzzew@skbuf>
 <20210306140440.3uwmyji4smxdpgpm@skbuf>
 <87czwcqh96.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czwcqh96.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 07:17:09PM +0100, Tobias Waldekranz wrote:
> On Sat, Mar 06, 2021 at 16:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Sat, Mar 06, 2021 at 04:00:33PM +0200, Vladimir Oltean wrote:
> >> Hi Tobias,
> >>
> >> On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
> >> > This is the second attempt to provide a fix for the issue described in
> >> > 99b8202b179f, which was reverted in the previous commit.
> >> >
> >> > When a change is made to some global bridge attribute, such as VLAN
> >> > filtering, accept events where orig_dev is the bridge master netdev.
> >> >
> >> > Separate the validation of orig_dev based on whether the attribute in
> >> > question is global or per-port.
> >> >
> >> > Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
> >> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> > ---
> >>
> >> What do you think about this alternative?
> >
> > Ah, wait, this won't work when offloading objects/attributes on a LAG.
> > Let me actually test your patch.
> 
> Right. But you made me realize that my v1 is also flawed, because it
> does not guard against trying to apply attributes to non-offloaded
> ports. ...the original issue :facepalm:
> 
> I have a version ready which reuses the exact predicate that you
> previously added to dsa_port_offloads_netdev:
> 
> -               if (netif_is_bridge_master(attr->orig_dev))
> +               if (dp->bridge_dev == attr->orig_dev)
> 
> Do you think anything else needs to be changed, or should I send that as
> v2?

Sorry, I just get a blank stare when I look at that blob of code you've
added at the beginning of dsa_slave_port_attr_set, it might as well be
correct but I'm not smart enough to process it and say "yes it is".

What do you think about this one? At least for me it's easier to
understand what's going on, and would leave a lot more room for further
fixups if needed.

-----------------------------[ cut here ]-----------------------------
From 1f1d463788ace3434878f16aa2f083db2b007990 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat, 6 Mar 2021 01:24:54 +0100
Subject: [PATCH] net: dsa: fix switchdev objects on bridge master mistakenly
 being applied on ports

Tobias reports that the blamed patch was too broad, and now, VLAN
objects being added to a bridge:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp3 master br0
bridge vlan add dev br0 vid 100 self

are being added to all slave ports instead (swp2, swp3).

This is because the fix was too broad: we made dsa_port_offloads_netdev
say "yes, I offload the br0 bridge" for all slave ports, but we didn't
add the checks whether the switchdev object was in fact meant for the
physical port or for the bridge itself.

The reason why the fix was too broad is because the question itself,
"does this DSA port offload this netdev", was too broad in the first
place. The solution is to disambiguate the question and separate it into
two different functions, one to be called for each switchdev attribute /
object that has an orig_dev == net_bridge (dsa_port_offloads_bridge),
and the other for orig_dev == net_bridge_port (*_offloads_bridge_port).

Fixes: 99b8202b179f ("net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 25 +++++++++++---------
 net/dsa/slave.c    | 59 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2eeaa42f2e08..9d4b0e9b1aa1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -230,8 +230,8 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
-static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
-					    struct net_device *dev)
+static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
+						 struct net_device *dev)
 {
 	/* Switchdev offloading can be configured on: */
 
@@ -241,12 +241,6 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 		 */
 		return true;
 
-	if (dp->bridge_dev == dev)
-		/* DSA ports connected to a bridge, and event was emitted
-		 * for the bridge.
-		 */
-		return true;
-
 	if (dp->lag_dev == dev)
 		/* DSA ports connected to a bridge via a LAG */
 		return true;
@@ -254,14 +248,23 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	return false;
 }
 
+static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
+					    struct net_device *bridge_dev)
+{
+	/* DSA ports connected to a bridge, and event was emitted
+	 * for the bridge.
+	 */
+	return dp->bridge_dev == bridge_dev;
+}
+
 /* Returns true if any port of this tree offloads the given net_device */
-static inline bool dsa_tree_offloads_netdev(struct dsa_switch_tree *dst,
-					    struct net_device *dev)
+static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
+						 struct net_device *dev)
 {
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_netdev(dp, dev))
+		if (dsa_port_offloads_bridge_port(dp, dev))
 			return true;
 
 	return false;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 491e3761b5f4..992fcab4b552 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -278,28 +278,43 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
-	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
-		return -EOPNOTSUPP;
-
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_set_state(dp, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags,
 						extack);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
 		break;
 	default:
@@ -341,9 +356,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp)) {
 		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
@@ -391,27 +403,36 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
 		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_add_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
@@ -431,9 +452,6 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
@@ -459,27 +477,36 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
 		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_del_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
@@ -2298,7 +2325,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * other ports bridged with the LAG should be able to
 			 * autonomously forward towards it.
 			 */
-			if (dsa_tree_offloads_netdev(dp->ds->dst, dev))
+			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev))
 				return NOTIFY_DONE;
 		}
 
-----------------------------[ cut here ]-----------------------------
