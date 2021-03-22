Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6E0344CED
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhCVRMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:47 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:7069
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230334AbhCVRLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVUKy0iT51Kydd4vx3afQ+VvVuvlbhVQVFCcxYdVbZ4fdc1lRpo9P/vappmiPJTUedzut24eWlQF42sF0poUt3ecZCgbYoWUoqxiCFkB2UvhTVZHqch55wK1kIR09g9NJZxr2oc1PBnSwNcugzo8XCOalAjcDGcQ9pelPDmG6xrz5CSHvQ1LYU+bfC/1FbtwjK4ZDO7oxNVtszMkFmzMJDSWrCkY2S4rM8+v+IBntZBAdUeEOEfIn0fZehDR8ZX5lgCiQPykNbJk8Y4tfrkWmhzpIK5gjcW+6XxdP875VpoKvfAhpcLGfeRSRUfd5nDy+I4c2Ik/Z1U+iKLUAyDp9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIyLDrOGmh7+GExun7HKWUTTE6/x4GaZnNLnP4C4eVA=;
 b=ga6d5DQcHLiqnpRSk+a+H0TfXo4scvZpzwRkd/1HbOg5aZ1+yjZRiy1e7EwGUF6EfSy4N78YHSjWXvqnSA9qnfmVEduFi1jCs4d6jtNYHUGX8wDIwYTQIe7fzPSjHGFAmQF8qMavP67GYQekKFH/RklZavyuA5gVemnb5vAGMStUERgdpTwTW1FCya/WHBc3nUxfpIOjB6dlcSm7+XvZe/XG599B/I65VYtIxHXUmMymKGkluXdD8xFlBETcQ7VsJNF2qVPK8LZI3ofD7kjJHeSCc6R2+skjvKCSVnYweKR9ZlUOKI+z8K3ZquxCN8g0/TYLbWcxPfFfg8/fWMUl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIyLDrOGmh7+GExun7HKWUTTE6/x4GaZnNLnP4C4eVA=;
 b=bRB0BhjYp3GvcGsIPwkGazNlBfArUriQKh3q1l4FJ6O+f71cFGpc8ZuOUpKl+s+eiXb9rvPhBBPWZUsE77/mW+VGBc6ms+ZvVQaJ47p6ZOQlFlBUnSrKUm+UZlV/Ihb6QtFkfDtNvtb28tl4Y0xINGiflG6CPBrynCTHy6QTNn79QWyQPXLzFweWwQr1MirKQNK/a0XUZapIooqSxtkJ+dquzqC07iyBxWUsl54Klcr58zsklA9cpoyQE01d7oyEcrLSA15YREVPj+Y9oPkx8S0gCCb2vDOXeHBrcJpwW5mScToe7uUJPCCbciHjL75ft/n4Cgqm5nw8da0mzpddQg==
Received: from MW4PR04CA0226.namprd04.prod.outlook.com (2603:10b6:303:87::21)
 by MN2PR12MB2861.namprd12.prod.outlook.com (2603:10b6:208:af::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Mon, 22 Mar
 2021 17:11:35 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::d0) by MW4PR04CA0226.outlook.office365.com
 (2603:10b6:303:87::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:34 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 10:11:34 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:32 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Mon, 22 Mar 2021 19:11:11 +0200
Message-ID: <1616433075-27051-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe0654ee-0e2d-4f2c-0251-08d8ed558beb
X-MS-TrafficTypeDiagnostic: MN2PR12MB2861:
X-Microsoft-Antispam-PRVS: <MN2PR12MB286179AF0D793755B0C3985CD4659@MN2PR12MB2861.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: diAnoarO1KDYIS7OTHL8wyV5tqDRx3BfoNGX6D2Yu6a+ThWfCKcn+qhwn2T1Xu1fD1kgdz4Tvm+SJWeeodogL99SvBsfcefG3eak37aKXZndZ2fNQNEu+prNTxANB6c73WcC/VQbyUXdg9sqY/3zPKqnWpCfAXac4KxYtyuYe0A7Jm22peFUOOelfvk7oZ2I65mwEUVpWJh4+9B2odiRpiQFkn0QrxqSD4zodh/F1CKWSuzKbarQcuAxkx0VBmFbZRGhmSSe7ICrOJo7fjIAPm9fhjKK5WgfhWX1+IbrxZ4A90zyXMulaLy7vaEh1/FXL18kt1my0vpR8kSpmVMDGY4Cr6ftKi5jxANOwpcXgAkv0ixdApsO8JIBDv+nFDYnKtxoIFI6OlB1e9jLnwNMMKLnMqXFAWjduYdBWb4tTf4/Yb0cSDcmYuLQfpozF8tUrBADNQLnOPjMRye6Y0xQKhpXIjiS7+s1D4WunHYIjth//51T53wKDHDT5B+QuvjFDt7hEOg2k7MnVX0R5GcY3gFTA1sSwekmdOIZQdtLh6z2Do1mVsvXvIaTFv1Y//gN/uHTL9XTC7VdbkWVq/lgComaA8ywGHWpbuSW96DpK1UDOvoM2bA/YvKS4tYhQjSG4xUd0wqsRDxH7pmRMjoH7Q==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(36840700001)(46966006)(36756003)(54906003)(83380400001)(316002)(8936002)(70206006)(30864003)(36860700001)(6666004)(47076005)(478600001)(110136005)(2616005)(82740400003)(5660300002)(2906002)(336012)(7696005)(70586007)(426003)(26005)(186003)(4326008)(82310400003)(7636003)(107886003)(8676002)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:34.7063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0654ee-0e2d-4f2c-0251-08d8ed558beb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Define get_module_eeprom_by_page() ethtool callback and implement
netlink infrastructure.

get_module_eeprom_by_page() allows network drivers to dump a part of
module's EEPROM specified by page and bank numbers along with offset and
length. It is effectively a netlink replacement for get_module_info()
and get_module_eeprom() pair, which is needed due to emergence of
complex non-linear EEPROM layouts.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  32 +++-
 include/linux/ethtool.h                      |  33 +++-
 include/uapi/linux/ethtool_netlink.h         |  19 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/eeprom.c                         | 161 +++++++++++++++++++
 net/ethtool/netlink.c                        |  10 ++
 net/ethtool/netlink.h                        |   2 +
 7 files changed, 255 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..b370d1186ceb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1280,6 +1280,34 @@ Kernel response contents:
 For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
 the table contains static entries, hard-coded by the NIC.
 
+MODULE_EEPROM
+===========
+
+Fetch module EEPROM data dump.
+
+Request contents:
+
+  =======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_EEPROM_HEADER``       nested  request header
+  ``ETHTOOL_A_MODULE_EEPROM_OFFSET``       u32     offset within a page
+  ``ETHTOOL_A_MODULE_EEPROM_LENGTH``       u32     amount of bytes to read
+  ``ETHTOOL_A_MODULE_EEPROM_PAGE``         u8      page number
+  ``ETHTOOL_A_MODULE_EEPROM_BANK``         u8      bank number
+  ``ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS``  u8      page I2C address
+  =======================================  ======  ==========================
+
+Kernel response contents:
+
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_MODULE_EEPROM_HEADER``          | nested | reply header        |
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_MODULE_EEPROM_DATA``            | nested | array of bytes from |
+ |                                             |        | module EEPROM       |
+ +---------------------------------------------+--------+---------------------+
+
+``ETHTOOL_A_MODULE_EEPROM_DATA`` has an attribute length equal to the amount of
+bytes driver actually read.
+
 Request translation
 ===================
 
@@ -1357,8 +1385,8 @@ are netlink only.
   ``ETHTOOL_GET_DUMP_FLAG``           n/a
   ``ETHTOOL_GET_DUMP_DATA``           n/a
   ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
-  ``ETHTOOL_GMODULEINFO``             n/a
-  ``ETHTOOL_GMODULEEEPROM``           n/a
+  ``ETHTOOL_GMODULEINFO``             ``ETHTOOL_MSG_MODULE_EEPROM_GET``
+  ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
   ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
   ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
   ``ETHTOOL_GRSSH``                   n/a
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..2f6df3b75dd6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -81,6 +81,7 @@ enum {
 #define ETH_RSS_HASH_NO_CHANGE	0
 
 struct net_device;
+struct netlink_ext_ack;
 
 /* Some generic methods drivers may use in their ethtool_ops */
 u32 ethtool_op_get_link(struct net_device *dev);
@@ -265,6 +266,31 @@ struct ethtool_pause_stats {
 	u64 rx_pause_frames;
 };
 
+#define ETH_MODULE_EEPROM_PAGE_LEN	256
+#define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
+
+/**
+ * struct ethtool_eeprom_data - EEPROM dump from specified page
+ * @offset: Offset within the specified EEPROM page to begin read, in bytes.
+ * @length: Number of bytes to read.
+ * @page: Page number to read from.
+ * @bank: Page bank number to read from, if applicable by EEPROM spec.
+ * @i2c_address: I2C address of a page. Value less than 0x7f expected. Most
+ *	EEPROMs use 0x50 or 0x51.
+ * @data: Pointer to buffer with EEPROM data of @length size.
+ *
+ * This can be used to manage pages during EEPROM dump in ethtool and pass
+ * required information to the driver.
+ */
+struct ethtool_module_eeprom {
+	__u32	offset;
+	__u32	length;
+	__u8	page;
+	__u8	bank;
+	__u8	i2c_address;
+	__u8	*data;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -410,6 +436,9 @@ struct ethtool_pause_stats {
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
+ * @get_module_eeprom_by_page: Get a region of plug-in module EEPROM data from
+ *	specified page. Returns a negative error code or the amount of bytes
+ *	read.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -515,6 +544,9 @@ struct ethtool_ops {
 				   const struct ethtool_tunable *, void *);
 	int	(*set_phy_tunable)(struct net_device *,
 				   const struct ethtool_tunable *, const void *);
+	int	(*get_module_eeprom_by_page)(struct net_device *dev,
+					     const struct ethtool_module_eeprom *page,
+					     struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
@@ -538,7 +570,6 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
-struct netlink_ext_ack;
 struct phy_device;
 struct phy_tdr_config;
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a286635ac9b8..c99dea5afbb2 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_MODULE_EEPROM_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +81,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -629,6 +631,23 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* MODULE EEPROM */
+
+enum {
+	ETHTOOL_A_MODULE_EEPROM_UNSPEC,
+	ETHTOOL_A_MODULE_EEPROM_HEADER,			/* nest - _A_HEADER_* */
+
+	ETHTOOL_A_MODULE_EEPROM_OFFSET,			/* u32 */
+	ETHTOOL_A_MODULE_EEPROM_LENGTH,			/* u32 */
+	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+
+	__ETHTOOL_A_MODULE_EEPROM_CNT,
+	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 7a849ff22dad..d604346bc074 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o
+		   tunnels.o eeprom.o
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
new file mode 100644
index 000000000000..79d75e0e2391
--- /dev/null
+++ b/net/ethtool/eeprom.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+#include "netlink.h"
+#include "common.h"
+
+struct eeprom_req_info {
+	struct ethnl_req_info	base;
+	u32			offset;
+	u32			length;
+	u8			page;
+	u8			bank;
+	u8			i2c_address;
+};
+
+struct eeprom_reply_data {
+	struct ethnl_reply_data base;
+	u32			length;
+	u8			*data;
+};
+
+/* Module EEPROMs use one byte to store page number, while each page is 256
+ * bytes long, so in principle offset is limited by a multiple of that,
+ * plus the length of an additional SFP page located at high I2C address.
+ */
+#define MODULE_EEPROM_MAX_OFFSET (257 * ETH_MODULE_EEPROM_PAGE_LEN)
+
+#define MODULE_EEPROM_REQINFO(__req_base) \
+	container_of(__req_base, struct eeprom_req_info, base)
+
+#define MODULE_EEPROM_REPDATA(__reply_base) \
+	container_of(__reply_base, struct eeprom_reply_data, base)
+
+static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct eeprom_reply_data *reply = MODULE_EEPROM_REPDATA(reply_base);
+	struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_base);
+	struct ethtool_module_eeprom page_data = {0};
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_module_eeprom_by_page)
+		return -EOPNOTSUPP;
+
+	/* Allow dumps either of low or high page without crossing half page boundary */
+	if ((request->offset < ETH_MODULE_EEPROM_PAGE_LEN / 2 &&
+	     request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN / 2) ||
+	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
+		return -EINVAL;
+
+	page_data.offset = request->offset;
+	page_data.length = request->length;
+	page_data.i2c_address = request->i2c_address;
+	page_data.page = request->page;
+	page_data.bank = request->bank;
+	page_data.data = kmalloc(page_data.length, GFP_KERNEL);
+	if (!page_data.data)
+		return -ENOMEM;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret)
+		goto err_free;
+
+	ret = dev->ethtool_ops->get_module_eeprom_by_page(dev, &page_data,
+							  info->extack);
+	if (ret < 0)
+		goto err_ops;
+
+	reply->length = ret;
+	reply->data = page_data.data;
+
+	ethnl_ops_complete(dev);
+	return 0;
+
+err_ops:
+	ethnl_ops_complete(dev);
+err_free:
+	kfree(page_data.data);
+	return ret;
+}
+
+static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
+				struct netlink_ext_ack *extack)
+{
+	struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_info);
+
+	if (!tb[ETHTOOL_A_MODULE_EEPROM_OFFSET] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_LENGTH] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS])
+		return -EINVAL;
+
+	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]);
+	request->offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
+	request->length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
+
+	if (request->offset > MODULE_EEPROM_MAX_OFFSET)
+		return -EINVAL;
+
+	if (tb[ETHTOOL_A_MODULE_EEPROM_PAGE]) {
+		request->page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
+		if (request->page > 0 &&
+		    (request->offset < ETH_MODULE_EEPROM_PAGE_LEN / 2 ||
+		     request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN))
+			return -EINVAL;
+	}
+	if (tb[ETHTOOL_A_MODULE_EEPROM_BANK])
+		request->bank = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]);
+
+	return 0;
+}
+
+static int eeprom_reply_size(const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	const struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_base);
+
+	return nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA */
+}
+
+static int eeprom_fill_reply(struct sk_buff *skb,
+			     const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_reply_data *reply = MODULE_EEPROM_REPDATA(reply_base);
+
+	return nla_put(skb, ETHTOOL_A_MODULE_EEPROM_DATA, reply->length, reply->data);
+}
+
+static void eeprom_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_reply_data *reply = MODULE_EEPROM_REPDATA(reply_base);
+
+	kfree(reply->data);
+}
+
+const struct ethnl_request_ops ethnl_module_eeprom_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MODULE_EEPROM_GET,
+	.reply_cmd		= ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MODULE_EEPROM_HEADER,
+	.req_info_size		= sizeof(struct eeprom_req_info),
+	.reply_data_size	= sizeof(struct eeprom_reply_data),
+
+	.parse_request		= eeprom_parse_request,
+	.prepare_data		= eeprom_prepare_data,
+	.reply_size		= eeprom_reply_size,
+	.fill_reply		= eeprom_fill_reply,
+	.cleanup_data		= eeprom_cleanup_data,
+};
+
+const struct nla_policy ethnl_module_eeprom_get_policy[] = {
+	[ETHTOOL_A_MODULE_EEPROM_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MODULE_EEPROM_OFFSET]	= { .type = NLA_U32 },
+	[ETHTOOL_A_MODULE_EEPROM_LENGTH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_MODULE_EEPROM_PAGE]		= { .type = NLA_U8 },
+	[ETHTOOL_A_MODULE_EEPROM_BANK]		= { .type = NLA_U8 },
+	[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]	=
+		NLA_POLICY_RANGE(NLA_U8, 0, ETH_MODULE_MAX_I2C_ADDRESS),
+};
+
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..52d1ffb1bca2 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -245,6 +245,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -912,6 +913,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tunnel_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_EEPROM_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_module_eeprom_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_eeprom_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6eabd58d81bf..71cbd9df8229 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -375,6 +376,7 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.18.2

