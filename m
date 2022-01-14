Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E95A48EE86
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiANQlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243527AbiANQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:41:05 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527AAC061401;
        Fri, 14 Jan 2022 08:41:05 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so22614465pja.1;
        Fri, 14 Jan 2022 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y8WPqZOFxbPJoQcZN2ooGmiwiIT8eHvGY9NSUvSKEeQ=;
        b=mdqIJ/KFqRO0AnapE+8Uw2s/QTq5tDw3k7jX6auOYUpldUSOe2bfEOckp4suJ2c9IF
         xIe9kUOo4LP0Nd3YxMpoOjmyDtoOvWnJ/bl/hSZUBY7y0fqZobD9kFMROUzLVKYiFdnf
         sdR5+DEwuSorupLPNI0UuxAYa7RS+HEV0YojWDnwB6Bu4Tkb31kWybvW6/AVe8YRUjqr
         4RKdJM1eZQs76yWu+o6Flcg/UEYUTmqWlYN+RS8fEnH2xpG0ItLC32uNeToVYGcfq3I0
         NW4Hwq1m4CHnFU4WbdWiaXAIwM9zNn3xOLt4nan470sBcIy0/uxGN8JwcoELw/K9Wcd1
         2bhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8WPqZOFxbPJoQcZN2ooGmiwiIT8eHvGY9NSUvSKEeQ=;
        b=BK5SX7mnEJeVyiSMUf+zv82OXinZ75IM+DZM6zTdaGuaEtMqpLjYlPRX2nb4YcnJAG
         encaI+nlfk7EK2S4m467yXXvQu1cudHGyACyCu56nD0BLOu5EXA6b7iP5+vFwG7nqqcB
         CX9vYFDY0EZxCnG7Mr3UUWEQv+KvxBQQbAm3xx0N5o8YXRGW3rPVW38w36JtUjprDnsg
         bpZZLK9m68P+FdfvjtNvuLH302xV2JPW/kpaM3SLcZN/hOKJH+Q/dZSyaGe4KlFF/9Ke
         xpjOgHqqQNgX6/Cqss91NHqI5h7I60Lx6trIrNqEpBbhiOUlIGAMeqRo2gZvZpviJDzI
         9d7g==
X-Gm-Message-State: AOAM5300yCjfUUnrxeE2RlFHyh4fhWMj+7lZ1tC7b2WuOW3to119F7fW
        ZHN7u1RwWOjsdKhc4BdIX5rc+mpqY6KdjQ==
X-Google-Smtp-Source: ABdhPJzd2mzocPeNBjtxNjc6uOlNTkyVZkLBRu9KDSawIBHjnIuLGKVye5PCCy/UjZ8+A7HcfK8D3g==
X-Received: by 2002:a17:90b:1e08:: with SMTP id pg8mr11570777pjb.216.1642178464667;
        Fri, 14 Jan 2022 08:41:04 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id z16sm5030656pgi.89.2022.01.14.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:41:04 -0800 (PST)
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
Subject: [PATCH bpf-next v8 08/10] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Fri, 14 Jan 2022 22:09:51 +0530
Message-Id: <20220114163953.1455836-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; h=from:subject; bh=/4n5adH9A1hr42pfmX7klZhKpzye5l+wp/IKu2WnTcA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acVga2esdgBnxqOhfMsLwvT2jPezPOBbizTiCKo DTnZbCWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFQAKCRBM4MiGSL8RynSyEA CbL5GhCxq2txMXBLbI8GR1vb+rGcuDIH3QO4d8fG+GdAXWwlfGKX3KAzNb8g+KdpNffQqzF2WZgH1u fR7+UFJpAHmbeNJoawYYbrPX7Fpl8EEi2tS+V2FFQX8v4Fta0gDbJeol1PigIPZ72cMxWIJTkwrJXT o/fscuTjoISoJA9t6cBKpuH0wUeCQrsUmPYpflaqPLcQ2YwX0YF9H/TspnnSXqn99Akhbd2+7zkYzL sCr4nhnXI7lybXiEvXsNx9Ok25UT0aKLFjIAP1EsFCotV4nrbRf6rke8QzXdJN7ca8yTSRvEamx9w5 sK0SC+UuIprYc4UOgB0jm75Hb8MbliCmLB5fK90NiNyiAtrDtHBdXrbBbagB2w3QcXxwDizLr7Xpsb 8toRsAptUaH+ve6IudG1jB5/n/NU4Fy7Vjwjyp2hQRG8hkpjHbmdh3n1QySgL+uw9bjLYGIeiaaq1H CQD1ooZpoO5dzAeUph9b/zlgJOtEqvW3w3BrHhFrlkd329oArjwuSU3f1NLRzSzngxOfyDzqGMf5DZ MSOdTqMKafHwNoVfQuAdsRLBFCjfBDneJpNfOvvRecHDRsWsTxu5hwgkaEIyQzEL9+DlEsKDwZTk/r ljuldrL2seZPy4mslPv93fVvepEe8gaGlqFrRr4XbIJRkiZgqA54m+BbzfqA==
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

