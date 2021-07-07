Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19A93BF197
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhGGVvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:51:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhGGVvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625694542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6Lkp9H+PeXEJohL6vruWVGim8bb8jO4Rintdh3j+00=;
        b=VP32trsuwK7tdMZr5qDxW/pTWB54JJJGJeHr3B6hRge1Y3c664xpmIWf2TiHOVG+ADcS8X
        steStxfGmnTPM10WdMKacyRu26gXzMRthaoZGrV2z5vCw7UiwOPNdfwhHGQxczVrp1nwuL
        ehLHt5Pw8oyJe0oJE5MUZmnysIrpOBg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-Ra5oUMjPOASHFvpyUQCfag-1; Wed, 07 Jul 2021 17:49:01 -0400
X-MC-Unique: Ra5oUMjPOASHFvpyUQCfag-1
Received: by mail-wm1-f69.google.com with SMTP id d16-20020a1c73100000b02901f2d21e46efso1531089wmb.6
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 14:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6Lkp9H+PeXEJohL6vruWVGim8bb8jO4Rintdh3j+00=;
        b=T8c/X366yQVD2spUtdse2A8ftFJH1kENyicM/dNyINjXsmcP4jaIJC+wv2JqZpu0W5
         ng/fq2ftYAVDBzmQS2cs0Av9LK89f/d9lTVXtjPo2wMS72xTWNVrWbQUquzT+i9hhm6+
         QI7zJi1zyU3zzznt0W0vIDajad0KTDeO6KQvViKZ6KQqgZDTLV8PneYyFEL795S/YAtG
         mLz5J3hICdH4554km2TXf+0N+LuWv+6n3xuG/vOYRQjZ2kx3S8p3lSKm8gnLGUGqCmow
         mkvfjndGorNp7GBhDQ3kT0MF0RWjqD0vQ+S/4ppf2bQe052KYnyLjNIH5JJS6hnnC+QH
         3nOA==
X-Gm-Message-State: AOAM532TxBq+r/H3pP1cKymiJGF/rQpJN7eVQJuctU9jNwcQwCTAxRL2
        5ci+qqKxwzbNWDg05MB9yJE5x4gUeb5+zIneQCOstJ9NQvCkH12XfkoigcQfxfL8wfYmArCS2i9
        k7DbEb+/7qdNNSA6Z
X-Received: by 2002:adf:9466:: with SMTP id 93mr30832138wrq.340.1625694540668;
        Wed, 07 Jul 2021 14:49:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs/zK/o/CEalUgy0txiMvjZKapygMpZixoKK0bABasdS9LEUn7Zpd1LxDLk2h3Osby8JMxBg==
X-Received: by 2002:adf:9466:: with SMTP id 93mr30832125wrq.340.1625694540543;
        Wed, 07 Jul 2021 14:49:00 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id c16sm144524wmr.2.2021.07.07.14.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:49:00 -0700 (PDT)
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
Subject: [PATCHv3 bpf-next 6/7] libbpf: allow specification of "kprobe/function+offset"
Date:   Wed,  7 Jul 2021 23:47:50 +0200
Message-Id: <20210707214751.159713-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707214751.159713-1-jolsa@kernel.org>
References: <20210707214751.159713-1-jolsa@kernel.org>
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

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e04ce724240..60c9e3e77684 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10309,11 +10309,25 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
 					    const char *func_name)
 {
 	char errmsg[STRERR_BUFSIZE];
+	char func[BPF_OBJ_NAME_LEN];
+	unsigned long offset = 0;
 	struct bpf_link *link;
-	int pfd, err;
+	int pfd, err, n;
+
+	n = sscanf(func_name, "%[a-zA-Z0-9_.]+%lx", func, &offset);
+	if (n < 1) {
+		err = -EINVAL;
+		pr_warn("kprobe name is invalid: %s\n", func_name);
+		return libbpf_err_ptr(err);
+	}
+	if (retprobe && offset != 0) {
+		err = -EINVAL;
+		pr_warn("kretprobes do not support offset specification\n");
+		return libbpf_err_ptr(err);
+	}
 
-	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
-				    0 /* offset */, -1 /* pid */);
+	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func,
+				    offset, -1 /* pid */);
 	if (pfd < 0) {
 		pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
 			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
-- 
2.31.1

