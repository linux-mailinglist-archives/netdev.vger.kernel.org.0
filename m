Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D821F38E88E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhEXOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:21:30 -0400
Received: from mail-sn1anam02on2047.outbound.protection.outlook.com ([40.107.96.47]:51214
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232486AbhEXOV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:21:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuBj5sY685r+EkJM2aRMa9rDe+nPG0LdfR+xUN5DA77LjYpSuLapq1ZjSie2vYKClxaUGRreXBQwCR1O+qoxN7XDLnbbuuNUV4O7cuRQdipr4yKKdA7s8iiGhY+AbGtfPwYRP+B4ND8pa1ZMUeMdeIIWI/nKMA4FFYzSY8lPqQwXJK3hJgWgEwomih4jLN5HIa1pDQ1x1GAPA3JWOXSNwvv3lzHI5C/TBDWQx5w6+uuq4EhSqEkITmw6b/VgDh1VisKFiXjOvG4MsK/Xsg56VO+OwPRkaMIUKFa1z9aqnpuz8kX1Q3UzpOvXso8CnK7CmkrDJt1W/Xby8YzFkHSmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTw3JRotI7dEjz0p65+A8PLSLSooDT8ERRm6Z0QNikM=;
 b=l8tkk0SMMuhIQ1CVVwWkXyErtSma6Ysreg52KL+fqLUP8IE6odttXKlf5bObgjb0TWYTwyz0Ix0GmXlxV40JqXq9N8EtEgbtc6vN+qTOMGA1wMAC+nqgD2gVrJWb6fsvVt9szajBHpRJHefVWtz9M98NpXwmBiMmrvRDB6pa4uGUyvSBR7jwitKle971/0B+lICEtQ+AUoI2u+RaDsQSpvIx2nattmwZaceldKz/mFKtJu1bFq1KQ6dr8rW9zwSZyEdz6pj1tVArLxijib4kXEnbEXd06mAotidPTq5lXWBXd6pprXZNPCF6CEYgTVOPaoZ4YKTI4RYYuNQb723ZwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTw3JRotI7dEjz0p65+A8PLSLSooDT8ERRm6Z0QNikM=;
 b=cF9lJfMBg/hfdUqU75Kfhh0jFltmpBZ0BULomyUSCz5AiqaZqICgheCQrXOiQ+isImK2FY7rXiVsu/jofjFCyBDlht3cg4sjRKZ1eZwwiFQOXBk5c3WdxKQoqa30kMwWspz83w8+osFbCi+gN4CAQ0880D+O9UIi07E6XJVTvOdTuveXZdTbH3HnfRCtsn3Xi3zzlWZhf+Rg5jiM1l6oAe77bx7OvMGMirGKr1RAvhD7NtHkBM0pAF147ba0UHqSd0yXh04S54MZDSZ7m6GgkOVn8VH9VUNc+BHe+J+x8sywIbvqt1DG/Kb/t6i8OlV+VxgX5WD1Pj+7aOT0e3YOOg==
Received: from BN9PR03CA0220.namprd03.prod.outlook.com (2603:10b6:408:f8::15)
 by BYAPR12MB3128.namprd12.prod.outlook.com (2603:10b6:a03:dd::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 14:19:59 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::8e) by BN9PR03CA0220.outlook.office365.com
 (2603:10b6:408:f8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend
 Transport; Mon, 24 May 2021 14:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 14:19:58 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:19:57 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 14:19:56 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v2 1/4] ethtool: Add netlink handler for getmodule (-m)
Date:   Mon, 24 May 2021 17:18:57 +0300
Message-ID: <1621865940-287332-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71f09bf8-8a98-47dc-7ce6-08d91ebf0324
X-MS-TrafficTypeDiagnostic: BYAPR12MB3128:
X-Microsoft-Antispam-PRVS: <BYAPR12MB31280A63D19650C6ADEA6C4CD4269@BYAPR12MB3128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +m1mA9GdqpMMfpVHOiBrYxUT2mp+00CUFojKmCi8fMcjoAWhKFFJ4ipNXCw6VITHKYGrnk/zYI+ibhSaWZ9n5mJHaQaiMQEacZoOy4FYgi2gLEVXMJNQD9LDjOXCrySrBNFrcvTvcj2yPeA1QHqs0NVUAPgr8WMGRXmQMWcV6Cu80l8EQfVaYGWkNxcThbWm0QHxh+lCJjaB+esuInIFKykqT6A85oWrwn6pM9VVeT+1ar6RVFNpFwbcSVcgq2zr4Xqi7kdza0kTPQwFw5Wj8gsDRRtf8Ljad25U/A5ZGLe/PE4AvY/01IXSQFJdv9mksSGGkybwOoAyhZMv2Eq6Boum4RUvVypOzPKLlZYbxllXDA6/IiB/BM5rmLxWW0R4cDxceYG9UhE8nguHLlfdKy2q2ZPoYJr8ZasIRYScwbKgXTOanjDPWBq50fRZzPmHO/OmLjmQnbhdq49oc+VR6uA75BKcCxIf5F8cPR02wnIlGMRhUMxQkoFEVhq+8BulMzHD0Nf5RM44Q57BDOfFJ9ZZw/2r1sKYzb5y21KDltf3f/xOcdVbbFqC57Q7ol2PIZyHPj+Anwis7WGTntYFLy6rN8RVoJ9BviBrt6OBByPl7CUdM0rRDkfQFS1lKnA77uG+RCb2IRPqG0vaxpLEEQtSc7JIM0tFzeir7mfOVOI=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(36756003)(82310400003)(70586007)(86362001)(7696005)(8676002)(47076005)(70206006)(478600001)(36906005)(7636003)(36860700001)(316002)(110136005)(54906003)(82740400003)(83380400001)(30864003)(2616005)(426003)(336012)(5660300002)(186003)(2906002)(4326008)(26005)(356005)(8936002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 14:19:58.7477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f09bf8-8a98-47dc-7ce6-08d91ebf0324
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3128
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
 netlink/module-eeprom.c | 404 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 468 insertions(+)
 create mode 100644 list.h
 create mode 100644 netlink/module-eeprom.c

diff --git a/Makefile.am b/Makefile.am
index 75c2456..6abd2b7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -38,6 +38,7 @@ ethtool_SOURCES += \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
 		  netlink/stats.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
+		  netlink/module-eeprom.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
diff --git a/ethtool.c b/ethtool.c
index 8ed5a33..33a0a49 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5897,11 +5897,15 @@ static const struct option args[] = {
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
index 8ea7c53..d6fc4e2 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -363,6 +363,17 @@ static const struct pretty_nla_desc __stats_desc[] = {
 	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GRP, stats_grp),
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
@@ -396,6 +407,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_GET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -434,6 +446,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_GET_REPLY, fec),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_NTF, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET_REPLY, stats),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 7015907..91bf02b 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -44,6 +44,7 @@ int nl_sfec(struct cmd_context *ctx);
 bool nl_gstats_chk(struct cmd_context *ctx);
 int nl_gstats(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
+int nl_getmodule(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -97,6 +98,7 @@ static inline void nl_monitor_usage(void)
 #define nl_sfec			NULL
 #define nl_gstats_chk		NULL
 #define nl_gstats		NULL
+#define nl_getmodule		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
new file mode 100644
index 0000000..16fe09e
--- /dev/null
+++ b/netlink/module-eeprom.c
@@ -0,0 +1,404 @@
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
+		return ret;
+
+	if (getmodule_cmd_params.dump_hex && getmodule_cmd_params.dump_raw) {
+		fprintf(stderr, "Hex and raw dump cannot be specified together\n");
+		return -EINVAL;
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
+	if (request.page && !request.offset)
+		request.offset = 128;
+
+	if (getmodule_cmd_params.dump_hex || getmodule_cmd_params.dump_raw) {
+		ret = page_fetch(nlctx, &request);
+		if (ret < 0)
+			goto cleanup;
+		reply_page = cache_get(request.page, request.bank, request.i2c_address);
+		if (!reply_page) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
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
+cleanup:
+	cache_free();
+	return ret;
+}
-- 
2.18.2

