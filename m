Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DAA3E43CB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhHIKWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:22:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53507 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233212AbhHIKWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1184D5C00DB;
        Mon,  9 Aug 2021 06:22:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Aug 2021 06:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uPz4aoxh3Qb/1Wdqcpnf3PJu0/wbvAPeh4adwV4N0EM=; b=oSTKdiXy
        MKyL/0PZ1j/RsXeQe7RAsNZ+htqy/pzjdAtwuxuKfx2S9GX1UKrBtSDCg1J5U/Fo
        NZZOrABPnDPIYKuMLoXrB5BhuCIJd+y51bhRlcJcHRoKca6mBpkJGImQxelfn7s1
        QAwIw2PKknGfCFVZCiofq6OKhWAgPGD/WbljTCeo3uCMkp1fgD0P6kYYohRrg5Ja
        xWM8zDQ8lqqGe+SWV0h9Rw0m1oJ4FBs/0J6QG6EyFPb05nKjYtiV1dASIL0Ihqa3
        +5P84yy7BjTSoLWEZL7N10zPAwrYPKR6W9sskHT5Opjhu7LDETflT3y4jijmbp2Q
        4oGHfiTQK4q8IQ==
X-ME-Sender: <xms:2QERYfAbUoSm1duL3tLigTTK_S1nYxsamd__3_5KeMAZDcbHsposiw>
    <xme:2QERYVihRUVwdZH0868q3aNU88NnBJkwSvNWvfHyeR2vVFC5K9E-SVQBUBPYliT-D
    xRR2bJbm9FKapM>
X-ME-Received: <xmr:2QERYakaGxIb-T8zBdoNkW9aJTZq6Lalevo_jNYSX6kZaubdWTlSa99S72Ntnr-XCeanOhAzoequ-qHs7HKGGH4Osyo7mAuWt8bO2kp4fYgKgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2QERYRycLXbN_3QTGkHgENpJR0vZvAmCkpYXkmEsV-GKcE9MJo_N4A>
    <xmx:2QERYURkwLkR3LTqAiL0YIza-7tt5lTL7d0ccgnp6r8sTXWNzsvrbw>
    <xmx:2QERYUZlltjRzNTEekTPrj2U_mDPws3_UT9LRKIrJj87Rl1uqpD9ig>
    <xmx:2gERYTFdPpHx-g3ULZLIFQ_qXenokV-a0MN7VISBkehU70dPwkuYwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/8] ethtool: Add ability to control transceiver modules' low power mode
Date:   Mon,  9 Aug 2021 13:21:45 +0300
Message-Id: <20210809102152.719961-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
modules parameters and retrieve their status.

The first parameter to control is the low power mode of the module. It
is only relevant for paged memory modules, as flat memory modules always
operate in low power mode.

When a paged memory module is in low power mode, its power consumption
is reduced to the minimum, the management interface towards the host is
available and the data path is deactivated.

User space can choose to put modules that are not currently in use in
low power mode and transition them to high power mode before putting the
associated ports administratively up.

Transitioning into low power mode means loss of carrier, so error is
returned when the netdev is administratively up.

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

The low power mode can be queried from the kernel. In case
LowPwrAllowRequestHW was on, the kernel would need to take into account
the state of the LowPwrRequestHW signal, which is not visible to user
space.

 $ ethtool --show-module swp11
 Module parameters for swp11:
 low-power false

Turn on low power mode:

 # ethtool --set-module swp11 low-power on

Query low power mode again:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 low-power true

Verify with the data read from the EEPROM:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On

Allow the module to transition out of low power mode:

 # ethtool --set-module swp11 low-power off

Query low power mode again:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 low-power false

Verify with the data read from the EEPROM:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off

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
 Transmit avg optical power (Channel 3)    : 0.7743 mW / -1.11 dBm
 Transmit avg optical power (Channel 4)    : 0.7837 mW / -1.06 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9186 mW / -0.37 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9136 mW / -0.39 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.8986 mW / -0.46 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8701 mW / -0.60 dBm

The module is not in low power mode, as it is not forced by hardware
(Power override is on) or by software (Power set is off).

The low power mode can be queried from the kernel. In case Power
override was off, the kernel would need to take into account the state
of the LPMode signal, which is not visible to user space.

 $ ethtool --show-module swp13
 Module parameters for swp13:
 low-power false

Turn on low power mode:

 # ethtool --set-module swp13 low-power on

Query low power mode again:

 $ ethtool --show-module swp13
 Module parameters for swp13:
 low-power true

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

Allow the module to transition out of low power mode:

 # ethtool --set-module swp13 low-power off

Query low power mode again:

 $ ethtool --show-module swp13
 Module parameters for swp13:
 low-power false

Verify with the data read from the EEPROM:

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) enabled
 Power set                                 : Off
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.7783 mW / -1.09 dBm
 Transmit avg optical power (Channel 2)    : 0.7806 mW / -1.08 dBm
 Transmit avg optical power (Channel 3)    : 0.7885 mW / -1.03 dBm
 Transmit avg optical power (Channel 4)    : 0.7985 mW / -0.98 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9124 mW / -0.40 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9071 mW / -0.42 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.8993 mW / -0.46 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8644 mW / -0.63 dBm

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  55 +++++-
 include/linux/ethtool.h                      |   9 +
 include/uapi/linux/ethtool_netlink.h         |  16 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/module.c                         | 184 +++++++++++++++++++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 7 files changed, 286 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/module.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c86628e6a235..07eac5bc9cfc 100644
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
@@ -1498,6 +1501,52 @@ Kernel response contents:
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
+  ``ETHTOOL_A_MODULE_LOW_POWER_ENABLED``  bool    low power mode is enabled
+  ======================================  ======  ==========================
+
+The optional ``ETHTOOL_A_MODULE_LOW_POWER_ENABLED`` attribute encodes whether
+low power mode is forced by the host.
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
+  ``ETHTOOL_A_MODULE_LOW_POWER_ENABLED``  bool    low power mode is enabled
+  ======================================  ======  ==========================
+
+When set, the optional ``ETHTOOL_A_MODULE_LOW_POWER_ENABLED`` attribute is used
+to force the module to stay in low power mode or force it back into low power
+mode. When cleared, capable modules can transition to high power mode.
+
+To avoid changes to the operational state of the device, low power mode can
+only be set when the device is administratively down.
+
+For SFF-8636 modules, low power mode is forced by the host according to table
+6-10 in revision 2.10a of the specification.
+
+For CMIS modules, low power mode is forced by the host according to table 6-12
+in revision 5.0 of the specification.
+
 Request translation
 ===================
 
@@ -1597,4 +1646,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_SET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4711b96dae0c..04286debdcdc 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -570,6 +570,10 @@ struct ethtool_module_eeprom {
  * @get_eth_ctrl_stats: Query some of the IEEE 802.3 MAC Ctrl statistics.
  * @get_rmon_stats: Query some of the RMON (RFC 2819) statistics.
  *	Set %ranges to a pointer to zero-terminated array of byte ranges.
+ * @get_module_low_power: Get the low power mode status of the plug-in module
+ *	used by the network device.
+ * @set_module_low_power: Set the low power mode status of the plug-in module
+ *	used by the network device.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -689,6 +693,11 @@ struct ethtool_ops {
 	void	(*get_rmon_stats)(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats,
 				  const struct ethtool_rmon_hist_range **ranges);
+	int	(*get_module_low_power)(struct net_device *dev,
+					bool *p_low_power,
+					struct netlink_ext_ack *extack);
+	int	(*set_module_low_power)(struct net_device *dev, bool low_power,
+					struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b93710eff7..72fb821f3928 100644
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
@@ -831,6 +835,18 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+/* MODULE */
+
+enum {
+	ETHTOOL_A_MODULE_UNSPEC,
+	ETHTOOL_A_MODULE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_LOW_POWER_ENABLED,	/* u8 */
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
index 000000000000..947f2188d725
--- /dev/null
+++ b/net/ethtool/module.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct module_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct module_reply_data {
+	struct ethnl_reply_data		base;
+	u8 low_power:1,
+	   low_power_valid:1;
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
+static int module_get_low_power(struct net_device *dev,
+				struct module_reply_data *data,
+				struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool low_power;
+	int ret;
+
+	if (!ops->get_module_low_power)
+		return 0;
+
+	ret = ops->get_module_low_power(dev, &low_power, extack);
+	if (ret < 0)
+		return ret;
+
+	data->low_power = low_power;
+	data->low_power_valid = true;
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
+	ret = module_get_low_power(dev, data, extack);
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
+	if (data->low_power_valid)
+		len += nla_total_size(sizeof(u8)); /* _MODULE_LOW_POWER_ENABLED */
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
+	if (data->low_power_valid &&
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_LOW_POWER_ENABLED,
+		       data->low_power))
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
+const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_LOW_POWER_ENABLED + 1] = {
+	[ETHTOOL_A_MODULE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MODULE_LOW_POWER_ENABLED] = NLA_POLICY_MAX(NLA_U8, 1),
+};
+
+static int module_set_low_power(struct net_device *dev, struct nlattr **tb,
+				bool *p_mod, struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool low_power_new, low_power;
+	int ret;
+
+	if (!tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED])
+		return 0;
+
+	if (!ops->get_module_low_power || !ops->set_module_low_power) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED],
+				    "Setting low power mode is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_running(dev)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED],
+				    "Cannot set low power mode when port is administratively up");
+		return -EINVAL;
+	}
+
+	low_power_new = !!nla_get_u8(tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED]);
+	ret = ops->get_module_low_power(dev, &low_power, extack);
+	if (ret < 0)
+		return ret;
+	*p_mod = low_power_new != low_power;
+
+	return ops->set_module_low_power(dev, low_power_new, extack);
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
+	ret = module_set_low_power(dev, tb, &mod, info->extack);
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
index 077aac3929a8..cf0fcbfe3c5c 100644
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
+extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_LOW_POWER_ENABLED + 1];
 
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

