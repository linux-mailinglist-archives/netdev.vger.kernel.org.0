Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785CC4A7256
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344656AbiBBNyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344613AbiBBNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmdcIiImDczn6f3CR2CX3Iu2tcVi06TPYmGxM9JxMVg=;
        b=M8xO5tsYTUxBrXvqfdMjSepHHPwUF6f6/l9HPkObmbKLi+JgdaHCbOIAHH4d9Zj9Qt7e/5
        eaMcC7d37pjeCDTyTl79NdAzb0PHzMQtLY/WdePI/eyYt7CnmMsV+AVVmO4vK7Wy1x9xb5
        98oPwozvzm0hlJ6Am7latphK+E2ovpQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-zcUzQwcfMcuqUCsz55ulaw-1; Wed, 02 Feb 2022 08:53:55 -0500
X-MC-Unique: zcUzQwcfMcuqUCsz55ulaw-1
Received: by mail-ed1-f72.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso10415109edt.20
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:53:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmdcIiImDczn6f3CR2CX3Iu2tcVi06TPYmGxM9JxMVg=;
        b=juZexaqW0ruo9RWtLbpIjZ6wmd08c3EMv9cbfaOZ3Z2M2GAUAzw6r5db+5VEKyPjV0
         sGtZLJ61U68uq1fgn16MyzLMo3XuCaVpwKKOyv38M0U4lpmMxms6Aq94N5GiQ3JflwW0
         cQorVB9gOBHRQMAD/Ql1lIfcF++SEKts+42hCN02/v63OSLBPoElbAP/MALYJ3LIN+Yx
         fRe9i8IFpvHSkPnmeyHO9Pcc9rTSz8uwK/jvq5i9sXrvCiuA8ikERDoEwUgvpQj/Di/I
         qI9gkpuWy3gsza967xRrn1sKZ9PaNqXjFfQ+5qfyL5OWDfXRtXQ/nPxlfsMOuGU2nfIU
         ajTA==
X-Gm-Message-State: AOAM531DxpfV829h878l43wvvBO0SXgEm5xNW7pvlcSwOudxPsK6pN4r
        Z5pLmaMPwKdri5MYByNtWRs59WbCjMxr11wQBphaTVkYngKvMvj2x2GbQJgJHHYMX54bycu9WJg
        rXr0lwV3yh5VoduY/
X-Received: by 2002:a17:906:604d:: with SMTP id p13mr24728338ejj.639.1643810033734;
        Wed, 02 Feb 2022 05:53:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBR9DR4TppVEV3M7QqQMxwZJh36m2BbKzoYg1EmmV3Cx7Lz1/QJk2/Gf1EUqW/sQJhcqZWZA==
X-Received: by 2002:a17:906:604d:: with SMTP id p13mr24728329ejj.639.1643810033497;
        Wed, 02 Feb 2022 05:53:53 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id ce20sm3260162ejb.169.2022.02.02.05.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:53:53 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 3/8] bpf: Add bpf_cookie support to fprobe
Date:   Wed,  2 Feb 2022 14:53:28 +0100
Message-Id: <20220202135333.190761-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to call bpf_get_attach_cookie helper from
kprobe program attached by fprobe link.

The bpf_cookie is provided by array of u64 values, where
each value is paired with provided function address with
the same array index.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |  2 +
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           | 83 +++++++++++++++++++++++++++++++++-
 kernel/trace/bpf_trace.c       | 16 ++++++-
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 100 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6eb0b180d33b..7b65f05c0487 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1301,6 +1301,8 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 #endif
 }
 
+u64 bpf_fprobe_cookie(struct bpf_run_ctx *ctx, u64 ip);
+
 /* BPF program asks to bypass CAP_NET_BIND_SERVICE in bind. */
 #define BPF_RET_BIND_NO_CAP_NET_BIND_SERVICE			(1 << 0)
 /* BPF program asks to set CN on the packet. */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c0912f0a3dfe..0dc6aa4f9683 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1484,6 +1484,7 @@ union bpf_attr {
 				__aligned_u64	addrs;
 				__u32		cnt;
 				__u32		flags;
+				__aligned_u64	bpf_cookies;
 			} fprobe;
 		};
 	} link_create;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0cfbb112c8e1..6c5e74bc43b6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -33,6 +33,8 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/fprobe.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -3025,10 +3027,18 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
 
 #ifdef CONFIG_FPROBE
 
+struct bpf_fprobe_cookie {
+	unsigned long addr;
+	u64 bpf_cookie;
+};
+
 struct bpf_fprobe_link {
 	struct bpf_link link;
 	struct fprobe fp;
 	unsigned long *addrs;
+	struct bpf_run_ctx run_ctx;
+	struct bpf_fprobe_cookie *bpf_cookies;
+	u32 cnt;
 };
 
 static void bpf_fprobe_link_release(struct bpf_link *link)
@@ -3045,6 +3055,7 @@ static void bpf_fprobe_link_dealloc(struct bpf_link *link)
 
 	fprobe_link = container_of(link, struct bpf_fprobe_link, link);
 	kfree(fprobe_link->addrs);
+	kfree(fprobe_link->bpf_cookies);
 	kfree(fprobe_link);
 }
 
@@ -3053,9 +3064,37 @@ static const struct bpf_link_ops bpf_fprobe_link_lops = {
 	.dealloc = bpf_fprobe_link_dealloc,
 };
 
+static int bpf_fprobe_cookie_cmp(const void *_a, const void *_b)
+{
+	const struct bpf_fprobe_cookie *a = _a;
+	const struct bpf_fprobe_cookie *b = _b;
+
+	if (a->addr == b->addr)
+		return 0;
+	return a->addr < b->addr ? -1 : 1;
+}
+
+u64 bpf_fprobe_cookie(struct bpf_run_ctx *ctx, u64 ip)
+{
+	struct bpf_fprobe_link *fprobe_link;
+	struct bpf_fprobe_cookie *val, key = {
+		.addr = (unsigned long) ip,
+	};
+
+	if (!ctx)
+		return 0;
+	fprobe_link = container_of(ctx, struct bpf_fprobe_link, run_ctx);
+	if (!fprobe_link->bpf_cookies)
+		return 0;
+	val = bsearch(&key, fprobe_link->bpf_cookies, fprobe_link->cnt,
+		      sizeof(key), bpf_fprobe_cookie_cmp);
+	return val ? val->bpf_cookie : 0;
+}
+
 static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
 				struct pt_regs *regs)
 {
+	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
@@ -3063,12 +3102,16 @@ static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
 		goto out;
 	}
 
+	old_run_ctx = bpf_set_run_ctx(&fprobe_link->run_ctx);
+
 	rcu_read_lock();
 	migrate_disable();
 	err = bpf_prog_run(fprobe_link->link.prog, regs);
 	migrate_enable();
 	rcu_read_unlock();
 
+	bpf_reset_run_ctx(old_run_ctx);
+
  out:
 	__this_cpu_dec(bpf_prog_active);
 	return err;
@@ -3161,10 +3204,12 @@ static int fprobe_resolve_syms(const void *usyms, u32 cnt,
 
 static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
+	struct bpf_fprobe_cookie *bpf_cookies = NULL;
 	struct bpf_fprobe_link *link = NULL;
 	struct bpf_link_primer link_primer;
+	void __user *ubpf_cookies;
+	u32 flags, cnt, i, size;
 	unsigned long *addrs;
-	u32 flags, cnt, size;
 	void __user *uaddrs;
 	void __user *usyms;
 	int err;
@@ -3205,6 +3250,37 @@ static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *p
 			goto error;
 	}
 
+	ubpf_cookies = u64_to_user_ptr(attr->link_create.fprobe.bpf_cookies);
+	if (ubpf_cookies) {
+		u64 *tmp;
+
+		err = -ENOMEM;
+		tmp = kzalloc(size, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+
+		if (copy_from_user(tmp, ubpf_cookies, size)) {
+			kfree(tmp);
+			err = -EFAULT;
+			goto error;
+		}
+
+		size = cnt * sizeof(*bpf_cookies);
+		bpf_cookies = kzalloc(size, GFP_KERNEL);
+		if (!bpf_cookies) {
+			kfree(tmp);
+			goto error;
+		}
+
+		for (i = 0; i < cnt; i++) {
+			bpf_cookies[i].addr = addrs[i];
+			bpf_cookies[i].bpf_cookie = tmp[i];
+		}
+
+		sort(bpf_cookies, cnt, sizeof(*bpf_cookies), bpf_fprobe_cookie_cmp, NULL);
+		kfree(tmp);
+	}
+
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link) {
 		err = -ENOMEM;
@@ -3224,6 +3300,8 @@ static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *p
 		link->fp.entry_handler = fprobe_link_entry_handler;
 
 	link->addrs = addrs;
+	link->bpf_cookies = bpf_cookies;
+	link->cnt = cnt;
 
 	err = register_fprobe_ips(&link->fp, addrs, cnt);
 	if (err) {
@@ -3236,6 +3314,7 @@ static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *p
 error:
 	kfree(link);
 	kfree(addrs);
+	kfree(bpf_cookies);
 	return err;
 }
 #else /* !CONFIG_FPROBE */
@@ -4476,7 +4555,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.fprobe.flags
+#define BPF_LINK_CREATE_LAST_FIELD link_create.fprobe.bpf_cookies
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 28e59e31e3db..b54b2ef93928 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1049,6 +1049,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_attach_cookie_fprobe, struct pt_regs *, regs)
+{
+	return bpf_fprobe_cookie(current->bpf_ctx, regs->ip);
+}
+
+static const struct bpf_func_proto bpf_get_attach_cookie_proto_fprobe = {
+	.func		= bpf_get_attach_cookie_fprobe,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
 {
 	struct bpf_trace_run_ctx *run_ctx;
@@ -1295,7 +1307,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->expected_attach_type == BPF_TRACE_FPROBE ?
 			&bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
 	case BPF_FUNC_get_attach_cookie:
-		return &bpf_get_attach_cookie_proto_trace;
+		return prog->expected_attach_type == BPF_TRACE_FPROBE ?
+			&bpf_get_attach_cookie_proto_fprobe :
+			&bpf_get_attach_cookie_proto_trace;
 	default:
 		return bpf_tracing_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c0912f0a3dfe..0dc6aa4f9683 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1484,6 +1484,7 @@ union bpf_attr {
 				__aligned_u64	addrs;
 				__u32		cnt;
 				__u32		flags;
+				__aligned_u64	bpf_cookies;
 			} fprobe;
 		};
 	} link_create;
-- 
2.34.1

