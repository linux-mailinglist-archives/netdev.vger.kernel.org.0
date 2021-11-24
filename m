Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F109145B6CB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhKXIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:46:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241546AbhKXIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shseh34EZ8lSWaWuyg5bZ/fi6QGZqSZDZrwtCV/PRmY=;
        b=Qrb4A4AJaE1RX60AeKZfSbcqmatHDgYE9smOrw0aQtASSAt/SmymQxQ6tj3+lT8cYmyzW4
        H+e+LEGXU6jk4mHX2zJsly0TXgDwabvE5hRCYNMIkijyTfqByocPUcLjoLLEzxqrvBmT19
        ZaujiDnsplZlk5d9nzthyQITdVMAMMI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-jaNwOYi7N2ulyJMDEHcE2g-1; Wed, 24 Nov 2021 03:41:59 -0500
X-MC-Unique: jaNwOYi7N2ulyJMDEHcE2g-1
Received: by mail-wr1-f70.google.com with SMTP id q17-20020adff791000000b00183e734ba48so290957wrp.8
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shseh34EZ8lSWaWuyg5bZ/fi6QGZqSZDZrwtCV/PRmY=;
        b=Q0EofmJNxkJ9sLs5RqVCplVY0VpFtHW9pR5E5IMzl2FCwC8WQUgCNmfvu3FZA2HEj9
         w4h2lLUAdwfCgRUwrTHPjNgAgaHOZIMNEVfcI8V3eOskafRsL41b4gcK+8FNc3+KHNez
         DWTOeGb3G9u4H1ov1LpBbPcJL8SG5K1iIxNYqWWEss29ghILvNC52SV9NgC04NgOV8t7
         BqTZgHY2CKX9WBjrwkOVI0limN6BXofE9DR+NdVfjZXvi+fOrJPCqLPNS8xplrMStMzE
         DQvdXQrlCJYYr77Cfc0tg9EM/uagy7zrvvTMXt/HjNngBwU1zGaYxmkDdBHBA9eBMxOQ
         fhNQ==
X-Gm-Message-State: AOAM530nCrV6btSo6mk3R/JCjE4Hu1Me5H3RxqCOXcA70BZCEa6L2nwJ
        KG6xxp/5vOGCrcrPDBmROitbPjkgZR3BOzSya3F3RjUfOt1ILFy+t0MrxIHkWJHgWLRW1/tkdQF
        kR0+V4P49mt+jIama
X-Received: by 2002:a5d:6691:: with SMTP id l17mr16604539wru.227.1637743318107;
        Wed, 24 Nov 2021 00:41:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOpcUZpBeEIVgbyAADajoY2+vGJmyxlVWkqXGkoDZ+BH/JclGr6tlUHTrebAx650ScyDsOnQ==
X-Received: by 2002:a5d:6691:: with SMTP id l17mr16604499wru.227.1637743317902;
        Wed, 24 Nov 2021 00:41:57 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f7sm4771235wmg.6.2021.11.24.00.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:57 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6/8] libbpf: Add support for k[ret]probe.multi program section
Date:   Wed, 24 Nov 2021 09:41:17 +0100
Message-Id: <20211124084119.260239-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new sections kprobe.multi/kretprobe.multi for multi
kprobe programs.

It's now possible to define kprobe/kretprobe program like:

  SEC("kprobe.multi/bpf_fentry_test*")

and it will be automatically attached to bpf_fentry_test*
functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 105 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b570e93de735..c1feb5f389a0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8348,6 +8348,7 @@ int bpf_program__set_flags(struct bpf_program *prog, __u32 flags)
 }
 
 static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie);
+static struct bpf_link *attach_kprobe_multi(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
@@ -8362,6 +8363,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
 	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("kprobe.multi/",	KPROBE,	0, SEC_NONE, attach_kprobe_multi),
+	SEC_DEF("kretprobe.multi/",	KPROBE, 0, SEC_NONE, attach_kprobe_multi),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -9918,6 +9921,108 @@ static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cooki
 	return link;
 }
 
+struct kprobe_resolve_multi {
+	const char *name;
+	char **funcs;
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
+static int kprobe_resolve_multi_cb(void *arg, unsigned long long sym_addr,
+				   char sym_type, const char *sym_name)
+{
+	struct kprobe_resolve_multi *res = arg;
+	char **p, *sym;
+
+	if (!glob_matches(res->name, sym_name))
+		return 0;
+
+	if (res->cnt == res->alloc) {
+		res->alloc = max((__u32) 16, res->alloc * 3 / 2);
+		p = libbpf_reallocarray(res->funcs, res->alloc, sizeof(__u32));
+		if (!p)
+			return -ENOMEM;
+		res->funcs = p;
+	}
+	sym = strdup(sym_name);
+	if (!sym)
+		return -ENOMEM;
+	res->funcs[res->cnt++] = sym;
+	return 0;
+}
+
+static void free_str_array(char **func, __u32 cnt)
+{
+	__u32 i;
+
+	for (i = 0; i < cnt; i++)
+		free(func[i]);
+	free(func);
+}
+
+static struct bpf_link *attach_kprobe_multi(const struct bpf_program *prog, long cookie)
+{
+	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
+	struct kprobe_resolve_multi res = { };
+	struct bpf_link *link;
+	int err;
+
+	opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe.multi/");
+	if (opts.retprobe)
+		res.name = prog->sec_name + sizeof("kretprobe.multi/") - 1;
+	else
+		res.name = prog->sec_name + sizeof("kprobe.multi/") - 1;
+
+	err = libbpf__kallsyms_parse(&res, kprobe_resolve_multi_cb);
+	if (err) {
+		free_str_array(res.funcs, res.cnt);
+		return libbpf_err_ptr(err);
+	}
+	if (!res.cnt)
+		return libbpf_err_ptr(-ENOENT);
+	opts.multi.cnt = res.cnt;
+	opts.multi.funcs = res.funcs;
+	link = bpf_program__attach_kprobe_opts(prog, NULL, &opts);
+	free_str_array(res.funcs, res.cnt);
+	return link;
+}
+
 static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
 					 const char *binary_path, uint64_t offset)
 {
-- 
2.33.1

