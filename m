Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3D3578ADF
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiGRTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiGRT3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:15 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4812DA8E;
        Mon, 18 Jul 2022 12:29:05 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id e5so9537614qts.1;
        Mon, 18 Jul 2022 12:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tA2rl8RctZ6HL9V5x9xFMH8oSgBBwUuElKQvWOHzbeI=;
        b=hP/RxbCCEkxGibcmzYfoczVfz2LGpVvZkrG5wlu75XNiAI1BfNZJPMtwQd0PYtFa4k
         9sqDaS6kmGHiRQpzGl3YHVh0l8qAJUfrnfctlEXZsk+yJaCHbydmsJ/FIeyIMRe2QYYS
         AB02g9p+c9CoMw9OrSZ9omO4Oxfqs9oeUUaFdWEZpJcv2MJ7cdtPYz3Fd8zBnbGvz1Iw
         o7jHZpB3NBZRj1mxkRUcREMvO38UFX1tl3lIgHvmj+MBAc2h6f3RXJF3Q60pUT+dIr1T
         Zgt4vkyg0W1HEu5nB4dG2ctBT26OjozQ53zCuCaHayZmI0SZj41p5lheZfaXVwMwGzSd
         cd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tA2rl8RctZ6HL9V5x9xFMH8oSgBBwUuElKQvWOHzbeI=;
        b=qtjOuBinv1cjHReODh9T0bjPhnyu5jC0QelJgxKYx3Arsce7Yigf0yxIcSts23lfb1
         pAury/y9BIhoIkAzApCV9F8JcplIbrVrqxQ97D7k8HVFm4X8zsSVVnVUkbjOdBj0yAc3
         9E6VSQROy+f/KIr8zpVMmc4O4oX6Dv8+4TKehi0lA6Amg6uWCqk+qxa7IoE4vpAzwGV/
         C2NNz1w4gmz0xDH1ZpGl0lnPaaGycQ077ZA38BKll8euwrmSG6eh/Xblm5QoATD914I9
         Lq699aNuQA7exlALJUyr7hvZaGobg4OvvJUf5/s7+fMsWI00X4J3leqy2UKgY+Jzmjef
         ffNg==
X-Gm-Message-State: AJIora+QaTfqUYwF0qSHYlCkEyEoFJFW/ZybbU+sSRvjRdmjbCEffEla
        4WF1dBbWJ7Bt/jgFgtH7eF14EZ224ObACw==
X-Google-Smtp-Source: AGRyM1vQmvbkX1kTEORONuNSMwS4ZWos+Eg2Ylq19DBEaI61zIn7vgC2XHqbVwUo3RPShBlZ/+yVwg==
X-Received: by 2002:ac8:5790:0:b0:31e:f69a:1b9e with SMTP id v16-20020ac85790000000b0031ef69a1b9emr2408133qta.103.1658172544528;
        Mon, 18 Jul 2022 12:29:04 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id v17-20020ac85791000000b0031ee2080c73sm6310369qta.54.2022.07.18.12.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:29:04 -0700 (PDT)
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
Subject: [PATCH 15/16] sched/topology: optimize topology_span_sane()
Date:   Mon, 18 Jul 2022 12:28:43 -0700
Message-Id: <20220718192844.1805158-16-yury.norov@gmail.com>
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

topology_span_sane() checks if cpu == i before calling
	cpumask_equal(tl->mask(cpu), tl->mask(i)).

However, tl->mask(cpu) and tl->mask(i) may point to the same cpumask
even if i != cpu. Fix the check accordingly.

While here, move tl->mask(cpu) out of the loop, and make the in-loop
code calculating tl->mask(i) only once.

Catched with CONFIG_DEBUG_BITMAP:
[    0.867917] Call Trace:
[    0.868209]  <TASK>
[    0.868471]  build_sched_domains+0x36f/0x1a40
[    0.868576]  sched_init_smp+0x44/0xba
[    0.869012]  ? mtrr_aps_init+0x84/0xa0
[    0.869465]  kernel_init_freeable+0x12e/0x26e
[    0.869982]  ? rest_init+0xd0/0xd0
[    0.870406]  kernel_init+0x16/0x120
[    0.870821]  ret_from_fork+0x22/0x30
[    0.871244]  </TASK>
[    0.871502] ---[ end trace 0000000000000000 ]---
[    0.872040] b1:              ffffffffb1fd3480
[    0.872041] b2:              ffffffffb1fd3480
[    0.872041] b3:              0
[    0.872042] nbits:   256
[    0.872042] start:   0
[    0.872042] off:     0
[    0.872043] Bitmap: parameters check failed
[    0.872043] include/linux/bitmap.h [427]: bitmap_equal

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/sched/topology.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05b6c2ad90b9..ad32d0a43424 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2211,6 +2211,8 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
 static bool topology_span_sane(struct sched_domain_topology_level *tl,
 			      const struct cpumask *cpu_map, int cpu)
 {
+	const struct cpumask *mc = tl->mask(cpu);
+	const struct cpumask *mi;
 	int i;
 
 	/* NUMA levels are allowed to overlap */
@@ -2226,14 +2228,18 @@ static bool topology_span_sane(struct sched_domain_topology_level *tl,
 	for_each_cpu(i, cpu_map) {
 		if (i == cpu)
 			continue;
+
+		mi = tl->mask(i);
+		if (mi == mc)
+			continue;
+
 		/*
 		 * We should 'and' all those masks with 'cpu_map' to exactly
 		 * match the topology we're about to build, but that can only
 		 * remove CPUs, which only lessens our ability to detect
 		 * overlaps
 		 */
-		if (!cpumask_equal(tl->mask(cpu), tl->mask(i)) &&
-		    cpumask_intersects(tl->mask(cpu), tl->mask(i)))
+		if (!cpumask_equal(mc, mi) && cpumask_intersects(mc, mi))
 			return false;
 	}
 
-- 
2.34.1

