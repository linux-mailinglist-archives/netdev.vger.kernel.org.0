Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17BD3F0875
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhHRPxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:16 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:52935 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240066AbhHRPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:15 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A00BF582FDE;
        Wed, 18 Aug 2021 11:52:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 18 Aug 2021 11:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OLw5cxi/q073jZovZozsKO7FdoVh9gVo3gqPJpMVwdo=; b=PqOS7lgh
        tusHXzI/4K9f2Dm6qza+OzACratcsuXJQsoul6AYMefO6ynN3+oDEwOuUOohWQ6r
        g7xznr0FdZPAAolbnUsWXoGaAqRCGl1AWbfRDdnJtQp48g1DGZZn8WeaQ8IchqJB
        kzZWygaTF0AsBQJW+7C5z97dlciIYiex0YKklEUkkd7EAhDBGm4j/eYa9yFHQuZZ
        bYuOFV0n4Qj/HD2OX76Wfq1tHXhkWQkdXqKSLcxIW78n93KVwc2aTLJ32JJg7ki8
        c+l2GkVwBa51SnXLudJxx/rgiCgTJI+cZiJyYk+GALJdlGKmYtwWZ72QtmGyx6kC
        EX9PWX/iOPH9zg==
X-ME-Sender: <xms:yCwdYfcPpg6rJWGFxPeXJQmOttedAbjt2QNXtJvsxO1pheOh_caO8w>
    <xme:yCwdYVPStqB40hsz7DWYcavxWjeql66wtPKBWOKQOk1VdQQHILilNcQj4dz8LzCXH
    i0zMpMSiIfZhRc>
X-ME-Received: <xmr:yCwdYYh3soTi1RAUN3ccDQBomItWVVxFT_q8t9y4eT-Jg3oHAESwhZLSCGmjoj5ooYcxodjNGPAnZjKmG0ktVC6sbO5mNfdu7Jay1NhVmoFWqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yCwdYQ-BpD0baZ2ctuRiKvO7HFteeinTtz8KDAg2co2qv3VBBXvx-Q>
    <xmx:yCwdYbsxFkMQkmUqi0oLW1EbqF_Wo0Dfbk3x0p4xDmVvLpfmhmVEyA>
    <xmx:yCwdYfHKawS3qHlewrmxD-PUkqg6BmwoKIAWbacLVXhqX6VLpNhrPw>
    <xmx:yCwdYRBSjncOVda-Okk7PS9Mq3C9tRjW7VcDeR56Uq1mp7BW0xvk0w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Wed, 18 Aug 2021 18:51:57 +0300
Message-Id: <20210818155202.1278177-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
modules parameters and retrieve their status.

The first parameter to control is the power mode of the module. It is
only relevant for paged memory modules, as flat memory modules always
operate in low power mode.

When a paged memory module is in low power mode, its power consumption
is reduced to the minimum, the management interface towards the host is
available and the data path is deactivated.

User space can choose to put modules that are not currently in use in
low power mode and transition them to high power mode before putting the
associated ports administratively up. This is useful for user space that
favors reduced power consumption and lower temperatures over reduced
link up times. In QSFP-DD modules the transition from low power mode to
high power mode can take a few seconds and this transition is only
expected to get longer with future / more complex modules.

User space can control the power mode of the module via the power mode
policy attribute ('ETHTOOL_A_MODULE_POWER_MODE_POLICY'). Possible
values:

* low: Module is always in low power mode.

* high: Module is always in high power mode.

* high-on-up: Module is transitioned by the host to high power mode when
  the first port using it is put administratively up and to low power
  mode when the last port using it is put administratively down.

The operational power mode of the module is available to user space via
the 'ETHTOOL_A_MODULE_POWER_MODE' attribute. The attribute is not
reported to user space when a module is not plugged-in.

Transitioning into low power mode means loss of carrier, so an error is
returned when the port is administratively up.

The user API is designed to be generic enough so that it could be used
for modules with different memory maps (e.g., SFF-8636, CMIS).

The only implementation of the device driver API in this series is for a
MAC driver (mlxsw) where the module is controlled by the device's
firmware, but it is designed to be generic enough so that it could also
be used by implementations where the module is controlled by the CPU.

CMIS testing
============

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off

The module is not in low power mode, as it is not forced by hardware
(LowPwrAllowRequestHW is off) or by software (LowPwrRequestSW is off).

The power mode can be queried from the kernel. In case
LowPwrAllowRequestHW was on, the kernel would need to take into account
the state of the LowPwrRequestHW signal, which is not visible to user
space.

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy high
 power-mode high

Change the power mode policy to 'high-on-up':

 # ethtool --set-module swp11 power-mode-policy high-on-up

Query the power mode again:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy high-on-up
 power-mode low

Verify with the data read from the EEPROM:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On

Put the associated port administratively up which will instruct the host
to transition the module to high power mode:

 # ip link set dev swp11 up

Query the power mode again:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy high-on-up
 power-mode high

Verify with the data read from the EEPROM:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off

Put the associated port administratively down which will instruct the
host to transition the module to low power mode:

 # ip link set dev swp11 down

Query the power mode again:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy high-on-up
 power-mode low

Verify with the data read from the EEPROM:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On

SFF-8636 testing
================

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) enabled
 Power set                                 : Off
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.7733 mW / -1.12 dBm
 Transmit avg optical power (Channel 2)    : 0.7649 mW / -1.16 dBm
 Transmit avg optical power (Channel 3)    : 0.7790 mW / -1.08 dBm
 Transmit avg optical power (Channel 4)    : 0.7837 mW / -1.06 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9302 mW / -0.31 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9079 mW / -0.42 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.8993 mW / -0.46 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8778 mW / -0.57 dBm

The module is not in low power mode, as it is not forced by hardware
(Power override is on) or by software (Power set is off).

The power mode can be queried from the kernel. In case Power override
was off, the kernel would need to take into account the state of the
LPMode signal, which is not visible to user space.

 $ ethtool --show-module swp13
 Module parameters for swp13:
 power-mode-policy high
 power-mode high

Change the power mode policy to 'high-on-up':

 # ethtool --set-module swp13 power-mode-policy high-on-up

Query the power mode again:

 $ ethtool --show-module swp13
 Module parameters for swp13:
 power-mode-policy high-on-up
 power-mode low

Verify with the data read from the EEPROM:

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) not enabled
 Power set                                 : On
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 2)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 3)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 4)    : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 1)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 2)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 3)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 4)  : 0.0000 mW / -inf dBm

Put the associated port administratively up which will instruct the host
to transition the module to high power mode:

 # ip link set dev swp13 up

Query the power mode again:

 $ ethtool --show-module swp13
 Module parameters for swp13:
 power-mode-policy high-on-up
 power-mode high

Verify with the data read from the EEPROM:

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) enabled
 Power set                                 : Off
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.7934 mW / -1.01 dBm
 Transmit avg optical power (Channel 2)    : 0.7859 mW / -1.05 dBm
 Transmit avg optical power (Channel 3)    : 0.7885 mW / -1.03 dBm
 Transmit avg optical power (Channel 4)    : 0.7985 mW / -0.98 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9325 mW / -0.30 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9034 mW / -0.44 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.9086 mW / -0.42 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8885 mW / -0.51 dBm

Put the associated port administratively down which will instruct the
host to transition the module to low power mode:

 # ip link set dev swp13 down

Query the power mode again:

 $ ethtool --show-module swp13
 Module parameters for swp13:
 power-mode-policy high-on-up
 power-mode low

Verify with the data read from the EEPROM:

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) not enabled
 Power set                                 : On
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 2)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 3)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 4)    : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 1)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 2)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 3)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 4)  : 0.0000 mW / -inf dBm

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  66 ++++++-
 include/linux/ethtool.h                      |  25 +++
 include/uapi/linux/ethtool.h                 |  25 +++
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/module.c                         | 191 +++++++++++++++++++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 8 files changed, 346 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/module.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c86628e6a235..54a704370bfc 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -179,7 +179,7 @@ according to message purpose:
 
 Userspace to kernel:
 
-  ===================================== ================================
+  ===================================== =================================
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
@@ -213,7 +213,9 @@ Userspace to kernel:
   ``ETHTOOL_MSG_MODULE_EEPROM_GET``     read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET``             get standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
-  ===================================== ================================
+  ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
+  ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
+  ===================================== =================================
 
 Kernel to userspace:
 
@@ -252,6 +254,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
+  ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1498,6 +1501,63 @@ Kernel response contents:
   ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
   ====================================  ======  ==========================
 
+MODULE_GET
+==========
+
+Gets transceiver module parameters.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_HEADER``            nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_HEADER``             nested  reply header
+  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
+  ``ETHTOOL_A_MODULE_POWER_MODE``         u8      operational power mode
+  ======================================  ======  ==========================
+
+The optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute encodes the
+transceiver module power mode policy enforced by the host.
+
+The optional ``ETHTHOOL_A_MODULE_POWER_MODE`` attribute encodes the operational
+power mode policy of the transceiver module. It is only reported when a module
+is plugged-in. Possible values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_module_power_mode
+
+MODULE_SET
+==========
+
+Sets transceiver module parameters.
+
+Request contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
+  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
+  ======================================  ======  ==========================
+
+When set, the optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute is used
+to set the transceiver module power policy enforced by the host. Possible
+values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_module_power_mode_policy
+
+For SFF-8636 modules, low power mode is forced by the host according to table
+6-10 in revision 2.10a of the specification.
+
+For CMIS modules, low power mode is forced by the host according to table 6-12
+in revision 5.0 of the specification.
+
+To avoid changes to the operational state of the device, power mode policy can
+only be set when the device is administratively down.
+
 Request translation
 ===================
 
@@ -1597,4 +1657,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_SET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4711b96dae0c..07d40dc20ca4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -405,6 +405,20 @@ struct ethtool_module_eeprom {
 	u8	*data;
 };
 
+/**
+ * struct ethtool_module_power_mode_params - module power mode parameters
+ * @policy: The power mode policy enforced by the host for the plug-in module.
+ * @mode: The operational power mode of the plug-in module. Should be filled by
+ * device drivers on get operations.
+ * @mode_valid: Indicates the validity of the @mode field. Should be set by
+ * device drivers on get operations when a module is plugged-in.
+ */
+struct ethtool_module_power_mode_params {
+	enum ethtool_module_power_mode_policy policy;
+	enum ethtool_module_power_mode mode;
+	u8 mode_valid:1;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -570,6 +584,11 @@ struct ethtool_module_eeprom {
  * @get_eth_ctrl_stats: Query some of the IEEE 802.3 MAC Ctrl statistics.
  * @get_rmon_stats: Query some of the RMON (RFC 2819) statistics.
  *	Set %ranges to a pointer to zero-terminated array of byte ranges.
+ * @get_module_power_mode: Get the power mode policy for the plug-in module
+ *	used by the network device and its operational power mode, if
+ *	plugged-in.
+ * @set_module_power_mode: Set the power mode policy for the plug-in module
+ *	used by the network device.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -689,6 +708,12 @@ struct ethtool_ops {
 	void	(*get_rmon_stats)(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats,
 				  const struct ethtool_rmon_hist_range **ranges);
+	int	(*get_module_power_mode)(struct net_device *dev,
+					 struct ethtool_module_power_mode_params *params,
+					 struct netlink_ext_ack *extack);
+	int	(*set_module_power_mode)(struct net_device *dev,
+					 const struct ethtool_module_power_mode_params *params,
+					 struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 67aa7134b301..0a52ee560c3a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -704,6 +704,31 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_module_power_mode_policy - plug-in module power mode policy
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
+ *	host to high power mode when the first port using it is put
+ *	administratively up and to low power mode when the last port using it
+ *	is put administratively down.
+ */
+enum ethtool_module_power_mode_policy {
+	ETHTOOL_MODULE_POWER_MODE_POLICY_LOW,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP,
+};
+
+/**
+ * enum ethtool_module_power_mode - plug-in module power mode
+ * @ETHTOOL_MODULE_POWER_MODE_LOW: Module is in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
+ */
+enum ethtool_module_power_mode {
+	ETHTOOL_MODULE_POWER_MODE_LOW,
+	ETHTOOL_MODULE_POWER_MODE_HIGH,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b93710eff7..c22f5c902060 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -47,6 +47,8 @@ enum {
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
+	ETHTOOL_MSG_MODULE_GET,
+	ETHTOOL_MSG_MODULE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -90,6 +92,8 @@ enum {
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_GET_REPLY,
+	ETHTOOL_MSG_MODULE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -831,6 +835,19 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+/* MODULE */
+
+enum {
+	ETHTOOL_A_MODULE_UNSPEC,
+	ETHTOOL_A_MODULE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_POWER_MODE_POLICY,	/* u8 */
+	ETHTOOL_A_MODULE_POWER_MODE,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MODULE_CNT,
+	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 0a19470efbfb..b76432e70e6b 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
new file mode 100644
index 000000000000..6fb7d84fabf7
--- /dev/null
+++ b/net/ethtool/module.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct module_req_info {
+	struct ethnl_req_info base;
+};
+
+struct module_reply_data {
+	struct ethnl_reply_data	base;
+	struct ethtool_module_power_mode_params power;
+	u8 power_valid:1;
+};
+
+#define MODULE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct module_reply_data, base)
+
+/* MODULE_GET */
+
+const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1] = {
+	[ETHTOOL_A_MODULE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int module_get_power_mode(struct net_device *dev,
+				 struct module_reply_data *data,
+				 struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int ret;
+
+	if (!ops->get_module_power_mode)
+		return 0;
+
+	ret = ops->get_module_power_mode(dev, &data->power, extack);
+	if (ret < 0)
+		return ret;
+
+	data->power_valid = true;
+
+	return 0;
+}
+
+static int module_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct module_reply_data *data = MODULE_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = module_get_power_mode(dev, data, extack);
+	if (ret < 0)
+		goto out_complete;
+
+out_complete:
+	ethnl_ops_complete(dev);
+	return ret;
+}
+
+static int module_reply_size(const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	struct module_reply_data *data = MODULE_REPDATA(reply_base);
+	int len = 0;
+
+	if (data->power_valid)
+		len += nla_total_size(sizeof(u8));	/* _MODULE_POWER_MODE_POLICY */
+
+	if (data->power_valid && data->power.mode_valid)
+		len += nla_total_size(sizeof(u8));	/* _MODULE_POWER_MODE */
+
+	return len;
+}
+
+static int module_fill_reply(struct sk_buff *skb,
+			     const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct module_reply_data *data = MODULE_REPDATA(reply_base);
+
+	if (data->power_valid &&
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_POWER_MODE_POLICY,
+		       data->power.policy))
+		return -EMSGSIZE;
+
+	if (data->power_valid && data->power.mode_valid &&
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_POWER_MODE, data->power.mode))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_module_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MODULE_GET,
+	.reply_cmd		= ETHTOOL_MSG_MODULE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MODULE_HEADER,
+	.req_info_size		= sizeof(struct module_req_info),
+	.reply_data_size	= sizeof(struct module_reply_data),
+
+	.prepare_data		= module_prepare_data,
+	.reply_size		= module_reply_size,
+	.fill_reply		= module_fill_reply,
+};
+
+/* MODULE_SET */
+
+const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1] = {
+	[ETHTOOL_A_MODULE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MODULE_POWER_MODE_POLICY] =
+		NLA_POLICY_MAX(NLA_U8, ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP),
+};
+
+static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,
+				 bool *p_mod, struct netlink_ext_ack *extack)
+{
+	struct ethtool_module_power_mode_params power = {};
+	struct ethtool_module_power_mode_params power_new;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int ret;
+
+	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
+		return 0;
+
+	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
+				    "Setting power mode policy is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_running(dev)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
+				    "Cannot set power mode policy when port is administratively up");
+		return -EINVAL;
+	}
+
+	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
+	ret = ops->get_module_power_mode(dev, &power, extack);
+	if (ret < 0)
+		return ret;
+	*p_mod = power_new.policy != power.policy;
+
+	return ops->set_module_power_mode(dev, &power_new, extack);
+}
+
+int ethnl_set_module(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MODULE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = module_set_power_mode(dev, tb, &mod, info->extack);
+	if (ret < 0)
+		goto out_ops;
+
+	if (!mod)
+		goto out_ops;
+
+	ethtool_notify(dev, ETHTOOL_MSG_MODULE_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1797a0a90019..38b44c0291b1 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -282,6 +282,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
+	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -593,6 +594,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
+	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
 };
 
 /* default notification handler */
@@ -686,6 +688,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -999,6 +1002,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_phc_vclocks_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_phc_vclocks_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_module_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_module,
+		.policy = ethnl_module_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 077aac3929a8..1aafba5b67bb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -337,6 +337,7 @@ extern const struct ethnl_request_ops ethnl_fec_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
+extern const struct ethnl_request_ops ethnl_module_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -373,6 +374,8 @@ extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
+extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
+extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -391,6 +394,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.31.1

