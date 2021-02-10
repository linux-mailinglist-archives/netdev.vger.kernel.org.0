Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA1631621B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBJJYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhBJJUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:20:53 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266F6C061793;
        Wed, 10 Feb 2021 01:19:19 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bl23so2827212ejb.5;
        Wed, 10 Feb 2021 01:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BaqHv35UAk0w7T/uD/CSSDW6lycJdyqutaqpLfpkUVI=;
        b=U474aC74CwqAWi7SHJtwSnOKIbXigvlO4bts0L0AuxnJDjKGkfNO45S3MpsQ63V89l
         fzpg46e7j1JdZq45baVuSlaFsCMXkjN+tV4CLnbkIN5B6W7rwfE/6KnnKvr67JjxLHRD
         NEr2T5ppiT9A64tJKtRqU/COyK1X0dPM4g1Ztp0ar7chXMlGm/oAwfWJh4W1P/h1YUEF
         m7raxCMKjjmPsLeBysEz0YF2TyItESN7lJInywLxVC3xue7JEXTLzTTHBFi7tIkRV8bb
         nX5f17aJKpGRjbUyEkpXVJv60+cJDb6NddGoCfkwRdmlJArGcrpnKhqpV5iycsPMR0Wh
         2oZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BaqHv35UAk0w7T/uD/CSSDW6lycJdyqutaqpLfpkUVI=;
        b=IidnRjrgOmlJR0maay3bVrzA5WpPTUSR6tJGFuWxc08DdKVnpzz48NyTI0p71JIf66
         +3smm0/PyTvXKHgWcio0NdIPsL/rZ52n1BfuxdOeDIQCQRq84LR0eFebTHKJZ0OJWmkq
         gVSYF5z46857kkmN9EW5JBdhXAI3Rn1rBQ0xScV2zgTiOzXBlc1FfWlpTeO3StDRi79z
         XXwCmW2tDXZ3EXodA9u+7AXQxKjhVyPHZkVm+sfQ6/8IfOKAsRD7DqBTelCQ0cYp32ce
         hdFM9v/YSlSAOvkLjn68/iGCDQhODiR1sadkoF+BKvMJQYnQKsvFuAkNFJfvxeaFK5rt
         /hsg==
X-Gm-Message-State: AOAM5310FYofzkXxdD/OeZUgoKry5elPnrmnYWyLP+kzDCpI5nmjlkgx
        CpKy3gJECQ7xA1SfPumNPek=
X-Google-Smtp-Source: ABdhPJxJFKeE+HQFussmBFnBxLn/qAlsEu7SJIIcZc9iiyPppfQZzhx46FNg4sjy4j9lZHHZEGogTw==
X-Received: by 2002:a17:906:391b:: with SMTP id f27mr1990443eje.228.1612948757874;
        Wed, 10 Feb 2021 01:19:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v3 net-next 03/11] net: bridge: don't print in br_switchdev_set_port_flag
Date:   Wed, 10 Feb 2021 11:14:37 +0200
Message-Id: <20210210091445.741269-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
References: <20210210091445.741269-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently br_switchdev_set_port_flag has two options for error handling
and neither is good:
- The driver returns -EOPNOTSUPP in PRE_BRIDGE_FLAGS if it doesn't
  support offloading that flag, and this gets silently ignored and
  converted to an errno of 0. Nobody does this.
- The driver returns some other error code, like -EINVAL, in
  PRE_BRIDGE_FLAGS, and br_switchdev_set_port_flag shouts loudly.

The problem is that we'd like to offload some port flags during bridge
join and leave, but also not have the bridge shout at us if those fail.
But on the other hand we'd like the user to know that we can't offload
something when they set that through netlink. And since we can't have
the driver return -EOPNOTSUPP or -EINVAL depending on whether it's
called by the user or internally by the bridge, let's just add an extack
argument to br_switchdev_set_port_flag and propagate it to its callers.
Then, when we need offloading to really fail silently, this can simply
be passed a NULL argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Deal with the br_switchdev_set_port_flag call from sysfs too.

Changes in v2:
- br_set_port_flag now returns void, so no extack there.
- don't overwrite extack in br_switchdev_set_port_flag if already
  populated.

 net/bridge/br_netlink.c   |  9 +++++----
 net/bridge/br_private.h   |  6 ++++--
 net/bridge/br_switchdev.c | 13 +++++++------
 net/bridge/br_sysfs_if.c  |  7 +++++--
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4e64775bd8fb..b7731614c036 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -866,7 +866,8 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 }
 
 /* Process bridge protocol info on port */
-static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
+static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
+		      struct netlink_ext_ack *extack)
 {
 	unsigned long old_flags, changed_mask;
 	bool br_vlan_tunnel_old;
@@ -896,7 +897,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 
 	changed_mask = old_flags ^ p->flags;
 
-	err = br_switchdev_set_port_flag(p, p->flags, changed_mask);
+	err = br_switchdev_set_port_flag(p, p->flags, changed_mask, extack);
 	if (err) {
 		p->flags = old_flags;
 		goto out;
@@ -1015,7 +1016,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 			if (err)
 				return err;
 
-			err = br_setport(p, tb);
+			err = br_setport(p, tb, extack);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
@@ -1105,7 +1106,7 @@ static int br_port_slave_changelink(struct net_device *brdev,
 	if (!data)
 		return 0;
 
-	return br_setport(br_port_get_rtnl(dev), data);
+	return br_setport(br_port_get_rtnl(dev), data, extack);
 }
 
 static int br_port_fill_slave_info(struct sk_buff *skb,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d242ba668e47..a1639d41188b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1575,7 +1575,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb);
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-			       unsigned long mask);
+			       unsigned long mask,
+			       struct netlink_ext_ack *extack);
 void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
@@ -1605,7 +1606,8 @@ static inline bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 					     unsigned long flags,
-					     unsigned long mask)
+					     unsigned long mask,
+					     struct netlink_ext_ack *extack)
 {
 	return 0;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c004ade25ac0..ac8dead86bf2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -60,7 +60,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-			       unsigned long mask)
+			       unsigned long mask,
+			       struct netlink_ext_ack *extack)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
@@ -80,14 +81,15 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
-				       &info.info, NULL);
+				       &info.info, extack);
 	err = notifier_to_errno(err);
 	if (err == -EOPNOTSUPP)
 		return 0;
 
 	if (err) {
-		br_warn(p->br, "bridge flag offload is not supported %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+		if (extack && !extack->_msg)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "bridge flag offload is not supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -97,8 +99,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	err = switchdev_port_attr_set(p->dev, &attr);
 	if (err) {
-		br_warn(p->br, "error setting offload flag on port %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+		NL_SET_ERR_MSG_MOD(extack, "error setting offload flag on port");
 		return err;
 	}
 
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 5aea9427ffe1..72e92376eef1 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -59,6 +59,7 @@ static BRPORT_ATTR(_name, 0644,					\
 static int store_flag(struct net_bridge_port *p, unsigned long v,
 		      unsigned long mask)
 {
+	struct netlink_ext_ack extack = {0};
 	unsigned long flags = p->flags;
 	int err;
 
@@ -68,9 +69,11 @@ static int store_flag(struct net_bridge_port *p, unsigned long v,
 		flags &= ~mask;
 
 	if (flags != p->flags) {
-		err = br_switchdev_set_port_flag(p, flags, mask);
-		if (err)
+		err = br_switchdev_set_port_flag(p, flags, mask, &extack);
+		if (err) {
+			netdev_err(p->dev, "%s\n", extack._msg);
 			return err;
+		}
 
 		p->flags = flags;
 		br_port_flags_change(p, mask);
-- 
2.25.1

