Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17AC463117
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhK3Khz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:37:55 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:37185
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233372AbhK3Kho (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 05:37:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2KWmee6wz88HGxkLcnHpJE5uh4C560u4ZUn0aEW9jqxQ/i/bMyPseXAFqmjBBK2s3YyDyojMrinIQhZx6rn6UP9H3E04RpHEMNDXez6Zxtow5vy5MZUSfnyUGvHf0CISb4Kkm+gtwUQCutbHaGnRf3BiHWmHvTySYuEprn0dkbnOdA9pmnARev+f+kvGeZVMj7EcZixnHjQZIsA1DskyDsODrDVLOzMySqVDsngxDT0M2dOEjuBYBvgrGWuskneU4mfx5juAPxCn8mIaTogRXOlDy/lCSqSfhHz3YmVc/94duaXPDf1Wtz7ZHV9QuIWF4yU5t7TduaNyR4AyXinJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdYslIfl0j/D5m6HRwk5wVLMKjih5DSPte++WTzdZa0=;
 b=U9Qg8txTnhw9k90zFE5UlxkLuvAP+8dpBNQs5WiCG18DvgRtnEm319O/9TZtxyi4beIhGluS4TidKj29Xf8QChg+X4LURVctrCEmo1zy74nWNVEUoV7SVTm+sAthj9htKSHeYEcmiyPyGrRdNkoQJoEaKC0HNQw2FTJvrb41clQTk5dv7LXhNq1PFje6TZOLkaw0V4r5GOj21YSsmv0l42LOeIPUG8g7cceVdXKAUHTAdQNdNQkKFDChhMey6VGxHEwtVCQvMGuriWYCUxUhY75/Atf64oROebs5dNIQGbKBx7bnscA6Ce8zjRr9vq78bohZGuIxqBNW/jnApV3n5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdYslIfl0j/D5m6HRwk5wVLMKjih5DSPte++WTzdZa0=;
 b=xppNIr2M943pLvSTPSGZE60nGdd8ikz1c07Z+HF70wiMLqb3Ia0n+Oo5f9edR6OqQ2BfeUlVc5DjETGvcWhKmPAaucPbFZg8lNqo4PIkwyqkUIk5Bpi322h/ctw8H8z98LktxYYRfzCUzgefarGzb/lLmSVwP1CDt7un9ER/3BQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0064.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 10:34:21 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 10:34:21 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: [PATCH net-next v2 2/3] net: prestera: add counter HW API
Date:   Tue, 30 Nov 2021 12:32:59 +0200
Message-Id: <1638268383-8498-3-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::26) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4734.21 via Frontend Transport; Tue, 30 Nov 2021 10:34:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd6f04bc-1607-4620-5054-08d9b3ecf837
X-MS-TrafficTypeDiagnostic: VI1P190MB0064:
X-Microsoft-Antispam-PRVS: <VI1P190MB0064E168BA861E3653F914458F679@VI1P190MB0064.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PT4oowsOFTtZmtcvy1cjhDxiexRza4Ldjns3emVFw0K0f6saVtgc0/rCEGVPpqjT/gZaaZ2qBKHqeF9vTLsXsxZVlkrJXmjEBXn0s09rBh2hWP0gIEsaiCsf89aRQ8QVnQWVw2ZaHc95lGmnLSDsQ7fAyRrqU6fKX0WWMkifmx7bUZVJRBfFF9xL1ZNPaE2G/TnqVnPUpOfPw9Z4e/7OzEOXpukpax3B+sOpCcPYKmED9mfUYzGg0kxBe7E0XhjobGwxUR8Jc9spkqtqCT0iMNMFLTWfbiVIu6xgh7YH0IbnmXXGkZg3yRrnO+e0yAb+6t54Y5+llU8Owb8wWuPaJWP9QKw//XS2HFRxMRXckMP9TE+5CPEPfNTEX3g4KbDn4lcc4IdXJ22FJcjLYMgv1pbMJLDEHIIYSTaLNGc7Xfag34GVc3pjzmdrX6DKdUkjZzTtKfCIQFFrfdXd9U3rjvY9e1mae9qykr5xA1LxeorWTJ1A2TvqYFOS2KthetZ00uENpucgAqpQmxAphbZsbu6u9YvRjaZDqOCqrahRS7MxYOcfXU/XO6eQ9cW377zaa973hciUCNgcAeDBHGgTlsGMXQjHqJ7toEIkHnyndseksv+MpmAlyjuTqajjs+YHlbGO4jmOGW5Iv3bAK6/AEs+rCnrBMYmTy/bjrjWKG3HM6HvnZnwBwepRAyJ8lPpfB5qI7mXtGJKgWHJ/Rdz6lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(186003)(83380400001)(36756003)(38100700002)(6666004)(8936002)(38350700002)(26005)(2906002)(52116002)(316002)(86362001)(44832011)(6916009)(66946007)(6486002)(508600001)(6512007)(8676002)(5660300002)(66476007)(2616005)(4326008)(6506007)(956004)(54906003)(30864003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ukzsvJX4VRt80d58kncxam4m4lK4bs+n09Hl2BEEeTZOuEJnX2F4cz8Ci5XR?=
 =?us-ascii?Q?kCdmOVeckPQYXttYTivNRqXHInaOxevb4K+joqEFEdsHWqB5Cb9JLQDQ0pwH?=
 =?us-ascii?Q?mKHad+r9fztwHxkkSQVKB+3wWMx68EnWSFOijbYk1OGtMMeTyZ/fO2uxjc+i?=
 =?us-ascii?Q?wbE5Kckxmu38bSn2z+SOlikKBS7ZU5dnOjsN/5ndDQBDEPZj4IIKNDgBN/Yz?=
 =?us-ascii?Q?x4EUKMZUAcodBtj/VLAicLrATPUdyqDMdA2c7e/9cwE+0sHVeIBTer01O1Tn?=
 =?us-ascii?Q?XWvW2khdlQ/NoNSXRactD7jAcHoXC0+ufowq1Almxj1Oq+6IyfrMOBHsGrGU?=
 =?us-ascii?Q?E7WTw0Qs+rPGXpb24nCjq0sPzP/azUxeVI0hsDlGU0qQorH9b4zmCTsnV8Y2?=
 =?us-ascii?Q?XWZNkjXXrF42drcfaKw9WSXdIpXR/89g/TPKo6lKnzsGStddhhqZ7SigE1ir?=
 =?us-ascii?Q?9H8xQojpIfh5NEYz7RUvJxhPz0tuKV/OcC+Vh9bTPwbyNm+SFYI8EiogKad5?=
 =?us-ascii?Q?cFGGWdV6j0zxbhhbZgQGskTmbXzDom9gXQQZ1ELpIMxhbXgfFj6zTt71+KRv?=
 =?us-ascii?Q?SLLFm4oiwmHcm0QNeURkrClIUbJQG8DBowR5ArFh6Pd9Z59LKwQ6Pj2eqU+X?=
 =?us-ascii?Q?RuHnr/039fKNDlGJfuzz3g9W+5oMmDUQQPNu8TytpjoJt5zvnvOjxfX2tmGj?=
 =?us-ascii?Q?mCQ84Bg6xuRnaYRKPpOfbZ9F2NnNx8CTG9LxR5de/baT9R52Sv0422LLZ6nA?=
 =?us-ascii?Q?Gbjci+SmIIEIH5DK9ewiehXpqUBbm7GVnfNW/8mkg/QcvwYycaARgG27n6nk?=
 =?us-ascii?Q?fC6NHTqJMMAfuS7KDoiHtLK3bKTN57thrz9bXXKAKmH1lFsSu1aLNQCN8vwL?=
 =?us-ascii?Q?GOoPpO0dVsHsGZJKZ4tNHaw6MqDRd95KfLjxH3fcOQHGii03ZodfAbzDx3KJ?=
 =?us-ascii?Q?N6Qx8CgTH2b+/XCaI6rkVexK2BenpH63SoVNgcqpPAEPiaVz4fXF71zBqUIX?=
 =?us-ascii?Q?HiFJBIorrjv1tHYmic4d/Uh61VekppMnox2Y59+vSLT9CcphUdJzeRS/VuzX?=
 =?us-ascii?Q?vL1QvzxoC8lUk35iQKtYDEr6jIhZooAzGX5yhlctOy/omQxGq3Fdjhk0ELTq?=
 =?us-ascii?Q?B9nQinQZgcHvPshwcCfE8Ks6t1Baf8iU+jzS89wb6joeL80/isW5C5ItMVVK?=
 =?us-ascii?Q?TxCHYhfnKFVJx6hi3Z+Zfrjr1956oivb0eXQyyVAS9TM+zRb9U1gp54k6psT?=
 =?us-ascii?Q?MPfTFQ5YPr5UO29cOhGFwFhzbhNUPTg4dNZDd7Jveff6+aBZPNvymMe79kve?=
 =?us-ascii?Q?MDFbGSSOuHVrkb4pk3bU/DigFNVkAYNEZXJcSFT7EdnniC0Oqpk2i8CbhooU?=
 =?us-ascii?Q?txHA31F4bEtCBaXpxZZm6+wVL0zVU2n9LM/qMPvJEw0r0bO0Y7pHP/fZVmC5?=
 =?us-ascii?Q?r1FrPqr8oRPOOBlU4NbdPLdn9XARitl6Do5pvGK2/vTmaHsQ1euLR3Sw2aes?=
 =?us-ascii?Q?IwRcsuH0u7eeZpDTuyP7KhZd1yKOaI8+lM6nCF6Gd3kht+Yyw+v4gKQVjap2?=
 =?us-ascii?Q?nthK20Xn0O1klPqKLgkv+oRhTDaESk/wL0VzOSEUQCsMF74LFv87D2wJHXY2?=
 =?us-ascii?Q?2cVTTLk94eDKoYZdRBQkckANyRkN2nxApQ1jXarKYjCxN0wlpCUa8GasUwkL?=
 =?us-ascii?Q?Imyu9A=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6f04bc-1607-4620-5054-08d9b3ecf837
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:34:21.0053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMLCgc9Q2Jf/rr9B/GHGcnG84fWnxBFCwVXJ7p+5VbRxreju3IQMat8/f5fnKymuBek+LQ8uiAUy3fiU+SEU59pl2AynJcjUI+GGBSI4ik8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Add counter API for getting HW statistics.

- HW statistics gathered by this API are deleyed.
- Batch of conters is supported.
- acl stat is supported.

Co-developed-by: Serhiy Boiko <serhiy.boiko@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:

- decrease indent level in prestera_counter_block_get
- remove inline in source code
- fix structure laid out

 drivers/net/ethernet/marvell/prestera/Makefile     |   2 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |   1 +
 .../net/ethernet/marvell/prestera/prestera_acl.h   |   7 +
 .../ethernet/marvell/prestera/prestera_counter.c   | 475 +++++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_counter.h   |  30 ++
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 140 +++++-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  21 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |   8 +
 8 files changed, 682 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 0609df8b913d..48dbcb2baf8f 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -3,6 +3,6 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
-			   prestera_flower.o prestera_span.o
+			   prestera_flower.o prestera_span.o prestera_counter.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2a4c14c704c0..797b2e4d3551 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -248,6 +248,7 @@ struct prestera_switch {
 	u32 mtu_max;
 	u8 id;
 	struct prestera_lag *lags;
+	struct prestera_counter *counter;
 	u8 lag_member_max;
 	u8 lag_max;
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 92332eb70201..8bfb7ad7307b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -60,6 +60,10 @@ struct prestera_acl_match {
 	__be32 mask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
 };
 
+struct prestera_acl_action_count {
+	u32 id;
+};
+
 struct prestera_acl_rule_entry_key {
 	u32 prio;
 	struct prestera_acl_match match;
@@ -67,6 +71,9 @@ struct prestera_acl_rule_entry_key {
 
 struct prestera_acl_hw_action_info {
 	enum prestera_acl_rule_action id;
+	union {
+		struct prestera_acl_action_count count;
+	};
 };
 
 /* This struct (arg) used only to be passed as parameter for
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_counter.c b/drivers/net/ethernet/marvell/prestera/prestera_counter.c
new file mode 100644
index 000000000000..4cd53a2dae46
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_counter.c
@@ -0,0 +1,475 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2021 Marvell International Ltd. All rights reserved */
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_acl.h"
+#include "prestera_counter.h"
+
+#define COUNTER_POLL_TIME	(msecs_to_jiffies(1000))
+#define COUNTER_RESCHED_TIME	(msecs_to_jiffies(50))
+#define COUNTER_BULK_SIZE	(256)
+
+struct prestera_counter {
+	struct prestera_switch *sw;
+	struct delayed_work stats_dw;
+	struct mutex mtx;  /* protect block_list */
+	struct prestera_counter_block **block_list;
+	u32 total_read;
+	u32 block_list_len;
+	u32 curr_idx;
+	bool is_fetching;
+};
+
+struct prestera_counter_block {
+	struct list_head list;
+	u32 id;
+	u32 offset;
+	u32 num_counters;
+	u32 client;
+	struct idr counter_idr;
+	refcount_t refcnt;
+	struct mutex mtx;  /* protect stats and counter_idr */
+	struct prestera_counter_stats *stats;
+	u8 *counter_flag;
+	bool is_updating;
+	bool full;
+};
+
+enum {
+	COUNTER_FLAG_READY = 0,
+	COUNTER_FLAG_INVALID = 1
+};
+
+static bool
+prestera_counter_is_ready(struct prestera_counter_block *block, u32 id)
+{
+	return block->counter_flag[id - block->offset] == COUNTER_FLAG_READY;
+}
+
+static void prestera_counter_lock(struct prestera_counter *counter)
+{
+	mutex_lock(&counter->mtx);
+}
+
+static void prestera_counter_unlock(struct prestera_counter *counter)
+{
+	mutex_unlock(&counter->mtx);
+}
+
+static void prestera_counter_block_lock(struct prestera_counter_block *block)
+{
+	mutex_lock(&block->mtx);
+}
+
+static void prestera_counter_block_unlock(struct prestera_counter_block *block)
+{
+	mutex_unlock(&block->mtx);
+}
+
+static bool prestera_counter_block_incref(struct prestera_counter_block *block)
+{
+	return refcount_inc_not_zero(&block->refcnt);
+}
+
+static bool prestera_counter_block_decref(struct prestera_counter_block *block)
+{
+	return refcount_dec_and_test(&block->refcnt);
+}
+
+/* must be called with prestera_counter_block_lock() */
+static void prestera_counter_stats_clear(struct prestera_counter_block *block,
+					 u32 counter_id)
+{
+	memset(&block->stats[counter_id - block->offset], 0,
+	       sizeof(*block->stats));
+}
+
+static struct prestera_counter_block *
+prestera_counter_block_lookup_not_full(struct prestera_counter *counter,
+				       u32 client)
+{
+	u32 i;
+
+	prestera_counter_lock(counter);
+	for (i = 0; i < counter->block_list_len; i++) {
+		if (counter->block_list[i] &&
+		    counter->block_list[i]->client == client &&
+		    !counter->block_list[i]->full &&
+		    prestera_counter_block_incref(counter->block_list[i])) {
+			prestera_counter_unlock(counter);
+			return counter->block_list[i];
+		}
+	}
+	prestera_counter_unlock(counter);
+
+	return NULL;
+}
+
+static int prestera_counter_block_list_add(struct prestera_counter *counter,
+					   struct prestera_counter_block *block)
+{
+	struct prestera_counter_block **arr;
+	u32 i;
+
+	prestera_counter_lock(counter);
+
+	for (i = 0; i < counter->block_list_len; i++) {
+		if (counter->block_list[i])
+			continue;
+
+		counter->block_list[i] = block;
+		prestera_counter_unlock(counter);
+		return 0;
+	}
+
+	arr = krealloc(counter->block_list, (counter->block_list_len + 1) *
+		       sizeof(*counter->block_list), GFP_KERNEL);
+	if (!arr) {
+		prestera_counter_unlock(counter);
+		return -ENOMEM;
+	}
+
+	counter->block_list = arr;
+	counter->block_list[counter->block_list_len] = block;
+	counter->block_list_len++;
+	prestera_counter_unlock(counter);
+	return 0;
+}
+
+static struct prestera_counter_block *
+prestera_counter_block_get(struct prestera_counter *counter, u32 client)
+{
+	struct prestera_counter_block *block;
+	int err;
+
+	block = prestera_counter_block_lookup_not_full(counter, client);
+	if (block)
+		return block;
+
+	block = kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return ERR_PTR(-ENOMEM);
+
+	err = prestera_hw_counter_block_get(counter->sw, client,
+					    &block->id, &block->offset,
+					    &block->num_counters);
+	if (err)
+		goto err_block;
+
+	block->stats = kcalloc(block->num_counters,
+			       sizeof(*block->stats), GFP_KERNEL);
+	if (!block->stats) {
+		err = -ENOMEM;
+		goto err_stats;
+	}
+
+	block->counter_flag = kcalloc(block->num_counters,
+				      sizeof(*block->counter_flag),
+				      GFP_KERNEL);
+	if (!block->counter_flag) {
+		err = -ENOMEM;
+		goto err_flag;
+	}
+
+	block->client = client;
+	mutex_init(&block->mtx);
+	refcount_set(&block->refcnt, 1);
+	idr_init_base(&block->counter_idr, block->offset);
+
+	err = prestera_counter_block_list_add(counter, block);
+	if (err)
+		goto err_list_add;
+
+	return block;
+
+err_list_add:
+	idr_destroy(&block->counter_idr);
+	mutex_destroy(&block->mtx);
+	kfree(block->counter_flag);
+err_flag:
+	kfree(block->stats);
+err_stats:
+	prestera_hw_counter_block_release(counter->sw, block->id);
+err_block:
+	kfree(block);
+	return ERR_PTR(err);
+}
+
+static void prestera_counter_block_put(struct prestera_counter *counter,
+				       struct prestera_counter_block *block)
+{
+	u32 i;
+
+	if (!prestera_counter_block_decref(block))
+		return;
+
+	prestera_counter_lock(counter);
+	for (i = 0; i < counter->block_list_len; i++) {
+		if (counter->block_list[i] &&
+		    counter->block_list[i]->id == block->id) {
+			counter->block_list[i] = NULL;
+			break;
+		}
+	}
+	prestera_counter_unlock(counter);
+
+	WARN_ON(!idr_is_empty(&block->counter_idr));
+
+	prestera_hw_counter_block_release(counter->sw, block->id);
+	idr_destroy(&block->counter_idr);
+	mutex_destroy(&block->mtx);
+	kfree(block->stats);
+	kfree(block);
+}
+
+static int prestera_counter_get_vacant(struct prestera_counter_block *block,
+				       u32 *id)
+{
+	int free_id;
+
+	if (block->full)
+		return -ENOSPC;
+
+	prestera_counter_block_lock(block);
+	free_id = idr_alloc_cyclic(&block->counter_idr, NULL, block->offset,
+				   block->offset + block->num_counters,
+				   GFP_KERNEL);
+	if (free_id < 0) {
+		if (free_id == -ENOSPC)
+			block->full = true;
+
+		prestera_counter_block_unlock(block);
+		return free_id;
+	}
+	*id = free_id;
+	prestera_counter_block_unlock(block);
+
+	return 0;
+}
+
+int prestera_counter_get(struct prestera_counter *counter, u32 client,
+			 struct prestera_counter_block **bl, u32 *counter_id)
+{
+	struct prestera_counter_block *block;
+	int err;
+	u32 id;
+
+get_next_block:
+	block = prestera_counter_block_get(counter, client);
+	if (IS_ERR(block))
+		return PTR_ERR(block);
+
+	err = prestera_counter_get_vacant(block, &id);
+	if (err) {
+		prestera_counter_block_put(counter, block);
+
+		if (err == -ENOSPC)
+			goto get_next_block;
+
+		return err;
+	}
+
+	prestera_counter_block_lock(block);
+	if (block->is_updating)
+		block->counter_flag[id - block->offset] = COUNTER_FLAG_INVALID;
+	prestera_counter_block_unlock(block);
+
+	*counter_id = id;
+	*bl = block;
+
+	return 0;
+}
+
+void prestera_counter_put(struct prestera_counter *counter,
+			  struct prestera_counter_block *block, u32 counter_id)
+{
+	if (!block)
+		return;
+
+	prestera_counter_block_lock(block);
+	idr_remove(&block->counter_idr, counter_id);
+	block->full = false;
+	prestera_counter_stats_clear(block, counter_id);
+	prestera_counter_block_unlock(block);
+
+	prestera_hw_counter_clear(counter->sw, block->id, counter_id);
+	prestera_counter_block_put(counter, block);
+}
+
+static u32 prestera_counter_block_idx_next(struct prestera_counter *counter,
+					   u32 curr_idx)
+{
+	u32 idx, i, start = curr_idx + 1;
+
+	prestera_counter_lock(counter);
+	for (i = 0; i < counter->block_list_len; i++) {
+		idx = (start + i) % counter->block_list_len;
+		if (!counter->block_list[idx])
+			continue;
+
+		prestera_counter_unlock(counter);
+		return idx;
+	}
+	prestera_counter_unlock(counter);
+
+	return 0;
+}
+
+static struct prestera_counter_block *
+prestera_counter_block_get_by_idx(struct prestera_counter *counter, u32 idx)
+{
+	if (idx >= counter->block_list_len)
+		return NULL;
+
+	prestera_counter_lock(counter);
+
+	if (!counter->block_list[idx] ||
+	    !prestera_counter_block_incref(counter->block_list[idx])) {
+		prestera_counter_unlock(counter);
+		return NULL;
+	}
+
+	prestera_counter_unlock(counter);
+	return counter->block_list[idx];
+}
+
+static void prestera_counter_stats_work(struct work_struct *work)
+{
+	struct delayed_work *dl_work =
+		container_of(work, struct delayed_work, work);
+	struct prestera_counter *counter =
+		container_of(dl_work, struct prestera_counter, stats_dw);
+	struct prestera_counter_block *block;
+	u32 resched_time = COUNTER_POLL_TIME;
+	u32 count = COUNTER_BULK_SIZE;
+	bool done = false;
+	int err;
+	u32 i;
+
+	block = prestera_counter_block_get_by_idx(counter, counter->curr_idx);
+	if (!block) {
+		if (counter->is_fetching)
+			goto abort;
+
+		goto next;
+	}
+
+	if (!counter->is_fetching) {
+		err = prestera_hw_counter_trigger(counter->sw, block->id);
+		if (err)
+			goto abort;
+
+		prestera_counter_block_lock(block);
+		block->is_updating = true;
+		prestera_counter_block_unlock(block);
+
+		counter->is_fetching = true;
+		counter->total_read = 0;
+		resched_time = COUNTER_RESCHED_TIME;
+		goto resched;
+	}
+
+	prestera_counter_block_lock(block);
+	err = prestera_hw_counters_get(counter->sw, counter->total_read,
+				       &count, &done,
+				       &block->stats[counter->total_read]);
+	prestera_counter_block_unlock(block);
+	if (err)
+		goto abort;
+
+	counter->total_read += count;
+	if (!done || counter->total_read < block->num_counters) {
+		resched_time = COUNTER_RESCHED_TIME;
+		goto resched;
+	}
+
+	for (i = 0; i < block->num_counters; i++) {
+		if (block->counter_flag[i] == COUNTER_FLAG_INVALID) {
+			prestera_counter_block_lock(block);
+			block->counter_flag[i] = COUNTER_FLAG_READY;
+			memset(&block->stats[i], 0, sizeof(*block->stats));
+			prestera_counter_block_unlock(block);
+		}
+	}
+
+	prestera_counter_block_lock(block);
+	block->is_updating = false;
+	prestera_counter_block_unlock(block);
+
+	goto next;
+abort:
+	prestera_hw_counter_abort(counter->sw);
+next:
+	counter->is_fetching = false;
+	counter->curr_idx =
+		prestera_counter_block_idx_next(counter, counter->curr_idx);
+resched:
+	if (block)
+		prestera_counter_block_put(counter, block);
+
+	schedule_delayed_work(&counter->stats_dw, resched_time);
+}
+
+/* Can be executed without rtnl_lock().
+ * So pay attention when something changing.
+ */
+int prestera_counter_stats_get(struct prestera_counter *counter,
+			       struct prestera_counter_block *block,
+			       u32 counter_id, u64 *packets, u64 *bytes)
+{
+	if (!block || !prestera_counter_is_ready(block, counter_id)) {
+		*packets = 0;
+		*bytes = 0;
+		return 0;
+	}
+
+	prestera_counter_block_lock(block);
+	*packets = block->stats[counter_id - block->offset].packets;
+	*bytes = block->stats[counter_id - block->offset].bytes;
+
+	prestera_counter_stats_clear(block, counter_id);
+	prestera_counter_block_unlock(block);
+
+	return 0;
+}
+
+int prestera_counter_init(struct prestera_switch *sw)
+{
+	struct prestera_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter)
+		return -ENOMEM;
+
+	counter->block_list = kzalloc(sizeof(*counter->block_list), GFP_KERNEL);
+	if (!counter->block_list) {
+		kfree(counter);
+		return -ENOMEM;
+	}
+
+	mutex_init(&counter->mtx);
+	counter->block_list_len = 1;
+	counter->sw = sw;
+	sw->counter = counter;
+
+	INIT_DELAYED_WORK(&counter->stats_dw, prestera_counter_stats_work);
+	schedule_delayed_work(&counter->stats_dw, COUNTER_POLL_TIME);
+
+	return 0;
+}
+
+void prestera_counter_fini(struct prestera_switch *sw)
+{
+	struct prestera_counter *counter = sw->counter;
+	u32 i;
+
+	cancel_delayed_work_sync(&counter->stats_dw);
+
+	for (i = 0; i < counter->block_list_len; i++)
+		WARN_ON(counter->block_list[i]);
+
+	mutex_destroy(&counter->mtx);
+	kfree(counter->block_list);
+	kfree(counter);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_counter.h b/drivers/net/ethernet/marvell/prestera/prestera_counter.h
new file mode 100644
index 000000000000..ad6b73907799
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_counter.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2021 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_COUNTER_H_
+#define _PRESTERA_COUNTER_H_
+
+#include <linux/types.h>
+
+struct prestera_counter_stats {
+	u64 packets;
+	u64 bytes;
+};
+
+struct prestera_switch;
+struct prestera_counter;
+struct prestera_counter_block;
+
+int prestera_counter_init(struct prestera_switch *sw);
+void prestera_counter_fini(struct prestera_switch *sw);
+
+int prestera_counter_get(struct prestera_counter *counter, u32 client,
+			 struct prestera_counter_block **block,
+			 u32 *counter_id);
+void prestera_counter_put(struct prestera_counter *counter,
+			  struct prestera_counter_block *block, u32 counter_id);
+int prestera_counter_stats_get(struct prestera_counter *counter,
+			       struct prestera_counter_block *block,
+			       u32 counter_id, u64 *packets, u64 *bytes);
+
+#endif /* _PRESTERA_COUNTER_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index d6c425b651cb..92cb5e9099c6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -9,6 +9,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_acl.h"
+#include "prestera_counter.h"
 
 #define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
 
@@ -38,6 +39,13 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD = 0x402,
 	PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE = 0x403,
 
+	PRESTERA_CMD_TYPE_COUNTER_GET = 0x510,
+	PRESTERA_CMD_TYPE_COUNTER_ABORT = 0x511,
+	PRESTERA_CMD_TYPE_COUNTER_TRIGGER = 0x512,
+	PRESTERA_CMD_TYPE_COUNTER_BLOCK_GET = 0x513,
+	PRESTERA_CMD_TYPE_COUNTER_BLOCK_RELEASE = 0x514,
+	PRESTERA_CMD_TYPE_COUNTER_CLEAR = 0x515,
+
 	PRESTERA_CMD_TYPE_VTCAM_CREATE = 0x540,
 	PRESTERA_CMD_TYPE_VTCAM_DESTROY = 0x541,
 	PRESTERA_CMD_TYPE_VTCAM_RULE_ADD = 0x550,
@@ -408,7 +416,34 @@ struct prestera_msg_vtcam_resp {
 
 struct prestera_msg_acl_action {
 	__le32 id;
-	__le32 __reserved[7];
+	__le32 __reserved;
+	union {
+		struct {
+			__le32 id;
+		} count;
+		__le32 reserved[6];
+	};
+};
+
+struct prestera_msg_counter_req {
+	struct prestera_msg_cmd cmd;
+	__le32 client;
+	__le32 block_id;
+	__le32 num_counters;
+};
+
+struct prestera_msg_counter_stats {
+	__le64 packets;
+	__le64 bytes;
+};
+
+struct prestera_msg_counter_resp {
+	struct prestera_msg_ret ret;
+	__le32 block_id;
+	__le32 offset;
+	__le32 num_counters;
+	__le32 done;
+	struct prestera_msg_counter_stats stats[0];
 };
 
 struct prestera_msg_span_req {
@@ -512,6 +547,8 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_rule_del_req) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_bind_req) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -523,6 +560,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_span_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1072,6 +1110,9 @@ prestera_acl_rule_add_put_action(struct prestera_msg_acl_action *action,
 	case PRESTERA_ACL_RULE_ACTION_TRAP:
 		/* just rule action id, no specific data */
 		break;
+	case PRESTERA_ACL_RULE_ACTION_COUNT:
+		action->count.id = __cpu_to_le32(info->count.id);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1831,3 +1872,100 @@ void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
 	list_del_rcu(&eh->list);
 	kfree_rcu(eh, rcu);
 }
+
+int prestera_hw_counter_trigger(struct prestera_switch *sw, u32 block_id)
+{
+	struct prestera_msg_counter_req req = {
+		.block_id = __cpu_to_le32(block_id)
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_COUNTER_TRIGGER,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_counter_abort(struct prestera_switch *sw)
+{
+	struct prestera_msg_counter_req req;
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_COUNTER_ABORT,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_counters_get(struct prestera_switch *sw, u32 idx,
+			     u32 *len, bool *done,
+			     struct prestera_counter_stats *stats)
+{
+	struct prestera_msg_counter_resp *resp;
+	struct prestera_msg_counter_req req = {
+		.block_id = __cpu_to_le32(idx),
+		.num_counters = __cpu_to_le32(*len),
+	};
+	size_t size = sizeof(*resp) + sizeof(*resp->stats) * (*len);
+	int err, i;
+
+	resp = kmalloc(size, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_COUNTER_GET,
+			       &req.cmd, sizeof(req), &resp->ret, size);
+	if (err)
+		goto free_buff;
+
+	for (i = 0; i < __le32_to_cpu(resp->num_counters); i++) {
+		stats[i].packets += __le64_to_cpu(resp->stats[i].packets);
+		stats[i].bytes += __le64_to_cpu(resp->stats[i].bytes);
+	}
+
+	*len = __le32_to_cpu(resp->num_counters);
+	*done = __le32_to_cpu(resp->done);
+
+free_buff:
+	kfree(resp);
+	return err;
+}
+
+int prestera_hw_counter_block_get(struct prestera_switch *sw,
+				  u32 client, u32 *block_id, u32 *offset,
+				  u32 *num_counters)
+{
+	struct prestera_msg_counter_resp resp;
+	struct prestera_msg_counter_req req = {
+		.client = __cpu_to_le32(client)
+	};
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_COUNTER_BLOCK_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*block_id = __le32_to_cpu(resp.block_id);
+	*offset = __le32_to_cpu(resp.offset);
+	*num_counters = __le32_to_cpu(resp.num_counters);
+
+	return 0;
+}
+
+int prestera_hw_counter_block_release(struct prestera_switch *sw,
+				      u32 block_id)
+{
+	struct prestera_msg_counter_req req = {
+		.block_id = __cpu_to_le32(block_id)
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_COUNTER_BLOCK_RELEASE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_counter_clear(struct prestera_switch *sw, u32 block_id,
+			      u32 counter_id)
+{
+	struct prestera_msg_counter_req req = {
+		.block_id = __cpu_to_le32(block_id),
+		.num_counters = __cpu_to_le32(counter_id)
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_COUNTER_CLEAR,
+			    &req.cmd, sizeof(req));
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 6b7a9f8e2ea2..0496e454e148 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -117,6 +117,12 @@ enum prestera_hw_vtcam_direction_t {
 	PRESTERA_HW_VTCAM_DIR_EGRESS = 1,
 };
 
+enum {
+	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0 = 0,
+	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1 = 1,
+	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2 = 2,
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
@@ -130,6 +136,7 @@ typedef void (*prestera_event_cb_t)
 struct prestera_rxtx_params;
 struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
+struct prestera_counter_stats;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -211,6 +218,20 @@ int prestera_hw_vtcam_iface_unbind(struct prestera_switch *sw,
 				   struct prestera_acl_iface *iface,
 				   u32 vtcam_id);
 
+/* Counter API */
+int prestera_hw_counter_trigger(struct prestera_switch *sw, u32 block_id);
+int prestera_hw_counter_abort(struct prestera_switch *sw);
+int prestera_hw_counters_get(struct prestera_switch *sw, u32 idx,
+			     u32 *len, bool *done,
+			     struct prestera_counter_stats *stats);
+int prestera_hw_counter_block_get(struct prestera_switch *sw,
+				  u32 client, u32 *block_id, u32 *offset,
+				  u32 *num_counters);
+int prestera_hw_counter_block_release(struct prestera_switch *sw,
+				      u32 block_id);
+int prestera_hw_counter_clear(struct prestera_switch *sw, u32 block_id,
+			      u32 counter_id);
+
 /* SPAN API */
 int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
 int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 4369a3ffad45..a0dbad5cb88d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -18,6 +18,7 @@
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
 #include "prestera_ethtool.h"
+#include "prestera_counter.h"
 #include "prestera_switchdev.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
@@ -904,6 +905,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_counter_init(sw);
+	if (err)
+		goto err_counter_init;
+
 	err = prestera_acl_init(sw);
 	if (err)
 		goto err_acl_init;
@@ -936,6 +941,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 err_span_init:
 	prestera_acl_fini(sw);
 err_acl_init:
+	prestera_counter_fini(sw);
+err_counter_init:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -956,6 +963,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_devlink_traps_unregister(sw);
 	prestera_span_fini(sw);
 	prestera_acl_fini(sw);
+	prestera_counter_fini(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_switchdev_fini(sw);
-- 
2.7.4

