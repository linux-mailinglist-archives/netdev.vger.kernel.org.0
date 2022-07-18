Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A0578AC1
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiGRT3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiGRT2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:54 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D69ED5A;
        Mon, 18 Jul 2022 12:28:52 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o26so9561767qkl.6;
        Mon, 18 Jul 2022 12:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WuubJCN67Jl+OjN8nViAm+NVBqJ2ywJqSxExI1yjjeo=;
        b=Tj6uBzad4HGB6EL0M1yus7P2xl8seTebl3KEY60QiHYHkiZzGlnZJc4zmMQ715lBQb
         V+6rCjlFtE36SY7lmQBsjFybnyNA/OpYbPg+Hxm3taVetxQSzz05FbXjQEqoSn3tr68N
         fufksI4iYgEDgfiqAfDBwg7RDixJD5/BbGOR3iYboPjgzPCnwUY3I9q81BKlZDy93R5+
         TYLpPb/vjZhMTWj53wGRv+e2qfs4M6ZZ3ek9UJ68NbZRFgDae6SXyqs1nFFZVE0b4GJf
         TuETrm14lrx8VLkbDZWKHiMSYX1+sOP0ozMNOUt4xFlsRcKHdAtHqy1wiM2QBsaIJik6
         D9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WuubJCN67Jl+OjN8nViAm+NVBqJ2ywJqSxExI1yjjeo=;
        b=nArK0v2r1yode3l+iFyhdtsEdLmfZrSn8XAyJ9sCYe/FMI7ffT7RwcCycf8CWgMvW+
         Cccl9/e6vz2d1L5RWzv/0bSgkTf0Usg4WNyV0xwDjQE8Z2xUsBn+n8rS1xhHAzjxC3Ep
         UykOc9GPSR4nK12nX7hRclPMA1xhjaAk6G7ifkkiDpHbcI5kYR+VctcyPMBk/vVNbCmF
         RQXhxXTN3YEf6MD40e0+7wkeD7VfkpnTHUheGe00FqwBQmyyjMO1Xaf/UxySBpeish/D
         8zhEVvoasi8EYF56cFyl/n5EX3fWEdePoXRlFNOJSk22TCPiKigmOoX9TRNySbTnjh8i
         hTjw==
X-Gm-Message-State: AJIora8CRPc4VGUOPscqLbrYugdFTVnlML7PKI4zrO37yMZ9ptLTb4of
        bZk3mxBeHERn/Y+QD72Hl2/T6M7dWh+yoQ==
X-Google-Smtp-Source: AGRyM1utJxde5Ak8ZdjBXmB+6RTWRe3dLKOIt69li9dLPfU8C1nB6Z6dKZAjbNpuMZO2dr2cItKKhg==
X-Received: by 2002:a37:b346:0:b0:6b2:8e4c:690c with SMTP id c67-20020a37b346000000b006b28e4c690cmr18431369qkf.654.1658172531539;
        Mon, 18 Jul 2022 12:28:51 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id r2-20020ac87ee2000000b0031ed590433bsm8607338qtc.78.2022.07.18.12.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:51 -0700 (PDT)
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
Subject: [PATCH 04/16] lib/test_bitmap: test test_bitmap_arr{32,64} starting from nbits == 1
Date:   Mon, 18 Jul 2022 12:28:32 -0700
Message-Id: <20220718192844.1805158-5-yury.norov@gmail.com>
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

nbits == 0 is useless. In a real code it's most probably a sign of
error, and it makes CONFIG_DEBUG_BITMAP barking.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 2a70393ac011..bc48d992d10d 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -567,7 +567,7 @@ static void __init test_bitmap_arr32(void)
 
 	memset(arr, 0xa5, sizeof(arr));
 
-	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
+	for (nbits = 1; nbits < EXP1_IN_BITS; ++nbits) {
 		bitmap_to_arr32(arr, exp1, nbits);
 		bitmap_from_arr32(bmap2, arr, nbits);
 		expect_eq_bitmap(bmap2, exp1, nbits);
@@ -593,7 +593,7 @@ static void __init test_bitmap_arr64(void)
 
 	memset(arr, 0xa5, sizeof(arr));
 
-	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
+	for (nbits = 1; nbits < EXP1_IN_BITS; ++nbits) {
 		memset(bmap2, 0xff, sizeof(arr));
 		bitmap_to_arr64(arr, exp1, nbits);
 		bitmap_from_arr64(bmap2, arr, nbits);
-- 
2.34.1

