Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B0B4F81BF
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbiDGOfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344039AbiDGOfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:35:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A137B1A4D76
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:32:59 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l7so5845662ejn.2
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 07:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xKUy2LfkQOU36YYP275L0VIM3+P8AOvBnViRjJWqBFI=;
        b=HbqV7e/pJGj4ujn97e3htMy3sNkWe49fTuSqcKuCOcpoZQG82OreQiBEiCw5/hgb/E
         r58Tatyld41khG24JkUHnZsL2RcKQy6e16qwUKpuDUU47YwTmAfEgTM4SPdO4uqaJpRn
         Oya9qGvshiVg+gXDaBf24EDXSaL3lzYVsGncBPAL+y4F7WTRdbuIVxmhJ0Bih2mMoj1s
         AQAGjHo3qk/BfAA+IJeCMbRv/9MNEUiVcmSwwaW8Ew465btWXzVquqg6C+3/ej/lucc5
         vipAXEf3Gz5tSCVg4P1DnUr83F79iRTS7yujmkny7gjngSXUlO10CYnj7NTqhla+Hkfe
         Focw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKUy2LfkQOU36YYP275L0VIM3+P8AOvBnViRjJWqBFI=;
        b=7rwXiqfSHHixvvQi7QPbyBhLDhDfSXTr41Mk0gyFpL0FW/cXANBnceekK7cRW1JDcj
         JDk4Zyo6yNx8DvMmvi75S36/40E7kYB+sS7/GW8Cy0+tbPSndCD7YFNvs6IEDtOld33/
         e1AnLgqOFYp3fywUU3EKSgHRL/zBuJve2BIo9SNw2W6cbBupYMD1spW7Poh1+eFtpDAB
         6ny7M1zRO1hxrQF1kpddZLqncz/X6h0QZl7MPyiNoST6Ar9OH9G6w833vQKImJV9YeZt
         8TDzsrnnV/aeF5hvuByxqium5EMLgBcETquWgyXExIzcpiKzRyj+nHDlrkR+oYmP54VA
         sHUw==
X-Gm-Message-State: AOAM532lmD3KqyRu/rKqnoKJ7gooYfCmbHxzWKL2PoguNvWTsesIXlFq
        vBYouOjZHPalM66gFLTAhyI=
X-Google-Smtp-Source: ABdhPJwn8LJugTTDkFrg+dmB2k704vMDEbAwp+4LYEBrqtaP0TM2ZFd5ZMdG6AujdxWk7W6mvgVaoA==
X-Received: by 2002:a17:907:9811:b0:6e8:d7:7bf5 with SMTP id ji17-20020a170907981100b006e800d77bf5mr14139783ejc.381.1649341945990;
        Thu, 07 Apr 2022 07:32:25 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709060e8300b006d0e8ada804sm7665607ejf.127.2022.04.07.07.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:32:24 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:32:23 +0300
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
Message-ID: <20220407143223.f7qqvvzbybjfkakm@skbuf>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
 <20220404104826.1902292-2-mattias.forsblad@gmail.com>
 <20220406230135.cdhd3rwugz4m4lw3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406230135.cdhd3rwugz4m4lw3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 02:01:35AM +0300, Vladimir Oltean wrote:
> > +static int dsa_slave_bridge_foreign_if_check(struct net_device *dev,
> > +					     struct dsa_mall_drop_tc_entry *drop)
> > +{
> > +	struct net_device *lower_dev;
> > +	struct dsa_port *dp = NULL;
> > +	bool foreign_if = false;
> > +	struct list_head *iter;
> > +
> > +	/* Check port types in this bridge */
> > +	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> > +		if (dsa_slave_dev_check(lower_dev))
> > +			dp = dsa_slave_to_port(lower_dev);
> 
> This is subtly buggy, because "dp" may have a NULL dp->bridge (software
> forwarding), which is effectively equivalent to "foreign_if = true" in
> that it requires sending traffic to the CPU. Yet you don't set
> "foreign_if = true" when you detect such a port.
> 
> > +		else
> > +			foreign_if = true;
> 
> And this is really buggy, because the bridge port may be an offloaded
> LAG device which doesn't require forwarding to the CPU, yet you mark it
> as foreign_if = true.
> 
> This is actually more complicated to treat, because not only do you need
> to dig deeper through the lowers of the bridge port itself, but you have
> to monitor CHANGEUPPER events where info->upper_dev isn't a bridge at all.
> Just consider the case where a DSA port joins a LAG which is already a
> bridge port, in a bridge with foreign interfaces.
> 
> > +	}
> > +
> > +	/* Offload only if we have requested it and the bridge only
> > +	 * contains dsa ports
> > +	 */
> > +	if (!dp || !dp->bridge)
> > +		return 0;
> 
> And this is subtly buggy too, because you only look at the last dp you
> see. But in a mixed bridge with offloaded and unoffloaded DSA interfaces,
> you effectively fail to update dp->bridge->local_rcv_effective, because
> the dp->bridge of the last dp may be NULL, yet you've walked through
> non-NULL dp->bridge structures which you've ignored.

Edit: the implementation I had posted yesterday is buggy too, because if
the bridge contains no direct DSA slave interface, just LAG interfaces
offloaded by DSA interfaces, we'll fail to get a hold of a dp->bridge.

It seems like the most straightforward thing to do is to find the bridge
from our list of bridges rather than deducing it from the bridge device
lowers.

-----------------------------[ cut here ]-----------------------------
From f980ba7ac63c527fd2b9a674e2249d4308ac1620 Mon Sep 17 00:00:00 2001
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
 include/net/dsa.h  |  3 ++-
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     |  7 +++++++
 net/dsa/slave.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 1 deletion(-)

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
index af9a815c2639..cbee564e1c22 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -656,8 +656,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	if (err)
 		goto err_bridge_join;
 
+	err = dsa_bridge_foreign_dev_update(bridge_dev);
+	if (err)
+		goto err_foreign_update;
+
 	return 0;
 
+err_foreign_update:
+	dsa_port_pre_bridge_leave(dp, bridge_dev);
+	dsa_port_bridge_leave(dp, bridge_dev);
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f87109e7696d..ce213b93ec05 100644
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
@@ -2874,6 +2890,42 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	return true;
 }
 
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
+{
+	struct net_device *first_slave = NULL, *lower;
+	struct dsa_bridge *bridge = NULL;
+	struct dsa_switch_tree *dst;
+	bool have_foreign = false;
+	struct list_head *iter;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
+				bridge = dp->bridge;
+				first_slave = dp->slave;
+				break;
+			}
+		}
+	}
+
+	/* Bridge with no DSA interface in it */
+	if (!bridge)
+		return 0;
+
+	netdev_for_each_lower_dev(bridge_dev, lower, iter) {
+		if (dsa_foreign_dev_check(first_slave, lower)) {
+			have_foreign = true;
+			break;
+		}
+	}
+
+	bridge->have_foreign = have_foreign;
+	/* TODO update all other consumers of this information */
+
+	return 0;
+}
+
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-----------------------------[ cut here ]-----------------------------
