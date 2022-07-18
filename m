Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B76578AC2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiGRT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbiGRT3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:03 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DB4B841;
        Mon, 18 Jul 2022 12:28:57 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id r2so9570577qta.0;
        Mon, 18 Jul 2022 12:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RIuxtr8d+TB6goTZIrQnEqj0NYsoVNuGdOrD+16hKvE=;
        b=K6FLy4kdLZiOyB3bLUhszl5Zd1puGwKh81hdQ6rMAxhulKYqedp7eUmoIZR0afJcpb
         nkiXT9uXP0O9WHgoCSQ2IR/sDvIeb+YkvalAFfr8I5dYLsp+gO1RFi5HdpTv9xwEjdQ2
         auToBt5qQGIID9AHzaDc+sYfyIwWA0/KGjjZxYfmJ39gMRAk2oUkonyTSXkmCxoD4Fux
         yUPBSSyh4zYo4dxNsy901oFcH5LCqM2CA0xbWm/ZpSmbLWp+HfPmCnB1q1t1r0vv+BNU
         aNYNiAkMVnc3um9vm7dDymoR9WWvElT0wUSR1fdH1muLCWOWVQ3EyjMKXAO1Br2kBR00
         Vx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIuxtr8d+TB6goTZIrQnEqj0NYsoVNuGdOrD+16hKvE=;
        b=gFWudZYVFqtuqMOmd4NJn95F2VqDGSm/mEU00IG7Tpmca2mgfOQP+1zvT1teLn7IkI
         /8Nk4GljTzgGPvvNArlWptwhruF9LwJxgzYRRexoR7v1jmjRZ0ogd3qx9u0IuFuCjSQi
         XB3+qwwaa2tF+VoDPzKOmezyC6deOvOhNOaVS/8O+h3ewkdwwkna1JUe9dR1F03edH9/
         rk0C3IkeybFG1vGjO4uz/3zG8xG3yNrGitbjA82ew92Q0HzIn84ZOxkxcop892TpceIE
         frsOpSoY7zGma+ELq0xRcaFO18efr55C3aXgDNjec5WTYBn0LTLXpGFpYcZBmdBhgRGD
         Bvlw==
X-Gm-Message-State: AJIora/DWbkpU1xWxTqBtLbwy4G0aCM34cNnZehS6wTrqhlovXJ7WAaj
        jFF6xLXN3O/AbF14imNAV6HtbGd4whNqaQ==
X-Google-Smtp-Source: AGRyM1t1sw1jCN1ieW37kpkYQIAyMtVdPUyvBuYOD3/FMPrCUNrO4liqD1XLniGG0iHGpMVX+tZbUg==
X-Received: by 2002:ac8:7e89:0:b0:31e:e0dd:9084 with SMTP id w9-20020ac87e89000000b0031ee0dd9084mr10850238qtj.37.1658172535998;
        Mon, 18 Jul 2022 12:28:55 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id bi14-20020a05620a318e00b006b5f85f8fa8sm1114706qkb.125.2022.07.18.12.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:55 -0700 (PDT)
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
Subject: [PATCH 08/16] smp: optimize smp_call_function_many_cond() for more
Date:   Mon, 18 Jul 2022 12:28:36 -0700
Message-Id: <20220718192844.1805158-9-yury.norov@gmail.com>
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
If it's the case, we can use cpumask_copy instead of cpumask_and, which
is faster.

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
 kernel/smp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 7ed2b9b12f74..f96fdf944b4a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -942,7 +942,11 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
 
 	if (run_remote) {
 		cfd = this_cpu_ptr(&cfd_data);
-		cpumask_and(cfd->cpumask, mask, cpu_online_mask);
+		if (mask == cpu_online_mask)
+			cpumask_copy(cfd->cpumask, cpu_online_mask);
+		else
+			cpumask_and(cfd->cpumask, mask, cpu_online_mask);
+
 		__cpumask_clear_cpu(this_cpu, cfd->cpumask);
 
 		cpumask_clear(cfd->cpumask_ipi);
-- 
2.34.1

