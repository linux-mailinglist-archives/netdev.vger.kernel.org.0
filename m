Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1151F3C81FC
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhGNJry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238894AbhGNJry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FDtmaDB4kqS4wOcww/6mdOWXrjUXzfE502+dL3peCCs=;
        b=Cea+fuGCc+pXw6u+5p1PMr/XMhYLmUEznsomEIdA5Ulr5Ld90fvAula9l6ENFls2ifzD2t
        dpuSvwUQ1D30NMz1PjSzMPYu9NdVAFkmT2yA2qqKU6Ozosqx4KjGtzOS3xqXSE1LoCJwT1
        n+zQgiL8XfsNK095olNnPKOTsy7xSHk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-67kW1tjlMLKJNfKbwt7Anw-1; Wed, 14 Jul 2021 05:45:01 -0400
X-MC-Unique: 67kW1tjlMLKJNfKbwt7Anw-1
Received: by mail-wr1-f72.google.com with SMTP id 32-20020adf82a30000b029013b21c75294so1203954wrc.14
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDtmaDB4kqS4wOcww/6mdOWXrjUXzfE502+dL3peCCs=;
        b=C9qQYH06rRWpj4EG+NdhMhE/1EEVKOKCZKsIY0EuMP7pKCZ7IXFM2pjWQdtUp5zw1a
         Tpeq3gmXhIUV6BJeii5akKmpgGEWBPWPVXj9BQfd9OY7QhvDaY2r3Nq2R7KyT+tZ0GVl
         +pv3m0m+5EExR1dJmVRHiMPI2v7O6JinK8LvTPkaKthVF+e/OHQp4sVpUnI5GhgunNfP
         0nr4gde1NHbwNYYIcYML5fyNpBc/3oiCYY+whVol/dH/PvtYLIH8wDsudGFXfOYD99k/
         3psoqzQmRftwQfWXCw5CwbW1H+X4URCaDIXRs0kYqHnA65tUhtwJHBkxjlr5jYCUpfbS
         Ekcg==
X-Gm-Message-State: AOAM532FzxsuBJbC3FRQkMYeGEwO9ofVrplCauhi6BB+g+hXErZlL7bA
        iEG1Y3IDvD5P/h2fpnm9wHxM2mn5WKLSqcyCKOscgQeWCRxpjYloDe9Pn4noZPO9t2BS//1jBTS
        m89cjYVO6rg2uhsXs
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr11733054wrs.405.1626255900310;
        Wed, 14 Jul 2021 02:45:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsX2PRzSqZC/fziGlaaGD8QqV4nNw/LBU9k/sV45C+e6beEAn1vHoY0xIAGZK32lnnmXF69w==
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr11733030wrs.405.1626255900114;
        Wed, 14 Jul 2021 02:45:00 -0700 (PDT)
Received: from krava.redhat.com ([5.171.203.6])
        by smtp.gmail.com with ESMTPSA id c12sm2108345wrr.90.2021.07.14.02.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:44:59 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv4 bpf-next 7/8] libbpf: Allow specification of "kprobe/function+offset"
Date:   Wed, 14 Jul 2021 11:43:59 +0200
Message-Id: <20210714094400.396467-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714094400.396467-1-jolsa@kernel.org>
References: <20210714094400.396467-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

kprobes can be placed on most instructions in a function, not
just entry, and ftrace and bpftrace support the function+offset
notification for probe placement.  Adding parsing of func_name
into func+offset to bpf_program__attach_kprobe() allows the
user to specify

SEC("kprobe/bpf_fentry_test5+0x6")

...for example, and the offset can be passed to perf_event_open_probe()
to support kprobe attachment.

[jolsa: changed original code to use bpf_program__attach_kprobe_opts
and use dynamic allocation in sscanf]

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d93a6f9408d1..abe6d4842bb0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10348,6 +10348,7 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 
 struct bpf_program_attach_kprobe_opts {
 	bool retprobe;
+	unsigned long offset;
 };
 
 static struct bpf_link*
@@ -10360,7 +10361,7 @@ bpf_program__attach_kprobe_opts(struct bpf_program *prog,
 	int pfd, err;
 
 	pfd = perf_event_open_probe(false /* uprobe */, opts->retprobe, func_name,
-				    0 /* offset */, -1 /* pid */);
+				    opts->offset, -1 /* pid */);
 	if (pfd < 0) {
 		pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
 			prog->name, opts->retprobe ? "kretprobe" : "kprobe", func_name,
@@ -10394,12 +10395,31 @@ static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
 				      struct bpf_program *prog)
 {
 	struct bpf_program_attach_kprobe_opts opts;
+	unsigned long offset = 0;
+	struct bpf_link *link;
 	const char *func_name;
+	char *func;
+	int n, err;
 
 	func_name = prog->sec_name + sec->len;
 	opts.retprobe = strcmp(sec->sec, "kretprobe/") == 0;
 
-	return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%lx", &func, &offset);
+	if (n < 1) {
+		err = -EINVAL;
+		pr_warn("kprobe name is invalid: %s\n", func_name);
+		return libbpf_err_ptr(err);
+	}
+	if (opts.retprobe && offset != 0) {
+		err = -EINVAL;
+		pr_warn("kretprobes do not support offset specification\n");
+		return libbpf_err_ptr(err);
+	}
+
+	opts.offset = offset;
+	link = bpf_program__attach_kprobe_opts(prog, func, &opts);
+	free(func);
+	return link;
 }
 
 struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
-- 
2.31.1

