Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED88447C17
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhKHImh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbhKHIm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BB2C0613F5;
        Mon,  8 Nov 2021 00:39:42 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u17so15265603plg.9;
        Mon, 08 Nov 2021 00:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F4COnTTRSC+CwVYNV8z9S/6Jkdf+sp3tFqGz0D2qNdM=;
        b=U86xcKBeIe8C88277Vsloks1Il0hC3nKHvJ/vLLriTNMrA4feGBNC9/5t3C0NY+mi9
         k0apksnAx8GSlr8XnRgNkC8844s/oe6uT6IeRT8NMnfS5P9gWmzIciQcWKweRk337tMM
         R3L91x8yeBo2/haXhaqtndWPD6n8XuzekdRzEsz8nNn7HRSWliVlH0LPwgXImKNIjwQ2
         xoCSgy0W1Vs7L0FngeHa0k78vc5RyDzj70ZshBdBDQgi/63wTJb6dzkAPPAtavkIcUhF
         cHf1P8FNWZhJm4reblZI3cL2DEbGnpDfkzUJN82a3bqfg9jjPHX+Tkv91UClqAX7MNq+
         CKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F4COnTTRSC+CwVYNV8z9S/6Jkdf+sp3tFqGz0D2qNdM=;
        b=Q1iNN+OolM7LjzfYIyKhUWjmfE5yTrcua+TT7I+YvTHZG+wyCkGTbYZABWhazuseNG
         4Cw4xQ4M0GtM6Q95ErEdRKezykm10v81DG5pKZ3HFyARtcdx906veHEdCappg3sNNXSj
         KlHEMG/UGFdvP8kMhXFqmz/+ArK2AVqUqnrjnJAiKH4qUdT6MaIvOcB2XtRgNTqEu4ju
         GNS6S3mVypN/qKVAJA+TAbRitrByEN8moju/cg2OvBBI6GYzkcaIzYVcF32KkxT0CUGF
         J1gdUoqCfe5xgfAchLv2XE8mbuBphYbZ6fXmDj69z2XfgM2QUO1gcNpGxca+wlAEVr3b
         kXLA==
X-Gm-Message-State: AOAM531Na6uHSyBFOtvO/GWbxAcOXcYGrC0lEkX0stcZ4kew3RZ6yyOO
        WpxjZhZ4TFngHVbCogN4K70=
X-Google-Smtp-Source: ABdhPJz6TyXtOl9PVb+CV7JTpxefSEYXhcK6oHfHEwQaGhLu5wThf9piHTh4Fia/b/8GTiLgxUtiQw==
X-Received: by 2002:a17:902:e849:b0:142:c85:4d3d with SMTP id t9-20020a170902e84900b001420c854d3dmr40721527plg.75.1636360781841;
        Mon, 08 Nov 2021 00:39:41 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:41 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of open-coded string copy
Date:   Mon,  8 Nov 2021 08:38:37 +0000
Message-Id: <20211108083840.4627-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is better to use get_task_comm() instead of the open coded string
copy as we do in other places.

struct elf_prpsinfo is used to dump the task information in userspace
coredump or kernel vmcore. Below is the verfication of vmcore,

crash> ps
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
      0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
      0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]

It works well as expected.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
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
 fs/binfmt_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a813b70f594e..138956fd4a88 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	get_task_comm(psinfo->pr_fname, p);
 
 	return 0;
 }
-- 
2.17.1

