Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02EA441380
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhKAGH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhKAGHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1E7C06120C;
        Sun, 31 Oct 2021 23:04:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k4so1069630plx.8;
        Sun, 31 Oct 2021 23:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnbvpW9WGZPPHsD461H5NLpgI+BcZRpk9Uvkg/7/FsI=;
        b=mBgEqR2cuqWgG4wbE+Ee9nl7PI0oPuF//CHOFEk3rqDKH5Wv+2P8q+SgcLACl7Eu1S
         DYIBVewqg0Hdo0Z9cjB8Sc4otEiDDpzHVGJDzdQm/23So6LaXX9kNiFXBxpugZ7V+xVS
         0csKWuVOGikNjqyzPgk+VenqX+qZTV7bDJrecXDWyeYudRBWBkdXOMGaT3EtG6yamLnt
         oT+8TiedZHp3qG2ml51vaYf8orZUmG0H45pcDpUssVRSPBh7l6VY8IyPdChDJul82kv5
         Ev7EY/jQQfLSgW8XNit4lnKgN4T8Rq4bUuBwJvyrwIhPyecKtKCfMJM4hdXsmzwSwxCL
         KqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnbvpW9WGZPPHsD461H5NLpgI+BcZRpk9Uvkg/7/FsI=;
        b=X6fkjcpe6mzh8qOKc3DsZ7Cu7SMm9wxGkzruf7WvtS83k69P424BXLWq2/2HOp1y0f
         kSHXyOM/H5NtS7l/xvtBCYJ/zLFFuQeLp3y7wyOuf4vk4DjDwI69jahyyC9o5LDVvjgU
         NpD4Afvqw5KEG0Q/2LAHGugWO8XgAu4l6R4Z8yM3UpVEtvt8qkGrxnLxWoM6duT3/lo2
         yFilMrXsUGXAGtyKd4GB8jIKTxHfQUo8UanW4mg/pbuzlKrlIgLnRc+iv4/Dk1n2y7N+
         353FKnIoJJ1Ete1q684kk0JqayGyUq3sqZ+c3t6BSfmewYQug+dix2zOuQ6buBu5GCXG
         XRPQ==
X-Gm-Message-State: AOAM530TZMlNX+EOfKyPjS7WU8YfP2HK6fuO8TW/tcYaBsDUzlQ9OKmj
        e/hZ1GTahlL/P1iBDVZV66I=
X-Google-Smtp-Source: ABdhPJzGCvt5iEpyM474KY6O62Zlsfcvpf7wrXcYqDsBGf7Az/ne89nFa22e0UxYm86jwgxdTn2BTA==
X-Received: by 2002:a17:902:bd01:b0:141:6232:6f89 with SMTP id p1-20020a170902bd0100b0014162326f89mr23251730pls.12.1635746685828;
        Sun, 31 Oct 2021 23:04:45 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:45 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v7 07/11] tools/bpf/bpftool/skeleton: make it adopt to task comm size change
Date:   Mon,  1 Nov 2021 06:04:15 +0000
Message-Id: <20211101060419.4682-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
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

