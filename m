Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938E847013C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhLJNGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbhLJNGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9B6C0617A1;
        Fri, 10 Dec 2021 05:03:00 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x131so8376040pfc.12;
        Fri, 10 Dec 2021 05:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aI1nGou3Nc0FoFgo0ANOkn7CZWEGUiq9qzL72YqOolY=;
        b=mdG7fP4KWC9chzeQ9DqhLbffXruLq1D49qujLeS6E/diBgUs1kU0ZBTaAzn3t61Om4
         Xg8iKUgA8MKDmaay1/QeTuD1KpaCmthfkHsO8Ob4rs6PAEaZennv4duQgoKllCJp31jm
         ScVgH0xJCA6IthD/U04LsLBwtDGEiGXMFdXLzvHd5xJ0Myd69ShX/c2Hj7RN0XKo5fcI
         ZznaLkJTOz0g4JslEh4LLMZQ8Nfd9Iylio4q9KcX2QW5BkmhSUsdntsinDFlf3jyihID
         K76haVJ3/klvu2QAN+3QkqdvjTM+/g+DxAN62Igx/aD27Rr7hG439mKEK51RSit5MGPX
         D6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aI1nGou3Nc0FoFgo0ANOkn7CZWEGUiq9qzL72YqOolY=;
        b=f6jKzz7Fi9EFM3Z9ngcTMx47wtNRc7HdtOtjU44Xss3aTK9+JUpZWaTx3d2coYFC2F
         EjH2SrGz9wT7emHyek410PlQ9kTZbhmWc0YfVbK5yPN51JdGpqrdomykCSmtc8kj7kw1
         1/CP2YKuvUrIC8KgPX9X/sOYh48/lJZXgixajypNTGedHOrOV2wAhnH9I4OQySj8/0/S
         294jCUyHDQ0Hn4K8caiObSMnTSzrWWZptrO2/kZF24AgS6YW5yg51C7OD81GR1pO7oTM
         bwpcpCULzk+kfOqnXiTfFPTVAslaKS/4be3wk4HmTSJYb52cK0EOne+BTJREIOsVU5rr
         bPoQ==
X-Gm-Message-State: AOAM530NSmPk38xdyGMNWl3DTn5NNVmxV2mI1UAUDHyrUeH/lS/KMFFe
        GQkLES4IBnByTmaMQzICqEYAM3NIBB8=
X-Google-Smtp-Source: ABdhPJw57/lA8blBJk2VdKXInHViPIOnQrtxPMLpbvnuvE8kUoYlzKzy0q8AX29lN1350yC7nGjIsg==
X-Received: by 2002:a63:b5e:: with SMTP id a30mr20091693pgl.432.1639141379826;
        Fri, 10 Dec 2021 05:02:59 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id mi14sm13276405pjb.6.2021.12.10.05.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:59 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v3 8/9] selftests/bpf: Extend kfunc selftests
Date:   Fri, 10 Dec 2021 18:32:29 +0530
Message-Id: <20211210130230.4128676-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12528; h=from:subject; bh=55KFim4ne0RHMM1nfAOqStqfVDWbySP87cnaUnDiO6k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/U93QMIBa/AUbCL9cdPn+fNjlUKo/O5oRU65mC 1RhxVNOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP1AAKCRBM4MiGSL8RynKhD/ 9ZwfzIcAu0ryZtuIi7GJ2rbdS2yzB+6sPaM1eE5EoGgQ8qvvEfE0/mEjFJYdBT/ZsWq2nOQZ3E5Zc0 d3P7tESNz5l903d801oUkcqGRaLClK3SAbXbWjVjUoRvsuXdWUHGz9IKjB51cYEVpDhQgEmo20VdDG BJpvvZlse+n6eaO6PsuKNzq2q5I9EGUkYSiPeoNXZT1YTtHbF16YRjsX5SToF1ROUTJRKsWzzqm2UE 8VjTEtmJc53F/WNxM18PgxW6UBoSfTsGcQDvuSGLhLZtIubszJYz3DruR5yF7v0r+1EfNvU5ScwK6A 0duOQs/YNZ79zx91R9dwN6ppyHJxY1P6M8X0VdsmhrkZRkIFP+5mdCqKSA/kQM6C7fEPRYZvaZHMbF UvyomJ6xXkRNtLSg1ihVdClKm8bmNE3uazo7DsIutUrySvXby2r3AHBuaKfnL9d8GIP330/wH3x83q qBlbLGRurrDX8f/76aqCSzjGis5ogLRorfMkol3tT1dsJJz7zwwC7u5grZsjR7Iun0xOcE8+Zx07cf ZXAu26jmV4IsxIqDq70KzFYYt6xSagPTJeZm+P7L4NhVyEhqr2q5xfPbdyPsCChNZuOMZ0AqKACQLU /3naFaYxRTImTa4G2o18FZcPM9UhJOmdodlUloySOzJIIdXRoovsUJiNQD7g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
testing the various failure cases.

The failure selftests will test the following cases for kfunc:
kfunc_call_test_fail1 - Argument struct type has non-scalar member
kfunc_call_test_fail2 - Nesting depth of type > 8
kfunc_call_test_fail3 - Struct type has trailing zero-sized FAM
kfunc_call_test_fail4 - Trying to pass reg->type != PTR_TO_CTX when
			argument struct type is a ctx type
kfunc_call_test_fail5 - void * not part of mem, len pair
kfunc_call_test_fail6 - u64 * not part of mem, len pair
kfunc_call_test_fail7 - mark_btf_ld_reg copies ref_obj_id
kfunc_call_test_fail8 - Same type btf_struct_walk reference copy handled
			correctly during release (i.e. only parent
			object can be released)

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/kfunc_call.c     | 28 ++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 52 ++++++++++++++++++-
 .../bpf/progs/kfunc_call_test_fail1.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail2.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail3.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail4.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail5.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail6.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail7.c         | 24 +++++++++
 .../bpf/progs/kfunc_call_test_fail8.c         | 22 ++++++++
 10 files changed, 220 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 7d7445ccc141..b6630b9427d0 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -5,11 +5,33 @@
 #include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
+#include "kfunc_call_test_fail1.skel.h"
+#include "kfunc_call_test_fail2.skel.h"
+#include "kfunc_call_test_fail3.skel.h"
+#include "kfunc_call_test_fail4.skel.h"
+#include "kfunc_call_test_fail5.skel.h"
+#include "kfunc_call_test_fail6.skel.h"
+#include "kfunc_call_test_fail7.skel.h"
+#include "kfunc_call_test_fail8.skel.h"
 
 static void test_main(void)
 {
 	struct kfunc_call_test_lskel *skel;
 	int prog_fd, retval, err;
+	void *fskel;
+
+#define FAIL(nr)                                                               \
+	({                                                                     \
+		fskel = kfunc_call_test_fail##nr##__open_and_load();           \
+		if (!ASSERT_EQ(fskel, NULL,                                    \
+			       "kfunc_call_test_fail" #nr                      \
+			       "__open_and_load")) {                           \
+			kfunc_call_test_fail##nr##__destroy(fskel);            \
+			return;                                                \
+		}                                                              \
+	})
+
+	FAIL(1); FAIL(2); FAIL(3); FAIL(4); FAIL(5); FAIL(6); FAIL(7); FAIL(8);
 
 	skel = kfunc_call_test_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel"))
@@ -27,6 +49,12 @@ static void test_main(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
 	ASSERT_EQ(retval, 3, "test2-retval");
 
+	prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
+	ASSERT_EQ(retval, 0, "test_ref_btf_id-retval");
+
 	kfunc_call_test_lskel__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8a8cf59017aa..5aecbb9fdc68 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -1,13 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2021 Facebook */
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_tcp_helpers.h"
 
 extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
 extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
 
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+extern void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb) __ksym;
+extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
+extern void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p) __ksym;
+extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
 {
@@ -44,4 +51,45 @@ int kfunc_call_test1(struct __sk_buff *skb)
 	return ret;
 }
 
+SEC("tc")
+int kfunc_call_test_ref_btf_id(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("tc")
+int kfunc_call_test_pass(struct __sk_buff *skb)
+{
+	struct prog_test_pass1 p1 = {};
+	struct prog_test_pass2 p2 = {};
+	short a = 0;
+	__u64 b = 0;
+	long c = 0;
+	char d = 0;
+	int e = 0;
+
+	bpf_kfunc_call_test_pass_ctx(skb);
+	bpf_kfunc_call_test_pass1(&p1);
+	bpf_kfunc_call_test_pass2(&p2);
+
+	bpf_kfunc_call_test_mem_len_pass1(&a, sizeof(a));
+	bpf_kfunc_call_test_mem_len_pass1(&b, sizeof(b));
+	bpf_kfunc_call_test_mem_len_pass1(&c, sizeof(c));
+	bpf_kfunc_call_test_mem_len_pass1(&d, sizeof(d));
+	bpf_kfunc_call_test_mem_len_pass1(&e, sizeof(e));
+	bpf_kfunc_call_test_mem_len_fail2(&b, -1);
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
new file mode 100644
index 000000000000..4088000dcfc0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail1(struct prog_test_fail1 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail1(struct __sk_buff *skb)
+{
+	struct prog_test_fail1 s = {};
+
+	bpf_kfunc_call_test_fail1(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
new file mode 100644
index 000000000000..0c9779693576
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail2(struct prog_test_fail2 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail2(struct __sk_buff *skb)
+{
+	struct prog_test_fail2 s = {};
+
+	bpf_kfunc_call_test_fail2(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
new file mode 100644
index 000000000000..4e5a7493cdf7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail3(struct prog_test_fail3 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail3(struct __sk_buff *skb)
+{
+	struct prog_test_fail3 s = {};
+
+	bpf_kfunc_call_test_fail3(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
new file mode 100644
index 000000000000..01c3523c7c50
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail4(struct __sk_buff *skb)
+{
+	struct __sk_buff local_skb = {};
+
+	bpf_kfunc_call_test_pass_ctx(&local_skb);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
new file mode 100644
index 000000000000..e32f13709357
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail5(struct __sk_buff *skb)
+{
+	int a = 0;
+
+	bpf_kfunc_call_test_mem_len_fail1(&a, sizeof(a));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
new file mode 100644
index 000000000000..998626aaca35
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail6(struct __sk_buff *skb)
+{
+	int a = 0;
+
+	bpf_kfunc_call_test_mem_len_fail2((void *)&a, sizeof(a));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
new file mode 100644
index 000000000000..05d4914b0533
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail7(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *p, *p2;
+	unsigned long sp = 0;
+
+	p = bpf_kfunc_call_test_acquire(&sp);
+	if (p) {
+		p2 = p->next->next;
+		bpf_kfunc_call_test_release(p);
+		if (p2->a == 42)
+			return 1;
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c
new file mode 100644
index 000000000000..eac8637ce841
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail8(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *p, *p2;
+	unsigned long sp = 0;
+
+	p = bpf_kfunc_call_test_acquire(&sp);
+	if (p) {
+		p2 = p->next->next;
+		bpf_kfunc_call_test_release(p2);
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

