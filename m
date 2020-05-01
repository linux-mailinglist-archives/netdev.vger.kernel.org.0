Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8447A1C186D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgEAOrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgEAOpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:09 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC8724968;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344306;
        bh=hkiqN/QrjAnxIafOQsAVClXlNjkAlT26dumfuuA/mHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaT/2C2eT5Pl3qhZ26SayGAwbrh7OuOzyfIeGVMiT2dwe7dgDJHdtEE5dFZJXI+2Y
         yqTdGdWj5YiscMsXqqXUzjSAVP9riTY3UcvDh3yQuv3tjQcfOAeOY94lAVVQO9HjgI
         mjAxBz59lVJ99WXCzSad5xbuMr96yd3hhBxFtPpk=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCdd-Jr; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 15/37] docs: networking: device drivers: convert aquantia/atlantic.txt to ReST
Date:   Fri,  1 May 2020 16:44:37 +0200
Message-Id: <f6d8605f322899e9fa1a71248b165e7ad3840ab7.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use copyright symbol;
- adjust title and its markup;
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../aquantia/{atlantic.txt => atlantic.rst}   | 373 +++++++++++-------
 .../networking/device_drivers/index.rst       |   1 +
 MAINTAINERS                                   |   2 +-
 3 files changed, 227 insertions(+), 149 deletions(-)
 rename Documentation/networking/device_drivers/aquantia/{atlantic.txt => atlantic.rst} (63%)

diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.txt b/Documentation/networking/device_drivers/aquantia/atlantic.rst
similarity index 63%
rename from Documentation/networking/device_drivers/aquantia/atlantic.txt
rename to Documentation/networking/device_drivers/aquantia/atlantic.rst
index 2013fcedc2da..595ddef1c8b3 100644
--- a/Documentation/networking/device_drivers/aquantia/atlantic.txt
+++ b/Documentation/networking/device_drivers/aquantia/atlantic.rst
@@ -1,83 +1,96 @@
-Marvell(Aquantia) AQtion Driver for the aQuantia Multi-Gigabit PCI Express
-Family of Ethernet Adapters
-=============================================================================
-
-Contents
-========
-
-- Identifying Your Adapter
-- Configuration
-- Supported ethtool options
-- Command Line Parameters
-- Config file parameters
-- Support
-- License
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+===============================
+Marvell(Aquantia) AQtion Driver
+===============================
+
+For the aQuantia Multi-Gigabit PCI Express Family of Ethernet Adapters
+
+.. Contents
+
+    - Identifying Your Adapter
+    - Configuration
+    - Supported ethtool options
+    - Command Line Parameters
+    - Config file parameters
+    - Support
+    - License
 
 Identifying Your Adapter
 ========================
 
-The driver in this release is compatible with AQC-100, AQC-107, AQC-108 based ethernet adapters.
+The driver in this release is compatible with AQC-100, AQC-107, AQC-108
+based ethernet adapters.
 
 
 SFP+ Devices (for AQC-100 based adapters)
-----------------------------------
+-----------------------------------------
 
-This release tested with passive Direct Attach Cables (DAC) and SFP+/LC Optical Transceiver.
+This release tested with passive Direct Attach Cables (DAC) and SFP+/LC
+Optical Transceiver.
 
 Configuration
-=========================
-  Viewing Link Messages
-  ---------------------
+=============
+
+Viewing Link Messages
+---------------------
   Link messages will not be displayed to the console if the distribution is
   restricting system messages. In order to see network driver link messages on
-  your console, set dmesg to eight by entering the following:
+  your console, set dmesg to eight by entering the following::
 
        dmesg -n 8
 
-  NOTE: This setting is not saved across reboots.
+  .. note::
 
-  Jumbo Frames
-  ------------
+     This setting is not saved across reboots.
+
+Jumbo Frames
+------------
   The driver supports Jumbo Frames for all adapters. Jumbo Frames support is
   enabled by changing the MTU to a value larger than the default of 1500.
   The maximum value for the MTU is 16000.  Use the `ip` command to
-  increase the MTU size.  For example:
+  increase the MTU size.  For example::
 
-        ip link set mtu 16000 dev enp1s0
+	ip link set mtu 16000 dev enp1s0
 
-  ethtool
-  -------
+ethtool
+-------
   The driver utilizes the ethtool interface for driver configuration and
   diagnostics, as well as displaying statistical information. The latest
   ethtool version is required for this functionality.
 
-  NAPI
-  ----
+NAPI
+----
   NAPI (Rx polling mode) is supported in the atlantic driver.
 
 Supported ethtool options
-============================
- Viewing adapter settings
- ---------------------
- ethtool <ethX>
+=========================
 
- Output example:
+Viewing adapter settings
+------------------------
+
+ ::
+
+    ethtool <ethX>
+
+ Output example::
 
   Settings for enp1s0:
     Supported ports: [ TP ]
     Supported link modes:   100baseT/Full
-                            1000baseT/Full
-                            10000baseT/Full
-                            2500baseT/Full
-                            5000baseT/Full
+			    1000baseT/Full
+			    10000baseT/Full
+			    2500baseT/Full
+			    5000baseT/Full
     Supported pause frame use: Symmetric
     Supports auto-negotiation: Yes
     Supported FEC modes: Not reported
     Advertised link modes:  100baseT/Full
-                            1000baseT/Full
-                            10000baseT/Full
-                            2500baseT/Full
-                            5000baseT/Full
+			    1000baseT/Full
+			    10000baseT/Full
+			    2500baseT/Full
+			    5000baseT/Full
     Advertised pause frame use: Symmetric
     Advertised auto-negotiation: Yes
     Advertised FEC modes: Not reported
@@ -92,16 +105,22 @@ Supported ethtool options
     Wake-on: d
     Link detected: yes
 
- ---
- Note: AQrate speeds (2.5/5 Gb/s) will be displayed only with linux kernels > 4.10.
-    But you can still use these speeds:
+
+ .. note::
+
+    AQrate speeds (2.5/5 Gb/s) will be displayed only with linux kernels > 4.10.
+    But you can still use these speeds::
+
 	ethtool -s eth0 autoneg off speed 2500
 
- Viewing adapter information
- ---------------------
- ethtool -i <ethX>
+Viewing adapter information
+---------------------------
 
- Output example:
+ ::
+
+  ethtool -i <ethX>
+
+ Output example::
 
   driver: atlantic
   version: 5.2.0-050200rc5-generic-kern
@@ -115,12 +134,16 @@ Supported ethtool options
   supports-priv-flags: no
 
 
- Viewing Ethernet adapter statistics:
- ---------------------
- ethtool -S <ethX>
+Viewing Ethernet adapter statistics
+-----------------------------------
 
- Output example:
- NIC statistics:
+ ::
+
+    ethtool -S <ethX>
+
+ Output example::
+
+  NIC statistics:
      InPackets: 13238607
      InUCast: 13293852
      InMCast: 52
@@ -164,85 +187,95 @@ Supported ethtool options
      Queue[3] InLroPackets: 0
      Queue[3] InErrors: 0
 
- Interrupt coalescing support
- ---------------------------------
- ITR mode, TX/RX coalescing timings could be viewed with:
+Interrupt coalescing support
+----------------------------
 
- ethtool -c <ethX>
+ ITR mode, TX/RX coalescing timings could be viewed with::
 
- and changed with:
+    ethtool -c <ethX>
 
- ethtool -C <ethX> tx-usecs <usecs> rx-usecs <usecs>
+ and changed with::
 
- To disable coalescing:
+    ethtool -C <ethX> tx-usecs <usecs> rx-usecs <usecs>
 
- ethtool -C <ethX> tx-usecs 0 rx-usecs 0 tx-max-frames 1 tx-max-frames 1
+ To disable coalescing::
 
- Wake on LAN support
- ---------------------------------
+    ethtool -C <ethX> tx-usecs 0 rx-usecs 0 tx-max-frames 1 tx-max-frames 1
 
- WOL support by magic packet:
+Wake on LAN support
+-------------------
 
- ethtool -s <ethX> wol g
+ WOL support by magic packet::
 
- To disable WOL:
+    ethtool -s <ethX> wol g
 
- ethtool -s <ethX> wol d
+ To disable WOL::
 
- Set and check the driver message level
- ---------------------------------
+    ethtool -s <ethX> wol d
+
+Set and check the driver message level
+--------------------------------------
 
  Set message level
 
- ethtool -s <ethX> msglvl <level>
+ ::
+
+    ethtool -s <ethX> msglvl <level>
 
  Level values:
 
- 0x0001 - general driver status.
- 0x0002 - hardware probing.
- 0x0004 - link state.
- 0x0008 - periodic status check.
- 0x0010 - interface being brought down.
- 0x0020 - interface being brought up.
- 0x0040 - receive error.
- 0x0080 - transmit error.
- 0x0200 - interrupt handling.
- 0x0400 - transmit completion.
- 0x0800 - receive completion.
- 0x1000 - packet contents.
- 0x2000 - hardware status.
- 0x4000 - Wake-on-LAN status.
+ ======   =============================
+ 0x0001   general driver status.
+ 0x0002   hardware probing.
+ 0x0004   link state.
+ 0x0008   periodic status check.
+ 0x0010   interface being brought down.
+ 0x0020   interface being brought up.
+ 0x0040   receive error.
+ 0x0080   transmit error.
+ 0x0200   interrupt handling.
+ 0x0400   transmit completion.
+ 0x0800   receive completion.
+ 0x1000   packet contents.
+ 0x2000   hardware status.
+ 0x4000   Wake-on-LAN status.
+ ======   =============================
 
  By default, the level of debugging messages is set 0x0001(general driver status).
 
  Check message level
 
- ethtool <ethX> | grep "Current message level"
+ ::
 
- If you want to disable the output of messages
+    ethtool <ethX> | grep "Current message level"
 
- ethtool -s <ethX> msglvl 0
+ If you want to disable the output of messages::
+
+    ethtool -s <ethX> msglvl 0
+
+RX flow rules (ntuple filters)
+------------------------------
 
- RX flow rules (ntuple filters)
- ---------------------------------
  There are separate rules supported, that applies in that order:
+
  1. 16 VLAN ID rules
  2. 16 L2 EtherType rules
  3. 8 L3/L4 5-Tuple rules
 
 
  The driver utilizes the ethtool interface for configuring ntuple filters,
- via "ethtool -N <device> <filter>".
+ via ``ethtool -N <device> <filter>``.
 
- To enable or disable the RX flow rules:
+ To enable or disable the RX flow rules::
 
- ethtool -K ethX ntuple <on|off>
+    ethtool -K ethX ntuple <on|off>
 
  When disabling ntuple filters, all the user programed filters are
  flushed from the driver cache and hardware. All needed filters must
  be re-added when ntuple is re-enabled.
 
  Because of the fixed order of the rules, the location of filters is also fixed:
+
  - Locations 0 - 15 for VLAN ID filters
  - Locations 16 - 31 for L2 EtherType filters
  - Locations 32 - 39 for L3/L4 5-tuple filters (locations 32, 36 for IPv6)
@@ -253,32 +286,34 @@ Supported ethtool options
  addresses can be supported. Source and destination ports are only compared for
  TCP/UDP/SCTP packets.
 
- To add a filter that directs packet to queue 5, use <-N|-U|--config-nfc|--config-ntuple> switch:
+ To add a filter that directs packet to queue 5, use
+ ``<-N|-U|--config-nfc|--config-ntuple>`` switch::
 
- ethtool -N <ethX> flow-type udp4 src-ip 10.0.0.1 dst-ip 10.0.0.2 src-port 2000 dst-port 2001 action 5 <loc 32>
+    ethtool -N <ethX> flow-type udp4 src-ip 10.0.0.1 dst-ip 10.0.0.2 src-port 2000 dst-port 2001 action 5 <loc 32>
 
  - action is the queue number.
  - loc is the rule number.
 
- For "flow-type ip4|udp4|tcp4|sctp4|ip6|udp6|tcp6|sctp6" you must set the loc
+ For ``flow-type ip4|udp4|tcp4|sctp4|ip6|udp6|tcp6|sctp6`` you must set the loc
  number within 32 - 39.
- For "flow-type ip4|udp4|tcp4|sctp4|ip6|udp6|tcp6|sctp6" you can set 8 rules
+ For ``flow-type ip4|udp4|tcp4|sctp4|ip6|udp6|tcp6|sctp6`` you can set 8 rules
  for traffic IPv4 or you can set 2 rules for traffic IPv6. Loc number traffic
  IPv6 is 32 and 36.
  At the moment you can not use IPv4 and IPv6 filters at the same time.
 
- Example filter for IPv6 filter traffic:
+ Example filter for IPv6 filter traffic::
 
- sudo ethtool -N <ethX> flow-type tcp6 src-ip 2001:db8:0:f101::1 dst-ip 2001:db8:0:f101::2 action 1 loc 32
- sudo ethtool -N <ethX> flow-type ip6 src-ip 2001:db8:0:f101::2 dst-ip 2001:db8:0:f101::5 action -1 loc 36
+    sudo ethtool -N <ethX> flow-type tcp6 src-ip 2001:db8:0:f101::1 dst-ip 2001:db8:0:f101::2 action 1 loc 32
+    sudo ethtool -N <ethX> flow-type ip6 src-ip 2001:db8:0:f101::2 dst-ip 2001:db8:0:f101::5 action -1 loc 36
 
- Example filter for IPv4 filter traffic:
+ Example filter for IPv4 filter traffic::
 
- sudo ethtool -N <ethX> flow-type udp4 src-ip 10.0.0.4 dst-ip 10.0.0.7 src-port 2000 dst-port 2001 loc 32
- sudo ethtool -N <ethX> flow-type tcp4 src-ip 10.0.0.3 dst-ip 10.0.0.9 src-port 2000 dst-port 2001 loc 33
- sudo ethtool -N <ethX> flow-type ip4 src-ip 10.0.0.6 dst-ip 10.0.0.4 loc 34
+    sudo ethtool -N <ethX> flow-type udp4 src-ip 10.0.0.4 dst-ip 10.0.0.7 src-port 2000 dst-port 2001 loc 32
+    sudo ethtool -N <ethX> flow-type tcp4 src-ip 10.0.0.3 dst-ip 10.0.0.9 src-port 2000 dst-port 2001 loc 33
+    sudo ethtool -N <ethX> flow-type ip4 src-ip 10.0.0.6 dst-ip 10.0.0.4 loc 34
 
  If you set action -1, then all traffic corresponding to the filter will be discarded.
+
  The maximum value action is 31.
 
 
@@ -287,8 +322,9 @@ Supported ethtool options
  from L2 Ethertype filter with UserPriority since both User Priority and VLAN ID
  are passed in the same 'vlan' parameter.
 
- To add a filter that directs packets from VLAN 2001 to queue 5:
- ethtool -N <ethX> flow-type ip4 vlan 2001 m 0xF000 action 1 loc 0
+ To add a filter that directs packets from VLAN 2001 to queue 5::
+
+    ethtool -N <ethX> flow-type ip4 vlan 2001 m 0xF000 action 1 loc 0
 
 
  L2 EtherType filters allows filter packet by EtherType field or both EtherType
@@ -297,17 +333,17 @@ Supported ethtool options
  distinguish VLAN filter from L2 Ethertype filter with UserPriority since both
  User Priority and VLAN ID are passed in the same 'vlan' parameter.
 
- To add a filter that directs IP4 packess of priority 3 to queue 3:
- ethtool -N <ethX> flow-type ether proto 0x800 vlan 0x600 m 0x1FFF action 3 loc 16
+ To add a filter that directs IP4 packess of priority 3 to queue 3::
 
+    ethtool -N <ethX> flow-type ether proto 0x800 vlan 0x600 m 0x1FFF action 3 loc 16
 
- To see the list of filters currently present:
+ To see the list of filters currently present::
 
- ethtool <-u|-n|--show-nfc|--show-ntuple> <ethX>
+    ethtool <-u|-n|--show-nfc|--show-ntuple> <ethX>
 
- Rules may be deleted from the table itself. This is done using:
+ Rules may be deleted from the table itself. This is done using::
 
- sudo ethtool <-N|-U|--config-nfc|--config-ntuple> <ethX> delete <loc>
+    sudo ethtool <-N|-U|--config-nfc|--config-ntuple> <ethX> delete <loc>
 
  - loc is the rule number to be deleted.
 
@@ -316,34 +352,37 @@ Supported ethtool options
  case, any flow that matches the filter criteria will be directed to the
  appropriate queue. RX filters is supported on all kernels 2.6.30 and later.
 
- RSS for UDP
- ---------------------------------
+RSS for UDP
+-----------
+
  Currently, NIC does not support RSS for fragmented IP packets, which leads to
  incorrect working of RSS for fragmented UDP traffic. To disable RSS for UDP the
  RX Flow L3/L4 rule may be used.
 
- Example:
- ethtool -N eth0 flow-type udp4 action 0 loc 32
+ Example::
+
+    ethtool -N eth0 flow-type udp4 action 0 loc 32
+
+UDP GSO hardware offload
+------------------------
 
- UDP GSO hardware offload
- ---------------------------------
  UDP GSO allows to boost UDP tx rates by offloading UDP headers allocation
  into hardware. A special userspace socket option is required for this,
- could be validated with /kernel/tools/testing/selftests/net/
+ could be validated with /kernel/tools/testing/selftests/net/::
 
     udpgso_bench_tx -u -4 -D 10.0.1.1 -s 6300 -S 100
 
  Will cause sending out of 100 byte sized UDP packets formed from single
  6300 bytes user buffer.
 
- UDP GSO is configured by:
+ UDP GSO is configured by::
 
     ethtool -K eth0 tx-udp-segmentation on
 
- Private flags (testing)
- ---------------------------------
+Private flags (testing)
+-----------------------
 
- Atlantic driver supports private flags for hardware custom features:
+ Atlantic driver supports private flags for hardware custom features::
 
 	$ ethtool --show-priv-flags ethX
 
@@ -354,7 +393,7 @@ Supported ethtool options
 	PHYInternalLoopback: off
 	PHYExternalLoopback: off
 
- Example:
+ Example::
 
 	$ ethtool --set-priv-flags ethX DMASystemLoopback on
 
@@ -370,93 +409,130 @@ Command Line Parameters
 The following command line parameters are available on atlantic driver:
 
 aq_itr -Interrupt throttling mode
-----------------------------------------
+---------------------------------
 Accepted values: 0, 1, 0xFFFF
+
 Default value: 0xFFFF
-0      - Disable interrupt throttling.
-1      - Enable interrupt throttling and use specified tx and rx rates.
-0xFFFF - Auto throttling mode. Driver will choose the best RX and TX
-         interrupt throtting settings based on link speed.
+
+======   ==============================================================
+0        Disable interrupt throttling.
+1        Enable interrupt throttling and use specified tx and rx rates.
+0xFFFF   Auto throttling mode. Driver will choose the best RX and TX
+	 interrupt throtting settings based on link speed.
+======   ==============================================================
 
 aq_itr_tx - TX interrupt throttle rate
-----------------------------------------
+--------------------------------------
+
 Accepted values: 0 - 0x1FF
+
 Default value: 0
+
 TX side throttling in microseconds. Adapter will setup maximum interrupt delay
 to this value. Minimum interrupt delay will be a half of this value
 
 aq_itr_rx - RX interrupt throttle rate
-----------------------------------------
+--------------------------------------
+
 Accepted values: 0 - 0x1FF
+
 Default value: 0
+
 RX side throttling in microseconds. Adapter will setup maximum interrupt delay
 to this value. Minimum interrupt delay will be a half of this value
 
-Note: ITR settings could be changed in runtime by ethtool -c means (see below)
+.. note::
+
+   ITR settings could be changed in runtime by ethtool -c means (see below)
 
 Config file parameters
-=======================
+======================
+
 For some fine tuning and performance optimizations,
 some parameters can be changed in the {source_dir}/aq_cfg.h file.
 
 AQ_CFG_RX_PAGEORDER
-----------------------------------------
+-------------------
+
 Default value: 0
+
 RX page order override. Thats a power of 2 number of RX pages allocated for
-each descriptor. Received descriptor size is still limited by AQ_CFG_RX_FRAME_MAX.
+each descriptor. Received descriptor size is still limited by
+AQ_CFG_RX_FRAME_MAX.
+
 Increasing pageorder makes page reuse better (actual on iommu enabled systems).
 
 AQ_CFG_RX_REFILL_THRES
-----------------------------------------
+----------------------
+
 Default value: 32
+
 RX refill threshold. RX path will not refill freed descriptors until the
 specified number of free descriptors is observed. Larger values may help
 better page reuse but may lead to packet drops as well.
 
 AQ_CFG_VECS_DEF
-------------------------------------------------------------
+---------------
+
 Number of queues
+
 Valid Range: 0 - 8 (up to AQ_CFG_VECS_MAX)
+
 Default value: 8
+
 Notice this value will be capped by the number of cores available on the system.
 
 AQ_CFG_IS_RSS_DEF
-------------------------------------------------------------
+-----------------
+
 Enable/disable Receive Side Scaling
 
 This feature allows the adapter to distribute receive processing
 across multiple CPU-cores and to prevent from overloading a single CPU core.
 
 Valid values
-0 - disabled
-1 - enabled
+
+==  ========
+0   disabled
+1   enabled
+==  ========
 
 Default value: 1
 
 AQ_CFG_NUM_RSS_QUEUES_DEF
-------------------------------------------------------------
+-------------------------
+
 Number of queues for Receive Side Scaling
+
 Valid Range: 0 - 8 (up to AQ_CFG_VECS_DEF)
 
 Default value: AQ_CFG_VECS_DEF
 
 AQ_CFG_IS_LRO_DEF
-------------------------------------------------------------
+-----------------
+
 Enable/disable Large Receive Offload
 
 This offload enables the adapter to coalesce multiple TCP segments and indicate
 them as a single coalesced unit to the OS networking subsystem.
-The system consumes less energy but it also introduces more latency in packets processing.
+
+The system consumes less energy but it also introduces more latency in packets
+processing.
 
 Valid values
-0 - disabled
-1 - enabled
+
+==  ========
+0   disabled
+1   enabled
+==  ========
 
 Default value: 1
 
 AQ_CFG_TX_CLEAN_BUDGET
-----------------------------------------
+----------------------
+
 Maximum descriptors to cleanup on TX at once.
+
 Default value: 256
 
 After the aq_cfg.h file changed the driver must be rebuilt to take effect.
@@ -472,7 +548,8 @@ License
 =======
 
 aQuantia Corporation Network Driver
-Copyright(c) 2014 - 2019 aQuantia Corporation.
+
+Copyright |copy| 2014 - 2019 aQuantia Corporation.
 
 This program is free software; you can redistribute it and/or modify it
 under the terms and conditions of the GNU General Public License,
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 019a0d2efe67..7dde314fc957 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -30,6 +30,7 @@ Contents:
    3com/3c509
    3com/vortex
    amazon/ena
+   aquantia/atlantic
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 990d1414ffd6..91098b704635 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1280,7 +1280,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 W:	https://www.marvell.com/
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
-F:	Documentation/networking/device_drivers/aquantia/atlantic.txt
+F:	Documentation/networking/device_drivers/aquantia/atlantic.rst
 F:	drivers/net/ethernet/aquantia/atlantic/
 
 AQUANTIA ETHERNET DRIVER PTP SUBSYSTEM
-- 
2.25.4

