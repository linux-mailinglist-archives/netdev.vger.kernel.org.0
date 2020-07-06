Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B68C215492
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgGFJVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:21:00 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16676 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgGFJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 05:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594027257; x=1625563257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KXvHOUThZBG1JwN3D0CPyXX+5vP02M2Oe4vY5byDp8I=;
  b=mRJCZl+nkWfs15Oz9CUNuKrdKTgErCprLM4LdeM/lOkl6J9QZvHuT5yr
   jkxaPtwpR66/WL1GYJDXe33mVL8rXAtWrWpLfpYKb/lWKKwQiTUcCOBpu
   7nfba5EaRmLLEGqLShO9W5DVDvlbFPiJPhKgtUaxaJ3Vq+t66wrW/B/Um
   MTGJ3WDql2QNf/bvpZ+J3AC1Wk4STM9AwmG5Xkoe40nEv4YrkzWVMQ9WF
   DCbpZlJJZNx20Z3yQjNJ1YIFqSrTMN7GS1VlVCKNofsbTIdGVkjQJ+wjx
   R0NnaPmGhmzWj/oJ5xz+IXfi4+QIJdN01cJnFcJIlcb5FuIykKURyeaQa
   g==;
IronPort-SDR: xw0V5yUAX6PQVVREnrId8Lc96DWAPMDhYx/UuQ1SeU9/oWTSiNncjeYSwO9E1MJB7TmeEstyu6
 md2FF7ZTYk1g0OzPw4BRX+zPOzB4r+PA8f3CWp0iOXwGT1P9bvM2yCrOUNdsUumO2Hjx3KIsRi
 BSe8wRuXUP3QBkAu+sngrnivLzyYrbw8nlOIOfY27pJ48UuqoKlsy1ujuQsPag5nFNvCxcmPXt
 qE90c8apvHyhvoHqxQIsqB2zLSoivDcX9R8u3HVnjofhyVGgnaKh7j/7k3WvZvpilHCWeSHglc
 Rig=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="18108987"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 02:20:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 02:20:57 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 6 Jul 2020 02:20:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 05/12] bridge: mrp: Rename br_mrp_port_open to br_mrp_ring_port_open
Date:   Mon, 6 Jul 2020 11:18:35 +0200
Message-ID: <20200706091842.3324565-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
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
index 779e1eb754430..d4176f8956d05 100644
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
index 5e612123c5605..d5957f7e687ff 100644
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

