Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE80368DDE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbhDWHYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 03:24:22 -0400
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:57760
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229982AbhDWHYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 03:24:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+f11rmwXftDd6nN8vdgsFxqj+lCy6PI/ebM+KYk4jUcEiFhVAiKknfoPmklPXyVMsqdc7aEV6wOq4D9VrP5TGAliRvq0S5uEG9oF7HE+2dBVLf4sTuqr+eKvTac6MdB89qsdrxt0V6KUHm+wakzIgrN5tsv9DQ467X5wYMNt39WfG27iC65iu3MWsH/xoAW7c50d+V74bPNDfBAYhE3iCUfxEYtZZ+8XCCMVQaBIxzLnwnVu+2jPkdTvtyljPZgS+4fdV5A3RsnbUCDCM111p2iYIEtMlKC68jL007qBEoo3SBfeUdIDy23TWg8oQtE3CN2xqaUX8m82OPlECoOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62bFuhmAXLtJGafFHw9zHRmbUq9cIunDpAj4UAUxLbs=;
 b=b64Tj6kEIfGT/W+etCM3ScfY30CYFZv3UDCSKzoSSJ2YgPpypXFwVunUkQdcOQ5qYXrzTHmXn7cj0ItB8Gtq/e24MWmgOIhSh2K8D//wjxc7HYJoiC20hAVdiG+Jn5NMsvDJKVMbPA3xANCKcnUHGpx7AH4oJwj49x9bVMqp2ve2cge9+ElvZz2lNMkyayX+smN2fRPPlHF57gcqfiyU+wNPlcPvEHbiFCe7lTP4AOWX167ZSTUN9RM46aQqFGTTJbd/lL4A8fafKHIDHnRegvrTmCu30oZUZIqekk6KU8TqBdHdrauMEzb4sWMegjkcmEwANILRAyrC2hwtheq9BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62bFuhmAXLtJGafFHw9zHRmbUq9cIunDpAj4UAUxLbs=;
 b=O8/7VKM14MGmDKNj3VtQtOKALNKMu2GNfo22/D7OygMHqs7QMNndYo+efoNOunW0U0lv6TsZTe7C2UMPmj7glXwfZ7ZBSpyJVaaJPk6bNmzsg1mXUMeM47gkwgmdFFS2oxlFmcru6zR+ebKXMC8iHs1Re7Skzex486mU/2icSX7dXSin6IOUnR0GZNxHuUmRB6qETWKbu2ER3wKNZ2nODZGoRHuc6YSp7HlgagSyE51eziZuA4eNXHvwcqRp+3iQ3CWzwa631i0nufFWKAmHj5Av2K6xYKgk6zZ4FEz+KV9aAnd4TurjqztqIX+T8q+COkjd6NNLEz9eJXq+ARnwUw==
Received: from DM3PR03CA0008.namprd03.prod.outlook.com (2603:10b6:0:50::18) by
 MN2PR12MB2910.namprd12.prod.outlook.com (2603:10b6:208:af::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Fri, 23 Apr 2021 07:23:43 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::d3) by DM3PR03CA0008.outlook.office365.com
 (2603:10b6:0:50::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 07:23:43 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 07:23:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:40 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool-next 1/4] ethtool: Add netlink handler for getmodule (-m)
Date:   Fri, 23 Apr 2021 10:23:13 +0300
Message-ID: <1619162596-23846-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c532d37-faaf-4de3-f360-08d90628b9d9
X-MS-TrafficTypeDiagnostic: MN2PR12MB2910:
X-Microsoft-Antispam-PRVS: <MN2PR12MB29100FAD0680A63F72C25D1DD4459@MN2PR12MB2910.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPYnwsVAdUyOkQlhgl4mY3G9MDzGeD75TB6RXyvG3wkXApJbuH215E0y9p8ggArxaQYTKT5iNIh4L+QpJp7oavnAKmSYvygicL19UuzBCnvRz8irSKHoVwZb8hTuCzRplCbkP61tay119tdOlAe0fScnwC7gmcXN/csOBSghSVt91qE0EOshKbxNF15Z9O6Y89R+FUzsoQxbTE+7nekHk4VkCQGnh4pK3v6jh/lG9bzYMrIc+0MtUxeo/Ca3GFT0sq2Pl40ERSzjZH2zktReYNVKouPToNv+R+y2xrjTfEYZorjJkXWcw7FBfH0iFsnMpjchQsKa8lIHQHkOfVDpSMddFx2l5BmvrStxyJbJOterMbtQ1MkvnllOv4SaB8hvLDLDq4xllZR4gq19qGy2ttlE3sI8tpbGZPf+Wg6Yq0uuRHQLME1jCqGFrmpfiXi6xpWaxw1kKxyTr9GtmUXg1zzESSJk+6pvTSRt0TcT14Yv5DF9uK79z0Rq1sCZqK/C+gM18baFvsSHQOQCddIEeUHXFRBUDKHsUtlOhmzqHXYU9iSkw68/6b8T16W+HJtx9hjH6679nm9oDzCtYRlDVv1rijY3k6GvNbPoQgg7Q5bTS8/+sJ9R5lonwltKBp5DADOJPkZl/8wvkloOfBD6O6F28JXAEhZj1sSTXtfKdPI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(30864003)(70586007)(316002)(8676002)(82310400003)(5660300002)(2616005)(7696005)(82740400003)(54906003)(356005)(86362001)(186003)(478600001)(336012)(83380400001)(36906005)(6666004)(70206006)(7636003)(107886003)(36756003)(110136005)(26005)(36860700001)(2906002)(47076005)(4326008)(426003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 07:23:43.4563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c532d37-faaf-4de3-f360-08d90628b9d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Implement "ethtool -m <dev>" subcommand using netlink and extend the
interface for new module EEPROM standards. Currently, ethtool supports
module EEPROM dumps of continuous memory regions, which are specified
using a pair of parameters - offset and length. But due to emergence of
new standards such as CMIS 4.0, which further extends possible
addressed memory, this approach shows its limitations.

Extend command line interface in order to support dumps of arbitrary
pages including CMIS 4.0-specific banked pages:
 ethtool -m <dev> [page N] [bank N] [i2c N]

Command example:
 # ethtool -m eth2 page 1 offset 0x80 length 0x20

 Offset          Values
 ------          ------
 0x0080:         11 00 23 80 00 00 00 00 00 00 00 08 ff 00 00 00
 0x0090:         00 00 01 a0 4d 65 6c 6c 61 6e 6f 78 20 20 20 20

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Makefile.am             |   1 +
 ethtool.c               |   4 +
 internal.h              |  10 +
 list.h                  |  34 ++++
 netlink/desc-ethtool.c  |  13 ++
 netlink/extapi.h        |   2 +
 netlink/module-eeprom.c | 425 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 489 insertions(+)
 create mode 100644 list.h
 create mode 100644 netlink/module-eeprom.c

diff --git a/Makefile.am b/Makefile.am
index e3e311d..9734bde 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,6 +37,7 @@ ethtool_SOURCES += \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
+		  netlink/module-eeprom.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
diff --git a/ethtool.c b/ethtool.c
index a8339c8..f7e8d28 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5881,11 +5881,15 @@ static const struct option args[] = {
 	{
 		.opts	= "-m|--dump-module-eeprom|--module-info",
 		.func	= do_getmodule,
+		.nlfunc = nl_getmodule,
 		.help	= "Query/Decode Module EEPROM information and optical diagnostics if available",
 		.xhelp	= "		[ raw on|off ]\n"
 			  "		[ hex on|off ]\n"
 			  "		[ offset N ]\n"
 			  "		[ length N ]\n"
+			  "		[ page N ]\n"
+			  "		[ bank N ]\n"
+			  "		[ i2c N ]\n"
 	},
 	{
 		.opts	= "--show-eee",
diff --git a/internal.h b/internal.h
index 27da8ea..2affebe 100644
--- a/internal.h
+++ b/internal.h
@@ -216,6 +216,16 @@ static inline int ethtool_link_mode_set_bit(unsigned int nr, u32 *mask)
 	return 0;
 }
 
+/* Struct for managing module EEPROM pages */
+struct ethtool_module_eeprom {
+	u32	offset;
+	u32	length;
+	u8	page;
+	u8	bank;
+	u8	i2c_address;
+	u8	*data;
+};
+
 /* Context for sub-commands */
 struct cmd_context {
 	const char *devname;	/* net device name */
diff --git a/list.h b/list.h
new file mode 100644
index 0000000..aa97fdd
--- /dev/null
+++ b/list.h
@@ -0,0 +1,34 @@
+#ifndef ETHTOOL_LIST_H__
+#define ETHTOOL_LIST_H__
+
+#include <unistd.h>
+
+/* Generic list utilities */
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	head->next->prev = new;
+	new->next = head->next;
+	new->prev = head;
+	head->next = new;
+}
+
+static inline void list_del(struct list_head *entry)
+{
+	entry->next->prev = entry->prev;
+	entry->prev->next = entry->next;
+	entry->next = NULL;
+	entry->prev = NULL;
+}
+
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+#endif
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index fe5d7ba..3aacf05 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -318,6 +318,17 @@ const struct pretty_nla_desc __tunnel_info_desc[] = {
 	NLATTR_DESC_NESTED(ETHTOOL_A_TUNNEL_INFO_UDP_PORTS, tunnel_udp),
 };
 
+const struct pretty_nla_desc __module_eeprom_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MODULE_EEPROM_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MODULE_EEPROM_HEADER, header),
+	NLATTR_DESC_U32(ETHTOOL_A_MODULE_EEPROM_OFFSET),
+	NLATTR_DESC_U32(ETHTOOL_A_MODULE_EEPROM_LENGTH),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_EEPROM_PAGE),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_EEPROM_BANK),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS),
+	NLATTR_DESC_BINARY(ETHTOOL_A_MODULE_EEPROM_DATA)
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -348,6 +359,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_ACT, cable_test),
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_ACT, cable_test_tdr),
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET, tunnel_info),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -383,6 +395,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_NTF, cable_test_ntf),
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_NTF, cable_test_tdr_ntf),
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY, tunnel_info),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 761cafb..72308e2 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -39,6 +39,7 @@ int nl_cable_test(struct cmd_context *ctx);
 int nl_cable_test_tdr(struct cmd_context *ctx);
 int nl_gtunnels(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
+int nl_getmodule(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -87,6 +88,7 @@ static inline void nl_monitor_usage(void)
 #define nl_cable_test		NULL
 #define nl_cable_test_tdr	NULL
 #define nl_gtunnels		NULL
+#define nl_getmodule		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
new file mode 100644
index 0000000..7298087
--- /dev/null
+++ b/netlink/module-eeprom.c
@@ -0,0 +1,425 @@
+/*
+ * module-eeprom.c - netlink implementation of module eeprom get command
+ *
+ * ethtool -m <dev>
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include <stddef.h>
+
+#include "../sff-common.h"
+#include "../qsfp.h"
+#include "../qsfp-dd.h"
+#include "../internal.h"
+#include "../common.h"
+#include "../list.h"
+#include "netlink.h"
+#include "parser.h"
+
+#define ETH_I2C_ADDRESS_LOW	0x50
+#define ETH_I2C_ADDRESS_HIGH	0x51
+#define ETH_I2C_MAX_ADDRESS	0x7F
+
+static struct cmd_params
+{
+	u8 dump_hex;
+	u8 dump_raw;
+	u32 offset;
+	u32 length;
+	u32 page;
+	u32 bank;
+	u32 i2c_address;
+} getmodule_cmd_params;
+
+static const struct param_parser getmodule_params[] = {
+	{
+		.arg		= "hex",
+		.handler	= nl_parse_u8bool,
+		.dest_offset	= offsetof(struct cmd_params, dump_hex),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "raw",
+		.handler	= nl_parse_u8bool,
+		.dest_offset	= offsetof(struct cmd_params, dump_raw),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "offset",
+		.handler	= nl_parse_direct_u32,
+		.dest_offset	= offsetof(struct cmd_params, offset),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "length",
+		.handler	= nl_parse_direct_u32,
+		.dest_offset	= offsetof(struct cmd_params, length),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "page",
+		.handler	= nl_parse_direct_u32,
+		.dest_offset	= offsetof(struct cmd_params, page),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "bank",
+		.handler	= nl_parse_direct_u32,
+		.dest_offset	= offsetof(struct cmd_params, bank),
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "i2c",
+		.handler	= nl_parse_direct_u32,
+		.dest_offset	= offsetof(struct cmd_params, i2c_address),
+		.min_argc	= 1,
+	},
+	{}
+};
+
+struct page_entry {
+	struct list_head link;
+	struct ethtool_module_eeprom *page;
+};
+
+static struct list_head page_list = LIST_HEAD_INIT(page_list);
+
+static int cache_add(struct ethtool_module_eeprom *page)
+{
+	struct page_entry *list_element;
+
+	if (!page)
+		return -1;
+	list_element = malloc(sizeof(*list_element));
+	if (!list_element)
+		return -ENOMEM;
+	list_element->page = page;
+
+	list_add(&list_element->link, &page_list);
+	return 0;
+}
+
+static void page_free(struct ethtool_module_eeprom *page)
+{
+	free(page->data);
+	free(page);
+}
+
+static void cache_del(struct ethtool_module_eeprom *page)
+{
+	struct ethtool_module_eeprom *entry;
+	struct list_head *head, *next;
+
+	list_for_each_safe(head, next, &page_list) {
+		entry = ((struct page_entry *)head)->page;
+		if (entry == page) {
+			list_del(head);
+			free(head);
+			page_free(entry);
+			break;
+		}
+	}
+}
+
+static void cache_free(void)
+{
+	struct ethtool_module_eeprom *entry;
+	struct list_head *head, *next;
+
+	list_for_each_safe(head, next, &page_list) {
+		entry = ((struct page_entry *)head)->page;
+		list_del(head);
+		free(head);
+		page_free(entry);
+	}
+}
+
+static struct ethtool_module_eeprom *page_join(struct ethtool_module_eeprom *page_a,
+					       struct ethtool_module_eeprom *page_b)
+{
+	struct ethtool_module_eeprom *joined_page;
+	u32 total_length;
+
+	if (!page_a || !page_b ||
+	    page_a->page != page_b->page ||
+	    page_a->bank != page_b->bank ||
+	    page_a->i2c_address != page_b->i2c_address)
+		return NULL;
+
+	total_length = page_a->length + page_b->length;
+	joined_page = calloc(1, sizeof(*joined_page));
+	joined_page->data = calloc(1, total_length);
+	joined_page->page = page_a->page;
+	joined_page->bank = page_a->bank;
+	joined_page->length = total_length;
+	joined_page->i2c_address = page_a->i2c_address;
+
+	if (page_a->offset < page_b->offset) {
+		memcpy(joined_page->data, page_a->data, page_a->length);
+		memcpy(joined_page->data + page_a->length, page_b->data, page_b->length);
+		joined_page->offset = page_a->offset;
+	} else {
+		memcpy(joined_page->data, page_b->data, page_b->length);
+		memcpy(joined_page->data + page_b->length, page_a->data, page_a->length);
+		joined_page->offset = page_b->offset;
+	}
+
+	return joined_page;
+}
+
+static struct ethtool_module_eeprom *cache_get(u32 page, u32 bank, u8 i2c_address)
+{
+	struct ethtool_module_eeprom *entry;
+	struct list_head *head, *next;
+
+	list_for_each_safe(head, next, &page_list) {
+		entry = ((struct page_entry *)head)->page;
+		if (entry->page == page && entry->bank == bank &&
+		    entry->i2c_address == i2c_address)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static int getmodule_page_fetch_reply_cb(const struct nlmsghdr *nlhdr,
+					 void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_EEPROM_DATA + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct ethtool_module_eeprom *lower_page;
+	struct ethtool_module_eeprom *response;
+	struct ethtool_module_eeprom *request;
+	struct ethtool_module_eeprom *joined;
+	u8 *eeprom_data;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	if (!tb[ETHTOOL_A_MODULE_EEPROM_DATA]) {
+		fprintf(stderr, "Malformed netlink message (getmodule)\n");
+		return MNL_CB_ERROR;
+	}
+
+	response = calloc(1, sizeof(*response));
+	if (!response)
+		return -ENOMEM;
+
+	request = (struct ethtool_module_eeprom *)data;
+	response->offset = request->offset;
+	response->page = request->page;
+	response->bank = request->bank;
+	response->i2c_address = request->i2c_address;
+	response->length = mnl_attr_get_payload_len(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
+	eeprom_data = mnl_attr_get_payload(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
+
+	response->data = malloc(response->length);
+	if (!response->data) {
+		free(response);
+		return -ENOMEM;
+	}
+	memcpy(response->data, eeprom_data, response->length);
+
+	if (!request->page) {
+		lower_page = cache_get(request->page, request->bank, response->i2c_address);
+		if (lower_page) {
+			joined = page_join(lower_page, response);
+			page_free(response);
+			cache_del(lower_page);
+			return cache_add(joined);
+		}
+	}
+
+	return cache_add(response);
+}
+
+static int page_fetch(struct nl_context *nlctx, const struct ethtool_module_eeprom *request)
+{
+	struct nl_socket *nlsock = nlctx->ethnl_socket;
+	struct nl_msg_buff *msg = &nlsock->msgbuff;
+	struct ethtool_module_eeprom *page;
+	int ret;
+
+	if (!request || request->i2c_address > ETH_I2C_MAX_ADDRESS)
+		return -EINVAL;
+
+	/* Satisfy request right away, if region is already in cache */
+	page = cache_get(request->page, request->bank, request->i2c_address);
+	if (page && page->offset <= request->offset &&
+	    page->offset + page->length >= request->offset + request->length) {
+		return 0;
+	}
+
+	ret = nlsock_prep_get_request(nlsock, ETHTOOL_MSG_MODULE_EEPROM_GET,
+				      ETHTOOL_A_MODULE_EEPROM_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	if (ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_LENGTH, request->length) ||
+	    ethnla_put_u32(msg, ETHTOOL_A_MODULE_EEPROM_OFFSET, request->offset) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_PAGE, request->page) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_BANK, request->bank) ||
+	    ethnla_put_u8(msg, ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS, request->i2c_address))
+		return -EMSGSIZE;
+
+	ret = nlsock_sendmsg(nlsock, NULL);
+	if (ret < 0)
+		return ret;
+	ret = nlsock_process_reply(nlsock, getmodule_page_fetch_reply_cb, (void *)request);
+	if (ret < 0)
+		return ret;
+
+	return nlsock_process_reply(nlsock, nomsg_reply_cb, NULL);
+}
+
+static bool page_available(struct ethtool_module_eeprom *which)
+{
+	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
+	u8 id = page_zero->data[SFF8636_ID_OFFSET];
+	u8 flat_mem = page_zero->data[2] & 0x80;
+
+	switch (id) {
+	case SFF8024_ID_SOLDERED_MODULE:
+	case SFF8024_ID_SFP:
+		return (!which->bank && which->page <= 1);
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP28:
+	case SFF8024_ID_QSFP_PLUS:
+		return (!which->bank && which->page <= 3);
+	case SFF8024_ID_QSFP_DD:
+		return !(flat_mem && which->page);
+	default:
+		return true;
+	}
+}
+
+static int decoder_prefetch(struct nl_context *nlctx)
+{
+	struct ethtool_module_eeprom *page_zero_lower = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
+	struct ethtool_module_eeprom request = {0};
+	u8 module_id = page_zero_lower->data[0];
+	int err = 0;
+
+	/* Fetch rest of page 00 */
+	request.i2c_address = ETH_I2C_ADDRESS_LOW;
+	request.offset = 128;
+	request.length = 128;
+	err = page_fetch(nlctx, &request);
+	if (err)
+		return err;
+
+	switch (module_id) {
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP28:
+	case SFF8024_ID_QSFP_PLUS:
+		memset(&request, 0, sizeof(request));
+		request.i2c_address = ETH_I2C_ADDRESS_LOW;
+		request.offset = 128;
+		request.length = 128;
+		request.page = 3;
+		break;
+	case SFF8024_ID_QSFP_DD:
+		memset(&request, 0, sizeof(request));
+		request.i2c_address = ETH_I2C_ADDRESS_LOW;
+		request.offset = 128;
+		request.length = 128;
+		request.page = 1;
+		break;
+	}
+
+	return page_fetch(nlctx, &request);
+}
+
+static void decoder_print(void)
+{
+	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
+	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
+
+	switch (module_id) {
+	case SFF8024_ID_SFP:
+		sff8079_show_all(page_zero->data);
+		break;
+	default:
+		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
+		break;
+	}
+}
+
+int nl_getmodule(struct cmd_context *ctx)
+{
+	struct ethtool_module_eeprom request = {0};
+	struct ethtool_module_eeprom *reply_page;
+	struct nl_context *nlctx = ctx->nlctx;
+	u32 dump_length;
+	u8 *eeprom_data;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_EEPROM_GET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-m";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	ret = nl_parser(nlctx, getmodule_params, &getmodule_cmd_params, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
+	if (getmodule_cmd_params.dump_hex && getmodule_cmd_params.dump_raw) {
+		fprintf(stderr, "Hex and raw dump cannot be specified together\n");
+		return 1;
+	}
+
+	request.i2c_address = ETH_I2C_ADDRESS_LOW;
+	request.length = 128;
+	ret = page_fetch(nlctx, &request);
+	if (ret)
+		goto cleanup;
+
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
+	if (getmodule_cmd_params.page || getmodule_cmd_params.bank ||
+	    getmodule_cmd_params.offset || getmodule_cmd_params.length)
+#endif
+		getmodule_cmd_params.dump_hex = true;
+
+	request.offset = getmodule_cmd_params.offset;
+	request.length = getmodule_cmd_params.length ?: 128;
+	request.page = getmodule_cmd_params.page;
+	request.bank = getmodule_cmd_params.bank;
+	request.i2c_address = getmodule_cmd_params.i2c_address ?: ETH_I2C_ADDRESS_LOW;
+
+	if (getmodule_cmd_params.dump_hex || getmodule_cmd_params.dump_raw) {
+		if (!page_available(&request))
+			goto err_invalid;
+
+		ret = page_fetch(nlctx, &request);
+		if (ret < 0)
+			return ret;
+		reply_page = cache_get(request.page, request.bank, request.i2c_address);
+		if (!reply_page)
+			goto err_invalid;
+
+		eeprom_data = reply_page->data + (request.offset - reply_page->offset);
+		dump_length = reply_page->length < request.length ? reply_page->length
+								  : request.length;
+		if (getmodule_cmd_params.dump_raw)
+			fwrite(eeprom_data, 1, request.length, stdout);
+		else
+			dump_hex(stdout, eeprom_data, dump_length, request.offset);
+	} else {
+		ret = decoder_prefetch(nlctx);
+		if (ret)
+			goto cleanup;
+		decoder_print();
+	}
+
+err_invalid:
+	ret = -EINVAL;
+cleanup:
+	cache_free();
+	return ret;
+}
-- 
2.26.2

