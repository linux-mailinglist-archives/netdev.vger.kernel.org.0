Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F5C20AD37
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgFZHeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:34:21 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21154 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbgFZHeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 03:34:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593156859; x=1624692859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bGdo8Z3VK54TAZk4Kcgqdi2FUl61QSXWAzjqQhcrnXk=;
  b=KcslBG8MdoUwnbmw9lJco1GcL6RogQq7PcHmAtuhyF1nU6vOl3ifoRzR
   b1qbVIZHfiZPaopyWaewnJ9itWbMY8YKCkbXrVfX/043xO+Mu+bTLUcIM
   dBXmxqiNbUEBSlyo6XRAoc7jxqSu2FcuqFfFJt32gvVDxx7NLtM73by6p
   5+7sK6Kc/iD7BaaXTogAyElS4+/R6xijQAM0W66jAm7tXgLEldGpb17LI
   dP5Dgp4fhxeoILl4I1kv8ru7OcJpMkvZ4eclSJvuj8h1B6ynRYsFWlRsg
   ZbCvyHSbrG5zAzODkcZztcvRUHHd0ER4oSH1Iz004ZGj3rKRO3s76WDgi
   w==;
IronPort-SDR: o6TJF88jfv+NB/E/tDZVojeiPpYZtzPCgst5yrmxZx1y2rUweDqYCWvm7EFlueb7nug8Of0RWV
 R/8Yiqll3NsLCNywTrScMgvFQ+T80wqSN1uKTtudf0HEx9Xse0G5Fx/DhmplYY1/Ikpj3EoZTw
 a4o3SmwO9/rHtbLDkF0W4ND6HZPIRh8Xtjkc3U7QdZ8irnGsJxk/Fu3LMd51GAo9XI+gEdNtZ+
 uTDRP+LSKDaucNRBO9CBMgvztTs0A8tOePT2Wc53MSz+BU/ug4IS/ED6vHbrUd6Z4Mf9TMN2an
 QAw=
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="85185615"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2020 00:34:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 00:34:00 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 26 Jun 2020 00:34:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/2] bridge: mrp: Extend MRP netlink interface with IFLA_BRIDGE_MRP_CLEAR
Date:   Fri, 26 Jun 2020 09:33:48 +0200
Message-ID: <20200626073349.3495526-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626073349.3495526-1-horatiu.vultur@microchip.com>
References: <20200626073349.3495526-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the userspace daemon dies, then when is restarted it doesn't
know if there are any MRP instances in the kernel. Therefore extend the
netlink interface to allow the daemon to clear all MRP instances when is
started.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h |  8 ++++++++
 net/bridge/br_mrp.c            | 15 +++++++++++++++
 net/bridge/br_mrp_netlink.c    | 26 ++++++++++++++++++++++++++
 net/bridge/br_private_mrp.h    |  1 +
 4 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index caa6914a3e53a..2ae7d0c0d46b8 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -166,6 +166,7 @@ enum {
 	IFLA_BRIDGE_MRP_RING_STATE,
 	IFLA_BRIDGE_MRP_RING_ROLE,
 	IFLA_BRIDGE_MRP_START_TEST,
+	IFLA_BRIDGE_MRP_CLEAR,
 	__IFLA_BRIDGE_MRP_MAX,
 };
 
@@ -228,6 +229,13 @@ enum {
 
 #define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
 
+enum {
+	IFLA_BRIDGE_MRP_CLEAR_UNSPEC,
+	__IFLA_BRIDGE_MRP_CLEAR_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_CLEAR_MAX (__IFLA_BRIDGE_MRP_CLEAR_MAX - 1)
+
 struct br_mrp_instance {
 	__u32 ring_id;
 	__u32 p_ifindex;
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 779e1eb754430..dcbf21b91313d 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -372,6 +372,21 @@ int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance)
 	return 0;
 }
 
+/* Deletes all MRP instances on the bridge
+ * note: called under rtnl_lock
+ */
+int br_mrp_clear(struct net_bridge *br)
+{
+	struct br_mrp *mrp;
+	struct br_mrp *tmp;
+
+	list_for_each_entry_safe(mrp, tmp, &br->mrp_list, list) {
+		br_mrp_del_impl(br, mrp);
+	}
+
+	return 0;
+}
+
 /* Set port state, port state can be forwarding, blocked or disabled
  * note: already called with rtnl_lock
  */
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 34b3a8776991f..5e743538464f6 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -14,6 +14,7 @@ static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_NESTED },
 	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_NESTED },
 	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_CLEAR]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -235,6 +236,25 @@ static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
 	return br_mrp_start_test(br, &test);
 }
 
+static const struct nla_policy
+br_mrp_clear_policy[IFLA_BRIDGE_MRP_CLEAR_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_CLEAR_UNSPEC]		= { .type = NLA_REJECT },
+};
+
+static int br_mrp_clear_parse(struct net_bridge *br, struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_START_TEST_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_CLEAR_MAX, attr,
+			       br_mrp_clear_policy, extack);
+	if (err)
+		return err;
+
+	return br_mrp_clear(br);
+}
+
 int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
 {
@@ -301,6 +321,12 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 			return err;
 	}
 
+	if (tb[IFLA_BRIDGE_MRP_CLEAR]) {
+		err = br_mrp_clear_parse(br, tb[IFLA_BRIDGE_MRP_CLEAR], extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 33b255e38ffec..25c3b8596c25b 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -36,6 +36,7 @@ struct br_mrp {
 /* br_mrp.c */
 int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance);
 int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
+int br_mrp_clear(struct net_bridge *br);
 int br_mrp_set_port_state(struct net_bridge_port *p,
 			  enum br_mrp_port_state_type state);
 int br_mrp_set_port_role(struct net_bridge_port *p,
-- 
2.26.2

