Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1812D479D9A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhLRVsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32219 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbhLRVsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864113; x=1671400113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fE3tqHjEMbCmphmGNz7kpGrKW6lOyKWN0AlPcHC/O5Q=;
  b=AM4vMwgajvm3Mid2SdY/3Y1t9FQksZpjFiW8PKgltjZxEH/rmUV7cT7G
   /TqQH+uUnH+eHMrIvPoL2FgwSRqEs0L/SF8kyyFc+yOnSzPOK+YUXzSq9
   C5TztsbHleekKLV5kcm0MB+D+ln8mdUFXWEk6/2pGEEUMw9X/A4LbfPBU
   Je6hlUOhYurl0fR1T5XWBHWea8tUsaNYjBENnVqDs3nF9m/uSMi6o2aV7
   cyRrw7DnbXamGBIVaAbWvdbErMuRyUtgeISMZEK0kgnxucJvfZOH/drDK
   gK7d4lbj/YvvDhhMtyLgFOZc3AGV5Om64gwDqnjnytofenqBN5JMdQg8n
   A==;
IronPort-SDR: sDrgruILdAfqUbZ2G4u1/j5kOEiQU4LC6LTZY0KuFEuBuHaikm9ZEILYgrKx2ymveh100gFh7B
 lIILTG73v742gFmpXd7P9g57RxJo4RUsigumPLFoAIXdOXm8pw9oXA1qilFT/V/qbMvyeyj4mc
 eWobWO6cN/6987/4WV20BO6lo1CiBvlOQSsipZkAZ+i0TPGYOIJUuICySpCY/zYUIzK0f97763
 g4PYkyZPQpZ0XE9DxZcrT9aiORydGUjasKz8y84oBVy2sOjLn0k+RW1/uA1IBJvGmB500sBTua
 xr2ZnnVYPxOjj97TMzq5ekmq
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="147123592"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v8 8/9] net: lan966x: Extend switchdev bridge flags
Date:   Sat, 18 Dec 2021 22:49:45 +0100
Message-ID: <20211218214946.531940-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently allow a port to be part or not of the multicast flooding mask.
By implementing the switchdev calls SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
and SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_switchdev.c     | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 81e37624b553..af058700a95b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -9,6 +9,39 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
+static void lan966x_port_set_mcast_flood(struct lan966x_port *port,
+					 bool enabled)
+{
+	u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_MC));
+
+	val = ANA_PGID_PGID_GET(val);
+	if (enabled)
+		val |= BIT(port->chip_port);
+	else
+		val &= ~BIT(port->chip_port);
+
+	lan_rmw(ANA_PGID_PGID_SET(val),
+		ANA_PGID_PGID,
+		port->lan966x, ANA_PGID(PGID_MC));
+}
+
+static void lan966x_port_bridge_flags(struct lan966x_port *port,
+				      struct switchdev_brport_flags flags)
+{
+	if (flags.mask & BR_MCAST_FLOOD)
+		lan966x_port_set_mcast_flood(port,
+					     !!(flags.val & BR_MCAST_FLOOD));
+}
+
+static int lan966x_port_pre_bridge_flags(struct lan966x_port *port,
+					 struct switchdev_brport_flags flags)
+{
+	if (flags.mask & ~BR_MCAST_FLOOD)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void lan966x_update_fwd_mask(struct lan966x *lan966x)
 {
 	int i;
@@ -67,6 +100,12 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 		return 0;
 
 	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		lan966x_port_bridge_flags(port, attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		err = lan966x_port_pre_bridge_flags(port, attr->u.brport_flags);
+		break;
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		lan966x_port_stp_state_set(port, attr->u.stp_state);
 		break;
-- 
2.33.0

