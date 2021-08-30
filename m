Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC853FBB0D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhH3Rfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhH3Rfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4669FC061575;
        Mon, 30 Aug 2021 10:34:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e7so14139843pgk.2;
        Mon, 30 Aug 2021 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GE2vKVy8HgkCUTYMNvHrEbPsiAi4yZkY5Ysm66dS+LY=;
        b=awrRi8FO6CibGOLs2sFhOeMm03ZpDiRvRBEgNi5PfEGU7QYHRc/njdT6g8YU6Z7UT5
         rBmU1OGU61MJD8ZJj8sMEbQLwOHwPd3RRAmQF7fjnxgvZyonWXg5uj3pR6FTi0Kt3ddf
         BcsqqIoyA+43NsrcqL48YebgLzwT4ZaHNtoQT32ybkdlTzf4mGJr5kKKRRN5j7HE4WJh
         VFBjUR36flEngNfNEwAxnE/FacuuC+bLVPAbYdYWjYvbWsZv82RoGh8QXDZXWg5TMueN
         tP5dSFvHgO3peiBSPP1ZPZd1GIHfrfZhRZ7zT41T8gViOh3mLRsgDPb+0xQleqxGLsYq
         6Y7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GE2vKVy8HgkCUTYMNvHrEbPsiAi4yZkY5Ysm66dS+LY=;
        b=fd1j0oOXMO7BXV+OV/L7+FIf03xoLR01byv0qqDdU2tm8iFVtW43RRVOB3UgLULx74
         RPWlqvWlvMko0T5GUrDLcFtGE9FKLT0FeFNpo/zpLnq69KXqvH/z/+MrypWOYFcTYplw
         HoCAEUOyGhRRvZe0gJeMxV6TEBV3itGGn0Q7MU8hgxR9gC4Ep4JPlveInILpRHvtTexC
         d4AKGmdv1074xenPROZGdWCv5V/yH4UMdszUCHJiFA0oBZ9txD3pCdNBH/wN2ZzZ7NdG
         3ON+4IXsrGUO75dPgCsD9KGWirFIP7KeNt3kv+cqY1mTOSCKmVkoG9vyX2WJU56UAI53
         lhLw==
X-Gm-Message-State: AOAM532+aSOlv+/et6VCFz8ApkCg3+Qrl6/SUJS+afwPSdF/IPJ+Osex
        v1pMPCAuiOLUKf2LGEe+MGhvBO4wa3yjuw==
X-Google-Smtp-Source: ABdhPJwsR8GQewTlzJtrnL6A0TFJgWHpWvPirNKwSSoMkbaJ/Mtles7JPcFDkQKq42IKxkbM/+cC4A==
X-Received: by 2002:a63:111d:: with SMTP id g29mr22947935pgl.222.1630344879548;
        Mon, 30 Aug 2021 10:34:39 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id s83sm10637340pfc.204.2021.08.30.10.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next RFC v1 3/8] libbpf: Support kernel module function calls
Date:   Mon, 30 Aug 2021 23:04:19 +0530
Message-Id: <20210830173424.1385796-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5110; h=from:subject; bh=f9uEtT2cd1efCyrBHSxXPofXfnm19SbwIJqwSdAJ+UI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9FQ7WEk5vF5q019TXwYaMliAXntH+shsv7FxZ AzErmVaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8RysFfEA C1I+EAmxsguspj3Y/RqmXgZ+ZyZmPCWHAYY9zAtR5uX/taPDPRG64HMzRPjM1VFXFEKSmx09AiAna1 kVX+A9+EFYeWdyuutOaqObE5+wa3sVX9c/BV/RyzO12QcgssR6/ujuWvegfDYhkHqTVgd72EltvSyD f5czsqR1+SPu7vChpdCnLhfZjZXV80tiQpPkGq5Q2nboIFUNLg9Y7bvCFIv3+oR6ZfcTktDA3FVX5w FU9jzoFdiCI+oP2SOAgjOAlTVv5lrYjN+uGIIH8yakAke47Rl1POyNhak9VJNtDmmnCXV1OGK1Sxlp xlI+j6KfMawmL82cO2WyYKadbnkQyFAvrHhomuIl70LnQMRSXeWfGoxFm5LNIPA7PMYWP42Tx8msOi +89GGthbPs7lHNrmjFC0XHrofbVOK8ZUFiG0f+qV6C2wzjOUEOO8YvqUZ6HlRX8rkMumZ77o9lITkk Ds6kEkk+6e8FsqNmHX/gl9ghPaZ67LLnNmvBzluNAkTxAvcl92s66wH3YYunxW5Xo/s2lh5RQ7omJl WRr5t29o2phDewCSQeZUpg524SdYsyqUUpK6WPs9x0xKaqEz7SxXGb5HvugH8DgQCRF3ElRaFbMWyL fhUd05Q0w9FBJrt0Rpd2zPi2VOntntYIx5C3/CDUDfawDB+T+kjXi63hM+qQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             |  3 ++
 tools/lib/bpf/libbpf.c          | 71 +++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |  2 +
 3 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..df2d1ceba146 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -265,6 +265,9 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	attr.line_info_cnt = load_attr->line_info_cnt;
 	attr.line_info = ptr_to_u64(load_attr->line_info);
 
+	attr.kfunc_btf_fds = ptr_to_u64(load_attr->kfunc_btf_fds);
+	attr.kfunc_btf_fds_cnt = load_attr->kfunc_btf_fds_cnt;
+
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
 		       min(strlen(load_attr->name), (size_t)BPF_OBJ_NAME_LEN - 1));
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 88d8825fc6f6..c4677ef97caa 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -419,6 +419,12 @@ struct extern_desc {
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
+			/* offset to be patched in for insn->off,
+			 * this is 0 for btf_vmlinux, and index + 1
+			 * for module BTF, where index is BTF index in
+			 * obj->kfunc_btf_fds.fds array
+			 */
+			__u32 offset;
 		} ksym;
 	};
 };
@@ -515,6 +521,13 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	struct {
+		struct hashmap *map;
+		int *fds;
+		size_t cap_cnt;
+		__u32 n_fds;
+	} kfunc_btf_fds;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -5327,6 +5340,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6122,6 +6136,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
 
+	if (prog->obj->kfunc_btf_fds.n_fds) {
+		load_attr.kfunc_btf_fds = prog->obj->kfunc_btf_fds.fds;
+		load_attr.kfunc_btf_fds_cnt = prog->obj->kfunc_btf_fds.n_fds;
+	}
+
 	if (prog->obj->gen_loader) {
 		bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
 				   prog - prog->obj->programs);
@@ -6723,9 +6742,49 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	}
 
 	if (kern_btf != obj->btf_vmlinux) {
-		pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
-			ext->name);
-		return -ENOTSUP;
+		size_t index;
+		void *value;
+
+		/* Lazy initialize btf->fd index map */
+		if (!obj->kfunc_btf_fds.map) {
+			obj->kfunc_btf_fds.map = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn,
+							      NULL);
+			if (!obj->kfunc_btf_fds.map)
+				return -ENOMEM;
+
+			obj->kfunc_btf_fds.fds = calloc(8, sizeof(*obj->kfunc_btf_fds.fds));
+			if (!obj->kfunc_btf_fds.fds) {
+				hashmap__free(obj->kfunc_btf_fds.map);
+				return -ENOMEM;
+			}
+			obj->kfunc_btf_fds.cap_cnt = 8;
+		}
+
+		if (!hashmap__find(obj->kfunc_btf_fds.map, kern_btf, &value)) {
+			size_t *cap_cnt = &obj->kfunc_btf_fds.cap_cnt;
+			/* Not found, insert BTF fd into slot, and grab next
+			 * index from the fd array.
+			 */
+			ret = libbpf_ensure_mem((void **)&obj->kfunc_btf_fds.fds,
+						cap_cnt, sizeof(int), obj->kfunc_btf_fds.n_fds + 1);
+			if (ret)
+				return ret;
+			index = obj->kfunc_btf_fds.n_fds++;
+			obj->kfunc_btf_fds.fds[index] = kern_btf_fd;
+			value = (void *)index;
+			ret = hashmap__add(obj->kfunc_btf_fds.map, kern_btf, &value);
+			if (ret)
+				return ret;
+
+		} else {
+			index = (size_t)value;
+		}
+		/* index starts from 0, so shift offset by 1 as offset == 0 is reserved
+		 * for btf_vmlinux in the kernel
+		 */
+		ext->ksym.offset = index + 1;
+	} else {
+		ext->ksym.offset = 0;
 	}
 
 	kern_func = btf__type_by_id(kern_btf, kfunc_id);
@@ -6901,6 +6960,12 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up kfunc_btf */
+	hashmap__free(obj->kfunc_btf_fds.map);
+	obj->kfunc_btf_fds.map = NULL;
+	zfree(&obj->kfunc_btf_fds.fds);
+	obj->kfunc_btf_fds.cap_cnt = obj->kfunc_btf_fds.n_fds = 0;
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 533b0211f40a..701719d9caaf 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -276,6 +276,8 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *kfunc_btf_fds;
+	__u32 kfunc_btf_fds_cnt;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
-- 
2.33.0

