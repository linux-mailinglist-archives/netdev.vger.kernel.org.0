Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC345A97A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbhKWRDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:03:11 -0500
Received: from mail-eopbgr60115.outbound.protection.outlook.com ([40.107.6.115]:58118
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238389AbhKWRDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:03:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDwtUKgLOMrajlOQ2ybkk00ozxOD4PJPfvALcbYfV0rSLvO2zRGZsTRXvU1emw49iRxE0U4RgpCZfKz7pmnPAYTt1m6VJyoi+sGKVE2xhOoe7U81C4bGJvHZWierQP4C7lqvFnjkAP9tKlPGr1ucwvvR0+09y2HoZZ334gda7WNQLQHDGLeh+Zza6AjbMYsiOfldbMGxjAwwl9b5Sh3tufMJrleBAbTeWUNUHWjJVcgm5AbVSr9xou1RXN8+EgFO6wrfjp20BSpufj/Eduby0QhFZu6ADxinRKBTCp/TeSsQ4S81GKerMdnQgYv0I8AqogAfvpfX2k2yS+jz8wuz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLT7Sk7g/lu1vi76GLmPoNudJP5brjny1BO2UHR5rLU=;
 b=I9BWfbu0pJsrqL+kCkznBXvWepA+RYHI1/OmgDb4Dro/KdffchOmk0q5dnjJeyVmLzYIqg3KFnHexOqvzIGyqPSBnUcc/n2wQNmImY2LZT8+m0M6EoO0hSswO+tFGWfyvZku0Z/tXvzPlR2b2r7Nf27GI1YrvWJ/fc6TemmS0z+Hu0f+RqJggaLM0AW0ugL5EduMt5QsGtHVQAxNMQxO8LHG2AuBBhQTn5fkQmB26FvNwVvea2vDwR5r6FolybdrG0/Dql5/FhXdvwAxeZW/QSRrZkuRT7QBLerfYdFaC6Uus27TXJ2AeITHbru7PDiYfOLJug82MMQHfxi8J1f7Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLT7Sk7g/lu1vi76GLmPoNudJP5brjny1BO2UHR5rLU=;
 b=dH0II1KlZa5G60eJHbKGDpi3igUKYKJHzaBwy/lF93UJoOUm09GK/VZLfuneSgQ8YVPv2mrj9EMA8Zs8tgT9g7LTVDzZ++qI+uHedTeBTrG2sdBbKI0fTmCTEV/DAYXWxW5M2xksTQuty/YQ7CVD17t9vr8xo+yO5qZGAWdXObY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0830.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 16:59:59 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 16:59:59 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: [PATCH net-next 2/3] net: prestera: add counter HW API
Date:   Tue, 23 Nov 2021 18:58:01 +0200
Message-Id: <1637686684-2492-3-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0203.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::28) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8PR04CA0203.eurprd04.prod.outlook.com (2603:10a6:20b:2f3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 16:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcc351ca-d714-404b-40e7-08d9aea2aeb5
X-MS-TrafficTypeDiagnostic: VE1P190MB0830:
X-Microsoft-Antispam-PRVS: <VE1P190MB08308EC0DEE30B1DFAB579CE8F609@VE1P190MB0830.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXtpt2jxDwaHIAVB3zUFVhvt3z/DDMT8l1QlF8Yqb9/kbFJPnrYf98I8qzMnKWtMdxJ+rMWtN+sOTpebyU/BrNdk7gP9kiG2CoZSdDKc5MQp+bLbUQmRZvkf956E4IUN7JqFiZ149Pw7k6/jgXHwvLFmZouOiPZ/aH9UQMUYsWbJ9IUzqlD1/qEu360kO/J0his1B0e0LUw/KgNNUIWTj9tYM8fHKgZDqYZ7E32a8RIIkKcTyXKYNhgX2KYUcZ7w7T+s8I0Mai+gg0t5jZqvscd0Vos9rTvDtSSY/hWkxk1cCqZu6cmnn7+0KAcEsjS7Zuz/NFyfeXoxZBmhR8P5fR63KU0HAbUWq1VCBXwAjddRqmx5s34cIBuYZISZYrFu+IvT//v0SG0cSqMpgjYbfwSHhdOgrmhAg1GYE5r4yjUBBM4DkD9in+CGr19X0EKfLgotZ5/bspXWldUztuAunkwKZmPGFIJD5h4S2Nl+dhP9aBSK40RwWu4QWK10NinFPG3wGvn0thJN7W4xLFS2sX6m2SEYPPvuYsZcYnZTScaH4upbLOEcOPmyRRmVmsAVcxCm5WmThDoeidI8tGhFZyoSBUHol96O/WsRctVIBpFlYPcS9O3IlKrVCcxONQvG1qm/ZH6F6q0OKQVa+7k1bHcxDV0BKLHq64MlYgh2Ud4r6Jhux8+OWtz52fyTkWQjBlRcGUAZwUx+YM+rFHtzkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(39840400004)(366004)(396003)(346002)(36756003)(26005)(956004)(2616005)(6666004)(83380400001)(66946007)(8936002)(8676002)(6512007)(38350700002)(66556008)(66476007)(52116002)(316002)(186003)(30864003)(2906002)(6916009)(38100700002)(44832011)(86362001)(54906003)(4326008)(5660300002)(508600001)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+h/K/Tgzo87tsTGpQDxS+01qY81nQsahp8L9rbBoZpA2hhNVRUXNTkxVF1Sz?=
 =?us-ascii?Q?z/r52sC8OzLxyDboAIVC3UcBFN7KtbMS1wi0c0yJR3KZaJ+PpgR/99Tbba14?=
 =?us-ascii?Q?bwVZl4RRhw64DUHJL7M+blcT7IMKvY9iUBnLd4zs0RwNH4hG39/1J5gxSsDY?=
 =?us-ascii?Q?58bYo2Vmi5v7h0C+ud8plgp5a5F5+A9wAey9k61IdmYY3radp2VVI2msmyr/?=
 =?us-ascii?Q?a441Ar6W2liJND5hdpENEHLhKtcSmtRMSySEvB0ArauAc6ZDakxncXlZ2PoR?=
 =?us-ascii?Q?jNhIVXuVI1zIXuQqOTr/Gmu9PdYVj9KkWlFY5Q2dkJKseRUiIWDSpZktO13X?=
 =?us-ascii?Q?kxSNmGaydXVnVwHaL3x6qNYbH/rWzkjQFFoKAwTzPQOkTvdahuWZZhFgzYmK?=
 =?us-ascii?Q?2W5slv5E5Dgp9mfwT6WxMT3ZlekQM3BoDak3YilxXgCkIUqHL+via+Ef/ex9?=
 =?us-ascii?Q?hlCcwZx3ykRzVFLfBLAhD96zwUB/HrR4iRVZw9LO7FLu6ouC0wn50j0AFInT?=
 =?us-ascii?Q?HL9KYA4JErPiZVc3y9fXjKir9+aBfwgacCEi1bbsiYXiFiSbjDge9+lmt6SV?=
 =?us-ascii?Q?7z0FmDf3FRfGHplPzGET6o3QCdeHB+4qdNnG7ZJSHIxYGeeq5KSFm35Fb2f9?=
 =?us-ascii?Q?OeJ1ZWIY/ZgexA8AHHbFBA2CLk7eNBbj3W9cQmClZ0LJPHNMgX9mf/mbSxFJ?=
 =?us-ascii?Q?mCvyNgA5dRWTjYoj98Ve6c8gK1QPVzWMY3MfSSyO3UmmKxL8iPljA8TQBJLG?=
 =?us-ascii?Q?oTR5DUHJtDJrzdFwD+UXreA7jAMIi2S64GH/YeM7pB/aJg9yLKUsU5JYFJe0?=
 =?us-ascii?Q?j9bVQ/Xxpk7vlabd/XxYqSBSKN9cWlYL4QBWO2/Yjh6yPRPRC6isgEcihYCY?=
 =?us-ascii?Q?wJi0Po1oWrd9CszfUobsmaRD5Gn+RjK3waq2Ix52vWAXcfX3T4Xec6O4iZue?=
 =?us-ascii?Q?RVKSB9uhIKaSw7BcYWDIAsolEIPsKuSn/WnbA5CaqfGvLddR0gsH5a7+dxsG?=
 =?us-ascii?Q?O3+xZkSwJCK1DtTJGUSfMqjKieFmrdPgVSaqDUezuwrWIPlnxB57r6kVDYVu?=
 =?us-ascii?Q?WzXiFnYHuu+89MEoEQqMzH1sHba4wflI3gZBagYnr6NuOdrwr8CnJPzkuaxW?=
 =?us-ascii?Q?UwvBvaycG0bg7N6utpDDc8wLju6ptWAc7av0lPJfKRjO9+C+XEmYbIPjPTwz?=
 =?us-ascii?Q?dei0Zmi42VehM8UvdWlyYuSakVXYeSFXumgwQ8KXj//VdnsEf4SDZG/Aht64?=
 =?us-ascii?Q?AsVNkZfsQ9uwoMdJ4CHjIzxlcviTbQyiuHH/pqn17EnMSm6cPXVtb9ieFiUI?=
 =?us-ascii?Q?LSiva5RFw4XGLyr8XWd3xZcZ38PtFAkBoeogzo0aRhSvkdA3xNHedZohLIvb?=
 =?us-ascii?Q?RwEsAgWlBqv9JEFY46RiLt/E4CxmkNe0VJqRrEVDXxQsdKQuv0YfWpLpSm0W?=
 =?us-ascii?Q?6bTq1X0e24lf+GBz8jl6EgiI+FILxDYzT8d/capd9epQ+lYMnwuD9bLmIX+s?=
 =?us-ascii?Q?AaojX3uydTVWoT8e6jEyqFxt7nu4Piv9psWe93HLkMF5/K4i2Ghwc6wFg0pI?=
 =?us-ascii?Q?VF/kPwe8mKQzVToB/PWeqv+23hUgGtw0kB210+EuFCAOCAcqhfzJY4xvfKzx?=
 =?us-ascii?Q?J26Q0AH0z2T+z7fvywlG99jE8JGJ3ODYQuRYpql4hbKE9+KBtoKJLTGTcTK9?=
 =?us-ascii?Q?lL2QAA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc351ca-d714-404b-40e7-08d9aea2aeb5
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 16:59:59.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1t8aneW+bBZFd/EwikN2XDw+dc5wE0HVqlthcnpouWNXK6h31gqcP8SRyH2ZwELE08SB34ORjn4TmWSuI8KG+rFeO8rzdagsH2bfFvPOtoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0830
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
 drivers/net/ethernet/marvell/prestera/Makefile     |   2 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |   1 +
 .../net/ethernet/marvell/prestera/prestera_acl.h   |   7 +
 .../ethernet/marvell/prestera/prestera_counter.c   | 474 +++++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_counter.h   |  30 ++
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 140 +++++-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  21 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |   8 +
 8 files changed, 681 insertions(+), 2 deletions(-)
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
index b7f9a7904508..a1a99f026b87 100644
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
index 000000000000..82de93913ccb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_counter.c
@@ -0,0 +1,474 @@
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
+	bool is_fetching;
+	u32 total_read;
+	struct mutex mtx;  /* protect block_list */
+	struct prestera_counter_block **block_list;
+	u32 block_list_len;
+	u32 curr_idx;
+};
+
+struct prestera_counter_block {
+	struct list_head list;
+	u32 id;
+	u32 offset;
+	u32 num_counters;
+	u32 client;
+	struct idr counter_idr;
+	bool full;
+	bool is_updating;
+	refcount_t refcnt;
+	struct mutex mtx;  /* protect stats and counter_idr */
+	struct prestera_counter_stats *stats;
+	u8 *counter_flag;
+};
+
+enum {
+	COUNTER_FLAG_READY = 0,
+	COUNTER_FLAG_INVALID = 1
+};
+
+static inline bool
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
+	if (!block) {
+		block = kzalloc(sizeof(*block), GFP_KERNEL);
+		if (!block)
+			return ERR_PTR(-ENOMEM);
+
+		err = prestera_hw_counter_block_get(counter->sw, client,
+						    &block->id, &block->offset,
+						    &block->num_counters);
+		if (err)
+			goto err_block;
+
+		block->stats = kcalloc(block->num_counters,
+				       sizeof(*block->stats), GFP_KERNEL);
+		if (!block->stats) {
+			err = -ENOMEM;
+			goto err_stats;
+		}
+
+		block->counter_flag = kcalloc(block->num_counters,
+					      sizeof(*block->counter_flag),
+					      GFP_KERNEL);
+		if (!block->counter_flag) {
+			err = -ENOMEM;
+			goto err_flag;
+		}
+
+		block->client = client;
+		mutex_init(&block->mtx);
+		refcount_set(&block->refcnt, 1);
+		idr_init_base(&block->counter_idr, block->offset);
+
+		err = prestera_counter_block_list_add(counter, block);
+		if (err)
+			goto err_list_add;
+	}
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

