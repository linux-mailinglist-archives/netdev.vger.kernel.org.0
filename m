Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05D9655686
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiLXAK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiLXAKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:10:25 -0500
X-Greylist: delayed 338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:10:23 PST
Received: from 4.mo547.mail-out.ovh.net (4.mo547.mail-out.ovh.net [46.105.39.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924F719D
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:10:23 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.208.143])
        by mo547.mail-out.ovh.net (Postfix) with ESMTPS id 3FDE820ED3;
        Sat, 24 Dec 2022 00:04:38 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:36 +0100
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
Subject: [PATCH bpf-next v3 10/16] bpfilter: add target structure
Date:   Sat, 24 Dec 2022 01:03:56 +0100
Message-ID: <20221224000402.476079-11-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4761993658134752887
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeetfeejvefgueejfeduhfegudduffelffetffffteelueeileeiudduvedugfeufeenucffohhmrghinhepuhhsvghrrdhnrghmvgdpuhhsvghrrdhtrghrghgvthenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlh
 esfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrgeskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegjedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add target structure, containing a pointer to a target_ops structure and
a pointer to an xt_entry_target structure. The later containing the
payload for the target's type.

target_ops structure provides two operations:
- check: validates the target.
- gen_inline: generate the eBPF bytecode for the target.

All target_ops are kept in a map by their name.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |  42 ++++
 net/bpfilter/context.h                        |   1 +
 net/bpfilter/target.c                         | 203 ++++++++++++++++++
 net/bpfilter/target.h                         |  57 +++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   5 +-
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  23 ++
 .../selftests/bpf/bpfilter/test_target.c      |  83 +++++++
 9 files changed, 415 insertions(+), 2 deletions(-)
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 345341a9ee30..7e642e0ae932 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -13,7 +13,7 @@ $(LIBBPF_A):
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o logger.o map-common.o
 bpfilter_umh-objs += context.o codegen.o
-bpfilter_umh-objs += match.o xt_udp.o
+bpfilter_umh-objs += match.o xt_udp.o target.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index f420fb8b6507..ac07b678baa7 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -15,6 +15,7 @@
 #include "logger.h"
 #include "map-common.h"
 #include "match.h"
+#include "target.h"
 
 static const struct match_ops *match_ops[] = { &xt_udp };
 
@@ -42,6 +43,35 @@ static int init_match_ops_map(struct context *ctx)
 	return 0;
 }
 
+static const struct target_ops *target_ops[] = {
+	&standard_target_ops,
+	&error_target_ops
+};
+
+static int init_target_ops_map(struct context *ctx)
+{
+	int r;
+
+	r = create_map(&ctx->target_ops_map, ARRAY_SIZE(target_ops));
+	if (r) {
+		BFLOG_ERR("failed to create targets map: %s", STRERR(r));
+		return r;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(target_ops); ++i) {
+		const struct target_ops *t = target_ops[i];
+
+		r = map_upsert(&ctx->target_ops_map, t->name, (void *)t);
+		if (r) {
+			BFLOG_ERR("failed to upsert in targets map: %s",
+				  STRERR(r));
+			return r;
+		}
+	}
+
+	return 0;
+}
+
 int create_context(struct context *ctx)
 {
 	int r;
@@ -52,10 +82,22 @@ int create_context(struct context *ctx)
 		return r;
 	}
 
+	r = init_target_ops_map(ctx);
+	if (r) {
+		BFLOG_ERR("failed to initialize targets map: %s", STRERR(r));
+		goto err_free_match_ops_map;
+	}
+
 	return 0;
+
+err_free_match_ops_map:
+	free_map(&ctx->match_ops_map);
+
+	return r;
 }
 
 void free_context(struct context *ctx)
 {
+	free_map(&ctx->target_ops_map);
 	free_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index e36aa8ebf57e..f9c34a9968b8 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -11,6 +11,7 @@
 
 struct context {
 	struct hsearch_data match_ops_map;
+	struct hsearch_data target_ops_map;
 };
 
 int create_context(struct context *ctx);
diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
new file mode 100644
index 000000000000..a96ec7735c0e
--- /dev/null
+++ b/net/bpfilter/target.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#define _GNU_SOURCE
+
+#include "target.h"
+
+#include <linux/err.h>
+#include <linux/filter.h>
+#include <linux/list.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "codegen.h"
+#include "context.h"
+#include "logger.h"
+#include "map-common.h"
+
+static const struct target_ops *target_ops_map_find(struct hsearch_data *map,
+						    const char *name)
+{
+	const size_t len = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
+
+	if (len < BPFILTER_EXTENSION_MAXNAMELEN)
+		return map_find(map, name);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static int standard_target_check(struct context *ctx,
+				 const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
+
+	// Positive values of verdict denote a jump offset into a blob.
+	if (standard_target->verdict > 0)
+		return 0;
+
+	// Special values like ACCEPT, DROP, RETURN are encoded as negative values.
+	if (standard_target->verdict < 0) {
+		if (standard_target->verdict == BPFILTER_RETURN)
+			return 0;
+
+		switch (convert_verdict(standard_target->verdict)) {
+		case BPFILTER_NF_ACCEPT:
+		case BPFILTER_NF_DROP:
+		case BPFILTER_NF_QUEUE:
+			return 0;
+		}
+	}
+
+	BFLOG_ERR("unsupported verdict: %d", standard_target->verdict);
+
+	return -EINVAL;
+}
+
+static int standard_target_gen_inline(struct codegen *ctx,
+				      const struct target *target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+	int r;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)target->ipt_target;
+
+	if (standard_target->verdict >= 0) {
+		struct codegen_subprog_desc *subprog;
+		struct codegen_fixup_desc *fixup;
+
+		subprog = malloc(sizeof(*subprog));
+		if (!subprog) {
+			BFLOG_ERR("out of memory");
+			return -ENOMEM;
+		}
+
+		INIT_LIST_HEAD(&subprog->list);
+		subprog->type = CODEGEN_SUBPROG_USER_CHAIN;
+		subprog->insn = 0;
+		subprog->offset = standard_target->verdict;
+
+		fixup = malloc(sizeof(*fixup));
+		if (!fixup) {
+			BFLOG_ERR("out of memory");
+			free(subprog);
+			return -ENOMEM;
+		}
+
+		INIT_LIST_HEAD(&fixup->list);
+		fixup->type = CODEGEN_FIXUP_JUMP_TO_CHAIN;
+		fixup->insn = ctx->len_cur;
+		fixup->offset = standard_target->verdict;
+
+		list_add_tail(&fixup->list, &ctx->fixup);
+
+		r = codegen_push_awaiting_subprog(ctx, subprog);
+		if (r) {
+			BFLOG_ERR("failed to push awaiting subprog: %s",
+				  STRERR(r));
+			return r;
+		}
+
+		EMIT(ctx, BPF_JMP_IMM(BPF_JA, 0, 0, 0));
+
+		return 0;
+	}
+
+	if (standard_target->verdict == BPFILTER_RETURN) {
+		EMIT(ctx, BPF_EXIT_INSN());
+		return 0;
+	}
+
+	r = ctx->codegen_ops->emit_ret_code(ctx, convert_verdict(standard_target->verdict));
+	if (r) {
+		BFLOG_ERR("failed to emit return code: %s", STRERR(r));
+		return r;
+	}
+
+	EMIT(ctx, BPF_EXIT_INSN());
+
+	return 0;
+}
+
+const struct target_ops standard_target_ops = {
+	.name = "",
+	.revision = 0,
+	.size = sizeof(struct xt_standard_target),
+	.check = standard_target_check,
+	.gen_inline = standard_target_gen_inline,
+};
+
+static int error_target_check(struct context *ctx,
+			      const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_error_target *error_target;
+	size_t maxlen;
+
+	error_target = (const struct bpfilter_ipt_error_target *)ipt_target;
+	maxlen = sizeof(error_target->error_name);
+	if (strnlen(error_target->error_name, maxlen) == maxlen) {
+		BFLOG_ERR("failed to check error target: too long errorname");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int error_target_gen_inline(struct codegen *ctx,
+				   const struct target *target)
+{
+	return -EINVAL;
+}
+
+const struct target_ops error_target_ops = {
+	.name = "ERROR",
+	.revision = 0,
+	.size = sizeof(struct xt_error_target),
+	.check = error_target_check,
+	.gen_inline = error_target_gen_inline,
+};
+
+int init_target(struct context *ctx,
+		const struct bpfilter_ipt_target *ipt_target,
+		struct target *target)
+{
+	const size_t maxlen = sizeof(ipt_target->u.user.name);
+	const struct target_ops *found;
+	int r;
+
+	if (strnlen(ipt_target->u.user.name, maxlen) == maxlen) {
+		BFLOG_ERR("cannot init target: too long target name '%s'",
+			  ipt_target->u.user.name);
+		return -EINVAL;
+	}
+
+	found = target_ops_map_find(&ctx->target_ops_map,
+				    ipt_target->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_ERR("cannot find target by name '%s' in map",
+			  ipt_target->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size != ipt_target->u.target_size ||
+	    found->revision != ipt_target->u.user.revision) {
+		BFLOG_ERR("invalid target size: '%s'", ipt_target->u.user.name);
+		return -EINVAL;
+	}
+
+	r = found->check(ctx, ipt_target);
+	if (r)
+		return r;
+
+	target->target_ops = found;
+	target->ipt_target = ipt_target;
+
+	return 0;
+}
diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
new file mode 100644
index 000000000000..57bae658b6a2
--- /dev/null
+++ b/net/bpfilter/target.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_TARGET_H
+#define NET_BPFILTER_TARGET_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <stdint.h>
+
+struct codegen;
+struct context;
+struct target;
+struct target_ops_map;
+
+struct target_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint8_t revision;
+	uint16_t size;
+	int (*check)(struct context *ctx,
+		     const struct bpfilter_ipt_target *ipt_target);
+	int (*gen_inline)(struct codegen *ctx, const struct target *target);
+};
+
+struct target {
+	const struct target_ops *target_ops;
+	const struct bpfilter_ipt_target *ipt_target;
+};
+
+extern const struct target_ops standard_target_ops;
+extern const struct target_ops error_target_ops;
+
+/* Restore verdict's special value(ACCEPT, DROP, etc.) from its negative
+ * representation.
+ */
+static inline int convert_verdict(int verdict)
+{
+	return -verdict - 1;
+}
+
+static inline int standard_target_verdict(const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
+
+	return standard_target->verdict;
+}
+
+int init_target(struct context *ctx,
+		const struct bpfilter_ipt_target *ipt_target,
+		struct target *target);
+
+#endif // NET_BPFILTER_TARGET_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index f84cc86493df..89912a44109f 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -3,3 +3,4 @@ tools/**
 test_map
 test_match
 test_xt_udp
+test_target
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 97f8d596de36..587951d14c0c 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -13,6 +13,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
 TEST_GEN_PROGS += test_xt_udp
+TEST_GEN_PROGS += test_target
 
 KSFT_KHDR_INSTALL := 1
 
@@ -37,11 +38,13 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
+BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
 
 BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS)
 BPFILTER_COMMON_SRCS += $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/logger.c
-BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
 $(OUTPUT)/test_xt_udp: test_xt_udp.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
index 705fd1777a67..0d6a6bee5514 100644
--- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -19,4 +19,27 @@ static inline void init_entry_match(struct xt_entry_match *match,
 	match->u.user.revision = revision;
 }
 
+static inline void init_standard_target(struct xt_standard_target *ipt_target,
+					int revision, int verdict)
+{
+	snprintf(ipt_target->target.u.user.name,
+		 sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_STANDARD_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	ipt_target->verdict = verdict;
+}
+
+static inline void init_error_target(struct xt_error_target *ipt_target,
+				     int revision, const char *error_name)
+{
+	snprintf(ipt_target->target.u.user.name,
+		 sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_ERROR_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s",
+		 error_name);
+}
+
 #endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_target.c b/tools/testing/selftests/bpf/bpfilter/test_target.c
new file mode 100644
index 000000000000..0ebe4b052a9b
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_target.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <linux/bpfilter.h>
+#include <linux/netfilter/x_tables.h>
+
+#include "../../kselftest_harness.h"
+
+#include "context.h"
+#include "logger.h"
+#include "target.h"
+
+#include "bpfilter_util.h"
+
+FIXTURE(test_standard_target)
+{
+	struct context ctx;
+	struct xt_standard_target ipt_target;
+	struct target target;
+};
+
+FIXTURE_VARIANT(test_standard_target)
+{
+	int verdict;
+};
+
+FIXTURE_VARIANT_ADD(test_standard_target, accept) {
+	.verdict = -BPFILTER_NF_ACCEPT - 1,
+};
+
+FIXTURE_VARIANT_ADD(test_standard_target, drop) {
+	.verdict = -BPFILTER_NF_DROP - 1,
+};
+
+FIXTURE_SETUP(test_standard_target)
+{
+	logger_set_file(stderr);
+	ASSERT_EQ(0, create_context(&self->ctx));
+
+	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
+	init_standard_target(&self->ipt_target, 0, variant->verdict);
+}
+
+FIXTURE_TEARDOWN(test_standard_target)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_standard_target, init)
+{
+	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
+				 &self->target));
+}
+
+FIXTURE(test_error_target)
+{
+	struct context ctx;
+	struct xt_error_target ipt_target;
+	struct target target;
+};
+
+FIXTURE_SETUP(test_error_target)
+{
+	logger_set_file(stderr);
+	ASSERT_EQ(0, create_context(&self->ctx));
+
+	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
+	init_error_target(&self->ipt_target, 0, "x");
+}
+
+FIXTURE_TEARDOWN(test_error_target)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_error_target, init)
+{
+	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
+				 &self->target));
+}
+
+TEST_HARNESS_MAIN
-- 
2.38.1

