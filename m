Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB63578AC5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbiGRT26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiGRT2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:54 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA983FEB;
        Mon, 18 Jul 2022 12:28:53 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id b25so8800394qka.11;
        Mon, 18 Jul 2022 12:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fSIJ7a7j2AX31WFosI1tLZd0prS7r7q6CFeV8/OppVE=;
        b=VbkCt5PHj4oSczMa9BarPYV2CjxzDRvrtDRRMj4B07hzccBFOAfmYblYUUH9Ajgumv
         RKM4K28hzaiG92J/7vkuoCFu1rn9w8fhy0lWf6SIorEHqKyHwppnrzuULW+EmT6h7aZb
         iNnNyCpV5Al9CLDF5s+BHS+cuFK+7eXWgag89LdLI4R4kgeV2hbArCXUwMlgqtF2xWIm
         qfkeQzp0/+pXaxkZspiEkYN3yN4c8vfsqHzTwgjkQ3p2CVysWoVDuRXKrA2nXL5HlaIv
         LdBinorxw3H/YgC7eHfwweeumD20to6B5s4SYw9LVJdPLE0pFWEA8sn1G0OBVc/9tacU
         f7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fSIJ7a7j2AX31WFosI1tLZd0prS7r7q6CFeV8/OppVE=;
        b=cD5ZeosHnFTEjr1F4y9szPkWBBod684uIM96g7mjDpMvrk+/K5W2ZQXtUIJfZY2G23
         4WgWkXp1L7PTE6ZfJbfvTjaeSw40xIiqE6xPZJi5S2SDaDlkwB3hbsOF+rFzSU/S/+53
         VGca8LhJVTk+1lmDwU712ED4EBIb/0jZNcuM6AgONNw5DusUqCJrZEz8jZBYZaoNybgG
         V8KmHFl31LjeFUEasX+4iOoEhnG8FRZ4XGx9UE0B8KGMLmWIHXBc3ppKapL6uaLTvsOr
         GTSV30b1nl2kt9d6g1qJiqd6qECLX/0fl9DPdb93nX+Wv+iL6aYtwTao/krYvPpEvPxg
         T4Rw==
X-Gm-Message-State: AJIora+UWv+ZedSAh3kN4lSqQIAlrfbSrzzpWp37/O5tNkyH8x0Edv9K
        k2NieK7xPmrBbo1nrYTGAX2hRHhyw1SsKw==
X-Google-Smtp-Source: AGRyM1vV0SLlM81qvktCdvHe8wlRlm35TgOxVMvgml/1hdumCxKzVqNhVheVD3VDTLe5gZR7GC4mqw==
X-Received: by 2002:ae9:e402:0:b0:6a7:86a3:752e with SMTP id q2-20020ae9e402000000b006a786a3752emr18219422qkc.300.1658172532712;
        Mon, 18 Jul 2022 12:28:52 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b006a6d20386f6sm13557144qkn.42.2022.07.18.12.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:52 -0700 (PDT)
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
Subject: [PATCH 05/16] lib/test_bitmap: disable compile-time test if DEBUG_BITMAP() is enabled
Date:   Mon, 18 Jul 2022 12:28:33 -0700
Message-Id: <20220718192844.1805158-6-yury.norov@gmail.com>
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

CONFIG_DEBUG_BITMAP, when enabled, injects __bitmap_check_params()
into bitmap functions. It prevents compiler from compile-time
optimizations, which makes corresponding test fail.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index bc48d992d10d..8bd279a7633f 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -877,6 +877,7 @@ static void __init test_bitmap_print_buf(void)
 
 static void __init test_bitmap_const_eval(void)
 {
+#ifndef CONFIG_DEBUG_BITMAP
 	DECLARE_BITMAP(bitmap, BITS_PER_LONG);
 	unsigned long initvar = BIT(2);
 	unsigned long bitopvar = 0;
@@ -934,6 +935,7 @@ static void __init test_bitmap_const_eval(void)
 	/* ~BIT(25) */
 	BUILD_BUG_ON(!__builtin_constant_p(~var));
 	BUILD_BUG_ON(~var != ~BIT(25));
+#endif
 }
 
 static void __init selftest(void)
-- 
2.34.1

