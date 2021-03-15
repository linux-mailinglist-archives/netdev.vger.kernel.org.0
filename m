Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731E533C3C6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbhCORNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:11 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:30560
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231305AbhCORNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6zqxUGTtiGBGhFcNAeKkeFoo8mBDnyplbUAVVIJx00a0TW7whfJeFkz4OoR4AZS4iMg6981wPznoJVv83Zy/1VB95BLJ2Nbyml8QVIiqyelMbDFKt2lwbaD44TZSWN0cF0/sXCIR9DFy6PhTp0/tp9hpCDh30cW1DlGCdAtbGvy5509L2OgVvKhFnqy4MQiyMfUO3nJrjLV2+ob2wIHqZkileCtxiNdbaeC4v8vg4YO+1mgGOf3YZ1h+1nGxJrV3UOVBTsng8GAIaao52UyUdBZEShL9A0mP7ygPJYz/9mnLvpKyvfejvUC918mKnjrOiYgBmjxQ+QwwS0Biez1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDkhxdXgtx17Bkot1s+1t4J6BHZFa/DHjRnw+DPLHQM=;
 b=VSOQskKEJxqI4wG9asssrVAh2PslFluamMcxb5NbJ/WmEOgc62SBcgqjPb36HNcA6tJzGokG1LcDrvo9Isyq3D05JmSfurjX+QmNX+8g20uEX1F56s2JLZF3MbtSWQPnYjbttJM71N/EYeiryiQAfmqwBKlM8qAiw3ZTrLVF7fCNyoTiYJPAFpsqwGvjjhlzpUNolk0gMMnz0gSIzufHBQee2WJ/hr/43Mw7f35nP/N2rwP7xC3r8WpjsqqNk9qRjXVgYxYtg7wF0LZx90+JfUW6yawjfA4LaA4CKOLESgT0H3yb6bOVTqux5/MXhkjfxfJsEOsZQI5ii4UKUE7uZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDkhxdXgtx17Bkot1s+1t4J6BHZFa/DHjRnw+DPLHQM=;
 b=rvmHUXMApQDAlzVE9Y68ELWkh1cxp7KM9FuFAeoyrDbvEhVp9YnMWuPA7PWfLg+b3iyVzGshLE4JwTdYzL0Z5Jx9PI0LXn4QVb4ljiIJ1PCwCBFzvW6WSlpyKwrxJu0wDlkIOZ5Tu1XyQgP2/dQkg2vrgkc6aJNruiTaogrOIUuS3FjCjMfzKsgKhgblOrmz4GXL0EepBoYKdtf6fIkyXL8Lyfr2wNY5iv2dzIO6zfsfQ0DMAFAoK9HygjtH8Imk5qwP57WesSP6iRDQ+T5UgqcEXasVXGgM8wcfc7wiFtvh9B28LqrdXZp7JBMZzFchkOcIC/4z+4c+ngfyL+CDPQ==
Received: from DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33)
 by DM5PR1201MB0089.namprd12.prod.outlook.com (2603:10b6:4:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 17:12:59 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::42) by DM5PR07CA0143.outlook.office365.com
 (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:12:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:12:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:12:58 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:12:56 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Mon, 15 Mar 2021 19:12:39 +0200
Message-ID: <1615828363-464-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1615828363-464-1-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c3fa280-3ac7-494a-cd4d-08d8e7d59538
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0089:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00898AC440D364353469463DD46C9@DM5PR1201MB0089.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5ocqYpGlAkVrU/n2axoiiMLLkjzHsLqLPO+VF04vugWgSP0nuV+Y5Eu3xuoHKgK6iURVnK09ceipMjcIEh6PvZR8WBfPb6UgpFP8MvbcNJTELqGHK5nDBhSVl5KuflG6iyI4MAVPdGIZN53FYEH7FfG/HXL2EZsIiICE+Ga7bsZn1LKoZppOZ2HnL5URN9c4q+JYyheqY+d95E1/WNs6SuoOwUg6FuyK5RjV12YSMig/lm1Y4dIIHAmD5/JDdmnhgsZ9DSkAmG+j2y7hBCd5Tj7YGr2rTj3P58pC1FIAYAhwjvqAXe0Fp29SaRDJZ3af5Uydo1JZnZ13f4E7m9/3dL0IFcEmuKr/x0mkW7jHBFJqcXUo0mmeFpbzwiyh2cA5Og4yZAGqVNMtTTLiNrxAlDIR8l4JGMlzbl0k+WjIonQFTOcniOJTrleXrsbcWCmAr4RgqALZEVTM8zPmoAxw3CyhBpI3uQWI1HouKzFhVowaCMPk9RT5te7Y64u3JO4wjG0b48zcNRRsJZlcMZKpqOM8S0tteYfk6gLjEvSwYOiX+KxUnRQhxsWXVlIVFvweKlloHQx4H4ctqCDrEXG3EHKtkBMpdtZq2nM6zPksr+ArbBpSmVEDaIIKriQdQ+aMHNnkKjv29PwpBs4lzcaUxBea47T7jxSzEqQQmyymjlATQn41QPlej/Q9A4836+e
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(26005)(70586007)(70206006)(186003)(2906002)(82310400003)(336012)(2616005)(7696005)(426003)(6666004)(356005)(36756003)(107886003)(4326008)(82740400003)(7636003)(47076005)(8936002)(5660300002)(478600001)(36906005)(54906003)(86362001)(30864003)(36860700001)(8676002)(34020700004)(316002)(83380400001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:12:58.9114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3fa280-3ac7-494a-cd4d-08d8e7d59538
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Define get_module_eeprom_data_by_page() ethtool callback and implement
netlink infrastructure.

get_module_eeprom_data_by_page() allows network drivers to dump a part
of module's EEPROM specified by page and bank numbers along with offset
and length. It is effectively a netlink replacement for
get_module_info() and get_module_eeprom() pair, which is needed due to
emergence of complex non-linear EEPROM layouts.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  34 ++++-
 include/linux/ethtool.h                      |   8 +-
 include/uapi/linux/ethtool.h                 |  25 +++
 include/uapi/linux/ethtool_netlink.h         |  19 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/eeprom.c                         | 153 +++++++++++++++++++
 net/ethtool/netlink.c                        |  10 ++
 net/ethtool/netlink.h                        |   2 +
 8 files changed, 249 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..25846b97632a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1280,6 +1280,36 @@ Kernel response contents:
 For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
 the table contains static entries, hard-coded by the NIC.
 
+EEPROM_DATA
+===========
+
+Fetch module EEPROM data dump.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
+  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
+  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
+  ``ETHTOOL_A_EEPROM_DATA_PAGE``         u8      page number
+  ``ETHTOOL_A_EEPROM_DATA_BANK``         u8      bank number
+  ``ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS``  u8      page I2C address
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_EEPROM_DATA_HEADER``            | nested | reply header        |
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_EEPROM_DATA_LENGTH``            | u32    | amount of bytes read|
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_EEPROM_DATA``                   | nested | array of bytes from |
+ |                                             |        | module EEPROM       |
+ +---------------------------------------------+--------+---------------------+
+
+``ETHTOOL_A_EEPROM_DATA`` has an attribute length equal to the amount of bytes
+driver actually read.
+
 Request translation
 ===================
 
@@ -1357,8 +1387,8 @@ are netlink only.
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
index ec4cd3921c67..9551005b350a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -81,6 +81,7 @@ enum {
 #define ETH_RSS_HASH_NO_CHANGE	0
 
 struct net_device;
+struct netlink_ext_ack;
 
 /* Some generic methods drivers may use in their ethtool_ops */
 u32 ethtool_op_get_link(struct net_device *dev);
@@ -410,6 +411,9 @@ struct ethtool_pause_stats {
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
+ * @get_module_eeprom_data_by_page: Get a region of plug-in module EEPROM data
+ *	from specified page. Returns a negative error code or the amount of
+ *	bytes read.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -515,6 +519,9 @@ struct ethtool_ops {
 				   const struct ethtool_tunable *, void *);
 	int	(*set_phy_tunable)(struct net_device *,
 				   const struct ethtool_tunable *, const void *);
+	int	(*get_module_eeprom_data_by_page)(struct net_device *dev,
+						  const struct ethtool_eeprom_data *page,
+						  struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
@@ -538,7 +545,6 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
-struct netlink_ext_ack;
 struct phy_device;
 struct phy_tdr_config;
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..b3e92db3ad37 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -340,6 +340,28 @@ struct ethtool_eeprom {
 	__u8	data[0];
 };
 
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
+struct ethtool_eeprom_data {
+	__u32	offset;
+	__u32	length;
+	__u8	page;
+	__u8	bank;
+	__u8	i2c_address;
+	__u8	*data;
+};
+
 /**
  * struct ethtool_eee - Energy Efficient Ethernet information
  * @cmd: ETHTOOL_{G,S}EEE
@@ -1865,6 +1887,9 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define ETH_MODULE_SFF_8636_MAX_LEN     640
 #define ETH_MODULE_SFF_8436_MAX_LEN     640
 
+#define ETH_MODULE_EEPROM_PAGE_LEN	256
+#define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
+
 /* Reset flags */
 /* The reset() operation must clear the flags for the components which
  * were actually reset.  On successful return, the flags indicate the
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a286635ac9b8..e1b1b962f3da 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_EEPROM_DATA_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +81,7 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -629,6 +631,23 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* MODULE EEPROM DATA */
+
+enum {
+	ETHTOOL_A_EEPROM_DATA_UNSPEC,
+	ETHTOOL_A_EEPROM_DATA_HEADER,			/* nest - _A_HEADER_* */
+
+	ETHTOOL_A_EEPROM_DATA_OFFSET,			/* u32 */
+	ETHTOOL_A_EEPROM_DATA_LENGTH,			/* u32 */
+	ETHTOOL_A_EEPROM_DATA_PAGE,			/* u8 */
+	ETHTOOL_A_EEPROM_DATA_BANK,			/* u8 */
+	ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,		/* u8 */
+	ETHTOOL_A_EEPROM_DATA,				/* nested */
+
+	__ETHTOOL_A_EEPROM_DATA_CNT,
+	ETHTOOL_A_EEPROM_DATA_MAX = (__ETHTOOL_A_EEPROM_DATA_CNT - 1)
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
index 000000000000..e110336dc231
--- /dev/null
+++ b/net/ethtool/eeprom.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool.h>
+#include "netlink.h"
+#include "common.h"
+
+struct eeprom_data_req_info {
+	struct ethnl_req_info	base;
+	u32			offset;
+	u32			length;
+	u8			page;
+	u8			bank;
+	u8			i2c_address;
+};
+
+struct eeprom_data_reply_data {
+	struct ethnl_reply_data base;
+	u32			length;
+	u8			*data;
+};
+
+#define EEPROM_DATA_REQINFO(__req_base) \
+	container_of(__req_base, struct eeprom_data_req_info, base)
+
+#define EEPROM_DATA_REPDATA(__reply_base) \
+	container_of(__reply_base, struct eeprom_data_reply_data, base)
+
+static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
+				    struct ethnl_reply_data *reply_base,
+				    struct genl_info *info)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
+	struct ethtool_eeprom_data page_data = {0};
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
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
+	ret = ethnl_ops_begin(dev);
+	if (ret)
+		goto err_free;
+
+	ret = dev->ethtool_ops->get_module_eeprom_data_by_page(dev, &page_data,
+							       info->extack);
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
+static int eeprom_data_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
+				     struct netlink_ext_ack *extack)
+{
+	struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_info);
+	struct net_device *dev = req_info->dev;
+
+	if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
+	    !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
+	    !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
+		return -EINVAL;
+
+	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
+	if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
+		return -EINVAL;
+
+	request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
+	request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
+	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
+	    dev->ethtool_ops->get_module_eeprom_data_by_page &&
+	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
+		return -EINVAL;
+
+	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
+		request->page = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
+	if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
+		request->bank = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
+
+	return 0;
+}
+
+static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	const struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
+
+	return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
+	       nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA */
+}
+
+static int eeprom_data_fill_reply(struct sk_buff *skb,
+				  const struct ethnl_req_info *req_base,
+				  const struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+
+	if (nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_LENGTH, reply->length) ||
+	    nla_put(skb, ETHTOOL_A_EEPROM_DATA, reply->length, reply->data))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static void eeprom_data_cleanup_data(struct ethnl_reply_data *reply_base)
+{
+	struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
+
+	kfree(reply->data);
+}
+
+const struct ethnl_request_ops ethnl_eeprom_data_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_EEPROM_DATA_GET,
+	.reply_cmd		= ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_EEPROM_DATA_HEADER,
+	.req_info_size		= sizeof(struct eeprom_data_req_info),
+	.reply_data_size	= sizeof(struct eeprom_data_reply_data),
+
+	.parse_request		= eeprom_data_parse_request,
+	.prepare_data		= eeprom_data_prepare_data,
+	.reply_size		= eeprom_data_reply_size,
+	.fill_reply		= eeprom_data_fill_reply,
+	.cleanup_data		= eeprom_data_cleanup_data,
+};
+
+const struct nla_policy ethnl_eeprom_data_get_policy[] = {
+	[ETHTOOL_A_EEPROM_DATA_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_EEPROM_DATA_OFFSET]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_LENGTH]		= { .type = NLA_U32 },
+	[ETHTOOL_A_EEPROM_DATA_PAGE]		= { .type = NLA_U8 },
+	[ETHTOOL_A_EEPROM_DATA_BANK]		= { .type = NLA_U8 },
+	[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]	= { .type = NLA_U8 },
+	[ETHTOOL_A_EEPROM_DATA]			= { .type = NLA_BINARY },
+};
+
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..ff2528bee192 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -245,6 +245,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_EEPROM_DATA_GET]	= &ethnl_eeprom_data_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -912,6 +913,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tunnel_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_EEPROM_DATA_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_eeprom_data_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_eeprom_data_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6eabd58d81bf..60954c7b4dfe 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_eeprom_data_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -375,6 +376,7 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_eeprom_data_get_policy[ETHTOOL_A_EEPROM_DATA + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.26.2

