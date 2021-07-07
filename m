Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16CE3BF07F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGGTtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233089AbhGGTtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6Lkp9H+PeXEJohL6vruWVGim8bb8jO4Rintdh3j+00=;
        b=Z2PpmaxhScqQGLUL6IQM8yOFVU3NPEuV995gMNMgerMFQ5RxYOj6c8BzPSppHwGWZoXL8Y
        KCs6rS2PJRAoYenBJwSM1W0H5ufXBtRW4ApCpUIHaJkwYCf+hUcWvI7laRm6n5CuPFZzVM
        D7x9N9UN+jkwdkUzQ+q7fzJbKQSkLts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-Y1wPafbTORWGNSUWFAsM4A-1; Wed, 07 Jul 2021 15:47:08 -0400
X-MC-Unique: Y1wPafbTORWGNSUWFAsM4A-1
Received: by mail-wm1-f69.google.com with SMTP id a13-20020a7bc1cd0000b02902104c012aa3so2598764wmj.9
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:47:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6Lkp9H+PeXEJohL6vruWVGim8bb8jO4Rintdh3j+00=;
        b=IvDZbEL6H75SiSvnYGHCv84YLH+ey2qYaVki+dJy66kOrLtYVcmt2kyK7E6VTuO5ht
         M664hmtSM0MH7od09aTRIkj1C1eqwiVx5yRlrfO/P0yNobFa2F+TPJ7H40JYEdF8vZ4s
         4ZGBOx9Iop326BpeWbZN7wWHmIR+MrQz8u09ptXTv/4oFK4B8ixAVVd+QzDX5IYO9tJx
         R1Bfr5RGSihnferWI8DAG5TudXNrw7YJv66qLW0NiE0Q46ArbmMKZwUN+yuFCeOuYj5w
         UQsl3qbcIaBiOC6rOG4yAmUH8A94RaaIZ2vWcz7vcJSa/CswxcXipYThdT6yfIwt5Ijk
         Jz6Q==
X-Gm-Message-State: AOAM530m+ywNopeLV3AjFI1EYVGYTCrswO06PRSkz+HAjubzl8Dnfr0B
        8qq9F6/xnlgaNFl/3UYUOxt72NZWIf6042zvEozShSZQnWsHQsAN5ovO5QA2ykruIKBWVFRnVsQ
        tOE7f1GlI9163y4tc
X-Received: by 2002:a1c:4302:: with SMTP id q2mr792616wma.37.1625687227560;
        Wed, 07 Jul 2021 12:47:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx6Hij6OUVN0HPvFYTpi+Y4VHcPBqilpZnkPQP9PAJQEeBMChoVHxNTGuD6GH5ZZ0UJXu2rA==
X-Received: by 2002:a1c:4302:: with SMTP id q2mr792598wma.37.1625687227390;
        Wed, 07 Jul 2021 12:47:07 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id l20sm20208357wmq.3.2021.07.07.12.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:47:07 -0700 (PDT)
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
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 6/7] libbpf: allow specification of "kprobe/function+offset"
Date:   Wed,  7 Jul 2021 21:46:18 +0200
Message-Id: <20210707194619.151676-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707194619.151676-1-jolsa@kernel.org>
References: <20210707194619.151676-1-jolsa@kernel.org>
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

