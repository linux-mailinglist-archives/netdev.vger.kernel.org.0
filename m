Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911AE3A7E7A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhFOM5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:57:23 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:62803
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230395AbhFOM5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 08:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGdYM0TDS/1i2aip7e5RjAlrOXzKGbI3Tm6thzDmJ/EQoor1iBCerhcjo0Dt9autMnj0Qn53sr5fAG+T8LROe7nxYqcSuh7DsjJlXwkldfEfqZwtRtXpoZXUIFei48f2RccGfSd525D4j/yBGemckrsolRI2eey4Gg7T7Pn/d+/a0i8O1x4gkrdhXnVOw/R9iXEDjrW5Tn29Hb9clZEAJOoS5waJOsnbMQpyUTMa8AtmbdIVkDghikNgxiwTS++eX17AZDqi8V/Ssl1sLtYxqEKbnkPOO3E9jPrtSHKJyJ+GF4ljQljmEhSZj0KVFrFt5QNtDNayXgslekdAvuiRBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4m6iAwnEJTuFJ5Icoep6FbtC1qg7V3ZhtuAePvECV0=;
 b=X1PbHVe+A1kJYIIlENgh1RLyWZUr2Fao8lZMJ3/ra3E7bKF1qdDzaRZUCeiWm8ML342D+QdxobMzWIW5lV/NjDOA/tQn5VaCYEeCreDD0ikAs4B0kM0ujegSFkpwMH3dUy2uTmM7fHcDKNKGnLn66AxsmrrRJ1SxhWYGtDf1QTNZP8hHZOZ/KTciFRh/zU1ZYHcFIxj3fAj42ZKDjVtTNNCPyCmBexd8XZCprHMp7LlQ5YRDxvRPRJsVB5cK029dOn8Emt1DeKB54yi5kMqcThmcJbiJJE48WfbPE4kK7ncQ1/pto1r0/aEl9EgSHtB7cP39WU1gKEPY/rO/7fT8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4m6iAwnEJTuFJ5Icoep6FbtC1qg7V3ZhtuAePvECV0=;
 b=jT+n1voCPycJZWEQNmV9hif6z9L607jWRXvFXk/8snFcpbcE6aAjfUXbDouGWh2bL6FZD/+wAC4OljXmwe1cd7IyqqixGuMZJ9h8SGnezc/8SNy6c6bKRTx6MrABHT834k9sFIDDBnEljuFu03Oh7WfSN5TWDGNx2IinrXpgtj4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0124.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Tue, 15 Jun 2021 12:55:10 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 12:55:10 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 2/2] net: marvell: prestera: Add matchall support
Date:   Tue, 15 Jun 2021 15:54:44 +0300
Message-Id: <20210615125444.31538-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615125444.31538-1-vadym.kochan@plvision.eu>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 12:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95082e23-da20-43a4-bc04-08d92ffccee7
X-MS-TrafficTypeDiagnostic: HE1P190MB0124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB01243BF703E459BDEE046A7895309@HE1P190MB0124.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:222;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8u9LZ6CEP94tW7baUJstX9NOliiqriNA3NWcRgOEYD92qTYEBNLyY8dfSmfxhHW5FMFZLpMidsAF0QpdhpSraSYuJS76QqUsB8n4ne9g3eFRmex0vTagcHh5/8GspHnafpGQn3RuF5ojg4EbbyKVtiwI+qELvyLCcdqMBx5bTQSqJE4axKQOw3NHRUKSx+BMMSAYPv+8A4uQWtHmnTXyfK6OCNIYEGYkZfM+Yyd0ziOm46vCoDi9teCj7dsQNT/onPkxMwNoRMtdAggY3hnyShx2qoFgYarOBuknT0JaCu0jXNWONC/uP1O4Zc39GwjGz/teMsAc/c7lEbIqA6u7afHsPKFjjWe4cz/Wz49CdRC2CNH+YQp6vtF/KdHwB8TMUq8u2DYgzt1ryYbXaC4yL9ttK0HkPgHQcltPuy8o654mus54uC3ev/4q3UVI4IcpMe1yg+pJTGMg79eIzHGC0QYQN9H58Wm9vE7uOP1juk54ygRkKFAqRlskJhrX96gCVLWGTqpqBHruPQ+x/4ApfQ0U1DPCuBaMsiTJm3KUz37hae/xn0rNtX5jf8jVwa5hu2pOk+IdpsEC1qfcouHFwepmGLpqSXf8LsBw0siVm3sOPZzJd32gAsZX77MJ+1vf11adgPchxrrBPj5vP7Htw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(186003)(316002)(86362001)(6666004)(36756003)(2616005)(6506007)(956004)(44832011)(8936002)(8676002)(6512007)(4326008)(52116002)(6486002)(478600001)(110136005)(38350700002)(26005)(38100700002)(54906003)(1076003)(83380400001)(30864003)(7416002)(2906002)(5660300002)(66946007)(66556008)(16526019)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BprMd8G7TihjC3j3moE2b3bHEfd8+zJoWMoqxcJuSq0IgTevsSjlc7M7uQP6?=
 =?us-ascii?Q?6UOWb+3xj+PUxJrzto2Rr8K8uZAeo8xAv/PawusK+Wlnf6DsRWIAdUg9Dyta?=
 =?us-ascii?Q?bRli5NNsabr5PcPKLCa6yKckAo6RWLukN8oR7Ob1gM9dxhqpOd+jYYqB2YPj?=
 =?us-ascii?Q?xN2h8m/Ct7tyTSlG1mHiFoWuVfQYZ5YA8ccgv94+jmbyrVBgNVHorkbpvibC?=
 =?us-ascii?Q?HaYqBbohlsVO0MrKUO9exyVxe98jPufrSi0k+uKEzjb0cyRqpJMYdin/gaaP?=
 =?us-ascii?Q?IJuQzUsUXd3POT1XUOud3eiZNSDbqv0Yhzg8Zinn+3SBH5rXzUUZrA+UrnAx?=
 =?us-ascii?Q?unnog6SJuo8/yByzgymNY2mn07712vaA/VsFtPnrPFmH1NxQFmftH6blJRAi?=
 =?us-ascii?Q?6Gnz5L7Xp4puCvbH0CsH4f3J82PwPVlI5VJVD11Gqk3fdN/bGJwz87OL609W?=
 =?us-ascii?Q?zj4zHy8mO9H/hCa6HqU9i2pPPTjZBKyH/qrde2CtBKALBqQ2Bfc7Zj0tpDWl?=
 =?us-ascii?Q?StCqDx7MXdM3BZXJHi8M0wF89CDJxN/B4oxoFO4Se4AmRXm1ScgUafrZ6O4N?=
 =?us-ascii?Q?GNqH0vWaz5Rk3QO/bvHfr6MK9dASab2ALEn5Q0dZzJAqgr19zwo5MCHFh6k9?=
 =?us-ascii?Q?3PvGYDOrfOPw59V2TzCieeHsSgyatCXKyiWKIYHEMGSDJniAq4FSiwO5uObC?=
 =?us-ascii?Q?yEwZdkGcgNm1CQ5F1nO5x3ElSnRE0qqc+FM3m88GvhjEhugXgnsLWUmL3Msl?=
 =?us-ascii?Q?xdUbf76Ir4u+THnM6bmiefqwHcn8YwgMDNbrK8/bDTd/7nGiDK/BKkUhRW6L?=
 =?us-ascii?Q?WfOwtrbWhEw5BoMOgc4rk6o9h3NDUsG9zZo24U9cVRgpGBl8mmYvQLXv+qqH?=
 =?us-ascii?Q?eQ4OQdDOn4Oz27AdwGbfx0IF4CuxSvvi3cDU4drqMKzFLs2VOdh+ZCCqxZ4H?=
 =?us-ascii?Q?heM5vG+68PmcbCG6JlcfCYRtwvSe42VcWkEClM7H3uALd869reRvQHaO7SB+?=
 =?us-ascii?Q?5mNWdzgmAQ2IYX7NaA3k715XkJMj3qBdjL0g2YKg7GUQGe2k87ukxyJq3Dzn?=
 =?us-ascii?Q?Dig/pOnd/CeYBKnAWnancGQIrKygYcvUOSBbTF1zsYXFf869g4D5UsldLKUL?=
 =?us-ascii?Q?hVNZhSsFGY/PGaJnUdTARLmF1REjnwSktSPePkOVxFqJp5n6PJA4mc6JqwQL?=
 =?us-ascii?Q?ZizOl5tBnTwJlD9DsEOTqwmVYA9fu7rqFJSDk85Eop8nrTl7lZ5grQliSBPY?=
 =?us-ascii?Q?c+poOrMiGHE/iRa/DqbygtSjV4K8o5tb90Sma7yXnzFBSKkOgC3Pj8kUar8S?=
 =?us-ascii?Q?kzKJ8oNseoC4drBqOVW+3NVc?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 95082e23-da20-43a4-bc04-08d92ffccee7
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 12:55:10.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWrmA7dVKG8ARuS6VhBk++aER05CbjyNDqX3X0lGJDrGUg2bUfSUblq9IIY3gIOgsQQBSZ+MWbEsVRsNs81j72MUECzohuQMnddfw+rhRWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

- Introduce matchall filter support
- Add SPAN API to configure port mirroring.
- Add tc mirror action.

At this moment, only mirror (egress) action is supported.

Example:
    tc filter ... action mirred egress mirror dev DEV

Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../ethernet/marvell/prestera/prestera_acl.c  |   2 +
 .../ethernet/marvell/prestera/prestera_acl.h  |   3 +-
 .../ethernet/marvell/prestera/prestera_flow.c |  19 ++
 .../ethernet/marvell/prestera/prestera_hw.c   |  69 +++++
 .../ethernet/marvell/prestera/prestera_hw.h   |   6 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +
 .../ethernet/marvell/prestera/prestera_span.c | 245 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_span.h |  20 ++
 10 files changed, 374 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 42327c4afdbf..0609df8b913d 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -3,6 +3,6 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
-			   prestera_flower.o
+			   prestera_flower.o prestera_span.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index bbbe780d0886..f18fe664b373 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -172,6 +172,7 @@ struct prestera_event {
 };
 
 struct prestera_switchdev;
+struct prestera_span;
 struct prestera_rxtx;
 struct prestera_trap_data;
 struct prestera_acl;
@@ -181,6 +182,7 @@ struct prestera_switch {
 	struct prestera_switchdev *swdev;
 	struct prestera_rxtx *rxtx;
 	struct prestera_acl *acl;
+	struct prestera_span *span;
 	struct list_head event_handlers;
 	struct notifier_block netdev_nb;
 	struct prestera_trap_data *trap_data;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 817f78b1e90c..5165ac96a70e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -6,6 +6,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_acl.h"
+#include "prestera_span.h"
 
 struct prestera_acl {
 	struct prestera_switch *sw;
@@ -149,6 +150,7 @@ int prestera_acl_block_bind(struct prestera_flow_block *block,
 	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
 	if (!binding)
 		return -ENOMEM;
+	binding->span_id = PRESTERA_SPAN_INVALID_ID;
 	binding->port = port;
 
 	err = prestera_hw_acl_port_bind(port, block->ruleset->id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 935c79a26036..2f129eb55547 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -28,14 +28,15 @@ enum prestera_acl_rule_action {
 	PRESTERA_ACL_RULE_ACTION_TRAP
 };
 
-struct prestera_switch;
 struct prestera_port;
+struct prestera_switch;
 struct prestera_acl_rule;
 struct prestera_acl_ruleset;
 
 struct prestera_flow_block_binding {
 	struct list_head list;
 	struct prestera_port *port;
+	int span_id;
 };
 
 struct prestera_flow_block {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index b818dd871512..b350082a1815 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -7,10 +7,25 @@
 #include "prestera.h"
 #include "prestera_acl.h"
 #include "prestera_flow.h"
+#include "prestera_span.h"
 #include "prestera_flower.h"
 
 static LIST_HEAD(prestera_block_cb_list);
 
+static int prestera_flow_block_mall_cb(struct prestera_flow_block *block,
+				       struct tc_cls_matchall_offload *f)
+{
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return prestera_span_replace(block, f);
+	case TC_CLSMATCHALL_DESTROY:
+		prestera_span_destroy(block);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
 					 struct flow_cls_offload *f)
 {
@@ -41,6 +56,8 @@ static int prestera_flow_block_cb(enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return prestera_flow_block_flower_cb(block, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return prestera_flow_block_mall_cb(block, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -163,6 +180,8 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
 	if (!tc_can_offload(port->dev))
 		prestera_acl_block_disable_dec(block);
 
+	prestera_span_destroy(block);
+
 	err = prestera_acl_block_unbind(block, port);
 	if (err)
 		goto error;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 42b8d9f56468..c1297859e471 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -56,6 +56,11 @@ enum prestera_cmd_type_t {
 
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
+	PRESTERA_CMD_TYPE_SPAN_GET = 0x1100,
+	PRESTERA_CMD_TYPE_SPAN_BIND = 0x1101,
+	PRESTERA_CMD_TYPE_SPAN_UNBIND = 0x1102,
+	PRESTERA_CMD_TYPE_SPAN_RELEASE = 0x1103,
+
 	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
 
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
@@ -377,6 +382,18 @@ struct prestera_msg_acl_ruleset_resp {
 	u16 id;
 };
 
+struct prestera_msg_span_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u8 id;
+} __packed __aligned(4);
+
+struct prestera_msg_span_resp {
+	struct prestera_msg_ret ret;
+	u8 id;
+} __packed __aligned(4);
+
 struct prestera_msg_stp_req {
 	struct prestera_msg_cmd cmd;
 	u32 port;
@@ -1055,6 +1072,58 @@ int prestera_hw_acl_port_unbind(const struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
+{
+	struct prestera_msg_span_resp resp;
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_SPAN_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*span_id = resp.id;
+
+	return 0;
+}
+
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
+{
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.id = span_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_BIND,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_span_unbind(const struct prestera_port *port)
+{
+	struct prestera_msg_span_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_UNBIND,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id)
+{
+	struct prestera_msg_span_req req = {
+		.id = span_id
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SPAN_RELEASE,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 {
 	struct prestera_msg_port_attr_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index c01d376574d2..546d5fd8240d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -188,6 +188,12 @@ int prestera_hw_acl_port_bind(const struct prestera_port *port,
 int prestera_hw_acl_port_unbind(const struct prestera_port *port,
 				u16 ruleset_id);
 
+/* SPAN API */
+int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
+int prestera_hw_span_unbind(const struct prestera_port *port);
+int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ea683b5a8a2e..d2a738da368a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera_hw.h"
 #include "prestera_acl.h"
 #include "prestera_flow.h"
+#include "prestera_span.h"
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
 #include "prestera_ethtool.h"
@@ -909,6 +910,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_acl_init;
 
+	err = prestera_span_init(sw);
+	if (err)
+		goto err_span_init;
+
 	err = prestera_devlink_register(sw);
 	if (err)
 		goto err_dl_register;
@@ -928,6 +933,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 err_lag_init:
 	prestera_devlink_unregister(sw);
 err_dl_register:
+	prestera_span_fini(sw);
+err_span_init:
 	prestera_acl_fini(sw);
 err_acl_init:
 	prestera_event_handlers_unregister(sw);
@@ -947,6 +954,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_destroy_ports(sw);
 	prestera_lag_fini(sw);
 	prestera_devlink_unregister(sw);
+	prestera_span_fini(sw);
 	prestera_acl_fini(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
new file mode 100644
index 000000000000..d399e47fb429
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_acl.h"
+#include "prestera_span.h"
+
+struct prestera_span_entry {
+	struct list_head list;
+	struct prestera_port *port;
+	refcount_t ref_count;
+	u8 id;
+};
+
+struct prestera_span {
+	struct prestera_switch *sw;
+	struct list_head entries;
+};
+
+static struct prestera_span_entry *
+prestera_span_entry_create(struct prestera_port *port, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&entry->ref_count, 1);
+	entry->port = port;
+	entry->id = span_id;
+	list_add_tail(&entry->list, &port->sw->span->entries);
+
+	return entry;
+}
+
+static void prestera_span_entry_del(struct prestera_span_entry *entry)
+{
+	list_del(&entry->list);
+	kfree(entry);
+}
+
+static struct prestera_span_entry *
+prestera_span_entry_find_by_id(struct prestera_span *span, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+
+	list_for_each_entry(entry, &span->entries, list) {
+		if (entry->id == span_id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static struct prestera_span_entry *
+prestera_span_entry_find_by_port(struct prestera_span *span,
+				 struct prestera_port *port)
+{
+	struct prestera_span_entry *entry;
+
+	list_for_each_entry(entry, &span->entries, list) {
+		if (entry->port == port)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static int prestera_span_get(struct prestera_port *port, u8 *span_id)
+{
+	u8 new_span_id;
+	struct prestera_switch *sw = port->sw;
+	struct prestera_span_entry *entry;
+	int err;
+
+	entry = prestera_span_entry_find_by_port(sw->span, port);
+	if (entry) {
+		refcount_inc(&entry->ref_count);
+		*span_id = entry->id;
+		return 0;
+	}
+
+	err = prestera_hw_span_get(port, &new_span_id);
+	if (err)
+		return err;
+
+	entry = prestera_span_entry_create(port, new_span_id);
+	if (IS_ERR(entry)) {
+		prestera_hw_span_release(sw, new_span_id);
+		return PTR_ERR(entry);
+	}
+
+	*span_id = new_span_id;
+	return 0;
+}
+
+static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
+{
+	struct prestera_span_entry *entry;
+	int err;
+
+	entry = prestera_span_entry_find_by_id(sw->span, span_id);
+	if (!entry)
+		return false;
+
+	if (!refcount_dec_and_test(&entry->ref_count))
+		return 0;
+
+	err = prestera_hw_span_release(sw, span_id);
+	if (err)
+		return err;
+
+	prestera_span_entry_del(entry);
+	return 0;
+}
+
+static int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
+				  struct prestera_port *to_port)
+{
+	int err;
+	u8 span_id;
+	struct prestera_switch *sw = binding->port->sw;
+
+	if (binding->span_id != PRESTERA_SPAN_INVALID_ID)
+		/* port already in mirroring */
+		return -EEXIST;
+
+	err = prestera_span_get(to_port, &span_id);
+	if (err)
+		return err;
+
+	err = prestera_hw_span_bind(binding->port, span_id);
+	if (err) {
+		prestera_span_put(sw, span_id);
+		return err;
+	}
+
+	binding->span_id = span_id;
+	return 0;
+}
+
+static int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
+{
+	int err;
+
+	err = prestera_hw_span_unbind(binding->port);
+	if (err)
+		return err;
+
+	err = prestera_span_put(binding->port->sw, binding->span_id);
+	if (err)
+		return err;
+
+	binding->span_id = PRESTERA_SPAN_INVALID_ID;
+	return 0;
+}
+
+int prestera_span_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f)
+{
+	struct prestera_flow_block_binding *binding;
+	__be16 protocol = f->common.protocol;
+	struct flow_action_entry *act;
+	struct prestera_port *port;
+	int err;
+
+	if (!flow_offload_has_one_action(&f->rule->action)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (f->common.chain_index) {
+		NL_SET_ERR_MSG(f->common.extack, "Only chain 0 is supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &f->rule->action.entries[0];
+
+	if (act->id != FLOW_ACTION_MIRRED)
+		return -EOPNOTSUPP;
+
+	if (protocol != htons(ETH_P_ALL))
+		return -EOPNOTSUPP;
+
+	/* TODO: add prio check */
+
+	if (!prestera_netdev_check(act->dev)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only switchdev port is supported");
+		return -EINVAL;
+	}
+
+	port = netdev_priv(act->dev);
+	list_for_each_entry(binding, &block->binding_list, list) {
+		err = prestera_span_rule_add(binding, port);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(binding,
+					     &block->binding_list, list)
+		prestera_span_rule_del(binding);
+	return err;
+}
+
+void prestera_span_destroy(struct prestera_flow_block *block)
+{
+	struct prestera_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		prestera_span_rule_del(binding);
+}
+
+int prestera_span_init(struct prestera_switch *sw)
+{
+	struct prestera_span *span;
+
+	span = kzalloc(sizeof(*span), GFP_KERNEL);
+	if (!span)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&span->entries);
+
+	sw->span = span;
+	span->sw = sw;
+
+	return 0;
+}
+
+void prestera_span_fini(struct prestera_switch *sw)
+{
+	struct prestera_span *span = sw->span;
+
+	WARN_ON(!list_empty(&span->entries));
+	kfree(span);
+}
+
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.h b/drivers/net/ethernet/marvell/prestera/prestera_span.h
new file mode 100644
index 000000000000..f0644521f78a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_SPAN_H_
+#define _PRESTERA_SPAN_H_
+
+#include <net/pkt_cls.h>
+
+#define PRESTERA_SPAN_INVALID_ID -1
+
+struct prestera_switch;
+struct prestera_flow_block;
+
+int prestera_span_init(struct prestera_switch *sw);
+void prestera_span_fini(struct prestera_switch *sw);
+int prestera_span_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f);
+void prestera_span_destroy(struct prestera_flow_block *block);
+
+#endif /* _PRESTERA_SPAN_H_ */
-- 
2.17.1

