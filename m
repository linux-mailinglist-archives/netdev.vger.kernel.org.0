Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3458D367E06
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhDVJoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:44:32 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9908 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbhDVJob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084636; x=1650620636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cJLAzpx4+QLF4LIY4OJkqLB0ncw5gj/mbF7cohzklls=;
  b=fmy/pIr8+DCscdlcueL4sMpa6/7PCPIQysAPz2537b4NBQX66/7/fjat
   r8/HzUTq1plgFiyXt1CLDIoHt3qi9cD7iwaoX80xGOYX4Idb4GeZSRG/Y
   a4uy++kgaFEC6q1CblJL/zskN16cbF7Wg+5yPUpWCehHHVJ248Gebh3un
   TZSaEBDKAuIBKuBFiV870vMSHhxbbYcs9821qL1HUCfehmAnV6r9oYOys
   gKq7rVJd3EqliheAfywJjF2e7eXnqE25QlBmOdVxr/yONKm4AD+BbHQ2i
   AS+AL8ws0gkzbe+40Y0eQa8U816cY4fvDRUecau3GmXrEw0uUaqO8VzVc
   A==;
IronPort-SDR: V5PHlqJXK4sMWYwFDeVPjmxgw5b3BSVjMysa8hEKW/6HTWEvOifzbWi/33CkHXaflKDser+1Ky
 VYPy91IMlUy4rNlbELD32cNDfL3iTsTaF7Lr6xvBjMIVCco4i1JBqL5scglFPnwUaDfMJmsZ7o
 B2kD+9TJyjDnOjX0bW2BymHU/aDBiruj1zMiQodQkgJkc5BgqEh8tyN+8OteDOkiVN4kJqwTze
 OR+YKljYYHKOGLyFV/6lYY73ttzNh7T3zpLgFa7/aSsmZqh0EyNkmGMHQFM+iq9D0yPJfg9p/O
 2d4=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="117977918"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:54 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:48 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 7/9] net: dsa: microchip: add support for port mirror operations
Date:   Thu, 22 Apr 2021 15:12:55 +0530
Message-ID: <20210422094257.1641396-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for port_mirror_add() and port_mirror_del operations

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 50 ++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 573d2dd906f5..bfce5098ea69 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -128,6 +128,54 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+	int rc;
+
+	if (ingress)
+		rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
+	else
+		rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
+
+	if (rc < 0)
+		return rc;
+
+	rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
+	if (rc < 0)
+		return rc;
+
+	/* configure mirror port */
+	rc = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			      PORT_MIRROR_SNIFFER, true);
+	if (rc < 0)
+		return rc;
+
+	rc = lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+
+	return rc;
+}
+
+static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 data;
+
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
+
+	lan937x_pread8(dev, port, P_MIRROR_CTRL, &data);
+
+	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
 {
 	phy_interface_t interface;
@@ -396,6 +444,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_flags	= lan937x_port_bridge_flags,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
+	.port_mirror_add	= lan937x_port_mirror_add,
+	.port_mirror_del	= lan937x_port_mirror_del,
 	.port_max_mtu		= lan937x_get_max_mtu,
 	.port_change_mtu	= lan937x_change_mtu,
 	.phylink_validate	= lan937x_phylink_validate,
-- 
2.27.0

