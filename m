Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2558023D23A
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgHEUKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgHEQ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:28:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C47AC008699
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 09:28:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w17so25521402ply.11
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 09:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A43ByyyVzbSptwNygct83mi3n2DzKWgXvNfPebKl6yg=;
        b=Vhtt0A1Lb+45MJ+Wh1Mnd/6dAyl5W8x4OJgHYPrxVIsTEvhXGbgFbuLoVs9PSI6FVb
         4+koDTinZDAnktM3XmWYW7oHe5byoeDqkyO3ubwkG+KfRrbD2WMJH0qKf4zNdJGVO8xx
         /e+WkeJsW8Oiw8Oedhof48VQhF5C8NcxQC8V7xQa+zd9BKfaXQOlnpPjApEQoPPIPADl
         thisXlmYHDhe2M9jishy6oQJKDq11jKExdFuyCVrsIf0fGx3Nrk9iwaKa1IrCGV07MB8
         jCflwrMAOiNIa8bWrrpkDC6KlBXWRewwszJNRIvUcfK9Dvz2VLM9OGf6oxYKWsMATv8U
         OmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A43ByyyVzbSptwNygct83mi3n2DzKWgXvNfPebKl6yg=;
        b=MuVHGiLOnncEZvJP4gWHw7jIb6VdC0eTqiHk5x5tk0UbWfeu9LSSpv1MppzDOhmUi8
         owr5mmpFPE8bwZUltRGGm63YHFKRtCQk/NP00ZcLYZ6khHt+ni1FpGFz4stmm2nh7JrI
         bKFQNkd14qPKDaUjOFIn+o7gx4PFcLhoyNtx65xIJW49ZHZRcPeoh9j/H6BEuHHfEAbu
         51vVzRt4dn3gspBB/fMJF9Fn8AJPpmUQsrNu6oPwYLJhkTOKPx2VaEP+GSi/QH1X6MfT
         k5Enqv5HDJ3Ihy7yizbyEKJ8sDK8rtfnnorTXtqsGhqYJma8mLZsTto2YABofKX0cYtU
         6UKQ==
X-Gm-Message-State: AOAM5333p23fAVudjKF9rYQSHkX+ooeFvlQt08ZaOdaWkZTjP0bZjSTP
        PdDDKg3BMEmXBoswF+wCEWRomQ==
X-Google-Smtp-Source: ABdhPJz8Xblx/0gqLzz6ZElpaAiPlDeIUeBjMLlCp2hzlHJxhui/0ePgefixV57yu+dDZ6yxbRkDVQ==
X-Received: by 2002:a17:90a:4502:: with SMTP id u2mr3822075pjg.187.1596644918065;
        Wed, 05 Aug 2020 09:28:38 -0700 (PDT)
Received: from localhost.localdomain ([103.136.220.70])
        by smtp.gmail.com with ESMTPSA id 12sm3953119pfn.173.2020.08.05.09.28.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:28:37 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     rostedt@goodmis.org, naveen.n.rao@linux.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        sfr@canb.auug.org.au, mingo@kernel.org, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2] kprobes: fix NULL pointer dereference at kprobe_ftrace_handler
Date:   Thu,  6 Aug 2020 00:27:13 +0800
Message-Id: <20200805162713.16386-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found a case of kernel panic on our server. The stack trace is as
follows(omit some irrelevant information):

  BUG: kernel NULL pointer dereference, address: 0000000000000080
  RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
  RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
  RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
  RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <IRQ>
   ftrace_ops_assist_func+0x56/0xe0
   ftrace_call+0x5/0x34
   tcpa_statistic_send+0x5/0x130 [ttcp_engine]

The tcpa_statistic_send is the function being kprobed. After analysis,
the root cause is that the fourth parameter regs of kprobe_ftrace_handler
is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.

  crash> dis tcpa_statistic_send -r
         <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>

The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
is NULL. In theory, we should call the ftrace_regs_caller instead of the
ftrace_caller. After in-depth analysis, we found a reproducible path.

  Writing a simple kernel module which starts a periodic timer. The
  timer's handler is named 'kprobe_test_timer_handler'. The module
  name is kprobe_test.ko.

  1) insmod kprobe_test.ko
  2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
  3) echo 0 > /proc/sys/kernel/ftrace_enabled
  4) rmmod kprobe_test
  5) stop step 2) kprobe
  6) insmod kprobe_test.ko
  7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'

We mark the kprobe as GONE but not disarm the kprobe in the step 4).
The step 5) also do not disarm the kprobe when unregister kprobe. So
we do not remove the ip from the filter. In this case, when the module
loads again in the step 6), we will replace the code to ftrace_caller
via the ftrace_module_enable(). When we register kprobe again, we will
not replace ftrace_caller to ftrace_regs_caller because the ftrace is
disabled in the step 3). So the step 7) will trigger kernel panic. Fix
this problem by disarming the kprobe when the module is going away.

Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
changelogs in v2:
 1) fix compiler warning for !CONFIG_KPROBES_ON_FTRACE.

 kernel/kprobes.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 146c648eb943..d36e2b017588 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1114,9 +1114,20 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
-#define prepare_kprobe(p)	arch_prepare_kprobe(p)
-#define arm_kprobe_ftrace(p)	(-ENODEV)
-#define disarm_kprobe_ftrace(p)	(-ENODEV)
+static inline int prepare_kprobe(struct kprobe *p)
+{
+	return arch_prepare_kprobe(p);
+}
+
+static inline int arm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
+
+static inline int disarm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
 #endif
 
 /* Arm a kprobe with text_mutex */
@@ -2148,6 +2159,13 @@ static void kill_kprobe(struct kprobe *p)
 	 * the original probed function (which will be freed soon) any more.
 	 */
 	arch_remove_kprobe(p);
+
+	/*
+	 * The module is going away. We should disarm the kprobe which
+	 * is using ftrace.
+	 */
+	if (kprobe_ftrace(p))
+		disarm_kprobe_ftrace(p);
 }
 
 /* Disable one kprobe */
-- 
2.11.0

