Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FF4457D5C
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhKTLbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbhKTLbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F1C061574;
        Sat, 20 Nov 2021 03:28:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so12921264pju.3;
        Sat, 20 Nov 2021 03:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tEaEqo0LatYc7Bqp4nP+g3PsyWq0ANknSNVk7gGI5oU=;
        b=dwMQaTe6H58dGLThH9f5dNiTLQTR7wxrd97n6+FoRq4EPM3JuDVu84xxEFhUl6W3y+
         1Mu/DW1NsWZAwXTLhJQrlZCFhhB29VS7mZCbJPR0kdIXQ9WPpF1LBjJt3uDQJLTzWCc0
         oiliUIs4wTII45cxT7PG19NzN2+2Xi85fPMefEU5mEs3OXsJbmmORGKc5uOxsSx3p0/b
         0fy655YcaSZGhbpcOuFD6x7ceHW5Kr1Lc9y/qkXLMhYUcI1vRme0dXmdQ5ZgtZbbXFyA
         JrPiQz8xA1WqDLKfoRgz8scX02M4e1okXtvGmYoBEDzjrezOTO8HKwDXPh162cGB24bm
         FWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tEaEqo0LatYc7Bqp4nP+g3PsyWq0ANknSNVk7gGI5oU=;
        b=bkwoA9l1ebe58nJOYXREv8+mWBhg3VqARuemwJNy9mjdVrBwCbqTcqKO12yQl28n9J
         oept00aO+VjovjQXj6gI9tBTp1pyBW5fgKEOT02rjuqjXsqUyI+wSQh5DbiORMcwzope
         FAiQEy1da438C20k5aq5Q8oxc2mkeTgXmvWt2Y/Rwkqb0vx8CfTHz0xL7mwRjKzMeHDS
         TMVIsUx8YX9niFdhqHtx+WFpOdlziCTktFy7KzdYLn4fQzzrfebGzsgCbDmNUukklE5b
         K6OVyUboxNKBbl8CWRiTaq+vw2Mq+eXdSOOmzCbFfclffB2wIJJHkPKNsYs0ZPIuXI5c
         dqpw==
X-Gm-Message-State: AOAM5331jwzUpvdRhi9gAMdkedVn6MN+CrJVhmwapEW5+W1t+gNCIEuo
        dpFdPE1L2tzePdN9ap/qHVaU93AyweW5X1o1wX4=
X-Google-Smtp-Source: ABdhPJxx6IXfHMZUvhVc7t2hNtDO+hU3JjOX4iXLcBdBeDlaYH5wP6HAWIyvMxWolg+i2afGvs9kdw==
X-Received: by 2002:a17:902:9a09:b0:142:82e1:6cff with SMTP id v9-20020a1709029a0900b0014282e16cffmr88343798plp.47.1637407687765;
        Sat, 20 Nov 2021 03:28:07 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:07 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 6/7] tools/bpf/bpftool/skeleton: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm
Date:   Sat, 20 Nov 2021 11:27:37 +0000
Message-Id: <20211120112738.45980-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
index d9b420972934..f70702fcb224 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
+++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -71,8 +71,8 @@ int iter(struct bpf_iter__task_file *ctx)
 
 	e.pid = task->tgid;
 	e.id = get_obj_id(file->private_data, obj_type);
-	bpf_probe_read_kernel(&e.comm, sizeof(e.comm),
-			      task->group_leader->comm);
+	bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm),
+				  task->group_leader->comm);
 	bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
 
 	return 0;
-- 
2.17.1

