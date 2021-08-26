Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA683F8F03
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhHZTm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243599AbhHZTmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNOph7fDuFs97Eha5R8U+AbH+ZbOQ2fdynr7Ppgl9xo=;
        b=HxD7TpEwAgWEK8u+k4YHnIuO2q37GNdLTB1m3ee/Hp/cSBXsM9C8lrbQMP1maI6Y6F8Tsc
        DfC5VOKGx3QKJ29/6Jh94RX/CTo4QlmhbMYXhAYPD7nXG4aOokmWsnV/dFyLPQKJs8o++G
        Vz/R/PSPTonuPUjN0Kss1zNQ7xMs+3Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-04rQY9AVN86oDjX3ZSkPHQ-1; Thu, 26 Aug 2021 15:41:35 -0400
X-MC-Unique: 04rQY9AVN86oDjX3ZSkPHQ-1
Received: by mail-wm1-f72.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so1125517wmr.9
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNOph7fDuFs97Eha5R8U+AbH+ZbOQ2fdynr7Ppgl9xo=;
        b=E7hP+LItLJGVYHyGRMHJkl+rhJYHdgVKJNXRqa0Hze79qN491pf7Dq9ZD7IBvSXwGV
         bqr1PV7QOTpcX/QlkzulXCxLzt/3vUgLWM7bEDVfkmIVG8bmZB6bs6HvKFZ7+pE/fN//
         DogYAUNjXYrIhBi1CztCNikI6aQG0E3KpfPJ0huuuiQbkkSFhgcgWyx3p5yx2Cb39zEu
         RUZdDd7yN1ZIUDYypQ7twWF+H9/Ft+ze/GJr2MSsf+sZi2FnqEb7ZKip5xt9fhVXH2CO
         vnIA21sEifJpBYivMqQ4ytdbHPjydfj4vKlZY5DEaEy3rUYrqXk0Bw1hrwNVXRyWCKof
         w/cQ==
X-Gm-Message-State: AOAM531FhA/81kijNvolDqvQxmGkpBYKPb2/2HlfNv4V2PQXEWZuacTS
        3hi6zzQuPjsVCy1eKvpIVImPPhDNGPZaEk5P4Tfcs8NlNGa7nCOf9OcAbFNdUlYFCx9rplqtFZ0
        214HVk24ieBjc1QFW
X-Received: by 2002:a5d:65cc:: with SMTP id e12mr6218292wrw.266.1630006894649;
        Thu, 26 Aug 2021 12:41:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1VfBS9lN1U/9ZDy+tjTNLSfUPE3NMeOcXS6gjf3AKHcPmgkRW6/Zzyv3AhZ1r8BdB6dgFyg==
X-Received: by 2002:a5d:65cc:: with SMTP id e12mr6218280wrw.266.1630006894474;
        Thu, 26 Aug 2021 12:41:34 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id q11sm9133336wmc.41.2021.08.26.12.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:34 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 21/27] libbpf: Add support to link multi func tracing program
Date:   Thu, 26 Aug 2021 21:39:16 +0200
Message-Id: <20210826193922.66204-22-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to link multi func tracing program
through link_create interface.

Adding special types for multi func programs:

  fentry.multi
  fexit.multi

so you can define multi func programs like:

  SEC("fentry.multi/bpf_fentry_test*")
  int BPF_PROG(test1, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)

that defines test1 to be attached to bpf_fentry_test* functions.
The test1 program is loaded with BPF_F_MULTI_FUNC flag.

If functions are not specified the program needs to be attached
manually.

Adding new btf_ids/btf_ids_cnt fields to bpf_link_create_opts,
that define functions to attach the program to.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c    |  8 +++++
 tools/lib/bpf/bpf.h    |  6 +++-
 tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..20422d58b945 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -713,12 +713,20 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
+		attr.link_create.multi_btf_ids = (__u64) OPTS_GET(opts, multi.btf_ids, 0);
+		attr.link_create.multi_btf_ids_cnt = OPTS_GET(opts, multi.btf_ids_cnt, 0);
+		if (!OPTS_ZEROED(opts, multi))
+			return libbpf_err(-EINVAL);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
 		break;
 	}
 proceed:
+
 	fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 6fffb3cdf39b..2eff99be7069 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -181,10 +181,14 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			__u32 *btf_ids;
+			__u32  btf_ids_cnt;
+		} multi;
 	};
 	size_t :0;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field multi
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 88d8825fc6f6..7f717b7755be 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -230,6 +230,7 @@ struct bpf_sec_def {
 	bool is_attachable;
 	bool is_attach_btf;
 	bool is_sleepable;
+	bool is_multi_func;
 	attach_fn_t attach_fn;
 };
 
@@ -6446,6 +6447,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 		if (prog->sec_def->is_sleepable)
 			prog->prog_flags |= BPF_F_SLEEPABLE;
+		if (prog->sec_def->is_multi_func)
+			prog->prog_flags |= BPF_F_MULTI_FUNC;
 		bpf_program__set_type(prog, prog->sec_def->prog_type);
 		bpf_program__set_expected_attach_type(prog,
 				prog->sec_def->expected_attach_type);
@@ -7915,6 +7918,8 @@ static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
 				      struct bpf_program *prog);
 static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
 				     struct bpf_program *prog);
+static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
+					   struct bpf_program *prog);
 static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
 				   struct bpf_program *prog);
 static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
@@ -7991,6 +7996,14 @@ static const struct bpf_sec_def section_defs[] = {
 		.attach_fn = attach_iter),
 	SEC_DEF("syscall", SYSCALL,
 		.is_sleepable = true),
+	SEC_DEF("fentry.multi/", TRACING,
+		.expected_attach_type = BPF_TRACE_FENTRY,
+		.is_multi_func = true,
+		.attach_fn = attach_trace_multi),
+	SEC_DEF("fexit.multi/", TRACING,
+		.expected_attach_type = BPF_TRACE_FEXIT,
+		.is_multi_func = true,
+		.attach_fn = attach_trace_multi),
 	BPF_EAPROG_SEC("xdp_devmap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
@@ -8435,6 +8448,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
 	if (!name)
 		return -EINVAL;
 
+	if (prog->prog_flags & BPF_F_MULTI_FUNC)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
 		if (!section_defs[i].is_attach_btf)
 			continue;
@@ -9523,6 +9539,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
 	return (struct bpf_link *)link;
 }
 
+static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
+{
+	char *pattern = prog->sec_name + prog->sec_def->len;
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	enum bpf_attach_type attach_type;
+	int prog_fd, link_fd, cnt, err;
+	struct bpf_link *link = NULL;
+	__u32 *ids = NULL;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = bpf_object__load_vmlinux_btf(prog->obj, true);
+	if (err)
+		return ERR_PTR(err);
+
+	cnt = btf__find_by_glob_kind(prog->obj->btf_vmlinux, BTF_KIND_FUNC,
+				     pattern, NULL, &ids);
+	if (cnt <= 0)
+		return ERR_PTR(-EINVAL);
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	opts.multi.btf_ids = ids;
+	opts.multi.btf_ids_cnt = cnt;
+
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
+	if (link_fd < 0) {
+		err = -errno;
+		goto out_err;
+	}
+	link->fd = link_fd;
+	free(ids);
+	return link;
+
+out_err:
+	free(link);
+	free(ids);
+	return ERR_PTR(err);
+}
+
+static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
+					   struct bpf_program *prog)
+{
+	return bpf_program__attach_multi(prog);
+}
+
 struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 {
 	return bpf_program__attach_btf_id(prog);
-- 
2.31.1

