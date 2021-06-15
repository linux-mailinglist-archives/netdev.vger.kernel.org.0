Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484913A7E78
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhFOM5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:57:19 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:62803
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230360AbhFOM5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 08:57:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLrmCioBRx/fwwzJIlZcBOUfVPCQxC9oMb8U/zQDOIQ462E6j2CbKxVDDZo6wKgDa4ouDQucI/vhogU5/hDEN3PcyDmPkpe3OYr1TK8tjvlPo113ZZZzmgUk6ayQhnY9HysUoGSmU4afwa5Ko96T6Kwurhh2/Sr251k9p/c2J+f0PhrTImST7OJPBkzK5szg4t7JWJO2IUrr7Dy0kLjeocfaLqtaqe/lqIqh0t1fVXaa7f7hWfLZ3Au4EAj/WsJ2YwPkL9ClwNzD/bGZdNJ9ZF1fuVtptumWJssKWgIXgfa6605SiqLZ83nXq7Z59gOFEXqWN30IABPpBIzFVfZYxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsoBY69a1PdhLwqCEuj8D62Pa0iq1wbm0f5W3xxxw9s=;
 b=hHp0mxkO8SF8rnzucx/tDH1wYyk0Y6ICajJhok2rR/ItpNgQGJqkqFLPA1ZnNTwmAIXGwG78X66Jpe9yTagcDAXTZ2C2gZ3V7LaI1t+Wyk9Z0hlcCCRYwrMmykPok3hrB1oFBgy8gqBNBmxa2SmNm+3WvavkE8X6WO0xJLS4osdbYJc8PXEFyLIPyKCJFtMxRbmXngz/8SjaCo7q6upOysiHB4cr5moUF1k6IwBsu0MfC0KuNThNG5503KeazDtOWpERNqxGV6sAwqqX+yWW/PFcdvl0PiyOwPir9iu3Xt4RykGYTpWufYVqsnnCfUESPk0fYq7QbXfeUYmmMWEzTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsoBY69a1PdhLwqCEuj8D62Pa0iq1wbm0f5W3xxxw9s=;
 b=mJWFV1VU5jq5KkkQP5iLBiVY57g0ytGr5omyi6R7C2QfhsMxJ1tTJ0lZCDqsZyKWtnjLMgRivm6qww8qF7KBPDWXw5lADx12JBuCLHnSRAG7t1EOG/FwO+IrL0MR22A2UWxu3l2vlzJy48XMN2MvzmdWF7Mk+RVYtm97neOoHA0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0124.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Tue, 15 Jun 2021 12:55:09 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 12:55:09 +0000
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
Subject: [PATCH net-next 1/2] net: marvell: Implement TC flower offload
Date:   Tue, 15 Jun 2021 15:54:43 +0300
Message-Id: <20210615125444.31538-2-vadym.kochan@plvision.eu>
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
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 12:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ba68f68-defa-4582-6e11-08d92ffcce30
X-MS-TrafficTypeDiagnostic: HE1P190MB0124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0124C31D0F4E802A918B1BB095309@HE1P190MB0124.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:132;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DEE6VkBW8Y3Ov+DO9MVMeuhQd1Wt399GfDcZ9YoIxUtDz8nivCK1tVkxDC1o7aol5tcjyIamZ1lEpAywh9NnmvP4/3iAC4M08RbaKqBbuALZg7G5B2oRKIPBZM51luHkc0u00de3tJZYH6W9LJ68phlvaXarwx60GNnIUXJ4CMzUcjt8EabLD0VfcYRfr966ORTOW8a1BSB5kkiVSilxogXnxlcYtLY4ZLKPhf/crg0kMlhO25KY+kSBqEmRjL36b5EnMbDE5/KveV5rbtqUgnFjzDx8gdl5Hy/wQPrmLXms3DD+MmWMtDCEKZRvtQOKkeRPqg1HrkpZhPk2QQQF2tDLGHfzhWLi3rProCqqcY9ZUiZcN1ICS3PbfQqHpk/OdlbW5CnM1IXqabe7Rhb1xpp4LZb5Gp7M4ZrBbr7aObbpHP7Gaia4CQxK00mcfJTmNe/BjSA+Bsshn0qJT1kZ2X5008T4nJVCk+wWmekqvahVgHs8mNjul4ttcwitPRX0Twm1UsB90YZuLHT0A5FKh52otIbs5gZ5Zn9TGfyb8jz5uHzfMHPpQsjFzTbr2YNawMP1EN1Et23YhxHOCDbFfpvm4WXg62QUw4oGjGESNce98Tv2b2AguFsdvGZfo7byo5G00fEmdLWBxo7fU4mRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(186003)(316002)(86362001)(6666004)(36756003)(2616005)(6506007)(956004)(44832011)(8936002)(8676002)(6512007)(4326008)(52116002)(6486002)(478600001)(110136005)(38350700002)(26005)(38100700002)(54906003)(1076003)(83380400001)(30864003)(7416002)(2906002)(5660300002)(66946007)(66556008)(16526019)(66476007)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nTHcNcHeXYtKjkkzFOweq+j13d5DLDiq2uNkxXW32O/HTUh56Ig514g8c+RO?=
 =?us-ascii?Q?YKXn/buK0e223oCF4X9Aaj0TYgjNP+EHcxzyJjopX/0dNY5cTn89aghhgruY?=
 =?us-ascii?Q?DABohtj9tb+Xiq9v+2JLqUkM2VbHxDz7bcLhxMRpEFKe9QMJB9yVAbeHVXXV?=
 =?us-ascii?Q?yhYD1MK9LOo+Ah45OqTT4iP8nHerbo8eVTPuGPHKsYy7/z8hf84XIHkSNkQe?=
 =?us-ascii?Q?ci/ghaLYQtYRvIBgxyhjgubo/mWSi6a6WMwSjRg7T+wPMejLJoNPkYRtfKF9?=
 =?us-ascii?Q?MK8MOGS7LUaJF4OafJzrw9CZkZPKDiDY38ib4whru5GnuZpVxQoYrQ50B61N?=
 =?us-ascii?Q?hV1mBRiWBn4oWdzGyz4ZOEBZ75MWnxvlcHiMCCxoi3BM2Q5E4f6vqyod31ed?=
 =?us-ascii?Q?bz2pNDuMsMAIjEodE3JdPHsuFdwIo7/t9HDPXlUoE1T0uVSFd/Otdq/Gwl+j?=
 =?us-ascii?Q?nTqoqCN3kIeExNbUTFnyUPjAemCr4rDH2P9MwaBxWnL0hi9Rj9uX9LGmMVli?=
 =?us-ascii?Q?1pMbosu/K8CiweYgUOEoGRo62K98FqzvkBKMWTKW7n2lrV88p0TukbZJyCN/?=
 =?us-ascii?Q?X5og+XHFeoWN8VbfFzDn4H0AXtCkf+OtqVWMVuva0rqL0+vKfHJeWETYw1Hm?=
 =?us-ascii?Q?NDLyZMbRWli+us05CyskGYkW/rFlLsmkGCjMK8h/Zoq2zwPv504fNJCGNOGb?=
 =?us-ascii?Q?SurVHrgLIr8e4CscWWf9SU2bQPeetC7TBZZh2CHmvK0s21LA6xNp08q6g9U9?=
 =?us-ascii?Q?JJzlwVhAA7+UlAaNabX3IbhAq8WVbaSC03bUMDfMF7qJXOjD3+vvQsQQBLE1?=
 =?us-ascii?Q?7hIdmB/9oC0+w1eKHQb80C8dOP9cVinvZuBcKjhLnYUKSW5m/zhDZWDolyl4?=
 =?us-ascii?Q?t85TU5+SPHUseGew31FiQgXuqJ95AJoaXm3DUbonWeS6GPlW4+1ZzYCGb8Mh?=
 =?us-ascii?Q?8h2fBjDyelJ+KEPVwrnE4VPmHDSslzzqxknRlbuuS2IwV18KbOEfxFU+bfII?=
 =?us-ascii?Q?13MfttRIxvXbkOKSK/uKTv3rj6ADqxbjU2fUp7ikygjG74VCSLyRO3QUWnYp?=
 =?us-ascii?Q?FuNO5066KbcTlVBxWsy4vshPUyv9jz8QtmfpJH2PbJ9i2bQk0039/5v+AiyY?=
 =?us-ascii?Q?Ae/hKtemX+qTPsXOxVryoTUS66BU9DYQJuDG0Ggpf22ef/zmCL65y2aye7PJ?=
 =?us-ascii?Q?SsEOtOYe6844vg/b/oqybD6p60MULT5YRUh8KuKkSf0CWT1rpGxH1+Lt9Zs2?=
 =?us-ascii?Q?bQod3jXzTAJg38OaAJngrvZG9lushHstiQvtcIcH8xgX3csdYkOav8myHZZ0?=
 =?us-ascii?Q?5DLRC9roVC3JvqaMK+De29kk?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba68f68-defa-4582-6e11-08d92ffcce30
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 12:55:08.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJEJxLPhV/oFs6Ypj+I3ShWeMIswJO6ogn2FslKXv7MMzs6yqxDKyD/flAofr6oEWPuQZ15OIhUEg69YENdPC7a9BIdECOFUxpdZBqSqvIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

Add ACL infrastructure for Prestera Switch ASICs family devices to
offload cls_flower rules to be processed in the HW.

ACL implementation is based on tc filter api. The flower classifier
is supported to configure ACL rules/matches/action.

Supported actions:

    - drop
    - trap
    - pass

Supported dissector keys:

    - indev
    - src_mac
    - dst_mac
    - src_ip
    - dst_ip
    - ip_proto
    - src_port
    - dst_port
    - vlan_id
    - vlan_ethtype
    - icmp type/code

Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   5 +
 .../ethernet/marvell/prestera/prestera_acl.c  | 398 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_acl.h  | 129 ++++++
 .../ethernet/marvell/prestera/prestera_flow.c | 196 +++++++++
 .../ethernet/marvell/prestera/prestera_flow.h |  14 +
 .../marvell/prestera/prestera_flower.c        | 359 ++++++++++++++++
 .../marvell/prestera/prestera_flower.h        |  18 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 292 +++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  17 +
 .../ethernet/marvell/prestera/prestera_main.c |  90 +++-
 11 files changed, 1519 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 93129e32ebc5..42327c4afdbf 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
-			   prestera_switchdev.o
+			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
+			   prestera_flower.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 6353f1c67638..bbbe780d0886 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -67,9 +67,12 @@ struct prestera_lag {
 	u16 lag_id;
 };
 
+struct prestera_flow_block;
+
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
+	struct prestera_flow_block *flow_block;
 	struct devlink_port dl_port;
 	struct list_head lag_member;
 	struct prestera_lag *lag;
@@ -171,11 +174,13 @@ struct prestera_event {
 struct prestera_switchdev;
 struct prestera_rxtx;
 struct prestera_trap_data;
+struct prestera_acl;
 
 struct prestera_switch {
 	struct prestera_device *dev;
 	struct prestera_switchdev *swdev;
 	struct prestera_rxtx *rxtx;
+	struct prestera_acl *acl;
 	struct list_head event_handlers;
 	struct notifier_block netdev_nb;
 	struct prestera_trap_data *trap_data;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
new file mode 100644
index 000000000000..817f78b1e90c
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -0,0 +1,398 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/rhashtable.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_acl.h"
+
+struct prestera_acl {
+	struct prestera_switch *sw;
+	struct list_head rules;
+};
+
+struct prestera_acl_ruleset {
+	struct rhashtable rule_ht;
+	struct prestera_switch *sw;
+	u16 id;
+};
+
+struct prestera_acl_rule {
+	struct rhash_head ht_node;
+	struct list_head list;
+	struct list_head match_list;
+	struct list_head action_list;
+	struct prestera_flow_block *block;
+	unsigned long cookie;
+	u32 priority;
+	u8 n_actions;
+	u8 n_matches;
+	u32 id;
+};
+
+static const struct rhashtable_params prestera_acl_rule_ht_params = {
+	.key_len = sizeof(unsigned long),
+	.key_offset = offsetof(struct prestera_acl_rule, cookie),
+	.head_offset = offsetof(struct prestera_acl_rule, ht_node),
+	.automatic_shrinking = true,
+};
+
+static struct prestera_acl_ruleset *
+prestera_acl_ruleset_create(struct prestera_switch *sw)
+{
+	struct prestera_acl_ruleset *ruleset;
+	int err;
+
+	ruleset = kzalloc(sizeof(*ruleset), GFP_KERNEL);
+	if (!ruleset)
+		return ERR_PTR(-ENOMEM);
+
+	err = rhashtable_init(&ruleset->rule_ht, &prestera_acl_rule_ht_params);
+	if (err)
+		goto err_rhashtable_init;
+
+	err = prestera_hw_acl_ruleset_create(sw, &ruleset->id);
+	if (err)
+		goto err_ruleset_create;
+
+	ruleset->sw = sw;
+
+	return ruleset;
+
+err_ruleset_create:
+	rhashtable_destroy(&ruleset->rule_ht);
+err_rhashtable_init:
+	kfree(ruleset);
+	return ERR_PTR(err);
+}
+
+static void prestera_acl_ruleset_destroy(struct prestera_acl_ruleset *ruleset)
+{
+	prestera_hw_acl_ruleset_del(ruleset->sw, ruleset->id);
+	rhashtable_destroy(&ruleset->rule_ht);
+	kfree(ruleset);
+}
+
+struct prestera_flow_block *
+prestera_acl_block_create(struct prestera_switch *sw, struct net *net)
+{
+	struct prestera_flow_block *block;
+
+	block = kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return NULL;
+	INIT_LIST_HEAD(&block->binding_list);
+	block->net = net;
+	block->sw = sw;
+
+	block->ruleset = prestera_acl_ruleset_create(sw);
+	if (IS_ERR(block->ruleset)) {
+		kfree(block);
+		return NULL;
+	}
+
+	return block;
+}
+
+void prestera_acl_block_destroy(struct prestera_flow_block *block)
+{
+	prestera_acl_ruleset_destroy(block->ruleset);
+	WARN_ON(!list_empty(&block->binding_list));
+	kfree(block);
+}
+
+static struct prestera_flow_block_binding *
+prestera_acl_block_lookup(struct prestera_flow_block *block,
+			  struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		if (binding->port == port)
+			return binding;
+
+	return NULL;
+}
+
+unsigned int prestera_acl_block_rule_count(struct prestera_flow_block *block)
+{
+	return block ? block->rule_count : 0;
+}
+
+void prestera_acl_block_disable_inc(struct prestera_flow_block *block)
+{
+	if (block)
+		block->disable_count++;
+}
+
+void prestera_acl_block_disable_dec(struct prestera_flow_block *block)
+{
+	if (block)
+		block->disable_count--;
+}
+
+bool prestera_acl_block_disabled(const struct prestera_flow_block *block)
+{
+	return block->disable_count;
+}
+
+int prestera_acl_block_bind(struct prestera_flow_block *block,
+			    struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+	int err;
+
+	if (WARN_ON(prestera_acl_block_lookup(block, port)))
+		return -EEXIST;
+
+	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
+	if (!binding)
+		return -ENOMEM;
+	binding->port = port;
+
+	err = prestera_hw_acl_port_bind(port, block->ruleset->id);
+	if (err)
+		goto err_rules_bind;
+
+	list_add(&binding->list, &block->binding_list);
+	return 0;
+
+err_rules_bind:
+	kfree(binding);
+	return err;
+}
+
+int prestera_acl_block_unbind(struct prestera_flow_block *block,
+			      struct prestera_port *port)
+{
+	struct prestera_flow_block_binding *binding;
+
+	binding = prestera_acl_block_lookup(block, port);
+	if (!binding)
+		return -ENOENT;
+
+	list_del(&binding->list);
+
+	prestera_hw_acl_port_unbind(port, block->ruleset->id);
+
+	kfree(binding);
+	return 0;
+}
+
+struct prestera_acl_ruleset *
+prestera_acl_block_ruleset_get(struct prestera_flow_block *block)
+{
+	return block->ruleset;
+}
+
+u16 prestera_acl_rule_ruleset_id_get(const struct prestera_acl_rule *rule)
+{
+	return rule->block->ruleset->id;
+}
+
+struct net *prestera_acl_block_net(struct prestera_flow_block *block)
+{
+	return block->net;
+}
+
+struct prestera_switch *prestera_acl_block_sw(struct prestera_flow_block *block)
+{
+	return block->sw;
+}
+
+struct prestera_acl_rule *
+prestera_acl_rule_lookup(struct prestera_acl_ruleset *ruleset,
+			 unsigned long cookie)
+{
+	return rhashtable_lookup_fast(&ruleset->rule_ht, &cookie,
+				      prestera_acl_rule_ht_params);
+}
+
+struct prestera_acl_rule *
+prestera_acl_rule_create(struct prestera_flow_block *block,
+			 unsigned long cookie)
+{
+	struct prestera_acl_rule *rule;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&rule->match_list);
+	INIT_LIST_HEAD(&rule->action_list);
+	rule->cookie = cookie;
+	rule->block = block;
+
+	return rule;
+}
+
+struct list_head *
+prestera_acl_rule_match_list_get(struct prestera_acl_rule *rule)
+{
+	return &rule->match_list;
+}
+
+struct list_head *
+prestera_acl_rule_action_list_get(struct prestera_acl_rule *rule)
+{
+	return &rule->action_list;
+}
+
+int prestera_acl_rule_action_add(struct prestera_acl_rule *rule,
+				 struct prestera_acl_rule_action_entry *entry)
+{
+	struct prestera_acl_rule_action_entry *a_entry;
+
+	a_entry = kmalloc(sizeof(*a_entry), GFP_KERNEL);
+	if (!a_entry)
+		return -ENOMEM;
+
+	memcpy(a_entry, entry, sizeof(*entry));
+	list_add(&a_entry->list, &rule->action_list);
+
+	rule->n_actions++;
+	return 0;
+}
+
+u8 prestera_acl_rule_action_len(struct prestera_acl_rule *rule)
+{
+	return rule->n_actions;
+}
+
+u32 prestera_acl_rule_priority_get(struct prestera_acl_rule *rule)
+{
+	return rule->priority;
+}
+
+void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
+				    u32 priority)
+{
+	rule->priority = priority;
+}
+
+int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
+				struct prestera_acl_rule_match_entry *entry)
+{
+	struct prestera_acl_rule_match_entry *m_entry;
+
+	m_entry = kmalloc(sizeof(*m_entry), GFP_KERNEL);
+	if (!m_entry)
+		return -ENOMEM;
+
+	memcpy(m_entry, entry, sizeof(*entry));
+	list_add(&m_entry->list, &rule->match_list);
+
+	rule->n_matches++;
+	return 0;
+}
+
+u8 prestera_acl_rule_match_len(struct prestera_acl_rule *rule)
+{
+	return rule->n_matches;
+}
+
+void prestera_acl_rule_destroy(struct prestera_acl_rule *rule)
+{
+	struct prestera_acl_rule_action_entry *a_entry;
+	struct prestera_acl_rule_match_entry *m_entry;
+	struct list_head *pos, *n;
+
+	list_for_each_safe(pos, n, &rule->match_list) {
+		m_entry = list_entry(pos, typeof(*m_entry), list);
+		list_del(pos);
+		kfree(m_entry);
+	}
+
+	list_for_each_safe(pos, n, &rule->action_list) {
+		a_entry = list_entry(pos, typeof(*a_entry), list);
+		list_del(pos);
+		kfree(a_entry);
+	}
+
+	kfree(rule);
+}
+
+int prestera_acl_rule_add(struct prestera_switch *sw,
+			  struct prestera_acl_rule *rule)
+{
+	u32 rule_id;
+	int err;
+
+	/* try to add rule to hash table first */
+	err = rhashtable_insert_fast(&rule->block->ruleset->rule_ht,
+				     &rule->ht_node,
+				     prestera_acl_rule_ht_params);
+	if (err)
+		return err;
+
+	/* add rule to hw */
+	err = prestera_hw_acl_rule_add(sw, rule, &rule_id);
+	if (err)
+		goto err_rule_add;
+
+	rule->id = rule_id;
+
+	list_add_tail(&rule->list, &sw->acl->rules);
+	rule->block->rule_count++;
+
+	return 0;
+
+err_rule_add:
+	rhashtable_remove_fast(&rule->block->ruleset->rule_ht, &rule->ht_node,
+			       prestera_acl_rule_ht_params);
+	return err;
+}
+
+void prestera_acl_rule_del(struct prestera_switch *sw,
+			   struct prestera_acl_rule *rule)
+{
+	rhashtable_remove_fast(&rule->block->ruleset->rule_ht, &rule->ht_node,
+			       prestera_acl_rule_ht_params);
+	rule->block->rule_count--;
+	list_del(&rule->list);
+	prestera_hw_acl_rule_del(sw, rule->id);
+}
+
+int prestera_acl_rule_get_stats(struct prestera_switch *sw,
+				struct prestera_acl_rule *rule,
+				u64 *packets, u64 *bytes, u64 *last_use)
+{
+	u64 current_packets;
+	u64 current_bytes;
+	int err;
+
+	err = prestera_hw_acl_rule_stats_get(sw, rule->id, &current_packets,
+					     &current_bytes);
+	if (err)
+		return err;
+
+	*packets = current_packets;
+	*bytes = current_bytes;
+	*last_use = jiffies;
+
+	return 0;
+}
+
+int prestera_acl_init(struct prestera_switch *sw)
+{
+	struct prestera_acl *acl;
+
+	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
+	if (!acl)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&acl->rules);
+	sw->acl = acl;
+	acl->sw = sw;
+
+	return 0;
+}
+
+void prestera_acl_fini(struct prestera_switch *sw)
+{
+	struct prestera_acl *acl = sw->acl;
+
+	WARN_ON(!list_empty(&acl->rules));
+	kfree(acl);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
new file mode 100644
index 000000000000..935c79a26036
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_ACL_H_
+#define _PRESTERA_ACL_H_
+
+enum prestera_acl_rule_match_entry_type {
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE = 1,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_SRC,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_DST,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE,
+	PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE
+};
+
+enum prestera_acl_rule_action {
+	PRESTERA_ACL_RULE_ACTION_ACCEPT,
+	PRESTERA_ACL_RULE_ACTION_DROP,
+	PRESTERA_ACL_RULE_ACTION_TRAP
+};
+
+struct prestera_switch;
+struct prestera_port;
+struct prestera_acl_rule;
+struct prestera_acl_ruleset;
+
+struct prestera_flow_block_binding {
+	struct list_head list;
+	struct prestera_port *port;
+};
+
+struct prestera_flow_block {
+	struct list_head binding_list;
+	struct prestera_switch *sw;
+	unsigned int rule_count;
+	unsigned int disable_count;
+	struct net *net;
+	struct prestera_acl_ruleset *ruleset;
+	struct flow_block_cb *block_cb;
+};
+
+struct prestera_acl_rule_action_entry {
+	struct list_head list;
+	enum prestera_acl_rule_action id;
+};
+
+struct prestera_acl_rule_match_entry {
+	struct list_head list;
+	enum prestera_acl_rule_match_entry_type type;
+	union {
+		struct {
+			u8 key;
+			u8 mask;
+		} u8;
+		struct {
+			u16 key;
+			u16 mask;
+		} u16;
+		struct {
+			u32 key;
+			u32 mask;
+		} u32;
+		struct {
+			u64 key;
+			u64 mask;
+		} u64;
+		struct {
+			u8 key[ETH_ALEN];
+			u8 mask[ETH_ALEN];
+		} mac;
+	} keymask;
+};
+
+int prestera_acl_init(struct prestera_switch *sw);
+void prestera_acl_fini(struct prestera_switch *sw);
+struct prestera_flow_block *
+prestera_acl_block_create(struct prestera_switch *sw, struct net *net);
+void prestera_acl_block_destroy(struct prestera_flow_block *block);
+struct net *prestera_acl_block_net(struct prestera_flow_block *block);
+struct prestera_switch *prestera_acl_block_sw(struct prestera_flow_block *block);
+unsigned int prestera_acl_block_rule_count(struct prestera_flow_block *block);
+void prestera_acl_block_disable_inc(struct prestera_flow_block *block);
+void prestera_acl_block_disable_dec(struct prestera_flow_block *block);
+bool prestera_acl_block_disabled(const struct prestera_flow_block *block);
+int prestera_acl_block_bind(struct prestera_flow_block *block,
+			    struct prestera_port *port);
+int prestera_acl_block_unbind(struct prestera_flow_block *block,
+			      struct prestera_port *port);
+struct prestera_acl_ruleset *
+prestera_acl_block_ruleset_get(struct prestera_flow_block *block);
+struct prestera_acl_rule *
+prestera_acl_rule_create(struct prestera_flow_block *block,
+			 unsigned long cookie);
+u32 prestera_acl_rule_priority_get(struct prestera_acl_rule *rule);
+void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
+				    u32 priority);
+u16 prestera_acl_rule_ruleset_id_get(const struct prestera_acl_rule *rule);
+struct list_head *
+prestera_acl_rule_action_list_get(struct prestera_acl_rule *rule);
+u8 prestera_acl_rule_action_len(struct prestera_acl_rule *rule);
+u8 prestera_acl_rule_match_len(struct prestera_acl_rule *rule);
+int prestera_acl_rule_action_add(struct prestera_acl_rule *rule,
+				 struct prestera_acl_rule_action_entry *entry);
+struct list_head *
+prestera_acl_rule_match_list_get(struct prestera_acl_rule *rule);
+int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
+				struct prestera_acl_rule_match_entry *entry);
+void prestera_acl_rule_destroy(struct prestera_acl_rule *rule);
+struct prestera_acl_rule *
+prestera_acl_rule_lookup(struct prestera_acl_ruleset *ruleset,
+			 unsigned long cookie);
+int prestera_acl_rule_add(struct prestera_switch *sw,
+			  struct prestera_acl_rule *rule);
+void prestera_acl_rule_del(struct prestera_switch *sw,
+			   struct prestera_acl_rule *rule);
+int prestera_acl_rule_get_stats(struct prestera_switch *sw,
+				struct prestera_acl_rule *rule,
+				u64 *packets, u64 *bytes, u64 *last_use);
+
+#endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
new file mode 100644
index 000000000000..b818dd871512
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_acl.h"
+#include "prestera_flow.h"
+#include "prestera_flower.h"
+
+static LIST_HEAD(prestera_block_cb_list);
+
+static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
+					 struct flow_cls_offload *f)
+{
+	if (f->common.chain_index != 0)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return prestera_flower_replace(block, f);
+	case FLOW_CLS_DESTROY:
+		prestera_flower_destroy(block, f);
+		return 0;
+	case FLOW_CLS_STATS:
+		return prestera_flower_stats(block, f);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int prestera_flow_block_cb(enum tc_setup_type type,
+				  void *type_data, void *cb_priv)
+{
+	struct prestera_flow_block *block = cb_priv;
+
+	if (prestera_acl_block_disabled(block))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return prestera_flow_block_flower_cb(block, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void prestera_flow_block_release(void *cb_priv)
+{
+	struct prestera_flow_block *block = cb_priv;
+
+	prestera_acl_block_destroy(block);
+}
+
+static struct prestera_flow_block *
+prestera_flow_block_get(struct prestera_switch *sw,
+			struct flow_block_offload *f,
+			bool *register_block)
+{
+	struct prestera_flow_block *block;
+	struct flow_block_cb *block_cb;
+
+	block_cb = flow_block_cb_lookup(f->block,
+					prestera_flow_block_cb, sw);
+	if (!block_cb) {
+		block = prestera_acl_block_create(sw, f->net);
+		if (!block)
+			return ERR_PTR(-ENOMEM);
+
+		block_cb = flow_block_cb_alloc(prestera_flow_block_cb,
+					       sw, block,
+					       prestera_flow_block_release);
+		if (IS_ERR(block_cb)) {
+			prestera_acl_block_destroy(block);
+			return ERR_CAST(block_cb);
+		}
+
+		block->block_cb = block_cb;
+		*register_block = true;
+	} else {
+		block = flow_block_cb_priv(block_cb);
+		*register_block = false;
+	}
+
+	flow_block_cb_incref(block_cb);
+
+	return block;
+}
+
+static void prestera_flow_block_put(struct prestera_flow_block *block)
+{
+	struct flow_block_cb *block_cb = block->block_cb;
+
+	if (flow_block_cb_decref(block_cb))
+		return;
+
+	flow_block_cb_free(block_cb);
+	prestera_acl_block_destroy(block);
+}
+
+static int prestera_setup_flow_block_bind(struct prestera_port *port,
+					  struct flow_block_offload *f)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_flow_block *block;
+	struct flow_block_cb *block_cb;
+	bool disable_block = false;
+	bool register_block;
+	int err;
+
+	block = prestera_flow_block_get(sw, f, &register_block);
+	if (IS_ERR(block))
+		return PTR_ERR(block);
+
+	block_cb = block->block_cb;
+
+	if (!tc_can_offload(port->dev)) {
+		if (prestera_acl_block_rule_count(block)) {
+			err = -EOPNOTSUPP;
+			goto err_block_bind;
+		}
+
+		disable_block = true;
+	}
+
+	err = prestera_acl_block_bind(block, port);
+	if (err)
+		goto err_block_bind;
+
+	if (register_block) {
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &prestera_block_cb_list);
+	}
+
+	if (disable_block)
+		prestera_acl_block_disable_inc(block);
+
+	port->flow_block = block;
+	return 0;
+
+err_block_bind:
+	prestera_flow_block_put(block);
+
+	return err;
+}
+
+static void prestera_setup_flow_block_unbind(struct prestera_port *port,
+					     struct flow_block_offload *f)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_flow_block *block;
+	struct flow_block_cb *block_cb;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block,
+					prestera_flow_block_cb, sw);
+	if (!block_cb)
+		return;
+
+	block = flow_block_cb_priv(block_cb);
+
+	if (!tc_can_offload(port->dev))
+		prestera_acl_block_disable_dec(block);
+
+	err = prestera_acl_block_unbind(block, port);
+	if (err)
+		goto error;
+
+	if (!flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+	}
+error:
+	port->flow_block = NULL;
+}
+
+int prestera_flow_block_setup(struct prestera_port *port,
+			      struct flow_block_offload *f)
+{
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	f->driver_block_list = &prestera_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		return prestera_setup_flow_block_bind(port, f);
+	case FLOW_BLOCK_UNBIND:
+		prestera_setup_flow_block_unbind(port, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
new file mode 100644
index 000000000000..467c7038cace
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_FLOW_H_
+#define _PRESTERA_FLOW_H_
+
+#include <net/flow_offload.h>
+
+struct prestera_port;
+
+int prestera_flow_block_setup(struct prestera_port *port,
+			      struct flow_block_offload *f);
+
+#endif /* _PRESTERA_FLOW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
new file mode 100644
index 000000000000..e571ba09ec08
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -0,0 +1,359 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
+
+#include "prestera.h"
+#include "prestera_acl.h"
+#include "prestera_flower.h"
+
+static int prestera_flower_parse_actions(struct prestera_flow_block *block,
+					 struct prestera_acl_rule *rule,
+					 struct flow_action *flow_action,
+					 struct netlink_ext_ack *extack)
+{
+	struct prestera_acl_rule_action_entry a_entry;
+	const struct flow_action_entry *act;
+	int err, i;
+
+	if (!flow_action_has_entries(flow_action))
+		return 0;
+
+	flow_action_for_each(i, act, flow_action) {
+		memset(&a_entry, 0, sizeof(a_entry));
+
+		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+			a_entry.id = PRESTERA_ACL_RULE_ACTION_ACCEPT;
+			break;
+		case FLOW_ACTION_DROP:
+			a_entry.id = PRESTERA_ACL_RULE_ACTION_DROP;
+			break;
+		case FLOW_ACTION_TRAP:
+			a_entry.id = PRESTERA_ACL_RULE_ACTION_TRAP;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
+			pr_err("Unsupported action\n");
+			return -EOPNOTSUPP;
+		}
+
+		err = prestera_acl_rule_action_add(rule, &a_entry);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
+				      struct flow_cls_offload *f,
+				      struct prestera_flow_block *block)
+{
+	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+	struct prestera_acl_rule_match_entry m_entry = {0};
+	struct net_device *ingress_dev;
+	struct flow_match_meta match;
+	struct prestera_port *port;
+
+	flow_rule_match_meta(f_rule, &match);
+	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unsupported ingress ifindex mask");
+		return -EINVAL;
+	}
+
+	ingress_dev = __dev_get_by_index(prestera_acl_block_net(block),
+					 match.key->ingress_ifindex);
+	if (!ingress_dev) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Can't find specified ingress port to match on");
+		return -EINVAL;
+	}
+
+	if (!prestera_netdev_check(ingress_dev)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Can't match on switchdev ingress port");
+		return -EINVAL;
+	}
+	port = netdev_priv(ingress_dev);
+
+	m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT;
+	m_entry.keymask.u64.key = port->hw_id | ((u64)port->dev_id << 32);
+	m_entry.keymask.u64.mask = ~(u64)0;
+
+	return prestera_acl_rule_match_add(rule, &m_entry);
+}
+
+static int prestera_flower_parse(struct prestera_flow_block *block,
+				 struct prestera_acl_rule *rule,
+				 struct flow_cls_offload *f)
+{
+	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+	struct flow_dissector *dissector = f_rule->match.dissector;
+	struct prestera_acl_rule_match_entry m_entry;
+	u16 n_proto_mask = 0;
+	u16 n_proto_key = 0;
+	u16 addr_type = 0;
+	u8 ip_proto = 0;
+	int err;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_META) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ICMP) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN))) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported key");
+		return -EOPNOTSUPP;
+	}
+
+	prestera_acl_rule_priority_set(rule, f->common.prio);
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_META)) {
+		err = prestera_flower_parse_meta(rule, f, block);
+		if (err)
+			return err;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(f_rule, &match);
+		addr_type = match.key->addr_type;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(f_rule, &match);
+		n_proto_key = ntohs(match.key->n_proto);
+		n_proto_mask = ntohs(match.mask->n_proto);
+
+		if (n_proto_key == ETH_P_ALL) {
+			n_proto_key = 0;
+			n_proto_mask = 0;
+		}
+
+		/* add eth type key,mask */
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE;
+		m_entry.keymask.u16.key = n_proto_key;
+		m_entry.keymask.u16.mask = n_proto_mask;
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		/* add ip proto key,mask */
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO;
+		m_entry.keymask.u8.key = match.key->ip_proto;
+		m_entry.keymask.u8.mask = match.mask->ip_proto;
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		ip_proto = match.key->ip_proto;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(f_rule, &match);
+
+		/* add ethernet dst key,mask */
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC;
+		memcpy(&m_entry.keymask.mac.key,
+		       &match.key->dst, sizeof(match.key->dst));
+		memcpy(&m_entry.keymask.mac.mask,
+		       &match.mask->dst, sizeof(match.mask->dst));
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		/* add ethernet src key,mask */
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC;
+		memcpy(&m_entry.keymask.mac.key,
+		       &match.key->src, sizeof(match.key->src));
+		memcpy(&m_entry.keymask.mac.mask,
+		       &match.mask->src, sizeof(match.mask->src));
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(f_rule, &match);
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC;
+		memcpy(&m_entry.keymask.u32.key,
+		       &match.key->src, sizeof(match.key->src));
+		memcpy(&m_entry.keymask.u32.mask,
+		       &match.mask->src, sizeof(match.mask->src));
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST;
+		memcpy(&m_entry.keymask.u32.key,
+		       &match.key->dst, sizeof(match.key->dst));
+		memcpy(&m_entry.keymask.u32.mask,
+		       &match.mask->dst, sizeof(match.mask->dst));
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		if (ip_proto != IPPROTO_TCP && ip_proto != IPPROTO_UDP) {
+			NL_SET_ERR_MSG_MOD
+			    (f->common.extack,
+			     "Only UDP and TCP keys are supported");
+			return -EINVAL;
+		}
+
+		flow_rule_match_ports(f_rule, &match);
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC;
+		m_entry.keymask.u16.key = ntohs(match.key->src);
+		m_entry.keymask.u16.mask = ntohs(match.mask->src);
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST;
+		m_entry.keymask.u16.key = ntohs(match.key->dst);
+		m_entry.keymask.u16.mask = ntohs(match.mask->dst);
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(f_rule, &match);
+
+		if (match.mask->vlan_id != 0) {
+			memset(&m_entry, 0, sizeof(m_entry));
+			m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID;
+			m_entry.keymask.u16.key = match.key->vlan_id;
+			m_entry.keymask.u16.mask = match.mask->vlan_id;
+			err = prestera_acl_rule_match_add(rule, &m_entry);
+			if (err)
+				return err;
+		}
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID;
+		m_entry.keymask.u16.key = ntohs(match.key->vlan_tpid);
+		m_entry.keymask.u16.mask = ntohs(match.mask->vlan_tpid);
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+	}
+
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_ICMP)) {
+		struct flow_match_icmp match;
+
+		flow_rule_match_icmp(f_rule, &match);
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE;
+		m_entry.keymask.u8.key = match.key->type;
+		m_entry.keymask.u8.mask = match.mask->type;
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+
+		memset(&m_entry, 0, sizeof(m_entry));
+		m_entry.type = PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE;
+		m_entry.keymask.u8.key = match.key->code;
+		m_entry.keymask.u8.mask = match.mask->code;
+		err = prestera_acl_rule_match_add(rule, &m_entry);
+		if (err)
+			return err;
+	}
+
+	return prestera_flower_parse_actions(block, rule,
+					     &f->rule->action,
+					     f->common.extack);
+}
+
+int prestera_flower_replace(struct prestera_flow_block *block,
+			    struct flow_cls_offload *f)
+{
+	struct prestera_switch *sw = prestera_acl_block_sw(block);
+	struct prestera_acl_rule *rule;
+	int err;
+
+	rule = prestera_acl_rule_create(block, f->cookie);
+	if (IS_ERR(rule))
+		return PTR_ERR(rule);
+
+	err = prestera_flower_parse(block, rule, f);
+	if (err)
+		goto err_flower_parse;
+
+	err = prestera_acl_rule_add(sw, rule);
+	if (err)
+		goto err_rule_add;
+
+	return 0;
+
+err_rule_add:
+err_flower_parse:
+	prestera_acl_rule_destroy(rule);
+	return err;
+}
+
+void prestera_flower_destroy(struct prestera_flow_block *block,
+			     struct flow_cls_offload *f)
+{
+	struct prestera_acl_rule *rule;
+	struct prestera_switch *sw;
+
+	rule = prestera_acl_rule_lookup(prestera_acl_block_ruleset_get(block),
+					f->cookie);
+	if (rule) {
+		sw = prestera_acl_block_sw(block);
+		prestera_acl_rule_del(sw, rule);
+		prestera_acl_rule_destroy(rule);
+	}
+}
+
+int prestera_flower_stats(struct prestera_flow_block *block,
+			  struct flow_cls_offload *f)
+{
+	struct prestera_switch *sw = prestera_acl_block_sw(block);
+	struct prestera_acl_rule *rule;
+	u64 packets;
+	u64 lastuse;
+	u64 bytes;
+	int err;
+
+	rule = prestera_acl_rule_lookup(prestera_acl_block_ruleset_get(block),
+					f->cookie);
+	if (!rule)
+		return -EINVAL;
+
+	err = prestera_acl_rule_get_stats(sw, rule, &packets, &bytes, &lastuse);
+	if (err)
+		return err;
+
+	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.h b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
new file mode 100644
index 000000000000..91e045eec58b
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_FLOWER_H_
+#define _PRESTERA_FLOWER_H_
+
+#include <net/pkt_cls.h>
+
+struct prestera_flow_block;
+
+int prestera_flower_replace(struct prestera_flow_block *block,
+			    struct flow_cls_offload *f);
+void prestera_flower_destroy(struct prestera_flow_block *block,
+			     struct flow_cls_offload *f);
+int prestera_flower_stats(struct prestera_flow_block *block,
+			  struct flow_cls_offload *f);
+
+#endif /* _PRESTERA_FLOWER_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index a4e3dc8d3abe..42b8d9f56468 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -8,6 +8,7 @@
 
 #include "prestera.h"
 #include "prestera_hw.h"
+#include "prestera_acl.h"
 
 #define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
 
@@ -37,6 +38,14 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD = 0x402,
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE = 0x403,
 
+	PRESTERA_CMD_TYPE_ACL_RULE_ADD = 0x500,
+	PRESTERA_CMD_TYPE_ACL_RULE_DELETE = 0x501,
+	PRESTERA_CMD_TYPE_ACL_RULE_STATS_GET = 0x510,
+	PRESTERA_CMD_TYPE_ACL_RULESET_CREATE = 0x520,
+	PRESTERA_CMD_TYPE_ACL_RULESET_DELETE = 0x521,
+	PRESTERA_CMD_TYPE_ACL_PORT_BIND = 0x530,
+	PRESTERA_CMD_TYPE_ACL_PORT_UNBIND = 0x531,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
@@ -301,6 +310,73 @@ struct prestera_msg_bridge_resp {
 	u16 bridge;
 };
 
+struct prestera_msg_acl_action {
+	u32 id;
+};
+
+struct prestera_msg_acl_match {
+	u32 type;
+	union {
+		struct {
+			u8 key;
+			u8 mask;
+		} u8;
+		struct {
+			u16 key;
+			u16 mask;
+		} u16;
+		struct {
+			u32 key;
+			u32 mask;
+		} u32;
+		struct {
+			u64 key;
+			u64 mask;
+		} u64;
+		struct {
+			u8 key[ETH_ALEN];
+			u8 mask[ETH_ALEN];
+		} mac;
+	} __packed keymask;
+};
+
+struct prestera_msg_acl_rule_req {
+	struct prestera_msg_cmd cmd;
+	u32 id;
+	u32 priority;
+	u16 ruleset_id;
+	u8 n_actions;
+	u8 n_matches;
+};
+
+struct prestera_msg_acl_rule_resp {
+	struct prestera_msg_ret ret;
+	u32 id;
+};
+
+struct prestera_msg_acl_rule_stats_resp {
+	struct prestera_msg_ret ret;
+	u64 packets;
+	u64 bytes;
+};
+
+struct prestera_msg_acl_ruleset_bind_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 ruleset_id;
+};
+
+struct prestera_msg_acl_ruleset_req {
+	struct prestera_msg_cmd cmd;
+	u16 id;
+};
+
+struct prestera_msg_acl_ruleset_resp {
+	struct prestera_msg_ret ret;
+	u16 id;
+};
+
 struct prestera_msg_stp_req {
 	struct prestera_msg_cmd cmd;
 	u32 port;
@@ -763,6 +839,222 @@ int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
 	return 0;
 }
 
+int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
+{
+	struct prestera_msg_acl_ruleset_resp resp;
+	struct prestera_msg_acl_ruleset_req req;
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULESET_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*ruleset_id = resp.id;
+
+	return 0;
+}
+
+int prestera_hw_acl_ruleset_del(struct prestera_switch *sw, u16 ruleset_id)
+{
+	struct prestera_msg_acl_ruleset_req req = {
+		.id = ruleset_id,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULESET_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
+static int prestera_hw_acl_actions_put(struct prestera_msg_acl_action *action,
+				       struct prestera_acl_rule *rule)
+{
+	struct list_head *a_list = prestera_acl_rule_action_list_get(rule);
+	struct prestera_acl_rule_action_entry *a_entry;
+	int i = 0;
+
+	list_for_each_entry(a_entry, a_list, list) {
+		action[i].id = a_entry->id;
+
+		switch (a_entry->id) {
+		case PRESTERA_ACL_RULE_ACTION_ACCEPT:
+		case PRESTERA_ACL_RULE_ACTION_DROP:
+		case PRESTERA_ACL_RULE_ACTION_TRAP:
+			/* just rule action id, no specific data */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
+static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
+				       struct prestera_acl_rule *rule)
+{
+	struct list_head *m_list = prestera_acl_rule_match_list_get(rule);
+	struct prestera_acl_rule_match_entry *m_entry;
+	int i = 0;
+
+	list_for_each_entry(m_entry, m_list, list) {
+		match[i].type = m_entry->type;
+
+		switch (m_entry->type) {
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_SRC:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID:
+			match[i].keymask.u16.key = m_entry->keymask.u16.key;
+			match[i].keymask.u16.mask = m_entry->keymask.u16.mask;
+			break;
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_PROTO:
+			match[i].keymask.u8.key = m_entry->keymask.u8.key;
+			match[i].keymask.u8.mask = m_entry->keymask.u8.mask;
+			break;
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_SMAC:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_DMAC:
+			memcpy(match[i].keymask.mac.key,
+			       m_entry->keymask.mac.key,
+			       sizeof(match[i].keymask.mac.key));
+			memcpy(match[i].keymask.mac.mask,
+			       m_entry->keymask.mac.mask,
+			       sizeof(match[i].keymask.mac.mask));
+			break;
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_SRC:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_SRC:
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_DST:
+			match[i].keymask.u32.key = m_entry->keymask.u32.key;
+			match[i].keymask.u32.mask = m_entry->keymask.u32.mask;
+			break;
+		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT:
+			match[i].keymask.u64.key = m_entry->keymask.u64.key;
+			match[i].keymask.u64.mask = m_entry->keymask.u64.mask;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
+int prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			     struct prestera_acl_rule *rule,
+			     u32 *rule_id)
+{
+	struct prestera_msg_acl_action *actions;
+	struct prestera_msg_acl_match *matches;
+	struct prestera_msg_acl_rule_resp resp;
+	struct prestera_msg_acl_rule_req *req;
+	u8 n_actions;
+	u8 n_matches;
+	void *buff;
+	u32 size;
+	int err;
+
+	n_actions = prestera_acl_rule_action_len(rule);
+	n_matches = prestera_acl_rule_match_len(rule);
+
+	size = sizeof(*req) + sizeof(*actions) * n_actions +
+		sizeof(*matches) * n_matches;
+
+	buff = kzalloc(size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	req = buff;
+	actions = buff + sizeof(*req);
+	matches = buff + sizeof(*req) + sizeof(*actions) * n_actions;
+
+	/* put acl actions into the message */
+	err = prestera_hw_acl_actions_put(actions, rule);
+	if (err)
+		goto free_buff;
+
+	/* put acl matches into the message */
+	err = prestera_hw_acl_matches_put(matches, rule);
+	if (err)
+		goto free_buff;
+
+	req->ruleset_id = prestera_acl_rule_ruleset_id_get(rule);
+	req->priority = prestera_acl_rule_priority_get(rule);
+	req->n_actions = prestera_acl_rule_action_len(rule);
+	req->n_matches = prestera_acl_rule_match_len(rule);
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_ADD,
+			       &req->cmd, size, &resp.ret, sizeof(resp));
+	if (err)
+		goto free_buff;
+
+	*rule_id = resp.id;
+free_buff:
+	kfree(buff);
+	return err;
+}
+
+int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id)
+{
+	struct prestera_msg_acl_rule_req req = {
+		.id = rule_id
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULE_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw, u32 rule_id,
+				   u64 *packets, u64 *bytes)
+{
+	struct prestera_msg_acl_rule_stats_resp resp;
+	struct prestera_msg_acl_rule_req req = {
+		.id = rule_id
+	};
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_STATS_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*packets = resp.packets;
+	*bytes = resp.bytes;
+
+	return 0;
+}
+
+int prestera_hw_acl_port_bind(const struct prestera_port *port, u16 ruleset_id)
+{
+	struct prestera_msg_acl_ruleset_bind_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.ruleset_id = ruleset_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_BIND,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_acl_port_unbind(const struct prestera_port *port,
+				u16 ruleset_id)
+{
+	struct prestera_msg_acl_ruleset_bind_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.ruleset_id = ruleset_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_UNBIND,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 {
 	struct prestera_msg_port_attr_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 7f72d81cf918..c01d376574d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -100,6 +100,7 @@ struct prestera_port_stats;
 struct prestera_port_caps;
 enum prestera_event_type;
 struct prestera_event;
+struct prestera_acl_rule;
 
 typedef void (*prestera_event_cb_t)
 	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
@@ -171,6 +172,22 @@ int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id);
 int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id);
 int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id);
 
+/* ACL API */
+int prestera_hw_acl_ruleset_create(struct prestera_switch *sw,
+				   u16 *ruleset_id);
+int prestera_hw_acl_ruleset_del(struct prestera_switch *sw,
+				u16 ruleset_id);
+int prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			     struct prestera_acl_rule *rule,
+			     u32 *rule_id);
+int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id);
+int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw,
+				   u32 rule_id, u64 *packets, u64 *bytes);
+int prestera_hw_acl_port_bind(const struct prestera_port *port,
+			      u16 ruleset_id);
+int prestera_hw_acl_port_unbind(const struct prestera_port *port,
+				u16 ruleset_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index d825fbdfa86f..ea683b5a8a2e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -12,6 +12,8 @@
 
 #include "prestera.h"
 #include "prestera_hw.h"
+#include "prestera_acl.h"
+#include "prestera_flow.h"
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
 #include "prestera_ethtool.h"
@@ -200,12 +202,90 @@ static void prestera_port_stats_update(struct work_struct *work)
 			   msecs_to_jiffies(PRESTERA_STATS_DELAY_MS));
 }
 
+static int prestera_port_feature_hw_tc(struct net_device *dev, bool enable)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	if (!enable) {
+		if (prestera_acl_block_rule_count(port->flow_block)) {
+			netdev_err(dev, "Active offloaded tc filters, can't turn hw_tc_offload off\n");
+			return -EINVAL;
+		}
+		prestera_acl_block_disable_inc(port->flow_block);
+	} else {
+		prestera_acl_block_disable_dec(port->flow_block);
+	}
+	return 0;
+}
+
+static int
+prestera_port_handle_feature(struct net_device *dev,
+			     netdev_features_t wanted_features,
+			     netdev_features_t feature,
+			     int (*feature_handler)(struct net_device *dev,
+						    bool enable))
+{
+	netdev_features_t changes = wanted_features ^ dev->features;
+	bool enable = !!(wanted_features & feature);
+	int err;
+
+	if (!(changes & feature))
+		return 0;
+
+	err = feature_handler(dev, enable);
+	if (err) {
+		netdev_err(dev, "%s feature %pNF failed, err %d\n",
+			   enable ? "Enable" : "Disable", &feature, err);
+		return err;
+	}
+
+	if (enable)
+		dev->features |= feature;
+	else
+		dev->features &= ~feature;
+
+	return 0;
+}
+
+static int prestera_port_set_features(struct net_device *dev,
+				      netdev_features_t features)
+{
+	netdev_features_t oper_features = dev->features;
+	int err;
+
+	err = prestera_port_handle_feature(dev, features, NETIF_F_HW_TC,
+					   prestera_port_feature_hw_tc);
+
+	if (err) {
+		dev->features = oper_features;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int prestera_port_setup_tc(struct net_device *dev,
+				  enum tc_setup_type type,
+				  void *type_data)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return prestera_flow_block_setup(port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_open = prestera_port_open,
 	.ndo_stop = prestera_port_close,
 	.ndo_start_xmit = prestera_port_xmit,
+	.ndo_setup_tc = prestera_port_setup_tc,
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
+	.ndo_set_features = prestera_port_set_features,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
 	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
@@ -298,7 +378,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_dl_port_register;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
+	dev->hw_features |= NETIF_F_HW_TC;
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 
@@ -824,6 +905,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_acl_init(sw);
+	if (err)
+		goto err_acl_init;
+
 	err = prestera_devlink_register(sw);
 	if (err)
 		goto err_dl_register;
@@ -843,6 +928,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 err_lag_init:
 	prestera_devlink_unregister(sw);
 err_dl_register:
+	prestera_acl_fini(sw);
+err_acl_init:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -860,6 +947,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_destroy_ports(sw);
 	prestera_lag_fini(sw);
 	prestera_devlink_unregister(sw);
+	prestera_acl_fini(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_switchdev_fini(sw);
-- 
2.17.1

