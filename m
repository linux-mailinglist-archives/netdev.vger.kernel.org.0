Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE874578ACF
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiGRT3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiGRT25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:57 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91B26F5;
        Mon, 18 Jul 2022 12:28:55 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id o1so9549566qkg.9;
        Mon, 18 Jul 2022 12:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=m9V57xphOJe8FxCe80bZ1J3RuFelVtvXoENVWMfISb4=;
        b=B0XuB+yAeTJmK6B+vnHnd3BO8yIPsZ8lCES1PpoVp7Ti9ESY8L/5LseEzml+iCgDqI
         1YlvnrUUgNx4DD7RQwT4vms4g+VmvWZpGoAnJNKJ0UYr9HyWBXYZufeEWv7Vuwxy/4nI
         qIrQ27tmeRvKsD0HQGA4yMLWkqHFveDpBWb4zZNi9MJuv/+VtQRCqaE5PFi0tfV7R98a
         9bkurHLXilYTf8+/4Z6M5WqsGBng481jqtXDo5QizTdcTOcHRejuVHRFGd14+vBFF67B
         NUB7Epima9nbyqEkq0yYEeKIgt/HN7ct0hLat+eWTlW+qrZnqyzPXV06pMIjXg2GHmsY
         vUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9V57xphOJe8FxCe80bZ1J3RuFelVtvXoENVWMfISb4=;
        b=x2W7Yce8qD7GAnd11x8NoHIrMk5s0ETIBCgK/MKrwAaTqwnjMN5gvLv3sWOQ7zwmfs
         V3zPrRgb2ayJ95ctGN2m2w2cQKCKu7toIN2lGU0+SA7AqBL9aSVNPSEcK9xsBq3bA/t1
         exa2Sw22nksud25LoouCuhj++9DC5lxutwbM/WgLn/F1mecuhWcFZ2fiHWJuZiAMm5mH
         OPl9FzyPClpwbCq2KxhAiSdlltG7tAQFXp1FIIG9CUewmqeoCWRg5lsVr73AIei1hBKr
         iWP3VOPgS8HjVCEN5LjHChIJcSh9JxYcykPhsWmHybwtyoXgknkhx4KmU/V4OQS8Bb5C
         aWJg==
X-Gm-Message-State: AJIora8MDHGoaHeRScbu8fbfB9W1NrBoVPI4Bcwv+3uL97NgiDZjOuIO
        0Eh20ChSsEW/tes+grOp2kpfqF82KyFafg==
X-Google-Smtp-Source: AGRyM1vQdCay2nDpE1RIgzYmRYjdYqMGFdzO6hLEN38y55+zWOu2X7pBEMBNCfY35RCjup6wtifAoA==
X-Received: by 2002:a05:620a:468e:b0:6b5:af5b:6e5f with SMTP id bq14-20020a05620a468e00b006b5af5b6e5fmr18034173qkb.288.1658172534753;
        Mon, 18 Jul 2022 12:28:54 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id x6-20020a05620a258600b006a65c58db99sm12736880qko.64.2022.07.18.12.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:54 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        Yury Norov <yury.norov@gmail.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 07/16] smp: optimize smp_call_function_many_cond()
Date:   Mon, 18 Jul 2022 12:28:35 -0700
Message-Id: <20220718192844.1805158-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220718192844.1805158-1-yury.norov@gmail.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smp_call_function_many_cond() is often passed with cpu_online_mask.
If this is the case, we can use num_online_cpus(), which is O(1)
instead of cpumask_{first,next}(), which is O(N).

It can be optimized further: if cpu_online_mask has 0 or single bit
set (depending on cpu_online(this_cpu), we can return result without
AND'ing with user's mask.

Caught with CONFIG_DEBUG_BITMAP:
[    7.830337] Call trace:
[    7.830397]  __bitmap_check_params+0x1d8/0x260
[    7.830499]  smp_call_function_many_cond+0x1e8/0x45c
[    7.830607]  kick_all_cpus_sync+0x44/0x80
[    7.830698]  bpf_int_jit_compile+0x34c/0x5cc
[    7.830796]  bpf_prog_select_runtime+0x118/0x190
[    7.830900]  bpf_prepare_filter+0x3dc/0x51c
[    7.830995]  __get_filter+0xd4/0x170
[    7.831145]  sk_attach_filter+0x18/0xb0
[    7.831236]  sock_setsockopt+0x5b0/0x1214
[    7.831330]  __sys_setsockopt+0x144/0x170
[    7.831431]  __arm64_sys_setsockopt+0x2c/0x40
[    7.831541]  invoke_syscall+0x48/0x114
[    7.831634]  el0_svc_common.constprop.0+0x44/0xfc
[    7.831745]  do_el0_svc+0x30/0xc0
[    7.831825]  el0_svc+0x2c/0x84
[    7.831899]  el0t_64_sync_handler+0xbc/0x140
[    7.831999]  el0t_64_sync+0x18c/0x190
[    7.832086] ---[ end trace 0000000000000000 ]---
[    7.832375] b1:		ffff24d1ffd98a48
[    7.832385] b2:		ffffa65533a29a38
[    7.832393] b3:		ffffa65533a29a38
[    7.832400] nbits:	256
[    7.832407] start:	0
[    7.832412] off:	0
[    7.832418] smp: Bitmap: parameters check failed
[    7.832432] smp: include/linux/bitmap.h [363]: bitmap_and

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/smp.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index dd215f439426..7ed2b9b12f74 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -880,6 +880,28 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
 #define SCF_WAIT	(1U << 0)
 #define SCF_RUN_LOCAL	(1U << 1)
 
+/* Check if we need remote execution, i.e., any CPU excluding this one. */
+static inline bool __need_remote_exec(const struct cpumask *mask, unsigned int this_cpu)
+{
+	unsigned int cpu;
+
+	switch (num_online_cpus()) {
+	case 0:
+		return false;
+	case 1:
+		return cpu_online(this_cpu) ? false : true;
+	default:
+		if (mask == cpu_online_mask)
+			return true;
+	}
+
+	cpu = cpumask_first_and(mask, cpu_online_mask);
+	if (cpu == this_cpu)
+		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+
+	return cpu < nr_cpu_ids;
+}
+
 static void smp_call_function_many_cond(const struct cpumask *mask,
 					smp_call_func_t func, void *info,
 					unsigned int scf_flags,
@@ -916,12 +938,7 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
 	if ((scf_flags & SCF_RUN_LOCAL) && cpumask_test_cpu(this_cpu, mask))
 		run_local = true;
 
-	/* Check if we need remote execution, i.e., any CPU excluding this one. */
-	cpu = cpumask_first_and(mask, cpu_online_mask);
-	if (cpu == this_cpu)
-		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (cpu < nr_cpu_ids)
-		run_remote = true;
+	run_remote = __need_remote_exec(mask, this_cpu);
 
 	if (run_remote) {
 		cfd = this_cpu_ptr(&cfd_data);
-- 
2.34.1

