Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0F44A724E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344615AbiBBNyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344666AbiBBNyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oO9kCxYzu+S91SbPZpT/UZqtqo7+3S7Tz0558nP+sM4=;
        b=fADYtXwDyZE3T8rGeH59pclR012WdVNgye3r58n3myzKPxo96XfI9aQWN+m9cUHnB0xaEQ
        CsGMzYn4sn9ZrkMeGlyl0v5O4zj+XYu22Outf9KfTUhM5brhKOFJyUvl5mmZt/Y6AED4yx
        a75elTzAG/ojJxT1QZmTMsp+cuaM3+U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-9eHfSAxmO6GnHqawcV04Hg-1; Wed, 02 Feb 2022 08:54:14 -0500
X-MC-Unique: 9eHfSAxmO6GnHqawcV04Hg-1
Received: by mail-ed1-f70.google.com with SMTP id bc24-20020a056402205800b00407cf07b2e0so10480176edb.8
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:54:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oO9kCxYzu+S91SbPZpT/UZqtqo7+3S7Tz0558nP+sM4=;
        b=ZcvlM91glVRB/3c020fdCxA/yJrGkVgcPuCNcdDpgkQTDxzW8127jP+oeh4/OnD3+1
         2BH+rhK5zlYtFpcJtQbv9HfUevSgE1tmAq6P16ViAjwzUZqU4HnIHRcrn6H27aOoibs2
         P+IJmWxqU/SYSJ/KhhrH1MOUbuBBp5Tq5xhL1ntpqF5Z2Bq1fzqqtrluWtK+Q9YZq20G
         55lVOCXlk0uysXItQxpp56eNAEmsxx05HtPUyRGQ8ojehc8nylZumKZL1RlcKdtrdrSf
         mpihW3dnlLSY236f6nZUhwghtBpWGOT+cDx4yrVEhkjQcvQjCace0Vcp3dXe4qW5vEqr
         TGuA==
X-Gm-Message-State: AOAM532cvdv7tpNQMd1MuE3W8rG3XSYVcPeVtmN+bGdu34b/Lma33MjX
        Hqldf9oARhM20wuW21WVG16SpS470s7qaV1FQ3vGAYfCPHYXO6YTLMzcYgMI0POH8J3XCjgArd0
        96lIXBMprICyIrJtA
X-Received: by 2002:a50:ee09:: with SMTP id g9mr1824081eds.387.1643810052945;
        Wed, 02 Feb 2022 05:54:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1Sui85jvHnptZNNYz6ZXNsvi0FZvRDG85OezXcljt811sTnYz4JPS1Z27F+E8W9jeUIvoQg==
X-Received: by 2002:a50:ee09:: with SMTP id g9mr1824065eds.387.1643810052726;
        Wed, 02 Feb 2022 05:54:12 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id by22sm15763502ejb.5.2022.02.02.05.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:54:12 -0800 (PST)
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
Subject: [PATCH 6/8] libbpf: Add bpf_program__attach_kprobe_opts for multi kprobes
Date:   Wed,  2 Feb 2022 14:53:31 +0100
Message-Id: <20220202135333.190761-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to bpf_program__attach_kprobe_opts to load kprobes
to multiple functions.

If the kprobe program has BPF_TRACE_FPROBE as expected_attach_type
it will use the new fprobe link to attach the program. In this case
it will use 'func_name' as pattern for functions to attach.

Adding also support to use '*' wildcard in 'kprobe/kretprobe' section
name by SEC macro, like:

  SEC("kprobe/bpf_fentry_test*")
  SEC("kretprobe/bpf_fentry_test*")

This will set kprobe's expected_attach_type to BPF_TRACE_FPROBE,
and attach it to provided functions pattern.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 136 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 133 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7d595cfd03bc..6b343ef77ed8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8607,13 +8607,15 @@ static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie
 static struct bpf_link *attach_lsm(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie);
 
+static int init_kprobe(struct bpf_program *prog, long cookie);
+
 static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("socket",		SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_reuseport/migrate",	SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_reuseport",		SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
-	SEC_DEF("kprobe/",		KPROBE,	0, SEC_NONE, attach_kprobe),
+	SEC_DEF("kprobe/",		KPROBE,	0, SEC_NONE, attach_kprobe, .init_fn = init_kprobe),
 	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
-	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
+	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe, .init_fn = init_kprobe),
 	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
@@ -10031,6 +10033,123 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+struct fprobe_resolve {
+	const char *name;
+	__u64 *addrs;
+	__u32 alloc;
+	__u32 cnt;
+};
+
+static bool glob_matches(const char *glob, const char *s)
+{
+	int n = strlen(glob);
+
+	if (n == 1 && glob[0] == '*')
+		return true;
+
+	if (glob[0] == '*' && glob[n - 1] == '*') {
+		const char *subs;
+		/* substring match */
+
+		/* this is hacky, but we don't want to allocate
+		 * for no good reason
+		 */
+		((char *)glob)[n - 1] = '\0';
+		subs = strstr(s, glob + 1);
+		((char *)glob)[n - 1] = '*';
+
+		return subs != NULL;
+	} else if (glob[0] == '*') {
+		size_t nn = strlen(s);
+		/* suffix match */
+
+		/* too short for a given suffix */
+		if (nn < n - 1)
+			return false;
+		return strcmp(s + nn - (n - 1), glob + 1) == 0;
+	} else if (glob[n - 1] == '*') {
+		/* prefix match */
+		return strncmp(s, glob, n - 1) == 0;
+	} else {
+		/* exact match */
+		return strcmp(glob, s) == 0;
+	}
+}
+
+static int resolve_fprobe_cb(void *arg, unsigned long long sym_addr,
+			     char sym_type, const char *sym_name)
+{
+	struct fprobe_resolve *res = arg;
+	__u64 *p;
+
+	if (!glob_matches(res->name, sym_name))
+		return 0;
+
+	if (res->cnt == res->alloc) {
+		res->alloc = max((__u32) 16, res->alloc * 3 / 2);
+		p = libbpf_reallocarray(res->addrs, res->alloc, sizeof(__u32));
+		if (!p)
+			return -ENOMEM;
+		res->addrs = p;
+	}
+	res->addrs[res->cnt++] = sym_addr;
+	return 0;
+}
+
+static struct bpf_link *
+attach_fprobe_opts(const struct bpf_program *prog,
+		   const char *func_name,
+		   const struct bpf_kprobe_opts *kopts)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	struct fprobe_resolve res = {
+		.name = func_name,
+	};
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int err, link_fd, prog_fd;
+	bool retprobe;
+
+	err = libbpf__kallsyms_parse(&res, resolve_fprobe_cb);
+	if (err)
+		goto error;
+	if (!res.cnt) {
+		err = -ENOENT;
+		goto error;
+	}
+
+	retprobe = OPTS_GET(kopts, retprobe, false);
+
+	opts.fprobe.addrs = (__u64) res.addrs;
+	opts.fprobe.cnt = res.cnt;
+	opts.flags = retprobe ? BPF_F_FPROBE_RETURN : 0;
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
+	if (link_fd < 0) {
+		err = -errno;
+		pr_warn("prog '%s': failed to attach to %s: %s\n",
+			prog->name, res.name,
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto error;
+	}
+	link->fd = link_fd;
+	free(res.addrs);
+	return link;
+
+error:
+	free(link);
+	free(res.addrs);
+	return libbpf_err_ptr(err);
+}
+
 struct bpf_link *
 bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 				const char *func_name,
@@ -10047,6 +10166,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 	if (!OPTS_VALID(opts, bpf_kprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
 
+	if (prog->expected_attach_type == BPF_TRACE_FPROBE)
+		return attach_fprobe_opts(prog, func_name, opts);
+
 	retprobe = OPTS_GET(opts, retprobe, false);
 	offset = OPTS_GET(opts, offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
@@ -10112,6 +10234,14 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
 	return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
 }
 
+static int init_kprobe(struct bpf_program *prog, long cookie)
+{
+	/* If we have wildcard, switch to fprobe link. */
+	if (strchr(prog->sec_name, '*'))
+		bpf_program__set_expected_attach_type(prog, BPF_TRACE_FPROBE);
+	return 0;
+}
+
 static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
@@ -10127,7 +10257,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cooki
 	else
 		func_name = prog->sec_name + sizeof("kprobe/") - 1;
 
-	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.*]+%li", &func, &offset);
 	if (n < 1) {
 		err = -EINVAL;
 		pr_warn("kprobe name is invalid: %s\n", func_name);
-- 
2.34.1

