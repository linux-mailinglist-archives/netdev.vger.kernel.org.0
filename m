Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A13220DBD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgGONJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:09:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731486AbgGONJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594818551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YM5wS3/iQvsLxkvvgQKlzXyu1TZ85UBWopqL4qdKj4M=;
        b=FNfgBzMlXjqs9ORiZgY/OwL17S6vKBBiFHh5vGCqFJkpou/WVdM9zprEapUC4ndI3R9gYh
        WuBWsdYh1ulWjbwL2Hd45vV1kFUZFlXVzqX8Re8794mJR9ERAixLWbxpIrCH0BdsEewvGW
        KSL6kujzGxSkep9aJ5KvOqAIRDbj7Wo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-6KhIEb3pM_G6bshClhd4lw-1; Wed, 15 Jul 2020 09:09:08 -0400
X-MC-Unique: 6KhIEb3pM_G6bshClhd4lw-1
Received: by mail-qt1-f199.google.com with SMTP id d45so1319676qte.12
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YM5wS3/iQvsLxkvvgQKlzXyu1TZ85UBWopqL4qdKj4M=;
        b=nW2EuYhxOEiZLOWeKl2DaCfQCh3hAZG/r5U0NzqoUTt1Qkb+K/9hP9kwtq51ZNubPu
         JRAVnbQbBmLhCpv2s6J6/nLdMlwtV96o8T8KE5OFM0SjjfflaIbn+hqAdgRHq/BUTEfo
         XVK1jVZ7fKN9YnnmoziMkCXwI+NLwi2EpXJvb3+VVPVhumFTdyi6yYsYNUE5IcZcRPjK
         3kQoOMhS6MWf/oYiop+wqh+gc9Qcv+IKe73TQGXzxA9d7AH6ZJ0+96bG8qUKdZmKeRoi
         6NMxin0SiBwCvDrPbmDWVvlI+xl4d/WnTL0pzgZgK5KTWiwDvA/NxpEw9Viwr2X1Ndav
         khbw==
X-Gm-Message-State: AOAM533kibGNeqIuPqTLtb8dLl/UnRRszfp4WMpnbC6Eqg/9OpaUrVEC
        wu11uCXaX7/jk4GTPzyZoZ4f8FKWQF2m9nrxV2yCDht0WiCgBqfcEdS3eIZKIIpGmX3V6BsMBDN
        RZLAH6/1U5x/0Tx5G
X-Received: by 2002:aed:2f26:: with SMTP id l35mr10223929qtd.79.1594818547484;
        Wed, 15 Jul 2020 06:09:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxexpd8ety7QWvJP1K2X2hD9z59ditVhtwpVUDy9a287FPwbwF6xrDuhKtLsNljtlww08V1FA==
X-Received: by 2002:aed:2f26:: with SMTP id l35mr10223910qtd.79.1594818547268;
        Wed, 15 Jul 2020 06:09:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a185sm2061895qkg.3.2020.07.15.06.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:09:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD7DF181C9D; Wed, 15 Jul 2020 15:09:04 +0200 (CEST)
Subject: [PATCH bpf-next v2 5/6] libbpf: add support for supplying target to
 bpf_raw_tracepoint_open()
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 15 Jul 2020 15:09:04 +0200
Message-ID: <159481854475.454654.15685979293063948667.stgit@toke.dk>
In-Reply-To: <159481853923.454654.12184603524310603480.stgit@toke.dk>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support for supplying a target fd and btf ID for the
raw_tracepoint_open() BPF operation, using a new bpf_raw_tracepoint_opts
structure. This can be used for attaching freplace programs to multiple
destinations.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |   13 ++++++++++++-
 tools/lib/bpf/bpf.h      |    9 +++++++++
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index a7329b671c41..030c57f8d7c9 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -793,17 +793,28 @@ int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
 	return err;
 }
 
-int bpf_raw_tracepoint_open(const char *name, int prog_fd)
+int bpf_raw_tracepoint_open_opts(const char *name, int prog_fd,
+				 struct bpf_raw_tracepoint_opts *opts)
 {
 	union bpf_attr attr;
 
+	if (!OPTS_VALID(opts, bpf_raw_tracepoint_opts))
+		return -EINVAL;
+
 	memset(&attr, 0, sizeof(attr));
 	attr.raw_tracepoint.name = ptr_to_u64(name);
 	attr.raw_tracepoint.prog_fd = prog_fd;
+	attr.raw_tracepoint.tgt_prog_fd = OPTS_GET(opts, tgt_prog_fd, 0);
+	attr.raw_tracepoint.tgt_btf_id = OPTS_GET(opts, tgt_btf_id, 0);
 
 	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 }
 
+int bpf_raw_tracepoint_open(const char *name, int prog_fd)
+{
+	return bpf_raw_tracepoint_open_opts(name, prog_fd, NULL);
+}
+
 int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
 		 bool do_log)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index dbef24ebcfcb..bae0003899f4 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -227,7 +227,16 @@ LIBBPF_API int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len);
 LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
+struct bpf_raw_tracepoint_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	int tgt_prog_fd; /* target program to attach to */
+	__u32 tgt_btf_id; /* BTF ID of target function */
+};
+#define bpf_raw_tracepoint_opts__last_field tgt_btf_id
+
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
+LIBBPF_API int bpf_raw_tracepoint_open_opts(const char *name, int prog_fd,
+					    struct bpf_raw_tracepoint_opts *opts);
 LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf,
 			    __u32 log_buf_size, bool do_log);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c5d5c7664c3b..17320a5721a5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -288,5 +288,6 @@ LIBBPF_0.1.0 {
 		bpf_map__value_size;
 		bpf_program__autoload;
 		bpf_program__set_autoload;
+		bpf_raw_tracepoint_open_opts;
 		btf__set_fd;
 } LIBBPF_0.0.9;

