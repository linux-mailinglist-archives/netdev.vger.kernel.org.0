Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF91C0158
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgD3QFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB9C24996;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=d94CsypiJEYQM/PseQEmq5pXeaworePLCyj5TfMicOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFVTwCE05GKbjAIiVWJcmuvzyWF1jmAYqlXSW9p5IVHDimnMzYxwl18SBzoXsPjOV
         sjcwD95387WIN+GKr/aHZmRLIuUBhuiNx2v9FHbqtqPuZ/lAhewdf8JEQgX21GVT1m
         BLthGxSjsmPsVaC5Q/p65FRdBm6y04cfWO3uUZR8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGg-Rg; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 32/37] docs: networking: convert switchdev.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:27 +0200
Message-Id: <549e294cfa5dc175b4b72c624cbabfbee9f0b84f.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use copyright symbol;
- adjust title markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../{switchdev.txt => switchdev.rst}          | 114 ++++++++++--------
 drivers/staging/fsl-dpaa2/ethsw/README        |   2 +-
 3 files changed, 66 insertions(+), 51 deletions(-)
 rename Documentation/networking/{switchdev.txt => switchdev.rst} (84%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e5a705024c6a..5e495804f96f 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -105,6 +105,7 @@ Contents:
    seg6-sysctl
    skfp
    strparser
+   switchdev
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/switchdev.txt b/Documentation/networking/switchdev.rst
similarity index 84%
rename from Documentation/networking/switchdev.txt
rename to Documentation/networking/switchdev.rst
index 86174ce8cd13..ddc3f35775dc 100644
--- a/Documentation/networking/switchdev.txt
+++ b/Documentation/networking/switchdev.rst
@@ -1,7 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+===============================================
 Ethernet switch device driver model (switchdev)
 ===============================================
-Copyright (c) 2014 Jiri Pirko <jiri@resnulli.us>
-Copyright (c) 2014-2015 Scott Feldman <sfeldma@gmail.com>
+
+Copyright |copy| 2014 Jiri Pirko <jiri@resnulli.us>
+
+Copyright |copy| 2014-2015 Scott Feldman <sfeldma@gmail.com>
 
 
 The Ethernet switch device driver model (switchdev) is an in-kernel driver
@@ -12,53 +18,57 @@ Figure 1 is a block diagram showing the components of the switchdev model for
 an example setup using a data-center-class switch ASIC chip.  Other setups
 with SR-IOV or soft switches, such as OVS, are possible.
 
+::
 
-                             User-space tools
+
+			     User-space tools
 
        user space                   |
       +-------------------------------------------------------------------+
        kernel                       | Netlink
-                                    |
-                     +--------------+-------------------------------+
-                     |         Network stack                        |
-                     |           (Linux)                            |
-                     |                                              |
-                     +----------------------------------------------+
+				    |
+		     +--------------+-------------------------------+
+		     |         Network stack                        |
+		     |           (Linux)                            |
+		     |                                              |
+		     +----------------------------------------------+
 
-                           sw1p2     sw1p4     sw1p6
-                      sw1p1  +  sw1p3  +  sw1p5  +          eth1
-                        +    |    +    |    +    |            +
-                        |    |    |    |    |    |            |
-                     +--+----+----+----+----+----+---+  +-----+-----+
-                     |         Switch driver         |  |    mgmt   |
-                     |        (this document)        |  |   driver  |
-                     |                               |  |           |
-                     +--------------+----------------+  +-----------+
-                                    |
+			   sw1p2     sw1p4     sw1p6
+		      sw1p1  +  sw1p3  +  sw1p5  +          eth1
+			+    |    +    |    +    |            +
+			|    |    |    |    |    |            |
+		     +--+----+----+----+----+----+---+  +-----+-----+
+		     |         Switch driver         |  |    mgmt   |
+		     |        (this document)        |  |   driver  |
+		     |                               |  |           |
+		     +--------------+----------------+  +-----------+
+				    |
        kernel                       | HW bus (eg PCI)
       +-------------------------------------------------------------------+
        hardware                     |
-                     +--------------+----------------+
-                     |         Switch device (sw1)   |
-                     |  +----+                       +--------+
-                     |  |    v offloaded data path   | mgmt port
-                     |  |    |                       |
-                     +--|----|----+----+----+----+---+
-                        |    |    |    |    |    |
-                        +    +    +    +    +    +
-                       p1   p2   p3   p4   p5   p6
+		     +--------------+----------------+
+		     |         Switch device (sw1)   |
+		     |  +----+                       +--------+
+		     |  |    v offloaded data path   | mgmt port
+		     |  |    |                       |
+		     +--|----|----+----+----+----+---+
+			|    |    |    |    |    |
+			+    +    +    +    +    +
+		       p1   p2   p3   p4   p5   p6
 
-                             front-panel ports
+			     front-panel ports
 
 
-                                    Fig 1.
+				    Fig 1.
 
 
 Include Files
 -------------
 
-#include <linux/netdevice.h>
-#include <net/switchdev.h>
+::
+
+    #include <linux/netdevice.h>
+    #include <net/switchdev.h>
 
 
 Configuration
@@ -114,10 +124,10 @@ Using port PHYS name (ndo_get_phys_port_name) for the key is particularly
 useful for dynamically-named ports where the device names its ports based on
 external configuration.  For example, if a physical 40G port is split logically
 into 4 10G ports, resulting in 4 port netdevs, the device can give a unique
-name for each port using port PHYS name.  The udev rule would be:
+name for each port using port PHYS name.  The udev rule would be::
 
-SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}=="<phys_switch_id>", \
-	ATTR{phys_port_name}!="", NAME="swX$attr{phys_port_name}"
+    SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}=="<phys_switch_id>", \
+	    ATTR{phys_port_name}!="", NAME="swX$attr{phys_port_name}"
 
 Suggested naming convention is "swXpYsZ", where X is the switch name or ID, Y
 is the port name or ID, and Z is the sub-port name or ID.  For example, sw1p1s0
@@ -173,7 +183,7 @@ Static FDB Entries
 
 The switchdev driver should implement ndo_fdb_add, ndo_fdb_del and ndo_fdb_dump
 to support static FDB entries installed to the device.  Static bridge FDB
-entries are installed, for example, using iproute2 bridge cmd:
+entries are installed, for example, using iproute2 bridge cmd::
 
 	bridge fdb add ADDR dev DEV [vlan VID] [self]
 
@@ -185,7 +195,7 @@ XXX: what should be done if offloading this rule to hardware fails (for
 example, due to full capacity in hardware tables) ?
 
 Note: by default, the bridge does not filter on VLAN and only bridges untagged
-traffic.  To enable VLAN support, turn on VLAN filtering:
+traffic.  To enable VLAN support, turn on VLAN filtering::
 
 	echo 1 >/sys/class/net/<bridge>/bridge/vlan_filtering
 
@@ -194,7 +204,7 @@ Notification of Learned/Forgotten Source MAC/VLANs
 
 The switch device will learn/forget source MAC address/VLAN on ingress packets
 and notify the switch driver of the mac/vlan/port tuples.  The switch driver,
-in turn, will notify the bridge driver using the switchdev notifier call:
+in turn, will notify the bridge driver using the switchdev notifier call::
 
 	err = call_switchdev_notifiers(val, dev, info, extack);
 
@@ -202,7 +212,7 @@ Where val is SWITCHDEV_FDB_ADD when learning and SWITCHDEV_FDB_DEL when
 forgetting, and info points to a struct switchdev_notifier_fdb_info.  On
 SWITCHDEV_FDB_ADD, the bridge driver will install the FDB entry into the
 bridge's FDB and mark the entry as NTF_EXT_LEARNED.  The iproute2 bridge
-command will label these entries "offload":
+command will label these entries "offload"::
 
 	$ bridge fdb
 	52:54:00:12:35:01 dev sw1p1 master br0 permanent
@@ -219,11 +229,11 @@ command will label these entries "offload":
 	01:00:5e:00:00:01 dev br0 self permanent
 	33:33:ff:12:35:01 dev br0 self permanent
 
-Learning on the port should be disabled on the bridge using the bridge command:
+Learning on the port should be disabled on the bridge using the bridge command::
 
 	bridge link set dev DEV learning off
 
-Learning on the device port should be enabled, as well as learning_sync:
+Learning on the device port should be enabled, as well as learning_sync::
 
 	bridge link set dev DEV learning on self
 	bridge link set dev DEV learning_sync on self
@@ -314,12 +324,16 @@ forwards the packet to the matching FIB entry's nexthop(s) egress ports.
 
 To program the device, the driver has to register a FIB notifier handler
 using register_fib_notifier. The following events are available:
-FIB_EVENT_ENTRY_ADD: used for both adding a new FIB entry to the device,
-                     or modifying an existing entry on the device.
-FIB_EVENT_ENTRY_DEL: used for removing a FIB entry
-FIB_EVENT_RULE_ADD, FIB_EVENT_RULE_DEL: used to propagate FIB rule changes
 
-FIB_EVENT_ENTRY_ADD and FIB_EVENT_ENTRY_DEL events pass:
+===================  ===================================================
+FIB_EVENT_ENTRY_ADD  used for both adding a new FIB entry to the device,
+		     or modifying an existing entry on the device.
+FIB_EVENT_ENTRY_DEL  used for removing a FIB entry
+FIB_EVENT_RULE_ADD,
+FIB_EVENT_RULE_DEL   used to propagate FIB rule changes
+===================  ===================================================
+
+FIB_EVENT_ENTRY_ADD and FIB_EVENT_ENTRY_DEL events pass::
 
 	struct fib_entry_notifier_info {
 		struct fib_notifier_info info; /* must be first */
@@ -332,12 +346,12 @@ FIB_EVENT_ENTRY_ADD and FIB_EVENT_ENTRY_DEL events pass:
 		u32 nlflags;
 	};
 
-to add/modify/delete IPv4 dst/dest_len prefix on table tb_id.  The *fi
-structure holds details on the route and route's nexthops.  *dev is one of the
-port netdevs mentioned in the route's next hop list.
+to add/modify/delete IPv4 dst/dest_len prefix on table tb_id.  The ``*fi``
+structure holds details on the route and route's nexthops.  ``*dev`` is one
+of the port netdevs mentioned in the route's next hop list.
 
 Routes offloaded to the device are labeled with "offload" in the ip route
-listing:
+listing::
 
 	$ ip route show
 	default via 192.168.0.2 dev eth0
diff --git a/drivers/staging/fsl-dpaa2/ethsw/README b/drivers/staging/fsl-dpaa2/ethsw/README
index f6fc07f780d1..b48dcbf7c5fb 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/README
+++ b/drivers/staging/fsl-dpaa2/ethsw/README
@@ -79,7 +79,7 @@ The DPSW can have ports connected to DPNIs or to PHYs via DPMACs.
 
 For a more detailed description of the Ethernet switch device driver model
 see:
-	Documentation/networking/switchdev.txt
+	Documentation/networking/switchdev.rst
 
 Creating an Ethernet Switch
 ===========================
-- 
2.25.4

