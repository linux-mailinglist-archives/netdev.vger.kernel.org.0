Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF572A65AE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgKDOAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:1607 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbgKDOAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:36 -0500
IronPort-SDR: /VQK9A7Uk5q6vrdIwGWjoYU+X7LiZs7xQm0RXUCFxCG2v+gpX0tDeEhwdCDhNCCnsQCYBHOBe1
 wFu1+1uVQZ5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="149069163"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="149069163"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:34 -0800
IronPort-SDR: ZlMg6vHkUSwYWHmlpK6l2RFmAQbema0FFS5LJ5a3+C6Ee79RQ+u5k74eg64dQ72WYvJUB+HeOx
 m+d3pGF3xVGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="363982559"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 04 Nov 2020 06:00:31 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 074D45C2; Wed,  4 Nov 2020 16:00:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 04/10] thunderbolt: Add link_speed and link_width to XDomain
Date:   Wed,  4 Nov 2020 17:00:24 +0300
Message-Id: <20201104140030.6853-5-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Isaac Hazan <isaac.hazan@intel.com>

Link speed and link width are needed for checking expected values in
case of using a loopback service.

Signed-off-by: Isaac Hazan <isaac.hazan@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 .../ABI/testing/sysfs-bus-thunderbolt         | 28 ++++++++
 drivers/thunderbolt/switch.c                  |  9 ++-
 drivers/thunderbolt/tb.h                      |  1 +
 drivers/thunderbolt/xdomain.c                 | 65 +++++++++++++++++++
 include/linux/thunderbolt.h                   |  4 ++
 5 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-thunderbolt b/Documentation/ABI/testing/sysfs-bus-thunderbolt
index 0b4ab9e4b8f4..a91b4b24496e 100644
--- a/Documentation/ABI/testing/sysfs-bus-thunderbolt
+++ b/Documentation/ABI/testing/sysfs-bus-thunderbolt
@@ -1,3 +1,31 @@
+What:		/sys/bus/thunderbolt/devices/<xdomain>/rx_speed
+Date:		Feb 2021
+KernelVersion:	5.11
+Contact:	Isaac Hazan <isaac.hazan@intel.com>
+Description:	This attribute reports the XDomain RX speed per lane.
+		All RX lanes run at the same speed.
+
+What:		/sys/bus/thunderbolt/devices/<xdomain>/rx_lanes
+Date:		Feb 2021
+KernelVersion:	5.11
+Contact:	Isaac Hazan <isaac.hazan@intel.com>
+Description:	This attribute reports the number of RX lanes the XDomain
+		is using simultaneously through its upstream port.
+
+What:		/sys/bus/thunderbolt/devices/<xdomain>/tx_speed
+Date:		Feb 2021
+KernelVersion:	5.11
+Contact:	Isaac Hazan <isaac.hazan@intel.com>
+Description:	This attribute reports the XDomain TX speed per lane.
+		All TX lanes run at the same speed.
+
+What:		/sys/bus/thunderbolt/devices/<xdomain>/tx_lanes
+Date:		Feb 2021
+KernelVersion:	5.11
+Contact:	Isaac Hazan <isaac.hazan@intel.com>
+Description:	This attribute reports number of TX lanes the XDomain
+		is using simultaneously through its upstream port.
+
 What: /sys/bus/thunderbolt/devices/.../domainX/boot_acl
 Date:		Jun 2018
 KernelVersion:	4.17
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index c73bbfe69ba1..05a360901790 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -932,7 +932,14 @@ int tb_port_get_link_speed(struct tb_port *port)
 	return speed == LANE_ADP_CS_1_CURRENT_SPEED_GEN3 ? 20 : 10;
 }
 
-static int tb_port_get_link_width(struct tb_port *port)
+/**
+ * tb_port_get_link_width() - Get current link width
+ * @port: Port to check (USB4 or CIO)
+ *
+ * Returns link width. Return values can be 1 (Single-Lane), 2 (Dual-Lane)
+ * or negative errno in case of failure.
+ */
+int tb_port_get_link_width(struct tb_port *port)
 {
 	u32 val;
 	int ret;
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 8ea360b0ff77..09658d07460e 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -864,6 +864,7 @@ struct tb_port *tb_next_port_on_path(struct tb_port *start, struct tb_port *end,
 	     (p) = tb_next_port_on_path((src), (dst), (p)))
 
 int tb_port_get_link_speed(struct tb_port *port);
+int tb_port_get_link_width(struct tb_port *port);
 
 int tb_switch_find_vse_cap(struct tb_switch *sw, enum tb_switch_vse_cap vsec);
 int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap);
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 7c61d2aeaac9..26dc1fc886e5 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -941,6 +941,43 @@ static void tb_xdomain_restore_paths(struct tb_xdomain *xd)
 	}
 }
 
+static inline struct tb_switch *tb_xdomain_parent(struct tb_xdomain *xd)
+{
+	return tb_to_switch(xd->dev.parent);
+}
+
+static int tb_xdomain_update_link_attributes(struct tb_xdomain *xd)
+{
+	bool change = false;
+	struct tb_port *port;
+	int ret;
+
+	port = tb_port_at(xd->route, tb_xdomain_parent(xd));
+
+	ret = tb_port_get_link_speed(port);
+	if (ret < 0)
+		return ret;
+
+	if (xd->link_speed != ret)
+		change = true;
+
+	xd->link_speed = ret;
+
+	ret = tb_port_get_link_width(port);
+	if (ret < 0)
+		return ret;
+
+	if (xd->link_width != ret)
+		change = true;
+
+	xd->link_width = ret;
+
+	if (change)
+		kobject_uevent(&xd->dev.kobj, KOBJ_CHANGE);
+
+	return 0;
+}
+
 static void tb_xdomain_get_uuid(struct work_struct *work)
 {
 	struct tb_xdomain *xd = container_of(work, typeof(*xd),
@@ -1052,6 +1089,8 @@ static void tb_xdomain_get_properties(struct work_struct *work)
 	xd->properties = dir;
 	xd->property_block_gen = gen;
 
+	tb_xdomain_update_link_attributes(xd);
+
 	tb_xdomain_restore_paths(xd);
 
 	mutex_unlock(&xd->lock);
@@ -1158,9 +1197,35 @@ static ssize_t unique_id_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(unique_id);
 
+static ssize_t speed_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tb_xdomain *xd = container_of(dev, struct tb_xdomain, dev);
+
+	return sprintf(buf, "%u.0 Gb/s\n", xd->link_speed);
+}
+
+static DEVICE_ATTR(rx_speed, 0444, speed_show, NULL);
+static DEVICE_ATTR(tx_speed, 0444, speed_show, NULL);
+
+static ssize_t lanes_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tb_xdomain *xd = container_of(dev, struct tb_xdomain, dev);
+
+	return sprintf(buf, "%u\n", xd->link_width);
+}
+
+static DEVICE_ATTR(rx_lanes, 0444, lanes_show, NULL);
+static DEVICE_ATTR(tx_lanes, 0444, lanes_show, NULL);
+
 static struct attribute *xdomain_attrs[] = {
 	&dev_attr_device.attr,
 	&dev_attr_device_name.attr,
+	&dev_attr_rx_lanes.attr,
+	&dev_attr_rx_speed.attr,
+	&dev_attr_tx_lanes.attr,
+	&dev_attr_tx_speed.attr,
 	&dev_attr_unique_id.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_vendor_name.attr,
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 5db2b11ab085..e441af88ed77 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -179,6 +179,8 @@ void tb_unregister_property_dir(const char *key, struct tb_property_dir *dir);
  * @lock: Lock to serialize access to the following fields of this structure
  * @vendor_name: Name of the vendor (or %NULL if not known)
  * @device_name: Name of the device (or %NULL if not known)
+ * @link_speed: Speed of the link in Gb/s
+ * @link_width: Width of the link (1 or 2)
  * @is_unplugged: The XDomain is unplugged
  * @resume: The XDomain is being resumed
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
@@ -223,6 +225,8 @@ struct tb_xdomain {
 	struct mutex lock;
 	const char *vendor_name;
 	const char *device_name;
+	unsigned int link_speed;
+	unsigned int link_width;
 	bool is_unplugged;
 	bool resume;
 	bool needs_uuid;
-- 
2.28.0

