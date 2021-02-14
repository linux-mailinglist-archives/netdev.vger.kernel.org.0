Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D993831B105
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhBNPzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhBNPzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:55:12 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA89C061756
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:31 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lg21so7353047ejb.3
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4uscKdj3e7dnMtPXmv9+QMMVBCYkWMXWgoYx5eWd1aM=;
        b=YLriXzAvAuOqD/v+i46xD2jTb4VVkH0LrnmPluR1jBrnWsQMDKMFIYUvaZS9e14hlI
         Ssa3c3QX5bZ8nyJsVIJXGckoUY+po0sD7k38yBMqSk8udS1XkM7gfGpKXDICn9tEJwBd
         IuIvi14+S9iIYvItHbg4TqARivCO6GNbtwX95XOPTCkTOTWD9TshC37Hs1DbP7tdPJS1
         9K8O4PWAEUtypWxENPMd+CLxdnJZYjN0I76HZrstWBIKS47SZ8SiSHQw0aqu3jwkAaY+
         8wmc5Omv11QWEnqNFm4Bx01xn5ekMyh/cQUxsLoLhfg/o2qU6tSn4tzh0KEq7hKoSOZh
         /kHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4uscKdj3e7dnMtPXmv9+QMMVBCYkWMXWgoYx5eWd1aM=;
        b=jZsJjbpg7qdJRo8eYNtCXVQpxutVqZQnXUlsiVTOQlnPHlnK0DQgse45/YQHZjJB3j
         KSqQrHbkPTcYsiXDj6s+mX4Iq/rupSkCChgifhlTdz55XNmVNT+lUx93sH9ZtKLI2xQ2
         HGYBjT2UJVhlOVJ/htbi4Qk0KmdDZWPL6c1f+fNedKr4f93BROuBQZuqdypkucXrqHvV
         HrevxYxzs2SsA+4HTRKfbW9qTBSYAWk/OK8hIXYFbvWt7E37BPa7YAsIx6IyuRlyg5te
         qbq7iTuRdBq6+tXbNH5JH0N/Wzd6UiYW344nLZIvMZUGza0OYa79JnTLDnw9E1IrC4fO
         iUew==
X-Gm-Message-State: AOAM532yYTtKP0Wuo5AHMvLSWOKV00OR38ZywBVcvQkFVqW7dbkehZ4d
        JDpwHopkppMc7w+8VCmzr74=
X-Google-Smtp-Source: ABdhPJxz8n+j9cVliZ8WX7SUNdPlQpSCHzjOlg4Hn+FofJywPjQPtxcPAfGraje37YIUjK15yb/1EQ==
X-Received: by 2002:a17:906:338f:: with SMTP id v15mr1451856eja.395.1613318069257;
        Sun, 14 Feb 2021 07:54:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cn18sm8576003edb.66.2021.02.14.07.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:54:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next 1/4] net: dsa: don't offload switchdev objects on ports that don't offload the bridge
Date:   Sun, 14 Feb 2021 17:53:23 +0200
Message-Id: <20210214155326.1783266-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155326.1783266-1-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Starting with commit 058102a6e9eb ("net: dsa: Link aggregation support"),
DSA warns that certain configurations of upper interfaces are not offloaded
to hardware. When a DSA port does not offload a LAG interface, the
dp->lag_dev pointer is always NULL. However the same cannot be said about
offloading a bridge: dp->bridge_dev will get populated regardless of
whether the driver can put the port into the bridge's forwarding domain
or not.

Instead of silently returning 0 if the driver doesn't implement
.port_bridge_join, return -EOPNOTSUPP instead, and print a message via
netlink extack that the configuration was not offloaded to hardware.

Now we can use the check whether dp->bridge_dev is NULL in order to
avoid offloading at all switchdev attributes and objects for ports that
don't even offload the basic operation of switching. Those can still do
the required L2 forwarding using the bridge software datapath, but
enabling any hardware features specific to the bridge such as address
learning would just ask for problems.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 2 ++
 net/dsa/slave.c    | 5 +++++
 net/dsa/switch.c   | 7 +++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f5949b39f6f7..7b0dd2d5f3f8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -205,6 +205,8 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 					    struct net_device *dev)
 {
 	/* Switchdev offloading can be configured on: */
+	if (!dp->bridge_dev)
+		return false;
 
 	if (dev == dp->slave)
 		/* DSA ports directly connected to a bridge, and event
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8c9a41a7209a..94bce3596eb6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1922,6 +1922,11 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_bridge_join(dp, info->upper_dev);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1906179e59f7..4137716d0de5 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -88,9 +88,12 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 {
 	struct dsa_switch_tree *dst = ds->dst;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_join)
+	if (dst->index == info->tree_index && ds->index == info->sw_index) {
+		if (!ds->ops->port_bridge_join)
+			return -EOPNOTSUPP;
+
 		return ds->ops->port_bridge_join(ds, info->port, info->br);
+	}
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
 	    ds->ops->crosschip_bridge_join)
-- 
2.25.1

