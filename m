Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9A5441378
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhKAGHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhKAGHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35A8C061764;
        Sun, 31 Oct 2021 23:04:41 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n23so5638840pgh.8;
        Sun, 31 Oct 2021 23:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ap2gAMjIVTbmjeLM5LRGgC4luOpifeHIYUs0krjMvxk=;
        b=Xww3fwhQ6GVEpXF7vRbHR0oD+u34jHMA9vEJrrh55zmht9IdE5Qb/0vjbQs4HN5gvY
         POcNuU5T+abx6eRSGb9nZuGqjMlnYzI3jqvFYBpqbT6poqQDzWL/OCelJl7Ho3Jrf54u
         5YN/78Tr6wNXbUZYW94XoWas9EC868iRRB80bXY8hf7ZBFghg6/WFfP5WyJZQXRoDLAc
         5qWLDy0anYrl3w8SOS4VT5/w0N/L80lgTsNBBnkKg70ESOn1Peuixzj+ADfGsxOt+hYL
         hcPflq3MyEUgj2IPSiAxx5uysxJUuGk+9g1qy+Fnllx7jZ0Mylv4WfpxvfDZiclIXnpB
         nNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ap2gAMjIVTbmjeLM5LRGgC4luOpifeHIYUs0krjMvxk=;
        b=mzZAw8q7G9WAIbu0mr5dwx2+rjgpH809Jv+KdJxmgXU5M7Gb7HDQJBVNMQiUq0Ob1H
         H+8eMnyy+sRKeyEqLOTNqFinTc5qU7srYhlzJ48+GP9R23iblu3z32y+lrO4DKMsAQJy
         07JIdmrYOIgyd8DHgfJbZw7BpQKyemALGOrghrppIECnPuNEfh7dv+qO1XcRdG1Vfslk
         BOVqIxKBHOARef2qef52A4dz+Op9pSQexCzCHoAjFrUtImrsc8+zGEo0trcQ1xBF5bCQ
         0v40EQFyT6S4yo8yWMD/8dMwEUaTybX9deBsx16xaTDtoLMtOdarAA4NHKFNejpUSLxn
         8Q+w==
X-Gm-Message-State: AOAM530DZyryQUp7WGIapJHSPQqAffzTen4660n/4CfySKyaAKyUPGmt
        Ev1zwb3RjenEUyzxU7IV5k0=
X-Google-Smtp-Source: ABdhPJzKLE+vunSqJAXuq5W8qJV8bLajJd/LjCll+mqrJULVSs7WJNF0By6dsSaTkrqw5K5k4BauhA==
X-Received: by 2002:a62:1743:0:b0:480:a01f:bf14 with SMTP id 64-20020a621743000000b00480a01fbf14mr11691513pfx.72.1635746681116;
        Sun, 31 Oct 2021 23:04:41 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:40 -0700 (PDT)
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v7 05/11] fs/binfmt_elf: make prpsinfo always get a nul terminated task comm
Date:   Mon,  1 Nov 2021 06:04:13 +0000
Message-Id: <20211101060419.4682-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported a -Wstringop-truncation warning after I
extend task comm from 16 to 24. Below is the detailed warning:

   fs/binfmt_elf.c: In function 'fill_psinfo.isra':
>> fs/binfmt_elf.c:1575:9: warning: 'strncpy' output may be truncated copying 16 bytes from a string of length 23 [-Wstringop-truncation]
    1575 |         strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Replacing the open-coded strncpy() with the helper get_task_comm() can
avoid this warning.

As the struct prpsinfo is externally parsed, for example by the crash
utility, we can't change the size of pr_fname. So I just leave it as-is.

I also verfied if it still work well when I extend the comm size to 24.
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

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
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

