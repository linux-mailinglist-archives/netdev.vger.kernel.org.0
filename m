Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AF7472943
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbhLMKTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:19:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35196 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239323AbhLMKP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390528; x=1670926528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=haaajnQ9KdQzf5Mx5HH6B82QTnOP2wKd/LjkryL7T0I=;
  b=d3BhcTdRsfRx3TDzVSmdM5NFN1QaAjF8CsrK47r3IIrVp65lHYKL/pAX
   1v5XfeCOrvDenFLp/fAK0kjy7GvPIHmiggX+a98CwC9AHrPJhxNm9kIOi
   XGmUY4ynT5xZj1tMXfse7Mdg/kQj089R8vAj5tWWrxLrECVn3Dy+tgC+L
   1MQGcV+YTqYTwiipxe3LEpwomk6q+5mejGWqj6Xdc9V1TxRi29V6/UpCR
   BVz2QACfvMbpIcUCiVEWw95UmaJtK/zMdc9a4V8hoOQrU3BRNZlhCm4OW
   5HgBa/eJML7zmJkzuN/p1FSROKNHDBC2ws0EHhxs6nUJiRa4KuBes6UAa
   Q==;
IronPort-SDR: R9RkZw/20RZHlrXowl1QK9fVHLsJyjqoCxZeDkhP9qWReed1rlpdMojtidH8C3aJjI6WMeLxG3
 lebTLJuxVnKY/3pog7o7D+15aNtMznvre3f6073EaYemaOOXJW3gHX8FB1qLDmS0Nm++HHe11Q
 YOPv55Azgf2ILpY9YEpsYEygI0YdZNieaRX1TMMmjXR6OmSFTO/LqKe9Lc0Z2+bGKFrqgkVJHF
 FIXshD92gqRqDCHwjg8l42CdTLCurTseCCvFQsFlCXDksuS3hved4By2jYyAsfXmMhWRNKfH3v
 M4ghsaMX0lw/3zPjz0VzGqPh
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="146445674"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:20 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:15:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 09/10] net: lan966x: Extend switchdev bridge flags
Date:   Mon, 13 Dec 2021 11:14:31 +0100
Message-ID: <20211213101432.2668820-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
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
index 062b9fc80e7d..bda8fdf9514a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -11,6 +11,34 @@ struct lan966x_ext_entry {
 	u32 ports;
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
@@ -66,6 +94,12 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 	int err = 0;
 
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

