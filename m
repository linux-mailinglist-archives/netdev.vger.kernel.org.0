Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C331D24F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhBPVpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:45:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45677 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhBPVpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:45:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511915; x=1645047915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xU9OI21zE49z1khz1tGdwEbVYbu5HKURTo6lpbHNH84=;
  b=Gzu4rQG4UJbN/LiZYLcM/v4hLtViI07Fnaa2OAA4kOW9G6/YY45hlKTP
   U8pXAyBKtNgV44glDyRH2O4eLNnSZz7ad9wgZkGOiI5N+f2BAXWuffT7Z
   dU45INDbVUeWfgWdWex1NYboKndhARDa1Djk9kK0P3H+oMRRxz+TetGr3
   mpTjiQ3aVCow5nzxVVqyzGC10JAwgHdv06dag15wGdLYRuBYys097EpX9
   SSUy34MAzbZ4JDwutO8IlRoS8WuiPoEJuFmb5oNSKD0bnQmW1hEWy4epM
   17T821FCKI+JnVFGWeYWtLmNGxTL3CREf2Ex20KpXu5LZ0ahhS6NKirAz
   g==;
IronPort-SDR: 06hfEACKEUI4f7wqLs9M/Z8ZX8QvH+KXZ5FbrldXtvzhjNopiZnG+U8NJCRsqWM8zxtka/0Qz/
 GGyvML9/x41ic8fm68Kd3FTkSzNjZaCK3mJC2bZIHm3+hrIfPRqIIh2bHu2WUKtl+zckwf/Nrd
 Yn5kHhzkZPC8xCmoI2VWlHXdUZSYfl+kBQgbmNqVLqYeONKg/OypQJRnppJzmXAZADbgNQlgrH
 Cm35GAzBXAPVFUOvz/oTXvyzlOjTGju/NUOGUEX8eOdHusjKHcdypD8LEbgnTgWro/LzVOGV/M
 AmU=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="115334519"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:10 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:43:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 3/8] bridge: mrp: Add 'enum br_mrp_hw_support'
Date:   Tue, 16 Feb 2021 22:42:00 +0100
Message-ID: <20210216214205.32385-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the enum br_mrp_hw_support that is used by the br_mrp_switchdev
functions to allow the SW to detect the cases where HW can't implement
the functionality or when SW is used as a backup.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 2514954c1431..966444304c38 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -46,6 +46,20 @@ struct br_mrp {
 	struct rcu_head			rcu;
 };
 
+/* This type is returned by br_mrp_switchdev functions that allow to have a SW
+ * backup in case the HW can't implement completely the protocol.
+ * BR_MRP_NONE - means the HW can't run at all the protocol, so the SW stops
+ *               configuring the node anymore.
+ * BR_MRP_SW - the HW can help the SW to run the protocol, by redirecting MRP
+ *             frames to CPU.
+ * BR_MRP_HW - the HW can implement completely the protocol.
+ */
+enum br_mrp_hw_support {
+	BR_MRP_NONE,
+	BR_MRP_SW,
+	BR_MRP_HW,
+};
+
 /* br_mrp.c */
 int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance);
 int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
-- 
2.27.0

