Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0035C475890
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242447AbhLOMMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:12:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:34591 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242395AbhLOMMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639570364; x=1671106364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ny48oPbrv7gOMJ87trlv0nUMZ4gaJyzubZH9Ly6NTcc=;
  b=DkZfG/rLPY9tFb2JafeiedQSzJpjweRgs7kr3XgNFSW9Whjq4bdayBvH
   Z/+AfAKQ+RvhF0VeF+S/S7cW6Dgbh1vJp5/HLycicbhz4o6/2mdeCZiSx
   acNd6COk6JtGnsdulg/qRa+DeU8+FBms9nccHqyL9nWivaGBNCrcV7Chw
   XkYE4qABSSZd/M7t8iTMRmJj16EYv9e+AlFOF1Xs5Fio/8p0MZG697P4r
   Kbd9DEB+yzO7DHiLw8lTGNUeRZOja3aXKW+6e5Ap6zvR7YkLYjUZce24J
   7vgLJgEO8h99wPjtY9OE0ZFO9MuXLkx+/U7hTPs09IyDEddoZkgTcveic
   w==;
IronPort-SDR: 5qni3QyGtI0v5o5st6NWNFAO2OVhjErBjis0XAsDahargFxLKL1CVdWrWvvENboWLfw5Dfbpx8
 l5QEubiXIX2uxoyA0Izjtn2Hl28Uy6PeOsJEm/W/8kzMTcDrHT/jMql6lrbUroF2b17+iyHP5U
 gVA8PAMn/YP+g/WNzIripufrK5LsqwYBk2mhuBWbeCofuq/3rRc8Z5E0j+Pzc52RKX9AXgdcPC
 8QEuy3yYmfqaRoKgehM0hRSJ213vtWGPVPAaPTsEzcNNbrx+Z0jJU5bllMgBeSLuATGN1VybOT
 d6TWGgY7guxjW8dQED1hxXtb
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="155564806"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 05:12:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 05:12:42 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Dec 2021 05:12:40 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 8/9] net: lan966x: Extend switchdev bridge flags
Date:   Wed, 15 Dec 2021 13:13:08 +0100
Message-ID: <20211215121309.3669119-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
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
index 61f9e906cf80..560486267695 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -18,6 +18,34 @@ struct lan966x_ext_entry {
 	struct lan966x *lan966x;
 };
 
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
@@ -76,6 +104,12 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
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

