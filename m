Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325EA3D3ED1
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhGWQv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:51:56 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8470 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhGWQvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061533; x=1658597533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s/IbI4U2eY/Rf6aGcu5LRgHiyor0Okw2MpZuEmrVh5w=;
  b=eQxdrAVgD1ir6PxCxsThICgnCYLt7PAYkWMu+lcSkeJos1NajPW/FNME
   X3rWeNEDbTJzpFY0BHyIvkdYrKm0oSDcWdv03Zeq4KviFv/e6+P1Xv0hD
   iv0pCfGnQQrDrTpY+qVpbMpd/VK+8ZNXU72KNIQf9kBI5CsPrFEAz2GHd
   EjxOTxk+IQ5Lss8fKF5sbuYUgOn4xKv+pz9lNdiKcYqQOBFfsB/kbFX/i
   UJMJkJrSPy13tgyrshfD4x7M23UWiZAML8QzeC+1Epg/EMQNXQmuKoWuu
   2EvVCkk2/h1jp71yv2JChGZjprWkpTCuXByv9AwxZDX2SdMWdE6UCGEq1
   Q==;
IronPort-SDR: IWmxlCDfDse352/jJGLtR4miUk7befqJHK6lilieCpO+4pp62odTB2D6GirSmAn/MUWNTc9MHb
 VhIybc6HS6tR1JvSzPl3GheE/gCEMNghp8e7tj1rzVUWEfeO7Rvn6LXyVs8PiuN52iq1g8GdI/
 6fiLP1nuOSrMuCwu6UL7HLt3gOLVQcO99XjnM+6Nhfqi0hSWNC4Q7sEzsCW7bwVYfFfOrqHKf/
 7PUJ71+S1wdp/SPyUYMQ2W+K7JIH5ZZP9w2iCpq7rkiggmSYa+YYyso7lK/7d1v0Zq6B3vYBBL
 zdzSRMpnq4Ek+HBIrPAs80Rq
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="125755770"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:32:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:32:11 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:32:06 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 10/10] net: dsa: microchip: add support for vlan operations
Date:   Fri, 23 Jul 2021 23:01:08 +0530
Message-ID: <20210723173108.459770-11-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
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
 drivers/net/dsa/microchip/lan937x_main.c | 198 +++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index fb780678ef8d..963b066a8ad1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -15,6 +15,14 @@
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
@@ -23,6 +31,97 @@ static u8 lan937x_get_fid(u16 vid)
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
@@ -197,6 +296,102 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag,
+				       struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	ret = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE,
+			  flag);
+
+	return ret;
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
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table\n");
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
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table\n");
+		return ret;
+	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
+				       vlan->vid);
+		if (ret < 0) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid\n");
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
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	struct lan937x_vlan vlan_entry;
+	u16 pvid;
+	int ret;
+
+	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
+	pvid &= 0xFFF;
+
+	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return ret;
+	}
+	/* clear port fwd map */
+	vlan_entry.fwd_map &= ~BIT(port);
+
+	if (untagged)
+		vlan_entry.untag_prtmap &= ~BIT(port);
+
+	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return ret;
+	}
+
+	ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to set pvid\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid)
 {
@@ -1007,6 +1202,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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
2.27.0

