Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60B4655675
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiLXAFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiLXAFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:05:16 -0500
X-Greylist: delayed 1256 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:04:42 PST
Received: from 3.mo546.mail-out.ovh.net (3.mo546.mail-out.ovh.net [178.33.251.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F41B9C0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:42 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.108.1.236])
        by mo546.mail-out.ovh.net (Postfix) with ESMTPS id 9EFBA277BB;
        Sat, 24 Dec 2022 00:04:40 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:39 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: [PATCH bpf-next v3 12/16] bpfilter: add table structure
Date:   Sat, 24 Dec 2022 01:03:58 +0100
Message-ID: <20221224000402.476079-13-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4762838084792544887
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegiedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The table_ops structure describes a set of operations for an individual
table type.

Tables support the following set of operations:
- create: create an instance of a table from an ipt_replace blob.
- codegen: generate eBPF bytecode for a table.
- install: load BPF maps, progs, and attach them.
- uninstall: detach loaded BPF maps and progs, and unload them.
- free: free all resources used by a table.

Each table keeps an instance of iptables' table blob and an array of
rules for this blob. The array of rules provides a more convenient way
to interact with the blob's entries, while having a copy of the blob
will ease communication with iptables.

All tables created are stored in a map, used for lookups. Also, all
tables are linked into a list to ease cleanup.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |  64 +++
 net/bpfilter/context.h                        |   4 +
 net/bpfilter/table.c                          | 391 ++++++++++++++++++
 net/bpfilter/table.h                          |  59 +++
 tools/testing/selftests/bpf/bpfilter/Makefile |   2 +-
 6 files changed, 520 insertions(+), 2 deletions(-)
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 759fb6c847d1..9f5b46c70a41 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -13,7 +13,7 @@ $(LIBBPF_A):
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o logger.o map-common.o
 bpfilter_umh-objs += context.o codegen.o
-bpfilter_umh-objs += match.o xt_udp.o target.o rule.o
+bpfilter_umh-objs += match.o xt_udp.o target.o rule.o table.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index ac07b678baa7..81c9751a2a2d 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -9,6 +9,7 @@
 #include "context.h"
 
 #include <linux/kernel.h>
+#include <linux/list.h>
 
 #include <string.h>
 
@@ -72,6 +73,39 @@ static int init_target_ops_map(struct context *ctx)
 	return 0;
 }
 
+static const struct table_ops *table_ops[] = {};
+
+static int init_table_ops_map(struct context *ctx)
+{
+	int r;
+
+	r = create_map(&ctx->table_ops_map, ARRAY_SIZE(table_ops));
+	if (r) {
+		BFLOG_ERR("failed to create tables map: %s", STRERR(r));
+		return r;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(table_ops); ++i) {
+		const struct table_ops *t = table_ops[i];
+
+		r = map_upsert(&ctx->table_ops_map, t->name, (void *)t);
+		if (r) {
+			BFLOG_ERR("failed to upsert in tables map: %s",
+				  STRERR(r));
+			return r;
+		}
+	}
+
+	return 0;
+}
+
+static int init_table_index(struct context *ctx)
+{
+	INIT_LIST_HEAD(&ctx->table_index.list);
+
+	return create_map(&ctx->table_index.map, ARRAY_SIZE(table_ops));
+}
+
 int create_context(struct context *ctx)
 {
 	int r;
@@ -88,8 +122,26 @@ int create_context(struct context *ctx)
 		goto err_free_match_ops_map;
 	}
 
+	r = init_table_ops_map(ctx);
+	if (r) {
+		BFLOG_ERR("failed to initialize tables map: %s", STRERR(r));
+		goto err_free_target_ops_map;
+	}
+
+	r = init_table_index(ctx);
+	if (r) {
+		BFLOG_ERR("failed to initialize tables index: %s", STRERR(r));
+		goto err_free_table_ops_map;
+	}
+
 	return 0;
 
+err_free_table_ops_map:
+	free_map(&ctx->table_ops_map);
+
+err_free_target_ops_map:
+	free_map(&ctx->target_ops_map);
+
 err_free_match_ops_map:
 	free_map(&ctx->match_ops_map);
 
@@ -98,6 +150,18 @@ int create_context(struct context *ctx)
 
 void free_context(struct context *ctx)
 {
+	struct list_head *t;
+	struct list_head *n;
+
+	list_for_each_safe(t, n, &ctx->table_index.list) {
+		struct table *table;
+
+		table = list_entry(t, struct table, list);
+		table->table_ops->uninstall(ctx, table);
+		table->table_ops->free(table);
+	}
+	free_map(&ctx->table_index.map);
+	free_map(&ctx->table_ops_map);
 	free_map(&ctx->target_ops_map);
 	free_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index f9c34a9968b8..b0e91e37d057 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -9,9 +9,13 @@
 
 #include <search.h>
 
+#include "table.h"
+
 struct context {
 	struct hsearch_data match_ops_map;
 	struct hsearch_data target_ops_map;
+	struct hsearch_data table_ops_map;
+	struct table_index table_index;
 };
 
 int create_context(struct context *ctx);
diff --git a/net/bpfilter/table.c b/net/bpfilter/table.c
new file mode 100644
index 000000000000..4094c82c31de
--- /dev/null
+++ b/net/bpfilter/table.c
@@ -0,0 +1,391 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#define _GNU_SOURCE
+
+#include "table.h"
+
+#include <linux/err.h>
+#include <linux/list.h>
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "context.h"
+#include "logger.h"
+#include "rule.h"
+
+static int rule_offset_comparator(const void *x, const void *y)
+{
+	const struct rule *rule = y;
+
+	return x - (const void *)rule->ipt_entry;
+}
+
+static bool table_has_hook(const struct table *table, uint32_t hook)
+{
+	BUG_ON(hook >= BPFILTER_INET_HOOK_MAX);
+
+	return table->valid_hooks & (1 << hook);
+}
+
+static int table_init_rules(struct context *ctx, struct table *table,
+			    const struct bpfilter_ipt_replace *ipt_replace)
+{
+	uint32_t offset;
+
+	table->entries = malloc(table->size);
+	if (!table->entries) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	memcpy(table->entries, ipt_replace->entries, table->size);
+
+	table->rules = calloc(table->num_rules, sizeof(table->rules[0]));
+	if (!table->rules) {
+		BFLOG_ERR("out of memory");
+		return -ENOMEM;
+	}
+
+	offset = 0;
+	for (int i = 0; i < table->num_rules; ++i) {
+		const struct bpfilter_ipt_entry *ipt_entry;
+		int r;
+
+		if (table->size < offset + sizeof(*ipt_entry)) {
+			BFLOG_ERR("invalid table size: %d", table->size);
+			return -EINVAL;
+		}
+
+		ipt_entry = table->entries + offset;
+
+		if ((uintptr_t)ipt_entry % __alignof__(struct bpfilter_ipt_entry)) {
+			BFLOG_ERR("invalid alignment for struct ipt_entry");
+			return -EINVAL;
+		}
+
+		if (table->size < offset + ipt_entry->next_offset) {
+			BFLOG_ERR("invalid table size: %d", table->size);
+			return -EINVAL;
+		}
+
+		r = init_rule(ctx, ipt_entry, &table->rules[i]);
+		if (r) {
+			BFLOG_ERR("failed to initialize rule: %s",
+				  STRERR(r));
+			return r;
+		}
+
+		table->rules[i].ipt_entry = ipt_entry;
+		offset += ipt_entry->next_offset;
+	}
+
+	if (offset != ipt_replace->size) {
+		BFLOG_ERR("invalid final offset: %d", offset);
+		return -EINVAL;
+	}
+
+	if (table->num_rules != ipt_replace->num_entries) {
+		BFLOG_ERR("mismatch in number of rules: got %d, expected %d",
+			  table->num_rules, ipt_replace->num_entries);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int table_check_hooks(const struct table *table)
+{
+	uint32_t max_rule_front, max_rule_last;
+	bool check = false;
+
+	for (int i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		if (!table_has_hook(table, i))
+			continue;
+
+		if (check) {
+			if (table->hook_entry[i] <= max_rule_front) {
+				BFLOG_ERR("invalid hook entry");
+				return -EINVAL;
+			}
+
+			if (table->underflow[i] <= max_rule_last) {
+				BFLOG_ERR("invalid underflow entry");
+				return -EINVAL;
+			}
+		}
+
+		max_rule_front = table->hook_entry[i];
+		max_rule_last = table->underflow[i];
+		check = true;
+	}
+
+	return 0;
+}
+
+static int table_init_hooks(struct table *table,
+			    const struct bpfilter_ipt_replace *ipt_replace)
+{
+	for (int i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		struct rule *rule_front;
+		struct rule *rule_last;
+		int verdict;
+
+		if (!table_has_hook(table, i))
+			continue;
+
+		rule_front = table_find_rule_by_offset(table, ipt_replace->hook_entry[i]);
+		rule_last = table_find_rule_by_offset(table, ipt_replace->underflow[i]);
+
+		if (!rule_front || !rule_last) {
+			BFLOG_ERR("expected a first and last rule");
+			return -EINVAL;
+		}
+
+		if (!rule_is_unconditional(rule_last)) {
+			BFLOG_ERR("expected unconditional rule");
+			return -EINVAL;
+		}
+
+		if (!rule_has_standard_target(rule_last)) {
+			BFLOG_ERR("expected rule for a standard target");
+			return -EINVAL;
+		}
+
+		verdict = standard_target_verdict(rule_last->target.ipt_target);
+		if (verdict >= 0) {
+			BFLOG_ERR("expected a valid standard target verdict: %d",
+				  verdict);
+			return -EINVAL;
+		}
+
+		verdict = convert_verdict(verdict);
+
+		if (verdict != BPFILTER_NF_DROP && verdict != BPFILTER_NF_ACCEPT) {
+			BFLOG_ERR("verdict must be either NF_DROP or NF_ACCEPT");
+			return -EINVAL;
+		}
+
+		table->hook_entry[i] = rule_front - table->rules;
+		table->underflow[i] = rule_last - table->rules;
+	}
+
+	return table_check_hooks(table);
+}
+
+static struct rule *next_rule(const struct table *table, struct rule *rule)
+{
+	const uint32_t i = rule - table->rules;
+
+	if (table->num_rules <= i + 1) {
+		BFLOG_ERR("rule index is out of range");
+		return ERR_PTR(-EINVAL);
+	}
+
+	++rule;
+	rule->came_from = i;
+
+	return rule;
+}
+
+static struct rule *backtrack_rule(const struct table *table, struct rule *rule)
+{
+	uint32_t i = rule - table->rules;
+	int prev_i;
+
+	do {
+		rule->hook_mask ^= (1 << BPFILTER_INET_HOOK_MAX);
+		prev_i = i;
+		i = rule->came_from;
+		rule->came_from = 0;
+
+		if (i == prev_i)
+			return NULL;
+
+		rule = &table->rules[i];
+	} while (prev_i == i + 1);
+
+	return next_rule(table, rule);
+}
+
+static int table_check_chain(struct table *table, uint32_t hook,
+			     struct rule *rule)
+{
+	uint32_t i = rule - table->rules;
+
+	rule->came_from = i;
+
+	for (;;) {
+		bool visited;
+		int verdict;
+
+		if (!rule)
+			return 0;
+
+		if (IS_ERR(rule))
+			return PTR_ERR(rule);
+
+		i = rule - table->rules;
+
+		if (table->num_rules <= i) {
+			BFLOG_ERR("rule index is out of range: %d", i);
+			return -EINVAL;
+		}
+
+		if (rule->hook_mask & (1 << BPFILTER_INET_HOOK_MAX)) {
+			BFLOG_ERR("hook index out of range");
+			return -EINVAL;
+		}
+
+		// already visited
+		visited = rule->hook_mask & (1 << hook);
+		rule->hook_mask |= (1 << hook) | (1 << BPFILTER_INET_HOOK_MAX);
+
+		if (visited) {
+			rule = backtrack_rule(table, rule);
+			continue;
+		}
+
+		if (!rule_has_standard_target(rule)) {
+			rule = next_rule(table, rule);
+			continue;
+		}
+
+		verdict = standard_target_verdict(rule->target.ipt_target);
+		if (verdict > 0) {
+			rule = table_find_rule_by_offset(table, verdict);
+			if (!rule) {
+				BFLOG_ERR("failed to find rule by offset");
+				return -EINVAL;
+			}
+
+			rule->came_from = i;
+			continue;
+		}
+
+		if (!rule_is_unconditional(rule)) {
+			rule = next_rule(table, rule);
+			continue;
+		}
+
+		rule = backtrack_rule(table, rule);
+	}
+
+	return 0;
+}
+
+static int table_check_chains(struct table *table)
+{
+	int r = 0;
+
+	for (int i = 0, r = 0; !r && i < BPFILTER_INET_HOOK_MAX; ++i) {
+		if (table_has_hook(table, i))
+			r = table_check_chain(table, i, &table->rules[table->hook_entry[i]]);
+	}
+
+	return r;
+}
+
+struct table *create_table(struct context *ctx,
+			   const struct bpfilter_ipt_replace *ipt_replace)
+{
+	struct table *table;
+	int r;
+
+	table = calloc(1, sizeof(*table));
+	if (!table) {
+		BFLOG_ERR("out of memory");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	INIT_LIST_HEAD(&table->list);
+	table->valid_hooks = ipt_replace->valid_hooks;
+	table->num_rules = ipt_replace->num_entries;
+	table->num_counters = ipt_replace->num_counters;
+	table->size = ipt_replace->size;
+
+	r = table_init_rules(ctx, table, ipt_replace);
+	if (r) {
+		BFLOG_ERR("failed to initialise table rules: %s", STRERR(r));
+		goto err_free;
+	}
+
+	r = table_init_hooks(table, ipt_replace);
+	if (r) {
+		BFLOG_ERR("failed to initialise table hooks: %s", STRERR(r));
+		goto err_free;
+	}
+
+	r = table_check_chains(table);
+	if (r) {
+		BFLOG_ERR("failed to check table chains: %s", STRERR(r));
+		goto err_free;
+	}
+
+	return table;
+
+err_free:
+	free_table(table);
+
+	return ERR_PTR(r);
+}
+
+struct rule *table_find_rule_by_offset(const struct table *table,
+				       uint32_t offset)
+{
+	const struct bpfilter_ipt_entry *key;
+
+	key = table->entries + offset;
+
+	return bsearch(key, table->rules, table->num_rules,
+		       sizeof(table->rules[0]), rule_offset_comparator);
+}
+
+void table_get_info(const struct table *table,
+		    struct bpfilter_ipt_get_info *info)
+{
+	snprintf(info->name, sizeof(info->name), "%s", table->table_ops->name);
+	info->valid_hooks = table->valid_hooks;
+
+	for (int i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		const struct rule *rule_front, *rule_last;
+
+		if (!table_has_hook(table, i)) {
+			info->hook_entry[i] = 0;
+			info->underflow[i] = 0;
+			continue;
+		}
+
+		rule_front = &table->rules[table->hook_entry[i]];
+		rule_last = &table->rules[table->underflow[i]];
+		info->hook_entry[i] = (const void *)rule_front->ipt_entry - table->entries;
+		info->underflow[i] = (const void *)rule_last->ipt_entry - table->entries;
+	}
+
+	info->num_entries = table->num_rules;
+	info->size = table->size;
+}
+
+void free_table(struct table *table)
+{
+	if (!table)
+		return;
+
+	list_del(&table->list);
+
+	if (table->rules) {
+		for (int i = 0; i < table->num_rules; ++i)
+			free_rule(&table->rules[i]);
+		free(table->rules);
+	}
+
+	free(table->entries);
+	free(table);
+}
diff --git a/net/bpfilter/table.h b/net/bpfilter/table.h
new file mode 100644
index 000000000000..d683005e1755
--- /dev/null
+++ b/net/bpfilter/table.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_TABLE_H
+#define NET_BPFILTER_TABLE_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <linux/types.h>
+
+#include <search.h>
+#include <stdint.h>
+
+struct context;
+struct rule;
+struct table;
+
+struct table_ops {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	struct table *(*create)(struct context *ctx,
+				const struct bpfilter_ipt_replace *ipt_replace);
+	int (*codegen)(struct context *ctx, struct table *table);
+	int (*install)(struct context *ctx, struct table *table);
+	void (*uninstall)(struct context *ctx, struct table *table);
+	void (*free)(struct table *table);
+	void (*update_counters)(struct table *table);
+};
+
+struct table {
+	const struct table_ops *table_ops;
+	uint32_t valid_hooks;
+	uint32_t num_rules;
+	uint32_t num_counters;
+	uint32_t size;
+	uint32_t hook_entry[BPFILTER_INET_HOOK_MAX];
+	uint32_t underflow[BPFILTER_INET_HOOK_MAX];
+	struct rule *rules;
+	void *entries;
+	void *ctx;
+	struct list_head list;
+};
+
+struct table_index {
+	struct hsearch_data map;
+	struct list_head list;
+};
+
+struct table *create_table(struct context *ctx,
+			   const struct bpfilter_ipt_replace *ipt_replace);
+struct rule *table_find_rule_by_offset(const struct table *table,
+				       uint32_t offset);
+void table_get_info(const struct table *table,
+		    struct bpfilter_ipt_get_info *info);
+void free_table(struct table *table);
+
+#endif // NET_BPFILTER_TABLE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 4ef52bfe2d21..53634699d427 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -45,7 +45,7 @@ BPFILTER_RULE_SRCS := $(BPFILTERSRCDIR)/rule.c
 BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS)
 BPFILTER_COMMON_SRCS += $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/logger.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
-BPFILTER_COMMON_SRCS += $(BPFILTER_RULE_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTER_RULE_SRCS) $(BPFILTERSRCDIR)/table.c
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
-- 
2.38.1

