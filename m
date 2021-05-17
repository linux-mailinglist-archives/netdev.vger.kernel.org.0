Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD3386D4D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344270AbhEQWzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344274AbhEQWzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:55:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE5EC0613ED
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:46 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f75-20020a1c1f4e0000b0290171001e7329so425069wmf.1
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=It14OYF7gMIIbrH0L4XXl28vAWYtIT0X3r0wPJ+ooAY=;
        b=bd0lBuZfi2VBhYFnwlDUpimoW0GA+Fkkb60UD6aaEyiuhV9IDZ72Hj0qwmZu8Rr1+1
         c2qTCmxh3EReSM+at+RgUoy2VnfFy3jHUqfUamr8fYvOP7Gi8iH5h08pSV/JU7B9tPRx
         IIKAeXzXjPDO8tIOr+UZ2MmF231bS8Clk6mdY/bu8Dnj5KTlmqfN9tBwT8Lg9fCK7X5r
         LBt7555h2kcxomR5ZfNOu8L5oNOQ4+g1/DtEgFLjFDdFFyOsWjyJSSsZQG8gaTESbG7W
         H6Ax8Yod/IE1sFAYIhva25xZN6eIC2tThQhgQDBMGlx7NNjnZFH1/MicWDoryR0ppEm5
         lJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=It14OYF7gMIIbrH0L4XXl28vAWYtIT0X3r0wPJ+ooAY=;
        b=APG3c600vbs2xXjBaZ73TeScylUTKY+1hjPy7DPvXckS8mjuXpXRnqveLF9rO0kCRe
         OPnAAsuoxJbms06tWoPSyGkLHY9xvuucMjFOpF2dW5RCKNhvcmOaetovkLKiOH9SuQDy
         qQRaqYKOrTqW8w8DGlbweKi1K0Rls/pXa2BUCQfm94hOFm+p/B5F9uYPzGulxGo7yCpj
         Xsxbk1joaP0hjS4Xd0XxBnLg07Qis8VyvLd2Ij5mnDKNsir7r1pcJjiLwcoA6kHft2h5
         s7+CkOg1ObYjmZEmhgOFds2tSBADoVd6vT2zBekm/OCFBBzhNIFK7MJEzax7conCpZfv
         /XXQ==
X-Gm-Message-State: AOAM532QqQZicm7un+m9rsNWHPW6Nn2vheYK0fybzTd248aXEWueAxbY
        tKvtTHa/0n0JAYqHBXjeb5s1JQ==
X-Google-Smtp-Source: ABdhPJyeGwXVMAvkZFrMfuxwcAWHZLjeiDV3+/4+fg9U1jReSyUWTUDDAGPrCQUNNudDMTbNy8t8Pw==
X-Received: by 2002:a1c:4b0c:: with SMTP id y12mr1400098wma.28.1621292025233;
        Mon, 17 May 2021 15:53:45 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id q10sm16152189wmc.31.2021.05.17.15.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:45 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 07/11] bpfilter: Add struct target
Date:   Tue, 18 May 2021 02:53:04 +0400
Message-Id: <20210517225308.720677-8-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct target_ops defines polymorphic interface for targets. A target
consists of pointers to struct target_ops and struct xt_entry_target
which contains a payload for the target's type.

All target_ops are kept in map target_ops_map by their name.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |  34 +++++-
 net/bpfilter/context.h                        |   2 +
 net/bpfilter/target-ops-map.h                 |  49 ++++++++
 net/bpfilter/target.c                         | 112 ++++++++++++++++++
 net/bpfilter/target.h                         |  34 ++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   5 +-
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  31 +++++
 .../selftests/bpf/bpfilter/test_target.c      |  85 +++++++++++++
 10 files changed, 352 insertions(+), 3 deletions(-)
 create mode 100644 net/bpfilter/target-ops-map.h
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index d1a36dd2c666..f3de07bc8004 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o io.o map-common.o match.o context.o
+bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index 96735c7883bf..a77134008540 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 
 #include "match.h"
+#include "target.h"
 
 static int init_match_ops_map(struct context *ctx)
 {
@@ -30,12 +31,43 @@ static int init_match_ops_map(struct context *ctx)
 	return 0;
 }
 
+static int init_target_ops_map(struct context *ctx)
+{
+	const struct target_ops *target_ops[] = { &standard_target_ops, &error_target_ops };
+	int i, err;
+
+	err = create_target_ops_map(&ctx->target_ops_map, ARRAY_SIZE(target_ops));
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(target_ops); ++i) {
+		err = target_ops_map_insert(&ctx->target_ops_map, target_ops[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int create_context(struct context *ctx)
 {
-	return init_match_ops_map(ctx);
+	int err;
+
+	err = init_match_ops_map(ctx);
+	if (err)
+		return err;
+
+	err = init_target_ops_map(ctx);
+	if (err) {
+		free_match_ops_map(&ctx->match_ops_map);
+		return err;
+	}
+
+	return 0;
 }
 
 void free_context(struct context *ctx)
 {
+	free_target_ops_map(&ctx->target_ops_map);
 	free_match_ops_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index a3e737b603f0..c62c1ba4781c 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -9,11 +9,13 @@
 #include <stdio.h>
 
 #include "match-ops-map.h"
+#include "target-ops-map.h"
 
 struct context {
 	FILE *log_file;
 	int log_level;
 	struct match_ops_map match_ops_map;
+	struct target_ops_map target_ops_map;
 };
 
 int create_context(struct context *ctx);
diff --git a/net/bpfilter/target-ops-map.h b/net/bpfilter/target-ops-map.h
new file mode 100644
index 000000000000..6b65241328da
--- /dev/null
+++ b/net/bpfilter/target-ops-map.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_TARGET_OPS_MAP_H
+#define NET_BPFILTER_TARGET_OPS_MAP_H
+
+#include "map-common.h"
+
+#include <linux/err.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "target.h"
+
+struct target_ops_map {
+	struct hsearch_data index;
+};
+
+static inline int create_target_ops_map(struct target_ops_map *map, size_t nelem)
+{
+	return create_map(&map->index, nelem);
+}
+
+static inline const struct target_ops *target_ops_map_find(struct target_ops_map *map,
+							   const char *name)
+{
+	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
+
+	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
+		return map_find(&map->index, name);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int target_ops_map_insert(struct target_ops_map *map,
+					const struct target_ops *target_ops)
+{
+	return map_insert(&map->index, target_ops->name, (void *)target_ops);
+}
+
+static inline void free_target_ops_map(struct target_ops_map *map)
+{
+	free_map(&map->index);
+}
+
+#endif // NET_BPFILTER_TARGET_OPS_MAP_H
diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
new file mode 100644
index 000000000000..a18fe477f93c
--- /dev/null
+++ b/net/bpfilter/target.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "target.h"
+
+#include <linux/err.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "bflog.h"
+#include "context.h"
+#include "target-ops-map.h"
+
+static int convert_verdict(int verdict)
+{
+	return -verdict - 1;
+}
+
+static int standard_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
+
+	if (standard_target->verdict > 0)
+		return 0;
+
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
+	BFLOG_DEBUG(ctx, "invalid verdict: %d\n", standard_target->verdict);
+
+	return -EINVAL;
+}
+
+const struct target_ops standard_target_ops = {
+	.name = "",
+	.revision = 0,
+	.size = sizeof(struct xt_standard_target),
+	.check = standard_target_check,
+};
+
+static int error_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_error_target *error_target;
+	size_t maxlen;
+
+	error_target = (const struct bpfilter_ipt_error_target *)&ipt_target;
+	maxlen = sizeof(error_target->error_name);
+	if (strnlen(error_target->error_name, maxlen) == maxlen) {
+		BFLOG_DEBUG(ctx, "cannot check error target: too long errorname\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+const struct target_ops error_target_ops = {
+	.name = "ERROR",
+	.revision = 0,
+	.size = sizeof(struct xt_error_target),
+	.check = error_target_check,
+};
+
+int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
+		struct target *target)
+{
+	const size_t maxlen = sizeof(ipt_target->u.user.name);
+	const struct target_ops *found;
+	int err;
+
+	if (strnlen(ipt_target->u.user.name, maxlen) == maxlen) {
+		BFLOG_DEBUG(ctx, "cannot init target: too long target name\n");
+		return -EINVAL;
+	}
+
+	found = target_ops_map_find(&ctx->target_ops_map, ipt_target->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find target by name: '%s'\n", ipt_target->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size != ipt_target->u.target_size ||
+	    found->revision != ipt_target->u.user.revision) {
+		BFLOG_DEBUG(ctx, "invalid target: '%s'\n", ipt_target->u.user.name);
+		return -EINVAL;
+	}
+
+	err = found->check(ctx, ipt_target);
+	if (err)
+		return err;
+
+	target->target_ops = found;
+	target->ipt_target = ipt_target;
+
+	return 0;
+}
diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
new file mode 100644
index 000000000000..5d9c4c459c05
--- /dev/null
+++ b/net/bpfilter/target.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_TARGET_H
+#define NET_BPFILTER_TARGET_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <stdint.h>
+
+struct context;
+struct target_ops_map;
+
+struct target_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint16_t size;
+	uint8_t revision;
+	int (*check)(struct context *ctx, const struct bpfilter_ipt_target *ipt_target);
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
+int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
+		struct target *target);
+
+#endif // NET_BPFILTER_TARGET_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index e5073231f811..1856d0515f49 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -2,3 +2,4 @@
 test_io
 test_map
 test_match
+test_target
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 362c9a28b88d..78da74b9ee68 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -11,6 +11,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 TEST_GEN_PROGS += test_io
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
+TEST_GEN_PROGS += test_target
 
 KSFT_KHDR_INSTALL := 1
 
@@ -19,4 +20,6 @@ include ../../lib.mk
 $(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
 $(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/map-common.c \
-	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c
+	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/target.c
+$(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/map-common.c \
+	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/match.c
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
new file mode 100644
index 000000000000..d82ff86f280e
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef BPFILTER_UTIL_H
+#define BPFILTER_UTIL_H
+
+#include <linux/bpfilter.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <stdio.h>
+
+static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
+					int verdict)
+{
+	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_STANDARD_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	ipt_target->verdict = verdict;
+}
+
+static inline void init_error_target(struct xt_error_target *ipt_target, int revision,
+				     const char *error_name)
+{
+	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_ERROR_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
+}
+
+#endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_target.c b/tools/testing/selftests/bpf/bpfilter/test_target.c
new file mode 100644
index 000000000000..6765497b53c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_target.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include "context.h"
+#include "target.h"
+
+#include <linux/bpfilter.h>
+#include <linux/err.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#include "../../kselftest_harness.h"
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
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
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
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
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
2.25.1

