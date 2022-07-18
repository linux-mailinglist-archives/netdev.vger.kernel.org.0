Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C685578AD6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiGRTaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiGRT3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:13 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D74A44A;
        Mon, 18 Jul 2022 12:29:03 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id l14so7164036qtv.4;
        Mon, 18 Jul 2022 12:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nMdR+AEtByh2Sj3uhRet9r/mYlLTue7hiNXqJ4zPF7A=;
        b=ThZjcWWpivQL4LIMCYMLUyqh5o5kXMqBz+8OT2okIYTlrj/edxwBb2dbQa9UPOmtF6
         4kSD+ZK2zlONe0lcAJjESBk9Nh+IMF2AWtzKWASNF/7e6AOQFfgrht6kvwCXXaBw+ZJ/
         TuekgFubFOIx/+8XhYbzZTP0R9y2FHpWi0c1TNSBFoZBSAURAUsk02B8TI4+roOQrfEb
         rqvV8Zlz0kLm2wnKF7Eb5xNF8jQ/LSP7mPfSKTCz8rO9Som4BkQVoJkslp7Xj+XOaxbI
         /IAz4pqpN4giyGSLVmRa+JZ33lWzIiVJrwXSuZTIP487wCG2DZbEQ+zSsLJzYmv+Cs+/
         XhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMdR+AEtByh2Sj3uhRet9r/mYlLTue7hiNXqJ4zPF7A=;
        b=qLIGhyV2409m4CxitSPQKxY9DA+HrMefJE9hJcR0YL9nXimwMT+/yC9S8rFm0jyXTI
         cqE1A37T4LeI0Hlnqzak0YXGFTysI9GPy23KR3DRuUeJFFVtc2LtYSg2e5Hy0kwKTBly
         Na4QKhuGB4H/vTeMJMKynqt2/m3n3rZWXNlo45RzihQEgF3lNlCb5+ScuufZLyt/cdPQ
         2jFiwqWLQzoX+SASXBM2NieCTL/4YT1LqKodzyJy7ZyNivFYsC3oquo741CarDlhCH8q
         TSenN/RPrWNnaaA/8Fr1DnWNQyWS5jpaC7hpRl75lNYV1VCSOvcXsj7dRenG4Mzzwlsa
         GAPA==
X-Gm-Message-State: AJIora+diTQeF2YOz/Bz+t5JYP55yN4z66jwxlmMPaYipdQp9JkXlDtb
        ILUnKVMNIEJxQ5aybK7CGAY6KIef0Tm29w==
X-Google-Smtp-Source: AGRyM1vJb89RwvBBeMzFkakUtULOUGREDepYG3L9kNDYRN+9fj+cWruAf8vfYMA3CaqjYR907kc98w==
X-Received: by 2002:a05:622a:213:b0:31e:c569:220e with SMTP id b19-20020a05622a021300b0031ec569220emr22576563qtx.436.1658172542486;
        Mon, 18 Jul 2022 12:29:02 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id n18-20020a05620a295200b006b5e45ff82csm5125690qkp.93.2022.07.18.12.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:29:02 -0700 (PDT)
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
Subject: [PATCH 13/16] time: optimize tick_setup_device()
Date:   Mon, 18 Jul 2022 12:28:41 -0700
Message-Id: <20220718192844.1805158-14-yury.norov@gmail.com>
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

tick_setup_device() calls cpumask_equal(newdev->cpumask, cpumask)
even if newdev->cpumask == cpumask. Fix it.

Caught with CONFIG_DEBUG_BITMAP:
[    0.070960] Call trace:
[    0.070974]  __bitmap_check_params+0x144/0x250
[    0.071008]  tick_setup_device+0x70/0x1a0
[    0.071040]  tick_check_new_device+0xc0/0x110
[    0.071066]  clockevents_register_device+0x74/0x1c0
[    0.071090]  clockevents_config_and_register+0x2c/0x3c
[    0.071114]  arch_timer_starting_cpu+0x170/0x470
[    0.071147]  cpuhp_invoke_callback+0x104/0x20c
[    0.071180]  cpuhp_invoke_callback_range+0x70/0xf0
[    0.071205]  notify_cpu_starting+0xac/0xcc
[    0.071229]  secondary_start_kernel+0xe4/0x154
[    0.071259]  __secondary_switched+0xa0/0xa4
[    0.071297] ---[ end trace 0000000000000000 ]---
[    0.071328] b1:	ffffa1f27323b890
[    0.071339] b2:	ffffa1f27323b890
[    0.071348] b3:	0
[    0.071356] nbits:	256
[    0.071366] start:	0
[    0.071374] off:	0
[    0.071383] Bitmap: parameters check failed
[    0.071390] include/linux/bitmap.h [419]: bitmap_equal

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7205f76f8d10..7b2da8ef09ef 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -255,7 +255,7 @@ static void tick_setup_device(struct tick_device *td,
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpumask_equal(newdev->cpumask, cpumask))
+	if (newdev->cpumask != cpumask && !cpumask_equal(newdev->cpumask, cpumask))
 		irq_set_affinity(newdev->irq, cpumask);
 
 	/*
-- 
2.34.1

