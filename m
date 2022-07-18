Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A6578AB7
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiGRT2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiGRT2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:50 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE1AD5A;
        Mon, 18 Jul 2022 12:28:48 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r21so8832283qtn.11;
        Mon, 18 Jul 2022 12:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OWEXlSbAfAwywlnXDil6CYNW0FSVu9hGAT+NA18MHDQ=;
        b=EdkRpor4TlGyKnTLZL6ybUgdj9y+RP1U2qMx+qo2WRbae6kczgkFok4CRrhKnmECjE
         BkNDZq/325XPSSByV3oQf/TzCJs5c0+pyMopjHMn+DloZPH4YCia6agETBzkZ9O2R63r
         Sfzc43oRP8KkOnmqDB65zJIgv4o3qXdvG+V6aFbNWCQKf1EsDN37x+1WeR3Nt4oMt769
         2KPNHOqvnz2G/wmJSU5SWhdVktHz7N8FZU6k1/q5lT1ljCiNPCjqMSlIUzNrNatzQ0XQ
         lFN5p4uVklAw74PmFXTeVo1V90esQebTmWviZEGmWjkKyWhJEsnO56dg/6lR7uMiRsY9
         6e6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OWEXlSbAfAwywlnXDil6CYNW0FSVu9hGAT+NA18MHDQ=;
        b=xNIInG5c2bWBb6+jh8vjLB9TXOaFJCqOShYcUtaShzC8kNkCVfSUZYaF6EWt0mEpCC
         FGxgi09S3hWEKX9/1Y+g7eiZgVDeDBBV+CcSTpQeqcuZO6lyaF26Z5LhS1lprb5InFcS
         MtvUaaUkR92xJCSM+JpK/WcMp6p6gEnH2DviyJQkST0W+6rNfIp4ULcMILLmXNdniGCw
         cMrP4NcaG6kY4oqW+wipyyVf2hBu1G/pf+DwtOh6Le3ZEbSxTlGRGOJpzsfZzvM7AFBp
         S1mJ4ZoMh5i5AylPXKBxbBPqvQfQXjgtccovPYqQkL3zQYkvpHxQU2K+NecEzMBrA24C
         lQPQ==
X-Gm-Message-State: AJIora+87SjU8KiEY+5e8rwMGYuXoOXaOg8241qpdvaEzeDKgTKVxTSB
        SI7WBLAszBuvethKqyyYkdSTeZYYNxLkbg==
X-Google-Smtp-Source: AGRyM1vqDidU2mj3mjL1nyFt/o9b/6DrRe9boOZKOh5cfsbupafmIWKyPwSd3R9NQ0P+as9cY9uNww==
X-Received: by 2002:a05:622a:58d:b0:317:ca0d:91a5 with SMTP id c13-20020a05622a058d00b00317ca0d91a5mr21815757qtb.601.1658172526705;
        Mon, 18 Jul 2022 12:28:46 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id q9-20020ac84509000000b0031eb3af3ffesm9650206qtn.52.2022.07.18.12.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:46 -0700 (PDT)
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
Subject: [PATCH 00/16] Introduce DEBUG_BITMAP config option and bitmap_check_params()
Date:   Mon, 18 Jul 2022 12:28:28 -0700
Message-Id: <20220718192844.1805158-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Bitmap functions are often a part of hot paths, and we can't put argument
sanity checks inside them. Sometimes wrong parameters combination cause
bug reports that are pretty hard to investigate:
https://lore.kernel.org/linux-mm/YsbpTNmDaam8pl+f@xsang-OptiPlex-9020/

And sometimes we can optimize caller code. For example, to avoid copying
of bitmap if source and destination are the same.

It's quite tricky to detect such places unless we've covered all bitmap
API calls with the parameters checker.

This series:
 - introduces bitmap_check_params() with a couple of common-used wrappers;
 - clears all bitmap warnings found for x86_64, arm64 and powerpc64 in
   boot test.

Yury Norov (16):
  lib/bitmap: add bitmap_check_params()
  lib/bitmap: don't call bitmap_set() with len == 0
  lib/test_bitmap: don't test bitmap_set if nbits == 0
  lib/test_bitmap: test test_bitmap_arr{32,64} starting from nbits == 1
  lib/test_bitmap: disable compile-time test if DEBUG_BITMAP() is
    enabled
  lib/test_bitmap: delete meaningless test for bitmap_cut
  smp: optimize smp_call_function_many_cond()
  smp: optimize smp_call_function_many_cond() for more
  irq: don't copy cpu affinity mask if source is equal to destination
  sched: optimize __set_cpus_allowed_ptr_locked()
  time: optimize tick_check_preferred()
  time: optimize tick_check_percpu()
  time: optimize tick_setup_device()
  mm/percpu: optimize pcpu_alloc_area()
  sched/topology: optimize topology_span_sane()
  lib: create CONFIG_DEBUG_BITMAP parameter

 include/linux/bitmap.h    |  95 +++++++++++++++++++++++++++
 kernel/irq/manage.c       |   3 +-
 kernel/sched/core.c       |   3 +-
 kernel/sched/topology.c   |  10 ++-
 kernel/smp.c              |  35 ++++++++--
 kernel/time/tick-common.c |  18 ++++--
 lib/Kconfig.debug         |   7 ++
 lib/bitmap.c              | 132 ++++++++++++++++++++++++++++++++++----
 lib/test_bitmap.c         |  12 ++--
 mm/percpu.c               |   3 +-
 10 files changed, 281 insertions(+), 37 deletions(-)

-- 
2.34.1

