Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE82134535A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhCVXwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhCVXwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7371EC061574;
        Mon, 22 Mar 2021 16:52:14 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ce10so24107134ejb.6;
        Mon, 22 Mar 2021 16:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2lVrwqtYZdn4Cq95K9Ax8U6MOh2RqIZ/KBKR9D/4SSA=;
        b=Mn9525TUMj47Z5+rhoa9T9jBlJH36uLzpE7lsxEAPnB4nVNlF6lcSheE0UEndFclDv
         1SDXkMoHb0I4SNDVr1ylqcizP9zetYDZBoM+YuiVGdf90ARbq8kBNZK4UiaqSSaFoBV8
         puR9RJRqPTQnHfu7JX+rp7GPOFiAScyTAbVq0MoXDnq61digha4AAM62PrOeO12rB2Br
         /S+QAJCID5Kk36jlaqqFBESNJMyprDsTsVNRDcwbEbZ0uCMscrP17yvIbolH+wgRoiVj
         VbDcu/uQ1Xe96fu56T/D7CGRDuf6IWGQT4Eu6ceB+7nZbvUFOwEMwg72u/CpGarBcuPz
         H1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2lVrwqtYZdn4Cq95K9Ax8U6MOh2RqIZ/KBKR9D/4SSA=;
        b=ktpWoDXEGJbGzTUKC6XfqN5+EZfkrTZQnXkSAkQDGqF3OpTTHMIPnEPgUtfdoPECVC
         byNhMWJzQdxVGHGp0SsEJJ5bMjVZoMFjc/YSOH96n2PT6pOB0W+g3sxiCevEm5BPgNI/
         5/C3iBYLN3lfUZ/nty/8+SPG17mfw5yPZBCgMe8qSODR77Wjq9kvuaac2n/uN/xc0pgV
         ce3pBWO4Qau7pUmSTiPVHRJbhWrtEaN4tMR0b1ZTkuGKpkAknfL5sfojU5+L/fv2QMcF
         st4ibkYg23hJUE9W+z3XDEhvHeoXcniSQ16dX/JoQh1+LF5HTh20gnyL7w1sSaYfcdge
         F0PQ==
X-Gm-Message-State: AOAM531QZtpASnuYLfXhCBAvnPC374amMlTlUuviaVzS4K5t9wlNqPOh
        B6LFZpVtz9cXbGLqwBJFuTY=
X-Google-Smtp-Source: ABdhPJw6Z4W2eOXeu3zR1HNBC594Bag2zq+JaGAIBfYXElQK3zyFWrkvIz146REAYNi595/G96+1OQ==
X-Received: by 2002:a17:906:ecaa:: with SMTP id qh10mr2121344ejb.425.1616457133153;
        Mon, 22 Mar 2021 16:52:13 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 09/11] net: dsa: sync up switchdev objects and port attributes when joining the bridge
Date:   Tue, 23 Mar 2021 01:51:50 +0200
Message-Id: <20210322235152.268695-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If we join an already-created bridge port, such as a bond master
interface, then we can miss the initial switchdev notifications emitted
by the bridge for this port, while it wasn't offloaded by anybody.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  3 +++
 net/dsa/port.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  4 ++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b8778c5d8529..92282de54230 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -262,6 +262,9 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
+extern struct notifier_block dsa_slave_switchdev_notifier;
+extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
+
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c712bf3da0a0..01e30264b25b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -170,12 +170,46 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 static int dsa_port_switchdev_sync(struct dsa_port *dp,
 				   struct netlink_ext_ack *extack)
 {
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	struct net_device *br = dp->bridge_dev;
 	int err;
 
 	err = dsa_port_inherit_brport_flags(dp, extack);
 	if (err)
 		return err;
 
+	err = dsa_port_set_state(dp, br_port_get_stp_state(brport_dev));
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = dsa_port_vlan_filtering(dp, br_vlan_enabled(br), extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = dsa_port_ageing_time(dp, br_get_ageing_time(br));
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_mdb_replay(br, brport_dev,
+			    &dsa_slave_switchdev_blocking_notifier,
+			    extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_fdb_replay(br, brport_dev, &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_vlan_replay(br, brport_dev,
+			     &dsa_slave_switchdev_blocking_notifier,
+			     extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -198,6 +232,18 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+
+	/* VLAN filtering is handled by dsa_switch_bridge_leave */
+
+	/* Some drivers treat the notification for having a local multicast
+	 * router by allowing multicast to be flooded to the CPU, so we should
+	 * allow this in standalone mode too.
+	 */
+	dsa_port_mrouter(dp->cpu_dp, true, NULL);
+
+	/* Ageing time may be global to the switch chip, so don't change it
+	 * here because we have no good reason (or value) to change it to.
+	 */
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1ff48be476bb..c51e52418a62 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2392,11 +2392,11 @@ static struct notifier_block dsa_slave_nb __read_mostly = {
 	.notifier_call  = dsa_slave_netdevice_event,
 };
 
-static struct notifier_block dsa_slave_switchdev_notifier = {
+struct notifier_block dsa_slave_switchdev_notifier = {
 	.notifier_call = dsa_slave_switchdev_event,
 };
 
-static struct notifier_block dsa_slave_switchdev_blocking_notifier = {
+struct notifier_block dsa_slave_switchdev_blocking_notifier = {
 	.notifier_call = dsa_slave_switchdev_blocking_event,
 };
 
-- 
2.25.1

