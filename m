Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298DA21C9CC
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgGLOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:10:29 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:27226 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbgGLOJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594562976; x=1626098976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7oeyCdW3SaxHGFwrbjX0PagsNEmHZBm/ki2DO6IlLE=;
  b=e7Ub/r1WkweMKqCjkLZbqIISWSWzeWtipGa1c7uET3Lit/GEJ0vZHXng
   Jo9KKFqNom7PPTNvteU0xJUptSidApqlNIvvAIZDjEHxdIScO1eurGf8Q
   lmB6b2EqjOWCdVd/L5fu1BLkO34apuZNW7P817O92bmhceSvsH/T1ViqE
   abr6RL0fS5xRhVReEvc9MPRbOVNt/s48oOYsyF6H5s0Bu7GGpwhV+9pj9
   /hGbp55kFBfYN9tMxr5HIe3Rzli7Rs47zLCJ9KDVHtNXOMCYlH7ZwTQKp
   SHU6OnXMqPBeedON0eQ3+YqR6mUkz9My56ZOAtoRZKep/4LEWB5INW1o8
   w==;
IronPort-SDR: 3lyMqw+i6PRvm1SP+/hbs+a4Ib+hwceLz/wqK6TteWtiF1m4y84Me0rlMpJbHep1xCGHSQoJ/+
 Ui0YkD81gMiChbVqP+OMs77A3y87yxAr2ulEhyuGcEwQXCq/Ep3e+siYskRQGL2zenIBhgTQgB
 Eaq7w5fir0NJjLG4pf6v5n4xkfLKHKlmKbLdipLVUsydAYAbhOjqcQ+zowtMmqfpgwdxtfJnml
 au612Y8yz4LRcQrMN1ncepy8ZQCB0iYHLcpH31o2PN+8O8awds01qw7lVVkAlsHinoX5i1TvKV
 qYg=
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="18871092"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2020 07:09:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 07:09:35 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 12 Jul 2020 07:09:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 05/12] bridge: mrp: Rename br_mrp_port_open to br_mrp_ring_port_open
Date:   Sun, 12 Jul 2020 16:05:49 +0200
Message-ID: <20200712140556.1758725-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
References: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
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

