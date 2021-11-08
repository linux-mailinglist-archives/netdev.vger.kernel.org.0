Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF18447C1F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbhKHImy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbhKHImf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:35 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C050C061714;
        Mon,  8 Nov 2021 00:39:51 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g18so10512012pfk.5;
        Mon, 08 Nov 2021 00:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vo2MttItjwsBsGEUYM0AHAekU+2EW8dsU5b9ohsZ6Ts=;
        b=FwceL46eexAcZCPqGKjKQWeRmziWQbb8WStX5KoHEXQ0HRFmEoxTbDvAd2WtYlt/Iq
         RV1aZIohd0k1nzuLtqYyDQsHVCTdIuYJugDZ0V9WYpWbfcprziMckAwkMF3P72cn28p/
         Fk9qKo8Sey/QfeZj9QuPTurT1T6LmzlyfbLYpV3Yf0aYdurW1SfmpoGa49NZ17w5WvBu
         oU5R53qvv6cuDYKDcLFhs1MnsgLoJhAQ543YqxZQxNycMHUyCbwdADEUaUIs146ujYSW
         6Opr6p4VaBbmaq2iTzrR8/qlo48gQy3i8VH1hHSoNO8IinNuyi03EHFENln+fZCVri+R
         9lJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vo2MttItjwsBsGEUYM0AHAekU+2EW8dsU5b9ohsZ6Ts=;
        b=yjfsUtDZYpxN7osO8gd1iUa0uRpa2Fx8q5eS5UTuSIxAU+oYQA6yCI0lVyqVWS3XMX
         uDtQYYq/KvQEAW5RKQs3T1h1Ra+fHJXAB+d+wDR5ispughYfTt8tkU6tQZm1ySOZ3Fwi
         nCNB8mgyObYhiiRzvUm9UFugmg+emNU6wcFNnA9KlhLaD5Tm8e9RpphNc38jzdQHjo4z
         Ba4epPt7chv0xA16pZnMU2WyAgCFD3J9/LzWZbjrAEIMK2qb9B4WS5ToFUrxKXIbmJY/
         TIb7M8KthGcqcVZvaY3m1IzmDV9+AjlYIXFDEnSSAiWD9N1EV/1pTeOcuqX7fwFmvT7p
         gLRA==
X-Gm-Message-State: AOAM533PGjc55XNhhR8Vk4mUE42z24bBJI863TjF7bfp1rt0vr9nJpil
        KAV8trv517T6NGblBr6+KlfDDcONIejJOAWHWu8=
X-Google-Smtp-Source: ABdhPJwgo4zI7DiDbY+RIIxuCe+WtrN4O4psiCBih6u5/j6TLIYm8NMWW7enVf1avJoGZz+hPCeR4w==
X-Received: by 2002:a63:556:: with SMTP id 83mr48600913pgf.222.1636360790838;
        Mon, 08 Nov 2021 00:39:50 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:50 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 6/7] tools/bpf/bpftool/skeleton: use bpf_probe_read_kernel_str to get task comm
Date:   Mon,  8 Nov 2021 08:38:39 +0000
Message-Id: <20211108083840.4627-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

