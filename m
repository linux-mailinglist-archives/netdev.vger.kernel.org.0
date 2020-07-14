Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB0721EA67
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGNHjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:19 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:50721 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgGNHjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712355; x=1626248355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7oeyCdW3SaxHGFwrbjX0PagsNEmHZBm/ki2DO6IlLE=;
  b=MbRLCnPftio9m0SLPGsHeonPtIHjWPnshUE2DuCO+AcbTgf/hMc+pQoA
   GNgTTY5Brlp12jsVN4Zq5U5+W000DXBMel+2MEA3qisqqnkYxm9557upo
   WBbYWHq3q3lAW3kKc7HU9QHWekuCdAtGZahTRJeUp5S+w6eBNd8+qdwOx
   +oNydiK6903z7L41ufwu8KqwLjfJ+AnKmvPQqdMjU3tFO9Y+0I/5tmTWK
   9lFww9MZ7L7FtldRDSvdZXp/KB7HVcBeWvybbho+N3NFSqkDjfXie/JUO
   XUIq6N7q8IMSYhq9F00dDfA+IuBL3hKdEfPBcwvI0RlZrflZllLIvTLaY
   Q==;
IronPort-SDR: H0BiaTDn822x0pr0G6E6JHkv8cXmZKM8qqMC2QCWmNXkHPNskyOqbLD3g8jGzjcQEf+0dUpGqU
 9XZkRGIO8/DYpJJtDs/EcJ6y55EDeumhQhessb6YpWIjWFYqrUlWm335NXehVVjynzg/JeL3m1
 6fbSE9QYdH6eTztX7ixxUhg6I7g7ZaVLOibOnOHfUrGxdhwa59W0RVdYh8pUxseD4kSm1I8mSC
 3nS+f+o6BJgbmlsVknf5hhw1BgYMJaco2qv8I2h4fkl2gptImsSnSr4iCAW0rBg/+u+tOLeIeP
 /j8=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="81753268"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:38:44 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 05/12] bridge: mrp: Rename br_mrp_port_open to br_mrp_ring_port_open
Date:   Tue, 14 Jul 2020 09:34:51 +0200
Message-ID: <20200714073458.1939574-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames the function br_mrp_port_open to
br_mrp_ring_port_open. In this way is more clear that a ring port lost
the continuity because there will be also a br_mrp_in_port_open.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c         | 6 +++---
 net/bridge/br_mrp_netlink.c | 2 +-
 net/bridge/br_private_mrp.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 90592af9db619..fe7cf1446b58a 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -213,7 +213,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 		}
 
 		if (notify_open && !mrp->ring_role_offloaded)
-			br_mrp_port_open(p->dev, true);
+			br_mrp_ring_port_open(p->dev, true);
 	}
 
 	p = rcu_dereference(mrp->s_port);
@@ -229,7 +229,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 		}
 
 		if (notify_open && !mrp->ring_role_offloaded)
-			br_mrp_port_open(p->dev, true);
+			br_mrp_ring_port_open(p->dev, true);
 	}
 
 out:
@@ -537,7 +537,7 @@ static void br_mrp_mrm_process(struct br_mrp *mrp, struct net_bridge_port *port,
 	 * not closed
 	 */
 	if (mrp->ring_state != BR_MRP_RING_STATE_CLOSED)
-		br_mrp_port_open(port->dev, false);
+		br_mrp_ring_port_open(port->dev, false);
 }
 
 /* Determin if the test hdr has a better priority than the node */
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index c4f5c356811f3..acce300c0cc29 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -368,7 +368,7 @@ int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 	return -EMSGSIZE;
 }
 
-int br_mrp_port_open(struct net_device *dev, u8 loc)
+int br_mrp_ring_port_open(struct net_device *dev, u8 loc)
 {
 	struct net_bridge_port *p;
 	int err = 0;
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 8841ba847fb29..e93c8f9d4df58 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -74,6 +74,6 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 				   enum br_mrp_port_role_type role);
 
 /* br_mrp_netlink.c  */
-int br_mrp_port_open(struct net_device *dev, u8 loc);
+int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
 
 #endif /* _BR_PRIVATE_MRP_H */
-- 
2.27.0

