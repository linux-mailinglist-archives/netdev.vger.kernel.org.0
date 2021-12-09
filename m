Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF8946F133
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhLIRNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242577AbhLIRNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:43 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5365C0617A1;
        Thu,  9 Dec 2021 09:10:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id k64so5968631pfd.11;
        Thu, 09 Dec 2021 09:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qm2U5bTkEJTdtWyXDG71Entszgzc/RhG3xXJ9RDf29M=;
        b=Ru4+tqYaBY3jTI7+i8QZfM9dWZCDefqtVMV7NZPnSwyo9rItGL8dM+rbIOnGGRI0QZ
         CaeHEOttcrA0oRucxXBuvf4h5OFjII10mh/3fALUglMi3Ny0F3HySPir19Qxss2jgeyw
         5st0GW/1O65utq1fEm5wokYs8PExq0+TiwYtj0GcICsBKI26jTKxMSv9esSe3qI1fw9u
         uUPW7CvranSJxi6yQM8QiZQJVzJkjTRkzkEvLm/fxHsfyT1Bgb8rF29FmwUKiY0vT6km
         n0t83X0gO7zxOAAaiFb+c/JdjJl+cjoF9tDkwSSnnsA0FN8SRCyYvF9K5NGaWBHoj6FF
         c2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qm2U5bTkEJTdtWyXDG71Entszgzc/RhG3xXJ9RDf29M=;
        b=cRLrHtx7LJS/JpmyStUTXsnT23rpmWdnFWaW6CNVYuTjQFDMzQdBpvTUkHfuknLM+/
         AGv8NG0jrC3cUKXY/wZ27FS6VnBI7OzKf4BeGrtu6euSAlX/WX+7Yu6ZH6DtA0Vk13/d
         mbLUa8U0IiTD2+n8m0IhLEs7AyjIm9/Exmv7MF2DNjzDEV2l9VN4DZtqLNFD25Wlp9Jr
         F79slaE2332DP+/txL2ZcoYA+u99HSiioLGKFqrCHtyHlhrb/zP47NQ1ztePIeD9VbOZ
         A3TOzLzTdCJzTY5fQ0NjMOIZbwk8vjLkQ/fjf+g9fOi4emmcBvbaYjsmV/cqUKIWJ0FR
         yFQg==
X-Gm-Message-State: AOAM5314p85ZmRJ/j5fRSmkGxyR7HwVy7y12V6VP+kobP1QGkvna86FW
        ENO65rRtiTXXSq8jnsLLwi8SHNMztMw=
X-Google-Smtp-Source: ABdhPJyumObBNlYb5jF6ye0EO8v0mc8Sm4sW4hWMYZiOvBLixYcNIxPeiiqyEQ5YRvNqWOhUmQKTYg==
X-Received: by 2002:a05:6a00:10d3:b0:4a4:e516:826f with SMTP id d19-20020a056a0010d300b004a4e516826fmr12862357pfu.70.1639069800279;
        Thu, 09 Dec 2021 09:10:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id t67sm271655pfd.24.2021.12.09.09.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:59 -0800 (PST)
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
Subject: [PATCH bpf-next v2 9/9] selftests/bpf: Add test for unstable CT lookup API
Date:   Thu,  9 Dec 2021 22:39:29 +0530
Message-Id: <20211209170929.3485242-10-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9113; h=from:subject; bh=+oKhHtTdeDTEem517MijXEkkhf1i2X5kWae8iRTXYG8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgIWbucVzRpT2e+Xac2C7LdIpXLjyge4u6GMVcc kfG1lheJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4CAAKCRBM4MiGSL8Ryp9QD/ 43VDUHs+oojMUrgSlZtOQpYa5S6zL9ohnLP7XksaRlfZg6oOgTLrDvNiGLgHhtMk2EiAUtFtNMMYwR OM4rB3Nbx9YmFfwA6cXV7GmU/zOa0iDuOY+w2DoXBweSnpt8n1IvZr1S6wtm0uE6cCScmhwn+8lUJD MIB9Wvt673+5AFGFgqNMxCtkyNvoVeEfU6YRLIxMn+7jLw4SoFo+2tOz7RhQDNkLJyy+mV5U7dATyy n+g6B+q4IUbwuU6s1OjI4vG7bV9mYWkJ7ktcg6OpW29f0yCuMX64fHqH0zvliMyiStgJadZEXQbern 9rotgIm9xcYyJyP7m2sKimiCDOWO64BferFIHUiBc5OblfrwtzQFRUzaiOedWdJ5lwUeTvm8Hyqx+T +hqvk4gzHqNXXtsj/DINJX01PQYw1O7lEhBCBvpB45WoFS0xYi9HmCRok0zFZFWtFQaPkPV0xxoMnV eGRtpKxj8Jts12m/65qg5LblR/t/YpLrqfaoKzYPKs1ZO8S8ttcZ1m80kXg7cKg3lAXBf+AC3I6XTV +BB7qo3v369y9Guhh7lQcZXredo9B1HP9nKCeX7//aTpNRrCfiY7qyb5iqF39nury3H7MkvZMjOeg5 X/1iyscW27UZ2DmM5gpR1sPjjanC0HtlyTcBfk2xdW+qtydvg1EfXJII2qyQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests that we return errors as documented, and also that the kfunc
calls work from both XDP and TC hooks.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 ++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 113 ++++++++++++++++++
 3 files changed, 165 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 5192305159ec..4a2a47fcd6ef 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -46,3 +46,7 @@ CONFIG_IMA_READ_POLICY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_NETFILTER=y
+CONFIG_NF_DEFRAG_IPV4=y
+CONFIG_NF_DEFRAG_IPV6=y
+CONFIG_NF_CONNTRACK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
new file mode 100644
index 000000000000..56e8d745b8c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_bpf_nf.skel.h"
+
+enum {
+	TEST_XDP,
+	TEST_TC_BPF,
+};
+
+void test_bpf_nf_ct(int mode)
+{
+	struct test_bpf_nf *skel;
+	int prog_fd, err, retval;
+
+	skel = test_bpf_nf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
+		return;
+
+	if (mode == TEST_XDP)
+		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
+	else
+		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
+
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
+				(__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto end;
+
+	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
+	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
+	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
+	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
+	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
+	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
+	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
+	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT,"Test EAFNOSUPPORT for invalid len__tuple");
+end:
+	test_bpf_nf__destroy(skel);
+}
+
+void test_bpf_nf(void)
+{
+	if (test__start_subtest("xdp-ct"))
+		test_bpf_nf_ct(TEST_XDP);
+	if (test__start_subtest("tc-bpf-ct"))
+		test_bpf_nf_ct(TEST_TC_BPF);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
new file mode 100644
index 000000000000..7cfff245b24f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define EAFNOSUPPORT 97
+#define EPROTO 71
+#define ENONET 64
+#define EINVAL 22
+#define ENOENT 2
+
+int test_einval_bpf_tuple = 0;
+int test_einval_reserved = 0;
+int test_einval_netns_id = 0;
+int test_einval_len_opts = 0;
+int test_eproto_l4proto = 0;
+int test_enonet_netns_id = 0;
+int test_enoent_lookup = 0;
+int test_eafnosupport = 0;
+
+struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __weak __ksym;
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __weak __ksym;
+void bpf_ct_release(struct nf_conn *) __weak __ksym;
+
+#define nf_ct_test(func, ctx)                                                  \
+	({                                                                     \
+		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
+						.netns_id = -1 };              \
+		struct bpf_sock_tuple bpf_tuple;                               \
+		struct nf_conn *ct;                                            \
+                                                                               \
+		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
+		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_bpf_tuple = opts_def.error;                \
+                                                                               \
+		opts_def.reserved[0] = 1;                                      \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.reserved[0] = 0;                                      \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_reserved = opts_def.error;                 \
+                                                                               \
+		opts_def.netns_id = -2;                                        \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_netns_id = opts_def.error;                 \
+                                                                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def) - 1);                               \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_len_opts = opts_def.error;                 \
+                                                                               \
+		opts_def.l4proto = IPPROTO_ICMP;                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eproto_l4proto = opts_def.error;                  \
+                                                                               \
+		opts_def.netns_id = 0xf00f;                                    \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enonet_netns_id = opts_def.error;                 \
+                                                                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enoent_lookup = opts_def.error;                   \
+                                                                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1,         \
+			  &opts_def, sizeof(opts_def));                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eafnosupport = opts_def.error;                    \
+	})
+
+SEC("xdp")
+int nf_xdp_ct_test(struct xdp_md *ctx)
+{
+	nf_ct_test(bpf_xdp_ct_lookup, ctx);
+	return 0;
+}
+
+SEC("tc")
+int nf_skb_ct_test(struct __sk_buff *ctx)
+{
+	nf_ct_test(bpf_skb_ct_lookup, ctx);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

