Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E2D102F21
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfKSWU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:20:28 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56470 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbfKSWT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:57 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJocx059817;
        Tue, 19 Nov 2019 16:19:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201990;
        bh=vdo8c+BrXUD51Y2Gd1dd7mJVDNfc2hxqGO27y13aOhk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vIsPSqiOqD0ZMWbu6YnGtLbc3P5jN2giMaTO1MCNhviMofsATXEKDKtT7w+hSUgTP
         ATchQ4vJb8En2LaBVwZjOIXbnm1GRBG+XcLwuk43gA1xTgXqmDvpiI9nxxz7nImfyW
         FCM/uMWXRWB2YIP7d4x9+kC7pe099qzh/3YtbZr0=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJoBO018056
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:50 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:49 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:50 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJnHj055258;
        Tue, 19 Nov 2019 16:19:49 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v7 net-next 10/13] Documentation: networking: add cpsw switchdev based driver documentation
Date:   Wed, 20 Nov 2019 00:19:22 +0200
Message-ID: <20191119221925.28426-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

A new cpsw dirver based on switchdev was added. Add documentation about
basic configuration and future features

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../device_drivers/ti/cpsw_switchdev.txt      | 210 ++++++++++++++++++
 .../devlink-params-ti-cpsw-switch.txt         |  10 +
 2 files changed, 220 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
 create mode 100644 Documentation/networking/devlink-params-ti-cpsw-switch.txt

diff --git a/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt b/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
new file mode 100644
index 000000000000..ba1112f383f0
--- /dev/null
+++ b/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
@@ -0,0 +1,210 @@
+* Texas Instruments CPSW switchdev based ethernet driver 2.0
+
+- Port renaming
+On older udev versions renaming of ethX to swXpY will not be automatically
+supported
+In order to rename via udev:
+ip -d link show dev sw0p1 | grep switchid
+
+SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}==<switchid>, \
+        ATTR{phys_port_name}!="", NAME="sw0$attr{phys_port_name}"
+
+
+====================
+# Dual mac mode
+====================
+- The new (cpsw_new.c) driver is operating in dual-emac mode by default, thus
+working as 2 individual network interfaces. Main differences from legacy CPSW
+driver are:
+ - optimized promiscuous mode: The P0_UNI_FLOOD (both ports) is enabled in
+addition to ALLMULTI (current port) instead of ALE_BYPASS.
+So, Ports in promiscuous mode will keep possibility of mcast and vlan filtering,
+which is provides significant benefits when ports are joined to the same bridge,
+but without enabling "switch" mode, or to different bridges.
+ - learning disabled on ports as it make not too much sense for
+   segregated ports - no forwarding in HW.
+ - enabled basic support for devlink.
+
+	devlink dev show
+		platform/48484000.switch
+
+	devlink dev param show
+	platform/48484000.switch:
+	name switch_mode type driver-specific
+	values:
+		cmode runtime value false
+	name ale_bypass type driver-specific
+	values:
+		cmode runtime value false
+
+Devlink configuration parameters
+====================
+See Documentation/networking/devlink-params-ti-cpsw-switch.txt
+
+====================
+# Bridging in dual mac mode
+====================
+The dual_mac mode requires two vids to be reserved for internal purposes,
+which, by default, equal CPSW Port numbers. As result, bridge has to be
+configured in vlan unaware mode or default_pvid has to be adjusted.
+
+	ip link add name br0 type bridge
+	ip link set dev br0 type bridge vlan_filtering 0
+	echo 0 > /sys/class/net/br0/bridge/default_pvid
+	ip link set dev sw0p1 master br0
+	ip link set dev sw0p2 master br0
+ - or -
+	ip link add name br0 type bridge
+	ip link set dev br0 type bridge vlan_filtering 0
+	echo 100 > /sys/class/net/br0/bridge/default_pvid
+	ip link set dev br0 type bridge vlan_filtering 1
+	ip link set dev sw0p1 master br0
+	ip link set dev sw0p2 master br0
+
+====================
+# Enabling "switch"
+====================
+The Switch mode can be enabled by configuring devlink driver parameter
+"switch_mode" to 1/true:
+	devlink dev param set platform/48484000.switch \
+	name switch_mode value 1 cmode runtime
+
+This can be done regardless of the state of Port's netdev devices - UP/DOWN, but
+Port's netdev devices have to be in UP before joining to the bridge to avoid
+overwriting of bridge configuration as CPSW switch driver copletly reloads its
+configuration when first Port changes its state to UP.
+
+When the both interfaces joined the bridge - CPSW switch driver will enable
+marking packets with offload_fwd_mark flag unless "ale_bypass=0"
+
+All configuration is implemented via switchdev API.
+
+====================
+# Bridge setup
+====================
+	devlink dev param set platform/48484000.switch \
+	name switch_mode value 1 cmode runtime
+
+	ip link add name br0 type bridge
+	ip link set dev br0 type bridge ageing_time 1000
+	ip link set dev sw0p1 up
+	ip link set dev sw0p2 up
+	ip link set dev sw0p1 master br0
+	ip link set dev sw0p2 master br0
+	[*] bridge vlan add dev br0 vid 1 pvid untagged self
+
+[*] if vlan_filtering=1. where default_pvid=1
+
+=================
+# On/off STP
+=================
+ip link set dev BRDEV type bridge stp_state 1/0
+
+Note. Steps [*] are mandatory.
+
+====================
+# VLAN configuration
+====================
+bridge vlan add dev br0 vid 1 pvid untagged self <---- add cpu port to VLAN 1
+
+Note. This step is mandatory for bridge/default_pvid.
+
+=================
+# Add extra VLANs
+=================
+ 1. untagged:
+    bridge vlan add dev sw0p1 vid 100 pvid untagged master
+    bridge vlan add dev sw0p2 vid 100 pvid untagged master
+    bridge vlan add dev br0 vid 100 pvid untagged self <---- Add cpu port to VLAN100
+
+ 2. tagged:
+    bridge vlan add dev sw0p1 vid 100 master
+    bridge vlan add dev sw0p2 vid 100 master
+    bridge vlan add dev br0 vid 100 pvid tagged self <---- Add cpu port to VLAN100
+
+====
+FDBs
+====
+FDBs are automatically added on the appropriate switch port upon detection
+
+Manually adding FDBs:
+bridge fdb add aa:bb:cc:dd:ee:ff dev sw0p1 master vlan 100
+bridge fdb add aa:bb:cc:dd:ee:fe dev sw0p2 master <---- Add on all VLANs
+
+====
+MDBs
+====
+MDBs are automatically added on the appropriate switch port upon detection
+
+Manually adding MDBs:
+bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent vid 100
+bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent <---- Add on all VLANs
+
+==================
+Multicast flooding
+==================
+CPU port mcast_flooding is always on
+
+Turning flooding on/off on swithch ports:
+bridge link set dev sw0p1 mcast_flood on/off
+
+==================
+Access and Trunk port
+==================
+ bridge vlan add dev sw0p1 vid 100 pvid untagged master
+ bridge vlan add dev sw0p2 vid 100 master
+
+
+ bridge vlan add dev br0 vid 100 self
+ ip link add link br0 name br0.100 type vlan id 100
+
+ Note. Setting PVID on Bridge device itself working only for
+ default VLAN (default_pvid).
+
+=====================
+ NFS
+=====================
+The only way for NFS to work is by chrooting to a minimal environment when
+switch configuration that will affect connectivity is needed.
+Assuming you are booting NFS with eth1 interface(the script is hacky and
+it's just there to prove NFS is doable).
+
+setup.sh:
+#!/bin/sh
+mkdir proc
+mount -t proc none /proc
+ifconfig br0  > /dev/null
+if [ $? -ne 0 ]; then
+        echo "Setting up bridge"
+        ip link add name br0 type bridge
+        ip link set dev br0 type bridge ageing_time 1000
+        ip link set dev br0 type bridge vlan_filtering 1
+
+        ip link set eth1 down
+        ip link set eth1 name sw0p1
+        ip link set dev sw0p1 up
+        ip link set dev sw0p2 up
+        ip link set dev sw0p2 master br0
+        ip link set dev sw0p1 master br0
+        bridge vlan add dev br0 vid 1 pvid untagged self
+        ifconfig sw0p1 0.0.0.0
+        udhchc -i br0
+fi
+umount /proc
+
+run_nfs.sh:
+#!/bin/sh
+mkdir /tmp/root/bin -p
+mkdir /tmp/root/lib -p
+
+cp -r /lib/ /tmp/root/
+cp -r /bin/ /tmp/root/
+cp /sbin/ip /tmp/root/bin
+cp /sbin/bridge /tmp/root/bin
+cp /sbin/ifconfig /tmp/root/bin
+cp /sbin/udhcpc /tmp/root/bin
+cp /path/to/setup.sh /tmp/root/bin
+chroot /tmp/root/ busybox sh /bin/setup.sh
+
+run ./run_nfs.sh
+
diff --git a/Documentation/networking/devlink-params-ti-cpsw-switch.txt b/Documentation/networking/devlink-params-ti-cpsw-switch.txt
new file mode 100644
index 000000000000..4037458499f7
--- /dev/null
+++ b/Documentation/networking/devlink-params-ti-cpsw-switch.txt
@@ -0,0 +1,10 @@
+ale_bypass	[DEVICE, DRIVER-SPECIFIC]
+		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes.
+		All packets will be sent to the Host port only if enabled.
+		Type: bool
+		Configuration mode: runtime
+
+switch_mode	[DEVICE, DRIVER-SPECIFIC]
+		Enable switch mode
+		Type: bool
+		Configuration mode: runtime
-- 
2.17.1

