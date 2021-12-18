Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC30479D8F
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhLRVs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6554 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbhLRVsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864104; x=1671400104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L4Zeo+iupdje7QK4hzmJHLBzv4tA2GhoD2cRtibSm8o=;
  b=HFO2xbRSd8u3s5v4gMKrHvmYk+UJ7BPK7ER7/m+wvB86Sn491XugX//2
   bIV2/nC/n5mMQ0Nc/NNswAeFwY6uYhuzh3ab4GGNDMy+XfuuQQZe+DI9j
   Pf2PZ22fib5Zqe6niQz9Lfu4dgVa32Nd/+MVmSbaqAZ8TUNmdZjui5TOI
   ObhU+lBFgbnKTBD5GouFQcGUFTMJxyrohpI2rX5UQvrqXfc7a13H929xC
   5EP9NB9TqPMA1QfeRZ1cWgHQdmG4rkKHJw3v9YHJ40FUEkuiIVojZ+FAD
   GzgJ4yXBlMhekouPsFBAAi8sGjGj5+8ogLbAZdL6+qbrKiX+vsW8pyEmZ
   w==;
IronPort-SDR: 2gu/imQmrNijTC94wh710uAF/mP7gg/wkT1puwwNg/RkY9Je5MlPbnVRgIL6cJLEo8h1nnKYtZ
 a07LLNKppplDhG8bxaUNSRpA8t40wfgU5lYXtR6H5rQm+obx/zW0lCxgauYJuP2H/GeicKJ+Yd
 s4PStiqZJ7iHcn1+kwAM0ZVKnLgu6cSUluPyLg9JMUa2s7ompJOp1ceadAFDhGijWkZPKRsn0l
 6m/wP0GECiBPzBeOPf5GUmjbfbepJ7RkqLTG+xbiFRv02fBGCs8zZufjdQ86YxXvwa6wUX1NtB
 VU6kz0zutuqsVjvD/cBiHAB1
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="155989493"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:23 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v8 5/9] net: lan966x: Remove .ndo_change_rx_flags
Date:   Sat, 18 Dec 2021 22:49:42 +0100
Message-ID: <20211218214946.531940-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
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

