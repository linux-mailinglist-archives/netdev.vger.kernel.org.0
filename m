Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20A347907D
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbhLQPxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:53:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:18931 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238487AbhLQPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639756398; x=1671292398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9VA8D6bYEnnC9Y/Bka/7Sf+ZQwt4NdxJhfhWbnidquE=;
  b=gPAfxXA/cFAKXRgp3d6IBLOZbdpHZFnnnvu56OXJt4gZsNawG9uLslca
   Ifghdx2p4VMTjzo+K35NUkFEwcyDsilwQmS51mxald8SeOmqUOoVT2Zlb
   0Ttt7h9/liUS3VNzI6jTrmkpRSNhkAx0NBvREPsUSQYbwa2qflh2TtItK
   eezgiaeHw7EVQ1gxZObiEPvOdeZRi7qhPs4CWKX5yeTlGBWFcDbmG3va0
   B7z5WKvZEfwdXMeMLcZCyhjEmrbCB7DjvpjWsnmRsaMyqGYly2srO1CGg
   huwACo+N6LbwK5XSoayztJDkz81w2fRYq4mNdtTaHCkIt6U6nxdVpfDMG
   w==;
IronPort-SDR: dSvKlNAl9xiYs4x/6h1o8hWw4hGADIjtqIcq82L0x/zZvyjySJjkOlV9P1M49j1O2XxXPpp9BL
 2jQnmpb55Vubeh5FIUqYtxJlRq9TFYk8b9iFV0fauKdh+Mps+0+nczVWDdat3/cBIxUzOIlDdR
 nYpeJHHekRq7oBGeQmbFZWZYlt+hncpQJS5B6R2XRlPsKmTf5tL+N/zluWOONOMS9nvAWkt2GH
 moSUOK1O/U8v8wNR6v0xOzEiFrrYixv+k7JjSHwiO13+Tq/m+zn8058QHJGsZylcpsa/oU+RJI
 Y21qg5APGroODdb4UrKQibXC
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="155892495"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 08:53:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 08:53:17 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 08:53:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v7 8/9] net: lan966x: Extend switchdev bridge flags
Date:   Fri, 17 Dec 2021 16:53:52 +0100
Message-ID: <20211217155353.460594-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217155353.460594-1-horatiu.vultur@microchip.com>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
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

