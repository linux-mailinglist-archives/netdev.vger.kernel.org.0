Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2387D578ACD
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiGRT3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbiGRT3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:12 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536D09FFF;
        Mon, 18 Jul 2022 12:28:59 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id l14so7163873qtv.4;
        Mon, 18 Jul 2022 12:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3XYQv40S3S5GPzbQg2pMTtfGv4eD74y+tQ/YBLA8hPI=;
        b=TByPl+Xwiw2xqd6sHhrukw9bBi6aYZ9/z4hJI5n//rUO3S0J3LYVyW846tuoecx0/P
         +mwSlwBGZWSeexadVQp08LKtTu3yhD9GwqRpcIaZI+JTvwBTqsldLUYP7cMYJCj0qmee
         qzWvSzxAj6hHk8lfZ/znqRQjr8YYK6LhI35e/XjH607M4tjQzo2HZoBMdEmvG4Au2nUw
         7VRp/BbOQlyMaiQHsMqpMueyXN70vJlljWT7heZMwoRcxsr+t7a84MhXDH0oqg1RW59u
         ELUqUPatBeLpVq9tLx/9dMB7Lb9eBn1unJzFEZ12o7YFpej8nHIclhzYzEdXcPOn0e7U
         PU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XYQv40S3S5GPzbQg2pMTtfGv4eD74y+tQ/YBLA8hPI=;
        b=1yUGvr2KBbqt5mRt3sIUdBoE7U9UOY1OOtJdKm7DB3fRXRnzF4GUHPeWf5rF/wis59
         RgX746WJf7x+5ec+hvNPHEr7fxGIzR5wwk74H962dXLqvvYDIb5u/vIfdzUNVwAMLwBI
         knubeXMJkCJAtNPNkAizd+iYqLNKS8E5hbIkfgRCRgpFwd8VK/3kwIhPmSCodzre0HC5
         Plj3JGItNcTFI3mjnXkoWwwsqPwTVeUfBgawFXy1MF5l+bCvFdgtijLS+YR8dtr7linD
         tyVPlNcXTcM1Td6WgGq9royTv3TlHF9gVCGKRQSbIfoNX1M23XnETn64waKqiTFBfrv8
         r8Vw==
X-Gm-Message-State: AJIora/RS7m8GyI6AgiG0CwcUGy31uSqwfbWkDDRX98yJMJ0iRDP52kf
        rUZszc0DqVYRQh47lqtanuxSIBj8Jwe0CQ==
X-Google-Smtp-Source: AGRyM1sbR5MtKZUL9t8F0KGlqcEkHR0jVinkErRs9JvmFXVZhVXEvlih/lkWGgZ5SUq5r6VMJWzeKg==
X-Received: by 2002:ac8:5cca:0:b0:31e:f51f:dd97 with SMTP id s10-20020ac85cca000000b0031ef51fdd97mr3070736qta.47.1658172538023;
        Mon, 18 Jul 2022 12:28:58 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id m13-20020ac8688d000000b0031bf484079esm8937407qtq.18.2022.07.18.12.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:57 -0700 (PDT)
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
Subject: [PATCH 10/16] sched: optimize __set_cpus_allowed_ptr_locked()
Date:   Mon, 18 Jul 2022 12:28:38 -0700
Message-Id: <20220718192844.1805158-11-yury.norov@gmail.com>
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

Don't call cpumask_subset(new_mask, cpu_allowed_mask) if new_mask
is cpu_allowed_mask.

Caught with CONFIG_DEBUG_BITMAP:
[    0.132174] Call trace:
[    0.132189]  __bitmap_check_params+0x144/0x250
[    0.132216]  __set_cpus_allowed_ptr_locked+0x8c/0x2c0
[    0.132241]  sched_init_smp+0x80/0xd8
[    0.132273]  kernel_init_freeable+0x12c/0x28c
[    0.132299]  kernel_init+0x28/0x13c
[    0.132325]  ret_from_fork+0x10/0x20
[    0.132354] ---[ end trace 0000000000000000 ]---
[    0.132378] b1:	ffffcd0c07819a58
[    0.132388] b2:	ffffcd0c07819a58
[    0.132397] b3:	0
[    0.132405] nbits:	256
[    0.132414] start:	0
[    0.132422] off:	0
[    0.132444] Bitmap: parameters check failed
[    0.132467] include/linux/bitmap.h [468]: bitmap_subset

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da0bf6fe9ecd..d6424336ef2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2874,7 +2874,8 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 		cpu_valid_mask = cpu_online_mask;
 	}
 
-	if (!kthread && !cpumask_subset(new_mask, cpu_allowed_mask)) {
+	if (!kthread && new_mask != cpu_allowed_mask &&
+			!cpumask_subset(new_mask, cpu_allowed_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.34.1

