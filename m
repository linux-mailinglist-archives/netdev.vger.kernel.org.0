Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0EE578AB9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiGRT2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiGRT2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:51 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F4125D3;
        Mon, 18 Jul 2022 12:28:50 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id e16so5626142qka.5;
        Mon, 18 Jul 2022 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mds6TiJm2i/ciGRewHyQeRgrE3/eBxBJskgGjRCv8jE=;
        b=K+OO8GlSGfFoQ4u6Xgs/Jnqm5tx2JRuUl5xIk00RjcP+K/hkgRPZinOZ2EttuW5q5q
         hvFsBf0zmTfoBNpetZrWb+DCskXNBQW9Wr6HHqY575HwOkPBTVw4HS1BOky1KOrpEXOd
         tmKdebqLU2VTtvGMLQNsyBADet1rY6Vweu3mXy+o5kaVdj+jOz5T0mr49UwAGgGr8XLe
         3JUtC9totttIeVL+NIKb0V3FiTtHU0zLxxZcy7PTaZsjaTiDd2H+U0uKvVz7FW8SLQbu
         DM4pMj5FgVTxaD/374QNS1ulsCavtIMeCQ9ntw6jXlM51lUnIbkhUR+mDJzqNU9A/tqz
         2SoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mds6TiJm2i/ciGRewHyQeRgrE3/eBxBJskgGjRCv8jE=;
        b=c7ZWtbA9TDGQ75fVfWDU8r7rrJy+9I9pDimY0wD9nVzps8ZXPM4g0/QUkxjfX3/z97
         Ax0aO8Y/9WNe4+dFxTSD9BedoTjjoSWYQ5cYjlVZHrv4hWdiD31/IB3MzeS+Wjr3jaH7
         fXM/UuMsoQN0NOE8UREanC4JmFqfQJJ+NS72S09iQgHI3DnCsJyg9LtBBnEUI1rjdjoQ
         uy75CqD4ZzppFSNDxoPXalnPvQQpP5qujqz8pWEAZVY6ZK4zS3JRpKT1k5xZ2NEeJlxK
         OfzIMkhefswYYeQngx6K319npTu8k/egvJCufw97rh+Ciggqz1iv0ehKq1sBA3/yRdH1
         AI0w==
X-Gm-Message-State: AJIora+I+qWcbWtvXUZDyqCea7wJRh2qKo2zUAh1ZwdS+wfjaK7c/S6O
        Xpdw3xjJpFTCx5LbpifQWGRBW9UgsvUJDw==
X-Google-Smtp-Source: AGRyM1sjmRb0z/jF/I9QRHkB+Qs97iyonIxrkCMHXwc46LvQcGE4P1mvDuBHw7JATaMF3VYkVo9uoA==
X-Received: by 2002:a37:8245:0:b0:6b5:9078:267 with SMTP id e66-20020a378245000000b006b590780267mr17879707qkd.684.1658172529164;
        Mon, 18 Jul 2022 12:28:49 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id cc12-20020a05622a410c00b00316a384447fsm7028960qtb.16.2022.07.18.12.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:48 -0700 (PDT)
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
Subject: [PATCH 02/16] lib/bitmap: don't call bitmap_set() with len == 0
Date:   Mon, 18 Jul 2022 12:28:30 -0700
Message-Id: <20220718192844.1805158-3-yury.norov@gmail.com>
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

bitmap_parselist() format allows passing 0-length regions, but because
len == 0 is not covered by small_const_nbits() macro, we have to call
__bitmap_set() and do some prologue calculations just for nothing.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/bitmap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index cd4dd848ea6a..790df2ea02df 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -712,10 +712,13 @@ struct region {
 
 static void bitmap_set_region(const struct region *r, unsigned long *bitmap)
 {
-	unsigned int start;
+	unsigned int start, len;
 
-	for (start = r->start; start <= r->end; start += r->group_len)
-		bitmap_set(bitmap, start, min(r->end - start + 1, r->off));
+	for (start = r->start; start <= r->end; start += r->group_len) {
+		len = min(r->end - start + 1, r->off);
+		if (len > 0)
+			bitmap_set(bitmap, start, len);
+	}
 }
 
 static int bitmap_check_region(const struct region *r)
-- 
2.34.1

