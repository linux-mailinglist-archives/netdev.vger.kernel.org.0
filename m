Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B27135971C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhDIIHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:15 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:60385
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229621AbhDIIHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kkb6GN7k+rbzHr5/TCdcIrm9qrj4TgRulTgsiIwCqzA32pQwuocCwmfG0ANIrTat/C0wmyEcttILCCnVTzMEqVpsiVoSBTDsDoRooTjMw1XlAQa2DCp0R6wFfFK+qvXgQrwL6KGDL2yTD4PNJmTiyxBDvmmvrkTEz4VxuWScDfh14xY/FTP82Tmmn63UjAihfHgZOQSRxejr9ici9jRezaerj6LtjWyk+QsDG8nc8XNxhTEq/VloVMs36W6bRNE13mBi2Z0+Qy1pzVXaRMs7yFztigwoV3l7CYWGkDT5IxIQpeq+SDf+ZbLXdAuyM2iFnnnqfDuwdvgqO6pXwCsdvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeKwMJ96Ab7FiZx1ujYdjEFK0q5tfayD8J0ZC+Cs6PA=;
 b=Lr1rqhDEIRp0gEiIyUk0onc4zpPNrznSjMdOPm+Xr62TpVkjJxh1X5wkVQeYzjqtFszy1dtndqiFaAd/7OiJJL4HKaS++FYqU/nicRnaBd9tbqdSrwRz+f3TkVmOvVLLYcIymuRd691s1PSYkyAkgeCKLZMj98TmmJeSwWD0noOD2T4+ZQXLMbpy5I9e8yJ9ZKfCCbsq7BpFmqSWSHM9vO2W7wbRkqVlrTAG4HsUDbk6qvfkrc03PBwGSmEiOdDNkTD3JwFuYjXlFkMaG9fIa0OlTqkJSecJowctAau5gxzugkOCyKqJmh7VPNZlxFcCWhOTbtJ/1uDbfyvYt2kgrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeKwMJ96Ab7FiZx1ujYdjEFK0q5tfayD8J0ZC+Cs6PA=;
 b=ZqQJ/MpnKAX6HikhYBQNlllGVVetxwpVjBNQMzdtUOw64zyQlJvRdsEzTtojB3/tXOeSZ7E1bXphUvrLjVAqmjyrNwFKylT5WQ1gm839XPs1NUvaxZIzNLZtLMZ54S13wCU9/seg4ScF3lUFCFfD0k+O2PIkeAx6RBQ7fJwh9OrlNgz7Fk1/BPB70AD5pFNDQEzTAZKL8VIRVwYUyrrgKKZjCtkHmw7CPZ4FmhU/kAlC6g/T43OyqXFU3Qi4W6jMzxoC8aHEvtMdeTnGt1czz6c6aQjeAMUXtICpFbfgQ+hXbNFfjOo0DQMLdLB1vFObYhneJUcnKj0xBu5YRsTA9g==
Received: from BN9PR03CA0080.namprd03.prod.outlook.com (2603:10b6:408:fc::25)
 by BN7PR12MB2594.namprd12.prod.outlook.com (2603:10b6:408:28::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 9 Apr
 2021 08:07:00 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::ac) by BN9PR03CA0080.outlook.office365.com
 (2603:10b6:408:fc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.19 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:06:59 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:06:59 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:06:57 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 1/8] ethtool: Allow network drivers to dump arbitrary EEPROM data
Date:   Fri, 9 Apr 2021 11:06:34 +0300
Message-ID: <1617955601-21055-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f2375e4-e143-4419-0b32-08d8fb2e73ca
X-MS-TrafficTypeDiagnostic: BN7PR12MB2594:
X-Microsoft-Antispam-PRVS: <BN7PR12MB2594ECC0B786DEF621FBE309D4739@BN7PR12MB2594.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OE/uyWygrP9o8oW62id4c8JgPqU4wZOpXQ+gf6FYT90vfgArC04AmRMp4l/1Ty7c8ranhVIqJfxII8KwSD7O2YS5AkEDkneQGTv5+oEk3t8uhfm3wMyG8vs+dtsIiOREnCMXGPj0W5SJXsExgqaPhOqzAx70iHaTayAoix53S6CLn7N5h5F+Zzn6lzs7xFyU4iMyvx3P65IhJDbW1rflN07HwSd3YuR4JqGhp6IDITCeHZyY6Ki5db7I/9Rv42vWN6Mkt4VTdY67VT/hVHtzAii00bbbEJwRzhpzpdq6cpa+L/iBW/4S+wwFiGkDXVv6eCS9vBofcsvCa55dgBi7x6rTTXHcTUgI25A/JfBZ58zOkkszaqzlW4+ySWS5JnNHCSDPZwp/xBehIadLqspCnEUrkofTbbr0EsNx62GRk5AHuCCZdqjeow2FwThRqMlQm5qNzpY4yZMF4Y7LqraM8L2m6Hce5aeR89plf+1YvF1pUIWvJfnF7tU2PLRG+EQbx/STrbcF5blU7AQLE9JypK5ZCHCYI3IYUb42EvuQjQeBG/z2hx5FQQzpWKgTXUIr15sOraHb2XesdG4yj4DFldOJdq+ErKUNHpm9fiIKCTGWhn4tIV495f01LxWuuLzq4lNoZy5izatdKwbtYUWzWTq3jmo1OraCpyP/WB7OxK4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(36756003)(86362001)(26005)(6666004)(82310400003)(8676002)(110136005)(478600001)(83380400001)(54906003)(30864003)(4326008)(8936002)(186003)(7636003)(47076005)(356005)(336012)(426003)(5660300002)(36906005)(2906002)(107886003)(316002)(82740400003)(7696005)(2616005)(36860700001)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:06:59.9985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2375e4-e143-4419-0b32-08d8fb2e73ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2594
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
 net/ethtool/eeprom.c                         | 171 +++++++++++++++++++
 net/ethtool/netlink.c                        |  11 ++
 net/ethtool/netlink.h                        |   2 +
 7 files changed, 270 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index fd84f4ed898a..77e4a838f247 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1338,6 +1338,38 @@ in an implementation specific way.
 ``ETHTOOL_A_FEC_AUTO`` requests the driver to choose FEC mode based on SFP
 module parameters. This does not mean autonegotiation.
 
+MODULE_EEPROM
+=============
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
 
@@ -1415,8 +1447,8 @@ are netlink only.
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
index 5c631a298994..7106c73fca34 100644
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
+ * struct ethtool_module_eeprom - EEPROM dump from specified page
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
@@ -412,6 +438,9 @@ struct ethtool_pause_stats {
  *	cannot use the standard PHY library helpers.
  * @get_phy_tunable: Read the value of a PHY tunable.
  * @set_phy_tunable: Set the value of a PHY tunable.
+ * @get_module_eeprom_by_page: Get a region of plug-in module EEPROM data from
+ *	specified page. Returns a negative error code or the amount of bytes
+ *	read.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -517,6 +546,9 @@ struct ethtool_ops {
 				   const struct ethtool_tunable *, void *);
 	int	(*set_phy_tunable)(struct net_device *,
 				   const struct ethtool_tunable *, const void *);
+	int	(*get_module_eeprom_by_page)(struct net_device *dev,
+					     const struct ethtool_module_eeprom *page,
+					     struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
@@ -540,7 +572,6 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
-struct netlink_ext_ack;
 struct phy_device;
 struct phy_tdr_config;
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7f1bdb5b31ba..9612dcd48a6a 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -44,6 +44,7 @@ enum {
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
 	ETHTOOL_MSG_FEC_GET,
 	ETHTOOL_MSG_FEC_SET,
+	ETHTOOL_MSG_MODULE_EEPROM_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -84,6 +85,7 @@ enum {
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
 	ETHTOOL_MSG_FEC_GET_REPLY,
 	ETHTOOL_MSG_FEC_NTF,
+	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -646,6 +648,23 @@ enum {
 	ETHTOOL_A_FEC_MAX = (__ETHTOOL_A_FEC_CNT - 1)
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
index c2dc9033a8f7..83842685fd8c 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o
+		   tunnels.o fec.o eeprom.o
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
new file mode 100644
index 000000000000..8536dd905da5
--- /dev/null
+++ b/net/ethtool/eeprom.c
@@ -0,0 +1,171 @@
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
+
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
index 705a4b201564..5f5d7c4b3d4a 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -246,6 +246,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -931,6 +932,16 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_fec_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_fec_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_EEPROM_GET,
+		.flags  = GENL_UNS_ADMIN_PERM,
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
index 785f7ee45930..4305ac971bb0 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
+extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -378,6 +379,7 @@ extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_T
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
+extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.26.2

