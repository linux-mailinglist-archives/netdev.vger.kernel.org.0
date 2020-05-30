Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146441E9281
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgE3QLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:11:22 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17600 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgE3QLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590855080; x=1622391080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FNLQouKpG7IS4iwU0B98diux1lPp3DYq6mEgrVByZaE=;
  b=BPiM/BddQLNTPaygwkZ9e89LmcWS13xKVWQF0+SCkFwpKjWNmRgEsYcQ
   W+eIS5DOIMQQDZQPo4ZQE0siDWK4/rA1rrtI/tvY/o4Ue5LXYHffRlVAL
   3t992oY0VQsylA2ptiKcIMWvsJyU+xYsX4TNTRpQYD1PoeznIKyODXSIv
   bYVRiT13Cu1MxLtTuzJjFxVJSJVDVvaI8WDGr2gasVFQQYLZZKlSJTABo
   GHeg2WV4s9jmUmrGxEy/2GQfoaObZjeXo8yLp5j/ScpZGVmzY8K2tYrgB
   e8pNIEjAtEosqs7rws+tGJDIfxV1Z8zroSFC/bjQe3XPkmKSocJ1967Sc
   w==;
IronPort-SDR: C9J9r+nqFg2OJG6ExxKAHF3N1nZwkJdbaOLF67SF1S84dfnTLDFGmqdtVtnqsBBMBun8cJEaXK
 c94frczzkQVHqU1tErRWsfUEbTlMVYxVE/15LzjcOB2alqPduDanHXc9LWcvyQuzKCpIMwk23i
 uHX7p5aCPZFkTAEAdhjGPuYdzrez0I0nrAnDXo2MUry8rM81YrFio+vgjRXU9IpZAwCtFzHEsL
 xk21AIWTYO3cl28AVpOucDeYF6z7yr7SsAVtIb8x1JIoo6aChZVbfYpBX7nWIOWnQ2e6Tdsg9h
 d/U=
X-IronPort-AV: E=Sophos;i="5.73,452,1583218800"; 
   d="scan'208";a="14047735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2020 09:11:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 30 May 2020 09:11:19 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sat, 30 May 2020 09:11:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/3] bridge: mrp: Set the priority of MRP instance
Date:   Sat, 30 May 2020 18:09:47 +0000
Message-ID: <20200530180948.1194569-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
References: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each MRP instance has a priority, a lower value means a higher priority.
The priority of MRP instance is stored in MRP_Test frame in this way
all the MRP nodes in the ring can see other nodes priority.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h        | 1 +
 include/uapi/linux/if_bridge.h | 2 ++
 net/bridge/br_mrp.c            | 3 ++-
 net/bridge/br_mrp_netlink.c    | 5 +++++
 net/bridge/br_mrp_switchdev.c  | 1 +
 net/bridge/br_private_mrp.h    | 1 +
 6 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index db519957e134b..f82ef4c45f5ed 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -116,6 +116,7 @@ struct switchdev_obj_mrp {
 	struct net_device *p_port;
 	struct net_device *s_port;
 	u32 ring_id;
+	u16 prio;
 };
 
 #define SWITCHDEV_OBJ_MRP(OBJ) \
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 5a43eb86c93bf..0162c1370ecb6 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -176,6 +176,7 @@ enum {
 	IFLA_BRIDGE_MRP_INSTANCE_RING_ID,
 	IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX,
 	IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX,
+	IFLA_BRIDGE_MRP_INSTANCE_PRIO,
 	__IFLA_BRIDGE_MRP_INSTANCE_MAX,
 };
 
@@ -230,6 +231,7 @@ struct br_mrp_instance {
 	__u32 ring_id;
 	__u32 p_ifindex;
 	__u32 s_ifindex;
+	__u16 prio;
 };
 
 struct br_mrp_ring_state {
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 8ea59504ef47a..f8fd037219fe9 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -147,7 +147,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 	br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_RING_TEST, sizeof(*hdr));
 	hdr = skb_put(skb, sizeof(*hdr));
 
-	hdr->prio = cpu_to_be16(MRP_DEFAULT_PRIO);
+	hdr->prio = cpu_to_be16(mrp->prio);
 	ether_addr_copy(hdr->sa, p->br->dev->dev_addr);
 	hdr->port_role = cpu_to_be16(port_role);
 	hdr->state = cpu_to_be16(mrp->ring_state);
@@ -290,6 +290,7 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
 		return -ENOMEM;
 
 	mrp->ring_id = instance->ring_id;
+	mrp->prio = instance->prio;
 
 	p = br_mrp_get_port(br, instance->p_ifindex);
 	spin_lock_bh(&br->lock);
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index d9de780d2ce06..8cb67d9ca44e0 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -22,6 +22,7 @@ br_mrp_instance_policy[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_INSTANCE_PRIO]		= { .type = NLA_U16 },
 };
 
 static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
@@ -49,6 +50,10 @@ static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
 	inst.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]);
 	inst.p_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]);
 	inst.s_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]);
+	inst.prio = MRP_DEFAULT_PRIO;
+
+	if (tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO])
+		inst.prio = nla_get_u16(tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO]);
 
 	if (cmd == RTM_SETLINK)
 		return br_mrp_add(br, &inst);
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index 51cb1d5a24b4f..3a776043bf80d 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -12,6 +12,7 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
 		.p_port = rtnl_dereference(mrp->p_port)->dev,
 		.s_port = rtnl_dereference(mrp->s_port)->dev,
 		.ring_id = mrp->ring_id,
+		.prio = mrp->prio,
 	};
 	int err;
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index a0f53cc3ab85c..558941ce23669 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -14,6 +14,7 @@ struct br_mrp {
 	struct net_bridge_port __rcu	*s_port;
 
 	u32				ring_id;
+	u16				prio;
 
 	enum br_mrp_ring_role_type	ring_role;
 	u8				ring_role_offloaded;
-- 
2.26.2

