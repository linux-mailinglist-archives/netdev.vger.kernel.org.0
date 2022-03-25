Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C34E797D
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377201AbiCYQ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377210AbiCYQ5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:57:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F813E0CC;
        Fri, 25 Mar 2022 09:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648227321; x=1679763321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=alt+GVmfCQP3oT5MONyZvSlYVrF0TY9sxu2v7DZkm2Y=;
  b=W7W4hjvO6wv0vhYM0HayoDCeNWYJugpom8z4zdyoc5G1qK49/lbCXjWh
   4EC4Bc3AR8OfkJcd1bduzxkODnn2wOhx3XcxSxR+dhdKEHNDGwgtXKhBA
   PNc4EKo3CEtZf85Fx8bqxQG8giZpxXsZQtYNSnMs/dRhO8jQBO+q+80N/
   YF+D5X+DqyqD4lEjKG3Fc9zpMUOGRwZrSuRuayqDACjR2bel5H8TwODaF
   plid0Fy2nwD5zl7xfrYdJSIkHUTmGeKVqndEyxU7f849C62vNy0bvkwbN
   6EKrqa6kv4181taffL9Bag8n9f5qaIO+GImtV1EuPsSt93xtEku7HK7Fl
   w==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="90177743"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 09:55:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 09:54:55 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 09:54:49 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC PATCH v11 net-next 10/10] net: dsa: microchip: add support for vlan operations
Date:   Fri, 25 Mar 2022 22:23:41 +0530
Message-ID: <20220325165341.791013-11-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for VLAN add, del, prepare and filtering operations.

The VLAN aware is a global setting. Mixed vlan filterings
are not supported. vlan_filtering_is_global is made as true
in lan937x_setup function.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 186 +++++++++++++++++++++++
 1 file changed, 186 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5067da9488c1..f1489c5c7229 100644
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
@@ -162,6 +261,90 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
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
 				const unsigned char *addr, u16 vid,
 				struct dsa_db db)
@@ -1076,6 +1259,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

