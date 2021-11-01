Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760B944136B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhKAGH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKAGHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA417C061746;
        Sun, 31 Oct 2021 23:04:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x16-20020a17090a789000b001a69735b339so614987pjk.5;
        Sun, 31 Oct 2021 23:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rZRlybNT1VQOoNxdQue8vo9tAC5dSJmDk+dmEknNUrc=;
        b=a1M395Bqh+HLw+RAGcbuG3Ee9gQ5Pt14RuYZaJHZtAq8IsesqFhaR4qs895G5hbMKL
         iQS5vYZGfgH7a5b3h4KU8iCUQfcJ2pMAUZ7xUYJlwNlcv/9R98mCr+O99gLbYNgvnTdf
         Jq1Q2Y9+75eoLINoepcqswMcLPx+E9zUvTqyDgQoDj1JjQ7GhueGgF6r1EyHzZ4+n1+P
         4VyRgUsHzVN0JaYnojDA5tc4RqapLPK5V8yI7l8aREDyn7EoVRQ484iSc2Ox4D6ZVWo3
         RXydvoGhJx9s1/xKjIdOKtfqIsQHqS0jolmiHdBqkJBvY53eM6lKKs8AgkFuHiKGjnlr
         HK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rZRlybNT1VQOoNxdQue8vo9tAC5dSJmDk+dmEknNUrc=;
        b=cQ1F9IaxwbEGSb72WC/p4WoxODTWncYrTKV7fctFjOBdFJpO+uZNCHPlnlfwHxt/eL
         I8vBjnP5hDABeYdeeqvw1oFMLEMZbuXNHg0x05/zjUfVtM4iytRc6L3ziK4mBD/Ez45V
         +2kjeUmS5kcCcTWXMCQAwscqLs8Xhvl7f+6qkwbAzm4IsBnDP9eyyPJ9uYC6z2rRMWdv
         G3gJsNKJji4oV3dYG85X4qNi8VEvzivPvkTx1v32vMyZV5uLfCNcvtIq7cNEpHWkh9E2
         XidZqT/pBp7Ni0yZGo9+DJw5t7kMjtOuDrgRKtpwIDHxozaah6J1m3bCGjbRDW70Sqcp
         OYsw==
X-Gm-Message-State: AOAM532Y5xa0sSlQbseIlBPXpUe+4zNm21k3Yo5pEsvn03DRQpnw24pB
        aQ7OD3ItrunuU10d9lTt7yk=
X-Google-Smtp-Source: ABdhPJzL4jPx+ZhAWUkFzp5hvgKpDWtgYKzpi4hD6dRWbzMDiPGRwPGbJb/YNiUpFAuwRHKj4szYdg==
X-Received: by 2002:a17:902:8bcb:b0:141:b34e:d54f with SMTP id r11-20020a1709028bcb00b00141b34ed54fmr15789414plo.68.1635746676451;
        Sun, 31 Oct 2021 23:04:36 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:35 -0700 (PDT)
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
Subject: [PATCH v7 03/11] sched.h: use __must_be_array instead of BUILD_BUG_ON in get_task_comm
Date:   Mon,  1 Nov 2021 06:04:11 +0000
Message-Id: <20211101060419.4682-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that __get_task_comm() will truncate and pad, it's safe to use on both
too-small and too-big arrays. So it is not needed to check array length
any more. For the original goal of making sure get_task_comm() is being
used on a char array, we can use __must_be_array().

Below is the verification when I changed the dest buffer of
get_task_comm() in a driver code,

  CC [M]  drivers/infiniband/hw/qib/qib_file_ops.o
In file included from ./include/linux/bits.h:22:0,
                 from ./include/linux/ioport.h:13,
                 from ./include/linux/pci.h:31,
                 from drivers/infiniband/hw/qib/qib_file_ops.c:35:
drivers/infiniband/hw/qib/qib_file_ops.c: In function ‘setup_ctxt’:
./include/linux/build_bug.h:16:51: error: negative width in bit-field ‘<anonymous>’
 #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                   ^
./include/linux/compiler.h:258:28: note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
 #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                            ^~~~~~~~~~~~~~~~~
./include/linux/sched.h:1941:23: note: in expansion of macro ‘__must_be_array’
  __get_task_comm(buf, __must_be_array(buf) + sizeof(buf), tsk)
                       ^~~~~~~~~~~~~~~
drivers/infiniband/hw/qib/qib_file_ops.c:1325:2: note: in expansion of macro ‘get_task_comm’
  get_task_comm(test, current);

It hit this warnig as expected.

Suggested-by: Kees Cook <keescook@chromium.org>
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
 include/linux/sched.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c1a927ddec64..b9c85c52fed0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1931,10 +1931,8 @@ static inline void set_task_comm(struct task_struct *tsk, const char *from)
 }
 
 extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
-#define get_task_comm(buf, tsk) ({			\
-	BUILD_BUG_ON(sizeof(buf) != TASK_COMM_LEN);	\
-	__get_task_comm(buf, sizeof(buf), tsk);		\
-})
+#define get_task_comm(buf, tsk)		\
+	__get_task_comm(buf, __must_be_array(buf) + sizeof(buf), tsk)
 
 #ifdef CONFIG_SMP
 static __always_inline void scheduler_ipi(void)
-- 
2.17.1

