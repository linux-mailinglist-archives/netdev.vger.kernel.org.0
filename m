Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7554234F6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhJFAbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbhJFAbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:31:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEE5C061766;
        Tue,  5 Oct 2021 17:29:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p1so875612pfh.8;
        Tue, 05 Oct 2021 17:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTgi6QrC3BHmTI8J3/+5DjgDIrcuKtZUvmL8l9gwicQ=;
        b=Lb8Jx2+HX+68yZ0yWPfsXJDV71rc+i+6m6KCOyikcAAToyVmVOkYrRlFoZwAZv5OJ7
         nlLPHbnIavg9gRn9/Up3oPdqAAJhcrNtSxoQPSy6cX5WoYCanm5VbdSkAqr/9NARqZis
         QjTHVYeik0qWSdSG0KrPHHok4Db39C1aSa1rxcY9Akc5YsS53rh1YRxXsw+gOQNWlwu4
         I1ZWtte66ozqsjo6jt9IAMNg0R/wdyQ8R8RhOhByCfPzY2qeGx0JVzuF8Hqwak5pJtv1
         tkVD+e1IjufDS6GYDWeRvBzdg22pL++K5BINumHep9llkqh1Vog3bIQVt5CuBMHq5n78
         k7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTgi6QrC3BHmTI8J3/+5DjgDIrcuKtZUvmL8l9gwicQ=;
        b=P7dSx5hw0Do9EEQnsAzyhTuHFjrmXNfP8/+rV4JIUpq8w3gxSmvIg7XfibF9ykX5/j
         Zlsjzr64TGzIvqhWyD4MwPfzMlDEMGBkka5QsShN5vKl8A+WQPrmhf8YRhYPd+Z84mqF
         Ozdwn3F60vfCf+3VJQKnMAmaZLKJeVUU8VO3tzbCTnh/zxAS3tUsOS+0mGzw9iJsfj86
         vAmhNOY00obqJbrg4/UwkEtyGSj6kYsnkWAzfbSRXQtxpnYgBs/4UXJSFNLZPjeU/xhR
         5ZteD5igstQKgxMZnLzq1BrHieoobRRjoXdqGgcNF05T/CqaoF4WvwteRhEeCi84xc4V
         wSDw==
X-Gm-Message-State: AOAM5332BCO2duHVdDHLUvtsGZJ6mVSgi2UbYYVyEp7zXPmxT39fmDy+
        ZUrvkBlmDjeLhLemB+BtdDjeWS9cKLQ=
X-Google-Smtp-Source: ABdhPJw5Ogv0igCRAiRnnf+1HnNLIfF2A6H4Pxxxvmd3EseeuWrAbdQ+S4kFnLomgj9GuxmSH04gCw==
X-Received: by 2002:aa7:9e9a:0:b0:447:a1be:ee48 with SMTP id p26-20020aa79e9a000000b00447a1beee48mr33721275pfq.48.1633480148373;
        Tue, 05 Oct 2021 17:29:08 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id w9sm3139155pjk.28.2021.10.05.17.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:29:08 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 4/6] bpf: selftests: Move test_ksyms_weak test to lskel, add libbpf test
Date:   Wed,  6 Oct 2021 05:58:51 +0530
Message-Id: <20211006002853.308945-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4343; h=from:subject; bh=4tvYwn/5csi5Df3dmPxmGgXq6bkFX36iyn8BycVhcas=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxQqrCmUDw5RRQ3lXczpuZ7vo9kuj6AQK3LrGui 8/4lPJ+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsUAAKCRBM4MiGSL8RypQKD/ oDWREw8xu93e/2kxHE/qJWeHTq7s9jzgHKvywjoCMttHzZs11nNjd/2LuXyCqzXj38VfHQjm9VAova 9Rkni2WcHgmLwgHqbniXJnB4ly9UzjDVd4qkyKdRUMqJeDOCSjPT+kvItPi2Bv7oA3b50EinTPFtnc AUvhPgCXQNb5TbO435+9crIWwWuyN2U4R1MAG/KaRLNIbd8ASlyFAbJzT0C4bAnrD7fb+f91ShtVvn pnZNeC8p/1WNG0Cm7RyNWpno6/0ccUDhFwrBpVxzUuOw8Ha9PRx15hr3pJRRiHAB/GJEjeI5vle8kW Pgu6tRmQLiMfTsr+pC7Qy74EsttxKjb6oY8pbADuJ9vUkgHFGsuSfOXE/lac3vR6KnXT51r3S9daU+ cZXCXQXvx+vn3SxNpOLLPQuNX3bcVTKzqzo74jNhaycEX8mUEkAsX365/hHJ8ZHCzCYuB207RfRazj NiEssOe+wVj1FIU6RjTziN9uQevrtZwPMhFoSFwRsAc82dqT6oukd9MCRmutRj79raocifh2l469ax ml3lCpHSibjfCbTzod97vK1aqweLycK+3pc4cITiKmf30HvNIelkrFNi1lOzIQGlepS+np3Pv3duxP 1JUa6Lbmy/4Lpg8bwnTHIQzZMlysnHMO9Dm8jseq1zR21figdmgd3cJH7Inw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
Create a file for testing libbpf skeleton as well, so that both
gen_loader and libbpf get tested.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  6 ++--
 .../bpf/prog_tests/ksyms_weak_libbpf.c        | 31 +++++++++++++++++++
 .../selftests/bpf/progs/test_ksyms_weak.c     |  3 +-
 4 files changed, 36 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c5c9a9f50d8d..4ae5bc852ca8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -317,7 +317,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
 # Generate both light skeleton and libbpf skeleton for these
-LSKELS_EXTRA := test_ksyms_module.c
+LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index cf3acfa5a91d..21ff02d47076 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -6,7 +6,7 @@
 #include <bpf/btf.h>
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
-#include "test_ksyms_weak.skel.h"
+#include "test_ksyms_weak.lskel.h"
 
 static int duration;
 
@@ -89,11 +89,11 @@ static void test_weak_syms(void)
 	int err;
 
 	skel = test_ksyms_weak__open_and_load();
-	if (CHECK(!skel, "test_ksyms_weak__open_and_load", "failed\n"))
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
 		return;
 
 	err = test_ksyms_weak__attach(skel);
-	if (CHECK(err, "test_ksyms_weak__attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ksyms_weak__attach"))
 		goto cleanup;
 
 	/* trigger tracepoint */
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
new file mode 100644
index 000000000000..b75725e28647
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "test_ksyms_weak.skel.h"
+
+void test_ksyms_weak_libbpf(void)
+{
+	struct test_ksyms_weak *skel;
+	struct test_ksyms_weak__data *data;
+	int err;
+
+	skel = test_ksyms_weak__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
+		return;
+
+	err = test_ksyms_weak__attach(skel);
+	if (!ASSERT_OK(err, "test_ksyms_weak__attach"))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	ASSERT_EQ(data->out__existing_typed, 0, "existing typed ksym");
+	ASSERT_NEQ(data->out__existing_typeless, -1, "existing typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typeless, 0, "nonexistent typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typed, 0, "nonexistent typed ksym");
+
+cleanup:
+	test_ksyms_weak__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
index 5f8379aadb29..521e7b99db08 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -21,7 +21,6 @@ __u64 out__non_existent_typed = -1;
 extern const struct rq runqueues __ksym __weak; /* typed */
 extern const void bpf_prog_active __ksym __weak; /* typeless */
 
-
 /* non-existent weak symbols. */
 
 /* typeless symbols, default to zero. */
@@ -38,7 +37,7 @@ int pass_handler(const void *ctx)
 	/* tests existing symbols. */
 	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
 	if (rq)
-		out__existing_typed = rq->cpu;
+		out__existing_typed = 0;
 	out__existing_typeless = (__u64)&bpf_prog_active;
 
 	/* tests non-existent symbols. */
-- 
2.33.0

