Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4732FAFE
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCFOAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhCFOAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 09:00:36 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDE7C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 06:00:36 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id p1so7092522edy.2
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 06:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yPTKIs3jMsNcGs83bXsC7ZvJto7AkgpE3TaZGgOGZfY=;
        b=Mm0WU7Ntf9XgTFdamTsO/BjqRFFRt5dcCsmIySflWh82yPkyiQt2iaBhM/WGK1h4/b
         qlUWBqqd3ji4SScP0/T3buP4wvizeJJR7cli7c7If7XtLgQP3qKdXmmuxzm22Not6biK
         wHltO8yW1yXRyrrw8UG9QLBkFR/Qxbq3dvaj99LqyCZvmVh5wfwvaAgev3dPGGrH3LRf
         Jarpm6P5oAKVI1KMGW7+Vsu+44onrUDp4AdtNwxgddHdFHxpfN0j2tyCqisHZ6ZhLQfS
         5gDI9o9dj66ZrRPhj6dLcYOLD5LLF+Psp/7aqDwSCdbc7y0xhrsd8q66hnJ2QtxgHC+z
         xIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yPTKIs3jMsNcGs83bXsC7ZvJto7AkgpE3TaZGgOGZfY=;
        b=i0eU/G8zooQl3YT646jCXHWXOJSBZLYv2QbzvR/ngTtn7sNP6lBSPRggu/5yYv8j9F
         TFHKqguLIn2rWzC9cBEzJlqR7jxg4lxSFmbKlbKs3C3EWJfLIgSeAGB9p8PdILizFmbc
         eQvqxkR5dLFubkFiUSgXw0C5JF480n2V4ZhwB5d6p/mki54HtMguCuuKtgngY7e1v07h
         /iIzlKdx8kO4ZIeYz3Z9FdG6hZUpaXTThmPtWmVQvQ4Vlm295s1t7rSYrsRmor/PDUBG
         ldKpzf0fw+rhTWcWWYtnYUoWmNQvs4UXtVrMSii3IstSvVBMooi8ajqWET4C329RwpF4
         nmCg==
X-Gm-Message-State: AOAM533dqCIR/oUbC3Xr19MM3s6uvip03ykFGGD0lGD4Q4ca/wr7Um65
        vyFvAf65MCVN9ELUWfO2+qE=
X-Google-Smtp-Source: ABdhPJxRTrgdGbEaM1Aruzh8b8OnaYNq5aVjoPZPv6Sr9+lwGAtHixnfSSJE5LJfMpwV+CR+VW1sFQ==
X-Received: by 2002:a05:6402:1d33:: with SMTP id dh19mr13767714edb.362.1615039234950;
        Sat, 06 Mar 2021 06:00:34 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q16sm3214636ejd.15.2021.03.06.06.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:00:34 -0800 (PST)
Date:   Sat, 6 Mar 2021 16:00:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge
 attribute changes
Message-ID: <20210306140033.axpbtqamaruzzzew@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
 <20210306002455.1582593-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306002455.1582593-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
> This is the second attempt to provide a fix for the issue described in
> 99b8202b179f, which was reverted in the previous commit.
> 
> When a change is made to some global bridge attribute, such as VLAN
> filtering, accept events where orig_dev is the bridge master netdev.
> 
> Separate the validation of orig_dev based on whether the attribute in
> question is global or per-port.
> 
> Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

What do you think about this alternative?

-----------------------------[ cut here ]-----------------------------
From af528ac6de2b16df4c8ba21bc7d978984883f319 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat, 6 Mar 2021 15:47:01 +0200
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

Let's keep that definition of dsa_port_offloads_netdev, and just add the
checks for the individual switchdev object types and attributes that can
be notified both on a physical port as well as on the bridge network
interface. This will allow us in the future to do things such as offload
VLANs on the bridge interface by sending them to the CPU port, instead
of the crude "all VLANs on user ports must be added to the CPU port too"
logic that we have now. It will also allow us to properly support the
drivers that don't implement .port_bridge_add and .port_bridge_leave,
because we'll still have an accurate answer to the question
"dsa_port_offloads_netdev".

Fixes: 99b8202b179f ("net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 60 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 491e3761b5f4..6e6384b2d5d2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -283,6 +283,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		if (!dsa_slave_dev_check(dev))
+			return 0;
+
 		ret = dsa_port_set_state(dp, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
@@ -290,13 +293,22 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		if (!dsa_slave_dev_check(attr->orig_dev))
+			return 0;
+
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (!dsa_slave_dev_check(attr->orig_dev))
+			return 0;
+
 		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags,
 						extack);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		if (!dsa_slave_dev_check(attr->orig_dev))
+			return 0;
+
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
@@ -341,9 +353,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp)) {
 		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
@@ -389,10 +398,14 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		return -EOPNOTSUPP;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
@@ -402,16 +415,21 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mrp_add_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
@@ -431,9 +449,6 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
@@ -457,10 +472,14 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		return -EOPNOTSUPP;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
@@ -470,16 +489,21 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (!dsa_slave_dev_check(obj->orig_dev))
+			return 0;
+
 		err = dsa_port_mrp_del_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
-----------------------------[ cut here ]-----------------------------
