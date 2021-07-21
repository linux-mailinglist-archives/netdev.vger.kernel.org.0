Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3C3D0618
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhGTX3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhGTX17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 19:27:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC586C061767;
        Tue, 20 Jul 2021 17:08:35 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i16so251078pgi.9;
        Tue, 20 Jul 2021 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tYofpJff5strJxm5ZQGyRIYf51MZ0yNj/PppC2q8O5s=;
        b=maqBBnqDAYzwWiHIVaHVSzGOD1BWMpmAdtSOiAF1HvcDkhQNZEwmfUqITKRQEAmFRz
         CFBTnU46UL+PDb6/TVAxCPIv2NNa+rDxSB09wBtWSz4Yx4oLZcaH40jvv1EKwSkbz6WK
         c3VKjg5vk9Jgo0xYR9y8JZSgszrHljnVHHGYXBOGvrsaX76Ya0gAY1nmBGWLFx59ftAM
         FDCVRKTauU0e+io+jdOmpEVQYgyHvKP2vro9vWMpbEVX5TTJvTrjAj4OjvhjYcpfgR2q
         51zMfKCV/pBA23EGuZQybsfHltg0vuZr9wQplw0TaJOCAaPwKg7aGwUJ/snidv73qQYl
         EImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tYofpJff5strJxm5ZQGyRIYf51MZ0yNj/PppC2q8O5s=;
        b=UjoF3tiTaIUe42zhjVFbcL7hOWVF64d/MS7gPSxyG/PBbDnrjEnTUKDY8bJFp3kds2
         +S3080f9FJLZA99PPxSW0FkEIseKY5aNS5ZafnufHbkiLcpV2JwuQMcq+MBe8EIBUW7E
         jRjSxRu9JKRn13Trfmi7YfNLNx/P+53B96x63iMFYdLEq/eoOTa0l84W0droZ/ISdRH8
         g8759V3Gv+WFb6iPsrumdJsibiJdgAU1EpHejV0dX+i3g6gTGIzXvW9m8DHQqyJCShQb
         py+66EeliGi6apsvZS5dmkAfveFlOO03PmW1m0UYQ8b2rHUE5As3yXYIVuznen69hWLK
         bw0w==
X-Gm-Message-State: AOAM5302jDNXghaHZyLgxeS3fmCcib8KhNEq035gTp3o0oVEiPQdogcX
        TGVbMBm9T3u2W7y4X0OKV0I=
X-Google-Smtp-Source: ABdhPJx+5glPPqi9n7+IaixrGSmfv/0N+KVAL65fAJwOjqhVs9U194XjjlQ+aQuRHeWpQ1RXYqVJgg==
X-Received: by 2002:a65:490b:: with SMTP id p11mr32819255pgs.313.1626826115454;
        Tue, 20 Jul 2021 17:08:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::6:4ad3])
        by smtp.gmail.com with ESMTPSA id f31sm28140684pgm.1.2021.07.20.17.08.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Jul 2021 17:08:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 3/4] libbpf: Move CO-RE types into relo_core.h.
Date:   Tue, 20 Jul 2021 17:08:21 -0700
Message-Id: <20210721000822.40958-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In order to make a clean split of CO-RE logic move its types
into independent header file.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 32 ++++--------
 tools/lib/bpf/libbpf_internal.h | 71 +------------------------
 tools/lib/bpf/relo_core.h       | 92 +++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 93 deletions(-)
 create mode 100644 tools/lib/bpf/relo_core.h

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4f71b4218f14..7ae5992a79e2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5022,34 +5022,20 @@ static size_t bpf_core_essential_name_len(const char *name)
 	return n;
 }
 
-struct core_cand
-{
-	const struct btf *btf;
-	const struct btf_type *t;
-	const char *name;
-	__u32 id;
-};
-
-/* dynamically sized list of type IDs and its associated struct btf */
-struct core_cand_list {
-	struct core_cand *cands;
-	int len;
-};
-
-static void bpf_core_free_cands(struct core_cand_list *cands)
+static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
 {
 	free(cands->cands);
 	free(cands);
 }
 
-static int bpf_core_add_cands(struct core_cand *local_cand,
+static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
 			      size_t local_essent_len,
 			      const struct btf *targ_btf,
 			      const char *targ_btf_name,
 			      int targ_start_id,
-			      struct core_cand_list *cands)
+			      struct bpf_core_cand_list *cands)
 {
-	struct core_cand *new_cands, *cand;
+	struct bpf_core_cand *new_cands, *cand;
 	const struct btf_type *t;
 	const char *targ_name;
 	size_t targ_essent_len;
@@ -5185,11 +5171,11 @@ static int load_module_btfs(struct bpf_object *obj)
 	return 0;
 }
 
-static struct core_cand_list *
+static struct bpf_core_cand_list *
 bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 local_type_id)
 {
-	struct core_cand local_cand = {};
-	struct core_cand_list *cands;
+	struct bpf_core_cand local_cand = {};
+	struct bpf_core_cand_list *cands;
 	const struct btf *main_btf;
 	size_t local_essent_len;
 	int err, i;
@@ -6218,7 +6204,7 @@ static int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn
 				    const struct bpf_core_relo *relo,
 				    int relo_idx,
 				    const struct btf *local_btf,
-				    struct core_cand_list *cands)
+				    struct bpf_core_cand_list *cands)
 {
 	struct bpf_core_spec local_spec, cand_spec, targ_spec = {};
 	struct bpf_core_relo_res cand_res, targ_res;
@@ -6372,7 +6358,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			       struct hashmap *cand_cache)
 {
 	const void *type_key = u32_as_hash_key(relo->type_id);
-	struct core_cand_list *cands = NULL;
+	struct bpf_core_cand_list *cands = NULL;
 	const char *prog_name = prog->name;
 	const struct btf_type *local_type;
 	const char *local_name;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 016ca7cb4f8a..3178d5685dce 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <linux/err.h>
 #include "libbpf_legacy.h"
+#include "relo_core.h"
 
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
@@ -366,76 +367,6 @@ struct bpf_line_info_min {
 	__u32	line_col;
 };
 
-/* bpf_core_relo_kind encodes which aspect of captured field/type/enum value
- * has to be adjusted by relocations.
- */
-enum bpf_core_relo_kind {
-	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
-	BPF_FIELD_BYTE_SIZE = 1,	/* field size in bytes */
-	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
-	BPF_FIELD_SIGNED = 3,		/* field signedness (0 - unsigned, 1 - signed) */
-	BPF_FIELD_LSHIFT_U64 = 4,	/* bitfield-specific left bitshift */
-	BPF_FIELD_RSHIFT_U64 = 5,	/* bitfield-specific right bitshift */
-	BPF_TYPE_ID_LOCAL = 6,		/* type ID in local BPF object */
-	BPF_TYPE_ID_TARGET = 7,		/* type ID in target kernel */
-	BPF_TYPE_EXISTS = 8,		/* type existence in target kernel */
-	BPF_TYPE_SIZE = 9,		/* type size in bytes */
-	BPF_ENUMVAL_EXISTS = 10,	/* enum value existence in target kernel */
-	BPF_ENUMVAL_VALUE = 11,		/* enum value integer value */
-};
-
-/* The minimum bpf_core_relo checked by the loader
- *
- * CO-RE relocation captures the following data:
- * - insn_off - instruction offset (in bytes) within a BPF program that needs
- *   its insn->imm field to be relocated with actual field info;
- * - type_id - BTF type ID of the "root" (containing) entity of a relocatable
- *   type or field;
- * - access_str_off - offset into corresponding .BTF string section. String
- *   interpretation depends on specific relocation kind:
- *     - for field-based relocations, string encodes an accessed field using
- *     a sequence of field and array indices, separated by colon (:). It's
- *     conceptually very close to LLVM's getelementptr ([0]) instruction's
- *     arguments for identifying offset to a field.
- *     - for type-based relocations, strings is expected to be just "0";
- *     - for enum value-based relocations, string contains an index of enum
- *     value within its enum type;
- *
- * Example to provide a better feel.
- *
- *   struct sample {
- *       int a;
- *       struct {
- *           int b[10];
- *       };
- *   };
- *
- *   struct sample *s = ...;
- *   int x = &s->a;     // encoded as "0:0" (a is field #0)
- *   int y = &s->b[5];  // encoded as "0:1:0:5" (anon struct is field #1, 
- *                      // b is field #0 inside anon struct, accessing elem #5)
- *   int z = &s[10]->b; // encoded as "10:1" (ptr is used as an array)
- *
- * type_id for all relocs in this example  will capture BTF type id of
- * `struct sample`.
- *
- * Such relocation is emitted when using __builtin_preserve_access_index()
- * Clang built-in, passing expression that captures field address, e.g.:
- *
- * bpf_probe_read(&dst, sizeof(dst),
- *		  __builtin_preserve_access_index(&src->a.b.c));
- *
- * In this case Clang will emit field relocation recording necessary data to
- * be able to find offset of embedded `a.b.c` field within `src` struct.
- *
- *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
- */
-struct bpf_core_relo {
-	__u32   insn_off;
-	__u32   type_id;
-	__u32   access_str_off;
-	enum bpf_core_relo_kind kind;
-};
 
 typedef int (*type_id_visit_fn)(__u32 *type_id, void *ctx);
 typedef int (*str_off_visit_fn)(__u32 *str_off, void *ctx);
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
new file mode 100644
index 000000000000..62633e73c297
--- /dev/null
+++ b/tools/lib/bpf/relo_core.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* Copyright (c) 2021 Facebook */
+
+#ifndef __RELO_CORE_H
+#define __RELO_CORE_H
+
+/* bpf_core_relo_kind encodes which aspect of captured field/type/enum value
+ * has to be adjusted by relocations.
+ */
+enum bpf_core_relo_kind {
+	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_BYTE_SIZE = 1,	/* field size in bytes */
+	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+	BPF_FIELD_SIGNED = 3,		/* field signedness (0 - unsigned, 1 - signed) */
+	BPF_FIELD_LSHIFT_U64 = 4,	/* bitfield-specific left bitshift */
+	BPF_FIELD_RSHIFT_U64 = 5,	/* bitfield-specific right bitshift */
+	BPF_TYPE_ID_LOCAL = 6,		/* type ID in local BPF object */
+	BPF_TYPE_ID_TARGET = 7,		/* type ID in target kernel */
+	BPF_TYPE_EXISTS = 8,		/* type existence in target kernel */
+	BPF_TYPE_SIZE = 9,		/* type size in bytes */
+	BPF_ENUMVAL_EXISTS = 10,	/* enum value existence in target kernel */
+	BPF_ENUMVAL_VALUE = 11,		/* enum value integer value */
+};
+
+/* The minimum bpf_core_relo checked by the loader
+ *
+ * CO-RE relocation captures the following data:
+ * - insn_off - instruction offset (in bytes) within a BPF program that needs
+ *   its insn->imm field to be relocated with actual field info;
+ * - type_id - BTF type ID of the "root" (containing) entity of a relocatable
+ *   type or field;
+ * - access_str_off - offset into corresponding .BTF string section. String
+ *   interpretation depends on specific relocation kind:
+ *     - for field-based relocations, string encodes an accessed field using
+ *     a sequence of field and array indices, separated by colon (:). It's
+ *     conceptually very close to LLVM's getelementptr ([0]) instruction's
+ *     arguments for identifying offset to a field.
+ *     - for type-based relocations, strings is expected to be just "0";
+ *     - for enum value-based relocations, string contains an index of enum
+ *     value within its enum type;
+ *
+ * Example to provide a better feel.
+ *
+ *   struct sample {
+ *       int a;
+ *       struct {
+ *           int b[10];
+ *       };
+ *   };
+ *
+ *   struct sample *s = ...;
+ *   int x = &s->a;     // encoded as "0:0" (a is field #0)
+ *   int y = &s->b[5];  // encoded as "0:1:0:5" (anon struct is field #1, 
+ *                      // b is field #0 inside anon struct, accessing elem #5)
+ *   int z = &s[10]->b; // encoded as "10:1" (ptr is used as an array)
+ *
+ * type_id for all relocs in this example  will capture BTF type id of
+ * `struct sample`.
+ *
+ * Such relocation is emitted when using __builtin_preserve_access_index()
+ * Clang built-in, passing expression that captures field address, e.g.:
+ *
+ * bpf_probe_read(&dst, sizeof(dst),
+ *		  __builtin_preserve_access_index(&src->a.b.c));
+ *
+ * In this case Clang will emit field relocation recording necessary data to
+ * be able to find offset of embedded `a.b.c` field within `src` struct.
+ *
+ *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
+ */
+struct bpf_core_relo {
+	__u32   insn_off;
+	__u32   type_id;
+	__u32   access_str_off;
+	enum bpf_core_relo_kind kind;
+};
+
+struct bpf_core_cand
+{
+	const struct btf *btf;
+	const struct btf_type *t;
+	const char *name;
+	__u32 id;
+};
+
+/* dynamically sized list of type IDs and its associated struct btf */
+struct bpf_core_cand_list {
+	struct bpf_core_cand *cands;
+	int len;
+};
+
+#endif
-- 
2.30.2

