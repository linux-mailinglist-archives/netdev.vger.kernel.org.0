Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6B3494C0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCYO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:37 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:3424
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230406AbhCYO5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZL7viCQzSK7G4OFwjG+o3+3VC655c3GuN+C5M5WC9QtZYVPX+iw7R+v7tK4DHhblT252fR3PWnvgUCoO7AeebdVbI1glfVieuBiXZMMf2eSOldUQcSqyhEBaLi+4PeQN1GcIuZD+3pJN2H0iYxeLXBAs6Xxe5FkZLFKCGG9lcBnFws4X+XbkKfTLCAa5Y/KGyzJC8W34vbFFpTZKhmEz65+KnDJ/GGn8vSd68fUjjbPzpDSQSxhNtvPSlfDeRluVY2c/e5/w4RvxHrfSR3hGPSACM7Tk8VbVWzg3raO9/gUkpLBEJwGjI8f9DCLCTroFaUiju/YHHK5YrR5VBoaovQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpJ48wTn7BYFG3GgIbOX4FjiTc06XuWBWb+wu3vpEx8=;
 b=TMEIPkGcIOJX+F8sNvv+VF2FQuS9Y0EjJiLO/BYTQhN8XZfcFMTgJdYRaNSNc6eucr43U/FfaaTSqyeoUeztyedPOn2tkH7IgEahE0iISW9ASFx53wCBCpDobMtMZRisjhq+dtIcKmkfFUOKVpqIg9Jood5J8F1niF9qh/WGGaLLipks/HwjKSWHtI1OhD7Nufo13prOYNj5xjEvMQubcquaYKGQEI7CfJLQKt908JJVeY6UabkTH+hYlEbIBll5NN8mC1ezGWuSec3vtb53aZj3XPHANFdRHQSo2seSX5Tn4A2ul66151m9M5GC0lCCaNrreLKA0RISiNMLyIqHww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpJ48wTn7BYFG3GgIbOX4FjiTc06XuWBWb+wu3vpEx8=;
 b=R6priYGeZg1zo6IsWq7v+cz7euwQgA8+g9oa2UI5E9xy/4bvnTrWdDW8SoWaRipTKanO09efg2gAjG5ikAIu+vTSAOJNP1EE4ZlUseV9G1f9MpZn4dRC9lDRH6gXnVmIj3dhntvl5vBAccuiY/gB5Vj8HHgqIPih2ps4lUa8yDNpxqB7vOhH09ZR0kQ5oA0cYpx8jD2pKz8t1yTi71PyKxxZQFwLx5sjcpGRTxF5YAhwJmLWhBWeXQty8xBPxPu6KIjzmEIasIYINjeebx3jewU9MGeflvFQkKMi2XZB7hl3NCZdBEVsO/IirZUox8/+2HS8XzUJLaeSe84bg/03rw==
Received: from CO1PR15CA0100.namprd15.prod.outlook.com (2603:10b6:101:21::20)
 by DM5PR12MB1289.namprd12.prod.outlook.com (2603:10b6:3:79::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 14:57:13 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::bb) by CO1PR15CA0100.outlook.office365.com
 (2603:10b6:101:21::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:12 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:12 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:10 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Thu, 25 Mar 2021 16:56:51 +0200
Message-ID: <1616684215-4701-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26097838-89dc-4b26-a2c9-08d8ef9e4601
X-MS-TrafficTypeDiagnostic: DM5PR12MB1289:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1289346F38B5AFCCAB11B4F3D4629@DM5PR12MB1289.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Sa8W6bPOfE3kr/2bxJ2i+dwkPGB4Z4vcdAXjmMskY2fg0ceBeTq1kctGEF20+P562Mwqkp3J1WnZnjwWphbD670N2zJnQ5wbW0+L+Xy3RnbZCpjHT9Q95QkRzUn2HXMz6Sp44SgsKapYCJvorZ/4DGAKhKvwE5Boe1Bl2oNqAzpgwv0fwiJt1AyDMI5Q/nkvlURRUY5Pouk0jY2/MS1kmPaZYY9/8V24uGguzBB+1gxA8LucT2ZZO554rIt3NbLLHiGD/iQYBHZbT45MFq1nVgryHJS1BQajXYbB2OyBsnDu8xWEXMI1E6NmaLrCRvZc9h7VDlO9DmFdNY/g+qSRw5GzvbgyV9egqC4nhh1dwlrJgybP0iuj4IfLBMbU4xSpfQViREtjkg5/l3IBU/i28tKkw5DshNiSAXNCksCMHXUjxchWbopgtO5LtFY479Od0NrCJLlWeBXRrURjZDFyaD7osQFyZRFtgQAfFJK0gmp9Iwc31FWG5P+7YVrJq3HzdUzaIDjQ4zCTmukjJTTwB3pBT0DTmEIcWa358ktKqIT5o9SwkOhc/zauFLkRre3myzMH8BDgynJeuEKJSpklZbjMurrywWj11Va1SHwrloUj9floScUEKCK8TygoMjRhFKilktJZoXOcj8PXdc00A==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(7696005)(83380400001)(107886003)(356005)(2906002)(82740400003)(6666004)(426003)(336012)(7636003)(2616005)(8676002)(4326008)(8936002)(26005)(36906005)(36860700001)(5660300002)(86362001)(30864003)(54906003)(478600001)(316002)(110136005)(36756003)(70206006)(70586007)(47076005)(82310400003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:12.9969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26097838-89dc-4b26-a2c9-08d8ef9e4601
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1289
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
 Documentation/networking/ethtool-netlink.rst |  36 +++-
 include/linux/ethtool.h                      |  33 +++-
 include/uapi/linux/ethtool_netlink.h         |  19 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/eeprom.c                         | 170 +++++++++++++++++++
 net/ethtool/netlink.c                        |  10 ++
 net/ethtool/netlink.h                        |   2 +
 7 files changed, 268 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..b6a21b9d1973 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1280,6 +1280,38 @@ Kernel response contents:
 For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
 the table contains static entries, hard-coded by the NIC.
 
+MODULE_EEPROM
+===========
+
+Fetch module EEPROM data dump.
+This interface is designed to allow dumps of at most 1/2 page at once. This
+means only dumps of 128 (or less) bytes are allowed, without crossing half page
+boundary located at offset 128. For pages other than 0 only high 128 bytes are
+accessible.
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
 
@@ -1357,8 +1389,8 @@ are netlink only.
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
index 3583f7fc075c..19a609a4b714 100644
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
 
+#define ETH_MODULE_EEPROM_PAGE_LEN	128
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
index 000000000000..10d5f6b34f2f
--- /dev/null
+++ b/net/ethtool/eeprom.c
@@ -0,0 +1,170 @@
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
+	    !tb[ETHTOOL_A_MODULE_EEPROM_PAGE] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS])
+		return -EINVAL;
+
+	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]);
+	request->offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
+	request->length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
+
+	if (!request->length)
+		return -EINVAL;
+
+	/* The following set of conditions limit the API to only dump 1/2
+	 * EEPROM page without crossing low page boundary located at offset 128.
+	 * This means user may only request dumps of length limited to 128 from
+	 * either low 128 bytes or high 128 bytes.
+	 * For pages higher than 0 only high 128 bytes are accessible.
+	 */
+	request->page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
+	if (request->page && request->offset < ETH_MODULE_EEPROM_PAGE_LEN) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_PAGE],
+				    "reading from lower half page is allowed for page 0 only");
+		return -EINVAL;
+	}
+
+	if (request->offset < ETH_MODULE_EEPROM_PAGE_LEN &&
+	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
+				    "reading cross half page boundary is illegal");
+		return -EINVAL;
+	} else if (request->offset >= ETH_MODULE_EEPROM_PAGE_LEN * 2) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_OFFSET],
+				    "offset is out of bounds");
+		return -EINVAL;
+	} else if (request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN * 2) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
+				    "reading cross page boundary is illegal");
+		return -EINVAL;
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

