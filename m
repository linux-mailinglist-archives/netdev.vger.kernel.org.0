Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FC74A9E35
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377246AbiBDRqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:46:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:20478 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377249AbiBDRqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643996770; x=1675532770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cuGByK+uEpyblTUhK3/5PwLHaOehWs+ttlMnz9tNnu8=;
  b=lHOZY0+s6UKpAFVqkW7HTDUuOaPvPVyEgQXjXVAqtEOKlxE/wOa1H3gW
   HAbZ8JmtzO48H4k5hcfxqAY7lnZMdKdoM7ieexyMVOYnM03D7hJn+s7h2
   f+BR9w9KDZZXrXZbaTnesxeskW7QFYSHrqnsYljYmXiCTYo2r7q8dL165
   oF9qnEEODERaN0n+YoP5yHpVp3qwlMY5TFv/C7rryPBrDB+QxUO8M9teJ
   cvjhvoGVPMmmWYtAfVGOyQuWxUOpt0Lolb5ahSTMZRQTkJeLHbH9KkuEY
   v9ljKjg4SvNbpPX9fcq5l+frt1fS0VA8TK9KmLyZSssKULPg1ZRrNQwuc
   g==;
IronPort-SDR: tKgXqFGVcrakxhdl8v3JUavmsnyLix0rRorxDQz5jpoZCEO46nHU9e9qRaDE91TASeRfQFBdD+
 9o7cW4p5cxeuzEc63tmbkOl4GtkNmK1DOILgDexVjjGVPDrxPH5rlxkuZJjJqkNC8Cd07te610
 l0uziZL0jc86p4tkO1OBNtdWJ1LpeHcxgJm7cyt2SwMqGyykf6HJND4V5Ct4EW98HgDLn0UDwX
 GacoqMPPvrFh0p1iLFnmjtn459Ao0uc4gYLivHdsAg7FW0PCQdeeQqPjl6dSr0AQnUp3s64RJz
 KRL0Rwk6Wx2yUZSdPUoFy6rR
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="151993915"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 10:46:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 10:46:08 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 10:46:03 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v7 net-next 10/10] net: dsa: microchip: add support for vlan operations
Date:   Fri, 4 Feb 2022 23:15:00 +0530
Message-ID: <20220204174500.72814-11-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for VLAN add, del, prepare and filtering operations.

The VLAN aware is a global setting. Mixed vlan filterings
are not supported. vlan_filtering_is_global is made as true
in lan937x_setup function.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 186 +++++++++++++++++++++++
 1 file changed, 186 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index bc1b66777e03..ee1525a558a4 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -17,6 +17,14 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+static int lan937x_wait_vlan_ctrl_ready(struct ksz_device *dev)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL, val,
+					!(val & VLAN_START), 10, 1000);
+}
+
 static u8 lan937x_get_fid(u16 vid)
 {
 	if (vid > ALU_FID_SIZE)
@@ -25,6 +33,97 @@ static u8 lan937x_get_fid(u16 vid)
 		return vid;
 }
 
+static int lan937x_get_vlan_table(struct ksz_device *dev, u16 vid,
+				  struct lan937x_vlan *vlan_entry)
+{
+	u32 data;
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &data);
+	if (ret < 0)
+		goto exit;
+
+	vlan_entry->valid = !!(data & VLAN_VALID);
+	vlan_entry->fid	= data & VLAN_FID_M;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
+			 &vlan_entry->untag_prtmap);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4,
+			 &vlan_entry->fwd_map);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
+static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
+				  struct lan937x_vlan *vlan_entry)
+{
+	u32 data;
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	data = vlan_entry->valid ? VLAN_VALID : 0;
+	data |= vlan_entry->fid;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, data);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
+			  vlan_entry->untag_prtmap);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_entry->fwd_map);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
 static int lan937x_read_table(struct ksz_device *dev, u32 *table)
 {
 	int ret;
@@ -163,6 +262,90 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_update_port_member(dev, port);
 }
 
+static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag,
+				       struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* enable/disable VLAN mode, once enabled, look up process starts
+	 * and then forwarding and discarding are done based on port
+	 * membership of the VLAN table
+	 */
+	return lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, flag);
+}
+
+static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	struct lan937x_vlan vlan_entry;
+	int ret;
+
+	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
+		return ret;
+	}
+
+	vlan_entry.fid = lan937x_get_fid(vlan->vid);
+	vlan_entry.valid = true;
+
+	/* set/clear switch port when updating vlan table registers */
+	if (untagged)
+		vlan_entry.untag_prtmap |= BIT(port);
+	else
+		vlan_entry.untag_prtmap &= ~BIT(port);
+
+	vlan_entry.fwd_map |= BIT(port);
+
+	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table");
+		return ret;
+	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
+				       vlan->vid);
+		if (ret < 0) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+	struct lan937x_vlan vlan_entry;
+	int ret;
+
+	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return ret;
+	}
+
+	/* clear port fwd map & untag entries*/
+	vlan_entry.fwd_map &= ~BIT(port);
+	vlan_entry.untag_prtmap &= ~BIT(port);
+
+	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid)
 {
@@ -1102,6 +1285,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_vlan_filtering = lan937x_port_vlan_filtering,
+	.port_vlan_add = lan937x_port_vlan_add,
+	.port_vlan_del = lan937x_port_vlan_del,
 	.port_fdb_dump = lan937x_port_fdb_dump,
 	.port_fdb_add = lan937x_port_fdb_add,
 	.port_fdb_del = lan937x_port_fdb_del,
-- 
2.30.2

