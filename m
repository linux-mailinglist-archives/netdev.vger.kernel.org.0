Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDA3578AE7
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiGRTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiGRT3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:12 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6D9DF16;
        Mon, 18 Jul 2022 12:28:58 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c24so4029697qkm.4;
        Mon, 18 Jul 2022 12:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RIK4clDwX1oEMjN7pszaNKOSN2c//m8ehQ85KvlfQJc=;
        b=lNlO9SN3GGquIrZKMvt9zNOWmROiQ7UKGluxoJ/6490SfH4l3ZFvvrQ5XQ1qO64f2W
         p+I82uCQ8ZvuMZH+fAnQobCtCoq0Pxx28ZFgroRR13TygKFuozWxlJ/fBsXMsFi7JF8j
         LslOfWo/Dy/F6Ir4B6EskXMCoRMKBE9TwZvII3lNY3HkD0b5xpWqgQo6jfTqyMEE9GjF
         krBbndqao3O5qYyeZ+ps1kb1QUfD4EBcW10RtUjMZnVw3PPOlBGTUXkNXWRiSQp+594Y
         nQRk9aoZ3fTiFdlQFLY2WCbpyvmZnPd+Gmd7tWwjC5cucyR0Eq7BkmeA3NQwpHGdiKoM
         400g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIK4clDwX1oEMjN7pszaNKOSN2c//m8ehQ85KvlfQJc=;
        b=579E0dGF+dgD8naDl20afHk9yX8ej94OmBI4vpL8x7NCxfeuZik/2uZkKQTuciIjU5
         42BhHANdJh12Tglpee6m2egVaYmhUcePEzwR7s+fIaZTMjlwAsOpy3yrsswe5z79lPE+
         yigYQvsgdKFwEGV79gNcATPAvc6qK7TOHwhWSa3dUFCHbS5RBqrUhosVI1qrsBNXrmu7
         HMtzpNmT1vJoy6ehgJMTT6xhx9vhY96wPXSITJhFSxBnN3lqnBa7wNbkHFwpWad2Km5l
         YQRC6Hh46qv3EtT1Nn+ioDJL0sD4uNJ90YnaybSzHtIbBNtEKE9n+ZCodo/Guu3EUEJr
         uAMg==
X-Gm-Message-State: AJIora9dNT99rOS5ito2Msf370F5brNuiGhC+p3cqiBUdBxX0xYZ2x5Y
        +ESh4ypzvlOpqVi8vV+RKSMaszXpBa82nw==
X-Google-Smtp-Source: AGRyM1tudjg+bwULkYNm5Rqfm5wd3D6Bva3YUzb4kaoYEWEhL+2Z1rueeD9ZkF0QCclQf/uBzBI+zw==
X-Received: by 2002:a05:620a:4725:b0:6b5:f6a9:950e with SMTP id bs37-20020a05620a472500b006b5f6a9950emr2013188qkb.464.1658172536990;
        Mon, 18 Jul 2022 12:28:56 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id dm53-20020a05620a1d7500b006b4880b08a9sm12668183qkb.88.2022.07.18.12.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:56 -0700 (PDT)
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
Subject: [PATCH 09/16] irq: don't copy cpu affinity mask if source is equal to destination
Date:   Mon, 18 Jul 2022 12:28:37 -0700
Message-Id: <20220718192844.1805158-10-yury.norov@gmail.com>
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

irq_do_set_affinity() may be called with
	mask == irq_data_to_desc()->irq_common_data.affinity

Copying in that case is useless.

Caught with CONFIG_DEBUG_BITMAP:
[    1.089177]  __bitmap_check_params+0x144/0x250
[    1.089238]  irq_do_set_affinity+0x120/0x470
[    1.089298]  irq_startup+0x140/0x16c
[    1.089350]  __setup_irq+0x668/0x760
[    1.089402]  request_threaded_irq+0xe8/0x1b0
[    1.089474]  vp_find_vqs_msix+0x270/0x410
[    1.089532]  vp_find_vqs+0x48/0x1b4
[    1.089584]  vp_modern_find_vqs+0x1c/0x70
[    1.089641]  init_vq+0x2dc/0x34c
[    1.089690]  virtblk_probe+0xdc/0x710
[    1.089745]  virtio_dev_probe+0x19c/0x270
[    1.089802]  really_probe.part.0+0x9c/0x2ac
[    1.089863]  __driver_probe_device+0x98/0x144
[    1.089923]  driver_probe_device+0xac/0x140
[    1.089985]  __driver_attach+0xf8/0x1a0
[    1.090047]  bus_for_each_dev+0x70/0xd0
[    1.090101]  driver_attach+0x24/0x30
[    1.090153]  bus_add_driver+0x150/0x200
[    1.090208]  driver_register+0x78/0x130
[    1.090266]  register_virtio_driver+0x28/0x40
[    1.090329]  virtio_blk_init+0x68/0xa4
[    1.090400]  do_one_initcall+0x50/0x1c0
[    1.090471]  kernel_init_freeable+0x208/0x28c
[    1.090538]  kernel_init+0x28/0x13c
[    1.090590]  ret_from_fork+0x10/0x20
[    1.090642] ---[ end trace 0000000000000000 ]---
[    1.090705] b1:	ffff2ec742b85e18
[    1.090710] b2:	ffff2ec742b85e18
[    1.090715] b3:	0
[    1.090719] nbits:	256
[    1.090723] start:	0
[    1.090727] off:	0

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/irq/manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c396319d5ac..f9c1b21584ec 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -284,7 +284,8 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 	case IRQ_SET_MASK_OK_DONE:
-		cpumask_copy(desc->irq_common_data.affinity, mask);
+		if (desc->irq_common_data.affinity != mask)
+			cpumask_copy(desc->irq_common_data.affinity, mask);
 		fallthrough;
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_validate_effective_affinity(data);
-- 
2.34.1

