Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22DD578AD9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiGRTaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiGRT3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:13 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A52A279;
        Mon, 18 Jul 2022 12:29:02 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id g9so9551028qvq.7;
        Mon, 18 Jul 2022 12:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9jRBPxHetNaAYvNL/Zbk4Gz5JHeIZjINC1YVksHLpK0=;
        b=UWtmw4bkYSqZCrwkTdXvOJn0HuT45kCRhfcR25N1KZz4XPy5uHeP36ClHVvtxuQ0ml
         eR5MjNl5qmX49XbhugFRX9Q90pk0oydAsfvrCtMgEq6H+FFLr5M39bqMJV/2aDTL8QMd
         Mr5FnWMOsu+Oj9iWEBqUquNtUmVGFIUMVcfpkrmO4P1SAV9L6D4GUGE/7pXbBYWmGSvp
         yCoqENUMPT3+KVmnijAAPfz650MZZj/EIkfrWSELI+A5ssy2P71glhClbjpPNPVxkZHm
         vYHQO4TP3f3Ii52Sn3fr1U56mheGEatDLvDKTJFdhaq7zhn6Qn+rmyN5Vn2ChEuVs68B
         RCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jRBPxHetNaAYvNL/Zbk4Gz5JHeIZjINC1YVksHLpK0=;
        b=MMDx0q0vzdkhzCXSzUyTA2uNgME5QBkLeAYGw4UHdXWcW4RHJ0q/TFPGVHBcWCxIvD
         9xqy/+nl60LJmSv3Uw3Cz3Z0FfNszUBVVWDsXYenoNgG6Ie9Z5D7FPN1A38/2MhDSdW4
         lEWFdxJSeznu03Q983i/0J/basWTnsMpyuPi9kgIhOzTqLajyInzXuAm6EgRbFJY+ukQ
         mfJOC3IHSmKUFd0oKx/dIe7djaINEcssl5XzPKalPvdftIJu/LyjFyFbw+zYf6Z8w4zg
         q4Z2TFHBwH158mr912fa0sFWOrSQcGrh9i3jbQkOSCDEBeQ1rNWWtuhgOvEJhjWbTNVO
         CTfg==
X-Gm-Message-State: AJIora9wNTh+BQcgvqtVvER3Gao1hq8DCUJQILkw8LKDezQpVBNq3vIG
        YIPVz83tpV07cJ+jOV4t1ZMo0IG4G88Teg==
X-Google-Smtp-Source: AGRyM1tJL6xF5uFJZtWlPYKjynWj22iMoR4ixYcMYqU4mAIXJGlgzVLwHxDXYCNM6iwonqEgJ0BPsw==
X-Received: by 2002:a05:6214:d8c:b0:473:5a78:cdd3 with SMTP id e12-20020a0562140d8c00b004735a78cdd3mr22081665qve.105.1658172540532;
        Mon, 18 Jul 2022 12:29:00 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id y14-20020a37640e000000b006b5869c1525sm11450264qkb.21.2022.07.18.12.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:59 -0700 (PDT)
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
Subject: [PATCH 12/16] time: optimize tick_check_percpu()
Date:   Mon, 18 Jul 2022 12:28:40 -0700
Message-Id: <20220718192844.1805158-13-yury.norov@gmail.com>
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

tick_check_percpu() calls cpumask_equal() even if
curdev->cpumask == cpumask_of(cpu). Fix it.

Caught with CONFIG_DEBUG_BITMAP:
[    0.077622] Call trace:
[    0.077637]  __bitmap_check_params+0x144/0x250
[    0.077675]  tick_check_replacement+0xac/0x320
[    0.077716]  tick_check_new_device+0x50/0x110
[    0.077747]  clockevents_register_device+0x74/0x1c0
[    0.077779]  dummy_timer_starting_cpu+0x6c/0x80
[    0.077817]  cpuhp_invoke_callback+0x104/0x20c
[    0.077856]  cpuhp_invoke_callback_range+0x70/0xf0
[    0.077890]  notify_cpu_starting+0xac/0xcc
[    0.077921]  secondary_start_kernel+0xe4/0x154
[    0.077951]  __secondary_switched+0xa0/0xa4
[    0.077992] ---[ end trace 0000000000000000 ]---
[    0.078021] b1:	ffffbfec4703b890
[    0.078031] b2:	ffffbfec4703b890
[    0.078043] b3:	0
[    0.078052] nbits:	256
[    0.078065] start:	0
[    0.078075] off:	0
[    0.078086] Bitmap: parameters check failed
[    0.078095] include/linux/bitmap.h [419]: bitmap_equal

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/time/tick-common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index fdd5ae1a074b..7205f76f8d10 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -290,13 +290,15 @@ static bool tick_check_percpu(struct clock_event_device *curdev,
 {
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		return false;
-	if (cpumask_equal(newdev->cpumask, cpumask_of(cpu)))
+	if (newdev->cpumask == cpumask_of(cpu) ||
+			cpumask_equal(newdev->cpumask, cpumask_of(cpu)))
 		return true;
 	/* Check if irq affinity can be set */
 	if (newdev->irq >= 0 && !irq_can_set_affinity(newdev->irq))
 		return false;
 	/* Prefer an existing cpu local device */
-	if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
+	if (curdev && (curdev->cpumask == cpumask_of(cpu) ||
+			cpumask_equal(curdev->cpumask, cpumask_of(cpu))))
 		return false;
 	return true;
 }
-- 
2.34.1

