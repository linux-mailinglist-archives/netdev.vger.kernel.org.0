Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C56441365
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhKAGHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhKAGHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA0CC061714;
        Sun, 31 Oct 2021 23:04:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so15307312pje.0;
        Sun, 31 Oct 2021 23:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HfuDNEiJT3BfJis8gojDnNsP87rFWM/LtilUesqMR5U=;
        b=hPb9/J7ocOjTulc4EreHCv8ZMiDH7pY0cCDo/lAIUe0tnuOnhIo5NHHug7nWuJhrNC
         6vtVwF5uYsRSCf7RfEpnZD/J0nqa25t6NpDZ053/nVgcg1n+PRqGI40eSjB5C9FL96df
         4D6KcJrwmQXgwdK4zJJfcYP3RS9yKvQgt8/ZkbbVP3+ilc93odwkhmd3O0NAarTD5WDq
         ZnoJsc4bZN1D3V6Fo82j0RR5+FKeHn+QsNLQHdHfs84ZO8yuGicC3Jn5/yvYglIqpHXU
         8obAblxVypVdciBUpGDBoPUuxBiOWFZ1wv+VfYR44yyHma+mcUd73KOAlrLzu1v57TYJ
         aR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HfuDNEiJT3BfJis8gojDnNsP87rFWM/LtilUesqMR5U=;
        b=wZyWVoWw4PhVZ+2VZgjbKAF9ueAIkgMjaZ/ia3GkczKcsPn/joaBsz57Nm86VECdkl
         mMTZovq8QS7EodoaxmWtaC4oJb/bOPTaXt43e/Gb55dvx/VpOiwoa+oaKMQ6v4Mh+lfB
         XSqescdex1xM7Q4qEXNVIQ/wmhO1p4L9GB2E7DRF8q0tZ5rbVZa4YQpSNxC3MZW3Skk4
         LEqyTBppSaGuSFkkHxwMRkgFw4/KU2PPTPt1b5KKJi4NRPAJHx5AFXCB5TmxlmH0JLcD
         jYGzqVXVKD8PDvV5y4LpZAmViiQjx3g1d2ulVPTiVhBTQbB7iI/CFMf9ZwZm9tK56Wkz
         aNzw==
X-Gm-Message-State: AOAM53312Ytsh/DmQKyAvMT94Ll6Xq+linlZCAXn3nQIw63AvGWe/18T
        kfkFYC7PhRuD7Sr1FAzDxRw=
X-Google-Smtp-Source: ABdhPJzGByODALzastMQt6vIF+ynjmZShKqwIA1uQ394MFzxHKuVJACVDnLYpsoO/05vk972q4vbYA==
X-Received: by 2002:a17:90b:30e:: with SMTP id ay14mr15464050pjb.60.1635746674092;
        Sun, 31 Oct 2021 23:04:34 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:33 -0700 (PDT)
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
Subject: [PATCH v7 02/11] fs/exec: make __get_task_comm always get a nul terminated string
Date:   Mon,  1 Nov 2021 06:04:10 +0000
Message-Id: <20211101060419.4682-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
will be without null ternimator, that may cause problem. We can make sure
the buffer size not smaller than comm at the callsite to avoid that
problem, but there may be callsite that we can't easily change.

Using strscpy_pad() instead of strncpy() in __get_task_comm() can make
the string always nul ternimated.

Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
 fs/exec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 404156b5b314..013b707d995d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1209,7 +1209,8 @@ static int unshare_sighand(struct task_struct *me)
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, buf_size);
+	/* Always NUL terminated and zero-padded */
+	strscpy_pad(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
-- 
2.17.1

