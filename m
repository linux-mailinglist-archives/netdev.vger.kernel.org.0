Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31157142B8D
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgATNGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:06:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38416 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728935AbgATNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZR8zX+ydWBbBu89eT3Dfy7pXd3GWbtA0n7Gp7hmhwM=;
        b=aVUUABTAbdusDhqByaT7203UFYMgJcQZxxSMn/q7N7Y+pO+fxKHHTrD7DMik3XQzQzqVJ1
        jO7DpgKJkQ+olkkUZpO5DUPrFis4uZ9iCVm4bvJGDJNcmli84v9LfqvvuAXnMBwnE6VILg
        VvimAV8HXqGKsADMkttFuVggxBqu1sU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-wStsF56OOueGrpUcjW9BIg-1; Mon, 20 Jan 2020 08:06:51 -0500
X-MC-Unique: wStsF56OOueGrpUcjW9BIg-1
Received: by mail-lf1-f69.google.com with SMTP id v10so6207899lfa.14
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:06:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kZR8zX+ydWBbBu89eT3Dfy7pXd3GWbtA0n7Gp7hmhwM=;
        b=SHYUEApftfncjor4Icx+kt2LGzKOJRRQV4aZ7RfZXKrX3hIk3K3PG2jWyhUsK+7xSI
         ykwH3PASHUjvWw95LVnr4avS1CK8Oe1zAi7mHXbbkK6PNhXRK8YjDQQabSTFo01kzL+w
         7mEN+qZZBeJ3+o99LKDaThIrAJCQ5NKwl11vLC5KKIfLOCifTQZKe5i+N0ISBmQEgkbB
         uN0xjHFVLvrYD3M5yn9l0OGzHhmUQS1HgME/omCHpPWFoXum+axUFm2ub9HULhsAdB8F
         UwTL5tM1zAuE9uM7VKtsLsJ17eG7zt/G7lq65XN0pczLOMdvxsHrA4lyWzWK4kIi/EAx
         e+1Q==
X-Gm-Message-State: APjAAAVmfJlIKi4+f9Ha0DX13ocwyPTzaS74uRII9EYrzgMeDMwPCuCP
        N1F2NsQf0jkj4Jp0A2NRXZLcAF5XQ/WH2eZ7IdpakWQA1H0xObJa0fvCyz2HiQoQk4Hje2UJ97i
        XHIJrJS4iXZq06pZb
X-Received: by 2002:a19:c82:: with SMTP id 124mr6361224lfm.152.1579525610205;
        Mon, 20 Jan 2020 05:06:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzP2QdGmR9drjELXs9stfRKxX9t6uODuDCYi7BoHCel4Br99OHqeQNYuT6HeyyQr5h3NkqBng==
X-Received: by 2002:a19:c82:: with SMTP id 124mr6361203lfm.152.1579525609886;
        Mon, 20 Jan 2020 05:06:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y1sm16673362ljm.12.2020.01.20.05.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:06:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1BCA01804D8; Mon, 20 Jan 2020 14:06:48 +0100 (CET)
Subject: [PATCH bpf-next v5 07/11] perf: Use consistent include paths for
 libbpf
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Mon, 20 Jan 2020 14:06:48 +0100
Message-ID: <157952560797.1683545.7685921032671386301.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Fix perf to include libbpf header files with the bpf/ prefix, to
be consistent with external users of the library.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/perf/examples/bpf/5sec.c             |    2 +-
 tools/perf/examples/bpf/empty.c            |    2 +-
 tools/perf/examples/bpf/sys_enter_openat.c |    2 +-
 tools/perf/include/bpf/pid_filter.h        |    2 +-
 tools/perf/include/bpf/stdio.h             |    2 +-
 tools/perf/include/bpf/unistd.h            |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/examples/bpf/5sec.c b/tools/perf/examples/bpf/5sec.c
index b9c203219691..49f4f84da485 100644
--- a/tools/perf/examples/bpf/5sec.c
+++ b/tools/perf/examples/bpf/5sec.c
@@ -39,7 +39,7 @@
    Copyright (C) 2018 Red Hat, Inc., Arnaldo Carvalho de Melo <acme@redhat.com>
 */
 
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 int probe(hrtimer_nanosleep, rqtp->tv_sec)(void *ctx, int err, long sec)
 {
diff --git a/tools/perf/examples/bpf/empty.c b/tools/perf/examples/bpf/empty.c
index 3776d26db9e7..7d7fb0c9fe76 100644
--- a/tools/perf/examples/bpf/empty.c
+++ b/tools/perf/examples/bpf/empty.c
@@ -1,3 +1,3 @@
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 license(GPL);
diff --git a/tools/perf/examples/bpf/sys_enter_openat.c b/tools/perf/examples/bpf/sys_enter_openat.c
index 9cd124b09392..c4481c390d23 100644
--- a/tools/perf/examples/bpf/sys_enter_openat.c
+++ b/tools/perf/examples/bpf/sys_enter_openat.c
@@ -14,7 +14,7 @@
  * the return value.
  */
 
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 struct syscall_enter_openat_args {
 	unsigned long long unused;
diff --git a/tools/perf/include/bpf/pid_filter.h b/tools/perf/include/bpf/pid_filter.h
index 6e61c4bdf548..607189a315b2 100644
--- a/tools/perf/include/bpf/pid_filter.h
+++ b/tools/perf/include/bpf/pid_filter.h
@@ -3,7 +3,7 @@
 #ifndef _PERF_BPF_PID_FILTER_
 #define _PERF_BPF_PID_FILTER_
 
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 #define pid_filter(name) pid_map(name, bool)
 
diff --git a/tools/perf/include/bpf/stdio.h b/tools/perf/include/bpf/stdio.h
index 316af5b2ff35..7ca6fa5463ee 100644
--- a/tools/perf/include/bpf/stdio.h
+++ b/tools/perf/include/bpf/stdio.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 struct bpf_map SEC("maps") __bpf_stdout__ = {
        .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
diff --git a/tools/perf/include/bpf/unistd.h b/tools/perf/include/bpf/unistd.h
index ca7877f9a976..d1a35b6c649d 100644
--- a/tools/perf/include/bpf/unistd.h
+++ b/tools/perf/include/bpf/unistd.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: LGPL-2.1
 
-#include <bpf.h>
+#include <bpf/bpf.h>
 
 static int (*bpf_get_current_pid_tgid)(void) = (void *)BPF_FUNC_get_current_pid_tgid;
 

