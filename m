Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6E9478B13
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhLQMJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:09:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9085 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbhLQMJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639742967; x=1671278967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9VA8D6bYEnnC9Y/Bka/7Sf+ZQwt4NdxJhfhWbnidquE=;
  b=lCJALZ+1XrZxZF6eMUjmOA7Q+/1OkDxUQllepA6bzgiqVRgp1hSU/jBv
   uPieM/q6bdy40EGmXMRr9DxxQTQ9uLI/eRSAm60ARVtEIFg782UcwUGnG
   Y5bVxnJpLUOb5UwM0y1dfJCbGggC10oF4m7WtDXXrHV9EyvzgAA/fzC8w
   6810BGNLpo0xSJHz2kjkg8tRuLyexxHeL4AmCSYn4hzvOkCzXs5FW9IMS
   6ch0tDWjOgQIkNtPqxNlPgSoT60J/aNwkBynk7/kMbPoVGc0OAs3ifiPR
   Vp52FYRp4jNEtl2ljw5jEIYHH8gx/8RXm5cylMg8J0S/6ble4TAICZd/N
   Q==;
IronPort-SDR: 4ASzrZMylXfZC69l61Gn8S0AR/eFpR4Ny4yJxYxcUnEfeebpA1KyJQ7oPxrU4L8SPG8qJnqVh+
 NQdY43V1/rstzlqLYZ6djgLRYX0OEeT4AOGMppMuFF1DAvPSfFap6nZiG9VSWTrwynqOrX0sZW
 xwlkoLQF7/vRUs2fPEW6fGuu+zfDQLLhRhVrZPg9mJgzw1qI5EbDfec3IuSKvsAwxWkzXLgCxw
 1lYzSgrcOZhQw1/LIShzSgQWVBu7i6R/Y48A0h4jU86eB+MTPGFLDx5mZeN103PQfEixiYA7Rw
 YO5FzCjQQ5iNdO4JNC3vv1XQ
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="155868904"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 05:09:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 05:09:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 05:09:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v6 8/9] net: lan966x: Extend switchdev bridge flags
Date:   Fri, 17 Dec 2021 13:10:16 +0100
Message-ID: <20211217121017.282481-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217121017.282481-1-horatiu.vultur@microchip.com>
References: <20211217121017.282481-1-horatiu.vultur@microchip.com>
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
 .../microchip/lan966x/lan966x_switchdev.c     | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index cef9e690fb82..af227b33cb3f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -9,6 +9,34 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
+static void lan966x_port_bridge_flags(struct lan966x_port *port,
+				      struct switchdev_brport_flags flags)
+{
+	u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_MC));
+
+	val = ANA_PGID_PGID_GET(val);
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		if (flags.val & BR_MCAST_FLOOD)
+			val |= BIT(port->chip_port);
+		else
+			val &= ~BIT(port->chip_port);
+	}
+
+	lan_rmw(ANA_PGID_PGID_SET(val),
+		ANA_PGID_PGID,
+		port->lan966x, ANA_PGID(PGID_MC));
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
@@ -67,6 +95,12 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
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

