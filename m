Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01D578AE2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiGRTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiGRT3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:14 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0432D1E3;
        Mon, 18 Jul 2022 12:29:04 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id m6so9543539qvq.10;
        Mon, 18 Jul 2022 12:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/K1YhC0xN+k7O2FGj/yOUKehgh1HnqMHevQj0FQmavI=;
        b=hncdckdd/8keGq0BbMkUSkVvo58eaSfk46icZhjcfux7VapB1d8lOZsIlqh8gYAlwO
         nsH6TNRxQKop1KFXKAjUK6jXGpI96ZhzGYzEb1l58Uuid0BejJtLScjUXd1FwD7d6d0I
         n6nBpJsBMCWPJZOY2isxybjgVNgOUtIwy5syFw6dhjVkH48EFPjJXnsXMjILmWWh6aNt
         1XjXQ+KmT1tei8OVv0kOBxiaSSBAGf1jRYjjXWTW/jEj/bm8gP4G3KDncFs30f51O1n9
         KoibE09XlnBMUE30LzuwHeutbdP4Gw0vPBuJAXfM44toJn9n4BYblu9g3pXR4SHa5Cz4
         j6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/K1YhC0xN+k7O2FGj/yOUKehgh1HnqMHevQj0FQmavI=;
        b=1hsppSoi2ihKjmjPsCy+fDCVQq+lzVFsc/JfIYZ/HJn7JWk82VTaA14TsWON25hg18
         WVPYJNICoIFtcmTuyxVQ8prv/pwuWkBWckx26KBsjG316GtlXK3jFetOHihXpHIUcZF3
         nHz6FbE/H29W2E0VlmV2RP1+V2F2wGkHRlunDjHofHTuFb12VoZ4biK+xPH1R02Eu2mo
         0Km8k6s/OY5sHoAefCSUav2wG7qUd36p7copYVcasv1cuzmLgbBI4g41HMkfHaGcyPYK
         BFkBRGLmhQw4YjlByy+CldPOuzQASabNxl0FBluyvlMxp04cY0OX0t2QS8QWJ5eL/fmJ
         7Mpw==
X-Gm-Message-State: AJIora+zmkzVeUO+3yuEbLkjClwFriNLYb7Jum0UjD3uf9gjsqRGXsOx
        /s90bE6B4IaeyOHa0bMAGXRcKVLn7thrDw==
X-Google-Smtp-Source: AGRyM1uDAtG39PkyBUTwcaTq2/uDHYY4DcIItWFReB0uOGieqEEzLgaz94Wt8f3sFC0ByQPjoqZW6g==
X-Received: by 2002:a05:6214:226d:b0:473:339e:3264 with SMTP id gs13-20020a056214226d00b00473339e3264mr22107594qvb.41.1658172543484;
        Mon, 18 Jul 2022 12:29:03 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id bb31-20020a05622a1b1f00b0031ef21aec36sm2216383qtb.32.2022.07.18.12.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:29:03 -0700 (PDT)
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
Subject: [PATCH 14/16] mm/percpu: optimize pcpu_alloc_area()
Date:   Mon, 18 Jul 2022 12:28:42 -0700
Message-Id: <20220718192844.1805158-15-yury.norov@gmail.com>
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

Don't call bitmap_clear() to clear 0 bits.

bitmap_clear() can handle 0-length requests properly, but it's not covered
with static optimizations, and falls to __bitmap_set(). So we are paying a
function call + prologue work cost just for nothing.

Caught with CONFIG_DEBUG_BITMAP:
[   45.571799]  <TASK>
[   45.571801]  pcpu_alloc_area+0x194/0x340
[   45.571806]  pcpu_alloc+0x2fb/0x8b0
[   45.571811]  ? kmem_cache_alloc_trace+0x177/0x2a0
[   45.571815]  __percpu_counter_init+0x22/0xa0
[   45.571819]  fprop_local_init_percpu+0x14/0x30
[   45.571823]  wb_get_create+0x15d/0x5f0
[   45.571828]  cleanup_offline_cgwb+0x73/0x210
[   45.571831]  cleanup_offline_cgwbs_workfn+0xcf/0x200
[   45.571835]  process_one_work+0x1e5/0x3b0
[   45.571839]  worker_thread+0x50/0x3a0
[   45.571843]  ? rescuer_thread+0x390/0x390
[   45.571846]  kthread+0xe8/0x110
[   45.571849]  ? kthread_complete_and_exit+0x20/0x20
[   45.571853]  ret_from_fork+0x22/0x30
[   45.571858]  </TASK>
[   45.571859] ---[ end trace 0000000000000000 ]---
[   45.571860] b1:		ffffa8d5002e1000
[   45.571861] b2:		0
[   45.571861] b3:		0
[   45.571862] nbits:	44638
[   45.571863] start:	44638
[   45.571864] off:	0
[   45.571864] percpu: Bitmap: parameters check failed
[   45.571865] percpu: include/linux/bitmap.h [538]: bitmap_clear

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 mm/percpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3633eeefaa0d..f720f7c36b91 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1239,7 +1239,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
 
 	/* update boundary map */
 	set_bit(bit_off, chunk->bound_map);
-	bitmap_clear(chunk->bound_map, bit_off + 1, alloc_bits - 1);
+	if (alloc_bits > 1)
+		bitmap_clear(chunk->bound_map, bit_off + 1, alloc_bits - 1);
 	set_bit(bit_off + alloc_bits, chunk->bound_map);
 
 	chunk->free_bytes -= alloc_bits * PCPU_MIN_ALLOC_SIZE;
-- 
2.34.1

