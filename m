Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FF9475894
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbhLOMM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:12:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:10305 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242382AbhLOMMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639570355; x=1671106355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L4Zeo+iupdje7QK4hzmJHLBzv4tA2GhoD2cRtibSm8o=;
  b=xYMYVTcEgVUVgDuZGifouhEHqgPdrnZy/fBEm5nYehitANak8T8i3aGz
   u9mf9TPMHGHXZIl/a3Hh6M4KIc5jwVtPYxofrz1uxdtRP0xiyUhPq08AF
   T0xAZfCp1QGrCdnqlNfMj2/VkM0//DPuUMdzkSwkeFo4yHS/CQ2quCoX8
   plh/Leh8z42UuxOjBwVhesuXBoES25buon64iA8TOY2UpGWWQ/cuWRNVQ
   VHZsL9E1p2uPhmsnVCsnmQfVnuXCjaJvKw268Fp/fnusQsm0NSt3fsH4Y
   YXKDDNIoqyGyl8ASlE/ES/F8jzC3Bjueb1E6Jss4rNU1UeGwLm2qRc94/
   Q==;
IronPort-SDR: 3jMwNsVT7SRsIoxJn7ZTL287t+nuYerVlHAl8IT6fi6AOa+4z/vF6dsvlYCD9KaxR3KAjy85t4
 L4AlDVbPvzTqYJNKIUIlCg4jdtvYSvkqMrmEa95JIu7zVpmpP5qnPFlAWWGO70ciobcjWQGM3V
 LYTsabCjKxrydrKOtRGpLKxFIL6jKbsQOqxN9c0y9kfnk/LJdWv4Fyp2h8doWdVLeR0Pm42N7m
 z9mLufBrpdcunrZcS36HmTDtBWoB5LI3L91vRf/Vi2JbZiEjUAncT92rxGJCCS7YRKmTkg4LEU
 yjVfFJVI+fTb8E+voAboFSz1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="79637293"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 05:12:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 05:12:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Dec 2021 05:12:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 5/9] net: lan966x: Remove .ndo_change_rx_flags
Date:   Wed, 15 Dec 2021 13:13:05 +0100
Message-ID: <20211215121309.3669119-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
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

