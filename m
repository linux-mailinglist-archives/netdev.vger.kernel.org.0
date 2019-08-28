Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290FA9FAC4
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfH1Goh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:35206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfH1GoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443794"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 05/15] Documentation: iavf: Update the Intel LAN driver doc for iavf
Date:   Tue, 27 Aug 2019 23:43:57 -0700
Message-Id: <20190828064407.30168-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the LAN driver documentation to include the latest feature
implementation and driver capabilities.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 .../networking/device_drivers/intel/iavf.rst  | 115 +++++++++++++-----
 1 file changed, 82 insertions(+), 33 deletions(-)

diff --git a/Documentation/networking/device_drivers/intel/iavf.rst b/Documentation/networking/device_drivers/intel/iavf.rst
index 2d0c3baa1752..cfc08842e32c 100644
--- a/Documentation/networking/device_drivers/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/intel/iavf.rst
@@ -10,11 +10,15 @@ Copyright(c) 2013-2018 Intel Corporation.
 Contents
 ========
 
+- Overview
 - Identifying Your Adapter
 - Additional Configurations
 - Known Issues/Troubleshooting
 - Support
 
+Overview
+========
+
 This file describes the iavf Linux* Base Driver. This driver was formerly
 called i40evf.
 
@@ -27,6 +31,7 @@ The guest OS loading the iavf driver must support MSI-X interrupts.
 
 Identifying Your Adapter
 ========================
+
 The driver in this kernel is compatible with devices based on the following:
  * Intel(R) XL710 X710 Virtual Function
  * Intel(R) X722 Virtual Function
@@ -50,9 +55,10 @@ Link messages will not be displayed to the console if the distribution is
 restricting system messages. In order to see network driver link messages on
 your console, set dmesg to eight by entering the following::
 
-  dmesg -n 8
+    # dmesg -n 8
 
-NOTE: This setting is not saved across reboots.
+NOTE:
+  This setting is not saved across reboots.
 
 ethtool
 -------
@@ -72,11 +78,11 @@ then requests from that VF to set VLAN tag stripping will be ignored.
 To enable/disable VLAN tag stripping for a VF, issue the following command
 from inside the VM in which you are running the VF::
 
-  ethtool -K <if_name> rxvlan on/off
+    # ethtool -K <if_name> rxvlan on/off
 
 or alternatively::
 
-  ethtool --offload <if_name> rxvlan on/off
+    # ethtool --offload <if_name> rxvlan on/off
 
 Adaptive Virtual Function
 -------------------------
@@ -91,21 +97,21 @@ additional features depending on what features are available in the PF with
 which the AVF is associated. The following are base mode features:
 
 - 4 Queue Pairs (QP) and associated Configuration Status Registers (CSRs)
-  for Tx/Rx.
-- i40e descriptors and ring format.
-- Descriptor write-back completion.
-- 1 control queue, with i40e descriptors, CSRs and ring format.
-- 5 MSI-X interrupt vectors and corresponding i40e CSRs.
-- 1 Interrupt Throttle Rate (ITR) index.
-- 1 Virtual Station Interface (VSI) per VF.
+  for Tx/Rx
+- i40e descriptors and ring format
+- Descriptor write-back completion
+- 1 control queue, with i40e descriptors, CSRs and ring format
+- 5 MSI-X interrupt vectors and corresponding i40e CSRs
+- 1 Interrupt Throttle Rate (ITR) index
+- 1 Virtual Station Interface (VSI) per VF
 - 1 Traffic Class (TC), TC0
 - Receive Side Scaling (RSS) with 64 entry indirection table and key,
-  configured through the PF.
-- 1 unicast MAC address reserved per VF.
-- 16 MAC address filters for each VF.
-- Stateless offloads - non-tunneled checksums.
-- AVF device ID.
-- HW mailbox is used for VF to PF communications (including on Windows).
+  configured through the PF
+- 1 unicast MAC address reserved per VF
+- 16 MAC address filters for each VF
+- Stateless offloads - non-tunneled checksums
+- AVF device ID
+- HW mailbox is used for VF to PF communications (including on Windows)
 
 IEEE 802.1ad (QinQ) Support
 ---------------------------
@@ -117,8 +123,8 @@ VLAN ID, among other uses.
 
 The following are examples of how to configure 802.1ad (QinQ)::
 
-  ip link add link eth0 eth0.24 type vlan proto 802.1ad id 24
-  ip link add link eth0.24 eth0.24.371 type vlan proto 802.1Q id 371
+    # ip link add link eth0 eth0.24 type vlan proto 802.1ad id 24
+    # ip link add link eth0.24 eth0.24.371 type vlan proto 802.1Q id 371
 
 Where "24" and "371" are example VLAN IDs.
 
@@ -133,6 +139,19 @@ specific application. This can reduce latency for the specified application,
 and allow Tx traffic to be rate limited per application. Follow the steps below
 to set ADq.
 
+Requirements:
+
+- The sch_mqprio, act_mirred and cls_flower modules must be loaded
+- The latest version of iproute2
+- If another driver (for example, DPDK) has set cloud filters, you cannot
+  enable ADQ
+- Depending on the underlying PF device, ADQ cannot be enabled when the
+  following features are enabled:
+
+  + Data Center Bridging (DCB)
+  + Multiple Functions per Port (MFP)
+  + Sideband Filters
+
 1. Create traffic classes (TCs). Maximum of 8 TCs can be created per interface.
 The shaper bw_rlimit parameter is optional.
 
@@ -141,9 +160,9 @@ to 1Gbit for tc0 and 3Gbit for tc1.
 
 ::
 
-  # tc qdisc add dev <interface> root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
-  queues 16@0 16@16 hw 1 mode channel shaper bw_rlimit min_rate 1Gbit 2Gbit
-  max_rate 1Gbit 3Gbit
+    tc qdisc add dev <interface> root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
+    queues 16@0 16@16 hw 1 mode channel shaper bw_rlimit min_rate 1Gbit 2Gbit
+    max_rate 1Gbit 3Gbit
 
 map: priority mapping for up to 16 priorities to tcs (e.g. map 0 0 0 0 1 1 1 1
 sets priorities 0-3 to use tc0 and 4-7 to use tc1)
@@ -162,6 +181,10 @@ Totals must be equal or less than port speed.
 For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
 monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
 
+NOTE:
+  Setting up channels via ethtool (ethtool -L) is not supported when the
+  TCs are configured using mqprio.
+
 2. Enable HW TC offload on interface::
 
     # ethtool -K <interface> hw-tc-offload on
@@ -171,16 +194,16 @@ monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
     # tc qdisc add dev <interface> ingress
 
 NOTES:
- - Run all tc commands from the iproute2 <pathtoiproute2>/tc/ directory.
- - ADq is not compatible with cloud filters.
+ - Run all tc commands from the iproute2 <pathtoiproute2>/tc/ directory
+ - ADq is not compatible with cloud filters
  - Setting up channels via ethtool (ethtool -L) is not supported when the TCs
-   are configured using mqprio.
+   are configured using mqprio
  - You must have iproute2 latest version
- - NVM version 6.01 or later is required.
+ - NVM version 6.01 or later is required
  - ADq cannot be enabled when any the following features are enabled: Data
-   Center Bridging (DCB), Multiple Functions per Port (MFP), or Sideband Filters.
+   Center Bridging (DCB), Multiple Functions per Port (MFP), or Sideband Filters
  - If another driver (for example, DPDK) has set cloud filters, you cannot
-   enable ADq.
+   enable ADq
  - Tunnel filters are not supported in ADq. If encapsulated packets do arrive
    in non-tunnel mode, filtering will be done on the inner headers.  For example,
    for VXLAN traffic in non-tunnel mode, PCTYPE is identified as a VXLAN
@@ -198,6 +221,16 @@ NOTES:
 Known Issues/Troubleshooting
 ============================
 
+Bonding fails with VFs bound to an Intel(R) Ethernet Controller 700 series device
+---------------------------------------------------------------------------------
+If you bind Virtual Functions (VFs) to an Intel(R) Ethernet Controller 700
+series based device, the VF slaves may fail when they become the active slave.
+If the MAC address of the VF is set by the PF (Physical Function) of the
+device, when you add a slave, or change the active-backup slave, Linux bonding
+tries to sync the backup slave's MAC address to the same MAC address as the
+active slave. Linux bonding will fail at this point. This issue will not occur
+if the VF's MAC address is not set by the PF.
+
 Traffic Is Not Being Passed Between VM and Client
 -------------------------------------------------
 You may not be able to pass traffic between a client system and a
@@ -215,13 +248,28 @@ Do not unload a port's driver if a Virtual Function (VF) with an active Virtual
 Machine (VM) is bound to it. Doing so will cause the port to appear to hang.
 Once the VM shuts down, or otherwise releases the VF, the command will complete.
 
+Using four traffic classes fails
+--------------------------------
+Do not try to reserve more than three traffic classes in the iavf driver. Doing
+so will fail to set any traffic classes and will cause the driver to write
+errors to stdout. Use a maximum of three queues to avoid this issue.
+
+Multiple log error messages on iavf driver removal
+--------------------------------------------------
+If you have several VFs and you remove the iavf driver, several instances of
+the following log errors are written to the log::
+
+    Unable to send opcode 2 to PF, err I40E_ERR_QUEUE_EMPTY, aq_err ok
+    Unable to send the message to VF 2 aq_err 12
+    ARQ Overflow Error detected
+
 Virtual machine does not get link
 ---------------------------------
 If the virtual machine has more than one virtual port assigned to it, and those
 virtual ports are bound to different physical ports, you may not get link on
 all of the virtual ports. The following command may work around the issue::
 
-  ethtool -r <PF>
+    # ethtool -r <PF>
 
 Where <PF> is the PF interface in the host, for example: p5p1. You may need to
 run the command more than once to get link on all virtual ports.
@@ -251,12 +299,13 @@ traffic.
 If you have multiple interfaces in a server, either turn on ARP filtering by
 entering::
 
-  echo 1 > /proc/sys/net/ipv4/conf/all/arp_filter
+    # echo 1 > /proc/sys/net/ipv4/conf/all/arp_filter
 
-NOTE: This setting is not saved across reboots. The configuration change can be
-made permanent by adding the following line to the file /etc/sysctl.conf::
+NOTE:
+  This setting is not saved across reboots. The configuration change can be
+  made permanent by adding the following line to the file /etc/sysctl.conf::
 
-  net.ipv4.conf.all.arp_filter = 1
+    net.ipv4.conf.all.arp_filter = 1
 
 Another alternative is to install the interfaces in separate broadcast domains
 (either in different switches or in a switch partitioned to VLANs).
-- 
2.21.0

