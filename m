Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB9212794
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgGBPRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:17:46 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:15290 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgGBPRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593703065; x=1625239065;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BzwNLQaWDEDUI8FxwCl4Uh+/YsdsHxhPuPu4DdBvfT4=;
  b=g0tPRpEULEZ92GoQzlXOCqwGCz7tvcAZk3Uw50XeoHzbS5pEHqN8uGjf
   C2coVIaujsk+lebDI7P9sv6VkhRmo1NlIwXqTa2yRWCh34QosEgnRnMPN
   NBCgOokXV0sn8qhqKaqZNYGz/vIwyRAaUq1mbhQ/EdCyDXIcSWhaqs4YK
   LnFGDsIiSrFaa1zjIzECDTpVNZY7QiHjArppZHoYFj3a52FRafXjB3uWc
   uPC9i8hcX5CAsKJ3Y+ifW3tOoaMFzxmWknsK+ijSG8JF7hqRS7vKzwdWy
   DCTWUlhVDcIvc5H/3IVWelm6N4/DrWdpRyEkRY5E+f7rFB2Zcn+7lppDP
   A==;
IronPort-SDR: bikCCKFy82se/QGu3CCOpqAmO89tNv8/4+I9DE6ILM2SGcfx09uwXKu11nJLfKzGv66OZeioj8
 X/YuxJzpSE7SdWSc11WW1+6g3uAqti1jtZoyJqLWyupzMepCdQspU8Z6nGrPYtKyLoJQlpDpP7
 Y+a0RaGaQyg0SOu8RldLoYwLHU+fnXiCIcQKLz0JE9WPcIlnoI4cJhJXM68bieAJUO5DRYtIGx
 UrpRKCl/Xyhndasf+E09umbEBRjaurI7dOMQMWD55Jv11j1E6lOtPgZT5cvnsVDewnDUq5YuPh
 S68=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="78582058"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 08:17:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 08:17:24 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 08:17:30 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 1/2] net: dsa: microchip: split adjust_link() in phylink_mac_link_{up|down}()
Date:   Thu, 2 Jul 2020 18:17:23 +0300
Message-ID: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA subsystem moved to phylink and adjust_link() became deprecated in
the process. This patch removes adjust_link from the KSZ DSA switches and
adds phylink_mac_link_up() and phylink_mac_link_down().

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---

Changes in v2:
 - added reviewed-by tag;

 drivers/net/dsa/microchip/ksz8795.c    |  3 ++-
 drivers/net/dsa/microchip/ksz9477.c    |  3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 32 ++++++++++++++++----------
 drivers/net/dsa/microchip/ksz_common.h |  7 ++++--
 4 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 47d65b77caf7..862306a9db2c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1111,7 +1111,8 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.setup			= ksz8795_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.adjust_link		= ksz_adjust_link,
+	.phylink_mac_link_down	= ksz_mac_link_down,
+	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
 	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz8795_get_strings,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9a51b8a4de5d..9e4bdd950194 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1399,7 +1399,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.setup			= ksz9477_setup,
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
-	.adjust_link		= ksz_adjust_link,
+	.phylink_mac_link_down	= ksz_mac_link_down,
+	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
 	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz9477_get_strings,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..55ceaf00ece1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -135,26 +135,34 @@ int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 }
 EXPORT_SYMBOL_GPL(ksz_phy_write16);
 
-void ksz_adjust_link(struct dsa_switch *ds, int port,
-		     struct phy_device *phydev)
+void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+		       phy_interface_t interface)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
 
 	/* Read all MIB counters when the link is going down. */
-	if (!phydev->link) {
-		p->read = true;
-		schedule_delayed_work(&dev->mib_read, 0);
-	}
+	p->read = true;
+	schedule_delayed_work(&dev->mib_read, 0);
+
+	mutex_lock(&dev->dev_mutex);
+	dev->live_ports &= ~(1 << port);
+	mutex_unlock(&dev->dev_mutex);
+}
+EXPORT_SYMBOL_GPL(ksz_mac_link_down);
+
+void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		     phy_interface_t interface, struct phy_device *phydev,
+		     int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Remember which port is connected and active. */
 	mutex_lock(&dev->dev_mutex);
-	if (!phydev->link)
-		dev->live_ports &= ~(1 << port);
-	else
-		/* Remember which port is connected and active. */
-		dev->live_ports |= (1 << port) & dev->on_ports;
+	dev->live_ports |= (1 << port) & dev->on_ports;
 	mutex_unlock(&dev->dev_mutex);
 }
-EXPORT_SYMBOL_GPL(ksz_adjust_link);
+EXPORT_SYMBOL_GPL(ksz_mac_link_up);
 
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..c0224dd0cf8a 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,8 +159,11 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 
 int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
 int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
-void ksz_adjust_link(struct dsa_switch *ds, int port,
-		     struct phy_device *phydev);
+void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+		       phy_interface_t interface);
+void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		     phy_interface_t interface, struct phy_device *phydev,
+		     int speed, int duplex, bool tx_pause, bool rx_pause);
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-- 
2.25.1

