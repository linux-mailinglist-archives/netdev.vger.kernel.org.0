Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA1B439164
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhJYIgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbhJYIgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:25 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EADC061224;
        Mon, 25 Oct 2021 01:33:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v16so2028429ple.9;
        Mon, 25 Oct 2021 01:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3JLxwHM1CeX0o7W4dwtTtvlyCiBChK2EpomgZ3q4G2c=;
        b=ePdfPG1JTA0ck7rtQ5KzZPGFF1sIvEFh4aTe6YJByMYFNpp44OqKvD13fZGA4EZ6id
         sDRU5XC4NgVOeJORW05ElLhXB73fHs4A5lqGI0Z7JMTeW75f56tnj84uRuv3fDoflktv
         Cxg3lG9LcxZLJ/4VJNZ0fVFD5yyADpYIxDzDVsDash7oLO/wcCtNZIq1FojiTpZferwd
         VHIPB117F8ZtuVZzPOovDkUTmtxWku9LUmVUih/uPrbAQChABOXO7CsMVqYc1mzESNGe
         zSwNavI52UykTZZUy3W4/sXxoXKFZCj+GJQh30XLp2LOZEDtBO8nscEpn1CCcw2KKcxa
         h5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3JLxwHM1CeX0o7W4dwtTtvlyCiBChK2EpomgZ3q4G2c=;
        b=PhdPLVRhMtAZq6yQY9LzwTbg02JzH4QRbv3bXP3Sw7A0r2td0q9XUGK9d28DR6n7Nr
         PETYKMiOjPBvvJr+TwfRZ+92/WD8gQycLCfM0gWbSaIWxTDp9biS91iN+wHbx0wrBSie
         Sgb6H6DRX9RjkHE7alnVfH1SIn8VvRHdQ5UZ8deWPoMzxlUXkj7wqKgJ1H8Cr5M2LJFP
         UyLkJGkNiPwB5D49/KAz/JzrZv0YG0fXI85Zgtuw0UafRMfgSVcCpowBcIa46KtM4MLB
         T0B1CRxZitPvL0Hd0Q1tqjt7MXYT0aoawYHeskJ8Rxb/iY5N6yNNNJmHhAupgLqsZym8
         u/6w==
X-Gm-Message-State: AOAM5313O/LQd9bYKsrF5yL6aw8kvFKkgE/fzto1SpEVFbJMqkn/4skL
        zZc/IxU6G1THoUU3yBgeqV8=
X-Google-Smtp-Source: ABdhPJzKtmTPywPSXUOghfkjQUrKogUwRUlblGA2CFK9iX/Cg60lUvJHKUYmf90ZIfyJxDns3bO2sg==
X-Received: by 2002:a17:903:32c7:b0:13e:ea76:f8cb with SMTP id i7-20020a17090332c700b0013eea76f8cbmr15237119plr.74.1635150838815;
        Mon, 25 Oct 2021 01:33:58 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:58 -0700 (PDT)
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
Subject: [PATCH v6 07/12] samples/bpf/offwaketime_kern: make sched_switch tracepoint args adopt to comm size change
Date:   Mon, 25 Oct 2021 08:33:10 +0000
Message-Id: <20211025083315.4752-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sched:sched_switch tracepoint is derived from kernel, we should make
its args compitable with the kernel.

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
 samples/bpf/offwaketime_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index 4866afd054da..eb4d94742e6b 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -113,11 +113,11 @@ static inline int update_counts(void *ctx, u32 pid, u64 delta)
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
-- 
2.17.1

