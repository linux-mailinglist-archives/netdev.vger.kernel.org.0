Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18126578AD0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiGRT3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbiGRT2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:52 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5081D2BFE;
        Mon, 18 Jul 2022 12:28:51 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id bz13so3157863qtb.7;
        Mon, 18 Jul 2022 12:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=h/b9Gor8OmaVbqlus0N8Yerswqy364XPSWWiuokjuPU=;
        b=fqFJufaEGeNpfSwDeHLXACT8OnWWXz+SS1j38SVvv2XI3V7V8WDZtxIfdvIaKQ8y9v
         0B0WY2lTYT/i7+LGAA/Ip2Q7u/fJdoSJt/07tIAob70ImqR7TtZlTUPoT1LuMgFcuWY4
         7HFka6L2jlYH/h5SMQBpAZF9w4mMJC5VPkP+4naKoLuGj5PEwF6S3Vgsnqe9/5kDZX5n
         E1qaAdoAy7EOEd3ji4eGl8J7TIvZC5UE2R5Le3yIwidlKTaWO/goPl8ml+dCO0JT7Ivy
         7rMLL+xDqIc/xTUV4ajY3ZNx4vpyBfXc91TeNvsl4Lz9YhlMBkra7r0yzMzayL5h8PUk
         nvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h/b9Gor8OmaVbqlus0N8Yerswqy364XPSWWiuokjuPU=;
        b=H1IGxrZocn1L1esbYq2CGQZz58XNJecCBmV2ErVkRaobHnabTvabDSKGDxpXRAyOZ0
         +VcCtN9JmReKwliaFj5JUdqpfoaB9Y1IIr2fQu+d8xw0OovdYwATLJSFJlwkN6RJnt0n
         oV7WBh3YpQ30WtSP/bSfY8su9IpHLtwUtS/OAOkAhzjwaZKte4onZG1Ui27ko1B/j4pP
         OMAy2yM6PxlrEwmpoghmDqXZdvGszUpEGoXQ5lHz5fi8uclZFHTId2ZOLq42efOQfKXr
         lOCjNjqnOOSkiKfXyhcVS0iULhEarcedj95aTAPY+QoFN/dQ5g8ilhbhbSBRVmBncyse
         KmnQ==
X-Gm-Message-State: AJIora94bnyIKu0vOi4OaLrgFIxMwJ47ZcSk11ZFA6jV+HMA1TDajSSF
        yiRqIltMQFVCIEpNpnO1Qdx7cJH7psfVOA==
X-Google-Smtp-Source: AGRyM1uaGs+CAqWH8avpKeUoD3vmIQkUBNKvCB+RRyAV1xF9WVdeoxP71d/HveDQuxFH6mXJfEXYcA==
X-Received: by 2002:a05:622a:198b:b0:31e:ec25:8ead with SMTP id u11-20020a05622a198b00b0031eec258eadmr5759733qtc.423.1658172530262;
        Mon, 18 Jul 2022 12:28:50 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id x27-20020a05620a0b5b00b006b5e43466ebsm4634117qkg.59.2022.07.18.12.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:49 -0700 (PDT)
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
Subject: [PATCH 03/16] lib/test_bitmap: don't test bitmap_set if nbits == 0
Date:   Mon, 18 Jul 2022 12:28:31 -0700
Message-Id: <20220718192844.1805158-4-yury.norov@gmail.com>
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

Don't test bitmap_set(bitmap, start, 0) as it's useless, most probably
a sign of error in real code, and makes CONFIG_DEBUG_BITMAP barking.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 98754ff9fe68..2a70393ac011 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -622,7 +622,7 @@ static void noinline __init test_mem_optimisations(void)
 	unsigned int start, nbits;
 
 	for (start = 0; start < 1024; start += 8) {
-		for (nbits = 0; nbits < 1024 - start; nbits += 8) {
+		for (nbits = 1; nbits < 1024 - start; nbits += 8) {
 			memset(bmap1, 0x5a, sizeof(bmap1));
 			memset(bmap2, 0x5a, sizeof(bmap2));
 
-- 
2.34.1

