Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16148B54A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345935AbiAKSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350389AbiAKSGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:06:01 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3C8C034009;
        Tue, 11 Jan 2022 10:05:21 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z3so18426399plg.8;
        Tue, 11 Jan 2022 10:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y8WPqZOFxbPJoQcZN2ooGmiwiIT8eHvGY9NSUvSKEeQ=;
        b=aZ2W4E2i4J1Dv1/sl3hcOctH6aP6qxm+1BgEM2+4NnWqt32SN4E+oM45zYLuEFEN9G
         Eau30bfsPCzeRwfaReRrTbcJ+UEY6UkZlsxmtgDV0twjq8i6mLISzaglMpZLU+yoRHeF
         5YAVAkXLmCcR4lGvk4Xi6U36MTDLBQN6+lg6AxRAkUbZ6/YuF+7NyKopzNqRteTBIojJ
         BCVTBs7yWA2hVndn7pQ/MmRQSXc9X2/9J8GAWZ2PNx5K2ZAVP8C9X8wJx4V19Po5V6Xj
         wGX6YSuf4eByC8d1g6ZvXJrWagxn9JW5QYJmRRJZUgY9MZcdoGzpaMrDu9l0WhktVdIf
         GIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8WPqZOFxbPJoQcZN2ooGmiwiIT8eHvGY9NSUvSKEeQ=;
        b=IMx9TumdffKYHj4QHzr9rmpsKVfFfyeUGzx8Rcm5k8dumfWr7d4WthkZ7sR/WkXcSl
         8NE11Cfr9ckkTg+GrZG/5HiPDnrYJdXU9OUAZfeBzDq8oRmoRCn7wylDt9gZIC9qCiy7
         K8HF3hQ6xeLst5BPponLG98J+PGe+OXtucZaIpAd0arfmD/4iR9lXEoQgBtrjBDAXUUP
         Fta3imlpD8uE21NZFmHh85PGuo2ekczLaAt7w3GkKVyGuC2Nfm6Q3PnIBCvXQv0Hx7EQ
         BEiF3NF9frrrphanQ2Mcr3sdV/Vv5WT0TvQiz5hM3KXr1U9XtIyI6GC1EeEDtVy+GzGF
         FF+A==
X-Gm-Message-State: AOAM5327lCBmraS5xKOP6/3IhElRlZUlKuj8D9hR0k25TLD+M0MOlYKc
        c9XYUDsxkKF1BHp0peC0qCtVzQNUzBeKQg==
X-Google-Smtp-Source: ABdhPJw0Rx/duNbQHWvh0WeyM/WIF6eV9STnuA+yJ2wR5RcVhl9oyzidBzKL6mHSNXiiPk9qBs3ejw==
X-Received: by 2002:a17:903:2351:b0:14a:61b8:6190 with SMTP id c17-20020a170903235100b0014a61b86190mr1130103plh.104.1641924320350;
        Tue, 11 Jan 2022 10:05:20 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id a21sm8405203pfl.209.2022.01.11.10.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:05:20 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v7 08/10] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Tue, 11 Jan 2022 23:34:26 +0530
Message-Id: <20220111180428.931466-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111180428.931466-1-memxor@gmail.com>
References: <20220111180428.931466-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; h=from:subject; bh=/4n5adH9A1hr42pfmX7klZhKpzye5l+wp/IKu2WnTcA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3cakga2esdgBnxqOhfMsLwvT2jPezPOBbizTiCKo DTnZbCWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GpAAKCRBM4MiGSL8RygM7D/ 9oXyMukxtg0biW/VLwvGBTjuon9eCqECt3BtSYQTBrux2bvkc+Ip+jmXGWZN8ov5B/aY+RqoU88O5I Zxf/kpZTzOl5DS/yrquFzSJUVSgdB3JluNej3g8wRH40rSI8AFhtHFAQjNu+AMvJO7Qp5FeXS9/f2U dmBHssfKq3/OtpuA4BPSiwcJYrYdtX5n2YatNvI3hJtcnN7mB7TX7UUVFzn6ZB86QybDzmqiXH2now 9kLs1bv3BI6VJ1syQkR7IcmX5IQGKnGKS8FVFSnrGmpTjJvTDNbKJ5ksk9+FYQqDbqrM/W8C8p4dwO V99ZWFK44Uhy72DEDKrRQf+A4ln8tpY4+9eAJsVqsx+FZd/EA2BpwpclUSaRHvIbeWmCGvu6ZTHwPU w8JdjlncBaGETGf3YOMMOgRWOiZnISZ4TsOiQjpsCI4msRsf9iJm8+sAO8zAgrpeXa7j20+k53vLhI cH7Mw8GiqJEbcVGZDXSciGdcXYZbFp5HBa1mrfRhtzJZnJpIHYAuhl4/KtQZ0m/7EN6eIW2A8hr01e Kjq0fTj1xU7avqgiGTigpWWhMUd/jPhB+IqZfGM0xLuZ0NI6rfO/G9KJIAcqQgn3OnkthHFNuKe1Bd EhbEg+gL2lktbvA3JsgPESDO2VpzlchtxB+/zWWKEPOpr/929ztD1RNjz95Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to add tests (esp. negative tests) where we only want to
ensure the program doesn't pass through the verifier, and also verify
the error. The next commit will add the tests making use of this.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 28 +++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 76cd903117af..29bbaa58233c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/if_ether.h>
 #include <linux/btf.h>
 
+#include <bpf/btf.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -66,6 +67,11 @@ static bool unpriv_disabled = false;
 static int skips;
 static bool verbose = false;
 
+struct kfunc_btf_id_pair {
+	const char *kfunc;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -92,6 +98,7 @@ struct bpf_test {
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
 	int fixup_map_timer[MAX_FIXUPS];
+	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -744,6 +751,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 	int *fixup_map_timer = test->fixup_map_timer;
+	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -936,6 +944,26 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_timer++;
 		} while (*fixup_map_timer);
 	}
+
+	/* Patch in kfunc BTF IDs */
+	if (fixup_kfunc_btf_id->kfunc) {
+		struct btf *btf;
+		int btf_id;
+
+		do {
+			btf_id = 0;
+			btf = btf__load_vmlinux_btf();
+			if (btf) {
+				btf_id = btf__find_by_name_kind(btf,
+								fixup_kfunc_btf_id->kfunc,
+								BTF_KIND_FUNC);
+				btf_id = btf_id < 0 ? 0 : btf_id;
+			}
+			btf__free(btf);
+			prog[fixup_kfunc_btf_id->insn_idx].imm = btf_id;
+			fixup_kfunc_btf_id++;
+		} while (fixup_kfunc_btf_id->kfunc);
+	}
 }
 
 struct libcap {
-- 
2.34.1

