Return-Path: <netdev+bounces-7497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6240C72078F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD37281951
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289621D2C7;
	Fri,  2 Jun 2023 16:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DC1D2BA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:30:01 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2083.outbound.protection.outlook.com [40.107.249.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71FEB4;
	Fri,  2 Jun 2023 09:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADf+PziJAgbCEdJy9gXH9AKX0BA2GJZ7yRpWuKTyA+OCWC/oXuVJOpki/1mAtNLSpNZnrCkLKaaMXLdxk191D326c3U7IKM9CRNKBnymvUGIO41VyZ7HNVw8FIkzrATxy8Zb289SFrhB67x+6hEGnpUuQA0/dqRLCWniAaKIVTpBhytdNgi4Zb0pSThe+Bz4ThihcqLyVEC692CiB3+O8g93dDISXxpqQxJCP/zb1gMoZcB8gX1fL7g7uk8rX2ZgtiUrMszF8NvDpmkgs7dQ0mKVf3nphaiTEDNdQE20TztpHTmMZvXYZ7Ppta04LbZ4/OLma4JcrxSPt+/PUmAA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpUPR95aWNLLc8ygCD+ogUcMebiV1U9TfzQlRtEEor4=;
 b=SmWrxprPJ76NBZSZjvesqEX1HkjdCRYxYSKPmxj3ifRaEq9KBdmX0v/Zhwr1IN6qs2Pyf0GuWQrUijVu+zzBqM+KxRhtF3tphu9JfiE/UpDwKNeDgF1s+xDMitt4qUXq6Z8i/tDS9P9+cvAeq0ML/cp3p+/vGWUyO7Ux0khXStOwsrBrronL+f4AuJ1DJO5CUF/4PsUNM1nfVe6H4NYBx3g8Bn39lgKQeEI2c0D84kZgfFAyisbI+5jwlunjKQfNvVlc4ranv61Bs1SCW6S6RMiqpdtwjkD7plne8ASMLl7xL6px55MLT529BlOz6Pd2sszxXpXuu7rDLFBE9BbKzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpUPR95aWNLLc8ygCD+ogUcMebiV1U9TfzQlRtEEor4=;
 b=bn5NTeeCQbMK8x85h87z2uZBARkOpg+gH7TiziBPAGuVyOb5KCcfTp2gTIWk0PocROq9E24g6+Q+LjwxTargtU+ReBKnueMILQ0UfYKpbLoR7XEX1Ks+brpKpSeMXohG4Wy7RFTAZam8q1z/mn1Ob/FC/cvKqbEhUFR752TLan4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM0PR04MB6867.eurprd04.prod.outlook.com (2603:10a6:208:182::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Fri, 2 Jun
 2023 16:29:52 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 16:29:52 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	linux-kernel@vger.kernel.org,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [RFC PATCH net-next] net/sched: introduce pretty printers for Qdiscs
Date: Fri,  2 Jun 2023 19:29:35 +0300
Message-Id: <20230602162935.2380811-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0120.eurprd09.prod.outlook.com
 (2603:10a6:803:78::43) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM0PR04MB6867:EE_
X-MS-Office365-Filtering-Correlation-Id: bb87a41d-dd50-446c-8abf-08db63869793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MHSnlWpxnExkRzhBeTam2LW/ljJyE8uSUyc5L1hCLueb+nYdKP35w2PatB0veU/7PFBYi65QJSQmNsGFB9QYI1RJIGHCoCK/6DHJMHstTASfQV7bArkvoUnd25tFfar3WQViVlFfmq/HYT54urAIIsAgX05AFM58J1XNLl0lBjxyEJOwv8IzM0xvRO4tqSKAkP9BR+r7DHnIBvEubypLHHdwTueOwZnaIRCUIL31+fpBHdIL1aVhV9WVg6SdQL8nkSQGlBcxKnarbfnBhrfNthBlsKt4S2SYL45cPfA2+r7ESiB4lzt8yWEw2FPZLVrCNE4OYLjoZAeLTSz6kvdfQW7HsCP/Ax6YQNNIKR6Fhk+mMv29eoKSWVN6qq3BEuYcOOUqogny/BzNLB2djp7yrwona7Sod00i+7H59ub5ILjGqVkdyvH/FrQvU5yIIDyNaxUQh6bXTeHeha0+fzjbBKr1otWWup10Ztzp8hS+TE8XDkGjDBiMoh+jN459nGoRMaqdM7AiFXqxcG38J/H0nYuGV6CmXU8jVI7cTgwJrH9V9eKaqdlZfPQ73q6xwIkqqY8vBPIoYXcvbiKjASXzA6PGsO41WC8Z+UIxfX32qst2kPHhvI6SosPmtVvCss5O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(6512007)(186003)(6506007)(1076003)(26005)(41300700001)(38350700002)(38100700002)(2616005)(83380400001)(6486002)(6666004)(52116002)(54906003)(36756003)(66556008)(66476007)(4326008)(66946007)(6916009)(478600001)(316002)(44832011)(7416002)(5660300002)(2906002)(8676002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BgDmRz0IoDfEg+dqOabpiNt1EtYHLrrH9zSoYS5gS6DMp/H7fPqscbw8hsm3?=
 =?us-ascii?Q?xHrdmzAW+XFSEcQXBZOv/eg0f0/GmCZYlUXYsQ1gX8GR2jwBUV0H0AbgAqqk?=
 =?us-ascii?Q?pMVTDFP5AiEK4E7eE0xCgzKKR/RrX5FCQWCa3BCFf8evQHFl1Hsu+Oe4czcl?=
 =?us-ascii?Q?bYiE8hDWPRjxLWGD6VpUlvkvLHfc7VLadI9jL6GCBRwM2uXsnhgB3zY3MWrp?=
 =?us-ascii?Q?uXkdF7RZwL5CQY5HQImeiN+Knr4rwCBW2LoV1P6ax1npc3Eazm8kqpV/aFFU?=
 =?us-ascii?Q?m7dwUAfRBanmCsaNWPapZiVpPhxh4N5g4c+OJZZwyO+jQ3WvSEOhInM2vz9K?=
 =?us-ascii?Q?FNf567cgn4Q0Eb4+uj93k2Z5DhwPqzWBvGtNtSkW7KBVkM7FxCLH2bD7gyJQ?=
 =?us-ascii?Q?qcH3XGydq5q9jap3j5G69d4+riT7vBE5kc9O6EA1k4C7KGkcjsl8FcybtPqx?=
 =?us-ascii?Q?v0RSVIvkHsAFEzvj5N6vZh1v09ZP9Q5XI5rhZICdgNbH+djRNPcLU/DPpvQY?=
 =?us-ascii?Q?Vd0bmmO9W9tDW7j6epHz4cGIalDCPy2I/neqVrCTParpwxhoKJR5RjG3TZ5q?=
 =?us-ascii?Q?i2YrlKP07ngUwv0Fy9YlACAyi/BJItFg1gDVxHZGHObTfBbgrwPUDqeN4II+?=
 =?us-ascii?Q?KQXpGbOWElhitInYpqX8JFG1yENQ/H9+ksr6DnWQwUXAEl4qls1REe4B3Pzh?=
 =?us-ascii?Q?lGCCHfxyAzzi2uaBQCLeAuCY39irVlsIXwqe9Pqh5247gsXchOCVb3OwF7h2?=
 =?us-ascii?Q?oy/r9aJD7z8AdWQ+tad0ARBKSKaRTopqQ2syv7BvU6trywyNLLZJ2UTQeNjX?=
 =?us-ascii?Q?F8lP1qts3GFCeVDy8M6yqXnpwmeoxembnIxVfFNDgOvNDavtSwmL2C8uyaAO?=
 =?us-ascii?Q?ytBG7+VbnFHs11/drlQsaRzMcsB/Vy2p694wcWeM5TjwpxSL96Pi+aabxIWo?=
 =?us-ascii?Q?yOXFuaKLEsvDX32PL08brbvFdC5oYz/qoTLvclmgT2JQpgXavYNsMnReryRO?=
 =?us-ascii?Q?jjqKhXvkqto0JiS07rZdifWlYySn+Drm5rlSPkkiqf7xefYelQbaV8E4AXW+?=
 =?us-ascii?Q?HrWWuvUTCTKQQ0liEC+rhR03zM2kfnYjPuXXgfX1KrN4eeds2r+cIOfwGxer?=
 =?us-ascii?Q?nWesiS2e1e9KiXA1UB7pH3ZTGGhpoJLx1yYep9yw92SreK/WmN4BJ5CE0eEG?=
 =?us-ascii?Q?FfIZ1rElJTSdraNvKw+GCmFeLfFrZ80xpUr6Dwd9VFzMfHHE2TP1kKcVhhOL?=
 =?us-ascii?Q?Q9SIIwUe5iilD1WZFv6rwRhiblCo29nSbuuf0NFvYeHLy9TpdoeZzBCfVPa9?=
 =?us-ascii?Q?FifqNNN/CM/6zBBRY6MhAkuOgU1pZAZFqufVWqzQp0rkT0GtBw8rQNyx2Dlh?=
 =?us-ascii?Q?Kb23GjxHogt0uW+7cg0mPHxfsRBcze7qoIANgPtm/ppgRAmaW/w+fgMk1rCi?=
 =?us-ascii?Q?UQiM95OX9StEu7Ug+dzWBzBJHCok2aNzQUOLpWJLXdkMnkDmSx67gWRj/oro?=
 =?us-ascii?Q?dt+7m22XBQVMov2BI6mRyo1mzw2OceqiJXTmq2mOS3OhuOQ9Fc3lczp2zs6v?=
 =?us-ascii?Q?cQvLiYa+XvPQMmhlhU3AZPNl540csvE1Z0wk/eHf7KCC3cWBKBVrCedrDpBG?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb87a41d-dd50-446c-8abf-08db63869793
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:29:52.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PuCoRQBie9sl/2hHmr+abjw15pwykJtg0WN+MlfDFMx9Hxr+Igy4b5GfDd85Qc7KjoDRaQpUWNJwIpf93wtGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6867
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sometimes when debugging Qdiscs it may be confusing to know exactly what
you're looking at, especially since they're hierarchical. Pretty printing
the handle, parent handle and netdev is a bit cumbersome, so this patch
proposes a set of wrappers around __qdisc_printk() which are heavily
inspired from __net_printk().

It is assumed that these printers will be more useful for untalented
kernel hackers such as myself rather than to the overall quality of the
code, since Qdiscs rarely print stuff to the kernel log by design (and
where they do, maybe that should be reconsidered in the first place).

A single demo conversion has been made, there is room for more if the
idea is appreciated.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/sch_debug.h | 45 +++++++++++++++++++++
 net/sched/Makefile      |  2 +-
 net/sched/sch_api.c     |  4 +-
 net/sched/sch_debug.c   | 86 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+), 3 deletions(-)
 create mode 100644 include/net/sch_debug.h
 create mode 100644 net/sched/sch_debug.c

diff --git a/include/net/sch_debug.h b/include/net/sch_debug.h
new file mode 100644
index 000000000000..032de4710671
--- /dev/null
+++ b/include/net/sch_debug.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_SCHED_DEBUG_H
+#define __NET_SCHED_DEBUG_H
+
+#include <linux/bug.h>
+#include <linux/kern_levels.h>
+
+struct Qdisc;
+
+__printf(3, 4) __cold
+void qdisc_printk(const char *level, const struct Qdisc *sch,
+		  const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_emerg(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_alert(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_crit(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_err(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_warn(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_notice(const struct Qdisc *sch, const char *format, ...);
+__printf(2, 3) __cold
+void qdisc_info(const struct Qdisc *sch, const char *format, ...);
+
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
+#define qdisc_dbg(__sch, format, args...)			\
+do {								\
+	dynamic_qdisc_dbg(__sch, format, ##args);		\
+} while (0)
+#elif defined(DEBUG)
+#define qdisc_dbg(__sch, format, args...)			\
+	qdisc_printk(KERN_DEBUG, __sch, format, ##args)
+#else
+#define qdisc_dbg(__sch, format, args...)			\
+({								\
+	if (0)							\
+		qdisc_printk(KERN_DEBUG, __sch, format, ##args); \
+})
+#endif
+
+#endif
diff --git a/net/sched/Makefile b/net/sched/Makefile
index b5fd49641d91..ab13bf7db283 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -6,7 +6,7 @@
 obj-y	:= sch_generic.o sch_mq.o
 
 obj-$(CONFIG_INET)		+= sch_frag.o
-obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
+obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o sch_debug.o
 obj-$(CONFIG_NET_CLS)		+= cls_api.o
 obj-$(CONFIG_NET_CLS_ACT)	+= act_api.o
 obj-$(CONFIG_NET_ACT_POLICE)	+= act_police.o
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fdb8f429333d..a6bfe2e40f89 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -31,6 +31,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/sch_debug.h>
 #include <net/tc_wrapper.h>
 
 #include <trace/events/qdisc.h>
@@ -597,8 +598,7 @@ EXPORT_SYMBOL(__qdisc_calculate_pkt_len);
 void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
 {
 	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
-		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
-			txt, qdisc->ops->id, qdisc->handle >> 16);
+		qdisc_warn(qdisc, "%s: qdisc is non-work-conserving?\n", txt);
 		qdisc->flags |= TCQ_F_WARN_NONWC;
 	}
 }
diff --git a/net/sched/sch_debug.c b/net/sched/sch_debug.c
new file mode 100644
index 000000000000..1f47dac88c6e
--- /dev/null
+++ b/net/sched/sch_debug.c
@@ -0,0 +1,86 @@
+#include <linux/pkt_sched.h>
+#include <net/sch_generic.h>
+#include <net/sch_debug.h>
+
+static void qdisc_handle_str(u32 handle, char *str)
+{
+	if (handle == TC_H_ROOT) {
+		sprintf(str, "root");
+		return;
+	} else if (handle == TC_H_INGRESS) {
+		sprintf(str, "ingress");
+		return;
+	} else {
+		sprintf(str, "%x:%x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
+		return;
+	}
+}
+
+static void __qdisc_printk(const char *level, const struct Qdisc *sch,
+			   struct va_format *vaf)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	char handle_str[10], parent_str[10];
+
+	qdisc_handle_str(sch->handle, handle_str);
+	qdisc_handle_str(sch->parent, parent_str);
+
+	if (dev && dev->dev.parent) {
+		dev_printk_emit(level[1] - '0',
+				dev->dev.parent,
+				"%s %s %s%s %s %s parent %s: %pV",
+				dev_driver_string(dev->dev.parent),
+				dev_name(dev->dev.parent),
+				netdev_name(dev), netdev_reg_state(dev),
+				sch->ops->id, handle_str, parent_str, vaf);
+	} else if (dev) {
+		printk("%s%s%s %s %s parent %s: %pV",
+		       level, netdev_name(dev), netdev_reg_state(dev),
+		       sch->ops->id, handle_str, parent_str, vaf);
+	} else {
+		printk("%s(NULL net_device) %s %s parent %s: %pV", level,
+		       sch->ops->id, handle_str, parent_str, vaf);
+	}
+}
+
+void qdisc_printk(const char *level, const struct Qdisc *sch,
+		  const char *format, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, format);
+
+	vaf.fmt = format;
+	vaf.va = &args;
+
+	__qdisc_printk(level, sch, &vaf);
+
+	va_end(args);
+}
+EXPORT_SYMBOL(qdisc_printk);
+
+#define define_qdisc_printk_level(func, level)			\
+void func(const struct Qdisc *sch, const char *fmt, ...)	\
+{								\
+	struct va_format vaf;					\
+	va_list args;						\
+								\
+	va_start(args, fmt);					\
+								\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+								\
+	__qdisc_printk(level, sch, &vaf);			\
+								\
+	va_end(args);						\
+}								\
+EXPORT_SYMBOL(func);
+
+define_qdisc_printk_level(qdisc_emerg, KERN_EMERG);
+define_qdisc_printk_level(qdisc_alert, KERN_ALERT);
+define_qdisc_printk_level(qdisc_crit, KERN_CRIT);
+define_qdisc_printk_level(qdisc_err, KERN_ERR);
+define_qdisc_printk_level(qdisc_warn, KERN_WARNING);
+define_qdisc_printk_level(qdisc_notice, KERN_NOTICE);
+define_qdisc_printk_level(qdisc_info, KERN_INFO);
-- 
2.34.1


