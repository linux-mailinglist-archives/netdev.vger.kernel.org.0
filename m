Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13FB478B0A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhLQMJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:09:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9063 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbhLQMJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:09:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639742957; x=1671278957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L4Zeo+iupdje7QK4hzmJHLBzv4tA2GhoD2cRtibSm8o=;
  b=CLLOFWj66iMlp+cSiUOWfXC18aWgluRM/fRKU+D0X2Vtlf7wqvs2/PK6
   2PsvgWDPBRF9wQUI0kTxAye9BK6JhyVq/QAqE5IygcTHli9u6MeLm6v7S
   6+ogkJ7/7cNYW14fdYBaXZkVU+sN2fyqKjgxBPqRa4JdroRhWcrxyVpch
   IcskV2TzED/5cIAB1zg51R5K1LjY7duk3yRCwte8uKI1r9D63y/GxLq9I
   A2F0lm+JdmRJl04Y2pl7PUQrZpJ7UkNyr5eStHFL3NWVbPltfCjoJyy3X
   b1vZk4nEoMSZPWwS0uqMORUW+Hn4RZunZS5HEl4EG6OjAuzl/7B6z0WYc
   w==;
IronPort-SDR: i9nVnMBWSVnG+10070CE9T/INsa/v4u5xLk4N9iK87UydtyWbuSnSaJRM1quW+MIo54v2RQ2oN
 ZT/bKnEjRc05NiVa7elq484ddT+MDlxPVUJbK0tSf3ySKo6TTLg2A+S8hju+NcqaMtCIx74EZ9
 qL3OV1/A09bSQRIRQCdn5Am6IIsbEqHRLiqQzJW8CYAU4NRanDYUgmXgVwp/MhVYXsu/qI8Xpu
 M61GDflA/MwxPEFoIYRYvkYhyDQWKVIUwIJIrVIbXd68yVH9qNMF8L6aObqMRyn8m2DKCwAPcf
 2UOQnjrwLET/NTf3d0q+XyfN
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="155868879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 05:09:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 05:09:16 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 05:09:13 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v6 5/9] net: lan966x: Remove .ndo_change_rx_flags
Date:   Fri, 17 Dec 2021 13:10:13 +0100
Message-ID: <20211217121017.282481-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217121017.282481-1-horatiu.vultur@microchip.com>
References: <20211217121017.282481-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function lan966x_port_change_rx_flags() was used only when
IFF_PROMISC flag was set. In that case it was setting to copy all the
frames to the CPU instead of removing any RX filters. Therefore remove
it.

Fixes: d28d6d2e37d10d ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 23 -------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 7c6d6293611a..dc40ac2eb246 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -298,28 +298,6 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
 
-static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
-{
-	struct lan966x *lan966x = port->lan966x;
-
-	lan_rmw(ANA_CPU_FWD_CFG_SRC_COPY_ENA_SET(enable),
-		ANA_CPU_FWD_CFG_SRC_COPY_ENA,
-		lan966x, ANA_CPU_FWD_CFG(port->chip_port));
-}
-
-static void lan966x_port_change_rx_flags(struct net_device *dev, int flags)
-{
-	struct lan966x_port *port = netdev_priv(dev);
-
-	if (!(flags & IFF_PROMISC))
-		return;
-
-	if (dev->flags & IFF_PROMISC)
-		lan966x_set_promisc(port, true);
-	else
-		lan966x_set_promisc(port, false);
-}
-
 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -369,7 +347,6 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_open			= lan966x_port_open,
 	.ndo_stop			= lan966x_port_stop,
 	.ndo_start_xmit			= lan966x_port_xmit,
-	.ndo_change_rx_flags		= lan966x_port_change_rx_flags,
 	.ndo_change_mtu			= lan966x_port_change_mtu,
 	.ndo_set_rx_mode		= lan966x_port_set_rx_mode,
 	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
-- 
2.33.0

