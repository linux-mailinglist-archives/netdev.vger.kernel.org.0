Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4477578AD5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiGRTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiGRT3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:13 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66F76263;
        Mon, 18 Jul 2022 12:29:00 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id c24so4029775qkm.4;
        Mon, 18 Jul 2022 12:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=D0vGYuUrWK1A1pC+aGb2diJW4SXv6dDhykR2E3SvFc8=;
        b=acjdcKpDdV2PdvNi+eoEwihWKcpSrRAsrDHiFJG9tElETVBRpRl1BHIlBTcqTpJ1PZ
         dqPhoWLauRERrZA0j1cq0xNk0IkyjS+bk910OJd6v3ZC939j06bzpOv+oySvXXxzwccG
         DuquVnf7VDRuglTdL1A81oCQPyP9OiRPuTo9rV8rvvWPSirAXqZUVdJ9cVJF+N/tZAut
         cn4mvdBOyL7FeaLStoJT+VMKK5o0ToUzvTPwDDD4B5R4znOjfgPiLRfaP8jZoSwV2fdJ
         sN1KlbxFCs/ArEXTCRiHuBowwklPVPJUzv5nXSPFafZGnOR76aQqVOuKje8NqcNeZoVw
         N+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0vGYuUrWK1A1pC+aGb2diJW4SXv6dDhykR2E3SvFc8=;
        b=og/igHkWFYrWYeZz6vUsN6Pdr0D5z/e1KOxkdUYo6DWB+bdBTFUXXOihxAyekf8vOF
         P1A35YKN+9HI7Hd/SpAhGNd+lfFT/+0ZsGA1oRse/UfbOytoQNvS3q7XdPfq0p5ZRXLp
         rsZ/YrypKSy5pB8uBGBheq3N5vL98D8Aon8a+/9LgMJnmH6fB3oy/QYD/1+WfsVHrfPM
         KMIh7ZHZEsia2jX71oU9Ez6dt75XpHp31aENPTvJZV3R5YLPqd7Oot7V8FlF9q/ZCUeQ
         hp5UZk1KzMyud4GgalBHYC+z33IzrqM90WIH7Raedb28Im/IINmZfzx78nU92272hAA8
         KeEA==
X-Gm-Message-State: AJIora/4GaZwBYEP3zbBM4aCA+E75Cy8yAv+dsfDo967NsxhT3C88kmA
        lA6VGDptmtPOJ8DLdCNcq3lDtZAsJS6tAQ==
X-Google-Smtp-Source: AGRyM1sfjfCy0QR9NsI2tMcO46D+TGA9UPgSgzjARo5pB7cKyOwUWXXbOFws+xYx88TQYg8ZRSCfgg==
X-Received: by 2002:a37:648f:0:b0:6b5:ccd2:3ff9 with SMTP id y137-20020a37648f000000b006b5ccd23ff9mr11422805qkb.139.1658172539175;
        Mon, 18 Jul 2022 12:28:59 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id ez12-20020a05622a4c8c00b0031eb0bb5c3csm9878869qtb.28.2022.07.18.12.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:58 -0700 (PDT)
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
Subject: [PATCH 11/16] time: optimize tick_check_preferred()
Date:   Mon, 18 Jul 2022 12:28:39 -0700
Message-Id: <20220718192844.1805158-12-yury.norov@gmail.com>
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

tick_check_preferred() calls cpumask_equal() even if
curdev->cpumask == newdev->cpumask. Fix it.

Caught with CONFIG_DEBUG_BITMAP:
[    0.079109] Call trace:
[    0.079124]  __bitmap_check_params+0x144/0x250
[    0.079161]  tick_check_replacement+0x1a4/0x320
[    0.079203]  tick_check_new_device+0x50/0x110
[    0.079237]  clockevents_register_device+0x74/0x1c0
[    0.079268]  dummy_timer_starting_cpu+0x6c/0x80
[    0.079310]  cpuhp_invoke_callback+0x104/0x20c
[    0.079353]  cpuhp_invoke_callback_range+0x70/0xf0
[    0.079401]  notify_cpu_starting+0xac/0xcc
[    0.079434]  secondary_start_kernel+0xe4/0x154
[    0.079471]  __secondary_switched+0xa0/0xa4
[    0.079516] ---[ end trace 0000000000000000 ]---
[    0.079542] b1:	ffffbfec4703b890
[    0.079553] b2:	ffffbfec4703b890
[    0.079566] b3:	0
[    0.079576] nbits:	256
[    0.079588] start:	0
[    0.079598] off:	0
[    0.079609] Bitmap: parameters check failed
[    0.079619] include/linux/bitmap.h [419]: bitmap_equal

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/time/tick-common.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 46789356f856..fdd5ae1a074b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -316,9 +316,13 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 	 * Use the higher rated one, but prefer a CPU local device with a lower
 	 * rating than a non-CPU local device
 	 */
-	return !curdev ||
-		newdev->rating > curdev->rating ||
-	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
+	if (!curdev || newdev->rating > curdev->rating)
+		return true;
+
+	if (newdev->cpumask == curdev->cpumask)
+		return false;
+
+	return !cpumask_equal(curdev->cpumask, newdev->cpumask);
 }
 
 /*
-- 
2.34.1

