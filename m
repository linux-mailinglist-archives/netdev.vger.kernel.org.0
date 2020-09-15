Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7F26B8C6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIPAuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:50:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42836 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgIOLlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600170068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9fKJXKN7VEhK7rTxzSRwDVyT2JXTZwoaKL+6VZUoBs=;
        b=ezngq0M4NEYBloXnPWHLQDK7SBuSo0x0m1GxKU3xU2bxOqS0aO284MIrh3+UBdXEw1gADq
        aYlwq1STFvDaK1dlKPP7Zv5hKSWevyUGSPgb/JeIU0ZfU3RzLvqVdVjwyYH7y4+mN1aSLC
        TRpo7DhfwIspl4VvOaKRq7lZpJ1dHRY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-KLktm3z8P26cJ6GLSOlVSQ-1; Tue, 15 Sep 2020 07:41:06 -0400
X-MC-Unique: KLktm3z8P26cJ6GLSOlVSQ-1
Received: by mail-ed1-f72.google.com with SMTP id i23so1136803edr.14
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 04:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=w9fKJXKN7VEhK7rTxzSRwDVyT2JXTZwoaKL+6VZUoBs=;
        b=Sbf1Z470L9HdO9UFiPXtY2bP7sbYUttLUApedPgvwahrSojcpzUywmj8lJEWZ+ZwTc
         NMCyCQlcS4gRrWONouy7BgYTwNfJaOcZ0awRQiSA6oece8dTHvEJXh3hlh+5W03oVp/U
         ztGHu7lLwLdANLLLjGt+2PfqlIfm8OgLqeJT36rYulNLz0vAnIWFs0hzovPYmAqFjhQF
         sy4LEE6C7rsxEb1X9v9lMUFHIEOyBVjd4wQYQ+5F147q4GauhbW2qxHR05lYf9dL8Yof
         fxwduAItgpH8QW/TW3OF2mNRN1h9VscqoalWYw5CiIRb0s1FFx0z7lyIREnkjZIZ/vUg
         q6Nw==
X-Gm-Message-State: AOAM530MFtaD2/xZCItulzKWVM2mL4ZzFlPiSUWoPK1/FM4DFXGy0wjb
        uAyMfsv6fKM321BsflvzcfF7z6vZ3/Y2MmUAxgkf8yXtuzyW+cpq33ZDbSQ5lphklmF8MKTwvUc
        EHYQc/s+PiK33Zuc1
X-Received: by 2002:a17:906:3759:: with SMTP id e25mr19398383ejc.281.1600170065258;
        Tue, 15 Sep 2020 04:41:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX7RfRm6iniM5SmaodndIFtQgzIT5Ww5VKOvVQJmL14fylehW5jLhmGjq0VOp4n5vy3qNh3w==
X-Received: by 2002:a17:906:3759:: with SMTP id e25mr19398348ejc.281.1600170064896;
        Tue, 15 Sep 2020 04:41:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y9sm9937836ejw.96.2020.09.15.04.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 04:41:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 996C01829CB; Tue, 15 Sep 2020 13:41:03 +0200 (CEST)
Subject: [PATCH bpf-next v5 6/8] libbpf: add support for freplace attachment
 in bpf_link_create
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 15 Sep 2020 13:41:03 +0200
Message-ID: <160017006352.98230.621859348254499900.stgit@toke.dk>
In-Reply-To: <160017005691.98230.13648200635390228683.stgit@toke.dk>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support for supplying a target btf ID for the bpf_link_create()
operation, and adds a new bpf_program__attach_freplace() high-level API for
attaching freplace functions with a target.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |    1 +
 tools/lib/bpf/bpf.h      |    3 ++-
 tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 5 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 82b983ff6569..e928456c0dd6 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.iter_info =
 		ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
 	attr.link_create.iter_info_len = OPTS_GET(opts, iter_info_len, 0);
+	attr.link_create.target_btf_id = OPTS_GET(opts, target_btf_id, 0);
 
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 015d13f25fcc..f8dbf666b62b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -174,8 +174,9 @@ struct bpf_link_create_opts {
 	__u32 flags;
 	union bpf_iter_link_info *iter_info;
 	__u32 iter_info_len;
+	__u32 target_btf_id;
 };
-#define bpf_link_create_opts__last_field iter_info_len
+#define bpf_link_create_opts__last_field target_btf_id
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 550950eb1860..165131c73f40 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
 static struct bpf_link *
 bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
-		       const char *target_name)
+		       int target_btf_id, const char *target_name)
 {
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
 	int prog_fd, link_fd;
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .target_btf_id = target_btf_id);
 
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
@@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
 		return ERR_PTR(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
-	attach_type = bpf_program__get_expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
+	if (bpf_program__get_type(prog) == BPF_PROG_TYPE_EXT)
+		attach_type = BPF_TRACE_FREPLACE;
+	else
+		attach_type = bpf_program__get_expected_attach_type(prog);
+
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -9357,19 +9363,25 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
 struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 {
-	return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
+	return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
 }
 
 struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
 {
-	return bpf_program__attach_fd(prog, netns_fd, "netns");
+	return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
 }
 
 struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int ifindex)
 {
 	/* target_fd/target_ifindex use the same field in LINK_CREATE */
-	return bpf_program__attach_fd(prog, ifindex, "xdp");
+	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
+}
+
+struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
+					      int target_fd, int target_btf_id)
+{
+	return bpf_program__attach_fd(prog, target_fd, target_btf_id, "freplace");
 }
 
 struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a750f67a23f6..ce5add9b9203 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_freplace(struct bpf_program *prog,
+			     int target_fd, int target_btf_id);
 
 struct bpf_map;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 92ceb48a5ca2..3cc2c42f435d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
 
 LIBBPF_0.2.0 {
 	global:
+		bpf_program__attach_freplace;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;

