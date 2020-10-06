Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C784A284E6F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgJFO4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:56:11 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32966 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgJFO4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601996168; x=1633532168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v0/BOEk8FwPkuHSCL3bWhHvT/r5H6A4X4lw4kAN4c/4=;
  b=eUXGrkmLq+/EM/dMlU8GM8AVikomXVF7E4dvVQBvq+rSAN9L9yTbhJS+
   +x+L9WcHZDIkTjJQrkFWB5hMhnWMbOGQM3ByoL2q0Ihu8tJkURW/BBZ9B
   bVIDDpLORgOYrrGhnASsVBMpXGjXARjKqwXbt2N6TpxV3M+rXD0AAgFaM
   NeOX/IaWLBBZUPkLIq/LiwGbB7SfRQqUaWLol8AiBIWrqTzkcGG0/X1cz
   /kAJvc8Vjoq8zF1dKBiM/OHp00xDMOlhgQ1HTnLWz6QYXWDayphCYCJwr
   LKrwJ/Yo2RhGa7Kl3uEADEYrJyhGF3w63LAzlSl4cccHzqvS/VquEJeww
   g==;
IronPort-SDR: 0kT2o0thliVnZKrb6Ec2X2kI9lFTY4+YzgBOSXj+H8FO0VYBV9/7GToiIRr/5mkPztnJZR6LPw
 17SZyOFf7AXds/qTPQpsxYA7pKnxydlY2EYaN3OJoWZzatssY5HDRqzE5RvI/tElzfMV8XUjQZ
 /FUsfiSh5GWsKVqMMB907rtnEk+kRd1aK1GQVCLPJlDwQdMIWAdcpgTXZ71FLiZaaLBnTBKS3y
 p+7voGgQD0oWHP0YTdv0GLe1yYboMkaCxYSy/Cu57qCa1okXD/GqPIy9+kqMybbMAYX10XF7Xp
 3gU=
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="94386971"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Oct 2020 07:56:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 6 Oct 2020 07:55:54 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 6 Oct 2020 07:56:02 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@resnulli.us>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v3 9/9] bridge: cfm: Bridge port remove.
Date:   Tue, 6 Oct 2020 14:53:38 +0000
Message-ID: <20201006145338.1956886-10-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
References: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is addition of CFM functionality to delete MEP instances
on a port that is removed from the bridge.
A MEP can only exist on a port that is related to a bridge.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>m
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
---
 net/bridge/br_cfm.c     | 13 +++++++++++++
 net/bridge/br_if.c      |  1 +
 net/bridge/br_private.h |  6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index 6fbfef44c235..fc8268cb76c1 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -867,3 +867,16 @@ bool br_cfm_created(struct net_bridge *br)
 {
 	return !hlist_empty(&br->mep_list);
 }
+
+/* Deletes the CFM instances on a specific bridge port
+ */
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *port)
+{
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	hlist_for_each_entry(mep, &br->mep_list, head)
+		if (mep->create.ifindex == port->dev->ifindex)
+			mep_delete_implementation(br, mep);
+}
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..f7d2f472ae24 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -334,6 +334,7 @@ static void del_nbp(struct net_bridge_port *p)
 	spin_unlock_bh(&br->lock);
 
 	br_mrp_port_del(br, p);
+	br_cfm_port_del(br, p);
 
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c36a0e3e29f2..6c79b10dad82 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1465,6 +1465,7 @@ static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
 bool br_cfm_created(struct net_bridge *br);
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
 int br_cfm_status_fill_info(struct sk_buff *skb,
 			    struct net_bridge *br,
@@ -1484,6 +1485,11 @@ static inline bool br_cfm_created(struct net_bridge *br)
 	return false;
 }
 
+static inline void br_cfm_port_del(struct net_bridge *br,
+				   struct net_bridge_port *p)
+{
+}
+
 static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
 {
 	return -EOPNOTSUPP;
-- 
2.28.0

