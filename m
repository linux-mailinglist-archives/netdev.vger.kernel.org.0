Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FC43F8EE8
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243541AbhHZTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243536AbhHZTlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v00APJ6meHaZsL60TP0qAulcqbDujycB2Ey6wbdiEio=;
        b=ZQM3UD9L8j7OkZnunNNDNHYNbKPoQYjffFQuASNDjH8zfmHjGz5nZ3K5rXSW/VAVkZJso5
        JLQK5fxEtueue28VdCunygKIATzh28+c0UrY/lBoYLzOqVZyc685baDbqA/Issp7kvBlAs
        fOeZrFjBZXVRtnLs4wJDjzYz8C/eTe8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-LO_VR75RMy-XfRG0WFxP5A-1; Thu, 26 Aug 2021 15:40:20 -0400
X-MC-Unique: LO_VR75RMy-XfRG0WFxP5A-1
Received: by mail-wm1-f71.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so4767817wmc.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v00APJ6meHaZsL60TP0qAulcqbDujycB2Ey6wbdiEio=;
        b=ID6bEZQqIn22yea1ZV5tzsiicfD3aMJZvTb8mLpIR1gwba9E915bfbnpfJbj5cQqAI
         /2AYTjGQauCGRj7uvjhBvM17163DSCwwxwqmkm3eBomtEZi/ztz6W1VR8uIyhm/Aqd2e
         qEpUFFP8kSca5cKSbaxdaPGqvGnAfLRpcEbiSuDmy2dcYnVtlmE3fDdzK+6KXKppjjZg
         nhba6m85nagZe1orJXIGwo4Ov9PrsVAsuBvp88NQECCrjk/2JDlWMbozthO6gUYaIm/f
         bRG1YU9/mPnFJtiPIwiGuSPMKWxXATod6b0573O/zqn5RtDrgHM9I2oTNG4NuaEaLcta
         SJrw==
X-Gm-Message-State: AOAM5332T3fMj7n4JwwToJKGD8B6eFhblD9/xVD4ub2NlH6zNqBD51ub
        pmThiv5WxrwsOR/WNJSIN6cQIRAEF5b0fyQpWeakEdNSUzjr1t1cIDMXgxmORG3TrhIsTJdTx08
        sqk2oqAtY90t3aK7l
X-Received: by 2002:a05:600c:154e:: with SMTP id f14mr16035638wmg.162.1630006819453;
        Thu, 26 Aug 2021 12:40:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMzN3kbJMLDo29fhXdu4MghVFwWLrCtOYz0OBBkS+zzgjXQaVK4AOPIsKHCwBqu0N6kFRmgw==
X-Received: by 2002:a05:600c:154e:: with SMTP id f14mr16035614wmg.162.1630006819193;
        Thu, 26 Aug 2021 12:40:19 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id n14sm4016308wrx.10.2021.08.26.12.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:18 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 09/27] bpf: Add support to load multi func tracing program
Date:   Thu, 26 Aug 2021 21:39:04 +0200
Message-Id: <20210826193922.66204-10-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
that allows the program to be loaded without specific function to be
attached to.

Such program will be allowed to be attached to multiple functions
in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c          |  3 ++-
 tools/include/uapi/linux/bpf.h |  7 +++++++
 5 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f19f83e..dc9838d741ac 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -865,6 +865,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool multi_func;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 791f31dd0abe..1f9d336861f0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1110,6 +1110,13 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
+ * not expect BTF ID for the program, instead it assumes it's function
+ * with 6 u64 arguments. No trampoline is created for the program. Such
+ * program can be attached to multiple functions.
+ */
+#define BPF_F_MULTI_FUNC	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..fa3f93c423d8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/btf_ids.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2012,7 +2013,8 @@ static int
 bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
 			   struct btf *attach_btf, u32 btf_id,
-			   struct bpf_prog *dst_prog)
+			   struct bpf_prog *dst_prog,
+			   bool multi_func)
 {
 	if (btf_id) {
 		if (btf_id > BTF_MAX_TYPE)
@@ -2032,6 +2034,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		}
 	}
 
+	if (multi_func) {
+		if (prog_type != BPF_PROG_TYPE_TRACING)
+			return -EINVAL;
+		if (!attach_btf || btf_id)
+			return -EINVAL;
+		return 0;
+	}
+
 	if (attach_btf && (!btf_id || dst_prog))
 		return -EINVAL;
 
@@ -2155,6 +2165,16 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 	}
 }
 
+#define DEFINE_BPF_MULTI_FUNC(args...)			\
+	extern int bpf_multi_func(args);		\
+	int __init bpf_multi_func(args) { return 0; }
+
+DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
+		      unsigned long a3, unsigned long a4,
+		      unsigned long a5, unsigned long a6)
+
+BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
+
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD fd_array
 
@@ -2165,6 +2185,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	struct btf *attach_btf = NULL;
 	int err;
 	char license[128];
+	bool multi_func;
 	bool is_gpl;
 
 	if (CHECK_ATTR(BPF_PROG_LOAD))
@@ -2174,7 +2195,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_MULTI_FUNC))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2205,6 +2227,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
 
+	multi_func = attr->prog_flags & BPF_F_MULTI_FUNC;
+
 	/* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
 	 * or btf, we need to check which one it is
 	 */
@@ -2223,7 +2247,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				return -ENOTSUPP;
 			}
 		}
-	} else if (attr->attach_btf_id) {
+	} else if (attr->attach_btf_id || multi_func) {
 		/* fall back to vmlinux BTF, if BTF type ID is specified */
 		attach_btf = bpf_get_btf_vmlinux();
 		if (IS_ERR(attach_btf))
@@ -2236,7 +2260,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
 				       attach_btf, attr->attach_btf_id,
-				       dst_prog)) {
+				       dst_prog, multi_func)) {
 		if (dst_prog)
 			bpf_prog_put(dst_prog);
 		if (attach_btf)
@@ -2256,10 +2280,11 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf = attach_btf;
-	prog->aux->attach_btf_id = attr->attach_btf_id;
+	prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->multi_func = multi_func;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 206c221453cf..e9e84adfb974 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13628,7 +13628,8 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
 		return 0;
-	}
+	} else if (prog->aux->multi_func)
+		return prog->type == BPF_PROG_TYPE_TRACING ? 0 : -EINVAL;
 
 	if (prog->type == BPF_PROG_TYPE_LSM) {
 		ret = bpf_lsm_verify_prog(&env->log, prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 791f31dd0abe..1f9d336861f0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1110,6 +1110,13 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
+ * not expect BTF ID for the program, instead it assumes it's function
+ * with 6 u64 arguments. No trampoline is created for the program. Such
+ * program can be attached to multiple functions.
+ */
+#define BPF_F_MULTI_FUNC	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
-- 
2.31.1

